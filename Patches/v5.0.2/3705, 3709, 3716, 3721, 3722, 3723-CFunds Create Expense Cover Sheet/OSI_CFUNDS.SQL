-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_cfunds as
/******************************************************************************
   Name:     Osi_CFunds
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    24-Jun-2009 C.Hall          Created Package
    26-Jun-2009 C.Hall          Added get_tagline.
    17-Aug-2009 M.Batdorf       Added get_cfunds_mgmt_url.
    21-Oct-2009 R.Dibble        Added get_cfunds_mgmt_url_raw so it would
                                *actually* function correctly
    9-Nov-2009  J.Faris         Added can_delete.
    19-Jan-2010 T.McGuffin      Added check_writability.
    24-Jan-2011 J.Faris         Added create_instance, creates a new cfunds expense object.
    02-Mar-2011 Tim Ward        CR#3705 - Added generate_expense_cover_sheet.
    02-Mar-2011 Tim Ward        CR#3722 - Added get_default_charge_unit.
******************************************************************************/
    function validate_amount(p_amount in varchar2, p_mask varchar2)
        return varchar2;

    function get_cfunds_url(p_obj in varchar2)
        return varchar2;

    function get_tagline(p_obj in varchar2)
        return varchar2;

    function get_cfunds_mgmt_url
        return varchar2;

    function get_cfunds_mgmt_url_raw
        return varchar2;

    /*  Given a file sid as p_obj, can_delete will return a custom error message if the object
        is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2)
        return varchar2;

    /* checks whether a given cfunds expense object should be writable or not */
    function check_writability(p_obj in varchar2, p_context in varchar2)
        return varchar2;

    /* create_instance creates a new cfunds expense object  */
    function create_instance(
        p_incurred_date             IN   DATE,
        p_charge_to_unit            IN   VARCHAR2,
        p_claimant                  IN   VARCHAR2,
        p_category                  IN   VARCHAR2,
        p_paragraph                 IN   VARCHAR2,
        p_description               IN   VARCHAR2,
        p_parent                    IN   VARCHAR2,
        p_parent_info               IN   VARCHAR2,
        p_take_from_advances        IN   NUMBER,
        p_take_from_other_sources   IN   NUMBER,
        p_receipt_disposition       IN   VARCHAR2,
        p_source_amount             IN   NUMBER,
        p_agent_amount              IN   NUMBER,
        p_conversion_rate           IN   NUMBER)
        return varchar2;

    function generate_expense_cover_sheet(p_obj in varchar2) return clob;

    function get_default_charge_unit return varchar2;
    
end osi_cfunds;
/


