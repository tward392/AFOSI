set define off;

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
     16-Feb-2011 Tim Ward        Problem pulling correct DEERS_DATE.
     04-Mar-2011 Tim Ward        CR#3734 - set_special_interest is deleting 'I' and 'A' and it should only delete 'I'.
     18-Mar-2011 Tim Ward        CR#3731 - PERSONNEL should not be deleted.
                                  Also defaulted delete_object to return 'You are not authorized to perform the requested action.'
                                  instead of 'Y'.  Removed the checkForPriv from i2ms.js deleteObj function.
                                  Changed in delete_object.
     07-Oct-2011 Tim Ward        CR#3946 - Add ParentInfo Open Link to Grid and Selected Attachment Detials so the users can get to the
                                  parent quickly (if it is not the same as this file). 
                                  Changed OSI_OBJECT.GET_OPEN_LINK so it returns 32000 instead of 200 in the Link since the parentinfo 
                                  can be as long as the title + a few characters...
                                  
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
        v_rtn VARCHAR2(32000);
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
              WHERE obj = p_sid AND INSTR(NVL(p_special_interest, 'null'), mission) = 0 and obj_context='I';
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
    FUNCTION delete_object(p_obj IN VARCHAR2) RETURN VARCHAR2 IS

          v_rtn      VARCHAR2(200)             := NULL;
          v_ot       VARCHAR2(20)              := NULL;
          v_ot_cd    VARCHAR2(200)             := NULL;

    BEGIN
         v_ot := Core_Obj.get_objtype(p_obj);

         IF v_ot IS NULL THEN

           log_error('Delete_Object: Error locating Object Type for ' || NVL(v_ot, 'NULL'));
           RETURN 'Invalid Object passed to Delete_Object';

         END IF;

         SELECT code INTO v_ot_cd FROM T_CORE_OBJ_TYPE WHERE SID = v_ot;

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

                 ---Can never delete units, if this changes, will need to make a OSI_UNIT.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';

             WHEN v_ot_cd = 'PERSONNEL' THEN

                 ---Can never delete Personnel, if this changes, will need to make a OSI_PERSONNEL.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';
             
             WHEN v_ot_cd = 'EVIDENCE' THEN

                 ---Gets here ONLY if the Evidence is NOT Read-ONLY---
                 v_rtn := 'Y';
                      
             ELSE 
                 v_rtn := 'You are not authorized to perform the requested action.';

         END CASE;

         IF v_rtn <> 'Y' THEN

           RETURN v_rtn;

         END IF;
    
         ---execute the delete, all object-specific and child table deletions will cascade---
         DELETE FROM T_CORE_OBJ WHERE SID = p_obj;

         RETURN 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            log_error('Delete_Object: Error encountered using Object ' || NVL(p_obj, 'NULL') || ':' || SQLERRM);
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
        v_deers_date date;
        v_deers_date_string varchar2(200);
        
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
                  SELECT max(DEERS_DATE) INTO v_deers_date FROM T_OSI_PARTICIPANT_HUMAN H,T_OSI_PARTICIPANT_VERSION V WHERE V.PARTICIPANT=p_obj_sid AND V.SID=H.SID;

                  if v_deers_date is null then
                    
                    v_deers_date_string := 'Never';

                  else

                    v_deers_date_string := to_char(v_deers_date,'dd-Mon-YYYY HH:MI:SS PM');
                  
                  end if;
                  
             EXCEPTION WHEN OTHERS THEN

                      v_deers_date := 'Never';

             END;
             v_return := v_return || '  <li>' || v_deers_date_string || '<small>Last DEERS</small></li>' || CHR(10) || CHR(13);
    
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
--   Date and Time:   12:26 Friday October 7, 2011
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

PROMPT ...Remove page 5100
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5100);
 
end;
/

 
--application/pages/page_05100
prompt  ...PAGE 5100: Attachments
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript1.1" type="text/javascript">'||chr(10)||
''||chr(10)||
'    function SetDescription()'||chr(10)||
'    {'||chr(10)||
'     var pathname = $v(''P5100_SOURCE_DISPLAY1'');'||chr(10)||
''||chr(10)||
'     var filename = '||chr(10)||
'        pathname.substr(pathname.lastIndexOf("\\")+1,pathname.length)'||chr(10)||
''||chr(10)||
'     var ext ='||chr(10)||
'        filename.substr(filename.lastIndexOf("."),filename.length)'||chr(10)||
'     '||chr(10)||
'     if ($v(''P5100_LOCATION'')==''DB'' || $v(''P5100_LOCATION'')==''FILE'')'||chr(10)||
'       ';

ph:=ph||'{'||chr(10)||
'        if (filename==ext)'||chr(10)||
'          $s(''P5100_DESCRIPTION'',filename);'||chr(10)||
'        else'||chr(10)||
'          $s(''P5100_DESCRIPTION'',filename.replace(ext,""));'||chr(10)||
''||chr(10)||
'        $s(''P5100_LAST_FILE_PICKED'',pathname);'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
'    function CheckDescription()'||chr(10)||
'    {'||chr(10)||
'     if ($v(''P5100_LOCATION'')==''DB'' || $v(''P5100_LOCATION'')==''FILE'')'||chr(10)||
'       {'||chr(10)||
'        if (!$v_IsEmpty(''P5100_SOURCE_DISPLAY1''))'||chr(10)||
'          {'||chr(10)||
'           i';

