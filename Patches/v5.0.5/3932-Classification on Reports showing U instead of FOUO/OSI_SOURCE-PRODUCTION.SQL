CREATE OR REPLACE package body osi_source as
/******************************************************************************
   Name:     OSI_SOURCE
   Purpose:  Provides functionality for Source objects.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------
    10-Nov-2009  T.Whitehead     Created Package.
    26-Jan-2010  T.McGuffin      Added Check_Writability.
    03-Feb-2010  T.Whitehead     Added burn, unburn, migrate.
    12-May-2010  T.Whitehead     Added already_exists.
    18-May-2010  T.Whitehead     Copied I2MS MIGRATESOURCE procedure to MIGRATE function.
    10-Jun-2010  T.Whitehead     Added run_report, run_meet_reports.
    07-Jul-2010  J.Faris         Modified run_report to return a no data message for
                                 empty reports, updated log_error w/line numbers.
    07-Sep-2010  R.Dibble        Added search_sources
    08-Sep-2010  R.Dibble        Added get_legacy_source_id, get_source_type_desc, get_source_type_code
    12-Sep-2010  R.Dibble        Added import_legacy_source
    27-Oct-2010  R.Dibble        Added get_legacy_partic_sid
                                  Added dup_source_exists_in_legacy
                                  Added import_legacy_report
                                  Added get_legacy_source_sid
    30-Oct-2010  R.Dibble        Added get_mission_area_desc
    29-Nov-2010  Tim Ward        Changed import_legacy_report to use Global Temporary Tables for
                                  both Notes to avoid the ora-22992 error that occurs when
                                  trying to get records with LOBs accross Database Links.
    22-Dec-2010  Tim Ward        Changed create_instance to create sources with the PERSONNEL
                                  Restriction by default.
    25-Mar-2011  Carl Grunert   Modified run_report to correctly print Classification
    08-Apr-2011  Tim Ward       Modified import_legacy_report and increase the v_temp# from 4000 to
                                 32000 varchar2 to eliminate an error when copying the background
                                 notes that were larger than 4000 characters over.
    20-Apr-2011  Tim Ward       CR#3784 - Modified import_legacy_report to include Legacy Source ID in Title.
                                 Changed get_tagline to use Title instead of just ID in the tag line.
                                CR#3757 - Include Associated Source Meet Activity IDs in import_legacy_report.
                                 Added Hyperlinks for Source, Participant, and associated activities.
                                                                    
******************************************************************************/
    c_pipe      varchar2(100)            := core_util.get_config('CORE.PIPE_PREFIX')
                                            || 'OSI_SOURCE';
    c_objtype   t_core_obj_type.sid%type   := core_obj.lookup_objtype('FILE.SOURCE');
    v_dup_sid   t_osi_f_source.sid%type;
    v_dup_id    t_osi_file.id%type;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function already_exists(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select sid, get_id(sid) as id
                    from t_osi_f_source
                   where participant in(select participant
                                          from t_osi_f_source
                                         where sid = p_obj) and sid <> p_obj)
        loop
            v_dup_sid := x.sid;
            v_dup_id := x.id;
            return 'This participant is already a Source. The source number is ' || v_dup_id || '.';
        end loop;

        return null;
    exception
        when others then
            log_error('already_exists: ' || sqlerrm);
            raise;
    end already_exists;

    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_obj_type   t_core_obj_type.sid%type;
    begin
        v_obj_type := core_obj.get_objtype(p_obj);

        if    (osi_auth.check_for_priv('SOURCE_NOWN', v_obj_type) = 'Y')
           or (osi_file.get_unit_owner(p_obj) = osi_personnel.get_current_unit(null)) then
            case osi_object.get_status_code(p_obj)
                when 'PO' then
                    return 'Y';
                when 'AA' then
                    return 'Y';
                when 'IM' then
                    if (osi_auth.check_for_priv('SOURCE_CHANGE', v_obj_type) = 'Y') then
                        return 'Y';
                    else
                        return 'N';
                    end if;
                else
                    return 'N';
            end case;
        end if;

        return 'N';
    exception
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

    function create_instance(
        p_source_type    in   varchar2,
        p_participant    in   varchar2,
        p_witting        in   varchar2 := null,
        p_mission_area   in   varchar2 := null)
        return varchar2 is
        v_obj_type   t_core_obj_type.sid%type;
        v_sid        t_core_obj.sid%type;
        v_id         t_osi_file.id%type;
        v_restriction varchar2(20);
    begin
        v_obj_type := core_obj.lookup_objtype('FILE.SOURCE');
        
        select sid into v_restriction from t_osi_reference r where USAGE='RESTRICTION' AND CODE='PERSONNEL';
        
        -- Add a bogus title.
        v_sid := osi_file.create_instance(v_obj_type, 'title', v_restriction);

        select id
          into v_id
          from t_osi_file
         where sid = v_sid;

        insert into t_osi_f_source
                    (sid, source_type, participant, witting_source, mission_area)
             values (v_sid, p_source_type, p_participant, p_witting, p_mission_area);

        -- Replace the bogus title with the file id.
        update t_osi_file
           set title = v_id
         where sid = v_sid;

        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    function get_id(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_file.get_id(p_obj);
    exception
        when others then
            log_error('get_id: ' || sqlerrm);
            return 'get_id: ' || sqlerrm;
    end get_id;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_object.get_status(p_obj);
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: ' || sqlerrm;
    end get_status;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return 'Source Number: ' || osi_file.get_title(p_obj);-- || get_id(p_obj);
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: ' || sqlerrm;
    end get_tagline;

    function migrate(p_obj in varchar2)
        return varchar2 is
        l_cur_user       varchar2(1000);
        l_cur_user_sid   t_core_personnel.sid%type;
        l_act_nums       varchar2(1000);
        l_file_nums      varchar2(1000);
        l_currentdt      date;
        l_id             t_osi_file.id%type;
        l_note_type      t_osi_note_type.sid%type;
    begin
        if (already_exists(p_obj) is null) then
            --No duplicate Source found.
            return null;
        end if;

        l_id := get_id(p_obj);
        l_cur_user := core_context.personnel_name;
        l_cur_user_sid := core_context.personnel_sid;
        l_currentdt := sysdate;

        select sid
          into l_note_type
          from t_osi_note_type
         where obj_type = c_objtype and usage = 'MIGRATION' and code = 'DSM';

------------------------------------------------------------------
--- Migrate all Source Meet Activities to the Duplicate Source ---
------------------------------------------------------------------
        for a in (select a.sid activity, a.id, a.title, s.auto_gen_title
                    from t_osi_activity a, t_osi_a_source_meet s
                   where a.source = p_obj and a.sid = s.sid)
        loop
            l_act_nums := l_act_nums || a.id || ', ';

            update t_osi_activity a
               set a.source = v_dup_sid
             where sid = a.activity;

            update t_osi_a_source_meet s
               set s.auto_gen_title = replace(a.auto_gen_title, a.id, v_dup_id)
             where sid = a.activity;

            insert into t_osi_note
                        (obj, creating_personnel, note_type, note_text)
                 values (a.activity,
                         l_cur_user_sid,
                         l_note_type,
                         'This Activity was migrated to DUPLICATE Source:  ' || v_dup_id
                         || ' from Source:  ' || l_id || ' by ' || l_cur_user || ' on '
                         || l_currentdt || '.');
        end loop;

--------------------------------------------------
--- Migrate all Computer Intrusion OSI Sources ---
--------------------------------------------------
        for c in (select s.sid as cint, s.compint, a.id, a.sid as activity, a.title
                    from t_osi_a_compint_source s, t_osi_a_comp_intrusion ci, t_osi_activity a
                   where s.osi_source = p_obj and s.compint = ci.sid and ci.sid = a.sid)
        loop
            update t_osi_a_compint_source cs
               set cs.osi_source = v_dup_sid
             where sid = c.cint;

            l_act_nums := l_act_nums || c.id || ', ';

            insert into t_osi_note
                        (obj, creating_personnel, note_type, note_text)
                 values (c.activity,
                         l_cur_user_sid,
                         l_note_type,
                         'This Activity OSI Source was migrated to DUPLICATE Source:  ' || v_dup_id
                         || ' from Source:  ' || l_id || ' by ' || l_cur_user || ' on '
                         || l_currentdt || '.');
        end loop;

-------------------------------------------------------------------
--- Migrate all Suspicious Activity Reports OSI Sources ---
-------------------------------------------------------------------
        for c in (select s.sid as cint, a.id, r.sid as sar, a.sid as activity, a.title
                    from t_osi_a_suspact_source s, t_osi_a_suspact_report r, t_osi_activity a
                   where osi_source = p_obj and s.suspact = r.sid and r.sid = a.sid)
        loop
            update t_osi_a_suspact_source ss
               set ss.osi_source = v_dup_sid
             where ss.sid = c.cint;

            l_act_nums := l_act_nums || c.id || ', ';

            insert into t_osi_note
                        (obj, creating_personnel, note_type, note_text)
                 values (c.activity,
                         l_cur_user_sid,
                         l_note_type,
                         'This Activity OSI Source was migrated to DUPLICATE Source:  ' || v_dup_id
                         || ' from Source:  ' || l_id || ' by ' || l_cur_user || ' on '
                         || l_currentdt || '.');
        end loop;

---------------------------
--- Move Existing Notes ---
---------------------------
        update t_osi_note
           set obj = v_dup_sid
         where obj = p_obj;

---------------------------------
--- Move Existing Attachments ---
---------------------------------
        update t_osi_attachment
           set obj = v_dup_sid
         where obj = p_obj;

--------------------------------------
--- Move Existing Labor/Work Hours ---
--------------------------------------
        update t_osi_work_hours
           set obj = v_dup_sid
         where obj = p_obj;

-----------------------------------
---  Move Existing Participants ---
-----------------------------------
        update t_osi_partic_involvement
           set obj = v_dup_sid
         where obj = p_obj;

----------------------------------
---  Move Existing Assignments ---
----------------------------------
        update t_osi_assignment
           set obj = v_dup_sid
         where obj = p_obj;

------------------------------------------------
---  Add a Note to the Duplicate Source File ---
------------------------------------------------
        insert into t_osi_note
                    (obj, creating_personnel, note_type, note_text)
             values (v_dup_sid,
                     l_cur_user_sid,
                     l_note_type,
                     'Activities ' || substr(l_act_nums, 1, length(l_act_nums) - 2) || chr(13)
                     || chr(10) || 'Files ' || substr(l_file_nums, 1, length(l_file_nums) - 2)
                     || chr(13) || chr(10) || 'were migrated to DUPLICATE Source:  ' || v_dup_id
                     || chr(13) || chr(10) || 'from Source:  ' || l_id || ' by ' || l_cur_user
                     || ' on ' || l_currentdt || '.');

        begin
            update t_osi_personnel_recent_objects
               set obj = v_dup_sid
             where obj = p_obj and personnel = l_cur_user_sid;
        exception
            when others then
                log_error('Error updating t_osi_personnel_recent_objects - ' || sqlerrm);
        end;

        return v_dup_sid;
    exception
        when others then
            log_error('migrate: ' || sqlerrm);
            raise;
    end migrate;

    function run_meet_reports(p_obj in varchar2)
        return clob is
        l_ok                       varchar2(5000);
        l_obj                      t_core_obj.sid%type;
        l_template                 clob                  := null;
        l_temp_template1           clob                  := null;
        l_temp_template2           clob                  := null;
        l_counter                  number;
        l_dblcurleystart           number;
        l_total_activities         number;
        l_last_classification      varchar2(32000)       := null;
        l_current_classification   varchar2(32000)       := null;
    begin
        l_obj := p_obj;
        l_counter := 0;

        select count(ra.sid)
          into l_total_activities
          from t_osi_report_spec rs, t_osi_report_activity ra
         where rs.obj = l_obj and rs.sid = ra.spec and ra.selected = 'Y';

        --- Get Actual SID of Object ---
        for a in (select ra.activity as parent
                    from t_osi_report_spec rs, t_osi_report_activity ra
                   where rs.obj = l_obj and rs.sid = ra.spec and ra.selected = 'Y')
        loop
            l_counter := l_counter + 1;

            if (l_counter = l_total_activities) then
                l_temp_template1 := osi_source_meet.run_report(a.parent, false, false);
            else
                l_temp_template1 := osi_source_meet.run_report(a.parent, true, false);
            end if;

            if (l_counter > 1) then
                select substr(l_temp_template2, 1, length(l_temp_template2) - 1)
                  into l_temp_template2
                  from dual;

                select instr(l_temp_template1, '}}')
                  into l_dblcurleystart
                  from dual;

                select substr(l_temp_template1,
                              l_dblcurleystart + 2,
                              length(l_temp_template1) - l_dblcurleystart - 1)
                  into l_temp_template1
                  from dual;
            end if;

            l_temp_template2 := l_temp_template2 || l_temp_template1;
            l_current_classification := osi_classification.get_report_class(a.parent);

            if (l_last_classification is null) then
                l_last_classification := l_current_classification;
            else
                if (l_last_classification != l_current_classification) then
                    if (upper(substr(l_last_classification, 1, 1)) = 'U') then
                        if (   upper(substr(l_current_classification, 1, 1)) = 'C'
                            or upper(substr(l_current_classification, 1, 1)) = 'S') then
                            l_last_classification := l_current_classification;
                        end if;
                    elsif(upper(substr(l_last_classification, 1, 1)) = 'C') then
                        if (upper(substr(l_current_classification, 1, 1)) = 'S') then
                            l_last_classification := l_current_classification;
                        end if;
                    end if;
                end if;
            end if;
        end loop;

        l_ok :=
            core_template.replace_tag(l_temp_template2,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(l_last_classification, 'RTF'),
                                      p_multiple       => true);

        if l_temp_template2 is not null then
            l_template := l_temp_template2 || '}';
        else
            l_template := 'No Source Meet activity data found.';
        end if;

        core_util.cleanup_temp_clob(l_temp_template1);
        core_util.cleanup_temp_clob(l_temp_template2);
        return l_template;
    exception
        when others then
            log_error('run_meet_reports: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            return l_template;
    end run_meet_reports;

    function run_report(p_obj in varchar2)
        return clob is
        l_format           varchar2(4)                               := 'RTF';
        l_obj              varchar2(20);
        l_ok               varchar2(5000);
        l_ssn              varchar2(11);
        l_template         clob;
        l_template_date    date;
        l_temp_clob        clob;
        l_temp             varchar2(32767);
        l_assist_agent     varchar2(1000);
        l_latest_org       v_osi_partic_relation.related_name%type;
        l_org_address      v_osi_partic_address.single_line%type;
        l_sex              v_osi_participant_version.sex_desc%type;
        l_dob              varchar2(15);                      --v_osi_participant_version.dob%type;
        l_address          v_osi_partic_address.single_line%type;
        l_mime_type        t_core_template.mime_type%type;
        l_mime_disp        t_core_template.mime_disposition%type;
        l_participant      t_osi_participant.sid%type;
        l_id               t_osi_file.id%type;
        l_burnlist         varchar2(3);
        l_mission_area     t_osi_mission_category.description%type;
        l_witting_source   varchar2(3);
        v_class            varchar2(100);
    begin
        l_obj := p_obj;
        l_ok :=
            core_template.get_latest('SOURCE_REPORT',
                                     l_template,
                                     l_template_date,
                                     l_mime_type,
                                     l_mime_disp);

        select description
            into v_class
            from T_OSI_REFERENCE
        where code = osi_classification.get_report_class(l_obj);

        l_ok :=
            core_template.replace_tag(l_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, l_format),
                                      p_multiple       => true);

        --- Get Parts we can get from the Main Tables ---
        select s.participant, f.id, decode(s.burn_list, null, 'NO', 'N', 'NO', 'YES') as burn_list,
               decode(s.witting_source, null, 'NO', 'U', 'NO', 'N', 'NO', 'YES') as witting_source,
               m.description as mission_area
          into l_participant, l_id, l_burnlist,
               l_witting_source,
               l_mission_area
          from t_osi_file f, t_osi_f_source s, t_osi_mission_category m
         where f.sid = s.sid and s.sid = l_obj and s.mission_area = m.sid(+);

        --- Things from T_SOURCE and T_MISSION ---
        l_ok :=
            core_template.replace_tag(l_template,
                                      'SOURCE_NUMBER',
                                      osi_report.replace_special_chars(l_id, l_format));
        l_ok :=
            core_template.replace_tag(l_template,
                                      'WITTING_SOURCE',
                                      osi_report.replace_special_chars(l_witting_source, l_format));
        l_ok :=
            core_template.replace_tag(l_template,
                                      'MISSION_AREA',
                                      osi_report.replace_special_chars(l_mission_area, l_format));
        l_ok :=
            core_template.replace_tag(l_template,
                                      'BURN_LIST',
                                      osi_report.replace_special_chars(l_burnlist, l_format));

        --- Things from the PERSON Package ---
        begin
            select to_char(pv.dob, 'DD-Mon-YYYY'), pv.sex_desc, pa.single_line
              into l_dob, l_sex, l_address
              from v_osi_participant_version pv, v_osi_partic_address pa
             where pv.participant = l_participant
               and pv.current_version = pv.sid
               and pa.participant_version = pv.sid
               and pa.type_code = 'BIRTH';
        exception
            when no_data_found then
                null;
        end;

        l_ok :=
            core_template.replace_tag
                         (l_template,
                          'SOURCE_NAME',
                          osi_report.replace_special_chars(osi_participant.get_name(l_participant),
                                                           l_format));
        l_ok :=
            core_template.replace_tag(l_template,
                                      'SOURCE_BIRTH_DATA',
                                      osi_report.replace_special_chars(l_sex || ' Born: ' || l_dob
                                                                       || ' ' || l_address,
                                                                       l_format));
        l_ssn := osi_participant.get_number(l_participant, 'SSN');
        l_ok :=
            core_template.replace_tag
                       (l_template,
                        'SOURCE_RANK_SSN',
                        osi_report.replace_special_chars(osi_participant.get_rank(l_participant)
                                                         || ' ' || substr(l_ssn, 1, 3) || '-'
                                                         || substr(l_ssn, 4, 2) || '-'
                                                         || substr(l_ssn, 6, 4),
                                                         l_format));

        begin
            select pr.related_name, pa.single_line
              into l_latest_org, l_org_address
              from v_osi_partic_relation pr, v_osi_partic_address pa
             where pr.this_participant = l_participant
               and pr.relation_code = 'IMO'
               and pr.related_to = pa.participant
               and pa.participant_version = osi_participant.get_current_version(pr.related_to)
               and pa.is_current = 'Y';
        exception
            when others then
                l_latest_org := null;
                l_org_address := null;
        end;

        if (   l_latest_org is null
            or l_latest_org = '') then
            l_ok := core_template.replace_tag(l_template, 'SOURCE_UNIT', ' ');
        else
            l_ok :=
                core_template.replace_tag(l_template,
                                          'SOURCE_UNIT',
                                          osi_report.replace_special_chars(l_latest_org || ' '
                                                                           || l_org_address,
                                                                           l_format));
        end if;

        --- Things that are NOTES ---
        l_ok :=
            core_template.replace_tag
                                    (l_template,
                                     'BACKGROUND',
                                     osi_report.replace_special_chars(osi_note.latest_note(l_obj,
                                                                                           'BG'),
                                                                      l_format));
        l_ok :=
            core_template.replace_tag
                                    (l_template,
                                     'MOTIVATION',
                                     osi_report.replace_special_chars(osi_note.latest_note(l_obj,
                                                                                           'M'),
                                                                      l_format));
        l_ok :=
            core_template.replace_tag
                                    (l_template,
                                     'CONTACT_INFO',
                                     osi_report.replace_special_chars(osi_note.latest_note(l_obj,
                                                                                           'CI'),
                                                                      l_format));
        l_ok :=
            core_template.replace_tag
                                    (l_template,
                                     'TRANSFER',
                                     osi_report.replace_special_chars(osi_note.latest_note(l_obj,
                                                                                           'TR'),
                                                                      l_format));
        l_ok :=
            core_template.replace_tag
                                    (l_template,
                                     'TERMINATE',
                                     osi_report.replace_special_chars(osi_note.latest_note(l_obj,
                                                                                           'RFT'),
                                                                      l_format));
        --- Get Handling Agents ---
        l_ok :=
            core_template.replace_tag
                                (l_template,
                                 'HANDLING_AGENT',
                                 osi_report.replace_special_chars(osi_report.get_agent_name(l_obj),
                                                                  l_format));
        l_assist_agent := osi_report.get_agent_name(l_obj, 'AUX');

        if (   length(l_assist_agent) = 0
            or l_assist_agent is null) then
            l_assist_agent := osi_report.get_agent_name(l_obj, 'SUPPORT');
        end if;

        l_ok :=
            core_template.replace_tag(l_template,
                                      'ASST_HANDLING_AGENT',
                                      osi_report.replace_special_chars(l_assist_agent, l_format));
        --- C-Funds List ---
        osi_util.aitc(l_temp_clob,
                      osi_rtf.new_row || osi_rtf.new_cell(6600) || osi_rtf.new_cell(8160)
                      || osi_rtf.new_cell(9480));
        osi_util.aitc(l_temp_clob,
                      osi_rtf.put_in_row(osi_rtf.put_in_cell(osi_rtf.bold('Description'))
                                         || osi_rtf.put_in_cell(osi_rtf.bold('Incurred Date'))
                                         || osi_rtf.put_in_cell(osi_rtf.bold('Amount'))));

        for a in (select   to_char(incurred_date, 'DD-Mon-YYYY') as incurred_date,
                           trim(to_char(source_amount / nvl(conversion_rate, 1),
                                        '$9,999,999,999,990.00')) as source_amount,
                           description
                      from t_osi_activity ta, t_cfunds_expense_v3 tcev
                     where ta.source = l_obj and ta.sid = tcev.parent
                  order by tcev.incurred_date desc)
        loop
            osi_util.aitc(l_temp_clob,
                          osi_rtf.new_row || osi_rtf.new_cell(6600) || osi_rtf.new_cell(8160)
                          || osi_rtf.new_cell(9480));
            osi_util.aitc
                (l_temp_clob,
                 osi_rtf.put_in_row
                            (osi_rtf.put_in_cell(osi_report.replace_special_chars(a.description,
                                                                                  l_format))
                             || osi_rtf.put_in_cell(a.incurred_date)
                             || osi_rtf.put_in_cell(a.source_amount)));
        end loop;

        osi_util.aitc(l_temp_clob, osi_rtf.new_paragraph(''));
        l_ok := core_template.replace_tag(l_template, 'CFUNDS', l_temp_clob);
        --- Commodities List ---
        l_temp_clob := null;
        osi_util.aitc(l_temp_clob,
                      osi_rtf.new_row || osi_rtf.new_cell(1440) || osi_rtf.new_cell(9480));
        osi_util.aitc(l_temp_clob,
                      osi_rtf.put_in_row(osi_rtf.put_in_cell(osi_rtf.bold('Meet Date'))
                                         || osi_rtf.put_in_cell(osi_rtf.bold('Description'))));

        for a in (select   to_char(activity_date, 'DD-Mon-YYYY') as meet_date, commodity
                      from t_osi_a_source_meet tasm, t_osi_activity ta
                     where ta.source = l_obj and ta.sid = tasm.sid
                  order by ta.activity_date desc)
        loop
            osi_util.aitc(l_temp_clob,
                          osi_rtf.new_row || osi_rtf.new_cell(1440) || osi_rtf.new_cell(9480));
            osi_util.aitc
                (l_temp_clob,
                 osi_rtf.put_in_row
                                (osi_rtf.put_in_cell(a.meet_date)
                                 || osi_rtf.put_in_cell
                                                     (osi_report.replace_special_chars(a.commodity,
                                                                                       l_format))));
        end loop;

        osi_util.aitc(l_temp_clob, osi_rtf.new_paragraph(''));
        l_ok := core_template.replace_tag(l_template, 'COMMODITIES', l_temp_clob);
        --- Training List ---
        l_temp_clob := null;
        osi_util.aitc(l_temp_clob,
                      osi_rtf.new_row || osi_rtf.new_cell(1440) || osi_rtf.new_cell(9480));
        osi_util.aitc(l_temp_clob,
                      osi_rtf.put_in_row(osi_rtf.put_in_cell(osi_rtf.bold('Meet Date'))
                                         || osi_rtf.put_in_cell(osi_rtf.bold('Description'))));

        for a in (select   to_char(o.create_on, 'DD-Mon-YYYY') as create_date, description
                      from t_core_obj o,
                           t_osi_activity ta,
                           t_osi_a_srcmeet_training t,
                           t_osi_reference r
                     where o.sid = ta.sid
                       and ta.source = l_obj
                       and ta.sid = t.obj
                       and t.training = r.sid
                  order by o.create_on desc)
        loop
            osi_util.aitc(l_temp_clob,
                          osi_rtf.new_row || osi_rtf.new_cell(1440) || osi_rtf.new_cell(9480));
            osi_util.aitc
                (l_temp_clob,
                 osi_rtf.put_in_row
                              (osi_rtf.put_in_cell(a.create_date)
                               || osi_rtf.put_in_cell
                                                   (osi_report.replace_special_chars(a.description,
                                                                                     l_format))));
        end loop;

        osi_util.aitc(l_temp_clob, osi_rtf.new_paragraph(''));
        l_ok := core_template.replace_tag(l_template, 'TRAINING', l_temp_clob);
        --- Source Meet List ---
        l_temp_clob := null;
        osi_util.aitc(l_temp_clob,
                      osi_rtf.new_row || osi_rtf.new_cell(1440) || osi_rtf.new_cell(3000)
                      || osi_rtf.new_cell(9468));
        osi_util.aitc(l_temp_clob,
                      osi_rtf.put_in_row(osi_rtf.put_in_cell(osi_rtf.bold('Date'))
                                         || osi_rtf.put_in_cell(osi_rtf.bold('Type'))
                                         || osi_rtf.put_in_cell(osi_rtf.bold('Associated File'))));

        for a in (select   to_char(a.activity_date, 'DD-Mon-YYYY') as meet_date, r.description,
                           nvl(f.title, '     ') as ftitle
                      from t_osi_activity a,
                           t_osi_a_source_meet sm,
                           t_osi_reference r,
                           t_osi_assoc_fle_act afa,
                           t_osi_file f
                     where a.source = l_obj
                       and a.sid = sm.sid
                       and sm.contact_method = r.sid(+)
                       and a.sid = afa.activity_sid(+)
                       and afa.file_sid = f.sid(+)
                  order by a.activity_date desc, a.sid)
        loop
            osi_util.aitc
                (l_temp_clob,
                 osi_rtf.put_in_row
                            (osi_rtf.put_in_cell(a.meet_date)
                             || osi_rtf.put_in_cell
                                                   (osi_report.replace_special_chars(a.description,
                                                                                     l_format))
                             || osi_rtf.put_in_cell(osi_report.replace_special_chars(a.ftitle,
                                                                                     l_format))));
        end loop;

        l_ok := core_template.replace_tag(l_template, 'MEETS', l_temp_clob);
        return l_template;
        core_util.cleanup_temp_clob(l_template);
    exception
        when others then
            log_error('run_report: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            return l_template;
    end run_report;

    procedure burn(p_obj in varchar2) is
    begin
        update t_osi_f_source
           set burn_list = 'Y'
         where sid = p_obj;
    exception
        when others then
            log_error('burn: ' || sqlerrm);
            raise;
    end burn;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'OSI_SOURCE';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    procedure unburn(p_obj in varchar2) is
    begin
        update t_osi_f_source
           set burn_list = 'N'
         where sid = p_obj;
    exception
        when others then
            log_error('unburn: ' || sqlerrm);
            raise;
    end unburn;

    /* Given a Legacy I2MS Source SID, return the Source ID */
    function get_legacy_source_id(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(40);
    begin
        select id
          into v_return
          from ref_t_source
         where sid = p_obj;

        return v_return;
    exception
        when others then
            log_error('OSI_SOURCE.get_legacy_source_id: ' || sqlerrm);
            raise;
    end get_legacy_source_id;

    /* Used to search Web and Legacy I2MS Sources */
    procedure search_sources(p_session in out varchar2, p_source_id in varchar2) is
        procedure process_match(
            p_session         in   varchar2,
            p_sid             in   varchar2,
            p_web_or_legacy   in   varchar2) is
            v_cnt   number;
        begin
            --Clear Buffer
            v_cnt := 0;

            for k in (select sid
                        from t_osi_migration_source_hit
                       where user_session = p_session and source_sid = p_sid)
            loop
                --See if this source has been processed as a hit already
                v_cnt := v_cnt + 1;
            end loop;

            if (v_cnt > 0) then
                return;
            else
                for k in (select *
                            from t_osi_migration
                           where type = 'SOURCE' and old_sid = p_sid)
                loop
                    --See if this source has been imported already
                    v_cnt := v_cnt + 1;
                end loop;
            end if;

            if (v_cnt = 0) then
                insert into t_osi_migration_source_hit
                            (user_session, source_sid, database)
                     values (p_session, p_sid, p_web_or_legacy);

                commit;
            end if;
        end;
    begin
        --Get Session ID's
        --Legacy
        if (p_session is null) then
            --Get new Session ID
            p_session := core_sidgen.next_sid;

            --Just remove anything over 6 hours old
            delete from t_osi_migration_source_hit
                  where create_on < sysdate - .25;

            commit;
        else
            --Clear out old session data
            delete from t_osi_migration_source_hit
                  where user_session = p_session;

            commit;
        end if;

        --Search Web Database
        for k in (select tof.sid
                    from t_osi_file tof, t_osi_f_source ofs
                   where ofs.sid = tof.sid and tof.id like '%' || p_source_id || '%')
        loop
            process_match(p_session, k.sid, 'WEB');
        end loop;

        --Search Legacy Database
        for k in (select sid
                    from ref_t_source
                   where id like '%' || p_source_id || '%')
        loop
            process_match(p_session, k.sid, 'LEGACY');
        end loop;
    exception
        when others then
            log_error('OSI_SOURCE.search_sources: ' || sqlerrm);
            raise;
    end search_sources;

    /* Given a Source Type SID of an Object SID, return the Source Type Description */
    function get_source_type_desc(p_obj_or_source_type_sid in varchar2)
        return varchar2 is
        v_return            varchar2(100);
        v_source_type_sid   t_osi_f_source_type.sid%type;
    begin
        --Default the source type sid, then see if we need to change it...
        v_source_type_sid := p_obj_or_source_type_sid;

        --See if we've been passed an Object SID instead
        for k in (select source_type
                    from t_osi_f_source
                   where sid = p_obj_or_source_type_sid)
        loop
            v_source_type_sid := k.source_type;
            exit;
        end loop;

        --See if we can find a source type for the proper TYPE SID
        for k in (select description
                    from t_osi_f_source_type
                   where sid = v_source_type_sid)
        loop
            v_return := k.description;
            exit;
        end loop;

        return v_return;
    exception
        when others then
            log_error('OSI_SOURCE.get_source_type_desc: ' || sqlerrm);
            raise;
    end get_source_type_desc;

    /* Given a Source Type SID of an Object SID, return the Source Type CODE */
    function get_source_type_code(p_obj_or_source_type_sid in varchar2)
        return varchar2 is
        v_return            varchar2(100);
        v_source_type_sid   t_osi_f_source_type.sid%type;
    begin
        --Default the source type sid, then see if we need to change it...
        v_source_type_sid := p_obj_or_source_type_sid;

        --See if we've been passed an Object SID instead
        for k in (select source_type
                    from t_osi_f_source
                   where sid = p_obj_or_source_type_sid)
        loop
            v_source_type_sid := k.source_type;
            exit;
        end loop;

        --See if we can find a source type for the proper TYPE SID
        for k in (select code
                    from t_osi_f_source_type
                   where sid = v_source_type_sid)
        loop
            v_return := k.code;
            exit;
        end loop;

        return v_return;
    exception
        when others then
            log_error('OSI_SOURCE.get_source_type_code: ' || sqlerrm);
            raise;
    end get_source_type_code;

    /* Given a source ID return  Y/N depending where or not the source participant was imported from legacy */
    function src_partic_is_from_legacy(p_obj in varchar2)
        return varchar2 is
        v_participant_sid   t_osi_f_source.participant%type;
    begin
        --Note: Sources are tied to participant, not versions, so we just need
        --      to see if the participant SID is in the OSI_MIGRATION table (NEW_SID)
        select participant
          into v_participant_sid
          from t_osi_f_source
         where sid = p_obj;

        for k in (select new_sid
                    from t_osi_migration
                   where type = 'PARTICIPANT' and new_sid = v_participant_sid)
        loop
            return 'Y';
        end loop;

        return 'N';
    exception
        when no_data_found then
            --There is no participant on this source, so just return false
            return 'N';
        when others then
            log_error('OSI_SOURCE.src_partic_is_from_legacy: ' || sqlerrm);
            raise;
    end src_partic_is_from_legacy;

    /* Given a Source SID, return the Legacy Participant SID (If one exists) */
    function get_legacy_partic_sid(p_obj in varchar2)
        return varchar2 is
    begin
        --Get the Web participant SID
        for k in (select participant
                    from t_osi_f_source
                   where sid = p_obj)
        loop
            for j in (select old_sid
                        from t_osi_migration
                       where type = 'PARTICIPANT' and new_sid = k.participant)
            loop
                return j.old_sid;
            end loop;
        end loop;

        return '<none>';
    exception
        when others then
            log_error('OSI_SOURCE.get_legacy_partic_sid: ' || sqlerrm);
            raise;
    end get_legacy_partic_sid;

    /* Given a Source SID, returns Y/N depending on whether or not a Migratable Source exists in Legacy */
    function dup_source_exists_in_legacy(p_obj in varchar2)
        return varchar2 is
        v_partic_sid   varchar2(20);
    begin
        v_partic_sid := get_legacy_partic_sid(p_obj);

        for k in (select sid
                    from ref_t_source
                   where person = v_partic_sid)
        loop
            return 'Y';
        end loop;

        return 'N';
    exception
        when others then
            log_error('OSI_SOURCE.dup_source_exists_in_legacy: ' || sqlerrm);
            raise;
    end dup_source_exists_in_legacy;

    function get_legacy_source_sid(p_obj in varchar2)
        return varchar2 is
        v_partic_sid   varchar2(20);
    begin
        v_partic_sid := get_legacy_partic_sid(p_obj);

        for k in (select sid
                    from ref_t_source
                   where person = v_partic_sid)
        loop
            return k.sid;
        end loop;

        return '<none>';
    exception
        when others then
            log_error('OSI_SOURCE.get_legacy_source_sid: ' || sqlerrm);
            raise;
    end get_legacy_source_sid;

/* Given a Object SID or Mission Area SID, returns the mission area description */
    function get_mission_area_desc(p_obj_or_ma in varchar2)
        return varchar2 is
        v_temp   varchar2(40);
    begin
        begin
            --See if this is a Obj SID
            select mission_area
              into v_temp
              from t_osi_f_source
             where sid = p_obj_or_ma;
        exception
            when no_data_found then
                --The given parameter was not of the Object, but of the MA itself, so use it.
                v_temp := p_obj_or_ma;
        end;

        for k in (select code, description
                    from t_osi_mission_category
                   where sid = v_temp)
        loop
            return k.description || ' (' || k.code || ')';
        end loop;

        return null;
    exception
        when others then
            log_error('OSI_SOURCE.get_mission_area_desc: ' || sqlerrm);
            raise;
    end get_mission_area_desc;

    /* Given a Web Source SID, will generate Legacy Report and attach to the current Source */
    /* Note, this function is expecting a Legacy Source to Exist, this should be checked for already */
    function import_legacy_report(p_obj in varchar2)
        return varchar2 is
        v_legacy_source_sid   varchar2(20);
        v_legacy_partic_sid   varchar2(20);
        v_web_partic_sid      varchar2(20);
        --v_return              t_osi_attachment.sid%type   := '<none>';
        v_report_guts         clob;
        v_file_begin          varchar2(2000)
            := '{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}}{\colortbl;\red0\green0\blue0;\red0\green0\blue255;}{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20';
        v_file_end            varchar2(2000) := '\par }';
        v_temp1               varchar2(32000);
        v_temp2               varchar2(32000);
        v_cnt                 number;
        v_burncnt             number;
        v_legacy_id           varchar2(100);
        v_id                  varchar2(100);
        
        procedure mark_as_mig(
            p_type      in   varchar2,
            p_old_sid   in   varchar2,
            p_new_sid   in   varchar2,
            p_parent    in   varchar2) is
        begin
            insert into t_osi_migration
                        (type, old_sid, new_sid, date_time, parent)
                 values (p_type, p_old_sid, p_new_sid, sysdate, p_parent);
        exception
            when others then
                raise;
        end mark_as_mig;

        function is_witting_desc(p_obj in varchar2)
            return varchar2 is
        begin
            for k in (select witting_source
                        from t_osi_f_source
                       where sid = p_obj)
            loop
                if (k.witting_source is not null) then
                    if (k.witting_source = 'Y') then
                        return 'Yes';
                    elsif(k.witting_source = 'N') then
                        return 'No';
                    end if;
                end if;
            end loop;

            return null;
        end is_witting_desc;

        procedure couple_source_to_partic(
            p_legacy_partic_sid   in   varchar2,
            p_web_partic_sid      in   varchar2) is
            v_new_partic_org_sid   t_osi_participant.sid%type;
            v_new_sid_temp         t_osi_partic_relation.sid%type;
            v_temp                 varchar2(20);
        begin
            for k in (select sid, that_person, start_date, end_date, known_date, mod1_value,
                             mod2_value, mod3_value, comments
                        from ref_v_person_relation
                       where this_person = p_legacy_partic_sid)
            loop
                --See if this participant has a UIC (Need to look in the T_PERSON_VERSION table)
                for j in (select org_uic
                            from ref_t_person_version
                           where person = k.that_person and org_uic is not null
                                 and current_flag = 1)
                loop
                    --Search the Web System to see if we can find a participant with the
                    --same UIC code
                    for l in (select opv.participant, opv.sid
                                from t_osi_participant_nonhuman opn, t_osi_participant_version opv
                               where opn.sid = opv.sid and opn.org_uic = j.org_uic)
                    loop
                        --Last step in search, see if this PV record is a current PV record
                        begin
                            --We need to find a match on the Partic SID and the PV SID
                            select sid
                              into v_new_partic_org_sid
                              from t_osi_participant
                             where current_version = l.sid and sid = l.participant;

                            --If we didn't go into the exception, this is the one we want
                            --so--
                            --Get Relation Type
                            select sid
                              into v_temp
                              from t_osi_partic_relation_type
                             where code = 'OTH';

                            insert into t_osi_partic_relation
                                        (partic_a,
                                         partic_b,
                                         rel_type,
                                         start_date,
                                         end_date,
                                         known_date,
                                         mod1_value,
                                         mod2_value,
                                         mod3_value,
                                         comments)
                                 values (p_web_partic_sid,
                                         v_new_partic_org_sid,
                                         v_temp,
                                         k.start_date,
                                         k.end_date,
                                         k.known_date,
                                         k.mod1_value,
                                         k.mod2_value,
                                         k.mod3_value,
                                         k.comments)
                              returning sid
                                   into v_new_sid_temp;

                            mark_as_mig('SOURCE_PARTIC_ORG_TIE',
                                        k.sid,
                                        v_new_sid_temp,
                                        p_web_partic_sid);
                        exception
                            when no_data_found then
                                --This PV record is not the most current
                                --Not that it particularly matters, but if there are multiple
                                --PV records, from the same particiopant, with the same UIC,
                                --we don't want multiple person_relation records in the web system
                                exit;
                        end;
                    end loop;
                end loop;
            end loop;
        exception
            when others then
                raise;
        end couple_source_to_partic;
    begin
        --Get the sid of the Legacy Source record
        v_legacy_source_sid := get_legacy_source_sid(p_obj);
        --Get the SID of the legacy participant
        v_legacy_partic_sid := get_legacy_partic_sid(p_obj);
        --Start File
        v_report_guts := v_file_begin;

        --*****Header
        --Get Source ID
        select id
          into v_legacy_id
          from ref_t_source
         where sid = v_legacy_source_sid;

        v_temp1 := 'Legacy I2MS Import data for: Source ID - ' || '{\field{\*\fldinst{HYPERLINK "I2MS:://pSid=' || v_legacy_source_sid || '" \\o "Open in I2MS"}}{\fldrslt{\ul\cf2 ' || v_legacy_id || '}}} As of: ' || to_char(sysdate,'DD-Mon-YYYY') || ' \par\par\par ';

        v_report_guts := v_report_guts || v_temp1;
        v_temp1 := '';
        --Full Name
        v_temp1 := '\b Full Name: \b0 ' || '{\field{\*\fldinst{HYPERLINK "I2MS:://pSid=' || v_legacy_partic_sid || '" \\o "Open in I2MS"}}{\fldrslt{\ul\cf2 ' || ref_person.current_name(v_legacy_partic_sid) || '}}} \par ';
        v_report_guts := v_report_guts || v_temp1;
        --SSN or Other ID (if Available)
        v_temp1 := null;
        v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'SSN');

        if (v_temp2 is not null) then
            v_temp1 := '\b Social Security Number: \b0 ' || v_temp2;
        else
            v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'FID');

            if (v_temp2 is not null) then
                v_temp1 := '\b Foreign ID Number: \b0 ' || v_temp2;
            else
                v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'DL');

                if (v_temp2 is not null) then
                    v_temp1 := '\b Drivers License: \b0 ' || v_temp2;
                else
                    v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'PP');

                    if (v_temp2 is not null) then
                        v_temp1 := '\b Passport: \b0 ' || v_temp2;
                    else
                        v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'ARN');

                        if (v_temp2 is not null) then
                            v_temp1 := '\b Alien Registration Number: \b0 ' || v_temp2;
                        else
                            v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'FBI');

                            if (v_temp2 is not null) then
                                v_temp1 := '\b FBI Number: \b0 ' || v_temp2;
                            else
                                v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'PN');

                                if (v_temp2 is not null) then
                                    v_temp1 := '\b Position Number: \b0 ' || v_temp2;
                                else
                                    v_temp2 := ref_person.number_set(v_legacy_partic_sid, 'OTHER');

                                    if (v_temp2 is not null) then
                                        v_temp1 := '\b Other ID Number: \b0 ' || v_temp2;
                                    end if;
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;

        if (v_temp1 is not null) then
            v_report_guts := v_report_guts || v_temp1 || '\par ';
        else
            v_report_guts := v_report_guts || '\b Identifying Number: \b0 <none> \par ';
        end if;

        --Mission Area
        v_temp1 := '\b Mission Area: \b0 ' || get_mission_area_desc(p_obj) || '\par ';
        v_report_guts := v_report_guts || v_temp1;
        --Witting Source
        v_temp1 := '\b Source is Witting: \b0 ' || is_witting_desc(p_obj) || '\par ';
        v_report_guts := v_report_guts || v_temp1;
        
        --Burn List
        select burn_list
          into v_burncnt
          from ref_t_source
         where sid = v_legacy_source_sid;

        if (abs(v_burncnt) = 0) then
            --Not on burn list
            v_temp1 := '\b On Burn List: \b0 NO \par ';
        elsif(abs(v_burncnt) = 1) then
            --On Burn List
            v_temp1 := '\b On Burn List: \b0 YES \par ';
        elsif(v_burncnt is null) then
            --Unknown
            v_temp1 := '\b On Burn List: \b0 UNKNOWN \par ';
        end if;

        v_report_guts := v_report_guts || v_temp1;
        
        --Background
        v_temp1 := '\b Background: \b0 ' || '\par ';
        v_cnt := 0;

        --Notes
        --Transfer the notes to the temp table
        DELETE FROM T_OSI_MIGRATION_NOTES;
        INSERT INTO T_OSI_MIGRATION_NOTES SELECT * FROM ref_t_note_v2 WHERE PARENT=v_legacy_source_sid;
  
        for k in (select *
                    from T_OSI_MIGRATION_NOTES
                   where parent = v_legacy_source_sid and upper(category) = 'BACKGROUND')
        loop
            v_cnt := v_cnt + 1;
            v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 Note:' || k.note || ' \par \par ';
        end loop;

        if (v_cnt = 0) then
            v_temp1 := v_temp1 || 'No Background Data Found \par ';
        end if;

        v_report_guts := v_report_guts || v_temp1;
        --Motivation
        v_temp1 := '\b Motivation: \b0 ' || '\par ';
        v_cnt := 0;

        for k in (select *
                    from T_OSI_MIGRATION_NOTES
                   where parent = v_legacy_source_sid and upper(category) = 'MOTIVATION')
        loop
            v_cnt := v_cnt + 1;
            v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 Note:' || k.note || ' \par \par ';
        end loop;

        if (v_cnt = 0) then
            v_temp1 := v_temp1 || 'No Background Data Found \par ';
        end if;

        v_report_guts := v_report_guts || v_temp1;
        --Assignments
        v_temp1 := '\b Assignments: \b0 ' || '\par ';
        v_cnt := 0;

        for k in (select   vp.personnel_name, rta.assign_role, rta.start_date, rta.end_date
                      from ref_t_assignment rta, ref_v_personnel vp
                     where rta.parent = v_legacy_source_sid and vp.sid = rta.personnel
                  order by rta.start_date)
        loop
            v_cnt := v_cnt + 1;
            v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 Agent:' || k.personnel_name || ' \par ';
            v_temp1 := v_temp1 || 'Assignment Role:' || k.assign_role || ' \par ';
            v_temp1 := v_temp1 || 'Begin Date: ' || to_char(k.start_date, 'dd-Mon-rrrr')
                       || ' \par ';
            v_temp1 := v_temp1 || 'End Date: ' || to_char(k.end_date, 'dd-Mon-rrrr')
                       || ' \par\par ';
        end loop;

        if (v_cnt = 0) then
            v_temp1 := v_temp1 || 'No Assignment Data Found \par ';
        end if;
       
        ---Source Meet Associations---
        v_temp1 := v_temp1 || '\b Source Meet Associations\b0 \par ';
        FOR a in (select sid,id from ref_t_activity where source=v_legacy_source_sid)
        loop
            v_temp1 := v_temp1 || '{\field{\*\fldinst{HYPERLINK "I2MS:://pSid=' || a.sid || '" \\o "Open in I2MS"}}{\fldrslt{\ul\cf2 ' || a.id || '}}} \par ';

        end loop;
        
        v_report_guts := v_report_guts || v_temp1;

        ---Supported Files Associations---
        v_temp1 := '\par \b Supported Files\b0 \par ';
        for a in (select sid,id from ref_v_file_lookup_v2 where SID in (select FYLE from REF_T_FILE_CONTENT where ACTIVITY in (select SID from REF_T_ACTIVITY where SOURCE = v_legacy_source_sid)))
        loop
            v_temp1 := v_temp1 || '{\field{\*\fldinst{HYPERLINK "I2MS:://pSid=' || a.sid || '" \\o "Open in I2MS"}}{\fldrslt{\ul\cf2 ' || a.id || '}}} \par ';

        end loop;

        ---Collection Requirements File Associations---
        v_temp1 := v_temp1 || '\par \b Collection Requirements Files\b0 \par ';
        for a in (select sid,id from ref_v_file_lookup_v2 where SID in (select CRCE from REF_T_CR_USAGE where MEET in (select SID from REF_T_ACTIVITY where SOURCE = v_legacy_source_sid)))
        loop
            v_temp1 := v_temp1 || '{\field{\*\fldinst{HYPERLINK "I2MS:://pSid=' || a.sid || '" \\o "Open in I2MS"}}{\fldrslt{\ul\cf2 ' || a.id || '}}} \par ';

        end loop;

        ---IIR File Associations---
        v_temp1 := v_temp1 || '\par \b IIR Files\b0 \par ';
        for a in (select sid,id from ref_v_file_lookup_v2 where SID in (select IR from REF_T_IR_SOURCE where OSI_SOURCE = v_legacy_source_sid))
        loop
            v_temp1 := v_temp1 || '{\field{\*\fldinst{HYPERLINK "I2MS:://pSid=' || a.sid || '" \\o "Open in I2MS"}}{\fldrslt{\ul\cf2 ' || a.id || '}}} \par ';

        end loop;
                
        v_report_guts := v_report_guts || v_temp1;

        --Finish off file
        v_report_guts := v_report_guts || v_file_end;

        --Create Attachment
        insert into t_osi_attachment
                    (obj,
                     type,
                     content,
                     storage_loc_type,
                     description,
                     source,
                     mime_type,
                     creating_personnel)
             values (p_obj,
                     osi_attachment.get_attachment_type_sid(core_obj.lookup_objtype('FILE.SOURCE'),
                                                            'LEG_IMP',
                                                            'ATTACHMENT'),
                     hex_funcs.clob_to_blob(v_report_guts),
                     'DB',
                     'Source Migration Details',
                     'DetailReport.rtf',
                     'application/msword',
                     core_context.personnel_sid)
          returning sid
               into v_temp1;

        mark_as_mig('SOURCE_MISC_DETAIL_ATTACHMENT', null, v_temp1, p_obj);

        --Get Web Participant SID for UIC Unit Coupling
        select participant
          into v_web_partic_sid
          from t_osi_f_source
         where sid = p_obj;

        insert into z_richd_temp
                    (thevarchar2)
             values ('v_legacy_partic_sid:' || v_legacy_partic_sid || ' - v_web_partic_sid:'
                     || v_web_partic_sid);

        --Couple the new source to any non-indiv participants that it was coupled to
        --before (if possible)
        couple_source_to_partic(v_legacy_partic_sid, v_web_partic_sid);
        
        ---Put Legacy Source ID in Title---
        v_id := osi_file.get_id(p_obj);
        update t_osi_file set title=v_id  || ' (Legacy Source ID:  ' || v_legacy_id || ')' where sid=p_obj;
        
        return v_temp1;
    exception
        when others then
            log_error('OSI_SOURCE.import_legacy_report: ' || sqlerrm);
            raise;
    end import_legacy_report;
    
    /* Used to import a Legacy I2MS Source into Web I2MS */
    /* Note: this is the first run at Source import, which was never used, but I am leaving it
             here in case requirements change in the future */
