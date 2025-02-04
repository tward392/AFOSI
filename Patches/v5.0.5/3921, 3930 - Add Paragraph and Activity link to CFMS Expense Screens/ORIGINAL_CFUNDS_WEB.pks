CREATE OR REPLACE PACKAGE WEBI2MS.cfunds_web is
/*
    Cfunds_Web - Holds C-Funds related web routines that generate html
                 and send the web pages to the server.

    History:
        11-Jul-03 RWH   Original version.
        13-Oct-03 CLJ   Added EFT Info procedure, updated form 28 & 29.
        05-Dec-03 CLJ   Removed Adjust_Limitations procedure since it looked obsolete.
        19-Apr-04 CLJ   Added a new 'hidden' debugging method called 'TEST_PAYMENT_LISTING' to
                         help find a problem seen up at OSI.
                        Added a few parameters to Expense_form method to allow
                         user to add data before form is shown.
        18-May-04 AES   Updated Advance_Form30 parameters.
        21-Jun-04 CLJ   Modified the Form29 method since it has new parameters.
        28-Jun-04 CLJ   Added new public method "Validate_Claimant" (for debugging use).
        30-Jun-04 CLJ   Added new parameter to "form29" to allow user to skip corrupt data checking.
        19-Aug-04 CLJ   Added fiscal year parameters to most procedures.
                        Added new procedures: Adjust_AFOSI_Limitations,
                        AFOSI_Limitations_List, Manage_CFMS.
        24-Sep-04 CLJ   Added new procedure Reconcile_account.
        29-Jun-05 GEG   Fixing various problems found. v_Command2_Specs in transfer_details changed its size.
                         1:Fixed links because of 10g upgrade.  The get_current_package return the page even if it
                         includes ! exclamation marks. 10g fixes this.  Had to repair spots that built urls that were
                         correcting based on the 8i spec.
                         2:Don't forget that the v_HQ_CC_Unit_SID (below) should equal what is atOSI.
                         3:Changed the MFR feature and transaction log.
                         4:Fixed the links to transaction log from mfr_details, manage_limitations and
                         reconcile_account.  If a person was denied access then the pUnit and PFiscalYear were
                         not being set so the javascript to pop up windows for transaction log would fail.
                         Added new procedure PrintForm28.  This will give the user the ability to print a more condensed
                         version of the transaction log.
                         5:Reversed the Disallowed and Reject functionality.  Request from Cfunds to
                         relabel the Disallow to Reject and the Reject to Disallow.  This incurred
                         redoing functionality to let Disallow to exhibit Reject functionality and Disallow
                         to exhibit Reject functionality.
                         6:Gave the ability to get the voucher number set on submission of expense
                         7:Added a dfo page
                         8:added a expense and advance search page
        01-Aug-05 JAT    Modified manage_cfms to call the end of year closeout routines.  Also, changed
                         the Payment List/Send Pending routine to look more like the Transfer/Send Pending
                         page when the user hits the "pay unit" button.
        08-Aug-05 JAT    Added routines for end of year closing.  Zero_all and zero_region_unit are used
                         to transfer balances to the parent unit.  Reinit_all and reinit_region_unit are
                         used to transfer balances from the parent back to the unit.
        22-Aug-05 JAT    Added routines for next and previous expense.  Expense status table added
                         for expense details.
        12-May-09 MAB    Copied from WEB schema, renamed, and imported. Modified calls to
                            WEB schema to call new WEB_ packages.

*/
    procedure home_page_guts(punit in varchar2 := null, pfiscalyear in varchar2 := null);

    -- Management of AFOSI limitations/activities (HQ level).
    procedure adjust_afosi_limitations(name_array in owa.vc_arr, value_array in owa.vc_arr);

/*
    Generates a webpage that allows the HQ FM C-Funds custodian to manage the details
    of many settings that apply to OSI.  Links are available to allow access to
    setup EFT Information, set the Limitation totals for OSI, and manage the
    MFR processing.

    This procedure use the "Flexible Parameter Passing" mechanism since we
    don't know how many parameters need to be processed.

*/
    procedure afosi_limitations_list(name_array in owa.vc_arr, value_array in owa.vc_arr);