ph:=ph||'f ($v_IsEmpty(''P5100_DESCRIPTION''))'||chr(10)||
'             {'||chr(10)||
'              alert("Description is required.");'||chr(10)||
'              //$f_First_field(''P5100_DESCRIPTION'');'||chr(10)||
'              //return false;'||chr(10)||
'              SetDescription();'||chr(10)||
'              return true;'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
'     return true;'||chr(10)||
'    }'||chr(10)||
' '||chr(10)||
'    function ReleaseCheck()'||chr(10)||
'    {'||chr(10)||
'     return true;'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"';

wwv_flow_api.create_page(
  p_id     => 5100,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Attachments',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P5100_SEL_ATTACHMENT.'');"',
  p_step_sub_title => 'Attachments',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'$(window).load(function(){  '||chr(10)||
''||chr(10)||
'  var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
''||chr(10)||
'});'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111007121108',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '21-OCT-2010  J.Faris - WCHG0000319 updated javascript ''description'' validation to set the default description instead of constantly popping the message.'||chr(10)||
''||chr(10)||
'11-Apr-2011 Tim Ward - Made Report not Use Pagination, gets rid of problems '||chr(10)||
'                       when items are deleted and Pagination changes.  User '||chr(10)||
'                       gets an ugly error until they close the browser and '||chr(10)||
'                       re-open it.  '||chr(10)||
''||chr(10)||
'                       Also set FileSize/Attached By/On to NoWrap to '||chr(10)||
'                       make them look better.'||chr(10)||
''||chr(10)||
'                       Made FileSize Right Justified.'||chr(10)||
''||chr(10)||
'                       Made the Report go 100% width.'||chr(10)||
''||chr(10)||
'18-May-2011 Tim Ward - CR#3783 and 3834 - Move Case File back to open if'||chr(10)||
'                       the "ROI/CSR Final Published" Report Type is changed.'||chr(10)||
'                       Changed in Process "change_status_back_OP", now runs'||chr(10)||
'                       on DELETE,SAVE.'||chr(10)||
''||chr(10)||
'07-Oct-2011 - CR#3946 - Add ParentInfo Open Link to Grid and Selected'||chr(10)||
'                        Attachment Detials so the users can get to the'||chr(10)||
'                        parent quickly (if it is not the same as this file).'||chr(10)||
'                        Added File/Activity to the Grid, changed the value'||chr(10)||
'                        of P5100_OBJ_TAG is in "Preload Items".  Changed '||chr(10)||
'                        Condition of P5100_OBJ_TAG to be displayed only if'||chr(10)||
'                        P5100_USAGE=''ATTACHMENT'' since that is the only one '||chr(10)||
'                        that has filters to show attachments from associated '||chr(10)||
'                        files/activities.  Also changed '||chr(10)||
'                        OSI_OBJECT.GET_OPEN_LINK so it returns 32000 instead '||chr(10)||
'                        of 200 in the Link since the parentinfo can be as long '||chr(10)||
'                        as the title + a few characters...'||chr(10)||
''||chr(10)||
'07-Oct-2011  Tim Ward - Added Shift Up/Down Key for Navigation. '||chr(10)||
'                        Added "JS_REPORT_AUTO_SCROLL" to HTML Header.  '||chr(10)||
'                        Added onkeydown="return checkForUpDownArrows '||chr(10)||
'                        (event, ''&P5100_SEL_ATTACHMENT.'');" to HTML Body'||chr(10)||
'                        Attribute. '||chr(10)||
'                        Added name=''#SID#'' to "Link Attributes" of the '||chr(10)||
'                        SID Column of the Report. '||chr(10)||
'                        Added a new Branch to'||chr(10)||
'                                 "f?p=&APP_ID.:5100:&SESSION.::&DEBUG.:::#&5100_SEL_NOTE.",'||chr(10)||
'                        this allows the report to move the the Anchor '||chr(10)||
'                        of the selected currentrow.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5100,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<div class="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 2573503288822953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
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
  p_plug_required_role => '!'||(5499017822598037+ wwv_flow_api.g_id_offset),
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
  p_id=> 8105502134151193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Access Denied',
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
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE = ''PERSONNEL'''||chr(10)||
'and'||chr(10)||
':TAB_ENABLED <> ''Y''',
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
  p_id=> 89968506459315951 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Details of Selected &P5100_USAGE_DISPLAY. <font color="red"><i>([shift]+[down]/[up] to navigate &P5100_USAGE_DISPLAY.(s))</i></font>',
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
  p_plug_display_when_condition => ':P5100_SEL_ATTACHMENT IS NOT NULL OR :P5100_MODE = ''ADD''',
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
  p_id=> 89968731421315953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
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
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
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
  p_id=> 89968931968315953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Choose the Attached Reports to Display',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5100_IS_FILE = ''Y''',
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
s:=s||'select a.sid "SID",'||chr(10)||
'       decode(a.storage_loc_type,'||chr(10)||
'              ''OUTSIDE'', '''','||chr(10)||
'              ''<a href=''''f?p=&APP_ID.:250:&SESSION.:'' || a.sid'||chr(10)||
'              || '':&DEBUG.:250:'''' target=''''_blank''''><img src="#IMAGE_PREFIX#themes/OSI/arrow_down-small.png" alt="Download/View" /></a>'') as "Download",'||chr(10)||
'       decode(a.mime_type,'||chr(10)||
'              null, ''Hard Copy'','||chr(10)||
'              ''<img src="&IMAGE_PREFIX.'''||chr(10)||
'';

s:=s||'              || osi_util.get_mime_icon(a.mime_type, a.source) || ''" alt="'' || a.mime_type || ''"> '') as "File Type",'||chr(10)||
'       a.description as "Description",'||chr(10)||
'       (select nvl(description, ''-'')'||chr(10)||
'          from t_osi_attachment_type at'||chr(10)||
'         where sid = a.type'||chr(10)||
'           and (   at.usage = :p5100_usage'||chr(10)||
'                or at.usage is null and :p5100_usage = ''ATTACHMENT'')) as "Attachment Type",'||chr(10)||
'    ';

s:=s||'   osi_util.parse_size(dbms_lob.getlength(a.content)) as "File Size",'||chr(10)||
'       a.create_by as "Attached By", a.create_on as "Date Attached",'||chr(10)||
'       decode(a.sid, :p5100_sel_attachment, ''Y'', ''N'') "Current",'||chr(10)||
'       decode(:P5100_OBJ, a.obj, core_obj.get_parentinfo(a.obj), osi_object.get_open_link(a.obj,core_obj.get_parentinfo(a.obj))) as "File/Activity"'||chr(10)||
'  from t_osi_attachment a,'||chr(10)||
'       t_osi_attachme';

s:=s||'nt_type at'||chr(10)||
' where (at.sid(+) = a.type'||chr(10)||
'   and nvl(at.usage, ''ATTACHMENT'') = :p5100_usage)'||chr(10)||
'   &P5100_FILTERS.';

wwv_flow_api.create_report_region (
  p_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_name=> '&P5100_USAGE_DISPLAY.s',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P0_obj_type_code <> ''PERSONNEL'''||chr(10)||
'or'||chr(10)||
'(:P0_OBJ_TYPE_CODE = ''PERSONNEL'' and :TAB_ENABLED = ''Y'')',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '1000000000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No &P5100_REPORT_MSG. found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '1000000000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P5100_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000627243874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
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
  p_id=> 96000728149874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Download',
  p_column_display_sequence=> 2,
  p_column_heading=> '&nbsp;',
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
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000821042874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'File Type',
  p_column_display_sequence=> 3,
  p_column_heading=> 'File Type',
  p_column_alignment=>'CENTER',
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
  p_id=> 96000911699874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Description',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Description',
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
  p_id=> 96001006826874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Attachment Type',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Attachment Type',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'ITEM_NOT_NULL_OR_ZERO',
  p_display_when_condition=> 'p5100_show_type',
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
  p_id=> 96001133157874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'File Size',
  p_column_display_sequence=> 6,
  p_column_heading=> 'File Size',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 96001229742874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Attached By',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Attached By',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 96001316967874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Date Attached',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Date Attached',
  p_column_format=> '&FMT_DATE.',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 96001428251874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 9,
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
  p_id=> 8268816223964004 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'File/Activity',
  p_column_display_sequence=> 10,
  p_column_heading=> 'File/Activity',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P5100_USAGE=''ATTACHMENT'''||chr(10)||
'AND :P5100_IS_FILE=''Y'''||chr(10)||
'AND :P5100_ASSOC_ATTACHMENTS NOT IN (''ME'')',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89969128704315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 40,
  p_button_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5100_ADD_LABEL.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> '(:P0_OBJ_TYPE_CODE not in (''PERSONNEL'',''UNIT'') and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
''||chr(10)||
'or'||chr(10)||
''||chr(10)||
'((:P0_OBJ_TYPE_CODE = ''PERSONNEL'' and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
'and'||chr(10)||
'osi_auth.check_for_priv(''ATCH'', :P0_OBJ_TYPE_SID) = ''Y'')'||chr(10)||
''||chr(10)||
'or'||chr(10)||
''||chr(10)||
'((:P0_OBJ_TYPE_CODE = ''UNIT'' and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
'and'||chr(10)||
'osi_auth.check_for_priv(''ATCH'', :P0_OBJ_TYPE_SID) = ''Y'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969714565315956 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 20,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5100_SEL_ATTACHMENT IS NOT NULL AND'||chr(10)||
':P5100_IS_ASSOC IS NOT NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969520283315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 30,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P5100_SEL_ATTACHMENT',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969307841315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 10,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P5100_SEL_ATTACHMENT IS NOT NULL'||chr(10)||
''||chr(10)||
'AND'||chr(10)||
''||chr(10)||
':P5100_IS_ASSOC IS NOT NULL'||chr(10)||
''||chr(10)||
'and'||chr(10)||
''||chr(10)||
'(osi_auth.check_for_priv(''ATCH_DELETE'', :p0_obj_type_sid) = ''Y'' or'||chr(10)||
':p5100_CREATING_PERSONNEL = :user_sid)'||chr(10)||
''||chr(10)||
'and'||chr(10)||
''||chr(10)||
'((:p0_obj_type_code = ''FILE.SFS'' and'||chr(10)||
' :p0_writable = ''Y'' and'||chr(10)||
' osi_object.get_status_code(:p0_obj) not in (''CL'',''SV'',''AV'',''RV'')) or true)',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16177023862626890 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 70,
  p_button_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 5100);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91072535069823301 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 60,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_cattributes=>'onclick="javascript:ReleaseCheck();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89977419753315976 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>89977231569315974 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_branch_action=> 'f?p=&APP_ID.:5100:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
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
  p_id=>6541403513057628 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_CREATING_PERSONNEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 335,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'CREATING_PERSONNEL',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8105819813151210 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ACCESS_DENIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8105502134151193+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Access Denied',
  p_source=>'You do not have permission to view the contents of this tab.',
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
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8751615819100764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_RPT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 345,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select sid '||chr(10)||
'from t_osi_attachment_type '||chr(10)||
'where (usage = ''REPORT'' and code = ''CR'') '||chr(10)||
'and obj_type = :p0_obj',
  p_source_type=> 'QUERY',
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
  p_id=>16177203908630507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 355,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
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
  p_id=>89970108112315956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_ATTACHMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SEL_ATTACHMENT=',
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
  p_id=>89970324808315956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Location',
  p_source=>'P5100_LOCATION_VALUE',
  p_source_type=> 'ITEM',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'SELECT DESCRIPTION, CODE'||chr(10)||
'FROM T_OSI_ATTACHMENT_LOC_TYPE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Location -',
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
  p_read_only_when=>'P5100_SEL_ATTACHMENT',
  p_read_only_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>89970517561315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source=>'DESCRIPTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onblur="javascript:CheckDescription();"',
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
  p_id=>89970730016315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DATE_MODIFIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Modified',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'DATE_MODIFIED',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>89970922565315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ_TAG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File/Activity',
  p_source_type=> 'ITEM',
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
  p_display_when=>':P5100_SEL_ATTACHMENT IS NOT NULL'||chr(10)||
'AND :P5100_USAGE=''ATTACHMENT'''||chr(10)||
'AND :P5100_IS_FILE=''Y'''||chr(10)||
'AND :P5100_ASSOC_ATTACHMENTS NOT IN (''ME'')',
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
  p_id=>89971135606315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Type',
  p_source=>'TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_attachment_type'||chr(10)||
'   where obj_type = :p0_obj_type_sid and usage = :p5100_usage'||chr(10)||
'     and (active = ''Y'' or sid = :p5100_sel_attachment)'||chr(10)||
'order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Attachment Type -',
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
  p_display_when=>'p5100_show_type',
  p_display_when_type=>'ITEM_NOT_NULL_OR_ZERO',
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
  p_id=>89971512072315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ASSOC_ATTACHMENTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 89968931968315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ME',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Attachments for this File;ME,Attachments for Associated Files;A_FILES,Attachments for Associated Activities;A_ACT,Attachments for Inherited Activities;I_ACT',
  p_lov_columns=> 4,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''UPDATE'');"',
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
  p_id=>89971709629315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_IS_FILE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_IS_FILE',
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
  p_id=>89971918229315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_USAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_USAGE',
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
  p_id=>89972135266315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_USAGE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_USAGE_DISPLAY',
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
  p_id=>89972324566315960 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ADD_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_ADD_LABEL',
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
  p_id=>89972514425315960 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_FILENAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'SUBSTR(:P5100_SOURCE, INSTR(:P5100_SOURCE, ''/'')+1)',
  p_source_type=> 'FUNCTION',
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
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'') AND :P5100_SEL_ATTACHMENT IS NOT NULL',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'SUBSTR(:P5100_SOURCE, INSTR(:P5100_SOURCE, ''/'')+1)');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972728423315962 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 305,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_OBJ=',
  p_source=>'OBJ',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>89972928881315967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DEFAULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_DEFAULT=',
  p_source=>'SELECT DEFAULT_SOURCE'||chr(10)||