--    function import_legacy_source(p_sid in varchar2)
--        return varchar2 is
--        v_new_sid_source        varchar2(20);
--        v_new_sid_participant   varchar2(20);
--        v_old_sid_participant   varchar2(20);
--        v_new_sid_temp          varchar2(20);
--        v_cnt                   number;
--        v_temp                  varchar2(20);
--        v_temp_2                varchar2(20);
--        v_temp_3                varchar2(20);
--        v_migration_cnt_total   number;
--        v_cannot_import         boolean;
--        v_temp_clob             clob;

--        procedure mark_as_mig(
--            p_type      in   varchar2,
--            p_old_sid   in   varchar2,
--            p_new_sid   in   varchar2,
--            p_parent    in   varchar2) is
--        begin
--            v_migration_cnt_total := v_migration_cnt_total + 1;

--            insert into t_osi_migration
--                        (type, old_sid, new_sid, date_time, num, parent)
--                 values (p_type, p_old_sid, p_new_sid, sysdate, v_migration_cnt_total, p_parent);
--        exception
--            when others then
--                raise;
--        end mark_as_mig;

--        function get_source_mig_info(p_sid in varchar2)
--            return clob is
--            v_file_begin   varchar2(2000)
--                := '{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}} {\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20';
--            v_file_end     varchar2(2000)  := '\par }';
--            v_return       clob;
--            v_temp1        varchar2(32000);
--            v_temp2        varchar2(32000);
--        begin
--            --Start File
--            v_return := v_file_begin;

