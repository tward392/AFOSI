-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_GENERIC_FILE" as
/******************************************************************************
   Name:     Osi_Generic_File
   Purpose:  Provides Functionality For Generic_File File Objects.

   Revisions:
    Date         Author          Description
    ----------   --------------  ------------------------------------
     7-Apr-2009  T.McGuffin      Created Package
    28-May-2009  T.McGuffin      Added get_objective_activities and get_objective_files functions.
    28-May-2009  T.McGuffin      Added set_objective_activities and set_objective_files procedures.
    28-May-2009  T.McGuffin      Added get_objective_sid and set_objective_sid.
    24-Jun-2009  T.McGuffin      Modified create_instance to load standard objectives.
    21-Jan-2010  T.McGuffin      Added check_writability
    04-Feb-2011  Tim Ward        CR#3540 - Load Standard Objectives Message.
                                  Changed load_standard_objectives from a procedure to a function
                                  that returns sql%rowcount.
******************************************************************************
    * Given an object sid as p_obj, returns a default activity tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given an object sid as p_obj, return a summary.  Can pass a variant
       in p_variant to affect the format of the results (i.e. HTML) */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    /* Given an object sid as p_obj and a reference to a clob, will fill in
       the clob with xml data to be used for the doc1 index */
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given an object sid as p_obj, will return the current status of the file */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* Will take all necessary steps to create a new instance of this type of object */
    function create_instance(
        p_obj_type         in   varchar2,
        p_title            in   varchar2,
        p_restriction      in   varchar2,
        p_std_objectives   in   varchar2)
        return varchar2;

    /* Given an objective sid for a generic file, will return an apex-friendly colon-delimited
       list of activity sids that support the objective */
    function get_objective_activities(p_objective_sid in varchar2)
        return varchar2;

    /* Given an objective sid for a generic file, will return an apex-friendly colon-delimited
       list of file sids that support the objective */
    function get_objective_files(p_objective_sid in varchar2)
        return varchar2;

    /* Given an objective sid for a generic file and a colon-delimited list of activity sids,
       will synch the list with t_osi_f_generic_objective_act for that objective */
    procedure set_objective_activities(p_objective_sid in varchar2, p_activities in varchar2);

    /* Given an objective sid for a generic file and a colon-delimited list of file sids,
       will synch the list with t_osi_f_generic_objective_file for that objective */
    procedure set_objective_files(p_objective_sid in varchar2, p_files in varchar2);

    /* Used to set and get a new objective created through an instead of trigger (thus
       preventing the possibility of RETURNING INTO */
    procedure set_objective_sid(p_sid varchar2);

    function get_objective_sid
        return varchar2;

    function load_standard_objectives(p_obj varchar2) return number;

    /* returns Y when input object is writable */
    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2;
end osi_generic_file;
/


