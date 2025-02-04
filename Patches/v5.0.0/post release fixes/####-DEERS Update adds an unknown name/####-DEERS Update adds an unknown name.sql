ALTER TABLE T_OSI_DEERS_IMPORT drop CONSTRAINT PK_DEERSIMPORT_PARTIC;

 ALTER TABLE T_OSI_DEERS_IMPORT ADD (
  CONSTRAINT FK_DEERSIMPORT_PARTIC 
 FOREIGN KEY (PARTICIPANT_SID) 
 REFERENCES T_OSI_PARTICIPANT (SID) ON DELETE CASCADE);

INSERT INTO T_CORE_CONFIG ( SID, CODE, SETTING, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33315VAY', 'OSI.IMAGE_PREFIX', 'i', NULL, 'timothy.ward',  TO_Date( '01/19/2011 12:38:54 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '01/19/2011 12:40:04 PM', 'MM/DD/YYYY HH:MI:SS AM'));
COMMIT;


CREATE TABLE WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
(
  I2MS_COLUMN   VARCHAR2(100 BYTE),
  DEERS_COLUMN  VARCHAR2(100 BYTE),
  SEQ           NUMBER,
  LABEL         VARCHAR2(100 BYTE)
)
TABLESPACE I2MS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;



Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('LAST_NAME', 'DEERS_LAST_NAME', 2, 'Last Name');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('MIDDLE_NAME', 'DEERS_MIDDLE_NAME', 4, 'Middle Name');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('CADENCY', 'DEERS_CADENCY', 5, 'Cadency');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('PAY_PLAN', 'DEERS_PAY_PLAN', 6, 'Pay Plan');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('PAY_GRADE', 'DEERS_PAY_GRADE', 7, 'Pay Grade');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('PAY_BAND', 'DEERS_PAY_BAND', 8, 'Pay Band');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('RANK', 'DEERS_RANK', 9, 'Rank');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('ADDRESS_DISPLAY', 'DEERS_ADDRESS_DISPLAY', 10, 'Address');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('ETHNICITY', 'DEERS_ETHNICITY', 11, 'Ethnicity');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('EYE_COLOR', 'DEERS_EYE_COLOR', 12, 'Eye Color');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('HAIR_COLOR', 'DEERS_HAIR_COLOR', 13, 'Hair Color');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('HEIGHT', 'DEERS_HEIGHT', 14, 'Height');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('WEIGHT', 'DEERS_WEIGHT', 15, 'Weight');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('RACE', 'DEERS_RACE', 16, 'Race');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('SEX', 'DEERS_SEX', 17, 'Sex');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('BLOOD_TYPE', 'DEERS_BLOOD_TYPE', 18, 'Blood Type');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('SERVICE', 'DEERS_SERVICE', 19, 'Service');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('AFFILIATION', 'DEERS_AFFILIATION', 20, 'Affiliation');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('CITIZENSHIP', 'DEERS_CITIZENSHIP', 21, 'Citizenship');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('BIRTH_STATE', 'DEERS_BIRTH_STATE', 22, 'Birth State');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('BIRTH_COUNTRY', 'DEERS_BIRTH_COUNTRY', 23, 'Birth Country');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('HOME_PHONE', 'DEERS_HOME_PHONE', 24, 'Home Phone');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('WORK_PHONE', 'DEERS_WORK_PHONE', 25, 'Work Phone');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('EMAIL', 'DEERS_EMAIL', 26, 'Email Address');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('DOD', 'DEERS_DOD', 27, 'Date Of Death');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('PHOTO', 'DEERS_PHOTO', 28, 'Photo');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('DOB', 'DEERS_DOB', 1, 'Date of Birth');
Insert into WEBI2MS.T_OSI_DEERS_COMPARE_COLUMNS
   (I2MS_COLUMN, DEERS_COLUMN, SEQ, LABEL)
 Values
   ('FIRST_NAME', 'DEERS_FIRST_NAME', 3, 'First Name');
COMMIT;

CREATE OR REPLACE VIEW V_OSI_DEERS_COMPARE
(SID, PARTICIPANT, PARTICIPANT_VERSION, SSN, FIRST_NAME, 
 MIDDLE_NAME, LAST_NAME, CADENCY, DOB, PAY_PLAN, 
 PAY_GRADE, PAY_BAND, RANK, ADDRESS_1, ADDRESS_2, 
 CITY, STATE, ZIP, COUNTRY, ADDRESS_DISPLAY, 
 ETHNICITY, EYE_COLOR, HAIR_COLOR, HEIGHT, WEIGHT, 
 RACE, SEX, BLOOD_TYPE, SERVICE, AFFILIATION, 
 CITIZENSHIP, BIRTH_STATE, BIRTH_COUNTRY, HOME_PHONE, WORK_PHONE, 
 EMAIL, DOD, PHOTO, DEERS_ID, DEERS_FIRST_NAME, 
 DEERS_MIDDLE_NAME, DEERS_LAST_NAME, DEERS_CADENCY, DEERS_DOB, DEERS_PAY_PLAN, 
 DEERS_PAY_GRADE, DEERS_PAY_BAND, DEERS_RANK, DEERS_ADDRESS_1, DEERS_ADDRESS_2, 
 DEERS_CITY, DEERS_STATE, DEERS_ZIP, DEERS_COUNTRY, DEERS_ADDRESS_DISPLAY, 
 DEERS_ETHNICITY, DEERS_EYE_COLOR, DEERS_HAIR_COLOR, DEERS_HEIGHT, DEERS_WEIGHT, 
 DEERS_RACE, DEERS_SEX, DEERS_BLOOD_TYPE, DEERS_SERVICE, DEERS_AFFILIATION, 
 DEERS_CITIZENSHIP, DEERS_BIRTH_STATE, DEERS_BIRTH_COUNTRY, DEERS_HOME_PHONE, DEERS_WORK_PHONE, 
 DEERS_EMAIL, DEERS_DOD, DEERS_PHOTO)
AS 
select di.sid, pv.participant, pv.sid as participant_version, pv.ssn, pn.first_name,
           pn.middle_name, pn.last_name, pn.cadency, pv.dob, pv.sa_pay_plan_desc as pay_plan,
           pv.sa_pay_grade_desc as pay_grade, pv.sa_pay_band_desc as pay_band, pv.sa_rank as rank,
           current_address.address_1, current_address.address_2, current_address.city,
           current_address.state_desc as state, current_address.postal_code as zip,
           current_address.country_desc as country,
           (select display_string
                    from v_osi_partic_address
                   where participant_version=pv.sid and type_code = 'MAIL') as address_display,
           pv.ethnicity_desc as ethnicity, pv.eye_color_desc as eye_color,
           pv.hair_color_desc as hair_color, pv.height, pv.weight, pv.race_desc as race,
           pv.sex_desc as sex, pv.blood_type_desc as blood_type, pv.sa_service_desc as service,
           pv.sa_affiliation_desc as affiliation,
           (select country.description
              from t_osi_partic_citizenship pc, t_dibrs_country country
             where pv.sid = pc.participant_version(+) and pc.country = country.sid
                   and rownum = 1) as citizenship,
           osi_participant.get_birth_state(pv.sid) as birth_state,
           osi_participant.get_birth_country(pv.sid) as birth_country,
           osi_participant.get_contact_value(pv.sid, 'HOMEP') as home_phone,
           osi_participant.get_contact_value(pv.sid, 'OFFP') as work_phone,
           osi_participant.get_contact_value(pv.sid, 'EMLP') as email, pv.dod,
           (select core_util.blob_thumbnail(m.content, 300)
              from v_osi_partic_images m
             where pv.participant = m.obj(+) and m.source = 'DEERS' and create_on = (select max(create_on) from v_osi_partic_images m where pv.participant = m.obj(+) and m.source = 'DEERS')) as photo,
           di.dod_edi_pn_id as deers_id, di.first_name as deers_first_name,
           di.middle_name as deers_middle_name, di.last_name as deers_last_name,
           di.cadency as deers_cadency, di.birth_date as deers_dob,
           dibrs_reference.lookup_ref_desc('PAY_PLAN', di.pay_plan) as deers_pay_plan,
           dibrs_reference.get_pay_grade_desc(di.pay_grade) as deers_pay_grade,
           dibrs_reference.get_pay_band_desc(di.pay_band) as deers_pay_band,
           di.service_rank as deers_rank, di.addr_1 as deers_address_1,
           di.addr_2 as deers_address_2, di.addr_city as deers_city,
           dibrs_reference.get_state_desc(di.addr_state) as deers_state, di.addr_zip as deers_zip,
           dibrs_reference.get_country_desc(di.addr_country) as deers_country,
           rtrim(decode(di.addr_1, null, null, di.addr_1 || chr(13) || chr(10))
                 || decode(di.addr_2, null, null, di.addr_2 || chr(13) || chr(10))
                 || decode(di.addr_city, null, null, di.addr_city || ', ')
                 || decode(di.addr_state, null, null, di.addr_state || ' ')
                 || decode(null, null, null, ' ')
                 || decode(di.addr_zip, null, null, di.addr_zip || chr(13) || chr(10))
                 || decode(di.addr_country, null, null, '105', null, 'US', null, di.addr_country),
                 ', ' || chr(13) || chr(10)) as deers_address_display,
           dibrs_reference.lookup_ref_desc('ETHNICITY', di.ethnicity) as deers_ethnicity,
           osi_reference.lookup_ref_desc('PERSON_EYE_COLOR', di.eye_color) as deers_eye_color,
           osi_reference.lookup_ref_desc('PERSON_HAIR_COLOR', di.hair_color) as deers_hair_color,
           di.height as deers_height, di.weight as deers_weight,
           dibrs_reference.get_race_desc(di.race) as deers_race,
           dibrs_reference.lookup_ref_desc('SEX', di.sex) as deers_sex,
           osi_reference.lookup_ref_desc('PERSON_BLOOD_TYPE', di.blood_type) as deers_blood_type,
           dibrs_reference.lookup_ref_desc('SERVICE_TYPE', di.sa_service) as deers_service,
           osi_reference.lookup_ref_desc('INDIV_AFFILIATION',
                                         di.sa_affiliation) as deers_affiliation,
           dibrs_reference.get_country_desc(di.citizenship) as deers_citizenship,
           dibrs_reference.get_state_desc(di.birth_state) as deers_birth_state,
           dibrs_reference.get_country_desc(di.birth_country) as deers_birth_country,
           di.home as deers_home_phone, di.work as deers_work_phone, di.email as deers_email,
           di.decease_date as deers_dod, core_util.blob_thumbnail(di.photo, 300) as deers_photo
      from t_osi_deers_import di,
           v_osi_participant_version pv,
           v_osi_partic_name pn,
           v_osi_partic_address current_address
     where di.participant_sid = pv.participant
       and pv.current_version = pv.sid
       and pv.current_name = pn.sid(+)
       and pv.current_address = current_address.sid(+)
