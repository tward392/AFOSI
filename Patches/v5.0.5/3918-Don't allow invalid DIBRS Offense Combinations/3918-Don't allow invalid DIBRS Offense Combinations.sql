-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_checklist is
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
    12-JUN-2009  Richard Dibble  Added get_checklist_auto_output
    15-JUN-2009  Richard Dibble  Added object_is_associated_to_a_file, object_has_lead_note,
                                 interview_has_dd2701
    16-JUN-2009  Richard Dibble  Added get_soft_checked_items
    17-JUN-2009  Richard Dibble  Added object_has_lead_agent, soft_checks_exist, object_has_at_least_one_objective
    22-JUN-2009  Richard Dibble  Added gen1_objectives_not_null
    23-JUN-2009  Richard Dibble  Added user_is_lead_agent, active_assignments_have_wrkhrs, assoc_act_assigns_have_wrkhrs
    20-Jul-2009  Richard Dibble  Added activity_has_subject, modified soft_checks_exist to handle
                                  two sided object filtering (will be phased out though)
    23-Jul-2009  T. Whitehead    Added participant_has_legal_name.
    10-Sep-2009  T. Whitehead    Modified participants_confirmed and participant_has_legal_name to work
                                  with participant versions.
    15-Sep-2009  T. Whitehead    Added participant_cage_code, participant_relationships.
    28-Oct-2009  T. Whitehead    Added participant_has_ssn, participant_has_association.
    29-Oct-2009  T. Whitehead    Renamed participant functions.
    04-Nov-2009  T. Whitehead    Added clist_is_complete and clist_has_comments.
    04-Nov-2009  Richard Dibble  Added search_explanation and search_person.
    17-Nov-2009  T. Whitehead    Added source_is_confirmed and source_required_notes.
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
    17-FEB-2010  Tom Leighty     Added dibrs_diff_sex
                                  Added dibrs_max_value
    18-FEB-2010  Richard Dibble  Added aapp_doa_ws
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
    19-FEB-2010  JaNelle Horne   Added inv_dispo_spec, inv_drug_indentified, inv_have_referral, inv_have_victim,
                                  inv_dispo_incident, inv_dispo_case, inv_all_inc_covered, inv_all_off_covered,
                                   inv_have_prim_offense, inv_have_subject, inv_property_item, per_reservist_set,
                                   nv_arfc_not_null, participante_role_exists
    22-FEB-2010  JaNelle Horne   Added inv_all_vic_covered, inv_have_incident, inv_all_sub_covered,
                                  inv_roi,
                                  Added inv_complaint_form
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
    12-MAR-2010  Tom Leighty    Added add_name_to_message
                                 Added current_pv_links
                                 Added deers_update_on_indivs
                                 Added curtailed_content_note
    12-MAR-2010 JaNelle Horne   Corrected issue with inv_complaint_form and inv_roi
    24-MAR-2010 JaNelle Horne   Fixed issue with dibrs_complete_ah_offs and dibrs_if_ucmj_date.  Procedures
                                were duplicated in the file.
    12-MAY-2010 Jason Faris     Added verify_assoc_poly_exam_act, verify_poly_csp, verify_poly_exam_reason,
                                verify_poly_exculpatory, verify_poly_have_examinee, verify_poly_return_reason.
    19-May-2010 Tim McGuffin    Fixed image prefix bugs and inv_approve_134z2
    06-Jun-2010 JaNelle Horne   Updated inv_complaint_form and inv_roi so that obj_type is checked.
    23-Jun-2010 JaNelle Horne   Updated dibrs_vic_type and dibrs_society
    16-Jul-2010 JaNelle Horne   Corrected issue with dibrs_society and dibrs_specification
    02-Aug-2010 JaNelle Horne   Corrected issues with dibrs_logical_property, dibrs_comb_vaild, dibrs_property_require,
                                inv_dispo_spec, assocact_closed, dibrs_gun_category, dibrs_society and dibrs_self_injury.
    31-Aug-2010 T. Whitehead    CHG0003326 Added CHECK_ACTIVITY_DATE.
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
    05-Oct-2010 Richard Dibble  Modified get_checklist_auto_output() to handle details
    06-Oct-2010 Richard Dibble  Added get_checklist_self_output()
    08-Oct-2010 Richard Dibble  Added details_exist_for_this_cl()
                                 Modified get_checklist_auto_output() to use 2 out parameters instead of a return value
    03-Nov-2010 Richard Dibble  Added source_import_is_satisfied
    10-Nov-2010 Richard Dibble  Added aapp_fm82_carb,  aapp_email_msg
    11-Nov-2010 Richard Dibble  Added p_filter to get_checklist_auto_output
    10-Feb-2011 Jason Faris     Added verify_legacy_relationships
    21-Jun-2011 Tim Ward        CR#3894 Fixing "value error: character string buffer too small" error during Case Closure
                                 Checklist.  Changed assocact_closed to use CLOB instead of varchar2(?????).
    27-Oct-2011 Tim Ward        CR#3589 - Only HQ can approve 106-A- Cases.
                                 Added inv_approve_106a.
    07-Nov-2011 Tim Ward        CR#3918 - Check for Valid Offense Combinations when adding specs.
                                 Changed dibrs_comb_valid.
                                 Added check_offense_combos.
                                 Added get_offense_count.