--            --*****Header
--            --Get Source ID
--            select id
--              into v_temp2
--              from ref_t_source
--             where sid = p_sid;

--            v_temp1 :=
--                'Relational/Import data for: Source ID - ' || v_temp2 || ' \par  As of: ' || sysdate
--                || ' \par\par\par ';
--            v_return := v_return || v_temp1;
--            v_temp1 := '';
--            --*****Associated Activities
--            v_temp1 := null;
--            v_cnt := 0;
--            v_temp1 := '\b ASSOCIATED SOURCE MEET ACTIVITIES \b0 \par \par  ';

--            for k in (select distinct id, title, activity_date, auto_gen_title, status_desc
--                                 from ref_v_activity rva, ref_t_act_source_meet rtasm
--                                where rva.source = p_sid and rva.sid = rtasm.sid)
--            loop
--                v_cnt := v_cnt + 1;
--                v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 Activity ID: ' || k.id || '\par ';
--                v_temp1 := v_temp1 || 'Activity Title: ' || k.title || '\par ';
--                v_temp1 := v_temp1 || 'Activity Date: ' || k.activity_date || '\par ';
--                v_temp1 := v_temp1 || 'Source Meet Title: ' || k.auto_gen_title || '\par ';
--                v_temp1 := v_temp1 || 'Status: ' || k.status_desc || '\par \par ';
--            end loop;

