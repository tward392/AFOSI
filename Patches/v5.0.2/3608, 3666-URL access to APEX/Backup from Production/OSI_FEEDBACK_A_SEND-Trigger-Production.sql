CREATE OR REPLACE TRIGGER WEBI2MS."OSI_FEEDBACK_A_I_SEND" 
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
    --v_user_text varchar2(4000);
    v_user_email_address     varchar2(400);
    v_msg                    varchar2(4500);
    v_status                 varchar2(400);
    v_crlf                   varchar2(10)                 := chr(11) || chr(13);
    v_allowed_addresses      varchar2(200);
    v_have_allowed_address   boolean;
begin
    --Get Helpdesk Email Address
    v_email_to := core_util.get_config('OSI.FEEDBACK_EMAIL_ADDRESS');
    --Get the sending personnels name
    v_username := osi_personnel.get_name(:new.personnel);

    if (:new.obj is not null) then
        --Get Object Type
        v_object_type_desc := osi_object.get_objtype_desc(core_obj.get_objtype(:new.obj));
        --Get the title of the object in question
        v_object_title := core_obj.get_tagline(:new.obj);
        --Get the ID of the object in question
        v_object_id := osi_object.get_id(:new.obj, null);
    else
        --Get Object Type
        v_object_type_desc := '(not applicable)';
        --Get the title of the object in question
        v_object_title := '(not applicable)';
        --Get the ID of the object in question
        v_object_id := '(not applicable)';
    end if;

    --See if the user has a primary email address
    begin
        v_have_allowed_address := false;

        select value
          into v_user_email_address
          from t_osi_personnel_contact opc, t_osi_reference tor
         where opc.type = tor.sid and tor.code = 'EMLP' and opc.personnel = :new.personnel;

        v_allowed_addresses :=
             core_list.convert_to_list(core_util.get_config('OSI.NOTIF_EMAIL_ALLOW_ADDRESSES'), ',');

        --Check to make sure they are allowed to send with this email address (if not, just default to NO_REPLY address)
        for cnt in 1 .. core_list.count_list_elements(v_allowed_addresses)
        loop
            if (substr(v_user_email_address,
                       instr(v_user_email_address, '@') + 1,
                       length(v_user_email_address)) =
                                                core_list.get_list_element(v_allowed_addresses, cnt)) then
                --Found it!
                v_have_allowed_address := true;
                exit;
            end if;
        end loop;

        if (v_have_allowed_address = false) then
            return;
        --v_user_email_address := core_util.get_config('OSI.NOTIF_SNDR');
        end if;
    exception
        when no_data_found then
            --If user has no primary email address, use the NO_REPLY address
            --v_user_email_address := core_util.get_config('OSI.NOTIF_SNDR');
            return;
    end;

    --Probably shouldn't need the IF block, but better safe than sorry..
    if (v_have_allowed_address = true) then
        --Get Page Description
        select page_name || ' Page'
          into v_page_desc
          from apex_030200.apex_application_pages
         where page_id = :new.page_id and application_id = 100;

        --Create Message
        v_msg := 'Personnel / User: ' || v_username || v_crlf;
        v_msg := v_msg || 'Date/Time: ' || to_char(sysdate, 'Dy DD-Mon-YYYY HH24:MI:SS') || v_crlf;
        v_msg := v_msg || 'Page Desctiption: ' || v_page_desc || v_crlf;
        v_msg := v_msg || 'Object Type: ' || v_object_type_desc || v_crlf;
        v_msg := v_msg || 'Object ID: ' || v_object_id || v_crlf;
        v_msg := v_msg || 'Object Title: ' || v_object_title || v_crlf;
        v_msg := v_msg || 'User Message: ' || :new.user_text || v_crlf;
        --Send email
        v_status :=
                   core_util.email_send(v_email_to, 'Help Desk Ticket', v_msg, v_user_email_address);
--Should we do something with the status output?
    end if;
exception
    when others then
        raise;
end osi_feedback_a_i_send;
/



