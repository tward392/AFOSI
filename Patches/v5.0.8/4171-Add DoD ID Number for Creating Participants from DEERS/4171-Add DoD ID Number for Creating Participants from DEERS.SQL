INSERT INTO T_OSI_PARTIC_NUMBER_TYPE ( SID, CODE, DESCRIPTION, JABS_CODE, NOTE_REQUIRED, DEERS_SEARCHABLE, DEERS_CODE, SEQ, ACTIVE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33319E4Y', 'DOD', 'DoD ID Number', NULL, 'N', 'Y', NULL, 9, 'Y', 'timothy.ward',  TO_Date( '11/08/2012 11:17:50 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2012 11:17:50 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;




set define off;

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
    13-Jul-2011  Tim Ward        CR#3859 - Photo not showing up in the Participant Details Report. 
                                  Changed in process_photo_information and update_person_with_deers.
    08-Sep-2011  Tim Ward        CR#3917-Error in DEERS updates because of Multiple Relationships 
                                  Changed in process_unit_relationship.
    27-Dec-2011  Tim Ward        CR#3925 - "Could not Process Request" if there are tw legal names
                                  Changed in get_deers_information.
    08-Nov-2012  Tim Ward        CR#4171 - Allow Searching DEERS with DoD ID Number.
                                  Changed in get_deers_information and process_deers_participant.                                                           
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
                            (obj, description, type, storage_loc_type, source, content, lock_mode, seq)
                     values (v_person_sid,
                             'DEERS Photo imported:  ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS'),
                             (select sid
                                from t_osi_attachment_type
                               where obj_type = v_obj_type and usage = 'MUGSHOT' and code = 'MUG'),
                             'DB',
                             'DEERS',
                             osi_util.hex_to_blob(l_photo),
                             'LOCKED', 1);
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

                  l_rel_sid  := null;
                  for y in (select sid, partic_a, partic_b from t_osi_partic_relation
                                where (   (partic_a = v_person_sid and partic_b = l_unit_sid)
                                      or (partic_b = v_person_sid and partic_a = l_unit_sid))
                                      and (rel_type = l_rel_type and (to_char(comments)='DEERS' or to_char(comments)='DEERS created relationship')) order by sid)
                                      --and (rel_type = 'DEERS' or rel_type = 'DEERS created relationship');
                  loop
                      l_rel_sid  := y.sid;
                      l_person_a := y.partic_a;
                      l_person_b := y.partic_b;
                      exit;
                             
                  end loop;   
                           
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

