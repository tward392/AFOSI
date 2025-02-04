-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_RECORDS_CHECK" as
/******************************************************************************
   Name:     osi_records_check
   Purpose:  Provides Functionality For Law Enforcement Records Check Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    05-Jun-2009 M.Batdorf       Created this package spec. get_tagline, get_summary, index1,
                                get_status, create_instance, and clone.
    14-Jul-2009 T.McGuffin      Removed participant and participant role from create_instance.
    19-Mar-2012 Tim Ward        CR#3696 - Create Multiple Records Check Activities at Once.
                                 Added p_subject_of_activity, p_file_sid, p_work_hours_fields, and
                                 p_complete to create_instance paramters.

******************************************************************************/

    /* Given a Law Enforcement Records Check sid (p_obj), this function returns a default Law Enforcement Records Check  tagline.
       Currently using the default activity tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given a Law Enforcement Records Check  sid (p_obj), returns a summary.  Can pass a variant
       in p_variant to affect the format of the results (i.e. HTML)
       Currently using the default activity summary */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    /* Given a Law Enforcement Records Check  sid (p_obj) and a reference to a clob, will fill in
       the clob with xml data to be used for the doc1 index
       Currently using the default activity index1 */
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given a Law Enforcement Records Check  sid (p_obj), will return the current status of the Law Enforcement Records Check .
       Currently using the default activity status */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* This function creates a new Law Enforcement Records Check instance and returns the new sid */
    function create_instance(
        p_title               in   varchar2,
        p_reference_num       in   varchar2,
        p_doc_type            in   varchar2,
        p_act_date            in   date,
        p_restriction         in   varchar2,
        p_narrative           in   clob,
        p_subject_of_activity in varchar2,
        p_file_sid            in varchar2,
        p_work_hours_fields   in varchar2,
        p_complete            in varchar2)
        return varchar2;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2);
end osi_records_check;
/


