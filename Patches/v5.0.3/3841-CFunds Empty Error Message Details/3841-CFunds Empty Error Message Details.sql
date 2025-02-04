set define off;

CREATE OR REPLACE package body cfunds_pkg is
/*
    CFunds_Pkg - Holds C-Funds related utility and business rule
                 enforcement routines.

    History:
        29-Jul-03 RWH   Original version.
        05-Nov-03 CLJ   Updated  Reimburse_Expenses to calculate total
                        of the Total_Amount_US, not just Total_Amount
                        from t_cfunds_expense_v3.
        18-Nov-03 CLJ   Added code to Pay_Expense to set the reviewing unit for HQ.
        18-Nov-03 CLJ   Added code to Reimburse_expenses to allow HQ to
                        have their own expenses reimbursed.
        19-Nov-03 CLJ   Changed priv check in Fix_expense to look at the
                        fix priv in the Charge_to_unit not Reviewing_unit.
        19-Nov-03 CLJ   Improved previous fix to Reimburse_expenses to prevent all
                        units from reimbursing HQ's expenses.
        24-Nov-03 CLJ   Added code in Pay_Expense to default the Reviewed flag to 1.
        26-Nov-03 CLJ   Added code in Reimburse_Expenses to set the
                        Reviewed flag to 0 for all reimbursed expenses.
        02-Dec-03 CLJ   Changed Reviewed flag to set 'Y' or 'N' instead of numeric.
        12-Dec-03 CLJ   Changed Repay_Expense so that the amount repaid is
                        compared to the total amount paid to the agent, not
                        to the total amount of the expense (in the case of
                        "Take from other sources" the agent wasn't paid any money,
                        but an advance was created anyway).
        08-Mar-04 CLJ   Added new procs: Delete Expense, Create_Expense,
                        Submit_Expense, and Check_expense_required_fields.
                        Modified Repay_Expense to add in the Advance amount to the advance
                        automatically created.
        16-Apr-04 CLJ   Modified the Reimburse_Expenses method to fix the HQ Payment
                        Listing not having HQ expenses on it. <TESTING> Passed with 2 expense records.
        20-Apr-04 AES   Added PAID_CHECK_NUMBER to Update T_CFUNDS_EXPENSE_V3 statement in Pay_Expense procedure.
        19-May-04 CLJ   Modified Get_Unit_WF_Balance to solve a problem where an unreceived
                        Expense Reimbursement Transfer was being counted in the total and
                        it shouldn't have been counted.
        21-Jun-04 CLJ   Added public function "Is_Expense_Paid_Down".
        21-Jun-04 CLJ   Modified "approve_expense" to not allow an expense to be approved
                        if there was never a limitation set up for the Charge-to-unit
                        of the expense.  Error message was made more detailed.
                        Added business rule to "approve_expense" - if the expense is in a prior
                        fiscal year, do not check limitations at all.
                        Also changes in Reimburse_Expenses that are pending.
                        (these changes are commented out until they are complete.).
                        Changes that are being released: Added public functions
                       "Get_Fiscal_Year", "Get_Transfer_FY".
                        Overloaded get_fiscal_year_start_date and
                        get_fiscal_year_end_date to accept a year as parameter
                        not just a date.
        28-Jul-04 AES   Updated Submit_Expense code so that users with the CFEXP.PRXY privilege are able to submit an expense.
        19-Aug-04 CLJ   Modified Get_Transfer_FY to return a FY date for transfers that don't
                        have expenses.
                        Modified the select statement in Reimburse_Expenses to only
                        select those expenses within the specified fiscal year.
                        Took out processing in reimburse_expenses that checks limitations
                        for prior fiscal years.  Limitations are only restricting in the
                        current fiscal year.
                        Modified approve_expense so that if the expense date is not in the
                        current fiscal year, no limitation checks are done.
      22-Sep-04 CLJ   Updated Receive_Working_Funds procedure to not close any expenses
                        marked "Take_From_Other_Sources" unless they have all transfers complete.
                        Added new procedure, Pay_TFOS_Expense.
      22-Sep-04 CLJ   Modified "get_transfer_fy" to use the expense table instead of
                        the view to speed up performance.
      30-Sep-04 CLJ   Modified "Get_Unit_WF_Balance" to look at the new TFOS fields
                        of an expense.  Also changed logic a bit to look at the Repaid
                        fields all the time instead of only when expense date was certain thing.
      25-Oct-04 CLJ   Modified "Get_Unit_WF_Balance" to return a working fund balance
                        for a date in the past specified by new parameter, pAsOf.
                        Modified "Get_Fiscal_Year_Start_Date" to fix an error
                        seen only on Oct 1.
      xx-Oct-04 CLJ   Added public function "Get_MFR_Status".
                        Changed the v_recon_threshold variable to be 0.
                        Added public function "Reconcile".
      17-Jan-05 CLJ   Added public routine "Create_CFunds_Unit". For
                        developers use only right now.
      16-May-05 GEG   Added rounding calculations where CONVERSION_RATE is used in division.  Occurs in
                         Check_Expense_Required_Fields and Get_Unit_WF_Balance. Added a correction to
                         Get_Unit_WF_Balance where a T_CFUNDS_EXPENSE_V3 "select statment where clause"  problem.
                         Changed REPAID_ON < v_since_date to REPAID_ON < v_asof_date.
      29-Jun-05 GEG   Changed reimburse expenses to use a 'P' for the creation of the voucher number.
                        Added two functions is_unit_parent and is_Unit_child.  These will tell you if
                        the parent or child unit passed in as a 2nd parameter is the parent or child of the
                        first parameter (unit) passed in.
                        Reversed the Disallowed and Reject functionality.  Request from Cfunds to
                        relabel the Disallow to Reject and the Reject to Disallow.  This incurred
                        redoing functionality to let Disallow to exhibit Reject functionality and Disallow
                        to exhibit Reject functionality.
                        Gave the ability to get the voucher number set on submission of expense
                        Added a dfo creation function
                        Added a mfr creation function
      01-Aug-05 JAT   Added functions for end of year closing.  get_unit_wfaf to get the end of year
                        working funds, get_unit_dfotf to get end of year dfo balance, get_unit_oa to get
                        end of year outstanding advances, get_unit_oe to get end of year outstanding
                        expenses.  Additional routines send_closing_transfer to add an end of year closing
                        transfer row to the Oracle table and get_units_eoy_order which return a list of
                        units in tree order, top to bottom or bottom to top, for doing the end of year
                        transfers.
      08-Aug-05 JAT   Modified get_unit_wf_balance to handle new end of year transfer types of WFAF,
                        OA, OE, and DFOTF.  For end of year closing, all detachments and regions transfer
                        DFO funcds, outstanding expenses, outstanding advances, and working fund balance
                        to their parent unit and everything works its way up to headquarters.  Because of
                        these transfers, all detachments and regions end the year with a zero balance.
                        Then, the first day of the new fiscal year, all of these balances get transferred
                        back to the originating unit.
    11-Oct-05 JDB   Modified Unit OE to account for a repayment from a previous year.

    01-NOV-06 WC    Modified submit_expense  CR#1988
    09-JUL-07 JDB   Modified Send working funds to handle parent units better.
    20-JUL-07 JDB   Modified Get Unit OE. Added DER calc to incomming transfers. FIS 24 is the only unit with these at this time so it was hard to notice.
    02-AUG-07 JDB   Modified Send Working Funds. Added a check for available working funds amount.
    13-May-09 MAB   Copied from old i2ms schema and modified to make more suitable to current environment,
                     e.g., made calls to old context package now call core_context, commented out calls to
                     old context package that no longer exist in core_context, capture sids using the
                     returning into clause on inserts instead of using old sequences that generated sids,
                     which do not exist in this schema, etc.
    22-May-09 CVH   Added get_tagline.
    26-Jun-09 CVH   Moved get_tagline to osi_cfunds.
    12-Oct-09 RND   Added approve_advance_for_apex
    13-Jul-10 JLH   Updated action types used for cfunds_test_cfp to those used by WEBI2MS.
    24-Aug-10 TJW   WCH00000318 Changed hard coded sids in get_units_eoy_order, get_unit_accountability, and is_unit_parent,
    03-Mar-11 TJW   CR#3729 Changed repay_expense to insert into T_CORE_OBJ before inserting into T_CFUNDS_ADVANCE_V2.  
                     Not doing this was causing an 
                     "ORA-02291: integrity constraint (WEBI2MS.FK_CFUNDS_ADVANCE_V2_OBJ) violated - parent key not found" error.
    11-May-11 TJW   CR#3841 Changed get_error_detail to get the internal SQLERRM error message if v_error_details is empty.  
                     Hopefully this will avoid blank error messages (like what was happening when some users were tryign to create an MFR).
     
*/
    c_pipe              varchar2(20)     := core_util.get_config('CORE.PIPE_PREFIX')
                                            || 'CFUNDS_PKG';
    v_error_detail      varchar2(1000);
    v_exp_rec           v_cfunds_expense_v3%rowtype;
    v_adv_rec           v_cfunds_advance_v2%rowtype;
    v_arp_rec           v_cfunds_advance_repayment_v2%rowtype;
    v_xfr_rec           v_cfunds_xfr%rowtype;
    v_recon_threshold   number                                  := 200;
    -- Days before last reconcile to look for transactions
    v_dollar_format     varchar2(25)                            := '$999,999,999,999,990.00';
    v_hq_cc_unit_sid    varchar2(20)                  := core_util.get_config('OSI.HQ_CC_UNIT_SID');
    -- Following variables set by each routine that uses them.
    -- Saves call into the Context_Pkg.
    v_my_name           varchar2(500);
 
    -- Private Routines (not in spec)
    function get_cat_cnts_against_limits(pcat in varchar2)
        return boolean is
    begin
        if nvl(pcat, '-') in('E') then
            return false;
        else
            return true;
        end if;
    end get_cat_cnts_against_limits;

-- looks to see that all required fields for an expense have been completed
-- the expense must already be loaded into v_exp_rec before calling this function.
-- an exception will be raised if a field isn't filled in.
    procedure check_expense_required_fields is
        v_doc_required_amount   varchar2(50);
    begin
        -- check for all required fields being filled in.
        -- required fields are:.
        --     1)Incurred_Date, 2)charge_to_unit, 3)Claimant,
        --     4)category, 5)paragraph, 6)description,
        --     7)parent_info, 8)conversion_rate,
        --     9)one of agent_amount or source_amount,
        --     10)one of three Documentation values - only when Total amount US is $75 or greater.
        if v_exp_rec.incurred_date is null then
            v_error_detail := 'Please specify the Date of this Expense.';
            raise invalid_parameters;
        elsif v_exp_rec.incurred_date > sysdate then
            v_error_detail := 'The date of this expense cannot be in the future.';
            raise invalid_parameters;
        end if;

        if    v_exp_rec.charge_to_unit is null
           or v_exp_rec.charge_to_unit = ' ' then
            v_error_detail :=
                         'There is no Unit for this Expense, an expense must be charged to a Unit.';
            raise invalid_parameters;
        end if;

        if v_exp_rec.claimant is null then
            v_error_detail := 'Please specify the Claimant for this Expense.';
            raise invalid_parameters;
        end if;

        if v_exp_rec.category is null then
            v_error_detail := 'Please specify a Category for this Expense.';
            raise invalid_parameters;
        end if;

        if v_exp_rec.paragraph is null then
            v_error_detail := 'Please specify a Paragraph for this Expense.';
            raise invalid_parameters;
        end if;

        if v_exp_rec.description is null then
            v_error_detail := 'Please provide some justification/comments for this Expense.';
            raise invalid_parameters;
        end if;

        if v_exp_rec.parent_info is null then
            v_error_detail := 'Please specify the Context of this Expense.';
            raise invalid_parameters;
        end if;

        if v_exp_rec.conversion_rate is null then
            v_error_detail := 'Please specify the Conversion Rate for this Expense.';
            raise invalid_parameters;
        end if;

        if (nvl(v_exp_rec.source_amount, 0) + nvl(v_exp_rec.agent_amount, 0)) = 0 then
            v_error_detail := 'Please specify a Source Amount or an Agent Amount for this Expense.';
            raise invalid_parameters;
        end if;

        select setting
          into v_doc_required_amount
          from t_core_config
         where code = 'CF_RDREQ';

        -- are the amounts enough to make documentation required?.
        if (round((((nvl(v_exp_rec.source_amount, 0) + nvl(v_exp_rec.agent_amount, 0))
                    / nvl(v_exp_rec.conversion_rate, 1))),
                  2) > nvl(v_doc_required_amount, 1)) then
            if v_exp_rec.receipts_disposition is null then
                v_error_detail :=
                    'Please choose an appropriate option under the "Documentation necessary" section.';
                raise invalid_parameters;
            end if;
        end if;
    end check_expense_required_fields;

-- Returns just the year that is the fiscal year for the given date.
    function get_fiscal_year(pfor_date in date := null)
        return varchar2 is
        v_work_date   date;
    begin
        v_work_date := nvl(pfor_date, sysdate);
        return to_char(add_months(v_work_date, 3), 'YYYY');
    end get_fiscal_year;

    function get_fiscal_year_start_date(pfor_date in date := null)
        return date is
        v_work_date   date;
    begin
        v_work_date := nvl(pfor_date, sysdate);

        if v_work_date >= to_date('01-Oct-' || to_char(v_work_date, 'YYYY'), 'dd-Mon-yyyy') then
            return to_date('01-Oct-' || to_char(v_work_date, 'YYYY'), 'dd-Mon-yyyy');
        else
            return add_months(to_date('01-Oct-' || to_char(v_work_date, 'YYYY'), 'dd-Mon-yyyy'),
                              -12);
        end if;
    end get_fiscal_year_start_date;

    function get_fiscal_year_start_date(pfor_fiscal_year in varchar2 := null)
        return date is
        v_work_year   varchar2(10);
        v_work_date   date;
    begin
        v_work_year := nvl(pfor_fiscal_year, get_fiscal_year(sysdate));
        v_work_date := to_date('01-Jan-' || v_work_year, 'dd-Mon-yyyy');
        --This does not look right but breaks form29 when changed
        return get_fiscal_year_start_date(v_work_date);
    end get_fiscal_year_start_date;

    function get_fiscal_year_end_date(pfor_date in date := null)
        return date is
    begin
        return add_months(get_fiscal_year_start_date(pfor_date), 12) - 1;
    end get_fiscal_year_end_date;

    function get_fiscal_year_end_date(pfor_year in varchar2 := null)
        return date is
    begin
        return add_months(get_fiscal_year_start_date(pfor_year), 12) - 1;
    end get_fiscal_year_end_date;

    function get_transfer_fy(ptransfer in varchar2)
        return varchar2 is
        v_expense_date   date;
    begin
        v_error_detail := null;

        select nvl(exp.incurred_date, t.create_on)
          into v_expense_date
          from t_cfunds_xfr_exp et, t_cfunds_expense_v3 exp, v_cfunds_xfr t
         where et.xfr(+) = t.SID and et.expense = exp.SID(+) and t.SID = ptransfer and rownum <= 1;

        return get_fiscal_year(v_expense_date);
    exception
        when no_data_found then
            return null;
    end get_transfer_fy;

    procedure load_expense(pexpense in varchar2) is
    begin
        select *
          into v_exp_rec
          from v_cfunds_expense_v3
         where SID = pexpense;
    exception
        when no_data_found then
            raise_application_error(-20200, 'Invalid Expense SID specified.');
        when others then
            raise_application_error(-20200, 'Exception in Load_Expense: ' || sqlerrm);
    end load_expense;

    procedure load_advance(padvance in varchar2) is
    begin
        select *
          into v_adv_rec
          from v_cfunds_advance_v2
         where SID = padvance;
    exception
        when no_data_found then
            raise_application_error(-20200, 'Invalid Advance SID specified.');
        when others then
            raise_application_error(-20200, 'Exception in Load_Advance: ' || sqlerrm);
    end load_advance;

    procedure load_advance_repayment(padvance_repayment in varchar2) is
    begin
        select *
          into v_arp_rec
          from v_cfunds_advance_repayment_v2
         where SID = padvance_repayment;
    exception
        when no_data_found then
            raise_application_error(-20200, 'Invalid Advance Repayment SID specified.');
        when others then
            raise_application_error(-20200, 'Exception in Load_Advance_Repayment: ' || sqlerrm);
    end load_advance_repayment;

    procedure load_transfer(pxfr in varchar2) is
    begin
        select *
          into v_xfr_rec
          from v_cfunds_xfr
         where SID = pxfr;
    exception
        when no_data_found then
            raise_application_error(-20200, 'Invalid Transfer SID specified.');
        when others then
            raise_application_error(-20200, 'Unhandled exception in Load_Transfer: ' || sqlerrm);
    end load_transfer;

