CREATE OR REPLACE PACKAGE BODY "OSI_AAPP_FILE" as
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
 *  Agent Application (110) File - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_AAPP_FILE
   PURPOSE:    Supports the Agent Application (110) in WebI2MS.

   REVISIONS:
   Date        Author           Description
   ----------  ---------------  ------------------------------------
   11/10/2009  Richard Dibble   Created this package.
   02/05/2010  Tim McGuffin     Added Check_Writability.
   02/09/2010  Richard Dibble   Added update_recall_note
   03/02/2010  Richard Dibble   Added generate_roi   
   03/10/2010  Richard Dibble   Added rpt_generate_add_info_sections 
                                 Added rpt_generate_generic_act_sect 
                                 Added rpt_get_maiden_names 
                                 Added rpt_get_aka_names 
                                 Added rpt_get_aapp_file_subject 
                                 Added rpt_get_basic_info 
                                 Added rpt_get_aapp_person_roi_block
   08/18/2010  Tim Ward         CR#0299 Changed rpt_generate_add_info_sections 
                                 to accept null for p_replace_tag so they can 
                                 return just the rtf and not the whole report.
                                 Changed rpt_generate_generic_act_sect to include
                                 Education in the Case Statement.
   23-Mar-2011 Tim Ward         CR#3766 - Changed rpt_generate_generic_act_sect to increase
                                 v_temp2 from varchar2(8000) to clob.
                                 
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_AAPP_FILE';
    
    --REPORTING VARIABLES[BEGIN]
    v_ok1           varchar2(2000);
    v_ok2           varchar2(2000);
    v_report        clob                                    := null;
    v_chr_cnt       number                                  := 1;
    v_newline       varchar2(10)                            := '\par ';
    c_block_half_inch    varchar2(250)
        := '}\pard\plain \ql \li0\ri0\widctlpar\tx360\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
    --REPORTING VARIABLES[END]

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

    procedure load_standard_objectives(p_obj in varchar2) is
    begin
        for k in (select *
                    from t_osi_f_aapp_file_obj_type
                   where sid not in(select obj_type
                                      from t_osi_f_aapp_file_obj
                                     where obj = p_obj) and active = 'Y')
        loop
            insert into t_osi_f_aapp_file_obj
                        (obj, obj_type)
                 values (p_obj, k.sid);
        end loop;
    exception
        when others then
            log_error('osi_aapp_file.load_standard_objectives: ' || sqlerrm);
    end load_standard_objectives;
    
    function get_objective_type_code(p_objective_type_sid in varchar2) return varchar2 is
    v_return t_osi_f_aapp_file_obj_type.code%type;
    begin
        select code into v_return from t_osi_f_aapp_file_obj_type where SID = p_objective_type_sid;
        
        return v_return;
        exception
        when others then
            log_error('osi_aapp_file.get_objective_type_code: ' || sqlerrm);
    end get_objective_type_code;

    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_subject       in   varchar2)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
            v_partic_role   t_osi_partic_role_type.sid%type;
    begin
        -- Common file creation,
        -- handles t_core_obj, t_osi_file, starting status, lead assignment, unit owner
        v_sid := osi_file.create_instance(p_obj_type, p_title, p_restriction);

        insert into t_osi_f_aapp_file
                    (sid, synopsis, background)
             values (v_sid,
                     'This investigation was initiated to determine SUBJECT''s eligibility for...',
                     'This box is not used for ROI generation.');
             
                 select sid
      into v_partic_role
      from t_osi_partic_role_type
     where obj_type member of osi_object.get_objtypes(v_sid) and usage = 'SUBJECT';
     
