CREATE OR REPLACE VIEW V_CFUNDS_EXPENSE_V3
(SID, VOUCHER_NO, CLAIMANT, INCURRED_DATE, PARENT, 
 PARENT_INFO, DESCRIPTION, CHARGE_TO_UNIT, REVIEWING_UNIT, CATEGORY, 
 PARAGRAPH, SOURCE_AMOUNT, AGENT_AMOUNT, CONVERSION_RATE, TAKE_FROM_ADVANCES, 
 TAKE_FROM_OTHER_SOURCES, RECEIPTS_DISPOSITION, RECEIPTS_FWD_TO, SUBMITTED_ON, APPROVED_BY, 
 APPROVED_ON, REJECTED_BY, REJECTED_ON, REJECTION_COMMENT, PAID_BY, 
 PAID_ON, PAID_CASH_AMOUNT, PAID_CHECK_AMOUNT, PAID_CHECK_NUMBER, ADVANCE_AMOUNT, 
 CLEARED, INVALIDATED_BY, INVALIDATED_ON, INVALIDATION_COMMENT, REPAID_ON, 
 REPAID_VOUCHER_NO, REPAID_CASH_AMOUNT, REPAID_CHECK_AMOUNT, REPAID_CHECK_NUMBER, REPAID_ADVANCE, 
 REPAID_CLEARED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, 
 REVIEWED, REVIEW_HISTORY, CLOSED_BY, CLOSED_ON, TFOS_BY, 
 TFOS_ON, TFOS_CASH_AMOUNT, TFOS_CHECK_AMOUNT, TFOS_CHECK_NUMBER, CLAIMANT_NAME, 
 CLAIMANT_SSN, CHARGE_TO_UNIT_CODE, CHARGE_TO_UNIT_NAME, REVIEWING_UNIT_CODE, REVIEWING_UNIT_NAME, 
 CATEGORY_DESC, PEC, PARAGRAPH_CONTENT, RECEIPTS_FWD_TO_NAME, RECEIPT_DISPOSITION_DESC, 
 SOURCE_ID, TOTAL_AMOUNT, AGENT_AMOUNT_US, SOURCE_AMOUNT_US, TOTAL_AMOUNT_US, 
 STATUS, PARAGRAPH_NUMBER, SOURCESID)
AS 
select cfe.sid, cfe.voucher_no, cfe.claimant, cfe.incurred_date, cfe.parent, cfe.parent_info,
           cfe.description, cfe.charge_to_unit, cfe.reviewing_unit, cfe.category, cfe.paragraph,
           cfe.source_amount, cfe.agent_amount, cfe.conversion_rate, cfe.take_from_advances,
           cfe.take_from_other_sources, cfe.receipts_disposition, cfe.receipts_fwd_to,
           cfe.submitted_on, cfe.approved_by, cfe.approved_on, cfe.rejected_by, cfe.rejected_on,
           cfe.rejection_comment, cfe.paid_by, cfe.paid_on, cfe.paid_cash_amount,
           cfe.paid_check_amount, cfe.paid_check_number, cfe.advance_amount, cfe.cleared,
           cfe.invalidated_by, cfe.invalidated_on, cfe.invalidation_comment, cfe.repaid_on,
           cfe.repaid_voucher_no, cfe.repaid_cash_amount, cfe.repaid_check_amount,
           cfe.repaid_check_number, cfe.repaid_advance, cfe.repaid_cleared, cfe.create_by,
           cfe.create_on, cfe.modify_by, cfe.modify_on, cfe.reviewed, cfe.review_history,
           cfe.closed_by, cfe.closed_on, cfe.tfos_by, cfe.tfos_on, cfe.tfos_cash_amount,
           cfe.tfos_check_amount, cfe.tfos_check_number,
           cp.last_name || ', ' || cp.first_name || ' ' || cp.middle_name as claimant_name,
           p.ssn as claimant_ssn, u.unit_code as charge_to_unit_code,
           osi_unit.get_name(u.sid) as charge_to_unit_name, u2.unit_code as reviewing_unit_code,
           osi_unit.get_name(u2.sid) as reviewing_unit_name, cfc.description as category_desc,
           cfc.program_expense_code as pec, cfp.content as paragraph_content,
           cp2.last_name || ', ' || cp2.first_name || ' '
           || cp2.middle_name as receipts_fwd_to_name,
           cfrd.description as receipt_disposition_desc, s.id as source_id,
           nvl(cfe.agent_amount, 0) + nvl(cfe.source_amount, 0) as total_amount,
           round(cfe.agent_amount / nvl(cfe.conversion_rate, 1), 2) as agent_amount_us,
           round(cfe.source_amount / nvl(cfe.conversion_rate, 1), 2) as source_amount_us,
           round((nvl(cfe.agent_amount, 0) + nvl(cfe.source_amount, 0))
                 / nvl(cfe.conversion_rate, 1),
                 2) as total_amount_us,
           cfunds_pkg.get_expense_status(cfe.submitted_on,
                                         cfe.approved_on,
                                         cfe.rejected_on,
                                         cfe.paid_on,
                                         cfe.invalidated_on,
                                         cfe.repaid_on,
                                         cfe.reviewing_unit,
                                         cfe.closed_on) as status,
           cfp.paragraph_number as paragraph_number, s.sid as sourcesid
      from t_cfunds_expense_v3 cfe,
           t_osi_personnel p,
           t_osi_personnel p2,
           t_core_personnel cp,
           t_core_personnel cp2,
           t_osi_unit u,
           t_osi_unit u2,
           t_cfunds_categories cfc,
           t_cfunds_paragraphs cfp,
           t_cfunds_receipt_disposition cfrd,
           t_osi_activity a,
           t_osi_file s
     where p.sid = cfe.claimant
       and cp.sid = cfe.claimant
       and p2.sid(+) = cfe.receipts_fwd_to
       and cp2.sid(+) = cfe.receipts_fwd_to
       and u.sid = cfe.charge_to_unit
       and u2.sid(+) = cfe.reviewing_unit
       and cfc.code = cfe.category
       and cfp.paragraph(+) = cfe.paragraph
       and cfrd.code(+) = cfe.receipts_disposition
       and a.sid(+) = cfe.parent
       and s.sid(+) = a.source
