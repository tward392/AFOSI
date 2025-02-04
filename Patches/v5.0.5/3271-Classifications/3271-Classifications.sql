INSERT INTO T_CORE_CONFIG ( SID, CODE, SETTING, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184P7', 'OSI.ALLOW_CLASSIFICATIONS', 'N', 'Allow the Classify Action To Be Visible', 'timothy.ward',  TO_Date( '11/08/2011 09:29:37 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 09:29:37 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;


alter table t_core_classification_level add active varchar2(1) default 'Y';

update t_core_classification_level set active='N' where code='TS';

commit;


ALTER TABLE T_CORE_CLASSIFICATION_RT DISABLE CONSTRAINT FK_CORE_CLSRT_RT;

DELETE FROM T_CORE_CLASSIFICATION_RT_DEST;

INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '2220000040J', 'GBR', 'Great Britain', 2, 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '2220000040K', 'AUS', 'Australia', 2, 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '2220000040L', 'FRA', 'France', 2, 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '2220000040M', 'GER', 'Germany', 2, 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '2220000040N', 'CAN', 'Canada', 2, 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '2220000040O', 'USA', 'United States of America', 1, 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '2220000040P', 'NATO', 'NATO North Atlantic Treaty Organization', 3, 'I2MS\Richard.Hull',  TO_Date( '03/10/2006 03:30:11 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:49:34 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333183IN', 'KOR', 'Korea', 4, 'timothy.ward',  TO_Date( '10/24/2011 06:53:52 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/24/2011 06:53:52 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333183IO', 'TUR', 'Turkey', 5, 'timothy.ward',  TO_Date( '10/24/2011 06:54:01 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/24/2011 06:54:01 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OM', 'NZL', 'New Zealand', 6, 'timothy.ward',  TO_Date( '11/08/2011 08:39:29 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:50 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184ON', 'ACGU', 'ACGU Australia, Canada, Great Britain, United States of America', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:40:27 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:35 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OO', 'FVEY', 'FVEY Five Eyes', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:40:45 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:43 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OP', 'CNFC', 'CNFC Combined Naval Forces Central Command', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:41:20 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:36 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OQ', 'CPMT', 'CPMT Civilan Protection Monitoring Team for Sudan', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:41:38 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:42 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OR', 'CWCS', 'CWCS Chemical Weapons Convention States', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:41:52 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:43 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OS', 'ECTF', 'ECTF European Counter-Terrorism Forces', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:42:09 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:43 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OT', 'GCTF', 'GCTF Global Counter-Terrorism Forces', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:42:41 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:43 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OU', 'GMIF', 'GMIF Global Maritime Interception Forces', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:42:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:44 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OV', 'ISAF', 'ISAF International Security Assistance Forces for Afghanistan', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:43:19 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:44 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OW', 'KFOR', 'KFOR Stabilization Forces in Kosovo', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:46:26 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:44 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OX', 'MCFI', 'MCFI Multinational Coalition Forces - Iraq', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:46:58 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:44 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OY', 'MPFL', 'MPFL Multinational Peacekeeping Forces - Liberia', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:48:12 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:45 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184OZ', 'OSAG', 'OSAG Olympic Security Advisory Group', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:48:56 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:45 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_CORE_CLASSIFICATION_RT_DEST ( SID, CODE, DESCRIPTION, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333184P0', 'SFOR', 'SFOR Stabilization Forces in Bosnia', 3, 'timothy.ward',  TO_Date( '11/08/2011 08:49:14 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '11/08/2011 08:51:46 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

ALTER TABLE T_CORE_CLASSIFICATION_RT ENABLE CONSTRAINT FK_CORE_CLSRT_RT;

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
     25-Oct-2011 Tim Ward        Now looks up Object Classification, if not found, uses the OSI.DEFAULT_CLASS.
                                  Changed in getstatusbar.
                                  
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
        v_classification varchar2(4000);
        
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
           
           v_classification := core_classification.FULL_MARKING(p_obj_sid);
           
           if v_classification is null or v_classification='' then
  
             v_classification := core_util.GET_CONFIG('OSI.DEFAULT_CLASS');
             
             if length(v_classification)<2 then
               
               begin
                    select description into v_classification from t_core_classification_level where code=v_classification;
               
               exception when others then

                             v_classification := core_util.GET_CONFIG('OSI.DEFAULT_CLASS');
               
               end;
               
             end if;
  
           end if;
           v_return := v_return || '  <li>This OBJECT IS Classified:  ' || v_classification || '<small>Classification</small></li>' || CHR(10) || CHR(13);
     
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
--   Date and Time:   10:25 Tuesday November 8, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Actions
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
 
 
prompt Component Export: LIST 92826724656999729
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Actions',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'Actions',
  p_list_item_link_target=> '',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2520728589513384 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6,
  p_list_item_link_text=> 'Check DEERS',
  p_list_item_link_target=> 'javascript:checkDeers(''&P0_OBJ.'');" onclick="javascript:runDirtyTest(''Action''); return !(checkDirty());',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':p0_obj_type_code = ''PART.INDIV'' and'||chr(10)||
'(:p0_obj_context is null or'||chr(10)||
' :p0_obj_context = osi_participant.get_current_version(:p0_obj))',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 100181419940409692 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7,
  p_list_item_link_text=> 'Delete',
  p_list_item_link_target=> 'javascript:deleteObj(''&P0_OBJ.'',''DELETE_OBJECT'');',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_OBJ',
  p_list_item_disp_condition2=> 'javascript:doSubmit(''DELETE_OBJECT'');',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2720026837350801 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7.1,
  p_list_item_link_text=> 'Generate Narrative',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:showPopWin(''f?p=&APP_ID.:22010:&SESSION.::&DEBUG.:22010:::'',600,600,null);return false;',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':p0_obj_type_code = ''ACT.INIT_NOTIF''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827224358027970 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS1.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS1.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS1',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827538210031946 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS2.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS2.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS2',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827710983033635 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS3.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS3.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS3',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827914792034698 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS4.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS4.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS4',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92834125022151189 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS5.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS5.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS5',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92834327793151960 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS6.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS6.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS6',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5681128439478298 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS7.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS7.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS7',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 8397824798935030 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> 'Classify',
  p_list_item_link_target=> 'javascript:newWindow({page:765,clear_cache:''765'',name:''&P0_OBJ._CLASSIFICATION'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P765_OBJ,P765_CONTEXT'',item_values:''&P0_OBJ.,,&P0_OBJ.,'',request:''CLASSIFICATION''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> 'CORE_UTIL.GET_CONFIG(''OSI.ALLOW_CLASSIFICATIONS'')=''Y''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 16340017748308654 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>80,
  p_list_item_link_text=> 'Masking',
  p_list_item_link_target=> 'javascript:newWindow({page:760,clear_cache:''760'',name:''&P0_OBJ._MASK'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P760_OBJ'',item_values:''&P0_OBJ.,,&P0_OBJ.'',request:''MASK''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE in (''ACT.INTERVIEW.WITNESS'',''ACT.SOURCE_MEET'',''ACT.SURVEILLANCE'')',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 17869823711799476 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>90,
  p_list_item_link_text=> 'Duplicate Legacy I2MS Source Search',
  p_list_item_link_target=> 'javascript:newWindow({page:11330,clear_cache:''11330'',name:''&P0_OBJ._SRCSRCH'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P11330_OBJ'',item_values:''&P0_OBJ.,,&P0_OBJ.'',request:''SRCH''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE = ''FILE.SOURCE''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 22212726543600706 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>100,
  p_list_item_link_text=> 'Legacy I2MS Relationship Search',
  p_list_item_link_target=> 'javascript:importRelations(''&P0_OBJ.'',''IMPORT_RELATIONS'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE like (''PART.%'') and osi_participant.get_imp_relations_flag(:P0_OBJ) = ''N''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
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
--   Date and Time:   09:27 Tuesday October 25, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: CLASSIFICATIONPREVIEW
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
 
 
prompt Component Export: APP PROCESS 8659721679334624
 
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
'  v_class       varchar2(20)    := apex_application.g_x01;'||chr(10)||
'  v_disseminate varchar2(32000) := apex_application.g_x02;'||chr(10)||
'  v_release_to  varchar2(32000) := apex_application.g_x03;'||chr(10)||
'  v_result      varchar2(32000);'||chr(10)||
'  v_temp        varchar2(32000);'||chr(10)||
'  v_cnt         number;'||chr(10)||
'  v_tot_rt      number;'||chr(10)||
'  v_tot_hi      number;'||chr(10)||
'  v_blockRT     number := 0;'||chr(10)||
'  v_block_temp  varchar2(1);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     select';

p:=p||' count(*) into v_tot_rt '||chr(10)||
'           from table(split(v_release_to,'':'')) where column_value is not null;'||chr(10)||
''||chr(10)||
'     select count(*) into v_tot_hi '||chr(10)||
'           from table(split(v_disseminate,'':'')) where column_value is not null;'||chr(10)||
'       '||chr(10)||
'     if v_class is null or v_class = '''' or v_class = ''~~~''then'||chr(10)||
'       '||chr(10)||
'       v_result:='''';'||chr(10)||
''||chr(10)||
'     else     '||chr(10)||
''||chr(10)||
'       select description into v_result from t_core_classifica';

p:=p||'tion_level'||chr(10)||
'             where sid=v_class;'||chr(10)||
'     '||chr(10)||
'       v_cnt := 1;'||chr(10)||
'       for d in (select column_value from table(split(v_disseminate,'':''))'||chr(10)||
'                  where column_value is not null)'||chr(10)||
'       loop'||chr(10)||
'           select code,blocks_rt into v_temp,v_block_temp'||chr(10)||
'               from t_core_classification_hi_type'||chr(10)||
'                 where sid=d.column_value;'||chr(10)||
'         '||chr(10)||
'           if v_cnt = 1 then'||chr(10)||
''||chr(10)||
'     ';

p:=p||'        v_result := v_result || ''//'';'||chr(10)||
''||chr(10)||
'           else'||chr(10)||
''||chr(10)||
'             v_result := v_result || '','';'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
''||chr(10)||
'           v_result := v_result || v_temp;'||chr(10)||
'           v_cnt := v_cnt + 1;'||chr(10)||
'         '||chr(10)||
'           if v_block_temp <> ''N'' then'||chr(10)||
'           '||chr(10)||
'             v_blockRT := 1;'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
''||chr(10)||
'       end loop;'||chr(10)||
'     '||chr(10)||
'       if v_blockRT = 0 then'||chr(10)||
''||chr(10)||
'         if v_tot_rt > 0 then'||chr(10)||
'           '||chr(10)||
' ';

p:=p||'          if v_tot_hi > 0 then'||chr(10)||
''||chr(10)||
'             v_result := v_result || '','';'||chr(10)||
''||chr(10)||
'           else'||chr(10)||
''||chr(10)||
'             v_result := v_result || ''//'';'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
'     '||chr(10)||
'           if v_tot_rt > 0 then'||chr(10)||
'   '||chr(10)||
'             v_result := v_result || ''REL TO USA'';'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
'     '||chr(10)||
'           v_cnt := 1;'||chr(10)||
'           for r in (select column_value from table(split(v_release_to,'':''))'||chr(10)||
'                      wher';

p:=p||'e column_value is not null)'||chr(10)||
'           loop'||chr(10)||
'               select code into v_temp from t_core_classification_rt_dest'||chr(10)||
'                     where sid=r.column_value;'||chr(10)||
'         '||chr(10)||
'               if v_cnt = v_tot_rt then'||chr(10)||
'           '||chr(10)||
'                 v_result := v_result || '' AND '' || v_temp;'||chr(10)||
'  '||chr(10)||
'               else '||chr(10)||
'  '||chr(10)||
'                 v_result := v_result || '','' || v_temp;'||chr(10)||
''||chr(10)||
'               end if;'||chr(10)||
'      ';

p:=p||'         v_cnt := v_cnt + 1;'||chr(10)||
'  '||chr(10)||
'           end loop;'||chr(10)||
''||chr(10)||
'         end if;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     htp.p(v_result);'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 8659721679334624 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'CLASSIFICATIONPREVIEW',
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
--   Date and Time:   10:24 Tuesday November 8, 2011
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

PROMPT ...Remove page 765
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>765);
 
end;
/

 
--application/pages/page_00765
prompt  ...PAGE 765: Classify
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 765,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Classify',
  p_step_title=> 'Classify',
  p_html_page_onload=>'onload="javascript:ClassificationPreview();"',
  p_step_sub_title => 'Classify',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_welcome_text=> '<script language="JavaScript" type="text/javascript">'||chr(10)||
' if (''&P765_DONE.'' == ''Y'')'||chr(10)||
'   {'||chr(10)||
'    window.opener.location.reload(true);'||chr(10)||
'    close();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'function ClassificationPreview()'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                           $v(''pFlowId''),'||chr(10)||
'                           ''APPLICATION_PROCESS=CLASSIFICATIONPREVIEW'','||chr(10)||
'                           $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',$v(''P765_CLASSIFICATION'')); '||chr(10)||
' get.addParam(''x02'',$v(''P765_DISSEMINATION''));     '||chr(10)||
' get.addParam(''x03'',$v(''P765_RELEASE_TO''));     '||chr(10)||
' '||chr(10)||
' gReturn = get.get();'||chr(10)||
' $s(''P765_PREVIEW'',gReturn);'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111108092447',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
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
  p_id=> 8362305733907974 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 765,
  p_plug_name=> 'Classify',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 8362500335907982 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 765,
  p_button_sequence=> 10,
  p_button_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P765_SID is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8362726574907984 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 765,
  p_button_sequence=> 15,
  p_button_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P765_SID is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8362921708907984 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 765,
  p_button_sequence=> 20,
  p_button_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>8365008500907994 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_branch_action=> 'f?p=&APP_ID.:765:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-OCT-2010 11:00 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8363107852907984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_CLASSIFICATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Classification:',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select description d, sid r'||chr(10)||
'  from t_core_classification_level'||chr(10)||
'   where active=''Y'' order by weight',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Classification Type -',
  p_lov_null_value=> '~~~',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%"',
  p_tag_attributes2=> 'style="width:100%"',
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
  p_id=>8363312271907987 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P765_SID',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>8363707750907987 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P765_OBJ',
  p_source=>'OBJ',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>8365416546937012 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_PREVIEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'style="width:100%;"',
  p_tag_attributes  => 'style="width:100%; height:85px;" readonly="readonly"',
  p_tag_attributes2=> 'style="width:100%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 3,
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
  p_id=>8366900541027015 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_DISSEMINATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Dissemination<br>Controls:',
  p_pre_element_text=>'<div class="scrollChecklist" style="height:175px;">',
  p_post_element_text=>'</div>',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => '&P765_DISS_SELECT.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_tag_attributes  => 'onclick="javascript:ClassificationPreview();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P765_CLASSIFICATION is not null and'||chr(10)||
':P765_CLASSIFICATION not in (''~~~'') and'||chr(10)||
'length(:P765_CLASSIFICATION) <> 0',
  p_display_when_type=>'SQL_EXPRESSION',
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
  p_id=>8368306260066509 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_RELEASE_TO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Release To:',
  p_pre_element_text=>'<div class="scrollChecklist" style="height:175px;">',
  p_post_element_text=>'</div>',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'select description display_value, sid return_value '||chr(10)||
'from t_core_classification_rt_dest'||chr(10)||
'where code <> ''USA'' order by seq, code',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_tag_attributes  => 'onclick="javascript:ClassificationPreview();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P765_RELEASE_TO_VISIBLE',
  p_display_when2=>'Y',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>8370115252392966 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_DISS_SELECT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Diss Select',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%"',
  p_tag_attributes2=> 'style="width:100%"',
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
  p_id=>8395728495727975 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_RELEASE_TO_VISIBLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Release To Visible',
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
  p_id=>8398314165064438 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_CLASSIFICATION_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Classification Code',
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
  p_id=>8718118346461282 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P765_DONE',
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
  p_id=>8784624237937682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_CONTEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Context',
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'if :P765_CLASSIFICATION is null or :P765_CLASSIFICATION='''' or :P765_CLASSIFICATION=''~~~'' then'||chr(10)||
'  '||chr(10)||
'  :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'  :P765_CLASSIFICATION_CODE:=NULL;'||chr(10)||
''||chr(10)||
'else'||chr(10)||
'  '||chr(10)||
'  begin'||chr(10)||
'       select RT_ALLOWED,CODE INTO :P765_RELEASE_TO_VISIBLE,:P765_CLASSIFICATION_CODE '||chr(10)||
'             from t_core_classification_level where sid=:P765_CLASSIFICATION;'||chr(10)||
''||chr(10)||
'  exception when others then'||chr(10)||
'           '||chr(10)||
'         ';

p:=p||'  :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'           :P765_CLASSIFICATION_CODE := ''U'';'||chr(10)||
''||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
':P765_DISS_SELECT := ''select t.description display_value, t.sid return_value '' ||'||chr(10)||
'                     ''        from t_core_classification_hi_type t,'' ||'||chr(10)||
'                     ''             t_core_classification_level_hi h,'' ||'||chr(10)||
'                     ''             t_core_classification_level l'' ||'||chr(10)||
'      ';

p:=p||'               ''          where t.sid=h.hi '' ||'||chr(10)||
'                     ''            and l.sid=h.lvl '' ||'||chr(10)||
'                     ''            and l.code='' || '''''''' || :P765_CLASSIFICATION_CODE || '''''''' ||'||chr(10)||
'                     ''               order by t.seq, t.description'';';

wwv_flow_api.create_page_process(
  p_id     => 8481122888596860 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Classification Picked',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P765_CLASSIFICATION',
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
p:=p||'if :p765_sid is not null then'||chr(10)||
''||chr(10)||
'  delete from t_core_classification_hi where marking=:p765_sid;'||chr(10)||
'  delete from t_core_classification_rt where marking=:p765_sid;'||chr(10)||
'  commit;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P765_CLASSIFICATION is not null and'||chr(10)||
'   :P765_CLASSIFICATION not in (''~~~'') and'||chr(10)||
'   length(:P765_CLASSIFICATION) <> 0 then'||chr(10)||
''||chr(10)||
'  if :REQUEST in (''SAVE'') then'||chr(10)||
'    '||chr(10)||
'    update t_core_classification set class_level=:p765_clas';

p:=p||'sification'||chr(10)||
'      where sid=:p765_sid;'||chr(10)||
'    commit;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    insert into t_core_classification  '||chr(10)||
'           (obj,obj_context,class_level,hi_applies,rt_applies) '||chr(10)||
'    values (:p765_obj,:p765_context,:p765_classification,''N'',''N'') returning sid into :p765_sid;'||chr(10)||
'    commit;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if length(nvl(:P765_DISSEMINATION,'''')) > 0 then'||chr(10)||
''||chr(10)||
'    for i in (select column_value from table(split(:P765_DISSEMINA';

p:=p||'TION,'':'')) '||chr(10)||
'                    where column_value is not null)'||chr(10)||
'    loop'||chr(10)||
'       '||chr(10)||
'        insert into t_core_classification_hi (marking,hi) values'||chr(10)||
'         (:p765_sid,i.column_value);'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
'    update t_core_classification set hi_applies=''Y'' where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    update t_core_classification set hi_applies=''N'' where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if length(nvl(:P765_RELEASE_TO,''''';

p:=p||')) > 0 then'||chr(10)||
''||chr(10)||
'    for i in (select column_value from table(split(:P765_RELEASE_TO,'':''))'||chr(10)||
'                    where column_value is not null)'||chr(10)||
'    loop'||chr(10)||
'        insert into t_core_classification_rt (marking,rt) values'||chr(10)||
'         (:p765_sid,i.column_value);'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    update t_core_classification set rt_applies=''Y'' where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    update t_core_classification set rt_applies=''N'' ';

p:=p||'where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'else'||chr(10)||
''||chr(10)||
'  delete from t_core_classification where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
'commit;';

wwv_flow_api.create_page_process(
  p_id     => 8400918639188714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Save',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Error Saving Classification',
  p_process_when=>':REQUEST in (''SAVE'',''CREATE'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'Classification saved.',
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
'    :p765_done := ''Y'';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8717807956458298 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set DONE Flag',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''SAVE'',''CREATE'')',
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
'     if :p765_context is null or :p765_context='''' then'||chr(10)||
''||chr(10)||
'       select sid,class_level into :p765_sid, :p765_classification '||chr(10)||
'          from t_core_classification where obj=:p765_obj and (obj_context is null '||chr(10)||
'                                                           or obj_context='''');'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       select sid,class_level into :p765_sid, :p765_classification '||chr(10)||
'          from t_core_classi';

p:=p||'fication where obj=:p765_obj and obj_context=:p765_context;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'  :P767_SID := NULL;'||chr(10)||
'  :P767_CLASSIFICATION := NULL;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
''||chr(10)||
'if :P765_CLASSIFICATION is null or :P765_CLASSIFICATION='''' or :P765_CLASSIFICATION=''~~~'' then'||chr(10)||
'  '||chr(10)||
'  :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'  :P765_CLASSIFICATION_CODE:=NULL;'||chr(10)||
'  :P765_DISSEMINATE:=NULL;'||chr(10)||
'  :P765_RELEASE_TO:=NULL;'||chr(10)||
''||chr(10)||
'else'||chr(10)||
'  '||chr(10)||
'  begin'||chr(10)||
'';

p:=p||'       select RT_ALLOWED,CODE INTO :P765_RELEASE_TO_VISIBLE,:P765_CLASSIFICATION_CODE '||chr(10)||
'             from t_core_classification_level where sid=:P765_CLASSIFICATION;'||chr(10)||
''||chr(10)||
'  exception when others then'||chr(10)||
'           '||chr(10)||
'           :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'           :P765_CLASSIFICATION_CODE := ''U'';'||chr(10)||
''||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
':P765_DISS_SELECT := ''select t.description display_value, t.sid return_value '' ||'||chr(10)||
'    ';

p:=p||'                 ''        from t_core_classification_hi_type t,'' ||'||chr(10)||
'                     ''             t_core_classification_level_hi h,'' ||'||chr(10)||
'                     ''             t_core_classification_level l'' ||'||chr(10)||
'                     ''          where t.sid=h.hi '' ||'||chr(10)||
'                     ''            and l.sid=h.lvl '' ||'||chr(10)||
'                     ''            and l.code='' || '''''''' || :P765_CLASSIFICATION_CO';

p:=p||'DE || '''''''' ||'||chr(10)||
'                     ''               order by t.seq, t.description'';'||chr(10)||
''||chr(10)||
':P765_DISSEMINATION := '''';'||chr(10)||
'for d in (select * from t_core_classification_hi where marking=:P765_SID)'||chr(10)||
'loop'||chr(10)||
'    :P765_DISSEMINATION := :P765_DISSEMINATION || d.hi || '':'';'||chr(10)||
' '||chr(10)||
'end loop;'||chr(10)||
''||chr(10)||
':P765_RELEASE_TO := '''';'||chr(10)||
'for d in (select * from t_core_classification_rt where marking=:P765_SID)'||chr(10)||
'loop'||chr(10)||
'    :P765_RELEASE_TO := :P765_R';

p:=p||'ELEASE_TO || d.rt || '':'';'||chr(10)||
' '||chr(10)||
'end loop;';

wwv_flow_api.create_page_process(
  p_id     => 8401605535289065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_BOX_BODY',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Load',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CLASSIFICATION',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'select DESCRIPTION display_value, CODE return_value '||chr(10)||
'      from T_CORE_CLASSIFICATION_HI_TYPE '||chr(10)||
'          order by SEQ, DESCRIPTION');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 765
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

