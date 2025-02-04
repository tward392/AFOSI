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

******************************************************************************/
    c_pipe              varchar2(100)
                                  := core_util.get_config('CORE.PIPE_PREFIX')
                                     || 'OSI_INVESTIGATION';
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
    v_date_fmt          varchar2(11)                   := core_util.get_config('CORE.DATE_FMT_DAY');
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

    procedure clone_specifications(p_old_sid in varchar2, p_new_sid in varchar2) is
        v_new_spec_sid   t_osi_f_inv_spec.SID%type;
    begin
        for i in (select *
                    from t_osi_f_inv_spec
                   where investigation = p_old_sid)
        loop
            --clone main spec record
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
                         vic_susp_drugs)
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
                         i.vic_susp_drugs)
              returning SID
                   into v_new_spec_sid;

            --clone aah list
            insert into t_osi_f_inv_spec_aah
                        (specification, aah)
                select v_new_spec_sid, aah
                  from t_osi_f_inv_spec_aah
                 where specification = i.SID;

            --clone ajh list
            insert into t_osi_f_inv_spec_ajh
                        (specification, ajh)
                select v_new_spec_sid, ajh
                  from t_osi_f_inv_spec_ajh
                 where specification = i.SID;

            --clone weapon force used list
            insert into t_osi_f_inv_spec_arm
                        (specification, armed_with, gun_category)
                select v_new_spec_sid, armed_with, gun_category
                  from t_osi_f_inv_spec_arm
                 where specification = i.SID;

            --clone criminal activities list
            insert into t_osi_f_inv_spec_crim_act
                        (specification, crim_act_type)
                select v_new_spec_sid, crim_act_type
                  from t_osi_f_inv_spec_crim_act
                 where specification = i.SID;

            --clone victim injuries list
            insert into t_osi_f_inv_spec_vic_injury
                        (specification, injury_type)
                select v_new_spec_sid, injury_type
                  from t_osi_f_inv_spec_vic_injury
                 where specification = i.SID;
        end loop;
    exception
        when others then
            log_error('clone_specifications: ' || sqlerrm);
            raise;
    end clone_specifications;

    function clone_to_case(p_sid in varchar2)
        return varchar2 is
        v_new_sid        t_core_obj.SID%type;
        v_old_id         t_osi_file.id%type;
        v_new_id         t_osi_file.id%type;
        v_close_status   t_osi_status.SID%type;
        v_note_sid       t_osi_note.SID%type;
        v_starting_status  t_osi_status.sid%type;
    begin
        --clone object
        insert into t_core_obj
                    (obj_type)
             values (core_obj.lookup_objtype('FILE.INV.CASE'))
          returning SID
               into v_new_sid;

        v_new_id := osi_object.get_next_id;

        --clone basic file info
        insert into t_osi_file
                    (SID, id, title, closed_short, restriction)
            select v_new_sid, v_new_id, title, closed_short, restriction
              from t_osi_file
             where SID = p_sid;

        --clone investigation
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

        --clone offenses
        insert into t_osi_f_inv_offense
                    (investigation, offense, priority)
            select v_new_sid, offense, priority
              from t_osi_f_inv_offense
             where investigation = p_sid;

        clone_specifications(p_sid, v_new_sid);

        -- clone subjects, victims and agencies
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
             where obj = p_sid;

        --map incidents to this file
        insert into t_osi_f_inv_incident_map
                    (investigation, incident)
            select v_new_sid, incident
              from t_osi_f_inv_incident_map
             where investigation = p_sid;

        --clone special interest mission areas
        insert into t_osi_mission
                    (obj, mission, obj_context)
            select v_new_sid, mission, obj_context
              from t_osi_mission
             where obj = p_sid and obj_context='I';

        --clone units to notify
        insert into t_osi_f_notify_unit
                    (file_sid, unit_sid)
            select v_new_sid, unit_sid
              from t_osi_f_notify_unit
             where file_sid = p_sid;

        --clone activity associations
        insert into t_osi_assoc_fle_act
                    (file_sid, activity_sid, resource_allocation)
            select v_new_sid, activity_sid, resource_allocation
              from t_osi_assoc_fle_act
             where file_sid = p_sid;

        --clone file associations
        insert into t_osi_assoc_fle_fle
                    (file_a, file_b)
            select v_new_sid, file_b
              from t_osi_assoc_fle_fle
             where file_a = p_sid;

        insert into t_osi_assoc_fle_fle
                    (file_a, file_b)
            select file_a, v_new_sid
              from t_osi_assoc_fle_fle
             where file_b = p_sid;

        --associate to current file
        insert into t_osi_assoc_fle_fle
                    (file_a, file_b)
             values (v_new_sid, p_sid);

        --clone assignments
        insert into t_osi_assignment
                    (obj, personnel, assign_role, start_date, end_date, unit)
            select v_new_sid, personnel, assign_role, start_date, end_date, unit
              from t_osi_assignment
             where obj = p_sid;

        --set unit ownership to current user's unit
        osi_file.set_unit_owner(v_new_sid);

        --save status
        select starting_status
          into v_starting_status
          from t_osi_obj_type ot, t_core_obj_type ct
         where ot.sid=ct.sid and ct.code='FILE.INV.CASE';
        
        insert into t_osi_status_history
                    (obj, status, effective_on, transition_comment, is_current) values
                    (v_new_sid, v_starting_status, sysdate, 'Created', 'Y');

        --close old file if informational
        if core_obj.get_objtype(p_sid) = core_obj.lookup_objtype('FILE.INV.INFO') then
            select SID
              into v_close_status
              from t_osi_status
             where code = 'CL';

            osi_status.change_status_brute(p_sid,
                                           v_close_status,
                                           'Closed (Short) with Case Creation');
            v_note_sid :=
                osi_note.add_note
                               (p_sid,
                                osi_note.get_note_type(core_obj.lookup_objtype('FILE.INV.INFO'),
                                                       'CLOSURE'),
                                'Original documents are contained in the associated case file:  '
                                || v_new_id || '.');
        end if;

        select id
          into v_old_id
          from t_osi_file
         where SID = p_sid;

        --Add Note
        v_note_sid :=
            osi_note.add_note(v_new_sid,
                              osi_note.get_note_type(core_obj.lookup_objtype('FILE.INV.CASE'),
                                                     'CREATE'),
                              'This Case File was created using the following File:  ' || v_old_id
                              || '.');
        return v_new_sid;
    exception
        when others then
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

        Select description
          into v_class
          from T_OSI_REFERENCE
         where code = osi_classification.get_report_class(v_obj_sid);

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

    function get_org_info(ppopv in varchar2, preplacenullwithunk in boolean := false)
        return varchar2 is
        v_result     varchar2(4000);
        v_org        varchar2(20);
        v_org_name   varchar2(100);
        v_base       varchar2(100);
        v_base_loc   varchar2(100);
    begin
        log_error('--->OSI_INVESTIGATION.Get_Org_Info(' || ppopv || ') - ' || sysdate);
        v_result := null;
        v_org := osi_participant.get_org_member_name(ppopv);

        if v_org is not null then
            select osi_participant.get_name(ppopv), pa.city, nvl(pa.state_desc, pa.country_desc)
              into v_org_name, v_base, v_base_loc
              from t_osi_participant_version pv, v_osi_partic_address pa
             where pa.participant_version = pv.SID and pv.SID = ppopv and pa.is_current = 'Y';

            if preplacenullwithunk = true then
                v_result :=
                    nvl(v_org_name, 'UNK') || ', ' || nvl(v_base, 'UNK') || ', '
                    || nvl(v_base_loc, 'UNK');
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

    function roi_group_order(psid in varchar2)
        return varchar2 is
