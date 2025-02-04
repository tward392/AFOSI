CREATE OR REPLACE PACKAGE BODY "OSI_ASSOC" as
/**
 * Air Force - Office Of Special Investigation
 *    _____  ___________________    _________.___
 *   /  _  \ \_   _____/\_____  \  /   _____/|   |
 *  /  /_\  \ |    __)   /   |   \ \_____  \ |   |
 * /    |    \|     \   /    |    \/        \|   |
 * \____|__  /\___  /   \_______  /_______  /|___|
 *         \/     \/            \/        \/
 *  Investigative Information Management System
 *  .___________    _____    _________
 *  |   \_____  \  /     \  /   _____/
 *  |   |/  ____/ /  \ /  \ \_____  \
 *  |   /       \/    Y    \/        \
 *  |___\_______ \____|__  /_______  /
 *              \/       \/        \/
 *  OSI_ASSOC - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_OSI_ASSOC
   PURPOSE:    Provides functionality Associations in WebI2MS.

    REVISIONS:
    Date         Author            Description
    -----------  ---------------  ------------------------------------
    06-Jun-2010  Richard Dibble   Created this package

******************************************************************************/
    c_pipe                     varchar2(100)
                                         := core_util.get_config('CORE.PIPE_PREFIX')
                                            || 'OSI_ASSOC';
    v_activity_com_attempted   number        := 0;
    v_activity_com             number        := 0;
    v_activity_not_com_priv    number        := 0;
    v_activity_not_com_chkl    number        := 0;
    v_activity_clo_attempted   number        := 0;
    v_activity_clo             number        := 0;
    v_activity_not_clo_priv    number        := 0;
    v_activity_not_clo_chkl    number        := 0;
    v_not_attempted            number        := 0;

    --NOTE: Search for 'TODO' to find incomplete items
    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

