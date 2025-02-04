-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_sfs_investigation as
/******************************************************************************
   Name:     osi_sfs_investigation
   Purpose:  Provides functionality for the SFS Investigation File.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------------
    09-AUG-2010  T. Whitehead    Created this package
    06-Jul-2011  Tim Ward        CR#3600 - Allo Creating DCII Indexing file from Dev/Info Files.
                                  Added clone_to_dcii.

******************************************************************************/

    /* Given an object sid as p_obj, returns a default file tagline. */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given an object sid as p_obj, return a summary.  Can pass a variant
       in p_variant to affect the format of the results (i.e. HTML). */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    /* Given an object sid as p_obj and a reference to a clob, will fill in
       the clob with xml data to be used for the doc1 index .*/
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given an object sid as p_obj, will return the current status of the file. */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* Will take all necessary steps to create a new instance of this type of object. */
    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_background    in   varchar2,
        p_summary       in   varchar2)
        return varchar2;

    /* Returns Y if the input object is writable (not read-only). */
    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2;

    function clone_to_dcii(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) return varchar2;

/* Begin report routines. */
end osi_sfs_investigation;
/


CREATE OR REPLACE package body osi_sfs_investigation as
/******************************************************************************
   Name:     osi_sfs_investigation
   Purpose:  Provides functionality for the SFS Investigation File.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------------
    09-AUG-2010  T. Whitehead    Created this package
    06-Jul-2011  Tim Ward        CR#3600 - Allo Creating DCII Indexing file from Dev/Info Files.
                                  Added clone_to_dcii.

******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'osi_sfs_investigation';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_file.get_tagline(p_obj);
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_file.get_summary(p_obj, p_variant);
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_file.index1(p_obj, p_clob);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_file.get_status(p_obj);
    end get_status;

    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_background    in   varchar2,
        p_summary       in   varchar2)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
    begin
        -- Common file creation,
        -- handles t_core_obj, t_osi_file, starting status, lead assignment, unit owner
        v_sid := osi_file.create_instance(p_obj_type, p_title, p_restriction);

        insert into t_osi_f_sfs_investigation
                    (sid, background, summary)
             values (v_sid, p_background, p_summary);

        return v_sid;
    exception
        when others then
            log_error('osi_sfs_investigation.create_instance: ' || sqlerrm);
    end create_instance;

    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_obj_type   t_core_obj_type.sid%type;
        v_status     t_osi_status.code%type;
    begin
        v_obj_type := core_obj.get_objtype(p_obj);
        v_status := osi_object.get_status_code(p_obj);

        if (v_status = 'AA') then
            --Check for Approval Privilege
            return osi_auth.check_for_priv
                                        ('APPROVE',
                                         v_obj_type,
                                         core_context.personnel_sid,
                                         osi_personnel.get_current_unit(core_context.personnel_sid));
        elsif(v_status = 'AC') then
            --Check for Closure Priv
            return osi_auth.check_for_priv
                                        ('CLOSE',
                                         v_obj_type,
                                         core_context.personnel_sid,
                                         osi_personnel.get_current_unit(core_context.personnel_sid));
        elsif(   v_status = 'CL'
              or v_status = 'SV'
              or v_status = 'AV'
              or v_status = 'RV') then
            return osi_auth.check_for_priv
                                        ('BR_BYPASS',
                                         v_obj_type,
                                         core_context.personnel_sid,
                                         osi_personnel.get_current_unit(core_context.personnel_sid));
        else
            return 'Y';
        end if;
    exception
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

/* p_parameter1 is a list of Subjects to Create the Case with (separated with a ~) */
function clone_to_dcii(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) return varchar2 is

        v_new_sid        t_core_obj.SID%type;
        v_old_id         t_osi_file.id%type;
        v_new_id         t_osi_file.id%type;
        v_close_status   t_osi_status.SID%type;
        v_note_sid       t_osi_note.SID%type;
        v_starting_status  t_osi_status.sid%type;

