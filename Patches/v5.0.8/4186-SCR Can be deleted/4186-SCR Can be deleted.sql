set define off;

CREATE OR REPLACE package body osi_status_proc as
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
 *  Lifecycle - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_STATUS_PROC
   PURPOSE:    Provides functionality status change processing in WebI2MS.

    REVISIONS:
    Date        Author           Description
    ----------  ---------------  ------------------------------------
    11-may-2009  Richard Dibble  Created this package
    26-May-2009  Richard Dibble  Added transfer_file
    29-May-2009  Richard Dibble  Added verify_user_created_last_sh
    01-Jun-2009  Richard Dibble  Added mark_closed_short_file and unmark_closed_short_file
    04-Jun-2009  Tim McGuffin    Modified clone_activity to account for non-core addresses
    05-Jun-2009  Tim McGuffin    Modified verify_user_created_last_sh to reference new version
                                 of OSI_STATUS_PROC.last_sh_create_by.
    23-Jun-2009  Richard Dibble  Fixed reopen_object after Tim broke it
    02-Jul-2009  Richard Dibble  Modified reset_restriction to handle new ACL/ACE setup
                                 Added is_activity, is_file and get_restriction_sid
    15-Jul-2009  Tim McGuffin    Added update_activity_close_date function and called it from close_activity.
    15-Jul-2009  Tim McGuffin    Modified action text in Reopen_object to just say "Reopen", instead of
                                 "ReOpen-Last Open State"
    23-Jul-2009  T. Whitehead    Added confirm_participant, unconfirm_participant.
    06-Oct-2009  T.McGuffin      Added clone_to_case procedure.
    08-Oct-2009  T.McGuffin      Added set_file_full_id procedure.
    06-Nov-2009  T. Whitehead    Added case_from_init_notif.
    07-Dec-2009  T.Whitehead     Added transfer_file_end_assignments.
    28-Jan-2009  T.Whitehead     Added source_burn and source_unburn.
    08-Feb-2010  R.Dibble        Added aapp_can_recall  
    09-Feb-2010  Richard Dibble  Added recall_aapp_file 
    16-Mar-2010  Richard Dibble  Added aapp_set_restriction_ap
    18-Mar-2010  Jason Faris     Added sar_phase_update
    09-Apr-2010  Jason Faris     Added reopen_sar  
    29-Apr-2010  T.Whitehead     Added deers_update_links.
    06-May-2010  JaNelle Horne   Added copy_special_interest
    12-May-2010  Jason Faris     Added poly_file_auto_transfer.
    12-May-2010  T.Whitehead     Added source_exists.
    18-May-2010  JaNelle Horne   Added copy_mission_area, autofill_summary_inv
    28-May-2010  JaNelle Horne   Added create_sum_complaint_rpt
    05-Jun-2010  Richard Dibble  Added act_clear_complete_date, act_clear_close_date
    06-Jun-2010  JaNelle Horne   Updated create_sum_complaint_rpt so that attachment type sid is pulled back
                                 based on obj_type
    22-Jun-2010  JaNelle Horne   Updated find_last_valid_return_point; missing a join in the query
                                 Updated create_sum_complaint_rpt so that it checks for existing SCR and deletes any
                                 before adding final SCR.
    23-Jun-2010  Jason Faris     Added case_clear_negative_indexes.
    19-Aug-2010  Richard Dibble  Added pmm_close_account, user_can_close_account
    20-Aug-2010  Richard Dibble  Added pmm_suspend_account, pmm_reopen_account, 
                                 user_can_reopen_account, pmm_handle_pw_reset,
                                 pmm_handle_fix_login_id, pmm_user_can_fix_login_id,
                                 pmm_check_for_active_assign   
    30-Aug-2010  Richard Dibble  Modified pmm_disable_password to handle effective date
                                 Modified pmm_suspend_account and pmm_close_account to handle effective date
    09-Nov-2010  Richard Dibble  Added check_for_old_partic_links
    02-Mar-2011  Tim Ward        CR#3725 - Added Source to clone_activity for Sourc Meet Activities.
    04-Mar-2011  Carl Grunert    Added get file name code to create_sum_complaint_rpt. (CHG0003675) 
    08-Mar-2011  Tim Ward        CR#3740 - poly_file_auto_transfer not always auto tranferring to correct
                                  previous unit, also had to delete one of the auto_transfer calls because
                                  it was auto transferring twice on HQ Rejection:

                                  DELETE FROM T_OSI_STATUS_CHANGE_PROC WHERE SID='22200000XQB';
                                  COMMIT;                                  
    22-Mar-2011  Tim Ward        CR#3760 - Changed pmm_close/suspend/reopen_account to include personnel_status_date.
    05-May-2011  Tim Ward        CR#3836 - Changed poly_file_auto_transfer to change RPO/Requesting Unit before transfer.
    06-May-2011  Tim Ward        CR#3837 - Changed clone_activity to add the correct cloned from ID to the Note instead
                                  of the new ID.
    10-May-2011  Tim Ward        CR#3839 - Cloning Activities results in a Title that is over the max length.
                                  Chagned in clone_activity.
    09-Jun-2011  Tim Ward        CR#3879 - Cloning Activities that are assigned as leads copies the assigned unit
                                  over, this makes the activity a 1/2 lead....
                                  Chagned in clone_activity.
    27-Jun-2011  Tim Ward        CR#3863 - Reopening of FILE.INV should go back to Investigatively Closed if there
                                  is a "ROI/CSR Final Published" attached in the reports tab.
                                  Changed in reopen_object.
    30-Jun-2011  Tim Ward        CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Added Get_Subject_Selection_HTML.
                                  Changed clone_to_case.
                                  Changed case_from_init_notif.
    06-Jul-2011  Tim Ward        CR#3600 - Allo Creating DCII Indexing file from Dev/Info Files.
                                  Added clone_to_dcii.
    04-Nov-2011  Tim Ward        CR#3863 - Recalling/Rejecting of FILE.INV should go back to Investigatively Closed if there
                                  is a "ROI/CSR Final Published" attached in the reports tab.
                                  Changed in reopen_object.
                                  Added check_for_ic.
    17-Apr-2012  Tim Ward        CR#3653 - Lock a Lead Note only after the Lead has been Sent.
                                  Changed in assign_auxilary_unit.
    09-Nov-2012  Tim Ward        CR#4186 - Change LOCK_MODE for SCR to LOCKED so it can't be deleted/editted.
                                  Changed in reate_sum_complaint_rpt.
    