/*
    procedure log_error2(p_msg in varchar2) is
    begin
        log_error(p_msg);
        --dbms_output.put_line(p_msg);
    --core_logger.log_it(c_pipe, p_msg);
    end log_error2;
*/  
--Returns T/F as to whether the activity is restricted or not.
    --Note: This function will only work if ACTUAL activity SID's are passed into it
    function activity_is_restricted(p_activity in varchar2)
        return boolean is
    begin
        for k in (select restriction
                    from t_osi_activity
                   where sid = p_activity)
        loop
            if (osi_reference.lookup_ref_code(k.restriction) = 'NONE') then
                return false;
            else
                return true;
            end if;
        end loop;
    exception
        when others then
            log_error('OSI_ASSOC.activity_is_restricted: ' || sqlerrm);
            raise;
    end activity_is_restricted;

    --Returns T/F as to whether the activity CAN or CANNOT be completed
    --Activity must not be completed (No complete date)

    --Note: This function will only work if ACTUAL activity SID's are passed into it
    function activity_can_be_completed(p_activity in varchar2)
        return boolean is
    begin
        --log_error2('Checking Complete-ability of:[' || p_activity || '] - Starting');

        --Check to see if it has a complete date
        for k in (select complete_date
                    from t_osi_activity
                   where sid = p_activity)
        loop
            if (k.complete_date is null) then
                --log_error2('Checking Complete-ability of:[' || p_activity || '] - Returning True');
                return true;
            else
                --log_error2('Checking Complete-ability of:[' || p_activity || '] - Returning False');
                return false;
            end if;
        end loop;
    exception
        when others then
            log_error('OSI_ASSOC.activity_can_be_completed: ' || sqlerrm);
            raise;
    end activity_can_be_completed;

    --Returns T/F as to whether the activity CAN or CANNOT be completed
    --Activity must not be closed (No closed date)

    --Note: This function will only work if ACTUAL activity SID's are passed into it
    function activity_can_be_closed(p_activity in varchar2)
        return boolean is
    begin
        --log_error2('Checking Close-ability of:[' || p_activity || '] - Starting');

        --Check to see if it has a complete date
        for k in (select close_date, complete_date
                    from t_osi_activity
                   where sid = p_activity)
        loop
            if (k.close_date is null and k.complete_date is not null) then
                --To close, you need a null close date, but also must have a non-null complete date
                --log_error2('Checking Close-ability of:[' || p_activity || '] - Returning True');
                return true;
            else
                --log_error2('Checking Close-ability of:[' || p_activity || '] - Returning False');
                return false;
            end if;
        end loop;
    exception
        when others then
            log_error('OSI_ASSOC.activity_can_be_closed: ' || sqlerrm);
            raise;
    end activity_can_be_closed;

    function get_stat_change_sid_com(p_activity in varchar2)
        return varchar2 is
        v_temp   varchar2(4000);
    begin
        --Note, this function is ASSUMING that the activity is able to be moved to the
        --Completed lifecycle state.
        begin
            --First see if there is an explicit status change for this object.
            select sid
              into v_temp
              from t_osi_status_change
             where from_status = osi_object.get_status_sid(p_activity)
               and transition = 'Complete Activity'
               and osi_object.get_objtype_code(obj_type) =
                                       osi_object.get_objtype_code(core_obj.get_objtype(p_activity));
        exception
            when no_data_found then
                --If none was found, grab the ACT. transition
                select sid
                  into v_temp
                  from t_osi_status_change
                 where from_status = osi_object.get_status_sid(p_activity)
                   and transition = 'Complete Activity'
                   and osi_object.get_objtype_code(obj_type) = 'ACT';
        end;

        return v_temp;
    exception
        when others then
            log_error('OSI_ASSOC.get_stat_change_sid_com: ' || sqlerrm);
            raise;
    end get_stat_change_sid_com;

    function get_stat_change_sid_clo(p_activity in varchar2)
        return varchar2 is
        v_temp   varchar2(4000);
    begin
        --Note, this function is ASSUMING that the activity is able to be moved to the
        --Closed lifecycle state.
        begin
            --First see if there is an explicit status change for this object.
            select sid
              into v_temp
              from t_osi_status_change
             where from_status = osi_object.get_status_sid(p_activity)
               and transition = 'Close Activity'
               and osi_object.get_objtype_code(obj_type) =
                                       osi_object.get_objtype_code(core_obj.get_objtype(p_activity));
        exception
            when no_data_found then
                --If none was found, grab the ACT. transition
                select sid
                  into v_temp
                  from t_osi_status_change
                 where from_status = osi_object.get_status_sid(p_activity)
                   and transition = 'Close Activity'
                   and osi_object.get_objtype_code(obj_type) = 'ACT';
        end;

        return v_temp;
    exception
        when others then
            log_error('OSI_ASSOC.get_stat_change_sid_clo: ' || sqlerrm);
            raise;
    end get_stat_change_sid_clo;

    function get_stat_change_auth(p_stat_change_sid in varchar2)
        return varchar2 is
        v_temp   varchar2(4000);
    begin
        select oaat.code
          into v_temp
          from t_osi_status_change osc, t_osi_auth_action_type oaat
         where osc.sid = p_stat_change_sid and oaat.sid = osc.auth_action;

        return v_temp;
    exception
        when others then
            log_error('OSI_ASSOC.get_stat_change_auth: ' || sqlerrm);
            raise;
    end get_stat_change_auth;

    procedure complete_single_activity(p_activity in varchar2) is
        v_stat_change_sid   t_osi_status_change.sid%type;
        v_auth_action       t_osi_status_change.auth_action%type;
    begin
        --Only update this counter if the COMPLETE is successful
        v_stat_change_sid := get_stat_change_sid_com(p_activity);
        v_auth_action := get_stat_change_auth(v_stat_change_sid);

        --Check for permission
        if (v_auth_action is not null) then
            if (osi_auth.check_for_priv(v_auth_action, core_obj.get_objtype(p_activity)) <> 'Y') then
                --If a PRIV is required, and the user has it not, then return without
                --doing the complete or incrementing the complete counter.
                v_activity_not_com_priv := v_activity_not_com_priv + 1;
                return;
            end if;
        end if;

        --Check for checklist completion
        if (osi_checklist.checklist_complete(p_activity, v_stat_change_sid) <> 'Y') then
            --Increment failure counter
            v_activity_not_com_chkl := v_activity_not_com_chkl + 1;
            return;
        end if;

        --Change Status
        osi_status.change_status(p_activity, v_stat_change_sid);
        --Thinking everything else is already handled by STATUS_CHANGE_PROC

        --Increment Counter
        v_activity_com := v_activity_com + 1;
        commit;
    exception
        when others then
            log_error('OSI_ASSOC.complete_single_activity: ' || sqlerrm);
            raise;
    end complete_single_activity;

    procedure close_single_activity(p_activity in varchar2) is
        v_stat_change_sid   t_osi_status_change.sid%type;
        v_auth_action       t_osi_status_change.auth_action%type;
    begin
        --Only update this counter if the CLOSE is successful
        v_stat_change_sid := get_stat_change_sid_clo(p_activity);
        v_auth_action := get_stat_change_auth(v_stat_change_sid);

        --Check for permission
        if (v_auth_action is not null) then
            if (osi_auth.check_for_priv(v_auth_action, core_obj.get_objtype(p_activity)) <> 'Y') then
                --If a PRIV is required, and the user has it not, then return without
                --doing the close or incrementing the close counter.
                v_activity_not_clo_priv := v_activity_not_clo_priv + 1;
                return;
            end if;
        end if;

        --Check for checklist completion
        if (osi_checklist.checklist_complete(p_activity, v_stat_change_sid) <> 'Y') then
            --Increment failure counter
            v_activity_not_clo_chkl := v_activity_not_clo_chkl + 1;
            return;
        end if;

        --Change Status
        osi_status.change_status(p_activity, v_stat_change_sid);
        --Thinking everything else is already handled by STATUS_CHANGE_PROC

        --Increment Counter
        v_activity_clo := v_activity_clo + 1;
    exception
        when others then
            log_error('OSI_ASSOC.close_single_activity: ' || sqlerrm);
            raise;
    end close_single_activity;

    procedure cc_single_activity(p_activity in varchar2) is
    begin
        log_error('Doing ACt:' || p_activity);

        --Check to see if it is restricted
        if (activity_is_restricted(p_activity) = true) then
            v_not_attempted := v_not_attempted + 1;
            --Can't do anything so get out NOW!!!!
            return;
        end if;

        --Complete Activity (If Possible)
        if (activity_can_be_completed(p_activity)) then
            complete_single_activity(p_activity);
            v_activity_com_attempted := v_activity_com_attempted + 1;
        end if;

        --Close Activity (If Possible)
        if (activity_can_be_closed(p_activity)) then
            close_single_activity(p_activity);
            v_activity_clo_attempted := v_activity_clo_attempted + 1;
        end if;
    exception
        when others then
            log_error('OSI_ASSOC.cc_single_activity: ' || sqlerrm);
            raise;
    end cc_single_activity;

    --Closes and Completes a list of Activity SIDs
    --Note: This function will only work if ACTUAL activity SID's are passed into it
    function cc_activities(p_activity_sid_list in varchar2)
        return varchar2 is
        v_list     varchar2(4000);
        --Need a seperate list as it will get chopped up (cannot do that to a parameter)
        v_return   varchar2(8000);
        v_cnt      number;
        v_crlf     varchar2(40)   := '<br>';                                  --chr(11) || chr(13);
    begin
        v_list := p_activity_sid_list;
        v_cnt := core_list.count_list_elements(v_list);
        log_error('Doing ACtS:' || p_activity_sid_list);

        --Loop through list and C/C
        for n in 1 .. v_cnt
        loop
            cc_single_activity(core_list.get_list_element(v_list, n));
        end loop;

        --Return counters somehow - TODO (this is just an initial output)
        v_return := 'Handling [' || v_cnt || '] Activities. ' || v_crlf;
        v_return :=
            v_return || 'Completed [' || v_activity_com || '] of [' || v_activity_com_attempted
            || '] attempted activities. ' || v_crlf;
        v_return :=
            v_return || 'Closed [' || v_activity_clo || '] of [' || v_activity_clo_attempted
            || '] attempted activities. ' || v_crlf;
        v_return :=
            v_return || '[' || v_not_attempted || '] Restricted Activities not attempted.' || v_crlf;
        v_return :=
            v_return || '[' || v_activity_not_com_priv
            || '] Activities not completed due to user privileges.' || v_crlf;
        v_return :=
            v_return || '[' || v_activity_not_clo_priv
            || '] Activities not closed due to user privileges.' || v_crlf;
        v_return :=
            v_return || '[' || v_activity_not_com_chkl
            || '] Activities not completed due to user incomplete checklists.' || v_crlf;
        v_return :=
            v_return || '[' || v_activity_not_clo_chkl
            || '] Activities not closed due to user incomplete checklists.' || v_crlf;
        return v_return;
    exception
        when others then
            log_error('OSI_ASSOC.cc_activities: ' || sqlerrm);
            raise;
    end cc_activities;
end OSI_ASSOC;
/
