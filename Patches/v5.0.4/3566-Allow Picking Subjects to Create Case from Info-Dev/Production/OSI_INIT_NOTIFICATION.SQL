-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE           "OSI_INIT_NOTIFICATION" is
/******************************************************************************
   Name:     osi_init_notification
   Purpose:  Provides functionality for Initial Notification objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    30-Oct-2009 T.Whitehead     Created Package.
    02-Nov-2009 T.Whitehead     Added clone.
    05-Nov-2009 T.Whitehead     Added create_case_file.
******************************************************************************/
    /*
     * Creates a case file from the given Initial Notification Activity.
     */
    function create_case_file(p_obj in varchar2)
        return varchar2;

    function create_instance(
        p_title         in   varchar2,
        p_notified_by   in   varchar2,
        p_notified_on   in   varchar2,
        p_restriction   in   varchar2,
        p_narrative     in   clob)
        return varchar2;

    function get_status(p_obj in varchar2)
        return varchar2;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    function get_tagline(p_obj in varchar2)
        return varchar2;

    procedure clone(p_obj in varchar2, p_new_sid in varchar2);

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);
end osi_init_notification;
/


CREATE OR REPLACE PACKAGE BODY           "OSI_INIT_NOTIFICATION" is
/******************************************************************************
   Name:     osi_init_notification
   Purpose:  Provides functionality for Initial Notification objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    30-Oct-2009 T.Whitehead     Created Package.
    02-Nov-2009 T.Whitehead     Added clone.
    05-Nov-2009 T.Whitehead     Added create_case_file.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_INIT_NOTIFICATION';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    function create_case_file(p_obj in varchar2)
        return varchar2 is
        v_file_sid      t_core_obj.sid%type;
        v_file_type     t_core_obj_type.sid%type;
        v_fbi_loc_num   t_osi_unit.fbi_loc_num%type;
        v_special_int   varchar2(4000);
        v_temp_sid      varchar2(20);
        v_temp_str      varchar2(200);
    begin
        v_file_type := core_obj.lookup_objtype('FILE.INV.CASE');

        for x in (select a.title, a.narrative, a.restriction, a.activity_date,
                         a.creating_unit, n.begin_date, n.end_date, n.reported_date,
                         n.mission_area
                    from t_osi_activity a, t_osi_a_init_notification n
                   where a.sid = n.sid and n.sid = p_obj)
        loop
            -- Skipping osi_file.create_instance because we have a custom starting status note.
            insert into t_core_obj
                        (obj_type)
                 values (v_file_type)
              returning sid
                   into v_file_sid;

            insert into t_osi_file
                        (sid, title, id, restriction)
                 values (v_file_sid, x.title, osi_object.get_next_id, x.restriction);

            -- Set the starting status.
            osi_status.change_status_brute(v_file_sid, osi_status.get_starting_status(v_file_type),
                                           'Created from Inital Notification Activity');
            osi_object.create_lead_assignment(v_file_sid);
            osi_file.set_unit_owner(v_file_sid);
            
            --- Insert a Investigation File Record ---
            insert into t_osi_f_investigation
                        (sid, manage_by, summary_allegation)
                 values (v_file_sid, x.mission_area, x.narrative);
            
            --- Copy the Special Interests from the Activity to the File ---
            v_special_int := osi_object.get_special_interest(p_obj);
            osi_object.set_special_interest(v_file_sid, v_special_int);
            
            -- Investigative support doesn't apply.
            --- Create an incident in the File if any of the Dates were filled in the Activity ---
            if(    x.begin_date is not null
                or x.end_date is not null
                or x.reported_date is not null)then

                select fbi_loc_num
                  into v_fbi_loc_num
                  from t_osi_unit
                 where sid = x.creating_unit;
                 
                insert into t_osi_f_inv_incident
                            (start_date, end_date, report_date, fbi_loc_num)
                     values (x.begin_date, x.end_date, x.reported_date, v_fbi_loc_num)
                     returning sid into v_temp_sid;
                                 
                insert into t_osi_f_inv_incident_map
                            (investigation, incident)
                     values (v_file_sid, v_temp_sid);            
            end if;
            
            --- Copy the Subject if created in the Activity ---
            for p in (select pi.participant_version
                        from t_osi_partic_involvement pi,
                             t_osi_partic_role_type rt
                       where pi.obj = p_obj
                         and pi.involvement_role = rt.sid
                         and rt.obj_type member of osi_object.get_objtypes(p_obj)
                         and rt.code = 'SUBJECT'
                         and rt.usage = 'PARTICIPANTS')loop
                
                select sid into v_temp_sid
                  from t_osi_partic_role_type
                 where code = 'SUBJECT'
                   and usage = 'SUBJECT'
                   and obj_type member of osi_object.get_objtypes(v_file_type);
                
                insert into t_osi_partic_involvement
                            (obj, participant_version, involvement_role)
                     values (v_file_sid, p.participant_version, v_temp_sid);
                     
                for n in (select last_name
                            from v_osi_partic_name
                           where participant_version = p.participant_version
                             and is_current = 'Y')loop
                    
                    v_temp_str := n.last_name || ' (S); ';
                end loop;
            end loop;
            
            --- Copy the Victim over if created in the Activity ---
            for p in (select pi.participant_version
                        from t_osi_partic_involvement pi,
                             t_osi_partic_role_type rt
                       where pi.obj = p_obj
                         and pi.involvement_role = rt.sid
                         and rt.obj_type member of osi_object.get_objtypes(p_obj)
                         and rt.code = 'VICTIM'
                         and rt.usage = 'PARTICIPANTS')loop
                         
                select sid into v_temp_sid
                  from t_osi_partic_role_type
                 where code = 'VICTIM'
                   and usage = 'VICTIM'
                   and active = 'Y'
                   and obj_type member of osi_object.get_objtypes(v_file_type);
                   
                insert into t_osi_partic_involvement
                            (obj, participant_version, involvement_role)
                     values (v_file_sid, p.participant_version, v_temp_sid);
                     
                for n in (select last_name
                            from v_osi_partic_name
                           where participant_version = p.participant_version
                             and is_current = 'Y')loop
                    
                    v_temp_str := v_temp_str || n.last_name || ' (V);';
                end loop;
            end loop;
            
            if(v_temp_str is not null)then
                update t_osi_file
                   set title = v_temp_str
                 where sid = v_file_sid;
            end if;
            
            --- Copy the Notified By into the file as Referred to OSI ---
            for p in (select pi.participant_version, pi.involvement_role
                        from t_osi_partic_involvement pi,
                             t_osi_partic_role_type rt
                       where pi.obj = p_obj
                         and pi.involvement_role = rt.sid
                         and rt.obj_type member of osi_object.get_objtypes(p_obj)
                         and rt.code = 'NOTIFIED'
                         and rt.usage = 'PARTICIPANT')loop
                
                select sid into v_temp_sid
                  from t_osi_partic_role_type
                 where obj_type member of osi_object.get_objtypes(v_file_sid)
                   and code = 'REFTO'
                   and usage = 'OTHER AGENCIES';

                insert into t_osi_partic_involvement
                            (obj, participant_version, involvement_role)
                     values (v_file_sid, p.participant_version, v_temp_sid);
            end loop;
            
            --- Associate the File and Activity ---
            insert into t_osi_assoc_fle_act
                        (file_sid, activity_sid)
                 values (v_file_sid, p_obj);

            --- Copy the Activity Assignments to the File ---
            for p in (select personnel, assign_role, start_date, unit
                        from t_osi_assignment
                       where obj = p_obj
                         and end_date is null
                         and personnel <> core_context.personnel_sid)loop
                
                insert into t_osi_assignment
                            (obj, personnel, assign_role, start_date, unit)
                      values(v_file_sid, p.personnel, p.assign_role, p.start_date, p.unit);
            end loop;
        end loop;

        return v_file_sid;
    exception
        when others then
            log_error('create_case_file: ' || sqlerrm);
            raise;
    end create_case_file;

    function create_instance(
        p_title         in   varchar2,
        p_notified_by   in   varchar2,
        p_notified_on   in   varchar2,
        p_restriction   in   varchar2,
        p_narrative     in   clob)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
        v_obj_type t_core_obj_type.sid%type;
    begin
        v_obj_type := core_obj.lookup_objtype('ACT.INIT_NOTIF');
        v_sid :=
            osi_activity.create_instance(v_obj_type,
                                         p_notified_on,
                                         p_title,
                                         p_restriction,
                                         p_narrative);

        insert into t_osi_a_init_notification
                    (sid)
             values (v_sid);
        
        if(p_notified_by is not null)then
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_notified_by,
                         (select sid
                            from t_osi_partic_role_type
                           where obj_type member of osi_object.get_objtypes(v_obj_type) 
                             and usage = 'PARTICIPANT'
                             and code = 'NOTIFIED'));
        end if;
        return v_sid;
    end create_instance;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_in_record   t_osi_a_init_notification%rowtype;
    begin
        select *
          into v_in_record
          from t_osi_a_init_notification
         where sid = p_obj;

        insert into t_osi_a_init_notification
                    (sid, begin_date, end_date, reported_date, mission_area)
             values (p_new_sid,
                     v_in_record.begin_date,
                     v_in_record.end_date,
                     v_in_record.reported_date,
                     v_in_record.mission_area);
    exception
        when others then
            log_error('osi_init_notification.clone: ' || sqlerrm);
            raise;
    end clone;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;
end osi_init_notification;
/

