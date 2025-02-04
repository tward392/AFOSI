-- "Set define off" turns off substitution variables. 
Set define off; 

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

    FUNCTION can_delete(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        -- Does this person have associations (files or activities)?
        FOR a IN (SELECT pi.SID
                    FROM T_OSI_PARTIC_INVOLVEMENT pi, T_OSI_PARTICIPANT_VERSION pv
                   WHERE pi.participant_version = pv.SID AND pv.participant = p_obj)
        LOOP
            RETURN 'Cannot delete a participant used in a file or activity.';
        END LOOP;

        -- Does this person have relationships?
        FOR b IN (SELECT pr.SID
                    FROM T_OSI_PARTIC_RELATION pr
                   WHERE pr.partic_a = p_obj
                      OR pr.partic_b = p_obj)
        LOOP
            RETURN 'You cannot delete a participant with an existing relationship.';
        END LOOP;

        RETURN 'Y';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.Can_Delete: Error encountered using Object '
                      || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in OSI_PARTICIPANT.Can_Delete using Object: '
                   || NVL(p_obj, 'NULL');
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
        p_unknown   IN   VARCHAR2 := 'Y')
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
            SELECT SID
              INTO v_num_type
              FROM T_OSI_PARTIC_NUMBER_TYPE
             WHERE code = 'SSN';

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
        FOR x IN (SELECT   pa.SID, a.address_1, a.address_2, a.city, a.province,
                           s.description AS state, s.code AS state_code, a.postal_code,
                           c.description AS country, c.code AS country_code, a.geo_coords
                      FROM T_OSI_ADDRESS a,
                           T_OSI_PARTIC_ADDRESS pa,
                           T_OSI_ADDR_TYPE t,
                           T_DIBRS_COUNTRY c,
                           T_DIBRS_STATE s
                     WHERE (   pa.participant_version = p_pvop
                            OR pa.participant_version = Osi_Participant.get_current_version(p_pvop))
                       AND a.SID = pa.address(+)
                       AND a.address_type = t.SID
                       AND t.code = p_address_code
                       AND a.state = s.SID(+)
                       AND a.country = c.SID(+)
                  ORDER BY pa.modify_on DESC)
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
                    RETURN x.state;
                WHEN 'STATE_CODE' THEN
                    RETURN x.state_code;
                WHEN 'ZIP' THEN
                    RETURN x.postal_code;
                WHEN 'POSTAL_CODE' THEN
                    RETURN x.postal_code;
                WHEN 'COUNTRY' THEN
                    RETURN x.country;
                WHEN 'COUNTRY_CODE' THEN
                    RETURN x.country_code;
                WHEN 'GEO_COORDS' THEN
                    RETURN x.geo_coords;
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

    FUNCTION get_name(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_program   T_CORE_OBJ_TYPE.SID%TYPE;
    BEGIN
        v_program := Core_Obj.lookup_objtype('PART.NONINDIV.PROG');

        FOR x IN (SELECT RTRIM(RTRIM(pn.last_name
                                     || DECODE(pv.obj_type, v_program, '', ', ' || pn.first_name)
                                     || ' ' || pn.middle_name,
                                     ' '),
                               ',')
                         || DECODE(pv.org_majcom, NULL, '', ' (' || pv.org_majcom_desc || ')')
                                                                                           AS NAME
                    FROM T_OSI_PARTIC_NAME pn, v_osi_participant_version pv
                   WHERE (   pv.SID = p_pvop
                          OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
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
            FOR x IN (SELECT   pr.SID
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
                   WHERE participant_version = v_pv_sid AND is_current = 'N')
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
                         WHERE obj = p_obj AND ROWNUM = 1
                      ORDER BY create_on ASC)
            LOOP
                Osi_Util.aitc(v_temp_clob,
                              '<td align="center"><img src="f?p=' || v( 'APP_ID') || ':801:'
                              || v( 'SESSION') || ':' || x.SID
                              || '" border="0" alt="Mugshot" style="vertical-align:top;"/></td>');
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
                           DECODE(v_pv_sid, this_participant, related_name, this_name) AS NAME,
                           description, specifics, comments, mod2_value
                      FROM v_osi_partic_relation
                     WHERE (   this_participant = v_pv_sid
                            OR related_to = v_pv_sid)
                       AND description IS NOT NULL
                  ORDER BY description, NAME)
        LOOP
            IF (   (NVL(x.mod2_value, 'xxx') LIKE 'ORCON%')
                OR (NVL(x.mod2_value, 'xxx') LIKE 'LIMDIS%')) THEN
                -- TODO: Replace with a system log entry.
                log_error
                    ('run_report_details: Object is ORCON or LIMDIS - User does not have permission to view document therefore no link will be generated');
            ELSE
                v_counter := v_counter + 1;
                Osi_Util.aitc(v_temp_clob,
                              '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');

                IF (x.related_to = v_pv_sid) THEN
                    Osi_Util.aitc
                                (v_temp_clob,
                                 '<td>'
                                 || Osi_Object.get_tagline_link(get_participant(x.this_participant))
                                 || '</td></tr>');
                ELSE
                    Osi_Util.aitc(v_temp_clob,
                                  '<td>'
                                  || Osi_Object.get_tagline_link(get_participant(x.related_to))
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
        --Get object type SID
        v_obj_type := Core_Obj.lookup_objtype('PART.INDIV');

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

            --Get PERSON_CHARS columns [BEGIN]
            v_osi_person_chars_sex := Dibrs_Reference.lookup_ref_sid('SEX', UPPER(k.sex));

            IF (k.eye_color IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_person_chars_eye_color
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'PERSON_EYE_COLOR' AND UPPER(description) = UPPER(k.eye_color);
            ELSE
                v_osi_person_chars_eye_color := NULL;
            END IF;

            IF (k.hair_color IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_person_chars_hair_color
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'PERSON_HAIR_COLOR' AND UPPER(description) = UPPER(k.hair_color);
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
                v_temp := k.name_type;

                IF (k.name_type = 'A') THEN
                    --Special case for AKA (When dealing with individual participants)
                    v_temp := 'AKA';
                ELSE
                    v_temp := k.name_type;
                END IF;

                --Shouldn't need this try/catch, but have it in place for non-indiv folks
                BEGIN
                    SELECT SID
                      INTO v_osi_partic_name_name_type
                      FROM T_OSI_PARTIC_NAME_TYPE
                     WHERE code = v_temp;
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
            CASE k.addr_type
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
                     WHERE USAGE = 'INDIV_DATE' AND description = k.date_type;
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
            log_error('osi_participant.import_legacy_part_version: ' || SQLERRM);
            RAISE;
    END import_legacy_part_version;

    FUNCTION import_legacy_participant(p_person_version IN VARCHAR2)
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

        FUNCTION get_part_rel_info(p_person IN VARCHAR2)
            RETURN CLOB IS
            v_file_begin   VARCHAR2(2000)
                := '{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}} {\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20';
            v_file_end     VARCHAR2(2000)  := '\par }';
            v_return       CLOB;
            v_temp1        VARCHAR2(20000);
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
        --Get object type SID
        v_obj_type := Core_Obj.lookup_objtype('PART.INDIV');

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
            v_osi_participant_ethnicity := Osi_Reference.lookup_ref_sid('ETHNICITY', k.ethnicity);

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
            mark_as_mig('PARTICIPANT', k.SID, v_new_sid_temp, '');
        END LOOP;

        --Give the participant a starting status
        Osi_Status.change_status_brute
                             (v_new_sid,
                              Osi_Status.get_starting_status(Core_Obj.lookup_objtype('PART.INDIV')),
                              'Created');

        --If person is confirmed, need to change their status to show it
        IF (v_temp IS NOT NULL) THEN
            --Get status change
            SELECT SID
              INTO v_temp
              FROM T_OSI_STATUS_CHANGE
             WHERE obj_type = Core_Obj.lookup_objtype('PART.INDIV')
               AND from_status =
                               Osi_Status.get_starting_status(Core_Obj.lookup_objtype('PART.INDIV'))
               AND UPPER(transition) = 'CONFIRM';

            Osi_Status.change_status(v_new_sid, v_temp);
        END IF;
        
        --Notes
        --Transfer the notes to the temp table
        DELETE FROM T_OSI_MIGRATION_NOTES;
        INSERT INTO T_OSI_MIGRATION_NOTES SELECT * FROM ref_t_note_v2 WHERE PARENT=v_person_sid;
  
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
                     WHERE obj_type = Core_Obj.lookup_objtype('PART.INDIV')
                       AND USAGE = 'NOTELIST'
                       AND UPPER(description) = UPPER(k.CATEGORY);
                EXCEPTION
                    WHEN OTHERS THEN
                        --If not type is not found, then use the 'Additional Info' note.
                        v_osi_note_note_type :=
                            Osi_Note.get_note_type(Core_Obj.lookup_objtype('PART.INDIV'),
                                                   'ADD_INFO');
                END;
            ELSE
                --Category should never be null, but if it is, just use "Additional Info" note.
                v_osi_note_note_type :=
                          Osi_Note.get_note_type(Core_Obj.lookup_objtype('PART.INDIV'), 'ADD_INFO');
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
        INSERT INTO T_OSI_MIGRATION_ATCH SELECT * FROM ref_t_attachment_v3 WHERE PARENT=v_person_sid;

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
                    Osi_Attachment.get_attachment_type_sid(Core_Obj.lookup_objtype('PART.INDIV'),
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
                             date_modified)
                     VALUES (v_new_sid,
                             v_temp2,
                             j.blob_content,
                             j.attach_location,
                             j.description,
                             j.source_location,
                             NULL,
                             v_temp,
                             j.LOCKED,
                             j.content_date)
                  RETURNING SID
                       INTO v_new_sid_temp;
            END LOOP;

            mark_as_mig('PARTICIPANT_ATCH', k.SID, v_new_sid_temp, v_new_sid);
        END LOOP;

        --Person Detail Report
        --ref_obj_doc_web.make_doc_per(v_person_sid, v_temp_clob, null);
        v_temp_clob := get_part_rel_info(v_person_sid);

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
--   Date and Time:   08:06 Monday January 10, 2011
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
'        window.parent.doSubmit(''RELOAD'');'||chr(10)||
'        /*opener';

ph:=ph||'.doSubmit(''RELOAD'');*/'||chr(10)||
'    }'||chr(10)||
'    '||chr(10)||
'    if (cloning == 1 || open_new == true){'||chr(10)||
'         newWindow({page:''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'                    clear_cache:''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'                    name:''&P5450_CLONE_NEW_SID.'', item_names:''P0_OBJ'', '||chr(10)||
'                    item_values:''&P5450_CLONE_NEW_SID.'', '||chr(10)||
'                    request:''OPEN''});'||chr(10)||
'    }'||chr(10)||
'   '||chr(10)||
'    if(''&P5450_STATUS_';

ph:=ph||'CHANGE_DESC.'' == ''Approve File'' & ''&P5450_OBJ_TYPE.'' == ''Case''){'||chr(10)||
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
  p_last_upd_yyyymmddhh24miss => '20110110074900',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '11-MAY-2010  Jason Faris     Added conditional ''RPO Unit'' selector for Criminal Poly File Support.'||chr(10)||
'04-JUN-2010  Tim McGuffin    Added audit logging of status changes.');
 
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
'    v_parameter1   varchar2(500)  := null;'||chr(10)||
'    v_parameter2   varchar2(4000) := null;'||chr(10)||
'    v_temp         t_osi_note.sid%type;'||chr(10)||
'    v_result       varchar2(32767) := null;'||chr(10)||
'    v_log_msg      varchar2(500);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'    v_log_msg := ''Lifecycle:'' || :p0_obj || ''-'' || :p5450_status_change_desc;'||chr(10)||
'    --Grab Unit into Parameter1 if nessecary'||chr(10)||
'    if (:p5450_unit_required = ''Y'') then'||chr(10)||
'        v_paramet';

p:=p||'er1 := :p5450_unit_sid;'||chr(10)||
'        v_log_msg := v_log_msg || ''-'' || v_parameter1;'||chr(10)||
'    end if;'||chr(10)||
'    log_info(v_log_msg);'||chr(10)||
''||chr(10)||
'    --Grab Unit Text into Parameter2 if nessecary'||chr(10)||
'    if (:p5450_unit_text_required = ''Y'') then'||chr(10)||
'        v_parameter2 := :p5450_unit_text;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
''||chr(10)||
'   osi_status.change_status(:p0_obj, :p5450_status_change_sid, v_parameter1, v_parameter2, :P5450_EFFECTIVE_DATE);'||chr(10)||
''||chr(10)||
'    if (:p5450_';

p:=p||'note_text is not null) then'||chr(10)||
'        :P5450_NEW_NOTE_SID := osi_note.add_note(:p0_obj,'||chr(10)||
'                          osi_status.get_required_note_type(:p5450_status_change_sid),'||chr(10)||
'                          :p5450_note_text);'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5450_status_change_desc in (''Clone Activity'',''Create Case'')) then'||chr(10)||
'        --Put the cloned sid in the page if it exists.'||chr(10)||
'        :p5450_clone_new_sid := osi_st';

p:=p||'atus_proc.get_cloned_sid;'||chr(10)||
'        '||chr(10)||
'        select page_num'||chr(10)||
'          into :p5450_clone_page_to_launch'||chr(10)||
'          from t_core_dt_obj_type_page'||chr(10)||
'         where obj_type member of osi_object.get_objtypes(:p5450_clone_new_sid)'||chr(10)||
'           and page_function = ''OPEN'';'||chr(10)||
'         --where obj_type = core_obj.get_objtype(:p5450_clone_new_sid);'||chr(10)||
'    end if;'||chr(10)||
'    '||chr(10)||
'    if(:p5450_status_change_desc = ''Migrate to Exis';

p:=p||'ting Source'') then'||chr(10)||
'        :p5450_clone_new_sid := osi_status_proc.get_cloned_sid;'||chr(10)||
'        :P5450_source_id := osi_source.get_id(:p5450_clone_new_sid);'||chr(10)||
'        '||chr(10)||
'        select page_num'||chr(10)||
'          into :p5450_clone_page_to_launch'||chr(10)||
'          from t_core_dt_obj_type_page'||chr(10)||
'         where obj_type member of osi_object.get_objtypes(:p5450_clone_new_sid)'||chr(10)||
'           and page_function = ''OPEN'';'||chr(10)||
'        '||chr(10)||
'     ';

p:=p||'   delete from t_core_obj where sid = :p0_obj;'||chr(10)||
'        :p0_obj := :p5450_clone_new_sid;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'       if(:p5450_status_change_desc = ''Approve File'' and :p5450_obj_type = ''Case'')then     '||chr(10)||
'      '||chr(10)||
'       select sid'||chr(10)||
'       into :p5450_report_type'||chr(10)||
'       from t_osi_report_type'||chr(10)||
'      where description = ''Letter of Notification'''||chr(10)||
'       and obj_type = core_obj.lookup_objtype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'      :deb';

p:=p||'ug := :p5450_report_type;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'    :p5450_done := ''Y'';'||chr(10)||
'exception'||chr(10)||
'    when others then'||chr(10)||
'        :p5450_done := ''N'';'||chr(10)||
'        raise;'||chr(10)||
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
--   Date and Time:   08:38 Friday January 7, 2011
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

PROMPT ...Remove page 30135
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30135);
 
end;
/

 
--application/pages/page_30135
prompt  ...PAGE 30135: Participant Duplicates
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'  if(''&REQUEST.'' == ''CONFIRM_DUPLICATE''){'||chr(10)||
'    // This will close the participant window where the confirm started.'||chr(10)||
'    var objWindow = window.open('''', ''&P30135_OBJ.'','''');'||chr(10)||
'    objWindow.close();'||chr(10)||
'    // Now open a new window with the merged contents.'||chr(10)||
'    newWindow({page:''30005'', '||chr(10)||
'               clear_cache:''30005'', '||chr(10)||
'               name:''&P30135_R';

ph:=ph||'EPLACEMENT.'', item_names:''P0_OBJ,P0_OBJ_CONTEXT'','||chr(10)||
'               item_values:''&P30135_REPLACEMENT.,&P30135_REPLACEMENT_VER.'','||chr(10)||
'               request:''OPEN''});'||chr(10)||
'    window.close();'||chr(10)||
'  }'||chr(10)||
'  '||chr(10)||
'  if(''&REQUEST.'' == ''CONFIRM_NEW''){'||chr(10)||
'    var objWindow = window.open('''', ''&P30135_OBJ.'','''');'||chr(10)||
'    window.close();'||chr(10)||
'    objWindow.doSubmit();'||chr(10)||
'  }'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30135,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Participant Duplicates',
  p_step_title=> 'Confirm Participant',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110106092111',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30135,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select participant as sid,'||chr(10)||
'       last_name as "Last Name",'||chr(10)||
'       first_name as "First Name",'||chr(10)||
'       middle_name as "Middle Name",'||chr(10)||
'       score as "Matching Likelihood",'||chr(10)||
'       info as "Reasons for Match",'||chr(10)||
'       decode(participant, :P30135_SEL_PARTICIPANT, ''Y'', ''N'') as "Current"'||chr(10)||
'  from v_osi_partic_search_result'||chr(10)||
' where session_id = :p30135_session';

wwv_flow_api.create_report_region (
  p_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30135,
  p_name=> 'Possible Duplicates',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 5,
  p_display_column=> 1,
  p_display_point=> 'BEFORE_BOX_BODY',
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
  p_query_no_data_found=> 'No duplicate participants found.',
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
  p_plug_query_exp_filename=> '&P30135_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5954022595118270 + wwv_flow_api.g_id_offset,
  p_region_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
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
  p_id=> 5810120269510370 + wwv_flow_api.g_id_offset,
  p_region_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
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
  p_id=> 5810228635510370 + wwv_flow_api.g_id_offset,
  p_region_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
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
  p_id=> 5810327733510370 + wwv_flow_api.g_id_offset,
  p_region_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
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
  p_id=> 5810416693510370 + wwv_flow_api.g_id_offset,
  p_region_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
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
  p_id=> 5810511284510370 + wwv_flow_api.g_id_offset,
  p_region_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
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
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5810013100510370 + wwv_flow_api.g_id_offset,
  p_region_id=> 5809626543510359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 5975830063009839 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30135,
  p_plug_name=> 'Details of Possible Duplicate',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
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
  p_plug_display_when_condition => 'P30135_REPLACEMENT',
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
  p_id=> 5976008030012990 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30135,
  p_plug_name=> 'Details of Unconfirmed Participant',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 16010629698655681 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30135,
  p_button_sequence=> 30,
  p_button_plug_id => 5809626543510359+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this, 30135);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5980413019099535 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30135,
  p_button_sequence=> 10,
  p_button_plug_id => 5975830063009839+wwv_flow_api.g_id_offset,
  p_button_name    => 'CONFIRM_DUPLICATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Confirm as Duplicate',
  p_button_position=> 'REGION_TEMPLATE_NEXT',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5992929557473326 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30135,
  p_button_sequence=> 15,
  p_button_plug_id => 5975830063009839+wwv_flow_api.g_id_offset,
  p_button_name    => 'VIEW_SELECTED',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'View Selected',
  p_button_position=> 'REGION_TEMPLATE_NEXT',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:newWindow({name:''&P30135_REPLACEMENT.'','||chr(10)||
'page:30005,'||chr(10)||
'clear_cache:30005,'||chr(10)||
'item_names:''P0_OBJ'','||chr(10)||
'item_values:''&P30135_REPLACEMENT.'','||chr(10)||
'request:''OPEN''});',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5980631027104732 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30135,
  p_button_sequence=> 20,
  p_button_plug_id => 5976008030012990+wwv_flow_api.g_id_offset,
  p_button_name    => 'CONFIRM_NEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Confirm as New',
  p_button_position=> 'REGION_TEMPLATE_NEXT',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5981025617112685 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_branch_action=> 'f?p=&APP_ID.:30135:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 17-FEB-2010 13:25 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3534417661469825 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_CONFIRM_ALLOWED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 5809626543510359+wwv_flow_api.g_id_offset,
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
  p_id=>5811007973514457 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_REPLACEMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 5809626543510359+wwv_flow_api.g_id_offset,
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
  p_id=>5811213860516176 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 5809626543510359+wwv_flow_api.g_id_offset,
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
  p_id=>5909415090556109 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_SC_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 5809626543510359+wwv_flow_api.g_id_offset,
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
  p_id=>5978210716032635 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_REPLACE_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 5975830063009839+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_details(:p30135_replacement, ''Y'', ''Y'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'width="100%"',
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
  p_id=>5978505999040746 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_OBJ_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 5976008030012990+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_details(:p30135_obj, ''Y'', ''Y'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'width="100%"',
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
  p_id=>6784014788036781 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 5809626543510359+wwv_flow_api.g_id_offset,
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
  p_id=>6959501291553310 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_REPLACEMENT_VER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 5975830063009839+wwv_flow_api.g_id_offset,
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
  p_id=>16010806973658639 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_name=>'P30135_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 5809626543510359+wwv_flow_api.g_id_offset,
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
  p_id=> 14769706404247687 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30135,
  p_computation_sequence => 10,
  p_computation_item=> 'P30135_OBJ',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'ITEM_VALUE',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'P0_OBJ',
  p_compute_when => 'P0_OBJ',
  p_compute_when_type=>'ITEM_IS_NOT_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12065600752412270 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30135,
  p_validation_name => 'Confirm any priv check',
  p_validation_sequence=> 10,
  p_validation => 'osi_auth.check_for_priv(''PER.ANYNEW'', :p0_obj_type_sid) = ''Y'''||chr(10)||
'or'||chr(10)||
':P30135_CONFIRM_ALLOWED=''Y''',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'Cannot confirm as New participant - Likely match(es) exist.',
  p_validation_condition=> 'CONFIRM_NEW',
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
p:=p||':P30135_REPLACEMENT := substr(:REQUEST,6);';

wwv_flow_api.create_page_process(
  p_id     => 5954431384130240 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30135,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select participant',
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
p:=p||'osi_status.change_status(:p30135_obj, :p30135_sc_sid);';

wwv_flow_api.create_page_process(
  p_id     => 6135716297449987 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30135,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Confirm new',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CONFIRM_NEW',
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
p:=p||'osi_participant.replace_with(:p30135_obj, :p30135_replacement);'||chr(10)||
':p30135_replacement_ver := osi_participant.get_current_version(:p30135_replacement);';

wwv_flow_api.create_page_process(
  p_id     => 6642305850932471 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30135,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Confirm duplicate',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CONFIRM_DUPLICATE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30135
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