******************************************************************************/
    
    c_pipe                  varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX')
                                       || 'OSI_status_proc';
    v_clone_new_sid         varchar2(20)  := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    -- Tells whether or not the given object is an activity
    function is_activity(p_obj in varchar2) return number is
    begin
        for K in (select SID from t_osi_activity where sid = p_obj)
        loop
            return 1;
        end loop;
    return 0; 
       exception
     
        when others then
            log_error('OSI_STATUS_PROC.is_activity: ' || sqlerrm);
            raise;
    end is_activity;
    
    -- Tells whether or not the given object is a file
        function is_file(p_obj in varchar2) return number is
    begin
        for K in (select SID from t_osi_file where sid = p_obj)
        loop
            return 1;
        end loop;
    return 0; 
       exception
     
        when others then
            log_error('OSI_STATUS_PROC.is_file: ' || sqlerrm);
            raise;
    end is_file;
    
    --Returns the SID of the given restriction
    function get_restriction_sid(p_restriction in varchar2) return varchar2 is
    begin
        for K in (select SID from t_osi_reference where description = p_restriction and usage = 'RESTRICTION')
        loop
            return k.sid;
        end loop;
           exception
     
        when others then
            log_error('OSI_STATUS_PROC.get_acl_sid: ' || sqlerrm);
            raise;
    end get_restriction_sid;
    

    --Handles restriction changes when switching units
    --(Assures that an activity restricted to "Assigned Personnel" can be
    --accessed by others in the newly assigned unit, etc.)
    procedure reset_restriction(p_obj in varchar2) is
        v_current_restriction_desc   varchar2(300);
        v_new_restriction            t_core_obj.acl%type;
    --The hard coding in this function was recomended by Tim McGuffin on 05/12/2009
    begin
        --Get new restriction
        v_new_restriction := get_restriction_sid('Unit and Assigned Personnel');
        
        --ACTIVITIES
        if (is_activity(p_obj) = 1) then
        
            --Get the current ACL
            select tor.DESCRIPTION
            into v_current_restriction_desc
            from t_osi_reference tor, t_osi_activity toa
            where toa.RESTRICTION = tor.SID(+) and toa.sid = p_obj;

            --If the ACL is "Assigned Personnel", then we need to change it to
            --Unit and Assigned Personnel
            if (v_current_restriction_desc = 'Assigned Personnel') then

                --Update T_CORE_OBJ with new ACL
                update t_osi_activity
                   set restriction = v_new_restriction
                 where sid = p_obj;
            end if;
        
        end if;
        
        --FILES
        if (is_file(p_obj) = 1) then
        
            --Get the current ACL
            select tor.DESCRIPTION
            into v_current_restriction_desc
            from t_osi_reference tor, t_osi_file tof
            where tof.RESTRICTION = tor.SID(+)  and tof.sid = p_obj;

            --If the ACL is "Assigned Personnel", then we need to change it to
            --Unit and Assigned Personnel
            if (v_current_restriction_desc = 'Assigned Personnel') then

                --Update T_CORE_OBJ with new ACL
                update t_osi_file
                   set restriction = v_new_restriction
                 where sid = p_obj;
            end if;
        
        end if;
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.reset_restriction: ' || sqlerrm);
            raise;
    end reset_restriction;

    --Returns the creating unit of an activity
    function get_activity_create_by_unit(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_activity.assigned_unit%type;
    begin
        select creating_unit
          into v_return
          from t_osi_activity
         where sid = p_obj;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.get_activity_create_by_unit: ' || sqlerrm);
            raise;
    end get_activity_create_by_unit;

    --Ends all assignments for the specified object
    procedure end_all_assignments(p_obj in varchar2) is
    begin
        update t_osi_assignment
           set end_date = sysdate
         where obj = p_obj and end_date is null;
    exception
        when others then
            log_error('OSI_STATUS_PROC.end_all_assignments: ' || sqlerrm);
            raise;
    end end_all_assignments;

    --Finds the last valid return point in the status history chain
    function find_last_valid_return_point(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(20) := '<none>';
    begin
        --This is using a cursor-for loop although it will only grab the first record, then exit.
        --It was left with this architecture in case we need to add some further code to it later.
        for k in (select os.SID
                    from t_osi_status_history osh, t_osi_status os, t_osi_status_return_points osrp
                   where os.SID = osrp.status_sid and osrp.active = 'Y' and osh.obj = p_obj and osh.status = os.SID
                     and (   osrp.OBJ_TYPE member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                     or obj_type = core_obj.lookup_objtype('ALL'))
                   order by osh.create_on desc)
        loop
            v_return := k.sid;
            exit;
        end loop;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.find_last_valid_return_point: ' || sqlerrm);
            raise;
    end find_last_valid_return_point;

    --Finds the number of days to use for a suspense date calculation
    function find_days_for_suspense(p_obj in varchar2)
        return number is
        v_number_of_days   t_core_config.setting%type;
    begin
/************************************************************************
--Below is the SQL from the fat client.  This will need to be implemented once
we have out Investigative File tables in place
--        SQL = " SELECT "
--        SQL = SQL & "    SPECIAL_INTEREST"
--        SQL = SQL & " FROM "
--        SQL = SQL & "    T_INVESTIGATIVE_FILE"
--        SQL = SQL & " WHERE "
--        SQL = SQL & "    SID in"
--        SQL = SQL & "       (select FYLE from T_FILE_CONTENT "
--        SQL = SQL & "        where ACTIVITY = '" & pActivitySID & "') "
--        SQL = SQL & "    and"
--        SQL = SQL & "    SPECIAL_INTEREST = '13'"
************************************************************************/
--Notes:05/15/2009
--Basicaly what happens is, you check the associated investigative files,
--see if there is one with a special interest of 13 or'Seven Burner',
--and IF SO, it uses core_util.GET_CONFIG('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_2') which is 5 days
--and IF NOT, it uses core_util.GET_CONFIG('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_1') which is 20 days

        --For now, we will just return 20 days
        return core_util.get_config('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_1');
    exception
        when others then
            log_error('OSI_STATUS_PROC.find_days_for_suspense: ' || sqlerrm);
            raise;
    end find_days_for_suspense;

    --Used for updating an activities create by unit
    procedure update_activity_create_by_unit(p_obj in varchar2, p_unit in number) is
        v_date   date;
    begin
        update t_osi_activity
           set creating_unit = p_unit;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_create_by_unit: ' || sqlerrm);
            raise;
    end update_activity_create_by_unit;

    --Used for updating an activities suspense date
    procedure update_activity_suspense_date(p_obj in varchar2, p_num_of_days in number) is
        v_date   date;
    begin
        --See if there is already a suspense date
        select suspense_date
          into v_date
          from t_osi_activity
         where sid = p_obj;

        if (v_date is null) then
            v_date := sysdate + p_num_of_days;
        else
            v_date := v_date + p_num_of_days;
        end if;

        update t_osi_activity
           set suspense_date = v_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_suspense_date: ' || sqlerrm);
            raise;
    end update_activity_suspense_date;

    --Used for updating an activities complete date
    procedure update_activity_complete_date(p_obj in varchar2, p_date in date) is
    begin
        --Set the activity Completed Date
        update t_osi_activity
           set complete_date = p_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_complete_date: ' || sqlerrm);
            raise;
    end;

    --Used for updating an activities complete date
    procedure update_activity_close_date(p_obj in varchar2, p_date in date) is
    begin
        --Set the activity Close Date
        update t_osi_activity
           set close_date = p_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_close_date: ' || sqlerrm);
            raise;
    end;

    --Used for updating activity unit assignment
    procedure update_activity_unit_assign(p_obj in varchar2, p_unit in varchar2) is
    begin
        update t_osi_activity
           set assigned_unit = p_unit
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_unit_assign: ' || sqlerrm);
            raise;
    end update_activity_unit_assign;

    --Used for updating activity unit assignment
    procedure update_activity_aux_unit(p_obj in varchar2, p_unit in varchar2) is
    begin
        update t_osi_activity
           set aux_unit = p_unit
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_aux_unit: ' || sqlerrm);
            raise;
    end update_activity_aux_unit;

    /* Used to process an activity on Completion */
    procedure complete_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Set the activity Completed Date
        update_activity_complete_date(p_obj, sysdate);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.complete_activity: ' || sqlerrm);
            raise;
    end complete_activity;

    /* Used to process an activity on Closure */
    procedure close_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update_activity_close_date(p_obj, sysdate);
        end_all_assignments(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.close_activity: ' || sqlerrm);
            raise;
    end close_activity;

    procedure check_for_ic(p_obj in varchar2, v_new_status_sid varchar2) is

         v_object_type_code  varchar2(100);
         v_last_inv_closed   date;
         v_inv_closed_status_sid varchar2(20);
         v_open_status_sid varchar2(20);
         v_roi_count number;

    begin
         v_object_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

         ---Investigations need to go from Open to Investigatively Closed if there is a 'ROI/CSR Final Published' attached---
         if v_object_type_code in ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') then
           
           select sid into v_open_status_sid 
                from t_osi_status where code='OP' and description='Open';
           
           if v_new_status_sid = v_open_status_sid then

             select count(*) into v_roi_count from t_osi_attachment a,t_osi_attachment_type t
                   where a.obj=p_obj and a.type=t.sid and t.code='ROIFP' and t.OBJ_TYPE=core_obj.get_objtype(p_obj);
          
             if v_roi_count > 0 then                

               select sid into v_inv_closed_status_sid 
                    from t_osi_status where code='IC' and description='Investigatively Closed';
                
               v_last_inv_closed := osi_status.last_sh_date(p_obj, v_inv_closed_status_sid);

               update t_osi_status_history set is_current='N' where obj=p_obj and is_current='Y';
               insert into t_osi_status_history (obj, status, effective_on, transition_comment, is_current)
                  values (p_obj, v_inv_closed_status_sid, v_last_inv_closed, 'Investigatively Closed', 'Y');

             end if;
             
           end if;
            
         End if;

    exception
        when others then
            log_error('OSI_STATUS_PROC.check_for_ic: ' || sqlerrm);
            raise;

    end check_for_ic;

    /* Used to process an activity on Re-Open */
    procedure reopen_object(p_obj in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) is

         v_status_sid   t_OSI_STATUS.sid%type;

    begin
         --Get last allowable return point
         v_status_sid := find_last_valid_return_point(p_obj);

         --Change to tha status we just got from the find_last_valid_return_point() function
         OSI_STATUS.change_status_brute(p_obj, v_status_sid, 'Reopen'); 

         --Reset Restriction.  This will only reset objects whose restriction is set to
         --"Assigned Personnel"
         reset_restriction(p_obj);
        
         --- Check if it Should be Investigatively Closed ---
         check_for_ic(p_obj, v_status_sid);

    exception
        when others then
            log_error('OSI_STATUS_PROC.reopen_object: ' || sqlerrm);
            raise;
    end reopen_object;

    /* Used to process an activiting on Assignment of an Auxilary Unit */
    procedure assign_auxilary_unit(p_obj in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) is

         v_suspense_days_to_use   number;
         v_obj_type               varchar2(20);
         v_note_type              varchar2(20);

    begin
         --- Update Unit Assignment ---
         update_activity_unit_assign(p_obj, p_parameter1);
 
         --- Update aux unit ---
         update_activity_aux_unit(p_obj, p_parameter1);

         --- Update the suspense date ---
         update_activity_suspense_date(p_obj, find_days_for_suspense(p_obj));

         --- Update the completed date ---
         update_activity_complete_date(p_obj, null);

         --Reset Restriction.  This will only reset objects whose restriction is set to "Assigned Personnel" --
         reset_restriction(p_obj);

         --- Lock the Lead Note Now ---
         v_obj_type := core_obj.get_objtype(p_obj);
         v_note_type := osi_note.get_note_type(v_obj_type, 'LEAD');
         update t_osi_note set lock_mode='IMMED' where obj=p_obj and note_type=v_note_type;
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.assign_auxilary_unit: ' || sqlerrm);
            raise;
    end assign_auxilary_unit;

    /* Used to process an activity on Re-Call */
    procedure recall_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        test   number;
    begin
        --**Note: This function is virtually identical to reject_activity, but left seperate for differentiation
        --**>
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Update aux unit
        update_activity_aux_unit(p_obj, null);
        --Update the suspense date
        update_activity_suspense_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.recall_activity: ' || sqlerrm);
            raise;
    end recall_activity;

    /* Used to process an activity on Rejection */
    procedure reject_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        test   number;
    begin
        --**Note: This function is virtually identical to recall_activity, but left seperate for differentiation
        --**>
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Update aux unit
        update_activity_aux_unit(p_obj, null);
        --Update the suspense date
        update_activity_suspense_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.reject_activity: ' || sqlerrm);
            raise;
    end reject_activity;

    procedure case_from_init_notif(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_init_notification.create_case_file(p_obj, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('case_from_init_notif' || sqlerrm);
            raise;
    end case_from_init_notif;
    /* Used to process an activity on Clone */
    procedure clone_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_core_obj_record           t_core_obj%rowtype;
        v_object_type               t_core_obj_type.sid%type;
        v_object_type_description   t_core_obj_type.description%type;
        v_new_sid                   varchar2(20);
        v_new_id                    varchar2(100);
        v_temp t_osi_note.sid%type;
        v_id                        varchar2(100);
        v_title                     varchar2(100);
    begin
        --Set v_object_type
        v_object_type := core_obj.get_objtype(p_obj);

        --Set v_object_type_description
        select description
          into v_object_type_description
          from t_core_obj_type
         where sid = v_object_type;

        --Get new ID
        v_new_id := osi_object.get_next_id;

        --Get the Core_Obj Information
        select *
          into v_core_obj_record
          from t_core_obj
         where sid = p_obj;

        --Create t_core_obj record
        insert into t_core_obj
                    (obj_type, acl)
             values (v_core_obj_record.obj_type, v_core_obj_record.acl)
          returning sid
               into v_new_sid;

        --Set global clone sid
        v_clone_new_sid := v_new_sid;
        
        --Create t_osi_activity_record
        for k in (select *
                    from t_osi_activity
                   where sid = p_obj)
        loop
            v_id := k.id;

            v_title := osi_object.get_default_title(v_core_obj_record.obj_type);
        
            if v_title is null or v_title='' then
          
              v_title := substr('Copy of: ' || k.title, 1, 100);

            end if;
            
            insert into t_osi_activity
                        (sid,
                         id,
                         title,
                         narrative,
                         creating_unit,
                         assigned_unit,
                         activity_date,
                         source)
                 values (v_new_sid,
                         v_new_id,
                         v_title, ---'Copy of: ' || k.title,
                         k.narrative,
                         k.creating_unit,
                         k.creating_unit,
                         k.activity_date,
                         k.source);
        end loop;

        osi_object.do_title_substitution(v_new_sid);

        --Set status
        OSI_STATUS.change_status_brute(v_new_sid,
                                       OSI_STATUS.get_starting_status(v_object_type),
                                       'Created');
        --Add Note
        v_temp := osi_note.add_note(v_new_sid,
                          osi_note.get_note_type(v_object_type, 'CLONE'),
                          'This ' || v_object_type_description || ' Activity was created from the '
                          || v_object_type_description || ' with ID# ' || v_id || '.');

        --Clone AddressList
        for k in (select *
                    from t_osi_address
                   where obj = p_obj)
        loop
            insert into t_osi_address
                        (obj,
                         address_type,
                         address_1,
                         address_2,
                         city,
                         state,
                         postal_code,
                         country,
                         start_date,
                         end_date,
                         known_date,
                         province,
                         geo_coords,
                         comments)
                 values (v_new_sid,
                         k.address_type,
                         k.address_1,
                         k.address_2,
                         k.city,
                         k.state,
                         k.postal_code,
                         k.country,
                         k.start_date,
                         k.end_date,
                         k.known_date,
                         k.province,
                         k.geo_coords,
                         k.comments);
        end loop;

        --Clone Assignment List
        for k in (select *
                    from t_osi_assignment
                   where obj = p_obj)
        loop
            insert into t_osi_assignment
                        (obj, personnel, assign_role, start_date, end_date, unit)
                 values (v_new_sid, k.personnel, k.assign_role, k.start_date, k.end_date, k.unit);
        end loop;

        --Clone Investigative Support
        --t_osi_mission_category, t_osi_mission
        for k in (select *
                    from t_osi_mission
                   where obj = p_obj)
        loop
            insert into t_osi_mission
                        (obj, obj_context, mission)
                 values (v_new_sid, k.obj_context, k.mission);
        end loop;

        --Clone Associated Files
        for k in (select *
                    from t_osi_assoc_fle_act
                   where activity_sid = p_obj)
        loop
            insert into t_osi_assoc_fle_act
                        (activity_sid, file_sid, resource_allocation)
                 values (v_new_sid, k.file_sid, k.resource_allocation);
        end loop;

        --Clone Participant List
        for k in (select *
                    from t_osi_partic_involvement
                   where obj = p_obj)
        loop
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
                 values (v_new_sid,
                         k.participant_version,
                         k.involvement_role,
                         k.num_briefed,
                         k.action_date,
                         k.response,
                         k.response_date,
                         k.agency_file_num,
                         k.report_to_dibrs,
                         k.report_to_nibrs,
                         k.reason);
        end loop;
        
        --Do special processing (per object), each object will need its own CLONE() procedure.
        execute immediate 'BEGIN ' || osi_object.get_obj_package(v_object_type) || '.CLONE('''
                          || p_obj || ''', ''' || v_new_sid || '''); END;';
    exception
        when others then
            log_error('OSI_STATUS_PROC.clone_activity: ' || sqlerrm);
            raise;
    end clone_activity;

    procedure clone_to_case(
        p_sid          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_investigation.clone_to_case(p_sid, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('clone_to_case: ' || sqlerrm);
            raise;
    end clone_to_case;


    /* Used to retrieve the SID of a recently cloned object */
    function get_cloned_sid
        return varchar2 is
    begin
        return v_clone_new_sid;
    exception
        when others then
            log_error('OSI_STATUS_PROC.get_cloned_sid: ' || sqlerrm);
            raise;
    end get_cloned_sid;

    /* Used to process a file transfer */
    procedure transfer_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        --Set the owning unit
        osi_file.set_unit_owner(p_obj, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('OSI_STATUS_PROC.transfer_file: ' || sqlerrm);
            raise;
    end transfer_file;

    /* Used to process a file being closed short */
    procedure mark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_file
           set closed_short = 'Y'
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.mark_closed_short_file: ' || sqlerrm);
            raise;
    end mark_closed_short_file;

    /* Used to process a file being re-opened */
    procedure unmark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_file
           set closed_short = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.unmark_closed_short_file: ' || sqlerrm);
            raise;
    end unmark_closed_short_file;

    /* Used to unarchive a file */
    procedure unarchive_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_temp   varchar2(2000);
    begin
        --Parameter 1 should be the unit
        --Parameter 2 should be the reason

        --Set the owner to the new unit (if it is different than the current unit)
        if (p_parameter1 != osi_file.get_unit_owner(p_obj)) then
            if (p_parameter2 is null) then
                v_temp := 'Unarchive to a Different Unit';
            else
                v_temp := p_parameter2;
            end if;

            osi_file.set_unit_owner(p_obj, p_parameter1, v_temp);
            
            reset_restriction(p_obj);
        end if;

    exception
        when others then
            log_error('OSI_STATUS_PROC.unarchive_file: ' || sqlerrm);
            raise;
    end unarchive_file;

    /* Used to verify that the current user was the one that created the last status history record */
    function verify_user_created_last_sh(p_obj in varchar2)
        return varchar2 is
        v_return       varchar2(3000);
        v_created_by   varchar2(200);
    begin
        v_created_by := OSI_STATUS.last_sh_create_by(p_obj, null);

        if (core_context.personnel_name != v_created_by) then
            v_return := 'Only ' || v_created_by || ' can perform this operation.';
        else
            v_return := null;
        end if;

        return v_return;
    exception
        when others then
            log_error('verify_user_created_last_sh: ' || sqlerrm);
            raise;
    end verify_user_created_last_sh;
    
    procedure confirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_participant.confirm(p_obj);
    exception
        when others then
            log_error('confirm_participant: ' || sqlerrm);
            raise;
    end confirm_participant;

    procedure unconfirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_participant.unconfirm(p_obj);
    exception
        when others then
            log_error('unconfirm_participant: ' || sqlerrm);
            raise;
    end unconfirm_participant;

    procedure set_file_full_id(p_obj in varchar2,
                               p_parameter1 in varchar2 := null,
                               p_parameter2 in varchar2 := null) is
        v_ot_code t_core_obj_type.code%type;
        v_full_id t_osi_file.full_id%type;
    begin
        log_error('set_file_full_id called');

        v_full_id := osi_file.generate_full_id(p_obj);

        if v_full_id is not null then
        update t_osi_file
           set full_id = v_full_id
         where sid = p_obj;
        end if;
    exception when others then
            log_error('OSI_STATUS_PROC.set_file_full_id: ' || sqlerrm);
    end set_file_full_id;
    
    procedure source_burn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_source.burn(p_obj);
    exception
        when others then
            log_error('source_burn: ' || sqlerrm);
    end source_burn;
    
    function source_exists(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_source.already_exists(p_obj);
    exception
        when others then
            log_error('source_exists: ' || sqlerrm);
    end source_exists;
    
    procedure source_migrate(
        p_obj           in varchar2,
        p_parameter1    in varchar2 := null,
        p_parameter2    in varchar2 := null)is
    begin
        v_clone_new_sid := osi_source.migrate(p_obj);
    exception
        when others then
            log_error('source_migrate: ' || sqlerrm);
    end source_migrate;
    
    procedure source_unburn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_source.unburn(p_obj);
    exception
        when others then
            log_error('source_unburn: ' || sqlerrm);
    end source_unburn;
    
    procedure transfer_file_end_assignments(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        transfer_file(p_obj, p_parameter1, p_parameter2);
        end_all_assignments(p_obj);
    exception when others then
        log_error('transfer_file_end_assignments: ' || sqlerrm);
    end transfer_file_end_assignments;
    
    /* Determines whether or not a certain 110 file can be recalled (based on current status) */
    function aapp_can_recall(p_obj in varchar2)
        return varchar2 is
        v_return        varchar2(3000);
        --v_current_lifecycle_state t_osi_status_history
        v_status_code   varchar2(200);
        v_crlf varchar2(200) := Chr(13) ;
    begin
        --Need to lock out Recall during the following status states:
        --NW,CL,STA,RAA,ARCH
        v_status_code := osi_object.get_status_code(p_obj);

        if (v_status_code in ('NW','CL','STA','RAA','ARCH')) then
            v_return :=
                'Recall can not be done in the following lifecycle states:' || v_crlf || 'New' || v_crlf || 'Closed' || v_crlf || 'Sent to Archive' || v_crlf || 'Received At Archive' || v_crlf || 'Archived';
        else
            v_return := null;
        end if;

        return v_return;
    exception
        when others then
            log_error('aapp_can_recall: ' || sqlerrm);
            raise;
    end aapp_can_recall;
    
    procedure recall_aapp_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_new_status    t_osi_status_history.status%type;
    begin
        --Append to Note (Done in After Update process in the Page [Page 5450])
        
        --Get last status (where TO and FROM status are different)
        -->There is no FROM and TO in STATUS_HISTORY
        for K in (select STATUS from t_osi_status_history
        where is_current = 'N' and obj = p_obj order by create_on desc)
        loop
            --Ordering descending, grab the first item and leave
            v_new_status := k.status;
            exit;
        end loop;        
        
        --Change Status to last [real] status (Check to see how this works in a 
        --loop.  Assuming the user might expect to move back multiple 
        --lifecycle steps??) [meaning we would have to find items where 
        --TO and FROM status were different, AND also not coupled by a recall] 
        --NOT DOING THIS: SEE COMMENT BELOW
        osi_status.CHANGE_STATUS_BRUTE(p_obj, v_new_status, 'Recalled To ' || osi_status.GET_STATUS_DESC(v_new_status));
        --Will not be handling looping.  So, it someone Recalls from Open to New, 
        --then Recalls again, it will recall back to Open.
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.recall_aapp_file: ' || sqlerrm);
            raise;
    end recall_aapp_file;
    
    /* Used to change an AAPP (110 File)'s restriction to "Assigned Personnel" on close .  This stops personnel from seeing their own file. */
    procedure aapp_set_restriction_ap(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_new_restriction            t_core_obj.acl%type;
        v_current_restriction_desc   varchar2(300);
    begin
        --Get new restriction
        v_new_restriction := get_restriction_sid('Assigned Personnel');

        --Get the current ACL
        select tor.description
          into v_current_restriction_desc
          from t_osi_reference tor, t_osi_file tof
         where tof.restriction = tor.sid(+) and tof.sid = p_obj;

        --If the ACL is "Assigned Personnel", then we need to change it to
        --Unit and Assigned Personnel
        if (v_current_restriction_desc = 'Unit and Assigned Personnel') then
            --Update T_CORE_OBJ with new ACL
            update t_osi_file
               set restriction = v_new_restriction
             where sid = p_obj;
        end if;
    exception
        when others then
            log_error('OSI_STATUS_PROC.aapp_set_restriction_ap: ' || sqlerrm);
            raise;
    end aapp_set_restriction_ap;

    /* Suspicious Activity (phase) status changes update the "follow-up suffix" */
    procedure sar_phase_update(p_obj in varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        --v_current_lifecycle_state t_osi_status_history
        v_status_code   varchar2(200);
        v_cur_suffix    t_osi_a_suspact_report.followup_suffix%type;
        v_new_suffix    varchar2(50);
        v_version_char   varchar2(1);
    begin
        --get current status
        v_status_code := osi_object.get_status_code(p_obj);

        begin
            select followup_suffix
              into v_cur_suffix
              from t_osi_a_suspact_report
             where sid = p_obj;
        exception
            when NO_DATA_FOUND then
                 v_cur_suffix := '';
        end;

        v_version_char := nvl(substr(v_cur_suffix, 3), '');

        case v_status_code
            when 'SR' then--Submit for Review
            v_new_suffix := 'YN' || v_version_char; 
            when 'SP' then--Submit to Publish
            v_new_suffix := 'YY' || v_version_char; 
            when 'PU' then--Publish SAR
            v_new_suffix := 'NY' || v_version_char; 
            when 'OP' then--Create Echo
               if v_version_char is null then
                  v_version_char := 'a';
               else
                  v_version_char := CHR(ASCII(SUBSTR(v_version_char, 1, 1)) + 1);
               end if;
               v_new_suffix := 'NN' || v_version_char;
        end case;

        update t_osi_a_suspact_report set followup_suffix = v_new_suffix where sid = p_obj;

    exception
        when others then
            log_error('sar_phase_update: ' || sqlerrm);
            raise;
    end sar_phase_update; 

    /*Suspicious Activity "reopen" restores to the last phase transition */
    procedure reopen_sar(
    p_obj          in   varchar2,
    p_parameter1   in   varchar2 := null,
    p_parameter2   in   varchar2 := null) is
    v_cur_suffix    t_osi_a_suspact_report.followup_suffix%type;
    v_status_code   varchar2(100);
    v_to_status     varchar2(20);
    begin
        begin
            select followup_suffix
              into v_cur_suffix
              from t_osi_a_suspact_report
             where SID = p_obj;
        exception
            when NO_DATA_FOUND then
                v_cur_suffix := '';
        end;

        case nvl(substr(v_cur_suffix, 1, 2), '')
            when '' then                                --indicates no phase transitions
                v_status_code := 'CM';
            when 'YN' then                              --indicates last phase was: Submitted for Review
                v_status_code := 'SR';
            when 'YY' then                              --indicates last phase was: Submitted to Publish
                v_status_code := 'SP';
            when 'NY' then                              --indicates last phase was: Published
                v_status_code := 'PU';
            when 'NN' then/* This is special...indicates last phase was Echo created, then completed, closed, and re-opened.
                             In this case the status goes back to 'Published'*/
                v_status_code := 'PU';
        end case;

        select SID
          into v_to_status
          from t_osi_status
         where code = v_status_code;

        OSI_STATUS.change_status_brute(p_obj, v_to_status, 'Reopen');
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when OTHERS then
            log_error('reopen_sar error: ' || sqlerrm);
    end;   

    /*Used to copy special interests on Case when approved*/
    procedure copy_special_interest(
        p_obj          in   varchar2, 
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    
    begin
        
        --delete existing special interests with obj_context of 'A', if any

        delete from t_osi_mission
        where obj = p_obj
        and obj_context = 'A';

        --make copies of existing special interestes

        insert into t_osi_mission (obj, mission, obj_context)
            select obj, mission, 'A'
             from t_osi_mission
            where obj = p_obj
             and obj_context = 'I';

    exception
        when others then
            log_error('OSI_STATUS_PROC.copy_special_interest: ' || sqlerrm);
            raise;
    end copy_special_interest;

    procedure deers_update_links(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        l_result varchar2(32767) := null;
    begin
        -- Status methods that execute AFTER do not have return values.
        l_result := osi_deers.update_all_pv_links(p_obj);
    exception
        when others then
            log_error('osi_status_proc.deers_update_links: ' || sqlerrm);
            raise;
    end deers_update_links;
    
    function check_for_old_partic_links(p_obj in varchar2)
        return varchar2 is
        l_yr_ago   date         := sysdate - 365;
        l_pv_sid   varchar2(50) := null;
    begin
        --Loop through activity participants tied to this file
        for i in (select activity_sid
                    from t_osi_assoc_fle_act
                   where file_sid = p_obj and modify_on > l_yr_ago)
        loop
            for j in (select pv.participant, z.participant_version
                        from v_osi_partic_act_involvement z,
                             t_osi_participant ip,
                             t_osi_participant_version pv
                       where z.activity = i.activity_sid
                         and z.participant_version = pv.sid
                         and pv.participant = ip.sid)
            loop
                begin
                    select sid
                      into l_pv_sid
                      from v_osi_participant_version
                     where participant = j.participant and sid = current_version;
                exception
                    when no_data_found then
                        l_pv_sid := null;
                end;

                if (l_pv_sid <> j.participant_version and l_pv_sid is not null) then
                    --update_pv_links(j.participant_version, l_pv_sid, i.activity_sid, false);
                    --Updatable link was found, return null and allow user to update
                    return null;
                end if;
            end loop;
        end loop;

        --Loop through file participants
        for m in (select pv.participant, f.participant_version
                    from v_osi_partic_file_involvement f,
                         t_osi_participant ip,
                         t_osi_participant_version pv
                   where f.file_sid = p_obj
                     and f.participant_version = pv.sid
                     and pv.participant = ip.sid)
        loop
            begin
                select sid
                  into l_pv_sid
                  from v_osi_participant_version
                 where participant = m.participant and sid = current_version;
            exception
                when no_data_found then
                    l_pv_sid := null;
            end;

            if (l_pv_sid <> m.participant_version and l_pv_sid is not null) then
                
                --Updatable link was found, return null and allow user to update
                return null;
            end if;
        end loop;

        return 'No Participant Links need updating.';
    exception
        when OTHERS then
            log_error('OSI_STATUS_PROC.check_for_old_partic_links: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            raise;
    end check_for_old_partic_links;

    /* Used to transfer ownership of a Poly File automatically based on status. */
    procedure poly_file_auto_transfer(p_obj in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) is
        
        v_transfer_reason  varchar2(500);
        v_prev_unit        varchar2(20);
        v_status_code      varchar2(200);
        
    begin
         v_status_code := osi_object.get_status_code(p_obj);
       
         select transition_comment into v_transfer_reason
           from t_osi_status_history
          where obj = p_obj
            and is_current = 'Y';
        
                      
         --- if 'Awaiting Approval' set the requesting_unit = Poly Auth Unit, if 'Awaiting ---
         ---    Closure' set the RPO Unit = Poly Auth Unit.                                ---
         case
             when v_status_code = 'AA' then
         
                 --- Set Request Unit to Last Owner but ONLY FOR CRIM POLY ---
                 if osi_object.get_objtype_code(core_obj.GET_OBJTYPE(p_obj))='FILE.POLY_FILE.CRIM' then
                   
                   update t_osi_f_poly_file set requesting_unit = osi_file.get_unit_owner(p_obj)where sid = p_obj;-------->core_util.get_config('POLY_SID') where sid = p_obj;
                   
                 end if;
                 
                 --- transfer ownership to Poly Auth Unit ---
                 transfer_file(p_obj, core_util.get_config('POLY_SID'), v_transfer_reason);

             when v_status_code = 'AC' then

                 --- Set RPO Unit to Last Owner ---
                 update t_osi_f_poly_file set rpo_unit = osi_file.get_unit_owner(p_obj)where sid = p_obj;--------> core_util.get_config('POLY_SID') where sid = p_obj;

                 --- transfer ownership to Poly Auth Unit ---
                 transfer_file(p_obj, core_util.get_config('POLY_SID'), v_transfer_reason);

             --- if status is reverting to 'New' or 'Open' transfer ownership to PREVIOUS unit. --- 
             when v_status_code in('NW','OP') then

                 for a in(select unit_sid from t_osi_f_unit
                                where file_sid = p_obj
                                  and end_date is not null
                                order by start_date desc)
                 loop
                     v_prev_unit := a.unit_sid;
                     exit;
                          
                 end loop;

                 --- transfer ownership to the previous unit ---
                 transfer_file(p_obj, v_prev_unit, v_transfer_reason); 

         end case;  
    
    exception
        when OTHERS then
            log_error('OSI_STATUS_PROC.POLY_FILE_AUTO_TRANSFER: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            raise;
    end;

/*Used to copy mission area value at the time the investigative file was approved */
     procedure copy_mission_area(
        p_obj          in   varchar2, 
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    
    begin
           --make copies of existing mission areas

            update t_osi_f_investigation 
                set manage_by_appv = (select manage_by
                                        from t_osi_f_investigation
                                        where sid = p_obj
                                        and manage_by is not null)
                where sid = p_obj;

    exception
        when others then
            log_error('OSI_STATUS_PROC.copy_mission_area: ' || sqlerrm);
            raise;
    end copy_mission_area;

/*Used to fill in the summary of investigation if null and add default suffix when investigative
    file is approved. */
 procedure autofill_summary_inv(
         p_obj          in   varchar2, 
   p_parameter1   in   varchar2 := null,
   p_parameter2   in   varchar2 := null) is

    v_summary clob;

    
    begin 
 
   select summary_investigation
                 into v_summary
             from T_OSI_F_INVESTIGATION
   where sid = p_obj; 
   
    --Copy background into summary investigation if summary investigation is null
    
    if dbms_lob.getlength(v_summary) = 0 then

     update t_osi_f_investigation
      set summary_investigation = (select summary_allegation
                                                       from t_osi_f_investigation
                                                       where sid = p_obj)
       where sid = p_obj;
  
    end if;
    
  --Add default suffix to summary investigation

           update t_osi_f_investigation
    set summary_investigation = summary_investigation || core_util.get_config('OSI.INV_SUMMARY_SUFFIX')
   where sid = p_obj;
 
 exception
        when others then
            log_error('OSI_STATUS_PROC.autofill_summary_inv: ' || sqlerrm);
            raise;
    end autofill_summary_inv; 

procedure create_sum_complaint_rpt(
    p_obj          in   varchar2,
    p_parameter1   in   varchar2 := null,
    p_parameter2   in   varchar2 := null) is
        v_blob           blob;
        v_clob           clob;
        v_in Pls_Integer := 1;
        v_out Pls_Integer := 1;
        v_lang Pls_Integer := 0;
        v_warning Pls_Integer := 0;
        v_attach_count   varchar2(10);
        v_id            varchar2(100);
        v_extension     t_osi_report_mime_type.file_extension%type;
        v_file_name     varchar2(100)                                := 'No_File_ID_Given';
        v_report_type   varchar2(20);
begin
    -- Check for existing SCR and delete if any exist
    select count(*)
      into v_attach_count
      from t_osi_attachment a, t_osi_attachment_type at
     where a.obj = p_obj
       and a.type = at.SID
       and at.usage = 'REPORT'
       and at.code = 'CR';


       if(v_attach_count > 0) then

             delete from t_osi_attachment a
               where a.obj = p_obj
               and a.type =
                 (select SID
                    from t_osi_attachment_type
                   where (usage = 'REPORT' and code = 'CR')
                     and obj_type = core_obj.get_objtype(p_obj));

       end if;

    -- Create Summary Complaint Report
    DBMS_LOB.CREATETEMPORARY(v_blob, FALSE);
    DBMS_LOB.OPEN(v_blob, DBMS_LOB.LOB_READWRITE);
    v_clob := osi_investigation.summary_complaint_rpt(p_obj);
    --Attach complaint report to investigative file
    dbms_lob.converttoblob(v_blob, v_clob, dbms_lob.getlength(v_clob), v_in, v_out, 1 ,v_lang, v_warning);

    --Get file name
    select SID into v_report_type from T_OSI_REPORT_TYPE
  where upper(description) = 'SUMMARY COMPLAINT REPORT';
    select mt.file_extension
      into  v_extension
      from t_osi_report_type rt, t_osi_report_mime_type mt
     where rt.sid = v_report_type and rt.mime_type = mt.sid(+);

    
    -- Look for a File or Activity ID first.
    for x in (select full_id
                from t_osi_file
               where sid = p_obj)
    loop
        v_id := x.full_id;
    end loop;

    if (v_id is not null) then
        v_file_name := v_id;
    end if;

    v_file_name := v_file_name || v_extension;

    
    insert into t_osi_attachment
                (obj, type, content, storage_loc_type, description, source, mime_type, creating_personnel, lock_mode)
         values (p_obj,
                 (select SID
                    from t_osi_attachment_type
                   where (usage = 'REPORT' and code = 'CR')
                     and obj_type = core_obj.get_objtype(p_obj)),
                 v_blob,
                 'DB',
                 'Complaint Report-Final',
                 v_file_name,
                 'application/msword',
                 core_context.personnel_sid, 'LOCKED');
exception
    when others then
        log_error('OSI_STATUS_PROC.create_sum_complaint_rpt: ' || sqlerrm);
        raise;
end create_sum_complaint_rpt;
    
   /* Clears the COMPLETE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_complete_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_activity
           set complete_date = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.act_clear_complete_date: ' || sqlerrm);
            raise;
    end act_clear_complete_date;

    /* Clears the CLOSE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_close_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_activity
           set close_date = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.act_clear_close_date: ' || sqlerrm);
            raise;
    end act_clear_close_date;

    /* At case approval, clear all subjects' negative DCII indications */
    procedure case_clear_negative_indexes(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_dcii_intentions
           set include_in_index = null
         where investigation = p_obj
     and include_in_index = 'N';
    exception
        when others then
            log_error('OSI_STATUS_PROC.case_clear_negative_indexes: ' || sqlerrm);
            raise;
    end case_clear_negative_indexes;

    /* Used to disable a Personnel PW */
    procedure pmm_disable_password(p_obj in varchar2, p_effective_date in date) is
        v_effective_date date;
    begin
        --Get PW Expirt Effective Date
        if (p_effective_date is not null) then
            v_effective_date := p_effective_date;
        else
            v_effective_date := sysdate;
        end if;
        
        --Disable Password
        update t_core_personnel
           set pswd = 'DISABLED'
         where sid = p_obj;

        --Update Pswd Exp. date
        update t_core_personnel
           set pswd_expiration_date = v_effective_date - 30
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_disable_password: ' || sqlerrm);
            raise;
    end pmm_disable_password;

    /* Used to Close a Personnel File (User Account) */
    procedure pmm_close_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status   t_osi_personnel.personnel_status_sid%type;
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);
        
        --Disable Password
        pmm_disable_password(p_obj, v_effective_date);

        --End current unit assignment
        update t_osi_personnel_unit_assign
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --End roles
        update t_osi_personnel_unit_role
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --End privs
        update t_osi_personnel_priv
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --Clear Badge Number
        update t_osi_personnel
           set badge_num = null
         where sid = p_obj;

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'CL';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_close_account: ' || sqlerrm);
            raise;
    end pmm_close_account;

    /* Used to verify that the current user is allowed to close the given account SID */
    function pmm_user_can_close_account(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
    begin
        if (core_context.personnel_sid = p_obj) then
            v_return := 'You may not close your own Personnel Record.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_close_account: ' || sqlerrm);
            raise;
    end pmm_user_can_close_account;

    /* Used to Suspend a Personnel File (User Account) */
    procedure pmm_suspend_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status   t_osi_personnel.personnel_status_sid%type;
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);
        
        
        --Disable Password
        pmm_disable_password(p_obj, v_effective_date);

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'SU';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_suspend_account: ' || sqlerrm);
            raise;
    end pmm_suspend_account;

    /* Used to Reopen a Personnel File (User Account) */
    procedure pmm_reopen_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_username   t_core_personnel.login_id%type;
        v_status     t_osi_personnel.personnel_status_sid%type;
        v_ok         varchar2(200);
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);

        --Get Username
        select login_id
          into v_username
          from t_core_personnel
         where sid = p_obj;

        --Reset Password
        v_ok := core_context.reset_pswd(v_username, core_util.get_config('CORE.PSWD_RESET'));

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'OP';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_reopen_account: ' || sqlerrm);
            raise;
    end pmm_reopen_account;

    /* Used to verify that the current user is allowed to reopen the given account SID */
    function pmm_user_can_reopen_account(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
    begin
        --Must be able to reset a PW
        if (osi_auth.check_for_priv('RESET_PW', core_obj.get_objtype(p_obj)) <> 'Y') then
            v_return :=
                'You do not have permission to reset a users password which is required to reopen an account.'
                || chr(13);
        end if;

        --Target Personnel must have a current Unit Assignment
        if (osi_personnel.get_current_unit(p_obj) is null) then
            v_return :=
                v_return
                || 'This account can only be re-opened if the Agent has been assigned to a Unit.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_reopen_account: ' || sqlerrm);
            raise;
    end pmm_user_can_reopen_account;

    /* Used to reset password via the Actions Menu */
    procedure pmm_handle_pw_reset(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_username   t_core_personnel.login_id%type;
        v_ok         varchar2(200);
    begin
        --Get Username
        select login_id
          into v_username
          from t_core_personnel
         where sid = p_obj;

        --Reset Password
        v_ok := core_context.reset_pswd(v_username, core_util.get_config('CORE.PSWD_RESET'));
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_handle_pw_reset: ' || sqlerrm);
            raise;
    end pmm_handle_pw_reset;
    
    /* PMM: Used to Fix Login ID's via the Actions Menu */
    procedure pmm_handle_fix_login_id(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_current_login_id t_core_personnel.LOGIN_ID%type;
        v_new_id            t_core_personnel.LOGIN_ID%type;
        v_orig_ln        varchar2(100);
        v_fi             varchar2(1);
        v_mi             varchar2(1);
        v_ln             varchar2(50);
        v_id             varchar2(30);
        v_fname         varchar2(100);
        v_mname         varchar2(100);
        v_lname         varchar2(100);
     
        begin
              --Get Old ID and other info
        select login_id, last_name, first_name, middle_name 
         into v_current_login_id, v_lname, v_fname, v_mname
          from t_core_personnel where sid = p_obj;
        
        
        --Save off Original Last Name (minus spaces and dashes and apostrophies)
        v_orig_ln := replace(v_lname, '-', '');
        v_orig_ln := replace(v_orig_ln, ' ', '');
        v_orig_ln := replace(v_orig_ln, '''', '');
        --Get first initial
        v_fi := substr(v_fname, 1, 1);
        --Get middle initial
        v_mi := substr(v_mname, 1, 1);
        --Put both together
        v_id := v_fi || v_mi;
        --Get Last Name
        v_ln := ltrim(upper(v_orig_ln), 8 - length(v_id));
        --Concatonate ID
        v_id := substr(v_id || v_ln, 0, 8);
        
        if (v_current_login_id <> v_id) then
            --If these two are the same, then the only thing we would be 
            --doing is incrementing the nunber at the end, which is pointless
            v_new_id := osi_personnel.CREATE_LOGIN_ID(v_fname, v_mname, v_lname);
                     
            update t_core_personnel
            set login_id = v_new_id where sid = p_obj;
        end if;
         
        exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_handle_fix_login_id: ' || sqlerrm);
            raise;
    end pmm_handle_fix_login_id;
    
    
    /* PMM: Used to verify that the current user is allowed to fix a login ID on the given account SID */
    function pmm_user_can_fix_login_id(p_obj in varchar2)
      
      return varchar2 is
        v_return   varchar2(3000) := null;
    begin
         if (core_context.personnel_sid = p_obj) then
            v_return := 'You may not fix your own Login ID.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_fix_login_id: ' || sqlerrm);
            raise;
    end pmm_user_can_fix_login_id;
    
    /*PMM: Returns message as to whether the object has open assignments. */
   function pmm_check_for_active_assign(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
        v_act      boolean := false;
        v_file     boolean := false;
    begin
        for k in (select *
                    from t_osi_assignment oa
                   where personnel = p_obj
                     and end_date is null
                     and osi_object.get_objtype_code(core_obj.get_objtype(oa.obj)) like 'ACT%')
        loop
            v_act := true;
        end loop;

        for k in (select *
                    from t_osi_assignment oa
                   where personnel = p_obj
                     and end_date is null
                     and osi_object.get_objtype_code(core_obj.get_objtype(oa.obj)) like 'FILE%')
        loop
            v_file := true;
        end loop;

        if (v_act and v_file) then
            v_return :=
                'This user has current assignment(s) in both Activities and Files, are you sure you would like to perform this action?';
        elsif(v_act and not v_file) then
            v_return :=
                'This user has current assignment(s) in Activities, are you sure you would like to perform this action?';
        elsif(not v_act and v_file) then
            v_return :=
                'This user has current assignment(s) in Files, are you sure you would like to perform this action?';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_check_for_active_assign: ' || sqlerrm);
            raise;
    end pmm_check_for_active_assign;

    function Get_Subject_Selection_HTML (p_obj in Varchar2) return clob is
    
        vCRLF            varchar2(2) :=  chr(10) || chr(13);
        l_rowCount       number default 1;
        l_i2msTable      clob;
        object_type      varchar2(100);
        v_name           varchar2(400);
        v_partic_version varchar2(20);
        
        vCursor sys_refcursor;
                
    begin
         l_i2msTable := '<P ALIGN=CENTER><TABLE ID="SubjectList">' || vCRLF || ' <TR ID="HeaderRow">' || vCRLF;
         l_i2msTable := l_i2msTable || '  <TD ID="HeaderColumn">*** Pick Subjects to Include in New Case File ***</TD>' || ' </TR>';

         l_rowCount := 0;

         --See if it is File or Activity--        
         select t.code into object_type from t_core_obj o,t_core_obj_type t where o.sid=p_obj and o.OBJ_TYPE=t.sid;
         if object_type like 'ACT.%' then

           open vCursor for SELECT osi_participant.get_name(participant_version) as name,participant_version FROM v_osi_partic_act_involvement WHERE activity=p_obj and role='Subject' order by name;      
         
         else

           open vCursor for SELECT osi_participant.get_name(participant_version) as name,participant_version FROM v_osi_partic_file_involvement WHERE file_sid=p_obj and role='Subject' order by name;      

         end if;
         
         loop
             FETCH vCursor INTO v_name, v_partic_version;
             EXIT WHEN vCursor%NOTFOUND;             
             l_i2msTable := l_i2msTable || ' <TR ';
               
             if mod(l_rowCount, 2) = 0 then
               
               l_i2msTable := l_i2msTable || 'ID="evenRow"';

             else
               
               l_i2msTable := l_i2msTable || 'ID="oddRow"';
                 
             end if;

             l_i2msTable := l_i2msTable || '><TD ID="theLabel"><input checked="true" name="p_t32" id="P5450_SUBJECT_CHECKBOX_' || l_rowCount || '" type="checkbox" value="' || v_partic_version || '" />' || v_name || '</TD></TR>' || vCRLF;

             l_rowCount := l_rowCount + 1;
         
         end loop;
     
         l_i2msTable := l_i2msTable || '</TABLE></P>' || vCRLF;
         
         close vCursor;
         if l_rowCount > 1 then

           log_error('Get_Subject_Selection_HTML returned=' || l_i2msTable);
           return l_i2msTable;
           
         else

           log_error('Get_Subject_Selection_HTML returned=NOTHING');
           return '';

         end if;
                 
         exception
             when others then
                 log_error('ERROR IN Get_Subject_Selection_HTML=' || sqlerrm);
                 raise;   
     
    end Get_Subject_Selection_HTML;

    procedure clone_to_dcii(
        p_sid          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_sfs_investigation.clone_to_dcii(p_sid, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('clone_to_dcii: ' || sqlerrm);
            raise;
    end clone_to_dcii;
 
end osi_status_proc;
/






set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   10:36 Friday November 9, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.0.00.27
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
 
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>apex_util.find_security_group_id(user));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en-us'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2009.01.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := 100;
   wwv_flow_api.g_id_offset := 0;
null;
 
end;
/

PROMPT ...Remove page 5100
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5100);
 
end;
/

 
--application/pages/page_05100
prompt  ...PAGE 5100: Attachments
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript1.1" type="text/javascript">'||chr(10)||
''||chr(10)||
'    function SetDescription()'||chr(10)||
'    {'||chr(10)||
'     var pathname = $v(''P5100_SOURCE_DISPLAY1'');'||chr(10)||
''||chr(10)||
'     var filename = '||chr(10)||
'        pathname.substr(pathname.lastIndexOf("\\")+1,pathname.length)'||chr(10)||
''||chr(10)||
'     var ext ='||chr(10)||
'        filename.substr(filename.lastIndexOf("."),filename.length)'||chr(10)||
'     '||chr(10)||
'     if ($v(''P5100_LOCATION'')==''DB'' || $v(''P5100_LOCATION'')==''FILE'')'||chr(10)||
'       ';

ph:=ph||'{'||chr(10)||
'        if (filename==ext)'||chr(10)||
'          $s(''P5100_DESCRIPTION'',filename);'||chr(10)||
'        else'||chr(10)||
'          $s(''P5100_DESCRIPTION'',filename.replace(ext,""));'||chr(10)||
''||chr(10)||
'        $s(''P5100_LAST_FILE_PICKED'',pathname);'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
'    function CheckDescription()'||chr(10)||
'    {'||chr(10)||
'     if ($v(''P5100_LOCATION'')==''DB'' || $v(''P5100_LOCATION'')==''FILE'')'||chr(10)||
'       {'||chr(10)||
'        if (!$v_IsEmpty(''P5100_SOURCE_DISPLAY1''))'||chr(10)||
'          {'||chr(10)||
'           i';

ph:=ph||'f ($v_IsEmpty(''P5100_DESCRIPTION''))'||chr(10)||
'             {'||chr(10)||
'              alert("Description is required.");'||chr(10)||
'              //$f_First_field(''P5100_DESCRIPTION'');'||chr(10)||
'              //return false;'||chr(10)||
'              SetDescription();'||chr(10)||
'              return true;'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
'     return true;'||chr(10)||
'    }'||chr(10)||
' '||chr(10)||
'    function ReleaseCheck()'||chr(10)||
'    {'||chr(10)||
'     return true;'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"'||chr(10)||
''||chr(10)||
'<';

ph:=ph||'!-- jQuery SWFUpload Code -->'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jquery/jquery-swfupload/js/swfupload/swfupload.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jquery/jquery-swfupload/js/jquery.swfupload.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jquery/js/jquery.jqplugin.1.0.2.min.js"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'	$(''';

ph:=ph||'#swfupload-control'').swfupload({'||chr(10)||
'                upload_url: "#IMAGE_PREFIX#jquery/jquery-swfupload/upload-file.php",'||chr(10)||
'                file_post_name: ''uploadfile'','||chr(10)||
'                file_size_limit : "15360",'||chr(10)||
'                file_types : "*.*",'||chr(10)||
'                file_types_description : "All files",'||chr(10)||
'                file_upload_limit : 10,'||chr(10)||
'                flash_url : "#IMAGE_PREFIX#jquery/jquery-swfupl';

ph:=ph||'oad/js/swfupload/swfupload.swf",'||chr(10)||
'                button_image_url : ''#IMAGE_PREFIX#jquery/jquery-swfupload/js/swfupload/SelectFilesButton.png'','||chr(10)||
'                button_width : 110,'||chr(10)||
'                button_height : 22,'||chr(10)||
'                button_placeholder : $(''#button'')[0],'||chr(10)||
'                debug: false'||chr(10)||
'	})'||chr(10)||
'		.bind(''fileQueued'', function(event, file){'||chr(10)||
'			var listitem=''<li id="''+file.id+''" >''+'||chr(10)||
'				''File:';

ph:=ph||' <em>''+file.name+''</em> (''+Math.round(file.size/1024)+'' KB) <span class="progressvalue" ></span>''+'||chr(10)||
'				''<div class="progressbar" ><div class="progress" ></div></div>''+'||chr(10)||
'				''<p class="status" >Pending</p>''+'||chr(10)||
'				''<span class="cancel" >&nbsp;</span>''+'||chr(10)||
'				''</li>'';'||chr(10)||
'			$(''#log'').append(listitem);'||chr(10)||
'			$(''li#''+file.id+'' .cancel'').bind(''click'', function(){'||chr(10)||
'				var swfu = $.swfupload.getInstance(''#swfupload';

ph:=ph||'-control'');'||chr(10)||
'				swfu.cancelUpload(file.id);'||chr(10)||
'				$(''li#''+file.id).slideUp(''fast'');'||chr(10)||
'			});'||chr(10)||
''||chr(10)||
'			// start the upload since it''s queued'||chr(10)||
'			$(this).swfupload(''startUpload'');'||chr(10)||
'		})'||chr(10)||
'		.bind(''fileQueueError'', function(event, file, errorCode, message)'||chr(10)||
'                     {'||chr(10)||
'                      if(errorCode==-100)'||chr(10)||
'                        alert(''You are allowed to upload ''+message+'' files at a time.'');'||chr(10)||
'     ';

ph:=ph||'                 else'||chr(10)||
'			alert(''Size of the file ''+file.name+'' is greater than 15MB limit'');'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''fileDialogComplete'', function(event, numFilesSelected, numFilesQueued){'||chr(10)||
'			$(''#queuestatus'').text(''Files Selected: ''+numFilesSelected+'' / Queued Files: ''+numFilesQueued);'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadStart'', function(event, file){'||chr(10)||
''||chr(10)||
'                        var param = {''actualfilename'' : ''&USER_SID.''';

ph:=ph||'+file.name};'||chr(10)||
'                        $(this).swfupload(''setPostParams'', param);'||chr(10)||
''||chr(10)||
'			$(''#log li#''+file.id).find(''p.status'').text(''Uploading...'');'||chr(10)||
'			$(''#log li#''+file.id).find(''span.progressvalue'').text(''0%'');'||chr(10)||
'			$(''#log li#''+file.id).find(''span.cancel'').hide();'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadProgress'', function(event, file, bytesLoaded){'||chr(10)||
'			//Show Progress'||chr(10)||
'			var percentage=Math.round((bytesLoaded/file.size';

ph:=ph||')*100);'||chr(10)||
'			$(''#log li#''+file.id).find(''div.progress'').css(''width'', percentage+''%'');'||chr(10)||
'			$(''#log li#''+file.id).find(''span.progressvalue'').text(percentage+''%'');'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadSuccess'', function(event, file, serverData){'||chr(10)||
'			var item=$(''#log li#''+file.id);'||chr(10)||
'			item.find(''div.progress'').css(''width'', ''100%'');'||chr(10)||
'			item.find(''span.progressvalue'').text(''100%'');'||chr(10)||
'			item.addClass(''success'').find(''p.statu';

ph:=ph||'s'').html(''Upload complete...Loading into Database...'');'||chr(10)||
''||chr(10)||
'                        var get = new htmldb_Get(null,'||chr(10)||
'                                                 $v(''pFlowId''),'||chr(10)||
'                                                 ''APPLICATION_PROCESS=ATTACHMENTS_SAVE_TO_DATABASE'','||chr(10)||
'                                                 $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'                        var serverDataSplit = serverD';

ph:=ph||'ata.split("~~~");'||chr(10)||
''||chr(10)||
'                        get.addParam(''x01'',''&P5100_OBJ1.'');        // OBJ'||chr(10)||
'                        get.addParam(''x02'',''&USER_SID.'');          // User SID'||chr(10)||
'                        get.addParam(''x03'',serverDataSplit[0]);    // Filename'||chr(10)||
'                        get.addParam(''x04'',serverDataSplit[1]);    // MimeType'||chr(10)||
'                        gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'			if(gReturn = ';

ph:=ph||'"")'||chr(10)||
'                          item.find(''p.status'').html(''Upload complete......'');'||chr(10)||
'                        else '||chr(10)||
'                          item.find(''p.status'').html(''Upload complete...''+gReturn);'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadError'', function(event, file, errorCode, message)'||chr(10)||
'                     {'||chr(10)||
'                      if(errorCode!==-240)'||chr(10)||
'                        {'||chr(10)||
'			 var item=$(''#log li#''+file.id);'||chr(10)||
'			 ';

ph:=ph||'item.addClass(''error'').find(''p.status'').html(''Upload Failed...''+message);'||chr(10)||
'                        }'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadComplete'', function(event, file){'||chr(10)||
'			// upload has completed, try the next one in the queue'||chr(10)||
'			$(this).swfupload(''startUpload'');'||chr(10)||
''||chr(10)||
'                        var stats = $.swfupload.getInstance(''#swfupload-control'').getStats();'||chr(10)||
''||chr(10)||
'                        if(stats.files_queued <= 0)'||chr(10)||
'  ';

ph:=ph||'                        {'||chr(10)||
'                           alert(''Uploads are complete, please click OK to refresh this page....'');'||chr(10)||
'                           clearDirty();'||chr(10)||
'                           doSubmit(''MULTI_SAVED'');'||chr(10)||
'                          }'||chr(10)||
'		})'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'<!-- jQuery SWFUpload Code -->'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 5100,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Attachments',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P5100_SEL_ATTACHMENT.'');"',
  p_step_sub_title => 'Attachments',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'$(window).load(function(){  '||chr(10)||
''||chr(10)||
'  var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' if(jQuery.browser.flash==false)'||chr(10)||
'   {'||chr(10)||
'    $("label[for=P5100_SWFUPLOAD],#P5100_SWFUPLOAD").hide();'||chr(10)||
'   }'||chr(10)||
'});'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121109103529',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '21-OCT-2010  J.Faris - WCHG0000319 updated javascript ''description'' validation to set the default description instead of constantly popping the message.'||chr(10)||
''||chr(10)||
'11-Apr-2011 Tim Ward - Made Report not Use Pagination, gets rid of problems '||chr(10)||
'                       when items are deleted and Pagination changes.  User '||chr(10)||
'                       gets an ugly error until they close the browser and '||chr(10)||
'                       re-open it.  '||chr(10)||
''||chr(10)||
'                       Also set FileSize/Attached By/On to NoWrap to '||chr(10)||
'                       make them look better.'||chr(10)||
''||chr(10)||
'                       Made FileSize Right Justified.'||chr(10)||
''||chr(10)||
'                       Made the Report go 100% width.'||chr(10)||
''||chr(10)||
'18-May-2011 Tim Ward - CR#3783 and 3834 - Move Case File back to open if'||chr(10)||
'                       the "ROI/CSR Final Published" Report Type is changed.'||chr(10)||
'                       Changed in Process "change_status_back_OP", now runs'||chr(10)||
'                       on DELETE,SAVE.'||chr(10)||
''||chr(10)||
'15-Sep-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
'07-Oct-2011 - CR#3946 - Add ParentInfo Open Link to Grid and Selected'||chr(10)||
'                        Attachment Detials so the users can get to the'||chr(10)||
'                        parent quickly (if it is not the same as this file).'||chr(10)||
'                        Added File/Activity to the Grid, changed the value'||chr(10)||
'                        of P5100_OBJ_TAG is in "Preload Items".  Changed '||chr(10)||
'                        Condition of P5100_OBJ_TAG to be displayed only if'||chr(10)||
'                        P5100_USAGE=''ATTACHMENT'' since that is the only one '||chr(10)||
'                        that has filters to show attachments from associated '||chr(10)||
'                        files/activities.  Also changed '||chr(10)||
'                        OSI_OBJECT.GET_OPEN_LINK so it returns 32000 instead '||chr(10)||
'                        of 200 in the Link since the parentinfo can be as long '||chr(10)||
'                        as the title + a few characters...'||chr(10)||
''||chr(10)||
'07-Oct-2011  Tim Ward - Added Shift Up/Down Key for Navigation. '||chr(10)||
'                        Added "JS_REPORT_AUTO_SCROLL" to HTML Header.  '||chr(10)||
'                        Added onkeydown="return checkForUpDownArrows '||chr(10)||
'                        (event, ''&P5100_SEL_ATTACHMENT.'');" to HTML Body'||chr(10)||
'                        Attribute. '||chr(10)||
'                        Added name=''#SID#'' to "Link Attributes" of the '||chr(10)||
'                        SID Column of the Report. '||chr(10)||
'                        Added a new Branch to'||chr(10)||
'                                 "f?p=&APP_ID.:5100:&SESSION.::&DEBUG.:::#&5100_SEL_NOTE.",'||chr(10)||
'                        this allows the report to move the the Anchor '||chr(10)||
'                        of the selected currentrow.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
''||chr(10)||
'19-Jan-2012 Tim Ward - CR#3776 - Allow Adding Attachments after Closure, but hide the Save/Delete'||chr(10)||
'                        buttons so items can''t be changes/deleted.'||chr(10)||
''||chr(10)||
'01-May-2012 - Tim Ward - CR#4044 - Added ROI Print and Print Order Fields.'||chr(10)||
'                          Changed Query to join new table'||chr(10)||
'                          T_OSI_REPORT_ROI_ATTACH.'||chr(10)||
''||chr(10)||
'21-May-2012 - Tim Ward - CR#4070 - Source Files shouldn''t show filters.'||chr(10)||
''||chr(10)||
'25-Sep-2012 - Tim Ward - CR#3710, 3861 - Multiple uploads at once.'||chr(10)||
''||chr(10)||
'09-Nov-2012 - Tim Ward - CR#4186 - Hide Save, Delete, Browse, and Select'||chr(10)||
'                          when LOCK_MODE is not null.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5100,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<div class="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 2573503288822953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_required_role => '!'||(5499017822598037+ wwv_flow_api.g_id_offset),
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 8105502134151193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Access Denied',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE = ''PERSONNEL'''||chr(10)||
'and'||chr(10)||
':TAB_ENABLED <> ''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89968506459315951 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Details of Selected &P5100_USAGE_DISPLAY. <font color="red"><i>([shift]+[down]/[up] to navigate &P5100_USAGE_DISPLAY.(s))</i></font>',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5100_SEL_ATTACHMENT IS NOT NULL OR :P5100_MODE = ''ADD''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89968731421315953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89968931968315953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Choose the Attached Reports to Display',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5100_IS_FILE = ''Y'''||chr(10)||
'AND :P0_OBJ_TYPE_CODE NOT IN (''FILE.SOURCE'')',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select a.sid "SID",'||chr(10)||
'       decode(a.storage_loc_type,'||chr(10)||
'              ''OUTSIDE'', '''','||chr(10)||
'              ''<a href=''''f?p=&APP_ID.:250:&SESSION.:'' || a.sid'||chr(10)||
'              || '':&DEBUG.:250:'''' target=''''_blank''''><img src="#IMAGE_PREFIX#themes/OSI/arrow_down-small.png" alt="Download/View" /></a>'') as "Download",'||chr(10)||
'       decode(a.mime_type,'||chr(10)||
'              null, ''Hard Copy'','||chr(10)||
'              ''<img src="&IMAGE_PREFIX.'''||chr(10)||
'';

s:=s||'              || osi_util.get_mime_icon(a.mime_type, a.source) || ''" alt="'' || a.mime_type || ''"> '') as "File Type",'||chr(10)||
'       a.description as "Description",'||chr(10)||
'       (select nvl(description, ''-'')'||chr(10)||
'          from t_osi_attachment_type at'||chr(10)||
'         where sid = a.type'||chr(10)||
'           and (   at.usage = :p5100_usage'||chr(10)||
'                or at.usage is null and :p5100_usage = ''ATTACHMENT'')) as "Attachment Type",'||chr(10)||
'    ';

s:=s||'   osi_util.parse_size(dbms_lob.getlength(a.content)) as "File Size",'||chr(10)||
'       a.create_by as "Attached By", a.create_on as "Date Attached",'||chr(10)||
'       decode(a.sid, :p5100_sel_attachment, ''Y'', ''N'') "Current",'||chr(10)||
'       decode(:P5100_OBJ, a.obj, core_obj.get_parentinfo(a.obj), osi_object.get_open_link(a.obj,core_obj.get_parentinfo(a.obj))) as "File/Activity",'||chr(10)||
'       decode(ra.attachment,a.sid,''Yes'',''No'') a';

s:=s||'s "Print",'||chr(10)||
'       nvl(ra.seq,0) as "Order"'||chr(10)||
'  from t_osi_attachment a,'||chr(10)||
'       t_osi_attachment_type at,'||chr(10)||
'       t_osi_report_roi_attach ra'||chr(10)||
' where (at.sid(+) = a.type'||chr(10)||
'   and nvl(at.usage, ''ATTACHMENT'') = :p5100_usage)'||chr(10)||
'   and (a.sid=ra.attachment(+) and a.obj=ra.obj(+))'||chr(10)||
'   &P5100_FILTERS.';

wwv_flow_api.create_report_region (
  p_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_name=> '&P5100_USAGE_DISPLAY.s',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P0_obj_type_code <> ''PERSONNEL'''||chr(10)||
'or'||chr(10)||
'(:P0_OBJ_TYPE_CODE = ''PERSONNEL'' and :TAB_ENABLED = ''Y'')',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '1000000000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No &P5100_REPORT_MSG. found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '1000000000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P5100_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000627243874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'N',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000728149874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Download',
  p_column_display_sequence=> 3,
  p_column_heading=> '&nbsp;',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000821042874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'File Type',
  p_column_display_sequence=> 2,
  p_column_heading=> 'File Type',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000911699874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Description',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Description',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001006826874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Attachment Type',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Attachment Type',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'ITEM_NOT_NULL_OR_ZERO',
  p_display_when_condition=> 'p5100_show_type',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001133157874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'File Size',
  p_column_display_sequence=> 8,
  p_column_heading=> 'File Size',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001229742874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Attached By',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Attached By',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001316967874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Date Attached',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Date Attached',
  p_column_format=> '&FMT_DATE.',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001428251874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8268816223964004 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'File/Activity',
  p_column_display_sequence=> 12,
  p_column_heading=> 'File/Activity',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P5100_USAGE=''ATTACHMENT'''||chr(10)||
'AND :P5100_IS_FILE=''Y'''||chr(10)||
'AND :P5100_ASSOC_ATTACHMENTS NOT IN (''ME'')',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13428607875061818 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Print',
  p_column_display_sequence=> 4,
  p_column_heading=> 'ROI Print?',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13429501519126245 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Order',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Print Order',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89969128704315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 40,
  p_button_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5100_ADD_LABEL.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> '(:P0_OBJ_TYPE_CODE not in (''PERSONNEL'',''UNIT'') and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
''||chr(10)||
'or'||chr(10)||
''||chr(10)||
'((:P0_OBJ_TYPE_CODE = ''PERSONNEL'' and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
'and'||chr(10)||
'osi_auth.check_for_priv(''ATCH'', :P0_OBJ_TYPE_SID) = ''Y'')'||chr(10)||
''||chr(10)||
'or'||chr(10)||
''||chr(10)||
'((:P0_OBJ_TYPE_CODE = ''UNIT'' and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
'and'||chr(10)||
'osi_auth.check_for_priv(''ATCH'', :P0_OBJ_TYPE_SID) = ''Y'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969714565315956 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 20,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5100_SEL_ATTACHMENT IS NOT NULL AND'||chr(10)||
':P5100_IS_ASSOC IS NOT NULL AND'||chr(10)||
':P0_WRITABLE=''Y'' AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969520283315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 30,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P5100_SEL_ATTACHMENT',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969307841315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 10,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P5100_SEL_ATTACHMENT IS NOT NULL AND'||chr(10)||
':P5100_IS_ASSOC IS NOT NULL AND'||chr(10)||
'(osi_auth.check_for_priv(''ATCH_DELETE'', :p0_obj_type_sid) = ''Y'' or :p5100_CREATING_PERSONNEL = :user_sid) AND'||chr(10)||
':p0_writable=''Y'' AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_button_comment=>'--- Line Removed from Condition 19-Jan-2012'||chr(10)||
'---((:p0_obj_type_code = ''FILE.SFS'' and :p0_writable = ''Y'' and osi_object.get_status_code(:p0_obj) not in (''CL'',''SV'',''AV'',''RV'')) or true)',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16177023862626890 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 70,
  p_button_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 5100);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91072535069823301 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 60,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_cattributes=>'onclick="javascript:ReleaseCheck();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89977419753315976 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>89977231569315974 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_branch_action=> 'f?p=&APP_ID.:5100:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P5100_OBJ1.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5781903038960339 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 365,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6541403513057628 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_CREATING_PERSONNEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 335,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'CREATING_PERSONNEL',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8105819813151210 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ACCESS_DENIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8105502134151193+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Access Denied',
  p_source=>'You do not have permission to view the contents of this tab.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8751615819100764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_RPT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 345,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select sid '||chr(10)||
'from t_osi_attachment_type '||chr(10)||
'where (usage = ''REPORT'' and code = ''CR'') '||chr(10)||
'and obj_type = :p0_obj',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13429003204098276 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_PRINT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 375,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'ROI Print?',
  p_source=>'PRINT',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13429227099105246 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_PRINT_ORDER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 385,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Print Order',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14705005429767507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SWFUPLOAD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 121.5,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Upload Multiple Attachments',
  p_source=>'<style type="text/css" >'||chr(10)||
'#swfupload-control p{ margin:10px 5px; font-size:0.9em; }'||chr(10)||
'#log{ margin:0; padding:0; width:500px;}'||chr(10)||
'#log li{ list-style-position:inside; margin:2px; border:1px solid #ccc; padding:10px; font-size:12px; '||chr(10)||
'	font-family:Arial, Helvetica, sans-serif; color:#333; background:#fff; position:relative;}'||chr(10)||
'#log li .progressbar{ border:1px solid #333; height:5px; background:#fff; }'||chr(10)||
'#log li .progress{ background:#999; width:0%; height:5px; }'||chr(10)||
'#log li p{ margin:0; line-height:18px; }'||chr(10)||
'#log li.success{ border:1px solid #339933; background:#ccf9b9; }'||chr(10)||
'#log li.error{ border:1px solid #B84D4D; background:#FF0000; }'||chr(10)||
'#log li span.cancel{ position:absolute; top:5px; right:5px; width:20px; height:20px; '||chr(10)||
'	background:url(''#IMAGE_PREFIX#jquery/jquery-swfupload/js/swfupload/cancel.png'') no-repeat; cursor:pointer; }'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<div id="swfupload-control">'||chr(10)||
'	<input type="button" id="button" /><label id="queuestatus" >Files Selected: 0 / Queued Files: 0</label>'||chr(10)||
'	<ol id="log"></ol>'||chr(10)||
'</div>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes2=> ' id="SWFUpload_Label_0"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'') AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16177203908630507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 355,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17486217734384656 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCK_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 395,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'LOCK_MODE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970108112315956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_ATTACHMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SEL_ATTACHMENT=',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970324808315956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Location',
  p_source=>'P5100_LOCATION_VALUE',
  p_source_type=> 'ITEM',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'SELECT DESCRIPTION, CODE'||chr(10)||
'FROM T_OSI_ATTACHMENT_LOC_TYPE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Location -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_read_only_when=>'P5100_SEL_ATTACHMENT',
  p_read_only_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970517561315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source=>'DESCRIPTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onblur="javascript:CheckDescription();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970730016315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DATE_MODIFIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Modified',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'DATE_MODIFIED',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970922565315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ_TAG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File/Activity',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT IS NOT NULL'||chr(10)||
'AND :P5100_USAGE=''ATTACHMENT'''||chr(10)||
'AND :P5100_IS_FILE=''Y'''||chr(10)||
'AND :P5100_ASSOC_ATTACHMENTS NOT IN (''ME'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971135606315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Type',
  p_source=>'TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_attachment_type'||chr(10)||
'   where obj_type=:p0_obj_type_sid and usage = :p5100_usage'||chr(10)||
'     and (active = ''Y'' or sid = :p5100_sel_attachment)'||chr(10)||
'order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Attachment Type -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'p5100_show_type',
  p_display_when_type=>'ITEM_NOT_NULL_OR_ZERO',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971512072315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ASSOC_ATTACHMENTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 89968931968315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ME',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Attachments for this File;ME,Attachments for Associated Files;A_FILES,Attachments for Associated Activities;A_ACT,Attachments for Inherited Activities;I_ACT',
  p_lov_columns=> 4,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''UPDATE'');"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971709629315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_IS_FILE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_IS_FILE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971918229315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_USAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_USAGE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972135266315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_USAGE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_USAGE_DISPLAY',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972324566315960 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ADD_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_ADD_LABEL',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972514425315960 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_FILENAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'SUBSTR(:P5100_SOURCE, INSTR(:P5100_SOURCE, ''/'')+1)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'') AND :P5100_SEL_ATTACHMENT IS NOT NULL',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'SUBSTR(:P5100_SOURCE, INSTR(:P5100_SOURCE, ''/'')+1)');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972728423315962 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 305,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_OBJ=',
  p_source=>'OBJ',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972928881315967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DEFAULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_DEFAULT=',
  p_source=>'SELECT DEFAULT_SOURCE'||chr(10)||
'  FROM T_OSI_ATTACHMENT_LOC_TYPE'||chr(10)||
' WHERE CODE = :P5100_LOCATION;',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89973111291315967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE=',
  p_source=>'SOURCE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89973321073315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCATION_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_LOCATION_VALUE=',
  p_source=>'STORAGE_LOC_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89973723512315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DISPLAY1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 121,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '&P5100_SOURCE_DEFAULT.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
  p_display_as=> 'FILE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:SetDescription();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'') AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89974116508315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 116,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'Filename',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_LABEL=',
  p_source=>'SELECT LT.SOURCE_LABEL'||chr(10)||
'  FROM T_OSI_ATTACHMENT_LOC_TYPE LT'||chr(10)||
' WHERE LT.CODE = :P5100_LOCATION',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89974306816315970 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DISPLAY2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 122,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '&P5100_SOURCE_DEFAULT.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE = ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90191435144745245 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_VALUE',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91696110052924568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_FILE_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Type',
  p_source=>'select ''<img src="'' || ''&IMAGE_PREFIX.'''||chr(10)||
'       || osi_util.get_mime_icon(:p5100_mime_type, :p5100_source) || ''" alt="'' || :p5100_mime_type || ''"> '''||chr(10)||
'  from dual',
  p_source_type=> 'QUERY',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91696432216930996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_SIZE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Size',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91697016417935865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_ATTACHED_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Attached By',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P5100_SEL_ATTACHMENT',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93438721493928231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DOWNLOAD_LINK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 155,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Download',
  p_source=>'<a href=''f?p=&APP_ID.:250:&SESSION.:&P5100_SEL_ATTACHMENT.:&DEBUG.:250:'' target=''_blank''>Download</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93539128547458334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_MODE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95314813809105521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_REPORT_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'LOWER(:P5100_USAGE_DISPLAY) || ''s''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95795113446811165 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_MIME_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 315,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'MIME_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95987930071629068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_FILTERS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_FILTERS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96043334900410276 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_IS_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 320,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_IS_ASSOC',
  p_source=>'select 1'||chr(10)||
'  from t_osi_attachment'||chr(10)||
' where sid = :p5100_sel_attachment and obj = :p5100_obj;',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>98521323722200984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SHOW_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 325,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100412724608218170 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_TYPE',
  p_validation_sequence=> 1,
  p_validation => 'P5100_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Type must be specified.',
  p_validation_condition=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89975215668315971 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_LOCATION Not Null',
  p_validation_sequence=> 5,
  p_validation => 'P5100_LOCATION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Location must be specified.',
  p_validation_condition=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89970324808315956 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89974816169315970 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Soft copy not null',
  p_validation_sequence=> 10,
  p_validation => 'P5100_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P5100_SOURCE_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''CREATE'') AND :P5100_LOCATION IN (''DB'', ''FILE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89973723512315968 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 22-APR-2009 11:33');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89974609671315970 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Hard copy not null',
  p_validation_sequence=> 15,
  p_validation => 'P5100_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P5100_SOURCE_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''CREATE'', ''SAVE'') AND :P5100_LOCATION = ''OUTSIDE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89974306816315970 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89975031327315971 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_DESCRIPTION Not Null',
  p_validation_sequence=> 20,
  p_validation => 'P5100_DESCRIPTION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Description must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 89970517561315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 22-APR-2009 11:33');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8721015473382834 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Check max_num attach types',
  p_validation_sequence=> 30,
  p_validation => 'declare '||chr(10)||
''||chr(10)||
'       v_max_count varchar(10);'||chr(10)||
'       v_attach_count varchar(10);'||chr(10)||
'begin'||chr(10)||
'     if :P5100_TYPE is not null then'||chr(10)||
''||chr(10)||
'       select max_num into v_max_count'||chr(10)||
'             from t_osi_attachment_type where sid = :P5100_TYPE;'||chr(10)||
'     '||chr(10)||
'       if :P5100_SEL_ATTACHMENT IS NULL then'||chr(10)||
''||chr(10)||
'         select count(*) into v_attach_count'||chr(10)||
'           from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'          where a.obj = :P0_OBJ'||chr(10)||
'            and a.type = at.sid'||chr(10)||
'            and at.sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         select count(*) into v_attach_count'||chr(10)||
'           from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'          where a.obj = :P0_OBJ'||chr(10)||
'            and a.type = at.sid'||chr(10)||
'            and at.sid = :P5100_TYPE'||chr(10)||
'            and a.sid != :P5100_SEL_ATTACHMENT;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'       if(v_attach_count >= v_max_count) then'||chr(10)||
''||chr(10)||
'         return ''There can only be '' || v_max_count || '||chr(10)||
'                '' Attachment of this type in this object.'';'||chr(10)||
''||chr(10)||
'       else '||chr(10)||
''||chr(10)||
'        return null;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Attachment type already exists on this File. ',
  p_validation_condition=> ':REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT'''||chr(10)||
''||chr(10)||
''||chr(10)||
'declare '||chr(10)||
''||chr(10)||
'       v_max_count varchar(10);'||chr(10)||
'       v_attach_count varchar(10);'||chr(10)||
'begin'||chr(10)||
'     select max_num'||chr(10)||
'       into v_max_count'||chr(10)||
'     from t_osi_attachment_type'||chr(10)||
'      where sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'     select count(*)'||chr(10)||
'       into v_attach_count'||chr(10)||
'       from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'      where a.obj = :P0_OBJ'||chr(10)||
'       and a.type = at.sid'||chr(10)||
'       and at.sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'     if(v_attach_count >= v_max_count) then'||chr(10)||
''||chr(10)||
'       return ''There can only be '' || v_max_count || '' Attachment of this type in this object.'';'||chr(10)||
''||chr(10)||
'     else '||chr(10)||
''||chr(10)||
'      return null;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'end;');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8782524288390115 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Create/Save/Delete SCR',
  p_validation_sequence=> 40,
  p_validation => 'declare'||chr(10)||
''||chr(10)||
'   v_scr varchar2(20);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     select sid into v_scr'||chr(10)||
'       from t_osi_attachment_type'||chr(10)||
'        where usage=''REPORT'''||chr(10)||
'          and code=''CR'''||chr(10)||
'          and obj_type=:p0_obj_type_sid;'||chr(10)||
''||chr(10)||
'     if (:p5100_type = v_scr) then'||chr(10)||
''||chr(10)||
'       return ''You cannot Create, Edit, or Delete a Summary Complaint Report.'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return null;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Error',
  p_validation_condition=> ':REQUEST IN (''CREATE'',''SAVE'',''DELETE'') and'||chr(10)||
'osi_object.get_objtype_code(core_obj.get_objtype(:P0_OBJ)) like ''FILE.INV%''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> ':REQUEST IN (''SAVE'',''DELETE'') and'||chr(10)||
'osi_object.get_status(:P0_OBJ) not in (''New'', ''Awaiting Approval'') and'||chr(10)||
'select osi_object.get_objtype_code(core_obj.get_objtype(:P0_OBJ)) like ''FILE.INV%''');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11827424158571048 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 45,
  p_validation => 'P5100_DATE_MODIFIED',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P5100_DATE_MODIFIED IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89970730016315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  procedure l(p_log_text varchar2) is'||chr(10)||
'  begin'||chr(10)||
'     core_logger.log_it(''timtest'', p_log_text);'||chr(10)||
'  end l;'||chr(10)||
'begin'||chr(10)||
'  l('' '');'||chr(10)||
'  l(''obj:'' || :p5100_obj || '', '' || core_obj.get_tagline(:p5100_obj));'||chr(10)||
'  l(''sid:'' || :p5100_sel_attachment);'||chr(10)||
'  l(''text:'' || :p5100_description);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6690205082622300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'debug',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (:request in(''ADD'', ''P5100_LOCATION'')) then'||chr(10)||
'        :p5100_mode := ''ADD'';'||chr(10)||
'    else'||chr(10)||
'        :p5100_mode := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95132918713047790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set mode',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:T_OSI_ATTACHMENT:P5100_SEL_ATTACHMENT:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 95299420877142370 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Do T_OSI_ATTACHMENT',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CREATE,SAVE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P5100_SEL_ATTACHMENT',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_blob   blob          := null;'||chr(10)||
'    v_file   varchar2(400) := null;'||chr(10)||
'    v_mime   varchar2(255)  := null;'||chr(10)||
''||chr(10)||
'    procedure upload(p_source in varchar2) is'||chr(10)||
'    begin'||chr(10)||
'        select blob_content, filename, mime_type'||chr(10)||
'          into v_blob, v_file, v_mime'||chr(10)||
'          from wwv_flow_files'||chr(10)||
'         where name = p_source;'||chr(10)||
''||chr(10)||
'        update t_osi_attachment'||chr(10)||
'           set content = v_blob,'||chr(10)||
'           ';

p:=p||'    source = v_file,'||chr(10)||
'               mime_type = v_mime,'||chr(10)||
'               type = :p5100_type,'||chr(10)||
'               storage_loc_type = :p5100_location_value,'||chr(10)||
'               description = :p5100_description'||chr(10)||
'         where sid = :p5100_sel_attachment;'||chr(10)||
'    end;'||chr(10)||
'begin'||chr(10)||
'    if (:p5100_location_value <> ''OUTSIDE'') then'||chr(10)||
'        if (:request = ''CREATE'') then'||chr(10)||
'            upload(:p5100_source);'||chr(10)||
'        elsif(:request ';

p:=p||'= ''SAVE'') then'||chr(10)||
'            if (:p5100_source <> :p5100_source_display1) then'||chr(10)||
'                --A new attachment was given.'||chr(10)||
'                upload(:p5100_source_display1);'||chr(10)||
'            else'||chr(10)||
'                update t_osi_attachment'||chr(10)||
'                   set type = :p5100_type,'||chr(10)||
'                       storage_loc_type = :p5100_location_value,'||chr(10)||
'                       description = :p5100_description'||chr(10)||
'        ';

p:=p||'         where sid = :p5100_sel_attachment;'||chr(10)||
'            end if;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90170733611516101 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get the BLOB',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,SAVE',
  p_process_when_type=>'',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'   v_status_change_sid varchar2(20);'||chr(10)||
'   v_current_status varchar2(20);'||chr(10)||
'   v_type varchar(50);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     '||chr(10)||
'  if(:P0_OBJ_TYPE_CODE like ''FILE.INV%'' and :P5100_USAGE = ''REPORT'') then'||chr(10)||
''||chr(10)||
'       select at.sid'||chr(10)||
'         into v_type'||chr(10)||
'         from t_osi_attachment_type at'||chr(10)||
'        where at.usage = ''REPORT'''||chr(10)||
'         and at.code = ''ROIFP'''||chr(10)||
'         and at.obj_type = :P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'       v_current_s';

p:=p||'tatus := osi_object.get_status_code(:P0_OBJ);'||chr(10)||
''||chr(10)||
'   if (v_current_status = ''OP'' and :P5100_TYPE = v_type) then'||chr(10)||
''||chr(10)||
'      select sc.sid'||chr(10)||
'        into v_status_change_sid'||chr(10)||
'        from t_osi_status_change sc, t_osi_status s1, t_osi_status s2'||chr(10)||
'       where sc.from_status = s1.sid'||chr(10)||
'        and sc.to_status = s2.sid'||chr(10)||
'        and s1.code = ''OP'''||chr(10)||
'        and s2.code = ''IC'''||chr(10)||
'        and sc.obj_type = core_obj.lookup_';

p:=p||'objtype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'      osi_status.change_status(:P0_OBJ, v_status_change_sid);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8583804323504898 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 16,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'change_status_to_IC',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,SAVE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'Declare'||chr(10)||
''||chr(10)||
'  v_status_change_sid varchar2(20);'||chr(10)||
'  v_current_status varchar2(20);'||chr(10)||
'  v_type varchar2(20);'||chr(10)||
'  v_attach_count varchar2(10);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if (:P0_OBJ_TYPE_CODE like ''FILE.INV%'' and :P5100_USAGE = ''REPORT'') then'||chr(10)||
''||chr(10)||
'    select at.sid into v_type from t_osi_attachment_type at'||chr(10)||
'     where at.usage = ''REPORT'''||chr(10)||
'       and at.code = ''ROIFP'''||chr(10)||
'       and at.obj_type = :P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'    select count(*) ';

p:=p||'into v_attach_count from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'     where obj = :P0_OBJ '||chr(10)||
'       and a.type = at.sid'||chr(10)||
'       and at.code = ''ROIFP'';'||chr(10)||
' '||chr(10)||
'    v_current_status := osi_object.get_status_code(:P0_OBJ);'||chr(10)||
''||chr(10)||
'    ---if (v_current_status = ''IC'' and :P5100_TYPE = v_type and v_attach_count = 0) then    '||chr(10)||
'    if (v_current_status = ''IC'' and ((:P5100_TYPE = v_type and :request=''DELETE'') or (:P51';

p:=p||'00_TYPE != v_type and :request=''SAVE'')) and v_attach_count = 0) then    '||chr(10)||
''||chr(10)||
'      select sc.sid into v_status_change_sid from t_osi_status_change sc, t_osi_status s1, t_osi_status s2'||chr(10)||
'       where sc.from_status = s1.sid'||chr(10)||
'         and sc.to_status = s2.sid'||chr(10)||
'         and s1.code = ''IC'''||chr(10)||
'         and s2.code = ''IC'''||chr(10)||
'         and sc.transition = ''Reopen'''||chr(10)||
'         and sc.obj_type = core_obj.lookup_objtype(''F';

p:=p||'ILE.INV'');'||chr(10)||
''||chr(10)||
'      osi_status.change_status(:P0_OBJ, v_status_change_sid);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8593206971272143 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 17,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'change_status_back_OP',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'DELETE,SAVE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (   :request in(''ADD'', ''DELETE'', ''CANCEL'')'||chr(10)||
'        or :request like ''EDIT_%'') then'||chr(10)||
'        :p5100_type := null;'||chr(10)||
'        :p5100_source_label := null;'||chr(10)||
'        :p5100_description := null;'||chr(10)||
'        :p5100_date_modified := null;'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'        :p5100_location_value := null;'||chr(10)||
'        :p5100_location := null;'||chr(10)||
'        :p5100_date_modified := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:r';

p:=p||'equest in (''ADD'',''DELETE'')) then'||chr(10)||
'        :p5100_sel_attachment := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''P5100_LOCATION'') then'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 93949220719504334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'   v_Seq number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     :P5100_SEL_ATTACHMENT := SUBSTR(:REQUEST, 6);'||chr(10)||
''||chr(10)||
'     select seq into v_Seq from t_osi_report_roi_attach'||chr(10)||
'           where obj=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;'||chr(10)||
''||chr(10)||
'     :P5100_PRINT:=''Y'';'||chr(10)||
'     :P5100_PRINT_ORDER:=to_char(v_Seq);'||chr(10)||
''||chr(10)||
'exception when NO_DATA_FOUND then'||chr(10)||
''||chr(10)||
'         :P5100_PRINT:='''';'||chr(10)||
'         :P5100_PRINT_ORDER:=''0'';'||chr(10)||
'  '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89975928747315973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Attachment',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'     '||chr(10)||
'     v_Count Number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if (:P5100_PRINT IS NULL OR :P5100_PRINT=''N'' OR :P5100_PRINT='''') THEN ---:P5100_PRINT_OBJ is null or :P5100_PRINT_ATTACHMENT is null then'||chr(10)||
''||chr(10)||
'       delete from t_osi_report_roi_attach'||chr(10)||
'             where obj=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       select count(*) into v_Count from t_osi_report_roi_attach'||chr(10)||
'             where obj';

p:=p||'=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;'||chr(10)||
'     '||chr(10)||
'       if(v_Count=0) then'||chr(10)||
''||chr(10)||
'         insert into t_osi_report_roi_attach (obj,attachment,seq) values'||chr(10)||
'          (:P5100_OBJ, :P5100_SEL_ATTACHMENT, :P5100_PRINT_ORDER);  '||chr(10)||
''||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         update t_osi_report_roi_attach set seq=:P5100_PRINT_ORDER'||chr(10)||
'               where obj=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;  '||chr(10)||
'  '||chr(10)||
'       end if;'||chr(10)||
'';

p:=p||''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         null;'||chr(10)||
'     '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13431612507422697 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Save to T_OSI_REPORT_ROI_ATTACH',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''CREATE'',''SAVE'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    :p5100_obj1 := :p0_obj;'||chr(10)||
'    :p5100_obj  := :p0_obj;'||chr(10)||
'    :p5100_usage := :tab_params;'||chr(10)||
''||chr(10)||
'    select count(sid)'||chr(10)||
'      into :p5100_show_type'||chr(10)||
'      from t_osi_attachment_type'||chr(10)||
'     where obj_type = :p0_obj_type_sid'||chr(10)||
'       and usage = :p5100_usage and active = ''Y'';'||chr(10)||
''||chr(10)||
'    if (:p5100_assoc_attachments is null) then'||chr(10)||
'        :p5100_assoc_attachments := ''ME'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_sel_attachment';

p:=p||' is not null) then'||chr(10)||
'        select decode(at.description, ''NULL'', ''''),'||chr(10)||
'               osi_util.parse_size(dbms_lob.getlength(a.content)), a.create_by,'||chr(10)||
'               decode(a.obj, :P5100_OBJ, core_obj.get_parentinfo(a.obj), osi_object.get_open_link(a.obj,core_obj.get_parentinfo(a.obj)))'||chr(10)||
'          into :p5100_sel_type,'||chr(10)||
'               :p5100_sel_size, :p5100_sel_attached_by,'||chr(10)||
'               :p5100_obj';

p:=p||'_tag'||chr(10)||
'          from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'         where a.sid = :p5100_sel_attachment and a.type = at.sid(+);'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_usage = ''ATTACHMENT'') then'||chr(10)||
'        :p5100_usage_display := initcap(:p5100_usage);'||chr(10)||
'        :p5100_add_label := :btn_add || '' Attachment(s)'';'||chr(10)||
''||chr(10)||
'        if (instr(:p0_obj_type_code, ''FILE.'', 1, 1) > 0) then'||chr(10)||
'            :p5100_is_file := ''Y'';'||chr(10)||
'';

p:=p||'        else'||chr(10)||
'            :p5100_is_file := ''N'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_usage = ''REPORT'') then'||chr(10)||
'        :p5100_usage_display := ''Attached '' || initcap(:p5100_usage);'||chr(10)||
'        :p5100_add_label := :btn_add || '' Report(s)'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
'    when no_data_found then'||chr(10)||
'        return;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89975310618315971 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload Items',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_add_or   boolean := false;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'    :p5100_filters := null;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''ME'') > 0) then'||chr(10)||
'        v_add_or := true;'||chr(10)||
'        :p5100_filters := :p5100_filters'||chr(10)||
'                       || '' a.obj = '''''' || :p0_obj || '''''''';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''A_FILES'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_fi';

p:=p||'lters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p5100_filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in (select that_file from v_osi_assoc_fle_fle where this_file = '''''''||chr(10)||
'            || :p0_obj || '''''')'';'||chr(10)||
'        v_add_or := true;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''A_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_filters || '' or '';'||chr(10)||
'        ';

p:=p||'end if;'||chr(10)||
''||chr(10)||
'        :p5100_filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in(select activity_sid from v_osi_assoc_fle_act where file_sid = '''''''||chr(10)||
'            || :p0_obj || '''''')'';'||chr(10)||
'        v_add_or := true;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''I_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_filters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p5100_';

p:=p||'filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in(select activity_sid'||chr(10)||
'                  from v_osi_assoc_fle_act'||chr(10)||
'                 where file_sid in(select that_file'||chr(10)||
'                                     from v_osi_assoc_fle_fle'||chr(10)||
'                                    where this_file = '''''''||chr(10)||
'            || :p0_obj || ''''''))'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'   if :p5100_filters is not null then'||chr(10)||
'       :p5100_fi';

p:=p||'lters := '' and ('' || :p5100_filters || '')'';'||chr(10)||
'   end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95988135397639971 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Build WHERE clause',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'F|#OWNER#:T_OSI_ATTACHMENT:P5100_SEL_ATTACHMENT:SID';

wwv_flow_api.create_page_process(
  p_id     => 91758918521863790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch T_OSI_ATTACHMENT',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P5100_SEL_ATTACHMENT IS NOT NULL AND :REQUEST <> ''P5100_LOCATION''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P5100_SEL_ATTACHMENT',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (   osi_auth.check_for_priv(''TAB_ATTACHMENTS'', :p0_obj_type_sid) = ''Y'''||chr(10)||
'        or osi_auth.check_for_priv(''TAB_ALL'', :p0_obj_type_sid) = ''Y'') then'||chr(10)||
'        :tab_enabled := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        :tab_enabled := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8106112177154029 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetTabDisabler',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (:request = ''CREATE'') then        '||chr(10)||
'        :p5100_location_value := :p5100_location;'||chr(10)||
'    '||chr(10)||
'        if (:p5100_location_value in(''DB'', ''FILE'')) then'||chr(10)||
'            :p5100_source := :p5100_source_display1;'||chr(10)||
'        else'||chr(10)||
'            :p5100_source := :p5100_source_display2;'||chr(10)||
'        end if;'||chr(10)||
'        '||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''SAVE'' and :p5100_location_value = ''OUTSIDE'') then'||chr(10)||
'        :p510';

p:=p||'0_source := :p5100_source_display2;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''P5100_LOCATION'') then'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'        :p5100_location_value := :p5100_location;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89976131007315973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set source',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 5100
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done