begin
     --- clone object ---
     insert into t_core_obj (obj_type)
             values (core_obj.lookup_objtype('FILE.SFS')) returning SID into v_new_sid;

     v_new_id := osi_object.get_next_id;

     --- clone basic file info ---
     insert into t_osi_file (SID, id, title, closed_short, restriction)
           select v_new_sid, v_new_id, title, closed_short, restriction from t_osi_file where SID = p_sid;

     --- clone investigation ---
     insert into t_osi_f_sfs_investigation
                (SID,
                 background,
                 summary)
        select v_new_sid, summary_allegation, summary_investigation
          from t_osi_f_investigation
         where SID = p_sid;

    --- clone ONLY subjects that were selected by the user ---
    insert into t_osi_partic_involvement
               (obj,
                participant_version,
                involvement_role,
                num_briefed,
                action_date,
                response,
                response_date,
                agency_file_num,
                report_to_dibrs,
                report_to_nibrs,
                reason)
        select v_new_sid, participant_version, involvement_role, num_briefed, action_date,
               response, response_date, agency_file_num, report_to_dibrs, report_to_nibrs,
               reason
          from t_osi_partic_involvement
         where obj=p_sid and involvement_role in (select sid from t_osi_partic_role_type where role='Subject') and participant_version in  (select * from table(split(p_parameter1,'~')) where column_value is not null);

    --- clone victims and agencies ---
    insert into t_osi_partic_involvement
               (obj,
                participant_version,
                involvement_role,
                num_briefed,
                action_date,
                response,
                response_date,
                agency_file_num,
                report_to_dibrs,
                report_to_nibrs,
                reason)
        select v_new_sid, participant_version, involvement_role, num_briefed, action_date,
               response, response_date, agency_file_num, report_to_dibrs, report_to_nibrs,
               reason
          from t_osi_partic_involvement
         where obj=p_sid and involvement_role in (select sid from t_osi_partic_role_type where role not in 'Subject');

    --- clone activity associations ---
    insert into t_osi_assoc_fle_act (file_sid, activity_sid, resource_allocation)
        select v_new_sid, activity_sid, resource_allocation
          from t_osi_assoc_fle_act
         where file_sid = p_sid;

    --- clone file associations ---
    insert into t_osi_assoc_fle_fle (file_a, file_b)
        select v_new_sid, file_b
          from t_osi_assoc_fle_fle
         where file_a = p_sid;

    insert into t_osi_assoc_fle_fle (file_a, file_b)
        select file_a, v_new_sid
          from t_osi_assoc_fle_fle
         where file_b = p_sid;

    --- associate to current file ---
    insert into t_osi_assoc_fle_fle (file_a, file_b) values (v_new_sid, p_sid);

    --- clone assignments ---
    insert into t_osi_assignment (obj, personnel, assign_role, start_date, end_date, unit)
        select v_new_sid, personnel, assign_role, start_date, end_date, unit from t_osi_assignment
         where obj = p_sid;

    --- set unit ownership to current user's unit ---
    osi_file.set_unit_owner(v_new_sid);

    --- save status ---
    select starting_status into v_starting_status from t_osi_obj_type ot, t_core_obj_type ct
         where ot.sid=ct.sid and ct.code='FILE.SFS';
        
    insert into t_osi_status_history
                (obj, status, effective_on, transition_comment, is_current) values
                (v_new_sid, v_starting_status, sysdate, 'Created', 'Y');

    select id into v_old_id from t_osi_file where SID = p_sid;

    --- Add Note ---
    v_note_sid := osi_note.add_note(v_new_sid, osi_note.get_note_type(core_obj.lookup_objtype('FILE.SFS'), 'CREATE'), 'This DCII Indexing File was created using the following File:  ' || v_old_id || '.');
    return v_new_sid;

exception when others then

    log_error('clone_to_dcii: ' || sqlerrm);
    raise;
        
end clone_to_dcii;

end osi_sfs_investigation;
/