-- General Routines (remaining routines are public - in spec)
    function get_error_detail
        return varchar2 is
    begin
        if v_error_detail is null or v_error_detail='' then
          v_error_detail:=SQLERRM;
        end if;
        
        return v_error_detail;
    end get_error_detail;

    function get_voucher_num(ptype in varchar2, pfor_date in date := sysdate)
        return varchar2 is
        v_vno   number;
    begin
        if upper(ptype) not in('A', 'E', 'R', 'X', 'M', 'P', 'D') then
            core_logger.log_it(c_pipe,
                               'Invalid C-Funds voucher type (' || ptype || ') - returning NULL');
            return null;
        end if;

        select s_cfunds_vno.nextval
          into v_vno
          from dual;

        return upper(ptype) || to_char(add_months(pfor_date, 3), 'yy')
               || ltrim(to_char(v_vno, '0000000'), ' ');
    end get_voucher_num;

    function get_reconcile_threshold
        return number is
        v_threshold   number;
    begin
        select setting
          into v_threshold
          from t_core_config
         where code = 'CF_THRESH';

        return v_threshold;
    exception
        when no_data_found then
            return 0;
        when others then
            return 0;
    end get_reconcile_threshold;

-- Expense related routines
    function get_expense_status(
        psubmitted_on     in   date,
        papproved_on      in   date,
        prejected_on      in   date,
        ppaid_on          in   date,
        pinvalidated_on   in   date,
        prepaid_on        in   date,
        previewing_unit   in   varchar2,
        pclosed_on        in   date)
        return varchar2 is
    begin
        if prepaid_on is not null then
            return 'Repaid';
        end if;

--  reversed Rejected and Disallowed;
        if pinvalidated_on is not null then
            return 'Rejected';
        end if;

        if pclosed_on is not null then
            return 'Closed';
        end if;

        if ppaid_on is not null then
            return 'Paid';
        end if;

        if papproved_on is not null then
            return 'Approved';
        end if;

--  reversed Rejected and Disallowed;
        if prejected_on is not null and prejected_on > psubmitted_on then
            -- MBATDORF - POTENTIAL BUG - WHY IS AN EXPENSE REJECTED
            -- ON THE SAME DAY IT IS SUBMITTED NOT DISALLOWED?
            return 'Disallowed';
        end if;

        if psubmitted_on is not null then
            return 'Submitted';
        end if;

        return 'New';
    end get_expense_status;

    function is_expense_paid_down(pexpense in varchar2, punit in varchar2)
        return varchar2 is
        v_xfr   varchar2(50);
    begin
        v_error_detail := null;

        select e.xfr
          into v_xfr
          from t_cfunds_xfr_exp e, v_cfunds_xfr t
         where e.xfr = t.SID
           and t.xfr_type = 'ER'
           and t.sender = punit
           and e.expense = pexpense
           and t.receive_date is not null;

        return 'Y';
    exception
        when no_data_found then
            return 'N';
    end is_expense_paid_down;

    procedure delete_expense(pexpense in varchar2) is
    begin
        v_error_detail := null;

        delete from t_cfunds_expense_v3
              where SID = pexpense and paid_on is null;
    --under no circumstances is a paid expense ever to be deleted.
    end delete_expense;

    procedure create_expense(
        pincurred_date          in       date,
        pcharge_to_unit         in       varchar2,
        pclaimant               in       varchar2,
        pcategory               in       varchar2,
        pparagraph              in       varchar2,
        pdescription            in       varchar2,
        pcontext                in       varchar2,
        ptake_from_advances     in       number,
        ptake_from_other        in       number,
        preceipts_disposition   in       varchar2,
        psource_amount          in       number,
        pagent_amount           in       number,
        pconversion_rate        in       number,
        psid                    out      varchar2) is
    begin
        v_error_detail := null;

        -- check for all required fields being filled in.
        -- required fields are:.
        --     Claimant, Incurred_Date,
        --     charge_to_unit, category,
        --     conversion_rate, one of agent_amount or source_amount

        -- Incurred date is allowed to be in the future as long as its not
        -- past the last day of the current fiscal year.  This is ok until
        -- submittal, at which point the date cannot be in the future.
        if pincurred_date is null then
            v_error_detail := 'Please specify the Date of this Expense.';
            raise invalid_parameters;
        elsif get_fiscal_year_end_date(pincurred_date) > get_fiscal_year_end_date(sysdate) then
            v_error_detail :=
                    'The date of this expense cannot be beyond the end of the current fiscal year.';
            raise invalid_parameters;
        end if;

        if    pcharge_to_unit is null
           or pcharge_to_unit = ' ' then
            v_error_detail :=
                         'There is no Unit for this Expense, an expense must be charged to a Unit.';
            raise invalid_parameters;
        end if;

        if pclaimant is null then
            v_error_detail := 'Please specify the Claimant for this Expense.';
            raise invalid_parameters;
        end if;

        if pcategory is null then
            v_error_detail := 'Please specify a Category for this Expense.';
            raise invalid_parameters;
        end if;

-- also check for positive amounts here
        if (nvl(psource_amount, 0) + nvl(pagent_amount, 0)) = 0 then
            v_error_detail := 'Please specify a Source Amount or an Agent Amount for this Expense.';
            raise invalid_parameters;
        end if;

-- positive amount check too
        if pconversion_rate is null then
            v_error_detail := 'Please specify the Conversion Rate for this Expense.';
            raise invalid_parameters;
        end if;

        if     pclaimant <> core_context.personnel_sid
           and cfunds_test_cfp('EXP_PAY',
                               core_obj.lookup_objtype('CFUNDS_EXP'),
                               core_context.personnel_sid,
                               pcharge_to_unit) = 'N' then
            v_error_detail := 'You do not have privilege to create this expense.';
            raise no_privilege;
        end if;

        --  Note- Source_ID is only generated thru the view, not available in table.
        --    for that reason it cannot be specified when a new expense is created.
        v_exp_rec := null;
        v_my_name := core_context.personnel_name;
        v_exp_rec.voucher_no := 'to be auto-generated';
        v_exp_rec.incurred_date := pincurred_date;
        v_exp_rec.charge_to_unit := pcharge_to_unit;
        v_exp_rec.claimant := pclaimant;
        v_exp_rec.category := pcategory;
        v_exp_rec.paragraph := pparagraph;
        v_exp_rec.description := pdescription;
        v_exp_rec.parent_info := pcontext;
        v_exp_rec.take_from_advances := ptake_from_advances;
        v_exp_rec.take_from_other_sources := ptake_from_other;
        v_exp_rec.receipts_disposition := preceipts_disposition;
        v_exp_rec.source_amount := psource_amount;
        v_exp_rec.agent_amount := pagent_amount;
        v_exp_rec.conversion_rate := pconversion_rate;
        v_exp_rec.create_by := v_my_name;
        v_exp_rec.create_on := sysdate;
        v_exp_rec.modify_by := v_my_name;
        v_exp_rec.modify_on := sysdate;

        insert into t_cfunds_expense_v3
                    (voucher_no,
                     incurred_date,
                     charge_to_unit,
                     claimant,
                     category,
                     paragraph,
                     description,
                     parent_info,
                     take_from_advances,
                     take_from_other_sources,
                     receipts_disposition,
                     source_amount,
                     agent_amount,
                     conversion_rate,
                     create_by,
                     create_on,
                     modify_by,
                     modify_on)
             values (v_exp_rec.voucher_no,
                     v_exp_rec.incurred_date,
                     v_exp_rec.charge_to_unit,
                     v_exp_rec.claimant,
                     v_exp_rec.category,
                     v_exp_rec.paragraph,
                     v_exp_rec.description,
                     v_exp_rec.parent_info,
                     v_exp_rec.take_from_advances,
                     v_exp_rec.take_from_other_sources,
                     v_exp_rec.receipts_disposition,
                     v_exp_rec.source_amount,
                     v_exp_rec.agent_amount,
                     v_exp_rec.conversion_rate,
                     v_exp_rec.create_by,
                     v_exp_rec.create_on,
                     v_exp_rec.modify_by,
                     v_exp_rec.modify_on)
          returning SID
               into v_exp_rec.SID;

        psid := v_exp_rec.SID;
    end create_expense;

    procedure submit_expense(pexpense in varchar2) is
        v_voucher_no   t_cfunds_expense_v3.voucher_no%type;
    begin
        v_error_detail := null;
        load_expense(pexpense);

        if v_exp_rec.status <> 'New' and v_exp_rec.status <> 'Disallowed' then
            v_error_detail := 'Expense has already been submitted for approval.';
            raise bad_timing;
        end if;

        check_expense_required_fields;

        -- exceptions are raised from this method.
        if v_exp_rec.claimant <> core_context.personnel_sid then
            if     cfunds_test_cfp('EXP_CRE_PROXY',
                                   core_obj.lookup_objtype('CFUNDS_EXP'),
                                   core_context.personnel_sid,
                                   v_exp_rec.charge_to_unit) = 'N'
               and cfunds_test_cfp('EXP_PAY',
                                   core_obj.lookup_objtype('CFUNDS_EXP'),
                                   core_context.personnel_sid,
                                   v_exp_rec.charge_to_unit) = 'N' then
                v_error_detail := 'You do not have privilege to submit this expense.';
                raise no_privilege;
            end if;
        end if;

        v_my_name := core_context.personnel_name;

        if    v_exp_rec.voucher_no = 'to be auto-generated'
           or v_exp_rec.voucher_no = ''
           or v_exp_rec.voucher_no is null then
            -- On submission of expense create a voucher number.
            v_voucher_no := get_voucher_num('E', v_exp_rec.incurred_date);
        else
            v_voucher_no := v_exp_rec.voucher_no;
        end if;

        update t_cfunds_expense_v3
           set submitted_on = sysdate,
               voucher_no = v_voucher_no,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = pexpense;
    end submit_expense;

    procedure approve_expense(pexpense in varchar2) is
        v_lim   number;
        v_bal   number;
    begin
        v_error_detail := null;
        load_expense(pexpense);

        if v_exp_rec.status = 'New' then
            v_error_detail := 'Expense has not yet been submitted for approval.';
            core_logger.log_it(c_pipe, 'exception in approve expense: ' || v_error_detail);
            raise bad_timing;
        end if;

        if v_exp_rec.status <> 'Submitted' then
            v_error_detail := 'Expense has already been approved (or disallowed).';
            core_logger.log_it(c_pipe, 'exception in approve expense: ' || v_error_detail);
            raise bad_timing;
        end if;

        check_expense_required_fields;

        -- exceptions are raised from this method.
        if v_exp_rec.claimant = core_context.personnel_sid then
            v_error_detail := 'You are not allowed to approve your own expenses.';
            core_logger.log_it(c_pipe, 'exception in approve expense: ' || v_error_detail);
            raise no_privilege;
        end if;

        if cfunds_test_cfp('APPROVE_CL',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           v_exp_rec.charge_to_unit) = 'N' then
            v_error_detail := 'You do not have privilege to approve this expense.';
            core_logger.log_it(c_pipe, 'exception in approve expense: ' || v_error_detail);
            raise no_privilege;
        end if;

        -- If the expense date is not in the current fiscal year, no limitation
        -- checks are done.
        if v_exp_rec.incurred_date >= get_fiscal_year_start_date(sysdate) then
            if get_cat_cnts_against_limits(v_exp_rec.category) then
                v_lim :=
                       get_unit_limitation(v_exp_rec.charge_to_unit, 'EXP', v_exp_rec.pec, sysdate);
                v_bal :=
                    get_unit_annual_expenses(v_exp_rec.charge_to_unit,
                                             v_exp_rec.pec,
                                             v_exp_rec.incurred_date);

                if nvl(v_bal, 0) + nvl(v_exp_rec.total_amount_us, 0) > nvl(v_lim, 0) then
                    v_error_detail := 'Annual limitation would be exceeded by this expense.';

                    if nvl(v_lim, 0) = 0 then
                        v_error_detail :=
                            v_error_detail
                            || ' The annual limitation may never have been setup, please assign a limitation to this unit: '
                            || v_exp_rec.charge_to_unit_name || '.';
                    end if;

                    core_logger.log_it(c_pipe, 'exception in approve expense: ' || v_error_detail);
                    raise limitation_exceeded;
                end if;
            end if;
        end if;

        v_my_name := core_context.personnel_name;

        update t_cfunds_expense_v3
           set approved_by = v_my_name,
               approved_on = sysdate,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = pexpense;
    end approve_expense;

