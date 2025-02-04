CREATE OR REPLACE package body osi_status as
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
 *  Status Common Thing - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_STATUS
   PURPOSE:    Supports the Lifecycles in WebI2MS.

   REVISIONS:
   Date        Author           Description
   ----------  ---------------  ------------------------------------
   30-Apr-2009 Richard Dibble  Initial version.
   05-Jun-2009 Tim McGuffin    Added last_sh, last_sh_date, last_sh_create_on,
                               last_sh_create_by functions.
   23-Jun-2009 Richard Dibble  Fixed note_is_required_on_stat_chng after Tim broke it.
   09-Feb-2010 Richard Dibble  Added get_status_desc
   02-Apr-2010 Richard Dibble  Added first_sh and first_sh_date
   11-May-2010 Jason Faris     Added last_sh_sid
   20-Aug-2010 Richard Dibble  Added get_confirm_message
   30-Aug-2010 Richard Dibble  Added date_is_required_on_stat_chng
                               Modified change_status and change_status_brute
                               to handle effective date
   04-Nov-2011  Tim Ward       CR#3863 - Recalling/Rejecting of FILE.INV should go back to Investigatively Closed if there
                                is a "ROI/CSR Final Published" attached in the reports tab.
                                Changed in reopen_object.
                                Added check_for_ic.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_status';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    /* Returns Y or N depending on whether or not a note is required on a specific status change */
    function note_is_required_on_stat_chng(p_status_change_sid in varchar2)
        return varchar2 is
        v_comment_type   t_osi_status_change.comment_type%type;
    begin
        select comment_type
          into v_comment_type
          from t_osi_status_change
         where sid = p_status_change_sid;

        return v_comment_type;