/

CREATE OR REPLACE VIEW V_OSI_PARTICIPANT_INDIV_TITLE
(SID, PARTICIPANT, CURRENT_VERSION, NAME, ADDRESS, 
 SEX, DOB, RACE, SSN, CONFIRMED, 
 MEMBER_OF_ORG, SERVICE, AFFILIATION, COMPONENT, PAY_PLAN, 
 PAY_GRADE, RANK, RANK_DATE, SPECIALTY_CODE, MILITARY_ORGANIZATION, DEERS_DATE)
AS 
select pv.sid, pv.participant, p.current_version, osi_participant.get_name(pv.sid) as name,
           osi_address.get_addr_display(osi_address.get_address_sid(pv.participant),
                                        null,
                                        '<br>') as address,
           dsex.description as sex, p.dob, drace.description as race,
           osi_participant.get_number(pv.sid, 'SSN') as ssn,
           osi_participant.get_confirmation(pv.sid) as confirmed,
           osi_participant.get_org_member_name(pv.sid) as member_of_org,
           dservice.description as service, r.description as affiliation,
           dcomponent.description as component, dpp.description as pay_plan,
           dpg.description as pay_grade, ph.sa_rank as rank, ph.sa_rank_date as rank_date,
           ph.sa_specialty_code as specialty_code,
           osi_participant.get_mil_member_name(pv.sid) as military_organization,
           ph.deers_date as deers_date
      from t_core_obj o,
           t_osi_participant p,
           t_osi_participant_human ph,
           t_osi_participant_version pv,
           t_osi_person_chars pc,
           t_dibrs_reference dsex,
           t_dibrs_reference dservice,
           t_dibrs_reference dcomponent,
           t_dibrs_reference dpp,
           t_dibrs_race_type drace,
           t_dibrs_pay_grade_type dpg,
           t_osi_reference r
     where o.sid = p.sid
       and p.sid = pv.participant
       and ph.sid(+) = pv.sid
       and pc.sid(+) = pv.sid
       and dservice.sid(+) = ph.sa_service
       and r.sid(+) = ph.sa_affiliation
       and dcomponent.sid(+) = ph.sa_component
       and dpp.sid(+) = pc.sa_pay_plan
       and dpg.sid(+) = pc.sa_pay_grade
       and dsex.sid(+) = pc.sex
       and drace.sid(+) = pc.race
/

-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_deers is
/******************************************************************************
   name:     osi_deers
   purpose:  Handles interfacing with DMDC DEERS system.

   revisions:
    date         author          description
    ----------   --------------  ------------------------------------
    16-Mar-2010  T.Whitehead     Copied from I2MS, modified to work,
                                 added is_searchable_number, get_import_message.
    17-Jan-2011  Tim Ward        Added DEERS_COMPARE to do Deers check now instead of doing it
                                  in page 30140.
******************************************************************************/

    /*
        GET_VALUE_OF_TAG2:  Used for testing only!  To be used in an anonymous
        block in SQL window for examining XML data.
    */
    function get_value_of_tag2(p_clob in clob, p_tag in varchar2, p_begin in integer)
        return varchar2;

    function is_searchable_number(p_num_type in varchar2)
        return varchar2;

    /*
        DELETE_IMPORT_RECORD:  This procedure is used when aborting a DEERS
        update to remove the produced record from the initial DEERS call.  We are
        currently not retaining records for each import and are instead writing
        unused data into a DEERS note attached to the person.
    */
    procedure delete_import_record(p_sid in varchar2);

    /*
        DELETE_UPDATE_FIELD:  This procedure is used to clear out data from
        the temp table that the user doesn't want to use to update the current
        participant.  Pass in a tilde separated list (with no spaces) of the table
        columns to delete and the SID from the T_OSI_DEERS_IMPORT table.
    */
    procedure delete_update_field(p_column in varchar2, p_sid in varchar2);

    /*
        GET_DEERS_INFORMATION:  This will be the main called function when
        requesting information from DEERS.
        When PNEW is 1 (new participant) the SSN will be passed into P_SSN and
        the last name into P_LAST_NAME.  When PNEW is 0 (updating current
        participant) the SID from the T_PERSON table will be passed into P_SSN
        and P_LAST_NAME will be NULL.
    */
    function get_deers_information(
        p_ssn         in   varchar2,
        p_last_name   in   varchar2,
        p_new         in   integer,
        p_numtype     in   varchar2 := 'SSN')
        return varchar2;

    -- TESTING FUNCTIONS
    function test_get_deers_information(
        p_ssn         in   varchar2,
        p_last_name   in   varchar2,
        p_new         in   integer,
        p_numtype     in   varchar2 := 'SSN')
        return varchar2;

    /*
        If importing from DEERS fails this will tell you why.
     */
    function get_import_message
        return varchar2;

    /*
        SHOW_UPDATE_LINK_BUTTON:  This function is used by the T_OSI_STATUS_CHANGE_PROC table
        and status change page 5450 to indicate whether to show the "Update Participant Links"
        button in the investigative case file.
    */
    function show_update_link_button(p_obj in varchar2)
        return varchar2;

    /*
        UPDATE_PV_LINKS:  This function is used to update person_version links to
        a case and its associated activities when closing a case file.  This is done
        to meet a new business rule.  We are only going back one year to check activities.
        Returns null if everything worked, otherwise an error message.
    */
    function update_all_pv_links(p_obj in varchar2)
        return varchar2;

    /*
        UPDATE_PERSON_WITH_DEERS:  This procedure is used at the very last when
        the user selects to update the current participant with the selected DEERS
        data.  The data from the temp table is then transferred to appropriate fields
        in the Person tables.  Returns the Person Version SID in case it creates a new one.
    */
    function update_person_with_deers(p_deers_sid in varchar2, p_participant in varchar2)
        return varchar2;

    function DEERS_COMPARE (p_sid in Varchar2, p_shown out Varchar2, p_uncheckedItems out Varchar2) return clob;
    
end osi_deers;
/


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
                    'select ' || p_type || '                    from (select ' || p_type
                    || ' from t_osi_partic_name                           where name_type = (select sid                                                from t_osi_partic_name_type                                               where code = ''L'')                           order by dbms_random.value)                   where rownum = 1';
            else
                l_sql :=
                    'select ' || p_type || '                    from (select ' || p_type
                    || ' from t_osi_partic_name                           where name_type = (select sid                                                from t_osi_partic_name_type                                               where code = ''L'')                            and '
                    || p_type
                    || ' is not null                           order by dbms_random.value)                   where rownum = 1';
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
                'select value from (select value from t_osi_partic_contact                       where type = osi_reference.lookup_ref_sid(''CONTACT_TYPE'','''
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
                    'select ' || p_column || '                         from (select ' || p_column
                    || ' from v_osi_partic_address                               order by dbms_random.value)                        where rownum = 1';
            else
                l_sql :=
                    'select ' || p_column || '                         from (select ' || p_column || ' from v_osi_partic_address where '
                    || p_column
                    || ' is not null order by dbms_random.value)                        where rownum = 1';
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


