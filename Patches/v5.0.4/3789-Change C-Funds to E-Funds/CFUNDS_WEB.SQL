SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY Cfunds_Web IS
/*
    Cfunds_Web - Holds E-Funds related web routines that generate html
                 and send the web pages to the server.

      NOTE:
          If you make a new package to use in iol web stuff, you
          need to run this command once (use the new package name in <<here>>)-
          'grant execute on <<cfweb_angela>> to iol_public'
          Run that in SQl window by itself once.

     Instructions for dumping data from the pipe:
    use:.
    begin
      CORE_LOGGER.Dump_Em('WEB',1);
    end;
        Note: if you ever need to get a variable declared, use 'declare' and then put in your variable definintion above the begin word.


    History:
        11-Jul-03 RWH   Original version.
        13-Oct-03 CLJ   Added EFT Info procedure, updated form 28 & 29.
        28-Oct-03 RWH   Updated Unit_List to support an Active flag.
        05-Nov-03 CLJ   Changed hard-coded fiscal years in form 28 & 29 to 2004.
                        <TESTING> Passed. Opened each form and saw change.
        13-Nov-03 CLJ   Updated PaymentListing code and EFT code to function correctly.
        13-Nov-03 RWH   Added explicit dbms_sql.close_cursor calls for each
                        dynamic cursor.
        18-Nov-03 CLJ   Removed close_cursor calls after cellsprint, since they cause errors.
        19-Nov-03 CLJ   Improved earlier fix to payment listing code to prevent
                        all units from seeing HQ's expenses.
        24-Nov-03 CLJ   Added checkboxes to the Expense details for
                        "Take from Advance" and "Take from other sources" options.
                        * corresponding change to Expense details template needed.
                        Added code to allow user to change these options.
                        Added code to allow update of certain fields when
                        "Process Payment" is done.
                        Changed code showing "Receipts forwarded to"
                        to say "Receipts sent to dossier".  * Corresponding
                        change to DB table data necessary (T_CFUNDS_RECEIPT_DISPOSITION).
        05-Dec-03 CLJ   Modified Home_Page_Guts to show pending outgoing and incoming
                        transfer counts and links.
                        Modified Transfer_Details to allow a pending transfer to be
                        sent out.  Also in Transfer_Details, changed button name from Complete Repayment
                        to Send Working Funds. * corresponding change to Menu table done too.
                        Modified Transfer_Form to show the Type (was hard-coded to
                        "Working Fund Transfer").
                        Modified Transfer_Details to allow a transfer to be created
                        without being sent (by leaving the sent date null).
                        Modified Transfers [List of Transfers] to show the
                        status in red so user can find new ones easily (later we can
                        add filters to this page).
                        In Payment_Listing_Details, the Payment listing is now split into
                        a Reviewed list that is available to create a Expense Reimbursement Transfer
                        on, and an Unreviewed list that shows expenses that need to be reviewed.
                        A new privilege (intended only for HQ) allows a button to be seen on
                        this screen that will mark all unreviewed expenses as reviewed at one time.
                        The only other way to mark an expense as reviewed is to go into the expense
                        details page and press the 'Reviewed' button.  This is how the Regions
                        will do their reviews.
                        In Expense_Details, a new button was added to allow the Expense to be
                        marked as Reviewed.  Other optimizations were done at the same time,
                        including hiding data that isn't relevant (Repayment details before
                        it is possible to fill the Repayment amount in), and making some
                        fields labels when they are read-only (category and paragraph).
        10-Dec-03 CLJ   Modified Expense_Details so that the instructions for how
                        to indicate that the expense has been taken from the advance
                        are showing up on the screen if applicable.
                        Added code to allow radio buttons in Transfer_Details to have
                        tooltips and labels allowing a click on label to change the
                        value of radio button.
        12-Dec-03 CLJ   Modified Expense_Details to fix the bug where the Repayment
                        of a Disallowed expense was not working correctly.
                        Turned the Outstanding column of the Form 28 always on
                        so a running total can be seen for debugging in the field.
                        Turned OFF the checkboxes being editable when an expense is
                        in the Disallowed state.
        15-Dec-03 CLJ   Modified Form28 method to make the Expense Repayment
                        type of transfer be subtracted from the outstanding amount column.
        30-Dec-03 CLJ   Transfer_Details: added an ID Number column to the Expense List.
                        Added an Order By to the query in the Advances_By_Personnel method.
                        Started a method (Expense_Newone) to create a new expense in the Web System.
        02-Jan-04 CLJ   Modified Expense_from method to call the new cfunds_exp_form_preamble
                        template that allows the user to enter a name of a custodian.
        07-Jan-04 CLJ   Modified the Form28 code so that the "actual Total Accountability" is calcualted
                        a little differently, goes along with the change that was done on 15-Dec-03.
                        Since this wasn't put in back in Dec, the total accountability
                        was always different in from 28 (very bad).
        17-Feb-04 CLJ   Added a new 'hidden' debugging method called 'TEST_PAYMENT_LISTING' to
                        help find a problem seen up at OSI.
        20-Feb-04 CLJ   Added some debugging code to Manage_Limitations, need to grab latest
                        template when this is released.  Show by using "&pDebug=true"
        19-Mar-04 CLJ   Modified Expense_Details to allow new expenses to be created.
                        Also makes expense Details screen more user-friendly and editable more.
        05-Apr-04 CLJ   Expense Details NOT DONE!!!
                        Modified Form 28 procedure to match new requirements.  Can't be
                        turned on until Form 29 is fixed.  Also need fix to Working Fund Transfer Report.
                        Parallel changes to the Form 28 fix: Template update; and
                        modification to the menu table to change the "Expenditure Log" into
                        "Transaction Log" on left-hand side menu.
        14-Apr-04 AES   Updated the sort order for Unit data combo boxes to sort by CODE rather than NAME.
                        Added HTML "label for" code so that checkboxes can be checked by clicking on the label.
        15-Apr-04 AES   In Build_filterBar, renamed Fix Expense button to Re-submit Fixed Expense button.
        15-Apr-04 AES   Updated Build_FilterBar to check the correct checkboxes (modified v_item_name and v_FilterBar definitions).
        19-Apr-04 CLJ   Removed "Expense_Newone" method.
        23-Apr-04 AES   Modified Advance_Details to update T_CFUNDS_ADVANCE_V2 table NARRATIVE for Approve and Process Payment.
        12-May-04 AES   Updated Advance_Form30 with v_Signature variable and Replace_Tag for SIGNATURE_BLOCK and CUSTODIAN_NAME.
        18-May-04 AES   Added a generic Cfunds_Form_Preamble to Advance_Form30 and Updated Expense_Form to use the same preamble.
        26-May-04 CLJ   Modified "payment_listing_form" to allow longer lists of expenses
                        to print out.  Fixes a problem seen at HQ where a long payment listing
                        couldn't be printed.
        27-May-04 CLJ   Modified "Payment_Listing_Details" to check for the privilege to send
                        a Payment Listing transfer that has already been created but just
                        needs to be sent.  Priv check was missing in here.
                        Also modified "transfer_details" to remove one un-used variable (v_Receiver).
        21-Jun-04 CLJ   Modified many methods to make form 28, Form 29 and Transfer details work.
                        This check-in is being done to send to client for testing before it is released.
                        THere are many parts of this that will not be moved over to the
                        CFunds_Web package, since some of it is not finished.  The Expense_Details
                        in particular is very bad and should be ignored.  There are some
                        templates that go with this code, "cyohe_cfunds_form_28",
                        "cyohe_cfunds_form_29", "cyohe_cfunds_transfer_form",
                        "cfunds_form29_preamble", and "cyohe_cfunds_expense_details".
                        Also, the transfer_form method is not finished and has some debugging
                        messages appearing.
                        DO NOT MOVE ALL THIS CODE OVER TO CFUNDS_WEB PACKAGE!!!
        23-Jun-04 CLJ   Added code to Home_Page_Guts and corresponding template to show
                        a drop-down for the selected fiscal year.
        24-Jun-04 AES   Moved code in Advance_Details so update to Narrative occurs after Approve_Advance and Issue_Advance.
        28-Jun-04 CLJ   Modified methods to make form 28 and Form 29 work: form28 and form29.
                        New methods to support these changes: Validate_Claimant, Validate_Form29,
                         Validate_Expense_Details, Validate_Advances_Repaid, Validate_Expenses_TFOS,
                         Validate_DER_Processing, Fake_Get_Unit_WF_Balance.
                        New templates that go with this code: "cfunds_form_28",
                        "cfunds_form_29", "cfunds_form29_preamble".
        30-Jun-04 CLJ   New function "Validate_Expenses_TFOS_2" written to help find expenses
                        that need to have a way to record that the agent was paid the money (Form29).
                        Added new parameter to "form29" to allow user to skip corrupt data checking.
        12-Jul-04 CLJ   Modified 'home_page_guts' procedure to show error message for units who don't
                        have a limitation set up.  Also renamed template "home_page_guts" to
                        "cfunds_home_page_guts" to match standards.  Also, replaced the
                        'Unavailable' word (for Percent Obligated) to just be a dash ('-').
        16-Jul-04 CLJ   Modified the expense_form method to use Serve_Clob instead of Serve_Page
                        to prevent an error.
                        Modified 'home_page_guts' method to show a special link when the
                        limitation has been changed.  New template needed:  'cfunds_page_background_begin'.
        28-Jul-04 CLJ   Modified 'home_page_guts' method to not show the special red link
                        for units at the bottom level of the hierarchy... these bottom units
                        always have a target limitation of 0 but don't need to react.
        17-Aug-04 CLJ   Added Fiscal Year parameters to many many methods; this change impacts
                         nearly every form in CFMS.  Almost every screen interface shows
                         either a drop-down picklist or label to indicate the fiscal year
                         for the current session.  Other minor fixes done at the same time:...
                        Transaction Log and Custodian Change form links now open a new
                         browser window instead of using the same one (prevents the user from
                         having to use the browser's Back button).
                        Advances now show the Amount of money Remaining in the list of Advances
                         and on the Advance Details page.
                        Filter interface for Advances and Expenses lists has improved, can now
                         choose unit and fiscal year in addition to lifecycle states.  Also, button
                         was renamed to say 'Apply Filters to List'.
                        Home Page has a new link to show if items exist for a previous fiscal year
                         or not, if so the link shows a pop-up message that tells the user
                         what items are outstanding in the previous fiscal year.
                        Manage Limitations screen has been improved with instructions and red numbers
                         to indicate if user needs to do something.
                        "Payment Listing" should now replace all instances where it showed "Expense
                         Reimbursement".
                        New Manage CFMS link to allow HQ custodian to manage limitation for all OSI
                         and also set up EFT information.
        22-Sep-04 CLJ   Added a new section in Expense_Details to allow the custodian to
                         enter payment details for an expense that was marked Take from Other Sources.
                        Modified the Expense_form to show the details of payments,
                         similar to the Advance form, with signature spaces next to
                         the cash amount and check amounts.
        23-Sep-04 AES   Updated Unit_List to prevent user from making a unit inactive if it has open
                         advances, expenses, or transfers.
                        Updated all select statements which obtain unit name information
                         to check the ACTIVE value in T_CFUNDS_UNIT and add the text '(INACTIVE CFUNDS UNIT)'
                         to the unit name if T_CFUNDS_UNIT.ACTIVE='N'.
        24-Sep-04 CLJ   Added code to "Home_Page_Guts" procedure that looks for Payment
                         Listings in past fiscal years and shows details in the pop-up
                         if there are.  Past Fiscal years now show a link to the Payment
                         Listings page if there are payment listings to process.  Also
                         Optimized code in Home_page_guts by using a new view that
                         is a simplified version of v_cfunds_expense_v3. It is called
                         V_CFUNDS_EXPENSE_V3_STATUS_LIM.
        24-Sep-04 CLJ   Fixed bug in "Expense_Details", some buttons didn't show up.
                        Also fixed format strings to allow longer numbers to show up.
        30-Sep-04 AES   Updated Manage_Limitations to check that the user's unit is a reviewing unit and
                         that the user has the 'Set Expense Limitation' privilege
                         before allowing the user to Update CFunds Limitations.
        30-Sep-04 CLJ   Modified "Form28" to show expenses that are TFOS (Take From Other Sources)
                         as a disbursement when the TFOS payment has been done.
                         Also modified "Fake_Get_Unit_WF_Balance" to include the TFOS amounts
                         in the calculation of the Working Fund Balance.
                         Another change to go along with these is to "Validate_Expenses_TFOS_2"
                         This procedure was changed to ignore closed expenses that were processed
                         using the new TFOS_ fields, since they aren't incorrect any longer.  Some
                         incorrect data may still exist from before these fields were in the system.
-- angela change - merge.
        06-Oct-04 AES   Updated length of Home_Page_Guts (v_command1_specs) and Transfer_Details (v_command2_specs)
                         variables from varchar(100) to varchar(200).
        25-Oct-04 CLJ   Updated code in "Form28" procedure so the balance from the previous fiscal
                         year will be the starting balance for the new fiscal year.
        xx-Oct-04 CLJ   Added new procedure, Reconcile_account.
                         NEED TO: Replace Fake_Get_Unit_WF_Balance with TempGet_Unit_WF_Balance.
        17-Jan-05 CLJ   Took out the fourth parameter to the cellsprint call in transfer procedure;
                         this was a customized solution but can't work in Oracle 10g so code needs
                         rewrite to make 'nowrap' again an attribute on cells in table.
        16-May-05 GEG   Updated the Fake_Get_Unit_WF_Balance procedure to round off calculations with the CONVERSION_RATE division.
                         John Biggs request for rounding off calculations that have in Fake_Get_Unit_WF_Balance.
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
        31-Aug-05 JAT    Added routines for next and previous payment listing.  Fixed a payment listing
                         bug.
       
  25-Jan-06 JDB  Made starting accountability for form28 always 0.
  18-Jul-07 JDB  Fix transfers from to show special transfers to the same unit(self/DFO) only once.
  18-Jul-07 JDB  Added Totals to the payment listing titles in the outstanding payment listing section of form 29 (Audit)
  18-Jul-07 JDB  Attempt to fix liabilities in form 29 to work for regions. Current year liabilities were not printing.
  20-Jul-07 JDB  Made Fiscal Year Label on Expense Details accurate for old expenses.
  20-Jul-07 JDB  Added DFO as part of incoming and outgoing transfers on a form 29 (Audit)
  20-Jul-07 JDB    Added to DER section to include DERS recieved by a parent after FY change. Form 29 (audit)
  20-Jul-07 JDB  Added EOY payment listings to subunits in expense section for 24 EFIS only due to special circumstances. Form 29 (audit)
  20-Jul-07 JDB  Subtract Liabilities from section 2 of the form29 (audit) to improve understandability.
  24-Jul-07 JDB  Use get accountability function for the home page but highlight in red if the totals don't match.
  26-Jul-07 JDB  Added a negative sign to the liabilities value.
  26-Jul-07 JDB  Added subtotals to section 2C
  20-Sep-07 JDB  Modified from 28 and form28print to Show unreceived DFAS transfers.to HQ
  20-Sep-07 JDB  Modified Transfers + payment listing by Unit to use the correct Order By
  20-Sep-07 JDB  Modified Payment Listings By Unit and Payment Listing Details to show voucher numbers where applicable. Also needed modifications to the Web Template.
  20-Sep-07 JDB  Modified Form 29, Form28, and Form28Print to account for (WF) funds sent back to DFAS
  21-Sep-07 JDB  Modified PrintForm28 to match the logic of Form28.
  24-Sep-07 JDB  Changed AT to PJ in Adjust AFOSI limitations. Modified template too.
  01-Oct-07 JDB  Added EOY 'Expenses for Sub-Units not Paid Down' section to from29 Local Expenses Section.
  11-Jan-07 JDB  Changed form29 sent transfers to include WF transers sent of a FY.
  26-Sep-08 RND   Modified HOME_PAGE to accept a ticket parameter
  12-May-09 MAB  Copied from WEB schema, renamed it, and modified calls to all database objects that
                 do not exist in the current schema.
  14-Jul-09 JDB   Adjusted Payment Listing from to include the new PEC
  21-Apr-10 RND  Modified the current template to add new PEC Codes that JDB put in prior
  13-Jul-10 JLH  Updated action types used for cfunds_test_cfp to those used by WEBI2MS.
  24-Aug-10 TJW  WCH00000318 Changed hard coded sids 1010005M and 10100023. 
  01-Oct-10 JDB  ADjusted form 29. Commented out a union in the Local Expenses section.
  01-Oct-10 JDB  Adjusted from 29. Exclueded EOY Rejected Expenses which are already on a paylisting because they are counted elsewhere.
  21-Dec-10 TJW  PR#3467 - Changed the two Update v_cfunds_expense_v3 to Update t_cfunds_expense_v3 because the changes to the view for
                  WebI2MS makes the view Not Updatable.
  23-Feb-11 TJW  Added and un.END_DATE is null to the unit select in home_page_guts to stop duplicate units.
  25-Jul-11 TJW  CR#3881 - Add Amount Remaining to home page.
                  Changed in home_page_guts.
  15-Aug-11 TJW  CR#3789 Change C-Funds to E-Funds and CFMS to EFMS.                  
  30-Sep-11 JDB Added 5 changes to the form 29 for end of year

*/

    -- constants
    v_nl                       VARCHAR2(10)    := CHR(13) || CHR(10);
    c_pipe                     VARCHAR2(20)    := Core_Util.get_config('CORE.PIPE_PREFIX') || 'CFUNDS_WEB';
    v_amount_format            VARCHAR2(25)    := '999,999,999,999,990.00';
    v_dollar_format            VARCHAR2(25)    := '$999,999,999,999,990.00';
    v_conversion_rate_format   VARCHAR2(25)    := '999,999,999,999,990.0099';
    v_error_detail             VARCHAR2(1000);
    v_hq_cc_unit_sid           VARCHAR2(20)    := Core_Util.get_config('OSI.HQ_CC_UNIT_SID');
    v_fis24_unit_sid           VARCHAR2(20)    := Core_Util.get_config('OSI.UNIT_FIS24_SID');

    -- Fiscal year before system startup (used to test fiscal year change).
    -- first actual fiscal year for OSI is 2004, can change it here if need be.
    v_first_fiscal_year        VARCHAR2(10)   := '2004';

    -- Private Exceptions
    a_stink                    EXCEPTION;

    -- Private (support) Routines
    PROCEDURE append_info_to_clob(
        poriginal    IN OUT NOCOPY   CLOB,
        pappend      IN              VARCHAR2,
        pseparator   IN              VARCHAR2 := ', ') IS
        -- these local variable are used only for error reporting
        v_orig         VARCHAR2(50);
        v_len_orig     NUMBER;
        v_len_append   NUMBER;
        v_len_sep      NUMBER;
    BEGIN
        v_orig := dbms_lob.SUBSTR(poriginal, 50, 1);         -- save in case we need to report them
        v_len_orig := NVL(dbms_lob.getlength(poriginal), 0);
        v_len_append := NVL(LENGTH(pappend), 0);
        v_len_sep := NVL(LENGTH(pseparator), 0);

        IF poriginal IS NULL THEN                                             -- create a temp clob
            dbms_lob.createtemporary(poriginal, TRUE);
        END IF;

        IF dbms_lob.isopen(poriginal) = 0 THEN                               -- open it (read-write)
            dbms_lob.OPEN(poriginal, dbms_lob.lob_readwrite);
        END IF;

        IF pappend IS NOT NULL THEN                                      -- we're gonna do something
            IF v_len_orig > 0 AND v_len_sep > 0 THEN                          -- need the separator
                dbms_lob.writeappend(poriginal, v_len_sep, pseparator);
            END IF;

            dbms_lob.writeappend(poriginal, v_len_append, pappend);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it('I2MS', 'Append_Info_to_Clob Error: ' || SQLERRM);
            Core_Logger.log_it('I2MS',
                               '  Orig/Append/Sep lengths: ' || v_len_orig || '/' || v_len_append
                               || '/' || v_len_sep);
            Core_Logger.log_it('I2MS', '  Start of Orig: ' || v_orig);
-- by not re-raising the exception, the routine will complete
-- without error, and pOriginal will be as full as it can be.
    END append_info_to_clob;

    FUNCTION date_precision(pdate IN DATE)
        RETURN VARCHAR2 IS
        v_rtn    VARCHAR2(100);
        v_mm     VARCHAR2(2);
        v_dd     VARCHAR2(2);
        v_time   VARCHAR2(6);
    BEGIN
        v_mm := TO_CHAR(pdate, 'mm');
        v_dd := TO_CHAR(pdate, 'dd');
        v_time := TO_CHAR(pdate, 'hh24miss');

        IF v_time = '000000' THEN
            v_rtn := 'Day';
        ELSIF v_mm = '01' AND v_dd = '01' AND v_time = '000002' THEN
            v_rtn := 'Year';
        ELSIF v_dd = '01' AND v_time = '000001' THEN
            v_rtn := 'Month';
        ELSE
            v_rtn := 'Second';
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it('I2MS', 'Error in Date_Precision: ' || SQLERRM);
            RETURN NULL;
    END date_precision;

    FUNCTION get_html_fy_dropdown(pfiscalyear IN VARCHAR2 := NULL, pname IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_html   VARCHAR2(30000);
        v_year   VARCHAR2(10);                           -- index through the possible fiscal years
        v_name   VARCHAR2(100);
    BEGIN
        v_name := NVL(pname, 'SelectFiscalYear');
        -- setup fiscal year selector control.
        v_html := '<select ID="' || v_name || '" NAME="' || v_name || '" size="1">';
        v_year := v_first_fiscal_year;                            -- Fiscal year at system startup.

        LOOP
            EXIT WHEN v_year > Cfunds_Pkg.get_fiscal_year(SYSDATE);

            IF NVL(pfiscalyear, v_year) = v_year THEN
                v_html := v_html || '<option selected value="' || v_year || '">' || v_year;
            ELSE
                v_html := v_html || '<option value="' || v_year || '">' || v_year;
            END IF;

            v_year := v_year + 1;                 -- add one year for each year since system startup
        END LOOP;

        v_html := v_html || '</select>';
        RETURN v_html;
    END get_html_fy_dropdown;

    PROCEDURE menu(pshowbackbutton IN BOOLEAN := FALSE, ppreviousvalue IN VARCHAR2 := NULL) IS
/*
Displays the menu on the left side of the window.
Menu items can be changed in T_CFUNDS_MENU_ITEMS.

This routine is not in alphabetic order since it is used by Begin_Serve_Page.
*/
        v_pvalue          VARCHAR2(200);
        v_template        CLOB;
        v_template_date   DATE;
        v_frag            VARCHAR2(32000);
        v_group           NUMBER          := -9999;
        v_ok              BOOLEAN;
        v_skip_this       BOOLEAN         := FALSE;
        v_current_page    VARCHAR(1000);
    BEGIN
        Core_Logger.log_it(c_pipe, '>>>> Cfunds_Web.Menu');
        v_ok := Web_Template_Pkg.get_latest('cfunds_menu', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_menu"');
            htp.print('Could NOT locate template');
            RETURN;
        END IF;

        --htp.p('pPreviousValue is ' || pPreviousValue); -- use for debugging only
        IF pshowbackbutton THEN
            -- set the default value if the user has not passed in the url the backbutton will go to if clickec.
            v_pvalue := NVL(ppreviousvalue, 'home_page');
            v_ok :=
                Web_Template_Pkg.replace_tag
                    (v_template,
                     'BACK_BUTTON',
                     '<a href="vbscript:PreviousButton(&quot;' || Web_Util_Pkg.get_current_package
                     || ppreviousvalue
                     || '&quot;)" id="PreviousButton" style="background:/images/I2ms/100middle.bmp"><img src="/images/I2ms/BackButton2.bmp"></a>');
        ELSE
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'BACK_BUTTON', ' ');
        END IF;

        v_frag := NULL;

        FOR m IN (SELECT   *
                      FROM T_CFUNDS_MENU_ITEMS
                  ORDER BY link_group, seq)
        LOOP
            IF m.link_group > 0 AND m.seq > 0 THEN
                v_skip_this := FALSE;

                IF (m.seq = 49) THEN
                    -- check for priv at HQ level
                    IF Cfunds_Test_Cfp('CF_LIM_SET_ORG',
                                       Core_Obj.lookup_objtype('NONE'),
                                       Core_Context.personnel_sid,
                                       v_hq_cc_unit_sid) = 'N' THEN
                        v_skip_this := TRUE;
                    END IF;
                END IF;

                IF (m.seq = 15) THEN                   -- reconcile account not ready for prime time
                    v_skip_this := TRUE;
                END IF;

                IF NOT v_skip_this THEN
                    IF m.link_group <> v_group THEN
                        v_frag := v_frag || '<tr height="10"><td></td></tr>';
                    END IF;

                    v_group := m.link_group;

                    IF m.seq <= 50 THEN
                        -- E.G. Because Get_Current_Package return correctly the page calling it to include the ! that were thrown away
                        -- in 8i, the following menu building breaks if we don't remove the ! from the call to Get_Current_Package.
                        -- There will be a tendency to have one to many ! in the page call therefor corrupting the call to the page.
                        -- This of course depends on the the page building the menu links.  Therefore the replace method included in building the links.
                        IF LOWER(SUBSTR(m.href, 1, 12)) = 'cfunds.form2' THEN
                            -- form28 and from29 get opened in a new window; this is done with javascript code.
                            v_frag :=
                                v_frag || '<tr><td><a href="javascript:MenuLinksToPopup('''
                                || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                || SUBSTR(m.href, 8) || ''')';
                        ELSIF LOWER(SUBSTR(m.href, 1, 7)) = 'cfunds.' THEN           -- case of page
                            IF (   SUBSTR(m.href, -1, 1) = '?'
                                OR (SUBSTR(m.href, -1, 1)) = '&') THEN
                                v_frag :=
                                    v_frag || '<tr><td><a href="vbscript:MenuLinks(&quot;'
                                    || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                    || SUBSTR(m.href, 8) || '&quot;)';
                            ELSE
                                v_frag :=
                                    v_frag || '<tr><td><a href="'
                                    || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                    || SUBSTR(m.href, 8);
                            END IF;
                        ELSIF     LOWER(SUBSTR(m.href, 1, 8)) = '!cfunds.'
                              AND (   SUBSTR(m.href, -1, 1) = '?'
                                   OR (SUBSTR(m.href, -1, 1)) = '&') THEN
                            v_frag :=
                                v_frag || '<tr><td><a href="vbscript:MenuLinks(&quot;!'
                                || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                || SUBSTR(m.href, 9) || '&quot;)';
                        ELSE
                            v_frag := v_frag || '<tr><td><a href="' || m.href;
                        END IF;

                        v_frag := v_frag || '">' || m.NAME || '</a></td></tr>';
                    END IF;
                END IF;
            END IF;
        END LOOP;

        v_ok := Web_Template_Pkg.replace_tag(v_template, 'MENU_LIST', v_frag);
        v_ok := Web_Template_Pkg.serve_clob(v_template);
        Core_Logger.log_it(c_pipe, '<<<< Cfunds_Web.Menu');
    END menu;

    PROCEDURE msgbox(pmsg IN VARCHAR2) IS
/*
This routine is used for debugging only.  It will pop up
a message window when the form is loading with the message.
*/
    BEGIN
        htp.print('<script language="JavaScript" type="text/javascript">');
        htp.print('<!--');
        htp.print('msgbox("' || pmsg || '");');
        htp.print('//-->');
        htp.print('</script>');
    END msgbox;

    PROCEDURE setunitsid(punit IN VARCHAR2 := NULL) IS
/*
This routine is used for setting the unit sid.
*/
        v_unit_sid   T_CFUNDS_UNIT.SID%TYPE;
    BEGIN
        -- find the unit to default to if not sent in as a parameter
        v_unit_sid := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
        htp.print('<script language="vbscript" type="text/vbscript">');
        htp.print('<!--');
        htp.print('SetUnitSid("' || v_unit_sid || '")');
        htp.print('//-->');
        htp.print('</script>');
    END setunitsid;

    PROCEDURE set_fiscal_year(pfiscal_year IN VARCHAR2 := NULL) IS
/*
This routine is used for setting the fiscal year.
*/
        v_fiscal_year   VARCHAR2(10);
    BEGIN
        -- find the fiscal year to default to if not sent in as a parameter
        v_fiscal_year := NVL(pfiscal_year, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        htp.print('<script language="vbscript" type="text/vbscript">');
        htp.print('<!--');
        htp.print('SetFiscalYear("' || v_fiscal_year || '")');
        htp.print('//-->');
        htp.print('</script>');
    END set_fiscal_year;

    PROCEDURE setvparams(vparams IN VARCHAR2 := NULL) IS
/*
This routine will make a inline vbscript call to set page calling paramters.
*/
    BEGIN
        htp.print('<script language="vbscript" type="text/vbscript">');
        htp.print('<!--');
        htp.print('SetVParams("' || vparams || '")');
        htp.print('//-->');
        htp.print('</script>');
    END setvparams;

    PROCEDURE begin_serve_page(
        ppagetitle        IN   VARCHAR2 := 'E-Funds',
        pshowmenu         IN   BOOLEAN := FALSE,
        pshowbackbutton   IN   BOOLEAN := FALSE,
        pheader1          IN   VARCHAR2 := ' ',
        pheader2          IN   VARCHAR2 := ' ',
        ppreviousvalue    IN   VARCHAR2 := 'home_page') IS
/*
This is the routine that starts the HTML page code.  IT MUST be
used in conjunction with End_Serve_Page, since it is only designed
to get the HTML to a point where the guts of the page can be created by
a different routine.

End_Serve_Page will create the end tags for the table cell, row, table, body and html page.

Call this proc with no parameters to just get a page border;
use parameters when you want the 'extras'
pPageTitle should always be used; this is what shows as the Title in the browser
window.
*/
        v_template        CLOB;                                -- holds the html previously written
        v_template_date   DATE;                  -- date of the most recent version of the template
        v_offset          NUMBER        := 1;
        -- number indicating how many characters of the template have been sent to the browser ('served').
        v_tag             VARCHAR2(100);
        -- holds the name of the replacement tag that was found by the Serve_Page routine.
        v_ok              BOOLEAN;                           -- flag indicating success or failure.
    BEGIN
        Core_Logger.log_it(c_pipe, '>>>> Cfunds_Web.Begin_Serve_Page');
        -- get the actual template text string (this is the html that will make the web page)
        v_ok :=
            Web_Template_Pkg.get_latest('cfunds_page_background_begin', v_template,
                                        v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe,
                               '  Could not locate template "cfunds_page_background_begin"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- get the URL to allow this form to call itself back when an action happens.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
-- replace the SELF tag (in the <form method="POST" action=/pls/iol/cfunds.expenses_by_personnel> string)
      -- link for home page in upper left corner, on the '100' logo of bill image.
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'HOME_PAGE',
                                         REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                         || 'home_page');
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'PAGE_TITLE', ppagetitle);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'BACK_BUTTON', 'BACK');

        -- comment out the part of code that doesn't apply when showing/hiding menu.
        IF pshowmenu = TRUE THEN
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SINGLE_CELL_GUTS_START', '<!--');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SINGLE_CELL_GUTS_END', '-->');
            -- replace non-applicable tags just to get them out of the html.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DUAL_CELL_GUTS_START', ' ');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DUAL_CELL_GUTS_END', ' ');
        ELSE
            -- replace non-applicable tags just to get them out of the html.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SINGLE_CELL_GUTS_START', ' ');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SINGLE_CELL_GUTS_END', ' ');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DUAL_CELL_GUTS_START', '<!--');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DUAL_CELL_GUTS_END', '-->');
        END IF;

        v_ok := Web_Template_Pkg.replace_tag(v_template, 'HEADER1_HEADER_TABLE', pheader1);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'HEADER2_HEADER_TABLE', pheader2);

        IF pheader1 || pheader2 = '  ' THEN
            -- comment out this table if there are no headings.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'BEGIN_HEADER_TABLE', '<!--');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'END_HEADER_TABLE', '-->');
        ELSE
            -- replace tags just to get them out of the html.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'BEGIN_HEADER_TABLE', ' ');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'END_HEADER_TABLE', ' ');

            -- if there is only one header line, decrease the size of the header table to give more room for other stuff.
            IF pheader2 = ' ' THEN
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SIZE_HEADER_TABLE', '5%');
            ELSIF pheader1 = ' ' THEN
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SIZE_HEADER_TABLE', '5%');
            END IF;
        END IF;

        -- replace this tag with 'default' value if it wasn't replaced above
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SIZE_HEADER_TABLE', '20%');

        -- loop through all the tags not replaced yet.  These will be tags that cannot be replaced
        -- before the page starts to be served.  They instantly throw html code to the client, so we
        -- send the html code (Serve_Page does this) until we get to a tag.  Then the tag is dealt
        -- with, and Serve_Page sends more html code until all tags are done and the end of the
        -- page is found (v_tag is null).
        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'MENU_LIST' THEN
                IF pshowmenu THEN
                    -- call routine to show the menu from a seperate stored template.
                    menu(pshowbackbutton, ppreviousvalue);
                END IF;
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;

        Core_Logger.log_it(c_pipe, '<<<< Cfunds_Web.Begin_Serve_Page');
    END begin_serve_page;

    FUNCTION build_filterbar(pfilters IN VARCHAR2)
        RETURN VARCHAR2 IS
/*
This private routine builds two rows of an HTML table that contains a checkbox filter
for each item represented in the pFilters parameter.  pFilters will be built
specifically for use by this procedure.  Each checkbox item must send 3 parts
to specify the control name, value (checked=on, unchecked=off), and DisplayName.

The function CORE_LIST.Add_Item_To_List must be used to create the pFilters parameter.
The function will be called 3 times for each checkbox, once for each specified part.

This procedure will build all the checkboxes and then add an "Update List" button
on the end.
*/
/*

  <tr>
    <td><input type="checkbox" name="pNew" value="checked" [WEBTOK@NEW_FLAG]></td>
    <td>new&nbsp;&nbsp;</td>
    <td><input type="checkbox" name="pSubmitted" value="checked" [WEBTOK@SUBMIT_FLAG]></td>
    <td>Submitted&nbsp;&nbsp;</td>
    <td><input type="checkbox" name="pApproved" value="checked" [WEBTOK@APPV_FLAG]></td>
    <td>Approved&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td><input type="checkbox" name="pRejected" value="checked" [WEBTOK@REJ_FLAG]></td>
    <td>Rejected&nbsp;&nbsp;</td>
    <td><input type="checkbox" name="pActive" value="checked" [WEBTOK@ACTIVE_FLAG]></td>
    <td>Active&nbsp;&nbsp;</td>
    <td><input type="checkbox" name="pClosed" value="checked" [WEBTOK@CLOSED_FLAG]></td>
    <td>Closed&nbsp;&nbsp;</td>
    <td><input type="submit" value="Update List" name="pCommand"></td>
  </tr>

*/
        v_ok                 BOOLEAN;
        v_item_name          VARCHAR2(100);
        v_item_value         VARCHAR2(100);
        v_item_displayname   VARCHAR2(100);
        v_filterstring       VARCHAR2(1000);
        v_filterbar          VARCHAR2(10000);
        v_count              NUMBER;
        v_item_count         NUMBER;
    BEGIN
        v_filterstring := pfilters;
        -- find the number of checkboxes to make.
        v_count := Core_List.count_list_elements(v_filterstring);

        IF v_count <> 0 THEN
            v_item_count := v_count / 3;
        ELSE
            RETURN ' ';                    -- if there aren't any items then don't build the table.
        END IF;

        -- open row.
        v_filterbar := v_filterbar || '<tr>';
        v_count := 0;

        LOOP
            v_item_name := Core_List.pop_list_item(v_filterstring);
            EXIT WHEN v_item_name IS NULL;
            -- first construct the table cell to contain a checkbox.
            -- give it the appropriate name and enter the "checked" string if it was checked.
            v_item_value := Core_List.pop_list_item(v_filterstring);
            --replace a returned value of 'on' to 'Checked'
            v_item_value := REPLACE(v_item_value, 'on', 'Checked');
            -- then get the display name and put that in the next table cell.
            v_item_displayname := Core_List.pop_list_item(v_filterstring);
            v_filterbar :=
                v_filterbar || '<td><input type="checkbox" name="' || v_item_name || '" id="'
                || v_item_name || '" title="' || v_item_displayname || '" ' || v_item_value
                || '><label for="' || v_item_name || '">' || v_item_displayname || '</label></td>';
            v_count := v_count + 1;

            IF v_item_count = 6 AND v_count = 3 THEN
                -- start a new row if there are 6 total items.
                v_filterbar := v_filterbar || '</tr><tr>';
            END IF;

            IF v_item_count = 8 AND v_count = 4 THEN
                -- start a new row if there are 8 total items.
                v_filterbar := v_filterbar || '</tr><tr>';
            END IF;
        END LOOP;

        --adds some space
        v_filterbar := v_filterbar || '</tr><tr><td height="15" colspan="4">&nbsp;</td>';
        -- put in the button to allow filters to be updated.
        -- this button requires some VBscript code in the template in order to work.
        v_filterbar :=
            v_filterbar
            || '</tr><tr><td colspan="4" align="center">&nbsp;&nbsp;&nbsp;<input type="button" value="Apply Filters to List" name="pBtnRefresh" onclick="Do_Refresh()"></td>';
        -- close row and table
        v_filterbar := v_filterbar || '</tr>';
        RETURN v_filterbar;
    END build_filterbar;

    PROCEDURE end_serve_page IS
/*
This is the routine that ends the HTML page code.  IT MUST be
used in conjunction with Begin_Serve_Page, since it produces the end tags
to complete the HTML after the guts of the page have been created by
a different routine.

This routine creates the end tags for the table cell, row, table, body and html page.
*/
        v_template        CLOB;
        v_template_date   DATE;
        v_offset          NUMBER        := 1;
        v_tag             VARCHAR2(100);
        v_ok              BOOLEAN;
    BEGIN
        Core_Logger.log_it(c_pipe, '>>>> Cfunds_Web.End_Serve_Page');
        v_ok :=
             Web_Template_Pkg.get_latest('cfunds_page_background_end', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_page_background_end"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
        Core_Logger.log_it(c_pipe, '<<<< Cfunds_Web.End_Serve_Page');
    END end_serve_page;

    PROCEDURE home_page_guts(punit IN VARCHAR2 := NULL, pfiscalyear IN VARCHAR2 := NULL) IS
        v_template                      CLOB;
        v_template_date                 DATE;
        v_offset                        NUMBER                   := 1;
        v_tag                           VARCHAR2(100);
        v_query                         VARCHAR2(4000);
        v_cursor                        INTEGER;
        v_cnt                           NUMBER;
        v_ok                            BOOLEAN;
        v_total_amt_spnt_ci             NUMBER;
        v_total_amt_spnt_sai            NUMBER;
        v_total_amt_spnt_fpd            NUMBER;
        v_total_yearly_amount_ci        NUMBER;
        v_total_yearly_amount_sai       NUMBER;
        v_total_yearly_amount_fpd       NUMBER;
        v_unit_sid                      T_CFUNDS_UNIT.SID%TYPE;
        v_query2                        VARCHAR2(4000);
        v_cursor2                       INTEGER;
        v_command1_specs                VARCHAR2(200);
        v_limitation_error              VARCHAR2(1000);
        v_year                          VARCHAR2(10)             := v_first_fiscal_year;
        -- Fiscal year prior to system startup in FY04.
        v_fiscal_year                   VARCHAR2(10);
        v_prior_year_count              NUMBER                   := 0;
        v_count                         NUMBER;
        v_prior_year_message            VARCHAR2(5000);
        v_total_target_limitation_sia   NUMBER;
        v_total_target_limitation_ci    NUMBER;
        v_total_target_limitation_fpd   NUMBER;
        v_wf_balance                    NUMBER;
        v_outstanding_expenses          NUMBER;
        v_outstanding_advances          NUMBER;
        v_total_accountability          NUMBER;
    BEGIN
        Core_Logger.log_it(c_pipe, '--> Cfunds_Web.Home_Page_Guts');
        v_ok := Web_Template_Pkg.get_latest('cfunds_home_page_guts', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_home_page_guts"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- Since we are setting this in Home_page and this procedure is never directly called
        -- Then go ahead and set the Unit Sid.
        v_unit_sid := punit;
        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'SELF',
                                         Web_Util_Pkg.get_self || '?pUnit=' || v_unit_sid);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'pUNIT', v_unit_sid);

-- check if the fiscal year is the current fiscal year; if we are showing data from a past fiscal year,
        -- the values need to be found a different way.
        IF v_fiscal_year = Cfunds_Pkg.get_fiscal_year(SYSDATE) THEN
            -- find the values to display for the selected unit's spending
            v_total_amt_spnt_ci :=
                          NVL(Cfunds_Pkg.get_unitorg_annual_expenses(v_unit_sid, 'CI', SYSDATE), 0);
            v_total_amt_spnt_sai :=
                        NVL(Cfunds_Pkg.get_unitorg_annual_expenses(v_unit_sid, 'S&IA', SYSDATE), 0);
            v_total_amt_spnt_fpd :=
                         NVL(Cfunds_Pkg.get_unitorg_annual_expenses(v_unit_sid, 'FPD', SYSDATE), 0);
            v_total_yearly_amount_ci :=
                        NVL(Cfunds_Pkg.get_unitorg_limitation(v_unit_sid, 'EXP', 'CI', SYSDATE), 0);
            v_total_yearly_amount_sai :=
                      NVL(Cfunds_Pkg.get_unitorg_limitation(v_unit_sid, 'EXP', 'S&IA', SYSDATE), 0);
            v_total_yearly_amount_fpd :=
                       NVL(Cfunds_Pkg.get_unitorg_limitation(v_unit_sid, 'EXP', 'FPD', SYSDATE), 0);
            -- find the current target limitations.
            v_total_target_limitation_sia :=
                         NVL(Cfunds_Pkg.get_unit_limitation(v_unit_sid, 'OXT', 'S&IA', SYSDATE), 0);
            v_total_target_limitation_ci :=
                           NVL(Cfunds_Pkg.get_unit_limitation(v_unit_sid, 'OXT', 'CI', SYSDATE), 0);
            v_total_target_limitation_fpd :=
                          NVL(Cfunds_Pkg.get_unit_limitation(v_unit_sid, 'OXT', 'FPD', SYSDATE), 0);

            -- look to see if the current unit has subordinate units; if not,
            -- don't show a red link.  The units at the bottom level all have
            -- target limitations of '0' for some odd reason, but that doesn't make
            -- it an error.
            IF Cfunds_Pkg.lookup_cfunds_unit(v_unit_sid).reviewing_unit = 'Y' THEN
                -- check if S&IA limitations have changed and replace tag if they have.
                IF v_total_yearly_amount_sai <> v_total_target_limitation_sia THEN
                    -- if limitations have changed, then make the amount show red.
                    --  Note: the following line launches a messageBox from a vbScript routine called 'doMsg'.  This routine is
                    -- located in the "cfunds_page_background_begin" template
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'TOTAL_YEARLY_LIMIT_SAI',
                             '<a href="javascript:void(0)" onclick="doMsg &quot;Your S&IA Limitation has been changed.  Your new limitation is '
                             || trim(TO_CHAR(v_total_target_limitation_sia, v_dollar_format))
                             || '.&quot;,&quot;Alert: S&IA Limitation Change&quot;"><font color="red">'
                             || TO_CHAR(v_total_yearly_amount_sai, v_dollar_format) || '</font></a>');
                END IF;

                -- check if CI limitations have changed and replace tag if they have.
                IF v_total_yearly_amount_ci <> v_total_target_limitation_ci THEN
                    -- if limitations have changed, then make the amount show red.
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'TOTAL_YEARLY_LIMIT_CI',
                             '<a href="javascript:void(0)" onclick="doMsg &quot;Your CI Limitation has been changed.  Your new limitation is '
                             || trim(TO_CHAR(v_total_target_limitation_ci, v_dollar_format))
                             || '.&quot;,&quot;Alert: CI Limitation Change&quot;"><font color="red">'
                             || TO_CHAR(v_total_yearly_amount_ci, v_dollar_format) || '</font></a>');
                END IF;

                -- check if FPT limitations have changed and replace tag if they have.
                IF v_total_yearly_amount_fpd <> v_total_target_limitation_fpd THEN
                    -- if limitations have changed, then make the amount show red.
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'TOTAL_YEARLY_LIMIT_FPD',
                             '<a href="javascript:void(0)" onclick="doMsg &quot;Your FPD Limitation has been changed.  Your new limitation is '
                             || trim(TO_CHAR(v_total_target_limitation_fpd, v_dollar_format))
                             || '.&quot;,&quot;Alert: FPD Limitation Change&quot;"><font color="red">'
                             || TO_CHAR(v_total_yearly_amount_fpd, v_dollar_format) || '</font></a>');
                END IF;
            END IF;

            -- find balance, accountabiltiy, outstanding expenses, outstanding advances
            v_wf_balance := Cfunds_Pkg.get_unit_wf_balance(v_unit_sid, FALSE, SYSDATE);
            v_outstanding_expenses :=
                ABS(Cfunds_Pkg.get_unit_oe(v_unit_sid,
                                           Cfunds_Pkg.get_fiscal_year_start_date(SYSDATE),
                                           Cfunds_Pkg.get_fiscal_year_end_date(SYSDATE)));
            v_outstanding_advances :=
                ABS(Cfunds_Pkg.get_unit_oa(v_unit_sid,
                                           Cfunds_Pkg.get_fiscal_year_start_date(SYSDATE),
                                           Cfunds_Pkg.get_fiscal_year_end_date(SYSDATE)));
            v_total_accountability := Cfunds_Pkg.get_unit_accountability(v_unit_sid);
            --v_wf_balance + abs(v_outstanding_expenses) + abs(v_outstanding_advances);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMT_SPNT_CI',
                                             TO_CHAR(v_total_amt_spnt_ci, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMT_SPNT_SAI',
                                             TO_CHAR(v_total_amt_spnt_sai, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMT_SPNT_FPD',
                                             TO_CHAR(v_total_amt_spnt_fpd, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_YEARLY_LIMIT_CI',
                                             TO_CHAR(v_total_yearly_amount_ci, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_YEARLY_LIMIT_SAI',
                                             TO_CHAR(v_total_yearly_amount_sai, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_YEARLY_LIMIT_FPD',
                                             TO_CHAR(v_total_yearly_amount_fpd, v_dollar_format));

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOTAL_AMT_REMAIN_CI', TO_CHAR(v_total_yearly_amount_ci-v_total_amt_spnt_ci, v_dollar_format));
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOTAL_AMT_REMAIN_SAI', TO_CHAR(v_total_yearly_amount_sai-v_total_amt_spnt_sai, v_dollar_format));
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOTAL_AMT_REMAIN_FPD', TO_CHAR(v_total_yearly_amount_fpd-v_total_amt_spnt_fpd, v_dollar_format));
                                             
            IF v_total_yearly_amount_ci = 0 THEN -- check for 0 to prevent error from division by 0.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PERCENT_OBLIGATED_CI', '-');
                v_limitation_error :=
                    '<b><font color="red">CI Limitation not set - <br> you will not be able to approve any expenses until '
                    || Cfunds_Pkg.lookup_cfunds_unit(Cfunds_Pkg.get_parent_unit(v_unit_sid)).unit_name
                    || ' sets your limitation!</font></b><p>';
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PERCENT_OBLIGATED_CI',
                                                 TO_CHAR(v_total_amt_spnt_ci
                                                         / v_total_yearly_amount_ci * 100,
                                                         '990.00')
                                                 || '%');
            END IF;

            IF v_total_yearly_amount_sai = 0 THEN
                -- check for 0 to prevent error from division by 0.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PERCENT_OBLIGATED_SAI', '-');
                v_limitation_error :=
                    v_limitation_error
                    || '<b><font color="red">S&IA Limitation not set - <br> you will not be able to approve any expenses until '
--               || CFUNDS_PKG.LOOKUP_CFUNDS_UNIT (CFUNDS_PKG.GET_PARENT_UNIT (V_UNIT_SID)).NAME
                    || Cfunds_Pkg.lookup_cfunds_unit(Cfunds_Pkg.get_parent_unit(v_unit_sid)).unit_name
                    || ' sets your limitation!</font></b><p>';
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PERCENT_OBLIGATED_SAI',
                                                 TO_CHAR(v_total_amt_spnt_sai
                                                         / v_total_yearly_amount_sai * 100,
                                                         '990.00')
                                                 || '%');
            END IF;

            IF v_total_yearly_amount_fpd = 0 THEN
                -- check for 0 to prevent error from division by 0.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PERCENT_OBLIGATED_FPD', '-');
                v_limitation_error :=
                    v_limitation_error
                    || '<b><font color="red">FPD Limitation not set - <br> you will not be able to approve any expenses until '
--               || CFUNDS_PKG.LOOKUP_CFUNDS_UNIT (CFUNDS_PKG.GET_PARENT_UNIT (V_UNIT_SID)).NAME
                    || Cfunds_Pkg.lookup_cfunds_unit(Cfunds_Pkg.get_parent_unit(v_unit_sid)).unit_name
                    || ' sets your limitation!</font></b><p>';
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PERCENT_OBLIGATED_FPD',
                                                 TO_CHAR(v_total_amt_spnt_fpd
                                                         / v_total_yearly_amount_fpd * 100,
                                                         '990.00')
                                                 || '%');
            END IF;

            -- if there are no limitations set, then show an error for this unit.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'LIMITATION_ERROR', v_limitation_error);
            -- find the working fund balance for the currently selected unit.
            v_ok :=
                Web_Template_Pkg.replace_tag
                                         (v_template,
                                          'WORKING_FUND_TOTAL',
                                          TO_CHAR(NVL(Cfunds_Pkg.get_unit_wf_balance(v_unit_sid), 0),
                                                  v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'OUTSTANDING_EXPENSES',
                                             TO_CHAR(v_outstanding_expenses, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'OUTSTANDING_ADVANCES',
                                             TO_CHAR(v_outstanding_advances, v_dollar_format));

            IF v_total_accountability <>
                             v_wf_balance + ABS(v_outstanding_expenses)
                             + ABS(v_outstanding_advances) THEN
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'TOTAL_ACCOUNTABILITY',
                                                 '<b><font color="red">'
                                                 || TO_CHAR(v_total_accountability, v_dollar_format)
                                                 || '</font></b>');
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'TOTAL_ACCOUNTABILITY',
                                                 TO_CHAR(v_total_accountability, v_dollar_format));
            END IF;

            IF Cfunds_Test_Cfp('APPROVE_CL',
                               Core_Obj.lookup_objtype('CFUNDS_EXP'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to approve expenses.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_EXP_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_EXP_COUNT', ' ');
            ELSE
                -- The user can approve expenses.

                -- find the number of submitted expenses for the currently selected unit
                -- in the current fiscal year.
                FOR e IN
                    (SELECT COUNT(*) AS num_expenses
                       FROM v_cfunds_expense_v3_status_lim
                      WHERE status IN('Submitted')
                        AND charge_to_unit = '' || v_unit_sid || ''
                        AND TRUNC(incurred_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of expenses is 0, don't make a link.
                    IF e.num_expenses = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'SUBMIT_EXP_LABEL',
                                                         'No submitted expenses');
                    --if the number of expenses is 1, make a link straight to that expense details page.
                    ELSIF e.num_expenses = 1 THEN
                        -- find the SID of the one expense for the currently selected unit.
                        FOR ed IN
                            (SELECT SID, CATEGORY, paragraph
                               FROM v_cfunds_expense_v3_status_lim
                              WHERE status IN('Submitted')
                                AND charge_to_unit = '' || v_unit_sid || ''
                                AND TRUNC(incurred_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                 (v_template,
                                                  'SUBMIT_EXP_LABEL',
                                                  'Submitted <a href="vbscript:MenuLinks(&quot;'
                                                  || Web_Util_Pkg.get_current_package
                                                  || 'expense_details?pSID=' || ed.SID
                                                  || '&pCategory=' || ed.CATEGORY || '&pParagraph='
                                                  || ed.paragraph || '&&quot;)">expense</a>');
                            EXIT;
                        END LOOP;
                    --if the number of expenses is >1 then link to the expenses listing page.
                    ELSIF e.num_expenses > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                     (v_template,
                                      'SUBMIT_EXP_LABEL',
                                      'Submitted <a href="vbscript:MenuLinks(&quot;'
                                      || Web_Util_Pkg.get_current_package
                                      || 'expenses_by_personnel?pSubmitted=only&&quot;)">expenses</a>');
                    END IF;

                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_EXP_COUNT', e.num_expenses);
                    EXIT;
                END LOOP;
            END IF;

            IF Cfunds_Test_Cfp('EXP_PAY',
                               Core_Obj.lookup_objtype('CFUNDS_EXP'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to pay expenses.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_EXP_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_EXP_COUNT', ' ');
            ELSE
                -- The user can pay expenses.

                -- find the number of approved expenses for the currently selected unit.
                FOR e IN
                    (SELECT COUNT(*) AS num_expenses
                       FROM v_cfunds_expense_v3_status_lim
                      WHERE status IN('Approved')
                        AND charge_to_unit = '' || v_unit_sid || ''
                        AND TRUNC(incurred_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of expenses is 0, don't make a link.
                    IF e.num_expenses = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'APPR_EXP_LABEL',
                                                         'No approved expenses');
                    --if the number of expenses is 1, make a link straight to that expense details page.
                    ELSIF e.num_expenses = 1 THEN
                        -- find the SID of the one expense for the currently selected unit.
                        FOR ed IN
                            (SELECT SID, CATEGORY, paragraph
                               FROM v_cfunds_expense_v3_status_lim
                              WHERE status IN('Approved')
                                AND charge_to_unit = '' || v_unit_sid || ''
                                AND TRUNC(incurred_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                  (v_template,
                                                   'APPR_EXP_LABEL',
                                                   'Approved <a href="vbscript:MenuLinks(&quot;'
                                                   || Web_Util_Pkg.get_current_package
                                                   || 'expense_details?pSID=' || ed.SID
                                                   || '&pCategory=' || ed.CATEGORY || '&pParagraph='
                                                   || ed.paragraph || '&&quot;)">expense</a>');
                            EXIT;
                        END LOOP;
                    --if the number of expenses is >1 then link to the expenses listing page.
                    ELSIF e.num_expenses > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                      (v_template,
                                       'APPR_EXP_LABEL',
                                       'Approved <a href="vbscript:MenuLinks(&quot;'
                                       || Web_Util_Pkg.get_current_package
                                       || 'expenses_by_personnel?pApproved=only&&quot;)">expenses</a>');
                    END IF;

                    v_ok :=
                          Web_Template_Pkg.replace_tag(v_template, 'APPR_EXP_COUNT', e.num_expenses);
                    EXIT;
                END LOOP;
            END IF;

            IF Cfunds_Test_Cfp('APPROVE_CL',
                               Core_Obj.lookup_objtype('CFUNDS_ADV'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to approve advances.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_ADVANCE_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_ADVANCE_COUNT', ' ');
            ELSE
                -- The user can approve advances.

                -- find the number of submitted advances for the currently selected unit.
                FOR a IN
                    (SELECT COUNT(*) AS num_advances
                       FROM v_cfunds_advance_v2
                      WHERE status IN('Submitted')
                        AND unit = '' || v_unit_sid || ''
                        AND TRUNC(request_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of advances is 0, don't make a link.
                    IF a.num_advances = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'SUBMIT_ADVANCE_LABEL',
                                                         'No submitted advances');
                    --if the number of advances is 1, make a link straight to that advance details page.
                    ELSIF a.num_advances = 1 THEN
                        -- find the SID of the one advance for the currently selected unit.
                        FOR ad IN
                            (SELECT SID
                               FROM v_cfunds_advance_v2
                              WHERE status IN('Submitted')
                                AND unit = '' || v_unit_sid || ''
                                AND TRUNC(request_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                 (v_template,
                                                  'SUBMIT_ADVANCE_LABEL',
                                                  'Submitted <a href="vbscript:MenuLinks(&quot;'
                                                  || Web_Util_Pkg.get_current_package
                                                  || 'advance_details?pSID=' || ad.SID
                                                  || '&&quot;)">advance</a>');
                            EXIT;
                        END LOOP;
                    --if the number of advances is >1 then link to the advances listing page.
                    ELSIF a.num_advances > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                  (v_template,
                                   'SUBMIT_ADVANCE_LABEL',
                                   'Submitted <a href="vbscript:MenuLinks(&quot;'
                                   || Web_Util_Pkg.get_current_package
                                   || 'advances_By_Personnel?pSubmitted=checked&&quot;)">advances</a>');
                    END IF;

                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SUBMIT_ADVANCE_COUNT',
                                                     a.num_advances);
                    EXIT;
                END LOOP;
            END IF;

            IF Cfunds_Test_Cfp('ADV_ISSUE',
                               Core_Obj.lookup_objtype('CFUNDS_ADV'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to pay advances.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_ADVANCE_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_ADVANCE_COUNT', ' ');
            ELSE
                -- The user can pay advances.

                -- find the number of Approved advances for the currently selected unit.
                FOR a IN
                    (SELECT COUNT(*) AS num_advances
                       FROM v_cfunds_advance_v2
                      WHERE status IN('Approved')
                        AND unit = '' || v_unit_sid || ''
                        AND TRUNC(request_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of advances is 0, don't make a link.
                    IF a.num_advances = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'APPR_ADVANCE_LABEL',
                                                         'No approved advances');
                    --if the number of advances is 1, make a link straight to that advance details page.
                    ELSIF a.num_advances = 1 THEN
                        -- find the SID of the one advance for the currently selected unit.
                        FOR ad IN
                            (SELECT SID
                               FROM v_cfunds_advance_v2
                              WHERE status IN('Approved')
                                AND unit = '' || v_unit_sid || ''
                                AND TRUNC(request_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                  (v_template,
                                                   'APPR_ADVANCE_LABEL',
                                                   'Approved <a href="vbscript:MenuLinks(&quot;'
                                                   || Web_Util_Pkg.get_current_package
                                                   || 'advance_details?pSID=' || ad.SID
                                                   || '&&quot;)">advance</a>');
                            EXIT;
                        END LOOP;
                    --if the number of advances is >1 then link to the advances listing page.
                    ELSIF a.num_advances > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                   (v_template,
                                    'APPR_ADVANCE_LABEL',
                                    'Approved <a href="vbscript:MenuLinks(&quot;'
                                    || Web_Util_Pkg.get_current_package
                                    || 'advances_By_Personnel?pApproved=checked&&quot;)">advances</a>');
                    END IF;

                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'APPR_ADVANCE_COUNT',
                                                     a.num_advances);
                    EXIT;
                END LOOP;
            END IF;

            -- find the number of unreceived transfers for the currently selected unit.
            FOR t IN (SELECT COUNT(*) AS num_transfers
                        FROM T_CFUNDS_XFR
                       WHERE (NOT send_date IS NULL)
                         AND (receive_date IS NULL)
                         AND receiver = '' || v_unit_sid || ''
                         AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
            LOOP
                --if the number of transfers is 0, don't make a link.
                IF t.num_transfers = 0 THEN
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TRANSFER_LABEL', 'Incoming:');
                --if the number of transfers is 1, make a link straight to that transfer details page.
                ELSIF t.num_transfers = 1 THEN
                    -- find the SID of the one unreceived transfer for the currently selected unit.
                    FOR td IN (SELECT SID
                                 FROM T_CFUNDS_XFR
                                WHERE (NOT send_date IS NULL)
                                  AND (receive_date IS NULL)
                                  AND receiver = '' || v_unit_sid || ''
                                  AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
                    LOOP
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'TRANSFER_LABEL',
                                                         '<a href="vbscript:MenuLinks(&quot;'
                                                         || Web_Util_Pkg.get_current_package
                                                         || 'transfer_details?pSID=' || td.SID
                                                         || '&&quot;)">Incoming:</a>');
                        EXIT;
                    END LOOP;
                --if the number of transfers is >1 then link to the transfers listing page.
                ELSIF t.num_transfers > 1 THEN
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'TRANSFER_LABEL',
                                                     '<a href="vbscript:MenuLinks(&quot;'
                                                     || Web_Util_Pkg.get_current_package
                                                     || 'transfers?&quot;)">Incoming:</a>');
                END IF;

                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TRANSFER_COUNT', t.num_transfers);
                EXIT;
            END LOOP;

            -- find the number of unsent transfers from the currently selected unit.
            FOR t IN (SELECT COUNT(*) AS num_transfers
                        FROM T_CFUNDS_XFR
                       WHERE (send_date IS NULL)
                         AND (receive_date IS NULL)
                         AND sender = '' || v_unit_sid || ''
                         AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
            LOOP
                --if the number of unsent transfers is 0, don't make a link.
                IF t.num_transfers = 0 THEN
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template, 'OUT_TRANSFER_LABEL', 'Outgoing:');
                --if the number of unsent transfers is 1, make a link straight to that transfer details page.
                ELSIF t.num_transfers = 1 THEN
                    -- find the SID of the one unreceived transfer for the currently selected unit.
                    FOR td IN (SELECT SID
                                 FROM T_CFUNDS_XFR
                                WHERE (send_date IS NULL)
                                  AND (receive_date IS NULL)
                                  AND sender = '' || v_unit_sid || ''
                                  AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
                    LOOP
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'OUT_TRANSFER_LABEL',
                                                         '<a href="vbscript:MenuLinks(&quot;'
                                                         || Web_Util_Pkg.get_current_package
                                                         || 'transfer_details?pSID=' || td.SID
                                                         || '&&quot;)">Outgoing:</a>');
                        EXIT;
                    END LOOP;
                --if the number of unsent transfers is >1 then link to the transfers listing page.
                ELSIF t.num_transfers > 1 THEN
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'OUT_TRANSFER_LABEL',
                                                     '<a href="vbscript:MenuLinks(&quot;'
                                                     || Web_Util_Pkg.get_current_package
                                                     || 'transfers?&quot;)">Outgoing:</a>');
                END IF;

                v_ok :=
                     Web_Template_Pkg.replace_tag(v_template, 'OUT_TRANSFER_COUNT', t.num_transfers);
                EXIT;
            END LOOP;

            -- **********   find summary info: ************ --
            -- look for items needing attention in
            -- a prior fiscal year.
            IF Cfunds_Test_Cfp('APPROVE_CL',
                               Core_Obj.lookup_objtype('CFUNDS_EXP'),
                               Core_Context.personnel_sid,
                               v_unit_sid) <> 'N' THEN
                -- The user can approve expenses.

                -- find the number of submitted expenses for the currently selected unit
                -- in the selected prior fiscal year.
                SELECT COUNT(*)
                  INTO v_count
                  FROM v_cfunds_expense_v3_status_lim
                 WHERE status IN('Submitted')
                   AND charge_to_unit = '' || v_unit_sid || ''
                   AND TRUNC(incurred_date)
                           BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_first_fiscal_year)
                               AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year - 1);

                v_prior_year_count := v_prior_year_count + v_count;

                IF v_count = 1 THEN
                    v_prior_year_message := '&quot;One submitted expense found.&quot; & vbcrlf & ';
                ELSIF v_count > 1 THEN
                    v_prior_year_message :=
                        v_prior_year_message || '&quot;' || v_count
                        || ' submitted expenses found.&quot; & vbcrlf & ';
                END IF;
            END IF;

            IF Cfunds_Test_Cfp('EXP_PAY',
                               Core_Obj.lookup_objtype('CFUNDS_EXP'),
                               Core_Context.personnel_sid,
                               v_unit_sid) <> 'N' THEN
                -- The user can pay expenses.

                -- find the number of approved expenses for the currently selected unit.
                SELECT COUNT(*)
                  INTO v_count
                  FROM v_cfunds_expense_v3_status_lim
                 WHERE status IN('Approved')
                   AND charge_to_unit = '' || v_unit_sid || ''
                   AND TRUNC(incurred_date)
                           BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_first_fiscal_year)
                               AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year - 1);

                v_prior_year_count := v_prior_year_count + v_count;

                IF v_count = 1 THEN
                    v_prior_year_message :=
                        v_prior_year_message
                        || '&quot;One approved expense found.&quot; & vbcrlf & ';
                ELSIF v_count > 1 THEN
                    v_prior_year_message :=
                        v_prior_year_message || '&quot;' || v_count
                        || ' approved expenses found.&quot; & vbcrlf & ';
                END IF;
            END IF;

            IF Cfunds_Test_Cfp('APPROVE_CL',
                               Core_Obj.lookup_objtype('CFUNDS_ADV'),
                               Core_Context.personnel_sid,
                               v_unit_sid) <> 'N' THEN
                -- The user can approve advances.

                -- find the number of submitted advances for the currently selected unit.
                SELECT COUNT(*)
                  INTO v_count
                  FROM v_cfunds_advance_v2
                 WHERE status IN('Submitted')
                   AND unit = '' || v_unit_sid || ''
                   AND TRUNC(request_date)
                           BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_first_fiscal_year)
                               AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year - 1);

                v_prior_year_count := v_prior_year_count + v_count;

                IF v_count = 1 THEN
                    v_prior_year_message :=
                        v_prior_year_message
                        || '&quot;One submitted advance found.&quot; & vbcrlf & ';
                ELSIF v_count > 1 THEN
                    v_prior_year_message :=
                        v_prior_year_message || '&quot;' || v_count
                        || ' submitted advances found.&quot; & vbcrlf & ';
                END IF;
            END IF;

            IF Cfunds_Test_Cfp('ADV_ISSUE',
                               Core_Obj.lookup_objtype('CFUNDS_ADV'),
                               Core_Context.personnel_sid,
                               v_unit_sid) <> 'N' THEN
                -- The user can pay advances.

                -- find the number of Approved advances for the currently selected unit.
                SELECT COUNT(*)
                  INTO v_count
                  FROM v_cfunds_advance_v2
                 WHERE status IN('Approved')
                   AND unit = '' || v_unit_sid || ''
                   AND TRUNC(request_date)
                           BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_first_fiscal_year)
                               AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year - 1);

                v_prior_year_count := v_prior_year_count + v_count;

                IF v_count = 1 THEN
                    v_prior_year_message :=
                        v_prior_year_message
                        || '&quot;One approved advance found.&quot; & vbcrlf & ';
                ELSIF v_count > 1 THEN
                    v_prior_year_message :=
                        v_prior_year_message || '&quot;' || v_count
                        || ' approved advances found.&quot; & vbcrlf & ';
                END IF;
            END IF;

            -- find the number of approved expenses for the currently selected unit.
            SELECT COUNT(*)
              INTO v_count
              FROM v_cfunds_expense_v3_status_lim
             WHERE status IN('Rejected')
               AND charge_to_unit = '' || v_unit_sid || ''
               AND TRUNC(incurred_date)
                       BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_first_fiscal_year)
                           AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year - 1);

            v_prior_year_count := v_prior_year_count + v_count;

            IF v_count = 1 THEN
                v_prior_year_message :=
                      v_prior_year_message || '&quot;One rejected expense found.&quot; & vbcrlf & ';
            ELSIF v_count > 1 THEN
                v_prior_year_message :=
                    v_prior_year_message || '&quot;' || v_count
                    || ' rejected expenses found.&quot; & vbcrlf & ';
            END IF;

            -- find the number of unreceived transfers for the currently selected unit.
            SELECT COUNT(*)
              INTO v_count
              FROM T_CFUNDS_XFR
             WHERE (NOT send_date IS NULL)
               AND (receive_date IS NULL)
               AND receiver = '' || v_unit_sid || ''
               AND Cfunds_Pkg.get_transfer_fy(SID) <> v_fiscal_year;

            v_prior_year_count := v_prior_year_count + v_count;

            IF v_count = 1 THEN
                v_prior_year_message :=
                     v_prior_year_message || '&quot;One incoming transfer found.&quot; & vbcrlf & ';
            ELSIF v_count > 1 THEN
                v_prior_year_message :=
                    v_prior_year_message || '&quot;' || v_count
                    || ' incoming transfers found.&quot; & vbcrlf & ';
            END IF;

            -- find the number of unsent transfers from the currently selected unit.
            SELECT COUNT(*)
              INTO v_count
              FROM T_CFUNDS_XFR
             WHERE (send_date IS NULL)
               AND (receive_date IS NULL)
               AND sender = '' || v_unit_sid || ''
               AND Cfunds_Pkg.get_transfer_fy(SID) <> v_fiscal_year;

            v_prior_year_count := v_prior_year_count + v_count;

            IF v_count = 1 THEN
                v_prior_year_message :=
                     v_prior_year_message || '&quot;One outgoing transfer found.&quot; & vbcrlf & ';
            ELSIF v_count > 1 THEN
                v_prior_year_message :=
                    v_prior_year_message || '&quot;' || v_count
                    || ' outgoing transfers found.&quot; & vbcrlf & ';
            END IF;

            -- find the number of payment listings for the currently selected unit.
            v_count := 0;

            FOR pl IN
                (SELECT   u.SID, u.unit_name
                     FROM v_cfunds_expense_v3_status_lim e, v_cfunds_unit u
                    WHERE TRUNC(e.incurred_date)
                              BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_first_fiscal_year)
                                  AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year - 1)
                      AND e.status = 'Paid'
                      AND e.reviewing_unit = v_unit_sid
                      AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) = u.SID
                 GROUP BY u.unit_name, u.SID)
            LOOP
                v_count := v_count + 1;
            END LOOP;

            v_prior_year_count := v_prior_year_count + v_count;

            IF v_count = 1 THEN
                v_prior_year_message :=
                       v_prior_year_message || '&quot;One payment listing found.&quot; & vbcrlf & ';
            ELSIF v_count > 1 THEN
                v_prior_year_message :=
                    v_prior_year_message || '&quot;' || v_count
                    || ' payment listings found.&quot; & vbcrlf & ';
            END IF;

            v_prior_year_message :=
                   v_prior_year_message || '&quot;Select a prior Fiscal Year to see details.&quot; ';

            IF v_prior_year_count > 0 THEN
                -- print summary of items needing attention from a prior fiscal year.
                --  Note: the following line launches a messageBox from a vbScript routine called 'doMsg'.  This routine is
                -- located in the "cfunds_page_background_begin" template (it must be in the <HEAD> section
                -- of the HTML in order to work correctly).  The following line allows us to launch a message box from
                -- an underlined link instead of a button.
                v_ok :=
                    Web_Template_Pkg.replace_tag
                        (v_template,
                         'PRIOR_FISCAL_YEAR_LABEL',
                         '<a href="javascript:void(0)" onclick="doMsg ' || v_prior_year_message
                         || ',&quot;Prior Fiscal Year Transactions&quot;"><font color="red">Action items</font></a> from a prior fiscal year');
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PRIOR_FISCAL_YEAR_COUNT',
                                                 v_prior_year_count);
            ELSE
                -- no items found that need attention from a prior fiscal year.
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PRIOR_FISCAL_YEAR_LABEL',
                                                 'No items from a prior fiscal year');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PRIOR_FISCAL_YEAR_COUNT', 0);
            END IF;
        ELSE                             -- the user selected to view data from a prior fiscal year.
            -- find the values to display for the selected unit's spending
            v_total_amt_spnt_ci :=
                NVL
                    (Cfunds_Pkg.get_unitorg_annual_expenses
                                                 (v_unit_sid,
                                                  'CI',
                                                  Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)),
                     0);
            v_total_amt_spnt_sai :=
                NVL
                    (Cfunds_Pkg.get_unitorg_annual_expenses
                                                 (v_unit_sid,
                                                  'S&IA',
                                                  Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)),
                     0);
            v_total_amt_spnt_fpd :=
                NVL
                    (Cfunds_Pkg.get_unitorg_annual_expenses
                                                 (v_unit_sid,
                                                  'FPD',
                                                  Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)),
                     0);
            v_total_yearly_amount_ci :=
                NVL
                    (Cfunds_Pkg.get_unitorg_limitation
                                                 (v_unit_sid,
                                                  'EXP',
                                                  'CI',
                                                  Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)),
                     0);
            v_total_yearly_amount_sai :=
                NVL
                    (Cfunds_Pkg.get_unitorg_limitation
                                                 (v_unit_sid,
                                                  'EXP',
                                                  'S&IA',
                                                  Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)),
                     0);
            v_total_yearly_amount_fpd :=
                NVL
                    (Cfunds_Pkg.get_unitorg_limitation
                                                 (v_unit_sid,
                                                  'EXP',
                                                  'FPD',
                                                  Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)),
                     0);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMT_SPNT_CI',
                                             TO_CHAR(v_total_amt_spnt_ci, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMT_SPNT_SAI',
                                             TO_CHAR(v_total_amt_spnt_sai, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMT_SPNT_FPD',
                                             TO_CHAR(v_total_amt_spnt_fpd, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_YEARLY_LIMIT_CI',
                                             TO_CHAR(v_total_yearly_amount_ci, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_YEARLY_LIMIT_SAI',
                                             TO_CHAR(v_total_yearly_amount_sai, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_YEARLY_LIMIT_FPD',
                                             TO_CHAR(v_total_yearly_amount_fpd, v_dollar_format));

            IF v_total_yearly_amount_ci = 0 THEN -- check for 0 to prevent error from division by 0.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PERCENT_OBLIGATED_CI', '-');
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PERCENT_OBLIGATED_CI',
                                                 TO_CHAR(v_total_amt_spnt_ci
                                                         / v_total_yearly_amount_ci * 100,
                                                         '990.00')
                                                 || '%');
            END IF;

            IF v_total_yearly_amount_sai = 0 THEN
                -- check for 0 to prevent error from division by 0.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PERCENT_OBLIGATED_SAI', '-');
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PERCENT_OBLIGATED_SAI',
                                                 TO_CHAR(v_total_amt_spnt_sai
                                                         / v_total_yearly_amount_sai * 100,
                                                         '990.00')
                                                 || '%');
            END IF;

            IF v_total_yearly_amount_fpd = 0 THEN
                -- check for 0 to prevent error from division by 0.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PERCENT_OBLIGATED_FPD', '-');
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PERCENT_OBLIGATED_FPD',
                                                 TO_CHAR(v_total_amt_spnt_fpd
                                                         / v_total_yearly_amount_fpd * 100,
                                                         '990.00')
                                                 || '%');
            END IF;

            -- never show an error for a prior fiscal year since it doesn't matter now.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'LIMITATION_ERROR', ' ');
               --  ** working fund balance for the currently selected unit can't be found for prior years yet.
            --   v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'WORKING_FUND_TOTAL', to_char(nvl(Cfunds_Pkg.Get_Unit_WF_Balance(v_unit_sid),0),v_dollar_format) );
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'WORKING_FUND_TOTAL',
                                             'past balance unavailable');
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'OUTSTANDING_EXPENSES',
                                             'past expenses unavailable');
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'OUTSTANDING_ADVANCES',
                                             'past advances unavailable');
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_ACCOUNTABILITY',
                                             'past accountability unavailable');

            IF Cfunds_Test_Cfp('APPROVE_CL',
                               Core_Obj.lookup_objtype('CFUNDS_EXP'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to approve expenses.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_EXP_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_EXP_COUNT', ' ');
            ELSE
                -- The user can approve expenses.

                -- find the number of submitted expenses for the currently selected unit
                -- in the selected prior fiscal year.
                FOR e IN
                    (SELECT COUNT(*) AS num_expenses
                       FROM v_cfunds_expense_v3_status_lim
                      WHERE status IN('Submitted')
                        AND charge_to_unit = '' || v_unit_sid || ''
                        AND TRUNC(incurred_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of expenses is 0, don't make a link.
                    IF e.num_expenses = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'SUBMIT_EXP_LABEL',
                                                         'No submitted expenses');
                    --if the number of expenses is 1, make a link straight to that expense details page.
                    ELSIF e.num_expenses = 1 THEN
                        -- find the SID of the one expense for the currently selected unit.
                        FOR ed IN
                            (SELECT SID, CATEGORY, paragraph
                               FROM v_cfunds_expense_v3_status_lim
                              WHERE status IN('Submitted')
                                AND charge_to_unit = '' || v_unit_sid || ''
                                AND TRUNC(incurred_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                 (v_template,
                                                  'SUBMIT_EXP_LABEL',
                                                  'Submitted <a href="vbscript:MenuLinks(&quot;'
                                                  || Web_Util_Pkg.get_current_package
                                                  || 'expense_details?pSID=' || ed.SID
                                                  || '&pCategory=' || ed.CATEGORY || '&pParagraph='
                                                  || ed.paragraph || '&&quot;)">expense</a>');
                            EXIT;
                        END LOOP;
                    --if the number of expenses is >1 then link to the expenses listing page.
                    ELSIF e.num_expenses > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                     (v_template,
                                      'SUBMIT_EXP_LABEL',
                                      'Submitted <a href="vbscript:MenuLinks(&quot;'
                                      || Web_Util_Pkg.get_current_package
                                      || 'expenses_by_personnel?pSubmitted=only&&quot;)">expenses</a>');
                    END IF;

                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_EXP_COUNT', e.num_expenses);
                    EXIT;
                END LOOP;
            END IF;

            IF Cfunds_Test_Cfp('EXP_PAY',
                               Core_Obj.lookup_objtype('CFUNDS_EXP'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to pay expenses.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_EXP_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_EXP_COUNT', ' ');
            ELSE
                -- The user can pay expenses.

                -- find the number of approved expenses for the currently selected unit.
                FOR e IN
                    (SELECT COUNT(*) AS num_expenses
                       FROM v_cfunds_expense_v3_status_lim
                      WHERE status IN('Approved')
                        AND charge_to_unit = '' || v_unit_sid || ''
                        AND TRUNC(incurred_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of expenses is 0, don't make a link.
                    IF e.num_expenses = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'APPR_EXP_LABEL',
                                                         'No approved expenses');
                    --if the number of expenses is 1, make a link straight to that expense details page.
                    ELSIF e.num_expenses = 1 THEN
                        -- find the SID of the one expense for the currently selected unit.
                        FOR ed IN
                            (SELECT SID, CATEGORY, paragraph
                               FROM v_cfunds_expense_v3_status_lim
                              WHERE status IN('Approved')
                                AND charge_to_unit = '' || v_unit_sid || ''
                                AND TRUNC(incurred_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                  (v_template,
                                                   'APPR_EXP_LABEL',
                                                   'Approved <a href="vbscript:MenuLinks(&quot;'
                                                   || Web_Util_Pkg.get_current_package
                                                   || 'expense_details?pSID=' || ed.SID
                                                   || '&pCategory=' || ed.CATEGORY || '&pParagraph='
                                                   || ed.paragraph || '&&quot;)">expense</a>');
                            EXIT;
                        END LOOP;
                    --if the number of expenses is >1 then link to the expenses listing page.
                    ELSIF e.num_expenses > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                      (v_template,
                                       'APPR_EXP_LABEL',
                                       'Approved <a href="vbscript:MenuLinks(&quot;'
                                       || Web_Util_Pkg.get_current_package
                                       || 'expenses_by_personnel?pApproved=only&&quot;)">expenses</a>');
                    END IF;

                    v_ok :=
                          Web_Template_Pkg.replace_tag(v_template, 'APPR_EXP_COUNT', e.num_expenses);
                    EXIT;
                END LOOP;
            END IF;

            IF Cfunds_Test_Cfp('APPROVE_CL',
                               Core_Obj.lookup_objtype('CFUNDS_ADV'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to approve advances.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_ADVANCE_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SUBMIT_ADVANCE_COUNT', ' ');
            ELSE
                -- The user can approve advances.

                -- find the number of submitted advances for the currently selected unit.
                FOR a IN
                    (SELECT COUNT(*) AS num_advances
                       FROM v_cfunds_advance_v2
                      WHERE status IN('Submitted')
                        AND unit = '' || v_unit_sid || ''
                        AND TRUNC(request_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of advances is 0, don't make a link.
                    IF a.num_advances = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'SUBMIT_ADVANCE_LABEL',
                                                         'No submitted advances');
                    --if the number of advances is 1, make a link straight to that advance details page.
                    ELSIF a.num_advances = 1 THEN
                        -- find the SID of the one advance for the currently selected unit.
                        FOR ad IN
                            (SELECT SID
                               FROM v_cfunds_advance_v2
                              WHERE status IN('Submitted')
                                AND unit = '' || v_unit_sid || ''
                                AND TRUNC(request_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                 (v_template,
                                                  'SUBMIT_ADVANCE_LABEL',
                                                  'Submitted <a href="vbscript:MenuLinks(&quot;'
                                                  || Web_Util_Pkg.get_current_package
                                                  || 'advance_details?pSID=' || ad.SID
                                                  || '&&quot;)">advance</a>');
                            EXIT;
                        END LOOP;
                    --if the number of advances is >1 then link to the advances listing page.
                    ELSIF a.num_advances > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                  (v_template,
                                   'SUBMIT_ADVANCE_LABEL',
                                   'Submitted <a href="vbscript:MenuLinks(&quot;'
                                   || Web_Util_Pkg.get_current_package
                                   || 'advances_By_Personnel?pSubmitted=checked&&quot;)">advances</a>');
                    END IF;

                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SUBMIT_ADVANCE_COUNT',
                                                     a.num_advances);
                    EXIT;
                END LOOP;
            END IF;

            IF Cfunds_Test_Cfp('ADV_ISSUE',
                               Core_Obj.lookup_objtype('CFUNDS_ADV'),
                               Core_Context.personnel_sid,
                               v_unit_sid) = 'N' THEN
                --The user doesn't have privilege to pay advances.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_ADVANCE_LABEL', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPR_ADVANCE_COUNT', ' ');
            ELSE
                -- The user can pay advances.

                -- find the number of Approved advances for the currently selected unit.
                FOR a IN
                    (SELECT COUNT(*) AS num_advances
                       FROM v_cfunds_advance_v2
                      WHERE status IN('Approved')
                        AND unit = '' || v_unit_sid || ''
                        AND TRUNC(request_date)
                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                LOOP
                    --if the number of advances is 0, don't make a link.
                    IF a.num_advances = 0 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'APPR_ADVANCE_LABEL',
                                                         'No approved advances');
                    --if the number of advances is 1, make a link straight to that advance details page.
                    ELSIF a.num_advances = 1 THEN
                        -- find the SID of the one advance for the currently selected unit.
                        FOR ad IN
                            (SELECT SID
                               FROM v_cfunds_advance_v2
                              WHERE status IN('Approved')
                                AND unit = '' || v_unit_sid || ''
                                AND TRUNC(request_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year))
                        LOOP
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                                  (v_template,
                                                   'APPR_ADVANCE_LABEL',
                                                   'Approved <a href="vbscript:MenuLinks(&quot;'
                                                   || Web_Util_Pkg.get_current_package
                                                   || 'advance_details?pSID=' || ad.SID
                                                   || '&&quot;)">advance</a>');
                            EXIT;
                        END LOOP;
                    --if the number of advances is >1 then link to the advances listing page.
                    ELSIF a.num_advances > 1 THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                   (v_template,
                                    'APPR_ADVANCE_LABEL',
                                    'Approved <a href="vbscript:MenuLinks(&quot;'
                                    || Web_Util_Pkg.get_current_package
                                    || 'advances_By_Personnel?pApproved=checked&&quot;)">advances</a>');
                    END IF;

                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'APPR_ADVANCE_COUNT',
                                                     a.num_advances);
                    EXIT;
                END LOOP;
            END IF;

            -- find the number of unreceived transfers for the currently selected unit.
            FOR t IN (SELECT COUNT(*) AS num_transfers
                        FROM T_CFUNDS_XFR
                       WHERE (NOT send_date IS NULL)
                         AND (receive_date IS NULL)
                         AND receiver = '' || v_unit_sid || ''
                         AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
            LOOP
                --if the number of transfers is 0, don't make a link.
                IF t.num_transfers = 0 THEN
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TRANSFER_LABEL', 'Incoming:');
                --if the number of transfers is 1, make a link straight to that transfer details page.
                ELSIF t.num_transfers = 1 THEN
                    -- find the SID of the one unreceived transfer for the currently selected unit.
                    FOR td IN (SELECT SID
                                 FROM T_CFUNDS_XFR
                                WHERE (NOT send_date IS NULL)
                                  AND (receive_date IS NULL)
                                  AND receiver = '' || v_unit_sid || ''
                                  AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
                    LOOP
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'TRANSFER_LABEL',
                                                         '<a href="vbscript:MenuLinks(&quot;'
                                                         || Web_Util_Pkg.get_current_package
                                                         || 'transfer_details?pSID=' || td.SID
                                                         || '&&quot;)">Incoming:</a>');
                        EXIT;
                    END LOOP;
                --if the number of transfers is >1 then link to the transfers listing page.
                ELSIF t.num_transfers > 1 THEN
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'TRANSFER_LABEL',
                                                     '<a href="vbscript:MenuLinks(&quot;'
                                                     || Web_Util_Pkg.get_current_package
                                                     || 'transfers?&quot;)">Incoming:</a>');
                END IF;

                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TRANSFER_COUNT', t.num_transfers);
                EXIT;
            END LOOP;

            -- find the number of unsent transfers from the currently selected unit.
            FOR t IN (SELECT COUNT(*) AS num_transfers
                        FROM T_CFUNDS_XFR
                       WHERE (send_date IS NULL)
                         AND (receive_date IS NULL)
                         AND sender = '' || v_unit_sid || ''
                         AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
            LOOP
                --if the number of unsent transfers is 0, don't make a link.
                IF t.num_transfers = 0 THEN
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template, 'OUT_TRANSFER_LABEL', 'Outgoing:');
                --if the number of unsent transfers is 1, make a link straight to that transfer details page.
                ELSIF t.num_transfers = 1 THEN
                    -- find the SID of the one unreceived transfer for the currently selected unit.
                    FOR td IN (SELECT SID
                                 FROM T_CFUNDS_XFR
                                WHERE (send_date IS NULL)
                                  AND (receive_date IS NULL)
                                  AND sender = '' || v_unit_sid || ''
                                  AND Cfunds_Pkg.get_transfer_fy(SID) = v_fiscal_year)
                    LOOP
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'OUT_TRANSFER_LABEL',
                                                         '<a href="vbscript:MenuLinks(&quot;'
                                                         || Web_Util_Pkg.get_current_package
                                                         || 'transfer_details?pSID=' || td.SID
                                                         || '&&quot;)">Outgoing:</a>');
                        EXIT;
                    END LOOP;
                --if the number of unsent transfers is >1 then link to the transfers listing page.
                ELSIF t.num_transfers > 1 THEN
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'OUT_TRANSFER_LABEL',
                                                     '<a href="vbscript:MenuLinks(&quot;'
                                                     || Web_Util_Pkg.get_current_package
                                                     || 'transfers?&quot;)">Outgoing:</a>');
                END IF;

                v_ok :=
                     Web_Template_Pkg.replace_tag(v_template, 'OUT_TRANSFER_COUNT', t.num_transfers);
                EXIT;
            END LOOP;

            -- find the number of payment listings for the currently selected unit.
            -- (We are just using the Prior fiscal year replacement tag because its there.).
            v_count := 0;

            FOR pl IN
                (SELECT   u.SID, u.unit_name
                     FROM v_cfunds_expense_v3_status_lim e, v_cfunds_unit u
                    WHERE TRUNC(e.incurred_date)
                              BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                  AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                      AND e.status = 'Paid'
                      AND e.reviewing_unit = v_unit_sid
                      AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) = u.SID
                 GROUP BY u.unit_name, u.SID)
            LOOP
                v_count := v_count + 1;
            END LOOP;

            IF v_count > 0 THEN
                -- print link to payment listings needing attention for this prior fiscal year.
                v_ok :=
                    Web_Template_Pkg.replace_tag
                                    (v_template,
                                     'PRIOR_FISCAL_YEAR_LABEL',
                                     '<a href="vbscript:MenuLinks(&quot;'
                                     || Web_Util_Pkg.get_current_package
                                     || 'payment_listing_by_unit?&quot;)">Active payment listings</a>');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PRIOR_FISCAL_YEAR_COUNT', v_count);
            ELSE
                -- no payment listings found that need attention.
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PRIOR_FISCAL_YEAR_LABEL',
                                                 'No active payment listings');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PRIOR_FISCAL_YEAR_COUNT', 0);
            END IF;
        END IF;

        -- actually send out the page to the server
        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);

            IF NOT v_ok THEN
                Core_Logger.log_it(c_pipe, 'home page guts v_ok = FALSE, v_tag = ' || v_tag);
            END IF;

            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            IF v_tag = 'UNIT_NAME' THEN
                -- setup the cursor for the unit combo box
                v_cursor2 := DBMS_SQL.OPEN_CURSOR;
                v_query2 := '';
                v_query2 := v_query2 || ' select U.SID,';
                v_query2 :=
                    v_query2
                    || '        decode(CFU.ACTIVE,''N'',UN.UNIT_NAME || '' (INACTIVE CFUNDS UNIT)'',UN.UNIT_NAME) as NAME,';
                v_query2 :=
                    v_query2 || '        decode(U.SID, ''' || v_unit_sid
                    || ''', ''Y'',null) as SELECTED';
                v_query2 :=
                           v_query2 || ' from T_OSI_UNIT U, T_CFUNDS_UNIT CFU, T_OSI_UNIT_NAME UN ';
                v_query2 := v_query2 || ' where UN.UNIT = U.SID and U.SID  = CFU.SID (+)';
                v_query2 := v_query2 || '   and un.END_DATE is null';
                v_query2 := v_query2 || ' order by u.UNIT_code';
                DBMS_SQL.PARSE(v_cursor2, v_query2, dbms_sql.native);
                owa_util.listprint(v_cursor2, 'SelectUnit', 1, FALSE);
                DBMS_SQL.CLOSE_CURSOR(v_cursor2);
            ELSIF v_tag = 'FISCAL_YEAR_DROPDOWN' THEN
                -- setup fiscal year selector control.
                htp.p('<select NAME="SelectFiscalYear" id="pFiscalYear" size="1">');

                -- v_year initialized to '2003', the Fiscal year before system startup.
                LOOP
                    EXIT WHEN v_year > Cfunds_Pkg.get_fiscal_year(SYSDATE);

                    IF NVL(pfiscalyear, v_year) = v_year THEN
                        htp.p('<option selected value="' || v_year || '">' || v_year);
                    ELSE
                        htp.p('<option value="' || v_year || '">' || v_year);
                    END IF;

                    v_year := v_year + 1;
                END LOOP;

                htp.p('</select>');
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;

        Core_Logger.log_it(c_pipe, '<-- END home page guts.');
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'OOPS' || SQLERRM);
    END home_page_guts;

    PROCEDURE exception_handler(pinternal IN BOOLEAN := FALSE) IS
    BEGIN
        htp.print('<font size="+2"><b>Error processing request!</b></font><br><br>');
        htp.nl;
        htp.print('<b>Error details:</b><br>');
        --htp.print(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        IF pinternal THEN
            htp.print(v_error_detail);
        ELSE
            htp.print(Cfunds_Pkg.get_error_detail);
        END IF;

        htp.nl;
        ROLLBACK;
    END exception_handler;

-- Public Procedures

    -- AFOSI Limitation Management (HQ level).
    PROCEDURE adjust_afosi_limitations(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
--  Parameters
        vp_unit           T_OSI_UNIT.SID%TYPE;
        vp_pec            T_CFUNDS_PECS.code%TYPE;
        vp_eff_date       DATE;
        vp_command        VARCHAR2(100);
        vp_debug          VARCHAR2(10);
        vp_limtotalci     NUMBER;
        vp_limtotalsia    NUMBER;
        vp_limtotalfpd    NUMBER;
        vp_fiscal_year    VARCHAR2(10);
        vp_ci_comments    VARCHAR2(30000);
        vp_sia_comments   VARCHAR2(30000);
        vp_fpd_comments   VARCHAR2(30000);
--  Template Processing
        v_template        CLOB;
        v_template_date   DATE;
        v_offset          NUMBER                    := 1;
        v_tag             VARCHAR2(100);
        v_self            VARCHAR2(500);
--  Query Processing/General
        v_query           VARCHAR2(4000);
        v_query_status    VARCHAR2(400);
        v_cursor          INTEGER;
        v_cnt             NUMBER;
        v_ok              BOOLEAN;
        v_tmp             VARCHAR2(500);
        v_amt_spent       NUMBER;
        v_curr_lim        NUMBER;
    BEGIN
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Adjust_AFOSI_Limitations');
        Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
        Web_Util_Pkg.dump_params(name_array, value_array);
        -- Get control parameters
        vp_command :=
               NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pCommand'), 'Refresh');
        vp_unit :=
            NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                Cfunds_Pkg.get_my_cfunds_unit);
        v_tmp := Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pEff_Date');
        vp_eff_date := TO_DATE(v_tmp, 'dd-Mon-yyyy');
        vp_eff_date := TRUNC(NVL(vp_eff_date, SYSDATE));
        vp_debug := NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pDebug'), 'FALSE');
        vp_limtotalci :=
                     NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pLimTotalCI'), 0);
        vp_limtotalsia :=
                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pLimTotalSIA'), 0);
        vp_limtotalfpd :=
                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pLimTotalFPD'), 0);
        vp_fiscal_year :=
            NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear'),
                Cfunds_Pkg.get_fiscal_year(SYSDATE));
        vp_ci_comments :=
            NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pCIComments'),
                'System generated comment: Update done using EFMS.');
        vp_sia_comments :=
            NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pSIAComments'),
                'System generated comment: Update done using EFMS.');
        vp_fpd_comments :=
            NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFPDComments'),
                'System generated comment: Update done using EFMS.');
        -- E.G this fix should work on lower and recent version of oracle.
        --v_self := '!' || WEB_UTIL_PKG.Get_Self;
        v_self := '!' || REPLACE(Web_Util_Pkg.get_self, '!', '');
        begin_serve_page('E-Funds Adjust AFOSI Limitations',
                         TRUE,
                         TRUE,
                         ' ',
                         'E-Funds Adjust AFOSI Limitations',
                         'DoHistory');

        -- Process commands. Only real command is 'Update'. Default processing
        -- is the 'Refresh' command (which gets executed in all cases).
        IF vp_command = 'Update' THEN
            Web_Util_Pkg.send_comment('Processing Update');

            IF vp_eff_date < TRUNC(SYSDATE) THEN
                htp.p
                    ('You cannot enter limitations in the past.  Please change the date and try again.<br>');
            ELSE
                -- Update the Limitation for all of OSI to the number requested.
                -- May be nice to throw up a verification check first..

                --    domsg('Are you sure you want ot increase/decrease this amount $xyy by this much $xxx?);
                IF vp_limtotalci <> 0 THEN
                    --  add record to DB to update this limitation.
                    Cfunds_Pkg.set_oxt_limitation(v_hq_cc_unit_sid,
                                                  vp_limtotalci,
                                                  'CI',
                                                  vp_ci_comments,
                                                  vp_eff_date);
                    htp.p('The CI limitation for OSI has been changed to '
                          || TO_CHAR(vp_limtotalci, v_dollar_format));
                END IF;

                IF vp_limtotalsia <> 0 THEN
                    --  add record to DB to update this limitation.
                    Cfunds_Pkg.set_oxt_limitation(v_hq_cc_unit_sid,
                                                  vp_limtotalsia,
                                                  'S&IA',
                                                  vp_sia_comments,
                                                  vp_eff_date);
                    htp.p('The S&IA limitation for OSI has been changed to '
                          || TO_CHAR(vp_limtotalsia, v_dollar_format));
                END IF;

                IF vp_limtotalfpd <> 0 THEN
                    --  add record to DB to update this limitation.
                    Cfunds_Pkg.set_oxt_limitation(v_hq_cc_unit_sid,
                                                  vp_limtotalfpd,
                                                  'FPD',
                                                  vp_fpd_comments,
                                                  vp_eff_date);
                    htp.p('The FPD limitation for OSI has been changed to '
                          || TO_CHAR(vp_limtotalfpd, v_dollar_format));
                END IF;

                COMMIT;                                              -- only called if no exceptions
            END IF;
        END IF;                                                                 -- Update processing

        -- Start default (Refresh) processing

        -- Check privilege to even show the information
        IF Cfunds_Test_Cfp('CF_LIM_SET_ORG',
                           Core_Obj.lookup_objtype('NONE'),
                           Core_Context.personnel_sid,
                           v_hq_cc_unit_sid) = 'N' THEN
            v_error_detail :=
                  'You do not have privilege to view the limitations ' || 'for the specified unit.';
            RAISE a_stink;
        END IF;

        v_ok :=
            Web_Template_Pkg.get_latest('cfunds_adjust_afosi_limitations',
                                        v_template,
                                        v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe,
                               '  Could not locate template "cfunds_adjust_afosi_limitations"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self || '?a=1');
        -- remember the Fiscal Year
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'EFFECTIVE_DATE',
                                         TO_CHAR(vp_eff_date, 'dd-Mon-yyyy'));
        v_ok :=
            Web_Template_Pkg.replace_tag
                                  (v_template,
                                   'LIM_TOTAL_CI',
                                   TO_CHAR(NVL(Cfunds_Pkg.get_unit_limitation(v_hq_cc_unit_sid,
                                                                              'OXT',
                                                                              'CI',
                                                                              vp_eff_date),
                                               0),
                                           v_dollar_format));
        v_ok :=
            Web_Template_Pkg.replace_tag
                                  (v_template,
                                   'LIM_TOTAL_SIA',
                                   TO_CHAR(NVL(Cfunds_Pkg.get_unit_limitation(v_hq_cc_unit_sid,
                                                                              'OXT',
                                                                              'S&IA',
                                                                              vp_eff_date),
                                               0),
                                           v_dollar_format));
        v_ok :=
            Web_Template_Pkg.replace_tag
                                  (v_template,
                                   'LIM_TOTAL_FPD',
                                   TO_CHAR(NVL(Cfunds_Pkg.get_unit_limitation(v_hq_cc_unit_sid,
                                                                              'OXT',
                                                                              'FPD',
                                                                              vp_eff_date),
                                               0),
                                           v_dollar_format));
        -- E.G this fix should work on lower and recent version of oracle.
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'CI_LINK',
                                         '!' || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                         || 'afosi_limitations_list?pFiscalYear=' || vp_fiscal_year
                                         || '&pUnit=' || vp_unit || '&pPEC=CI');
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'SIA_LINK',
                                         '!' || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                         || 'afosi_limitations_list?pFiscalYear=' || vp_fiscal_year
                                         || '&pUnit=' || vp_unit);
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'FPD_LINK',
                                         '!' || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                         || 'afosi_limitations_list?pFiscalYear=' || vp_fiscal_year
                                         || '&pUnit=' || vp_unit || '&pPEC=FPD');

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'AMT_SPENT_TOT' THEN
                NULL;
            ELSE
                htp.print('[' || v_tag || ']');
            END IF;
        END LOOP;

        end_serve_page;
        setunitsid(vp_unit);
        set_fiscal_year(vp_fiscal_year);
    EXCEPTION
        WHEN a_stink THEN
            exception_handler(TRUE);
            end_serve_page;
            setunitsid(vp_unit);
            set_fiscal_year(vp_fiscal_year);
        WHEN OTHERS THEN
            exception_handler;
            end_serve_page;
            setunitsid(vp_unit);
            set_fiscal_year(vp_fiscal_year);
    END adjust_afosi_limitations;

    PROCEDURE afosi_limitations_list(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
--  Parameters
        vp_unit           T_OSI_UNIT.SID%TYPE;
        vp_pec            T_CFUNDS_PECS.code%TYPE;
        vp_fiscal_year    VARCHAR2(10);
--  Template Processing
        v_template        CLOB;
        v_template_date   DATE;
        v_offset          NUMBER                            := 1;
        v_tag             VARCHAR2(100);
        v_self            VARCHAR2(500);
--  Query Processing/General
        v_query           VARCHAR2(4000);
        v_query_status    VARCHAR2(400);
        v_cursor          INTEGER;
        v_cnt             NUMBER;
        v_ok              BOOLEAN;
        v_tmp             VARCHAR2(500);
        v_last_amount     T_CFUNDS_LIMITATION.amount%TYPE;
    BEGIN
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.AFOSI_Limitations_List');
        Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
        Web_Util_Pkg.dump_params(name_array, value_array);
        -- Get control parameters
        vp_unit :=
            NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                Cfunds_Pkg.get_my_cfunds_unit);
        vp_fiscal_year :=
            NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear'),
                Cfunds_Pkg.get_fiscal_year(SYSDATE));
        vp_pec := NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pPEC'), 'S&IA');
        -- E.G this fix should work on lower and recent version of oracle.
        --v_self := '!' || WEB_UTIL_PKG.Get_Self;
        v_self := '!' || REPLACE(Web_Util_Pkg.get_self, '!', '');
        begin_serve_page('E-Funds AFOSI Limitations List',
                         TRUE,
                         TRUE,
                         ' ',
                         'E-Funds AFOSI Limitations List',
                         'DoHistory');

        -- Start default (Refresh) processing

        -- Check privilege to even show the information
        IF Cfunds_Test_Cfp('CF_LIM_SET_ORG',
                           Core_Obj.lookup_objtype('NONE'),
                           Core_Context.personnel_sid,
                           v_hq_cc_unit_sid) = 'N' THEN
            v_error_detail := 'You do not have privilege to view this information' || '.';
            RAISE a_stink;
        END IF;

        v_ok :=
            Web_Template_Pkg.get_latest('cfunds_afosi_limitations_list', v_template,
                                        v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe,
                               '  Could not locate template "cfunds_afosi_limitations_list"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self || '?a=1');
        -- remember the Fiscal Year
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'PEC', vp_pec);

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'LIMITS_LIST' THEN
                v_last_amount := 0;

                FOR lim IN (SELECT   effective_date, amount, comments, create_on
                                FROM T_CFUNDS_LIMITATION
                               WHERE lim_type = 'OXT'
                                 AND pec = vp_pec
                                 AND unit = v_hq_cc_unit_sid
                                 AND effective_date <= TRUNC(SYSDATE)
                            ORDER BY effective_date, create_on)
                LOOP
                    htp.tableRowOpen;
                        htp.tabledata(lim.effective_date);
                        htp.tabledata(TO_CHAR(lim.amount, v_dollar_format), 'right');
                        htp.tabledata(NVL(lim.comments, '&nbsp;'));
                    htp.tableRowClose;
                    v_last_amount := lim.amount;
                END LOOP;

                htp.tableRowOpen;
                    htp.tabledata('<b>TODAY</b>');
                    htp.tabledata(TO_CHAR(v_last_amount, v_dollar_format), 'right');
                    htp.tabledata('Today''s Current Limitation');
                htp.tableRowClose;

                FOR lim IN (SELECT   effective_date, amount, comments, create_on
                                FROM T_CFUNDS_LIMITATION
                               WHERE lim_type = 'OXT'
                                 AND pec = vp_pec
                                 AND unit = v_hq_cc_unit_sid
                                 AND effective_date > TRUNC(SYSDATE)
                            ORDER BY effective_date, create_on)
                LOOP
                    htp.tableRowOpen;
                        htp.tabledata('<font color="red">' || lim.effective_date || '</font>');
                        htp.tabledata('<font color="red">' || TO_CHAR(lim.amount, v_dollar_format)
                                      || '</font>',
                                      'right');
                        htp.tabledata('<font color="red">' || NVL(lim.comments, '&nbsp;') || '</font>');
                    htp.tableRowClose;
                END LOOP;
            ELSE
                htp.print('[' || v_tag || ']');
            END IF;
        END LOOP;

        end_serve_page;
        setunitsid(vp_unit);
        set_fiscal_year(vp_fiscal_year);
    EXCEPTION
        WHEN a_stink THEN
            exception_handler(TRUE);
            end_serve_page;
            setunitsid(vp_unit);
            set_fiscal_year(vp_fiscal_year);
        WHEN OTHERS THEN
            exception_handler;
            end_serve_page;
            setunitsid(vp_unit);
            set_fiscal_year(vp_fiscal_year);
    END afosi_limitations_list;

    PROCEDURE advances_by_personnel(
        pcommand      IN   VARCHAR2,
        pnew          IN   VARCHAR2,
        psubmitted    IN   VARCHAR2,
        papproved     IN   VARCHAR2,
        prejected     IN   VARCHAR2,
        pactive       IN   VARCHAR2,
        pclosed       IN   VARCHAR2,
        punit         IN   VARCHAR2,
        pfiscalyear   IN   VARCHAR2,
        punitpick     IN   VARCHAR2) IS
        v_template        CLOB;
        v_template_date   DATE;
        v_offset          NUMBER                := 1;
        v_tag             VARCHAR2(100);
        v_query           VARCHAR2(4000);
        v_query_status    VARCHAR2(400);
        v_cursor          INTEGER;
        v_cnt             NUMBER;
        v_ok              BOOLEAN;
        v_filter_list     VARCHAR2(1000);
        v_unit            T_OSI_UNIT.SID%TYPE;
        v_params          VARCHAR2(1000);
        v_params_short    VARCHAR2(1000);
        v_fiscal_year     VARCHAR2(10);

        PROCEDURE add_filter_item(
            pcontrol_name   IN   VARCHAR2,
            ponoff          IN   VARCHAR2,
            pdisplayname    IN   VARCHAR2) IS
        BEGIN
            -- setup the string for the filterbar,
            v_ok := Core_List.add_item_to_list(pcontrol_name, v_filter_list);
            v_ok := Core_List.add_item_to_list(ponoff, v_filter_list);
            v_ok := Core_List.add_item_to_list(pdisplayname, v_filter_list);

            -- Set parameters to be sent to next page and status parameters
            IF ponoff IS NOT NULL THEN
                v_params := v_params || '&' || pcontrol_name || '=' || ponoff;
                v_query_status := v_query_status || ',''' || pdisplayname || '''';
                v_params_short := v_params_short || '-' || pcontrol_name;
            END IF;
        END add_filter_item;
    BEGIN
        -- set the v_unit.  It should always be the pUnit but since this page can
        -- be called from any point we have to have a default in case.
        v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
        begin_serve_page('E-Funds Advances by Personnel',
                         TRUE,
                         TRUE,
                         ' ',
                         'E-Funds Advances by Personnel',
                         'home_page');
        Core_Logger.log_it(c_pipe, '--> Cfunds_Web.Advances(' || pcommand || ')');
        v_ok :=
            Web_Template_Pkg.get_latest('cfunds_advances_by_personnel', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe,
                               '  Could not locate template "cfunds_advances_by_personnel"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
        -- remember the Fiscal Year
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'FISCAL_YEAR_LABEL',
                                         get_html_fy_dropdown(v_fiscal_year, 'pFiscalYear'));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit);
        -- setup the string for the filterbar, and also ,
        -- Set parameters to be sent to next page and status parameters
        add_filter_item('pNew', pnew, 'New');
        add_filter_item('pSubmitted', psubmitted, 'Submitted');
        add_filter_item('pApproved', papproved, 'Approved');
        add_filter_item('pActive', pactive, 'Active');
        add_filter_item('pRejected', prejected, 'Disallowed');
        add_filter_item('pClosed', pclosed, 'Closed');
        -- actually generate the table that holds the checkbox filters and the update filters button.
        v_ok :=
               Web_Template_Pkg.replace_tag(v_template, 'FILTERBAR', build_filterbar(v_filter_list));

        IF v_params IS NOT NULL THEN
            v_params := '&pParams=' || v_params;
            -- need to make sure there is no occurance of the =- combination.
            v_params := REPLACE(v_params, '=-', '=');
        END IF;

        IF v_params_short IS NOT NULL THEN
            v_params_short := '&pParams=' || v_params_short;
            -- need to make sure there is no occurance of the =- combination.
            v_params_short := REPLACE(v_params_short, '=-', '=');
        END IF;

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'ADVANCE_LIST' THEN
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                v_query := '';
                v_query := v_query || 'select';
                v_query :=
                    v_query || '     ''<a href="' || Web_Util_Pkg.get_current_package
                    || 'advance_details?pSID='' || a.SID || ''&pUnit=' || v_unit || '&pFiscalYear='
                    || v_fiscal_year || v_params_short || '">'' || a.VOUCHER_NO || ''</a>'',';
                v_query := v_query || '     a.CLAIMANT_NAME,';
                v_query := v_query || '     a.REQUEST_DATE as REQUESTED_DATE,';
                v_query :=
                    v_query
                    || '     decode(a.ISSUE_ON,null,''&nbsp;'',to_char(nvl(a.CHECK_AMOUNT,0) + nvl(a.CASH_AMOUNT,0) - nvl(a.EXPENSED_AMOUNT,0) - nvl(Cfunds_Pkg.Get_Advance_Total_Repayments( a.SID ),0),'''
                    || v_dollar_format || ''')) as AVAIL_AMOUNT,';
                v_query :=
                    v_query || '     to_char(a.AMOUNT_REQUESTED,''' || v_dollar_format
                    || ''') as AMOUNT,';
                v_query := v_query || '     a.STATUS ';
                v_query := v_query || ' from V_CFUNDS_ADVANCE_V2 a';
                v_query := v_query || ' where ';
                v_query :=
                    v_query || '     Cfunds_Pkg.Get_Fiscal_Year(a.REQUEST_DATE) = '''
                    || v_fiscal_year || ''' and ';
                v_query := v_query || '     UNIT = ''' || v_unit || ''' and';
                v_query := v_query || '     STATUS in (''bogus''';
                v_query := v_query || v_query_status || ')';                    -- close STATUS set
                v_query := v_query || ' order by a.REQUEST_DATE ';
                Core_Logger.log_it(c_pipe, 'ADVANCE LIST v_query = ' || v_query);
                DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                owa_util.cellsprint(v_cursor, 1000, NULL, v_cnt);
            ELSIF v_tag = 'UNIT_LIST' THEN
                -- setup the cursor for the combo box to select a unit
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                v_query := '';
                v_query := v_query || ' select SID, UNIT_NAME, ';
                v_query :=
                        v_query || '     decode(SID, ''' || v_unit || ''', ''Y'',null) as SELECTED';
                v_query := v_query || ' from V_CFUNDS_UNIT';
                v_query := v_query || ' order by UNIT_CODE';
                Core_Logger.log_it(c_pipe, 'UNIT LIST v_query = ' || v_query);
                DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
--                OWA_CORE_LISTPRINT(V_CURSOR, 'pUnitPick', 1, FALSE);
                owa_util.listprint(v_cursor, 'pUnitPick', 1, FALSE);
                DBMS_SQL.CLOSE_CURSOR(v_cursor);
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;

        end_serve_page;
        setunitsid(v_unit);
        set_fiscal_year(v_fiscal_year);
        Core_Logger.log_it(c_pipe, '<-- Cfunds_Web.Advances');
--    setvparams(v_params); -- not used here, because this only is used for pages where the previous page has filters.
    END advances_by_personnel;

    PROCEDURE advance_details(
        pcommand        IN   VARCHAR2,
        psid            IN   VARCHAR2,
        ppurpose        IN   VARCHAR2,
        pcheck_amount   IN   NUMBER,
        pcheck_number   IN   VARCHAR2,
        pcash_amount    IN   NUMBER,
        punit           IN   VARCHAR2,
        pparams         IN   VARCHAR2,
        pfiscalyear     IN   VARCHAR2) IS
        v_template         CLOB;
        v_template_date    DATE;
        v_offset           NUMBER         := 1;
        v_tag              VARCHAR2(100);
        v_query            VARCHAR2(4000);
        v_query_status     VARCHAR2(400);
        v_cursor           INTEGER;
        v_cnt              NUMBER;
        v_ok               BOOLEAN;
        v_params           VARCHAR2(100);
        v_strreadonly      VARCHAR2(9);
        v_command1_specs   VARCHAR2(200);
        v_command2_specs   VARCHAR2(200);
        v_voucher_no       VARCHAR2(100);
        v_fiscal_year      VARCHAR2(10);
    BEGIN
        IF pparams IS NULL THEN
            begin_serve_page('E-Funds Advance Details',
                             TRUE,
                             TRUE,
                             ' ',
                             'E-Funds Advance Details',
                             'Home_Page');
        ELSE
            begin_serve_page('E-Funds Advance Details',
                             TRUE,
                             TRUE,
                             ' ',
                             'E-Funds Advance Details',
                             'advances_by_personnel');
        END IF;

        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Advance_Details(' || pcommand || ')');
        v_ok := Web_Template_Pkg.get_latest('cfunds_advance_details', v_template, v_template_date);

        IF pcommand = 'Delete' THEN
            Core_Logger.log_it(c_pipe, 'getting advance delete template');
            v_ok :=
                  Web_Template_Pkg.get_latest('cfunds_advance_delete', v_template, v_template_date);
        END IF;

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_Advance_Details"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'PPARAMS', pparams);
        -- remember the Fiscal Year
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', v_fiscal_year);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', punit);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);

        IF pcommand = 'Reject' THEN
            Cfunds_Pkg.reject_advance(psid);
        END IF;

        IF pcommand = 'Approve' THEN
            Cfunds_Pkg.approve_advance(psid);

            UPDATE T_CFUNDS_ADVANCE_V2
               SET narrative = ppurpose
             WHERE SID = psid;
        END IF;

        IF pcommand = 'Process Payment' THEN
            IF pcheck_amount IS NULL THEN
                IF pcash_amount IS NULL THEN
                    v_error_detail := 'Missing amount of payment.';
                    RAISE a_stink;
                END IF;
            ELSE
                IF pcheck_number IS NULL THEN
                    v_error_detail := 'Missing check number.';
                    RAISE a_stink;
                END IF;
            END IF;

            Cfunds_Pkg.issue_advance(psid,
                                     pcash_amount,
                                     pcheck_amount,
                                     pcheck_number,
                                     'Y',
                                     'Y',
                                     v_voucher_no);

            UPDATE T_CFUNDS_ADVANCE_V2
               SET narrative = ppurpose
             WHERE SID = psid;
        END IF;

        IF pcommand = 'Delete' THEN
            DELETE FROM T_CFUNDS_ADVANCE_V2
                  WHERE SID = psid;

            Core_Logger.log_it(c_pipe, 'delete row from T_CFUNDS_ADVANCE_V2');
        END IF;

        FOR a IN (SELECT *
                    FROM v_cfunds_advance_v2
                   WHERE SID = psid)
        LOOP
            -- make input fields readonly if the status isn't Approved.
            v_strreadonly := ' readonly';                                   -- default is read-only

            IF a.status = 'New' THEN
                v_strreadonly := ' ';
                v_command1_specs :=
                    'type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'advance_form30?pSID=' || psid || '")''';
                --v_Command2_Specs := 'type=''hidden'' value=''Approve''';
                v_command2_specs := 'type=''submit'' value=''Delete''';
                Core_Logger.log_it(c_pipe, 'status of advance is new');
            ELSIF a.status = 'Submitted' THEN
                v_command1_specs := 'type=''submit'' value=''Approve''';
                v_command2_specs := 'type=''submit'' value=''Reject''';
            ELSIF a.status = 'Approved' THEN
                v_strreadonly := ' ';
                v_command1_specs := 'type=''submit'' value=''Process Payment''';
                v_command2_specs :=
                    'type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'advance_form30?pSID=' || psid || '")''';
            ELSIF a.status = 'Active' THEN
                v_command1_specs :=
                    'type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'advance_form30?pSID=' || psid || '")''';
                v_command2_specs := 'type=''hidden'' value=''Process Repayment''';
            ELSE                                                              -- a.STATUS = 'Closed'
                v_command1_specs :=
                    'type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'advance_form30?pSID=' || psid || '")''';
                v_command2_specs := 'type=''hidden'' value=''Process Repayment''';
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_1', v_command1_specs);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_2', v_command2_specs);
            -- save SID value for next iteration of the form.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', a.SID);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'REQUEST_DATE', a.request_date);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'STATUS_DESC', a.status);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CLAIMANT_NAME', a.claimant_name);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_NAME', a.unit_name);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'PURPOSE', a.narrative);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', a.voucher_no);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'AMOUNT_REQUESTED',
                                             TO_CHAR(a.amount_requested, v_dollar_format));

            -- calculate the amount of the advance that is still outstanding and needs to be repaid.
            IF a.issue_on IS NULL THEN
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'AMOUNT_REMAINING', ' ');
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag
                                    (v_template,
                                     'AMOUNT_REMAINING',
                                     TO_CHAR(NVL(a.check_amount, 0) + NVL(a.cash_amount, 0)
                                             - NVL(a.expensed_amount, 0)
                                             - NVL(Cfunds_Pkg.get_advance_total_repayments(a.SID),
                                                   0),
                                             v_dollar_format));
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'PAYMENT_ISSUE_ON', a.issue_on);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CHECK_AMOUNT',
                                             v_strreadonly || ' value = ' || a.check_amount);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CHECK_NUMBER',
                                             v_strreadonly || ' value = ' || a.check_number);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CASH_AMOUNT',
                                             v_strreadonly || ' value = ' || a.cash_amount);

            IF a.expensed_amount IS NULL THEN
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'EXPENSED_AMOUNT',
                                                 'No expenses were used to repay this advance.');
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag
                        (v_template,
                         'EXPENSED_AMOUNT',
                         'The amount of this advance that was repaid through approved expenses: '
                         || TO_CHAR(a.expensed_amount, v_dollar_format));
            END IF;

            IF a.status = 'Active' THEN
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'REPAYMENT_LINK',
                                                 '<a  href="' || Web_Util_Pkg.get_current_package
                                                 || 'repayment_details?pAdvance=' || a.SID
                                                 || '&pUnit=' || punit || '&pParams=' || pparams
                                                 || '">Create New Repayment</a>');
            ELSE
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'REPAYMENT_LINK', ' ');
            END IF;

            EXIT;
        END LOOP;

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            IF v_tag = 'REPAYMENT_LISTING' THEN
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                v_query := '';
                v_query := v_query || 'select';
                v_query :=
                    v_query || '     ''<a  href="' || Web_Util_Pkg.get_current_package
                    || 'repayment_details?pSid='' || ar.SID || ''' || '&pUnit=' || punit
                    || '&pAdvance=' || psid || '&pParams=' || pparams
                    || '">'' || ar.VOUCHER_NO || ''</a>'',';
                v_query := v_query || '     ar.RECEIVE_ON,';
                v_query :=
                    v_query || '     to_char(ar.TOTAL_AMOUNT,''' || v_dollar_format
                    || ''') as TOTAL_AMOUNT';
                v_query := v_query || ' from V_CFUNDS_ADVANCE_REPAYMENT_V2 ar';
                v_query := v_query || ' where ';
                v_query := v_query || '     ar.ADVANCE = ''' || psid || '''';
                v_query := v_query || ' order by';
                v_query := v_query || '     ar.RECEIVE_ON';
                DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                owa_util.cellsprint(v_cursor, 1000, NULL, v_cnt);
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;

        end_serve_page;
        setunitsid(punit);
        setvparams(pparams);
        set_fiscal_year(v_fiscal_year);
        COMMIT;         -- commit here is only done when the page has completed display successfully
    -- (no exceptions were raised).
    EXCEPTION
        WHEN a_stink THEN
            exception_handler(TRUE);
            end_serve_page;
            setunitsid(punit);
            setvparams(pparams);
            set_fiscal_year(v_fiscal_year);
        WHEN Cfunds_Pkg.bad_timing THEN
            exception_handler;
            end_serve_page;
            setunitsid(punit);
            setvparams(pparams);
            set_fiscal_year(v_fiscal_year);
        WHEN Cfunds_Pkg.no_privilege THEN
            exception_handler;
            end_serve_page;
            setunitsid(punit);
            setvparams(pparams);
            set_fiscal_year(v_fiscal_year);
        WHEN Cfunds_Pkg.invalid_parameters THEN
            exception_handler;
            end_serve_page;
            setunitsid(punit);
            setvparams(pparams);
            set_fiscal_year(v_fiscal_year);
        WHEN OTHERS THEN
            htp.print(SQLERRM);
            htp.nl;
            htp.print(Cfunds_Pkg.get_error_detail);
            htp.nl;
            end_serve_page;
            setunitsid(punit);
            setvparams(pparams);
            set_fiscal_year(v_fiscal_year);
            ROLLBACK;
    END advance_details;

    PROCEDURE advance_form30(
        psid              IN   VARCHAR2,
        pcommand          IN   VARCHAR2,
        pcustodian_name   IN   T_CFUNDS_ADVANCE_V2.issue_by%TYPE) IS
-- This procedure will launch another browser window with html in report output and the user can
-- hit a print button from there.
        v_template          CLOB;
        v_template_date     DATE;
        v_offset            NUMBER         := 1;
        v_tag               VARCHAR2(100);
        v_query             VARCHAR2(4000);
        v_cursor            INTEGER;
        v_cnt               NUMBER;
        v_ok                BOOLEAN;
        v_expensed_amount   VARCHAR2(100);
        v_claimant_name     VARCHAR(100);
        v_custodian_name    VARCHAR(100);
        v_signature         VARCHAR2(100);
    BEGIN
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Advance_Details');

        --Check for Closed Advance
        SELECT COUNT(*)
          INTO v_cnt
          FROM v_cfunds_advance_v2
         WHERE SID = psid AND close_date IS NOT NULL;

        IF pcommand IS NULL AND v_cnt > 0 THEN
            -- when the form first comes up, allow the user to see and edit the custodian name.
            v_ok :=
                   Web_Template_Pkg.get_latest('cfunds_form_preamble', v_template, v_template_date);

            IF v_template_date IS NULL THEN
                Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_form_preamble"');
                htp.print('Could not locate template');
                RETURN;
            END IF;

            -- find the name of the Custodian if it exists.
            SELECT issue_by
              INTO v_custodian_name
              FROM v_cfunds_advance_v2
             WHERE SID = psid;

            --WEB_UTIL_PKG.SEND_COMMENT('Custodian is ' || v_custodian_name);
            v_ok :=
                 Web_Template_Pkg.replace_tag(v_template, 'FORM_TITLE', 'CONTINGENCY FUNDS ADVANCE');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template, 'TOP_LABEL', 'Custodian Name Verification');
            v_ok :=
                Web_Template_Pkg.replace_tag
                    (v_template,
                     'TEXTAREA_LABEL',
                     'Confirm that the name below is the correct name of the person who will sign this form.  If not, enter the correct name.');
            v_ok :=
                Web_Template_Pkg.replace_tag
                    (v_template,
                     'FEEDBACK',
                     'Custodian Name: <input maxLength="50" size="50" name="pCustodian_Name" value="'
                     || v_custodian_name || '">');
        ELSE
            -- once the user has edited the custodian name, the form will be shown.
            v_ok :=
                  Web_Template_Pkg.get_latest('cfunds_advance_form30', v_template, v_template_date);

            IF v_template_date IS NULL THEN
                Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_Advance_form30"');
                htp.print('Could not locate template');
                RETURN;
            END IF;
        END IF;

        Web_Util_Pkg.send_comment('Advance SID is ' || psid);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', psid);

-- Printform will launch another browser window with html in report output and the user can
-- hit a print button from there.
        FOR a IN (SELECT *
                    FROM v_cfunds_advance_v2
                   WHERE SID = psid)
        LOOP
            IF a.close_date IS NULL THEN                                               --not closed
                v_signature := '__________________________________';
            ELSE                                                                            --closed
                v_signature := '<font size="2"><u>PREVIOUSLY SIGNED<u></font>';
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DATE', a.request_date);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'AMOUNT',
                                             TO_CHAR(a.amount_requested, v_dollar_format));
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'PURPOSE', a.narrative);

            IF    a.check_amount = 0
               OR a.check_amount IS NULL THEN
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_DATE', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_AMOUNT', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_NUMBER', ' ');
            ELSE
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_DATE', a.issue_on);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'CHECK_AMOUNT',
                                                 TO_CHAR(a.check_amount, v_dollar_format));
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_NUMBER', a.check_number);
            END IF;

            IF    a.cash_amount = 0
               OR a.cash_amount IS NULL THEN
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_DATE', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_AMOUNT', ' ');
            ELSE
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_DATE', a.issue_on);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'CASH_AMOUNT',
                                                 TO_CHAR(a.cash_amount, v_dollar_format));
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'VOUCHER_NUM', a.voucher_no);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CLAIMANT_NAME_UNIT',
                                             a.claimant_name || '; ' || a.unit_name);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'SIGNATURE_BLOCK',
                                             v_signature,
                                             'WEBTOK@',
                                             TRUE);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'APPAUTH_NAME_UNIT', a.approved_by);
            v_ok :=
                  Web_Template_Pkg.replace_tag(v_template, 'CUSTODIAN_NAME', UPPER(pcustodian_name));
            v_claimant_name := REPLACE(a.CLAIMANT_NAME,'''','''''');

            IF a.expensed_amount IS NULL THEN
                v_expensed_amount := '$0.00';
            ELSE
                v_expensed_amount := TO_CHAR(a.expensed_amount, v_dollar_format);
            END IF;

            EXIT;
        END LOOP;

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            IF v_tag = 'REPAYMENT_LISTING' THEN
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                v_query := '';
                v_query := v_query || 'select';
                v_query := v_query || '     ar.VOUCHER_NO,';
                v_query := v_query || '     ar.RECEIVE_ON,';
                v_query :=
                    v_query || '     to_char(ar.TOTAL_AMOUNT,''' || v_dollar_format
                    || ''') as TOTAL_AMOUNT,';
                v_query := v_query || '     ''' || v_claimant_name || ''',';
                v_query := v_query || '     ar.RECEIVE_BY';
                v_query := v_query || ' from V_CFUNDS_ADVANCE_REPAYMENT_V2 ar';
                v_query := v_query || ' where ';
                v_query := v_query || '     ar.ADVANCE = ''' || psid || '''';
                v_query := v_query || ' order by';
                v_query := v_query || '     ar.RECEIVE_ON';
                DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                owa_util.cellsprint(v_cursor, 1000, NULL, v_cnt);

                IF v_expensed_amount <> '$0.00' THEN
                    htp.print('<TR><TD></TD><TD></TD><TD>' || v_expensed_amount
                              || '</TD><TD>Expense(s)</TD><TD></TD></TR>');
                END IF;
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;
    END advance_form30;

-- EFT Information
    PROCEDURE eft_info(
        pcommand          IN   VARCHAR2,
        peft_unit         IN   VARCHAR2,
        prouting_number   IN   VARCHAR2,
        paccount_number   IN   VARCHAR2,
        paccount_desc     IN   VARCHAR2,
        punit             IN   VARCHAR2,
        pfiscalyear       IN   VARCHAR2) IS
        v_template         CLOB;
        v_template_date    DATE;
        v_offset           NUMBER                   := 1;
        v_tag              VARCHAR2(100);
        v_query            VARCHAR2(4000);
        v_query_status     VARCHAR2(400);
        v_cursor           INTEGER;
        v_ok               BOOLEAN;
        v_fiscal_year      VARCHAR2(10);
        v_unit_sid         T_CFUNDS_UNIT.SID%TYPE;
        v_routing_number   VARCHAR2(30);                              --T_CFUNDS_UNIT.EFT_ABA%type;
        v_account_number   VARCHAR2(30);                              --T_CFUNDS_UNIT.EFT_DAN%type;
        v_account_desc     VARCHAR2(200);                       --T_CFUNDS_UNIT.EFT_ACCT_DESC%type;
    BEGIN
        Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
        begin_serve_page('E-Funds EFT Info', TRUE, TRUE, ' ', 'E-Funds EFT Info', 'DoHistory');
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.EFT_Info(' || pcommand || ')');
        v_ok := Web_Template_Pkg.get_latest('cfunds_eft_info', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_eft_info"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
        -- remember the Fiscal Year
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
        -- find the unit to default to if not sent in as a parameter
        v_unit_sid := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit_sid);
        Web_Util_Pkg.send_comment('pCommand is ' || pcommand);
        Web_Util_Pkg.send_comment('v_unit_sid is ' || v_unit_sid);

        IF pcommand = 'OK' THEN
            -- check for priv
            IF    Cfunds_Test_Cfp('CF_XFR_SWF',
                                  Core_Obj.lookup_objtype('NONE'),
                                  Core_Context.personnel_sid,
                                  v_unit_sid) = 'N'
               OR Cfunds_Test_Cfp('CF_XFR_RWF',
                                  Core_Obj.lookup_objtype('NONE'),
                                  Core_Context.personnel_sid,
                                  v_unit_sid) = 'N' THEN
                v_error_detail :=
                         'You do not have privilege to setup EFT info ' || 'in the specified unit.';
                RAISE a_stink;
            END IF;

            -- save values for later use.
            v_routing_number := prouting_number;
            v_account_number := paccount_number;
            v_account_desc := paccount_desc;

        -- if the textboxes are all empty, then make all fields null.
-- START HERE,
-- turn this into a script to look in AFOSI database and remove any
-- empty EFT information so it won't print a page when it shouldn't.
            IF     LTRIM(prouting_number) IS NULL
               AND LTRIM(paccount_number) IS NULL
               AND LTRIM(paccount_desc) IS NULL THEN
                v_routing_number := NULL;
                v_account_number := NULL;
                v_account_desc := NULL;
            ELSE
                -- don't allow partial saving
                IF LTRIM(prouting_number) IS NULL THEN
                    v_error_detail :=
                             'You must specify a routing number before saving any EFT information.';
                    RAISE a_stink;
                END IF;

                IF LTRIM(paccount_number) IS NULL THEN
                    v_error_detail :=
                            'You must specify an account number before saving any EFT information.';
                    RAISE a_stink;
                END IF;
            END IF;

            -- save data to database.
            UPDATE T_CFUNDS_UNIT
               SET eft_aba = v_routing_number,
                   eft_dan = v_account_number,
                   eft_acct_desc = v_account_desc
             WHERE SID = v_unit_sid;

            htp.print('EFT information was saved.');
        END IF;

        -- fill in the information if there is any for the selected unit.
        FOR u IN (SELECT *
                    FROM v_cfunds_unit
                   WHERE SID = v_unit_sid)
        LOOP
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'ROUTING_NUMBER', u.eft_aba);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'ACCOUNT_NUMBER', u.eft_dan);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'ACCOUNT_DESC', u.eft_acct_desc);
            EXIT;
        END LOOP;

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            IF v_tag = 'UNIT_LIST' THEN
                -- setup the cursor for the combo box to select a unit
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                v_query := '';
                v_query := v_query || ' select SID, UNIT_NAME, ';
                v_query :=
                    v_query || '     decode(SID, ''' || v_unit_sid || ''', ''Y'',null) as SELECTED';
                v_query := v_query || ' from V_CFUNDS_UNIT';
                --  v_query := v_query ||  ' where CFUNDS_TEST_CFP(''CF_LIM_SET_EXP'', core_context.personnel_sid, SID) = ''Y''';
                v_query := v_query || ' order by UNIT_CODE';
                DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
--                OWA_CORE_LISTPRINT(V_CURSOR, 'pEFT_Unit', 1, FALSE);
                owa_util.listprint(v_cursor, 'pEFT_Unit', 1, FALSE);
                DBMS_SQL.CLOSE_CURSOR(v_cursor);
            ELSE
                htp.print('[' || v_tag || ']');
            END IF;
        END LOOP;

        end_serve_page;
        setunitsid(v_unit_sid);
        set_fiscal_year(v_fiscal_year);
        COMMIT;         -- commit here is only done when the page has completed display successfully
    -- (no exceptions were raised).
    EXCEPTION
        WHEN a_stink THEN
            exception_handler(TRUE);
            end_serve_page;
            setunitsid(v_unit_sid);
            set_fiscal_year(v_fiscal_year);
        WHEN OTHERS THEN
            htp.print(SQLERRM);
            htp.nl;
            htp.print(Cfunds_Pkg.get_error_detail);
            htp.nl;
            end_serve_page;
            setunitsid(v_unit_sid);
            set_fiscal_year(v_fiscal_year);
            RETURN;
    END eft_info;

-- Expense Routines
    PROCEDURE expense_details(
        pcommand                  IN   VARCHAR2,
        psid                      IN   VARCHAR2,
        pcategory                 IN   VARCHAR2,
        pparagraph                IN   VARCHAR2,
        pdescription              IN   VARCHAR2,
        pcheck_amount             IN   NUMBER,
        pcheck_number             IN   VARCHAR2,
        pcash_amount              IN   NUMBER,
        padvance_created          IN   VARCHAR2,
        prepayment_check_amount   IN   NUMBER,
        prepayment_check_number   IN   VARCHAR2,
        prepayment_cash_amount    IN   NUMBER,
        prejection_comments       IN   VARCHAR2,
        paction                   IN   VARCHAR2,
        punit                     IN   VARCHAR2,
        pparams                   IN   VARCHAR2,
        ppersid                   IN   VARCHAR2,
        ptakefromadvance          IN   VARCHAR2,
        ptakefromother            IN   VARCHAR2,
        pfiscalyear               IN   VARCHAR2) IS
        v_template                 CLOB;
        v_template_date            DATE;
        v_offset                   NUMBER                                       := 1;
        v_tag                      VARCHAR2(100);
        v_query                    VARCHAR2(4000);
        v_cursor                   INTEGER;
        v_cnt                      NUMBER;
        v_ok                       BOOLEAN;
        v_execute_rtn              INTEGER;
        v_query2                   VARCHAR2(4000);
        v_cursor2                  INTEGER;
        v_code                     VARCHAR2(10);
        v_command1_specs           VARCHAR2(200);
        v_command2_specs           VARCHAR2(200);
        v_command3_specs           VARCHAR2(1000);
        v_command4_specs           VARCHAR2(1000);
        v_command5_specs           VARCHAR2(1000);
        v_voucher_no               VARCHAR2(100);
        v_action                   VARCHAR2(30);
        v_repayment_voucher_no     T_CFUNDS_EXPENSE_V3.repaid_voucher_no%TYPE;
        v_advance_voucher_no       T_CFUNDS_EXPENSE_V3.repaid_voucher_no%TYPE;
        v_temp_string              VARCHAR2(500);
        v_xfr_voucher_no           T_CFUNDS_XFR.voucher_no%TYPE;
        v_review_history           T_CFUNDS_EXPENSE_V3.review_history%TYPE;
        v_repayment_html           VARCHAR2(10000);
        v_payment_html             VARCHAR2(10000);
        v_payment_listings         VARCHAR2(10000);
        v_status_html              VARCHAR2(10000)                              := ' ';
        v_can_change_category      BOOLEAN                                      := FALSE;
        v_can_change_paragraph     BOOLEAN                                      := FALSE;
        v_can_change_description   BOOLEAN                                      := FALSE;
        v_fiscal_year              VARCHAR2(10);
        v_fiscal_year_label        VARCHAR2(10);
        v_new                      VARCHAR2(20);
        v_submitted                VARCHAR2(20);
        v_approved                 VARCHAR2(20);
        v_paid                     VARCHAR2(20);
        v_rejected                 VARCHAR2(20);
        v_returned                 VARCHAR2(20);
        v_repaid                   VARCHAR2(20);
        v_closed                   VARCHAR2(20);
        v_sidfound                 BOOLEAN;
        v_nextsid                  VARCHAR2(20);
        v_prevsid                  VARCHAR2(20);
        v_prevparagraph            VARCHAR2(40);
        v_nextparagraph            VARCHAR2(40);
        v_prevcategory             VARCHAR2(40);
        v_nextcategory             VARCHAR2(40);
        v_prevclaimant             VARCHAR2(40);
        v_nextclaimant             VARCHAR2(40);
        v_temp1                    VARCHAR2(200);
        v_temp2                    VARCHAR2(200);
        v_loopcount                INTEGER;
        v_idx                      INTEGER;
        v_found_idx1               INTEGER;
        v_found_idx2               INTEGER;
        v_found_end                INTEGER;
        v_len1                     INTEGER;
        v_len2                     INTEGER;
--     CURSOR c_expense(p_SID IN VARCHAR2) AS
--            SELECT *
--            FROM v_cfunds_expense_v2
--            WHERE sid = p_SID;
--
--     r_expense c_expense%ROWTYPE;
    BEGIN
--     OPEN c_expense(pSID);
--     FETCH c_expense INTO r_expense;
--     IF c_expense%NOTFOUND THEN
--         NULL;
--     END IF;

        --     CLOSE c_expense;

        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        -- xxx for next and prev fetches
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Expense_Details pParams are (' || pparams || ')');
        Web_Util_Pkg.send_comment('pParams = ' || pparams);
        v_new := 'bogus';
        v_submitted := 'bogus';
        v_approved := 'bogus';
        v_paid := 'bogus';
        v_rejected := 'bogus';
        v_returned := 'bogus';
        v_repaid := 'bogus';
        v_closed := 'bogus';

        IF INSTR(pparams, 'pNew') > 0 THEN
            v_new := 'New';
        END IF;

        IF INSTR(pparams, 'pSubmitted') > 0 THEN
            v_submitted := 'Submitted';
        END IF;

        IF INSTR(pparams, 'pApproved') > 0 THEN
            v_approved := 'Approved';
        END IF;

        IF INSTR(pparams, 'pPaid') > 0 THEN
            v_paid := 'Paid';
        END IF;

        IF INSTR(pparams, 'pRejected') > 0 THEN
            v_rejected := 'Rejected';
        END IF;

        IF INSTR(pparams, 'pReturned') > 0 THEN
            v_returned := 'Returned';
        END IF;

        IF INSTR(pparams, 'pRepaid') > 0 THEN
            v_repaid := 'Repaid';
        END IF;

        IF INSTR(pparams, 'pClosed') > 0 THEN
            v_closed := 'Closed';
        END IF;

-- xxx find next and prev in one shot, no workie
        v_sidfound := FALSE;
        v_nextsid := 'bogus';
        v_prevsid := 'bogus';
        v_nextparagraph := ' ';
        v_nextcategory := ' ';
        v_prevparagraph := ' ';
        v_prevcategory := ' ';

        FOR x IN
            (SELECT   COUNT(*) AS num_expenses, claimant, claimant_name
                 FROM v_cfunds_expense_v3
                WHERE (   status = v_new
                       OR status = v_submitted
                       OR status = v_approved
                       OR status = v_paid
                       OR status = v_rejected
                       OR status = v_returned
                       OR status = v_repaid
                       OR status = v_closed)
                  AND charge_to_unit = punit
                  AND TRUNC(incurred_date)
                          BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                              AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
             GROUP BY claimant_name, claimant)
        LOOP
            FOR e IN
                (SELECT   *
                     FROM v_cfunds_expense_v3
                    WHERE (   status = v_new
                           OR status = v_submitted
                           OR status = v_approved
                           OR status = v_paid
                           OR status = v_rejected
                           OR status = v_returned
                           OR status = v_repaid
                           OR status = v_closed)
                      AND claimant = x.claimant
                      AND charge_to_unit = punit
                      AND TRUNC(incurred_date)
                              BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                  AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                 ORDER BY incurred_date)
            LOOP
                IF v_sidfound = TRUE THEN
                    v_nextsid := e.SID;
                    v_nextparagraph := e.paragraph;
                    v_nextcategory := e.CATEGORY;
                    v_nextclaimant := e.claimant;
                    EXIT;
                END IF;

                IF e.SID = psid THEN
                    v_sidfound := TRUE;
                ELSE
                    v_prevsid := e.SID;
                    v_prevparagraph := e.paragraph;
                    v_prevcategory := e.CATEGORY;
                    v_prevclaimant := e.claimant;
                END IF;
            END LOOP;

            IF v_nextsid <> 'bogus' THEN
                EXIT;
            END IF;
        END LOOP;

        IF ppersid IS NULL THEN
            begin_serve_page('E-Funds Expense Details',
                             TRUE,
                             TRUE,
                             ' ',
                             'E-Funds Expense Details',
                             'Home_Page');
        ELSE
            begin_serve_page('E-Funds Expense Details',
                             TRUE,
                             TRUE,
                             ' ',
                             'E-Funds Expense Details',
                             'Expenses_For_Indiv?pSID=' || ppersid);
        END IF;

        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Expense_Details(' || pcommand || ')');

        IF paction IS NULL THEN
            v_action := 'Other';
        ELSE
            v_action := paction;
        END IF;

        IF pcommand = 'Return' THEN
            v_ok :=
                Web_Template_Pkg.get_latest('cfunds_expense_rejection_comments',
                                            v_template,
                                            v_template_date);
            v_action := 'Return';
        ELSIF pcommand = 'Reject' THEN
            v_ok :=
                Web_Template_Pkg.get_latest('cfunds_expense_rejection_comments',
                                            v_template,
                                            v_template_date);
            v_action := 'Reject';
        ELSIF pcommand = 'Repaid by Agent' THEN
            v_ok :=
                Web_Template_Pkg.get_latest('cfunds_expense_rejection_comments',
                                            v_template,
                                            v_template_date);
            v_action := 'Repaid by Agent';
        ELSIF pcommand = 'Delete' THEN
            v_ok :=
                  Web_Template_Pkg.get_latest('cfunds_expense_delete', v_template, v_template_date);
            v_action := 'Delete';
        ELSE
            v_ok :=
                 Web_Template_Pkg.get_latest('cfunds_expense_details', v_template, v_template_date);
        END IF;

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_expense_details"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- remember the Fiscal Year
        --v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'FISCAL_YEAR_LABEL', v_fiscal_year );
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'PER_SID', ppersid);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_SID', punit);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'PPARAMS', pparams);

        IF pcommand = 'OK' THEN
            IF v_action = 'Reject' THEN
                Cfunds_Pkg.reject_expense(psid, prejection_comments);
            ELSIF v_action = 'Repaid by Agent' THEN
                Cfunds_Pkg.repay_expense(psid,
                                         prepayment_cash_amount,
                                         prepayment_check_amount,
                                         prepayment_check_number,
                                         v_repayment_voucher_no,
                                         v_advance_voucher_no,
                                         v_xfr_voucher_no);
            ELSIF v_action = 'Return' THEN
                Cfunds_Pkg.disallow_expense(psid, prejection_comments);
            END IF;
        ELSIF pcommand = 'Reviewed' THEN
/*            UPDATE v_cfunds_expense_v3 e
               SET e.reviewed = 'Y',
                   e.review_history =
                       e.review_history || 'Reviewed in unit ' || e.reviewing_unit_name || ' by '
                       || Core_Context.personnel_name || ' on ' || SYSDATE || '.  '
             WHERE SID = psid; */

            UPDATE t_cfunds_expense_v3 e
               SET e.reviewed = 'Y',
                   e.review_history =
                       e.review_history || 'Reviewed in unit ' || osi_unit.get_name(e.reviewing_unit) || ' by '
                       || Core_Context.personnel_name || ' on ' || SYSDATE || '.  '
             WHERE SID=psid;
                          
        ELSIF pcommand = 'Approve' THEN
            UPDATE T_CFUNDS_EXPENSE_V3
               SET CATEGORY = pcategory,
                   paragraph = pparagraph,
                   description = pdescription,
                   take_from_advances = ptakefromadvance,
                   take_from_other_sources = ptakefromother
             WHERE SID = psid;

            Cfunds_Pkg.approve_expense(psid);
        ELSIF pcommand = 'Process Payment' THEN
            IF pcheck_amount IS NOT NULL THEN
                IF pcheck_number IS NULL THEN
                    v_error_detail := 'Missing check number.';
                    RAISE a_stink;
                END IF;
            END IF;

            UPDATE T_CFUNDS_EXPENSE_V3
               SET paragraph = pparagraph,
                   description = pdescription,
                   take_from_advances = ptakefromadvance,
                   take_from_other_sources = ptakefromother
             WHERE SID = psid;

            Cfunds_Pkg.pay_expense(psid, pcash_amount, pcheck_amount, pcheck_number, v_voucher_no);
        ELSIF pcommand = 'Re-submit Fixed Expense' THEN
            UPDATE T_CFUNDS_EXPENSE_V3
               SET paragraph = pparagraph,
                   description = pdescription
             WHERE SID = psid;

            Cfunds_Pkg.fix_expense(psid);
        ELSIF pcommand = 'Pay Agent' THEN
            -- record money given to the agent by the DET. (only happens for TFOS expenses)
            Cfunds_Pkg.pay_tfos_expense(psid, pcash_amount, pcheck_amount, pcheck_number);
        ELSIF pcommand = 'Delete' THEN
            DELETE FROM T_CFUNDS_EXPENSE_V3
                  WHERE SID = psid;
        END IF;

        IF v_action = 'Reject' THEN
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOP_LABEL', 'Reject Expense');
            v_ok :=
                   Web_Template_Pkg.replace_tag(v_template, 'TEXTAREA_LABEL', 'Rejection Comments');
        ELSIF v_action = 'Repaid by Agent' THEN
            v_ok :=
                 Web_Template_Pkg.replace_tag(v_template, 'TOP_LABEL', 'Confirm Expense Repayment');
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TEXTAREA_LABEL',
                                             'Details of Repayment Action');
            -- replace specific tag to show user what happened.
            v_temp_string := 'You have chosen to create a repayment for this expense.  The amount ';
            v_temp_string :=
                v_temp_string
                || trim(TO_CHAR(NVL(prepayment_check_amount, 0) + NVL(prepayment_cash_amount, 0),
                                v_dollar_format));
            v_temp_string := v_temp_string || ' is the amount the agent has given to you. ';
            v_temp_string := v_temp_string || ' If this amount is less than the amount paid';
            v_temp_string := v_temp_string || ' to the agent for this expense, clicking ''OK'' will';
            v_temp_string := v_temp_string || ' create an advance for the remaining amount. ';
            v_temp_string := v_temp_string || ' Click ''Cancel'' to stop this action.';
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FEEDBACK', v_temp_string);
            -- save the repayment values so that the repayment can be made when the
            -- user hits 'ok' (otherwise an advance gets created).
            v_ok :=
                Web_Template_Pkg.replace_tag
                                   (v_template,
                                    'REPAYMENT_PARAMS',
                                    '<INPUT TYPE="hidden" NAME="pRepayment_Cash_Amount" VALUE="'
                                    || prepayment_cash_amount || '">'
                                    || '<INPUT TYPE="hidden" NAME="pRepayment_Check_Amount" VALUE="'
                                    || prepayment_check_amount || '">'
                                    || '<INPUT TYPE="hidden" NAME="pRepayment_Check_Number" VALUE="'
                                    || prepayment_check_number || '">');
        ELSIF v_action = 'Return' THEN
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOP_LABEL', 'Returned Expense');
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TEXTAREA_LABEL',
                                             'Returned Expense Comments');
        END IF;

        -- Replace these tags if they weren't replaced before.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOP_LABEL', ' ');
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'TEXTAREA_LABEL', ' ');
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FEEDBACK', ' ');
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'REPAYMENT_PARAMS', ' ');
        -- save action value for next iteration of the form.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'ACTION', v_action);

        FOR e IN (SELECT *
                    FROM v_cfunds_expense_v3
                   WHERE SID = psid)
        LOOP
            IF e.incurred_date IS NOT NULL THEN
                -- if the fiscal year wasn't specified, use the incurred fiscal year.
                v_fiscal_year_label :=
                                      NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(e.incurred_date));
            ELSE
                v_fiscal_year_label := v_fiscal_year;
            END IF;

            v_ok :=
                  Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', v_fiscal_year_label);

            IF e.status = 'New' THEN
                v_command1_specs :=
                    '<input type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'expense_form?pSID=' || psid
                    || '")'' name="pCommand">';
                v_command2_specs := '<input type=''submit'' value=''Delete'' name="pCommand">';
                v_command3_specs := ' ';
            ELSIF e.status = 'Submitted' THEN
                v_command1_specs := '<input type=''submit'' value=''Approve'' name="pCommand">';
                v_command2_specs := '<input type=''submit'' value=''Return'' name="pCommand">';
                v_command3_specs := ' ';
                v_can_change_category := TRUE;
                v_can_change_paragraph := TRUE;
                v_can_change_description := TRUE;

                IF NVL(ABS(e.take_from_other_sources), 0) <> 0 THEN
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_OTHER', 'checked');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_OTHER', ' ');
                END IF;

                -- show the available advance balance if the agent wants to do this.
                IF ABS(e.take_from_advances) = 1 THEN
                    v_ok :=
                           Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_ADVANCE', 'checked');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_ADVANCE', ' ');
                END IF;
            ELSIF e.status = 'Approved' THEN
                v_command1_specs :=
                                '<input type=''submit'' value=''Process Payment'' name="pCommand">';
                v_command2_specs :=
                    '<input type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'expense_form?pSID=' || psid
                    || '")'' name="pCommand">';
                v_command3_specs := ' ';
                v_can_change_paragraph := TRUE;
                v_can_change_description := TRUE;
                v_payment_html := '';
                v_payment_html :=
                    v_payment_html
                    || '<tr><td colspan="2" height="35" width="230"><b>Payment Details: </b></td></tr>';

                IF NVL(ABS(e.take_from_other_sources), 0) <> 0 THEN
                    v_payment_html :=
                        v_payment_html
                        || '<tr><td width="70"></td><td colspan="3" width="320">This expense was paid from sources outside of OSI.  Please hit the "Process Payment" button without filling in any cash or check amounts.</td></tr>'
                        || '<tr><td width="70"> </td><td colspan="3" width="320"><font color="red">* Warning: Do not fill in the below fields.</font></td></tr>';
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_OTHER', 'checked');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_OTHER', ' ');
                END IF;

                -- show the available advance balance if the agent wants to do this.
                IF ABS(e.take_from_advances) = 1 THEN
--                 v_Payment_Html := v_Payment_Html || '<tr><td width="70"></td><td colspan="3" width="320">There is an advance balance of' || to_char(Cfunds_Pkg.GET_ADVANCE_TOTAL_AVAILABLE(e.CLAIMANT,e.CHARGE_TO_UNIT),v_dollar_format) || ' to apply towards this expense.</td></tr>'
--                     || '<tr><td width="70"> </td><td colspan="3" width="320"><font color="red">* Warning: It is possible that this amount could change prior to when the actual "Pay Expense" button is clicked.</font></td></tr>';
                    v_payment_html :=
                        v_payment_html
                        || '<tr><td width="70"></td><td colspan="3" width="320">There is an advance balance of'
                        || TO_CHAR(Cfunds_Pkg.get_advance_total_available(e.claimant,
                                                                          e.charge_to_unit),
                                   v_dollar_format)
                        || ' to apply towards this expense.</td></tr>'
                        || '<tr><td width="70"> </td><td colspan="3" width="320"><font color="red">* Note: To indicate that the total amount of '
                        || TO_CHAR(e.total_amount_us, v_dollar_format)
                        || ' is to be taken from the outstanding advance amount, leave the fields below empty and then press the "Process Payment" button.</font></td></tr>';
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_ADVANCE', 'checked');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_ADVANCE', ' ');
                END IF;

                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Agent Paid On: </td>';
                v_payment_html :=
                    v_payment_html
                    || '  <td nowrap><font class="DBdata"> </font></td><td></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Cash Amount: $</td>';
                v_payment_html :=
                    v_payment_html
                    || '  <td width="60"><input maxLength="15" size="10" name="pCash_Amount"    value = ></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Check Amount: $</td>';
                v_payment_html :=
                    v_payment_html
                    || '  <td width="60"><input maxLength="15" size="10" name="pCheck_Amount"    value = ></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Check Number: </td>';
                v_payment_html :=
                    v_payment_html
                    || '  <td width="60"><input maxLength="10" size="10" name="pCheck_Number"    value = ></td></tr>';
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PAYMENT_DETAILS', v_payment_html);
            ELSIF e.status = 'Disallowed' THEN
                v_command1_specs :=
                    '<input type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'expense_form?pSID=' || psid || '")''>';
                v_command2_specs := '<input type=''hidden'' value=''Hidden''>';
                v_command3_specs := '<input type=''hidden'' value=''Hidden''>';
                v_ok :=
                    Web_Template_Pkg.replace_tag
                        (v_template,
                         'REJECTION_COMMENTS',
                         '<tr> <td colspan="2" height="35" width="230"><b>Disallowed Expense Comments:</b></td></tr>'
                         || '<tr><td width="70" height="35"></td><td colspan="2" width="220">'
                         || e.rejection_comment || '</td></tr>');
            ELSIF e.status = 'Paid' THEN
                -- check here for TFOS...
                IF ABS(e.take_from_other_sources) = 1 AND e.tfos_on IS NULL THEN
                    v_payment_html := '';
                    v_payment_html :=
                        v_payment_html
                        || '<tr><td colspan="2" height="35" width="230"><b>Payment Details (DFO Funds): </b></td></tr>';
                    v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                    v_payment_html := v_payment_html || '  <td width="160">Agent Paid On: </td>';
                    v_payment_html :=
                        v_payment_html
                        || '  <td nowrap><font class="DBdata"> </font></td><td></td></tr>';
                    v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                    v_payment_html := v_payment_html || '  <td width="160">Cash Amount: $</td>';
                    v_payment_html :=
                        v_payment_html
                        || '  <td width="60"><input maxLength="15" size="10" name="pCash_Amount"    value = ></td></tr>';
                    v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                    v_payment_html := v_payment_html || '  <td width="160">Check Amount: $</td>';
                    v_payment_html :=
                        v_payment_html
                        || '  <td width="60"><input maxLength="15" size="10" name="pCheck_Amount"    value = ></td></tr>';
                    v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                    v_payment_html := v_payment_html || '  <td width="160">Check Number: </td>';
                    v_payment_html :=
                        v_payment_html
                        || '  <td width="60"><input maxLength="10" size="10" name="pCheck_Number"    value = ></td></tr>';
                    v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                    v_payment_html :=
                        v_payment_html
                        || '  <td colspan="2" width="220"><input type=''submit'' value=''Pay Agent'' name="pCommand"></td></tr>';
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'TFOS_PAYMENT_DETAILS',
                                                     v_payment_html);
                END IF;

                -- only show reviewed button when the expense needs to be reviewed.
                IF e.reviewed = 'Y' THEN
                    -- make sure that the unit is the one that should be doing the review.
                    IF Cfunds_Test_Cfp('EXP_INVALIDATE',
                                       Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                       Core_Context.personnel_sid,
                                       e.reviewing_unit) = 'Y' THEN
                        --old IF e.REVIEWING_UNIT = osi_personnel.get_current_unit(core_context.personnel_sid) THEN
                        v_command1_specs :=
                                         '<input type=''submit'' value=''Reject'' name="pCommand">';
                    ELSE
                        v_command1_specs := ' ';
                    END IF;

                    v_command2_specs :=
                        '<input type=''button'' value=''Print Form'' onclick=''PrintForm("'
                        || Web_Util_Pkg.get_current_package || 'expense_form?pSID=' || psid
                        || '")'' name="pCommand">';
                    v_command3_specs := ' ';
                ELSE
                    -- make sure that the unit is the one that should be doing the review.
                    IF Cfunds_Test_Cfp('EXP_INVALIDATE',
                                       Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                       Core_Context.personnel_sid,
                                       e.reviewing_unit) = 'Y' THEN
                        --old IF e.REVIEWING_UNIT = osi_personnel.get_current_unit(core_context.personnel_sid) THEN
                        v_command1_specs :=
                                       '<input type=''submit'' value=''Reviewed'' name="pCommand">';
                        v_command2_specs :=
                                         '<input type=''submit'' value=''Reject'' name="pCommand">';
                    ELSE
                        v_command1_specs := ' ';
                        v_command2_specs := ' ';
                    END IF;

                    v_command3_specs :=
                        '<input type=''button'' value=''Print Form'' onclick=''PrintForm("'
                        || Web_Util_Pkg.get_current_package || 'expense_form?pSID=' || psid
                        || '")'' name="pCommand">';
                END IF;
            ELSIF e.status = 'Rejected' THEN
                v_can_change_paragraph := TRUE;
                v_can_change_description := TRUE;
                v_command1_specs :=
                                '<input type=''submit'' value=''Repaid by Agent'' name="pCommand">';
                v_command2_specs :=
                        '<input type=''submit'' value=''Re-submit Fixed Expense'' name="pCommand">';
                v_command3_specs := ' ';
                v_ok :=
                    Web_Template_Pkg.replace_tag
                        (v_template,
                         'REJECTION_COMMENTS',
                         '<tr> <td colspan="2" height="35" width="230"><b>Rejected Expense Comments:</b></td></tr>'
                         || '<tr><td width="70" height="35"></td><td colspan="2" width="220">'
                         || e.invalidation_comment || '</td></tr>');
                v_repayment_html := '';
                v_repayment_html :=
                    v_repayment_html
                    || '<tr><td colspan="2" height="35" width="230"><b>Repayment Details: </b></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70"> </td>';
                v_repayment_html :=
                                  v_repayment_html || '  <td  width="160">Repayment Made On:  </td>';
                v_repayment_html :=
                          v_repayment_html || '  <td nowrap><font class="DBdata"> </font></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html :=
                    v_repayment_html
                    || '  <td width="220" colspan="2">Note: An Advance will be created if the Repayment amounts do not total the amount paid previously on this expense.</td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html := v_repayment_html || '  <td width="160">Cash Amount: $</td>';
                v_repayment_html :=
                    v_repayment_html
                    || '  <td width="60"><input maxLength="10" size="10" name="pRepayment_Cash_Amount"  value = ></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html := v_repayment_html || '  <td width="160">Check Amount: $</td>';
                v_repayment_html :=
                    v_repayment_html
                    || '  <td width="60"><input maxLength="10" size="10" name="pRepayment_Check_Amount"  value = ></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html := v_repayment_html || '  <td width="160">Check Number: </td>';
                v_repayment_html :=
                    v_repayment_html
                    || '  <td width="60"><input maxLength="10" size="10" name="pRepayment_Check_Number"  value = ></td></tr>';
                v_ok :=
                     Web_Template_Pkg.replace_tag(v_template, 'REPAYMENT_DETAILS', v_repayment_html);
            ELSIF e.status = 'Repaid' THEN
                v_command1_specs :=
                    '<input type=''button'' value=''Print Repayment Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'expense_repayment_form?pSID=' || psid
                    || '")'' name="pCommand">';
                v_command2_specs := ' ';
                v_command3_specs := ' ';
                v_repayment_html := '';
                v_repayment_html :=
                    v_repayment_html
                    || '<tr><td colspan="2" height="35" width="230"><b>Repayment Details: </b></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70"> </td>';
                v_repayment_html :=
                                 v_repayment_html || '  <td  width="160">Repayment Made On:  </td>';
                v_repayment_html :=
                    v_repayment_html || '  <td nowrap><font class="DBdata">' || e.repaid_on
                    || '</font></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html :=
                    v_repayment_html
                    || '  <td width="220" colspan="2">Note: This expense was repaid by creating an advance if the amounts below are zero.</td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html := v_repayment_html || '  <td width="160">Cash Amount: $</td>';
                v_repayment_html :=
                    v_repayment_html || '  <td nowrap><font class="DBdata">'
                    || e.repaid_cash_amount || '</font></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html := v_repayment_html || '  <td width="160">Check Amount: $</td>';
                v_repayment_html :=
                    v_repayment_html || '  <td nowrap><font class="DBdata">'
                    || e.repaid_check_amount || '</font></td></tr>';
                v_repayment_html := v_repayment_html || '<tr><td width="70" height="35" > </td>';
                v_repayment_html := v_repayment_html || '  <td width="160">Check Number: </td>';
                v_repayment_html :=
                    v_repayment_html || '  <td nowrap><font class="DBdata">'
                    || e.repaid_check_number || '</font></td></tr>';
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template, 'REPAYMENT_DETAILS', v_repayment_html);
            ELSE                                                              -- e.STATUS = 'Closed'
                v_command1_specs :=
                    '<input type=''button'' value=''Print Form'' onclick=''PrintForm("'
                    || Web_Util_Pkg.get_current_package || 'expense_form?pSID=' || psid
                    || '")'' name="pCommand">';
                v_command2_specs := ' ';
                v_command3_specs := ' ';
            END IF;

            -- xxx
            IF v_prevsid <> 'bogus' THEN
                v_command4_specs :=
                    '<input type="button" value="Previous Expense" onclick=location="'
                    || Web_Util_Pkg.get_current_package || 'expense_details?pSID=' || v_prevsid
                    || '&pCategory=' || v_prevcategory || '&pParagraph=' || v_prevparagraph
                    || '&pPerSid=' || v_prevclaimant || '&pUnit=' || punit || '&pFiscalYear='
                    || pfiscalyear || '&pParams=' || pparams || '">';
                Core_Logger.log_it(c_pipe,
                                   'Expense_Details v_command4_specs is (' || v_command4_specs
                                   || ')');
            ELSE
                v_command4_specs := ' ';
            END IF;

            IF v_nextsid <> 'bogus' THEN
                v_command5_specs :=
                    '<input type="button" value="Next Expense" onclick=location="'
                    || Web_Util_Pkg.get_current_package || 'expense_details?pSID=' || v_nextsid
                    || '&pCategory=' || v_nextcategory || '&pParagraph=' || v_nextparagraph
                    || '&pPerSid=' || v_nextclaimant || '&pUnit=' || punit || '&pFiscalYear='
                    || pfiscalyear || '&pParams=' || pparams || '">';
                Core_Logger.log_it(c_pipe,
                                   'Expense_Details v_command5_specs is (' || v_command5_specs
                                   || ')');
            ELSE
                v_command5_specs := ' ';
            END IF;

            -- replace these tags if they didn't get replaced above.
            v_ok :=
                Web_Template_Pkg.replace_tag
                    (v_template,
                     'REJECTION_NOTE',
                     'Note: An Advance will be created if the Repayment amounts don''t total the amount paid previously on this expense.');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'REJECTION_COMMENTS', ' ');
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_1', v_command1_specs);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_2', v_command2_specs);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_3', v_command3_specs);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_4', v_command4_specs);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_5', v_command5_specs);
            -- save SID value for next iteration of the form.
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', e.SID);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'EXPENSE_DATE', e.incurred_date);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', e.voucher_no);

            IF NVL(ABS(e.take_from_other_sources), 0) <> 0 THEN
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_OTHER', 'disabled checked');
            ELSE
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_OTHER', 'disabled');
            END IF;

            -- show the available advance balance if the agent wants to do this.
            IF ABS(e.take_from_advances) = 1 THEN
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'TAKE_FROM_ADVANCE',
                                                 'disabled checked');
            ELSE
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAKE_FROM_ADVANCE', 'disabled');
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'STATUS_DESC', e.status);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CLAIMANT_NAME', e.claimant_name);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_NAME', e.charge_to_unit_name);

            --  code here makes Category a label when it shouldn't be changed.
            -- ( only can change when the expense is in Submitted state).
            -- Otherwise it will create a drop-down box.
            IF NOT v_can_change_category THEN
                -- replace tag for category
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'CATEGORY',
                                                 '<font class="DBdata">' || e.category_desc
                                                 || '</font>');
            END IF;

            --  code here makes Paragraph a label when it shouldn't be changed.
            -- ( can change when the expense is in Submitted, Approved, or Returned state).
            -- Otherwise it will create a drop-down box.
            IF NOT v_can_change_paragraph THEN
                -- replace tag for paragraph
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'PARAGRAPH',
                                                 '<font class="DBdata">' || e.paragraph_content
                                                 || '</font>');
            END IF;

            --  code here makes the Justification/Description text box readonly when it shouldn't be changed.
            IF NOT v_can_change_description THEN
                -- make textbox readonly.
                v_ok :=
                    Web_Template_Pkg.replace_tag
                        (v_template,
                         'DESCRIPTION',
                         '<textarea readonly name="pDescription" rows=5 cols=56 valign="top" width="590">'
                         || e.description || '</textarea>');
            ELSE
                v_ok :=
                    Web_Template_Pkg.replace_tag
                        (v_template,
                         'DESCRIPTION',
                         '<textarea name="pDescription" rows=5 cols=56 valign="top" width="590">'
                         || e.description || '</textarea>');
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CONTEXT', e.parent_info);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SOURCE_NO', NVL(e.source_id, 'N/A'));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'SOURCE_AMT',
                                             TO_CHAR(e.source_amount, v_amount_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'RECEIPTS_DISPO',
                                             NVL(e.receipt_disposition_desc, 'N/A'));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'AGENT_AMT',
                                             TO_CHAR(e.agent_amount, v_amount_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'AMOUNT_SPENT',
                                             TO_CHAR(e.total_amount, v_amount_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CONVERSION_RATE',
                                             TO_CHAR(e.conversion_rate, v_conversion_rate_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMT_US',
                                             TO_CHAR(e.total_amount_us, v_dollar_format));

            IF    e.paid_on IS NULL
               OR ABS(e.take_from_other_sources) = 1 THEN
                v_payment_html := ' ';
            ELSE
                v_payment_html := '';
                v_payment_html :=
                    v_payment_html
                    || '<tr><td colspan="2" height="35" width="230"><b>Payment Details: </b></td></tr>';

                IF ABS(e.take_from_advances) = 1 THEN
                    IF NVL(e.advance_amount, 0) > 0 THEN
                        v_payment_html :=
                            v_payment_html
                            || '<tr><td width="70" height="35"></td><td colspan="2" width="220"><b>'
                            || TO_CHAR(e.advance_amount, v_dollar_format)
                            || ' was taken from Advance balance.</b></td></tr>';
                    END IF;
                END IF;

                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Agent Paid On: </td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">' || e.paid_on
                    || '</font></td><td></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Cash Amount:</td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">'
                    || TO_CHAR(e.paid_cash_amount, v_dollar_format) || '</font></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Check Amount:</td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">'
                    || TO_CHAR(e.paid_check_amount, v_dollar_format) || '</font></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Check Number: </td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">' || e.paid_check_number
                    || '</font></td></tr>';
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'PAYMENT_DETAILS', v_payment_html);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'REPAYMENT_DETAILS', ' ');

            IF e.tfos_on IS NULL THEN
                v_payment_html := ' ';
            ELSE
                v_payment_html := '';
                v_payment_html :=
                    v_payment_html
                    || '<tr><td colspan="2" height="35" width="230"><b>DFO Funds Payment Details: </b></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Agent Paid On: </td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">' || e.tfos_on
                    || '</font></td><td></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Cash Amount:</td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">'
                    || TO_CHAR(e.tfos_cash_amount, v_dollar_format) || '</font></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Check Amount:</td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">'
                    || TO_CHAR(e.tfos_check_amount, v_dollar_format) || '</font></td></tr>';
                v_payment_html := v_payment_html || '<tr><td width="70"> </td>';
                v_payment_html := v_payment_html || '  <td width="160">Check Number: </td>';
                v_payment_html :=
                    v_payment_html || '  <td nowrap><font class="DBdata">' || e.tfos_check_number
                    || '</font></td></tr>';
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'TFOS_PAYMENT_DETAILS', v_payment_html);
            v_review_history := ' ';

            IF e.reviewing_unit_name IS NOT NULL THEN
                IF e.status <> 'Repaid' THEN
                    v_review_history :=
                        '<tr><td colspan="2" height="35" width="230"><b>Review History: </b></td></tr>';
                    v_review_history := v_review_history || '<tr>';
                    v_review_history :=
                        v_review_history
                        || '<td width="70"></td><td>Unit currently reviewing:</td>';
                    v_review_history :=
                        v_review_history || '<td><font class="DBdata">' || e.reviewing_unit_name
                        || '</font></td>';
                    v_review_history := v_review_history || '</tr>';
                END IF;
            END IF;

            IF e.review_history IS NOT NULL THEN
                IF v_review_history = ' ' THEN
                    v_review_history :=
                        '<tr><td colspan="2" height="35" width="230"><b>Review History: </b></td></tr>';
                END IF;

                v_review_history := v_review_history || '<tr>';
                v_review_history := v_review_history || '<td width="70"></td>';
                v_review_history :=
                    v_review_history || '<td colspan="3" width="420"><font class="DBdata">'
                    || e.review_history || '</font></td>';
                v_review_history := v_review_history || '</tr>';
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'REVIEW_HISTORY', v_review_history);
            -- show transfers that contain this expense.
            v_payment_listings := '';
            v_payment_listings :=
                v_payment_listings
                || '<tr><td colspan="4" height="35" width="490"><b>Transfers Containing this Expense: </b></td></tr>';
            v_loopcount := 0;

            FOR x IN (SELECT x.SID, x.voucher_no, x.receive_date, x.sender, x.xfr_type
                        FROM T_CFUNDS_XFR_EXP xe, T_CFUNDS_EXPENSE_V3 EXP, T_CFUNDS_XFR x
                       WHERE EXP.SID = xe.expense AND xe.xfr = x.SID AND EXP.SID = e.SID)
            LOOP
                v_loopcount := v_loopcount + 1;
                v_payment_listings := v_payment_listings || '<tr>';
                v_payment_listings := v_payment_listings || '<td width="70"></td>';

                IF x.xfr_type = 'ER' THEN
                    v_payment_listings :=
                               v_payment_listings || '<td colspan="3" width="420">Payment Listing ';
                ELSE
                    v_payment_listings :=
                        v_payment_listings
                        || '<td colspan="3" width="420">Returned Expense Repayment ';
                END IF;

                v_payment_listings :=
                    v_payment_listings || '<a  href="' || Web_Util_Pkg.get_current_package
                    || 'payment_listing_details?pXfr=' || x.SID || '&pFiscalYear=' || v_fiscal_year
                    || '">' || x.voucher_no || '</a>';

                IF x.receive_date IS NULL THEN
                    v_payment_listings := v_payment_listings || ' is pending.<N/td>';
                ELSE
                    v_payment_listings := v_payment_listings || ' was received.</td>';
                END IF;

                v_payment_listings := v_payment_listings || '</tr>';
            END LOOP;

            IF v_loopcount > 0 THEN
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template, 'PAYMENT_LISTINGS',
                                                 v_payment_listings);
            ELSE
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PAYMENT_LISTINGS', ' ');
            END IF;

            --xxx status report table
            --v_Status_Html := '<table border=1><tr><td> Status </td><td> By </td><td> Date </td></tr>';
            --v_Status_Html := '<tr><td  colspan="4" height="35" width="490"><b> Status Report</b></td></tr>';
            Core_Logger.log_it(c_pipe, 'expense detail - status processing (' || psid || ')');
            v_status_html :=
                v_status_html
                || '<tr><td><br><b> Status </b></td><td><br><b> By </b></td><td><br><b> Date </b></td></tr>';

            IF e.claimant IS NOT NULL AND e.incurred_date IS NOT NULL THEN
                v_status_html :=
                     v_status_html || '<tr><td> Incurred </td> <td> ' || e.claimant_name || '</td>';
                v_status_html := v_status_html || '<td> ' || e.incurred_date || ' </td></tr>';
            END IF;

            IF e.create_by IS NOT NULL AND e.create_on IS NOT NULL THEN
                v_status_html :=
                          v_status_html || '<tr><td> Created </td> <td> ' || e.create_by || '</td>';
                v_status_html := v_status_html || '<td> ' || e.create_on || ' </td></tr>';
            END IF;

            IF e.create_by IS NOT NULL AND e.submitted_on IS NOT NULL THEN
                Core_Logger.log_it(c_pipe, 'expense detail - skipping submitted (' || psid || ')');
            ELSE
                v_status_html :=
                        v_status_html || '<tr><td> Submitted </td> <td> ' || e.create_by || '</td>';
                v_status_html := v_status_html || '<td> ' || e.submitted_on || ' </td></tr>';
            END IF;

            IF e.approved_by IS NOT NULL AND e.approved_on IS NOT NULL THEN
                v_status_html :=
                       v_status_html || '<tr><td> Approved </td> <td> ' || e.approved_by || '</td>';
                v_status_html := v_status_html || '<td> ' || e.approved_on || ' </td></tr>';
            END IF;

            IF e.rejected_by IS NOT NULL AND e.rejected_on IS NOT NULL THEN
                v_status_html :=
                     v_status_html || '<tr><td> Disallowed </td> <td> ' || e.rejected_by || '</td>';
                v_status_html := v_status_html || '<td> ' || e.rejected_on || ' </td></tr>';
            END IF;

            IF e.paid_by IS NOT NULL AND e.paid_on IS NOT NULL THEN
                v_status_html :=
                               v_status_html || '<tr><td> Paid </td> <td> ' || e.paid_by || '</td>';
                v_status_html := v_status_html || '<td> ' || e.paid_on || ' </td></tr>';
            END IF;

            IF e.invalidated_by IS NOT NULL AND e.invalidated_on IS NOT NULL THEN
                v_status_html :=
                    v_status_html || '<tr><td> Invalidated </td> <td> ' || e.invalidated_by
                    || '</td>';
                v_status_html := v_status_html || '<td> ' || e.invalidated_on || ' </td></tr>';
            END IF;

            IF e.claimant_name IS NOT NULL AND e.repaid_on IS NOT NULL THEN
                v_status_html :=
                       v_status_html || '<tr><td> Repaid </td> <td> ' || e.claimant_name || '</td>';
                v_status_html := v_status_html || '<td> ' || e.repaid_on || ' </td></tr>';
            END IF;

            IF e.review_history IS NOT NULL THEN
                v_idx := 1;

                LOOP
                    v_found_idx1 := INSTR(e.review_history, ' by ', v_idx);

                    IF    v_found_idx1 IS NULL
                       OR v_found_idx1 = 0 THEN
                        EXIT;
                    END IF;

                    v_found_idx2 := INSTR(e.review_history, ' on ', v_idx);

                    IF    v_found_idx2 IS NULL
                       OR v_found_idx2 = 0 THEN
                        EXIT;
                    END IF;

                    v_found_end := INSTR(e.review_history, '.  ', v_idx);

                    IF    v_found_end IS NULL
                       OR v_found_end = 0 THEN
                        EXIT;
                    END IF;

                    v_found_idx1 := v_found_idx1 + 4;
                    v_found_idx2 := v_found_idx2 + 4;
                    v_len1 := v_found_idx2 - v_found_idx1 - 3;
                    v_len2 := v_found_end - v_found_idx2;
                    v_temp1 := SUBSTR(e.review_history, v_found_idx1, v_len1);
                    v_temp2 := SUBSTR(e.review_history, v_found_idx2, v_len2);
                    v_status_html :=
                              v_status_html || '<tr><td> Reviewed </td> <td> ' || v_temp1 || '</td>';
                    v_status_html := v_status_html || '<td> ' || v_temp2 || ' </td></tr>';
                    v_idx := v_found_end + 4;
                END LOOP;
            END IF;

            v_ok := Web_Template_Pkg.replace_tag(v_template, 'STATUS_LISTINGS', v_status_html);
            EXIT;
        END LOOP;

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            IF v_tag = 'CATEGORY' THEN
                -- setup the cursor for the category combo box
                v_cursor2 := DBMS_SQL.OPEN_CURSOR;
                v_query2 := '';
                v_query2 := v_query2 || ' select';
                v_query2 := v_query2 || '     cc.CODE,';
                v_query2 := v_query2 || '     cc.DESCRIPTION,';
                v_query2 :=
                    v_query2 || '     decode(cc.CODE, ''' || pcategory
                    || ''', ''Y'',null) as SELECTED';
                v_query2 := v_query2 || ' from T_CFUNDS_CATEGORIES cc';
                DBMS_SQL.PARSE(v_cursor2, v_query2, dbms_sql.native);
--                OWA_CORE_LISTPRINT(V_CURSOR2, 'pCategory', 1, FALSE);
                owa_util.listprint(v_cursor2, 'pCategory', 1, FALSE);
                DBMS_SQL.CLOSE_CURSOR(v_cursor2);
            ELSIF v_tag = 'PARAGRAPH' THEN
                /* The following query adds one row to match up to a 'null' paragraph
                   so that the User Interface can indicate that nothing was selected.
                   This only is necessary for fields that aren't required.
                */
                v_cursor2 := DBMS_SQL.OPEN_CURSOR;
                v_query2 := '';
                v_query2 := v_query2 || ' select';
                v_query2 := v_query2 || '     cfp.PARAGRAPH,';
                v_query2 := v_query2 || '     substr(cfp.CONTENT,1,100),';
                v_query2 :=
                    v_query2 || '     decode(cfp.PARAGRAPH, ''' || pparagraph
                    || ''', ''Y'',null) as SELECTED';
                v_query2 := v_query2 || '     from (';
                v_query2 :=
                        v_query2 || '     select null as PARAGRAPH, ''(none selected)'' as CONTENT';
                v_query2 := v_query2 || '     from dual';
                v_query2 := v_query2 || '     union all';
                v_query2 := v_query2 || '     select';
                v_query2 := v_query2 || '     PARAGRAPH,';
                v_query2 := v_query2 || '     substr(CONTENT,1,100)';
                v_query2 := v_query2 || '     from T_CFUNDS_PARAGRAPHS) cfp';
                DBMS_SQL.PARSE(v_cursor2, v_query2, dbms_sql.native);
--                OWA_CORE_LISTPRINT(V_CURSOR2, 'pParagraph', 1, FALSE);
                owa_util.listprint(v_cursor2, 'pParagraph', 1, FALSE);
                DBMS_SQL.CLOSE_CURSOR(v_cursor2);
            ELSE
                htp.print('[WEBTOK@' || v_tag || ']');
            END IF;
        END LOOP;

        end_serve_page;
        setvparams(pparams);
        setunitsid(punit);
        set_fiscal_year(v_fiscal_year);
        COMMIT;         -- commit here is only done when the page has completed display successfully
    -- (no exceptions were raised).
    EXCEPTION
        WHEN a_stink THEN
            exception_handler(TRUE);
            end_serve_page;
            setvparams(pparams);
            setunitsid(punit);
            set_fiscal_year(v_fiscal_year);
        WHEN Cfunds_Pkg.bad_timing THEN
            exception_handler;
            end_serve_page;
            setvparams(pparams);
            setunitsid(punit);
            set_fiscal_year(v_fiscal_year);
        WHEN Cfunds_Pkg.no_privilege THEN
            exception_handler;
            end_serve_page;
            setvparams(pparams);
            setunitsid(punit);
            set_fiscal_year(v_fiscal_year);
        WHEN Cfunds_Pkg.invalid_parameters THEN
            exception_handler;
            end_serve_page;
            setvparams(pparams);
            setunitsid(punit);
            set_fiscal_year(v_fiscal_year);
        WHEN OTHERS THEN
            htp.print(SQLERRM);
            htp.nl;
            htp.print(Cfunds_Pkg.get_error_detail);
            htp.nl;
            end_serve_page;
            setvparams(pparams);
            setunitsid(punit);
            set_fiscal_year(v_fiscal_year);
            ROLLBACK;
    END expense_details;

    PROCEDURE expense_form(
        psid             IN   VARCHAR2,
        pcommand         IN   VARCHAR2,
        papprover_name   IN   T_CFUNDS_EXPENSE_V3.approved_by%TYPE) IS
-- This procedure will launch another browser window with html in report output and the user can
-- hit a print button from there.
        v_template        CLOB;
        v_template_date   DATE;
        v_offset          NUMBER                             := 1;
        v_tag             VARCHAR2(100);
        v_query           VARCHAR2(4000);
        v_cursor          INTEGER;
        v_ok              BOOLEAN;
        v_approver_name   T_CFUNDS_EXPENSE_V3.paid_by%TYPE;
        v_cnt             NUMBER;
        v_signature       VARCHAR2(100);
    BEGIN
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Expense_Form');
        v_ok := Web_Template_Pkg.get_latest('cfunds_expense_form', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_expense_form"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        Web_Util_Pkg.send_comment('Expense SID is ' || psid);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', psid);

        FOR e IN (SELECT *
                    FROM v_cfunds_expense_v3
                   WHERE SID = psid)
        LOOP
            v_signature := '__________________________________';
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SOURCE_ID', e.source_id);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'VOUCHER_NO', e.voucher_no);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CONTEXT', e.parent_info);
            v_ok :=
                   Web_Template_Pkg.replace_tag(v_template, 'RECEIPTS', e.receipt_disposition_desc);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DATE', e.incurred_date);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CATEGORY_DESC', e.category_desc);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'PARAGRAPH', e.paragraph_content);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DESCRIPTION', e.description);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'SOURCE_AMOUNT',
                                             TO_CHAR(e.source_amount, v_amount_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'AGENT_AMOUNT',
                                             TO_CHAR(e.agent_amount, v_amount_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'AMOUNT_SPENT',
                                             TO_CHAR(e.source_amount + e.agent_amount,
                                                     v_amount_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CONVERSION_RATE',
                                             TO_CHAR(e.conversion_rate, v_conversion_rate_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'TOTAL_AMOUNT',
                                             TO_CHAR(e.total_amount_us, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CLAIMANT_NAME',
                                             e.claimant_name,
                                             'WEBTOK@',
                                             TRUE);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CUST_NAME', UPPER(papprover_name));

            IF ABS(e.take_from_other_sources) = 1 THEN
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'DFO_ISSUED_FUNDS',
                                                 '(DFO ISSUED FUNDS)');

                IF    e.tfos_check_amount = 0
                   OR e.tfos_check_amount IS NULL THEN
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_DATE', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_AMOUNT', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_NUMBER', ' ');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_DATE', e.tfos_on);
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'CHECK_AMOUNT',
                                                     TO_CHAR(e.tfos_check_amount, v_dollar_format));
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template, 'CHECK_NUMBER',
                                                     e.tfos_check_number);
                END IF;

                IF    e.tfos_cash_amount = 0
                   OR e.tfos_cash_amount IS NULL THEN
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_DATE', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_AMOUNT', ' ');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_DATE', e.tfos_on);
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'CASH_AMOUNT',
                                                     TO_CHAR(e.tfos_cash_amount, v_dollar_format));
                END IF;
            ELSE
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'DFO_ISSUED_FUNDS', ' ');

                IF    e.paid_check_amount = 0
                   OR e.paid_check_amount IS NULL THEN
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_DATE', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_AMOUNT', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_NUMBER', ' ');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_DATE', e.paid_on);
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'CHECK_AMOUNT',
                                                     TO_CHAR(e.paid_check_amount, v_dollar_format));
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template, 'CHECK_NUMBER',
                                                     e.paid_check_number);
                END IF;

                IF    e.paid_cash_amount = 0
                   OR e.paid_cash_amount IS NULL THEN
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_DATE', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_AMOUNT', ' ');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_DATE', e.paid_on);
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'CASH_AMOUNT',
                                                     TO_CHAR(e.paid_cash_amount, v_dollar_format));
                END IF;
            END IF;

            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'SIGNATURE_BLOCK',
                                             v_signature,
                                             'WEBTOK@',
                                             TRUE);
            EXIT;
        END LOOP;

        v_ok := Web_Template_Pkg.serve_clob(v_template);
    END expense_form;

    PROCEDURE expense_repayment_form(psid IN VARCHAR2) IS
-- This procedure will launch another browser window with html in report output and the user can
-- hit a print button from there.
        v_template        CLOB;
        v_template_date   DATE;
        v_offset          NUMBER         := 1;
        v_tag             VARCHAR2(100);
        v_query           VARCHAR2(4000);
        v_cursor          INTEGER;
        v_ok              BOOLEAN;
    --v_last_name Varchar2(100);
    BEGIN
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Expense_Repayment_Form');
        v_ok :=
            Web_Template_Pkg.get_latest('cfunds_expense_repayment_form',
                                        v_template,
                                        v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe,
                               '  Could not locate template "cfunds_expense_repayment_form"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        Web_Util_Pkg.send_comment('Expense SID is ' || psid);

        FOR e IN (SELECT *
                    FROM v_cfunds_expense_v3
                   WHERE SID = psid)
        LOOP
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'VOUCHER_NO', e.voucher_no);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'DATE', e.incurred_date);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'REPAYMENT_VOUCHER_NO',
                                             e.repaid_voucher_no);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'REPAYMENT_DATE', e.repaid_on);
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CASH_AMOUNT',
                                             TO_CHAR(e.repaid_cash_amount, v_dollar_format));
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CHECK_AMOUNT',
                                             TO_CHAR(e.repaid_check_amount, v_dollar_format));
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_NUMBER', e.repaid_check_number);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'CLAIMANT_NAME_UNIT', e.claimant_name);
        -- Decided to use the cutsodian that is logged in name for the this as the Custodian Name on the Form
--        v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'CFUNDS_CUST_NAME_UNIT', ' ??? how to find this ???' );
        --select LAST_NAME into v_last_name from T_UNIT_ASSIGNMENT, T_PERSONNEL where T_UNIT_ASSIGNMENT.UNIT = Cfunds_Pkg.Get_My_Cfunds_Unit and (T_UNIT_ASSIGNMENT.ASSIGN_ROLE='CFDETCUST' or T_UNIT_ASSIGNMENT.ASSIGN_ROLE='CFDETCUSTLIM' or T_UNIT_ASSIGNMENT.ASSIGN_ROLE='CFMGR') and T_PERSONNEL.SID = T_UNIT_ASSIGNMENT.PERSONNEL;
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'CFUNDS_CUST_NAME_UNIT',
                                             Core_Context.personnel_name);
            EXIT;
        END LOOP;

        v_ok := Web_Template_Pkg.serve_clob(v_template);
    END expense_repayment_form;

    PROCEDURE expenses_by_personnel(
        pcommand          IN   VARCHAR2,
        pnew              IN   VARCHAR2,
        psubmitted        IN   VARCHAR2,
        papproved         IN   VARCHAR2,
        ppaid             IN   VARCHAR2,
        prejected         IN   VARCHAR2,
        preturned         IN   VARCHAR2,
        prepaid           IN   VARCHAR2,
        pclosed           IN   VARCHAR2,
        ppaymentlisting   IN   VARCHAR2,
        punit             IN   VARCHAR2,
        pfiscalyear       IN   VARCHAR2,
        punitpick         IN   VARCHAR2) IS
        v_template                 CLOB;
        v_template_date            DATE;
        v_offset                   NUMBER                   := 1;
        v_tag                      VARCHAR2(100);
        v_query                    VARCHAR2(4000);
        v_query_status             VARCHAR2(400);
        v_cursor                   INTEGER;
        v_cnt                      NUMBER;
        v_ok                       BOOLEAN;
        v_params                   VARCHAR2(1000);
        v_filter_list              VARCHAR2(1000);
        v_unit_name                VARCHAR2(50);
        v_usage                    VARCHAR2(20);
        v_form_caption             VARCHAR2(50);
        v_unit_constructor         VARCHAR2(10);
        v_unit                     T_CFUNDS_UNIT.SID%TYPE;
        v_total_payment_due_unit   NUMBER;
        v_fiscal_year              VARCHAR2(10);

        PROCEDURE add_filter_item(
            pcontrol_name   IN   VARCHAR2,
            ponoff          IN   VARCHAR2,
            pdisplayname    IN   VARCHAR2) IS
        BEGIN
            -- setup the string for the filterbar,
            v_ok := Core_List.add_item_to_list(pcontrol_name, v_filter_list);
            v_ok := Core_List.add_item_to_list(ponoff, v_filter_list);
            v_ok := Core_List.add_item_to_list(pdisplayname, v_filter_list);

            -- Set parameters to be sent to next page and status parameters
            IF ponoff IS NOT NULL THEN
                v_params := v_params || '&' || pcontrol_name || '=' || ponoff;
                v_query_status := v_query_status || ',''' || pdisplayname || '''';
            END IF;
        END add_filter_item;

        FUNCTION get_form_usage
            RETURN VARCHAR2 IS
        BEGIN
            IF ppaymentlisting IS NOT NULL THEN
                v_form_caption := 'Current Payment Listing';
                v_unit_constructor := ' for ';
                RETURN 'PaymentListing';
            END IF;

            IF psubmitted = 'only' THEN
                v_form_caption := 'Expenses to be Approved';
                v_unit_constructor := ' in ';
                RETURN 'Approval';
            END IF;

            IF papproved = 'only' THEN
                v_form_caption := 'Expenses to be Paid';
                v_unit_constructor := ' in ';
                RETURN 'Payment';
            END IF;

            v_form_caption := 'E-Funds Expenses by Personnel';
            v_unit_constructor := ' for ';
            RETURN 'FilteredList';
        END get_form_usage;
    BEGIN
        v_usage := get_form_usage;
        v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
        -- find the name of this unit whose expenses are showing.
        v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
        Core_Logger.log_it(c_pipe,
                           'v_usage = ' || v_usage || ', v_unit = ' || v_unit || ', v_unit_name = '
                           || v_unit_name);

        IF v_usage = 'FilteredList' THEN
            begin_serve_page(v_form_caption || v_unit_constructor || v_unit_name,
                             TRUE,
                             TRUE,
                             NULL,
                             v_form_caption,
                             'home_page');
        ELSE
            begin_serve_page(v_form_caption || v_unit_constructor || v_unit_name,
                             TRUE,
                             TRUE,
                             v_form_caption,
                             v_unit_constructor || v_unit_name,
                             'home_page');
        END IF;

        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Expenses_By_Personnel(' || pcommand || ')');
        v_ok :=
            Web_Template_Pkg.get_latest('cfunds_expenses_by_personnel', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe,
                               '  Could not locate template "cfunds_expenses_by_personnel"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
        -- remember the Fiscal Year
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'FISCAL_YEAR_LABEL',
                                         get_html_fy_dropdown(v_fiscal_year, 'pFiscalYear'));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit);
        -- setup the string for the filterbar, and also ,
        -- Set parameters to be sent to next page and status parameters
        add_filter_item('pNew', pnew, 'New');
        add_filter_item('pSubmitted', psubmitted, 'Submitted');
        add_filter_item('pApproved', papproved, 'Approved');
        add_filter_item('pPaid', ppaid, 'Paid');
        add_filter_item('pRejected', prejected, 'Rejected');
        add_filter_item('pReturned', preturned, 'Disallowed');
        add_filter_item('pRepaid', prepaid, 'Repaid');
        add_filter_item('pClosed', pclosed, 'Closed');

        IF v_usage = 'FilteredList' THEN
            -- actually generate the table that holds the checkbox filters and the update filters button.
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'FILTERBAR',
                                             build_filterbar(v_filter_list));
        ELSE
            -- don't generate the table (just replace the tag).
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FILTERBAR', ' ');

            IF v_usage = 'PaymentListing' THEN
                -- find the total amount of the expenses ready for paying for this unit.
                FOR t IN (SELECT SUM(total_amount_us) AS total
                            FROM v_cfunds_expense_v3
                           WHERE status = 'Paid' AND reviewing_unit = v_unit)
                LOOP
                    v_total_payment_due_unit := NVL(t.total, 0);
                    -- and print out the total and unit info.
                    htp.print('Expenses total '
                              || TO_CHAR(v_total_payment_due_unit, v_dollar_format) || ' for unit: '
                              || v_unit_name);

                    IF v_total_payment_due_unit > 0 THEN
                        --  print a button to send the user to the Transfer form
                        htp.print('<form  method="POST" action="'
                                  || Web_Util_Pkg.get_current_package
                                  || 'transfer_details?pType=ER&pSend_To=' || v_unit || '&pAmount='
                                  || t.total || '&pFiscalYear=' || v_fiscal_year || '">');
                        htp.print('<input type="submit" value="Pay Unit" name="pCommand"></form>');
                    END IF;

                    EXIT;
                END LOOP;
            END IF;
        END IF;

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'PERSONNEL_LIST' THEN
                IF NOT v_usage = 'PaymentListing' THEN
                    v_cursor := DBMS_SQL.OPEN_CURSOR;
                    v_query := '';
                    v_query := v_query || 'select';
                    v_query :=
                        v_query || '     ''<a href="' || Web_Util_Pkg.get_current_package
                        || 'expenses_for_indiv?pSID='' || e.CLAIMANT || ''' || v_params
                        || '&pUnit=' || v_unit || '&pFiscalYear=' || v_fiscal_year
                        || '">'' || e.CLAIMANT_NAME || ''</a>'',';
                    v_query := v_query || '     count(*) as NUM_EXPENSES,';
                    v_query := v_query || '     trunc(max(e.INCURRED_DATE)) as LATEST_EXPENSE,';
                    v_query := v_query || '     trunc(min(e.INCURRED_DATE)) as OLDEST_EXPENSE';
                    v_query := v_query || ' from V_CFUNDS_EXPENSE_V3 e';
                    v_query := v_query || ' where ';
                    v_query :=
                        v_query || '     Cfunds_Pkg.Get_Fiscal_Year(e.INCURRED_DATE) = '''
                        || v_fiscal_year || ''' and ';
                    v_query := v_query || '     CHARGE_TO_UNIT = ''' || v_unit || ''' and';
                    v_query := v_query || '     STATUS in (''bogus''';
                    v_query := v_query || v_query_status || ')';                -- close STATUS set
                    v_query := v_query || ' group by';
                    v_query := v_query || '     e.CLAIMANT_NAME, e.CLAIMANT';
                    Core_Logger.log_it
                        (c_pipe,
                         'Cfunds_Web.Expenses_By_Personnel - NOT v_usage = PaymentListing query = '
                         || v_query);
                    DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                    owa_util.cellsprint(v_cursor, 1000, NULL, v_cnt);
                ELSE
                    IF v_total_payment_due_unit > 0 THEN
                        v_cursor := DBMS_SQL.OPEN_CURSOR;
                        v_query := '';
                        v_query := v_query || 'select';
                        v_query :=
                            v_query || '     ''<a href="' || Web_Util_Pkg.get_current_package
                            || 'expenses_for_indiv?pSID='' || e.CLAIMANT || ''&pPaid=checked&pUnit='
                            || v_unit || '&pFiscalYear=' || v_fiscal_year
                            || '">'' || e.CLAIMANT_NAME || ''</a>'',';
                        v_query := v_query || '     count(*) as NUM_EXPENSES,';
                        v_query := v_query || '     trunc(max(e.INCURRED_DATE)) as LATEST_EXPENSE,';
                        v_query := v_query || '     trunc(min(e.INCURRED_DATE)) as OLDEST_EXPENSE';
                        v_query := v_query || ' from V_CFUNDS_EXPENSE_V3 e';
                        v_query := v_query || ' where ';
                        v_query :=
                            v_query || '     Cfunds_Pkg.Get_Fiscal_Year(e.INCURRED_DATE) = '''
                            || v_fiscal_year || ''' and ';
                        v_query := v_query || '     REVIEWING_UNIT = ''' || v_unit || ''' and';
                        v_query := v_query || '     STATUS = ''Paid''';
                        v_query := v_query || ' group by';
                        v_query := v_query || '     e.CLAIMANT_NAME, e.CLAIMANT';
                        Core_Logger.log_it
                            (c_pipe,
                             'Cfunds_Web.Expenses_By_Personnel - v_usage = PaymentListing query = '
                             || v_query);
                        DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                        owa_util.cellsprint(v_cursor, 1000, NULL, v_cnt);
                    END IF;
                END IF;
            ELSIF v_tag = 'UNIT_LIST' THEN
                -- setup the cursor for the combo box to select a unit
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                v_query := '';
                v_query := v_query || ' select SID, UNIT_NAME, ';
                v_query :=
                        v_query || '     decode(SID, ''' || v_unit || ''', ''Y'',null) as SELECTED';
                v_query := v_query || ' from V_CFUNDS_UNIT';
                v_query := v_query || ' order by UNIT_CODE';
                DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
--                OWA_CORE_LISTPRINT(V_CURSOR, 'pUnitPick', 1, FALSE);
                owa_util.listprint(v_cursor, 'pUnitPick', 1, FALSE);
                DBMS_SQL.CLOSE_CURSOR(v_cursor);
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;

        end_serve_page;
        setunitsid(punit);
        set_fiscal_year(v_fiscal_year);
    END expenses_by_personnel;

    PROCEDURE expenses_for_indiv(
        pcommand      IN   VARCHAR2,
        pnew          IN   VARCHAR2,
        psubmitted    IN   VARCHAR2,
        papproved     IN   VARCHAR2,
        ppaid         IN   VARCHAR2,
        prejected     IN   VARCHAR2,
        preturned     IN   VARCHAR2,
        prepaid       IN   VARCHAR2,
        pclosed       IN   VARCHAR2,
        psid          IN   VARCHAR2,
        punit         IN   VARCHAR2,
        pfiscalyear   IN   VARCHAR2,
        punitpick     IN   VARCHAR2) IS
        v_template        CLOB;
        v_template_date   DATE;
        v_offset          NUMBER                                       := 1;
        v_params_short    VARCHAR2(1000);
        v_params          VARCHAR2(1000);
        v_tag             VARCHAR2(100);
        v_query           VARCHAR2(4000);
        v_query_params    VARCHAR2(4000);
        v_cursor          INTEGER;
        v_cnt             NUMBER;
        v_ok              BOOLEAN;
        v_filter_list     VARCHAR2(1000);
        v_unit_name       VARCHAR2(50);
        v_unit            T_CFUNDS_UNIT.SID%TYPE;
        v_fiscal_year     VARCHAR2(10);
        v_claimant        v_cfunds_osi_personnel.personnel_name%TYPE;

        PROCEDURE add_filter_item(
            pcontrol_name   IN   VARCHAR2,
            ponoff          IN   VARCHAR2,
            pdisplayname    IN   VARCHAR2) IS
        BEGIN
            -- setup the string for the filterbar,
            v_ok := Core_List.add_item_to_list(pcontrol_name, v_filter_list);
            v_ok := Core_List.add_item_to_list(ponoff, v_filter_list);
            v_ok := Core_List.add_item_to_list(pdisplayname, v_filter_list);

            -- Set parameters to be sent to next page and status parameters
            IF ponoff IS NOT NULL THEN
                v_params := v_params || '&' || pcontrol_name || '=' || ponoff;
                v_query_params := v_query_params || ',''' || pdisplayname || '''';
                v_params_short := v_params_short || '-' || pcontrol_name;
            END IF;
        END add_filter_item;
    BEGIN
        v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
        -- find the name of this unit whose expenses are showing.
        v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
        begin_serve_page('E-Funds Expenses for Individual in ' || v_unit_name,
                         TRUE,
                         TRUE,
                         NULL,
                         'E-Funds Expenses for Individual',
                         'expenses_by_personnel');
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Expenses_For_Indiv(' || pcommand || ')');
        v_ok :=
               Web_Template_Pkg.get_latest('cfunds_expenses_for_indiv', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_expenses_for_indiv"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
        -- remember the Fiscal Year
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'FISCAL_YEAR_LABEL',
                                         get_html_fy_dropdown(v_fiscal_year, 'pFiscalYear'));
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_LABEL', v_unit_name);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit);
        v_params := '';
        v_params_short := '';
        v_query_params := '';
        -- setup the string for the filterbar, and also ,
        -- Set parameters to be sent to next page and status parameters
        add_filter_item('pNew', pnew, 'New');
        add_filter_item('pSubmitted', psubmitted, 'Submitted');
        add_filter_item('pApproved', papproved, 'Approved');
        add_filter_item('pPaid', ppaid, 'Paid');
        add_filter_item('pRejected', prejected, 'Rejected');
        add_filter_item('pReturned', preturned, 'Disallowed');
        add_filter_item('pRepaid', prepaid, 'Repaid');
        add_filter_item('pClosed', pclosed, 'Closed');
        -- actually generate the table that holds the checkbox filters and the update filters button.
        v_ok :=
               Web_Template_Pkg.replace_tag(v_template, 'FILTERBAR', build_filterbar(v_filter_list));

        IF v_params_short IS NOT NULL THEN
            v_params_short := '&pParams=' || v_params_short;
            -- need to make sure there is no occurance of the =- combination.
            v_params_short := REPLACE(v_params_short, '=-', '=');
        END IF;

        Core_Logger.log_it(c_pipe, 'Expenses_For_Indiv v_params_short(' || v_params_short || ')');
        -- remember the SID so the screen can be refreshed when the user changes the filters.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID_FLAG', psid);
        -- remember the UNIT so the screen can be refreshed when the user changes the filters.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_FLAG', punit);

        SELECT personnel_name
          INTO v_claimant
          FROM v_cfunds_osi_personnel
         WHERE SID = psid;

        v_ok := Web_Template_Pkg.replace_tag(v_template, 'CLAIMANT_LABEL', v_claimant);

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'EXPENSE_LIST' THEN
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                v_query := '';
                v_query := v_query || 'select';
                v_query :=
                    v_query || '     ''<a  href="' || Web_Util_Pkg.get_current_package
                    || 'expense_details?pSID='' || e.SID || ''&pCategory='' || e.CATEGORY || ''&pParagraph='' || e.PARAGRAPH || ''&pPerSid='
                    || psid || '&pUnit=' || punit || '&pFiscalYear=' || v_fiscal_year
                    || v_params_short || '">'' || e.INCURRED_DATE || ''</a>'',';
                v_query := v_query || '     e.VOUCHER_NO,';
                v_query := v_query || '     e.CATEGORY_DESC,';
                v_query :=
                        v_query || '     to_char(e.TOTAL_AMOUNT_US,''' || v_dollar_format || '''),';
                v_query := v_query || '     e.STATUS';
                v_query := v_query || ' from V_CFUNDS_EXPENSE_V3 e';
                v_query := v_query || ' where ';
                v_query :=
                    v_query || '     Cfunds_Pkg.Get_Fiscal_Year(e.INCURRED_DATE) = '''
                    || v_fiscal_year || ''' and ';
                v_query := v_query || '     CLAIMANT = ''' || psid || ''' and';
                v_query := v_query || '     CHARGE_TO_UNIT = ''' || v_unit || ''' and';
                v_query := v_query || '     STATUS in (''bogus''';
                v_query := v_query || v_query_params || ')';                    -- close STATUS set
                v_query := v_query || ' order by';
                v_query := v_query || '     e.INCURRED_DATE';
                DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                owa_util.cellsprint(v_cursor, 1000, NULL, v_cnt);
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;

        end_serve_page;
        setvparams(v_params);
        setunitsid(punit);
        set_fiscal_year(v_fiscal_year);
    END expenses_for_indiv;

    PROCEDURE validate_claimant(punit IN VARCHAR2, pshowall IN VARCHAR2) IS
        v_template                CLOB;
        v_template_date           DATE;
        v_offset                  NUMBER                   := 1;
        v_tag                     VARCHAR2(100);
        v_query                   VARCHAR2(4000);
        v_cursor                  INTEGER;
        v_ok                      BOOLEAN;
        v_unit_name               VARCHAR2(50);
        v_unit                    T_CFUNDS_UNIT.SID%TYPE;
        v_advance_amount_total    NUMBER                   := 0;
        v_expensed_amount_total   NUMBER                   := 0;
        v_temp_string             VARCHAR2(50);
        v_error_count             NUMBER                   := 0;
        v_error_units_string      VARCHAR2(10000);
        v_total_monetary_error    NUMBER                   := 0;
        v_cfcustodian             VARCHAR2(10);
        v_commander               VARCHAR2(10);
        v_new_row                 VARCHAR2(10)             := 'Y';
    BEGIN
        -- find the unit to default to if not sent in as a parameter
        v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);

        IF v_unit = 'ALL' THEN
            -- find the name of this unit whose claimants are showing.
            v_unit_name := 'All OSI Units';
            -- change this to check for a specific HQ priv ***********************
            v_cfcustodian :=
                Cfunds_Test_Cfp('EXP_PAY',
                                Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                Core_Context.personnel_sid,
                                v_hq_cc_unit_sid);
            v_commander :=
                Cfunds_Test_Cfp('APPROVE_CL',
                                Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                Core_Context.personnel_sid,
                                v_hq_cc_unit_sid);
        ELSE
            -- find the name of this unit whose claimants are showing.
            v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
            v_cfcustodian :=
                Cfunds_Test_Cfp('EXP_PAY',
                                Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                Core_Context.personnel_sid,
                                v_unit);
            v_commander :=
                Cfunds_Test_Cfp('APPROVE_CL',
                                Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                Core_Context.personnel_sid,
                                v_unit);
        END IF;

        -- test unit to see if user has privs to see data;
        -- since there isn't a priv for accessing E-Funds Custodian
        -- level data, we check 2 privs and if both fail then
        -- user can't see any data.
        IF v_cfcustodian = 'N' AND v_commander = 'N' THEN
            v_error_detail :=
                            'You do not have privileges to view data ' || 'for the specified unit.';
            RAISE a_stink;
        END IF;

        begin_serve_page('E-Funds Validate Claimant in ' || v_unit_name,
                         FALSE,
                         FALSE,
                         'E-Funds Validate Claimant',
                         'in ' || v_unit_name);
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.Validate_Claimant');
        v_ok := Web_Template_Pkg.get_latest('cfunds_validate_claimant', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_validate_claimant"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'UNIT_NAME' THEN
                htp.p('<select NAME="SelectUnit" size="1">');

                FOR c IN (SELECT   u.SID AS code, u.unit_name AS description,
                                   DECODE(u.SID, v_unit, 'SELECTED', NULL) AS selected
                              FROM (SELECT 'ALL' AS SID, 'ALL OSI' AS unit_name, '_' AS unit_code,
                                           'a' AS bogus
                                      FROM dual
                                    UNION ALL
                                    SELECT SID, unit_name, unit_code, 'b' AS bogus
                                      FROM v_cfunds_unit) u
                          ORDER BY bogus, u.unit_code)
                LOOP
                    htp.p('<option ' || c.selected || ' value="' || c.code || '">' || c.description);
                END LOOP;

                htp.p('</select>');
            ELSIF v_tag = 'PERSONNEL_LIST' THEN
                v_error_units_string := '';

                -- select only the claimants in the selected unit; OR ...
                -- IF the unit selected was ALL, get all claimants in OSI.
                FOR p IN (SELECT p.unit_name, p.personnel_name, p.i2ms_login, p.SID
                            FROM v_cfunds_osi_personnel p, T_CFUNDS_UNIT u
                           WHERE u.SID = p.unit AND(   p.unit = v_unit
                                                    OR v_unit = 'ALL'))
                LOOP
                    htp.tableRowOpen(NULL, NULL, NULL, NULL, 'style="BACKGROUND-COLOR: lightcyan"');
                        htp.p('<td align="center" colspan="4">' || p.personnel_name || ' (' || p.SID
                              || ')</td>');
                    htp.tableRowClose;
                    v_advance_amount_total := 0;
                    v_new_row := 'Y';

                    FOR e IN (SELECT e.advance_amount, e.status, e.voucher_no,
                                     e.charge_to_unit_name, e.charge_to_unit, e.incurred_date
                                FROM v_cfunds_expense_v3 e
                               WHERE claimant = p.SID)
                    LOOP
                        --  dont show all data for all OSI units
                        IF v_unit <> 'ALL' THEN
                            IF v_new_row = 'Y' THEN
                                v_new_row := 'N';
                                htp.tableRowOpen;
                                    htp.tabledata
                                                 ('<font face="Arial" size="2"><b>ID Number</b></font>');
                                    htp.tabledata
                                             ('<font face="Arial" size="2"><b>Date Incurred</b></font>');
                                    htp.tabledata
                                           ('<font face="Arial" size="2"><b>Advanced Amount</b></font>');
                                    htp.tabledata('<font face="Arial" size="2"><b>Status</b></font>',
                                                  NULL,
                                                  NULL,
                                                  'nowrap');
                                htp.tableRowClose;
                            END IF;

                            v_temp_string := '';

                            IF e.charge_to_unit <> v_unit THEN
                                v_temp_string := ' * Unit charged is not ' || v_unit_name;
                            END IF;

                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || e.voucher_no
                                              || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(e.incurred_date, 'dd-Mon-yyyy') || '</font>');
                                htp.tabledata('<font face="Arial" size="2">' || e.advance_amount
                                              || '&nbsp;' || '</font>');
                                htp.tabledata('<font face="Arial" size="2">' || e.status
                                              || v_temp_string || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END IF;

                        v_advance_amount_total := v_advance_amount_total + NVL(e.advance_amount, 0);
                    END LOOP;

                    htp.tableRowOpen(NULL, NULL, NULL, NULL,
                                     'style="BACKGROUND-COLOR: lightyellow"');
                        htp.print
                            ('<td colspan="3"><font face="Arial" size="2">'
                             || 'Total amount of all expenses "Taken from Advances" (Advanced Amount): </font></td>');
                        htp.tabledata('<font face="Arial" size="2">'
                                      || TO_CHAR(v_advance_amount_total, v_dollar_format) || '</font>');
                    htp.tableRowClose;
                    v_expensed_amount_total := 0;
                    v_new_row := 'Y';

                    FOR a IN (SELECT a.expensed_amount, a.status, a.unit, a.voucher_no, a.unit_name,
                                     a.issue_on
                                FROM v_cfunds_advance_v2 a
                               WHERE claimant = p.SID)
                    LOOP
                        --  dont show all data for all OSI units
                        IF v_unit <> 'ALL' THEN
                            IF v_new_row = 'Y' THEN
                                v_new_row := 'N';
                                htp.tableRowOpen;
                                    htp.tabledata
                                                 ('<font face="Arial" size="2"><b>ID Number</b></font>');
                                    htp.tabledata
                                               ('<font face="Arial" size="2"><b>Date Issued</b></font>');
                                    htp.tabledata
                                           ('<font face="Arial" size="2"><b>Expensed Amount</b></font>');
                                    htp.tabledata('<font face="Arial" size="2"><b>Status</b></font>',
                                                  NULL,
                                                  NULL,
                                                  'nowrap');
                                htp.tableRowClose;
                            END IF;

                            v_temp_string := '';

                            IF a.unit <> v_unit THEN
                                v_temp_string := ' * Unit charged is not ' || v_unit_name;
                            END IF;

                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || a.voucher_no
                                              || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(a.issue_on, 'dd-Mon-yyyy') || '&nbsp;'
                                              || '</font>');
                                htp.tabledata('<font face="Arial" size="2">' || a.expensed_amount
                                              || '&nbsp;' || '</font>');
                                htp.tabledata('<font face="Arial" size="2">' || a.status
                                              || v_temp_string || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END IF;

                        v_expensed_amount_total :=
                                                 v_expensed_amount_total + NVL(a.expensed_amount, 0);
                    END LOOP;

                    htp.tableRowOpen(NULL, NULL, NULL, NULL,
                                     'style="BACKGROUND-COLOR: lightyellow"');
                        htp.print
                            ('<td colspan="3"><font face="Arial" size="2">'
                             || 'Total amount of all advances that were paid by expenses (Expensed Amount):'
                             || '</font></td>');
                        htp.tabledata('<font face="Arial" size="2">'
                                      || TO_CHAR(v_expensed_amount_total, v_dollar_format) || '</font>');
                    htp.tableRowClose;

                    IF v_expensed_amount_total <> v_advance_amount_total THEN
                        v_error_count := v_error_count + 1;
                        v_error_units_string :=
                                       v_error_units_string || '<br>Error in Unit: ' || p.unit_name;
                        v_total_monetary_error :=
                            v_total_monetary_error
                            +(v_advance_amount_total - v_expensed_amount_total);
                        htp.tableRowOpen(NULL, NULL, NULL, NULL, 'style="BACKGROUND-COLOR: red"');
                            htp.tabledata('<font face="Arial" size="2"><b>'
                                          || 'ERROR!!!-- not equal -->' || '</b></font>');
                            htp.tabledata
                                ('<font face="Arial" size="2"><b>Expensed Amount does not equal Advanced Amount''</b></font>');
                            htp.tabledata('<font face="Arial" size="2"><b>'
                                          || TO_CHAR(v_advance_amount_total, v_dollar_format) || '-'
                                          || TO_CHAR(v_expensed_amount_total, v_dollar_format)
                                          || '=</b></font>');
                            htp.tabledata('<font face="Arial" size="2"><b>Diff: '
                                          || TO_CHAR((v_advance_amount_total - v_expensed_amount_total),
                                                     v_dollar_format)
                                          || '</b></font>');
                        htp.tableRowClose;
                    END IF;
                END LOOP;

                htp.print('<br> Total number of errors is: ' || v_error_count || '<br><br>');

                IF v_error_count > 0 THEN
                    htp.tableRowOpen(NULL, NULL, NULL, NULL, 'style="BACKGROUND-COLOR: red"');
                        htp.tabledata('<font face="Arial" size="2"><b>' || ' SUM OF ALL ERRORS ...'
                                      || '</b></font>');
                        htp.tabledata('<font face="Arial" size="2">...........</font>');
                        htp.tabledata('<font face="Arial" size="2">...........</font>');
                        htp.tabledata('<font face="Arial" size="2"><b>'
                                      || TO_CHAR(v_total_monetary_error, v_dollar_format)
                                      || '</b></font>');
                    htp.tableRowClose;

                    IF v_unit = 'ALL' THEN
                        htp.print('<br> Units that have errors: <br>' || v_error_units_string
                                  || '<br><br>');
                    ELSE
                        htp.print
                            ('This unit has error(s) totalling '
                             || TO_CHAR(v_total_monetary_error, v_dollar_format)
                             || '.  This amount will likely be causing this unit''s form 29 to have'
                             || ' unequal totals in Part I and Part II. ');
                    END IF;
                END IF;
            ELSE
                htp.print('Unexpected tag: ' || v_tag);
            END IF;
        END LOOP;

        end_serve_page;
    EXCEPTION
        WHEN a_stink THEN
            exception_handler(TRUE);
            end_serve_page;
    END validate_claimant;

-- Check expense and advance offset amounts. [OFFSET].
    FUNCTION validate_form29(punit IN VARCHAR2)
        RETURN VARCHAR2 IS
/*
    This procedure checks for some invalid data and if found, the form 29 can show the problem.
    Use Validate_Claimant to see details of the errors that were found by this function..
*/
        v_advance_amount_total     NUMBER          := 0;
        v_expensed_amount_total    NUMBER          := 0;
        v_error_count              NUMBER          := 0;
        v_error_personnel_string   VARCHAR2(10000);
        v_total_monetary_error     NUMBER          := 0;
        v_result                   VARCHAR2(20000);
    BEGIN
        v_error_personnel_string := '';

        -- select only the personnel in the selected unit;
        FOR p IN (SELECT p.personnel_name, p.SID
                    FROM v_cfunds_osi_personnel p, T_CFUNDS_UNIT u
                   WHERE u.SID = p.unit AND p.unit = punit)
        LOOP
            -- First:
            -- For all expenses that belong to this personnel, add up the advance
            -- amount for each one.
            v_advance_amount_total := 0;

            FOR e IN (SELECT e.advance_amount
                        FROM v_cfunds_expense_v3 e
                       WHERE claimant = p.SID)
            LOOP
                v_advance_amount_total := v_advance_amount_total + NVL(e.advance_amount, 0);
            END LOOP;

            -- Next:
            -- For all advances that belong to this personnel, add up the expensed
            -- amount for each one.
            v_expensed_amount_total := 0;

            FOR a IN (SELECT
                             --sum(a.expensed_amount)
                             a.expensed_amount
                        FROM v_cfunds_advance_v2 a
                       WHERE claimant = p.SID)
            LOOP
                v_expensed_amount_total := v_expensed_amount_total + NVL(a.expensed_amount, 0);
            END LOOP;

            -- Now:..
            -- The expensed amount should be equal to the advance amount.
            -- (expensed amount = the sum of all the advances paid back by expenses).
            -- (advance amount = the sum of all the expenses amounts that were
            --  taken from advances.).
            IF v_expensed_amount_total <> v_advance_amount_total THEN
                v_error_count := v_error_count + 1;
                v_error_personnel_string := v_error_personnel_string || '<br> ' || p.personnel_name;
                v_total_monetary_error :=
                         v_total_monetary_error
                         +(v_advance_amount_total - v_expensed_amount_total);
            END IF;
        END LOOP;

        v_result := 'none';

        IF v_error_count > 0 THEN
            v_result :=('<br> The total number of errors is: ' || v_error_count || '<br>');
            v_result :=
                v_result
                ||('These error(s) total ' || TO_CHAR(v_total_monetary_error, v_dollar_format)
                   || '. <br>');
            v_result :=
                   v_result
                   ||('Personnel that have errors: ' || v_error_personnel_string || '<br>');
            v_result :=
                v_result
                ||('To see details, click here: <a href="' || Web_Util_Pkg.get_current_package
                   || 'validate_claimant?pUnit=' || punit
                   || '">Details of Claimants in this Unit</a><br>');

            IF v_total_monetary_error > 0 THEN
                v_result :=
                    v_result || 'This amount will likely be causing this Form to have'
                    || ' unequal totals in Part I and Part II. <br> If you subtract this amount ('
                    || TO_CHAR(v_total_monetary_error, v_dollar_format)
                    || ') from the Part II total, your Form should balance.<br>';
            ELSE
                v_result :=
                    v_result || 'This amount will likely be causing this Form to have'
                    || ' unequal totals in Part I and Part II. <br> If you add this amount('
                    || TO_CHAR(v_total_monetary_error, v_dollar_format)
                    || ') to the Part II total, your Form should balance.<br>';
            END IF;
        END IF;

        RETURN v_result;
    END validate_form29;

-- check total of expenses against paid amounts and advanced amounts. [MATCHING].
    FUNCTION validate_expense_details(punit IN VARCHAR2, pfiscalyear IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
/*
    This procedure checks for some invalid data and if found, the form 29 can show the problem.
    The check that is done is to check the total amount of the expense against the total
    amount paid to agent and paid by advance..
*/
        v_error_count              NUMBER          := 0;
        v_error_string             VARCHAR2(10000);
        v_total_monetary_error     NUMBER          := 0;
        v_error_personnel_string   VARCHAR2(10000);
        v_result                   VARCHAR2(30000);
    BEGIN
        v_error_string := '';

        FOR e IN (SELECT SID, voucher_no, e.claimant_name, e.claimant,
                         NVL(paid_cash_amount, 0) + NVL(paid_check_amount, 0)
                         + NVL(advance_amount, 0) AS paid_out_sum,
                         NVL(total_amount_us, 0) AS total_amt_us,
                         NVL(e.take_from_other_sources, 0) AS tfos
                    FROM v_cfunds_expense_v3 e
                   WHERE (   status = 'Closed'
                          OR e.status = 'Repaid') AND e.charge_to_unit = punit)
        LOOP
            IF ABS(e.tfos) <> 1 THEN
                IF e.paid_out_sum <> e.total_amt_us THEN
                    v_total_monetary_error :=
                                          v_total_monetary_error
                                          +(e.total_amt_us - e.paid_out_sum);
                    v_error_personnel_string :=
                        v_error_personnel_string || '<br><a href="'
                        || Web_Util_Pkg.get_current_package || 'expense_details?pSID=' || e.SID
                        || '&pUnit=' || punit || '&pFiscalYear=' || pfiscalyear || '">'
                        || e.voucher_no || '</a>';
                    v_error_count := v_error_count + 1;
                END IF;
            END IF;
        END LOOP;

        v_result := 'none';

        IF v_error_count > 0 THEN
            v_result :=('<br> The total number of errors is: ' || v_error_count || '<br>');
            v_result :=
                v_result
                ||('These error(s) total ' || TO_CHAR(v_total_monetary_error, v_dollar_format)
                   || '. <br>');
            v_result :=
                    v_result
                    ||('Expenses that have errors: ' || v_error_personnel_string || '<br>');
        END IF;

        RETURN v_result;
    END validate_expense_details;

-- check repayments against total of advances for integrity. [REPAYMENT].
    FUNCTION validate_advances_repaid(punit IN VARCHAR2)
        RETURN VARCHAR2 IS
/*
    This procedure checks for some invalid data and if found, the form 29 can show the problem.
    This function adds up all the amounts for closed advances and makes sure the total of the advance
    matches the total amount paid back on the advance (includes repayments and expenses that are applied to it).
*/
        v_error_count              NUMBER          := 0;
        v_error_string             VARCHAR2(10000);
        v_total_monetary_error     NUMBER          := 0;
        v_error_personnel_string   VARCHAR2(10000);
        v_result                   VARCHAR2(20000);
        v_repayments               NUMBER          := 0;
    BEGIN
        v_error_string := '';

        FOR a IN (SELECT a.SID, a.voucher_no, a.issue_on, a.cash_amount, a.check_amount,
                         a.expensed_amount, a.claimant_name
                    FROM v_cfunds_advance_v2 a
                   WHERE a.status = 'Closed' AND a.unit = punit)
        LOOP
            v_repayments := 0;

            FOR r IN (SELECT NVL(ar.cash_amount, 0) AS repaid_cash_amount,
                             NVL(ar.check_amount, 0) AS repaid_check_amount
                        FROM T_CFUNDS_ADVANCE_REPAYMENT_V2 ar
                       WHERE ar.advance(+) = a.SID)
            LOOP
                v_repayments := v_repayments + r.repaid_cash_amount + r.repaid_check_amount;
            END LOOP;

            IF (NVL(a.cash_amount, 0) + NVL(a.check_amount, 0)) <>
                                                           (NVL(a.expensed_amount, 0) + v_repayments) THEN
                v_total_monetary_error :=
                    v_total_monetary_error +(NVL(a.cash_amount, 0) + NVL(a.check_amount, 0))
                    -(NVL(a.expensed_amount, 0) + v_repayments);
                v_error_personnel_string := v_error_personnel_string || a.claimant_name || '<br>';
                v_error_count := v_error_count + 1;
            END IF;
        END LOOP;

        v_result := 'none';

        IF v_error_count > 0 THEN
            v_result :=('<br> The total number of errors is: ' || v_error_count || '<br>');
            v_result :=
                v_result
                ||('These error(s) total ' || TO_CHAR(v_total_monetary_error, v_dollar_format)
                   || '. <br>');
            v_result :=
                   v_result
                   ||('Personnel that have errors: ' || v_error_personnel_string || '<br>');
        END IF;

        RETURN v_result;
    END validate_advances_repaid;

    -- check Take From Other Sources expenses for invalid paid amounts. [OVERPAID].
    FUNCTION validate_expenses_tfos(punit IN VARCHAR2, pfiscalyear IN VARCHAR2)
        RETURN VARCHAR2 IS
        /*
            This procedure checks for some invalid data and if found, the form 29 can show the problem.
            This function checks to see if any expense marked Take From Other Sources has
            amounts in the Paid out properties (these should all be 0).
        */
        v_error_count              NUMBER          := 0;
        v_error_string             VARCHAR2(10000);
        v_total_monetary_error     NUMBER          := 0;
        v_error_personnel_string   VARCHAR2(10000);
        v_result                   VARCHAR2(20000);
    BEGIN
        v_error_string := '';

        FOR e IN (SELECT *
                    FROM (SELECT e.SID, e.voucher_no, e.incurred_date, e.claimant_name,
                                 e.charge_to_unit_name, e.status, e.total_amount_us,
                                 NVL(e.paid_cash_amount, 0)
                                 + NVL(e.paid_check_amount, 0)
                                 + NVL(e.advance_amount, 0) AS paid_out
                            FROM v_cfunds_expense_v3 e
                           WHERE e.charge_to_unit = punit AND ABS(e.take_from_other_sources) = 1)
                   WHERE paid_out <> 0)
        LOOP
            v_total_monetary_error := v_total_monetary_error + e.paid_out;
            v_error_personnel_string :=
                v_error_personnel_string || '<br><a href="' || Web_Util_Pkg.get_current_package
                || 'expense_details?pSID=' || e.SID || '&pUnit=' || punit || '&pFiscalYear='
                || pfiscalyear || '">' || e.voucher_no || '</a>';
            v_error_count := v_error_count + 1;
        END LOOP;

        v_result := 'none';

        IF v_error_count > 0 THEN
            v_result :=('<br> The total number of errors is: ' || v_error_count || '<br>');
            v_result :=
                v_result
                ||('These error(s) total ' || TO_CHAR(v_total_monetary_error, v_dollar_format)
                   || '. <br>');
            v_result :=
                    v_result
                    ||('Expenses that have errors: ' || v_error_personnel_string || '<br>');
        END IF;

        RETURN v_result;
    END validate_expenses_tfos;

-- check for expenses that were paid back to agent but not recorded in system. [MISSING].
    FUNCTION validate_expenses_tfos_2(punit IN VARCHAR2, pfiscalyear IN VARCHAR2)
        RETURN VARCHAR2 IS
/*
    This procedure checks for some invalid data and if found, the form 29 can show the problem.
    This function checks for expenses marked Take From Other Sources that
    have a status of Closed. If the amounts in the Paid out properties are all 0,
    then the unit's working fund will be wrong, since we don't yet have a way for the unit
    to pay back the agent.
    We now have new fields that allow the agent to get paid.  They all start with TFOS_
    If these are filled in, we should be ok, but if they are left empty on a closed expense, then
    we still need to count that as an error.
*/
        v_error_count              NUMBER          := 0;
        v_error_string             VARCHAR2(10000);
        v_total_monetary_error     NUMBER          := 0;
        v_error_personnel_string   VARCHAR2(10000);
        v_result                   VARCHAR2(20000);
    BEGIN
        v_error_string := '';

        FOR e IN (SELECT *
                    FROM (SELECT e.SID, e.voucher_no, e.incurred_date, e.claimant_name,
                                 e.charge_to_unit_name, e.status, e.total_amount_us,
                                 NVL(e.paid_cash_amount, 0)
                                 + NVL(e.paid_check_amount, 0)
                                 + NVL(e.advance_amount, 0) AS paid_out
                            FROM v_cfunds_expense_v3 e
                           WHERE e.charge_to_unit = punit
                             AND ABS(e.take_from_other_sources) = 1
                             AND e.status = 'Closed'
                             AND e.tfos_by IS NULL)
                   WHERE paid_out = 0)
        LOOP
            v_total_monetary_error := v_total_monetary_error + e.total_amount_us;
            v_error_personnel_string :=
                v_error_personnel_string || '<br><a href="' || Web_Util_Pkg.get_current_package
                || 'expense_details?pSID=' || e.SID || '&pUnit=' || punit || '&pFiscalYear='
                || pfiscalyear || '">' || e.voucher_no || '</a>';
            v_error_count := v_error_count + 1;
        END LOOP;

        v_result := 'none';

        IF v_error_count > 0 THEN
            v_result :=('<br> The total number of errors is: ' || v_error_count || '<br>');
            v_result :=
                v_result
                ||('These error(s) total ' || TO_CHAR(v_total_monetary_error, v_dollar_format)
                   || '. <br>');
            v_result :=
                    v_result
                    ||('Expenses that have errors: ' || v_error_personnel_string || '<br>');
            v_result :=
                v_result || 'This amount will likely be causing this Form to have'
                || ' unequal totals in Part I and Part II. <br> If you subtract this amount ('
                || TO_CHAR(v_total_monetary_error, v_dollar_format)
                || ') from the Part II total, your Form should balance.<br>';
        END IF;

        RETURN v_result;
    END validate_expenses_tfos_2;

-- check DER transers for valid data in related transfers to that expense. [DISALLOWED].
    FUNCTION validate_der_processing(punit IN VARCHAR2, pfiscalyear IN VARCHAR2)
        RETURN VARCHAR2 IS
/*
    This procedure checks for some invalid data and if found, the form 29 can show the problem.
    This function looks at all expenses that are on a DER Transfer to the Unit specified
    in pUnit, and then checks to see if pUnit received money from its parent unit to cover
    this same expense.  pUnit should not receive money from the DER and the parent unit,
    so finding any data here would be data errors.  The return value will include links
    to allow both transfers to be viewed.  (DER = Disallowed Expense Reimbursement).
*/
        v_error_count              NUMBER          := 0;
        v_error_string             VARCHAR2(10000);
        v_total_monetary_error     NUMBER          := 0;
        v_error_personnel_string   VARCHAR2(10000);
        v_result                   VARCHAR2(20000);
    BEGIN
        v_error_string := '';

        FOR e IN (SELECT et.expense, EXP.claimant_name, EXP.voucher_no AS exp_voucher_no,
                         EXP.total_amount_us, t.SID AS der_transfer,
                         t.voucher_no AS der_voucher_no
                    FROM T_CFUNDS_XFR_EXP et, v_cfunds_expense_v3 EXP, v_cfunds_xfr t
                   WHERE et.xfr = t.SID
                     AND et.expense = EXP.SID
                     AND t.xfr_type = 'DER'
                     AND t.receiver = punit)
        LOOP
            FOR e2 IN (SELECT et.expense, t.voucher_no, t.SID
                         FROM T_CFUNDS_XFR_EXP et, v_cfunds_expense_v3 EXP, v_cfunds_xfr t
                        WHERE et.xfr = t.SID
                          AND et.expense = EXP.SID
                          AND et.expense = e.expense
                          AND t.xfr_type = 'ER'
                          AND t.receiver = punit)
            LOOP
                v_total_monetary_error := v_total_monetary_error + e.total_amount_us;
                v_error_personnel_string :=
                    v_error_personnel_string || '<br><a href="' || Web_Util_Pkg.get_current_package
                    || 'expense_details?pSID=' || e.expense || '&pUnit=' || punit
                    || '&pFiscalYear=' || pfiscalyear || '">' || e.exp_voucher_no || '</a>';
                v_error_personnel_string :=
                    v_error_personnel_string || '. Transfer from parent unit: <a href="'
                    || Web_Util_Pkg.get_current_package || 'transfer_details?pSID=' || e2.SID
                    || '&pSend_To=' || punit || '&pFiscalYear=' || pfiscalyear || '">'
                    || e2.voucher_no || '</a>';
                v_error_personnel_string :=
                    v_error_personnel_string || '. DER Transfer: <a href="'
                    || Web_Util_Pkg.get_current_package || 'transfer_details?pSID='
                    || e.der_transfer || '&pSend_To=' || punit || '&pFiscalYear=' || pfiscalyear
                    || '">' || e.der_voucher_no || '</a>';
                v_error_count := v_error_count + 1;
            END LOOP;
        END LOOP;

        v_result := 'none';

        IF v_error_count > 0 THEN
            v_result :=('<br> The total number of errors is: ' || v_error_count || '<br>');
            v_result :=
                v_result
                ||('These error(s) total ' || TO_CHAR(v_total_monetary_error, v_dollar_format)
                   || '. <br>');
            v_result :=
                    v_result
                    ||('Expenses that have errors: ' || v_error_personnel_string || '<br>');
            v_result :=
                v_result || 'This amount will likely be causing this Form to have'
                || ' unequal totals in Part I and Part II. <br> If you subtract this amount'
                || ' from the Part II total, your Form should balance.<br>';
        END IF;

        RETURN v_result;
    END validate_der_processing;

/*
   This is a copy of the procedure in Cfunds_Pkg called Get_Unit_WF_Balance.
   It spits out degugging lines to aid in debugging from 28.
   To work, the user needs to add the "&pDebug=True" to the URL of the Form28.

   This function was updated from what the old Get_Unit_WF_Balance used to do
   by not counting ER transfers that have not been received yet.  The old function would
   count them as part of the Working Fund Total even though the "Receive" button hadn't
   been pressed yet.  This function affects what will show up on the Home Page, so
   changing it may cause some Units to complain.
*/
-- This is a Private function.
    FUNCTION fake_get_unit_wf_balance(punit IN VARCHAR2, pcleared_only IN BOOLEAN := FALSE)
        RETURN NUMBER IS
        v_bal               NUMBER;
        v_since_date        DATE;
        v_pay_from_wf       VARCHAR2(1);
        v_recon_threshold   NUMBER;          -- Days before last reconcile to look for transactions
    BEGIN
        -- Get last recon balance and date (if any)

        --     select nvl(RECON_BALANCE,0), nvl(RECON_ON - v_recon_threshold,'01-Jan-1990'), nvl(PAY_FROM_WF,'Y')
--       into v_bal, v_since_date, v_pay_from_wf
--       from T_CFUNDS_UNIT
--       where SID = pUnit;
        v_recon_threshold := Cfunds_Pkg.get_reconcile_threshold; -- This number is database driven.
        v_pay_from_wf := 'Y';                                   -- not used, but kept just in case.
        v_bal := 0;
        v_since_date := '01-Jan-1990';

        FOR r IN (SELECT   recon_balance, recon_on
                      FROM T_CFUNDS_RECONCILIATION
                     WHERE unit = punit
                  ORDER BY recon_on DESC)
        LOOP
            v_bal := NVL(r.recon_balance, 0);
            v_since_date := NVL(r.recon_on - v_recon_threshold, '01-Jan-1990');
            EXIT;
        END LOOP;

        htp.p('starting balance: ' || v_bal);
        htp.nl;
        htp.p('since date: ' || v_since_date);
        htp.nl;
-- this transfers block is what used to be in the old "get_unit_wf_balance"... is it not correct  05/19/04
--     -- Process additions and subtractions from various transactions
-- htp.p('<u>Transfers coming up next</u>');htp.nl;
--     for x in (select * from T_CFUNDS_XFR
--               where (RECEIVER = pUnit and
--                      RECEIVE_DATE > v_since_date and
--                      nvl(RECEIVE_CLEARED,'-') <> 'r') or
--                     (SENDER = pUnit and
--                      SEND_DATE > v_since_date and
--                      nvl(SEND_CLEARED,'-') <> 'r'))
--     loop
--         if x.RECEIVER = pUnit then
--             if nvl(x.RECEIVE_CLEARED,'-') = 'c' or not pCleared_Only then
--                 v_bal := v_bal + nvl(x.AMOUNT,0);
-- htp.p('updated balance (transfer [' || x.XFR_TYPE ||']: coming in): ' || v_bal || '   Amount: ' || x.amount || '  ID: ' || x.VOUCHER_NO);htp.nl;
--             end if;
--         end if;
--         if x.SENDER = pUnit and
--            (v_pay_from_wf = 'Y' or x.XFR_TYPE <> 'ER') and
--            x.SENDER <> x.RECEIVER then
--             if nvl(x.SEND_CLEARED,'-') = 'c' or not pCleared_Only then
--                 v_bal := v_bal - nvl(x.AMOUNT,0);
-- htp.p('updated balance (transfer [' || x.XFR_TYPE ||']: going out): ' || v_bal || '   Amount: ' || x.amount || '  ID: ' || x.VOUCHER_NO);htp.nl;
--             end if;
--         end if;
--     end loop;

        -- first transfer section
        -- Process additions and subtractions from various transactions
        htp.p('<u>Incoming transfers coming up next</u>');
        htp.nl;

        FOR x IN (SELECT *
                    FROM T_CFUNDS_XFR
                   WHERE (    receiver = punit
                          AND receive_date > v_since_date
                          AND NVL(receive_cleared, '-') <> 'r'))
        LOOP
            IF x.receiver = punit THEN
                IF    NVL(x.receive_cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal + NVL(x.amount, 0);
                    htp.p('updated balance (transfer [' || x.xfr_type || ']: coming in): ' || v_bal
                          || '   Amount: ' || x.amount || '  ID: ' || x.voucher_no);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

-- second part of transfers
    -- Process additions and subtractions from various transactions
        htp.p('<u>Outgoing transfers coming up next</u>');
        htp.nl;

        FOR x IN (SELECT *
                    FROM T_CFUNDS_XFR
                   WHERE (sender = punit AND send_date > v_since_date
                          AND NVL(send_cleared, '-') <> 'r'))
        LOOP
            IF     x.sender = punit
               AND (   v_pay_from_wf = 'Y'
                    OR x.xfr_type <> 'ER')
               AND x.sender <> x.receiver THEN
                IF    NVL(x.send_cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal - NVL(x.amount, 0);
                    htp.p('updated balance (transfer [' || x.xfr_type || ']: going out): ' || v_bal
                          || '   Amount: ' || x.amount || '  ID: ' || x.voucher_no);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

        htp.p('<u>Expenses coming up next</u>');
        htp.nl;

        FOR e IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE charge_to_unit = punit AND paid_on > v_since_date)
        LOOP
            IF NVL(e.cleared, '-') <> 'r' THEN
                v_bal := v_bal - NVL(e.paid_cash_amount, 0);
                -- cash amounts always considered cleared
                htp.p('updated balance (expense: subtract cash amount): ' || v_bal || '   Amount: '
                      || e.paid_cash_amount || '  ID: ' || e.voucher_no);
                htp.nl;

                IF    NVL(e.cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal - NVL(e.paid_check_amount, 0);
                    htp.p('updated balance (expense: subtract check amount): ' || v_bal
                          || '   Amount: ' || e.paid_check_amount || '  ID: ' || e.voucher_no);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

        htp.p('<u>repaying Expenses...</u>');
        htp.nl;

        FOR e IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE charge_to_unit = punit AND repaid_on > v_since_date)
        LOOP
            IF NVL(e.repaid_cleared, '-') <> 'r' THEN
                -- Add in the total amount of the expense MINUS any
                -- Check amount. This may be different than the
                -- actual Cash amount of the repayment, but that
                -- cash difference will be accounted for by the
                -- advance processing below (which treats an expense
                -- repayment advance just like any other advance).
                v_bal :=
                    ROUND((v_bal + NVL(e.source_amount / NVL(e.conversion_rate, 1), 0)
                           + NVL(e.agent_amount / NVL(e.conversion_rate, 1), 0)
                           - NVL(e.repaid_check_amount, 0)),
                          2);
                htp.p('updated balance (expense: Add Adjusted total): ' || v_bal || '   Amount: '
                      || TO_CHAR(ROUND((NVL(e.source_amount / NVL(e.conversion_rate, 1), 0)
                                        + NVL(e.agent_amount / NVL(e.conversion_rate, 1), 0)
                                        - NVL(e.repaid_check_amount, 0)),
                                       2))
                      || '  ID: ' || e.voucher_no);
                htp.nl;

--htp.p('updated balance (expense: Add Adjusted total): ' || v_bal || '   Amount:' || nvl(e.SOURCE_AMOUNT / nvl(e.CONVERSION_RATE,1),0) + nvl(e.AGENT_AMOUNT / nvl(e.CONVERSION_RATE,1),0)
                          -- - nvl(e.REPAID_CHECK_AMOUNT,0) || '  ID: ' || e.VOUCHER_NO);htp.nl;
                IF    NVL(e.repaid_cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal + NVL(e.repaid_check_amount, 0);
                    htp.p('updated balance (expense: Add Repaid check amount): ' || v_bal
                          || '   Amount: ' || e.repaid_check_amount || '  ID: ' || e.voucher_no);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

        htp.p('<u>TFOS Expenses coming up next</u>');
        htp.nl;

        FOR e IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE charge_to_unit = punit AND tfos_on > v_since_date)
        LOOP
            v_bal := v_bal - NVL(e.tfos_cash_amount, 0);  -- cash amounts always considered cleared
            htp.p('updated balance (expense: subtract TFOS cash amount): ' || v_bal || '   Amount: '
                  || e.tfos_cash_amount || '  ID: ' || e.voucher_no);
            htp.nl;
            v_bal := v_bal - NVL(e.tfos_check_amount, 0);
            htp.p('updated balance (expense: subtract TFOS check amount): ' || v_bal
                  || '   Amount: ' || e.tfos_check_amount || '  ID: ' || e.voucher_no);
            htp.nl;
        END LOOP;

        htp.p('<u>Advances coming up next</u>');
        htp.nl;

        FOR a IN (SELECT *
                    FROM T_CFUNDS_ADVANCE_V2
                   WHERE unit = punit AND issue_on > v_since_date AND NVL(cleared, '-') <> 'r')
        LOOP
            v_bal := v_bal - NVL(a.cash_amount, 0);
            htp.p('updated balance (advance: Subtract Cash amount): ' || v_bal || '   Amount: '
                  || a.cash_amount || '  ID: ' || a.voucher_no);
            htp.nl;

            IF    NVL(a.cleared, '-') = 'c'
               OR NOT pcleared_only THEN
                v_bal := v_bal - NVL(a.check_amount, 0);
                htp.p('updated balance (advance: Subtract check amount): ' || v_bal || '   Amount: '
                      || a.check_amount || '  ID: ' || a.voucher_no);
                htp.nl;
            END IF;
        END LOOP;

        htp.p('<u>Advance Repayments coming up next</u>');
        htp.nl;

        FOR r IN (SELECT ar.*, a.voucher_no AS adv_voucher_no
                    FROM T_CFUNDS_ADVANCE_REPAYMENT_V2 ar, T_CFUNDS_ADVANCE_V2 a
                   WHERE a.SID = ar.advance
                     AND a.unit = punit
                     AND ar.receive_on > v_since_date
                     AND NVL(ar.cleared, '-') <> 'r')
        LOOP
            v_bal := v_bal + NVL(r.cash_amount, 0);
            htp.p('updated balance (advance repayment [for Advance: ' || r.adv_voucher_no
                  || ']: add cash amount): ' || v_bal || '   Amount: ' || r.cash_amount || '  ID: '
                  || r.voucher_no);
            htp.nl;

            IF    NVL(r.cleared, '-') = 'c'
               OR NOT pcleared_only THEN
                v_bal := v_bal + NVL(r.check_amount, 0);
                htp.p('updated balance (advance repayment: add check amount): ' || v_bal
                      || '   Amount: ' || r.check_amount || '  ID: ' || r.voucher_no);
                htp.nl;
            END IF;
        END LOOP;

        htp.p('<u>MFRs coming up next</u>');
        htp.nl;

        FOR e IN (SELECT *
                    FROM T_CFUNDS_MFR
                   WHERE unit = punit AND incurred_date > v_since_date AND completed_on IS NOT NULL)
        LOOP
            v_bal := v_bal + NVL(e.amount, 0);
            -- add all amounts; negative amounts will make balance less.
            htp.p('updated balance (MFR: add MFR amount): ' || v_bal || '   Amount: ' || e.amount
                  || '  ID: ' || e.voucher_no);
            htp.nl;
        END LOOP;

        htp.p('final balance: ' || v_bal);
        htp.nl;
        RETURN v_bal;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(c_pipe,
                               'Cfunds_Pkg.Get_Unit_WF_Balance: NO_DATA_FOUND (looking up Unit)');
            htp.p('Error: No Data Found');
            htp.nl;
            RETURN NULL;
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_WF_Balance: Error: ' || SQLERRM);
            htp.p('Error: Others: ' || SQLERRM);
            htp.nl;
            RETURN NULL;
    END fake_get_unit_wf_balance;

-- taken from Cfunds_Pkg.Get_Unit_WF_Balance on 10/25/04... use for debugging,
-- use this instead of Fake_Get_Unit_WF_Balance in the future.
    FUNCTION tempget_unit_wf_balance(
        punit           IN   VARCHAR2,
        pcleared_only   IN   BOOLEAN := FALSE,
        pasof           IN   DATE := SYSDATE)
        RETURN NUMBER IS
        v_bal           NUMBER;
        v_since_date    DATE;
        v_pay_from_wf   VARCHAR2(1);
        v_asof_date     DATE;
    -- the 'As of' date is any date.  It can include the time.  But if only a date is
    -- sent in, the timestamp will be '00:00', which is midnight of the As Of date.
    -- So if you want all transactions for 30-Sep-2004, you would pass in 01-Oct-2004.
    BEGIN
        -- Get last recon balance and date (if any)
        SELECT NVL(recon_balance, 0), '01-Jan-1990', NVL(pay_from_wf, 'Y')
          INTO v_bal, v_since_date, v_pay_from_wf
          FROM T_CFUNDS_UNIT
         WHERE SID = punit;

        htp.p('starting balance: ' || v_bal);
        htp.nl;
        v_asof_date := TRUNC(pasof);
        htp.p('v_asof date: ' || TO_CHAR(v_asof_date, 'dd-mon-yyyy'));
        htp.nl;
        htp.p('v_since date: ' || TO_CHAR(v_since_date, 'dd-mon-yyyy'));
        htp.nl;
        htp.p('punit: ' || punit);
        htp.nl;
        -- Process additions and subtractions from various transactions

        -- incoming transfers
        htp.p('<u>Incoming transfers coming up next</u>');
        htp.nl;

        FOR x IN (SELECT *
                    FROM T_CFUNDS_XFR
                   WHERE (    receiver = punit
                          AND (receive_date BETWEEN v_since_date AND v_asof_date)
                          AND NVL(receive_cleared, '-') <> 'r'))
        LOOP
            IF x.receiver = punit THEN
                IF    NVL(x.receive_cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal + NVL(x.amount, 0);
                    htp.p('updated balance (transfer [' || x.xfr_type || ']: coming in): ' || v_bal
                          || '   Amount: ' || x.amount || '  ID: ' || x.voucher_no);
                    htp.nl;
                    htp.p('   receive_date is ' || x.receive_date);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

        -- outgoing transfers
        htp.p('<u>Outgoing transfers coming up next</u>');
        htp.nl;

        FOR x IN (SELECT *
                    FROM T_CFUNDS_XFR
                   WHERE (    sender = punit
                          AND send_date > v_since_date
                          AND send_date < v_asof_date
                          AND NVL(send_cleared, '-') <> 'r'))
        LOOP
            IF     x.sender = punit
               AND (   v_pay_from_wf = 'Y'
                    OR x.xfr_type <> 'ER')
               AND x.sender <> x.receiver THEN
                IF    NVL(x.send_cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal - NVL(x.amount, 0);
                    htp.p('updated balance (transfer [' || x.xfr_type || ']: going out): ' || v_bal
                          || '   Amount: ' || x.amount || '  ID: ' || x.voucher_no);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

        htp.p('<u>Expenses coming up next</u>');
        htp.nl;

        FOR e IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE charge_to_unit = punit AND paid_on > v_since_date AND paid_on < v_asof_date)
        LOOP
            IF NVL(e.cleared, '-') <> 'r' THEN
                v_bal := v_bal - NVL(e.paid_cash_amount, 0);
                -- cash amounts always considered cleared
                htp.p('updated balance (expense: subtract cash amount): ' || v_bal || '   Amount: '
                      || e.paid_cash_amount || '  ID: ' || e.voucher_no);
                htp.nl;

                IF    NVL(e.cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal - NVL(e.paid_check_amount, 0);
                    htp.p('updated balance (expense: subtract check amount): ' || v_bal
                          || '   Amount: ' || e.paid_check_amount || '  ID: ' || e.voucher_no);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

        htp.p('<u>repaying Expenses...</u>');
        htp.nl;

        FOR e IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE charge_to_unit = punit
                     AND repaid_on > v_since_date
                     AND repaid_on < v_since_date)
        LOOP
            IF e.repaid_on > v_since_date AND NVL(e.repaid_cleared, '-') <> 'r' THEN
                -- Add in the total amount of the expense MINUS any
                -- Check amount. This may be different than the
                -- actual Cash amount of the repayment, but that
                -- cash difference will be accounted for by the
                -- advance processing below (which treats an expense
                -- repayment advance just like any other advance).
                v_bal :=
                    ROUND((v_bal + NVL(e.source_amount / NVL(e.conversion_rate, 1), 0)
                           + NVL(e.agent_amount / NVL(e.conversion_rate, 1), 0)
                           - NVL(e.repaid_check_amount, 0)),
                          2);
                htp.p('updated balance (expense: Add Adjusted total): ' || v_bal || '   Amount: '
                      || TO_CHAR(ROUND((NVL(e.source_amount / NVL(e.conversion_rate, 1), 0)
                                        + NVL(e.agent_amount / NVL(e.conversion_rate, 1), 0)
                                        - NVL(e.repaid_check_amount, 0))),
                                 2)
                      || '  ID: ' || e.voucher_no);
                htp.nl;

                IF    NVL(e.repaid_cleared, '-') = 'c'
                   OR NOT pcleared_only THEN
                    v_bal := v_bal + NVL(e.repaid_check_amount, 0);
                    htp.p('updated balance (expense: Add Repaid check amount): ' || v_bal
                          || '   Amount: ' || e.repaid_check_amount || '  ID: ' || e.voucher_no);
                    htp.nl;
                END IF;
            END IF;
        END LOOP;

        htp.p('<u>TFOS Expenses coming up next</u>');
        htp.nl;

        FOR e IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE charge_to_unit = punit AND tfos_on > v_since_date AND tfos_on < v_asof_date)
        LOOP
            v_bal := v_bal - NVL(e.tfos_cash_amount, 0);
            htp.p('updated balance (expense: subtract TFOS cash amount): ' || v_bal || '   Amount: '
                  || e.tfos_cash_amount || '  ID: ' || e.voucher_no);
            htp.nl;
            v_bal := v_bal - NVL(e.tfos_check_amount, 0);
            htp.p('updated balance (expense: subtract TFOS check amount): ' || v_bal
                  || '   Amount: ' || e.tfos_check_amount || '  ID: ' || e.voucher_no);
            htp.nl;
        END LOOP;

        htp.p('<u>Advances coming up next</u>');
        htp.nl;

        FOR a IN (SELECT *
                    FROM T_CFUNDS_ADVANCE_V2
                   WHERE unit = punit
                     AND issue_on > v_since_date
                     AND issue_on < v_asof_date
                     AND NVL(cleared, '-') <> 'r')
        LOOP
            v_bal := v_bal - NVL(a.cash_amount, 0);
            htp.p('updated balance (advance: Subtract Cash amount): ' || v_bal || '   Amount: '
                  || a.cash_amount || '  ID: ' || a.voucher_no);
            htp.nl;

            IF    NVL(a.cleared, '-') = 'c'
               OR NOT pcleared_only THEN
                v_bal := v_bal - NVL(a.check_amount, 0);
                htp.p('updated balance (advance: Subtract check amount): ' || v_bal || '   Amount: '
                      || a.check_amount || '  ID: ' || a.voucher_no);
                htp.nl;
            END IF;
        END LOOP;

        htp.p('<u>Advance Repayments coming up next</u>');
        htp.nl;

        FOR r IN (SELECT ar.*, a.voucher_no AS adv_voucher_no
                    FROM T_CFUNDS_ADVANCE_REPAYMENT_V2 ar, T_CFUNDS_ADVANCE_V2 a
                   WHERE a.SID = ar.advance
                     AND a.unit = punit
                     AND ar.receive_on > v_since_date
                     AND ar.receive_on < v_asof_date
                     AND NVL(ar.cleared, '-') <> 'r')
        LOOP
            v_bal := v_bal + NVL(r.cash_amount, 0);
            htp.p('updated balance (advance repayment [for Advance: ' || r.adv_voucher_no
                  || ']: add cash amount): ' || v_bal || '   Amount: ' || r.cash_amount || '  ID: '
                  || r.voucher_no);
            htp.nl;

            IF    NVL(r.cleared, '-') = 'c'
               OR NOT pcleared_only THEN
                v_bal := v_bal + NVL(r.check_amount, 0);
                htp.p('updated balance (advance repayment: add check amount): ' || v_bal
                      || '   Amount: ' || r.check_amount || '  ID: ' || r.voucher_no);
                htp.nl;
            END IF;
        END LOOP;

        htp.p('final balance: ' || v_bal);
        htp.nl;
        RETURN v_bal;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(c_pipe,
                               'Cfunds_Pkg.Get_Unit_WF_Balance: NO_DATA_FOUND (looking up Unit)');
            htp.p('Error: No Data Found');
            htp.nl;
            RETURN NULL;
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'Cfunds_Pkg.Get_Unit_WF_Balance: Error: ' || SQLERRM);
            htp.p('Error: Others: ' || SQLERRM);
            htp.nl;
            RETURN NULL;
    END tempget_unit_wf_balance;

-- use pDebug=true to see list of calculations.
-- This procedure will show the Form 28 in report output
    PROCEDURE form28(
        punit         IN   VARCHAR2,
        pfiscalyear   IN   VARCHAR2,
        pdebug        IN   VARCHAR2,
        pstart_date   IN   DATE,
        pend_date     IN   DATE,
        pcommand      IN   VARCHAR2) IS
        v_template               CLOB;
        v_template_date          DATE;
        v_offset                 NUMBER                   := 1;
        v_tag                    VARCHAR2(100);
        v_query                  VARCHAR2(4000);
        v_cursor                 INTEGER;
        v_ok                     BOOLEAN;
        v_unit                   T_CFUNDS_UNIT.SID%TYPE;
        v_receive_unit           T_CFUNDS_UNIT.SID%TYPE;
        v_fiscal_year            VARCHAR2(10);
        v_fiscal_range           VARCHAR2(20);
        v_working_fund           NUMBER                   := 0;
        v_advance_amount         NUMBER                   := 0;
        v_total_accountability   NUMBER                   := 0;
        v_bal                    NUMBER;
        v_since_date             DATE;
        v_pay_from_wf            VARCHAR2(1);
        v_skip_record            BOOLEAN;
        v_current_working_fund   NUMBER                   := 0;
        v_row_ind                NUMBER                   := 0;
        v_outstanding_trans      NUMBER                   := 0;
        v_start_date             DATE;
        v_end_date               DATE;
    BEGIN
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.form_28');
        v_ok := Web_Template_Pkg.get_latest('cfunds_form_28', v_template, v_template_date);

        IF v_template_date IS NULL THEN
            Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_form_28"');
            htp.print('Could not locate template');
            RETURN;
        END IF;

        v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
        -- if the fiscal year wasn't specified, use the current fiscal year.
        v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
        Core_Logger.log_it(c_pipe, 'Cfunds_Web.form_28 ' || v_fiscal_year);
        -- ensure start date is a begining of the fiscal year
        v_start_date :=
            Cfunds_Pkg.get_fiscal_year_start_date(NVL(pstart_date,
                                                      TO_DATE('01-JAN-' || v_fiscal_year,
                                                              'dd-Mon-yyyy')));
        v_end_date :=
            NVL(pend_date,
                Cfunds_Pkg.get_fiscal_year_end_date(TO_DATE('01-JAN-' || v_fiscal_year,
                                                            'dd-Mon-yyyy')));

        -- ensure end date is not > now.
        IF v_end_date > SYSDATE + 7 THEN
            v_end_date := SYSDATE;
        END IF;

        -- prevent errors by ensuring start date is less than end date.
        IF v_start_date > v_end_date THEN
            v_start_date := Cfunds_Pkg.get_fiscal_year_start_date(v_end_date);
        END IF;

        -- Cfunds prior to 01-oct-2005 do not calculate properly if all previos years are not included.
        IF v_start_date < TO_DATE('01-OCT-2005', 'dd-Mon-yyyy') THEN
            v_start_date := TO_DATE('01-OCT-2003', 'dd-Mon-yyyy');
        --2004 was the first year cfunds was used.
        END IF;

        -- Gets a range to use for display of the fiscal year.
        v_fiscal_range := Cfunds_Pkg.get_fiscal_year(v_start_date);

        IF v_fiscal_range <> Cfunds_Pkg.get_fiscal_year(v_end_date) THEN
            v_fiscal_range := v_fiscal_range || ' - ' || Cfunds_Pkg.get_fiscal_year(v_end_date);
        END IF;

        Core_Logger.log_it(c_pipe, 'Cfunds_Web.form_28 ' || v_start_date);
        Web_Util_Pkg.send_comment('Unit SID is ' || v_unit);
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'UNIT_NAME',
                                         Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name);
        -- save the unit SID for next iteration of form.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
        -- Have to do FISCAL_YEAR twice.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
        --this fiscal year is hidden and passed back. It can not be a range.
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_range);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'START_DATE', v_start_date);
        v_ok := Web_Template_Pkg.replace_tag(v_template, 'END_DATE', v_end_date);
        v_ok :=
            Web_Template_Pkg.replace_tag(v_template,
                                         'URL',
                                         REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                         || 'PrintForm28?');

        LOOP
            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
            EXIT WHEN NOT v_ok
                  OR (v_tag IS NULL);

            -- Now process each found tag
            IF v_tag = 'TRANSACTION_LIST' THEN
                v_skip_record := FALSE;                                         --initialize value.

                -- Get last recon balance and date (if any)
                SELECT NVL(recon_balance, 0), NVL(recon_on, v_start_date), NVL(pay_from_wf, 'Y')
                  INTO v_bal, v_since_date, v_pay_from_wf
                  FROM T_CFUNDS_UNIT
                 WHERE SID = v_unit;

                -- Find out if this is the top.
                SELECT NVL(pay_from_wf, 'Y')
                  INTO v_pay_from_wf
                  FROM T_CFUNDS_UNIT
                 WHERE SID = v_unit;

                -- note that we are only
                -- using the "v_pay_from_wf" flag to indicate the unit
                -- that shouldn't have a transfer to itself show up twice
                -- in the listing.  This is because this is how we get
                -- HQ to enter the Working Fund money for all of OSI for
                -- the whole year.  So HQ becomes accountable for that
                -- money that was received, but it wasn't really received
                -- from HQ and we filter that outgoing transaction out.
                -- We show that as an incoming transaction only.

                -- HQ also doesn't send out Payment Listings, they come from the
                -- money DFAS has, not HQ working fund.

                -----------get the starting balance and write a row that shows what it is. -----------------

                --IF v_fiscal_year = Cfunds_Pkg.get_fiscal_year(SYSDATE) THEN
                -- find the working fund balance from the past fiscal year and make that the starting balance.
                -- this will get the balance up to the date but not including the start date.  The way Get_Unit_WF_Balance works.
            --    v_total_accountability := Cfunds_Pkg.Get_Unit_WF_Balance(v_unit,FALSE,v_Start_Date);
            --ELSE
                -- insert a line telling the past wf balance is 0.
-- NOTE THAT THIS MUST BE FIXED LATER!!!!!
--***************
-- ONLY WILL WORK DURING THE SECOND FISCAL YEAR. (fix before 01-Oct-2005)!
                v_total_accountability := 0;

                --END IF;

                --htp.tableRowOpen;
                --htp.tableData('<font face="Arial" size="2">Starting Balance On Hand</font>',NULL,NULL, 'nowrap',NULL,'8' );
                --htp.tableData('<font face="Arial" size="2">' || TO_CHAR(v_total_accountability, v_dollar_format) || '</font>','right',NULL, 'nowrap');
                --htp.tableData('&nbsp; ', 'right',NULL, 'nowrap');
                --htp.tableRowClose;

                ------------- start finding and processing all transactions ------------------
                FOR t IN
                    (SELECT   transaction_date, transaction_desc, claim_no, adj_acct,
                                                                                     -- Adjust accountability
                                                                                     sub_trans,
                              transact,
                                       --
                                       incidentals, transaction_type, status, direction
                         FROM ((SELECT                -- looking for wf transfers from sub ordinates
                                       receive_date AS transaction_date,
                                       
-- Should this be uncommented?
                         --decode(XFR_TYPE_DESC,'Expense Repayment','Payment Listing',XFR_TYPE_DESC) || ' from ' || decode(v_pay_from_wf, 'N', 'DFAS', SENDER_NAME) as TRANSACTION_DESC,
                                       xfr_type_desc || ' from ' || sender_name AS transaction_desc,
                                       voucher_no AS claim_no,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                              'Y', amount,
                                              0) AS adj_acct,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                              'N', amount,
                                              0) AS sub_trans,
                                       0 AS transact, 0 AS incidentals,
                                       xfr_type || 'XFR' AS transaction_type, status,
                                       'F' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender <> v_unit
                                   AND receiver = v_unit
                                   AND receive_date IS NOT NULL
                                   AND xfr_type = 'WF')
                               UNION ALL
                               (SELECT                -- looking for repayments or ER or DER to unit
                                       receive_date AS transaction_date,
                                       DECODE(xfr_type_desc,
                                              'Expense Repayment', 'Payment Listing',
                                              xfr_type_desc)
                                       || ' from '
                                       || DECODE(v_pay_from_wf, 'N', 'DFAS', sender_name)
                                                                                AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       amount AS transact, 0 AS incidentals,
                                       xfr_type || 'XFR' AS transaction_type, status,
                                       'F' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender <> v_unit
                                   AND receiver = v_unit
                                   AND receive_date IS NOT NULL
                                   AND (   xfr_type = 'ER'
                                        OR xfr_type = 'DER'))
                               UNION ALL
                               (SELECT
                                       -- These are transfers of HQ to HQ only.  Simulates transfers from DFAS or some higher authority.
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       DECODE(xfr_type_desc,
                                              'Expense Repayment', 'Payment Listing',
                                              xfr_type_desc)
                                       || DECODE(ABS(amount),
                                                 amount, ' from DFAS to ' || receiver_name,
                                                 ' from ' || receiver_name || ' to DFAS')
                                                                                AS transaction_desc,
                                       voucher_no AS claim_no,
                                       DECODE(xfr_type, 'ER', 0, ABS(amount)) AS adj_acct,
                                       
                                       --expense repayments don't adjust accontability
                                       0 AS sub_trans,
                                       DECODE(xfr_type, 'ER', ABS(amount), 0) AS transact,
                                       0 AS incidentals, 'XFR-SELF' AS transaction_type, status,
                                       DECODE(ABS(amount), amount, 'F', 'T') AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND receiver = v_unit
                                   AND (   xfr_type = 'ER'
                                        OR xfr_type = 'DER'
                                        OR (xfr_type = 'WF' AND receive_date IS NOT NULL))
                                   AND
                                       -- Changed to avoid unrecieved DFAS WF transfers from counting.
                                       send_date IS NOT NULL)
                               UNION ALL
                               (SELECT          -- New Section: Show unreceived DFAS transfers.to HQ
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       
                                       --decode(XFR_TYPE_DESC,'Expense Repayment','Payment Listing',XFR_TYPE_DESC) || ' to ' || RECEIVER_NAME as TRANSACTION_DESC,
                                       'Working Fund Transfer from DFAS to '
                                       || receiver_name
                                       || DECODE(receive_date,
                                                 NULL, ' (Pending)',
                                                 '') AS transaction_desc,
                                       voucher_no AS claim_no,
                                       
--If receive_date is null then overide the other columns to 0 and set incidentals - otherwise process normally
                                       DECODE
                                           (receive_date,
                                            NULL, 0,
                                            DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                   'Y', amount,
                                                   0)) AS adj_acct,
                                       DECODE
                                           (receive_date,
                                            NULL, 0,
                                            DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                   'N', amount,
                                                   0)) AS sub_trans,
                                       0 AS transact,
                                       DECODE(receive_date, NULL, amount, 0) AS incidentals,
                                       xfr_type || 'XFR' AS transaction_type, status,
                                       'T' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND receiver = v_unit
                                   AND send_date IS NOT NULL
                                   AND receive_date IS NULL
                                   AND xfr_type = 'WF')
                               UNION ALL
                               (SELECT
                                       -- These are transfers of DFO Advance type.  Simulates transfers from DFO to Unit.
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       DECODE(xfr_type,
                                              'DFOA', 'DFO Advance',
                                              xfr_type) AS transaction_desc,
                                       voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                       0 AS transact, 0 AS incidentals,
                                       'XFR-DFO' AS transaction_type, status, 'F' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND receiver = v_unit
                                   AND (xfr_type = 'DFOA')
                                   AND send_date IS NOT NULL)
                               UNION ALL
                               (SELECT
                                       -- These are transfers of DFO Repayment type.  Simulates transfers from unit to DFO.
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       DECODE(xfr_type,
                                              'DFOR', 'DFO Repayment',
                                              xfr_type) AS transaction_desc,
                                       voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                       0 AS transact, 0 AS incidentals,
                                       'XFR-DFO' AS transaction_type, status, 'T' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND receiver = v_unit
                                   AND (xfr_type = 'DFOR')
                                   AND send_date IS NOT NULL)
                               UNION ALL
                               (SELECT                   -- looking for wf transfers out of the unit
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       
                                       --decode(XFR_TYPE_DESC,'Expense Repayment','Payment Listing',XFR_TYPE_DESC) || ' to ' || RECEIVER_NAME as TRANSACTION_DESC,
                                       xfr_type_desc || ' to ' || receiver_name
                                       || DECODE(receive_date,
                                                 NULL, ' (Pending)',
                                                 '') AS transaction_desc,
                                       voucher_no AS claim_no,
                                       
--If receive_date is null then overide the other columns to 0 and set incidentals - otherwise process normally
                                       DECODE
                                           (receive_date,
                                            NULL, 0,
                                            DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                   'Y', amount,
                                                   0)) AS adj_acct,
                                       DECODE
                                           (receive_date,
                                            NULL, 0,
                                            DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                   'N', amount,
                                                   0)) AS sub_trans,
                                       0 AS transact,
                                       DECODE(receive_date, NULL, amount, 0) AS incidentals,
                                       xfr_type || 'XFR' AS transaction_type, status,
                                       'T' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND receiver <> v_unit
                                   AND send_date IS NOT NULL
                                   AND xfr_type = 'WF')
                               UNION ALL
                               (SELECT
                                       -- if ER or DER are not from HQ then a DISBURSEMENT
                                       -- if ER or DER are from HQ then an incidental.
                                       -- Essentially if Payment Listing is not from HQ then disbursement going down to sub unit
                                       -- if payment from HQ then payment if probably a DER from DFAS to unit not to be
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       DECODE(xfr_type_desc,
                                              'Expense Repayment', 'Payment Listing',
                                              xfr_type_desc)
                                       || DECODE(v_pay_from_wf, 'N', ' from DFAS ', ' ') || 'to '
                                       || receiver_name
                                       || DECODE(receive_date, NULL, ' (Pending)', '')
                                                                                AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       
-- If the RECEIVE_DATE is null then the amount always goes incidentals, overiding the pay from wf check. If its not null, then the pay from wf checks operate normally
                                       DECODE(receive_date,
                                              NULL, 0,
                                              DECODE(v_pay_from_wf, 'N', 0, amount)) AS transact,
                                       DECODE(receive_date,
                                              NULL, amount,
                                              DECODE(v_pay_from_wf, 'N', amount, 0)) AS incidentals,
                                       xfr_type || 'XFR' AS transaction_type, status,
                                       'T' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND receiver <> v_unit
                                   AND send_date IS NOT NULL
                                   AND (   xfr_type = 'ER'
                                        OR xfr_type = 'DER'))
                               UNION ALL
                               (SELECT                    -- repayments of advances that increase wf
                                       r.receive_on AS transaction_date,
                                       'Advance Repayment - '
                                       || a.claimant_name AS transaction_desc,
                                       r.voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       (NVL(r.cash_amount, 0) + NVL(r.check_amount, 0)) AS transact,
                                       0 AS incidentals, 'AR' AS transaction_type, ' ' AS status,
                                       'F' AS direction
                                  FROM v_cfunds_advance_v2 a, v_cfunds_advance_repayment_v2 r
                                 WHERE a.unit = v_unit AND a.SID = r.advance)
                               UNION ALL
                               (SELECT                    -- repayment of expenses that increases wf
                                       repaid_on AS transaction_date,
                                       'Repay Expense - ' || claimant_name AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       NVL(total_amount_us, 0) AS transact, 0 AS incidentals,
                                       'ER' AS transaction_type, ' ' AS status, 'F' AS direction
                                  FROM v_cfunds_expense_v3
                                 WHERE charge_to_unit = v_unit AND repaid_on IS NOT NULL)
                               UNION ALL
                               (SELECT                      -- expenses that decrease accountability
                                       paid_on AS transaction_date,
                                       'Expense - ' || claimant_name
                                       || DECODE(ABS(take_from_other_sources),
                                                 1, ' (TFOS)',
                                                 '') AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       NVL(paid_cash_amount, 0)
                                       + NVL(paid_check_amount, 0) AS transact,
                                       
                                       -- regular expense not taken from advance
                                       DECODE((NVL(paid_cash_amount, 0) + NVL(paid_check_amount, 0)),
                                              0, total_amount_us,
                                              0) AS incidentals,       -- expense taken from advance
                                       'E' AS transaction_type, status, 'T' AS direction
                                  FROM v_cfunds_expense_v3
                                 WHERE charge_to_unit = v_unit AND paid_on IS NOT NULL)
                               UNION ALL
                               (SELECT                                -- no effect on accountability
                                       incurred_date AS transaction_date,
                                       'MFR - ' || create_by AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       0 AS transact, NVL(amount, 0) AS incidentals,
                                       
                                       -- mfr has no effect on accountability so an incidental
                                       'M' AS transaction_type, status, ' ' AS direction
                                  FROM v_cfunds_mfr
                                 WHERE unit = v_unit)              --  and COMPLETED_ON is not null)
                               UNION ALL
                               (SELECT                                                             --
                                       issue_on AS transaction_date,
                                       'Advance - ' || claimant_name AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       (NVL(cash_amount, 0) + NVL(check_amount, 0)) AS transact,
                                       0 AS incidentals, 'A' AS transaction_type, status,
                                       'T' AS direction
                                  FROM v_cfunds_advance_v2
                                 WHERE unit = v_unit AND issue_on IS NOT NULL)
                               UNION ALL
                               (SELECT                    -- if end of fiscal year transfer received
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       DECODE(sender,
                                              receiver, 'FY Working Fund for AFOSI',
                                              xfr_type_desc || ' FROM ' || sender_name)
                                                                                AS transaction_desc,
                                       voucher_no AS claim_no,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                              'Y', amount,
                                              0) AS adj_acct,
                                       
                                       --Fliped the SENDER second to handle issues when a subunit gets moved to a new region
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                              'N', amount,
                                              0) AS sub_trans,
                                       
                                       --0 as ADJ_ACCT,
                                       --AMOUNT as SUB_TRANS,
                                       0 AS transact, 0 AS incidentals,
                                       xfr_type || 'EOFY' AS transaction_type, status,
                                       'F' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE receiver = v_unit
                                   AND (   sender <> v_unit
                                        OR sender = v_hq_cc_unit_sid)--'1010005M')
                                   AND send_date IS NOT NULL
                                   AND xfr_type = 'WFAF')
                               UNION ALL
                               (SELECT                    -- if end of fiscal year transfer received
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       DECODE(sender,
                                              receiver, 'FY DFO Transfer for AFOSI',
                                              xfr_type_desc || ' FROM ' || sender_name)
                                                                                AS transaction_desc,
                                       voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                       0 AS transact, 0 AS incidentals,
                                       xfr_type || 'EOFY' AS transaction_type, status,
                                       'F' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE receiver = v_unit
                                   AND (   sender <> v_unit
                                        OR sender = v_hq_cc_unit_sid)--'1010005M')
                                   AND send_date IS NOT NULL
                                   AND xfr_type = 'DFOTF')
                               UNION ALL
                               (SELECT                    -- if end of fiscal year transfer recieved
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       DECODE(sender,
                                              receiver, 'FY ' || xfr_type_desc || ' for AFOSI',
                                              xfr_type_desc || ' FROM ' || sender_name)
                                                                                AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                              'Y', amount,
                                              0) AS transact,
                                       
                                       --Fliped the SENDER second to handle issues when a subunit gets moved to a new region
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                              'N', amount,
                                              0) AS incidentals,
                                       xfr_type || 'EOFY' AS transaction_type, status,
                                       'F' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE receiver = v_unit
                                   AND (   sender <> v_unit
                                        OR sender = v_hq_cc_unit_sid)--'1010005M')
                                   AND send_date IS NOT NULL
                                   AND (   xfr_type = 'OA'
                                        OR xfr_type = 'OE'))
                               UNION ALL
                               (SELECT                        -- if end of fiscal year transfer sent
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       xfr_type_desc || ' TO ' || receiver_name AS transaction_desc,
                                       voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                       0 AS transact, 0 AS incidentals,
                                       xfr_type || 'EOFY' AS transaction_type, status,
                                       
                                       --decode(SENDER, v_unit, 'T', 'F') as DIRECTION
                                       'T' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND (receiver <> v_unit)
                                   AND send_date IS NOT NULL
                                   AND xfr_type = 'DFOTF')
                               UNION ALL
                               (SELECT                        -- if end of fiscal year transfer sent
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       xfr_type_desc || ' TO ' || receiver_name AS transaction_desc,
                                       voucher_no AS claim_no,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                              'Y', amount,
                                              0) AS adj_acct,
                                       
                                       --0 as SUB_TRANS,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                              'N', amount,
                                              0) AS sub_trans,
                                       
                                       --Fliped the RECEIVER second to handle issues when a subunit gets moved to a new region
                                       0 AS transact, 0 AS incidentals,
                                       xfr_type || 'EOFY' AS transaction_type, status,
                                       'T' AS direction
                                  --'F' as DIRECTION
                                FROM   v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND (receiver <> v_unit)
                                   AND send_date IS NOT NULL
                                   AND xfr_type = 'WFAF')
                               UNION ALL
                               (SELECT                        -- if end of fiscal year transfer sent
                                       DECODE(receive_date,
                                              NULL, send_date,
                                              receive_date) AS transaction_date,
                                       xfr_type_desc || ' TO ' || receiver_name AS transaction_desc,
                                       voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                              'Y', amount,
                                              0) AS transact,
                                       DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                              'N', amount,
                                              0) AS incidentals,
                                       
                                       --Fliped the RECEIVER second to handle issues when a subunit gets moved to a new region
                                       xfr_type || 'EOFY' AS transaction_type, status,
                                       'T' AS direction
                                  FROM v_cfunds_xfr
                                 WHERE sender = v_unit
                                   AND (receiver <> v_unit)
                                   AND send_date IS NOT NULL
                                   AND (   xfr_type = 'OA'
                                        OR xfr_type = 'OE')))
                        WHERE TRUNC(transaction_date) BETWEEN
--                         Cfunds_Pkg.Get_Fiscal_Year_Start_Date( v_fiscal_year ) and
--                         Cfunds_Pkg.Get_Fiscal_Year_End_Date( v_fiscal_year )
                                                             v_start_date AND v_end_date
                     ORDER BY transaction_date)
                LOOP
                    -- calculate outstanding transactions column.
                    -- v_Outstanding_trans :=  v_Outstanding_trans + t.TRANSACT + t.SUB_TRANS;
                    -- calculate the total accountability.  Using the t.ADJ_ACCT value.
                    -- (this goes in the 'OUTSTANDING FORMS 26 & 30' column.)
                    IF t.transaction_type = 'A' THEN
                        -- advances transaction
                        v_outstanding_trans := v_outstanding_trans + t.transact;
                    ELSIF t.transaction_type = 'AR' THEN
                        -- repayments transaction
                        v_outstanding_trans := v_outstanding_trans - t.transact;
                    ELSIF t.transaction_type = 'E' THEN
                        -- expense transaction
                        v_outstanding_trans := v_outstanding_trans + t.transact;
                    ELSIF t.transaction_type = 'ET' THEN
                        -- the amount paid to the agent for a TFOS expense
                        v_outstanding_trans := v_outstanding_trans + t.transact;
                    ELSIF t.transaction_type = 'ER' THEN
                        -- repayment.
                        v_outstanding_trans := v_outstanding_trans - t.transact;
                    ELSIF t.transaction_type = 'WFXFR' THEN           -- transfer in and out of unit
                        -- SUB_TRANS is a wf to a sub unit, ADJ_ACCT is a wf to a parent unit
                        IF (t.direction = 'F') THEN
                            v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                            v_total_accountability := v_total_accountability + t.adj_acct;
                        ELSE                                                      -- Direction = 'T'
                            v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                            v_total_accountability := v_total_accountability - t.adj_acct;
                        END IF;
                    ELSIF t.transaction_type = 'ERXFR' THEN                    -- transfer into unit
                        --expense repayment transfer;
                        IF (t.direction = 'F') THEN
                            v_outstanding_trans := v_outstanding_trans - t.transact;
                        ELSE                                                      -- Direction = 'T'
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        END IF;
                    ELSIF t.transaction_type = 'DERXFR' THEN                   -- transfer into unit
                        --disallowed expense repayment transfer
                        IF (t.direction = 'F') THEN
                            v_outstanding_trans := v_outstanding_trans - t.transact;
                        ELSE                                                      -- Direction = 'T'
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        END IF;
                    ELSIF t.transaction_type = 'XFR-SELF' THEN
                        -- this is the simulated case of HQ getting funds from on high and there being given
                        -- a pot of money to work with.
                        IF (t.direction = 'F') THEN
                            v_total_accountability := v_total_accountability + t.adj_acct;
                            v_outstanding_trans := v_outstanding_trans - t.transact;
                        ELSE                                                      -- Direction = 'T'
                            v_total_accountability := v_total_accountability - t.adj_acct;
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        END IF;
                    ELSIF t.transaction_type = 'XFR-DFO' THEN
                        -- this is the case of a unit getting or repaying DFO funds.
                        -- this affects the working fund balance.
                        IF (t.direction = 'F') THEN
                            v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                            v_total_accountability := v_total_accountability + t.adj_acct;
                        ELSE                                                      -- Direction = 'T'
                            v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                            v_total_accountability := v_total_accountability - t.adj_acct;
                        END IF;
                    ELSIF t.transaction_type = 'WFAFEOFY' THEN
                        -- do them WFAF end of fiscal year transfers
                        IF (t.direction = 'F') THEN
                            v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                            v_total_accountability := v_total_accountability + t.adj_acct;
                        ELSE                                                      -- Direction = 'T'
                            v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                            v_total_accountability := v_total_accountability - t.adj_acct;
                        END IF;
                    ELSIF t.transaction_type = 'DFOTFEOFY' THEN
                        -- do them DFOTF end of fiscal year transfers
                        IF (t.direction = 'F') THEN
                            v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                            v_total_accountability := v_total_accountability + t.adj_acct;
                        ELSE                                                      -- Direction = 'T'
                            v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                            v_total_accountability := v_total_accountability - t.adj_acct;
                        END IF;
                    --if (t.DIRECTION = 'F') then
                    --    v_total_accountability := v_total_accountability - t.ADJ_ACCT;
                    --else
                    --    v_total_accountability := v_total_accountability + t.ADJ_ACCT;
                    --end if;
                    ELSIF t.transaction_type = 'OAEOFY' THEN
                        -- do them OA end of fiscal year transfers
                        IF (t.direction = 'F') THEN
                            v_total_accountability := v_total_accountability - t.transact;
                            v_outstanding_trans := v_outstanding_trans - t.transact;
                        ELSE
                            v_total_accountability := v_total_accountability + t.transact;
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        END IF;
                    ELSIF t.transaction_type = 'OEEOFY' THEN
                        -- do them OE end of fiscal year transfers
                        IF (t.direction = 'F') THEN
                            v_total_accountability := v_total_accountability - t.transact;
                            v_outstanding_trans := v_outstanding_trans - t.transact;
                        ELSE
                            v_total_accountability := v_total_accountability + t.transact;
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        END IF;
                    END IF;

                    IF NOT v_skip_record THEN
                        IF v_row_ind = 0 THEN
                            v_row_ind := 1;
                            htp.tableRowOpen(NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             'style="BACKGROUND-COLOR: lightcyan"');
                            ELSE
                                v_row_ind := 0;
                                htp.tableRowOpen;
                                END IF;
        
                                htp.tabledata('<font face="Arial" SIZE="2">'
                                              || TO_CHAR(t.transaction_date, 'dd-Mon-yyyy') || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" SIZE="2">' || t.transaction_desc
                                              || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" SIZE="2">' || t.claim_no || '</font>');
        
                                -- Accountability Adjustments
                                IF t.adj_acct = 0 THEN
                                    htp.tabledata('0', 'right', NULL, 'nowrap');
                                ELSE
                                    IF (t.direction = 'F') THEN
                                        htp.tabledata('<font face="Arial" SIZE="2">'
                                                      || TO_CHAR(t.adj_acct, v_dollar_format) || '</font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    ELSE
                                        htp.tabledata('<font face="Arial" SIZE="2" color="#ff0000">('
                                                      || TO_CHAR(t.adj_acct, v_dollar_format) || ')</font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    END IF;
                                END IF;
        
                                -- subordinate transfers - transfers from sub units and to sub units.
                                IF t.sub_trans = 0 THEN
                                    htp.tabledata('0', 'right', NULL, 'nowrap');
                                ELSE
                                    IF (t.direction = 'F') THEN
                                        htp.tabledata('<font face="Arial" SIZE="2">'
                                                      || TO_CHAR(t.sub_trans, v_dollar_format) || '</font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    ELSE
                                        htp.tabledata('<font face="Arial" SIZE="2" color="#ff0000">('
                                                      || TO_CHAR(t.sub_trans, v_dollar_format) || ')</font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    END IF;
                                END IF;
        
                                -- Transactions - expenses and advances, wf transfers to other units, expense repayments,
                                -- advance repayments, expense repayment transfers, Disallowed expense repayments.
                                IF t.transact = 0 THEN
                                    htp.tabledata('0', 'right', NULL, 'nowrap');
                                ELSE
                                    IF (t.direction = 'F') THEN
                                        htp.tabledata('<font face="Arial" SIZE="2">'
                                                      || TO_CHAR(t.transact, v_dollar_format) || '</font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    ELSE
                                        htp.tabledata('<font face="Arial" SIZE="2" color="#ff0000">('
                                                      || TO_CHAR(t.transact, v_dollar_format) || ')</font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    END IF;
                                END IF;
        
                                -- this is the expenses from Advances column
                                IF t.incidentals = 0 THEN
                                    htp.tabledata('0', 'right', NULL, 'nowrap');
                                ELSE
                                    htp.tabledata('<font face="Arial" SIZE="2">'
                                                  || TO_CHAR(t.incidentals, v_dollar_format) || '</font>',
                                                  'right',
                                                  NULL,
                                                  'nowrap');
                                END IF;
        
                                htp.tabledata('<font face="Arial" SIZE="2">'
                                              || TO_CHAR(v_outstanding_trans, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                                -- The following is the balance on Hand which is really the working fund total.
                                htp.tabledata('<font face="Arial" SIZE="2">'
                                              || TO_CHAR((v_total_accountability - v_outstanding_trans),
                                                         v_dollar_format)
                                              || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" SIZE="2">'
                                              || TO_CHAR(v_total_accountability, v_dollar_format)
                                              || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END IF;
    
                        -- reset
                        v_skip_record := FALSE;
                    END LOOP;
    
                    -- The calculated balance should match the current_working_fund that is calculated
                    -- above; if they don't match THEN they both are shown, AND something IS wrong.
                    IF pdebug IS NOT NULL THEN
                        -- allow pDebug flag to be used to display debugging data.
                        v_current_working_fund := fake_get_unit_wf_balance(v_unit);
                    ELSE
                        -- this will get the balance to the end date and including the end date.  The way Get_Unit_WF_Balance works.
                        v_current_working_fund :=
                                          Cfunds_Pkg.get_unit_wf_balance(v_unit, FALSE, v_end_date + 1);
                    END IF;
    
                    IF TO_DATE(v_end_date, 'dd-Mon-yyyy') < TO_DATE(SYSDATE, 'dd-Mon-yyyy') THEN
                        -- enter a comment (temporary, until we complete the "Stake-in-the-ground" ability.).
                        htp.print
                            ('<tr><td colspan="10">These calculations do not include your latest transactions.  This total may not be your current Working Fund Balance.</td></tr>');
                    END IF;
    
                    IF v_current_working_fund <>(v_total_accountability - v_outstanding_trans) THEN
                        -- print extra data to alert the user to a problem.
                        htp.tableRowOpen;
                            htp.tabledata('');
                            htp.tabledata('');
                            htp.tabledata('');
                            htp.tabledata('');
                            htp.tabledata('');
                            htp.tabledata('');
                            htp.tabledata('');
                            htp.tabledata('');
                            htp.tabledata
                                         ('<font face="Arial" size="2">Your check book balance is: </font>');
                            htp.tabledata('<font face="Arial" size="2">'
                                          || TO_CHAR(v_current_working_fund, v_dollar_format) || '</font>',
                                          'right',
                                          NULL,
                                          'nowrap');
                        htp.tableRowClose;
                    --htp.print('<tr><td colspan="10">Something is wrong in these calculations.</td></tr>');
                    --htp.print('<tr><td colspan="10">END date = ' || TO_CHAR(v_end_date + 1) || '.</td></tr>');
                    END IF;
                ELSE
                    htp.print('Unexpected tag: ' || v_tag);
                END IF;
            END LOOP;
        END form28;
    
        -- use pDebug=true to see list of calculations.
        -- This procedure will show the Form 28 in a printable output
        PROCEDURE printform28(
            punit         IN   VARCHAR2,
            pfiscalyear   IN   VARCHAR2,
            pdebug        IN   VARCHAR2,
            pstart_date   IN   DATE,
            pend_date     IN   DATE) IS
            v_template               CLOB;
            v_template_date          DATE;
            v_offset                 NUMBER                   := 1;
            v_tag                    VARCHAR2(100);
            v_query                  VARCHAR2(4000);
            v_cursor                 INTEGER;
            v_ok                     BOOLEAN;
            v_unit                   T_CFUNDS_UNIT.SID%TYPE;
            v_receive_unit           T_CFUNDS_UNIT.SID%TYPE;
            v_fiscal_year            VARCHAR2(10);
            v_fiscal_range           VARCHAR2(20);
            v_working_fund           NUMBER                   := 0;
            v_advance_amount         NUMBER                   := 0;
            v_total_accountability   NUMBER                   := 0;
            v_bal                    NUMBER;
            v_since_date             DATE;
            v_pay_from_wf            VARCHAR2(1);
            v_skip_record            BOOLEAN;
            v_current_working_fund   NUMBER                   := 0;
            v_row_ind                NUMBER                   := 0;
            v_outstanding_trans      NUMBER                   := 0;
            v_start_date             DATE;
            v_end_date               DATE;
        BEGIN
            Core_Logger.log_it(c_pipe, 'Cfunds_Web.printform_28');
            v_ok := Web_Template_Pkg.get_latest('cfunds_printform_28', v_template, v_template_date);
    
            IF v_template_date IS NULL THEN
                Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_form_28"');
                htp.print('Could not locate template');
                RETURN;
            END IF;
    
            v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
            -- if the fiscal year wasn't specified, use the current fiscal year.
            v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
            Core_Logger.log_it(c_pipe, 'Cfunds_Web.form_28 ' || v_fiscal_year);
            -- ensure start date is a begining of the fiscal year
            v_start_date :=
                Cfunds_Pkg.get_fiscal_year_start_date(NVL(pstart_date,
                                                          TO_DATE('01-JAN-' || v_fiscal_year,
                                                                  'dd-Mon-yyyy')));
            v_end_date :=
                NVL(pend_date,
                    Cfunds_Pkg.get_fiscal_year_end_date(TO_DATE('01-JAN-' || v_fiscal_year,
                                                                'dd-Mon-yyyy')));
    
            -- ensure end date is not > now.
            IF v_end_date > SYSDATE + 7 THEN
                v_end_date := SYSDATE;
            END IF;
    
            -- prevent errors by ensuring start date is less than end date.
            IF v_start_date > v_end_date THEN
                v_start_date := Cfunds_Pkg.get_fiscal_year_start_date(v_end_date);
            END IF;
    
            -- Cfunds prior to 01-oct-2005 do not calculate properly if all previos years are not included.
            IF v_start_date < TO_DATE('01-OCT-2005', 'dd-Mon-yyyy') THEN
                v_start_date := TO_DATE('01-OCT-2003', 'dd-Mon-yyyy');
            --2004 was the first year cfunds was used.
            END IF;
    
            -- Gets a range to use for display of the fiscal year.
            v_fiscal_range := Cfunds_Pkg.get_fiscal_year(v_start_date);
    
            IF v_fiscal_range <> Cfunds_Pkg.get_fiscal_year(v_end_date) THEN
                v_fiscal_range := v_fiscal_range || ' - ' || Cfunds_Pkg.get_fiscal_year(v_end_date);
            END IF;
    
            Core_Logger.log_it(c_pipe, 'Cfunds_Web.form_28 ' || v_start_date);
            Web_Util_Pkg.send_comment('Unit SID is ' || v_unit);
            -- replace tag values in template.
            v_ok :=
                Web_Template_Pkg.replace_tag(v_template,
                                             'UNIT_NAME',
                                             Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_range);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'START_DATE', v_start_date);
            v_ok := Web_Template_Pkg.replace_tag(v_template, 'END_DATE', v_end_date);
    
            -- gather data
            LOOP
                v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                EXIT WHEN NOT v_ok
                      OR (v_tag IS NULL);
    
                -- Now process each found tag
                IF v_tag = 'TRANSACTION_LIST' THEN
                    v_skip_record := FALSE;                                         --initialize value.
    
                    -- Get last recon balance and date (if any)
                    SELECT NVL(recon_balance, 0), NVL(recon_on, v_start_date), NVL(pay_from_wf, 'Y')
                      INTO v_bal, v_since_date, v_pay_from_wf
                      FROM T_CFUNDS_UNIT
                     WHERE SID = v_unit;
    
                    -- Find out if this is the top.
                    SELECT NVL(pay_from_wf, 'Y')
                      INTO v_pay_from_wf
                      FROM T_CFUNDS_UNIT
                     WHERE SID = v_unit;                                        -- note that we are only
    
                    -----------get the starting balance and write a row that shows what it is. -----------------
                    --IF v_fiscal_year = Cfunds_Pkg.get_fiscal_year(SYSDATE) THEN
                        -- find the working fund balance from the past fiscal year and make that the starting balance.
                        -- this will get the balance up to the date but not including the start date.  The way Get_Unit_WF_Balance works.
                    --    v_total_accountability := Cfunds_Pkg.Get_Unit_WF_Balance(v_unit,FALSE,v_Start_Date);
                    --ELSE
                    v_total_accountability := 0;
    
                    --END IF;
    
                    --htp.tableRowOpen;
                    --htp.tableData('<font face="Arial" size="1">Starting Balance On Hand</font>',NULL,NULL, 'nowrap',NULL,'8' );
                    --htp.tableData('<font face="Arial" size="1">' || TO_CHAR(v_total_accountability, v_dollar_format) || '</font>','right',NULL, 'nowrap');
                    --htp.tableData('&nbsp; ', 'right',NULL, 'nowrap');
                    --htp.tableRowClose;
    
                    ------------- start finding and processing all transactions ------------------
                    FOR t IN
                        (SELECT   transaction_date, transaction_desc, claim_no, adj_acct,
                                                                                         -- Adjust accountability
                                                                                         sub_trans,
                                  transact,
                                           --
                                           incidentals, transaction_type, status, direction
                             FROM ((SELECT                -- looking for wf transfers from sub ordinates
                                           receive_date AS transaction_date,
                                           
                                           -- Should this be uncommented?
                                                                    --decode(XFR_TYPE_DESC,'Expense Repayment','Payment Listing',XFR_TYPE_DESC) || ' from ' || decode(v_pay_from_wf, 'N', 'DFAS', SENDER_NAME) as TRANSACTION_DESC,
                                           xfr_type_desc || ' from ' || sender_name AS transaction_desc,
                                           voucher_no AS claim_no,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                                  'Y', amount,
                                                  0) AS adj_acct,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                                  'N', amount,
                                                  0) AS sub_trans,
                                           0 AS transact, 0 AS incidentals,
                                           xfr_type || 'XFR' AS transaction_type, status,
                                           'F' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender <> v_unit
                                       AND receiver = v_unit
                                       AND receive_date IS NOT NULL
                                       AND xfr_type = 'WF')
                                   UNION ALL
                                   (SELECT                -- looking for repayments or ER or DER to unit
                                           receive_date AS transaction_date,
                                           DECODE(xfr_type_desc,
                                                  'Expense Repayment', 'Payment Listing',
                                                  xfr_type_desc)
                                           || ' from '
                                           || DECODE(v_pay_from_wf, 'N', 'DFAS', sender_name)
                                                                                    AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           amount AS transact, 0 AS incidentals,
                                           xfr_type || 'XFR' AS transaction_type, status,
                                           'F' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender <> v_unit
                                       AND receiver = v_unit
                                       AND receive_date IS NOT NULL
                                       AND (   xfr_type = 'ER'
                                            OR xfr_type = 'DER'))
                                   UNION ALL
                                   (SELECT
                                           -- These are transfers of HQ to HQ only.  Simulates transfers from DFAS or some higher authority.
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           DECODE(xfr_type_desc,
                                                  'Expense Repayment', 'Payment Listing',
                                                  xfr_type_desc)
                                           || DECODE(ABS(amount),
                                                     amount, ' from DFAS to ' || receiver_name,
                                                     ' from ' || receiver_name || ' to DFAS')
                                                                                    AS transaction_desc,
                                           voucher_no AS claim_no,
                                           DECODE(xfr_type, 'ER', 0, ABS(amount)) AS adj_acct,
                                           
                                           --expense repayments don't adjust accontability
                                           0 AS sub_trans,
                                           DECODE(xfr_type, 'ER', ABS(amount), 0) AS transact,
                                           0 AS incidentals, 'XFR-SELF' AS transaction_type, status,
                                           DECODE(ABS(amount), amount, 'F', 'T') AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND receiver = v_unit
                                       AND (   xfr_type = 'ER'
                                            OR xfr_type = 'DER'
                                            OR (xfr_type = 'WF' AND receive_date IS NOT NULL))
                                       AND
                                           -- Changed to avoid unrecieved DFAS WF transfers from counting.
                                           send_date IS NOT NULL)
                                   UNION ALL
                                   (SELECT          -- New Section: Show unreceived DFAS transfers.to HQ
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           
                                           --decode(XFR_TYPE_DESC,'Expense Repayment','Payment Listing',XFR_TYPE_DESC) || ' to ' || RECEIVER_NAME as TRANSACTION_DESC,
                                           'Working Fund Transfer from DFAS to '
                                           || receiver_name
                                           || DECODE(receive_date,
                                                     NULL, ' (Pending)',
                                                     '') AS transaction_desc,
                                           voucher_no AS claim_no,
                                           
                                           --If receive_date is null then overide the other columns to 0 and set incidentals - otherwise process normally
                                           DECODE
                                               (receive_date,
                                                NULL, 0,
                                                DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                       'Y', amount,
                                                       0)) AS adj_acct,
                                           DECODE
                                               (receive_date,
                                                NULL, 0,
                                                DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                       'N', amount,
                                                       0)) AS sub_trans,
                                           0 AS transact,
                                           DECODE(receive_date, NULL, amount, 0) AS incidentals,
                                           xfr_type || 'XFR' AS transaction_type, status,
                                           'T' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND receiver = v_unit
                                       AND send_date IS NOT NULL
                                       AND receive_date IS NULL
                                       AND xfr_type = 'WF')
                                   UNION ALL
                                   (SELECT
                                           -- These are transfers of DFO Advance type.  Simulates transfers from DFO to Unit.
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           DECODE(xfr_type,
                                                  'DFOA', 'DFO Advance',
                                                  xfr_type) AS transaction_desc,
                                           voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                           0 AS transact, 0 AS incidentals,
                                           'XFR-DFO' AS transaction_type, status, 'F' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND receiver = v_unit
                                       AND (xfr_type = 'DFOA')
                                       AND send_date IS NOT NULL)
                                   UNION ALL
                                   (SELECT
                                           -- These are transfers of DFO Repayment type.  Simulates transfers from unit to DFO.
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           DECODE(xfr_type,
                                                  'DFOR', 'DFO Repayment',
                                                  xfr_type) AS transaction_desc,
                                           voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                           0 AS transact, 0 AS incidentals,
                                           'XFR-DFO' AS transaction_type, status, 'T' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND receiver = v_unit
                                       AND (xfr_type = 'DFOR')
                                       AND send_date IS NOT NULL)
                                   UNION ALL
                                   (SELECT                   -- looking for wf transfers out of the unit
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           
                                           --decode(XFR_TYPE_DESC,'Expense Repayment','Payment Listing',XFR_TYPE_DESC) || ' to ' || RECEIVER_NAME as TRANSACTION_DESC,
                                           xfr_type_desc || ' to ' || receiver_name
                                           || DECODE(receive_date,
                                                     NULL, ' (Pending)',
                                                     '') AS transaction_desc,
                                           voucher_no AS claim_no,
                                           
                                           --If receive_date is null then overide the other columns to 0 and set incidentals - otherwise process normally
                                           DECODE
                                               (receive_date,
                                                NULL, 0,
                                                DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                       'Y', amount,
                                                       0)) AS adj_acct,
                                           DECODE
                                               (receive_date,
                                                NULL, 0,
                                                DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                       'N', amount,
                                                       0)) AS sub_trans,
                                           0 AS transact,
                                           DECODE(receive_date, NULL, amount, 0) AS incidentals,
                                           xfr_type || 'XFR' AS transaction_type, status,
                                           'T' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND receiver <> v_unit
                                       AND send_date IS NOT NULL
                                       AND xfr_type = 'WF')
                                   UNION ALL
                                   (SELECT
                                           -- if ER or DER are not from HQ then a DISBURSEMENT
                                           -- if ER or DER are from HQ then an incidental.
                                           -- Essentially if Payment Listing is not from HQ then disbursement going down to sub unit
                                           -- if payment from HQ then payment if probably a DER from DFAS to unit not to be
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           DECODE(xfr_type_desc,
                                                  'Expense Repayment', 'Payment Listing',
                                                  xfr_type_desc)
                                           || DECODE(v_pay_from_wf, 'N', ' from DFAS ', ' ') || 'to '
                                           || receiver_name
                                           || DECODE(receive_date, NULL, ' (Pending)', '')
                                                                                    AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           
                                           -- If the RECEIVE_DATE is null then the amount always goes incidentals, overiding the pay from wf check. If its not null, then the pay from wf checks operate normally
                                           DECODE(receive_date,
                                                  NULL, 0,
                                                  DECODE(v_pay_from_wf, 'N', 0, amount)) AS transact,
                                           DECODE(receive_date,
                                                  NULL, amount,
                                                  DECODE(v_pay_from_wf, 'N', amount, 0)) AS incidentals,
                                           xfr_type || 'XFR' AS transaction_type, status,
                                           'T' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND receiver <> v_unit
                                       AND send_date IS NOT NULL
                                       AND (   xfr_type = 'ER'
                                            OR xfr_type = 'DER'))
                                   UNION ALL
                                   (SELECT                    -- repayments of advances that increase wf
                                           r.receive_on AS transaction_date,
                                           'Advance Repayment - '
                                           || a.claimant_name AS transaction_desc,
                                           r.voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           (NVL(r.cash_amount, 0) + NVL(r.check_amount, 0)) AS transact,
                                           0 AS incidentals, 'AR' AS transaction_type, ' ' AS status,
                                           'F' AS direction
                                      FROM v_cfunds_advance_v2 a, v_cfunds_advance_repayment_v2 r
                                     WHERE a.unit = v_unit AND a.SID = r.advance)
                                   UNION ALL
                                   (SELECT                    -- repayment of expenses that increases wf
                                           repaid_on AS transaction_date,
                                           'Repay Expense - ' || claimant_name AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           NVL(total_amount_us, 0) AS transact, 0 AS incidentals,
                                           'ER' AS transaction_type, ' ' AS status, 'F' AS direction
                                      FROM v_cfunds_expense_v3
                                     WHERE charge_to_unit = v_unit AND repaid_on IS NOT NULL)
                                   UNION ALL
                                   (SELECT                      -- expenses that decrease accountability
                                           paid_on AS transaction_date,
                                           'Expense - ' || claimant_name
                                           || DECODE(ABS(take_from_other_sources),
                                                     1, ' (TFOS)',
                                                     '') AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           NVL(paid_cash_amount, 0)
                                           + NVL(paid_check_amount, 0) AS transact,
                                           
                                           -- regular expense not taken from advance
                                           DECODE((NVL(paid_cash_amount, 0) + NVL(paid_check_amount, 0)),
                                                  0, total_amount_us,
                                                  0) AS incidentals,       -- expense taken from advance
                                           'E' AS transaction_type, status, 'T' AS direction
                                      FROM v_cfunds_expense_v3
                                     WHERE charge_to_unit = v_unit AND paid_on IS NOT NULL)
                                   UNION ALL
                                   (SELECT                                -- no effect on accountability
                                           incurred_date AS transaction_date,
                                           'MFR - ' || create_by AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           0 AS transact, NVL(amount, 0) AS incidentals,
                                           
                                           -- mfr has no effect on accountability so an incidental
                                           'M' AS transaction_type, status, ' ' AS direction
                                      FROM v_cfunds_mfr
                                     WHERE unit = v_unit)              --  and COMPLETED_ON is not null)
                                   UNION ALL
                                   (SELECT                                                             --
                                           issue_on AS transaction_date,
                                           'Advance - ' || claimant_name AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           (NVL(cash_amount, 0) + NVL(check_amount, 0)) AS transact,
                                           0 AS incidentals, 'A' AS transaction_type, status,
                                           'T' AS direction
                                      FROM v_cfunds_advance_v2
                                     WHERE unit = v_unit AND issue_on IS NOT NULL)
                                   UNION ALL
                                   (SELECT                    -- if end of fiscal year transfer received
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           DECODE(sender,
                                                  receiver, 'FY Working Fund for AFOSI',
                                                  xfr_type_desc || ' FROM ' || sender_name)
                                                                                    AS transaction_desc,
                                           voucher_no AS claim_no,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                                  'Y', amount,
                                                  0) AS adj_acct,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                                  'N', amount,
                                                  0) AS sub_trans,
                                           
                                           --0 as ADJ_ACCT,
                                           --AMOUNT as SUB_TRANS,
                                           0 AS transact, 0 AS incidentals,
                                           xfr_type || 'EOFY' AS transaction_type, status,
                                           'F' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE receiver = v_unit
                                       AND (   sender <> v_unit
                                            OR sender = v_hq_cc_unit_sid)--'1010005M')
                                       AND send_date IS NOT NULL
                                       AND xfr_type = 'WFAF')
                                   UNION ALL
                                   (SELECT                    -- if end of fiscal year transfer received
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           DECODE(sender,
                                                  receiver, 'FY DFO Transfer for AFOSI',
                                                  xfr_type_desc || ' FROM ' || sender_name)
                                                                                    AS transaction_desc,
                                           voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                           0 AS transact, 0 AS incidentals,
                                           xfr_type || 'EOFY' AS transaction_type, status,
                                           'F' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE receiver = v_unit
                                       AND (   sender <> v_unit
                                            OR sender = v_hq_cc_unit_sid)--'1010005M')
                                       AND send_date IS NOT NULL
                                       AND xfr_type = 'DFOTF')
                                   UNION ALL
                                   (SELECT                    -- if end of fiscal year transfer recieved
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           DECODE(sender,
                                                  receiver, 'FY ' || xfr_type_desc || ' for AFOSI',
                                                  xfr_type_desc || ' FROM ' || sender_name)
                                                                                    AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                                  'Y', amount,
                                                  0) AS transact,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, sender),
                                                  'N', amount,
                                                  0) AS incidentals,
                                           xfr_type || 'EOFY' AS transaction_type, status,
                                           'F' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE receiver = v_unit
                                       AND (   sender <> v_unit
                                            OR sender = v_hq_cc_unit_sid)--'1010005M')
                                       AND send_date IS NOT NULL
                                       AND (   xfr_type = 'OA'
                                            OR xfr_type = 'OE'))
                                   UNION ALL
                                   (SELECT                        -- if end of fiscal year transfer sent
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           xfr_type_desc || ' TO ' || receiver_name AS transaction_desc,
                                           voucher_no AS claim_no, amount AS adj_acct, 0 AS sub_trans,
                                           0 AS transact, 0 AS incidentals,
                                           xfr_type || 'EOFY' AS transaction_type, status,
                                           
                                           --decode(SENDER, v_unit, 'T', 'F') as DIRECTION
                                           'T' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND (receiver <> v_unit)
                                       AND send_date IS NOT NULL
                                       AND xfr_type = 'DFOTF')
                                   UNION ALL
                                   (SELECT                        -- if end of fiscal year transfer sent
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           xfr_type_desc || ' TO ' || receiver_name AS transaction_desc,
                                           voucher_no AS claim_no,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                  'Y', amount,
                                                  0) AS adj_acct,
                                           
                                           --0 as SUB_TRANS,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                  'N', amount,
                                                  0) AS sub_trans,
                                           0 AS transact, 0 AS incidentals,
                                           xfr_type || 'EOFY' AS transaction_type, status,
                                           'T' AS direction
                                      --'F' as DIRECTION
                                    FROM   v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND (receiver <> v_unit)
                                       AND send_date IS NOT NULL
                                       AND xfr_type = 'WFAF')
                                   UNION ALL
                                   (SELECT                        -- if end of fiscal year transfer sent
                                           DECODE(receive_date,
                                                  NULL, send_date,
                                                  receive_date) AS transaction_date,
                                           xfr_type_desc || ' TO ' || receiver_name AS transaction_desc,
                                           voucher_no AS claim_no, 0 AS adj_acct, 0 AS sub_trans,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                  'Y', amount,
                                                  0) AS transact,
                                           DECODE(Cfunds_Pkg.is_unit_parent(v_unit, receiver),
                                                  'N', amount,
                                                  0) AS incidentals,
                                           xfr_type || 'EOFY' AS transaction_type, status,
                                           'T' AS direction
                                      FROM v_cfunds_xfr
                                     WHERE sender = v_unit
                                       AND (receiver <> v_unit)
                                       AND send_date IS NOT NULL
                                       AND (   xfr_type = 'OA'
                                            OR xfr_type = 'OE')))
                            WHERE TRUNC(transaction_date) BETWEEN
                                                                 --                         Cfunds_Pkg.Get_Fiscal_Year_Start_Date( v_fiscal_year ) and
                                                                 --                         Cfunds_Pkg.Get_Fiscal_Year_End_Date( v_fiscal_year )
                                                                 v_start_date AND v_end_date
                         ORDER BY transaction_date)
                    LOOP
                        -- calculate outstanding transactions column.
                        -- v_Outstanding_trans :=  v_Outstanding_trans + t.TRANSACT + t.SUB_TRANS;
                        -- calculate the total accountability.  Using the t.ADJ_ACCT value.
                        -- (this goes in the 'OUTSTANDING FORMS 26 & 30' column.)
                        IF t.transaction_type = 'A' THEN
                            -- advances transaction
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        ELSIF t.transaction_type = 'AR' THEN
                            -- repayments transaction
                            v_outstanding_trans := v_outstanding_trans - t.transact;
                        ELSIF t.transaction_type = 'E' THEN
                            -- expense transaction
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        ELSIF t.transaction_type = 'ET' THEN
                            -- the amount paid to the agent for a TFOS expense
                            v_outstanding_trans := v_outstanding_trans + t.transact;
                        ELSIF t.transaction_type = 'ER' THEN
                            -- repayment.
                            v_outstanding_trans := v_outstanding_trans - t.transact;
                        ELSIF t.transaction_type = 'WFXFR' THEN           -- transfer in and out of unit
                            -- SUB_TRANS is a wf to a sub unit, ADJ_ACCT is a wf to a parent unit
                            IF (t.direction = 'F') THEN
                                v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                                v_total_accountability := v_total_accountability + t.adj_acct;
                            ELSE                                                      -- Direction = 'T'
                                v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                                v_total_accountability := v_total_accountability - t.adj_acct;
                            END IF;
                        ELSIF t.transaction_type = 'ERXFR' THEN                    -- transfer into unit
                            --expense repayment transfer;
                            IF (t.direction = 'F') THEN
                                v_outstanding_trans := v_outstanding_trans - t.transact;
                            ELSE                                                      -- Direction = 'T'
                                v_outstanding_trans := v_outstanding_trans + t.transact;
                            END IF;
                        ELSIF t.transaction_type = 'DERXFR' THEN                   -- transfer into unit
                            --disallowed expense repayment transfer
                            IF (t.direction = 'F') THEN
                                v_outstanding_trans := v_outstanding_trans - t.transact;
                            ELSE                                                      -- Direction = 'T'
                                v_outstanding_trans := v_outstanding_trans + t.transact;
                            END IF;
                        ELSIF t.transaction_type = 'XFR-SELF' THEN
                            -- this is the simulated case of HQ getting funds from on high and there being given
                            -- a pot of money to work with.
                            IF (t.direction = 'F') THEN
                                v_total_accountability := v_total_accountability + t.adj_acct;
                                v_outstanding_trans := v_outstanding_trans - t.transact;
                            ELSE                                                      -- Direction = 'T'
                                v_total_accountability := v_total_accountability - t.adj_acct;
                                v_outstanding_trans := v_outstanding_trans + t.transact;
                            END IF;
                        ELSIF t.transaction_type = 'XFR-DFO' THEN
                            -- this is the case of a unit getting or repaying DFO funds.
                            -- this affects the working fund balance.
                            IF (t.direction = 'F') THEN
                                v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                                v_total_accountability := v_total_accountability + t.adj_acct;
                            ELSE                                                      -- Direction = 'T'
                                v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                                v_total_accountability := v_total_accountability - t.adj_acct;
                            END IF;
                        ELSIF t.transaction_type = 'WFAFEOFY' THEN
                            -- do them WFAF end of fiscal year transfers
                            IF (t.direction = 'F') THEN
                                v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                                v_total_accountability := v_total_accountability + t.adj_acct;
                            ELSE                                                      -- Direction = 'T'
                                v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                                v_total_accountability := v_total_accountability - t.adj_acct;
                            END IF;
                        ELSIF t.transaction_type = 'DFOTFEOFY' THEN
                            -- do them DFOTF end of fiscal year transfers
                            IF (t.direction = 'F') THEN
                                v_outstanding_trans := v_outstanding_trans - t.sub_trans;
                                v_total_accountability := v_total_accountability + t.adj_acct;
                            ELSE                                                      -- Direction = 'T'
                                v_outstanding_trans := v_outstanding_trans + t.sub_trans;
                                v_total_accountability := v_total_accountability - t.adj_acct;
                            END IF;
                        --if (t.DIRECTION = 'F') then
                        --    v_total_accountability := v_total_accountability - t.ADJ_ACCT;
                        --else
                        --    v_total_accountability := v_total_accountability + t.ADJ_ACCT;
                        --end if;
                        ELSIF t.transaction_type = 'OAEOFY' THEN
                            -- do them OA end of fiscal year transfers
                            IF (t.direction = 'F') THEN
                                v_total_accountability := v_total_accountability - t.transact;
                                v_outstanding_trans := v_outstanding_trans - t.transact;
                            ELSE
                                v_total_accountability := v_total_accountability + t.transact;
                                v_outstanding_trans := v_outstanding_trans + t.transact;
                            END IF;
                        ELSIF t.transaction_type = 'OEEOFY' THEN
                            -- do them OE end of fiscal year transfers
                            IF (t.direction = 'F') THEN
                                v_total_accountability := v_total_accountability - t.transact;
                                v_outstanding_trans := v_outstanding_trans - t.transact;
                            ELSE
                                v_total_accountability := v_total_accountability + t.transact;
                                v_outstanding_trans := v_outstanding_trans + t.transact;
                            END IF;
                        END IF;
    
                        IF NOT v_skip_record THEN
                            IF v_row_ind = 0 THEN
                                v_row_ind := 1;
                                htp.tableRowOpen(NULL,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 'style="BACKGROUND-COLOR: lightcyan"');
                                ELSE
                                    v_row_ind := 0;
                                    htp.tableRowOpen;
                                    END IF;
            
                                    htp.tabledata('<font face="Arial" size="1">'
                                                  || TO_CHAR(t.transaction_date, 'dd-Mon-yyyy') || '</font>',
                                                  NULL,
                                                  NULL,
                                                  'nowrap');
                                    htp.tabledata('<font face="Arial" size="1">' || t.transaction_desc
                                                  || '</font>',
                                                  NULL,
                                                  NULL,
                                                  'nowrap');
                                    htp.tabledata('<font face="Arial" size="1">' || t.claim_no || '</font>');
            
                                    -- Accountability Adjustments
                                    IF t.adj_acct = 0 THEN
                                        htp.tabledata('0', 'right', NULL, 'nowrap');
                                    ELSE
                                        IF (t.direction = 'F') THEN
                                            htp.tabledata('<font face="Arial" size="1">'
                                                          || TO_CHAR(t.adj_acct, v_dollar_format) || '</font>',
                                                          'right',
                                                          NULL,
                                                          'nowrap');
                                        ELSE
                                            htp.tabledata('<font face="Arial" size="1" color="#ff0000">('
                                                          || TO_CHAR(t.adj_acct, v_dollar_format) || ')</font>',
                                                          'right',
                                                          NULL,
                                                          'nowrap');
                                        END IF;
                                    END IF;
            
                                    -- subordinate transfers - transfers from sub units and to sub units.
                                    IF t.sub_trans = 0 THEN
                                        htp.tabledata('0', 'right', NULL, 'nowrap');
                                    ELSE
                                        IF (t.direction = 'F') THEN
                                            htp.tabledata('<font face="Arial" size="1">'
                                                          || TO_CHAR(t.sub_trans, v_dollar_format) || '</font>',
                                                          'right',
                                                          NULL,
                                                          'nowrap');
                                        ELSE
                                            htp.tabledata('<font face="Arial" size="1" color="#ff0000">('
                                                          || TO_CHAR(t.sub_trans, v_dollar_format) || ')</font>',
                                                          'right',
                                                          NULL,
                                                          'nowrap');
                                        END IF;
                                    END IF;
            
                                    -- Transactions - expenses and advances, wf transfers to other units, expense repayments,
                                    -- advance repayments, expense repayment transfers, Disallowed expense repayments.
                                    IF t.transact = 0 THEN
                                        htp.tabledata('0', 'right', NULL, 'nowrap');
                                    ELSE
                                        IF (t.direction = 'F') THEN
                                            htp.tabledata('<font face="Arial" size="1">'
                                                          || TO_CHAR(t.transact, v_dollar_format) || '</font>',
                                                          'right',
                                                          NULL,
                                                          'nowrap');
                                        ELSE
                                            htp.tabledata('<font face="Arial" size="1" color="#ff0000">('
                                                          || TO_CHAR(t.transact, v_dollar_format) || ')</font>',
                                                          'right',
                                                          NULL,
                                                          'nowrap');
                                        END IF;
                                    END IF;
            
                                    -- this is the expenses from Advances column
                                    IF t.incidentals = 0 THEN
                                        htp.tabledata('0', 'right', NULL, 'nowrap');
                                    ELSE
                                        htp.tabledata('<font face="Arial" size="1">'
                                                      || TO_CHAR(t.incidentals, v_dollar_format) || '</font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    END IF;
            
                                    htp.tabledata('<font face="Arial" size="1">'
                                                  || TO_CHAR(v_outstanding_trans, v_dollar_format) || '</font>',
                                                  'right',
                                                  NULL,
                                                  'nowrap');
                                    -- The following is the balance on Hand which is really the working fund total.
                                    htp.tabledata('<font face="Arial" size="1">'
                                                  || TO_CHAR((v_total_accountability - v_outstanding_trans),
                                                             v_dollar_format)
                                                  || '</font>',
                                                  'right',
                                                  NULL,
                                                  'nowrap');
                                    htp.tabledata('<font face="Arial" size="1">'
                                                  || TO_CHAR(v_total_accountability, v_dollar_format)
                                                  || '</font>',
                                                  'right',
                                                  NULL,
                                                  'nowrap');
                                htp.tableRowClose;
                            END IF;
        
                            -- Reset
                            v_skip_record := FALSE;
                        END LOOP;
        
                        -- The calculated balance should match the current_working_fund that is calculated
                        -- above; if they don't match then they both are shown, and something is wrong.
                        IF pdebug IS NOT NULL THEN
                            -- allow pDebug flag to be used to display debugging data.
                            v_current_working_fund := fake_get_unit_wf_balance(v_unit);
                        ELSE
                            -- this will get the balance to the end date and including the end date.  The way Get_Unit_WF_Balance works.
                            v_current_working_fund :=
                                              Cfunds_Pkg.get_unit_wf_balance(v_unit, FALSE, v_end_date + 1);
                        END IF;
        
                        IF TO_DATE(v_end_date, 'dd-Mon-yyyy') < TO_DATE(SYSDATE, 'dd-Mon-yyyy') THEN
                            -- enter a comment (temporary, until we complete the "Stake-in-the-ground" ability.).
                            htp.print
                                ('<tr><td colspan="10">These calculations do not include your latest transactions.  This total may not be your current Working Fund Balance.</td></tr>');
                        END IF;
        
                        IF v_current_working_fund <>(v_total_accountability - v_outstanding_trans) THEN
                            -- print extra data to alert the user to a problem.
                            htp.tableRowOpen;
                                htp.tabledata('');
                                htp.tabledata('');
                                htp.tabledata('');
                                htp.tabledata('');
                                htp.tabledata('');
                                htp.tabledata('');
                                htp.tabledata('');
                                htp.tabledata('');
                                htp.tabledata
                                             ('<font face="Arial" size="2">Your check book balance is: </font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(v_current_working_fund, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        --htp.print('<tr><td colspan="10">Something is wrong in these calculations.</td></tr>');
                        --htp.print('<tr><td colspan="10">END date = ' || TO_CHAR(v_end_date + 1) || '.</td></tr>');
                        END IF;
                    ELSE
                        htp.print('Unexpected tag: ' || v_tag);
                    END IF;
                END LOOP;
            END printform28;
        
            -- only used by Form29 code to  try and calulate past fiscal year amounts.
            -- (Not sure that this is a good thing, so don't put it in the Cfunds_Pkg code.).
            FUNCTION fake2_get_unit_accountability(punit IN VARCHAR2, pfiscalyear IN VARCHAR2)
                RETURN NUMBER IS
                v_bal   NUMBER := 0;
            BEGIN
                FOR x IN (SELECT *
                            FROM T_CFUNDS_XFR
                           WHERE     xfr_type = 'WF'
                                 AND send_date IS NOT NULL
                                 AND receive_date IS NOT NULL
                                 AND (    receiver = punit
                                      AND receive_date
                                              BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(pfiscalyear)
                                                  AND Cfunds_Pkg.get_fiscal_year_end_date(pfiscalyear))
                              OR (    sender = punit
                                  AND send_date BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(pfiscalyear)
                                                    AND Cfunds_Pkg.get_fiscal_year_end_date(pfiscalyear)))
                LOOP
                    IF x.receiver = punit                              /* and x.RECEIVE_DATE is not null */
                                         THEN
                        v_bal := v_bal + NVL(x.amount, 0);
                    END IF;
        
                    IF x.sender = punit /* and x.SEND_DATE is not null */ AND x.sender <> x.receiver THEN
                        v_bal := v_bal - NVL(x.amount, 0);
                    END IF;
                END LOOP;
        
                RETURN v_bal;
            END fake2_get_unit_accountability;
        
            PROCEDURE form29(
                punit            IN   VARCHAR2,
                pfiscalyear      IN   VARCHAR2,
                pdebug           IN   VARCHAR2,
                pusage           IN   VARCHAR2,
                pcommand         IN   VARCHAR2,
                pauditor1_name   IN   VARCHAR2,
                pauditor2_name   IN   VARCHAR2,
                pdetco_name      IN   VARCHAR2,
                pincoming_name   IN   VARCHAR2,
                pskipchecks      IN   VARCHAR2) IS
                -- This procedure will show the Form 29 in report output and the user can
                -- hit a print button from there.  No second window is opened at this time.
                v_template                  CLOB;
                v_template_date             DATE;
                v_offset                    NUMBER                   := 1;
                v_tag                       VARCHAR2(100);
                v_query                     VARCHAR2(4000);
                v_cursor                    INTEGER;
                v_ok                        BOOLEAN;
                v_unit                      T_CFUNDS_UNIT.SID%TYPE;
                v_fiscal_year               VARCHAR2(10);
                v_outstanding_amount        NUMBER                   := 0;
                v_liabilities               NUMBER                   := 0;
                v_total_accountability      NUMBER                   := 0;
                v_working_fund_balance      NUMBER                   := 0;
                v_start_fiscal_year         DATE;
                v_end_fiscal_year           DATE;
                v_subordinate_total         NUMBER                   := 0;
                v_is_paid_down              VARCHAR2(10);
                v_new_transfer              VARCHAR2(50);
                -- save totals from different sections
                v_total_1a                  NUMBER                   := 0;
                v_total_1b                  NUMBER                   := 0;
                v_total_2a                  NUMBER                   := 0;
                v_total_2b_a                NUMBER                   := 0;
                v_total_2b_b                NUMBER                   := 0;
                v_total_2b_c                NUMBER                   := 0;
                v_total_2b_d                NUMBER                   := 0;
                v_total_2b_e                NUMBER                   := 0;
                v_total_2c                  NUMBER                   := 0;
                v_subtotal_2c               NUMBER                   := 0;
                v_corrupt_data_result       VARCHAR2(20000);
                v_since_date                DATE;
                v_recon_threshold           NUMBER                   := 200;
                -- Days before last reconcile to look for transactions
                v_repaid_msg                VARCHAR2(100);
                v_repaid_exp_sid            VARCHAR2(50);
                v_top_dog                   VARCHAR2(20)             := 'false';
                v_usage                     VARCHAR2(50);
                -- cc = custodian change; a = audit (only 2 usages allowed for this form).
                v_subordinate_unit_exists   VARCHAR2(20)             := 'false';
                v_current_fiscal_year       VARCHAR2(20)             := 'false';
            BEGIN
                v_since_date := SYSDATE -(2 * v_recon_threshold);                            -- early limit
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.form_29');
                   -- if the fiscal year wasn't specified, use the current fiscal year.
                -- ONLY USE CURRENT FISCAL YEAR. PREVIOUS YEARS DO NOT WORK.
                v_fiscal_year := Cfunds_Pkg.get_fiscal_year(SYSDATE);
        
                --NVL(pFiscalYear,Cfunds_Pkg.get_fiscal_year(SYSDATE));
                IF pcommand IS NULL THEN
                    -- when the form first comes up, allow the user to see and edit the custodian name.
                    v_ok :=
                         Web_Template_Pkg.get_latest('cfunds_form29_preamble', v_template, v_template_date);
        
                    IF v_template_date IS NULL THEN
                        Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_form29_preamble"');
                        htp.print('Could not locate template');
                        RETURN;
                    END IF;
        
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'UNIT',
                                                     NVL(punit, Cfunds_Pkg.get_my_cfunds_unit));
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'USAGE', NVL(pusage, 'cc'));
        
                    -- put the debug parameter in a hidden field if it exists.
                    IF NOT pdebug IS NULL THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'DEBUG_PARAM',
                                                         '<INPUT type="hidden" NAME="pDebug" VALUE="'
                                                         || pdebug || '">');
                    ELSE
                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'DEBUG_PARAM', ' ');
                    END IF;
        
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'FISCAL_YEAR_PARAM',
                                                     '<INPUT type="hidden" NAME="pFiscalYear" VALUE="'
                                                     || v_fiscal_year || '">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'FISCAL_YEAR',
                                                     'Fiscal Year: ' || v_fiscal_year);
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'DO_USAGE', 'Do Audit');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'TEXTAREA_LABEL',
                             'Enter the names below that are the correct names of the persons who will sign this form.');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'DO_USAGE', 'Do Audit');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'FORM_TITLE', 'CUSTODIAN CHANGE FORM');
                    -- change the button to allow user to switch name entry form.
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'FEEDBACK',
                             'Outgoing Custodian''s Name: <input maxLength="50" size="50" name="pAuditor1_Name" value=" ">');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'FEEDBACK_LINE_2', ' ');
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'FEEDBACK_LINE_3',
                             'Incoming Custodian''s Name or Detachment Commander''s Name: <input maxLength="50" size="50" name="pIncoming_Name" value=" ">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'TOP_LABEL',
                                                     'Custodian Change Form Name Verification');
                    -- serve the page and return to prevent extra processing from happening in the rest of this method.
                    v_ok := Web_Template_Pkg.serve_clob(v_template);
                    RETURN;
                ELSIF pcommand = 'Do Audit' THEN
                    -- allow the user to see and edit the auditor names.
                    v_ok :=
                         Web_Template_Pkg.get_latest('cfunds_form29_preamble', v_template, v_template_date);
        
                    IF v_template_date IS NULL THEN
                        Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_form29_preamble"');
                        htp.print('Could not locate template');
                        RETURN;
                    END IF;
        
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'UNIT',
                                                     NVL(punit, Cfunds_Pkg.get_my_cfunds_unit));
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'USAGE', 'a');
        
                    -- put the debug parameter in a hidden field if it exists.
                    IF NOT pdebug IS NULL THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'DEBUG_PARAM',
                                                         '<INPUT type="hidden" NAME="pDebug" VALUE="'
                                                         || pdebug || '">');
                    ELSE
                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'DEBUG_PARAM', ' ');
                    END IF;
        
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'FISCAL_YEAR_PARAM',
                                                     '<INPUT type="hidden" NAME="pFiscalYear" VALUE="'
                                                     || v_fiscal_year || '">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'FISCAL_YEAR',
                                                     'Fiscal Year: ' || v_fiscal_year);
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'DO_USAGE', 'Do Custodian Change');
                    -- change the button to allow user to switch name entry form.
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'TEXTAREA_LABEL',
                             'Enter the names below that are the correct names of the persons who will sign this form.');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'FORM_TITLE', 'AUDIT FORM');
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'FEEDBACK',
                             'First Auditor''s Name: <input maxLength="50" size="50" name="pAuditor1_Name" value=" ">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'FEEDBACK_LINE_2',
                             'Second Auditor''s Name: <input maxLength="50" size="50" name="pAuditor2_Name" value=" ">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'FEEDBACK_LINE_3',
                             'Detco''s Name:  <input maxLength="50" size="50" name="pDetCo_Name" value=" ">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template, 'TOP_LABEL',
                                                     'Audit Form Name Verification');
                    -- serve the page and return to prevent extra processing from happening in the rest of this method.
                    v_ok := Web_Template_Pkg.serve_clob(v_template);
                    RETURN;
                ELSIF pcommand = 'Do Custodian Change' THEN
                    -- allow the user to see and edit the custodian names.
                    v_ok :=
                         Web_Template_Pkg.get_latest('cfunds_form29_preamble', v_template, v_template_date);
        
                    IF v_template_date IS NULL THEN
                        Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_form29_preamble"');
                        htp.print('Could not locate template');
                        RETURN;
                    END IF;
        
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'UNIT',
                                                     NVL(punit, Cfunds_Pkg.get_my_cfunds_unit));
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'USAGE', 'cc');
        
                    -- put the debug parameter in a hidden field if it exists.
                    IF NOT pdebug IS NULL THEN
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'DEBUG_PARAM',
                                                         '<INPUT type="hidden" NAME="pDebug" VALUE="'
                                                         || pdebug || '">');
                    ELSE
                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'DEBUG_PARAM', ' ');
                    END IF;
        
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'FISCAL_YEAR_PARAM',
                                                     '<INPUT type="hidden" NAME="pFiscalYear" VALUE="'
                                                     || v_fiscal_year || '">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'FISCAL_YEAR',
                                                     'Fiscal Year: ' || v_fiscal_year);
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'DO_USAGE', 'Do Audit');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'TEXTAREA_LABEL',
                             'Enter the names below that are the correct names of the persons who will sign this form.');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'FORM_TITLE', 'CUSTODIAN CHANGE FORM');
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'FEEDBACK',
                             'Outgoing Custodian''s Name: <input maxLength="50" size="50" name="pAuditor1_Name" value=" ">');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'FEEDBACK_LINE_2', ' ');
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                            (v_template,
                             'FEEDBACK_LINE_3',
                             'Incoming Custodian''s Name or Detachment Commander''s Name: <input maxLength="50" size="50" name="pIncoming_Name" value=" ">');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'TOP_LABEL',
                                                     'Custodian Change Form Name Verification');
                    -- serve the page and return to prevent extra processing from happening in the rest of this method.
                    v_ok := Web_Template_Pkg.serve_clob(v_template);
                    RETURN;
                ELSE
                    -- once the user has entered the custodian or approver names, the form will be shown.
                    v_ok := Web_Template_Pkg.get_latest('cfunds_form_29', v_template, v_template_date);
        
                    IF v_template_date IS NULL THEN
                        Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_form_29"');
                        htp.print('Could not locate template');
                        RETURN;
                    END IF;
                END IF;
        
                v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                Web_Util_Pkg.send_comment('Unit SID is ' || v_unit);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'UNIT',
                                                 Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TODAYS_DATE', SYSDATE);
                v_start_fiscal_year := Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year);
                v_end_fiscal_year := Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
        
                IF v_fiscal_year = Cfunds_Pkg.get_fiscal_year(SYSDATE) THEN
                    v_current_fiscal_year := 'true';
                END IF;
        
                -- for past fiscal years, it doesn't make sense to show the current working fund balance,
                -- so don't even bother running this code.
                IF v_current_fiscal_year = 'true' THEN
                    IF pdebug IS NOT NULL THEN
                        v_working_fund_balance := NVL(fake_get_unit_wf_balance(v_unit), 0);
                    ELSE
                        v_working_fund_balance := NVL(Cfunds_Pkg.get_unit_wf_balance(v_unit), 0);
                    END IF;
        
                    IF pskipchecks IS NULL THEN
                        ------------------------- output details of any corrupt data.----------------------
                        -- Check expense and advance offset amounts. [OFFSET].
                        v_corrupt_data_result := validate_form29(v_unit);
        
                        IF v_corrupt_data_result <> 'none' THEN
                            htp.p
                                ('<b>Corrupt data found: [OFFSET]</b> <br>Expense totals taken from Advances don''t equal total Advances paid by expenses.'
                                 || v_corrupt_data_result || '<p>');
                        END IF;
        
                        -- check repayments against total of advances for integrity. [REPAYMENT].
                        v_corrupt_data_result := validate_advances_repaid(v_unit);
        
                        IF v_corrupt_data_result <> 'none' THEN
                            htp.p
                                ('<b>Corrupt data found: [REPAYMENT]</b> <br>Advance totals don''t add up. '
                                 || v_corrupt_data_result || '<p>');
                        END IF;
        
                        -- check total of expenses against paid amounts and advanced amounts. [MATCHING].
                        v_corrupt_data_result := validate_expense_details(v_unit, v_fiscal_year);
        
                        IF v_corrupt_data_result <> 'none' THEN
                            htp.p
                                ('<b>Corrupt data found: [MATCHING]</b> <br>Expense totals don''t add up. '
                                 || v_corrupt_data_result || '<p>');
                        END IF;
        
                                    -- check Take From Other Sources expenses for invalid paid amounts. [OVERPAID].
                        /*            v_corrupt_data_result := Validate_Expenses_TFOS(v_unit,v_fiscal_year );
                                    IF v_corrupt_data_result <> 'none' THEN
                                        htp.p('<b>Corrupt data found: [OVERPAID]</b> <br>Expenses marked "Take From Other Sources" have payment amounts that shouldn''t be there. '
                                               || '<br>Although this is an error, this amount should not be affecting the balance totals on this form.'
                                               || '<br>The system will be updated to provide a way to pay the agent for this expense AFTER the Payment Listing has been received.  When this happens, these expenses will need to be changed. '
                                               || v_corrupt_data_result || '<p>');
                                    END IF;*/
        
                        -- check for expenses that were paid back to agent but not recorded in system. [MISSING].
                        v_corrupt_data_result := validate_expenses_tfos_2(v_unit, v_fiscal_year);
        
                        IF v_corrupt_data_result <> 'none' THEN
                            htp.p
                                ('<b>Corrupt data found: [MISSING]</b> <br>Expenses marked "Take From Other Sources" have been closed without any record that the agent was paid back. '
                                 || '<br>This is an error that will be fixed later. Until then, this amount should be subtracted from the balance total in Part II of this form.'
                                 || '<br>The system will be updated to provide a way to pay the agent for this expense AFTER the Payment Listing has been received.  When this happens, these expenses will need to be changed. '
                                 || v_corrupt_data_result || '<p>');
                        END IF;
        
                        -- check DER transers for valid data in related transfers to that expense. [DISALLOWED].
                        v_corrupt_data_result := validate_der_processing(v_unit, v_fiscal_year);
        
                        IF v_corrupt_data_result <> 'none' THEN
                            htp.p
                                ('<b>Corrupt data found: [DISALLOWED]</b> <br>Your unit has one or more Disallowed Expense Reimbursement transfers for an expense '
                                 || '<br>that has also been paid on a payment listing by your parent unit.'
                                 || '<br>This basically means that you were paid twice for the same expense.'
                                 || v_corrupt_data_result || '<p>');
                        END IF;
        
                        htp.p('<br>');
                    END IF;
                END IF;
        
                -- save the fact that this is the top unit if it is.
                IF Cfunds_Pkg.get_parent_unit(v_unit) IS NULL THEN
                    v_top_dog := 'true';
                END IF;
        
                v_total_2a := v_working_fund_balance;
                v_usage := NVL(pusage, 'cc');
        
                IF v_usage = 'a' THEN
                    -- put the appropriate headers on the form.
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TITLE', 'C-FUNDS AUDIT');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'HEADING', 'C-FUNDS AUDIT');
                    -- hide this section when the form is used as an audit form.
                    -- these tags are at the bottom of the html template in a script.
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_1',
                                                     'Outgoing_List.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_2',
                                                     'Total_Outgoing.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_3',
                                                     'Total_Outgoing_Amt.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_4',
                                                     'Total_Outgoing_Title.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_5',
                                                     'Total_Outgoing_Title_2.innerHTML=" "');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_4_REPLACEMENT_1', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_4_REPLACEMENT_2', ' ');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_5_REPLACEMENT_1',
                                                     'Custodian_Change_Section.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_5_REPLACEMENT_2',
                                                     'Custodian_Change_Section_Header.innerHTML=" "');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'NAME_OF_CUSTODIAN', 'NAME OF AUDITOR');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SIGNATURE_OF_CUSTODIAN',
                                                     'SIGNATURE OF AUDITOR');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'TOTAL_ACCOUNTABLE_FUNDS_LABEL',
                                                     'TOTAL ACCOUNTABLE FUNDS');
                ELSIF v_usage = 'r' THEN
                    -- put the appropriate headers on the form.
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TITLE', 'C-FUNDS ACCOUNT DETAILS');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'HEADING', 'C-FUNDS ACCOUNT DETAILS');
                    -- hide this section when the form is used as an audit form.
                    -- these tags are at the bottom of the html template in a script.
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_1',
                                                     'Outgoing_List.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_2',
                                                     'Total_Outgoing.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_3',
                                                     'Total_Outgoing_Amt.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_4',
                                                     'Total_Outgoing_Title.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_3_REPLACEMENT_5',
                                                     'Total_Outgoing_Title_2.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_4_REPLACEMENT_1',
                                                     'SECOND_AUDITOR_SIGNATURE.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_4_REPLACEMENT_2',
                                                     'AUDITOR_COMMENTS.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_5_REPLACEMENT_1',
                                                     'Custodian_Change_Section.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_5_REPLACEMENT_2',
                                                     'Custodian_Change_Section_Header.innerHTML=" "');
                    -- Replace these 3 tags only if this form is used for reconciliation.
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_6_REPLACEMENT_1',
                                                     'Line.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_6_REPLACEMENT_2',
                                                     'Auditor_Section_Header.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_6_REPLACEMENT_3',
                                                     'Certification_Statement.innerHTML=" "');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'NAME_OF_CUSTODIAN', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SIGNATURE_OF_CUSTODIAN', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOTAL_ACCOUNTABLE_FUNDS_LABEL', ' ');
                ELSE
                    -- put the appropriate headers on the form.
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TITLE', 'CUSTODIAN CHANGE');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'HEADING', 'CUSTODIAN CHANGE');
                    -- replace these tags so this section doesn't get hidden.
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_3_REPLACEMENT_1', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_3_REPLACEMENT_2', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_3_REPLACEMENT_3', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_3_REPLACEMENT_4', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_3_REPLACEMENT_5', ' ');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_4_REPLACEMENT_1',
                                                     'SECOND_AUDITOR_SIGNATURE.innerHTML=" "');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SECTION_4_REPLACEMENT_2',
                                                     'AUDITOR_COMMENTS.innerHTML=" "');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_5_REPLACEMENT_1', ' ');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_5_REPLACEMENT_2', ' ');
                    v_ok :=
                          Web_Template_Pkg.replace_tag(v_template, 'NAME_OF_CUSTODIAN', 'NAME OF CUSTODIAN');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'SIGNATURE_OF_CUSTODIAN',
                                                     'SIGNATURE OF CUSTODIAN');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'TOTAL_ACCOUNTABLE_FUNDS_LABEL',
                                                     'TOTAL ACCOUNTABLE FUNDS AND PENDING TRANSACTIONS');
                END IF;
        
                -- replace these tags if they didn't get replaced above.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_6_REPLACEMENT_1', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_6_REPLACEMENT_2', ' ');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SECTION_6_REPLACEMENT_3', ' ');
                -- Part II A -- Section 1-----------------
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'CASH_ON_HAND',
                                                 TO_CHAR(v_working_fund_balance, v_dollar_format));
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CUSTODIAN_NAME', UPPER(pauditor1_name));
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'AUDITOR_2_NAME', UPPER(pauditor2_name));
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'DETCO_NAME', UPPER(pdetco_name));
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'INCOMING_CUSTODIAN_NAME',
                                                 UPPER(pincoming_name));
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'NAME_INCOMING_CUSTODIAN',
                                                 'NAME OF INCOMING CUSTODIAN OR DETACHMENT COMMANDER');
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'SIGNATURE_INCOMING_CUSTODIAN',
                                                 'SIGNATURE OF INCOMING CUSTODIAN OR DETACHMENT COMMANDER');
        
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
        
                    -- Part I A -- Section 1 ---------------------
                    IF v_tag = 'FUNDS_RECEIVED_LIST' THEN
                        -- Incoming Working Fund Transfers
                        v_total_accountability := 0;
        
                        FOR t IN (SELECT   description, amount, item_date
                                      FROM ((SELECT voucher_no || ' from DFAS' AS description, amount,
                                                    receive_date AS item_date
                                               FROM v_cfunds_xfr
                                              WHERE receiver = v_unit
                                                AND sender = v_unit
                                                AND receive_date IS NOT NULL
                                                AND xfr_type = 'WF'
                                                AND amount > 0)
                                            UNION ALL
                                            (SELECT voucher_no || ' from ' || sender_name AS description,
                                                    amount, receive_date AS item_date
                                               FROM v_cfunds_xfr
                                              WHERE receiver = v_unit
                                                AND sender <> v_unit
                                                AND receive_date IS NOT NULL
                                                AND send_date IS NOT NULL
                                                AND xfr_type = 'WF')
                                            UNION ALL
                                            (SELECT   'Working funds from ' || sender_name AS description,
                                                      SUM(DECODE(xfr_type, 'WFAF', amount, -1 * amount)),
                                                      receive_date AS item_date
                                                 FROM v_cfunds_xfr
                                                WHERE receiver = v_unit
                                                  AND (   sender <> v_unit
                                                       OR sender = v_hq_cc_unit_sid)--'1010005M')
                                                  AND receive_date IS NOT NULL
                                                  AND send_date IS NOT NULL
                                                  AND xfr_type IN('WFAF', 'OA', 'OE')
                                             GROUP BY sender_name, receive_date)
                                            UNION ALL
                                            (SELECT   'DFO forward from ' || sender_name AS description,
                                                      SUM(amount), receive_date AS item_date
                                                 FROM v_cfunds_xfr
                                                WHERE receiver = v_unit
                                                  AND (   sender <> v_unit
                                                       OR sender = v_hq_cc_unit_sid)--'1010005M')
                                                  AND receive_date IS NOT NULL
                                                  AND send_date IS NOT NULL
                                                  AND xfr_type IN('DFOTF')
                                             GROUP BY sender_name, receive_date)
                                            UNION ALL
                                            (SELECT voucher_no || ' from DFO' AS description, amount,
                                                    receive_date AS item_date
                                               FROM v_cfunds_xfr
                                              WHERE receiver = v_unit
                                                AND sender = v_unit
                                                AND receive_date IS NOT NULL
                                                AND xfr_type = 'DFOA'))
                                     WHERE item_date BETWEEN v_start_fiscal_year AND v_end_fiscal_year
                                  ORDER BY item_date)
                        LOOP
                            -- add the total amount received.
                            v_total_accountability := v_total_accountability + NVL(t.amount, 0);
                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || t.description || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.item_date, 'dd-Mon-yyyy') || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.amount, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END LOOP;
        
                        IF v_total_accountability = 0 THEN
                            htp.tableRowOpen;
                                htp.print
                                    ('<td colspan = "3"><font face="Arial" size="2">No transfers found</font></td>');
                            htp.tableRowClose;
                        END IF;
        
                        v_total_1a := v_total_1a + v_total_accountability;
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'FUNDS_RECEIVED',
                                                         TO_CHAR(v_total_accountability, v_dollar_format));
                    -- Part I A -- Section 2 ---------------------
                    ELSIF v_tag = 'FUNDS_SENT_LIST' THEN
                        -- Received Outgoing Working Fund Transfers
                        v_total_accountability := 0;
        
                        FOR t IN (SELECT   description, amount, item_date
                                      FROM ((SELECT voucher_no || ' to DFAS' AS description,
                                                    ABS(amount) AS amount, receive_date AS item_date
                                               FROM v_cfunds_xfr
                                              WHERE receiver = v_unit
                                                AND sender = v_unit
                                                AND receive_date IS NOT NULL
                                                AND xfr_type = 'WF'
                                                AND amount < 0)
                                            UNION ALL
                                            (SELECT voucher_no || ' to ' || receiver_name AS description,
                                                    amount, receive_date AS item_date
                                               --Was send_date. As send date the audit is broken for WF xfr sent over a FY change.
                                             FROM   v_cfunds_xfr
                                              WHERE sender = v_unit
                                                AND receiver <> v_unit
                                                AND send_date IS NOT NULL
                                                AND receive_date IS NOT NULL
                                                AND xfr_type = 'WF')
                                            UNION ALL
                                            (SELECT   'Working funds to ' || receiver_name AS description,
                                                      SUM(DECODE(xfr_type, 'WFAF', amount, -1 * amount)),
                                                      receive_date AS item_date
                                                 FROM v_cfunds_xfr
                                                WHERE receiver <> v_unit
                                                  AND sender = v_unit
                                                  AND receive_date IS NOT NULL
                                                  AND send_date IS NOT NULL
                                                  AND xfr_type IN('WFAF', 'OA', 'OE')
                                             GROUP BY receiver_name, receive_date)
                                            UNION ALL
                                            (SELECT   'DFO forward to ' || receiver_name AS description,
                                                      SUM(amount), receive_date AS item_date
                                                 FROM v_cfunds_xfr
                                                WHERE receiver <> v_unit
                                                  AND sender = v_unit
                                                  AND receive_date IS NOT NULL
                                                  AND send_date IS NOT NULL
                                                  AND xfr_type IN('DFOTF')
                                             GROUP BY receiver_name, receive_date)
                                            UNION ALL
                                            (SELECT voucher_no || ' to DFO' AS description, amount,
                                                    send_date AS item_date
                                               FROM v_cfunds_xfr
                                              WHERE receiver = v_unit
                                                AND sender = v_unit
                                                AND send_date IS NOT NULL
                                                AND receive_date IS NOT NULL
                                                AND xfr_type = 'DFOR'))
                                     WHERE item_date BETWEEN v_start_fiscal_year AND v_end_fiscal_year
                                  ORDER BY item_date)
                        LOOP
                            -- add the total amount received.
                            v_total_accountability := v_total_accountability + NVL(t.amount, 0);
                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || t.description || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.item_date, 'dd-Mon-yyyy') || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font color="red" face="Arial" size="2">('
                                              || TO_CHAR(t.amount, v_dollar_format) || ')</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END LOOP;
        
                        IF v_total_accountability = 0 THEN
                            htp.tableRowOpen;
                                htp.print
                                    ('<td colspan = "3"><font face="Arial" size="2">No transfers found</font></td>');
                            htp.tableRowClose;
                        END IF;
        
                        v_total_1a := v_total_1a - v_total_accountability;
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'FUNDS_SENT',
                                                         TO_CHAR(v_total_accountability, v_dollar_format));
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'TOTAL_1A',
                                                         TO_CHAR(v_total_1a, v_dollar_format));
                    -- Part I B ---------------------
                    ELSIF v_tag = 'SUBORDINATE_UNITS_LIST' THEN
                        -- Accountability of Subordinate Units
                        v_total_accountability := 0;
                        v_subordinate_unit_exists := 'false';
        
                        -- only show active C-Funds Units that are subordinate.
                        FOR u IN (SELECT   u.SID,
                                           Osi_Unit.get_name(u.SID)
                                           || '''s Accountability' AS detachment_name
                                      FROM T_OSI_UNIT u, T_CFUNDS_UNIT cfu
                                     WHERE Get_Accountable_Parent(u.SID) = v_unit
                                       AND u.active = 'Y'
                                       AND cfu.active = 'Y'
                                       AND u.SID = cfu.SID
                                  ORDER BY u.unit_code)
                        LOOP
                            -- add the total amount received.
        
                            -- ***     v_subordinate_total := Cfunds_Pkg.Get_Unit_Accountability( u.SID );
                            v_subordinate_total := Cfunds_Pkg.get_unit_accountability(u.SID);
                            v_total_accountability := v_total_accountability + NVL(v_subordinate_total, 0);
                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || u.detachment_name || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(v_subordinate_total, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                            v_subordinate_unit_exists := 'true';
                        END LOOP;
        
                        IF v_subordinate_unit_exists = 'false' THEN
                            htp.tableRowOpen;
                                htp.print
                                    ('<td colspan = "4"><font face="Arial" size="2">No Subordinate Units found</font></td>');
                            htp.tableRowClose;
                        END IF;
        
                        v_total_1b := v_total_accountability;
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'SUBORDINATE_UNITS_TOTAL',
                                                         TO_CHAR(v_total_accountability, v_dollar_format));
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'TOTAL_IB',
                                                         TO_CHAR(v_total_1b, v_dollar_format));
                    -- Part I C ---------------------
                    ELSIF v_tag = 'FUNDS_SENT_LIST_2' THEN
                        -- These are "Sent outgoing working fund transfers".  They haven't been received
                        -- at the receiving unit yet, and they were sent out by this unit, v_unit.
                        -- This section will not be seen by auditors on the Audit from, because
                        -- technically the accountability shouldn't change until these are received.
                        IF v_usage = 'cc' THEN
                            -- for an audit form, we don't use section C at all.
                            v_total_accountability := 0;
        
                            FOR t IN (SELECT   voucher_no || ' to ' || receiver_name AS description,
                                               amount, send_date AS item_date
                                          FROM v_cfunds_xfr
                                         WHERE sender = v_unit
                                           AND receiver <> v_unit
                                           AND send_date IS NOT NULL
                                           AND receive_date IS NULL
                                           AND xfr_type = 'WF'
                                           AND send_date < v_end_fiscal_year
                                      --BETWEEN v_start_fiscal_year AND v_end_fiscal_year
                                      ORDER BY item_date)
                            LOOP
                                -- add the total amount received.
                                v_total_accountability := v_total_accountability + NVL(t.amount, 0);
                                htp.tableRowOpen;
                                    htp.tabledata('<font face="Arial" size="2">' || t.description || '</font>');
                                    htp.tabledata('<font face="Arial" size="2">'
                                                  || TO_CHAR(t.item_date, 'dd-Mon-yyyy') || '</font>',
                                                  NULL,
                                                  NULL,
                                                  'nowrap');
                                    htp.tabledata('<font color="red" face="Arial" size="2">('
                                                  || TO_CHAR(t.amount, v_dollar_format) || ')</font>',
                                                  'right',
                                                  NULL,
                                                  'nowrap');
                                htp.tableRowClose;
                            END LOOP;
        
                            IF v_total_accountability = 0 THEN
                                htp.tableRowOpen;
                                    htp.print
                                        ('<td colspan = "3"><font face="Arial" size="2">No transfers found</font></td>');
                                htp.tableRowClose;
                            END IF;
        
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'FUNDS_SENT_2',
                                                             TO_CHAR(v_total_accountability,
                                                                     v_dollar_format));
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'TOTAL_ACCOUNTABLE_FUNDS',
                                                             TO_CHAR(v_total_1a + v_total_1b,
                                                                     v_dollar_format));
                        --removed - v_total_accountability
                        ELSE
                            -- the audit form still shows the total, but section C isn't included in that calcuation.
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'TOTAL_ACCOUNTABLE_FUNDS',
                                                             TO_CHAR(v_total_1a + v_total_1b,
                                                                     v_dollar_format));
                        END IF;
                    -- Part II B -- Section 1 ---------------------
                    ELSIF v_tag = 'SUBORDINATE_UNITS_LIST_2' THEN
                        -- Working Fund Transfers to Subordinate Units
                        v_total_accountability := 0;
                        v_subordinate_unit_exists := 'false';
        
                        -- only show active C-Funds Units that are subordinate.
                        FOR u IN (SELECT   u.SID,
                                           Osi_Unit.get_name(u.SID)
                                           || '''s Accountability' AS detachment_name
                                      FROM T_OSI_UNIT u, T_CFUNDS_UNIT cfu
                                     WHERE Get_Accountable_Parent(u.SID) = v_unit
                                       AND u.active = 'Y'
                                       AND cfu.active = 'Y'
                                       AND u.SID = cfu.SID
                                  ORDER BY u.unit_code)
                        LOOP
                            -- add the total amount received.
        
                            --***               v_subordinate_total := Cfunds_Pkg.Get_Unit_Accountability(u.SID);
                            v_subordinate_total := Cfunds_Pkg.get_unit_accountability(u.SID);
                            v_total_accountability := v_total_accountability + NVL(v_subordinate_total, 0);
                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || u.detachment_name || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(v_subordinate_total, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                            v_subordinate_unit_exists := 'true';
                        END LOOP;
                        
                        FOR u IN (SELECT  receiver_name || '''s Pending Adjustment #' || voucher_no AS detachment_name,
                                               amount
                                          FROM v_cfunds_xfr
                                         WHERE sender = v_unit
                                           AND receiver <> v_unit
                                           AND send_date IS NOT NULL
                                           AND receive_date IS NULL
                                           AND xfr_type = 'WF'
                                           AND send_date < v_end_fiscal_year
                                      --BETWEEN v_start_fiscal_year AND v_end_fiscal_year
                                      ORDER BY receiver_name)
                        LOOP
                                v_total_accountability := v_total_accountability + NVL(u.amount, 0);
                                htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || u.detachment_name || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(u.amount, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                            v_subordinate_unit_exists := 'true';
                        END LOOP;

                        IF v_subordinate_unit_exists = 'false' THEN
                            htp.tableRowOpen;
                                htp.print
                                    ('<td colspan = "4"><font face="Arial" size="2">No subordinate units with accountabilities found</font></td>');
                            htp.tableRowClose;
                        END IF;
        
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'SUBORDINATE_UNITS_TOTAL_2',
                                                         TO_CHAR(v_total_accountability, v_dollar_format));
                        v_total_2b_a := v_total_accountability;
                    -- Part II B -- Section 2 ---------------------
                    ELSIF v_tag = 'UNRECEIVED_DERS_LIST' THEN
                                 -- Sent Disallowed Expense Repayments
                                 -- this section is strange; I'm not sure I remember why it is here.
                                 -- I think it is for the lowest units to see DERs that have not been received yet.
                                 -- I didn't have enough data to test thouroughly.
                        -- Now also shows Recieved DERs if they were created previous year.
                        v_outstanding_amount := 0;
        
                        FOR t IN (SELECT   'EOY ' || voucher_no || ' to ' || receiver_name AS description,
                                           voucher_no, send_date,
                                           DECODE(receiver, v_unit, -1 * amount, amount) AS amount,
                                           xfr_type_desc, receiver_name, status
                                      FROM v_cfunds_xfr
                                     WHERE (    sender = v_unit
                                            AND 
                                                --SEND_DATE > v_since_date AND
                                                (   (receive_date IS NULL
                                                     AND send_date < v_start_fiscal_year)
                                                 OR (    create_on < v_start_fiscal_year
                                                     AND receive_date > v_start_fiscal_year))
                                            AND
                                                --added SEND_DATE < v_start_fiscal_year, but not sure if this is even needed.
                                                xfr_type = 'DER')
                                   --or -- Below half is new because FIS24 - X060053619 $40. xfer from FIS24 now gone, but caused a problem with FIR 6 X070073418 $20
                                  --(RECEIVER = v_unit AND
                                                  --(CREATE_ON < v_start_fiscal_year and RECEIVE_DATE > v_start_fiscal_year) AND
                                                  --XFR_TYPE ='DER')
                                  ORDER BY send_date)
                        LOOP
                            -- calculate the outstanding amounts for transfers.
                            v_outstanding_amount := v_outstanding_amount + NVL(t.amount, 0);
                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || t.description || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.send_date, 'dd-Mon-yyyy') || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.amount, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END LOOP;
        
                        IF v_outstanding_amount = 0 THEN
                            htp.tableRowOpen;
                                htp.print
                                    ('<td colspan = "3"><font face="Arial" size="2">No Disallowed Expense Repayments found</font></td>');
                            htp.tableRowClose;
                        END IF;
        
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'TOTAL_UNRECEIVED_DERS',
                                                         TO_CHAR(v_outstanding_amount, v_dollar_format));
                        v_total_2b_d := v_outstanding_amount;
                    -- Part II B -- Section 3 ---------------------
                    ELSIF v_tag = 'LOCAL_EXPENSES_LIST' THEN
                        -- Local Expenses (outstanding)
                        v_outstanding_amount := 0;
        
                        FOR t IN
                            (SELECT   recipient, voucher_no, item_date, amount
                                 FROM ((SELECT claimant_name AS recipient, voucher_no,
                                               incurred_date AS item_date,
                                               NVL(paid_cash_amount, 0)
                                               + NVL(paid_check_amount, 0)
                                               + NVL(advance_amount, 0) AS amount
                                          FROM v_cfunds_expense_v3 ce
                                         WHERE paid_on IS NOT NULL
                                           AND repaid_on IS NULL
                                           AND (charge_to_unit = v_unit)
                                           AND
                                                                /* or (GET_ACCOUNTABLE_PARENT(charge_to_unit) = v_unit and v_unit <> '1010005M' AND
                                               EXISTS (select 'x' from T_CFUNDS_XFR x, T_CFUNDS_XFR_EXP e where e.XFR = x.sid and x.SENDER = '1010005M' AND
                                               x.RECEIVER = v_unit AND CE.SID = e.EXPENSE AND x.RECEIVE_DATE IS NOT NULL))) AND*/
                                               SID NOT IN(     -- This expense is not on a paid transfer yet
                                                   SELECT xe.expense
                                                     FROM T_CFUNDS_XFR x, T_CFUNDS_XFR_EXP xe
                                                    WHERE xe.xfr = x.SID
                                                      AND                    -- the expense is on a transfer
                                                          x.receiver = ce.charge_to_unit
                                                      AND
                                                          -- the unit that paid the expense has gotten the money back
                                                          x.receive_date IS NOT NULL))
                                       UNION ALL
                                       (SELECT 'EOY '
                                               || DECODE(charge_to_unit,
                                                         v_unit, claimant_name,
                                                         'Expense for ' || charge_to_unit_name)
                                                                                               AS recipient,
                                               voucher_no, paid_on AS item_date,
                                               NVL(paid_cash_amount, 0)
                                               + NVL(paid_check_amount, 0)
                                               + NVL(advance_amount, 0) AS amount
                                          FROM v_cfunds_expense_v3 ce
                                         WHERE paid_on IS NOT NULL
                                           AND incurred_date < v_start_fiscal_year
                                           AND repaid_on IS NULL
                                           AND (   charge_to_unit = v_unit
                                                OR (    Get_Accountable_Parent(charge_to_unit) = v_unit
                                                    AND v_unit <> v_hq_cc_unit_sid--'1010005M'
                                                    AND EXISTS(
                                                            SELECT 'x'
                                                              FROM T_CFUNDS_XFR x, T_CFUNDS_XFR_EXP e
                                                             WHERE e.xfr = x.SID
                                                               AND x.sender = v_hq_cc_unit_sid--'1010005M'
                                                               AND x.receiver = v_unit
                                                               AND ce.SID = e.expense
                                                               AND x.receive_date IS NOT NULL))))
                                       UNION ALL
                                       (SELECT 'EOY Repaid Expense' AS recipient, voucher_no,
                                               repaid_on AS item_date,
                                               -1
                                               *(NVL(paid_cash_amount, 0) + NVL(paid_check_amount, 0)
                                                 + NVL(advance_amount, 0)) AS amount
                                          --Dont use repaid amounts because the repaid advance amount is not stored in this record. Assume full amount paid is repaid.
                                        FROM   v_cfunds_expense_v3
                                         WHERE paid_on IS NOT NULL
                                           AND paid_on < v_start_fiscal_year
                                           AND (   charge_to_unit = v_unit
                                                OR Get_Accountable_Parent(charge_to_unit) = v_unit))
                                       UNION ALL
                                       (SELECT 'EOY Outstanding Expenses for '
                                               || receiver_name AS recipient,
                                               voucher_no, receive_date AS item_date,
                                               DECODE(receiver, v_unit, -1 * amount, amount) AS amount
                                          FROM v_cfunds_xfr
                                         WHERE (   receiver = v_unit
                                                OR (sender = v_unit AND sender = v_hq_cc_unit_sid))--'1010005M'))
                                           AND xfr_type = 'OE')
                                       UNION ALL
                                       (SELECT 'Payment listing for EOY Expenses '
                                               || receiver_name AS recipient,
                                               voucher_no, receive_date AS item_date,
                                               DECODE(receiver, v_unit, -1 * amount, amount) AS amount
                                          FROM v_cfunds_xfr
                                         WHERE (   (receiver = v_unit)
                                                OR (sender = v_unit AND v_unit = v_fis24_unit_sid))--'10100023'))
                                           AND                                           --special exception
                                               xfr_type = 'ER'
                                           AND fiscal_year < TO_CHAR(v_end_fiscal_year, 'YYYY')
                                                                                               --Some may be from 2 years ago!
                                       )
                                       UNION ALL
                                       (SELECT 'Returned Payment for EOY Expenses '
                                               || receiver_name AS recipient,
                                               voucher_no, receive_date AS item_date,
                                               DECODE(receiver, v_unit, -1 * amount, amount) AS amount
                                          FROM v_cfunds_xfr
                                         WHERE ((sender = v_unit))
                                           AND xfr_type = 'DER'
                                           AND fiscal_year < TO_CHAR(v_end_fiscal_year, 'YYYY')
                                                                                               --Some may be from 2 years ago!
                                       )
                                       UNION ALL
            /*  JDB - 10/1/10 - Commented this portion out. It was placing sent but not recieved payment listings in the region's audit. However this money is still on the regions books so we can't subtract it yet. Most apparent at the beginning of the FY 
                                       (SELECT 'Payment listing for EOY Expenses '
                                               || receiver_name AS recipient,
                                               voucher_no, v_start_fiscal_year AS item_date,
                                               -1 * amount AS amount
                                          FROM v_cfunds_xfr
                                         WHERE (Get_Accountable_Parent(receiver) = v_unit)
                                           AND v_unit <> v_hq_cc_unit_sid--'1010005M'
                                           AND sender = v_unit
                                           AND xfr_type = 'ER'
                                           AND send_date < v_start_fiscal_year
                                           AND receive_date IS NULL
                                                                   --Some may be from 2 years ago!
                                       )
                                       UNION ALL*/
                                       (SELECT 'EOY Expenses for Sub-Units not paid down' AS recipient,
                                               'Pending' AS voucher_no, v_start_fiscal_year AS item_date,
                                               -1 * SUM(e.total_amount_us) AS amount
                                          FROM v_cfunds_expense_v3 e
                                         WHERE TRUNC(e.incurred_date) < v_start_fiscal_year
                                           AND e.status = 'Paid'
                                           AND e.reviewing_unit = v_unit)
                                       UNION ALL
                                       (SELECT 'EOY Rejected Expense for '
                                               || e.charge_to_unit_name AS recipient,
                                               voucher_no, v_start_fiscal_year AS item_date,
                                               -1 * e.total_amount_us AS amount
                                          FROM v_cfunds_expense_v3 e
                                         WHERE TRUNC(e.incurred_date) < v_start_fiscal_year
                                           AND invalidated_on IS NOT NULL
                                           AND repaid_on IS NULL
                                           AND e.reviewing_unit = v_unit AND 
         NOT EXISTS (SELECT 'x' FROM T_CFUNDS_XFR x1, T_CFUNDS_XFR_EXP e1 WHERE e1.XFR = x1.SID AND
                  e.SID = e1.EXPENSE) --10/1/10 JDB Make sure the expense isn't already on a paylisting. (This mostly affects unit rejections from showing on HQ)
          ))
                                WHERE item_date BETWEEN v_start_fiscal_year AND v_end_fiscal_year
                             ORDER BY item_date)
                        LOOP
                            -- calculate the outstanding amounts for expenses.
                            v_outstanding_amount := v_outstanding_amount + NVL(t.amount, 0);
                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || t.recipient || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" size="2">' || t.voucher_no || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.item_date, 'dd-Mon-yyyy') || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.amount, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END LOOP;
        
                        IF v_outstanding_amount = 0 THEN
                            htp.tableRowOpen;
                                htp.print
                                    ('<td colspan = "4"><font face="Arial" size="2">No expenses found</font></td>');
                            htp.tableRowClose;
                        END IF;
        
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'TOTAL_LOCAL_EXPENSES',
                                                         TO_CHAR(v_outstanding_amount, v_dollar_format));
                        v_total_2b_b := v_outstanding_amount;
                    -- Part II B -- Section 4 ---------------------
                    ELSIF v_tag = 'LOCAL_ADVANCES_LIST' THEN
                        -- Local Advances (Outstanding)
                        v_outstanding_amount := 0;
        
                        FOR t IN (SELECT   recipient, voucher_no, item_date, amount
                                      FROM ((SELECT claimant_name AS recipient, voucher_no,
                                                    request_date AS item_date,
                                                    NVL(amount_requested, 0)
                                                    - NVL(expensed_amount, 0)
                                                    - Cfunds_Pkg.get_advance_total_repayments
                                                                                             (SID)
                                                                                                  AS amount
                                               FROM v_cfunds_advance_v2
                                              WHERE status = 'Active' AND unit = v_unit)
                                            UNION ALL
                                            (SELECT 'EOY Outstanding Advances for '
                                                    || receiver_name AS recipient,
                                                    voucher_no, receive_date AS item_date, 0 AS amount
                                               --Decode(RECEIVER, v_unit, -1 * amount, amount) AS AMOUNT
                                             FROM   v_cfunds_xfr
                                              WHERE (receiver = v_unit) AND       -- or SENDER = v_unit) AND
                                                                           xfr_type = 'OA')
                                            UNION ALL
                                            (SELECT '  EOY ' || claimant_name AS recipient, voucher_no,
                                                    v_start_fiscal_year AS item_date,
                                                    NVL(amount_requested, 0)
                                                    - NVL(expensed_amount, 0)
                                                    - Cfunds_Pkg.get_advance_total_repayments
                                                                                             (SID)
                                                                                                  AS amount
                                               FROM v_cfunds_advance_v2
                                              WHERE issue_on < v_start_fiscal_year
                                                AND status = 'Active'
                                                AND (unit = v_unit)
                                                                   --  or GET_ACCOUNTABLE_PARENT(unit) = v_unit)
                                            ))
                                     WHERE item_date BETWEEN v_start_fiscal_year AND v_end_fiscal_year
                                  ORDER BY item_date)
                        LOOP
                            -- calculate the outstanding amounts for advances.
                            v_outstanding_amount := v_outstanding_amount + NVL(t.amount, 0);
                            htp.tableRowOpen;
                                htp.tabledata('<font face="Arial" size="2">' || t.recipient || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" size="2">' || t.voucher_no || '</font>');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.item_date, 'dd-Mon-yyyy') || '</font>',
                                              NULL,
                                              NULL,
                                              'nowrap');
                                htp.tabledata('<font face="Arial" size="2">'
                                              || TO_CHAR(t.amount, v_dollar_format) || '</font>',
                                              'right',
                                              NULL,
                                              'nowrap');
                            htp.tableRowClose;
                        END LOOP;
        
                        IF v_outstanding_amount = 0 THEN
                            htp.tableRowOpen;
                                htp.print
                                    ('<td colspan = "4"><font face="Arial" size="2">No advances found</font></td>');
                            htp.tableRowClose;
                        END IF;
        
                        v_ok :=
                            Web_Template_Pkg.replace_tag(v_template,
                                                         'TOTAL_LOCAL_ADVANCES',
                                                         TO_CHAR(v_outstanding_amount, v_dollar_format));
                        v_total_2b_c := v_outstanding_amount;
                        -- this tag is actually in the next section, but we replace it here because
                        -- it is too late by the time the next section is started.
                        v_ok :=
                            Web_Template_Pkg.replace_tag
                                (v_template,
                                 'PARENT',
                                 Cfunds_Pkg.lookup_cfunds_unit(Cfunds_Pkg.get_parent_unit(v_unit)).unit_name);
                    -- Part II B -- Section 5 ---------------------
                    ELSIF v_tag = 'OUTSTANDING_LIST' THEN
                        -- Outstanding Payment Listings
                        -- expenses that are paid_down, but not paid_up.
                        BEGIN
                            v_outstanding_amount := 0;
        
                            -- see if this unit is at the top of the unit hierarchy
                            -- do not show this section for the top unit (usually HQ).
                            IF v_top_dog = 'true' THEN
                                --I am at the top!'
                                -- these tags are at the bottom of the html template in a script.
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_REPLACEMENT_1',
                                                                 'Outstanding_List.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_REPLACEMENT_2',
                                                                 'Total_Outstanding.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_REPLACEMENT_3',
                                                                 'Total_Outstanding_Amt.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_REPLACEMENT_4',
                                                                 'Total_Outstanding_Title.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_REPLACEMENT_5',
                                                                 'Total_Outstanding_Msg.innerHTML=" "');
                                RAISE a_stink;
                            END IF;
        
                            v_new_transfer := 'none';
        
                            -- this should only happen for units who are reviewing units.
                            -- if this is not a reviewing unit, do not show this section at all.
                            FOR u IN (SELECT reviewing_unit
                                        FROM T_CFUNDS_UNIT
                                       WHERE SID = v_unit AND(   reviewing_unit = 'Y'
                                                              OR v_unit = v_fis24_unit_sid))--'10100023'))
                            LOOP
                                -- replace these tags so this section doesn't get hidden.
                                v_ok :=
                                     Web_Template_Pkg.replace_tag(v_template, 'SECTION_REPLACEMENT_1', ' ');
                                v_ok :=
                                     Web_Template_Pkg.replace_tag(v_template, 'SECTION_REPLACEMENT_2', ' ');
                                v_ok :=
                                     Web_Template_Pkg.replace_tag(v_template, 'SECTION_REPLACEMENT_3', ' ');
                                v_ok :=
                                     Web_Template_Pkg.replace_tag(v_template, 'SECTION_REPLACEMENT_4', ' ');
                                v_ok :=
                                     Web_Template_Pkg.replace_tag(v_template, 'SECTION_REPLACEMENT_5', ' ');
        
                                -- select all expenses that are on transfers my unit has sent.
                                -- this finds all expenses that are paid down
                                FOR t IN (SELECT   et.expense, et.xfr, et.SID, EXP.claimant_name,
                                                   EXP.voucher_no AS exp_voucher_no,
                                                   DECODE(send_date,
                                                          NULL, -1 * EXP.total_amount_us,
                                                          EXP.total_amount_us) AS total_amount_us,
                                                   EXP.charge_to_unit, EXP.status, EXP.paid_cash_amount,
                                                   EXP.paid_check_amount, EXP.advance_amount,
                                                   t.receiver_name, t.amount, t.voucher_no, t.receive_date,
                                                   t.send_date, t.fiscal_year
                                              FROM T_CFUNDS_XFR_EXP et,
                                                   v_cfunds_expense_v3 EXP,
                                                   v_cfunds_xfr t
                                             WHERE et.xfr = t.SID
                                               AND et.expense = EXP.SID
                                               AND t.xfr_type = 'ER'
                                               AND t.sender = v_unit
                                               AND (  ( ( t.send_date is null or t.send_date > v_start_fiscal_year) and  t.receive_date IS NULL
                                                        AND t.fiscal_year <
                                                                          TO_CHAR(v_end_fiscal_year, 'YYYY'))
                                                    OR (    t.send_date IS NOT NULL
                                                        AND t.fiscal_year =
                                                                          TO_CHAR(v_end_fiscal_year, 'YYYY')))
                                          --Some may be from 2 years ago! = v_fiscal_year
                                          ORDER BY t.receiver_name)
                                LOOP
                                    -- for each expense, look to see if this expense was paid by the parent unit.
                                    v_is_paid_down :=
                                        Cfunds_Pkg.is_expense_paid_down(t.expense,
                                                                        Get_Accountable_Parent(v_unit));
        
                                    -- if this expense has not been paid by the parent unit, then we need to
                                    -- show it because we need to consider this money (since we've already given
                                    -- the money away to subordinate units for this expense).
                                    IF    v_is_paid_down <> 'Y'
                                       OR (    t.receive_date IS NULL
                                           AND t.fiscal_year < TO_CHAR(v_end_fiscal_year, 'YYYY')) THEN
                                        v_repaid_msg := '';
                                        v_repaid_exp_sid := 'NA';
        
                                        -- special processing for Repaid expenses to see if they should be included or not.
                                        IF t.status = 'Repaid' THEN
                                            -- look for DER XFRs that have been received at this unit
                                            -- and that pay back this expense.  If found, then don't include this expense.
                                            -- (This situation means that this repaid expense is "finished" with processing).
                                            v_repaid_exp_sid := 'none';
        
                                            FOR expense IN (SELECT et.expense
                                                              FROM T_CFUNDS_XFR_EXP et,
                                                                   v_cfunds_expense_v3 EXP,
                                                                   v_cfunds_xfr xfr
                                                             WHERE et.xfr = xfr.SID
                                                               AND et.expense = EXP.SID
                                                               AND EXP.SID = t.expense
                                                               AND xfr.xfr_type = 'DER'
                                                               AND xfr.receiver = v_unit
                                                               AND (( xfr.receive_date IS NOT NULL
                                                               AND t.send_date is not null )
                                                               OR (xfr.receive_date is null and t.send_date is null ) ))
                                            -- fiscal year is already filtered out in the outer loop for this query
                                            LOOP
                                                -- if we find something, just save the SID to indicate that it was found.
                                                v_repaid_exp_sid := expense.expense;
                                            END LOOP;
        
                                            IF v_repaid_exp_sid = 'none' THEN
                                                -- if we didn't find a DER that has cancelled out this expense,
                                                -- then we will show this message.
                                                v_repaid_msg := ' * Expense was Repaid';
                                            END IF;
                                        END IF;
        
                                        IF    v_repaid_exp_sid = 'NA'
                                           OR v_repaid_msg = ' * Expense was Repaid' THEN
                                            -- if this expense is not Repaid, then print out the following info.
                                            -- OR....
                                            -- if this expense is Repaid and we went through the loop above and
                                            -- did not find any DERs that finished up the processing, then print out info.
                                            IF v_new_transfer <> t.voucher_no THEN
                                                -- the first time, print out the details of the transfer.
                                                htp.tableRowOpen;
                                                    htp.print
                                                        ('<td colspan="4" nowrap><font face="Arial" size="2">To '
                                                         || t.receiver_name || '; ID: ' || t.voucher_no
                                                         || '. Sent on ' || TO_CHAR(t.send_date, 'dd-Mon-yyyy')
                                                         || '. Total ' || TO_CHAR(t.amount, v_dollar_format)
                                                         || '</font></td>');
                                                htp.tableRowClose;
                                                v_new_transfer := t.voucher_no;
                                            -- flag to indicate this info has been shown.
                                            END IF;
        
                                            -- calculate the outstanding amount for expenses that need to be shown.
                                            -- (note that not all expenses on a transfer will show in this section,
                                            -- so the total amount of the transfer will not always be used).
                                            v_outstanding_amount :=
                                                            v_outstanding_amount + NVL(t.total_amount_us, 0);
                                            htp.tableRowOpen;
                                                -- show the details and amount of the expense that is found to be outstanding.
                                                htp.tabledata('<font face="Arial" size="2"></font>');
                                                htp.print
                                                         ('<td nowrap><font face="Arial" size="2"> Expense: '
                                                          || t.exp_voucher_no || v_repaid_msg || '</font></td>');
                                                htp.tabledata('<font face="Arial" size="2">'
                                                              || TO_CHAR(NVL(t.total_amount_us, 0),
                                                                         v_dollar_format)
                                                              || '</font>',
                                                              'right',
                                                              NULL,
                                                              'nowrap');
                                            htp.tableRowClose;
                                        END IF;
                                    END IF;
                                END LOOP;
        
                                RAISE a_stink;
                            END LOOP;
        
                            -- if these tags weren't replaced before, replace them here.
                            -- this will hide this section if the current unit isn't a reviewing unit.
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_REPLACEMENT_1',
                                                             'Outstanding_List.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_REPLACEMENT_2',
                                                             'Total_Outstanding.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_REPLACEMENT_3',
                                                             'Total_Outstanding_Amt.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_REPLACEMENT_4',
                                                             'Total_Outstanding_Title.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_REPLACEMENT_5',
                                                             'Total_Outstanding_Msg.innerHTML=" "');
                            RAISE a_stink;
                        EXCEPTION
                            WHEN a_stink THEN
                                -- This is the ending logic for this section, it should always run.
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'TOTAL_OUTSTANDING_PAYMENT_LISTINGS',
                                                                 TO_CHAR(v_outstanding_amount,
                                                                         v_dollar_format));
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'TOTAL_OUTSTANDING',
                                                                 TO_CHAR(v_outstanding_amount + v_total_2b_a
                                                                         + v_total_2b_b + v_total_2b_c
                                                                         + v_total_2b_d + v_total_2b_e,
                                                                         v_dollar_format));
                        END;
                    -- Part II C ---------------------
                    ELSIF v_tag = 'OUTSTANDING_LIST_2' THEN
                        --Payment Listings Received (but not paid to subordinate units).
                        -- expenses that are paid_up but NOT paid_down.
                        BEGIN
                            v_total_2c := 0;
                            v_new_transfer := 'none';
                                             -- used to hold the transfer so we can show details of the transfer
                            -- above the expenses that were paid on that transfer.
                            v_subtotal_2c := 0;
        
                            -- see if this unit is at the top of the unit hierarchy
                            -- do not show this section for the top unit (usually HQ).
                            IF v_top_dog = 'true' THEN
                                --I am at the top!'
                                -- these tags are at the bottom of the html template in a script.
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_2_REPLACEMENT_1',
                                                                 'Outstanding_List_2.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_2_REPLACEMENT_2',
                                                                 'Total_Outstanding_2.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_2_REPLACEMENT_3',
                                                                 'Total_Outstanding_2_Amt.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_2_REPLACEMENT_4',
                                                                 'Total_Outstanding_2_Title1.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_2_REPLACEMENT_5',
                                                                 'Total_Outstanding_2_Title2.innerHTML=" "');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'SECTION_2_REPLACEMENT_6',
                                                                 'Total_Outstanding_2_Title3.innerHTML=" "');
                                RAISE a_stink;
                            END IF;
        
                            -- this should only happen for units who are reviewing units. (EG, mostly Regions).
                            FOR u IN (SELECT reviewing_unit
                                        FROM T_CFUNDS_UNIT
                                       WHERE SID = v_unit AND reviewing_unit = 'Y')
                            LOOP
                                -- replace these tags so this section doesn't get hidden.
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template, 'SECTION_2_REPLACEMENT_1',
                                                                 ' ');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template, 'SECTION_2_REPLACEMENT_2',
                                                                 ' ');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template, 'SECTION_2_REPLACEMENT_3',
                                                                 ' ');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template, 'SECTION_2_REPLACEMENT_4',
                                                                 ' ');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template, 'SECTION_2_REPLACEMENT_5',
                                                                 ' ');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template, 'SECTION_2_REPLACEMENT_6',
                                                                 ' ');
        
                                -- select all expenses that are on transfers my unit has received.
                                -- (These are all the expenses that have been "paid_up".).
                                FOR t IN (SELECT   SID AS expense, voucher_no AS exp_voucher_no,
                                                   -1 * total_amount_us AS total_amount_us, charge_to_unit,
                                                   'Not Sent' AS voucher_no,
                                                   v_start_fiscal_year AS receive_date,
                                                   charge_to_unit_name AS sender_name,
                                                   charge_to_unit_name AS receiver_name
                                              FROM v_cfunds_expense_v3 EXP
                                             WHERE EXISTS(
                                                       SELECT 'x'
                                                         FROM T_CFUNDS_XFR_EXP cxe2, T_CFUNDS_XFR cx2
                                                        WHERE EXP.SID = cxe2.expense
                                                          AND cxe2.xfr = cx2.SID
                                                          AND cx2.receiver = v_unit
                                                          AND cx2.receive_date IS NOT NULL)
                                               AND NOT EXISTS(
                                                       SELECT 'x'
                                                         FROM T_CFUNDS_XFR_EXP t, T_CFUNDS_XFR x
                                                        WHERE EXP.SID = t.expense
                                                          AND t.xfr = x.SID
                                                          AND x.sender = v_unit
                                                          AND x.send_date IS NOT NULL)
                                               AND EXP.paid_on IS NOT NULL
                                               AND EXP.repaid_on IS NULL
                                               AND
                                                   --EXP.STATUS <> 'Rejected' and
                                                   Get_Accountable_Parent(charge_to_unit) = v_unit
                                          ORDER BY receiver_name)
                                LOOP
                                    -- first check to see if this expense belongs to my unit or to a subordinate unit.
                                    -- (we do not include expenses that belong to my unit).
                                    IF t.charge_to_unit <> v_unit THEN
                                        -- for each expense, look to see if this expense was paid to the subordinate unit.
                                        v_is_paid_down :=
                                                         Cfunds_Pkg.is_expense_paid_down(t.expense, v_unit);
        
                                        IF v_is_paid_down <> 'Y' THEN
                                            -- the first time, print out the details of the transfer.
                                            IF v_new_transfer <> t.receiver_name THEN
                                                IF v_new_transfer <> 'none' THEN
                                                    --New_Transfer has the name of the last processed unit in it still.
                                                    htp.tableRowOpen;
                                                        htp.tabledata('<font face="Arial" size="2"></font>');
                                                        htp.print
                                                            ('<td nowrap><font face="Arial" size="2"><b> Subtotal of pending payment listings to : '
                                                             || v_new_transfer || '</b></font></td>');
                                                        htp.tabledata('<font face="Arial" size="2"><b>'
                                                                      || TO_CHAR(NVL(v_subtotal_2c, 0),
                                                                                 v_dollar_format)
                                                                      || '</b></font>',
                                                                      'right',
                                                                      NULL,
                                                                      'nowrap');
                                                    htp.tableRowClose;
                                                END IF;
        
                                                v_subtotal_2c := 0;                     --reset the subtotal
                                                htp.tableRowOpen;
                                                    htp.print
                                                        ('<td colspan="4" nowrap><font face="Arial" size="2">From '
                                                         || t.sender_name || '; ID: ' || t.voucher_no || '.'
                                                         || '</font></td>');    --; Total: [WEBTOK@LASTSUBTOTAL]
                                                htp.tableRowClose;
                                                v_new_transfer := t.receiver_name;
                                            END IF;
        
                                            -- calculate the outstanding amounts for advances and expenses.
                                            -- if the expense is marked TakeFromOtherSources, we need to use the total amount of the expense.
                                            -- otherwise, use the totals that were paid to the agent.
                                            v_total_2c := v_total_2c + NVL(t.total_amount_us, 0);
                                            v_subtotal_2c := v_subtotal_2c + NVL(t.total_amount_us, 0);
                                            htp.tableRowOpen;
                                                htp.tabledata('<font face="Arial" size="2"></font>');
                                                htp.print
                                                         ('<td nowrap><font face="Arial" size="2"> Expense: '
                                                          || t.exp_voucher_no || '</font></td>');
                                                htp.tabledata('<font face="Arial" size="2">'
                                                              || TO_CHAR(NVL(t.total_amount_us, 0),
                                                                         v_dollar_format)
                                                              || '</font>',
                                                              'right',
                                                              NULL,
                                                              'nowrap');
                                            htp.tableRowClose;
                                        END IF;
                                    END IF;
                                END LOOP;
        
                                IF v_new_transfer <> 'none' THEN
                                    --New_Transfer has the name of the last processed unit in it still.
                                    htp.tableRowOpen;
                                        htp.tabledata('<font face="Arial" size="2"></font>');
                                        htp.print
                                            ('<td nowrap><font face="Arial" size="2"><b> Subtotal of pending payment listings to : '
                                             || v_new_transfer || '</b></font></td>');
                                        htp.tabledata('<font face="Arial" size="2"><b>'
                                                      || TO_CHAR(NVL(v_subtotal_2c, 0), v_dollar_format)
                                                      || '</b></font>',
                                                      'right',
                                                      NULL,
                                                      'nowrap');
                                    htp.tableRowClose;
                                END IF;
        
                                RAISE a_stink;
                            END LOOP;
        
                            -- if these tags weren't replaced before, replace them here.
                            -- this will hide this section if the current unit isn't a reviewing unit.
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_2_REPLACEMENT_1',
                                                             'Outstanding_List_2.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_2_REPLACEMENT_2',
                                                             'Total_Outstanding_2.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_2_REPLACEMENT_3',
                                                             'Total_Outstanding_2_Amt.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_2_REPLACEMENT_4',
                                                             'Total_Outstanding_2_Title1.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_2_REPLACEMENT_5',
                                                             'Total_Outstanding_2_Title2.innerHTML=" "');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'SECTION_2_REPLACEMENT_6',
                                                             'Total_Outstanding_2_Title3.innerHTML=" "');
                            RAISE a_stink;
                        EXCEPTION
                            WHEN a_stink THEN
                                -- This is the ending logic for this section, it should always run.
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'TOTAL_OUTSTANDING_2',
                                                                 TO_CHAR(v_total_2c, v_dollar_format));
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'TOTAL_ACCOUNTED_FOR',
                                                                 TO_CHAR(v_outstanding_amount + v_total_2b_a
                                                                         + v_total_2b_b + v_total_2b_c
                                                                         + v_total_2b_d + v_total_2b_e
                                                                         + v_total_2a,
                                                                         v_dollar_format));
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'TOTAL_RESPONSIBLE_FOR',
                                                                 TO_CHAR(v_outstanding_amount + v_total_2b_a
                                                                         + v_total_2b_b + v_total_2b_c
                                                                         + v_total_2b_d + v_total_2b_e
                                                                         + v_total_2a,
                                                                         v_dollar_format));
                        END;
                    ELSE
                        htp.print('[WEBTOK@' || v_tag || ']');
                    END IF;
                END LOOP;
            END form29;
        
            FUNCTION check_context
                RETURN VARCHAR2 IS
                v_who   VARCHAR2(100);
            BEGIN
                v_who := Core_Context.personnel_name;
        
                IF v_who IS NULL THEN
                    v_who := v( 'APP_USER');
                END IF;
        
                IF v_who IS NULL THEN
                    v_who := sys_context('USERENV', 'OS_USER');
                END IF;
        
                IF v_who IS NULL THEN
                    v_who := USER;
                END IF;
        
                RETURN v_who;
            EXCEPTION
                WHEN OTHERS THEN
                    Core_Logger.log_it(c_pipe, 'Exception in check_context: ' || SQLERRM);
            END check_context;
        
            PROCEDURE home_page(punit IN VARCHAR2, pfiscalyear IN VARCHAR2 := NULL, ptkt IN VARCHAR2 := NULL) IS
                v_user_info     VARCHAR2(100);
                v_unit_sid      T_CFUNDS_UNIT.SID%TYPE;
                v_cfcustodian   VARCHAR2(10);
                v_commander     VARCHAR2(10);
                v_person_role   VARCHAR2(25);
            BEGIN
                Core_Logger.log_it(c_pipe, '--> Cfunds_Web.Home_Page');
                -- make sure we have personnel context
                Core_Logger.log_it(c_pipe, 'user = ' || check_context);
                -- find the unit to default to if not sent in as a parameter
                v_unit_sid := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                Core_Logger.log_it(c_pipe, 'unit = ' || v_unit_sid);
                v_cfcustodian :=
                    Cfunds_Test_Cfp('EXP_PAY',
                                    Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                    Core_Context.personnel_sid,
                                    v_unit_sid);
                v_commander :=
                    Cfunds_Test_Cfp('APPROVE_CL',
                                    Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                    Core_Context.personnel_sid,
                                    v_unit_sid);
                Core_Logger.log_it(c_pipe,
                                   'v_cfcustodian = ' || v_cfcustodian || ', v_commander = ' || v_commander);
        
                -- test unit to see if user has privs to be in here;
                -- since there isn't a priv for accessing E-Funds Custodian
                -- level data, we check 2 privs and if both fail then
                -- user can't see any data.
                IF v_cfcustodian = 'N' AND v_commander = 'N' THEN
                    v_error_detail :=
                                    'You do not have privileges to view data ' || 'for the specified unit.';
                    RAISE a_stink;
                END IF;
        
                -- find the level of the current user's unit.
                FOR u IN (SELECT *
                            FROM v_cfunds_unit
                           WHERE SID = '' || Cfunds_Pkg.get_my_cfunds_unit || '')
                LOOP
                    IF v_cfcustodian = 'Y' THEN
                        v_person_role := 'Custodian';
                    ELSE
                        v_person_role := 'Commander';
                    END IF;
        
                    IF u.PARENT IS NULL THEN
                        IF u.reviewing_unit = 'Y' THEN
                            v_user_info := 'HQ ' || v_person_role;
                        ELSE
                            v_error_detail :=
                                'Your unit does not have a parent unit. '
                                || 'This will result in E-Funds expense repayments not being made.  Please call the I2MS help desk.';
                            RAISE a_stink;
                        END IF;
                    ELSE
                        IF u.unit_type = 'REGN' THEN
                            v_user_info := 'Region ' || v_person_role;
                        ELSIF u.unit_type = 'DET' THEN
                            v_user_info := 'Detachment ' || v_person_role;
                        ELSIF u.unit_type = 'HQ' THEN
                            v_user_info := u.unit_code || ' ' || v_person_role;
                        ELSE
                            v_user_info := u.unit_type || ' ' || v_person_role;
                        END IF;
                    END IF;
        
                    EXIT;
                END LOOP;
        
                begin_serve_page('E-Funds Home',
                                 TRUE,
                                 FALSE,
                                 'E-Funds Management System',
                                 'Welcome ' || v_user_info || '!');
                home_page_guts(v_unit_sid, pfiscalyear);
                end_serve_page;
                setunitsid(v_unit_sid);
                set_fiscal_year(pfiscalyear);
                Core_Logger.log_it(c_pipe, '<-- Cfunds_Web.Home_Page');
            EXCEPTION
                WHEN a_stink THEN
                    begin_serve_page('E-Funds Home',
                                     FALSE,
                                     FALSE,
                                     'E-Funds Management System',
                                     '',
                                     'DoHistory');
                    exception_handler(TRUE);
                    htp.print('<br><font size="+2"><b><a href="' || Web_Util_Pkg.get_current_package
                              || 'home_page?pUnit=' || Cfunds_Pkg.get_my_cfunds_unit
                              || '">Back to Home_Page</a></b></font><br><br>');
                    end_serve_page;
            END home_page;
        
            PROCEDURE manage_cfms(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
                --  Parameters
                vp_unit           T_OSI_UNIT.SID%TYPE;
                vp_pec            T_CFUNDS_PECS.code%TYPE;
                vp_fiscal_year    VARCHAR2(10);
                --  Template Processing
                v_template        CLOB;
                v_template_date   DATE;
                v_offset          NUMBER                    := 1;
                v_tag             VARCHAR2(100);
                v_self            VARCHAR2(500);
                --  Query Processing/General
                v_query           VARCHAR2(4000);
                v_query_status    VARCHAR2(400);
                v_cursor          INTEGER;
                v_cnt             NUMBER;
                v_ok              BOOLEAN;
                v_tmp             VARCHAR2(500);
            BEGIN
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Manage_CFMS');
                Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
                Web_Util_Pkg.dump_params(name_array, value_array);
                -- Get control parameters
                vp_unit :=
                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                        Cfunds_Pkg.get_my_cfunds_unit);
                vp_fiscal_year :=
                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear'),
                        Cfunds_Pkg.get_fiscal_year(SYSDATE));
                -- E.G this fix should work on lower and recent version of oracle.
                --v_self := '!' || WEB_UTIL_PKG.Get_Self;
                v_self := '!' || REPLACE(Web_Util_Pkg.get_self, '!', '');
                begin_serve_page('E-Funds Manage EFMS', TRUE, TRUE, ' ', 'E-Funds Manage EFMS', 'DoHistory');
        
                -- Start default (Refresh) processing
        
                -- Check privilege to even show the information
                --*** change to priv for overall limitation change (need to create)!!!!!!!!!!!!!!!!!!!!!!!!
                IF Cfunds_Test_Cfp('CF_LIM_SET_ORG',
                                   Core_Obj.lookup_objtype('NONE'),
                                   Core_Context.personnel_sid,
                                   v_hq_cc_unit_sid) = 'N' THEN
                    v_error_detail := 'You do not have privilege to view this information' || '.';
                    RAISE a_stink;
                END IF;
        
                v_ok := Web_Template_Pkg.get_latest('cfunds_manage_cfms', v_template, v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_manage_cfms"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self || '?a=1');
                -- remember the Fiscal Year
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'EFT',
                                                 REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                                 || 'eft_info?pFiscalYear=' || vp_fiscal_year || '&pUnit='
                                                 || vp_unit);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'UNIT_NAME',
                                                 Cfunds_Pkg.lookup_cfunds_unit(vp_unit).unit_name);
                -- E.G this fix should work on lower and recent version of oracle.
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'LIMITATIONS',
                                                 '!' || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                                 || 'adjust_afosi_limitations?pFiscalYear='
                                                 || vp_fiscal_year || '&pUnit=' || vp_unit);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'MFR',
                                                 REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                                 || 'mfr_by_unit?pFiscalYear=' || vp_fiscal_year
                                                 || '&pUnit=' || vp_unit);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'ZERO_REGION_UNIT',
                                                 '!' || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                                 || 'zero_all?pUnit=' || vp_unit || '&pFiscalYear='
                                                 || vp_fiscal_year);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'REINIT_REGION_UNIT',
                                                 '!' || REPLACE(Web_Util_Pkg.get_current_package, '!', '')
                                                 || 'reinit_all?pFiscalYear=' || vp_fiscal_year || '&pUnit='
                                                 || vp_unit);
        
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
                    IF v_tag = 'AMT_SPENT_TOT' THEN
                        --   htp.prn(to_char(v_amt_spent_tot, v_dollar_format));
                        NULL;
                    ELSE
                        htp.print('[' || v_tag || ']');
                    END IF;
                END LOOP;
        
                end_serve_page;
                setunitsid(vp_unit);
                set_fiscal_year(vp_fiscal_year);
            EXCEPTION
                WHEN a_stink THEN
                    exception_handler(TRUE);
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
                WHEN OTHERS THEN
                    exception_handler;
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
            END manage_cfms;
        
            PROCEDURE manage_limitations(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
                --  Parameters
                vp_unit              T_OSI_UNIT.SID%TYPE;
                vp_pec               T_CFUNDS_PECS.code%TYPE;
                vp_eff_date          DATE;
                vp_command           VARCHAR2(100);
                vp_debug             VARCHAR2(10);
                vp_fiscal_year       VARCHAR2(10);
                --  Template Processing
                v_template           CLOB;
                v_template_date      DATE;
                v_offset             NUMBER                              := 1;
                v_tag                VARCHAR2(100);
                v_self               VARCHAR2(500);
                --  Query Processing/General
                v_query              VARCHAR2(4000);
                v_query_status       VARCHAR2(400);
                v_cursor             INTEGER;
                v_cnt                NUMBER;
                v_ok                 BOOLEAN;
                v_show_link          BOOLEAN;
                v_tmp                VARCHAR2(500);
                v_reviewing_unit     T_CFUNDS_UNIT.reviewing_unit%TYPE;
                v_amt_spent          NUMBER;
                v_pct_oblgtd         NUMBER;
                v_curr_lim           NUMBER;
                v_amt_spent_tot      NUMBER                              := 0;
                v_pct_oblg_tot       NUMBER                              := 0;
                v_curr_lim_tot       NUMBER                              := 0;
                v_new_lim_tot        NUMBER                              := 0;
                v_org_target         NUMBER                              := 0;
                v_org_actual         NUMBER                              := 0;
                v_org_target_debug   NUMBER                              := 0;
                v_org_actual_child   NUMBER                              := 0;
                v_u_arr              Cfunds_Pkg.str_arr;
                v_l_arr              Cfunds_Pkg.num_arr;
                v_arr_ndx            BINARY_INTEGER                      := 0;
                v_this_unit          VARCHAR2(100);
                v_this_lim           NUMBER;
            BEGIN
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Manage_Limitations');
                Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
                Web_Util_Pkg.dump_params(name_array, value_array);
                -- Get control parameters
                vp_command :=
                       NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pCommand'), 'Refresh');
                vp_unit :=
                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                        Cfunds_Pkg.get_my_cfunds_unit);
                vp_pec := NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pPEC'), 'S&IA');
                vp_debug := NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pDebug'), 'FALSE');
                vp_fiscal_year := Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear');
        
                -- use the fiscal year to drive the effective date.
                IF vp_fiscal_year IS NULL THEN                                    -- use current fiscal year
                    vp_fiscal_year := Cfunds_Pkg.get_fiscal_year(SYSDATE);
                    -- use date passed as parameter, unless it wasn't passed in which case we use current date.
                    v_tmp := Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pEff_Date');
                    vp_eff_date := TO_DATE(v_tmp, 'dd-Mon-yyyy');
        
                    IF Cfunds_Pkg.get_fiscal_year(vp_eff_date) = vp_fiscal_year THEN
                        NULL;
                    ELSE
                        -- if the effective date is not in the selected [current] fiscal year, change it to today.
                        vp_eff_date := NULL;
                    END IF;
        
                    vp_eff_date := TRUNC(NVL(vp_eff_date, SYSDATE));
                ELSIF vp_fiscal_year = Cfunds_Pkg.get_fiscal_year(SYSDATE) THEN
                    v_tmp := Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pEff_Date');
                    vp_eff_date := TO_DATE(v_tmp, 'dd-Mon-yyyy');
        
                    IF Cfunds_Pkg.get_fiscal_year(vp_eff_date) = vp_fiscal_year THEN
                        NULL;
                    ELSE
                        -- if the effective date is not in the selected [current] fiscal year, change it to today.
                        vp_eff_date := NULL;
                    END IF;
        
                    vp_eff_date := TRUNC(NVL(vp_eff_date, SYSDATE));
                ELSE                               -- past fiscal year means we need to do something special
                    -- default to last effective date in that fiscal year.
                    vp_eff_date := Cfunds_Pkg.get_fiscal_year_end_date(vp_fiscal_year);
                END IF;
        
                -- E.G this fix should work on lower and recent version of oracle.
                --v_self := '!' || WEB_UTIL_PKG.Get_Self;
                v_self := '!' || REPLACE(Web_Util_Pkg.get_self, '!', '');
                begin_serve_page('E-Funds Manage Limitations',
                                 TRUE,
                                 TRUE,
                                 ' ',
                                 'E-Funds Manage Limitations',
                                 'DoHistory');
        
                -- Process commands. Only real command is 'Update'. Default processing
                -- is the 'Refresh' command (which gets executed in all cases).
                IF vp_command = 'Update' THEN
                    Core_Logger.log_it(c_pipe, 'Cfunds_Web.Manage Limitation: Update started');
                    --verify that the user's unit is a reviewing unit
                    --SELECT REVIEWING_UNIT INTO v_Reviewing_Unit
                        --FROM T_CFUNDS_UNIT
                        --WHERE SID = osi_personnel.get_current_unit(core_context.personnel_sid);
                    Core_Logger.log_it(c_pipe,
                                       'Cfunds_Web.Manage Limitation: Check Priv Passed'
                                       || Osi_Personnel.get_current_unit(Core_Context.personnel_sid));
        
                    --correct privilege AND the Unit must be a reviewing unit are required to update Cfunds Limitations
                    IF Cfunds_Test_Cfp('CF_LIM_SET_EXP',
                                       Core_Obj.lookup_objtype('NONE'),
                                       Core_Context.personnel_sid,
                                       vp_unit) = 'N' THEN
                        -- OR v_Reviewing_Unit = 'N' THEN
                        v_error_detail :=
                            'You do not have privilege to update the limitations '
                            || 'for the specified unit.';
                        htp.p('<INPUT TYPE="hidden" NAME="pFiscalYear" VALUE="' || vp_fiscal_year || '">');
                        htp.p('<INPUT TYPE="hidden" NAME="pUnit" VALUE="' || vp_unit || '">');
                        RAISE a_stink;
                    END IF;
        
                    Core_Logger.log_it(c_pipe, 'Cfunds_Web.Manage Limitation: Check Priv Passed');
                    Web_Util_Pkg.send_comment('Processing Update');
        
                    -- Sort through the parameters looking for non-Null pLimList values.
                    -- For each one found, add that (and it's corresponding pUnitList
                    -- value to the arrays which will be passed into Set_EXP_Limitation.
                    -- This process assumes that the Unit/Limitation values always appear
                    -- in pairs (with the Unit coming first).
                    FOR i IN name_array.FIRST .. name_array.LAST
                    LOOP
                        IF name_array(i) = 'pUnitList' THEN
                            v_this_unit := value_array(i);
                        END IF;
        
                        IF name_array(i) = 'pLimList' THEN
                            v_this_lim := value_array(i);
        
                            IF v_this_lim IS NOT NULL THEN
                                v_arr_ndx := v_arr_ndx + 1;
                                v_u_arr(v_arr_ndx) := v_this_unit;
                                v_l_arr(v_arr_ndx) := v_this_lim;
                            END IF;
        
                            Core_Logger.log_it(c_pipe,
                                               'Cfunds_Web.Manage Limitation: Unit ' || TO_CHAR(v_this_unit)
                                               || '  Limitation ' || TO_CHAR(v_this_lim) || ' ');
                        END IF;
                    END LOOP;                                                                           -- i
        
                    Core_Logger.log_it(c_pipe, 'Cfunds_Web.Manage Limitation: unit/Lim List Generated');
                    Web_Util_Pkg.send_comment('Passed ' || v_arr_ndx || ' unit/lim pairs.');
                    Core_Logger.log_it(c_pipe,
                                       'Cfunds_Web.Manage Limitation: ' || v_arr_ndx || ' pairs passed.');
                    Cfunds_Pkg.set_exp_limitation(vp_unit, v_u_arr, v_l_arr, vp_pec, NULL, vp_eff_date);
                    Core_Logger.log_it(c_pipe, 'Cfunds_Web.Manage Limitation: Set Lim Succeed');
                    COMMIT;                                                  -- only called if no exceptions
                END IF;                                                                 -- Update processing
        
                -- Start default (Refresh) processing
        
                -- Check privilege to even show the information
                IF Cfunds_Test_Cfp('CF_LIM_SET_EXP',
                                   Core_Obj.lookup_objtype('NONE'),
                                   Core_Context.personnel_sid,
                                   vp_unit) = 'N' THEN
                    v_error_detail :=
                          'You do not have privilege to view the limitations ' || 'for the specified unit.';
                    htp.p('<INPUT TYPE="hidden" NAME="pFiscalYear" VALUE="' || vp_fiscal_year || '">');
                    htp.p('<INPUT TYPE="hidden" NAME="pUnit" VALUE="' || vp_unit || '">');
                    RAISE a_stink;
                END IF;
        
                v_ok :=
                       Web_Template_Pkg.get_latest('cfunds_manage_limitations', v_template, v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_manage_limitations"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self || '?a=1');
                -- remember the Fiscal Year
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'FISCAL_YEAR_LABEL',
                                                 get_html_fy_dropdown(vp_fiscal_year, 'pFiscalYear'));
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
        
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
                    IF v_tag = 'AMT_SPENT_TOT' THEN
                        htp.prn(TO_CHAR(v_amt_spent_tot, v_dollar_format));
                    ELSIF v_tag = 'CURR_LIM_TOT' THEN
                        -- calculate this value here so we can compare; it is used later
                        -- to replace the corresponding tag [WEBTOK@ORG_TARGET].
                        v_org_target :=
                                NVL(Cfunds_Pkg.get_unit_limitation(vp_unit, 'OXT', vp_pec, vp_eff_date), 0);
        
                        -- look to see if the current unit has subordinate units; if not,
                        -- don't show a red number.  The units at the bottom level all have
                        -- target limitations of '0' for some odd reason, but that doesn't make
                        -- it an error.
                        IF Cfunds_Pkg.lookup_cfunds_unit(vp_unit).reviewing_unit = 'Y' THEN
                            IF v_org_target > v_curr_lim_tot THEN
                                htp.prn('<font color="red">' || TO_CHAR(v_curr_lim_tot, v_dollar_format)
                                        || '*</font>');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag
                                        (v_template,
                                         'HELP_MESSAGE',
                                         '<font color="red">*Note: </font> Your Limitation Amount is red because it is too low.  You need to adjust the limitations of one or more units on this list to increase the red number.  When the number shown in red matches your "Organization Target" number, it will no longer be red.');
                            ELSIF v_org_target < v_curr_lim_tot THEN
                                htp.prn('<font color="red">' || TO_CHAR(v_curr_lim_tot, v_dollar_format)
                                        || '*</font>');
                                v_ok :=
                                    Web_Template_Pkg.replace_tag
                                        (v_template,
                                         'HELP_MESSAGE',
                                         '<font color="red">*Note: </font> Your Limitation Amount is red because it is too high.  You need to adjust the limitations of one or more units on this list to decrease the red number.  When the number shown in red matches your "Organization Target" number, it will no longer be red.');
                            ELSE
                                htp.prn(TO_CHAR(v_curr_lim_tot, v_dollar_format));
                            END IF;
                        ELSE
                            htp.prn(TO_CHAR(v_curr_lim_tot, v_dollar_format));
                        END IF;
        
                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'HELP_MESSAGE', ' ');
                    -- if no change needed then do not print out a message.
                    ELSIF v_tag = 'EFF_DATE' THEN
                        v_tmp := TO_CHAR(vp_eff_date, 'dd-Mon-yyyy');
                        htp.p(v_tmp);
                    ELSIF v_tag = 'ORG_LIMIT_DEBUG' THEN
                        IF vp_debug <> 'FALSE' THEN
                            htp.prn('<td>Org Limit</td>');
                        END IF;                   -- only print this header for debugging - more code below.
                    ELSIF v_tag = 'ORG_LIMIT_DEBUG_MSG' THEN
                        IF vp_debug <> 'FALSE' THEN
                            htp.prn
                                ('Note for debugging: Do not try to sum up the totals in the Org Limit column.  The Org Limit total for each unit does not always match the Current Limit for that unit.  The first row shows the Current Limit for that unit only, and the Org Limit column shows the total of all the limitations for the unit and subordinate units.  Other units have their Current Total column showing the Organizational Total if they are parents of E-Funds units.  Bottom-level units (Dets) will normally have their Org Total  showing as $0, this is normal.');
                        END IF;                   -- only print this header for debugging - more code below.
                    ELSIF v_tag = 'LIMITATIONS_LIST' THEN
                        FOR u IN (SELECT   SID, unit_name, PARENT, DECODE(SID, vp_unit, 1, 2) AS grp
                                      FROM v_cfunds_unit
                                     WHERE (   PARENT = vp_unit
                                            OR SID = vp_unit)
                                  ORDER BY 4, 2)
                        LOOP
                            SELECT COUNT(*)
                              INTO v_cnt
                              FROM v_cfunds_unit
                             WHERE PARENT = u.SID;
        
                            IF    v_cnt = 0
                               OR u.grp = 1 THEN
                                v_amt_spent :=
                                    NVL(Cfunds_Pkg.get_unit_annual_expenses(u.SID, vp_pec, vp_eff_date), 0);
                                v_curr_lim :=
                                          Cfunds_Pkg.get_unit_limitation(u.SID, 'EXP', vp_pec, vp_eff_date);
                                v_show_link := FALSE;
                            ELSE
                                v_amt_spent :=
                                    NVL(Cfunds_Pkg.get_unitorg_annual_expenses(u.SID, vp_pec, vp_eff_date),
                                        0);
                                v_curr_lim :=
                                           Cfunds_Pkg.get_unit_limitation(u.SID, 'OXT', vp_pec, vp_eff_date);
                                v_show_link := TRUE;
                            END IF;
        
                            IF vp_debug <> 'FALSE' THEN
                                v_org_target_debug :=
                                          Cfunds_Pkg.get_unit_limitation(u.SID, 'OXT', vp_pec, vp_eff_date);
                            END IF;
        
                            -- only calculate this total for debugging (too costly for all the time use).
                            IF NVL(v_curr_lim, 0) = 0 THEN
                                v_pct_oblgtd := NULL;
                            ELSE
                                v_pct_oblgtd := v_amt_spent / v_curr_lim;
                            END IF;
        
                            htp.tableRowOpen;
                                htp.p('<td>');
            
                                IF NOT v_show_link THEN
                                    htp.p(u.unit_name);
                                ELSE
                                    htp.p('<a href="VBscript:Submit_Unit(&quot;' || u.SID || '&quot;)">');
                                    htp.p(u.unit_name);
                                    htp.p('</a>');
                                END IF;
            
                                htp.formhidden('pUnitList', u.SID);
                                htp.p('</td>');
                                htp.tabledata(TO_CHAR(v_amt_spent, v_dollar_format), 'right');
                                htp.tabledata(TO_CHAR(v_pct_oblgtd * 100, '990.0') || '%', 'right');
                                htp.p('<td>');
            
                                -- show link (pop-up info only) if this unit has subordinate units AND its Target Limitation is not equal to the Actual Limitation.
                                IF NOT v_show_link THEN
                                    htp.p(NVL(TO_CHAR(v_curr_lim, v_dollar_format), '(none set)'));
                                ELSE
                                    v_org_actual_child :=
                                        NVL(Cfunds_Pkg.get_unitorg_limitation(u.SID, 'EXP', vp_pec, vp_eff_date),
                                            0);
            
                                    IF v_org_actual_child <> v_curr_lim THEN
                                        htp.p
                                            ('<a href="javascript:void(0)" onclick="doMsg &quot;The actual limitation amount used by this unit and all subordinate units is '
                                             || TO_CHAR(v_org_actual_child, v_dollar_format)
                                             || '.  Use the Manage Limitations page to adjust these numbers.&quot;,&quot;Alert: Limitations Need Adjusting&quot;"><font color="red">'
                                             || NVL(TO_CHAR(v_curr_lim, v_dollar_format), '(none set)')
                                             || '</font></a>');
                                    ELSE
                                        htp.p(NVL(TO_CHAR(v_curr_lim, v_dollar_format), '(none set)'));
                                    END IF;
                                END IF;
            
                                htp.p('</td>');
                                htp.p('<TD><INPUT NAME="pLimList" onfocus="SaveCurrLim(' || NVL(v_curr_lim, 0)
                                      || ')" onblur="UpdateRunTot(' || NVL(v_curr_lim, 0) || ')"></TD>');
            
                                IF vp_debug <> 'FALSE' THEN
                                    htp.tabledata(TO_CHAR(NVL(v_org_target_debug, 0), v_dollar_format),
                                                  'right');
                                END IF;                  -- only show this column if we need to debug something.
        
                            htp.tableRowClose;
                            v_amt_spent_tot := v_amt_spent_tot + NVL(v_amt_spent, 0);
                            v_curr_lim_tot := v_curr_lim_tot + NVL(v_curr_lim, 0);
                        END LOOP;
                    ELSIF v_tag = 'LIM_RUN_TOT' THEN
                        htp.prn(LTRIM(TO_CHAR(v_curr_lim_tot)));
                    ELSIF v_tag = 'ORG_ACTUAL' THEN
                        v_org_actual :=
                             NVL(Cfunds_Pkg.get_unitorg_limitation(vp_unit, 'EXP', vp_pec, vp_eff_date), 0);
                        htp.prn(LTRIM(TO_CHAR(v_org_actual)));
                    ELSIF v_tag = 'ORG_TARGET' THEN
                        htp.prn(LTRIM(TO_CHAR(v_org_target)));
                    ELSIF v_tag = 'PCT_OBLG_TOT' THEN
                        IF v_curr_lim_tot <> 0 THEN
                            v_pct_oblg_tot := 100 *(v_amt_spent_tot / v_curr_lim_tot);
                            htp.prn(TO_CHAR(v_pct_oblg_tot, '990.0'));
                        END IF;
                    ELSIF v_tag = 'PEC_LIST' THEN
                        -- create a combo box to allow the user to choose their PEC.
                        -- setup the cursor for the combo box to select a PEC
                        v_cursor := DBMS_SQL.OPEN_CURSOR;
                        v_query := '';
                        v_query := v_query || ' select distinct';
                        v_query := v_query || '     PROGRAM_EXPENSE_CODE as CODE,';
                        v_query := v_query || '     PROGRAM_EXPENSE_CODE as DESCRIPTION,';
                        v_query :=
                            v_query || '     decode(PROGRAM_EXPENSE_CODE, ''' || vp_pec
                            || ''', ''Y'',null) as SELECTED';
                        v_query := v_query || ' from T_CFUNDS_CATEGORIES';
                        DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                        --                        OWA_CORE_LISTPRINT(V_CURSOR, 'pPEC', 1, FALSE);
                        owa_util.listprint(v_cursor, 'pPEC', 1, FALSE);
                        DBMS_SQL.CLOSE_CURSOR(v_cursor);
                    ELSIF v_tag = 'UNIT_LIST' THEN
                        -- setup the cursor for the combo box to select a unit
                        v_cursor := DBMS_SQL.OPEN_CURSOR;
                        v_query := '';
                        v_query := v_query || ' select SID, UNIT_NAME, ';
                        v_query :=
                               v_query || '     decode(SID, ''' || vp_unit || ''', ''Y'',null) as SELECTED';
                        v_query := v_query || ' from V_CFUNDS_UNIT';
                        v_query :=
                            v_query
                            || ' where CFUNDS_TEST_CFP(''CF_LIM_SET_EXP'', core_obj.lookup_objtype(''NONE''), core_context.personnel_sid, SID) = ''Y''';
                        v_query := v_query || ' order by UNIT_CODE';
                        DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                        --                        OWA_CORE_LISTPRINT(V_CURSOR, 'pUnitPick', 1, FALSE);
                        owa_util.listprint(v_cursor, 'pUnitPick', 1, FALSE);
                        DBMS_SQL.CLOSE_CURSOR(v_cursor);
                    ELSE
                        htp.print('[' || v_tag || ']');
                    END IF;
                END LOOP;
        
                end_serve_page;
                setunitsid(vp_unit);
                set_fiscal_year(vp_fiscal_year);
            EXCEPTION
                WHEN a_stink THEN
                    exception_handler(TRUE);
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
                WHEN OTHERS THEN
                    exception_handler;
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
            END manage_limitations;
        
            PROCEDURE mfr_by_unit(punit IN VARCHAR2, pfiscalyear IN VARCHAR2) IS
                v_template        CLOB;
                v_template_date   DATE;
                v_offset          NUMBER                   := 1;
                v_params_short    VARCHAR2(1000);
                v_params          VARCHAR2(1000);
                v_tag             VARCHAR2(100);
                v_query           VARCHAR2(4000);
                v_query_params    VARCHAR2(4000);
                v_cursor          INTEGER;
                v_ok              BOOLEAN;
                v_filter_list     VARCHAR2(1000);
                v_unit_name       VARCHAR2(50);
                v_unit            T_CFUNDS_UNIT.SID%TYPE;
                v_fiscal_year     VARCHAR2(10);
                v_data_written    BOOLEAN                  := FALSE;
            BEGIN
                -- if the unit wasn't specified, use the current user's unit.
                v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                -- if the fiscal year wasn't specified, use the current fiscal year.
                v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                -- find the name of this unit whose subordinate units are showing.
                v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
                begin_serve_page('E-Funds Memos For Record',
                                 TRUE,
                                 TRUE,
                                 '',
                                 'E-Funds Memos For Record',
                                 'home_page');
        
                IF Cfunds_Test_Cfp('CF_XFR_RWF',
                                   Core_Obj.lookup_objtype('NONE'),
                                   Core_Context.personnel_sid,
                                   Osi_Personnel.get_current_unit(Core_Context.personnel_sid)) = 'N' THEN
                    v_error_detail := 'You do not have privilege to view this information' || '.';
                    -- need these values added going to other links on the web page. limitations and transaction log.
                    htp.p('<INPUT TYPE="hidden" NAME="pFiscalYear" VALUE="' || v_fiscal_year || '">');
                    htp.p('<INPUT TYPE="hidden" NAME="pUnit" VALUE="' || v_unit || '">');
                    RAISE a_stink;
                END IF;
        
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.MFR_by_Unit');
                v_ok := Web_Template_Pkg.get_latest('cfunds_mfr_by_unit', v_template, v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_mfr_by_unit"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                -- remember the UNIT so the screen can be refreshed when the user changes the filters.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_FLAG', v_unit);
                -- remember the Fiscal Year
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'FISCAL_YEAR_LABEL',
                                                 get_html_fy_dropdown(v_fiscal_year));
        
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
                    IF v_tag = 'MFR_LIST' THEN
                        v_data_written := FALSE;
        
                        FOR mfr IN
                            (SELECT u.SID AS unit_sid, u.unit_name, mfr.voucher_no, mfr.amount,
                                    mfr.incurred_date, mfr.SID, mfr.status
                               FROM v_cfunds_mfr mfr, v_cfunds_unit u
                              WHERE TRUNC(mfr.incurred_date)
                                        BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                            AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                                AND mfr.unit = u.SID
                                AND mfr.unit = v_unit)
                        LOOP
                            -- indicate that a row is in the table now.
                            v_data_written := TRUE;
                            htp.tableRowOpen;
                                htp.p('<td>');
                                -- E.G. not sure about the need of the ! on earlier or later version of oracle
                                htp.p('<a  href="!' || Web_Util_Pkg.get_current_package || 'mfr_details?pUnit='
                                      || v_unit || '&pSID=' || mfr.SID || '&pFiscalYear=' || v_fiscal_year
                                      || '">');
                                htp.p(mfr.voucher_no);
                                htp.p('</a>');
                                htp.p('</td>');
                                htp.tabledata(mfr.unit_name, 'right');
                                htp.tabledata(TO_CHAR(mfr.amount, v_dollar_format), 'right');
                                htp.tabledata(mfr.incurred_date, 'right');
                                htp.tabledata(mfr.status, 'right');
                            htp.tableRowClose;
                        END LOOP;
        
                        IF NOT v_data_written THEN
                            htp.tableRowOpen;
                                htp.p('<td colspan="5">');
                                htp.p('No entries found.');
                                htp.p('</td>');
                            htp.tableRowClose;
                        END IF;
                    ELSE
                        htp.print('[' || v_tag || ']');
                    END IF;
                END LOOP;
        
                end_serve_page;
                setunitsid(v_unit);
                set_fiscal_year(pfiscalyear);
            EXCEPTION
                WHEN a_stink THEN
                    exception_handler(TRUE);
                    end_serve_page;
                    setunitsid(v_unit);
                    set_fiscal_year(v_fiscal_year);
            END mfr_by_unit;
        
            PROCEDURE mfr_details(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
                --  Parameters
                vp_command         VARCHAR2(100);
                vp_unit            T_OSI_UNIT.SID%TYPE;
                vp_fiscal_year     VARCHAR2(10);
                vp_sid             T_CFUNDS_MFR.SID%TYPE;
                vp_amount          T_CFUNDS_MFR.amount%TYPE;
                vp_comments        T_CFUNDS_MFR.comments%TYPE;
                vp_incurred_date   T_CFUNDS_MFR.incurred_date%TYPE;
                --  Template Processing
                v_template         CLOB;
                v_template_date    DATE;
                v_offset           NUMBER                                := 1;
                v_tag              VARCHAR2(100);
                v_self             VARCHAR2(500);
                --  Query Processing/General
                v_mfr_rec          v_cfunds_mfr%ROWTYPE                  := NULL;
                v_ok               BOOLEAN;
                v_buttons          VARCHAR2(3000);
                v_update_button    VARCHAR2(500);
                v_save_button      VARCHAR2(500);
                --     v_approve_button Varchar2(500);
                --     v_reject_button Varchar2(500);
                --     v_complete_button Varchar2(500);
                v_delete_button    VARCHAR2(500);
                --    v_submitted_by T_CFUNDS_MFR.SUBMITTED_BY%type;
                v_incurred_date    T_CFUNDS_MFR.incurred_date%TYPE;
                v_voucher_no       T_CFUNDS_EXPENSE_V3.voucher_no%TYPE;
        
                PROCEDURE load_mfr(psid IN VARCHAR2) IS
                BEGIN
                    SELECT *
                      INTO v_mfr_rec
                      FROM v_cfunds_mfr
                     WHERE SID = psid;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_mfr_rec := NULL;
                END load_mfr;
        
                FUNCTION set_incurred_date(pdate IN VARCHAR2)
                    RETURN BOOLEAN IS
                    v_date   DATE;
                BEGIN
                    -- looks as if we can do this conversion without causing an exception then
                    -- we have a valid date and one
                    -- of those possibilities is Null.
                    v_date := TO_DATE(pdate, 'dd-Mon-yy');
        
                    IF (NOT date_precision(v_date) IS NULL) THEN
                        vp_incurred_date := v_date;
                        RETURN TRUE;
                    ELSE
                        --WEB_UTIL_PKG.Send_Comment('You have an incorrect date format' || pDate);
                        vp_incurred_date := pdate;
                        RETURN TRUE;
                    END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_error_detail :=
                            'You do not have a valid date in a valid date format!  Format should be: "dd-Mon-yy".';
                        vp_incurred_date := NULL;
                        RETURN FALSE;
                END set_incurred_date;
        
                FUNCTION htmlize_string(pstring IN VARCHAR2)
                    RETURN VARCHAR2 IS
                    v_rtn   VARCHAR2(4000) := '';
                BEGIN
                    v_rtn := pstring;
                    v_rtn := REPLACE(v_rtn, CHR(13), NULL);
                    v_rtn := REPLACE(v_rtn, CHR(10), '<br>');
                    RETURN v_rtn;
                END htmlize_string;
            BEGIN
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.MFR_details');
                Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
                -- This prints your array paramters and values to the html page you are trying to build.
                Web_Util_Pkg.dump_params(name_array, value_array);
                -- Get control parameters
                vp_command :=
                       NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pCommand'), 'Refresh');
                vp_unit :=
                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                        Cfunds_Pkg.get_my_cfunds_unit);
                vp_fiscal_year :=
                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear'),
                        Cfunds_Pkg.get_fiscal_year(SYSDATE));
                vp_sid := NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pSID'), 'newone');
                vp_amount := Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pAmount');
                vp_comments := Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pComments');
        
                IF (set_incurred_date(Web_Util_Pkg.get_flex_parameter(name_array,
                                                                      value_array,
                                                                      'pIncurred_Date')) = FALSE) THEN
                    RAISE a_stink;
                END IF;
        
                -- E.G this fix should work on lower and recent version of oracle.
                --v_self := '!' || WEB_UTIL_PKG.Get_Self;
                v_self := '!' || REPLACE(Web_Util_Pkg.get_self, '!', '');
                begin_serve_page('E-Funds Memo For Record',
                                 TRUE,
                                 TRUE,
                                 ' ',
                                 'E-Funds Memo For Record',
                                 'DoHistory');
        
                -- Check privilege to even show the information
                IF Cfunds_Test_Cfp('CF_MFR_VIEW',
                                   Core_Obj.lookup_objtype('NONE'),
                                   Core_Context.personnel_sid,
                                   Osi_Personnel.get_current_unit(Core_Context.personnel_sid)) = 'N' THEN
                    v_error_detail := 'You do not have privilege to view this information' || '.';
                    -- need these values added going to other links on the web page. limitations and transaction log.
                    htp.p('<INPUT TYPE="hidden" NAME="pFiscalYear" VALUE="' || vp_fiscal_year || '">');
                    htp.p('<INPUT TYPE="hidden" NAME="pUnit" VALUE="' || vp_unit || '">');
                    RAISE a_stink;
                END IF;
        
                -- Process commands. Only real command is 'Update, Save and Delete'.
                IF vp_command = 'Save' THEN
                    IF vp_amount = NULL THEN
                        v_error_detail := 'You must enter an amount. Use zero if there is no amount.';
                        RAISE a_stink;
                    END IF;
        
                    -- create a new record for the MFR
                    -- if there isnt a record, create a new one.
                    -- query for existence; look for SID in the table first.
                    IF vp_sid = 'newone' THEN
                        Cfunds_Pkg.create_mfr(vp_incurred_date, vp_unit, vp_comments, vp_amount, vp_sid);
                        -- return SID and VOUCHER no.
                        htp.p('A new Memo For Record was saved');
                        COMMIT;
                        -- reload the MFR
                        load_mfr(vp_sid);
                    END IF;
                ELSIF vp_command = 'Update' THEN
                    -- check to see if they have the priviledge to update
                    IF Cfunds_Test_Cfp('CF_LIM_SET_ORG',
                                       Core_Obj.lookup_objtype('NONE'),
                                       Core_Context.personnel_sid,
                                       Osi_Personnel.get_current_unit(Core_Context.personnel_sid)) = 'N' THEN
                        v_error_detail := 'You do not have privilege to update this mfr.';
                        RAISE a_stink;
                    END IF;
        
                    -- save updated changes
                    UPDATE T_CFUNDS_MFR
                       SET
                           --SUBMITTED_ON = sysdate,
                           comments =
                               comments || v_nl || v_nl || 'Follow-Up by ' || Core_Context.personnel_name
                               || ' on ' || SYSDATE || v_nl || vp_comments,
                           --SUBMITTED_BY = core_context.personnel_name,
                           modify_on = SYSDATE,
                           modify_by = Core_Context.personnel_name
                     WHERE SID = vp_sid;
        
                    COMMIT;
                    htp.p('This Memo For Record was updated.');
                    -- reload the MFR
                    load_mfr(vp_sid);
                ELSIF vp_command = 'Delete' THEN
                    -- check for Status (can't delete after a certain point).
                    --if CFUNDS_TEST_CFP('CF_LIM_SET_ORG', 'NONE,' core_context.personnel_sid, v_HQ_CC_Unit_SID) = 'N' then
                    IF Cfunds_Test_Cfp('CF_LIM_SET_ORG',
                                       Core_Obj.lookup_objtype('NONE'),
                                       Core_Context.personnel_sid,
                                       Osi_Personnel.get_current_unit(Core_Context.personnel_sid)) = 'N' THEN
                        v_error_detail := 'You do not have privilege to delete this mfr.';
                        RAISE a_stink;
                    END IF;
        
                    DELETE FROM T_CFUNDS_MFR
                          WHERE SID = vp_sid;
        
                    COMMIT;
                    htp.p('Deletion of MFR succeeded.');
                    vp_sid := 'newone';
                ELSIF vp_command = 'Refresh' THEN
                    load_mfr(vp_sid);
                END IF;
        
                -- Set up the buttons that should show up.
                v_update_button :=
                    '<td vAlign=center><input type="button" value="Update MFR" name="pBtnUpdate" onclick="Do_Update()"></td>';
                v_save_button :=
                    '<td vAlign=center><input type="button" value="Save MFR" name="pBtnSave" onclick="Do_Save()"></td>';
                v_delete_button :=
                    '<td vAlign=center>&nbsp;&nbsp;&nbsp;<input type="button" value="Delete MFR" name="pBtnDelete" onclick="Do_Delete()"></td>';
        
                IF (vp_sid = 'newone') THEN
                    v_buttons := v_save_button;
                ELSE
                    v_buttons := v_update_button || v_delete_button;
                END IF;
        
                --htp.nl;
        
                -- get the template for mfr_details
                v_ok := Web_Template_Pkg.get_latest('cfunds_mfr_details', v_template, v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_mfr_details"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                -- Set the Sid here in the hidden input field.  Any earlier and updates and deletes will fail.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', vp_sid);
                -- replace the tags in the template with data
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self || '?a=1');
                -- remember the Fiscal Year
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', vp_fiscal_year);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'UNIT_NAME',
                                                 Cfunds_Pkg.lookup_cfunds_unit(vp_unit).unit_name);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'BUTTONS', v_buttons);
        
                IF (vp_sid = 'newone') THEN
                    v_ok :=
                          Web_Template_Pkg.replace_tag(v_template, 'CLAIMANT', Core_Context.personnel_name);
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                                           (v_template,
                                            'AMOUNT',
                                            '<input maxLength="10" size="10" name="pAmount" value="0.00" >');
                    v_ok :=
                        Web_Template_Pkg.replace_tag
                                         (v_template,
                                          'INCURRED_DATE',
                                          '<input maxLength="15" size="12" name="pIncurred_Date" value="'
                                          || TO_CHAR(SYSDATE, 'dd-Mon-yy') || '" >');
                    v_ok :=
                         Web_Template_Pkg.replace_tag(v_template, 'INCURRED_DATE_FORMAT', '&nbsp;dd-Mon-yy');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'PRECOMMENTS', '');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', '');
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'STATUS_DESC', '');
                ELSE
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'CLAIMANT', v_mfr_rec.submitted_by);
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'AMOUNT',
                                                     LTRIM(TO_CHAR(v_mfr_rec.amount, '99,999,990.00')));
                    v_ok :=
                          Web_Template_Pkg.replace_tag(v_template, 'INCURRED_DATE', v_mfr_rec.incurred_date);
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'INCURRED_DATE_FORMAT', '');
                    v_ok :=
                        Web_Template_Pkg.replace_tag(v_template,
                                                     'PRECOMMENTS',
                                                     htmlize_string(v_mfr_rec.comments));
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', v_mfr_rec.voucher_no);
                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'STATUS_DESC', v_mfr_rec.status);
                END IF;
        
                -- this is common to both  -- an empty text box.
                v_ok :=
                    Web_Template_Pkg.replace_tag
                           (v_template,
                            'COMMENTS',
                            '<textarea name="pComments" rows=5 cols=56 valign="top" width="590"></textarea>');
        
                -- this needed to process the page.
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
                    IF v_tag = 'AMT_SPENT_TOT' THEN
                        NULL;
                    ELSE
                        htp.print('[' || v_tag || ']');
                    END IF;
                END LOOP;
        
                end_serve_page;
                setunitsid(vp_unit);
                set_fiscal_year(vp_fiscal_year);
            EXCEPTION
                WHEN a_stink THEN
                    exception_handler(TRUE);
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
                WHEN Cfunds_Pkg.invalid_parameters THEN
                    exception_handler;
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
                WHEN Cfunds_Pkg.no_privilege THEN
                    exception_handler;
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
                WHEN OTHERS THEN
                    exception_handler;
                    end_serve_page;
                    setunitsid(vp_unit);
                    set_fiscal_year(vp_fiscal_year);
            END mfr_details;
        
            PROCEDURE navigation(punit IN VARCHAR2, pfiscalyear IN VARCHAR2 := NULL) IS
                v_template        CLOB;
                v_template_date   DATE;
                v_offset          NUMBER        := 1;
                v_tag             VARCHAR2(100);
                v_ok              BOOLEAN;
            BEGIN
                begin_serve_page('E-Funds Navigation', TRUE, TRUE, ' ', 'E-Funds Navigation', 'DoHistory');
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Navigation');
                v_ok := Web_Template_Pkg.get_latest('cfunds_navigation', v_template, v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_navigation"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                -- save these values to stay in same context (but not used for this page).
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', pfiscalyear);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', punit);
                v_ok := Web_Template_Pkg.serve_clob(v_template);
                end_serve_page;
                setunitsid(punit);
                set_fiscal_year(pfiscalyear);
            END navigation;
        
            PROCEDURE payment_listing_details(
                punit         IN   VARCHAR2,
                pprev_unit    IN   VARCHAR2,
                pxfr          IN   VARCHAR2,
                pcommand      IN   VARCHAR2,
                pfiscalyear   IN   VARCHAR2) IS
                v_template         CLOB;
                v_template_date    DATE;
                v_offset           NUMBER                         := 1;
                v_params_short     VARCHAR2(1000);
                v_params           VARCHAR2(1000);
                v_tag              VARCHAR2(100);
                v_query            VARCHAR2(4000);
                v_query_params     VARCHAR2(4000);
                v_cursor           INTEGER;
                v_ok               BOOLEAN;
                v_filter_list      VARCHAR2(1000);
                v_unit_name        VARCHAR2(50);
                v_unit             T_CFUNDS_UNIT.SID%TYPE;
                v_xfr              T_CFUNDS_XFR.SID%TYPE;
                v_usage            VARCHAR2(30);
                v_expense_total    NUMBER                         := 0;
                v_voucher          T_CFUNDS_XFR.voucher_no%TYPE;
                v_temp_unit        VARCHAR2(50)                   := 'none';
                v_html             VARCHAR2(3000);
                v_send_pending     BOOLEAN;
                v_hq               BOOLEAN;
                v_sender           T_CFUNDS_XFR.sender%TYPE;
                v_fiscal_year      VARCHAR2(10);
                v_command1_specs   VARCHAR2(400);
                v_command2_specs   VARCHAR2(400);
                v_prev_unit        VARCHAR2(100);
                v_next_unit        VARCHAR2(100);
                v_unit_found       BOOLEAN;
               -- pPrev_Unit is the previous unit who either reviewed or paid the expense.  This
            -- unit is who will be sent the payment when a transfer is done.
            BEGIN
                begin_serve_page('E-Funds Payment Listing',
                                 TRUE,
                                 TRUE,
                                 'E-Funds Payment Listing',
                                 NULL,
                                 'payment_listing_by_unit');
                Core_Logger.log_it(c_pipe,
                                   'Payment_Listing_Details v_unit ' || v_unit || ' pPrev_Unit '
                                   || pprev_unit);
                v_ok :=
                    Web_Template_Pkg.get_latest('cfunds_payment_listing_details',
                                                v_template,
                                                v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe,
                                       '  Could not locate template "cfunds_payment_listing_details"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                -- if the unit wasn't specified, use the current user's unit.
                v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                v_xfr := pxfr;                                                       -- sid of the transfer.
                -- if the fiscal year wasn't specified, use the current fiscal year.
                v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
        
                -- test for button clicks first, then after that test for parameters
                -- to see how to display the expense listing.
                IF pcommand = 'Pay Unit' THEN
                    Core_Logger.log_it(c_pipe,
                                       'Pay Unit v_unit ' || v_unit || ' pPrev_Unit ' || pprev_unit);
        
                    IF v_xfr IS NULL THEN
                        -- create new transfer record.
                        Core_Logger.log_it(c_pipe, 'Pay Unit v_xfr is null');
                        Cfunds_Pkg.reimburse_expenses(v_unit, pprev_unit, v_voucher, SYSDATE,
                                                      v_fiscal_year);
                        COMMIT;
                        v_usage := 'FinishXfr';
                        -- find the name of this unit whose data is showing.
                        v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(pprev_unit).unit_name;
                    ELSE
                        -- first check to make sure this user has the proper privilege
                        SELECT sender
                          INTO v_sender
                          FROM T_CFUNDS_XFR
                         WHERE SID = v_xfr;
        
                        IF Cfunds_Test_Cfp('EXP_INVALIDATE',
                                           Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                           Core_Context.personnel_sid,
                                           v_sender) = 'N' THEN
                            v_error_detail := 'You do not have privilege to reimburse these expenses.';
                            RAISE a_stink;
                        END IF;
        
                        -- write today's date into the transfer record that already exists.
                        UPDATE T_CFUNDS_XFR
                           SET send_date = SYSDATE,
                               modify_by = Core_Context.personnel_name,
                               modify_on = SYSDATE
                         WHERE SID = v_xfr;
        
                        -- test for errors.
                        IF SQL%rowcount < 1 THEN
                            v_error_detail := 'No transfer was found to update.';
                            RAISE a_stink;
                        END IF;
        
                        COMMIT;
        
                        SELECT voucher_no
                          INTO v_voucher
                          FROM T_CFUNDS_XFR
                         WHERE SID = v_xfr;
        
                        v_usage := 'CompleteXfr';
                    END IF;
                ELSIF pcommand = 'Mark all Reviewed' THEN
/*                    UPDATE v_cfunds_expense_v3 e
                       SET e.reviewed = 'Y',
                           e.review_history =
                               e.review_history || 'Reviewed in unit ' || e.reviewing_unit_name || ' by '
                               || Core_Context.personnel_name || ' on ' || SYSDATE || '.  '
                     WHERE TRUNC(e.incurred_date) BETWEEN Cfunds_Pkg.get_fiscal_year_start_date
                                                                                              (v_fiscal_year)
                                                      AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                       AND e.status = 'Paid'
                       AND NVL(e.reviewed, 'N') <> 'Y'
                       AND e.reviewing_unit = v_unit
                       AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) = pprev_unit;*/
                    UPDATE t_cfunds_expense_v3 e
                       SET e.reviewed = 'Y',
                           e.review_history =
                               e.review_history || 'Reviewed in unit ' || osi_unit.get_name(e.reviewing_unit) || ' by '
                               || Core_Context.personnel_name || ' on ' || SYSDATE || '.  '
                     WHERE TRUNC(e.incurred_date) BETWEEN Cfunds_Pkg.get_fiscal_year_start_date
                                                                                              (v_fiscal_year)
                                                      AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                       AND cfunds_pkg.get_expense_status(e.submitted_on,
                                                         e.approved_on,
                                                         e.rejected_on,
                                                         e.paid_on,
                                                         e.invalidated_on,
                                                         e.repaid_on,
                                                         e.reviewing_unit,
                                                         e.closed_on) = 'Paid'                       
                       AND NVL(e.reviewed, 'N') <> 'Y'
                       AND e.reviewing_unit = v_unit
                       AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) = pprev_unit;

        
                    -- test for errors.
                    IF SQL%rowcount < 1 THEN
                        v_error_detail := 'No expense records were found to update.';
                        RAISE a_stink;
                    END IF;
        
                    v_usage := 'StartXfr';
                    -- find the name of this unit whose data is showing.
                    v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(pprev_unit).unit_name;
                ELSIF pcommand = 'Send Listing' THEN
                    -- create a payment listing transfer, but do not send it yet.
                    Cfunds_Pkg.reimburse_expenses(v_unit, pprev_unit, v_voucher, NULL, v_fiscal_year);
                    COMMIT;
                    v_usage := 'PendingXfr';
                    -- find the name of this unit whose data is showing.
                    v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(pprev_unit).unit_name;
                ELSIF pprev_unit = v_unit THEN
                    v_usage := 'MyList';
                    -- find the name of this unit whose data is showing.
                    v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(pprev_unit).unit_name;
                ELSIF pxfr IS NOT NULL THEN
                    v_usage := 'ViewXfr';
                    -- find the name of this unit whose data is showing.
                    v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
                ELSIF pprev_unit IS NOT NULL THEN
                    v_usage := 'StartXfr';
                    -- find the name of this unit whose data is showing.
                    v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(pprev_unit).unit_name;
                ELSE
                    v_usage := 'Error';
                    v_error_detail := 'Not enough information was provided to find the requested data.';
                    RAISE a_stink;
                END IF;
        
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                -- remember the UNIT so the screen can be refreshed when the user changes the filters.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_FLAG', v_unit);
                v_prev_unit := 'bogus';
                v_next_unit := 'bogus';
                v_unit_found := FALSE;
        
                FOR pl IN
                    (SELECT   u.SID, u.unit_name, SUM(e.total_amount_us) AS total_pl_amount,
                              TRUNC(MIN(e.incurred_date)) AS oldest_expense
                         FROM v_cfunds_expense_v3 e, v_cfunds_unit u
                        WHERE TRUNC(e.incurred_date)
                                  BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                      AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                          AND e.status = 'Paid'
                          AND e.reviewing_unit = v_unit
                          AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) = u.SID
                     GROUP BY u.unit_name, u.SID
                     ORDER BY oldest_expense)
                LOOP
                    IF v_unit_found THEN
                        v_next_unit := pl.SID;
                        EXIT;
                    END IF;
        
                    IF pl.SID = pprev_unit THEN
                        v_unit_found := TRUE;
                    ELSE
                        v_prev_unit := pl.SID;
                    END IF;
                END LOOP;
        
                IF v_prev_unit = 'bogus' THEN
                    v_command1_specs := ' ';
                ELSE
                    v_command1_specs :=
                        '<input type="button" value="Previous Unit" onclick=location="'
                        || Web_Util_Pkg.get_current_package || 'payment_listing_details?pUnit=' || v_unit
                        || '&pPrev_Unit=' || v_prev_unit || '&pFiscalYear=' || pfiscalyear || '">';
                END IF;
        
                IF v_next_unit = 'bogus' THEN
                    v_command2_specs := ' ';
                ELSE
                    v_command2_specs :=
                        '<input type="button" value="Next Unit" onclick=location="'
                        || Web_Util_Pkg.get_current_package || 'payment_listing_details?pUnit=' || v_unit
                        || '&pPrev_Unit=' || v_next_unit || '&pFiscalYear=' || pfiscalyear || '">';
                END IF;
        
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_1', v_command1_specs);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_2', v_command2_specs);
                -- always display the fiscal year context.
                htp.p('Fiscal Year: ' || v_fiscal_year || '<br><br>');
        
                IF v_usage = 'FinishXfr' THEN
                    htp.p('A Payment Listing transfer has been created.<br>');
                    htp.p('Today''s date was used as the Sent Date.<br><br>');
                    htp.p('The ID number is ' || v_voucher || '.<br>');
                    v_usage := 'ViewXfr2';
                ELSIF v_usage = 'PendingXfr' THEN
                    htp.p('A Payment Listing transfer has been created.<br>');
                    htp.p
                        ('The date was not specified, meaning that the transfer hasn''t been actually sent yet.<br><br>');
                    htp.p('The ID number is ' || v_voucher || '.<br>');
                    htp.p
                        ('You will need to return to this payment listing and press the ''Pay Unit'' button when you send the money to the Unit.');
                    v_usage := 'ViewXfr2';
                ELSIF v_usage = 'CompleteXfr' THEN
                    htp.p('The selected Payment Listing transfer has been sent.<br>');
                    htp.p('Today''s date was used as the Sent Date<br><br>');
                    htp.p('for the Payment Listing transfer with ID number ' || v_voucher || '.<br>');
                    v_usage := 'ViewXfr2';
                END IF;
        
                Web_Util_Pkg.send_comment('the v_usage is: ' || v_usage);
        
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
                    IF v_tag = 'UNREVIEWED_EXPENSE_LIST' THEN
                        IF v_usage = 'StartXfr' THEN
                            v_expense_total := 0;
                            v_temp_unit := 'none';
        
                            FOR e IN
                                (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.SID, e.voucher_no,
                                          e.total_amount_us, e.category_desc, e.pec, e.paid_by,
                                          e.paragraph, e.CATEGORY, e.reviewed
                                     FROM v_cfunds_expense_v3 e
                                    WHERE TRUNC(e.incurred_date)
                                              BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                                  AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                                      AND e.status = 'Paid'
                                      AND NVL(e.reviewed, 'N') <> 'Y'
                                      AND e.reviewing_unit = v_unit
                                      AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) =
                                                                                                  pprev_unit
                                 ORDER BY e.charge_to_unit_name, e.incurred_date)
                            LOOP
                                IF v_temp_unit = 'none' THEN
                                    -- set up the table header first time through.
                                    htp.p
                                         ('<font size="+2"><b>Expenses not yet reviewed</b></font><br><br>');
                                    htp.p('<table border="1">');
                                    htp.p(' <tr>');
                                    htp.p('   <th nowrap>Unit of Expense</th>');
                                    htp.p('   <th nowrap>Expense ID</th>');
                                    htp.p('   <th nowrap>Total Amount</th>');
                                    htp.p('   <th nowrap>Category</th>');
                                    htp.p('   <th nowrap>PEC Code</th>');
                                    htp.p('   <th nowrap>Paid by</th>');
                                    htp.p(' </tr>');
                                    -- ensure this won't happen twice.
                                    v_temp_unit := 'done';
                                END IF;
        
                                IF v_temp_unit <> e.charge_to_unit THEN
                                    v_temp_unit := e.charge_to_unit;
                                    htp.tableRowOpen;
                                        htp.p('<td colspan="6">' || e.charge_to_unit_name || '</td>');
                                    htp.tableRowClose;
                                END IF;
        
                                htp.tableRowOpen;
                                    --htp.tableData(' ');
                                    htp.tabledata('&nbsp;');
                                    htp.p('<td nowrap>');
                                    htp.p('<a href="' || Web_Util_Pkg.get_current_package
                                          || 'expense_details?pSID=' || e.SID || '&pUnit=' || v_unit
                                          || '&pFiscalYear=' || v_fiscal_year || '&pCategory=' || e.CATEGORY
                                          || '&pParagraph=' || e.paragraph || '">');
                                    htp.p(e.voucher_no);
                                    htp.p('</a>');
                                    htp.p('</td>');
                                    htp.tabledata(TO_CHAR(e.total_amount_us, v_dollar_format),
                                                  'right',
                                                  NULL,
                                                  'true');
                                    htp.tabledata(e.category_desc, NULL, NULL, 'true');
                                    htp.tabledata(e.pec, NULL, NULL, 'true');
                                    htp.tabledata(e.paid_by, NULL, NULL, 'true');
                                htp.tableRowClose;
                                v_expense_total := v_expense_total + e.total_amount_us;
                            END LOOP;
        
                            IF v_temp_unit = 'none' THEN
                                htp.p('<!-- No Unreviewed expenses to list -->');
                            ELSE
                                htp.print('Unreviewed expenses total '
                                          || TO_CHAR(v_expense_total, v_dollar_format) || ' for unit: '
                                          || v_unit_name || '<br><br>');
        
                                -- if this user has a special persmission, put a button here
                                -- to allow all unreviewed expenses to be marked as reviewed.
                                IF Cfunds_Test_Cfp
                                                 ('EXP_MARK_REVIEWED',
                                                  Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                                  Core_Context.personnel_sid,
                                                  Osi_Personnel.get_current_unit(Core_Context.personnel_sid)) =
                                                                                                         'Y' THEN
                                    htp.print('<form  method="POST" action="'
                                              || Web_Util_Pkg.get_current_package
                                              || 'payment_listing_details?pUnit=' || v_unit
                                              || '&pPrev_Unit=' || pprev_unit || '&pFiscalYear='
                                              || v_fiscal_year || '">');
                                    htp.print
                                          ('<input type="submit" value="Mark all Reviewed" name="pCommand">');
                                    htp.print('</form>');
                                END IF;
        
                                -- end table.
                                htp.p('</table><br><hr><br>');
                            END IF;
                        ELSE
                            htp.p('<!-- tag doesn''t apply to this usage -->');
                        END IF;
                    ELSIF v_tag = 'EXPENSE_LIST' THEN
                        IF v_usage = 'StartXfr' THEN
                            v_expense_total := 0;
                            v_temp_unit := 'none';
        
                            FOR e IN
                                (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.SID, e.voucher_no,
                                          e.total_amount_us, e.category_desc, e.pec, e.paid_by,
                                          e.paragraph, e.CATEGORY, e.reviewed
                                     FROM v_cfunds_expense_v3 e
                                    WHERE TRUNC(e.incurred_date)
                                              BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                                  AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                                      AND e.status = 'Paid'
                                      AND NVL(e.reviewed, 'N') = 'Y'
                                      AND e.reviewing_unit = v_unit
                                      AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) =
                                                                                                  pprev_unit
                                 ORDER BY e.charge_to_unit_name, e.incurred_date)
                            LOOP
                                IF v_temp_unit <> e.charge_to_unit THEN
                                    v_temp_unit := e.charge_to_unit;
                                    htp.tableRowOpen;
                                        htp.p('<td colspan="6">' || e.charge_to_unit_name || '</td>');
                                    htp.tableRowClose;
                                END IF;
        
                                htp.tableRowOpen;
                                    htp.tabledata(' ');
                                    htp.p('<td nowrap>');
                                    htp.p('<a href="' || Web_Util_Pkg.get_current_package
                                          || 'expense_details?pSID=' || e.SID || '&pUnit=' || v_unit
                                          || '&pFiscalYear=' || v_fiscal_year || '&pCategory=' || e.CATEGORY
                                          || '&pParagraph=' || e.paragraph || '">');
                                    htp.p(e.voucher_no);
                                    htp.p('</a>');
                                    htp.p('</td>');
                                    htp.tabledata(TO_CHAR(e.total_amount_us, v_dollar_format),
                                                  'right',
                                                  NULL,
                                                  'true');
                                    htp.tabledata(e.category_desc, NULL, NULL, 'true');
                                    htp.tabledata(e.pec, NULL, NULL, 'true');
                                    htp.tabledata(e.paid_by, NULL, NULL, 'true');
                                htp.tableRowClose;
                                v_expense_total := v_expense_total + e.total_amount_us;
                            END LOOP;
        
                            IF v_temp_unit = 'none' THEN
                                htp.p('<tr><td colspan="6">No Reviewed expenses</td></tr>');
                            END IF;
        
                            htp.p('<font size="+2"><b>Reviewed Expenses</b></font><br><br>');
                            htp.print('Reviewed expenses total '
                                      || TO_CHAR(v_expense_total, v_dollar_format) || ' for unit: '
                                      || v_unit_name);
                            --  print a button to send the user to this form to create a transfer to reimburse expenses.
                            htp.print('<form  method="POST" action="' || Web_Util_Pkg.get_current_package
                                      || 'payment_listing_details?pUnit=' || v_unit || '&pPrev_Unit='
                                      || pprev_unit || '&pFiscalYear=' || v_fiscal_year || '">');
                            htp.print('<input type="submit" value="Pay Unit" name="pCommand">');
                            htp.print('<input type="submit" value="Send Listing" name="pCommand">');
                            --  print a button to allow the user to print the Payment Listing.
                            htp.print
                                ('<input type="button" value="Print Payment Listing"  onclick=''PrintForm("'
                                 || Web_Util_Pkg.get_current_package || 'payment_listing_form?pUnit='
                                 || v_unit || '&pPrev_Unit=' || pprev_unit || '&pFiscalYear='
                                 || v_fiscal_year || '")'' name="pCommand"><br><br>');
                            htp.print('</form>');
                        ELSIF v_usage = 'MyList' THEN
                            v_temp_unit := 'none';
        
                            FOR e IN
                                (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.reviewing_unit, e.SID,
                                          e.voucher_no, e.total_amount_us, e.category_desc, e.pec,
                                          e.paid_by, e.paragraph, e.CATEGORY
                                     FROM v_cfunds_expense_v3 e
                                    WHERE TRUNC(e.incurred_date)
                                              BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                                  AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                                      AND e.status = 'Paid'
                                      AND (   (Cfunds_Pkg.get_submitting_unit(e.reviewing_unit,
                                                                              e.charge_to_unit) = v_unit)
                                           OR (    e.reviewing_unit = e.charge_to_unit
                                               AND e.reviewing_unit = v_unit))
                                 ORDER BY e.charge_to_unit_name, e.incurred_date)
                            LOOP
                                IF v_temp_unit <> e.charge_to_unit THEN
                                    v_temp_unit := e.charge_to_unit;
                                    htp.tableRowOpen;
                                        htp.p('<td colspan="6">' || e.charge_to_unit_name || '</td>');
                                    htp.tableRowClose;
                                END IF;
        
                                IF e.reviewing_unit = e.charge_to_unit THEN
                                    v_hq := TRUE;
                                END IF;
        
                                htp.tableRowOpen;
                                    htp.tabledata(' ');
                                    htp.p('<td nowrap>');
                                    htp.p('<a href="' || Web_Util_Pkg.get_current_package
                                          || 'expense_details?pSID=' || e.SID || '&pUnit=' || v_unit
                                          || '&pFiscalYear=' || v_fiscal_year || '&pCategory=' || e.CATEGORY
                                          || '&pParagraph=' || e.paragraph || '">');
                                    htp.p(e.voucher_no);
                                    htp.p('</a>');
                                    htp.p('</td>');
                                    htp.tabledata(TO_CHAR(e.total_amount_us, v_dollar_format),
                                                  'right',
                                                  NULL,
                                                  'true');
                                    htp.tabledata(e.category_desc, NULL, NULL, 'true');
                                    htp.tabledata(e.pec, NULL, NULL, 'true');
                                    htp.tabledata(e.paid_by, NULL, NULL, 'true');
                                htp.tableRowClose;
                                v_expense_total := v_expense_total + e.total_amount_us;
                            END LOOP;
        
                            htp.print('Expenses total ' || TO_CHAR(v_expense_total, v_dollar_format)
                                      || ' for unit: ' || v_unit_name);
                            htp.print('<form  method="POST" action="' || Web_Util_Pkg.get_current_package
                                      || 'payment_listing_details?pUnit=' || v_unit || '&pPrev_unit='
                                      || pprev_unit || '&pFiscalYear=' || v_fiscal_year || '">');
        
                            IF v_hq THEN
                                -- print a button to allow HQ to reimburse iteself (DFAS actually).
                                htp.print('<input type="submit" value="Pay Unit" name="pCommand">');
                            END IF;
        
                            --  print a button to allow the user to print the Payment Listing.
                            htp.print
                                ('<input type="button" value="Print Payment Listing"  onclick=''PrintForm("'
                                 || Web_Util_Pkg.get_current_package || 'payment_listing_form?pUnit='
                                 || v_unit || '&pPrev_Unit=' || pprev_unit || '&pFiscalYear='
                                 || v_fiscal_year || '")'' name="pCommand"></form>');
                        ELSIF v_usage = 'ViewXfr' THEN
                            v_temp_unit := 'none';
        
                            FOR e IN (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.SID,
                                               e.voucher_no, e.total_amount_us, e.category_desc, e.pec,
                                               e.paid_by, e.paragraph, e.CATEGORY
                                          FROM v_cfunds_expense_v3 e, T_CFUNDS_XFR_EXP xe, T_CFUNDS_XFR x
                                         WHERE x.SID = v_xfr AND x.SID = xe.xfr AND e.SID = xe.expense
                                      ORDER BY e.charge_to_unit_name, e.incurred_date)
                            LOOP
                                IF v_temp_unit <> e.charge_to_unit THEN
                                    v_temp_unit := e.charge_to_unit;
                                    htp.tableRowOpen;
                                        htp.p('<td colspan="6">' || e.charge_to_unit_name || '</td>');
                                    htp.tableRowClose;
                                END IF;
        
                                htp.tableRowOpen;
                                    htp.tabledata(' ');
                                    htp.p('<td nowrap>');
                                    htp.p('<a href="' || Web_Util_Pkg.get_current_package
                                          || 'expense_details?pSID=' || e.SID || '&pUnit=' || v_unit
                                          || '&pFiscalYear=' || v_fiscal_year || '&pCategory=' || e.CATEGORY
                                          || '&pParagraph=' || e.paragraph || '">');
                                    htp.p(e.voucher_no);
                                    htp.p('</a>');
                                    htp.p('</td>');
                                    htp.tabledata(TO_CHAR(e.total_amount_us, v_dollar_format),
                                                  'right',
                                                  NULL,
                                                  'true');
                                    htp.tabledata(e.category_desc, NULL, NULL, 'true');
                                    htp.tabledata(e.pec, NULL, NULL, 'true');
                                    htp.tabledata(e.paid_by, NULL, NULL, 'true');
                                htp.tableRowClose;
                            END LOOP;
        
                            FOR x IN (SELECT SID, voucher_no, amount, sender_name, sender, receiver,
                                             receiver_name, send_date, receive_date, create_on
                                        FROM v_cfunds_xfr
                                       WHERE SID = v_xfr)
                            LOOP
                                v_html := 'ID Number: ';
                                v_html := v_html || x.voucher_no;
                                v_html := v_html || '<br> Transfer amount: ';
                                v_html := v_html || TO_CHAR(x.amount, v_dollar_format);
                                v_html := v_html || '<br> Sent from: ';
                                v_html := v_html || x.sender_name;
                                v_html := v_html || '<br> Sent to: ';
                                v_html := v_html || x.receiver_name;
        
                                IF x.send_date IS NOT NULL THEN
                                    v_html := v_html || '<br> Date sent: ';
                                    v_html := v_html || TO_CHAR(x.send_date, 'dd-Mon-yyyy');
                                ELSE
                                    v_send_pending := TRUE;
                                    v_html := v_html || '<br> This transfer has not been sent.';
                                END IF;
        
                                IF x.receive_date IS NOT NULL THEN
                                    v_html := v_html || '<br>  Date received: ';
                                    v_html := v_html || TO_CHAR(x.receive_date, 'dd-Mon-yyyy');
                                ELSE
                                    v_html := v_html || '<br>  This transfer has not been received.';
                                END IF;
        
                                IF v_send_pending THEN
                                    v_html :=
                                        v_html || '<br> (It was created on '
                                        || TO_CHAR(x.create_on, 'dd-Mon-yyyy') || '.)';
                                END IF;
        
                                v_html := v_html || '<br><br>';
                                v_html := v_html || '<h3>This transfer covers the following expenses:</h3>';
                            END LOOP;
        
                            --  print a button to allow the user to print the Payment Listing.
                            htp.print('<form  method="POST" action="' || Web_Util_Pkg.get_current_package
                                      || 'payment_listing_details?pUnit=' || v_unit || '&pXfr=' || v_xfr
                                      || '&pFiscalYear=' || v_fiscal_year || '">');
        
                            IF v_send_pending THEN
                                htp.print('<input type="submit" value="Pay Unit" name="pCommand">');
                            END IF;
        
                            htp.print
                                ('<input type="button" value="Print Payment Listing"  onclick=''PrintForm("'
                                 || Web_Util_Pkg.get_current_package || 'payment_listing_form?pUnit='
                                 || v_unit || '&pXfr=' || v_xfr || '&pFiscalYear=' || v_fiscal_year
                                 || '")'' name="pCommand"></form>');
                            htp.p(v_html);
                        ELSIF v_usage = 'ViewXfr2' THEN
                            v_xfr := NULL;
                            v_temp_unit := 'none';
        
                            FOR e IN (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.SID,
                                               e.voucher_no, e.total_amount_us, e.category_desc, e.pec,
                                               e.paid_by, e.paragraph, e.CATEGORY, x.SID AS xfr_sid
                                          FROM v_cfunds_expense_v3 e, T_CFUNDS_XFR_EXP xe, T_CFUNDS_XFR x
                                         WHERE x.voucher_no = v_voucher
                                           AND x.SID = xe.xfr
                                           AND e.SID = xe.expense
                                      ORDER BY e.charge_to_unit_name, e.incurred_date)
                            LOOP
                                IF v_temp_unit <> e.charge_to_unit THEN
                                    v_temp_unit := e.charge_to_unit;
                                    htp.tableRowOpen;
                                        htp.p('<td colspan="6">' || e.charge_to_unit_name || '</td>');
                                    htp.tableRowClose;
                                END IF;
        
                                IF v_xfr IS NULL THEN
                                    v_xfr := e.xfr_sid;
                                END IF;
        
                                htp.tableRowOpen;
                                    htp.tabledata(' ');
                                    htp.p('<td nowrap>');
                                    htp.p('<a href="' || Web_Util_Pkg.get_current_package
                                          || 'expense_details?pSID=' || e.SID || '&pUnit=' || v_unit
                                          || '&pFiscalYear=' || v_fiscal_year || '&pCategory=' || e.CATEGORY
                                          || '&pParagraph=' || e.paragraph || '">');
                                    htp.p(e.voucher_no);
                                    htp.p('</a>');
                                    htp.p('</td>');
                                    htp.tabledata(TO_CHAR(e.total_amount_us, v_dollar_format),
                                                  'right',
                                                  NULL,
                                                  'true');
                                    htp.tabledata(e.category_desc, NULL, NULL, 'true');
                                    htp.tabledata(e.pec, NULL, NULL, 'true');
                                    htp.tabledata(e.paid_by, NULL, NULL, 'true');
                                htp.tableRowClose;
                            END LOOP;
        
                            --  print a button to allow the user to print the Payment Listing.
                            htp.print('<form  method="POST" action="' || Web_Util_Pkg.get_current_package
                                      || 'payment_listing_details?pUnit=' || v_unit || '&pXfr=' || v_xfr
                                      || '&pFiscalYear=' || v_fiscal_year || '">');
                            htp.print
                                ('<input type="button" value="Print Payment Listing"  onclick=''PrintForm("'
                                 || Web_Util_Pkg.get_current_package || 'payment_listing_form?pUnit='
                                 || v_unit || '&pXfr=' || v_xfr || '&pFiscalYear=' || v_fiscal_year
                                 || '")'' name="pCommand"></form>');
                        ELSE
                            htp.p('error');
                        END IF;
                    ELSE
                        htp.print('[' || v_tag || ']');
                    END IF;
                END LOOP;
        
                end_serve_page;
                setunitsid(v_unit);
                set_fiscal_year(v_fiscal_year);
                COMMIT;
            EXCEPTION
                WHEN a_stink THEN
                    exception_handler(TRUE);
                    end_serve_page;
                    setunitsid(v_unit);
                    set_fiscal_year(v_fiscal_year);
                WHEN Cfunds_Pkg.bad_timing THEN
                    exception_handler;
                    end_serve_page;
                    setunitsid(v_unit);
                    set_fiscal_year(v_fiscal_year);
                WHEN Cfunds_Pkg.no_privilege THEN
                    exception_handler;
                    end_serve_page;
                    setunitsid(v_unit);
                    set_fiscal_year(v_fiscal_year);
            END payment_listing_details;
        
            PROCEDURE payment_listing_form(
                punit         IN   VARCHAR2,
                pprev_unit    IN   VARCHAR2,
                pxfr          IN   VARCHAR2,
                pfiscalyear   IN   VARCHAR2) IS
                v_template                 CLOB;
                v_template_eft             CLOB;
                v_template_date            DATE;
                v_offset                   NUMBER                             := 1;
                v_params_short             VARCHAR2(1000);
                v_params                   VARCHAR2(1000);
                v_tag                      VARCHAR2(100);
                v_query                    VARCHAR2(4000);
                v_query_params             VARCHAR2(4000);
                v_cursor                   INTEGER;
                v_ok                       BOOLEAN;
                v_ok_eft                   BOOLEAN;
                v_tag_eft                  VARCHAR2(100);
                v_offset_eft               NUMBER                             := 1;
                v_filter_list              VARCHAR2(1000);
                v_unit_name                VARCHAR2(50);
                v_unit                     T_CFUNDS_UNIT.SID%TYPE;
                -- the unit whose name and data will be shown- the 'owner' unit of this payment listing.
                v_total_payment_due_unit   NUMBER                             := 0;
                v_total_ci                 NUMBER                             := 0;
                v_total_sia                NUMBER                             := 0;
                v_total_fpd                NUMBER                             := 0;
                v_expense_total            NUMBER                             := 0;
                v_eft_string               VARCHAR2(10000);
                -- the template for the eft info is changed from clob to varchar2 type.
                v_html                     CLOB;
                v_usage                    VARCHAR2(50)                       := 'none';
                v_temp_unit                T_CFUNDS_UNIT.SID%TYPE;
                v_xfr                      T_CFUNDS_XFR.SID%TYPE;
                v_unit_eft_aba             T_CFUNDS_UNIT.eft_aba%TYPE;
                v_unit_eft_dan             T_CFUNDS_UNIT.eft_dan%TYPE;
                v_unit_eft_acct_desc       T_CFUNDS_UNIT.eft_acct_desc%TYPE;
                v_voucher_no               T_CFUNDS_XFR.voucher_no%TYPE       := 'Unofficial Report';
                v_listing_date             T_CFUNDS_XFR.send_date%TYPE        := SYSDATE;
                v_receiver                 T_CFUNDS_XFR.receiver%TYPE;
                v_fiscal_year              VARCHAR2(10);
            --    pPrev_Unit is the Previous Unit who approved these expenses.  THis is the unit
             --   that will get the Payment.
            BEGIN
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Payment_Listing_Form');
                v_xfr := pxfr;
        
                IF pprev_unit = punit THEN
                    v_usage := 'MyList';
                    v_unit := pprev_unit;
                ELSIF pxfr IS NOT NULL THEN
                    v_usage := 'ViewXfr';
        
                    SELECT receiver
                      INTO v_receiver
                      FROM T_CFUNDS_XFR
                     WHERE SID = pxfr;
        
                    v_unit := v_receiver;
                ELSIF pprev_unit IS NOT NULL THEN
                    v_usage := 'StartXfr';
                    v_unit := pprev_unit;
                ELSE
                    v_usage := 'Error';
                    v_error_detail := 'Not enough information was provided to find the requested data.';
                    RAISE a_stink;
                END IF;
        
                -- if the fiscal year wasn't specified, use the current fiscal year.
                v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                Web_Util_Pkg.send_comment('Usage is:' || v_usage);
                Web_Util_Pkg.send_comment('pUnit is:' || punit);
                Web_Util_Pkg.send_comment('pPrev_Unit is:' || pprev_unit);
                -- find the name of this unit whose data is showing.
                v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
                -- look for any EFT info for this unit.
                            --  if none found, don't show the EFT page at all.
                v_unit_eft_aba := Cfunds_Pkg.lookup_cfunds_unit(v_unit).eft_aba;
                Web_Util_Pkg.send_comment('eft aba value is: ' || v_unit_eft_aba);
                v_ok :=
                     Web_Template_Pkg.get_latest('cfunds_payment_listing_form', v_template, v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_payment_listing_form"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                -- remember the UNIT so the screen can be refreshed when the user changes the filters.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_FLAG', punit);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
        
                IF v_usage = 'StartXfr' THEN
                    v_temp_unit := 'none';
        
                    FOR e IN
                        (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.SID, e.voucher_no,
                                  e.total_amount_us, e.category_desc, e.pec, e.paid_by, e.paragraph,
                                  e.CATEGORY
                             FROM v_cfunds_expense_v3 e
                            WHERE TRUNC(e.incurred_date)
                                      BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                          AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                              AND e.status = 'Paid'
                              AND NVL(e.reviewed, 'N') = 'Y'
                              AND e.reviewing_unit = punit
                              AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) =
                                                                                                  pprev_unit
                         ORDER BY e.charge_to_unit_name, e.incurred_date)
                    LOOP
                        IF v_temp_unit <> e.charge_to_unit THEN
                            v_temp_unit := e.charge_to_unit;
                            append_info_to_clob(v_html,
                                                '<tr><td colspan="6">' || e.charge_to_unit_name
                                                || '</td></tr>',
                                                '');
                        END IF;
        
                        append_info_to_clob(v_html, '<tr>', '');
                        append_info_to_clob(v_html, '<td></td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.voucher_no || '</td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.category_desc || '</td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.paid_by || '</td>', '');
                        append_info_to_clob(v_html,
                                            '<td nowrap align="right">'
                                            || TO_CHAR(e.total_amount_us, v_dollar_format) || '</td>',
                                            '');
                        append_info_to_clob(v_html, '</tr>', '');
        
                        IF e.pec = 'CI' THEN
                            v_total_ci := v_total_ci + e.total_amount_us;
                        ELSIF e.pec = 'FPD' THEN
                            v_total_fpd := v_total_fpd + e.total_amount_us;
                        ELSE
                            v_total_sia := v_total_sia + e.total_amount_us;
                        END IF;
        
                        v_expense_total := v_expense_total + e.total_amount_us;
                    END LOOP;
                ELSIF v_usage = 'MyList' THEN
                    v_temp_unit := 'none';
        
                    FOR e IN
                        (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.SID, e.voucher_no,
                                  e.total_amount_us, e.category_desc, e.pec, e.paid_by, e.paragraph,
                                  e.CATEGORY
                             FROM v_cfunds_expense_v3 e
                            WHERE TRUNC(e.incurred_date)
                                      BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                          AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                              AND e.status = 'Paid'
                              AND (   (Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) =
                                                                                                       punit)
                                   OR (e.reviewing_unit = e.charge_to_unit AND e.reviewing_unit = punit))
                         ORDER BY e.charge_to_unit_name, e.incurred_date)
                    LOOP
                        IF v_temp_unit <> e.charge_to_unit THEN
                            v_temp_unit := e.charge_to_unit;
                            append_info_to_clob(v_html,
                                                '<tr><td colspan="6">' || e.charge_to_unit_name
                                                || '</td></tr>',
                                                '');
                        END IF;
        
                        append_info_to_clob(v_html, '<tr>', '');
                        append_info_to_clob(v_html, '<td></td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.voucher_no || '</td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.category_desc || '</td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.paid_by || '</td>', '');
                        append_info_to_clob(v_html,
                                            '<td nowrap align="right">'
                                            || TO_CHAR(e.total_amount_us, v_dollar_format) || '</td>',
                                            '');
                        append_info_to_clob(v_html, '</tr>', '');
        
                        IF e.pec = 'CI' THEN
                            v_total_ci := v_total_ci + e.total_amount_us;
                        ELSIF e.pec = 'FPD' THEN
                            v_total_fpd := v_total_fpd + e.total_amount_us;
                        ELSE
                            v_total_sia := v_total_sia + e.total_amount_us;
                        END IF;
        
                        v_expense_total := v_expense_total + e.total_amount_us;
                    END LOOP;
                ELSIF v_usage = 'ViewXfr' THEN
                    v_temp_unit := 'none';
        
                    FOR e IN (SELECT   e.charge_to_unit_name, e.charge_to_unit, e.SID, e.voucher_no,
                                       e.total_amount_us, e.category_desc, e.pec, e.paid_by, e.paragraph,
                                       e.CATEGORY
                                  FROM v_cfunds_expense_v3 e, T_CFUNDS_XFR_EXP xe, T_CFUNDS_XFR x
                                 WHERE x.SID = v_xfr AND x.SID = xe.xfr AND e.SID = xe.expense
                              ORDER BY e.charge_to_unit_name, e.incurred_date)
                    LOOP
                        IF v_temp_unit <> e.charge_to_unit THEN
                            v_temp_unit := e.charge_to_unit;
                            append_info_to_clob(v_html,
                                                '<tr><td colspan="6">' || e.charge_to_unit_name
                                                || '</td></tr>',
                                                '');
                        END IF;
        
                        append_info_to_clob(v_html, '<tr>', '');
                        append_info_to_clob(v_html, '<td></td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.voucher_no || '</td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.category_desc || '</td>', '');
                        append_info_to_clob(v_html, '<td nowrap>' || e.paid_by || '</td>', '');
                        append_info_to_clob(v_html,
                                            '<td nowrap align="right">'
                                            || TO_CHAR(e.total_amount_us, v_dollar_format) || '</td>',
                                            '');
                        append_info_to_clob(v_html, '</tr>', '');
        
                        IF e.pec = 'CI' THEN
                            v_total_ci := v_total_ci + e.total_amount_us;
                        ELSIF e.pec = 'FPD' THEN
                            v_total_fpd := v_total_fpd + e.total_amount_us;
                        ELSE
                            v_total_sia := v_total_sia + e.total_amount_us;
                        END IF;
        
                        v_expense_total := v_expense_total + e.total_amount_us;
                    END LOOP;
        
                    FOR x IN (SELECT SID, voucher_no, amount, sender_name, sender, receiver, receiver_name,
                                     send_date, receive_date
                                FROM v_cfunds_xfr
                               WHERE SID = v_xfr)
                    LOOP
                        -- the following tags are for the EFT page only.
                        v_voucher_no := x.voucher_no;
                        v_listing_date := x.send_date;
                        -- the following tags are the guts of the payment listing report.
                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'PL_ID_NUMBER', x.voucher_no);
                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'SYSTEM_DATE', x.send_date);
                    END LOOP;
                ELSE
                    append_info_to_clob(v_html, 'error', '');
                END IF;
        
                -- the following tags are the guts of the payment listing report.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'PL_ID_NUMBER', 'Unofficial Report');
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SYSTEM_DATE', SYSDATE);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_NAME_2', v_unit_name);
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'EXPENSE_LIST', v_html);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'FPD_TOTAL',
                                                 TO_CHAR(v_total_fpd, v_dollar_format));
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'SIA_TOTAL',
                                                 TO_CHAR(v_total_sia, v_dollar_format));
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'CI_TOTAL',
                                                 TO_CHAR(v_total_ci, v_dollar_format));
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'EXPENSE_TOTAL',
                                                 TO_CHAR(v_expense_total, v_dollar_format));
        
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
                    IF v_tag = 'EFT_INFO_SECTION' THEN
                        -- look for EFT info; if none found, don't show the EFT page at all.
                        IF v_unit_eft_aba IS NOT NULL THEN
                            -- if EFT info was found, lookup other EFT info for this unit.
                            v_unit_eft_dan := Cfunds_Pkg.lookup_cfunds_unit(v_unit).eft_dan;
                            v_unit_eft_acct_desc := Cfunds_Pkg.lookup_cfunds_unit(v_unit).eft_acct_desc;
                            v_ok :=
                                Web_Template_Pkg.get_latest('cfunds_payment_listing_eft_section',
                                                            v_template_eft,
                                                            v_template_date);
        
                            IF v_template_date IS NULL THEN
                                Core_Logger.log_it
                                        (c_pipe,
                                         '  Could not locate template "cfunds_payment_listing_eft_section"');
                                htp.print('Could not locate template');
                                RETURN;
                            END IF;
        
                            -- the following tags are for the EFT page only.
                            v_ok := Web_Template_Pkg.replace_tag(v_template_eft, 'ID_NUMBER', v_voucher_no);
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template_eft, 'LISTING_DATE', v_listing_date);
                            v_ok := Web_Template_Pkg.replace_tag(v_template_eft, 'UNIT_NAME', v_unit_name);
                            v_ok :=
                                  Web_Template_Pkg.replace_tag(v_template_eft, 'FISCAL_YEAR', v_fiscal_year);
                            v_ok :=
                                  Web_Template_Pkg.replace_tag(v_template_eft, 'UNIT_NAME_TWO', v_unit_name);
                            v_ok :=
                                 Web_Template_Pkg.replace_tag(v_template_eft, 'ROUTING_NUM', v_unit_eft_aba);
                            v_ok :=
                                 Web_Template_Pkg.replace_tag(v_template_eft, 'ACCOUNT_NUM', v_unit_eft_dan);
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template_eft,
                                                             'ACCOUNT_DESC',
                                                             v_unit_eft_acct_desc);
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template_eft,
                                                             'FPD_TOTAL_ONE',
                                                             TO_CHAR(v_total_fpd, v_dollar_format));
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template_eft,
                                                             'SIA_TOTAL_ONE',
                                                             TO_CHAR(v_total_sia, v_dollar_format));
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template_eft,
                                                             'CI_TOTAL_ONE',
                                                             TO_CHAR(v_total_ci, v_dollar_format));
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template_eft,
                                                             'TOTAL',
                                                             TO_CHAR(v_expense_total, v_dollar_format));
        
                            LOOP
                                v_ok_eft :=
                                    Web_Template_Pkg.serve_page(v_template_eft,
                                                                'WEBTOK@',
                                                                v_offset_eft,
                                                                v_tag_eft);
                                EXIT WHEN NOT v_ok_eft
                                      OR (v_tag_eft IS NULL);
                            END LOOP;
                        END IF;
                    ELSE
                        htp.print('[' || v_tag || ']');
                    END IF;
                END LOOP;
        
                -- close and free up the clob
                dbms_lob.CLOSE(v_html);
                dbms_lob.freetemporary(v_html);
            END payment_listing_form;
        
            PROCEDURE payment_listing_by_unit(punit IN VARCHAR2, pfiscalyear IN VARCHAR2) IS
                v_template        CLOB;
                v_template_date   DATE;
                v_offset          NUMBER                   := 1;
                v_params_short    VARCHAR2(1000);
                v_params          VARCHAR2(1000);
                v_tag             VARCHAR2(100);
                v_query           VARCHAR2(4000);
                v_query_params    VARCHAR2(4000);
                v_cursor          INTEGER;
                v_ok              BOOLEAN;
                v_filter_list     VARCHAR2(1000);
                v_unit_name       VARCHAR2(50);
                v_unit            T_CFUNDS_UNIT.SID%TYPE;
                v_fiscal_year     VARCHAR2(10);
                v_data_written    BOOLEAN                  := FALSE;
            BEGIN
                -- if the unit wasn't specified, use the current user's unit.
                v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                Core_Logger.log_it(c_pipe, 'Payment_Listing_by_Unit v_unit is ' || v_unit);
                -- if the fiscal year wasn't specified, use the current fiscal year.
                v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                -- find the name of this unit whose subordinate units are showing.
                v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
                begin_serve_page('E-Funds Payment Listings',
                                 TRUE,
                                 TRUE,
                                 '',
                                 'E-Funds Payment Listings',
                                 'home_page');
                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Payment_Listing_by_Unit');
                v_ok :=
                    Web_Template_Pkg.get_latest('cfunds_payment_listing_by_unit',
                                                v_template,
                                                v_template_date);
        
                IF v_template_date IS NULL THEN
                    Core_Logger.log_it(c_pipe,
                                       '  Could not locate template "cfunds_payment_listing_by_unit"');
                    htp.print('Could not locate template');
                    RETURN;
                END IF;
        
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                -- remember the UNIT so the screen can be refreshed when hte user changes the filters.
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_FLAG', v_unit);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'UNIT_NAME',
                                                 Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'UNIT_NAME_2',
                                                 Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name);
                -- remember the Fiscal Year
                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
                v_ok :=
                    Web_Template_Pkg.replace_tag(v_template,
                                                 'FISCAL_YEAR_LABEL',
                                                 get_html_fy_dropdown(v_fiscal_year));
        
                LOOP
                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                    EXIT WHEN NOT v_ok
                          OR (v_tag IS NULL);
        
                    -- Now process each found tag
                    IF v_tag = 'UNIT_LIST' THEN
                        v_data_written := FALSE;
        
                        FOR pl IN
                            (SELECT   u.SID, u.unit_name, SUM(e.total_amount_us) AS total_pl_amount,
                                      TRUNC(MIN(e.incurred_date)) AS oldest_expense
                                 FROM v_cfunds_expense_v3 e, v_cfunds_unit u
                                WHERE TRUNC(e.incurred_date)
                                          BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                              AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                                  AND e.status = 'Paid'
                                  AND e.reviewing_unit = v_unit
                                  AND Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) =
                                                                                                       u.SID
                             GROUP BY u.unit_name, u.SID
                             ORDER BY oldest_expense DESC)
                        LOOP
                            -- indicate that a row is in the table now.
                            v_data_written := TRUE;
                            htp.tableRowOpen;
                                htp.p('<td>');
                                htp.p('<a  href="' || Web_Util_Pkg.get_current_package
                                      || 'payment_listing_details?pUnit=' || v_unit || '&pPrev_Unit=' || pl.SID
                                      || '&pFiscalYear=' || v_fiscal_year || '">');
                                htp.p(pl.unit_name);
                                htp.p('</a>');
                                htp.p('</td>');
                                htp.tabledata(TO_CHAR(pl.total_pl_amount, v_dollar_format), 'right');
                                htp.tabledata(pl.oldest_expense, 'right');
                            htp.tableRowClose;
                        END LOOP;
        
                        IF NOT v_data_written THEN
                            htp.tableRowOpen;
                                htp.p('<td colspan="3">');
                                htp.p('No entries found.');
                                htp.p('</td>');
                            END IF;
                        ELSIF v_tag = 'MY_LIST_LINK' THEN
                            FOR pl IN
                                (SELECT SUM(e.total_amount_us) AS total_pl_amount,
                                        TRUNC(MIN(e.incurred_date)) AS oldest_expense
                                   FROM v_cfunds_expense_v3 e
                                  WHERE     TRUNC(e.incurred_date)
                                                BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                                    AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                                        AND e.status = 'Paid'
                                        AND (Cfunds_Pkg.get_submitting_unit(e.reviewing_unit, e.charge_to_unit) =
                                                                                                          v_unit)
                                     OR (e.reviewing_unit = e.charge_to_unit AND e.reviewing_unit = v_unit))
                            LOOP
                                IF pl.total_pl_amount IS NULL THEN
                                    htp.p('There are no expenses to be reimbursed to '
                                          || Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name);
                                ELSE
                                    htp.p('<a  href="' || Web_Util_Pkg.get_current_package
                                          || 'payment_listing_details?pUnit=' || v_unit || '&pPrev_Unit='
                                          || v_unit || '&pFiscalYear=' || v_fiscal_year || '">');
                                    htp.p('View my payment listing (total = $' || pl.total_pl_amount || ')');
                                    htp.p('</a>');
                                END IF;
                            END LOOP;
                        ELSIF v_tag = 'SENT_LIST' THEN
                            -- list of sent payment listings.
                            -- filtered for the selected fiscal year.
                            v_data_written := FALSE;
            
                            FOR pl IN (SELECT   t.SID, t.receiver, t.sender, t.voucher_no, t.send_date,
                                                t.amount, t.sender_name, t.receiver_name, t.status,
                                                t.fiscal_year
                                           FROM v_cfunds_xfr t
                                          WHERE t.sender = v_unit
                                            AND t.xfr_type = 'ER'
                                            AND t.fiscal_year = v_fiscal_year
                                       ORDER BY t.send_date DESC)
                            LOOP
                                -- indicate that a row is in the table now.
                                v_data_written := TRUE;
                                htp.tableRowOpen;
                                    htp.p('<td>');
                
                                    IF pl.status = 'Send Pending' THEN
                                        htp.p('<a  href="' || Web_Util_Pkg.get_current_package
                                              || 'transfer_details?pSID=' || pl.SID || '&pSend_To=' || pl.receiver
                                              || '&pUnit=' || pl.sender || '&pFiscalYear=' || v_fiscal_year || '">');
                                    ELSE
                                        htp.p('<a  href="' || Web_Util_Pkg.get_current_package
                                              || 'payment_listing_details?pUnit=' || v_unit || '&pXfr=' || pl.SID
                                              || '&pFiscalYear=' || v_fiscal_year || '">');
                                    END IF;
                
                                    htp.p(pl.voucher_no);
                                    htp.p('</a>');
                                    htp.p('</td>');
                                    htp.tabledata(pl.receiver_name);
                                    htp.tabledata(TO_CHAR(pl.amount, v_dollar_format), 'right');
                                    htp.tabledata(pl.send_date);
                                    htp.tabledata(pl.status);
                                htp.tableRowClose;
                            END LOOP;
            
                            IF NOT v_data_written THEN
                                htp.tableRowOpen;
                                    htp.p('<td colspan="5">');
                                    htp.p('No entries found.');
                                    htp.p('</td>');
                                END IF;
                            ELSIF v_tag = 'RECEIVED_LIST' THEN
                                v_data_written := FALSE;
                
                                FOR pl IN (SELECT   t.SID, t.receiver, t.sender, t.voucher_no, t.send_date,
                                                    t.amount, t.sender_name, t.receiver_name, t.status,
                                                    t.fiscal_year
                                               FROM v_cfunds_xfr t
                                              WHERE t.receiver = v_unit
                                                AND t.xfr_type = 'ER'
                                                AND t.fiscal_year = v_fiscal_year
                                           ORDER BY t.send_date DESC)
                                LOOP
                                    -- indicate that a row is in the table now.
                                    v_data_written := TRUE;
                                    htp.tableRowOpen;
                                        htp.p('<td>');
                                        htp.p('<a  href="' || Web_Util_Pkg.get_current_package
                                              || 'payment_listing_details?pUnit=' || v_unit || '&pXfr=' || pl.SID
                                              || '&pFiscalYear=' || v_fiscal_year || '">');
                                        htp.p(pl.voucher_no);
                                        htp.p('</a>');
                                        htp.p('</td>');
                                        htp.tabledata(pl.sender_name);
                                        htp.tabledata(TO_CHAR(pl.amount, v_dollar_format), 'right');
                                        htp.tabledata(pl.send_date);
                                        htp.tabledata(pl.status);
                                    htp.tableRowClose;
                                END LOOP;
                
                                IF NOT v_data_written THEN
                                    htp.tableRowOpen;
                                        htp.p('<td colspan="5">');
                                        htp.p('No entries found.');
                                        htp.p('</td>');
                                    END IF;
                                ELSE
                                    htp.print('[' || v_tag || ']');
                                END IF;
                            END LOOP;
                    
                            end_serve_page;
                            setunitsid(v_unit);
                            set_fiscal_year(pfiscalyear);
                        END payment_listing_by_unit;
                    
                        -- Reconcile account
                    
                        -- This is a Private function.
                        -- This function was created using Get_Unit_WF_Balance as the starting
                        -- point.  If that procedure changes, this should also change.  THe
                        -- same queries are done here as in Get_Unit_WF_Balance, but it is
                        -- much simpler.
                        FUNCTION is_reconciled(punit IN VARCHAR2)
                            RETURN BOOLEAN IS
                            v_since_date   DATE;
                            v_count        NUMBER;
                        BEGIN
                            -- add MFRs here.
                    
                            -- do a trigger for all these transactions to prevent delete.
                            v_count := 0;
                    
                            -- find the date of the last reconciliation.
                            FOR r IN (SELECT   recon_on
                                          FROM T_CFUNDS_RECONCILIATION
                                         WHERE unit = punit
                                      ORDER BY recon_on DESC)
                            LOOP
                                v_since_date := r.recon_on;
                                EXIT;
                            END LOOP;
                    
                            IF v_since_date IS NULL THEN
                                v_since_date := '01-Jan-1990';
                            END IF;
                    
                            --htp.p('starting balance: ' || v_bal);htp.nl;
                            --htp.p('since date: ' || v_since_date);htp.nl;
                    
                            --Incoming transfers
                            SELECT COUNT(*)
                              INTO v_count
                              FROM T_CFUNDS_XFR x
                             WHERE x.receiver = punit AND x.receive_date > v_since_date;
                    
                            IF v_count > 0 THEN
                                RETURN FALSE;
                            END IF;
                    
                            --Outgoing transfers
                            SELECT COUNT(*)
                              INTO v_count
                              FROM T_CFUNDS_XFR
                             WHERE sender = punit AND send_date > v_since_date;
                    
                            IF v_count > 0 THEN
                                RETURN FALSE;
                            END IF;
                    
                            --Expenses
                            SELECT COUNT(*)
                              INTO v_count
                              FROM T_CFUNDS_EXPENSE_V3
                             WHERE charge_to_unit = punit AND paid_on > v_since_date;
                    
                            IF v_count > 0 THEN
                                RETURN FALSE;
                            END IF;
                    
                            --repaying Expenses
                            SELECT COUNT(*)
                              INTO v_count
                              FROM T_CFUNDS_EXPENSE_V3
                             WHERE charge_to_unit = punit AND repaid_on > v_since_date;
                    
                            IF v_count > 0 THEN
                                RETURN FALSE;
                            END IF;
                    
                            --TFOS Expenses
                            SELECT COUNT(*)
                              INTO v_count
                              FROM T_CFUNDS_EXPENSE_V3
                             WHERE charge_to_unit = punit AND tfos_on > v_since_date;
                    
                            IF v_count > 0 THEN
                                RETURN FALSE;
                            END IF;
                    
                            --Advances
                            SELECT COUNT(*)
                              INTO v_count
                              FROM T_CFUNDS_ADVANCE_V2
                             WHERE unit = punit AND issue_on > v_since_date;
                    
                            IF v_count > 0 THEN
                                RETURN FALSE;
                            END IF;
                    
                            -- advance repayments
                            SELECT COUNT(*)
                              INTO v_count
                              FROM T_CFUNDS_ADVANCE_REPAYMENT_V2 ar, T_CFUNDS_ADVANCE_V2 a
                             WHERE a.SID = ar.advance AND a.unit = punit AND ar.receive_on > v_since_date;
                    
                            IF v_count > 0 THEN
                                RETURN FALSE;
                            END IF;
                    
                            RETURN TRUE;
                        END is_reconciled;
                    
                        PROCEDURE reconcile_account(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
                            --  Parameters
                            vp_command        VARCHAR2(100);
                            vp_unit           T_OSI_UNIT.SID%TYPE;
                            vp_fiscal_year    VARCHAR2(10);
                            vp_comment        T_CFUNDS_RECONCILIATION.recon_comment%TYPE;
                            --  Template Processing
                            v_template        CLOB;
                            v_template_date   DATE;
                            v_offset          NUMBER                                       := 1;
                            v_tag             VARCHAR2(100);
                            v_self            VARCHAR2(500);
                            --  Query Processing/General
                            v_recon_rec       T_CFUNDS_RECONCILIATION%ROWTYPE;
                            v_query           VARCHAR2(4000);
                            v_query_status    VARCHAR2(400);
                            v_cursor          INTEGER;
                            v_cnt             NUMBER;
                            v_ok              BOOLEAN;
                            v_tmp             VARCHAR2(500);
                    
                            PROCEDURE load_recon_rec(punit IN VARCHAR2) IS
                            BEGIN
                                FOR r IN (SELECT   *
                                              FROM T_CFUNDS_RECONCILIATION
                                             WHERE unit = punit
                                          ORDER BY recon_on DESC)
                                LOOP
                                    v_recon_rec := r;
                                    EXIT;
                                END LOOP;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    v_recon_rec := NULL;
                            END load_recon_rec;
                        BEGIN
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Reconcile_account');
                            Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
                            Web_Util_Pkg.dump_params(name_array, value_array);
                            -- Get control parameters
                            vp_command :=
                                   NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pCommand'), 'Refresh');
                            vp_unit :=
                                NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                                    Cfunds_Pkg.get_my_cfunds_unit);
                            vp_fiscal_year :=
                                NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear'),
                                    Cfunds_Pkg.get_fiscal_year(SYSDATE));
                            vp_comment :=
                                NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pComments'),
                                    'No comments entered.');
                            -- E.G this fix should work on lower and recent version of oracle.
                            --v_self := '!' || WEB_UTIL_PKG.Get_Self;
                            v_self := '!' || REPLACE(Web_Util_Pkg.get_self, '!', '');
                            begin_serve_page('E-Funds Reconcile Account',
                                             TRUE,
                                             TRUE,
                                             ' ',
                                             'E-Funds Reconcile Account',
                                             'DoHistory');
                            load_recon_rec(vp_unit);
                    
                            -- Check privilege to even show the information
                            IF Cfunds_Test_Cfp('CF_LIM_SET_ORG',
                                               Core_Obj.lookup_objtype('NONE'),
                                               Core_Context.personnel_sid,
                                               Osi_Personnel.get_current_unit(Core_Context.personnel_sid)) = 'N' THEN
                                v_error_detail := 'You do not have privilege to view this information' || '.';
                                htp.p('<INPUT TYPE="hidden" NAME="pFiscalYear" VALUE="' || vp_fiscal_year || '">');
                                htp.p('<INPUT TYPE="hidden" NAME="pUnit" VALUE="' || vp_unit || '">');
                                RAISE a_stink;
                            END IF;
                    
                            -- Process commands. Only real command is 'Save Balance'. Default processing
                            -- is the 'Refresh' command (which gets executed in all cases).
                            IF vp_command = 'Save Balance' THEN
                                -- check if there are any items to reconcile, if not, show an error message.
                                IF is_reconciled(vp_unit) = FALSE THEN
                                    -- Call this procedure but put it in the Cfunds_Pkg later....
                                    Cfunds_Pkg.reconcile(vp_unit,
                                                         NVL(Cfunds_Pkg.get_unit_wf_balance(vp_unit), 0),
                                                         vp_comment);
                                    load_recon_rec(vp_unit);                                            -- refresh data.
                                    htp.p('Reconcile successful');
                                ELSE
                                    -- no items were found, make an error message.
                                    v_error_detail :=
                                        'This account has already been reconciled.  There is no new data to reconcile at this time.';
                                    RAISE a_stink;
                                END IF;
                            END IF;
                    
                            -- Start default (Refresh) processing
                            v_ok := Web_Template_Pkg.get_latest('cfunds_reconcile_account', v_template, v_template_date);
                    
                            IF v_template_date IS NULL THEN
                                Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_reconcile_account"');
                                htp.print('Could not locate template');
                                RETURN;
                            END IF;
                    
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self || '?a=1');
                            -- remember the Fiscal Year
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'UNIT_NAME',
                                                             Cfunds_Pkg.lookup_cfunds_unit(vp_unit).unit_name);
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                    (v_template,
                                     'CUSTODIAN_CHANGE',
                                     '<a href="javascript:MenuLinksToPopup('''
                                     || REPLACE(Web_Util_Pkg.get_current_package, '!', '') || 'form29?pFiscalYear='
                                     || vp_fiscal_year
                                     || '&pCommand=bogus&pUsage=r&pSkipChecks=true&'')">Click here to see details of account activity</a>');
                            v_ok :=
                                Web_Template_Pkg.replace_tag
                                    (v_template,
                                     'COMMENTS',
                                     '<textarea name="pComments" rows=5 cols=56 valign="top" width="590">Enter new comments here before hitting "Save Balance".</textarea>');
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template, 'CURRENT_DATE',
                                                             TO_CHAR(SYSDATE, 'dd-Mon-yyyy'));
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'CURRENT_WF_BALANCE',
                                                             TO_CHAR(NVL(Cfunds_Pkg.get_unit_wf_balance(vp_unit), 0),
                                                                     v_dollar_format));
                    
                            IF v_recon_rec.recon_on IS NULL THEN
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'LAST_RECON_DATE',
                                                                 'This account has never been reconciled.');
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'LAST_RECON_BALANCE', ' ');
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'LAST_RECON_COMMENTS', ' ');
                            ELSE
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'LAST_RECON_DATE',
                                                                 TO_CHAR(v_recon_rec.recon_on, 'dd-Mon-yyyy'));
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'LAST_RECON_BALANCE',
                                                                 TO_CHAR(NVL(v_recon_rec.recon_balance, 0),
                                                                         v_dollar_format));
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'LAST_RECON_COMMENTS',
                                                                 v_recon_rec.recon_comment);
                            END IF;
                    
                            LOOP
                                v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                                EXIT WHEN NOT v_ok
                                      OR (v_tag IS NULL);
                    
                                -- Now process each found tag
                                IF v_tag = 'AMT_SPENT_TOT' THEN
                                    --   htp.prn(to_char(v_amt_spent_tot, v_dollar_format));
                                    NULL;
                                ELSE
                                    htp.print('[' || v_tag || ']');
                                END IF;
                            END LOOP;
                    
                            COMMIT;
                            end_serve_page;
                            setunitsid(vp_unit);
                            set_fiscal_year(vp_fiscal_year);
                        EXCEPTION
                            WHEN a_stink THEN
                                exception_handler(TRUE);
                                end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                            WHEN OTHERS THEN
                                exception_handler;
                                end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                        END reconcile_account;
                    
                        -- Repayment of an advance.
                        PROCEDURE repayment_details(
                            pcommand        IN   VARCHAR2,
                            padvance        IN   VARCHAR2,
                            psid            IN   VARCHAR2,
                            pcash_amount    IN   NUMBER,
                            pcheck_amount   IN   NUMBER,
                            punit           IN   VARCHAR2,
                            pparams         IN   VARCHAR2,
                            pfiscalyear     IN   VARCHAR2) IS
                            v_template        CLOB;
                            v_template_date   DATE;
                            v_offset          NUMBER                                := 1;
                            v_tag             VARCHAR2(100);
                            v_query           VARCHAR2(4000);
                            v_query_status    VARCHAR2(400);
                            v_cursor          INTEGER;
                            v_ok              BOOLEAN;
                            v_params          VARCHAR2(100);
                            v_strreadonly     VARCHAR2(9);
                            v_command1name    VARCHAR2(30);
                            v_command2name    VARCHAR2(30);
                            v_voucher_no      VARCHAR2(100);
                            v_advancesid      VARCHAR2(100);
                            v_fiscal_year     VARCHAR2(10);
                            v_advance_id      T_CFUNDS_ADVANCE_V2.voucher_no%TYPE;
                    
                            PROCEDURE get_advance_id IS
                            -- this will find the ID of the advance that is related to this
                            -- repayment, and store that value in the variable v_advance_id.
                            BEGIN
                                -- run query to find the ID, possible to have an error if,
                                -- v_AdvanceSid is null, so catch the error in this method.
                                SELECT voucher_no
                                  INTO v_advance_id
                                  FROM T_CFUNDS_ADVANCE_V2
                                 WHERE SID = v_advancesid;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    v_advance_id := ' ';
                            END get_advance_id;
                        BEGIN
                            v_advancesid := NVL(padvance, psid);
                            get_advance_id;
                            begin_serve_page('E-Funds Repayment Details',
                                             TRUE,
                                             TRUE,
                                             ' ',
                                             'E-Funds Repayment Details',
                                             'advance_details?pSID=' || v_advancesid);
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Repayment_Details(' || pcommand || ')');
                            v_ok := Web_Template_Pkg.get_latest('cfunds_repayment_details', v_template, v_template_date);
                    
                            IF v_template_date IS NULL THEN
                                Core_Logger.log_it(c_pipe, 'Could not locate template "cfunds_Repayment_Details"');
                                htp.print('Could not locate template');
                                RETURN;
                            END IF;
                    
                            -- if the fiscal year wasn't specified, use the current fiscal year.
                            v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                            -- remember the Fiscal Year
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', v_fiscal_year);
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                            -- save ADVANCE_SID value for next iteration of the form.
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'ADVANCE_SID', padvance);
                            -- save UNIT_SID value for next iteration of the form.
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_SID', punit);
                            -- save pParams value for next iteration of the form.
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'PPARAMS', pparams);
                    
                            -- See if the user pressed any buttons.
                            IF pcommand = 'Complete Repayment' THEN
                                Cfunds_Pkg.repay_advance(padvance, pcash_amount, pcheck_amount, v_voucher_no);
                                COMMIT;
                                htp.print('Repayment Completed, ID Number is ' || v_voucher_no);
                                --  ***  make the details re-appear
                                htp.nl;
                                htp.print('<a href="vbscript:PreviousButton(&quot;' || Web_Util_Pkg.get_current_package
                                          || 'advance_details?pSID=' || padvance
                                          || '&quot;)">View Refreshed Advance Details</a>');
                                end_serve_page;
                                setunitsid(punit);
                                setvparams(pparams);
                                set_fiscal_year(v_fiscal_year);
                                RETURN;
                            END IF;
                    
                            IF psid IS NULL THEN
                                -- show fields for input without grabbing data from database.
                    
                                -- show the button to allow repayment processing
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'BUTTON',
                                                                 'type=''submit'' value=''Complete Repayment''');
                                -- save SID value for next iteration of the form.
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', 'bogus');
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'RECEIVE_ON', SYSDATE);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'ADVANCE_NO', v_advance_id);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', 'to be auto-generated');
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOTAL_AMOUNT', '0');
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CHECK_AMOUNT', ' value = 0 ');
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'CASH_AMOUNT', ' value = 0 ');
                            -- call AddNew when the user clicks the Complete Repayment button.
                            END IF;
                    
                            FOR ar IN (SELECT *
                                         FROM v_cfunds_advance_repayment_v2
                                        WHERE SID = psid)
                            LOOP
                                -- make input fields readonly if the status isn't new.
                                v_strreadonly := ' readonly';                                   -- default is read-only
                    
                                IF ar.receive_on = '' THEN
                                    v_strreadonly := ' ';
                                END IF;
                    
                                -- hide the button to allow repayment processing
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'BUTTON',
                                                                 'type=''hidden'' value=''Complete Repayment''');
                                -- save SID value for next iteration of the form.
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', ar.SID);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'RECEIVE_ON', ar.receive_on);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'ADVANCE_NO', v_advance_id);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', ar.voucher_no);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TOTAL_AMOUNT', ar.total_amount);
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'CHECK_AMOUNT',
                                                                 v_strreadonly || ' value = ' || ar.check_amount);
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'CASH_AMOUNT',
                                                                 v_strreadonly || ' value = ' || ar.cash_amount);
                                EXIT;
                            END LOOP;
                    
                            v_ok := Web_Template_Pkg.serve_clob(v_template);
                            end_serve_page;
                            setunitsid(punit);
                            setvparams(pparams);
                            set_fiscal_year(v_fiscal_year);
                            COMMIT;
                        EXCEPTION
                            WHEN Cfunds_Pkg.bad_timing THEN
                                exception_handler;
                                end_serve_page;
                                setunitsid(punit);
                                setvparams(pparams);
                            WHEN Cfunds_Pkg.no_privilege THEN
                                exception_handler;
                                end_serve_page;
                                setunitsid(punit);
                                setvparams(pparams);
                            WHEN Cfunds_Pkg.invalid_parameters THEN
                                exception_handler;
                                end_serve_page;
                                setunitsid(punit);
                                setvparams(pparams);
                            WHEN OTHERS THEN
                                htp.print(SQLERRM);
                                htp.nl;
                                htp.print(Cfunds_Pkg.get_error_detail);
                                htp.nl;
                                end_serve_page;
                                setunitsid(punit);
                                setvparams(pparams);
                        END repayment_details;
                    
                        PROCEDURE search_expadv(punit IN VARCHAR2, psearchtoken IN VARCHAR2, pbtnsearch IN VARCHAR2) IS
                            v_user_info        VARCHAR2(100);
                            v_unit_sid         T_CFUNDS_UNIT.SID%TYPE;
                            v_permission_exp   VARCHAR2(10);
                            v_permission_adv   VARCHAR2(10);
                            v_searchtoken      VARCHAR2(128)            := '';
                            --v_Unit T_UNIT.SID%type;
                    
                            --template variables
                            v_ok               BOOLEAN;
                            v_template         CLOB;
                            v_template_date    DATE;
                            v_offset           NUMBER                   := 1;
                            v_tag              VARCHAR2(100);
                            -- data variables
                            v_data_written     BOOLEAN                  := FALSE;
                            v_writecolhdr      BOOLEAN                  := FALSE;
                        BEGIN
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Search_ExpAdv');
                            Web_Util_Pkg.send_comment('pUnit: ' || punit);
                            Web_Util_Pkg.send_comment('pSearchToken: ' || psearchtoken);
                            -- if the unit wasn't specified, use the current user's unit.
                            v_unit_sid := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                            v_permission_exp :=
                                Cfunds_Test_Cfp('SEARCH',
                                                Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                                Core_Context.personnel_sid,
                                                v_unit_sid);
                            v_permission_adv :=
                                Cfunds_Test_Cfp('SEARCH',
                                                Core_Obj.lookup_objtype('CFUNDS_ADV'),
                                                Core_Context.personnel_sid,
                                                v_unit_sid);
                    
                            -- test unit to see if user has privs to be in here;
                            -- since there isn't a priv for accessing E-Funds Custodian
                            -- level data, we check 2 privs and if both fail then
                            -- user can't see any data.
                            IF    v_permission_exp = 'N'
                               OR v_permission_adv = 'N' THEN
                                v_error_detail :=
                                                'You do not have privileges to view data ' || 'for the specified unit.'
                                                 || ' You must have privileges to search both Expenses and Advances.';
                                RAISE a_stink;
                            END IF;
                    
                            IF v_permission_exp = 'Y' AND v_permission_adv = 'Y' THEN
                                begin_serve_page('E-Funds Search Expenses/Advances',
                                                 TRUE,
                                                 TRUE,
                                                 '',
                                                 'E-Funds Management System',
                                                 'DoHistory');
                                v_ok := Web_Template_Pkg.get_latest('cfunds_search_expadv', v_template, v_template_date);
                    
                                IF v_template_date IS NULL THEN
                                    Core_Logger.log_it(c_pipe, 'Could not locate template "cfunds_Repayment_Details"');
                                    htp.print('Could not locate template');
                                    RETURN;
                                END IF;
                    
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit_sid);
                                -- assign the value to check and correct data
                                v_searchtoken := trim(psearchtoken);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SEARCH', '"' || v_searchtoken || '"');
                    
                                IF (NOT v_searchtoken IS NULL) THEN
                                    -- adjust the search string here for uneccessary characters
                                    v_searchtoken := REPLACE(v_searchtoken, '"', '');        -- strip the double quotes
                                    v_searchtoken := REPLACE(v_searchtoken, '''', '''');
                                    -- this lets the person enter contractions and other single tick items
                                    v_searchtoken := '%' || v_searchtoken || '%';
                    
                                    -- this should let the person search anywhere in the compared string
                                    LOOP
                                        v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                                        EXIT WHEN NOT v_ok
                                              OR (v_tag IS NULL);
                    
                                        -- Now process each found tag
                                        IF v_tag = 'SRCH_LIST' THEN
                                            v_data_written := FALSE;
                                            -- open table
                                            htp.p('<table border="1">');
                    
                                            FOR adexp IN (SELECT   psid, voucher, unit, unit_no, amount, ri_date,
                                                                   status, descript, typetbl
                                                              FROM ((SELECT SID AS psid, voucher_no AS voucher,
                                                                            charge_to_unit_name AS unit,
                                                                            charge_to_unit AS unit_no,
                                                                            total_amount_us AS amount,
                                                                            incurred_date AS ri_date,
                                                                            description AS descript, status AS status,
                                                                            'EX' AS typetbl
                                                                       FROM v_cfunds_expense_v3
                                                                      WHERE NOT charge_to_unit IS NULL)
                                                                    UNION ALL
                                                                    (SELECT SID AS psid, voucher_no AS voucher,
                                                                            unit_name AS unit, unit AS unit_no,
                                                                            amount_requested AS amount,
                                                                            request_date AS ri_date,
                                                                            narrative AS descript, status AS status,
                                                                            'AD' AS typetbl
                                                                       FROM v_cfunds_advance_v2
                                                                      WHERE NOT unit IS NULL))
                                                             WHERE (   (voucher LIKE v_searchtoken)
                                                                    OR (descript LIKE v_searchtoken))
                                                          ORDER BY unit_no, ri_date)
                                            LOOP
                                                IF (   (v_unit_sid = adexp.unit_no)
                                                    OR (Cfunds_Pkg.is_unit_child(v_unit_sid, adexp.unit_no) = 'Y')) THEN
                                                    -- indicate that a row is in the table now.
                                                    v_data_written := TRUE;
                    
                                                    IF (v_writecolhdr = FALSE) THEN
                                                        htp.tableRowOpen;
                                                            htp.tableheader('Voucher', 'center');
                                                            htp.tableheader('Unit', 'center');
                                                            htp.tableheader('Amount', 'center');
                                                            htp.tableheader('Date', 'center');
                                                            htp.tableheader('Status', 'center');
                                                        htp.tableRowClose;
                                                        v_writecolhdr := TRUE;
                                                    END IF;
                    
                                                    htp.tableRowOpen;
                        
                                                        IF (adexp.typetbl = 'AD') THEN
                                                            htp.p('<td>');
                                                            -- E.G. not sure about the need of the ! on earlier or later version of oracle
                                                            htp.p('<a  href="' || Web_Util_Pkg.get_current_package
                                                                  || 'advance_details?pSID=' || adexp.psid || '">');
                                                            htp.p(adexp.voucher);
                                                            htp.p('</a>');
                                                            htp.p('</td>');
                                                        ELSE
                                                            htp.p('<td>');
                                                            -- E.G. not sure about the need of the ! on earlier or later version of oracle
                                                            htp.p('<a  href="' || Web_Util_Pkg.get_current_package
                                                                  || 'expense_details?pSID=' || adexp.psid || '">');
                                                            htp.p(adexp.voucher);
                                                            htp.p('</a>');
                                                            htp.p('</td>');
                                                        END IF;
                        
                                                        htp.tabledata(adexp.unit, 'right');
                                                        htp.tabledata(TO_CHAR(adexp.amount, v_dollar_format), 'right');
                                                        htp.tabledata(adexp.ri_date, 'right');
                                                        htp.tabledata(adexp.status, 'right');
                                                    htp.tableRowClose;
                                                END IF;
                                            END LOOP;
                    
                                            IF NOT v_data_written THEN
                                                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Search_ExpAdv3');
                                                htp.p('<table border="1">');
                                                htp.tableRowOpen;
                                                    htp.tableheader('Voucher', 'center');
                                                    htp.tableheader('Unit', 'center');
                                                    htp.tableheader('Amount', 'center');
                                                    htp.tableheader('Date', 'center');
                                                    htp.tableheader('Status', 'center');
                                                htp.tableRowClose;
                                                htp.tableRowOpen;
                                                    htp.p('<td colspan="5">');
                                                    htp.p('No entries found.');
                                                    htp.p('</td>');
                                                htp.tableRowClose;
                                                htp.p('</table>');
                                            END IF;
                                        ELSE
                                            htp.print('[' || v_tag || ']');
                                        END IF;
                                    END LOOP;
                    
                                    htp.p('</table>');
                                ELSE
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                                                  (v_template,
                                                                   'SRCH_LIST',
                                                                   '<table border="0"><tr><td>&nbsp;</td></tr></table>');
                                    v_ok := Web_Template_Pkg.serve_clob(v_template);
                                END IF;
                            END IF;
                    
                            end_serve_page;
                        EXCEPTION
                            WHEN a_stink THEN
                                begin_serve_page('E-Funds Home',
                                                 FALSE,
                                                 FALSE,
                                                 'E-Funds Management System',
                                                 '',
                                                 'DoHistory');
                                exception_handler(TRUE);
                                htp.print('<br><font size="+2"><b><a href="' || Web_Util_Pkg.get_current_package
                                          || 'home_page?pUnit=' || Cfunds_Pkg.get_my_cfunds_unit
                                          || '">Back to Home_Page</a></b></font><br><br>');
                                end_serve_page;
                        END search_expadv;
                    
                        PROCEDURE dfo_by_unit(punit IN VARCHAR2, pfiscalyear IN VARCHAR2) IS
                            v_template        CLOB;
                            v_template_date   DATE;
                            v_offset          NUMBER                   := 1;
                            -- v_params_short Varchar2(1000);
                            -- v_params Varchar2(1000);
                            v_tag             VARCHAR2(100);
                            --    v_query Varchar2(4000);
                            --    v_query_params Varchar2(4000);
                            --    v_cursor Integer;
                            v_ok              BOOLEAN;
                            v_filter_list     VARCHAR2(1000);
                            v_unit_name       VARCHAR2(50);
                            v_unit            T_CFUNDS_UNIT.SID%TYPE;
                            v_fiscal_year     VARCHAR2(10);
                            v_data_written    BOOLEAN                  := FALSE;
                        BEGIN
                            -- if the unit wasn't specified, use the current user's unit.
                            v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                            -- if the fiscal year wasn't specified, use the current fiscal year.
                            v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                            -- find the name of this unit whose subordinate units are showing.
                            v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit).unit_name;
                            begin_serve_page('E-Funds DFOs By Unit', TRUE, TRUE, '', 'E-Funds DFO By Unit',
                                             'home_page');
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.dfo_by_Unit');
                            v_ok := Web_Template_Pkg.get_latest('cfunds_dfo_by_unit', v_template, v_template_date);
                    
                            IF v_template_date IS NULL THEN
                                Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_dfo_by_unit"');
                                htp.print('Could not locate template');
                                RETURN;
                            END IF;
                    
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                            -- remember the UNIT so the screen can be refreshed when the user changes the filters.
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_FLAG', v_unit);
                            -- remember the Fiscal Year
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
                            v_ok :=
                                Web_Template_Pkg.replace_tag(v_template,
                                                             'FISCAL_YEAR_LABEL',
                                                             get_html_fy_dropdown(v_fiscal_year));
                    
                            LOOP
                                v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                                EXIT WHEN NOT v_ok
                                      OR (v_tag IS NULL);
                    
                                -- Now process each found tag
                                IF v_tag = 'DFO_LIST' THEN
                                    v_data_written := FALSE;
                    
                                    FOR h IN
                                        (SELECT SID, DECODE(xfr_type, 'DFOA', 'DFO Advance', 'DFO Repayment') AS xtype,
                                                sender_name, receiver_name, voucher_no, amount, send_date, status
                                           FROM v_cfunds_xfr
                                          WHERE TRUNC(send_date)
                                                    BETWEEN Cfunds_Pkg.get_fiscal_year_start_date(v_fiscal_year)
                                                        AND Cfunds_Pkg.get_fiscal_year_end_date(v_fiscal_year)
                                            AND (   xfr_type = 'DFOA'
                                                 OR xfr_type = 'DFOR')
                                            AND sender = v_unit)
                                    LOOP
                                        -- indicate that a row is in the table now.
                                        v_data_written := TRUE;
                                        htp.tableRowOpen;
                                            htp.p('<td>');
                                            htp.p('<a  href="' || Web_Util_Pkg.get_current_package || 'DFO_details?pSID='
                                                  || h.SID || '&pUnit=' || v_unit || '&pFiscalYear=' || v_fiscal_year
                                                  || '">');
                                            htp.p(h.voucher_no);
                                            htp.p('</a>');
                                            htp.p('</td>');
                                            htp.tabledata(h.sender_name, 'right');
                                            htp.tabledata(TO_CHAR(h.amount, v_dollar_format), 'right');
                                            -- Doesn't matter whether it is the SEND or RECEIVE DATE -- see Create DFO
                                            htp.tabledata(h.send_date, 'right');
                                            htp.tabledata(h.status, 'right');
                                            htp.tabledata(h.xtype, 'left');
                                        htp.tableRowClose;
                                    END LOOP;
                    
                                    IF NOT v_data_written THEN
                                        htp.tableRowOpen;
                                            htp.p('<td colspan="3">');
                                            htp.p('No entries found.');
                                            htp.p('</td>');
                                        END IF;
                                    ELSE
                                        htp.print('[' || v_tag || ']');
                                    END IF;
                                END LOOP;
                        
                                end_serve_page;
                                setunitsid(v_unit);
                                set_fiscal_year(pfiscalyear);
                            END dfo_by_unit;
                        
                            PROCEDURE dfo_details(
                                psid          IN   VARCHAR2,
                                ptypecode     IN   VARCHAR2,
                                pfiscalyear   IN   VARCHAR2,
                                psenddate     IN   VARCHAR2,
                                punit         IN   VARCHAR2,
                                pdfo          IN   VARCHAR2,
                                pamount       IN   VARCHAR2) IS
                                v_send_date       DATE;
                                v_unit_sid        T_CFUNDS_UNIT.SID%TYPE;
                                v_permission      VARCHAR2(10);
                                v_unit_name       VARCHAR2(25);
                                v_fiscal_year     VARCHAR2(10);
                                v_sid             T_CFUNDS_XFR.SID%TYPE;
                                v_type            VARCHAR2(20);
                                v_dfo_rec         T_CFUNDS_XFR%ROWTYPE;
                                --template variables
                                v_ok              BOOLEAN;
                                v_template        CLOB;
                                v_template_date   DATE;
                                v_offset          NUMBER                   := 1;
                                v_tag             VARCHAR2(100);
                                v_self            VARCHAR2(500);
                            BEGIN
                                Core_Logger.log_it(c_pipe, '>>>> Cfunds_Web.DFO_Details');
                                Web_Util_Pkg.send_comment('pSID: ' || psid);
                                Web_Util_Pkg.send_comment('pDfo: ' || pdfo);
                                -- find the unit to default to if not sent in as a parameter
                                v_unit_sid := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                                v_permission :=
                                    Cfunds_Test_Cfp('CF_XFR_DFO',
                                                    Core_Obj.lookup_objtype('NONE'),
                                                    Core_Context.personnel_sid,
                                                    v_unit_sid);
                        
                                -- test unit to see if user has privs to be in here;
                                -- since there isn't a priv for accessing E-Funds Custodian
                                -- level data, we check 2 privs and if both fail then
                                -- user can't see any data.
                                IF v_permission = 'N' THEN
                                    v_error_detail :=
                                                    'You do not have privileges to view data ' || 'for the specified unit.';
                                    RAISE a_stink;
                                END IF;
                        
                                begin_serve_page('E-Funds Create DFO Transfers',
                                                 TRUE,
                                                 TRUE,
                                                 '',
                                                 'E-Funds Management System',
                                                 'DoHistory');
                                v_ok := Web_Template_Pkg.get_latest('cfunds_dfo_details', v_template, v_template_date);
                        
                                IF v_ok THEN
                                    Core_Logger.log_it
                                                     (c_pipe,
                                                      'web_template_pkg --> get_latest --> cfunds_dfo_details: v_ok = true');
                                ELSE
                                    Core_Logger.log_it
                                                    (c_pipe,
                                                     'web_template_pkg --> get_latest --> cfunds_dfo_details: v_ok = false');
                                END IF;
                        
                                IF v_template_date IS NULL THEN
                                    Core_Logger.log_it(c_pipe, 'Could not locate template "cfunds_Repayment_Details"');
                                    htp.print('Could not locate template');
                                    RETURN;
                                END IF;
                        
                                -- code to fill in page
                                -- if the fiscal year wasn't specified, use the current fiscal year.
                                v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                                -- find the name of this unit whose subordinate units are showing.
                                v_unit_name := Cfunds_Pkg.lookup_cfunds_unit(v_unit_sid).unit_name;
                                -- See if this is a new one or one to look at the
                                v_sid := NVL(psid, 'newone');
                                -- get the type
                                v_type := ptypecode;
                                v_self := Web_Util_Pkg.get_self;
                                Core_Logger.log_it(c_pipe,
                                                   'v_fiscal_year, v_unit_name, v_sid, v_type, v_self = ' || v_fiscal_year
                                                   || ', ' || v_unit_name || ', ' || v_sid || ', ' || v_type || ', '
                                                   || v_self);
                        
                                -- if your making a new one then go and create a new transfer entry
                                IF (v_sid = 'MakeNewOne') THEN
                                    IF v_unit_sid IS NULL THEN
                                        v_error_detail := 'Unit must be specified for this DFO.';
                                        RAISE a_stink;                                                --INVALID_PARAMETERS;
                                    END IF;
                        
                                    Core_Logger.log_it(c_pipe, 'MakeNewOne - unit sid = ' || v_unit_sid);
                        
                                    -- Check date
                                    IF psenddate IS NULL THEN
                                        v_error_detail := 'You must specify a date (check format). ';
                                        RAISE a_stink;
                                    ELSE
                                        BEGIN                                                     -- This checks formatting
                                            v_send_date := TO_DATE(psenddate, 'dd-Mon-yy');
                                        EXCEPTION
                                            WHEN OTHERS THEN
                                                Core_Logger.log_it
                                                    (c_pipe,
                                                     'Your date has been entered incorrectly (check format) psenddate = '
                                                     || TO_CHAR(psenddate));
                                                v_error_detail := 'Your date has been entered incorrectly (check format).';
                                                RAISE a_stink;
                                        END;
                                    END IF;
                        
                                    IF (pdfo = '0') THEN
                                        Core_Logger.log_it(c_pipe, 'creating dfo: pdfo = 0');
                                        Cfunds_Pkg.create_dfo(psenddate, v_unit_sid, 'DFOA', pamount, v_sid);
                                    ELSE
                                        Core_Logger.log_it(c_pipe, 'creating dfo: pdfo = ' || pdfo);
                                        Cfunds_Pkg.create_dfo(psenddate, v_unit_sid, 'DFOR', pamount, v_sid);
                                    END IF;
                        
                                    htp.p('A new DFO was saved');
                                    COMMIT;
                                END IF;
                        
                                IF (v_sid = 'newone') THEN
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                            (v_template,
                                             'BUTTONS',
                                             '<td valign="center"><input type="button" value="Save DFO" name="pBtnSave" onclick="Do_Save()"></td>');
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', v_sid);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                            (v_template,
                                             'SEND_DATE',
                                             'Date: <font class="DBdata"><input maxLength="10" size="10" name="pSendDate"></font>&nbsp;dd-Mon-yy');
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'VOUCHER_NO', 'to be auto-generated');
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit_sid);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', v_fiscal_year);
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                            (v_template,
                                             'AMOUNT',
                                             'Amount:&nbsp;&nbsp;&nbsp;&nbsp;<font class="DBdata"><input maxLength="10" size="10" name="pAmount" value="0.00"></font>');
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                            (v_template,
                                             'RADIO_BUTTONS',
                                             '<font class="DBdata"><input checked type="radio" name="pDfo" title="Receive DFO Advance" value="0"><label title="DFO Advance"> DFO Advance</label></font><br>'
                                             || '<font class="DBdata"><input type="radio" name="pDfo" title="DFO Repayment" value="1"><label title="DFO Repayment"> DFO Repayment</label></font>');
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT_NAME', v_unit_name);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TYPE_CODE', 'DFO');
                                ELSE
                                    Core_Logger.log_it(c_pipe, 'retrieve the DFO from the database and display the info');
                        
                                    -- retrieve the DFO from the database and display the info
                                    SELECT *
                                      INTO v_dfo_rec
                                      FROM T_CFUNDS_XFR
                                     WHERE SID = v_sid;
                        
                                    IF (v_dfo_rec.xfr_type = 'DFOA') THEN
                                        v_type := 'DFO Advance';
                                    ELSE
                                        v_type := 'DFO Repayment';
                                    END IF;
                        
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'BUTTONS', '<td></td>');
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', v_sid);
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'FISCAL_YEAR',
                                                                     Cfunds_Pkg.get_fiscal_year(v_dfo_rec.send_date));
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'SEND_DATE',
                                                                     'Date: <font class="DBdata">'
                                                                     || TO_DATE(v_dfo_rec.send_date, 'dd-Mon-yy')
                                                                     || '</font>');
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'VOUCHER_NO', v_dfo_rec.voucher_no);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_dfo_rec.sender);
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'FISCAL_YEAR_LABEL',
                                                                     Cfunds_Pkg.get_fiscal_year(v_dfo_rec.send_date));
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                                                 (v_template,
                                                                  'AMOUNT',
                                                                  'Amount:&nbsp;&nbsp;&nbsp;&nbsp;<font class="DBdata">$'
                                                                  || v_dfo_rec.amount || '</font>');
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'RADIO_BUTTONS',
                                                                     'Type: <font class="DBdata">' || v_type || '</font>');
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                                                  (v_template,
                                                                   'UNIT_NAME',
                                                                   Cfunds_Pkg.lookup_cfunds_unit(v_dfo_rec.sender).unit_name);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TYPE_CODE', v_dfo_rec.xfr_type);
                                END IF;
                        
                                v_ok := Web_Template_Pkg.serve_clob(v_template);
                                end_serve_page;
                                setunitsid(punit);
                                set_fiscal_year(v_fiscal_year);
                                Core_Logger.log_it(c_pipe, '<<<< Cfunds_Web.DFO_Details');
                            EXCEPTION
                                WHEN a_stink THEN
                                    Core_Logger.log_it(c_pipe, 'Exception a_stink Cfunds_Web.DFO_Details');
                                    exception_handler(TRUE);
                                    end_serve_page;
                                    setunitsid(v_unit_sid);
                                    set_fiscal_year(v_fiscal_year);
                                WHEN Cfunds_Pkg.invalid_parameters THEN
                                    Core_Logger.log_it(c_pipe,
                                                       'Exception  cfunds_pkg.invalid_parameters Cfunds_Web.DFO_Details');
                                    exception_handler;
                                    end_serve_page;
                                    setunitsid(punit);
                                    set_fiscal_year(v_fiscal_year);
                                WHEN Cfunds_Pkg.no_privilege THEN
                                    Core_Logger.log_it(c_pipe, 'Exception cfunds_pkg.no_privilege Cfunds_Web.DFO_Details');
                                    exception_handler;
                                    end_serve_page;
                                    setunitsid(punit);
                                    set_fiscal_year(v_fiscal_year);
                            END dfo_details;
                        
                            PROCEDURE transfer_details(
                                pcommand      IN   VARCHAR2,
                                psid          IN   VARCHAR2,
                                psend_to      IN   VARCHAR2,
                                pamount       IN   NUMBER,
                                ptype         IN   VARCHAR2,
                                punit         IN   VARCHAR2,
                                pnulldate     IN   NUMBER,
                                pfiscalyear   IN   VARCHAR2) IS
                                v_template           CLOB;
                                v_template_date      DATE;
                                v_offset             NUMBER                               := 1;
                                v_tag                VARCHAR2(100);
                                v_query              VARCHAR2(4000);
                                v_cursor             INTEGER;
                                v_cnt                NUMBER;
                                v_ok                 BOOLEAN;
                                v_params             VARCHAR2(100);
                                v_cursor2            INTEGER;
                                v_query2             VARCHAR2(4000);
                                v_voucher_no         T_CFUNDS_XFR.voucher_no%TYPE;
                                v_type               T_CFUNDS_XFR.xfr_type%TYPE;
                                v_sender             T_CFUNDS_XFR.sender%TYPE;
                                v_command2_specs     VARCHAR2(1024);
                                v_sid                T_CFUNDS_XFR.SID%TYPE;
                                v_fiscal_year        VARCHAR2(10);
                                v_type_description   T_CFUNDS_XFR_TYPE.description%TYPE;
                            BEGIN
                                begin_serve_page('E-Funds Transfer Details',
                                                 TRUE,
                                                 TRUE,
                                                 ' ',
                                                 'E-Funds Transfer Details',
                                                 'home_page');
                                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Transfer_Details(' || pcommand || ')');
                                v_ok := Web_Template_Pkg.get_latest('cfunds_transfer_details', v_template, v_template_date);
                        
                                IF v_template_date IS NULL THEN
                                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_Transfer_Details"');
                                    htp.print('Could not locate template');
                                    RETURN;
                                END IF;
                        
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                                -- if the fiscal year wasn't specified, use the current fiscal year.
                                v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                                v_sid := psid;                                                   -- the SID of the transfer.
                        
                                -- for new transfers, we don't want to show a past fiscal year in the details,
                                -- so change it so it displays the current fiscal year.  The context will stay ,
                                -- at whatever fiscal year they were in before they made this transfer though.
                                IF v_sid IS NULL THEN
                                    IF v_fiscal_year <> Cfunds_Pkg.get_fiscal_year(SYSDATE) THEN
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag(v_template,
                                                                         'FISCAL_YEAR_LABEL',
                                                                         Cfunds_Pkg.get_fiscal_year(SYSDATE));
                                    END IF;
                                END IF;
                        
                                -- remember the Fiscal Year
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', v_fiscal_year);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', punit);
                        
                                -- Process Actions that Button clicks caused.
                                IF pcommand = 'Send Working Funds' THEN
                                    -- Create a working fund transfer
                                    IF pnulldate IS NULL THEN
                                        htp.p('Please specify "Send now" or "Send later" and push the Send button again.');
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag
                                                               (v_template,
                                                                'AMOUNT',
                                                                '<input maxLength="10" size="10" name="pAmount" value="'
                                                                || pamount || '">');
                                        v_sid := NULL;
                                    ELSE
                                        IF pnulldate = 1 THEN
                                            Cfunds_Pkg.send_working_funds(punit, psend_to, pamount, v_voucher_no, NULL);
                                            htp.print('Working Funds transfer was created, ID number of Transfer is '
                                                      || v_voucher_no);
                                        --E.G          htp.print('Working Funds transfer was created, ID number of Transfer is ' || v_Voucher_No || ' from=' || pUnit || '  send=' || pSend_To);
                                        ELSE
                                            Cfunds_Pkg.send_working_funds(punit, psend_to, pamount, v_voucher_no);
                                            htp.print('Working Funds sent, ID number of Transfer is ' || v_voucher_no);
                                        -- E.G         htp.print('Working Funds sent, ID number of Transfer is ' || v_Voucher_No || ' from=' || pUnit || '  send=' || pSend_To);
                                        END IF;
                        
                                        htp.nl;
                        
                                        -- remember the SID so we can show the details later.
                                        SELECT SID
                                          INTO v_sid
                                          FROM T_CFUNDS_XFR
                                         WHERE voucher_no = v_voucher_no;
                                    END IF;
                                --elsif pCommand = 'Accept Transfer' then
                                ELSIF pcommand = 'Accept Transfer' THEN
                                    -- accept a transfer of any sort; working fund or Payment Listing.
                                    Cfunds_Pkg.receive_working_funds(psid);
                                    htp.print('Transfer Accepted');
                                    htp.nl;
                                ELSIF pcommand = 'Send Transfer' THEN
                                    -- send a transfer that already exists; (working fund or Payment Listing).
                        
                                    -- check for the proper privilege.
                                    SELECT xfr_type, sender
                                      INTO v_type, v_sender
                                      FROM T_CFUNDS_XFR
                                     WHERE SID = psid;
                        
                                    IF    v_type = 'ER'
                                       OR v_type = 'DER' THEN
                                        IF Cfunds_Test_Cfp('EXP_INVALIDATE',
                                                           Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                                           Core_Context.personnel_sid,
                                                           v_sender) = 'N' THEN
                                            v_error_detail := 'You do not have privilege to reimburse these expenses.';
                                            RAISE a_stink;
                                        END IF;
                                    ELSIF v_type = 'WF' THEN
                                        IF Cfunds_Test_Cfp('CF_XFR_SWF',
                                                           Core_Obj.lookup_objtype('NONE'),
                                                           Core_Context.personnel_sid,
                                                           v_sender) = 'N' THEN
                                            v_error_detail :=
                                                'You do not have privilege to send working funds '
                                                || 'from the specified unit.';
                                            RAISE a_stink;
                                        END IF;
                                    END IF;
                        
                                    -- write the date into the transfer record that already exists.
                                    UPDATE T_CFUNDS_XFR
                                       SET send_date = SYSDATE,
                                           modify_by = Core_Context.personnel_name,
                                           modify_on = SYSDATE
                                     WHERE SID = psid;
                        
                                    -- test for errors.
                                    IF SQL%rowcount < 1 THEN
                                        v_error_detail := 'No transfer was found to update.';
                                        RAISE a_stink;
                                    END IF;
                        
                                    htp.print('Transfer Sent');
                                    htp.nl;
                                END IF;
                        
                                -- save Type Code value for next iteration of the form.
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TYPE_CODE', ptype);
                        
                                -- only show the Print Form button when there are details to print for a transfer.
                                IF v_sid IS NOT NULL THEN
                                    v_command2_specs :=
                                        'type=''button'' value=''Print Form'' onclick=''PrintForm("'
                                        || Web_Util_Pkg.get_current_package || 'transfer_form?pSID=' || v_sid || '")''';
                                ELSE
                                    -- For new Transfer show fields for input without grabbing data from database. --
                                    v_command2_specs := 'type=''hidden'' value=''Hidden''';
                                    -- if v_SID is null then this must be a new transfer
                                    -- show radio buttons to allow the user to choose a date or not.
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                            (v_template,
                                             'TAG_1',
                                             '<font class="DBdata"><input type="radio" name="pNullDate" id="pNullDate1" title="create and send transfer now" value="0"><label for="pNullDate1" title="create and send transfer now"> Send now ('
                                             || TO_CHAR(SYSDATE, 'dd-Mon-yyyy') || ')</label></font>');
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag
                                            (v_template,
                                             'TAG_2',
                                             '<tr><td align="left" height="35" width="290" ><font class="DBdata"><input type="radio" name="pNullDate" id="pNullDate2" title="create transfer now but do not send it" value="1"><label for="pNullDate2" title="create transfer now but do not send it"> Send later</label></font></td>'
                                             || '<td width="40"> </td>'
                                             || '<td colspan="2" align="left" width="300"></td></tr>');
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'CREATE_ON',
                                                                     TO_CHAR(SYSDATE, 'dd-Mon-yyyy'));
                                    -- show the button to allow repayment processing
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'BUTTON',
                                                                     'type=''submit'' value=''Send Working Funds''');
                                    -- save SID value for next iteration of the form.
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', 'bogus');
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', 'to be auto-generated ');
                        
                                    -- find the description of the chosen type of transfer.
                                    SELECT DECODE(description, 'Expense Repayment', 'Payment Listing', description)
                                      INTO v_type_description
                                      FROM T_CFUNDS_XFR_TYPE
                                     WHERE code = ptype;
                        
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TYPE', v_type_description);
                        
                                    IF NOT pamount IS NULL THEN
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag(v_template,
                                                                         'AMOUNT',
                                                                         TO_CHAR(pamount, v_dollar_format));
                                    ELSE
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag(v_template,
                                                                         'AMOUNT',
                                                                         '<input maxLength="10" size="10" name="pAmount">');
                                    END IF;
                                END IF;                                                      -- end New Transfer processing.
                        
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'COMMAND_2', v_command2_specs);
                        
                                -- existing transfer - show details.
                                FOR t IN (SELECT DECODE(cfus.active,
                                                        'N', cfx.sender_name || '<br> (INACTIVE CFUNDS UNIT)',
                                                        cfx.sender_name) sender_desc,
                                                 DECODE(cfur.active,
                                                        'N', cfx.receiver_name || '<br> (INACTIVE CFUNDS UNIT)',
                                                        cfx.receiver_name) receiver_desc,
                                                 cfx.*
                                            FROM v_cfunds_xfr cfx, T_CFUNDS_UNIT cfus, T_CFUNDS_UNIT cfur
                                           WHERE cfx.sender = cfus.SID(+) AND cfx.receiver = cfur.SID(+) AND cfx.SID = v_sid)
                                LOOP
                                    v_type := t.xfr_type;                                   -- save type code for use later
                        
                                    IF t.xfr_type_desc = 'Expense Repayment' THEN
                                        v_type_description := 'Payment Listing';
                                    ELSE
                                        v_type_description := t.xfr_type_desc;
                                    END IF;
                        
                                    IF t.send_date IS NULL THEN
                                        -- show the button to allow transfer to be sent
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag(v_template,
                                                                         'BUTTON',
                                                                         'type=''submit'' value=''Send Transfer''');
                                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAG_1', 'Send Pending');
                                    ELSIF t.receive_date IS NULL THEN
                                        -- show the button to allow repayment processing
                                        -- v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'BUTTON', 'type=''submit'' value=''Accept Transfer''' );
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag(v_template,
                                                                         'BUTTON',
                                                                         'type=''submit'' value=''Accept Transfer''');
                                    ELSE
                                        -- hide the button to prevent repayment processing
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag(v_template,
                                                                         'BUTTON',
                                                                         'type=''hidden'' value=''Hidden''');
                                    END IF;
                        
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'TAG_1',
                                                                     'Sent On: <font class="DBdata">'
                                                                     || TO_CHAR(t.send_date, 'dd-Mon-yyyy') || '</font>');
                                    -- save SID value for next iteration of the form.
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SID', t.SID);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SENT_FROM', t.sender_desc);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', t.voucher_no);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'TYPE', v_type_description);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SEND_TO', t.receiver_desc);
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'AMOUNT',
                                                                     TO_CHAR(t.amount, v_dollar_format));
                        
                                    IF NOT t.receive_date IS NULL THEN
                                        --  Add details for the accepted date if the transfer was accepted.
                                        v_ok :=
                                            Web_Template_Pkg.replace_tag
                                                (v_template,
                                                 'TAG_2',
                                                 '<tr><td align="left" height="35" width="290" >Received On: <font class="DBdata">'
                                                 || TO_CHAR(t.receive_date, 'dd-Mon-yyyy') || '</font></td></tr>');
                                    END IF;
                        
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'CREATE_ON',
                                                                     TO_CHAR(t.create_on, 'dd-Mon-yyyy'));
                                    EXIT;                                       -- we only get one transfer with this query.
                                END LOOP;
                        
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'TAG_2', ' ');
                        
                                LOOP
                                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                                    EXIT WHEN NOT v_ok
                                          OR (v_tag IS NULL);
                        
                                    IF v_tag = 'SEND_TO' THEN
                                        -- setup the cursor for the combo box to select a unit to receive the transfer.
                                        v_cursor2 := DBMS_SQL.OPEN_CURSOR;
                                        v_query2 := '';
                                        v_query2 := v_query2 || ' select U.SID,';
                                        v_query2 :=
                                            v_query2
                                            || '        decode(CFU.ACTIVE,''N'',osi_unit.get_name(U.sid) || '' (INACTIVE CFUNDS UNIT)'',osi_unit.get_name(U.sid)) NAME,';
                                        v_query2 :=
                                            v_query2 || '        decode(U.SID, ''' || psend_to
                                            || ''', ''Y'',null) as SELECTED';
                                        v_query2 := v_query2 || ' from T_OSI_UNIT U, T_CFUNDS_UNIT CFU';
                                        v_query2 := v_query2 || ' where U.SID  = CFU.SID (+)';
                                        v_query2 := v_query2 || ' order by U.UNIT_CODE';
                                        DBMS_SQL.PARSE(v_cursor2, v_query2, dbms_sql.native);
                                        --                                        OWA_CORE_LISTPRINT(V_CURSOR2, 'pSend_To', 1, FALSE);
                                        owa_util.listprint(v_cursor2, 'pSend_To', 1, FALSE);
                                        DBMS_SQL.CLOSE_CURSOR(v_cursor2);
                                    ELSIF v_tag = 'SENT_FROM' THEN
                                        -- setup the cursor for the combo box to select a unit as the sending unit.
                                        v_cursor2 := DBMS_SQL.OPEN_CURSOR;
                                        v_query2 := '';
                                        v_query2 := v_query2 || ' select U.SID,';
                                        v_query2 :=
                                            v_query2
                                            || '        decode(CFU.ACTIVE,''N'',osi_unit.get_name(U.sid) || '' (INACTIVE CFUNDS UNIT)'',osi_unit.get_name(u.sid)) NAME,';
                                        v_query2 :=
                                            v_query2 || '        decode(U.SID, ''' || punit
                                            || ''', ''Y'',null) as SELECTED';
                                        v_query2 := v_query2 || ' from T_OSI_UNIT U, T_CFUNDS_UNIT CFU';
                                        v_query2 := v_query2 || ' where U.SID  = CFU.SID (+)';
                                        v_query2 := v_query2 || ' order by U.UNIT_CODE';
                                        DBMS_SQL.PARSE(v_cursor2, v_query2, dbms_sql.native);
                                        --                                        OWA_CORE_LISTPRINT(V_CURSOR2, 'pUnit', 1, FALSE);
                                        owa_util.listprint(v_cursor2, 'pUnit', 1, FALSE);
                                        DBMS_SQL.CLOSE_CURSOR(v_cursor2);
                                    --This will not be done if this
                                    -- transfer type is WF (working fund transfer).
                                    ELSIF v_tag = 'EXPENSE_LIST' THEN
                                        -- Check to see if this is an Expense Repayment type of transfer.
                                        -- or a 'Disallowed Expense Reimbursement' type.
                                        -- If it is, then we print out the list of Expenses that were repaid by this.
                                        IF    ptype = 'ER'
                                           OR v_type = 'ER'
                                           OR ptype = 'DER'
                                           OR v_type = 'DER' THEN
                                            htp.print('<br><b>Expenses repaid by transfer</b><br>');
                                            htp.print
                                                ('<table border="1"><tr><th>Expense Date</th><th>ID Number</th><th>Expense Category</th><th>Expense Amount</th><th>Status</th></tr>');
                                            v_cursor := DBMS_SQL.OPEN_CURSOR;
                                            v_query := '';
                                            v_query := v_query || 'select';
                                            v_query :=
                                                v_query || '     ''<a  href="' || Web_Util_Pkg.get_current_package
                                                || 'expense_details?pSID='' || e.SID || ''&pUnit=' || punit
                                                || '&pFiscalYear=' || v_fiscal_year
                                                || '&pCategory='' || e.CATEGORY || ''">'' || e.INCURRED_DATE || ''</a>'',';
                                            v_query := v_query || '     e.VOUCHER_NO,';
                                            v_query := v_query || '     e.CATEGORY_DESC,';
                                            v_query :=
                                                 v_query || '     to_char(e.TOTAL_AMOUNT_US,''' || v_dollar_format || '''),';
                                            v_query := v_query || '     e.STATUS';
                                            v_query := v_query || ' from V_CFUNDS_EXPENSE_V3 e,';
                                            v_query := v_query || '      T_CFUNDS_XFR_EXP xe,';
                                            v_query := v_query || '      T_CFUNDS_XFR x';
                                            v_query := v_query || ' where ';
                                            v_query := v_query || '     x.SID = ''' || psid || ''' and';
                                            v_query := v_query || '     x.SID = xe.XFR and';
                                            v_query := v_query || '     e.SID = xe.EXPENSE';
                                            v_query := v_query || ' order by';
                                            v_query := v_query || '     e.INCURRED_DATE';
                                            DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                                            owa_util.cellsprint(v_cursor, 1000, NULL, v_cnt);
                                            htp.print('</table>');
                                        END IF;
                                    ELSE
                                        htp.print('Unexpected tag: ' || v_tag);
                                    END IF;
                                END LOOP;
                        
                                end_serve_page;
                                setunitsid(punit);
                                set_fiscal_year(v_fiscal_year);
                                COMMIT;
                            EXCEPTION
                                WHEN a_stink THEN
                                    exception_handler(TRUE);
                                    end_serve_page;
                                    setunitsid(punit);
                                    set_fiscal_year(v_fiscal_year);
                                WHEN Cfunds_Pkg.bad_timing THEN
                                    exception_handler;
                                    end_serve_page;
                                    setunitsid(punit);
                                    set_fiscal_year(v_fiscal_year);
                                WHEN Cfunds_Pkg.no_privilege THEN
                                    exception_handler;
                                    end_serve_page;
                                    setunitsid(punit);
                                    set_fiscal_year(v_fiscal_year);
                                WHEN Cfunds_Pkg.invalid_parameters THEN
                                    exception_handler;
                                    end_serve_page;
                                    setunitsid(punit);
                                    set_fiscal_year(v_fiscal_year);
                                WHEN OTHERS THEN
                                    htp.print(SQLERRM);
                                    htp.nl;
                                    htp.print(Cfunds_Pkg.get_error_detail);
                                    htp.nl;
                                     --E.G.
                                    --htp.print('from=' || pUnit || '  send=' || pSend_To);
                                     --htp.nl;
                                    end_serve_page;
                                    setunitsid(punit);
                                    set_fiscal_year(v_fiscal_year);
                                    RETURN;
                            END transfer_details;
                        
                            --
                            --
                            -- function Fake_Get_Unit_Accountability( pUnit in Varchar2, pCurrent_Transfer in Varchar2 := null,
                            --                                       pBefore_After in Varchar2 := null ) return Number is
                            --     v_bal Number := 0;
                            -- begin
                            -- -- /* modify this function so that if the pCurrent Transfer is to be included, then it
                            -- --    is included.  if it is to be left out, then leave it out.  modify the sql below to
                            -- --    do this.
                            -- -- */
                            -- --     for x in (select * from T_CFUNDS_XFR
                            -- --               where XFR_TYPE = 'WF' and
                            -- --                     SEND_DATE is not null and
                            -- --                     RECEIVE_DATE is not null and
                            -- --                    (RECEIVER = pUnit or SENDER = pUnit))
                            -- --     loop
                            -- --         if x.RECEIVER = pUnit /* and x.RECEIVE_DATE is not null */ then
                            -- --             v_bal := v_bal + nvl(x.AMOUNT,0);
                            -- --         end if;
                            -- --         if x.SENDER = pUnit /* and x.SEND_DATE is not null */ and
                            -- --            x.SENDER <> x.RECEIVER then
                            -- --             v_bal := v_bal - nvl(x.AMOUNT,0);
                            -- --         end if;
                            -- --     end loop;
                            --
                            --
                            --
                            -- /* modify this function so that if the pCurrent Transfer is to be included, then it
                            --    is included.  if it is to be left out, then leave it out.  modify the sql below to
                            --    do this.
                            -- */
                            --     -- find all, but exclude pCurrent Transfer
                            --     for x in (select * from T_CFUNDS_XFR
                            --               where XFR_TYPE = 'WF' and
                            --                     SEND_DATE is not null and
                            --                     RECEIVE_DATE is not null and
                            --                     SID <> pCurrent_Transfer and
                            --                    (RECEIVER = pUnit or SENDER = pUnit))
                            --     loop
                            --         if x.RECEIVER = pUnit /* and x.RECEIVE_DATE is not null */ then
                            --             v_bal := v_bal + nvl(x.AMOUNT,0);
                            --         end if;
                            --         if x.SENDER = pUnit /* and x.SEND_DATE is not null */ and
                            --            x.SENDER <> x.RECEIVER then
                            --             v_bal := v_bal - nvl(x.AMOUNT,0);
                            --         end if;
                            --     end loop;
                            -- htp.nl;
                            -- htp.p('Without this transfer, balance is: ' || v_bal);
                            -- htp.nl;
                            --
                            --     if pBefore_After = 'True' then
                            --         -- include pCurrent Transfer.
                            --         for x in (select * from T_CFUNDS_XFR
                            --                   where XFR_TYPE = 'WF' and
                            --                         SID = pCurrent_Transfer)
                            --         loop
                            --             if x.RECEIVER = pUnit then
                            --                 v_bal := v_bal + nvl(x.AMOUNT,0);
                            -- htp.p('Adding transfer amount of: ' || x.amount);htp.nl;
                            -- htp.p('x.Receiver is: ' || x.RECEIVER);htp.nl;
                            -- htp.p('pUnit is: ' || pUnit);htp.nl;
                            --             end if;
                            --             if x.SENDER = pUnit and
                            --                x.SENDER <> x.RECEIVER then
                            --                 v_bal := v_bal - nvl(x.AMOUNT,0);
                            -- htp.p('Subtracting transfer amount of: ' || x.amount);htp.nl;
                            --             end if;
                            --         end loop;
                            --
                            -- htp.p('After including or excluding this transfer, balance is: ' || v_bal);htp.nl;
                            --
                            --    -- else
                            --        -- do not include pCurrent Transfer.
                            --     end if;
                            --
                            --
                            --
                            --
                            --
                            --     return v_bal;
                            --
                            -- end Fake_Get_Unit_Accountability;
                            --
                            --
                            --
                            --
                            -- function Fke_Get_UnitOrg_Accountability( pUnit in Varchar2, pCurrent_Transfer in Varchar2,
                            --                                       pBefore_After in Varchar2 ) return Number is
                            --     v_rtn Number := 0;
                            -- begin
                            --     for u in (select SID from T_UNIT
                            --               where Cfunds_Pkg.Get_Unit_Participation(SID) = 'Y'
                            --               connect by PARENT = prior SID
                            --               start with SID = pUnit)
                            --     loop
                            --         v_rtn := v_rtn + nvl(Fake_Get_Unit_Accountability( u.SID),0);
                            --     end loop;
                            --
                            --     if v_rtn = 0 then
                            --         return null;
                            --     else
                            --         return v_rtn;
                            --     end if;
                            --
                            -- end Fke_Get_UnitOrg_Accountability;
                            PROCEDURE transfer_form(psid IN VARCHAR2) IS
                                -- This procedure will launch another browser window with html in report output and the user can
                                -- hit a print button from there.
                                v_template          CLOB;
                                v_template_date     DATE;
                                v_offset            NUMBER         := 1;
                                v_tag               VARCHAR2(100);
                                v_query             VARCHAR2(4000);
                                v_cursor            INTEGER;
                                v_cnt               NUMBER;
                                v_ok                BOOLEAN;
                                v_expensed_amount   VARCHAR2(100);
                                v_claimant_name     VARCHAR(100);
                            BEGIN
                                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Transfer_Form');
                                v_ok := Web_Template_Pkg.get_latest('cfunds_transfer_form', v_template, v_template_date);
                        
                                IF v_template_date IS NULL THEN
                                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_transfer_form"');
                                    htp.print('Could not locate template');
                                    RETURN;
                                END IF;
                        
                                -- Printform will launch another browser window with html in report output and the user can
                                -- hit a print button from there.
                                FOR t IN (SELECT *
                                            FROM v_cfunds_xfr
                                           WHERE SID = psid)
                                LOOP
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'DATE', t.send_date);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SENT_FROM', t.sender_name);
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'ID_NUMBER', t.voucher_no);
                        
                                    IF t.xfr_type = 'ER' THEN
                                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'TYPE', 'PAYMENT LISTING');
                                    ELSE
                                        v_ok := Web_Template_Pkg.replace_tag(v_template, 'TYPE', UPPER(t.xfr_type_desc));
                                    END IF;
                        
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'SEND_TO', t.receiver_name);
                                    v_ok :=
                                        Web_Template_Pkg.replace_tag(v_template,
                                                                     'AMOUNT',
                                                                     TO_CHAR(t.amount, v_dollar_format));
                                    v_ok := Web_Template_Pkg.replace_tag(v_template, 'ACCEPT_DATE', t.receive_date);
                                    EXIT;
                                END LOOP;
                        
                                LOOP
                                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                                    EXIT WHEN NOT v_ok
                                          OR (v_tag IS NULL);
                        
                                    IF v_tag = 'EXPENSE_LISTING' THEN
                                        htp.print('put list of expenses here if needed later.');
                                    --             v_cursor := dbms_sql.open_cursor;
                                    --
                                    --             v_query := '';
                                    --             v_query := v_query ||  'select';
                                    --             v_query := v_query ||  '     ar.VOUCHER_NO,';
                                    --             v_query := v_query ||  '     ar.RECEIVE_ON,';
                                    --             v_query := v_query ||  '     to_char(ar.TOTAL_AMOUNT,''' || v_dollar_format || ''') as TOTAL_AMOUNT,';
                                    --             v_query := v_query ||  '     ''' || v_claimant_name || ''',';
                                    --             v_query := v_query ||  '     ar.RECEIVE_BY';
                                    --             v_query := v_query ||  ' from V_CFUNDS_ADVANCE_REPAYMENT_V2 ar';
                                    --             v_query := v_query ||  ' where ';
                                    --             v_query := v_query ||  '     ar.ADVANCE = ''' || pSID || '''';
                                    --             v_query := v_query ||  ' order by';
                                    --             v_query := v_query ||  '     ar.RECEIVE_ON';
                                    --
                                    --             dbms_sql.parse( v_cursor, v_query, dbms_sql.native );
                                    --
                                    --             owa_util.cellsprint( v_cursor, 1000, null, v_cnt );
                                    --
                                    --             if v_expensed_amount <> '$0.00' then
                                    --                 htp.print('<TR><TD></TD><TD></TD><TD>' || v_expensed_amount || '</TD><TD>Expense</TD><TD></TD></TR>');
                                    --             end if;
                                    ELSE
                                        htp.print(' ');
                                    END IF;
                                END LOOP;
                            END transfer_form;
                        
                            -- changes pending, do not include this in Fiscal Year changes.
                            -- procedure Transfer_Form( pSID in Varchar2 ) is
                            -- -- This procedure will launch another browser window with html in report output and the user can
                            -- -- hit a print button from there.
                            --     v_template Clob;
                            --     v_template_date Date;
                            --     v_offset Number := 1;
                            --     v_tag Varchar2(100);
                            --     v_query Varchar2(4000);
                            --     v_cursor Integer;
                            --     v_cnt Number;
                            --     v_ok Boolean;
                            --     v_expensed_amount Varchar2(100);
                            --     v_claimant_name Varchar(100);
                            --
                            --     v_previous_accountability Number :=0;
                            --     v_new_accountability Number := 0;
                            --     v_sent_prev_acctability Number :=0;
                            --     v_sent_new_acctability Number :=0;
                            --
                            -- begin
                            --
                            --     CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Transfer_Form');
                            --
                            --     v_ok := WEB_TEMPLATE_PKG.Get_Latest( 'cfunds_transfer_form', v_template, v_template_date );
                            --     if v_template_date is null then
                            --         CORE_LOGGER.Log_It( c_pipe, '  Could not locate template "cfunds_transfer_form"' );
                            --         htp.print( 'Could not locate template' );
                            --         return;
                            --     end if;
                            --
                            -- -- Printform will launch another browser window with html in report output and the user can
                            -- -- hit a print button from there.
                            --
                            --     for t in (select * from V_CFUNDS_XFR where sid = pSID)
                            --     loop
                            --
                            --         -- ADD:  Check for if Sending and Receiving units are the same (then it is
                            --         -- HQ transferring to itself for DFAS and we should do something special.
                            --
                            --
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'DATE', t.SEND_DATE );
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'SENT_FROM', t.SENDER_NAME );
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'ID_NUMBER', t.VOUCHER_NO );
                            --
                            -- --*** Keep this if block in real code.
                            --         if t.XFR_TYPE = 'ER' then
                            --             v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'TYPE', 'PAYMENT LISTING' );
                            --         else
                            --             v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'TYPE', upper(t.XFR_TYPE_DESC) );
                            --         end if;
                            --
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'SEND_TO',  t.RECEIVER_NAME );
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'AMOUNT', to_char( t.AMOUNT,v_dollar_format)  );
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'ACCEPT_DATE', t.RECEIVE_DATE );
                            --
                            --         v_previous_accountability := fake_get_unit_accountability(t.RECEIVER, pSID, 'False');
                            --         v_new_accountability := fake_get_unit_accountability(t.RECEIVER, pSID, 'True');
                            --         v_sent_prev_acctability := fake_get_unit_accountability(t.SENDER, pSID, 'False');
                            --         v_sent_new_acctability := fake_get_unit_accountability(t.SENDER, pSID, 'True');
                            --
                            --
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'PREV_ACCT', to_char(v_previous_accountability,v_dollar_format) );
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'AMT_TRANS', to_char( t.AMOUNT,v_dollar_format));
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'NEW_ACCT', to_char(v_new_accountability,v_dollar_format) );
                            --
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'SENT_PREV_ACCT', to_char(v_sent_prev_acctability,v_dollar_format) );
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'SENT_AMT_TRANS', to_char( t.AMOUNT,v_dollar_format));
                            --         v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'SENT_NEW_ACCT', to_char(v_sent_new_acctability,v_dollar_format) );
                            --
                            -- --htp.print('Are these two equal?: ' || v_previous_accountability || ' and ' || v_new_accountability);
                            -- --htp.print('Are these two equal - sent?: ' || v_sent_prev_acctability || ' and ' || v_sent_new_acctability);
                            -- htp.nl;
                            -- htp.p('v_previous_accountability: ' || v_previous_accountability);htp.nl;
                            -- htp.p('v_new_accountability: ' || v_new_accountability);htp.nl;
                            -- htp.p('v_sent_prev_acctability: ' || v_sent_prev_acctability);htp.nl;
                            -- htp.p('v_sent_new_acctability: ' || v_sent_new_acctability);
                            -- htp.nl;
                            --         -- replace these tags with space if the amounts are equal.
                            --         -- for unequal amounts, the tags are replaced below wiht multiple lines
                            --         -- when the page is served.
                            --         if v_previous_accountability <> v_new_accountability then
                            -- --htp.print('These two are not equal: ' || v_previous_accountability || ' and ' || v_new_accountability);
                            --             v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'SCRIPT_RECEIVED',' ' );
                            --         end if;
                            --
                            --         if v_sent_prev_acctability <> v_sent_new_acctability then
                            -- --htp.print('These two are not equal - sent: ' || v_sent_prev_acctability || ' and ' || v_sent_new_acctability);
                            --             v_ok := WEB_TEMPLATE_PKG.Replace_Tag( v_template, 'SCRIPT_SENT',' ' );
                            --         end if;
                            --
                            --       exit;
                            --     end loop;
                            --
                            --     loop
                            --         v_ok := WEB_TEMPLATE_PKG.Serve_Page( v_template, 'WEBTOK@', v_offset, v_tag );
                            --
                            --    exit when not v_ok or (v_tag is null);
                            --
                            --      if v_tag = 'EXPENSE_LISTING' then
                            --
                            --             htp.print('put list of expenses here if needed later.');
                            -- --             v_cursor := dbms_sql.open_cursor;
                            -- --
                            -- --             v_query := '';
                            -- --             v_query := v_query ||  'select';
                            -- --             v_query := v_query ||  '     ar.VOUCHER_NO,';
                            -- --             v_query := v_query ||  '     ar.RECEIVE_ON,';
                            -- --             v_query := v_query ||  '     to_char(ar.TOTAL_AMOUNT,''' || v_dollar_format || ''') as TOTAL_AMOUNT,';
                            -- --             v_query := v_query ||  '     ''' || v_claimant_name || ''',';
                            -- --             v_query := v_query ||  '     ar.RECEIVE_BY';
                            -- --             v_query := v_query ||  ' from V_CFUNDS_ADVANCE_REPAYMENT_V2 ar';
                            -- --             v_query := v_query ||  ' where ';
                            -- --             v_query := v_query ||  '     ar.ADVANCE = ''' || pSID || '''';
                            -- --             v_query := v_query ||  ' order by';
                            -- --             v_query := v_query ||  '     ar.RECEIVE_ON';
                            -- --
                            -- --             dbms_sql.parse( v_cursor, v_query, dbms_sql.native );
                            -- --
                            -- --             owa_util.cellsprint( v_cursor, 1000, null, v_cnt );
                            -- --
                            -- --             if v_expensed_amount <> '$0.00' then
                            -- --                 htp.print('<TR><TD></TD><TD></TD><TD>' || v_expensed_amount || '</TD><TD>Expense</TD><TD></TD></TR>');
                            -- --             end if;
                            --         elsif v_tag = 'SCRIPT_SENT' then
                            --             htp.print('<script language="vbscript" type="text/vbscript">');
                            --             htp.print( '<!-- ');
                            --             htp.print( 'SentAccountability.innerHTML=" " ');
                            --             htp.print( '-->');
                            --             htp.print( '</script>');
                            --         elsif v_tag = 'SCRIPT_RECEIVED' then
                            --             htp.print('<script language="vbscript" type="text/vbscript">');
                            --             htp.print( '<!-- ');
                            --             htp.print( 'Accountability.innerHTML=" " ');
                            --             htp.print( '-->');
                            --             htp.print( '</script>');
                            --         else
                            --             htp.print( ' ');
                            --         end if;
                            --
                            --     end loop;
                            --
                            -- end Transfer_Form;
                            PROCEDURE transfers(punit IN VARCHAR2 := NULL, pfiscalyear IN VARCHAR2) IS
                                v_template        CLOB;
                                v_template_date   DATE;
                                v_offset          NUMBER                   := 1;
                                v_tag             VARCHAR2(100);
                                v_query           VARCHAR2(4000);
                                v_query_status    VARCHAR2(400);
                                v_cursor          INTEGER;
                                v_cnt             NUMBER;
                                v_ok              BOOLEAN;
                                v_fiscal_year     VARCHAR2(10);
                                v_unit            T_CFUNDS_UNIT.SID%TYPE;
                            BEGIN
                                begin_serve_page('E-Funds Transfers', TRUE, TRUE, ' ', 'E-Funds Transfers', 'home_page');
                                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Transfers');
                                v_ok := Web_Template_Pkg.get_latest('cfunds_transfers', v_template, v_template_date);
                        
                                IF v_template_date IS NULL THEN
                                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_transfers"');
                                    htp.print('Could not locate template');
                                    RETURN;
                                END IF;
                        
                                -- if the unit wasn't specified, use the current user's unit.
                                v_unit := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                                -- if the fiscal year wasn't specified, use the current fiscal year.
                                v_fiscal_year := NVL(pfiscalyear, Cfunds_Pkg.get_fiscal_year(SYSDATE));
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                                -- remember the Fiscal Year
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', v_fiscal_year);
                                v_ok :=
                                    Web_Template_Pkg.replace_tag(v_template,
                                                                 'FISCAL_YEAR_LABEL',
                                                                 get_html_fy_dropdown(v_fiscal_year));
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', v_unit);
                        
                                LOOP
                                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                                    EXIT WHEN NOT v_ok
                                          OR (v_tag IS NULL);
                        
                                    -- Now process each found tag
                                    IF v_tag = 'TRANSFER_LIST' THEN
                                        FOR h IN
                                            (SELECT   t.SID, t.receiver, t.voucher_no, t.send_date,
                                                      TO_CHAR(t.amount, v_dollar_format) AS amount,
                                                      DECODE(t.xfr_type_desc,
                                                             'Expense Repayment', 'Payment Listing',
                                                             t.xfr_type_desc) AS xfr_type_desc,
                                                      t.sender_name, t.receiver_name,
                                                      DECODE(t.status,
                                                             'Sent', '<font color="red"><b>' || t.status || '</b></font>',
                                                             t.status) AS status
                                                 FROM v_cfunds_xfr t
                                                WHERE receiver = v_unit
                                                      AND Cfunds_Pkg.get_transfer_fy(t.SID) = v_fiscal_year
                                             UNION ALL
                                             SELECT   t.SID, t.receiver, t.voucher_no, t.send_date,
                                                      TO_CHAR(t.amount, v_dollar_format) AS amount,
                                                      DECODE(t.xfr_type_desc,
                                                             'Expense Repayment', 'Payment Listing',
                                                             t.xfr_type_desc) AS xfr_type_desc,
                                                      t.sender_name, t.receiver_name,
                                                      DECODE(t.status,
                                                             'Send Pending', '<font color="red"><b>' || t.status
                                                              || '</b></font>',
                                                             t.status) AS status
                                                 FROM v_cfunds_xfr t
                                                WHERE sender = v_unit
                                                  AND receiver <> v_unit
                                                  AND        --This transfer would already be included from the query above.
                                                      Cfunds_Pkg.get_transfer_fy(t.SID) = v_fiscal_year
                                             ORDER BY 4 DESC)
                                        LOOP
                                            htp.print('<tr><td nowrap><a href="' || Web_Util_Pkg.get_current_package
                                                      || 'transfer_details?pSID=' || h.SID || '&pSend_To=' || h.receiver
                                                      || '&pUnit=' || v_unit || '&pFiscalYear=' || v_fiscal_year || '">'
                                                      || h.voucher_no || '</a></td>' || '<td nowrap>' || h.send_date
                                                      || '</td>' || '<td nowrap>' || h.amount || '</td>' || '<td nowrap>'
                                                      || h.xfr_type_desc || '</td>' || '<td nowrap>' || h.sender_name
                                                      || '</td>' || '<td nowrap>' || h.receiver_name || '</td>'
                                                      || '<td nowrap>' || h.status || '</td></tr>');
                                        END LOOP;
                                    ELSE
                                        htp.print('Unexpected tag: ' || v_tag);
                                    END IF;
                                END LOOP;
                        
                                end_serve_page;
                                setunitsid(v_unit);
                                set_fiscal_year(v_fiscal_year);
                            EXCEPTION                                                   -- handle eception with default info
                                WHEN OTHERS THEN
                                    Core_Logger.log_it(c_pipe, 'TRANSFER_LIST: Others.');
                                    end_serve_page;
                                    setunitsid(v_unit);
                                    set_fiscal_year(v_fiscal_year);
                            END transfers;
                        
                            PROCEDURE unit_list(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
                                --  Parameters
                                vp_unit           T_OSI_UNIT.SID%TYPE;
                                vp_command        VARCHAR2(100);
                                vp_fiscal_year    VARCHAR2(10);
                                --  Template Processing
                                v_template        CLOB;
                                v_template_date   DATE;
                                v_offset          NUMBER                  := 1;
                                v_tag             VARCHAR2(100);
                                v_self            VARCHAR2(500);
                                v_feedback        VARCHAR2(5000)          := NULL;
                                --  Query Processing/General
                                v_cfu_rec         T_CFUNDS_UNIT%ROWTYPE;
                                v_row_editable    VARCHAR2(5);
                                v_unit            VARCHAR2(20)            := NULL;
                                v_participating   VARCHAR2(1)             := NULL;
                                v_reviewer        VARCHAR2(1)             := NULL;
                                v_active          VARCHAR2(1)             := NULL;
                                v_attr            VARCHAR2(500)           := NULL;
                                v_query           VARCHAR2(4000);
                                v_cursor          INTEGER;
                                v_ins_cnt         NUMBER                  := 0;
                                v_upd_cnt         NUMBER                  := 0;
                                v_del_cnt         NUMBER                  := 0;
                                v_opencf          NUMBER                  := 0;
                                v_openadv         NUMBER;
                                v_openexp         NUMBER;
                                v_openxfr         NUMBER;
                                v_ok              BOOLEAN;
                        
                                PROCEDURE load_cfu(psid IN VARCHAR2) IS
                                BEGIN
                                    SELECT *
                                      INTO v_cfu_rec
                                      FROM T_CFUNDS_UNIT
                                     WHERE SID = psid;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        v_cfu_rec := NULL;
                                END load_cfu;
                            BEGIN
                                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Unit_List');
                                Web_Util_Pkg.send_comment('Current user: ' || Core_Context.personnel_name);
                                Web_Util_Pkg.dump_params(name_array, value_array);
                                -- Get control parameters
                                vp_command :=
                                       NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pCommand'), 'Refresh');
                                vp_unit :=
                                    NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                                        Cfunds_Pkg.get_my_cfunds_unit);
                                vp_fiscal_year := Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear');
                                -- E.G this fix should work on lower and recent version of oracle.
                                --  v_self := '!' || WEB_UTIL_PKG.Get_Self;
                                v_self := '!' || REPLACE(Web_Util_Pkg.get_self, '!', '');
                                begin_serve_page('E-Funds Setup Unit List',
                                                 TRUE,
                                                 TRUE,
                                                 ' ',
                                                 'E-Funds Setup Unit List',
                                                 'DoHistory');
                        
                                -- Process commands. Only real command is 'Update'. Default processing
                                -- is the 'Refresh' command (which gets executed in all cases).
                                IF vp_command = 'Update' THEN
                                    Web_Util_Pkg.send_comment('Processing Update');
                        
                                    --         v_error_detail := 'The Update function is not yet implemented.';
                                    --         raise A_STINK;
                        
                                    -- Sort through the parameters looking for non-Null pPartList or pRevList
                                    -- values. For each one found, update (or insert) the row in T_CFUNDS_UNIT.
                                    FOR i IN name_array.FIRST .. name_array.LAST
                                    LOOP
                                        IF name_array(i) = 'pPartList' THEN
                                            v_participating := value_array(i);
                                        END IF;
                        
                                        IF name_array(i) = 'pRevList' THEN
                                            v_reviewer := value_array(i);
                                        END IF;
                        
                                        IF name_array(i) = 'pActiveList' THEN
                                            v_active := value_array(i);
                                        END IF;
                        
                                        IF name_array(i) = 'pUnitList' THEN
                                            v_unit := value_array(i);
                                            -- This is the last element of the PartList/RevList/UnitList set,
                                            -- so process this set.
                                            load_cfu(v_unit);
                        
                                            /*
                                                            if v_cfu_rec.SID is null then
                                                                WEB_UTIL_PKG.SEND_COMMENT('Unit ' || v_unit || ' is not current a participating unit');
                                                            else
                                                                WEB_UTIL_PKG.SEND_COMMENT('Unit ' || v_cfu_rec.UNIT_NAME || ' is reviewer: ' || v_cfu_rec.REVIEWING_UNIT);
                                                            end if;
                        
                                                            WEB_UTIL_PKG.SEND_COMMENT( 'pPartList: ' || v_participating );
                                                            WEB_UTIL_PKG.SEND_COMMENT( 'pRevList:  ' || v_reviewer );
                                            */              -- If PartList is null, then try to delete the row from T_CFUNDS_UNIT.
                                                            -- If there are any expenses, advances, transfers, etc., the delete
                                                            -- will fail (and so will this web page).
                        
                                            --check for open Cfund expenses, advances and transfers (count to see if any exist)
                                            SELECT COUNT(*)
                                              INTO v_openadv
                                              FROM T_CFUNDS_ADVANCE_V2
                                             WHERE unit = v_unit AND close_date IS NULL;
                        
                                            SELECT COUNT(*)
                                              INTO v_openexp
                                              FROM T_CFUNDS_EXPENSE_V3
                                             WHERE (   charge_to_unit = v_unit
                                                    OR reviewing_unit = v_unit) AND closed_on IS NULL;
                        
                                            SELECT COUNT(*)
                                              INTO v_openxfr
                                              FROM T_CFUNDS_XFR
                                             WHERE (   sender = v_unit
                                                    OR receiver = v_unit) AND receive_date IS NULL;
                        
                                            v_opencf := v_openadv + v_openexp + v_openxfr;
                        
                                            IF Cfunds_Test_Cfp('EXP_PAY',
                                                               Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                                               Core_Context.personnel_sid,
                                                               Cfunds_Pkg.get_parent_unit(v_unit)) = 'N' THEN
                                                NULL;                                                  -- don't do anything
                                            ELSIF v_participating IS NULL AND v_cfu_rec.SID IS NOT NULL THEN
                                                -- WEB_UTIL_PKG.SEND_COMMENT( 'Deleting ' || v_cfu_rec.UNIT_NAME );
                                                DELETE FROM T_CFUNDS_UNIT
                                                      WHERE SID = v_unit;
                        
                                                v_del_cnt := v_del_cnt + SQL%rowcount;
                                            ELSIF     v_participating IS NOT NULL
                                                  AND v_cfu_rec.SID IS NOT NULL
                                                  AND (   NVL(v_cfu_rec.reviewing_unit, 'N') <> NVL(v_reviewer, 'N')
                                                       OR NVL(v_cfu_rec.active, 'N') <> NVL(v_active, 'N')) THEN
                                                -- WEB_UTIL_PKG.SEND_COMMENT( 'Updating ' || v_cfu_rec.UNIT_NAME );
                        
                                                --check for open cfunds before allowing user to make a unit inactive
                                                IF v_active IS NULL AND(v_opencf > 0) THEN
                                                    v_error_detail := 'There are the following open cfunds: <br>';
                        
                                                    IF v_openadv > 0 THEN
                                                        v_error_detail :=
                                                              v_error_detail || v_openadv || ' open Cfunds Advance(s) <br>';
                                                    END IF;
                        
                                                    IF v_openexp > 0 THEN
                                                        v_error_detail :=
                                                               v_error_detail || v_openexp || ' open Cfunds Expense(s)<br>';
                                                    END IF;
                        
                                                    IF v_openxfr > 0 THEN
                                                        v_error_detail :=
                                                             v_error_detail || v_openxfr || ' open Cfunds Transfer(s) <br>';
                                                    END IF;
                        
                                                    v_error_detail :=
                                                        v_error_detail
                                                        || ' These items must be closed before this unit can become inactive.';
                                                    RAISE a_stink;
                                                ELSE
                                                    UPDATE T_CFUNDS_UNIT
                                                       SET reviewing_unit = NVL(v_reviewer, 'N'),
                                                           active = NVL(v_active, 'N'),
                                                           modify_by = Core_Context.personnel_name,
                                                           modify_on = SYSDATE
                                                     WHERE SID = v_unit;
                                                END IF;
                        
                                                v_upd_cnt := v_upd_cnt + SQL%rowcount;
                                            ELSIF v_participating IS NOT NULL AND v_cfu_rec.SID IS NULL THEN
                                                -- WEB_UTIL_PKG.SEND_COMMENT( 'Inserting ' || v_unit );
                        
                                                --check for open cfunds before allowing user to make a unit inactive
                                                IF v_active IS NULL AND(v_opencf > 0) THEN
                                                    v_error_detail := 'There are the following open cfunds: <br>';
                        
                                                    IF v_openadv > 0 THEN
                                                        v_error_detail :=
                                                              v_error_detail || v_openadv || ' open Cfunds Advance(s) <br>';
                                                    END IF;
                        
                                                    IF v_openexp > 0 THEN
                                                        v_error_detail :=
                                                               v_error_detail || v_openexp || ' open Cfunds Expense(s)<br>';
                                                    END IF;
                        
                                                    IF v_openxfr > 0 THEN
                                                        v_error_detail :=
                                                             v_error_detail || v_openxfr || ' open Cfunds Transfer(s) <br>';
                                                    END IF;
                        
                                                    v_error_detail :=
                                                        v_error_detail
                                                        || ' These items must be closed before this unit can become inactive.';
                                                    RAISE a_stink;
                                                ELSE
                                                    INSERT INTO T_CFUNDS_UNIT
                                                                (SID,
                                                                 reviewing_unit,
                                                                 active,
                                                                 pay_from_wf,
                                                                 create_by,
                                                                 create_on,
                                                                 modify_by,
                                                                 modify_on)
                                                         VALUES (v_unit,
                                                                 NVL(v_reviewer, 'N'),
                                                                 NVL(v_active, 'N'),
                                                                 'Y',
                                                                 Core_Context.personnel_name,
                                                                 SYSDATE,
                                                                 Core_Context.personnel_name,
                                                                 SYSDATE);
                        
                                                    v_ins_cnt := v_ins_cnt + SQL%rowcount;
                                                END IF;
                                            END IF;
                        
                                            -- Reset variables for next time
                                            v_participating := NULL;
                                            v_reviewer := NULL;
                                            v_active := NULL;
                                        END IF;
                                    END LOOP;                                                                           -- i
                        
                                    COMMIT;                                                  -- only called if no exceptions
                                --        rollback;
                                END IF;                                                                 -- Update processing
                        
                                -- Start default (Refresh) processing
                        
                                -- Check privilege to even show the information
                        
                                --     if CFUNDS_TEST_CFP('EXP_PAY', core_obj.lookup_objtype('CFUNDS_EXP'),core_context.personnel_sid, vp_Unit) = 'N' then
                                --         v_error_detail := 'You do not have privilege to view the ' ||
                                --                           'specified unit.';
                                --         raise A_STINK;
                                --     end if;
                                v_ok := Web_Template_Pkg.get_latest('cfunds_unit_list', v_template, v_template_date);
                        
                                IF v_template_date IS NULL THEN
                                    Core_Logger.log_it(c_pipe, '  Could not locate template "cfunds_unit_list"');
                                    htp.print('Could not locate template');
                                    RETURN;
                                END IF;
                        
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', v_self || '?a=1');
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
                                v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
                        
                                LOOP
                                    v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                                    EXIT WHEN NOT v_ok
                                          OR (v_tag IS NULL);
                        
                                    -- Now process each found tag
                                    IF v_tag = 'FEEDBACK' THEN
                                        IF v_ins_cnt + v_upd_cnt + v_del_cnt > 0 THEN
                                            htp.print('Inserted ' || v_ins_cnt || ' units.<br>');
                                            htp.print('Updated  ' || v_upd_cnt || ' units.<br>');
                                            htp.print('Deleted  ' || v_del_cnt || ' units.<br>');
                                        END IF;
                                    ELSIF v_tag = 'UNIT_SET_LIST' THEN
                                        FOR u IN (SELECT     SID, unit_code, Osi_Unit.get_name(SID) unit_name, LEVEL
                                                        FROM T_OSI_UNIT
                                                  CONNECT BY unit_parent = PRIOR SID
                                                  START WITH SID = vp_unit)
                                        LOOP
                                            load_cfu(u.SID);
                                            v_row_editable :=
                                                Cfunds_Test_Cfp('EXP_PAY',
                                                                Core_Obj.lookup_objtype('CFUNDS_EXP'),
                                                                Core_Context.personnel_sid,
                                                                NVL(Cfunds_Pkg.get_parent_unit(u.SID), u.SID));
                                            htp.prn('<tr');
                        
                                            IF v_row_editable <> 'Y' THEN
                                                htp.prn(' bgcolor=Silver');
                                                v_attr := ' disabled';
                                            ELSE
                                                v_attr := NULL;
                                            END IF;
                        
                                            htp.print('>');
                                            htp.prn('<td>');
                        
                                            FOR i IN 1 ..(u.LEVEL - 1)
                                            LOOP
                                                htp.prn('-&nbsp;');
                                            END LOOP;
                        
                                            htp.prn(u.unit_name);
                                            htp.print('</td>');
                                            htp.prn('<td align="center">');
                                            htp.prn('<input type="checkbox" name="pPartList" value="Y"' || v_attr);
                        
                                            IF v_cfu_rec.SID IS NOT NULL THEN
                                                htp.prn(' checked');
                                            END IF;
                        
                                            htp.prn('>');
                                            htp.print('</td>');
                                            htp.prn('<td align="center">');
                                            htp.prn('<input type="checkbox" name="pRevList" value="Y"' || v_attr);
                        
                                            IF v_cfu_rec.reviewing_unit = 'Y' THEN
                                                htp.prn(' checked');
                                            END IF;
                        
                                            htp.prn('>');
                                            htp.print('</td>');
                                            htp.prn('<td align="center">');
                                            htp.prn('<input type="checkbox" name="pActiveList" value="Y"' || v_attr);
                        
                                            IF v_cfu_rec.active = 'Y' THEN
                                                htp.prn(' checked');
                                            END IF;
                        
                                            htp.prn('>');
                                            htp.prn('<input type="hidden" name="pUnitList" value="' || u.SID || '">');
                                            htp.print('</td>');
                                            htp.print('</tr>');
                                        END LOOP;
                                    ELSIF v_tag = 'UNIT_PICK_LIST' THEN
                                        -- setup the cursor for the combo box to select a unit
                                        v_cursor := DBMS_SQL.OPEN_CURSOR;
                                        v_query := '';
                                        v_query := v_query || ' select U.SID,';
                                        v_query :=
                                            v_query
                                            || '        decode(CFU.ACTIVE,''N'',osi_unit.get_name(U.sid) || '' (INACTIVE CFUNDS UNIT)'',osi_unit.get_name(u.sid)) NAME,';
                                        v_query :=
                                            v_query || '        decode(U.SID, ''' || vp_unit
                                            || ''', ''Y'',null) as SELECTED';
                                        v_query := v_query || ' from T_OSI_UNIT U, T_CFUNDS_UNIT CFU';
                                        v_query := v_query || ' where U.SID  = CFU.SID (+)';
                                        v_query := v_query || ' order by U.UNIT_CODE';
                                        DBMS_SQL.PARSE(v_cursor, v_query, dbms_sql.native);
                                        --                                        OWA_CORE_LISTPRINT(V_CURSOR, 'pUnitPick', 1, FALSE);
                                        owa_util.listprint(v_cursor, 'pUnitPick', 1, FALSE);
                                        DBMS_SQL.CLOSE_CURSOR(v_cursor);
                                    ELSE
                                        htp.print('[' || v_tag || ']');
                                    END IF;
                                END LOOP;
                        
                                ROLLBACK;
                                end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                            EXCEPTION
                                WHEN a_stink THEN
                                    exception_handler(TRUE);
                                    end_serve_page;
                                WHEN OTHERS THEN
                                    IF v_error_detail IS NULL THEN
                                        v_error_detail := SQLERRM;
                                    END IF;
                        
                                    exception_handler(TRUE);
                                    v_error_detail := NULL;
                                    end_serve_page;
                                    setunitsid(vp_unit);
                                    set_fiscal_year(vp_fiscal_year);
                            END unit_list;
                        
                            PROCEDURE test_payment_listing(punit IN VARCHAR2) IS
                                v_unit_sid     T_CFUNDS_UNIT.SID%TYPE;
                                v_uo_lim_tot   NUMBER;
                                v_child_lim    NUMBER;
                                v_string       VARCHAR2(30000);
                            BEGIN
                                begin_serve_page('E-Funds Test Payment Listing',
                                                 FALSE,
                                                 FALSE,
                                                 ' ',
                                                 'E-Funds Test Payment Listing');
                                -- find the unit to default to if not sent in as a parameter
                                v_unit_sid := NVL(punit, Cfunds_Pkg.get_my_cfunds_unit);
                                htp.p('pReimbursing_Unit = ' || v_unit_sid);
                                htp.nl;
                                v_uo_lim_tot := NVL(Cfunds_Pkg.get_unit_limitation(v_unit_sid, 'EXP', '%', SYSDATE), 0);
                                htp.print('starting total: ' || v_uo_lim_tot);
                                htp.nl;
                                htp.print('<table border=1>');
                                htp.tableRowOpen;
                                    htp.tabledata('UNIT', 'left', 'j', 'true', '1', '1', 'width="200"');
                                    htp.tabledata('LIMITATIONS for Unit', 'left', 'j', 'true', '1', '1', 'width="200"');
                                    htp.tabledata('Running Total', 'left', 'j', 'true', '1', '1', 'width="200"');
                                htp.tableRowClose;
                        
                                FOR u IN (SELECT SID, unit_name
                                            FROM v_cfunds_unit
                                           WHERE PARENT = v_unit_sid)
                                LOOP
                                    v_child_lim := Cfunds_Pkg.get_unit_limitation(u.SID, 'OXT', '%', SYSDATE);
                        
                                    IF v_child_lim IS NULL THEN
                                        v_child_lim := Cfunds_Pkg.get_unit_limitation(u.SID, 'EXP', '%', SYSDATE);
                                    END IF;
                        
                                    v_uo_lim_tot := v_uo_lim_tot + NVL(v_child_lim, 0);
                                    htp.tableRowOpen;
                                        htp.tabledata(u.unit_name, 'left', 'j', 'true', '1', '1', 'width="200"');
                                        htp.tabledata(v_child_lim, 'left', 'j', 'true', '1', '1', 'width="200"');
                                        htp.tabledata(v_uo_lim_tot, 'left', 'j', 'true', '1', '1', 'width="200"');
                                    htp.tableRowClose;
                                END LOOP;
                    
                            htp.tableClose;
                    
                            IF v_uo_lim_tot <> NVL(Cfunds_Pkg.get_unit_limitation(v_unit_sid, 'OXT', '%', SYSDATE), 0) THEN
                                htp.nl;
                                htp.print('You cannot reimburse expenses now because the '
                                          || 'total expense limitation for the organization '
                                          || 'is different than the target limitation. The actual '
                                          || '(or target) expense limitations for the subordinate units '
                                          || '(or organizations) must be decreased. ');
                                htp.nl;
                                htp.print('total from running calculations above: ' || v_uo_lim_tot);
                                htp.nl;
                                htp.print('total from Get Unit Limitation: '
                                          || NVL(Cfunds_Pkg.get_unit_limitation(v_unit_sid, 'OXT', '%', SYSDATE), 0));
                                htp.nl;
                            END IF;
                    
                            htp.print(v_string || ' END.');
                            end_serve_page;
                        EXCEPTION
                            WHEN a_stink THEN
                                exception_handler(TRUE);
                                end_serve_page;
                                setunitsid(v_unit_sid);
                            WHEN OTHERS THEN
                                htp.print(SQLERRM);
                                htp.nl;
                                htp.print(Cfunds_Pkg.get_error_detail);
                                htp.nl;
                                end_serve_page;
                                setunitsid(v_unit_sid);
                                RETURN;
                        END test_payment_listing;
                    
                        PROCEDURE zero_all(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
                            --  Parameters
                            vp_unit           T_OSI_UNIT.SID%TYPE;
                            vp_fiscal_year    VARCHAR2(10);
                            --  Template Processing
                            v_template        CLOB;
                            v_template_date   DATE;
                            v_offset          NUMBER                := 1;
                            v_tag             VARCHAR2(100);
                            --  Query Processing/General
                            v_this_unit       VARCHAR2(100);
                            v_this_parent     VARCHAR2(100);
                            v_start_date      DATE;
                            v_end_date        DATE;
                            v_today           DATE;
                            v_ok              BOOLEAN;
                            v_count           BINARY_INTEGER        := 0;
                            v_idx             BINARY_INTEGER        := 0;
                            punits_array      Cfunds_Pkg.str_arr;
                            pother_array      Cfunds_Pkg.str_arr;
                            v_seconds         NUMBER                := 85000;
                            v_sec             NUMBER;
                            v_sum             NUMBER;
                        BEGIN
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Zero_All entered');
                            begin_serve_page('Zero Region/Unit', TRUE, TRUE, ' ', 'Zero Region/Unit', 'home_page');
                            vp_unit :=
                                NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                                    Cfunds_Pkg.get_my_cfunds_unit);
                            vp_fiscal_year :=
                                NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear'),
                                    Cfunds_Pkg.get_fiscal_year(SYSDATE));
                    
                            IF Cfunds_Test_Cfp('CF_EOY_ZERO',
                                               Core_Obj.lookup_objtype('NONE'),
                                               Core_Context.personnel_sid,
                                               vp_unit) = 'N' THEN
                                -- OR v_Reviewing_Unit = 'N' THEN
                                v_error_detail := 'You do not have privilege to perform EOY processing.';
                                htp.p('<INPUT TYPE="hidden" NAME="pFiscalYear" VALUE="' || vp_fiscal_year || '">');
                                htp.p('<INPUT TYPE="hidden" NAME="pUnit" VALUE="' || vp_unit || '">');
                                RAISE a_stink;
                            END IF;
                    
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All hq unit is ' || vp_Unit);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All fiscal year is ' || vp_fiscal_year);
                            Cfunds_Pkg.get_units_eoy_order(vp_unit, FALSE, punits_array, pother_array, v_count);
                            IF v_count = 0 THEN
                                Core_Logger.log_it(c_pipe, '  No units found "cfunds_send_closing_all"');
                                htp.print('Could not locate units');
                                RETURN;
                            END IF;
                    
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All v_count is ' || v_count);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (1) is ' || pUnits_Array(1));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (2) is ' || pUnits_Array(2));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (3) is ' || pUnits_Array(3));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (4) is ' || pUnits_Array(4));
                    
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (1) is ' || pOther_Array(1));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (2) is ' || pOther_Array(2));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (3) is ' || pOther_Array(3));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All (4) is ' || pOther_Array(4));
                            v_start_date := Cfunds_Pkg.get_fiscal_year_start_date(vp_fiscal_year);
                            --v_start_date := TO_DATE('01-JAN-2001');--
                            v_end_date := Cfunds_Pkg.get_fiscal_year_end_date(vp_fiscal_year);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All START DATE' || v_start_date);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_All END DATE' || v_end_date);
                            Core_Logger.Log_It( c_pipe, 'Cfunds_Web.Zero_All got dates' );
                            v_ok := Web_Template_Pkg.get_latest('cfunds_send_closing_all', v_template, v_template_date);
                    
                            IF v_template_date IS NULL THEN
                                Core_Logger.log_it(c_pipe, '  Could NOT locate template "cfunds_send_closing_all"');
                                htp.print('Could NOT locate template');
                                RETURN;
                            END IF;
                    
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                            -- remember the Fiscal Year
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', vp_fiscal_year);
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
                            v_ok := Web_Template_Pkg.serve_page(v_template, 'WEBTOK@', v_offset, v_tag);
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Zero_All BEGIN processing');
                            v_idx := 1;
                    
                            LOOP
                                v_sec := v_seconds / 86400;
                                -- use second timetags so the tranlog has everything in order
                                v_seconds := v_seconds + 1;
                                v_this_unit := punits_array(v_idx);
                                v_this_parent := pother_array(v_idx);
                                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Zero_All doing ' || v_this_unit || ' parent = ' || v_this_parent);
                                zero_region_unit(v_this_unit, v_this_parent, v_start_date, v_end_date + v_sec);
                                v_idx := v_idx + 1;
                    
                                IF v_idx > v_count THEN
                                    EXIT;
                                END IF;
                            END LOOP;
                    
                            --Process final transfer for HQ
                            v_seconds := v_seconds + 10;
                            v_sec := v_seconds / 86400;
                    
                            SELECT -1 * SUM(amount)
                              INTO v_sum
                              FROM T_CFUNDS_XFR x
                             WHERE x.xfr_type = 'WFAF'
                               AND x.receiver = v_hq_cc_unit_sid--'1010005M'
                               AND x.receive_date > v_end_date
                               AND x.sender <> v_hq_cc_unit_sid;--'1010005M';
                    
                            IF v_sum <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_hq_cc_unit_sid,--'1010005M',
                                                                 v_hq_cc_unit_sid,--'1010005M',
                                                                 v_sum,
                                                                 'WFAF',
                                                                 v_end_date + v_sec,
                                                                 'TP');
                            END IF;
                    
                            htp.print('<tr><td nowrap>' || 'COMMAND' || '</td>' || '<td nowrap>' || v_sum || '</td>');
                            v_seconds := v_seconds - 1;
                            v_sec := v_seconds / 86400;
                    
                            SELECT -1 * SUM(amount)
                              INTO v_sum
                              FROM T_CFUNDS_XFR x
                             WHERE x.xfr_type = 'DFOTF'
                               AND x.receiver = v_hq_cc_unit_sid--'1010005M'
                               AND x.receive_date > v_end_date
                               AND x.sender <> v_hq_cc_unit_sid;--'1010005M';
                    
                            IF v_sum <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_hq_cc_unit_sid,--'1010005M',
                                                                 v_hq_cc_unit_sid,--'1010005M',
                                                                 v_sum,
                                                                 'DFOTF',
                                                                 v_end_date + v_sec,
                                                                 'TP');
                            END IF;
                    
                            htp.print('<td nowrap>' || v_sum || '</td>');
                            v_seconds := v_seconds - 1;
                            v_sec := v_seconds / 86400;
                    
                            SELECT -1 * SUM(amount)
                              INTO v_sum
                              FROM T_CFUNDS_XFR x
                             WHERE x.xfr_type = 'OA'
                               AND x.receiver = v_hq_cc_unit_sid--'1010005M'
                               AND x.receive_date > v_end_date
                               AND x.sender <> v_hq_cc_unit_sid;--'1010005M';
                    
                            IF v_sum <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_hq_cc_unit_sid,--'1010005M',
                                                                 v_hq_cc_unit_sid,--'1010005M',
                                                                 v_sum,
                                                                 'OA',
                                                                 v_end_date + v_sec,
                                                                 'TP');
                            END IF;
                    
                            htp.print('<td nowrap>' || v_sum || '</td>');
                            v_seconds := v_seconds - 1;
                            v_sec := v_seconds / 86400;
                    
                            SELECT -1 * SUM(amount)
                              INTO v_sum
                              FROM T_CFUNDS_XFR x
                             WHERE x.xfr_type = 'OE'
                               AND x.receiver = v_hq_cc_unit_sid--'1010005M'
                               AND x.receive_date > v_end_date
                               AND x.sender <> v_hq_cc_unit_sid;--'1010005M';
                    
                            IF v_sum <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_hq_cc_unit_sid,--'1010005M',
                                                                 v_hq_cc_unit_sid,--'1010005M',
                                                                 v_sum,
                                                                 'OE',
                                                                 v_end_date + v_sec,
                                                                 'TP');
                            END IF;
                    
                            htp.print('<td nowrap>' || v_sum || '</td></tr>');
                            htp.print('</TABLE>');
                            end_serve_page;
                        EXCEPTION
                            WHEN a_stink THEN
                                exception_handler(TRUE);
                                end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                            WHEN OTHERS THEN
                                exception_handler;
                                end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                        END zero_all;
                    
                        PROCEDURE zero_region_unit(
                            punit        IN   VARCHAR2 := NULL,
                            pparent      IN   VARCHAR2 := NULL,
                            pstartdate   IN   DATE := NULL,
                            penddate     IN   DATE := NULL) IS
                            --  Parameters
                            vp_unit          T_OSI_UNIT.SID%TYPE;
                            vp_fiscal_year   VARCHAR2(10);
                            --  Template Processing
                    
                            --  Query Processing/General
                            v_this_unit      VARCHAR2(100);
                            v_this_parent    VARCHAR2(100);
                            v_wfaf           NUMBER;
                            v_dfotf          NUMBER;
                            v_oa             NUMBER;
                            v_oe             NUMBER;
                            v_start_date     DATE;
                            v_end_date       DATE;
                            v_unit_name      VARCHAR2(100);
                        BEGIN
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Zero_Region_Unit entered');
                            v_start_date := pstartdate;
                            v_end_date := penddate;
                            v_this_unit := punit;
                            v_this_parent := pparent;
                    
                            IF Cfunds_Test_Cfp('CF_EOY_ZERO',
                                               Core_Obj.lookup_objtype('NONE'),
                                               Core_Context.personnel_sid,
                                               punit) = 'N' THEN
                                -- OR v_Reviewing_Unit = 'N' THEN
                                v_error_detail := 'You do not have privilege to perform EOY processing.';
                                RAISE a_stink;
                            END IF;
                    
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Zero_Region_Unit doing ' || v_this_unit);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Zero_Region_Unit DATE ' || to_char(v_end_date, 'yyyy-mm-dd hh24:mi:ss'));
                            v_dfotf := Cfunds_Pkg.get_unit_dfotf(v_this_unit, v_start_date, v_end_date);
                    
                            IF v_dfotf <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_parent,
                                                                 v_dfotf,
                                                                 'DFOTF',
                                                                 v_end_date,
                                                                 'TP');
                            END IF;
                    
                            v_wfaf := Cfunds_Pkg.get_unit_wfaf(v_this_unit, v_start_date, v_end_date);
                    
                            IF v_wfaf <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_parent,
                                                                 v_wfaf,
                                                                 'WFAF',
                                                                 v_end_date,
                                                                 'TP');
                            END IF;
                    
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Zero_Region_Unit before OA ');
                            v_oa := Cfunds_Pkg.get_unit_oa(v_this_unit, v_start_date, v_end_date);
                    
                            IF v_oa <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_parent,
                                                                 v_oa,
                                                                 'OA',
                                                                 v_end_date,
                                                                 'TP');
                            END IF;
                    
                            v_oe := Cfunds_Pkg.get_unit_oe(v_this_unit, v_start_date, v_end_date);
                    
                            IF v_oe <> 0 THEN
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_parent,
                                                                 v_oe,
                                                                 'OE',
                                                                 v_end_date,
                                                                 'TP');
                            END IF;
                    
                            SELECT Osi_Unit.get_name(SID)
                              INTO v_unit_name
                              FROM T_OSI_UNIT
                             WHERE SID = v_this_unit;
                    
                            htp.print('<tr><td nowrap>' || v_unit_name || '</td>' || '<td nowrap>' || v_wfaf || '</td>'
                                      || '<td nowrap>' || v_dfotf || '</td>' || '<td nowrap>' || v_oa || '</td>'
                                      || '<td nowrap>' || v_oe || '</td></tr>');
                        EXCEPTION
                            WHEN a_stink THEN
                                exception_handler(TRUE);
                                --end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                            WHEN OTHERS THEN
                                exception_handler(TRUE);
                                --end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                        END zero_region_unit;
                    
                        PROCEDURE reinit_all(name_array IN owa.vc_arr, value_array IN owa.vc_arr) IS
                            --  Parameters
                            vp_unit           T_OSI_UNIT.SID%TYPE;
                            vp_fiscal_year    VARCHAR2(10);
                            --  Template Processing
                            v_template        CLOB;
                            v_template_date   DATE;
                            v_offset          NUMBER                := 1;
                            v_tag             VARCHAR2(100);
                            --  Query Processing/General
                            v_this_unit       VARCHAR2(100);
                            v_this_child      VARCHAR2(100);
                            v_start_date      DATE;
                            v_end_date        DATE;
                            v_today           DATE;
                            v_ok              BOOLEAN;
                            v_idx             BINARY_INTEGER        := 0;
                            v_count           BINARY_INTEGER        := 0;
                            punits_array      Cfunds_Pkg.str_arr;
                            pother_array      Cfunds_Pkg.str_arr;
                            v_seconds         NUMBER                := 70;
                            v_sec             NUMBER;
                        BEGIN
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Reinit_All entered');
                            begin_serve_page('Reinit Region/Unit', TRUE, TRUE, ' ', 'Reinit Region/Unit', 'home_page');
                            vp_unit :=
                                NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pUnit'),
                                    Cfunds_Pkg.get_my_cfunds_unit);
                            vp_fiscal_year :=
                                NVL(Web_Util_Pkg.get_flex_parameter(name_array, value_array, 'pFiscalYear'),
                                    Cfunds_Pkg.get_fiscal_year(SYSDATE));
                    
                            IF Cfunds_Test_Cfp('CF_EOY_REINIT',
                                               Core_Obj.lookup_objtype('NONE'),
                                               Core_Context.personnel_sid,
                                               vp_unit) = 'N' THEN
                                -- OR v_Reviewing_Unit = 'N' THEN
                                v_error_detail := 'You do not have privilege to perform EOY processing.';
                                htp.p('<INPUT TYPE="hidden" NAME="pFiscalYear" VALUE="' || vp_fiscal_year || '">');
                                htp.p('<INPUT TYPE="hidden" NAME="pUnit" VALUE="' || vp_unit || '">');
                                RAISE a_stink;
                            END IF;
                    
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit_All hq unit IS ' || vp_Unit);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit_All fiscal year IS ' || vp_fiscal_year);
                            Cfunds_Pkg.get_units_eoy_order(vp_unit, TRUE, punits_array, pother_array, v_count);
                            IF v_count = 0 THEN
                                Core_Logger.log_it(c_pipe, '  No units FOUND "cfunds_reinit_closing_all"');
                                htp.print('Could NOT locate units');
                                RETURN;
                            END IF;
                    
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit v_count IS ' || v_count);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (1) IS ' || pUnits_Array(1));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (2) IS ' || pUnits_Array(2));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (3) IS ' || pUnits_Array(3));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (4) IS ' || pUnits_Array(4));
                    
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (1) IS ' || pOther_Array(1));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (2) IS ' || pOther_Array(2));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (3) IS ' || pOther_Array(3));
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit (4) IS ' || pOther_Array(4));
                            v_start_date := Cfunds_Pkg.get_fiscal_year_start_date(vp_fiscal_year);
                            v_end_date := Cfunds_Pkg.get_fiscal_year_end_date(vp_fiscal_year);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit_All START DATE' || v_start_date);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit_All END DATE' || v_end_date);
                            --CORE_LOGGER.Log_It( c_pipe, 'Cfunds_Web.Reinit_All got dates' );
                            v_ok :=
                                   Web_Template_Pkg.get_latest('cfunds_reinit_closing_all', v_template, v_template_date);
                    
                            IF v_template_date IS NULL THEN
                                Core_Logger.log_it(c_pipe, '  Could NOT locate template "cfunds_reinit_closing_all"');
                                htp.print('Could NOT locate template');
                                RETURN;
                            END IF;
                    
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'SELF', Web_Util_Pkg.get_self);
                            -- remember the Fiscal Year
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR', vp_fiscal_year);
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'FISCAL_YEAR_LABEL', vp_fiscal_year);
                            v_ok := Web_Template_Pkg.replace_tag(v_template, 'UNIT', vp_unit);
                            --v_ok := WEB_TEMPLATE_PKG.Serve_Page( v_template, 'WEBTOK@', v_offset, v_tag );
                            v_ok := Web_Template_Pkg.serve_clob(v_template, 1, 10000);
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Reinit_All BEGIN processing');
                            v_sec := v_seconds / 86400;    -- use second timetags so the tranlog has everything in order
                            v_seconds := v_seconds + 1;
                            reinit_region_unit(v_hq_cc_unit_sid/*'1010005M'*/, v_hq_cc_unit_sid/*'1010005M'*/, v_start_date, v_end_date + v_sec);
                            v_idx := 1;
                    
                            LOOP
                                v_sec := v_seconds / 86400;
                                -- use second timetags so the tranlog has everything in order
                                v_seconds := v_seconds + 1;
                                v_this_unit := punits_array(v_idx);
                                v_this_child := pother_array(v_idx);
                                Core_Logger.log_it(c_pipe, 'Cfunds_Web.Reinit_All doing ' || v_this_unit);
                                reinit_region_unit(v_this_unit, v_this_child, v_start_date, v_end_date + v_sec);
                                v_idx := v_idx + 1;
                    
                                IF v_idx > v_count THEN
                                    EXIT;
                                END IF;
                            END LOOP;
                    
                            htp.print('</TABLE>');
                            end_serve_page;
                        EXCEPTION
                            WHEN a_stink THEN
                                exception_handler(TRUE);
                                end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                            WHEN OTHERS THEN
                                exception_handler;
                                end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                        END reinit_all;
                    
                        PROCEDURE reinit_region_unit(
                            punit        IN   VARCHAR2 := NULL,
                            pchild       IN   VARCHAR2 := NULL,
                            pstartdate   IN   DATE := NULL,
                            penddate     IN   DATE := NULL) IS
                            --  Parameters
                            vp_unit          T_OSI_UNIT.SID%TYPE;
                            vp_fiscal_year   VARCHAR2(10);
                            --  Template Processing
                    
                            --  Query Processing/General
                            v_this_unit      VARCHAR2(100);
                            v_this_child     VARCHAR2(100);
                            v_wfaf           NUMBER                := 0;
                            v_dfotf          NUMBER                := 0;
                            v_oa             NUMBER                := 0;
                            v_oe             NUMBER                := 0;
                            v_start_date     DATE;
                            v_end_date       DATE;
                            v_unit_name      VARCHAR2(100);
                            v_child_name     VARCHAR2(100);
                            v_count          BINARY_INTEGER;
                            v_found          BOOLEAN               := FALSE;
                            v_sign           NUMBER                := 1;
                        BEGIN
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Reinit_Region_Unit entered');
                            v_start_date := pstartdate;
                            v_end_date := penddate;
                            v_this_unit := punit;
                            v_this_child := pchild;
                    
                            IF Cfunds_Test_Cfp('CF_EOY_REINIT',
                                               Core_Obj.lookup_objtype('NONE'),
                                               Core_Context.personnel_sid,
                                               punit) = 'N' THEN
                                -- OR v_Reviewing_Unit = 'N' THEN
                                v_error_detail := 'You do not have privilege to perform EOY processing.';
                                RAISE a_stink;
                            END IF;
                    
                            Core_Logger.log_it(c_pipe, 'Cfunds_Web.Reinit_Region_Unit doing ' || v_this_unit);
                    
                            IF v_this_unit = v_hq_cc_unit_sid /*'1010005M' */ AND v_this_child = v_hq_cc_unit_sid /*'1010005M' */ THEN
                                v_sign := -1;
                            END IF;
                    
                            FOR x IN (SELECT *
                                        FROM T_CFUNDS_XFR
                                       WHERE xfr_type = 'WFAF'
                                         AND receiver = v_this_unit
                                         AND sender = v_this_child
                                         AND send_date > v_end_date - 5)
                            LOOP
                                v_wfaf := v_sign * x.amount;
                                v_found := TRUE;
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_child,
                                                                 v_wfaf,
                                                                 'WFAF',
                                                                 v_end_date + 1,
                                                                 'TP');
                                EXIT;
                            END LOOP;
                    
                            FOR x IN (SELECT *
                                        FROM T_CFUNDS_XFR
                                       WHERE xfr_type = 'DFOTF'
                                         AND receiver = v_this_unit
                                         AND sender = v_this_child
                                         AND send_date > v_end_date - 5)
                            LOOP
                                v_dfotf := v_sign * x.amount;
                                v_found := TRUE;
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_child,
                                                                 v_dfotf,
                                                                 'DFOTF',
                                                                 v_end_date + 1,
                                                                 'TP');
                                EXIT;
                            END LOOP;
                    
                            FOR x IN (SELECT *
                                        FROM T_CFUNDS_XFR
                                       WHERE xfr_type = 'OA'
                                         AND receiver = v_this_unit
                                         AND sender = v_this_child
                                         AND send_date > v_end_date - 5)
                            LOOP
                                v_oa := v_sign * x.amount;
                                v_found := TRUE;
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_child,
                                                                 v_oa,
                                                                 'OA',
                                                                 v_end_date + 1,
                                                                 'TP');
                                EXIT;
                            END LOOP;
                    
                            FOR x IN (SELECT *
                                        FROM T_CFUNDS_XFR
                                       WHERE xfr_type = 'OE'
                                         AND receiver = v_this_unit
                                         AND sender = v_this_child
                                         AND send_date > v_end_date - 5)
                            LOOP
                                v_oe := v_sign * x.amount;
                                v_found := TRUE;
                                Cfunds_Pkg.send_closing_transfer(v_this_unit,
                                                                 v_this_child,
                                                                 v_oe,
                                                                 'OE',
                                                                 v_end_date + 1,
                                                                 'TP');
                                EXIT;
                            END LOOP;
                    
                            SELECT Osi_Unit.get_name(SID)
                              INTO v_unit_name
                              FROM T_OSI_UNIT
                             WHERE SID = v_this_unit;
                    
                            SELECT Osi_Unit.get_name(SID)
                              INTO v_child_name
                              FROM T_OSI_UNIT
                             WHERE SID = v_this_child;
                    
                            IF v_found THEN
                                htp.print('<tr><td nowrap>' || v_unit_name || '</td>' || '<td nowrap>' || v_child_name
                                          || '</td>' || '<td nowrap>' || v_wfaf || '</td>' || '<td nowrap>' || v_dfotf
                                          || '</td>' || '<td nowrap>' || v_oa || '</td>' || '<td nowrap>' || v_oe
                                          || '</td></tr>');
                            END IF;
                        EXCEPTION
                            WHEN a_stink THEN
                                exception_handler(TRUE);
                                --end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                            WHEN OTHERS THEN
                                exception_handler(TRUE);
                                --end_serve_page;
                                setunitsid(vp_unit);
                                set_fiscal_year(vp_fiscal_year);
                        END reinit_region_unit;
                    END;
/