-- This uses the code for the old reject expense.  Reversed what disallowed
-- and rejected mean.
    procedure disallow_expense(pexpense in varchar2, pcomment in varchar2) is
    begin
        v_error_detail := null;
        load_expense(pexpense);

        if v_exp_rec.status = 'New' then
            v_error_detail := 'Expense has not yet been submitted for approval.';
            core_logger.log_it(c_pipe, 'exception in disallow expense: ' || v_error_detail);
            raise bad_timing;
        end if;

        if v_exp_rec.status <> 'Submitted' then
            v_error_detail := 'Expense has already been approved (or disallowed).';
            core_logger.log_it(c_pipe, 'exception in disallow expense: ' || v_error_detail);
            raise bad_timing;
        end if;

        if v_exp_rec.claimant = core_context.personnel_sid then
            v_error_detail := 'You are not allowed to disallow your own expenses.';
            core_logger.log_it(c_pipe, 'exception in disallow expense: ' || v_error_detail);
            raise no_privilege;
        end if;

        if cfunds_test_cfp('APPROVE_CL',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           v_exp_rec.charge_to_unit) = 'N' then
            v_error_detail := 'You do not have privilege to disallow this expense.';
            core_logger.log_it(c_pipe, 'exception in disallow expense: ' || v_error_detail);
            raise no_privilege;
        end if;

        v_my_name := core_context.personnel_name;

        update t_cfunds_expense_v3
           set rejected_by = v_my_name,
               rejected_on = sysdate,
               rejection_comment = pcomment,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = pexpense;
    end disallow_expense;

    procedure pay_expense(
        pexpense     in       varchar2,
        pcash_amt    in       number,
        pcheck_amt   in       number,
        pcheck_num   in       varchar2,
        pvoucher     out      varchar2) is
        v_adv_amt     number;
        v_avail_amt   number;
        v_rev_unit    t_cfunds_expense_v3.reviewing_unit%type;
    begin
        v_error_detail := null;
        savepoint one;
        load_expense(pexpense);
        v_my_name := core_context.personnel_name;

        if v_exp_rec.approved_on is null then
            v_error_detail := 'Expense has not yet been approved.';
            raise bad_timing;
        end if;

        if v_exp_rec.paid_on is not null then
            v_error_detail := 'Expense has already been paid.';
            raise bad_timing;
        end if;

        check_expense_required_fields;

        -- exceptions are raised from this method.
        if round(pcheck_amt, 2) <> pcheck_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the check amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if round(pcash_amt, 2) <> pcash_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the cash amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if     nvl(v_exp_rec.take_from_advances, 0) = 0
           and (nvl(pcash_amt, 0) + nvl(pcheck_amt, 0)) <> v_exp_rec.total_amount_us then
            v_error_detail :=
                'Cash and Check amounts do not total to expense amount, and "Take from Advances" not specified.';
            raise invalid_parameters;
        end if;

        if     abs(v_exp_rec.take_from_advances) = 1
           and (nvl(pcash_amt, 0) + nvl(pcheck_amt, 0)) > v_exp_rec.total_amount_us then
            v_error_detail := 'Cash and Check amounts cannot exceed total expense amount.';
            raise invalid_parameters;
        end if;

        if cfunds_test_cfp('EXP_PAY',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           v_exp_rec.charge_to_unit) = 'N' then
            v_error_detail := 'You do not have privilege to pay this expense.';
            raise no_privilege;
        end if;

        -- Now we start the process of marking the expense PAID. The only real
        -- tricky part is dealing with the "Take from Advances" option.
        v_exp_rec.paid_cash_amount := nvl(pcash_amt, 0);
        v_exp_rec.paid_check_amount := nvl(pcheck_amt, 0);
        v_exp_rec.paid_check_number := pcheck_num;
        v_exp_rec.advance_amount := 0;
        v_adv_amt :=
                v_exp_rec.total_amount_us - v_exp_rec.paid_cash_amount - v_exp_rec.paid_check_amount;

        -- double checking - this should be the same value but in transitioning
        -- to the new way of creating a voucher numbers (at submit) there may be a possibility
        -- of having an invalid voucher number which has to be set by this time
        if    (v_exp_rec.voucher_no = 'to be auto-generated')
           or (v_exp_rec.voucher_no is null) then
            v_exp_rec.voucher_no := get_voucher_num('E', v_exp_rec.incurred_date);
        end if;

        if abs(v_exp_rec.take_from_advances) = 1 and v_adv_amt > 0 then
            for a in (select   SID, check_amount, cash_amount, expensed_amount,
                               get_advance_total_repayments(SID) as repay_amount
                          from v_cfunds_advance_v2
                         where claimant = v_exp_rec.claimant
                           and unit = v_exp_rec.charge_to_unit
                           and status = 'Active'
                      order by issue_on)
            loop
                v_avail_amt :=
                    nvl(a.check_amount, 0) + nvl(a.cash_amount, 0) - nvl(a.expensed_amount, 0)
                    - nvl(a.repay_amount, 0);

                if v_avail_amt > 0 then
                    -- should always be true, but just in case...
                    if v_avail_amt <= v_adv_amt then
                        -- Use all this advance on this expense
                        update t_cfunds_advance_v2
                           set expensed_amount = nvl(expensed_amount, 0) + v_avail_amt,
                               close_date = sysdate,
                               narrative =
                                   narrative || chr(13) || chr(10) || v_exp_rec.voucher_no || '  '
                                   || to_char(v_exp_rec.incurred_date, 'dd-Mon-yyyy') || '  '
                                   || to_char(v_avail_amt, '$9,999,990.00'),
                               modify_by = v_my_name,
                               modify_on = sysdate
                         where SID = a.SID;

                        v_adv_amt := v_adv_amt - v_avail_amt;
                        v_exp_rec.advance_amount := v_exp_rec.advance_amount + v_avail_amt;
                    else
                        -- Use some of this advance on this expense
                        update t_cfunds_advance_v2
                           set expensed_amount = nvl(expensed_amount, 0) + v_adv_amt,
                               narrative =
                                   narrative || chr(13) || chr(10) || v_exp_rec.voucher_no || '  '
                                   || to_char(v_exp_rec.incurred_date, 'dd-Mon-yyyy') || '  '
                                   || to_char(v_adv_amt, '$9,999,990.00'),
                               modify_by = v_my_name,
                               modify_on = sysdate
                         where SID = a.SID;

                        v_exp_rec.advance_amount := v_exp_rec.advance_amount + v_adv_amt;
                        v_adv_amt := 0;
                    end if;
                end if;

                exit when v_adv_amt = 0;                                          -- gone far enough
            end loop;                                                                    -- advances
        end if;

        if v_adv_amt > 0 then
            -- Problem. Don't have enough available advances to cover the part
            -- of the expense that wasn't paid by Cash/Check.
            v_error_detail :=
                'Insufficient advances to cover remaining portion ('
                || ltrim(to_char(v_adv_amt, '$9,990.00')) || ') of the expense.';
            raise invalid_parameters;
        -- Should run through exception handler
        end if;

        v_rev_unit := get_next_reviewing_unit(v_exp_rec.charge_to_unit);

        -- if there isn't a next reviewing unit then this must be HQ and we need to set this
        -- value for the reviewing unit so that this expense will show up on the payment listing.
        if v_rev_unit is null then
            v_rev_unit := v_exp_rec.charge_to_unit;
        end if;

        update t_cfunds_expense_v3
           set voucher_no = v_exp_rec.voucher_no,
               reviewing_unit = v_rev_unit,
               reviewed = 'N',
               paid_by = v_my_name,
               paid_on = sysdate,
               paid_cash_amount = v_exp_rec.paid_cash_amount,
               paid_check_amount = v_exp_rec.paid_check_amount,
               paid_check_number = v_exp_rec.paid_check_number,
               advance_amount = v_exp_rec.advance_amount,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = pexpense;

        pvoucher := v_exp_rec.voucher_no;
    exception
        when others then
            rollback to savepoint one;
            raise;
    end pay_expense;

