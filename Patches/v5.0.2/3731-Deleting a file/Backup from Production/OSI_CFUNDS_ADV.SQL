-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE           "OSI_CFUNDS_ADV" as
/******************************************************************************
   NAME:       OSI_CFUNDS_ADV
   PURPOSE:    Used to handle CFunds Advance objects

   REVISIONS:
   Date        Author           Description
   ----------  ---------------  ------------------------------------
   10/7/2009   Richard Dibble   Created this package.
   11/9/2009   Jason Faris      Added can_delete.
   02/10/2010  Tim McGuffin     Added check_writability.
   03/25/2010  Tim McGuffin     Added get_claimant.
*****************************************************************************/

    /* Given an object sid as p_obj, returns a default activity tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Will take all necessary steps to create a new instance of this type of object */
    function create_instance(
        p_obj_type           in   varchar2,
        p_claimant           in   varchar2,
        p_requested_amount   in   varchar2,
        p_requested_unit     in   varchar2,
        p_voucher_no         in   varchar2,
        p_narrative          in   varchar2,
        p_date_of_request    in   date)
        return varchar2;

    /*  Given a file sid as p_obj, can_delete will return a custom error message if the object
        is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2)
        return varchar2;

    /* checks whether a given cfunds advance object should be writable or not */
    function check_writability(p_obj in varchar2, p_context in varchar2)
        return varchar2;

    /* returns the sid of the personnel for the claimant responsible for a cfunds advance */
    function get_claimant(p_obj in varchar2) return varchar2;
end osi_cfunds_adv;
/


CREATE OR REPLACE PACKAGE BODY "OSI_CFUNDS_ADV" AS
/******************************************************************************
   NAME:       OSI_CFUNDS_ADV
   PURPOSE:    Used to handle CFunds Advance objects

   REVISIONS:
   Date        Author           Description
   ----------  ---------------  ------------------------------------
   10/7/2009   Richard Dibble   Created this package.
   11/9/2009   Jason Faris      Added can_delete.
   12/16/2009  Richard Dibble   Modified can_delete to use the proper
                               "get status" function
   02/10/2010  Tim McGuffin     Added check_writability, fixed can_delete.
   03/25/2010  Tim McGuffin     Added get_claimant.
   10/06/2010  Tim Ward         CR#3232 - Allow Rejected (Disallowed) Advances
                                 to be Submitted Again.
								 Changed in check_writability.
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_cfunds_adv';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    /* Given an object sid as p_obj, returns a default activity tagline */
    FUNCTION get_tagline(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(300);
    BEGIN
        FOR k IN (SELECT voucher_no, request_date, claimant
                    FROM T_CFUNDS_ADVANCE_V2
                   WHERE SID = p_obj)
        LOOP
            v_return :=
                'CFunds Advance: ' || k.voucher_no || ' - '
                || TO_CHAR(k.request_date, 'dd-Mon-yyyy') || ' - '
                || Osi_Personnel.get_name(k.claimant);
        END LOOP;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline: ' || SQLERRM);
            RETURN 'get_tagline: Error';
    END get_tagline;

    /* Will take all necessary steps to create a new instance of this type of object */
    FUNCTION create_instance(
        p_obj_type           IN   VARCHAR2,
        p_claimant           IN   VARCHAR2,
        p_requested_amount   IN   VARCHAR2,
        p_requested_unit     IN   VARCHAR2,
        p_voucher_no         IN   VARCHAR2,
        p_narrative          IN   VARCHAR2,
        p_date_of_request    IN   DATE)
        RETURN VARCHAR2 IS
        v_sid   T_CORE_OBJ.SID%TYPE;
    BEGIN
        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (p_obj_type)
          RETURNING SID
               INTO v_sid;

        INSERT INTO T_CFUNDS_ADVANCE_V2
                    (SID, voucher_no, claimant, request_date, amount_requested, narrative, unit)
             VALUES (v_sid,
                     p_voucher_no,
                     p_claimant,
                     p_date_of_request,
                     p_requested_amount,
                     p_narrative,
                     p_requested_unit);

        Core_Obj.bump(v_sid);
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('Error creating CFunds Advance. Error is: ' || SQLERRM);
            RAISE;
    END create_instance;

    FUNCTION can_delete(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_claimant          T_CORE_PERSONNEL.SID%TYPE;
        v_obj_type          T_CORE_OBJ_TYPE.SID%TYPE;
        v_status            VARCHAR2(50);
        v_parent_writable   VARCHAR2(1);
    BEGIN
        SELECT claimant,
               Cfunds_Pkg.get_advance_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             issue_on,
                                             close_date),
               Core_Obj.lookup_objtype('CFUNDS_ADV')
          INTO v_claimant,
               v_status,
               v_obj_type
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        IF    v_claimant = Core_Context.personnel_sid
           OR Osi_Auth.check_for_priv('CF_PROXY', v_obj_type) = 'Y' THEN
            IF v_status IN('New', 'Rejected') THEN
                RETURN 'Y';
            ELSE
                RETURN 'Cannot delete unless status is New or Rejected.';
            END IF;
        ELSE
            RETURN 'You can only delete your own advance.';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('can_delete: ' || SQLERRM);
            RAISE;
    END can_delete;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_claimant          T_CORE_PERSONNEL.SID%TYPE;
        v_obj_type          T_CORE_OBJ_TYPE.SID%TYPE;
        v_status            VARCHAR2(50);
        v_parent_writable   VARCHAR2(1);
    BEGIN
        SELECT claimant,
               Cfunds_Pkg.get_advance_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             issue_on,
                                             close_date),
               Core_Obj.lookup_objtype('CFUNDS_ADV')
          INTO v_claimant,
               v_status,
               v_obj_type
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        IF (    (   v_claimant = Core_Context.personnel_sid
                 OR Osi_Auth.check_for_priv('CF_PROXY', v_obj_type) = 'Y')
            AND v_status IN('New', 'Rejected', 'Disallowed')) THEN
            RETURN 'Y';
        ELSIF     Osi_Auth.check_for_priv('APPROVE_CL', v_obj_type) = 'Y'
              AND v_status IN('Submitted', 'Rejected', 'Disallowed') THEN
            RETURN 'Y';
        END IF;

        RETURN 'N';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'N';
        WHEN OTHERS THEN
            log_error('check_writability: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION get_claimant(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_CFUNDS_ADVANCE_V2.claimant%TYPE;
    BEGIN
        SELECT claimant
          INTO v_rtn
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_claimant: ' || SQLERRM);
            RAISE;
    END get_claimant;
END Osi_Cfunds_Adv;
/