/* tjw here removed for 4171.        
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
*/
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
    function get_deers_information(p_ssn in varchar2, p_last_name in varchar2, p_new in integer, p_numtype in varchar2 := 'SSN') return varchar2 is
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
        l_numtypesid_ssn    t_osi_partic_number_type.sid%type;
    begin
        begin
            select sid into l_numtypesid_ssn from t_osi_partic_number_type where code='SSN';
        exception
            when no_data_found then
                null;
        end;

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

          select sid into v_pv_sid from v_osi_participant_version where participant=v_person_sid and sid=current_version;

          select dod_edi_pn_id into v_ssn from t_osi_participant where sid=v_person_sid;

          if v_ssn is not null then

            v_xml := ws_by_dod_edi(v_ssn);

          else

            begin
                 select count(distinct(num_value)) into ssn_count from t_osi_partic_number where participant_version=v_pv_sid and num_type=l_numtype_sid;

                  if ssn_count > 1 then

                    l_output := 'ERROR Participant has more than one ' || l_numdescription || '.';
                    l_ssn := null;
                    v_ssn := null;

                  else

                    select distinct (num_value) into v_ssn from t_osi_partic_number where participant_version=v_pv_sid and num_type=l_numtype_sid;

                  end if;

            exception
                  when no_data_found then

                      l_output := 'ERROR Could not find a ' || l_numdescription;
                      l_ssn := null;
                      v_ssn := null;

                      update t_osi_participant_human set deers_date = sysdate - 153 where sid=v_pv_sid;
            end;

            l_last_name:=null;
            begin
                 for n in (select n.last_name from t_osi_partic_name n, t_osi_partic_name_type nt where n.participant_version=v_pv_sid and n.name_type=nt.sid and nt.code='L')
                 loop
                     l_last_name:=n.last_name;
                         
                 end loop;
                     
                 if l_last_name is null or l_last_name='' then
                       
                   raise no_data_found;
                       
                 end if;
                     
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
        
        ---------------------
        --- p_num = 1 New ---
        ---------------------
        else

          if l_numtypecodei2ms='DOD' then

            v_xml := ws_by_dod_edi(p_ssn);
            l_output := is_valid(l_numtypecodei2ms, l_numdescription, p_ssn);

          else

            v_xml := ws_by_ssn_last_name(p_ssn, substr(upper(p_last_name), 1, 3), 'adr', l_numtypecode);
            l_output := is_valid(l_numtypecodei2ms, l_numdescription, p_ssn);
              
          end if;

          if l_output <> 'Y' then
 
            v_import_message := l_output;
            return null;
 
          end if;

          if p_new = 0 then

            begin
                 select n.participant_version into v_pv_sid
                      from t_osi_partic_number n, t_osi_partic_name v
                     where n.num_type = l_numtype_sid
                       and n.num_value = p_ssn
                       and v.last_name like p_last_name || '%'
                       and n.participant_version = v.participant_version;

                 select participant into v_person_sid from t_osi_participant_version where sid = v_pv_sid;

                  if v_person_sid is null or v_pv_sid is null then

                    core_logger.log_it(c_pipe,'[GET_DEERS_INFORMATION]1336 Could not find table records for Person SID = ' || v_person_sid || ' and PersonVersion SID = ' || v_pv_sid);
                    v_import_message := 'ERROR Error getting person records for update';
                    return null;

                  end if;

            exception

                  when no_data_found then
                      core_logger.log_it(c_pipe,'[GET_DEERS_INFORAMTION]1346 Could not find table records for Person SID = ' || v_person_sid || ' and PersonVersion SID = ' || v_pv_sid);
                      v_import_message := 'ERROR Error getting person records for update';
                      return null;
            end;
          
          end if;
          
        end if;
        
        --------------------------------------------
        --- Special Case for DoD Number Searches ---
        --------------------------------------------
        if l_numtypecodei2ms='DOD' then

          remove_old_personnel_rcds;
          v_ssn := get_value_of_tag('DOD_EDI_PN_ID', 1);

          if v_ssn is null then

            core_logger.log_it(c_pipe,'[GET_DEERS_INFORMATION]1361 Could not get information from DEERS for ' || p_numtype || ' = ' || p_ssn);
            v_import_message := 'ERROR Could not get information from DEERS';
            return null;

          elsif p_last_name is not null and v_ssn <> p_ssn then

               core_logger.log_it(c_pipe,'[GET_DEERS_INFORMATION]1365 ' || p_numtype || ' from DEERS did not match entered ' || p_numtype || ' = ' || p_ssn);
               v_import_message := 'ERROR Returned a non-matching ' || p_numtype;
               return null;

          end if;
          v_ssn := get_value_of_tag('PN_ID', 1);

        else

          remove_old_personnel_rcds;
          v_ssn := get_value_of_tag('PN_ID', 1);

          if v_ssn is null then

            core_logger.log_it(c_pipe,'[GET_DEERS_INFORMATION]1361 Could not get information from DEERS for ' || p_numtype || ' = ' || p_ssn);
            v_import_message := 'ERROR Could not get information from DEERS';
            return null;

          elsif p_last_name is not null and v_ssn <> p_ssn then

               core_logger.log_it(c_pipe,'[GET_DEERS_INFORMATION]1365 ' || p_numtype || ' from DEERS did not match entered ' || p_numtype || ' = ' || p_ssn);
               v_import_message := 'ERROR Returned a non-matching ' || p_numtype;
               return null;

          end if;
          
        end if;
        
        -----------------------
        --- New Participant ---
        -----------------------
        if p_new <> 0 then

          --- do an initial creation of an unconfirmed participant, if new ---
          -- Confirmation occurs in process_person_information.
          insert into t_core_obj (obj_type) values (v_obj_type) returning sid into v_person_sid;

          insert into t_osi_participant (sid) values (v_person_sid);

          insert into t_osi_participant_version (participant) values (v_person_sid) returning sid into v_pv_sid;

          insert into t_osi_participant_human (sid) values (v_pv_sid);

          insert into t_osi_person_chars (sid) values (v_pv_sid);
          
          update t_osi_participant set current_version=v_pv_sid where sid=v_person_sid;

          delete t_osi_personnel_recent_objects where obj not in(select sid from t_osi_participant) and personnel=core_context.personnel_sid();

          insert into t_osi_partic_name (participant_version,name_type,last_name)
                values (v_pv_sid, (select sid from t_osi_partic_name_type where code='L'),p_last_name) returning sid into l_name_sid;

          update t_osi_participant_version set current_name=l_name_sid where sid=v_pv_sid;

          if l_numtypecodei2ms='DOD' then

            insert into t_osi_partic_number (participant_version,num_type,num_value) values (v_pv_sid,l_numtypesid_ssn,v_ssn);
            insert into t_osi_partic_number (participant_version,num_type,num_value) values (v_pv_sid,l_numtype_sid,p_ssn);
          
          else

            insert into t_osi_partic_number (participant_version,num_type,num_value) values (v_pv_sid,l_numtype_sid,p_ssn);
            
          end if;
                    

          osi_status.change_status_brute(v_person_sid,osi_status.get_starting_status(v_obj_type),'DEERS Created');

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

        return l_rtn;

    exception
        when others then
            core_logger.log_it(c_pipe,'[GET_DEERS_INFORMATION]1436 Oracle error during processing of ' || p_ssn || '/' || sqlerrm);
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
                    
                    update t_osi_attachment set seq=seq+1 where obj=v_person_sid;
                    
                    insert into t_osi_attachment
                                (obj,
                                 obj_context,
                                 type,
                                 description,
                                 storage_loc_type,
                                 source,
                                 content, seq)
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
                                 i.photo, 1);

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