/*
    Generates a webpage that allows the HQ FM C-Funds custodian to view the details
    of all limitations that apply to OSI.  Limitations are shown as a list so
    both past and future limitations can be seen.  This will allow the HQ custodian
    to see what is 'coming up'.

    This procedure use the "Flexible Parameter Passing" mechanism since we
    don't know how many parameters need to be processed.

*/

    -- Advances
    procedure advance_details(
        pcommand        in   varchar2 := null,
        psid            in   varchar2 := null,
        ppurpose        in   varchar2 := null,
        pcheck_amount   in   number := null,
        pcheck_number   in   varchar2 := null,
        pcash_amount    in   number := null,
        punit           in   varchar2 := null,
        pparams         in   varchar2 := null,
        pfiscalyear     in   varchar2 := null);

/*
    Generates a webpage that contains details of a selected Advance.
    This also lists the Advance Repayments that have been applied toward
    this advance in a table.

    pCommand: Indicates what type of button the user pushed. Valid
            options are: Approve, Reject, Process Payment, Print form.
    pSID: Indicates the SID of the advance that the user selected. Valid
            SIDs come from T_CFUNDS_ADVANCE_V2.  This SID is passed here
            from the items listed in the Advances_For_Unit webpage.

    pPurpose:
    pCheck_Issue_On:
    pCheck_Amount:
    pCheck_Number:
    pCash_Issue_On:
    pCash_Amount:
            All the above parameters hold the text string data from the corresponding
            text field in the web form.  No code controls this, it is automatically
            done by server processing.
            (These values are not used when this webpage is first displayed).
*/
    procedure advances_by_personnel(
        pcommand      in   varchar2 := null,
        pnew          in   varchar2 := null,
        psubmitted    in   varchar2 := null,
        papproved     in   varchar2 := null,
        prejected     in   varchar2 := null,
        pactive       in   varchar2 := null,
        pclosed       in   varchar2 := null,
        punit         in   varchar2 := null,
        pfiscalyear   in   varchar2 := null,
        punitpick     in   varchar2 := null);

/*
    Generates a webpage that lists all Advances for the User's Unit.
    It defaults to showing Submitted and Approved (Approved=not Paid) advances.

    pCommand: Indicates what type of button the user pushed. Valid
            options are: Update List and Reset Options.  No code is
            needed here to cause the button to create the appropriate action.
    pSID: Indicates the SID of the advance that the user selected. Valid
            SIDs come from T_CFUNDS_ADVANCE_V2.

    pNew:
    pSubmitted:
    pApproved:
    pRejected:
    pActive:
    pClosed:
            All the above parameters hold the values from the corresponding
            checkboxes in the web form.  These filter the list of advances
            by the chosen Status values.  After the checkboxes are changed,
            the user should hit the "Update List" command button to trigger
            a refresh of the list.
*/
    procedure advance_form30(
        psid              in   varchar2,
        pcommand          in   varchar2 := null,
        pcustodian_name   in   t_cfunds_advance_v2.issue_by%type := null);

/*
    Generates a webpage that produces an electronic Form 30 (Request For Advance of Funds).
    It shows the details of the current advance (this page is launched from the
    Advance_details page only).  The user must hit the Print button on the browser
    in order to print this form.

    pSID: Indicates the SID of the advance that the user selected. Valid
            SIDs come from T_CFUNDS_ADVANCE_V2.
    pCommand:  User gets a screen that allows the Custodian's name to be input,
               and then hits OK button.  pCommand stores the value of OK or cancel.
    pApprover: The name of the Custodian that will be shown on the Advance Form.
*/

    -- EFT Information
    procedure eft_info(
        pcommand          in   varchar2 := null,
        peft_unit         in   varchar2 := null,
        prouting_number   in   varchar2 := null,
        paccount_number   in   varchar2 := null,
        paccount_desc     in   varchar2 := null,
        punit             in   varchar2 := null,
        pfiscalyear       in   varchar2 := null);

