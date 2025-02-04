set define off;

CREATE OR REPLACE TRIGGER WEBI2MS.osi_feedback_a_i_send
    after insert
    on t_osi_feedback
    referencing new as new old as old
    for each row
declare
    v_email_to               t_core_config.setting%type;
    v_username               varchar2(100);
    v_object_type_desc       varchar2(400);
    v_object_title           varchar2(400);
    v_object_id              varchar2(400);
    v_page_desc              varchar2(400);
    v_user_email_address     varchar2(400);
    v_msg                    varchar2(4500);
    v_status                 varchar2(400);
    v_crlf                   varchar2(10)                 := chr(11) || chr(13);
    v_allowed_addresses      varchar2(200);
    v_have_allowed_address   boolean;
    v_url                    varchar2(4000) := core_util.get_config('CORE.BASE_URL');
    v_unit_sid               varchar2(20);
begin
     ---Get Helpdesk Email Address---
     v_email_to := core_util.get_config('OSI.FEEDBACK_EMAIL_ADDRESS');

     ---Get the sending personnels name---
     v_username := osi_personnel.get_name(:new.personnel);

     if (:new.obj is not null) then

       ---Get Object Type---
       v_object_type_desc := osi_object.get_objtype_desc(core_obj.get_objtype(:new.obj));

       ---Get the title of the object in question---
       v_object_title := core_obj.get_tagline(:new.obj);

       ---Get the ID of the object in question---
       v_object_id := osi_object.get_id(:new.obj, null);
       
       if v_object_id is null or v_object_id='' then
       
         v_object_id := '(not found)';
         
       end if;
       
     else

       ---Get Object Type---
       v_object_type_desc := '(not applicable)';

       ---Get the title of the object in question---
       v_object_title := '(not applicable)';

       ---Get the ID of the object in question---
       v_object_id := '(not applicable)';

     end if;

     ---See if the user has a primary email address---
     begin
          v_have_allowed_address := false;
 
          select value into v_user_email_address
            from t_osi_personnel_contact opc, t_osi_reference tor
             where opc.type = tor.sid and tor.code = 'EMLP' and opc.personnel = :new.personnel;

          v_allowed_addresses := core_list.convert_to_list(core_util.get_config('OSI.NOTIF_EMAIL_ALLOW_ADDRESSES'), ',');

          ---Check to make sure they are allowed to send with this email address (if not, just default to NO_REPLY address)---
          for cnt in 1 .. core_list.count_list_elements(v_allowed_addresses)
          loop
              if (substr(v_user_email_address,instr(v_user_email_address, '@') + 1,length(v_user_email_address)) = core_list.get_list_element(v_allowed_addresses, cnt)) then

                ---Found it!---
                v_have_allowed_address := true;
                exit;

              end if;

          end loop;

          if (v_have_allowed_address = false) then

            return;

          end if;

     exception
         when no_data_found then
             ---If user has no primary email address, use the NO_REPLY address---
             --v_user_email_address := core_util.get_config('OSI.NOTIF_SNDR');
             return;
     end;

     ---Probably shouldn't need the IF block, but better safe than sorry..---
     if (v_have_allowed_address = true) then
 
       ---Get Page Description---
       select page_name || ' Page' into v_page_desc
          from apex_030200.apex_application_pages
         where page_id = :new.page_id and application_id = 100;

       ---Create Message---
       v_unit_sid := osi_personnel.get_current_unit(:new.personnel);
       v_msg := '<p style="font-family:Courier New;"><table border=0 style="font-family:Courier New;">';
       v_msg := v_msg || '<tr><td align=right valign=top>Personnel / User:&nbsp;</td><td>' || '<a href="' || v_url  || :new.personnel || '">' || v_username || '</a></td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;User Unit:&nbsp;</td><td><a href="' || v_url || v_unit_sid || '">' ||  osi_unit.get_name(v_unit_sid) || '</a></td></tr>';
       
       for a in (select REGEXP_REPLACE(REGEXP_REPLACE(c.value,
                 '([[:digit:]]{3})([[:digit:]]{3})([[:digit:]]{4})',
                 '(\1) \2-\3'),'([[:digit:]]{3})([[:digit:]]{4})',
                 '\1-\2') as PhoneNumber,r.code from t_osi_personnel_contact c,t_osi_reference r where personnel=:new.personnel and r.sid=c.type and r.code in ('OFFP','DSNP'))
       loop
           if a.code='OFFP' then

             v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Phone:&nbsp;</td><td>' ||  a.PhoneNumber || '</td></tr>';

           end if;
           
           if a.code='DSNP' then
  
             v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DSN:&nbsp;</td><td>' ||  a.PhoneNumber || '</td></tr>';
           
           end if;
                    
       end loop;
              
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date/Time:&nbsp;</td><td>' || to_char(sysdate, 'Dy DD-Mon-YYYY HH24:MI:SS') || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>Page Desctiption:&nbsp;</td><td>' || v_page_desc || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Object Type:&nbsp;</td><td>' || v_object_type_desc || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Object ID:&nbsp;</td><td>' || '<a href="' || v_url || :new.obj || '">' || v_object_id || '</a>' || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;Object Title:&nbsp;</td><td>' || v_object_title || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;User Message:&nbsp;</td><td>' || replace(replace(:new.user_text,chr(10),'<BR>'),chr(13),'') || '</td></tr>';
       v_msg := v_msg || '</table></p>';

       ---Send email---
       v_status := core_util.email_send(v_email_to, 'Help Desk Ticket', v_msg, v_user_email_address, null, null, null, 'text/html;');

       ---Should we do something with the status output?---

     end if;

exception
    when others then
        raise;

end osi_feedback_a_i_send;
/