set define off;

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
     01-Nov-2011  Tim Ward       CR#3847 - AKA and NEE missing from Subject and Victim Title Block of ROI.
                                  Added Name_Set.
     15-Nov-2011 Tim Ward        CR#3738 - Adding Active/All Flag, noticed desktop name not display right.
                                  Added parameter and changed get_name.
     20-Jan-2012 Tim Ward        CR#3738 - Changed Parameter to Default to 'Y' instead of No.
                                  Changed get_name.
     16-Apr-2012 Tim Ward        CR#4011 - Change Address Case statement to include an else to set it to OTHER
                                  Changed import_legacy_part_version.
     16-Apr-2012 Tim Ward        CR#4032 - Change Select to see if person has been migrated (could return more than one).
                                  Changed import_legacy_relationships.
     16-Apr-2012 Tim Ward        CR#4017 - Individual Participant Title Screen shows Birth Address instead of Current.
                                  Changed get_address_data and V_OSI_PARTICIPANT_INDIV_TITLE view.
     09-Nov-2012 Tim Ward        CR#4171 - Added Check for Matching DoD ID Number since we can now search on it.
                                  Changed in check_for_matches.
                                  
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
                     --and type_code=p_address_code
                     and (type_code=p_address_code or (IS_CURRENT='Y' AND p_address_code LIKE 'CURRENT%'))
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

    FUNCTION get_name(p_pvop IN VARCHAR2, p_ln_first IN VARCHAR2:='Y') RETURN VARCHAR2 IS

         v_individual T_CORE_OBJ_TYPE.SID%TYPE;

    BEGIN
         v_individual := Core_Obj.lookup_objtype('PART.INDIV');
         
         IF p_ln_First = 'N' then

           FOR x IN (SELECT /*+FIRST_ROWS*/ DECODE(pv.obj_type, v_individual, RTRIM(LTRIM(PN.FIRST_NAME || DECODE(PN.MIDDLE_NAME, NULL, '', ' ' || PN.MIDDLE_NAME) || DECODE(PN.LAST_NAME, NULL, '', ' ' || PN.LAST_NAME))),
                                                                              PN.LAST_NAME || DECODE(PV.ORG_MAJCOM_CODE, NULL, '', ' (' || PV.ORG_MAJCOM_CODE || ')')) as name         
                       FROM T_OSI_PARTIC_NAME pn, v_osi_participant_version pv
                      WHERE (pv.SID = p_pvop OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                        AND (pn.SID = pv.current_name))

           LOOP
               RETURN x.NAME;
           END LOOP;

         ELSE

           FOR x IN (SELECT /*+FIRST_ROWS*/ DECODE(pv.obj_type, v_individual, RTRIM(LTRIM(PN.LAST_NAME || DECODE(PN.FIRST_NAME, NULL, '', ', ' || PN.FIRST_NAME) || DECODE(PN.MIDDLE_NAME, NULL, '', ' ' || PN.MIDDLE_NAME))),
                                                                              PN.LAST_NAME || DECODE(PV.ORG_MAJCOM_CODE, NULL, '', ' (' || PV.ORG_MAJCOM_CODE || ')')) as name         
                       FROM T_OSI_PARTIC_NAME pn, v_osi_participant_version pv
                      WHERE (pv.SID = p_pvop OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                        AND (pn.SID = pv.current_name))

           LOOP
               RETURN x.NAME;
           END LOOP;
                    
         END IF;
         
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
        v_cnt                    number                               := 0;
        v_found_match            BOOLEAN;
        v_sex_code               VARCHAR2(200);
        v_num_type_code          VARCHAR2(200);
        v_num_type_description   VARCHAR2(200);
        v_participant_sid        VARCHAR2(20);

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

                v_cnt := 1;
                v_found_match := TRUE;
            END LOOP;
            
            --- Check for Existing DoD ID Number if that is what is being searched ---
            if v_code = 'DOD' then
              
              begin
                   select sid into v_participant_sid from t_osi_participant where dod_edi_pn_id=p_number;
              exception when others then

                       v_participant_sid := null;
              end;
              if v_participant_sid is not null then
                v_score := 100;
                if v_found_match = TRUE then
                  UPDATE T_OSI_PARTIC_SEARCH_RESULT set score=v_score, info=info || ' ' || v_info where session_id=p_session_web and participant=v_participant_sid;
                else
                  INSERT INTO T_OSI_PARTIC_SEARCH_RESULT (session_id, participant, score, info) VALUES (p_session_web, v_participant_sid, v_score, v_info);
                end if;
                
                v_found_match := TRUE;
              end if;
              
            end if;
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
                ELSE
                    v_osi_address_address_type :=
                                          Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'OTH');
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
                FOR new_rel in (SELECT new_sid FROM t_osi_migration WHERE type='PARTICIPANT' AND old_sid = v_rel_person)
                LOOP
                    v_new_rel_person := new_rel.new_sid;
                    
                END LOOP;
                
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

FUNCTION Name_Set( pPoPV IN VARCHAR2, pType IN VARCHAR2 ) RETURN VARCHAR2 IS

     v_result VARCHAR2(1000);

BEGIN
     FOR pn IN (SELECT RTRIM(LTRIM(pn.FIRST_NAME || DECODE(pn.MIDDLE_NAME, NULL, '', ' ' || pn.MIDDLE_NAME) || DECODE(pn.LAST_NAME, NULL, '', ' ' || pn.LAST_NAME))) || '; ' AS WHOLE_NAME
                 FROM T_OSI_PARTIC_NAME PN,
                      T_OSI_PARTICIPANT P,
                      T_OSI_PARTICIPANT_VERSION PV,
                      T_OSI_PARTIC_NAME_TYPE PT
                 WHERE (PV.SID=pPopV OR (PV.PARTICIPANT=pPoPV AND P.CURRENT_VERSION=pPopV)) 
                   AND PN.PARTICIPANT_VERSION=PV.SID
                   AND PN.NAME_TYPE=PT.SID
                   AND PT.CODE LIKE pType
                   AND P.SID=PV.PARTICIPANT
                 ORDER BY PN.LAST_NAME, PN.FIRST_NAME, PN.MIDDLE_NAME)
    LOOP

        v_result := v_result || PN.WHOLE_NAME;

    END LOOP;

    v_result := RTRIM( v_result, '; ' );

    RETURN( v_result );

END Name_Set;

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
--   Date and Time:   08:08 Friday November 9, 2012
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

PROMPT ...Remove page 30000
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30000);
 