/*
    Generates a webpage that allows an agent (usually a custodian at HQ)
    to enter data required to make an Electronic Funds Transfer (EFT).  The
    data entered is specified for a particular unit, and there is a privilege
    needed to view and change data for subordinate units.  Currently only HQ
    keeps this information for the Regions in order to send it to DFAS when a
    Payment Listing is done.

    pUnit: The unit selected on the page before this link was selected.
           Defaults to the unit of the logged in user if it isn't specified.
    pSID: Indicates the SID of the advance that the user selected. Valid
            SIDs come from T_CFUNDS_ADVANCE_V2.
*/

    -- Expenses
    procedure expense_details(
        pcommand                  in   varchar2 := null,
        psid                      in   varchar2 := null,
        pcategory                 in   varchar2 := null,
        pparagraph                in   varchar2 := null,
        pdescription              in   varchar2 := null,
        pcheck_amount             in   number := null,
        pcheck_number             in   varchar2 := null,
        pcash_amount              in   number := null,
        padvance_created          in   varchar2 := null,
        prepayment_check_amount   in   number := null,
        prepayment_check_number   in   varchar2 := null,
        prepayment_cash_amount    in   number := null,
        prejection_comments       in   varchar2 := null,
        paction                   in   varchar2 := null,
        punit                     in   varchar2 := null,
        pparams                   in   varchar2 := null,
        ppersid                   in   varchar2 := null,
        ptakefromadvance          in   varchar2 := null,
        ptakefromother            in   varchar2 := null,
        pfiscalyear               in   varchar2 := null);