--            if (v_cnt = 0) then
--                v_temp1 := v_temp1 || 'No Data Found \par ';
--            end if;

--            --Concatonate the activities
--            v_return := v_return || v_temp1 || ' \par ';
--            --Clear buffer(s)
--            v_temp1 := null;
--            v_cnt := 0;
--            v_temp1 := '\b ASSOCIATED FILES \b0 \par \par ';

--            --*****Associated Files
--            for k in (select id, title, subtype_desc, status_desc
--                        from ref_v_file_lookup_v2
--                       where (   (sid in(select fyle
--                                           from ref_t_file_content
--                                          where activity in(select sid
--                                                              from ref_t_activity
--                                                             where source = p_sid)))
--                              or (sid in(select crce
--                                           from ref_t_cr_usage
--                                          where meet in(select sid
--                                                          from ref_t_activity
--                                                         where source = p_sid)))
--                              or (sid in(select ir
--                                           from ref_t_ir_source
--                                          where osi_source = p_sid))))
--            loop
--                v_cnt := v_cnt + 1;
--                v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 File ID: ' || k.id || '\par ';
--                v_temp1 := v_temp1 || 'File Title: ' || k.title || '\par ';
--                v_temp1 := v_temp1 || 'File Type: ' || k.subtype_desc || '\par ';
--                v_temp1 := v_temp1 || 'Status: ' || k.status_desc || '\par \par ';
--            end loop;