end;
/

 
--application/pages/page_30000
prompt  ...PAGE 30000: Individual Participant (Search/Create)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'"STYLE_FORMLAYOUT_100%"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' $(".optionallabel").attr("tabindex","-1");'||chr(10)||
' $(''#P30000_NUMBER_TYPE_LABEL'').remove();'||chr(10)||
' $(''#P30000_X_LABEL'').remove();'||chr(10)||
' $(''#P30000_X_ELEMENT'').remove();'||chr(10)||
' $(''#footpanel'').remove();'||chr(10)||
' $(''#minbuttononly'').remove();'||chr(10)||
' $(''#maxbuttononly'').remove();'||chr(10)||
' '||chr(10)||
' $(''#P30000_FIRST_NAME_TD'').width($(''#P30000_NUMBER_TYPE'').width());'||chr(10)||
' ';

ph:=ph||'$(''#P30000_DOB'').width($(''#P30000_SEX'').width());'||chr(10)||
''||chr(10)||
' if($(''#P30000_DIALOG'').val()==''Y'')'||chr(10)||
'   {'||chr(10)||
'    $(''.bannerTable'').next(''table'').hide();'||chr(10)||
'    $(''.bannerTable'').hide();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if("&REQUEST." == "CREATE_RETURN" || "&REQUEST." == "CREATE_UNK_RETURN")'||chr(10)||
'   passBack("&P30000_SEL_PARTICIPANT.");'||chr(10)||
''||chr(10)||
' if (''&P30000_NEW_PARTIC_SID.''!='''')'||chr(10)||
' {'||chr(10)||
'  newWindow({page:30005, '||chr(10)||
'             clear_cache:30005, '||chr(10)||
'             n';

ph:=ph||'ame:''&P30000_NEW_PARTIC_SID.'', item_names:''P0_OBJ'', '||chr(10)||
'             item_values:''&P30000_NEW_PARTIC_SID.'', '||chr(10)||
'             request:''OPEN''});'||chr(10)||
' '||chr(10)||
'  close();'||chr(10)||
' }'||chr(10)||
''||chr(10)||
' $("#P30000_LAST_NAME,#P30000_FIRST_NAME,#P30000_NUMBER_VALUE").keypress(function(e) '||chr(10)||
'  {'||chr(10)||
'   if(e.keyCode==13)'||chr(10)||
'     doSubmit(''SEARCH'');'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'function passBack(pSid)'||chr(10)||
'{'||chr(10)||
' if($(''#P30000_DIALOG'').val()==''Y'')'||chr(10)||
'   {'||chr(10)||
'    window.parent.document.getE';

ph:=ph||'lementById("&P30000_RETURN_ITEM.").value = pSid;'||chr(10)||
'    window.parent.doSubmit("&P30000_RETURN_ITEM.");'||chr(10)||
'    closeDialog();'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    opener.document.getElementById("&P30000_RETURN_ITEM.").value = pSid;'||chr(10)||
'    opener.doSubmit("&P30000_RETURN_ITEM.");'||chr(10)||
'    window.close();'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
''||chr(10)||
'function useSelected(pMessage)'||chr(10)||
'{'||chr(10)||
' if(confirm(pMessage))'||chr(10)||
'   passBack("&P30000_SEL_PARTICIPANT.");'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'/*'||chr(10)||
' * This functi';

ph:=ph||'on is available to prompt the user. It was being used by button'||chr(10)||
' * #16 but it isn''t right now.'||chr(10)||
' */'||chr(10)||
'function createInstance(pMessage, pRequest)'||chr(10)||
'{'||chr(10)||
' if(confirm(pMessage))'||chr(10)||
'   doSubmit(pRequest);'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30000,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Individual Participant (Search/Create)',
  p_step_title=> 'Search/Create Participant',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="JavaScript">'||chr(10)||
'if("&P30000_ACTION." == "DEERS_UNCONFIRM")'||chr(10)||
'  {'||chr(10)||
'   if ("&P30000_LAST_NAME." == "")'||chr(10)||
'     {'||chr(10)||
'      var r=false;'||chr(10)||
'      alert("Last Name is Required.");'||chr(10)||
'     }'||chr(10)||
'   else'||chr(10)||
'     var r=confirm("&P30000_DEERS_MSG.");'||chr(10)||
''||chr(10)||
'   if (r==true)'||chr(10)||
'     doSubmit("CREATE");'||chr(10)||
'  }'||chr(10)||
'  '||chr(10)||
'if("&P30000_ACTION." == "DEERS_CREATED")'||chr(10)||
'  {'||chr(10)||
'   alert("&P30000_DEERS_MSG.");'||chr(10)||
'   doSubmit("DEERS_CREATED");'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'if("&P30000_ACTION." == ''DEERS_ERROR'')'||chr(10)||
'  alert("&P30000_DEERS_MSG.");'||chr(10)||
''||chr(10)||
'if("&P30000_ACTION." == ''DEERS_MSG'')'||chr(10)||
'  alert("&P30000_DEERS_MSG.");'||chr(10)||
' '||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121109080758',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '22-FEB-2011 J.FARIS WCHG0000371 - Participants Relationships Import, updated Import Legacy Participant process.'||chr(10)||
''||chr(10)||
'12-Apr-2011 Tim Ward CR#3795 - Added Check Last Name null validation.  '||chr(10)||
'                               Last Name is required to create a Participant.'||chr(10)||
''||chr(10)||
'12-Apr-2011 Tim Ward CR#3489 - Changed Footer Javascript to confirm OK/CANCEL '||chr(10)||
'                     CR#3764   if the user wants to create the unconfirmed '||chr(10)||
'                               participant.'||chr(10)||
''||chr(10)||
'08-Jun-2011 Tim Ward CR#3597 - Foreign ID Number Saves and SSN when '||chr(10)||
'                               Creating Participant.  Changed create_instance'||chr(10)||
'                               process to pass number type to'||chr(10)||
'                               osi_participant.create_instance function.'||chr(10)||
''||chr(10)||
'08-Jun-2011 - Tim Ward CR#3876 - Foreign National Privileges that are missing'||chr(10)||
'                                 Added Page 30101 branch.'||chr(10)||
''||chr(10)||
'22-Aug-2012 - Tim Ward - Getting rid of JS_POPUP_OBJ_DATA in favor of'||chr(10)||
'                          jQuery Modal Dialog window.'||chr(10)||
'                         Redesigned the screen a bit for appearance.'||chr(10)||
'                         Made Create Return add the object to recent accessed.'||chr(10)||
'                         Pressing "ENTER" while in Last Name, First Name or'||chr(10)||
'                          Number value initiates the Search.'||chr(10)||
'                         Set Tab Index so Tab goes LN, FN, Number, DOB, Sex,'||chr(10)||
'                          Search, Create, Unknown, Cancel.'||chr(10)||
''||chr(10)||
'09-Nov-2012 - Tim Ward - CR#4171 - Added DoD Number to DEERS searchable, so the'||chr(10)||
'                          P30000_MESSAGE is now built in the Process.'||chr(10)||
'');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30000,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30000,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select person_version,'||chr(10)||
'       decode(person_version, :P30000_SEL_LEGACY_PART, ''Y'', ''N'') as "Current",'||chr(10)||
'       Names as "Names",'||chr(10)||
'       score as "Matching Likelihood",'||chr(10)||
'       details as "Reasons for Match"'||chr(10)||
'  from v_osi_migration_partic_hit'||chr(10)||
' where user_session = :P30000_LEGACY_PARTIC_SESSION';

wwv_flow_api.create_report_region (
  p_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_name=> 'Legacy I2MS Participants',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 50,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P30000_CONTINUE = ''Y''',
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
  p_query_no_data_found=> 'No Legacy I2MS Participant Matches Found',
  p_query_num_rows_type=> 'ROWS_X_TO_Y_OF_Z',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 12141531488721506 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PERSON_VERSION',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''LVIEW_#PERSON_VERSION#'')',
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
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 12136412470592992 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
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
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 12200804643144285 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Names',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Names',
  p_column_alignment=>'LEFT',
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
  p_id=> 12130003009222854 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Matching Likelihood',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Matching Likelihood',
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
  p_id=> 12130128891222854 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Reasons for Match',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Reasons For Match',
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 12140418067698773 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Details of Selected Legacy Participant',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 60,
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
  p_plug_display_when_condition => ':P30000_SEL_LEGACY_PART IS NOT NULL',
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
  p_id=> 89341136016602021 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Search/Create Parameters',
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
  p_id=> 89345512226620324 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
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
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'select participant,'||chr(10)||
'       decode(participant, :P30000_SEL_PARTICIPANT, ''Y'', ''N'') as "Current",'||chr(10)||
'       last_name as "Last Name",'||chr(10)||
'       first_name as "First Name",'||chr(10)||
'       middle_name as "Middle Name",'||chr(10)||
'       score as "Matching Likelihood",'||chr(10)||
'       info as "Reasons for Match"'||chr(10)||
'  from v_osi_partic_search_result'||chr(10)||
' where session_id = :p30000_session';