/*
    Generates a webpage that contains details of a selected Expense.

    pCommand: Indicates what type of button the user pushed. Valid
            options are: Approve, Reject, Process Payment (?? STILL UNDER DEVELOPMENT).
    pSID: Indicates the SID of the expense that the user selected. Valid
            SIDs come from T_CFUNDS_EXPENSE_V3.  This SID is passed here
            from the items listed in the Expenses_For_Indiv webpage.

    pCategory (drop-down),
    pParagraph (drop-down),
    pDescription:
    pCheck_Amount:
    pCheck_Number:
    pCash_Amount:
    pTakeFromAdvance (checkbox),
    pTakeFromOther (checkbox)
            All the above parameters hold the text string data from the corresponding
            text field in the web form.  No code controls this, it is automatically
            done by server processing.
            (These values are not used when this webpage is first displayed).
*/

    -- procedure Expense_Details( pCommand in Varchar2 := null,
--                            pSID in Varchar2 := null,
--          pCategory in Varchar2 := null,
--                            pParagraph in Varchar2 := null,
--          pDescription in Varchar2 := null,
--                            pCheck_Amount in Number := null,
--                            pCheck_Number in Varchar2 := null,
--                            pCash_Amount in Number := null,
--                            pRepayment_Check_Amount in Number := null,
--                            pRepayment_Check_Number in Varchar2 := null,
--                            pRepayment_Cash_Amount in Number := null,
--                            pRejection_Comments in Varchar2 := null,
--                            pAction in Varchar2 := null,
--                            pUnit in Varchar2 := null,
--                            pParams in Varchar2 := null,
--                            pPerSid in Varchar2 := null,
--                            pTakeFromAdvance in Varchar2 := null,
--                            pTakeFromOther in Varchar2 := null,
--                           pDate in Date := null,
--                           pClaimant in Varchar2 := null,
--                           pContext in Varchar2 := null,
--                           pDocumentation in Varchar2 := null,
--                           pSource_Amount in Number := null,
--                           pAgent_Amount in Number := null,
--                           pConversion_Rate in Number := null );
-- /*
--     Generates a webpage that contains details of a selected Expense.
-- also now allows new expenses to be created.
--
--       Note- Source_ID is only generated thru the view, not available in table.
--          for that reason it cannot be specified when a new expense is created.
--
--
--     pCommand: Indicates what type of button the user pushed. Valid
--             options are: Approve, Reject, Process Payment (?? STILL under DEVELOPMENT).
--     pSID: Indicates the SID of the expense that the user selected. Valid
--             SIDs come from T_CFUNDS_EXPENSE_V3.  This SID is passed here
--             from the items listed in the Expenses_For_Indiv webpage.
--
--     pCategory (drop-down),
--     pParagraph (drop-down),
--     pDescription:  These three fields are editable only during certain lifecycle states.
--
--     pCheck_Amount:
--     pCheck_Number:
--     pCash_Amount:   These three parameters are used when the "Process Payment" button
--        is clicked, the user fills in some or all of these values and then hits the button.
--
--     pRepayment_Check_Amount
--     pRepayment_Check_Number
--     pRepayment_Cash_Amount  These three parameters are used only when the agent is re-paying
--         an expense that has been disallowed.  The Repay Expense button is clicked after
--         these fields are filled in (these fields are optional, if none are filled in
--         an advance gets created to track that the agent still owes the money).
--
--     pRejection_Comments: stores comments entered when an expense is rejected or disallowed
--
--     pAction: used to indicate what action is being processed; some Commands like Reject need
--          input from the user before the update is complete.  pAction is the way the form
--          keeps track of which command is being processed.
--
--     pUnit: keeps the current Unit context that was chosen on the HomePage so when the user
--        navigates through the site all pages are in the same unit context.
--
--     pParams: holds the list of parameters that were applied to the previous web page,
--        needed so when the Back button is pressed the same parameters can be applied and
--        thus the same page can be displayed - in a refreshed state.
--
--     pPerSid: the Claimant of this expense, used to indicate that the previous page
--        was the expenses_by_personnel.  This allows the Back button to know where to send
--        the user.
--
--     pTakeFromAdvance (checkbox),
--     pTakeFromOther (checkbox)  These checkboxes are only editable during certain lifecycle states.
--
-- The following 7 parameters are only used when a new expense is created:
--     pDate: Date the expense was incurred.
--     pClaimant: Person who actually spent the funds (usually will be different from
--        the agent entering the new expense, since some agents working in remote locations
--        don't have access to computers).
--     pContext:  Text field should describe the I2MS Activity that these C-Funds apply to
--     pDocumentation: 3 option buttons give the user a choice as to how proof of this expense
--        was done (receipts are kept track of outside the system but the system holds
--        values saying where they are).  An option is only required when the total amount
--        spent is greater than $75.
--     pSource_Amount: the amount of funds spent for the source (not always US dollars)
--     pAgent_Amount: the amount of funds spent for the agent (not always US dollars)
--     pConversion_Rate: the rate at which you divide the sum of the above 2 values to
--        make the total be in US dollars.
--
--
--             all the above parameters hold the text string data from the corresponding
--             text field in the web form.  No code controls this, it is automatically
--             done by server processing.
--             (These values are not used when this webpage is first displayed).
-- */
    procedure expense_form(
        psid             in   varchar2,
        pcommand         in   varchar2 := null,
        papprover_name   in   t_cfunds_expense_v3.approved_by%type := null);

/*
    Generates a webpage that produces an electronic Expense Form.
    It shows the details of the current expense (this page is launched from the
    Expense_details page only).  The user must hit the Print button on the browser
    in order to print this form.

    pSID: Indicates the SID of the expense that the user selected. Valid
            SIDs come from T_CFUNDS_EXPENSE_V3.
    pCommand:  User gets a screen that allows the Approver's name to be input,
               and then hits OK button.  pCommand stores the value of OK or cancel.
    pApprover: The name of the Approval Authority that will be shown on the Expense Form.
*/
    procedure expense_repayment_form(psid in varchar2);

