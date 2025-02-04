--run on webi2ms schema
CREATE SYNONYM REF_T_ACTIVITY FOR i2ms.T_ACTIVITY@LEGACY.DIMRO;
CREATE SYNONYM REF_V_FILE_LOOKUP_V2 for i2ms.V_FILE_LOOKUP_V2@LEGACY.DIMRO;
CREATE SYNONYM REF_T_FILE_CONTENT for i2ms.T_FILE_CONTENT@LEGACY.DIMRO;
CREATE SYNONYM REF_T_CR_USAGE for i2ms.T_CR_USAGE@LEGACY.DIMRO;
CREATE SYNONYM REF_T_IR_SOURCE for i2ms.T_IR_SOURCE@LEGACY.DIMRO;
commit;

 set define off;

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
--   Date and Time:   10:13 Tuesday April 19, 2011
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

PROMPT ...Remove page 1350
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1350);
 
end;
/

 
--application/pages/page_01350
prompt  ...PAGE 1350: Desktop Sources
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1350,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Sources',
  p_step_title=> '&DESKTOP_TITLE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 92011431286949262+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110419101255',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '13-DEC-2010 J.Faris WCHG0000264 - DT view query updates for performance.'||chr(10)||
''||chr(10)||
'19-Apr-2011 Tim Ward - CR#3784 - Added Title to the available columns.');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url, '||chr(10)||
'       f.id as "ID",'||chr(10)||
'       st.description as "Source Type",'||chr(10)||
'       decode(osi_object.get_lead_agent(o.sid),'||chr(10)||
'              null, ''NO LEAD AGENT'','||chr(10)||
'              osi_personnel.get_name(osi_object.get_lead_agent(o.sid))) as "Lead Agent",'||chr(10)||
'       osi_unit.get_name('||chr(10)||
'            osi_object.get_assigned_unit(o.sid)) as "Controlling Unit",'||chr(10)||
'       os';

s:=s||'i_object.get_status(o.sid) as "Status",'||chr(10)||
'       mc.description as "Mission Area",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       f.title as "Title"'||chr(10)||
'  from        (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed)';

s:=s||' last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_f_source f2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = f2.sid'||chr(10)||
'             and (   (    :p1350_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1350_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user';

s:=s||'_sid))'||chr(10)||
'                  or (    :p1350_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1350_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (    :p1350_filter = ''ME'' '||chr(10)||
'                      and osi_object.is_assigned(o1.sid)=''Y'')'||chr(10)||
'                  or (    :p1350_filter = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          o';

