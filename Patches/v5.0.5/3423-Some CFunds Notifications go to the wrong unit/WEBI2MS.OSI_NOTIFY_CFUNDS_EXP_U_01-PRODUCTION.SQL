CREATE OR REPLACE TRIGGER WEBI2MS."OSI_NOTIFY_CFUNDS_EXP_U_01" 
BEFORE UPDATE
OF SUBMITTED_ON,APPROVED_BY,APPROVED_ON,REJECTED_BY,REJECTED_ON,REJECTION_COMMENT,PAID_ON
ON T_CFUNDS_EXPENSE_V3 REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare

  v_specifics  Varchar2(4000);
  v_PerSID     Varchar2(20);
  v_ParentUnit Varchar2(20);
  v_FiscalYearBegin Date;
  v_FiscalYearEnd Date;
  v_Activity Varchar2(100);
  
begin
  
  Begin  
  select ID into v_Activity 
    from T_OSI_ACTIVITY 
   where SID=:new.PARENT;

  exception
           when NO_DATA_FOUND then
     v_Activity := 'Unknown';
  end;
  
  --- check that the Submitted on Date is being Updated (i.e. expense is being submitted for approval) --- 
  if (:old.SUBMITTED_ON != :new.SUBMITTED_ON) or (:old.SUBMITTED_ON IS NULL and :new.SUBMITTED_ON IS NOT NULL) then

    core_logger.log_it('NOTIFICATION','CFund Expense Submitted Notification - ' || :new.SID);

    v_PerSID := core_context.Personnel_SID;

    select UNIT_PARENT 
       into V_ParentUnit 
       from T_OSI_UNIT 
      where SID=:new.CHARGE_TO_UNIT;

    if v_ParentUNIT is null then

       core_logger.log_it('NOTIFICATION','WARNING: No Parent Unit Found for UNIT=' || :new.CHARGE_TO_UNIT );

    else

      v_specifics := substr('Expense Submitted for Approval By: ' || CORE_CONTEXT.Personnel_Name
                  || ', Submitted On: ' || :new.SUBMITTED_ON
                  || ', Source Amount: $' || NVL(:new.SOURCE_AMOUNT,0) || '/Agent_Amount: $' || NVL(:new.AGENT_AMOUNT,0)
                  || ', Justification/Details/Explanation: ' || :new.DESCRIPTION
                  || '<BR>***** Expense must be approved and paid withing 10 calendar days *****',1,4000);
      
      OSI_NOTIFICATION.Record_Detection('CF.EXP.SUBMIT',:new.SID,'CFunds Expense Submitted for Approval:  ' || v_Activity || ', ' || :new.VOUCHER_NO || ', ' || to_char(:new.INCURRED_DATE,'DD-Mon-YYYY'),:new.MODIFY_BY,:new.MODIFY_ON, v_ParentUNIT, v_specifics);
  
    end if;

  end if;

  --- check that the Rejected on Date is being Updated (i.e. expense is being Disallowed) --- 
  if (:old.REJECTED_ON != :new.REJECTED_ON) or (:old.REJECTED_ON IS NULL and :new.REJECTED_ON IS NOT NULL) then

     core_logger.log_it('NOTIFICATION','CFund Expense Rejected Notification - ' || :new.SID);

    v_PerSID := CORE_CONTEXT.Personnel_SID;

    select UNIT_PARENT into V_ParentUnit from T_OSI_UNIT where SID=:new.CHARGE_TO_UNIT;

    if v_ParentUNIT is null then

       core_logger.log_it('NOTIFICATION','WARNING: No Parent Unit Found for UNIT=' || :new.CHARGE_TO_UNIT );

    else

      v_specifics := 'Expense Rejected By: ' || CORE_CONTEXT.Personnel_Name
                  || ', Rejected On: ' || :new.REJECTED_ON
                  || ', Source Amount: $' || NVL(:new.SOURCE_AMOUNT,0) || '/Agent_Amount: $' || NVL(:new.AGENT_AMOUNT,0)
                  || ', Rejection Comments: ' || :new.REJECTION_COMMENT
                  || '<BR>***** Reject must be cleared within 5 Days *****';

      OSI_NOTIFICATION.Record_Detection('CF.EXP.REJECT',:new.SID,'CFunds Expense Rejected:  ' || v_Activity || ', ' || :new.VOUCHER_NO || ', ' || to_char(:new.INCURRED_DATE,'DD-Mon-YYYY'),:new.MODIFY_BY,:new.MODIFY_ON, v_ParentUNIT, v_specifics);
  
    end if;

  end if;

  --- check that the Approved on Date is being Updated (i.e. expense is being Approved) --- 
 if (:old.APPROVED_ON != :new.APPROVED_ON) or (:old.APPROVED_ON IS NULL and :new.APPROVED_ON IS NOT NULL) then

     core_logger.log_it('NOTIFICATION','CFund Expense Approval Notification - ' || :new.SID);

    v_PerSID := CORE_CONTEXT.Personnel_SID;

    select UNIT_PARENT into V_ParentUnit from T_OSI_UNIT where SID=:new.CHARGE_TO_UNIT;

    if v_ParentUNIT is null then

       core_logger.log_it('NOTIFICATION', 'WARNING: No Parent Unit Found for UNIT=' || :new.CHARGE_TO_UNIT );

    else

      v_specifics := 'Expense Approved By: ' || CORE_CONTEXT.Personnel_Name
                  || ', Approved On: ' || :new.APPROVED_ON
                  || ', Source Amount: $' || NVL(:new.SOURCE_AMOUNT,0) || '/Agent_Amount: $' || NVL(:new.AGENT_AMOUNT,0);

      OSI_NOTIFICATION.Record_Detection('CF.EXP.APP',:new.SID,'CFunds Expense Approved:  ' || v_Activity || ', ' || :new.VOUCHER_NO || ', ' || to_char(:new.INCURRED_DATE,'DD-Mon-YYYY'),:new.MODIFY_BY,:new.MODIFY_ON, v_ParentUNIT, v_specifics);
  
    end if;

  end if;


  --- Check for Previous Fiscal Year's Expenses ---
   core_logger.log_it('NOTIFICATION',:new.submitted_on || ',' || :old.submitted_on  || '---' ||  :new.paid_on  || ',' ||  :old.paid_on  || '---' ||  :new.approved_on  || ',' ||  :old.approved_on);
  if (:new.submitted_on != :old.submitted_on or (:new.submitted_on is not null and :old.submitted_on is null)) or (:new.paid_on != :old.paid_on or (:new.paid_on is not null and :old.paid_on is null)) or (:new.approved_on != :old.approved_on or (:new.approved_on is not null and :old.approved_on is null)) then
    
    if sysdate < to_date('10/01/' || to_char(sysdate,'YYYY'),'MM/DD/YYYY') then   
   
      select to_date('10/01/' || to_char(sysdate-365,'YYYY'),'MM/DD/YYYY') into v_FiscalYearBegin from dual;
      select to_date('09/30/' || to_char(sysdate,'YYYY'),'MM/DD/YYYY') into v_FiscalYearEnd from dual;
 
    else

      select to_date('10/01/' || to_char(sysdate,'YYYY'),'MM/DD/YYYY') into v_FiscalYearBegin from dual;
      select to_date('09/30/' || to_char(sysdate+365,'YYYY'),'MM/DD/YYYY') into v_FiscalYearEnd from dual;
 
    end if;
  
     core_logger.log_it('NOTIFICATION','Fiscal Year Start:  ' || v_FiscalYearBegin || ', Fiscal Year End:  ' || v_FiscalYearEnd);
    if :new.incurred_date < v_FiscalYearBegin then
      
      if :new.submitted_on != :old.submitted_on  or (:new.submitted_on is not null and :old.submitted_on is null) then
      
     v_specifics := 'Expenses Submitted for a previous Fiscal Year requires prior approval from HQ C-Funds Custodian.';
   
   end if;
      if :new.paid_on != :old.paid_on or (:new.paid_on is not null and :old.paid_on is null) then
      
     v_specifics := 'Expenses Paid for a previous Fiscal Year requires prior approval from HQ C-Funds Custodian.';
   
   end if;
      if :new.approved_on != :old.approved_on or (:new.approved_on is not null and :old.approved_on is null) then
      
     v_specifics := 'Expenses Approved for a previous Fiscal Year requires prior approval from HQ C-Funds Custodian.';
   
   end if;
   
       core_logger.log_it('NOTIFICATION','v_specifics:  ' || v_specifics);
      OSI_NOTIFICATION.Record_Detection('CF.EXP.PREV.FY',:new.SID,'CFunds Expense Previous FY Approved:  ' || v_Activity || ', ' || :new.VOUCHER_NO || ', ' || to_char(:new.INCURRED_DATE,'DD-Mon-YYYY'),:new.MODIFY_BY,:new.MODIFY_ON, :new.CHARGE_TO_UNIT, v_specifics);
  
    end if;
 
  end if;
  
end;
/