wwv_flow_api.create_report_region (
  p_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_name=> 'Existing I2MS Participants',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P30000_CONTINUE = ''Y''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '100000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No matching participants found.',
  p_query_num_rows_type=> 'ROWS_X_TO_Y_OF_Z',
  p_query_row_count_max=> '100000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5589426093214521 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PARTICIPANT',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''VIEW_#PARTICIPANT#'')',
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
  p_id=> 91173814978667756 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 7,
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
  p_id=> 91170916835547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Last Name',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Last Name',
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
  p_id=> 91171013061547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'First Name',
  p_column_display_sequence=> 3,
  p_column_heading=> 'First Name',
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
  p_id=> 91171138238547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Middle Name',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Middle Name',
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
  p_id=> 91171238301547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Matching Likelihood',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Matching Likelihood',
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
  p_id=> 91171323011547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Reasons for Match',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Reasons For Match',
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 90599109543441349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Details of Selected Participant',
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
  p_plug_display_when_condition => ':P30000_SEL_PARTICIPANT IS NOT NULL',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89405908818791303 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 10,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'SEARCH',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Search',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_cattributes=>'tabindex="7"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91222636952661168 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 100,
  p_button_plug_id => 89364113657999253+wwv_flow_api.g_id_offset,
  p_button_name    => 'OPEN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Open Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:newWindow({name:''PARTICIPANT&P30000_SEL_PARTICIPANT.'',              page:30005,              clear_cache:30005,              item_names:''P0_OBJ'',              item_values:''&P30000_SEL_PARTICIPANT.'',              request:''OPEN''});',
  p_button_condition=> 'P30000_SEL_PARTICIPANT',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91222813823661170 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 105,
  p_button_plug_id => 89364113657999253+wwv_flow_api.g_id_offset,
  p_button_name    => 'USE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Use Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:useSelected(''Are you sure you want to associate this participant to another object?'');',
  p_button_condition=> ':P30000_SEL_PARTICIPANT IS NOT NULL AND'||chr(10)||
':P30000_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13050432249930481 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 115,
  p_button_plug_id => 12129308399222823+wwv_flow_api.g_id_offset,
  p_button_name    => 'IMPORT_SELECTED',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Import Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_SEL_LEGACY_PART is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89341331911602023 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 15,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE IS NULL AND :P30000_CONTINUE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'tabindex="8"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91267032597639204 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 16,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE = ''FROM_OBJ'' AND :P30000_CONTINUE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'tabindex="8"',
  p_button_comment=>'javascript:createInstance(''This participant will be created UNCONFIRMED and associated to object &P0_OBJ_TAGLINE.. Do you want to continue?'', ''CREATE_RETURN'');',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89418530138686924 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 20,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_UNK',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Unknown Participant',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'tabindex="9"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91329434025836453 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 21,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_UNK_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Unknown Participant',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'tabindex="9"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89341514582602023 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 25,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_button_condition=> ':P30000_DIALOG!=''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'tabindex="10"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16130023242567368 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 125,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_condition=> ':P30000_DIALOG=''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'onClick="javascript:closeDialog();" tabindex="10"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5917911033397014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30101:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> .5,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST=''CREATE'' and osi_auth.check_access(:P0_OBJ)=''N'';',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2011 13:00 by TWARD');
 
wwv_flow_api.create_page_branch(
  p_id=>89341722159602023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30005:&SESSION.:OPEN:&DEBUG.:30000::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 1,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST IN (''CREATE'', ''CREATE_UNK'', ''DEERS_CREATED'')',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>89406229948791306 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30000:&SESSION.:&REQUEST.:&DEBUG.::P30000_CONTINUE,P30000_SEL_PARTICIPANT:Y,',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>89405908818791303+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>89345334474607882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30000:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 14:31 by RECHER');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3670711603404937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DEERS_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
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
  p_id=>3670904055404950 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DEERS_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
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
  p_id=>3809010655211925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
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
  p_id=>5612126859820320 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SESSION',
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
  p_id=>12128015091082846 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LEGACY_PARTIC_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_LEGACY_PARTIC_SESSION',
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
  p_id=>12135209091573150 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_LEGACY_PART',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 12129308399222823+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEL_LEGACY_PART',
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
  p_id=>12140730534702298 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_LEGACY_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 12140418067698773+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_legacy_part_details(:P30000_SEL_LEGACY_PART);',
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
  p_id=>13051211518952871 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NEW_PARTIC_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 12140418067698773+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_NEW_PARTIC_SID',
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
  p_id=>16129727613559126 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DIALOG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
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
  p_id=>16137317389323381 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'id="P30000_X_LABEL" nowrap="nowrap"',
  p_cattributes_element=>'id="P30000_X_ELEMENT"',
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
  p_id=>89341938654602024 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_PARTICIPANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEL_PARTICIPANT',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
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
  p_id=>89367113059055907 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_pre_element_text=>'<h1>',
  p_post_element_text=>'</h1>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'tabindex="-1"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 6,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<tr><td width="155" rowspan="3" colspan="3">&nbsp;</td>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89367333622071267 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LAST_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Last Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'id="P30000_LAST_NAME_TD" nowrap="nowrap"',
  p_tag_attributes  => 'tabindex="1"',
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
  p_id=>89367517823076190 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_FIRST_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'First Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 5,
  p_cAttributes=> 'id="P30000_FIRST_NAME_TD" nowrap="nowrap"',
  p_tag_attributes  => 'tabindex="2"',
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
  p_id=>89367909989083378 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 5,
  p_tag_attributes  => 'tabindex="4"',
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
  p_id=>89368629167098340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DOB',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Birthdate',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'class="datepickernew" tabindex="5"',
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
  p_id=>89368936224109821 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sex',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P30000_SEX_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Sex -',
  p_lov_null_value=> '',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'tabindex="6"',
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
  p_id=>89405434052770254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_CONTINUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_CONTINUE=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>90599516946452935 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 400,
  p_item_plug_id => 90599109543441349+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_PARTICIPANT.GET_DETAILS(:P30000_SEL_PARTICIPANT);',
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
  p_id=>91259033619437731 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_RETURN_ITEM=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91262816181199224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_MODE=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93263632644079337 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_partic_number_type'||chr(10)||
'   where active = ''Y'''||chr(10)||
'      or sid = :p30000_number_type'||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'id="P30000_NUMBER_TYPE_LABEL"',
  p_tag_attributes  => 'tabindex="3"',
  p_begin_on_new_line => 'NO',
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
  p_id=>95045621212372757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'dibrs_reference.get_lov(''SEX'',:p30000_sex);',
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
  p_id=>95545015495471757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SSN_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select sid'||chr(10)||
'  from t_osi_partic_number_type'||chr(10)||
' where code = ''SSN''',
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
  p_id=>96758123524419584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_FNAME_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_FNAME_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758315968419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LNAME_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_LNAME_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758522773419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_NUMBER_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758717427419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DOB_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_DOB_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758908934419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEX_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95544834972458520 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Numeric SSN',
  p_validation_sequence=> 1,
  p_validation => 'P30000_NUMBER_VALUE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => 'SSN must be numeric.',
  p_validation_condition=> ':request = ''SEARCH'' and :p30000_number_type = :p30000_ssn_type',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 1175616794373923 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'DOB is valid date',
  p_validation_sequence=> 2,
  p_validation => 'P30000_DOB',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'DOB must be a valid date.',
  p_validation_condition=> ':request = ''SEARCH''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89368629167098340 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89416938619651515 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Not null search terms',
  p_validation_sequence=> 5,
  p_validation => ':P30000_LAST_NAME IS NOT NULL OR '||chr(10)||
':P30000_FIRST_NAME IS NOT NULL OR'||chr(10)||
':P30000_NUMBER_VALUE IS NOT NULL',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'Must supply a first name, last name or SSN number.',
  p_validation_condition=> 'SEARCH',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95801423087059968 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'SSN is numeric',
  p_validation_sequence=> 10,
  p_validation => 'P30000_NUMBER_VALUE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => 'SSN must be numeric.',
  p_validation_condition=> ':P30000_NUMBER_TYPE = :P30000_SSN_TYPE AND'||chr(10)||
':REQUEST = ''CREATE'' OR'||chr(10)||
':REQUEST = ''CREATE_RETURN''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95801713306075979 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'SSN is 9 digits',
  p_validation_sequence=> 15,
  p_validation => 'begin'||chr(10)||
'  if(:p30000_number_type = :p30000_ssn_type)then'||chr(10)||
'      if(   length(:p30000_number_value) = 9'||chr(10)||
'         or :p30000_number_value is null)then'||chr(10)||
'        return true;'||chr(10)||
'      else'||chr(10)||
'        return false;'||chr(10)||
'      end if;'||chr(10)||
'  else'||chr(10)||
'    return true;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'SSN must be nine digits.',
  p_validation_condition=> 'CREATE,CREATE_RETURN,SEARCH',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96773724440836168 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check last name',
  p_validation_sequence=> 20,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_lname_old is not null) then'||chr(10)||
'        if (:p30000_lname_old = :p30000_last_name) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_lname_old is null and :p30000_last_name is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The last name has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96806310073287789 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check first name',
  p_validation_sequence=> 21,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_fname_old is not null) then'||chr(10)||