insert into t_osi_partic_involvement i
                        (obj, participant_version, involvement_role)
                 values (v_sid, OSI_PARTICIPANT.GET_CURRENT_VERSION(p_subject), v_partic_role);
                 
        load_standard_objectives(v_sid);
        return v_sid;
    exception
        when others then
            log_error('osi_aapp_file.create_instance: ' || sqlerrm);
    end create_instance;

    procedure update_aapp_types(p_obj in varchar2, p_type_type in varchar2, p_types in varchar2) is
        v_list    varchar2(200);
        v_count   number;
    begin
        v_list := core_list.convert_to_list(p_types, ':');
        v_count := core_list.count_list_elements(v_list);

        delete from t_osi_f_aapp_file_types
              where obj = p_obj and aapp_type_type = p_type_type;

        if (v_count > 0) then
            for k in 1 .. v_count
            loop
                insert into t_osi_f_aapp_file_types
                            (obj, aapp_type_type, aapp_type)
                     values (p_obj, p_type_type, core_list.get_list_element(v_list, k));
            end loop;
        end if;
    exception
        when others then
            log_error('osi_aapp_file.update_aapp_types: ' || sqlerrm);
    end update_aapp_types;

    /* Given an object SID, return whether or not the file is for an Agent or Support */
    function is_agent_file(p_obj in varchar2)
        return varchar2 is
    begin
        for k in (select category
                    from t_osi_f_aapp_file
                   where sid = p_obj)
        loop
            --Have side, not need description
            for j in (select description
                        from t_osi_reference
                       where sid = k.category and upper(description) like '%AGENT%')
            loop
                return 'Y';
            end loop;
        end loop;

        return 'N';
    exception
        when others then
            log_error('osi_aapp_file.is_agent_file: ' || sqlerrm);
    end is_agent_file;

    /* Given a category type, return Y/N whether or not this is an agent type */
    function is_agent_type(p_category in varchar2)
        return varchar2 is
    begin
        for k in (select description
                    from t_osi_reference
                   where sid = p_category and upper(description) like '%AGENT%')
        loop
            return 'Y';
        end loop;

        return 'N';
    exception
        when others then
            log_error('osi_aapp_file.is_agent_type: ' || sqlerrm);
    end is_agent_type;

    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_obj_type   t_core_obj_type.sid%type;
    begin
        v_obj_type := core_obj.get_objtype(p_obj);
        
       case osi_object.get_status_code(p_obj)
            when 'CL' then
                return 'N';
            when 'STA' then
                return 'N';
            when 'RAA' then
                return 'N';
            when 'ARCH' then
                return 'N';
            else
                return 'Y';
        end case;
    exception
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

    /* Updates a note when the Recall lifecycle change has been used */
   procedure update_recall_note(p_note_sid in varchar2) is
        v_last_state    t_osi_status_history%rowtype;
        v_status_desc   t_osi_status.description%type;
        v_obj           t_osi_note.obj%type;
        v_temp          varchar2(500);
        v_crlf          varchar2(200)                   := chr(13);
    begin
        --Get Obj
        select obj
          into v_obj
          from t_osi_note
         where sid = p_note_sid;

        --Get last state (Current State)
        select os.description
          into v_status_desc
          from t_osi_status os, t_osi_status_history osh
         where osh.status = os.sid and osh.obj = v_obj and osh.is_current = 'Y';

        --Create note append text
        v_temp := 'Recalled to ' || v_status_desc || v_crlf || '-----------------------' || v_crlf;
        
        --Update note
        osi_note.update_note(p_note_sid, v_temp);
    exception
        when others then
            log_error('osi_aapp_file.update_recall_note: ' || sqlerrm);
            raise;
    end update_recall_note;
    