-- This uses the code for the old disallow expense.  Reversed what disallowed
-- and rejected mean.
    procedure reject_expense(pexpense in varchar2, pcomment in varchar2) is
    begin
        v_error_detail := null;
        --CONTEXT_PKG.CHECK_CONTEXT;
        load_expense(pexpense);

        if v_exp_rec.paid_on is null then
            v_error_detail := 'Expense has not yet been paid.';
            raise bad_timing;
        end if;

        if v_exp_rec.invalidated_on is not null then
            v_error_detail := 'Expense has already been rejected.';
            raise bad_timing;
        end if;

        if v_exp_rec.reviewing_unit is null then
            v_error_detail := 'Expense is not under review.';
            raise bad_timing;
        end if;

        if cfunds_test_cfp('EXP_INVALIDATE',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           v_exp_rec.reviewing_unit) = 'N' then
            v_error_detail := 'You do not have privilege to reject this expense.';
            raise no_privilege;
        end if;

        v_my_name := core_context.personnel_name;

        update t_cfunds_expense_v3
           set invalidated_by = v_my_name,
               invalidated_on = sysdate,
               invalidation_comment = pcomment,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = pexpense;
    end reject_expense;

    procedure fix_expense(pexpense in varchar2) is
    begin
        v_error_detail := null;
        --CONTEXT_PKG.CHECK_CONTEXT;
        load_expense(pexpense);

        if v_exp_rec.invalidated_on is null then
            v_error_detail := 'Expense has not been Rejected.';
            raise bad_timing;
        end if;

        if v_exp_rec.repaid_on is not null then
            v_error_detail := 'Expense has already been repaid.';
            raise bad_timing;
        end if;

        if cfunds_test_cfp('EXP_FIX_INVALID',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           v_exp_rec.charge_to_unit) = 'N' then
            v_error_detail := 'You do not have the privilege to fix this expense.';
            raise no_privilege;
        end if;

        v_my_name := core_context.personnel_name;

        update t_cfunds_expense_v3
           set invalidated_by = null,
               invalidated_on = null,
               invalidation_comment =
                              invalidation_comment || ' FIXED by ' || v_my_name || ' on ' || sysdate,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = pexpense;
    end fix_expense;

    procedure repay_expense(
        pexpense       in       varchar2,
        pcash_amt      in       number,
        pcheck_amt     in       number,
        pcheck_num     in       varchar2,
        ppmt_voucher   out      varchar2,
        padv_voucher   out      varchar2,
        pxfr_voucher   out      varchar2) is

        v_obj_type_sid varchar2(20);
        v_acl_sid      varchar2(20);
                
    begin
        v_error_detail := null;
        savepoint one;
        load_expense(pexpense);

        if v_exp_rec.invalidated_on is null then
            v_error_detail := 'Expense has not been rejected.';
            raise bad_timing;
        end if;

        if v_exp_rec.repaid_on is not null then
            v_error_detail := 'Expense has already been repaid.';
            raise bad_timing;
        end if;

        if round(pcash_amt, 2) <> pcash_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the cash amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if round(pcheck_amt, 2) <> pcheck_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the check amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if nvl(pcash_amt, 0) + nvl(pcheck_amt, 0) > v_exp_rec.total_amount_us then
            v_error_detail := 'Expense repayment is more than total expense amount.';
            raise invalid_parameters;
        end if;

        if nvl(pcheck_amt, 0) = 0 and pcheck_num is not null then
            v_error_detail := 'Check Number specified with no Check Amount.';
            raise invalid_parameters;
        end if;

        if cfunds_test_cfp('EXP_ENTER_REPAY',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           v_exp_rec.charge_to_unit) = 'N' then
            v_error_detail := 'You do not have privilege to enter a repayment for this expense.';
            raise no_privilege;
        end if;

        if nvl(pcash_amt, 0) + nvl(pcheck_amt, 0) > 0 then
            v_exp_rec.repaid_voucher_no := get_voucher_num('E');
        end if;

        v_adv_rec := null;
        v_my_name := core_context.personnel_name;

        if nvl(pcash_amt, 0) + nvl(pcheck_amt, 0) <
               nvl(v_exp_rec.advance_amount, 0) + nvl(v_exp_rec.paid_cash_amount, 0)
               + nvl(v_exp_rec.paid_check_amount, 0) then
            -- Need to create an advance to collect the remaining portion
            -- of the expense.
            v_adv_rec.voucher_no := get_voucher_num('A');
            v_adv_rec.request_date := sysdate;
            v_adv_rec.unit := v_exp_rec.charge_to_unit;
            -- need to add in the advanced amount too.
            v_adv_rec.amount_requested :=
                (nvl(v_exp_rec.advance_amount, 0) + nvl(v_exp_rec.paid_cash_amount, 0)
                 + nvl(v_exp_rec.paid_check_amount, 0))
                -(nvl(pcash_amt, 0) + nvl(pcheck_amt, 0));
            v_adv_rec.claimant := v_exp_rec.claimant;
            v_adv_rec.narrative :=
                'Auto-generated advance to cover unrepaid portion ' || 'of expense '
                || v_exp_rec.voucher_no || ' which ' || 'was invalidated on '
                || v_exp_rec.invalidated_on || ' by ' || v_exp_rec.invalidated_by || '.';
            v_adv_rec.submitted_on := sysdate;
            v_adv_rec.approved_by := v_my_name;
            v_adv_rec.approved_on := sysdate;
            v_adv_rec.issue_by := v_my_name;
            v_adv_rec.issue_on := sysdate;
            v_adv_rec.cash_amount := v_adv_rec.amount_requested;
            v_adv_rec.check_amount := 0;
            v_adv_rec.create_by := v_my_name;
            v_adv_rec.create_on := sysdate;
            v_adv_rec.modify_by := v_my_name;
            v_adv_rec.modify_on := sysdate;
            
            --- Get the CFUNDS_ADV Object Type SID and the ACL SID ---
            select t.sid,a.sid into v_obj_type_sid,v_acl_sid from t_core_obj_type t,t_core_acl a where t.code='CFUNDS_ADV' and a.obj_type=t.sid;
            
            --- Insert the Advance into T_CORE_OBJ, getting to SID back --- 
            insert into t_core_obj (obj_type,acl) values (v_obj_type_sid,v_acl_sid) returning SID into v_adv_rec.SID;
        
            insert into t_cfunds_advance_v2
                        (sid, 
                         voucher_no,
                         request_date,
                         unit,
                         amount_requested,
                         claimant,
                         narrative,
                         submitted_on,
                         approved_by,
                         approved_on,
                         issue_by,
                         issue_on,
                         cash_amount,
                         check_amount,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                 values (v_adv_rec.SID,
                         v_adv_rec.voucher_no,
                         v_adv_rec.request_date,
                         v_adv_rec.unit,
                         v_adv_rec.amount_requested,
                         v_adv_rec.claimant,
                         v_adv_rec.narrative,
                         v_adv_rec.submitted_on,
                         v_adv_rec.approved_by,
                         v_adv_rec.approved_on,
                         v_adv_rec.issue_by,
                         v_adv_rec.issue_on,
                         v_adv_rec.cash_amount,
                         v_adv_rec.check_amount,
                         v_adv_rec.create_by,
                         v_adv_rec.create_on,
                         v_adv_rec.modify_by,
                         v_adv_rec.modify_on)
              returning SID
                   into v_adv_rec.SID;
        end if;

        update t_cfunds_expense_v3
           set repaid_on = sysdate,
               repaid_voucher_no = v_exp_rec.repaid_voucher_no,
               repaid_cash_amount = nvl(pcash_amt, 0),
               repaid_check_amount = nvl(pcheck_amt, 0),
               repaid_check_number = pcheck_num,
               repaid_advance = v_adv_rec.SID,                                      -- might be null
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = pexpense;

        -- It is possible that an invalidated expense has already been
        -- reimbursed at one (or more levels). If so, the charge_to_unit
        -- has already received money for the invalid expense, and thus
        -- needs to forward any money collected from the agent to the
        -- unit that last reimbursed the expense. Therefore, a transfer
        -- should be created to record that transaction in the database.
        v_xfr_rec := null;

        for x in (select   a.sender
                      from t_cfunds_xfr a, t_cfunds_xfr_exp b
                     where b.xfr = a.SID and b.expense = pexpense
                  order by a.create_on desc)
        loop
            v_xfr_rec.voucher_no := get_voucher_num('X');

            insert into t_cfunds_xfr
                        (xfr_type,
                         voucher_no,
                         sender,
                         send_date,
                         receiver,
                         amount,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                 values ('DER',
                         v_xfr_rec.voucher_no,
                         v_exp_rec.charge_to_unit,
                         null,
                         x.sender,
                         v_exp_rec.total_amount_us,
                         v_my_name,
                         sysdate,
                         v_my_name,
                         sysdate)
              returning SID
                   into v_xfr_rec.SID;

            insert into t_cfunds_xfr_exp
                        (xfr, expense)
                 values (v_xfr_rec.SID, pexpense);

            exit;                                                       -- only need most recent one
        end loop;                                                                               -- x

        ppmt_voucher := v_exp_rec.repaid_voucher_no;
        padv_voucher := v_adv_rec.voucher_no;
        pxfr_voucher := v_xfr_rec.voucher_no;
    exception
        when others then
            rollback to savepoint one;
            raise;
    end repay_expense;

    procedure reimburse_expenses(
        preimbursing_unit   in       varchar2,
        psubmitting_unit    in       varchar2,
        pvoucher            out      varchar2,
        psend_date          in       date := sysdate,
        pfiscal_year        in       varchar2 := null) is
        v_xfr_sid             t_cfunds_xfr.SID%type;
        v_xfr_vno             t_cfunds_xfr.voucher_no%type;
        v_xfr_amt             t_cfunds_xfr.amount%type;
        v_nxt_rev             t_cfunds_xfr.sender%type;
        v_uo_lim_tot          number;
        v_child_lim           number;
        v_as_of_date          date;
        -- cutoff date for finding expenses to be reimbursed;
        -- allows us to reimburse expenses for past fiscal years
        -- seperately from current fiscal year.
        v_prior_fiscal_year   varchar2(10)                   := 'N';
    -- flag indicates if we are processing a prior FY.
    begin
        v_error_detail := null;
        pvoucher := null;
        savepoint one;
        v_my_name := core_context.personnel_name;

        if cfunds_test_cfp('EXP_INVALIDATE',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           preimbursing_unit) = 'N' then
            v_error_detail := 'You do not have privilege to reimburse these expenses.';
            raise no_privilege;
        end if;

        -- check to see which fiscal year we're dealing with.
        if pfiscal_year is null then
            v_as_of_date := sysdate;
        else
            if pfiscal_year = get_fiscal_year(sysdate) then
                v_as_of_date := sysdate;
            else
                -- test to be sure this is a past date, not a future date.
                if v_as_of_date >= sysdate then
                    v_as_of_date := sysdate;
                else
                    -- we have a previous fiscal year to process.
                    v_as_of_date := get_fiscal_year_end_date(pfiscal_year);
                    v_prior_fiscal_year := 'Y';
                end if;
            end if;
        end if;

        -- only test limitations if this is the current fiscal year.
        -- Limitations do not matter for prior fiscal year processes.
        if v_prior_fiscal_year = 'N' then
            v_uo_lim_tot :=
                           nvl(get_unit_limitation(preimbursing_unit, 'EXP', '%', v_as_of_date), 0);

            for u in (select SID
                        from v_cfunds_unit
                       where parent = preimbursing_unit)
            loop
                v_child_lim := get_unit_limitation(u.SID, 'OXT', '%', v_as_of_date);

                if v_child_lim is null then
                    v_child_lim := get_unit_limitation(u.SID, 'EXP', '%', v_as_of_date);
                end if;

                v_uo_lim_tot := v_uo_lim_tot + nvl(v_child_lim, 0);
            end loop;

            if v_uo_lim_tot <>
                            nvl(get_unit_limitation(preimbursing_unit, 'OXT', '%', v_as_of_date), 0) then
                v_error_detail :=
                    'You cannot reimburse expenses now because the '
                    || 'total expense limitation for the organization (' || v_uo_lim_tot || ') '
                    || 'is different than the target limitation ('
                    || nvl(get_unit_limitation(preimbursing_unit, 'OXT', '%', v_as_of_date), 0)
                    || '). The actual '
                    || '(or target) expense limitations for the subordinate units '
                    || '(or organizations) must be decreased.';
                raise bad_timing;
            end if;
        end if;

        -- Create a transfer
        -- Changed this per requirements for OSI to make these P type of transactions voucher numbers.
        v_xfr_vno := get_voucher_num('P');

        insert into t_cfunds_xfr
                    (xfr_type, voucher_no, sender, send_date, receiver, create_by, create_on)
             values ('ER',
                     v_xfr_vno,
                     preimbursing_unit,
                     psend_date,
                     psubmitting_unit,
                     v_my_name,
                     sysdate)
          returning SID
               into v_xfr_sid;

        v_nxt_rev := get_next_reviewing_unit(preimbursing_unit);
        v_xfr_amt := 0;

        for e in (select *
                    from v_cfunds_expense_v3
                   where status = 'Paid'
                     and reviewing_unit = preimbursing_unit
                     and (trunc(incurred_date) between get_fiscal_year_start_date(v_as_of_date)
                                                   and get_fiscal_year_end_date(v_as_of_date))
                     and (   (    nvl(reviewed, 'N') = 'Y'
                              and get_submitting_unit(preimbursing_unit, charge_to_unit) =
                                                                                    psubmitting_unit)
                          or (    preimbursing_unit = v_hq_cc_unit_sid
                              and
--NVL(REVIEWED,'N') = 'N' AND 1/14/09 JDB HQ cfunds mgrs keep reviewing their own expenses causing problems. changed routine to not care if it is or isn't reviewed.
                                  preimbursing_unit = charge_to_unit
                              and preimbursing_unit = psubmitting_unit)))
        -- the last part of this, where expenses are not reviewed, is for HQ expenses only.
        loop
            v_xfr_amt := v_xfr_amt + nvl(e.total_amount_us, 0);

            insert into t_cfunds_xfr_exp
                        (xfr, expense)
                 values (v_xfr_sid, e.SID);

            update t_cfunds_expense_v3
               set reviewing_unit = v_nxt_rev,
                   reviewed = 'N'
             where SID = e.SID;
        end loop;

        if v_xfr_amt = 0 then
            v_error_detail :=
                'No reimbursable expenses found for fiscal year ' || get_fiscal_year(v_as_of_date)
                || '.';
            raise bad_timing;
        end if;

        update t_cfunds_xfr
           set amount = v_xfr_amt,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = v_xfr_sid;

        pvoucher := v_xfr_vno;
    exception
        when others then
            rollback to savepoint one;
            raise;
    end reimburse_expenses;

    procedure pay_tfos_expense(
        pexpense     in   varchar2,
        pcash_amt    in   number,
        pcheck_amt   in   number,
        pcheck_num   in   varchar2) is
        v_ancestor_unit    t_osi_unit.SID%type;
        v_ancestor_count   number;
        v_transfer_count   number;
        v_cnt              number;
        v_ok_to_close      boolean;
    begin
        v_error_detail := null;
        savepoint one;
        load_expense(pexpense);
        v_my_name := core_context.personnel_name;

        if v_exp_rec.paid_on is null then
            v_error_detail := 'Expense has not yet been paid.';
            raise bad_timing;
        end if;

        if nvl(abs(v_exp_rec.take_from_other_sources), 0) = 0 then
            v_error_detail := 'This expense has not been paid from other sources.';
            raise invalid_parameters;
        else
            if round(pcheck_amt, 2) <> pcheck_amt then
                v_error_detail :=
                    'You may not specify more than 2 decimal places '
                    || 'for the check amount (cannot have fractional cents).';
                raise invalid_parameters;
            end if;

            if round(pcash_amt, 2) <> pcash_amt then
                v_error_detail :=
                    'You may not specify more than 2 decimal places '
                    || 'for the cash amount (cannot have fractional cents).';
                raise invalid_parameters;
            end if;

            if (nvl(pcash_amt, 0) + nvl(pcheck_amt, 0)) <> v_exp_rec.total_amount_us then
                v_error_detail := 'Cash and Check amounts do not total to expense amount.';
                raise invalid_parameters;
            end if;
        end if;

        if cfunds_test_cfp('EXP_PAY',
                           core_obj.lookup_objtype('CFUNDS_EXP'),
                           core_context.personnel_sid,
                           v_exp_rec.charge_to_unit) = 'N' then
            v_error_detail := 'You do not have privilege to pay this expense.';
            raise no_privilege;
        end if;

        -- Now we start the process of filling in the amount paid to the agent.
        v_exp_rec.tfos_cash_amount := nvl(pcash_amt, 0);
        v_exp_rec.tfos_check_amount := nvl(pcheck_amt, 0);
        v_exp_rec.tfos_check_number := pcheck_num;
        -- Next, we need to look to see if we should close this expense.

        -- If all required transfers for this expense exist and have
        -- been completed, then we should close it.
        v_ok_to_close := false;
        v_ancestor_unit := v_exp_rec.charge_to_unit;

        -- default to the originating unit
        while v_ancestor_unit is not null
        loop
            -- loop through ancestor units and find if there is a received transfer.
            v_ok_to_close := false;

            select count(*)
              into v_cnt
              from t_cfunds_xfr_exp a, t_cfunds_xfr b
             where a.expense = v_exp_rec.SID
               and b.SID = a.xfr
               and b.xfr_type = 'ER'
               and b.receiver = v_ancestor_unit
               and not b.receive_date is null;

            v_ancestor_unit := get_parent_unit(v_ancestor_unit);

            if v_cnt = 0 then
                -- transfer not received, cannot close, exit this loop.
                if v_ancestor_unit is null then
                    -- we were at the top level when we looked for a transfer, so a count
                    -- of 0 is expected because HQ doesn't receive transfers.
                    v_ok_to_close := true;
                end if;

                exit;
            end if;
        end loop;

        if v_ok_to_close = true then
            -- ok to close.
            v_exp_rec.closed_by := core_context.personnel_name;
            v_exp_rec.closed_on := sysdate;
        end if;

        -- Now, change the data in the database.
        update t_cfunds_expense_v3
           set tfos_by = v_my_name,
               tfos_on = sysdate,
               tfos_cash_amount = v_exp_rec.tfos_cash_amount,
               tfos_check_amount = v_exp_rec.tfos_check_amount,
               tfos_check_number = v_exp_rec.tfos_check_number,
               modify_by = v_my_name,
               modify_on = sysdate,
               closed_by = v_exp_rec.closed_by,
               closed_on = v_exp_rec.closed_on
         where SID = pexpense;
    exception
        when others then
            rollback to savepoint one;
            raise;
    end pay_tfos_expense;

-- Advance related routines
    function get_advance_status(
        psubmitted_on   in   date,
        papproved_on    in   date,
        prejected_on    in   date,
        pissue_on       in   date,
        pclose_date     in   date)
        return varchar2 is
    begin
        if pclose_date is not null then
            return 'Closed';
        end if;

        if pissue_on is not null then
            return 'Active';
        end if;

        if papproved_on is not null then
            return 'Approved';
        end if;

        if prejected_on is not null and prejected_on > psubmitted_on then
            return 'Disallowed';
        end if;

        if psubmitted_on is not null then
            return 'Submitted';
        end if;

        return 'New';
    end get_advance_status;

    function get_advance_total_available(pclaimant in varchar2, punit in varchar2)
        return number is
        v_rtn   number;
    begin
        select sum(nvl(check_amount, 0) + nvl(cash_amount, 0) - nvl(expensed_amount, 0)
                   - nvl(get_advance_total_repayments(SID), 0))
          into v_rtn
          from v_cfunds_advance_v2
         where claimant = pclaimant and unit = punit and status = 'Active';

        return nvl(v_rtn, 0);
    end get_advance_total_available;

    function get_advance_total_repayments(padvance in varchar2)
        return number is
        v_rtn   number;
    begin
        select sum(nvl(check_amount, 0) + nvl(cash_amount, 0))
          into v_rtn
          from t_cfunds_advance_repayment_v2
         where advance = padvance;

        return nvl(v_rtn, 0);
    end get_advance_total_repayments;

    procedure approve_advance(padvance in varchar2) is
    begin
        v_error_detail := null;
        load_advance(padvance);

        if v_adv_rec.submitted_on is null then
            v_error_detail := 'Advance has not yet been submitted for approval.';
            raise bad_timing;
        end if;

        if    nvl(v_adv_rec.approved_on, v_adv_rec.submitted_on - 1) > v_adv_rec.submitted_on
           or nvl(v_adv_rec.rejected_on, v_adv_rec.submitted_on - 1) > v_adv_rec.submitted_on then
            v_error_detail := 'Advance has already been approved (or rejected).';
            raise bad_timing;
        end if;

        if cfunds_test_cfp('APPROVE_CL',
                           core_obj.lookup_objtype('CFUNDS_ADV'),
                           core_context.personnel_sid,
                           v_adv_rec.unit) = 'N' then
            v_error_detail := 'You do not have privilege to approve this Advance.';
            raise no_privilege;
        end if;

        v_my_name := core_context.personnel_name;

        update t_cfunds_advance_v2
           set approved_by = v_my_name,
               approved_on = sysdate,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = padvance;
    end approve_advance;

    procedure approve_advance_for_apex(padvance in varchar2) is
    begin
        v_error_detail := null;
        load_advance(padvance);

        if v_adv_rec.submitted_on is null then
            v_error_detail := 'Advance has not yet been submitted for approval.';
            raise bad_timing;
        end if;

        if    nvl(v_adv_rec.approved_on, v_adv_rec.submitted_on - 1) > v_adv_rec.submitted_on
           or nvl(v_adv_rec.rejected_on, v_adv_rec.submitted_on - 1) > v_adv_rec.submitted_on then
            v_error_detail := 'Advance has already been approved (or rejected).';
            raise bad_timing;
        end if;

        if cfunds_test_cfp('APPROVE_CL',
                           core_obj.lookup_objtype('CFUNDS_ADV'),
                           core_context.personnel_sid,
                           v_adv_rec.unit) = 'N' then
            v_error_detail := 'You do not have privilege to approve this Advance.';
            raise no_privilege;
        end if;
/*
        v_my_name := core_context.personnel_name;

        update t_cfunds_advance_v2
           set approved_by = v_my_name,
               approved_on = sysdate,
               modify_by = v_my_name,
               modify_on = sysdate
         where sid = padvance;
*/
    end approve_advance_for_apex;

    procedure reject_advance(padvance in varchar2) is
    begin
        v_error_detail := null;
        load_advance(padvance);

        if v_adv_rec.submitted_on is null then
            v_error_detail := 'Advance has not yet been submitted for approval.';
            raise bad_timing;
        end if;

        if    v_adv_rec.approved_on is not null
           or v_adv_rec.rejected_on is not null then
            v_error_detail := 'Advance has already been approved (or rejected).';
            raise bad_timing;
        end if;

        if cfunds_test_cfp('APPROVE_CL',
                           core_obj.lookup_objtype('CFUNDS_ADV'),
                           core_context.personnel_sid,
                           v_adv_rec.unit) = 'N' then
            v_error_detail := 'You do not have privilege to reject this Advance.';
            raise no_privilege;
        end if;

        v_my_name := core_context.personnel_name;

        update t_cfunds_advance_v2
           set rejected_by = v_my_name,
               rejected_on = sysdate,
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = padvance;
    end reject_advance;

    procedure issue_advance(
        padvance          in       varchar2,
        pcash_amt         in       number,
        pcheck_amt        in       number,
        pcheck_num        in       varchar2,
        pcash_accepted    in       varchar2,
        pcheck_accepted   in       varchar2,
        pvoucher          out      varchar2) is
        v_voucher   t_cfunds_advance_v2.voucher_no%type;
    begin
        v_error_detail := null;
        load_advance(padvance);

        if v_adv_rec.approved_on is null then
            v_error_detail := 'Advance has not yet been approved.';
            raise bad_timing;
        end if;

        if v_adv_rec.issue_on is not null then
            v_error_detail := 'Advance has already been issued.';
            raise bad_timing;
        end if;

        if round(pcash_amt, 2) <> pcash_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the cash amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if round(pcheck_amt, 2) <> pcheck_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the check amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if nvl(pcash_amt, 0) + nvl(pcheck_amt, 0) <> v_adv_rec.amount_requested then
            v_error_detail := 'Cash and Check amounts do not total to requested amount.';
            raise invalid_parameters;
        end if;

        if cfunds_test_cfp('ADV_ISSUE',
                           core_obj.lookup_objtype('CFUNDS_ADV'),
                           core_context.personnel_sid,
                           v_adv_rec.unit) = 'N' then
            v_error_detail := 'You do not have privilege to issue this Advance.';
            raise no_privilege;
        end if;

        v_voucher := get_voucher_num('A', v_adv_rec.request_date);
        v_my_name := core_context.personnel_name;

        update t_cfunds_advance_v2
           set voucher_no = v_voucher,
               issue_by = v_my_name,
               issue_on = sysdate,
               cash_amount = nvl(pcash_amt, 0),
               check_amount = nvl(pcheck_amt, 0),
               check_number = pcheck_num,
               cash_accepted = upper(pcash_accepted),
               check_accepted = upper(pcheck_accepted),
               modify_by = v_my_name,
               modify_on = sysdate
         where SID = padvance;

        pvoucher := v_voucher;
    end issue_advance;

    procedure repay_advance(
        padvance     in       varchar2,
        pcash_amt    in       number,
        pcheck_amt   in       number,
        pvoucher     out      varchar2) is
        v_max_repay   number;
        v_voucher     t_cfunds_advance_repayment_v2.voucher_no%type;
    begin
        v_error_detail := null;
        savepoint one;
        v_my_name := core_context.personnel_name;

        -- LOCK TABLE T_CFUNDS_ADVANCE_V2, T_CFUNDS_ADVANCE_REPAYMENT_V2 IN EXCLUSIVE MODE;

        -- LOCK ONE ROW IN T_CFUNDS_ADVANCE_V2  21 SEP 2006 wc
        update t_cfunds_advance_v2
           set modify_on = modify_on
         where SID = padvance;

        load_advance(padvance);

        if v_adv_rec.status <> 'Active' then
            v_error_detail := 'Advance is not active - cannot enter repayment.';
            raise bad_timing;
        end if;

        if round(pcash_amt, 2) <> pcash_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the cash amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if round(pcheck_amt, 2) <> pcheck_amt then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the check amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        v_max_repay :=
            v_adv_rec.amount_requested - nvl(v_adv_rec.expensed_amount, 0)
            - nvl(get_advance_total_repayments(padvance), 0);

        if nvl(pcash_amt, 0) + nvl(pcheck_amt, 0) > v_max_repay then
            v_error_detail :=
                'Repayment is too much. ' || ltrim(to_char(v_max_repay, '$9,990.00'))
                || ' will close this advance.';
            raise invalid_parameters;
        end if;

        if cfunds_test_cfp('ADV_ENTER_REP',
                           core_obj.lookup_objtype('CFUNDS_ADV'),
                           core_context.personnel_sid,
                           v_adv_rec.unit) = 'N' then
            v_error_detail := 'You do not have privilege to enter a Repayment for this Advance.';
            raise no_privilege;
        end if;

        v_voucher := get_voucher_num('R');

        insert into t_cfunds_advance_repayment_v2
                    (advance,
                     voucher_no,
                     check_amount,
                     cash_amount,
                     receive_by,
                     receive_on,
                     create_by,
                     create_on,
                     modify_by,
                     modify_on)
             values (padvance,
                     v_voucher,
                     nvl(pcheck_amt, 0),
                     nvl(pcash_amt, 0),
                     v_my_name,
                     sysdate,
                     v_my_name,
                     sysdate,
                     v_my_name,
                     sysdate);

        if nvl(pcash_amt, 0) + nvl(pcheck_amt, 0) = v_max_repay then
            -- Close out this advance
            update t_cfunds_advance_v2
               set close_date = sysdate,
                   modify_by = v_my_name,
                   modify_on = sysdate
             where SID = padvance;
        end if;

        pvoucher := v_voucher;
    exception
        when others then
            rollback to savepoint one;
            raise;
    end repay_advance;

-- MFR related routines
    function get_mfr_status(
        psubmitted_on   in   date,
        papproved_on    in   date,
        prejected_on    in   date,
        pcompleted_on   in   date)
        return varchar2 is
    begin
        return 'Active';
    end get_mfr_status;

-- Create an Memo For Recored
    procedure create_mfr(
        pincurred_date    in       date,
        pcharge_to_unit   in       varchar2,
        pcomments         in       varchar2,
        pamount           in       number,
        psid              out      varchar2) is
        v_mfr_rec   t_cfunds_mfr%rowtype;
        v_my_name   varchar2(100);
    begin
        v_error_detail := null;

        -- check for all required fields being filled in.
        -- required fields are:.
        --     Claimant, Incurred_Date,
        --     charge_to_unit, category,
        --     conversion_rate, one of agent_amount or source_amount

        -- Incurred date is allowed to be in the future as long as its not
        -- past the last day of the current fiscal year.  This is ok until
        -- submittal, at which point the date cannot be in the future.
        if cfunds_test_cfp('CF_MFR_CRT',
                           core_obj.lookup_objtype('NONE'),
                           core_context.personnel_sid,
                           pcharge_to_unit) = 'N' then
            v_error_detail := 'You do not have privilege to create this MFR.';
            raise no_privilege;
        end if;

        if pincurred_date is null then
            v_error_detail := 'Please specify the Date of this MFR.';
            raise invalid_parameters;
        elsif cfunds_pkg.get_fiscal_year_end_date(pincurred_date) >
                                                        cfunds_pkg.get_fiscal_year_end_date(sysdate) then
            v_error_detail :=
                        'The date of this MFR cannot be beyond the end of the current fiscal year.';
            raise invalid_parameters;
        end if;

        if    pcharge_to_unit is null
           or pcharge_to_unit = ' ' then
            v_error_detail := 'There is no Unit for this MFR, an MFR must be charged to a Unit.';
            raise invalid_parameters;
        end if;

        if pcomments is null then
            v_error_detail := 'Please specify Comments for this MFR.';
            raise invalid_parameters;
        end if;

        v_my_name := core_context.personnel_name;
        v_mfr_rec.voucher_no := cfunds_pkg.get_voucher_num('M', pincurred_date);
        v_mfr_rec.incurred_date := pincurred_date;
        v_mfr_rec.unit := pcharge_to_unit;
        v_mfr_rec.comments := pcomments;
        v_mfr_rec.amount := pamount;
        v_mfr_rec.create_by := v_my_name;
        v_mfr_rec.create_on := sysdate;
        v_mfr_rec.modify_by := v_my_name;
        v_mfr_rec.modify_on := sysdate;
        v_mfr_rec.submitted_by := v_my_name;
        v_mfr_rec.submitted_on := sysdate;

        insert into t_cfunds_mfr
                    (voucher_no,
                     incurred_date,
                     unit,
                     comments,
                     amount,
                     create_by,
                     create_on,
                     modify_by,
                     modify_on,
                     submitted_by,
                     submitted_on)
             values (v_mfr_rec.voucher_no,
                     v_mfr_rec.incurred_date,
                     v_mfr_rec.unit,
                     v_mfr_rec.comments,
                     v_mfr_rec.amount,
                     v_mfr_rec.create_by,
                     v_mfr_rec.create_on,
                     v_mfr_rec.modify_by,
                     v_mfr_rec.modify_on,
                     v_mfr_rec.submitted_by,
                     v_mfr_rec.submitted_on)
          returning SID
               into v_mfr_rec.SID;

        psid := v_mfr_rec.SID;
    end create_mfr;

-- Reconciliation related routines
    procedure reconcile(punit in varchar2, pbalance in number, pcomment in varchar2) is
    begin
        v_error_detail := null;
        savepoint one;
        v_my_name := core_context.personnel_name;

        if pbalance < 0 then
            v_error_detail :=
                          'Account balance is negative. ' || 'Cannot reconcile a negative account.';
            raise invalid_parameters;
        end if;

        insert into t_cfunds_reconciliation
                    (unit, recon_balance, recon_comment, recon_by, recon_on)
             values (punit, pbalance, pcomment, v_my_name, sysdate);
    exception
        when others then
            rollback to savepoint one;
            raise;
    end reconcile;

-- Transfer related routines
    function get_transfer_status(psend_date in date, preceive_date in date)
        return varchar2 is
    begin
        if psend_date is null then
            return 'Send Pending';
        end if;

        if preceive_date is null then
            return 'Sent';
        end if;

        return 'Received';
    end get_transfer_status;

    procedure send_working_funds(
        pfrom_unit   in       varchar2,
        pto_unit     in       varchar2,
        pamount      in       number,
        pvoucher     out      varchar2,
        psend_date   in       date := sysdate) is
        v_from_unit         t_cfunds_xfr.sender%type;
        v_vno               t_cfunds_xfr.voucher_no%type;
        v_from_wf_balance   number                         := 0;
    begin
        v_error_detail := null;
        v_my_name := core_context.personnel_name;
        v_from_unit := nvl(pfrom_unit, get_my_cfunds_unit);

        if pto_unit is null then
            v_error_detail := 'You must specify a receiving Unit.';
            raise invalid_parameters;
        end if;

        if nvl(pamount, 0) <= 0 then
            v_error_detail := 'You must specify a positive amount to transfer.';
            raise invalid_parameters;
        end if;

        if round(pamount, 2) <> pamount then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        v_from_wf_balance := nvl(get_unit_wf_balance(v_from_unit), 0);
        core_logger.log_it(c_pipe,
                           'working funds balance for SENDING unit ' || v_from_unit || ' is '
                           || v_from_wf_balance);

        if v_from_wf_balance < pamount then
            v_error_detail :=
                'The sending unit does not have enough Working Funds.'
                || ' The maximum amount that can be sent by this unit is '
                || to_char(v_from_wf_balance, v_dollar_format) || '.';
            raise invalid_parameters;
        end if;

        if v_from_unit = pto_unit then                                                 -- must be HQ
            if lookup_cfunds_unit(v_from_unit).unit_parent is not null then
                v_error_detail := 'The sending and receiving unit must be different.';
                raise invalid_parameters;
            end if;
        end if;

        if     get_next_reviewing_unit(v_from_unit) <> pto_unit
           and get_next_reviewing_unit(pto_unit) <> v_from_unit then
            v_error_detail :=
                           'Transfers must include 1 region or HQ as either the sender or receiver';
            raise invalid_parameters;
        end if;

        if cfunds_test_cfp('CF_XFR_SWF',
                           core_obj.lookup_objtype('NONE'),
                           core_context.personnel_sid,
                           v_from_unit) = 'N' then                                              --OR
            v_error_detail :=
                'You do not have privilege to send working funds '
                || 'between the specified units.';
            raise no_privilege;
        end if;

        v_vno := get_voucher_num('X');

        insert into t_cfunds_xfr
                    (xfr_type,
                     voucher_no,
                     sender,
                     send_date,
                     receiver,
                     amount,
                     create_by,
                     create_on,
                     modify_by,
                     modify_on)
             values ('WF',
                     v_vno,
                     v_from_unit,
                     psend_date,
                     pto_unit,
                     pamount,
                     v_my_name,
                     sysdate,
                     v_my_name,
                     sysdate);

        pvoucher := v_vno;
    end send_working_funds;

    procedure receive_working_funds(pxfr in varchar2) is
        v_cnt   number;
    begin
        savepoint one;
        v_error_detail := null;
        load_transfer(pxfr);

        if v_xfr_rec.receive_date is not null then
            v_error_detail := 'This transfer has already been received.';
            raise bad_timing;
        end if;

        if cfunds_test_cfp('CF_XFR_RWF',
                           core_obj.lookup_objtype('NONE'),
                           core_context.personnel_sid,
                           v_xfr_rec.receiver) = 'N' then
            v_error_detail :=
                      'You do not have privilege to receive working funds into the receiving unit.';
            raise no_privilege;
        end if;

        update t_cfunds_xfr
           set receive_date = sysdate,
               modify_by = core_context.personnel_name,
               modify_on = sysdate
         where SID = pxfr;

        -- Check each expense associated with this transfer. If there is no
        -- REVIEWING_UNIT, the expense might need to be closed. Determine this
        -- by verifying that ALL transfers that touch that expense have been
        -- received.
        for xe in (select a.expense, b.take_from_other_sources, b.tfos_on
                     from t_cfunds_xfr_exp a, t_cfunds_expense_v3 b
                    where a.xfr = pxfr and b.SID = a.expense and b.reviewing_unit is null)
        loop
            -- Have a candidate expense, so check all transfers
            select count(*)
              into v_cnt
              from t_cfunds_xfr_exp a, t_cfunds_xfr b
             where a.expense = xe.expense and b.SID = a.xfr and b.receive_date is null;

            if v_cnt = 0 then
                -- close the expense
                -- only if it is not marked Take From Other Sources.
                update t_cfunds_expense_v3
                   set closed_by = core_context.personnel_name,
                       closed_on = sysdate
                 where SID = xe.expense;
            end if;
        end loop;
    exception
        when others then
            rollback to savepoint one;
            raise;
    end receive_working_funds;

-- move this to the Cfunds_Pkg. -- you will need to make changes
-- to the error handling.
    procedure create_dfo(
        pdate      in       date,
        punit      in       varchar2,
        pdfotype   in       varchar2,
        pamount    in       number,
        psid       out      varchar2) is
        v_dfo_rec   t_cfunds_xfr%rowtype;
        v_my_name   varchar2(100);
    begin
        if cfunds_test_cfp('CF_XFR_DFO',
                           core_obj.lookup_objtype('NONE'),
                           core_context.personnel_sid,
                           punit) = 'N' then
            v_error_detail := 'You do not have privilege to create this DFO.';
            raise no_privilege;
        end if;

        if punit is null then
            v_error_detail := 'Unit must be specified for this DFO.';
            raise invalid_parameters;
        end if;

        if    (pamount is null)
           or (pamount <= 0) then
            v_error_detail := 'Please specify an amount for this DFO.';
            raise invalid_parameters;
        end if;

        if cfunds_pkg.get_fiscal_year(pdate) <> cfunds_pkg.get_fiscal_year(sysdate) then
            v_error_detail := 'You cannot specify a DFO outside the current fiscal year.';
            raise invalid_parameters;
        end if;

        if pdfotype is null then
            v_error_detail := 'Please select the type of DFO transfer';
            raise invalid_parameters;
        end if;

        v_my_name := core_context.personnel_name;
        v_dfo_rec.xfr_type := pdfotype;
        v_dfo_rec.voucher_no := cfunds_pkg.get_voucher_num('D', pdate);
        v_dfo_rec.sender := punit;
        v_dfo_rec.send_date := pdate;
        v_dfo_rec.receive_date := pdate;
        v_dfo_rec.receiver := punit;
        v_dfo_rec.amount := pamount;
        v_dfo_rec.create_by := v_my_name;
        v_dfo_rec.create_on := sysdate;
        v_dfo_rec.modify_by := v_my_name;
        v_dfo_rec.modify_on := sysdate;

        insert into t_cfunds_xfr
                    (xfr_type,
                     voucher_no,
                     sender,
                     send_date,
                     receive_date,
                     receiver,
                     amount,
                     create_by,
                     create_on,
                     modify_by,
                     modify_on)
             values (v_dfo_rec.xfr_type,
                     v_dfo_rec.voucher_no,
                     v_dfo_rec.sender,
                     v_dfo_rec.send_date,
                     v_dfo_rec.receive_date,
                     v_dfo_rec.receiver,
                     v_dfo_rec.amount,
                     v_dfo_rec.create_by,
                     v_dfo_rec.create_on,
                     v_dfo_rec.modify_by,
                     v_dfo_rec.modify_on)
          returning SID
               into v_dfo_rec.SID;

        psid := v_dfo_rec.SID;
    end create_dfo;

-- Unit related routines
    procedure create_cfunds_unit(punit in varchar2) is
    begin
        v_error_detail := null;

        if lookup_cfunds_unit(punit).SID is null then
            -- ok to create a new one.
            insert into t_cfunds_unit
                        (SID, create_by, create_on)
                 values (punit, core_context.personnel_name, sysdate);
        else
            -- error, this unit already exists.
            v_error_detail := 'This unit is already a C-Funds unit.';
            raise bad_timing;
        end if;
    end create_cfunds_unit;

    function get_cfunds_unit(
        punit           in   varchar2,
        previewer       in   varchar2 := '-',
        pinclude_self   in   varchar2 := 'Y')
        return varchar2 is
    begin
        for u in (select     SID, unit_code, unit_parent
                        from t_osi_unit
                       where cfunds_pkg.get_unit_participation(SID, previewer) = 'Y'
                  connect by SID = prior unit_parent
                  start with SID = punit)
        loop
            if    upper(nvl(pinclude_self, 'Y')) = 'Y'
               or u.SID <> punit then
                core_logger.log_it(c_pipe, 'cfunds unit for unit ' || punit || ' is ' || u.SID);
                return u.SID;
            end if;
        end loop;

        core_logger.log_it(c_pipe, 'cfunds unit for unit ' || punit || ' is null');
        return null;
    end get_cfunds_unit;

    function get_my_cfunds_unit
        return varchar2 is
        v_unit   varchar2(20);
    begin
        v_unit := get_cfunds_unit(osi_personnel.get_current_unit(core_context.personnel_sid));

        if v_unit is null then
            core_logger.log_it(c_pipe,
                               'get_my_cfunds_unit returned null for personnel '
                               || nvl(core_context.personnel_sid, 'null'));
        end if;

        return v_unit;
    end get_my_cfunds_unit;

    function get_next_reviewing_unit(punit in varchar2)
        return varchar2 is
    begin
        return get_cfunds_unit(punit, 'Y', 'N');
    end get_next_reviewing_unit;

    function get_parent_unit(punit in varchar2)
        return varchar2 is
    begin
        return get_cfunds_unit(punit, '-', 'N');
    end get_parent_unit;

    function get_submitting_unit(previewing_unit in varchar2, pcreating_unit in varchar2)
        return varchar2 is
        v_rtn   varchar2(100);
    begin
        if    previewing_unit is null
           or pcreating_unit is null then
            return null;
        end if;

        for u in (select     SID, unit_code, unit_parent
                        from t_osi_unit
                       where cfunds_pkg.get_unit_participation(SID) = 'Y'
                  connect by SID = prior unit_parent
                  start with SID = pcreating_unit)
        loop
            exit when u.SID = previewing_unit;

            if    u.SID = pcreating_unit
               or cfunds_pkg.get_unit_participation(u.SID, 'Y') = 'Y' then
                v_rtn := u.SID;
            end if;
        end loop;

        return v_rtn;
    end get_submitting_unit;

    function get_unit_accountability(punit in varchar2)
        return number is
        v_bal   number := 0;
    begin
        for x in (select *
                    from t_cfunds_xfr
                   where xfr_type = 'WF'
                     and send_date is not null
                     and receive_date is not null
                     and (   receiver = punit
                          or sender = punit))
        loop
            if     x.receiver = punit
               and (   get_accountable_parent(x.sender) <> x.receiver
                    or x.sender = v_hq_cc_unit_sid)--'1010005M')
                                             /* and x.RECEIVE_DATE is not null */
            then
                v_bal := v_bal + nvl(x.amount, 0);
            end if;

            if     x.sender = punit
               /* and x.SEND_DATE is not null */
               and x.sender <> x.receiver
               and (   get_accountable_parent(x.receiver) <> x.sender
                    or x.receiver = v_hq_cc_unit_sid) then --'1010005M') then
                v_bal := v_bal - nvl(x.amount, 0);
            end if;
        end loop;

        return v_bal;
    end get_unit_accountability;

    function get_unit_annual_expenses(punit in varchar2, ppec in varchar2, ptest_date in date)
        return number is
        v_rtn   number := 0;
    begin
        for e in (select total_amount_us, category
                    from v_cfunds_expense_v3
                   where charge_to_unit = punit
                     and pec like ppec
                     and approved_on is not null
                     and trunc(incurred_date) between get_fiscal_year_start_date(ptest_date)
                                                  and get_fiscal_year_end_date(ptest_date)
                     and repaid_on is null)
        loop
            if get_cat_cnts_against_limits(e.category) then
                v_rtn := v_rtn + nvl(e.total_amount_us, 0);
            end if;
        end loop;

        if v_rtn = 0 then
            v_rtn := null;
        end if;

        return v_rtn;
    end get_unit_annual_expenses;

    function get_unitorg_annual_expenses(punit in varchar2, ppec in varchar2, ptest_date in date)
        return number is
        v_rtn   number := 0;
    begin
        for u in (select     SID
                        from t_osi_unit
                       where cfunds_pkg.get_unit_participation(SID) = 'Y'
                  connect by unit_parent = prior SID
                  start with SID = punit)
        loop
            v_rtn := v_rtn + nvl(get_unit_annual_expenses(u.SID, ppec, ptest_date), 0);
        end loop;

        if v_rtn = 0 then
            return null;
        else
            return v_rtn;
        end if;
    end get_unitorg_annual_expenses;

    function get_unit_limitation(
        punit        in   varchar2,
        plim_type    in   varchar2,
        ppec         in   varchar2,
        pasof_date   in   date)
        return number is
        v_rtn   number := 0;
    begin
        for p in (select distinct pec
                             from t_cfunds_limitation
                            where unit = punit
                              and lim_type = plim_type
                              and nvl(pec, 'x') like nvl(ppec, 'x')
                              and effective_date <= nvl(pasof_date, sysdate))
        loop
            for l in (select   amount
                          from t_cfunds_limitation
                         where unit = punit
                           and lim_type = plim_type
                           and nvl(pec, 'x') like nvl(p.pec, 'x')
                           and effective_date <= nvl(pasof_date, sysdate)
                      order by create_on desc)
            loop
                v_rtn := v_rtn + nvl(l.amount, 0);
                exit;                                        -- only want most recent lim for a PEC
            end loop;
        end loop;

        if v_rtn = 0 then
            return null;
        else
            return v_rtn;
        end if;
    end get_unit_limitation;

    function get_unitorg_limitation(
        punit        in   varchar2,
        plim_type    in   varchar2,
        ppec         in   varchar2,
        pasof_date   in   date)
        return number is
        v_rtn   number := 0;
    begin
        for u in (select     SID
                        from t_osi_unit
                       where cfunds_pkg.get_unit_participation(SID) = 'Y'
                  connect by unit_parent = prior SID
                  start with SID = punit)
        loop
            v_rtn := v_rtn + nvl(get_unit_limitation(u.SID, plim_type, ppec, pasof_date), 0);
        end loop;

        if v_rtn = 0 then
            return null;
        else
            return v_rtn;
        end if;
    end get_unitorg_limitation;

    function get_unit_os_balance(punit in varchar2)
        return number is
        v_bal          number;
        v_since_date   date;
    begin
        -- Initialize variables
        v_bal := 0;
        v_since_date := sysdate -(2 * get_reconcile_threshold);

        -- early limit

        -- Process additions and subtractions from various transactions
        for e in (select e.*, x.receive_date
                    from t_cfunds_expense_v3 e, t_cfunds_xfr_exp xe, t_cfunds_xfr x
                   where e.charge_to_unit = punit
                     and e.paid_on > v_since_date
                     and xe.expense(+) = e.SID
                     and x.SID(+) = xe.xfr
                     and x.receiver(+) = punit)
        loop
            if e.receive_date is null then
                v_bal :=
                    v_bal + nvl(e.paid_cash_amount, 0) + nvl(e.paid_check_amount, 0)
                    - nvl(e.repaid_cash_amount, 0) - nvl(e.repaid_check_amount, 0);
            end if;
        end loop;

        for a in (select *
                    from t_cfunds_advance_v2
                   where unit = punit and issue_on > v_since_date and close_date is null)
        loop
            v_bal := v_bal + nvl(a.cash_amount, 0) + nvl(a.check_amount, 0);
        end loop;

        for r in (select ar.*
                    from t_cfunds_advance_repayment_v2 ar, t_cfunds_advance_v2 a
                   where a.SID = ar.advance
                     and a.unit = punit
                     and ar.receive_on > v_since_date
                     and a.close_date is null)
        loop
            v_bal := v_bal - nvl(r.cash_amount, 0) - nvl(r.check_amount, 0);
        end loop;

        return v_bal;
    exception
        when no_data_found then
            core_logger.log_it(c_pipe,
                               'CFunds_Pkg.Get_Unit_OS_Balance: NO_DATA_FOUND (looking up Unit)');
            return null;
        when others then
            core_logger.log_it(c_pipe, 'CFunds_Pkg.Get_Unit_OS_Balance: Error: ' || sqlerrm);
            return null;
    end get_unit_os_balance;

    function get_unit_participation(punit in varchar2, previewer in varchar2 := 'N')
        return varchar2 is                                                             -- 'Y' or 'N'
        v_rev   t_cfunds_unit.reviewing_unit%type;
    begin
        select reviewing_unit
          into v_rev
          from t_cfunds_unit
         where SID = punit and active = 'Y';

        if upper(previewer) = 'Y' then
            return v_rev;
        else
            return 'Y';
        end if;
    exception
        when no_data_found then
            return 'N';
    end get_unit_participation;

    function get_unit_wf_balance(
        punit           in   varchar2,
        pcleared_only   in   boolean := false,
        pasof           in   date := sysdate)
        return number is
        v_bal           number;
        v_since_date    date;
        v_pay_from_wf   varchar2(1);
        v_asof_date     date;
    -- the 'As of' date is any date.  It can include the time.  But if only a date is
    -- sent in, the timestamp will be '00:00', which is midnight of the As Of date.
    -- So if you want all transactions for 30-Sep-2004, you would pass in 01-Oct-2004.
    begin
        -- Get last recon balance and date (if any)
        select nvl(recon_balance, 0), nvl(recon_on - v_recon_threshold, '01-Jan-1990'),
               nvl(pay_from_wf, 'Y')
          into v_bal, v_since_date,
               v_pay_from_wf
          from t_cfunds_unit
         where SID = punit;

        v_asof_date := pasof;

        -- Process additions and subtractions from various transactions

        -- incoming transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = punit
                          and (   xfr_type = 'ER'
                               or xfr_type = 'DER'
                               or xfr_type = 'WF')
                          and receive_date > v_since_date
                          and receive_date < v_asof_date
                          and nvl(receive_cleared, '-') <> 'r'))
        loop
            if x.receiver = punit then
                if    nvl(x.receive_cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal + nvl(x.amount, 0);
                end if;
            end if;
        end loop;

        -- outgoing transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    sender = punit
                          and (   xfr_type = 'ER'
                               or xfr_type = 'DER'
                               or xfr_type = 'WF')
                          and send_date > v_since_date
                          and send_date < v_asof_date
                          and nvl(send_cleared, '-') <> 'r'))
        loop
            if     x.sender = punit
               and (   v_pay_from_wf = 'Y'
                    or x.xfr_type <> 'ER')
               and x.sender <> x.receiver then
                if    nvl(x.send_cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal - nvl(x.amount, 0);
                end if;
            end if;
        end loop;

        -- incomming and outgoing dfo transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = punit
                          and (   xfr_type = 'DFOA'
                               or xfr_type = 'DFOR')
                          and receive_date > v_since_date
                          and receive_date < v_asof_date))
        loop
            if x.xfr_type = 'DFOA' then
                v_bal := v_bal + nvl(x.amount, 0);
            elsif x.xfr_type = 'DFOR' then
                v_bal := v_bal - nvl(x.amount, 0);
            end if;
        end loop;

        for e in (select *
                    from t_cfunds_expense_v3
                   where charge_to_unit = punit and paid_on > v_since_date and paid_on < v_asof_date)
        loop
            if nvl(e.cleared, '-') <> 'r' then
                v_bal := v_bal - nvl(e.paid_cash_amount, 0);

                -- cash amounts always considered cleared
                if    nvl(e.cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal - nvl(e.paid_check_amount, 0);
                end if;
            end if;
        end loop;

        for e in (select *
                    from t_cfunds_expense_v3
                   where charge_to_unit = punit
                     and repaid_on > v_since_date
                     and repaid_on < v_asof_date)
        loop
            if e.repaid_on > v_since_date and nvl(e.repaid_cleared, '-') <> 'r' then
                -- Add in the total amount of the expense MINUS any
                -- Check amount. This may be different than the
                -- actual Cash amount of the repayment, but that
                -- cash difference will be accounted for by the
                -- advance processing below (which treats an expense
                -- repayment advance just like any other advance).
                v_bal :=
                    round((v_bal + nvl(e.source_amount / nvl(e.conversion_rate, 1), 0)
                           + nvl(e.agent_amount / nvl(e.conversion_rate, 1), 0)
                           - nvl(e.repaid_check_amount, 0)),
                          2);

                if    nvl(e.repaid_cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal + nvl(e.repaid_check_amount, 0);
                end if;
            end if;
        end loop;

        for a in (select *
                    from t_cfunds_advance_v2
                   where unit = punit
                     and issue_on > v_since_date
                     and issue_on < v_asof_date
                     and nvl(cleared, '-') <> 'r')
        loop
            v_bal := v_bal - nvl(a.cash_amount, 0);

            if    nvl(a.cleared, '-') = 'c'
               or not pcleared_only then
                v_bal := v_bal - nvl(a.check_amount, 0);
            end if;
        end loop;

        for r in (select ar.*
                    from t_cfunds_advance_repayment_v2 ar, t_cfunds_advance_v2 a
                   where a.SID = ar.advance
                     and a.unit = punit
                     and ar.receive_on > v_since_date
                     and ar.receive_on < v_asof_date
                     and nvl(ar.cleared, '-') <> 'r')
        loop
            v_bal := v_bal + nvl(r.cash_amount, 0);

            if    nvl(r.cleared, '-') = 'c'
               or not pcleared_only then
                v_bal := v_bal + nvl(r.check_amount, 0);
            end if;
        end loop;

        -- incoming and outgoing end of year dfo transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    (   receiver = punit
                               or sender = punit)
                          and xfr_type = 'DFOTF'
                          and send_date > v_since_date
                          and send_date < v_asof_date + 1))
        loop
            core_logger.log_it(c_pipe, 'Cfunds_Pkg.getbalance dfo ' || x.amount);

            if x.sender = punit then
                v_bal := v_bal - nvl(x.amount, 0);
            elsif x.receiver = punit then
                v_bal := v_bal + nvl(x.amount, 0);
            end if;
        end loop;

        -- incoming end of year WF transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = punit
                          and xfr_type = 'WFAF'
                          and send_date > v_since_date
                          and send_date < v_asof_date + 1))
        loop
            core_logger.log_it(c_pipe, 'Cfunds_Pkg.getbalance incoming WFAF ' || x.amount);
            v_bal := v_bal + nvl(x.amount, 0);
        end loop;

        -- outgoing end of year WF transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    sender = punit
                          and xfr_type = 'WFAF'
                          and send_date > v_since_date
                          and send_date < v_asof_date + 1))
        loop
            v_bal := v_bal - nvl(x.amount, 0);
            core_logger.log_it(c_pipe, 'Cfunds_Pkg.getbalance Outgoing WFAF ' || x.amount);
        end loop;

        return v_bal;
    exception
        when no_data_found then
            core_logger.log_it(c_pipe,
                               'CFunds_Pkg.Get_Unit_WF_Balance: NO_DATA_FOUND (looking up Unit)');
            return null;
        when others then
            core_logger.log_it(c_pipe, 'CFunds_Pkg.Get_Unit_WF_Balance: Error: ' || sqlerrm);
            return null;
    end get_unit_wf_balance;

    function get_unit_wfaf_balance(
        punit           in   varchar2,
        pcleared_only   in   boolean := false,
        pasof           in   date := sysdate)
        return number is
        v_bal           number;
        v_since_date    date;
        v_pay_from_wf   varchar2(1);
        v_asof_date     date;
    -- the 'As of' date is any date.  It can include the time.  But if only a date is
    -- sent in, the timestamp will be '00:00', which is midnight of the As Of date.
    -- So if you want all transactions for 30-Sep-2004, you would pass in 01-Oct-2004.
    begin
        -- Get last recon balance and date (if any)
        select nvl(recon_balance, 0), nvl(recon_on - v_recon_threshold, '01-Jan-1990'),
               nvl(pay_from_wf, 'Y')
          into v_bal, v_since_date,
               v_pay_from_wf
          from t_cfunds_unit
         where SID = punit;

        v_asof_date := pasof;

        -- Process additions and subtractions from various transactions

        -- incoming transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = punit
                          and (   xfr_type = 'ER'
                               or xfr_type = 'DER'
                               or xfr_type = 'WF')
                          and receive_date > v_since_date
                          and receive_date < v_asof_date
                          and nvl(receive_cleared, '-') <> 'r'))
        loop
            if x.receiver = punit then
                if    nvl(x.receive_cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal + nvl(x.amount, 0);
                end if;
            end if;
        end loop;

        -- outgoing transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    sender = punit
                          and (   xfr_type = 'ER'
                               or xfr_type = 'DER'
                               or xfr_type = 'WF')
                          and receive_date > v_since_date
                          and receive_date < v_asof_date
                          and nvl(receive_cleared, '-') <> 'r'))
        loop
            if     x.sender = punit
               and (   v_pay_from_wf = 'Y'
                    or x.xfr_type <> 'ER')
               and x.sender <> x.receiver then
                if    nvl(x.send_cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal - nvl(x.amount, 0);
                end if;
            end if;
        end loop;

        -- incoming and outgoing dfo transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = punit
                          and (   xfr_type = 'DFOA'
                               or xfr_type = 'DFOR')
                          and receive_date > v_since_date
                          and receive_date < v_asof_date))
        loop
            if x.xfr_type = 'DFOA' then
                v_bal := v_bal + nvl(x.amount, 0);
            elsif x.xfr_type = 'DFOR' then
                v_bal := v_bal - nvl(x.amount, 0);
            end if;
        end loop;

        for e in (select *
                    from t_cfunds_expense_v3
                   where charge_to_unit = punit and paid_on > v_since_date and paid_on < v_asof_date)
        loop
            if nvl(e.cleared, '-') <> 'r' then
                v_bal := v_bal - nvl(e.paid_cash_amount, 0);

                -- cash amounts always considered cleared
                if    nvl(e.cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal - nvl(e.paid_check_amount, 0);
                end if;
            end if;
        end loop;

        for e in (select *
                    from t_cfunds_expense_v3
                   where charge_to_unit = punit
                     and repaid_on > v_since_date
                     and repaid_on < v_asof_date)
        loop
            if e.repaid_on > v_since_date and nvl(e.repaid_cleared, '-') <> 'r' then
                -- Add in the total amount of the expense MINUS any
                -- Check amount. This may be different than the
                -- actual Cash amount of the repayment, but that
                -- cash difference will be accounted for by the
                -- advance processing below (which treats an expense
                -- repayment advance just like any other advance).
                v_bal :=
                    round((v_bal + nvl(e.source_amount / nvl(e.conversion_rate, 1), 0)
                           + nvl(e.agent_amount / nvl(e.conversion_rate, 1), 0)
                           - nvl(e.repaid_check_amount, 0)),
                          2);

                if    nvl(e.repaid_cleared, '-') = 'c'
                   or not pcleared_only then
                    v_bal := v_bal + nvl(e.repaid_check_amount, 0);
                end if;
            end if;
        end loop;

        for a in (select *
                    from t_cfunds_advance_v2
                   where unit = punit
                     and issue_on > v_since_date
                     and issue_on < v_asof_date
                     and nvl(cleared, '-') <> 'r')
        loop
            v_bal := v_bal - nvl(a.cash_amount, 0);

            if    nvl(a.cleared, '-') = 'c'
               or not pcleared_only then
                v_bal := v_bal - nvl(a.check_amount, 0);
            end if;
        end loop;

        for r in (select ar.*
                    from t_cfunds_advance_repayment_v2 ar, t_cfunds_advance_v2 a
                   where a.SID = ar.advance
                     and a.unit = punit
                     and ar.receive_on > v_since_date
                     and ar.receive_on < v_asof_date
                     and nvl(ar.cleared, '-') <> 'r')
        loop
            v_bal := v_bal + nvl(r.cash_amount, 0);

            if    nvl(r.cleared, '-') = 'c'
               or not pcleared_only then
                v_bal := v_bal + nvl(r.check_amount, 0);
            end if;
        end loop;

        -- incoming and outgoing end of year dfo transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    (   receiver = punit
                               or sender = punit)
                          and xfr_type = 'DFOTF'
                          and send_date > v_since_date
                          and send_date < v_asof_date + 1))
        loop
            core_logger.log_it(c_pipe, 'Cfunds_Pkg.getbalance dfo ' || x.amount);

            if x.sender = punit then
                v_bal := v_bal - nvl(x.amount, 0);
            elsif x.receiver = punit then
                v_bal := v_bal + nvl(x.amount, 0);
            end if;
        end loop;

        -- incoming end of year WF transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = punit
                          and xfr_type = 'WFAF'
                          and send_date > v_since_date
                          and send_date < v_asof_date + 1))
        loop
            core_logger.log_it(c_pipe, 'Cfunds_Pkg.getbalance incoming WFAF ' || x.amount);
            v_bal := v_bal + nvl(x.amount, 0);
        end loop;

        -- outgoing end of year WF transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    sender = punit
                          and xfr_type = 'WFAF'
                          and send_date > v_since_date
                          and send_date < v_asof_date + 1))
        loop
            v_bal := v_bal - nvl(x.amount, 0);
            core_logger.log_it(c_pipe, 'Cfunds_Pkg.getbalance Outgoing WFAF ' || x.amount);
        end loop;

        return v_bal;
    exception
        when no_data_found then
            core_logger.log_it(c_pipe,
                               'CFunds_Pkg.Get_Unit_WF_Balance: NO_DATA_FOUND (looking up Unit)');
            return null;
        when others then
            core_logger.log_it(c_pipe, 'CFunds_Pkg.Get_Unit_WF_Balance: Error: ' || sqlerrm);
            return null;
    end get_unit_wfaf_balance;

    function get_unitorg_wf_balance(punit in varchar2, pcleared_only in boolean := false)
        return number is
        v_rtn   number := 0;
    begin
        for u in (select     SID
                        from t_osi_unit
                       where cfunds_pkg.get_unit_participation(SID) = 'Y'
                  connect by unit_parent = prior SID
                  start with SID = punit)
        loop
            v_rtn := v_rtn + nvl(get_unit_wf_balance(u.SID, pcleared_only), 0);
        end loop;

        if v_rtn = 0 then
            return null;
        else
            return v_rtn;
        end if;
    end get_unitorg_wf_balance;

    function lookup_cfunds_unit(punit in varchar2)
        return unit_info_rec is
    begin
        for u in (select u.SID, u.unit_code, osi_unit.get_name(u.SID) unit_name, u.unit_parent,
                         cu.reviewing_unit, cu.pay_from_wf, cu.eft_aba, cu.eft_dan,
                         cu.eft_acct_desc
                    from t_osi_unit u, t_cfunds_unit cu
                   where cu.SID = u.SID
                     and (   u.SID = punit
                          or u.unit_code = punit
                          or osi_unit.get_name(u.SID) = punit))
        loop
            return u;                                                    -- return first (only) row
        end loop;

        return null;                                                   -- nothing found, return null
    end lookup_cfunds_unit;

    procedure set_exp_limitation(
        porgunit      in   varchar2,
        punit_array   in   str_arr,
        plim_array    in   num_arr,
        ppec          in   varchar2,
        pcomments     in   varchar2,
        peff_date     in   date := sysdate) is
        v_cnt     number;
        v_ucode   v_cfunds_unit.unit_code%type;
        v_uname   v_cfunds_unit.unit_name%type;
        v_uexp    number;
        v_oexp    number;
    begin
        v_error_detail := null;
        savepoint one;

        if    porgunit is null
           or ppec is null
           or punit_array is null
           or plim_array is null then
            v_error_detail :=
                'One or more required parameters (OrgUnit, '
                || 'PEC, Unit_Array, Lim_Array) is Null.';
            raise invalid_parameters;
        end if;

        if punit_array.count <> plim_array.count then
            v_error_detail := 'Unit array and Limitation array are not the ' || 'same size.';
            raise invalid_parameters;
        end if;

        if punit_array.count = 0 then
            v_error_detail := 'Unit and Limitation arrays have no elements.';
            raise invalid_parameters;
        end if;

        if trunc(nvl(peff_date, sysdate)) < trunc(sysdate) then
            v_error_detail :=
                            'You cannot set the effective date for a limitation ' || 'to the past.';
            raise invalid_parameters;
        end if;

        if cfunds_test_cfp('CF_LIM_SET_EXP',
                           core_obj.lookup_objtype('NONE'),
                           core_context.personnel_sid,
                           porgunit) = 'N' then
            v_error_detail :=
                'You do not have privilege to set the Expense '
                || 'limitation for this organization.';
            raise no_privilege;
        end if;

        v_my_name := core_context.personnel_name;

        for i in punit_array.first .. punit_array.last
        loop
            select unit_code, unit_name
              into v_ucode, v_uname
              from v_cfunds_unit
             where SID = punit_array(i);

            if    punit_array(i) is null
               or plim_array(i) is null then
                v_error_detail := 'A Unit or Limitation value was Null.';
                raise invalid_parameters;
            end if;

            if plim_array(i) < 0 then
                v_error_detail :=
                    'You cannot specify negative amounts for the ' || 'new limitations. ('
                    || v_uname || ')';
                raise invalid_parameters;
            end if;

            if round(plim_array(i), 2) <> plim_array(i) then
                v_error_detail :=
                    'You may not specify more than 2 decimal places '
                    || 'for the amounts (cannot have fractional cents). ' || '(' || v_uname || ')';
                raise invalid_parameters;
            end if;

            if punit_array(i) <> porgunit then
                select count(*)
                  into v_cnt
                  from v_cfunds_unit
                 where SID = punit_array(i) and parent = porgunit;

                if v_cnt = 0 then
                    v_error_detail :=
                        'A specified unit (' || v_uname || ') is '
                        || 'not a direct child of the Organization.';
                    raise invalid_parameters;
                end if;
            end if;

            select count(*)
              into v_cnt
              from t_cfunds_unit
             where get_parent_unit(SID) = punit_array(i);

            if    v_cnt = 0
               or punit_array(i) = porgunit then
                -- no subordinates, set EXP limitation
                v_uexp := get_unit_annual_expenses(punit_array(i), ppec, peff_date);

                if plim_array(i) < v_uexp then
                    v_error_detail :=
                        'Unit (' || v_uname || ') has actual annual ' || 'expenses ('
                        || ltrim(to_char(v_uexp, '$9,999,990.00'))
                        || ') that already excede the specified limitation. ' || '('
                        || ltrim(to_char(plim_array(i), '$9,999,990.00')) || ')';
                    raise invalid_parameters;
                end if;

                insert into t_cfunds_limitation
                            (effective_date,
                             lim_type,
                             unit,
                             pec,
                             amount,
                             comments,
                             create_by,
                             create_on,
                             modify_by,
                             modify_on)
                     values (peff_date,
                             'EXP',
                             punit_array(i),
                             ppec,
                             plim_array(i),
                             pcomments,
                             v_my_name,
                             sysdate,
                             v_my_name,
                             sysdate);
            else                                                 -- subordinates, set OXP limitation
                v_oexp := get_unitorg_annual_expenses(punit_array(i), ppec, peff_date);

                if plim_array(i) < v_oexp then
                    v_error_detail :=
                        'Organization (' || v_uname || ') has actual annual ' || 'expenses ('
                        || ltrim(to_char(v_oexp, '$9,999,990.00'))
                        || ') that already excede the specified target limitation. ' || '('
                        || ltrim(to_char(plim_array(i), '$9,999,990.00')) || ')';
                    raise invalid_parameters;
                end if;

                insert into t_cfunds_limitation
                            (effective_date,
                             lim_type,
                             unit,
                             pec,
                             amount,
                             comments,
                             create_by,
                             create_on,
                             modify_by,
                             modify_on)
                     values (peff_date,
                             'OXT',
                             punit_array(i),
                             ppec,
                             plim_array(i),
                             pcomments,
                             v_my_name,
                             sysdate,
                             v_my_name,
                             sysdate);
            end if;
        end loop;

