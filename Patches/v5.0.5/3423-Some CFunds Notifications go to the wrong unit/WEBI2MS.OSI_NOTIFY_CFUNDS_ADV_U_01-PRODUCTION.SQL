CREATE OR REPLACE TRIGGER WEBI2MS."OSI_NOTIFY_CFUNDS_ADV_U_01" 
BEFORE UPDATE
OF SUBMITTED_ON
  ,APPROVED_BY
  ,APPROVED_ON
  ,REJECTED_BY
  ,REJECTED_ON
ON T_CFUNDS_ADVANCE_V2
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare

  v_specifics  Varchar2(4000);
  v_PerSID     Varchar2(20);
  v_ParentUnit Varchar2(20);

begin

  --- check that the Submitted on Date is being Updated (i.e. expense is being submitted for approval) --- 
  if (:old.SUBMITTED_ON != :new.SUBMITTED_ON) or (:old.SUBMITTED_ON IS NULL and :new.SUBMITTED_ON IS NOT NULL) then

    core_logger.log_it('NOTIFICATION','CFund Advance Submitted Notification - ' || :new.SID);

    v_PerSID := CORE_CONTEXT.Personnel_SID;

    select UNIT_PARENT into V_ParentUnit from T_OSI_UNIT where SID=:new.UNIT;

    if v_ParentUNIT is null then

      core_logger.log_it('NOTIFICATION','WARNING: No Parent Unit Found for UNIT=' || :new.UNIT );

    else

      v_specifics := 'Advance Submitted for Approval By: ' || CORE_CONTEXT.Personnel_Name
                  || ', Submitted On: ' || :new.SUBMITTED_ON
                  || ', Amount: $' || NVL(:new.AMOUNT_REQUESTED,0)
                  || ', Purpose: ' || :new.NARRATIVE;

      OSI_NOTIFICATION.Record_Detection('CF.ADV.SUBMIT',:new.SID,'Advance Submitted for Approval: ' || :new.NARRATIVE,:new.MODIFY_BY,:new.MODIFY_ON, v_ParentUNIT, v_specifics);
  
    end if;

  end if;

  --- check that the Rejected on Date is being Updated (i.e. expense is being rejected) --- 
  if (:old.REJECTED_ON != :new.REJECTED_ON) or (:old.REJECTED_ON IS NULL and :new.REJECTED_ON IS NOT NULL) then

    core_logger.log_it('NOTIFICATION','CFund Advance Rejected Notification - ' || :new.SID);

    v_PerSID := CORE_CONTEXT.Personnel_SID;

    select UNIT_PARENT into V_ParentUnit from T_OSI_UNIT where SID=:new.UNIT;

    if v_ParentUNIT is null then

      core_logger.log_it('NOTIFICATION','WARNING: No Parent Unit Found for UNIT=' || :new.UNIT );

    else

      v_specifics := 'Advance Rejected By: ' || :new.REJECTED_BY
                  || ', Rejected On: ' || :new.REJECTED_ON
                  || ', Amount: $' || NVL(:new.AMOUNT_REQUESTED,0)
                  || ', Purpose: ' || :new.NARRATIVE;

      OSI_NOTIFICATION.Record_Detection('CF.ADV.REJECT',:new.SID,'Advance Rejected: ' || :new.NARRATIVE,:new.MODIFY_BY,:new.MODIFY_ON, v_ParentUNIT, v_specifics);
  
    end if;

  end if;
  
  --- check that the Approved on Date is being Updated (i.e. expense is being Approved) --- 
  if (:old.APPROVED_ON != :new.APPROVED_ON) or (:old.APPROVED_ON IS NULL and :new.APPROVED_ON IS NOT NULL) then

    core_logger.log_it('NOTIFICATION','CFund Advance Approved Notification - ' || :new.SID);

    v_PerSID := CORE_CONTEXT.Personnel_SID;

    select UNIT_PARENT into V_ParentUnit from T_OSI_UNIT where SID=:new.UNIT;

    if v_ParentUNIT is null then

      core_logger.log_it('NOTIFICATION','WARNING: No Parent Unit Found for UNIT=' || :new.UNIT );

    else

      v_specifics := 'Advance Approved By: ' || :new.APPROVED_BY
                  || ', Approved On: ' || :new.APPROVED_ON
                  || ', Amount: $' || NVL(:new.AMOUNT_REQUESTED,0)
                  || ', Purpose: ' || :new.NARRATIVE;

      OSI_NOTIFICATION.Record_Detection('CF.ADV.APP',:new.SID,'Advance Approved: ' || :new.NARRATIVE,:new.MODIFY_BY,:new.MODIFY_ON, v_ParentUNIT, v_specifics);
  
    end if;

  end if;

end;
/