/*
    Generates a webpage that produces an electronic Expense Repayment Form.
    It shows the voucher number and date of the current expense (this page is launched from the
    Expense_details page only), and also shows details about how the agent repaid the
    expense to the c-funds custofian.  The user must hit the Print button on the browser
    in order to print this form.

    pSID: Indicates the SID of the expense that the user selected. Valid
            SIDs come from T_CFUNDS_EXPENSE_V3.
*/
    procedure expenses_by_personnel(
        pcommand          in   varchar2 := null,
        pnew              in   varchar2 := null,
        psubmitted        in   varchar2 := null,
        papproved         in   varchar2 := null,
        ppaid             in   varchar2 := null,
        prejected         in   varchar2 := null,
        preturned         in   varchar2 := null,
        prepaid           in   varchar2 := null,
        pclosed           in   varchar2 := null,
        ppaymentlisting   in   varchar2 := null,
        punit             in   varchar2 := null,
        pfiscalyear       in   varchar2 := null,
        punitpick         in   varchar2 := null);

/*
    Generates a webpage that lists each Personnel in the User's Unit that
    have Expenses.  For each Personnel, the total number of expenses is shown.
    It defaults to showing Submitted and Approved (Approved=not Paid) expenses.
    The user can filter the list to see different counts.

    pCommand: Indicates what type of button the user pushed. Valid
            options are: Update List and Reset Options.  No code is
            needed here to cause the button to create the appropriate action.

    pNew:
    pSubmitted:
    pApproved:
    pRejected:
    pPaid:
    pDisallowed:
    pRepaid:
    pClosed:
            All the above parameters hold the values from the corresponding
            checkboxes in the web form.  These filter the list of expenses
            by the chosen Status values.  After the checkboxes are changed,
            the user should hit the "Update List" command button to trigger
            a refresh of the list.
*/
    procedure expenses_for_indiv(
        pcommand      in   varchar2 := null,
        pnew          in   varchar2 := null,
        psubmitted    in   varchar2 := null,
        papproved     in   varchar2 := null,
        ppaid         in   varchar2 := null,
        prejected     in   varchar2 := null,
        preturned     in   varchar2 := null,
        prepaid       in   varchar2 := null,
        pclosed       in   varchar2 := null,
        psid          in   varchar2 := null,
        punit         in   varchar2 := null,
        pfiscalyear   in   varchar2 := null,
        punitpick     in   varchar2 := null);

/*
    Generates a webpage that lists all the Expenses for the chosen Personnel
    in the User's Unit. It defaults to showing the same filters as the calling
    web page had chosen.  The calling web page is Expenses_By_Personnel.
    The user can filter the list to see different expenses.

    pCommand: Indicates what type of button the user pushed. Valid
            options are: Update List and Reset Options.  No code is
            needed here to cause the button to create the appropriate action.
    pSID: Indicates the SID of the Personnel that the user selected. Valid
            SIDs come from T_PERSONNEL.

    pNew:
    pSubmitted:
    pApproved:
    pRejected:
    pPaid:
    pDisallowed:
    pRepaid:
    pClosed:
            All the above parameters hold the values from the corresponding
            checkboxes in the web form.  These filter the list of expenses
            by the chosen Status values.  After the checkboxes are changed,
            the user should hit the "Update List" command button to trigger
            a refresh of the list.
*/

    -- Debugging procedure only
    procedure validate_claimant(punit in varchar2 := null, pshowall in varchar2 := null);

/*
    This procedure will show, for each claimant in the given unit,
    the amount of money that was taken from all advances and applied to expenses,
    and also the amount of advanced money that was repaid using expenses.

    These two numbers should match, since the expense and advances always should
    record the proper amount taken from one and put on the other.

    This procedure is meant to be run as a means to detect corrupt data in the database.
    Corrupt data found by this procedure will cause the Custodian Change Form
    to not balance.

*/

    -- Forms generated for AFOSI
    procedure form28(
        punit         in   varchar2 := null,
        pfiscalyear   in   varchar2 := null,
        pdebug        in   varchar2 := null,
        pstart_date   in   date := null,
        pend_date     in   date := null,
        pcommand      in   varchar2 := null);