function rpt_generate_add_info_sections(
        p_parent_sid    in   varchar2,
        p_objective     in   varchar2,
        p_replace_tag   in   varchar2 := Null)
        return varchar2 is
        v_obj_sid     varchar2(40) := null;
        v_cnt         number;
        v_from_date   date;
        v_to_date     date;
    begin
        --Get Objective SID
        select objective_sid
          into v_obj_sid
          from v_osi_f_aapp_file_obj
         where objective_type_code = p_objective and obj_sid = p_parent_sid;

        --Get # of References
        select count(sid)
          into v_cnt
          from t_osi_f_aapp_file_obj_act
         where objective = v_obj_sid;

        --Get First Date
        select min(activity_date_from)
          into v_from_date
          from v_osi_f_aapp_file_obj_act
         where objective_sid = v_obj_sid;

        --Get Last Date
        select max(activity_date_to)
          into v_to_date
          from v_osi_f_aapp_file_obj_act
         where objective_sid = v_obj_sid;
        
        if p_replace_tag is null then

          v_ok1 := to_char(v_cnt) || ' References - Covering '
                                  || to_char(v_from_date, v_date_format) || ' to '
                                  || to_char(v_to_date, v_date_format);

        else

          v_ok1 :=
              core_template.replace_tag(v_report,
                                        p_replace_tag,
                                        to_char(v_cnt) || ' References - Covering '
                                        || to_char(v_from_date, v_date_format) || ' to '
                                        || to_char(v_to_date, v_date_format)
                                                                            --,'RTF')
                                       );
        end if;
        
        return v_ok1;
    exception
        when others then
            --If this errors out, lets at least get rid of the token so as not to confuse anyone.
            v_ok1 := core_template.replace_tag(v_report, p_replace_tag, sqlerrm);
            log_error('--- osi_aapp_file.rpt_generate_add_info_sections ERROR---' || sqlerrm);
            return '--- osi_aapp_file.rpt_generate_add_info_sections ERROR---' || sqlerrm;
    end rpt_generate_add_info_sections;

    function rpt_generate_generic_act_sect(
        p_obj                   in   varchar2,
        p_objective_type_code   in   varchar2,
        p_replace_tag           in   varchar2 := Null)
        return varchar2 is
        v_temp    clob           := null;
        v_temp2   clob           := ''; --varchar2(8000);
        v_temp3   clob           := null;
    begin
        v_temp2 := '';                                                               --Clear the buffer
        v_chr_cnt := 1;                                                        --Reset Lettering Holder

        --Loop through objectives
        for k in (select objective_sid
                    from v_osi_f_aapp_file_obj
                   where obj_sid = p_obj and objective_type_code = p_objective_type_code)
        loop
            --Loop through activities
            for j in (select   *
                          from v_osi_f_aapp_file_obj_act
                         where objective_sid = k.objective_sid
                      order by activity_date_from asc)
            loop
                for l in (select *
                            from v_osi_a_aapp_activity
                           where sid = j.activity_sid)
                loop
                    --Set Letter
                    v_temp := chr(64 + v_chr_cnt) || '.   ';
                    --Increment Letter Counter
                    v_chr_cnt := v_chr_cnt + 1;

                    case osi_object.get_objtype_code(core_obj.get_objtype(l.sid))
                        when 'ACT.AAPP.DOCUMENT_REVIEW' then                          --Document Review
                            v_temp := v_temp || l.activity_narrative;
                        when 'ACT.AAPP.INTERVIEW' then                                       --Interview
                            --Line 1
                            --Was this person a relative?
                            if (l.int_relative = 'Y') then
                                v_temp3 := ' (RELATIVE)';
                            else
                                v_temp3 := '';
                            end if;

                            v_temp :=
                                v_temp || 'Interview of: ' || l.int_of || ', ' || l.int_org || ', '
                                || l.address_2 || v_temp3 || v_newline;

                            --Line 2
                            --Was this a telephonic interview?
                            if (l.int_type_desc = 'PHONE') then
                                v_temp3 := v_temp3 || ' - TELEPHONIC';
                            else
                                v_temp3 := '';
                            end if;

                            v_temp :=
                                v_temp || 'Date/Place: ' || to_char(l.activity_date, v_date_format)
                                || '/' || l.address_1 || v_temp3 || v_newline;
                            --Line 3
                            v_temp :=
                                     v_temp || 'Interviewer: SA ' || l.int_interviewer_name || v_newline;

                            --Line 4
                            if (l.int_asst_interviewer_name is not null) then
                                v_temp :=
                                    v_temp || 'Asst Interviewer: SA ' || l.int_asst_interviewer_name
                                    || v_newline;
                            end if;

                            --Line 5
                            v_temp :=
                                v_temp
                                || 'Associated Exhibit: XXX [insert exhibit number if necessary, else remove line]'
                                || v_newline;
                            --Extra Spaces and narrative
                            v_temp := v_temp || v_newline || l.activity_narrative;
                        when 'ACT.AAPP.RECORDS_CHECK' then                               --Records Check
                            v_temp := v_temp || l.activity_narrative;
                        when 'ACT.AAPP.EDUCATION' then
                            v_temp :=
                                v_temp || 'SUBJECT attended ' || l.deg_school || ', ' || l.address_1
                                || ', from ' || to_char(l.date_from, v_date_format) || ' to ';
                             --if (L.DATE_TO is null) then
                                 --V_TEMP := V_TEMP || 'PRESENT';
                            -- else
                            --This ^^^^^ was commented out in the Legacy I2MS code.
                            v_temp := v_temp || to_char(l.date_to, v_date_format);

                            --end if;
                            if (l.deg_grad_date is not null) then
                                v_temp :=
                                    v_temp || ' and graduated with a ' || l.deg_degree || ' on '
                                    || to_char(l.deg_grad_date, v_date_format);
                            end if;

                    end case;

                    --Add trailing line feed(s)
                    v_temp := v_temp || v_newline || v_newline || v_newline;
                    --Concatonate to the buffer
                    v_temp2 := v_temp2 || v_temp;
                end loop;
            end loop;
        end loop;

        if (   v_temp2 is null
            or length(v_temp2) <= 0) then
            --Here we will default parts of the ROI that have no information.
            case p_objective_type_code
                when 50 then
                    v_temp2 :=
                        '>>>SUBJECT was not unemployed during the time frame of this investigation.<<<';
                when 100 then
                    v_temp2 :=
                        '>>>SUBJECT has never filed for bankruptcy, nor were any records found indicating SUBJECT had done so.<<<';
                when 110 then
                    v_temp2 := '>>>SUBJECT has never been married.<<<';
                when 120 then
                    v_temp2 := '>>>SUBJECT has never been divorced or SUBJECTs spouse is deceased.<<<';
                when 140 then
                    v_temp2 :=
                        '>>>SUBJECT stated he/she has never been taken to Criminal Court, nor were any records found indicating he/she had been a participant in a criminal court proceeding.<<<';
                when 150 then
                    v_temp2 :=
                        '>>>SUBJECT stated he/she has never been taken to Civil Court, nor were any records found indicating he/she had been a participant in a criminal court proceeding.<<<';
                else
                    --do nothing
                    v_temp2 := v_temp2;
            end case;
        end if;
        
        if p_replace_tag is null then
        
          v_ok1 := v_temp2;
        
        else
        
          v_ok1 := core_template.replace_tag(v_report, p_replace_tag, v_temp2);
        
        end if;
        
        return v_ok1;
    exception
        when others then
            log_error('--- osi_aapp_file.rpt_generate_generic_act_sect ERROR---' || sqlerrm);
            v_ok1 :=
                core_template.replace_tag
                                         (v_report,
                                          p_replace_tag,
                                          '--- osi_aapp_file.rpt_generate_generic_act_sect ERROR---'
                                          || sqlerrm);
            return '--- osi_aapp_file.rpt_generate_generic_act_sect ERROR---' || sqlerrm;
    end rpt_generate_generic_act_sect;

    function rpt_get_maiden_names(p_person_version in varchar2)
        return varchar2 is
        v_return   varchar2(2000);
    begin
        --Get participant
        for k in (select participant
                    from t_osi_participant_version
                   where sid = p_person_version)
        loop
            --Get participant versions
            for l in (select sid
                        from t_osi_participant_version
                       where participant = k.participant)
            loop
                --Get a/the past mainden name(s) for this person version.
                for m in (select rtrim(ltrim(first_name
                                             || decode(middle_name, null, '', ' ' || middle_name)
                                             || decode(last_name, null, '', ' ' || last_name)))
                                                                                         --|| ' '
                                 as whole_name
                            from t_osi_partic_name
                           where name_type = (select sid
                                                from t_osi_partic_name_type
                                               where code = 'M')
                             and participant_version = l.sid)
                loop
                    v_return := v_return || m.whole_name;
                end loop;
            end loop;
        end loop;

        return v_return;
    exception
        when others then
            log_error('--- osi_aapp_file.rpt_get_maiden_names ERROR---' || sqlerrm);
            return '--- osi_aapp_file.rpt_get_maiden_names ERROR---' || sqlerrm;
    end rpt_get_maiden_names;

    function rpt_get_aka_names(p_person_version in varchar2)
        return varchar2 is
        v_return   varchar2(2000);
    begin
        --Get participant
        for k in (select participant
                    from t_osi_participant_version
                   where sid = p_person_version)
        loop
            --Get participant versions
            for l in (select sid
                        from t_osi_participant_version
                       where participant = k.participant)
            loop
                --Get a/the past AKA name(s) for this person version.
                for m in (select rtrim(ltrim(first_name
                                             || decode(middle_name, null, '', ' ' || middle_name)
                                             || decode(last_name, null, '', ' ' || last_name)))
                                                                                         --|| ' '
                                 as whole_name
                            from t_osi_partic_name
                           where name_type = (select sid
                                                from t_osi_partic_name_type
                                               where code = 'AKA')
                             and participant_version = l.sid)
                loop
                    v_return := v_return || m.whole_name;
                end loop;
            end loop;
        end loop;

        return v_return;
    exception
        when others then
            log_error('--- osi_aapp_file.rpt_get_aka_names ERROR---' || sqlerrm);
            return '--- osi_aapp_file.rpt_get_aka_names ERROR---' || sqlerrm;
    end rpt_get_aka_names;

    function rpt_get_aapp_file_subject(p_obj in varchar2)
        return varchar2 is
    begin
        for k in (select participant_version
                    from t_osi_partic_involvement
                   where obj = p_obj)
        loop
            return k.participant_version;
        end loop;

        return null;
    exception
        when others then
            log_error('--- osi_aapp_file.rpt_get_aapp_file_subject ERROR---' || sqlerrm);
            return '--- osi_aapp_file.rpt_get_aapp_file_subject ERROR---' || sqlerrm;
    end rpt_get_aapp_file_subject;

    function rpt_get_basic_info(p_person_version in varchar2, p_saa out varchar2, p_per out varchar2)
        return varchar2 is
        v_return   varchar2(4000);
        v_temp     varchar2(2000);
        v_sex      varchar2(100);
        v_dob      date;
        v_pob      varchar2(100);
        v_pp       varchar2(100);
        v_pg       varchar2(100);
        v_ppg      varchar2(100);
        v_saa      varchar2(100);
        v_per      varchar2(20);
        v_pt       varchar2(100);
        v_tempx    varchar2(2000);
    begin
        v_return := '';
        -- Get Names
        v_return := v_return || nvl(osi_participant.get_name(p_person_version), 'UNKNOWN') || ', ';
        v_temp := rpt_get_maiden_names(p_person_version);

        if (v_temp is not null) then
            v_return := v_return || 'NEE: ' || v_temp || ', ';
        end if;

        v_temp := rpt_get_aka_names(p_person_version);

        if (v_temp is not null) then
            v_return := v_return || 'AKA: ' || v_temp || ', ';
        end if;

        --Get Sex
        for k in (select sex_desc
                    from v_osi_person_chars
                   where sid = p_person_version)
        loop
            v_sex := k.sex_desc;
        end loop;

        --Get DOB
        for k in (select dob
                    from t_osi_participant
                   where current_version = p_person_version)
        loop
            v_dob := k.dob;
        end loop;

        --Birth State or Country
        for k in (select state_code, country_desc
                    from v_osi_partic_address
                   where participant_version = p_person_version and type_code = 'BIRTH')
        loop
            v_pob := nvl(k.state_code, k.country_desc);
        end loop;

        --Pay Plan / Pay Grade
        for k in (select decode(sa_pay_plan_code,
                                'GS', 'GS',
                                'ES', 'ES',
                                null, '',
                                substr(sa_pay_plan_code, 1, 1)) as "PP_CODE",
                         sa_pay_grade_code
                    from v_osi_person_chars
                   where sid = p_person_version)
        loop
            v_pp := k.pp_code;
            v_pg := ltrim(k.sa_pay_grade_code, '0');
        end loop;

        --Service Affiliation
        v_tempx := '';

        for k in (select osir.description
                    from t_osi_participant_human oph, t_osi_reference osir
                   where osir.sid = oph.sa_affiliation)
        loop
            v_tempx := k.description;
            exit;
        end loop;

        v_saa := nvl(v_tempx, 'none');
        --Person
        v_per := osi_participant.get_participant(p_person_version);
        --Person Type
        v_pt :=
            osi_object.get_objtype_code
                                (core_obj.get_objtype(osi_participant.get_participant(p_person_version)));

        if (v_pt = 'PART.INDIV') then
            if (v_sex is not null) then
                v_return := v_return || v_sex || ' ';
            end if;

            v_return := v_return || 'Born: ';
            v_return := v_return || nvl(to_char(v_dob, 'DD MON YY'), 'Unknown') || ', ';
            v_return := v_return || nvl(v_pob, 'Unknown') || ', ';
            -- If Civilian, put in "CIV" keyword, else Paygrade
            v_ppg := v_pp || '-' || v_pg;

            if v_ppg = '-' then
                v_ppg := 'CIV';
            end if;

            v_return := v_return || v_ppg || ', ';
            --Identifying Numbers (SSN first, then ISN if none exists)
            v_tempx := '';

            for k in (select   num_value
                          from t_osi_partic_number opn, t_osi_partic_number_type opnt
                         where opn.num_type = opnt.sid
                           and (   opnt.code = 'SSN'
                                or opnt.code = 'ISN')
                           and participant_version = p_person_version
                           and (   expire_date > sysdate
                                or expire_date is null)
                      order by opnt.code desc, opn.issue_date desc, opn.create_on desc)
            loop
                v_tempx := k.num_value;
                exit;
            end loop;

            v_return := v_return || nvl(v_tempx, 'Unknown');
        else
            null;
        end if;

        p_saa := v_saa;
        p_per := v_per;
        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('--- osi_aapp_file.rpt_get_basic_info ERROR---' || sqlerrm);
            raise;
    end rpt_get_basic_info;

    function rpt_get_aapp_person_roi_block(p_person_version in varchar2)
        return varchar2 is
        v_return   varchar2(5000);
        v_temp     varchar2(2000);
        v_saa      varchar2(100);
        v_per      varchar2(20);
    begin
        v_return := v_return || rpt_get_basic_info(p_person_version, v_saa, v_per);
        -->Don't think any of the below code is used in AAPP
         /*
                    if v_saa = 'ME' then                                              -- military (or employee)
                        v_result := v_result || get_org_info(ppopv);
                    else                                                       -- civilian or military dependent
                        v_temp := null;

                        for r in (select   that_person, ltrim(rel_desc, 'is ') as rel_type
                                      from v_person_relation
                                     where this_person = v_per
                                       and rel_desc in('is Spouse of', 'is Child of')
                                       and (   end_date is null
                                            or end_date > sysdate)
                                  order by nvl(start_date, modify_on) desc)
                        loop
                            rpt_get_basic_info(r.that_person, v_temp, v_saa, v_per);
                            v_temp := r.rel_type || ' ' || v_temp;

                            if nvl(v_saa, 'none') <> 'ME' then                      -- not a military dependent
                                v_temp := null;
                                exit;
                            end if;

                            v_temp := v_temp || get_org_info(r.that_person);
                            exit;                                                           -- only need 1st row
                        end loop;

                        if v_temp is null then
                            v_temp := address(ppopv, 'CURRENT');
                        end if;

                        v_result := v_result || v_temp;
                    end if;
        */
        v_return := rtrim(v_return, ', ');
        return v_return;
    exception
        when others then
            log_error('--- osi_aapp_file.rpt_get_aapp_person_roi_block ERROR---' || sqlerrm);
            return '--- osi_aapp_file.rpt_get_aapp_person_roi_block ERROR---' || sqlerrm;
    end rpt_get_aapp_person_roi_block;

    function generate_roi(p_obj in varchar2)
        return clob is
        v_return_date   date;
        v_mime_type     t_core_template.mime_type%type;
        v_mime_disp     t_core_template.mime_disposition%type;
        v_temp          clob                                    := null;               --- Buffer 1 ---
        v_temp2         clob                                    := null;               --- Buffer 2 ---
        v_temp3         clob                                    := null;
        v_temp4         varchar2(2000);
        v_temp5         varchar2(2000);
        v_notes         clob;
        v_cnt           number                                  := 0;
        --v_idpheader     varchar2(1000);
        v_id            varchar2(1000);
    begin
        --Get latest template
        v_ok1 :=
            core_template.get_latest('AGENT_APPLICANT_ROI',
                                     v_report,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);
        --Get Full ID
        --v_id := 'FINISH ID CODE';
        v_ok1 :=
            core_template.replace_tag(v_report,
                                      'FULL_ID',
                                      osi_file.get_full_id(p_obj),
                                      p_multiple       => true);
        --Get Classification
        --This will need to be resolved via a Classification System in the future
        v_ok1 :=
            core_template.replace_tag(v_report,
                                      'CLASSIFICATION',
                                      osi_classification.get_report_class(p_obj),
                                      p_multiple       => true);

        --Report By
        for la in (select 'SA ' || first_name || ' '
                          || decode(middle_name,
                                    null, '(UNK) ',
                                    '', '(UNK) ',
                                    middle_name || ' ')
                          || last_name as lead_agent
                     from v_osi_personnel_gen_info
                    where sid in(select personnel
                                   from t_osi_assignment
                                  where obj = p_obj and assign_role in(select sid
                                                                         from t_osi_assignment_role_type
                                                                        where code = 'LEAD')))
        loop
            v_temp := la.lead_agent;
        end loop;

        v_ok1 := core_template.replace_tag(v_report, 'LEAD_AGENT', v_temp);

        --v_osi_f_aapp_file
        for k in (select *
                    from v_osi_f_aapp_file
                   where sid = p_obj)
        loop
            --Start Date
            v_ok1 :=
                core_template.replace_tag(v_report, 'START_DATE', to_char(k.start_date, v_date_format));
            --Date of Report
            v_ok1 := core_template.replace_tag(v_report, 'PRINTDATE', to_char(sysdate, v_date_format));

            --Matters Investigated
            case k.category_code
                when 'AGT' then                                                                -- Agent
                    v_temp5 := 'Investigative Duty';
                when 'RAGT' then                                                        -- Reserve Agent
                    v_temp5 := 'Investigative Duty';
                when 'SPT' then                                                               -- Support
                    v_temp5 := 'Support Duty';
                when 'RSPT' then                                                      -- Reserve Support
                    v_temp5 := 'Support Duty';
                else
                    v_temp5 := ' ';
            end case;

            v_ok1 := core_template.replace_tag(v_report, 'AGENT_OR_SUPP', v_temp5);

            --Need to hold onto this V_TEMP buffer for a minute so we can do the Background portion.

            --Background[BEGIN]
            begin
                v_temp4 := rpt_get_aapp_file_subject(p_obj);

                select sa_pay_plan_code
                  into v_temp2
                  from v_osi_person_chars
                 where sid = v_temp4;
            exception
                when others then
                    v_temp2 := null;
            end;

            v_temp3 :=
                'This investigation was initiated to determine SUBJECT''s '
                || 'eligibility and suitability for ' || v_temp5 || ' with AFOSI';

            if (v_temp5 = 'Investigative Duty') then
                case v_temp2
                    when 'EM' then                                               --PAY_PLAN of Enlisted
                        v_temp3 := v_temp3 || ' as an enlisted Special Agent';
                    when 'OM' then                                    --PAY_PLAN of Commissioned Officer
                        v_temp3 := v_temp3 || ' as an officer Special Agent';
                    when 'CM' then                                        --PAY_PLAN of Cadet/Midshipman
                        v_temp3 := v_temp3 || ' as an officer Special Agent';
                    when 'NSPS' then                    --PAY_PLAN of National Security Personnel System
                        v_temp3 := v_temp3 || ' as a civilian Special Agent';
                    else                                         --All other PAY_PLANS not listed above.
                        v_temp3 := v_temp3 || ' as a civilian Special Agent';
                end case;
            end if;

            v_temp3 := v_temp3 || '.';
            v_ok1 := core_template.replace_tag(v_report, 'BACKGROUND', v_temp3);
            --Background[END]

            --Subject
            v_ok1 :=
                core_template.replace_tag
                                        (v_report,
                                         'SUBJECT',
                                         rpt_get_aapp_person_roi_block(rpt_get_aapp_file_subject(p_obj)));
            --Status
            v_ok1 := core_template.replace_tag(v_report, 'STATUS', 'Closed');
            --Currently this will stay as "Closed." but I left this code in here in case this has to change later.
            --Synopsis
            v_ok1 := core_template.replace_tag(v_report, 'SYNOPSIS', k.synopsis);
        end loop;

        --Education[BEGIN]
        v_temp2 := '';                                                                --Clear the buffer
        v_chr_cnt := 1;                                                         --Reset Lettering Holder

        --Loop through objectives of type '10'
        for k in (select objective_sid
                    from v_osi_f_aapp_file_obj
                   where obj_sid = p_obj and objective_type_code = '10')
        loop
            --Loop through Activity List (tied to each objective.)
            for j in (select   activity_sid
                          from v_osi_f_aapp_file_obj_act
                         where objective_sid = k.objective_sid
                      order by activity_date_from asc)
            loop
                --Should only be one record in this loop.
                for l in (select *
                            from v_osi_a_aapp_activity
                           where sid = j.activity_sid)
                loop
                    --Set Letter
                    v_temp := chr(64 + v_chr_cnt) || '.   ';
                    --Increment Letter Counter
                    v_chr_cnt := v_chr_cnt + 1;
                    v_temp :=
                        v_temp || 'SUBJECT attended ' || l.deg_school || ', ' || l.address_1
                        || ', from ' || to_char(l.date_from, v_date_format) || ' to ';
                     --if (L.DATE_TO is null) then
                         --V_TEMP := V_TEMP || 'PRESENT';
                    -- else
                    --This ^^^^^ was commented out in the Legacy I2MS code.
                    v_temp := v_temp || to_char(l.date_to, v_date_format);

                    --end if;
                    if (l.deg_grad_date is not null) then
                        v_temp :=
                            v_temp || ' and graduated with a ' || l.deg_degree || ' on '
                            || to_char(l.deg_grad_date, v_date_format);
                    end if;

                    --Add trailing period and line feed(s)
                    v_temp := v_temp || '.' || v_newline || v_newline || v_newline;
                    --Concatonate to the buffer
                    v_temp2 := v_temp2 || v_temp;
                end loop;
            end loop;
        end loop;

        v_ok1 := core_template.replace_tag(v_report, 'EDUCATION', v_temp2);
        --Education[END]

        --Education References[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '20', 'EDUC_REF');
        v_ok1 := rpt_generate_add_info_sections(p_obj, '20', 'ADD_INFO32');
        --Education References[END]

        --Employment[BEGIN]
        v_temp2 := '';                                                                --Clear the buffer
        v_chr_cnt := 1;                                                         --Reset Lettering Holder

        --Loop through objectives of type '30'
        for k in (select objective_sid
                    from v_osi_f_aapp_file_obj
                   where obj_sid = p_obj and objective_type_code = '30')
        loop
            --Loop through Activity List (tied to each objective.)
            for j in (select   activity_sid
                          from v_osi_f_aapp_file_obj_act
                         where objective_sid = k.objective_sid
                      order by activity_date_from asc)
            loop
                --Should only be one record in this loop.
                for l in (select *
                            from v_osi_a_aapp_activity
                           where sid = j.activity_sid)
                loop
                    --Set Letter
                    v_temp := chr(64 + v_chr_cnt) || '.   ';
                    --Increment Letter Counter
                    v_chr_cnt := v_chr_cnt + 1;
                    v_temp :=
                        v_temp || 'SUBJECT was employed ' || l.emp_pos_type_desc || ' as a/an '
                        || l.emp_position || ' at ' || l.emp_employer || ', ' || l.address_1
                        || ', from ' || to_char(l.date_from, v_date_format) || ' to ';
                    v_temp := v_temp || to_char(l.date_to, v_date_format);
                    --Add trailing period and line feed(s)
                    v_temp := v_temp || '.' || v_newline || v_newline || v_newline;
                    --Concatonate to the buffer
                    v_temp2 := v_temp2 || v_temp;
                end loop;
            end loop;
        end loop;

        v_ok1 := core_template.replace_tag(v_report, 'EMPLOYMENT', v_temp2);
        --Employment[END]

        --Employment Reference[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '40', 'EMPLOYMENT_REF');
        v_ok1 := rpt_generate_add_info_sections(p_obj, '40', 'ADD_INFO34');
        --Employment Reference[END]

        --Unemployment[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '50', 'UNEMPLOY');
        --Unemployment[END]

        --Listed References[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '60', 'LIST_REF');
        v_ok1 := rpt_generate_add_info_sections(p_obj, '60', 'ADD_INFO36');
        --Listed References[END]

        --Developed References[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '70', 'DEV_REF');
        v_ok1 := rpt_generate_add_info_sections(p_obj, '70', 'ADD_INFO37');
        --Listed References[END]

        --Neighborhood Investigation[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '80', 'NEIGHBORHOOD');
        v_ok1 := rpt_generate_add_info_sections(p_obj, '80', 'ADD_INFO38');
        --Neighborhood Investigation[END]

        --Finance[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '90', 'FINANCE');
        --Finance[END]

        --Bankruptcy[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '100', 'BANKRUPT');
        --BankruptcyEND]

        --Spouse Interview[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '110', 'SPOUSE_INT');
        --Spouse Interview]

        --Former Spouse Interview[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '120', 'FORMER_SPOUSE');
        --Former Spouse Interview[END]

        --Divorce[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '130', 'DIVORCE');
        --Divorce[END]

        --Criminal Court[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '140', 'CRIMINAL');
        --Criminal Court[END]

        --Civil Court[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '150', 'CIVIL');
        --Civil Court[END]

        --Medical Records[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '160', 'MEDICAL');
        --Medical Records[END]

        --Medical Records[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '170', 'PERSONNEL');
        --Medical Records[END]

        --Local Agency Checks[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '180', 'LOCAL_CHECKS');
        --Local Agency Checks[END]

        --State Agency Checks[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '190', 'STATE_CHECKS');
        --State Agency Checks[END]

        --State Agency Checks[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '200', 'NATIONAL_CHECKS');
        --State Agency Checks[END]

        --Subject Interview[BEGIN]
        v_ok1 := rpt_generate_generic_act_sect(p_obj, '210', 'SUBJECT_INT');
        --Subject Interview[END]

        --- Get IDP Notes ---
        v_cnt := 0;

        for k in (select   ton.note_text
                      from t_osi_note ton, t_osi_note_type ont
                     where ont.sid = ton.note_type
                       and ont.code = 'IDP'
                       and (   ton.obj = p_obj
                            or ton.obj in(select activity_sid
                                            from t_osi_assoc_fle_act
                                           where file_sid = p_obj))
                  order by ton.create_on)
        loop
            v_cnt := v_cnt + 1;

            if (v_cnt = 1) then
                v_notes := v_notes || c_block_half_inch || v_cnt || '\tab ';
            else
                v_notes := v_notes || '\par\par ' || v_cnt || '\tab ';
            end if;

            v_notes := v_notes || k.note_text;
        end loop;

        v_ok1 := core_template.replace_tag(v_report, 'NOTES', v_notes);

        --- Get Lead Agent Name, Unit Name, and IDP Header ---
        for a in (select   'INTERNAL DATA PAGE, AFOSI ' || osi_unit.get_name(oa.unit)
                           || ', ' || nvl(v_id, '<NO DESCRIPTIVE FILE NUMBER>') || ', '
                           || to_char(sysdate, v_date_format) as idpheader
                      from t_osi_assignment oa, t_osi_assignment_role_type oart
                     where oa.assign_role = oart.sid
                       and oart.code = 'LEAD'
                       and oa.end_date is null
                       and oa.obj = p_obj
                  order by oa.start_date)
        loop
            --Should only be 1 lead.
            v_temp4 := a.idpheader;
        end loop;

        v_ok1 := core_template.replace_tag(v_report, 'IDPHEADER', v_temp4);
        return v_report;
    exception
        when others then
            log_error('osi_aapp_file.generate_roi: ' || sqlerrm);
            raise;
    end generate_roi;
end osi_aapp_file;
/