'        if (:p30000_fname_old = :p30000_first_name) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_fname_old is null and :p30000_first_name is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The first name has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808013068354920 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check number',
  p_validation_sequence=> 22,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_number_old is not null) then'||chr(10)||
'        if (:p30000_number_old = :p30000_number_value) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_number_old is null and :p30000_number_value is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The number value has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808408351363045 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check DOB',
  p_validation_sequence=> 23,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_dob_old is not null) then'||chr(10)||
'        if (:p30000_dob_old = :p30000_dob) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_dob_old is null and :p30000_dob is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The birthdate has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808625320367978 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check sex',
  p_validation_sequence=> 24,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_sex_old is not null) then'||chr(10)||
'        if (:p30000_sex_old = :p30000_sex) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_sex_old is null and :p30000_sex is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The sex value has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 5275827908497509 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check Last Name null',
  p_validation_sequence=> 34,
  p_validation => 'begin'||chr(10)||
'    if(:p30000_last_name is null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The last name is a required field.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
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
''||chr(10)||
'  :P30000_SEL_LEGACY_PART := null;'||chr(10)||
''||chr(10)||
'  osi_participant.check_for_matches(:p30000_number_value,'||chr(10)||
'                                    :p30000_number_type,'||chr(10)||
'                                    :p30000_dob,'||chr(10)||
'                                    :p30000_last_name,'||chr(10)||
'                                    :p30000_first_name,'||chr(10)||
'                                    :p30000_sex,'||chr(10)||
'                                 ';