/*
    This procedure will show the Form 28 in report output and the user can
    hit a print button from there.

    Set pDebug=true in browser URL to turn debugging on, this will cause the
    'Outstanding' column to show a running total.

*/
    procedure printform28(
        punit         in   varchar2,
        pfiscalyear   in   varchar2,
        pdebug        in   varchar2 := null,
        pstart_date   in   date,
        pend_date     in   date);

/*
    This procedure will show the a printable version of the From 28.
*/

    -- 22-Aug-08 TJW    CR#2719 - Added Detco Signature block to Form 29.
    procedure form29(
        punit            in   varchar2 := null,
        pfiscalyear      in   varchar2 := null,
        pdebug           in   varchar2 := null,
        pusage           in   varchar2 := null,
        pcommand         in   varchar2 := null,
        pauditor1_name   in   varchar2 := null,
        pauditor2_name   in   varchar2 := null,
        pdetco_name      in   varchar2 := null,
        pincoming_name   in   varchar2 := null,
        pskipchecks      in   varchar2 := null);

/*
    This procedure will show the Form 29 in report output and the user can
    hit a print button from there.

    Set pDebug=true in browser URL to turn debugging on, this will cause the
    calculations to be shown at the top of the page before the Actual form.

    pUsage tells the code the type of form to show - an audit form is used when an
    audit is done, and a custodian change form is done either when a custodian change
    takes place, or the custodian can just use it to reconcile their books.

    pCommand is used to allow a startup template to allow the user to enter names
    of Custodians or Auditors.  Buttons are either Ok or Do_Audit or Do_Custodian_Change.
    The user can either enter auditors' names or custodian's names, and the
    corresponding version of Form 29 will be shown.

    pAuditor1_Name, pAuditor2_Name, pIncoming_Name are parameters to allow
    the user to enter names to be filled in on the form in the signature section.

    pSkipChecks allows the user to see the form without any corrupt data messages being shown.

*/
--  22-Aug-08 TJW    CR#2719 - Added Detco Signature block to Form 29.

    -- Home Page
    procedure home_page(
        punit         in   varchar2 := null,
        pfiscalyear   in   varchar2 := null,
        ptkt          in   varchar2 := null);

/*
    Generates a webpage that contains the summary statistics for the current user's
    unit.  This is the starting point for the whole C-Funds web interface.

    pUnit allows the user to choose a unit.  This will show data for the chosen unit
       on all subsequent pages.  Defaults to user's current unit.  Permissions checked,
       if user doesn't have approve or pay priv for expenses, he is not allowed to see
       any pages for the selected unit.
    pFiscalYear allows the user to choose a fiscal year.  Defaults to current fiscal year
       but user can change to view data from prior fiscal years.
*/
    procedure manage_cfms(name_array in owa.vc_arr, value_array in owa.vc_arr);

/*
    Generates a webpage that allows the HQ FM C-Funds custodian to manage the limitations
    of all OSI, and also manage other aspects of the CFMS.  This is an entry point
    to all Management functionality needed to be done only at the HQ level.

    This procedure use the "Flexible Parameter Passing" mechanism since we
    don't know how many parameters need to be processed.

*/
    procedure manage_limitations(name_array in owa.vc_arr, value_array in owa.vc_arr);

/*
    Generates a webpage that allows a C-Funds custodian to manage the limitations
    of a selected unit, and all immediate sub-units of that unit. If the sub-unit
    has its own sub-units, the Organization Expense Target (OXT) limitation can be
    established. If there are no sub-sub-units, the actual Expense (EXP) limitation
    can be established.

    This procedure use the "Flexible Parameter Passing" mechanism since there
    can be many Unit/Limitation pairs processed. The procedure accomplishes
    the actual database updates via the Cfunds_Pkg.Set_EXP_Limitation.

    To debug the data on production database:  use "&pDebug=True" on the end of the URL.
*/

    -- Memo For Record.
    procedure mfr_by_unit(punit in varchar2, pfiscalyear in varchar2);