/


CREATE OR REPLACE TRIGGER "OSI_CFUNDS_EXP_IO_U_01" 
    instead of delete or insert or update
    on v_cfunds_expense_v3
    referencing new as new old as old
    for each row
declare
    v_sid           varchar2(20);
    v_obj_type      varchar2(20);
    v_approved_by   varchar2(100) := :new.approved_by;
    v_rejected_by   varchar2(100) := :new.rejected_by;
begin
    if inserting then
        v_obj_type := core_obj.lookup_objtype('CFUNDS_EXP');

        insert into t_core_obj
                    (obj_type)
             values (v_obj_type)
          returning sid
               into v_sid;

        insert into t_cfunds_expense_v3
                    (sid,
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
                     :new.incurred_date,
                     :new.charge_to_unit,
                     :new.claimant,
                     :new.category,
                     :new.paragraph,
                     :new.description,
                     :new.parent,
                     :new.parent_info,
                     :new.take_from_advances,
                     :new.take_from_other_sources,
                     :new.receipts_disposition,
                     :new.source_amount,
                     :new.agent_amount,
                     :new.conversion_rate);

        core_obj.bump(v_sid);
    elsif updating then
        if (:old.approved_on is null and :new.approved_on is not null) then
            v_approved_by := substr(core_context.personnel_name, 1, 100);
        end if;

        if (:old.rejected_on is null and :new.rejected_on is not null) then
            v_rejected_by := substr(core_context.personnel_name, 1, 100);
        end if;

        update t_cfunds_expense_v3
           set incurred_date = :new.incurred_date,
               charge_to_unit = :new.charge_to_unit,
               paragraph = :new.paragraph,
               claimant = :new.claimant,
               category = :new.category,
               description = :new.description,
               source_amount = :new.source_amount,
               agent_amount = :new.agent_amount,
               conversion_rate = :new.conversion_rate,
               take_from_advances = :new.take_from_advances,
               receipts_disposition = :new.receipts_disposition,
               submitted_on = :new.submitted_on,
               approved_on = :new.approved_on,
               approved_by = v_approved_by,
               rejected_on = :new.rejected_on,
               rejected_by = v_rejected_by,
               rejection_comment = :new.rejection_comment
         where sid = :new.sid;

        core_obj.bump(:new.sid);
    end if;
exception
    when others then
        -- Consider logging the error and then re-raise
        raise;
end;
/