/*
        if (V_COMMENT_TYPE = 'R') then
            return 'Y';
        else
            return 'N';
        end if;
*/
    exception
        when others then
            log_error('OSI_STATUS.note_is_required_on_stat_chng: ' || sqlerrm);
            raise;
    end note_is_required_on_stat_chng;

    /* Returns the correct note type sid for the given status change */
    function get_required_note_type(p_status_change_sid in varchar2)
        return varchar2 is
        v_note_type   t_osi_status_change.note_cat%type;
    begin
        select note_cat
          into v_note_type
          from t_osi_status_change
         where sid = p_status_change_sid;

        return v_note_type;
    exception
        when others then
            log_error('OSI_STATUS.get_required_note_type: ' || sqlerrm);
            raise;
    end get_required_note_type;

    /* Returns flag based on unit requirement for the given status change*/
    function unit_is_required_on_stat_chng(p_status_change_sid in varchar2)
        return varchar2 is
        v_unit_required   t_osi_status_change.unit_required%type;
    begin
        select unit_required
          into v_unit_required
          from t_osi_status_change
         where sid = p_status_change_sid;

        return v_unit_required;
    exception
        when others then
            log_error('OSI_STATUS.unit_is_required_on_stat_chng: ' || sqlerrm);
            raise;
    end unit_is_required_on_stat_chng;

    /* Returns flag based on unit text requirement for the given status change*/
    function unit_text_required_on_statchng(p_status_change_sid in varchar2)
        return varchar2 is
        v_unit_text_required   t_osi_status_change.unit_text_required%type;
    begin
        select unit_text_required
          into v_unit_text_required
          from t_osi_status_change
         where sid = p_status_change_sid;

        return v_unit_text_required;
    exception
        when others then
            log_error('OSI_STATUS.unit_text_required_on_statchng: ' || sqlerrm);
            raise;
    end unit_text_required_on_statchng;

        /* Returns the confirmation message (Are you sure) to be displayed to the user
           Note: If the status change has no custom message, it uses the
           T_CORE_CONFIG:STATUS_CONFIRM_MESSAGE text as its default message
        */
        /*
        function get_confirm_message(p_status_change_sid in varchar2)
            return varchar2 is
            v_confirm_message   t_osi_status_change.confirm_message%type;
        begin
            select confirm_message
              into v_confirm_message
              from t_osi_status_change
             where sid = p_status_change_sid;

            if (v_confirm_message is null) then
                v_confirm_message := core_util.get_config('OSI.STATUS_DEFAULT_CONFIRM_MESSAGE');
            end if;

            return v_confirm_message;
        exception
            when others then
                log_error('OSI_STATUS.GET_CONFIRM_MESSAGE: ' || sqlerrm);
                raise;
        end get_confirm_message;
    */
        /* Changes the status of the object to the new supplied status
            This is generally only used when changing the status from special
            processing, using bruit force.
         */
    procedure change_status_brute(
        p_obj                  in   varchar2,
        p_to_status_sid        in   varchar2,
        p_transition_comment   in   varchar2 := null,
        p_effective_date       in   date := null) is
        v_old_is_current_status       varchar2(20);
        v_status_change_description   varchar2(500);
        v_effective_date              date;
    begin
         --Get the SID of the status record that currently is marked as IS_CURRENT
        --(Don't want to update that record until we are sure the status change went through alright)
        begin
            --Need to wrap this in a try/catch block in case there are no existing status records for this object
            select sid
              into v_old_is_current_status
              from t_osi_status_history
             where obj = p_obj and is_current = 'Y';
        exception
            when others then
                v_old_is_current_status := 'NONE';
        end;

        --Get Effective Date
        if (p_effective_date is not null) then
            v_effective_date := p_effective_date;
        else
            v_effective_date := sysdate;
        end if;

        --Insert new status record into T_OSI_STATUS_HISTORY
        insert into t_osi_status_history
                    (obj, status, effective_on, transition_comment, is_current)
             values (p_obj, p_to_status_sid, v_effective_date, p_transition_comment, 'Y');

        --Update the old IS_CURRENT record so it no longer is marked as IS_CURRENT
        if (v_old_is_current_status <> 'NONE') then
            update t_osi_status_history
               set is_current = 'N'
             where sid = v_old_is_current_status;
        end if;

    exception
        when others then
            log_error('OSI_STATUS.CHANGE_STATUS_BRUTE: ' || sqlerrm);
    end change_status_brute;

    /* Changes the status of the object based on the status change */
    procedure change_status(
        p_obj                 in   varchar2,
        p_status_change_sid   in   varchar2,
        p_parameter1          in   varchar2 := null,
        p_parameter2          in   varchar2 := null,
        p_effective_date      in   date := null) is
        v_status_change_description   varchar2(500);
        v_new_status_sid              varchar2(20);
        v_old_status_sid              varchar2(20);
        v_ok                          varchar2(2000);
    begin
        --Get the description from T_OSI_STATUS_CHANGE so we can insert it into T_OSI_STATUS_HISTORY
        --Get the NEW status SID
        --Get the OLD status SID
        select transition, to_status, from_status
          into v_status_change_description, v_new_status_sid, v_old_status_sid
          from t_osi_status_change
         where sid = p_status_change_sid;

        --Need to wrap this, making sure we don't run it when TO and FROM status are the same
        --such scenarios will used for CLONE, REOPEN, etc.
        if (v_new_status_sid <> v_old_status_sid) then
            change_status_brute(p_obj,
                                v_new_status_sid,
                                v_status_change_description,
                                p_effective_date);
        end if;

        --Do any special processing for this status change
        for k in (select proc_to_use
                    from t_osi_status_change_proc
                   where status_change_sid = p_status_change_sid
                     and active = 'Y'
                     and process_point = 'AFTER')
        loop
            --For debugging only
            --insert into z_richd_temp (theclob) values ('BEGIN ' || k.proc_to_use || '(''' || p_obj || '''); END;');
            execute immediate 'BEGIN ' || k.proc_to_use || '(''' || p_obj || ''', '''
                              || p_parameter1 || ''', ''' || p_parameter2 || '''); END;';
        end loop;
        
        --- Check for Investigatively Closed ---
        osi_status_proc.check_for_ic(p_obj, v_new_status_sid);

    exception
        when others then
            log_error('OSI_STATUS.CHANGE_STATUS: ' || sqlerrm);
            raise;
    end change_status;

    /* Retrieves the starting status of an object type */
    function get_starting_status(p_obj_type_sid in varchar2)
        return varchar2 is
        v_return   t_osi_obj_type.starting_status%type;
    begin
        select starting_status
          into v_return
          from t_osi_obj_type
         where sid = p_obj_type_sid;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS.get_starting_status: ' || sqlerrm);
            raise;
    end get_starting_status;

    /* Retrieves the status change description of a status change SID */
    function get_status_change_desc(p_status_change_sid in varchar2)
        return varchar2 is
        v_return   t_osi_status_change.transition%type;
    begin
        select transition
          into v_return
          from t_osi_status_change
         where sid = p_status_change_sid;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS.get_status_change_desc: ' || sqlerrm);
            raise;
    end get_status_change_desc;

    /* Retrieves the status  description of a status  SID */
    function get_status_desc(p_status_sid in varchar2)
        return varchar2 is
        v_return   t_osi_status.description%type;
    begin
        select description
          into v_return
          from t_osi_status
         where sid = p_status_sid;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS.get_status_desc: ' || sqlerrm);
            raise;
    end get_status_desc;

    /* Retrieves the T_OSI_STATUS_HISTORY record associated with the input p_status (code or sid) */
    function last_sh(p_obj in varchar2, p_status in varchar2)
        return t_osi_status_history%rowtype is
    begin
        for i in (select   h.*
                      from t_osi_status_history h, t_osi_status s
                     where h.obj = p_obj
                       and h.status = s.sid
                       and (   p_status is null
                            or s.sid = p_status
                            or s.code = p_status)
                  order by h.create_on desc)
        loop
            return i;                                                        -- only need first one
        end loop;

        return null;                                                             -- if nothing found
    end last_sh;

    /* Retrieves the T_OSI_STATUS_HISTORY record associated with the input p_status (code or sid) */
    function first_sh(p_obj in varchar2, p_status in varchar2)
        return t_osi_status_history%rowtype is
    begin
        for i in (select   h.*
                      from t_osi_status_history h, t_osi_status s
                     where h.obj = p_obj
                       and h.status = s.sid
                       and (   p_status is null
                            or s.sid = p_status
                            or s.code = p_status)
                  order by h.create_on asc)
        loop
            return i;                                                        -- only need first one
        end loop;

        return null;                                                             -- if nothing found
    end first_sh;

    /* Retrieves the EFFECTIVE_ON column for the last Status History record for an object */
    function last_sh_date(p_obj in varchar2, p_status in varchar2)
        return date is
        v_sh_rec   t_osi_status_history%rowtype;
    begin
        v_sh_rec := last_sh(p_obj, p_status);
        return nvl(v_sh_rec.effective_on, v_sh_rec.create_on);
    exception
        when others then
            log_error('last_sh_date: ' || sqlerrm);
            raise;
    end last_sh_date;

    /* Retrieves the EFFECTIVE_ON column for the first Status History record for an object */
    function first_sh_date(p_obj in varchar2, p_status in varchar2)
        return date is
        v_sh_rec   t_osi_status_history%rowtype;
    begin
        v_sh_rec := first_sh(p_obj, p_status);
        return nvl(v_sh_rec.effective_on, v_sh_rec.create_on);
    exception
        when others then
            log_error('first_sh_date: ' || sqlerrm);
            raise;
    end first_sh_date;

    /* Retrieves the CREATE_ON column for the last Status History record for an object */
    function last_sh_create_on(p_obj in varchar2, p_status in varchar2)
        return date is
        v_sh_rec   t_osi_status_history%rowtype;
    begin
        v_sh_rec := last_sh(p_obj, p_status);
        return v_sh_rec.create_on;
    exception
        when others then
            log_error('last_sh_create_on: ' || sqlerrm);
            raise;
    end last_sh_create_on;

    /* Retrieves the CREATE_BY column for the last Status History record for an object */
    function last_sh_create_by(p_obj in varchar2, p_status in varchar2)
        return varchar2 is
        v_sh_rec   t_osi_status_history%rowtype;
    begin
        v_sh_rec := last_sh(p_obj, p_status);
        return v_sh_rec.create_by;
    exception
        when others then
            log_error('last_sh_create_by: ' || sqlerrm);
            raise;
    end last_sh_create_by;

    /* Retrieves the SID column for the last Status History record for an object */
    function last_sh_sid(p_obj in varchar2, p_status in varchar2)
        return varchar2 is
        v_sh_rec   t_osi_status_history%rowtype;
    begin
        v_sh_rec := last_sh(p_obj, p_status);
        return v_sh_rec.sid;
    exception
        when others then
            log_error('last_sh_sid: ' || sqlerrm);
            raise;
    end last_sh_sid;

    /* Runs pre-processing checks and return a list of issues */
    function run_pre_processing(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2 is
        v_return        varchar2(1000) := null;
        v_return_temp   varchar2(4000) := null;
    begin
        --Loop through and run all processes
        for k in (select proc_to_use
                    from t_osi_status_change_proc
                   where status_change_sid = p_status_change_sid
                     and active = 'Y'
                     and process_point = 'BEFORE')
        loop
            execute immediate 'BEGIN :1 := ' || k.proc_to_use || '(''' || p_obj || '''); END;'
                        using out v_return_temp;

            --If there is a return value, add it to the list (along with a CR
            if (v_return_temp is not null) then
                v_return := v_return_temp || chr(13);
            end if;
        end loop;

        --Send it on home!
        return v_return;
    exception
        when others then
            log_error('run_pre_processing: ' || sqlerrm);
            return 'An error has been encountered during status change pre-processing.';
    end run_pre_processing;

    /* Returns custom messages for Status Changes */
    function get_confirm_message(p_status_change_sid in varchar2, p_obj in varchar2)
        return varchar2 is
        v_return        varchar2(4000) := null;
        v_return_temp   varchar2(2000) := null;
    begin
        --First see if there is a custom message in the table
        for k in (select confirm_message
                    from t_osi_status_change
                   where sid = p_status_change_sid)
        loop
            v_return := k.confirm_message;
        end loop;

        if (v_return is null) then
            --There is no confirm message, so see if we have processing functions
            --Loop through and run all processes
            for k in (select proc_to_use
                        from t_osi_status_change_proc
                       where status_change_sid = p_status_change_sid
                         and active = 'Y'
                         and process_point = 'MSG_BEFORE')
            loop
                execute immediate 'BEGIN :1 := ' || k.proc_to_use || '(''' || p_obj || '''); END;'
                            using out v_return_temp;

                --If there is a return value, add it to the list (along with a CR
                if (v_return_temp is not null) then
                    v_return := v_return_temp || chr(13);
                end if;
            end loop;
        end if;

        if (v_return is null) then
            --There is no processing message so simply return a generic message.
            v_return := core_util.get_config('OSI.STATUS_DEFAULT_CONFIRM_MESSAGE');
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS.get_confirm_message: ' || sqlerrm);
            raise;
    end get_confirm_message;

    /* Returns flag based on date requirement for the given status change */
    function date_is_required_on_stat_chng(p_status_change_sid in varchar2)
        return varchar2 is
        v_date_required   t_osi_status_change.allow_date%type;
    begin
        select allow_date
          into v_date_required
          from t_osi_status_change
         where sid = p_status_change_sid;

        return v_date_required;
    exception
        when others then
            log_error('OSI_STATUS.date_is_required_on_stat_chng: ' || sqlerrm);
            raise;
    end date_is_required_on_stat_chng;
end osi_status;
/