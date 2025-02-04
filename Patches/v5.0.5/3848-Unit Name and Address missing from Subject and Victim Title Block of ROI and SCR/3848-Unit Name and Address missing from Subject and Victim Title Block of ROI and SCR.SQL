set define off;

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
        --load_participants(v_parent_sid);
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

    procedure get_basic_info(
        ppopv            in       varchar2,
        presult          out      varchar2,
        psaa             out      varchar2,
        pper             out      varchar2,
        pincludename     in       boolean := true,
        pnameonly        in       boolean := false,
        pincludemaiden   in       boolean := true,
        pincludeaka      in       boolean := true) is
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
                select pn.first_name || ' ' || last_name
                  into v_temp
                  from t_osi_partic_name pn, t_osi_partic_name_type pnt
                 where pn.name_type = pnt.SID and pn.participant_version = ppopv and pnt.code = 'M';

                if v_temp is not null then
                    v_result := v_result || 'NEE: ' || v_temp || ', ';
                end if;
            end if;

            if pincludeaka = true then
                select pn.first_name || ' ' || last_name
                  into v_temp
                  from t_osi_partic_name pn, t_osi_partic_name_type pnt
                 where pn.name_type = pnt.SID and pn.participant_version = ppopv and pnt.code = 'A';

                if v_temp is not null then
                    v_result := v_result || 'AKA: ' || v_temp || ', ';
                end if;
            end if;

            v_result := rtrim(replace(v_result, '; ', ', '), ', ') || '; ';
        end if;

        if pnameonly = false then
            --- Get Sex, Birthdate, Birth State or Country, Pay Grade ---
            select sex_desc, dob, nvl(pa.state_desc, pa.country_desc), sa_pay_plan_desc,
                   sa_pay_grade_desc, sa_affiliation_code, pv.participant, pv.obj_type_desc
              into v_sex, v_dob, v_pob, v_pp,
                   v_pg, v_saa, v_per, v_pt
              from v_osi_participant_version pv, v_osi_partic_address pa
             where pv.SID = ppopv and pv.current_version = pa.participant_version(+)
                   and pa.type_code(+) = 'BIRTH';

            if v_pt = 'Individual' then
                --- Sex Born:  DOB ---
                v_result :=
                    v_result || nvl(v_sex, 'UNK') || ' Born: '
                    || nvl(to_char(v_dob, v_date_fmt), 'UNK') || '; ';
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
                v_ssn :=
                       substr(v_ssn, 1, 3) || '-' || substr(v_ssn, 4, 2) || '-'
                       || substr(v_ssn, 6, 4);

                if    v_ssn = null
                   or length(v_ssn) = 0
                   or v_ssn = '--' then
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

    function getparticipantname(ppersonversionsid in varchar2, pshortname in boolean := true)
        return varchar2 is
        v_tmp   varchar2(1000) := null;
    begin
        log_error('--->GetParticipantName(' || ppersonversionsid || ')-' || sysdate);

        if pshortname = true then
            /*for s in (select   short
                          from roi_participants_used
                         where person_version = ppersonversionsid
                      order by rowid)
            loop
                v_tmp := s.short;
            end loop; */
            if v_tmp is null then
                v_tmp := '';
            end if;
        else
            for s in (select osi_participant.get_name(pv.SID) as pname, ph.sa_rank as rank,
                             decode(pc.sa_pay_plan,
                                    'GS', 'GS',
                                    'ES', 'ES',
                                    null, '',
                                    substr(pc.sa_pay_plan, 1, 1))
                             || '-' || ltrim(pc.sa_pay_grade, '0') as grade,
                             ph.sa_affiliation as saa, pn.title as title, pv.SID as pvsid
                        from t_osi_participant_version pv,
                             t_osi_participant_human ph,
                             t_osi_person_chars pc,
                             t_osi_partic_name pn
                       where pv.SID = ppersonversionsid
                         and pv.SID = ph.SID
                         and pv.SID = pc.SID
                         and pn.SID = pv.current_name)
            loop
                if s.saa = 'ME' then                                 --- military (or employee) ---
                    v_tmp :=
                        v_tmp || s.pname || ', '
                        || nvl(s.title, nvl(s.rank, 'UNK') || ', ' || nvl(s.grade, 'UNK')) || ', '
                        || nvl(get_org_info(s.pvsid, true), 'UNK');
                else                                         --- civilian or military dependent  ---
                    v_tmp := v_tmp || s.pname;
                --|| ', ' || nvl(osi_participant.get_address_data(s.pvsid, 'CURRENT'), 'UNK');
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
        vtmp := getsubjectofactivity(false);

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
        --load_participants(v_parent_sid);
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

    function roi_block(ppopv in varchar2)
        return varchar2 is
        v_result   varchar2(4000);
        v_temp     varchar2(2000);
        v_saa      varchar2(100);
        v_per      varchar2(20);
    begin
        get_basic_info(ppopv, v_result, v_saa, v_per, true, false, false, false);

        if v_saa = 'ME' then                                         --- military (or employee) ---
            v_result := v_result || nvl(get_org_info(ppopv), 'UNK');
        else                                                 --- civilian or military dependent  ---
            v_temp := null;

            for r in (select   vpr.related_to as that_version,
                               ltrim(vpr.description, 'is ') as rel_type
                          from v_osi_partic_relation vpr, t_osi_partic_relation pr
                         where vpr.this_participant = v_per
                           and vpr.SID = pr.SID
                           and description in('is Spouse of', 'is Child of')
                           and (   pr.end_date is null
                                or pr.end_date > sysdate)
                      order by nvl(pr.start_date, modify_on) desc)
            loop
                get_basic_info(r.that_version, v_temp, v_saa, v_per);
                v_result := v_result || nvl(get_org_info(r.that_version), 'UNK') || ', ';
                exit;                                                     --- only need 1st row ---
            end loop;

            v_result :=
                v_result
                || nvl(osi_address.get_addr_display(osi_address.get_address_sid(ppopv)), 'UNK');
        --CR#2728 || '.';
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
        --load_participants(v_parent_sid);
        --load_agents_assigned(v_parent_sid);
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
        --load_participants(v_parent_sid);
        --load_agents_assigned(v_parent_sid);
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

        --Load_Participants(v_parent_sid);
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

procedure auto_load_specs(p_obj in varchar2) is

         v_list varchar2(2000);
         v_offense varchar2(20);
         v_incident varchar2(20);
         v_subject varchar2(20);
         v_victim varchar2(20);

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

         insert into t_osi_f_inv_spec (investigation, incident, offense, subject, victim) values (p_obj, v_incident, v_offense, v_subject, v_victim);

     end loop; 

end auto_load_specs;
    
end osi_investigation;
/