/*
    Shows a page that lists MFR objects for a selected unit-
    MFR = Memo For Record.

*/
    procedure mfr_details(name_array in owa.vc_arr, value_array in owa.vc_arr);

/*
    Shows a page that allows a custodian to enter or work with a MFR object-
    MFR = Memo For Record.

*/
    procedure navigation(punit in varchar2 := null, pfiscalyear in varchar2 := null);

/*
    Shows a page that basically lists the structure of the C-Funds site links.
    Nothing fancy here.
*/
    procedure payment_listing_details(
        punit         in   varchar2 := null,
        pprev_unit    in   varchar2 := null,
        pxfr          in   varchar2 := null,
        pcommand      in   varchar2 := null,
        pfiscalyear   in   varchar2 := null);

/*
     Shows a page that lists all expenses that are to be reimbursed to the
     unit passed in; only those expenses that are for the pPrev_Unit
     and that are in the selected fiscal year will be shown  Currently
     defaults to the current fiscal year.
     Links will allow the expense details to be seen for each expense,
     and a button will display a form that calls for
     a transfer of funds to be initiated in the system.

     This form is used to show lists of expenses before they are linked
     to an expense reimbursement transfer, and to show transfers with
     the appropriate expenses.  If you sent in a pXfr parameter, then
     don't use pPrev_Unit.  Same is true for the other way- if you use
     pPrev_Unit then don't use pXfr.

     pXfr is the SID of a transfer of type 'ER' - Expense Reimbursement-
          that has already been initiated.
     pUnit is the SID of the unit currently being worked (the 'context'
          from the Home_page selection.
     pPrev_Unit is the SID of the Unit that reviewed the expenses previously.
          For example, if you are in Region 1, and you are looking at
          everything in Region 1's context, you could see a payment
          listing for Det 101.  In order to show this form, Region 1's
          SID would be put in pUnit and Det 101's SID would be put in
          pPrev_Unit.
     pFiscal_Year is the fiscal year chosen that filters the data.  Only payment
          listings in the selected fiscal year will be shown.  If not specified,
          the current fiscal year is used.
*/
    procedure payment_listing_form(
        punit         in   varchar2,
        pprev_unit    in   varchar2 := null,
        pxfr          in   varchar2 := null,
        pfiscalyear   in   varchar2 := null);

/*
     Launches a new browser window that shows the list of
     expenses that need to be reimbursed.  Intended to
     be used as a report for printing.
*/
    procedure payment_listing_by_unit(punit in varchar2 := null, pfiscalyear in varchar2 := null);

/*
     Shows a page that lists all units that are subordinate to the
     unit passed in; only those units that have paid expenses and
     that the unit passed in is the reviewing unit for will be shown
     They are shown with a total amount due, and links will allow
     a transfer of funds to be initiated in the system.
     This listing will be filtered by the fiscal year chosen, currently
     defaults to the current fiscal year.
*/

    -- Reconcile Account
    procedure reconcile_account(name_array in owa.vc_arr, value_array in owa.vc_arr);

/*
    Generates a webpage that allows a C-Funds custodian to save the working fund
    balance.  It also allows the custodian to check their account details by
    linking to the custodian change log.

    This procedure uses the "Flexible Parameter Passing" mechanism since we
    don't know how many parameters need to be processed.

*/

    -- Advance Repayments
    procedure repayment_details(
        pcommand        in   varchar2 := null,
        padvance        in   varchar2 := null,
        psid            in   varchar2 := null,
        pcash_amount    in   number := null,
        pcheck_amount   in   number := null,
        punit           in   varchar2 := null,
        pparams         in   varchar2 := null,
        pfiscalyear     in   varchar2 := null);