'  FROM T_OSI_ATTACHMENT_LOC_TYPE'||chr(10)||
' WHERE CODE = :P5100_LOCATION;',
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
  p_id=>89973111291315967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE=',
  p_source=>'SOURCE',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>89973321073315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCATION_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_LOCATION_VALUE=',
  p_source=>'STORAGE_LOC_TYPE',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>89973723512315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DISPLAY1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 121,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '&P5100_SOURCE_DEFAULT.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
  p_display_as=> 'FILE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:SetDescription();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>89974116508315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 116,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'Filename',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_LABEL=',
  p_source=>'SELECT LT.SOURCE_LABEL'||chr(10)||
'  FROM T_OSI_ATTACHMENT_LOC_TYPE LT'||chr(10)||
' WHERE LT.CODE = :P5100_LOCATION',
  p_source_type=> 'QUERY',
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
  p_id=>89974306816315970 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DISPLAY2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 122,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '&P5100_SOURCE_DEFAULT.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
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
  p_display_when=>':P5100_LOCATION_VALUE = ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>90191435144745245 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_VALUE',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
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
  p_id=>91696110052924568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_FILE_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Type',
  p_source=>'select ''<img src="'' || ''&IMAGE_PREFIX.'''||chr(10)||
'       || osi_util.get_mime_icon(:p5100_mime_type, :p5100_source) || ''" alt="'' || :p5100_mime_type || ''"> '''||chr(10)||
'  from dual',
  p_source_type=> 'QUERY',
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
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
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
  p_id=>91696432216930996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_SIZE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Size',
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
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
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
  p_id=>91697016417935865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_ATTACHED_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Attached By',
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
  p_display_when=>'P5100_SEL_ATTACHMENT',
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
  p_id=>93438721493928231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DOWNLOAD_LINK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 155,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Download',
  p_source=>'<a href=''f?p=&APP_ID.:250:&SESSION.:&P5100_SEL_ATTACHMENT.:&DEBUG.:250:'' target=''_blank''>Download</a>',
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
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
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
  p_id=>93539128547458334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_MODE',
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
  p_id=>95314813809105521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_REPORT_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'LOWER(:P5100_USAGE_DISPLAY) || ''s''',
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
  p_id=>95795113446811165 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_MIME_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 315,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'MIME_TYPE',
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
  p_id=>95987930071629068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_FILTERS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_FILTERS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
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
  p_id=>96043334900410276 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_IS_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 320,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_IS_ASSOC',
  p_source=>'select 1'||chr(10)||
