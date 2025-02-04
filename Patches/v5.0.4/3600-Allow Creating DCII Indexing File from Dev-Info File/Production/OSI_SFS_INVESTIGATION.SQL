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
end osi_sfs_investigation;
/