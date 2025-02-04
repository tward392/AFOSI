CREATE TABLE WEBI2MS.T_OSI_EMAILLINK
(
  SID         VARCHAR2(20 BYTE)                 NOT NULL,
  PERSONNEL   VARCHAR2(20 BYTE),
  OBJ         VARCHAR2(20 BYTE),
  USER_TEXT   VARCHAR2(4000 BYTE),
  SENDER      VARCHAR2(4000 BYTE),
  RECIPIENTS  VARCHAR2(4000 BYTE),
  CREATE_BY   VARCHAR2(100 BYTE),
  CREATE_ON   DATE,
  MODIFY_BY   VARCHAR2(100 BYTE),
  MODIFY_ON   DATE
);

COMMENT ON TABLE WEBI2MS.T_OSI_EMAILLINK IS '[Holds records for User EMail Link.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.SID IS 'The SID for this row.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.PERSONNEL IS 'The personnel that is sending the EMail Link.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.OBJ IS 'The object that the user was viewing when he/she clicked EMail Link';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.USER_TEXT IS 'The text the user typed into the EMail Link Message Window.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.SENDER IS 'Senders Email Address.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.RECIPIENTS IS 'Recipients Email Addresses.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.CREATE_BY IS 'The name of the user that created this record.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.CREATE_ON IS 'The date of creation of this record.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.MODIFY_BY IS 'The name of the user who last modified this record.';

COMMENT ON COLUMN WEBI2MS.T_OSI_EMAILLINK.MODIFY_ON IS 'The date of the last modification of this record.';


CREATE UNIQUE INDEX WEBI2MS.PK_OSI_EMAILLINK ON WEBI2MS.T_OSI_EMAILLINK (SID);


CREATE OR REPLACE TRIGGER WEBI2MS.OSI_EMAILLINK_B_I_SID
BEFORE INSERT
ON WEBI2MS.T_OSI_EMAILLINK
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
begin
    
  if :new.SID is null then

    :new.SID := Core_Sidgen.NEXT_SID;

  end if;

end;
/
SHOW ERRORS;



CREATE OR REPLACE TRIGGER WEBI2MS.OSI_EMAILLINK_B_I_SEND
BEFORE INSERT
ON WEBI2MS.T_OSI_EMAILLINK
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare

    v_email_to               varchar2(4000);
    v_email_to_temp          varchar2(4000);
    v_username               varchar2(100);
    v_object_type_desc       varchar2(400);
    v_object_title           varchar2(400);
    v_object_id              varchar2(400);
    v_page_desc              varchar2(400);
    v_user_email_address     varchar2(400);
    v_msg                    varchar2(4500);
    v_status                 varchar2(400);
    v_crlf                   varchar2(10)   := chr(13) || chr(10);
    v_url                    varchar2(4000) := core_util.get_config('CORE.BASE_URL');
    v_EmailDomainAllowed     varchar2(4000) := core_util.GET_CONFIG('OSI.NOTIF_EMAIL_ALLOW_ADDRESSES');
    
begin
     v_user_email_address := :new.sender;
     
     ---Get Helpdesk Email Address---
     for a in (select column_value from table(split(:new.recipients,':')))
     loop
         begin
              select cont.value into v_email_to_temp
                 from t_core_personnel p,t_osi_personnel op,t_osi_personnel_contact cont,t_osi_reference r
                  where p.SID=op.SID 
                    and cont.personnel=p.sid 
                    and r.sid=cont.type 
                    and r.code='EMLP' 
                    and upper(substr(cont.value,-length(v_EmailDomainAllowed)))=upper(v_EmailDomainAllowed)
                    and p.sid=a.column_value;
              
              if (v_email_to = '' or v_email_to is null) then

                v_email_to := v_email_to_temp;

              else

                v_email_to := v_email_to || ',' || v_email_to_temp;
              
              end if;
             
         exception when others then

                  null;
                  
         end;
  
  null;       
     end loop;

     :new.recipients := v_email_to;
     
     ---Get the sending personnels name---
     v_username := osi_personnel.get_name(:new.personnel);

     ---Get Object Type---
     v_object_type_desc := osi_object.get_objtype_desc(core_obj.get_objtype(:new.obj));

     ---Get the title of the object in question---
     v_object_title := core_obj.get_tagline(:new.obj);

     ---Get the ID of the object in question---
     v_object_id := osi_object.get_id(:new.obj, null);
       
     if v_object_id is null or v_object_id='' then
       
       v_object_id := '(not found)';
         
     end if;
    
     ---Create Message---
     v_msg := replace(:new.user_text,v_crlf,'<BR>') || '<BR><A HREF="' || v_url || :new.obj || '">' || v_object_title || '</A><BR>';

     ---Send email---
     v_status := core_util.email_send(v_email_to, v_object_title, v_msg, v_user_email_address, null, null, null, 'text/html;');

exception
    when others then
        raise;

end osi_emaillink_b_i_send;
/
SHOW ERRORS;



CREATE OR REPLACE TRIGGER WEBI2MS.OSI_EMAILLINK_B_IU_TS
BEFORE INSERT OR UPDATE
ON WEBI2MS.T_OSI_EMAILLINK
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare

  V_WHO   Varchar2(100);
  V_WHEN  Date;

begin
    
  V_WHO := Core_Context.PERSONNEL_NAME;

  if V_WHO is null then

    V_WHO := V('APP_USER');

  end if;

  if V_WHO is null then

    V_WHO := SYS_CONTEXT('USERENV', 'OS_USER');

  end if;

  if V_WHO is null then

    V_WHO := user;

  end if;

  V_WHEN := sysdate;

  if INSERTING then

    :new.CREATE_BY := V_WHO;
    :new.CREATE_ON := V_WHEN;
  
  end if;
    
  :new.MODIFY_BY := V_WHO;
  :new.MODIFY_ON := V_WHEN;

end;
/
SHOW ERRORS;



ALTER TABLE WEBI2MS.T_OSI_EMAILLINK ADD (CONSTRAINT PK_OSI_EMAILLINK PRIMARY KEY (SID));

GRANT SELECT ON  WEBI2MS.T_OSI_EMAILLINK TO MIS_ROLE;


