set define off;


CREATE OR REPLACE package body osi_note as
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
 *  Notes Common Object - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_NOTE
   PURPOSE:    Supports the Notes Common Object in WebI2MS.

   REVISIONS:
   Date        Author           Description
   ----------  ---------------  ------------------------------------
    22-apr-2009  Richard Dibble  Created this package
    04-May-2009  Richard Dibble  Added ADD_NOTE and GET_STATUS_NOTE_TYPE
    17-Jun-2009  Tim McGuffin    Modified package to reference non-core note tables.
    17-Jun-2009  Tim McGuffin    Modified get_note_type to handle inheritance.
    09-Feb-2010  Richard Dibble  Changed add_note to a function, added update_note
    12-May-2010  Jason Faris     Added LATEST_NOTE
    14-Sep-2010  Richard Dibble  Modified get_note_status to check the lock mode of 
                                 the note, not the note type
    09-Nov-2012  Tim Ward        CR#4145 - Allow Locking/Unlocking of Notes by Users.
                                  Changed get_note_status.                                 
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_note';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    /* Returns the status of the note in question */
    function get_note_status(p_sid in varchar2)
        return varchar2 is
        v_note_lock_mode       t_osi_note_type.lock_mode%type;
        v_note_last_mod_date   date;
    begin
        --Grab the Lock Mode setting for this particular note
        select n.lock_mode, n.modify_on
          into v_note_lock_mode, v_note_last_mod_date
          from t_osi_note n
         where n.sid = p_sid;

        --Now check for the lock mode. (This will probably need to be more robust later,
        --it has been simplified for now because the only current lock modes that OSI uses
        --are 72HR, NEVER and IMMED

        --If the lock mode is NEVER, then we can just pass through
        if (v_note_lock_mode = 'NEVER') then
            return 'Open';
        end if;

        --If the lock mode is 72HR, we have to calculte whether or not we are past the editable threshhold
        if (v_note_lock_mode = '72HR') then
            if (v_note_last_mod_date + 3 < sysdate) then
                return 'Locked';
            else
                return 'Open';
            end if;
        end if;

        --If the note is IMMED locked, then it never can be changed (i.e. status change comments)
        if (v_note_lock_mode = 'IMMED') then
            return 'Locked';
        end if;

        if (v_note_lock_mode = 'USER_LOCKED') then
            return 'Locked by User';
        end if;

        return '<none>';
    exception
        when no_data_found then
            log_error('OSI_NOTE.GET_NOTE_STATUS: ' || sqlerrm);
            return null;
    end get_note_status;

    /* Gets the SID of an objects STATUS note type (NOTE_CAT_CODE of 'STATUS') */
    function get_note_type(p_obj_type in varchar2, p_note_cat_code in varchar2)
        return varchar2 is
        v_return   t_osi_note_type.sid%type;
    begin
        select sid
          into v_return
          from t_osi_note_type
         where obj_type member of osi_object.get_objtypes(p_obj_type) and code = p_note_cat_code;

        return v_return;
    exception
        when others then
            log_error('OSI_NOTE.GET_STATUS_NOTE_TYPE: ' || sqlerrm);
            return 'NO_STATUS_NOTE_TYPE_EXISTS';
    end get_note_type;

    /* Adds a note to an object with a particular note type */
    function add_note(p_obj in varchar2, p_note_type in varchar2, p_text in varchar2)
        return varchar2 is
        v_creating_personnel   varchar2(20);
        v_lock_mode            t_osi_note_type.lock_mode%type;
        v_return               t_osi_note.sid%type;
    begin
        --Get the creating personnel
        v_creating_personnel := core_context.personnel_sid;

        --Get the lock mode
        select lock_mode
          into v_lock_mode
          from t_osi_note_type
         where sid = p_note_type;

        --Insert the note
        insert into t_osi_note
                    (obj, note_type, note_text, creating_personnel, lock_mode)
             values (p_obj, p_note_type, p_text, v_creating_personnel, v_lock_mode)
             return sid
               into v_return;

        return v_return;
    exception
        when others then
            log_error('OSI_NOTE.ADD_NOTE: ' || sqlerrm);
            raise;
    end add_note;
    
    /* Given a Note SID, this procedure updates the given note */
    procedure update_note(
        p_note_sid           in   varchar2,
        p_text_to_append     in   varchar2,
        p_beginning_or_end   in   varchar2 := 'BEGIN') is
        v_note_text   clob;
    begin
        select note_text
          into v_note_text
          from t_osi_note
         where sid = p_note_sid;

        if (p_beginning_or_end = 'BEGIN') then
            v_note_text := p_text_to_append || v_note_text;
        else
            v_note_text := v_note_text || p_text_to_append;
        end if;

        update t_osi_note
           set note_text = v_note_text
         where sid = p_note_sid;
    exception
        when others then
            log_error('OSI_NOTE.UPDATE_NOTE: ' || sqlerrm);
            raise;
    end update_note;

    /* Given an object sid and status desc, this function returns the latest
       note text for that (lifecycle) note type code. */
    function latest_note(p_obj in Varchar2, p_type in Varchar2)
        return Clob is
    begin
        for p in (select n.note_text
                    from t_osi_note n, t_osi_note_type nt
                   where n.obj = p_obj 
                     and n.note_type = nt.sid
                     and (nt.code = p_type or
                          nt.sid = p_type)
                  order by n.create_on desc)
        loop
            return(p.note_text);
        end loop;

        return(null);                                                            -- if nothing found
    end latest_note;
        
end osi_note;
/
