-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE BODY osi_local_synchronization as
/************************************************************************************** 
   NAME:       OSI_LOCAL_SYNCHRONIZATION
   PURPOSE:    Supports the Syncing of Local Mode into WebI2MS.

   REVISIONS:
   Date        Author           Description
   ----------  ---------------  ------------------------------------------------------ 
   14-Jun-2010  Tim Ward        Created this package (Based SYNC_LOCAL_PARTICIPANTS). 
   26-Aug-2010  Tim Ward        Un-Commented sync_local_act_avsupport now that it is in WebI2MS. 
   21-Dec-2010  Tim Ward        Participants not saving a Starting Status in T_OSI_STATUS_HISTORY.
                                 Changed SYNC_LOCAL_PARTICIPANTS.
   09-Mar-2011  Tim Ward        CR#3743 - DEERS Update is broken on Locally Sync'ed Participants.  Need to 
                                 insert a record into t_osi_person_chars.
                                 Changed SYNC_LOCAL_PARTICIPANTS.
   11-Jul-2012  Tim Ward        CR#4085 - Make sure the Insert to T_OSI_STATUS_HISTORY is done last.  It
                                 was being done before the assignment was entered causing "NO LEAD AGENT"
                                 to be shown in the Desktop View because of the Trigger 
                                 T_OSI_STATUS_HISTORY.OSI_STATHIST_B_I_AL.

**************************************************************************************/  
  
  ------------------------------------------------------------------------------------------------------------  
  --- Mark iobects as no longer local.  This will prevent them from being picked up again on the next run. ---  
  ------------------------------------------------------------------------------------------------------------  
  procedure UPDATE_OBJ_LOCAL_STATUS(pSid in varchar2) as

  begin

       update sync.t_iobject ti set ti.local=0 where ti.sid = pSid;
       commit;

  end UPDATE_OBJ_LOCAL_STATUS;

  ---------------- 
  --- Feedback ---  
  ---------------- 
  procedure INSERT_FEEDBACK(pSyncTable in varchar2, pSyncSid in varchar2, pI2MSTable in varchar2, pI2MSSID in varchar2, sql_errorMsg in varchar2 := Null) as
       
       sql_statement varchar2(4000);
       
  begin
       begin
            Select sql_text into sql_statement from v$sql where address = (Select prev_sql_addr from v$session where sid = (Select unique sid from v$mystat));
       exception when others then
            
                sql_statement := '** More Than One Found**';

       end;
       
       core_logger.log_it('SYNC', pSyncTable || '~' || pSyncSid || '~' || pI2MSTable || '~' || pI2MSSID || '~' || sql_statement || '~' || sql_errorMsg);
       insert into sync.i2ms_feedback (sync_table, sync_sid, i2ms_table, i2ms_sid, sql_statement, error_msg) values (pSyncTable, pSyncSid, pI2MSTable, pI2MSSID, substr(sql_statement,1,4000), sql_errorMsg); 
       commit;

  end INSERT_FEEDBACK;

  procedure INSERT_RECORD(pLocalTableName in varchar2 , pRemoteTableName in varchar2, act_rec in act_cur%rowtype, p_sid in varchar2 , p_type in varchar2, p_core_acl in varchar2, p_RestrictionSID in varchar2) as

     pitype_sid varchar2(20) := null;
     p_partic_usage varchar2(100) := 'SUBJECT';
     p_partic_code varchar2(100) := 'SUBJECT';
     v_Recent_SID varchar2(20);
          
  begin
       case pRemoteTableName
           
           when 'T_CORE_OBJ' then                                                      
               
               insert into t_core_obj (sid,obj_type,acl,create_by,create_on,modify_by,modify_on) values (p_sid,p_type,p_core_acl,act_rec.createby,act_rec.createon,act_rec.modifyby,act_rec.modifyon);
               commit;

               -- Update the Dates and User Name, the Trigger could have changed them --
               update t_core_obj set create_by=act_rec.createby, create_on=act_rec.createon, modify_by=act_rec.modifyby, modify_on=act_rec.modifyon where sid=p_sid;
               commit;
               
               -- Add or Update Recent Objects --
               begin
                    select sid into v_Recent_SID from T_OSI_PERSONNEL_RECENT_OBJECTS where PERSONNEL=act_rec.usersid AND OBJ=p_sid AND UNIT=act_rec.owner;
                    update T_OSI_PERSONNEL_RECENT_OBJECTS set times_accessed=times_accessed+1,last_accessed=sysdate where sid=v_Recent_SID;
                    commit;
                    
               exception when others then
                         
                        INSERT INTO T_OSI_PERSONNEL_RECENT_OBJECTS (PERSONNEL,OBJ,UNIT,TIMES_ACCESSED,LAST_ACCESSED) VALUES (act_rec.usersid,p_sid,act_rec.owner,1,sysdate);
                        commit;
                            
               end;
               
           when 'T_OSI_ACTIVITY' then
               
               insert into t_osi_activity (sid,id,title,narrative,creating_unit,assigned_unit,activity_date,restriction) values (p_sid,act_rec.idnumber, act_rec.title, act_rec.narrative,act_rec.owner,act_rec.owner,act_rec.activitydate,p_RestrictionSID);
               commit;

           when 'T_OSI_STATUS_HISTORY' then

               insert into t_osi_status_history (obj, status, effective_on, transition_comment, is_current) values (p_sid, osi_status.get_starting_status(p_type), act_rec.createon, 'Created (Local)', 'Y');
               commit;
               
               -- Update the Dates and User Name, the Trigger could have changed them --
               update t_osi_status_history set create_by=act_rec.createby where obj=p_sid;
               commit;

           when 'T_OSI_PARTIC_INVOLVEMENT' then
               
               case OSI_OBJECT.get_objtype_code(p_type)
                                  
                   when 'ACT.INIT_NOTIF' then
                       
                       p_partic_usage := 'PARTICIPANT';
                       p_partic_code := 'NOTIFIED';
                       
                   when 'ACT.AV_SUPPORT' then
                       
                       p_partic_usage := 'REQUESTOR';
                       p_partic_code := 'REQUESTOR';
                       
                   else
                       p_partic_usage := 'SUBJECT';
                       p_partic_code := 'SUBJECT';

               end case;

               -- Create the t_osi_partic_involvement record --
               select sid into pitype_sid from t_osi_partic_role_type
                     where obj_type member of osi_object.get_objtypes(p_type) and usage = p_partic_usage and code=p_partic_code;

               -- Feedback -- 
               INSERT_FEEDBACK(pLocalTableName,act_rec.sid,pRemoteTableName || 'Subject SID=' || act_rec.subject,p_sid);
                                
               insert into t_osi_partic_involvement (sid,obj,participant_version,involvement_role, create_by, create_on, modify_by, modify_on) values (Null, p_sid, osi_participant.get_current_version(act_rec.subject), pitype_sid, act_rec.createby, act_rec.createon, act_rec.modifyby, act_rec.modifyon);
               commit;
              
       end case;

       -- Feedback -- 
       INSERT_FEEDBACK(pLocalTableName,act_rec.sid,pRemoteTableName,p_sid);

  end INSERT_RECORD;
  
  procedure TRANSLATE_TYPE_SUBTYPES(p_LocalType in varchar2, pLocal_SubType in varchar2, pRemoteType out varchar2, pRemote_SubType out varchar2) as
  begin
       case p_LocalType
         
           when 'Individual' then

               pRemoteType := 'PART.INDIV';
               pRemote_SubType := 'Individual';
       
           when 'Company' then

               pRemoteType := 'PART.NONINDIV.COMP';
               pRemote_SubType := pLocal_SubType;

           when 'Organization' then

               pRemoteType := 'PART.NONINDIV.ORG';
               pRemote_SubType := pLocal_SubType;
       
           when 'Program' then

               pRemoteType := 'PART.NONINDIV.PROG';
               pRemote_SubType := 'Program';
           
       end case;
       
  end TRANSLATE_TYPE_SUBTYPES;

  -------------------------------------------
  -- Syncs Note and Attachments from Stubs --
  -------------------------------------------
  procedure SYNC_LOCALDATA_FROM_STUBS as
     
     p_TypeSid varchar2(100);
     p_Last_Job varchar2(20) := '-------------------';
          
  begin
       for l_rec in (select o.sid, o.objecttype, o.type, o.subtype, j.job_number  
                               from sync.t_iobject o, sync.t_sync_jobs j, sync.t_sync_objects so 
                                   where o.haslocaldata=-1 and
                                         j.END_TIME is not null and
                                         j.SYNC_TO_WEB_START is null and
                                         j.JOB_NUMBER=so.JOB_NUMBER and
                                        o.SID=so.OBJ
                                  order by j.JOB_NUMBER,o.SID)
       loop
           if p_Last_Job != l_rec.job_number then
             
             if p_Last_Job != '-------------------' then

               update sync.t_sync_jobs j set sync_to_web_end=sysdate where j.JOB_NUMBER=p_Last_Job;
               commit;
             
             else
  
               -- Feedback -- 
               INSERT_FEEDBACK('SYNC_LOCALDATA_FROM_STUBS','Start-' || sysdate, '-', '-');
             
             end if;
   
             INSERT_FEEDBACK('SYNC_LOCALDATA_FROM_STUBS','Job Number Change: p_Last_Job=' || p_Last_Job || ', NewJob=' || l_rec.job_number, '-', '-');

             p_Last_Job := l_rec.job_number;

             update sync.t_sync_jobs j set sync_to_web_start=sysdate where j.JOB_NUMBER=p_Last_Job;
             commit;

           end if;
           
           begin
                select obj_type into p_TypeSid from t_core_obj t where t.sid=l_rec.sid;

                sync_local_notes(l_rec.sid, l_rec.sid, p_TypeSid);

                sync_local_attachments(l_rec.sid, l_rec.sid, p_TypeSid);

                update sync.t_iobject ti set ti.haslocaldata=0 where ti.sid = l_rec.sid;
                commit;

           exception when others then
                    
                    Null;
                    
           end;

       end loop;

       if p_Last_Job != '-------------------' then
  
         -- Feedback -- 
         INSERT_FEEDBACK('SYNC_LOCALDATA_FROM_STUBS','  End-' || sysdate, '-', '-');

         update sync.t_sync_jobs j set sync_to_web_end=sysdate where j.JOB_NUMBER=p_Last_Job;
         commit;

       end if;

  end SYNC_LOCALDATA_FROM_STUBS;
    
  ------------------------------- 
  ------------------------------- 
  ------------------------------- 
  --- Common Objects Synching --- 
  ------------------------------- 
  ------------------------------- 
  ------------------------------- 

  --------------------------------------------------------------
  --- Sync ALL Common Objects that are Associated to Objects ---
  --------------------------------------------------------------
  procedure SYNC_LOCAL_COMMON_OBJECTS(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

  begin

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_COMMON_OBJECTS','Start-' || sysdate,p_RemoteSid,p_TypeSid);

       sync_local_attachments(p_RemoteSid, p_LocalSid, p_TypeSid);     
       sync_local_notes(p_RemoteSid, p_LocalSid, p_TypeSid);
       sync_local_related_objects(p_RemoteSid, p_LocalSid, p_TypeSid);
       sync_local_evidence(p_RemoteSid, p_LocalSid, p_TypeSid);

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_COMMON_OBJECTS','  End-' || sysdate,p_RemoteSid,p_TypeSid);
       
  end SYNC_LOCAL_COMMON_OBJECTS;
  
  --------------------------------------   
  --- Related Objects Synching --------- 
  ---  1. Assignments  (Personnel)   --- 
  ---  2. Associations (File)        --- 
  ---  3. Participants (Participant) --- 
  --------------------------------------  
  procedure SYNC_LOCAL_RELATED_OBJECTS(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     r_sid varchar2(20) := null;
     r_type varchar2(20) := null;
     r_createon date := null;
     r_createby varchar2(20) := null;
     r_modifyon date := null;
     r_modifyby varchar2(20) := null;     
     r_assign_role_sid varchar2(20) := null;
     
     p_assoc_sid varchar2(20) := null;

     p_sid varchar2(20) := null;
     pitype_sid varchar2(20) := null;
     p_partic_usage varchar2(100) := null;
     p_partic_code varchar2(100) := null;
     
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_RELATED_OBJECTS','Start-' || sysdate,p_RemoteSid,p_TypeSid);

       -- Sync All Notes Associated to p_sid -- 
       for ro_rec in (select * from sync.t_relatedobject r where r.objectsid = p_LocalSid) 
       loop
           select sid, objecttype, createby, createon, modifyby, modifyon into r_sid, r_type, r_createby, r_createon, r_modifyby, r_modifyon from sync.t_iobject where sid=ro_rec.myobject;
            
           case r_type
         
               when 'Personnel' then
                   
                   p_assoc_sid := core_sidgen.next_sid;

                   select sid into r_assign_role_sid from t_osi_assignment_role_type rt
                         where obj_type member of osi_object.get_objtypes(p_TypeSid) and 
                               active = 'Y' and 
                               upper(description) = upper(ro_rec.type) and
                               code not in (select code from t_osi_assignment_role_type
                                                  where obj_type = p_TypeSid and override = 'Y' and sid <> rt.sid);

                   insert into t_osi_assignment (SID, OBJ, PERSONNEL, ASSIGN_ROLE, START_DATE, END_DATE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, UNIT) values
                                                (p_assoc_sid, p_RemoteSid, ro_rec.myobject, r_assign_role_sid, ro_rec.begindate, null, r_createby, r_createon, r_modifyby, r_modifyon, osi_personnel.get_current_unit(r_sid));
                                                                   
                   -- Feedback -- 
                   INSERT_FEEDBACK('T_RELATEDOBJECT',ro_rec.sid,'T_OSI_ASSIGNMENT',p_assoc_sid);
                   commit;
                   
               when 'File' then

                   p_assoc_sid := core_sidgen.next_sid;
                   
                   insert into t_osi_assoc_fle_act (SID, FILE_SID, ACTIVITY_SID, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON) values
                                                   (p_assoc_sid, ro_rec.myobject, p_RemoteSid, r_createby, r_createon, r_modifyby, r_modifyon);
                                                                   
                   -- Feedback -- 
                   INSERT_FEEDBACK('T_RELATEDOBJECT',ro_rec.sid,'T_OSI_ASSOC_FLE_ACT',p_assoc_sid);
                   commit;
                   
               when 'Participant' then
                   
                   for r in (select * from 
                                   t_osi_partic_role_type 
                                   where obj_type member of osi_object.get_objtypes(p_TypeSid) 
                                     and role=ro_rec.type)
                   loop
                       p_partic_usage := r.usage;
                       p_partic_code := r.code;
                       pitype_sid := r.sid;
                               
                   end loop;
                   
                   if pitype_sid is not null then
                   
                     p_sid := core_sidgen.next_sid;

                     -- Create the t_osi_partic_involvement record --
                     insert into t_osi_partic_involvement (sid, obj, participant_version, involvement_role, num_briefed, create_by, create_on, modify_by, modify_on) values (Null, p_RemoteSid, osi_participant.get_current_version(ro_rec.myobject), pitype_sid, ro_rec.numbriefed, r_createby, r_createon, r_modifyby, r_modifyon);
                     commit;
                                                                   
                     -- Feedback -- 
                     INSERT_FEEDBACK('T_RELATEDOBJECT',ro_rec.sid,'T_OSI_PARTIC_INVOLVEMENT',p_sid);
                     commit;

                   else  

                     -- Feedback -- 
                     INSERT_FEEDBACK('T_RELATEDOBJECT',ro_rec.sid,'RELATED OBJECT IGNORED (' || r_type || '-' || ro_rec.type || ')','-');
                     commit;

                   end if;
                   
               else
               
                   -- Feedback -- 
                   INSERT_FEEDBACK('T_RELATEDOBJECT',ro_rec.sid,'RELATED OBJECT IGNORED (' || r_type || '-' || ro_rec.type || ')','-');
                   commit;
          
           end case;

           -- Reset values -- 
           r_sid := null;
           r_type := null;
           r_createon := null;
           r_createby := null;
           r_modifyon := null;
           r_modifyby := null;     
           r_assign_role_sid  := null;
           p_assoc_sid  := null;
           
       end loop; 

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_RELATED_OBJECTS','  End-' || sysdate,p_RemoteSid,p_TypeSid);

  exception
      when others then
          INSERT_FEEDBACK('SYNC_LOCAL_RELATED_OBJECTS', 'SYNC_LOCAL_RELATED_OBJECTS', 'SYNC_LOCAL_RELATED_OBJECTS', 'SYNC_LOCAL_RELATED_OBJECTS', SQLERRM);

  end SYNC_LOCAL_RELATED_OBJECTS;

  ------------------------ 
  --- Address Synching --- 
  ------------------------ 
  procedure SYNC_LOCAL_ADDRESS(pa_LocalAddressSID in varchar2, pa_AddressType in varchar2, p_sid in varchar2, p_ObjType in varchar2, p_createby in varchar2, p_createon in date, p_modifyby in varchar2, p_modifyon in date) as

           pa_sid varchar2(20) := null;
           pa_ADDR_1 varchar2(100) := null;
           pa_ADDR_2 varchar2(100) := null;
           pa_CITY varchar2(100) := null;
           pa_STATE varchar2(20) := null;
           pa_ZIP varchar2(30) := null;
           pa_COUNTRY varchar2(20) := null;
           p_address_type_sid varchar2(20) := null;

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ADDRESS','Start-' || sysdate,p_sid,p_ObjType);

       select distinct ta.ADDR1,ta.ADDR2,ta.CITY,st.sid,ta.ZIP,cn.sid into 
                       pa_ADDR_1,pa_ADDR_2,pa_CITY,pa_STATE,pa_ZIP,pa_COUNTRY 
             from sync.t_address ta, T_DIBRS_STATE st, T_DIBRS_COUNTRY cn
                 where ta.sid = pa_LocalAddressSID and
                      cn.description(+) = ta.country and st.description(+) = ta.state;  

       pa_sid := core_sidgen.next_sid;
             
       select sid into p_address_type_sid from t_osi_addr_type t
                 where obj_type member of osi_object.get_objtypes(p_ObjType) and code=pa_AddressType;
    
       insert into t_osi_address (SID,OBJ,ADDRESS_TYPE,ADDRESS_1,ADDRESS_2,CITY,STATE,POSTAL_CODE,COUNTRY,CREATE_ON,CREATE_BY,MODIFY_ON,MODIFY_BY) values 
                                 (pa_sid,p_sid,p_address_type_sid,pa_ADDR_1,pa_ADDR_2,pa_CITY,pa_STATE,pa_ZIP,pa_COUNTRY,p_createon,p_createby,p_modifyon,p_modifyby);

       -- Feedback -- 
       INSERT_FEEDBACK('T_ADDRESS (' || pa_AddressType || ')',pa_LocalAddressSID,'T_OSI_ADDRESS',pa_sid);

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ADDRESS','  End-' || sysdate,p_sid,p_ObjType);

  exception
      when others then
          INSERT_FEEDBACK('SYNC_LOCAL_ADDRESS', 'SYNC_LOCAL_ADDRESS', 'SYNC_LOCAL_ADDRESS', 'SYNC_LOCAL_ADDRESS', SQLERRM);

  end SYNC_LOCAL_ADDRESS;

  ---------------------------- 
  --- Participant Synching --- 
  ---------------------------- 
  procedure SYNC_LOCAL_PARTICIPANTS as

           p_sid varchar2(20) := null;
           pv_sid varchar2(20) := null;
           pn_sid varchar2(20) := null;
           pv_cn number := null;
           ps_sid varchar2(20) := null;
           p_type varchar2(20) := null;
           p_type_temp varchar2(50) := null;
           p_subtype varchar2(20) := null;
           p_subtype_temp varchar2(50) := null;
           pn_type varchar2(20) := null;
           p_core_acl varchar2(20) := null;
           p_numtype_sid varchar(20) := null;
           v_Recent_SID varchar2(20) := null;
          
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_PARTICIPANTS','Start-' || sysdate,'-','-');
  
       -- All persons must be local and have at least a name -- 
       for person_rec in (select distinct a.*, c.SSN, c.BIRTHADDRESS from sync.t_iobject a, sync.t_name b, sync.t_individual c
                                where a.sid = b.OBJECTSID and
                                      a.sid = c.sid(+) and
                                      a.OBJECTTYPE = 'Participant' and 
                                   a.local = -1) 
       loop
           -- Translate the Type and Subtype Codes from Local I2MS/I2MS to webI2MS --
           TRANSLATE_TYPE_SUBTYPES(person_rec.type, person_rec.subtype,  p_type_temp, p_subtype_temp);

           select sid into p_type from t_core_obj_type t where t.CODE=p_type_temp;
           select sid into p_subtype from t_osi_reference r where r.usage=p_type_temp and r.description=p_subtype_temp;
           select sid into p_core_acl from t_core_acl a where a.OBJ_TYPE=p_type;

           -- Create the t_core_obj record --   
           p_sid := core_sidgen.next_sid;

           insert into t_core_obj (sid,obj_type,acl,create_by,create_on,modify_by,modify_on) values (p_sid,p_type,p_core_acl,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
           commit;

           -- Update the Dates and User Name, the Trigger could have changed them --
           update t_core_obj set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=p_sid;
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',person_rec.sid,'T_CORE_OBJ',p_sid);

           -- Create the t_osi_status_history record --
           insert into t_osi_status_history (obj, status, effective_on, transition_comment, is_current) values (p_sid, osi_status.get_starting_status(p_type), person_rec.createon, 'Created (Local)', 'Y');
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',person_rec.sid,'T_OSI_STATUS_HISTORY',p_sid);
               
           -- Update the Dates and User Name, the Trigger could have changed them --
           update t_osi_status_history set create_by=person_rec.createby where obj=p_sid;
           commit;
     
           --- Create the t_osi_participant record -- 
           insert into t_osi_participant (sid,create_by,create_on,modify_by,modify_on) values (p_sid,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
           commit;     

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',person_rec.sid,'T_OSI_PARTICIPANT',p_sid);

           -- Update the Dates and User Name, the Trigger could have changed them --
           update t_osi_participant set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=p_sid;
           commit;
     
           -- Create the t_osi_participant_version record -- 
           pv_sid := core_sidgen.next_sid;
           insert into t_osi_participant_version (sid,participant,create_by,create_on,modify_by,modify_on) values (pv_sid,p_sid,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',person_rec.sid,'T_OSI_PARTICIPANT_VERSION',pv_sid);

           -- Update the Dates and User Name, the Trigger could have changed them --
           update t_osi_participant_version set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=pv_sid;
           commit;

           -- Create the t_osi_participant_human or t_osi_participant_nonhuman record -- 
           if p_subtype_temp = 'Individual' then

             insert into t_osi_participant_human (sid,create_by,create_on,modify_by,modify_on) values (pv_sid,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
             commit;

             -- Feedback -- 
             INSERT_FEEDBACK('T_IOBJECT',person_rec.sid,'T_OSI_PARTICIPANT_HUMAN',pv_sid);
  
             -- Update the Dates and User Name, the Trigger could have changed them --
             update t_osi_participant_human set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=pv_sid;
             commit;

             -- Create t_osi_person_chars Record ---
             insert into t_osi_person_chars (sid,create_by,create_on,modify_by,modify_on) values (pv_sid,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
             commit;

             -- Update the Dates and User Name, the Trigger could have changed them --
             update t_osi_person_chars set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=pv_sid;
             commit;

           else
     
             insert into t_osi_participant_nonhuman (sid,sub_type,create_by,create_on,modify_by,modify_on) values (pv_sid,p_subtype,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
             commit;

             -- Feedback -- 
             INSERT_FEEDBACK('T_IOBJECT',person_rec.sid,'T_OSI_PARTICIPANT_NONHUMAN',pv_sid);

             -- Update the Dates and User Name, the Trigger could have changed them --
             update t_osi_participant_nonhuman set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=pv_sid;
             commit;

           end if;
      
           -- Update t_osi_participant with the Current Version -- 
           update t_osi_participant set current_version=pv_sid where sid=p_sid;
           commit;
           
           -- Add the SSN -- 
           if person_rec.SSN is not null then

             ps_sid := core_sidgen.next_sid;
             
             select sid into p_numtype_sid from t_osi_partic_number_type t where t.code='SSN';
    
             insert into t_osi_partic_number (sid,participant_version,num_type,num_value,create_by,create_on,modify_by,modify_on) values (ps_sid,pv_sid,p_numtype_sid,person_rec.SSN,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
             commit;

             --Feedback -- 
             INSERT_FEEDBACK('T_INDIVIDUAL',person_rec.SID,'T_OSI_PARTIC_NUMBER',ps_sid);

             -- Update the Dates and User Name, the Trigger could have changed them --
             update t_osi_partic_number set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=ps_sid;
             commit;
           
           end if;
           
           -- Add the birth address --  
           if person_rec.BIRTHADDRESS is not null then
             
             sync_local_address(person_rec.BIRTHADDRESS,'BIRTH',p_sid,p_Type,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);

           end if;
           
           -- Add the primary address --  
           if person_rec.PRIMARYADDRESS is not null then

             sync_local_address(person_rec.PRIMARYADDRESS,'PERMANENT',p_sid,p_Type,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);

           end if;

           -- Create person names -- 
           for name_rec in (select d.*, e.CURRENTNAME from sync.t_name d, sync.t_entity e
                            where d.OBJECTSID = person_rec.sid and
                      e.SID(+) = d.OBJECTSID) 
           loop 
               pn_sid := core_sidgen.next_sid;

               -- Find name type -- 
               select sid into pn_type from t_osi_partic_name_type t where t.DESCRIPTION=name_rec.type;

               -- Add name records -- 
               insert into t_osi_partic_name (SID,PARTICIPANT_VERSION,NAME_TYPE,LAST_NAME,FIRST_NAME,MIDDLE_NAME,CADENCY,CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON) values
                                (pn_sid,pv_sid,pn_type,name_rec.LASTNAME,name_rec.FIRSTNAME,name_rec.MIDDLENAME,name_rec.CADENCE,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
               commit;

               -- Update the Dates and User Name, the Trigger could have changed them --
               update t_osi_partic_name set create_by=person_rec.createby, create_on=person_rec.createon, modify_by=person_rec.modifyby, modify_on=person_rec.modifyon where sid=pn_sid;
               commit;

               -- Flag the current name to use -- 
               if name_rec.CURRENTNAME is not null then

                 pv_cn := 1;
                 update t_osi_participant_version set current_name = pn_sid where sid = pv_sid;
                 commit;

               end if;

               if pv_cn is null then

                 -- They may not have picked a name to use, so we will -- 
                 update t_osi_participant_version set current_name = pn_sid where sid = pv_sid;
                 commit;

               end if;

               --Feedback -- 
               INSERT_FEEDBACK('T_NAME',name_rec.SID,'T_OSI_PARTICIPANT_NAME',pn_sid);
           
           end loop;
           
           -- Mark iobects as no longer local.  This will prevent them from being picked up again on the next run. --
           UPDATE_OBJ_LOCAL_STATUS(person_rec.sid); 

           update sync.t_iobject set idnumber=p_sid,sid=p_sid where sid=person_rec.sid;
           commit;
           update sync.t_individual set sid=p_sid where sid=person_rec.sid;
           commit;
           update sync.t_activity set subject=p_sid where subject=person_rec.sid;
           commit;
           update sync.t_entity set sid=p_sid,currentname=pn_sid where sid=person_rec.sid;
           commit;
           update sync.t_name set sid=pn_sid,objectsid=p_sid where objectsid=person_rec.sid;
           commit;
           update sync.t_relatedObject set myobject=p_sid where myobject=person_rec.sid;
           commit;
           update sync.t_relatedObject set objectsid=p_sid where objectsid=person_rec.sid;
           commit;
           update sync.t_relatedObject set sid=p_sid where sid=person_rec.sid;
           commit;
           update sync.t_sourcesofinformation set source=p_sid where source=person_rec.sid;
           commit;
           update sync.t_note set objectsid=p_sid where objectsid=person_rec.sid;
           commit;
           update sync.t_attachment set objectsid=p_sid where objectsid=person_rec.sid;
           commit;

           -- Add or Update Recent Objects --
           begin
                select sid into v_Recent_SID from T_OSI_PERSONNEL_RECENT_OBJECTS where PERSONNEL=person_rec.usersid AND OBJ=p_sid AND UNIT=person_rec.owner;
                update T_OSI_PERSONNEL_RECENT_OBJECTS set times_accessed=times_accessed+1,last_accessed=sysdate where sid=v_Recent_SID;
                commit;
                    
           exception when others then
                         
                    INSERT INTO T_OSI_PERSONNEL_RECENT_OBJECTS (PERSONNEL,OBJ,UNIT,TIMES_ACCESSED,LAST_ACCESSED) VALUES (person_rec.usersid,p_sid,person_rec.owner,1,sysdate);
                    commit;
                            
           end;
                      
           -- Reset values -- 
           p_sid := null;
           pv_sid := null;
           pn_sid := null;
           pv_cn := null;
           ps_sid := null;
           p_type := null;
           p_subtype := null;
           pn_type := null;
           p_subtype_temp := null;
           p_core_acl := null;
           p_numtype_sid := null;
           v_Recent_SID := null;
           
       end loop; 

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_PARTICIPANTS','  End-' || sysdate,'-','-');

  exception
      when others then
          INSERT_FEEDBACK('SYNC_LOCAL_PARTICIPANTS', 'SYNC_LOCAL_PARTICIPANTS', 'SYNC_LOCAL_PARTICIPANTS', 'SYNC_LOCAL_PARTICIPANTS', SQLERRM);

  end SYNC_LOCAL_PARTICIPANTS;

  ---------------------- 
  --- Notes Synching --- 
  ---------------------- 
  procedure SYNC_LOCAL_NOTES(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     n_sid varchar2(20) := null;
     n_type varchar2(20) := null;
     n_lock_mode varchar2(50) := null;

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_NOTES','Start-' || sysdate, p_RemoteSid, p_TypeSid);

       -- Sync All Notes Associated to p_sid -- 
       for note_rec in (select * from sync.t_note n where n.objectsid = p_LocalSid and n.local=-1) 
       loop
           select sid,lock_mode into n_type,n_lock_mode 
                 from t_osi_note_type t 
                 where t.obj_type member of osi_object.get_objtypes(p_TypeSid) and
                       upper(description)=upper(note_rec.type) and
                       usage='NOTELIST' and
                       code not in (select code from t_osi_note_type where obj_type=p_TypeSid and override='Y' and sid <> t.sid);                

           -- Create the t_osi_note record --   
           n_sid := core_sidgen.next_sid;

           insert into t_osi_note (sid,obj,note_type,note_text,creating_personnel,create_by,create_on,modify_by,modify_on) values 
                            (n_sid,p_RemoteSid,n_type,note_rec.narrative,note_rec.usersid,note_rec.createby,note_rec.createon,note_rec.createby,note_rec.createon);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_NOTE',note_rec.sid,'T_OSI_NOTE',n_sid);

           update t_osi_note set create_by=note_rec.createby ,create_on=note_rec.createon where sid=n_sid;
           commit;

           update sync.t_note set local=0 where sid=note_rec.sid;
           commit;

           -- Reset values -- 
           n_sid := null;
           
       end loop; 

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_NOTES','  End-' || sysdate, p_RemoteSid, p_TypeSid);

  exception
      when others then
          INSERT_FEEDBACK('SYNC_LOCAL_NOTES', 'SYNC_LOCAL_NOTES', 'SYNC_LOCAL_NOTES', 'SYNC_LOCAL_NOTES', SQLERRM);

  end SYNC_LOCAL_NOTES;

  ------------------------- 
  --- Local Attachments --- 
  ------------------------- 
  procedure SYNC_LOCAL_ATTACHMENTS(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     a_sid varchar2(20) := null;
     a_type varchar2(20) := null;
     
     --- Types only for Finger/Palmprint Activities ---
     a_type_FPEFT varchar2(20) := null;
     a_type_FPSTAT varchar2(20) := null;
     a_type_PPEFT varchar2(20) := null;
     a_type_PPSTAT varchar2(20) := null;
     
     a_storage_type varchar2(20) := null;
     
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ATTACHMENTS','Start-' || sysdate, p_RemoteSid, p_TypeSid);

       -- Get Attachment Type SIDs for Fingerprint/Palmprint Attachments ---
       begin
            select sid into a_type_FPEFT from t_osi_attachment_type t where t.obj_type=p_TypeSid and usage='FINGERPRINT';
       exception
           when others then
           a_type_FPEFT := Null;
       end;
             
       begin
            select sid into a_type_FPSTAT from t_osi_attachment_type t where t.obj_type=p_TypeSid and usage='FINGERPRINT-STATS';
       exception
           when others then
           a_type_FPSTAT := Null;
       end;
       begin
            select sid into a_type_PPEFT from t_osi_attachment_type t where t.obj_type=p_TypeSid and usage='PALMPRINT';
       exception
           when others then
           a_type_PPEFT := Null;
       end;
       begin
            select sid into a_type_PPSTAT from t_osi_attachment_type t where t.obj_type=p_TypeSid and usage='PALMPRINT-STATS';
       exception
           when others then
           a_type_PPSTAT := Null;
       end;
            
       -- Sync All Attachments -- 
       for att_rec in (select * from sync.t_attachment a where a.objectsid=p_LocalSid and a.local=-1)
       loop
           a_sid := core_sidgen.next_sid;

           --- 'Softcopy Maintained in I2MS' --- 
           a_storage_type := 'DB';
        
           case att_rec.type
          
               when 'FingerPrintEFTFile' then

                   a_type := a_type_FPEFT;

               when 'FingerPrintStatsFile' then

                   a_type := a_type_FPSTAT;

               when 'PalmPrintEFTFile' then

                   a_type := a_type_PPEFT;

               when 'PalmPrintStatsFile' then

                   a_type := a_type_PPSTAT;
               
               when 'Hardcopy Maintained in AF Form 3986' then
                   
                   a_storage_type := 'OUTSIDE';
               
               when 'Softcopy Maintained in AF Form 3986' then
                   
                   a_storage_type := 'FILE';
               
               when 'Softcopy Maintained in I2MS' then
               
                   a_storage_type := 'DB';
               
               else
                 
                   a_storage_type := 'OUTSIDE';
                   
           end case;
      
           insert into t_osi_attachment (sid,obj,type,content,storage_loc_type,description,source,creating_personnel,create_by,create_on,modify_by,modify_on,mime_type) values 
                                       (a_sid,p_RemoteSid,a_type,att_rec.filedata,a_storage_type,att_rec.description,att_rec.filename,att_rec.usersid,att_rec.createby,att_rec.createon,att_rec.createby,att_rec.datemodified,att_rec.mimetype);
           commit;

           update t_osi_attachment set create_by=att_rec.createby ,create_on=att_rec.createon where sid=a_sid;
           commit;
      
           -- Feedback -- 
           INSERT_FEEDBACK('T_ATTACHMENT',att_rec.sid,'T_OSI_ATTACHMENT',a_sid);
      
           a_sid := null;
           a_type := null;

           update sync.t_attachment set local=0 where sid=att_rec.sid;
           commit;

           -- Mark iobects as no longer local.  This will prevent them from being picked up again on the next run. --
           UPDATE_OBJ_LOCAL_STATUS(p_LocalSid); 
      
       end loop;    

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ATTACHMENTS',' End-' || sysdate, p_RemoteSid, p_TypeSid);
       
  exception
      when others then
          INSERT_FEEDBACK('SYNC_LOCAL_ATTACHMENTS', 'SYNC_LOCAL_ATTACHMENTS', 'SYNC_LOCAL_ATTACHMENTS', 'SYNC_LOCAL_ATTACHMENTS', SQLERRM);

  end SYNC_LOCAL_ATTACHMENTS;

  -------------------------   
  --- Evidence Synching --- 
  -------------------------   
  procedure SYNC_LOCAL_EVIDENCE(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as
       
       e_sid varchar2(20) := Null;
       e_status_sid varchar2(20) := osi_evidence.get_starting_status;
       e_acquisitiontype varchar2(20) := Null;
       p_Type varchar2(20) := Null;
               
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_EVIDENCE','Start-' || sysdate, p_RemoteSid, p_TypeSid);

       select sid into p_Type from t_core_obj_type where code='EVIDENCE';
       
       -- Sync All Notes Associated to p_sid -- 
       for ev_rec in (select * from sync.t_evidence e where e.objectsid = p_LocalSid) 
       loop
           e_sid := core_sidgen.next_sid;

           case ev_rec.acquisitiontype
          
               when 'Investigative Activity' then

                   e_acquisitiontype := 'RFIA';

               when 'Obtained During Search' then

                   e_acquisitiontype := 'ODSO';

               when 'Received From Participant' then

                   e_acquisitiontype := 'RFP';

               when 'Received From Source' then

                   e_acquisitiontype := 'RFS';

               when 'Seized From Participant' then

                   e_acquisitiontype := 'SFP';
           
           end case;
                      
           insert into t_osi_evidence (SID, OBJ, SEQ_NUM, DESCRIPTION, OBTAINED_BY_SID, OBTAINED_DATE, UNIT_SID, STATUS_SID, OBTAINED_BY_UNIT_SID, ACQUISITION_METHOD, FINAL_DISP, IDENTIFY_AS, ODSO_COMMENT, RECEIVED_FROM_PARTICIPANT_SID, SEIZED_FROM_PARTICIPANT_SID, OWNER_SID) values
                                      (e_sid, p_RemoteSid, ev_rec.tagnumber, ev_rec.description, ev_rec.obtainedby, ev_rec.datereceived, ev_rec.controllingunit, e_status_sid, osi_personnel.get_current_unit(ev_rec.obtainedby), e_acquisitiontype, substr(ev_rec.recommendeddisposition,1,500), substr(ev_rec.identifysourceas,1,200), ev_rec.obtainedduringsearchof, ev_rec.receivedfromparticipant, ev_rec.seizedfromparticipant, ev_rec.owner); 
                                                                   
           -- Feedback -- 
           INSERT_FEEDBACK('T_EVIDENCE',ev_rec.sid,'T_OSI_EVIDENCE',e_sid);
           commit;
           
           if ev_rec.obtainedat is not null then
  
             sync_local_address(ev_rec.obtainedat,'OBTAINED_AT',e_sid,p_Type,Null,Null,Null,Null);--,person_rec.createby,person_rec.createon,person_rec.modifyby,person_rec.modifyon);
  
           end if;
           
           e_acquisitiontype := Null;
                   
       end loop; 

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_EVIDENCE','  End-' || sysdate, p_RemoteSid, p_TypeSid);
       
  exception
      when others then
          INSERT_FEEDBACK('SYNC_LOCAL_EVIDENCE', 'SYNC_LOCAL_EVIDENCE', 'SYNC_LOCAL_EVIDENCE', 'SYNC_LOCAL_EVIDENCE', SQLERRM);

  end SYNC_LOCAL_EVIDENCE;

  --------------------------- 
  --------------------------- 
  --- Activities Synching --- 
  --------------------------- 
  --------------------------- 
  procedure SYNC_ALL_LOCAL_ACTIVITIES as

     p_sid varchar2(20) := null;
     p_type varchar2(20) := null;
     p_core_acl varchar2(20) := null;
     p_core_obj_type_code varchar2(100) := null;
     p_core_obj_type_code_last varchar2(100) := '~!~!~!~!~!~!~FIRST ONE~!~!~!~!~!~!~';
     p_RestrictionSID varchar2(20) := null;
     p_StatusSid varchar2(20) := null;
     p_AddressCode varchar2(100) := null;
     p_Last_Job varchar2(20) := '-------------------';
     
  begin
       -- Sync the Local Participants Once Per Run --
       for act_rec in act_cur
       loop
           sync_local_participants;
           exit;
           
       end loop;
       
       -- Check for HasLocalData (Attachments/Notes added to Stubs --
      sync_localdata_from_stubs;
       
       -- Sync All Activity Types -- 
       for act_rec in act_cur                                  
       loop
           if p_Last_Job != act_rec.job_number then
             
             if p_Last_Job != '-------------------' then

               update sync.t_sync_jobs j set sync_to_web_end=sysdate where j.JOB_NUMBER=p_Last_Job;
               commit;
             
             else
  
               -- Feedback -- 
               INSERT_FEEDBACK('SYNC_ALL_LOCAL_ACTIVITIES','Start-' || sysdate, '-', '-');
             
             end if;
   
             INSERT_FEEDBACK('SYNC_ALL_LOCAL_ACTIVITIES','Job Number Change: p_Last_Job=' || p_Last_Job || ', NewJob=' || act_rec.job_number, '-', '-');

             p_Last_Job := act_rec.job_number;

             update sync.t_sync_jobs j set sync_to_web_start=sysdate where j.JOB_NUMBER=p_Last_Job;
             commit;

           end if;
           
           case act_rec.type
               
               when 'FingerPalmPrint' then
                   
                   p_core_obj_type_code := 'ACT.FINGERPRINT.CRIMINAL';
               
               when 'Interview' then
                   
                   p_core_obj_type_code := 'ACT.INTERVIEW.' || UPPER(act_rec.subtype);

                   --- Location of Interview Address ---
                   p_AddressCode := 'LOC';
                   
               when 'InitialNotification' then
                   
                   p_core_obj_type_code := 'ACT.INIT_NOTIF';
                   
               when 'Search' then
                   
                   p_core_obj_type_code := 'ACT.SEARCH.' || UPPER(act_rec.subtype);

                   --- Location of Search Address ---
                   p_AddressCode := 'LOC';

               when 'DocumentReview' then
                   
                   p_core_obj_type_code := 'ACT.DOCUMENT_REVIEW';

               when 'LawEnforcementRecordsCheck' then
                   
                   p_core_obj_type_code := 'ACT.RECORDS_CHECK';

               when 'Consultation' then
                   
                   p_core_obj_type_code := sync_get_consultcoord_type(act_rec.type, act_rec.subtype);

               when 'Coordination' then
                   
                   p_core_obj_type_code := sync_get_consultcoord_type(act_rec.type, act_rec.subtype);
               
               when 'ExceptionActivity' then
                   
                   p_core_obj_type_code := 'ACT.EXCEPTION';
                   
               when 'Briefing' then
                   
                   p_core_obj_type_code := 'ACT.BRIEFING';
               
               when 'Liaison' then

                   p_core_obj_type_code := 'ACT.LIAISON';
               
               when 'AVSupport' then
                   
                   p_core_obj_type_code := 'ACT.AV_SUPPORT';

               when 'MediaAnalysis' then
                   
                   p_core_obj_type_code := 'ACT.MEDIA_ANALYSIS';
                       
               when 'SourceMeet' then
                   
                   p_core_obj_type_code := 'ACT.SOURCE_MEET';

                   --- Location of Source Meet ---
                   p_AddressCode := 'MEET';

               when 'PolyExam' then
                   
                   p_core_obj_type_code := 'ACT.POLY_EXAM';
               
               when 'ComputerIntrusion' then
                   
                   p_core_obj_type_code := 'ACT.COMP_INTRUSION';

                   --- Location of Base ---
                   p_AddressCode := 'BASE';

               else
                   -- Feedback -- 
                   INSERT_FEEDBACK('T_IOBJECT',act_rec.sid,'ACTIVITY IGNORED (' || act_rec.type || ')','-');
                   
           end case;
           
           if p_core_obj_type_code is not null then
             
             if p_core_obj_type_code <> p_core_obj_type_code_last then

               -- Get Object Type SID and ACL SID --   
               select sid into p_type from t_core_obj_type t where t.code=p_core_obj_type_code;
               select sid into p_core_acl from t_core_acl a where a.obj_type=p_type;

               p_core_obj_type_code_last := p_core_obj_type_code;
             
             end if;
                  
             -- Create the t_core_obj record --   
             p_sid := core_sidgen.next_sid;

             insert_record('T_IOBJECT','T_CORE_OBJ',act_rec,p_sid,p_type,p_core_acl,null);

             -- Create the t_osi_activity record --
             begin
                  select sid into p_RestrictionSID from t_osi_reference where usage='RESTRICTION' and description=act_rec.restriction;
             exception    
             when others then
               
                 p_RestrictionSID := Null;
               
             end;

             insert_record('T_IOBJECT','T_OSI_ACTIVITY',act_rec,p_sid,p_type,p_core_acl, p_RestrictionSID);
             
             --- Sync Activity Specific Information ---
             case p_core_obj_type_code
                 
                 when 'ACT.FINGERPRINT.CRIMINAL' then

                     sync_local_act_fingerprint(p_sid, act_rec.sid, p_type);
                 
                 when 'ACT.INTERVIEW.' || UPPER(act_rec.subtype) then

                     sync_local_act_interview(p_sid, act_rec.sid, p_type);
                 
                 when 'ACT.INIT_NOTIF' then
                     
                     sync_local_act_init_notif(p_sid, act_rec.sid, p_type);

                 when 'ACT.SEARCH.' || UPPER(act_rec.subtype) then

                     sync_local_act_search(p_sid, act_rec.sid, p_type);

                 when 'ACT.DOCUMENT_REVIEW' then

                     sync_local_act_documentreview(p_sid, act_rec.sid, p_type);

                 when 'ACT.RECORDS_CHECK' then

                     sync_local_act_recordscheck(p_sid, act_rec.sid, p_type);

                 when 'ACT.BRIEFING' then

                     sync_local_act_briefing(p_sid, act_rec.sid, p_type);

                 when 'ACT.LIAISON' then

                     sync_local_act_liaison(p_sid, act_rec.sid, p_type);
                 
                 when 'ACT.AV_SUPPORT' then

                     sync_local_act_avsupport(p_sid, act_rec.sid, p_type);
                 
                 when 'ACT.MEDIA_ANALYSIS' then

                     sync_local_act_media_analysis(p_sid, act_rec.sid, p_type);
                 
                 when 'ACT.SOURCE_MEET' then

                     sync_local_act_source_meet(p_sid, act_rec.sid, p_type);
                 
                 when 'ACT.POLY_EXAM' then

                     sync_local_act_poly_exam(p_sid, act_rec.sid, p_type);

                 when 'ACT.COMP_INTRUSION' then

                     sync_local_act_comp_int(p_sid, act_rec.sid, p_type);
                 
                 else
                     if substr(p_core_obj_type_code,1,17) IN ('ACT.CONSULTATION.','ACT.COORDINATION.') then
                     
                       sync_local_act_consult_coord(p_sid, act_rec.sid, p_type);
                     
                     else
  
                       -- Feedback -- 
                       INSERT_FEEDBACK('T_IOBJECT',act_rec.sid,'ACTIVITY SPECIFIC INFORMATION IGNORED (' || act_rec.type || ')','-',p_core_obj_type_code);
                     
                     end if;
                     
             end case;
             
             -- Subject in Source Meets is Actually the Source SID ---
             if p_core_obj_type_code = 'ACT.SOURCE_MEET' then
    
               -- Update Source SID --
               update t_osi_activity a set source=act_rec.subject where a.sid=p_sid;
               commit;
   
               -- Feedback -- 
               INSERT_FEEDBACK('T_ACTIVITY',act_rec.sid,'T_OSI_ACTIVITY',p_sid,'Soruce=, ' || act_rec.subject);

             else
              
               if act_rec.subject is not null and act_rec.subjectname not in ('Unspecified','UNSPECIFIED') then
               
                 -- Create the t_osi_partic_involvement record --
                 insert_record('T_ACTIVITY','T_OSI_PARTIC_INVOLVEMENT',act_rec,p_sid,p_type,p_core_acl, p_RestrictionSID);
               
               end if;
               
             end if;
             
             --- Sync Address ---
             if act_rec.primaryaddress is not null then

               sync_local_address(act_rec.primaryaddress,p_AddressCode,p_sid,p_type,act_rec.createby,act_rec.createon,act_rec.modifyby,act_rec.modifyon);
           
             end if;
             
             --- Sync All Objects that Can be Associated to Activities ---
             sync_local_common_objects(p_sid, act_rec.sid, p_type);

             -- Create the t_osi_status_history record --
             insert_record('T_IOBJECT','T_OSI_STATUS_HISTORY',act_rec,p_sid,p_type,p_core_acl, p_RestrictionSID);
     
             -- Mark iobects as no longer local.  This will prevent them from being picked up again on the next run. --
             UPDATE_OBJ_LOCAL_STATUS(act_rec.sid); 

             -- Reset values -- 
             p_sid := null;
             p_core_obj_type_code := null;
             p_AddressCode := null;
             
           end if;
                      
       end loop; 

       if p_Last_Job != '-------------------' then
  
         -- Feedback -- 
         INSERT_FEEDBACK('SYNC_ALL_LOCAL_ACTIVITIES','  End-' || sysdate, '-', '-');

         update sync.t_sync_jobs j set sync_to_web_end=sysdate where j.JOB_NUMBER=p_Last_Job;
         commit;

       end if;
       
    exception
        when others then
            INSERT_FEEDBACK('SYNC_ALL_LOCAL_ACTIVITIES', 'SYNC_ALL_LOCAL_ACTIVITIES', 'SYNC_ALL_LOCAL_ACTIVITIES', 'SYNC_ALL_LOCAL_ACTIVITIES', SQLERRM);

  end SYNC_ALL_LOCAL_ACTIVITIES;
  
  --------------------------------------------------- 
  --- Fingerprint/Palmprint/Biometrics Activities --- 
  ---------------------------------------------------
  procedure SYNC_LOCAL_ACT_FINGERPRINT(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_FINGERPRINT','Start-' || sysdate, '-', '-');

       -- Create the t_osi_a_fingerprint record --   
       insert into t_osi_a_fingerprint (sid) values (p_RemoteSid);
       commit;

       -- Feedback -- 
       INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_FINGERPRINT',p_RemoteSid);

    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_FINGERPRINT', 'SYNC_LOCAL_ACT_FINGERPRINT', 'SYNC_LOCAL_ACT_FINGERPRINT', 'SYNC_LOCAL_ACT_FINGERPRINT', SQLERRM);

  end SYNC_LOCAL_ACT_FINGERPRINT;

  ---------------------------- 
  --- Interview Activities --- 
  ---------------------------- 
  procedure SYNC_LOCAL_ACT_INTERVIEW(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     p_AdvisementTypeSid varchar2(20) := null;
     p_Form2701TypeSid varchar2(20) := null;

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_INTERVIEW','Start-' || sysdate, '-', '-');
       
       for int_rec in (select * from sync.t_interview where sid=p_LocalSid)                                   
       loop
 
           begin
                select sid into p_AdvisementTypeSid from t_osi_reference r where r.usage='ADVISEMENT' and description=int_rec.ADVISEMENTTYPE;
           
           exception when others then
                
                p_AdvisementTypeSid := Null;
                
           end;

           begin
                select sid into p_Form2701TypeSid from t_osi_reference r where r.usage='DD2701_RESULT' and description=int_rec.FORM2701TYPE;

           exception when others then
                
                p_Form2701TypeSid := Null;
                
           end;

           -- Create the t_osi_a_interview record --   
           insert into t_osi_a_interview (sid,advisement,dd2701) values (p_RemoteSid,p_AdvisementTypeSid,p_Form2701TypeSid);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_INTERVIEW',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_INTERVIEW','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_INTERVIEW', 'SYNC_LOCAL_ACT_INTERVIEW', 'SYNC_LOCAL_ACT_INTERVIEW', 'SYNC_LOCAL_ACT_INTERVIEW', SQLERRM);

  end SYNC_LOCAL_ACT_INTERVIEW;

  ---------------------------------------- 
  --- Initial Notifications Activities --- 
  ---------------------------------------- 
  procedure SYNC_LOCAL_ACT_INIT_NOTIF(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     p_MissionArea varchar2(20) := null;

     v_array apex_application_global.vc_arr2;
     v_specialinterests varchar2(4000);
     v_temp_string varchar2(20);

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_INIT_NOTIF','Start-' || sysdate, '-', '-');
       
       for init_rec in (select * from sync.t_initialnotification where sid=p_LocalSid)                                   
       loop
 
           begin
                select sid into p_MissionArea from t_osi_mission_category c where c.DESCRIPTION=init_rec.missionarea;
           
           exception when others then
                
                p_MissionArea := Null;
                
           end;
           
           v_array := apex_util.string_to_table(init_rec.specialinterests, '|');
           for i in 1 .. v_array.count
           loop
               begin
                    -- Feedback -- 
                    INSERT_FEEDBACK('T_INITIALNOTIFICATION',p_LocalSid,'t_osi_mission_category-v_array(' || i || ')',p_RemoteSid,v_array(i));
                    
                    select sid into v_temp_string from t_osi_mission_category c where c.description=v_array(i);

                    -- Feedback -- 
                    INSERT_FEEDBACK('T_INITIALNOTIFICATION',p_LocalSid,'t_osi_mission_category-v_temp_string',p_RemoteSid,v_temp_string);
                    
                    if length(v_specialinterests) > 0 then
                      
                      v_specialinterests := v_specialinterests || ':';
                      
                    end if;
                    
                    v_specialinterests := v_specialinterests || v_temp_string;

                    -- Feedback -- 
                    INSERT_FEEDBACK('T_INITIALNOTIFICATION',p_LocalSid,'t_osi_mission_category-v_specialinterests',p_RemoteSid,v_specialinterests);
                    
               exception when others then
                        
                        v_temp_string := null;
               end;
               
           end loop;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'osi_object.set_special_interest',p_RemoteSid,v_specialinterests);

           osi_object.set_special_interest(p_RemoteSid,v_specialinterests);
           
           -- Create the t_osi_a_init_notification record --   
           insert into t_osi_a_init_notification (sid,begin_date,end_date,reported_date,mission_area) values (p_RemoteSid,init_rec.incidentbegindatetime,init_rec.incidentenddatetime,init_rec.incidentreporteddatetime,p_MissionArea);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_INIT_NOTIF',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_INIT_NOTIF','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_INIT_NOTIF', 'SYNC_LOCAL_ACT_INIT_NOTIF', 'SYNC_LOCAL_ACT_INIT_NOTIF', 'SYNC_LOCAL_ACT_INIT_NOTIF', SQLERRM);

  end SYNC_LOCAL_ACT_INIT_NOTIF;

  ------------------------- 
  --- Search Activities --- 
  ------------------------- 
  procedure SYNC_LOCAL_ACT_SEARCH(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     p_SearchBasisSid varchar2(20) := null;

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_SEARCH','Start-' || sysdate, '-', '-');
       
       for srch_rec in (select * from sync.t_search where sid=p_LocalSid)                                   
       loop

           begin
                select sid into p_SearchBasisSid from t_osi_reference r where r.usage='SEARCH_BASIS' and description=srch_rec.BASIS;
           
           exception when others then
                
                p_SearchBasisSid := Null;
                
           end;

           -- Create the t_osi_a_search record --   
           insert into t_osi_a_search (sid,search_basis,explanation) values (p_RemoteSid,p_SearchBasisSid,srch_rec.explanation);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_SEARCH',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_SEARCH','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_SEARCH', 'SYNC_LOCAL_ACT_SEARCH', 'SYNC_LOCAL_ACT_SEARCH', 'SYNC_LOCAL_ACT_SEARCH', SQLERRM);

  end SYNC_LOCAL_ACT_SEARCH;

  ---------------------------------- 
  --- Document Review Activities --- 
  ---------------------------------- 
  procedure SYNC_LOCAL_ACT_DOCUMENTREVIEW(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     p_DocTypeSid varchar2(20) := null;

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_DOCUMENTREVIEW','Start-' || sysdate, '-', '-');
       
       for docrev_rec in (select d.sid,d.documentnumber,o.subtype from sync.t_documentreview d,sync.t_iobject o where d.sid=p_LocalSid and d.sid=o.sid )                                   
       loop

           begin
                select sid into p_DocTypeSid from t_osi_reference r where r.usage='DOCREV_DOCTYPE' and description=docrev_rec.subtype;
           
           exception when others then
                
                p_DocTypeSid := Null;
                
           end;

           -- Create the t_osi_a_document_review record --   
           insert into t_osi_a_document_review (sid,doc_type,document_number) values (p_RemoteSid,p_DocTypeSid,docrev_rec.documentnumber);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_DOCUMENT_REVIEW',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_DOCUMENTREVIEW','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_DOCUMENTREVIEW', 'SYNC_LOCAL_ACT_DOCUMENTREVIEW', 'SYNC_LOCAL_ACT_DOCUMENTREVIEW', 'SYNC_LOCAL_ACT_DOCUMENTREVIEW', SQLERRM);

  end SYNC_LOCAL_ACT_DOCUMENTREVIEW;

  -------------------------------- 
  --- Records Check Activities --- 
  -------------------------------- 
  procedure SYNC_LOCAL_ACT_RECORDSCHECK(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     p_LercTypeSid varchar2(20) := null;

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_DOCUMENTREVIEW','Start-' || sysdate, '-', '-');
       
       for lerc_rec in (select l.sid,l.referencenumber,o.subtype from sync.t_lawenforcementrecordscheck l,sync.t_iobject o where l.sid=p_LocalSid and l.sid=o.sid )                                   
       loop

           begin
                select sid into p_LercTypeSid from t_osi_reference r where r.usage='LERC_DOCTYPE' and description=lerc_rec.subtype;
           
           exception when others then
                
                p_LercTypeSid := Null;
                
           end;

           -- Create the t_osi_a_records_check record --   
           insert into t_osi_a_records_check (sid,doc_type,reference_num) values (p_RemoteSid,p_LercTypeSid,lerc_rec.referencenumber);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_RECORDS_CHECK',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_RECORDSCHECK','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_RECORDSCHECK', 'SYNC_LOCAL_ACT_RECORDSCHECK', 'SYNC_LOCAL_ACT_RECORDSCHECK', 'SYNC_LOCAL_ACT_RECORDSCHECK', SQLERRM);

  end SYNC_LOCAL_ACT_RECORDSCHECK;

  -------------------------------------------- 
  --- Consultation/Coordination Activities --- 
  --------------------------------------------
  procedure SYNC_LOCAL_ACT_CONSULT_COORD(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     p_MethodSid varchar2(20) := null;

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_CONSULT_COORD','Start-' || sysdate, '-', '-');
       
       for c_rec in (select * from sync.t_consultation where sid=p_LocalSid)                                   
       loop

           begin
                select sid into p_MethodSid from t_osi_reference r where r.usage='CONTACT_METHOD' and description=c_rec.method;
           
           exception when others then
                
                p_MethodSid := Null;
                
           end;

           -- Create the t_osi_a_records_check record --   
           insert into t_osi_a_consult_coord (sid,cc_method) values (p_RemoteSid,p_MethodSid);
           commit;

           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_CONSULT_COORD',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_CONSULT_COORD','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_CONSULT_COORD', 'SYNC_LOCAL_ACT_CONSULT_COORD', 'SYNC_LOCAL_ACT_CONSULT_COORD', 'SYNC_LOCAL_ACT_CONSULT_COORD', SQLERRM);

  end SYNC_LOCAL_ACT_CONSULT_COORD;
  
  function SYNC_GET_CONSULTCOORD_TYPE(type in varchar2, subtype in varchar2) return varchar2 is

     p_ActCode varchar2(100) := 'ACT.' || upper(type) || '.OTHER';
        
  begin
       begin

            select code into p_ActCode from t_core_obj_type where description = type || ', ' || subtype;
            
       exception when others then
                
               null;

       end;

       return p_ActCode;
  
  end SYNC_GET_CONSULTCOORD_TYPE;

  --------------------------- 
  --- Briefing Activities --- 
  --------------------------- 
  procedure SYNC_LOCAL_ACT_BRIEFING(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     v_array apex_application_global.vc_arr2;
     v_topic varchar2(4000);
     v_subtopic varchar2(4000);
     v_subtopic_start number;
     
     v_topic_Sid varchar2(20);
     v_subtopic_sid varchar2(20);
     v_content_Sid varchar2(20);
     
     c_sid varchar2(20);
          
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_BRIEFING','Start-' || sysdate, '-', '-');
       
       for brief_rec in (select b.sid,b.location,b.topics,o.subtype from sync.t_briefing b,sync.t_iobject o where b.sid=p_LocalSid and b.sid=o.sid )                                   
       loop
           -- Create the t_osi_a_records_check record --   
           insert into t_osi_a_briefing (sid,location) values (p_RemoteSid,brief_rec.location);
           commit;
           
           v_array := apex_util.string_to_table(brief_rec.topics, '|');
           for i in 1 .. v_array.count
           loop
               begin
                    if length(v_array(i)) > 0 then
                      
                      v_subtopic_start := instr(v_array(i),' (',1,1);
                      
                      v_topic := upper(rtrim(ltrim(substr(v_array(i),1,v_subtopic_start-1))));
                      v_subtopic := upper(rtrim(ltrim(substr(v_array(i),v_subtopic_start+2,length(v_array(i))-v_subtopic_start-2))));

                      -- Feedback -- 
                      INSERT_FEEDBACK('T_BRIEFING',p_LocalSid,'Topic=' || v_topic || ', SubTopic=' || v_subtopic,p_RemoteSid);
                      
                      select sid into v_topic_sid from t_osi_topic where upper(description)=v_topic;
                      select sid into v_subtopic_sid from t_osi_subtopic where upper(description)=v_subtopic;
                      select sid into v_content_sid from t_osi_topic_content where topic=v_topic_sid and subtopic=v_subtopic_sid;

                      c_sid := core_sidgen.next_sid;
                      
                      insert into t_osi_briefing_topic_content (sid,briefing,topic_content) values (c_sid,p_RemoteSid,v_content_sid);
                      commit;

                      -- Feedback -- 
                      INSERT_FEEDBACK('T_BRIEFING',p_LocalSid,'T_OSI_BRIEFING_TOPIC_CONTENT - ' || c_sid || ',' || p_RemoteSid || ',' || v_content_sid,p_RemoteSid);
                      
                    end if;
                    
               exception when others then
                        
                        -- Feedback -- 
                        INSERT_FEEDBACK('T_BRIEFING',p_LocalSid,'TOPIC/SUBTOPIC NOT FOUND',p_RemoteSid);
               end;
               
           end loop;
           
           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_BRIEFING',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_BRIEFING','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_BRIEFING', 'SYNC_LOCAL_ACT_BRIEFING', 'SYNC_LOCAL_ACT_BRIEFING', 'SYNC_LOCAL_ACT_BRIEFING', SQLERRM);

  end SYNC_LOCAL_ACT_BRIEFING;

  -------------------------- 
  --- Liaison Activities --- 
  -------------------------- 
  procedure SYNC_LOCAL_ACT_LIAISON(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     v_Type_Sid varchar2(20);
     v_Level_Sid varchar2(20);

  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_LIAISON','Start-' || sysdate, '-', '-');
       
       for l_rec in (select l.sid,l.liaisonlevel,o.type,o.subtype from sync.t_liaison l,sync.t_iobject o where l.sid=p_LocalSid and l.sid=o.sid )                                   
       loop
           begin
                select sid into v_Type_Sid from t_osi_reference where usage='LIAISON_TYPE' and description='Liaison, ' || l_rec.subtype;

           exception when others then
         
                    -- Feedback -- 
                    INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_LIAISON',p_RemoteSid,'Liaison, ' || l_rec.subtype || ' - Type NOT FOUND.' );
           
           end;

           begin
                select sid into v_Level_Sid from t_osi_reference where usage='LIAISON_LEVEL' and description=l_rec.liaisonlevel;

           exception when others then
         
                    -- Feedback -- 
                    INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_LIAISON',p_RemoteSid,l_rec.liaisonlevel || ' - Liaison Level NOT FOUND.' );
           
           end;
           
           if v_Type_Sid is not null and v_Level_Sid is not null then
  
             -- Create the t_osi_a_records_check record --   
             insert into t_osi_a_liaison (sid,liaison_type,liaison_level) values (p_RemoteSid,v_Type_Sid,v_Level_Sid);
             commit;
             
           end if;
           
           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_LIAISON',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_LIAISON','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_LIAISON', 'SYNC_LOCAL_ACT_LIAISON', 'SYNC_LOCAL_ACT_LIAISON', 'SYNC_LOCAL_ACT_LIAISON', SQLERRM);

  end SYNC_LOCAL_ACT_LIAISON;

  ----------------------------- 
  --- AV Support Activities --- 
  ----------------------------- 
  procedure SYNC_LOCAL_ACT_AVSUPPORT(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     v_Type_Sid varchar2(20);

  begin
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_AVSUPPORT', p_LocalSid, 'T_OSI_A_AVSUPPORT', p_RemoteSid, 'AVSupport Activity is not SUPPORTED by WebI2MS');

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_AVSUPPORT','Start-' || sysdate, '-', '-');
       
       for av_rec in (select a.sid,a.requestedbydatetime,a.completeddatetime,o.type,o.subtype from sync.t_avsupport a,sync.t_iobject o where a.sid=p_LocalSid and a.sid=o.sid )                                   
       loop
           if av_rec.subtype is not null then

             begin
                  select sid into v_Type_Sid from t_osi_reference where usage='AV_TYPE' and description=av_rec.subtype;

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_AVSUPPORT',p_RemoteSid,'AVSupport Type Not Found-, ' || av_rec.subtype);
           
             end;
             
           end if;
           
           -- Create the t_osi_a_avsupport record --   
           insert into t_osi_a_avsupport (sid,av_type,date_request_by,date_completed) values (p_RemoteSid,v_Type_Sid,av_rec.requestedbydatetime,av_rec.completeddatetime);
           commit;
             
           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_AVSUPPORT',p_RemoteSid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_AVSUPPORT','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_AVSUPPORT', 'SYNC_LOCAL_ACT_AVSUPPORT', 'SYNC_LOCAL_ACT_AVSUPPORT', 'SYNC_LOCAL_ACT_AVSUPPORT', SQLERRM);

  end SYNC_LOCAL_ACT_AVSUPPORT;

  --------------------------------- 
  --- Media Analysis Activities --- 
  --------------------------------- 
  procedure SYNC_LOCAL_ACT_MEDIA_ANALYSIS(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     v_Type_Sid varchar2(20);
     v_Units_Sid varchar2(20);
     v_MA_Sid varchar2(20);
          
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_MEDIA_ANALYSIS','Start-' || sysdate, '-', '-');
       
       for ma_rec in (select m.objectsid,m.mediatype,m.mediasize,m.mediasizeunits,m.quantity,m.dateseized,m.datereceived,m.dateanalysisstart,m.dateanalysisend,m.removable,m.comments,o.type,o.subtype from sync.t_mediaanalyzed m,sync.t_iobject o where o.sid=p_LocalSid and o.sid=m.objectsid(+))
                                          
       loop
           if ma_rec.mediasizeunits is not null then

             begin
                  select sid into v_Units_Sid from t_osi_reference where usage='MEDANLY_UNIT' and description=ma_rec.mediasizeunits;

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_MEDIA_ANALYSIS',p_RemoteSid,'Media Size Units Not Found-, ' || ma_rec.mediasizeunits);
           
             end;
             
           end if;

           begin
                select sid into v_Type_Sid from t_osi_reference where usage='MEDANLY_TYPE' and description=ma_rec.mediatype;

           exception when others then
         
                    -- Feedback -- 
                    INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_MEDIA_ANALYSIS',p_RemoteSid,'Media Type Not Found-, ' || ma_rec.mediatype);
           
           end;
           
           v_MA_Sid := core_sidgen.next_sid;
           
           -- Create the t_osi_a_media_analysis record --   
           insert into t_osi_a_media_analysis (sid,activity,media_type,media_size,media_size_units,quantity,seizure_date,receive_date,analysis_start_date,analysis_end_date,removable_flag,comments) values (v_MA_Sid,p_RemoteSid,v_Type_Sid,ma_rec.mediasize,v_Units_Sid,ma_rec.quantity,ma_rec.dateseized,ma_rec.datereceived,ma_rec.dateanalysisstart,ma_rec.dateanalysisend,decode(ma_rec.removable,0,'N',-1,'Y','U'),ma_rec.comments);
           commit;
             
           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_MEDIA_ANALYSIS-Activity=' || p_RemoteSid,v_MA_Sid);
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_MEDIA_ANALYSIS','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_MEDIA_ANALYSIS', 'SYNC_LOCAL_ACT_MEDIA_ANALYSIS', 'SYNC_LOCAL_ACT_MEDIA_ANALYSIS', 'SYNC_LOCAL_ACT_MEDIA_ANALYSIS', SQLERRM);

  end SYNC_LOCAL_ACT_MEDIA_ANALYSIS;

  ------------------------------ 
  --- Source Meet Activities --- 
  ------------------------------ 
  procedure SYNC_LOCAL_ACT_SOURCE_MEET(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     v_ContactMethod_Sid varchar2(20);
     v_TrainingType_Sid varchar2(20);
     v_SourceTraining_Sid varchar2(20);
               
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_SOURCE_MEET','Start-' || sysdate, '-', '-');
       
       for sm_rec in (select s.interviewtype,s.commodity,s.nextmeetdate,o.type,o.createby,o.createon,o.modifyby,o.modifyon,a.sid from sync.t_sourcemeet s,sync.t_iobject o,sync.t_activity a where o.sid=p_LocalSid and o.sid=s.sid and o.sid=a.sid)
       loop
           if sm_rec.interviewtype is not null then

             begin
                  select sid into v_ContactMethod_Sid from t_osi_reference where usage='CONTACT_METHOD' and description=sm_rec.interviewtype;

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_SOURCE_MEET',p_RemoteSid,'Contact Method Not Found-, ' || sm_rec.interviewtype);
           
             end;
             
           end if;

           -- Create the t_osi_a_source_meet record --   
           insert into t_osi_a_source_meet (sid,contact_method,next_meet_date,commodity) values (p_RemoteSid,v_ContactMethod_Sid,sm_rec.nextmeetdate,sm_rec.commodity);
           commit;
             
           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_SOURCE_MEET',p_RemoteSid);
           
           for st_rec in (select s.sid,s.objectsid,s.trainingtype,s.duration,s.comments from sync.t_sourcetraining s,sync.t_iobject o where o.sid=p_LocalSid and o.sid=s.objectsid)
           loop
               begin
                    select sid into v_TrainingType_Sid from t_osi_reference where usage='TRAINING_TYPE' and description=st_rec.trainingtype;

               exception when others then
          
                        -- Feedback -- 
                        INSERT_FEEDBACK('T_SOURCETRAINING',p_LocalSid,'T_OSI_A_SRCMEET_TRAINING',p_RemoteSid,'Source Training Type Not Found-, ' || st_rec.trainingtype);
           
               end;

               -- Create the t_osi_a_srcmeet_training record --   
               v_SourceTraining_Sid := core_sidgen.next_sid;
               insert into t_osi_a_srcmeet_training (sid,obj,training,duration,comments,create_by,create_on,modify_by,modify_on) values (v_SourceTraining_Sid,p_RemoteSid,v_TrainingType_Sid,st_rec.duration,st_rec.comments,sm_rec.createby,sm_rec.createon,sm_rec.modifyby,sm_rec.modifyon);
               commit;
             
               -- Feedback -- 
               INSERT_FEEDBACK('T_SOURCETRAINING',st_rec.sid,'T_OSI_A_SRCMEET_TRAINING',v_SourceTraining_Sid);

           end loop;           
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_SOURCE_MEET','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_SOURCE_MEET', 'SYNC_LOCAL_ACT_SOURCE_MEET', 'SYNC_LOCAL_ACT_SOURCE_MEET', 'SYNC_LOCAL_ACT_SOURCE_MEET', SQLERRM);

  end SYNC_LOCAL_ACT_SOURCE_MEET;

  ---------------------------- 
  --- Poly Exam Activities --- 
  ---------------------------- 
  procedure SYNC_LOCAL_ACT_POLY_EXAM(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     v_EXAMINEE_PHYS_COND varchar2(20);
     v_RESULT varchar2(20);
     v_EXAM_MONITOR varchar2(20);
     v_Question_Sid varchar2(20);
     v_array apex_application_global.vc_arr2;
     v_temp_string varchar2(20);
     v_Temp_Sid varchar2(20);
                 
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_POLY_EXAM','Start-' || sysdate, '-', '-');
       
       for pe_rec in (select LOCATION,START_DATETIME,END_DATETIME,EXAMINEE_PHYS_COND,EXAMINEE_PHYS_REMARK,INSTRUMENT_SERIAL_NUM,RESULT,NUMBER_OF_SERIES,NUMBER_OF_CHARTS,EXAM_MONITOR,BEHAVIORS,TECHNIQUES,o.type,o.createby,o.createon,o.modifyby,o.modifyon,a.sid from sync.t_polyexam p,sync.t_iobject o,sync.t_activity a where o.sid=p_LocalSid and o.sid=p.sid and o.sid=a.sid)
       loop
           update t_osi_activity set activity_date=pe_rec.start_datetime;
           commit;
           
           -- Get SID of Physical Condition of Examinee --
           if pe_rec.examinee_phys_cond is not null then

             begin
                  select sid into v_EXAMINEE_PHYS_COND from t_osi_reference where usage='POLY_PHYS_COND' and description=pe_rec.examinee_phys_cond;

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_POLY_EXAM',p_RemoteSid,'Physical Condition of Examinee Not Found-, ' || pe_rec.examinee_phys_cond);
           
             end;
             
           end if;

           -- Get SID of Opinion/Result --
           if pe_rec.result is not null then

             begin
                  select sid into v_RESULT from t_osi_a_polyex_result where description || '/' || sub_description=pe_rec.result;

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_POLY_EXAM',p_RemoteSid,'Opinion/Result Not Found-, ' || pe_rec.result);
           
             end;
             
           end if;

           -- Get SID of Monitor To Exam --
           if pe_rec.exam_monitor is not null then

             begin
                  select sid into v_EXAM_MONITOR from t_osi_reference where usage='POLY_MONITOR' and description=pe_rec.exam_monitor;

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_POLY_EXAM',p_RemoteSid,'Monitor To Exam Not Found-, ' || pe_rec.exam_monitor);
           
             end;
             
           end if;

           -- Create the t_osi_a_poly_exam record --   
           insert into t_osi_a_poly_exam (sid,LOCATION,START_DATETIME,END_DATETIME,EXAMINEE_PHYS_COND,EXAMINEE_PHYS_COND_REMARK,INSTRUMENT_SERIAL_NUM,RESULT,NUMBER_OF_SERIES,NUMBER_OF_CHARTS,EXAM_MONITOR) values 
                                         (p_RemoteSid,pe_rec.LOCATION,pe_rec.START_DATETIME,pe_rec.END_DATETIME,v_EXAMINEE_PHYS_COND,pe_rec.EXAMINEE_PHYS_REMARK,pe_rec.INSTRUMENT_SERIAL_NUM,v_RESULT,pe_rec.NUMBER_OF_SERIES,pe_rec.NUMBER_OF_CHARTS,v_EXAM_MONITOR);
           commit;
             
           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_POLY_EXAM',p_RemoteSid);
           
           -- Load the Behavior(s) --
           v_array := apex_util.string_to_table(pe_rec.behaviors, '|');

           -- Feedback -- 
           INSERT_FEEDBACK('POLY EXAM BEHAVIORS',p_LocalSid,pe_rec.behaviors || '-count=' || v_array.count,p_RemoteSid);
           
           for i in 1 .. v_array.count
           loop
               begin
                    -- Feedback -- 
                    INSERT_FEEDBACK('POLY EXAM BEHAVIORS',p_LocalSid,'v_array(i)=' || v_array(i),p_RemoteSid);
                    if v_array(i) is not null then

                      select sid into v_temp_string from t_osi_reference where usage='POLY_BEHAVIOR' and description=v_array(i);

                      v_Temp_Sid  := core_sidgen.next_sid;
                      
                      insert into t_osi_a_polyex_behavior (sid,exam,behavior,modify_by,modify_on,create_by,create_on) values (v_Temp_Sid,p_RemoteSid,v_temp_string,pe_rec.modifyby,pe_rec.modifyon,pe_rec.createby,pe_rec.createon);
                      commit;
                      
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_POLYEXAM',p_LocalSid,'t_osi_a_polyex_behavior-' || v_array(i),p_RemoteSid,v_temp_string);

                    end if;
                    
               exception when others then
                        
                        -- Feedback -- 
                        INSERT_FEEDBACK('T_POLYEXAM',p_LocalSid,'t_osi_reference(POLY_BEHAVIOR) not found-' || v_array(i),p_RemoteSid,SQLERRM);
                        v_temp_string := null;
                        
               end;
               
           end loop;

           -- Load the Technique(s)/Type of Test(s) --
           v_array := apex_util.string_to_table(pe_rec.techniques, '|');

           -- Feedback -- 
           INSERT_FEEDBACK('POLY EXAM TECHNIQUES',p_LocalSid,pe_rec.techniques || '-count=' || v_array.count,p_RemoteSid);

           for i in 1 .. v_array.count
           loop
               begin
                    -- Feedback -- 
                    INSERT_FEEDBACK('POLY EXAM TECHNIQUES',p_LocalSid,'v_array(i)=' || v_array(i),p_RemoteSid);

                    if v_array(i) is not null then

                      select sid into v_temp_string from t_osi_reference where usage='POLY_TECHNIQUE' and description=v_array(i);

                      v_Temp_Sid  := core_sidgen.next_sid;
                      
                      insert into t_osi_a_polyex_technique (sid,exam,technique,modify_by,modify_on,create_by,create_on) values (v_Temp_Sid,p_RemoteSid,v_temp_string,pe_rec.modifyby,pe_rec.modifyon,pe_rec.createby,pe_rec.createon);
                      commit;
                      
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_POLYEXAM',p_LocalSid,'t_osi_a_polyex_behavior-' || v_array(i),p_RemoteSid,v_temp_string);

                    end if;
                    
               exception when others then
                        
                        -- Feedback -- 
                        INSERT_FEEDBACK('T_POLYEXAM',p_LocalSid,'t_osi_reference(POLY_TECHNIQUE) not found-' || v_array(i),p_RemoteSid,SQLERRM);
                        v_temp_string := null;
                        
               end;
               
           end loop;

           -- Load the Poly Questions --
           for pq_rec in (select p.sid,p.objectsid,p.series_num,p.question_num,p.question,p.response,o.CREATEBY,o.CREATEON,o.MODIFYBY,o.MODIFYON from sync.t_polyexamquestions p,sync.t_iobject o where o.sid=p_LocalSid and o.sid=p.objectsid)
           loop

               -- Create the t_osi_a_polyex_question record --   
               v_Question_Sid  := core_sidgen.next_sid;
               insert into t_osi_a_polyex_question (sid,exam,series_num,question_num,question,response,create_by,create_on,modify_by,modify_on) values (v_Question_Sid,p_RemoteSid,pq_rec.series_num,pq_rec.question_num,pq_rec.question,pq_rec.response,pq_rec.createby,pq_rec.createon,pq_rec.modifyby,pq_rec.modifyon);
               commit;
             
               -- Feedback -- 
               INSERT_FEEDBACK('T_POLYEXAMQUESTIONS',pq_rec.sid,'T_OSI_A_POLYEX_QUESTION',v_Question_Sid);

           end loop;           
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_POLY_EXAM','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_POLY_EXAM', 'SYNC_LOCAL_ACT_POLY_EXAM', 'SYNC_LOCAL_ACT_POLY_EXAM', 'SYNC_LOCAL_ACT_POLY_EXAM', SQLERRM);

  end SYNC_LOCAL_ACT_POLY_EXAM;

  ------------------------------------- 
  --- Computer Intrusion Activities --- 
  ------------------------------------- 
  procedure SYNC_LOCAL_ACT_COMP_INT(p_RemoteSid in Varchar2, p_LocalSid in Varchar2, p_TypeSid in Varchar2) as

     v_Intrusion_Impact varchar2(20);
     v_Contact_Method varchar2(20);
     v_AFCERT_Category varchar2(20);
     
     v_Intruder_System_SID varchar2(20);
     v_CountrySID varchar2(20);
     v_Component_SID varchar2(20);
     v_ComponentType_SID varchar2(20);
     v_Source_SID varchar2(20);
     v_SourceType_SID varchar2(20);
     v_Class_Level_SID varchar2(20);
     v_Participant_Version_SID varchar2(20);
     
  begin
       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_COMP_INT','Start-' || sysdate, '-', '-');
       
       for ci_rec in (select c.INTRUSION_FROM_DATE,c.INTRUSION_TO_DATE,c.CCI_COMMENT,c.INTRUSION_IMPACT,c.CONTACT_METHOD,c.AFCERT_CATEGORY,c.AFCERT_INCIDENT_NUM,c.SYS_APPLICATION,c.SYS_CPU,c.SYS_BUILDING,c.SYS_ROOM,c.SYS_OS,c.SYS_OS_VERSION,c.SYS_SECURITY_MODE,c.SYS_OTHER_SOFTWARE,c.SYS_CLASS_LEVEL,c.NETWORK_NAME,c.CCI_NOTIFIED,c.REQUEST_FOR_INFORMATION,c.SYS_LOGIN_BANNER_INSTALLED,c.SYS_COVERED_BY_ASIMS,c.SYS_OTHER_SECURITY_INSTALLED,o.type,o.createby,o.createon,o.modifyby,o.modifyon,a.sid from sync.t_computerintrusion c,sync.t_iobject o,sync.t_activity a where o.sid=p_LocalSid and o.sid=c.sid and o.sid=a.sid)
       loop
       
           -- Get SID of Intrusion Impact --
           if ci_rec.intrusion_impact is not null then

             begin
                  select sid into v_Intrusion_Impact from t_osi_reference where usage='COMPINT_IMPACT' and upper(description)=upper(ci_rec.intrusion_impact);

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_COMP_INTRUSION',p_RemoteSid,'Intrusion Impact Not Found-, ' || ci_rec.intrusion_impact);
           
             end;
             
           end if;
           -- Get SID of Contact Method --
           if ci_rec.contact_method is not null then

             begin
                  select sid into v_Contact_Method from t_osi_reference where usage='CONTACT_METHOD' and upper(description)=upper(ci_rec.contact_method);

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_COMP_INTRUSION',p_RemoteSid,'Contact Method Not Found-, ' || ci_rec.contact_method);
           
             end;
             
           end if;
           -- Get SID of AFCERT Category --
           if ci_rec.afcert_category is not null then

             begin
                  select sid into v_AFCERT_Category from t_osi_reference where usage='AFCERT_CATEGORY' and upper(description)=upper(ci_rec.AFCERT_CATEGORY);

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_COMP_INTRUSION',p_RemoteSid,'AFCERT Category Not Found-, ' || ci_rec.AFCERT_CATEGORY);
           
             end;
             
           end if;
           -- Get SID of Highest Classification of Data on System --
           if ci_rec.SYS_CLASS_LEVEL is not null then

             begin
                  select sid into v_Class_Level_SID from t_osi_reference where usage='DATA_CLASSIFICATION' and upper(description)=upper(ci_rec.SYS_CLASS_LEVEL);

             exception when others then
         
                      -- Feedback -- 
                      INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_COMP_INTRUSION',p_RemoteSid,'Classification Level Not Found-, ' || ci_rec.SYS_CLASS_LEVEL);
           
             end;
             
           end if;

           -- Create the t_osi_a_comp_intrusion record --   
           insert into t_osi_a_comp_intrusion (SID,INTRUSION_FROM_DATE,INTRUSION_TO_DATE,CCI_COMMENT,INTRUSION_IMPACT,CONTACT_METHOD,AFCERT_CATEGORY,AFCERT_INCIDENT_NUM,SYS_APPLICATION,SYS_CPU,SYS_BUILDING,SYS_ROOM,SYS_OS,SYS_OS_VERSION,SYS_SECURITY_MODE,SYS_OTHER_SOFTWARE,SYS_CLASS_LEVEL,NETWORK_NAME,CCI_NOTIFIED,REQUEST_FOR_INFORMATION,SYS_LOGIN_BANNER_INSTALLED,SYS_COVERED_BY_ASIMS,SYS_OTHER_SECURITY_INSTALLED) values 
                                              (p_RemoteSid,ci_rec.INTRUSION_FROM_DATE,ci_rec.INTRUSION_TO_DATE,ci_rec.CCI_COMMENT,v_Intrusion_Impact,v_Contact_Method,v_AFCERT_Category,ci_rec.AFCERT_INCIDENT_NUM,ci_rec.SYS_APPLICATION,ci_rec.SYS_CPU,ci_rec.SYS_BUILDING,ci_rec.SYS_ROOM,ci_rec.SYS_OS,ci_rec.SYS_OS_VERSION,ci_rec.SYS_SECURITY_MODE,ci_rec.SYS_OTHER_SOFTWARE,v_Class_Level_SID,ci_rec.NETWORK_NAME,
                                               decode(ci_rec.CCI_NOTIFIED,'Checked','Y','Unchecked','N','U'),
                                               decode(ci_rec.REQUEST_FOR_INFORMATION,'Checked','Y','Unchecked','N','U'),
                                               decode(ci_rec.SYS_LOGIN_BANNER_INSTALLED,'Checked','Y','Unchecked','N','U'),
                                               decode(ci_rec.SYS_COVERED_BY_ASIMS,'Checked','Y','Unchecked','N','U'),
                                               decode(ci_rec.SYS_OTHER_SECURITY_INSTALLED,'Checked','Y','Unchecked','N','U'));
           commit;
             
           -- Feedback -- 
           INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_COMP_INTRUSION',p_RemoteSid);

           -- Load the Intruder Systems --
           for is_rec in (select i.sid,i.ipdomain,i.link_order,i.country,i.comments,o.CREATEBY,o.CREATEON,o.MODIFYBY,o.MODIFYON from sync.t_intrudersystem i,sync.t_iobject o where o.sid=p_LocalSid and o.sid=i.objectsid)
           loop
               -- Get SID of the Country --
               if is_rec.country is not null then

                 begin
                      select sid into v_CountrySID from t_dibrs_country where upper(description)=upper(is_rec.country);

                 exception when others then
         
                          -- Feedback -- 
                          INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_COMPINT_INTRUDER_SYS',p_RemoteSid,'Country Not Found-, ' || is_rec.country);
           
                 end;
             
               end if;
               
               -- Create the t_osi_a_osi_compint_intruder_sys record --   
               v_Intruder_System_SID  := core_sidgen.next_sid;
               insert into t_osi_compint_intruder_sys (sid,compint,ip,link_order,country,comments,create_by,create_on,modify_by,modify_on) values (v_Intruder_System_SID,p_RemoteSid,is_rec.ipdomain,is_rec.link_order,v_CountrySID,is_rec.comments,is_rec.createby,is_rec.createon,is_rec.modifyby,is_rec.modifyon);
               commit;
             
               -- Feedback -- 
               INSERT_FEEDBACK('T_INTRUDERSYSTEM',is_rec.sid,'T_OSI_COMPINT_INTRUDER_SYS',v_Intruder_System_SID);

           end loop;           

           -- Load the Compromised Network IP/Domain Names --
           for cn_rec in (select * from sync.t_compromisedsystem where objectsid=p_LocalSid)
           loop
               -- Get SID of the Component Type --
               begin
                    select sid into v_ComponentType_SID from t_osi_reference where upper(description)='DOMAIN' and usage='CMPINTRSNCOMP_TYPE';

               exception when others then
         
                        -- Feedback -- 
                        INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_COMP_INTRUSION_COMPONENT',p_RemoteSid,'Component Type Not Found-Domain');
           
               end;
               
               -- Create the t_osi_a_osi_compint_intruder_sys record --   
               v_Component_SID  := core_sidgen.next_sid;
               insert into t_osi_comp_intrusion_component (sid,comp_intrusion,component_type,component_val) values (v_Component_SID,p_RemoteSid,v_ComponentType_SID,cn_rec.ipdomain);
               commit;
             
               -- Feedback -- 
               INSERT_FEEDBACK('T_COMPROMISEDSYSTEM',cn_rec.sid,'T_OSI_COMP_INTRUSION_COMPONENT',v_Component_SID);

           end loop;           

           -- Load the Dial Up Numbers --
           for du_rec in (select sid,objectsid,dialupnumber,decode(phonetype,'Commercial','Commercial Dialup',phonetype) as phonetype from sync.t_dialupnumbers where objectsid=p_LocalSid)
           loop
               -- Get SID of the Component Type --
               begin
                    select sid into v_ComponentType_SID from t_osi_reference where upper(description)=upper(du_rec.phonetype) and usage='CMPINTRSNCOMP_TYPE';

               exception when others then
         
                        -- Feedback -- 
                        INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_COMP_INTRUSION_COMPONENT',p_RemoteSid,'Component Type Not Found-Domain');
           
               end;
               
               -- Create the t_osi_a_osi_compint_intruder_sys record --   
               v_Component_SID  := core_sidgen.next_sid;
               insert into t_osi_comp_intrusion_component (sid,comp_intrusion,component_type,component_val) values (v_Component_SID,p_RemoteSid,v_ComponentType_SID,du_rec.dialupnumber);
               commit;
             
               -- Feedback -- 
               INSERT_FEEDBACK('T_DIALUPNUMBERS',du_rec.sid,'T_OSI_COMP_INTRUSION_COMPONENT',v_Component_SID);

           end loop;           

           -- Load the Sources --
           for s_rec in (select o.sid,objectsid,sourcetype,source,description,decode(sourceavailableforrecontact,'Checked','Y','Unchecked','N','U') as sourceavailableforrecontact,decode(sourceprotectionrequired,'Checked','Y','Unchecked','N','U') as sourceprotectionrequired,o.CREATEBY,o.CREATEON,o.MODIFYBY,o.MODIFYON from sync.t_sourcesofinformation s,sync.t_iobject o where o.sid=p_LocalSid and o.sid=s.objectsid)
           loop
               -- Get SID of the Source Type  --
               begin
                    select sid into v_SourceType_SID from t_osi_reference where usage='SOURCE_TYPE' and upper(description)=upper(s_rec.sourcetype);

               exception when others then
         
                        -- Feedback -- 
                        INSERT_FEEDBACK('T_IOBJECT',p_LocalSid,'T_OSI_A_COMPINT_SOURCE',p_RemoteSid,'Source Type Not Found-, ' || s_rec.sourcetype);
           
               end;
               
               begin
                    -- Create the t_osi_a_osi_compint_source record --   
                    v_Source_SID  := core_sidgen.next_sid;
                    case s_rec.sourcetype
           
                        when 'ASIMS' then

                            insert into t_osi_a_compint_source (sid,compint,src_type,description,create_by,create_on,modify_by,modify_on) values 
                                                               (v_Source_SID,p_RemoteSid,v_SourceType_SID,s_rec.description,s_rec.createby,s_rec.createon,s_rec.modifyby,s_rec.modifyon);
                            commit;
                       
                        when 'Agent Observation' then

                            insert into t_osi_a_compint_source (sid,compint,src_type,description,recontactable,create_by,create_on,modify_by,modify_on) values 
                                                               (v_Source_SID,p_RemoteSid,v_SourceType_SID,s_rec.description,s_rec.sourceavailableforrecontact,s_rec.createby,s_rec.createon,s_rec.modifyby,s_rec.modifyon);
                            commit;
                   
                        when 'OSI Source' then

                            insert into t_osi_a_compint_source (sid,compint,src_type,description,recontactable,osi_source,create_by,create_on,modify_by,modify_on) values 
                                                               (v_Source_SID,p_RemoteSid,v_SourceType_SID,s_rec.description,s_rec.sourceavailableforrecontact,s_rec.source,s_rec.createby,s_rec.createon,s_rec.modifyby,s_rec.modifyon);
                            commit;
     
                        when 'One-Time Source' then
                            
                            begin
                                 select current_version into v_Participant_Version_SID from t_osi_participant where sid=s_rec.source;                         
                            
                            exception when others then

                                     -- Feedback -- 
                                     INSERT_FEEDBACK( 'T_SOURCESOFINFORMATION',s_rec.sid,'T_OSI_A_COMPINT_SOURCE-Failed to Load Source Type: ' || s_rec.sourcetype || ', could not find VersionSid for :' || s_rec.source,v_Source_SID, SQLERRM);
                            
                            end;
                            
                            insert into t_osi_a_compint_source (sid,compint,src_type,description,recontactable,one_time_source,ots_protection_reqd,create_by,create_on,modify_by,modify_on) values 
                                                               (v_Source_SID,p_RemoteSid,v_SourceType_SID,s_rec.description,s_rec.sourceavailableforrecontact,v_Participant_Version_SID,s_rec.sourceprotectionrequired,s_rec.createby,s_rec.createon,s_rec.modifyby,s_rec.modifyon);
                            commit;
                                  
                        when 'Other US Agency' then

                            begin
                                 select current_version into v_Participant_Version_SID from t_osi_participant where sid=s_rec.source;                         
                            
                            exception when others then

                                     -- Feedback -- 
                                     INSERT_FEEDBACK( 'T_SOURCESOFINFORMATION',s_rec.sid,'T_OSI_A_COMPINT_SOURCE-Failed to Load Source Type: ' || s_rec.sourcetype || ', could not find VersionSid for :' || s_rec.source,v_Source_SID, SQLERRM);
                            
                            end;
                            insert into t_osi_a_compint_source (sid,compint,src_type,recontactable,one_time_source,create_by,create_on,modify_by,modify_on) values 
                                                               (v_Source_SID,p_RemoteSid,v_SourceType_SID,s_rec.sourceavailableforrecontact,v_Participant_Version_SID,s_rec.createby,s_rec.createon,s_rec.modifyby,s_rec.modifyon);
                            commit;
                       
                    end case;
               
               exception when others then

                        -- Feedback -- 
                        INSERT_FEEDBACK( 'T_SOURCESOFINFORMATION',s_rec.sid,'T_OSI_A_COMPINT_SOURCE-Failed to Load Source Type: ' || s_rec.sourcetype,v_Source_SID, SQLERRM);
                                                                          
               end;
               
               -- Feedback -- 
               INSERT_FEEDBACK('T_SOURCESOFINFORMATION',s_rec.sid,'T_OSI_A_COMPINT_SOURCE',v_Source_SID);

           end loop;           
           
       end loop;

       -- Feedback -- 
       INSERT_FEEDBACK('SYNC_LOCAL_ACT_COMP_INT','  End-' || sysdate, '-', '-');
           
    exception
        when others then
            INSERT_FEEDBACK('SYNC_LOCAL_ACT_COMP_INT', 'SYNC_LOCAL_ACT_COMP_INT', 'SYNC_LOCAL_ACT_COMP_INT', 'SYNC_LOCAL_ACT_COMP_INT', SQLERRM);

  end SYNC_LOCAL_ACT_COMP_INT;
   
end osi_local_synchronization;
/