'  from t_osi_attachment'||chr(10)||
' where sid = :p5100_sel_attachment and obj = :p5100_obj;',
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
  p_id=>98521323722200984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SHOW_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 325,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
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
  p_id => 100412724608218170 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_TYPE',
  p_validation_sequence=> 1,
  p_validation => 'P5100_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Type must be specified.',
  p_validation_condition=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89975215668315971 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_LOCATION Not Null',
  p_validation_sequence=> 5,
  p_validation => 'P5100_LOCATION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Location must be specified.',
  p_validation_condition=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89970324808315956 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89974816169315970 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Soft copy not null',
  p_validation_sequence=> 10,
  p_validation => 'P5100_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P5100_SOURCE_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''CREATE'') AND :P5100_LOCATION IN (''DB'', ''FILE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89973723512315968 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 22-APR-2009 11:33');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89974609671315970 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Hard copy not null',
  p_validation_sequence=> 15,
  p_validation => 'P5100_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P5100_SOURCE_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''CREATE'', ''SAVE'') AND :P5100_LOCATION = ''OUTSIDE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89974306816315970 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89975031327315971 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_DESCRIPTION Not Null',
  p_validation_sequence=> 20,
  p_validation => 'P5100_DESCRIPTION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Description must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 89970517561315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 22-APR-2009 11:33');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8721015473382834 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Check max_num attach types',
  p_validation_sequence=> 30,
  p_validation => 'declare '||chr(10)||