-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_OBJECT" AS
/******************************************************************************
   Name:     Osi_Object
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
     Date        Author          Description
     ----------  --------------  ------------------------------------
     17-Apr-2009 T.McGuffin      Created Package
     29-Apr-2009 T.McGuffin      Added Get_Next_Id Function.
     01-May-2009 Richard Dibble  Added Get_Status
     06-May-2009 T.McGuffin      Added Get_Objtype_Desc function.
     11-May-2009 T.Whitehead     Added Get_Address function.
     21-May-2009 Richard Dibble  Added Get_Obj_Package Procedure
     22-May-2009 T.McGuffin      Removed Get_Address.  Created Get_Address_Sid and Get_Participant_Sid
     27-May-2009 T.McGuffin      Added Create_Lead_Assignment procedure.
     29-May-2009 Richard Dibble  Added get_status_history_sid, modified get_status_sid to reference it
     01-Jun-2009 T.McGuffin      Added Get_Objtypes function.
     01-Jun-2009 T.McGuffin      Added Get_ID function.
     23-Jun-2009 Richard Dibble  Added Get_Assigned_unit
     09-Oct-2009 T.McGuffin      Added obj_context parameter to get_id (for participant versions)
     13-Oct-2009 J.Faris         Added Delete_Object
     02-Nov-2009 T.Whitehead     Added get/set_special_interest.
     02-Nov-2009 Richard Dibble  Added get_objtype_code
     17-Dec-2009 T.Whitehead     Added get_default_title.
     18-Dec-2009 T.Whitehead     Added do_title_substitution.
     28-Dec-2009 T.Whitehead     Added get_status_code.
     12-Jan-2010 T.Whitehead     Added optional parameter p_text to get_open_link.
     13-Jan-2010 T.McGuffin      Added check_writability function.
     22-Feb-2009 T.McGuffin      Added is_assigned function.
     26-Feb-2009 T.McGuffin      Added get_lead_agent function.
     24-Mar-2010 T.McGuffin      Modified get_assigned_unit function to include cfunds advances.
     27-Apr-2010 J.Horne         Modified get/set_special_interest to include only special Interests
                                 that have been marked 'I.'
     25-May-2010 T.Leighty       Added addicon, append_assoc_activities, append_involved_participants,
                                 append_attachments, append_notes, append_related_files, get_template
                                 and doc_detail.
     08-Jun-2010 T.Leighty       Modified append_involved_participants to fix bug that prevented all
                                 file types to be included.
     07-Dec-2010 Tim Ward        Added getStatusBar.
******************************************************************************/
    TYPE t_parent_list IS TABLE OF VARCHAR2(20);

    /*
     * Returns the default activity or file title for the given object type sid.
     */
    FUNCTION get_default_title(p_obj_type_sid IN VARCHAR2)
        RETURN VARCHAR2;

    /*
     * Updates the activity or file title by replacing substitution strings
     * with their respective values.
     */
    PROCEDURE do_title_substitution(p_obj IN VARCHAR2);

    /*
      * Returns the participant sid "involved" with the given object and involvement role usage.
      * This function assumes that only one participant exists for the object with the input usage.
      * Returns null if no participant is found.
      */
    FUNCTION get_participant_sid(p_obj IN VARCHAR2, p_usage IN VARCHAR2)
        RETURN VARCHAR2;

    /* Given an object sid, will return the url used to open the object
       It assumes the javascript function newWindow will be included on the source page */
    FUNCTION get_object_url(
        p_obj           IN   VARCHAR2,
        p_item_names    IN   VARCHAR2 := NULL,
        p_item_values   IN   VARCHAR2 := NULL)
        RETURN VARCHAR2;

    /* Given an object sid, will return the html link used to open the object with
       "Open" as the display HTML.  It assumes the javascript function newWindow will
        be included on the source page */
    FUNCTION get_open_link(p_obj IN VARCHAR2, p_text IN VARCHAR2 := NULL)
        RETURN VARCHAR2;

    /* Given an object sid, will return the html link used to open the object with
       the object's tagline as the display HTML.  It assumes the javascript function newWindow will
        be included on the source page */
    FUNCTION get_tagline_link(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* will return a unique id number for a new file or activity using the personnel number
       the year, day of year, and time */
    FUNCTION get_next_id
        RETURN VARCHAR2;

-- builds a colon-delimited list of special interest mission areas (sids) for a given investigation.
    FUNCTION get_special_interest(p_sid IN VARCHAR2)
        RETURN VARCHAR2;

    -- takes in a colon-delimited list of special interest mission areas (sids) for a given investigation
    -- and parses through inserting/updating/deleting the updates into the database;
    PROCEDURE set_special_interest(p_sid IN VARCHAR2, p_special_interest IN VARCHAR2);

    /* Gets the status history SID of an object */
    FUNCTION get_status_history_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* Gets the stauts code of an object. */
    FUNCTION get_status_code(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* Gets the status SID of an object */
    FUNCTION get_status_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* Gets the status DESCRIPTION of an object */
    FUNCTION get_status(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* Given an object type sid or code, return the description */
    FUNCTION get_objtype_desc(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2;

    /* Given an object type sid, return the description */
    FUNCTION get_objtype_code(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2;

    /* Gets the object specific package to call */
    FUNCTION get_obj_package(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2;

    /* Given an object sid, will assign the input personnel to the object using
       the assignment role with CODE = LEAD.  If no personnel is passed in, this
       function will use the current user (core_context.personnel_sid) */
    PROCEDURE create_lead_assignment(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL);

    /* Given an object type sid (most desireable) or an object sid, will return
       the object's type and all of its inherited types.  These are returned as
       a table of varchar2(20), and are pipelined one at a time rather than all at
       once.  The recommended way to call this would be:
                 where obj_type member of osi_object.get_objtypes(x)
        where x is an object type sid or object instance sid.
       If an object sid is passed in, core_obj.get_objtype is called initially. */
    FUNCTION get_objtypes(p_obj_or_type IN VARCHAR2)
        RETURN t_parent_list pipelined;

    /* Given an object sid, will return the ID for that object.  For files and activities,
        Osi_File.Get_ID and Osi_Activity Get_ID functions will be called respectively.
        Otherwise, the object type's method package will be used to try to call Get_ID. */
    FUNCTION get_id(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2;

    /* Takes and ACTIVITY or FILE sid and return the currently assigned unit */
    FUNCTION get_assigned_unit(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* Given an object sid, the object type's method package will be used to try to call Delete_Object */
    FUNCTION delete_object(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* Given an object sid and context (i.e. participant_version), check_writability in the object's method
       package will be called, returning Y or N indicating whether an object is editable or not */
    FUNCTION check_writability(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2;

    /* Given an object sid and optionally a personnel (otherwise the current user is used),
       this function will return Y or N indicating whether the user is assigned to the obj or not */
    FUNCTION is_assigned(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL)
        RETURN VARCHAR2;

    /* Given an object, will return the sid of the personnel assigned as the lead agent if applicable,
       and otherwise null */
    FUNCTION get_lead_agent(p_obj IN VARCHAR2)
        RETURN VARCHAR2;

    /* Adds icons to a given template. */
    FUNCTION addicon(v_template IN CLOB, p_sid IN VARCHAR2)
        RETURN CLOB;

    /* Retrieve the poper template */
    PROCEDURE get_template(p_name IN VARCHAR2, p_template IN OUT NOCOPY CLOB);

    /* Add the associated activities the to the document. */
    PROCEDURE append_assoc_activities(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2);

    /* Add a list of attachment links to the document. */
    PROCEDURE append_attachments(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2);

    /* Add involved participant links to the report. */
    PROCEDURE append_involved_participants(
        p_clob          IN OUT NOCOPY   CLOB,
        p_parent        IN              VARCHAR2,
        p_leave_blank   IN              BOOLEAN := FALSE);

    /* Add a the associated notes to the report. */
    PROCEDURE append_notes(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2);

    /* Find and append the related files to the documents. */
    PROCEDURE append_related_files(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2);

    /*  Initial parsing routine to determine appropriate report to generate.  Once the the proper report is determined    */
    /*  the coorisponding report procedure is called.                                                                     */
    PROCEDURE doc_detail(p_sid IN VARCHAR2 := NULL);

    FUNCTION getStatusBar(p_obj_sid IN VARCHAR2) RETURN VARCHAR2;
 
END Osi_Object;
/


CREATE OR REPLACE PACKAGE BODY Osi_Object AS
/******************************************************************************
   Name:     Osi_Object
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     17-Apr-2009 T.McGuffin      Created Package
     29-Apr-2009 T.McGuffin      Added Get_Next_Id Function.
     01-May-2009 Richard Dibble  Added Get_Status
     06-May-2009 T.McGuffin      Added Get_Objtype_Desc function.
     11-May-2009 T.Whitehead     Added Get_Address function.
     20-May-2009 R.Dibble        Modified Get_Status to utilize non-core tables
     21-May-2009 R. Dibble       Added Get_Obj_Package Procedure
     22-May-2009 T.McGuffin      Removed Get_Address.  Created Get_Address_Sid and Get_Participant_Sid
     27-May-2009 T.McGuffin      Added Create_Lead_Assignment procedure.
     01-Jun-2009 T.McGuffin      Added Get_Objtypes function.
     01-Jun-2009 T.McGuffin      Added Get_ID function.
     24-Aug-2009 T.McGuffin      Modified get_object_url to include optional parameters for item names and vals.
     13-Oct-2009 J.Faris         Added Delete_Object
     02-Nov-2009 T.Whitehead     Added get/set_special_interest.
     02-Nov-2009 Richard Dibble  Added get_objtype_code
     17-Dec-2009 T.Whitehead     Added get_default_title.
     18-Dec-2009 T.Whitehead     Added do_title_substitution.
     28-Dec-2009 T.Whitehead     Added get_status_code.
     12-Jan-2010 T.Whitehead     Added optional parameter p_text to get_open_link.
     13-Jan-2010 T.McGuffin      Added check_writability function.
     22-Feb-2010 T.McGuffin      Added is_assigned function.
     26-Feb-2010 T.McGuffin      Added get_lead_agent function.
     24-Mar-2010 T.McGuffin      Modified get_assigned_unit function to include cfunds advances.
     27-Apr-2010 J.Horne         Modified get/set_special_interest to include only special Interests
                                 that have been marked 'I.'
     10-May-2010 R.Dibble        Modified delete_object to always reject when the object type is UNIT
     25-May-2010 T.Leighty       Added addicon, append_assoc_activities, append_involved_participants,
                                 append_attachments, append_notes, append_related_files, get_template
                                 and doc_detail
     27-May-2010 T.Leighty       Modified append_involved_participants to use correct view table 
                                 combination in queries.
     08-Jun-2010 T.Leighty       Modified append_involved_participants to fix bug that prevented all
                                 file types to be included.
     15-Jul-2010 J.Faris         Implementing a previous update to error handling in is_assigned function.
     30-Nov-2010 J.Horne         Updated append_attachments; changed format for URL
     30-Nov-2010 Tim Ward        Changed get_next_id incase IDs are gotten in Rapid Succession.
     07-Dec-2010 Tim Ward        Added getStatusBar.
     09-Dec-2010 Richard Dibble  Modified get_object_url to forward user to a dummy page if they do not have access.
     13-Dec-2010 Richard Dibble  Modified get_object_url to supress logging
     18-Jan-2011 Tim Ward        Redid getStatusBar to not use the jixedBar.
     19-Jan-2011 Tim Ward        Added Last DEERS date to a PART.INDIV object's statusbar.
     19-Jan-2011 Tim Ward        Added core_util.get_config('OSI.IMAGE_PREFIX') to getStatusBar so we can get the correct
                                 #IMAGE_DIR# value for the Min/Max.gif buttons.
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_OBJECT';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;
    
    FUNCTION get_default_title(p_obj_type_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT default_title
                    FROM T_OSI_OBJ_TYPE
                   WHERE SID = p_obj_type_sid)
        LOOP
            RETURN x.default_title;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_default_title: ' || SQLERRM);
    END get_default_title;
    
    PROCEDURE do_title_substitution(p_obj IN VARCHAR2) IS
        v_objcode   T_CORE_OBJ_TYPE.code%TYPE;
        v_updated   VARCHAR2(4000);
        v_sid       T_CORE_OBJ.SID%TYPE;
    BEGIN
        SELECT code
          INTO v_objcode
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        /*
         * Any object types that need special processing should have a case statement
         * that is above 'ACT%' added for them.
         */
        CASE
            WHEN v_objcode LIKE 'ACT.AAPP%' THEN
                BEGIN
                    SELECT file_sid
                      INTO v_sid
                      FROM T_OSI_ASSOC_FLE_ACT
                    WHERE activity_sid = p_obj;
                    
                    v_updated := Osi_Util.do_title_substitution(v_sid, Osi_Activity.get_title(p_obj));
                    v_updated := Osi_Util.do_title_substitution(p_obj, v_updated);
                    
                    UPDATE T_OSI_ACTIVITY
                       SET title = v_updated
                     WHERE SID = p_obj;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- This should never happen.
                        log_error('do_title_substitution: - Error in ACT.AAPP% case - ' || SQLERRM);
                 END;
                 
            WHEN v_objcode LIKE 'ACT%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_Activity.get_title(p_obj));

                UPDATE T_OSI_ACTIVITY
                   SET title = v_updated
                 WHERE SID = p_obj;

            WHEN v_objcode LIKE 'FILE%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_File.get_title(p_obj), 'T_OSI_FILE');

                UPDATE T_OSI_FILE
                   SET title = v_updated
                 WHERE SID = p_obj;
        END CASE;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('do_title_substitution: ' || SQLERRM);
    END do_title_substitution;

    FUNCTION get_participant_sid(p_obj IN VARCHAR2, p_usage IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_OSI_PARTICIPANT.SID%TYPE;
    BEGIN
        IF p_obj IS NOT NULL AND p_usage IS NOT NULL THEN
            SELECT i.participant_version
              INTO v_rtn
              FROM T_OSI_PARTIC_INVOLVEMENT i, T_OSI_PARTIC_ROLE_TYPE ir
             WHERE i.involvement_role = ir.SID AND i.obj = p_obj AND ir.USAGE = p_usage;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN v_rtn;
        WHEN OTHERS THEN
            log_error('get_participant_sid: ' || SQLERRM);
            RAISE;
    END get_participant_sid;

    FUNCTION get_object_url(
        p_obj           IN   VARCHAR2,
        p_item_names    IN   VARCHAR2 := NULL,
        p_item_values   IN   VARCHAR2 := NULL)
    RETURN VARCHAR2 IS
        v_url   VARCHAR2(200);
        v_obj            T_CORE_OBJ.SID%TYPE;
        v_obj_context    T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
    
        --See if this person has access first
        IF (Osi_Auth.Check_Access(p_obj, p_supress_logging=>TRUE) = 'N') THEN
            --They do not, so do not give them the URL
            v_url := 'javascript:newWindow({page:120,clear_cache:'''',name:'''',item_names:''P120_OBJ'',item_values:''' || p_obj || ','',request:''OPEN''})';
            RETURN v_url;
        END IF;
    
        v_obj := p_obj;
        -- Determine if the given p_obj is an obj sid or a participant version sid.
        FOR x IN (SELECT SID, participant
                    FROM v_osi_participant_version
                   WHERE SID = p_obj)
        LOOP
            v_obj := x.participant;
            v_obj_context := x.SID;
        END LOOP;
        
        SELECT 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
                   || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                   || DECODE(p_item_names, NULL, NULL, ',' || p_item_names) || ''',item_values:'''
                   || v_obj || ',' || v_obj_context || DECODE(p_item_values, NULL, NULL, ',' || p_item_values)
                   || ''',request:''OPEN''})'
              INTO v_url
              FROM T_CORE_DT_OBJ_TYPE_PAGE
             WHERE obj_type MEMBER OF Osi_Object.get_objtypes(v_obj) AND page_function = 'OPEN';
        RETURN v_url;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_object_url: ' || SQLERRM);
            RETURN('get_object_url: Error');
    END get_object_url;

    FUNCTION get_open_link(p_obj IN VARCHAR2, p_text IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn VARCHAR2(200);
    BEGIN
        IF p_obj IS NOT NULL THEN
            v_rtn := '<!--' || p_obj || '--><a href="' || get_object_url(p_obj) || '">';
            IF(p_text IS NULL)THEN
                v_rtn := v_rtn || 'Open</a>';
            ELSE
                v_rtn := v_rtn || p_text || '</a>';
            END IF;
            RETURN v_rtn;
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_open_link: ' || SQLERRM);
            RETURN('get_open_link: Error');
    END get_open_link;

    FUNCTION get_tagline_link(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF p_obj IS NOT NULL THEN
            RETURN '<!--' || Core_Obj.get_tagline(p_obj) || '--><a href="' || get_object_url(p_obj)
                  || '">' || Core_Obj.get_tagline(p_obj) || '</a>';
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline_link: ' || SQLERRM);
            RETURN('get_tagline_link: Error');
    END get_tagline_link;

    FUNCTION get_next_id
        RETURN VARCHAR2 IS
        v_personnel_num T_CORE_PERSONNEL.personnel_num%TYPE := NVL(Core_Context.personnel_num, '00000');
        v_year          NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'yy'));
        v_doy           NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'ddd'));
        v_hours         NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'hh24'));
        v_minutes       NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'mi'));
        v_tmp_id        T_OSI_FILE.ID%TYPE                  := NULL;
        v_exists        NUMBER                              := 1;
    BEGIN
         LOOP
             v_tmp_id := LTRIM(RTRIM(TO_CHAR(v_personnel_num,'00000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_year,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_doy,'000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_hours,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_minutes,'00')));

             BEGIN
                 SELECT 1
                   INTO v_exists
                   FROM dual
                  WHERE EXISTS(SELECT 1
                                 FROM (SELECT ID
                                         FROM T_OSI_FILE
                                       UNION ALL
                                       SELECT ID
                                         FROM T_OSI_ACTIVITY) o
                                WHERE o.ID = v_tmp_id);
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     EXIT;
             END;

             v_minutes := v_minutes - 1;

             IF v_minutes < 0 THEN
                
               v_hours := v_hours - 1;
                
               IF v_hours < 0 THEN
                  
                 v_doy := v_doy - 1;
                
                 IF v_doy < 0 THEN
                  
                   v_doy := 365;
                  
                 END IF;
                
                 v_hours := 23;
                  
               END IF;
                
               v_minutes := 59;
                
              END IF;
            
          END LOOP;

          RETURN v_tmp_id;
          
    END get_next_id;

    FUNCTION get_special_interest(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_array    apex_application_global.vc_arr2;
        v_idx      INTEGER                         := 1;
        v_string   VARCHAR2(4000);
    BEGIN
        FOR i IN (SELECT mission
                    FROM T_OSI_MISSION
                   WHERE obj = p_sid
                    AND obj_context = 'I')
        LOOP
            v_array(v_idx) := i.mission;
            v_idx := v_idx + 1;
        END LOOP;

        v_string := apex_util.table_to_string(v_array, ':');
        RETURN v_string;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_special_interest: ' || SQLERRM);
            RAISE;
    END get_special_interest;

    PROCEDURE set_special_interest(p_sid IN VARCHAR2, p_special_interest IN VARCHAR2) IS
        v_array    apex_application_global.vc_arr2;
        v_string   VARCHAR2(4000);
    BEGIN
        v_array := apex_util.string_to_table(p_special_interest, ':');

        FOR i IN 1 .. v_array.COUNT
        LOOP
            INSERT INTO T_OSI_MISSION
                        (obj, mission, obj_context)
                SELECT p_sid, v_array(i), 'I'
                  FROM dual
                 WHERE NOT EXISTS(SELECT 1
                                    FROM T_OSI_MISSION
                                   WHERE obj = p_sid AND mission = v_array(i) AND obj_context = 'I');
        END LOOP;

        DELETE FROM T_OSI_MISSION
              WHERE obj = p_sid AND INSTR(NVL(p_special_interest, 'null'), mission) = 0;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('set_special_interest: ' || SQLERRM);
            RAISE;
    END set_special_interest;
    
    /* Gets the status history SID of an object */
    FUNCTION get_status_history_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR k IN (SELECT SID
                    FROM T_OSI_STATUS_HISTORY
                   WHERE obj = p_obj AND is_current = 'Y')
        LOOP
            RETURN k.SID;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in get_status_history_sid function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_history_sid;
    
    FUNCTION get_status_code(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT s.code
                    FROM T_OSI_STATUS_HISTORY sh, T_OSI_STATUS s
                   WHERE sh.SID = get_status_history_sid(p_obj)
                     AND sh.status = s.SID)
        LOOP
            RETURN x.code;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status_code: ' || SQLERRM);
            RETURN NULL;
    END get_status_code;

    FUNCTION get_status_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR a IN (SELECT status
                    FROM T_OSI_STATUS_HISTORY
                   WHERE SID = get_status_history_sid(p_obj))
        LOOP
            RETURN a.status;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in GET_STATUS function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_sid;

    FUNCTION get_status(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_status   T_OSI_STATUS.description%TYPE;
    BEGIN
        IF p_obj IS NULL THEN
            log_error('get_status: null parameter passed');
            RETURN NULL;
        END IF;

        SELECT description
          INTO v_status
          FROM T_OSI_STATUS
         WHERE SID = get_status_sid(p_obj);

        RETURN v_status;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status: ' || SQLERRM || ' ~ ' || p_obj);
            RETURN NULL;
    END get_status;

    FUNCTION get_objtype_desc(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_description   T_CORE_OBJ_TYPE.description%TYPE;
    BEGIN
        SELECT description
          INTO v_description
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type
            OR code = p_obj_type;

        RETURN v_description;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_desc: ' || SQLERRM);
            RETURN('get_objtype_desc: Error');
    END get_objtype_desc;
    
        FUNCTION get_objtype_code(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   T_CORE_OBJ_TYPE.code%TYPE;
    BEGIN
        SELECT code
          INTO v_return
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_code: ' || SQLERRM);
            RETURN('get_objtype_code: Error');
    END get_objtype_code;

    /* Gets the object specific package to call */
    FUNCTION get_obj_package(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_package   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        SELECT method_pkg
          INTO v_package
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_package;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_obj_package: ' || SQLERRM);
            RAISE;
    END get_obj_package;

    PROCEDURE create_lead_assignment(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL) IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        IF p_obj IS NOT NULL THEN
            INSERT INTO T_OSI_ASSIGNMENT
                        (obj, personnel, unit, start_date, assign_role)
                 VALUES (p_obj,
                         v_personnel,
                         Osi_Personnel.get_current_unit(v_personnel),
                         SYSDATE,
                         (SELECT SID
                            FROM T_OSI_ASSIGNMENT_ROLE_TYPE
                           WHERE obj_type MEMBER OF get_objtypes(p_obj) AND code = 'LEAD'));
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_lead_assignment: ' || SQLERRM);
            RAISE;
    END create_lead_assignment;

    /* pipelines records of type t_parent_list one at a time.
       finds the input object type first, including this in the list.
       then it return the parent object type, and the parent's parent, etc.. */
    FUNCTION get_objtypes(p_obj_or_type IN VARCHAR2)
        RETURN t_parent_list pipelined IS
        v_tmp_parent    T_OSI_OBJ_TYPE.PARENT%TYPE;
        v_tmp_objtype   T_OSI_OBJ_TYPE.SID%TYPE;
    BEGIN
        v_tmp_objtype := Core_Obj.get_objtype(p_obj_or_type);

        IF v_tmp_objtype IS NULL THEN
            v_tmp_objtype := p_obj_or_type;
        END IF;

        LOOP
        BEGIN
            pipe ROW(v_tmp_objtype);

            SELECT PARENT
              INTO v_tmp_parent
              FROM T_OSI_OBJ_TYPE
             WHERE SID = v_tmp_objtype;

            EXIT WHEN v_tmp_parent IS NULL;
            v_tmp_objtype := v_tmp_parent;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            EXIT;
        END;
        END LOOP;

        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('get_objtypes: ' || SQLERRM);
            RETURN;
    END get_objtypes;

    FUNCTION get_id(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        SELECT method_pkg, code
          INTO v_method_pkg, v_type_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        IF v_type_code LIKE 'ACT.%' THEN
            RETURN Osi_Activity.get_id(p_obj);
        ELSIF v_type_code LIKE 'FILE.%' THEN
            RETURN Osi_File.get_id(p_obj);
        ELSIF v_method_pkg IS NULL THEN
            RETURN NULL;
        ELSE
            BEGIN
                EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.get_id(:obj,:context); end;'
                        USING OUT v_rtn, IN p_obj, IN p_obj_context;
                RETURN v_rtn;
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN NULL;
            END;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'invalid object type';
        WHEN OTHERS THEN
            RETURN 'untrapped error';
    END get_id;
    
    /* Takes and ACTIVITY or FILE sid and return the currently assigned unit */
    FUNCTION get_assigned_unit(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(20);
    --This function is assuming an object will always have an assignment of some type
    BEGIN
        --See if it is an activity
        FOR k IN (SELECT assigned_unit
                    FROM T_OSI_ACTIVITY
                   WHERE SID = p_obj)
        LOOP
            --An activity was found, send back the unit.
            RETURN k.assigned_unit;
        END LOOP;

        FOR k IN (SELECT SID FROM T_OSI_FILE WHERE SID = p_obj)
        LOOP
            RETURN Osi_File.get_unit_owner(p_obj);
        END LOOP;

        FOR k IN (SELECT unit FROM T_CFUNDS_ADVANCE_V2 WHERE SID = p_obj) LOOP
            RETURN k.unit;
        END LOOP;
        
        RETURN '<none>';
    EXCEPTION
        WHEN OTHERS THEN
            log_error(SQLERRM);
            RAISE;
    END get_assigned_unit;
    
    /* Performs deletion operation for all objects */
    FUNCTION delete_object(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn      VARCHAR2(200)             := NULL;
        v_ot       VARCHAR2(20)              := NULL;
        v_ot_cd    VARCHAR2(200)             := NULL;

    BEGIN
        v_ot := Core_Obj.get_objtype(p_obj);

        IF v_ot IS NULL THEN
            log_error('Delete_Object: Error locating Object Type for '
                               || NVL(v_ot, 'NULL'));
            RETURN 'Invalid Object passed to Delete_Object';
        END IF;

   SELECT code 
        INTO v_ot_cd 
        FROM T_CORE_OBJ_TYPE 
       WHERE SID = v_ot;

   CASE 
           WHEN SUBSTR(v_ot_cd,1,3) = 'ACT' THEN
         v_rtn := Osi_Activity.can_delete(p_obj);
           WHEN SUBSTR(v_ot_cd,1,4) = 'FILE' THEN
               v_rtn := Osi_File.can_delete(p_obj);
           WHEN SUBSTR(v_ot_cd,1,4) = 'PART' THEN
               v_rtn := Osi_Participant.can_delete(p_obj);
           WHEN v_ot_cd = 'CFUNDS_ADV' THEN
               v_rtn := Osi_Cfunds_Adv.can_delete(p_obj);
           WHEN v_ot_cd = 'CFUNDS_EXP' THEN
               v_rtn := Osi_Cfunds.can_delete(p_obj);
           WHEN v_ot_cd = 'UNIT' THEN
               --Can never delete units, if this changes, will need to make a OSI_UNIT.CAN_DELETE() function
               v_rtn := 'N';
           ELSE v_rtn := 'Y';
      END CASE;

   IF v_rtn <> 'Y' THEN
           RETURN v_rtn;
      END IF;
    
      --execute the delete, all object-specific and child table deletions will cascade
   DELETE FROM T_CORE_OBJ WHERE SID = p_obj;

   RETURN 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            log_error('Delete_Object: Error encountered using Object '
                               || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in Delete_Object using Object: ' || NVL(p_obj, 'NULL');
    END delete_object;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        
        SELECT method_pkg, code
          INTO v_method_pkg, v_type_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        IF v_type_code LIKE 'ACT.%' THEN
            RETURN Osi_Activity.check_writability(p_obj);
        ELSE
            BEGIN
                EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.check_writability(:obj,:context); end;'
                        USING OUT v_rtn, IN p_obj, IN p_obj_context;
                RETURN v_rtn;
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN 'Y';
            END;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('osi_object.check_writability: invalid object type');
        WHEN OTHERS THEN
            log_error('osi_object.check_writablity: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION is_assigned(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        FOR x IN (SELECT 'Y' AS result
                    FROM T_OSI_ASSIGNMENT
                   WHERE obj = p_obj
                     AND personnel = v_personnel
                     AND SYSDATE BETWEEN NVL(start_date, TO_DATE('01011901', 'mmddyyyy'))
                                     AND NVL(end_date, TO_DATE('12312999', 'mmddyyyy')))
        LOOP
            RETURN x.result;
        END LOOP;
        
        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.is_assigned: ' || SQLERRM);
            RAISE;
    END is_assigned;

    FUNCTION get_lead_agent(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR i IN (SELECT oa.personnel
                    FROM T_OSI_ASSIGNMENT oa, 
                         T_OSI_ASSIGNMENT_ROLE_TYPE oart
                   WHERE oa.obj = p_obj
                     AND oa.assign_role = oart.SID 
                     AND oart.code = 'LEAD'
                ORDER BY oa.end_date DESC)
        LOOP
            RETURN i.personnel;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.get_lead_agent: ' || SQLERRM);
            RAISE;
    END get_lead_agent;


--======================================================================================================================
--======================================================================================================================
    FUNCTION addicon(v_template IN CLOB, p_sid IN VARCHAR2)
        RETURN CLOB IS
        v_rtn        CLOB           := NULL;
        v_iconlink   VARCHAR2(1000);
        v_inifile    VARCHAR2(128);
        v_vlturl     VARCHAR2(1000);
    BEGIN

        SELECT setting                                                                       --value
          INTO v_inifile
          FROM T_CORE_CONFIG
         WHERE code = 'DEFAULTINI';

        v_iconlink :=
            '<A HREF="I2MS:://pSid=' || p_sid || ' ' || v_inifile
            || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="\images\I2MS\OBJ_SEARCH\i2ms.gif"></A>&nbsp&nbsp';
        IF    Core_Util.get_config('OSI_VLT_URL_JSP') IS NOT NULL
           OR Core_Util.get_config('OSI_VLT_URL_OWA') IS NOT NULL THEN

        v_iconlink :=
            v_iconlink || '<A HREF="' || v_vlturl
            || '"><IMG BORDER=0 ALT="Launch Visual Link Tool" SRC="\images\I2MS\OBJ_SEARCH\vlt.gif"></A>&nbsp&nbsp';

        END IF;
        IF    v_template = ''
           OR v_template IS NULL THEN
            v_rtn := v_iconlink;
        ELSE
            SELECT REPLACE(v_template, '<h2>', '<h2>' || v_iconlink)
              INTO v_rtn
              FROM dual;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.AddIcon Error: ' || SQLERRM);
            RETURN v_template;
    END addicon;

--======================================================================================================================
--   Retrieve the poper template                                                                                      ==
--======================================================================================================================

    PROCEDURE get_template(p_name IN VARCHAR2, p_template IN OUT NOCOPY CLOB) IS
        v_date              DATE;
        v_ok                VARCHAR2(256);
        v_prefix            VARCHAR2(20) := 'osi_';
        v_mime_type         T_CORE_TEMPLATE.mime_type%TYPE;
        v_mime_disposition  T_CORE_TEMPLATE.mime_disposition%TYPE;
    BEGIN

        v_ok := Core_Template.get_latest(v_prefix || p_name, p_template, v_date, v_mime_type, v_mime_disposition);

        IF v_date IS NULL THEN                                         -- try it without the prefix
            v_ok := Core_Template.get_latest(p_name, p_template, v_date, v_mime_type, v_mime_disposition);

            IF v_date IS NULL THEN

                RAISE_APPLICATION_ERROR(-20200,
                                        'Could not locate template "' || v_prefix || p_name || '"');
            END IF;
        END IF;

    END get_template;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_assoc_activities(
        p_doc      IN OUT NOCOPY   CLOB,
        p_parent   IN              VARCHAR2) IS

        v_cnt    NUMBER;
        v_temp   VARCHAR2(5000);

    BEGIN
        v_cnt := 0;

        FOR h IN (SELECT activity_sid, activity_id, activity_title
                    FROM v_osi_assoc_fle_act
                   WHERE file_sid = p_parent)
        LOOP
            IF (   (Core_Classification.has_hi(h.activity_sid, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.activity_sid, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Assoc_Activities: Object is ORCON or LIMDIS - User does not have permission to view document '
                     || 'therefore no link will be generated');
            ELSE
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
            v_temp := v_temp || Osi_Object.get_tagline_link(h.activity_sid);
            v_temp := v_temp || ', ' || h.activity_title || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;
    END append_assoc_activities;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_attachments(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_cnt2   NUMBER         := 0;
        v_temp   VARCHAR2(5000);

    BEGIN

        FOR h IN (SELECT a.SID, 
                           AT.USAGE, 
                           NVL(a.description, AT.description) AS desc_type,
                           NVL(dbms_lob.getlength(a.content), 0) AS blob_length
                      FROM T_OSI_ATTACHMENT a,
                           T_OSI_ATTACHMENT_TYPE AT,
                           T_CORE_OBJ o,
                           T_CORE_OBJ_TYPE ot
                     WHERE a.obj = p_parent
                       AND a.obj = o.SID
                       AND a.TYPE = AT.SID(+)
                       AND o.obj_type = ot.SID
                       AND NVL(AT.USAGE, 'ATTACHMENT') = 'ATTACHMENT'
                  ORDER BY a.modify_on)
        LOOP
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD><B>' || v_cnt || ':</B> </TD>';
            v_temp := v_temp || '<TD width="100%">';

            IF h.blob_length > 0 THEN
                --v_temp := v_temp || '<a href="docs/' || h.sid || '">';
                v_temp := v_temp || '<a href="f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':'
                                || h.SID || ':' || v('DEBUG') || ':250: " target="blank"/>';
            END IF;

            -- If there is no description then put something
            IF h.desc_type IS NULL THEN
                v_temp := v_temp || h.SID;
            ELSE
                v_temp := v_temp || h.desc_type;
            END IF;

            IF h.blob_length > 0 THEN
              v_temp := v_temp || '</a>';
            END IF;

            v_temp := v_temp || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
        END LOOP;
        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.Append_Attachments Error: ' || SQLERRM);
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
    END append_attachments;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_involved_participants(
        p_clob         IN OUT NOCOPY   CLOB,
        p_parent       IN              VARCHAR2,
        p_leave_blank  IN              BOOLEAN := FALSE) IS

        v_object_type   VARCHAR2(4);

    BEGIN
      SELECT SUBSTR(ot.code, 1, 4)
        INTO v_object_type
        FROM T_CORE_OBJ o,
             T_CORE_OBJ_TYPE ot
       WHERE o.SID = p_parent
         AND o.obj_type = ot.SID;

      CASE v_object_type
      WHEN 'FILE'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT fi.ROLE,
                           pv.participant
                      FROM v_osi_partic_file_involvement fi,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = fi.participant_version
                       AND fi.file_sid = p_parent
                  ORDER BY fi.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      WHEN 'ACT.'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT ai.ROLE,
                           pv.participant
                      FROM v_osi_partic_act_involvement ai,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = ai.participant_version
                       AND ai.activity = p_parent
                 ORDER BY ai.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      ELSE
        IF NOT p_leave_blank 
          THEN
            Osi_Util.aitc(p_clob, '<tr><td>No data found</td></tr>');
        END IF;
      END CASE;
    

    END append_involved_participants;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_notes(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt   NUMBER := 0;
    BEGIN

        v_cnt := 0;

        FOR n IN (SELECT n.modify_on, 
                      nt.description,
                      n.note_text
                 FROM T_OSI_NOTE n,
                      T_OSI_NOTE_TYPE nt
                WHERE n.obj = p_parent
                  AND n.note_type = nt.SID
             ORDER BY n.modify_on DESC)
        LOOP
            v_cnt := v_cnt + 1;
            Osi_Util.aitc(p_doc,
                 '<TR><TD width="100%"><B>' || v_cnt || ': NOTE (' || n.description || ', '
                 || TO_CHAR(n.modify_on, 'dd-Mon-YY hh24:mi:ss') || ')</B><BR>');
            dbms_lob.append(p_doc, Core_Util.html_ize(n.note_text));
            Osi_Util.aitc(p_doc, CHR(13) || CHR(10) || '</TD></TR>');
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD>No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Util.append_info_to_clob(p_doc,
                                '<TR><TD width="100%">No Data Found</TD></TR>' || CHR(13) || CHR(10)
                                || '</table></body>' || CHR(13) || CHR(10),
                                '');
    END append_notes;


--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_related_files(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_temp   VARCHAR2(5000);
    BEGIN

        FOR h IN (SELECT af.file_a AS related_file,
                        (SELECT ID
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS ID,
                        (SELECT title
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS title,
                        (SELECT sot.description
                           FROM T_CORE_OBJ so,
                                T_CORE_OBJ_TYPE sot
                          WHERE so.SID = af.file_a
                            AND so.obj_type = sot.SID) AS description
                   FROM T_OSI_FILE f,
                        T_OSI_ASSOC_FLE_FLE af,
                        T_CORE_OBJ o,
                        T_CORE_OBJ_TYPE ot
                  WHERE f.SID = p_parent
                    AND f.SID = o.SID
                    AND f.SID = af.file_b
                    AND o.obj_type = ot.SID 
                  UNION 
                 SELECT af.file_b AS related_file,
                       (SELECT ID
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS ID,
                       (SELECT title
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS title,
                       (SELECT sot.description
                          FROM T_CORE_OBJ so,
                               T_CORE_OBJ_TYPE sot
                         WHERE so.SID = af.file_b
                           AND so.obj_type = sot.SID) AS description
                  FROM T_OSI_FILE f,
                       T_OSI_ASSOC_FLE_FLE af,
                       T_CORE_OBJ o,
                       T_CORE_OBJ_TYPE ot
                 WHERE f.SID = p_parent
                   AND f.SID = o.SID
                   AND f.SID = af.file_a
                   AND o.obj_type = ot.SID 
              ORDER BY ID)
        LOOP
            IF ((Core_Classification.has_hi(h.related_file, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.related_file, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Related_Files: Object is ORCON or LIMDIS - User does not have permission to view document therefore no link will be generated');
            ELSE
                v_cnt := v_cnt + 1;
                v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
                v_temp := v_temp || Osi_Object.get_tagline_link(h.related_file) || ', ';
                v_temp := v_temp || h.title || ', ' || h.description;
                v_temp := v_temp || '</TD></TR>';
                Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;

    END append_related_files;


--======================================================================================================================
--  Initial parsing routine to determine appropriate report to generate.  Once the the proper report is determined    ==
--  the coorisponding report procedure is called.                                                                     ==
--======================================================================================================================
    PROCEDURE doc_detail(p_sid IN VARCHAR2 := NULL) IS

        v_ok           VARCHAR2(1000);
        v_doc          CLOB;
        v_obj_type     T_CORE_OBJ_TYPE.code%TYPE;
        v_authorized   VARCHAR2(10);                             -- can the user run a search
        v_restrict     VARCHAR2(10);                             -- For checking restricted objects
        v_cookie       VARCHAR2(100)   := NULL;

    BEGIN

        BEGIN
            -- restricted files and activities should not be displayed
            v_obj_type := NULL;
            v_restrict := NULL;

            SELECT SUBSTR(ot.code, 1, 3)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'ACT' THEN

                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_ACTIVITY a,
                       T_OSI_REFERENCE r
                 WHERE a.SID = p_sid
                   AND a.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This activity is restricted.');
                    RETURN;
                END IF;
            END IF;

            SELECT SUBSTR(ot.code, 1, 4)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'FILE' THEN
                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_FILE f,
                       T_OSI_REFERENCE r
                 WHERE f.SID = p_sid
                   AND f.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This file is restricted.');
                    RETURN;
                END IF;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;                                                 -- Continue processing
        END;

        -- there are calls from other procedures that do not set up the links to pass obj_type.
        -- therefore the need to make sure there is one. Hopefully.
        SELECT ot.code
          INTO v_obj_type
          FROM T_CORE_OBJ o,
               T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_sid
           AND o.obj_type = ot.SID;

        Core_Util.append_info_to_clob(v_doc, CHR(10), '');

        IF SUBSTR(v_obj_type, 1, 3) = 'ACT'
          THEN Osi_Activity.make_doc_act(p_sid, v_doc);   -- Activity Report
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART'
              THEN Osi_Participant.run_report_details(p_sid); -- Participant Report
              ELSE
                IF SUBSTR(v_obj_type, 1, 8) = 'FILE.INV'
                  THEN Osi_Investigation.make_doc_investigative_file(p_sid, v_doc); -- Investigative File Report
                  ELSE Osi_File.make_doc_misc_file(p_sid, v_doc); -- General File Report
                END IF;
            END IF;
        END IF;


        IF dbms_lob.getlength(v_doc) > 10 
          THEN
            v_ok := Core_Util.serve_clob(v_doc);
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART' 
              THEN NULL;
              ELSE htp.print('<html><head><title>No Document Exists</title></head>'
                      || '<body>No document currently exists for this object.</body></html>');
           END IF;
        END IF;

        Core_Util.cleanup_temp_clob(v_doc);
    END doc_detail;
 
    FUNCTION getStatusBar(p_obj_sid IN VARCHAR2) RETURN VARCHAR2 IS

        v_return VARCHAR2(4000);
        v_type_descr VARCHAR2(200);
        v_create_on VARCHAR2(200);
        v_status VARCHAR2(200);
        v_type_code VARCHAR2(200);
        v_tag VARCHAR2(200);
        v_obtained_by VARCHAR2(200);
        v_personnel_name VARCHAR2(200);
        v_unit_name VARCHAR2(200);
        v_suffix VARCHAR2(200);
        v_obj_type_sid VARCHAR2(200);
        v_obj_act_type_sid VARCHAR2(200);
        v_obj_fle_type_sid VARCHAR2(200);
        v_photo_count VARCHAR2(200);
        v_photo_size VARCHAR2(200);
        v_photo_tab_sid VARCHAR2(200);
        v_deers_date VARCHAR2(200);
        
    BEGIN
         IF p_obj_sid IS NULL OR p_obj_sid='' THEN
    
           RETURN '';
     
         END IF;
   
         --- Get the Object Type Sid for ALL Activities ---
         BEGIN
              SELECT SID INTO v_obj_act_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='ACT';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_act_type_sid := '*unknown*';
      
         END;

         --- Get the Object Type Sid for ALL Files ---
         BEGIN
              SELECT SID INTO v_obj_fle_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='FILE';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_fle_type_sid := '*unknown*';
      
         END;

         --- Get the Type Code and Sid for the Current Object (p_obj_sid) ---
         BEGIN
              SELECT CODE,T.SID INTO v_type_code,v_obj_type_sid FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_code := '*unknown*';
      
         END;

         IF v_type_code IN ('EMM','UNIT','*unknown*') THEN
       
           RETURN '';
     
         END IF;
      
         --- Get Status for C-Funds Expense Objects ---
         IF v_type_code = 'CFUNDS_EXP' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_expense_v3 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for C-Funds Advance Objects ---
         ELSIF v_type_code = 'CFUNDS_ADV' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_advance_v2 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for All Other Objects ---
         ELSE
   
           BEGIN
                SELECT Osi_Object.get_status(p_obj_sid) INTO v_status FROM dual;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;
     
         END IF;
   
         --- Fix the Working for Pariticpant Confirmed/Unconfirmed ---
         IF v_status IN ('Confirm','Unconfirm') THEN
      
           v_status := v_status || 'ed';
     
         END IF;
   
         --- Get Object Type Description ---
         BEGIN
              SELECT description INTO v_type_descr FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_descr := '*unknown*';
      
         END;

         --- Get Create On Date ---
         BEGIN
              SELECT TO_CHAR(create_on,'dd-Mon-yyyy') INTO v_create_on FROM T_CORE_OBJ WHERE SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_create_on := '*unknown*';
      
         END;

         --- Get Activity Or File Suffix so we will say "Search Activity" instead of just "Search" ---
         BEGIN
              SELECT ' Activity' INTO v_suffix FROM dual WHERE v_obj_act_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
         EXCEPTION WHEN OTHERS THEN
            
            v_suffix := '';
      
         END;
   
         --- Get Activity Or File Suffix so we will say "Case File" instead of just "Case" ---
         IF v_suffix = '' OR v_suffix IS NULL THEN

           BEGIN
                SELECT ' File' INTO v_suffix FROM dual WHERE v_obj_fle_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
           EXCEPTION WHEN OTHERS THEN
            
                         v_suffix := '';
      
           END;
     
         END IF;
   
         --- Make sure we don't say "Security Polygrpah File File" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-4,5) = ' File' THEN
     
           v_suffix := '';
     
         END IF;

         --- Make sure we don't say "Agent Application Activity - Education Activity Activity" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-8,9) = ' Activity' THEN
     
           v_suffix := '';
     
         END IF;
   
         IF v_type_code = 'EVIDENCE' THEN
           
           BEGIN
                SELECT SUBSTR(DESCRIPTION,1,50),TO_CHAR(OBTAINED_DATE,'dd-Mon-yyyy'),STATUS,TAG_NUMBER,OBTAINED_BY
                      INTO v_type_descr,v_create_on,v_status,v_tag,v_obtained_by FROM v_osi_evidence WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
              
                    RETURN '';
     
           END;

           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || ' <small>Description</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_create_on || ' <small>Obtained on</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_tag || ' <small>Tag #</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_obtained_by || ' <small>Obtained By</small></li>' || CHR(10) || CHR(13);

         ELSIF v_type_code = 'PERSONNEL' THEN
           
              BEGIN
                   SELECT DECODE(PERSONNEL_STATUS,'CL','Closed','OP','Open','SU','Suspended','Unknown'),TO_CHAR(STATUS_DATE,'dd-Mon-yyyy'),PERSONNEL_NAME,UNIT_NAME
                         INTO v_type_descr,v_create_on,v_personnel_name,v_unit_name FROM v_osi_personnel WHERE SID=p_obj_sid;
     
              EXCEPTION WHEN OTHERS THEN
              
                       RETURN '';
     
              END;  
      
              v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
              v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Status: ' || v_type_descr || ' <small>Status</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Effective: ' || v_create_on || ' <small>Effective</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Agent: ' || v_personnel_name || ' <small>Agent Name</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Unit: ' || v_unit_name || ' <small>Assigned To</small></li>' || CHR(10) || CHR(13);

         ELSE
  
           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || v_suffix || ' <small>Object Type</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Created on ' || v_create_on || ' <small>Create Date</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Status is ' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
     
           IF v_type_code = 'PART.INDIV' THEN
             
             BEGIN
                  SELECT COUNT(*),Osi_Util.parse_size(SUM(DBMS_LOB.GETLENGTH(CONTENT))) INTO v_photo_count,v_photo_size FROM T_OSI_ATTACHMENT A,T_OSI_ATTACHMENT_TYPE T WHERE A.TYPE=T.SID AND T.USAGE='MUGSHOT' AND A.OBJ=p_obj_sid;

                  IF v_photo_count = '1' THEN
        
                    v_photo_count := v_photo_count || ' Photo';
      
                  ELSE

                    v_photo_count := v_photo_count || ' Photos';
         
                  END IF;
            
             EXCEPTION WHEN OTHERS THEN
    
                      v_photo_count := '0';
                      v_photo_size := '0 KB';
    
             END;
             
             BEGIN
                  SELECT SID INTO v_photo_tab_sid FROM T_OSI_TAB WHERE tab_label='Photo/Image';

             EXCEPTION WHEN OTHERS THEN

                      v_photo_tab_sid := '2220000077I';

             END;
    
             v_return := v_return || '  <li><a href=javascript:goToTab(''' || v_photo_tab_sid || '''); return false;>' || v_photo_count || '/' || v_photo_size || '</a> <small>Photos/Size</small></li>' || CHR(10) || CHR(13);

             BEGIN
                  SELECT nvl(MAX(to_char(DEERS_DATE,'dd-Mon-YYYY HH:MI:SS PM')),'Never') INTO v_deers_date FROM T_OSI_PARTICIPANT_HUMAN H,T_OSI_PARTICIPANT_VERSION V WHERE V.PARTICIPANT=p_obj_sid AND V.SID=H.SID;
                  
             EXCEPTION WHEN OTHERS THEN

                      v_deers_date := 'Never';

             END;
             v_return := v_return || '  <li>' || v_deers_date || '<small>Last DEERS</small></li>' || CHR(10) || CHR(13);
    
           END IF;
     
           v_return := v_return || '  <li>This OBJECT IS Classified:  UNCLASSIFIED <small>Classification</small></li>' || CHR(10) || CHR(13);
     
         END IF;
         
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="minbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="minbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="minbutton" onclick="javascript:hideStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/min.gif" align=bottom><small>Minimize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul">' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="maxbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="maxbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="maxbutton" onclick="javascript:showStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/max.gif" align=bottom><small>Maximize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);
   
         RETURN v_return;
   
    END getStatusBar;
 
END Osi_Object;
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
--   Date and Time:   13:40 Monday January 17, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: DeleteDeersImportRecord
--   Manifest End
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

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: APP PROCESS 3691812988366862
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'  v_sid varchar2(100)  := apex_application.g_x01;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  osi_deers.delete_import_record(v_sid);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 3691812988366862 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DeleteDeersImportRecord',
  p_process_sql_clob=> p,
  p_process_error_message=> ' ',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

COMMIT;

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
--   Date and Time:   13:40 Monday January 17, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: UpdateDeers
--   Manifest End
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

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: APP PROCESS 3687431847727960
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'  v_sid        varchar2(100)  := apex_application.g_x01;'||chr(10)||
'  v_obj        varchar2(100)  := apex_application.g_x02;'||chr(10)||
'  l_values     varchar2(4000) := apex_application.g_x03;'||chr(10)||
'  l_result     varchar2(4000);'||chr(10)||
'  l_action_msg varchar2(4000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  -- Delete all the selected items.'||chr(10)||
'  osi_deers.delete_update_field(l_values, v_sid);'||chr(10)||
'    '||chr(10)||
'  -- Update the participant now.'||chr(10)||
'  l_result := osi_deers.up';

p:=p||'date_person_with_deers(v_sid, v_obj);'||chr(10)||
''||chr(10)||
'  if (l_result is null) then'||chr(10)||
'    '||chr(10)||
'    -- Only the DEERS timestamp was updated.'||chr(10)||
'    l_action_msg := ''DEERS data matches Web I2MS data. No changes were made.'';'||chr(10)||
'    osi_deers.delete_import_record(v_sid);'||chr(10)||
'    '||chr(10)||
'  elsif(instr(l_result, ''ERROR'') > 0) then'||chr(10)||
''||chr(10)||
'       -- An error occurred.'||chr(10)||
'       l_action_msg := '||chr(10)||
'              ''The following error occured while trying to';

p:=p||' update this participant: '' || '||chr(10)||
'              ltrim(l_result, ''ERROR '');'||chr(10)||
'  '||chr(10)||
'  elsif(l_result = ''No new Version.'') then'||chr(10)||
''||chr(10)||
'       l_action_msg := ''Selected WebI2MS Data Updated.  The participant window will be reloaded.'';'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    -- A new participant version was created.'||chr(10)||
'    l_action_msg := ''A new participant version was created from DEERS data. The participant window will be reloaded.'';'||chr(10)||
''||chr(10)||
'  end ';

p:=p||'if;'||chr(10)||
'  '||chr(10)||
'  htp.p(l_action_msg);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 3687431847727960 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'UpdateDeers',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

COMMIT;

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
--   Date and Time:   07:31 Wednesday January 19, 2011
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

PROMPT ...Remove page 30005
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30005);
 
end;
/

 
--application/pages/page_30005
prompt  ...PAGE 30005: Individual Title Info
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph := null;
wwv_flow_api.create_page(
  p_id     => 30005,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Individual Title Info',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title => 'Individual Participant',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110119072839',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30005,p_text=>h);
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
  p_id=> 89988419834396415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30005,
  p_plug_name=> 'Individual Participant',
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
  p_id=> 89988622133396417 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30005,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89994335505396431 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>89994120943396429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_branch_action=> 'f?p=&APP_ID.:30005:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3710708591610938 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_DEERS_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 175,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'DMDC DEERS Last Updated',
  p_format_mask=>'DD-Mon-YYYY HH:MI:SS PM',
  p_source=>'DEERS_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
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
  p_id=>89989234428396418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_ORGANIZATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Organization',
  p_source=>'MEMBER_OF_ORG',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>89990409412396421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_MIL_ORGANIZATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 165,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Military Organization',
  p_source=>'MILITARY_ORGANIZATION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>89990632511396421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30005_SID',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>89990831778396423 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_SEX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sex',
  p_source=>'SEX',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
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
  p_id=>89991036113396423 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_SERVICE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Service',
  p_source=>'SERVICE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
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
  p_id=>89991206452396423 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_AFFILIATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Affiliation',
  p_source=>'AFFILIATION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
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
  p_id=>89991435299396423 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_COMPONENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Component',
  p_source=>'COMPONENT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
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
  p_id=>89991609346396423 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_PAY_PLAN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Pay Plan',
  p_source=>'PAY_PLAN',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
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
  p_id=>89991830665396424 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_PAY_GRADE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Pay Grade',
  p_source=>'PAY_GRADE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
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
  p_id=>89992024987396424 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_RANK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Rank',
  p_source=>'RANK',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 50,
  p_cHeight=> 1,
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
  p_id=>89992224298396424 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_RANK_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 155,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Rank Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'RANK_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
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
  p_id=>89992434473396424 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_SPECIALTY_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Specialty',
  p_source=>'SPECIALTY_CODE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 30,
  p_cHeight=> 1,
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
  p_id=>89992835894396426 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_DOB',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'DOB',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'DOB',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>89993012552396426 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_SSN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'SSN',
  p_source=>'SSN',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>89993228237396426 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30005,
  p_name=>'P30005_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89988419834396415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Name',
  p_source=>'NAME',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    :p30005_sid := osi_participant.get_current_version(:p0_obj);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90737422144680193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30005,
  p_process_sequence=> 1,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload items',
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
p:=p||'F|#OWNER#:V_OSI_PARTICIPANT_INDIV_TITLE:P30005_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 98933824070843793 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30005,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Get V_OSI_PARTICIPANT_INDIV_TITLE',
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
-- ...updatable report columns for page 30005
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
--   Date and Time:   08:00 Wednesday January 19, 2011
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

PROMPT ...Remove page 30140
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30140);
 
end;
/

 
--application/pages/page_30140
prompt  ...PAGE 30140: DEERS
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script type="text/javascript">'||chr(10)||
'function checkAll()'||chr(10)||
'{'||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
'  '||chr(10)||
' for (var i = 0; i < node_list.length; i++)'||chr(10)||
'    {'||chr(10)||
'     var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'     if (node.getAttribute(''type'') == ''checkbox'')'||chr(10)||
'       {'||chr(10)||
'        node.checked=true;'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function uncheckAll()'||chr(10)||
'{'||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
'  '||chr(10)||
' for (var i = 0';

ph:=ph||'; i < node_list.length; i++)'||chr(10)||
'    {'||chr(10)||
'     var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'     if (node.getAttribute(''type'') == ''checkbox'')'||chr(10)||
'       {'||chr(10)||
'        node.checked=false;'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function DeleteDeersImportRecord()'||chr(10)||
'{'||chr(10)||
' var l_field_id = document.getElementById(''P30140_SID'');'||chr(10)||
''||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=DeleteDeersI';

ph:=ph||'mportRecord'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',l_field_id.value);'||chr(10)||
' gReturn = get.get();'||chr(10)||
' window.close();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function UpdateDeers()'||chr(10)||
'{'||chr(10)||
' var unselected = "";'||chr(10)||
''||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
''||chr(10)||
' var l_field_id = document.getElementById(''P30140_UNCHECKED_ITEMS''); '||chr(10)||
' var l_field_sid = document.getElementById(''P30140_SID''); '||chr(10)||
' var l_field_obj = docu';

ph:=ph||'ment.getElementById(''P30140_OBJ''); '||chr(10)||
'  '||chr(10)||
' for (var i = 0; i < node_list.length; i++) '||chr(10)||
'    {'||chr(10)||
'     var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'     if (node.getAttribute(''type'') == ''checkbox'') '||chr(10)||
'       {'||chr(10)||
'        if (node.checked==false)'||chr(10)||
'          {'||chr(10)||
'           if (l_field_id.value.indexOf("~" + node.name + "~") < 0)'||chr(10)||
'             {'||chr(10)||
'              unselected = unselected.concat(node.name,"~");'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
' ';

ph:=ph||'      }'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
' l_field_id.value = l_field_id.value + unselected;'||chr(10)||
''||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=UpdateDeers'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',l_field_sid.value);'||chr(10)||
' get.addParam(''x02'',l_field_obj.value);'||chr(10)||
' get.addParam(''x03'',l_field_id.value);'||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' var myStr';

ph:=ph||'ing = String(gReturn);'||chr(10)||
' myString=myString.replace(''\n'', '''', ''g'');'||chr(10)||
''||chr(10)||
' if (myString=="DEERS data matches Web I2MS data. No changes were made.")'||chr(10)||
'   {'||chr(10)||
'    // Only the DEERS timestamp was updated. //'||chr(10)||
'    alert(gReturn);'||chr(10)||
'    window.close();'||chr(10)||
'   }'||chr(10)||
' else if(myString.indexOf(''The following error occured while'')==0)'||chr(10)||
'        {'||chr(10)||
'         alert(gReturn);'||chr(10)||
'         window.close();'||chr(10)||
'        }    '||chr(10)||
'      else'||chr(10)||
'        {';

ph:=ph||''||chr(10)||
'         // A new participant version was created.         //'||chr(10)||
'         // or the Photo was changed without a new version //'||chr(10)||
'         alert(gReturn);'||chr(10)||
'         newWindow({page:''30005'', '||chr(10)||
'                    clear_cache:''30005'', '||chr(10)||
'                    name:''&P0_OBJ.'', item_names:''P0_OBJ_CONTEXT'','||chr(10)||
'                    item_values:''&P30140_RESULT.'','||chr(10)||
'                    request:''OPEN''});'||chr(10)||
'         window.cl';

ph:=ph||'ose();'||chr(10)||
'        }'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<style>'||chr(10)||
'#DEERSComparison '||chr(10)||
'                {'||chr(10)||
'                 border: none;'||chr(10)||
'                 width: 97%;'||chr(10)||
'                 font: 1em Courier New;'||chr(10)||
'                }'||chr(10)||
''||chr(10)||
'#DEERSDataColumn'||chr(10)||
'                {'||chr(10)||
'                 width: 50%;'||chr(10)||
'                }'||chr(10)||
''||chr(10)||
'#I2MSDataColumn'||chr(10)||
'                {'||chr(10)||
'                 width: 50%;'||chr(10)||
'                }'||chr(10)||
''||chr(10)||
'#DEERSData'||chr(10)||
'          {'||chr(10)||
'           border: ';

ph:=ph||'3px ridge;'||chr(10)||
'           width: 100%;'||chr(10)||
'           font: 1em Courier New;'||chr(10)||
'           border-collapse: collapse;'||chr(10)||
'          }'||chr(10)||
'#I2MSData'||chr(10)||
'         {'||chr(10)||
'          border: 3px ridge;'||chr(10)||
'          width: 100%;'||chr(10)||
'          font: 1em Courier New;'||chr(10)||
'          border-collapse: collapse;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#I2MSData td'||chr(10)||
'            {'||chr(10)||
'             height: 22px;'||chr(10)||
'             border-left: 1px solid #D9D9D9;'||chr(10)||
'             cellspacing: 0';

ph:=ph||';'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'#DEERSData td'||chr(10)||
'            {'||chr(10)||
'             height: 22px;'||chr(10)||
'             border-left: 1px solid #D9D9D9;'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'#evenRow'||chr(10)||
'         {'||chr(10)||
'          background: #fff;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#oddRow'||chr(10)||
'         {'||chr(10)||
'          background: #eee;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#currentHeader'||chr(10)||
'              {'||chr(10)||
'               border-b';

ph:=ph||'ottom: 3px ridge;'||chr(10)||
'              }'||chr(10)||
''||chr(10)||
'#DeersHeader'||chr(10)||
'              {'||chr(10)||
'               border-bottom: 3px ridge;'||chr(10)||
'              }'||chr(10)||
'</style>';

wwv_flow_api.create_page(
  p_id     => 30140,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'DEERS',
  p_step_title=> 'DEERS Check',
  p_step_sub_title => 'DEERS',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110119080010',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30140,p_text=>ph);
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
  p_id=> 3210011864697148 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30140,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'DECLARE'||chr(10)||
'BEGIN'||chr(10)||
''||chr(10)||
'  htp.p(:p30140_html);'||chr(10)||
'  '||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_plug (
  p_id=> 3657419316494285 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30140,
  p_plug_name=> 'Participant Comparison',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 3,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P30140_SHOWN',
  p_plug_display_when_cond2=>'Y',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 3210432486697150 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 5,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'UPDATE_DEERS',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Update',
  p_button_position=> 'REGION_TEMPLATE_EDIT',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:UpdateDeers();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3210204089697148 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 15,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:DeleteDeersImportRecord();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3674719343071494 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 10,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'SELECT_ALL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Select All',
  p_button_position=> 'REGION_TEMPLATE_NEXT',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:checkAll();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3675712726116890 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 11,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'DESELECT_ALL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'De-Select All',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:uncheckAll();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>3229528606697206 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_branch_action=> 'f?p=&APP_ID.:30140:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 09-APR-2010 16:07 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3211201166697151 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3222012720697181 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30140_RESULT=',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 8000,
  p_cHeight=> 10,
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
  p_id=>3222422691697182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3222605017697182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_MUGSHOT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'PHOTO',
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
  p_id=>3222810502697184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_D_MUGSHOT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'DEERS_PHOTO',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>3336827467553720 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30140_ACTION=',
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
  p_id=>3580728043495959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_ACTION_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3643831470455779 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_SHOWN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 248,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3658328413553673 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_HTML',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 258,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>4330830460650535 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_UNCHECKED_ITEMS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
p:=p||'begin'||chr(10)||
''||chr(10)||
'  if (:p30140_sid is null) then'||chr(10)||
''||chr(10)||
'    :p30140_sid := osi_deers.get_deers_information(:p30140_obj, null, 0, null);'||chr(10)||
''||chr(10)||
'    -- A match was not found or an error occured.'||chr(10)||
'    if (:p30140_sid is null) then'||chr(10)||
'    '||chr(10)||
'      :p30140_shown  := ''N'';'||chr(10)||
'      htp.p(''<script language="JavaScript">alert("'' || ltrim(ltrim(osi_deers.get_import_message, ''ERROR ''), ''MSG '') || ''");window.close();</script>'');'||chr(10)||
''||chr(10)||
'    end i';

p:=p||'f;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3228810727697204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30140,
  p_process_sequence=> 1,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CANCEL',
  p_process_when_type=>'REQUEST_NOT_EQUAL_CONDITION',
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
p:=p||'F|#OWNER#:V_OSI_DEERS_COMPARE:P30140_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 3229019374697204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30140,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Get V_OSI_DEERS_COMPARE',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P30140_SID',
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
p:=p||'DECLARE'||chr(10)||
''||chr(10)||
'  p_shown          varchar2(1);'||chr(10)||
'  p_uncheckedItems varchar2(4000);'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'  '||chr(10)||
'  :p30140_html := osi_deers.deers_compare(:p30140_obj, p_shown, p_uncheckedItems);'||chr(10)||
'  '||chr(10)||
'  :p30140_shown := p_shown;'||chr(10)||
'  :p30140_unchecked_items := p_uncheckedItems;'||chr(10)||
'  '||chr(10)||
'  if p_shown = ''N'' then'||chr(10)||
''||chr(10)||
'    osi_deers.delete_import_record(:P30140_SID);'||chr(10)||
'    htp.p(''<script language="JavaScript">alert("All Web I2MS information is ';

p:=p||'up to date.");window.close();</script>'');'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 3584410530001928 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30140,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check for differences',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P30140_SID',
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
-- ...updatable report columns for page 30140
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

