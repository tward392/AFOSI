set define off;

CREATE OR REPLACE PACKAGE BODY Osi_Auth AS
/******************************************************************************
   Name:     osi_auth
   Purpose:  Provides Functionality For Authorization.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    29-Oct-2009 T.McGuffin      Created Package
    17-Dec-2009 R.Dibble        Added get_role_description, get_role_lov  
    18-Dec-2009 R.Dibble        Added get_role_complete_description,validate_role_creation
    04-Jan-2010 R.Dibble        Added get_perm_complete_description, get_perm_description, get_perm_lov
    06-Jan-2010 R.Dibble        Added user_can_grant_priv, priv_is_common_grant
    07-Jan-2010 R.Dibble        Added change_permission
    12-Jan-2010 R.Dibble        Added user_can_grant_role
    18-Jan-2010 R.Dibble        Added change_role    
    24-May-2010 T.McGuffin      Modified check_access to prevent multiple assignments causing an error.
    07-Jun-2010 T.McGuffin      Auditing failed check_for_privs.
    01-Oct-2010 R.Dibble        Added get_priv_description
    05-Oct-2010 T.Whitehead     CHG0003227 - Removed audit logging from check_for_priv.    
    20-Oct-2010 Tim Ward        Added OSI.CHECKFORPRIV_AUDIT_LOGGING to T_CORE_CONFIG to allow turning off
                                 check_for_priv failure logging (just like legacy).
                                 Changed check_for_priv.    
    20-Oct-2010 Tim Ward        CR#3223 & 3224 - Adding Logging and Notifications for check_access failures.
                                 Changed check_access.    
    01-Nov-2010 Tim Ward        Fix bug where Participants and Personnel Records couldn't be accessed.
    12-Nov-2010 J.Faris         Updated block of CheckAccess to return Y on affirmative checkforPriv while 
                                 continuing to log failures.
    09-Dec-2010 R.Dibble        Fixed small bug with check_access and ACCESS_ASS privilege
                                 Modified check_access to show pass messages on the 3 ACCESS type privilege checks
                                 Modified check_for_priv to look for explicit object actions prior to inherited object actions.
    13-Dec-2010 R.Dibble        Added p_supress_logging to check_access and check_for_priv.  Defaults to FALSE.
                                 Modified check_for_priv to do 2nd generation obj type testing when possible
    16-Dec-2010 R.Dibble        Fixed log suppression issue with Check_Access() 
    21-Dec-2010 J.Faris         Fixed issue with Check_Access to prevent any unit ownership checking when not applicable,
                                (Personnel, Participants). Also fixed bug in check_for_priv that wasn't parsing specific
                                object type code (by using a new function -"freq_instr").                            
    23-Dec-2010 J.Faris         Fixed Unit and Assigned Peronnel Only Restriction by changeing p_obj to v_personnel
                                in check_access on the IF v_obj_unit <> Osi_Personnel.get_current_unit(v_personnel) THEN                          
                                line.      
    28-Dec-2010 J.Faris         Fixed check_access to retrieve the participant SID when it is being called with a participant
                                version SID.                      
    08-Feb-2011 Tim Ward        CR#3536 - Lead Agent Name not found in check_access.
                                 Added a boolean input to check_access (p_get_message).
    04-Mar-2011 John Biggs      Changed check_for_priv to take out duplicate checking.
    04-Mar-2011 Tim Ward        Added p_explicit_action_check parameter to check_for_priv to tell it not to check parents.
                                 Changed p_supress_logging parameter from boolean := false to varchar2 := 'N' so we can call
                                  it from outside of PL/SQL.
    22-Apr-2011 Tim Ward        CR#3829 - Added v_explicit_action_check value to Check_Access.  
                                 Now check T_CORE_OBJ_TYPE.INHERIT_PRIVS_FROM_PARENT to see if 
                                 check_for_priv should check explicitly or not.
                                         
******************************************************************************/
--###################################################################################################
--#                  Check Access Algorithm - Documented by Richard N. Dibble                       #
--###################################################################################################
--#  Privilege (or Combo)     #  User Ability                                                       #
--###################################################################################################
--#           .OVR            #  This privilege is a RESTRICTION OVERRIDE.                          #
--#                           #                                                                     #
--#                           #  Ex. If a user has all other needed access to an object, but does   #
--#                           #  NOT meet the proper restriction, they can still access the         #
--#                           #  object.  So, if an object is set to "Unit" or "Unit and Assigned   # 
--#                           #  Personnel" restrictions, and they are neither, they can access     #
--#                           #  this object if all other requirements are met (.ACA or .ACC, see   # 
--#       "OVERRIDE"          #  below).                                                            #
--###################################################################################################
--#           .ACA            #  This is the ACCESS ALL PRIVILEGE.                                  #
--#                           #                                                                     #
--#                           #  WHEN NO RESTRICTION EXISTS, a user can access an object in         #
--#                           #  another unit.  So, if an object is set to "None" restriction, they # 
--#                           #  can access an object either WITHIN or OUTSIDE OF THEIR UNIT.       #
--#                           #                                                                     #
--#                           #  WHEN A RESTRICTION EXISTS, a user would be able to access an       #
--#                           #  object only if they meet the restriction, whether or not they are  #
--#                           #  in the objects unit - a user may be assigned to an object, but not # 
--#                           #  in the objects unit (this is very common as agents from unit A     #
--#                           #  will often get assigned to objects from unit B).                   #
--#                           #                                                                     #
--#                           #  - If the restriction is "Unit and Assigned Personnel", they would  #
--#                           #  be able to open the object when either in the objects unit, or if  #
--#                           #  they are assigned to the object.                                   #
--#                           #                                                                     #
--#                           #  - If the restriction is "Unit", they would be able to open the     #
--#                           #  object when they are in the objects unit even if they are not      #
--#          "ACCESS"         #  assigned.                                                          #
--###################################################################################################
--#           .ACC            #  This is the ACCESS PRIVILEGE.                                      #
--#                           #                                                                     #
--#                           #  WHEN NO RESTRICTION EXISTS, a user can access an object in their   # 
--#                           #  unit.  This privilege deals with the notation "Within the          #
--#                           #  specified chain of command".  This means that if this privilege    #
--#                           #  is granted to the user for "All OSI Units" or "Unit and            #
--#                           #  Subordinate Units", the user will in fact be able to access an     #
--#                           #  object that is in either THEIR or in a SUBORDINATE UNIT.           #
--#                           #  **See details for this below.                                      #
--#                           #                                                                     #
--#                           #  WHEN A RESTRICTION EXISTS, the user would be able to access an     #
--#                           #  object as stated in the .ACA section - "When a restriction         #
--#        "ACCESS_UNT"       #  exists" above.                                                     #
--###################################################################################################
--#           .OVR            #  WHEN A RESTRICTION EXISTS, this combination will allow a user to   #
--#            and            #  access any object in THEIR UNIT, REGARDLESS of RESTRICTION.  Most  # 
--#           .ACC            #  likely used for Unit Leadership.                                   #
--###################################################################################################
--#           .OVR            #  WHEN A RESTRICTION EXISTS, this combination will a user to access  #
--#            and            #  any object REGARDLESS of RESTRICTION or UNIT AFFILIATION.  Most    #
--#           .ACA            #  likely used for Administrative or HQ leadership.                   #
--###################################################################################################
--# FURTHER NOTES:                                                                                  #
--# **This functionality algorithm is slightly different from Legacy to Web:                        #
--#                                                                                                 #
--#  LEGACY: The CheckForPriv() function would start at the objects unit, and travel upwards        #
--#          through the chain of command (looking at each subsequent units parent) until it found  #
--#          a match for the given privilege for the given personnel.                               #
--#                                                                                                 #
--#  WEB: In the web version, there is a single cursor loop (actually 3 for different checks) in    #
--#       the CheckForPriv() that utilizes the osi_unit.is_subordinate(objects_unit, users_unit)    #
--#       function to determine if the user has the privilege.                                      #
--#                                                                                                 #
--#  BOTH: Privs are checked by looking in the users roles, then their personnel privs, then the    #
--#        proxy table.                                                                             #
--###################################################################################################

    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_AUTH';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    FUNCTION check_for_priv(
        p_action                IN   VARCHAR2,
        p_obj_type              IN   VARCHAR2,
        p_personnel             IN   VARCHAR2 := NULL,
        p_unit                  IN   VARCHAR2 := NULL,
        p_supress_logging       in   VARCHAR2 := 'N',
        p_explicit_action_check in   VARCHAR2 := 'N')
        RETURN VARCHAR2 IS
        v_unit        T_OSI_UNIT.SID%TYPE;
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
        v_logfails    VARCHAR2(1);
        v_action      varchar2(100);
        v_obj_type varchar2(100);
        v_temp varchar2(20);
        

    BEGIN
        IF p_action IS NULL THEN
            RETURN 'N';
        END IF;

        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);
        v_unit := NVL(p_unit, Osi_Personnel.get_current_unit(v_personnel));
        --Set original action
        v_action := p_action;
                
        --If not: Continue on with the priv checking utilizing inheritance 
        FOR i IN (SELECT 1
                    FROM T_OSI_PERSONNEL_UNIT_ROLE ur, 
                          T_OSI_AUTH_ROLE_PRIV rp,
                          T_OSI_AUTH_PRIV p,
                          T_OSI_AUTH_ACTION_TYPE AT
                   WHERE ur.personnel = v_personnel
                     AND (   ur.unit IS NULL
                          OR (ur.unit = v_unit)
                          OR (    ur.include_subords = 'Y'
                              AND Osi_Unit.is_subordinate(ur.unit, v_unit) = 'Y'))
                     AND ur.assign_role = rp.ROLE
                     AND rp.priv = p.SID
                     AND AT.SID = p.action
                     AND AT.code = p_action
                     AND ((p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type) and p_explicit_action_check='N')
                     or (p.obj_type = p_obj_type and p_explicit_action_check='Y'))
                     AND ur.enabled = 'Y'
                     AND rp.enabled = 'Y'
                     AND SYSDATE BETWEEN NVL(ur.start_date, SYSDATE - 1)
                                     AND NVL(ur.end_date, SYSDATE + 1))
        LOOP
            LOG_ERROR('1-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
            RETURN 'Y';
        END LOOP;

        FOR i IN (SELECT 1
                    FROM T_OSI_PERSONNEL_PRIV pp,
                         T_OSI_AUTH_PRIV p,
                         T_OSI_AUTH_ACTION_TYPE AT
                   WHERE pp.personnel = v_personnel
                     AND pp.priv = p.SID
                     AND AT.SID = p.action
                     AND AT.code = p_action
                     AND ((p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type) and p_explicit_action_check='N')
                     or (p.obj_type = p_obj_type and p_explicit_action_check='Y'))
                     AND (   pp.unit IS NULL
                          OR pp.unit = v_unit
                          OR (pp.include_subords = 'Y' AND Osi_Unit.is_subordinate(pp.unit, v_unit) = 'Y'))
                     AND pp.enabled = 'Y'
                     AND SYSDATE BETWEEN NVL(pp.start_date, SYSDATE - 1) AND NVL(pp.end_date, SYSDATE + 1))
        LOOP
            LOG_ERROR('2-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
            RETURN 'Y';
        END LOOP;

        FOR i IN (SELECT 1
                    FROM T_OSI_PERSONNEL_PRIV_PROXY ppp,
                         T_OSI_AUTH_PRIV p,
                         T_OSI_AUTH_ACTION_TYPE AT
                   WHERE ppp.grantee = v_personnel
                     AND p.SID = ppp.priv
                     AND AT.SID = p.action
                     AND AT.code = p_action
                     --AND p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type)
                     AND ((p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type) and p_explicit_action_check='N')
                     or (p.obj_type = p_obj_type and p_explicit_action_check='Y'))
                     AND unit = v_unit
                     AND SYSDATE BETWEEN NVL(start_date, SYSDATE - 1) AND NVL(end_date, SYSDATE + 1))
        LOOP
            LOG_ERROR('3-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
            RETURN 'Y';
        END LOOP;
        
        v_logfails := Core_Util.GET_CONFIG('OSI.CHECKFORPRIV_AUDIT_LOGGING');
  
        IF v_logfails = 'Y' OR v_logfails IS NULL OR v_logfails='' THEN
          
          if (p_supress_logging = 'N') then

            Log_Info('Failed:' || p_obj_type || '-' || p_action);

          end if;

        END IF;
  
        LOG_ERROR('NNNNNNNOOOOOOOOO-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
        RETURN 'N';
    END check_for_priv;

    PROCEDURE LogCheckAccessReturn(p_obj IN VARCHAR2, myRtn IN VARCHAR2, myMsg IN VARCHAR2, FailMsg IN VARCHAR2) IS
    
    v_CompleteMsg VARCHAR2(1000);
    v_event_sid   VARCHAR2(30);
    v_Log_Rtn     VARCHAR2(5);
    
 BEGIN
      IF myRTN = 'N' THEN
     
     v_Log_Rtn := 'False';

         ELSE
   
     v_Log_Rtn := 'True';
     
   END IF;

      v_CompleteMsg := 'CheckAccess:' || p_obj || ' - ' ||  v_Log_Rtn || ' - ';
   
   IF (FailMsg = '' OR FailMsg IS NULL) AND myRTN='N' THEN
     
        v_CompleteMsg := v_CompleteMsg || myMsg;
   
   ELSE
    
        v_CompleteMsg := v_CompleteMsg || FailMsg; 
     
   END IF;
   
         Log_Info(v_CompleteMsg);
   
   IF myRTN = 'N' THEN
           
     BEGIN
                SELECT SID INTO v_event_sid FROM T_OSI_NOTIFICATION_EVENT_TYPE t WHERE t.CODE='ACCESS.FAILED';

                INSERT INTO T_OSI_NOTIFICATION_EVENT (SID,EVENT_CODE,PARENT,PARENT_INFO,EVENT_BY,EVENT_ON,IMPACTED_UNIT,SPECIFICS,GENERATED) VALUES (NULL,v_event_sid,p_obj, Core_Obj.GET_TAGLINE(p_obj),Core_Context.personnel_name,SYSDATE,NULL,Core_Context.personnel_sid,'N');
                COMMIT;

     EXCEPTION WHEN OTHERS THEN
              
     NULL;
         
     END;       
     
   END IF;
   
 END LogCheckAccessReturn;
     
    FUNCTION Check_Access(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL,
        p_supress_logging   in   boolean := false, p_get_message in boolean := false) RETURN VARCHAR2 IS

        v_personnel              T_CORE_PERSONNEL.SID%TYPE;
        v_assigned               VARCHAR2(1)                 := 'N';
        v_obj                    T_OSI_PARTICIPANT.SID%TYPE;
        v_obj_type               T_CORE_OBJ_TYPE.SID%TYPE;
        v_obj_code               T_CORE_OBJ_TYPE.CODE%TYPE;
        v_obj_unit               T_OSI_UNIT.SID%TYPE;
        v_obj_restriction        T_OSI_REFERENCE.code%TYPE;
        v_lead_agent             T_CORE_PERSONNEL.SID%TYPE;
        myMsg                    VARCHAR2(4000);
        FailMsg                  VARCHAR2(4000);
        myRtn                    VARCHAR2(1) := 'Y';
        v_explicit_action_check  VARCHAR2(1) := 'N';
  
    BEGIN
         myMsg := 'You do not have permission to perform this function.';

         v_personnel := NVL(p_personnel, Core_Context.personnel_sid);
         
         BEGIN
              SELECT 'Y' INTO v_assigned
           FROM T_OSI_ASSIGNMENT
                        WHERE obj = p_obj
                          AND personnel = v_personnel
                          AND SYSDATE BETWEEN NVL(start_date, TO_DATE('01011901', 'mmddyyyy'))
                                          AND NVL(end_date, TO_DATE('12312999', 'mmddyyyy'))
                          AND ROWNUM=1;
         EXCEPTION
                  WHEN NO_DATA_FOUND THEN
         
                v_assigned := 'N';
         END;

         /* Check to see if a participant_version sid is being passed in
            (common for report links) if so, initialize v_obj with participant sid */
         if Core_Obj.get_objtype(p_obj) is not null then
              v_obj := p_obj;
         else
             BEGIN
                  SELECT PARTICIPANT
                    INTO v_obj
                    FROM T_OSI_PARTICIPANT_VERSION
                   WHERE SID = p_obj;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      v_obj := p_obj;
             END;
         end if;
         
         v_obj_unit := Osi_Object.get_assigned_unit(p_obj);
         v_obj_type := Core_Obj.get_objtype(v_obj);
         v_obj_code := osi_object.get_objtype_code(v_obj_type);
         v_explicit_action_check := core_obj.get_inherit_privs_flag(v_obj_type);
         
         IF NOT(check_for_priv('OVERRIDE', v_obj_type, v_personnel, v_obj_unit, 'Y', v_explicit_action_check) = 'Y' OR v_assigned = 'Y') THEN
           
           BEGIN
                SELECT r.code INTO v_obj_restriction
                      FROM (SELECT restriction FROM T_OSI_FILE WHERE SID = p_obj
                        UNION
                        SELECT restriction FROM T_OSI_ACTIVITY WHERE SID = p_obj) x, T_OSI_REFERENCE r
                              WHERE r.SID = x.restriction;
           EXCEPTION
                    WHEN NO_DATA_FOUND THEN
   
                     v_obj_restriction := 'NONE';
           END;

           v_lead_agent := osi_object.get_lead_agent(p_obj);
           IF v_obj_restriction = 'PERSONNEL' THEN
             
             if v_lead_agent = v_personnel then

               myMsg := REPLACE('This Object has been Restricted to ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR>Your Assignment in this object has been ended.', '  ', ' ');

             else

               myMsg := REPLACE('This Object has been Restricted to ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR>Please contact the Lead Agent ' || osi_personnel.get_name(v_lead_agent) || ' so they can give you access to this object.', '  ', ' ');

             end if;
             
             FailMsg := 'RESTRICTED TO ASSIGNED PERSONNEL ONLY';
             myRtn := 'N';
        
           ELSIF v_obj_restriction = 'UNIT' THEN
        
                IF v_obj_unit <> Osi_Personnel.get_current_unit(v_personnel) THEN
  
                  if v_lead_agent = v_personnel then

                    myMsg := REPLACE('This Object has been Restricted to UNIT AND ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR><BR>Your Assignment in this object has been ended.', '  ', ' ');

                  else

                    myMsg := REPLACE('This Object has been Restricted to UNIT AND ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR><BR>Please contact the Lead Agent ' || osi_personnel.get_name(v_lead_agent) || ' so they can give you access to this object.', '  ', ' ');

                  end if;

                  FailMsg := 'RESTRICTED TO UNIT';
                  myRtn := 'N';
        
                END IF;
        
           END IF;
        
         END IF;

         IF myRtn = 'Y' THEN

           --- Check Access without Unit ---
           IF check_for_priv('ACCESS', v_obj_type, v_personnel, null, 'Y', v_explicit_action_check) = 'N' THEN       

             FailMsg := 'check_for_priv(ACCESS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';
             myRtn := 'N';

           ELSE

             FailMsg := 'check_for_priv(ACCESS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';--NULL;
             myRtn := 'Y';

           END IF;

           if v_obj_unit != '<none>' then --Only do the following checks if Unit Ownership is applicable

             --- Check access with Unit ---
             IF myRtn = 'N' and check_for_priv('ACCESS_UNT', v_obj_type, v_personnel, v_obj_unit, 'Y', v_explicit_action_check) = 'N' THEN

               FailMsg := 'check_for_priv(ACCESS_UNT,' || v_obj_type || ',' || v_personnel || ',' || v_obj_unit || ',Y,' || v_explicit_action_check || ')';
               myRtn := 'N';

             ELSE

               FailMsg := 'check_for_priv(ACCESS_UNT,' || v_obj_type || ',' || v_personnel || ',' || v_obj_unit  || ',Y,' || v_explicit_action_check || ')';--NULL;
               myRtn := 'Y';

             END IF;
               
             --- Check access for objects assigned to ---
             if (myrtn = 'N') then

               if (v_assigned = 'Y' and check_for_priv('ACCESS_ASS', v_obj_type, v_personnel, null, 'Y', v_explicit_action_check) = 'Y') then

                 FailMsg := 'check_for_priv(ACCESS_ASS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';--NULL;
                 myRtn := 'Y';

               else
 
                 FailMsg := 'check_for_priv(ACCESS_ASS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';
                 myRtn := 'N';

               end if;
 
             end if;
 
           end if;

        END IF;
         
        --- Always allow them in their own Personnel Record ---
        IF p_obj = v_personnel THEN
                  
          FailMsg := NULL;
          myRtn := 'Y';
                
        END IF;

        --- Log Success or Failure of Access to Object ---
        if (p_supress_logging = false) then
 
          LogCheckAccessReturn(p_obj, myRtn, myMsg, FailMsg);
 
        end if;
        
        if p_get_message = false then

          RETURN myRtn;
        
        else
          
          RETURN myMSG;
          
        end if;
        
    END Check_Access;
 
/* Given a Role SID, I will return you the Description */
    FUNCTION get_role_description(p_role_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(200);
    BEGIN
        SELECT description
          INTO v_return
          FROM T_OSI_AUTH_ROLE
         WHERE SID = p_role_sid;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_role_description: ' || SQLERRM);
            RAISE;
    END get_role_description;
    
    /* Given a Role SID, I will return you the Complete Description */
    FUNCTION get_role_complete_description(p_role_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(200);
    BEGIN
        SELECT complete_desc
          INTO v_return
          FROM T_OSI_AUTH_ROLE
         WHERE SID = p_role_sid;

        RETURN v_return;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('osi_auth.get_role_complete_description: ' || SQLERRM);
            RAISE;
    END get_role_complete_description;
        
    FUNCTION get_role_lov(p_current_role IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn    VARCHAR2(32000);
        v_temp   VARCHAR2(1000);
    BEGIN
        FOR a IN (SELECT   description, SID
                      FROM T_OSI_AUTH_ROLE
                 
                  ORDER BY description)
        LOOP
            v_rtn := v_rtn || REPLACE(a.description, ', ', ' / ') || ';' || a.SID || ',';
        END LOOP;

        v_rtn := RTRIM(v_rtn, ',');
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_role_lov: ' || SQLERRM);
            RAISE;
    END get_role_lov;
        
    /* Given a Permission SID, I will return you the Complete Description */
    FUNCTION get_perm_complete_description(p_perm IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_obj VARCHAR2(20);
        v_action VARCHAR2(2000);
        v_return   VARCHAR2(1000);
    BEGIN
        SELECT obj_type, action INTO v_obj, v_action
        FROM T_OSI_AUTH_PRIV
        WHERE SID = p_perm;
        
        SELECT description INTO v_action FROM T_OSI_AUTH_ACTION_TYPE WHERE
        SID = v_action;
        
        v_return := Osi_Object.GET_OBJTYPE_DESC(v_obj) || ': ' || v_action;
        

        RETURN v_return;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('osi_auth.get_perm_complete_description: ' || SQLERRM);
            RAISE;
    END get_perm_complete_description;

    /* Given a Permission SID, I will return you the Basic Description */
    FUNCTION get_perm_description(p_perm IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(400);
    BEGIN
        SELECT cot.code || '.' || oaat.code || ': ' || oap.description
          INTO v_return
          FROM T_OSI_AUTH_ACTION_TYPE oaat, T_OSI_AUTH_PRIV oap, T_CORE_OBJ_TYPE cot
         WHERE oaat.SID = oap.action AND oap.obj_type = cot.SID AND oap.SID = p_perm;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_perm_description: ' || SQLERRM);
            RAISE;
    END get_perm_description;
        
        
        
    /* Returns an LOV of currently usable permissions */
    FUNCTION get_perm_lov
        RETURN VARCHAR2 IS
                v_rtn    VARCHAR2(32000);
        v_temp   VARCHAR2(1000);
    BEGIN
        FOR k IN (SELECT    
                     SID
                      FROM v_osi_auth_priv
                 
                  ORDER BY obj_type, action_type)
        LOOP
            v_rtn := v_rtn || REPLACE(get_perm_description(k.SID), ', ', ' / ') || ';' || k.SID || ',';
        END LOOP;

        v_rtn := RTRIM(v_rtn, ',');
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_perm_lov: ' || SQLERRM);
            RAISE;
    END get_perm_lov;
        
            
   /* Used to validate a role creation */
    FUNCTION validate_role_creation(
        p_assign_role   IN   VARCHAR2,
        p_unit          IN   VARCHAR2,
        p_personnel     IN   VARCHAR2)
        RETURN VARCHAR2 IS
        v_max_hq           NUMBER       := 0;
        v_max_rgn          NUMBER       := 0;
        v_max_sqd          NUMBER       := 0;
        v_max_unit         NUMBER       := 0;
        v_allow_top        VARCHAR2(1);
        v_agent_only       VARCHAR2(1);
        v_role_count       NUMBER       := 0;
        v_unit_type_code   VARCHAR2(20);
        not_an_agent       EXCEPTION;
        role_unit          EXCEPTION;
        role_unit_type     EXCEPTION;
        hq_role_max        EXCEPTION;
        rgn_role_exists    EXCEPTION;
        unit_role_exists   EXCEPTION;
        sqd_role_exists    EXCEPTION;
    BEGIN
        SELECT max_per_hq, max_per_rgn, max_per_sqd, max_per_unit, allow_top, agent_only
          INTO v_max_hq, v_max_rgn, v_max_sqd, v_max_unit, v_allow_top, v_agent_only
          FROM T_OSI_AUTH_ROLE
         WHERE SID = p_assign_role;

        v_unit_type_code := Osi_Reference.lookup_ref_code(Osi_Unit.get_unit_type(p_unit));

        -- Check to make sure the person is an agent for roles which require it.
        SELECT COUNT(*)
          INTO v_role_count
          FROM T_OSI_PERSONNEL
         WHERE SID = p_personnel AND badge_num IS NULL;

        --Note, due to a non-standard table (T_OSI_AUTH_ROLE), we are checking for 0 and N (checking for N in case the table gets fixed eventually) - RND:I did not create this table
        IF (v_role_count > 0 AND v_agent_only NOT IN ('N','0')) THEN
            RAISE not_an_agent;
        END IF;

        v_role_count := 0;

        -- Check if the role is allowed to be assigned at the top.
        --Note, due to a non-standard table (T_OSI_AUTH_ROLE), we are checking for 0 and N (checking for N in case the table gets fixed eventually) - RND:I did not create this table
        IF (p_unit IS NULL AND v_allow_top NOT IN ('N','0')) THEN
            RAISE role_unit;
        END IF;

        -- Count the number of times this role is used in this unit
        SELECT COUNT(*)
          INTO v_role_count
          FROM T_OSI_PERSONNEL_UNIT_ROLE
         WHERE assign_role = p_assign_role AND unit = p_unit
               AND(   end_date IS NULL
                   OR end_date > SYSDATE);

        -- Check if the role usage exceeds the maximum allowed
        IF (v_unit_type_code = 'HQ' AND v_role_count >= v_max_hq)  THEN
            IF v_max_hq = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE hq_role_max;
        END IF;

        IF (v_unit_type_code = 'REGN' AND v_role_count >= v_max_rgn) THEN
            IF v_max_rgn = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE rgn_role_exists;
        END IF;

        IF (v_unit_type_code = 'FIS' AND v_role_count >= v_max_sqd) THEN
            IF v_max_sqd = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE sqd_role_exists;
        END IF;

        IF ((   v_unit_type_code = 'DET'
            OR v_unit_type_code = 'OL') AND v_role_count >= v_max_unit) THEN
            IF v_max_unit = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE unit_role_exists;
        END IF;
        
    --T_UNIT_ASSIGNMENT = Assigning Roles to Personnel (T_OSI_PERSONNEL_UNIT_ROLE) Note: This table is improperly named in WebI2MS.. Should be T_OSI_PERSONNEL_ROLE
    --T_ASSIGNMETN_HISTORY = Assigning Personnel to Units (T_OSI_PERSONNEL_UNIT_ASSIGN)
   RETURN NULL;
       EXCEPTION
        WHEN not_an_agent THEN
            RETURN 'The Role "' || get_role_description(p_assign_role)
                   || '" can only be assigned to badged agents.';
        WHEN role_unit THEN
            RETURN 'The unit can not be "All OSI" for the "' || get_role_description(p_assign_role)
                   || '" role.';
        WHEN role_unit_type THEN
            RETURN 'The Role, "' || get_role_description(p_assign_role)
                   || '", is not allowed for this unit type.';
        WHEN hq_role_max THEN
            RETURN 'Only ' || v_max_hq || ' active "' || get_role_description(p_assign_role)
                   || '" allowed in this HQ unit.';
        WHEN rgn_role_exists THEN
            RETURN 'Only ' || v_max_rgn || ' active "' || get_role_description(p_assign_role)
                   || '" per region is allowed.';
        WHEN sqd_role_exists THEN
            RETURN 'Only ' || v_max_sqd || ' active "' || get_role_description(p_assign_role)
                   || '" per squadron is allowed.';
        WHEN unit_role_exists THEN
            RETURN 'Only ' || v_max_unit || ' active "' || get_role_description(p_assign_role)
                   || '" per unit is allowed.';
        WHEN OTHERS THEN
            log_error('osi_auth.validate_role_creation: ' || SQLERRM);
            RETURN SQLERRM;
    END validate_role_creation;
    
    
    
    FUNCTION priv_is_common_grant(p_priv IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_cnt   NUMBER;
    BEGIN
        FOR k IN (SELECT priv
                    FROM v_osi_auth_role_priv
                   WHERE priv = p_priv AND common_grant = 'Y')
        LOOP
            RETURN 'Y';
        END LOOP;

        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.priv_is_common_grant: ' || SQLERRM);
            RETURN SQLERRM;
    END priv_is_common_grant;
    
    /* Returns 'Y' if the currently logged on user can grant a specific privilege */
    FUNCTION user_can_grant_priv(
        p_unit        IN   VARCHAR2,
        p_incsubs     IN   VARCHAR2,
        p_priv        IN   VARCHAR2,
        p_personnel   IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel   T_OSI_PERSONNEL.SID%TYPE;
        v_cnt         NUMBER;
        v_unit        VARCHAR2(20);
    BEGIN
        --First, need to check if its a common grant.. This trumps the 'Grantable' flag
        --That is of course provided the user has common grant privilege
        IF (    priv_is_common_grant(p_priv) = 'Y'
            AND Osi_Auth.check_for_priv('PMM_COMMON', Core_Obj.lookup_objtype('PERSONNEL')) = 'Y') THEN
            --This IS a common grantable priv, and the user HAS the privilege to use common grants
            RETURN 'Y';
        END IF;

        --Determine what personnel we have
        IF (p_personnel IS NULL) THEN
            v_personnel := Core_Context.personnel_sid;
        ELSE
            v_personnel := p_personnel;
        END IF;

        --CHECK FOR PERMISSION WITHIN A CURRENTLY ASSIGNED ROLE
        --Start with Unit we were passed
        v_unit := p_unit;

        LOOP
            --Checking Roles
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_PERSONNEL_UNIT_ROLE opur, T_OSI_AUTH_ROLE_PRIV oarp
             WHERE NVL(NVL(opur.unit, v_unit), 'x') = NVL(v_unit, 'x')
               AND opur.personnel = v_personnel
               AND SYSDATE BETWEEN NVL(opur.start_date, SYSDATE - 1) AND NVL(opur.end_date, SYSDATE + 1)
               AND (   v_unit = p_unit
                    OR opur.include_subords = 'Y'
                    OR opur.unit IS NULL)
               AND (   UPPER(NVL(p_incsubs, 'N')) <> 'Y'
                    OR opur.include_subords = 'Y'
                    OR opur.unit IS NULL)
               AND oarp.ROLE = opur.assign_role
               AND oarp.priv = p_priv
               AND oarp.grantable = 'Y';

            IF (v_cnt > 0) THEN
                --We found the grantable privilege within a role so return ok.
                RETURN 'Y';
            END IF;

            -- Look for the privilege in parent units
            IF (v_unit IS NOT NULL) THEN
                SELECT unit_parent
                  INTO v_unit
                  FROM T_OSI_UNIT
                 WHERE SID = v_unit;
            ELSE
                v_unit := NULL;
            END IF;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        --CHECK FOR EXPLICIT PRIVILEGE GRANTS
        --Start with Unit we were passed
        v_unit := p_unit;

        LOOP
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_PERSONNEL_PRIV
             WHERE NVL(NVL(unit, v_unit), 'x') = NVL(v_unit, 'x')
               AND priv = p_priv
               AND personnel = v_personnel
               AND SYSDATE BETWEEN NVL(start_date, SYSDATE - 1) AND NVL(end_date, SYSDATE + 1)
               AND grantable = 'Y'
               AND (   v_unit = p_unit
                    OR include_subords = 'Y'
                    OR unit IS NULL)
               AND (   UPPER(NVL(p_incsubs, 'N')) <> 'Y'
                    OR include_subords = 'Y'
                    OR unit IS NULL);

            IF (v_cnt > 0) THEN
                --We found the grantable privilege so return ok.
                RETURN 'Y';
            END IF;

            -- Look for the privilege in parent units
            IF (v_unit IS NOT NULL) THEN
                SELECT unit_parent
                  INTO v_unit
                  FROM T_OSI_UNIT
                 WHERE SID = v_unit;
            ELSE
                v_unit := NULL;
            END IF;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.user_can_grant_priv: ' || SQLERRM);
            RETURN SQLERRM;
    END user_can_grant_priv;
    
    /* Returns 'Y' if the currently logged on user can grant a specific role */
    FUNCTION user_can_grant_role(
        p_unit        IN   VARCHAR2,
        p_incsubs     IN   VARCHAR2,
        p_role        IN   VARCHAR2,
        p_personnel   IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel    T_OSI_PERSONNEL.SID%TYPE;
        v_cnt          NUMBER;
        v_unit         VARCHAR2(20);
        v_grant_priv   T_OSI_AUTH_ROLE.grant_priv%TYPE;
    BEGIN

    --t_unit_role = t_osi_auth_role
    --t_unit_assignment = t_osi_personnel_unit_role

        --Get the privilege needed to grant this role
        FOR k IN (SELECT oap.action_type
                    FROM T_OSI_AUTH_ROLE oar, v_osi_auth_priv oap
                   WHERE oar.SID = p_role AND oar.grant_priv = oap.SID)
        LOOP
            v_grant_priv := k.action_type;
            EXIT;
        END LOOP;

        --Now that we know the basic permission to grant this role, lets see if the user has it.
        IF (Osi_Auth.check_for_priv(v_grant_priv, Core_Obj.lookup_objtype('PERSONNEL')) = 'Y') THEN
            --If so, return OK.
            RETURN 'Y';
        END IF;

        --Set the unit to the original unit
        v_unit := p_unit;
        
       --Determine what personnel we have
        IF (p_personnel IS NULL) THEN
            v_personnel := Core_Context.personnel_sid;
        ELSE
            v_personnel := p_personnel;
        END IF;
        
        LOOP
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_PERSONNEL_UNIT_ROLE
             WHERE assign_role = p_role
               AND personnel = v_personnel
               AND NVL(NVL(unit, v_unit), 'x') = NVL(v_unit, 'x')
               AND SYSDATE BETWEEN NVL(start_date, SYSDATE - 1) AND NVL(end_date, SYSDATE + 1)
               AND grantable = 'Y'
               AND (   v_unit = p_unit
                    OR include_subords = 'Y'
                    OR unit IS NULL)
               AND (   UPPER(NVL(p_incsubs, 'N')) <> 'Y'
                    OR include_subords = 'Y'
                    OR unit IS NULL);

            IF (v_cnt > 0) THEN
                --We found a grantable role, so exit
                RETURN 'Y';
            END IF;

            -- Look for the role in parent units
            IF (v_unit IS NOT NULL) THEN
                SELECT unit_parent
                  INTO v_unit
                  FROM T_OSI_UNIT
                 WHERE SID = v_unit;
            ELSE
                v_unit := NULL;
            END IF;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.user_can_grant_role: ' || SQLERRM);
            RETURN SQLERRM;
    END user_can_grant_role;
    
    
    /* Used when a user "Edit's" a permission */
    /* Note: This function actually ends the current permission, then creates another with the new specs. */
   FUNCTION change_permission(
        p_current_perm_sid   IN   VARCHAR2,
        p_perm               IN   VARCHAR2,
        p_unit               IN   VARCHAR2,
        p_start_date         IN   DATE,
        p_end_date           IN   DATE,
        p_enabled            IN   VARCHAR2,
        p_grantable          IN   VARCHAR2,
        p_include_subords    IN   VARCHAR2,
        p_allow_or_deny IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_personnel   T_OSI_PERSONNEL_PRIV.personnel%TYPE;
        v_sid         T_OSI_PERSONNEL_PRIV.SID%TYPE;
    BEGIN
        --Set the sid to the current perm.  
        --If the perm has not changed then this will be returned
        v_sid := p_current_perm_sid;

        --Get the personnel we are dealing with (saves us one input parameter)
        SELECT personnel
          INTO v_personnel
          FROM T_OSI_PERSONNEL_PRIV
         WHERE SID = p_current_perm_sid;

        --First see if there is a difference
        BEGIN
            SELECT SID
              INTO v_sid
              FROM T_OSI_PERSONNEL_PRIV
             WHERE SID = p_current_perm_sid
               AND personnel = v_personnel
               AND priv = p_perm
               AND unit = p_unit
               AND TO_CHAR(start_date,'DD/MM/YYYY') = TO_CHAR(p_start_date,'DD/MM/YYYY')
               
               AND (TO_CHAR(end_date,'DD/MM/YYYY') = TO_CHAR(p_end_date,'DD/MM/YYYY')
                    OR
                    (end_date IS NULL AND p_end_date IS NULL))
               
               AND grantable = p_grantable
               AND enabled = p_enabled
               AND include_subords = p_include_subords
               AND allow_or_deny = p_allow_or_deny;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Perm has changed - SO -
                --Update current perm with END date of now
                UPDATE T_OSI_PERSONNEL_PRIV
                   SET end_date = SYSDATE
                 WHERE SID = p_current_perm_sid;

                --Create a new perm with new specs
                INSERT INTO T_OSI_PERSONNEL_PRIV
                            (personnel,
                             priv,
                             unit,
                             start_date,
                             end_date,
                             grantable,
                             enabled,
                             include_subords,
                             allow_or_deny)
                     VALUES (v_personnel,
                             p_perm,
                             p_unit,
                             p_start_date,
                             p_end_date,
                             p_grantable,
                             p_enabled,
                             p_include_subords,
                             p_allow_or_deny)
                  RETURNING SID
                       INTO v_sid;
        END;

        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.change_permission: ' || SQLERRM);
            RETURN SQLERRM;
    END change_permission;
    
    /* Used when a user "Edit's" a role */
    /* Returns the SID of the new role for SEL_ROLE purposes */
    /* Note: This function actually ends the current role, then creates another with the new specs. */  
    
    FUNCTION change_role(
        p_current_role_sid   IN   VARCHAR2,
        p_role               IN   VARCHAR2,
        p_unit               IN   VARCHAR2,
        p_start_date         IN   DATE,
        p_end_date           IN   DATE,
        p_enabled            IN   VARCHAR2,
        p_grantable          IN   VARCHAR2,
        p_include_subords    IN   VARCHAR2)
        RETURN VARCHAR2 IS
        v_personnel   T_OSI_PERSONNEL_UNIT_ROLE.personnel%TYPE;
        v_sid         T_OSI_PERSONNEL_UNIT_ROLE.SID%TYPE;
    BEGIN
        --Set the sid to the current perm.  
        --If the perm has not changed then this will be returned
        v_sid := p_current_role_sid;

        --Get the personnel we are dealing with (saves us one input parameter)
        SELECT personnel
          INTO v_personnel
          FROM T_OSI_PERSONNEL_UNIT_ROLE
         WHERE SID = p_current_role_sid;

        --First see if there is a difference
        BEGIN
            SELECT SID
              INTO v_sid
              FROM T_OSI_PERSONNEL_UNIT_ROLE
             WHERE SID = p_current_role_sid
               AND personnel = v_personnel
               AND assign_role = p_role
               AND unit = p_unit
               AND TO_CHAR(start_date,'DD/MM/YYYY') = TO_CHAR(p_start_date,'DD/MM/YYYY')
               
               AND (TO_CHAR(end_date,'DD/MM/YYYY') = TO_CHAR(p_end_date,'DD/MM/YYYY')
                    OR
                    (end_date IS NULL AND p_end_date IS NULL))
               
               AND grantable = p_grantable
               AND enabled = p_enabled
               AND include_subords = p_include_subords;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Perm has changed - SO -
                --Update current perm with END date of now
                UPDATE T_OSI_PERSONNEL_UNIT_ROLE
                   SET end_date = SYSDATE
                 WHERE SID = p_current_role_sid;

                --Create a new perm with new specs
                INSERT INTO T_OSI_PERSONNEL_UNIT_ROLE
                            (personnel,
                             assign_role,
                             unit,
                             start_date,
                             end_date,
                             grantable,
                             enabled,
                             include_subords)
                     VALUES (v_personnel,
                             p_role,
                             p_unit,
                             p_start_date,
                             p_end_date,
                             p_grantable,
                             p_enabled,
                             p_include_subords)
                  RETURNING SID
                       INTO v_sid;
        END;

        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.change_role: ' || SQLERRM);
            RETURN SQLERRM;
    END change_role;
    
    /* Used to egt the free text representation of a permission */
    FUNCTION get_priv_description(p_priv IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR k IN (SELECT ot.code AS ot_code, AT.code AS at_code, ot.description AS ot_desc,
                         AT.description AS at_desc
                    FROM T_OSI_AUTH_ACTION_TYPE AT, T_CORE_OBJ_TYPE ot, T_OSI_AUTH_PRIV p
                   WHERE AT.SID = p.action AND ot.SID = p.obj_type AND p.SID = p_priv)
        LOOP
            IF (k.ot_desc LIKE 'Dummy%') THEN
                RETURN k.at_code || ': ' || k.at_desc;
            ELSE
                RETURN k.ot_code || '.' || k.at_code || ': ' || k.ot_desc || '-' || k.at_desc;
            END IF;
        END LOOP;

        RETURN ' ';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_priv_description: ' || SQLERRM);
            RETURN SQLERRM;
    END get_priv_description;
        
   
   
END Osi_Auth;
/