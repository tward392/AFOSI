SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY "OSI_CFUNDS_ADV" AS
/******************************************************************************
   NAME:       OSI_CFUNDS_ADV
   PURPOSE:    Used to handle CFunds Advance objects

   REVISIONS:
   Date         Author           Description
   -----------  ---------------  ------------------------------------
   07-Oct-2009  Richard Dibble   Created this package.
   09-Nov-2009  Jason Faris      Added can_delete.
   16-Dec-2009  Richard Dibble   Modified can_delete to use the proper
                                  "get status" function
   10-Feb-2010  Tim McGuffin     Added check_writability, fixed can_delete.
   25-Mar-2010  Tim McGuffin     Added get_claimant.
   06-Oct-2010  Tim Ward         CR#3232 - Allow Rejected (Disallowed) Advances
                                  to be Submitted Again.
                                  Changed in check_writability.
   16-Mar-2011  Tim Ward         Added get_id function.
   18-Mar-2011  Tim Ward        CR#3731 - Privilege needs to be checked in here now since the
                                 checkForPriv from i2ms.js deleteObj function.
                                 Changed in can_delete.
   15-Aug-2011  Tim Ward        CR#3789 Change C-Funds to E-Funds.                  
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
                'EFunds Advance: ' || k.voucher_no || ' - '
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

    FUNCTION can_delete(p_obj IN VARCHAR2) RETURN VARCHAR2 IS

         v_claimant          T_CORE_PERSONNEL.SID%TYPE;
         v_obj_type          T_CORE_OBJ_TYPE.SID%TYPE;
         v_status            VARCHAR2(50);
         v_parent_writable   VARCHAR2(1);

    BEGIN
         if osi_auth.check_for_priv('DELETE',Core_Obj.get_objtype(p_obj))='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;

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

         IF v_claimant = Core_Context.personnel_sid OR Osi_Auth.check_for_priv('CF_PROXY', v_obj_type) = 'Y' THEN

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

    function get_id(p_obj in varchar2, p_obj_context in varchar2 := null)
        return varchar2 is
        v_id   t_cfunds_advance_v2.voucher_no%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select voucher_no
          into v_id
          from t_cfunds_advance_v2
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;        

END Osi_Cfunds_Adv;
/
