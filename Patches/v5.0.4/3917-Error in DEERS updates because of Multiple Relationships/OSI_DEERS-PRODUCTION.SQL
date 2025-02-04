CREATE OR REPLACE package body osi_deers is
/******************************************************************************
   name:     osi_deers
   purpose:  Handles interfacing with DMDC DEERS system.

   revisions:
    date         author          description
    ----------   --------------  ------------------------------------
    16-Mar-2010  T.Whitehead     Copied from I2MS, modified to work,
                                 added is_searchable_number, get_import_message.
                                 NOTE: is_valid has code commented out until notifications
                                       are implemented.
    11-Jan-2011  Tim Ward        Changed v_pipe to c_pipe and got rid of v_pipe so we are only
                                  writing to one pipe instead of two.
    11-Jan-2011  Tim Ward        Fixing issues in update_person_with_deers and
                                  delte_update_field.
                                  Address was not comparing correctly.
    17-Jan-2011  Tim Ward        Changed process_unit_relationship because even if you cancelled
                                  a DEERS check it would create a duplicate Relationship record.
    17-Jan-2011  Tim Ward        Added DEERS_COMPARE to do Deers check now instead of doing it
                                  in page 30140.
    17-Jan-2011  Tim Ward        Birth State was actually being retrieved from Mail Address State.
                                  Changed process_address_information.
    17-Jan-2011  Tim Ward        Changed delete_update_field to use field names from T_OSI_DEERS_COMPARE_COLUMNS
                                  or V_OSI_DEERS_COMPARE.
    17-Jan-2011  Tim Ward        Changed return message in update_peson_with_deers incase just the photo was updated, 
                                  there is not a new participant version created ('No new Version.').  The UpdateDeers
                                  will look for this message and show 'Selected WebI2MS Data Updated.  The participant window will be reloaded.'.
    18-Jan-2011  Tim Ward        Changed the --- Update Photo --- or update_person_with_deers to look for SOURCE='DEERS' instead 
                                  of OBJ_CONTEXT='...' since I found at least one instance in Beta where OBJ_CONTEXT was empty. 
    18-Jan-2011  Tim Ward        Added Exception blocks around all selects in delete_update_field.  Not having this was
                                  causing fields to update if the select failed to return rows.
    09-Mar-2011  Tim Ward        CR#3743 - DEERS Update is broken on Locally Sync'ed Participants.  Need to 
                                  insert a record into t_osi_person_chars.
                                  Changed update_person_with_deers.
                                  
******************************************************************************/

    --- Variables ---
    c_pipe              varchar2(100)     := core_util.get_config('CORE.PIPE_PREFIX')
                                             || 'OSI_DEERS';
    v_xml               clob;
    v_dod_edi_pn_id     varchar2(10);
    v_person_sid        varchar2(20);
    v_pv_sid            varchar2(20);
    v_import_sid        varchar2(20);
    v_import_message    varchar2(1000);
    v_note              clob;
    v_txt               varchar2(100);
    v_ssn               varchar2(50);
    v_generic_creator   varchar2(100)              := 'DEERS';
    v_tmp_note          varchar2(10000)            := null;
    v_obj_type          t_core_obj_type.sid%type   := core_obj.lookup_objtype('PART.INDIV');

    /*
     * Private functions.
     */
    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function add_name_to_message(p_msg in varchar2, p_name in varchar2)
        return varchar2 is
        l_rtn   varchar2(4000) := null;
        l_pos   number;
    begin
        l_rtn := p_msg;
        l_pos := instr(l_rtn, p_name);

        if    l_pos is null
           or l_pos < 1 then
            if l_rtn is null then
                l_rtn := p_name;
            else
                l_rtn := l_rtn || chr(13) || chr(10) || p_name;
            end if;
        end if;

        return l_rtn;
    end add_name_to_message;

    function replacespecialcharacters(p_string in varchar2)
        return varchar2 is
    begin
        return replace(upper(p_string), '&APOS;', '''');
    end replacespecialcharacters;

    -- Private (support) routines
    -- Retrieves the value from the XML code with the given TAG.
    function get_value_of_tag(p_tag in varchar2, p_begin in integer)
        return varchar2 is
        l_start    integer;
        l_end      integer;
        l_return   varchar2(4000);
    begin
        l_start := instr(v_xml, '<adr:' || p_tag || '>', p_begin) + length(p_tag) + 6;
        l_end := instr(v_xml, '</adr:' || p_tag || '>', p_begin);
        l_return := substr(v_xml, l_start, l_end - l_start);
        return replacespecialcharacters(l_return);
    end get_value_of_tag;

    function get_value_of_tag_clob(p_tag in varchar2, p_begin in integer)
        return clob is
        l_start    integer;
        l_end      integer;
        l_return   clob;
    begin
        l_start := instr(v_xml, '<adr:' || p_tag || '>', p_begin) + length(p_tag) + 6;
        l_end := instr(v_xml, '</adr:' || p_tag || '>', p_begin);
        l_return := substr(v_xml, l_start, l_end - l_start);
        return(l_return);
    end get_value_of_tag_clob;

    -- Formats name for display in desktop views.
    function formalize_name(p_pv in varchar2)
        return varchar2 is
        l_first_name    varchar2(100);
        l_middle_name   varchar2(100);
        l_last_name     varchar2(100);
        l_cadency       varchar2(20);
        l_title         varchar2(20);
    begin
        for z in (select n.first_name, n.middle_name, n.last_name, n.cadency, n.title,
                         nt.code as name_type
                    from t_osi_partic_name n, t_osi_partic_name_type nt
                   where n.participant_version = p_pv and n.name_type = nt.sid)
        loop
            if z.name_type = 'L' then
                l_first_name := z.first_name;
                l_middle_name := z.middle_name;
                l_last_name := z.last_name;
            end if;
        end loop;

        return l_last_name || ', ' || l_first_name || ' ' || l_middle_name;
    end formalize_name;

    /*
        Searches for errors in the XML file either through broken connection or
        problems encountered by DEERS with appropriate error codes.
     */
    function is_valid(v_numtypecode in varchar2, v_numdescription in varchar2, p_ssn in varchar2)
        return varchar2 is
        l_code         varchar2(25)   := null;
        l_start        integer        := 0;
        l_msg          varchar2(3800) := null;
        l_log_prefix   varchar2(200)  := null;
        l_rtn_prefix   varchar2(200)  := null;
    begin
        --- a short XML demonstrates communication errors with DEERS ---
        if length(v_xml) < 25 then
            l_msg := 'No data found at DEERS.';
            l_log_prefix := '[IS_VALID]141 ';
            l_rtn_prefix := 'ERROR ';
        elsif length(v_xml) < 600 then
            l_msg := 'HTTP error in communication with DEERS.';
            l_log_prefix := '[IS_VALID]144 ';
            l_rtn_prefix := 'ERROR ';
        end if;

        l_start := instr(v_xml, '<env:faultcode>', 1) + 15;

        if l_start > 15 then
            l_code := substr(v_xml, l_start, 5);

            if l_code = '14020' then
                l_msg :=
                      'Improper SOAP request sent to DEERS - Communication error 14020 with DEERS.';
                l_log_prefix := '[IS_VALID]154 ';
                l_rtn_prefix := 'ERROR ';
            elsif l_code = '14030' then
                l_msg :=
                      'Bad format of SOAP message to DEERS - Communication error 14030 with DEERS.';
                l_log_prefix := '[IS_VALID]157 ';
                l_rtn_prefix := 'ERROR ';
            elsif l_code = '14150' then
                l_msg := 'DEERS data discrepancy error.';
                l_log_prefix := '[IS_VALID]160 ';
                l_rtn_prefix := 'ERROR ';
            else
                l_msg := 'General communication error with DEERS.';
                l_log_prefix := '[IS_VALID]163 ';
                l_rtn_prefix := 'ERROR ';
            end if;
        end if;

        if l_msg is null then
            l_code := get_value_of_tag('MTCH_RSN_CD', 1);

            case l_code
                when 'PMC' then
                    return 'Y';
                when 'PAB' then
                    update t_osi_participant_human
                       set deers_date = sysdate
                     where sid = v_pv_sid;

                    l_msg :=
                        'More than one matching record found at DEERS for ' || v_numdescription
                        || ' of ' || p_ssn || '.';
                    l_log_prefix := '[IS_VALID]175 ';
                    l_rtn_prefix := 'ERROR ';
                when 'PNB' then
                    update t_osi_participant_human
                       set deers_date = sysdate
                     where sid = v_pv_sid;

                    l_msg :=
                        'No matches found at DEERS for ' || v_numdescription || ' of ' || p_ssn
                        || '.';
                    l_log_prefix := '[IS_VALID]179 ';
                    l_rtn_prefix := 'MSG ';
                else
                    l_code := get_value_of_tag('PN_ID', 1);

                    if    l_code is null
                       or l_code = '' then
                        update t_osi_participant_human
                           set deers_date = sysdate
                         where sid = v_pv_sid;

                        l_msg :=
                            'No matches found at DEERS for ' || v_numdescription || ' of ' || p_ssn
                            || '.';
                        l_log_prefix := '[IS_VALID]190 ';
                        l_rtn_prefix := 'MSG ';
                    else
                        return 'Y';
                    end if;
            end case;
        end if;

        core_logger.log_it(c_pipe, l_log_prefix || l_msg);

        if l_rtn_prefix = 'ERROR ' then
            if instr(l_msg, p_ssn, 1, 1) = 0 then
                l_msg := l_msg || ' - ' || v_numdescription || ':  ' || p_ssn;
            end if;

            if v_pv_sid is not null and v_pv_sid <> '' then
                null;
                /* Added back in by Craig.PUrcell */
                --Commented out until notifications are implemented.
                osi_notification.record_detection
                                       ('DEERS.ERROR',
                                        v_pv_sid,
                                        'Participant:  ' || osi_participant.get_name(v_pv_sid)
                                        || ' - ' || v_numdescription || ': ' || v_ssn,
                                        'I2MS',
                                        sysdate,
                                        osi_personnel.get_current_unit(core_context.personnel_sid),
                                        'DMDC DEERS Error - ' || l_msg);
            end if;
        end if;

        return l_rtn_prefix || l_msg;
    end is_valid;

    /*
        This function was taken from Rich's code in the gateway server, but I have encountered
        a number of XML data packets that produce errors in the first line getting the XMLType.
        Haven't been able to figure out why so I am using string functions to parse the XML data
        packet (GET_VALUE_OF_TAG()).
    */
    function get_deers_element(p_node in varchar2, p_ns in varchar2 := null)
        return varchar2 is
        l_xml      xmltype;
        v_def_ns   varchar2(1000)
            := 'xmlns:rbs="http://adr.dmdc.osd.mil/rbs" '
               || 'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" '
               || 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
               || 'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
               || 'xmlns:adr="http://adr.dmdc.osd.mil/adrRecord"';
    begin
        l_xml := xmltype(substr(v_xml, instr(v_xml, '<env:Envelope')));

        if l_xml.existsnode(p_node, nvl(p_ns, v_def_ns)) = 1 then
            return l_xml.extract(p_node || '/text()', nvl(p_ns, v_def_ns)).getstringval;
        else
            return null;
        end if;
    end get_deers_element;

    -- Gets the I2MS code value to match the DEERS code value using the T_DEERS_MAP table.
    function get_i2ms_equivalent(p_type in varchar2, p_deers_code in varchar2)
        return varchar2 is
        l_rtn   varchar2(50) := null;
    begin
        if p_deers_code is not null then
            for x in (select i2ms_code
                        --      into L_RTN
                      from   t_osi_deers_map
                       where code = p_type and deers_code = p_deers_code)
            loop
                l_rtn := x.i2ms_code;
                exit;
            end loop;
        end if;

        return l_rtn;
    end get_i2ms_equivalent;

    /*
        Some returns from DEERS have multiple personnel tags indicating multiple records. We are
        assuming that the last one is the most current (per analysis of multiple records) so this
        procedure removes all but the last personnel record from the XML data so that parsing of
        service information is easier.
     */
    procedure remove_old_personnel_rcds is
        l_start    integer;
        l_begin    integer        := 1;
        l_end      integer;
        l_return   varchar2(4000);
    begin
        for x in 0 .. 50
        loop
            l_start := instr(v_xml, '<adr:personnel>', l_begin) + 16;
            l_end := instr(v_xml, '<adr:personnel>', l_start);

            if l_start < l_end then
                v_xml := substr(v_xml, 1, l_start) || substr(v_xml, l_end, length(v_xml));
            else
                exit;
            end if;
        end loop;
    end remove_old_personnel_rcds;

    /*
        This procedure is used to added unused DEERS data to a note that will be attached
        to the person's record.
     */
    procedure add_to_note(p_desc in varchar2, p_value in varchar2) is
    begin
        if p_value is not null then
            v_note := v_note || p_desc || p_value || chr(13);
        end if;
    end;

    -- Adds the dash to the phone numbers to separate the area code, exchange and number.
    function format_telephone_number(p_num in varchar2)
        return varchar2 is
        l_rtn   varchar2(25);
    begin
        l_rtn := substr(p_num, 1, 3) || '-';

        if length(p_num) > 8 then
            l_rtn := l_rtn || substr(p_num, 4, 3) || '-' || substr(p_num, 7, length(p_num));
        else
            l_rtn := l_rtn || substr(p_num, 4, length(p_num));
        end if;

        return l_rtn;
    end format_telephone_number;

    /*
        Retrieves information for the T_PERSON table and then inserts if NEW or adds to the temp
        table for the user to select which values to update. Unused data is put into a note for
        future reference.
     */
    function process_person_information(p_new in integer)
        return varchar2 is
        l_birth_date      date           := null;
        l_death_date      date           := null;
        l_rtn             varchar2(100)  := 'Y';
        l_child_sid       varchar2(25)   := null;
        l_ethnicity       varchar2(20)   := null;
        l_ethnicity_sid   varchar2(20)   := null;
        l_temp_str        varchar2(1000) := null;
    begin
        -- Get information for the Person table
        for i in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_OSI_PARTICIPANT'
                  order by assoc_column)
        loop
            l_temp_str := get_value_of_tag(i.xml_code, 1);

            case(i.assoc_column)
                when 'DOB' then
                    if l_temp_str is not null then
                        l_birth_date :=
                            to_date(substr(l_temp_str, 1, 4) || '/' || substr(l_temp_str, 5, 2)
                                    || '/' || substr(l_temp_str, 7, 2),
                                    'yyyy/mm/dd');
                    end if;
                when 'DOD' then
                    if l_temp_str is not null then
                        l_death_date :=
                            to_date(substr(l_temp_str, 1, 4) || '/' || substr(l_temp_str, 5, 2)
                                    || '/' || substr(l_temp_str, 7, 2),
                                    'yyyy/mm/dd');
                    end if;
                when 'ETHNICITY' then
                    l_ethnicity := get_i2ms_equivalent(i.assoc_column, l_temp_str);
                    l_ethnicity_sid := dibrs_reference.lookup_ref_sid('ETHNICITY', l_ethnicity);
                when 'DOD_EDI_PN_ID' then
                    v_dod_edi_pn_id := l_temp_str;
                else
                    l_temp_str := null;
            end case;
        end loop;

        if p_new <> 0 then
            update t_osi_participant
               set dob = l_birth_date,
                   dod = l_death_date,
                   ethnicity = l_ethnicity_sid,
                   dod_edi_pn_id = v_dod_edi_pn_id,
                   confirm_on = sysdate,
                   confirm_by = nvl(core_context.personnel_name(), v_generic_creator)
             where sid = v_person_sid;

            select sid
              into l_temp_str
              from t_osi_status
             where code = 'CONFIRM';

            osi_status.change_status_brute(v_person_sid, l_temp_str, 'DEERS Confirmed');
            v_import_sid := null;
        else
            delete from t_osi_deers_import
                  where participant_sid = v_person_sid;

            insert into t_osi_deers_import
                        (dod_edi_pn_id, participant_sid, birth_date, ethnicity, decease_date)
                 values (v_dod_edi_pn_id, v_person_sid, l_birth_date, l_ethnicity, l_death_date)
              returning sid
                   into v_import_sid;

            v_note := 'DEERS Query executed          ' || to_char(sysdate, 'dd-Mon-yyyy hh24:mi');
            v_note := v_note || chr(13) || chr(13);
            v_note :=
                v_note || 'Data existing in DEERS but not automatically updated in Web I2MS:'
                || chr(13) || chr(13);

            begin
                select description
                  into v_txt
                  from t_dibrs_reference
                 where usage = 'ETHNICITY' and code = l_ethnicity;
            exception
                when no_data_found then
                    v_txt := l_ethnicity;
            end;
        end if;

        return l_rtn;
    exception
        when others then
            core_logger.log_it
                (c_pipe,
                 '[PROCESS_PERSON_INFORMATION]392 Could not update T_OSI_PARTICIPANT table with SID = '
                 || v_person_sid || ' / ' || sqlerrm);
            return 'ERROR Could not update Person info';
    end process_person_information;

    /*
        Retrieves information for the T_PERSON_VERSION table and then inserts if NEW or adds to
        the temp table for the user to select which values to update. Unused data is put into a
        note for future reference.
     */
    function process_pv_information(p_new in integer)
        return varchar2 is
        l_rtn                 varchar2(1000)  := 'Y';
        l_birth_date          date            := null;
        l_gender              varchar2(20)    := null;
        l_gender_sid          varchar2(20)    := null;
        l_race                varchar2(200)   := null;
        l_race_sid            varchar2(20)    := null;
        l_height              number          := null;
        l_weight              number          := null;
        l_eye_color           varchar2(20)    := null;
        l_eye_color_sid       varchar2(20)    := null;
        l_hair_color          varchar2(20)    := null;
        l_hair_color_sid      varchar2(20)    := null;
        l_blood_type          varchar2(40)    := null;
        l_blood_type_sid      varchar2(20)    := null;
        l_service             varchar2(1000)  := null;
        l_service_sid         varchar2(20)    := null;
        l_srvc_comp           varchar2(2000)  := null;
        l_srvc_comp_sid       varchar2(20)    := null;
        l_srvc_pay_grd        varchar2(2000)  := null;
        l_srvc_pay_grd_sid    varchar2(20)    := null;
        l_srvc_pay_pln        varchar2(2000)  := null;
        l_srvc_pay_pln_sid    varchar2(20)    := null;
        l_srvc_rank           varchar2(1000)  := null;
        l_srvc_affiltn        varchar2(200)   := null;
        l_srvc_affiltn_sid    varchar2(20)    := null;
        l_temp_str            varchar2(10000) := null;
        l_start               integer         := 0;
        l_child_sid           varchar2(25)    := null;
        l_srvc_pay_pln2       varchar2(2000)  := null;
        l_srvc_pay_band       varchar2(2000)  := null;
        l_srvc_pay_band_sid   varchar2(20)    := null;
    begin
        -- Get general information for the Person Version table
        for j in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_OSI_PERSON_CHARS' and assoc_column not like 'SA_%'
                  order by assoc_column)
        loop
            l_temp_str := get_value_of_tag(j.xml_code, 1);

            case(j.assoc_column)
                when 'EYE_COLOR' then
                    l_eye_color := get_i2ms_equivalent(j.assoc_column, l_temp_str);
                    l_eye_color_sid :=
                                      osi_reference.lookup_ref_sid('PERSON_EYE_COLOR', l_eye_color);
                when 'HAIR_COLOR' then
                    l_hair_color := get_i2ms_equivalent(j.assoc_column, l_temp_str);
                    l_hair_color_sid :=
                                    osi_reference.lookup_ref_sid('PERSON_HAIR_COLOR', l_hair_color);
                when 'HEIGHT' then
                    l_height := to_number(l_temp_str);
                when 'RACE' then
                    l_race := get_i2ms_equivalent(j.assoc_column, l_temp_str);
                    l_race_sid := dibrs_reference.get_race_sid(l_race);
                when 'SEX' then
                    l_gender := get_i2ms_equivalent(j.assoc_column, l_temp_str);
                    l_gender_sid := dibrs_reference.lookup_ref_sid('SEX', l_gender);
                when 'WEIGHT' then
                    l_weight := to_number(l_temp_str);
                when 'BLOOD_TYPE' then
                    l_blood_type := get_i2ms_equivalent(j.assoc_column, l_temp_str);
                    l_blood_type_sid :=
                                    osi_reference.lookup_ref_sid('PERSON_BLOOD_TYPE', l_blood_type);
                else
                    l_temp_str := null;
            end case;
        end loop;

        -- Get service information for the Person Version table
        for k in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table in('T_OSI_PERSON_CHARS', 'T_OSI_PARTICIPANT_HUMAN')
                       and assoc_column like 'SA_%'
                  order by assoc_column)
        loop
            l_start := instr(v_xml, '<adr:personnel>', 1);
            l_temp_str := get_value_of_tag(k.xml_code, l_start);

            case(k.assoc_column)
                when 'SA_AFFILIATION' then
                    l_srvc_affiltn := get_i2ms_equivalent(k.assoc_column, l_temp_str);
                    l_srvc_affiltn_sid :=
                                  osi_reference.lookup_ref_sid('INDIV_AFFILIATION', l_srvc_affiltn);
                    l_srvc_comp := get_i2ms_equivalent('SA_COMPONENT', l_temp_str);
                    l_srvc_comp_sid :=
                                   dibrs_reference.lookup_ref_sid('SERVICE_COMPONENT', l_srvc_comp);
                when 'SA_PAY_GRADE' then
                    l_srvc_pay_grd := l_temp_str;
                    l_srvc_pay_grd_sid := dibrs_reference.get_pay_grade_sid(l_srvc_pay_grd);

                    if l_srvc_pay_grd = '00' then
                        l_srvc_pay_grd := null;
                        l_srvc_pay_grd_sid := null;
                    end if;
                when 'SA_PAY_PLAN' then
                    l_srvc_pay_pln2 := l_temp_str;
                    l_srvc_pay_pln := get_i2ms_equivalent(k.assoc_column, l_temp_str);
                    l_srvc_pay_pln_sid :=
                                         dibrs_reference.lookup_ref_sid('PAY_PLAN', l_srvc_pay_pln);
                when 'SA_RANK' then
                    l_srvc_rank := l_temp_str;
                when 'SA_SERVICE' then
                    l_service := get_i2ms_equivalent(k.assoc_column, l_temp_str);
                    l_service_sid := dibrs_reference.lookup_ref_sid('SERVICE_TYPE', l_service);
                else
                    l_temp_str := null;
            end case;
        end loop;

        --- Convert to NSPS if L_SRVC_PAY_PLN is 'YA-YP (not YO) ---
        begin
            select plan_code
              into l_temp_str
              from t_dibrs_pay_grade_type
             where code = l_srvc_pay_pln2;
        exception
            when no_data_found then
                l_temp_str := 'BLAHBLAH';
        end;

        if l_temp_str = 'NSPS' then
            if    l_srvc_pay_grd is null
               or l_srvc_pay_grd = '' then
                l_srvc_pay_band := null;
                l_srvc_pay_band_sid := null;
            else
                l_srvc_pay_band := 'PB' || to_char(to_number(l_srvc_pay_grd));
                l_srvc_pay_band_sid := dibrs_reference.get_pay_band_sid(l_srvc_pay_band);
            end if;

            l_srvc_pay_grd := l_srvc_pay_pln2;
            l_srvc_pay_grd_sid := dibrs_reference.get_pay_grade_sid(l_srvc_pay_pln2);
            l_srvc_pay_pln := 'NSPS';
            l_srvc_pay_pln_sid := dibrs_reference.lookup_ref_sid('PAY_PLAN', l_srvc_pay_pln);
        end if;

        if p_new <> 0 then
            update t_osi_participant_human
               set sa_affiliation = l_srvc_affiltn_sid,
                   sa_component = l_srvc_comp_sid,
                   sa_rank = l_srvc_rank,
                   sa_service = l_service_sid
             where sid = v_pv_sid;

            update t_osi_person_chars
               set sex = l_gender_sid,
                   eye_color = l_eye_color_sid,
                   hair_color = l_hair_color_sid,
                   blood_type = l_blood_type_sid,
                   race = l_race_sid,                   -- will be NULL if DEERS is Other or Unknown
                   sa_pay_plan = l_srvc_pay_pln_sid,
                   sa_pay_grade = l_srvc_pay_grd_sid,
                   sa_pay_band = l_srvc_pay_band_sid,
                   height = l_height,
                   weight = l_weight
             where sid = v_pv_sid;
        else
            update t_osi_deers_import
               set pay_plan = l_srvc_pay_pln,
                   pay_grade = l_srvc_pay_grd,
                   pay_band = l_srvc_pay_band,
                   service_rank = l_srvc_rank,
                   sex = l_gender,
                   race = l_race,
                   height = l_height,
                   weight = l_weight,
                   eye_color = l_eye_color,
                   hair_color = l_hair_color,
                   blood_type = l_blood_type,
                   sa_service = l_service,
                   sa_affiliation = l_srvc_affiltn
             where sid = v_import_sid
                or participant_sid = v_person_sid;

            begin
                select description
                  into v_txt
                  from t_dibrs_race_type
                 where code = l_race;
            exception
                when no_data_found then
                    v_txt := l_race;
            end;

            begin
                select description
                  into v_txt
                  from t_dibrs_reference
                 where usage = 'SERVICE_COMPONENT' and code = l_srvc_comp;
            exception
                when no_data_found then
                    v_txt := l_srvc_comp;
            end;

            begin
                select description
                  into v_txt
                  from t_dibrs_reference
                 where usage = 'SERVICE_TYPE' and code = l_service;
            exception
                when no_data_found then
                    v_txt := l_service;
            end;

            begin
                select description
                  into v_txt
                  from t_dibrs_reference
                 where usage = 'SEX' and code = l_gender;
            exception
                when no_data_found then
                    v_txt := l_gender;
            end;

            if l_blood_type = 'UNK' then
                l_blood_type := 'Unknown';
            end if;

            begin
                select description
                  into v_txt
                  from t_osi_reference
                 where usage = 'INDIV_AFFILIATION' and code = l_srvc_affiltn;
            exception
                when no_data_found then
                    v_txt := l_srvc_affiltn;
            end;
        end if;

        update t_osi_participant_human
           set deers_date = sysdate
         where sid = v_pv_sid;

        return l_rtn;
    exception
        when others then
            core_logger.log_it
                (c_pipe,
                 '[PROCESS_PV_INFORMATION]593 Could not update T_OSI_PARTICIPANT_HUMAN with SID of '
                 || v_pv_sid || ' / ' || sqlerrm);
            return 'ERROR Could not update Person Version info';
    end process_pv_information;

    /*
        Retrieves information for the T_PERSON_NAME table and then inserts if NEW or adds to the
        temp table for the user to select which values to update. Unused data is put into a note
        for future reference.
     */
    function process_name_information(p_new in integer)
        return varchar2 is
        l_rtn           varchar2(100)  := 'Y';
        l_last_name     varchar2(100)  := null;
        l_first_name    varchar2(100)  := null;
        l_middle_name   varchar2(100)  := null;
        l_cadency       varchar2(20)   := null;
        l_child_sid     varchar2(25)   := null;
        l_temp_str      varchar2(1000) := null;
    begin
        -- Get name information
        for n in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_OSI_PARTIC_NAME'
                  order by assoc_column)
        loop
            l_temp_str := get_value_of_tag(n.xml_code, 1);

            case(n.assoc_column)
                when 'CADENCY' then
                    l_cadency := l_temp_str;
                when 'FIRST_NAME' then
                    l_first_name := l_temp_str;
                when 'LAST_NAME' then
                    l_last_name := l_temp_str;
                when 'MIDDLE_NAME' then
                    l_middle_name := l_temp_str;
                else
                    l_temp_str := null;
            end case;
        end loop;

        if p_new <> 0 then
            update t_osi_partic_name
               set cadency = upper(l_cadency),
                   first_name = upper(l_first_name),
                   last_name = upper(l_last_name),
                   middle_name = upper(l_middle_name)
             where participant_version = v_pv_sid;
        else
            update t_osi_deers_import
               set first_name = upper(l_first_name),
                   middle_name = upper(l_middle_name),
                   last_name = upper(l_last_name),
                   cadency = upper(l_cadency)
             where sid = v_import_sid
                or participant_sid = v_person_sid;
        end if;

        return l_rtn;
    exception
        when others then
            core_logger.log_it
                (c_pipe,
                 '[PROCESS_NAME_INFORMATION]660 Could not update T_OSI_PARTIC_NAME where PARTICIPANT_VERSION = '
                 || v_pv_sid || ' / ' || sqlerrm);
            return 'ERROR Could not update Person Name info';
    end process_name_information;

    /*
        Retrieves information for the T_PHONE_EMAIL table and then inserts if NEW or adds to the
        temp table for the user to select which values to update. Unused data is put into a note
        for future reference.
     */
    function process_phone_information(p_new in integer)
        return varchar2 is
        l_rtn           varchar2(100)  := 'Y';
        l_temp_str      varchar2(1000) := null;
        l_child_sid     varchar2(25)   := null;
        l_pe_category   varchar2(50)   := null;
    begin
        -- Get phone and e-mail information
        for o in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_OSI_PARTIC_CONTACT'
                  order by assoc_column)
        loop
            l_temp_str := get_value_of_tag(o.xml_code, 1);

            if l_temp_str is not null then
                begin
                    case(o.assoc_column)
                        when 'EMAIL' then
                            l_pe_category := osi_reference.lookup_ref_sid('CONTACT_TYPE', 'EMLP');
                        when 'HOME' then
                            l_pe_category := osi_reference.lookup_ref_sid('CONTACT_TYPE', 'HOMEP');
                            l_temp_str := format_telephone_number(l_temp_str);
                        when 'WORK' then
                            l_pe_category := osi_reference.lookup_ref_sid('CONTACT_TYPE', 'OFFP');
                            l_temp_str := format_telephone_number(l_temp_str);
                        else
                            l_pe_category := null;
                    end case;
                exception
                    when no_data_found then
                        l_pe_category := null;
                end;

                if p_new <> 0 and l_pe_category is not null then
                    insert into t_osi_partic_contact
                                (participant_version, type, value)
                         values (v_pv_sid, l_pe_category, l_temp_str);
                else
                    if l_pe_category is not null then
                        if l_pe_category = osi_reference.lookup_ref_sid('CONTACT_TYPE', 'EMLP') then
                            update t_osi_deers_import
                               set email = l_temp_str
                             where sid = v_import_sid
                                or participant_sid = v_person_sid;
                        end if;

                        if l_pe_category = osi_reference.lookup_ref_sid('CONTACT_TYPE', 'HOMEP') then
                            update t_osi_deers_import
                               set home = l_temp_str
                             where sid = v_import_sid
                                or participant_sid = v_person_sid;
                        end if;

                        if l_pe_category = osi_reference.lookup_ref_sid('CONTACT_TYPE', 'OFFP') then
                            update t_osi_deers_import
                               set work = l_temp_str
                             where sid = v_import_sid
                                or participant_sid = v_person_sid;
                        end if;
                    end if;
                end if;
            end if;
        end loop;

        return l_rtn;
    end process_phone_information;

    /*
        Retrieves information for the T_ADDRESS and T_ADDRESS_V2 table and then inserts if NEW or
        adds to the temp table for the user to select which values to update. Unused data is put
        into a note for future reference.  This function is the last called and will add a new note
        or attach to existing one for this person.
     */
    function process_address_information(p_new in integer)
        return varchar2 is
        l_rtn              varchar2(100)  := 'Y';
        l_temp_str         varchar2(1000) := null;
        l_child_sid        varchar2(25)   := null;
        l_addr1            varchar2(250)  := null;
        l_addr2            varchar2(250)  := null;
        l_addr_city        varchar2(200)  := null;
        l_addr_state       varchar2(25)   := null;
        l_addr_state_sid   varchar2(20)   := null;
        l_zip_code         varchar2(20)   := null;
        l_addr_cntry       varchar2(50)   := null;
        l_addr_cntry_sid   varchar2(20)   := null;
        l_addr_type        varchar2(20)   := null;
        l_brth_state       varchar2(30)   := null;
        l_brth_state_sid   varchar2(20)   := null;
        l_brth_cntry       varchar2(10)   := null;
        l_brth_cntry_sid   varchar2(20)   := null;
        l_tmp_note         clob           := null;
    begin
        l_addr_type := osi_address.get_addr_type(v_obj_type, 'ADDR_LIST', 'MAIL');

        -- Get Mailing Address Information --
        for p in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_OSI_ADDRESS' and xml_code like 'MA_%'
                  order by assoc_column)
        loop
            l_temp_str := get_value_of_tag(p.xml_code, 1);

            case(p.assoc_column)
                when 'ADDRESS_1' then
                    l_addr1 := l_temp_str;
                when 'ADDRESS_2' then
                    l_addr2 := l_temp_str;
                when 'CITY' then
                    l_addr_city := l_temp_str;
                when 'COUNTRY' then
                    l_addr_cntry := upper(l_temp_str);
                    l_addr_cntry_sid := dibrs_reference.get_country_sid(upper(l_temp_str));
                when 'STATE' then
                    l_addr_state := upper(l_temp_str);
                    l_addr_state_sid := dibrs_reference.get_state_sid(upper(l_temp_str));
                when 'POSTAL_CODE' then
                    l_zip_code := l_temp_str;
                /*
                 This part of the zip code is not stored in Web I2MS.
                when 'ADDR_ZIP_X' then
                    l_zip_code := l_zip_code || '-' || l_temp_str;
                */
            else
                    l_temp_str := null;
            end case;
        end loop;

        if p_new <> 0 then
            begin
                insert into t_osi_address
                            (obj,
                             address_type,
                             address_1,
                             address_2,
                             city,
                             state,
                             postal_code,
                             country)
                     values (v_person_sid,
                             l_addr_type,
                             l_addr1,
                             l_addr2,
                             l_addr_city,
                             l_addr_state_sid,
                             l_zip_code,
                             l_addr_cntry_sid)
                  returning sid
                       into l_temp_str;

                insert into t_osi_partic_address
                            (participant_version, address)
                     values (v_pv_sid, l_temp_str)
                  returning sid
                       into l_child_sid;
            exception
                when others then
                    begin
                        insert into t_osi_address
                                    (obj,
                                     address_type,
                                     address_1,
                                     address_2,
                                     city,
                                     state,
                                     postal_code,
                                     country)
                             values (v_person_sid,
                                     l_addr_type,
                                     l_addr1,
                                     l_addr2,
                                     l_addr_city,
                                     l_addr_state_sid,
                                     l_zip_code,
                                     l_addr_cntry_sid)
                          returning sid
                               into l_temp_str;

                        insert into t_osi_partic_address
                                    (participant_version, address)
                             values (v_pv_sid, l_temp_str)
                          returning sid
                               into l_child_sid;
                    exception
                        when others then
                            insert into t_osi_address
                                        (obj,
                                         address_type,
                                         address_1,
                                         address_2,
                                         city,
                                         state,
                                         postal_code,
                                         country)
                                 values (v_person_sid,
                                         l_addr_type,
                                         l_addr1,
                                         l_addr2,
                                         l_addr_city,
                                         l_addr_state_sid,
                                         l_zip_code,
                                         l_addr_cntry_sid)
                              returning sid
                                   into l_temp_str;

                            insert into t_osi_partic_address
                                        (participant_version, address)
                                 values (v_pv_sid, l_temp_str)
                              returning sid
                                   into l_child_sid;
                    end;
            end;

            update t_osi_participant_version
               set current_address = l_child_sid
             where sid = v_pv_sid;
        else
            update t_osi_deers_import
               set addr_1 = l_addr1,
                   addr_2 = l_addr2,
                   addr_city = l_addr_city,
                   addr_state = l_addr_state,
                   addr_zip = l_zip_code,
                   addr_country = l_addr_cntry
             where sid = v_import_sid
                or participant_sid = v_person_sid;
        end if;

        --- Birth State and Country ---
        for q in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_OSI_ADDRESS' and xml_code like 'BRTH_%'
                  order by assoc_column)
        loop
            l_temp_str := get_value_of_tag(q.xml_code, 1);

            case(q.assoc_column)
                when 'STATE' then
                    l_brth_state := upper(l_temp_str);
                    l_brth_state_sid := dibrs_reference.get_state_sid(upper(l_temp_str));
                when 'COUNTRY' then
                    l_brth_cntry := upper(l_temp_str);
                    l_brth_cntry_sid := dibrs_reference.get_country_sid(upper(l_temp_str));
                else
                    l_temp_str := null;
            end case;
        end loop;

        if p_new <> 0 and(   l_brth_state is not null
                          or l_brth_cntry is not null) then
            begin
                l_temp_str := osi_address.get_addr_type(v_obj_type, 'BIRTH', 'BIRTH');

                insert into t_osi_address
                            (obj, address_type, state, country)
                     values (v_person_sid, l_temp_str, l_brth_state_sid, l_brth_cntry_sid)
                  returning sid
                       into l_child_sid;

                insert into t_osi_partic_address
                            (participant_version, address)
                     values (v_pv_sid, l_child_sid);
            exception
                when others then
                    begin
                        insert into t_osi_address
                                    (obj, address_type, province, country)
                             values (v_person_sid, l_temp_str, l_brth_state_sid, l_brth_cntry_sid)
                          returning sid
                               into l_child_sid;

                        insert into t_osi_partic_address
                                    (participant_version, address)
                             values (v_pv_sid, l_child_sid);
                    exception
                        when others then
                            insert into t_osi_address
                                        (obj, address_type, province)
                                 values (v_person_sid, l_temp_str, l_brth_state)
                              returning sid
                                   into l_child_sid;

                            insert into t_osi_partic_address
                                        (participant_version, address)
                                 values (v_pv_sid, l_child_sid);
                    end;
            end;
        else
            if l_brth_state is not null then
                begin
                    select description
                      into v_txt
                      from t_dibrs_state
                     where sid = l_brth_state;
                exception
                    when no_data_found then
                        v_txt := l_brth_state;
                end;

                update t_osi_deers_import
                   set birth_state = l_brth_state
                 where sid = v_import_sid
                    or participant_sid = v_person_sid;
            end if;

            if l_brth_cntry is not null then
                begin
                    select description
                      into v_txt
                      from t_dibrs_country
                     where sid = l_brth_cntry;
                exception
                    when no_data_found then
                        v_txt := l_brth_cntry;
                end;

                update t_osi_deers_import
                   set birth_country = l_brth_cntry
                 where sid = v_import_sid
                    or participant_sid = v_person_sid;
            end if;
        end if;

        if p_new = 0 then
            for x in (select n.note_text
                        from t_osi_note n, t_osi_note_type nt
                       where n.obj = v_person_sid
                         and n.note_type = nt.sid
                         and nt.obj_type = v_obj_type
                         and nt.code = 'DEERS')
            loop
                l_tmp_note := x.note_text;
            end loop;

            select sid
              into l_temp_str
              from t_osi_note_type
             where obj_type = v_obj_type and code = 'DEERS';

            if l_tmp_note is null then
                insert into t_osi_note
                            (obj, lock_mode, note_type, note_text)
                     values (v_person_sid, 'IMMED', l_temp_str, v_note || chr(13) || chr(13));
            else
                update t_osi_note
                   set note_text =
                           l_tmp_note || chr(13)
                           || '-------------------------------------------------------' || chr(13)
                           || v_note || chr(13) || chr(13)
                 where obj = v_person_sid and note_type = l_temp_str;
            end if;
        end if;

        return l_rtn;
    exception
        when others then
            core_logger.log_it
                (c_pipe,
                 '[PROCESS_ADDRESS_INFORMATION]972 Could not update T_OSI_PARTIC_ADDRESS where PARTICIPANT_VERSION = '
                 || v_pv_sid || ' / ' || sqlerrm);
            return 'ERROR Could not update Person address info';
    end process_address_information;

    function process_photo_information(p_new in integer)
        return varchar2 is
        l_rtn     varchar2(100) := 'Y';
        l_photo   clob;
    begin
        l_photo := get_value_of_tag_clob('PHT_IMG', 1);

        if l_photo is not null then
            if p_new <> 0 then
                insert into t_osi_attachment
                            (obj, description, type, storage_loc_type, source, content, lock_mode)
                     values (v_person_sid,
                             'DEERS Photo imported:  ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS'),
                             (select sid
                                from t_osi_attachment_type
                               where obj_type = v_obj_type and usage = 'MUGSHOT' and code = 'MUG'),
                             'DB',
                             'DEERS',
                             osi_util.hex_to_blob(l_photo),
                             'LOCKED');
            else
                update t_osi_deers_import
                   set photo = osi_util.hex_to_blob(l_photo)
                 where sid = v_import_sid
                    or participant_sid = v_person_sid;
            end if;
        end if;

        return l_rtn;
    exception
        when others then
            core_logger.log_it
                (c_pipe,
                 '[PROCESS_PHOTO_INFORMATION]973 Could not update T_OSI_ATTACHMENT table with OBJ = '
                 || v_person_sid || ' / ' || sqlerrm);
            return 'ERROR Could not update Photo info';
    end process_photo_information;

    /*
        This function gets the Unit code from the personnel record and then processes it according
        to DMDC specifications for each branch of service to get the UIC.
     */
    function get_uic(p_new in integer)
        return varchar2 is
        l_rtn        varchar2(100) := null;
        l_uic        varchar2(10)  := null;
        l_svc        varchar2(10)  := null;
        l_unit_sid   varchar2(20)  := null;
        l_rel_sid    varchar2(20)  := null;
    begin
        l_uic := get_value_of_tag('UNIT_ID_CD', 1);
        l_svc := get_value_of_tag('SVC_CD', 1);

        if    l_svc = 'A'
           or l_svc = 'N' then
            l_rtn := substr(l_uic, 1, 6);
        elsif l_svc = 'F' then
            l_rtn := 'F' || substr(l_uic, length(l_uic) - 3, 4);
        elsif l_svc = 'C' then
            l_rtn := 'C' || substr(l_uic, 1, 7);
        elsif l_svc = 'M' then
            l_rtn := 'M' || l_uic;
        else
            l_rtn := null;
        end if;

        return l_rtn;
    end;

    /*
        This function looks for a UIC from the Personnel tag in the XML and if it exists looks for
        an organization participant with a matching UIC and creates a relationship between them.
        Unused data is put into a note for future reference.
     */
    function process_unit_relationship(p_new in integer)
        return varchar2 is
        l_rtn        varchar2(100)                         := 'Y';
        l_uic        varchar2(10)                          := null;
        l_unit_sid   varchar2(20)                          := null;
        l_rel_sid    varchar2(20)                          := null;
        l_person_a   varchar2(20);
        l_person_b   varchar2(20);
        l_rel_type   t_osi_partic_relation.rel_type%type;
    begin
        l_uic := get_uic(p_new);
        core_logger.log_it(c_pipe, 'PROCESS_UNIT_RELATIONSHIP:  ' || l_uic);

        if l_uic is not null then
            for x in (select pv.participant
                        from t_osi_participant_version pv,
                             t_osi_participant_nonhuman nh,
                             t_osi_reference r
                       where pv.sid = nh.sid
                         and nh.org_uic = l_uic
                         and nh.sub_type = r.sid
                         and r.usage = 'PART.NONINDIV.ORG'
                         and r.code = 'POUM')
            loop
                l_unit_sid := x.participant;
            end loop;

            select sid
              into l_rel_type
              from t_osi_partic_relation_type
             where code = 'IMOU';

            if l_unit_sid is not null then
                if p_new <> 0 then
                    insert into t_osi_partic_relation
                                (partic_a, partic_b, rel_type, comments, known_date)
                         values (v_person_sid,
                                 l_unit_sid,
                                 l_rel_type,
                                 'DEERS created relationship',
                                 sysdate);
                else
                    begin
                        select sid, partic_a, partic_b
                          into l_rel_sid, l_person_a, l_person_b
                          from t_osi_partic_relation
                         where (   (partic_a = v_person_sid and partic_b = l_unit_sid)
                                or (partic_b = v_person_sid and partic_a = l_unit_sid))
                           and (rel_type = l_rel_type and (to_char(comments)='DEERS' or to_char(comments)='DEERS created relationship'));
                           --and (rel_type = 'DEERS' or rel_type = 'DEERS created relationship');
                    exception
                        when no_data_found then
                            l_rel_sid := null;
                    end;

                    if l_rel_sid is null then
                        insert into t_osi_partic_relation
                                    (partic_a, partic_b, rel_type, comments, known_date)
                             values (v_person_sid,
                                     l_unit_sid,
                                     l_rel_type,
                                     'DEERS created relationship',
                                     sysdate);
                    else
                        -- currently adding DEERS UIC data to the note rather than
                        --    changing current record
                        -- now we are always creating a relationship
                        if    l_person_a = l_unit_sid
                           or l_person_b = l_unit_sid then
                            add_to_note('DEERS UIC data:  ', l_uic);
                        else
                            insert into t_osi_partic_relation
                                        (partic_a, partic_b, rel_type, comments, known_date)
                                 values (v_person_sid,
                                         l_unit_sid,
                                         l_rel_type,
                                         'DEERS created relationship',
                                         sysdate);
                        end if;
                    end if;
                end if;
            end if;
        end if;

        if    l_unit_sid is null
           or l_unit_sid = '' then
            add_to_note('** DEERS UIC data NOT FOUND (Unit Relationship not added):  ',
                        'UIC=' || l_uic || chr(13));
        end if;

        return l_rtn;
    end process_unit_relationship;

    /*
        This function parses thru the XML information using the above functions to get all of the
        data for a new or existing participant.
     */
    function process_deers_participant(
        p_new              in   integer,
        v_numtypecode      in   varchar2,
        v_numdescription   in   varchar2)
        return varchar2 is
        l_citizenship       varchar2(200)                       := null;
        l_citizenship_sid   varchar2(20)                        := null;
        l_temp_str          varchar2(1000)                      := null;
        l_pv_sid            varchar2(25)                        := null;
        l_rtn               varchar2(100)                       := 'Y';
        l_child_sid         varchar2(25)                        := null;
        l_num_type          t_osi_partic_number_type.sid%type;
    begin
        l_rtn := process_person_information(p_new);

        if l_rtn <> 'Y' then
            return l_rtn;
        end if;

        l_rtn := process_pv_information(p_new);

        if l_rtn <> 'Y' then
            return l_rtn;
        end if;

        l_rtn := process_unit_relationship(p_new);

        if l_rtn <> 'Y' then
            return l_rtn;
        end if;

        select sid
          into l_num_type
          from t_osi_partic_number_type
         where code = v_numtypecode;

        --- Get Number ---
        for l in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_OSI_PARTIC_NUMBER'
                  order by assoc_column)
        loop
            v_ssn := get_value_of_tag(l.xml_code, 1);
        end loop;

        if p_new <> 0 then
            begin
                select pn.sid
                  into l_child_sid
                  from t_osi_partic_number pn
                 where pn.participant_version = v_pv_sid and pn.num_type = l_num_type;
            exception
                when no_data_found then
                    l_child_sid := null;
            end;

            if l_child_sid is not null then
                update t_osi_partic_number
                   set num_value = v_ssn
                 where sid = l_child_sid;
            else
                insert into t_osi_partic_number
                            (participant_version, num_type, num_value)
                     values (v_pv_sid, l_num_type, v_ssn);
            end if;
        end if;

        -- Get citizenship information
        for m in (select   substr(xml_code,
                                  instr(xml_code, ':', 7) + 1,
                                  length(xml_code)) as xml_code,
                           i2ms_table, assoc_column
                      from t_osi_deers_xml_map
                     where i2ms_table = 'T_PARTIC_CITIZENSHIP'
                  order by assoc_column)
        loop
            l_citizenship := get_value_of_tag(m.xml_code, 1);
            l_citizenship_sid := dibrs_reference.get_country_sid(l_citizenship);

            if l_citizenship is null then
                l_citizenship := get_value_of_tag('BRTH_CTRY_CD', 1);
                l_citizenship_sid := dibrs_reference.get_country_sid(l_citizenship);
            end if;
        end loop;

        if p_new <> 0 then
            if l_citizenship is not null then
                insert into t_osi_partic_citizenship
                            (participant_version, country)
                     values (v_pv_sid, l_citizenship_sid);
            end if;
        else
            begin
                select description
                  into v_txt
                  from t_dibrs_country
                 where code = l_citizenship;
            exception
                when no_data_found then
                    v_txt := l_citizenship;
            end;

            update t_osi_deers_import
               set citizenship = l_citizenship
             where sid = v_import_sid
                or participant_sid = v_person_sid;
        end if;

        l_rtn := process_name_information(p_new);

        if l_rtn <> 'Y' then
            return l_rtn;
        end if;

        l_rtn := process_phone_information(p_new);

        if l_rtn <> 'Y' then
            return l_rtn;
        end if;

        l_rtn := process_address_information(p_new);
        l_rtn := process_photo_information(p_new);
        core_logger.log_it
                         (c_pipe,
                          '[PROCESS_DEERS_PARTICIPANT]1212 Successfully obtained DEERS data for '
                          || v_ssn || ' (' || osi_participant.get_name(v_pv_sid) || ')');
        return l_rtn;
    exception
        when others then
            core_logger.log_it
                             (c_pipe,
                              '[PROCESS_DEERS_PARTICIPANT]1221 Error processing DEERS data for '
                              || v_numdescription || ' = ' || v_ssn || ' / ' || sqlerrm);
            return 'ERROR Error processing DEERS data';
    end process_deers_participant;

    -- Used for testing, using an anonymous block in SQL window.
    function get_value_of_tag2(p_clob in clob, p_tag in varchar2, p_begin in integer)
        return varchar2 is
        l_start    integer;
        l_end      integer;
        l_return   varchar2(4000);
    begin
        l_start := instr(p_clob, '<adr:' || p_tag || '>', p_begin) + length(p_tag) + 6;
        l_end := instr(p_clob, '</adr:' || p_tag || '>', p_begin);
        l_return := substr(p_clob, l_start, l_end - l_start);
        return l_return;
    end get_value_of_tag2;

    function is_searchable_number(p_num_type in varchar2)
        return varchar2 is
    begin
        for x in (select deers_searchable
                    from t_osi_partic_number_type
                   where (   sid = p_num_type
                          or code = p_num_type))
        loop
            return x.deers_searchable;
        end loop;

        return 'N';
    exception
        when others then
            log_error('is_searchable_number: ' || sqlerrm);
            raise;
    end is_searchable_number;

    /*
        This procedure is used when aborting a DEERS update to remove the produced record from the
        initial DEERS call.  We are currently not retaining records for each import and are instead
        writing unused data into a DEERS note attached to the person.
     */
    procedure delete_import_record(p_sid in varchar2) is
    begin

         delete from t_osi_deers_import where sid = p_sid;
         commit;

    end delete_import_record;

    /*
        This procedure is used to clear out data from the temp table that the user doesn't want to
        use to update the current participant.  Pass in a tilde separated list (with no spaces) of
        the table columns to delete and the SID from the T_OSI_DEERS_IMPORT table.
     */
    procedure delete_update_field(p_column in varchar2, p_sid in varchar2) is
        l_col        varchar2(50);
        l_pos        integer;
        l_bgn        integer       := 1;
        l_txt        varchar2(100);
        l_note       clob;
        l_temp_str   varchar2(400);
    begin

        v_note := null;
        
        if v_person_sid is null then
          
          begin
               select participant_sid into v_person_sid from t_osi_deers_import where sid=p_sid;
          exception when others then
               
               null;
               
          end; 
            
        end if;
        
        for x in 1 .. 1000
        loop
            l_pos := instr(p_column, '~', l_bgn);

            if l_pos = 0 then
                l_pos := length(p_column) + l_bgn;
            end if;

            l_col := substr(p_column, l_bgn, l_pos - l_bgn);
            core_logger.log_it(c_pipe, 'SET ' || l_col || ' TO NULL.');

            case l_col
                when 'FIRST_NAME' then
                    
                    begin
                    select first_name
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;
                    add_to_note('DEERS First Name is ', l_txt);

                    update t_osi_deers_import
                       set first_name = null
                     where sid = p_sid;
                when 'MIDDLE_NAME' then
                    begin
                    select middle_name
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Middle Name is ', l_txt);

                    update t_osi_deers_import
                       set middle_name = null
                     where sid = p_sid;
                when 'LAST_NAME' then
                    begin
                    select last_name
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Last Name is ', l_txt);

                    update t_osi_deers_import
                       set last_name = null
                     where sid = p_sid;
                when 'CADENCY' then
                    begin
                    select cadency
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Cadency is ', l_txt);

                    update t_osi_deers_import
                       set cadency = null
                     where sid = p_sid;
                when 'DOB' then
                    begin
                    select to_char(birth_date, 'dd-Mon-yyyy')
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Birth Date is ', l_txt);

                    update t_osi_deers_import
                       set birth_date = null
                     where sid = p_sid;
                when 'PAY_PLAN' then
                    begin
                        select d.description, i.pay_plan
                          into l_txt, l_temp_str
                          from t_osi_deers_import i, t_dibrs_reference d
                         where i.sid = p_sid and i.pay_plan = d.code and d.usage = 'PAY_PLAN';
                    exception
                        when no_data_found then
                            l_txt := l_temp_str;
                    end;

                    add_to_note('DEERS Pay Plan is ', l_txt);

                    update t_osi_deers_import
                       set pay_plan = null
                     where sid = p_sid;
                when 'PAY_GRADE' then
                    begin
                    select pay_grade
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Pay Grade is ', l_txt);

                    update t_osi_deers_import
                       set pay_grade = null
                     where sid = p_sid;
                when 'PAY_BAND' then
                    begin
                    select pay_band
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Pay Band is ', l_txt);

                    update t_osi_deers_import
                       set pay_band = null
                     where sid = p_sid;
                when 'RANK' then
                    begin
                    select service_rank
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Service Rank is ', l_txt);

                    update t_osi_deers_import
                       set service_rank = null
                     where sid = p_sid;
                when 'ADDR_1' then
                    begin
                    select addr_1
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Street Address is ', l_txt);

                    update t_osi_deers_import
                       set addr_1 = null
                     where sid = p_sid;
                when 'ADDR_2' then
                    begin
                    select addr_2
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Street Address line 2 is ', l_txt);

                    update t_osi_deers_import
                       set addr_2 = null
                     where sid = p_sid;
                when 'ADDR_CITY' then
                    begin
                    select addr_city
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Address City is ', l_txt);

                    update t_osi_deers_import
                       set addr_city = null
                     where sid = p_sid;
                when 'ADDR_STATE' then
                    begin
                    select nvl(d.description, i.addr_state)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_state d
                     where i.sid = p_sid and i.addr_state = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Address State is ', l_txt);

                    update t_osi_deers_import
                       set addr_state = null
                     where sid = p_sid;
                when 'ADDR_ZIP' then
                    begin
                    select addr_zip
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Zip Code is ', l_txt);

                    update t_osi_deers_import
                       set addr_zip = null
                     where sid = p_sid;
                when 'ADDR_COUNTRY' then
                    begin
                    select nvl(d.description, i.addr_country)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_country d
                     where i.sid = p_sid and i.addr_country = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Address Country is ', l_txt);

                    update t_osi_deers_import
                       set addr_country = null
                     where sid = p_sid;

                when 'ADDRESS_DISPLAY' then

                    begin
                    select addr_1
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Street Address is ', l_txt);

                    update t_osi_deers_import
                       set addr_1 = null
                     where sid = p_sid;

                    begin
                    select addr_2
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Street Address line 2 is ', l_txt);

                    update t_osi_deers_import
                       set addr_2 = null
                     where sid = p_sid;

                    begin
                    select addr_city
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Address City is ', l_txt);

                    update t_osi_deers_import
                       set addr_city = null
                     where sid = p_sid;

                    begin
                    select nvl(d.description, i.addr_state)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_state d
                     where i.sid = p_sid and i.addr_state = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Address State is ', l_txt);

                    update t_osi_deers_import
                       set addr_state = null
                     where sid = p_sid;

                    begin
                    select addr_zip
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Zip Code is ', l_txt);

                    update t_osi_deers_import
                       set addr_zip = null
                     where sid = p_sid;

                    begin
                    select nvl(d.description, i.addr_country)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_country d
                     where i.sid = p_sid and i.addr_country = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Address Country is ', l_txt);

                    update t_osi_deers_import
                       set addr_country = null
                     where sid = p_sid;
                     
                when 'SSN' then
                    add_to_note('', l_txt);
                when 'FID' then
                    add_to_note('', l_txt);
                when 'ETHNICITY' then
                    begin
                    select nvl(d.description, i.ethnicity)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_reference d
                     where i.sid = p_sid and i.ethnicity = d.code(+) and usage = 'ETHNICITY';
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Ethnicity is ', l_txt);

                    update t_osi_deers_import
                       set ethnicity = null
                     where sid = p_sid;
                when 'EYE_COLOR' then
                    begin
                    select eye_color
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Eye Color is ', l_txt);

                    update t_osi_deers_import
                       set eye_color = null
                     where sid = p_sid;
                when 'HAIR_COLOR' then
                    begin
                    select hair_color
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Hair Color is ', l_txt);

                    update t_osi_deers_import
                       set hair_color = null
                     where sid = p_sid;
                when 'HEIGHT' then
                    begin
                    select height
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Height is ', l_txt);

                    update t_osi_deers_import
                       set height = null
                     where sid = p_sid;
                when 'WEIGHT' then
                    begin
                    select weight
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Weight is ', l_txt);

                    update t_osi_deers_import
                       set weight = null
                     where sid = p_sid;
                when 'RACE' then
                    begin
                    select nvl(d.description, i.race)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_race_type d
                     where i.sid = p_sid and i.race = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Race is ', l_txt);

                    update t_osi_deers_import
                       set race = null
                     where sid = p_sid;
                when 'SEX' then
                    begin
                    select nvl(d.description, i.sex)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_reference d
                     where i.sid = p_sid and i.sex = d.code(+) and d.usage = 'SEX';
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Sex is ', l_txt);

                    update t_osi_deers_import
                       set sex = null
                     where sid = p_sid;
                when 'BLOOD_TYPE' then
                    begin
                    select blood_type
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Blood Type is ', l_txt);

                    update t_osi_deers_import
                       set blood_type = null
                     where sid = p_sid;
                when 'SERVICE' then
                    begin
                    select nvl(d.description, i.sa_service)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_reference d
                     where i.sid = p_sid and i.sa_service = d.code(+) and d.usage = 'SERVICE_TYPE';
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Service is ', l_txt);

                    update t_osi_deers_import
                       set sa_service = null
                     where sid = p_sid;
                when 'AFFILIATION' then
                    begin
                    select nvl(d.description, i.sa_affiliation)
                      into l_txt
                      from t_osi_deers_import i, t_osi_reference d
                     where i.sid = p_sid and i.sa_affiliation = d.code(+)
                           and d.usage = 'INDIV_AFFILIATION';
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Service Affiliation is ', l_txt);

                    update t_osi_deers_import
                       set sa_affiliation = null
                     where sid = p_sid;
                when 'CITIZENSHIP' then
                    begin
                    select nvl(d.description, i.citizenship)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_country d
                     where i.sid = p_sid and i.citizenship = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Citizenship is ', l_txt);

                    update t_osi_deers_import
                       set citizenship = null
                     where sid = p_sid;
                when 'BIRTH_STATE' then
                    begin
                    select nvl(d.description, i.birth_state)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_state d
                     where i.sid = p_sid and i.birth_state = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Birth State is ', l_txt);

                    update t_osi_deers_import
                       set birth_state = null
                     where sid = p_sid;
                when 'BIRTH_COUNTRY' then
                    begin
                    select nvl(d.description, i.birth_country)
                      into l_txt
                      from t_osi_deers_import i, t_dibrs_country d
                     where i.sid = p_sid and i.birth_country = d.code(+);
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Birth Country is ', l_txt);

                    update t_osi_deers_import
                       set birth_country = null
                     where sid = p_sid;
                when 'HOME_PHONE' then
                    begin
                    select home
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Home Phone # is ', l_txt);

                    update t_osi_deers_import
                       set home = null
                     where sid = p_sid;
                when 'WORK_PHONE' then
                    begin
                    select work
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Work Phone # is ', l_txt);

                    update t_osi_deers_import
                       set work = null
                     where sid = p_sid;
                when 'EMAIL' then
                    begin
                    select email
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Email Address is ', l_txt);

                    update t_osi_deers_import
                       set email = null
                     where sid = p_sid;
                when 'DOD' then
                    begin
                    select decease_date
                      into l_txt
                      from t_osi_deers_import
                     where sid = p_sid;
                    exception when others then
                             l_txt:='';
                    end;

                    add_to_note('DEERS Decease Date is ', l_txt);

                    update t_osi_deers_import
                       set decease_date = null
                     where sid = p_sid;
                when 'PHOTO' then
                    update t_osi_deers_import
                       set photo = null
                     where sid = p_sid;
                else
                    add_to_note('', l_txt);
            end case;

            if l_pos = length(p_column) + l_bgn then
                exit;
            end if;

            l_bgn := l_pos + 1;
        end loop;
        
        if v_person_sid is not null then

          if v_note is not null then
              select sid
                into l_temp_str
                from t_osi_note_type
               where obj_type = v_obj_type and code = 'DEERS';

              for c in (select n.note_text
                          from t_osi_note n
                         where n.note_type = l_temp_str and n.obj = v_person_sid)
              loop
                  l_note := c.note_text;
              end loop;

              v_tmp_note :=
                  'Additional DEERS intentionally not updated by user or Fields that have not changed:'
                  || chr(13) || chr(13) || v_note || chr(13) || chr(13);

              if l_note is null then
                  insert into t_osi_note
                              (obj, lock_mode, note_type, note_text)
                       values (v_person_sid, 'IMMED', l_temp_str, v_tmp_note);
              else
                  update t_osi_note
                     set note_text = l_note || v_tmp_note
                   where note_type = l_temp_str and obj = v_person_sid;
              end if;
          end if;
          
        end if;
        
commit;
    exception
        when others then
            core_logger.log_it
                      (c_pipe,
                       '[DELETE_UPDATE_FIELD]1673 Could not find T_OSI_DEERS_IMPORT record SID '
                       || p_sid || ' - ' || SQLERRM);
    end delete_update_field;

    /*
        This will be the main called function when requesting information from DEERS.                                                               ---
        When P_NEW is 1 (new participant) the SSN will be passed into P_SSN and the
        last name into P_LAST_NAME.  When P_NEW is 0 (updating current participant)
        the SID from the T_PERSON table will be passed into P_SSN and P_LAST_NAME will be NULL.
    */
    function get_deers_information(
        p_ssn         in   varchar2,
        p_last_name   in   varchar2,
        p_new         in   integer,
        p_numtype     in   varchar2 := 'SSN')
        return varchar2 is
        l_rtn               varchar2(20);
        l_output            varchar2(1000)                              := 'Y';
        l_ssn               varchar2(10)                                := null;
        l_last_name         varchar2(50)                                := null;
        ssn_count           number;
        l_numdescription    t_osi_partic_number_type.description%type;
        l_numtypecode       t_osi_partic_number_type.deers_code%type;
        l_numtypecodei2ms   t_osi_partic_number_type.code%type;
        l_numtype_sid       t_osi_partic_number_type.sid%type;
        l_name_sid          t_osi_partic_name.sid%type;
    begin
        begin
            select description, deers_code, code, sid
              into l_numdescription, l_numtypecode, l_numtypecodei2ms, l_numtype_sid
              from t_osi_partic_number_type
             where code = p_numtype;
        exception
            when no_data_found then
                select description, deers_code, code, sid
                  into l_numdescription, l_numtypecode, l_numtypecodei2ms, l_numtype_sid
                  from t_osi_partic_number_type
                 where code = 'SSN';
        end;

        if p_ssn is null then
            v_import_message := 'ERROR No ' || l_numdescription || ' was passed';
            return null;
        end if;

        if p_new = 0 then
            v_person_sid := p_ssn;

            select sid
              into v_pv_sid
              from v_osi_participant_version
             where participant = v_person_sid and sid = current_version;

            select dod_edi_pn_id
              into v_ssn
              from t_osi_participant
             where sid = v_person_sid;

            if v_ssn is not null then
                v_xml := ws_by_dod_edi(v_ssn);
            else
                begin
                    select count(distinct(num_value))
                      into ssn_count
                      from t_osi_partic_number
                     where participant_version = v_pv_sid and num_type = l_numtype_sid;

                    if ssn_count > 1 then
                        l_output :=
                                  'ERROR Participant has more than one ' || l_numdescription || '.';
                        l_ssn := null;
                        v_ssn := null;
                    else
                        select distinct (num_value)
                                   into v_ssn
                                   from t_osi_partic_number
                                  where participant_version = v_pv_sid and num_type = l_numtype_sid;
                    end if;
                exception
                    when no_data_found then
                        l_output := 'ERROR Could not find a ' || l_numdescription;
                        l_ssn := null;
                        v_ssn := null;

                        update t_osi_participant_human
                           set deers_date = sysdate - 153
                         where sid = v_pv_sid;
                end;

                begin
                    select n.last_name
                      into l_last_name
                      from t_osi_partic_name n, t_osi_partic_name_type nt
                     where n.participant_version = v_pv_sid and n.name_type = nt.sid
                           and nt.code = 'L';
                exception
                    when no_data_found then
                        l_output := 'ERROR Could not find a legal name';
                        l_last_name := null;
                end;

                if l_output <> 'Y' then
                    v_import_message := l_output;
                    return null;
                end if;

                v_xml := ws_by_ssn_last_name(v_ssn, l_last_name, 'adr', l_numtypecode);
            end if;

            l_output := is_valid(l_numtypecodei2ms, l_numdescription, v_ssn);

            if l_output = 'Y' then
                v_dod_edi_pn_id := get_value_of_tag('DOD_EDI_PN_ID', 1);
            else
                v_import_message := l_output;
                return null;
            end if;
        else
            v_xml :=
                 ws_by_ssn_last_name(p_ssn, substr(upper(p_last_name), 1, 3), 'adr', l_numtypecode);
            l_output := is_valid(l_numtypecodei2ms, l_numdescription, p_ssn);

            if l_output <> 'Y' then
                v_import_message := l_output;
                return null;
            end if;

            if p_new = 0 then
                begin
                    select n.participant_version
                      into v_pv_sid
                      from t_osi_partic_number n, t_osi_partic_name v
                     where n.num_type = l_numtype_sid
                       and n.num_value = p_ssn
                       and v.last_name like p_last_name || '%'
                       and n.participant_version = v.participant_version;

                    select participant
                      into v_person_sid
                      from t_osi_participant_version
                     where sid = v_pv_sid;

                    if    v_person_sid is null
                       or v_pv_sid is null then
                        core_logger.log_it
                            (c_pipe,
                             '[GET_DEERS_INFORMATION]1336 Could not find table records for Person SID = '
                             || v_person_sid || ' and PersonVersion SID = ' || v_pv_sid);
                        v_import_message := 'ERROR Error getting person records for update';
                        return null;
                    end if;
                exception
                    when no_data_found then
                        core_logger.log_it
                            (c_pipe,
                             '[GET_DEERS_INFORAMTION]1346 Could not find table records for Person SID = '
                             || v_person_sid || ' and PersonVersion SID = ' || v_pv_sid);
                        v_import_message := 'ERROR Error getting person records for update';
                        return null;
                end;
            end if;
        end if;

        remove_old_personnel_rcds;
        v_ssn := get_value_of_tag('PN_ID', 1);

        if v_ssn is null then
            core_logger.log_it
                        (c_pipe,
                         '[GET_DEERS_INFORMATION]1361 Could not get information from DEERS for '
                         || p_numtype || ' = ' || p_ssn);
            v_import_message := 'ERROR Could not get information from DEERS';
            return null;
        elsif p_last_name is not null and v_ssn <> p_ssn then
            core_logger.log_it(c_pipe,
                               '[GET_DEERS_INFORMATION]1365 ' || p_numtype
                               || ' from DEERS did not match entered ' || p_numtype || ' = '
                               || p_ssn);
            v_import_message := 'ERROR Returned a non-matching ' || p_numtype;
            return null;
        end if;

        if p_new <> 0 then
            --- do an initial creation of an unconfirmed participant, if new ---
            -- Confirmation occurs in process_person_information.
            insert into t_core_obj
                        (obj_type)
                 values (v_obj_type)
              returning sid
                   into v_person_sid;

            insert into t_osi_participant
                        (sid)
                 values (v_person_sid);

            insert into t_osi_participant_version
                        (participant)
                 values (v_person_sid)
              returning sid
                   into v_pv_sid;

            insert into t_osi_participant_human
                        (sid)
                 values (v_pv_sid);

            insert into t_osi_person_chars
                        (sid)
                 values (v_pv_sid);

            update t_osi_participant
               set current_version = v_pv_sid
             where sid = v_person_sid;

            delete      t_osi_personnel_recent_objects
                  where obj not in(select sid
                                     from t_osi_participant)
                    and personnel = core_context.personnel_sid();

            insert into t_osi_partic_name
                        (participant_version, name_type, last_name)
                 values (v_pv_sid, (select sid
                                      from t_osi_partic_name_type
                                     where code = 'L'), p_last_name)
              returning sid
                   into l_name_sid;

            update t_osi_participant_version
               set current_name = l_name_sid
             where sid = v_pv_sid;

            insert into t_osi_partic_number
                        (participant_version, num_type, num_value)
                 values (v_pv_sid, l_numtype_sid, p_ssn);

            osi_status.change_status_brute(v_person_sid,
                                           osi_status.get_starting_status(v_obj_type),
                                           'DEERS Created');
            --commit;
            l_output := process_deers_participant(1, l_numtypecodei2ms, l_numdescription);

            if l_output = 'Y' then
                l_rtn := v_pv_sid;
            else
                l_rtn := null;
                v_import_message := l_output;
            end if;
        else
            l_output := process_deers_participant(0, l_numtypecodei2ms, l_numdescription);

            if l_output = 'Y' then
                l_rtn := v_import_sid;
            else
                l_rtn := null;
                v_import_message := l_output;
            end if;
        end if;

        --commit;
        return l_rtn;
    exception
        when others then
            core_logger.log_it(c_pipe,
                               '[GET_DEERS_INFORMATION]1436 Oracle error during processing of '
                               || p_ssn || '/' || sqlerrm);
            v_import_message := 'ERROR Could not process this request';
            return null;
    end get_deers_information;

    function test_get_deers_information(
        p_ssn         in   varchar2,
        p_last_name   in   varchar2,
        p_new         in   integer,
        p_numtype     in   varchar2 := 'SSN')
        return varchar2 is
        l_sid             varchar2(20);
        l_ssn             varchar2(1000);
        l_first_name      varchar2(1000);
        l_middle_name     varchar2(1000);
        l_last_name       varchar2(1000);
        l_cadency         varchar2(1000);
        l_dob             date;
        l_pay_plan        varchar2(1000);
        l_pay_grade       varchar2(1000);
        l_rank            varchar2(1000);
        l_address_1       varchar2(1000);
        l_address_2       varchar2(1000);
        l_city            varchar2(1000);
        l_state           varchar2(1000);
        l_zip             varchar2(1000);
        l_country         varchar2(1000);
        l_ethnicity       varchar2(1000);
        l_eye_color       varchar2(1000);
        l_hair_color      varchar2(1000);
        l_height          varchar2(1000);
        l_weight          varchar2(1000);
        l_race            varchar2(1000);
        l_sex             varchar2(1000);
        l_blood_type      varchar2(1000);
        l_service         varchar2(1000);
        l_affiliation     varchar2(1000);
        l_component       varchar2(1000);
        l_citizenship     varchar2(1000);
        l_birth_state     varchar2(1000);
        l_home            varchar2(1000);
        l_work            varchar2(1000);
        l_email           varchar2(1000);
        l_dod             date;
        l_pay_band        varchar2(1000);
        l_birth_country   varchar2(1000);
        l_temp            varchar2(1000);
        l_photo           v_osi_partic_images.content%type;

        function get_random_name(p_type in varchar2, p_null_ok in varchar2 := 'N')
            return varchar2 is
            l_sql   varchar2(500);
            l_rtn   varchar2(200);
        begin
            if (p_null_ok = 'Y') then
                l_sql :=
                    'select ' || p_type || '
                   from (select ' || p_type
                    || ' from t_osi_partic_name
                          where name_type = (select sid
                                               from t_osi_partic_name_type
                                              where code = ''L'')
                          order by dbms_random.value)
                  where rownum = 1';
            else
                l_sql :=
                    'select ' || p_type || '
                   from (select ' || p_type
                    || ' from t_osi_partic_name
                          where name_type = (select sid
                                               from t_osi_partic_name_type
                                              where code = ''L'')
                           and '
                    || p_type
                    || ' is not null
                          order by dbms_random.value)
                  where rownum = 1';
            end if;

            execute immediate l_sql
                         into l_rtn;

            return l_rtn;
        end get_random_name;

        function get_random_ssn
            return varchar2 is
        begin
            for x in (select ssn
                        from (select   ssn
                                  from v_osi_participant_version
                                 where ssn is not null
                              order by dbms_random.value)
                       where rownum = 1)
            loop
                return x.ssn;
            end loop;

            return null;
        end get_random_ssn;

        function get_random_country
            return varchar2 is
        begin
            for x in (select code
                        from (select   code
                                  from t_dibrs_country
                              order by dbms_random.value)
                       where rownum = 1)
            loop
                return x.code;
            end loop;

            return null;
        end get_random_country;

        function get_random_state
            return varchar2 is
        begin
            for x in (select code
                        from (select   code
                                  from t_dibrs_state
                              order by dbms_random.value)
                       where rownum = 1)
            loop
                return x.code;
            end loop;

            return null;
        end get_random_state;

        function get_random_date(p_year in varchar)
            return date is
            l_seed   number;
            l_rtn    date;
        begin
            select to_number(to_char(to_date('01/01/' || p_year, 'mm/dd/yyyy'), 'J'), '9999999')
              into l_seed
              from dual;

            select to_date(trunc(dbms_random.value(l_seed, l_seed + 364)), 'J')
              into l_rtn
              from dual;

            return l_rtn;
        end get_random_date;

        function get_random_contact(p_type in varchar2)
            return varchar2 is
            l_sql   varchar2(600);
            l_rtn   t_osi_partic_contact.value%type;
        begin
            l_sql :=
                'select value from (select value from t_osi_partic_contact
                      where type = osi_reference.lookup_ref_sid(''CONTACT_TYPE'','''
                || p_type || ''') order by dbms_random.value) where rownum = 1';

            execute immediate l_sql
                         into l_rtn;

            return l_rtn;
        end get_random_contact;

        function get_some_pv_value(p_ssn in varchar2, p_column in varchar2)
            return varchar2 is
            l_sql   varchar2(500);
            l_rtn   varchar2(200);
        begin
            l_sql :=
                'select ' || p_column
                || ' from v_osi_participant_version where ssn = :p_ssn and rownum = 1';

            execute immediate l_sql
                         into l_rtn
                        using p_ssn;

            return l_rtn;
        end get_some_pv_value;

        function get_some_address_value(p_column in varchar2, p_null_ok in varchar2 := 'N')
            return varchar2 is
            l_sql   varchar2(500);
            l_rtn   varchar2(100);
        begin
            if (p_null_ok = 'Y') then
                l_sql :=
                    'select ' || p_column || '
                        from (select ' || p_column
                    || ' from v_osi_partic_address
                              order by dbms_random.value)
                       where rownum = 1';
            else
                l_sql :=
                    'select ' || p_column || '
                        from (select ' || p_column || ' from v_osi_partic_address where '
                    || p_column
                    || ' is not null order by dbms_random.value)
                       where rownum = 1';
            end if;

            execute immediate l_sql
                         into l_rtn;

            return l_rtn;
        end get_some_address_value;

        function get_random_image
            return blob is
        begin
            for x in (select content
                        from (select   content
                                  from v_osi_partic_images
                              order by dbms_random.value)
                       where rownum = 1)
            loop
                return x.content;
            end loop;

            return null;
        end get_random_image;
    begin
        if (p_new = 0) then
            -- p_ssn is the object sid, p_new = 0, everything else is null
            l_ssn := get_random_ssn;
            l_first_name := get_random_name('FIRST_NAME');
            l_middle_name := get_random_name('MIDDLE_NAME');
            l_last_name := get_random_name('LAST_NAME');
            l_dob := get_random_date('1979');
            l_pay_plan := get_some_pv_value(l_ssn, 'SA_PAY_PLAN_CODE');
            l_pay_grade := get_some_pv_value(l_ssn, 'SA_PAY_GRADE_CODE');
            l_rank := get_some_pv_value(l_ssn, 'SA_RANK');
            l_address_1 := get_some_address_value('ADDRESS_1');
            l_address_2 := get_some_address_value('ADDRESS_2');
            l_city := get_some_address_value('CITY');
            l_state := get_some_address_value('STATE_CODE');
            l_zip := get_some_address_value('POSTAL_CODE');
            l_country := get_some_address_value('COUNTRY_CODE');
            l_ethnicity := get_some_pv_value(l_ssn, 'ETHNICITY_CODE');
            l_eye_color := get_some_pv_value(l_ssn, 'EYE_COLOR_CODE');
            l_hair_color := get_some_pv_value(l_ssn, 'HAIR_COLOR_CODE');
            l_height := get_some_pv_value(l_ssn, 'HEIGHT');
            l_weight := get_some_pv_value(l_ssn, 'WEIGHT');
            l_race := get_some_pv_value(l_ssn, 'RACE_CODE');
            l_sex := get_some_pv_value(l_ssn, 'SEX_CODE');
            l_blood_type := get_some_pv_value(l_ssn, 'BLOOD_TYPE_CODE');
            l_service := get_some_pv_value(l_ssn, 'SA_SERVICE_CODE');
            l_affiliation := get_some_pv_value(l_ssn, 'SA_AFFILIATION_CODE');
            l_citizenship := get_random_country;
            l_birth_state := get_random_state;
            l_home := get_random_contact('HOMEP');
            l_work := get_random_contact('OFFP');
            l_email := get_random_contact('EMLP');
            l_dod := get_random_date('2010');
            --l_dod := null;
            l_pay_band := get_some_pv_value(l_ssn, 'SA_PAY_BAND');
            l_birth_country := get_random_country;
            l_photo := get_random_image;

            insert into t_osi_deers_import
                        (dod_edi_pn_id,
                         participant_sid,
                         first_name,
                         middle_name,
                         last_name,
                         birth_date,
                         pay_plan,
                         pay_grade,
                         service_rank,
                         addr_1,
                         addr_2,
                         addr_city,
                         addr_state,
                         addr_zip,
                         addr_country,
                         ethnicity,
                         eye_color,
                         hair_color,
                         height,
                         weight,
                         race,
                         sex,
                         blood_type,
                         sa_service,
                         sa_affiliation,
                         citizenship,
                         birth_state,
                         home,
                         work,
                         email,
                         decease_date,
                         pay_band,
                         birth_country,
                         photo)
                 values ('DEERS-123',
                         p_ssn,
                         l_first_name,
                         l_middle_name,
                         l_last_name,
                         l_dob,
                         l_pay_plan,
                         l_pay_grade,
                         l_rank,
                         l_address_1,
                         l_address_2,
                         l_city,
                         l_state,
                         l_zip,
                         l_country,
                         l_ethnicity,
                         l_eye_color,
                         l_hair_color,
                         l_height,
                         l_weight,
                         l_race,
                         l_sex,
                         l_blood_type,
                         l_service,
                         l_affiliation,
                         l_citizenship,
                         l_birth_state,
                         l_home,
                         l_work,
                         l_email,
                         l_dod,
                         l_pay_band,
                         l_birth_country,
                         l_photo)
              returning sid
                   into l_sid;
        else
            declare
                l_numtype_sid   t_osi_partic_number_type.sid%type;
                l_name_sid      t_osi_partic_name.sid%type;
            begin
                begin
                    select sid
                      into l_numtype_sid
                      from t_osi_partic_number_type
                     where code = p_numtype;
                exception
                    when no_data_found then
                        select sid
                          into l_numtype_sid
                          from t_osi_partic_number_type
                         where code = 'SSN';
                end;

                -- Create the fake DEERS participant.
                l_ssn := get_random_ssn;

                insert into t_core_obj
                            (obj_type)
                     values (v_obj_type)
                  returning sid
                       into v_person_sid;

                insert into t_osi_participant
                            (sid)
                     values (v_person_sid);

                insert into t_osi_participant_version
                            (participant)
                     values (v_person_sid)
                  returning sid
                       into v_pv_sid;

                update t_osi_participant
                   set current_version = v_pv_sid
                 where sid = v_person_sid;

                l_sid := v_pv_sid;
                l_dob := get_random_date('1979');
                l_dod := get_random_date('2010');
                --l_dod := null;
                l_ethnicity := get_some_pv_value(l_ssn, 'ETHNICITY');

                update t_osi_participant
                   set current_version = v_pv_sid,
                       dob = l_dob,
                       dod = l_dod,
                       ethnicity = l_ethnicity,
                       dod_edi_pn_id = 'DEERS_1',
                       confirm_on = sysdate,
                       confirm_by = nvl(core_context.personnel_name(), v_generic_creator)
                 where sid = v_person_sid;

                delete      t_osi_personnel_recent_objects
                      where obj not in(select sid
                                         from t_osi_participant)
                        and personnel = core_context.personnel_sid();

                l_first_name := get_random_name('FIRST_NAME');
                l_middle_name := get_random_name('MIDDLE_NAME');
                l_cadency := get_random_name('CADENCY');

                insert into t_osi_partic_name
                            (participant_version,
                             name_type,
                             last_name,
                             first_name,
                             middle_name,
                             cadency)
                     values (v_pv_sid,
                             (select sid
                                from t_osi_partic_name_type
                               where code = 'L'),
                             p_last_name,
                             l_first_name,
                             l_middle_name,
                             l_cadency)
                  returning sid
                       into l_name_sid;

                update t_osi_participant_version
                   set current_name = l_name_sid
                 where sid = v_pv_sid;

                insert into t_osi_partic_number
                            (participant_version, num_type, num_value)
                     values (v_pv_sid, l_numtype_sid, p_ssn);

                l_affiliation := get_some_pv_value(l_ssn, 'SA_AFFILIATION');
                l_component := get_some_pv_value(l_ssn, 'SA_COMPONENT');
                l_rank := get_some_pv_value(l_ssn, 'SA_RANK');
                l_service := get_some_pv_value(l_ssn, 'SA_SERVICE');

                update t_osi_participant_human
                   set sa_affiliation = l_affiliation,
                       sa_component = l_component,
                       sa_rank = l_rank,
                       sa_service = l_service
                 where sid = v_pv_sid;

                l_sex := get_some_pv_value(l_ssn, 'SEX');
                l_eye_color := get_some_pv_value(l_ssn, 'EYE_COLOR');
                l_hair_color := get_some_pv_value(l_ssn, 'HAIR_COLOR');
                l_blood_type := get_some_pv_value(l_ssn, 'BLOOD_TYPE');
                l_race := get_some_pv_value(l_ssn, 'RACE');
                l_pay_plan := get_some_pv_value(l_ssn, 'SA_PAY_PLAN');
                l_pay_grade := get_some_pv_value(l_ssn, 'SA_PAY_GRADE');
                l_pay_band := get_some_pv_value(l_ssn, 'SA_PAY_BAND');
                l_height := get_some_pv_value(l_ssn, 'HEIGHT');
                l_weight := get_some_pv_value(l_ssn, 'WEIGHT');

                update t_osi_person_chars
                   set sex = l_sex,
                       eye_color = l_eye_color,
                       hair_color = l_hair_color,
                       blood_type = l_blood_type,
                       race = l_race,                   -- will be NULL if DEERS is Other or Unknown
                       sa_pay_plan = l_pay_plan,
                       sa_pay_grade = l_pay_grade,
                       sa_pay_band = l_pay_band,
                       height = l_height,
                       weight = l_weight
                 where sid = v_pv_sid;

                l_home := get_random_contact('HOMEP');

                insert into t_osi_partic_contact
                            (participant_version, type, value)
                     values (v_pv_sid, osi_reference.lookup_ref_sid('CONTACT_TYPE', 'HOMEP'),
                             l_home);

                l_work := get_random_contact('OFFP');

                insert into t_osi_partic_contact
                            (participant_version, type, value)
                     values (v_pv_sid, osi_reference.lookup_ref_sid('CONTACT_TYPE', 'OFFP'), l_work);

                l_email := get_random_contact('EMLP');

                insert into t_osi_partic_contact
                            (participant_version, type, value)
                     values (v_pv_sid, osi_reference.lookup_ref_sid('CONTACT_TYPE', 'EMLP'),
                             l_email);

                l_address_1 := get_some_address_value('ADDRESS_1');
                l_address_2 := get_some_address_value('ADDRESS_2');
                l_city := get_some_address_value('CITY');
                l_state := get_some_address_value('STATE');
                l_zip := get_some_address_value('POSTAL_CODE');
                l_country := get_some_address_value('COUNTRY');

                insert into t_osi_address
                            (obj,
                             address_type,
                             address_1,
                             address_2,
                             city,
                             state,
                             postal_code,
                             country)
                     values (v_person_sid,
                             osi_address.get_addr_type(v_obj_type, 'ADDR_LIST', 'MAIL'),
                             l_address_1,
                             l_address_2,
                             l_city,
                             l_state,
                             l_zip,
                             l_country)
                  returning sid
                       into l_temp;

                insert into t_osi_partic_address
                            (participant_version, address)
                     values (v_pv_sid, l_temp)
                  returning sid
                       into l_temp;

                update t_osi_participant_version
                   set current_address = l_temp
                 where sid = v_pv_sid;

                l_photo := get_random_image;

                insert into t_osi_attachment
                            (obj, description, type, storage_loc_type, source, content, lock_mode)
                     values (v_person_sid,
                             'DEERS Photo imported:  ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS'),
                             (select sid
                                from t_osi_attachment_type
                               where obj_type = v_obj_type and usage = 'MUGSHOT' and code = 'MUG'),
                             'DB',
                             'DEERS',
                             l_photo,
                             'LOCKED');

                l_citizenship := get_some_address_value('COUNTRY', 'N');

                insert into t_osi_partic_citizenship
                            (participant_version, country)
                     values (v_pv_sid, l_citizenship);

                osi_status.change_status_brute(v_person_sid,
                                               osi_status.get_starting_status(v_obj_type),
                                               'DEERS Created');

                select sid
                  into l_temp
                  from t_osi_status
                 where code = 'CONFIRM';

                osi_status.change_status_brute(v_person_sid, l_temp, 'DEERS Confirmed');
            end;
        end if;

        return l_sid;
    exception
        when others then
            v_import_message := 'ERROR in test_get_deers_information: ' || sqlerrm;
            return null;
    end test_get_deers_information;

    function get_import_message
        return varchar2 is
    begin
        return v_import_message;
    end get_import_message;

    function show_update_link_button(p_obj in varchar2)
        return varchar2 is
        l_cmplt   number;
        l_msg     varchar2(4000);
    begin
        osi_checklist.current_pv_links(p_obj, l_cmplt, l_msg);

        if l_cmplt = 0 then
            return null;
        else
            return 'N';
        end if;
    end show_update_link_button;

    /*
        This procedure is used at the very last when the user selects to update the current
        participant with the selected DEERS data.  The data from the temp table is then
        transferred to appropriate fields in the Person tables.
     */
    function update_person_with_deers(p_deers_sid in varchar2, p_participant in varchar2)
        return varchar2 is
        l_current_first            varchar2(100);
        l_current_middle           varchar2(100);
        l_current_last             varchar2(100);
        l_current_version          varchar2(25);
        l_current_cadency          varchar2(50);
        l_current_dob              date;
        l_current_pay_plan         varchar2(50);
        l_current_pay_grd          varchar2(50);
        l_current_pay_band         varchar2(50);
        l_current_rank             varchar2(50);
        l_current_addr1            varchar2(150);
        l_current_addr2            varchar2(150);
        l_current_city             varchar2(50);
        l_current_state            varchar2(50);
        l_current_province         varchar2(20);
        l_current_zip              varchar2(30);
        l_current_cntry            varchar2(200);
        l_name_sid                 varchar2(25);
        l_addr_sid                 varchar2(25);
        l_first_name               varchar2(100);
        l_last_name                varchar2(100);
        l_middle_name              varchar2(100);
        l_cadency                  varchar2(50);
        l_title                    varchar2(50);
        l_temp_str                 varchar2(4000);
        l_new_version              boolean        := true;
        l_current_ethnicity        varchar2(50);
        l_current_decease_date     date;
        l_current_eye_color        varchar2(50);
        l_current_hair_color       varchar2(50);
        l_current_height           number;
        l_current_weight           number;
        l_current_race             varchar2(10);
        l_current_sex              varchar2(50);
        l_current_blood_type       varchar2(50);
        l_current_sa_service       varchar2(50);
        l_current_sa_affiliation   varchar2(50);
        l_current_home             varchar2(100);
        l_current_work             varchar2(100);
        l_current_email            varchar2(100);
        l_current_citizenship      varchar2(10);
        l_current_birth_state      varchar2(2);
        l_current_birth_country    varchar2(2);
        result                     number         := null;
        l_rtn                      varchar2(20);
        v_person_chars_count       number;        
    begin
         log_error('>>>update_person_with_deers(' || p_deers_sid || ',' || p_participant || ') Start ' || sysdate);                

         v_person_sid := p_participant;

        for y in (select upper(n.first_name) as first_name, upper(n.middle_name) as middle_name,
                         upper(n.last_name) as last_name, upper(n.cadency) as cadency
                    from v_osi_participant_version v, v_osi_partic_name n
                   where v.participant = p_participant
                     and v.sid = v.current_version
                     and n.participant_version = v.sid
                     and n.type_code = 'L')
        loop
            l_current_first := y.first_name;
            l_current_middle := y.middle_name;
            l_current_last := y.last_name;
            l_current_cadency := y.cadency;
            exit;
        end loop;

        for x in (select to_date(to_char(p.dob, 'mm/dd/yyyy'), 'mm/dd/yyyy') as dob, r.code,
                         to_date(to_char(p.dod, 'mm/dd/yyyy'), 'mm/dd/yyyy') as dod
                    from t_osi_participant p, t_dibrs_reference r
                   where p.sid = p_participant and p.ethnicity(+) = r.sid and r.usage = 'ETHNICITY')
        loop
            l_current_dob := x.dob;
            l_current_ethnicity := x.code;
            l_current_decease_date := x.dod;
        end loop;

        for x in (select sid, sa_pay_plan_code as pp, sa_pay_grade_code as pg, sa_rank as rank,
                         sa_pay_band_code as pb, eye_color_code as ec, hair_color_code as hc,
                         height, weight, race_code as race, sex_code as sex, blood_type_code as bt,
                         sa_service_code as sc, sa_affiliation_code as ac
                    from v_osi_participant_version
                   where participant = p_participant and sid = current_version)
        loop
            l_current_version := x.sid;
            l_current_pay_plan := x.pp;
            l_current_pay_grd := x.pg;
            l_current_rank := x.rank;
            l_current_pay_band := x.pb;
            l_current_eye_color := x.ec;
            l_current_hair_color := x.hc;
            l_current_height := x.height;
            l_current_weight := x.weight;
            l_current_race := x.race;
            l_current_sex := x.race;
            l_current_blood_type := x.bt;
            l_current_sa_service := x.sc;
            l_current_sa_affiliation := x.ac;
        end loop;

        v_pv_sid := l_current_version;

        begin
            select pc.value
              into l_current_email
              from t_osi_partic_contact pc, t_osi_reference r
             where pc.participant_version = l_current_version
               and pc.type = r.sid
               and r.usage = 'CONTACT_TYPE'
               and r.code = 'EMLP'
               and rownum = 1;
        exception
            when no_data_found then
                l_current_email := null;
        end;

        begin
            select pc.value
              into l_current_home
              from t_osi_partic_contact pc, t_osi_reference r
             where pc.participant_version = l_current_version
               and pc.type = r.sid
               and r.usage = 'CONTACT_TYPE'
               and r.code = 'HOMEP'
               and rownum = 1;
        exception
            when no_data_found then
                l_current_home := null;
        end;

        begin
            select pc.value
              into l_current_work
              from t_osi_partic_contact pc, t_osi_reference r
             where pc.participant_version = l_current_version
               and pc.type = r.sid
               and r.usage = 'CONTACT_TYPE'
               and r.code = 'OFFP'
               and rownum = 1;
        exception
            when no_data_found then
                l_current_work := null;
        end;

        for w in (select address_1, address_2, city, state_code, province, postal_code,
                         country_code, sid
                    from v_osi_partic_address
                   where participant_version = v_pv_sid and type_code = 'MAIL')
        loop
            l_current_addr1 := w.address_1;
            l_current_addr2 := w.address_2;
            l_current_city := w.city;
            l_current_state := w.state_code;
            l_current_province := w.province;
            l_current_zip := w.postal_code;
            l_current_cntry := w.country_code;
            l_addr_sid := w.sid;
            exit;
        end loop;

        for i in (select *
                    from t_osi_deers_import
                   where sid = p_deers_sid)
        loop
            result := -1;

            ---- if name info is different, then create a new version ----
            if     (   upper(i.first_name) = l_current_first
                    or i.first_name is null)
               and (   upper(i.middle_name) = l_current_middle
                    or i.middle_name is null)
               and (   upper(i.last_name) = l_current_last
                    or i.last_name is null)
               and (   i.cadency = l_current_cadency
                    or i.cadency is null)
               and (   to_char(i.birth_date, 'mm/dd/yyyy') = to_char(l_current_dob, 'mm/dd/yyyy')
                    or i.birth_date is null)
               and (   i.pay_plan = l_current_pay_plan
                    or i.pay_plan is null)
               and (   i.pay_grade = l_current_pay_grd
                    or i.pay_grade is null)
               and (   i.pay_band = l_current_pay_band
                    or i.pay_band is null)
               and (   i.service_rank = l_current_rank
                    or i.service_rank is null)
               and (   i.addr_1 = l_current_addr1
                    or i.addr_1 is null)
               and (   i.addr_2 = l_current_addr2
                    or i.addr_2 is null)
               and (   i.addr_city = l_current_city
                    or i.addr_city is null)
               and (   i.addr_state = l_current_state
                    or i.addr_state is null)
               and (   i.addr_zip = l_current_zip
                    or i.addr_zip is null)
               and (   i.addr_country = l_current_cntry
                    or i.addr_country is null)
               and (   i.ethnicity = l_current_ethnicity
                    or i.ethnicity is null)
               and (   i.eye_color = l_current_eye_color
                    or i.eye_color is null)
               and (   i.hair_color = l_current_hair_color
                    or i.hair_color is null)
               and (   i.height = l_current_height
                    or i.height is null)
               and (   i.weight = l_current_weight
                    or i.weight is null)
               and (   i.race = l_current_race
                    or i.race is null)
               and (   i.sex = l_current_sex
                    or i.sex is null)
               and (   i.blood_type = l_current_blood_type
                    or i.blood_type is null)
               and (   i.sa_service = l_current_sa_service
                    or i.sa_service is null)
               and (   i.sa_affiliation = l_current_sa_affiliation
                    or i.sa_affiliation is null)
               and (   i.citizenship = l_current_citizenship
                    or i.citizenship is null)
               and (   i.birth_state = l_current_birth_state
                    or i.birth_state is null)
               and (   i.birth_country = l_current_birth_country
                    or i.birth_country is null)
               and (   i.home = l_current_home
                    or i.home is null)
               and (   i.work = l_current_work
                    or i.work is null)
               and (   i.email = l_current_email
                    or i.email is null)
               and (   i.decease_date = l_current_decease_date
                    or i.decease_date is null) then
                update t_osi_participant_human
                   set deers_date = sysdate
                 where sid = v_pv_sid;

                l_rtn := null;
            else
                -- with any change, create a new version
                l_current_version := v_pv_sid;

                update t_osi_participant
                   set dob = nvl(i.birth_date, dob)
                 where sid = v_person_sid;

                insert into t_osi_participant_version
                            (participant)
                     values (v_person_sid)
                  returning sid
                       into v_pv_sid;

                l_rtn := v_pv_sid;

                insert into t_osi_participant_human
                            (sid,
                             age_low,
                             age_high,
                             build,
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
                    select v_pv_sid, age_low, age_high, build, posture, writing_hand, religion,
                           religion_involvement, clearance, sa_service, sa_affiliation,
                           sa_component, nvl(i.service_rank, sa_rank), sa_rank_date,
                           sa_specialty_code, sa_reservist, sa_reservist_status, sa_reservist_type,
                           fsa_service, fsa_rank, fsa_equiv_rank, fsa_rank_date, suspected_io,
                           known_io, is_bald, bald_comment, is_hard_of_hearing, hearing_comment,
                           has_facial_hair, facial_hair_comment, wears_glasses, glasses_comment,
                           has_teeth, teeth_comment, sysdate
                      from t_osi_participant_human
                     where sid = l_current_version;

                --- Just incase it is a participant that was Synced from Local Mode, before Local Mode Sync was Fixed ---
                --- Make sure there is a current record in t_osi_person_chars for this participant, so the update     ---
                --- following it will work...............                                                             ---
                select count(*) into v_person_chars_count from t_osi_person_chars where sid=l_current_version;
                if v_person_chars_count = 0 then
 
                  insert into t_osi_person_chars(sid) values (l_current_version);
                  commit;

                end if;                     
                     
                insert into t_osi_person_chars
                            (sid,
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
                    select v_pv_sid, sex, eye_color, hair_color, blood_type, race,
                           decode(i.pay_plan, null, sa_pay_plan, (select sid
                                                                    from t_dibrs_reference
                                                                   where code = i.pay_plan)),
                           decode(i.pay_grade, null, sa_pay_grade, (select sid
                                                                      from t_dibrs_pay_grade_type
                                                                     where code = i.pay_grade)),
                           decode(i.pay_band, null, sa_pay_band, (select sid
                                                                    from t_dibrs_pay_band_type
                                                                   where code = i.pay_band)),
                           height, weight, education_level
                      from t_osi_person_chars
                     where sid = l_current_version;

                update t_osi_participant
                   set current_version = v_pv_sid
                 where sid = v_person_sid;

                for y in (select last_name, first_name, middle_name, cadency, title
                            from v_osi_partic_name
                           where participant_version = l_current_version and type_code = 'L')
                loop
                    l_last_name := y.last_name;
                    l_first_name := y.first_name;
                    l_middle_name := y.middle_name;
                    l_cadency := y.cadency;
                    l_title := y.title;
                    exit;
                end loop;

                --- If Name is not going to be updated, then just copy over the current ones ---
                if     (i.first_name is null)
                   and (i.middle_name is null)
                   and (i.last_name is null)
                   and (i.cadency is null) then
                    insert into t_osi_partic_name
                                (participant_version,
                                 name_type,
                                 last_name,
                                 first_name,
                                 middle_name,
                                 cadency,
                                 title)
                        select v_pv_sid, name_type, last_name, first_name, middle_name, cadency,
                               title
                          from v_osi_partic_name
                         where participant_version = l_current_version and type_code not in('L');

                    for x in (select name_type, last_name, first_name, middle_name, cadency, title
                                from v_osi_partic_name
                               where participant_version = l_current_version and type_code in('L'))
                    loop
                        insert into t_osi_partic_name
                                    (participant_version,
                                     name_type,
                                     last_name,
                                     first_name,
                                     middle_name,
                                     cadency,
                                     title)
                             values (v_pv_sid,
                                     x.name_type,
                                     x.last_name,
                                     x.first_name,
                                     x.middle_name,
                                     x.cadency,
                                     x.title)
                          returning sid
                               into l_name_sid;
                    end loop;
                else
                    --- If Name going to be updated, then copy over the current ones, changing   ---
                    --- the current Legal 'L' name to Unknown 'U', then insert the new Legal one ---
                    insert into t_osi_partic_name
                                (participant_version,
                                 name_type,
                                 last_name,
                                 first_name,
                                 middle_name,
                                 cadency,
                                 title)
                        select v_pv_sid,
                               decode(type_code, 'L', (select sid
                                                         from t_osi_partic_name_type
                                                        where code = 'U'), name_type), last_name,
                               first_name, middle_name, cadency, title
                          from v_osi_partic_name
                         where participant_version = l_current_version;

                    insert into t_osi_partic_name
                                (participant_version,
                                 name_type,
                                 last_name,
                                 first_name,
                                 middle_name,
                                 cadency,
                                 title)
                         values (v_pv_sid,
                                 (select sid
                                    from t_osi_partic_name_type
                                   where code = 'L'),
                                 nvl(i.last_name, l_last_name),
                                 nvl(i.first_name, l_first_name),
                                 nvl(i.middle_name, l_middle_name),
                                 nvl(i.cadency, l_cadency),
                                 l_title)
                      returning sid
                           into l_name_sid;

                end if;

                update t_osi_participant_version
                   set current_name = l_name_sid
                 where sid = v_pv_sid;

                l_temp_str := formalize_name(v_pv_sid);

                --commit;

                --- If we are updating the Address with DIBRS, make sure we don't copy the selected 'MAIL' address ---
                if    i.addr_1 is not null
                   or i.addr_2 is not null
                   or i.addr_city is not null
                   or i.addr_state is not null
                   or i.addr_zip is not null
                   or i.addr_country is not null then
                    for x in (select a.address_type, a.address_1, a.address_2, a.city, a.state,
                                     a.province, a.postal_code, a.country, a.start_date,
                                     a.end_date, a.known_date, a.comments, a.geo_coords
                                from t_osi_partic_address pa, t_osi_address a, t_osi_addr_type at
                               where pa.participant_version = l_current_version
                                 and pa.address = a.sid
                                 and a.address_type = at.sid
                                 and at.code <> 'MAIL'
                                 and at.obj_type = v_obj_type
                                 and pa.sid not in(select current_address
                                                     from t_osi_participant_version
                                                    where sid = l_current_version))
                    loop
                        insert into t_osi_address
                                    (obj,
                                     address_type,
                                     address_1,
                                     address_2,
                                     city,
                                     state,
                                     province,
                                     postal_code,
                                     country,
                                     start_date,
                                     end_date,
                                     known_date,
                                     comments,
                                     geo_coords)
                             values (v_person_sid,
                                     x.address_type,
                                     x.address_1,
                                     x.address_2,
                                     x.city,
                                     x.state,
                                     x.province,
                                     x.postal_code,
                                     x.country,
                                     x.start_date,
                                     x.end_date,
                                     x.known_date,
                                     x.comments,
                                     x.geo_coords)
                          returning sid
                               into l_addr_sid;

                        insert into t_osi_partic_address
                                    (participant_version, address)
                             values (v_pv_sid, l_addr_sid);
                    end loop;
                --- If we are NOT updating the Address with DIBRS, make sure we copy ALL addresses ---
                else
                    for x in (select a.address_type, a.address_1, a.address_2, a.city, a.state,
                                     a.province, a.postal_code, a.country, a.start_date,
                                     a.end_date, a.known_date, a.comments, a.geo_coords
                                from t_osi_partic_address pa, t_osi_address a, t_osi_addr_type at
                               where pa.participant_version = l_current_version
                                 and pa.address = a.sid
                                 and a.address_type = at.sid
                                 and at.obj_type = v_obj_type)
                    loop
                        insert into t_osi_address
                                    (obj,
                                     address_type,
                                     address_1,
                                     address_2,
                                     city,
                                     state,
                                     province,
                                     postal_code,
                                     country,
                                     start_date,
                                     end_date,
                                     known_date,
                                     comments,
                                     geo_coords)
                             values (v_person_sid,
                                     x.address_type,
                                     x.address_1,
                                     x.address_2,
                                     x.city,
                                     x.state,
                                     x.province,
                                     x.postal_code,
                                     x.country,
                                     x.start_date,
                                     x.end_date,
                                     x.known_date,
                                     x.comments,
                                     x.geo_coords)
                          returning sid
                               into l_addr_sid;

                        insert into t_osi_partic_address
                                    (participant_version, address)
                             values (v_pv_sid, l_addr_sid);
                    end loop;
                end if;

                --- Copy the DIBRS address into I2MS as current Selected 'MAIL' Address ---
                if    i.addr_1 is not null
                   or i.addr_2 is not null
                   or i.addr_city is not null
                   or i.addr_state is not null
                   or i.addr_zip is not null
                   or i.addr_country is not null then
                    begin
                        select sid
                          into l_current_state
                          from t_dibrs_state
                         where code = upper(i.addr_state);

                        l_current_province := null;
                    exception
                        when no_data_found then
                            l_current_state := null;
                            l_current_province := upper(i.addr_state);
                    end;

                    begin
                        select sid
                          into l_current_cntry
                          from t_dibrs_country
                         where code = upper(i.addr_country);
                    exception
                        when no_data_found then
                            l_current_cntry := null;
                    end;

                    insert into t_osi_address
                                (obj,
                                 address_type,
                                 address_1,
                                 address_2,
                                 city,
                                 state,
                                 postal_code,
                                 country,
                                 province,
                                 comments)
                         values (v_person_sid,
                                 (select sid
                                    from t_osi_addr_type
                                   where code = 'MAIL' and obj_type = v_obj_type),
                                 i.addr_1,
                                 i.addr_2,
                                 i.addr_city,
                                 l_current_state,
                                 i.addr_zip,
                                 l_current_cntry,
                                 l_current_province,
                                 'Created by DEERS query')
                      returning sid
                           into l_addr_sid;

                    insert into t_osi_partic_address
                                (participant_version, address)
                         values (v_pv_sid, l_addr_sid)
                      returning sid
                           into l_addr_sid;

                    update t_osi_participant_version
                       set current_address = l_addr_sid
                     where sid = v_pv_sid;
                end if;

                ---- Check for Birth State and Birth Country ----
                if    i.birth_state is not null
                   or i.birth_country is not null then
                    begin
                        select a.sid
                          into l_temp_str
                          from t_osi_partic_address pa, t_osi_address a, t_osi_addr_type at
                         where pa.participant_version = v_pv_sid
                           and pa.address = a.sid
                           and a.address_type = at.sid
                           and at.code = 'BIRTH';
                    exception
                        when no_data_found then
                            l_temp_str := null;
                    end;

                    if l_temp_str is null then
                        insert into t_osi_address
                                    (obj, address_type, state, country)
                             values (v_person_sid,
                                     (select sid
                                        from t_osi_addr_type
                                       where code = 'BIRTH' and obj_type = v_obj_type),
                                     (select sid
                                        from t_dibrs_state
                                       where code = i.birth_state),
                                     (select sid
                                        from t_dibrs_country
                                       where code = i.birth_country))
                          returning sid
                               into l_addr_sid;

                        insert into t_osi_partic_address
                                    (participant_version, address)
                             values (v_pv_sid, l_addr_sid);
                    else
                        update t_osi_address
                           set state =
                                     decode(i.birth_state,
                                            null, state,
                                            (select sid
                                               from t_dibrs_state
                                              where code = i.birth_state)),
                               country =
                                   decode(i.birth_country,
                                          null, country,
                                          (select sid
                                             from t_dibrs_country
                                            where code = i.birth_country))
                         where sid = l_temp_str;
                    end if;
                end if;

                ---- Copy Other T_PERSON Fields ----
                if i.ethnicity is not null then
                    update t_osi_participant
                       set ethnicity = dibrs_reference.lookup_ref_sid('ETHNICITY', i.ethnicity)
                     where sid = v_person_sid;
                end if;

                if i.decease_date is not null then
                    update t_osi_participant
                       set dod = i.decease_date
                     where sid = v_person_sid;
                end if;

--------------------------------------------

                ---- Copy Other T_PERSON_VERSION Fields ----
                if i.eye_color is not null then
                    update t_osi_person_chars
                       set eye_color = osi_reference.lookup_ref_sid('PERSON_EYE_COLOR', i.eye_color)
                     where sid = v_pv_sid;
                end if;

                if i.hair_color is not null then
                    update t_osi_person_chars
                       set hair_color =
                                     osi_reference.lookup_ref_sid('PERSON_HAIR_COLOR', i.hair_color)
                     where sid = v_pv_sid;
                end if;

                if i.height is not null then
                    update t_osi_person_chars
                       set height = i.height
                     where sid = v_pv_sid;
                end if;

                if i.weight is not null then
                    update t_osi_person_chars
                       set weight = i.weight
                     where sid = v_pv_sid;
                end if;

                if i.race is not null then
                    update t_osi_person_chars
                       set race = (select sid
                                     from t_dibrs_race_type
                                    where code = i.race)
                     where sid = v_pv_sid;
                end if;

                if i.sex is not null then
                    update t_osi_person_chars
                       set sex = dibrs_reference.lookup_ref_sid('SEX', i.sex)
                     where sid = v_pv_sid;
                end if;

                if i.blood_type is not null then
                    update t_osi_person_chars
                       set blood_type =
                                     osi_reference.lookup_ref_sid('PERSON_BLOOD_TYPE', i.blood_type)
                     where sid = v_pv_sid;
                end if;

                if i.sa_service is not null then
                    update t_osi_participant_human
                       set sa_service = dibrs_reference.lookup_ref_sid('SERVICE_TYPE', i.sa_service)
                     where sid = v_pv_sid;
                end if;

                if i.sa_affiliation is not null then
                    update t_osi_participant_human
                       set sa_affiliation =
                                 osi_reference.lookup_ref_sid('INDIV_AFFILIATION', i.sa_affiliation)
                     where sid = v_pv_sid;
                end if;

--------------------------------------------
                insert into t_osi_partic_citizenship
                            (participant_version, country, effective_date)
                    select v_pv_sid, country, effective_date
                      from t_osi_partic_citizenship
                     where participant_version = l_current_version;

                if i.citizenship is not null then
                    insert into t_osi_partic_citizenship
                                (participant_version, country)
                         values (v_pv_sid, (select sid
                                              from t_dibrs_country
                                             where code = i.citizenship));
                end if;

                insert into t_osi_partic_mark
                            (participant_version, mark_type, mark_location, description)
                    select v_pv_sid, mark_type, mark_location, description
                      from t_osi_partic_mark
                     where participant_version = l_current_version;

                insert into t_osi_partic_number
                            (participant_version,
                             num_type,
                             num_value,
                             issue_date,
                             issue_country,
                             issue_state,
                             issue_province,
                             expire_date,
                             note)
                    select v_pv_sid, num_type, num_value, issue_date, issue_country, issue_state,
                           issue_province, expire_date, note
                      from t_osi_partic_number
                     where participant_version = l_current_version;

                insert into t_osi_partic_contact
                            (participant_version, type, value)
                    select v_pv_sid, type, value
                      from t_osi_partic_contact
                     where participant_version = l_current_version;

                if i.home is not null then
                    if l_current_home is null then
                        insert into t_osi_partic_contact
                                    (participant_version, type, value)
                             values (v_pv_sid,
                                     osi_reference.lookup_ref_sid('CONTACT_TYPE', 'HOMEP'),
                                     i.home);
                    else
                        update t_osi_partic_contact
                           set value = i.home
                         where participant_version = v_pv_sid
                           and type = osi_reference.lookup_ref_sid('CONTACT_TYPE', 'HOMEP')
                           and value = l_current_home;
                    end if;
                end if;

                if i.work is not null then
                    if l_current_work is null then
                        insert into t_osi_partic_contact
                                    (participant_version, type, value)
                             values (v_pv_sid,
                                     osi_reference.lookup_ref_sid('CONTACT_TYPE', 'OFFP'),
                                     i.work);
                    else
                        update t_osi_partic_contact
                           set value = i.work
                         where participant_version = v_pv_sid
                           and type = osi_reference.lookup_ref_sid('CONTACT_TYPE', 'OFFP')
                           and value = l_current_work;
                    end if;
                end if;

                if i.email is not null then
                    if l_current_email is null then
                        insert into t_osi_partic_contact
                                    (participant_version, type, value)
                             values (v_pv_sid,
                                     osi_reference.lookup_ref_sid('CONTACT_TYPE', 'EMLP'),
                                     i.email);
                    else
                        update t_osi_partic_contact
                           set value = i.email
                         where participant_version = v_pv_sid
                           and type = osi_reference.lookup_ref_sid('CONTACT_TYPE', 'EMLP')
                           and value = l_current_email;
                    end if;
                end if;

                insert into t_osi_partic_vehicle
                            (participant_version,
                             plate_num,
                             reg_exp_date,
                             reg_country,
                             reg_state,
                             reg_province,
                             title_owner,
                             vin,
                             make,
                             model,
                             year,
                             color,
                             body_type,
                             gross_weight,
                             num_axles,
                             role,
                             comments)
                    select v_pv_sid, plate_num, reg_exp_date, reg_country, reg_state, reg_province,
                           title_owner, vin, make, model, year, color, body_type, gross_weight,
                           num_axles, role, comments
                      from t_osi_partic_vehicle
                     where participant_version = l_current_version;

                insert into t_osi_partic_date
                            (participant_version, type, value, comments)
                    select v_pv_sid, type, value, comments
                      from t_osi_partic_date
                     where participant_version = l_current_version;
            end if;

            --- Update Photo ---
            if i.photo is not null and result is not null then
                begin
                    select dbms_lob.compare(content, photo)
                      into result
                      from (select   a.content, d.photo
                                from t_osi_attachment a, t_osi_deers_import d
                               where a.source = 'DEERS'
                                 and a.obj = p_participant
                                 and a.obj = d.participant_sid(+)
                            order by a.create_on desc)
                     where rownum = 1;
                exception
                    when no_data_found then
                        result := null;
                end;

                --- Result is 0 if the BLOB is Unchanged ---
                if    result is null
                   or result != 0 then
                    insert into t_osi_attachment
                                (obj,
                                 obj_context,
                                 type,
                                 description,
                                 storage_loc_type,
                                 source,
                                 content)
                         values (v_person_sid,
                                 'PARTICIPANT:  Photo Imported from DEERS',
                                 (select sid
                                    from t_osi_attachment_type
                                   where obj_type = v_obj_type and usage = 'MUGSHOT'
                                         and code = 'MUG'),
                                 'DEERS Photo imported:  '
                                 || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS'),
                                 'DB',
                                 'DEERS',
                                 i.photo);

                  if l_rtn is null then

                    l_rtn := 'No new Version.';

                  end if;

                end if;
                
            end if;
        end loop;

        delete from t_osi_deers_import
              where sid = p_deers_sid;

        log_error('>>>update_person_with_deers(' || p_deers_sid || ',' || p_participant || ') End ' || sysdate || ', return=' || l_rtn);                
        return l_rtn;
    exception
        when others then
            core_logger.log_it
                    (c_pipe,
                     '[UPDATE_PERSON_WITH_DEERS]1960 Oracle error encountered when updating an '
                     || 'existing participant with user selected DEERS data: ' || sqlerrm);

            delete from t_osi_deers_import
                  where sid = p_deers_sid;

            raise;
    end update_person_with_deers;

    /*
        When new versions are generated, need to link associated activities to the new version.
        CR#2242 Not all participant links are being updated because of the many ways dates are
        checked. Remove date checks from this proceedure.
        CR#2465 File Specification is not updated to the new version. of a participant.
     */
    procedure update_pv_links(
        p_old_pv   in   varchar2,
        p_new_pv   in   varchar2,
        p_act      in   varchar2,
        p_file     in   boolean) is
    begin
        if p_file then
            update t_osi_partic_involvement
               set participant_version = p_new_pv
             where participant_version = p_old_pv and obj = p_act;

            update t_osi_f_inv_spec
               set subject = p_new_pv
             where subject = p_old_pv and investigation = p_act;

            update t_osi_f_inv_spec
               set victim = p_new_pv
             where victim = p_old_pv and investigation = p_act;

            update t_osi_f_inv_subj_disposition
               set subject = p_new_pv
             where subject = p_old_pv and investigation = p_act;
        else
            update t_osi_partic_involvement
               set participant_version = p_new_pv
             where participant_version = p_old_pv and obj = p_act;

            for y in (select g.sid
                        from t_osi_a_gi_involvement g, t_osi_activity a
                       where g.gi = p_act and g.participant_version = p_old_pv and g.gi = a.sid)
            loop
                update t_osi_a_gi_involvement
                   set participant_version = p_new_pv
                 where sid = y.sid;
            end loop;

            for z in (select sid, ousa_agency
                        from t_osi_a_compint_source
                       where compint = p_act
                         and (   ousa_agency = p_old_pv
                              or one_time_source = p_old_pv))
            loop
                if z.ousa_agency is null then
                    update t_osi_a_compint_source
                       set one_time_source = p_new_pv
                     where sid = z.sid;
                else
                    update t_osi_a_compint_source
                       set ousa_agency = p_new_pv
                     where sid = z.sid;
                end if;
            end loop;

            for w in (select t.sid
                        from t_osi_a_suspact_source t, t_osi_activity a
                       where t.suspact = p_act and t.one_time_source = p_old_pv
                             and t.suspact = a.sid)
            loop
                update t_osi_a_suspact_source
                   set one_time_source = p_new_pv
                 where sid = w.sid;
            end loop;
        end if;
    end update_pv_links;

    /*
        This is called from the status change code when the "Update Participant Links" link is
        clicked in the case object. Returns NULL if everything is okay otherwise an error message.
     */
    function update_all_pv_links(p_obj in varchar2)
        return varchar2 is
        l_yr_ago   date         := sysdate - 365;
        l_pv_sid   varchar2(50) := null;
    begin
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

                if l_pv_sid <> j.participant_version and l_pv_sid is not null then
                    update_pv_links(j.participant_version, l_pv_sid, i.activity_sid, false);
                end if;
            end loop;
        end loop;

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

            if l_pv_sid <> m.participant_version and l_pv_sid is not null then
                update_pv_links(m.participant_version, l_pv_sid, p_obj, true);
            end if;
        end loop;

        return null;
    exception
        when others then
            core_logger.log_it
                     (c_pipe,
                      '[ADD_NAME_TO_MESSAGE]2102 An error has occurred in UPDATE_ALL_PV_LINKS: '
                      || sqlerrm);
            return 'An error has occurred: ' || sqlerrm;
    end update_all_pv_links;

    function DEERS_COMPARE (p_sid in Varchar2, p_shown out Varchar2, p_uncheckedItems out Varchar2) return clob is
    
        v_rtn           varchar2(4000);
        v_i2ms_columns  varchar2(4000);
        v_deers_columns varchar2(4000);
        v_column_count  number;
        v_temp1         varchar2(4000);
        v_temp2         varchar2(4000);
         
        CURSOR myColumns is select I2MS_COLUMN,DEERS_COLUMN,LABEL from t_osi_deers_compare_columns order by seq;
    
        TYPE the_i2ms_columns IS TABLE OF t_osi_deers_compare_columns.I2MS_COLUMN%TYPE INDEX BY PLS_INTEGER;
        i2ms_columns the_i2ms_columns;

        TYPE the_deers_columns IS TABLE OF t_osi_deers_compare_columns.DEERS_COLUMN%TYPE INDEX BY PLS_INTEGER;
        deers_columns the_deers_columns;

        TYPE the_labels IS TABLE OF t_osi_deers_compare_columns.LABEL%TYPE INDEX BY PLS_INTEGER;
        labels the_labels;

        l_columnValue1 varchar2(4000);
        l_columnValue2 varchar2(4000);
        l_BLOBValue1   blob;
        l_BLOBValue2   blob;
        l_status       integer;
        l_colCnt       number default 0;
        l_cnt          number default 0;
        l_line         clob;--long;
        l_currCol      number default 1;
        l_descTbl      dbms_sql.desc_tab;
        l_theCursor    integer default dbms_sql.open_cursor;
    
        vCRLF varchar2(2) :=  chr(10) || chr(13);

        l_rowCount     number default 1;
        
        l_i2msTable    clob;
        l_deersTable   clob;
                
    begin
         p_uncheckedItems := '~';
     
         v_column_count := 1;
         for c in myColumns
         loop
             i2ms_columns(v_column_count) := c.i2ms_column;
             deers_columns(v_column_count) := c.deers_column;
             labels(v_column_count) := c.label;
             v_column_count := v_column_count + 1;
         
         end loop;

         v_temp1 := 'select '; 
         for cnt in 1 .. i2ms_columns.count -- - 1
         loop
             v_temp1 := v_temp1 || i2ms_columns(cnt) || ',' || deers_columns(cnt) || ',';

         end loop;

         if substr(v_temp1,length(v_temp1),1) = ',' then
       
           v_temp1 := substr(v_temp1,1,length(v_temp1)-1);
       
         end if;
          
         v_temp1 := v_temp1 || ' from v_osi_deers_compare where participant=' || '''' || p_sid || '''';

         DBMS_SQL.PARSE(l_theCursor, v_temp1, DBMS_SQL.NATIVE);
     
         dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl);
     
         for i in 1 .. l_colCnt
         loop
             if l_descTbl(i).col_type=113 then

               dbms_sql.define_column( l_theCursor, i, l_BLOBValue1);

             else
  
               dbms_sql.define_column( l_theCursor, i, l_columnValue1, 4000);
               
             end if;

         end loop;

         l_status := dbms_sql.execute(l_theCursor);
     
         l_i2msTable := '<TABLE ID="DEERSComparison"><TR><TD ID="I2MSDataColumn"><TABLE ID="I2MSData">' || vCRLF;
         l_i2msTable := l_i2msTable || ' <TR><TH ID="CurrentHeader" COLSPAN=2>Current Web I2MS Data</TH></TR>';

         l_deersTable := '<TD ID="DEERSDataColumn"><TABLE ID="DEERSData">' || vCRLF;
         l_deersTable := l_deersTable || ' <TR><TH ID="DEERSHeader" COLSPAN=2>DEERS Data</TH></TR>' || vCRLF;
     
         while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
         loop
             l_cnt := l_cnt + 1;
         
             for i in 1 .. l_colCnt/2
             loop
                 if l_descTbl(l_currCol).col_type=113 then

                   dbms_sql.column_value(l_theCursor, l_currCol, l_BLOBValue1);
                   dbms_sql.column_value(l_theCursor, l_currCol+1, l_BLOBValue2);
                   if dbms_lob.compare(l_BLOBValue1, l_BLOBValue2) != 0  or (l_BLOBValue1 is null and l_BLOBValue2 is not null) then

                     l_columnValue1 := '&lt;' || labels(i) || ' Changed&gt;';
                     l_columnValue2 := '&lt;' || labels(i) || '  Changed&gt;';
                   
                   else
                     
                     l_columnValue1 := '&nbsp;';
                     l_columnValue2 := '&nbsp;';
                       
                   end if;

                 else 
      
                   dbms_sql.column_value(l_theCursor, l_currCol, l_columnValue1);
                   dbms_sql.column_value(l_theCursor, l_currCol+1, l_columnValue2);
                 
                 end if;
                 
                 if l_columnValue1 is null then
                   
                   l_columnValue1 := '&nbsp;';
               
                 end if;
                 if l_columnValue2 is null then
               
                   l_columnValue2 := '&nbsp;';
               
                 end if;

                 if l_columnValue1 <> l_columnValue2 and l_columnValue2 <> '&nbsp;' then
             
                   l_i2msTable := l_i2msTable || ' <TR ';
                   l_deersTable := l_deersTable || ' <TR ';
               
                   if mod(l_rowCount, 2) = 0 then
               
                     l_i2msTable := l_i2msTable || 'ID="evenRow"';
                     l_deersTable := l_deersTable || 'ID="evenRow"';
               
                   else
               
                     l_i2msTable := l_i2msTable || 'ID="oddRow"';
                     l_deersTable := l_deersTable || 'ID="oddRow"';
                 
                   end if;
                
                   l_i2msTable := l_i2msTable || '><TD ID="theLabel">' || labels(i) || '</TD><TD ID="theValue">' || l_columnValue1 || '</TD></TR>' || vCRLF;
                   l_deersTable := l_deersTable || '><TD ID="theLabel"><input checked="true" type="checkbox" name="' || i2ms_columns(i) || '" />' || labels(i) || '</TD><TD ID="theValue">' || l_columnValue2 || '</TD></TR>' || vCRLF;
                   l_rowCount := l_rowCount + 1;
             
                 else
               
                   p_uncheckedItems := p_uncheckedItems || i2ms_columns(i) || '~';
                 
                 end if;
             
                 l_currCol := l_currCol+2;
               
             end loop;
         
         end loop;
         dbms_sql.close_cursor(l_theCursor);
     
         l_i2msTable := l_i2msTable || '</TABLE></TD>' || vCRLF;
         l_deersTable := l_deersTable || '</TABLE></TD></TR></TABLE>' || vCRLF;
     
         if l_rowCount = 1 then
       
           p_shown := 'N';
      
         else
       
           p_shown := 'Y';
       
         end if;
     
         return l_i2msTable || l_deersTable;
                 
         exception
             when others then
                 log_error('ERROR IN DEERS_COMPARE=' || sqlerrm);
                 dbms_sql.close_cursor(l_theCursor);
                 raise;   
     
    end DEERS_COMPARE;

end osi_deers;
/