--            if (v_cnt = 0) then
--                v_temp1 := v_temp1 || 'No Data Found \par ';
--            end if;

--            --Concatonate the files
--            v_return := v_return || v_temp1 || ' \par ';
--            --Clear buffer(s)
--            v_temp1 := null;
--            v_cnt := 0;
--            v_temp1 := '\b TRAINING \b0 \par \par ';

--            --*****Associated Files
--            for k in (select   training_desc, meet_date, duration, comments
--                          from ref_v_training
--                         where meet in(select sid
--                                         from ref_t_activity
--                                        where source = p_sid)
--                      order by meet_date)
--            loop
--                v_cnt := v_cnt + 1;
--                v_temp1 :=
--                    v_temp1 || '\b ' || v_cnt || '.> \b0 Type of Training: ' || k.training_desc
--                    || '\par ';
--                v_temp1 := v_temp1 || 'Training Date: ' || k.meet_date || '\par ';
--                v_temp1 := v_temp1 || 'Duration: ' || k.duration || '\par ';
--                v_temp1 := v_temp1 || 'Comments: ' || k.comments || '\par \par ';
--            end loop;

--            if (v_cnt = 0) then
--                v_temp1 := v_temp1 || 'No Data Found \par ';
--            end if;

--            --Concatonate the training
--            v_return := v_return || v_temp1 || ' \par ';
--            --Clear buffer(s)
--            v_temp1 := null;
--            v_cnt := 0;
--            v_temp1 := '\b HIGH RISK ORGANIZATIONS SUPPORTED \b0 \par \par ';