/*
    Returns a string used to sort the TOC Groups.
*/
    begin
        load_activity(psid);

        if (   v_act_desc = 'Group Interview'
            or v_mask is not null) then                  -- Interviews -- and -- Group Interviews --
            if v_mask = 'Investigative Activity' then
                return 'Z';
            else
                return 'A';
            end if;
        elsif v_act_desc like 'Document Review' then                          -- Document Reviews --
            return 'D';
        elsif v_act_desc like 'Coordination%' then
            return 'G';                                                         -- Coordinations --
        elsif v_act_desc like 'Consultation%' then
            return 'H';                                                         -- Consultations --
        elsif v_act_desc like 'Search%' then                                          -- Searches --
            return 'B';
        elsif v_act_desc = 'Law Enforcement Records Check' then                 -- Records Checks --
            return 'E';
        else
            return 'Z';                                           -- Other Investigative Aspects --
        end if;
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
        return osi_report.replace_special_chars(v_act_narrative, 'RTF');
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

        Select description
          into v_class
          from T_OSI_REFERENCE
         where code = osi_classification.get_report_class(v_obj_sid);

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

        Select description
          into v_class
          from T_OSI_REFERENCE
         where code = osi_classification.get_report_class(v_obj_sid);

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
                v_subject_ssn := replace(a.ssn, '-', '');
                v_subject_ssn :=
                    ' (' || substr(v_subject_ssn, 1, 3) || '-' || substr(v_subject_ssn, 4, 2)
                    || '-' || substr(v_subject_ssn, 5, 4) || ')';
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
            v_letters := v_letters || 'ign order or permit any type of investigation, or take any other official action against someone undergoing an AFOSI investigation before coordinating with AFOSI and the servicing SJA."  We recommend you place this individual on administrative hold IAW AFI';
            v_letters := v_letters || ' 36-3208 to prevent PCS and/or retirement pending completion of the investigation, and command action if appropriate.  Please coordinate any TDY or leave requests concerning this individual with AFOSI prior to approval.}{\rtlch\fcs1 \af0 \ltrch\fcs0'; 
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

        Select description
          into v_class
          from T_OSI_REFERENCE
         where code = osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, 'RTF'));
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

        for a in (select   note_text, seq
                      from t_osi_note n, t_osi_note_type nt
                     where (   n.obj = v_obj_sid
                            or n.obj in(select activity_sid
                                          from t_osi_assoc_fle_act
                                         where file_sid = v_obj_sid))
                       and n.note_type = nt.SID
                       and nt.description in('Curtailed Content Report Note', 'IDP Note')
                  order by seq)
        loop
            v_cnt := v_cnt + 1;
            osi_util.aitc(v_idp_list, '\par\par ' || v_cnt || '\tab ');
            dbms_lob.append(v_idp_list, osi_report.replace_special_chars_clob(a.note_text, 'RTF'));
        end loop;

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

        Select description
          into v_class
          from T_OSI_REFERENCE
         where code = osi_classification.get_report_class(v_obj_sid);

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

                begin
                    select related_to
                      into v_spouse_sid
                      from v_osi_partic_relation
                     where this_participant = b.participant and description = 'is Spouse of';
                exception
                    when no_data_found then
                        v_spouse_sid := null;
                end;

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
                osi_util.aitc(v_preview, '\line ' || v_exhibits);
            end if;

            --- Narrative Text ---
            if v_narrative is not null then
                dbms_lob.append(v_preview, '\par \ql\fi0\li0\line ' || v_narrative);
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
end osi_investigation;
/