/*
    v_uexp := Get_Unit_Limitation( pOrgUnit, 'OXT', pPec, pEff_Date );
    v_oexp := Get_UnitOrg_Limitation( pOrgUnit, 'EXP', pPec, pEff_Date );

    if v_uexp = v_oexp then
        null;
    else
        v_error_detail := 'The total expense limitations for the organization ' ||
                          'do not match the target limitations.';
        raise INVALID_PARAMETERS;
    end if;
*/
        return;
    exception
        when others then
            rollback to savepoint one;
            raise;
    end set_exp_limitation;

    procedure set_oxt_limitation(
        punit       in   varchar2,
        pamount     in   number,
        ppec        in   varchar2,
        pcomments   in   varchar2,
        peff_date   in   date := sysdate) is
        v_cnt   number;
    begin
        v_error_detail := null;

        if    punit is null
           or pamount is null
           or pcomments is null
           or ppec is null then
            v_error_detail :=
                     'One or more required parameters (Unit, Amount, ' || 'PEC, Comments) is Null.';
            raise invalid_parameters;
        end if;

        if pamount <= 0 then
            v_error_detail := 'You must specify a positive amount for the ' || 'new limitation.';
            raise invalid_parameters;
        end if;

        if round(pamount, 2) <> pamount then
            v_error_detail :=
                'You may not specify more than 2 decimal places '
                || 'for the amount (cannot have fractional cents).';
            raise invalid_parameters;
        end if;

        if trunc(nvl(peff_date, sysdate)) < trunc(sysdate) then
            v_error_detail :=
                            'You cannot set the effective date for a limitation ' || 'to the past.';
            raise invalid_parameters;
        end if;

        if punit = get_my_cfunds_unit and get_parent_unit(punit) is not null then
            v_error_detail := 'You cannot set the OXT for your own unit.';
            raise invalid_parameters;
        end if;

        if cfunds_test_cfp('CF_LIM_SET_ORG',
                           core_obj.lookup_objtype('NONE'),
                           core_context.personnel_sid,
                           punit) = 'N' then
            v_error_detail :=
                'You do not have privilege to set the Organizational Expense '
                || 'Target limitation for this unit.';
            raise no_privilege;
        end if;

        select count(*)
          into v_cnt
          from t_cfunds_unit
         where get_parent_unit(SID) = punit;

        if v_cnt = 0 then
            core_logger.log_it(c_pipe,
                               'Unit ' || punit || ' has no organization (no subordinate '
                               || 'units). Therefore, OXT limitations do not apply.');
            v_error_detail :=
                'Specified Unit has no organization (no subordinate '
                || 'units). Therefore, OXT limitations do not apply.';
            raise invalid_parameters;
        end if;

        if pamount < get_unitorg_annual_expenses(punit, ppec, peff_date) then
            v_error_detail :=
                'The specified limitation cannot be set because actual '
                || 'expenses for the organization already exceed that ' || 'limitation.';
            raise invalid_parameters;
        end if;

        v_my_name := core_context.personnel_name;

        insert into t_cfunds_limitation
                    (effective_date,
                     lim_type,
                     unit,
                     pec,
                     amount,
                     comments,
                     create_by,
                     create_on,
                     modify_by,
                     modify_on)
             values (trunc(peff_date),
                     'OXT',
                     punit,
                     ppec,
                     pamount,
                     pcomments,
                     v_my_name,
                     sysdate,
                     v_my_name,
                     sysdate);
    end set_oxt_limitation;

    function is_unit_parent(punit in varchar2, pparent in varchar2)
        return varchar2 is
        v_parent   varchar2(1) := 'N';
    begin
        if pparent = punit and pparent = v_hq_cc_unit_sid then --'1010005M' then
            --For DFAS to OSI Transactions
            v_parent := 'Y';
        end if;

        for u in (select     SID
                        from t_osi_unit
                       where SID <> punit
                  connect by SID = prior unit_parent
                  start with SID = punit)
        loop
            if (pparent = u.SID) then
                v_parent := 'Y';
            end if;
        end loop;

        return v_parent;
    end is_unit_parent;

    function is_unit_child(punit in varchar2, pchild in varchar2)
        return varchar2 is
        v_child   varchar2(1) := 'N';
    begin
        for u in (select     SID
                        from t_osi_unit
                       where SID <> punit
                  connect by unit_parent = prior SID
                  start with SID = punit)
        loop
            if (pchild = u.SID) then
                v_child := 'Y';
            end if;
        end loop;

        return v_child;
    end is_unit_child;

    function get_unit_wfaf(p_this_unit in varchar2, p_start_date in date, p_end_date in date)
        return number is
        v_wfaf   number := 0;
    begin
        core_logger.log_it(c_pipe, 'CFunds_Pkg.Get_Unit_WFAF: entered');
        v_wfaf := get_unit_wfaf_balance(p_this_unit, false, p_end_date);
        return v_wfaf;
    end get_unit_wfaf;

    function get_unit_dfotf(p_this_unit in varchar2, p_start_date in date, p_end_date in date)
        return number is
        v_dfotf   number := 0;
    begin
        core_logger.log_it(c_pipe, 'CFunds_Pkg.Get_Unit_DFOTF: entered');

        -- incomming and outgoing dfo transfers
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = p_this_unit
                          and xfr_type like 'DFO%'
                          and receive_date > p_start_date
                          and receive_date < p_end_date))
        loop
            if x.xfr_type = 'DFOA' then
                v_dfotf := v_dfotf + nvl(x.amount, 0);
            elsif x.xfr_type = 'DFOR' then
                v_dfotf := v_dfotf - nvl(x.amount, 0);
            end if;
        end loop;

        for x in (select decode(receiver, p_this_unit, amount, -1 * amount) as amount
                    from t_cfunds_xfr
                   where (    (   receiver = p_this_unit
                               or sender = p_this_unit)
                          and xfr_type = 'DFOTF'
                          and send_date > p_start_date
                          and send_date < p_end_date))
        loop
            v_dfotf := v_dfotf + nvl(x.amount, 0);
        end loop;

        return v_dfotf;
    end get_unit_dfotf;

    function get_unit_oa(p_this_unit in varchar2, p_start_date in date, p_end_date in date)
        return number is
        v_oa       number       := 0;
        v_parent   varchar2(20);
    begin
        core_logger.log_it(c_pipe, 'CFunds_Pkg.Get_Unit_OA: entered');
        v_parent := get_parent_unit(p_this_unit);

        for a in (select *
                    from t_cfunds_advance_v2
                   where unit = p_this_unit
                     and issue_on < p_end_date
                     and close_date is null
                     and nvl(cleared, '-') <> 'r')
        loop
            v_oa := v_oa - nvl(a.cash_amount, 0);
            v_oa := v_oa - nvl(a.check_amount, 0);
            v_oa := v_oa + nvl(a.expensed_amount, 0);
            core_logger.log_it(c_pipe,
                               'CFunds_Pkg.Get_Unit_OA: ' || a.voucher_no || ':' || a.SID || '  - '
                               || v_oa);
        end loop;

        for r in (select ar.*
                    from t_cfunds_advance_repayment_v2 ar, t_cfunds_advance_v2 a
                   where a.SID = ar.advance
                     and a.unit = p_this_unit
                     and ar.receive_on < p_end_date
                     and a.close_date is null
                     and nvl(ar.cleared, '-') <> 'r')
        loop
            v_oa := v_oa + nvl(r.cash_amount, 0);
            v_oa := v_oa + nvl(r.check_amount, 0);
            core_logger.log_it(c_pipe,
                               'CFunds_Pkg.Get_Unit_OA: ' || r.voucher_no || ':' || r.advance
                               || '  - ' || v_oa);
        end loop;

