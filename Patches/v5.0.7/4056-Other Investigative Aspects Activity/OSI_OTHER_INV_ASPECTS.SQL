-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE           "OSI_OTHER_INV_ASPECTS" as
/*************************************************************************************
   Name:     osi_other_inv_aspects
   Purpose:  Provides Functionality For Other Investigative Aspects Activity Objects.

   Revisions:
    Date         Author          Description
    -----------  --------------  ----------------------------------------------
    06-Jun-2012  Tim Ward        CR#4056 - Created Package from OSI_EXCEPTION.

*************************************************************************************/

    /* Given a sid (p_obj), this function returns a default tagline.  Currently using the default activity tagline */
    function get_tagline(p_obj in varchar2) return varchar2;

    /* Given a sid (p_obj), returns a summary.  Can pass a variant in p_variant to affect the format of the results (i.e. HTML) Currently using the default activity summary */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null) return clob;

    /* Given a sid (p_obj) and a reference to a clob, will fill in the clob with xml data to be used for the doc1 index Currently using the default activity index1 */
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given a sid (p_obj), will return the current status of the Other Investigative Aspects Activity. Currently using the default activity status */
    function get_status(p_obj in varchar2) return varchar2;

    /* This function creates a new Other Investigative Aspects Activity instance and returns the new sid */
    function create_instance(p_title in varchar2, p_explanation in varchar2, p_act_date in date, p_restriction in varchar2, p_narrative in clob, p_participant in varchar2 := '', p_participant_role in varchar2 := '') return varchar2;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2);

end osi_OTHER_INV_ASPECTS;
/

CREATE OR REPLACE PACKAGE BODY           "OSI_OTHER_INV_ASPECTS" as
/*************************************************************************************
   Name:     osi_other_inv_aspects
   Purpose:  Provides Functionality For Other Investigative Aspects Activity Objects.

   Revisions:
    Date         Author          Description
    -----------  --------------  ----------------------------------------------
    06-Jun-2012  Tim Ward        CR#4056 - Created Package from OSI_EXCEPTION.

*************************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_OTHER_INV_ASPECTS';

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
            log_error('get_summary: p_obj = ' || nvl(p_obj, 'null') || ', p_variant = ' || nvl(p_variant, 'null') || '. Error is: ' || sqlerrm);
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

    -- the create_instance function is not being used by the application for the Other Investigative Aspects Activity
    -- the osi_activity.create_instance is being used with a general activity create page
    function create_instance(
        p_title              in   varchar2,
        p_explanation        in   varchar2,
        p_act_date           in   date,
        p_restriction        in   varchar2,
        p_narrative          in   clob,
        p_participant        in   varchar2 := '',
        p_participant_role   in   varchar2 := '')
        return varchar2 is
        v_sid                t_core_obj.sid%type;
        v_participant_role   varchar2(20);
    begin
        v_sid :=
            osi_activity.create_instance(core_obj.lookup_objtype('ACT.OTHER.INV.ASPECTS'),
--                                         null,
                                         p_act_date,
                                         p_title,
                                         p_restriction,
                                         p_narrative);

        --        insert into t_osi_a_OTHER_INV_ASPECTS
        --                    (sid, explanation, activity_date)
        --             values (v_sid, p_explanation, p_act_date);
        if p_participant is not null then
            begin
                if p_participant_role is not null then
                    v_participant_role := p_participant_role;
                else
                    select sid
                      into v_participant_role
                      from t_osi_partic_role_type
                     where usage = 'PARTICIPANTS'
                       and obj_type = core_obj.lookup_objtype('ACT.OTHER.INV.ASPECTS')
                       and upper(role) = 'OTHER PARTICIPANT';
                end if;

                insert into t_osi_partic_involvement i
                            (obj, participant_version, involvement_role)
                     values (v_sid, p_participant, v_participant_role);
            exception
                when others then
                    log_error
                        ('create_instance: error attempting insert into t_osi_partic_involvement. v_sid = '
                         || v_sid || ', p_participant = ' || nvl(p_participant, 'null')
                         || ', p_participant_role = ' || nvl(p_participant_role, 'null'));
            end;
        end if;

        core_obj.bump(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: p_title = ' || nvl(p_title, 'null') || ', p_explanation = '
                      || nvl(p_explanation, 'null') || ', p_act_date = '
                      || to_char(nvl(p_act_date,
                                     to_date('01-JAN-1900 00:00', 'DD-MON-YYYY HH24:MI')),
                                 'DD-MON-YYYY HH24:MI')
                      || ', p_restriction = ' || nvl(p_restriction, 'null') || '. Error is: '
                      || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_other_inv_aspects_rec t_osi_activity%rowtype;
    begin
        -- NO ADDITIONAL PROCESSING IS NEEDED FOR THE Other Investigative Aspects Activity. EVERYTHING THAT NEEDS
        -- TO BE DONE IS DONE IN THE OSI_STATUS_PROC PACKAGE.
        --Get Exception Activity record just to record the exception if it does not exist
        select *
          into v_other_inv_aspects_rec
          from t_osi_activity
         where sid = p_obj;
    exception
        when others then
            log_error('osi_v_other_inv_aspects_rec.clone: p_obj = ' || nvl(p_obj, 'null') || ', p_new_sid = '
                      || nvl(p_new_sid, 'null') || '. Error is: ' || sqlerrm);
            raise;
    end clone;
end osi_OTHER_INV_ASPECTS;
/