''||chr(10)||
'       v_max_count varchar(10);'||chr(10)||
'       v_attach_count varchar(10);'||chr(10)||
'begin'||chr(10)||
'     if :P5100_TYPE is not null then'||chr(10)||
''||chr(10)||
'       select max_num into v_max_count'||chr(10)||
'             from t_osi_attachment_type where sid = :P5100_TYPE;'||chr(10)||
'     '||chr(10)||
'       if :P5100_SEL_ATTACHMENT IS NULL then'||chr(10)||
''||chr(10)||
'         select count(*) into v_attach_count'||chr(10)||
'           from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'          where a.obj = :P0_OBJ'||chr(10)||
'            and a.type = at.sid'||chr(10)||
'            and at.sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         select count(*) into v_attach_count'||chr(10)||
'           from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'          where a.obj = :P0_OBJ'||chr(10)||
'            and a.type = at.sid'||chr(10)||
'            and at.sid = :P5100_TYPE'||chr(10)||
'            and a.sid != :P5100_SEL_ATTACHMENT;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'       if(v_attach_count >= v_max_count) then'||chr(10)||
''||chr(10)||
'         return ''There can only be '' || v_max_count || '||chr(10)||
'                '' Attachment of this type in this object.'';'||chr(10)||
''||chr(10)||
'       else '||chr(10)||
''||chr(10)||
'        return null;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Attachment type already exists on this File. ',
  p_validation_condition=> ':REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT'''||chr(10)||
''||chr(10)||
''||chr(10)||
'declare '||chr(10)||
''||chr(10)||
'       v_max_count varchar(10);'||chr(10)||
'       v_attach_count varchar(10);'||chr(10)||
'begin'||chr(10)||
'     select max_num'||chr(10)||
'       into v_max_count'||chr(10)||
'     from t_osi_attachment_type'||chr(10)||
'      where sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'     select count(*)'||chr(10)||
'       into v_attach_count'||chr(10)||
'       from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'      where a.obj = :P0_OBJ'||chr(10)||
'       and a.type = at.sid'||chr(10)||
'       and at.sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'     if(v_attach_count >= v_max_count) then'||chr(10)||
''||chr(10)||
'       return ''There can only be '' || v_max_count || '' Attachment of this type in this object.'';'||chr(10)||
''||chr(10)||
'     else '||chr(10)||
''||chr(10)||
'      return null;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'end;');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8782524288390115 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Save/Delete SCR',
  p_validation_sequence=> 40,
  p_validation => 'declare'||chr(10)||