--            --*****High Risk Orgs Supported
--            for k in (select   name, create_on
--                          from ref_v_person_involvement_v2
--                         where parent = p_sid
--                      order by involvement_role)
--            loop
--                v_cnt := v_cnt + 1;
--                v_temp1 :=
--                     v_temp1 || '\b ' || v_cnt || '.> \b0 Organization Name:' || k.name || ' \par ';
--                v_temp1 := v_temp1 || 'Start Date: ' || trunc(k.create_on) || ' \par ';
--                v_temp1 := v_temp1 || ' \par ';
--            end loop;

--            if (v_cnt = 0) then
--                v_temp1 := v_temp1 || 'No Data Found \par ';
--            end if;

--            --Concatonate the high risk orgs
--            v_return := v_return || v_temp1 || ' \par ';
--            --Finish off file
--            v_return := v_return || v_file_end;
--            --Send home
--            return v_return;
--        end get_source_mig_info;
--    begin
--        --Clear Buffer
--        v_cnt := 0;

--        --First see if the participant has been imported
--        --Get Legacy participant SID
--        select person
--          into v_old_sid_participant
--          from ref_t_source
--         where sid = p_sid;

--        --See if this participant has been migrated
--        select count(new_sid)
--          into v_cnt
--          from t_osi_migration
--         where old_sid = v_old_sid_participant;

