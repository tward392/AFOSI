set define off;

CREATE OR REPLACE package body osi_checklist is
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
 *  Checklist Support/Enhancement - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   Name:     OSI_CHECKLIST
   Purpose:  Provides checklist management functions.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------------
    01-MAY-2009  Richard Dibble  Created this package
    04-JUN-2009  Richard Dibble  Added participants_confirmed
    12-JUN-2009  Richard Dibble  Added get_checklist_output
    15-JUN-2009  Richard Dibble  Added object_is_associated_to_a_file, object_has_lead_note,
                                  interview_has_dd2701
    16-JUN-2009  Richard Dibble  Added get_soft_checked_items
    17-JUN-2009  Richard Dibble  Added object_has_lead_agent, soft_checks_exist, object_has_at_least_one_obj
    17-JUN-2009  Tim McGuffin    Modified object_has_lead_note to reference non-core notes.
    22-JUN-2009  Richard Dibble  Modified object_has_lead_agent per 06/18/2009 PMO Meeting,
                                  added gen1_objectives_not_null
    23-JUN-2009  Richard Dibble  Added user_is_lead_agent, active_assignments_have_wrkhrs
    20-Jul-2009  Richard Dibble  Added activity_has_subject, modified soft_checks_exist to handle
                                  two sided object filtering (will be phased out though)
    23-Jul-2009  T. Whitehead    Added participant_has_legal_name.
    24-Aug-2009  Richard Dibble  Modified get_checklist_auto_output and checklist_complete to fix string size bugs
    10-Sep-2009  T. Whitehead    Modified participants_confirmed and participant_has_legal_name to work
                                  with participant versions.
    15-Sep-2009  T. Whitehead    Added participant_cage_code, participant_relationships.
    28-Oct-2009  T. Whitehead    Added participant_has_ssn, participant_has_association.
    29-Oct-2009  T. Whitehead    Renamed participant functions.
    04-Nov-2009  Richard Dibble  Modified Checklist_Complete to better handle user checkable items
    04-Nov-2009  T. Whitehead    Added clist_is_complete and clist_has_comments.
    17-Nov-2009  T. Whitehead    Added source_is_confirmed, source_required_notes
                                 and note_type_exists for private use.
    16-Dec-2009  J. Faris        Added surv_intcond_null, surv_activation_date, surv_approval_data, and surv_participant.
    29-JAN-2010  Tom Leighty     Added dibrs_valid_st_ctr procedure
                                  Added dibrs_injury_self procedure
                                  Added dibrs_gun_category procedure
    01-FEB-2010  Tom Leighty     Added dibrs_vic_type procedure
                                  Added place holder procedures to facilitate testing.  This will allow
                                  the application to function without erroring out in order to test.
                                  As development progresses the place holders will be replaced with
                                  verifing routines.
    03-FEB-2010  Tom Leighty     Added dibrs_valid_age.
    08-FEB-2010  Tom Leighty     Added dibrs_vicrel_ofdr
    09-FEB-2010  Tom Leighty     Added dibrs_criminal_activity
                                  Added dibrs_property_require
    11-FEB-2010  Tom Leighty     Added dibrs_vicage_pres
                                  Added dibrs_comb_valid
    12-FEB-2020  Tom Leighty     Removed the place holder procedure dibrs_clearance_reason.  Appears
                                  the business logic was removed from i2ms but not the meta data.
                                  Meta data was removed from the Web version relieving the need for
                                  the business logic in the checklist package.
    16-FEB-2010  Tom Leighty     Added dibrs_ofdr_info
    17-FEB-2010  Richard Dibble  Added aapp_1288
                                  Added aapp_imt_686
                                  Added aapp_doa_bq
                                  Added aapp_doa_coe
                                  Added aapp_doa_cr
                                  Added aapp_doa_dd2760
                                  Added aapp_doa_dl
                                  Added aapp_doa_doa
                                  Added aapp_doa_epropr
                                  Added aapp_doa_far
                                  Added aapp_doa_fq
                                  Added aapp_doa_pp
                                  Added aapp_doa_ri
                                  Added aapp_doa_rrrip
                                  Added aapp_doa_shipley
                                  Added aapp_doa_soufa
                                  Added attachment_exists
                                  Added aapp_subject_is_military
                                  Added aapp_subject_is_enlisted
    17-FEB-2010  Tom Leighty     Added dibrs_diff_sex
                                  Added dibrs_max_value
    18-FEB 2010  Richard Dibble  Added aapp_doa_ws
                                  Added aapp_unit_151det
                                  Added aapp_unit_bps
                                  Added aapp_unit_dcii
                                  Added aapp_unit_dlab
                                  Added aapp_unit_lor
                                  Added aapp_unit_picture
                                  Added aapp_unit_sf86hc
                                  Added aapp_region_151reg
                                  Added aapp_region_roi
                                  Added aapp_objectives_met
                                  Added aapp_tracknum
                                  Added aapp_act_closed
    18-FEB-2010  Tom Leighty     Added dibrs_vicsex_pres
                                  Added dibrs_vicindiv_age
                                  Added dibrs_ssn_length
                                  Added dibrs_rmv_drug_info
                                  Added dibrs_recover_date
    19-FEB-2010  JaNelle Horne   Added inv_dispo_spec, inv_drug_indentified, inv_have_referral,
                                  inv_have_victim, inv_dispo_incident, inv_dispo_case, inv_all_inc_covered,
                                  inv_all_off_covered, inv_have_prim_offense, inv_have_subject,
                                  inv_property_item, per_reservist_set, inv_arfc_not_null,
                                  participante_role_exists
    22-FEB-2010  JaNelle Horne   Added inv_all_vic_covered, inv_have_incident, inv_all_sub_covered,
                                  inv_roi, inv_complaint_form
    23-FEB-2010  Tom Leighty     Added dibrs_specification
                                  Added dibrs_max_offage
                                  Added assocact_closed
                                  Added inv_mission_area
                                  Added evidence_disp
    24-FEB-2010  Tom Leighty     Added dibrs_vicrel_warn
                                  Added dibrs_society
    25-FEB-2010  Tom Leighty     Added dibrs_ir_occ_date
                                  Added dibrs_w_f_used
                                  Added inv_approve_134z2
    01-MAR-2010  Richard Dibble  Modified get_checklist_auto_output to order properly
                                  Added aapp_a_have_dates
    03-MAR-2010  Jason Faris     Added fp_card_attached
    03-MAR-2010  JaNelle Horne   Added dibrs_complete_ah_offs, dibrs_if_ucmj_date, inv_dispo_off_result,
                                  dibrs_proper_aahc_codes, dibrs_valid_aahc_codes, dibrs_aahc_require,
                                  dibrs_premises_entry
    09-MAR-2010 JaNelle Horne    Added dibrs_drg_equip, dibrs_nodupdrugcode, dibrs_property_value,
                                 dibrs_spec_jurisdiction, have_assocact, inv_off_on_usi,
                                 dibrs_stolen_recv_vehic, dibrs_drg_measure_qnty, dibrs_prop_suspdrg,
                                     dibrs_prop_loss, dibrs_logical_property, dibrs_injury_type
    12-MAR-2010  Tom Leighty    Added current_pv_links
                                 Added deers_update_on_indivs
                                 Added curtailed_content_note
                                 Added add_name_to_message
    12-MAR-2010 JaNelle Horne   Corrected issue with inv_complaint_form and inv_roi
    18-MAR-2010 Tom Leighty     Corrected query in dibrs_w_f_used procedure.  Converted it to use local
                                 schema tables instead fo the dibrs schema.
    23-MAR-2010 Tom Leighty     Correct the p_complete null settings in the procedures: assocact_closed,
                                 dibrs_vicsex_pres, dibrs_society, dibrs_rmv_drug_info, dibrs_max_value
                                 dibrs_vicrel_warn, and curtailed_content_note.
    24-MAR-2010 Tom Leighty     Added verification of case file in the procedures: inv_all_inc_covered,
                                 inv_all_off_covered, inv_all_sub_covered, and inv_all_vic_covered.
    24-MAR-2010 Tom Leighty     Removed quotes from around p_complete response of '1' to result in 1
                                 returned from the procedure dibrs_drg_equip.
    24-MAR-2010 JaNelle Horne   Fixed issue with dibrs_complete_ah_offs and dibrs_if_ucmj_date.  Procedures
                                were duplicated in the file.
    12-MAY-2010 Jason Faris     Added verify_assoc_poly_exam_act, verify_poly_csp, verify_poly_exam_reason,
                                verify_poly_exculpatory, verify_poly_have_examinee, verify_poly_return_reason.
    12-MAY-2010 Tom Leighty     Updated the link logic in current_pv_links to follow the get_tag_link method.
    19-May-2010 Tim McGuffin    Fixed image prefix bugs and inv_approve_134z2
    06-Jun-2010 JaNelle Horne   Updated inv_complaint_form and inv_roi so that obj_type is checked.
    23-Jun-2010 JaNelle Horne   Updated dibrs_vic_type and dibrs_society
    16-Jul-2010 JaNelle Horne   Corrected issue with dibrs_society and dibrs_specification
    02-Aug-2010 JaNelle Horne   Corrected issues with dibrs_logical_property (CHG0003178), dibrs_comb_vaild (CHG0003234), dibrs_property_require,
                                inv_dispo_spec, assocact_closed, dibrs_gun_category, dibrs_society and dibrs_self_injury.
    08-Aug-2010 JaNelle Horne   Bug found in dibrs_comb_valid was not fixed during 02-Aug-2010 update, it is now fixed.
    31-Aug-2010 T. Whitehead    CHG0003326 Added CHECK_ACTIVITY_DATE.
    03-Sep-2010 Richard Dibble  Added aapp_file_is_agent, aapp_file_is_support
                                Modified aapp_doa_doa, aapp_unit_bps to check for agent only
    16-Sep-2010 Tim Ward        CHG0003209 - Offense Results must have Charged Result if a Result of Acquitted or Convicted.
                                 Added VERIFY_OFFENSE_RESULTS.
    16-Sep-2010 Tim Ward        WCHG0000365 - Comparing CODE to SID instead of CODE to CODE.
                                 Changed dibrs_vicrel_ofdr.
    16-Sep-2010 Tim Ward        WCHG0000369 - Select returning too many rows where there is more than one name.
                                 Changed dibrs_vicrel_ofdr.
    27-Sep-2010 Tim Ward        Invalid Number Error when Low Age Estimate is 'NN', 'NB', or 'BB'.
                                 Changed dibrs_valid_age.
    27-Sep-2010 Tim Ward        WCHG0000365 - Comparing CODE to SID instead of CODE to CODE.
                                 Changed dibrs_ofdr_info.
                                 Changed dibrs_diff_sex.
                                 Changed dibrs_vicsex_pres.
                                 Changed dibrs_w_f_used.
                                 Changed dibrs_ssn_length.
                                 Changed dibrs_recover_date.
                                 Changed evidence_disp.
                                 Changed dibrs_injury_type.
    28-Sep-2010 Richard Dibble  Fixed minor open link issue with aapp_act_closed()
    29-Sep-2010 Jason Faris     Integrated Tim Ward's 27-Sep-2010 changes into Richmond Dev instance
    01-Oct-2010 JaNelle Horne   CHG0000365 - Changed dibrs_ofdr_info, dibrs_vicrel_warn, dibrs_w_f_used,
                                evidence_disp, inv_dispo_incident, dibrs_ir_occ_date, dibrs_prop_suspdrg, dibrs_recover_date
    01-Oct-2010 JaNelle Horne   Updated assocact_closed.  Put in carriage return between activity titles.
    05-Oct-2010 Richard Dibble  Modified get_checklist_auto_output() to handle details
    06-Oct-2010 Richard Dibble  Added get_checklist_self_output()
    08-Oct-2010 Richard Dibble  Added details_exist_for_this_cl()
                                 Modified get_checklist_auto_output() to use 2 out parameters instead of a return value
    03-Nov-2010 Richard Dibble  Added source_import_is_satisfied
    10-Nov-2010 Richard Dibble  Added aapp_fm82_carb,  aapp_email_msg
    11-Nov-2010 Richard Dibble  Added p_filter to get_checklist_auto_output
    06-Jan-2011 Jason Faris     Corrected SSN check in partic_i_has_ssn.
    10-Feb-2011 Jason Faris     Added verify_legacy_relationships
    11-May-2011 Tim Ward        CR#3842 Fixing "value error: character string buffer too small" error during Agent Application
                                 checklist.  Changed aapp_act_closed and get_checklist_auto_output to use CLOB instead of varchar2(?????).
    16-May-2011 Tim Ward        CR#3849 Unit Selection not checking to see if it is the current assignment, so it returns too many rows.
                                 Also, function was not even checking the privilege against the Unit.....
                                 Changed inv_approve_134z2.
    15-Jun-2011 Tim Ward        CR#3849 Changed inv_approve_134z2, Checklist would never pass, argument was being passed wrong.
                                 Unit Sid was being passed as Personnel Sid so check_for_priv would always fail.
    21-Jun-2011 Tim Ward        CR#3894 Fixing "value error: character string buffer too small" error during Case Closure
                                 Checklist.  Changed aapp_act_closed, assocact_closed, and checklist_complete to use CLOB instead of varchar2(?????).
                                 Also changed them to use IDs instead of Titles and getObjURL instead of get_tagline (all to shorten the strings).
    25-Oct-2011 Tim Ward        CR#3922 - Add the Goto Tab feature like Legacy I2MS to take the user to the tab the failed checklist item is on.
                                 Changed in get_checklist_auto_output.
    27-Oct-2011 Tim Ward        CR#3589 - Only HQ can approve 106-A- Cases.
                                 Added inv_approve_106a.
    07-Nov-2011 Tim Ward        CR#3918 - Check for Valid Offense Combinations when adding specs.
                                 Changed dibrs_comb_valid.
                                 Added check_offense_combos.
                                 Added get_offense_count.
    02-Feb-2012 Tim Ward        CR#3990 - Many AAPP Checklist changes.
    10-Feb-2012 Tim Ward        CR#3996 - Problem in dibrs_property_require .
    17-Apr-2012 Tim Ward        CR#3647 - Added Computer Intrusion AFCERT Incident Number Check.
                                 Added afcert_inc_num_req.
    27-Jun-2012 Wayne Combs     CR#4080 - Modified dibrs_vicage_pres to correct a missing join to the t_osi_inv_incident table 
                                          in the cursor for loop which was causing incorrect results.
    12-Jul-2012 Tim Ward        CR#3421 - New Contract Disclosure Special Interest Area Checklist.
                                 Added inv_contract_disclosure.
    02-Oct-2012 Tim Ward        CR#4024 - Surveillance Activity, Allow Expansions or Extensions in the Approval Tab.
                                 Changed surv_approval_data.
                                 
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_checklist';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function note_type_exists(p_obj in varchar2, p_code in varchar2, p_description out varchar2)
        return varchar2 is
    begin
        select description
          into p_description
          from t_osi_note_type
         where obj_type = core_obj.get_objtype(p_obj) and code = p_code;

        for x in (select n.sid
                    from t_osi_note n, t_osi_note_type nt
                   where n.note_type = nt.sid and n.obj = p_obj and nt.code = p_code)
        loop
            return 'Y';
        end loop;

        return null;
    exception
        when others then
            log_error('note_type_exists: ' || sqlerrm);
            raise;
    end note_type_exists;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    function add_name_to_message(p_msg in varchar2, p_name in varchar2)
        return clob is
        l_rtn   clob;
        l_pos   number;
    begin
        l_rtn := p_msg;
        l_pos := instr(l_rtn, p_name);

        if    l_pos is null
           or l_pos < 1 then
            if l_rtn is null then
                l_rtn := p_name;
            else
                l_rtn := l_rtn || '<br>' || p_name;
            end if;
        end if;

        return l_rtn;
    exception
        when others then
            log_error('add_name_to_message: ' || sqlerrm);
            raise;
    end add_name_to_message;

    procedure attachment_exists(
        p_obj        in       varchar2,
        p_type       in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2,
        p_location   in       varchar2) is
        v_cnt        number;
        v_location   varchar2(10);
    begin
        if (   v_location is null
            or v_location = '') then
            v_location := '%';
        else
            v_location := p_location;
        end if;

        select count(*)
          into v_cnt
          from t_osi_attachment
         where obj = p_obj and type like p_type and storage_loc_type like v_location;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No ' || osi_attachment.get_attachment_type_desc(p_type) || ' found';
        end if;
    exception
        when others then
            log_error('attachment_exists: ' || sqlerrm);
            raise;
    end attachment_exists;

    procedure participant_role_exists(
        p_parent     in       varchar2,
        p_role       in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_partic_involvement pi, t_osi_partic_role_type prt
         where pi.involvement_role = prt.sid and pi.obj = p_parent and prt.role = p_role;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No ' || p_role || ' identified';
        end if;
    exception
        when others then
            log_error('participant_role_exists: ' || sqlerrm);
            raise;
    end participant_role_exists;

    /* Determines is a checklist is complete for a given lifecycle change */
    function checklist_complete(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2 is
        v_return     varchar2(10)    := 'Y';
        v_complete   varchar2(200);
        v_msg        clob;
        v_count      number;
    begin
        --Check for function verifiable items
        for k in (select ocit.sid, ocit.verify_proc
                    from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
                   where ocitm.checklist_item_type_sid = ocit.sid
                     and ocitm.status_change_sid = p_status_change_sid
                     and ocitm.completion_required = 1
                     and (   ocit.obj_type is null
                          or ocit.obj_type = core_obj.get_objtype(p_obj))
                     and ocit.verify_proc is not null)
        loop
            execute immediate 'BEGIN ' || k.verify_proc || '(''' || p_obj || ''', :1 , :2); END;'
                        using out v_complete, out v_msg;

            if (v_complete = 0) then
                v_count := 0;

                --Verify Proc return false, so now lets see if there is a user checkable entry for this item
                for l in (select sid
                            from t_osi_checklist_item
                           where checklist_item_type_sid = k.sid and obj = p_obj)
                loop
                    v_count := v_count + 1;
                end loop;

                if (v_count <= 0) then
                    return 'N';
                end if;
            end if;
        end loop;

        --Check for user checkable (only) items (no Verify_Proc only, all Verify_Proc-user-checkables have already been checked above)
        for k in (select ocit.sid
                    from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
                   where ocitm.checklist_item_type_sid = ocit.sid
                     and ocitm.status_change_sid = p_status_change_sid
                     and ocitm.completion_required = 1
                     and (   ocit.obj_type is null
                          or ocit.obj_type = core_obj.get_objtype(p_obj))
                     and ocit.verify_proc is null
                     and ocit.sid not in(
                                       select checklist_item_type_sid
                                         from t_osi_checklist_item
                                        where obj = p_obj
                                              and status_change_sid = p_status_change_sid))
        loop
            --if any exist, we just return
            return 'N';
        end loop;

        return v_return;
    exception
        when others then
            log_error('osi_checklist.checklist_complete: ' || sqlerrm);
            raise;
    end checklist_complete;

    /* Used to verify that an object is associated to a file (most likely only used for Activities) */
    procedure object_is_associated_to_a_file(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cnt1   number;
        v_cnt2   number;
    begin
        --Check the Activity/File table
        select count(sid)
          into v_cnt1
          from t_osi_assoc_fle_act
         where file_sid = p_obj
            or activity_sid = p_obj;

        --Check the File/File table
        select count(sid)
          into v_cnt2
          from t_osi_assoc_fle_fle
         where file_a = p_obj
            or file_b = p_obj;

        if ((v_cnt1 + v_cnt2) > 0) then
            --Object is associated to a file.
            p_complete := 1;
            p_msg := 'Activity is associated to a File.';
        else
            --Object is NOT associated to a file
            p_complete := 0;
            p_msg := 'Activity is NOT associated to a File.';
        end if;
    exception
        when others then
            log_error(sqlerrm);
            raise;
    end object_is_associated_to_a_file;

    /* Used to verify that an objects has a lead note */
    procedure object_has_lead_note(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(n.sid)
          into v_cnt
          from t_osi_note n, t_osi_note_type nt
         where n.note_type = nt.sid and n.obj = p_obj and nt.code = 'LEAD';

        if (v_cnt > 0) then
            --Lead note exists
            p_complete := 1;
            p_msg := 'Lead Note Exists.';
        else
            --Lead note does not exist
            p_complete := 0;
            p_msg := 'No Lead Note found';
        end if;
    exception
        when others then
            log_error(sqlerrm);
            raise;
    end object_has_lead_note;

    /* Used to verify that an interview activity has a DD2701 entry */
    procedure interview_has_dd2701(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(sid)
          into v_cnt
          from t_osi_a_interview
         where sid = p_obj and dd2701 is not null;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := 'Form 2701 entry completed.';
        else
            p_complete := 0;
            p_msg := 'Missing Form 2701 Entry';
        end if;
    exception
        when others then
            log_error(sqlerrm);
            raise;
    end interview_has_dd2701;

    /* Used to verify that an object has a lead agent */
    procedure object_has_lead_agent(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_assignment oa, t_osi_assignment_role_type oart
         where oart.sid = oa.assign_role
           and oa.obj = p_obj
           and (   oa.end_date is null
                or oa.end_date > sysdate)
           and oart.description in('Lead Agent', 'Examiner');

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := 'Lead Agent Found';
        else
            p_complete := 0;
            p_msg := 'No Lead Agent';
        end if;
    exception
        when others then
            log_error(sqlerrm);
            raise;
    end object_has_lead_agent;

    procedure object_has_at_least_one_obj(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cnt   number;
    begin
        select count(sid)
          into v_cnt
          from t_osi_f_gen1_objective
         where file_sid = p_obj;

        if (v_cnt = 0) then
            p_complete := 0;
            p_msg := 'Must Specify at least one Objective.';
        else
            p_complete := 1;
            p_msg := 'At least one objective exists';
        end if;
    exception
        when others then
            log_error(sqlerrm);
            raise;
    end object_has_at_least_one_obj;

    /* Used to verify that all objectives have some text in them */
    procedure gen1_objectives_not_null(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        --check for record in T_GENERIC1_FILE without corresponding record in T_GENERIC1_OBJECTIVE
        select count(*)
          into v_cnt
          from t_osi_f_gen1_file
         where sid = p_obj and sid in(select file_sid
                                        from t_osi_f_gen1_objective);

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No objectives for this file';
            return;                                                                      -- get out
        end if;

        select count(*)
          into v_cnt
          from t_osi_f_gen1_objective
         where file_sid = p_obj and objective is null;

        if v_cnt = 0 then
            p_complete := 1;
            p_msg := 'No null objectives found.';
        else
            p_complete := 0;
            p_msg := 'At least one objective is null';
        end if;
    exception
        when others then
            log_error('gen1_objectives_not_null: ' || sqlerrm);
            raise;
    end gen1_objectives_not_null;

    /* Used to determine if any details are available for a particular Checklist */
    function details_exist_for_this_cl(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2 is
    begin
        --Loop through mapped checklist items
        for k in (select   ocit.details
                      from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
                     where ocitm.checklist_item_type_sid = ocit.sid
                       and ocitm.status_change_sid = p_status_change_sid
                       and (   ocit.obj_type is null
                            or ocit.obj_type = core_obj.get_objtype(p_obj))
                       and nvl(ocitm.user_editable, 0) <> 1
                       and verify_proc is not null
                  order by ocit.title)
        loop
            if (k.details is not null) then
                return 'Y';
            end if;
        end loop;

        for k in (select ocit.title, ocit.description, ocit.sid, ocit.details
                    from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
                   where ocitm.checklist_item_type_sid = ocit.sid
                     and ocitm.status_change_sid = p_status_change_sid
                     and (   ocit.obj_type is null
                          or ocit.obj_type = core_obj.get_objtype(p_obj))
                     and ocitm.user_editable = 1)
        loop
            if (k.details is not null) then
                return 'Y';
            end if;
        end loop;

        return 'N';
    exception
        when others then
            log_error('OSI_CHECKLIST.details_exist_for_this_cl: ' || sqlerrm);
            raise;
    end details_exist_for_this_cl;

    /* Used to get the output for the checklist widget */
    procedure get_checklist_auto_output(
        p_obj                 in       varchar2,
        p_status_change_sid   in       varchar2,
        p_output_p_1          out      varchar2,
        p_output_p_2          out      varchar2,
        p_output_f_1          out      varchar2,
        p_output_f_2          out      varchar2,
        p_output_d_1          out      varchar2,
        p_output_d_2          out      varchar2,
        p_show_details        in       varchar2 := 'N',
        p_filter              in       varchar2) is
        v_output                 clob;
        v_output_pass            clob;
        v_output_fail            clob;
        v_output_dna             clob;
        v_pass                   varchar2(200)
                              := '<img src="' || v( 'IMAGE_PREFIX')
                                 || '/themes/OSI/success_w.gif"/>';
        v_fail                   varchar2(200)
                                   := '<img src="' || v( 'IMAGE_PREFIX')
                                      || '/themes/OSI/fail.gif"/>';
        v_dna                    varchar2(200)
                              := '<img src="' || v( 'IMAGE_PREFIX')
                                 || '/themes/OSI/success_y.gif"/>';
        v_complete               varchar2(200);
        v_msg                    clob;
        v_crlf                   varchar2(4)     := '<br>';
        v_opt                    varchar2(20);
        v_max_output_size        number          := 20000;
        v_max_size_reached_f_1   boolean         := false;
        v_max_size_reached_p_1   boolean         := false;
        v_max_size_reached_d_1   boolean         := false;
        v_show_pass              boolean         := false;
        v_show_dna               boolean         := false;
    begin
        --Get filter parameters
        if (instr(p_filter, 'PASS') > 0) then
            v_show_pass := true;
        end if;

        if (instr(p_filter, 'DNA') > 0) then
            v_show_dna := true;
        end if;

        --Clear Buffers
        p_output_p_1 := null;
        p_output_p_2 := null;
        p_output_f_1 := null;
        p_output_f_2 := null;
        p_output_d_1 := null;
        p_output_d_2 := null;

        --Loop through mapped checklist items
        for k in (select   ocit.verify_proc, ocit.title, ocitm.completion_required, ocit.details, ocit.containing_tab
                      from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
                     where ocitm.checklist_item_type_sid = ocit.sid
                       and ocitm.status_change_sid = p_status_change_sid
                       and (   ocit.obj_type is null
                            or ocit.obj_type = core_obj.get_objtype(p_obj))
                       and nvl(ocitm.user_editable, 0) <> 1
                       and verify_proc is not null
                  order by ocit.title)
        loop
            --Execute each checklist procedure (need to put a cap number on this at some point)
            execute immediate 'BEGIN ' || k.verify_proc || '(''' || p_obj || ''', :1 , :2); END;'
                        using out v_complete, out v_msg;

            --Set Optional Flags
            if (k.completion_required = 1) then
                v_opt := '';
            else
                v_opt := ' (Optional) ';
            end if;

            if (v_complete = 1 and v_show_pass = true) then
                --Pass
                v_output_pass := v_output_pass || '<b>' || k.title || v_opt || '</b>' || v_crlf || v_pass || v_msg || v_crlf;

                if (p_show_details = 'Y' and k.details is not null) then
                    v_output_pass :=
                        v_output_pass
                        || '<i>Details from users guide:</i><br><Table width=100%><tr><td>'
                        || replace(replace(k.details, ',', ' -'), chr(13), '<br>')
                        || '</td></tr></Table>' || v_crlf;
                else
                    v_output_pass := v_output_pass || v_crlf;
                end if;
            elsif(v_complete = 0) then
                --Fail
                if k.containing_tab is null then

                  v_output_fail := v_output_fail || '<b>' || k.title || v_opt || '</b>' || v_crlf || v_fail || v_msg || v_crlf;

                else

                  v_output_fail := v_output_fail || '<b><a href="javascript:window.parent.goToTab(''' || k.containing_tab || ''',''' || p_obj || ''');">' || k.title || v_opt || '</a></b>' || v_crlf || v_fail || v_msg || v_crlf;

                end if;
                
                if (p_show_details = 'Y' and k.details is not null) then
                    v_output_fail :=
                        v_output_fail
                        || '<i>Details from users guide:</i><br><Table width=100%><tr><td>'
                        || replace(replace(k.details, ',', ' -'), chr(13), '<br>')
                        || '</td></tr></Table>' || v_crlf;
                else
                    v_output_fail := v_output_fail || v_crlf;
                end if;
            elsif(v_complete is null and v_show_dna = true) then
                --Does Not Apply
                v_output_dna :=
                    v_output_dna || '<b>' || k.title || v_opt || '</b>' || v_crlf || v_dna || v_msg
                    || v_crlf;

                if (p_show_details = 'Y' and k.details is not null) then
                    v_output_dna :=
                        v_output_dna
                        || '<i>Details from users guide:</i><br><Table width=100%><tr><td>'
                        || replace(replace(k.details, ',', ' -'), chr(13), '<br>')
                        || '</td></tr></Table>' || v_crlf;
                else
                    v_output_dna := v_output_dna || v_crlf;
                end if;
            end if;

            --Pass Buffer
            if (v_max_size_reached_p_1 = false) then
                if (length(v_output_pass) > v_max_output_size) then
                    --Max size has been reached, so need to spill over into 2nd output buffer.
                    p_output_p_1 := v_output_pass;
                    --Mark as max reached
                    v_max_size_reached_p_1 := true;
                    --Clear buffers
                    v_output_pass := null;
                end if;
            end if;

            --Fail Buffer
            if (v_max_size_reached_f_1 = false) then
                if (length(v_output_fail) > v_max_output_size) then
                    --Max size has been reached, so need to spill over into 2nd output buffer.
                    p_output_f_1 := v_output_fail;
                    --Mark as max reached
                    v_max_size_reached_f_1 := true;
                    --Clear buffers
                    v_output_fail := null;
                end if;
            end if;

            --DNA Buffer
            if (v_max_size_reached_d_1 = false) then
                if (length(v_output_dna) > v_max_output_size) then
                    --Max size has been reached, so need to spill over into 2nd output buffer.
                    p_output_d_1 := v_output_dna;
                    --Mark as max reached
                    v_max_size_reached_d_1 := true;
                    --Clear buffers
                    v_output_dna := null;
                end if;
            end if;
/*
            if (v_max_size_reached_1 = false) then
                if (length(v_output_fail || v_output_pass || v_output_dna) > v_max_output_size) then
                    --Max size has been reached, so need to spill over into 2nd output buffer.
                    p_output_1 := v_output_fail || v_output_pass || v_output_dna;
                    --Mark as max reached
                    v_max_size_reached_1 := true;
                    --Clear buffers
                    v_output_fail := null;
                    v_output_pass := null;
                    v_output_dna := null;
                end if;
            end if;
*/
        end loop;

        --Pass Buffer
        if (v_max_size_reached_p_1 = true) then
            --We reached the max size in the first buffer so now need to fill the 2nd
            p_output_p_2 := v_output_pass;
        else
            --No max reached so just return the first buffer.
            p_output_p_1 := v_output_pass;
        end if;

        --Fail Buffer
        if (v_max_size_reached_f_1 = true) then
            --We reached the max size in the first buffer so now need to fill the 2nd
            p_output_f_2 := v_output_fail;
        else
            --No max reached so just return the first buffer.
            p_output_f_1 := v_output_fail;
        end if;

        --DNA Buffer
        if (v_max_size_reached_d_1 = true) then
            --We reached the max size in the first buffer so now need to fill the 2nd
            p_output_d_2 := v_output_dna;
        else
            --No max reached so just return the first buffer.
            p_output_d_1 := v_output_dna;
        end if;
/*
        if (v_max_size_reached_1 = true) then
            --We reached the max size in the first buffer so now need to fill the 2nd
            p_output_2 := v_output_fail || v_output_pass || v_output_dna;
        else
            --No max reached so just return the first buffer.
            p_output_1 := v_output_fail || v_output_pass || v_output_dna;
        end if;
*/  --Combine everything
    --v_output := v_output || v_output_fail || v_output_pass || v_output_dna;
    --return v_output;
    exception
        when others then
            log_error('OSI_CHECKLIST.get_checklist_auto_output:' || sqlerrm);
            raise;
    end get_checklist_auto_output;

    /* Used to get the output for the checklist widget */
    function get_checklist_self_output(
        p_obj                 in   varchar2,
        p_status_change_sid   in   varchar2,
        p_show_details        in   varchar2 := 'N')
        return varchar2 is
        v_return   varchar2(32767);
    begin
        for k in (select ocit.title, ocit.description, ocit.sid, ocit.details
                    from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
                   where ocitm.checklist_item_type_sid = ocit.sid
                     and ocitm.status_change_sid = p_status_change_sid
                     and (   ocit.obj_type is null
                          or ocit.obj_type = core_obj.get_objtype(p_obj))
                     and ocitm.user_editable = 1)
        loop
            if (p_show_details = 'Y' and k.details is not null) then
                v_return :=
                    v_return || '<b>' || replace(k.title, ',', ' -') || '</b><br>'
                    || replace(k.description, ',', ' -')
                    || '<br><i>Details from users guide:</i><br><Table width=100%><tr><td>'
                    || replace(replace(k.details, ',', ' -'), chr(13), '<br>')
                    || '</td></tr></Table>;' || k.sid || ',';
            else
                v_return :=
                    v_return || '<b>' || replace(k.title, ',', ' -') || '</b><br>'
                    || replace(k.description, ',', ' -') || '<br><br>;' || k.sid || ',';
            end if;
        end loop;

        v_return := rtrim(v_return, ',');
        return v_return;
    exception
        when others then
            log_error('OSI_CHECKLIST.get_checklist_self_output:' || sqlerrm);
            raise;
    end get_checklist_self_output;

    /* Used to get the soft checklist list */
    function get_soft_checked_items(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2 is
        v_array      apex_application_global.vc_arr2;
        v_idx        integer                         := 1;
        v_return     varchar2(4000);
        v_complete   varchar2(200);
        v_msg        varchar2(1000);
    begin
        --Get checklist items that were checked in the past
        for k in (select checklist_item_type_sid
                    from t_osi_checklist_item
                   where obj = p_obj and status_change_sid = p_status_change_sid)
        loop
            v_array(v_idx) := k.checklist_item_type_sid;
            v_idx := v_idx + 1;
        end loop;

        --Get checklist items that can be auto checked
        for k in (select ocit.sid, ocit.verify_proc
                    from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
                   where ocitm.checklist_item_type_sid = ocit.sid
                     and ocitm.status_change_sid = p_status_change_sid
                     and (   ocit.obj_type is null
                          or ocit.obj_type = core_obj.get_objtype(p_obj))
                     and ocitm.user_editable = 1
                     and verify_proc is not null)
        loop
            execute immediate 'BEGIN ' || k.verify_proc || '(''' || p_obj || ''', :1 , :2); END;'
                        using out v_complete, out v_msg;

            if (v_complete = 1) then
                v_array(v_idx) := k.sid;
                v_idx := v_idx + 1;
            end if;
        end loop;

        v_return := apex_util.table_to_string(v_array, ':');
        return v_return;
    exception
        when others then
            log_error('get_soft_checked_items: ' || sqlerrm);
            raise;
    end get_soft_checked_items;

    /* Used to determine if Soft Checks exist */
    function soft_checks_exist(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2 is
        v_return   varchar2(20);
        v_cnt      number;
    begin
        select count(ocitm.sid)
          into v_cnt
          from t_osi_checklist_item_type_map ocitm, t_osi_checklist_item_type ocit
         where ocitm.status_change_sid = p_status_change_sid
           and ocitm.user_editable = 1
           and ocitm.checklist_item_type_sid = ocit.sid
           and (   ocit.obj_type = core_obj.get_objtype(p_obj)
                or ocit.obj_type is null);

        if (v_cnt > 0) then
            v_return := 'Y';
        else
            v_return := 'N';
        end if;

        return v_return;
    exception
        when others then
            log_error('get_soft_checked_items: ' || sqlerrm);
            raise;
    end soft_checks_exist;

    /* Used to verify that the current user is the lead agent */
    procedure user_is_lead_agent(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(sid)
          into v_cnt
          from t_osi_assignment
         where obj = p_obj
           and personnel = core_context.personnel_sid
           and assign_role in(select sid
                                from t_osi_assignment_role_type
                               where code = 'LEAD');

        if (   v_cnt = 0
            or v_cnt is null) then
            p_msg := 'Current User is not Lead Agent';
            p_complete := 0;
        else
            p_msg := 'Current User is Lead Agent';
            p_complete := 1;
        end if;
    exception
        when others then
            log_error('user_is_lead_agent: ' || sqlerrm);
            raise;
    end user_is_lead_agent;

    /* Used to verify that active assignments have work hours */
    procedure active_assignments_have_wrkhrs(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cnt   number;
    begin
        --NOTE: We currently do not have work hours functionality
        --TODO: When (and if) we do, we will need to uncomment this procedure and make it function properly
        p_complete := 1;
        p_msg := 'All Assigned Personnel Have Work Hours';
--        --GET ALL PERSONNEL ASSIGNED TO THE OBJECT WHO DO NOT HAVE WORKHOURS
--        select count(personnel)
--          into v_cnt
--          from t_osi_assignment
--         where obj = p_OBJ
--           and start_date <= sysdate
--           and end_date is null
--           and personnel not in(select personnel
--                                  from t_osi_labor_hours
--                                 where obj = p_obj);

    --        if v_cnt > 0 then
--            for c in (select osi_personnel.GET_NAME(personnel) as "personnel_name"
--                        from t_osi_assignment
--                       where obj = p_obj
--                         and start_date <= sysdate
--                         and end_date is null
--                         and personnel not in(select personnel
--                                                from t_osi_labor_hours
--                                               where obj = pp_obj))
--            loop
--                v_ids := v_ids || ltrim(rtrim(c.personnel_name)) || '<BR>';
--            end loop;

    --            p_complete := 0;
--            p_msg :=
--                'The Following Assignments do NOT have Work Hours:<HR>'
--                || substr(v_ids, 1, length(v_ids) - 4);
--        else
--            p_complete := 1;
--            p_msg := 'All Assigned Personnel Have Work Hours';
--        end if;
    exception
        when others then
            log_error('active_assignments_have_wrkhrs: ' || sqlerrm);
            raise;
    end active_assignments_have_wrkhrs;

    /* Used to verify that associated activities' active assignments have work hours */
    procedure assoc_act_assigns_have_wrkhrs(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cnt   number;
    begin
        --NOTE: We currently do not have work hours functionality
        --TODO: When (and if) we do, we will need to uncomment this procedure and make it function properly
        p_complete := 1;
        p_msg := 'All Assigned Personnel for Associated Activities Have Work Hours.';
--        v_cnt := 0;
--        --initialize count of activities with personnel missing work hours
--        v_msg := 'DEFAULT';                                                         --initial value

    --        --Loop through all associated activities for the given file
--        for n in (select activity, id
--                    from t_file_content c, t_activity a
--                   where c.fyle = pparent and activity = a.sid)
--        loop
--            --Check Assignments List for Each Associated Activity
--            checklist_pkg.verify_asgnmnts_wkhrs(n.activity, v_complete, v_msg);

    --            --count number of activities with personnel missing work hours
--            if v_complete = 0 then
--                v_cnt := v_cnt + 1;
--                v_ids :=
--                    v_ids || '<A HREF="I2MS:://pSid=' || n.activity || ' '
--                    || get_config('DEFAULTINI') || '">' || n.id || '</A>, ';
--            end if;
--        end loop;

    --        if v_msg = 'DEFAULT' then
--            pcomplete := null;
--            pmsg := 'No Associated Activities Found';
--        else
--            if v_cnt > 0 then
--                pcomplete := 0;
--                pmsg :=
--                    'The Following Associated Activities do Not have Work Hours for All Assigned Personnel:<HR>'
--                    || substr(v_ids, 1, length(v_ids) - 2);
--            else
--                pcomplete := 1;
--                pmsg := 'All Assigned Personnel for Associated Activities Have Work Hours.';
--            end if;
--        end if;
    exception
        when others then
            log_error('assoc_act_assigns_have_wrkhrs: ' || sqlerrm);
            raise;
    end assoc_act_assigns_have_wrkhrs;

    /* Used to verify that an activity has AT LEAST ONE subject */
    procedure activity_has_subject(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number;
    begin
        p_complete := 0;
        p_msg := 'MUST Have ONE Subject of Activity Participant.';

        select count(opi.sid)
          into v_count
          from t_osi_partic_involvement opi, t_osi_partic_role_type oprt
         where opi.involvement_role = oprt.sid
           and upper(oprt.role) = 'SUBJECT OF ACTIVITY'
           and opi.obj = p_obj;

        if v_count > 0 then
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('activity_has_subject: ' || sqlerrm);
            raise;
    end activity_has_subject;

    procedure partic_has_relationships(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(pr.sid)
          into v_cnt
          from t_osi_partic_relation pr
         where pr.partic_a = p_obj
            or pr.partic_b = p_obj;

        if (v_cnt > 0) then
            p_complete := 1;
            p_msg := 'Relationships exist.';
        else
            p_complete := 0;
            p_msg := 'Should have at least one relationship.';
        end if;
    exception
        when others then
            log_error('partic_has_relationships: ' || sqlerrm);
            raise;
    end partic_has_relationships;

    procedure partic_i_has_association(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number := 0;
    begin
        if (osi_participant.has_isn_number(p_obj) = 'Y') then
            p_complete := null;
            p_msg := 'Check for association is not needed.';
            return;
        end if;

        select count(pi.sid)
          into v_cnt
          from t_osi_partic_involvement pi, t_osi_participant_version pv
         where pi.participant_version = pv.sid
           and pv.participant = p_obj
           and (   pi.obj in(select sid
                               from t_osi_activity)
                or pi.obj in(select sid
                               from t_osi_file));

        if (v_cnt > 0) then
            p_complete := 1;
            p_msg := 'Associations exist.';
        else
            p_complete := 0;
            p_msg := 'Missing association with a File or Activity.';
        end if;
    exception
        when others then
            log_error('partic_i_has_association: ' || sqlerrm);
            raise;
    end partic_i_has_association;

    procedure partic_i_has_legal_name(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(n.sid)
          into v_cnt
          from t_osi_partic_name n, t_osi_partic_name_type t, t_osi_participant_version pv
         where pv.participant = p_obj
           and pv.sid = n.participant_version
           and n.name_type = t.sid
           and t.code = 'L';

        if (v_cnt > 0) then
            p_complete := 1;
            p_msg := 'A legal name is present.';
        else
            p_complete := 0;
            p_msg := 'A legal name MUST be given.';
        end if;
    exception
        when others then
            log_error('partic_i_has_legal_name: ' || sqlerrm);
            raise;
    end partic_i_has_legal_name;

    procedure partic_i_has_ssn(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        if (osi_participant.has_isn_number(p_obj) = 'Y') then
            p_complete := null;
            p_msg := 'SSN is not needed.';
            return;
        end if;

        select count(pn.sid)
          into v_cnt
          from t_osi_participant_version pv, t_osi_partic_number pn, t_osi_partic_number_type nt
         where pv.participant = p_obj
           and pn.participant_version = pv.SID
           and pn.num_type = nt.SID
           and nt.code = 'SSN';

        if (v_cnt > 0) then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Missing SSN.';
        end if;
    exception
        when others then
            log_error('partic_i_has_ssn: ' || sqlerrm);
            raise;
    end partic_i_has_ssn;

    procedure partic_n_has_cage_code(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(p.sid)
          into v_cnt
          from t_osi_participant_nonhuman p, t_osi_participant_version pv
         where pv.participant = p_obj and pv.sid = p.sid and p.co_cage is not null;

        if (v_cnt > 0) then
            p_complete := 1;
            p_msg := 'A Cage Code is present.';
        else
            p_complete := 0;
            p_msg := 'Missing Cage Code.';
        end if;
    exception
        when others then
            log_error('partic_n_has_cage_code: ' || sqlerrm);
            raise;
    end partic_n_has_cage_code;

    /* Used to verify that an objects participants are confirmed */
    procedure participants_confirmed(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_count           number          := 0;
        v_temp            varchar2(32767);
        v_obj_type_code   varchar2(200);
    begin
        --See if there are any participants to begin with
        select count(sid)
          into v_count
          from t_osi_partic_involvement
         where obj = p_obj;

        --if there are none, we can just exit with success
        if v_count = 0 then
            --We may have object level participants
            v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

            if (v_obj_type_code like 'ACT.SEARCH.%') then
                for k in (select opi.participant_version
                            from t_osi_partic_involvement opi,
                                 t_osi_participant_version opv,
                                 t_osi_participant op
                           where opi.participant_version = op.sid
                             and op.sid = opv.participant
                             and (   op.confirm_on is null
                                  or op.confirm_on = '')
                             and opi.obj = p_obj)
                  /*for k in (select oas.person
                 from t_osi_a_search oas,
                      t_osi_participant_version opv,
                      t_osi_participant op
                where oas.person = op.sid
                  and op.sid = opv.participant
                  and (   op.confirm_on is null
                       or op.confirm_on = '')
                  and oas.sid = p_obj)*/
                loop
                    --v_temp := v_temp || '<br>' || osi_object.get_open_link(k.participant);
                    v_temp :=
                             v_temp || '<br>' || osi_object.get_tagline_link(k.participant_version);
                end loop;

                --If no unconfirmed participants exist
                if (v_temp is null) then
                    p_complete := 1;
                    p_msg := 'All Participant(s) have been Confirmed.';
                else
                    --If unconfirmed participants exist
                    p_complete := 0;
                    p_msg := 'The Following Participant(s) are Unconfirmed:<br>' || v_temp;
                end if;
            else
                p_complete := null;
                p_msg := 'No Participants.';
            end if;

            return;
        else
            --There are participants, loop through and get them
            for k in (select opv.participant
                        from t_osi_partic_involvement opi,
                             t_osi_participant op,
                             t_osi_participant_version opv
                       where opi.obj = p_obj
                         and op.sid = opv.participant
                         and opv.sid = opi.participant_version
                         and op.confirm_by is null)
            loop
                --v_temp := v_temp || '<br>' || osi_object.get_open_link(k.participant);
                v_temp := v_temp || '<br>' || osi_object.get_tagline_link(k.participant);
            end loop;

            --If no unconfirmed participants exist
            if (v_temp is null) then
                p_complete := 1;
                p_msg := 'All Participant(s) have been Confirmed.';
            else
                --If unconfirmed participants exist
                p_complete := 0;
                p_msg := 'The Following Participant(s) are Unconfirmed:<br>' || v_temp;
            end if;
        end if;
    exception
        when others then
            log_error('participants_confirmed: ' || sqlerrm);
            raise;
    end participants_confirmed;

    procedure clist_has_comments(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_temp          varchar2(32767);
        v_cur_section   varchar2(20)    := 1;
        v_br            varchar2(4)     := '<br>';
        v_max_rtn       integer         := 0;
        v_tot           integer         := 0;
    begin
        p_complete := 1;
        p_msg := 'Required comments exist.';

        for x in (select r.section, r.section_desc, r.item_seq, r.item_text, r.answer
                    from v_osi_clist_result r, t_osi_a_clist_comment_req cr
                   where r.checklist = p_obj
                     and r.item = cr.item
                     and r.answer = cr.answer
                     and r.comment_text is null
                     and cr.active = 'Y')
        loop
            if (v_tot = v_max_rtn) then
                if (v_cur_section <> x.section) then
                    v_cur_section := x.section;
                    v_temp := v_temp || v_br;
                    v_temp := v_temp || x.section_desc || v_br;
                end if;
            end if;

            if (v_max_rtn < 5) then
                v_max_rtn := v_max_rtn + 1;
                v_temp := v_temp || x.item_seq || '. ' || x.item_text || v_br;
            end if;

            v_tot := v_tot + 1;
        end loop;

        if (v_temp is not null) then
            p_complete := 0;
            p_msg :=
                'Here are ' || v_max_rtn || ' of ' || v_tot || ' items that require a comment: '
                || v_br || v_temp;
            return;
        end if;

        for x in (select r.sid
                    from v_osi_clist_result r, t_osi_a_clist_comment_req cr, t_osi_a_clist_answer a
                   where r.checklist = p_obj
                     and r.display_buttons = 'Y'
                     and r.item = cr.item
                     and r.answer = a.sid
                     and a.checklist_type = osi_clist.get_checklist_type(p_obj)
                     and a.answer_type in(osi_reference.lookup_ref_sid('CLIST_ANSWER', 'ANSWER0')))
        loop
            p_complete := null;
            p_msg := 'No answers were given that require comments.';
            return;
        end loop;
    exception
        when others then
            log_error('clist_has_comments: ' || sqlerrm);
            raise;
    end clist_has_comments;

    procedure clist_is_complete(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_temp          varchar2(32767);
        v_cur_section   varchar2(20)    := 1;
        v_br            varchar2(4)     := '<br>';
        v_max_rtn       integer         := 0;
        v_tot           integer         := 0;
    begin
        p_complete := 1;
        p_msg := 'Checklist is complete.';

        for x in (select r.section, r.section_desc, r.item_seq, r.item_text
                    from v_osi_clist_result r, t_osi_a_clist_answer a
                   where r.checklist = p_obj
                     and r.display_buttons = 'Y'
                     and r.answer = a.sid
                     and a.answer_type = osi_reference.lookup_ref_sid('CLIST_ANSWER', 'ANSWER0'))
        loop
            if (v_tot = v_max_rtn) then
                if (v_cur_section <> x.section) then
                    v_cur_section := x.section;
                    v_temp := v_temp || v_br;
                    v_temp := v_temp || x.section_desc || v_br;
                end if;
            end if;

            if (v_max_rtn < 5) then
                v_max_rtn := v_max_rtn + 1;
                v_temp := v_temp || x.item_seq || '. ' || x.item_text || v_br;
            end if;

            v_tot := v_tot + 1;
        end loop;

        if (v_temp is not null) then
            p_complete := 0;
            p_msg :=
                'Here are ' || v_max_rtn || ' of ' || v_tot || ' items that are not complete: '
                || v_br || v_temp;
        end if;
    exception
        when others then
            log_error('clist_is_complete: ' || sqlerrm);
            raise;
    end clist_is_complete;

    procedure search_explanation(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_obj_type_code   varchar2(200);
    begin
        --Clear variables
        p_complete := 1;
        p_msg := 'Explanation present';
        --Get the object type code
        v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

        if (   v_obj_type_code = 'ACT.SEARCH.PLACE'
            or v_obj_type_code = 'ACT.SEARCH.PROPERTY') then
            for k in (select explanation
                        from t_osi_a_search
                       where sid = p_obj)
            loop
                if (   k.explanation is null
                    or k.explanation = '') then
                    p_complete := 0;
                    p_msg := 'Explanation can not be empty for this type of search.';
                end if;
            end loop;
        elsif(v_obj_type_code = 'ACT.SEARCH.PERSON') then
            p_complete := null;
            p_msg := 'Explanation is not applicable for this type of search.';
        end if;
    exception
        when others then
            log_error('search_explanation: ' || sqlerrm);
            raise;
    end search_explanation;

    procedure search_person(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_obj_type_code   varchar2(200);
        v_partic_role     t_osi_partic_role_type.sid%type;
        v_cnt             number;
    begin
        --Clear variables
        p_complete := 1;
        p_msg := 'Person present';
        --Get the object type code
        v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

        if (   v_obj_type_code = 'ACT.SEARCH.PLACE'
            or v_obj_type_code = 'ACT.SEARCH.PROPERTY') then
            p_complete := null;
            p_msg := 'Person Associated with search is not applicable for this type of search.';
        elsif(v_obj_type_code = 'ACT.SEARCH.PERSON') then
            select sid
              into v_partic_role
              from t_osi_partic_role_type
             where obj_type = core_obj.lookup_objtype('ACT.SEARCH.PERSON') and usage = 'SUBJECT';

            select count(participant_version)
              into v_cnt
              from t_osi_partic_involvement
             where obj = p_obj and involvement_role = v_partic_role;

            if (v_cnt <= 0) then
                p_complete := 0;
                p_msg := 'Person Associated with search can not be empty for this type of search.';
            end if;
        end if;
    exception
        when others then
            log_error('search_person: ' || sqlerrm);
            raise;
    end search_person;

    procedure source_is_confirmed(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_participant   t_osi_f_source.participant%type;
    begin
        p_complete := 1;
        p_msg := 'Source is confirmed.';

        for x in (select participant
                    from t_osi_f_source
                   where sid = p_obj)
        loop
            v_participant := x.participant;
        end loop;

        if (v_participant is null) then
            p_complete := null;
            p_msg := 'No sources present.';
        else
            if (osi_participant.is_confirmed(v_participant) is null) then
                p_complete := 0;
                p_msg := 'Unconfirmed source.';
            end if;
        end if;
    exception
        when others then
            log_error('source_is_confirmed: ' || sqlerrm);
            raise;
    end source_is_confirmed;

    procedure source_required_notes(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt           integer;
        v_sep           varchar2(2)                        := ', ';
        v_msg           varchar2(200);
        v_description   t_osi_note_type.description%type;
    begin
        p_complete := 1;
        p_msg := 'Required notes exist.';

        if (note_type_exists(p_obj, 'RFFU', v_description) is null) then
            v_msg := v_description || v_sep;
        end if;

        if (note_type_exists(p_obj, 'R', v_description) is null) then
            v_msg := v_msg || v_description || v_sep;
        end if;

        if (v_msg is not null) then
            p_complete := 0;
            p_msg := 'Missing required notes: ' || rtrim(v_msg, v_sep) || '.';
        end if;
    exception
        when others then
            log_error('source_required_notes: ' || sqlerrm);
            raise;
    end source_required_notes;

    procedure surv_intcond_null(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        --- Check that Intercept Conducted is Null ---
        select count(*)
          into v_cnt
          from t_osi_a_surveillance
         where sid = p_obj and(   interceptconducted is null
                               or interceptconducted = 'U');

        if v_cnt = 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Intercept Conducted must be checked or unchecked.';
        end if;
    exception
        when others then
            log_error('surv_intcond_null: ' || sqlerrm);
            raise;
    end surv_intcond_null;

    procedure surv_activation_date(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        --- Check that Intercept Conducted is set ---
        select count(*)
          into v_cnt
          from t_osi_a_surveillance
         where sid = p_obj and interceptconducted = 'Y' and activation_date is null;

        if v_cnt = 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Must have Date of Activation if Intercept has been Conducted.';
        end if;
    exception
        when others then
            log_error('surv_activation_date: ' || sqlerrm);
            raise;
    end surv_activation_date;

    procedure surv_approval_data(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        --- Check that Intercept Conducted is set           ---
        select count(*)
          into v_cnt
          from t_osi_a_surveillance
         where sid = p_obj and interceptconducted = 'Y';

        if v_cnt > 0 then
            --- If it is, we must have approval data  ---
            select count(*)
              into v_cnt
              from t_osi_a_surv_approval s
             where s.surveillance = p_obj;
        else
            v_cnt := 1;
        end if;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Must have Approval Data if Intercept has been Conducted.';
        end if;
    exception
        when others then
            log_error('surv_approval_data: ' || sqlerrm);
            raise;
    end surv_approval_data;

    procedure surv_participant(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_objtype       varchar2(20);
        v_agency_role   varchar2(20);
        v_target_role   varchar2(20);
        v_cnt1          number;
        v_cnt2          number;
        v_msg1          varchar2(100)
            := 'Must have at least one participant with Action/Role of:  ''Agency Conducting the Intercept''.';
        v_msg2          varchar2(100)
             := 'Must have at least one participant with Action/Role of:  ''Targeted Individual''.';
    begin
        v_objtype := core_obj.get_objtype(p_obj);

        select sid
          into v_agency_role
          from t_osi_partic_role_type
         where obj_type = v_objtype
           and usage = 'PARTICIPANTS'
           and role = 'Agency Conducting the Intercept';

        select sid
          into v_target_role
          from t_osi_partic_role_type
         where obj_type = v_objtype and usage = 'PARTICIPANTS' and role = 'Targeted Individual';

        --- We must have at least one 'Agency Conducting the Intercept' participant  ---
        select count(*)
          into v_cnt1
          from t_osi_a_surveillance s, t_osi_partic_involvement t
         where s.sid = p_obj and s.sid = t.obj and t.involvement_role = v_agency_role;

        select count(*)
          into v_cnt2
          from t_osi_a_surveillance s, t_osi_partic_involvement t
         where s.sid = p_obj and s.sid = t.obj and t.involvement_role = v_target_role;

        if v_cnt1 > 0 and v_cnt2 > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;

            if v_cnt1 = 0 and v_cnt2 = 0 then
                p_msg := v_msg1 || '<BR>' || v_msg2;
            elsif v_cnt1 = 0 then
                p_msg := v_msg1;
            elsif v_cnt2 = 0 then
                p_msg := v_msg2;
            end if;
        end if;
    exception
        when others then
            log_error('surv_participant: ' || sqlerrm);
            raise;
    end surv_participant;

    /* DEBUGGING ONLY */
    procedure test_check(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        p_complete := 1;
    end test_check;

/*=============================================================================================*/
/* Used to verify that there is a valid state and/or country.                                  */
/*=============================================================================================*/
    procedure dibrs_valid_st_ctry(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp
         where sp.investigation = p_parent and sp.off_us_state is null and sp.off_country is null;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'State or Country code must be reported';
        else
            p_complete := 1;
            p_msg := 'State or Country code confirmed.';
        end if;
    exception
        when others then
            log_error('dibrs_valid_st_ctry: ' || sqlerrm);
            raise;
    end dibrs_valid_st_ctry;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_injury_self(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select distinct count(*)
                   into v_count
                   from t_osi_f_inv_spec s,
                        t_dibrs_offense_type o,
                        t_osi_f_inv_spec_arm sa,
                        t_dibrs_reference r
                  where s.investigation = p_parent
                    and sa.specification = s.sid
                    and s.offense = o.sid
                    and o.code = '115-B2'
                    and sa.armed_with = r.sid
                    and (r.code in('12', '11', '13', '14') and r.usage = 'ARMED_WITH');

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Cannot have Gun Category with offense 115-B2';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_injury_self: ' || sqlerrm);
            raise;
    end dibrs_injury_self;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_gun_category(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select distinct count(*)
                   into v_count
                   from t_osi_f_inv_spec s,
                        t_osi_f_inv_spec_arm sa,
                        t_dibrs_reference r1,
                        t_dibrs_reference r2
                  where s.investigation = p_parent
                    and s.sid = sa.specification
                    and sa.armed_with = r1.sid(+)
                    and r1.code not in('11', '12', '13', '14')
                    and sa.gun_category = r2.sid(+)
                    and r2.code in('A', 'M', 'S');

        if v_count > 0 then
            p_complete := 0;
            p_msg :=
                'Gun Category cannot be reported as Weapon/Force Used. If Weapon/Force Used is NOT a Type of Firearm';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_gun_category: ' || sqlerrm);
            raise;
    end dibrs_gun_category;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_vic_type(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        for a in (select ot.nibrs_code, ot.crime_against, ot.code as offense_code,
                         r1.code as subtype_code, cot.code as type_code
                    from t_osi_f_inv_spec s,
                         t_osi_f_inv_offense o,
                         t_dibrs_offense_type ot,
                         t_osi_reference r1,
                         t_osi_reference r2,
                         t_osi_participant p,
                         t_osi_participant_version pv,
                         t_osi_participant_human ph,
                         t_osi_participant_nonhuman pnh,
                         t_core_obj co,
                         t_core_obj_type cot
                   where s.investigation = p_parent
                     and s.offense = ot.sid
                     and ot.code not in('110-A-', '134-V2', '110-B-', '134-Z-')
                     and s.investigation = o.investigation
                     and o.offense = ot.sid
                     and o.priority = r2.sid
                     and r2.code <> 'N'
                     and ot.nibrs_code is not null
                     and s.victim = pv.sid
                     and pv.sid = p.current_version
                     and p.current_version = ph.sid(+)
                     and p.current_version = pnh.sid(+)
                     and pnh.sub_type = r1.sid(+)
                     and p.sid = co.sid
                     and co.obj_type = cot.sid)
        loop
            -- Victim type must be individual for the specified offenses
            if (   a.nibrs_code in
                       ('09B', '09C', '11A', '11B', '11C', '11D', '13A', '13B', '13C', '36A', '36B',
                        '100')
                or a.offense_code in
                       ('088---', '089---', '093---', '111-B1', '118-A-', '118-A1', '118-B-',
                        '118-C-', '118-D-', '119-A-', '119-B2', '120-N1', '125-C-', '134-R2',
                        '134-R3', '134U7A')) then
                if a.type_code <> 'PART.INDIV' then
                    v_count := v_count + 1;
                end if;
            -- Victim type must be society for the specified offenses
            elsif(   a.nibrs_code in
                         ('35A', '35B', '39A', '39B', '39C', '39D', '370', '40A', '40B', '520',
                          '90B', '90C', '90D', '90E', '90F', '90G', '90H', '90J')
                  or a.offense_code in
                         (                                                            --90Z offenses
                          '082-A-', '082-B1', '082-B2', '082-B3', '082-B4', '083-A-', '083-B-',
                          '084-A-', '084-B-', '085-A-', '085-B1', '085-B2', '085-C1', '085-C2',
                          '085-D-', '086-A1', '086-A2', '086-B1', '086-B2', '086-B3', '086-B4',
                          '086-C1', '086-C2', '086-D-', '087-A-', '087-B-', '090-B1', '090-B2',
                          '091-B1', '091-B2', '091-C1', '091-C2', '091-C3', '092-A0', '092-A1',
                          '092-A3', '092-A6', '092-A7', '092-A8', '092-B-', '092-C1', '092-C2',
                          '095-A-', '095-B-', '095-C-', '095-D1', '095-D2', '096-A-', '096-B1',
                          '096-B2', '098-A-', '098-B-', '099-A-', '099-B-', '099-C-', '099-D-',
                          '099-E-', '099-F-', '099-G-', '099-H-', '099-I-', '100-A-', '100-B-',
                          '101-A-', '101-B-', '102---', '104-A-', '104-B-', '104-C-', '104-D-',
                          '105-A-', '105-B-', '106---', '106-A-', '111-B2', '113-A1', '113-A2',
                          '113-A3', '115-A1', '115-A2', '115-B1', '115-B2', '118-B1', '131-A-',
                          '131-B-', '133-A-', '133-C-', '133-D-', '134-B1', '134-B2', '134-B3',
                          '134-B4', '134-G1', '134-G2', '134-G3', '134-G4', '134-G5', '134-G6',
                          '134-I1', '134-M1', '134-O1', '134-P2', '134-P3', '134-U1', '134-U2',
                          '134-U3', '134-U4', '134-U6', '134-U7', '134-U8', '134-W1', '134-W2',
                          '134-W3', '134-Z-')) then
                if not(a.type_code = 'PART.NONINDIV.ORG' and a.subtype_code = 'POS') then
                    v_count := v_count + 1;
                end if;
            -- Victim type cannot be society for the specified offenses
            elsif    a.nibrs_code =('220')
                  or a.crime_against =('Property') then
                if a.subtype_code = 'POS' then
                    v_count := v_count + 1;
                end if;
            end if;
        end loop;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Invalid Victim Type for selected Offense(s)';
        else
            p_complete := 1;
            p_msg := 'Victim Type validated for the selected Offense(s)';
        end if;
    exception
        when others then
            log_error('dibrs_vic_type: ' || sqlerrm);
            raise;
    end dibrs_vic_type;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_valid_age(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_pres   number := 0;
        v_cnt    number := 0;
        v_cnt2   number := 0;
        v_cnt3   number := 0;
        v_cnt4   number := 0;
    begin
        select count(*)
          into v_pres
          from t_osi_f_inv_spec sp, v_osi_participant_version pv, t_core_obj_type ot
         where sp.investigation = p_parent
           and pv.obj_type = ot.sid
           and (   (sp.victim = pv.sid and ot.code = 'PART.INDIV')
                or (sp.subject = pv.sid and ot.code = 'PART.INDIV'));

        if v_pres = 0 then
            p_complete := null;
            p_msg := 'No Individual Victim/Offender Present';
            return;
        end if;

        for a in (select pv.age_low, pv.age_high
                    from t_osi_f_inv_spec sp, v_osi_participant_version pv
                   where sp.investigation = p_parent
                     and (   sp.victim = pv.sid
                          or sp.subject = pv.sid)
                     and pv.age_low not in('NN', 'NB', 'BB')
                     and pv.age_high is not null)
        loop
            if a.age_low >= a.age_high then
                v_cnt := v_cnt + 1;
            end if;
        end loop;

        select count(*)
          into v_cnt2
          from t_osi_f_inv_spec sp, v_osi_participant_version pv
         where sp.investigation = p_parent
           and (   sp.victim = pv.sid
                or sp.subject = pv.sid)
           and pv.age_low in('NN', 'NB', 'BB')
           and pv.age_high is not null;

        select count(*)
          into v_cnt3
          from t_osi_f_inv_spec sp, v_osi_participant_version pv
         where sp.investigation = p_parent
           and (   sp.victim = pv.sid
                or sp.subject = pv.sid)
           and (   pv.age_low is null
                or pv.age_low in('0', '00'))
           and pv.age_high > 0;

        select count(*)
          into v_cnt4
          from t_osi_f_inv_spec sp, v_osi_participant_version pv
         where sp.investigation = p_parent
           and (   sp.victim = pv.sid
                or sp.subject = pv.sid)
           and (pv.age_high > 0 and(   pv.age_high < 2
                                    or pv.age_high > 99));

        if    (v_cnt > 0)
           or (v_cnt2 > 0)
           or (v_cnt3 > 0)
           or (v_cnt4 > 0) then
            p_complete := 0;
            p_msg := 'Invalid Victim/Offender age range.';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_valid_age: ' || sqlerrm);
            raise;
    end dibrs_valid_age;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_vicrel_ofdr(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count     number  := 0;
        v_subyear   boolean := false;
        v_age       number  := 0;
        v_offage    number  := 0;
        n_count     number  := 0;
    begin
        -- If Victim Type is not part.indiv (Individual), Offender IDs Related to this Victim cannot be reported.
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp, v_osi_participant_version pv, t_core_obj_type ot
         where sp.investigation = p_parent
           and sp.vic_rel_to_offender is not null
           and sp.victim is not null
           and sp.victim = pv.sid
           and pv.obj_type = ot.sid
           and ot.code <> 'PART.INDIV';

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Victim must have a valid relationship to Offender';
            return;
        end if;

        -- If Victim Type is a part.indiv (Individual), Offender IDs Related to this Victim must be reported.
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp, v_osi_participant_version pv, t_core_obj_type ot
         where sp.investigation = p_parent
           and sp.vic_rel_to_offender is null
           and sp.victim is not null
           and sp.victim = pv.sid
           and pv.obj_type = ot.sid
           and ot.code = 'PART.INDIV';

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Victim relationship to Offender must exist';
            return;
        end if;

        -- Only one Victim/Offender Related may have Relationship of Victim to Offender of "VO" (Victim was Offender)
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp, t_dibrs_reference r
         where sp.investigation = p_parent
           and sp.vic_rel_to_offender = r.sid
           and r.code = 'VO'
           and (   exists(
                       select 'x'
                         from t_osi_f_inv_spec ssp, t_dibrs_reference sr
                        where ssp.sid <> sp.sid
                          and ssp.incident = sp.incident
                          and ssp.vic_rel_to_offender = sr.sid
                          and sr.code = 'VO'
                          and ssp.victim = sp.victim)
                or exists(
                       select 'x'
                         from t_osi_f_inv_spec ssp, t_dibrs_reference sr
                        where ssp.sid <> sp.sid
                          and ssp.incident = sp.incident
                          and ssp.vic_rel_to_offender = sr.sid
                          and sr.code = 'VO'
                          and ssp.subject = sp.subject));

        if v_count > 0 then
            p_complete := 0;
            p_msg :=
                'Only one Victim/Offender Related value may have Relationship of Victim to '
                || 'Offender of Victim was Offender)';
            return;
        end if;

        -- If Relationship of Victim to Offender is "VO", a minimum of two Victim and two Offender segments are required
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp, t_dibrs_reference r
         where sp.investigation = p_parent
           and sp.vic_rel_to_offender = r.sid
           and r.code = 'VO'
           and (   not exists(
                              select 'x'
                                from t_osi_f_inv_spec
                               where sid <> sp.sid and incident = sp.incident
                                     and victim <> sp.victim)
                or not exists(
                            select 'x'
                              from t_osi_f_inv_spec
                             where sid <> sp.sid and incident = sp.incident
                                   and subject <> sp.subject));

        if v_count > 0 then
            p_complete := 0;
            p_msg :=
                'If Relationship of Victim to Offender is "Offender", a minimum of two Victim and two '
                || 'Offender records are required';
            return;
        end if;

        -- A Victim can only be married to one offender.
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp, t_dibrs_reference r
         where sp.investigation = p_parent
           and sp.vic_rel_to_offender = r.sid
           and r.code = 'AA'
           and exists(
                   select 'x'
                     from t_osi_f_inv_spec ssp, t_dibrs_reference sr
                    where ssp.sid <> sp.sid
                      and ssp.incident = sp.incident
                      and ssp.vic_rel_to_offender = sr.sid
                      and sr.code = 'AA'
                      and ssp.subject <> sp.subject
                      and ssp.victim = sp.victim);

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'An Victim can only be married to one Offender';
            return;
        end if;

        -- An Offender can only be married to one Victim.
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp, t_dibrs_reference r
         where sp.investigation = p_parent
           and sp.vic_rel_to_offender = r.sid
           and r.code = 'AA'
           and exists(
                   select 'x'
                     from t_osi_f_inv_spec ssp, t_dibrs_reference sr
                    where ssp.sid <> sp.sid
                      and ssp.incident = sp.incident
                      and ssp.vic_rel_to_offender = sr.sid
                      and sr.code = 'AA'
                      and ssp.subject = sp.subject
                      and ssp.victim <> sp.victim);

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'An Offender can only be married to one Victim';
            return;
        end if;

        --updated 9/6/06 C. Marston to check ages against the incident date as opposed to the current date.
        -- The following checks all deal w/age
        for a in (select pn.last_name as last_name, sp.vic_rel_to_offender, p.dob as vicdob,
                         pv.age_low as viclowage, pv.age_high as vichighage, pv.sex as vicsex,
                         p2.dob as offdob, pv2.age_low as offlowage, pv2.age_high as offhighage,
                         pv2.sex as offsex, pc.race as offrace, i.start_date as incdate,
                         vr.code as vic_rel_to_offender_code, rt.code as offrace_code,
                         st.code as offsex_code
                    from t_osi_f_inv_spec sp,
                         v_osi_participant_version pv,
                         v_osi_participant_version pv2,
                         t_osi_f_inv_incident i,
                         t_osi_partic_name pn,
                         t_core_obj_type ot,
                         t_osi_person_chars pc,
                         t_osi_participant p,
                         t_osi_participant p2,
                         t_dibrs_reference vr,                                -- victim relationship
                         t_dibrs_race_type rt,                                          -- race type
                         t_dibrs_reference st                                            -- sex type
                   where sp.investigation = p_parent
                     and sp.subject = pn.participant_version
                     and sp.incident = i.sid
                     and sp.victim is not null
                     and sp.subject is not null
                     and sp.victim = pv.sid
                     and sp.subject = pv2.sid
                     and pv.obj_type = ot.sid
                     and pv2.obj_type = ot.sid
                     and ot.code = 'PART.INDIV'
                     and pv2.sid = pc.sid
                     and pv2.participant = p2.sid
                     and pv.participant = p.sid
                     and pv2.current_name = pn.sid
                     and pc.race = rt.sid(+)
                     and pc.sex = st.sid(+)
                     and vr.sid = sp.vic_rel_to_offender(+))
        loop
            -- victim age
            if a.vicdob is not null then
                if to_char(trunc(a.vicdob), 'MM') = to_char(trunc(a.incdate), 'MM') then
                    if to_char(trunc(a.vicdob), 'DD') - to_char(trunc(a.incdate), 'DD') > 0 then
                        v_subyear := true;
                    end if;
                elsif to_char(trunc(a.vicdob), 'MM') > to_char(trunc(a.incdate), 'MM') then
                    v_subyear := true;
                end if;

                if v_subyear = true then
                    v_age := to_char(trunc(a.incdate), 'YYYY') - to_char(trunc(a.vicdob), 'YYYY');
                    v_age := v_age - 1;
                else
                    v_age := to_char(trunc(a.incdate), 'YYYY') - to_char(trunc(a.vicdob), 'YYYY');
                end if;
            elsif a.vichighage is not null then
                v_age := a.vichighage;
            elsif a.viclowage is not null then
                case a.viclowage
                    when 'NN' then                                          -- DIBRS under 24 hours
                        v_age := .0024;
                    when 'NB' then                                        -- DIBRS 1 - 6 days of age
                        v_age := .060;
                    when 'BB' then                                      -- DIBRS 7 - 364 days of age
                        v_age := .364;
                    else                                                         -- age must be >= 1
                        v_age := a.viclowage;
                end case;
            end if;

            -- offender age
            if a.offdob is not null then
                if to_char(trunc(a.offdob), 'MM') = to_char(trunc(a.incdate), 'MM') then
                    if to_char(trunc(a.offdob), 'DD') - to_char(trunc(a.incdate), 'DD') > 0 then
                        v_subyear := true;
                    end if;
                elsif to_char(trunc(a.offdob), 'MM') > to_char(trunc(a.incdate), 'MM') then
                    v_subyear := true;
                end if;

                if v_subyear = true then
                    v_offage := to_char(trunc(a.incdate), 'YYYY')
                                - to_char(trunc(a.offdob), 'YYYY');
                    v_offage := v_offage - 1;
                else
                    v_offage := to_char(trunc(a.incdate), 'YYYY')
                                - to_char(trunc(a.offdob), 'YYYY');
                end if;
            elsif a.offhighage is not null then
                v_offage := a.offhighage;
            elsif a.offlowage is not null then
                v_offage := a.offlowage;
            end if;

            --735 For 'AA' relationship age of victim and offender must be >=10
            if a.vic_rel_to_offender_code = 'AA' then
                if v_age > 0 then
                    if v_age < 10 then
                        v_count := v_count + 1;
                    end if;
                end if;

                if v_offage > 0 then
                    if v_offage < 10 then
                        v_count := v_count + 1;
                    end if;
                end if;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'For a Relationship value of "Spouse" the age of Victim and Offender must be >=10';
                    return;
                end if;
            end if;      --a.vic_rel_to_offender = 'AA' then age of victim and offender must be >=10

            -- Modified 9/25/06 C. Marston to include Offender name unknown error 733
            -- 737 If Offender Age, Sex, or Race is unknown, Relationship of Victim to Offender must be "CB"
            -- Modified 01/16/07 mtschnupp. This information is now being pulled above in the query running the 'a' loop.
            -- Relationship of Victim to Offender was not being matched up correctly with the corresponding offender.
            if    v_offage = 0
               or (   a.offsex_code is null
                   or a.offsex_code = 'I')
               or (   a.offrace_code is null
                   or a.offrace_code = 'U')
               or (n_count > 0) then
                if a.vic_rel_to_offender_code <> 'CB' then
                    v_count := v_count + 1;
                end if;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'If Offender Age, Sex, or Race is unknown, Relationship of Victim to '
                        || 'Offender must be "Relationship Unknown"';
                    return;
                end if;
            end if;

            --739 The reported Relationship of Victim to Offender is inconsistent with the reported Age of Offender
            if v_age > 0 and v_offage > 0 then
                if a.vic_rel_to_offender_code in('AB', 'AK') and v_age > v_offage then
                    -- victim was child, grandchild
                    v_count := v_count + 1;
                elsif a.vic_rel_to_offender_code in('AD', 'AG') and v_age < v_offage then
                    -- victim was parent, grandparent
                    v_count := v_count + 1;
                end if;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'Relationship of Victim to Offender is inconsistent with the reported Age of Offender';
                    return;
                end if;
            end if;
        end loop;

        if v_count = 0 then
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_vicrel_ofdr: ' || sqlerrm);
            raise;
    end dibrs_vicrel_ofdr;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_criminal_activity(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_count   number := 0;
    begin
        select count(*)
          into v_count
          from t_osi_f_inv_spec s, t_dibrs_offense_type ot
         where s.investigation = p_parent
           and s.offense = ot.code
           and ot.nibrs_code in
                   ('09A', '09B', '100', '120', '11A', '11B', '11C', '11D', '13A', '13B', '13C',
                    '35A', '35B', '39C', '250', '370', '280', '520')
           and not exists(select 'x'
                            from t_osi_f_inv_spec_crim_act ca
                           where ca.specification = s.sid);

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Must have a valid Criminal Activity for the specified Offense ID';
        else
            p_complete := 1;
            p_msg := 'Has a valid Criminal Activity for the specified Offense ID';
        end if;
    exception
        when others then
            log_error('dibrs_criminal_activity: ' || sqlerrm);
            raise;
    end dibrs_criminal_activity;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_property_require(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count    number := 0;
        v_count1   number := 0;
        v_count2   number := 0;
        v_count3   number := 0;
        v_count4   number := 0;
        v_count5   number := 0;
        v_count6   number := 0;
    begin
        --Check for offenses related to specification which allow for a property record.
        select count(*)
          into v_count
          from t_osi_f_inv_spec s, t_dibrs_offense_type ot
         where s.investigation = p_parent and s.offense = ot.sid and ot.property_applies = 'Y';

        if v_count = 0 then --No offenses in specification which allow for property records, exit OK
            p_complete := null;
            p_msg :=
                'No offenses present which allow for property records. No Property Records Required';
            return;
        end if;

        --reinitialize the variable
        v_count := 0;

        --Check to see if we have any property of loss types of 2-7
        select count(*)
          into v_count
          from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec s
         where s.investigation = p_parent
           and p.specification = s.sid
           and pl.sid = p.prop_loss_by
           and pl.report_as in(select sid
                                 from t_dibrs_property_loss_by_type
                                where code in('2', '3', '4', '5', '6', '7'));

        --If not, then we can exit OK.
        if v_count = 0 then
            p_complete := null;
            p_msg := 'No Property Record(s) exist or required for Offense(s)';
            return;                                                                      -- get out
        end if;

        -- If we have property loss types of 2-7 then we need to make sure they have a DESCRIPTION and VALUE
        -- exception for drug offenses, which do NOT require a value
        v_count := 0;

        select count(*)
          into v_count
          from t_osi_f_inv_property p,
               t_dibrs_property_loss_by_type pl,
               t_osi_f_inv_spec sp,
               t_dibrs_offense_type ot
         where pl.sid = p.prop_loss_by
           and sp.investigation = p_parent
           and sp.sid = p.specification
           and sp.offense = ot.sid
           and pl.report_as in(select sid
                                 from t_dibrs_property_loss_by_type
                                where code in('2', '3', '4', '5', '6', '7'))
           and (   p.prop_type is null
                or (ot.nibrs_code not in('35A') and p.prop_value is null));

        if v_count > 0 then
            p_complete := 0;
            p_msg :=
                'For Action Types of (Burned,Counterfited/Forged,Damaged/Destroyed/Vandalized,Recovered, '
                || 'Seized,Stolen etc..) a Description and Value are required. For Drug Offense(s) '
                || 'a Property Value is NOT required.';
            return;                                                                      -- get out
        end if;

        --If we have property loss types of 5 then we need to check the ACTION and PROP_RETURNED_ON dates
        --Fail if:
        -->Either data is null
        -->PROP_RETURNED_ON date is not after ACTION date, must be greater than Action Date
        select count(*)
          into v_count1
          from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec sp
         where sp.investigation = p_parent
           and sp.sid = p.specification
           and pl.sid = p.prop_loss_by
           and p.action_date is null;

        if v_count1 > 0 then
            p_complete := 0;
            p_msg := 'An Action Date is required. ';
            return;                                                                      -- get out
        end if;

        -- DIBRS Error 560
        select count(*)
          into v_count2
          from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec sp
         where sp.investigation = p_parent
           and sp.sid = p.specification
           and pl.sid = p.prop_loss_by
           and pl.report_as in(select sid
                                 from t_dibrs_property_loss_by_type
                                where code <> '5')
           and p.prop_returned_on is not null;

        if v_count2 > 0 then
            p_complete := 0;
            p_msg :=
                 'Return Date cannot be reported unless the property loss by is marked Recovered. ';
            return;                                                                      -- get out
        end if;

---TJW - Changes made 10-Feb-2012, now it is in-line with I2MS Legacy.        
        --check to make sure there is a recovered date if the property was marked 'Recovered'
        -- error 665, recovered prop must have recovered date
---TJW        select count(*)
---TJW          into v_count3
---TJW          from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec sp
---TJW         where sp.investigation = p_parent
---TJW           and sp.sid = p.specification
---TJW           and pl.sid = p.prop_loss_by
---TJW           and pl.report_as = (select sid
---TJW                                 from t_dibrs_property_loss_by_type
---TJW                                where code = '5')
---TJW           and (   p.prop_returned_on is null
---TJW                or p.action_date is null);
---TJW
---TJW        if v_count3 > 0 then
---TJW            p_complete := 0;
---TJW            p_msg :=
---TJW                'For an Action Type of (Recovered) a Action Date and a Returned On Date are required. ';
---TJW            return;                                                                      -- get out
---TJW        end if;

        select count(*)
          into v_count4
          from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec sp
         where sp.investigation = p_parent
           and sp.sid = p.specification
           and pl.sid = p.prop_loss_by
           and pl.report_as in(select sid
                                 from t_dibrs_property_loss_by_type
                                where code in('5', '7'))
           and p.prop_returned_on is not null
           and p.action_date is not null
           and to_char(p.prop_returned_on, 'YYYY/MM/DD HH24MI') <
                                                         to_char(p.action_date, 'YYYY/MM/DD HH24MI');

        if v_count4 > 0 then
            p_complete := 0;
            p_msg :=
                'For an Action Type of (Recovered) the Returned On Date must be after Action Date.';
            return;                                                                      -- get out
        end if;

        --If we have property loss types of 5 then we must have a corresponding loss type of 7
        select count(*)
          into v_count5
          from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec sp
         where sp.investigation = p_parent
           and sp.sid = p.specification
           and pl.sid = p.prop_loss_by
           and pl.report_as = (select sid
                                 from t_dibrs_property_loss_by_type
                                where code = '5')
           and not exists(
                   select 'x'
                     from t_osi_f_inv_property sp,
                          t_dibrs_property_loss_by_type spl,
                          t_osi_f_inv_spec ssp
                    where ssp.investigation = p_parent
                      and ssp.sid = sp.specification
                      and spl.sid = sp.prop_loss_by
                      and p.prop_type = sp.prop_type
                      and spl.report_as = (select sid
                                             from t_dibrs_property_loss_by_type
                                            where code = '7'));

        if v_count5 > 0 then
            p_complete := 0;
            p_msg :=
                'For Action Type of (Recovered) then we must have a corresponding Action Type of '
                || '(Stolen) for this Incident.';
            return;                                                                      -- get out
        end if;

        --Quantity (of Property) is required when Property Description is 03, 05, 24, 28, or 37. We have auto property w/out value
        select count(*)
          into v_count6
          from t_osi_f_inv_property p, t_osi_f_inv_spec sp
         where sp.investigation = p_parent
           and sp.sid = p.specification
           and p.prop_type in(select sid
                                from t_dibrs_property_type type
                               where code in('03', '05', '24', '28', '37'))
           and (   p.prop_quantity is null
                or p.prop_quantity = 0);

        if v_count6 > 0 then
            p_complete := 0;
            p_msg :=
                'Quantity (of Property) is required when Property Description is Automobiles, Buses, '
                || 'Other Motor Vehicles, Recreational Vehicles or Trucks';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_property_require: ' || sqlerrm);
            raise;
    end dibrs_property_require;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_vicage_pres(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count     number  := 0;
        v_count2    number  := 0;
        v_subyear   boolean := false;
        v_age       number  := 0;
    begin
        for a in (select ot.nibrs_code, p.dob, ph.age_low, ph.age_high, i.start_date inc_date
                    from t_dibrs_offense_type ot,
                         t_osi_f_inv_spec sp,
                         t_osi_participant p,
                         t_osi_participant_version pv,
                         t_osi_participant_human ph,
                         t_osi_f_inv_offense o,
                         t_osi_f_inv_incident i,
                         t_osi_reference r
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and sp.investigation = o.investigation
                     and o.priority = r.sid
                     and r.code <> 'N'
                     and ot.nibrs_code is not null
                     and sp.victim is not null
                     and sp.victim = pv.sid
                     and pv.participant = p.sid
                     and pv.sid = ph.sid
                     and i.sid = sp.incident)
        loop
            if a.nibrs_code = '36B' then
                v_count2 := v_count2 + 1;

                -- Age of Victim must be reported and must be less than or equal to 16
                if a.dob is not null then
                    if to_char(trunc(a.dob), 'MM') = to_char(trunc(a.inc_date), 'MM') then
                        if to_char(trunc(a.dob), 'DD') - to_char(trunc(a.inc_date), 'DD') > 0 then
                            v_subyear := true;
                        end if;
                    elsif to_char(trunc(a.dob), 'MM') > to_char(trunc(a.inc_date), 'MM') then
                        v_subyear := true;
                    end if;

                    if v_subyear = true then
                        v_age := to_char(trunc(a.inc_date), 'YYYY') - to_char(trunc(a.dob), 'YYYY');
                        v_age := v_age - 1;
                    else
                        v_age := to_char(trunc(a.inc_date), 'YYYY') - to_char(trunc(a.dob), 'YYYY');
                    end if;

                    if v_age > 16 then
                        v_count := v_count + 1;
                    end if;
                elsif a.age_high is not null then
                    v_age := a.age_high;

                    if v_age > 16 then
                        v_count := v_count + 1;
                    end if;
                elsif a.age_low is not null then
                    v_age := a.age_low;

                    if v_age > 16 then
                        v_count := v_count + 1;
                    end if;
                else
                    v_count := v_count + 1;
                end if;
            end if;
        end loop;

        if v_count2 = 0 then
            p_complete := null;                                                   -- not applicable
            p_msg := 'No Carnal Knowledge <= 16 Offenses';
            return;                                                                      -- get out
        end if;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Victim Age Not Specified';
        else
            p_complete := 1;
            p_msg := 'Victim Age Specified';
        end if;
    exception
        when others then
            log_error('dibrs_vicage_pres: ' || sqlerrm);
            raise;
    end dibrs_vicage_pres;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/

    function get_offense_count(p_nibrs_code in varchar2, p_parent varchar2, p_incident in varchar2, p_victim in varchar2, p_in_notin in varchar2 := 'IN') return number is
         
         v_count number;
         
    begin
         if p_in_notin = 'NOTIN' then

           select count(*) into v_count
             from t_dibrs_offense_type ot,
                  t_osi_f_inv_offense o,
                  t_osi_f_inv_spec sv2,
                  t_osi_reference r
            where o.investigation = p_parent
              and o.offense = ot.sid
              and o.offense = sv2.offense
              and o.priority = r.sid
              and r.code <> 'N'
              and ot.nibrs_code is not null
              and p_victim = sv2.victim
              and p_incident = sv2.incident
              and ot.nibrs_code not in(select column_value from table(split(p_nibrs_code,':')));

         else
         
           select count(*) into v_count
             from t_dibrs_offense_type ot,
                  t_osi_f_inv_offense o,
                  t_osi_f_inv_spec sv2,
                  t_osi_reference r
            where o.investigation = p_parent
              and o.offense = ot.sid
              and o.offense = sv2.offense
              and o.priority = r.sid
              and r.code <> 'N'
              and p_victim = sv2.victim
              and p_incident = sv2.incident
              and ot.nibrs_code in(select column_value from table(split(p_nibrs_code,',')));
         
         end if;
         
         return v_count;
        
    end get_offense_count;

    procedure check_offense_combos(p_parent in varchar2, p_nibrs_code in varchar2, p_incident in varchar2, p_victim in varchar2, v_offense in varchar2, p_complete out varchar2, p_msg out varchar2, v_count out number) is

    begin
         v_count:=0;
         
         -- if 09C exists, there can't be any other reportable offenses (693)
         if p_nibrs_code = '09C' then

           v_count := get_offense_count('09C', p_parent, p_incident, p_victim, 'NOTIN');
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'For this offense ' || v_offense || ' there can`t be any other reportable offenses';
             return;
             -- exit if error exists

           end if;

         end if;

         -- if 09A exists,  then 09B, 13A, 13B, and 13C are not allowed (699)
         if p_nibrs_code = '09A' then
              
           v_count := get_offense_count('09B,13A,13B,13C', p_parent, p_incident, p_victim);
           if v_count > 0 then
              
             p_complete := 0;
             p_msg := 'When a Manslaughter offense ' || v_offense || ' is used, then Negligent Manslaughter, Aggravated Assault, ' || 'Simple Assault, and Intimidation are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

         --if 09B exists, 09A, 13A, 13B, and 13C are not allowed (700)
         if p_nibrs_code = '09B' then

           v_count := get_offense_count('09A,13A,13B,13C', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When a Negligent Manslaughter offense ' || v_offense || ' is used then NIBRS Manslaughter, Aggravated Assault, ' || 'Simple Assault, and Intimidation are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

         -- if 11A, then 11D, 13A, 13B, 13C, 36A, and 36B are not allowed (701)
         if p_nibrs_code = '11A' then

           v_count := get_offense_count('11D,13A,13B,13C,36A,36B', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When a Forcible Rape offense ' || v_offense || ' is used then Forcible Fondling, Aggravated Assault, ' || 'Simple Assault, Intimidation, Incest, and Statutory Rape are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

         -- if 11B, then 11D, 13A, 13B, 13C, 36A, and 36B are not allowed (702)
         if p_nibrs_code = '11B' then
 
           v_count := get_offense_count('11D,13A,13B,13C,36A,36B', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When a Forcible Sodomy offense ' || v_offense || ' is used then Forcible Fondling, Aggravated Assault, ' || 'Simple Assault, Intimidation, Incest, and Statutory Rape are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

         -- if 11C, then 11D, 13A, 13B, 13C, 36A, and 36B are not allowed (703)
         if p_nibrs_code = '11C' then
 
           v_count := get_offense_count('11D,13A,13B,13C,36A,36B', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When a Sexual Assault with an Object offense ' || v_offense || ' is used then Forcible Fondling, Aggravated Assault, ' || 'Simple Assault, Intimidation, Incest, and Statutory Rape are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

         -- if 11D, then 11A, 11B, 11C, 13A, 13B, 13C, 36A, and 36B are not allowed (704)
         if p_nibrs_code = '11D' then

           v_count := get_offense_count('11A,11B,11C,13A,13B,13C,36A,36B', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When a Forcible Fondling offense ' || v_offense || ' is used then Forcible Rape, Forcible Sodomy, Sexual Assault ' || 'with an Object, Aggravated Assault, Simple Assault, ' || 'Intimidation, Incest, and Statutory Rape are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

         -- if 120, then 13A, 13B, 13C, 23A through 23H, and 240 are not allowed (705)
         if p_nibrs_code = '120' then

           v_count := get_offense_count('13A,13B,13C,23A,23B,23C,23D,23E,23F,23G,23H,240', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg :='When a Robbery offense ' || v_offense|| ' is used then Aggravated Assault, Simple Assault, '|| 'Intimidation, Pocket picking, Purse-snatching, '|| 'Shoplifting, Theft From Building, Property, '|| 'Theft from Coin Operated Machine '|| 'Device, Theft From Motor Vehicle, Parts or Accessories, ' || 'All other Larceny and Motor Vehicle Theft are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

         -- if 13A, then 09A, 09B, 11A, 11B, 11C, 120, 13B, and 13C are not allowed (706)
         if p_nibrs_code = '13A' then
 
           v_count := get_offense_count('09A,09B,11A,11B,11C,120,13B,13C', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg :='When a Aggravated Assault offense ' || v_offense || ' is used then Murder and Nonnegligent Manslaughter, Negligent Manslaughter, ' || 'Forcible Rape, Forcible Sodomy, Sexual Assault with an Object, Robbery, ' || 'Simple Assault and Intimidation are not allowed';
             return;                                                 -- exit if error exists
              
           end if;

         end if;

         -- if 13B, then 09A, 09B, 11A, 11B, 11C, 11D, 120, 13A, and 13C are not allowed (710)
         if p_nibrs_code = '13B' then

           v_count := get_offense_count('09A,09B,11A,11B,11C,11D,120,13A,13C', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When a Simple Assault offense ' || v_offense || ' then NIBRS Murder and Nonnegligent Manslaughter, Negligent Manslaughter, ' || 'Forcible Rape, Forcible Sodomy, Sexual Assault with an Object, Forcible Fondling, ' || 'Robbery, Aggravated Assault, and Intimidation are not allowed';
             return;                                                 -- exit if error exists
              
           end if;

         end if;

         -- if 13C, then 09A, 09B, 11A, 11B, 11C, 11D, 120, 13A, and 13B are not allowed (711)
         if p_nibrs_code = '13C' then
 
           v_count := get_offense_count('09A,09B,11A,11B,11C,11D,120,13A,13B', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When an Intimidation offense ' || v_offense || ' then NIBRS Murder and Nonnegligent Manslaughter, Negligent Manslaughter, ' || 'Forcible Rape, Forcible Sodomy, Sexual Assault with an Object, Forcible Fondling, ' || 'Robbery, Aggravated Assault, and Simple Assault are not allowed';
             return;                                                 -- exit if error exists
  
           end if;

         end if;

         -- if 23A through 23H or 240, then 120 is not allowed (712)
         if p_nibrs_code in('23A', '23B', '23C', '23D', '23E', '23F', '23G', '23H', '240') then

           v_count := get_offense_count('120', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When a Pocket picking, Purse-snatching, Shoplifting, Theft From Building, ' || 'Theft from Coin Operated Machine Device, Theft From Motor Vehicle, ' || 'Parts or Accessories, All other Larceny or Motor Vehicle Theft offense ' || v_offense || ' is used then Robbery Offense is not allowed';
             return;                                                 -- exit if error exists

           end if;
 
         end if;

         -- if 36A or 36B, then 11A, 11B, 11C, and 11D are not allowed (713)
         if p_nibrs_code in('36A', '36B') then

           v_count := get_offense_count('11A,11B,11C,11D', p_parent, p_incident, p_victim);
           if v_count > 0 then

             p_complete := 0;
             p_msg := 'When an Incest or Statutory Rape offense ' || v_offense || ' is used then Forcible Rape, Forcible Sodomy, Sexual Assault with an Object ' || 'or Forcible Fondling are not allowed';
             return;                                                 -- exit if error exists

           end if;

         end if;

    end check_offense_combos;
    
    procedure dibrs_comb_valid(p_parent in varchar2, p_complete out number, p_msg out varchar2) is

         v_count     number      := 0;

    begin
         for a in (select ot.nibrs_code, ot.code, sv2.victim, sv2.incident
                     from t_dibrs_offense_type ot,
                          t_osi_f_inv_offense o,
                          t_osi_f_inv_spec sv2,
                          t_osi_reference r
                    where o.investigation = p_parent
                      and o.offense = ot.sid
                      and o.offense = sv2.offense
                      and o.priority = r.sid
                      and r.code <> 'N'
                      and sv2.investigation = o.investigation
                      and ot.nibrs_code is not null)
         loop
             check_offense_combos(p_parent, a.nibrs_code, a.incident, a.victim, a.code, p_complete, p_msg, v_count);
             
             if v_count > 0 then
             
               return;
               
             end if;
             
         end loop;
             
         p_complete := 1;
         p_msg := 'Valid Combination of Offenses';

    exception
        when others then
            log_error('dibrs_comb_valid: ' || sqlerrm);
            raise;
    end dibrs_comb_valid;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_ofdr_info(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        results         number := 0;
        v_count         number := 0;
        subject_count   number := 0;
    begin
        p_complete := 0;                                              -- Assuming it will not pass.
        p_msg := null;

        --Check for clearance reason for ALL offenses
        select count(*)
          into v_count
          from t_osi_f_inv_incident i, t_osi_f_inv_incident_map im
         where im.investigation = p_parent and i.sid = im.incident and i.clearance_reason is null;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'All Offenses must have clearance reason';
            return;
        end if;

        select count(*)
          into v_count
          from t_osi_f_inv_incident_map mi,
               t_osi_f_inv_incident i,
               t_osi_f_inv_spec sp,
               t_osi_participant_version pv,
               t_osi_participant p,
               t_core_obj o,
               t_core_obj_type ot,
               t_dibrs_clearance_reason_type rt
         where i.sid = mi.incident
           and sp.sid = o.sid
           and o.obj_type = ot.sid
           and sp.investigation = p_parent
           and sp.investigation = mi.investigation
           and sp.subject = pv.sid
           and pv.participant = p.sid
           and ot.code not in('PART.INDIV')
           and rt.code not in('U', 'X', 'N')
           and i.clearance_reason = rt.sid(+);

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Must have valid clearance reason for non-individual Offenses';
            return;
        end if;

        -- Make sure we have some T_OFFENSE_TYPE.CLASS_CODE records with 'B'.
        select count(*)
          into results
          from t_dibrs_offense_type ot,
               t_osi_f_inv_spec sp,
               t_osi_f_inv_incident i,
               t_dibrs_clearance_reason_type rt
         where sp.investigation = p_parent
           and sp.incident = i.sid
           and sp.offense = ot.sid
           and ot.class_code = 'B'
           and rt.code not in('U', 'X', 'N')
           and i.clearance_reason = rt.sid(+);

        if results > 0 then
            p_msg := 'No Exceptional Clearance present.';
            p_complete := 0;
            return;
        end if;

        results := 0;

        select count(*)
          into results
          from v_osi_participant_version pv,
               t_osi_participant p,
               t_osi_f_inv_spec sp,
               t_osi_f_inv_incident i,
               t_osi_person_chars pc,
               t_core_obj_type ot,
               t_osi_partic_name n,
               t_dibrs_clearance_reason_type rt
         where sp.investigation = p_parent
           and pv.sid = pc.sid
           and pv.participant = p.sid
           and pv.sid = p.current_version
           and pv.obj_type = ot.sid
           and pv.current_name = n.sid
           and sp.subject = pv.sid
           and sp.incident = i.sid
           and n.last_name like '%UNKNOWN%'
           and ot.code = 'PART.INDIV'
           and rt.code not in('U', 'X', 'N')
           and i.clearance_reason = rt.sid(+)
           and (   pv.dob is null and pv.age_low is null and pv.age_high is null
                or pv.sex is null
                or pv.sex_code = 'I'
                or pc.race is null);

        if (results > 0) then
            p_complete := 0;
            p_msg :=
                'If Offender is "UNKNOWN" and missing offender Age, Sex or Race, '
                || 'then Exceptional Clearance reason must be "Not Applicable", "Unfounded/Unresolved", or "Arrest"';
            --PMSG := 'If Offender is "UNKNOWN" and missing offender Age, Sex or Race, then Exceptional Clearance reason must be "Unfounded" or "Arrest or Arrest Equivalent"';
            return;
        end if;

        results := 0;
        p_msg := null;

        for subj_name in (select osi_participant.get_name(pv.participant) as ofdr
                            from v_osi_participant_version pv,
                                 t_osi_partic_involvement pi,
                                 t_core_obj_type ot,
                                 t_osi_partic_name n,
                                 t_osi_person_chars pc
                           where pi.obj = p_parent
                             and pi.participant_version = pv.sid
                             and pv.sid = pc.sid
                             and pv.current_name = n.sid
                             and pi.involvement_role = 'Subject'
                             and pv.obj_type = ot.sid
                             and ot.code = 'PART.INDIV'
                             and (   (pv.dob is null and pv.age_low is null and pv.age_high is null)
                                  or pv.sex is null
                                  or pv.sex_code = 'I'
                                  or pc.race is null)
                             and n.last_name not like '%UNKNOWN%')
        loop
            if p_msg is null then
                p_msg :=
                    'Missing Known Offender Age, Sex or Race for one or more of the listed subjects :';
            end if;

            p_msg := p_msg || ' << ' || subj_name.ofdr || ' >>';
        end loop;

        if p_msg is not null then
            p_complete := 0;
            return;
        else
            p_complete := 1;                                                   -- Checklist passed.
            p_msg := null;
            return;
        end if;
    exception
        when others then
            log_error('dibrs_ofdr_info: ' || sqlerrm);
            raise;
    end dibrs_ofdr_info;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_diff_sex(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_records   number := 0;
        v_count     number := 0;
        v_count2    number := 0;
    begin
        for a in (select sp.vic_rel_to_offender, pv.sex as vicsex, pv2.sex as offsex,
                         ot.nibrs_code as nibrs_code, pv.sex_code as vicsex_code,
                         pv2.sex_code as offsex_code
                    from t_osi_f_inv_spec sp,
                         t_osi_f_inv_offense o,
                         t_dibrs_offense_type ot,
                         t_osi_reference r,
                         v_osi_participant_version pv,
                         v_osi_participant_version pv2
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and sp.investigation = o.investigation
                     and o.priority = r.sid(+)
                     and r.code <> 'N'
                     and ot.nibrs_code is not null
                     and ot.nibrs_code in('11A', '36B')
                     and sp.victim is not null
                     and sp.subject is not null
                     and sp.victim = pv.sid
                     and sp.subject = pv2.sid
                     and (select sot.code
                            from t_core_obj_type sot
                           where pv.obj_type = sot.sid) = 'PART.INDIV'
                     and (select sot.code
                            from t_core_obj_type sot
                           where pv2.obj_type = sot.sid) = 'PART.INDIV')
        loop
            v_records := v_records + 1;

            if (   a.nibrs_code = '11A'
                or a.nibrs_code = '36B') then
                if    (a.vicsex is null)
                   or (a.offsex is null)
                   or (a.vicsex = a.offsex)
                   or (a.vicsex_code = 'I')
                   or (a.offsex_code = 'I') then
                    v_count := v_count + 1;
                end if;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'For this type of offense the sex of Victim and Offender must be different in at least one case and neither can be reported as Indeterminate. Change '
                        || 'the sex of at least one of the Victims and/or Offenders so that not all '
                        || 'Victims and Offenders are the same sex. ';
                    return;
                end if;
            end if;
        end loop;

        --738 'BE','BH','AA','BB' - diff 'BL' - same
        for b in (select sp.vic_rel_to_offender, pv.sex as vicsex, pv2.sex as offsex,
                         r.code as vic_rel_to_offender_code
                    from t_osi_f_inv_spec sp,
                         v_osi_participant_version pv,
                         v_osi_participant_version pv2,
                         t_dibrs_reference r
                   where sp.investigation = p_parent
                     and sp.victim is not null
                     and sp.subject is not null
                     and sp.victim = pv.sid
                     and sp.subject = pv2.sid
                     and r.sid = sp.vic_rel_to_offender(+)
                     and (select sot.code
                            from t_core_obj_type sot
                           where pv.obj_type = sot.sid) = 'PART.INDIV'
                     and (select sot.code
                            from t_core_obj_type sot
                           where pv2.obj_type = sot.sid) = 'PART.INDIV')
        loop
            v_records := v_records + 1;

            if b.vic_rel_to_offender_code in('BE', 'BH', 'AA', 'BB') then
                if b.vicsex is not null and b.offsex is not null then
                    if b.vicsex = b.offsex then
                        v_count2 := v_count2 + 1;
                    end if;
                end if;
            elsif b.vic_rel_to_offender_code = 'BL' then
                if b.vicsex is not null and b.offsex is not null then
                    if b.vicsex <> b.offsex then
                        v_count2 := v_count + 1;
                    end if;
                end if;
            end if;
        end loop;

        if v_records = 0 then
            p_complete := null;
            p_msg := null;
        end if;

        if    (v_count > 0)
           or (v_count > 0) then
            p_complete := 0;
            p_msg := 'Victim/Offender sex must be different in one case.';
        else
            p_complete := 1;
            p_msg := 'Victim/Offender sex is different in at least one case.';
        end if;
    exception
        when others then
            log_error('dibrs_diff_sex: ' || sqlerrm);
            raise;
    end dibrs_diff_sex;

/*=============================================================================================*/
/*  Validate the begin and end dates.                                                          */
/*=============================================================================================*/
    procedure dibrs_ir_occ_date(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number := 0;
    begin
        v_cnt := 0;

        for c in (select i.start_date bdate, i.end_date edate, sysdate sdate
                    from t_osi_f_inv_incident i, t_osi_f_inv_incident_map im
                   where im.investigation = p_parent and im.incident = i.sid)
        loop
            if    c.edate <= c.bdate
               or c.bdate is null
               or c.edate is null then
                --and to_char(i.IR_OCC_END_DATE, 'MM/DD/YYYY HH24MI') > to_char(i.IR_OCC_BEGIN_DATE, 'MM/DD/YYYY HH24MI');
                v_cnt := v_cnt + 1;
            end if;

            -- Error # 626
            if c.bdate > c.sdate then
                v_cnt := v_cnt + 1;
            end if;
        end loop;

        if v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Missing Occurs End Date';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('OSI_CHECKLIST.dibrs_ir_occ_date: ' || sqlerrm);
            raise;
        --Code developed by another developer; unsure of the reasons for changing procedure
        -- so we opted to go back to original code from I2MS.  JLH - 10/1/2010
        /*p_msg := null;

        for c in (select fi.start_date bdate, fi.end_date edate
                    from t_osi_f_inv_incident fi, t_osi_f_inv_incident_map i
                   where i.investigation = p_parent and i.incident = fi.sid)
        loop
            if    (c.bdate is null)
               or (c.edate is null) then
                if c.bdate is null then
                    v_count := v_count + 1;
                    p_msg := 'A begin date is required.';
                end if;

                if c.edate is null then
                    v_count := v_count + 1;
                    p_msg := p_msg || 'An end date is required.';
                end if;
            else
                if c.edate <= c.bdate then
                    v_count := v_count + 1;
                    p_msg := 'The end date must be later than the begin date.';
                end if;

                if c.bdate > sysdate then
                    v_count := v_count + 1;
                    p_msg := p_msg || '  Begin date can not be in the future.';
                end if;
            end if;
        end loop;

        if v_count > 0 then
            p_complete := 0;
        else
            p_complete := 1;
            p_msg := 'Valid Date Range';
        end if;
    exception
        when others then
            log_error('dibrs_ir_occ_date: ' || sqlerrm);
            raise; */
    end dibrs_ir_occ_date;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_max_value(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        --Check to see if we have any property values over 1M
        select count(*)
          into v_count
          from t_osi_f_inv_property p, t_osi_f_inv_spec sp
         where p.specification = sp.sid and sp.investigation = p_parent and p.prop_value > 1000000;

        --If not, then we can exit OK.
        if v_count = 0 then
            p_complete := null;
            p_msg := 'No High Property Value';
            return;                                                                      -- get out
        end if;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Property value exceeds $1,000,000';
        else
            p_complete := 1;
            p_msg := 'Property value is under $1,000,000';
        end if;
    exception
        when others then
            log_error('dibrs_max_value: ' || sqlerrm);
            raise;
    end dibrs_max_value;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_vicsex_pres(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count    number := 0;
        v_count2   number := 0;
    begin
        for a in (select ot.nibrs_code, (select dr.code
                                           from t_dibrs_reference dr
                                          where pc.sex = dr.sid) as sex, r.code as priority_code
                    from t_dibrs_offense_type ot,
                         t_osi_f_inv_spec sp,
                         t_osi_participant_version pv,
                         t_osi_f_inv_offense o,
                         t_osi_person_chars pc,
                         t_core_obj_type cot,
                         t_osi_reference r
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and pv.sid = pc.sid
                     and sp.investigation = o.investigation
                     and r.sid = o.priority(+)
                     and r.code <> 'N'
                     and ot.nibrs_code is not null
                     and sp.victim is not null
                     and sp.victim = pv.sid
                     and ot.nibrs_code in('11A', '36B'))
        loop
            v_count2 := v_count2 + 1;

            if (   a.sex is null
                or a.sex not in('M', 'F')) then
                v_count := v_count + 1;
            end if;
        end loop;

        if v_count2 = 0 then
            p_complete := null;                                                   -- not applicable
            p_msg := 'No applicable offenses';
            return;                                                                      -- get out
        end if;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Victim Sex Not Specified';
        else
            p_complete := 1;
            p_msg := 'Victim Sex Specified';
        end if;
    exception
        when others then
            log_error('dibrs_vicsex_pres: ' || sqlerrm);
            raise;
    end dibrs_vicsex_pres;

/*=============================================================================================*/
/* Verify weapon(s) and force used.                                                            */
/*=============================================================================================*/
    procedure dibrs_w_f_used(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count    number := 0;                      -- used for all offenses                    --
        v_count2   number := 0;                      -- used for homicide check                  --
        v_count3   number := 0;                      -- used for simple assault check            --
        v_count4   number := 0;                      -- used for simple assault 2nd weapon check --
        v_count5   number := 0;                      -- used for simple assault 2nd weapon check --
    begin
        --- check for all offenses requiring force/weapon used ---
        select distinct count(*)
                   into v_count
                   from t_osi_f_inv_spec a, t_dibrs_offense_type c
                  where a.investigation = p_parent
                    and a.offense = c.sid
                    and c.code != '117---'
                    and c.code in(select code
                                    from t_dibrs_offense_type
                                   where type_weapon_used_applies = 'Y'
                                      or c.code = '0000A6');

        --- No Offenses have TYPE_WEAPON_USED_APPLIES = 'Y' ---
        if v_count = 0 then
            p_complete := 1;
            p_msg := 'No offense has a weapon used.';
            return;
        end if;

        for a in (select s.sid
                    from t_osi_f_inv_spec s, t_dibrs_offense_type c
                   where s.investigation = p_parent
                     and s.offense = c.sid
                     and c.code != '117---'
                     and c.code in(select code
                                     from t_dibrs_offense_type
                                    where type_weapon_used_applies = 'Y'
                                       or c.code = '0000A6'))
        loop
            select count(*)
              into v_count
              from t_osi_f_inv_spec_arm s
             where s.specification = a.sid;

            if v_count <= 0 then
                p_complete := 0;
                p_msg := 'Must have Force/Weapon used';
                return;
            end if;
        end loop;

        --- verify that force/weapon used is not "none" for homicide offense Error # 680                       ---
        --- reference Data Element Edits -- Offense Segment Edits #9 p.31 (see above comments for more detail) ---
        select distinct count(*)
                   into v_count2
                   from t_osi_f_inv_spec s,
                        t_dibrs_offense_type o,
                        t_osi_f_inv_spec_arm a,
                        t_dibrs_reference r
                  where s.investigation = p_parent
                    and s.sid = a.specification
                    and a.armed_with = r.sid
                    and r.code in('99')
                    and s.offense = o.sid
                    and o.nibrs_code in('09A', '09B', '09C');

        if v_count2 > 0 then
            p_complete := 0;
            p_msg := 'Weapon/Force used cannot be "None" for homicide offenses';
            return;
        end if;

        --- verify that type weapon is 40 "personal weapon", 90 "other", 95 "unknown", or                      ---
        --- 99 "none" for simple assault Error # 681                                                           ---
        select distinct count(*)
                   into v_count3
                   from t_osi_f_inv_spec a,
                        t_dibrs_offense_type b,
                        t_osi_f_inv_spec_arm s,
                        t_dibrs_reference r
                  where a.investigation = p_parent
                    and a.sid = s.specification
                    and s.armed_with = r.sid
                    and r.code not in('40', '90', '95', '99')
                    and a.offense = b.sid
                    and b.nibrs_code = '13B';

        if v_count3 > 0 then
            p_complete := 0;
            p_msg := 'Weapon/Force must be "Personal Weapon", "Other", "Unknown", or "None"';
            return;
        end if;

        --- For Simple Assault, the second weapon force used must be 40, 90, or null Error 683                  ---
        --- reference Data Element Edits -- Offense Segment Edits #10 p.31 (see above comments for more detail) ---
        select count(*)
          into v_count4
          from t_osi_f_inv_spec a,
               t_dibrs_offense_type b,
               t_osi_f_inv_spec_arm s,
               t_dibrs_reference r
         where a.investigation = p_parent
           and a.sid = s.specification
           and s.armed_with = r.sid
           and r.code in('40', '90', '95', '99')
           and a.offense = b.sid
           and b.nibrs_code = '13B';

        if v_count4 > 1 then
            select count(*)
              into v_count5
              from t_osi_f_inv_spec a,
                   t_dibrs_offense_type b,
                   t_osi_f_inv_spec_arm s,
                   t_dibrs_reference r
             where a.investigation = p_parent
               and a.sid = s.specification
               and s.armed_with = r.sid
               and r.code in('40', '90')
               and a.offense = b.sid
               and b.nibrs_code = '13B';

            if v_count5 < 1 then
                p_complete := 0;
                p_msg := 'Second Weapon/Force must be "Personal Weapon" or "Other"';
                return;
            else
                p_complete := 1;
                p_msg := null;
                return;
            end if;
        --- if you get this far and haven't returned yet, all checks completed ---
        else
            p_complete := 1;
            p_msg := null;
            return;
        end if;
    exception
        when others then
            log_error('dibrs_w_f_used: ' || sqlerrm);
            raise;
    end dibrs_w_f_used;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_vicindiv_age(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select count(*)
          into v_count
          from t_osi_f_inv_spec sp,
               t_osi_participant p,
               v_osi_participant_version pv,
               t_osi_participant_human ph
         where sp.investigation = p_parent
           and pv.sid = ph.sid
           and sp.victim is not null
           and sp.victim = pv.sid
           and pv.participant = p.sid
           and (select sot.code
                  from t_core_obj_type sot
                 where pv.obj_type = sot.sid) = 'PART.INDIV'
           and p.dob is null
           and ph.age_low is null;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Individual Victim must have a valid age.';
        else
            p_complete := 1;
            p_msg := 'Individual Victim has a valid age.';
        end if;
    exception
        when others then
            log_error('dibrs_vicindiv_age: ' || sqlerrm);
            raise;
    end dibrs_vicindiv_age;

/*=============================================================================================*/
/*  Validate victim to offender relationship.                                                  */
/*=============================================================================================*/
    procedure dibrs_vicrel_warn(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_record_count   number := 0;
    begin
        select count(*)
          into v_record_count
          from t_osi_f_inv_spec sp, v_osi_participant_version pv
         where sp.investigation = p_parent
           and sp.victim is not null
           and sp.victim = pv.sid
           and (select sot.code
                  from t_core_obj_type sot
                 where pv.obj_type = sot.sid) = 'PART.INDIV';

        if v_record_count = 0 then
            p_complete := null;
            p_msg := 'No Individual victims exist';
            return;
        end if;

        v_record_count := 0;

        -- 730 -  If Victim Type is "PART.INDIV" (Individual) and Group is A, Offender Relation must exist
        select count(*)
          into v_record_count
          from t_osi_f_inv_spec sp, v_osi_participant_version pv, t_dibrs_offense_type ot
         where sp.investigation = p_parent
           and sp.offense = ot.sid
           and sp.vic_rel_to_offender is null
           and sp.victim is not null
           and sp.victim = pv.sid
           and (select sot.code
                  from t_core_obj_type sot
                 where pv.obj_type = sot.sid) = 'PART.INDIV'
           and ot.class_code = 'A';

        if v_record_count > 0 then
            p_complete := 0;
            p_msg := 'Victim relationship to Offender must exist';
        else
            p_complete := 1;
            p_msg := 'Victim relationship to Offender exists';
        end if;
    exception
        when others then
            log_error('dibrs_vicrel_warn: ' || sqlerrm);
            raise;
    end dibrs_vicrel_warn;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_ssn_length(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select distinct count(*)
                   into v_count
                   from t_osi_partic_number pnu,
                        t_osi_partic_name pna,
                        t_osi_f_inv_spec sp,
                        t_osi_partic_number_type pnt
                  where sp.investigation = p_parent
                    and length(pnu.num_value) < 9
                    and length(pnu.num_value) > 9
                    and pnu.participant_version = pna.participant_version
                    and pnu.participant_version = sp.subject
                    and pnt.sid = pnu.num_type(+)
                    and pnt.code = 'SSN';

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Subject SSN must have 9 numbers.';
        else
            p_complete := 1;
            p_msg := 'Subject SSN is the properly length.';
        end if;
    exception
        when others then
            log_error('dibrs_ssn_length: ' || sqlerrm);
            raise;
    end dibrs_ssn_length;

/*=============================================================================================*/
/*  This procedure will check for information located in the drug_code, prop_quantity, or      */
/*  drug_measure which are not allowed due to business rules.                                  */
/*  This satisfies the errors 541 and 563                                                      */
/*=============================================================================================*/
    procedure dibrs_rmv_drug_info(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select count(*)
          into v_count
          from t_osi_f_inv_property p, t_osi_f_inv_spec sp
         where p.specification = sp.sid
           and sp.investigation = p_parent
           and (   (select dr.code
                      from t_dibrs_reference dr
                     where p.drug_type = dr.sid) is not null
                or drug_measure is not null);

        if (v_count <= 0) then
            p_complete := null;
            p_msg := 'No drug info available.';
            return;
        end if;

        v_count := 0;

        select count(*)
          into v_count
          from t_osi_f_inv_offense o, t_dibrs_offense_type t
         where o.investigation = p_parent and o.offense = t.sid and t.nibrs_code = '35A';

        if (v_count <= 0) then
            p_complete := 0;
            p_msg :=
                'Drug information is not allowed because no offense recorded for '
                || 'this incident is drug-related';
        else
            p_complete := 1;
            p_msg := 'Drug information accepted.';
        end if;
    exception
        when others then
            log_error('dibrs_rmv_drug_info: ' || sqlerrm);
            raise;
    end dibrs_rmv_drug_info;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_society(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number;
    begin
        -- determine if there are any offenses against society
        select count(*)
          into v_count
          from t_dibrs_offense_type ot,
               t_osi_f_inv_spec sp,
               t_osi_reference r,
               t_osi_f_inv_offense o
         where sp.investigation = p_parent
           and sp.offense = ot.sid
           and sp.investigation = o.investigation
           and o.offense = ot.sid
           and ot.crime_against = 'Society'
           and o.priority = r.sid
           and r.code <> 'N'
           and ot.code not in('0000A2', '0000A3', '0000A5');

        if v_count = 0 then                            -- if no offenses against society exist, exit
            p_complete := null;
            p_msg := 'No offenses against society exist';
            return;
        end if;

        v_count := 0;

        -- count the number of offenses against society which do NOT list society as victim
        select count(*)
          into v_count
          from t_dibrs_offense_type ot,
               t_osi_f_inv_spec sp,
               t_osi_f_inv_offense o,
               t_osi_reference r,
               t_osi_partic_name n
         where sp.investigation = p_parent
           and sp.offense = ot.sid
           and sp.investigation = o.investigation
           and sp.victim = n.participant_version
           and ot.crime_against = 'Society'
           and o.offense = ot.sid
           and o.priority = r.sid
           and r.code <> 'N'
           and n.last_name <> 'SOCIETY'
           and ot.code not in('0000A2', '0000A3', '0000A5');

        if v_count > 0 then                                                 -- if any present, error
            p_complete := 0;
            p_msg := 'Victim other than society present.';
        else               -- if all offenses against society list society as victim, check complete
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_society: ' || sqlerrm);
            raise;
    end dibrs_society;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_recover_date(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select count(*)
          into v_count
          from t_osi_f_inv_incident_map fi,
               t_osi_f_inv_incident i,
               t_osi_f_inv_spec s,
               t_osi_f_inv_property p,
               t_dibrs_property_loss_by_type pt
         where fi.investigation = p_parent
           and fi.investigation = s.investigation
           and s.sid = p.specification
           and fi.incident = i.sid
           and pt.code = '5'
           and p.prop_loss_by = pt.sid(+)
           and trunc(p.action_date) < trunc(i.start_date);

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Property recovered on date is earlier than the incident date.';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_recover_date: ' || sqlerrm);
            raise;
    end dibrs_recover_date;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_specification(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count      number        := 0;
        v_complete   number        := 0;
        v_message    varchar2(200) := 'Not Applicable';
        v_category   varchar2(2)   := null;
    begin
        for a in (select distinct pv.sid as pv_sid
                             from t_osi_partic_involvement pi, t_osi_participant_version pv
                            where pv.sid = pi.participant_version
                              and pi.obj = p_parent
                              and pi.involvement_role =
                                      (select sid
                                         from t_osi_partic_role_type
                                        where usage = 'SUBJECT'
                                          and role = 'Subject'
                                          and obj_type = core_obj.lookup_objtype('FILE.INV')))
        loop
            if    not v_complete = 1
               or v_complete is null then
                for b in (select incident, offense
                            from t_osi_f_inv_spec
                           where investigation = p_parent and subject = a.pv_sid)
                loop
                    if    not v_category = 'AA'
                       or v_category is null then
                        select max(decode(b.offense,
                                          '0000A6', 'AJ',
                                          '093---', 'AA',
                                          '094-A1', 'AA',
                                          '094-A2', 'AA',
                                          '094-A3', 'AA',
                                          '094-A4', 'AA',
                                          '094-B1', 'AA',
                                          '094-B2', 'AA',
                                          '094-B3', 'AA',
                                          '095-A-', 'AA',
                                          '095-B-', 'AA',
                                          '095-C-', 'AA',
                                          '095-D1', 'AA',
                                          '095-D2', 'AA',
                                          '096-A-', 'AA',
                                          '096-B1', 'AA',
                                          '096-B2', 'AA',
                                          '106---', 'AA',
                                          '106-A-', 'AA',
                                          '110-A-', 'AA',
                                          '110-B-', 'AA',
                                          '111-A1', 'AA',
                                          '111-A2', 'AA',
                                          '111-B1', 'AA',
                                          '111-B2', 'AA',
                                          '112---', 'AA',
                                          '116-A-', 'AA',
                                          '116-B-', 'AA',
                                          '123AA1', 'AA',
                                          '123AA2', 'AA',
                                          '123AB-', 'AA',
                                          '125-C-', 'AA',
                                          '131-A-', 'AA',
                                          '131-B-', 'AA',
                                          '133-B-', 'AA',
                                          '134-B1', 'AA',
                                          '134-B2', 'AA',
                                          '134-F1', 'AA',
                                          '134-G5', 'AA',
                                          '134-G6', 'AA',
                                          '134-J0', 'AA',
                                          '134-J1', 'AA',
                                          '134-J2', 'AA',
                                          '134-J3', 'AA',
                                          '134-J4', 'AA',
                                          '134-J5', 'AA',
                                          '134-J6', 'AA',
                                          '134-J7', 'AA',
                                          '134-J8', 'AA',
                                          '134-J9', 'AA',
                                          '134-M1', 'AA',
                                          '134-O1', 'AA',
                                          '134-R2', 'AA',
                                          '134-R3', 'AA',
                                          '134-R4', 'AA',
                                          '134-U1', 'AA',
                                          '134-U2', 'AA',
                                          '134-U3', 'AA',
                                          '134-U6', 'AA',
                                          '134-U7', 'AA',
                                          '134-U8', 'AA',
                                          '134-V2', 'AA',
                                          'AC'))
                          into v_category
                          from dual;
                    end if;
                end loop;

                if v_category = 'AA' then
                    select count(incident)
                      into v_count
                      from t_osi_f_inv_spec
                     where investigation = p_parent and subject = a.pv_sid;

                    if v_count = 0 then
                        v_complete := 0;
                        v_message := 'No offenses found in specifications.';
                    else
                        v_complete := 1;
                        v_message := 'Offenses found in specifications.';
                    end if;
                else
                    v_complete := 1;
                    v_message := null;
                end if;
            end if;
        end loop;

        p_msg := v_message;
        p_complete := v_complete;
    exception
        when others then
            log_error('dibrs_specification: ' || sqlerrm);
            raise;
    end dibrs_specification;

/*=============================================================================================*/
/*  Verify the maximum offender age.                                                           */
/*=============================================================================================*/
    procedure dibrs_max_offage(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_age           number  := 0;
        v_participant   number  := 0;
        v_count         number  := 0;
        v_subyear       boolean := false;
    begin
        select count(*)
          into v_participant
          from t_osi_f_inv_spec sp, v_osi_participant_version pv, t_core_obj o, t_core_obj_type ot
         where sp.investigation = p_parent
           and sp.subject = pv.sid
           and pv.participant = o.sid
           and o.obj_type = ot.sid
           and ot.code = 'PART.INDIV';

        if v_participant = 0 then
            p_complete := null;
            p_msg := 'No Individual Offender Present';
            return;
        end if;

        for a in (select pv.dob as birth_date
                    from t_osi_f_inv_spec sp, v_osi_participant_version pv, t_osi_participant p
                   where sp.investigation = p_parent
                     and sp.subject = pv.sid
                     and pv.participant = p.current_version)
        loop
            if a.birth_date is not null then
                if to_char(trunc(a.birth_date), 'MM') = to_char(trunc(sysdate), 'MM') then
                    if to_char(trunc(a.birth_date), 'DD') - to_char(trunc(sysdate), 'DD') > 0 then
                        v_subyear := true;
                    end if;
                elsif to_char(trunc(a.birth_date), 'MM') > to_char(trunc(sysdate), 'MM') then
                    v_subyear := true;
                end if;

                if v_subyear = true then
                    v_age := to_char(trunc(sysdate), 'YYYY') - to_char(trunc(a.birth_date), 'YYYY');
                    v_age := v_age - 1;
                else
                    v_age := to_char(trunc(sysdate), 'YYYY') - to_char(trunc(a.birth_date), 'YYYY');
                end if;

                if v_age > 98 then
                    v_count := v_count + 1;
                end if;
            end if;
        end loop;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Age value over 98 (Warning)';
        else
            p_complete := 1;
            p_msg := 'No age values over 98.';
        end if;
    exception
        when others then
            log_error('dibrs_max_offage: ' || sqlerrm);
            raise;
    end dibrs_max_offage;

/*=============================================================================================*/
/*  This procedure verifies that the associate activities are all closed.                      */
/*=============================================================================================*/
    procedure assocact_closed(p_parent in varchar2, p_complete out number, p_msg out clob) is
         v_message   clob;
         v_ids       clob;
         v_count     number;
    begin
         v_message := 'DEFAULT';                                                 ---initial value---
         v_count := 0;

         ---Loop through all associated activities for the given file---
         for n in (select act.close_date, act.id, act.title as activity, act.sid
                     from t_osi_file fc, t_osi_activity act, t_osi_assoc_fle_act afa
                    where fc.sid = p_parent and act.sid = afa.activity_sid and fc.sid = afa.file_sid)
         loop
             v_message := 'Associated Activities Found';

             --- LOOK FOR OPEN ASSOCIATED ACTIVITIES ---
             if n.close_date is null then
             
               v_count := v_count + 1;
               v_ids := v_ids || '<a href="javascript:getObjURL(''' || n.sid || ''');">' || n.id || '</a>, ';

             end if;

         end loop;

         if v_message = 'DEFAULT' then
 
           p_complete := null;
           p_msg := 'No Associated Activities';
  
         else
  
           if v_count > 0 then
  
             p_complete := 0;
             p_msg := 'The Following Associated Activities are NOT Closed:<br>' || substr(v_ids, 1, length(v_ids) - 2);
    
           else
    
             p_complete := 1;
             p_msg := 'All Associated Activities are closed.';

           end if;

         end if;

    exception
         when others then
             log_error('assocact_closed: ' || sqlerrm);
             raise;
    end assocact_closed;

/*=============================================================================================*/
/*  Verify mission area.                                                                       */
/*=============================================================================================*/
    procedure inv_mission_area(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select count(*)
          into v_count
          from t_osi_f_investigation
         where sid = p_parent and manage_by is not null;

        if v_count = 0 then
            p_complete := 0;
            p_msg := 'Missing Mission Area';
        else
            p_complete := 1;
            p_msg := 'Mission Area Verified';
        end if;
    exception
        when others then
            log_error('inv_mission_area: ' || sqlerrm);
            raise;
    end inv_mission_area;

/*=============================================================================================*/
/*  Check status of evidence disposal.                                                         */
/*=============================================================================================*/
    procedure evidence_disp(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := 0;
    begin
        select count(*)
          into v_count
          from v_osi_evidence e
         where e.status_code <> 'D' and e.obj in(select activity_sid
                                                   from t_osi_assoc_fle_act
                                                  where file_sid = p_parent);

        if v_count = 0 then
            p_complete := 1;
            p_msg := 'All evidence has not been disposed of.';
        else
            p_complete := 0;
            p_msg := 'All evidence has been disposed.';
        end if;
    exception
        when others then
            log_error('evidence_disp: ' || sqlerrm);
            raise;
    end evidence_disp;

/*=============================================================================================*/
/* Confirm user privilage to approve offense 134-Z2 Investigations.                            */
/*=============================================================================================*/
    procedure inv_approve_134z2(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_personnel   varchar2(20);
        v_unit        varchar2(20);
        v_count       number       := 0;
    begin
        select count(*) into v_count
          from t_osi_f_inv_offense o, t_dibrs_offense_type ot
         where o.investigation = p_parent and o.offense = ot.sid and ot.code = '134-Z2';

        if v_count = 0 then

          p_msg := 'No Offenses with Code: 134-Z2 exist.';
          p_complete := null;
          return;

        end if;

        v_personnel := core_context.personnel_sid;
        v_unit := osi_personnel.get_current_unit(v_personnel);

        p_msg := osi_auth.check_for_priv('APP_134_Z2', core_obj.get_objtype(p_parent), v_personnel, v_unit);

        if p_msg = 'Y' then

          p_complete := 1;
          p_msg := 'Current user can Approve Offense 134-Z2 Investigations.';

        else

          p_complete := 0;
          p_msg := 'Current user can not Approve Offense 134-Z2 Investigations.';

        end if;

    exception
        when others then
            log_error('inv_approve_134Z2: ' || sqlerrm);
            raise;
    end inv_approve_134z2;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure current_pv_links(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        l_msg      clob           := null;
        l_name     varchar2(1000) := null;
        l_pos      number;
        l_pv_sid   varchar2(50);
        l_yr_ago   date           := sysdate - 365;
    begin
        p_complete := 1;

        for i in (select activity_sid
                    from t_osi_assoc_fle_act
                   where file_sid = p_parent and modify_on > l_yr_ago)
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
                    select v.sid
                      into l_pv_sid
                      from t_osi_participant_version v, t_osi_participant p
                     where v.participant = j.participant
                       and v.participant = p.sid
                       and v.sid = p.current_version;
                exception
                    when no_data_found then
                        l_pv_sid := null;
                end;

                if l_pv_sid <> j.participant_version then
                    p_complete := 0;

                    if l_pv_sid is not null then
                        l_name := osi_object.get_tagline_link(l_pv_sid) || '<br>';
                    else
                        l_name := osi_object.get_tagline_link(j.participant_version) || '<br>';
                    end if;

                    l_msg := add_name_to_message(l_msg, l_name);
                end if;
            end loop;
        end loop;

        for m in (select pv.participant, f.participant_version
                    from v_osi_partic_file_involvement f,
                         t_osi_participant ip,
                         t_osi_participant_version pv
                   where f.file_sid = p_parent
                     and f.participant_version = pv.sid
                     and pv.participant = ip.sid)
        loop
            begin
                select v.sid
                  into l_pv_sid
                  from t_osi_participant_version v, t_osi_participant p
                 where v.participant = m.participant
                   and v.participant = p.sid
                   and p.current_version = v.sid;
            exception
                when no_data_found then
                    l_pv_sid := null;
            end;

            if l_pv_sid <> m.participant_version then
                p_complete := 0;

                if l_pv_sid is not null then
                    l_name := osi_object.get_tagline_link(l_pv_sid) || '<br>';
                else
                    l_name := osi_object.get_tagline_link(m.participant_version) || '<br>';
                end if;

                l_msg := add_name_to_message(l_msg, l_name);
            end if;
        end loop;

        if p_complete > 0 then
            p_msg := null;
        else
            p_msg := substr(l_msg, 1, length(l_msg) - 2);
        end if;
    exception
        when others then
            log_error('current_pv_links: ' || sqlerrm);
            raise;
    end current_pv_links;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure deers_update_on_indivs(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_deers_date   date;
        v_rtn          clob          := null;
        v_pv_sid       varchar2(30)  := null;
        v_name         varchar2(300) := null;
        v_pos          number;
        v_yr_ago       date          := sysdate - 365;
    begin
        p_complete := 1;

        -- get activities related to the case
        for i in (select tfc.activity_sid
                    from t_osi_assoc_fle_act tfc, t_osi_activity ta
                   where tfc.file_sid = p_parent
                     and ta.sid = tfc.activity_sid
                     and (   ta.complete_date is null
                          or ta.complete_date > to_date('03-OCT-2007', 'DD-MON-YYYY'))
                     and tfc.modify_on > v_yr_ago)
        loop
            for j in (select pv.participant, z.participant_version
                        from v_osi_partic_act_involvement z,
                             t_osi_participant ip,
                             t_osi_participant_version pv,
                             t_core_obj o,
                             t_core_obj_type ot
                       where z.activity = i.activity_sid
                         and z.participant_version = pv.sid
                         and pv.participant = ip.sid
                         and pv.participant = o.sid
                         and o.obj_type = ot.sid
                         and ot.code = 'PART.INDIV')
            loop
                begin
                    select ph.deers_date, pv.sid
                      into v_deers_date, v_pv_sid
                      from t_osi_participant_version pv,
                           t_osi_participant p,
                           t_osi_participant_human ph
                     where pv.participant = j.participant
                       and pv.participant = p.sid
                       and pv.sid = ph.sid
                       and p.current_version = pv.sid;
                exception
                    when no_data_found then
                        v_deers_date := null;
                        v_pv_sid := null;
                end;

                if    v_deers_date is null
                   or v_deers_date < sysdate - 183 then
                    p_complete := 0;
                    v_name := osi_object.get_tagline_link(v_pv_sid);
                    v_rtn := add_name_to_message(v_rtn, v_name);
                end if;
            end loop;
        end loop;

        --GET ALL INDIVIDUALS ASSIGNED TO THIS CASE
        for m in (select pv.participant, f.participant_version
                    from v_osi_partic_file_involvement f,
                         t_osi_participant ip,
                         t_osi_participant_version pv,
                         t_core_obj o,
                         t_core_obj_type ot
                   where f.file_sid = p_parent
                     and f.participant_version = pv.sid
                     and pv.participant = ip.sid
                     and pv.participant = o.sid
                     and o.obj_type = ot.sid
                     and ot.code = 'PART.INDIV')
        loop
            begin
                select ph.deers_date, pv.sid
                  into v_deers_date, v_pv_sid
                  from t_osi_participant_version pv, t_osi_participant p,
                       t_osi_participant_human ph
                 where pv.participant = m.participant
                   and pv.participant = p.sid
                   and pv.sid = ph.sid
                   and p.current_version = pv.sid;
            exception
                when no_data_found then
                    v_deers_date := null;
                    v_pv_sid := null;
            end;

            if    v_deers_date is null
               or v_deers_date < sysdate - 183 then
                p_complete := 0;
                v_name := osi_object.get_tagline_link(v_pv_sid);
                v_rtn := add_name_to_message(v_rtn, v_name);
            end if;
        end loop;

        if p_complete > 0 then
            p_msg := null;
        else
            p_msg := v_rtn;
        end if;
    exception
        when others then
            log_error('deers_update_on_indivs: ' || sqlerrm);
            raise;
    end deers_update_on_indivs;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure curtailed_content_note(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_112_count       number := 0;
        v_content_count   number := 0;
    begin
        select count(*)
          into v_112_count
          from t_dibrs_offense_type ot, t_osi_f_inv_offense o
         where o.investigation = p_parent and o.offense = ot.sid and ot.code like '112%';

        if v_112_count > 0 then
            select count(*)
              into v_content_count
              from t_osi_note n, t_osi_note_type nt
             where n.obj = p_parent
               and n.note_type = nt.sid
               and nt.description = 'Curtailed Content Report Note';

            if v_content_count = 0 then
                p_complete := 0;
                p_msg := 'Curtailed Content Report Note not found, but may be required.';
            else
                p_complete := 1;
                p_msg := 'Curtailed Content Report Note found.';
            end if;
        else
            p_complete := null;
            p_msg := 'No Offense Codes 112*, no Curtailed Content Report Note needed.';
        end if;
    exception
        when others then
            log_error('curtailed_content_note: ' || sqlerrm);
            raise;
    end curtailed_content_note;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_injury_type(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number;
        v_cnt1   number;
        v_cnt2   number;
    begin
        --This is checking to see if we have specifications that are in need of Injury Types
        --If there are none, it is returning null so the checklist knows to grey it out

        --DIBRS ERR# 568 references dibrs_common.inj_allowed function
        --inj allowed for these offenses ('13A', '13B', '100', '11A', '11B','11C', '11D', '120', '210')
        select count(s.offense)
          into v_cnt
          from t_osi_f_inv_spec s, t_dibrs_offense_type o
         where s.investigation = p_parent
           and s.offense = o.sid
           and o.nibrs_code in('13A', '13B', '100', '11A', '11B', '11C', '11D', '120', '210');

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Injury offense';
            return;                                                                      -- get out
        end if;

        --Loop through offenses that MUST have an injury type. Error #719  must be Individuals to have injury
        --DIBRS ERR# 568 references dibrs_common.inj_allowed function
        --inj allowed for these offenses ('13A', '13B', '100', '11A', '11B','11C', '11D', '120', '210')
        for k in (select s.sid
                    from t_osi_f_inv_spec s, t_osi_participant_human h, t_dibrs_offense_type o
                   where s.investigation = p_parent
                     and s.subject = h.sid
                     and s.offense = o.sid
                     and o.nibrs_code in
                                     ('13A', '13B', '100', '11A', '11B', '11C', '11D', '120', '210'))
        loop
            --Check to see if we have an injury for each of these offenses
            select count(specification)
              into v_cnt
              from t_osi_f_inv_spec_vic_injury
             where specification = k.sid;

            --if no injury exists, fail this checklist item right away and return.
            if (v_cnt = 0) then
                p_complete := 0;
                p_msg := 'Offense ID requires a Injury Type';
                return;
            end if;
        end loop;

        --These offenses must also have an Injury Type (This is handled in the code above)
        --The injury types must have a code of M or N, and nothing else
        -- DIBRS ERR# 718
        for k in (select s.sid
                    from t_osi_f_inv_spec s, t_dibrs_offense_type o
                   where s.investigation = p_parent and s.offense = o.sid and o.nibrs_code = '13B')
        loop
            --Check to see if we have the correct injury for each of these offenses
            select count(specification)
              into v_cnt
              from t_osi_f_inv_spec_vic_injury i, t_dibrs_reference r
             where specification = k.sid and i.injury_type = r.sid(+) and r.code not in('M', 'N');

            if (v_cnt > 0) then
                --This means an injury type of something OTHER than M or N has been found, so fail this checklist item
                p_complete := 0;
                p_msg := 'Offense ID requires a Injury Type of "Apparent Minor Injury" or "None"';
                return;
            end if;
        end loop;

        --Error # 717 These offenses must also have an Injury Type (This is handled in the code above)
              --Injury type code of N must stand alone; No other codes can be included with N= (NONE)
        for k in (select s.sid
                    from t_osi_f_inv_spec s, t_dibrs_offense_type o
                   where s.investigation = p_parent
                     and s.offense = o.sid
                     and o.nibrs_code in
                                     ('13A', '13B', '100', '11A', '11B', '11C', '11D', '120', '210'))
        loop
            --Check to see if we have the correct injury for each of these offenses
            select count(specification)
              into v_cnt1
              from t_osi_f_inv_spec_vic_injury i, t_dibrs_reference r
             where specification = k.sid and i.injury_type = r.sid(+) and r.code = 'N';

            select count(specification)
              into v_cnt2
              from t_osi_f_inv_spec_vic_injury
             where specification = k.sid;

            if v_cnt1 = 1 and v_cnt1 <> v_cnt2 then
                --This means an injury type of something NONE has been found with other injury type(s), so fail this checklist item
                p_complete := 0;
                p_msg := 'Offense ID requires Injury Type of N to stand alone';
                return;
            end if;
        end loop;

        --No problems, return OK
        p_complete := 1;
        p_msg := null;
    exception
        when others then
            log_error('dibrs_injury_type: ' || sqlerrm);
            raise;
    end dibrs_injury_type;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_logical_property(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
        a_cnt   number;
    begin
        --Check to see if there are any offenses which require property segements.
        -- If not, check is null
        select count(*)
          into v_cnt
          from t_dibrs_offense_type ot, t_osi_f_inv_spec sp, t_osi_f_inv_offense o
         where sp.investigation = p_parent
           and sp.offense = ot.sid
           and sp.investigation = o.investigation
           and o.offense = ot.sid
           and ot.property_applies = 'Y';

        -- if no property applies, null check
        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Check Required';
            return;                                                                      -- get out
        end if;

        /* -- Make checks against property descriptions based on offenses for
        -- incidents.  First, determine the total number of offenses for
        -- the current incident which allow reporting of property segments
        -- and which are not in the list which must be checked.  If this
        -- quantity is greater than zero, meaning that some offense allowing
        -- reporting of property but not on the list to be checked exists
        -- for the incident (and therefore that any property description
        -- is legal) then the following edits are bypassed.
        select count(*)
          into a_cnt
          from t_dibrs_offense_type ot,
               t_osi_f_inv_spec sp,
               t_osi_f_inv_offense o,
               t_osi_reference r
         where sp.investigation = p_parent
           and sp.offense = ot.SID
           and sp.investigation = o.investigation
           and o.priority = r.SID
           and o.offense = ot.SID
           and r.code <> 'N'
           and ot.property_applies = 'Y'
           and ot.nibrs_code not in
                              ('220', '240', '23A', '23B', '23C', '23D', '23E', '23F', '23G', '23H');

        -- If the number of offenses which allow property segments and which
        -- are NOT in the offenses listed in the WHERE clause of the above
        -- query is zero, the rest of the logical checks must be made.*/

        --reset ctr so we dont throw errors for offenses like 35A with prop desc of 10 (Drugs)
        v_cnt := 0;

        -- if a_cnt = 0 then
        for a in (select pt.code as prop_type, ot.nibrs_code
                    from t_dibrs_offense_type ot,
                         t_osi_f_inv_spec sp,
                         t_osi_f_inv_offense o,
                         t_osi_f_inv_property p,
                         t_dibrs_property_type pt,
                         t_osi_reference r
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and sp.investigation = o.investigation
                     and p.specification = sp.sid
                     and p.prop_type = pt.sid
                     and o.offense = ot.sid
                     and o.priority = r.sid
                     and r.code <> 'N'
                     and ot.nibrs_code is not null)
        loop
            -- Codes "03" (Automobiles), "05" (Buses), "24" (Other Motor
            -- Vehicles), "28" (Recreational Vehicles), and "37" (Trucks)
            -- cannot be present for offenses 23A, 23B, 23C, 23D, 23E,
            -- 23F, 23G, and 23H.
            if a.prop_type in('03', '05', '24', '28', '37') then
                select count(*)
                  into a_cnt
                  from t_dibrs_offense_type ot,
                       t_osi_f_inv_spec sp,
                       t_osi_f_inv_offense o,
                       t_osi_reference r
                 where sp.investigation = p_parent
                   and sp.offense = ot.sid
                   and sp.investigation = o.investigation
                   and o.priority = r.sid
                   and o.offense = ot.sid
                   and r.code <> 'N'
                   and ot.property_applies = 'Y'
                   and ot.nibrs_code in('23A', '23B', '23C', '23D', '23E', '23F', '23G', '23H');

                if a_cnt > 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- Code "04" (Bicycles) cannot be present for offenses
            -- 23A, and 23B
            elsif a.prop_type = '04' then
                select count(*)
                  into a_cnt
                  from t_dibrs_offense_type ot,
                       t_osi_f_inv_spec sp,
                       t_osi_f_inv_offense o,
                       t_osi_reference r
                 where sp.investigation = p_parent
                   and sp.offense = ot.sid
                   and sp.investigation = o.investigation
                   and o.priority = r.sid
                   and o.offense = ot.sid
                   and r.code <> 'N'
                   and ot.property_applies = 'Y'
                   and ot.nibrs_code in('23A', '23B');

                if a_cnt > 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- Codes "01" (Aircraft), "12" (Farm Equipment), "15" (Heavy
            -- Construction/Industrial Equipment), "18" (Livestock), and
            -- "39" (Watercraft) cannot be present for offenses 23A, 23B,
            -- and 23C
            elsif a.prop_type in('01', '12', '15', '18', '39') then
                select count(*)
                  into a_cnt
                  from t_dibrs_offense_type ot,
                       t_osi_f_inv_spec sp,
                       t_osi_f_inv_offense o,
                       t_osi_reference r
                 where sp.investigation = p_parent
                   and sp.offense = ot.sid
                   and sp.investigation = o.investigation
                   and o.priority = r.sid
                   and o.offense = ot.sid
                   and r.code <> 'N'
                   and ot.property_applies = 'Y'
                   and ot.nibrs_code in('23A', '23B', '23C', '23G');

                if a_cnt > 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- Codes "29" (Structures-Single Occupancy Dwelling), "30"
               -- (Structures-Other Dwellings), "31" (Structures-Commercial/
               -- Business), "32" (Structures-Industrial/Manufacturing), "33"
               -- (Structures-Public/Community), "34" (Structures-Storage),
               -- and "35" (Structures-Other) cannot be present for offenses
               -- 220, 240, 23A, 23B, 23C, 23D, 23E, 23F, and 23G
            elsif a.prop_type in('29', '30', '31', '32', '33', '34', '35') then
                select count(*)
                  into a_cnt
                  from t_dibrs_offense_type ot,
                       t_osi_f_inv_spec sp,
                       t_osi_f_inv_offense o,
                       t_osi_reference r
                 where sp.investigation = p_parent
                   and sp.offense = ot.sid
                   and sp.investigation = o.investigation
                   and o.priority = r.sid
                   and o.offense = ot.sid
                   and r.code <> 'N'
                   and ot.property_applies = 'Y'
                   and ot.nibrs_code in
                                     ('220', '240', '23A', '23B', '23C', '23D', '23E', '23F', '23G');

                if a_cnt > 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- Error 687
            -- If Offense is 240 - Motor Vehicle theft and Property Loss by is 7, one Property Description must be
            -- 03 - Automobiles, 05 - Buses, 24 - Other Motor Vehicles, 28 - Recreational Vehicles, or 37 - Trucks,
            elsif a.nibrs_code = '240' then
                select count(*)
                  into a_cnt
                  from t_dibrs_offense_type ot,
                       t_dibrs_property_loss_by_type pl,
                       t_osi_f_inv_spec sp,
                       t_osi_f_inv_offense o,
                       t_osi_f_inv_property p,
                       t_osi_reference r
                 where sp.investigation = p_parent
                   and sp.offense = ot.sid
                   and sp.investigation = o.investigation
                   and pl.sid = p.prop_loss_by
                   and o.priority = r.sid
                   and o.offense = ot.sid
                   and r.code <> 'N'
                   and ot.property_applies = 'Y'
                   and pl.report_as = (select sid
                                         from t_dibrs_property_loss_by_type
                                        where code = '7')
                   and p.prop_type in('03', '05', '24', '28', '37');

                if a_cnt > 0 then
                    v_cnt := v_cnt + 1;
                end if;
            end if;
        end loop;

        -- end if;
        if v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Missing Logical Property for Specified Offense(s)';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_logical_property: ' || sqlerrm);
            raise;
    end dibrs_logical_property;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_prop_loss(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number := 0;
        a_cnt   number;
    begin
        for a in (select ot.nibrs_code, dr.code as off_result, ot.code as offense_code
                    from t_dibrs_offense_type ot,
                         t_osi_f_inv_spec sp,
                         t_osi_f_inv_offense o,
                         t_osi_reference r,
                         t_dibrs_reference dr
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and sp.investigation = o.investigation
                     and o.offense = ot.sid
                     and o.priority = r.sid
                     and sp.off_result = dr.sid
                     and r.code <> 'N'
                     and ot.nibrs_code is not null
                     and sp.off_result is not null)
        loop
            a_cnt := 0;

            -- DIBRS ERROR #656
            if a.nibrs_code = '200' then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as = (select sid
                                             from t_dibrs_property_loss_by_type
                                            where code = '2');
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #657
            elsif a.nibrs_code = '510' then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '5', '7', '8'));
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #657
            elsif a.nibrs_code = '220' then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '5', '7', '8'));
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #658
            elsif a.nibrs_code = '250' then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('3', '5', '6'));
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #659
            elsif a.nibrs_code = '290' then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as = (select sid
                                             from t_dibrs_property_loss_by_type
                                            where code = '4');
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #660
            elsif a.nibrs_code in('35A', '35B') then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '6'));
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #661
            elsif(    a.nibrs_code in
                          ('23A', '23B', '23C', '23D', '23E', '23F', '23G', '23H', '26A', '26B',
                           '26C', '26D', '26E', '120', '210', '240', '270')
                  and (a.offense_code not in('083-A-', '083-B-'))) then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('5', '7'));
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #662
            elsif a.nibrs_code in('39A', '39B', '39C', '39D') then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as = (select sid
                                             from t_dibrs_property_loss_by_type
                                            where code = '6');
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- 100 Offenses requiring property.
            -- DIBRS ERROR #657
            elsif a.nibrs_code in('100') then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '5', '7', '8'));
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            -- DIBRS ERROR #663
            elsif a.nibrs_code = '280' then
                if a.off_result = 'A' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '8'));
                elsif a.off_result = 'C' then
                    select count(*)
                      into a_cnt
                      from t_osi_f_inv_property p,
                           t_dibrs_property_loss_by_type pl,
                           t_osi_f_inv_spec s
                     where s.investigation = p_parent
                       and p.specification = s.sid
                       and pl.sid = p.prop_loss_by
                       and pl.report_as in(select sid
                                             from t_dibrs_property_loss_by_type
                                            where code in('1', '5'));
                end if;

                if a_cnt = 0 then
                    v_cnt := v_cnt + 1;
                end if;
            end if;
        end loop;

        if v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Missing Property Loss Type ';
        else
            p_complete := 1;
            p_msg := 'Property Loss Type OK';
        end if;
    exception
        when others then
            log_error('dibrs_prop_loss: ' || sqlerrm);
            raise;
    end dibrs_prop_loss;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_prop_suspdrg(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number := 0;
        a_cnt    number;
        v_recs   number := 0;
    begin
        for a in (select o.sid, sp.sid as spec_sid
                    from t_dibrs_offense_type ot,
                         t_osi_f_inv_spec sp,
                         t_osi_f_inv_offense o,
                         t_osi_reference r
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and sp.investigation = o.investigation
                     and o.offense = ot.sid
                     and o.priority = r.sid
                     and r.code <> 'N'
                     and ot.nibrs_code is not null
                     and ot.nibrs_code = '35A')
        loop
            v_recs := v_recs + 1;

            select count(*)
              into a_cnt
              from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec s
             where s.investigation = p_parent
               and p.specification = s.sid
               and pl.sid = p.prop_loss_by
               and p.specification = a.spec_sid
               and pl.report_as = (select sid
                                     from t_dibrs_property_loss_by_type
                                    where code = '1')
               and p.drug_type is null
               and not exists(
                       select 1
                         from t_osi_f_inv_property p,
                              t_dibrs_property_loss_by_type pl,
                              t_osi_f_inv_spec s,
                              t_dibrs_property_type pt
                        where s.investigation = p_parent
                          and p.specification = s.sid
                          and p.prop_loss_by = pl.sid
                          and p.prop_type = pt.sid
                          and pl.report_as = (select sid
                                                from t_dibrs_property_loss_by_type
                                               where code = '6')
                          and pt.code = '10'
                          and p.specification = a.spec_sid);

            if a_cnt > 0 then
                v_cnt := v_cnt + 1;
            end if;

            select count(*)
              into a_cnt
              from t_osi_f_inv_property p,
                   t_dibrs_property_loss_by_type pl,
                   t_osi_f_inv_spec s,
                   t_dibrs_property_type pt
             where s.investigation = p_parent
               and p.specification = s.sid
               and p.prop_loss_by = pl.code
               and p.prop_type = pt.sid
               and pl.report_as = (select sid
                                     from t_dibrs_property_loss_by_type
                                    where code = '6')
               and pt.code = '10'
               and p.drug_type is null;

            if a_cnt > 0 then
                v_cnt := v_cnt + 1;
            end if;
        end loop;

        if v_recs = 0 then                                                -- no 35A offenses present
            p_complete := null;
            p_msg := 'None';
        elsif v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Missing Suspected Drug Type ';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_prop_suspdrg: ' || sqlerrm);
            raise;
    end dibrs_prop_suspdrg;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_drg_measure_qnty(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number := 0;
    begin
        --Check for offenses related to specification which allow for a property record.
        select count(*)
          into v_cnt
          from t_osi_f_inv_spec s, t_dibrs_offense_type ot
         where s.investigation = p_parent and s.offense = ot.sid and ot.property_applies = 'Y';

        if v_cnt = 0 then   --No offenses in specification which allow for property records, exit OK
            p_complete := null;
            p_msg := 'No offenses present which allow for property records.';
            return;
        end if;

        --reinitialize the variable
        v_cnt := 0;

        for a in (select p.prop_quantity, (select code
                                             from t_dibrs_reference x
                                            where x.sid = p.drug_measure) as drug_measure, r.code,
                         r.description
                    from t_osi_f_inv_property p, t_osi_f_inv_spec s, t_dibrs_reference r
                   where s.investigation = p_parent
                     and p.specification = s.sid
                     and p.drug_type = r.sid
                     and p.drug_type is not null)
        loop
            -- Error 629 - if drug measure is NP (number of plants), drug code must be
            -- E (marijuana), G (opium), or K (other hallucinogens)
            if a.drug_measure = 'NP' then
                if a.code not in('E', 'G', 'K') then
                    v_cnt := v_cnt + 1;
                    p_msg :=
                        'The drug, ' || a.description
                        || ', can not be used with a drug measure of (number of plants)';
                elsif     a.code in('E', 'G', 'K')
                      and (   a.prop_quantity < 1
                           or instr(a.prop_quantity, '.') > 0) then
                    v_cnt := v_cnt + 1;
                    p_msg := 'Number of plants reported must be a whole number greater than one.';
                    p_complete := 0;
                    return;
                end if;
            end if;

            -- Error 627 - if drug code is present, quantity and measure are required
            if a.code is not null then
                if (   a.prop_quantity <= 0
                    or a.prop_quantity is null
                    or a.drug_measure is null) then
                    v_cnt := v_cnt + 1;
                    p_msg := 'Quantity must be greater than zero.';
                end if;
            end if;
        end loop;

        if v_cnt > 0 then                                                   -- if errors are present
            p_complete := 0;
            return;
        else                                                                             --No errors
            p_complete := 1;
            return;
        end if;
    exception
        when others then
            log_error('dibrs_org_measure_qnty: ' || sqlerrm);
            raise;
    end dibrs_drg_measure_qnty;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure disposition_type(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        p_complete := 1;
        p_msg := null;
    exception
        when others then
            log_error('disposition_type: ' || sqlerrm);
            raise;
    end disposition_type;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_stolen_recv_vehic(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cnt    number;
        v_loss   number := null;
        v_recv   number := null;
    begin
        for a in (select prop_quantity, lbt.code as code_prop_loss_by
                    from t_osi_f_inv_property p,
                         t_osi_f_inv_spec s,
                         t_dibrs_property_loss_by_type lbt,
                         t_dibrs_property_type pt
                   where s.investigation = p_parent
                     and p.specification = s.sid
                     and lbt.sid = p.prop_loss_by
                     and p.prop_type = pt.sid
                     and pt.code = '03')
        loop
            -- MAKE SURE PROP_QUANTITY OF PROP_LOSS_BY '5' (RECOVERED) IS <= THAN PROP_QUANTITY OF PROP_LOSS_BY '7' (STOLEN)
            if a.code_prop_loss_by = '5' then
                v_recv := a.prop_quantity;
            elsif a.code_prop_loss_by = '7' then
                v_loss := a.prop_quantity;
            end if;
        end loop;

        if v_loss is null then
            -- NO RECORDS PRESENT
            p_complete := null;
            p_msg := 'No Stolen vehicles';
            return;
        elsif v_loss < v_recv then
            p_complete := 0;
            p_msg :=
                'Number of vehicles recovered must be equal to or less than number of vehicles stolen.';
        else
            p_complete := 1;
        end if;
    exception
        when others then
            log_error('dibrs_stolen_recv_vehic: ' || sqlerrm);
            raise;
    end dibrs_stolen_recv_vehic;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_off_on_usi(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := null;
    begin
        select count(sid)
          into v_count
          from t_osi_f_inv_spec
         where investigation = p_parent;

        if v_count = 0 then
            p_complete := null;
            p_msg := 'No Specifications.';
            return;                                                                      -- get out
        end if;

        select count(sid)
          into v_count
          from t_osi_f_inv_spec
         where nvl(off_on_usi, 'U') not in('Y', 'N') and investigation = p_parent;

        if (v_count > 0) then
            --- The checkbox has not been Checked/Unchecked ---
            p_complete := 0;
            p_msg := 'On Uniformed Service Installation Must have Yes or No Selected.';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('inv_off_on_usi: ' || sqlerrm);
            raise;
    end inv_off_on_usi;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure have_assocact(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        --LOOK AT ALL ASSOCIATED ACTIVITIES
        select count(*)
          into v_cnt
          from t_osi_assoc_fle_act
         where file_sid = p_parent;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No Associated Activities';
        end if;
    exception
        when others then
            log_error('have_assocact: ' || sqlerrm);
            raise;
    end have_assocact;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_spec_jurisdiction(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cnt    number;
        v_cnt2   number;
    begin
        -- 2/22/2008 Updated for the use of the Stat_basis in the incident table.
               --CHECK incident tab Jurisdictions all must have a value
        select count(*)
          into v_cnt
          from t_osi_f_inv_incident_map fi, t_osi_f_inv_incident i
         where fi.investigation = p_parent and fi.incident = i.sid and i.stat_basis is null;

        if v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Missing Incident Jurisdiction';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_spec_jurisdiction: ' || sqlerrm);
            raise;
    end dibrs_spec_jurisdiction;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_property_value(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
        a_cnt   number;
    begin
        -- Check for property records associated with this case
        select count(*)
          into v_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s
         where s.investigation = p_parent and p.specification = s.sid;

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Property';
            return;                                                                      -- get out
        end if;

    --Check to see if we have any property values over 1M
-- this check is just a warning, and is covered by verify_DIBRS_max_value
    /*select count(*)
      into v_cnt
      from T_PROPERTY P
     where P.FYLE = pParent
       and P.PROP_VALUE > 1000000;*/

        --If prop type is '88', then value must be '1' (unknown)
        select count(*)
          into v_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s, t_dibrs_property_type pt
         where s.investigation = p_parent
           and p.specification = s.sid
           and p.prop_type = pt.sid
           and pt.code = '88'
           and (   p.prop_value is null
                or p.prop_value <> 1);

        --Prop value for recovered property cannot be greater than prop value for stolen property
        select count(*)
          into a_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s, t_dibrs_property_loss_by_type lbt
         where s.investigation = p_parent
           and p.specification = s.sid
           and p.prop_loss_by = lbt.sid
           and lbt.code = '5'
           and exists(
                   select 'x'
                     from t_osi_f_inv_property,
                          t_osi_f_inv_spec s,
                          t_dibrs_property_loss_by_type lbt
                    where s.investigation = p_parent
                      and specification = s.sid
                      and prop_loss_by = lbt.sid
                      and prop_type = p.prop_type
                      and lbt.code = '7'
                      and prop_value < p.prop_value);

        if a_cnt > 0 then
            v_cnt := v_cnt + 1;
        end if;

        --If prop type is '09' or '22', then value must be 0
        select count(*)
          into a_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s, t_dibrs_property_type pt
         where s.investigation = p_parent
           and p.specification = s.sid
           and p.prop_type = pt.sid
           and pt.code in('09', '22')
           and p.prop_value > 0;

        if a_cnt > 0 then
            v_cnt := v_cnt + 1;
        end if;

        --Property Value cannot be 0 for the specified Property Description
        --However 35A offense w/Prop Type 10 can have blank property value
        select count(*)
          into a_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s, t_dibrs_property_type pt
         where s.investigation = p_parent
           and p.specification = s.sid
           and p.prop_type = pt.sid
           and pt.code not in('09', '22', '77', '99')
           and p.prop_value = 0
           and not exists(
                   select 'x'
                     from t_osi_f_inv_spec sp,
                          t_osi_f_inv_offense o,
                          t_dibrs_offense_type ot,
                          t_osi_f_inv_property pr,
                          t_dibrs_property_type pt,
                          t_osi_reference r
                    where sp.investigation = p_parent
                      and sp.offense = ot.sid
                      and sp.investigation = o.investigation
                      and pr.specification = sp.sid
                      and pr.sid = p.sid
                      and o.offense = ot.sid
                      and pr.prop_type = pt.sid
                      and o.priority = r.sid
                      and r.code <> 'N'
                      and ot.nibrs_code = '35A'
                      and pt.code = '10');

        if a_cnt > 0 then
            v_cnt := v_cnt + 1;
        end if;

        if v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Invalid Property Value for specified Description/Loss By';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('dibrs_property_value: ' || sqlerrm);
            raise;
    end dibrs_property_value;

/*=============================================================================================*/
/*
/*=============================================================================================*/
    procedure dibrs_nodupdrugcode(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        c_temp   varchar2(6000);
        t_temp   varchar2(6000);
        q_temp   varchar2(6000);
        r_temp   varchar2(6000);
        v_cnt    number;
        v_ctr    number;
        a_cnt    number;
    -- not in use at this time, see below code comments
    -- sub_measure   Varchar(4) := null; -- var created to hold the drug measure
    begin
        v_cnt := 0;

        select count(*)
          into v_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s
         where p.specification = s.sid and s.investigation = p_parent and specification is null;

        if (v_cnt > 0) then
            p_complete := 0;
            p_msg := 'Missing property record information.';
            return;
        end if;

        --9/20/06 Addition
        for a in (select distinct (s.incident)
                             from t_osi_f_inv_incident_map fi,
                                  t_osi_f_inv_spec s,
                                  t_dibrs_offense_type ot
                            where s.investigation = p_parent
                              and fi.incident = s.incident
                              and s.offense = ot.sid
                              and ot.property_applies = 'Y')
        loop
            select count(*)
              into a_cnt
              from t_osi_f_inv_property p, t_osi_f_inv_spec s
             where s.incident = a.incident and p.specification = s.sid;

            if (a_cnt = 0) then
                p_complete := 0;
                p_msg := 'Missing property record in incident where offense requires property.';
                return;
            end if;
        end loop;

        --Haven't found any issues so we can exit OK
        p_complete := 1;
        p_msg := null;
    exception
        when others then
            log_error('dibrs_nodupdrugcode: ' || sqlerrm);
            raise;
    end dibrs_nodupdrugcode;

/*=============================================================================================*/
/*                                                                                                                                  */
/*=============================================================================================*/
    procedure dibrs_drg_equip(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number := 0;
        v_cnt2   number := 0;
        a_cnt    number;
    begin
        for a in (select ot.nibrs_code, sp.off_result, sp.sid
                    from t_osi_f_inv_spec sp,
                         t_dibrs_offense_type ot,
                         t_osi_f_inv_offense o,
                         t_osi_reference r
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and sp.investigation = o.investigation
                     and o.offense = ot.sid
                     and o.priority = r.sid
                     and r.code <> 'N'
                     and ot.nibrs_code is not null
                     and ot.nibrs_code in('35A', '35B'))
        loop
            v_cnt2 := v_cnt2 + 1;

            -- check for drug equipment with completed drug offense Error 672
            select count(*)
              into a_cnt
              from t_osi_f_inv_property p,
                   t_osi_f_inv_spec s,
                   t_dibrs_property_type t,
                   t_dibrs_reference r
             where s.investigation = p_parent
               and s.sid = p.specification
               and a.sid = p.specification
               and p.prop_type = t.sid
               and t.code = '11'
               and a.nibrs_code = '35A'
               and a.off_result = r.sid;

            if a_cnt > 0 then
                v_cnt := v_cnt + 1;
            end if;

            --check for drugs with any drug equipment offense Error 673
            select count(*)
              into a_cnt
              from t_osi_f_inv_property p, t_osi_f_inv_spec s, t_dibrs_property_type pt
             where s.investigation = p_parent
               and s.sid = p.specification
               and p.prop_type = pt.sid
               and pt.code = '10'
               and a.nibrs_code = '35B'
               and a.sid = p.specification;

            if a_cnt > 0 then
                v_cnt := v_cnt + 1;
            end if;
        end loop;

        if v_cnt2 = 0 then
            -- No drug related offenses
            p_complete := null;
            p_msg := 'None';
        elsif v_cnt > 0 then
            -- there are errors
            p_complete := 0;
            p_msg := 'Incorrect combination of drug equipment and offenses';
        else                                                                           --no problems
            p_complete := 1;
        end if;
    exception
        when others then
            log_error('dibrs_drg_equip: ' || sqlerrm);
            raise;
    end dibrs_drg_equip;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_premises_entry(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number;
        v_cnt2   number := 0;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_inv_spec sp, t_dibrs_offense_type ot, t_osi_f_inv_offense o
         where sp.investigation = p_parent
           and sp.offense = ot.sid
           and sp.investigation = o.investigation
           and o.offense = ot.sid
           and o.priority <> (select sid
                                from t_osi_reference
                               where usage = 'OFFENSE_PRIORITY' and code = 'N')
           and ot.nibrs_code is not null
           and ot.nibrs_code = '220';

        if v_cnt = 0 then
            p_complete := null;                                                    --not applicable
            p_msg := 'Not applicable';
            return;                                                                      -- get out
        end if;

        for a in (select sp.num_prem_entered, (select r.code
                                                 from t_dibrs_reference r
                                                where r.sid = sp.entry_method) as entry_method,
                         lt.code
                    from t_osi_f_inv_spec sp,
                         t_dibrs_offense_type ot,
                         t_osi_f_inv_offense o,
                         t_dibrs_offense_location_type lt
                   where sp.investigation = p_parent
                     and sp.offense = ot.sid
                     and sp.investigation = o.investigation
                     and o.offense = ot.sid
                     and sp.off_loc = lt.sid
                     and o.priority <> (select sid
                                          from t_osi_reference
                                         where usage = 'OFFENSE_PRIORITY' and code = 'N')
                     and ot.nibrs_code is not null
                     and ot.nibrs_code = '220')
        loop
            if a.entry_method is null then
                v_cnt2 := v_cnt2 + 1;
            elsif a.code in('14', '19') and(   a.num_prem_entered is null
                                            or a.num_prem_entered = 0) then
                v_cnt2 := v_cnt2 + 1;
            end if;
        end loop;

        if v_cnt2 = 0 then
            p_complete := 1;
            p_msg := null;
            return;                                                                      -- get out
        else
            p_complete := 0;
            p_msg := 'Must Have Premises Entered/Method of Entry';
        end if;

        return;
    exception
        when others then
            log_error('dibrs_premises_entry: ' || sqlerrm);
            raise;
    end dibrs_premises_entry;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_aahc_require(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt       number        := 0;
        v_cnt2      number        := 0;
        v_offn      boolean       := false;
        v_offense   varchar2(500) := null;
    begin
        for c in (select distinct (s.victim), o.description as offense
                             from t_osi_f_inv_spec s, t_dibrs_offense_type o
                            where s.investigation = p_parent
                              and s.offense = o.sid
                              and o.nibrs_code in('13A', '09A', '09B', '09C'))
        loop
            v_offn := true;
            v_offense := c.offense;

            --DIBRS ERROR# 721
            select count(distinct(sac.aah))
              into v_cnt
              from t_osi_f_inv_spec s,
                   t_osi_f_inv_spec_aah sac,
                   t_dibrs_circmstance_aah_type cat,
                   t_dibrs_offense_type o
             where s.investigation = p_parent
               and s.sid = sac.specification
               and s.victim = c.victim
               and s.offense = o.sid
               and o.nibrs_code in('13A', '09A', '09B', '09C')
               --filter invalid codes (these codes currently don't apply to above offenses anyways)
               and cat.code not in('90', '91', '92', '93');

            if    v_cnt < 1
               or v_cnt > 2 then
                --v_cnt2 := v_cnt2 + 1; --Too few or many AAH listings for this victim
                p_complete := 0;
                p_msg :=
                    'This Offense ' || v_offense
                    || ' requires at least 1 Aggravated Assault/Homicide Circumstances value, but no more than '
                    || ' 2 Aggravated Assault/Homicide Circumstances values';
                return;                                                                  -- get out
            end if;

            v_cnt := 0;

            --DIBRS ERROR# 728
            select count(s.offense)
              into v_cnt
              from t_osi_f_inv_spec s,
                   t_osi_f_inv_spec_aah sac,
                   t_dibrs_circmstance_aah_type cat,
                   t_dibrs_offense_type o
             where s.investigation = p_parent
               and s.sid = sac.specification
               and not exists(select 'x'
                                from t_osi_f_inv_spec_ajh sjc
                               where sjc.specification = s.sid)
               and s.victim = c.victim
               and sac.aah = cat.sid
               and cat.code in('21', '22')
               and s.offense = o.sid
               and o.nibrs_code in('09C');

            if v_cnt > 0 then
                --v_cnt2 := v_cnt2 + 1;
                --Must have an AJH for victims with a spec with an AAH of 21 or 22
                p_complete := 0;
                p_msg :=
                    'This Offense ' || v_offense
                    || ' with an Aggravated Assault/Homicide Circumstances value of '
                    || '(Criminal Killed by Private Citizen or Criminal Killed by Police Officer) '
                    || 'requires an Additional Justifiable Homicide Circumstances value.';
                return;
            end if;
        end loop;

        if v_offn = false then
            p_complete := null;
            p_msg := 'No Aggravated Assault/Homicide Circumstances apply for these Offenses';
            return;                                                                      -- get out
        end if;

        p_complete := 1;
        p_msg := null;
    exception
        when others then
            log_error('dibrs_aahc_require: ' || sqlerrm);
            raise;
    end dibrs_aahc_require;

/*=============================================================================================*/
/*                                                                                            */
/*=============================================================================================*/
    procedure dibrs_valid_aahc_codes(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cmplt   number        := null;
        v_msg     varchar2(500) := 'Not applicable';
        v_cnt     number        := 0;
    begin
        p_complete := null;
        p_msg := 'Not applicable.';

-- check for multiple AAHC codes when one of them is 10-Unknown
        for a in (select s.sid
                    from t_osi_f_inv_spec s,
                         t_osi_f_inv_spec_aah sa,
                         t_dibrs_circmstance_aah_type cat
                   where s.investigation = p_parent
                     and sa.specification = s.sid
                     and sa.aah = cat.sid
                     and cat.code = '10')
        loop
            select count(*)
              into v_cnt
              from t_osi_f_inv_spec_aah
             where specification = a.sid;

            if v_cnt > 0 then
                p_complete := 1;
                p_msg := null;
            else
                p_complete := 0;
                p_msg := 'More than one circumstance along with code 10-Unknown.';
                return;
            end if;
        end loop;

-- check for multiple offenses and/or victims when the AAHC code is 08-Other Felony Involved
        for b in (select s.sid, s.subject
                    from t_osi_f_inv_spec s,
                         t_osi_f_inv_spec_aah sa,
                         t_dibrs_circmstance_aah_type cat
                   where s.investigation = p_parent
                     and sa.specification = s.sid
                     and sa.aah = cat.sid
                     and cat.code = '08')
        loop
            select count(distinct victim)
              into v_cnt
              from t_osi_f_inv_spec
             where investigation = p_parent and subject = b.subject;

            if v_cnt > 1 then
                p_complete := 1;
                p_msg := null;
            else
                select count(distinct offense)
                  into v_cnt
                  from t_osi_f_inv_spec
                 where investigation = p_parent and subject = b.subject;

                if v_cnt > 1 then
                    p_complete := 1;
                    p_msg := null;
                else
                    p_complete := 0;
                    p_msg :=
                        'Not enough offenses/victims with AAHC code '
                        || '08-Other Felony Involved.';
                    return;
                end if;
            end if;
        end loop;
    exception
        when others then
            log_error('dibrs_valid_aahc_codes: ' || sqlerrm);
            raise;
    end dibrs_valid_aahc_codes;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_proper_aahc_codes(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_cmplt   number        := null;
        v_msg     varchar2(500) := 'Not applicable';
        v_cnt     number        := 0;
    begin
        p_complete := null;
        p_msg := 'Not applicable';

        -- check for 20 or 21 AAHC code for Justifiable Homicide
        for a in (select s.sid
                    from t_osi_f_inv_spec s, t_dibrs_offense_type ot
                   where s.investigation = p_parent and s.offense = ot.sid and ot.code = '0000A4')
        -- Justifiable Homicide
        loop
            select count(*)
              into v_cnt
              from t_osi_f_inv_spec_aah
             where specification = a.sid;

            if v_cnt = 0 then
                p_complete := 0;
                p_msg := 'Not a proper AAHC code for Justifiable Homicide';
                return;
            else
                for w in (select code as aah_code
                            from t_osi_f_inv_spec_aah sa, t_dibrs_circmstance_aah_type t
                           where sa.specification = a.sid and sa.aah = t.sid)
                loop
                    if    w.aah_code = '20'
                       or w.aah_code = '21' then
                        p_complete := 1;
                        p_msg := null;
                    else
                        p_complete := 0;
                        p_msg := 'Not a proper AAHC code for Justifiable Homicide';
                        return;
                    end if;
                end loop;
            end if;
        end loop;

        -- check for AAHC of 01 - 06, 08 - 10 for Offenses with NIBRS_CODE of 13A
        -- DIBRS ERROR# 727
        for b in (select s.sid
                    from t_osi_f_inv_spec s, t_dibrs_offense_type ot
                   where s.investigation = p_parent and s.offense = ot.sid and ot.nibrs_code = '13A')
        loop
            select count(*)
              into v_cnt
              from t_osi_f_inv_spec_aah
             where specification = b.sid;

            if v_cnt = 0 then
                p_complete := 0;
                p_msg := 'Not a proper AAHC code for offense "13A"';
                return;
            else
                for x in (select code as aah_code
                            from t_osi_f_inv_spec_aah sa, t_dibrs_circmstance_aah_type t
                           where sa.specification = b.sid and sa.aah = t.sid)
                loop
                    if    x.aah_code = '01'
                       or x.aah_code = '02'
                       or x.aah_code = '03'
                       or x.aah_code = '04'
                       or x.aah_code = '05'
                       or x.aah_code = '06'
                       or x.aah_code = '08'
                       or x.aah_code = '09'
                       or x.aah_code = '10' then
                        p_complete := 1;
                        p_msg := null;
                    else
                        p_complete := 0;
                        p_msg := 'Not proper AAHC code for offense "13A"';
                        return;
                    end if;
                end loop;
            end if;
        end loop;

        -- check for AAHC of 01 - 10 for Offenses with NIBRS_CODE of 09A
        -- DIBRS ERROR# 744
        for c in (select s.sid
                    from t_osi_f_inv_spec s, t_dibrs_offense_type ot
                   where s.investigation = p_parent and s.offense = ot.sid and ot.nibrs_code = '09A')
        loop
            select count(*)
              into v_cnt
              from t_osi_f_inv_spec_aah
             where specification = c.sid;

            if v_cnt = 0 then
                p_complete := 0;
                p_msg := 'Not a proper AAHC code for offense "09A"';
                return;
            else
                for y in (select code as aah_code
                            from t_osi_f_inv_spec_aah sa, t_dibrs_circmstance_aah_type t
                           where sa.specification = c.sid and sa.aah = t.sid)
                loop
                    if    y.aah_code = '01'
                       or y.aah_code = '02'
                       or y.aah_code = '03'
                       or y.aah_code = '04'
                       or y.aah_code = '05'
                       or y.aah_code = '06'
                       or y.aah_code = '07'
                       or y.aah_code = '08'
                       or y.aah_code = '09'
                       or y.aah_code = '10' then
                        p_complete := 1;
                        p_msg := null;
                    else
                        p_complete := 0;
                        p_msg := 'Not a proper AAHC code for offense "09A"';
                        return;
                    end if;
                end loop;
            end if;
        end loop;

        -- check for AAHC of 30 - 34 for Offenses with NIBRS_CODE of 09B
        -- DIBRS ERROR# 745
        for d in (select s.sid
                    from t_osi_f_inv_spec s, t_dibrs_offense_type ot
                   where s.investigation = p_parent and s.offense = ot.sid and ot.nibrs_code = '09B')
        loop
            select count(*)
              into v_cnt
              from t_osi_f_inv_spec_aah
             where specification = d.sid;

            if v_cnt = 0 then
                p_complete := 0;
                p_msg := 'Not a proper AAHC code for offense "09B"';
                return;
            else
                for z in (select code as aah_code
                            from t_osi_f_inv_spec_aah sa, t_dibrs_circmstance_aah_type t
                           where sa.specification = d.sid and sa.aah = t.sid)
                loop
                    if    z.aah_code = '31'
                       or z.aah_code = '32'
                       or z.aah_code = '33'
                       or z.aah_code = '34'
                       or z.aah_code = '30' then
                        p_complete := 1;
                        p_msg := null;
                    else
                        p_complete := 0;
                        p_msg := 'Not a proper AAHC code for offense "09B"';
                        return;
                    end if;
                end loop;
            end if;
        end loop;
    exception
        when others then
            log_error('dibrs_proper_aahc_codes: ' || sqlerrm);
            raise;
    end dibrs_proper_aahc_codes;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_dispo_off_result(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_inv_subj_disposition d, t_osi_f_inv_subj_disp_offense do
         where d.investigation = p_parent
           and do.disposition = d.sid
           and (   do.result is null
                or do.result = '');

        if v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Disposition Subject Offense(s) Missing Results.';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('inv_dispo_off_result: ' || sqlerrm);
            raise;
    end inv_dispo_off_result;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure per_reservist_set(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number          := 0;
        v_ids   varchar2(32000);
    begin
        for j in (select ph.sid as participant_version
                    from t_osi_partic_involvement pi, t_osi_participant_human ph
                   where pi.obj = p_parent
                     and pi.participant_version = ph.sid
                     and pi.involvement_role in(select sid
                                                  from t_osi_partic_role_type
                                                 where usage in('SUBJECT', 'VICTIM'))
                     and nvl(ph.sa_reservist, 'U') not in('Y', 'N'))
        loop
            v_cnt := v_cnt + 1;
            v_ids := v_ids || '<br>' || osi_object.get_tagline_link(j.participant_version);
        end loop;

        if v_cnt = 0 then
            p_complete := 1;
            p_msg := 'All Subjects and Victims have Yes or No selected for Reservist Affiliation.';
        else
            p_complete := 0;
            p_msg :=
                'The following Subjects/Victims do not have Yes or No selected for Reservist Affiliation: <br>'
                || v_ids;
        end if;
    exception
        when others then
            log_error('per_reservist_set: ' || sqlerrm);
            raise;
    end per_reservist_set;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_arfc_not_null(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := null;
    begin
        select count(*)
          into v_count
          from t_osi_f_investigation
         where sid = p_parent and nvl(afrc, 'U') not in('Y', 'N');

        if v_count > 0 then
            --- The checkbox has not been Checked/Unchecked ---
            p_complete := 0;
            p_msg := 'Associated to AFRC Must be Yes or No.';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('inv_arfc_not_null: ' || sqlerrm);
            raise;
    end inv_arfc_not_null;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
/*    procedure dibrs_ir_ucmj_date(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        p_complete := 1;
        p_msg := null;
    exception
        when others then
            log_error('dibrs_ir_ucmj_date: ' || sqlerrm);
            raise;
    end dibrs_ir_ucmj_date;
*/
/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure dibrs_subject_rel(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        p_complete := 1;
        p_msg := null;
    exception
        when others then
            log_error('dibrs_subject_rel: ' || sqlerrm);
            raise;
    end dibrs_subject_rel;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_all_sub_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number;
        v_cnt2   number;
    begin
        select count(*)
          into v_cnt
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_parent and o.obj_type = ot.sid and ot.code = 'FILE.INV.CASE';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'Subject specifications only apply to CASE files.';
            return;
        end if;

        select count(distinct pi.participant_version)
          into v_cnt
          from t_osi_partic_involvement pi, t_osi_partic_role_type prt
         where pi.obj = p_parent and pi.involvement_role = prt.sid and prt.role = 'Subject';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Subjects for investigation';
            return;
        end if;

        select count(distinct s.subject)
          into v_cnt2
          from t_osi_f_inv_spec s
         where s.investigation = p_parent;

        if v_cnt = v_cnt2 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Subject not covered by specification';
        end if;
    exception
        when others then
            log_error('inv_all_sub_covered: ' || sqlerrm);
            raise;
    end inv_all_sub_covered;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_property_item(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_inv_offense o, t_dibrs_offense_type ot
         where o.investigation = p_parent and ot.sid = o.offense and ot.nibrs_code = '35A';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No drug offense';
            return;                                                                      -- get out
        end if;

        select count(*)
          into v_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s
         where p.specification = s.sid and s.investigation = p_parent;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No Property Item entered';
        end if;
    exception
        when others then
            log_error('inv_property_item: ' || sqlerrm);
            raise;
    end inv_property_item;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_complaint_form(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_sid   varchar2(20);
    begin
        select sid
          into v_sid
          from t_osi_attachment_type
         where (usage = 'REPORT' and code = 'CR') and obj_type = core_obj.get_objtype(p_parent);

        attachment_exists(p_parent, v_sid, p_complete, p_msg, 'DB');
    exception
        when others then
            log_error('inv_complaint_form: ' || sqlerrm);
            raise;
    end inv_complaint_form;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_roi(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_sid   varchar2(20);
    begin
        select sid
          into v_sid
          from t_osi_attachment_type
         where (usage = 'REPORT' and code = 'ROIFP') and obj_type = core_obj.get_objtype(p_parent);

        attachment_exists(p_parent, v_sid, p_complete, p_msg, 'DB');
    exception
        when others then
            log_error('inv_roi: ' || sqlerrm);
            raise;
    end inv_roi;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_have_subject(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        participant_role_exists(p_parent, 'Subject', p_complete, p_msg);
    exception
        when others then
            log_error('inv_have_subject: ' || sqlerrm);
            raise;
    end inv_have_subject;

    procedure inv_contract_disclosure(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    
      v_cnt number;
      
    begin
         select count(*) into v_cnt from t_osi_mission m,t_osi_mission_category c 
           where m.OBJ=p_parent
             and m.MISSION=c.sid
             and code='CD';    
         
         if v_cnt = 0 then
           
           p_complete := null;
           p_msg := 'Contract Disclosure Special Interest Area not checked.';
            
         else

           select count(*) into v_cnt from t_osi_partic_involvement i,t_osi_partic_role_type t 
             where i.obj=p_parent
               and t.sid=i.INVOLVEMENT_ROLE
               and t.USAGE='OTHER AGENCIES'
               and i.AGENCY_FILE_NUM is not null;    

           if v_cnt > 0 then

             p_complete := 1;
             p_msg := null;

           else

             p_complete := 0;
             p_msg := 'Other Agency with Agency File Number Required when Special Interest Area "Contract Disclosure" is checked.';

           end if;

         end if;
          
    exception
        when others then
            log_error('inv_contract_disclosure: ' || sqlerrm);
            raise;
    end inv_contract_disclosure;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_have_prim_offense(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_inv_offense io, t_osi_reference r
         where io.priority = r.sid
           and io.investigation = p_parent
           and r.code = 'P'
           and r.usage = 'OFFENSE_PRIORITY';

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No Primary Offense for file';
        end if;
    exception
        when others then
            log_error('inv_have_prim_offense: ' || sqlerrm);
            raise;
    end inv_have_prim_offense;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_have_incident(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_inv_incident_map
         where investigation = p_parent;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No Incident for file';
        end if;
    exception
        when others then
            log_error('inv_have_incident: ' || sqlerrm);
            raise;
    end inv_have_incident;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_all_vic_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number;
        v_cnt2   number;
    begin
        select count(*)
          into v_cnt
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_parent and o.obj_type = ot.sid and ot.code = 'FILE.INV.CASE';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'Victim specifications only apply to CASE files.';
            return;
        end if;

        select count(distinct pi.participant_version)
          into v_cnt
          from t_osi_partic_involvement pi, t_osi_partic_role_type pr
         where pi.obj = p_parent and pi.involvement_role = pr.sid and pr.role = 'Victim';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Victims for investigation';
            return;
        end if;

        select count(distinct s.victim)
          into v_cnt2
          from t_osi_f_inv_spec s
         where s.investigation = p_parent;

        if v_cnt = v_cnt2 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Victim not covered by specification';
        end if;
    exception
        when others then
            log_error('inv_all_vic_covered: ' || sqlerrm);
            raise;
    end inv_all_vic_covered;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_all_off_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number;
        v_cnt2   number;
    begin
        select count(*)
          into v_cnt
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_parent and o.obj_type = ot.sid and ot.code = 'FILE.INV.CASE';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'Offense specifications only apply to CASE files.';
            return;
        end if;

        select count(distinct offense_code)
          into v_cnt
          from t_osi_f_inv_offense io, t_osi_f_offense_category oc, t_dibrs_offense_type ot
         where io.offense = ot.sid and ot.sid = oc.offense and investigation = p_parent;

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Offenses for investigation';
            return;
        end if;

        select count(distinct offense)
          into v_cnt2
          from t_osi_f_inv_spec
         where investigation = p_parent;

        if v_cnt = v_cnt2 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Offense not covered by specification';
        end if;
    exception
        when others then
            log_error('inv_all_off_covered: ' || sqlerrm);
            raise;
    end inv_all_off_covered;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_all_inc_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number;
        v_cnt2   number;
    begin
        select count(*)
          into v_cnt
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_parent and o.obj_type = ot.sid and ot.code = 'FILE.INV.CASE';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'Incident specifications only apply to CASE files.';
            return;
        end if;

        select count(distinct incident)
          into v_cnt
          from t_osi_f_inv_incident_map
         where investigation = p_parent;

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Incidents for investigation';
            return;
        end if;

        select count(distinct incident)
          into v_cnt2
          from t_osi_f_inv_spec
         where investigation = p_parent;

        if v_cnt = v_cnt2 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Incident not covered by specification';
        end if;
    exception
        when others then
            log_error('inv_all_inc_covered: ' || sqlerrm);
            raise;
    end inv_all_inc_covered;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_dispo_case(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_parent and o.obj_type = ot.sid and ot.code = 'FILE.INV.CASE';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'Dispositions only apply to CASE Investigations';
            return;
        end if;

        select count(*)
          into v_cnt
          from t_osi_f_inv_disposition d
         where d.investigation = p_parent;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No investigative disposition';
        end if;
    exception
        when others then
            log_error('inv_dispo_case: ' || sqlerrm);
            raise;
    end inv_dispo_case;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_dispo_incident(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_parent and o.obj_type = ot.sid and ot.code = 'FILE.INV.CASE';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'Dispositions only apply to CASE Investigations';
            return;
        end if;

        select count(*)
          into v_cnt
          from t_osi_f_inv_incident_map
         where investigation = p_parent;

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Incident for file';
            return;                                                                      -- get out
        end if;

        select count(*)
          into v_cnt
          from t_osi_f_inv_incident i, t_osi_f_inv_incident_map im
         where i.sid = im.incident and im.investigation = p_parent and i.clearance_reason is null;

        if v_cnt = 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Missing incident disposition';
        end if;
    exception
        when others then
            log_error('inv_dispo_incident: ' || sqlerrm);
            raise;
    end inv_dispo_incident;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_have_victim(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        participant_role_exists(p_parent, 'Victim', p_complete, p_msg);
    exception
        when others then
            log_error('inv_have_victim: ' || sqlerrm);
            raise;
    end inv_have_victim;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_have_referral(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        participant_role_exists(p_parent, 'Referred for Action', p_complete, p_msg);
    exception
        when others then
            log_error('inv_have_referral: ' || sqlerrm);
            raise;
    end inv_have_referral;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_drug_identified(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_inv_offense o, t_dibrs_offense_type ot
         where o.investigation = p_parent and ot.sid = o.offense and ot.nibrs_code = '35A';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No drug offense';
            return;                                                                      -- get out
        end if;

        select count(*)
          into v_cnt
          from t_osi_f_inv_property p, t_osi_f_inv_spec s
         where p.specification = s.sid and s.investigation = p_parent and p.drug_type is not null;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'No drug identified';
        end if;
    exception
        when others then
            log_error('inv_drug_identified: ' || sqlerrm);
            raise;
    end inv_drug_identified;

/*=============================================================================================*/
/*                                                                                             */
/*=============================================================================================*/
    procedure inv_dispo_spec(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_core_obj co, t_core_obj_type cot
         where co.sid = p_parent and co.obj_type = cot.sid and cot.code = 'FILE.INV.CASE';

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'Dispositions only apply to CASE Investigations';
            return;
        end if;

        select count(*)
          into v_cnt
          from t_osi_f_inv_spec
         where investigation = p_parent;

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Specification for file';
            return;                                                                      -- get out
        end if;
    exception
        when others then
            log_error('inv_dispo_spec: ' || sqlerrm);
            raise;
    end inv_dispo_spec;

    function aapp_file_is_type(p_parent in varchar2, p_aapp_category in varchar2)
        return boolean is
    begin
         ----------------------------------------
         ---- Category Types:                 ---
         ----------------------------------------
         --- Civilian Agent     = 'CAGENT'    ---
         --- Civilian Pro Staff = 'CPROSTAFF' ---
         --- Enlisted Agent     = 'EAGENT'    ---
         --- Military Pro Staff = 'MPROSTAFF' ---
         --- Officer Agent      = 'OAGENT'    ---
         --- Reserve Agent      = 'RAGENT'    ---
         --- Reserve Pro Staff  = 'RPROSTAFF' ---
         ----------------------------------------
    
        for k in (select sid
                    from t_osi_f_aapp_file
                   where category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', p_aapp_category)
                     and sid = p_parent)
        loop
            return true;
        end loop;

        return false;
    exception
        when others then
            log_error('checklist_pkg.aapp_file_is_for_type: ' || sqlerrm);
            raise;
    end aapp_file_is_type;

    function aapp_file_is_support(p_parent in varchar2)
        return boolean is
    begin
        --Agent Only, no support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'MPROSTAFF')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'CPROSTAFF')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RPROSTAFF'))
                     and sid = p_parent)
        loop
            return true;
        end loop;

        return false;
    exception
        when others then
            log_error('checklist_pkg.aapp_file_is_support: ' || sqlerrm);
            raise;
    end aapp_file_is_support;

    function aapp_file_is_agent(p_parent in varchar2)
        return boolean is
    begin
        --- Agent Only ---
        for k in (select sid
                    from t_osi_f_aapp_file
                   where (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'EAGENT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'OAGENT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'CAGENT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGENT'))
                     and sid = p_parent)
        loop
            return true;
        end loop;

        return false;
    exception
        when others then
            log_error('checklist_pkg.aapp_file_is_active_or_reserve: ' || sqlerrm);
            raise;
    end aapp_file_is_agent;

    function aapp_file_is_active_or_reserve(p_parent in varchar2)
        return boolean is
    begin
        --- Reservist Only ---
        for k in (select sid
                    from t_osi_f_aapp_file
                   where (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGENT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'EAGENT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'OAGENT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RPROSTAFF'))
                     and sid = p_parent)
        loop
            return true;
        end loop;

        return false;
    exception
        when others then
            log_error('checklist_pkg.aapp_file_is_reservist: ' || sqlerrm);
            raise;
    end aapp_file_is_active_or_reserve;

    function aapp_file_is_reservist(p_parent in varchar2)
        return boolean is
    begin
        --- Reservist Only ---
        for k in (select sid
                    from t_osi_f_aapp_file
                   where (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGENT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RPROSTAFF'))
                     and sid = p_parent)
        loop
            return true;
        end loop;

        return false;
    exception
        when others then
            log_error('checklist_pkg.aapp_file_is_reservist: ' || sqlerrm);
            raise;
    end aapp_file_is_reservist;

    function aapp_subject_is_military(p_parent in varchar2)
        return boolean is
        v_partic_version   t_osi_participant_version.participant%type;
        v_temp             varchar2(200);
    begin
        --Get Participant
        begin
            select participant_version
              into v_partic_version
              from t_osi_partic_involvement
             where obj = p_parent
               and involvement_role =
                       osi_participant.get_inv_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                        'SUBJECT',
                                                        'SUBJECT');
        exception
            when no_data_found then
                --If person does not exist (which should never happen) we will return true as true is the most restrictive.
                return true;
        end;

        select sa_component
          into v_temp
          from t_osi_participant_human
         where sid = v_partic_version;

        if (   v_temp <> null
            or length(v_temp) > 0) then
            return true;
        else
            return false;
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_subject_is_military: ' || sqlerrm);
            return false;                            --Least restrictive, but shouldn't be an issue
    --if you see an error in the CORE_LOGGER output, see the above comment;
    end aapp_subject_is_military;

    function aapp_subject_is_enlisted(p_parent in varchar2)
        return boolean is
        v_partic_version   t_osi_participant_version.participant%type;
        v_temp             varchar2(200);
    begin
        --Get Participant
        begin
            select participant_version
              into v_partic_version
              from t_osi_partic_involvement
             where obj = p_parent
               and involvement_role =
                       osi_participant.get_inv_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                        'SUBJECT',
                                                        'SUBJECT');
        exception
            when no_data_found then
                --If person does not exist (which should never happen) we will return false as false is the most restrictive.
                return false;
        end;

        select sa_pay_plan
          into v_temp
          from t_osi_person_chars
         where sid = v_partic_version
           and sa_pay_plan = dibrs_reference.lookup_ref_sid('PAY_PLAN', 'EM');

        if (   v_temp <> null
            or length(v_temp) > 0) then
            return true;
        else
            return false;
        end if;
    exception
        when no_data_found then  --Most likely means that the person has payplan and is not enlisted
            return false;
        when others then
            return false;                            --Least restrictive, but shouldn't be an issue
    end aapp_subject_is_enlisted;

    
    

    
/*AAPP (110 File): AF FM 422. */
procedure aapp_doa_AF_422(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Active Duty and Reserve ---
     if (aapp_subject_is_military(p_parent)) or (aapp_file_is_active_or_reserve(p_parent)) then
       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'AF_422'),p_complete,p_msg,null);
     end if;

exception
     when others then
         log_error('osi_checklist.aapp_doa_AF_422: ' || sqlerrm);
         raise;

end aapp_doa_AF_422;

/*AAPP (110 File): AF IMT 686 Document attached. */
procedure aapp_imt_686(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'IMT_686'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_imt_686: ' || sqlerrm);
         raise;
end aapp_imt_686;
    
/*AAPP (110 File): AFOSI Form 61, AFOSI Applicant Questionnaire Document attached. */
procedure aapp_doa_AFOSIFORM61(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'AFOSIFORM61'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_doa_AFOSIFORM61: ' || sqlerrm);
         raise;

end aapp_doa_AFOSIFORM61;

/*AAPP (110 File): AFOSI Form 65, AFOSI Agent Applicant Writing Sample Instructions & Writing Sample Document attached. */
procedure aapp_doa_AFOSIFORM65(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Agent Only ---
     if (aapp_file_is_agent(p_parent)) then

       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'AFOSIFORM65'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_doa_AFOSIFORM65: ' || sqlerrm);
         raise;

end aapp_doa_AFOSIFORM65;

/*AAPP (110 File): AFOSI Form 79, AFOSI Applicant Eligibility Worksheet Document attached. */
procedure aapp_doa_AFOSIFORM79(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'AFOSIFORM79'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_doa_AFOSIFORM79: ' || sqlerrm);
         raise;

end aapp_doa_AFOSIFORM79;

/*AAPP (110 File): AFOSI Form 84, Realities of the AFOSI Profession Document attached. */
procedure aapp_doa_AFOSIFORM84(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'AFOSIFORM84'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_doa_AFOSIFORM84: ' || sqlerrm);
         raise;

end aapp_doa_AFOSIFORM84;

/*AAPP (110 File): AFOSI Form 87, Authorization for Release of Informaiton Document attached. */
procedure aapp_doa_AFOSIFORM87(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'AFOSIFORM87'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_doa_AFOSIFORM87: ' || sqlerrm);
         raise;

end aapp_doa_AFOSIFORM87;

/*AAPP (110 File): BPS documents attached. */
procedure aapp_unit_bps(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Enlisted and Reserve Agents Only ---
     if (aapp_file_is_type(p_parent,'EAGENT') or aapp_file_is_type(p_parent,'RAGENT')) then

       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'BPS'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_unit_bps: ' || sqlerrm);
         raise;

end aapp_unit_bps;

/*AAPP (110 File): Cognitive Testing Results attached. */
procedure aapp_doa_shipley(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Agent Only --
     if (aapp_file_is_agent(p_parent)) then

       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'SHIPLEY'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_doa_shipley: ' || sqlerrm);
         raise;

end aapp_doa_shipley;

/*AAPP (110 File): Credit Report documents attached. */
procedure aapp_doa_cr(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'CR'),p_complete,p_msg,null);

exception

     when others then
         log_error('osi_checklist.aapp_doa_cr: ' || sqlerrm);
         raise;

end aapp_doa_cr;

/*AAPP (110 File): DCII documents attached. */
procedure aapp_unit_dcii(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'DCII'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_unit_dcii: ' || sqlerrm);
         raise;

end aapp_unit_dcii;

/*AAPP (110 File): DD2760 documents attached. */
procedure aapp_doa_dd2760(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants Except for Military and Civilian Prostaff ---
     if (aapp_file_is_type(p_parent,'CAGENT') or
         aapp_file_is_type(p_parent,'EAGENT') or
         aapp_file_is_type(p_parent,'OAGENT') or
         aapp_file_is_type(p_parent,'RAGENT') or
         aapp_file_is_type(p_parent,'JDET')) then
         
       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'DD2760'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_doa_dd2760: ' || sqlerrm);
         raise;

end aapp_doa_dd2760;

/*AAPP (110 File): Drivers License documents attached. */
procedure aapp_doa_dl(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'DL'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_doa_dl: ' || sqlerrm);
         raise;

end aapp_doa_dl;

/*AAPP (110 File): EPR/OPR documents attached. */
procedure aapp_doa_epropr(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Active Duty and Reserve ---
     if (aapp_file_is_active_or_reserve(p_parent) or aapp_file_is_type(p_parent,'JDET')) then

       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'EPR_OPR'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_doa_epropr: ' || sqlerrm);
         raise;

end aapp_doa_epropr;

/*AAPP (110 File): Form 1288 document attached. */
procedure aapp_1288(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     p_complete := null;
     p_msg := null;

     --- Reserve Applicants Only --
     if (aapp_file_is_reservist(p_parent)) then
       
       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'1288'),p_complete,p_msg,null);
    end if;

exception
     when others then
         log_error('osi_checklist.aapp_1288: ' || sqlerrm);
         raise;

end aapp_1288;

/*AAPP (110 File): Letters of Recommendation documents attached. */
procedure aapp_unit_lor(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Active and Reserve ---
     if (aapp_file_is_active_or_reserve(p_parent) or aapp_file_is_type(p_parent,'JDET')) then

       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'LOR'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_unit_lor: ' || sqlerrm);
         raise;

end aapp_unit_lor;

/*AAPP (110 File): Email Notification attached. */
procedure aapp_email_msg(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'NEM'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_email_msg: ' || sqlerrm);
         raise;

end aapp_email_msg;

/*AAPP (110 File): Physical Fitness Assessment documents attached. */
procedure aapp_doa_far(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Active and Reserve ---
     if (aapp_file_is_active_or_reserve(p_parent)) then

       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'FAR'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_doa_far: ' || sqlerrm);
         raise;

end aapp_doa_far;

/* AAPP (110 File): Records Review Rip documents attached. */
procedure aapp_doa_rrrip(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- Active and Reserve ---
     if (aapp_file_is_active_or_reserve(p_parent)) then

       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'REC_RIP'),p_complete,p_msg,null);

     end if;

exception
     when others then
         log_error('osi_checklist.aapp_doa_rrrip: ' || sqlerrm);
         raise;

end aapp_doa_rrrip;
    
/*AAPP (110 File): Resume attached. */
procedure aapp_resume(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All Civilians and Reservists ---
     if (aapp_file_is_type(p_parent,'CAGENT') or
         aapp_file_is_type(p_parent,'CPROSTAFF') or
         aapp_file_is_type(p_parent,'RAGENT') or
         aapp_file_is_type(p_parent,'RPROSTAFF') or
         aapp_file_is_type(p_parent,'JDET')) then
         
       attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'RESUME'),p_complete,p_msg,null);
      
     end if; 

exception
     when others then
         log_error('osi_checklist.aapp_resume: ' || sqlerrm);
         raise;

end aapp_resume;
    
/*AAPP (110 File): The SF86 hard copy attached. */
procedure aapp_unit_sf86hc(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'SF86'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_unit_sf86hc: ' || sqlerrm);
         raise;

end aapp_unit_sf86hc;

/*AAPP (110 File): The Termination Report attached. */
procedure aapp_termination(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'TERMINATION'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_unit_sf86hc: ' || sqlerrm);
         raise;

end aapp_termination;
    
/*AAPP (110 File): 151REG documents attached. */
procedure aapp_region_151reg(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'151_REG'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_unit_151reg: ' || sqlerrm);
         raise;

end aapp_region_151reg;


/*AAPP (110 File): ROI documents attached. */
procedure aapp_region_roi(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'CROI', 'REPORT'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_region_roi: ' || sqlerrm);
         raise;
 end aapp_region_roi;

/*AAPP (110 File): ROI Draft documents attached. */
procedure aapp_draft_roi(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
begin
     --- All applicants ---
     attachment_exists(p_parent,osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),'DROI', 'REPORT'),p_complete,p_msg,null);

exception
     when others then
         log_error('osi_checklist.aapp_region_roi: ' || sqlerrm);
         raise;
 end aapp_draft_roi;

/*AAPP (110 File): All Objectives Must be Met. */
procedure aapp_objectives_met(p_parent in varchar2, p_complete out number, p_msg out varchar2) is

    v_cnt   number;

begin
     select count(*)into v_cnt
          from t_osi_f_aapp_file_obj
         where obj = p_parent and (obj_met is null or obj_met <> 'Y');

     if v_cnt = 0 then
 
       p_complete := 1;
       p_msg := null;
 
     else
 
       p_complete := 0;
       p_msg := 'ALL Objectives MUST be Met.';
 
     end if;

exception
     when others then
         log_error('osi_checklist.aapp_objectives_met: ' || sqlerrm);
         raise;

end aapp_objectives_met;

/*AAPP (110 File): All activities must be closed. */
procedure aapp_act_closed(p_parent in varchar2, p_complete out number, p_msg out varchar2) is

     v_cnt   number;
     v_msg   clob;
     v_ids   clob;

begin
     v_msg := 'DEFAULT';                                                     --- initial value ---
     v_cnt := 0;

     select count(activity_sid) into v_cnt
           from v_osi_f_aapp_file_obj_act
          where file_sid = p_parent;

     if v_cnt > 0 then
       
       --- Loop through all associated activities for the given file ---
       for n in (select activity_sid, activity_id
                       from v_osi_f_aapp_file_obj_act
                           where file_sid = p_parent and activity_close_date is null order by activity_id)
       loop
           v_msg := 'Associated Activities Found';

           --- LOOK FOR OPEN ASSOCIATED ACTIVITIES ---
           v_cnt := v_cnt + 1;
           v_ids := v_ids || '<a href="javascript:getObjURL(''' || n.activity_sid || ''');">' || n.activity_id || '</a>, ';
           --v_ids := v_ids || osi_object.get_tagline_link(n.activity_sid) || '<br>';
       end loop;

       --add trailing line feed
       v_ids := substr(v_ids, 1, length(v_ids) - 2) || '<br><br>';

     end if;

     if v_cnt = 0 then

       p_complete := null;
       p_msg := 'No Associated Activities';
   
     else

       if v_cnt > 0 and v_msg <> 'DEFAULT' then

         p_complete := 0;
         p_msg := 'The Following Associated Activities are NOT Closed:<HR>' || substr(v_ids, 1, length(v_ids) - 2);

       else

         p_complete := 1;
         p_msg := null;

      end if;

     end if;
exception
     when others then
         log_error('osi_checklist.aapp_act_closed: ' || sqlerrm);
         raise;

end aapp_act_closed;

/*AAPP (110 Activity): All activities must have TO/FROM dates. */
procedure aapp_a_have_dates(p_parent in varchar2, p_complete out number, p_msg out varchar2) is

    v_cnt   number;

begin
     select count(sid) into v_cnt
          from t_osi_a_aapp_activity
         where sid = '22200000RAH'and osi_object.get_objtype_code(core_obj.get_objtype('22200000RAH')) = 'ACT.AAPP.INTERVIEW';

     if (v_cnt > 0) then                             --This IS an interview, and needs the dates.

       select count(sid) into v_cnt
            from t_osi_a_aapp_activity
              where sid = p_parent and(   date_from is null or date_to is null);

       if (v_cnt > 0) then
 
         p_complete := 0;
         p_msg := 'You must have FROM and TO known dates for all interviews.';
 
       else
 
         p_complete := 1;
         p_msg := null;
 
       end if;
   else                            --This activity is NOT an interview, dates are not required.

     p_complete := null;
     p_msg := null;

   end if;

exception
    when others then
        log_error('osi_checklist.aapp_a_have_dates: ' || sqlerrm);
        raise;

end aapp_a_have_dates;

    /*Manual Fingerprint must have FD-249 fingerprint card attached for completion. */
    procedure fp_card_attached(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_objtype    varchar2(20);
        v_atchtype   varchar2(20);
        v_cnt        number;
        v_msg        varchar2(100) := 'FD-249 Scanned Fingerprint Card(s) Attached';
    begin
        v_objtype := core_obj.get_objtype(p_obj);

        select sid
          into v_atchtype
          from t_osi_attachment_type
         where obj_type = v_objtype and usage = 'ATTACHMENT' and code = 'FD_249';

        select count(*)
          into v_cnt
          from t_osi_attachment a
         where a.obj = p_obj and a.type = v_atchtype;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := v_msg;
        end if;
    exception
        when others then
            log_error('fp_card_attached: ' || sqlerrm);
            raise;
    end fp_card_attached;

    procedure dibrs_complete_ah_offs(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt    number;
        v_cnt2   number;
    begin
        begin
            select count(s.offense)
              into v_cnt
              from t_osi_f_inv_spec s
             where s.investigation = p_parent and s.off_result is null;
        exception
            when no_data_found then
                v_cnt := 0;
        end;

        if v_cnt > 0 then
            p_complete := 0;
            p_msg := 'Missing offense result';
            return;
        end if;

        begin
            --DIBRS ERROR# 682 -- all assault offenses should be coded as C (Completed)
            select count(s.off_result)
              into v_cnt2
              from t_osi_f_inv_spec s, t_dibrs_offense_type o, t_dibrs_reference r
             where s.investigation = p_parent
               and s.offense = o.sid
               and s.off_result = r.sid
               and o.nibrs_code in('09A', '09B', '09C', '13A', '13B', '13C')
               and r.code <> 'C';
        exception
            when no_data_found then
                v_cnt2 := 0;
        end;

        if v_cnt2 = 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Not complete results on all assault and homicide offenses';
        end if;
    exception
        when others then
            log_error('dibrs_complete_ah_offs: ' || sqlerrm);
            raise;
    end dibrs_complete_ah_offs;

    procedure dibrs_ir_ucmj_date(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt         number(3)      := 0;
        str1          varchar2(100);
        before_list   varchar2(4000) := null;
        after_list    varchar2(4000) := null;
    begin
        for b in (select   i.incident_id, trunc(i.start_date) as start_date, o.code,
                           upper(o.description) as description
                      from t_osi_f_inv_incident_map fi,
                           t_osi_f_inv_incident i,
                           t_osi_f_inv_spec s,
                           t_dibrs_offense_type o
                     where fi.investigation = p_parent
                       and fi.incident = i.sid
                       and i.sid = s.incident
                       and fi.investigation = s.investigation
                       and s.offense = o.sid
                  order by i.start_date asc)
        loop
            if (    b.start_date < to_date('01-10-2007', 'DD-MM-YYYY')
                and b.description like '%AFTER 1 OCT%') then
                v_cnt := v_cnt + 1;
                before_list :=
                    before_list || 'Incident ID:' || b.incident_id || ' cannot use UCMJ ' || b.code
                    || ' because the incident begin date occurred before 1 October 2007.'
                    || chr(13) || chr(10);
            elsif(    b.start_date >= to_date('01-10-2007', 'DD-MM-YYYY')
                  and b.description like '%BEFORE 1 OCT%') then
                v_cnt := v_cnt + 1;
                after_list :=
                    after_list || 'Incident ID:' || b.incident_id || ' cannot use UCMJ ' || b.code
                    || ' because the incident begin date occurred after 1 October 2007.' || chr(13)
                    || chr(10);
            end if;
        end loop;

        str1 :=
            'The following Incident ID(s) contained conflicting offense codes and incident begin dates:'
            || chr(13);

        if (v_cnt > 0) then
            p_complete := 0;
            p_msg := str1 || chr(13) || chr(10) || before_list || chr(13) || chr(10) || after_list;
            p_msg := substr(p_msg, 0, length(p_msg) - 3);
            return;
        else
            p_complete := 1;
            p_msg := null;
            return;
        end if;
    end dibrs_ir_ucmj_date;

    procedure verify_assoc_poly_exam_act(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
        v_objtype   varchar2(20);
        v_cnt       number;
        v_msg       varchar2(100) := 'Missing Associated Poly Exam Activity';
    begin
        --CHECK FOR ASSOCIATED POLY EXAM ACTIVITY
        select count(*)
          into v_cnt
          from v_osi_assoc_fle_act
         where file_sid = p_obj
           and core_obj.get_objtype(activity_sid) = core_obj.lookup_objtype('ACT.POLY_EXAM');

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := v_msg;
        end if;
    exception
        when others then
            log_error('verify_assoc_poly_exam_act: ' || sqlerrm);
            raise;
    end verify_assoc_poly_exam_act;

    procedure verify_poly_csp(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_csp   t_osi_f_poly_file.csp_type%type;
    begin
        --Check that CSP is not null
        select p.csp_type
          into v_csp
          from t_osi_f_poly_file p
         where p.sid = p_obj;

        if v_csp is not null then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Missing CSP';
        end if;
    exception
        when no_data_found then
            p_complete := 0;
            p_msg := 'Could not find row in T_POLY_FILE or T_FILE_V2';
    end verify_poly_csp;

    procedure verify_poly_exam_reason(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_poly_file
         where sid = p_obj and reason_for_exam is not null;

        p_complete := v_cnt;

        if v_cnt = 0 then
            p_msg := 'Reason for exam not specified';
        else
            p_msg := null;
        end if;
    exception
        when others then
            log_error('verify_poly_exam_reason: ' || sqlerrm);
            raise;
    end verify_poly_exam_reason;

    procedure verify_poly_exculpatory(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        --Check that Exculpatory is not null
        select count(*)
          into v_cnt
          from t_osi_f_poly_file
         where sid = p_obj and exculpatory is not null;

        if v_cnt > 0 then
            p_complete := 1;
            p_msg := null;
        else
            p_complete := 0;
            p_msg := 'Exculpatory checkbox is incomplete';
        end if;
    exception
        when others then
            log_error('verify_poly_exculpatory: ' || sqlerrm);
            raise;
    end verify_poly_exculpatory;

    procedure verify_poly_have_examinee(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        participant_role_exists(p_obj, 'Examinee', p_complete, p_msg);
    exception
        when others then
            log_error('verify_poly_have_examinee: ' || sqlerrm);
            raise;
    end verify_poly_have_examinee;

    procedure verify_poly_return_reason(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_count   number := null;
    begin
        select count(*)
          into v_count
          from t_osi_f_poly_file
         where sid = p_obj
           and (   admindef is null
                or admindef = 'N')
           and (   techdef is null
                or techdef = 'N');

        if v_count > 0 then
            --- The checkbox has not been Checked/Unchecked ---
            p_complete := 0;
            p_msg :=
                'Please Check either "File returned due to administrative or technical deficiencies".';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('verify_poly_return_reason: ' || sqlerrm);
            raise;
    end verify_poly_return_reason;

    procedure check_activity_date(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_date   date;
    begin
        p_complete := 1;
        p_msg := null;

        begin
            select trunc(activity_date)
              into v_date
              from t_osi_activity
             where sid = p_obj;
        exception
            when no_data_found then
                p_complete := 0;
                p_msg := 'Activity Not Found.';
        end;

        -- CR3393 modified on 22 Mar 10 to add an extra day for pacific units.  wcc
        if (v_date > trunc(sysdate) + 1) then
            p_complete := 0;
            p_msg :=
                'Activity Date (' || to_char(v_date, 'DD-MON-YYYY')
                || ') can not be greater than complete date (' || to_char(sysdate, 'DD-MON-YYYY')
                || ').';
        end if;
    end check_activity_date;

    procedure verify_offense_results(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        vac_co_count     number;
        vcharged_count   number;
    begin
        p_complete := 1;
        p_msg := null;

        for a in (select offense
                    from t_osi_f_inv_subj_disp_offense o, t_osi_f_inv_subj_disposition d
                   where d.sid = o.disposition and investigation = p_obj)
        loop
            select count(*)
              into vac_co_count
              from t_osi_f_inv_subj_disposition d,
                   t_osi_f_inv_subj_disp_offense o,
                   t_osi_f_inv_court_result_type t
             where t.sid = o.result
               and d.sid = o.disposition
               and investigation = p_obj
               and t.code in('AC', 'CO')
               and o.offense = a.offense;

            select count(*)
              into vcharged_count
              from t_osi_f_inv_subj_disposition d,
                   t_osi_f_inv_subj_disp_offense o,
                   t_osi_f_inv_court_result_type t
             where t.sid = o.result
               and d.sid = o.disposition
               and investigation = p_obj
               and t.code = 'CHARGED'
               and o.offense = a.offense;

            if vac_co_count > 0 and vcharged_count = 0 then
                p_complete := 0;
                exit;
            end if;
        end loop;

        if (p_complete = 0) then
            p_msg :=
                'Offense Results of Acquitted or Convicted require a corresponding Charged Result.';
        end if;
    end verify_offense_results;

    /* SOURCE: Used to verify whether or not a Source has been bounced off the Legacy I2MS database for data import */
    procedure source_import_is_satisfied(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2) is
    begin
        --First see if this source is a potential dup to begin with
        if (osi_source.dup_source_exists_in_legacy(p_obj) = 'N') then
            p_msg := 'No importable Legacy I2MS data exists.';
            return;
        end if;

        --See if the source has been searched in legacy
        for k in
            (select sid
               from t_osi_attachment
              where obj = p_obj
                and type =
                        osi_attachment.get_attachment_type_sid
                                                            (core_obj.lookup_objtype('FILE.SOURCE'),
                                                             'LEG_IMP',
                                                             'ATTACHMENT'))
        loop
            p_complete := 1;
            p_msg := 'Search Complete.';
            return;
        end loop;

        p_complete := 0;
        p_msg :=
            'You must search Legacy I2MS for importable data before this Source can be approved.  The search is located in the Actions Menu.';
    exception
        when others then
            log_error('osi_checklist.source_import_is_satisfied: ' || sqlerrm);
            raise;
    end source_import_is_satisfied;

    /* Used to verify that relationships have been imported from legacy */
    procedure verify_legacy_relationships(p_obj in varchar2, p_complete out number, p_msg out varchar2) is
        v_count           number          := 0;
        v_temp            varchar2(32767);
        v_obj_type_code   varchar2(200);
    begin

        --Determine if the check is coming from a Participant Confirmation or Case Closure
        v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

        -----------------------------------------
        ----  Processing for a PARTICIPANT object type
        -----------------------------------------

        if v_obj_type_code like 'PART.%' then
            --if there are none, we can just exit with success
            if osi_participant.get_imp_relations_flag(p_obj) = 'Y' then
                    p_complete := null;
                    p_msg := 'No Pending Relationships.';

                return;
            else
                    --If pending imports exist
                    p_complete := 0;
                    p_msg := 'Legacy I2MS Must Be Searched For Relationships.  The search is located in the Actions Menu.';
            end if;
            
        -----------------------------------------
        ----  Processing for a CASE object type
        -----------------------------------------
        else
            --See if there are any participants to begin with
            select count(SID)
              into v_count
              from t_osi_partic_involvement
             where obj = p_obj;

            --if there are none, we can just exit with success
            if v_count = 0 then
                    p_complete := null;
                    p_msg := 'No Pending Relationships.';

                return;
            else
                --There are participants, loop through and get them
                for k in (select opv.participant
                            from t_osi_partic_involvement opi,
                                 t_osi_participant op,
                                 t_osi_participant_version opv
                           where opi.obj = p_obj
                             and op.SID = opv.participant
                             and opv.SID = opi.participant_version
                             and osi_participant.get_imp_relations_flag(op.SID) = 'N')
                loop
                    --v_temp := v_temp || '<br>' || osi_object.get_open_link(k.participant);
                    v_temp := v_temp || '<br>' || osi_object.get_tagline_link(k.participant);
                end loop;

                --If no pending imports exist
                if (v_temp is null) then
                    p_complete := 1;
                    p_msg := 'All Legacy I2MS relationships have been imported.';
                else
                    --If pending imports exist
                    p_complete := 0;
                    p_msg := 'Legacy I2MS Must Be Searched For Relationships Pertaining to The Following Participant(s):<br>' || v_temp;
                end if;
            end if;
        end if;
    exception
        when others then
            log_error('verify_legacy_relationships: ' || sqlerrm);
            raise;
    end verify_legacy_relationships;

/*=============================================================================================*/
/* Confirm user privilage to approve offense 106-A- Investigations.                            */
/*=============================================================================================*/
    procedure inv_approve_106a(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_personnel   varchar2(20);
        v_unit        varchar2(20);
        v_count       number       := 0;
    begin
        select count(*) into v_count
          from t_osi_f_inv_offense o, t_dibrs_offense_type ot
         where o.investigation = p_parent and o.offense = ot.sid and ot.code = '106-A-';

        if v_count = 0 then

          p_msg := 'No Offenses with Code: 106-A- exist.';
          p_complete := null;
          return;

        end if;

        v_personnel := core_context.personnel_sid;
        v_unit := osi_personnel.get_current_unit(v_personnel);

        p_msg := osi_auth.check_for_priv('APP_106_A', core_obj.get_objtype(p_parent), v_personnel, v_unit);

        if p_msg = 'Y' then

          p_complete := 1;
          p_msg := 'Current user can Approve Offense 106-A- Investigations.';

        else

          p_complete := 0;
          p_msg := 'Current user can not Approve Offense 106-A- Investigations.';

        end if;

    exception
        when others then
            log_error('inv_approve_106a: ' || sqlerrm);
            raise;
    end inv_approve_106a;

    procedure afcert_inc_num_req (p_obj in varchar2, p_complete out number, p_msg out varchar2) is

             v_count   number;
    begin
         p_complete := 0;
         p_msg := 'AFCERT Incident Number Required.';

        select count(*) into v_count from t_osi_a_compint_source s,t_osi_reference r
         where s.src_type=r.sid 
           and r.code='ASIMS'
           and s.compint=p_obj;
        
        if v_count = 0 then
 
          p_complete := null;
          p_msg := 'No ASIMS Sources for this Activity.';
        
        elsif v_count > 0 then
          
          select count(*) into v_count from t_osi_a_comp_intrusion i where i.afcert_incident_num is null and i.sid=p_obj;
          
          if v_count=0 then
  
            p_complete := 1;
            p_msg := null;
          
          end if;
              
        end if;
        
    exception
        when others then
            log_error('afcert_incident_number_required: ' || sqlerrm);
            raise;
    end afcert_inc_num_req;

    
end osi_checklist;
/