''||chr(10)||
'   v_scr varchar2(20);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'     select sid'||chr(10)||
'     into v_scr'||chr(10)||
'     from t_osi_attachment_type'||chr(10)||
'     where usage = ''REPORT'''||chr(10)||
'     and code = ''CR'''||chr(10)||
'     and obj_type = :p0_obj_type_sid;'||chr(10)||
''||chr(10)||
'if (:p5100_type = v_scr) then'||chr(10)||
''||chr(10)||
'return ''You cannot edit or delete Complaint Report.'';'||chr(10)||
''||chr(10)||
'else'||chr(10)||
''||chr(10)||
'return null;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Error',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''DELETE'') and'||chr(10)||
'osi_object.get_status(:P0_OBJ) not in (''New'', ''Awaiting Approval'') and'||chr(10)||
'osi_object.get_objtype_code(core_obj.get_objtype(:P0_OBJ)) like ''FILE.INV%''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> ':REQUEST IN (''SAVE'',''DELETE'') and'||chr(10)||
'osi_object.get_status(:P0_OBJ) not in (''New'', ''Awaiting Approval'') and'||chr(10)||
'select osi_object.get_objtype_code(core_obj.get_objtype(:P0_OBJ)) like ''FILE.INV%''');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11827424158571048 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 45,
  p_validation => 'P5100_DATE_MODIFIED',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P5100_DATE_MODIFIED IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89970730016315957 + wwv_flow_api.g_id_offset,
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
'  procedure l(p_log_text varchar2) is'||chr(10)||
'  begin'||chr(10)||
'     core_logger.log_it(''timtest'', p_log_text);'||chr(10)||
'  end l;'||chr(10)||
'begin'||chr(10)||
'  l('' '');'||chr(10)||
'  l(''obj:'' || :p5100_obj || '', '' || core_obj.get_tagline(:p5100_obj));'||chr(10)||
'  l(''sid:'' || :p5100_sel_attachment);'||chr(10)||
'  l(''text:'' || :p5100_description);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6690205082622300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'debug',
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
p:=p||'begin'||chr(10)||
'    if (:request in(''ADD'', ''P5100_LOCATION'')) then'||chr(10)||
'        :p5100_mode := ''ADD'';'||chr(10)||
'    else'||chr(10)||
'        :p5100_mode := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95132918713047790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set mode',
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
p:=p||'#OWNER#:T_OSI_ATTACHMENT:P5100_SEL_ATTACHMENT:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 95299420877142370 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Do T_OSI_ATTACHMENT',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CREATE,SAVE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P5100_SEL_ATTACHMENT',
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
'    v_blob   blob          := null;'||chr(10)||
'    v_file   varchar2(400) := null;'||chr(10)||
'    v_mime   varchar2(255)  := null;'||chr(10)||
''||chr(10)||
'    procedure upload(p_source in varchar2) is'||chr(10)||
'    begin'||chr(10)||
'        select blob_content, filename, mime_type'||chr(10)||
'          into v_blob, v_file, v_mime'||chr(10)||
'          from wwv_flow_files'||chr(10)||
'         where name = p_source;'||chr(10)||
''||chr(10)||
'        update t_osi_attachment'||chr(10)||
'           set content = v_blob,'||chr(10)||
'           ';

p:=p||'    source = v_file,'||chr(10)||
'               mime_type = v_mime,'||chr(10)||
'               type = :p5100_type,'||chr(10)||
'               storage_loc_type = :p5100_location_value,'||chr(10)||
'               description = :p5100_description'||chr(10)||
'         where sid = :p5100_sel_attachment;'||chr(10)||
'    end;'||chr(10)||
'begin'||chr(10)||
'    if (:p5100_location_value <> ''OUTSIDE'') then'||chr(10)||
'        if (:request = ''CREATE'') then'||chr(10)||
'            upload(:p5100_source);'||chr(10)||
'        elsif(:request ';

p:=p||'= ''SAVE'') then'||chr(10)||
'            if (:p5100_source <> :p5100_source_display1) then'||chr(10)||
'                --A new attachment was given.'||chr(10)||
'                upload(:p5100_source_display1);'||chr(10)||
'            else'||chr(10)||
'                update t_osi_attachment'||chr(10)||
'                   set type = :p5100_type,'||chr(10)||
'                       storage_loc_type = :p5100_location_value,'||chr(10)||
'                       description = :p5100_description'||chr(10)||
'        ';