-- Back in for EOY --   Taken out because the outstanding advances from previous years are now calculated above.
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = p_this_unit
                          and xfr_type = 'OA'
                          and sender <> v_parent
                          and                                          --new line since this is back
                              send_date < p_end_date))
        loop
            v_oa := v_oa + nvl(x.amount, 0);
        end loop;

        for x in (select *
                    from t_cfunds_xfr
                   where (    sender = p_this_unit
                          and xfr_type = 'OA'
                          and receiver <> v_parent
                          and                                          --new line since this is back
                              send_date < p_end_date))
        loop
            v_oa := v_oa - nvl(x.amount, 0);
        end loop;

        return v_oa;
    end get_unit_oa;

    function get_unit_oe(p_this_unit in varchar2, p_start_date in date, p_end_date in date)
        return number is
        v_oe     number := 0;
        v_temp   number := 0;
    begin
        core_logger.log_it(c_pipe, 'CFunds_Pkg.Get_Unit_OE: entered');

        for e in (select   *
                      from t_cfunds_expense_v3
                     where charge_to_unit = p_this_unit
                       and (   (paid_on > p_start_date and paid_on < p_end_date)
                            or (repaid_on > p_start_date and repaid_on < p_end_date))
                  order by paid_on)
        loop
            if e.paid_on > p_start_date then
                if e.repaid_on > p_start_date then
                    v_temp :=((nvl(e.paid_cash_amount, 0) + nvl(e.paid_check_amount, 0)));
                    core_logger.log_it(c_pipe,
                                       'CFunds_Pkg.Get_Unit_OE: Repaid ignored of ' || v_temp
                                       || ' On ' || e.voucher_no);
                elsif abs(nvl(e.take_from_advances, 0)) > 0 then
                    v_temp :=
                        ((nvl(e.source_amount, 0) + nvl(e.agent_amount, 0))
                         / nvl(e.conversion_rate, 1));
                    core_logger.log_it(c_pipe,
                                       'Cfunds_Pkg.Get_Unit_OE: TFA OF ' || v_temp || ' On '
                                       || e.voucher_no);
                    v_oe := v_oe -((nvl(e.source_amount, 0)) / nvl(e.conversion_rate, 1));
                    -- cash amounts always considered cleared
                    v_oe := v_oe -((nvl(e.agent_amount, 0)) / nvl(e.conversion_rate, 1));
                    v_oe := round(v_oe, 2);
                else
                    v_temp :=(nvl(e.paid_cash_amount, 0) + nvl(e.paid_check_amount, 0));
                    core_logger.log_it(c_pipe,
                                       'Cfunds_Pkg.Get_Unit_OE: EXP OF -' || v_temp || ' On '
                                       || e.voucher_no);
                    v_oe := v_oe -(nvl(e.paid_cash_amount, 0));
                    -- cash amounts always considered cleared
                    v_oe := v_oe -(nvl(e.paid_check_amount, 0));
                end if;
            else
                if e.repaid_on > p_start_date and e.repaid_on < p_end_date then