s:=s||'si_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1350_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'                  or (    :p1350_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ';

s:=s||'in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'                                 osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_osi_file f,'||chr(10)||
'       t_osi_f_source s,'||chr(10)||
'       t_osi_f_source_type st,'||chr(10)||
'       t_';

s:=s||'osi_mission_category mc'||chr(10)||
' where o.sid = s.sid'||chr(10)||
'   and s.sid = f.sid'||chr(10)||
'   and s.source_type = st.sid'||chr(10)||
'   and mc.sid(+) = s.mission_area';

wwv_flow_api.create_page_plug (
  p_id=> 1627501569148425 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
  p_plug_name=> 'Management Files > Sources',
  p_region_name=>'',
  p_plug_template=> 92167138176750921+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.SOURCE''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url, '||chr(10)||
'       f.id as "ID",'||chr(10)||
'       st.description as "Source Type",'||chr(10)||
'       decode(osi_object.get_lead_agent(o.sid),'||chr(10)||
'              null, ''NO LEAD AGENT'','||chr(10)||
'              osi_personnel.get_name(osi_object.get_lead_agent(o.sid))) as "Lead Agent",'||chr(10)||
'       osi_unit.get_name('||chr(10)||
'            osi_object.get_assigned_unit(o.sid)) as "Controlling Unit",'||chr(10)||
'       os';

a1:=a1||'i_object.get_status(o.sid) as "Status",'||chr(10)||
'       mc.description as "Mission Area",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       f.title as "Title"'||chr(10)||
'  from        (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed)';

a1:=a1||' last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_f_source f2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = f2.sid'||chr(10)||
'             and (   (    :p1350_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1350_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user';

a1:=a1||'_sid))'||chr(10)||
'                  or (    :p1350_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1350_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (    :p1350_filter = ''ME'' '||chr(10)||
'                      and osi_object.is_assigned(o1.sid)=''Y'')'||chr(10)||
'                  or (    :p1350_filter = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          o';

a1:=a1||'si_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1350_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'                  or (    :p1350_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ';

a1:=a1||'in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'                                 osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_osi_file f,'||chr(10)||
'       t_osi_f_source s,'||chr(10)||
'       t_osi_f_source_type st,'||chr(10)||
'       t_';

a1:=a1||'osi_mission_category mc'||chr(10)||
' where o.sid = s.sid'||chr(10)||
'   and s.sid = f.sid'||chr(10)||
'   and s.source_type = st.sid'||chr(10)||
'   and mc.sid(+) = s.mission_area';

wwv_flow_api.create_worksheet(
  p_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1350,
  p_region_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_name => 'Management > Sources',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Sources found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1350_FILTER',
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
  p_show_detail_link          =>'C',
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
  p_download_filename         =>'&P1350_EXPORT_NAME.',
  p_detail_link              =>'#URL#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="" />',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1629321372164871+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'URL',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'url',
  p_report_label           =>'url',
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
  p_display_text_as        =>'HIDDEN',
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
  p_id => 1627811385148432+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'ID',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'ID',
  p_report_label           =>'ID',
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
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1627900294148437+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Source Type',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Source Type',
  p_report_label           =>'Source Type',
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
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1629431521164873+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created On',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Created On',
  p_report_label           =>'Created On',
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
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'&FMT_DATE.',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1629523554164873+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created By',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Created By',
  p_report_label           =>'Created By',
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
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2472715546498920+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Lead Agent',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Lead Agent',
  p_report_label           =>'Lead Agent',
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
  p_id => 2472818571498925+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Controlling Unit',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Controlling Unit',
  p_report_label           =>'Controlling Unit',
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
  p_id => 2472903330498925+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Status',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Status',
  p_report_label           =>'Status',
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
  p_id => 2473001537498926+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Mission Area',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Mission Area',
  p_report_label           =>'Mission Area',
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
  p_id => 5345425169033933+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Title',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
  p_column_label           =>'Title',
  p_report_label           =>'Title',
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
  p_id => 1628100116149296+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'ID:Source Type:Lead Agent:Controlling Unit:Status:Mission Area:Created On',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'You do not have access privileges for this folder.';

wwv_flow_api.create_page_plug (
  p_id=> 6187026444290582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
  p_plug_name=> 'Access Restricted',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.SOURCE''))=''N''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15469607162508987 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1350,
  p_button_sequence=> 10,
  p_button_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1350);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>2474300917513654 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_branch_action=> 'f?p=&APP_ID.:1350:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 06-APR-2010 12:17 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2473712214507409 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_name=>'P1350_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER',
  p_lov => '.'||to_char(6129207658248740 + wwv_flow_api.g_id_offset)||'.',
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
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15469813742510910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_name=>'P1350_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
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
  p_id=> 2473816716508753 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_computation_sequence => 10,
  p_computation_item=> 'P1350_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1350_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1350
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
--   Date and Time:   08:08 Tuesday April 19, 2011
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

PROMPT ...Remove page 11300
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11300);
 
end;
/

 
--application/pages/page_11300
prompt  ...PAGE 11300: Source (Create)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'if("&REQUEST." == "CREATE_RETURN"){'||chr(10)||
'  passBack("&P11300_SID.");'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function passBack(pSid){'||chr(10)||
'  opener.document.getElementById("&P11300_RETURN_ITEM.").value = pSid;'||chr(10)||
'  opener.doSubmit("&P11300_RETURN_ITEM.");'||chr(10)||
'  close();'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'"JS_POPUP_OBJ_DATA"'||chr(10)||
'"JS_CREATE_PARTIC_WIDGET"'||chr(10)||
'"JS_POPUP_LOCATOR"';

wwv_flow_api.create_page(
  p_id     => 11300,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Source (Create)',
  p_step_title=> 'Source (Create)',
  p_step_sub_title => 'Source (Create)',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817023621004643+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110419080811',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '19-Apr-2011 - Tim Ward CR#3643 - Change "Witting Source?" to "This Source is'||chr(10)||
'                                 Witting?" and change it to default to ?.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>11300,p_text=>ph);
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
  p_id=> 1915428808037703 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11300,
  p_plug_name=> 'Source',
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
  p_id             => 1915616275037706 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11300,
  p_button_sequence=> 10,
  p_button_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11300_MODE',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 2060904344413700 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11300,
  p_button_sequence=> 15,
  p_button_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P11300_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1915812731037706 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11300,
  p_button_sequence=> 20,
  p_button_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>1918301443037715 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_branch_action=> 'f?p=&APP_ID.:10250:&SESSION.:OPEN:&DEBUG.:11300::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_branch_condition=> 'CREATE',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-NOV-2009 15:42 by THOMAS');
 
wwv_flow_api.create_page_branch(
  p_id=>1918532676037717 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_branch_action=> 'f?p=&APP_ID.:11300:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-NOV-2009 13:40 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1916004564037709 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_MISSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Mission Area',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> '%null%',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_mission_category'||chr(10)||
'   where management_area = ''Y'' and active = ''Y'''||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Mission Area -',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1916206636037710 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_WITTING',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'This Source is Witting?',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_id=>1916403235037710 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
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
  p_id=>1916628550037712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Source Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_f_source_type'||chr(10)||
'   where active = ''Y'''||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Source Type -',
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
  p_id=>1916810168037712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_SOURCE_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Source',
  p_source=>'osi_participant.get_name(:p11300_source);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
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
  p_id=>1917021757037712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(400,''P11300_SOURCE'',''N'','''',''PART.INDIV'');">&ICON_LOCATOR.</a>',
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
  p_id=>1917205771037712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a href="'' || osi_object.get_object_url(:P11300_SOURCE) || ''">&ICON_MAGNIFY.</a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P11300_SOURCE',
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
  p_id=>1917402828037714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_CREATE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a title="Create Participant" href="javascript:createParticWidget(''P11300_SOURCE'');">&ICON_CREATE_PERSON.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
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
  p_id=>2060622090399870 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
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
  p_id=>2062514087794942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
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
  p_id=>2064520217014335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11300,
  p_name=>'P11300_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 1915428808037703+wwv_flow_api.g_id_offset,
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
  p_id => 1917714702037714 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11300,
  p_validation_name => 'P11300_TYPE Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P11300_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Source Type must be specified.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 1916628550037712 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 11-NOV-2009 14:48');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 9205516864722103 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11300,
  p_validation_name => 'Privilege to create source type',
  p_validation_sequence=> 2,
  p_validation => 'declare'||chr(10)||
'    l_action   t_osi_auth_action_type.code%type;'||chr(10)||
'begin'||chr(10)||
'    select at.code'||chr(10)||
'      into l_action'||chr(10)||
'      from t_osi_f_source_type st, t_osi_auth_priv p, t_osi_auth_action_type at'||chr(10)||
'     where st.sid = :p11300_type and st.privilege = p.sid and p.action = at.sid;'||chr(10)||
''||chr(10)||
'    if (osi_auth.check_for_priv(l_action, :p0_obj_type_sid) = ''Y'') then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'exception'||chr(10)||
'    when no_data_found then'||chr(10)||
'        return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'You are not authorized to create this type of Source.',
  p_validation_condition=> ':request like ''CREATE%''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 1916628550037712 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 1917908379037715 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11300,
  p_validation_name => 'P11300_SOURCE Not Null',
  p_validation_sequence=> 3,
  p_validation => 'P11300_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Source must be specified.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 1916810168037712 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 11-NOV-2009 14:48');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||':p0_obj := osi_source.create_instance(:p11300_type, :p11300_source, :p11300_witting, :p11300_mission);'||chr(10)||
':p11300_sid := :p0_obj;';

wwv_flow_api.create_page_process(
  p_id     => 1918012744037715 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11300,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create instance',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CREATE,CREATE_RETURN',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 11300
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
--   Date and Time:   08:06 Tuesday April 19, 2011
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

PROMPT ...Remove page 11315
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11315);
 
end;
/

 
--application/pages/page_11315
prompt  ...PAGE 11315: Source Bio Information
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_OBJ_DATA"'||chr(10)||
'"JS_CREATE_PARTIC_WIDGET"'||chr(10)||
'"JS_POPUP_LOCATOR"';

wwv_flow_api.create_page(
  p_id     => 11315,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Source Bio Information',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title => 'Source Bio Information',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'<!--'||chr(10)||
' var src = document.getElementById(''P11315_SOURCE'');'||chr(10)||
' var src_info_ro = document.getElementById(''P11315_SOURCE_INFO_RO'');'||chr(10)||
' var witting_ro = document.getElementById(''P11315_WITTING_INFO_RO'');'||chr(10)||
' var banner = document.getElementById(''SrcBioreadOnlyBanner'');'||chr(10)||
' var writeable = document.getElementById(''P0_WRITABLE'');'||chr(10)||
' '||chr(10)||
' if (writeable.value=="Y")'||chr(10)||
'    {'||chr(10)||
'     if(src.value.length>0 && src_info_ro.value.length>0 && witting_ro.value.length>0)'||chr(10)||
'       banner.style.display="inline";'||chr(10)||
'     else'||chr(10)||
'       banner.style.display="none";'||chr(10)||
'    }'||chr(10)||
'//-->'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817023621004643+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110419080617',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '19-Apr-2011 - Tim Ward CR#3643 - Change "Witting Source?" to "This Source is'||chr(10)||
'                                 Witting?" and change it to default to ?.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>11315,p_text=>ph);
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
  p_id=> 1924123711044818 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11315,
  p_plug_name=> 'Bio Information',
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
s:=s||'<center><div class="readOnlyBanner" id="SrcBioreadOnlyBanner" style="display:none;"><span>READ-ONLY</span></div></center>';

wwv_flow_api.create_page_plug (
  p_id=> 4759028830200262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11315,
  p_plug_name=> 'Read-Only Banner - Source Bio Info',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .001,
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
  p_plug_display_condition_type => '',
  p_plug_display_when_condition => ':P0_WRITABLE = ''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 1924324964044820 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11315,
  p_button_sequence=> 10,
  p_button_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':p11315_source_ro is null or'||chr(10)||
':p11315_source_info_ro is null or'||chr(10)||
':p11315_witting_info_ro is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1924519805044821 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11315,
  p_button_sequence=> 15,
  p_button_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
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
  p_id=>1927615292044829 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST LIKE ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 12-NOV-2009 14:54 by THOMAS');
 
wwv_flow_api.create_page_branch(
  p_id=>1927827065044829 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_branch_action=> 'f?p=&APP_ID.:11315:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 12-NOV-2009 14:55 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1924705433044821 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'PARTICIPANT',
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
  p_id=>1924907383044823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Source Name',
  p_source=>'osi_participant.get_name(:p11315_source);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P11315_SOURCE_RO.',
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
  p_id=>1925117458044823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(400,''P11315_SOURCE'',''N'','''',''PART.INDIV'');">&ICON_LOCATOR.</a>',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P11315_SOURCE_RO',
  p_display_when_type=>'ITEM_IS_NULL',
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
  p_id=>1925306540044823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 111,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a href="'' || osi_object.get_object_url(:P11315_SOURCE) || ''">&ICON_MAGNIFY.</a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
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
  p_id=>1925509129044825 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_CREATE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 112,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:createParticWidget(''P11315_SOURCE'');">&ICON_CREATE_PERSON.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P11315_SOURCE_RO',
  p_display_when_type=>'ITEM_IS_NULL',
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
  p_id=>1925701853044825 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_WITTING',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'This Source is Witting?',
  p_source=>'WITTING_SOURCE',
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => '&P11315_WITTING_INFO_RO.',
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
  p_id=>1925912463044825 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_MISSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Mission Area',
  p_source=>'MISSION_AREA',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_mission_category'||chr(10)||
'   where management_area = ''Y'' and active = ''Y'''||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Mission Area -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => '&P11315_SOURCE_INFO_RO.',
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
  p_id=>1926130934044825 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_SOURCE_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_details(:p11315_source, 1);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'width=100%',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
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
  p_id=>1926328649044826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_id=>2494606177426968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Source Type',
  p_source=>'SOURCE_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_f_source_type'||chr(10)||
'   where active = ''Y'''||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Source Type -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => '&P11315_SOURCE_INFO_RO.',
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
  p_id=>5081630958523107 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_SOURCE_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11315_SOURCE_RO',
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
  p_id=>5081807194525779 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_SOURCE_INFO_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11315_SOURCE_INFO_RO',
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
  p_id=>5084324265663115 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_name=>'P11315_WITTING_INFO_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 1924123711044818+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11315_WITTING_INFO_RO=',
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
  p_id=> 1926620168044826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11315,
  p_computation_sequence => 10,
  p_computation_item=> 'P11315_SID',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> ':P0_OBJ',
  p_compute_when => '',
  p_compute_when_type=>'%null%');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 1926824455044826 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11315,
  p_validation_name => 'P11315_SOURCE Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P11315_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Source must be specified.',
  p_validation_condition=> 'SAVE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 1924907383044823 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 13-NOV-2009 11:21');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 4955621807284592 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11315,
  p_validation_name => 'Don''t change type on certain status',
  p_validation_sequence=> 5,
  p_validation => 'begin'||chr(10)||
'    for x in (select a.code as priv,'||chr(10)||
'                     st.disallow_status_change as disallow,'||chr(10)||
'                     st.description as type'||chr(10)||
'                from t_osi_f_source_type st,'||chr(10)||
'                     t_osi_auth_priv p,'||chr(10)||
'                     t_osi_auth_action_type a'||chr(10)||
'               where st.sid = :p11315_type'||chr(10)||
'                 and st.privilege = p.sid'||chr(10)||
'                 and p.action = a.sid)'||chr(10)||
'    loop'||chr(10)||
'        if(osi_auth.check_for_priv(x.priv, :p0_obj_type_sid) = ''Y'')then'||chr(10)||
'            for y in (select s.code'||chr(10)||
'                        from t_osi_status_history sh,'||chr(10)||
'                             t_osi_status s'||chr(10)||
'                       where sh.obj = :p0_obj'||chr(10)||
'                         and sh.is_current = ''Y'''||chr(10)||
'                         and sh.status = s.sid)'||chr(10)||
'            loop'||chr(10)||
'                if(y.code like ''%'' || x.disallow || ''%'')then'||chr(10)||
'                    return ''Source Type cannot be changed when the status is '' || y.code || ''.'';'||chr(10)||
'                else'||chr(10)||
'                    return null;'||chr(10)||
'                end if;'||chr(10)||
'            end loop;'||chr(10)||
'        else'||chr(10)||
'            return ''You do not have the proper privileges to change the Source Type to '' || x.type || ''.'';'||chr(10)||
'        end if;'||chr(10)||
'    end loop;'||chr(10)||
'    '||chr(10)||
'    return null;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => '',
  p_validation_condition=> 'SAVE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
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
p:=p||'#OWNER#:T_OSI_F_SOURCE:P11315_SID:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 1927126797044828 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11315,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Do T_OSI_F_SOURCE',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE',
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
p:=p||'11315';

wwv_flow_api.create_page_process(
  p_id     => 1927302659044828 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11315,
  p_process_sequence=> 99,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_PAGES',
  p_process_name=> 'Clear items',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CANCEL',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'F|#OWNER#:T_OSI_F_SOURCE:P11315_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 1926931024044828 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11315,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Get T_OSI_F_SOURCE',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11315_SID',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
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
'    l_status       t_osi_status.code%type;'||chr(10)||
'    l_maint_priv   varchar2(1);'||chr(10)||
'begin'||chr(10)||
'    l_status := osi_object.get_status_code(:p11315_sid);'||chr(10)||
'    l_maint_priv :='||chr(10)||
'                   osi_auth.check_for_priv(''SOURCE_CHANGE'', core_obj.lookup_objtype(''FILE.SOURCE''));'||chr(10)||
''||chr(10)||
'    if (   l_status = ''PO'''||chr(10)||
'        or l_maint_priv = ''Y'') then'||chr(10)||
'        :p11315_source_info_ro := null;'||chr(10)||
'        :p11315_witting_info_';

p:=p||'ro := null;'||chr(10)||
'    else'||chr(10)||
'        :p11315_source_info_ro := :disable_select;'||chr(10)||
'        :p11315_witting_info_ro := :disable_radio;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (l_status = ''PO'') then'||chr(10)||
'        :p11315_source_ro := null;'||chr(10)||
'    else'||chr(10)||
'        :p11315_source_ro := :disable_text;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5084919894671331 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11315,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set read-only fields',
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
-- ...updatable report columns for page 11315
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
--   Date and Time:   07:15 Wednesday April 20, 2011
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

PROMPT ...Remove page 11330
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11330);
 
end;
/

 
--application/pages/page_11330
prompt  ...PAGE 11330: Source Approval Search
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 11330,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Source Approval Search',
  p_step_title=> 'Source Approval Search',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_welcome_text=> '<script type="text/javascript">'||chr(10)||
'<!--'||chr(10)||
'if (''&P11330_REFRESH_PARENT_WINDOW.'' == ''Y'')'||chr(10)||
'   window.opener.doSubmit();'||chr(10)||
'//-->'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110420071532',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '20-Apr-2011 - Tim Ward - CR#3784 - Added Item P11330_REFRESH_PARENT_WINDOW '||chr(10)||
'                                   and javascript to the Header text to'||chr(10)||
'                                   refresh the calling page so the Title'||chr(10)||
'                                   and Attachment Screens will update on'||chr(10)||
'                                   Report Import.');
 
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
  p_id=> 17870211160814709 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11330,
  p_plug_name=> 'Source Search - On Approval',
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
  p_plug_display_when_condition => ':P11330_SHOW_NO_ACTION = ''N''',
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
  p_id=> 17878604907011676 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11330,
  p_plug_name=> 'No Action Available',
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
  p_plug_display_when_condition => ':P11330_SHOW_NO_ACTION = ''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 17871322981846550 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11330,
  p_button_sequence=> 10,
  p_button_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17880508978031710 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11330,
  p_button_sequence=> 20,
  p_button_plug_id => 17878604907011676+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17925530794806135 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11330,
  p_button_sequence=> 30,
  p_button_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_button_name    => 'IMPORT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Import',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P11330_ATTACHED_REPORT_SID is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17933400675223287 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11330,
  p_button_sequence=> 40,
  p_button_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_button_name    => 'VIEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'View',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:250:&SESSION.:&P11330_ATTACHED_REPORT_SID.:&DEBUG.:::',
  p_button_condition=> ':P11330_ATTACHED_REPORT_SID is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>17925805645808318 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_branch_action=> 'f?p=&APP_ID.:11330:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 27-OCT-2010 09:16 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5358904715395185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_REFRESH_PARENT_WINDOW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Refresh Parent Window',
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
  p_id=>17870517739816651 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11330_OBJ',
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
  p_id=>17872820472864753 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_PARTIC_FROM_LEGACY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11330_PARTIC_FROM_LEGACY',
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
  p_id=>17879415296014667 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_SOURCE_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11330_SOURCE_STATUS',
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
  p_id=>17880821099035206 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_REASON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 17878604907011676+wwv_flow_api.g_id_offset,
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
  p_id=>17881917206053089 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_SHOW_NO_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11330_SHOW_NO_ACTION',
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
  p_id=>17918308650601071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_IS_SOURCE_IN_LEGACY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11330_SOURCE_IN_LEGACY',
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
  p_id=>17925415211801682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
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
  p_id=>17926428249871657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_ATTACHED_REPORT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11330_ATTACHED_REPORT_SID',
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
  p_id=>17934711373273690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11330,
  p_name=>'P11330_ALREADY_IMPORTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 17870211160814709+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11330_ALREADY_IMPORTED',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    :p11330_attached_report_sid := osi_source.import_legacy_report(:P11330_OBJ);'||chr(10)||
'    :P11330_REFRESH_PARENT_WINDOW := ''Y'';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 17926614527877165 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11330,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Import and Attach Report',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST = ''IMPORT''',
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
p:=p||'declare '||chr(10)||
'     v_temp varchar2(4000);'||chr(10)||
'begin'||chr(10)||
'    --See if participant had been imported from Legacy'||chr(10)||
'    :p11330_partic_from_legacy := osi_source.src_partic_is_from_legacy(:p11330_obj);'||chr(10)||
''||chr(10)||
'    --If the participant had been imported, lets get further information'||chr(10)||
'    if (:p11330_partic_from_legacy = ''Y'') then'||chr(10)||
'        --If they have been imported, see if there is a Dup Source in Legacy'||chr(10)||
'        :p11330_is_';

p:=p||'source_in_legacy := osi_source.dup_source_exists_in_legacy(:p11330_obj);'||chr(10)||
''||chr(10)||
'        --See if the Source has been Imported already'||chr(10)||
'        :p11330_already_imported := ''N'';'||chr(10)||
'        for k in'||chr(10)||
'            (select sid'||chr(10)||
'               from t_osi_attachment'||chr(10)||
'              where obj = :p11330_obj'||chr(10)||
'                and type ='||chr(10)||
'                        osi_attachment.get_attachment_type_sid'||chr(10)||
'                         ';

p:=p||'                                   (core_obj.lookup_objtype(''FILE.SOURCE''),'||chr(10)||
'                                                             ''LEG_IMP'','||chr(10)||
'                                                             ''ATTACHMENT''))'||chr(10)||
'        loop'||chr(10)||
'            :P11330_ATTACHED_REPORT_SID := k.sid;'||chr(10)||
'            :p11330_already_imported := ''Y'';'||chr(10)||
'            exit;'||chr(10)||
'        end loop;'||chr(10)||
'    else'||chr(10)||
'        :p11330_is_sour';

p:=p||'ce_in_legacy := ''N'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Get the current status of the Source'||chr(10)||
'    :p11330_source_status := osi_object.get_status_code(:p11330_obj);'||chr(10)||
'    --Default "NO Action" to No..'||chr(10)||
'    :p11330_show_no_action := ''N'';'||chr(10)||
''||chr(10)||
'    --Display No Action Message (When Nessecary)'||chr(10)||
'    if (:p11330_source_status <> ''AA'') then'||chr(10)||
'        :p11330_reason :='||chr(10)||
'               ''You can only search for an existing source while';

p:=p||' in the "Awaiting Approval" state.'';'||chr(10)||
'        :p11330_show_no_action := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        --See if there is a source in Legacy'||chr(10)||
'        if (:p11330_is_source_in_legacy <> ''Y'') then'||chr(10)||
'            :p11330_reason := ''There is no Source Data in Legacy I2MS to Import.'';'||chr(10)||
'            :p11330_show_no_action := ''Y'';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        --See if there is a source in Web'||chr(10)||
'        v_temp := osi_source.alr';

p:=p||'eady_exists(:P11330_OBJ);'||chr(10)||
'        if (v_temp is not null) then'||chr(10)||
'            :p11330_reason := ''You cannot search Legacy I2MS for Source data due to the following reason: <br>'' || v_temp;'||chr(10)||
'            :p11330_show_no_action := ''Y'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Display Standard Message (When Nessecary)'||chr(10)||
'    if (:p11330_attached_report_sid is null) then'||chr(10)||
'        :p11330_message :='||chr(10)||
'            ''Lega';

p:=p||'cy I2MS Source information is available, click the Import button to attach and view a report.'';'||chr(10)||
'    else'||chr(10)||
'        :p11330_message :='||chr(10)||
'            ''Legacy I2MS Source information has been imported and attached to this source.  Click the View button to see the report.'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 17876815942986410 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11330,
  p_process_sequence=> 10,
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
 
---------------------------------------
-- ...updatable report columns for page 11330
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