CREATE OR REPLACE PACKAGE BODY "OSI_GENERIC_FILE" as
/******************************************************************************
   Name:     Osi_Generic_File
   Purpose:  Provides Functionality For Generic_File File Objects.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------
    07-Apr-2009  T.McGuffin      Created Package
    26-May-2009  R.Dibble        Modified create_instance to handle Starting Status
    27-May-2009  T.McGuffin      Modified create_instance to use generic OSI_File.Create_Instance.
    28-May-2009  T.McGuffin      Added get_objective_activities and get_objective_files functions.
    28-May-2009  T.McGuffin      Added set_objective_activities and set_objective_files procedures.
    28-May-2009  T.McGuffin      Added get_objective_sid and set_objective_sid.
    21-Jan-2010  T.McGuffin      Added check_writability.
    04-Feb-2011  Tim Ward        CR#3540 - Load Standard Objectives Message.
                                  Changed load_standard_objectives from a procedure to a function
                                  that returns sql%rowcount.
******************************************************************************/
    c_pipe            varchar2(100)
                                   := core_util.get_config('CORE.PIPE_PREFIX')
                                      || 'OSI_GENERIC_FILE';
    v_objective_sid   t_osi_f_gen1_objective.sid%type;

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
        p_obj_type         in   varchar2,
        p_title            in   varchar2,
        p_restriction      in   varchar2,
        p_std_objectives   in   varchar2)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
    begin
        -- Common file creation,
        -- handles t_core_obj, t_osi_file, starting status, lead assignment, unit owner
        v_sid := osi_file.create_instance(p_obj_type, p_title, p_restriction);

        insert into t_osi_f_gen1_file
                    (sid)
             values (v_sid);

        if p_std_objectives = 'Y' then
            insert into t_osi_f_gen1_objective
                        (file_sid, objective, comments)
                select v_sid, objective, comments
                  from t_osi_f_gen1_objective_tmplt
                 where obj_type = p_obj_type;
        end if;

        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
    end create_instance;

    /* Build an array of the activities associated to the objective, and
       convert that array to an apex-friendly colon-delimited list */
    function get_objective_activities(p_objective_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select activity
                    from t_osi_f_gen1_objective_act
                   where objective = p_objective_sid)
        loop
            v_array(v_idx) := i.activity;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_objective_activities: ' || sqlerrm);
            raise;
    end get_objective_activities;

    /* Build an array of the files associated to the objective, and
       convert that array to an apex-friendly colon-delimited list */
    function get_objective_files(p_objective_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select file_sid
                    from t_osi_f_gen1_objective_file
                   where objective = p_objective_sid)
        loop
            v_array(v_idx) := i.file_sid;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_objective_files: ' || sqlerrm);
            raise;
    end get_objective_files;

    /* Translates p_activities (colon-delimited list of activity sids) into an array, then
       loops through and adds those that don't exist already.  Deletes those that no longer
       appear in the list */
    procedure set_objective_activities(p_objective_sid in varchar2, p_activities in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_activities, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_gen1_objective_act
                        (objective, activity)
                select p_objective_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_gen1_objective_act
                                   where objective = p_objective_sid and activity = v_array(i));
        end loop;

        delete from t_osi_f_gen1_objective_act
              where objective = p_objective_sid and instr(nvl(p_activities, 'null'), activity) = 0;
    exception
        when others then
            log_error('set_objective_activities: ' || sqlerrm);
            raise;
    end set_objective_activities;

    /* Translates p_files (colon-delimited list of file sids) into an array, then
       loops through and adds those that don't exist already.  Deletes those that no longer
       appear in the list */
    procedure set_objective_files(p_objective_sid in varchar2, p_files in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_files, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_gen1_objective_file
                        (objective, file_sid)
                select p_objective_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_gen1_objective_file
                                   where objective = p_objective_sid and file_sid = v_array(i));
        end loop;

        delete from t_osi_f_gen1_objective_file
              where objective = p_objective_sid and instr(nvl(p_files, 'null'), file_sid) = 0;
    exception
        when others then
            log_error('set_objective_files: ' || sqlerrm);
            raise;
    end set_objective_files;

    procedure set_objective_sid(p_sid varchar2) is
    begin
        v_objective_sid := p_sid;
    end set_objective_sid;

    function get_objective_sid
        return varchar2 is
    begin
        return v_objective_sid;
    end get_objective_sid;

    function load_standard_objectives(p_obj varchar2) return number is
    begin
        insert into t_osi_f_gen1_objective
                    (file_sid, objective, comments)
            select p_obj, x.objective, o.comments
              from t_osi_f_gen1_objective_tmplt o,
                   (select objective
                      from t_osi_f_gen1_objective_tmplt
                     where obj_type = core_obj.get_objtype(p_obj)
                    minus
                    select objective
                      from t_osi_f_gen1_objective
                     where file_sid = p_obj) x
             where x.objective = o.objective;
             
             return sql%rowcount;
             
    exception
        when others then
            log_error('load_standard_objectives: ' || sqlerrm);
            raise;
    end load_standard_objectives;

    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_obj_type   t_core_obj_type.sid%type;
    begin
        v_obj_type := core_obj.get_objtype(p_obj);

        case osi_object.get_status_code(p_obj)
            when 'NW' then
                return 'Y';
            when 'AA' then
                return 'Y';
            when 'OP' then
                return 'Y';
            when 'AC' then
                return 'Y';
            when 'CL' then
                return 'N';
            when 'SV' then
                return 'N';
            when 'RV' then
                return 'N';
            when 'AV' then
                return 'N';
            else
                return 'Y';
        end case;
    exception
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

end osi_generic_file;
/