p:=p||'         where sid = :p5100_sel_attachment;'||chr(10)||
'            end if;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90170733611516101 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get the BLOB',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,SAVE',
  p_process_when_type=>'',
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
'   v_status_change_sid varchar2(20);'||chr(10)||
'   v_current_status varchar2(20);'||chr(10)||
'   v_type varchar(50);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     '||chr(10)||
'  if(:P0_OBJ_TYPE_CODE like ''FILE.INV%'' and :P5100_USAGE = ''REPORT'') then'||chr(10)||
''||chr(10)||
'       select at.sid'||chr(10)||
'         into v_type'||chr(10)||
'         from t_osi_attachment_type at'||chr(10)||
'        where at.usage = ''REPORT'''||chr(10)||
'         and at.code = ''ROIFP'''||chr(10)||
'         and at.obj_type = :P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'       v_current_s';

p:=p||'tatus := osi_object.get_status_code(:P0_OBJ);'||chr(10)||
''||chr(10)||
'   if (v_current_status = ''OP'' and :P5100_TYPE = v_type) then'||chr(10)||
''||chr(10)||
'      select sc.sid'||chr(10)||
'        into v_status_change_sid'||chr(10)||
'        from t_osi_status_change sc, t_osi_status s1, t_osi_status s2'||chr(10)||
'       where sc.from_status = s1.sid'||chr(10)||
'        and sc.to_status = s2.sid'||chr(10)||
'        and s1.code = ''OP'''||chr(10)||
'        and s2.code = ''IC'''||chr(10)||
'        and sc.obj_type = core_obj.lookup_';

p:=p||'objtype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'      osi_status.change_status(:P0_OBJ, v_status_change_sid);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8583804323504898 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 16,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'change_status_to_IC',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,SAVE',
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
p:=p||'Declare'||chr(10)||
''||chr(10)||
'  v_status_change_sid varchar2(20);'||chr(10)||
'  v_current_status varchar2(20);'||chr(10)||
'  v_type varchar2(20);'||chr(10)||
'  v_attach_count varchar2(10);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if (:P0_OBJ_TYPE_CODE like ''FILE.INV%'' and :P5100_USAGE = ''REPORT'') then'||chr(10)||
''||chr(10)||
'    select at.sid into v_type from t_osi_attachment_type at'||chr(10)||
'     where at.usage = ''REPORT'''||chr(10)||
'       and at.code = ''ROIFP'''||chr(10)||
'       and at.obj_type = :P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'    select count(*) ';

p:=p||'into v_attach_count from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'     where obj = :P0_OBJ '||chr(10)||
'       and a.type = at.sid'||chr(10)||
'       and at.code = ''ROIFP'';'||chr(10)||
' '||chr(10)||
'    v_current_status := osi_object.get_status_code(:P0_OBJ);'||chr(10)||
''||chr(10)||
'    ---if (v_current_status = ''IC'' and :P5100_TYPE = v_type and v_attach_count = 0) then    '||chr(10)||
'    if (v_current_status = ''IC'' and ((:P5100_TYPE = v_type and :request=''DELETE'') or (:P51';

p:=p||'00_TYPE != v_type and :request=''SAVE'')) and v_attach_count = 0) then    '||chr(10)||
''||chr(10)||
'      select sc.sid into v_status_change_sid from t_osi_status_change sc, t_osi_status s1, t_osi_status s2'||chr(10)||
'       where sc.from_status = s1.sid'||chr(10)||
'         and sc.to_status = s2.sid'||chr(10)||
'         and s1.code = ''IC'''||chr(10)||
'         and s2.code = ''IC'''||chr(10)||
'         and sc.transition = ''Reopen'''||chr(10)||
'         and sc.obj_type = core_obj.lookup_objtype(''F';

p:=p||'ILE.INV'');'||chr(10)||
''||chr(10)||
'      osi_status.change_status(:P0_OBJ, v_status_change_sid);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8593206971272143 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 17,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'change_status_back_OP',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'DELETE,SAVE',
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
p:=p||'begin'||chr(10)||
'    if (   :request in(''ADD'', ''DELETE'', ''CANCEL'')'||chr(10)||
'        or :request like ''EDIT_%'') then'||chr(10)||
'        :p5100_type := null;'||chr(10)||
'        :p5100_source_label := null;'||chr(10)||
'        :p5100_description := null;'||chr(10)||
'        :p5100_date_modified := null;'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'        :p5100_location_value := null;'||chr(10)||
'        :p5100_location := null;'||chr(10)||
'        :p5100_date_modified := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:r';

p:=p||'equest in (''ADD'',''DELETE'')) then'||chr(10)||
'        :p5100_sel_attachment := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''P5100_LOCATION'') then'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 93949220719504334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear fields',
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
p:=p||':P5100_SEL_ATTACHMENT := SUBSTR(:REQUEST, 6);';