******************************************************************************/

    /* Determines is a checklist is complete for a given lifecycle change */
    function checklist_complete(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2;

    /* Used to determine if any details are available for a particular Checklist */
    function details_exist_for_this_cl(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2;

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
        p_filter in varchar2);

    /* Used to get the output for the checklist widget */
    function get_checklist_self_output(
        p_obj                 in   varchar2,
        p_status_change_sid   in   varchar2,
        p_show_details        in   varchar2 := 'N')
        return varchar2;

    /* Used to get the soft checklist list */
    function get_soft_checked_items(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2;

    /* Used to determine if Soft Checks exist */
    function soft_checks_exist(p_obj in varchar2, p_status_change_sid in varchar2)
        return varchar2;

    /* Used to verify that an object is associated to a file (most likely only used for Activities) */
    procedure object_is_associated_to_a_file(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /* Used to verify that an objects has a lead note */
    procedure object_has_lead_note(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that an interview activity has a DD2701 entry */
    procedure interview_has_dd2701(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that an object has a lead agent */
    procedure object_has_lead_agent(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that an object has at least one objective */
    procedure object_has_at_least_one_obj(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /* Used to verify that all objectives have some text in them */
    procedure gen1_objectives_not_null(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that the current user is the lead agent */
    procedure user_is_lead_agent(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that active assignments have work hours */
    procedure active_assignments_have_wrkhrs(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /* Used to verify that associated activities' active assignments have work hours */
    procedure assoc_act_assigns_have_wrkhrs(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /* Used to verify that an activity has AT LEAST ONE subject */
    procedure activity_has_subject(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that a participant has at least one relationship. */
    procedure partic_has_relationships(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that a participant is associated to at least one file or activity. */
    procedure partic_i_has_association(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that an individual participant has a legal name. */
    procedure partic_i_has_legal_name(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that an individual participant has a ssn. */
    procedure partic_i_has_ssn(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verfy a company has a Cage Code. */
    procedure partic_n_has_cage_code(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that an objects participants are confirmed */
    procedure participants_confirmed(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that items requiring a comment actually have comments. */
    procedure clist_has_comments(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify the checklist activity is complete. */
    procedure clist_is_complete(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that a person search has a person tied to it */
    procedure search_explanation(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that a place/property search has an explanation */
    procedure search_person(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that a source file has a confirmed participant. */
    procedure source_is_confirmed(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that a source file has the required note types. */
    procedure source_required_notes(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that surveillance Intercept Conducted is an actual Y/N value */
    procedure surv_intcond_null(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that surveillance activation date is present if Intercept Conducted is set */
    procedure surv_activation_date(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that surveillance approval data is present if Intercept Conducted is set */
    procedure surv_approval_data(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that surveillance object has at least one 'Agency Conducting the Intercept', 'Targeted Individual' participant */
    procedure surv_participant(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* DEBUGGING ONLY */
    procedure test_check(p_obj in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                 */
    function add_name_to_message(p_msg in varchar2, p_name in varchar2)
        return clob;

    /* Used to verify that there is a valid state and country. */
    procedure dibrs_valid_st_ctry(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_injury_self(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_gun_category(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_vic_type(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_valid_age(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_vicrel_ofdr(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_criminal_activity(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure dibrs_property_require(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure dibrs_vicage_pres(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_comb_valid(p_parent in varchar2, p_complete out number, p_msg out varchar2);
    
    --- To allow dibrs_comb_valid checking from WebI2MS Pages ----
    procedure check_offense_combos(p_parent in varchar2, p_nibrs_code in varchar2, p_incident in varchar2, p_victim in varchar2, v_offense in varchar2, p_complete out varchar2, p_msg out varchar2, v_count out number);

/*                                                                                                        */
    procedure dibrs_ofdr_info(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*  Check to see if the victim and offender are of different sexes.                                       */
    procedure dibrs_diff_sex(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*  Validate the begin and end dates.                                                                     */
    procedure dibrs_ir_occ_date(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*  Check to see that listed property values do not exceed a maximum thresh hold.                         */
    procedure dibrs_max_value(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_vicsex_pres(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* Verify weapon(s) and force used.                                                                       */
    procedure dibrs_w_f_used(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* Verify the age of the victim.                                                                          */
    procedure dibrs_vicindiv_age(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*  Validate victim to offender relationship.                                                             */
    procedure dibrs_vicrel_warn(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* Validate SSN formatting.                                                                               */
    procedure dibrs_ssn_length(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* This procedure will check for information located in the drug_code, prop_quantity,or                   */
    /* drug_measure which are not allowed due to business rules. This satisfies the errors 541 and 563        */
    procedure dibrs_rmv_drug_info(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* Check for victim set as society.                                                                       */
    procedure dibrs_society(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_recover_date(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_specification(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*  Verify the maximum offender age.                                                                      */
    procedure dibrs_max_offage(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*  This procedure verifies that the associate activities are all closed.                                 */
    procedure assocact_closed(p_parent in varchar2, p_complete out number, p_msg out clob);

    /*  Verify mission area.                                                                                  */
    procedure inv_mission_area(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*  Check status of evidence disposal.                                                                    */
    procedure evidence_disp(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* Confirm user privilage to approve offense 134-Z2 Investigations.                                       */
    procedure inv_approve_134z2(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* Confirm user privilage to approve offense 106-A- Investigations.                                       */
    procedure inv_approve_106a(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure current_pv_links(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure deers_update_on_indivs(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /*  Check to see if a curtailed content note is present.                                                  */
    procedure curtailed_content_note(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure dibrs_injury_type(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_logical_property(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure dibrs_prop_loss(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_prop_suspdrg(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_drg_measure_qnty(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure disposition_type(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_stolen_recv_vehic(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure inv_off_on_usi(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure have_assocact(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_spec_jurisdiction(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure dibrs_property_value(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_nodupdrugcode(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_drg_equip(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_premises_entry(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_aahc_require(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_valid_aahc_codes(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure dibrs_proper_aahc_codes(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure inv_dispo_off_result(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure per_reservist_set(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_arfc_not_null(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*                                                                                                        */
/*    procedure dibrs_ir_ucmj_date(p_parent in varchar2, p_complete out number, p_msg out varchar2);   */

    /*                                                                                                        */
    procedure dibrs_subject_rel(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_all_sub_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure dibrs_complete_ah_offs(
        p_parent     in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

/*                                                                                                        */
    procedure inv_property_item(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_complaint_form(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_roi(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_have_subject(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_have_prim_offense(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_have_incident(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_all_vic_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_all_off_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_all_inc_covered(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_dispo_case(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_dispo_incident(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_have_victim(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_have_referral(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_drug_identified(p_parent in varchar2, p_complete out number, p_msg out varchar2);

/*                                                                                                        */
    procedure inv_dispo_spec(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): Form 1288 document attached. */
    procedure aapp_1288(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): AF IMT 686 Document attached. */
    procedure aapp_imt_686(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): BQ documents attached. */
    procedure aapp_doa_bq(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): COE documents attached. */
    procedure aapp_doa_coe(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): CR documents attached. */
    procedure aapp_doa_cr(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): DD2760 documents attached. */
    procedure aapp_doa_dd2760(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): DL documents attached. */
    procedure aapp_doa_dl(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): AAPP DOA Document attached. */
    procedure aapp_doa_doa(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): EPR/OPR documents attached. */
    procedure aapp_doa_epropr(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): FAR documents attached. */
    procedure aapp_doa_far(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): FQ documents attached. */
    procedure aapp_doa_fq(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): PP documents attached. */
    procedure aapp_doa_pp(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): RI documents attached. */
    procedure aapp_doa_ri(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): RRRIP documents attached. */
    procedure aapp_doa_rrrip(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): SHIPLEY or Baccalaureate attached. */
    procedure aapp_doa_shipley(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): SOUFA documents attached. */
    procedure aapp_doa_soufa(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): WS documents attached. */
    procedure aapp_doa_ws(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): 151DET documents attached. */
    procedure aapp_unit_151det(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): BPS documents attached. */
    procedure aapp_unit_bps(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): DCII documents attached. */
    procedure aapp_unit_dcii(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): DLAB documents attached. */
    procedure aapp_unit_dlab(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): LOR documents attached. */
    procedure aapp_unit_lor(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): A picture is attached. */
    procedure aapp_unit_picture(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): The SF86 hard copy attached. */
    procedure aapp_unit_sf86hc(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): 151REG documents attached. */
    procedure aapp_region_151reg(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): ROI documents attached. */
    procedure aapp_region_roi(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): All Objectives Must be Met. */
    procedure aapp_objectives_met(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): Must have File Tracking Number */
    procedure aapp_tracknum(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): All activities must be closed. */
    procedure aapp_act_closed(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 File): Form82 attached. */
    procedure aapp_fm82_carb(p_parent in varchar2, p_complete out number, p_msg out varchar2);

   /*AAPP (110 File): Email Notification attached. */
    procedure aapp_email_msg(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*AAPP (110 Activity): All activities must have TO/FROM dates. */
    procedure aapp_a_have_dates(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /*Manual Fingerprint must have FD-249 fingerprint card attached for completion. */
    procedure fp_card_attached(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    procedure dibrs_ir_ucmj_date(p_parent in varchar2, p_complete out number, p_msg out varchar2);

    /* Poly File: Must have an associated Poly Exam activity. */
    procedure verify_assoc_poly_exam_act(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /* Poly File: CSP cannot be null. */
    procedure verify_poly_csp(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Poly File: Reason for Exam cannot be null. */
    procedure verify_poly_exam_reason(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Poly File: Exculpatory cannot be null.*/
    procedure verify_poly_exculpatory(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Poly File: Examinee must exist. */
    procedure verify_poly_have_examinee(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /* Poly File: Must have admin deficiency or technical deficiency specified as return reason. */
    procedure verify_poly_return_reason(
        p_obj        in       varchar2,
        p_complete   out      number,
        p_msg        out      varchar2);

    /* CHG0003326 Activity date must be before completed date. */
    procedure check_activity_date(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* CHG0003209 - Offense Results must have Charged Result IF a Result OF Acquitted OR Convicted. */
    procedure verify_offense_results(p_obj in varchar2, p_complete out number, p_msg out varchar2);
    
    /* SOURCE: Used to verify whether or not a Source has been bounced off the Legacy I2MS database for data import */
    procedure source_import_is_satisfied(p_obj in varchar2, p_complete out number, p_msg out varchar2);

    /* Used to verify that relationships have been imported from legacy */
    procedure verify_legacy_relationships(p_obj in varchar2, p_complete out number, p_msg out varchar2);

end osi_checklist;
/


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
         v_msg   clob;
         v_ids   clob;
    begin
         v_msg := 'DEFAULT';                                                     ---initial value---
         v_cnt := 0;

         select count(activity_sid)
           into v_cnt
           from v_osi_f_aapp_file_obj_act
          where file_sid = p_parent;

         if v_cnt > 0 then
       
           ---Loop through all associated activities for the given file---
           for n in (select   activity_sid, activity_id
                          from v_osi_f_aapp_file_obj_act
                         where file_sid = p_parent and activity_close_date is null
                      order by activity_id)
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

end osi_checklist;
/





-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_INVESTIGATION" as
/******************************************************************************
   name:     osi_investigation
   purpose:  provides functionality for investigative case file objects.

   revisions:
    date        author          description
    ----------  --------------  ------------------------------------
     7-apr-2009 t.mcguffin      created package
    30-jun-2009 t.mcguffin      added create_instance function.
    30-jul-2009 t.mcguffin      added next_incident_id function.
    13-Aug-2009 t.mcguffin      added get_aah_circumstances, get_ajh_circumstances, get_crim_activity,
                                get_vic_injuries, set_aah_circumstances, set_ajh_circumstances,
                                set_crim_activity and set_vic_injuries proc/functions.
    17-Sep-2009 t.mcguffin      added get_inv_dispositions and set_inv_dispositions.
    30-Sep-2009 t.mcguffin      added get_special_interest and set_special_interest proc/functions.
    30-Sep-2009 t.mcguffin      added get_notify_units and set_notify_units proc/functions.
    30-Sep-2009 t.mcguffin      added get_primary_offense, get_days_to_run and get_timeliness_date functions.
     2-Oct-2009 t.mcguffin      added get_full_id function
     7-Oct-2009 t.mcguffin      added clone_to_case function

     2-Nov-2009 t.whitehead     Moved get/set_special_interest to osi_object.
    20-Jan-2010 t.mcguffin      added check_writability
    31-Mar-2010 t.mcguffin      added get_final_roi_date.
    09-Apr-2010 J.Horne         Changed name of get_full_id to generate_full_id to better identify
                                what the function does.
    13-May-2010 J.Horne         Updated create_instance so that it will allow a user to add an offense,
                                subject, victim and summary when creating a new investigation. When offense,
                                subject and victim are all present, an incident and specification will also be created.
    19-May-2010 J.Horne         Updated create_instance to put in default background (summary allegation) info.
    25-May-2010 T.Leighty       Added make_doc_investigative_file.
    28-May-2010 J.Horne         Added summary_complaint_rpt, get_basic_info, participantname, getsubjectofactivity,
                                load_activity, get_assignments, get_f40_place, get_f40_date, roi_toc_interview, roi_toc_docreview,
                                roi_toc_consultation, roi_toc_search, roi_toc_sourcemeet, roi_toc, roi_header_interview,
                                roi_header_docreview, roi_header_consultation, roi_header_search, roi_header_sourcemeet,
                                roi_header_incidental_int, roi_header_default, roi_header, cleanup_temp_clob
    07-Jun-2010 J.Horne         Added roi_group, roi_group_header, roi_toc_order, roi_group, roi_group_order
    09-Jun-2010 J.Horne         Added case_roi, get_subject_list, get_victim_list, roi_block, get_owning_unit_cdr, get_cavaets_list,
                                get_sel_activity, get_evidence_list, get_idp_notes, get_act_exhibit
    11-Jun-2010 J.Horne         Added case_status_report
    14-Jun-2010 J.Horne         Added letter_of_notifcation, case_subjectvictimwitnesslist, getpersonnelphone, getunitphone, idp_notes_report,
                                form_40_roi, getparticipantphone
    24-Jun-2010 J.Faris         Added genericfile_report, get_attachment_list, get_objectives_list; Generic File report functions included
                                in this package because of common support functions and private variables
    25-Jun-2010 J.Horne         Fixed issue with case_subjectwitnessvictimlist; SSNs were duplicating.
    01-Jul-2010 J.Horne         Removed links from summary_complaint_rpt.
    18-Aug-2010 Tim Ward        CR#299 - WebI2MS Missing Narrative Preview.
                                 Added activity_narrative_preview.
    07-Jan-2011 Tim Ward        Moved get_assignments from here to OSI_REPORT.
    30-Jun-2011  Tim Ward       CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Changed clone_to_case.
    07-Jul-2011  Tim Ward       CR#3571 - Add Matters Investigated (Offenses) to Initial Notification.
                                  Added auto_load_specs.
    07-Nov-2011 Tim Ward        CR#3918 - Check for Valid Offense Combinations when adding specs.
                                 Changed auto_load_specs.
******************************************************************************/
    function get_tagline(p_obj in varchar2)
        return varchar2;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    function get_status(p_obj in varchar2)
        return varchar2;

    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_offense       in   varchar2,
        p_subject       in   varchar2,
        p_victim        in   varchar2,
        p_sum_inv       in   clob)
        return varchar2;

    -- gets the next available incident id from a sequence
    function next_incident_id
        return varchar2;

    -- builds a colon-delimited list of aah_circumstances (sids) for a given specification.
    function get_aah_circumstances(p_spec_sid in varchar2)
        return varchar2;

    -- builds a colon-delimited list of ajh_circumstances (sids) for a given specification.
    function get_ajh_circumstances(p_spec_sid in varchar2)
        return varchar2;

    -- builds a colon-delimited list of criminal activities (sids) for a given specification.
    function get_crim_activity(p_spec_sid in varchar2)
        return varchar2;

    -- builds a colon-delimited list of victim injuries (sids) for a given specification.
    function get_vic_injuries(p_spec_sid in varchar2)
        return varchar2;

    -- takes in a colon-delimited list of aah circumstances (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_aah_circumstances(p_spec_sid in varchar2, p_aah in varchar2);

    -- takes in a colon-delimited list of ajh circumstances (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_ajh_circumstances(p_spec_sid in varchar2, p_ajh in varchar2);

    -- takes in a colon-delimited list of criminal activities (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_crim_activity(p_spec_sid in varchar2, p_crim_act in varchar2);

    -- takes in a colon-delimited list of victim injuries (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_vic_injuries(p_spec_sid in varchar2, p_injuries in varchar2);

    -- builds a colon-delimited list of dispositions (sids) for the given investigation.
    function get_inv_dispositions(p_sid in varchar2)
        return varchar2;

    -- takes in a colon-delimited list of dispositions (sids) for a given investigation
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_inv_dispositions(p_sid in varchar2, p_dispositions in varchar2);

    -- builds a colon-delimited list of units to notify (sids) for a given investigation.
    function get_notify_units(p_sid in varchar2)
        return varchar2;

    -- takes in a colon-delimited list of units to notify (sids) for a given investigation
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_notify_units(p_sid in varchar2, p_notify_units in varchar2);

    -- returns the primary offense sid for an investigation
    function get_primary_offense(p_sid in varchar2)
        return varchar2;

    -- returns the number of days to run (used to calc timeliness date) for an investigation.
    function get_days_to_run(p_sid in varchar2)
        return number;

    -- returns the suspense or timeliness date for an investigation.
    function get_timeliness_date(p_sid in varchar2)
        return date;

    -- used to populate the full_id field in t_osi_file when appropriate.
    function generate_full_id(p_sid in varchar2)
        return varchar2;

    -- creates clone case file from another type of investigation
    function clone_to_case(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null)
        return varchar2;

    --called when user changes the investigative subtype.  deletes case-specific data.
    procedure change_inv_type(p_sid in varchar2, p_new_type in varchar2);

    -- returns Y if the input object is writable (not read-only)
    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2;

    -- if the input investigation has a Final ROI attached, will return the create_on date.
    function get_final_roi_date(p_obj varchar2)
        return date;

-- function summary_complaint_report(psid in varchar2)
--        return clob;

    --  Produces the html document for the investigative file report.
    procedure make_doc_investigative_file(p_sid in varchar2, p_doc in out nocopy clob);

    function summary_complaint_rpt(psid in varchar2)
        return clob;

    procedure get_basic_info(
        ppopv            in       varchar2,
        presult          out      varchar2,
        psaa             out      varchar2,
        pper             out      varchar2,
        pincludename     in       boolean := true,
        pnameonly        in       boolean := false,
        pincludemaiden   in       boolean := true,
        pincludeaka      in       boolean := true);

    function get_org_info(ppopv in varchar2, preplacenullwithunk in boolean := false)
        return varchar2;

    procedure load_activity(psid in varchar2);

    function get_f40_place(p_obj in varchar2)
        return varchar2;

    function get_f40_date(psid in varchar2)
        return date;

    function roi_toc_interview
        return varchar2;

    function roi_toc_docreview
        return varchar2;

    function roi_toc_consultation
        return varchar2;

    function roi_toc_sourcemeet
        return varchar2;

    function roi_toc_search
        return varchar2;

    function roi_toc(psid in varchar2)
        return varchar2;

    function roi_header_interview(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_incidental_int(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_docreview(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_consultation(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_sourcemeet(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_search(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_default(preturntable in varchar2 := 'N')
        return clob;

    function roi_group(psid in varchar2)
        return varchar2;

    function roi_group_order(psid in varchar2)
        return varchar2;

    function roi_toc_order(psid in varchar2)
        return varchar2;

    function roi_narrative(psid in varchar2)
        return clob;

    function roi_block(ppopv in varchar2)
        return varchar2;

    function roi_header(psid in varchar2, preturntable in varchar2 := 'N')
        return clob;

    function case_roi(psid in varchar2)
        return clob;

    function get_subject_list
        return varchar2;

    function get_victim_list
        return varchar2;

    function get_owning_unit_cdr
        return varchar2;

    function get_caveats_list
        return varchar2;

    procedure get_sel_activity(pspecsid in varchar2);

    procedure get_evidence_list(pparentsid in varchar2, pspecsid in varchar2);

    procedure get_idp_notes(pspecsid in varchar2, pfontsize in varchar2 := '20');

    function get_act_exhibit(pactivitysid in varchar2)
        return varchar2;

    function case_status_report(psid in varchar2)
        return clob;

    function letter_of_notification(psid in varchar2)
        return clob;

    function getpersonnelphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2;

    function getparticipantphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2;

    function getunitphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2;

    function case_subjectvictimwitnesslist(psid in varchar2)
        return clob;

    function idp_notes_report(psid in varchar2)
        return clob;

    function form_40_roi(psid in varchar2)
        return clob;

    /* Generic File report functions, included in this package because of common support functions and private variables */
    function genericfile_report(p_obj in varchar2)
        return clob;

    function get_attachment_list(p_obj in varchar2)
        return varchar2;

    procedure get_objectives_list(p_obj in varchar2);

    function Activity_Narrative_Preview(pSID in Varchar2, htmlorrtf IN VARCHAR2 := 'HTML')
        return Clob;

    procedure auto_load_specs(p_obj in varchar2, p_list out varchar2, p_send_first_back varchar2 := 'N');
        
end osi_investigation;
/


CREATE OR REPLACE package body osi_investigation as
/******************************************************************************
   name:     osi_investigation
   purpose:  provides functionality for investigative case file objects.

   revisions:
    date        author          description
    ----------  --------------  ------------------------------------
     7-apr-2009 t.mcguffin      created package
    30-jun-2009 t.mcguffin      added create_instance function.
    30-jul-2009 t.mcguffin      added next_incident_id function.
    13-Aug-2009 t.mcguffin      added get_aah_circumstances, get_ajh_circumstances, get_crim_activity,
                                get_vic_injuries, set_aah_circumstances, set_ajh_circumstances,
                                set_crim_activity and set_vic_injuries proc/functions.
    17-Sep-2009 t.mcguffin      added get_inv_dispositions and set_inv_dispositions.
    30-Sep-2009 t.mcguffin      added get_special_interest and set_special_interest proc/functions.
    30-Sep-2009 t.mcguffin      added get_notify_units and set_notify_units proc/functions.
    30-Sep-2009 t.mcguffin      added get_primary_offense, get_days_to_run and get_timeliness_date functions.
     2-Oct-2009 t.mcguffin      added get_full_id function
     7-Oct-2009 t.mcguffin      added clone_to_case function and clone_specifications procedure
     9-Oct-2009 t.mcguffin      added change_inv_type function
     2-Nov-2009 t.whitehead     Moved get/set_special_interest to osi_object.
    20-Jan-2010 t.mcguffin      added check_writability;
    17-Feb-2010 t.mcguffin      modified clone_to_case for changes to add_note (changed to function)
    31-Mar-2010 t.mcguffin      added get_final_roi_date.
    09-Apr-2010 J.Horne         Changed name of get_full_id to generate_full_id to better identify
                                what the function does.
    13-May-2010 J.Horne         Updated create_instance to that it will allow a user to add an offense,
                                subject, victim and summary when creating a new investigation. When offense,
                                subject and victim are all present, an incident and specification will also be created.
    19-May-2010 J.Horne         Updated create_instance to put in default background (summary allegation) info.
    25-May-2010 T.Leighty       Added make_doc_investigative_file.
    28-May-2010 J.Horne         Added summary_complaint_rpt, get_basic_info, participantname, getsubjectofactivity,
                                load_activity, get_assignments, get_f40_place, get_f40_date, roi_toc_interview, roi_toc_docreview,
                                roi_toc_consultation, roi_toc_search, roi_toc_sourcemeet, roi_toc, roi_header_interview,
                                roi_header_docreview, roi_header_consultation, roi_header_search, roi_header_sourcemeet,
                                roi_header_incidental_int, roi_header_default, roi_header, cleanup_temp_clob
    07-Jun-2010 J.Horne         Added roi_group, roi_group_header, roi_toc_order, roi_group, roi_group_order
    08-Jun-2010 J.Horne         Removed references to util.logger
    09-Jun-2010 J.Horne         Added case_roi, get_subject_list, get_victim_list, roi_block, get_owning_unit_cdr, get_cavaets_list,
                                get_sel_activity, get_evidence_list, get_idp_notes, get_act_exhibit
    11-Jun-2010 J.Horne         Added case_status_report
    14-Jun-2010 J.Horne         Added letter_of_notifcation, case_subjectvictimwitnesslist, getpersonnelphone, getunitphone, idp_notes_report,
                                form_40_roi, getparticipantphone
    24-Jun-2010 J.Faris         Added genericfile_report, get_attachment_list, get_objectives_list; Generic File report functions included
                                in this package because of common support functions and private variables
    25-Jun-2010 J.Horne         Fixed issue with case_subjectwitnessvictimlist; SSNs were duplicating.
    01-Jul-2010 J.Horne         Removed links from summary_complaint_rpt.
    18-Aug-2010 Tim Ward        CR#299 - WebI2MS Missing Narrative Preview.
                                 Added v_obj_type_sid and v_obj_type_code variables.
                                 Added activity_narrative_preview.
                                 Changed load_activity, roi_group.
    07-Sep-2010 T.Whitehead     CHG0003170 - Added Program Data section to form_40_roi.
    20-Sep-2010 Richard Dibble  CR#3277 - Removed IDP Page code from Summary_Complaint_Report() and Case_ROI()
    27-Sep-2010 Richard Dibble  WCHG0000338 - Added build_agent_names() and load_agents_assigned() modified get_assignments()
                                and case_roi() to use them accordingly
    12-Oct-2010 J.Faris         CHG0003170 - Reinstated Thomas W. changes from 07-Sep after inadvertently removing the code during Andrews
                                integration of CR#299.
    12-Oct-2010 Tim Ward        CR#299 - WCH0000338 change to get_assignments broke activity_narrative_preview
                                 Changed activity_narrative_preview.
    26-Oct-2010 Richard Dibble  Fixed roi_group() to properly handle interview activities
    06-Jan-2010 Tim Ward        Added load_agents_assigned to summary_complaint_rpt and moved the function above it so
                                 it could call it without adding it to the spec.
                                 This fixes the <<Error during ROI_Header_Default>> - ORA-01403: no data found. error messages.
                                Changed the Approval Authority section of summary_complaint_rpt to get the correct approval authority name.
                                Changed the Units To Notify to not display Specialty Support when there is no Units to Notify.
    07-Jan-2011 Tim Ward        Moved load_agents_assigned from here to OSI_REPORT.
    07-Jan-2011 Tim Ward        Moved get_assignments from here to OSI_REPORT.
    07-Jan-2011 Tim Ward        Moved build_agent_name from here to OSI_REPORT.
    25-Jan-2011 Tim Ward        Changed check_writability to use APPROVE/CLOSE instead
                                 of APPROVE_OP/APPROVE_CL to allow COMMANDER to edit before Approval/Closure.
    25-Feb-2011 Carl Grunert    CHG0003506 - fixed ROI Reports Footer missing the "Unclassified" word
    03-Mar-2011 Tim Ward        CR#3730 - Changed clone_to_case to NOT clone Status History, but save the starting status.
    04-Mar-2011 Tim Ward        CR#3733 - Changed clone_to_case to copy only obj_context='I' and include the obj_context
                                 when copying Special Interests (fixing the WEBI2MS.UK_OSI_MISS_ACTMISSION error).
    07-Mar-2011 Tim Ward        CR#3736 - Wrong Unit Name getting Pulled.  Fixed to use end_date is null in case_roi,
                                 summary_complaint_rpt, case_status_report, and letter_of_notification.
    25-Mar-2011 Jason Faris     Fixed summary_complaint_rpt formatting from stripping the last name when subjects or victims > 1.
    28-Mar-2011 Tim Ward        CR#3774 - Last Name of Subjects/Victims missing.
                                 Other Agencies works sometimes, not all the time.
                                 Changed in summary_complaint_rpt and a few other '\par' changed to '\par '.
    04-Apr-2011 Tim Ward        Summary Complaint Report showing mostly [TOKEN@....] starting with Subject List.
                                 Changed v_ppg from varchar2(100) to varchar2(400) in get_basic_info.
    14-Apr-2011 Tim Ward        CR#3818 - ROI shows all attachments selected or not.
                                 Changed get_act_exhibit.
    02-May-2011 Tim Ward        CR#3833 - ROI Date doesn't show on Desktop View.
                                 Changed 'ROISFS' to 'ROIFP' in get_final_roi_date.
    19-May-2011 Tim Ward        CR#3828 - Unit Address wrong in the Letter of Notification Report.
                                 Changed letter_of_notification.
    09-Jun-2011 Tim Ward        CR#3363 - Letter Of Notification Typo APD should be AFPD.
                                 Changed letter_of_notification.
    09-Jun-2011 Tim Ward        CR#3215 - Letter Of Notification Modifications
                                 Changed letter_of_notification.
    30-Jun-2011  Tim Ward       CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Changed clone_to_case and clone_specifications.
                                  Added SAPRO fields to clone_specifications for CR#3680 and CR#3868.
    07-Jul-2011  Tim Ward       CR#3571 - Add Matters Investigated (Offenses) to Initial Notification.
                                  Added auto_load_specs.
    13-Jul-2011  Tim Ward       CR#3870 - Letter Of Notification Privacy Act Information.
                                  New Variable v_privacyActInfo, changed letter_of_notification.
    22-Jul-2011  Tim Ward       CR#3880 - ROI Narrative Sort Order issues.
                                  Changed in ROI_GROUP_ORDER.
    15-Sep-2011  Tim Ward       CR#3940 - Error happening when trying to Create an ROI 
                                (calling replace_special_chars and need to call replace_special_chars_clob.)
                                 Changed roi_narrative.
                                Also found problem if there are HTML type characters in the Narrative, the 
                                 preview gets messed up.  And there is a 32K Limit to the HTML which had
                                 to be fixed in the Activity_Narrative_Preview Application Express Process.
                                 Changed activity_narrative_preview.
                                 Added escape_the_html.
    21-Sep-2011  Tim Ward       CR#3931 - ROI Date Format should be DD Mon YY not DD-Mon-YYYY. 
                                 Changed v_date_fmt to use new T_CORE_CONFIG entry 
                                 'CORE.DATE_FMT_REPORTS'=FMDD Mon FMFXYY instead of 'CORE.DATE_FMT_DAY'=dd-Mon-rrrr'.
    21-Sep-2011  Tim Ward       CR#3929 - Incorrect Paragraph referenced in the Letter Of Notification. 
                                 Changed 'AFI 36-3208' to 'AFI 36-2110, Table 2.1, Rule 10, Code 17' in letter_of_notification. 
    17-Oct-2011  Tim Ward       CR#3933 - Form 40 ROI fails if more than one spouse exists for a defendant in the relationships.
                                 Changed form_40_roi.
    20-Oct-2011  Tim Ward       CR#3932 - Classification on Reports is wrong.
                                  Changed all classification calls to:
                                   v_class := osi_classification.get_report_class(v_obj_sid);
    25-Oct-2011  Tim Ward       CR#3304 - Letter of Notification Report shows incorrect SSN.
                                 Fixed in Legacy I2MS 30-Sep-2009 but not carried over to WebI2MS.
                                 Changed in Letter_Of_Notification.        
    27-Oct-2011  Tim Ward       CR#3915 - Include Associated Files and Inherited Activities IDP Notes report in IDP NOTES REPORT.
                                CR#3961 - IDP Notes are now in CREATE_ON (Chronological Order).
                                        - Now gets Parentinfo as a HyperLink so you know where the note is from.
                                CR#3932 - Added Classification to IDP NOTES REPORT (forgot to do this on 20-Oct-2011).
                                 Changed in idp_notes_report.        
    01-Nov-2011  Tim Ward       CR#3848 - Unit Name, Address, and MAJCOMM missing from Subject and Victim Title Block of ROI and SCR.
                                 Changed in get_org_info.
    01-Nov-2011  Tim Ward       CR#3847 - AKA and NEE missing from Subject and Victim Title Block of ROI.
                                 Changed Get_Basic_Info.
    01-Nov-2011  Tim Ward       CR#3923 - Pay Plan, Grade and Affiliation not showing in ROI title block.
                                 Changed Get_Basic_Info.
                                Participant Information not showing for Interview Activities.
                                 Changed getparticipantname, roi_toc_interview, form_40_roi, genericfile_report, 
                                  summary_complaint_report, case_roi, and activity_narrative_preview.
    07-Nov-2011 Tim Ward        CR#3918 - Check for Valid Offense Combinations when adding specs.
                                 Changed auto_load_specs.
                                 
******************************************************************************/
    c_pipe              varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_INVESTIGATION';
    v_syn_error         varchar2(4000)                      := null;
    v_obj_sid           varchar(20)                         := null;
    v_spec_sid          varchar(20)                         := null;
    v_act_title         t_osi_activity.title%type;
    v_act_desc          t_core_obj_type.description%type;
    v_act_sid           t_osi_activity.SID%type;
    v_act_date          t_osi_activity.activity_date%type;
    v_act_complt_date   t_osi_activity.complete_date%type;
    v_act_narrative     t_osi_activity.narrative%type;
    v_obj_type_sid      t_core_obj_type.SID%type;
    v_obj_type_code     t_core_obj_type.code%type;
    v_nl                varchar2(100)                       := chr(10);
    v_newline           varchar2(10)                        := chr(13) || chr(10);
    v_mask              varchar2(50);
    v_date_fmt          varchar2(15)                        := core_util.get_config('CORE.DATE_FMT_REPORTS');
    v_privacyActInfo    varchar2(500) := 'This report contains FOR OFFICIAL USE ONLY (FOUO) information which must be protected under the Privacy Act and AFI 33-332.';
        
--------------------------------------
--- ROI Specific Private variables ---
--------------------------------------
    v_unit_sid          varchar2(20);
    v_act_toc_list      clob                                := null;
    v_act_narr_list     clob                                := null;
    v_exhibits_list     clob                                := null;
    v_exhibit_cnt       number                              := 0;
    v_evidence_list     clob                                := null;
    v_idp_list          clob                                := null;
    -- v_equipment_list    clob           := null;
    c_blockparaoff      varchar2(100)
            := '}\pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 {';
    c_hdr_linebreak     varchar2(30)                        := '\ql\fi-720\li720\ \line ';
    c_blockhalfinch     varchar2(250)
        := '}\pard\plain \ql \li0\ri0\widctlpar\tx360\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
    v_paraoffset        number                              := 0;
    v_exhibit_covers    clob                                := null;
    v_exhibit_table     clob                                := null;
    v_horz_line         varchar2(1000)
        := '{\shp{\*\shpinst\shpleft0\shptop84\shpright10000\shpbottom84\shpfhdr0\shpbxcolumn\shpbxignore\shpbypara\shpbyignore\shpwr3\shpwrk0\shpfblwtxt0\shpz0\shplid1030{\sp{\sn shapeType}{\sv 20}}{\sp{\sn fFlipH}{\sv 0}}{\sp{\sn fFlipV}{\sv 0}}{\sp{\sn shapePath}{\sv 4}}{\sp{\sn fFillOK}{\sv 0}}{\sp{\sn fFilled}{\sv 0}}{\sp{\sn fArrowheadsOK}{\sv 1}}{\sp{\sn fLayoutInCell}{\sv 1}}}{\shprslt{\*\do\dobxcolumn\dobypara\dodhgt8192\dpline\dpptx0\dppty0\dpptx10680\dppty0\dpx0\dpxsize10000\dpysize0\dplinew15\dplinecor0\dplinecog0\dplinecob0}}} \par ';
---------------------------------------------
--- Generic File Report Private Variables ---
---------------------------------------------
    v_narr_toc_list     clob                                := null;
    c_blockpara         varchar2(150)
        := '}\pard \ql \li0\ri0\widctlpar\tx0\tx720\tx2160\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 {';

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
        p_offense       in   varchar2,
        p_subject       in   varchar2,
        p_victim        in   varchar2,
        p_sum_inv       in   clob)
        return varchar2 is
        v_sid           t_core_obj.SID%type;
        v_background    clob;
        v_incidentsid   varchar(20);
    begin
        -- Common file creation,
        -- handles t_core_obj, t_osi_file, starting status, lead assignment, unit owner
        v_sid := osi_file.create_instance(p_obj_type, p_title, p_restriction);
        v_background := core_util.get_config('OSI.INV_DEFAULT_BACKGROUND');

        insert into t_osi_f_investigation
                    (SID, summary_allegation)
             values (v_sid, v_background);

        if p_offense is not null and p_subject is not null and p_victim is not null then
            --Create incident
            insert into t_osi_f_inv_incident
                        (start_date)
                 values (null);

            v_incidentsid := core_sidgen.last_sid;

            --Create incident Map
            insert into t_osi_f_inv_incident_map
                        (investigation, incident)
                 values (v_sid, v_incidentsid);

            --Create offense, assign priority of 'Primary'
            insert into t_osi_f_inv_offense
                        (investigation, offense, priority)
                 values (v_sid, p_offense, (select SID
                                              from t_osi_reference
                                             where usage = 'OFFENSE_PRIORITY' and code = 'P'));

            --Create specification
            insert into t_osi_f_inv_spec
                        (investigation, offense, subject, victim, incident)
                 values (v_sid, p_offense, p_subject, p_victim, v_incidentsid);

            --Create subject involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_subject,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Subject'
                             and usage = 'SUBJECT'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));

            --Create victim involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_victim,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Victim'
                             and usage = 'VICTIM'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));

            update t_osi_f_investigation
               set summary_investigation = p_sum_inv
             where SID = v_sid;

            return v_sid;
        end if;

        if p_offense is not null then
            --Create offense, assign priority of 'Primary'
            insert into t_osi_f_inv_offense
                        (investigation, offense, priority)
                 values (v_sid, p_offense, (select SID
                                              from t_osi_reference
                                             where usage = 'OFFENSE_PRIORITY' and code = 'P'));
        end if;

        if p_subject is not null then
            --Create subject involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_subject,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Subject'
                             and usage = 'SUBJECT'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));
        end if;

        if p_victim is not null then
            --Create victim involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_victim,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Victim'
                             and usage = 'VICTIM'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));
        end if;

        if p_sum_inv is not null then
            update t_osi_f_investigation
               set summary_investigation = p_sum_inv
             where SID = v_sid;
        end if;

        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
    end create_instance;

    function next_incident_id
        return varchar2 is
        v_sid_dom   varchar2(3);
        v_nxtseq    number;
        v_nxtval    varchar2(20);
    begin
        v_sid_dom := '2M2';

        select s_incident_id.nextval
          into v_nxtseq
          from dual;

        v_nxtval := v_sid_dom || lpad(core_edit.base(36, v_nxtseq), 5, '0');
        return(v_nxtval);
    end next_incident_id;

    /* get_aah_circumstances, get_ajh_circumstances, get_crim_activity and get_vic_injuries:
       Builds an array of the data associated to the specification, and
       convert that array to an apex-friendly colon-delimited list */
    function get_aah_circumstances(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select aah
                    from t_osi_f_inv_spec_aah
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.aah;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_aah_circumstances: ' || sqlerrm);
            raise;
    end get_aah_circumstances;

    function get_ajh_circumstances(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select ajh
                    from t_osi_f_inv_spec_ajh
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.ajh;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_ajh_circumstances: ' || sqlerrm);
            raise;
    end get_ajh_circumstances;

    function get_crim_activity(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select crim_act_type
                    from t_osi_f_inv_spec_crim_act
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.crim_act_type;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_crim_activity: ' || sqlerrm);
            raise;
    end get_crim_activity;

    function get_vic_injuries(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select injury_type
                    from t_osi_f_inv_spec_vic_injury
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.injury_type;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_vic_injuries: ' || sqlerrm);
            raise;
    end get_vic_injuries;

    /* set_aah_circumstances, set_ajh_circumstances, set_crim_activity and set_vic_injuries:
       Translate colon-delimited list of sids into an array, then
       loops through and adds those that don't exist already.  Deletes those that no longer
       appear in the list */
    procedure set_aah_circumstances(p_spec_sid in varchar2, p_aah in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_aah, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_aah
                        (specification, aah)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_aah
                                   where specification = p_spec_sid and aah = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_aah
              where specification = p_spec_sid and instr(nvl(p_aah, 'null'), aah) = 0;
    exception
        when others then
            log_error('set_aah_circumstances: ' || sqlerrm);
            raise;
    end set_aah_circumstances;

    procedure set_ajh_circumstances(p_spec_sid in varchar2, p_ajh in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_ajh, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_ajh
                        (specification, ajh)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_ajh
                                   where specification = p_spec_sid and ajh = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_ajh
              where specification = p_spec_sid and instr(nvl(p_ajh, 'null'), ajh) = 0;
    exception
        when others then
            log_error('set_ajh_circumstances: ' || sqlerrm);
            raise;
    end set_ajh_circumstances;

    procedure set_crim_activity(p_spec_sid in varchar2, p_crim_act in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_crim_act, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_crim_act
                        (specification, crim_act_type)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_crim_act
                                   where specification = p_spec_sid and crim_act_type = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_crim_act
              where specification = p_spec_sid and instr(nvl(p_crim_act, 'null'), crim_act_type) = 0;
    exception
        when others then
            log_error('set_crim_activity: ' || sqlerrm);
            raise;
    end set_crim_activity;

    procedure set_vic_injuries(p_spec_sid in varchar2, p_injuries in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_injuries, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_vic_injury
                        (specification, injury_type)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_vic_injury
                                   where specification = p_spec_sid and injury_type = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_vic_injury
              where specification = p_spec_sid and instr(nvl(p_injuries, 'null'), injury_type) = 0;
    exception
        when others then
            log_error('set_vic_injuries: ' || sqlerrm);
            raise;
    end set_vic_injuries;

    function get_inv_dispositions(p_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select disposition
                    from t_osi_f_inv_disposition
                   where investigation = p_sid)
        loop
            v_array(v_idx) := i.disposition;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_inv_dispositions: ' || sqlerrm);
            raise;
    end get_inv_dispositions;

    procedure set_inv_dispositions(p_sid in varchar2, p_dispositions in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_dispositions, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_disposition
                        (investigation, disposition)
                select p_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_disposition
                                   where investigation = p_sid and disposition = v_array(i));
        end loop;

        delete from t_osi_f_inv_disposition
              where investigation = p_sid and instr(nvl(p_dispositions, 'null'), disposition) = 0;
    exception
        when others then
            log_error('set_inv_dispositions: ' || sqlerrm);
            raise;
    end set_inv_dispositions;

    function get_notify_units(p_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select unit_sid
                    from t_osi_f_notify_unit
                   where file_sid = p_sid)
        loop
            v_array(v_idx) := i.unit_sid;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_notify_units: ' || sqlerrm);
            raise;
    end get_notify_units;

    procedure set_notify_units(p_sid in varchar2, p_notify_units in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_notify_units, ':');

        for i in 1 .. v_array.count
        loop
            if v_array(i) is not null then
                insert into t_osi_f_notify_unit
                            (file_sid, unit_sid)
                    select p_sid, v_array(i)
                      from dual
                     where not exists(select 1
                                        from t_osi_f_notify_unit
                                       where file_sid = p_sid and unit_sid = v_array(i));
            end if;
        end loop;

        delete from t_osi_f_notify_unit
              where file_sid = p_sid and instr(nvl(p_notify_units, 'null'), unit_sid) = 0;
    exception
        when others then
            log_error('set_notify_units: ' || sqlerrm);
            raise;
    end set_notify_units;

    function get_primary_offense(p_sid in varchar2)
        return varchar2 is
        v_offense   varchar2(20);
    begin
        select o.offense
          into v_offense
          from t_osi_f_inv_offense o, t_osi_reference p
         where o.investigation = p_sid and o.priority = p.SID and p.code = 'P' and rownum = 1;

        return v_offense;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_primary_offense: ' || sqlerrm);
            raise;
    end get_primary_offense;

    function get_days_to_run(p_sid in varchar2)
        return number is
        v_days_to_run       number;
        v_primary_offense   varchar2(20);
    begin
        v_primary_offense := get_primary_offense(p_sid);

        if v_primary_offense is not null then
            begin
                select max(dtr.days)
                  into v_days_to_run
                  from t_osi_f_inv_daystorun dtr, t_osi_f_investigation i
                 where i.SID = p_sid and dtr.area = i.manage_by and dtr.offense = v_primary_offense;
            exception
                when others then
                    null;
            end;

            if v_days_to_run is null then
                begin
                    select days
                      into v_days_to_run
                      from t_osi_f_inv_daystorun
                     where offense = v_primary_offense and area is null;
                exception
                    when others then
                        null;
                end;
            end if;
        end if;

        return nvl(v_days_to_run, 100);
    end get_days_to_run;

    function get_timeliness_date(p_sid in varchar2)
        return date is
        v_days_to_run   number;
    begin
        return trunc(osi_status.last_sh_create_on(p_sid, 'NW') + get_days_to_run(p_sid));
    exception
        when others then
            log_error('get_timeliness_date: ' || sqlerrm);
            raise;
    end get_timeliness_date;

    function generate_full_id(p_sid in varchar2)
        return varchar2 is
        v_inv_type               t_core_obj_type.code%type;
        v_primary_offense_code   t_dibrs_offense_type.code%type;
        v_full_id                t_osi_file.full_id%type;
        v_id                     t_osi_file.id%type;
    begin
        begin
            select ot.code, f.full_id, f.id
              into v_inv_type, v_full_id, v_id
              from t_core_obj o, t_osi_file f, t_core_obj_type ot
             where o.SID = p_sid and f.SID = o.SID and ot.SID = o.obj_type;
        exception
            when no_data_found then
                null;
        end;

        if v_full_id is not null then
            return v_full_id;
        end if;

        select unit_code || '-'
          into v_full_id
          from t_osi_unit
         where SID = osi_file.get_unit_owner(p_sid);

        case v_inv_type
            when 'FILE.INV.CASE' then
                v_full_id := v_full_id || 'C-';
            when 'FILE.INV.DEV' then
                v_full_id := v_full_id || 'D-';
            when 'FILE.INV.INFO' then
                v_full_id := v_full_id || 'I-';
            else
                v_full_id := v_full_id || '?-';
        end case;

        begin
            select code
              into v_primary_offense_code
              from t_dibrs_offense_type
             where SID = get_primary_offense(p_sid);
        exception
            when no_data_found then
                v_full_id := v_full_id || 'INVSTGTV-' || v_id;
                return v_full_id;
        end;

        if v_primary_offense_code is not null then
            v_full_id := v_full_id || v_primary_offense_code || '-' || v_id;
        end if;

        return v_full_id;
    exception
        when others then
            log_error('get_full_id: ' || sqlerrm);
            raise;
    end generate_full_id;

procedure clone_specifications(p_old_sid in varchar2, p_new_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) is

         v_new_spec_sid   t_osi_f_inv_spec.SID%type;

begin
     for i in (select * from t_osi_f_inv_spec where investigation=p_old_sid and subject in  (select * from table(split(p_parameter1,'~')) where column_value is not null))
     loop
         --- clone main spec record ---
         insert into t_osi_f_inv_spec
                    (investigation,
                     offense,
                     subject,
                     victim,
                     incident,
                     off_result,
                     off_loc,
                     off_on_usi,
                     off_us_state,
                     off_country,
                     off_involvement,
                     off_committed_on,
                     sub_susp_alcohol,
                     sub_susp_drugs,
                     sub_susp_computer,
                     vic_rel_to_offender,
                     num_prem_entered,
                     entry_method,
                     bias_motivation,
                     sexual_harassment_related,
                     vic_susp_alcohol,
                     vic_susp_drugs,
                     sapro_incident_location_code,
                     sapro_incident_location_csc)
             values (p_new_sid,
                     i.offense,
                     i.subject,
                     i.victim,
                     i.incident,
                     i.off_result,
                     i.off_loc,
                     i.off_on_usi,
                     i.off_us_state,
                     i.off_country,
                     i.off_involvement,
                     i.off_committed_on,
                     i.sub_susp_alcohol,
                     i.sub_susp_drugs,
                     i.sub_susp_computer,
                     i.vic_rel_to_offender,
                     i.num_prem_entered,
                     i.entry_method,
                     i.bias_motivation,
                     i.sexual_harassment_related,
                     i.vic_susp_alcohol,
                     i.vic_susp_drugs,
                     i.sapro_incident_location_code,
                     i.sapro_incident_location_csc)
          returning SID
               into v_new_spec_sid;

        --- clone aah list ---
        insert into t_osi_f_inv_spec_aah (specification, aah)
            select v_new_spec_sid, aah from t_osi_f_inv_spec_aah
             where specification = i.SID;

         --- clone ajh list ---
         insert into t_osi_f_inv_spec_ajh (specification, ajh)
            select v_new_spec_sid, ajh from t_osi_f_inv_spec_ajh
             where specification = i.SID;

        --- clone weapon force used list ---
        insert into t_osi_f_inv_spec_arm (specification, armed_with, gun_category)
            select v_new_spec_sid, armed_with, gun_category from t_osi_f_inv_spec_arm
             where specification = i.SID;

        --- clone criminal activities list ---
        insert into t_osi_f_inv_spec_crim_act (specification, crim_act_type)
            select v_new_spec_sid, crim_act_type from t_osi_f_inv_spec_crim_act
             where specification = i.SID;

        --- clone victim injuries list ---
        insert into t_osi_f_inv_spec_vic_injury (specification, injury_type)
            select v_new_spec_sid, injury_type from t_osi_f_inv_spec_vic_injury
             where specification = i.SID;
    end loop;

exception when others then

        log_error('clone_specifications: ' || sqlerrm);
        raise;

end clone_specifications;
    
/* p_parameter1 is a list of Subjects to Create the Case with (separated with a ~) */
function clone_to_case(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) return varchar2 is

        v_new_sid        t_core_obj.SID%type;
        v_old_id         t_osi_file.id%type;
        v_new_id         t_osi_file.id%type;
        v_close_status   t_osi_status.SID%type;
        v_note_sid       t_osi_note.SID%type;
        v_starting_status  t_osi_status.sid%type;

begin
     --- clone object ---
     insert into t_core_obj (obj_type)
             values (core_obj.lookup_objtype('FILE.INV.CASE')) returning SID into v_new_sid;

     v_new_id := osi_object.get_next_id;

     --- clone basic file info ---
     insert into t_osi_file (SID, id, title, closed_short, restriction)
           select v_new_sid, v_new_id, title, closed_short, restriction from t_osi_file where SID = p_sid;

     --- clone investigation ---
     insert into t_osi_f_investigation
                (SID,
                 manage_by,
                 manage_by_appv,
                 memo_5,
                 resolution,
                 summary_allegation,
                 summary_investigation,
                 afrc)
        select v_new_sid, manage_by, manage_by_appv, memo_5, resolution, summary_allegation,
               summary_investigation, afrc
          from t_osi_f_investigation
         where SID = p_sid;

    --- clone offenses ---
    insert into t_osi_f_inv_offense
                (investigation, offense, priority)
        select v_new_sid, offense, priority
          from t_osi_f_inv_offense
         where investigation = p_sid;

    clone_specifications(p_sid, v_new_sid, p_parameter1, p_parameter2);

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

    --- map incidents to this file ---
    insert into t_osi_f_inv_incident_map (investigation, incident)
        select v_new_sid, incident from t_osi_f_inv_incident_map
         where investigation = p_sid;

    --- clone special interest mission areas ---
    insert into t_osi_mission (obj, mission, obj_context)
        select v_new_sid, mission, obj_context from t_osi_mission
         where obj = p_sid and obj_context='I';

    --- clone units to notify ---
    insert into t_osi_f_notify_unit (file_sid, unit_sid)
        select v_new_sid, unit_sid
          from t_osi_f_notify_unit
         where file_sid = p_sid;

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
         where ot.sid=ct.sid and ct.code='FILE.INV.CASE';
        
    insert into t_osi_status_history
                (obj, status, effective_on, transition_comment, is_current) values
                (v_new_sid, v_starting_status, sysdate, 'Created', 'Y');

    --- close old file if informational ---
    if core_obj.get_objtype(p_sid) = core_obj.lookup_objtype('FILE.INV.INFO') then

      select SID into v_close_status from t_osi_status where code = 'CL';

      osi_status.change_status_brute(p_sid, v_close_status, 'Closed (Short) with Case Creation');

      v_note_sid := osi_note.add_note (p_sid, osi_note.get_note_type(core_obj.lookup_objtype('FILE.INV.INFO'), 'CLOSURE'), 'Original documents are contained in the associated case file:  ' || v_new_id || '.');

    end if;

    select id into v_old_id from t_osi_file where SID = p_sid;

    --- Add Note ---
    v_note_sid := osi_note.add_note(v_new_sid, osi_note.get_note_type(core_obj.lookup_objtype('FILE.INV.CASE'), 'CREATE'), 'This Case File was created using the following File:  ' || v_old_id || '.');
    return v_new_sid;

exception when others then

    log_error('clone_to_case: ' || sqlerrm);
    raise;
        
end clone_to_case;

    procedure change_inv_type(p_sid in varchar2, p_new_type in varchar2) is
    begin
        --change object type
        update t_core_obj
           set obj_type = p_new_type,
               acl = null
         where SID = p_sid and obj_type <> p_new_type;

        --delete property records
        delete from t_osi_f_inv_property
              where specification in(select SID
                                       from t_osi_f_inv_spec
                                      where investigation = p_sid);

        --delete subject disposition records (cascades children)
        delete from t_osi_f_inv_subj_disposition
              where investigation = p_sid;

        --delete investigation dispositions
        delete from t_osi_f_inv_disposition
              where investigation = p_sid;

        --delete incident dispositions
        update t_osi_f_inv_incident
           set clearance_reason = null
         where SID in(select incident
                        from t_osi_f_inv_incident_map
                       where investigation = p_sid);

        --clear overall investigative disposition
        update t_osi_f_investigation
           set resolution = null
         where SID = p_sid;
    exception
        when others then
            log_error('change_inv_type: ' || sqlerrm);
            raise;
    end change_inv_type;

    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_obj_type   t_core_obj_type.SID%type;
    begin
        v_obj_type := core_obj.get_objtype(p_obj);

        case osi_object.get_status_code(p_obj)
            when 'NW' then
                return 'Y';
            when 'AA' then
                --return osi_auth.check_for_priv('APPROVE_OP', v_obj_type);
                return osi_auth.check_for_priv('APPROVE', v_obj_type);
            when 'OP' then
                return 'Y';
            when 'AC' then
                --return osi_auth.check_for_priv('APPROVE_CL', v_obj_type);
                return osi_auth.check_for_priv('CLOSE', v_obj_type);
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

    function get_final_roi_date(p_obj varchar2)
        return date is
        v_return   date;
    begin
        select max(a.create_on)
          into v_return
          from t_osi_attachment a, t_osi_attachment_type at
         where a.obj = p_obj and at.SID = a.type and at.code = 'ROIFP';--'ROISFS';

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_final_roi_date: ' || sqlerrm);
            raise;
    end get_final_roi_date;

--======================================================================================================================
--  Produces the html document for the investigative file report.
--======================================================================================================================
    procedure make_doc_investigative_file(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp           varchar2(30000);
        v_temp_clob      clob;
        v_template       clob;
        v_fle_rec        t_osi_file%rowtype;
        v_inv_rec        t_osi_f_investigation%rowtype;
        v_ok             varchar2(1000);                     -- flag indicating success or failure.
        v_cnt            number;
        dispositions     varchar2(2000);
        resdescription   varchar2(100);
    begin
        core_logger.log_it(c_pipe, '--> make_doc_fle');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                      (c_pipe,
                       'ODW.Make_Doc_FLE: Investigation is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                     (c_pipe,
                      'ODW.Make_Doc_FLE: Investigation is LIMDIS - no document will be synthesized');
            return;
        end if;

        select *
          into v_fle_rec
          from t_osi_file
         where SID = p_sid;

        select *
          into v_inv_rec
          from t_osi_f_investigation
         where SID = p_sid;

        osi_object.get_template('OSI_ODW_DETAIL_FLE', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Put in summary fields
        v_ok := core_template.replace_tag(v_template, 'ID', v_fle_rec.id);
        v_ok := core_template.replace_tag(v_template, 'TITLE', v_fle_rec.title);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'SUMMARY_ALLEGATION',
                                      core_util.html_ize(v_inv_rec.summary_allegation));
        v_ok :=
            core_template.replace_tag(v_template,
                                      'SUMMARY_INVESTIGATION',
                                      core_util.html_ize(v_inv_rec.summary_investigation));
        -- get participants involved
        osi_object.append_involved_participants(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'PAR_INVOLVED', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);

        -- get offenses
        select count(*)
          into v_cnt
          from v_osi_f_inv_offense
         where investigation = p_sid;

        if v_cnt > 0 then
            v_temp :=
                '<TR><TD nowrap><b>Priority</b></TD>' || '<TD nowrap><b>Code</b></TD>'
                || '<TD width="100%"><b>Description</b></TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
            v_cnt := 0;

            for h in (select   o.priority_desc, ot.code, o.offense_desc
                          from v_osi_f_inv_offense o, t_dibrs_offense_type ot
                         where o.investigation = p_sid and o.offense = ot.SID
                      order by decode(o.priority_desc, 'Primary', 1, 'Reportable', 2, 3), ot.code)
            loop
                v_cnt := v_cnt + 1;
                v_temp :=
                    '<TR>' || '<TD nowrap><b>' || v_cnt || ': </b>' || h.priority_desc || '</TD>'
                    || '<TD nowrap>' || h.code || '</TD>' || '<TD width="100%">' || h.offense_desc
                    || '</TD>' || '</TR>';
                osi_util.aitc(v_temp_clob, v_temp);
            end loop;
        else
            osi_util.aitc(v_temp_clob, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        end if;

        v_ok := core_template.replace_tag(v_template, 'OFFENSES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);

        -- Subject Disposition List --
        select count(*)
          into v_cnt
          from t_osi_f_inv_subj_disposition sd,
               t_osi_f_inv_court_action_type c,
               t_osi_participant_version s,
               t_osi_partic_name sn,
               (select code
                  from t_dibrs_reference
                 where usage = 'STATUTORY_BASIS') dr,
               (select code
                  from t_osi_reference
                 where usage = 'INV_DISPOSITION_TYPE') osir
         where c.code = osir.code
           and s.SID = sd.subject
           and sn.SID(+) = s.current_name
           and dr.code(+) = sd.jurisdiction
           and sd.investigation = p_sid;

        if v_cnt > 0 then
            v_temp :=
                '<TR><TD nowrap><b>Subject Name</b></TD>'
                || '<TD nowrap><b>Disposition Description</b></TD>'
                || '<TD nowrap><b>Jurisdiction</b></TD>' || '<TD nowrap><b>Rendered</b></TD>'
                || '<TD nowrap><b>Notified</b></TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
            v_cnt := 0;

            for h in (select sd.SID, sd.investigation, sd.subject, osir.code, sd.jurisdiction,
                             sd.rendered_on, sd.notified_on, sd.comments, sd.create_by,
                             sd.create_on, sd.modify_by, sd.modify_on, c.description as disp_desc,
                             nvl(sn.last_name || ' ' || sn.first_name || ' ' || sn.middle_name,
                                 'None Specified') as subject_name,
                             dr.description as jurisdiction_desc
                        from t_osi_f_inv_subj_disposition sd,
                             t_osi_f_inv_court_action_type c,
                             t_osi_participant_version s,
                             t_osi_partic_name sn,
                             (select code, description
                                from t_dibrs_reference
                               where usage = 'STATUTORY_BASIS') dr,
                             (select code
                                from t_osi_reference
                               where usage = 'INV_DISPOSITION_TYPE') osir
                       where c.code = osir.code
                         and s.SID = sd.subject
                         and sn.SID(+) = s.current_name
                         and dr.code(+) = sd.jurisdiction
                         and sd.investigation = p_sid)
            loop
                v_cnt := v_cnt + 1;

                if v_cnt > 1 then
                    v_temp := '<TR BGCOLOR=#C0C0C0><TD colspan=8>&nbsp;</TD><TR>';
                else
                    v_temp := '';
                end if;

                v_temp :=
                    v_temp || '<TR>' || '<TD nowrap><b>' || v_cnt || ': </b>' || h.subject_name
                    || '&nbsp;</TD>' || '<TD nowrap>' || h.disp_desc || '&nbsp;</TD>'
                    || '<TD nowrap>' || h.jurisdiction_desc || '&nbsp;</TD>' || '<TD nowrap>'
                    || h.rendered_on || '&nbsp;</TD>' || '<TD nowrap>' || h.notified_on
                    || '&nbsp;</TD></TR>';

                if    h.comments <> ''
                   or h.comments is not null then
                    v_temp :=
                        v_temp
                        || '<TR><TD>&nbsp;</TD><TD colspan=4 width="100%"><CENTER><B>Comments</B></CENTER></TD></TR>'
                        || '<TR><TD>&nbsp;</TD><TD colspan=4 width="100%">' || h.comments
                        || '</TD></TR>';
                end if;

                osi_util.aitc(v_temp_clob, v_temp);
            end loop;
        else
            osi_util.aitc(v_temp_clob, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        end if;

        v_ok := core_template.replace_tag(v_template, 'SUBJECTDISPO', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);

        -- Incident/Investigation Disposition List --
        select count(*)
          into v_cnt
          from (select d.SID
                  from t_osi_f_inv_incident d, t_dibrs_clearance_reason_type dcr
                 where dcr.SID(+) = d.clearance_reason
                       and d.stat_basis in(select SID
                                             from t_dibrs_reference
                                            where usage = 'STATUTORY_BASIS')) a,
               (select im.incident
                  from t_osi_f_inv_incident c, t_osi_f_inv_incident_map im
                 where im.investigation = p_sid and c.SID = im.incident) i
         where a.SID = i.incident;

        if v_cnt > 0 then
            v_temp :=
                '<TR><TD nowrap><b>Incident ID</b></TD>' || '<TD nowrap><b>Description</b></TD>'
                || '<TD nowrap><b>Clearance Reason</b></TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
            v_cnt := 0;

            for h in (select a.incident_num, a.description, a.clearance_reason_desc
                        from (select i.SID as incident_num, dr.description,
                                     dc.description as clearance_reason_desc
                                from t_osi_f_inv_incident i,
                                     t_dibrs_clearance_reason_type dc,
                                     t_dibrs_reference dr
                               where dc.code(+) = i.clearance_reason and dr.SID(+) = i.stat_basis) a,
                             (select im.incident
                                from t_osi_f_inv_incident c, t_osi_f_inv_incident_map im
                               where im.investigation = p_sid and c.SID = im.incident) b
                       where a.incident_num = b.incident)
            loop
                v_cnt := v_cnt + 1;
                v_temp :=
                    '<TR>' || '<TD nowrap><b>' || v_cnt || ': </b>' || h.incident_num
                    || '&nbsp;</TD>' || '<TD nowrap>' || h.description || '&nbsp;</TD>'
                    || '<TD nowrap>' || h.clearance_reason_desc || '&nbsp;</TD></TR>';
                osi_util.aitc(v_temp_clob, v_temp);
            end loop;
        else
            osi_util.aitc(v_temp_clob, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        end if;

        -- Investigation Dispositions List and Resolution --
        select count(*)
          into v_cnt
          from t_osi_f_inv_subj_disposition id,
               (select SID
                  from t_osi_reference
                 where usage = 'INV_DISPOSITION_TYPE') idt
         where id.investigation = p_sid and id.disposition = idt.SID;

        if v_cnt > 0 then
            dispositions := '';

            for h in (select   idt.description
                          from t_osi_f_inv_subj_disposition id,
                               (select SID, description
                                  from t_osi_reference
                                 where usage = 'INV_DISPOSITION_TYPE') idt
                         where id.investigation = p_sid and id.disposition = idt.SID
                      order by idt.description)
            loop
                dispositions := dispositions || h.description || ', ';
            end loop;

            dispositions := substr(dispositions, 1, length(dispositions) - 2);
            v_temp :=
                '</TABLE><TABLE><TR><TD nowrap><b>Investigation Dispositions</b></TD>'
                || '<TD nowrap><b>Investigation Resolution</b></TD></TR>';

            select description
              into resdescription
              from t_osi_f_investigation inv,
                   (select SID, description
                      from t_osi_reference
                     where usage = 'INV_RESOLUTION_TYPE') ir
             where inv.SID = p_sid and inv.resolution = ir.SID(+);

            if    dispositions = ''
               or dispositions is null then
                dispositions := 'No Data Found';
            end if;

            v_temp :=
                v_temp || '<TR>' || '<TD width=100%>' || dispositions || '&nbsp;</TD>'
                || '<TD nowrap>' || resdescription || '&nbsp;</TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
        else
            osi_util.aitc(v_temp_clob, '</TABLE><TABLE>');
        end if;

        v_ok := core_template.replace_tag(v_template, 'INVDISPO', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Associated Activities.
        osi_object.append_assoc_activities(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ASSOCIATED_ACTIVITIES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Related Files.
        osi_object.append_related_files(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ASSOCIATED_FILES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Attachment Descriptions
        osi_object.append_attachments(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENT_DESC', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Notes
        osi_object.append_notes(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'NOTES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- return the completed template
        dbms_lob.append(p_doc, v_template);
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_fle');
    exception
        when no_data_found then
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_FLE Error: Non Investigative File SID Error');
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_FLE Error: ' || v_syn_error);
    end make_doc_investigative_file;

    function summary_complaint_rpt(psid in varchar2)
        return clob is
        v_ok                   varchar2(1000);
        v_template             clob                                    := null;
        v_template_date        date;
        v_mime_type            t_core_template.mime_type%type;
        v_mime_disp            t_core_template.mime_disposition%type;
        htmlorrtf              varchar2(4)                             := 'RTF';
        v_tempstring           clob;
        v_recordcounter        number;
        v_crlfpos              number;
        v_personnel_sid        varchar2(20);
        v_not_approved         varchar2(25)                            := 'FILE NOT YET APPROVED';
        v_approval_authority   varchar2(400)                           := null;
        v_approval_unitname    varchar2(400)                           := null;
        v_approval_date        date;
        inifilename            varchar2(400);
        v_name                 varchar2(1000);
        v_maiden               varchar2(1000);
        v_akas                 varchar2(1000);
        v_sex                  varchar2(400);
        v_dob                  varchar2(400);
        v_pob                  varchar2(400);
        v_pp                   varchar2(400);
        v_pg                   varchar2(400);
        v_ppg                  varchar2(400);
        v_saa                  varchar2(400);
        v_per                  varchar2(400);
        v_pt                   varchar2(400);
        v_ssn                  varchar2(400);
        v_org                  varchar2(400);
        v_org_name             varchar2(400);
        v_org_majcom           varchar2(400);
        v_base                 varchar2(400);
        v_base_loc             varchar2(400);
        v_relatedper           varchar2(400);
        v_lastunitname         varchar2(100);
        v_sig_block            varchar2(500);
        v_agent_name           varchar2(500);
        v_result               varchar2(4000);
        v_class                varchar2(100);
    begin
        log_error('>>> Summary_Complaint_Report');
        osi_report.load_participants(psid);
        osi_report.load_agents_assigned(psid);
        v_ok :=
            core_template.get_latest('SUMMARY_COMPLAINT_RPT',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        --- Replace File SID for Links that can be clicked on ---
        v_ok :=
            core_template.replace_tag(v_template,
                                      'FILE_SID',
                                      osi_report.replace_special_chars(psid, htmlorrtf),
                                      'TOKEN@',
                                      true);

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, htmlorrtf),
                                      'TOKEN@',
                                      true);
         --- Replace INI Filename for Links that can be clicked on ---
        /* begin
             select value
               into inifilename
               from t_core_config
              where code = 'DEFAULTINI';
         exception
             when no_data_found then
                 null;
         end;

         if inifilename is null then
             inifilename := 'I2MS.INI';
         end if; */
        v_ok :=
            core_template.replace_tag(v_template,
                                      'INI_FILE',
                                      osi_object.get_tagline_link(psid),
                                      'TOKEN@',
                                      true);
        --- Get Parts we can get from the Main Tables ---
        v_recordcounter := 1;

        for a in (select *
                    from v_osi_rpt_complaint_summary
                   where SID = psid)
        loop
            if v_recordcounter = 1 then
                v_ok :=
                    core_template.replace_tag
                                      (v_template,
                                       'SUMMARY_OF_ALLEGATION',
                                       osi_report.replace_special_chars_clob(a.summary_allegation,
                                                                             htmlorrtf));

                if a.summary_allegation = a.summary_investigation then
                    v_ok :=
                        core_template.replace_tag(v_template, 'SUMMARY_OF_INVESTIGATION_HEADER',
                                                  '');
                    v_ok := core_template.replace_tag(v_template, 'SUMMARY_OF_INVESTIGATION', '');
                else
                    v_ok :=
                        core_template.replace_tag
                              (v_template,
                               'SUMMARY_OF_INVESTIGATION_HEADER',
                               '\par '
                               || osi_report.replace_special_chars_clob('SUMMARY OF INVESTIGATION',
                                                                        htmlorrtf)
                               || '\par ');
                    v_ok :=
                        core_template.replace_tag
                                  (v_template,
                                   'SUMMARY_OF_INVESTIGATION',
                                   '\par '
                                   || osi_report.replace_special_chars_clob
                                                                           (a.summary_investigation,
                                                                            htmlorrtf)
                                   || '\par ');
                end if;

                v_ok :=
                    core_template.replace_tag(v_template,
                                              'FULL_ID',
                                              osi_report.replace_special_chars(nvl(a.full_id,
                                                                                   a.file_id),
                                                                               htmlorrtf),
                                              'TOKEN@',
                                              true);
                v_ok :=
                    core_template.replace_tag(v_template,
                                              'FILE_ID',
                                              osi_report.replace_special_chars(a.file_id, htmlorrtf),
                                              'TOKEN@',
                                              true);
                v_ok :=
                    core_template.replace_tag(v_template,
                                              'TITLE',
                                              osi_report.replace_special_chars(a.title, htmlorrtf),
                                              'TOKEN@',
                                              true);
                v_ok :=
                    core_template.replace_tag(v_template,
                                              'FILE_TYPE',
                                              osi_report.replace_special_chars(a.file_type,
                                                                               htmlorrtf),
                                              'TOKEN@',
                                              true);
                v_ok :=
                    core_template.replace_tag
                                     (v_template,
                                      'EFF_DATE',
                                      osi_report.replace_special_chars(to_char(a.effective_date,
                                                                               v_date_fmt),
                                                                       htmlorrtf),
                                      'TOKEN@',
                                      true);
                v_ok :=
                    core_template.replace_tag(v_template,
                                              'MISSION',
                                              osi_report.replace_special_chars(a.mission_area,
                                                                               htmlorrtf),
                                              'TOKEN@',
                                              true);
                v_tempstring := a.special_interest;

                if a.status <> 'OP' then
                    v_approval_authority := v_not_approved;
                end if;
            else
                --- There can be More than One Special Interest ---
                if v_tempstring is not null then
                    v_tempstring := v_tempstring || '\par ';
                end if;

                v_tempstring :=
                     v_tempstring || osi_report.replace_special_chars(a.special_interest, htmlorrtf);
            end if;

            v_recordcounter := v_recordcounter + 1;
        end loop;

        --- Replace Special Interest ---
        if v_tempstring is null then
            v_ok := core_template.replace_tag(v_template, 'SI', 'None', 'TOKEN@', true);
        else
            v_ok := core_template.replace_tag(v_template, 'SI', v_tempstring, 'TOKEN@', true);
        end if;

        --- Offenses List ---
        v_tempstring := null;

        for a in (select   r.description as priority,
                           ot.description || ', ' || ot.code offense_desc
                      from t_osi_f_inv_offense o, t_osi_reference r, t_dibrs_offense_type ot
                     where o.investigation = psid and o.priority = r.SID and o.offense = ot.SID
                  order by priority, offense_desc)
        loop
            if v_tempstring is not null then
                v_tempstring := v_tempstring || '\par ';
            end if;

            v_tempstring := v_tempstring || a.offense_desc;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'OFFENSES', v_tempstring);
        --- Subject List ---
        v_tempstring := null;

        for a in (select participant_version
                    from t_osi_partic_involvement pi,
                         t_osi_participant_version pv,
                         t_osi_partic_role_type prt
                   where pi.obj = psid
                     and pi.participant_version = pv.SID
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Subject'
                     and prt.usage = 'SUBJECT')
        loop
            --- Get Names ONLY ---
            get_basic_info(a.participant_version, v_name, v_saa, v_per, true, true, false, false);
            --- Get All other needed information ---
            get_basic_info(a.participant_version,
                           v_result,
                           v_saa,
                           v_per,
                           false,
                           false,
                           false,
                           false);

            if v_saa = 'ME' then                                      --- military (or employee) ---
                v_result := v_result || nvl(get_org_info(a.participant_version), 'UNK');
            end if;

            if v_tempstring is not null then
                v_tempstring := v_tempstring || '\par\par ';
            end if;

            v_tempstring := v_tempstring || v_name || v_result;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'SUBJECTS', v_tempstring, 'TOKEN@', true);
        --- Victim List ---
        v_tempstring := null;

        for a in (select participant_version
                    from t_osi_partic_involvement pi,
                         t_osi_participant_version pv,
                         t_osi_partic_role_type prt
                   where pi.obj = psid
                     and pi.participant_version = pv.SID
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Victim'
                     and prt.usage = 'VICTIM')
        loop
            --- Get Names ONLY ---
            get_basic_info(a.participant_version, v_name, v_saa, v_per, true, true, false, false);
            --- Get All other needed information ---
            get_basic_info(a.participant_version,
                           v_result,
                           v_saa,
                           v_per,
                           false,
                           false,
                           false,
                           false);

            if v_saa = 'ME' then                                      --- military (or employee) ---
                v_result := v_result || nvl(get_org_info(a.participant_version), 'UNK');
            end if;

            if v_tempstring is not null then
                v_tempstring := v_tempstring || '\par\par ';
            end if;

            v_tempstring := v_tempstring || v_name || v_result;
        --v_tempstring := v_tempstring || ' ' || v_result;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'VICTIMS', v_tempstring, 'TOKEN@', true);

        --- Lead Agent ---
        for a in (select personnel, first_name || ' ' || last_name as personnel_name, un.unit_name
                    from v_osi_obj_assignments oa, t_osi_unit_name un
                   where obj = psid and un.unit = oa.current_unit and role = 'LEAD' and un.end_date is null)
        loop
            select 'SA ' || first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name,
                   first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name || ', SA, '
                   || decode(op.pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
              into v_agent_name,
                   v_sig_block
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = a.personnel and cp.SID = op.SID;

            v_ok :=
                core_template.replace_tag(v_template, 'LEADAGENTNAME', v_agent_name, 'TOKEN@',
                                          false);
            v_ok :=
                core_template.replace_tag(v_template, 'LEADAGENTNAME', v_sig_block, 'TOKEN@', false);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'UNITNAME',
                                          osi_report.replace_special_chars(a.unit_name, htmlorrtf),
                                          'TOKEN@',
                                          true);
            v_personnel_sid := a.personnel;
            exit;
        end loop;

        --- Submitted for Approval Date ---
        begin
            select to_char(osi_status.first_sh_date(psid, 'AA'), v_date_fmt)
              into v_approval_date
              from dual;
        exception
            when no_data_found then
                null;
        end;

        if v_approval_date is null then
            v_ok :=
                core_template.replace_tag(v_template,
                                          'SUBMIT_FOR_APPROVAL_DATE',
                                          'FILE NOT YET SUBMITTED FOR APPROVAL');
        else
            v_ok :=
                 core_template.replace_tag(v_template, 'SUBMIT_FOR_APPROVAL_DATE', v_approval_date);
        end if;

        --- Approval Date ---
        begin
            select to_char(osi_status.first_sh_date(psid, 'OP'), v_date_fmt)
              into v_tempstring
              from dual;
        exception
            when no_data_found then
                null;
        end;

        if v_tempstring is null then
            v_ok := core_template.replace_tag(v_template, 'APPROVAL_DATE', 'FILE NOT YET APPROVED');
        else
            v_ok := core_template.replace_tag(v_template, 'APPROVAL_DATE', v_tempstring);
        end if;

        --- Approval Authority ---
--        for a in (select personnel, first_name || ' ' || last_name as personnel_name, un.unit_name
--                    from v_osi_obj_assignments oa, t_osi_unit_name un
--                   where obj = psid and un.unit = oa.current_unit and role = 'LEAD')
--        loop
        for a in (select SID as personnel, personnel_name, unit_name
                    from v_osi_personnel
                   where SID = core_context.PERSONNEL_SID)
        loop
            if v_approval_authority is null then
                select first_name || ' '
                       || decode(length(middle_name),
                                 1, middle_name || '. ',
                                 0, ' ',
                                 null, ' ',
                                 substr(middle_name, 1, 1) || '. ')
                       || last_name || ', SA, '
                       || decode(pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
                  into v_approval_authority
                  from t_core_personnel cp, t_osi_personnel op
                 where cp.SID = a.personnel and cp.SID = op.SID;
            end if;

            v_approval_unitname := a.unit_name;
            v_personnel_sid := a.personnel;
            exit;
        end loop;

        v_ok :=
            core_template.replace_tag
                         (v_template,
                          'APPROVALAUTHORITY',
                          osi_report.replace_special_chars(nvl(v_approval_authority,
                                                               'Approval Authority not assigned'),
                                                           htmlorrtf),
                          'TOKEN@',
                          true);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'APPROVALAUTHORITYUNIT',
                                      osi_report.replace_special_chars(v_approval_unitname,
                                                                       htmlorrtf),
                                      'TOKEN@',
                                      true);
        --- Related Activities ---
        v_tempstring := null;
        v_recordcounter := 0;
        log_error('Starting related Activities');

        for a in (select   a.SID as activity, a.narrative as activity_narrative,
                           replace(roi_header(a.SID), ' \line', '') as header
                      from t_osi_assoc_fle_act afa, t_osi_activity a
                     where afa.file_sid = psid and afa.activity_sid = a.SID
                  order by activity)
        loop
            v_recordcounter := v_recordcounter + 1;

            select instr(a.header, chr(13) || chr(10))
              into v_crlfpos
              from dual;

            v_tempstring :=
                v_tempstring
                || '\trowd \irow0\irowband0\ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt';
            v_tempstring :=
                v_tempstring
                || '\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth468\clshdrawnil \cellx360\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9108\clshdrawnil';
            v_tempstring :=
                v_tempstring
                || '\cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\faauto\adjustright\rin0\lin0\pararsid11419280\yts15 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \b '
                || ltrim(rtrim(to_char(v_recordcounter))) || '.\cell \pard';
            v_tempstring :=
                v_tempstring
                || '\ql \li44\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin44\pararsid11419280\yts15 ';

            if v_crlfpos > 0 then
                v_tempstring :=
                    v_tempstring                                               --|| '\cs16\ul\cf2 '
                    || replace(osi_report.replace_special_chars(substr(a.header, 1, v_crlfpos - 1),
                                                                htmlorrtf),
                               '\\tab',
                               '\tab')
                    || ' \b \line '
                    || replace(osi_report.replace_special_chars(substr(a.header,
                                                                       v_crlfpos + 2,
                                                                       length(a.header) - v_crlfpos
                                                                       + 1),
                                                                htmlorrtf),
                               '\\tab',
                               '\tab');
            else
                v_tempstring :=
                    v_tempstring                                               --|| '\cs16\ul\cf2 '
                    || replace(osi_report.replace_special_chars(a.header, htmlorrtf),
                               '\\tab',
                               '\tab')
                    || '\b';
            end if;

            v_tempstring :=
                v_tempstring
                || '\par \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \b \trowd \irow0\irowband0';
            v_tempstring :=
                v_tempstring
                || '\ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_tempstring :=
                v_tempstring
                || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth468\clshdrawnil \cellx360\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9108\clshdrawnil \cellx9468\row \trowd \irow1\irowband1\lastrow';
            v_tempstring :=
                v_tempstring
                || '\ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_tempstring :=
                v_tempstring
                || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\faauto\adjustright\rin0\lin0\pararsid11419280\yts15 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
            v_tempstring :=
                v_tempstring || osi_report.replace_special_chars(a.activity_narrative, htmlorrtf)
                || '\b \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \b';
            v_tempstring :=
                v_tempstring
                || '\trowd \irow1\irowband1\lastrow \ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrtbl';
            v_tempstring :=
                v_tempstring
                || '\clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 \par ';
        end loop;

        v_ok := core_template.replace_tag(v_template, 'ASSOCIATED_ACTIVITIES', v_tempstring);
        --- Related Files ---
        v_tempstring := null;

        for a in (select   that_file_full_id, that_file_id, that_file, that_file_title,
                           that_file_type_desc,
                           (select description
                              from t_osi_status_history sh, t_osi_status s
                             where sh.obj = psid
                               and s.SID = sh.status
                               and sh.is_current = 'Y') as that_status_desc
                      from v_osi_assoc_fle_fle
                     where this_file = psid
                  order by that_file_id)
        loop
            v_tempstring :=
                v_tempstring
                || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1890\clshdrawnil';
            v_tempstring :=
                v_tempstring
                || '\cellx1890\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4410\clshdrawnil \cellx6300\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx7830\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx9360\pard\plain';
            v_tempstring :=
                v_tempstring
                || '\ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid12283215 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 '
                || nvl(a.that_file_full_id, a.that_file_id) || ' \cell ';
            v_tempstring :=
                v_tempstring || a.that_file_title || '\cell ' || a.that_file_type_desc || ' \cell ';
            v_tempstring :=
                v_tempstring || a.that_status_desc
                || ' \cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl';
            v_tempstring :=
                v_tempstring
                || '\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr';
            v_tempstring :=
                v_tempstring
                || '\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1890\clshdrawnil \cellx1890\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4410\clshdrawnil \cellx6300\clvertalt\clbrdrt';
            v_tempstring :=
                v_tempstring
                || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx7830\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx9360\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
        end loop;

        v_ok :=
             core_template.replace_tag(v_template, 'ASSOCIATED_FILES', v_tempstring, 'TOKEN@', true);
        --- OSI Assignements ---
        v_tempstring := null;

        for a in (select   cp.first_name || ' ' || last_name as personnel_name,
                           art.description as assign_role, un.unit_name
                      from t_osi_assignment a,
                           t_osi_assignment_role_type art,
                           t_core_personnel cp,
                           t_osi_unit u,
                           t_osi_unit_name un
                     where a.personnel = cp.SID
                       and a.unit = u.SID
                       and u.SID = un.unit
                       and a.assign_role = art.SID
                       and obj = psid
                       and art.description <> 'Administrative'
                       and un.end_date is null
                  order by a.assign_role, a.start_date)
        loop
            v_tempstring :=
                v_tempstring
                || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid13590504 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\cltxlrtb\clftsWidth3\clwWidth1620\clshdrawnil \cellx1620\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4500\clshdrawnil \cellx6120\clvertalt\clbrdrt\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3240\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid13590504';
            v_tempstring :=
                v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 '
                || a.unit_name || '\fs24 \cell ' || a.personnel_name || '\fs24 \cell  '
                || a.assign_role || '\fs24 \cell \pard';
            v_tempstring :=
                v_tempstring
                || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid13590504 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\cltxlrtb\clftsWidth3\clwWidth1620\clshdrawnil \cellx1620\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4500\clshdrawnil \cellx6120\clvertalt\clbrdrt\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3240\clshdrawnil \cellx9360\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
        end loop;

        v_ok := core_template.replace_tag(v_template, 'ASSIGNED', v_tempstring);
        --- Specialty Support Requested ---
        v_tempstring := null;
        v_recordcounter := 1;

        for a in (select   mc.description as specialty
                      from t_osi_mission_category mc, t_osi_mission m
                     where m.obj = psid and mc.SID = m.mission and m.obj_context = 'I'
                  order by specialty)
        loop
            if mod(v_recordcounter, 2) = 0 then
                v_tempstring :=
                    v_tempstring
                    || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
                v_tempstring :=
                    v_tempstring
                    || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
                v_tempstring :=
                    v_tempstring
                    || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
                v_tempstring :=
                    v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 '
                    || v_lastunitname || '\cell ' || a.specialty
                    || '\cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
                v_tempstring :=
                    v_tempstring
                    || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
                v_tempstring :=
                    v_tempstring
                    || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
                v_tempstring :=
                        v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
                v_lastunitname := null;
            else
                v_lastunitname := a.specialty;
            end if;

            v_recordcounter := v_recordcounter + 1;
        end loop;

        if v_lastunitname is not null then
            v_tempstring :=
                v_tempstring
                || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
            v_tempstring :=
                v_tempstring
                || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
            v_tempstring :=
                v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 '
                || v_lastunitname
                || '\cell \cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
            v_tempstring :=
                v_tempstring
                || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
            v_tempstring :=
                v_tempstring
                || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
            v_tempstring :=
                        v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
        end if;

        v_ok := core_template.replace_tag(v_template, 'SPECIALTY', v_tempstring);
        --- Other AFOSI Units Notified ---
        v_tempstring := null;
        v_lastunitname := null;
        v_recordcounter := 1;

        for a in (select   u.unit_name
                      from t_osi_f_notify_unit nu, v_osi_unit u
                     where file_sid = psid and nu.unit_sid = u.SID
                  order by unit_name)
        loop
            if mod(v_recordcounter, 2) = 0 then
                v_tempstring :=
                    v_tempstring
                    || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
                v_tempstring :=
                    v_tempstring
                    || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
                v_tempstring :=
                    v_tempstring
                    || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
                v_tempstring :=
                    v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 '
                    || v_lastunitname || '\cell ' || a.unit_name
                    || '\cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
                v_tempstring :=
                    v_tempstring
                    || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
                v_tempstring :=
                    v_tempstring
                    || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
                v_tempstring :=
                        v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
                v_lastunitname := null;
            else
                v_lastunitname := a.unit_name;
            end if;

            v_recordcounter := v_recordcounter + 1;
        end loop;

        if v_lastunitname is not null then
            v_tempstring :=
                v_tempstring
                || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring :=
                v_tempstring
                || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
            v_tempstring :=
                v_tempstring
                || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
            v_tempstring :=
                v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 '
                || v_lastunitname
                || '\cell \cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
            v_tempstring :=
                v_tempstring
                || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
            v_tempstring :=
                v_tempstring
                || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
            v_tempstring :=
                        v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
        end if;

        v_ok := core_template.replace_tag(v_template, 'NOTIFY', v_tempstring);
        --- Other Agency Involvement ---
        v_tempstring := null;

        for a in (select   first_name || ' ' || last_name as name, prt.role as involvement_role,
                           r.description as response, pi.response_date, pi.agency_file_num,
                           pi.action_date
                      from t_osi_partic_involvement pi,
                           t_osi_partic_name pn,
                           t_osi_participant_version pv,
                           t_osi_partic_role_type prt,
                           t_osi_reference r
                     where pi.obj = psid
                       and pi.participant_version = pn.participant_version
                       and pv.current_name = pn.SID
                       and pi.involvement_role = prt.SID
                       and prt.usage='OTHER AGENCIES' --prt.role = 'Referred to Other Agency'
                       and pi.response = r.SID(+)
                       and prt.obj_type = core_obj.lookup_objtype('FILE.INV')
                  order by action_date, response_date)
        loop
            --- Action ---
            v_tempstring :=
                v_tempstring || a.involvement_role || ' ' || a.name || ' on '
                || to_char(a.action_date, v_date_fmt) || '.';

            --- Response ---
            if a.response is not null then
                v_tempstring :=
                    v_tempstring || ' ' || a.response || ' on '
                    || to_char(a.response_date, v_date_fmt) || '.';
            end if;

            if a.agency_file_num is not null then
                v_tempstring :=
                         v_tempstring || '  Other agency file number: ' || a.agency_file_num || '.';
            end if;

            v_tempstring := v_tempstring || '\par \par ';
        end loop;

        v_ok := core_template.replace_tag(v_template, 'OTHERAGENCY', v_tempstring);
/*
--Commented out per CHG0003277
        --- Get Notes ---
        v_tempstring := null;
        v_recordcounter := 1;

        for a in (select   note_text
                      from t_osi_note
                     where obj = psid
                        or obj in(select activity_sid
                                    from t_osi_assoc_fle_act
                                   where file_sid = psid)
                        or obj in(select that_file
                                    from v_osi_assoc_fle_fle
                                   where this_file = psid)
                  order by create_on)
        loop
            v_tempstring := v_tempstring || v_recordcounter || '.  ' || a.note_text || '\par\par ';
            v_recordcounter := v_recordcounter + 1;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'NOTES', v_tempstring);
*/
        log_error('<<< Summary_Complaint_Report');
        return v_template;
        core_util.cleanup_temp_clob(v_template);
    exception
        when others then
            log_error('Error: ' || sqlerrm);
            log_error('<<< Summary_Complaint_Report');
            return v_template;
    end summary_complaint_rpt;

    procedure get_basic_info(ppopv in varchar2, presult out varchar2, psaa out varchar2, pper out varchar2, pincludename in boolean := true, pnameonly in boolean := false, pincludemaiden in boolean := true, pincludeaka in boolean := true) is

         v_result   varchar2(4000);
         v_temp     varchar2(2000);
         v_sex      varchar2(100);
         v_dob      date;
         v_pob      varchar2(100);
         v_pp       varchar2(100);
         v_pg       varchar2(100);
         v_ppg      varchar2(400);
         v_saa      varchar2(100);
         v_per      varchar2(20);
         v_pt       varchar2(50);
         v_ssn      varchar2(11);

    begin
         v_result := '';
         log_error('start get_basic_info');

         if pincludename = true then

           --- Get Names ---
           v_result := v_result || osi_participant.get_name(ppopv) || ', ';

           if pincludemaiden = true then
             
             --v_temp := osi_participant.name_set(ppopv,'M');

             v_temp := null;

             if v_temp is not null then

               v_result := v_result || 'NEE: ' || v_temp || ', ';

             end if;

           end if;

           if pincludeaka = true then
           
             --v_temp := osi_participant.name_set(ppopv,'AKA');

             v_temp := null;

             if v_temp is not null then

               v_result := v_result || 'AKA: ' || v_temp || ', ';

             end if;
           end if;

           v_result := rtrim(replace(v_result, '; ', ', '), ', ') || '; ';
           
        end if;

        if pnameonly = false then

          --- Get Sex, Birthdate, Birth State or Country, Pay Grade ---
          select sex_desc, dob, nvl(pa.state_desc, pa.country_desc), 
                 ---sa_pay_plan_desc, sa_pay_grade_desc, sa_affiliation_code,
                 DECODE(pv.SA_PAY_PLAN_CODE, 'GS', 'GS', 'ES', 'ES', NULL, '', SUBSTR(pv.SA_PAY_PLAN_CODE,1,1)),LTRIM(pv.SA_PAY_GRADE_CODE, '0'),NVL(pv.SA_AFFILIATION_CODE,'none'), 
                 pv.participant, pv.obj_type_desc
              into v_sex, v_dob, v_pob, v_pp, v_pg, v_saa, v_per, v_pt
              from v_osi_participant_version pv, v_osi_partic_address pa
             where pv.SID = ppopv 
               and pv.current_version = pa.participant_version(+)
               and pa.type_code(+) = 'BIRTH';

          if v_pt = 'Individual' then

            --- Sex Born:  DOB ---
            v_result := v_result || nvl(v_sex, 'UNK') || ' Born: ' || nvl(to_char(v_dob, v_date_fmt), 'UNK') || '; ';

            --- Place of Birth ---
            v_result := v_result || nvl(v_pob, 'UNK') || '; ';

            --- If Civilian, put in "CIV" keyword, else Paygrade ---
            v_ppg := v_pp || '-' || v_pg;

            if v_ppg = '-' then

              v_ppg := 'Civ';

            end if;

            v_result := v_result || v_ppg || '; ';

            --- SSN ---
            v_ssn := osi_participant.get_number(ppopv, 'SSN');
            v_ssn := substr(v_ssn, 1, 3) || '-' || substr(v_ssn, 4, 2) || '-' || substr(v_ssn, 6, 4);

            if v_ssn = null or length(v_ssn) = 0 or v_ssn = '--' then

              v_ssn := 'UNK';

            end if;

            v_result := v_result || 'SSN: ' || v_ssn || '; ';

          else

            null;

          end if;

        end if;

        presult := v_result;
        psaa := v_saa;
        pper := v_per;
        return;
    exception
        when no_data_found then
            presult := null;
            core_logger.log_it(c_pipe, 'end get_basic_info');
            return;
    end get_basic_info;

    function get_org_info(ppopv in varchar2, preplacenullwithunk in boolean := false) return varchar2 is

         v_result     varchar2(4000) := NULL;
         v_org        varchar2(20);
         v_org_name   varchar2(100);
         v_base       varchar2(100);
         v_base_loc   varchar2(100);
         v_pv_sid     varchar2(20);

    begin
         log_error('--->OSI_INVESTIGATION.Get_Org_Info(' || ppopv || ') - ' || sysdate);

         --- Get Participant SID ---
         v_org := osi_participant.Latest_Org(ppopv);
         
         --- Get Current Version SID ---
         v_pv_sid := osi_participant.get_current_version(v_org);
         
         log_error('OSI_INVESTIGATION.Get_Org_Info - v_org = ' || v_org);

         if v_org is not null then

           select osi_participant.get_name(v_org), pa.city, nvl(pa.state_desc, pa.country_desc) into v_org_name, v_base, v_base_loc
              from t_osi_participant_version pv, v_osi_partic_address pa
             where pv.sid=v_pv_sid and pa.participant_version(+) = pv.SID and pa.is_current(+) = 'Y';    

           if preplacenullwithunk = true then
           
             v_result := nvl(v_org_name, 'UNK') || ', ' || nvl(v_base, 'UNK') || ', ' || nvl(v_base_loc, 'UNK');
           
           else
           
             v_result := v_org_name || ', ' || v_base || ', ' || v_base_loc;
           
           end if;
           
         end if;

         log_error('<---OSI_INVESTIGATION.Get_Org_Info return:  ' || v_result || ' - ' || sysdate);
         return(v_result);
         
    exception
         when no_data_found then
             return(null);
    end get_org_info;

    function getparticipantname(ppersonversionsid in varchar2, pshortname in boolean := true) return varchar2 is
         v_tmp   varchar2(1000) := null;
    begin
         log_error('--->GetParticipantName(' || ppersonversionsid || ')-' || sysdate);
         
         if pshortname = true then

           log_error('GetParticipantName-True');
         
         else
           
           log_error('GetParticipantName-False');
         
         end if;

         if pshortname = true then

           for s in (select short from t_osi_reports_partic_used where person_version = ppersonversionsid order by rowid)
           loop
               v_tmp := s.short;

           end loop;

           if v_tmp is null then

             v_tmp := '';

           end if;

         else

           for s in (select osi_participant.get_name(pv.SID) as pname, 
                            pv.sa_rank as rank,
                            decode(pv.sa_pay_plan_code, 'GS', 'GS', 'ES', 'ES', null, '', substr(pv.sa_pay_plan_code, 1, 1)) || '-' || ltrim(pv.sa_pay_grade_code, '0') as grade,
                            pv.sa_affiliation_code as saa, 
                            pv.ind_title as title, 
                            pv.SID as pvsid
                       from v_osi_participant_version pv
                      where pv.SID = ppersonversionsid)
           loop
               if s.saa = 'ME' then                                 

                 --- military (or employee) ---
                 v_tmp := v_tmp || s.pname || ', ' || nvl(s.title, nvl(s.rank, 'UNK') || ', ' || nvl(s.grade, 'UNK')) || ', ' || nvl(get_org_info(s.pvsid, true), 'UNK');

               else                                         

                 --- civilian or military dependent  ---
                 v_tmp := v_tmp || s.pname || ', ' || nvl(osi_participant.get_address_data(s.pvsid, 'CURRENT', 'DISPLAY'), 'UNK');
 
               end if;
 
           end loop;

         end if;

         log_error('<---GetParticipantName return: ' || v_tmp || ' - ' || sysdate);
         return v_tmp;

    end getparticipantname;

    function getsubjectofactivity(pshortname in boolean := false)
        return varchar2 is
        vtmp   varchar2(10000) := null;
    begin
        vtmp := null;

        for s in (select pv.SID
                    from t_osi_partic_involvement pi,
                         t_osi_participant_version pv,
                         t_osi_partic_role_type prt
                   where pi.involvement_role = prt.SID
                     and prt.usage = 'SUBJECT'
                     and prt.role = 'Subject of Activity'
                     and pv.SID = pi.participant_version
                     and pi.obj = v_act_sid)
        loop
            vtmp := getparticipantname(s.SID, pshortname);
        end loop;

        return rtrim(vtmp, ', ');
    exception
        when others then
            raise;
            return '<<GetSubjectOfActivity>>';
    end getsubjectofactivity;

    procedure load_activity(psid in varchar2) is
/*
    Loads information about the specified activity (and it's type)
    into package variables.
*/
        lead_prefix   varchar2(100) := null;
    begin
        select a.SID, a.title, cot.description, a.activity_date, a.complete_date, a.narrative,
               cot.SID, cot.code
          into v_act_sid, v_act_title, v_act_desc, v_act_date, v_act_complt_date, v_act_narrative,
               v_obj_type_sid, v_obj_type_code
          from t_osi_activity a, t_core_obj o, t_core_obj_type cot
         where a.SID = psid and a.SID = o.SID and o.obj_type = cot.SID;

        lead_prefix := core_util.get_config('OSI.LEAD_PREFIX');

        if substr(v_act_title, 1, length(lead_prefix)) = lead_prefix then
            v_act_title :=
                substr(v_act_title,
                       length(lead_prefix) + 1,
                       length(v_act_title) - length(lead_prefix));
        end if;

        --- Get the Activity's Masking Value ---
        begin
            select mt.mask
              into v_mask
              from t_osi_obj_mask m, t_osi_obj_mask_type mt
             where m.obj = psid and m.mask_type = mt.SID;
        exception
            when others then
                v_mask := null;
        end;

        if upper(v_mask) = 'NONE' then
            v_mask := null;
        end if;
    end load_activity;

    function get_f40_place(p_obj in varchar2)
        return varchar2 is
        v_return           varchar2(1000) := null;
        v_create_by_unit   varchar2(20);
        v_name             varchar2(100);
        v_obj_type_code    varchar2(200);
    begin
        --Note: This was originally added here for the Consultation/Coordination activity
        --If you need to add other activities, this will need to be modified.
        select creating_unit
          into v_create_by_unit
          from t_osi_activity
         where SID = p_obj;

        --Get object type code
        v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

        if v_obj_type_code like 'ACT.INTERVIEW%' then                               -- interviews --
            log_error('f40 place for interviews');
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        elsif v_obj_type_code like 'ACT.BRIEFING%' then                              -- briefings --
            select location
              into v_return
              from t_osi_a_briefing
             where SID = p_obj;
        elsif v_obj_type_code like 'ACT.SOURCE%' then                             -- source meets --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        elsif v_obj_type_code like 'ACT.SEARCH%' then                                 -- searches --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        elsif v_obj_type_code like 'ACT.POLY%' then                                 -- polygraphs --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
--                select location
--                  into v_return
--                  from t_act_poly_exam
--                 where sid = psid;
        elsif v_obj_type_code like 'ACT.SURV%' then                                 -- polygraphs --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        else
            --This is the displayed text for all other types
            v_name := osi_unit.get_name(osi_object.get_assigned_unit(p_obj));
            v_return :=
                v_name || ', '
                || osi_address.get_addr_display
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj)));
        end if;

        v_return := replace(v_return, chr(13) || chr(10), ' ');                            -- CRLF's
        v_return := replace(v_return, chr(10), ' ');                                         -- LF's
        v_return := rtrim(v_return, ', ');
        return v_return;
    exception
        when no_data_found then
            raise;
            return null;
    end get_f40_place;

    function get_f40_date(psid in varchar2)
        return date is
    begin
        load_activity(psid);
        return nvl(v_act_date, v_act_complt_date);
    exception
        when no_data_found then
            return null;
    end get_f40_date;

    function roi_toc_interview
        return varchar2 is
        vtmp   varchar2(3000);
    begin
        log_error('>>>ROI_TOC_Interview-' || v_act_sid);
        vtmp := getsubjectofactivity(true);

        if v_mask is not null then
            vtmp := v_mask;
        end if;

        log_error('<<<ROI_TOC_Interview-' || v_act_sid);
        return vtmp;
    exception
        when others then
            return '<<Error during ROI_TOC_Interview>> - ' || sqlerrm;
    end roi_toc_interview;

    function roi_toc_docreview
        return varchar2 is
        v_doc_type      varchar2(1000);
        v_explanation   varchar2(1000);
        v_participant   varchar2(1000);
    begin
        log_error('>>>ROI_TOC_DocReview-' || v_act_sid);

        select r.description, dr.explanation
          into v_doc_type, v_explanation
          from t_osi_a_document_review dr, t_osi_reference r
         where dr.SID = v_act_sid and dr.doc_type = r.SID;

        v_participant := getsubjectofactivity(true);

        if v_doc_type = 'Other' then
            if v_explanation is not null then
                v_doc_type := v_explanation;
            end if;
        end if;

        if    v_participant is null
           or v_participant = '' then
            v_doc_type := v_doc_type || v_newline;
        else
            v_doc_type := v_doc_type || ', ' || v_participant || v_newline;
        end if;

        log_error('<<<ROI_TOC_DocReview-' || v_act_sid);
        return v_doc_type;
    exception
        when no_data_found then
            return v_act_title;
        when others then
            return '<<Error during ROI_TOC_DocReview>> - ' || sqlerrm;
    end roi_toc_docreview;

    function roi_toc_consultation
        return varchar2 is
        vtmp   varchar2(1000);
    begin
        log_error('>>>ROI_TOC_Consultation-' || v_act_sid);
        vtmp :=
               ltrim(rtrim(replace(replace(v_act_desc, 'Coordination,', ''), 'Consultation,', '')));

        if vtmp = 'Other' then
            vtmp := v_act_title;
        end if;

        log_error('<<<ROI_TOC_Consultation-' || v_act_sid);
        return vtmp;
    exception
        when others then
            return '<<Error during ROI_TOC_Consultation>> - ' || sqlerrm;
    end roi_toc_consultation;

    function roi_toc_sourcemeet
        return varchar2 is
        v_meet_date   t_osi_a_source_meet.next_meet_date%type;
    begin
        log_error('>>>ROI_TOC_SourceMeet-' || v_act_sid);
        v_meet_date := get_f40_date(v_act_sid);
        log_error('<<<ROI_TOC_SourceMeet-' || v_act_sid);
        return 'CS Information';
    exception
        when no_data_found then
            return 'CS Information; Date not determined';
        when others then
            return '<<Error during ROI_TOC_SourceMeet>> - ' || sqlerrm;
    end roi_toc_sourcemeet;

    function roi_toc_search
        return varchar2 is
        vtmp           varchar2(3000);
        vexplanation   varchar2(200);
    begin
        log_error('>>>ROI_TOC_Search-' || v_act_sid);

        --- Search of Person ---
        if v_act_desc = 'Search of Person' then
            vtmp := 'Person ' || getsubjectofactivity(true);
        --- Search of Place/Property '30', '40' ---
        else
            select decode(explanation, null, '*Not Specified*', '', '*Not Specified*', explanation)
              into vexplanation
              from t_osi_a_search
             where SID = v_act_sid;

            if v_act_desc = 'Search of Place' then
                vtmp := 'Place ' || vexplanation;
            elsif v_act_desc = 'Search of Property' then
                vtmp := 'Property ' || vexplanation;
            end if;
        end if;

        log_error('<<<ROI_TOC_Search-' || v_act_sid);
        return vtmp;
    exception
        when others then
            return '<<Error during ROI_TOC_Search>> - ' || sqlerrm;
    end roi_toc_search;

    function roi_toc(psid in varchar2)
        return varchar2 is
/*
    Returns the TOC (Table of Contents) string for the specified activity.
*/
    begin
        load_activity(psid);

        if v_mask is not null then
            return roi_toc_interview;
        else
            if v_act_desc = 'Group Interview' then
                return 'Group Interview';
            elsif v_act_desc like 'Interview%' then
                return roi_toc_interview;
            elsif v_act_desc like 'Document Review' then
                return roi_toc_docreview;
            elsif    v_act_desc like 'Consultation%'
                  or v_act_desc like 'Coordination%' then
                return roi_toc_consultation;
            elsif v_act_desc like 'Source Meet' then
                return roi_toc_sourcemeet;
            elsif v_act_desc like 'Search%' then
                return roi_toc_search;
            elsif v_act_desc = 'Law Enforcement Records Check' then
                return roi_toc_docreview;
            elsif v_act_desc = 'Exception' then
                return v_act_title;
            else
                return v_act_desc;
            end if;
        end if;
    exception
        when no_data_found then
            return null;
    end roi_toc;

    function roi_header_interview(preturntable in varchar2 := 'N')
        return clob is
        v_tmp   clob := null;
    begin
        log_error('>>>ROI_Header_Interview-' || v_act_sid);

        if v_act_desc = 'Interview, Witness' then
            if v_mask is not null then
                v_tmp := v_tmp || v_mask;
            else
                --- Witness Interview ---
                v_tmp := v_tmp || getsubjectofactivity;
            end if;
        else
            --- Subject/Victim Interviews ---
            v_tmp := roi_toc_interview;
        end if;

        if preturntable = 'Y' then
            v_tmp := v_tmp || '\pard\par ';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Place:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt) || '/'
                || get_f40_place(v_act_sid)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_newline;
            v_tmp :=
                v_tmp || 'Date/Place: ' || to_char(v_act_date, v_date_fmt) || '/'
                || get_f40_place(v_act_sid) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        log_error('<<<ROI_Header_Interview-' || v_act_sid);
        return v_tmp;
    exception
        when no_data_found then
            return '<<Error during ROI_Header_Interview>> - ' || sqlerrm;
    end roi_header_interview;

-- Incidental/Group Interview --
    function roi_header_incidental_int(preturntable in varchar2 := 'N')
        return clob is
        v_tmp                clob          := null;
        vcount               number;
        vdatestring          varchar2(100);
        vmindate             date;
        vmaxdate             date;
        vprinteachdate       boolean;
        vlastaddr1           varchar2(100);
        vlastaddr2           varchar2(100);
        vlastcity            varchar2(30);
        vlaststate           varchar2(10);
        vlastprovince        varchar2(30);
        vlastzip             varchar2(30);
        vlastcountry         varchar2(100);
        vaddressstring       varchar2(500);
        vmultiplelocations   varchar2(20);
    begin
        log_error('>>>ROI_Header_Incidental_Int-' || v_act_sid);

        begin
            select min(t_g.interview_date), max(t_g.interview_date)
              into vmindate, vmaxdate
              from t_osi_a_gi_involvement t_g
             where t_g.gi = v_act_sid;

            if vmindate = vmaxdate then
                vdatestring := to_char(vmindate, v_date_fmt);
                vprinteachdate := false;
            else
                vdatestring :=
                             to_char(vmindate, v_date_fmt) || ' - '
                             || to_char(vmaxdate, v_date_fmt);
                vprinteachdate := true;
            end if;
        exception
            when others then
                vdatestring := to_char(get_f40_date(v_act_sid), v_date_fmt);
        end;

        vcount := 1;

        for a in (select a.address_1, a.address_2, a.city, a.province, s.code as state,
                         a.postal_code, c.description as country
                    from t_osi_address a,
                         t_osi_partic_address pa,
                         t_osi_addr_type t,
                         t_dibrs_country c,
                         t_dibrs_state s
                   where (pa.participant_version in(select participant_version
                                                      from t_osi_a_gi_involvement
                                                     where gi = v_act_sid))
                     and a.SID = pa.address(+)
                     and a.address_type = t.SID
                     and a.state = s.SID(+)
                     and a.country = c.SID(+))
        loop
            vaddressstring := '';

            if vcount = 1 then
                vlastaddr1 := a.address_1;
                vlastaddr2 := a.address_2;
                vlastcity := a.city;
                vlaststate := a.state;
                vlastprovince := a.province;
                vlastzip := a.postal_code;
                vlastcountry := a.country;
            else
                log_error(vcount || ':  ' || vlastaddr1 || '--' || a.address_1);

                if vlastaddr1 <> a.address_1 and vlastaddr1 <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastaddr1 := '~~DU~~';
                end if;

                log_error(vlastaddr2 || '--' || a.address_2);

                if vlastaddr2 <> a.address_2 and vlastaddr2 <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastaddr2 := '~~DU~~';
                end if;

                log_error(vlastcity || '--' || a.city);

                if vlastcity <> a.city and vlastcity <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastcity := '~~DU~~';
                end if;

                log_error(vlaststate || '--' || a.state);

                if vlaststate <> a.state and vlaststate <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlaststate := '~~DU~~';
                end if;

                log_error(vlastprovince || '--' || a.province);

                if vlastprovince <> a.province and vlastprovince <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastprovince := '~~DU~~';
                end if;

                log_error(vlastzip || '--' || a.postal_code);

                if vlastzip <> a.postal_code and vlastzip <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastzip := '~~DU~~';
                end if;

                log_error(vlastcountry || '--' || a.country);

                if vlastcountry <> a.country and vlastcountry <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastcountry := '~~DU~~';
                end if;
            end if;

            vcount := vcount + 1;
        end loop;

        vaddressstring := vmultiplelocations;

        if vlastaddr1 <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastaddr1 || ', ';
        end if;

        if vlastaddr2 <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastaddr2 || ', ';
        end if;

        if vlastcity <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastcity || ', ';
        end if;

        if vlaststate <> '~~DU~~' then
            vaddressstring := vaddressstring || vlaststate || ', ';
        end if;

        if vlastprovince <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastprovince || ', ';
        end if;

        if vlastzip <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastzip || ', ';
        end if;

        if vlastcountry <> '~~DU~~' then
            if vlastcountry <> 'United States of America' then
                vaddressstring := vaddressstring || vlastcountry;
            end if;
        end if;

        vaddressstring := rtrim(vaddressstring, ', ');

        if    vaddressstring = ''
           or vaddressstring is null then
            vaddressstring := '**Not Specified**';
            vaddressstring := osi_address.get_addr_display(osi_address.get_address_sid(v_act_sid));
        /* for a in (select   display_string_line
                      from v_address_v2
                     where parent = v_act_sid
                  order by selected asc)
        loop
            vaddressstring := a.display_string_line;
        end loop; */
        end if;

        v_tmp := roi_toc(v_act_sid);

        if preturntable = 'Y' then
            v_tmp :=
                v_tmp
                || '\pard\par \trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Place:';
            v_tmp :=
                v_tmp || '\cell ' || vdatestring || '/' || vaddressstring
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Interviewees:';
            v_tmp :=
                v_tmp
                || '\cell \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_newline;
            v_tmp := v_tmp || 'Date/Place: ' || vdatestring || '/' || vaddressstring || v_newline;
            v_tmp :=
                v_tmp || 'Agent(s): '
                || osi_report.get_assignments(v_act_sid, null, v_newline || '\tab  ') || v_newline;
            v_tmp := v_tmp || 'Interviewees: ';
        end if;

        if preturntable = 'N' then
            v_tmp := v_tmp || v_newline;
        end if;

        vcount := 1;

        for s in (select   pv.SID as participant_version,
                           nvl(to_char(gi.interview_date, 'FMDD Mon FMFXYY'),
                               'Not Interviewed') as datetouse
                      from t_osi_activity a,
                           t_osi_a_gi_involvement gi,
                           t_osi_participant_version pv,
                           t_osi_partic_name pn
                     where (a.SID = gi.gi)
                       and (pv.SID = gi.participant_version)
                       and (pn.SID = pv.current_name)
                       and a.SID = v_act_sid
                  order by gi.interview_date, pn.last_name)
        loop
            if preturntable = 'Y' then
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \qr '
                    || vcount || '.';
                v_tmp := v_tmp || '\cell \ql ' || getparticipantname(s.participant_version, false);

                if vprinteachdate = true then
                    v_tmp := v_tmp || ',    ' || s.datetouse;
                end if;

                v_tmp :=
                    v_tmp
                    || '\cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            else
                if vcount > 1 then
                    v_tmp := v_tmp || v_newline;
                end if;

                v_tmp :=
                    v_tmp || '\tab        ' || vcount || '.  '
                    || getparticipantname(s.participant_version, false);

                if vprinteachdate = true then
                    v_tmp := v_tmp || ',    ' || s.datetouse;
                end if;
            end if;

            vcount := vcount + 1;
        end loop;

        log_error('<<<ROI_Header_Incidental_Int-' || v_act_sid);
        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_Incidental_int>> - ' || sqlerrm;
    end roi_header_incidental_int;

    function roi_header_docreview(preturntable in varchar2 := 'N')
        return clob is
        v_tmp   clob;
    begin
        v_tmp := roi_toc_docreview;

        if preturntable = 'Y' then
            v_tmp := rtrim(v_tmp, v_newline);
            v_tmp := v_tmp || '\pard\par';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || 'Date: ' || to_char(v_act_date, v_date_fmt) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_DocReview>> - ' || sqlerrm;
    end roi_header_docreview;

    function roi_header_consultation(preturntable in varchar2 := 'N')
        return clob is
        v_tmp              clob          := null;
        v_consult_method   varchar(1000);
    begin
        log_error('>>>ROI_Header_Consultation-' || v_act_sid);

        if preturntable = 'Y' then
            v_tmp := roi_toc_consultation || '\pard\par';
        else
            v_tmp := roi_toc_consultation || v_newline;
        end if;

        begin
            select nvl(description, 'UNK')
              into v_consult_method
              from t_osi_a_consult_coord c, t_osi_reference r
             where c.cc_method = r.SID and c.SID = v_act_sid;
        exception
            when no_data_found then
                v_consult_method := 'UNK';
        end;

        if preturntable = 'Y' then
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Method:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt) || '/' || v_consult_method
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp :=
                v_tmp || 'Date/Method: ' || to_char(v_act_date, v_date_fmt) || '/'
                || v_consult_method || v_newline;
        end if;

        if v_act_desc = 'Consultation' then
            if preturntable = 'Y' then
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Specialist(s):';
                v_tmp :=
                    v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                    || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            else
                v_tmp :=
                    v_tmp || 'Specialist(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
            end if;
        else
            if preturntable = 'Y' then
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
                v_tmp :=
                    v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                    || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            else
                v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
            end if;
        end if;

        log_error('<<<ROI_Header_Consultation-' || v_act_sid);
        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_Consultation>> - ' || sqlerrm;
    end roi_header_consultation;

    function roi_header_sourcemeet(preturntable in varchar2 := 'N')
        return clob is
        v_meet_date   t_osi_a_source_meet.next_meet_date%type;
        v_tmp         clob;
    begin
        log_error('>>>ROI_Header_SourceMeet-' || v_act_sid);

        if preturntable = 'Y' then
            v_tmp := v_tmp || v_act_title || ' \pard\par ';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_act_title || v_newline;
            v_tmp := v_tmp || 'Date: ' || to_char(v_act_date, v_date_fmt) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        log_error('<<<ROI_Header_SourceMeet-' || v_act_sid);
        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_SourceMeet>> - ' || sqlerrm;
    end roi_header_sourcemeet;

    function roi_header_search(preturntable in varchar2 := 'N')
        return clob is
        v_tmp          clob                     := null;
        v_act_search   t_osi_a_search%rowtype;
    begin
        log_error('>>>ROI_Header_Search-' || v_act_sid);
        v_tmp := roi_toc_search || v_newline;

        if preturntable = 'Y' then
            v_tmp := roi_toc_search || ' \pard\par ';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Place:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt) || '/'
                || osi_address.get_addr_display(osi_address.get_address_sid(v_act_sid))
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp :=
                v_tmp || 'Date/Place: ' || to_char(v_act_date, v_date_fmt) || '/'
                || osi_address.get_addr_display(osi_address.get_address_sid(v_act_sid))
                || v_newline;
            v_tmp := v_tmp || 'Agents(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_Search>> - ' || sqlerrm;
    end roi_header_search;

    function roi_header_default(preturntable in varchar2 := 'N')
        return clob is
        v_tmp   clob := null;
    begin
        log_error('>>>ROI_Header_DEFAULT-' || v_act_sid);

        if preturntable = 'Y' then
            v_tmp := v_tmp || v_act_desc;
            v_tmp :=
                v_tmp
                || '\pard\par \trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_act_desc || v_newline;
            v_tmp := v_tmp || 'Date: ' || to_char(v_act_date, v_date_fmt) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        log_error('<<<ROI_Header_DEFAULT-' || v_act_sid);
        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_Default>> - ' || sqlerrm;
    end roi_header_default;

    function roi_group(psid in varchar2)
        return varchar2 is
/*
    Returns the TOC (Table of Contents) Group string for the specified activity.
*/
        v_tempstring      varchar2(300)               := null;
        v_obj_type_code   t_core_obj_type.code%type;
    begin
        load_activity(psid);
        v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(psid));

        if (   (v_obj_type_code like 'ACT.INTERVIEW%' and v_obj_type_code <> 'ACT.INTERVIEW.GROUP')
            or v_mask is not null) then
            if v_mask = 'Investigative Activity' then
                return 'Other Investigative Aspects';
            else
                return 'Interviews';
            end if;
        elsif v_act_desc = 'Document Review' then
            return 'Document Reviews';
        elsif v_act_desc like 'Coordination%' then
            return 'Coordinations';
        elsif v_act_desc like 'Consultation%' then
            return 'Consultations';
        elsif v_act_desc like 'Search%' then
            return 'Searches';
        elsif v_act_desc = 'Law Enforcement Records Check' then
            return 'Law Enforcement Records Checks';
        elsif v_act_desc like 'Agent Application Activity%' then
            begin
                select t.description
                  into v_tempstring
                  from t_osi_f_aapp_file_obj_act a,
                       t_osi_f_aapp_file_obj o,
                       t_osi_f_aapp_file_obj_type t
                 where a.obj = psid and a.objective = o.SID and o.obj_type = t.SID;
            exception
                when no_data_found then
                    return '#-# Objective Title';
            end;

            return v_tempstring;
        else
            return 'Other Investigative Aspects';
        end if;
    exception
        when no_data_found then
            return null;
    end roi_group;

    function roi_group_order(psid in varchar2) return varchar2 is
/*
    Returns a string used to sort the TOC Groups.
*/
    begin
         load_activity(psid);
         
         --- Maskings show up as Other Investigative Aspects ---
         if v_mask is not null then
           
           return 'Z';
           
         end if;
         
         case
         
             --- Interviews ---
             when v_obj_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.WITNESS','ACT.INTERVIEW.VICTIM') THEN
                 
                 return 'A';
             
             --- Searches ---
             when v_obj_type_code like 'ACT.SEARCH%' THEN
                 
                 return 'B';
             
             --- Document Reviews ---    
             when v_obj_type_code in ('ACT.DOCUMENT_REVIEW') THEN
                 
                 return 'D';
             
             --- Records Checks ---
             when v_obj_type_code in ('ACT.RECORDS_CHECK') THEN
                 
                 return 'E';
             
             --- Coordinations ---    
             when v_obj_type_code like 'ACT.COORDINATION%' THEN
                 
                 return 'G';
             
             --- Consultations ---    
             when v_obj_type_code like 'ACT.CONSULTATION%' THEN
                  
                 return 'H';
             
             -- Other Investigative Aspects --
             else
               
               return 'Z';
               
         end case; 

    exception
        when no_data_found then
            return null;
    end roi_group_order;

    function roi_toc_order(psid in varchar2)
        return varchar2 is
/*
    Returns a string that can be used to sort activities within
    an ROI Group.
*/
    begin
        return nvl(to_char(get_f40_date(psid), 'yyyymmddhh24miss'), 'z-none');
    exception
        when no_data_found then
            return null;
    end roi_toc_order;

    function roi_narrative(psid in varchar2)
        return clob is
/*
    Returns the Narrative (text) for the specified activity.
*/
    begin
        load_activity(psid);
        return osi_report.replace_special_chars_clob(v_act_narrative, 'RTF');
    exception
        when no_data_found then
            return null;
    end roi_narrative;

    function roi_header(psid in varchar2, preturntable in varchar2 := 'N')
        return clob is
        /*Returns the Narrative header for the specified activity. */
        v_tmp   clob;
    begin
        load_activity(psid);

        if v_mask is not null then
            v_tmp := roi_header_interview(preturntable);
        else
            if v_act_desc = 'Group Interview' then
                v_tmp := roi_header_incidental_int(preturntable);
            elsif v_act_desc like 'Interview%' then
                v_tmp := roi_header_interview(preturntable);
            elsif v_act_desc like 'Document Review' then
                v_tmp := roi_header_docreview(preturntable);
            elsif    v_act_desc like 'Consultation%'
                  or v_act_desc like 'Coordination%' then
                v_tmp := roi_header_consultation(preturntable);
            elsif v_act_desc like 'Source Meet' then
                v_tmp := roi_header_sourcemeet(preturntable);
            elsif v_act_desc like 'Search%' then
                v_tmp := roi_header_search(preturntable);
            elsif v_act_desc = 'Law Enforcement Records Check' then
                v_tmp := roi_header_docreview(preturntable);
            elsif v_act_desc = 'Exception' then
                --- Exception Activities ---
                return v_act_title;
            else
                v_tmp := roi_header_default(preturntable);
            end if;
        end if;

        return v_tmp;                                           --|| getotherspresent(preturntable);
    exception
        when no_data_found then
            return null;
    end roi_header;

    function case_roi(psid in varchar2)
        return clob is
        v_ok                    varchar2(1000);
        v_template              clob                                    := null;
        v_template_date         date;
        v_mime_type             t_core_template.mime_type%type;
        v_mime_disp             t_core_template.mime_disposition%type;
        v_full_id               varchar2(100)                           := null;
        v_file_id               varchar2(100)                           := null;
        v_file_offense          clob                                    := null;
        v_summary               clob                                    := null;
        v_offense_header        clob                                    := null;
        v_offense_desc_prefix   varchar2(100);
        v_report_by             varchar2(500);
        v_commander             varchar2(600);
        v_class                 varchar2(100);
        pragma autonomous_transaction;
    begin
        log_error('Case_ROI<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
             core_template.get_latest('ROI', v_template, v_template_date, v_mime_type, v_mime_disp);
        /* ----------------- Cover Page ------------------ */
        log_error('Starting Cover Page');

        for a in (select s.SID, obj,
                         to_char(start_date, v_date_fmt) || ' - '
                         || to_char(end_date, v_date_fmt) as report_period
                    from t_osi_report_spec s, t_osi_report_type rt
                   where obj = v_obj_sid and s.report_type = rt.SID and rt.description = 'ROI')
        loop
            v_spec_sid := a.SID;

            begin
                select 'SA ' || first_name || ' '
                       || decode(length(middle_name),
                                 1, middle_name || '. ',
                                 0, '',
                                 null, '',
                                 substr(middle_name, 1, 1) || '. ')
                       || last_name
                  into v_report_by
                  from t_core_personnel
                 where SID = core_context.personnel_sid;
            exception
                when no_data_found then
                    v_report_by := core_context.personnel_name;
            end;

            v_ok := core_template.replace_tag(v_template, 'REPORT_BY', v_report_by);
            v_ok := core_template.replace_tag(v_template, 'REPORT_PERIOD', a.report_period);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'RPT_DATE',
                                          to_char(sysdate, v_date_fmt),
                                          'TOKEN@',
                                          true);
        end loop;

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, 'RTF'),
                                      'TOKEN@',
                                      true);
                                      
        osi_report.load_participants(v_obj_sid);
        osi_report.load_agents_assigned(v_obj_sid);             --load_agents_assigned(v_parent_sid)

        for b in (select i.summary_investigation, f.id, f.full_id,
                         ot.description || ', ' || ot.code as file_offense
                    from t_osi_f_investigation i,
                         t_osi_file f,
                         t_osi_f_inv_offense io,
                         t_dibrs_offense_type ot,
                         t_osi_reference r
                   where i.SID = psid
                     and i.SID(+) = f.SID
                     and io.investigation = i.SID
                     and io.offense = ot.SID
                     and io.priority = r.SID
                     and r.code = 'P'
                     and r.usage = 'OFFENSE_PRIORITY')
        loop
            v_full_id := b.full_id;
            v_file_id := b.id;
            v_file_offense := b.file_offense;
            v_summary := b.summary_investigation;
        end loop;

---------------------------------------------------------------------------------------------------------------------------------
---- MAKE SURE that clcbpat## doesn't change from \red160\green160\blue160;  this corresponds to the ## entry in \colortbl; -----
---------------------------------------------------------------------------------------------------------------------------------
        v_offense_header :=
            '}\trowd \irow0\irowband0\ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_offense_header :=
            v_offense_header
            || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
        v_offense_header :=
            v_offense_header
            || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat18\cltxlrtb\clftsWidth1\clcbpatraw18 \cellx4536\pard\plain \qc \li0\ri0\widctlpar\intbl\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid3480925\yts18';
        v_offense_header :=
            v_offense_header
            || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\b\insrsid3480925 MATTERS INVESTIGATED}{\insrsid3480925 \cell }\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0';
        v_offense_header :=
            v_offense_header
            || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\insrsid3480925 \trowd \irow0\irowband0\ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv';
        v_offense_header :=
            v_offense_header
            || '\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10';
        v_offense_header :=
            v_offense_header
            || '\clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat18\cltxlrtb\clftsWidth1\clcbpatraw18 \cellx4536\row }\trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr';
        v_offense_header :=
            v_offense_header
            || '\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt';
-- v_Offense_Header := v_Offense_Header || '\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx970\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
        v_offense_header :=
            v_offense_header
            || '\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx1000\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
        v_offense_header :=
            v_offense_header
            || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
        v_offense_header :=
            v_offense_header
            || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\pard\plain \ql \li0\ri0\widctlpar\intbl\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid11035800\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
        v_offense_header :=
            v_offense_header
            || '\b\insrsid3480925 INCIDENT}{\insrsid3480925 \cell }{\b\insrsid3480925 OFFENSE DESCRIPTION}{\insrsid3480925 \cell }{\b\insrsid3480925 SUBJECT}{\insrsid3480925 \cell }{\b\insrsid3480925 VICTIM}{\insrsid3480925 \cell }\pard\plain';
        v_offense_header :=
            v_offense_header
            || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\insrsid3480925 \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10';
        v_offense_header :=
            v_offense_header
            || '\trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_offense_header :=
            v_offense_header
            || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
        v_offense_header :=
            v_offense_header
            || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx970\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt';
        v_offense_header :=
            v_offense_header
            || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
        v_offense_header :=
            v_offense_header
            || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\row }\pard \ql \fi-1440\li1440\ri0\widctlpar\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin1440\itap0 {\insrsid11035800 ';
        v_offense_header :=
            v_offense_header
            || '}\pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 {\b\insrsid16598193 ';
        v_file_offense := null;

        for c in (select r1.code as off_result, r2.code as off_involvement,
                         i.incident_id as incident, ot.description as offense_desc,
                         pn1.first_name || ' '
                         || decode(length(pn1.middle_name),
                                   1, pn1.middle_name || '. ',
                                   0, ' ',
                                   null, ' ',
                                   substr(pn1.middle_name, 1, 1) || '. ')
                         || pn1.last_name as subject_name,
                         pn2.first_name || ' '
                         || decode(length(pn2.middle_name),
                                   1, pn2.middle_name || '. ',
                                   0, ' ',
                                   null, ' ',
                                   substr(pn2.middle_name, 1, 1) || '. ')
                         || pn2.last_name as victim_name
                    from t_osi_f_inv_spec s,
                         t_dibrs_reference r1,
                         t_dibrs_reference r2,
                         t_osi_f_inv_incident i,
                         t_osi_participant_version pv1,
                         t_osi_participant_version pv2,
                         t_osi_partic_name pn1,
                         t_osi_partic_name pn2,
                         t_dibrs_offense_type ot
                   where s.investigation = v_obj_sid
                     and s.off_result = r1.SID(+)
                     and s.off_involvement = r2.SID(+)
                     and s.incident = i.SID
                     and s.subject = pv1.SID
                     and s.victim = pv2.SID
                     and pv1.current_name = pn1.SID
                     and pv2.current_name = pn2.SID
                     and s.offense = ot.SID)
        loop
            v_offense_desc_prefix := null;

            if c.off_result = 'A' then
                v_offense_desc_prefix := v_offense_desc_prefix || 'Attempted - ';
            end if;

            if c.off_involvement = 'A' then
                v_offense_desc_prefix := v_offense_desc_prefix || 'Accessory - ';
            end if;

            if c.off_involvement = 'C' then
                v_offense_desc_prefix := v_offense_desc_prefix || 'Conspiracy - ';
            end if;

            if c.off_involvement = 'S' then
                v_offense_desc_prefix := v_offense_desc_prefix || 'Solicit - ';
            end if;

            v_file_offense :=
                v_file_offense
                || '\trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr';
            v_file_offense :=
                v_file_offense
                || '\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt';
            v_file_offense :=
                v_file_offense
                || '\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx970\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_file_offense :=
                v_file_offense
                || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
            v_file_offense :=
                v_file_offense
                || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\pard\plain \ql \li0\ri0\widctlpar\intbl\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid11035800\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
            v_file_offense :=
                v_file_offense || '\insrsid3480925 ' || c.incident
                || '}{\insrsid3480925 \cell }{\insrsid3480925 ' || v_offense_desc_prefix
                || c.offense_desc || '}{\insrsid3480925 \cell }{\insrsid3480925 ' || c.subject_name
                || '}{\insrsid3480925 \cell }{\insrsid3480925 ' || c.victim_name
                || '}{\insrsid3480925 \cell }\pard\plain';
            v_file_offense :=
                v_file_offense
                || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\insrsid3480925 \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10';
            v_file_offense :=
                v_file_offense
                || '\trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
            v_file_offense :=
                v_file_offense
                || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
            v_file_offense :=
                v_file_offense
                || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx970\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt';
            v_file_offense :=
                v_file_offense
                || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_file_offense := v_file_offense || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\row }';
        end loop;

        v_file_offense := v_file_offense || '\pard ';
        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        -- multiple instances
        v_ok := core_template.replace_tag(v_template, 'FILE_NO', v_full_id, 'TOKEN@', true);
        -- multiple instances
        v_ok :=
            core_template.replace_tag(v_template, 'FILE_OFFENSE',
                                      v_offense_header || v_file_offense);
        v_ok := core_template.replace_tag(v_template, 'SUMMARY', v_summary);
        v_ok := core_template.replace_tag(v_template, 'SUBJECT_LIST', get_subject_list);
        v_ok := core_template.replace_tag(v_template, 'VICTIMS_LIST', get_victim_list);
        v_exhibit_cnt := 0;
        v_exhibit_covers := null;

        for c in (select unit, unit_name
                    from v_osi_obj_assignments oa, t_osi_unit_name un
                   where obj = v_obj_sid and un.unit = oa.current_unit and un.end_date is null)
        loop
            v_unit_sid := c.unit;
            v_ok := core_template.replace_tag(v_template, 'UNIT_NAME', c.unit_name, 'TOKEN@', true);
        -- multiple instances
        end loop;

        v_commander := get_owning_unit_cdr;
        v_ok := core_template.replace_tag(v_template, 'UNIT_CDR', v_commander);

        if instr(v_commander, ', USAF') > 0 then
            v_ok := core_template.replace_tag(v_template, 'DESIGNATION', 'Commander');
        else
            v_ok := core_template.replace_tag(v_template, 'DESIGNATION', 'Special Agent in Charge');
        end if;

        v_ok := core_template.replace_tag(v_template, 'CAVEAT_LIST', get_caveats_list);
        get_sel_activity(v_spec_sid);
        v_ok := core_template.replace_tag(v_template, 'ACTIVITY_TOC', v_act_toc_list);
        core_util.cleanup_temp_clob(v_act_toc_list);
        v_ok := core_template.replace_tag(v_template, 'NARRATIVE_LIST', v_act_narr_list);
        core_util.cleanup_temp_clob(v_act_narr_list);
        v_ok := core_template.replace_tag(v_template, 'EXHIBITS_LIST', v_exhibits_list);
        core_util.cleanup_temp_clob(v_exhibits_list);

        if    v_exhibit_covers is null
           or v_exhibit_covers = '' then
            v_ok := core_template.replace_tag(v_template, 'EXHIBIT_COVERS', 'Exhibits');
        else
            v_ok :=
                core_template.replace_tag(v_template,
                                          'EXHIBIT_COVERS',
                                          replace(v_exhibit_covers, '[TOKEN@FILE_ID]', v_full_id));
        end if;

        get_evidence_list(v_obj_sid, v_spec_sid);
        v_ok := core_template.replace_tag(v_template, 'EVIDENCE_LIST', v_evidence_list);
        core_util.cleanup_temp_clob(v_evidence_list);
/*
--Commented out per CR#CHG0003277
        get_idp_notes(v_spec_sid, '22');
        v_ok := core_template.replace_tag(v_template, 'IDP_LIST', v_idp_list);
        core_util.cleanup_temp_clob(v_idp_list);
*/
        log_error('Case_ROI - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('Case_ROI - Error -->' || sqlerrm);
            return v_template;
    end case_roi;

    function get_subject_list
        return varchar2 is
        v_subject_list   varchar2(30000) := null;
        v_cnt            number          := 0;
    begin
        log_error('Starting Get_subject_list');

        for a in (select pi.participant_version, pi.obj, prt.role,
                         roi_block(pi.participant_version) as title_block
                    from t_osi_partic_involvement pi, t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Subject'
                     and prt.usage = 'SUBJECT')
        loop
            if v_cnt = 0 then
                v_subject_list := a.title_block;
            else
                v_subject_list := v_subject_list || '\par\par \tab ' || a.title_block;
            end if;

            v_cnt := v_cnt + 1;
        end loop;

        return v_subject_list;
    exception
        when others then
            log_error('Get_Subject_List>>> - ' || sqlerrm);
            return null;
    end get_subject_list;

    function get_victim_list
        return varchar2 is
        v_victim_list   varchar2(30000) := null;
        v_cnt           number          := 0;
    begin
        for a in (select pi.participant_version, pi.obj, prt.role,
                         roi_block(pi.participant_version) as title_block
                    from t_osi_partic_involvement pi, t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Victim'
                     and prt.usage = 'VICTIM')
        loop
            if v_cnt = 0 then
                v_victim_list := a.title_block;
            else
                v_victim_list := v_victim_list || '\par\par \tab ' || a.title_block;
            end if;

            v_cnt := v_cnt + 1;
        end loop;

        return v_victim_list;
    exception
        when others then
            log_error('Get_Victim_List>>> - ' || sqlerrm);
            return null;
    end get_victim_list;

    function roi_block(ppopv in varchar2) return varchar2 is

         v_result   varchar2(4000);
         v_temp     varchar2(2000);
         v_saa      varchar2(100);
         v_per      varchar2(20);

    begin
         get_basic_info(ppopv, v_result, v_saa, v_per);------, true, false, false, false);

         if v_saa = 'ME' then                                         --- military (or employee) ---

           v_result := v_result || nvl(get_org_info(ppopv), 'UNK');

         else                                                         --- civilian or military dependent  ---
             v_temp := null;

             for r in (select vpr.related_to as that_version,
                              ltrim(vpr.description, 'is ') as rel_type
                           from v_osi_partic_relation vpr, t_osi_partic_relation pr
                          where vpr.this_participant = v_per
                            and vpr.SID = pr.SID
                            and description in('is Spouse of', 'is Child of')
                            and (pr.end_date is null or pr.end_date > sysdate)
                      order by nvl(pr.start_date, modify_on) desc)
             loop
                 get_basic_info(r.that_version, v_temp, v_saa, v_per);
                 v_result := v_result || nvl(get_org_info(r.that_version), 'UNK') || ', ';
                 exit;                                                     --- only need 1st row ---
             end loop;

             v_result := v_result || nvl(osi_address.get_addr_display(osi_address.get_address_sid(ppopv)), 'UNK');--CR#2728 || '.';
         end if;

         v_result := rtrim(v_result, '; ');
         return(v_result);

    end roi_block;

    function get_owning_unit_cdr
        return varchar2 is
        v_cdr_name   varchar2(500) := null;
        v_cdr_sid    varchar(20);
        v_pay_cat    varchar(4);
    begin
        begin
            log_error('Starting get_owning_unit_cdr');

            select a.personnel
              into v_cdr_sid
              from t_osi_assignment a, t_osi_assignment_role_type art
             where a.unit = v_unit_sid and a.assign_role = art.SID and art.description = 'Commander';
        exception
            when no_data_found then
                v_cdr_name := 'XXXXXXXXXXXXXXXXXX';
        end;

        begin
            select first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name,
                   decode(op.pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
              into v_cdr_name,
                   v_pay_cat
              from t_core_personnel p, t_osi_personnel op
             where p.SID = v_cdr_sid and p.SID = op.SID;
        exception
            when no_data_found then
                v_pay_cat := 'USAF';
        end;

        v_cdr_name := v_cdr_name || ', SA, ' || v_pay_cat;
        return v_cdr_name;
    exception
        when others then
            return 'XXXXXXXXXXXXXXXXXX, SA, USAF';
    end get_owning_unit_cdr;

    function get_caveats_list
        return varchar2 is
        v_caveats_list   varchar2(30000) := null;
        v_cnt            number          := 0;
    begin
        log_error('Start get_caveats_list');

        for a in (select   c.description
                      from t_osi_report_caveat_type c, t_osi_report_caveat r
                     where c.SID = r.caveat and r.spec = v_spec_sid and r.selected = 'Y'
                  order by description)
        loop
            if v_cnt = 0 then
                v_caveats_list := a.description;
            else
                v_caveats_list := v_caveats_list || '\par\par ' || a.description;
            end if;

            v_cnt := v_cnt + 1;
        end loop;

        return v_caveats_list;
    exception
        when others then
            return null;
    end get_caveats_list;

    procedure get_sel_activity(pspecsid in varchar2) is
        v_current_group   varchar2(200)   := null;
        v_narr_header     varchar2(30000) := null;
        v_narr_title      varchar2(30000) := null;
        v_exhibits        varchar(30000)  := null;
        v_init_notif      clob            := null;                      -- Varchar2(32000) := null;
        v_tmp_exhibits    clob            := null;
        v_ok              boolean;
    begin
        log_error('Starting get_sel_activity');
        v_paraoffset := 0;

        begin
            select summary_allegation
              into v_init_notif
              from t_osi_f_investigation
             where SID = v_obj_sid;

            if v_init_notif is not null then
                v_paraoffset := 1;
                v_current_group := 'Background';
                --- TOC Entry ---
                osi_util.aitc(v_act_toc_list, '\tx0\b ' || v_current_group || '\b0\tx7920\tab 2-1');
                --- Narrative Header  ---
                osi_util.aitc(v_act_narr_list, '\b ' || v_current_group || '\b0');
                --- Initial Notification Text ---
                v_act_narr_list := v_act_narr_list || '\par\par 2-1\tab\fi0\li0 ' || v_init_notif;
            --|| osi_report.replace_special_chars_clob(v_init_notif, 'RTF');
            end if;
        exception
            when no_data_found then
                null;
        end;

        for a in (select   *
                      from v_osi_rpt_roi_rtf
                     where spec = pspecsid and selected = 'Y'
                  order by seq asc, roi_combined_order asc, roi_group)
        loop
            if v_current_group is null then
                -- First TOC Group Header
                osi_util.aitc(v_act_toc_list, '\tx0\b ' || a.roi_group || '\b0');
                -- First Narrative Group Header
                osi_util.aitc(v_act_narr_list, '\b ' || a.roi_group || '\b0');
            else
                if v_current_group <> a.roi_group then
                    -- TOC Group Header
                    osi_util.aitc(v_act_toc_list, '\par\par\tx0\b ' || a.roi_group || '\b0');
                    -- Narrative Group Header
                    osi_util.aitc(v_act_narr_list, '\par\par\b ' || a.roi_group || '\b0');
                end if;
            end if;

            v_current_group := a.roi_group;
            -- Table of Contents listing --
            osi_util.aitc(v_act_toc_list,
                          '\par\par\fi-720\li720\tab ' || a.roi_toc || '\tx7920\tab 2-'
                          || to_char(a.seq + v_paraoffset));
            -- Narrative Header --
            v_narr_header :=
                '\par\par 2-' || to_char(a.seq + v_paraoffset) || '\tab\fi-720\li720 '
                || replace(roi_header(a.activity, 'Y'), v_newline, c_hdr_linebreak);
            osi_util.aitc(v_act_narr_list, v_narr_header);
            -- Exhibits --
            v_exhibits := get_act_exhibit(a.activity);

            if v_exhibits is not null then
                osi_util.aitc(v_act_narr_list, '\line ' || v_exhibits);
            end if;

            v_exhibits := null;

            -- Narrative Text --
            if a.roi_narrative is not null then
                osi_util.aitc(v_act_narr_list,
                              '{\info {\comment ~~NARRATIVE_BEGIN~~' || v_act_sid || '}}');

                if v_act_desc = 'Group Interview' then
                    osi_util.aitc(v_act_narr_list, '\par ' || c_blockparaoff);
                else
                    osi_util.aitc(v_act_narr_list, '\par\par ' || c_blockparaoff);
                end if;

                dbms_lob.append(v_act_narr_list, a.roi_narrative);
                osi_util.aitc(v_act_narr_list,
                              '{\info {\comment ~~NARRATIVE_END~~' || v_act_sid || '}}');
            else
                osi_util.aitc(v_act_narr_list, '\par ' || c_blockparaoff);
            end if;

            v_narr_header := null;
        end loop;

        log_error('End get_sel_activity');
    end get_sel_activity;

    procedure get_evidence_list(pparentsid in varchar2, pspecsid in varchar2) is
        lastaddress        varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        lastdate           date            := '01-JAN-1900';
        lastact            varchar2(20)    := '~`~`~`~`~`~`~`~`~`~';
        lastowner          varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        lastobtainedby     varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        lastreceivedfrom   varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        printnewline       boolean;
        currentagents      varchar2(32000) := '~`~`~`~`~`~`~`~`~`~';
        lastagents         varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        tempstring         varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        sortorder          number;
    begin
        log_error('--->Get_Evidence_List' || sysdate);

        for a in
            (select   e.SID, e.obj as activity, e.tag_number, e.obtained_by, e.obtained_date,
                      osi_address.get_addr_display
                                     (osi_address.get_address_sid(e.SID))
                                                                        as obtained_address_string,
                      e.description,
                      '(para. 2-' || trim(to_char(ra.seq + v_paraoffset, '999')) || ')' as para_no
                 from v_osi_evidence e, t_osi_report_activity ra
                where e.obj = ra.activity
                  and e.obj in(select activity
                                 from v_osi_rpt_roi_rtf
                                where selected = 'Y' and spec = pspecsid)
                  and spec = pspecsid
             order by ra.seq, e.tag_number)
        loop
            printnewline := false;

            if    lastact <> a.activity
               or lastaddress <> a.obtained_address_string then
                if lastact <> '~`~`~`~`~`~`~`~`~`~' then
                    osi_util.aitc(v_evidence_list, v_horz_line);
                end if;

                osi_util.aitc(v_evidence_list,
                              'Obtained at: \tab \fi-1440\li1440\ '
                              || osi_report.replace_special_chars(a.obtained_address_string || ' '
                                                                  || a.para_no,
                                                                  'RTF')
                              || ' \par ');
                printnewline := true;
                lastact := a.activity;
                lastaddress := a.obtained_address_string;
            end if;

            if lastdate <> a.obtained_date then
                osi_util.aitc(v_evidence_list,
                              'Obtained on: \tab \fi-1440\li1440\ '
                              || to_char(a.obtained_date, v_date_fmt) || ' \par ');
                printnewline := true;
                lastdate := a.obtained_date;
            end if;

            if lastobtainedby <> a.obtained_by then
                sortorder := 99;

                for n in (select a.personnel,
                                 decode(art.description, 'Lead Agent', 1, 99) as sortorder
                            from t_osi_assignment a,
                                 t_osi_assignment_role_type art,
                                 t_core_personnel p
                           where a.obj = a.activity
                             and a.assign_role = art.SID
                             and p.SID = a.obtained_by)
                loop
                    sortorder := n.sortorder;
                end loop;

                osi_util.aitc(v_evidence_list,
                              'Obtained by: \tab \fi-1440\li1440\ ' || a.obtained_by || ' \par ');
                printnewline := true;
                lastobtainedby := a.obtained_by;
            end if;

            currentagents := osi_report.get_assignments(a.activity);

            if lastagents <> currentagents then
                osi_util.aitc(v_evidence_list,
                              'Agent(s): \tab \fi-1440\li1440\ ' || currentagents || ' \par ');
                printnewline := true;
                lastagents := currentagents;
            end if;

            for p in (select participant_version
                        from t_osi_partic_involvement i, t_osi_partic_role_type rt
                       where i.obj = a.SID and i.involvement_role = rt.SID and rt.role = 'Owner')
            loop
                tempstring := getparticipantname(p.participant_version, true);

                if lastowner <> tempstring then
                    osi_util.aitc(v_evidence_list,
                                  'Owner: \tab \fi-1440\li1440\ ' || tempstring || ' \par ');
                    printnewline := true;
                    lastowner := tempstring;
                end if;
            end loop;

            tempstring := '~`~`~`~`~`~`~`~`~`~';

            for p in (select participant_version
                        from t_osi_partic_involvement i, t_osi_partic_role_type rt
                       where i.obj = a.SID
                         and i.involvement_role = rt.SID
                         and rt.role in('Received From Participant', 'Siezed From Participant'))
            loop
                tempstring := getparticipantname(p.participant_version, true);

                if lastreceivedfrom <> tempstring then
                    osi_util.aitc(v_evidence_list,
                                  'RCVD From: \tab \fi-1440\li1440\ ' || tempstring || ' \par ');
                    printnewline := true;
                    lastreceivedfrom := tempstring;
                end if;
            end loop;

            if printnewline = true then
                osi_util.aitc(v_evidence_list, ' \par ');
            end if;

            osi_util.aitc(v_evidence_list,
                          ' \tab ' || a.tag_number || ': \tab \fi-1440\li1440\ '
                          || osi_report.replace_special_chars(a.description, 'RTF') || ' \par ');
        end loop;

        log_error('<---Get_Evidence_List' || sysdate);
    end get_evidence_list;

    procedure get_idp_notes(pspecsid in varchar2, pfontsize in varchar2 := '20') is
        v_cnt   number := 0;
    begin
        for a in (select   note, seq, timestamp
                      from v_osi_rpt_avail_note
                     where spec = pspecsid
                       and (   selected = 'Y'
                            or category = 'Curtailed Content Report Note')
                  order by seq, timestamp)
        loop
            v_cnt := v_cnt + 1;

            if v_cnt = 1 then
                osi_util.aitc(v_idp_list,
                              replace(c_blockhalfinch, '\fs20', '\fs' || pfontsize) || v_cnt
                              || '\tab ');
            else
                osi_util.aitc(v_idp_list, '\par\par ' || v_cnt || '\tab ');
            end if;

            dbms_lob.append(v_idp_list, osi_report.replace_special_chars_clob(a.note, 'RTF'));
        end loop;
    end get_idp_notes;

    function get_act_exhibit(pactivitysid in varchar2)
        return varchar2 is
        v_tmp_narr_exhibits   varchar2(30000) := null;
        v_cnt                 number          := 0;
        v_ok                  boolean;
    begin
        log_error('>>>Get_Act_Exhibit-' || pactivitysid);
        v_exhibit_table :=
            '\trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\pard\plain \qc \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid2117219\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table
            || '\b\fs36 Exhibit #\b\fs36 [TOKEN@EXHIBIT_NUMBER]\b\fs36 \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0';
        v_exhibit_table :=
            v_exhibit_table
            || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033  \trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\row \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trrh7964\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\pard\plain \qc \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid2117219\yts18 \fs36\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table
            || '[TOKEN@EXHIBIT_NAME]\cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trrh7964\trleft-108';
        v_exhibit_table :=
            v_exhibit_table
            || '\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc';
        v_exhibit_table :=
            v_exhibit_table
            || '\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\row \pard\plain \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0\yts18';
        v_exhibit_table :=
                      v_exhibit_table || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table
            || '\trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\pard\plain \qc \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid2117219\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table || '\b\fs36 Exhibit #\b\fs36 [TOKEN@EXHIBIT_NUMBER]\b\fs36 \par '
            || osi_classification.get_report_class(pactivitysid)
            || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0';
        v_exhibit_table :=
            v_exhibit_table
            || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033  \trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\row ';

        for a in (select   a.description, ra.activity, ra.seq,
                           '(para. 2-' || trim(to_char(ra.seq + v_paraoffset, '999'))
                           || ')' as para_no
                      from t_osi_report_activity ra,
                           t_osi_attachment a,
                           t_osi_report_attachment rat
                     where (ra.activity = a.obj and rat.attachment = a.SID)
                       and ra.spec = v_spec_sid
                       and ra.spec = rat.spec
                       and ra.activity = pactivitysid
                       and ra.selected='Y'
                       and rat.selected = 'Y'
                  order by ra.seq)
        loop
            v_exhibit_cnt := v_exhibit_cnt + 1;
            v_cnt := v_cnt + 1;
            osi_util.aitc(v_exhibits_list,
                          ' \tab ' || v_exhibit_cnt || ' \tab '
                          || osi_report.replace_special_chars_clob(a.description, 'RTF') || ' '
                          || osi_report.replace_special_chars_clob(a.para_no, 'RTF') || '\par\par ');

            if v_cnt = 1 then
                v_tmp_narr_exhibits := v_exhibit_cnt;
            else
                v_tmp_narr_exhibits := v_tmp_narr_exhibits || ', ' || v_exhibit_cnt;
            end if;

            v_exhibit_covers :=
                v_exhibit_covers
                || replace(replace(v_exhibit_table,
                                   '[TOKEN@EXHIBIT_NUMBER]',
                                   v_exhibit_cnt || '\par ' || a.para_no),
                           '[TOKEN@EXHIBIT_NAME]',
                           osi_report.replace_special_chars_clob(a.description, 'RTF'));
        end loop;

        log_error('<<<Get_Act_Exhibit-Exhibits for ' || pactivitysid || '=' || v_cnt
                  || ', Total Exhibits=' || v_exhibit_cnt);

        if v_cnt > 0 then
            if v_cnt = 1 then
                return 'Exhibit: ' || v_tmp_narr_exhibits;
            else
                return 'Exhibits: ' || v_tmp_narr_exhibits;
            end if;
        else
            return v_tmp_narr_exhibits;
        end if;
    exception
        when others then
            return '';
    end get_act_exhibit;

    function case_status_report(psid in varchar2)
        return clob is
        v_ok              varchar2(1000);
        v_template        clob                                    := null;
        v_template_date   date;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_full_id         varchar2(100)                           := null;
        v_file_id         varchar2(100)                           := null;
        v_summary         clob                                    := null;
        v_report_by       varchar2(500);
        v_unit_address    varchar2(500);
        v_unit_name       varchar2(100);
        v_file_offense    varchar2(1000);
        v_distributions   varchar2(3000);
        v_updates         clob                                    := null;
        v_class           varchar2(100);
    begin
        log_error('Case_Status_Report<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('CASE_STATUS_REPORT',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        /* ----------------- Cover Page ------------------ */
        for a in (select s.SID, s.obj, pt.purpose, it.ig_code, st.status
                    from t_osi_report_spec s,
                         t_osi_report_igcode_type it,
                         t_osi_report_status_type st,
                         t_osi_report_purpose_type pt,
                         t_osi_report_type rt
                   where obj = v_obj_sid
                     and s.report_type = rt.SID
                     and rt.description = 'Case Status Report'
                     and s.ig_code = it.SID
                     and s.status = st.SID
                     and s.purpose = pt.SID)
        loop
            v_spec_sid := a.SID;
            v_ok :=
                core_template.replace_tag(v_template,
                                          'DATE',
                                          to_char(sysdate, v_date_fmt),
                                          'TOKEN@',
                                          true);
            --- First Page Footer Information ---
            v_ok :=
                core_template.replace_tag(v_template,
                                          'PURPOSE',
                                          osi_report.replace_special_chars(a.purpose, 'RTF'),
                                          'TOKEN@',
                                          true);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'IGCODES',
                                          osi_report.replace_special_chars(a.ig_code, 'RTF'),
                                          'TOKEN@',
                                          true);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'STATUS',
                                          osi_report.replace_special_chars(a.status, 'RTF'),
                                          'TOKEN@',
                                          true);
        end loop;

        for b in (select i.summary_investigation, f.id, f.full_id,
                         ot.description || ', ' || ot.code as file_offense
                    from t_osi_f_investigation i,
                         t_osi_file f,
                         t_osi_f_inv_offense o,
                         t_osi_reference r,
                         t_dibrs_offense_type ot
                   where i.SID = v_obj_sid
                     and i.SID(+) = f.SID
                     and i.SID = o.investigation
                     and o.priority = r.SID
                     and (r.code = 'P' and r.usage = 'OFFENSE_PRIORITY')
                     and o.offense = ot.SID)
        loop
            v_full_id := b.full_id;
            v_file_id := b.id;
            v_file_offense := b.file_offense;
            v_summary := b.summary_investigation;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'FILE_NUM', v_full_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'SUBJECT', get_subject_list);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'OFFENSES',
                                      osi_report.replace_special_chars_clob(v_file_offense, 'RTF'));
        v_ok :=
            core_template.replace_tag(v_template,
                                      'BACKGROUND',
                                      osi_report.replace_special_chars_clob(v_summary, 'RTF'));

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, 'RTF'),
                                      'TOKEN@',
                                      true);

        --- More First Page Footer Information ---
        for a in (select distribution
                    from t_osi_report_distribution
                   where spec = v_spec_sid)
        loop
            v_distributions := v_distributions || a.distribution || '; ';
        end loop;

        v_distributions := rtrim(v_distributions, '; ');
        v_ok :=
            core_template.replace_tag(v_template,
                                      'DISTRIBUTION',
                                      osi_report.replace_special_chars(v_distributions, 'RTF'));
        v_ok := core_template.replace_tag(v_template, 'REV', '');

        --- Report By ---
        begin
            select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(ua.unit), null, ' ')
                                                                                         as address
              into v_unit_name,
                   v_unit_address
              from t_osi_personnel_unit_assign ua, t_osi_unit_name un
             where ua.unit = un.unit
               and ua.unit = osi_personnel.get_current_unit(core_context.personnel_sid)
               and ua.personnel = core_context.personnel_sid
               and un.end_date is null;
          /*  select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(unit)) as address
              into v_unit_name,
                   v_unit_address
              from v_osi_obj_assignments oa, t_osi_unit_name un
             where obj = v_obj_sid and un.unit = oa.current_unit;
        select display_string_line
          into v_unit_address
          from v_address_v2
         where parent = context_pkg.unit_sid; */
        exception
            when no_data_found then
                v_unit_address := '<unknown>';
        end;

        v_ok :=
            core_template.replace_tag
                                  (v_template,
                                   'REPORT_BY',
                                   osi_report.replace_special_chars(core_context.personnel_name,
                                                                    'RTF')
                                   || ', ' || osi_report.replace_special_chars(v_unit_name, 'RTF')
                                   || ', ' || v_unit_address,
                                   'TOKEN@',
                                   false);

        --- Update via 'Case Status Report - Update' Note Type ---
        for a in (select note_text
                    from t_osi_note n, t_osi_note_type nt
                   where n.obj = v_obj_sid
                     and n.note_type = nt.SID
                     and nt.description = 'Case Status Report - Update'
                     and obj_type = core_obj.get_objtype(v_obj_sid))
        loop
            v_updates :=
                v_updates || osi_report.replace_special_chars_clob(a.note_text, 'RTF')
                || ' \par\par ';
        end loop;

        v_updates := rtrim(v_updates, ' \par\par ');
        v_ok := core_template.replace_tag(v_template, 'UPDATES', v_updates, 'TOKEN@', false);
        log_error('Case_Status_Report - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('Case_Status_Report - Error -->' || sqlerrm);
            return v_template;
    end case_status_report;

    function letter_of_notification(psid in varchar2)
        return clob is
        v_ok                  varchar2(1000);
        v_template            clob                                    := null;
        v_template_date       date;
        v_mime_type           t_core_template.mime_type%type;
        v_mime_disp           t_core_template.mime_disposition%type;
        v_full_id             varchar2(100)                           := null;
        v_file_id             varchar2(100)                           := null;
        v_letters             clob                                    := null;
        v_unit_from_address   varchar2(1000);
        v_unit_sid            varchar2(20);
        v_unit_name           varchar2(1000);
        v_memorandum_to       varchar2(1000);
        v_lead_agent          varchar2(1000);
        v_lead_agent_phone    varchar2(100);
        v_lead_agent_sid      varchar2(20);
        v_subject_name        varchar2(1000);
        v_subject_ssn         varchar2(20);
        v_subject_lastname    varchar2(1000);
        v_signature_line      varchar2(5000);
        v_fax_number          varchar2(100);
        v_sig_phone           varchar2(100);
        v_class               varchar2(100);
    begin
        log_error('Letter_Of_Notification<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('LETTER_OF_NOTIFICATION',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        --- Get Actual SID of Object ---
        for a in (select SID
                    from t_osi_report_spec
                   where obj = v_obj_sid)
        loop
            v_spec_sid := a.SID;
        end loop;

        --- Get the Lead Agents Sid and Name ---
        v_lead_agent_sid := osi_object.get_lead_agent(v_obj_sid);

        begin
            select decode(badge_num, null, '', 'SA ') || nls_initcap(first_name || ' ' || last_name)
              into v_lead_agent
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = v_lead_agent_sid and op.SID = cp.SID;
        exception
            when others then
                v_lead_agent := core_context.personnel_name;
        end;

        v_lead_agent_phone := getpersonnelphone(v_lead_agent_sid);

        --- Get the Full and File ID's ---
        begin
            select full_id, id
              into v_full_id, v_file_id
              from t_osi_file
             where SID = v_obj_sid;
        exception
            when others then
                v_full_id := '<Case Number Not Found>';
                v_file_id := '<Case Number Not Found>';
        end;

        --- Get the Owning Units SID and Name ---
        begin
            select unit, unit_name
              into v_unit_sid, v_unit_name
              from t_osi_f_unit f, t_osi_unit_name un
             where f.file_sid= v_obj_sid and un.unit = f.UNIT_SID and f.end_date is null and un.end_date is null;
        exception
            when others then
                v_unit_sid := osi_object.get_assigned_unit(v_obj_sid);
                v_unit_name := osi_unit.get_name(v_unit_sid);
        end;

        --- Get the Owning Unit's Address ---
        begin
            select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(v_unit_sid), null, ' ')
                                                                                         as address
              into v_unit_name,
                   v_unit_from_address
              from t_osi_f_unit f, t_osi_unit_name un
             where f.file_sid= v_obj_sid and un.unit = f.UNIT_SID and f.end_date is null and un.end_date is null;
        exception
            when others then
                v_unit_from_address := '<<Unit Address not Entered in UMM>>';
        end;

        if v_full_id is null then
            v_full_id := v_file_id;
        end if;

        v_fax_number := getunitphone(v_unit_sid, 'Office - Fax');

        --- Build the Signature Line ---
        begin
            select 'FOR THE COMMANDER \par\par\par\par\par ' || first_name || ' ' || last_name
                   || decode(badge_num, null, '', ', Special Agent')
                   || decode(pay_category, '03', ', DAF', '04', ', DAF', ', USAF')
              into v_signature_line
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = core_context.personnel_sid and cp.SID = op.SID;
        exception
            when others then
                v_signature_line :=
                          'FOR THE COMMANDER \par\par\par\par\par<Agent Name>, Special Agent, USAF';
        end;

        v_signature_line :=
            v_signature_line || '\par Superintendent, AFOSI '
            || replace(v_unit_name, 'DET', 'Detachment');
        v_sig_phone := getpersonnelphone(core_context.personnel_sid);

        --- One Page Letters for Each Subject associated to the Case ---
        for a in (select pi.participant_version, sa_rank, ssn
                    from v_osi_participant_version pv,
                         t_osi_partic_involvement pi,
                         t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pv.SID = pi.participant_version
                     and pi.involvement_role = prt.SID
                     and (prt.role = 'Subject' and prt.usage = 'SUBJECT'))
        loop
            if v_letters is not null then
                v_letters := v_letters || ' \page \par ';
            end if;

            --- Get The Subjects Military Organization Name ---
            for p in (select related_name as that_name
                        from v_osi_partic_relation, t_osi_participant_version pv
                       where this_participant = pv.participant and pv.SID = a.participant_version)
                 --and that_person_subtype_code = 'M'
                -- and end_date is null
            --order by start_date)
            loop
                v_memorandum_to := p.that_name;
            end loop;

            if v_memorandum_to is null then
                v_memorandum_to := '<<Military Organization NOT FOUND>>';
            end if;

            v_subject_name := null;
            v_subject_lastname := null;

            --- Get the Subjects RANK FIRST_NAME LAST_NAME ---
            for n in (select nls_initcap(first_name) as first_name,
                             nls_initcap(last_name) as last_name, nt.description as name_type
                        from t_osi_partic_name pn, t_osi_partic_name_type nt
                       where participant_version = a.participant_version and pn.name_type = nt.SID)
            loop
                if    n.name_type = 'Legal'
                   or v_subject_name is null then
                    v_subject_name := n.first_name || ' ' || n.last_name;
                    v_subject_lastname := n.last_name;
                end if;
            end loop;

            if a.sa_rank is not null then
                v_subject_name := a.sa_rank || ' ' || v_subject_name;
                v_subject_lastname := a.sa_rank || ' ' || v_subject_lastname;
            end if;

            if a.sa_rank is null then
                v_subject_lastname := v_subject_name;
            end if;

            --- Get the Subjects SSN ---
            if a.ssn is not null then

              v_Subject_SSN := Replace(a.ssn,'-','');
              v_Subject_SSN := ' (' || substr(v_Subject_SSN,1,3) || '-' || substr(v_Subject_SSN,4,2) || '-' || substr(v_Subject_SSN,6,4) || ')';

            end if;

            v_letters := v_letters || '\ltrrow\trowd \irow0\irowband0\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\pard\plain \ltrpar\qr \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373'; 
            v_letters := v_letters || '\rtlch\fcs1 \af0\afs24\alang1025 \ltrch\fcs0 \fs24\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid2903220 ' || to_char(sysdate, v_date_fmt) || '}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642';
            v_letters := v_letters || '\par }{\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642 \trowd \irow0\irowband0\ltrrow\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3'; 
            v_letters := v_letters || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow1\irowband1\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth1298\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx2430\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth3702\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220 MEMORANDUM FOR \cell }{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642   ' || osi_report.replace_special_chars(nls_initcap(v_memorandum_to), 'RTF') || '}{\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220'; 
            v_letters := v_letters || '\par }\pard \ltrpar\qr \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220  }{\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642\charrsid11272613 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 \trowd \irow1\irowband1\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth1298\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx2430\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth3702\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow2\irowband2\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard\plain \ltrpar\s17\qc \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 \rtlch\fcs1 \af0\afs20\alang1025'; 
            v_letters := v_letters || '\ltrch\fcs0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \b\fs24\insrsid2702642 \cell }\pard\plain \ltrpar\ql \li0\ri0\sa200\sl276\slmult1';
            v_letters := v_letters || '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs24\alang1025 \ltrch\fcs0 \fs24\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 \trowd \irow2\irowband2\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow3\irowband3\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 FROM:    }{\rtlch\fcs1 \af0'; 
            v_letters := v_letters || '\ltrch\fcs0 \insrsid2702642\charrsid2903220 \cell }{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 ' || replace(v_unit_name, 'DET', 'Detachment') || '}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid2903220 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1';
            v_letters := v_letters || '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow3\irowband3\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow4\irowband4\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\pard \ltrpar';
            v_letters := v_letters || '\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \cell }{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 ' || osi_report.replace_special_chars(v_unit_from_address, 'RTF') || '}{';
            v_letters := v_letters || '\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow4\irowband4\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\row \ltrrow';
            v_letters := v_letters || '}\trowd \irow5\irowband5\ltrrow\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt';
            v_letters := v_letters || '\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1'; 
            v_letters := v_letters || '\af0 \ltrch\fcs0 \insrsid2702642 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow5\irowband5\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0';
            v_letters := v_letters || '\insrsid2702642 ' || 'SUBJECT:  ' || 'Notification of AFOSI Investigation involving ' || v_Subject_Name || v_Subject_SSN || ' case number ' || v_full_id || '.' || '}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid1525579 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1';
            v_letters := v_letters || '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow6\irowband6\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642\charrsid7890914 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow7\irowband7\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642 '; 
            v_letters := v_letters || '1.  This is to inform you there is an on-going AFOSI investigation involving ' || v_Subject_LastName || ' from the ' || v_Memorandum_To || '.  IAW AFPD 71-1, Criminal Investigations and Counterintelligence, paragraph 7.5.3., Air Force Commanders: "Do not reass';
            v_letters := v_letters || 'ign order or permit any type of investigation, or take any other official action against someone undergoing an AFOSI investigation before coordinating with AFOSI and the servicing SJA."  We recommend you place this individual on administrative hold IAW AFI 36-2110, Table 2.1, Rule 10, Code 17';
            v_letters := v_letters || ' to prevent PCS and/or retirement pending completion of the investigation, and command action if appropriate.  Please coordinate any TDY or leave requests concerning this individual with AFOSI prior to approval.}{\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\b\insrsid2702642 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow8\irowband8\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow9\irowband9\ltrrow';
            v_letters := v_letters || '\ts16\trrh135\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642\charrsid268333 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow9\irowband9\ltrrow';
            v_letters := v_letters || '\ts16\trrh135\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0\insrsid2702642 ';
            v_letters := v_letters || '2.  Please endorse this letter and fax it to ' || v_Unit_Name || ', at ' || v_Fax_Number || '.  The case agent assigned to this investigation is ' || v_Lead_Agent || '.  If you have any questions concerning the investigation please contact the case agent first at ' || v_Lead_Agent_Phone || '.  If the case agent is unavailable, I can be reac';
            v_letters := v_letters || 'hed at ' || v_Sig_Phone || '.}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid268333 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642'; 
            v_letters := v_letters || '\trowd \irow10\irowband10\ltrrow\ts16\trrh135\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt';
            v_letters := v_letters || '\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow11\irowband11\ltrrow';
            v_letters := v_letters || '\ts16\trrh576\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642'; 
            v_letters := v_letters || '\cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow11\irowband11\ltrrow';
            v_letters := v_letters || '\ts16\trrh576\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow12\irowband12\lastrow \ltrrow';
            v_letters := v_letters || '\ts16\trrh1269\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth2868\clshdrawnil \cellx5369\clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth2132\clshdrawnil \cellx9360\pard \ltrpar';
            v_letters := v_letters || '\qr \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 \cell }\pard \ltrpar';
            v_letters := v_letters || '\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 ' || v_Signature_Line; 
            v_letters := v_letters || '\cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow12\irowband12\lastrow \ltrrow';
            v_letters := v_letters || '\ts16\trrh1269\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth2868\clshdrawnil \cellx5369\clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth2132\clshdrawnil \cellx9360\row }\pard \ltrpar';
            v_letters := v_letters || '\ql \li0\ri0\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0';

        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'LETTERS', v_letters);

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class || v_newline || v_privacyActInfo, 'RTF'));
        log_error('Letter_Of_Notification - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('Letter_Of_Notification - Error -->' || sqlerrm);
            return v_template;
    end letter_of_notification;

    function getpersonnelphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2 is
        v_phone_number   varchar2(100) := null;
    begin
        if onlygetthistype is not null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = onlygetthistype
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;

            return v_phone_number;
        end if;

        for m in (select value
                    into v_phone_number
                    from t_osi_personnel_contact pc, t_osi_reference r
                   where pc.personnel = psid
                     and pc.type = r.SID
                     and r.code = 'OFFP'
                     and r.usage = 'CONTACT_TYPE')
        loop
            v_phone_number := m.value;
        end loop;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'OFFA'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'DSNP'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'DSNA'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'MOBP'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'MOBA'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        return v_phone_number;
    end getpersonnelphone;

    function getparticipantphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2 is
        v_phone_number   varchar2(100) := null;
    begin
        if onlygetthistype is not null then
            v_phone_number := osi_participant.get_contact_value(psid, onlygetthistype);
            return v_phone_number;
        end if;

        v_phone_number := osi_participant.get_contact_value(psid, 'OFFP');

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'OFFA');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'DSNP');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'DSNA');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'MOBP');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'MOBA');
        end if;

        return v_phone_number;
    end getparticipantphone;

    function getunitphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2 is
        v_phone_number   varchar2(100) := null;
    begin
        if onlygetthistype is not null then
            for m in (select value
                        into v_phone_number
                        from t_osi_unit_contact uc, t_osi_reference r
                       where uc.unit = psid
                         and uc.type = r.SID
                         and r.description = onlygetthistype
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;

            return v_phone_number;
        end if;
    end getunitphone;

    function case_subjectvictimwitnesslist(psid in varchar2)
        return clob is
        v_ok              varchar2(1000);
        v_template        clob                                    := null;
        v_template_date   date;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_full_id         varchar2(100)                           := null;
        v_file_id         varchar2(100)                           := null;
        v_list            clob                                    := null;
        v_subject_name    varchar2(1000);
        v_subject_ssn     varchar2(20);
        v_office_phone    varchar2(100)                           := null;
        v_home_phone      varchar2(100)                           := null;
        v_email           varchar2(100)                           := null;
        v_last_role       varchar2(1000)                 := '~~FIRST_TIME_THROUGH~~UNIQUE~~HERE~~~';
    begin
        log_error('CASE_SubjectVictimWitnessList <<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('SUBJECT_VICTIM_WITNESS_LIST',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        --- Get Actual SID of Object ---
        for a in (select SID
                    from t_osi_report_spec
                   where obj = v_obj_sid)
        loop
            v_spec_sid := a.SID;
        end loop;

        --- Get the Full and File ID's ---
        begin
            select full_id, id
              into v_full_id, v_file_id
              from t_osi_file
             where SID = v_obj_sid;
        exception
            when others then
                v_full_id := '<Case Number Not Found>';
                v_file_id := '<Case Number Not Found>';
        end;

        if v_full_id is null then
            v_full_id := v_file_id;
        end if;

        --- List Subjects ---
        for a in (select   pi.participant_version, pi.obj,
                           decode(prt.role,
                                  'Subject of Activity', 'Witness',
                                  'Primary', 'Witness',
                                  prt.role) as involvement_role,
                           osi_participant.get_name(pv.SID) as name,
                           osi_participant.get_org_member_name(pv.SID) as org_name,
                           osi_participant.get_org_member_addr(pv.SID) as org_addr,
                           pv.current_address_desc as curr_addr_line, pv.ssn,
                           pv.sa_service_desc as sa_service, pv.sa_rank
                      from v_osi_participant_version pv,
                           t_osi_partic_involvement pi,
                           t_osi_partic_role_type prt
                     where pi.obj = v_obj_sid
                       and pv.SID = pi.participant_version
                       and pi.involvement_role = prt.SID
                       and prt.role in('Subject', 'Victim')
                  union all
                  select   pi.participant_version, pi.obj,
                           decode(prt.role,
                                  'Subject of Activity', 'Witness',
                                  'Primary', 'Witness',
                                  prt.role) as involvement_role,
                           osi_participant.get_name(pv.SID) as name,
                           osi_participant.get_org_member_name(pv.SID) as org_name,
                           osi_participant.get_org_member_addr(pv.SID) as org_addr,
                           pv.current_address_desc as curr_addr_line, pv.ssn,
                           pv.sa_service_desc as sa_service, pv.sa_rank
                      from v_osi_participant_version pv,
                           t_osi_partic_involvement pi,
                           t_osi_partic_role_type prt
                     where pi.obj in(
                               select fa.activity_sid
                                 from t_osi_activity a,
                                      t_osi_assoc_fle_act fa,
                                      t_core_obj o,
                                      t_core_obj_type cot
                                where fa.file_sid = v_obj_sid
                                  and a.SID = fa.activity_sid
                                  and a.SID = o.SID
                                  and o.obj_type = cot.SID
                                  and (   cot.description = 'Interview, Witness'
                                       or cot.description = 'Group Interview'))
                       and pv.SID = pi.participant_version
                       and pi.involvement_role = prt.SID
                       and prt.role in('Subject of Activity', 'Witness', 'Primary')
                  order by 3, 4)
        loop
            if v_last_role <> a.involvement_role then
                v_last_role := a.involvement_role;
                v_list :=
                    v_list
                    || ' \par \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
                v_list :=
                    v_list
                    || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
                v_list :=
                    v_list
                    || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs1 \cell \pard';
                v_list :=
                    v_list
                    || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
                v_list :=
                    v_list
                    || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
                v_list :=
                    v_list
                    || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\row \pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \fs24 ';
                v_list := v_list || '\qc\b ' || a.involvement_role || '(s) \b0';
            end if;

            v_list :=
                v_list
                || ' \par \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
            v_list :=
                v_list
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
            v_list :=
                v_list
                || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs1 \cell \pard';
            v_list :=
                v_list
                || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
            v_list :=
                v_list
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
            v_list :=
                v_list
                || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\row \pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \fs24 \par ';
            v_subject_name := null;
            v_subject_ssn := null;

            --- Get the Subjects RANK FIRST_NAME MIDDLE_NAME LAST_NAME, CADENCY ---
            for n in (select nls_initcap(first_name) as first_name,
                             nls_initcap(middle_name) as middle_name,
                             nls_initcap(last_name) as last_name, pnt.description as name_type,
                             cadency
                        from t_osi_partic_name pn, t_osi_partic_name_type pnt
                       where participant_version = a.participant_version and pn.name_type = pnt.SID)
            loop
                if    n.name_type = 'Legal'
                   or v_subject_name is null then
                    v_subject_name := n.first_name || ' ';

                    if n.middle_name is not null then
                        v_subject_name := v_subject_name || n.middle_name || ' ';
                    end if;

                    v_subject_name := v_subject_name || n.last_name;

                    if n.cadency is not null then
                        v_subject_name := v_subject_name || ', ' || n.cadency;
                    end if;
                end if;
            end loop;

            if a.sa_rank is not null then
                v_subject_name := a.sa_rank || ' ' || v_subject_name;
            end if;

            --- Get the Subjects SSN ---
            if a.ssn is not null then
                v_subject_ssn := replace(a.ssn, '-', '');
                v_subject_ssn :=
                    substr(v_subject_ssn, 1, 3) || '-' || substr(v_subject_ssn, 4, 2) || '-'
                    || substr(v_subject_ssn, 5, 4);
            end if;

            --- Get Office Phone Number ---
            v_office_phone :=
                        osi_participant.get_contact_value(a.participant_version, 'Office - Primary');

            if v_office_phone is null then
                v_office_phone :=
                     osi_participant.get_contact_value(a.participant_version, 'Office - Alternate');
            end if;

            if v_office_phone is null then
                v_office_phone :=
                          osi_participant.get_contact_value(a.participant_version, 'DSN - Primary');
            end if;

            if v_office_phone is null then
                v_office_phone :=
                        osi_participant.get_contact_value(a.participant_version, 'DSN - Alternate');
            end if;

            --- Get Home Phone Number ---
            v_home_phone :=
                          osi_participant.get_contact_value(a.participant_version, 'Home - Primary');

            if v_home_phone is null then
                v_home_phone :=
                       osi_participant.get_contact_value(a.participant_version, 'Home - Alternate');
            end if;

            if v_home_phone is null then
                v_home_phone :=
                       osi_participant.get_contact_value(a.participant_version, 'Mobile - Primary');
            end if;

            if v_home_phone is null then
                v_home_phone :=
                     osi_participant.get_contact_value(a.participant_version, 'Mobile - Alternate');
            end if;

            --- Get Email Address ---
            v_email := osi_participant.get_contact_value(a.participant_version, 'Email - Primary');

            if v_email is null then
                v_email :=
                      osi_participant.get_contact_value(a.participant_version, 'Email - Alternate');
            end if;

   -------------------------------------------
--- Add this Participant to the Listing ---
   -------------------------------------------
            v_list := v_list || ltrim(rtrim(v_subject_name)) || ' \par ';

            if v_subject_ssn is not null then
                v_list := v_list || v_subject_ssn || ' \par ';
            end if;

            if a.curr_addr_line is not null then
                v_list := v_list || a.curr_addr_line || ' \par ';
            end if;

            if a.sa_service is not null and a.sa_service <> 'N/A' then
                v_list := v_list || a.sa_service || ' \par ';
            end if;

            if a.org_name is not null then
                v_list := v_list || a.org_name || ' \par ';
            end if;

            if a.org_addr is not null then
                v_list := v_list || a.org_addr || ' \par ';
            end if;

            if v_office_phone is not null then
                v_list := v_list || v_office_phone || ' \par ';
            end if;

            if v_home_phone is not null then
                v_list := v_list || v_home_phone || ' \par ';
            end if;

            if v_email is not null then
                v_list := v_list || v_email || ' \par ';
            end if;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'FULL_ID', v_full_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'LIST', v_list);
        log_error('CASE_SubjectVictimWitnessList - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('CASE_SubjectVictimWitnessList - Error -->' || sqlerrm);
            return v_template;
    end case_subjectvictimwitnesslist;

    function idp_notes_report(psid in varchar2)
        return clob is
        v_ok              varchar2(1000);
        v_template        clob                                    := null;
        v_template_date   date;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_cnt             number                                  := 0;
        v_full_id         varchar2(100)                           := null;
        v_file_id         varchar2(100)                           := null;
        v_unit_sid        varchar2(20);
        v_idp_list        clob                                    := null;
        v_url             varchar2(4000) := core_util.get_config('CORE.BASE_URL');
        v_tempstring      clob;
    begin
        log_error('IDP_Notes_Report<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('IDP_NOTES_RPT',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        /* ----------------- Cover Page ------------------ */
        v_ok :=
            core_template.replace_tag(v_template,
                                      'RPT_DATE',
                                      to_char(sysdate, v_date_fmt),
                                      'TOKEN@',
                                      true);

        for b in (select full_id, id
                    into v_full_id, v_file_id
                    from t_osi_file
                   where SID = v_obj_sid)
        loop
            v_full_id := b.full_id;
            v_file_id := b.id;
        end loop;

        for c in (select unit, unit_name
                    from v_osi_obj_assignments oa, t_osi_unit_name un
                   where obj = v_obj_sid and un.unit = oa.current_unit and end_date is null)
        loop
            v_unit_sid := c.unit;
            v_ok := core_template.replace_tag(v_template, 'UNIT_NAME', c.unit_name, 'TOKEN@', true);
        -- multiple instances
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        -- multiple instances
        v_ok := core_template.replace_tag(v_template, 'FILE_NO', v_full_id, 'TOKEN@', true);
        -- multiple instances
        log_error('OBJ =' || v_obj_sid);
        v_idp_list := null;

        for a in (select obj, note_text, seq, 'Note from:  ' || core_obj.get_parentinfo(n.obj) as parentinfo
                        from t_osi_note n, t_osi_note_type nt
                        where n.note_type=nt.sid 
                          and   (n.obj=v_obj_sid 
                             or (n.obj in (select that_file from v_osi_assoc_fle_fle where this_file=v_obj_sid)) 
                             or (n.obj in (select activity_sid from v_osi_assoc_fle_act where file_sid=v_obj_sid)) 
                             or (n.obj in (select activity_sid from v_osi_assoc_fle_act where file_sid in (select that_file from v_osi_assoc_fle_fle where this_file=v_obj_sid))))         
                          and nt.description in('Curtailed Content Report Note', 'IDP Note')
                      order by n.create_on,seq )
        loop
            v_cnt := v_cnt + 1;
            --osi_util.aitc(v_idp_list, '\par\par ' || v_cnt || '\tab ' || a.parentinfo || '\par \tab ');

        v_tempstring := '{\field\fldedit{\*\fldinst HYPERLINK "' || v_url || a.obj || '" }';
        v_tempstring := v_tempstring || '{\fldrslt'; 
        v_tempstring := v_tempstring || '\cs16\ul\cf2 ' || osi_report.replace_special_chars_clob(a.parentinfo, 'RTF') || '}} ';
        osi_util.aitc(v_idp_list, '\par\par ' || v_cnt || '\tab ' || v_tempstring || '\par \tab ');
            
            dbms_lob.append(v_idp_list, osi_report.replace_special_chars_clob(a.note_text, 'RTF'));
        end loop;

        v_ok := core_template.replace_tag(v_template, 'CLASSIFICATION', osi_classification.get_report_class(v_obj_sid));
        v_ok := core_template.replace_tag(v_template, 'IDP_NOTES', v_idp_list);
        core_util.cleanup_temp_clob(v_idp_list);
        log_error('IDP_Notes_Report - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('IDP_Notes_Report - Error -->' || sqlerrm);
            return v_template;
    end idp_notes_report;

    function form_40_roi(psid in varchar2)
        return clob is
        v_ok                         varchar2(1000);
        v_template                   clob                                    := null;
        v_template_date              date;
        v_mime_type                  t_core_template.mime_type%type;
        v_mime_disp                  t_core_template.mime_disposition%type;
        v_full_id                    varchar2(100)                           := null;
        v_file_id                    varchar2(100)                           := null;
        v_summary                    clob                                    := null;
        v_report_by                  varchar2(500);
        v_unit_name                  varchar2(500);
        v_unit_address               varchar2(500);
        v_subject_count              number;
        v_defendants                 clob;
        v_defendants_pages           clob;
        v_defendants_details         clob;
        v_phone_number               varchar2(100);
        v_birth_label                varchar2(50);
        v_birth_information          varchar2(32000);
        v_ssn_label                  varchar2(50);
        v_ssn_information            varchar2(100);
        v_marital_label              varchar2(50);
        v_marital_information        varchar2(100);
        v_heightweight               varchar2(100);
        v_occupation                 varchar2(500);
        v_spouse_sid                 varchar2(20);
        v_spouse_name                varchar2(500);
        v_spouse_deceased            date;
        v_height_weight              varchar2(100);
        v_subject_of_activity        varchar2(500);
        v_curr_address               varchar2(500);
        v_sid                        varchar2(20);
        v_exhibits_pages             clob;
        v_exhibit_information        clob;
        v_exhibit_counter            number;
        v_evidence_list              clob;
        v_evidence_counter           number;
        v_leadagent                  varchar2(500);
        v_background                 clob;
        v_status_notes               clob;
        v_other_activities           clob;
        v_other_activities_counter   number;
        v_program_data               clob;
        v_class                      varchar2(100);
        pragma autonomous_transaction;
    begin
        log_error('Form_40_ROI<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('FORM_40_ROI',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        /* ----------------- Cover Page ------------------ */
        v_ok :=
            core_template.replace_tag(v_template,
                                      'RPT_DATE',
                                      to_char(sysdate, v_date_fmt),
                                      'TOKEN@',
                                      true);

        osi_report.load_participants(psid);
        osi_report.load_agents_assigned(psid);
        log_error('Get file details');

        for b in (select i.summary_investigation, i.summary_allegation, f.id, f.full_id
                    from t_osi_f_investigation i, t_osi_file f
                   where i.SID = v_obj_sid and i.SID(+) = f.SID)
        loop
            v_full_id := b.full_id;
            v_file_id := b.id;
            v_summary := b.summary_investigation;
            v_background := b.summary_allegation;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'FILE_NO', v_full_id, 'TOKEN@', true);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'SUMMARY',
                                      osi_report.replace_special_chars_clob(v_summary, 'RTF'));

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, 'RTF'),
                                      'TOKEN@',
                                      true);

        if    v_background is null
           or v_background = '' then
            v_ok := core_template.replace_tag(v_template, 'BACKGROUND_LABEL', '', 'TOKEN@', true);
            v_ok := core_template.replace_tag(v_template, 'BACKGROUND', '');
        else
            v_ok :=
                core_template.replace_tag(v_template,
                                          'BACKGROUND_LABEL',
                                          'Background',
                                          'TOKEN@',
                                          true);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'BACKGROUND',
                                          osi_report.replace_special_chars_clob(v_background, 'RTF'));
        end if;

        -- Program Data
        log_error('Get Program Data Notes');
        v_program_data := '';

        for a in (select   n.note_text
                      from t_osi_note n, t_osi_note_type nt
                     where n.obj = v_obj_sid
                       and n.note_type = nt.SID
                       and nt.usage = 'NOTELIST'
                       and nt.code = 'PD'
                  order by n.create_on)
        loop
            osi_util.aitc(v_program_data,
                          osi_report.replace_special_chars_clob(a.note_text, 'RTF') || ' ');
        end loop;

        if (   v_program_data is null
            or v_program_data = '') then
            v_ok := core_template.replace_tag(v_template, 'PROGRAM_LABEL', '', 'TOKEN@', true);
            v_ok := core_template.replace_tag(v_template, 'PROGRAM', '');
        else
            v_ok := core_template.replace_tag(v_template, 'PROGRAM_LABEL', 'Program Information');
            v_ok :=
                core_template.replace_tag(v_template,
                                          'PROGRAM_LABEL',
                                          osi_rtf.page_break || ' Program Information');
            v_ok := core_template.replace_tag(v_template, 'PROGRAM', v_program_data);
        end if;

        --- Lead Agent ---
        log_error('get lead agent');

        for a in (select a.personnel, cp.first_name || ' ' || last_name as personnel_name,
                         osi_unit.get_name(a.unit) as unit_name
                    from t_osi_assignment a, t_core_personnel cp, t_osi_assignment_role_type art
                   where a.obj = v_obj_sid
                     and a.personnel = cp.SID
                     and a.assign_role = art.SID
                     and art.description = 'Lead Agent')
        loop
            select first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name || ', SA, '
                   || decode(op.pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
              into v_leadagent
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = a.personnel and cp.SID = op.SID;

            v_ok :=
                core_template.replace_tag(v_template,
                                          'LEAD_AGENT',
                                          osi_report.replace_special_chars(v_leadagent, 'RTF')
                                          || ' \par ' || a.unit_name,
                                          'TOKEN@',
                                          false);
            exit;
        end loop;

        --- Report By ---
        begin
            select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(ua.unit), null, ' ')
                                                                                         as address
              into v_unit_name,
                   v_unit_address
              from t_osi_personnel_unit_assign ua, t_osi_unit_name un
             where ua.unit = un.unit
               and ua.unit = osi_personnel.get_current_unit(core_context.personnel_sid)
               and ua.personnel = core_context.personnel_sid
               and un.end_date is null;
        /*select display_string_line
          into v_unit_address
          from v_address_v2
         where parent = context_pkg.unit_sid;  */
        exception
            when no_data_found then
                v_unit_address := '<unknown>';
            when others then
                log_error('Form_40_ROI - Error -->' || sqlerrm || ' '
                          || dbms_utility.format_error_backtrace);
        end;

        --- Try to get a Phone Number ---
        v_phone_number := getpersonnelphone(core_context.personnel_sid);
        log_error('I2MS' || ', ' || 'REPORT OUTPUT_1: REPORT_BY '
                  || osi_report.replace_special_chars(core_context.personnel_name, 'RTF'));
        v_ok :=
            core_template.replace_tag
                                  (v_template,
                                   'REPORT_BY',
                                   osi_report.replace_special_chars(core_context.personnel_name,
                                                                    'RTF')
                                   || ', ' || osi_report.replace_special_chars(v_unit_name, 'RTF')
                                   || ', ' || v_unit_address || ' ' || v_phone_number,
                                   'TOKEN@',
                                   false);
        --- Last Status ---
        v_ok :=
            core_template.replace_tag(v_template,
                                      'STATUS',
                                      osi_object.get_status(v_obj_sid),
                                      'TOKEN@',
                                      false);
        v_ok := core_template.replace_tag(v_template, 'SUBJECT_LIST', get_subject_list);
        v_subject_count := 1;

----------------------------------------------------
----------------------------------------------------
--- Get Defandants Table of Contents and Details ---
----------------------------------------------------
----------------------------------------------------
        for b in (select pv.participant, pi.participant_version, obj_type_desc, dob as birth_date,
                         pv.ssn, pv.co_cage, co_duns, osi_participant.get_name(pv.SID) as name,
                         pv.current_address_desc as curr_addr_line
                    from v_osi_participant_version pv,
                         t_osi_partic_involvement pi,
                         t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pv.SID = pi.participant_version
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Subject')
        loop
            if v_subject_count > 1 then
                v_defendants := v_defendants || ' \par \par ';
                v_defendants_pages := v_defendants_pages || ' \par \par ';
            end if;

            if b.obj_type_desc = 'Individual' then
                --- Birth Date and Place of Birth ---
                v_birth_label := 'Date/POB:';
                v_birth_information :=
                    to_char(b.birth_date, v_date_fmt) || '/'
                    || osi_address.get_addr_display(osi_address.get_address_sid(b.participant),
                                                    null,
                                                    ' ');
                --- Social Security Number ---
                v_ssn_label := 'SSN: \tab  ';
                v_ssn_information := b.ssn;
                --- Get the Participants Marital Status ---
                v_marital_label := 'Marital Status:';
                v_marital_information := null;
                
                v_spouse_sid := null;
                for s in (select related_to from v_osi_partic_relation where this_participant = b.participant and description = 'is Spouse of' and end_date is null order by start_date)
                loop
                    v_spouse_sid := s.related_to;
                    exit;
                    
                end loop;

                if v_spouse_sid is not null then
                    begin
                        select p.dod, first_name || ' ' || last_name as name
                          into v_spouse_deceased, v_spouse_name
                          from t_osi_participant p,
                               t_osi_partic_name pn,
                               t_osi_participant_version pv
                         where p.SID = v_spouse_sid
                           and p.current_version = pv.SID
                           and pn.participant_version = pv.SID;

                        v_marital_information := 'Married to ' || v_spouse_name;

                        if v_spouse_deceased is not null then
                            v_marital_information := 'Widowed by ' || v_spouse_name;
                        end if;
                    exception
                        when no_data_found then
                            v_marital_information := 'Single';
                    end;
                end if;
            else
                --- These values are only if the Participant is NOT an Individual ---

                --- Management ---
                v_birth_label := 'Management:';
                v_birth_information := '';
                log_error('>>>Check for Management->b.PARTICIPANT_VERSION=' || b.participant_version
                          || ',b.PARTICPANT=' || b.participant);

                for m in (select osi_participant.get_name(pr.partic_b) as related_name,
                                 pr.mod1_value
                            from t_osi_partic_relation pr, t_osi_partic_relation_type rt
                           where pr.rel_type = rt.SID
                             and pr.partic_a = b.participant
                             and rt.description = 'is Management')
                loop
                    if length(v_birth_information) > 0 then
                        v_birth_information := v_birth_information || ' \par\par \tab\tab   ';
                    end if;

                    v_birth_information :=
                                       v_birth_information || m.related_name || ', ' || m.mod1_value;
                end loop;

                --- Vendor Code (I used Cage Code, hope it is the same) ---
                v_ssn_label := 'Vendor Code:';
                v_ssn_information := b.co_cage;
                --- DUNS Number ---
                v_marital_label := 'DUNS Number:';
                v_marital_information := b.co_duns;
                --- Try to get a Phone Number ---
                v_phone_number := osi_participant.get_contact_value(b.participant_version, 'HOMEP');
            end if;

            --- Defendants Table Of Contents Entry ---
            v_defendants := v_defendants || osi_report.replace_special_chars(b.name, 'RTF');
            v_defendants_pages :=
                                v_defendants_pages || 'B-' || ltrim(rtrim(to_char(v_subject_count)));
            --- List the Defendants Each on a Seperate Page ---
            v_defendants_details := v_defendants_details || '{\b Defendant \b \par\par }';
            v_defendants_details :=
                            v_defendants_details || '{Name: \tab \tab   ' || b.name || ' \par\par }';

            if b.obj_type_desc != 'Individual' then
                v_defendants_details :=
                    v_defendants_details || '{Address: \tab   ' || b.curr_addr_line
                    || ' \par\par }';
                v_defendants_details :=
                    v_defendants_details || '{Phone: \tab \tab   ' || v_phone_number
                    || ' \par\par }';
            end if;

            v_defendants_details :=
                v_defendants_details || '{' || v_birth_label || ' \tab   ' || v_birth_information
                || ' \par\par}';
            v_defendants_details :=
                v_defendants_details || '{' || v_ssn_label || ' \tab   ' || v_ssn_information
                || ' \par\par }';

            if b.obj_type_desc != 'Individual' then
                v_defendants_details :=
                    v_defendants_details || '{' || v_marital_label || '  ' || v_marital_information
                    || ' \par\par }';
            end if;

            v_status_notes := 'Status Note:  ';

            for n in (select n.note_text
                        from t_osi_note n, t_osi_note_type nt
                       where n.obj = b.participant
                         and n.note_type = nt.SID
                         and nt.description = 'Status of Defendant')
            loop
                v_status_notes :=
                    v_status_notes || osi_report.replace_special_chars_clob(n.note_text, 'RTF')
                    || ' \par\par ';
            end loop;

            if v_status_notes != 'Status Note:  ' then
                v_defendants_details := v_defendants_details || v_status_notes;
            end if;

            --- Page Number ---
            v_defendants_details :=
                v_defendants_details || '{ \pard\pvmrg\posyb\phmrg\posxc B-'
                || rtrim(ltrim(to_char(v_subject_count))) || '\par\page }';
            v_subject_count := v_subject_count + 1;
        end loop;

        --- Defendants Table Of Contents Replacement ---
        v_ok := core_template.replace_tag(v_template, 'DEFENDANTS', v_defendants);
        v_ok := core_template.replace_tag(v_template, 'DEFENDANTS_PAGES', v_defendants_pages);
        --- Defendants Detailed Listing ---
        v_ok := core_template.replace_tag(v_template, 'DEFENDANT_DETAILS', v_defendants_details);
--------------------------
--------------------------
--- Witness Interviews ---
--------------------------
--------------------------
        v_defendants := null;                                              --- Reusing Variables ---
        v_defendants_pages := null;
        v_defendants_details := null;
        v_subject_count := 1;
        v_exhibit_counter := 1;
        v_evidence_counter := 1;
        v_evidence_list := null;

        for b in (select fa.activity_sid, a.narrative
                    from t_osi_activity a, t_osi_assoc_fle_act fa, t_core_obj o,
                         t_core_obj_type cot
                   where fa.file_sid = v_obj_sid
                     and a.SID = fa.activity_sid
                     and a.SID = o.SID
                     and o.obj_type = cot.SID
                     and cot.description = 'Interview, Witness')
        loop
            if v_subject_count > 1 then
                v_defendants := v_defendants || ' \par \par ';
                v_defendants_pages := v_defendants_pages || ' \par \par ';
            end if;

            begin
                select osi_participant.get_name(pv.SID) as name,
                       pv.current_address_desc as curr_addr_line, pi.participant_version
                  into v_subject_of_activity,
                       v_curr_address, v_sid
                  from v_osi_participant_version pv,
                       t_osi_partic_involvement pi,
                       t_osi_partic_role_type prt
                 where pi.obj = b.activity_sid
                   and pv.SID = pi.participant_version
                   and pi.involvement_role = prt.SID
                   and prt.role = 'Subject of Activity';
            exception
                when no_data_found then
                    v_subject_of_activity := '<Unknown>';
                    v_curr_address := null;
                    v_sid := null;
            end;

            v_defendants :=
                      v_defendants || osi_report.replace_special_chars(v_subject_of_activity, 'RTF');
            v_defendants_pages :=
                                v_defendants_pages || 'C-' || ltrim(rtrim(to_char(v_subject_count)));
            --- List the Witnesses Each on a Seperate Page ---
            v_defendants_details := v_defendants_details || '{\b Witness \b \par\par }';
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars(v_subject_of_activity, 'RTF') || ' \par\par }';
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars(v_curr_address, 'RTF') || ' \par\par }';
            --- Try to get a Phone Number ---
            v_phone_number := getparticipantphone(v_sid);
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars(v_phone_number, 'RTF') || ' \par\par }';
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars_clob(b.narrative, 'RTF') || ' \par\par}';

            --- Exhibits ---
            for e in (select description
                        from t_osi_attachment
                       where obj = b.activity_sid)
            loop
                if v_exhibit_counter > 1 then
                    v_exhibit_information := v_exhibit_information || ' \par \par ';
                    v_exhibits_pages := v_exhibits_pages || ' \par \par ';
                end if;

                v_exhibit_information :=
                    v_exhibit_information
                    || osi_report.replace_special_chars_clob(e.description, 'RTF');
                v_exhibits_pages :=
                                v_exhibits_pages || 'F-' || ltrim(rtrim(to_char(v_exhibit_counter)));
                v_defendants_details :=
                    v_defendants_details || 'Exhibit ' || 'F-'
                    || ltrim(rtrim(to_char(v_exhibit_counter))) || ':  '
                    || osi_report.replace_special_chars_clob(e.description, 'RTF') || ' \par \par ';
                v_exhibit_counter := v_exhibit_counter + 1;
            end loop;

            --- Page Number ---
            v_defendants_details :=
                v_defendants_details || '{ \pard\pvmrg\posyb\phmrg\posxc C-'
                || rtrim(ltrim(to_char(v_subject_count))) || '\par\page }';
            v_subject_count := v_subject_count + 1;

            --- Evidence Listing ---
            for e in (select description
                        from t_osi_evidence
                       where obj = b.activity_sid)
            loop
                if v_evidence_counter > 1 then
                    v_evidence_list := v_evidence_list || ' \par \par ';
                end if;

                v_evidence_list :=
                    v_evidence_list || ltrim(rtrim(to_char(v_evidence_counter))) || '.  '
                    || osi_report.replace_special_chars_clob(e.description, 'RTF');
                v_evidence_counter := v_evidence_counter + 1;
            end loop;
        end loop;

        v_evidence_list := v_evidence_list || '\par { \pard\pvmrg\posyb\phmrg\posxc D-1 \par\page }';
        --- Witness Interviews Table Of Contents Replacement ---
        v_ok := core_template.replace_tag(v_template, 'WITNESS_INTERVIEWS', v_defendants);
        v_ok :=
               core_template.replace_tag(v_template, 'WITNESS_INTERVIEWS_PAGES', v_defendants_pages);
        --- Defendants Detailed Listing ---
        v_ok :=
            core_template.replace_tag(v_template, 'WITNESS_INTERVIEWS_DETAILS',
                                      v_defendants_details);
        --- Exhibits Table Of Contents Replacement ---
        v_ok := core_template.replace_tag(v_template, 'EXHIBITS', v_exhibit_information);
        v_ok := core_template.replace_tag(v_template, 'EXHIBITS_PAGES', v_exhibits_pages);
        --- Evidence Listing ---
        v_ok := core_template.replace_tag(v_template, 'EVIDENCE_LISTING', v_evidence_list);
        --- Other Activities ---
        v_other_activities_counter := 0;

        for b in (select   cot.description as type, narrative, title
                      from t_osi_assoc_fle_act fa,
                           t_osi_activity a,
                           t_core_obj co,
                           t_core_obj_type cot
                     where fa.file_sid = v_obj_sid
                       and fa.activity_sid = a.SID
                       and a.SID = co.SID
                       and co.obj_type = cot.SID
                  order by a.activity_date)
        loop
            if b.type = 'Interview, Witness' then
                --- Skip the Witness Interviews ---
                v_ok := null;
            else
                v_other_activities_counter := v_other_activities_counter + 1;

                if    b.narrative is null
                   or b.narrative = '' then
                    v_other_activities :=
                        v_other_activities || '{'
                        || rtrim(ltrim(to_char(v_other_activities_counter))) || '.  '
                        || osi_report.replace_special_chars_clob(b.title, 'RTF') || ' \par\par}';
                else
                    v_other_activities :=
                        v_other_activities || '{'
                        || rtrim(ltrim(to_char(v_other_activities_counter))) || '.  '
                        || osi_report.replace_special_chars_clob(b.narrative, 'RTF')
                        || ' \par\par}';
                end if;
            end if;
        end loop;

        v_ok :=
            core_template.replace_tag(v_template,
                                      'OTHER_ACTIVITIES',
                                      v_other_activities
                                      || '\par { \pard\pvmrg\posyb\phmrg\posxc E-1 \par }');
        log_error('Form_40_ROI - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('Form_40_ROI - Error -->' || sqlerrm || ' '
                      || dbms_utility.format_error_backtrace);
            return v_template;
    end form_40_roi;

    /* Generic File report functions, included in this package because of common support functions and private variables */
    function genericfile_report(p_obj in varchar2)
        return clob is
        v_ok                varchar2(2);
        v_htlmorrtf         varchar2(4)                             := 'RTF';
        v_temp_template     clob;
        v_template          clob;
        v_template_date     date;
        v_mime_type         t_core_template.mime_type%type;
        v_mime_disp         t_core_template.mime_disposition%type;
        v_class_def         varchar2(500);
        v_class             varchar2(500);
        v_summary           clob                                    := null;
        v_full_id           varchar2(100)                           := null;
        v_report_period     varchar2(25)                            := null;
        v_description       varchar2(4000)                          := null;
        v_attachment_list   varchar2(30000)                         := null;
        v_parent_sid        varchar2(20);
    begin
        v_parent_sid := p_obj;

        begin
            select rs.SID
              into v_spec_sid                                                     --package variable
              from t_osi_report_spec rs, t_osi_report_type rt
             where rs.obj = p_obj and rs.report_type = rt.SID and rt.description = 'Report';
        exception
            when others then
                log_error('genericfile_report: ' || sqlerrm);
                v_template := 'Error: Report Specification not found.';
                return v_template;
        end;

        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('GENERIC_REPORT',
                                     v_temp_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        /* ----------------- Cover Page ------------------ */

        --- Get default classification from t_core_config
        begin
            select description
              into v_class_def
              from t_core_classification_level
             where code = core_util.get_config('OSI.DEFAULT_CLASS');
        exception
            when no_data_found then
                v_class_def := core_util.get_config('OSI.DEFAULT_CLASS');
        end;

        for a in (select obj, osi_reference.lookup_ref_desc(classification) as classification
                    from t_osi_report_spec
                   where SID = v_spec_sid)
        loop
            v_ok :=
                core_template.replace_tag
                                    (v_temp_template,
                                     'REPORT_BY',
                                     osi_report.replace_special_chars(core_context.personnel_name,
                                                                      v_htlmorrtf));
            v_ok :=
                core_template.replace_tag
                    (v_temp_template,
                     'RPT_DATE',
                     osi_report.replace_special_chars
                                                (to_char(sysdate,
                                                         core_util.get_config('CORE.DATE_FMT_DAY')),
                                                 v_htlmorrtf));

            if a.classification is not null then
                --replace both header and footer tokens
                v_ok :=
                    core_template.replace_tag(v_temp_template,
                                              'CLASSIFICATION',
                                              osi_report.replace_special_chars(a.classification,
                                                                               v_htlmorrtf));
                v_ok :=
                    core_template.replace_tag(v_temp_template,
                                              'CLASSIFICATION',
                                              osi_report.replace_special_chars(a.classification,
                                                                               v_htlmorrtf));
            end if;
        end loop;

        --default classification not required in I2MS, so set to ' ' if no class exists
        --v_class := nvl(core_classification_v2.full_marking(p_obj), v_class_def);
        v_class := core_classification_v2.full_marking(p_obj);

        --replace both header and footer tokens, move on if token already filled
        begin
            v_ok := core_template.replace_tag(v_temp_template, 'CLASSIFICATION', v_class);
            v_ok := core_template.replace_tag(v_temp_template, 'CLASSIFICATION', v_class);
        exception
            when others then
                null;
        end;

        for b in (select description, full_id,
                         to_char(start_date,
                                 core_util.get_config('CORE.DATE_FMT_DAY'))
                         || ' - ' || to_char(end_date, core_util.get_config('CORE.DATE_FMT_DAY'))
                                                                                    as reportperiod
                    from v_osi_rpt_gen1
                   where SID = v_parent_sid)
        loop
            v_full_id := b.full_id;
            v_report_period := b.reportperiod;
            v_description := b.description;
        end loop;

        v_ok :=
            core_template.replace_tag(v_temp_template,
                                      'DESCRIPTION',
                                      osi_report.replace_special_chars(v_description, v_htlmorrtf));
        v_ok :=
            core_template.replace_tag(v_temp_template,
                                      'REPORT_PERIOD',
                                      osi_report.replace_special_chars(v_report_period, v_htlmorrtf));
        v_ok :=
            core_template.replace_tag(v_temp_template,
                                      'FILE_NO',
                                      osi_report.replace_special_chars(v_full_id, v_htlmorrtf));

        -- multiple instances
        for c in (select summary_text
                    from t_osi_f_gen1_summary
                   where active = 'Y'
                     and file_sid = v_parent_sid
                     and summary_date = (select max(t_osi_f_gen1_summary.summary_date)
                                           from t_osi_f_gen1_summary
                                          where active = 'Y' and file_sid = v_parent_sid))
        loop
            v_summary := c.summary_text;
        end loop;

        v_ok := core_template.replace_tag(v_temp_template, 'SUMMARY', v_summary);
        core_util.cleanup_temp_clob(v_summary);
        v_unit_sid := osi_file.get_unit_owner(v_parent_sid);
        v_ok :=
            core_template.replace_tag
                                   (v_temp_template,
                                    'UNIT_NAME',
                                    osi_report.replace_special_chars(osi_unit.get_name(v_unit_sid),
                                                                     v_htlmorrtf));
        v_ok := core_template.replace_tag(v_temp_template, 'UNIT_CDR', get_owning_unit_cdr);
        v_ok := core_template.replace_tag(v_temp_template, 'CAVEAT_LIST', get_caveats_list);
        v_attachment_list := get_attachment_list(v_parent_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'ATTACHMENTS_LIST', v_attachment_list);
        get_objectives_list(v_parent_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'OBJECTIVE_LIST', v_act_narr_list);
        core_util.cleanup_temp_clob(v_act_narr_list);
        v_ok := core_template.replace_tag(v_temp_template, 'OBJECTIVE_TOC', v_narr_toc_list);
        core_util.cleanup_temp_clob(v_narr_toc_list);
        get_idp_notes(v_spec_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'IDP_LIST', v_idp_list);
        core_util.cleanup_temp_clob(v_idp_list);

        osi_report.load_participants(p_obj);
        osi_report.load_agents_assigned(p_obj);
        
        v_act_narr_list := null;
        v_act_toc_list := null;
        get_sel_activity(v_spec_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'ACTIVITY_TOC', v_act_toc_list);
        v_ok := core_template.replace_tag(v_temp_template, 'ACTIVITY_LIST', v_act_narr_list);
        core_util.cleanup_temp_clob(v_act_toc_list);
        core_util.cleanup_temp_clob(v_act_narr_list);
        v_template := v_template || v_temp_template;
        return v_template;
    exception
        when others then
            log_error('genericfile_report: ' || sqlerrm || ' '
                      || dbms_utility.format_error_backtrace);
            return null;
    end genericfile_report;

    function get_attachment_list(p_obj in varchar2)
        return varchar2 is
        v_tmp_attachments   varchar2(30000) := null;
        v_cnt               number          := 0;
    begin
        for a in (select   description
                      from v_osi_attachments
                     where obj = p_obj
                  order by description)
        loop
            v_cnt := v_cnt + 1;

            if a.description is not null then
                if v_cnt = 1 then
                    v_tmp_attachments := v_tmp_attachments || 'Attachments\line ';
                end if;

                v_tmp_attachments := v_tmp_attachments || ' - ' || a.description || '\line ';
            else
                return null;
            end if;
        end loop;

        return v_tmp_attachments;
    exception
        when others then
            log_error('get_attachment_list: ' || sqlerrm);
            return null;
    end get_attachment_list;

    procedure get_objectives_list(p_obj in varchar2) is
        v_objective   varchar2(500)  := null;
        v_comments    varchar2(4000) := null;
        v_cnt         number         := 0;
    begin
        for a in (select   *
                      from t_osi_f_gen1_objective o
                     where o.file_sid = p_obj and o.objective_met <> 'U'
                  order by objective)
        loop
            v_cnt := v_cnt + 1;                                           -- paragraph counter   --
            v_objective := v_cnt || '\tab\b ' || a.objective || '\b0\par\par ';
            core_util.append_info_to_clob(v_act_narr_list, v_objective, null);

            if v_cnt = 1 then
                core_util.append_info_to_clob(v_narr_toc_list,
                                              a.objective || '\tab ' || v_cnt,
                                              null);
            else
                core_util.append_info_to_clob(v_narr_toc_list,
                                              '\par\par ' || a.objective || '\tab ' || v_cnt,
                                              null);
            end if;

            v_comments := c_blockpara || 'Objective Comment: \tab ' || a.comments || '\par\par ';
            core_util.append_info_to_clob(v_act_narr_list, v_comments, null);

            -- Determine if the objective was met --
            if a.objective_met = 'N' then
                core_util.append_info_to_clob(v_act_narr_list,
                                              'Objective Met? \tab No\par\par ',
                                              null);
            else
                core_util.append_info_to_clob(v_act_narr_list,
                                              'Objective Met? \tab Yes\par\par ',
                                              null);
            end if;

            core_util.append_info_to_clob(v_act_narr_list,
                                          c_blockpara || '\b Supporting Activities:\b0\par\par ',
                                          null);

            for act in (select   a2.narrative as narrative
                            from t_osi_f_gen1_objective_act oa, t_osi_activity a2
                           where oa.objective = a.SID and oa.activity = a2.SID
                        order by oa.objective)
            loop
                if act.narrative is null then
                    core_util.append_info_to_clob(v_act_narr_list, '<None>\par\par', null);
                else
                    core_util.append_info_to_clob(v_act_narr_list,
                                                  core_util.clob_replace(act.narrative,
                                                                         v_newline,
                                                                         c_hdr_linebreak)
                                                  || '\par\par ',
                                                  null);
                end if;
            end loop;

            core_util.append_info_to_clob(v_act_narr_list,
                                          c_blockpara || '\b Supporting Files:\b0\par\par ',
                                          null);

            for fle in (select   f.file_sid as that_file
                            from t_osi_f_gen1_objective_file f
                           where f.objective = a.SID
                        order by f.objective)
            loop
                core_util.append_info_to_clob
                                            (v_act_narr_list,
                                             core_util.clob_replace(get_summary(fle.that_file),
                                                                    v_newline,
                                                                    c_hdr_linebreak)
                                             || '\par\par ',
                                             null);
            end loop;
        end loop;
    exception
        when others then
            log_error('get_objectives_list: ' || sqlerrm);
    end get_objectives_list;

    function escape_the_html(v_clob in clob)
        return clob is
        
        l_outlob        clob;
        l_limit         NUMBER := 10000;
        v_text_amt      BINARY_INTEGER := l_limit;
        v_text_buffer   varchar2(32767);
        v_text_pos      NUMBER := 1;

    begin

         --- Create a tempory LOB to place our html in ---
         --dbms_lob.CREATETEMPORARY(lob_loc => v_clob , cache   => false  , dur     => dbms_lob.session);
  
         --- Now to loop through the CLOB in 10k intervals               ---
         --- so we can htf.escape_sc the string of data back on the page ---
         LOOP
             v_text_buffer := DBMS_LOB.SUBSTR(v_clob, v_text_amt, v_text_pos);
             EXIT WHEN v_text_buffer IS NULL;

             --- process the text and prepare to read again ---
             osi_util.aitc(l_outlob,  htf.escape_sc(v_text_buffer));
             v_text_pos := v_text_pos + v_text_amt;

         END LOOP;
 
         --- Kill the temporary LOB ---   
         --DBMS_LOB.FREETEMPORARY(lob_loc => l_narrative);
         return l_outlob;
         
    end escape_the_html;
    
    function activity_narrative_preview(psid in varchar2, htmlorrtf in varchar2 := 'HTML')
        return clob is
        v_group        clob         := null;
        v_header       clob         := null;
        v_narrative    clob         := null;
        v_exhibits     clob         := null;
        v_preview      clob         := null;
        v_parent_sid   varchar2(20);
        pparentsid     varchar2(20);
        pobjective     varchar2(20);
    begin
        load_activity(psid);

        begin
            select file_sid
              into v_parent_sid
              from t_osi_assoc_fle_act c
             where c.activity_sid = psid;
        exception
            when others then
                v_parent_sid := psid;
        end;

        osi_report.load_Participants(v_parent_sid);
        osi_report.load_agents_assigned(v_parent_sid);

        select roi_group(psid), roi_header(psid) as header, roi_narrative(psid) as narrative
          into v_group, v_header, v_narrative
          from dual;

        if v_obj_type_code like 'ACT.AAPP%' then
            -- member of osi_object.get_objtypes('ACT.AAPP') THEN
            select a.obj, t.code
              into pparentsid, pobjective
              from t_osi_f_aapp_file_obj_act a,
                   t_osi_f_aapp_file_obj o,
                   t_osi_f_aapp_file_obj_type t
             where a.obj = psid and a.objective = o.SID and o.obj_type = t.SID;

            --- Narrative Group ---
            osi_util.aitc(v_preview,
                          '\b ' || v_group || '\b0\tab \tab '
                          || osi_aapp_file.rpt_generate_add_info_sections(v_parent_sid, pobjective));
            --- Narrative Header ---
            v_preview :=
                v_preview || '\line '
                || osi_aapp_file.rpt_generate_generic_act_sect(v_parent_sid, pobjective);
        else
            --- Narrative Group ---
            osi_util.aitc(v_preview, '\b ' || v_group || '\b0');
            --- Narrative Header ---
            osi_util.aitc(v_preview,
                          '\par\par 2-##\tab\fi-720\li720 '
                          || replace(v_header, v_newline, c_hdr_linebreak || '\tab '));
            --- Exhibits ---
            v_exhibits := get_act_exhibit(psid);
            osi_util.aitc(v_preview, v_exhibits);

            if v_exhibits is not null then

              if htmlorrtf='HTML' then

                osi_util.aitc(v_preview, '\line ' || escape_the_html(v_exhibits));

              else

                osi_util.aitc(v_preview, '\line ' || v_exhibits);

              end if;
              
            end if;

            --- Narrative Text ---
            if v_narrative is not null then

              if htmlorrtf='HTML' then

                dbms_lob.append(v_preview, '\par \ql\fi0\li0\line ' || escape_the_html(v_narrative));

              else

                dbms_lob.append(v_preview, '\par \ql\fi0\li0\line ' || v_narrative);

              end if;
              
            end if;
        end if;

        if htmlorrtf = 'RTF' then
            v_preview := '{\rtf1' || v_preview || '}';
        else
            --- Replace Bolded Character Sequences ---
            v_preview := replace(v_preview, '\b0', '</b>');
            v_preview := replace(v_preview, '\b', '<b>');
            v_preview :=
                replace
                    (v_preview,
                     '\ql\fi-720\li720\ \line \tab ',
                     '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            --- Replace Tabs with Spaces ---
            v_preview :=
                      replace(v_preview, '\tab', '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            --- Replace \ql = Left-aligned, \fi = First Line Indent, and \li - Left Indent ---
            v_preview := replace(v_preview, '\fi-720\li720 ', '');
            v_preview := replace(v_preview, '\ql\fi0\li0 ', '');
            v_preview := replace(v_preview, '\fi-720\li720', '');
            v_preview := replace(v_preview, '\ql\fi0\li0', '');
            --- Replace \line and \par line breaks ---
            v_preview := replace(v_preview, '\line', '<br>');
            v_preview := replace(v_preview, '\par', '<br>');
            --- Add Font and Replace any final Line Breaks ---
            v_preview :=
                '<HTML><FONT FACE="Times New Roman">' || replace(v_preview, '\par ', '<br>')
                || '</FONT></HTML>';
        end if;

        return v_preview;
    end activity_narrative_preview;

procedure auto_load_specs(p_obj in varchar2, p_list out varchar2, p_send_first_back varchar2 := 'N') is

         v_list varchar2(2000);
         v_offense varchar2(20);
         v_incident varchar2(20);
         v_subject varchar2(20);
         v_victim varchar2(20);
         v_offense_code varchar2(10);
         v_msg varchar2(4000);
         v_complete varchar2(4000);
         v_nibrs varchar2(10);
         v_count number;

begin
     for a in(  select im.incident || '~' || io.offense || '~' || pi.participant_version || '~' || pi2.participant_version as ALL_COMBOS
        from t_osi_f_inv_incident_map im,
             t_osi_f_inv_offense io,
             t_osi_partic_involvement pi,
             t_osi_partic_role_type prt,
             t_osi_partic_involvement pi2,
             t_osi_partic_role_type prt2
       where im.investigation = p_obj
         and io.investigation = p_obj
         and pi.obj = p_obj
         and pi.involvement_role = prt.SID
         and prt.role = 'Subject'
         and pi2.obj = p_obj  
         and pi2.involvement_role = prt2.SID
         and prt2.role = 'Victim'
         and im.incident || '~' || io.offense || '~' || pi.participant_version || '~'
             || pi2.participant_version not in (select incident
             || '~' || offense
             || '~' || subject 
             || '~' || victim as EXISTING_SPECS
        from t_osi_f_inv_spec 
       where investigation = p_obj))
     loop
         v_list := '~'|| a.all_combos || '~';
      
         v_incident := core_list.POP_LIST_ITEM(v_list);
         v_offense := core_list.POP_LIST_ITEM(v_list);
         v_subject :=core_list.POP_LIST_ITEM(v_list);
         v_victim  := core_list.POP_LIST_ITEM(v_list);
           
         --- Make sure it is a valid Offense Combination ---
         begin
              select nibrs_code, code into v_nibrs, v_offense_code from t_dibrs_offense_type where sid=v_offense;
              osi_checklist.check_offense_combos(p_obj, v_nibrs, v_incident, v_victim, v_offense_code, v_complete, v_msg, v_count);

         exception when others then

                  v_msg:='';
                  v_count:=0;

         end;

         if v_count=0 then
           
           if p_send_first_back = 'N' then

             insert into t_osi_f_inv_spec (investigation, incident, offense, subject, victim) values (p_obj, v_incident, v_offense, v_subject, v_victim);
           
           else
         
             p_list := '~'|| a.all_combos || '~'; 
             return;
           
           end if;

         end if;
         
     end loop; 

exception when others then
         
         log_error('Error in auto_load_specs-' || SQLERRM);
         
end auto_load_specs;
    
end osi_investigation;
/


CREATE OR REPLACE PACKAGE BODY "OSI_INIT_NOTIFICATION" is
/******************************************************************************
   Name:     osi_init_notification
   Purpose:  Provides functionality for Initial Notification objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    30-Oct-2009 T.Whitehead     Created Package.
    02-Nov-2009 T.Whitehead     Added clone.
    05-Nov-2009 T.Whitehead     Added create_case_file.
    30-Jun-2011  Tim Ward       CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Changed create_case_file.
    07-Jul-2011  Tim Ward       CR#3571 - Add Matters Investigated (Offenses) to Initial Notification.
                                  Changed create_case_file.
    07-Nov-2011 Tim Ward        CR#3918 - Check for Valid Offense Combinations when adding specs.
                                 Changed create_case_file.
******************************************************************************/
c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_INIT_NOTIFICATION';

procedure log_error(p_msg in varchar2) is
begin
     core_logger.log_it(c_pipe, p_msg);
end log_error;
    
function create_case_file(p_obj in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) return varchar2 is

        v_file_sid      t_core_obj.sid%type;
        v_file_type     t_core_obj_type.sid%type;
        v_fbi_loc_num   t_osi_unit.fbi_loc_num%type;
        v_special_int   varchar2(4000);
        v_temp_sid      varchar2(20);
        v_temp_str      varchar2(200);

begin
     v_file_type := core_obj.lookup_objtype('FILE.INV.CASE');

     for x in (select a.title, a.narrative, a.restriction, a.activity_date,
                      a.creating_unit, n.begin_date, n.end_date, n.reported_date,
                      n.mission_area
                 from t_osi_activity a, t_osi_a_init_notification n where a.sid = n.sid and n.sid = p_obj)
     loop
         --- Skipping osi_file.create_instance because we have a custom starting status note. ---
         insert into t_core_obj (obj_type) values (v_file_type) returning sid into v_file_sid;

         insert into t_osi_file (sid, title, id, restriction) values (v_file_sid, x.title, osi_object.get_next_id, x.restriction);

         --- Set the starting status. ---
         osi_status.change_status_brute(v_file_sid, osi_status.get_starting_status(v_file_type), 'Created from Inital Notification Activity');
         osi_object.create_lead_assignment(v_file_sid);
         osi_file.set_unit_owner(v_file_sid);
            
         --- Insert a Investigation File Record ---
         insert into t_osi_f_investigation (sid, manage_by, summary_allegation) values (v_file_sid, x.mission_area, x.narrative);
            
         --- Copy the Special Interests from the Activity to the File ---
         v_special_int := osi_object.get_special_interest(p_obj);
         osi_object.set_special_interest(v_file_sid, v_special_int);
            
         -- Investigative support doesn't apply. ---
         
         --- Create an incident in the File if any of the Dates were filled in the Activity ---
         if(x.begin_date is not null or x.end_date is not null or x.reported_date is not null)then

           select fbi_loc_num into v_fbi_loc_num from t_osi_unit where sid = x.creating_unit;
                 
           insert into t_osi_f_inv_incident (start_date, end_date, report_date, fbi_loc_num) values (x.begin_date, x.end_date, x.reported_date, v_fbi_loc_num) returning sid into v_temp_sid;
                                 
           insert into t_osi_f_inv_incident_map (investigation, incident) values (v_file_sid, v_temp_sid);            
         
         --- Create an incident with null dates ---
         else

           select fbi_loc_num into v_fbi_loc_num from t_osi_unit where sid = x.creating_unit;
                 
           insert into t_osi_f_inv_incident (start_date, end_date, report_date, fbi_loc_num) values (null, null, null, v_fbi_loc_num) returning sid into v_temp_sid;
                                 
           insert into t_osi_f_inv_incident_map (investigation, incident) values (v_file_sid, v_temp_sid);            
         
         end if;
            
         --- Copy the Subject if created in the Activity ---
         for p in (select pi.participant_version
                     from t_osi_partic_involvement pi, t_osi_partic_role_type rt
                       where pi.obj = p_obj
                         and pi.involvement_role = rt.sid
                         and rt.obj_type member of osi_object.get_objtypes(p_obj)
                         and rt.code = 'SUBJECT'
                         and rt.usage = 'PARTICIPANTS'
                         and participant_version in  (select * from table(split(p_parameter1,'~')) where column_value is not null))
         loop
             select sid into v_temp_sid from t_osi_partic_role_type
                 where code = 'SUBJECT'
                   and usage = 'SUBJECT'
                   and obj_type member of osi_object.get_objtypes(v_file_type);
                
             insert into t_osi_partic_involvement (obj, participant_version, involvement_role)
                     values (v_file_sid, p.participant_version, v_temp_sid);
                     
             for n in (select last_name from v_osi_partic_name
                           where participant_version = p.participant_version
                             and is_current = 'Y')
             loop
                 v_temp_str := n.last_name || ' (S); ';

             end loop;

         end loop;
            
         --- Copy the Victim over if created in the Activity ---
         for p in (select pi.participant_version from t_osi_partic_involvement pi, t_osi_partic_role_type rt
                       where pi.obj = p_obj
                         and pi.involvement_role = rt.sid
                         and rt.obj_type member of osi_object.get_objtypes(p_obj)
                         and rt.code = 'VICTIM'
                         and rt.usage = 'PARTICIPANTS')
         loop
             select sid into v_temp_sid from t_osi_partic_role_type
                 where code = 'VICTIM'
                   and usage = 'VICTIM'
                   and active = 'Y'
                   and obj_type member of osi_object.get_objtypes(v_file_type);
                   
             insert into t_osi_partic_involvement (obj, participant_version, involvement_role)
                     values (v_file_sid, p.participant_version, v_temp_sid);
                     
             for n in (select last_name from v_osi_partic_name
                           where participant_version = p.participant_version
                             and is_current = 'Y')
             loop
                 v_temp_str := v_temp_str || n.last_name || ' (V);';

             end loop;
         end loop;
            
         if(v_temp_str is not null) then

           update t_osi_file set title = v_temp_str where sid = v_file_sid;

         end if;
            
         --- Copy the Notified By into the file as Referred to OSI ---
         for p in (select pi.participant_version, pi.involvement_role from t_osi_partic_involvement pi, t_osi_partic_role_type rt
                       where pi.obj = p_obj
                         and pi.involvement_role = rt.sid
                         and rt.obj_type member of osi_object.get_objtypes(p_obj)
                         and rt.code = 'NOTIFIED'
                         and rt.usage = 'PARTICIPANT')
         loop
             select sid into v_temp_sid from t_osi_partic_role_type
                 where obj_type member of osi_object.get_objtypes(v_file_sid)
                   and code = 'REFTO'
                   and usage = 'OTHER AGENCIES';

             insert into t_osi_partic_involvement (obj, participant_version, involvement_role)
                     values (v_file_sid, p.participant_version, v_temp_sid);

         end loop;
            
         --- Associate the File and Activity ---
         insert into t_osi_assoc_fle_act (file_sid, activity_sid) values (v_file_sid, p_obj);

         --- Copy the Activity Assignments to the File ---
         for p in (select personnel, assign_role, start_date, unit from t_osi_assignment
                       where obj = p_obj
                         and end_date is null
                         and personnel <> core_context.personnel_sid)
         loop
             insert into t_osi_assignment (obj, personnel, assign_role, start_date, unit)
                      values(v_file_sid, p.personnel, p.assign_role, p.start_date, p.unit);
         end loop;

         --- Copy the Matters Investigated to the File ---
         for p in (select * from t_osi_a_init_notif_offense
                       where activity = p_obj)
         loop
             insert into t_osi_f_inv_offense (investigation, offense, priority)
                      values(v_file_sid, p.offense, p.priority);
         end loop;
         
         osi_investigation.auto_load_specs(v_file_sid, v_special_int, 'N');
         
     end loop;

     return v_file_sid;

exception when others then

         log_error('create_case_file: ' || sqlerrm);
         raise;

end create_case_file;

    function create_instance(
        p_title         in   varchar2,
        p_notified_by   in   varchar2,
        p_notified_on   in   varchar2,
        p_restriction   in   varchar2,
        p_narrative     in   clob)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
        v_obj_type t_core_obj_type.sid%type;
    begin
        v_obj_type := core_obj.lookup_objtype('ACT.INIT_NOTIF');
        v_sid :=
            osi_activity.create_instance(v_obj_type,
                                         p_notified_on,
                                         p_title,
                                         p_restriction,
                                         p_narrative);

        insert into t_osi_a_init_notification
                    (sid)
             values (v_sid);
        
        if(p_notified_by is not null)then
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_notified_by,
                         (select sid
                            from t_osi_partic_role_type
                           where obj_type member of osi_object.get_objtypes(v_obj_type) 
                             and usage = 'PARTICIPANT'
                             and code = 'NOTIFIED'));
        end if;
        return v_sid;
    end create_instance;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_in_record   t_osi_a_init_notification%rowtype;
    begin
        select *
          into v_in_record
          from t_osi_a_init_notification
         where sid = p_obj;

        insert into t_osi_a_init_notification
                    (sid, begin_date, end_date, reported_date, mission_area)
             values (p_new_sid,
                     v_in_record.begin_date,
                     v_in_record.end_date,
                     v_in_record.reported_date,
                     v_in_record.mission_area);
    exception
        when others then
            log_error('osi_init_notification.clone: ' || sqlerrm);
            raise;
    end clone;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;
end osi_init_notification;
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
--   Date and Time:   07:33 Tuesday November 8, 2011
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

PROMPT ...Remove page 11125
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11125);
 
end;
/

 
--application/pages/page_11125
prompt  ...PAGE 11125: Specification Details
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript" type="text/javascript">'||chr(10)||
' if ("&REQUEST."=="DONE")'||chr(10)||
'  {'||chr(10)||
'   opener.doSubmit(''EDIT_&P11125_SEL_SPECIFICATION.'');'||chr(10)||
'   close();'||chr(10)||
'  }'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 11125,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Specification Details',
  p_step_title=> 'Specification for &P0_OBJ_TAGLINE.',
  p_step_sub_title => 'Specifications',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817023621004643+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111107135338',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-Nov-2011 - Tim Ward - CR#3918 - Don''t allow invalid offense combinations.'||chr(10)||
'                                    Changed AutoFill (there was a hard-coded'||chr(10)||
'                                    sid in the offense select).'||chr(10)||
'                                    Added "Check for Valid DIBRS Offense" '||chr(10)||
'                                    and "Check for Duplicate Specification"');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>11125,p_text=>ph);
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
  p_id=> 94019914438382751 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11125,
  p_plug_name=> 'Specification Details',
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
  p_id=> 96332620513938137 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11125,
  p_plug_name=> 'Hidden',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 94020120656382753 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 10,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11125_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96318733214733668 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 40,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11125_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96532236521610932 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 30,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> 'P11125_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 94020327857382753 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 20,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
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
  p_id=>96429320859356164 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_branch_action=> 'f?p=&APP_ID.:11125:&SESSION.:DONE:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_IN_CONDITION',
  p_branch_condition=> 'SAVE,CREATE,DELETE',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 30-JUL-2009 09:29 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96334017312956174 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_SEL_SPECIFICATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 96332620513938137+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Selected Specification',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96341108103038674 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_INCIDENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Incident',
  p_source=>'INCIDENT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select i.incident_id d, i.sid r'||chr(10)||
'  from t_osi_f_inv_incident i,'||chr(10)||
'       t_osi_f_inv_incident_map im'||chr(10)||
' where im.investigation = :P0_OBJ'||chr(10)||
'   and im.incident = i.sid'||chr(10)||
' order by i.incident_id',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Incident -',
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
  p_id=>96341418277051068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_OFFENSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Offense',
  p_source=>'OFFENSE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select distinct o.description, o.sid'||chr(10)||
'  from t_dibrs_offense_type o,'||chr(10)||
'       t_osi_f_inv_offense io'||chr(10)||
' where io.investigation = :p0_obj'||chr(10)||
'   and io.offense = o.sid',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Offense -',
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
  p_id=>96341636200075087 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_SUBJECT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Subject',
  p_source=>'SUBJECT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select core_obj.get_tagline(pi.participant_version) disp, '||chr(10)||
'       pi.participant_version retn'||chr(10)||
'  from t_osi_partic_involvement pi,'||chr(10)||
'       t_osi_partic_role_type rt'||chr(10)||
' where pi.obj = :p0_obj'||chr(10)||
'   and pi.involvement_role = rt.sid'||chr(10)||
'   and rt.usage = ''SUBJECT'''||chr(10)||
' order by core_obj.get_tagline(pi.participant_version)',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Subject -',
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
  p_id=>96341817631079240 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_VICTIM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Victim',
  p_source=>'VICTIM',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select core_obj.get_tagline(pi.participant_version) disp, '||chr(10)||
'       pi.participant_version retn'||chr(10)||
'  from t_osi_partic_involvement pi,'||chr(10)||
'       t_osi_partic_role_type rt'||chr(10)||
' where pi.obj = :p0_obj'||chr(10)||
'   and pi.involvement_role = rt.sid'||chr(10)||
'   and rt.usage = ''VICTIM'''||chr(10)||
' order by core_obj.get_tagline(pi.participant_version)',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Victim -',
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
  p_id=>96342807026085639 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_INVESTIGATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => ':P0_OBJ',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_source=>'INVESTIGATION',
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

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 15949230625097714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_computation_sequence => 10,
  p_computation_item=> 'P11125_INCIDENT',
  p_computation_point=> 'AFTER_HEADER',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'SELECT SID FROM (select i.Sid'||chr(10)||
'  from t_osi_f_inv_incident i,'||chr(10)||
'       t_osi_f_inv_incident_map im'||chr(10)||
' where im.investigation = :P0_OBJ'||chr(10)||
'   and im.incident = i.sid'||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1',
  p_compute_when => '',
  p_compute_when_type=>'NEVER');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342028020082243 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_INCIDENT Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P11125_INCIDENT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Incident must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341108103038674 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342207435082245 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_OFFENSE Not Null',
  p_validation_sequence=> 2,
  p_validation => 'P11125_OFFENSE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Offense must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341418277051068 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342413868082245 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_SUBJECT Not Null',
  p_validation_sequence=> 3,
  p_validation => 'P11125_SUBJECT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Subject must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341636200075087 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342632472082245 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_VICTIM Not Null',
  p_validation_sequence=> 4,
  p_validation => 'P11125_VICTIM',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Victim must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341817631079240 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8757324793983937 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'Check for Valid DIBRS Offense Combination',
  p_validation_sequence=> 40,
  p_validation => 'declare'||chr(10)||
'  '||chr(10)||
'  p_offense varchar2(4000);'||chr(10)||
'  p_nibrs_code varchar2(4000);'||chr(10)||
'  p_complete varchar2(4000);'||chr(10)||
'  p_msg varchar2(4000); '||chr(10)||
'  v_count number := 0;'||chr(10)||
'  '||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'     begin  '||chr(10)||
'          select code, nibrs_code into p_offense, p_nibrs_code'||chr(10)||
'             from t_dibrs_offense_type where sid=:P11125_OFFENSE;'||chr(10)||
''||chr(10)||
'     exception when others then'||chr(10)||
''||chr(10)||
'              return '''';'||chr(10)||
''||chr(10)||
'     end;'||chr(10)||
''||chr(10)||
'     osi_checklist.check_offense_combos(:P0_OBJ, '||chr(10)||
'                                        p_nibrs_code, '||chr(10)||
'                                        :P11125_INCIDENT, '||chr(10)||
'                                        :P11125_VICTIM, '||chr(10)||
'                                        p_offense, '||chr(10)||
'                                        p_complete, '||chr(10)||
'                                        p_msg, '||chr(10)||
'                                        v_count);'||chr(10)||
''||chr(10)||
'     return p_msg;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Error',
  p_validation_condition=> ':request in (''SAVE'',''CREATE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8758920356162488 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'Check for Duplicate Specification',
  p_validation_sequence=> 50,
  p_validation => 'declare'||chr(10)||
'     v_count number := 0;'||chr(10)||
'begin'||chr(10)||
'     select count(*) into v_count'||chr(10)||
'       from T_OSI_F_INV_SPEC'||chr(10)||
'      where investigation=:p0_obj'||chr(10)||
'        and offense=:P11125_OFFENSE'||chr(10)||
'        and incident=:P11125_INCIDENT'||chr(10)||
'        and subject=:P11125_SUBJECT'||chr(10)||
'        and victim=:P11125_VICTIM;'||chr(10)||
''||chr(10)||
'  if v_count > 0 then'||chr(10)||
'    '||chr(10)||
'    return ''Duplicate specifications are not allowed'';'||chr(10)||
'  '||chr(10)||
'  else'||chr(10)||
'  '||chr(10)||
'    return '''';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Error',
  p_validation_condition=> ':request in (''SAVE'',''CREATE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
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
''||chr(10)||
'  v_list varchar2(2000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     osi_investigation.auto_load_specs(:P0_OBJ, v_list, ''Y'');'||chr(10)||
'wwv_flow.debug(''v_list='' || v_list);'||chr(10)||
'     :P11125_INCIDENT := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
'     :P11125_OFFENSE := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
'     :P11125_SUBJECT := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
'     :P11125_VICTIM := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
' '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 15961123231161840 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Auto Fill',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11125_SEL_SPECIFICATION',
  p_process_when_type=>'ITEM_IS_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'Declare'||chr(10)||
''||chr(10)||
'    v_inc_not_used varchar(20);'||chr(10)||
'    v_off_not_used varchar(20);'||chr(10)||
'    v_sub_not_used varchar(20);'||chr(10)||
'    v_vic_not_used varchar(20);'||chr(10)||
'    v_newest_inc varchar(20);'||chr(10)||
'    v_newest_off varchar(20);'||chr(10)||
'    v_newest_sub varchar(20);'||chr(10)||
'    v_newest_vic varchar(20);'||chr(10)||
''||chr(10)||
'Begin'||chr(10)||
''||chr(10)||
'--Select details not already on a spec '||chr(10)||
''||chr(10)||
'--Incidents'||chr(10)||
'  Begin'||chr(10)||
'   select incident into v_inc_not_used from('||chr(10)||
'    select im.incident     '||chr(10)||
'     from t_osi_f_inv_incident_map im, t_osi_f_inv_spec s'||chr(10)||
'    where im.investigation = :P0_OBJ'||chr(10)||
'     and s.incident(+) = im.incident'||chr(10)||
'     and s.incident is null'||chr(10)||
'    order by im.sid desc)'||chr(10)||
'   where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_inc_not_used := null;'||chr(10)||
'  end;'||chr(10)||
' '||chr(10)||
'--Offenses'||chr(10)||
'  Begin'||chr(10)||
'   SELECT offense into v_off_not_used from '||chr(10)||
'    (select o.offense'||chr(10)||
'       from t_osi_f_inv_offense o, t_osi_f_inv_spec s'||chr(10)||
'      where o.investigation = :P0_OBJ'||chr(10)||
'       and s.investigation(+) = o.investigation'||chr(10)||
'       and s.offense(+) = o.offense'||chr(10)||
'       and s.offense is null'||chr(10)||
'      order by o.sid desc)'||chr(10)||
'    where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_off_not_used := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'--Subjects'||chr(10)||
'  Begin'||chr(10)||
''||chr(10)||
'  select participant_version into v_sub_not_used from '||chr(10)||
'    (select i.participant_version'||chr(10)||
'      from t_osi_partic_involvement i, t_osi_partic_role_type rt, t_osi_f_inv_spec s'||chr(10)||
'     where i.obj = :P0_OBJ'||chr(10)||
'      and i.involvement_role = rt.sid'||chr(10)||
'      and i.obj = s.investigation(+)'||chr(10)||
'      and rt.role = ''Subject'''||chr(10)||
'      and s.subject is null'||chr(10)||
'     order by i.sid desc)'||chr(10)||
'    where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_sub_not_used := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'--Victims'||chr(10)||
'  Begin'||chr(10)||
'   select participant_version into v_vic_not_used from('||chr(10)||
'     select i.participant_version'||chr(10)||
'      from t_osi_partic_involvement i, t_osi_partic_role_type rt, t_osi_f_inv_spec s'||chr(10)||
'     where i.obj = :P0_OBJ'||chr(10)||
'      and i.involvement_role = rt.sid'||chr(10)||
'      and i.obj = s.investigation(+)'||chr(10)||
'      and rt.role = ''Victim'''||chr(10)||
'      and s.victim is null'||chr(10)||
'     order by i.sid desc)'||chr(10)||
'    where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_vic_not_used := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'--Select newest details '||chr(10)||
''||chr(10)||
'SELECT SID into v_newest_inc'||chr(10)||
'FROM (select i.Sid'||chr(10)||
'  from t_osi_f_inv_incident i,'||chr(10)||
'       t_osi_f_inv_incident_map im'||chr(10)||
' where im.investigation = :P0_OBJ'||chr(10)||
'   and im.incident = i.sid'||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
'SELECT offense into v_newest_off'||chr(10)||
'FROM (select o.offense'||chr(10)||
'  from t_osi_f_inv_offense o'||chr(10)||
' where o.investigation = :P0_OBJ'||chr(10)||
'   order by o.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
'SELECT SID into v_newest_sub'||chr(10)||
'FROM (select i.participant_version sid'||chr(10)||
'  from t_osi_partic_involvement i, t_osi_partic_role_type rt'||chr(10)||
' where i.obj = :P0_OBJ'||chr(10)||
'   and i.involvement_role = rt.sid'||chr(10)||
'   and rt.role = ''Subject'''||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
'SELECT SID into v_newest_vic'||chr(10)||
'FROM (select i.participant_version sid'||chr(10)||
'  from t_osi_partic_involvement i, t_osi_partic_role_type rt'||chr(10)||
' where i.obj = :P0_OBJ'||chr(10)||
'   and i.involvement_role = rt.sid'||chr(10)||
'   and rt.role = ''Victim'''||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
''||chr(10)||
'  --Display details not already on spec. If none exist, display newest details'||chr(10)||
''||chr(10)||
'  if v_inc_not_used is not null then'||chr(10)||
'      :P11125_INCIDENT := v_inc_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_INCIDENT := v_newest_inc;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if v_off_not_used is not null then'||chr(10)||
'      :P11125_OFFENSE := v_off_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_OFFENSE := v_newest_off;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if v_sub_not_used is not null then'||chr(10)||
'      :P11125_SUBJECT := v_sub_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_SUBJECT := v_newest_sub;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if v_vic_not_used is not null then'||chr(10)||
'      :P11125_VICTIM := v_vic_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_VICTIM := v_newest_vic;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;');
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
p:=p||'#OWNER#:T_OSI_F_INV_SPEC:P11125_SEL_SPECIFICATION:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 96334708785963131 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE,CREATE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P11125_SEL_SPECIFICATION',
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
p:=p||'P11125_SEL_SPECIFICATION';

wwv_flow_api.create_page_process(
  p_id     => 96556830184826720 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>96532236521610932 + wwv_flow_api.g_id_offset,
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
p:=p||'CLOSE_WINDOW';

wwv_flow_api.create_page_process(
  p_id     => 96551213299802912 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLOSE_WINDOW',
  p_process_name=> 'Close Window',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>94020327857382753 + wwv_flow_api.g_id_offset,
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
p:=p||'F|#OWNER#:T_OSI_F_INV_SPEC:P11125_SEL_SPECIFICATION:SID';

wwv_flow_api.create_page_process(
  p_id     => 96332918220946962 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11125_SEL_SPECIFICATION',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 11125
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
--   Date and Time:   07:33 Tuesday November 8, 2011
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

PROMPT ...Remove page 11130
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11130);
 
end;
/

 
--application/pages/page_11130
prompt  ...PAGE 11130: Specifications Offense/Incident
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_OBJ_DATA"'||chr(10)||
'"JS_POPUP_LOCATOR"';

wwv_flow_api.create_page(
  p_id     => 11130,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Specifications Offense/Incident',
  p_step_title=> 'Specifications Offense/Incident',
  p_step_sub_title => 'Specifications Offense/Incident',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817023621004643+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111107135623',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-OCT-2010 J.FARIS WCHG0000360 - Split out times from date picker, new update time process.'||chr(10)||
''||chr(10)||
'16-Jun-2011 Tim Ward CR#3868 - SAPRO - Added Military Installation Region.'||chr(10)||
'                               Added JS_POPUP_LOCATOR to HTML header.'||chr(10)||
'                               Added SAPRO Page Items.'||chr(10)||
'                               Added Check ON USI Validation.'||chr(10)||
''||chr(10)||
'07-Jul-2011 Tim Ward CR#3571 - Add Matters Investigated (Offenses) to Initial '||chr(10)||
'                               Notification.'||chr(10)||
'                                Changed Auto Load Specs process.'||chr(10)||
''||chr(10)||
'07-Nov-2011 - Tim Ward - CR#3918 - Don''t allow invalid offense combinations.'||chr(10)||
'                                    Changed Auto Load Specs.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>11130,p_text=>ph);
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
  p_id=> 6099805691970788 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11130,
  p_plug_name=> 'Incident Location (SAPRO/DSAIDS)',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 31,
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
  p_plug_display_condition_type => 'SQL_EXPRESSION',
  p_plug_display_when_condition => ':P11130_SEL_SPECIFICATION IS NOT NULL AND'||chr(10)||
':P11130_OFF_ON_USI IN (''Y'',''N'') AND'||chr(10)||
':P11130_OFFENSE IN (SELECT OFFENSE_SID FROM T_SAPRO_OFFENSES)',
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
  p_id=> 6985810968622257 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11130,
  p_plug_name=> 'Missing Items',
  p_region_name=>'',
  p_plug_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'N',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P11130_data_ready',
  p_plug_display_when_cond2=>'N',
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
  p_id=> 96365821685039982 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11130,
  p_plug_name=> 'Offense/Incident of Selected Specification',
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
  p_plug_display_condition_type => 'ITEM_IS_NOT_NULL',
  p_plug_display_when_condition => 'P11130_SEL_SPECIFICATION',
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
s:=s||'select s.sid "SID",'||chr(10)||
'       i.incident_id "Incident",'||chr(10)||
'       o.description "Offense Description",'||chr(10)||
'       osi_object.get_tagline_link(osi_participant.get_participant(s.subject)) "Subject",'||chr(10)||
'       osi_object.get_tagline_link(osi_participant.get_participant(s.victim)) "Victim",'||chr(10)||
'       decode(:P11130_SEL_SPECIFICATION, s.sid, ''Y'', ''N'') "Current"'||chr(10)||
'  from t_osi_f_inv_spec s,'||chr(10)||
'       t_osi_f_inv_incident i,';

s:=s||''||chr(10)||
'       t_dibrs_offense_type o'||chr(10)||
' where s.investigation = :P0_OBJ'||chr(10)||
'   and i.sid = s.incident'||chr(10)||
'   and o.sid = s.offense';

wwv_flow_api.create_report_region (
  p_id=> 96366028485039985 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11130,
  p_name=> 'Specifications',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> 'P11130_data_ready',
  p_display_when_cond2=> 'Y',
  p_display_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '9999',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Specifications found.',
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
  p_plug_query_exp_filename=> '&P11130_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96366217309039996 + wwv_flow_api.g_id_offset,
  p_region_id=> 96366028485039985 + wwv_flow_api.g_id_offset,
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
  p_id=> 96366331168039996 + wwv_flow_api.g_id_offset,
  p_region_id=> 96366028485039985 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Incident',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Incident',
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
  p_id=> 96366413968039996 + wwv_flow_api.g_id_offset,
  p_region_id=> 96366028485039985 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Offense Description',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Offense Description',
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
  p_id=> 96366537921039996 + wwv_flow_api.g_id_offset,
  p_region_id=> 96366028485039985 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Subject',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Subject',
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
  p_id=> 96366638971039996 + wwv_flow_api.g_id_offset,
  p_region_id=> 96366028485039985 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Victim',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Victim',
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
  p_id=> 96366734923039996 + wwv_flow_api.g_id_offset,
  p_region_id=> 96366028485039985 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 6,
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
  p_id=> 96366819440039996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11130,
  p_plug_name=> 'Hidden but rendered',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 10,
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
s:=s||'select x.sid,'||chr(10)||
'       wu.description "Weapon Used",'||chr(10)||
'       gc.description "Category"'||chr(10)||
'  from t_osi_f_inv_spec_arm x,'||chr(10)||
'       t_dibrs_reference wu,'||chr(10)||
'       t_dibrs_reference gc'||chr(10)||
' where x.specification = :P11130_SEL_SPECIFICATION'||chr(10)||
'   and wu.sid = x.armed_with'||chr(10)||
'   and gc.sid(+) = x.gun_category';

wwv_flow_api.create_report_region (
  p_id=> 97110225958171443 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11130,
  p_name=> 'Weapon Force Used',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 40,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> 'P11130_SEL_SPECIFICATION',
  p_display_condition_type=> 'ITEM_IS_NOT_NULL',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Weapons Force Used found.',
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
  p_plug_query_exp_filename=> '&P11130_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 97110513899171457 + wwv_flow_api.g_id_offset,
  p_region_id=> 97110225958171443 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:popupObjData({page: 11160,height: 300,item_names: ''P11160_SEL_ARM'',item_values:''#SID#''});',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
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
  p_id=> 97110607972171460 + wwv_flow_api.g_id_offset,
  p_region_id=> 97110225958171443 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Weapon Used',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Weapon Used',
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
  p_id=> 97110709342171460 + wwv_flow_api.g_id_offset,
  p_region_id=> 97110225958171443 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Category',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Category',
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
  p_id             => 96368024596040001 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 50,
  p_button_plug_id => 96366028485039985+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Specification',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:popupObjData({page: 11125,height: 300});',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96557112653831159 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 55,
  p_button_plug_id => 96366028485039985+wwv_flow_api.g_id_offset,
  p_button_name    => 'EDIT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Edit Specification',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:popupObjData({page:11125,'||chr(10)||
'                         height:300,'||chr(10)||
'                         item_names:''P11125_SEL_SPECIFICATION'','||chr(10)||
'                         item_values:''&P11130_SEL_SPECIFICATION.''});',
  p_button_condition=> 'P11130_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16616722099362629 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 56,
  p_button_plug_id => 96366028485039985+wwv_flow_api.g_id_offset,
  p_button_name    => 'P11130_AUTO_LOAD_SPEC',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Auto Load Specifications',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96533806616668515 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 60,
  p_button_plug_id => 96366028485039985+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Specification',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> 'P11130_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 97111423927199299 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 70,
  p_button_plug_id => 97110225958171443+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD_ARM',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Weapon Force',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:popupObjData({page: 11160,height: 300,item_names: ''P11160_SPECIFICATION'',item_values:''&P11130_SEL_SPECIFICATION.''});',
  p_button_condition=> 'P11130_WEAPONS_USED_APPLIES',
  p_button_condition2=> 'Y',
  p_button_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96367635209039999 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 10,
  p_button_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11130_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16180819885663557 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 80,
  p_button_plug_id => 96366028485039985+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 11130);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16182729122808121 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 90,
  p_button_plug_id => 97110225958171443+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 11130);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96367827388040001 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11130,
  p_button_sequence=> 20,
  p_button_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
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
  p_id=>96372107781040023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 16:49 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>96372335037040024 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_branch_action=> 'f?p=&APP_ID.:11130:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 13:53 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6101025786052264 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_INCIDENT_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Incident Location Military Installation (SAPRO/DSAIDS)',
  p_source=>'declare'||chr(10)||
''||chr(10)||
'  v_location_name varchar2(200);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if :P11130_SAPRO_LOCATION_CODE is not null then'||chr(10)||
''||chr(10)||
'       SELECT LOCATION_NAME into v_location_name'||chr(10)||
'             FROM T_SAPRO_LOCATIONS '||chr(10)||
'                 WHERE LOCATION_CODE=:P11130_SAPRO_LOCATION_CODE;'||chr(10)||
'       '||chr(10)||
'       return v_location_name;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'        return null;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:95%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P11130_OFF_ON_USI=''Y''',
  p_display_when_type=>'SQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'declare'||chr(10)||
''||chr(10)||
'  v_location_name varchar2(200):=null;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     SELECT LOCATION_NAME into v_location_name'||chr(10)||
'           FROM T_SAPRO_LOCATIONS '||chr(10)||
'               WHERE LOCATION_CODE IN (SELECT SAPRO_INCIDENT_LOCATION_CODE '||chr(10)||
'                                          FROM T_OSI_F_INV_SPEC '||chr(10)||
'                                          WHERE SID=:P11130_SEL_SPECIFICATION);'||chr(10)||
'       '||chr(10)||
'      return v_location_name;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
'      when NO_DATA_FOUND then'||chr(10)||
'      return null;'||chr(10)||
'end;');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6101204446055563 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_MILITARY_INCIDENT_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(505,''P11130_SAPRO_LOCATION_CODE'',''N'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P11130_OFF_ON_USI=''Y''',
  p_display_when_type=>'SQL_EXPRESSION',
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
  p_id=>6106226918459448 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_SAPRO_LOCATION_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 209,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sapro Location Code',
  p_source=>'SAPRO_INCIDENT_LOCATION_CODE',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>6166016711489012 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_SAPRO_LOCATION_CODE2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sapro Location Code',
  p_source=>'SAPRO_INCIDENT_LOCATION_CSC',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>6166231602493328 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_INCIDENT_LOCATION2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Incident Location City/State/Country (SAPRO/DSAIDS)',
  p_source=>'declare'||chr(10)||
''||chr(10)||
'  v_location_name varchar2(200);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if :P11130_SAPRO_LOCATION_CODE2 is not null then'||chr(10)||
''||chr(10)||
'       SELECT CITY || '', '''||chr(10)||
'           || STATE || DECODE(STATE,NULL,'''','' '')'||chr(10)||
'           || DECODE(COUNTRY,''UNITED STATES OF AMERICA'',''USA'',COUNTRY)'||chr(10)||
'               into v_location_name'||chr(10)||
'             FROM T_SAPRO_CITY_STATE_COUNTRY '||chr(10)||
'                 WHERE SID=:P11130_SAPRO_LOCATION_CODE2;'||chr(10)||
'       '||chr(10)||
'       return v_location_name;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'        return null;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:95%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P11130_OFF_ON_USI=''N''',
  p_display_when_type=>'SQL_EXPRESSION',
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
  p_id=>6166410262496654 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_MILITARY_INCIDENT_FIND_WIDGET2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(507,''P11130_SAPRO_LOCATION_CODE2'',''N'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P11130_OFF_ON_USI=''N''',
  p_display_when_type=>'SQL_EXPRESSION',
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
  p_id=>6533215996300577 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_SAPRO_INCIDENT_LOC_DELETE2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:doSubmit(''DELETE_LOC'');"><img src="#IMAGE_PREFIX#themes/OSI/delete.gif" alt="Delete"></a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P11130_SAPRO_LOCATION_CODE2 is not null',
  p_display_when_type=>'SQL_EXPRESSION',
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
  p_id=>6536007721668836 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_SAPRO_INCIDENT_LOC_DELETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 225,
  p_item_plug_id => 6099805691970788+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:doSubmit(''DELETE_LOC'');"><img src="#IMAGE_PREFIX#themes/OSI/delete.gif" alt="Delete"></a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P11130_SAPRO_LOCATION_CODE is not null',
  p_display_when_type=>'SQL_EXPRESSION',
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
  p_id=>6986714563632714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_DATA_READY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 6985810968622257+wwv_flow_api.g_id_offset,
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6990709330678476 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_DATA_READY_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 6985810968622257+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'File must contain an incident, offense, subject, victim before you can create a specification.  Please enter any missing items and return to this tab.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<b> <font color="#FF0000"> File must contain an incident, offense, subject and victim before you can create a specification. </font> </b>',
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
  p_field_alignment  => 'CENTER',
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
  p_id=>16181028542666076 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 96366819440039996+wwv_flow_api.g_id_offset,
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
  p_id=>16689607065441632 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_SPEC_COUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 96366819440039996+wwv_flow_api.g_id_offset,
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
  p_id=>17208331485522770 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_HOUR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Time Committed',
  p_source=>'select to_char(OFF_COMMITTED_ON, ''hh24'') from T_OSI_F_INV_SPEC where sid = :p11130_sel_specification',
  p_source_type=> 'QUERY',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'HOURS',
  p_lov => '.'||to_char(2668702431512846 + wwv_flow_api.g_id_offset)||'.',
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
  p_id=>17208506336524978 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_MINUTE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 107,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select to_char(OFF_COMMITTED_ON, ''mi'') from T_OSI_F_INV_SPEC where sid = :p11130_sel_specification',
  p_source_type=> 'QUERY',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'MINUTES',
  p_lov => '.'||to_char(2677023537717654 + wwv_flow_api.g_id_offset)||'.',
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
  p_id=>96368230937040003 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_SEL_SPECIFICATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 96366819440039996+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Selected Specification',
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
  p_id=>96368406501040004 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 96366819440039996+wwv_flow_api.g_id_offset,
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
  p_id=>96417835376133270 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFF_LOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Location of Offense',
  p_source=>'OFF_LOC',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select description, sid'||chr(10)||
'  from t_dibrs_offense_location_type'||chr(10)||
' where (active = ''Y'' or sid = :P11130_OFF_LOC)'||chr(10)||
' order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Location of Offense -',
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
  p_id=>96440227280471598 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_INVESTIGATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => ':P0_OBJ',
  p_item_default_type => 'PLSQL_EXPRESSION',
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
  p_id=>96990421050722090 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFF_US_STATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'U.S. State or Possessions',
  p_source=>'OFF_US_STATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_dibrs_state'||chr(10)||
' where (active = ''Y'' or sid = :P11130_OFF_US_STATE)'||chr(10)||
' order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select U.S. State or Possessions -',
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
  p_id=>96990626722733221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFF_COUNTRY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Offense Location Country',
  p_source=>'OFF_COUNTRY',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_dibrs_country'||chr(10)||
' where (active = ''Y'' or sid = :P11130_OFF_COUNTRY)'||chr(10)||
' order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Offense Location Country -',
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
  p_id=>96991108284746792 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFF_RESULT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
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
  p_id=>96991607161765445 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFF_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Offense Result',
  p_source=>'OFF_RESULT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P11130_OFF_RESULT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Offense Result -',
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
  p_id=>96991925992780287 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFF_COMMITTED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Committed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'OFF_COMMITTED_ON',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
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
  p_id=>96992521537807428 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_SEX_HARASSMENT_REL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sexual Harrassment Related',
  p_source=>'SEXUAL_HARASSMENT_RELATED',
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
  p_id=>96995824354836587 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFF_ON_USI',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 165,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'On Uniformed Service Installation',
  p_source=>'OFF_ON_USI',
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
  p_id=>97004618141516964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_NUM_PREM_ENTERED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Number of Premises Entered',
  p_source=>'NUM_PREM_ENTERED',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 5,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P11130_MULTI_ENTRIES_STATE.',
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
  p_id=>97004818619526573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_ENTRY_METHOD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Method of Entry',
  p_source=>'ENTRY_METHOD',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P11130_ENTRY_METHOD_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Method of Entry -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P11130_ENTRY_METHOD_STATE.',
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
  p_id=>97005025891528709 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_ENTRY_METHOD_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
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
  p_id=>97228424902482734 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_OFFENSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 96365821685039982+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OFFENSE',
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
  p_id=>97282307510853689 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_ENTRY_METHOD_STATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 21,
  p_item_plug_id => 96366819440039996+wwv_flow_api.g_id_offset,
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>97282513397855382 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_MULTI_ENTRIES_STATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 22,
  p_item_plug_id => 96366819440039996+wwv_flow_api.g_id_offset,
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>97284618078244667 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_name=>'P11130_WEAPONS_USED_APPLIES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 23,
  p_item_plug_id => 96366819440039996+wwv_flow_api.g_id_offset,
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
 
wwv_flow_api.create_page_computation(
  p_id=> 96432337622446185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11130,
  p_computation_sequence => 10,
  p_computation_item=> 'P11130_SEL_SPECIFICATION',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> ':P0_OBJ_CONTEXT',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11419018149321142 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 10,
  p_validation => 'P11130_OFF_COMMITTED_ON',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':request in (''SAVE'',''CREATE'') and :P11130_OFF_COMMITTED_ON is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 96991925992780287 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6426606087206504 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_validation_name => 'Check ON USI',
  p_validation_sequence=> 20,
  p_validation => 'begin'||chr(10)||
'     if :P11130_OFF_ON_USI=''N'' then'||chr(10)||
'  '||chr(10)||
'       :P11130_SAPRO_LOCATION_CODE:=null;'||chr(10)||
'    '||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P11130_OFF_ON_USI=''Y'' then'||chr(10)||
'  '||chr(10)||
'       :P11130_SAPRO_LOCATION_CODE2:=null;'||chr(10)||
'    '||chr(10)||
'     end if;'||chr(10)||
'     '||chr(10)||
'     if :P11130_OFF_ON_USI in (''U'',''?'') or :P11130_OFF_ON_USI is null then'||chr(10)||
'      '||chr(10)||
'       :P11130_SAPRO_LOCATION_CODE:=null;'||chr(10)||
'       :P11130_SAPRO_LOCATION_CODE2:=null;'||chr(10)||
'       '||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Error',
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
p:=p||'#OWNER#:T_OSI_F_INV_SPEC:P11130_SEL_SPECIFICATION:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 96371222535040020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE,CREATE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P0_OBJ_CONTEXT',
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
'   v_new_date   date;'||chr(10)||
'begin'||chr(10)||
'   v_new_date :='||chr(10)||
' to_date(to_char(to_date(:p11130_off_committed_on,:FMT_DATE) , ''yyyymmdd'') || nvl(:p11130_hour, ''01'')'||chr(10)||
'                || nvl(:p11130_minute, ''00'') || ''00'','||chr(10)||
'                ''yyyymmddhh24miss'');'||chr(10)||
''||chr(10)||
'   update T_OSI_F_INV_SPEC set off_committed_on = v_new_date'||chr(10)||
'     where sid = :p11130_sel_specification;'||chr(10)||
''||chr(10)||
'   commit;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 17211413318631081 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 12,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Date',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Fail on Save Date',
  p_process_when=>':p11130_off_committed_on is not null and :request = ''SAVE''',
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
p:=p||'if :P11130_MULTI_ENTRIES_STATE is not null and'||chr(10)||
'   :P11130_NUM_PREM_ENTERED is not null then'||chr(10)||
'   update t_osi_f_inv_spec'||chr(10)||
'      set num_prem_entered = null'||chr(10)||
'    where sid = :P11130_SEL_SPECIFICATION;'||chr(10)||
'   :P11130_NUM_PREM_ENTERED := null;'||chr(10)||
'end if;'||chr(10)||
'if :P11130_ENTRY_METHOD_STATE is not null and'||chr(10)||
'   :P11130_ENTRY_METHOD is not null then'||chr(10)||
'   update t_osi_f_inv_spec'||chr(10)||
'      set entry_method = null'||chr(10)||
'    where sid =';

p:=p||' :P11130_SEL_SPECIFICATION;'||chr(10)||
'   :P11130_ENTRY_METHOD := null;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 97288017759471654 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear Entry Details',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>96367635209039999 + wwv_flow_api.g_id_offset,
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
p:=p||':P0_OBJ_CONTEXT := substr(:REQUEST, 6);';

wwv_flow_api.create_page_process(
  p_id     => 96956822530729068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Specification',
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
p:=p||'if :REQUEST in (''ADD'',''P11130_OFF_LOC'') then'||chr(10)||
'   :P11130_MODE := ''ADD'';'||chr(10)||
'else'||chr(10)||
'   :P11130_MODE := null;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 96371625883040021 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Mode',
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
p:=p||'11130';

wwv_flow_api.create_page_process(
  p_id     => 97301811263151029 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_PAGES',
  p_process_name=> 'Clear Items',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''CANCEL'',''DELETE'') or :REQUEST like ''EDIT_%''',
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
p:=p||'P0_OBJ_CONTEXT';

wwv_flow_api.create_page_process(
  p_id     => 97302035073176839 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'begin'||chr(10)||
'  if :REQUEST = ''DELETE'' then'||chr(10)||
'     return true;'||chr(10)||
'  elsif :REQUEST like ''TAB_%'' then'||chr(10)||
'     for i in (select 1'||chr(10)||
'                 from t_osi_tab parent,'||chr(10)||
'                      t_osi_tab child'||chr(10)||
'                where child.sid = substr(:REQUEST,5)'||chr(10)||
'                  and parent.sid = child.parent_tab'||chr(10)||
'                  and parent.tab_label = ''Specification'''||chr(10)||
'                  and rownum = 1) loop'||chr(10)||
'        return false;'||chr(10)||
'     end loop;'||chr(10)||
'     return true;'||chr(10)||
'  end if;'||chr(10)||
'  return false;'||chr(10)||
'end;',
  p_process_when_type=>'FUNCTION_BODY',
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
'  v_list varchar2(2000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'     osi_investigation.auto_load_specs(:P0_OBJ, v_list, ''N'');'||chr(10)||
''||chr(10)||
'     :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAGE_ID, '''');'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 16691621834512201 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Auto Load Specs',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>16616722099362629 + wwv_flow_api.g_id_offset,
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
p:=p||'UPDATE T_OSI_F_INV_SPEC SET SAPRO_INCIDENT_LOCATION_CODE=NULL,SAPRO_INCIDENT_LOCATION_CSC=NULL WHERE SID=:P11130_SEL_SPECIFICATION;'||chr(10)||
''||chr(10)||
':P11130_SAPRO_LOCATION_CODE:=NULL;'||chr(10)||
':P11130_INCIDENT_LOCATION:=NULL;'||chr(10)||
':P11130_SAPRO_LOCATION_CODE2:=NULL;'||chr(10)||
':P11130_INCIDENT_LOCATION2:=NULL;';

wwv_flow_api.create_page_process(
  p_id     => 6533325000303101 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 119,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear Incident Location',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'DELETE_LOC',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'declare  '||chr(10)||
'    v_inc_count varchar2(10) := 0;'||chr(10)||
'    v_off_count varchar2(10) := 0;'||chr(10)||
'    v_sub_count varchar2(10) := 0;'||chr(10)||
'    v_vic_count varchar2(10) := 0;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'     select count (*)'||chr(10)||
'       into v_off_count'||chr(10)||
'       from t_osi_f_inv_offense o'||chr(10)||
'      where investigation = :P0_OBJ;'||chr(10)||
''||chr(10)||
'     select count(*)'||chr(10)||
'       into v_inc_count'||chr(10)||
'       from t_osi_f_inv_incident_map'||chr(10)||
'      where investigation = :P0_OBJ;'||chr(10)||
''||chr(10)||
'    ';

p:=p||' select count(*)'||chr(10)||
'       into v_sub_count'||chr(10)||
'       from t_osi_partic_involvement pi, t_osi_partic_role_type prt'||chr(10)||
'      where obj = :P0_OBJ'||chr(10)||
'       and pi.involvement_role = prt.sid'||chr(10)||
'       and prt.role = ''Subject'''||chr(10)||
'       and prt.usage = ''SUBJECT'';'||chr(10)||
''||chr(10)||
'     select count(*)'||chr(10)||
'       into v_vic_count'||chr(10)||
'       from t_osi_partic_involvement pi, t_osi_partic_role_type prt'||chr(10)||
'      where obj = :P0_OBJ'||chr(10)||
'       and pi.invo';

p:=p||'lvement_role = prt.sid'||chr(10)||
'       and prt.role = ''Victim'''||chr(10)||
'       and prt.usage = ''VICTIM'';'||chr(10)||
''||chr(10)||
'    if (v_off_count > 0 and v_inc_count > 0 and v_sub_count > 0 and v_vic_count > 0) then'||chr(10)||
''||chr(10)||
'       :P11130_data_ready := ''Y'';'||chr(10)||
'    else '||chr(10)||
'       :P11130_data_ready := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'wwv_flow.debug(''1-:P11130_SAPRO_LOCATION_CODE='' || :P11130_SAPRO_LOCATION_CODE);'||chr(10)||
'wwv_flow.debug(''2-:P11130_SAPRO_LOCATION_CODE2='' |';

p:=p||'| :P11130_SAPRO_LOCATION_CODE2);'||chr(10)||
''||chr(10)||
'--    :P11130_SAPRO_LOCATION_CODE:=NULL;'||chr(10)||
'--    :P11130_SAPRO_LOCATION_CODE2:=NULL;'||chr(10)||
''||chr(10)||
'--wwv_flow.debug(''3-:P11130_SAPRO_LOCATION_CODE='' || :P11130_SAPRO_LOCATION_CODE);'||chr(10)||
'--wwv_flow.debug(''4-:P11130_SAPRO_LOCATION_CODE2='' || :P11130_SAPRO_LOCATION_CODE2);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6983231653571456 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check_Data',
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
p:=p||'F|#OWNER#:T_OSI_F_INV_SPEC:P11130_SEL_SPECIFICATION:SID';

wwv_flow_api.create_page_process(
  p_id     => 96371006665040018 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P11130_SEL_SPECIFICATION is not null and :REQUEST <> ''P11130_OFF_LOC''',
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
p:=p||':P11130_OFF_RESULT_LOV := dibrs_reference.get_lov(''OFFENSE_RESULT'',:P11130_OFF_RESULT);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'select (case ot.type_entry_method_applies'||chr(10)||
'           when ''Y'' then null'||chr(10)||
'           else :DISABLE_SELECT end),'||chr(10)||
'       ot.type_weapon_used_applies'||chr(10)||
'  into :P11130_ENTRY_METHOD_STATE,'||chr(10)||
'       :P11130_WEAPONS_USED_APPLIES'||chr(10)||
'  from t_dibrs_offense_type ot'||chr(10)||
' where ot.sid = :P11130_OFFENSE;'||chr(10)||
'exception when others the';

p:=p||'n'||chr(10)||
'  :P11130_ENTRY_METHOD_STATE:=NULL;'||chr(10)||
'  :P11130_WEAPONS_USED_APPLIES:=NULL;'||chr(10)||
'end;'||chr(10)||
''||chr(10)||
':P11130_ENTRY_METHOD_LOV := dibrs_reference.get_lov(''ENTRY_METHOD'',:P11130_ENTRY_METHOD);'||chr(10)||
''||chr(10)||
'if :P11130_ENTRY_METHOD_STATE is null then'||chr(10)||
'   :DEBUG := ''entry method state null'';'||chr(10)||
'   if :P11130_OFF_LOC is not null then'||chr(10)||
'      :DEBUG := ''off loc not null'';'||chr(10)||
''||chr(10)||
'      begin'||chr(10)||
'      select (case multi_entries_applies'||chr(10)||
'               ';

p:=p||'  when ''Y'' then null'||chr(10)||
'                 else :DISABLE_TEXT end)'||chr(10)||
'        into :P11130_MULTI_ENTRIES_STATE'||chr(10)||
'        from t_dibrs_offense_location_type'||chr(10)||
'       where sid = :P11130_OFF_LOC;'||chr(10)||
'      exception when others then'||chr(10)||
'        :P11130_MULTI_ENTRIES_STATE:=NULL;'||chr(10)||
'      end;'||chr(10)||
''||chr(10)||
'      :DEBUG := ''multi-entries state:'' || :P11130_MULTI_ENTRIES_STATE;'||chr(10)||
'      if :P11130_MULTI_ENTRIES_STATE is not null then'||chr(10)||
'     ';

p:=p||'    :P11130_NUM_PREM_ENTERED := null;'||chr(10)||
'      end if;'||chr(10)||
'   else'||chr(10)||
'       :P11130_NUM_PREM_ENTERED := null;'||chr(10)||
'       :P11130_MULTI_ENTRIES_STATE := :DISABLE_TEXT;'||chr(10)||
'   end if;'||chr(10)||
'else'||chr(10)||
'   :P11130_ENTRY_METHOD := null;'||chr(10)||
'   :P11130_NUM_PREM_ENTERED := null;'||chr(10)||
'   :P11130_MULTI_ENTRIES_STATE := :DISABLE_TEXT;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
''||chr(10)||
'wwv_flow.debug(''5-:P11130_SAPRO_LOCATION_CODE='' || :P11130_SAPRO_LOCATION_CODE);'||chr(10)||
'wwv_flow.debug(''6-:P';

p:=p||'11130_SAPRO_LOCATION_CODE2='' || :P11130_SAPRO_LOCATION_CODE2);';

wwv_flow_api.create_page_process(
  p_id     => 96991216726758735 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11130,
  p_process_sequence=> 30,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11130_SEL_SPECIFICATION',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 11130
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

