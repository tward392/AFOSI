--- 005-Participant_SSN_self_check                   ---
set scan off;

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
        v_msg        varchar2(10000);
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
        v_msg                    varchar2(10000);
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
        for k in (select   ocit.verify_proc, ocit.title, ocitm.completion_required, ocit.details
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
                v_output_pass :=
                    v_output_pass || '<b>' || k.title || v_opt || '</b>' || v_crlf || v_pass
                    || v_msg || v_crlf;

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
                v_output_fail :=
                    v_output_fail || '<b>' || k.title || v_opt || '</b>' || v_crlf || v_fail
                    || v_msg || v_crlf;

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
              from t_osi_a_surveillance s
             where s.sid = p_obj
               and (    s.approved_by is not null
                    and s.approved_date is not null
                    and s.approved_duration is not null);
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

        --check to make sure there is a recovered date if the property was marked 'Recovered'
        -- error 665, recovered prop must have recovered date
        select count(*)
          into v_count3
          from t_osi_f_inv_property p, t_dibrs_property_loss_by_type pl, t_osi_f_inv_spec sp
         where sp.investigation = p_parent
           and sp.sid = p.specification
           and pl.sid = p.prop_loss_by
           and pl.report_as = (select sid
                                 from t_dibrs_property_loss_by_type
                                where code = '5')
           and (   p.prop_returned_on is null
                or p.action_date is null);

        if v_count3 > 0 then
            p_complete := 0;
            p_msg :=
                'For an Action Type of (Recovered) a Action Date and a Returned On Date are required. ';
            return;                                                                      -- get out
        end if;

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
                     and pv.sid = ph.sid)
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
    procedure dibrs_comb_valid(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_count     number      := 0;
        v_count2    number      := 0;
        v_offense   varchar2(6) := null;
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
            v_offense := a.code;

            -- if 09C exists, there can't be any other reportable offenses (693)
            if a.nibrs_code = '09C' then
                select count(*)
                  into v_count2
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
                   and a.victim = sv2.victim
                   and a.incident = sv2.incident
                   and ot.nibrs_code <> '09C';

                if v_count2 > 0 then
                    p_complete := 0;
                    p_msg :=
                        'For this offense ' || v_offense
                        || ' there can`t be any other reportable offenses';
                    return;
                -- exit if error exists
                end if;
            end if;

            -- if 09A exists,  then 09B, 13A, 13B, and 13C are not allowed (699)
            if a.nibrs_code = '09A' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in('09B', '13A', '13B', '13C'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Manslaughter offense ' || v_offense
                        || ' is used, then Negligent Manslaughter, Aggravated Assault, '
                        || 'Simple Assault, and Intimidation are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            --if 09B exists, 09A, 13A, 13B, and 13C are not allowed (700)
            if a.nibrs_code = '09B' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in('09A', '13A', '13B', '13C'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Negligent Manslaughter offense ' || v_offense
                        || ' is used then NIBRS Manslaughter, Aggravated Assault, '
                        || 'Simple Assault, and Intimidation are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 11A, then 11D, 13A, 13B, 13C, 36A, and 36B are not allowed (701)
            if a.nibrs_code = '11A' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in('11D', '13A', '13B', '13C', '36A', '36B'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Forcible Rape offense ' || v_offense
                        || ' is used then Forcible Fondling, Aggravated Assault, '
                        || 'Simple Assault, Intimidation, Incest, and Statutory Rape are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 11B, then 11D, 13A, 13B, 13C, 36A, and 36B are not allowed (702)
            if a.nibrs_code = '11B' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in('11D', '13A', '13B', '13C', '36A', '36B'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Forcible Sodomy offense ' || v_offense
                        || ' is used then Forcible Fondling, Aggravated Assault, '
                        || 'Simple Assault, Intimidation, Incest, and Statutory Rape are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 11C, then 11D, 13A, 13B, 13C, 36A, and 36B are not allowed (703)
            if a.nibrs_code = '11C' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in('11D', '13A', '13B', '13C', '36A', '36B'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Sexual Assault with an Object offense ' || v_offense
                        || ' is used then Forcible Fondling, Aggravated Assault, '
                        || 'Simple Assault, Intimidation, Incest, and Statutory Rape are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 11D, then 11A, 11B, 11C, 13A, 13B, 13C, 36A, and 36B are not allowed (704)
            if a.nibrs_code = '11D' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in
                                            ('11A', '11B', '11C', '13A', '13B', '13C', '36A', '36B'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Forcible Fondling offense ' || v_offense
                        || ' is used then Forcible Rape, Forcible Sodomy, Sexual Assault '
                        || 'with an Object, Aggravated Assault, Simple Assault, '
                        || 'Intimidation, Incest, and Statutory Rape are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 120, then 13A, 13B, 13C, 23A through 23H, and 240 are not allowed (705)
            if a.nibrs_code = '120' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in
                                     ('13A', '13B', '13C', '23A', '23B', '23C', '23D', '23E', '23F',
                                      '23G', '23H', '240'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Robbery offense ' || v_offense
                        || ' is used then Aggravated Assault, Simple Assault, '
                        || 'Intimidation, Pocket picking, Purse-snatching, '
                        || 'Shoplifting, Theft From Building, Property, '
                        || 'Theft from Coin Operated Machine '
                        || 'Device, Theft From Motor Vehicle, Parts or Accessories, '
                        || 'All other Larceny and Motor Vehicle Theft are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 13A, then 09A, 09B, 11A, 11B, 11C, 120, 13B, and 13C are not allowed (706)
            if a.nibrs_code = '13A' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in
                                            ('09A', '09B', '11A', '11B', '11C', '120', '13B', '13C'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Aggravated Assault offense ' || v_offense
                        || ' is used then Murder and Nonnegligent Manslaughter, Negligent Manslaughter, '
                        || 'Forcible Rape, Forcible Sodomy, Sexual Assault with an Object, Robbery, '
                        || 'Simple Assault and Intimidation are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 13B, then 09A, 09B, 11A, 11B, 11C, 11D, 120, 13A, and 13C are not allowed (710)
            if a.nibrs_code = '13B' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in
                                     ('09A', '09B', '11A', '11B', '11C', '11D', '120', '13A', '13C'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Simple Assault offense ' || v_offense
                        || ' then NIBRS Murder and Nonnegligent Manslaughter, Negligent Manslaughter, '
                        || 'Forcible Rape, Forcible Sodomy, Sexual Assault with an Object, Forcible Fondling, '
                        || 'Robbery, Aggravated Assault, and Intimidation are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 13C, then 09A, 09B, 11A, 11B, 11C, 11D, 120, 13A, and 13B are not allowed (711)
            if a.nibrs_code = '13C' then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in
                                     ('09A', '09B', '11A', '11B', '11C', '11D', '120', '13A', '13B'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When an Intimidation offense ' || v_offense
                        || ' then NIBRS Murder and Nonnegligent Manslaughter, Negligent Manslaughter, '
                        || 'Forcible Rape, Forcible Sodomy, Sexual Assault with an Object, Forcible Fondling, '
                        || 'Robbery, Aggravated Assault, and Simple Assault are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 23A through 23H or 240, then 120 is not allowed (712)
            if a.nibrs_code in('23A', '23B', '23C', '23D', '23E', '23F', '23G', '23H', '240') then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in('120'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When a Pocket picking, Purse-snatching, Shoplifting, Theft From Building, '
                        || 'Theft from Coin Operated Machine Device, Theft From Motor Vehicle, '
                        || 'Parts or Accessories, All other Larceny or Motor Vehicle Theft offense '
                        || v_offense || ' is used then Robbery Offense is not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;

            -- if 36A or 36B, then 11A, 11B, 11C, and 11D are not allowed (713)
            if a.nibrs_code in('36A', '36B') then
                for b in (select ot.nibrs_code
                            from t_dibrs_offense_type ot,
                                 t_osi_f_inv_offense o,
                                 t_osi_f_inv_spec sv2,
                                 t_osi_reference r
                           where o.investigation = p_parent
                             and o.offense = ot.sid
                             and o.offense = sv2.offense
                             and o.priority = r.sid
                             and r.code <> 'N'
                             and a.victim = sv2.victim
                             and a.incident = sv2.incident
                             and ot.nibrs_code in('11A', '11B', '11C', '11D'))
                loop
                    v_count := v_count + 1;
                end loop;

                if v_count > 0 then
                    p_complete := 0;
                    p_msg :=
                        'When an Incest or Statutory Rape offense ' || v_offense
                        || ' is used then Forcible Rape, Forcible Sodomy, Sexual Assault with an Object '
                        || 'or Forcible Fondling are not allowed';
                    return;                                                 -- exit if error exists
                end if;
            end if;
        end loop;

        if v_count > 0 then
            p_complete := 0;
            p_msg := 'Invalid Combination of Offenses';
        else
            p_complete := 1;
            p_msg := 'Valid Combination of Offenses';
        end if;
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
    procedure assocact_closed(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_message   varchar2(32000);
        v_ids       varchar2(20000);
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
                v_ids := v_ids || osi_object.get_tagline_link(n.sid) || '<br>';
            --v_ids || '<A HREF="I2MS:://pSid=' || n.activity || ' '
            --|| core_obj.get_tagline(n.SID) || '">' || n.id || '</A>, ';
            end if;
        end loop;

        if v_message = 'DEFAULT' then
            p_complete := null;
            p_msg := 'No Associated Activities';
        else
            if v_count > 0 then
                p_complete := 0;
                p_msg := 'The Following Associated Activities are NOT Closed:<br>' || v_ids;
            --|| substr(v_ids, 1, length(v_ids) - 2);
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
        select count(*)
          into v_count
          from t_osi_f_inv_offense o, t_dibrs_offense_type ot
         where o.investigation = p_parent and o.offense = ot.sid and ot.code = '134-Z2';

        if v_count = 0 then
            p_msg := 'No Offenses with Code: 134-Z2 exist.';
            p_complete := null;
            return;
        end if;

        v_personnel := core_context.personnel_sid;

        select unit
          into v_unit
          from t_osi_personnel_unit_assign
         where personnel = v_personnel;

        p_msg := osi_auth.check_for_priv('APP_134_Z2', core_obj.get_objtype(p_parent));

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

    function aapp_file_is_support(p_parent in varchar2)
        return boolean is
    begin
        --Agent Only, no support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'SPT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RSPT'))
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
        --Agent Only, no support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'AGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT'))
                     and sid = p_parent)
        loop
            return true;
        end loop;

        return false;
    exception
        when others then
            log_error('checklist_pkg.aapp_file_is_agent: ' || sqlerrm);
            raise;
    end aapp_file_is_agent;

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

    /*AAPP (110 File): Form 1288 document attached. */
    procedure aapp_1288(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        p_complete := null;
        p_msg := null;

        --Reserve Applicants Only
        for k in (select sid
                    from t_osi_f_aapp_file
                   where sid = p_parent
                     and (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RSPT')))
        loop
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            '1288'),
                     p_complete,
                     p_msg,
                     null);
        end loop;
    exception
        when others then
            log_error('osi_checklist.aapp_1288: ' || sqlerrm);
            raise;
    end aapp_1288;

    /*AAPP (110 File): AF IMT 686 Document attached. */
    procedure aapp_imt_686(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'IMT_686'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_imt_686: ' || sqlerrm);
            raise;
    end aapp_imt_686;

    /*AAPP (110 File): BQ documents attached. */
    procedure aapp_doa_bq(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'BACK_QUES'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_doa_bq: ' || sqlerrm);
            raise;
    end aapp_doa_bq;

    /*AAPP (110 File): COE documents attached. */
    procedure aapp_doa_coe(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'COE'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_doa_coe: ' || sqlerrm);
            raise;
    end aapp_doa_coe;

    /*AAPP (110 File): CR documents attached. */
    procedure aapp_doa_cr(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'CR'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_doa_cr: ' || sqlerrm);
            raise;
    end aapp_doa_cr;

    /*AAPP (110 File): DD2760 documents attached. */
    procedure aapp_doa_dd2760(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'DD2760'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_doa_dd2760: ' || sqlerrm);
            raise;
    end aapp_doa_dd2760;

    /*AAPP (110 File): DL documents attached. */
    procedure aapp_doa_dl(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'DL'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_doa_dl: ' || sqlerrm);
            raise;
    end aapp_doa_dl;

    /*AAPP (110 File): AAPP DOA Document attached. */
    procedure aapp_doa_doa(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Agent Only, no support)
        if (aapp_file_is_agent(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'DOA'),
                     p_complete,
                     p_msg,
                     null);
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_doa: ' || sqlerrm);
            raise;
    end aapp_doa_doa;

    /*AAPP (110 File): EPR/OPR documents attached. */
    procedure aapp_doa_epropr(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Military Only
        if (aapp_subject_is_military(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'EPR_OPR'),
                     p_complete,
                     p_msg,
                     null);
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_epropr: ' || sqlerrm);
            raise;
    end aapp_doa_epropr;

    /*AAPP (110 File): FAR documents attached. */
    procedure aapp_doa_far(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Military Only
        if (aapp_subject_is_military(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'FAR'),
                     p_complete,
                     p_msg,
                     null);
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_far: ' || sqlerrm);
            raise;
    end aapp_doa_far;

    /*AAPP (110 File): FQ documents attached. */
    procedure aapp_doa_fq(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'FIN_QUES'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_doa_fq: ' || sqlerrm);
            raise;
    end aapp_doa_fq;

    /*AAPP (110 File): PP documents attached. */
    procedure aapp_doa_pp(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Military Only
        if (aapp_subject_is_military(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'AF_422'),
                     p_complete,
                     p_msg,
                     null);
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_pp: ' || sqlerrm);
            raise;
    end aapp_doa_pp;

    /*AAPP (110 File): RI documents attached. */
    procedure aapp_doa_ri(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Agent Only (No Support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where sid = p_parent
                     and (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'AGT')))
        loop
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'RO_INV'),
                     p_complete,
                     p_msg,
                     null);
        end loop;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_ri: ' || sqlerrm);
            raise;
    end aapp_doa_ri;

    /*AAPP (110 File): RRRIP documents attached. */
    procedure aapp_doa_rrrip(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Military Only
        if (aapp_subject_is_military(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'REC_RIP'),
                     p_complete,
                     p_msg,
                     null);
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_rrrip: ' || sqlerrm);
            raise;
    end aapp_doa_rrrip;

    /*AAPP (110 File): SHIPLEY or Baccalaureate attached. */
    procedure aapp_doa_shipley(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Agent Only (No Support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where sid = p_parent
                     and (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'AGT')))
        loop
            --And agent is military
            if (aapp_subject_is_military(p_parent)) then
                attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'SHIPLEY'),
                     p_complete,
                     p_msg,
                     null);
            end if;
        end loop;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_shipley: ' || sqlerrm);
            raise;
    end aapp_doa_shipley;

    /*AAPP (110 File): SOUFA documents attached. */
    procedure aapp_doa_soufa(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Agent Only (No Support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where sid = p_parent
                     and (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'AGT')))
        loop
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'SOUFA'),
                     p_complete,
                     p_msg,
                     null);
        end loop;

        --or Military
        if (aapp_subject_is_military(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'SOUFA'),
                     p_complete,
                     p_msg,
                     null);
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_soufa: ' || sqlerrm);
            raise;
    end aapp_doa_soufa;

    /*AAPP (110 File): WS documents attached. */
    procedure aapp_doa_ws(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Agent Only (No Support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where sid = p_parent
                     and (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'AGT')))
        loop
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'WRIT_SAMP'),
                     p_complete,
                     p_msg,
                     null);
        end loop;
    exception
        when others then
            log_error('osi_checklist.aapp_doa_ws: ' || sqlerrm);
            raise;
    end aapp_doa_ws;

    /*AAPP (110 File): 151DET documents attached. */
    procedure aapp_unit_151det(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All applicants
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            '151_DET'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_unit_151det: ' || sqlerrm);
            raise;
    end aapp_unit_151det;

    /*AAPP (110 File): BPS documents attached. */
    procedure aapp_unit_bps(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Agent Only, no support)
        if (aapp_file_is_agent(p_parent)) then
            --Military Only
            if (aapp_subject_is_military(p_parent)) then
                attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'BPS'),
                     p_complete,
                     p_msg,
                     null);
            end if;
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_unit_bps: ' || sqlerrm);
            raise;
    end aapp_unit_bps;

    /*AAPP (110 File): DCII documents attached. */
    procedure aapp_unit_dcii(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All applicants
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'DCII'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_unit_dcii: ' || sqlerrm);
            raise;
    end aapp_unit_dcii;

    /*AAPP (110 File): DLAB documents attached. */
    procedure aapp_unit_dlab(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Agent Only (No Support)
        for k in (select sid
                    from t_osi_f_aapp_file
                   where sid = p_parent
                     and (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'AGT')))
        loop
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'DLAB'),
                     p_complete,
                     p_msg,
                     null);
        end loop;
    exception
        when others then
            log_error('osi_checklist.aapp_unit_dlab: ' || sqlerrm);
            raise;
    end aapp_unit_dlab;

    /*AAPP (110 File): LOR documents attached. */
    procedure aapp_unit_lor(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --Enlisted Military (SA_PAY_PLAN of Enlisted)
        if (aapp_subject_is_enlisted(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'LOR'),
                     p_complete,
                     p_msg,
                     null);
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_unit_lor: ' || sqlerrm);
            raise;
    end aapp_unit_lor;

    /*AAPP (110 File): A picture is attached. */
    procedure aapp_unit_picture(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All but civilian support - If Component is blank and they are support, then not required
        --All non-blank components
        if (aapp_subject_is_military(p_parent)) then
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'PIC'),
                     p_complete,
                     p_msg,
                     null);
        end if;

        --then All agents
        for k in (select sid
                    from t_osi_f_aapp_file
                   where sid = p_parent
                     and (   category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'RAGT')
                          or category = osi_reference.lookup_ref_sid('AAPP_CATEGORY', 'AGT')))
        loop
            attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'PIC'),
                     p_complete,
                     p_msg,
                     null);
        end loop;
    exception
        when others then
            log_error('osi_checklist.aapp_unit_lor: ' || sqlerrm);
            raise;
    end aapp_unit_picture;

    /*AAPP (110 File): The SF86 hard copy attached. */
    procedure aapp_unit_sf86hc(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All applicants
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'SF86'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_unit_sf86hc: ' || sqlerrm);
            raise;
    end aapp_unit_sf86hc;

    /*AAPP (110 File): 151REG documents attached. */
    procedure aapp_region_151reg(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All applicants
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            '151_REG'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_unit_151reg: ' || sqlerrm);
            raise;
    end aapp_region_151reg;

    /*AAPP (110 File): ROI documents attached. */
    procedure aapp_region_roi(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All applicants
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'CROI'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_region_roi: ' || sqlerrm);
            raise;
    end aapp_region_roi;

    /*AAPP (110 File): All Objectives Must be Met. */
    procedure aapp_objectives_met(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(*)
          into v_cnt
          from t_osi_f_aapp_file_obj
         where obj = p_parent and(   obj_met is null
                                  or obj_met <> 'Y');

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

    /*AAPP (110 File): Must have File Tracking Number */
    procedure aapp_tracknum(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(sid)
          into v_cnt
          from t_osi_f_aapp_file
         where sid = p_parent and tracking_num is null;

        if (v_cnt > 0) then
            p_complete := 0;
            p_msg := 'Must have tracking number of file you send to HQ(DP).';
        else
            p_complete := 1;
            p_msg := null;
        end if;
    exception
        when others then
            log_error('osi_checklist.aapp_tracknum: ' || sqlerrm);
            raise;
    end aapp_tracknum;

    /*AAPP (110 File): All activities must be closed. */
    procedure aapp_act_closed(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
        v_msg   varchar2(32000);
        v_ids   varchar2(20000);
    begin
        v_msg := 'DEFAULT';                                                     ---initial value---
        v_cnt := 0;

        select count(activity_sid)
          into v_cnt
          from v_osi_f_aapp_file_obj_act
         where file_sid = p_parent;

        if v_cnt > 0 then
            ---Loop through all associated activities for the given file---
            for n in (select   activity_sid
                          from v_osi_f_aapp_file_obj_act
                         where file_sid = p_parent and activity_close_date is null
                      order by activity_id)
            loop
                v_msg := 'Associated Activities Found';
                --- LOOK FOR OPEN ASSOCIATED ACTIVITIES ---
                v_cnt := v_cnt + 1;
                v_ids := v_ids || osi_object.get_tagline_link(n.activity_sid) || '<br>';
            end loop;

            --add trailing line feed
            v_ids := v_ids || '<br>';
        end if;

        if v_cnt = 0 then
            p_complete := null;
            p_msg := 'No Associated Activities';
        else
            if v_cnt > 0 and v_msg <> 'DEFAULT' then
                p_complete := 0;
                p_msg :=
                    'The Following Associated Activities are NOT Closed:<HR>'
                    || substr(v_ids, 1, length(v_ids) - 2);
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

    /*AAPP (110 File): Form82 attached. */
    procedure aapp_fm82_carb(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All applicants
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'CARB_REC'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_fm82_carb: ' || sqlerrm);
            raise;
    end aapp_fm82_carb;

    /*AAPP (110 File): Email Notification attached. */
    procedure aapp_email_msg(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
    begin
        --All applicants
        attachment_exists
                    (p_parent,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.AAPP'),
                                                            'NEM'),
                     p_complete,
                     p_msg,
                     null);
    exception
        when others then
            log_error('osi_checklist.aapp_email_msg: ' || sqlerrm);
            raise;
    end aapp_email_msg;

    /*AAPP (110 Activity): All activities must have TO/FROM dates. */
    procedure aapp_a_have_dates(p_parent in varchar2, p_complete out number, p_msg out varchar2) is
        v_cnt   number;
    begin
        select count(sid)
          into v_cnt
          from t_osi_a_aapp_activity
         where sid = '22200000RAH'
           and osi_object.get_objtype_code(core_obj.get_objtype('22200000RAH')) =
                                                                                'ACT.AAPP.INTERVIEW';

        if (v_cnt > 0) then                             --This IS an interview, and needs the dates.
            select count(sid)
              into v_cnt
              from t_osi_a_aapp_activity
             where sid = p_parent and(   date_from is null
                                      or date_to is null);

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
end osi_checklist;
/



--- 006-Hughson_create_unknown_participant_highlight ---
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
--   Date and Time:   14:06 Friday January 7, 2011
--   Exported By:     TODD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Objects without Tabs and Menus
--   Manifest End
--   Version: 3.2.1.00.12
 
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

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: PAGE TEMPLATE 93856707457736574
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 93856707457736574
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"'||chr(10)||
' "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'||chr(10)||
'<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />'||chr(10)||
'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script';

c1:=c1||'>'||chr(10)||
'<head>'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submo';

c1:=c1||'dal/subModal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.4.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<s';

c1:=c1||'cript type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnElements = [];'||chr(10)||
'	var current;'||chr(10)||
'	var length = elements.length;'||chr(10)||
'	for(var i=0; i<length; i++){'||chr(10)||
'		current = elemen';

c1:=c1||'ts[i];'||chr(10)||
'		if(testClass.test(current.className)){'||chr(10)||
'			returnElements.push(current);'||chr(10)||
'		}'||chr(10)||
'	}'||chr(10)||
'	return returnElements;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'      dateFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Pr';

c1:=c1||'evious'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
'      showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#asfdcldr.gif'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function';

c1:=c1||'(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!=hidden]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i<inputs.';

c1:=c1||'length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></s';

c1:=c1||'cript>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(';

c1:=c1||'this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'      ';

c1:=c1||'      sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'            timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
''||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'   function checkDirty(){'||chr(10)||
'      return (/\:&APP_PAGE_ID./.test(document.getElementById(''P0_DIRTY'').value));'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function highlightSave() {'||chr(10)||
'      var anchors = document.getElementsByTagName(''a'');'||chr(10)||
'      for (var i = 0;i<anchors.length;i++){'||chr(10)||
'          if (/SAVE/.test(anchors[i].href)) '||chr(10)||
'		anchors[i].style.color = ''red''; '||chr(10)||
'          if ((/CREAT';

c2:=c2||'E/.test(anchors[i].href)) &&'||chr(10)||
'           !(/CREATE_UNK/.test(anchors[i].href)))'||chr(10)||
'            anchors[i].style.color = ''red'';     '||chr(10)||
'     }   '||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setDirty() {'||chr(10)||
'      document.getElementById(''P0_DIRTY'').value+='':&APP_PAGE_ID.'';'||chr(10)||
'      highlightSave();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function clearDirty() {'||chr(10)||
'      document.getElementById(''P0_DIRTY'').value ='||chr(10)||
'      document.getElementById(''P0_DIRTY'').value.replace(/\';

c2:=c2||':&APP_PAGE_ID./g, '''');'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setPopup() {'||chr(10)||
'      isPopup = true;'||chr(10)||
'   }'||chr(10)||
'   function onUnload(){'||chr(10)||
'      if (checkDirty()){'||chr(10)||
'         clearDirty();'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   // Main'||chr(10)||
'   if (checkDirty()) {'||chr(10)||
'      highlightSave();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   var inputs, selects, textAreas, anchors;'||chr(10)||
'   inputs = document.getElementsByTagName(''input'');'||chr(10)||
'   selects = document.getElementsByTagName(''select'');'||chr(10)||
'   textAreas = docum';

c2:=c2||'ent.getElementsByTagName(''textarea'');'||chr(10)||
'   anchors = document.getElementsByTagName(''a'');'||chr(10)||
''||chr(10)||
'   for(var i=0; i<anchors.length; i++){'||chr(10)||
'      if (/popup/i.test(anchors[i].href)){'||chr(10)||
'         anchors[i].attachEvent(''onclick'',setPopup);'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
'   for(var i=0; i<inputs.length; i++){'||chr(10)||
'      if ((inputs[i].type==''checkbox'' && !(/f[0-9]+/.test(inputs[i].name))) ||'||chr(10)||
'          (inputs[i].type==''radio'')){'||chr(10)||
'       ';

c2:=c2||'  inputs[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'      } '||chr(10)||
'      if (inputs[i].type==''text''){'||chr(10)||
'         $(inputs[i]).change(function() {'||chr(10)||
'    setDirty();'||chr(10)||
'  });'||chr(10)||
'      }   '||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<selects.length; i++)'||chr(10)||
'      selects[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'   for(var i=0; i<textAreas.length; i++)'||chr(10)||
'      textAreas[i].attachEvent(''onchange'',setDirty);'||chr(10)||
''||chr(10)||
'   window.onbeforeunload = onUnload;'||chr(10)||
'   func';

c2:=c2||'tion mySubmit(request){ '||chr(10)||
'       if (request == ''&BTN_SAVE.'' ||'||chr(10)||
'           request == ''&BTN_DELETE.'' ||'||chr(10)||
'           request == ''&BTN_CANCEL.'')'||chr(10)||
'           clearDirty();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>'||chr(10)||
''||chr(10)||
'';

c3:=c3||'<table class="bannerTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'      <td class="bannerLogo" width="30%">&nbsp;</td>'||chr(10)||
'      <td align="center" class="bannerLogo" width="40%">'||chr(10)||
'      <img height="35px" src="#IMAGE_PREFIX#themes/OSI/osi_object_banner.gif"/></td>'||chr(10)||
'      '||chr(10)||
'       <td class="navBar" width="30%">'||chr(10)||
'         <table cellpadding="0" cellspacing="0" border="0" summary=';

c3:=c3||'"" align="right">'||chr(10)||
'            <tr>'||chr(10)||
'               <td><a href="&USER_URL.">&APP_USER.</a></td>'||chr(10)||
'               <td>#NAVIGATION_BAR#</td>'||chr(10)||
'            </tr>'||chr(10)||
'         </table>'||chr(10)||
'      </td> '||chr(10)||
''||chr(10)||
'   </tr>'||chr(10)||
'   <tr>'||chr(10)||
'      <table width=100% cellpadding="0" cellspacing="0">'||chr(10)||
'  <tr>'||chr(10)||
'   <td width=33% class="underbannerbar" style="text-align: left;">'||chr(10)||
'             &P0_OBJ_TAGLINE.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'   <td width=33% clas';

c3:=c3||'s="underbannerbar" style="color:#e10505;text-align: center;">'||chr(10)||
'             &OSI_BANNER.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'   <td width=100% class="underbannerbar" style="text-align: right;">'||chr(10)||
'             &P0_OBJ_ID.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'  </tr>'||chr(10)||
'   </table>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_01#'||chr(10)||
'#REGION_POSITION_02#'||chr(10)||
'#REGION_POSITION_03#'||chr(10)||
'<table class="contentTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'  ';

c3:=c3||' <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; text-align:center; '||chr(10)||
''||chr(10)||
'color:red;">#GLOBAL_NOTIFICATION#</td></tr>'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top;">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#'||chr(10)||
''||chr(10)||
''||chr(10)||
'<!--div style="clear:both;"-->           '||chr(10)||
'#BOX_BODY##REGION_POSITION_04##REGION_POSITION_05#'||chr(10)||
'<!--/div-->'||chr(10)||
''||chr(10)||
''||chr(10)||
'     </td';

c3:=c3||'>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'<div class="versionDiv">I2MS &OSI_VERSION.</div>';

wwv_flow_api.create_template(
  p_id=> 93856707457736574 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Objects without Tabs and Menus',
  p_body_title=> '<!--#BODY_TITLE#-->',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t9success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<div style="float:right; padding:7px; padding-bottom:2px; border:1px solid #222222; background-color:#ffe0c0; border-bottom:none;">#TAB_LABEL##TAB_INLINE_EDIT#</div>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div style="float:right; padding:5px; padding-bottom:2px; margin-top:2px; border:1px solid #222222; border-bottom:none; background-color:#ffe0c0; "><a href="#TAB_LINK#">#TAB_LABEL##TAB_INLINE_EDIT#</a></div>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t9notification">#MESSAGE#</div>',
  p_navigation_bar=> '<table cellpadding="1" cellspacing="2" border="0"  class="t9navbar"><tr><td valign="top"><img src="#IMAGE_PREFIX#themes/theme_9/separator.png"/>'||chr(10)||
'</td>#BAR_BODY#</tr></table>',
  p_navbar_entry=> '<td valign="top"><a href="#LINK#">#TEXT#</a></td><td valign="top">'||chr(10)||
'<img src="#IMAGE_PREFIX#themes/theme_9/separator.png"/>'||chr(10)||
'</td>'||chr(10)||
'',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 101,
  p_theme_class_id => 3,
  p_template_comment => '');
end;
 
null;
 
end;
/

COMMIT;



--- 007-CC_Review_losing_comments                    ---
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
--   Date and Time:   13:41 Friday January 7, 2011
--   Exported By:     JASON
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.12
 
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

PROMPT ...Remove page 21406
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>21406);
 
end;
/

 
--application/pages/page_21406
prompt  ...PAGE 21406: Required Comment Capture
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'  if(''&P21406_CONTINUE.'' == ''Y''){'||chr(10)||
'    var comment = window.top.document.getElementById(''P21405_COMMENT_TEXT'');'||chr(10)||
'    comment.value = ''&P21406_COMMENT.'';'||chr(10)||
'    window.top.hidePopWin(true);'||chr(10)||
'  }'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 21406,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Required Comment Capture',
  p_step_title=> 'Required Comment Capture',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'JASON',
  p_last_upd_yyyymmddhh24miss => '20110107134122',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-JAN-2011 J.Faris - (Bug Fix)Created a before header process to set existing comments into P21406_COMMENT so they do not get overwritten.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21406,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 16932831074350968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21406,
  p_plug_name=> 'Required Comment',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 16934407787363232 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21406,
  p_button_sequence=> 10,
  p_button_plug_id => 16932831074350968+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>16934716445365728 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21406,
  p_branch_action=> 'f?p=&APP_ID.:21406:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 12-OCT-2010 10:40 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16933410081354439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21406,
  p_name=>'P21406_COMMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 16932831074350968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Please enter a comment to explain why this item received this result.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>16944823717717868 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21406,
  p_name=>'P21406_CONTINUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 16932831074350968+wwv_flow_api.g_id_offset,
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
  p_id => 16933627396359437 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21406,
  p_validation_name => 'P21406_COMMENT',
  p_validation_sequence=> 10,
  p_validation => 'if(:P21406_COMMENT is not null)then'||chr(10)||
'  :P21406_CONTINUE := ''Y'';'||chr(10)||
'  return true;'||chr(10)||
'else'||chr(10)||
'  :P21406_CONTINUE := ''N'';'||chr(10)||
'  return false;'||chr(10)||
'end if;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Comment must be specified.',
  p_validation_condition=> 'SAVE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 16933410081354439 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
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
p:=p||'begin'||chr(10)||
'      select cc.comment_text'||chr(10)||
'        into :p21406_comment'||chr(10)||
'        from t_osi_a_clist_comments cc, t_osi_a_clist_result cr'||chr(10)||
'       where cr.sid = :p21405_sid'||chr(10)||
'         and cc.checklist = cr.checklist'||chr(10)||
'         and cc.item = cr.item; '||chr(10)||
'exception'||chr(10)||
'     when NO_DATA_FOUND then'||chr(10)||
'              :p21406_comment := null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 21052920924208815 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21406,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Comment Text',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SAVE',
  p_process_when_type=>'REQUEST_NOT_EQUAL_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 21406
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



--- 008-WCHG0000269_Privilege_Default_Unit_Fix       ---
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
--   Date and Time:   14:03 Friday January 7, 2011
--   Exported By:     SCOTT
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.12
 
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

PROMPT ...Remove page 30460
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30460);
 
end;
/

 
--application/pages/page_30460
prompt  ...PAGE 30460: Personnel Assigned Permissions
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_OBJ_DATA"'||chr(10)||
'"JS_POPUP_LOCATOR"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
'function AlertForForeignNat(){'||chr(10)||
'if (document.getElementById(''P30460_USER_IS_FOREIGN_NAT'').value != ''N''){'||chr(10)||
'alert(''This user is a Foreign National, you are advised not to grant this user any privileges and to use only roles.'');'||chr(10)||
'}'||chr(10)||
'doSubmit(''ADD'');'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script language="JavaScript">'||chr(10)||
'function End(){'||chr(10)||
'var answer = confirm ("Are ';

ph:=ph||'you sure you would like to end this Role?")'||chr(10)||
'if (answer)'||chr(10)||
'{'||chr(10)||
'doSubmit(''END'');'||chr(10)||
'}'||chr(10)||
'}'||chr(10)||
'</script> ';

wwv_flow_api.create_page(
  p_id     => 30460,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Personnel Assigned Permissions',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'SCOTT',
  p_last_upd_yyyymmddhh24miss => '20110107140154',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '24-JUN-2010  Jason Faris Bug 0454 Fixed (ADD mode set/reset update).'||chr(10)||
'07-JAN-2011  Scott Recher - Fixed bug that had the unit of the admin logged '||chr(10)||
'             into the system as the default unit for assigning privileges '||chr(10)||
'             instead of the unit of the personnel object being modified.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30460,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select pp.sid as "SID",'||chr(10)||
'       osi_auth.get_priv_description(ap.sid) as "Permissions",'||chr(10)||
'       osi_unit.get_name(pp.unit) as "Unit", to_char(pp.start_date, :fmt_date) as "Start Date",'||chr(10)||
'       to_char(pp.end_date, :fmt_date) as "End Date",'||chr(10)||
'       decode(pp.enabled, ''Y'', ''Yes'', ''N'', ''No'', null) as "Use",'||chr(10)||
'       decode(pp.grantable, ''Y'', ''Yes'', ''N'', ''No'', null) as "Grant",'||chr(10)||
'       decode(pp.include_subo';

s:=s||'rds, ''Y'', ''Yes'', ''N'', ''No'', null) as "Sub Units",'||chr(10)||
'       pp.create_by as "Granted By", to_char(pp.create_on, :fmt_date) as "Granted On",'||chr(10)||
'       decode(pp.sid, :p30460_sel_perm, ''Y'', ''N'') as "Current"'||chr(10)||
'  from t_osi_auth_action_type at, t_core_obj_type ot, t_osi_auth_priv ap, t_osi_personnel_priv pp &P30460_FILTER.';

wwv_flow_api.create_report_region (
  p_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30460,
  p_name=> 'Assigned Individual Permissions',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':TAB_ENABLED = ''Y''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No privileges found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '100000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P30460_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3634302932397215 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_alignment=>'LEFT',
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
  p_id=> 3625318991944050 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Permissions',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Permissions',
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
  p_id=> 3640309605455926 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Unit',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Unit',
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
  p_id=> 3639722287450115 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Start Date',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Start Date',
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
  p_id=> 3639808878450115 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'End Date',
  p_column_display_sequence=> 5,
  p_column_heading=> 'End Date',
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
  p_id=> 3625418145944050 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Use',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Use',
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
  p_id=> 3625508406944050 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Grant',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Grant',
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
  p_id=> 3639920307450115 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Sub Units',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Sub Units',
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
  p_id=> 3640015728450115 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Granted By',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Granted By',
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
  p_id=> 3640130456450115 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Granted On',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Granted On',
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
  p_id=> 3634424658397217 + wwv_flow_api.g_id_offset,
  p_region_id=> 3625106339944043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 3733515166653215 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30460,
  p_plug_name=> 'Details of Selected Permission',
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
  p_plug_display_when_condition => '(:P30460_SEL_PERM IS NOT NULL OR :P30460_MODE = ''ADD'')'||chr(10)||
'and'||chr(10)||
':P30460_PRIV_ASSIGN_MOD_PRIV = ''Y''',
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
  p_id=> 4001015881730904 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30460,
  p_plug_name=> '&nbsp.',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 20,
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
  p_plug_display_when_condition => ':TAB_ENABLED = ''Y''',
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
  p_id=> 8146131578285637 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30460,
  p_plug_name=> 'Access Denied',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 40,
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 3773905149277915 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30460,
  p_button_sequence=> 90,
  p_button_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Permission',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:AlertForForeignNat();',
  p_button_condition=> ':P30460_LOCK_ADD = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3976215948510309 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30460,
  p_button_sequence=> 100,
  p_button_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_button_name    => 'END_PERMISSION',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'End Permission',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:End();',
  p_button_condition=> ':P30460_SEL_PERM is not null'||chr(10)||
'and'||chr(10)||
':P30460_LOCK_END = ''N'''||chr(10)||
'and'||chr(10)||
':P30460_END_DATE is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3737415430653243 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30460,
  p_button_sequence=> 60,
  p_button_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30460_SEL_PERM is not null'||chr(10)||
'and'||chr(10)||
':P30460_LOCK_SAVE = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3737616564653243 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30460,
  p_button_sequence=> 70,
  p_button_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P30460_SEL_PERM',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16046404342093114 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30460,
  p_button_sequence=> 110,
  p_button_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this, 30460);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3737803556653245 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30460,
  p_button_sequence=> 80,
  p_button_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>90284720742871240 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST LIKE ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 16:22 by THOMAS');
 
wwv_flow_api.create_page_branch(
  p_id=>90284925244872582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_branch_action=> 'f?p=&APP_ID.:30460:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 16:22 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3634614360400523 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_SEL_PERM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sel Perm',
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
  p_id=>3635824187412873 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Mode',
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
  p_id=>3733806758653229 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PERM_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Perm Lov',
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
  p_id=>3734020150653231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PERM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Permission',
  p_source=>'PRIV',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P30460_PERM_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Permission -',
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
  p_read_only_when=>':P30460_SEL_PERM is not null',
  p_read_only_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>3734213872653231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_UNIT_DB_COLUMN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Db Column',
  p_source=>'UNIT',
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
  p_id=>3734431334653231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_INCLUDE_SUB_DB_COLUMN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Include Subord Db Column',
  p_source=>'INCLUDE_SUBORDS',
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
  p_id=>3734623080653232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_USAGE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Usage Lov',
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
  p_id=>3734815397653232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_USAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Usage',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'STATIC2:&P30460_USAGE_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Usage -',
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
  p_id=>3735029530653232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30455_UNIT_SID',
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
  p_id=>3735207534653234 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit',
  p_source=>'OSI_UNIT.GET_NAME(:P30460_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':p30460_usage <> osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'',''ALL'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM'',item_values:''OSI.LOC.UNIT,P30605_UNIT_SID''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3735406382653234 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_UNIT_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(500,''P30460_UNIT_SID'',''N'',''&P30460_UNIT_SID.'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_display_when=>':p30460_usage <> osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'',''ALL'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>3735615106653235 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_USE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Y',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Allow the use of this <br>Permission',
  p_source=>'ENABLED',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>3735809432653235 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_GRANTABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Allow this Permission to be <br>Granted to other Agents',
  p_source=>'GRANTABLE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>3736011480653237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_START_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Start Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'START_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3736220128653237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_END_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'End Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'END_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3736623188653237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PERSONNEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Personnel',
  p_source=>'PERSONNEL',
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
  p_id=>3736812226653239 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PERM_COMPLETE_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
  p_cMaxlength=> 2000,
  p_cHeight=> 4,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXTAREA.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30460_PERM',
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
  p_id=>3737017664653239 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_TEMP',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Temp',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3848507598742107 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_ALLOW_OR_DENY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Allow Or Deny',
  p_source=>'ALLOW_OR_DENY',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:Allow;A,Deny;D',
  p_lov_columns=> 2,
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
  p_display_when_type=>'NEVER',
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
  p_id=>3856408018697904 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_USER_IS_FOREIGN_NAT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'User Is Foreign National',
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
  p_id=>3880209579786465 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PRIV_COMMON_GRANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Priv Common Grant',
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
  p_id=>3880418237789054 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PRIV_ASSIGN_MOD_PRIV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Assign Mod Priv',
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
  p_id=>3945703389331721 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PRIV_GRANT_ON_SEL_PERM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Priv Grant On Current Perm',
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
  p_id=>3947924822385218 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_NO_GRANT_WARMING',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 3733515166653215+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Warming',
  p_source=>'You do not have grant rights for this permission so you cannot modify it.',
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
  p_display_when=>':P30460_PRIV_GRANT_ON_SEL_PERM <> ''Y'''||chr(10)||
'and'||chr(10)||
':P30460_MODE = ''EDIT''',
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
  p_id=>3977204435525882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_LOCK_END',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lock End',
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
  p_id=>3978916706690368 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_LOCK_SAVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lock Save',
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
  p_id=>3984624867881970 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_USER_IS_AGENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'User Is Agent',
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
  p_id=>3985012316897229 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PRIV_USER_CAN_SLF_ADMIN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'User Can Self Admin',
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
  p_id=>3994313616616700 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_LOCK_ADD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lock Add',
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
  p_id=>4000717135721879 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_PERM_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 4001015881730904+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Show Previous Permissions;SPP',
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
  p_id=>4001814196758842 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 4001015881730904+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Filters',
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
  p_id=>8146430747285643 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_ACCESS_DENIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8146131578285637+wwv_flow_api.g_id_offset,
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
  p_id=>16046612307095459 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_name=>'P30460_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 280,
  p_item_plug_id => 3625106339944043+wwv_flow_api.g_id_offset,
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
 
wwv_flow_api.create_page_computation(
  p_id=> 3905315606291400 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_computation_sequence => 10,
  p_computation_item=> 'P30460_INCLUDE_SUB_DB_COLUMN',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> '    if (:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''SPEC'')) then'||chr(10)||
'        return ''N'';'||chr(10)||
'    elsif(:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''SPEC_SUB'')) then'||chr(10)||
'        return ''Y'';'||chr(10)||
'    elsif(:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''ALL'')) then'||chr(10)||
'        return ''Y'';'||chr(10)||
'    else'||chr(10)||
'        return null;'||chr(10)||
'    end if;',
  p_compute_when => 'SAVE,CREATE',
  p_compute_when_type=>'REQUEST_IN_CONDITION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 3905503616297450 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30460,
  p_computation_sequence => 20,
  p_computation_item=> 'P30460_UNIT_DB_COLUMN',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> '    if (:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''SPEC'')) then'||chr(10)||
'        return :p30460_unit_sid;'||chr(10)||
'    elsif(:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''SPEC_SUB'')) then'||chr(10)||
'        return :p30460_unit_sid;'||chr(10)||
'    elsif(:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''ALL'')) then'||chr(10)||
'        return null;'||chr(10)||
'    else'||chr(10)||
'        return null;'||chr(10)||
'    end if;',
  p_compute_when => 'SAVE,CREATE',
  p_compute_when_type=>'REQUEST_IN_CONDITION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 3787631038671989 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'P30460_PERM not null',
  p_validation_sequence=> 10,
  p_validation => 'P30460_PERM',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Permission must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 3734020150653231 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 3903703523240570 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'User Can Grant Permission',
  p_validation_sequence=> 15,
  p_validation => 'declare'||chr(10)||
'    v_ok   varchar2(200);'||chr(10)||
'begin'||chr(10)||
'    v_ok :='||chr(10)||
'        osi_auth.user_can_grant_priv(:p30460_unit_db_column,'||chr(10)||
'                                     :p30460_include_sub_db_column,'||chr(10)||
'                                     :p30460_perm);'||chr(10)||
''||chr(10)||
'    if (v_ok = ''Y'') then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'You do not have permissions to grant this privilege to this user.',
  p_validation_condition=> ':REQUEST in (''CREATE'',''SAVE'')'||chr(10)||
'and'||chr(10)||
':P30460_PERM is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 3734020150653231 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 3788210737675596 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'P30460_USAGE not null',
  p_validation_sequence=> 20,
  p_validation => 'P30460_USAGE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Usage must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 3734815397653232 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 3788410522684959 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'P30460_UNIT_SID not null',
  p_validation_sequence=> 30,
  p_validation => 'P30460_UNIT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit must be specified.',
  p_validation_condition=> ':request in (''SAVE'',''CREATE'')'||chr(10)||
'and'||chr(10)||
':P30460_USAGE <> OSI_REFERENCE.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''ALL'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 3735029530653232 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 3788625413689278 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'P30460_START_DATE not null',
  p_validation_sequence=> 40,
  p_validation => 'P30460_START_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Start Date must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 3736011480653237 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 3788719657697029 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'CREATE - Start Date Cannot be for Past',
  p_validation_sequence=> 80,
  p_validation => 'begin'||chr(10)||
'    if (:p30460_start_date <= sysdate - 2) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The start date cannot be for a past date.',
  p_when_button_pressed=> 3737616564653243 + wwv_flow_api.g_id_offset,
  p_associated_item=> 3736011480653237 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11762115932849528 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'Valid start date',
  p_validation_sequence=> 90,
  p_validation => 'P30460_START_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid start date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30460_START_DATE IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 3736011480653237 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11762331169853896 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'Valid end date',
  p_validation_sequence=> 91,
  p_validation => 'P30460_END_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid end date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30460_END_DATE IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 3736220128653237 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11762824721861545 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_validation_name => 'End date >= start date',
  p_validation_sequence=> 92,
  p_validation => 'begin'||chr(10)||
'    if (to_date(:P30460_END_DATE, ''DD-MON-YYYY HH24:MI'') >='||chr(10)||
'                                         to_date(:P30460_START_DATE, ''DD-MON-YYYY HH24:MI'')) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'exception'||chr(10)||
'    when others then'||chr(10)||
'        -- Return true because if an exception is thrown here then the validation that looks for a valid date will have failed.'||chr(10)||
'        return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'End date must be >= start date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30460_END_DATE IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 3736220128653237 + wwv_flow_api.g_id_offset,
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
p:=p||'begin'||chr(10)||
'    if (:request in(''ADD'')) then'||chr(10)||
'        :p30460_mode := ''ADD'';'||chr(10)||
'    elsif (:request like ''EDIT%'') then'||chr(10)||
'        :p30460_mode := ''EDIT'';'||chr(10)||
'    elsif (:request in(''SAVE'',''CANCEL'')) then'||chr(10)||
'        :p30460_mode := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3635311028409092 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 140,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set mode',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P30460_UNIT_SID,UPDATE',
  p_process_when_type=>'REQUEST_NOT_IN_CONDITION',
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
'    if (:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'',''SPEC'')) then'||chr(10)||
'        :p30460_unit_db_column := :p30460_unit_sid;'||chr(10)||
'        :p30460_include_sub_db_column := ''N'';'||chr(10)||
'    elsif(:p30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'',''SPEC_SUB'')) then'||chr(10)||
'        :p30460_unit_db_column := :p30460_unit_sid;'||chr(10)||
'        :p30460_include_sub_db_column := ''Y'';'||chr(10)||
'    elsif(:p';

p:=p||'30460_usage = osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'',''ALL'')) then'||chr(10)||
'        :p30460_unit_db_column := null;'||chr(10)||
'        :p30460_include_sub_db_column := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        :p30460_unit_db_column := null;'||chr(10)||
'        :p30460_include_sub_db_column := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3772421940244892 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 150,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Pre-ARP',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SAVE,CREATE',
  p_process_when_type=>'NEVER',
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
p:=p||'#OWNER#:T_OSI_PERSONNEL_PRIV:P30460_SEL_PERM:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 3772731075256926 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 160,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'ARP - Create Only',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CREATE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30460_SEL_PERM',
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
'    :P30460_sel_perm := osi_auth.change_permission(:p30460_sel_perm,'||chr(10)||
'                               :p30460_perm,'||chr(10)||
'                               :p30460_unit_db_column,'||chr(10)||
'                               to_date(:p30460_start_date, :fmt_date),'||chr(10)||
'                               to_date(:p30460_end_date, :fmt_date),'||chr(10)||
'                               :p30460_use,'||chr(10)||
'                               :p30460_gr';

p:=p||'antable,'||chr(10)||
'                               :p30460_include_sub_db_column,'||chr(10)||
'                               :P30460_allow_or_deny);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3973716435245495 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 170,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Change Permission (Instead of ARP)',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>3737415430653243 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '&SUCCESS_MSG.',
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
'    update t_osi_personnel_priv'||chr(10)||
'       set end_date = sysdate'||chr(10)||
'     where sid = :p30460_sel_perm;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 4447114290691639 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 180,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'End Permission',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'END',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
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
p:=p||'P30460_PERM,P30460_USAGE,P30460_UNIT_SID,P30460_USE,P30460_GRANTABLE,P30460_START_DATE,P30460_END_DATE,P30460_UNIT_DB_COLUMN,P30460_INCLUDE_SUB_DB_COLUMN,P30460_ALLOW_OR_DENY';

wwv_flow_api.create_page_process(
  p_id     => 3773522680273501 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 190,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Perm Fields - On Cancel',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>3737803556653245 + wwv_flow_api.g_id_offset,
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
p:=p||'P30460_SEL_PERM,P30460_PERM,P30460_USAGE,P30460_UNIT_SID,P30460_USE,P30460_GRANTABLE,P30460_START_DATE,P30460_END_DATE,P30460_UNIT_DB_COLUMN,P30460_INCLUDE_SUB_DB_COLUMN,P30460_ALLOW_OR_DENY';

wwv_flow_api.create_page_process(
  p_id     => 3773026704265143 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 195,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Perm Fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''ADD'',''DELETE'') or :REQUEST like ''EDIT_%''',
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
p:=p||':P30460_SEL_PERM := substr(:REQUEST,6);';

wwv_flow_api.create_page_process(
  p_id     => 3635515530410315 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 200,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Permission',
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
p:=p||'begin'||chr(10)||
'    if (   osi_auth.check_for_priv(''TAB_PRIV'', :p0_obj_type_sid) = ''Y'''||chr(10)||
'        or osi_auth.check_for_priv(''TAB_ALL'', :p0_obj_type_sid) = ''Y'') then'||chr(10)||
'        :tab_enabled := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        :tab_enabled := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8146501580286467 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 30,
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
'    if (instr(:P30460_PERM_FILTER, ''SPP'') <= 0 or'||chr(10)||
'       :P30460_PERM_FILTER is null) then'||chr(10)||
'        --If show others is checked'||chr(10)||
'        :p30460_filter :='||chr(10)||
'            '' where at.sid = ap.action and ot.sid = ap.obj_type and pp.priv = ap.sid and pp.personnel = '''''' || :p0_obj || '''''' and end_date is null'';'||chr(10)||
'    else'||chr(10)||
'--Do not shown ENDED perms'||chr(10)||
'        :p30460_filter :='||chr(10)||
'            '' where at.sid = a';

p:=p||'p.action and ot.sid = ap.obj_type and pp.priv = ap.sid and pp.personnel = '''''' || :p0_obj || '''''''';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 4000830641725790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 40,
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
p:=p||'F|#OWNER#:T_OSI_PERSONNEL_PRIV:P30460_SEL_PERM:SID';

wwv_flow_api.create_page_process(
  p_id     => 3769418075139654 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 130,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
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
'    :p30460_perm_lov := osi_auth.get_perm_lov;'||chr(10)||
'    :p30460_usage_lov := osi_reference.get_lov(''PERSONNEL_PERM_USAGE'');'||chr(10)||
'    --Role Description'||chr(10)||
'    :p30460_perm_complete_desc := osi_auth.get_perm_complete_description(:p30460_perm);'||chr(10)||
''||chr(10)||
'    --Get Unit Sid'||chr(10)||
'    if (:request <> ''P30460_UNIT_SID'') then'||chr(10)||
'        :p30460_unit_sid := osi_personnel.get_current_unit(:P30460_PERSONNEL);'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Ge';

p:=p||'t Foreign National Status'||chr(10)||
'    :P30460_USER_IS_FOREIGN_NAT := osi_personnel.user_is_foreign_nat(:P0_obj);'||chr(10)||
''||chr(10)||
'    --Get Privileges'||chr(10)||
'    :P30460_PRIV_COMMON_GRANT :=     osi_auth.check_for_priv(''PMM_COMMON'', :P0_obj_type_sid);'||chr(10)||
'    :P30460_PRIV_ASSIGN_MOD_PRIV :=  osi_auth.check_for_priv(''PMM_MODPRV'', :P0_obj_type_sid);'||chr(10)||
'    :P30460_PRIV_USER_CAN_SLF_ADMIN:=  osi_auth.check_for_priv(''PMM_SLFROL'', :P0_obj_';

p:=p||'type_sid);'||chr(10)||
''||chr(10)||
'    --Stuff for New Items'||chr(10)||
'    if (:p30460_mode = ''ADD'' and :request <> ''P30460_UNIT_SID'') then'||chr(10)||
'        if (:p30460_usage is null) then'||chr(10)||
'            --Only need to default it if it is blank'||chr(10)||
'            :p30460_usage := osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''SPEC_SUB'');'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p30460_unit_db_column := osi_personnel.get_current_unit(core_context.personnel_';

p:=p||'sid);'||chr(10)||
'        :p30460_personnel := :P0_obj;'||chr(10)||
'        :p30460_unit_sid := osi_personnel.get_current_unit(:P30460_PERSONNEL); '||chr(10)||
'        :P30460_allow_or_deny := ''A'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Determine of currently logged in user is the user we are looking at'||chr(10)||
'    --Note, if they are, we then have to take into account the PMM_SLFROL permission'||chr(10)||
'    if (:P0_OBJ = core_context.personnel_sid) then'||chr(10)||
'        :P30460';

p:=p||'_user_is_agent := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        :P30460_user_is_agent := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3744408427764829 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 140,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Parameters',
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
'    --Set Usage Column'||chr(10)||
'    if (:p30460_unit_db_column is not null) then'||chr(10)||
'        if (:p30460_include_sub_db_column = ''Y'') then'||chr(10)||
'            :p30460_usage := osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''SPEC_SUB'');'||chr(10)||
'        else'||chr(10)||
'            :p30460_usage := osi_reference.lookup_ref_sid(''PERSONNEL_PERM_USAGE'', ''SPEC'');'||chr(10)||
'        end if;'||chr(10)||
'    else'||chr(10)||
'        :p30460_usage := osi_reference.looku';

p:=p||'p_ref_sid(''PERSONNEL_PERM_USAGE'', ''ALL'');'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3744612583766053 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 150,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Usage Item',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST not in (''P30460_USAGE'',''P30460_UNIT_SID'',''UPDATE'')'||chr(10)||
'and'||chr(10)||
':P30460_MODE = ''EDIT''',
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
''||chr(10)||
''||chr(10)||
'   :P30460_PRIV_GRANT_ON_SEL_PERM := osi_auth.user_can_grant_priv(:p30460_unit_db_column,'||chr(10)||
'                                     :p30460_include_sub_db_column,'||chr(10)||
'                                     :p30460_perm);'||chr(10)||
''||chr(10)||
'    '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3946126938338509 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 210,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check If User Has Grant On Current Perm',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
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
p:=p||'    --Unlock unless we can find a reason to'||chr(10)||
'    :P30460_LOCK_ADD  := ''N'';'||chr(10)||
'    :P30460_LOCK_END  := ''N'';'||chr(10)||
'    :P30460_LOCK_SAVE := ''N'';'||chr(10)||
''||chr(10)||
'    --See if they have permission to assign and modify privileges'||chr(10)||
'    if (:P30460_PRIV_ASSIGN_MOD_PRIV <> ''Y'') then'||chr(10)||
'      :P30460_LOCK_ADD  := ''Y'';'||chr(10)||
'      :P30460_LOCK_END  := ''Y'';'||chr(10)||
'      :P30460_LOCK_SAVE := ''Y'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --See if the end date is filled in'||chr(10)||
' ';

p:=p||'   if(:P30460_end_date is not null) then'||chr(10)||
'      :P30460_LOCK_SAVE:= ''Y'';'||chr(10)||
'      :P30460_LOCK_END  := ''Y'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'   --See if user can modify the currently selected perm'||chr(10)||
'   if (:P30460_PRIV_GRANT_ON_SEL_PERM = ''N'') then'||chr(10)||
'      :P30460_LOCK_SAVE:= ''Y'';'||chr(10)||
'      :P30460_LOCK_END  := ''Y'';'||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   --See if the user currently logged in is the same as the object being edited'||chr(10)||
'   --If so, then this ';

p:=p||'user must have SELF ADMIN privileges or they completely are locked out'||chr(10)||
'   if (:P30460_USER_IS_AGENT = ''Y'' and :P30460_PRIV_USER_CAN_SLF_ADMIN = ''N'') then'||chr(10)||
'      :P30460_LOCK_ADD  := ''Y'';'||chr(10)||
'      :P30460_LOCK_END  := ''Y'';'||chr(10)||
'      :P30460_LOCK_SAVE := ''Y'';'||chr(10)||
'   end if;';

wwv_flow_api.create_page_process(
  p_id     => 3977325560532035 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30460,
  p_process_sequence=> 220,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check For Page Locking',
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
-- ...updatable report columns for page 30460
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



--- 009-Bug_0634_relationship_to_self                ---
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
--   Date and Time:   16:02 Friday January 7, 2011
--   Exported By:     JASON
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.12
 
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

PROMPT ...Remove page 30045
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30045);
 
end;
/

 
--application/pages/page_30045
prompt  ...PAGE 30045: Participant Relationships
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_LOCATOR"'||chr(10)||
'"JS_PRECISION_DATE"';

wwv_flow_api.create_page(
  p_id     => 30045,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Participant Relationships',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title => 'Participant Relationships',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'JASON',
  p_last_upd_yyyymmddhh24miss => '20110107160118',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-JAN-2011 J.Faris - (Bug 0634) Added ''excludes'' list to participant selector to prevent creating a relationship to self. ');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30045,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select r.sid, rt.description as "Relationship",'||chr(10)||
'       decode(:p30045_obj,'||chr(10)||
'              r.partic_a, osi_object.get_tagline_link(r.partic_b),'||chr(10)||
'              r.partic_b, osi_object.get_tagline_link(r.partic_a)) as "Participant",'||chr(10)||
'       osi_participant.get_relation_specifics(r.sid) as "Specifics",'||chr(10)||
'       decode(r.sid, :p30045_sid, ''Y'', ''N'') as "Current"'||chr(10)||
'  from t_osi_partic_relation r, t_osi_partic_re';

s:=s||'lation_type rt'||chr(10)||
' where (r.partic_a = :p30045_obj and r.rel_type = rt.sid)'||chr(10)||
'    or (r.partic_b = :p30045_obj and r.rel_type = rt.other_sid)';

wwv_flow_api.create_report_region (
  p_id=> 96304721637569468 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30045,
  p_name=> 'Relationships to Other Participants',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No relationships found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P30045_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96519208714770207 + wwv_flow_api.g_id_offset,
  p_region_id=> 96304721637569468 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
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
  p_id=> 96305138294569474 + wwv_flow_api.g_id_offset,
  p_region_id=> 96304721637569468 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Relationship',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Relationship',
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
  p_id=> 96571918148154407 + wwv_flow_api.g_id_offset,
  p_region_id=> 96304721637569468 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Participant',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Participant',
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
  p_id=> 96519533264824653 + wwv_flow_api.g_id_offset,
  p_region_id=> 96304721637569468 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Specifics',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Specifics',
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
  p_id=> 96519926469832159 + wwv_flow_api.g_id_offset,
  p_region_id=> 96304721637569468 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 5,
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 96306528348580793 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30045,
  p_plug_name=> 'Details of Selected Relationship',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
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
  p_plug_display_when_condition => ':P30045_SID IS NOT NULL OR :P30045_MODE = ''ADD''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 96323424566806876 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30045,
  p_button_sequence=> 10,
  p_button_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Relationship',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96323611539806879 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30045,
  p_button_sequence=> 20,
  p_button_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30045_SID IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96323812224806879 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30045,
  p_button_sequence=> 30,
  p_button_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30045_SID IS NOT NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96324011394806879 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30045,
  p_button_sequence=> 40,
  p_button_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P30045_SID IS NOT NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15988106654535482 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30045,
  p_button_sequence=> 60,
  p_button_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this, 30045);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96324236862806879 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30045,
  p_button_sequence=> 50,
  p_button_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>94593824294115667 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST LIKE ''TAB_%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2009 14:48 by THOMAS');
 
wwv_flow_api.create_page_branch(
  p_id=>94594018125115668 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_branch_action=> 'f?p=&APP_ID.:30045:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2009 14:48 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5962615079248517 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_START_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 108,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_format_mask=>'YYYYMMDDHH24MISS',
  p_source=>'START_DATE',
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
  p_id=>5962831355253189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_END_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 111,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_format_mask=>'YYYYMMDDHH24MISS',
  p_source=>'END_DATE',
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
  p_id=>5963107591255839 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_KNOWN_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 116,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_format_mask=>'YYYYMMDDHH24MISS',
  p_source=>'KNOWN_DATE',
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
  p_id=>15994613581537462 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
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
  p_id=>21126008024324682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_EXCLUDE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
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
  p_id=>96308436706611582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30045_SID=',
  p_source=>'SID',
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
  p_id=>96308717444615567 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30045_OBJ=',
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
  p_id=>96309127487618409 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
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
  p_id=>96310814159652437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_RELATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Relationship',
  p_source=>'P30045_REL_TYPE',
  p_source_type=> 'ITEM',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_partic_relation_type'||chr(10)||
' where active = ''Y'''||chr(10)||
'    or sid = :p30045_relation'||chr(10)||
'order by 1',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Relationship -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
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
  p_id=>96311016839652437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_PARTICIPANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Participant',
  p_source=>'osi_participant.get_name(:p30045_sel_partic);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 110,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
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
  p_id=>96311234149652437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_PARTIC_FIND',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 106,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(400,''P30045_SEL_PARTIC'',''N'',''&P30045_EXCLUDE.'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
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
  p_id=>96311414380652437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_PARTIC_VIEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 107,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Participant" href="'' || '||chr(10)||
'osi_object.get_object_url(:P30045_PARTICIPANT_VER) ||'||chr(10)||
'''">&ICON_MAGNIFY.</a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30045_PARTICIPANT_VER',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>96311608955652439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_START_DATE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Start Date',
  p_post_element_text=>'<a href="javascript:precisionDate(''P30045_START_DATE'');">&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:P30045_START_DATE,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
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
  p_id=>96311827751652439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_END_DATE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'End Date',
  p_post_element_text=>'<a href="javascript:precisionDate(''P30045_END_DATE'');">&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p30045_end_date,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
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
  p_id=>96312030196652439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_KNOWN_DATE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Known Date',
  p_post_element_text=>'<a href="javascript:precisionDate(''P30045_KNOWN_DATE'');">&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p30045_known_date,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
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
  p_id=>96312236850652439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_COMMENTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Comments',
  p_source=>'COMMENTS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 30000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>96312524894655504 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_SEL_PARTIC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30045_SEL_PARTIC=',
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
  p_id=>96487108359994212 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD1_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96487326296994232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96487538166994232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96488821698035921 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD1_REQD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96489034671035921 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD2_REQD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96489208646035923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD3_REQD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 21,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96501222512320045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD1_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P30045_MOD1_LABEL.',
  p_source=>'P30045_MOD1',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 110,
  p_cMaxlength=> 1000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30045_MOD1_LABEL IS NOT NULL AND :P30045_MOD1_REQD = ''N''',
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
  p_id=>96501411804320045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD2_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P30045_MOD2_LABEL.',
  p_source=>'P30045_MOD2',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 110,
  p_cMaxlength=> 1000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30045_MOD2_LABEL IS NOT NULL AND :P30045_MOD2_REQD = ''N''',
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
  p_id=>96501636898320046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD3_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P30045_MOD3_LABEL.',
  p_source=>'P30045_MOD3',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 110,
  p_cMaxlength=> 1000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30045_MOD3_LABEL IS NOT NULL AND :P30045_MOD3_REQD = ''N''',
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
  p_id=>96501830817320046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD1_VALUE_REQ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 126,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P30045_MOD1_LABEL.',
  p_source=>'P30045_MOD1',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 110,
  p_cMaxlength=> 1000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30045_MOD1_REQD = ''Y''',
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
  p_id=>96502036646320046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD2_VALUE_REQ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 131,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P30045_MOD2_LABEL.',
  p_source=>'P30045_MOD2',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 110,
  p_cMaxlength=> 1000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30045_MOD2_REQD = ''Y''',
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
  p_id=>96502215762320046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD3_VALUE_REQ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 136,
  p_item_plug_id => 96306528348580793+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P30045_MOD3_LABEL.',
  p_source=>'P30045_MOD3',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 110,
  p_cMaxlength=> 1000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 3,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30045_MOD3_REQD = ''Y''',
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
  p_id=>96504928446350121 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'MOD1_VALUE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96505112426350123 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'MOD2_VALUE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>96505326512350123 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_MOD3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'MOD3_VALUE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>97992007459283206 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_PARTIC_A',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30045_PARTIC_A=',
  p_source=>'PARTIC_A',
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
  p_id=>97992318195286332 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_PARTIC_B',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30045_PARTIC_B=',
  p_source=>'PARTIC_B',
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
  p_id=>98025029499406110 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_OTHER_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30045_OTHER_SID=',
  p_source=>'select rt.other_sid'||chr(10)||
'from t_osi_partic_relation r,'||chr(10)||
'     t_osi_partic_relation_type rt'||chr(10)||
'where r.sid = :p30045_sid'||chr(10)||
'  and r.rel_type = rt.sid;',
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
  p_id=>98039923884499076 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_name=>'P30045_REL_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 96304721637569468+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30045_REL_TYPE=',
  p_source=>'REL_TYPE',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 9653506901500446 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30045,
  p_computation_sequence => 10,
  p_computation_item=> 'P30045_OBJ',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'ITEM_VALUE',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'P0_OBJ',
  p_compute_when => '',
  p_compute_when_type=>'%null%');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96439417452459253 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_validation_name => 'P30045_RELATION Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P30045_RELATION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Relationship must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96310814159652437 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 30-JUL-2009 09:46');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96439633481459254 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_validation_name => 'P30045_SEL_PARTIC Not Null',
  p_validation_sequence=> 2,
  p_validation => 'P30045_SEL_PARTIC',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Participant must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96311016839652437 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 30-JUL-2009 09:46');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96510927594463439 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_validation_name => 'P30045_MOD1_VALUE_REQ Not Null',
  p_validation_sequence=> 3,
  p_validation => 'P30045_MOD1_VALUE_REQ',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P30045_MOD1_LABEL. must be specified.',
  p_validation_condition=> ':P30045_MOD1_REQD = ''Y'' AND :REQUEST IN (''CREATE'',''SAVE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 96501830817320046 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 31-JUL-2009 10:47');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96511130227463443 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_validation_name => 'P30045_MOD2_VALUE_REQ Not Null',
  p_validation_sequence=> 4,
  p_validation => 'P30045_MOD2_VALUE_REQ',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P30045_MOD2_LABEL. must be specified.',
  p_validation_condition=> ':P30045_MOD2_REQD = ''Y'' AND :REQUEST IN (''CREATE'',''SAVE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 96502036646320046 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 31-JUL-2009 10:47');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96511333684463443 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_validation_name => 'P30045_MOD3_VALUE_REQ Not Null',
  p_validation_sequence=> 5,
  p_validation => 'P30045_MOD3_VALUE_REQ',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P30045_MOD3_LABEL. must be specified.',
  p_validation_condition=> ':P30045_MOD3_REQD = ''Y'' AND :REQUEST IN (''CREATE'',''SAVE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 96502215762320046 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 31-JUL-2009 10:47');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||':P30045_SID := substr(:request,6);';

wwv_flow_api.create_page_process(
  p_id     => 96338235497999220 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select row',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':request like ''EDIT_%''',
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
'  if(:request in (''ADD'',''P30045_RELATION'',''P30045_SEL_PARTIC'',''P30045_START_DATE'','||chr(10)||
'                  ''P30045_END_DATE'',''P30045_KNOWN_DATE''))then'||chr(10)||
'     :p30045_mode := ''ADD'';'||chr(10)||
'  else'||chr(10)||
'     :p30045_mode := null;'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 96320536378762901 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 2,
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
p:=p||'begin'||chr(10)||
'    if (:p30045_obj = :p30045_partic_b) then'||chr(10)||
'        -- We must be editing a relationship created'||chr(10)||
'        -- from the other participant.'||chr(10)||
'        :p30045_partic_a := :p30045_sel_partic;'||chr(10)||
''||chr(10)||
'        if (:p30045_relation = :p30045_rel_type) then'||chr(10)||
'            :p30045_rel_type := :p30045_other_sid;'||chr(10)||
'        else'||chr(10)||
'            select nvl(rt.other_sid, rt.sid)'||chr(10)||
'              into :p30045_rel_type'||chr(10)||
'         ';

p:=p||'     from t_osi_partic_relation_type rt'||chr(10)||
'             where rt.sid = :p30045_relation;'||chr(10)||
'        end if;'||chr(10)||
'    else'||chr(10)||
'        -- We''re creating/editing a relationship to us.'||chr(10)||
'        :p30045_partic_a := :p30045_obj;'||chr(10)||
'        :p30045_partic_b := :p30045_sel_partic;'||chr(10)||
'        :p30045_rel_type := :p30045_relation;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 98013528292743379 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 3,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get hidden items',
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
p:=p||'begin'||chr(10)||
'    if (:p30045_mod1_reqd = ''Y'') then'||chr(10)||
'        :p30045_mod1 := :p30045_mod1_value_reqd;'||chr(10)||
'    else'||chr(10)||
'        :p30045_mod1 := :p30045_mod1_value;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p30045_mod2_reqd = ''Y'') then'||chr(10)||
'        :p30045_mod2 := :p30045_mod2_value_reqd;'||chr(10)||
'    else'||chr(10)||
'        :p30045_mod2 := :p30045_mod2_value;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p30045_mod3_reqd = ''Y'') then'||chr(10)||
'        :p30045_mod3 := :p30045_mod3_value_reqd;'||chr(10)||
' ';

p:=p||'   else'||chr(10)||
'        :p30045_mod3 := :p30045_mod3_value;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 96532031673609553 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get mod values',
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
p:=p||'#OWNER#:T_OSI_PARTIC_RELATION:P30045_SID:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 96322730668799135 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Do T_OSI_PARTIC_RELATION',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,SAVE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30045_SID',
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
'    if (:request in(''ADD'', ''DELETE'')) then'||chr(10)||
'        :p30045_sid := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request in (''ADD'', ''DELETE'') or :request like ''EDIT_%'')then'||chr(10)||
'        :p30045_sel_partic := null;'||chr(10)||
'        :p30045_participant := null;'||chr(10)||
'        :p30045_partic_a := null;'||chr(10)||
'        :p30045_partic_b := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request in (''ADD'', ''CANCEL'') or :request like ''EDIT_%'') then'||chr(10)||
'        :p30045_';

p:=p||'sel_partic := :p30045_partic_b;'||chr(10)||
'        :p30045_relation := null;'||chr(10)||
'        :p30045_rel_type := null;'||chr(10)||
'        :p30045_start_date := null;'||chr(10)||
'        :p30045_end_date := null;'||chr(10)||
'        :p30045_known_date := null;'||chr(10)||
'        :p30045_start_date_display := null;'||chr(10)||
'        :p30045_end_date_display := null;'||chr(10)||
'        :p30045_known_date_display := null;'||chr(10)||
'        :p30045_comments := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request ';

p:=p||'= ''ADD'') then'||chr(10)||
'        :p30045_mod1_label := null;'||chr(10)||
'        :p30045_mod2_label := null;'||chr(10)||
'        :p30045_mod3_label := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request in (''P30045_RELATION'', ''ADD'', ''CANCEL'')or :request like ''EDIT_%'') then'||chr(10)||
'        :p30045_mod1_value := null;'||chr(10)||
'        :p30045_mod2_value := null;'||chr(10)||
'        :p30045_mod3_value := null;'||chr(10)||
'        :p30045_mod1 := null;'||chr(10)||
'        :p30045_mod2 := null;'||chr(10)||
'        :';

p:=p||'p30045_mod3 := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 96322321187786964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 99,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear items',
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
'    v_sids   varchar2(5000) := ''SIDS_'';'||chr(10)||
'begin'||chr(10)||
'    for x in (select sid'||chr(10)||
'                from t_osi_participant_version'||chr(10)||
'               where participant = :p0_obj)'||chr(10)||
'    loop'||chr(10)||
'        v_sids := v_sids || ''~'' || x.sid;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    :p30045_exclude := v_sids;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 21128202979484084 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 1,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Pre-Load Items',
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
p:=p||'F|#OWNER#:T_OSI_PARTIC_RELATION:P30045_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 96322514045794318 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF T_OSI_PARTIC_RELATION',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P30045_SID IS NOT NULL AND'||chr(10)||
'(:REQUEST <> ''P30045_RELATION'' OR :REQUEST NOT LIKE ''%DATE%'')',
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
'    select mod1_name, mod1_reqd,'||chr(10)||
'           mod2_name, mod2_reqd,'||chr(10)||
'           mod3_name, mod3_reqd'||chr(10)||
'      into :p30045_mod1_label, :p30045_mod1_reqd,'||chr(10)||
'           :p30045_mod2_label, :p30045_mod2_reqd,'||chr(10)||
'           :p30045_mod3_label, :p30045_mod3_reqd'||chr(10)||
'      from t_osi_partic_relation_type'||chr(10)||
'     where sid = nvl(:p30045_relation,:p30045_rel_type);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 97986335987950765 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 5.5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get mod labels when relation changes',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':p30045_relation is not null or :p30045_rel_type is not null',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_when2=>':request = ''P30045_RELATION'' and ',
  p_process_when_type2=>'',
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
'    select mod1_name, mod1_reqd,'||chr(10)||
'           mod2_name, mod2_reqd,'||chr(10)||
'           mod3_name, mod3_reqd'||chr(10)||
'      into :p30045_mod1_label, :p30045_mod1_reqd,'||chr(10)||
'           :p30045_mod2_label, :p30045_mod2_reqd,'||chr(10)||
'           :p30045_mod3_label, :p30045_mod3_reqd'||chr(10)||
'      from t_osi_partic_relation_type'||chr(10)||
'     where sid = :p30045_rel_type;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 98010717455607757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 6,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get mod labels when EDITing',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':request like ''EDIT_%''',
  p_process_when_type=>'NEVER',
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
'    if (:p30045_obj = :p30045_partic_a) then'||chr(10)||
'        :p30045_sel_partic := :p30045_partic_b;'||chr(10)||
''||chr(10)||
'        select rt.sid'||chr(10)||
'          into :p30045_relation'||chr(10)||
'          from t_osi_partic_relation r, t_osi_partic_relation_type rt'||chr(10)||
'         where r.sid = :p30045_sid'||chr(10)||
'           and r.partic_a = :p30045_obj'||chr(10)||
'           and r.rel_type = rt.sid;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p30045_obj = :p30045_partic_b) then'||chr(10)||
'       ';

p:=p||' :p30045_sel_partic := :p30045_partic_a;'||chr(10)||
''||chr(10)||
'        select rt.sid'||chr(10)||
'          into :p30045_relation'||chr(10)||
'          from t_osi_partic_relation r, t_osi_partic_relation_type rt'||chr(10)||
'         where r.sid = :p30045_sid'||chr(10)||
'           and r.partic_b = :p30045_obj'||chr(10)||
'           and r.rel_type = rt.other_sid;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 97994631017365665 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30045,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Compute relationship',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':request like ''EDIT_%'' or :request = ''CANCEL''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30045
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




--- 013-CFunds Form 29                               ---


--- 014-Reloading_page_on_status_change_bug_fix      ---
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
--   Date and Time:   11:00 Thursday January 13, 2011
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

PROMPT ...Remove page 5450
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5450);
 
end;
/

 
--application/pages/page_05450
prompt  ...PAGE 5450: Status Change Widget
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<!-- This has to be declared above any reference to submodal scripts. -->'||chr(10)||
'<script type="text/javascript">var imgPrefix = ''#IMAGE_PREFIX#'';</script>'||chr(10)||
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMA';

ph:=ph||'GE_PREFIX#/themes/OSI/submodal/subModal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
''||chr(10)||
'"JS_POPUP_LOCATOR"'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
'function closeThis(){'||chr(10)||
'    /*'||chr(10)||
'    var xbox = window.top.document.getElementById(''popCloseBox'');'||chr(10)||
'    xbox.click();'||chr(10)||
'    */'||chr(10)||
'    window.top.hidePopWin();'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'if (''&P5450_DONE.'' == ''Y'')';

ph:=ph||'{'||chr(10)||
'    var cloning = 0;'||chr(10)||
'    var open_new = false;'||chr(10)||
''||chr(10)||
'    switch (''&P5450_STATUS_CHANGE_DESC.'') {'||chr(10)||
'      case ''Clone Activity'': '||chr(10)||
'              cloning = 1; '||chr(10)||
'              alert(''Click OK to open the cloned activity.''); '||chr(10)||
'              break;'||chr(10)||
'      case ''Create Case'': '||chr(10)||
'              cloning = 1; '||chr(10)||
'              alert(''Click OK to open the case file.''); '||chr(10)||
'              break;'||chr(10)||
'      case ''Migrate to Existing';

ph:=ph||' Source'':'||chr(10)||
'              open_new = confirm(''This source has been migrated to '' + ''&P5450_SOURCE_ID.'' + '', would you like to open it?'');'||chr(10)||
'              break;'||chr(10)||
'      default: '||chr(10)||
'              break;'||chr(10)||
'     }'||chr(10)||
''||chr(10)||
'    if(''&P5450_STATUS_CHANGE_DESC.'' == ''Migrate to Existing Source''){'||chr(10)||
'        window.parent.close();'||chr(10)||
'        /*opener.close();*/'||chr(10)||
'    }else{'||chr(10)||
'        if (cloning == 0 & open_new == false) '||chr(10)||
'          {';

ph:=ph||''||chr(10)||
'           window.parent.doSubmit(''RELOAD'');'||chr(10)||
'           /*opener.doSubmit(''RELOAD'');*/'||chr(10)||
'          }'||chr(10)||
'    }'||chr(10)||
'    '||chr(10)||
'    if (cloning == 1 || open_new == true){'||chr(10)||
'         newWindow({page:''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'                    clear_cache:''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'                    name:''&P5450_CLONE_NEW_SID.'', item_names:''P0_OBJ'', '||chr(10)||
'                    item_values:''&P5450_CLONE_NEW_S';

ph:=ph||'ID.'', '||chr(10)||
'                    request:''OPEN''});'||chr(10)||
'    }'||chr(10)||
'   '||chr(10)||
'    if(''&P5450_STATUS_CHANGE_DESC.'' == ''Approve File'' & ''&P5450_OBJ_TYPE.'' == ''Case''){'||chr(10)||
'        window.location = ''f?p=&APP_ID.:800:&SESSION.::::P800_REPORT_TYPE,P0_OBJ:&P5450_REPORT_TYPE.,&P0_OBJ.'';'||chr(10)||
'   }'||chr(10)||
'   else {'||chr(10)||
'        closeThis();'||chr(10)||
'   }'||chr(10)||
'   '||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 5450,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Status Change Widget',
  p_step_title=> 'Status Change Widget',
  p_step_sub_title => 'Status Change Widget',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="JavaScript" type="text/javascript">'||chr(10)||
'if (''&P5450_SHOW_CONFIRM.'' == ''Y''){'||chr(10)||
'    newWindow({page:''30135'', '||chr(10)||
'           clear_cache:''30135'', '||chr(10)||
'           name:''CONFIRM_'' + ''&P5450_CONFIRM_SESSION.'','||chr(10)||
'           item_names:''P30135_SC_SID,P30135_SESSION,P30135_CONFIRM_ALLOWED'', '||chr(10)||
'           item_values:''&P5450_STATUS_CHANGE_SID.,&P5450_CONFIRM_SESSION.,&P5450_CONFIRM_ALLOWED.'', '||chr(10)||
'           request:''OPEN''});'||chr(10)||
'javascript:closeThis();'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110113105950',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '11-MAY-2010  Jason Faris     Added conditional ''RPO Unit'' selector for Criminal Poly File Support.'||chr(10)||
'04-JUN-2010  Tim McGuffin    Added audit logging of status changes.'||chr(10)||
''||chr(10)||
'01-JAN-2011  Jason Faris    An update was made to the javascript on P5450 HTML Header to prevent a reload of the page in the case of a clone or Migrate Source action.'');'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5450,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 13476723894407034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Effective Date',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 27,
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
  p_plug_display_when_condition => ':P5450_DATE_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null'||chr(10)||
'and'||chr(10)||
':P5450_CHECKLIST_COMPLETE = ''Y''',
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
  p_id=> 90144213595465317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Comment',
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
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
'(:P5450_NOTE_REQUIRED = ''O'' or :P5450_NOTE_REQUIRED = ''R'')'||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 90157609856244248 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Parameter Stuff',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
  p_id=> 90159622370276293 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Checklist Information',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_PRE_PROCESS_CHECK is null',
  p_plug_footer=> '<script language="JavaScript" type="text/javascript">'||chr(10)||
'if ($v(''P5450_AUTHORIZED'')==''N''){'||chr(10)||
'   alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'   closeThis();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'</script>',
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
  p_id=> 90163324027371415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Confirmation - &P5450_STATUS_CHANGE_DESC.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 25,
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
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 90589130294220195 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Unit Assignment',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 22,
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
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_UNIT_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 91382720890965764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Access Verification - The following problems were found:',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
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
  p_plug_display_when_condition => ':P5450_PRE_PROCESS_CHECK is not null',
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
  p_id=> 93419223048540671 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Item',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
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
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 90144619756465332 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 5,
  p_button_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_CHECKLIST',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90162412683349201 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 10,
  p_button_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_NOTE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90144434019465328 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 20,
  p_button_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_NOTE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90164025805400273 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 30,
  p_button_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_CONFIRM',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_NOTE_REQUIRED = ''N'''||chr(10)||
'and'||chr(10)||
':P5450_DATE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90164529053410734 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 40,
  p_button_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_CONFIRM',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_NOTE_REQUIRED = ''N'''||chr(10)||
'and'||chr(10)||
':P5450_DATE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91385514124200345 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 50,
  p_button_plug_id => 91382720890965764+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_PRE_PROCESS',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13478806935477865 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 70,
  p_button_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_DATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_NOTE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13479011437479185 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 80,
  p_button_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_DATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5450_NOTE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16896902164612353 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 90,
  p_button_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_button_name    => 'SHOW_CHECKLIST',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Show Checklist',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>16897229522620264 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_branch_action=> 'f?p=&APP_ID.:5500:&SESSION.::&DEBUG.:5500:P5500_STATUS_CHANGE_SID,P0_OBJ:&P5450_STATUS_CHANGE_SID.,&P0_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>16896902164612353+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-OCT-2010 15:56 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>90145506390465349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_branch_action=> 'f?p=&APP_ID.:5450:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-MAY-2009 12:19 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3363806060047418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_AUTHORIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>3364312256096601 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_AUTH_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>3548722741431534 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CONFIRM_ALLOWED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>4856518545297114 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'begin'||chr(10)||
'  case '||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''FILE.POLY_FILE.CRIM'' '||chr(10)||
'           and :P5450_STATUS_CHANGE_DESC = ''Approve CrimPoly'' then'||chr(10)||
'          return ''RPO'';'||chr(10)||
'      when :P5450_STATUS_CHANGE_DESC = ''Unarchive'' then'||chr(10)||
'          return ''Unarchive to Unit'';'||chr(10)||
'      else'||chr(10)||
'          return ''Unit'';'||chr(10)||
'   end case;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_id=>4908906244006206 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_RPO_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5450_UNIT_LABEL.',
  p_post_element_text=>'<a href="javascript:popupLocator(503,''P5450_UNIT_SID'',''N'',''&P5450_UNIT_EXCLUDE.'');">&ICON_LOCATOR.</a>',
  p_source=>'OSI_UNIT.GET_NAME(:P5450_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_STATUS_CHANGE_DESC in(''Approve CrimPoly'',''Approve SecPoly'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'',item_values:''OSI.LOC.UNIT,P5450_UNIT_SID,&P5450_UNIT_EXCLUDE.''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5507305410048631 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NEW_NOTE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Note Sid',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>5901314800310025 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SHOW_CONFIRM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>6040419886165925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CONFIRM_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>7430418540040818 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SOURCE_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>8018030643299712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_REPORT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Report Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>8018429867318396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_OBJ_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select ot.description'||chr(10)||
'from t_core_obj o, t_core_obj_type ot'||chr(10)||
'where o.sid = :p0_obj'||chr(10)||
'and o.obj_type = ot.sid',
  p_source_type=> 'QUERY',
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
  p_id=>13477209827412426 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_DATE_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_DATE_REQUIRED',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>13480306635506175 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_EFFECTIVE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Effective Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
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
  p_id=>90144832022465332 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NOTE_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Text',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 90,
  p_cMaxlength=> 32000,
  p_cHeight=> 15,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>90157129680231087 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_STATUS_CHANGE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Change Sid',
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
  p_id=>90158020592247382 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_CHECKLIST_COMPLETE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>90158228211249582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CUSTOM_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_id=>90158434098251281 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NOTE_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Required',
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
  p_id=>90160106571281224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE_DISPLAY_YES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'<img src="#IMAGE_PREFIX#themes/OSI/success_w.gif"/> Checklist Complete - You may proceed.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_CHECKLIST_COMPLETE = ''Y''',
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
  p_id=>90161335446299020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE_MESSAGE_NO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'<img src="#IMAGE_PREFIX#themes/OSI/fail.gif"/> Checklist Not Complete - Please complete the checklist.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_CHECKLIST_COMPLETE = ''N''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<img src="#IMAGE_PREFIX#themes/OSI/fail.gif"/><a href="javascript:runChecklist(''&P0_OBJ.'',''&P5450_STATUS_CHANGE_SID.'')">Checklist Not Complete - Please complete the checklist.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90171008462518299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_COMMENT_MSG_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<label tabindex="999" class="requiredlabel">A comment for this action is REQUIRED.</label>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_NOTE_REQUIRED = ''R''',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>90172010801537865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_COMMENT_MSG_OPTIONAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'A comment for this action is OPTIONAL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_NOTE_REQUIRED = ''O''',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>90589834783239292 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5450_UNIT_LABEL.',
  p_post_element_text=>'<a href="javascript:popupLocator(510,''P5450_UNIT_SID'',''N'',''&P5450_UNIT_EXCLUDE.'');">&ICON_LOCATOR.</a>',
  p_source=>'OSI_UNIT.GET_NAME(:P5450_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_STATUS_CHANGE_DESC not in(''Approve CrimPoly'',''Approve SecPoly'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'',item_values:''OSI.LOC.UNIT,P5450_UNIT_SID,&P5450_UNIT_EXCLUDE.''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90591207684239295 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_UNIT_SID',
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
  p_id=>90593917405311145 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Required',
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
  p_id=>90660322917367023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_EXCLUDE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Exclude',
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
  p_id=>90706932143254204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Done',
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
  p_id=>90708210073304640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_ERROR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'THERE HAS BEEN A SYSTEM ERROR WHEN CHANGING STATUS.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_DONE = ''N''',
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
  p_id=>90856123722438759 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_STATUS_CHANGE_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Change Desc',
  p_source=>'osi_status.get_status_change_desc(:P5450_STATUS_CHANGE_SID)',
  p_source_type=> 'FUNCTION',
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
  p_id=>90933536158383762 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CLONE_PAGE_TO_LAUNCH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'none',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Clone Page To Launch',
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
  p_id=>90933823822389589 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CLONE_NEW_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'none',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Clone New Sid',
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
  p_id=>91372833134852682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_TEXT_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Text Required',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>91374906750015454 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Reason',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_UNIT_TEXT_REQUIRED = ''Y''',
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
  p_id=>91383036128970142 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_PRE_PROCESS_CHECK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_PRE_PROCESS_CHECK',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>91384721649145767 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_PRE_PROCESS_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 91382720890965764+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5450_PRE_PROCESS_CHECK',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXTAREA-AUTO-HEIGHT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'readOnly',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
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
  p_id=>93419618677548935 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 93419223048540671+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_obj.get_tagline(:P0_obj)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90595124294360435 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'UNIT must not be null',
  p_validation_sequence=> 5,
  p_validation => 'P5450_UNIT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit must be selected.',
  p_validation_condition=> ':P5450_UNIT_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':request not in (''P5450_UNIT_SID'', ''SHOW_CHECKLIST'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 90589834783239292 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90145121301465340 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'NOTE_TEXT must not be null',
  p_validation_sequence=> 10,
  p_validation => 'P5450_NOTE_TEXT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Note Text must be filled in.',
  p_validation_condition=> ':P5450_NOTE_REQUIRED = ''R'''||chr(10)||
'and'||chr(10)||
':request not in (''P5450_UNIT_SID'', ''SHOW_CHECKLIST'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 90144832022465332 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 14120623560758929 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'Effective Date cannot be more than 2 days in advance',
  p_validation_sequence=> 30,
  p_validation => 'begin'||chr(10)||
'    if (:p5450_date_required = ''Y'' and :p5450_effective_date is not null) then'||chr(10)||
'        if (:p5450_effective_date > trunc(sysdate) +2) then'||chr(10)||
'            return ''Effective date cannot be more than 2 days ahead.'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => '',
  p_validation_condition=> ':REQUEST like ''SAVE%''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13480306635506175 + wwv_flow_api.g_id_offset,
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
'  v_parameter1   varchar2(500)  := null;'||chr(10)||
'  v_parameter2   varchar2(4000) := null;'||chr(10)||
'  v_temp         t_osi_note.sid%type;'||chr(10)||
'  v_result       varchar2(32767) := null;'||chr(10)||
'  v_log_msg      varchar2(500);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  v_log_msg := ''Lifecycle:'' || :p0_obj || ''-'' || :p5450_status_change_desc;'||chr(10)||
''||chr(10)||
'  --- Grab Unit into Parameter1 if nessecary ---'||chr(10)||
'  if (:p5450_unit_required = ''Y'') then'||chr(10)||
''||chr(10)||
'    v_parameter1 := :p545';

p:=p||'0_unit_sid;'||chr(10)||
'    v_log_msg := v_log_msg || ''-'' || v_parameter1;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  log_info(v_log_msg);'||chr(10)||
''||chr(10)||
'  --- Grab Unit Text into Parameter2 if nessecary ---'||chr(10)||
'  --- TJW - 10-Jan-2011 added the Replace to get by a problem where Apostrophes in the Text Cause Oracle Errors ---'||chr(10)||
'  if (:p5450_unit_text_required = ''Y'') then'||chr(10)||
''||chr(10)||
'    v_parameter2 := replace(:p5450_unit_text,'''''''','''''''''''');'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  osi_status.ch';

p:=p||'ange_status(:p0_obj, :p5450_status_change_sid, v_parameter1, v_parameter2, :P5450_EFFECTIVE_DATE);'||chr(10)||
''||chr(10)||
'  if (:p5450_note_text is not null) then'||chr(10)||
''||chr(10)||
'    :P5450_NEW_NOTE_SID := osi_note.add_note(:p0_obj, osi_status.get_required_note_type(:p5450_status_change_sid), :p5450_note_text);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if (:p5450_status_change_desc in (''Clone Activity'',''Create Case'')) then'||chr(10)||
''||chr(10)||
'    --- Put the cloned sid in the pag';

p:=p||'e if it exists. ---'||chr(10)||
'    :p5450_clone_new_sid := osi_status_proc.get_cloned_sid;'||chr(10)||
'        '||chr(10)||
'    select page_num into :p5450_clone_page_to_launch'||chr(10)||
'      from t_core_dt_obj_type_page'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:p5450_clone_new_sid)'||chr(10)||
'       and page_function = ''OPEN'';'||chr(10)||
'     --where obj_type = core_obj.get_objtype(:p5450_clone_new_sid);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'    '||chr(10)||
'  if(:p5450_status_change_de';

p:=p||'sc = ''Migrate to Existing Source'') then'||chr(10)||
' '||chr(10)||
'   :p5450_clone_new_sid := osi_status_proc.get_cloned_sid;'||chr(10)||
'   :P5450_source_id := osi_source.get_id(:p5450_clone_new_sid);'||chr(10)||
'        '||chr(10)||
'   select page_num into :p5450_clone_page_to_launch'||chr(10)||
'      from t_core_dt_obj_type_page'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:p5450_clone_new_sid)'||chr(10)||
'       and page_function = ''OPEN'';'||chr(10)||
'        '||chr(10)||
'    delete from t_c';

p:=p||'ore_obj where sid = :p0_obj;'||chr(10)||
'    :p0_obj := :p5450_clone_new_sid;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if(:p5450_status_change_desc = ''Approve File'' and :p5450_obj_type = ''Case'')then     '||chr(10)||
'      '||chr(10)||
'    select sid into :p5450_report_type'||chr(10)||
'     from t_osi_report_type'||chr(10)||
'      where description = ''Letter of Notification'''||chr(10)||
'        and obj_type = core_obj.lookup_objtype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'    :debug := :p5450_report_type;'||chr(10)||
'  '||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
' ';

p:=p||' :p5450_done := ''Y'';'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
''||chr(10)||
'  when others then'||chr(10)||
'      :p5450_done := ''N'';'||chr(10)||
'      raise;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90145220571465348 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Object Status',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE_CONFIRM,SAVE_NOTE,SAVE_DATE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
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
'    v_temp   varchar2(20);'||chr(10)||
'begin'||chr(10)||
'    if (:p0_obj_type_code = ''FILE.AAPP'') then'||chr(10)||
'        if (:P5450_STATUS_CHANGE_DESC like ''%Recall%'') then'||chr(10)||
'             osi_aapp_file.update_recall_note(:P5450_NEW_NOTE_SID);'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5486532760930489 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Special Processing on Note',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SAVE_CONFIRM,SAVE_NOTE',
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'  v_ok                  varchar2(1);'||chr(10)||
'  v_possible_dupes      number;'||chr(10)||
'  v_status_change_sid   varchar2(40);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  :p5450_checklist_complete := osi_checklist.checklist_complete(:p0_obj, :p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  begin'||chr(10)||
'       select aa.code into :p5450_auth_action'||chr(10)||
'        from t_osi_status_change sc, '||chr(10)||
'             t_osi_auth_action_type aa'||chr(10)||
'        where sc.sid = :p5450_status_change_';

p:=p||'sid'||chr(10)||
'          and aa.sid(+) = sc.auth_action;'||chr(10)||
'  exception when no_data_found then'||chr(10)||
''||chr(10)||
'           :p5450_auth_action := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'  if :p5450_auth_action is not null then'||chr(10)||
''||chr(10)||
'    :p5450_authorized := osi_auth.check_for_priv(:p5450_auth_action,'||chr(10)||
'                                                 core_obj.get_objtype(:p0_obj));    '||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    :p5450_authorized := ''Y'';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  --For some reason, not';

p:=p||'e_required does not always re-fill in correctly.'||chr(10)||
'  :p5450_note_required := osi_status.note_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
'  :p5450_unit_required := osi_status.unit_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
'  :P5450_unit_text_required := osi_status.unit_text_required_on_statchng(:P5450_status_change_sid);'||chr(10)||
'  :p5450_custom_message := osi_status.get_confirm_message(:p545';

p:=p||'0_status_change_sid, :P0_OBJ);'||chr(10)||
'  :status_stat_change_sid := v_status_change_sid;'||chr(10)||
'  :p5450_date_required := osi_status.date_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  --Unit Exclusion'||chr(10)||
'  :p5450_unit_exclude := osi_object.get_assigned_unit(:P0_OBJ);'||chr(10)||
''||chr(10)||
'  --:p5450_unit_exclude := osi_personnel.get_current_unit(core_context.personnel_sid);'||chr(10)||
''||chr(10)||
'  :P5450_pre_process_check := osi_status.run_pre_pro';

p:=p||'cessing(:p0_obj, :p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  if(:p5450_checklist_complete = ''Y'' and :p0_obj_type_code = ''PART.INDIV'')then'||chr(10)||
''||chr(10)||
'     v_ok := osi_participant.check_for_duplicates(:p0_obj);'||chr(10)||
''||chr(10)||
'     :P5450_CONFIRM_ALLOWED := v_ok;'||chr(10)||
''||chr(10)||
'     --if(:p5450_auth_action = ''CONFIRM'' and v_ok = ''N'')then'||chr(10)||
'     if :p5450_auth_action = ''CONFIRM'' then'||chr(10)||
''||chr(10)||
'       :p5450_confirm_session := osi_participant.get_confirm_session;'||chr(10)||
'';

p:=p||''||chr(10)||
'       select count(*) into v_possible_dupes'||chr(10)||
'        from v_osi_partic_search_result'||chr(10)||
'         where session_id = :p5450_confirm_session;'||chr(10)||
'       '||chr(10)||
'      if v_possible_dupes <= 0 then'||chr(10)||
''||chr(10)||
'        :p5450_show_confirm := ''N'';'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'        :p5450_show_confirm := ''Y'';'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       :p5450_show_confirm := ''N'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
' '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90158607694262545 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Pre-Load Status Change Information',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 5450
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







































update T_DIBRS_OFFENSE_TYPE set active = 'N' where crime_against = 'Don''t Use';
commit;

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
--   Date and Time:   16:23 Wednesday January 12, 2011
--   Exported By:     JASON
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.12
 
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

PROMPT ...Remove page 550
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>550);
 
end;
/

 
--application/pages/page_00550
prompt  ...PAGE 550: Locate Offenses
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'"JS_LOCATOR"';

wwv_flow_api.create_page(
  p_id     => 550,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Locate Offenses',
  p_step_title=> 'Locate Offenses',
  p_step_sub_title => 'Locate Offenses',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'JASON',
  p_last_upd_yyyymmddhh24miss => '20110112162340',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '8-NOV-2010 J.Faris WCHG0000065 - Updated any references to :LOC_SELECTIONS to :P0_LOC_SELECTIONS, fixed conditions on ''Select'' links/checkboxes.'||chr(10)||
'12-JAN-2011 J.Faris - Fixed query to exclude offense types where active = ''N''.');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>550,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>550,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 96252812249865506 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 550,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
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
s:=s||'select apex_item.checkbox(1,'||chr(10)||
'                          o.sid,'||chr(10)||
'                          ''onchange="toggleCheckbox(this);"'','||chr(10)||
'                          :p0_loc_selections,'||chr(10)||
'                          '':'') "Include",'||chr(10)||
'       ''<a href="javascript:passBack('''''' || o.sid || '''''', '''''' || :p550_return_item'||chr(10)||
'       || '''''');">Select</a>'' "Select",'||chr(10)||
'       o.code "Offense ID",'||chr(10)||
'       o.description "Offense Descript';

s:=s||'ion",'||chr(10)||
'       o.crime_against "Crime Against",'||chr(10)||
'       c.category "Category"'||chr(10)||
'  from t_dibrs_offense_type o,'||chr(10)||
'       t_osi_f_offense_category c'||chr(10)||
' where c.offense(+) = o.sid'||chr(10)||
'   and instr(:p550_exclude, o.sid) = 0'||chr(10)||
'   and not exists(select 1'||chr(10)||
'                    from t_dibrs_offense_type o1'||chr(10)||
'                   where o1.sid = o.SID'||chr(10)||
'                     and instr(:P550_EXCLUDE, o1.sid) > 0)'||chr(10)||
'   and o.active = ';

s:=s||'''Y''';

wwv_flow_api.create_page_plug (
  p_id=> 96253018724865520 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 550,
  p_plug_name=> '&P550_OBJ_TAGLINE.',
  p_region_name=>'',
  p_plug_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select apex_item.checkbox(1,'||chr(10)||
'                          o.sid,'||chr(10)||
'                          ''onchange="toggleCheckbox(this);"'','||chr(10)||
'                          :p0_loc_selections,'||chr(10)||
'                          '':'') "Include",'||chr(10)||
'       ''<a href="javascript:passBack('''''' || o.sid || '''''', '''''' || :p550_return_item'||chr(10)||
'       || '''''');">Select</a>'' "Select",'||chr(10)||
'       o.code "Offense ID",'||chr(10)||
'       o.description "Offense Descript';

a1:=a1||'ion",'||chr(10)||
'       o.crime_against "Crime Against",'||chr(10)||
'       c.category "Category"'||chr(10)||
'  from t_dibrs_offense_type o,'||chr(10)||
'       t_osi_f_offense_category c'||chr(10)||
' where c.offense(+) = o.sid'||chr(10)||
'   and instr(:p550_exclude, o.sid) = 0'||chr(10)||
'   and not exists(select 1'||chr(10)||
'                    from t_dibrs_offense_type o1'||chr(10)||
'                   where o1.sid = o.SID'||chr(10)||
'                     and instr(:P550_EXCLUDE, o1.sid) > 0)'||chr(10)||
'   and o.active = ';

a1:=a1||'''Y''';

wwv_flow_api.create_worksheet(
  p_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 550,
  p_region_id => 96253018724865520+wwv_flow_api.g_id_offset,
  p_name => 'Activities',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No data found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => '',
  p_sort_asc_image       => '',
  p_sort_asc_image_attr  => '',
  p_sort_desc_image      => '',
  p_sort_desc_image_attr => '',
  p_sql_query => a1,
  p_status                    =>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving       =>'Y',
  p_allow_report_categories   =>'N',
  p_show_nulls_as             =>'-',
  p_pagination_type           =>'ROWS_X_TO_Y',
  p_pagination_display_pos    =>'BOTTOM_RIGHT',
  p_show_finder_drop_down     =>'Y',
  p_show_display_row_count    =>'Y',
  p_show_search_bar           =>'Y',
  p_show_search_textbox       =>'Y',
  p_show_actions_menu         =>'Y',
  p_report_list_mode          =>'TABS',
  p_show_detail_link          =>'N',
  p_show_select_columns       =>'Y',
  p_show_filter               =>'Y',
  p_show_sort                 =>'Y',
  p_show_control_break        =>'Y',
  p_show_highlight            =>'Y',
  p_show_computation          =>'N',
  p_show_aggregate            =>'N',
  p_show_chart                =>'N',
  p_show_calendar             =>'N',
  p_show_flashback            =>'N',
  p_show_reset                =>'N',
  p_show_download             =>'Y',
  p_show_help            =>'Y',
  p_download_formats          =>'CSV',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'TIM');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96253323862865539+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 550,
  p_worksheet_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Include',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'Include',
  p_report_label           =>'Include',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P550_MULTI',
  p_display_condition2     =>'Y',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96253434071865548+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 550,
  p_worksheet_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Select',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Select',
  p_report_label           =>'Select',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2',
  p_display_condition      =>'P550_MULTI',
  p_display_condition2     =>'Y',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96297623088399528+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Offense ID',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Offense Id',
  p_report_label           =>'Offense Id',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96297737956399531+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Offense Description',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Offense Description',
  p_report_label           =>'Offense Description',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96297816577399531+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Crime Against',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Crime Against',
  p_report_label           =>'Crime Against',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96297928650399531+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Category',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Category',
  p_report_label           =>'Category',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 96254108886865553+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 550,
  p_worksheet_id => 96253209615865523+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>100000,
  p_report_columns          =>'Select:ID:Activity Type:Title:Status:Controlling Unit:Date Completed:Offense ID:Offense Description:Crime Against:Category',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 96254227062865557 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 550,
  p_button_sequence=> 10,
  p_button_plug_id => 96253018724865520+wwv_flow_api.g_id_offset,
  p_button_name    => 'RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Return Selections',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:passBack(''theList'',''&P550_RETURN_ITEM.'');',
  p_button_condition=> 'P550_MULTI',
  p_button_condition2=> 'Y',
  p_button_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>96255906526865587 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 550,
  p_branch_action=> 'f?p=&APP_ID.:550:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96254411349865567 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 550,
  p_name=>'P550_MULTI',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 96252812249865506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
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
  p_id=>96254638146865571 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 550,
  p_name=>'P550_EXCLUDE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 96252812249865506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Z',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>96254820075865573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 550,
  p_name=>'P550_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 96252812249865506+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>96255022207865573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 550,
  p_name=>'P550_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 96252812249865506+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>96255226536865573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 550,
  p_name=>'P550_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 96252812249865506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P550_RETURN',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>96255414279865574 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 550,
  p_name=>'P550_INITIALIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 96252812249865506+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||':P0_LOC_SELECTIONS := null;'||chr(10)||
':P550_INITIALIZED := ''Y'';'||chr(10)||
'if :P550_OBJ is not null then'||chr(10)||
'   :P550_OBJ_TAGLINE := core_obj.get_tagline(:P550_OBJ);'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 96255620727865578 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 550,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P550_INITIALIZED',
  p_process_when_type=>'ITEM_IS_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 550
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