CREATE OR REPLACE package body osi_cfunds as
/******************************************************************************
   Name:     Osi_CFunds
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    24-Jun-2009 C.Hall          Created Package
    26-Jun-2009 C.Hall          Added get_tagline.
    21-Oct-2009 R.Dibble        Added get_cfunds_mgmt_url_raw
    9-Nov-2009  J.Faris         Added can_delete.
    19-Jan-2010  T.McGuffin     Added check_writability.
    24-Jan-2011 J.Faris         Added create_instance, creates a new cfunds expense object.
    02-Mar-2011 Tim Ward        CR#3705 - Added generate_expense_cover_sheet.
    02-Mar-2011 Tim Ward        CR#3722 - Added get_default_charge_unit and call it from
                                 get_cfunds_mgmt_url and get_cfunds_mgmt_url_raw.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_CFUNDS';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function validate_amount(p_amount in varchar2, p_mask varchar2)
        return varchar2 is
        v_err_found    varchar2(10) := 'N';
        v_amount_num   number;
    begin
        begin
            v_amount_num := to_number(p_amount, p_mask);
        exception
            when value_error then
                v_err_found := 'Y';
        end;

        -- try converting without the mask
        if (v_err_found = 'Y') then
            begin
                v_amount_num := to_number(p_amount);
            exception
                when value_error then
                    return 'N';
            end;
        end if;

        if (v_amount_num > 0) then
            return 'Y';
        elsif(v_amount_num = 0) then
            return 'Y0';
        else
            return 'N';
        end if;
    exception
        when others then
            log_error('Amount conversion error: ' || p_amount || ' ~ ' || p_mask || ' ~ ' || sqlerrm);
            return 'N';
    end validate_amount;

    function get_cfunds_url(p_obj in varchar2)
        return varchar2 is
        v_url   varchar2(200);
    begin
        select 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
               || ''',name:''' || p_obj || ''',item_names:''P' || page_num
               || '_SID'',item_values:''' || p_obj || ''',request:''OPEN''})'
          into v_url
          from t_core_dt_obj_type_page
         where obj_type = core_obj.get_objtype(p_obj) and page_function = 'OPEN';

        return v_url;
    exception
        when others then
            log_error('get_cfunds_url: ' || sqlerrm);
            return('get_funds_url: Error');
    end get_cfunds_url;

    function get_default_charge_unit return varchar2 is

         myCount           number;
         myUnit            varchar2(20);

    begin
         myUnit := osi_personnel.get_current_unit;

         while myUnit is not null
         loop
     
              select count(*) into myCount from t_cfunds_unit where sid=myUnit;
          
              if myCount = 1 then
       
                return myUnit;

              end if;

              select unit_parent into myUnit from t_osi_unit where sid=myUnit;

         end loop;

         return null;

    end get_default_charge_unit;

    function get_cfunds_mgmt_url
        return varchar2 is
        v_ticket   varchar2(200);
    begin
        --ticket_pkg.get_ticket_for_vb(core_context.personnel_sid, v_ticket);
        ticket_pkg.get_ticket(core_context.personnel_sid, v_ticket);
        return core_util.get_config('CFUNDS_URL') || '?punit=' || nvl(get_default_charge_unit,osi_personnel.get_current_unit)
               || '&' || core_util.get_config('TICKET_PARAM_NAME') || '=' || v_ticket || '"'
               || ' target=' || chr(39) || '_blank' || chr(39);
    end get_cfunds_mgmt_url;

    function get_cfunds_mgmt_url_raw
        return varchar2 is
        v_ticket   varchar2(200);
    begin
        return core_util.get_config('CFUNDS_URL') || '?punit=' || nvl(get_default_charge_unit,osi_personnel.get_current_unit);
    end get_cfunds_mgmt_url_raw;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_claimant   varchar2(120);
    begin
        select osi_personnel.get_name(claimant)
          into v_claimant
          from v_cfunds_expense_v3
         where SID = p_obj;

        return 'C-Funds Expense for ' || v_claimant;
    exception
        when others then
            log_error('get_tagline error: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function can_delete(p_obj in varchar2)
        return varchar2 is
        v_stat       varchar2(20);
        v_claimant   varchar2(200);
    begin
        -- if status in new, submitted, approved, or disallowed AND not paid, ok to delete
        begin
            select 'Y'
              into v_stat
              from t_cfunds_expense_v3
             where osi_object.get_status(p_obj) in('NEW', 'SUBMITTED', 'APPROVED', 'DISALLOWED')
               and paid_on is null;
        exception
            when no_data_found then
                return 'The Expense has already been paid to the agent, therefore it cannot be deleted.';
        end;

        -- Check if this is the claimant of the expense OR has the proxy privilege.
        begin
            select 'Y'
              into v_claimant
              from t_cfunds_expense_v3
             where SID = p_obj and claimant = core_context.personnel_sid;
        --TBD: potential check for "Proxy" Privilege
        exception
            when no_data_found then
                return 'You can only delete your own expense.';
        end;

        return 'Y';
    exception
        when others then
            log_error('OSI_CFUNDS.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL')
                      || ':' || sqlerrm);
            return 'Untrapped error in OSI_CFUNDS.Can_Delete using Object: ' || nvl(p_obj, 'NULL');
    end can_delete;

    function check_writability(p_obj in varchar2, p_context in varchar2)
        return varchar2 is
        v_claimant          t_core_personnel.SID%type;
        v_obj_type          t_core_obj_type.SID%type;
        v_status            varchar2(50);
        v_parent_writable   varchar2(1);
    begin
        select claimant,
               cfunds_pkg.get_expense_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             paid_on,
                                             invalidated_on,
                                             repaid_on,
                                             reviewing_unit,
                                             closed_on),
               core_obj.lookup_objtype('CFUNDS_EXP'), osi_object.check_writability(parent, null)
          into v_claimant,
               v_status,
               v_obj_type, v_parent_writable
          from t_cfunds_expense_v3
         where SID = p_obj;

        if v_parent_writable = 'Y' then
            if (    (   v_claimant = core_context.personnel_sid
                     or osi_auth.check_for_priv('EXP_CRE_PROXY', v_obj_type) = 'Y')
                and v_status in('New', 'Disallowed', 'Rejected')) then
                return 'Y';
            elsif     osi_auth.check_for_priv('APPROVE_CL', v_obj_type) = 'Y'
                  and v_status in('Submitted', 'Disallowed') then
                return 'Y';
            end if;
        end if;

        return 'N';
    exception
        when no_data_found then
            return 'N';
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

    function create_instance(
        p_incurred_date             IN   DATE,
        p_charge_to_unit            IN   VARCHAR2,
        p_claimant                  IN   VARCHAR2,
        p_category                  IN   VARCHAR2,
        p_paragraph                 IN   VARCHAR2,
        p_description               IN   VARCHAR2,
        p_parent                    IN   VARCHAR2,
        p_parent_info               IN   VARCHAR2,
        p_take_from_advances        IN   NUMBER,
        p_take_from_other_sources   IN   NUMBER,
        p_receipt_disposition       IN   VARCHAR2,
        p_source_amount             IN   NUMBER,
        p_agent_amount              IN   NUMBER,
        p_conversion_rate           IN   NUMBER)
        return VARCHAR2 IS
        v_sid        T_CORE_OBJ.SID%TYPE;
        v_obj_type   VARCHAR2(20);
    begin
        v_obj_type := core_obj.lookup_objtype('CFUNDS_EXP');

        insert into t_core_obj
                    (obj_type)
             values (v_obj_type)
          returning SID
               into v_sid;

        insert into t_cfunds_expense_v3
                    (SID,
                     incurred_date,
                     charge_to_unit,
                     claimant,
                     category,
                     paragraph,
                     description,
                     parent,
                     parent_info,
                     take_from_advances,
                     take_from_other_sources,
                     receipts_disposition,
                     source_amount,
                     agent_amount,
                     conversion_rate)
             values (v_sid,
                     p_incurred_date,
                     p_charge_to_unit,
                     p_claimant,
                     p_category,
                     p_paragraph,
                     p_description,
                     p_parent,
                     p_parent_info,
                     p_take_from_advances,
                     p_take_from_other_sources,
                     p_receipt_disposition,
                     p_source_amount,
                     p_agent_amount,
                     p_conversion_rate);

        Core_Obj.bump(v_sid);
        return v_sid;
    exception
        when OTHERS then
            log_error('Error creating CFunds Expense. Error is: ' || SQLERRM);
            RAISE;
    end create_instance;

    function generate_expense_cover_sheet(p_obj in varchar2) return clob is

        v_agent             varchar2(4000);
        v_paragraph         varchar2(4000);
        v_category          varchar2(4000);
        v_date_incurred     date;
        v_expense_id        varchar2(30);
        v_charge_to_unit    varchar2(20);
        v_context           varchar2(4000);
        v_source_id         varchar2(19);
        v_source_amount     number;
        v_agent_amount      number;
        v_total_amount      number;
        v_conversion_rate   number;
        v_total_amount_us   number;
        v_description       varchar2(4000);
        v_paragraph_number  varchar2(4000);
        v_paragraph_content varchar2(4000);
        v_parent            varchar2(20);
        v_return            clob := null;
        v_fmt_cf_currency   varchar2(4000) := core_util.get_config('CFUNDS.CURRENCY');
        v_date_fmt_day      varchar2(4000) := core_util.get_config('CORE.DATE_FMT_DAY');
        v_CRLF              varchar2(4) := CHR(13) || CHR(10);

    begin

        select claimant_name,
               paragraph_number || ' - ' || paragraph_content,
               category_desc, incurred_date, voucher_no, charge_to_unit,
               parent_info, decode(source_id,null,'N/A','','N/A',source_id), source_amount,
               agent_amount, total_amount, conversion_rate,
               total_amount_us, description,
               paragraph_number,
               paragraph_content,
               parent
          into v_agent,
               v_paragraph,
               v_category, v_date_incurred, v_expense_id, v_charge_to_unit,
               v_context, v_source_id, v_source_amount,
               v_agent_amount, v_total_amount, v_conversion_rate,
               v_total_amount_us, v_description,
               v_paragraph_number,
               v_paragraph_content,
               v_parent
          from v_cfunds_expense_v3
         where sid = p_obj;


        v_return :=
            '***************************************************************' || v_CRLF
            || 'CFunds Expense Cover Sheet, printed on '
            || to_char(systimestamp, v_date_fmt_day || ' HH12:MI:SS AM') || v_CRLF
            || '***************************************************************'
            || v_CRLF || v_CRLF || 'Agent Name                 :  ' || v_agent
            || v_CRLF || v_CRLF || 'Incurred Date              :  '
            || to_char(v_date_incurred, v_date_fmt_day) || v_CRLF || v_CRLF
            || 'Expense ID                 :  ' || v_expense_id || v_CRLF
            || v_CRLF || v_CRLF || 'Unit Charged with Expense  :  '
            || osi_unit.get_name(v_charge_to_unit) || v_CRLF || v_CRLF
            || 'Paragraph                  :  ' || v_paragraph_number || ' - ' || osi_util.wordwrapfunc(v_paragraph_content, 40 - Length(v_paragraph_number) -3, v_CRLF || '                              ' || lpad(' ', Length(v_paragraph_number) + 3, ' ')) || v_CRLF || v_CRLF
            || v_CRLF || 'Category                   :  ' || v_category || v_CRLF
            || v_CRLF || 'Context                    :  ' || 'Activity: ' || osi_activity.get_id(v_parent) || ' - ' || core_obj.get_tagline(v_parent) || v_CRLF
            || v_CRLF || v_CRLF || 'Source Number              :  ' || v_source_id
            || v_CRLF || v_CRLF || 'Source Amount              :  '
            || ltrim(to_char(v_source_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || 'Agent Amount               :  '
            || ltrim(to_char(v_agent_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || '                              __________' || v_CRLF
            || 'Amount Spent               :  '
            || ltrim(to_char(v_total_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || 'Conversion Rate            :  ' || v_conversion_rate
            || v_CRLF || v_CRLF || '                              __________'
            || v_CRLF || 'Expense Amount (US Dollars):  '
            || to_char(v_total_amount_us, v_fmt_cf_currency) || v_CRLF || v_CRLF
            || v_CRLF || 'Details                    :  ' || v_description;
            
            return v_return;

    end generate_expense_cover_sheet;
        
end osi_cfunds;
/