wwv_flow_api.create_page_process(
  p_id     => 89975928747315973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Attachment',
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
p:=p||'begin'||chr(10)||
'    :p5100_obj  := :p0_obj;'||chr(10)||
'    :p5100_usage := :tab_params;'||chr(10)||
''||chr(10)||
'    select count(sid)'||chr(10)||
'      into :p5100_show_type'||chr(10)||
'      from t_osi_attachment_type'||chr(10)||
'     where obj_type = :p0_obj_type_sid'||chr(10)||
'       and usage = :p5100_usage and active = ''Y'';'||chr(10)||
''||chr(10)||
'    if (:p5100_assoc_attachments is null) then'||chr(10)||
'        :p5100_assoc_attachments := ''ME'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_sel_attachment';

p:=p||' is not null) then'||chr(10)||
'        select decode(at.description, ''NULL'', ''''),'||chr(10)||
'               osi_util.parse_size(dbms_lob.getlength(a.content)), a.create_by,'||chr(10)||
'               decode(a.obj, :P5100_OBJ, core_obj.get_parentinfo(a.obj), osi_object.get_open_link(a.obj,core_obj.get_parentinfo(a.obj)))'||chr(10)||
'          into :p5100_sel_type,'||chr(10)||
'               :p5100_sel_size, :p5100_sel_attached_by,'||chr(10)||
'               :p5100_obj';

p:=p||'_tag'||chr(10)||
'          from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'         where a.sid = :p5100_sel_attachment and a.type = at.sid(+);'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_usage = ''ATTACHMENT'') then'||chr(10)||
'        :p5100_usage_display := initcap(:p5100_usage);'||chr(10)||
'        :p5100_add_label := :btn_add || '' Attachment(s)'';'||chr(10)||
''||chr(10)||
'        if (instr(:p0_obj_type_code, ''FILE.'', 1, 1) > 0) then'||chr(10)||
'            :p5100_is_file := ''Y'';'||chr(10)||
'';

p:=p||'        else'||chr(10)||
'            :p5100_is_file := ''N'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_usage = ''REPORT'') then'||chr(10)||
'        :p5100_usage_display := ''Attached '' || initcap(:p5100_usage);'||chr(10)||
'        :p5100_add_label := :btn_add || '' Report(s)'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
'    when no_data_found then'||chr(10)||
'        return;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89975310618315971 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload Items',
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
p:=p||'declare'||chr(10)||
'    v_add_or   boolean := false;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'    :p5100_filters := null;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''ME'') > 0) then'||chr(10)||
'        v_add_or := true;'||chr(10)||
'        :p5100_filters := :p5100_filters'||chr(10)||
'                       || '' a.obj = '''''' || :p0_obj || '''''''';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''A_FILES'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_fi';

p:=p||'lters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p5100_filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in (select that_file from v_osi_assoc_fle_fle where this_file = '''''''||chr(10)||
'            || :p0_obj || '''''')'';'||chr(10)||
'        v_add_or := true;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''A_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_filters || '' or '';'||chr(10)||
'        ';

p:=p||'end if;'||chr(10)||
''||chr(10)||
'        :p5100_filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in(select activity_sid from v_osi_assoc_fle_act where file_sid = '''''''||chr(10)||
'            || :p0_obj || '''''')'';'||chr(10)||
'        v_add_or := true;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''I_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_filters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p5100_';

p:=p||'filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in(select activity_sid'||chr(10)||
'                  from v_osi_assoc_fle_act'||chr(10)||
'                 where file_sid in(select that_file'||chr(10)||
'                                     from v_osi_assoc_fle_fle'||chr(10)||
'                                    where this_file = '''''''||chr(10)||
'            || :p0_obj || ''''''))'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'   if :p5100_filters is not null then'||chr(10)||
'       :p5100_fi';

p:=p||'lters := '' and ('' || :p5100_filters || '')'';'||chr(10)||
'   end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95988135397639971 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Build WHERE clause',
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
p:=p||'F|#OWNER#:T_OSI_ATTACHMENT:P5100_SEL_ATTACHMENT:SID';

wwv_flow_api.create_page_process(
  p_id     => 91758918521863790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch T_OSI_ATTACHMENT',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P5100_SEL_ATTACHMENT IS NOT NULL AND :REQUEST <> ''P5100_LOCATION''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P5100_SEL_ATTACHMENT',
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
'    if (   osi_auth.check_for_priv(''TAB_ATTACHMENTS'', :p0_obj_type_sid) = ''Y'''||chr(10)||
'        or osi_auth.check_for_priv(''TAB_ALL'', :p0_obj_type_sid) = ''Y'') then'||chr(10)||
'        :tab_enabled := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        :tab_enabled := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8106112177154029 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetTabDisabler',
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
p:=p||'begin'||chr(10)||
'    if (:request = ''CREATE'') then        '||chr(10)||
'        :p5100_location_value := :p5100_location;'||chr(10)||
'    '||chr(10)||
'        if (:p5100_location_value in(''DB'', ''FILE'')) then'||chr(10)||
'            :p5100_source := :p5100_source_display1;'||chr(10)||
'        else'||chr(10)||
'            :p5100_source := :p5100_source_display2;'||chr(10)||
'        end if;'||chr(10)||
'        '||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''SAVE'' and :p5100_location_value = ''OUTSIDE'') then'||chr(10)||
'        :p510';

p:=p||'0_source := :p5100_source_display2;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''P5100_LOCATION'') then'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'        :p5100_location_value := :p5100_location;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89976131007315973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set source',
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
-- ...updatable report columns for page 5100
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

commit;