--Repaid old expense this year. Needs to be reduced because the old expense is brought forward by the EOY process.
                    v_temp :=
                        ((nvl(e.source_amount, 0) + nvl(e.agent_amount, 0))
                         / nvl(e.conversion_rate, 1));
                    core_logger.log_it
                                     (c_pipe,
                                      'CFunds_Pkg.Get_Unit_OE: Repaid previous year expense of +'
                                      || v_temp || ' On ' || e.voucher_no);
                    v_oe := v_oe +((nvl(e.source_amount, 0)) / nvl(e.conversion_rate, 1));
                    -- cash amounts always considered cleared
                    v_oe := v_oe +((nvl(e.agent_amount, 0)) / nvl(e.conversion_rate, 1));
                    v_oe := round(v_oe, 2);
                else
                    v_temp :=(nvl(e.paid_cash_amount, 0) + nvl(e.paid_check_amount, 0));
                    core_logger.log_it(c_pipe,
                                       'Cfunds_Pkg.Get_Unit_OE: ignored START DATE' || v_temp
                                       || ' On ' || e.voucher_no);
                end if;
            end if;

            core_logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_OE: Running Total' || v_oe);
        end loop;

        core_logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_OE: END OF LOOP Running Total' || v_oe);

--Adds up all incomming recieved Payment listings
        for x in (select   *
                      from t_cfunds_xfr
                     where (    receiver = p_this_unit
                            and (   xfr_type = 'ER'
                                 or xfr_type = 'DER')
                            and receive_date > p_start_date
                            and receive_date < p_end_date)
                  order by receive_date)
        loop
            v_oe := v_oe + nvl(x.amount, 0);
            core_logger.log_it(c_pipe,
                               'Cfunds_Pkg.Get_Unit_OE: ER OF +' || nvl(x.amount, 0)
                               || '  Running Total: ' || v_oe);
        end loop;

        core_logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_OE: END OF LOOP Running Total' || v_oe);