CREATE OR REPLACE PACKAGE BODY Osi_Participant AS
/******************************************************************************
   name:     osi_participant
   purpose:  provides functionality for participant objects.

   revisions:
    date         author          description
    ----------   --------------  ------------------------------------
     12-may-2009 t.whitehead     Created this package.
     01-jun-2009 t.whitehead     Added create_nonindiv_instance.
     02-jun-2009 t.whitehead     Added Set_Current_Name.
     08-jun-2009 t.whitehead     Added Get_Subtype.
     15-jun-2009 t.whitehead     Added get_address_data, get_birth_city,
                                  get_birth_country, get_birth_state, get_number.
     16-jun-2009 t.whitehead     Added get_confirmation.
     22-jun-2009 t.whitehead     Added set_clearance.
     08-jul-2009 t.whitehead     Added set_current_address.
     20-jul-2009 t.whitehead     Added dob and sex params to create_instance.
     23-jul-2009 t.whitehead     Added p_acronym to create_nonindiv_instance.
     31-jul-2009 t.whitehead     Added get_relation_specifics, get_type_lov.
     10-aug-2009 t.whitehead     Modified get_name to consider versioning.
     11-aug-2009 t.whitehead     Modified the remaining functions that need to
                                 consider versioning.
     14-aug-2009 t.whitehead     Added get/set _address_sid, get_current_version,
                                 get_birth_address_sid methods.
     03-sep-2009 t.whitehead     Added get_subtype_sid, get_mil_member_name.
     04-sep-2009 t.whitehead     Added get_org_member_name.
     17-sep-2009 t.whitehead     Added get_next/previous_version, add/delete_version,
                                 get_participant.
     18-sep-2009 t.whitehead     Added is_confirmed.
     23-sep-2009 t.whitehead     Added get_version_label.
     05-oct-2009 t.whitehead     Added get/set_image_sid.
     09-oct-2009 t.whitehead     Added get_id.
     12-oct-2009 t.whitehead     Added an optional parameter to get_version_label.
     28-oct-2009 t.whitehead     Added has_isn_number.
     03-nov-2009 t.whitehead     Added get_create_menu.
     09-nov-2009 j.faris         Added can_delete.
     13-nov-2009 t.whitehead     Added p_omit_sa to get_details. This parameter is null by default
                                 and will cause the function to return all information about an
                                 individual. If you pass anything in for this parameter then
                                 service affiliation data will not be included in the details.
     11-dec-2009 t.whitehead     Added get_birth_country_code.
     31-dec-2009 t.whitehead     Added run_report_details.
     13-jan-2009 t.whitehead     Added check_writability.
     21-jan-2010 j.faris         Modified get_type_lov a accept an optional type list parameter.
     25-jan-2010 t.whitehead     Added remap_org_names.
     03-feb-2010 t.whitehead     Moved confirm, unconfirm from osi_status_proc.
     04-feb-2010 t.whitehead     Added check_for_matches.
     11-feb-2010 t.whitehead     Added check_for_duplicates.
     16-feb-2010 t.whitehead     Added get_confirm_messages, get_confirm_session. After calling
                                 check_for_duplicates calling get_confirm_messages returns any messages
                                 that would explain why check_for_duplicates returned null and
                                 get_confirm_session returns either null or a session sid.
     17-feb-2010 r.dibble        Added get_inv_type_sid
     19-feb-2010 t.whitehead     Added replace_with.
     21-apr-2010 t.whitehead     Added get_birth_state_code, get_contact_value.
     07-jun-2010 t.mcguffin      Added logging to DEERS query code.
     11-jun-2010 t.whitehead     Added get_rank.
     14-jun-2010 j.horne         Updated get_org_member_name to return sid of organization, changed name to
                                 get_org_member. Added get_org_member_addr.
     11-aug-2010 t.whitehead     Added get_type.
     23-aug-2010 r.dibble        Added import_legacy_participant
                                 Modified check_for_matches to search legacy participants
     25-aug-2010 r.dibble        Added get_legacy_part_details, get_legacy_part_names
     27-aug-2010 r.dibble        Modified import_legacy_participant to handle all versions
                                 Added import_legacy_part_version
     03-sep-2010 r.dibble        Added get_max_allowed_for_role, get_num_part_in_role
     08-sep-2010 t.whitehead     Updated the unconfirm procedure to automatically add a note.
     27-sep-2010 r.dibble        Fixed minor issue with import_legacy_participant() for note category handling
     18-sep-2010 r.dibble        Added these_details_are_editable
     19-Sep-2010 r.dibble        Modified import_legacy_participant to handle new attachments architecture
                                  as well as handle the DETAILS_LOCK functionality.
     11-Nov-2010 j.horne         Updated get_org_member.  Removed join to t_osi_partic_relation and added
                                 v_osi_partic_relation_2way
     24-Nov-2010 Tim Ward        Changed import_legacy_participant to use Global Temporary Tables for
                                  both Notes and Attachments to avoid the ora-22992 error that occurs when
                                  trying to get records with LOBs accross Database Links.
     08-Jan-2011 Tim Ward        Changed check_for_duplicates to not set v_confirm_allowed := 'N' when v_session
                                  is null, causing the function to return 'N' when it shouldn't.
     14-Jan-2011 j.horne         Updated run_report_details so SQL to get relationships used participant SID
                                  and not participant version sid. Updated SQL for images to look at SEQ.
     20-Jan-2011 j.horne         Added procedure reorder_partic_images and partic_image_sort
     24-Jan-2011 Tim Ward        Added Is_Married Function.
     24-Jan-2011 Tim Ward        Changed get_address_date to use V_OSI_PARTIC_ADDRESS and added DISPLAY as a return type.
     15-Feb-2011 Tim Ward        Fixed Is_Married still had a hard coded sid.
     16-Feb-2011 Tim Ward        Fixed import_legacy_participant to use the Legacy Attach_by and Attach_date as the new
                                  Create_by and Create_on.
     24-Feb-2011 j.faris         Fixed the ethnicity mapping in import_legacy_participant.
     24-Feb-2011 j.faris         Added import_legacy_relationships, get_imp_relations_flag, updates
                                 to import_legacy_part_version and import_legacy_participant.
     28-Feb-2011 Tim Ward        Changed CASE k.addr_type to CASE upper(k.addr_type) in import_legacy_participant.
                                  This gets rid of an "ORA-06592" error that was happening when the type returned
                                  was 'Permanent' instead of 'PERMANENT'.
     18-Mar-2011 Tim Ward        CR#3731 - Privilege needs to be checked in here now since the
                                  checkForPriv from i2ms.js deleteObj function.
                                  Changed for loops to select count(*).
                                  Changed in can_delete.
     24-Mar-2011 Tim Ward        CR#3770 - Found DEERS can return N/A for Hair Color and that was imported into Legacy 
                                  I2MS, when trying to import that from Legacy we get an Error:  No Data Found.
                                  Changed import_legacy_part_version.
     28-Mar-2011 Tim Ward        CR#3770 - Found DEERS can return Unknown for Eye Color and that was imported into Legacy 
                                  I2MS, when trying to import that from Legacy we get an Error:  No Data Found.
                                  Changed import_legacy_part_version.
     08-Jun-2011 Tim Ward        CR#3597 - Foreign ID # Saves incorrectly during creation (saves as SSN).
                                  Changed create_instance.
     20-Jun-2011 Tim Ward        CR#3893 - Releationship failing to import because the detailed report was getting
                                  too big.  Don't need/want to show relationship information for units, one was
                                  pulling 200+ relationships and it got too large for the VARCHAR2 and the CLOB.
                                  Changed import_legacy_participant and import_legacy_participant.get_part_rel_info.
     12-Jul-2011 Tim Ward        CR#3859 - DEERS Mugshot not displaying in details report.
                                  Changed in run_report_details.
     14-Jul-2011 Tim Ward        CR#3706 - Notification for Investigatively Closed Activities
                                  Added Latest_Org function.
    01-Nov-2011  Tim Ward       CR#3848 - Unit Name, Address, and MAJCOMM missing from Subject and Victim Title Block of ROI and SCR.
                                 Changed in get_name.
                                  
******************************************************************************/
    c_pipe          VARCHAR2(100)   := Core_Util.get_config('CORE.PIPE_PREFIX')
                                       || 'OSI_PARTICIPANT';
    v_address_sid   T_OSI_PARTIC_ADDRESS.SID%TYPE;
    v_image_sid     T_OSI_ATTACHMENT.SID%TYPE;
    v_messages      VARCHAR2(2000);
    v_session       VARCHAR2(20);

    /*
     * Private functions first.
     */
    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    /*
     * Public functions.
     */
    FUNCTION add_version(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_new_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_old_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_obj           T_OSI_PARTICIPANT.SID%TYPE;
        v_type          T_CORE_OBJ_TYPE.code%TYPE;
        v_sql           VARCHAR2(4000);
        v_table         VARCHAR2(100);
        v_current       VARCHAR2(20);
        v_temp          VARCHAR2(20);

        /*
         * Get the timestamp trigger name for the given table.
         */
        FUNCTION get_ts_trigger_script(p_table_name IN VARCHAR2, p_on_off IN VARCHAR2 := NULL)
            RETURN VARCHAR2 IS
            v_trig   VARCHAR2(256);
            v_rtn    VARCHAR2(300);
        BEGIN
            SELECT trigger_name
              INTO v_trig
              FROM USER_TRIGGERS
             WHERE table_name = p_table_name AND trigger_name LIKE '%_TS';

            SELECT 'alter trigger ' || v_trig || DECODE(p_on_off, NULL, ' disable', ' enable')
              INTO v_rtn
              FROM dual;

            RETURN v_rtn;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN NULL;
            WHEN OTHERS THEN
                log_error('get_ts_trigger_script: ' || SQLERRM);
                RETURN 'get_ts_trigger_script: ' || SQLERRM;
        END get_ts_trigger_script;

        /*
         * This function return a DML string that will copy all the data from a given table for
         * one version (p_old_version) into records for a new version (p_new_version).
         */
        FUNCTION get_duplicate_sql(
            p_table_name    IN   VARCHAR2,
            p_new_version   IN   VARCHAR2,
            p_old_version   IN   VARCHAR2)
            RETURN VARCHAR2 IS
            v_sql       VARCHAR2(4000)
                                     := 'insert into ' || p_table_name || ' (participant_version, ';
            v_rtn       VARCHAR2(4000);
            v_columns   VARCHAR2(4000);
        BEGIN
            FOR i IN (SELECT LOWER(column_name) AS column_name
                        FROM USER_TAB_COLUMNS
                       WHERE table_name = p_table_name
                         AND LOWER(column_name) NOT IN('sid', 'participant_version', 'obj'))
            LOOP
                v_columns := v_columns || i.column_name || ', ';
            END LOOP;

            v_columns := RTRIM(v_columns, ', ');
            v_sql :=
                v_sql || v_columns || ') select ''' || p_new_version || ''', ' || v_columns
                || ' from ' || p_table_name || ' where participant_version = ''' || p_old_version
                || '''';
            v_rtn := v_rtn || v_sql;
            RETURN v_rtn;
        END get_duplicate_sql;
    BEGIN
        v_obj := p_obj;
        -- Get the current version sid.
        v_old_version := get_current_version(v_obj);

        -- Get the new version sid.
        INSERT INTO T_OSI_PARTICIPANT_VERSION
                    (participant)
             VALUES (v_obj)
          RETURNING SID
               INTO v_new_version;

        -- Determine if this is an individual or not.
        SELECT ot.code
          INTO v_type
          FROM T_CORE_OBJ o, T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_obj AND o.obj_type = ot.SID;

        -- Name and Address versioning apply to individuals, organizations and companies.

        -- Names data.
        BEGIN
            v_table := 'T_OSI_PARTIC_NAME';

            -- Get the current name.
            SELECT current_name
              INTO v_current
              FROM T_OSI_PARTICIPANT_VERSION
             WHERE SID = v_old_version;

            -- Disable the timestamp trigger to preserve the original timestamp.
            EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

            -- Copy all the existing names except for the "current" one.
            v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
            v_sql := v_sql || ' and sid <> ''' || v_current || '''';

            EXECUTE IMMEDIATE v_sql;

            -- Now we'll do the "current" name manually.
            FOR x IN (SELECT name_type, title, last_name, first_name, middle_name, cadency,
                             create_by, create_on, modify_by, modify_on
                        FROM T_OSI_PARTIC_NAME
                       WHERE SID = v_current)
            LOOP
                INSERT INTO T_OSI_PARTIC_NAME
                            (participant_version,
                             name_type,
                             title,
                             last_name,
                             first_name,
                             middle_name,
                             cadency,
                             create_by,
                             create_on,
                             modify_by,
                             modify_on)
                     VALUES (v_new_version,
                             x.name_type,
                             x.title,
                             x.last_name,
                             x.first_name,
                             x.middle_name,
                             x.cadency,
                             x.create_by,
                             x.create_on,
                             x.modify_by,
                             x.modify_on)
                  RETURNING SID
                       INTO v_temp;

                -- Update which name is the current name.
                UPDATE T_OSI_PARTICIPANT_VERSION
                   SET current_name = v_temp
                 WHERE SID = v_new_version;
            END LOOP;

            -- Re-enable the timestamp trigger.
            EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
        EXCEPTION
            WHEN OTHERS THEN
                log_error('add_version: Error versioning name data: ' || SQLERRM);

                -- There was a problem so re-enable the trigger.
                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                RAISE;
        END;

        -- Address data.
        BEGIN
            -- Get the current address.
            SELECT current_address
              INTO v_current
              FROM T_OSI_PARTICIPANT_VERSION
             WHERE SID = v_old_version;

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

            -- Here we'll duplicate the records manually.
            FOR x IN (SELECT SID, obj, address_type, address_1, address_2, city, province, state,
                             postal_code, country, geo_coords, start_date, end_date, known_date,
                             comments, create_by, create_on, modify_by, modify_on
                        FROM T_OSI_ADDRESS
                       WHERE obj = v_obj)
            LOOP
                INSERT INTO T_OSI_ADDRESS
                            (obj,
                             address_type,
                             address_1,
                             address_2,
                             city,
                             province,
                             state,
                             postal_code,
                             country,
                             geo_coords,
                             start_date,
                             end_date,
                             known_date,
                             comments,
                             create_by,
                             create_on,
                             modify_by,
                             modify_on)
                     VALUES (x.obj,
                             x.address_type,
                             x.address_1,
                             x.address_2,
                             x.city,
                             x.province,
                             x.state,
                             x.postal_code,
                             x.country,
                             x.geo_coords,
                             x.start_date,
                             x.end_date,
                             x.known_date,
                             x.comments,
                             x.create_by,
                             x.create_on,
                             x.modify_by,
                             x.modify_on)
                  RETURNING SID
                       INTO v_temp;

                -- Add corresponding records to the participant address table.
                INSERT INTO T_OSI_PARTIC_ADDRESS
                            (participant_version, address)
                     VALUES (v_new_version, v_temp);

                IF (x.SID = v_current) THEN
                    -- Update the "current" address.
                    UPDATE T_OSI_PARTICIPANT_VERSION
                       SET current_address = v_temp
                     WHERE SID = v_new_version;
                END IF;
            END LOOP;

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
        EXCEPTION
            WHEN OTHERS THEN
                log_error('add_version: Error versioning address data: ' || SQLERRM);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                RAISE;
        END;

        -- Vehicle data.
        BEGIN
            v_table := 'T_OSI_PARTIC_VEHICLE';

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

            v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);

            EXECUTE IMMEDIATE v_sql;

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
        EXCEPTION
            WHEN OTHERS THEN
                log_error('add_version: Error versioning vehicle data: ' || SQLERRM);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                RAISE;
        END;

        -- Specifics/Organization Attributes apply only to organizations.
        IF (v_type = 'PART.NONINDIV.ORG') THEN
            BEGIN
                v_table := 'T_OSI_PARTIC_ORG_ATTR';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error
                           ('add_version: Error versioning other organization attributes data: '
                            || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;
        END IF;

        -- Company and Organization specific data.
        IF (v_type IN('PART.NONINDIV.COMP', 'PART.NONINDIV.ORG')) THEN
            BEGIN
                v_table := 'T_OSI_PARTICIPANT_NONHUMAN';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
                v_sql := REPLACE(v_sql, 'participant_version', 'sid');

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning non-individual data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;
        END IF;

        -- Everything below applies only to individuals.
        IF (v_type = 'PART.INDIV') THEN
            -- Other Dates data.
            BEGIN
                v_table := 'T_OSI_PARTIC_DATE';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning other dates data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Citizenships data.
            BEGIN
                v_table := 'T_OSI_PARTIC_CITIZENSHIP';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning citizenship data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Identifying Numbers data.
            BEGIN
                v_table := 'T_OSI_PARTIC_NUMBER';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning identifying numbers data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Individual data.
            BEGIN
                v_table := 'T_OSI_PARTICIPANT_HUMAN';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
                v_sql := REPLACE(v_sql, 'participant_version', 'sid');

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning individual data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- More individual data.
            BEGIN
                v_table := 'T_OSI_PERSON_CHARS';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
                v_sql := REPLACE(v_sql, 'participant_version', 'sid');

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning person chars data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Special marks data.
            BEGIN
                v_table := 'T_OSI_PARTIC_MARK';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning special marks data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Contact data.
            BEGIN
                v_table := 'T_OSI_PARTIC_CONTACT';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning contact data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;
        END IF;

        -- Set the new version as the current version.
        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_new_version
         WHERE SID = v_obj;

        RETURN v_new_version;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('add_version: ' || SQLERRM);
            RAISE;
    END add_version;

    FUNCTION delete_version(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_result    VARCHAR2(1)                          := 'Y';
        v_current   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
        v_current := get_previous_version(p_version);

        IF (v_current IS NULL) THEN
            v_result := 'N';
        ELSE
            UPDATE T_OSI_PARTICIPANT
               SET current_version = v_current
             WHERE SID = get_participant(p_version);

            DELETE FROM T_OSI_PARTICIPANT_VERSION
                  WHERE SID = p_version;
        END IF;

        RETURN v_result;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('delete_version: ' || SQLERRM);
            RETURN 'delete_version: ' || SQLERRM;
    END delete_version;

    FUNCTION can_delete(p_obj IN VARCHAR2) RETURN VARCHAR2 IS
         
         v_count_check number;
         
    BEGIN
         if osi_auth.check_for_priv('DELETE',Core_Obj.get_objtype(p_obj))='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;

         ---Does this person have associations (files or activities)?---
         select count(*) into v_count_check FROM T_OSI_PARTIC_INVOLVEMENT pi, T_OSI_PARTICIPANT_VERSION pv WHERE pi.participant_version = pv.SID AND pv.participant = p_obj;
         if v_count_check > 0 then

           RETURN 'You cannot delete a participant used in a file or activity.';

         end if;

         ---Does this person have relationships?---
         select count(*) into v_count_check FROM T_OSI_PARTIC_RELATION pr WHERE pr.partic_a = p_obj OR pr.partic_b = p_obj;
         if v_count_check > 0 then

           RETURN 'You cannot delete a participant with an existing relationship.';

         end if;

         RETURN 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.Can_Delete: Error encountered using Object ' || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in OSI_PARTICIPANT.Can_Delete using Object: ' || NVL(p_obj, 'NULL');

    END can_delete;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF (   p_version IS NULL
            OR p_version = get_current_version(p_obj)) THEN
            RETURN 'Y';
        ELSE
            RETURN 'N';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('check_writability: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION create_instance(
        p_lname     IN   VARCHAR2 := NULL,
        p_fname     IN   VARCHAR2 := NULL,
        p_ssn       IN   VARCHAR2 := NULL,
        p_dob       IN   DATE := NULL,
        p_sex       IN   VARCHAR2 := NULL,
        p_unknown   IN   VARCHAR2 := 'Y',
        p_num_type  IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_sid         T_CORE_OBJ.SID%TYPE;
        v_obj_type    T_CORE_OBJ_TYPE.SID%TYPE;
        v_par_type    T_OSI_REFERENCE.SID%TYPE;
        v_num_type    T_OSI_REFERENCE.SID%TYPE;
        v_ssn         T_OSI_PARTIC_NUMBER.num_value%TYPE;
        v_name_type   T_OSI_PARTIC_NAME_TYPE.SID%TYPE;
        v_fname       T_OSI_PARTIC_NAME.first_name%TYPE;
        v_lname       T_OSI_PARTIC_NAME.last_name%TYPE;
        v_version     T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_cur_name    T_OSI_PARTIC_NAME.SID%TYPE;

        /*
        * The first name for an unknown participant is UNIT_CODE-YEAR-NUMBER.
        * Example: 106-2009-0001
        * The last four digits start at one and are incremented by one. Each year the
        * sequence starts over.
        */
        FUNCTION get_unknown_number
            RETURN VARCHAR2 IS
            v_max    T_OSI_PARTIC_NAME.first_name%TYPE;
            v_rtn    T_OSI_PARTIC_NAME.first_name%TYPE;
            v_temp   T_OSI_PARTIC_NAME.first_name%TYPE;
        BEGIN
            v_temp :=
                Osi_Unit.get_code(Osi_Personnel.get_current_unit()) || '-'
                || TO_CHAR(SYSDATE, 'YYYY');

            SELECT MAX(first_name)
              INTO v_max
              FROM T_OSI_PARTIC_NAME
             WHERE first_name LIKE v_temp || '%';

            IF (v_max IS NULL) THEN
                v_max := 0;
            ELSE
                v_max := SUBSTR(v_max, INSTR(v_max, '-', 1, 2) + 1);
            END IF;

            v_rtn := v_temp || '-' || trim(TO_CHAR(v_max + 1, '0000'));
            RETURN v_rtn;
        END get_unknown_number;
    BEGIN
        v_obj_type := Core_Obj.lookup_objtype('PART.INDIV');

        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (v_obj_type)
          RETURNING SID
               INTO v_sid;

        INSERT INTO T_OSI_PARTICIPANT
                    (SID, unknown_flag, dob)
             VALUES (v_sid, p_unknown, p_dob);

        INSERT INTO T_OSI_PARTICIPANT_VERSION
                    (participant)
             VALUES (v_sid)
          RETURNING SID
               INTO v_version;

        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_version
         WHERE SID = v_sid;

        INSERT INTO T_OSI_PARTICIPANT_HUMAN
                    (SID)
             VALUES (v_version);

        INSERT INTO T_OSI_PERSON_CHARS
                    (SID, sex)
             VALUES (v_version, p_sex);

        SELECT n.SID
          INTO v_name_type
          FROM T_OSI_PARTIC_NAME_TYPE_MAP m, T_OSI_PARTIC_NAME_TYPE n
         WHERE m.participant_type = Osi_Reference.lookup_ref_sid('PART.INDIV', 'PI')
           AND m.name_type = n.SID
           AND n.code = 'L'
           AND m.active = 'Y';

        IF (p_unknown = 'Y') THEN
            v_lname := 'UNKNOWN';
            v_fname := get_unknown_number;
            v_ssn := NULL;
        ELSE
            v_lname := p_lname;
            v_fname := p_fname;
            v_ssn := p_ssn;
        END IF;

        INSERT INTO T_OSI_PARTIC_NAME
                    (participant_version, name_type, last_name, first_name)
             VALUES (v_version, v_name_type, v_lname, v_fname)
          RETURNING SID
               INTO v_cur_name;

        UPDATE T_OSI_PARTICIPANT_VERSION
           SET current_name = v_cur_name
         WHERE SID = v_version;

        IF (p_ssn IS NOT NULL) THEN
          
          IF (p_num_type is null) THEN

            SELECT SID
              INTO v_num_type
              FROM T_OSI_PARTIC_NUMBER_TYPE
             WHERE CODE='SSN';

          ELSE

            v_num_type := p_num_type;

          END IF;
         
            INSERT INTO T_OSI_PARTIC_NUMBER
                        (participant_version, num_type, num_value)
                 VALUES (v_version, v_num_type, v_ssn);
        END IF;

        Osi_Status.change_status_brute(v_sid, Osi_Status.get_starting_status(v_obj_type), 'Created');
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_instance: ' || SQLERRM);
            RAISE;
    END create_instance;

    FUNCTION create_nonindiv_instance(
        p_obj_type_sid   IN   VARCHAR2,
        p_sub_type       IN   VARCHAR2,
        p_name_type      IN   VARCHAR2,
        p_name           IN   VARCHAR2,
        p_acronym        IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_sid        T_CORE_OBJ.SID%TYPE;
        v_version    T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_cur_name   T_OSI_PARTIC_NAME.SID%TYPE;
    BEGIN
        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (p_obj_type_sid)
          RETURNING SID
               INTO v_sid;

        INSERT INTO T_OSI_PARTICIPANT
                    (SID)
             VALUES (v_sid);

        INSERT INTO T_OSI_PARTICIPANT_VERSION
                    (participant)
             VALUES (v_sid)
          RETURNING SID
               INTO v_version;

        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_version
         WHERE SID = v_sid;

        INSERT INTO T_OSI_PARTICIPANT_NONHUMAN
                    (SID, sub_type)
             VALUES (v_version, p_sub_type);

        INSERT INTO T_OSI_PARTIC_NAME
                    (participant_version, name_type, last_name, first_name)
             VALUES (v_version, p_name_type, p_name, p_acronym)
          RETURNING SID
               INTO v_cur_name;

        UPDATE T_OSI_PARTICIPANT_VERSION
           SET current_name = v_cur_name
         WHERE SID = v_version;

        Osi_Status.change_status_brute(v_sid,
                                       Osi_Status.get_starting_status(p_obj_type_sid),
                                       'Created');
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_nonindiv_instance: ' || SQLERRM);
            RAISE;
    END create_nonindiv_instance;

    FUNCTION is_confirmed(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_yn   VARCHAR2(1);
    BEGIN
        SELECT DECODE(confirm_by, NULL, NULL, 'Y')
          INTO v_yn
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        RETURN v_yn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('is_confirmed: ' || SQLERRM);
            RETURN 'is_confirmed: ' || SQLERRM;
    END is_confirmed;

    FUNCTION get_address_data(
        p_pvop           IN   VARCHAR2,
        p_address_code   IN   VARCHAR2,
        p_address_item   IN   VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT * FROM V_OSI_PARTIC_ADDRESS
                   WHERE (participant_version = p_pvop or participant_version = osi_participant.get_current_version(p_pvop))
                     and type_code=p_address_code
                   order by modify_on desc)
        LOOP
            CASE UPPER(p_address_item)
                WHEN 'SID' THEN
                    RETURN x.SID;
                WHEN 'ADDRESS1' THEN
                    RETURN x.address_1;
                WHEN 'ADDRESS2' THEN
                    RETURN x.address_2;
                WHEN 'ADDRESS' THEN
                    RETURN x.address_1 || CHR(10) || CHR(13) || x.address_2;
                WHEN 'CITY' THEN
                    RETURN x.city;
                WHEN 'PROVINCE' THEN
                    RETURN x.province;
                WHEN 'STATE' THEN
                    RETURN x.state_desc;
                WHEN 'STATE_CODE' THEN
                    RETURN x.state_code;
                WHEN 'ZIP' THEN
                    RETURN x.postal_code;
                WHEN 'POSTAL_CODE' THEN
                    RETURN x.postal_code;
                WHEN 'COUNTRY' THEN
                    RETURN x.country_desc;
                WHEN 'COUNTRY_CODE' THEN
                    RETURN x.country_code;
                WHEN 'GEO_COORDS' THEN
                    RETURN x.geo_coords;
                WHEN 'DISPLAY' THEN
                    IF SUBSTR(UPPER(p_address_code),-3) = '_ML' THEN
                      RETURN( x.display_string );
                    ELSIF SUBSTR(UPPER(p_address_code),-4) = '_SCO' THEN
                         RETURN( NVL(x.state_desc, x.country_desc) );
                    ELSE
                      RETURN( x.single_line );
                    END IF;
            END CASE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_address_data: ' || SQLERRM);
            RETURN 'get_address_data: ' || SQLERRM;
    END get_address_data;

    FUNCTION get_address_sid
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_address_sid;
    END get_address_sid;

    FUNCTION get_birth_address_sid(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'SID');
    END get_birth_address_sid;

    FUNCTION get_birth_city(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'CITY');
    END get_birth_city;

    FUNCTION get_birth_country(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'COUNTRY');
    END get_birth_country;

    FUNCTION get_birth_country_code(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'COUNTRY_CODE');
    END get_birth_country_code;

    FUNCTION get_birth_state(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'STATE');
    END get_birth_state;

    FUNCTION get_birth_state_code(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'STATE_CODE');
    END get_birth_state_code;

    FUNCTION get_confirm_messages
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_messages;
    END get_confirm_messages;

    FUNCTION get_confirm_session
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_session;
    END get_confirm_session;

    FUNCTION get_confirmation(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_confirmed   T_OSI_PARTICIPANT.confirm_by%TYPE;
    BEGIN
        SELECT DECODE(confirm_by, NULL, 'Not Confirmed', 'Confirmed')
          INTO v_confirmed
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        RETURN v_confirmed;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_confirmation: ' || SQLERRM);
            RETURN 'get_confirmation: ' || SQLERRM;
    END get_confirmation;

    FUNCTION get_contact_value(p_pvop IN VARCHAR2, p_type IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT VALUE
                    FROM v_osi_participant_version pv, T_OSI_PARTIC_CONTACT pc
                   WHERE (   pv.SID = p_pvop
                          OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                     AND pc.participant_version = pv.SID
                     AND pc.TYPE = Osi_Reference.lookup_ref_sid('CONTACT_TYPE', p_type))
        LOOP
            RETURN x.VALUE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_contact_value: ' || SQLERRM);
            RETURN 'get_contact_value: ' || SQLERRM;
    END get_contact_value;

    FUNCTION get_create_menu(p_icon IN VARCHAR2, p_page_item IN VARCHAR2, p_type_list IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_array      apex_application_global.vc_arr2;
        v_rtn        VARCHAR2(4000);
        v_id         VARCHAR2(10);
        v_page_num   NUMBER;
    BEGIN
        v_array := apex_util.string_to_table(p_type_list, '~');
        v_id := dbms_random.string('U', 10);
        v_rtn := '<a href="javascript:showHide(''' || v_id || ''');">' || p_icon || '</a>';
        v_rtn := v_rtn || '<div id="' || v_id || '" style="display:none;position:absolute;">';
        v_rtn := v_rtn || '<ul class="expandButton">';

        FOR x IN 1 .. v_array.COUNT
        LOOP
            FOR y IN (SELECT description
                        FROM T_CORE_OBJ_TYPE
                       WHERE code = UPPER(v_array(x)))
            LOOP
                IF (v_array(x) = 'PART.INDIV') THEN
                    v_rtn :=
                        v_rtn
                        || '<li class="expandedItem1"><a href="javascript:createObject(30000,''';
                    v_rtn := v_rtn || v_array(x) || ''', ''P30000_RETURN_ITEM,P30000_MODE'', ''';
                ELSE
                    v_rtn :=
                        v_rtn
                        || '<li class="expandedItem1"><a href="javascript:createObject(30100,''';
                    v_rtn := v_rtn || v_array(x) || ''', ''P30100_RETURN_ITEM,P30100_MODE'', ''';
                END IF;

                v_rtn := v_rtn || p_page_item || ',FROM_OBJ'');"';
                v_rtn := v_rtn || ' class="expandedLink">' || y.description || '</a></li>';
            END LOOP;
        END LOOP;

        RETURN v_rtn || '</ul>';
    END get_create_menu;

    FUNCTION get_current_version(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT current_version
                    FROM T_OSI_PARTICIPANT
                   WHERE SID = p_obj)
        LOOP
            RETURN x.current_version;
        END LOOP;

        RETURN NULL;
    END get_current_version;

    FUNCTION get_date(p_pvop IN VARCHAR2, p_code IN VARCHAR2)
        RETURN DATE IS
    BEGIN
        FOR x IN (SELECT   d.VALUE
                      FROM T_OSI_PARTIC_DATE d, v_osi_participant_version pv, T_OSI_REFERENCE r
                     WHERE (   pv.SID = p_pvop
                            OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                       AND d.participant_version = pv.SID
                       AND d.TYPE = r.SID
                       AND (   r.USAGE = 'INDIV_DATE'
                            OR r.USAGE = 'NON_INDIV_DATE')
                       AND r.code = p_code
                  ORDER BY d.modify_on DESC)
        LOOP
            RETURN x.VALUE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_date: ' || SQLERRM);
            RETURN 'get_date: ' || SQLERRM;
    END get_date;

    FUNCTION get_details(
        p_pvop          IN   VARCHAR2,
        p_omit_sa       IN   VARCHAR2 := NULL,
        p_for_confirm   IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn       VARCHAR2(4000);
        v_objtype   T_CORE_OBJ_TYPE.SID%TYPE;

        FUNCTION row_start
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<TR>';
        END row_start;

        FUNCTION row_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TR>';
        END row_end;

        FUNCTION new_row(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN row_start || p_text || row_end;
        END new_row;

        FUNCTION cell_start(p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
            v_rtn   VARCHAR2(500) := '<TD vAlign="top" ';
        BEGIN
            IF (p_col_span > 0) THEN
                v_rtn := v_rtn || 'colSpan="' || p_col_span || '" ';
            END IF;

            IF (p_row_span > 0) THEN
                v_rtn := v_rtn || 'rowSpan="' || p_row_span || '" ';
            END IF;

            RETURN v_rtn || '>';
        END cell_start;

        FUNCTION cell_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TD>';
        END cell_end;

        FUNCTION new_cell(p_text IN VARCHAR2, p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN cell_start(p_col_span, p_row_span) || p_text || cell_end;
        END new_cell;

        FUNCTION make_label(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<LABEL class="optionallabel"><SPAN>' || p_text || '</SPAN></LABEL>';
        END make_label;

        FUNCTION get_indiv_details(p_pvop IN VARCHAR2)
            RETURN VARCHAR2 IS
            v_name                    v_osi_participant_indiv_title.NAME%TYPE;
            v_sex                     v_osi_participant_indiv_title.sex%TYPE;
            v_service                 v_osi_participant_indiv_title.service%TYPE;
            v_address                 v_osi_participant_indiv_title.address%TYPE;
            v_dob                     v_osi_participant_indiv_title.dob%TYPE;
            v_affiliation             v_osi_participant_indiv_title.affiliation%TYPE;
            v_race                    v_osi_participant_indiv_title.race%TYPE;
            v_component               v_osi_participant_indiv_title.component%TYPE;
            v_ssn                     v_osi_participant_indiv_title.ssn%TYPE;
            v_pay_plan                v_osi_participant_indiv_title.pay_plan%TYPE;
            v_confirmed               v_osi_participant_indiv_title.confirmed%TYPE;
            v_pay_grade               v_osi_participant_indiv_title.pay_grade%TYPE;
            v_rank                    v_osi_participant_indiv_title.rank%TYPE;
            v_rank_date               v_osi_participant_indiv_title.rank_date%TYPE;
            v_specialty_code          v_osi_participant_indiv_title.specialty_code%TYPE;
            v_military_organization   v_osi_participant_indiv_title.military_organization%TYPE;
            v_format                  VARCHAR2(11);
        BEGIN
            IF (p_pvop IS NOT NULL) THEN
                SELECT pi.NAME, pi.sex, pi.service, pi.address, pi.dob, pi.affiliation, pi.race,
                       pi.component, pi.ssn, pi.pay_plan, pi.confirmed, pi.pay_grade, pi.rank,
                       pi.rank_date, pi.specialty_code, pi.military_organization
                  INTO v_name, v_sex, v_service, v_address, v_dob, v_affiliation, v_race,
                       v_component, v_ssn, v_pay_plan, v_confirmed, v_pay_grade, v_rank,
                       v_rank_date, v_specialty_code, v_military_organization
                  FROM v_osi_participant_indiv_title pi
                 WHERE pi.SID = p_pvop
                    OR (pi.participant = p_pvop AND pi.SID = pi.current_version);

                v_format := Core_Util.get_config('CORE.DATE_FMT_DAY');
            END IF;

            v_rtn := '<TABLE class="formlayout" width="100%" border="0"><TBODY>';
            v_rtn := v_rtn || '<colgroup span="3" align="left" width="33%"></colgroup>';
            v_rtn := v_rtn || row_start || new_cell('Name: ' || v_name);
            v_rtn := v_rtn || new_cell('Sex: ' || v_sex);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Service: ' || v_service);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address, 0, 8);
            v_rtn := v_rtn || new_cell('Date of Birth: ' || TO_CHAR(v_dob, v_format));

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Affiliation: ' || v_affiliation);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Race: ' || v_race);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Component: ' || v_component);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('SSN: ' || v_ssn);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Plan: ' || v_pay_plan);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Grade: ' || v_pay_grade);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank: ' || v_rank);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank Date: ' || TO_CHAR(v_rank_date, v_format));
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Specialty: ' || v_specialty_code);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Military Organization: ' || v_military_organization);
            END IF;

            v_rtn := v_rtn || row_end || '</TBODY></TABLE>';
            RETURN v_rtn;
        END get_indiv_details;

        FUNCTION get_nonindiv_details(p_pvop IN VARCHAR2)
            RETURN VARCHAR2 IS
            v_name        VARCHAR2(100);
            v_confirmed   VARCHAR2(20);
            v_subtype     VARCHAR2(100);
            v_address     VARCHAR2(4000);
            v_acronym     v_osi_participant_version.current_name%TYPE;
            v_cage        v_osi_participant_version.co_cage%TYPE;
            v_uic         v_osi_participant_version.org_uic%TYPE;
        BEGIN
            v_name := get_name(p_pvop);
            v_confirmed := get_confirmation(p_pvop);
            v_subtype := get_subtype(p_pvop);

            SELECT co_cage, org_uic, Osi_Address.get_addr_display(current_address, NULL, '<br>'),
                   current_name
              INTO v_cage, v_uic, v_address,
                   v_acronym
              FROM v_osi_participant_version
             WHERE SID = p_pvop
                OR (SID = current_version AND participant = p_pvop);

            v_rtn := '<TABLE class="formlayout" width="100%" border="0"><TBODY>';
            v_rtn := v_rtn || '<colgroup span="3" align="left" width="33%"></colgroup>';

            CASE v_objtype
                WHEN Core_Obj.lookup_objtype('PART.NONINDIV.PROG') THEN
                    v_rtn := v_rtn || row_start || new_cell('Program: ' || v_name) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

                    IF (p_for_confirm IS NOT NULL) THEN
                        BEGIN
                            SELECT first_name
                              INTO v_name
                              FROM v_osi_partic_name
                             WHERE SID = v_acronym;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                v_name := NULL;
                        END;

                        v_rtn := v_rtn || row_start || new_cell('Acronym: ' || v_name);
                        v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address);
                    END IF;

                    v_rtn := v_rtn || row_end;
                WHEN Core_Obj.lookup_objtype('PART.NONINDIV.ORG') THEN
                    v_rtn := v_rtn || row_start || new_cell('Organization: ' || v_name, 0, 3);
                    v_rtn := v_rtn || new_cell('Subtype: ' || v_subtype) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('UIC/PAS: ' || v_uic) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

                    IF (p_for_confirm IS NOT NULL) THEN
                        v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address);
                    END IF;

                    v_rtn := v_rtn || row_end;
                WHEN Core_Obj.lookup_objtype('PART.NONINDIV.COMP') THEN
                    v_rtn := v_rtn || row_start || new_cell('Company: ' || v_name, 0, 3);
                    v_rtn := v_rtn || new_cell('Subtype: ' || v_subtype) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Cage Code: ' || v_cage) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

                    IF (p_for_confirm IS NOT NULL) THEN
                        v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address);
                    END IF;

                    v_rtn := v_rtn || row_end;
            END CASE;

            v_rtn := v_rtn || '</TBODY></TABLE>';
            RETURN v_rtn;
        END get_nonindiv_details;
    BEGIN
        IF (p_pvop IS NOT NULL) THEN
            v_objtype := get_type_sid(p_pvop);

            IF (v_objtype = Core_Obj.lookup_objtype('PART.INDIV')) THEN
                RETURN get_indiv_details(p_pvop);
            ELSE
                RETURN get_nonindiv_details(p_pvop);
            END IF;
        END IF;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_details: ' || SQLERRM);
            RETURN 'get_details: ' || SQLERRM;
    END get_details;

    FUNCTION get_id(p_obj IN VARCHAR2, p_obj_context VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF (p_obj_context IS NULL) THEN
            RETURN get_version_label(get_current_version(p_obj), 1);
        ELSE
            RETURN get_version_label(p_obj_context, 1);
        END IF;
    END get_id;

    FUNCTION get_image_sid
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_image_sid;
    END get_image_sid;

    FUNCTION get_mil_member_name(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        BEGIN
            FOR x IN (SELECT   pr.partic_b
                          FROM T_OSI_PARTIC_RELATION pr, v_osi_participant_version pv
                         WHERE (   pv.SID = p_pvop
                                OR (pv.participant = p_pvop AND pv.SID = current_version))
                           AND pr.partic_a = pv.participant
                           AND pr.end_date IS NULL
                           AND Osi_Participant.get_subtype_sid(pr.partic_b) =
                                           Osi_Reference.lookup_ref_sid('PART.NONINDIV.ORG', 'POUM')
                      ORDER BY pr.start_date DESC)
            LOOP
                v_rtn := get_name(x.partic_b);
                EXIT;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rtn := NULL;
        END;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_mil_member_name: ' || SQLERRM);
            RETURN 'get_mil_member_name: ' || SQLERRM;
    END get_mil_member_name;

    FUNCTION get_name(p_pvop IN VARCHAR2) RETURN VARCHAR2 IS

         v_individual T_CORE_OBJ_TYPE.SID%TYPE;

    BEGIN
         v_individual := Core_Obj.lookup_objtype('PART.INDIV');

         FOR x IN (SELECT /*+FIRST_ROWS*/ DECODE(pv.obj_type, v_individual, RTRIM(LTRIM(PN.FIRST_NAME || DECODE(PN.MIDDLE_NAME, NULL, '', ' ' || PN.MIDDLE_NAME) || DECODE(PN.LAST_NAME, NULL, '', ' ' || PN.LAST_NAME))),
                                                                            PN.LAST_NAME || DECODE(PV.ORG_MAJCOM_CODE, NULL, '', ' (' || PV.ORG_MAJCOM_CODE || ')')) as name         
                     FROM T_OSI_PARTIC_NAME pn, v_osi_participant_version pv
                    WHERE (pv.SID = p_pvop OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                      AND (pn.SID = pv.current_name))

         LOOP
             RETURN x.NAME;
         END LOOP;

         RETURN NULL;
    EXCEPTION
         WHEN OTHERS THEN
             log_error('get_name: ' || SQLERRM);
             RETURN 'get_name: ' || SQLERRM;
    END get_name;

    FUNCTION get_name_type(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT t.description
                    FROM v_osi_participant_version pv,
                         T_OSI_PARTIC_NAME pn,
                         T_OSI_PARTIC_NAME_TYPE t
                   WHERE (   pv.SID = p_pvop
                          OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                     AND pn.SID = pv.current_name
                     AND pn.name_type = t.SID)
        LOOP
            RETURN x.description;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_name_type: ' || SQLERRM);
            RETURN 'get_name_type: ' || SQLERRM;
    END get_name_type;

    FUNCTION get_next_version(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_partic    T_OSI_PARTICIPANT.SID%TYPE;
        v_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
        v_partic := get_participant(p_version);

        IF (v_partic IS NULL) THEN
            -- An invalid version sid was given.
            log_error('get_next_version: Unknown version given.');
            RETURN NULL;
        END IF;

        SELECT SID
          INTO v_version
          FROM (SELECT   SID
                    FROM T_OSI_PARTICIPANT_VERSION
                   WHERE participant = v_partic AND SID > p_version
                ORDER BY SID ASC)
         WHERE ROWNUM = 1;

        RETURN v_version;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('get_next_version: ' || SQLERRM);
            RETURN 'get_next_version: ' || SQLERRM;
    END get_next_version;

    FUNCTION get_previous_version(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_partic    T_OSI_PARTICIPANT.SID%TYPE;
        v_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
        v_partic := get_participant(p_version);

        IF (v_partic IS NULL) THEN
            -- An invalid version sid was given.
            log_error('get_previous_version: Unknown version given.');
            RETURN NULL;
        END IF;

        SELECT SID
          INTO v_version
          FROM (SELECT   SID
                    FROM T_OSI_PARTICIPANT_VERSION
                   WHERE participant = v_partic AND SID < p_version
                ORDER BY SID DESC)
         WHERE ROWNUM = 1;

        RETURN v_version;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('get_previous_version: ' || SQLERRM);
            RETURN 'get_previous_version: ' || SQLERRM;
    END get_previous_version;

    FUNCTION get_number(p_pvop IN VARCHAR2, p_code IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_obj_code   T_CORE_OBJ_TYPE.code%TYPE;
    BEGIN
        SELECT code
          INTO v_obj_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = get_type_sid(p_pvop);

        IF (v_obj_code = 'PART.INDIV') THEN
            FOR x IN (SELECT pn.num_value
                        FROM T_OSI_PARTIC_NUMBER pn,
                             T_OSI_PARTIC_NUMBER_TYPE nt,
                             v_osi_participant_version pv
                       WHERE (   pv.SID = p_pvop
                              OR (pv.participant = p_pvop AND pv.SID = current_version))
                         AND pn.participant_version = pv.SID
                         AND pn.num_type = nt.SID
                         AND nt.code = p_code)
            LOOP
                RETURN x.num_value;
            END LOOP;
        ELSE
            FOR x IN (SELECT DECODE(v_obj_code,
                                    'PART.NONINDIV.COMP', co_cage,
                                    'PART.NONINDIV.ORG', org_uic) AS num_value
                        FROM v_osi_participant_version
                       WHERE SID = p_pvop
                          OR (participant = p_pvop AND SID = current_version))
            LOOP
                RETURN x.num_value;
            END LOOP;
        END IF;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_number: ' || SQLERRM);
            RETURN 'get_number: ' || SQLERRM;
    END get_number;

    FUNCTION get_org_member(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        BEGIN
            FOR x IN (SELECT   /*pr.THAT_PARTIC as sid--*/pr.SID
                          FROM v_osi_partic_relation_2way pr,
                               v_osi_participant_version pv,
                               T_OSI_PARTIC_RELATION_TYPE rt
                         WHERE (   pv.SID = p_pvop
                                OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                           AND pr.this_partic = pv.participant
                           AND (   pr.end_date IS NULL
                                OR pr.end_date > SYSDATE)
                           AND pr.rel_type = rt.SID
                           AND rt.code IN('IMOU', 'HUM', 'IMO', 'HM')
                      ORDER BY NVL(pr.start_date, pr.modify_on) DESC)
            LOOP
                v_rtn := x.SID;
                EXIT;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rtn := NULL;
        END;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_org_member: ' || SQLERRM);
            RETURN 'get_org_member: ' || SQLERRM;
    END get_org_member;

    FUNCTION get_org_member_name(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        v_rtn := get_name(get_org_member(p_pvop));
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_org_member_name: ' || SQLERRM);
            RETURN 'get_org_member_name: ' || SQLERRM;
    END get_org_member_name;

    FUNCTION get_org_member_addr(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        v_rtn := Osi_Address.get_addr_display(Osi_Address.get_address_sid(get_org_member(p_pvop)));
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_org_member_addr: ' || SQLERRM);
            RETURN 'get_org_member_addr: ' || SQLERRM;
    END get_org_member_addr;

    FUNCTION get_participant(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_sid   T_OSI_PARTICIPANT.SID%TYPE;
    BEGIN
        SELECT participant
          INTO v_sid
          FROM T_OSI_PARTICIPANT_VERSION
         WHERE SID = p_version;

        RETURN v_sid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('get_participant: ' || SQLERRM);
            RETURN 'get_participant: ' || SQLERRM;
    END get_participant;

    FUNCTION get_rank(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT sa_rank AS rank
                    FROM v_osi_participant_version
                   WHERE SID = p_pvop
                      OR (participant = p_pvop AND SID = current_version))
        LOOP
            RETURN x.rank;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_rank: ' || SQLERRM);
            RETURN 'get_rank: ' || SQLERRM;
    END get_rank;

    FUNCTION get_relation_specifics(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_specifics    VARCHAR2(3300);
        v_mod1_name    T_OSI_PARTIC_RELATION_TYPE.mod1_name%TYPE;
        v_mod2_name    T_OSI_PARTIC_RELATION_TYPE.mod2_name%TYPE;
        v_mod3_name    T_OSI_PARTIC_RELATION_TYPE.mod3_name%TYPE;
        v_mod1_value   T_OSI_PARTIC_RELATION.mod1_value%TYPE;
        v_mod2_value   T_OSI_PARTIC_RELATION.mod2_value%TYPE;
        v_mod3_value   T_OSI_PARTIC_RELATION.mod3_value%TYPE;
    BEGIN
        SELECT t.mod1_name, t.mod2_name, t.mod3_name, r.mod1_value, r.mod2_value, r.mod3_value
          INTO v_mod1_name, v_mod2_name, v_mod3_name, v_mod1_value, v_mod2_value, v_mod3_value
          FROM T_OSI_PARTIC_RELATION_TYPE t, T_OSI_PARTIC_RELATION r
         WHERE r.SID = p_sid AND r.rel_type = t.SID;

        IF (v_mod1_value IS NOT NULL) THEN
            Core_Util.append_info(v_specifics, v_mod1_name);
            Core_Util.append_info(v_specifics, v_mod1_value, ': ');
        END IF;

        IF (v_mod2_value IS NOT NULL) THEN
            Core_Util.append_info(v_specifics, v_mod2_name);
            Core_Util.append_info(v_specifics, v_mod2_value, ': ');
        END IF;

        IF (v_mod3_value IS NOT NULL) THEN
            Core_Util.append_info(v_specifics, v_mod3_name);
            Core_Util.append_info(v_specifics, v_mod3_value, ': ');
        END IF;

        RETURN v_specifics;
    END get_relation_specifics;

    FUNCTION get_subtype(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_subtype   T_OSI_REFERENCE.SID%TYPE;
        v_rtn       VARCHAR2(100);
    BEGIN
        SELECT sub_type
          INTO v_subtype
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        IF (v_subtype IS NULL) THEN
            v_rtn := 'Not Applicable';
        ELSE
            SELECT description
              INTO v_rtn
              FROM T_OSI_REFERENCE
             WHERE SID = v_subtype;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_subtype: ' || SQLERRM);
            RETURN 'get_subtype: ' || SQLERRM;
    END get_subtype;

    FUNCTION get_subtype_sid(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_subtype   T_OSI_REFERENCE.SID%TYPE;
        v_rtn       T_OSI_PARTICIPANT_NONHUMAN.sub_type%TYPE;
    BEGIN
        SELECT sub_type
          INTO v_subtype
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        IF (v_subtype IS NULL) THEN
            v_rtn := NULL;
        ELSE
            SELECT SID
              INTO v_rtn
              FROM T_OSI_REFERENCE
             WHERE SID = v_subtype;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_subtype: ' || SQLERRM);
            RETURN 'get_subtype: ' || SQLERRM;
    END get_subtype_sid;

    FUNCTION get_type(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_type   v_osi_participant_version.obj_type_desc%TYPE;
    BEGIN
        SELECT obj_type_desc
          INTO v_type
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        RETURN v_type;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_type: ' || SQLERRM);
            RETURN 'get_type: ' || SQLERRM;
    END get_type;

    FUNCTION get_type_sid(p_popv IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_sid   T_CORE_OBJ_TYPE.SID%TYPE;
    BEGIN
        --Assume it's a participant sid.
        BEGIN
            SELECT Core_Obj.get_objtype(p.SID)
              INTO v_sid
              FROM T_OSI_PARTICIPANT p
             WHERE p.SID = p_popv;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Must be a version sid.
                SELECT Core_Obj.get_objtype(pv.participant)
                  INTO v_sid
                  FROM T_OSI_PARTICIPANT_VERSION pv
                 WHERE pv.SID = p_popv;
        END;

        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_type_sid: ' || SQLERRM);
            RETURN 'get_type_sid: ' || SQLERRM;
    END get_type_sid;

    FUNCTION get_tagline(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_name(p_pvop);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline: ' || SQLERRM);
            RETURN 'get_tagline: ' || SQLERRM;
    END get_tagline;

    FUNCTION get_type_lov(p_type_list IN VARCHAR2 := 'ALL')
        RETURN VARCHAR2 IS
        v_lov    VARCHAR2(200);
        v_code   VARCHAR2(200);
        v_desc   VARCHAR2(200);
    BEGIN
        IF p_type_list = 'ALL' THEN
            Core_Util.append_info(v_lov, 'All Participant Types;ALL');
            Core_Util.append_info(v_lov, 'Companies;PART.NONINDIV.COMP');
            Core_Util.append_info(v_lov, 'Individuals by Name;PART.INDIV');
            Core_Util.append_info(v_lov, 'Organizations;PART.NONINDIV.ORG');
            Core_Util.append_info(v_lov, 'Programs;PART.NONINDIV.PROG');
        ELSE
            FOR a IN 1 .. 4
            LOOP
                v_code := Core_List.get_list_element(p_type_list, a);

                BEGIN
                    SELECT description
                      INTO v_desc
                      FROM T_CORE_OBJ_TYPE
                     WHERE code = v_code;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_desc := NULL;
                END;

                IF v_desc IS NOT NULL THEN
                    Core_Util.append_info(v_lov, v_desc || ';' || v_code);
                END IF;
            END LOOP;
        END IF;

        RETURN v_lov;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_type_lov: ' || SQLERRM);
            RETURN 'get_type_lov: ' || SQLERRM;
    END get_type_lov;

    FUNCTION get_version_label(p_pv IN VARCHAR2, p_short_label IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn       VARCHAR2(100);
        v_sid       VARCHAR2(20);
        v_current   VARCHAR2(20);
        v_by        VARCHAR2(100);
        v_date      VARCHAR2(11);
        v_time      VARCHAR2(8);
        v_format    VARCHAR2(30);
    BEGIN
        v_format := Core_Util.get_config('CORE.DATE_FMT_DAY');
        v_current := get_current_version(get_participant(p_pv));

        IF (v_current = p_pv) THEN
            v_sid := v_current;
            v_rtn := 'Current';
        ELSE
            v_sid := p_pv;
            v_rtn := 'Previous';
        END IF;

        IF (p_short_label IS NOT NULL) THEN
            RETURN v_rtn || ' Version';
        END IF;

        SELECT TO_CHAR(create_on, v_format), TO_CHAR(create_on, 'HH12:MI AM'), create_by
          INTO v_date, v_time, v_by
          FROM T_OSI_PARTICIPANT_VERSION
         WHERE SID = v_sid;

        RETURN v_rtn || ' version created by ' || v_by || ' on ' || v_date || ' at ' || v_time;

    END get_version_label;

    FUNCTION has_isn_number(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1);
        v_isn_exists   NUMBER;
        v_isn_type     T_OSI_REFERENCE.SID%TYPE;
    BEGIN
        -- Check for the existence of ISN number type.
        v_isn_type := Osi_Reference.lookup_ref_sid('INDIV_NUM', 'ISN');

        IF (v_isn_type IS NOT NULL) THEN
            SELECT COUNT(pn.SID)
              INTO v_isn_exists
              FROM v_osi_participant_version pv, T_OSI_PARTIC_NUMBER pn
             WHERE pv.SID = p_pvop
                OR     (pv.participant = p_pvop AND pv.current_version = pv.SID)
                   AND pv.SID = pn.participant_version
                   AND pn.num_type = v_isn_type;
        END IF;

        IF (v_isn_exists > 0) THEN
            v_rtn := 'Y';
        ELSE
            v_rtn := 'N';
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('has_isn_number: ' || SQLERRM);
            RAISE;
    END has_isn_number;

    FUNCTION check_for_duplicates(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_target            v_osi_participant_version%ROWTYPE;
        v_indiv             T_CORE_OBJ_TYPE.SID%TYPE;
        v_comp              T_CORE_OBJ_TYPE.SID%TYPE;
        v_org               T_CORE_OBJ_TYPE.SID%TYPE;
        v_prog              T_CORE_OBJ_TYPE.SID%TYPE;
        v_confirm_allowed   VARCHAR2(1);
        v_do_soundex        BOOLEAN;
        v_score             NUMBER                              := 0;
        v_max_score         NUMBER                              := 0;
        v_id_count          NUMBER;
        v_ssn_count         NUMBER;
        v_info              VARCHAR2(200);
    BEGIN
        v_messages := NULL;
        v_session := NULL;
        v_confirm_allowed := 'Y';
        v_indiv := Core_Obj.lookup_objtype('PART.INDIV');
        v_comp := Core_Obj.lookup_objtype('PART.NONINDIV.COMP');
        v_org := Core_Obj.lookup_objtype('PART.NONINDIV.ORG');
        v_prog := Core_Obj.lookup_objtype('PART.NONINDIV.PROG');

        -- This is the new participant that we want to verfiy doesn't already exist.
        SELECT *
          INTO v_target
          FROM v_osi_participant_version
         WHERE SID = current_version AND participant = p_obj;

        -- This loops over all the other confirmed participants.
        FOR x IN (SELECT v.SID, v.dob, v.participant, v.obj_type, v.co_cage, v.co_duns, v.org_uic,
                         v.sex
                    FROM v_osi_participant_version v
                   WHERE v.SID = v.current_version
                     AND v.confirm_on IS NOT NULL
                     AND v.obj_type = v_target.obj_type
                     AND v.SID <> v_target.SID)
        LOOP
            v_score := 0;
            v_info := NULL;

            -- Check DOB.
            IF (x.dob = v_target.dob) THEN
                v_score := v_score + 20;
                v_info := v_info || 'Same birth date. ';
            END IF;

            -- Check identifying numbers for each participant type.
            -- Individual
            IF (v_target.obj_type = v_indiv) THEN
                FOR n IN (SELECT DISTINCT nt.code, UPPER(pn.num_value) AS num_value
                                     FROM T_OSI_PARTIC_NUMBER pn, T_OSI_PARTIC_NUMBER_TYPE nt
                                    WHERE pn.participant_version = x.SID AND pn.num_type = nt.SID
                          INTERSECT
                          SELECT DISTINCT nt.code, UPPER(pn.num_value) AS num_value
                                     FROM T_OSI_PARTIC_NUMBER pn, T_OSI_PARTIC_NUMBER_TYPE nt
                                    WHERE pn.participant_version = v_target.SID
                                      AND pn.num_type = nt.SID)
                LOOP
                    IF (n.code = 'SSN') THEN
                        v_score := v_score + 75;
                        v_info := v_info || 'Same SSN. ';
                        EXIT;
                    END IF;

                    v_score := v_score + 50;
                    v_info := v_info || 'Same indentifying number. ';
                    EXIT;
                END LOOP;
            END IF;

            -- Company
            IF (v_target.obj_type = v_comp) THEN
                IF (UPPER(x.co_cage) = UPPER(v_target.co_cage)) THEN
                    v_score := v_score + 75;
                    v_info := v_info || 'Same CAGE Code. ';
                END IF;

                IF (UPPER(x.co_duns) = UPPER(v_target.co_duns)) THEN
                    v_score := v_score + 75;
                    v_info := v_info || 'Same DUNS. ';
                END IF;
            END IF;

            -- Organization
            IF (v_target.obj_type = v_org) THEN
                IF (UPPER(x.org_uic) = UPPER(v_target.org_uic)) THEN
                    v_score := v_score + 75;
                    v_info := v_info || 'Same UIC. ';
                END IF;
            END IF;

            -- Program
            IF (v_target.obj_type = v_prog) THEN
                -- Check relationship contracts.
                FOR r IN (SELECT DISTINCT related_to
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = x.SID
                                      AND relation_code IN('ICB', 'ICF')
                          INTERSECT
                          SELECT DISTINCT related_to
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = v_target.SID
                                      AND relation_code IN('ICB', 'ICF'))
                LOOP
                    v_score := v_score + 10;
                    v_info := v_info || 'Same contractor. ';
                    EXIT;
                END LOOP;

                FOR r IN (SELECT DISTINCT UPPER(specifics)
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = x.SID
                                          AND relation_code IN('ICB', 'ICF')
                          INTERSECT
                          SELECT DISTINCT UPPER(specifics)
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = v_target.SID
                                      AND relation_code IN('ICB', 'ICF'))
                LOOP
                    v_score := v_score + 10;
                    v_info := v_info || 'Same contract number. ';
                    EXIT;
                END LOOP;
            END IF;

            -- Check the names.
            IF (v_score < 80 AND v_max_score < 80) THEN
                v_do_soundex := TRUE;

                FOR n IN (SELECT DISTINCT UPPER(last_name),
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = x.SID AND type_code <> 'A'
                          INTERSECT
                          SELECT DISTINCT UPPER(last_name),
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = v_target.SID AND type_code <> 'A')
                LOOP
                    v_score := v_score + 50;
                    v_info := v_info || 'Same name';

                    IF (v_target.obj_type = v_prog) THEN
                        v_info := v_info || ' (or acronym)';
                    END IF;

                    v_info := v_info || '. ';
                    v_do_soundex := FALSE;
                    EXIT;
                END LOOP;
            END IF;

            IF (v_score < 75 AND v_score > 15 AND v_max_score < 80 AND v_do_soundex) THEN
                FOR n IN (SELECT DISTINCT SOUNDEX(last_name) AS last_name,
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = x.SID AND type_code <> 'A'
                          INTERSECT
                          SELECT DISTINCT SOUNDEX(last_name) AS last_name,
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = v_target.SID AND type_code <> 'A')
                LOOP
                    v_score := v_score + 25;
                    v_info := v_info || 'Similar name';

                    IF (v_target.obj_type = v_prog) THEN
                        v_info := v_info || ' (or acronym)';
                    END IF;

                    v_info := v_info || '. ';
                END LOOP;
            END IF;

            -- Adjust score for expected differences.
            IF (    v_score > 0
                AND x.sex IS NOT NULL
                AND v_target.sex IS NOT NULL
                AND x.sex <> v_target.sex) THEN
                v_score := v_score - 50;
                v_info := v_info || 'DIFFERENT sex. ';
            END IF;

            IF (v_score <= 0) THEN
                v_score := 0;
            ELSE
                v_info := RTRIM(v_info, ' ');

                IF (v_score > 100) THEN
                    v_score := 100;
                END IF;

                IF (v_session IS NULL) THEN
                    -- This is the first result so set the session.
                    v_session := Core_Sidgen.next_sid;
--                    v_confirm_allowed := 'N';
                END IF;

                INSERT INTO T_OSI_PARTIC_SEARCH_RESULT
                            (session_id, participant, score, info)
                     VALUES (v_session, x.participant, v_score, v_info);
            END IF;

            IF (v_score > v_max_score) THEN
                v_max_score := v_score;
            END IF;
        END LOOP;

        IF (v_max_score >= 75) THEN
            v_confirm_allowed := 'N';
        END IF;

        IF (v_target.obj_type = v_prog) THEN
            SELECT COUNT(SID)
              INTO v_score
              FROM v_osi_partic_relation
             WHERE this_participant = v_target.SID AND relation_code IN('ICB', 'ICF');

            IF (v_score = 0) THEN
                v_confirm_allowed := 'N';
            END IF;
        END IF;

        RETURN v_confirm_allowed;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('check_for_duplicates: ' || SQLERRM);
            --v_confirm_allowed := 'N';
            RAISE;
    END check_for_duplicates;

    PROCEDURE check_for_matches(
        p_number           IN       VARCHAR2,
        p_number_type      IN       VARCHAR2,
        p_dob              IN       DATE,
        p_lname            IN       VARCHAR2,
        p_fname            IN       VARCHAR2,
        p_sex              IN       VARCHAR2,
        p_session_web      IN OUT   VARCHAR2,
        p_session_legacy   IN OUT   VARCHAR2,
        p_deers_result     OUT      VARCHAR2) IS
        v_name_types             T_CORE_CONFIG.setting%TYPE;
        v_lname                  T_OSI_PARTIC_NAME.last_name%TYPE;
        v_fname                  T_OSI_PARTIC_NAME.first_name%TYPE;
        v_score                  NUMBER                               := 0;
        v_info                   VARCHAR2(150);
        v_code                   T_OSI_PARTIC_NUMBER_TYPE.code%TYPE;
        --v_cnt          number                               := 0;--TODO
        v_found_match            BOOLEAN;
        v_sex_code               VARCHAR2(200);
        v_num_type_code          VARCHAR2(200);
        v_num_type_description   VARCHAR2(200);

        --Process_Match = Legacy Only
        PROCEDURE process_match(
            p_session          IN   VARCHAR2,
            p_person_version   IN   VARCHAR2,
            p_hit_score        IN   NUMBER,
            p_details          IN   VARCHAR2) IS
            v_cnt   NUMBER;
        BEGIN
            --Clear Buffer
            v_cnt := 0;

            FOR k IN (SELECT *
                        FROM T_OSI_MIGRATION_PARTIC_HIT
                       WHERE user_session = p_session AND person_version = p_person_version)
            LOOP
                --See if this person has been processed as a hit already
                v_cnt := v_cnt + 1;
            END LOOP;

            IF (v_cnt > 0) THEN
                RETURN;
            ELSE
                FOR k IN (SELECT *
                            FROM T_OSI_MIGRATION
                           WHERE TYPE = 'PARTICIPANT_VERSION' AND old_sid = p_person_version)
                LOOP
                    --See if this person has been imported already
                    v_cnt := v_cnt + 1;
                END LOOP;
            END IF;

            IF (v_cnt = 0) THEN
                INSERT INTO T_OSI_MIGRATION_PARTIC_HIT
                            (user_session, person_version, score, details)
                     VALUES (p_session, p_person_version, p_hit_score, p_details);

                COMMIT;
            END IF;
        END process_match;
    BEGIN
        --Clear Buffers
        v_found_match := FALSE;

        --Get Session ID's
        --Legacy
        IF (p_session_legacy IS NULL) THEN
            p_session_legacy := Core_Sidgen.next_sid;

            --Just remove anything over 6 hours old
            DELETE FROM T_OSI_MIGRATION_PARTIC_HIT
                  WHERE create_on < SYSDATE - .25;

            COMMIT;
        ELSE
            --Clear out old session data
            DELETE FROM T_OSI_MIGRATION_PARTIC_HIT
                  WHERE user_session = p_session_legacy;

            COMMIT;
        END IF;

        --Web
        IF (p_session_web IS NULL) THEN
            p_session_web := Core_Sidgen.next_sid;

            --Just remove anything over 6 hours old
            DELETE FROM T_OSI_PARTIC_SEARCH_RESULT
                  WHERE create_on < SYSDATE - .25;

            COMMIT;
        ELSE
            --Clear out old session data
            DELETE FROM T_OSI_PARTIC_SEARCH_RESULT
                  WHERE session_id = p_session_web;

            COMMIT;
        END IF;

        IF (p_number IS NULL) THEN
            --p_session := core_sidgen.next_sid;--TODO
            -- Get the type codes for the searchable names.
            v_name_types := Core_Util.get_config('OSI.SEARCH_PARTICIPANT_NAME_TYPES');
            v_lname := UPPER(trim(p_lname));
            v_fname := UPPER(trim(p_fname));

            --Web Participant Search[BEGIN]
            FOR x IN (SELECT pv.SID, pv.participant, pn.last_name, pn.first_name
                        FROM v_osi_participant_version pv, v_osi_partic_name pn
                       WHERE pv.SID = pv.current_version
                         --and pv.current_name = pn.sid
                         AND pv.SID = pn.participant_version
                         AND (   p_dob IS NULL
                              OR pv.dob = p_dob)
                         AND (   p_sex IS NULL
                              OR pv.sex = p_sex)
                         AND INSTR(v_name_types, pn.type_code) > 0
                         AND (    (   SOUNDEX(pn.last_name) = SOUNDEX(v_lname)
                                   OR pn.last_name LIKE v_lname || '%')
                              AND (   SOUNDEX(pn.first_name) = SOUNDEX(v_fname)
                                   OR pn.first_name LIKE v_fname || '%'))
                         AND pv.confirm_by IS NOT NULL
                         AND pv.confirm_on IS NOT NULL)
            LOOP
                IF (   v_lname IS NOT NULL
                    OR LENGTH(v_lname) <> 0) THEN
                    IF (x.last_name = v_lname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching last name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding last name. ';
                    END IF;
                END IF;

                IF (   v_fname IS NOT NULL
                    OR LENGTH(v_fname) <> 0) THEN
                    IF (x.first_name = v_fname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching first name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding first name. ';
                    END IF;
                END IF;

                IF (p_dob IS NOT NULL) THEN
                    v_score := v_score + 25;
                    v_info := v_info || 'Matching DOB. ';
                END IF;

                IF (p_sex IS NOT NULL) THEN
                    v_score := v_score + 15;
                    v_info := v_info || 'Matching sex.';
                END IF;

                INSERT INTO T_OSI_PARTIC_SEARCH_RESULT
                            (session_id, participant, score, info)
                     VALUES (p_session_web, x.participant, v_score, v_info);

                v_score := 0;
                v_info := '';
            END LOOP;

            --Web Participant Search[END]

            --Legacy Participant Search[BEGIN]
            --Get Sex Code
            IF (p_sex IS NOT NULL) THEN
                SELECT code
                  INTO v_sex_code
                  FROM T_DIBRS_REFERENCE
                 WHERE SID = p_sex;
            END IF;

            FOR match IN (SELECT pv.SID, pv.person, pn.last_name, pn.first_name, pv.sex
                            FROM ref_t_person_version pv, ref_t_person_name pn, ref_t_person p
                           WHERE p.SID = pv.person
                             AND pv.SID = pn.person_version
                             AND (   p_dob IS NULL
                                  OR p.birth_date = p_dob)
                             AND (   pv.sex IS NULL
                                  OR pv.sex LIKE v_sex_code || '%')
                             AND INSTR(v_name_types, pn.name_type) > 0
                             AND (    (   SOUNDEX(pn.last_name) = SOUNDEX(v_lname)
                                       OR pn.last_name LIKE v_lname || '%')
                                  AND (   SOUNDEX(pn.first_name) = SOUNDEX(v_fname)
                                       OR pn.first_name LIKE v_fname || '%'))
                             AND p.confirm_by IS NOT NULL
                             AND p.confirm_on IS NOT NULL
                             AND pv.current_flag = 1)
            LOOP
                --Reset Scores and Info
                v_score := 0;
                v_info := '';

                --Last Name
                IF (   v_lname IS NOT NULL
                    OR LENGTH(v_lname) <> 0) THEN
                    IF (match.last_name = v_lname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching last name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding last name. ';
                    END IF;
                END IF;

                --First Name
                IF (   v_fname IS NOT NULL
                    OR LENGTH(v_fname) <> 0) THEN
                    IF (match.first_name = v_fname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching first name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding first name. ';
                    END IF;
                END IF;

                --Birth Date
                IF (p_dob IS NOT NULL) THEN
                    v_info := v_info || 'Matching DOB. ';
                    v_score := v_score + 25;
                END IF;

                --Sex
                IF ((   v_sex_code IS NOT NULL
                     OR LENGTH(v_sex_code) <> 0) AND match.sex IS NOT NULL) THEN
                    v_info := v_info || 'Matching sex. ';
                    v_score := v_score + 15;
                END IF;

                --Mark match
                process_match(p_session_legacy, match.SID, v_score, v_info);
            END LOOP;
        --Legacy Participant Search[END]
        ELSE
            --Try matching on Number
            v_score := 90;

            --p_session := core_sidgen.next_sid;--TODO

            --Web Participant Search With Number [BEGIN]
            SELECT 'Matching ' || description || '.', code
              INTO v_info, v_code
              FROM T_OSI_PARTIC_NUMBER_TYPE
             WHERE SID = p_number_type;

            FOR x IN (SELECT pv.SID, pv.participant
                        FROM v_osi_participant_version pv, T_OSI_PARTIC_NUMBER pn
                       WHERE pv.SID = pv.current_version
                         AND pn.participant_version = pv.SID
                         AND pn.num_type = p_number_type
                         AND pn.num_value = p_number
                         AND pv.confirm_by IS NOT NULL
                         AND pv.confirm_on IS NOT NULL)
            LOOP
                INSERT INTO T_OSI_PARTIC_SEARCH_RESULT
                            (session_id, participant, score, info)
                     VALUES (p_session_web, x.participant, v_score, v_info);

                --v_cnt := 1;--TODO
                v_found_match := TRUE;
            END LOOP;

            --Web Participant Search With Number[END]

            --Legacy Participant Search With Number[BEGIN]
            IF (p_number IS NOT NULL) THEN
                IF (p_number_type IS NOT NULL) THEN
                    --Get current code
                    SELECT code, description
                      INTO v_num_type_code, v_num_type_description
                      FROM T_OSI_PARTIC_NUMBER_TYPE
                     WHERE SID = p_number_type;

                    IF (v_num_type_code = 'OID') THEN
                        --Codes don't match in legacy vs. web
                        v_num_type_code := 'OTHER';
                    END IF;

                    v_info := 'Matching ' || v_num_type_description || '.';
                END IF;

                FOR k IN (SELECT person_version
                            FROM ref_t_person_number
                           WHERE UPPER(num_value) LIKE '%' || p_number || '%'
                             AND UPPER(num_type) = UPPER(v_num_type_code))
                LOOP
                    process_match(p_session_legacy, k.person_version, 90, v_info);
                    v_found_match := TRUE;
                END LOOP;
            END IF;

            --Legacy Participant Search With Number[END]
            IF (v_found_match = FALSE AND Osi_Deers.is_searchable_number(p_number_type) = 'Y') THEN
                -- Check deers.
                p_session_web := NULL;
                p_session_legacy := NULL;

                IF Core_Util.get_config('OSI.AUDITING') = 'ON' THEN
                    Log_Info('DEERS:Query for ' || UPPER(trim(p_lname)) || ', ' || p_number);
                END IF;

                p_deers_result :=
                          Osi_Deers.get_deers_information(p_number, UPPER(trim(p_lname)), 1, v_code);
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('check_for_matches: ' || SQLERRM);
            RAISE;
    END check_for_matches;

    PROCEDURE confirm(p_obj IN VARCHAR2) IS
    BEGIN
        UPDATE T_OSI_PARTICIPANT
           SET confirm_on = SYSDATE,
               confirm_by = Core_Context.personnel_name
         WHERE SID = p_obj;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('confirm: ' || SQLERRM);
            RAISE;
    END confirm;

    PROCEDURE unconfirm(p_obj IN VARCHAR2) IS
    BEGIN
        UPDATE T_OSI_PARTICIPANT
           SET confirm_on = NULL,
               confirm_by = NULL
         WHERE SID = p_obj;

        INSERT INTO T_OSI_NOTE
                    (obj, note_type, note_text, lock_mode)
             VALUES (p_obj,
                     (SELECT SID
                        FROM T_OSI_NOTE_TYPE
                       WHERE code = 'UNCONFIRM' AND USAGE = 'NOTELIST'),
                     'Participant was unconfirmed.',
                     'IMMED');
    EXCEPTION
        WHEN OTHERS THEN
            log_error('unconfirm: ' || SQLERRM);
            RAISE;
    END unconfirm;

    PROCEDURE remap_org_names(p_pvop IN VARCHAR2) IS
        v_count     INTEGER;
        v_pv        T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_ok        T_OSI_PARTIC_NAME_TYPE.SID%TYPE;
        v_subtype   T_OSI_PARTICIPANT_NONHUMAN.sub_type%TYPE;
    BEGIN
        -- See if this is a participant sid instead of a version sid.
        v_pv := get_current_version(p_pvop);

        IF (v_pv IS NULL) THEN
            v_pv := p_pvop;
        END IF;

        -- Get the organization type.
        v_subtype := get_subtype_sid(v_pv);

        FOR x IN (SELECT   SID, name_type
                      FROM T_OSI_PARTIC_NAME
                     WHERE participant_version = v_pv
                  ORDER BY create_on ASC)
        LOOP
            -- See if there is a corresponding name for the subtype.
            BEGIN
                SELECT m.name_type
                  INTO v_ok
                  FROM T_OSI_PARTIC_NAME_TYPE_MAP m
                 WHERE m.participant_type = v_subtype AND m.name_type = x.name_type;

                -- Make the first mapped name the default name.
                IF (v_count IS NULL) THEN
                    UPDATE T_OSI_PARTICIPANT_VERSION
                       SET current_name = x.SID
                     WHERE SID = v_pv;

                    v_count := 1;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- This name didn't map so unset it if it's the current name then delete it.
                    UPDATE T_OSI_PARTICIPANT_VERSION
                       SET current_name = NULL
                     WHERE SID = v_pv AND current_name = x.SID;

                    DELETE FROM T_OSI_PARTIC_NAME
                          WHERE SID = x.SID;
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('remap_org_names: ' || SQLERRM);
            RAISE;
    END remap_org_names;

    PROCEDURE replace_with(p_obj IN VARCHAR2, p_replacement IN VARCHAR2) IS
        v_count             INTEGER;
        v_sid               VARCHAR2(20);
        v_note              VARCHAR2(32767);
        v_crlf              VARCHAR2(2)                          := CHR(13) || CHR(10);
        v_obj_version       T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_replace_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_obj_row           v_osi_participant_version%ROWTYPE;
        v_replace_row       v_osi_participant_version%ROWTYPE;

        PROCEDURE log_note(p_note IN VARCHAR2) IS
        BEGIN
            Core_Util.append_info(v_note, p_note, v_crlf);
        END log_note;

        PROCEDURE check_diff(p_target IN VARCHAR2, p_replace IN VARCHAR2, p_note IN VARCHAR2) IS
            v_yn   VARCHAR2(3);
        BEGIN
            IF (NVL(p_target, 'NULL') <> NVL(p_replace, 'NULL')) THEN
                CASE p_target
                    WHEN 'Y' THEN
                        log_note(p_note || '=Yes');
                    WHEN 'N' THEN
                        log_note(p_note || '=No');
                    WHEN 'U' THEN
                        log_note(p_note || '=');
                    ELSE
                        log_note(p_note || '=' || p_target);
                END CASE;
            END IF;
        END check_diff;

        PROCEDURE check_diff(p_target IN DATE, p_replace IN DATE, p_note IN VARCHAR2) IS
        BEGIN
            IF (NVL(p_target, TO_DATE('01/01/1900', 'mm/dd/yyyy')) <>
                                                 NVL(p_replace, TO_DATE('01/01/1900', 'mm/dd/yyyy'))) THEN
                log_note(p_note || '=' || p_target);
            END IF;
        END check_diff;
    BEGIN
        IF (p_obj IS NOT NULL AND p_replacement IS NOT NULL) THEN
            v_obj_version := get_current_version(p_obj);
            v_replace_version := get_current_version(p_replacement);

            -- Agent Applicant File
            FOR c IN (SELECT pi.SID
                        FROM T_OSI_PARTIC_INVOLVEMENT pi, T_OSI_PARTIC_ROLE_TYPE rt
                       WHERE pi.involvement_role = rt.SID
                         AND rt.USAGE = 'SUBJECT'
                         AND rt.obj_type = Core_Obj.lookup_objtype('FILE.AAPP')
                         AND pi.participant_version IN(SELECT SID
                                                         FROM T_OSI_PARTICIPANT_VERSION
                                                        WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_PARTIC_INVOLVEMENT
                       SET participant_version = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate T_AGENT_Applicant filtered out.');
                END;
            END LOOP;

            -- Group Interview
            FOR c IN (SELECT i.SID
                        FROM T_OSI_A_GI_INVOLVEMENT i
                       WHERE participant_version IN(SELECT SID
                                                      FROM T_OSI_PARTICIPANT_VERSION
                                                     WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_A_GI_INVOLVEMENT
                       SET participant_version = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate GI Involvement filtered out.');
                END;
            END LOOP;

            -- Personnel Recent Objects
            FOR c IN (SELECT p.SID
                        FROM T_OSI_PERSONNEL_RECENT_OBJECTS p
                       WHERE p.obj = p_obj)
            LOOP
                BEGIN
                    UPDATE T_OSI_PERSONNEL_RECENT_OBJECTS
                       SET obj = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Personnel Cache filtered out.');
                END;
            END LOOP;

            -- Participant Involvement
            FOR c IN (SELECT pi.SID
                        FROM T_OSI_PARTIC_INVOLVEMENT pi
                       WHERE participant_version IN(SELECT SID
                                                      FROM T_OSI_PARTICIPANT_VERSION
                                                     WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_PARTIC_INVOLVEMENT
                       SET participant_version = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Participant Involvement filtered out.');
                END;
            END LOOP;

            -- Investigative File Specification Victim
            FOR c IN (SELECT i.SID
                        FROM T_OSI_F_INV_SPEC i
                       WHERE i.victim IN(SELECT SID
                                           FROM T_OSI_PARTICIPANT_VERSION
                                          WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_F_INV_SPEC
                       SET victim = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Specification Victim filtered out.');
                END;
            END LOOP;

            -- Investigative File Specification Subject
            FOR c IN (SELECT i.SID
                        FROM T_OSI_F_INV_SPEC i
                       WHERE i.subject IN(SELECT SID
                                            FROM T_OSI_PARTICIPANT_VERSION
                                           WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_F_INV_SPEC
                       SET subject = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Specification Subject filtered out.');
                END;
            END LOOP;

            -- Investigative File Subject Disposition
            FOR c IN (SELECT s.SID
                        FROM T_OSI_F_INV_SUBJ_DISPOSITION s
                       WHERE s.subject IN(SELECT SID
                                            FROM T_OSI_PARTICIPANT_VERSION
                                           WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_F_INV_SUBJ_DISPOSITION
                       SET subject = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Subject Disposition filtered out.');
                END;
            END LOOP;

            -- Source File
            UPDATE T_OSI_F_SOURCE
               SET participant = p_replacement
             WHERE participant = p_obj;

            -- Participant Relationships
            UPDATE T_OSI_PARTIC_RELATION r
               SET r.partic_a = p_replacement
             WHERE r.partic_a = p_obj
               AND NOT EXISTS(
                       SELECT SID
                         FROM T_OSI_PARTIC_RELATION
                        WHERE partic_a = r.partic_b
                          AND partic_b = p_replacement
                          AND rel_type = r.rel_type
                          AND NVL(known_date, TRUNC(SYSDATE)) = NVL(r.known_date, TRUNC(SYSDATE)));

            UPDATE T_OSI_PARTIC_RELATION r
               SET r.partic_b = p_replacement
             WHERE r.partic_b = p_obj
               AND NOT EXISTS(
                       SELECT SID
                         FROM T_OSI_PARTIC_RELATION
                        WHERE partic_a = r.partic_a
                          AND partic_b = p_replacement
                          AND rel_type = r.rel_type
                          AND NVL(known_date, TRUNC(SYSDATE)) = NVL(r.known_date, TRUNC(SYSDATE)));

            -- For the participant version details we're going to log in the note any differences.
            SELECT *
              INTO v_obj_row
              FROM v_osi_participant_version
             WHERE SID = v_obj_version;

            SELECT *
              INTO v_replace_row
              FROM v_osi_participant_version
             WHERE SID = v_replace_version;

            check_diff(v_obj_row.education_level, v_replace_row.education_level, 'education_level');
            check_diff(v_obj_row.sa_pay_grade_desc, v_replace_row.sa_pay_grade_desc, 'sa_pay_grade');
            check_diff(v_obj_row.sa_pay_plan_desc, v_replace_row.sa_pay_plan_desc, 'sa_pay_plan');
            check_diff(v_obj_row.height, v_replace_row.height, 'height');
            check_diff(v_obj_row.weight, v_replace_row.weight, 'weight');
            check_diff(v_obj_row.race_desc, v_replace_row.race_desc, 'race');
            check_diff(v_obj_row.hair_color_desc, v_replace_row.hair_color_desc, 'hair_color');
            check_diff(v_obj_row.eye_color_desc, v_replace_row.eye_color_desc, 'eye_color');
            check_diff(v_obj_row.age_low, v_replace_row.age_low, 'age_low');
            check_diff(v_obj_row.age_high, v_replace_row.age_high, 'age_high');
            check_diff(v_obj_row.sex_desc, v_replace_row.sex_desc, 'sex');
            check_diff(v_obj_row.sa_service_desc, v_replace_row.sa_service_desc, 'sa_service');
            check_diff(v_obj_row.sa_component_desc, v_replace_row.sa_component_desc, 'sa_component');
            check_diff(v_obj_row.org_uic, v_replace_row.org_uic, 'org_uic');
            check_diff(v_obj_row.org_high_risk, v_replace_row.org_high_risk, 'org_high_risk');
            check_diff(v_obj_row.org_num_people, v_replace_row.org_num_people, 'org_num_people');
            check_diff(v_obj_row.org_supporting_unit,
                       v_replace_row.org_supporting_unit,
                       'org_supporting_unit');
            check_diff(v_obj_row.current_address_desc,
                       v_replace_row.current_address_desc,
                       'current_address');
            check_diff(v_obj_row.build_desc, v_replace_row.build_desc, 'build');
            check_diff(v_obj_row.writing_hand_desc, v_replace_row.writing_hand_desc, 'writing_hand');
            check_diff(v_obj_row.is_bald, v_replace_row.is_bald, 'is_bald');
            check_diff(v_obj_row.bald_comment, v_replace_row.bald_comment, 'bald_comment');
            check_diff(v_obj_row.has_facial_hair, v_replace_row.has_facial_hair, 'has_facial_hair');
            check_diff(v_obj_row.facial_hair_comment,
                       v_replace_row.facial_hair_comment,
                       'facial_hair_comment');
            check_diff(v_obj_row.wears_glasses, v_replace_row.wears_glasses, 'wears_glasses');
            check_diff(v_obj_row.glasses_comment, v_replace_row.glasses_comment, 'glasses_comment');
            check_diff(v_obj_row.is_hard_of_hearing,
                       v_replace_row.is_hard_of_hearing,
                       'is_hard_of_hearing');
            check_diff(v_obj_row.hearing_comment, v_replace_row.hearing_comment, 'hearing_comment');
            check_diff(v_obj_row.has_teeth, v_replace_row.has_teeth, 'has_teeth');
            check_diff(v_obj_row.teeth_comment, v_replace_row.teeth_comment, 'teeth_comment');
            check_diff(v_obj_row.sa_rank, v_replace_row.sa_rank, 'sa_rank');
            check_diff(v_obj_row.sa_rank_date, v_replace_row.sa_rank_date, 'sa_rank_date');
            check_diff(v_obj_row.sa_affiliation_desc,
                       v_replace_row.sa_affiliation_desc,
                       'sa_affiliation');
            check_diff(v_obj_row.sa_specialty_code,
                       v_replace_row.sa_specialty_code,
                       'sa_specialty_code');
            check_diff(v_obj_row.fsa_service_desc, v_replace_row.fsa_service_desc, 'fsa_service');
            check_diff(v_obj_row.fsa_rank, v_replace_row.fsa_rank, 'fsa_rank');
            check_diff(v_obj_row.fsa_equiv_rank, v_replace_row.fsa_equiv_rank, 'fsa_equiv_rank');
            check_diff(v_obj_row.fsa_rank_date, v_replace_row.fsa_rank_date, 'fsa_rank_date');
            check_diff(v_obj_row.org_majcom, v_replace_row.org_majcom, 'org_majcom');
            check_diff(v_obj_row.posture_desc, v_replace_row.posture_desc, 'posture');
            check_diff(v_obj_row.religion, v_replace_row.religion, 'religion');
            check_diff(v_obj_row.religion_involvement_desc,
                       v_replace_row.religion_involvement_desc,
                       'religion_involvement');
            check_diff(v_obj_row.prog_description,
                       v_replace_row.prog_description,
                       'prog_description');
            v_note := v_note || v_crlf;

            /*
             * Now go through all the p_obj data and copy it with the p_replacement sid
             * before deleting p_obj.
             */

            /*
             * For each data element (i.e. table) we want to maintain the audit history so
             * we disable all the triggers before inserting. This requires providing a sid.
             * We only insert records that have certain unique fields.
             */
            EXECUTE IMMEDIATE 'alter table t_osi_partic_citizenship disable all triggers';

            INSERT INTO T_OSI_PARTIC_CITIZENSHIP
                        (SID,
                         participant_version,
                         country,
                         effective_date,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, country, effective_date, create_by,
                       create_on, modify_by, modify_on
                  FROM T_OSI_PARTIC_CITIZENSHIP
                 WHERE participant_version = v_obj_version
                   AND (country, effective_date) NOT IN(
                                                       SELECT country, effective_date
                                                         FROM T_OSI_PARTIC_CITIZENSHIP
                                                        WHERE participant_version =
                                                                                   v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_citizenship enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_mark disable all triggers';

            INSERT INTO T_OSI_PARTIC_MARK
                        (SID,
                         participant_version,
                         mark_type,
                         mark_location,
                         description,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, mark_type, mark_location,
                       description, create_by, create_on, modify_by, modify_on
                  FROM T_OSI_PARTIC_MARK
                 WHERE participant_version = v_obj_version
                   AND (mark_type, mark_location) NOT IN(
                                                       SELECT mark_type, mark_location
                                                         FROM T_OSI_PARTIC_MARK
                                                        WHERE participant_version =
                                                                                   v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_mark enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_name disable all triggers';

            INSERT INTO T_OSI_PARTIC_NAME
                        (SID,
                         participant_version,
                         name_type,
                         title,
                         last_name,
                         first_name,
                         middle_name,
                         cadency,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, name_type, title, last_name,
                       first_name, middle_name, cadency, create_by, create_on, modify_by, modify_on
                  FROM T_OSI_PARTIC_NAME
                 WHERE participant_version = v_obj_version
                   AND (name_type, last_name, first_name, middle_name, cadency) NOT IN(
                                       SELECT name_type, last_name, first_name, middle_name,
                                              cadency
                                         FROM T_OSI_PARTIC_NAME
                                        WHERE participant_version = v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_name enable all triggers';

            -- We'll take all the participant numbers.
            EXECUTE IMMEDIATE 'alter table t_osi_partic_number disable all triggers';

            FOR x IN (SELECT *
                        FROM T_OSI_PARTIC_NUMBER
                       WHERE participant_version = v_obj_version)
            LOOP
                BEGIN
                    INSERT INTO T_OSI_PARTIC_NUMBER
                                (SID,
                                 participant_version,
                                 num_type,
                                 num_value,
                                 issue_date,
                                 issue_country,
                                 issue_state,
                                 issue_province,
                                 expire_date,
                                 note,
                                 create_on,
                                 create_by,
                                 modify_on,
                                 modify_by)
                         VALUES (Core_Sidgen.next_sid,
                                 v_replace_version,
                                 x.num_type,
                                 x.num_value,
                                 x.issue_date,
                                 x.issue_country,
                                 x.issue_state,
                                 x.issue_province,
                                 x.expire_date,
                                 x.note,
                                 x.create_on,
                                 x.create_by,
                                 x.modify_on,
                                 x.modify_by);
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        NULL;
                END;
            END LOOP;

            EXECUTE IMMEDIATE 'alter table t_osi_partic_number enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_org_attr disable all triggers';

            INSERT INTO T_OSI_PARTIC_ORG_ATTR
                        (SID,
                         participant_version,
                         ATTRIBUTE,
                         comments,
                         create_on,
                         create_by,
                         modify_on,
                         modify_by)
                SELECT Core_Sidgen.next_sid, v_replace_version, ATTRIBUTE, comments, create_on,
                       create_by, modify_on, modify_by
                  FROM T_OSI_PARTIC_ORG_ATTR
                 WHERE participant_version = v_obj_version
                   AND (ATTRIBUTE, comments) NOT IN(SELECT ATTRIBUTE, comments
                                                      FROM T_OSI_PARTIC_ORG_ATTR
                                                     WHERE participant_version = v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_org_attr enable all triggers';

            -- This data is handled differently because we need to log the duplicate records.
            EXECUTE IMMEDIATE 'alter table t_osi_partic_vehicle disable all triggers';

            FOR x IN (SELECT plate_num, reg_exp_date, reg_country, reg_state,
                             (SELECT description
                                FROM T_DIBRS_STATE
                               WHERE SID = reg_state) AS state_desc, reg_province, title_owner, vin,
                             make, MODEL, YEAR, color, body_type, gross_weight, num_axles, ROLE,
                             comments, create_by, create_on, modify_by, modify_on
                        FROM T_OSI_PARTIC_VEHICLE
                       WHERE participant_version = v_obj_version)
            LOOP
                DECLARE
                    v_dup   BOOLEAN := FALSE;
                BEGIN
                    FOR y IN (SELECT plate_num, reg_exp_date, reg_country, reg_state, reg_province,
                                     title_owner, vin, make, MODEL, YEAR, color, body_type,
                                     gross_weight, num_axles, ROLE, comments, create_by, create_on,
                                     modify_by, modify_on
                                FROM T_OSI_PARTIC_VEHICLE
                               WHERE participant_version = v_replace_version)
                    LOOP
                        IF (    x.plate_num = y.plate_num
                            AND (   x.reg_state = y.reg_state
                                 OR x.reg_province = y.reg_province)) THEN
                            -- This is a duplicate. Log it.
                            v_dup := TRUE;
                            v_note := v_note || 'Vehicle Information Duplication: plate number=';
                            v_note :=
                                v_note || x.plate_num || ' state/province='
                                || NVL(x.state_desc, x.reg_province) || v_crlf;
                        END IF;
                    END LOOP;

                    IF (NOT v_dup) THEN
                        INSERT INTO T_OSI_PARTIC_VEHICLE
                                    (SID,
                                     participant_version,
                                     plate_num,
                                     reg_exp_date,
                                     reg_country,
                                     reg_state,
                                     reg_province,
                                     title_owner,
                                     vin,
                                     make,
                                     MODEL,
                                     YEAR,
                                     color,
                                     body_type,
                                     gross_weight,
                                     num_axles,
                                     ROLE,
                                     comments,
                                     create_by,
                                     create_on,
                                     modify_by,
                                     modify_on)
                             VALUES (Core_Sidgen.next_sid,
                                     v_replace_version,
                                     x.plate_num,
                                     x.reg_exp_date,
                                     x.reg_country,
                                     x.reg_state,
                                     x.reg_province,
                                     x.title_owner,
                                     x.vin,
                                     x.make,
                                     x.MODEL,
                                     x.YEAR,
                                     x.color,
                                     x.body_type,
                                     x.gross_weight,
                                     x.num_axles,
                                     x.ROLE,
                                     x.comments,
                                     x.create_by,
                                     x.create_on,
                                     x.modify_by,
                                     x.modify_on);
                    END IF;
                END;
            END LOOP;

            EXECUTE IMMEDIATE 'alter table t_osi_partic_vehicle enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_contact disable all triggers';

            INSERT INTO T_OSI_PARTIC_CONTACT
                        (SID,
                         participant_version,
                         TYPE,
                         VALUE,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, TYPE, VALUE, create_by, create_on,
                       modify_by, modify_on
                  FROM T_OSI_PARTIC_CONTACT
                 WHERE participant_version = v_obj_version
                   AND (TYPE, VALUE) NOT IN(SELECT TYPE, VALUE
                                              FROM T_OSI_PARTIC_CONTACT
                                             WHERE participant_version = v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_contact enable all triggers';

            -- In Web I2MS participant addresses are spread across two tables.
            EXECUTE IMMEDIATE 'alter table t_osi_partic_address disable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_address disable all triggers';

            FOR x IN (SELECT va.address_type, va.address_1, va.address_2, va.city, va.province,
                             va.state, va.postal_code, va.country, va.start_date, va.end_date,
                             va.known_date, va.geo_coords, va.comments, va.create_on, va.create_by,
                             va.modify_on, va.modify_by, a.create_on AS c1, a.create_by AS c2,
                             a.modify_on AS m1, a.modify_by AS m2
                        FROM v_osi_partic_address va, T_OSI_PARTIC_ADDRESS a
                       WHERE va.participant_version = v_obj_version
                         AND va.participant_version = a.participant_version
                         AND va.SID = a.SID
                         AND (va.address_1,
                              va.address_2,
                              va.city,
                              va.province,
                              va.state,
                              va.postal_code,
                              va.country,
                              va.start_date,
                              va.end_date,
                              va.known_date,
                              va.geo_coords,
                              va.comments) NOT IN(
                                 SELECT address_1, address_2, city, province, state, postal_code,
                                        country, start_date, end_date, known_date, geo_coords,
                                        comments
                                   FROM v_osi_partic_address
                                  WHERE participant_version = v_replace_version))
            LOOP
                INSERT INTO T_OSI_ADDRESS
                            (SID,
                             obj,
                             address_type,
                             address_1,
                             address_2,
                             city,
                             province,
                             state,
                             postal_code,
                             country,
                             geo_coords,
                             start_date,
                             end_date,
                             known_date,
                             comments,
                             create_on,
                             create_by,
                             modify_on,
                             modify_by)
                     VALUES (Core_Sidgen.next_sid,
                             p_replacement,
                             x.address_type,
                             x.address_1,
                             x.address_2,
                             x.city,
                             x.province,
                             x.state,
                             x.postal_code,
                             x.country,
                             x.geo_coords,
                             x.start_date,
                             x.end_date,
                             x.known_date,
                             x.comments,
                             x.create_on,
                             x.create_by,
                             x.modify_on,
                             x.modify_by)
                  RETURNING SID
                       INTO v_sid;

                INSERT INTO T_OSI_PARTIC_ADDRESS
                            (SID,
                             participant_version,
                             address,
                             create_on,
                             create_by,
                             modify_on,
                             modify_by)
                     VALUES (Core_Sidgen.next_sid, v_replace_version, v_sid, x.c1, x.c2, x.m1, x.m2);
            END LOOP;

            EXECUTE IMMEDIATE 'alter table t_osi_partic_address enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_address enable all triggers';

            DELETE FROM T_CORE_OBJ
                  WHERE SID = p_obj;

            IF (v_note IS NOT NULL) THEN
                v_note :=
                    'Deleted target data: ' || v_obj_row.obj_type_desc || ' Name= '
                    || v_obj_row.full_name || v_crlf || RTRIM(v_note, ', ');

                INSERT INTO T_OSI_NOTE
                            (obj, note_type, note_text, creating_personnel)
                     VALUES (p_replacement,
                             (SELECT SID
                                FROM T_OSI_NOTE_TYPE
                               WHERE obj_type = Core_Obj.lookup_objtype('PARTICIPANT')
                                 AND code = 'CONFIRM_REPLACE'),
                             v_note,
                             Core_Context.personnel_sid);
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('replace_with: ' || SQLERRM);
            RAISE;
    END replace_with;

    PROCEDURE run_report_details(p_obj IN VARCHAR2) IS
        v_date_fmt        VARCHAR2(11);
        v_mugshot         BLOB;
        v_ok              VARCHAR2(1000);
        v_template_date   DATE;
        v_mime_type       T_CORE_TEMPLATE.mime_type%TYPE;
        v_mime_disp       T_CORE_TEMPLATE.mime_disposition%TYPE;
        v_ot_code         T_CORE_OBJ_TYPE.code%TYPE;
        v_pv_sid          T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_sa_record       v_osi_partic_sa%ROWTYPE;
        v_counter         INTEGER                                 := 0;
        v_clob            CLOB;
        v_temp_clob       CLOB;
        v_main_clob       CLOB;
        v_pc_clob         CLOB;
        v_sa_clob         CLOB;
        v_bgcolor         VARCHAR2(9);
        v_name            VARCHAR2(200);
        v_no_data         VARCHAR2(35)                         := '<tr><td>No Data Found</td></tr>';
        v_address_list    VARCHAR2(400)
            := '<table class="bTABLE"><tr><td class="bTD" width="55%"><strong><u>All Addresses:</u></strong></td><td class="bTD" width="15%"><strong><u>Start Date</u></strong></td><td class="bTD" width="15%"><strong><u>End Date</u></strong></td><td class="bTD" width="15%"><strong><u>Known Date</u></strong></td></tr>[TOKEN@ADDRESS_ROWS]</table>';

    BEGIN
        v_pv_sid := get_current_version(p_obj);
        v_date_fmt := Core_Util.get_config('CORE.DATE_FMT_DAY');
        -- Get the style for this report.
        v_ok :=
            Core_Template.get_latest('PARTIC_DETAILS_STYLE',
                                     v_temp_clob,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        -- Load up the main template.
        v_ok :=
            Core_Template.get_latest('PARTIC_DETAILS_MAIN',
                                     v_main_clob,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        -- Apply the style.
        v_ok := Core_Template.replace_tag(v_main_clob, 'STYLE', v_temp_clob);
        v_temp_clob := NULL;
        -- All this applies to every participant type.
        v_name := Osi_Participant.get_name(p_obj);
        v_ok := Core_Template.replace_tag(v_main_clob, 'TITLE_CONTENTS', v_name);
        v_ok := Core_Template.replace_tag(v_main_clob, 'CURRENT_NAME', v_name);

        -- Other names.
        FOR x IN (SELECT full_name, type_description AS TYPE
                    FROM v_osi_partic_name
                   WHERE participant_version = v_pv_sid)
        --AND is_current = 'N')
        LOOP
            Osi_Util.aitc(v_temp_clob, '<b>' || x.TYPE || '</b> - ' || x.full_name || '<br>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            v_ok := Core_Template.replace_tag(v_main_clob, 'OTHER_NAMES', '');
        ELSE
            v_ok := Core_Template.replace_tag(v_main_clob, 'OTHER_NAMES', v_temp_clob);
        END IF;

        v_temp_clob := NULL;

        -- Current address.
        FOR x IN (SELECT single_line
                    FROM v_osi_partic_address
                   WHERE participant = p_obj AND is_current = 'Y')
        LOOP
            Osi_Util.aitc(v_temp_clob, x.single_line);
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            v_temp_clob := '';
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'CURRENT_ADDRESS', v_temp_clob);
        v_temp_clob := NULL;

        FOR x IN (SELECT single_line, type_description AS TYPE, start_date, end_date, known_date
                    FROM v_osi_partic_address
                   WHERE participant = p_obj AND is_current = 'N' AND type_code <> 'BIRTH')
        LOOP
            v_counter := v_counter + 1;

            -- Alternate row colors.
            IF (MOD(v_counter, 2) = 0) THEN
                v_bgcolor := '"#f5f5f5"';
            ELSE
                v_bgcolor := '""';
            END IF;

            IF (x.single_line IS NOT NULL) THEN
                Osi_Util.aitc(v_temp_clob,
                              '<tr bgcolor=' || v_bgcolor || '><td class="bTD" width="55%"><STRONG>'
                              || x.TYPE || '</STRONG>' || ' - ' || x.single_line
                              || '</td><td class="bTD" width="15%">'
                              || Osi_Util.display_precision_date(x.start_date)
                              || ' </td><td class="bTD" width="15%">'
                              || Osi_Util.display_precision_date(x.end_date)
                              || ' </td><td class="bTD" width="15%">'
                              || Osi_Util.display_precision_date(x.known_date) || ' </td></tr>');
            END IF;
        END LOOP;

        v_counter := 0;

        IF (v_temp_clob IS NULL) THEN
            v_ok := Core_Template.replace_tag(v_main_clob, 'ADDRESS_LIST', '');
        ELSE
            -- v_address_list is the table that we will add rows of addresses to.
            v_ok := Core_Template.replace_tag(v_main_clob, 'ADDRESS_LIST', v_address_list);
            v_ok := Core_Template.replace_tag(v_main_clob, 'ADDRESS_ROWS', v_temp_clob);
        END IF;

        v_temp_clob := NULL;

        SELECT ot.code
          INTO v_ot_code
          FROM T_CORE_OBJ o, T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_obj AND o.obj_type = ot.SID;

        -- Individual only data.
        IF (v_ot_code = 'PART.INDIV') THEN
            -- Make the first cell a bit smaller to fit the mugshot in.
            v_ok := Core_Template.replace_tag(v_main_clob, 'IWIDTH', '80%');
            -- Set the colSpan attribute to the default.
            v_ok := Core_Template.replace_tag(v_main_clob, 'COLSPAN', '1');
            -- Remove the replacement tokens for the other participant types.
            v_ok := Core_Template.replace_tag(v_main_clob, 'NON_INDIV', '');
            
            -- Get the mugshot image.
            FOR x IN (SELECT   SID
                          FROM v_osi_partic_images
                         WHERE obj = p_obj order by seq,sid)
            LOOP
                Osi_Util.aitc(v_temp_clob,
                              '<td align="center"><img src="f?p=' || v( 'APP_ID') || ':801:'
                              || v( 'SESSION') || ':' || x.SID
                              || '" border="0" alt="Mugshot" style="vertical-align:top;"/></td>');
                --- Get the First Image ONLY ---
                exit;
            END LOOP;

            IF (v_temp_clob IS NULL) THEN
                Osi_Util.aitc(v_temp_clob,
                              '<td align="center"><strong>Image Not Available</strong></td>');
            END IF;

            v_ok := Core_Template.replace_tag(v_main_clob, 'MUGSHOT', v_temp_clob);
            v_temp_clob := NULL;
            -- Contact list data.
            Osi_Util.aitc(v_temp_clob, '<strong><u>Contact Information List:</u></strong><br>');

            -- Build the list of contact values.
            FOR x IN (SELECT r.description AS TYPE, c.VALUE
                        FROM T_OSI_PARTIC_CONTACT c, T_OSI_REFERENCE r
                       WHERE c.participant_version = v_pv_sid AND c.TYPE = r.SID)
            LOOP
                Osi_Util.aitc(v_temp_clob, x.TYPE || ' - ' || x.VALUE || '<br>');
            END LOOP;

            v_ok := Core_Template.replace_tag(v_main_clob, 'CONTACT_LIST', v_temp_clob);
            v_temp_clob := NULL;
            -- Physical information sub-template.
            v_ok :=
                Core_Template.get_latest('PARTIC_DETAILS_PHYSICAL',
                                         v_pc_clob,
                                         v_template_date,
                                         v_mime_type,
                                         v_mime_disp);

            FOR x IN (SELECT a.single_line
                        FROM v_osi_partic_address a
                       WHERE a.participant_version = v_pv_sid AND a.type_code = 'BIRTH')
            LOOP
                Osi_Util.aitc(v_temp_clob, x.single_line);
            END LOOP;

            v_ok := Core_Template.replace_tag(v_pc_clob, 'BIRTH_ADDRESS', v_temp_clob);
            v_temp_clob := NULL;

            -- Most of the physical data is handled here.
            FOR x IN (SELECT bi.nationality, FLOOR((SYSDATE - bi.dob) / 365) AS age, bi.dob,
                             bi.ethnicity_desc, pc.is_hard_of_hearing_desc, pc.hearing_comment,
                             pc.has_teeth_desc, pc.teeth_comment, pc.has_facial_hair_desc,
                             pc.facial_hair_comment, pc.wears_glasses_desc, pc.glasses_comment,
                             pc.is_bald_desc, pc.bald_comment, pc.height, pc.weight,
                             pc.hair_color_desc, pc.eye_color_desc, pc.sex_desc, pc.build_desc,
                             pc.posture_desc, pc.writing_hand_desc, pc.race_desc
                        FROM v_osi_partic_birth_info bi, v_osi_partic_physical_chars pc
                       WHERE pc.SID = bi.SID AND pc.SID = v_pv_sid)
            LOOP
                v_ok := Core_Template.replace_tag(v_pc_clob, 'NATIONALITY', x.nationality);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'AGE', x.age);
                v_ok :=
                     Core_Template.replace_tag(v_pc_clob, 'BIRTH_DATE', TO_CHAR(x.dob, v_date_fmt));
                v_ok := Core_Template.replace_tag(v_pc_clob, 'ETHNICITY', x.ethnicity_desc);
                v_ok :=
                    Core_Template.replace_tag(v_pc_clob,
                                              'IS_HARD_OF_HEARING',
                                              x.is_hard_of_hearing_desc);
                v_ok :=
                    Core_Template.replace_tag(v_pc_clob,
                                              'HARD_OF_HEARING_COMMENT',
                                              x.hearing_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'HAS_TEETH', x.has_teeth_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'TEETH_COMMENT', x.teeth_comment);
                v_ok :=
                     Core_Template.replace_tag(v_pc_clob, 'HAS_FACIAL_HAIR', x.has_facial_hair_desc);
                v_ok :=
                    Core_Template.replace_tag(v_pc_clob,
                                              'FACIAL_HAIR_COMMENT',
                                              x.facial_hair_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'WEARS_GLASSES', x.wears_glasses_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'GLASSES_COMMENT', x.glasses_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'IS_BALD', x.is_bald_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'BALD_COMMENT', x.bald_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'HEIGHT', x.height);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'WEIGHT', x.weight);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'HAIR_COLOR', x.hair_color_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'EYE_COLOR', x.eye_color_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'SEX', x.sex_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'BUILD', x.build_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'POSTURE', x.posture_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'WRITING_HAND', x.writing_hand_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'RACE', x.race_desc);
            END LOOP;

            -- Get citizenships.
            FOR x IN (SELECT d.description AS country
                        FROM T_OSI_PARTIC_CITIZENSHIP pc, T_DIBRS_COUNTRY d
                       WHERE pc.participant_version = v_pv_sid AND pc.country = d.SID)
            LOOP
                Osi_Util.aitc(v_temp_clob, x.country || '; ');
            END LOOP;

            v_ok := Core_Template.replace_tag(v_pc_clob, 'CITIZENSHIP', RTRIM(v_temp_clob, '; '));
            v_temp_clob := NULL;

            -- Get special marks.
            FOR x IN (SELECT m.description AS comment_txt, ml.description AS LOCATION,
                             mt.description AS TYPE
                        FROM T_OSI_PARTIC_MARK m,
                             T_DIBRS_MARK_LOCATION_TYPE ml,
                             T_DIBRS_MARK_TYPE mt
                       WHERE m.participant_version = v_pv_sid
                         AND m.mark_type = mt.SID
                         AND m.mark_location = ml.SID)
            LOOP
                IF (x.comment_txt IS NULL) THEN
                    Osi_Util.aitc(v_temp_clob, x.TYPE);
                ELSE
                    Osi_Util.aitc(v_temp_clob, x.comment_txt || '-' || x.TYPE);
                END IF;

                Osi_Util.aitc(v_temp_clob, '-' || x.LOCATION || ';');
            END LOOP;

            v_ok := Core_Template.replace_tag(v_pc_clob, 'SPECIAL_MARKS', RTRIM(v_temp_clob, '; '));
            v_temp_clob := NULL;
            -- Add the sub-template to the main template.
            v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_PHYSICAL', v_pc_clob);
            -- Service affiliation sub-template.
            v_ok :=
                Core_Template.get_latest('PARTIC_DETAILS_SA',
                                         v_sa_clob,
                                         v_template_date,
                                         v_mime_type,
                                         v_mime_disp);

            BEGIN
                SELECT *
                  INTO v_sa_record
                  FROM v_osi_partic_sa
                 WHERE SID = v_pv_sid;

                IF (   v_sa_record.service_desc IS NOT NULL
                    OR v_sa_record.pay_grade_desc IS NOT NULL
                    OR v_sa_record.pay_plan_desc IS NOT NULL
                    OR v_sa_record.rank IS NOT NULL
                    OR v_sa_record.rank_date IS NOT NULL
                    OR v_sa_record.component_desc IS NOT NULL
                    OR v_sa_record.affiliation_desc IS NOT NULL
                    OR v_sa_record.specialty_code IS NOT NULL
                    OR v_sa_record.fsa_rank IS NOT NULL
                    OR v_sa_record.fsa_equiv_rank IS NOT NULL
                    OR v_sa_record.fsa_rank_date IS NOT NULL) THEN
                    v_ok :=
                          Core_Template.replace_tag(v_sa_clob, 'SERVICE', v_sa_record.service_desc);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'PAY_GRADE',
                                                  v_sa_record.pay_grade_desc);
                    v_ok :=
                         Core_Template.replace_tag(v_sa_clob, 'PAY_PLAN', v_sa_record.pay_plan_desc);
                    v_ok := Core_Template.replace_tag(v_sa_clob, 'RANK', v_sa_record.rank);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'RANK_DATE',
                                                  TO_CHAR(v_sa_record.rank_date, v_date_fmt));
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob, 'COMPONENT',
                                                  v_sa_record.component_desc);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'AFFILIATION',
                                                  v_sa_record.affiliation_desc);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'SPECIALTY_CODE',
                                                  v_sa_record.specialty_code);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'FSA_SERVICE',
                                                  v_sa_record.fsa_service_desc);
                    v_ok := Core_Template.replace_tag(v_sa_clob, 'FSA_RANK', v_sa_record.fsa_rank);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'FSA_EQUIV_RANK',
                                                  v_sa_record.fsa_equiv_rank);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'FSA_RANK_DATE',
                                                  TO_CHAR(v_sa_record.fsa_rank_date, v_date_fmt));
                    -- Add the sub-template to the main template.
                    v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', v_sa_clob);
                ELSE
                    v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', '');
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', '');
            END;
        END IF;

        -- Nonindividual only data.
        IF (v_ot_code LIKE 'PART.NONINDIV%') THEN
            -- Make the first cell as wide as the table since there is no mugshot.
            v_ok := Core_Template.replace_tag(v_main_clob, 'IWIDTH', '100%');
            -- Set the colSpan attribute to 2 so any following table rows that have two columns
            -- won't mess up the first row.
            v_ok := Core_Template.replace_tag(v_main_clob, 'COLSPAN', '2');
            -- Remove the replacement tokens not applicable to these participant types.
            v_ok := Core_Template.replace_tag(v_main_clob, 'MUGSHOT', '');
            v_ok := Core_Template.replace_tag(v_main_clob, 'CONTACT_LIST', '');
            v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_PHYSICAL', '');
            v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', '');
            v_temp_clob := NULL;

            FOR x IN (SELECT r.description AS TYPE, n.co_cage, n.org_uic,
                             r2.description AS org_majcom, n.org_num_people,
                             DECODE(n.org_high_risk, 'Y', 'Yes', 'N', 'No', '') AS org_high_risk,
                             n.prog_description
                        FROM T_OSI_PARTICIPANT_NONHUMAN n, T_OSI_REFERENCE r, T_OSI_REFERENCE r2
                       WHERE n.sub_type = r.SID(+) AND n.org_majcom = r2.SID(+)
                             AND n.SID = v_pv_sid)
            LOOP
                IF (v_ot_code = 'PART.NONINDIV.COMP') THEN
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2" width="100%">');
                    Osi_Util.aitc(v_temp_clob, '<strong>Sub Type:</strong> ' || x.TYPE || '<br>');
                    Osi_Util.aitc(v_temp_clob, '<strong>Cage Code:</strong> ' || x.co_cage);
                    Osi_Util.aitc(v_temp_clob, '</td></tr>');
                ELSIF(v_ot_code = 'PART.NONINDIV.ORG') THEN
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2" width="100%">');
                    Osi_Util.aitc(v_temp_clob, '<strong>Sub Type:</strong> ' || x.TYPE || '<br>');
                    Osi_Util.aitc(v_temp_clob, '<strong>UIC:</strong> ' || x.org_uic || '<br>');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>Major Command:</strong> ' || x.org_majcom || '<br>');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>Number of People:</strong> ' || x.org_num_people
                                  || '<br>');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>High Risk:</strong> ' || x.org_high_risk || '<br>');
                    Osi_Util.aitc(v_temp_clob, '</td></tr>');
                    -- Time for organization specifics. Add the header row first.
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2"><strong>Specifics: </strong>');

                    FOR x IN (SELECT a.comments, AT.CATEGORY, AT.sub_category
                                FROM T_OSI_PARTIC_ORG_ATTR a, T_OSI_PARTIC_ORG_ATTR_TYPE AT
                               WHERE a.participant_version = v_pv_sid AND a.ATTRIBUTE = AT.SID(+))
                    LOOP
                        IF (v_counter = 0) THEN
                            -- Close the header row.
                            Osi_Util.aitc(v_temp_clob, '</td></tr>');
                        END IF;

                        v_counter := v_counter + 1;
                        Osi_Util.aitc(v_temp_clob,
                                      '<tr><td><strong>' || v_counter || '</strong></td>');
                        Osi_Util.aitc(v_temp_clob,
                                      '<td><strong>Category</strong> - ' || x.CATEGORY || '<br>');
                        Osi_Util.aitc(v_temp_clob,
                                      '<strong>Sub-Category</strong> - ' || x.sub_category || '<br>');
                        Osi_Util.aitc(v_temp_clob, '<strong>Comments</strong> - ' || x.comments);
                        Osi_Util.aitc(v_temp_clob, '</td></tr>');
                    END LOOP;

                    IF (v_counter = 0) THEN
                        Osi_Util.aitc(v_temp_clob, 'No Data Found');
                        -- Close the header row.
                        Osi_Util.aitc(v_temp_clob, '</td></tr>');
                    END IF;

                    v_counter := 0;
                ELSIF(v_ot_code = 'PART.NONINDIV.PROG') THEN
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2" width="100%">');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>Program Description:</strong> ' || x.prog_description);
                    Osi_Util.aitc(v_temp_clob, '</td></tr>');
                END IF;

                v_ok := Core_Template.replace_tag(v_main_clob, 'NON_INDIV', v_temp_clob);
                v_temp_clob := NULL;
            END LOOP;
        END IF;

        -- Remaining object data.
        v_counter := 0;

        -- Identifying Numbers.
        FOR x IN (SELECT   nt.description AS TYPE, n.num_value, ds.description AS issue_state,
                           dc.description AS issue_country, n.issue_province
                      FROM T_OSI_PARTIC_NUMBER n,
                           T_OSI_PARTIC_NUMBER_TYPE nt,
                           T_DIBRS_STATE ds,
                           T_DIBRS_COUNTRY dc
                     WHERE n.participant_version = v_pv_sid
                       AND n.num_type = nt.SID
                       AND n.issue_state = ds.SID(+)
                       AND n.issue_country = dc.SID(+)
                  ORDER BY TYPE)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || x.TYPE);
            Core_Util.append_info_to_clob(v_temp_clob, x.num_value);
            Core_Util.append_info_to_clob(v_temp_clob, x.issue_state);
            Core_Util.append_info_to_clob(v_temp_clob, x.issue_country);
            Core_Util.append_info_to_clob(v_temp_clob, x.issue_province);
            Osi_Util.aitc(v_temp_clob, '</td></td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ID_NUMBERS', v_temp_clob);
        v_temp_clob := NULL;
        -- Associated Activities
        -- TODO: Add Handling Instructions
        v_counter := 0;

        FOR x IN (SELECT SID, ROLE, activity, activity_date, ID, title
                    FROM v_osi_partic_act_involvement
                   WHERE participant_version = v_pv_sid)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || Osi_Object.get_open_link(x.activity, x.ID));
            Core_Util.append_info_to_clob(v_temp_clob, x.title);
            Core_Util.append_info_to_clob(v_temp_clob, x.ROLE || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ASSOCIATED_ACTIVITIES', v_temp_clob);
        v_temp_clob := NULL;
        -- Associated Files
        -- TODO: Add Handling Instructions
        v_counter := 0;

        FOR x IN (SELECT SID, ROLE, file_sid, ID, title
                    FROM v_osi_partic_file_involvement
                   WHERE participant_version = v_pv_sid)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || Osi_Object.get_open_link(x.file_sid, x.ID));
            Core_Util.append_info_to_clob(v_temp_clob, x.title);
            Core_Util.append_info_to_clob(v_temp_clob, x.ROLE || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ASSOCIATED_FILES', v_temp_clob);
        v_temp_clob := NULL;
        -- Attachments: The only ones we're interested in are mugshots.
        v_counter := 0;

        FOR x IN (SELECT SID, NVL(description, SOURCE) AS description, content
                    FROM v_osi_partic_images
                   WHERE obj = p_obj)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td><td>');

            IF (x.content IS NOT NULL) THEN
                Osi_Util.aitc(v_temp_clob,
                              '<a href="f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':'
                              || x.SID || '" target="blank"/>');
            END IF;

            Osi_Util.aitc(v_temp_clob, x.description || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ATTACHMENTS', v_temp_clob);
        v_temp_clob := NULL;
        -- Relationships
        v_counter := 0;

        FOR x IN (SELECT   this_participant, related_to,
                           DECODE(get_participant(v_pv_sid),
                                  this_participant, related_name,
                                  this_name) AS NAME,
                           description, specifics, comments, mod2_value
                      FROM v_osi_partic_relation
                     WHERE (   this_participant = get_participant(v_pv_sid)
                            OR related_to = get_participant(v_pv_sid))
                       AND description IS NOT NULL
                  ORDER BY description, NAME)
        LOOP
            IF (   (NVL(x.mod2_value, 'xxx') LIKE 'ORCON%')
                OR (NVL(x.mod2_value, 'xxx') LIKE 'LIMDIS%')) THEN
                --TODO: Replace with a system log entry.
                log_error
                    ('run_report_details: Object is ORCON or LIMDIS - User does not have permission to view document therefore no link will be generated');
            ELSE
                v_counter := v_counter + 1;
                Osi_Util.aitc(v_temp_clob,
                              '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');

                IF (x.related_to = v_pv_sid) THEN
                    Osi_Util.aitc
                            (v_temp_clob,
                             '<td>' || x.description || ': '
                             || Osi_Object.get_tagline_link(get_current_version(x.this_participant))
                             || '</td></tr>');
                ELSE
                    Osi_Util.aitc(v_temp_clob,
                                  '<td>' || x.description || ': '
                                  || Osi_Object.get_tagline_link(get_current_version(x.related_to))
                                  || '</td></tr>');
                END IF;

                IF (x.specifics IS NOT NULL) THEN
                    Osi_Util.aitc(v_temp_clob,
                                  '<tr><td></td><td bgcolor="#f5f5f5"><b>Specifics: </b>'
                                  || x.specifics || '</td></tr>');
                END IF;

                IF (LENGTH(x.comments) > 0) THEN
                    Osi_Util.aitc(v_temp_clob,
                                  '<tr><td></td><td bgcolor="#f5f5f5"><b>Comments: </b>'
                                  || x.comments || '</td></tr>');
                END IF;
            END IF;
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'RELATIONSHIPS', v_temp_clob);
        v_temp_clob := NULL;
        -- Notes
        v_counter := 0;

        FOR x IN (SELECT nt.description AS TYPE, n.create_on, n.note_text
                    FROM T_OSI_NOTE n, T_OSI_NOTE_TYPE nt
                   WHERE n.obj = p_obj AND n.note_type = nt.SID)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="25%"><strong>' || v_counter || ': ' || x.TYPE || '<br>'
                          || TO_CHAR(x.create_on, v_date_fmt || ' hh24:mi:ss') || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || Core_Util.html_ize(x.note_text) || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'NOTES', v_temp_clob);
        v_ok := Core_Util.serve_clob(v_main_clob);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('run_report_details: ' || SQLERRM);
            RAISE;
    END run_report_details;

    PROCEDURE set_address_sid(p_sid IN VARCHAR2) IS
    BEGIN
        v_address_sid := p_sid;
    END set_address_sid;

    PROCEDURE set_current_address(p_pvop IN VARCHAR2, p_address_sid IN VARCHAR2 := NULL) IS
        v_new_current   T_OSI_PARTIC_ADDRESS.SID%TYPE;
    BEGIN
        v_new_current := p_address_sid;

        IF (v_new_current IS NULL) THEN
            -- No address was given so find the latest one added.
            FOR x IN (SELECT   a.SID
                          FROM v_osi_partic_address a
                         WHERE (   a.participant_version = p_pvop
                                OR a.participant = p_pvop)
                      ORDER BY a.create_on DESC)
            LOOP
                v_new_current := x.SID;
                EXIT;
            END LOOP;
        END IF;

        UPDATE v_osi_participant_version
           SET current_address = v_new_current
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);
    END set_current_address;

    PROCEDURE set_current_name(p_pvop IN VARCHAR2, p_name_sid IN VARCHAR2 := NULL) IS
        v_new_current   T_OSI_PARTIC_NAME.SID%TYPE;
    BEGIN
        v_new_current := p_name_sid;

        IF (v_new_current IS NULL) THEN
            -- No name was given so see if there is a LEGAL name.
            BEGIN
                SELECT n.SID
                  INTO v_new_current
                  FROM T_OSI_PARTIC_NAME n,
                       v_osi_participant_version pv,
                       T_OSI_PARTIC_NAME_TYPE_MAP t
                 WHERE (   pv.SID = p_pvop
                        OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                   AND n.participant_version = pv.SID
                   AND n.name_type = t.SID
                   AND t.max_num = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_new_current := NULL;
            END;

            IF (v_new_current IS NULL) THEN
                -- There was no LEGAL name so get the latest name added.
                FOR x IN (SELECT   n.SID
                              FROM T_OSI_PARTIC_NAME n,
                                   v_osi_participant_version pv,
                                   T_OSI_PARTIC_NAME_TYPE t
                             WHERE (   pv.SID = p_pvop
                                    OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                               AND n.participant_version = pv.SID
                               AND n.name_type = t.SID
                          ORDER BY n.create_on DESC)
                LOOP
                    v_new_current := x.SID;
                    EXIT;
                END LOOP;
            END IF;
        END IF;

        UPDATE v_osi_participant_version
           SET current_name = v_new_current
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('set_current_name: ' || SQLERRM);
    END set_current_name;

    PROCEDURE set_image_sid(p_sid IN VARCHAR2) IS
    BEGIN
        v_image_sid := p_sid;
    END set_image_sid;

    /* Given an Object Type SID, USAGE and CODE - Returns the SID of the involvement type */
    FUNCTION get_inv_type_sid(p_obj_type IN VARCHAR2, p_usage IN VARCHAR2, p_code IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   T_OSI_PARTIC_ROLE_TYPE.SID%TYPE;
    BEGIN
        SELECT SID
          INTO v_return
          FROM T_OSI_PARTIC_ROLE_TYPE
         WHERE obj_type = p_obj_type AND USAGE = p_usage AND code = p_code;

        RETURN v_return;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --No matching TYPE SID was found
            RETURN NULL;
        WHEN OTHERS THEN
            --Some other error
            log_error('osi_participant.get_inv_type_sid: ' || SQLERRM);
            RAISE;
    END get_inv_type_sid;

    PROCEDURE import_legacy_part_version(
        p_legacy_person_version   IN   VARCHAR2,
        p_new_person              IN   VARCHAR2) IS
        --T_OSI_PERSON_CHARS Columns
        v_osi_person_chars_sex           T_OSI_PERSON_CHARS.sex%TYPE;
        v_osi_person_chars_eye_color     T_OSI_PERSON_CHARS.eye_color%TYPE;
        v_osi_person_chars_hair_color    T_OSI_PERSON_CHARS.hair_color%TYPE;
        v_osi_person_chars_blood_type    T_OSI_PERSON_CHARS.blood_type%TYPE;
        v_osi_person_chars_race          T_OSI_PERSON_CHARS.race%TYPE;
        v_osi_person_chars_sa_pay_plan   T_OSI_PERSON_CHARS.sa_pay_plan%TYPE;
        v_osi_person_chars_sa_pay_grad   T_OSI_PERSON_CHARS.sa_pay_grade%TYPE;
        v_osi_person_chars_sa_pay_band   T_OSI_PERSON_CHARS.sa_pay_band%TYPE;
        --T_OSI_PARTICIPANT_HUMAN Columns
        v_osi_partic_human_build         T_OSI_PARTICIPANT_HUMAN.BUILD%TYPE;
        v_osi_partic_human_posture       T_OSI_PARTICIPANT_HUMAN.posture%TYPE;
        v_osi_partic_human_writ_hand     T_OSI_PARTICIPANT_HUMAN.writing_hand%TYPE;
        v_osi_partic_human_rel_inv       T_OSI_PARTICIPANT_HUMAN.religion_involvement%TYPE;
        v_osi_partic_human_clearance     T_OSI_PARTICIPANT_HUMAN.clearance%TYPE;
        v_osi_partic_human_sa_service    T_OSI_PARTICIPANT_HUMAN.sa_service%TYPE;
        v_osi_partic_human_sa_affil      T_OSI_PARTICIPANT_HUMAN.sa_affiliation%TYPE;
        v_osi_partic_human_sa_comp       T_OSI_PARTICIPANT_HUMAN.sa_component%TYPE;
        v_osi_partic_human_sa_res        T_OSI_PARTICIPANT_HUMAN.sa_reservist%TYPE;
        v_osi_partic_human_sa_res_stat   T_OSI_PARTICIPANT_HUMAN.sa_reservist_status%TYPE;
        v_osi_partic_human_sa_res_type   T_OSI_PARTICIPANT_HUMAN.sa_reservist_type%TYPE;
        v_osi_partic_human_fsa_service   T_OSI_PARTICIPANT_HUMAN.fsa_service%TYPE;
        v_osi_partic_human_sus_io        T_OSI_PARTICIPANT_HUMAN.suspected_io%TYPE;
        v_osi_partic_human_known_io      T_OSI_PARTICIPANT_HUMAN.known_io%TYPE;
        v_osi_partic_human_bald          T_OSI_PARTICIPANT_HUMAN.is_bald%TYPE;
        v_osi_partic_human_hard_hear     T_OSI_PARTICIPANT_HUMAN.is_hard_of_hearing%TYPE;
        v_osi_partic_human_facial_hair   T_OSI_PARTICIPANT_HUMAN.has_facial_hair%TYPE;
        v_osi_partic_human_wear_glass    T_OSI_PARTICIPANT_HUMAN.wears_glasses%TYPE;
        v_osi_partic_human_has_teeth     T_OSI_PARTICIPANT_HUMAN.has_teeth%TYPE;
        --T_OSI_PARTICIPANT_NONHUMAN Columns
        v_osi_partic_nonh_sub_type       T_OSI_PARTICIPANT_NONHUMAN.SUB_TYPE%TYPE;
        v_osi_partic_nonh_co_cage        T_OSI_PARTICIPANT_NONHUMAN.CO_CAGE%TYPE;
        v_osi_partic_nonh_co_duns        T_OSI_PARTICIPANT_NONHUMAN.CO_DUNS%TYPE;
        v_osi_partic_nonh_org_uic        T_OSI_PARTICIPANT_NONHUMAN.ORG_UIC%TYPE;
        v_osi_partic_nonh_org_majcom     T_OSI_PARTICIPANT_NONHUMAN.ORG_MAJCOM%TYPE;
        v_osi_partic_nonh_org_highrisk   T_OSI_PARTICIPANT_NONHUMAN.ORG_HIGH_RISK%TYPE;
        v_osi_partic_nonh_org_nopeople   T_OSI_PARTICIPANT_NONHUMAN.ORG_NUM_PEOPLE%TYPE;
        v_osi_partic_nonh_org_suppunit   T_OSI_PARTICIPANT_NONHUMAN.ORG_SUPPORTING_UNIT%TYPE;
        v_osi_partic_nonh_prog_desc      T_OSI_PARTICIPANT_NONHUMAN.PROG_DESCRIPTION%TYPE;
        --T_OSI_PARTIC_NAME Columns
        v_osi_partic_name_name_type      T_OSI_PARTIC_NAME.name_type%TYPE;
        --T_OSI_ADDRESS Columns
        v_osi_address_address_type       T_OSI_ADDRESS.address_type%TYPE;
        --T_OSI_PARTIC_NUMBER Columns
        v_osi_partic_number_num_type     T_OSI_PARTIC_NUMBER.num_type%TYPE;
        --T_OSI_PARTIC_CONTACT Columns
        v_osi_partic_contact_type        T_OSI_PARTIC_CONTACT.TYPE%TYPE;
        --T_OSI_PARTIC_VEHICLE Columns
        v_osi_partic_vehicle_body_type   T_OSI_PARTIC_VEHICLE.body_type%TYPE;
        v_osi_partic_vehicle_role        T_OSI_PARTIC_VEHICLE.ROLE%TYPE;
        --Other
        v_new_sid_version                VARCHAR2(20);
        v_migration_cnt_total            NUMBER                                              := 0;
        v_new_sid_temp                   VARCHAR2(20);
        v_temp                           VARCHAR2(4000);
        v_current_address                T_OSI_PARTICIPANT_VERSION.current_address%TYPE;
        v_current_name                   T_OSI_PARTICIPANT_VERSION.current_name%TYPE;
        v_person_sid                     VARCHAR2(40);
        v_obj_type                       T_CORE_OBJ_TYPE.SID%TYPE;
        v_obj_desc                       VARCHAR2(200);
        v_subtype_sid                    VARCHAR2(20);
        v_subtype_desc                   VARCHAR2(200);

        FUNCTION handle_boolean(p_data IN NUMBER)
            RETURN VARCHAR2 IS
        BEGIN
            IF (p_data IS NOT NULL) THEN
                IF (p_data = -1) THEN
                    RETURN 'Y';
                ELSIF(p_data = 0) THEN
                    RETURN 'N';
                ELSE
                    --Probably do not need to account for this situation
                    RETURN 'U';
                END IF;
            ELSE
                RETURN 'U';
            END IF;

            --If all else fails
            RETURN 'U';
        END handle_boolean;

        PROCEDURE mark_as_mig(
            p_type      IN   VARCHAR2,
            p_old_sid   IN   VARCHAR2,
            p_new_sid   IN   VARCHAR2,
            p_parent    IN   VARCHAR2) IS
        BEGIN
            v_migration_cnt_total := v_migration_cnt_total + 1;

            INSERT INTO T_OSI_MIGRATION
                        (TYPE, old_sid, new_sid, date_time, num, PARENT)
                 VALUES (p_type, p_old_sid, p_new_sid, SYSDATE, v_migration_cnt_total, p_parent);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE;
        END mark_as_mig;
    BEGIN
        ----------------------------
        -- Get the object type reference row for this person version
        ----------------------------
        select sid, usage, description
          into v_subtype_sid, v_obj_desc, v_subtype_desc 
          from t_osi_reference  
         where description = (select decode(pt.description,
                                               'Individual','Individual',
                                               'Program','Program',
                                                pt.sub_description) 
                                from ref_t_person p, ref_t_person_version pv, ref_t_person_type pt
                               where pv.sid = p_legacy_person_version
                                 and pv.person = p.sid
                                 and pt.code = p.type_code
                                 and pt.sub_code = p.subtype_code);

        --Get object type SID
        v_obj_type := Core_Obj.lookup_objtype(v_obj_desc);

        --Get the T_PERSON SID
        SELECT person
          INTO v_person_sid
          FROM ref_v_person_version
         WHERE SID = p_legacy_person_version;

        --T_PERSON_VERSION
        FOR k IN (SELECT *
                    FROM ref_t_person_version
                   WHERE SID = p_legacy_person_version)
        LOOP
            --Participant Version Table - Insert
            INSERT INTO T_OSI_PARTICIPANT_VERSION
                        (participant, locked_on, locked_by)
                 VALUES (p_new_person, k.locked_on, k.locked_by)
              RETURNING SID
                   INTO v_new_sid_version;

         IF v_obj_desc = 'PART.INDIV' THEN
            --Get PERSON_CHARS columns [BEGIN]
            v_osi_person_chars_sex := Dibrs_Reference.lookup_ref_sid('SEX', UPPER(k.sex));
            IF (k.eye_color IS NOT NULL) THEN
                begin
                     SELECT SID INTO v_osi_person_chars_eye_color
                       FROM T_OSI_REFERENCE
                      WHERE USAGE = 'PERSON_EYE_COLOR' AND UPPER(description) = UPPER(k.eye_color);
                exception when others then

                         v_osi_person_chars_eye_color := NULL;
                         
                end;
            ELSE
                v_osi_person_chars_eye_color := NULL;
            END IF;

            IF (k.hair_color IS NOT NULL) THEN
                begin
                     SELECT SID INTO v_osi_person_chars_hair_color
                       FROM T_OSI_REFERENCE
                       WHERE USAGE = 'PERSON_HAIR_COLOR' AND UPPER(description) = UPPER(k.hair_color);
                exception when others then

                         v_osi_person_chars_hair_color := NULL;
                         
                end;
            ELSE
                v_osi_person_chars_hair_color := NULL;
            END IF;

            v_osi_person_chars_blood_type :=
                                     Osi_Reference.lookup_ref_sid('PERSON_BLOOD_TYPE', k.blood_type);
            v_osi_person_chars_race := Dibrs_Reference.get_race_sid(k.race);
            v_osi_person_chars_sa_pay_plan :=
                                           Dibrs_Reference.lookup_ref_sid('PAY_PLAN', k.sa_pay_plan);
            v_osi_person_chars_sa_pay_grad := Dibrs_Reference.get_pay_grade_sid(k.sa_pay_grade);
            v_osi_person_chars_sa_pay_band := Dibrs_Reference.get_pay_band_sid(k.sa_pay_band);

            --Get PERSON_CHARS columns [END]

            --Person Chars Table - Insert
            INSERT INTO T_OSI_PERSON_CHARS
                        (SID,
                         sex,
                         eye_color,
                         hair_color,
                         blood_type,
                         race,
                         sa_pay_plan,
                         sa_pay_grade,
                         sa_pay_band,
                         height,
                         weight,
                         education_level)
                 VALUES (v_new_sid_version,
                         v_osi_person_chars_sex,
                         v_osi_person_chars_eye_color,
                         v_osi_person_chars_hair_color,
                         v_osi_person_chars_blood_type,
                         v_osi_person_chars_race,
                         v_osi_person_chars_sa_pay_plan,
                         v_osi_person_chars_sa_pay_grad,
                         v_osi_person_chars_sa_pay_band,
                         k.height,
                         k.weight,
                         k.education_level);

            
          
            --Get PARTICIPANT_HUMAN columns [BEGIN]
            IF (k.BUILD IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_build
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_BUILD' AND UPPER(description) = UPPER(k.BUILD);
            ELSE
                v_osi_partic_human_build := NULL;
            END IF;

            IF (k.posture IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_posture
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_POSTURE' AND UPPER(description) = UPPER(k.posture);
            ELSE
                v_osi_partic_human_posture := NULL;
            END IF;

            IF (k.writing_hand IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_writ_hand
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_HAND' AND UPPER(description) = UPPER(k.writing_hand);
            ELSE
                v_osi_partic_human_writ_hand := NULL;
            END IF;

            IF (k.religious_involvement IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_rel_inv
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_RELIGION_INVOLVEMENT'
                   AND UPPER(description) = UPPER(k.religious_involvement);
            ELSE
                v_osi_partic_human_rel_inv := NULL;
            END IF;

            IF (k.clearance IS NOT NULL) THEN
                IF (k.clearance = 'CON') THEN
                    v_osi_partic_human_clearance :=
                                               Osi_Reference.lookup_ref_sid('INDIV_CLEARANCE', 'C');
                ELSIF(k.clearance = 'SEC') THEN
                    v_osi_partic_human_clearance :=
                                               Osi_Reference.lookup_ref_sid('INDIV_CLEARANCE', 'S');
                ELSE
                    v_osi_partic_human_clearance :=
                                       Osi_Reference.lookup_ref_sid('INDIV_CLEARANCE', k.clearance);
                END IF;
            ELSE
                v_osi_partic_human_clearance := NULL;
            END IF;

            v_osi_partic_human_sa_service :=
                                          Osi_Reference.lookup_ref_sid('SERVICE_TYPE', k.sa_service);
            v_osi_partic_human_sa_affil :=
                                 Osi_Reference.lookup_ref_sid('INDIV_AFFILIATION', k.sa_affiliation);
            v_osi_partic_human_sa_comp :=
                                   Osi_Reference.lookup_ref_sid('SERVICE_COMPONENT', k.sa_component);
            v_osi_partic_human_sa_res := handle_boolean(k.sa_reservist);
            v_osi_partic_human_sa_res_stat :=
                         Osi_Reference.lookup_ref_sid('INDIV_RESERVE_STATUS', k.sa_reservist_status);
            v_osi_partic_human_sa_res_type :=
                             Osi_Reference.lookup_ref_sid('INDIV_RESERVE_TYPE', k.sa_reservist_type);
            v_osi_partic_human_fsa_service :=
                                       Dibrs_Reference.lookup_ref_sid('SERVICE_TYPE', k.fsa_service);
            v_osi_partic_human_sus_io := handle_boolean(k.suspected_io);
            v_osi_partic_human_known_io := handle_boolean(k.known_io);
            v_osi_partic_human_bald := handle_boolean(k.is_bald);
            v_osi_partic_human_hard_hear := handle_boolean(k.is_hard_of_hearing);
            v_osi_partic_human_facial_hair := handle_boolean(k.has_facial_hair);
            v_osi_partic_human_wear_glass := handle_boolean(k.wears_glasses);
            v_osi_partic_human_has_teeth := handle_boolean(k.has_teeth);

            --Get PARTICIPANT_HUMAN columns [END]
            INSERT INTO T_OSI_PARTICIPANT_HUMAN
                        (SID,
                         age_low,
                         age_high,
                         BUILD,
                         posture,
                         writing_hand,
                         religion,
                         religion_involvement,
                         clearance,
                         sa_service,
                         sa_affiliation,
                         sa_component,
                         sa_rank,
                         sa_rank_date,
                         sa_specialty_code,
                         sa_reservist,
                         sa_reservist_status,
                         sa_reservist_type,
                         fsa_service,
                         fsa_rank,
                         fsa_equiv_rank,
                         fsa_rank_date,
                         suspected_io,
                         known_io,
                         is_bald,
                         bald_comment,
                         is_hard_of_hearing,
                         hearing_comment,
                         has_facial_hair,
                         facial_hair_comment,
                         wears_glasses,
                         glasses_comment,
                         has_teeth,
                         teeth_comment,
                         deers_date)
                 VALUES (v_new_sid_version,
                         k.age_low,
                         k.age_high,
                         v_osi_partic_human_build,
                         v_osi_partic_human_posture,
                         v_osi_partic_human_writ_hand,
                         k.religious_affiliation,
                         v_osi_partic_human_rel_inv,
                         v_osi_partic_human_clearance,
                         v_osi_partic_human_sa_service,
                         v_osi_partic_human_sa_affil,
                         v_osi_partic_human_sa_comp,
                         k.sa_rank,
                         k.sa_rank_date,
                         k.sa_specialty_code,
                         v_osi_partic_human_sa_res,
                         v_osi_partic_human_sa_res_stat,
                         v_osi_partic_human_sa_res_type,
                         v_osi_partic_human_fsa_service,
                         k.fsa_rank,
                         k.fsa_equiv_rank,
                         k.fsa_rank_date,
                         v_osi_partic_human_sus_io,
                         v_osi_partic_human_known_io,
                         v_osi_partic_human_bald,
                         k.bald_comment,
                         v_osi_partic_human_hard_hear,
                         k.hard_of_hearing_comment,
                         v_osi_partic_human_facial_hair,
                         k.facial_hair_comment,
                         v_osi_partic_human_wear_glass,
                         k.glasses_comment,
                         v_osi_partic_human_has_teeth,
                         k.teeth_comment,
                         k.deers_date);

         ELSE  ----------------------------
               -- GET PART.NONINDIV COLUMNS
               ----------------------------
               IF v_subtype_sid IS NOT NULL THEN
                  v_osi_partic_nonh_sub_type := v_subtype_sid;
               END IF;
               IF k.co_cage IS NOT NULL THEN
                  v_osi_partic_nonh_co_cage := k.co_cage;
               ELSE
                  v_osi_partic_nonh_co_cage := null;
               END IF;
               IF k.co_duns IS NOT NULL THEN
                  v_osi_partic_nonh_co_duns := k.co_duns;
               ELSE
                  v_osi_partic_nonh_co_duns := null;
               END IF;
               IF k.org_uic IS NOT NULL THEN
                  v_osi_partic_nonh_org_uic := k.org_uic;
               ELSE
                  v_osi_partic_nonh_org_uic := null;
               END IF;
               IF k.org_majcom IS NOT NULL THEN
                SELECT SID
                  INTO v_osi_partic_nonh_org_majcom
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'MAJCOM' AND code = k.org_majcom;
               ELSE
                    v_osi_partic_nonh_org_majcom := NULL;
               END IF;
               IF k.org_high_risk IS NOT NULL THEN
                  IF k.org_high_risk <> 0 then
                         v_osi_partic_nonh_org_highrisk := 'Y';
                  ELSE
                         v_osi_partic_nonh_org_highrisk := 'N';
                  END IF;
               ELSE
                  v_osi_partic_nonh_org_highrisk := 'U'; --unknown
               END IF;
               IF k.org_num_people IS NOT NULL THEN
                  v_osi_partic_nonh_org_nopeople := k.org_num_people;
               ELSE
                  v_osi_partic_nonh_org_nopeople := null;
               END IF;
               IF k.org_supporting_unit IS NOT NULL THEN
                 SELECT NEW_SID
                   INTO v_osi_partic_nonh_org_suppunit
                   FROM T_OSI_MIGRATION
                  WHERE OLD_SID = k.org_supporting_unit;
               ELSE
                  v_osi_partic_nonh_org_suppunit := null;
               END IF;
               IF k.prog_description IS NOT NULL THEN
                  v_osi_partic_nonh_prog_desc := k.prog_description;
               ELSE
                  v_osi_partic_nonh_prog_desc := null;
               END IF;

               INSERT INTO T_OSI_PARTICIPANT_NONHUMAN
                           (SID,
                            sub_type,
                            co_cage,
                            co_duns,
                            org_uic,
                            org_majcom,
                            org_high_risk,
                            org_num_people,
                            org_supporting_unit,
                            prog_description)
                    VALUES (v_new_sid_version,
                            v_osi_partic_nonh_sub_type,
                            v_osi_partic_nonh_co_cage,
                            v_osi_partic_nonh_co_duns,
                            v_osi_partic_nonh_org_uic,
                            v_osi_partic_nonh_org_majcom,
                            v_osi_partic_nonh_org_highrisk,
                            v_osi_partic_nonh_org_nopeople,
                            v_osi_partic_nonh_org_suppunit,
                            v_osi_partic_nonh_prog_desc);
                        
         END IF;


        END LOOP;

        mark_as_mig('PARTICIPANT_VERSION', p_legacy_person_version, v_new_sid_version, p_new_person);

        --T_PERSON_CITIZENSHIP Table
        FOR k IN (SELECT *
                    FROM ref_t_person_citizenship
                   WHERE person_version = p_legacy_person_version)
        LOOP
            INSERT INTO T_OSI_PARTIC_CITIZENSHIP
                        (participant_version, country, effective_date)
                 VALUES (v_new_sid_version,
                         Dibrs_Reference.get_country_sid(k.country),
                         k.effective_date)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_CITIZENSHIP', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_MARK
        FOR k IN (SELECT *
                    FROM ref_t_person_mark
                   WHERE person_version = p_legacy_person_version)
        LOOP
            INSERT INTO T_OSI_PARTIC_MARK
                        (participant_version, mark_type, mark_location, description)
                 VALUES (v_new_sid_version,
                         Dibrs_Reference.get_mark_type_sid(k.type_code),
                         Dibrs_Reference.get_mark_location_type_sid(k.loc_code),
                         k.description)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_MARK', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_NAME
        FOR k IN (SELECT *
                    FROM ref_t_person_name
                   WHERE person_version = p_legacy_person_version)
        LOOP
            --Get Columns
            IF (k.name_type IS NOT NULL) THEN
                BEGIN
                    SELECT DESCRIPTION 
                      INTO v_temp
                      FROM ref_t_person_name_type
                     WHERE code = k.name_type;
                EXCEPTION
                        WHEN OTHERS THEN
                            log_error('import_legacy_part_version: Error locating description for name_type: ' || k.name_type || ' ' || SQLERRM);
                END;

                --Shouldn't need this try/catch, but have it in place for non-indiv folks
                BEGIN
                    SELECT SID
                      INTO v_osi_partic_name_name_type
                      FROM T_OSI_PARTIC_NAME_TYPE
                     WHERE UPPER(DESCRIPTION) = UPPER(v_temp);
                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('Bad Type : [' || k.name_type || ']');
                END;
            ELSE
                v_osi_partic_name_name_type := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_NAME
                        (participant_version,
                         name_type,
                         title,
                         last_name,
                         first_name,
                         middle_name,
                         cadency)
                 VALUES (v_new_sid_version,
                         v_osi_partic_name_name_type,
                         k.title,
                         k.last_name,
                         k.first_name,
                         k.middle_name,
                         k.cadency)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_NAME', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_ADDRESS_V2
        --Clear Current Address
        v_current_address := NULL;

        FOR k IN (SELECT *
                    FROM ref_t_address_v2
                   WHERE PARENT = p_legacy_person_version
                      OR PARENT = v_person_sid)
        LOOP
            CASE upper(k.addr_type)
                WHEN 'PERMANENT' THEN
                    v_osi_address_address_type :=
                                         Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'PERM');
                WHEN 'EDUCATION' THEN
                    v_osi_address_address_type :=
                                           Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'ED');
                WHEN 'EMPLOYMENT' THEN
                    v_osi_address_address_type :=
                                          Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'EMP');
                WHEN 'MAIL' THEN
                    v_osi_address_address_type :=
                                         Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'MAIL');
                WHEN 'OTHER' THEN
                    v_osi_address_address_type :=
                                          Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'OTH');
                WHEN 'RESIDENCE' THEN
                    v_osi_address_address_type :=
                                          Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'RES');
                WHEN 'TEMPORARY' THEN
                    v_osi_address_address_type :=
                                         Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'TEMP');
                WHEN 'BIRTH' THEN
                    v_osi_address_address_type :=
                                            Osi_Address.get_addr_type(v_obj_type, 'BIRTH', 'BIRTH');
            END CASE;

            --Create Address Record, Tied to PERSON
            INSERT INTO T_OSI_ADDRESS
                        (obj,
                         address_type,
                         address_1,
                         address_2,
                         city,
                         province,
                         state,
                         postal_code,
                         country,
                         geo_coords,
                         start_date,
                         end_date,
                         known_date,
                         comments)
                 VALUES (p_new_person,
                         v_osi_address_address_type,
                         k.addr_1,
                         k.addr_2,
                         k.addr_city,
                         k.addr_province,
                         Dibrs_Reference.get_state_sid(k.addr_state),
                         k.addr_zip,
                         Dibrs_Reference.get_country_sid(k.addr_country),
                         k.geo_coords,
                         k.start_date,
                         k.end_date,
                         k.known_date,
                         k.comments)
              RETURNING SID
                   INTO v_new_sid_temp;

            --Create Participant Address Record, Tied to PERSON_VERSION
            IF (k.PARENT <> v_person_sid) THEN
                --Only need to tie the PERSON_VERSION (non birth) to the version
                INSERT INTO T_OSI_PARTIC_ADDRESS
                            (participant_version, address)
                     VALUES (v_new_sid_version, v_new_sid_temp)
                  RETURNING SID
                       INTO v_new_sid_temp;
            END IF;

            mark_as_mig('PARTICIPANT_ADDRESS',
                        k.SID,
                        v_new_sid_temp,
                        '~' || p_new_person || '~' || v_new_sid_version || '~');

            --Check for Current Address
            IF (k.selected = -1 AND k.PARENT = p_legacy_person_version) THEN
                v_current_address := v_new_sid_temp;
            END IF;
        END LOOP;

        --Numbers
        FOR k IN (SELECT *
                    FROM ref_t_person_number
                   WHERE person_version = p_legacy_person_version)
        LOOP
            v_temp := NULL;

            IF (k.num_type = 'OTHER') THEN
                v_temp := 'OID';
            ELSE
                v_temp := k.num_type;
            END IF;

            SELECT SID
              INTO v_osi_partic_number_num_type
              FROM T_OSI_PARTIC_NUMBER_TYPE
             WHERE code = v_temp;

            INSERT INTO T_OSI_PARTIC_NUMBER
                        (participant_version,
                         num_type,
                         num_value,
                         issue_date,
                         issue_country,
                         issue_state,
                         issue_province,
                         expire_date,
                         note)
                 VALUES (v_new_sid_version,
                         v_osi_partic_number_num_type,
                         k.num_value,
                         k.issue_date,
                         Dibrs_Reference.get_country_sid(k.issue_country),
                         Dibrs_Reference.get_state_sid(k.issue_state),
                         k.issue_province,
                         k.expire_date,
                         k.note)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_NUMBER', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --Contact Info
        FOR k IN (SELECT *
                    FROM ref_t_phone_email
                   WHERE PARENT = p_legacy_person_version)
        LOOP
            IF (k.pe_category IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_contact_type
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'CONTACT_TYPE' AND UPPER(description) = UPPER(k.pe_category);
            --Need to UPPER() above because Legacy Val is DSN-Fax and Web Val is DSN-FAX
            ELSE
                v_osi_partic_contact_type := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_CONTACT
                        (participant_version, TYPE, VALUE)
                 VALUES (v_new_sid_version, v_osi_partic_contact_type, k.pe_value)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_CONTACT', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_ORG_ATTR
        FOR k IN (SELECT *
                    FROM ref_t_person_org_attr
                   WHERE person_version = p_legacy_person_version)
        LOOP
            IF (k.ATTRIBUTE IS NOT NULL) THEN
                SELECT SID
                  INTO v_temp
                  FROM T_OSI_PARTIC_ORG_ATTR_TYPE
                 WHERE code = k.ATTRIBUTE;
            ELSE
                v_temp := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_ORG_ATTR
                        (participant_version, ATTRIBUTE, comments)
                 VALUES (v_new_sid_version, v_temp, k.comments);

            mark_as_mig('PARTICIPANT_ORG_ATTR', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_VEHICLE
        FOR k IN (SELECT *
                    FROM ref_t_person_vehicle
                   WHERE person_version = p_legacy_person_version)
        LOOP
            --Get Body Type (From Description)
            IF (k.body_type IS NOT NULL) THEN
                SELECT description
                  INTO v_temp
                  FROM wcc_ref_t_person_vehicle_bt
                 WHERE SID = k.body_type;

                BEGIN
                    SELECT SID
                      INTO v_osi_partic_vehicle_body_type
                      FROM T_OSI_REFERENCE
                     WHERE USAGE = 'VEHICLE_BODY' AND description = v_temp;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_osi_partic_vehicle_body_type := NULL;
                END;
            ELSE
                v_osi_partic_vehicle_body_type := NULL;
            END IF;

            --Get Role (From Description)
            IF (k.ROLE IS NOT NULL) THEN
                SELECT description
                  INTO v_temp
                  FROM wcc_ref_t_person_vehicle_roles
                 WHERE SID = k.ROLE;

                BEGIN
                    SELECT SID
                      INTO v_osi_partic_vehicle_role
                      FROM T_OSI_REFERENCE
                     WHERE USAGE = 'VEHICLE_ROLE' AND description = v_temp;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_osi_partic_vehicle_role := NULL;
                END;
            ELSE
                v_osi_partic_vehicle_role := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_VEHICLE
                        (participant_version,
                         plate_num,
                         reg_exp_date,
                         reg_country,
                         reg_state,
                         reg_province,
                         title_owner,
                         vin,
                         make,
                         MODEL,
                         YEAR,
                         color,
                         body_type,
                         gross_weight,
                         num_axles,
                         ROLE,
                         comments)
                 VALUES (v_new_sid_version,
                         k.plate_num,
                         k.reg_exp_date,
                         Dibrs_Reference.get_country_sid(k.reg_country),
                         Dibrs_Reference.get_state_sid(k.reg_state),
                         k.reg_province,
                         k.title_num,
                         k.vin,
                         k.vehicle_make,
                         k.vehicle_model,
                         k.vehicle_year,
                         k.vehicle_color,
                         v_osi_partic_vehicle_body_type,
                         k.gross_weight,
                         k.num_axles,
                         v_osi_partic_vehicle_role,
                         k.comments)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_VEHICLE', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_DATE
        FOR k IN (SELECT *
                    FROM wcc_ref_t_date
                   WHERE PARENT = p_legacy_person_version)
        LOOP
            --Get Date Type (From Description)
            IF (k.date_type IS NOT NULL) THEN
                BEGIN
                    SELECT SID
                      INTO v_temp
                      FROM T_OSI_REFERENCE
                     WHERE USAGE = DECODE(v_obj_desc, 'PART.INDIV','INDIV_DATE','NON_INDIV_DATE') 
                       AND description = k.date_type;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_temp := NULL;
                END;
            ELSE
                v_temp := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_DATE
                        (participant_version, TYPE, VALUE, comments)
                 VALUES (v_new_sid_version, v_temp, k.date_value, k.comments)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_DATE', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --FINALIZATION STUFF

        --TODO, probably should a p_current to the function and only update when set to Y

        --Update Current Name and Current Address[BEGIN]
        --v_current_name
        v_current_name := NULL;

        FOR k IN (SELECT ind_curr_name
                    FROM ref_t_person_version
                   WHERE SID = p_legacy_person_version)
        LOOP
            v_current_name := k.ind_curr_name;
        END LOOP;

        FOR k IN (SELECT new_sid
                    FROM T_OSI_MIGRATION
                   WHERE old_sid = v_current_name AND PARENT = v_new_sid_version)
        LOOP
            v_current_name := k.new_sid;
        END LOOP;
        
        UPDATE T_OSI_PARTICIPANT_VERSION
           SET current_name = v_current_name,
               current_address = v_current_address
         WHERE SID = v_new_sid_version;
    --Update Current Name and Current Address[END]
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_participant.import_legacy_part_version: ' || SQLERRM || ' ' || dbms_utility.format_error_backtrace || ' using legacy version: ' || p_legacy_person_version);
            RAISE;
    END import_legacy_part_version;

    FUNCTION import_legacy_participant(p_person_version IN VARCHAR2, p_import_relations IN VARCHAR2 := 'Y')
        RETURN VARCHAR2 IS
        v_temp                          VARCHAR2(4000);
        v_temp2                         VARCHAR2(4000);
        v_temp_clob                     CLOB;
        v_person_sid                    VARCHAR2(40);
        v_obj_type                      T_CORE_OBJ_TYPE.SID%TYPE;
        v_new_sid                       T_CORE_OBJ.SID%TYPE;
        v_new_sid_version               T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_new_sid_temp                  VARCHAR2(20);
        v_migration_cnt_total           NUMBER                               := 0;
        v_current_version_sid           VARCHAR2(20);
        --T_OSI_PARTICIPANT Columns
        v_osi_participant_ethnicity     T_OSI_PARTICIPANT.ethnicity%TYPE;
        --T_OSI_NOTE Columns
        v_osi_note_note_type            T_OSI_NOTE.note_type%TYPE;
        v_osi_note_creating_personnel   T_OSI_NOTE.creating_personnel%TYPE;
        v_result                        VARCHAR2(200);
        v_obj_desc                      VARCHAR2(200);
        v_create_by                     varchar2(100);
        v_atch_seq                      NUMBER := 0;

        PROCEDURE mark_as_mig(
            p_type      IN   VARCHAR2,
            p_old_sid   IN   VARCHAR2,
            p_new_sid   IN   VARCHAR2,
            p_parent    IN   VARCHAR2,
            p_imp_rel   IN   VARCHAR2 := NULL) IS
        BEGIN
            v_migration_cnt_total := v_migration_cnt_total + 1;

            INSERT INTO T_OSI_MIGRATION
                        (TYPE, old_sid, new_sid, date_time, num, PARENT, imp_relations)
                 VALUES (p_type, p_old_sid, p_new_sid, SYSDATE, v_migration_cnt_total, p_parent, p_imp_rel);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE;
        END mark_as_mig;

        FUNCTION get_part_rel_info(p_person IN VARCHAR2)
            RETURN CLOB IS
            v_file_begin   VARCHAR2(2000)
                := '{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}} {\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20';
            v_file_end     VARCHAR2(2000)  := '\par }';
            v_return       CLOB;
            v_temp1        CLOB;--VARCHAR2(20000);
            v_cnt          NUMBER;
        BEGIN
             if p_import_relations = 'N' then
             
               return null;
               
             end if;
             
            --Start File
            v_return := v_file_begin;
            --*****Header
            v_temp1 :=
                'Relational data for: ' || ref_person.current_name(p_person) || ' \par  As of: '
                || SYSDATE || ' \par\par ';
            v_return := v_return || v_temp1;
            v_temp1 := '';
            --*****Associated Activities
            v_temp1 := NULL;
            v_cnt := 0;
            v_temp1 := '\b ASSOCIATED ACTIVITIES \b0 \par \par ';

            FOR k IN (SELECT DISTINCT ID, title, subtype_desc, involvement_role, SID
                                 FROM ref_v_person_act_inv
                                WHERE person = p_person)
            LOOP
                --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
                IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                    AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                    v_cnt := v_cnt + 1;
                    v_temp1 :=
                            v_temp1 || '\b ' || v_cnt || '.> \b0 Activity ID: ' || k.ID || ' \par ';
                    v_temp1 := v_temp1 || 'Activity Title: ' || k.title || ' \par ';
                    v_temp1 := v_temp1 || 'Activity Type: ' || k.subtype_desc || ' \par ';
                    v_temp1 :=
                         v_temp1 || 'Activity Involvement Role: ' || k.involvement_role || ' \par ';
                    v_temp1 := v_temp1 || ' \par ';
                END IF;
            END LOOP;

            IF v_cnt = 0 THEN
                v_temp1 := v_temp1 || 'No Data Found \par ';
            END IF;

            --Concatonate the activities
            v_return := v_return || v_temp1 || ' \par ';
            --Clear buffer(s)
            v_temp1 := NULL;
            v_cnt := 0;
            v_temp1 := '\b ASSOCIATED FILES \b0 \par \par ';

            --*****Associated Files
            FOR k IN (SELECT DISTINCT ID, title, type_desc, subtype_desc, involvement_role, SID
                                 FROM ref_v_person_file_inv
                                WHERE person = p_person)
            LOOP
                --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
                IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                    AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                    v_cnt := v_cnt + 1;
                    v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 File ID: ' || k.ID || ' \par ';
                    v_temp1 := v_temp1 || 'File Title: ' || k.title || ' \par ';
                    v_temp1 := v_temp1 || 'File Type: ' || k.type_desc || ' \par ';
                    v_temp1 := v_temp1 || 'File Sub Type: ' || k.subtype_desc || ' \par ';
                    v_temp1 :=
                             v_temp1 || 'File Involvement Role: ' || k.involvement_role || ' \par ';
                    v_temp1 := v_temp1 || ' \par ';
                END IF;
            END LOOP;

            IF v_cnt = 0 THEN
                v_temp1 := v_temp1 || 'No Data Found \par ';
            END IF;

            --Concatonate the files
            v_return := v_return || v_temp1 || ' \par ';
            --Clear buffer(s)
            v_temp1 := NULL;
            v_cnt := 0;
            v_temp1 := '\b RELATIONSHIPS \b0 \par \par ';

            --*****Relationships
            FOR k IN (SELECT *
                        FROM ref_v_person_relation
                       WHERE this_person = p_person)
            LOOP
                IF (    (NVL(k.mod2_value, 'xxx') NOT LIKE 'ORCON%')
                    AND (NVL(k.mod2_value, 'xxx') NOT LIKE 'LIMDIS%')) THEN
                    IF (k.rel_desc IS NOT NULL) THEN
                        v_cnt := v_cnt + 1;
                        v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 ' || k.rel_desc || ' \par ';
                        v_temp1 := v_temp1 || 'Participant: ' || k.that_name || ' \par ';

                        -- add specifics if any
                        IF (k.rel_specifics IS NOT NULL) THEN
                            v_temp1 := v_temp1 || 'Specifics: ' || k.rel_specifics || ' \par ';
                        END IF;

                        -- add comments if any
                        IF (k.comments IS NOT NULL) THEN
                            v_temp1 := v_temp1 || 'Comments: ' || k.comments || ' \par ';
                        END IF;

                        v_temp1 := v_temp1 || ' \par ';
                    END IF;
                END IF;
            END LOOP;

            IF v_cnt = 0 THEN
                v_temp1 := v_temp1 || 'No Data Found \par ';
            END IF;

            --Concatonate the files
            v_return := v_return || v_temp1 || ' \par ';
            --Finish off file
            v_return := v_return || v_file_end;
            --Send home
            RETURN v_return;
        END get_part_rel_info;
    BEGIN
        ----------------------------
        -- Get the object type reference row for this person version
        ----------------------------
        log_error('import_legacy_relationships: STATUS - fetching the object description for version: ' || p_person_version);
        select usage
          into v_obj_desc 
          from t_osi_reference  
         where usage like 'PART.%'
           and description = (select decode(pt.description,
                                               'Individual','Individual',
                                               'Program','Program',
                                                pt.sub_description)                                 
                                from ref_t_person p, ref_t_person_version pv, ref_t_person_type pt
                               where pv.sid = p_person_version
                                 and pv.person = p.sid
                                 and pt.code = p.type_code
                                 and pt.sub_code = p.subtype_code);

        --Get object type SID
        v_obj_type := Core_Obj.lookup_objtype(v_obj_desc);

        --Get the T_PERSON SID
        SELECT person
          INTO v_person_sid
          FROM ref_v_person_version
         WHERE SID = p_person_version;

        --CORE_OBJ Record - Insert
        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (v_obj_type)
          RETURNING SID
               INTO v_new_sid;

        --Main Participant Record
        FOR k IN (SELECT *
                    FROM ref_t_person
                   WHERE SID = v_person_sid)
        LOOP
            --Get Ethnicity
            v_osi_participant_ethnicity := Dibrs_Reference.lookup_ref_sid('ETHNICITY', k.ethnicity);

            --Main Part Record - Insert
            INSERT INTO T_OSI_PARTICIPANT
                        (SID,
                         unknown_flag,
                         confirm_on,
                         confirm_by,
                         dod_edi_pn_id,
                         dob,
                         dod,
                         ethnicity,
                         nationality,
                         details_lock)
                 VALUES (v_new_sid,
                         'N',
                         k.confirm_on,
                         k.confirm_by,
                         k.dod_edi_pn_id,
                         k.birth_date,
                         k.decease_date,
                         v_osi_participant_ethnicity,
                         k.nationality,
                         k.lock_details)
              RETURNING SID
                   INTO v_new_sid_temp;

            --Save off the Confirmed By field for use below
            v_temp := k.confirm_by;
            mark_as_mig('PARTICIPANT', k.SID, v_new_sid_temp, '', p_import_relations);
        END LOOP;

        --Give the participant a starting status
        Osi_Status.change_status_brute
                             (v_new_sid,
                              Osi_Status.get_starting_status(Core_Obj.lookup_objtype(v_obj_desc)),
                              'Created');

        --If person is confirmed, need to change their status to show it
        IF (v_temp IS NOT NULL) THEN
            --Get status change
            SELECT SID
              INTO v_temp
              FROM T_OSI_STATUS_CHANGE
             WHERE obj_type = Core_Obj.lookup_objtype(v_obj_desc)
               AND from_status =
                               Osi_Status.get_starting_status(Core_Obj.lookup_objtype(v_obj_desc))
               AND UPPER(transition) = 'CONFIRM';

            Osi_Status.change_status(v_new_sid, v_temp);
        END IF;

        --Notes
        --Transfer the notes to the temp table
        DELETE FROM T_OSI_MIGRATION_NOTES;

        INSERT INTO T_OSI_MIGRATION_NOTES
            SELECT *
              FROM ref_t_note_v2
             WHERE PARENT = v_person_sid;

        FOR k IN (SELECT *
                    FROM T_OSI_MIGRATION_NOTES
                   WHERE PARENT = v_person_sid)
        LOOP
            --Get Category
            IF (k.CATEGORY IS NOT NULL) THEN
                BEGIN
                    SELECT SID
                      INTO v_osi_note_note_type
                      FROM T_OSI_NOTE_TYPE
                     WHERE obj_type = Core_Obj.lookup_objtype(v_obj_desc)
                       AND USAGE = 'NOTELIST'
                       AND UPPER(description) = UPPER(k.CATEGORY);
                EXCEPTION
                    WHEN OTHERS THEN
                        --If not type is not found, then use the 'Additional Info' note.
                        v_osi_note_note_type :=
                            Osi_Note.get_note_type(Core_Obj.lookup_objtype(v_obj_desc),
                                                   'ADD_INFO');
                END;
            ELSE
                --Category should never be null, but if it is, just use "Additional Info" note.
                v_osi_note_note_type :=
                          Osi_Note.get_note_type(Core_Obj.lookup_objtype(v_obj_desc), 'ADD_INFO');
            END IF;

            --Get Creating Personnel
            IF (k.personnel IS NOT NULL) THEN
                BEGIN
                    SELECT new_sid
                      INTO v_osi_note_creating_personnel
                      FROM T_OSI_MIGRATION
                     WHERE TYPE = 'PERSONNEL' AND old_sid = k.personnel;
                EXCEPTION
                    WHEN OTHERS THEN
                        --If personnel is not found, then use the current personnel
                        v_osi_note_creating_personnel := Core_Context.personnel_sid;
                END;
            ELSE
                --Personnel should never be null, but if it is, use the current User.
                v_osi_note_creating_personnel := Core_Context.personnel_sid;
            END IF;

            INSERT INTO T_OSI_NOTE
                        (obj, note_type, note_text, creating_personnel, lock_mode)
                 VALUES (v_new_sid,
                         v_osi_note_note_type,
                         k.note,
                         v_osi_note_creating_personnel,
                         k.lock_mode)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_NOTE', k.SID, v_new_sid_temp, v_new_sid);
        END LOOP;

        --Attachments / Images (Mugshots)
        --Transfer the Attachments to the temp table
        DELETE FROM T_OSI_MIGRATION_ATCH;

        INSERT INTO T_OSI_MIGRATION_ATCH
            SELECT *
              FROM ref_t_attachment_v3
             WHERE PARENT = v_person_sid
          ORDER BY modify_on;

        FOR k IN (SELECT *
                    FROM T_OSI_MIGRATION_ATCH
                   WHERE PARENT = v_person_sid)
        LOOP
            --Get Creating Personnel
            IF (k.attach_by IS NOT NULL) THEN
                BEGIN
                    SELECT new_sid
                      INTO v_temp
                      FROM T_OSI_MIGRATION
                     WHERE TYPE = 'PERSONNEL' AND old_sid = k.attach_by;
                EXCEPTION
                    WHEN OTHERS THEN
                        --If personnel is not found, then use the current personnel
                        v_temp := Core_Context.personnel_sid;
                END;
            ELSE
                --Personnel should never be null, but if it is, use the current User.
                v_temp := Core_Context.personnel_sid;
            END IF;

            --Get Type
            IF (k.USAGE = 'MUGSHOT') THEN
                v_temp2 :=
                    Osi_Attachment.get_attachment_type_sid(Core_Obj.lookup_objtype(v_obj_desc),
                                                           'MUG',
                                                           'MUGSHOT');
            ELSE
                v_temp2 := NULL;
            END IF;

            --Transfer the Attachment to the temp table
            DELETE FROM T_OSI_MIGRATION_ATCH;

            INSERT INTO T_OSI_MIGRATION_ATCH
                SELECT *
                  FROM ref_t_attachment_v3
                 WHERE SID = k.SID;

            FOR j IN (SELECT *
                        FROM T_OSI_MIGRATION_ATCH
                       WHERE SID = k.SID)
            LOOP
                --Update the attachment sequence for mugshots only
                IF v_temp2 is not null then
                    v_atch_seq := v_atch_seq + 1;
                END IF;

                --Note: Do not need Attachment Type
                INSERT INTO T_OSI_ATTACHMENT
                            (obj,
                             TYPE,
                             content,
                             storage_loc_type,
                             description,
                             SOURCE,
                             mime_type,
                             creating_personnel,
                             lock_mode,
                             date_modified,
                             seq)
                     VALUES (v_new_sid,
                             v_temp2,
                             j.blob_content,
                             j.attach_location,
                             j.description,
                             j.source_location,
                             NULL,
                             v_temp,
                             j.LOCKED,
                             j.content_date,
                             decode(v_temp2,NULL,NULL,v_atch_seq))
                  RETURNING SID
                       INTO v_new_sid_temp;

                  begin
                       select osi_personnel.get_name(v_temp) into v_create_by from dual;

                  exception when others then
                       
                           v_create_by := core_context.personnel_name;
                       
                  end;             
                  --- To keep the Original Create On/By from Legacy, mainly for DEERS ---     
                  update t_osi_attachment set create_by=v_create_by, create_on=j.attach_date where sid=v_new_sid_temp;

            END LOOP;

            mark_as_mig('PARTICIPANT_ATCH', k.SID, v_new_sid_temp, v_new_sid);
        END LOOP;


        --Person Detail Report
        --ref_obj_doc_web.make_doc_per(v_person_sid, v_temp_clob, null);
        v_temp_clob := get_part_rel_info(v_person_sid);
        
        if v_temp_clob is not null then

          INSERT INTO T_OSI_ATTACHMENT
                      (obj,
                       content,
                       storage_loc_type,
                       description,
                       SOURCE,
                       mime_type,
                       creating_personnel)
               VALUES (v_new_sid,
                       Hex_Funcs.clob_to_blob(v_temp_clob),
                       'DB',
                       'Participant Detail Report - Imported Participant',
                       'DetailReport.rtf',
                       'application/msword',
                       Core_Context.personnel_sid)
            RETURNING SID
                 INTO v_new_sid_temp;
        
        end if;
        
        mark_as_mig('PARTICIPANT_DOC_DETAIL', p_person_version, v_new_sid_temp, v_new_sid);

        --Import Versions
        FOR k IN (SELECT   SID
                      FROM ref_t_person_version
                     WHERE person = v_person_sid
                  ORDER BY SID)
        LOOP
            import_legacy_part_version(k.SID, v_new_sid);
        END LOOP;

        --Get the current version
        FOR k IN (SELECT SID
                    FROM ref_t_person_version
                   WHERE person = v_person_sid AND current_flag = 1)
        LOOP
            SELECT new_sid
              INTO v_current_version_sid
              FROM T_OSI_MIGRATION
             WHERE old_sid = k.SID AND TYPE = 'PARTICIPANT_VERSION';
        END LOOP;

        --Update the Current Version
        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_current_version_sid
         WHERE SID = v_new_sid;

        ----------------------------
        --Import Relationships
        ----------------------------
        IF p_import_relations = 'Y' THEN
            v_result := import_legacy_relationships(v_new_sid, v_person_sid);
        
            IF (v_result <> 'Y' and v_result not like 'Search complete.%') THEN
                log_error('import_legacy_participant: ' || v_result);
                ROLLBACK;
                RETURN v_result;
            END IF;
        END IF;

        --Legacy:
        --T_PERSON [Complete]
        --T_PERSON_VERSION [Completish - See Notes]
        --T_PERSON_CITIZENSHIP [Complete]
        --T_PERSON_INVOLVEMENT_V2 (Not needed, will be generating the Part Detail Rpt.)
        --T_PERSON_MARK [Complete]
        --T_PERSON_NAME [Complete]
        --T_PERSON_NUMBER [Complete]
        --T_PERSON_ORG_ATTR [Complete]
        --T_PERSON_RELATION (Not needed, will be generating the Part Detail Rpt.)
        --T_PERSON_VEHICLE [Complete]
        --T_ADDRESS_V2 [Complete]
        --T_PHONE_EMAIL [Complete]
        --T_DATE [Complete]
        --Attach: Person Detail Report
        --Images [Complete]
        --Notes [Complete]
        --Attachments [Complete]
        --No associations [Complete]
        --No relationships [Complete]

        --Web:
        --T_CORE_OBJ [Complete]
        --T_OSI_PARTICIPANT [Complete]
        --T_OSI_PARTICIPANT_VERSION (Need CURRENT_ADDRESS, CURRENT_NAME)
        --T_OSI_PARTICIPANT_HUMAN [Complete]
        --T_OSI_PERSON_CHARS [Complete]
        --T_OSI_PARTIC_ADDRESS [Complete]
        --T_OSI_PARTIC_CITIZENSHIP [Complete]
        --T_OSI_PARTIC_CONTACT [Complete]
        --T_OSI_PARTIC_DATE [Complete]
        --T_OSI_PARTIC_NAME [Complete]
        --T_OSI_PARTIC_NUMBER [Complete]
        --T_OSI_PARTIC_ORG_ATTR [Complete]
        --T_OSI_PARTIC_VEHICLE [Complete]
        RETURN v_new_sid;
    END import_legacy_participant;

    FUNCTION get_legacy_part_names(p_person_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_legal_names    VARCHAR2(4000) := NULL;
        v_alias_names    VARCHAR2(4000) := NULL;
        v_maiden_names   VARCHAR2(4000) := NULL;
        v_temp           VARCHAR2(4000);
    BEGIN
        FOR k IN (SELECT name_type, last_name, first_name, middle_name
                    FROM ref_t_person_name
                   WHERE person_version = p_person_version AND name_type IN('L', 'A', 'M'))
        LOOP
            v_temp := '';

            IF (k.last_name IS NOT NULL) THEN
                v_temp := v_temp || k.last_name || ', ';
            END IF;

            IF (k.first_name IS NOT NULL) THEN
                v_temp := v_temp || k.first_name || ', ';
            END IF;

            IF (k.middle_name IS NOT NULL) THEN
                v_temp := v_temp || k.middle_name || ', ';
            END IF;

            v_temp := RTRIM(v_temp, ', ');

            CASE UPPER(k.name_type)
                WHEN 'L' THEN
                    v_legal_names := v_temp || ' (Legal) ';
                WHEN 'M' THEN
                    v_maiden_names := v_temp || ' (Maiden) ';
                WHEN 'A' THEN
                    v_alias_names := v_temp || ' (AKA) ';
            END CASE;
        END LOOP;

        RETURN v_legal_names || v_maiden_names || v_alias_names;
    END get_legacy_part_names;

    FUNCTION get_legacy_part_details(
        p_person_version   IN   VARCHAR2,
        p_omit_sa          IN   VARCHAR2 := NULL,
        p_for_confirm      IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn       VARCHAR2(4000);
        v_objtype   VARCHAR2(40);                                       --t_core_obj_type.sid%type;

        FUNCTION row_start
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<TR>';
        END row_start;

        FUNCTION row_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TR>';
        END row_end;

        FUNCTION new_row(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN row_start || p_text || row_end;
        END new_row;

        FUNCTION cell_start(p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
            v_rtn   VARCHAR2(500) := '<TD vAlign="top" ';
        BEGIN
            IF (p_col_span > 0) THEN
                v_rtn := v_rtn || 'colSpan="' || p_col_span || '" ';
            END IF;

            IF (p_row_span > 0) THEN
                v_rtn := v_rtn || 'rowSpan="' || p_row_span || '" ';
            END IF;

            RETURN v_rtn || '>';
        END cell_start;

        FUNCTION cell_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TD>';
        END cell_end;

        FUNCTION new_cell(p_text IN VARCHAR2, p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN cell_start(p_col_span, p_row_span) || p_text || cell_end;
        END new_cell;

        FUNCTION make_label(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<LABEL class="optionallabel"><SPAN>' || p_text || '</SPAN></LABEL>';
        END make_label;

        FUNCTION get_indiv_details(p_person_version IN VARCHAR2)
            RETURN VARCHAR2 IS
            v_name                    VARCHAR2(200);
            v_sex                     VARCHAR2(200);
            v_service                 VARCHAR2(200);
            v_address                 VARCHAR2(200);
            v_dob                     DATE;
            v_affiliation             VARCHAR2(200);
            v_race                    VARCHAR2(200);
            v_component               VARCHAR2(200);
            v_ssn                     VARCHAR2(200);
            v_pay_plan                VARCHAR2(200);
            v_confirmed               VARCHAR2(200);
            v_pay_grade               VARCHAR2(200);
            v_rank                    VARCHAR2(200);
            v_rank_date               DATE;
            v_specialty_code          VARCHAR2(200);
            v_military_organization   VARCHAR2(200);
            v_format                  VARCHAR2(11);
        BEGIN
            IF (p_person_version IS NOT NULL) THEN
                SELECT ref_person.current_name(vpv.SID), sex, vpv.sa_service_desc "SA_SERVICE",
                       ref_person.address(vpv.SID, 'CURRENT') AS "ADDRESS", vpv.birth_date,
                       oaffiliation.description AS "SA_AFFILIATION", vpv.race_desc,
                       dcomponent.description AS "SA_COMPONENT",
                       ref_person.latest_number(vpv.SID, 'SSN') AS "SSN",
                       dpay_plan.description AS "SA_PAYPLAN",
                       (SELECT DECODE(confirm_by, NULL, 'Not Confirmed', 'Confirmed')
                          FROM ref_t_person
                         WHERE SID = vpv.person) AS "CONFIRMED",
                       dpay_grade.description AS "SA_PAY_GRADE", vpv.sa_rank AS "SA_RANK",
                       vpv.sa_rank_date AS "SA_RANK_DATE",
                       vpv.sa_specialty_code AS "SA_SPECIALTY_CODE",
                       ref_person.get_org_info(vpv.SID) AS "MILITARY_ORG"
                  INTO v_name, v_sex, v_service,
                       v_address, v_dob,
                       v_affiliation, v_race,
                       v_component,
                       v_ssn,
                       v_pay_plan,
                       v_confirmed,
                       v_pay_grade, v_rank,
                       v_rank_date,
                       v_specialty_code,
                       v_military_organization
                  FROM ref_v_person_version vpv,
                       T_OSI_REFERENCE oaffiliation,
                       T_DIBRS_REFERENCE dcomponent,
                       T_DIBRS_REFERENCE dpay_plan,
                       T_DIBRS_PAY_GRADE_TYPE dpay_grade
                 WHERE (oaffiliation.code(+) = vpv.sa_affiliation AND oaffiliation.USAGE(+) =
                                                                                 'INDIV_AFFILIATION')
                   AND (dcomponent.code(+) = vpv.sa_component AND dcomponent.USAGE(+) =
                                                                                 'SERVICE_COMPONENT')
                   AND (dpay_plan.code(+) = vpv.sa_pay_plan AND dpay_plan.USAGE(+) = 'PAY_PLAN')
                   AND (dpay_grade.code(+) = vpv.sa_pay_grade)
                   AND vpv.SID = p_person_version;

                v_format := Core_Util.get_config('CORE.DATE_FMT_DAY');
            END IF;

            v_rtn := '<TABLE class="formlayout" width="100%" border="0"><TBODY>';
            v_rtn := v_rtn || '<colgroup span="3" align="left" width="33%"></colgroup>';
            v_rtn := v_rtn || row_start || new_cell('Name: ' || v_name);
            v_rtn := v_rtn || new_cell('Sex: ' || v_sex);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Service: ' || v_service);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address, 0, 8);
            v_rtn := v_rtn || new_cell('Date of Birth: ' || TO_CHAR(v_dob, v_format));

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Affiliation: ' || v_affiliation);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Race: ' || v_race);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Component: ' || v_component);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('SSN: ' || v_ssn);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Plan: ' || v_pay_plan);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Grade: ' || v_pay_grade);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank: ' || v_rank);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank Date: ' || TO_CHAR(v_rank_date, v_format));
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Specialty: ' || v_specialty_code);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Military Organization: ' || v_military_organization);
            END IF;

            v_rtn := v_rtn || row_end || '</TBODY></TABLE>';
            RETURN v_rtn;
        END get_indiv_details;
    BEGIN
        RETURN get_indiv_details(p_person_version);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_legacy_part_details: ' || SQLERRM);
            RETURN 'get_legacy_part_details: ' || SQLERRM;
    END get_legacy_part_details;

    FUNCTION get_part_rel_info(p_person IN VARCHAR2)
        RETURN CLOB IS
        v_file_begin   VARCHAR2(2000)
            := '{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}} {\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20';
        v_file_end     VARCHAR2(2000)  := '\par }';
        v_return       CLOB;
        v_temp1        VARCHAR2(20000);
        --v_temp2 varchar2(20000);
        --v_temp3 varchar2(32000);
        v_cnt          NUMBER;
    BEGIN
        --Start File
        v_return := v_file_begin;
        --*****Header
        v_temp1 :=
            'Relational data for: ' || ref_person.current_name(p_person) || ' \par  As of: '
            || SYSDATE || ' \par\par ';
        v_return := v_return || v_temp1;
        v_temp1 := '';
        --*****Associated Activities
        v_temp1 := NULL;
        v_cnt := 0;
        v_temp1 := '\b ASSOCIATED ACTIVITIES \b0 \par \par ';

        FOR k IN (SELECT DISTINCT ID, title, subtype_desc, involvement_role, SID
                             FROM ref_v_person_act_inv
                            WHERE person = p_person)
        LOOP
            --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
            IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                v_cnt := v_cnt + 1;
                v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 Activity ID: ' || k.ID || ' \par ';
                v_temp1 := v_temp1 || 'Activity Title: ' || k.title || ' \par ';
                v_temp1 := v_temp1 || 'Activity Type: ' || k.subtype_desc || ' \par ';
                v_temp1 :=
                         v_temp1 || 'Activity Involvement Role: ' || k.involvement_role || ' \par ';
                v_temp1 := v_temp1 || ' \par ';
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            v_temp1 := v_temp1 || 'No Data Found \par ';
        END IF;

        --Concatonate the activities
        v_return := v_return || v_temp1 || ' \par ';
        --Clear buffer(s)
        v_temp1 := NULL;
        v_cnt := 0;
        v_temp1 := '\b ASSOCIATED FILES \b0 \par \par ';

        --*****Associated Files
        FOR k IN (SELECT DISTINCT ID, title, type_desc, subtype_desc, involvement_role, SID
                             FROM ref_v_person_file_inv
                            WHERE person = p_person)
        LOOP
            --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
            IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                v_cnt := v_cnt + 1;
                v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 File ID: ' || k.ID || ' \par ';
                v_temp1 := v_temp1 || 'File Title: ' || k.title || ' \par ';
                v_temp1 := v_temp1 || 'File Type: ' || k.type_desc || ' \par ';
                v_temp1 := v_temp1 || 'File Sub Type: ' || k.subtype_desc || ' \par ';
                v_temp1 := v_temp1 || 'File Involvement Role: ' || k.involvement_role || ' \par ';
                v_temp1 := v_temp1 || ' \par ';
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            v_temp1 := v_temp1 || 'No Data Found \par ';
        END IF;

        --Concatonate the files
        v_return := v_return || v_temp1 || ' \par ';
        --Clear buffer(s)
        v_temp1 := NULL;
        v_cnt := 0;
        v_temp1 := '\b RELATIONSHIPS \b0 \par \par ';

        --*****Relationships
        FOR k IN (SELECT *
                    FROM ref_v_person_relation
                   WHERE this_person = p_person)
        LOOP
            IF (    (NVL(k.mod2_value, 'xxx') NOT LIKE 'ORCON%')
                AND (NVL(k.mod2_value, 'xxx') NOT LIKE 'LIMDIS%')) THEN
                IF (k.rel_desc IS NOT NULL) THEN
                    v_cnt := v_cnt + 1;
                    v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 ' || k.rel_desc || ' \par ';
                    v_temp1 := v_temp1 || 'Participant: ' || k.that_name || ' \par ';

                    -- add specifics if any
                    IF (k.rel_specifics IS NOT NULL) THEN
                        v_temp1 := v_temp1 || 'Specifics: ' || k.rel_specifics || ' \par ';
                    END IF;

                    -- add comments if any
                    IF (k.comments IS NOT NULL) THEN
                        v_temp1 := v_temp1 || 'Comments: ' || k.comments || ' \par ';
                    END IF;

                    v_temp1 := v_temp1 || ' \par ';
                END IF;
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            v_temp1 := v_temp1 || 'No Data Found \par ';
        END IF;

        --Concatonate the files
        v_return := v_return || v_temp1 || ' \par ';
        --Clear buffer(s)
        --v_temp1 := null; [Do Not Need]
        --v_cnt := 0;      [Do Not Need]

        --Finish off file
        v_return := v_return || v_file_end;
        --Send home
        RETURN v_return;
    END get_part_rel_info;

     ----------------------
     --Used to import legacy relationships
     ----------------------
     FUNCTION import_legacy_relationships(p_new_person IN VARCHAR2, p_i2ms_person IN VARCHAR2 := NULL) 
            RETURN VARCHAR2 IS
     
     v_source_person       VARCHAR2(20);
     v_rel_person          VARCHAR2(20);
     v_rel_perver          VARCHAR2(20);
     v_new_source_person   VARCHAR2(20);
     v_new_rel_person      VARCHAR2(20);
     v_partic_a            VARCHAR2(20);
     v_partic_b            VARCHAR2(20);
     v_rel_type            VARCHAR2(20);
     v_start_date            DATE;
     v_end_date            DATE;
     v_known_date            DATE;
     v_mod1_value            VARCHAR2(200);
     v_mod2_value            VARCHAR2(200);
     v_mod3_value            VARCHAR2(200);
     v_comments            VARCHAR2(1000);
     v_new_rel_sid         VARCHAR2(20);
     v_migration_cnt_total NUMBER := 0;
     v_cnt                 NUMBER := 0;
     
     PROCEDURE mark_as_mig(
            p_type      IN   VARCHAR2,
            p_old_sid   IN   VARCHAR2,
            p_new_sid   IN   VARCHAR2,
            p_parent    IN   VARCHAR2) IS
        BEGIN
            v_migration_cnt_total := v_migration_cnt_total + 1;

            INSERT INTO T_OSI_MIGRATION
                        (TYPE, old_sid, new_sid, date_time, num, PARENT)
                 VALUES (p_type, p_old_sid, p_new_sid, SYSDATE, v_migration_cnt_total, p_parent);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE;
        END mark_as_mig;

     BEGIN

            /* preliminary check to see if the import has already been run on this participant */
            IF p_i2ms_person is null and osi_participant.get_imp_relations_flag(p_new_person) = 'Y' THEN
                return 'Search complete. Legacy relationships have already been migrated.';
            END IF;
            
            /* initialize the legacy participant (not initialized when 
               import_legacy_relationships is called directly from the application) */
            IF p_i2ms_person is null then
               BEGIN
                    SELECT old_sid 
                      INTO v_source_person
                      FROM T_OSI_MIGRATION
                     WHERE new_sid = p_new_person
                       AND type = 'PARTICIPANT';
               EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                             --return an error message
                             return 'Error: Unable to locate a legacy participant for ' || p_new_person;
               END; 
            ELSE
                v_source_person := p_i2ms_person;     
            END IF;

            v_new_source_person := p_new_person;
            
            /* loop through the legacy relationships for v_source_person, EXCLUDING those previously migrated */
            FOR k IN (SELECT *
                        FROM ref_v_person_relation
                       WHERE this_person = v_source_person
                         AND sid not in(SELECT old_sid
                                          FROM t_osi_migration
                                         WHERE type = 'RELATIONSHIP'))
            LOOP
                v_cnt := v_cnt + 1;

                log_error('import_legacy_relationships: STATUS - processing relationship ' || v_cnt);

                --get the related person sid from legacy
                v_rel_person := k.that_person;
                v_new_rel_person := null;
                
                --first check to see if the related person has already been migrated
                BEGIN
                    SELECT new_sid
                      INTO v_new_rel_person
                      FROM t_osi_migration 
                     WHERE type = 'PARTICIPANT' 
                       AND old_sid = v_rel_person;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_new_rel_person := null;
                END;
                
                /* if v_rel_person does not yet exist in t_osi_migration, get the current 
                   version from legacy (for import) */
                IF v_new_rel_person is null then
                   BEGIN
                       SELECT SID
                         INTO v_rel_perver
                         FROM ref_t_person_version
                        WHERE person = v_rel_person AND current_flag = 1;
                   EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                             --return an error message
                             return 'Error: Unable to locate a current version in legacy for ' || v_rel_person;
                   END;
                /* import them...but do not import their relationships */
                    v_new_rel_person := import_legacy_participant(v_rel_perver, 'N');
                END IF;
                
                -- import the relationship using the new person sids
                /* initialize A and B persons */
                /* NOTE: in I2G, specific relationship sids are defined for each direction, so
                      regardless of I2MS A2B or B2A we will map this relationship as A to B */
                v_partic_a := v_new_source_person;
                v_partic_b := v_new_rel_person;

                /* get rel_type */
                BEGIN
                    select sid
                      into v_rel_type
                      from T_OSI_PARTIC_RELATION_TYPE
                     where upper(description) = upper(k.rel_desc);
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                         --return an error message
                         return 'Error: Unable to locate relationship type for ' || nvl(k.rel_desc, 'NULL');
                END;

                /* get remaining fields */
                v_start_date := k.START_DATE;
                v_end_date := k.END_DATE;
                v_known_date := k.KNOWN_DATE;
                v_mod1_value := k.MOD1_VALUE;
                v_mod2_value := k.MOD2_VALUE;
                v_mod3_value := k.MOD3_VALUE;
                v_comments := k.COMMENTS;
                
                /* insert the new relationship */
                INSERT INTO T_OSI_PARTIC_RELATION
                                (PARTIC_A,
                                 PARTIC_B,
                                 REL_TYPE,
                                 START_DATE,
                                 END_DATE,
                                 KNOWN_DATE,
                                 MOD1_VALUE,
                                 MOD2_VALUE,
                                 MOD3_VALUE,
                                 COMMENTS)
                         VALUES (v_partic_a,
                                 v_partic_b,
                                 v_rel_type,
                                 v_start_date,
                                 v_end_date,
                                 v_known_date,
                                 v_mod1_value,
                                 v_mod2_value,
                                 v_mod3_value,
                                 v_comments
                                 )
                      RETURNING SID
                           INTO v_new_rel_sid;

                mark_as_mig('RELATIONSHIP', k.SID, v_new_rel_sid, v_new_source_person);
                
            END LOOP;

            /* update the migration table to reflect that imp_relations now = 'Y' for this PARTICIPANT */ 
            UPDATE T_OSI_MIGRATION 
               SET imp_relations = 'Y' 
             WHERE type = 'PARTICIPANT' 
               AND new_sid = v_new_source_person
               AND imp_relations = 'N';

            /* return a confirmation message if no relationships found, or a 'Y' for successful import... */

            IF v_cnt = 0 THEN
                return 'Search complete. No additional legacy relationships found.';
            END IF;
            
            return 'Y';
     EXCEPTION
          WHEN OTHERS THEN
               log_error('import_legacy_relationships: Error: ' || dbms_utility.format_error_backtrace);
               ROLLBACK;
               return 'Error: ' || sqlerrm;
     END import_legacy_relationships;

    /* Given a specific role type SID, return the maximum number of participants allowed per object */
    FUNCTION get_max_allowed_for_role(p_role IN VARCHAR2)
        RETURN NUMBER IS
    BEGIN
        FOR k IN (SELECT max_num
                    FROM T_OSI_PARTIC_ROLE_TYPE
                   WHERE SID = p_role)
        LOOP
            RETURN k.max_num;
        END LOOP;

        --Simply return if passed an invalid sid
        RETURN 0;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.get_max_allowed_for_role: ' || SQLERRM);
            RAISE;
    END get_max_allowed_for_role;

    /* Given an object SID and a role SID, return the number already in that given role tied to the given object */
    --Note the exclude parameter, this is used to exclude the current item your on
    FUNCTION get_num_part_in_role(p_obj IN VARCHAR2, p_role IN VARCHAR2, p_exclude IN VARCHAR2)
        RETURN NUMBER IS
        v_cnt       NUMBER;
        v_exclude   VARCHAR2(20);
    BEGIN
        --Clear buffer
        v_cnt := 0;

        --Did this to make the query simpler
        IF (p_exclude IS NULL) THEN
            v_exclude := ' ';
        ELSE
            v_exclude := p_exclude;
        END IF;

        FOR k IN (SELECT SID
                    FROM T_OSI_PARTIC_INVOLVEMENT
                   WHERE obj = p_obj AND involvement_role = p_role AND SID <> v_exclude)
        LOOP
            v_cnt := v_cnt + 1;
        END LOOP;

        --Return value
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.get_num_part_in_role: ' || SQLERRM);
            RAISE;
    END get_num_part_in_role;

    /* Given a participant SID and a personnel SID (optional) will return Y/N if the details should be editable */
    FUNCTION details_are_editable(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_return          VARCHAR2(1)                 := 'N';
        v_personnel_sid   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        --First see if participant object is locked
        FOR k IN (SELECT SID
                    FROM T_OSI_PARTICIPANT
                   WHERE SID = p_obj AND details_lock = 'N')
        LOOP
            --If its not locked, just exit right out
            RETURN 'Y';
        END LOOP;

        --Get the personnel that is attempting to see data
        IF (p_personnel IS NOT NULL) THEN
            v_personnel_sid := p_personnel;
        ELSE
            v_personnel_sid := Core_Context.personnel_sid;
        END IF;

        --Since the object is marked as locked, need to see if the user has the override privilege
        --Action type = 'DET_UNL'
        IF (Osi_Auth.check_for_priv('DET_UNL',
                                    Core_Obj.lookup_objtype('PARTICIPANT'),
                                    v_personnel_sid) = 'Y') THEN
            v_return := 'Y';
        ELSE
            v_return := 'N';
        END IF;

        --If all else, return current v_return value
        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.details_are_editable: ' || SQLERRM);
            RAISE;
    END details_are_editable;

    procedure reorder_partic_images(p_obj in varchar2, p_cur_seq in number, p_targ_seq in number) is
    begin
        if p_targ_seq > p_cur_seq then                                  --moving LOWER in the chain
            for a in (select   *
                          from t_osi_attachment
                         where obj = p_obj and seq > p_cur_seq and seq <= p_targ_seq
                      order by seq)
            loop
                update v_osi_partic_images
                   set seq = a.seq - 1
                 where SID = a.SID;
            end loop;

            commit;
        elsif p_targ_seq < p_cur_seq then                               --moving HIGHER in the chain
            for a in (select   *
                          from v_osi_partic_images
                         where obj = p_obj and seq >= p_targ_seq and seq < p_cur_seq
                      order by seq)
            loop
                update t_osi_attachment
                   set seq = a.seq + 1
                 where SID = a.SID;
            end loop;

            commit;
        end if;
    exception
        when others then
            log_error('reorder_partic_images: ' || sqlerrm);
            raise;
    end;

    procedure partic_image_sort(v_obj in varchar2) is
        v_seq   Number := 0;
    Begin
        for a in (select   SID
                      from v_osi_partic_images
                     where obj = v_obj
                  order by SEQ asc)
        loop
            v_seq := v_seq + 1;

            update t_osi_attachment
               set seq = v_seq
             where SID = a.SID;
        end loop;

      end;

    FUNCTION Is_Married( pPoPV IN VARCHAR2 ) RETURN VARCHAR2 IS

        v_result VARCHAR2(3);
        v_cnt NUMBER;
    
    BEGIN
        SELECT COUNT(*) INTO v_cnt
          FROM T_OSI_PARTICIPANT_VERSION pv,
               V_OSI_PARTIC_RELATION_2WAY pr
          WHERE pr.this_partic = pv.participant AND
                upper(pr.rel_desc) LIKE '%SPOUSE%' AND
                (pv.participant = pPoPV OR pv.SID = pPoPV) AND
                NVL(pr.END_DATE,(SYSDATE + 1)) > SYSDATE;
                       
        IF v_cnt > 0 THEN

          v_result := 'YES';

        ELSE

          v_result := 'NO';

        END IF;
    
        RETURN (v_result);

    END Is_Married;

    ------------------------
    -- Returns Y if legacy relationships have already been imported, otherwise return N
    ------------------------
    FUNCTION get_imp_relations_flag(p_obj in varchar2)
        RETURN VARCHAR2 is

        v_return Varchar2(1);

    BEGIN
        select imp_relations
          into v_return
          from t_osi_migration
         where new_sid = p_obj
           and type = 'PARTICIPANT';

        v_return := nvl(v_return, 'Y');

        return v_return;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             return 'Y';
    END get_imp_relations_flag;

function Latest_Org( pPoPV in Varchar2, pOrgType in Varchar2 := '%') return Varchar2 is
    v_p_sid     T_OSI_PARTICIPANT.SID%type;
    v_p_type    Varchar2(100) := 'PART.NONINDIV.ORG';
begin
    --- Get the Participant SID --- 
    select participant into v_p_sid from t_osi_participant_version
        where (participant=pPoPV or SID=pPoPV) and rownum <= 1;

    --- Find the most recent Organization membership --- 
    for r in (select w.that_partic from v_osi_partic_relation_2way w,
                            t_osi_partic_relation_type rt 
                  where this_partic=v_p_sid 
                     and w.REL_TYPE=rt.sid 
                     and rt.code in ('IMO','IMOU')
                     and (end_date is null or end_date > sysdate) order by nvl(START_DATE,w.modify_on) desc)
    loop
        for s in (select o.sid from t_core_obj o,
                                    t_core_obj_type ot, 
                                    t_osi_participant_nonhuman nh, 
                                    t_osi_reference oref, 
                                    t_osi_participant_version pv
                     where o.sid=r.that_partic
                     and o.OBJ_TYPE=ot.sid
                     and ot.code=v_p_type
                     and oref.sid=nh.sub_type
                     and oref.code like pOrgType
                     and pv.participant=o.sid
                     and nh.sid=pv.sid)
        loop
            return( s.sid );    --- only need 1st row ---
            
        end loop;
        
    end loop;        
        
    raise NO_DATA_FOUND;     --- found no rows ---

exception
    when NO_DATA_FOUND then
        return( null );

end Latest_Org;

--grant select on t_person_name to webi2ms;
--grant select on t_person_number_type to webi2ms;
--grant select on t_person_number to webi2ms;
--grant select on t_person to webi2ms;
--grant select on t_person_version to webi2ms;
--grant select on v_person_version to webi2ms;
--grant select on t_person_citizenship to webi2ms;
--grant select on t_person_mark to webi2ms;
--grant select on t_address_v2 to webi2ms;
--grant select on t_phone_email to webi2ms;
--grant select on t_person_org_attr to webi2ms;
--grant select on t_person_vehicle to webi2ms;
--grant select on t_person_vehicle_body_types to webi2ms;
--grant select on t_person_vehicle_roles to webi2ms;
--grant select on t_date to webi2ms;
--grant select on t_date_type to webi2ms;
--grant select on t_note_v2 to webi2ms;
--grant select on t_attachment_v3 to webi2ms;
--grant select on v_person_act_inv to webi2ms;
--grant select on v_person_file_inv to webi2ms;
--grant select on v_person_relation to webi2ms;
--grant execute on person to webi2ms;
--grant execute on obj_doc_web to webi2ms;
--grant execute on classification_pkg to webi2ms;

--create synonym ref_t_person_name for i2ms.t_person_name;
--create synonym ref_t_person_number_type for i2ms.t_person_number_type;
--create synonym ref_t_person_number for i2ms.t_person_number;
--create synonym ref_t_person for i2ms.t_person;
--create synonym ref_t_person_version for i2ms.t_person_version;
--create synonym ref_v_person_version for i2ms.v_person_version;
--create synonym ref_t_person_citizenship for i2ms.t_person_citizenship;
--create synonym ref_t_person_mark for i2ms.t_person_mark;
--create synonym ref_t_address_v2  for i2ms.t_address_v2;
--create synonym ref_t_phone_email for i2ms.t_phone_email;
--create synonym ref_t_person_org_attr for i2ms.t_person_org_attr;
--create synonym ref_t_person_vehicle for i2ms.t_person_vehicle;
--create synonym ref_t_person_vehicle_bt for i2ms.t_person_vehicle_body_types;
--create synonym ref_t_person_vehicle_roles for i2ms.t_person_vehicle_roles;
--create synonym ref_t_date for i2ms.t_date;
--create synonym ref_t_date_type for i2ms.t_date_type;
--create synonym ref_t_note_v2 for i2ms.t_note_v2;
--create synonym ref_t_attachment_v3 for i2ms.t_attachment_v3;
--create synonym ref_v_person_act_inv  for i2ms.v_person_act_inv;
--create synonym ref_v_person_file_inv  for i2ms.v_person_file_inv;
--create synonym ref_v_person_relation  for i2ms.v_person_relation;
--create synonym ref_person for i2ms.person;
--create synonym ref_obj_doc_web for i2ms.obj_doc_web;
--create synonym ref_classification_pkg for i2ms.classification_pkg;
END Osi_Participant;
/

