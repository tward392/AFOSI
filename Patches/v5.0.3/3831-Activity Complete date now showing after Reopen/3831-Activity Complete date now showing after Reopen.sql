--- Turn off the Clearing of the Complete Date when Reopened ---
UPDATE T_OSI_STATUS_CHANGE_PROC SET ACTIVE='N' WHERE PROC_TO_USE='OSI_STATUS_PROC.ACT_CLEAR_COMPLETE_DATE';
COMMIT;


--- Fix Completed Dates for Existing Re-Opened ones ---
--SELECT * FROM T_OSI_STATUS_HISTORY WHERE TRANSITION_COMMENT='Reopen' AND OBJ IN (SELECT SID FROM T_OSI_ACTIVITY where complete_date is null);
--select * from t_osi_status_history where obj='7770A5XB';

declare
  
  v_date date;
  
BEGIN
 FOR I IN (SELECT * FROM T_OSI_STATUS_HISTORY WHERE TRANSITION_COMMENT='Reopen' AND OBJ IN (SELECT SID FROM T_OSI_ACTIVITY where complete_date is null))
 LOOP
     select max(effective_on) into v_date from t_osi_status_history where transition_comment='Complete Activity' and obj=i.obj;
     update t_osi_activity set complete_date=v_date where sid=i.obj;
     commit;
          
     dbms_output.put_line('obj=' || i.obj || ', completed on=' || v_date);
     
 END LOOP;
END;