/*
    Generates a webpage that contains details of a selected Advance Repayment.
    This webpage is also used to create a new Advance Repayment.

    pCommand: Indicates what type of button the user pushed. Valid
            options are: Create Repayment.
    pSID: Indicates the SID of the repayment that the user selected. Valid
            SIDs come from T_CFUNDS_ADVANCE_REPAYMENT_V2.  This SID is passed here
            from the items listed on the Advance_Details webpage.

    pCash_Amount:
    pCheck_Amount:
            All the above parameters hold the text string data from the corresponding
            text field in the web form.  No code controls this, it is automatically
            done by server processing.
*/

    -- Transfers
    procedure transfer_details(
        pcommand      in   varchar2 := null,
        psid          in   varchar2 := null,
        psend_to      in   varchar2 := null,
        pamount       in   number := null,
        ptype         in   varchar2 := null,
        punit         in   varchar2 := null,
        pnulldate     in   number := null,
        pfiscalyear   in   varchar2 := null);

/*
    Generates a webpage that contains details of a selected Transfer.
    This webpage is also used to create a new Transfer.

    pCommand: Indicates what type of button the user pushed. Valid
            options are: Send Transfer, Transfer Received.
    pSID: Indicates the SID of the transfer that the user selected. Valid
            SIDs come from T_CFUNDS_XFR.  This SID is passed here
            from the items listed on the Transfers webpage.

    pSend_To:
    pAmount:
            All the above parameters hold the text string data from the corresponding
            text fields in the web form.  No code controls this, it is automatically
            done by server processing.
    pNullDate: Checkbox control.  When checked, indicates that the transfer should
               be created but not sent.
*/
    procedure transfer_form(psid in varchar2 := null);

/*
    Generates a pop-up webpage that shows details of the specified transfer (looks it up
    by the pSID value).  Intended to allow custodians to get signatures on paper to
    satisfy auditors requirements.
*/
    procedure transfers(punit in varchar2 := null, pfiscalyear in varchar2 := null);

/*
    Generates a webpage that lists all the Transfers for the current usre's Unit.
    It is called from a link on the Home_Page.  It should only show up when there
    is more than one transfer to list.
*/
    procedure unit_list(name_array in owa.vc_arr, value_array in owa.vc_arr);

    procedure test_payment_listing(punit in varchar2);

/*
  Used for testing/debugging only.   Used when debugging is needed for Manage_Limitations.

  Output is the total limitation (organizational) for the unit sent in in pUnit.
  Subordinate units are shown with their unit limitation so you can see how the
  calculation is done.

  If this is run on a subordinate unit that is not a reviewing unit (unit has no
  other units under it), then the organizational limitation is 0.  This is correct,
  but this page will say that there are problems.  The important thing at this level
  is the starting limitation only!
*/
    procedure search_expadv(
        punit          in   varchar2 := null,
        psearchtoken   in   varchar2 := null,
        pbtnsearch     in   varchar2 := null);

/*
    Search Expenses and Advances  -- searches the voucher, description, narrative fields
*/
    procedure dfo_details(
        psid          in   varchar2 := null,
        ptypecode     in   varchar2 := null,
        pfiscalyear   in   varchar2 := null,
        psenddate     in   varchar2 := null,
        punit         in   varchar2 := null,
        pdfo          in   varchar2 := null,
        pamount       in   varchar2 := null);

/*
    Do DFO advances and repayments  -- give the user with the right permissions to
    to enter a DFO transfer.
*/
    procedure dfo_by_unit(punit in varchar2 := null, pfiscalyear in varchar2 := null);

/*
    List the DFOs by Unit  --  List in table style the DFO's entered by the user.
*/
    procedure zero_region_unit(
        punit        in   varchar2 := null,
        pparent      in   varchar2 := null,
        pstartdate   in   date := null,
        penddate     in   date := null);

    procedure zero_all(name_array in owa.vc_arr, value_array in owa.vc_arr);

    procedure reinit_region_unit(
        punit        in   varchar2 := null,
        pchild       in   varchar2 := null,
        pstartdate   in   date := null,
        penddate     in   date := null);

    procedure reinit_all(name_array in owa.vc_arr, value_array in owa.vc_arr);
end; 
/