p:=p||'   :p30000_session,'||chr(10)||
'                                    :p30000_legacy_partic_session,'||chr(10)||
'                                    :p30000_deers_result);'||chr(10)||
''||chr(10)||
'  :debug := ''deers result: '' || :p30000_deers_result;'||chr(10)||
''||chr(10)||
'  --- If this is true then a DEERS query was made. ---'||chr(10)||
'  if (:p30000_session is null) then'||chr(10)||
''||chr(10)||
'     --- If this is true then a DEERS error occured. ---'||chr(10)||
'     if (:p30000_deers_result is null) then'||chr(10)||
''||chr(10)||
'    ';

p:=p||'   :p30000_deers_msg := ltrim(osi_deers.get_import_message, ''MSG '') || ''\nUnconfirmed participant will be created.'';'||chr(10)||
'       :p30000_action := ''DEERS_UNCONFIRM'';'||chr(10)||
''||chr(10)||
'     elsif(instr(:p30000_deers_result, ''ERROR'') > 0) then'||chr(10)||
''||chr(10)||
'         :p30000_deers_msg := ltrim(:p30000_deers_result, ''ERROR '');'||chr(10)||
'         :p30000_action := ''DEERS_ERROR'';'||chr(10)||
' '||chr(10)||
'    elsif(instr(:p30000_deers_result, ''MSG'') > 0) then'||chr(10)||
''||chr(10)||
'         :';

p:=p||'p30000_deers_msg := ltrim(:p30000_deers_result, ''MSG '');'||chr(10)||
'         :p30000_action := ''DEERS_MSG'';'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
''||chr(10)||
'      --- A new participant was created and we have a version sid. ---'||chr(10)||
'      :p0_obj := osi_participant.get_participant(:p30000_deers_result);'||chr(10)||
'      :p30000_deers_msg := ''DEERS match found. Confirmed participant was created.'';'||chr(10)||
'      :p30000_action := ''DEERS_CREATED'';'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'';