--        if (v_cnt > 0) then
--            --If so, then use the sid
--            select new_sid
--              into v_new_sid_participant
--              from t_osi_migration
--             where old_sid = v_old_sid_participant and type = 'PARTICIPANT';
--        else
--            --Otherwise, need to import this person

--            --Get the latest version of this person from Legacy
--            --(need to because the import_legacy_participant function
--            --requires a person version)
--            select sid
--              into v_temp
--              from ref_t_person_version
--             where person = v_old_sid_participant and current_flag = 1;

--            --Import legacy particpant
--            v_new_sid_participant := osi_participant.import_legacy_participant(v_temp);
--        end if;

--        for k in (select *
--                    from ref_t_source
--                   where sid = p_sid)
--        loop
--            --Import Source
--            --Core Obj Record
--            insert into t_core_obj
--                        (obj_type)
--                 values (core_obj.lookup_objtype('FILE.SOURCE'))
--              returning sid
--                   into v_new_sid_source;

--            --OSI File Record
--            --(Using the ID as the Title)
--            insert into t_osi_file
--                        (sid, title, id, restriction)
--                 values (v_new_sid_source,
--                         k.id,
--                         k.id,
--                         osi_reference.lookup_ref_sid('RESTRICTION', 'PERSONNEL'));

--            --Set the starting status
--            osi_status.change_status_brute
--                            (v_new_sid_source,
--                             osi_status.get_starting_status(core_obj.lookup_objtype('FILE.SOURCE')),
--                             'Created - Imported From Legacy I2MS');