CREATE OR REPLACE PACKAGE BODY "OSI_RECORDS_CHECK" as
/******************************************************************************
   Name:     osi_records_check
   Purpose:  Provides Functionality For Law Enforcement Records Check Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    05-Jun-2009 M.Batdorf       Created this package body. get_tagline, get_summary, index1,
                                get_status, create_instance, and clone.
    14-Jul-2009 T.McGuffin      Removed participant and participant role from create_instance.
    19-Mar-2012 Tim Ward        CR#3696 - Create Multiple Records Check Activities at Once.
                                 Added p_subject_of_activity, p_file_sid, p_work_hours_fields, and
                                 p_complete to create_instance paramters.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_RECORDS_CHECK';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: p_obj = ' || nvl(p_obj, 'null') || ', p_variant = '
                      || nvl(p_variant, 'null') || '. Error is: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function create_instance(
        p_title               in   varchar2,
        p_reference_num       in   varchar2,
        p_doc_type            in   varchar2,
        p_act_date            in   date,
        p_restriction         in   varchar2,
        p_narrative           in   clob,
        p_subject_of_activity in varchar2,
        p_file_sid            in varchar2,
        p_work_hours_fields   in varchar2,
        p_complete            in varchar2)
        return varchar2 is
        v_sid                 t_core_obj.sid%type;
        v_pv_sid              varchar2(20);
        v_participant_role    varchar2(20);
        v_wh_pay_cat          varchar2(20);
        v_wh_duty_cat         varchar2(20);
        v_wh_mission          varchar2(20);
        v_wh_work_date        date;
        v_wh_hours            number;
        v_field_count         number;
        v_complete_status_sid varchar2(20);
        v_obj_type_sid        varchar2(20) := core_obj.lookup_objtype('ACT.RECORDS_CHECK');
    begin
         --- Create the Activity ---
         v_sid := osi_activity.create_instance(v_obj_type_sid,
                                               p_act_date,
                                               p_title,
                                               p_restriction,
                                               p_narrative);
         
         --- Add the Association to the File, if the user entered it ---
         if (p_file_sid is not null) then
         
           insert into t_osi_assoc_fle_act (file_sid, activity_sid) values (p_file_sid, v_sid);
           
         end if;
         
         --- Added the Subject of Activity, if the user entered it ---
         if (p_subject_of_activity is not null) then
           begin
                --- Get the Subject of Activity Role Type SID for Records Check Activities ---
                select sid into v_participant_role from t_osi_partic_role_type where obj_type=core_obj.lookup_objtype('ACT.RECORDS_CHECK') and role='Subject of Activity';
                
                --- Make sure we get the latest Participant Version SID ---
                select participant into v_pv_sid from t_osi_participant_version pv where pv.sid=p_subject_of_activity or pv.participant=p_subject_of_activity;

                select current_version into v_pv_sid from t_osi_participant where sid=v_pv_sid;                
                
                --- Add the Subject of Activity Record ---
                insert into t_osi_partic_involvement (obj, participant_version, involvement_role) values
                                                     (v_sid, v_pv_sid, v_participant_role);
                
           exception when others then
                   
                   null;
                   
           end;
           
         end if;
          
         --- Create the Records Check Activity Record ---
         insert into t_osi_a_records_check (sid, reference_num, doc_type) values (v_sid, p_reference_num, p_doc_type);

         core_obj.bump(v_sid);
         
         --- Create Work Hours Entry ---
         v_field_count := 1;
         for wh in (select column_value from table(split(p_work_hours_fields,'~')))
         loop
             case v_field_count
             
                 when 1 then
                            v_wh_pay_cat := wh.column_value;
                 when 2 then
                            v_wh_duty_cat := wh.column_value;
                 when 3 then
                            v_wh_mission := wh.column_value;
                 when 4 then
                            v_wh_work_date := to_date(wh.column_value);
                 when 5 then
                            v_wh_hours := to_number(wh.column_value);
                 
             end case;
             v_field_count := v_field_count+1;

         end loop;

         --- Make sure we have the required fields ---
         if v_wh_pay_cat is not null and v_wh_duty_cat is not null and v_wh_work_date is not null and v_wh_hours is not null then

           insert into t_osi_work_hours (PERSONNEL,OBJ,WORK_DATE,PAY_CAT,DUTY_CAT,MISSION,HOURS) VALUES
             (core_context.personnel_sid,v_sid,v_wh_work_date,v_wh_pay_cat,v_wh_duty_cat,v_wh_mission,v_wh_hours);
             
         end if;
         
         if (p_complete='Y') then 
           
           if (osi_checklist.checklist_complete(v_sid,v_complete_status_sid))='Y' then

             select c.sid into v_complete_status_sid from t_osi_status_change c,t_osi_status ts,t_osi_status fs
                  where c.to_status=ts.sid 
                    and c.OBJ_TYPE=v_obj_type_sid
                    and c.from_status=fs.sid
                    and fs.DESCRIPTION='Open';
                            
             osi_status.change_status(v_sid,v_complete_status_sid);
             
           end if;
           
         end if;
                 
         return v_sid;
        
    exception
        when others then
            log_error('create_instance: p_title = ' || nvl(p_title, 'null') || ', p_doc_type = '
                      || p_doc_type || ', p_reference_num = ' || nvl(p_reference_num, 'null')
                      || ', p_act_date = '
                      || to_char(nvl(p_act_date,
                                     to_date('01-JAN-1900 00:00', 'DD-MON-YYYY HH24:MI')),
                                 'DD-MON-YYYY HH24:MI')
                      || ', p_restriction = ' || nvl(p_restriction, 'null') || '. Error is: '
                      || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_recchk_rec   t_osi_a_records_check%rowtype;
    begin
        --Get Law Enforcement Records Check Activity record
        select *
          into v_recchk_rec
          from t_osi_a_records_check
         where sid = p_obj;

        --Insert a new Law Enforcement Records Check Activity record
        insert into t_osi_a_records_check
                    (sid, doc_type, reference_num)
             values (p_new_sid, v_recchk_rec.doc_type, v_recchk_rec.reference_num);
    exception
        when others then
            log_error('osi_records_check.clone: p_obj = ' || nvl(p_obj, 'null') || ', p_new_sid = '
                      || nvl(p_new_sid, 'null') || '. Error is: ' || sqlerrm);
            raise;
    end clone;
end osi_records_check;
/