--Subtracts out all outgoing recieved payment listings
        for x in (select   *
                      from t_cfunds_xfr
                     where (    sender = p_this_unit
                            and (   xfr_type = 'ER'
                                 or xfr_type = 'DER')
                            and receive_date > p_start_date
                            and receive_date < p_end_date)
                  order by receive_date)
        loop
            v_oe := v_oe - nvl(x.amount, 0);
            core_logger.log_it(c_pipe,
                               'Cfunds_Pkg.Get_Unit_OE: ER OF -' || nvl(x.amount, 0)
                               || '  Running Total: ' || v_oe);
        end loop;

        core_logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_OE: END OF LOOP Running Total' || v_oe);

--Calcs all OEs
        for x in (select *
                    from t_cfunds_xfr
                   where (    receiver = p_this_unit
                          and xfr_type = 'OE'
                          and receive_date > p_start_date
                          and receive_date < p_end_date + 1))
        loop
            v_oe := v_oe + nvl(x.amount, 0);
            core_logger.log_it(c_pipe,
                               'Cfunds_Pkg.Get_Unit_OE: OE OF -' || nvl(x.amount, 0)
                               || '  Running Total: ' || v_oe);
        end loop;

        core_logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_OE: END OF LOOP Running Total' || v_oe);

        for x in (select *
                    from t_cfunds_xfr
                   where (    sender = p_this_unit
                          and xfr_type = 'OE'
                          and receive_date > p_start_date
                          and receive_date < p_end_date + 1))
        loop
            v_oe := v_oe - nvl(x.amount, 0);
            core_logger.log_it(c_pipe,
                               'Cfunds_Pkg.Get_Unit_OE: OE OF +' || nvl(x.amount, 0)
                               || '  Running Total: ' || v_oe);
        end loop;

        core_logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_OE: END OF LOOP Running Total' || v_oe);
        v_oe := round(v_oe, 2);
        return v_oe;
    end get_unit_oe;

    procedure send_closing_transfer(
        p_this_unit     in   varchar2,
        p_this_parent   in   varchar2,
        p_amount        in   number,
        p_type          in   varchar2,
        p_closedate     in   date,
        p_direction     in   varchar2) is
        v_vno   t_cfunds_xfr.voucher_no%type;
    begin
        v_my_name := core_context.personnel_name;
        core_logger.log_it(c_pipe, 'Cfunds_Pkg.Send_Closing_Transfer: entered');
        v_vno := get_voucher_num('X', p_closedate);
        core_logger.log_it(c_pipe,
                           'VALUES: ' || p_type || ' ' || v_vno || ' ' || p_this_unit || ' '
                           || p_this_parent || ' ' || to_char(p_closedate) || ' '
                           || to_char(p_amount) || ' ' || v_my_name);

        insert into t_cfunds_xfr
                    (xfr_type,
                     voucher_no,
                     sender,
                     send_date,
                     receiver,
                     receive_date,
                     amount,
                     create_by,
                     create_on,
                     modify_by,
                     modify_on)
             values (p_type,
                     v_vno,
                     p_this_unit,
                     p_closedate,
                     p_this_parent,
                     p_closedate,
                     p_amount,
                     v_my_name,
                     sysdate,
                     v_my_name,
                     sysdate);
    exception
        when others then
            core_logger.log_it(c_pipe, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            core_logger.log_it(c_pipe, 'Cfunds_Pkg.Send_Closing_Transfer: EXIT');
    end send_closing_transfer;

    procedure get_units_eoy_order(
        phq_unit       in       varchar2,
        ptoptobottom   in       boolean,
        punits_array   out      str_arr,
        pother_array   out      str_arr,
        pcount         out      binary_integer) is
        v_idx           binary_integer;
        v_temp_idx      binary_integer;
        v_units_array   str_arr;
        v_other_array   str_arr;
        v_parent        varchar2(20);
    begin
        core_logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Units_EOY_Order: entered');
        v_idx := 0;

        for e in (select     u.SID, u.unit_parent, u.unit_code
                        from t_osi_unit u, t_cfunds_unit c
                       where u.SID = c.SID
                  connect by u.unit_parent = prior u.SID
                  start with u.unit_parent is null)
        loop
            -- skip those units not in the testing tree
            if (e.SID <> phq_unit and e.unit_code in ('UNASS','UNASS(SEP)')) then --e.SID <> '1010067J' and e.SID <> '10108OUP') then
                v_idx := v_idx + 1;
                pother_array(v_idx) := e.SID;
                v_parent := e.unit_parent;

                loop
                    if (v_parent=v_hq_cc_unit_sid or osi_unit.IsRegion(v_parent)='Y'
                               --('1010005M', '1010000H', '1010001L', '1010002D', '10100031',
                               -- '1010003K', '1010004J', '1010004Z', '1010005C', '10100076',
                               -- '101E3051')
                        or v_parent is null) then
                        exit;
                    end if;

                    select u2.unit_parent
                      into v_parent
                      from t_osi_unit u2
                     where u2.SID = v_parent;
                end loop;

                punits_array(v_idx) := v_parent;
            end if;
        end loop;

        pcount := v_idx;

        if not ptoptobottom then
            v_idx := 1;

            loop
                v_other_array(v_idx) := pother_array(v_idx);
                v_units_array(v_idx) := punits_array(v_idx);
                v_idx := v_idx + 1;

                if v_idx > pcount then
                    exit;
                end if;
            end loop;

            v_temp_idx := pcount;
            v_idx := 1;

            loop
                pother_array(v_temp_idx) := v_units_array(v_idx);
                punits_array(v_temp_idx) := v_other_array(v_idx);
                v_idx := v_idx + 1;
                v_temp_idx := v_temp_idx - 1;

                if v_temp_idx = 0 then
                    exit;
                end if;
            end loop;
        end if;
    end get_units_eoy_order;
end;
/