--            --Get Source Type
--            select sid
--              into v_temp
--              from t_osi_f_source_type
--             where code = k.source_type;

--            --Get Witting
--            v_temp_2 := 'N';

--            if (k.witting_source is not null) then
--                if (abs(k.witting_source) > 0) then
--                    v_temp_2 := 'Y';
--                end if;
--            else
--                v_temp_2 := 'U';
--            end if;

--            --Get Mission Area
--            if (k.mission_area is not null) then
--                select sid
--                  into v_temp_3
--                  from t_osi_mission_category
--                 where code = k.mission_area;
--            else
--                v_temp_3 := null;
--            end if;

--            --Source Record
--            insert into t_osi_f_source
--                        (sid, source_type, participant, witting_source, mission_area)
--                 values (v_new_sid_source, v_temp, v_new_sid_participant, v_temp_2, v_temp_3);

--            mark_as_mig('SOURCE', k.sid, v_new_sid_source, null);
--        end loop;

--        --Attachments
--        for k in (select *
--                    from ref_t_attachment_v3
--                   where parent = p_sid)
--        loop
--            --Get Creating Personnel
--            if (k.attach_by is not null) then
--                begin
--                    select new_sid
--                      into v_temp
--                      from t_osi_migration
--                     where type = 'PERSONNEL' and old_sid = k.attach_by;
--                exception
--                    when others then
--                        --If personnel is not found, then use the current personnel
--                        v_temp := core_context.personnel_sid;
--                end;
--            else
--                --Personnel should never be null, but if it is, use the current User.
--                v_temp := core_context.personnel_sid;
--            end if;

--            --Note: Do not need Attachment Type
--            insert into t_osi_attachment
--                        (obj,
--                         content,
--                         storage_loc_type,
--                         description,
--                         source,
--                         mime_type,
--                         creating_personnel,
--                         lock_mode,
--                         date_modified)
--                 values (v_new_sid_source,
--                         k.blob_content,
--                         k.attach_location,
--                         k.description,
--                         k.source_location,
--                         null,
--                         v_temp,
--                         k.locked,
--                         k.content_date)
--              returning sid
--                   into v_new_sid_temp;

--            mark_as_mig('SOURCE_ATCH', k.sid, v_new_sid_temp, v_new_sid_source);
--        end loop;

--        --Assignments
--        for k in (select *
--                    from ref_t_assignment
--                   where parent = p_sid)
--        loop
--            --Clear Buffers
--            v_cannot_import := false;

--            --Get Personnel
--            begin
--                select new_sid
--                  into v_temp
--                  from t_osi_migration
--                 where type = 'PERSONNEL' and old_sid = k.personnel;
--            exception
--                when others then
--                    v_cannot_import := true;
--            end;

--            --Get assignment role
--            select sid
--              into v_temp_2
--              from t_osi_assignment_role_type
--             where upper(description) = upper(k.assign_role)
--               and (   obj_type = core_obj.lookup_objtype('FILE')
--                    or obj_type = core_obj.lookup_objtype('ALL'));

--            if (v_cannot_import = false) then
--                insert into t_osi_assignment
--                            (obj, personnel, assign_role, start_date, end_date, unit)
--                     values (v_new_sid_source,
--                             v_temp,
--                             v_temp_2,
--                             k.start_date,
--                             k.end_date,
--                             osi_personnel.get_current_unit(v_temp))
--                  returning sid
--                       into v_new_sid_temp;

--                mark_as_mig('SOURCE_ASSIGNMENT', k.sid, v_new_sid_temp, v_new_sid_source);
--            else
--                mark_as_mig('SOURCE_ASSIGNMENT_FAIL', k.sid, v_new_sid_temp, v_new_sid_source);
--            end if;
--        end loop;

--        --Notes
--        for k in (select *
--                    from ref_t_note_v2
--                   where parent = p_sid)
--        loop
--            --Get Category
--            if (k.category is not null) then
--                begin
--                    select sid
--                      into v_temp
--                      from t_osi_note_type
--                     where obj_type = core_obj.lookup_objtype('FILE.SOURCE')
--                       and upper(description) = upper(k.category);
--                exception
--                    when others then
--                        --If not type is not found, then use the 'Unknown note type from Legacy Source Import' note.
--                        v_temp :=
--                              osi_note.get_note_type(core_obj.lookup_objtype('FILE.SOURCE'), 'UNK');
--                end;
--            else
--                --Category should never be null, but if it is, just use "Unknown note type from Legacy Source Import" note.
--                v_temp := osi_note.get_note_type(core_obj.lookup_objtype('PART.INDIV'), 'ADD_INFO');
--            end if;

--            --Get Creating Personnel
--            if (k.personnel is not null) then
--                begin
--                    select new_sid
--                      into v_temp_2
--                      from t_osi_migration
--                     where type = 'PERSONNEL' and old_sid = k.personnel;
--                exception
--                    when others then
--                        --If personnel is not found, then use the current personnel
--                        v_temp_2 := core_context.personnel_sid;
--                end;
--            else
--                --Personnel should never be null, but if it is, use the current User.
--                v_temp_2 := core_context.personnel_sid;
--            end if;

--            --Main Insert
--            --(Note, locking all notes as IMMED, Legacy handles Source Notes differently, so we're just locking them all so the results are the same in Web)
--            insert into t_osi_note
--                        (obj, note_type, note_text, creating_personnel, lock_mode)
--                 values (v_new_sid_source, v_temp, k.note, v_temp_2, 'IMMED')
--              returning sid
--                   into v_new_sid_temp;

--            mark_as_mig('SOURCE_NOTE', k.sid, v_new_sid_temp, v_new_sid_source);
--        end loop;

--        --Misc. Source Info
--        v_temp_clob := get_source_mig_info(p_sid);

--        insert into t_osi_attachment
--                    (obj,
--                     content,
--                     storage_loc_type,
--                     description,
--                     source,
--                     mime_type,
--                     creating_personnel)
--             values (v_new_sid_source,
--                     hex_funcs.clob_to_blob(v_temp_clob),
--                     'DB',
--                     'Source Migration Details',
--                     'DetailReport.rtf',
--                     'application/msword',
--                     core_context.personnel_sid)
--          returning sid
--               into v_new_sid_temp;

--        mark_as_mig('SOURCE_MISC_DETAIL_ATTACHMENT', null, v_new_sid_temp, v_new_sid_source);

--        --Set the owning unit
--        --Get old sid of owning unit
--        select unit
--          into v_temp
--          from ref_t_file_unit
--         where fyle = p_sid and end_date is null;

--        --Get new sid of owning unit
--        select new_sid
--          into v_temp
--          from t_osi_migration
--         where old_sid = v_temp and type = 'UNIT';

--        --Set to the unit of the current assigned personnel
--        osi_file.set_unit_owner(v_new_sid_source, v_temp, 'Owned prior to Legacy Source Import');
--        return v_new_sid_source;
--    exception
--        when others then
--            log_error('OSI_SOURCE.import_legacy_source: ' || sqlerrm);
--            raise;
--    end import_legacy_source;
--grant select on t_source to webi2ms;
--grant select on t_source to webi2ms;
--grant select on t_assignment to webi2ms;
--grant select on t_act_source_meet to webi2ms;
--grant select on v_activity to webi2ms;
--grant select on t_file_content to webi2ms;
--grant select on t_cr_usage to webi2ms;
--grant select on t_ir_source to webi2ms;
--grant select on v_file_lookup_v2 to webi2ms;
--grant select on v_training to webi2ms;
--grant select on v_person_involvement_v2 to webi2ms;
--grant select on t_file_unit to webi2ms;

--create synonym ref_t_source for i2ms.t_source;
--create synonym ref_t_source_type for i2ms.t_source_type;
--create synonym ref_t_assignment for i2ms.t_assignment;
--create synonym ref_t_act_source_meet for i2ms.t_act_source_meet;
--create synonym ref_v_activity for i2ms.v_activity;
--create synonym ref_t_file_content for i2ms.t_file_content;
--create synonym ref_t_cr_usage for i2ms.t_cr_usage;
--create synonym ref_t_ir_source  for i2ms.t_ir_source;
--create synonym ref_v_file_lookup_v2 for i2ms.v_file_lookup_v2;
--create synonym ref_v_training  for i2ms.v_training;
--create synonym ref_v_person_involvement_v2  for i2ms.v_person_involvement_v2;
--create synonym ref_t_file_unit  for i2ms.t_file_unit;
end osi_source;
/