p:=p||''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5578311932812948 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check for matches',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SEARCH',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'begin'||chr(10)||
'    :P30000_SEL_LEGACY_PART := null;'||chr(10)||
''||chr(10)||
'    osi_participant.check_for_matches(:p30000_number_value,'||chr(10)||
'                                      :p30000_number_type,'||chr(10)||
'                                      :p30000_dob,'||chr(10)||
'                                      :p30000_last_name,'||chr(10)||
'                                      :p30000_first_name,'||chr(10)||
'                                      :p30000_sex,'||chr(10)||
'                                      :p30000_session,'||chr(10)||
'                                      :p30000_legacy_partic_session,'||chr(10)||
'                                      :p30000_deers_result);'||chr(10)||
'    :debug := ''deers result: '' || :p30000_deers_result;'||chr(10)||
''||chr(10)||
'    -- If this is true then a DEERS query was made.'||chr(10)||
'    if (:p30000_session is null) then'||chr(10)||
'        -- If this is true then a DEERS error occured.'||chr(10)||
'        if (:p30000_deers_result is null) then'||chr(10)||
'            :p30000_deers_msg :='||chr(10)||
'                ltrim(osi_deers.get_import_message, ''MSG '')'||chr(10)||
'                || ''\nUnconfirmed participant will be created.'';'||chr(10)||
'            :p30000_action := ''DEERS_UNCONFIRM'';'||chr(10)||
'        elsif(instr(:p30000_deers_result, ''ERROR'') > 0) then'||chr(10)||
'            :p30000_deers_msg := ltrim(:p30000_deers_result, ''ERROR '');'||chr(10)||
'            :p30000_action := ''DEERS_ERROR'';'||chr(10)||
'        elsif(instr(:p30000_deers_result, ''MSG'') > 0) then'||chr(10)||
'            :p30000_deers_msg := ltrim(:p30000_deers_result, ''MSG '');'||chr(10)||
'            :p30000_action := ''DEERS_MSG'';'||chr(10)||
'        else'||chr(10)||
'            -- A new participant was created and we have a version sid.'||chr(10)||
'            :p0_obj := osi_participant.get_participant(:p30000_deers_result);'||chr(10)||
'            :p30000_deers_msg := ''DEERS match found. Confirmed participant was created.'';'||chr(10)||
'            :p30000_action := ''DEERS_CREATED'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
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
p:=p||'declare'||chr(10)||
'    v_sid varchar2(1000);'||chr(10)||
'begin'||chr(10)||
'    if (:request like ''CREATE_UNK%'') then'||chr(10)||
'        v_sid :='||chr(10)||
'            osi_participant.create_instance();'||chr(10)||
''||chr(10)||
'        if (:request = ''CREATE_UNK_RETURN'') then'||chr(10)||
'            :p30000_sel_participant := v_sid;'||chr(10)||
'        else'||chr(10)||
'            :p0_obj := v_sid;'||chr(10)||
'        end if;'||chr(10)||
'    else'||chr(10)||
'        v_sid :='||chr(10)||
'            osi_participant.create_instance(:p30000_last_name,'||chr(10)||
'          ';

p:=p||'                                  :p30000_first_name,'||chr(10)||
'                                            :p30000_number_value,'||chr(10)||
'                                            :p30000_dob,'||chr(10)||
'                                            :p30000_sex,'||chr(10)||
'                                            ''N'','||chr(10)||
'                                            :p30000_number_type);'||chr(10)||
'        if (:request = ''CREATE_RETURN'') then'||chr(10)||
'      ';

p:=p||'      :p30000_sel_participant := v_sid;'||chr(10)||
'            recent_access(v_sid,:user_sid);'||chr(10)||
'        else'||chr(10)||
'            :p0_obj := v_sid;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90630618723532185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create instance',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''CREATE%''',
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
p:=p||'delete t_osi_partic_search_result where session_id = :p30000_session;';

wwv_flow_api.create_page_process(
  p_id     => 5620119062130325 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear search results',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':request like ''%CREATE%''',
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
p:=p||':P30000_SEL_PARTICIPANT := SUBSTR(:REQUEST, 6);';

wwv_flow_api.create_page_process(
  p_id     => 91172133539588020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select participant',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''VIEW_%'';',
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
p:=p||':P30000_SEL_LEGACY_PART := SUBSTR(:REQUEST, 7);';

wwv_flow_api.create_page_process(
  p_id     => 12135319134576042 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Legacy participant',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''LVIEW_%'';',
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
'my_exception exception;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     :P30000_NEW_PARTIC_SID := osi_participant.import_legacy_participant(:P30000_SEL_LEGACY_PART);'||chr(10)||
'     if :P30000_NEW_PARTIC_SID like ''Error:%'' then'||chr(10)||
'        raise my_exception;'||chr(10)||
'     end if;'||chr(10)||
'exception'||chr(10)||
'    when my_exception then'||chr(10)||
'         raise;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13051332642958923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Import Legacy Participant',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Error importing legacy participant',
  p_process_when=>':REQUEST = ''IMPORT_SELECTED'';',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'Legacy Participant Imported',
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
'    :p30000_lname_old := :p30000_last_name;'||chr(10)||
'    :p30000_fname_old := :p30000_first_name;'||chr(10)||
'    :p30000_number_old := :p30000_number_value;'||chr(10)||
'    :p30000_dob_old := :p30000_dob;'||chr(10)||
'    :p30000_sex_old := :p30000_sex;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 96760115391455048 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 15,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Save search terms',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SEARCH',
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
p:=p||'DECLARE'||chr(10)||
' '||chr(10)||
'  v_msg varchar2(4000);'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'     FOR A IN (SELECT DESCRIPTION FROM T_OSI_PARTIC_NUMBER_TYPE '||chr(10)||
'                     WHERE DEERS_SEARCHABLE=''Y'' ORDER BY SEQ)'||chr(10)||
'     LOOP'||chr(10)||
'         v_msg := v_msg || replace(a.description,'' Number'','''') || ''/'';'||chr(10)||
''||chr(10)||
'     END LOOP;'||chr(10)||
'     if substr(v_msg, length(v_msg))=''/'' then'||chr(10)||
'       '||chr(10)||
'       v_msg := substr(v_msg,1,length(v_msg)-1);'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'    :P30000_MESSA';

p:=p||'GE:=''The first three letters of last name and '' || v_msg || '' Number are required to search DEERS.'';'||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 17477431662593851 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 50,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup Message',
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
-- ...updatable report columns for page 30000
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

