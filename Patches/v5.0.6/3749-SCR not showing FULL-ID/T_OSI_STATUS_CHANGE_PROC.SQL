ALTER TABLE T_OSI_STATUS_CHANGE_PROC ADD SEQ NUMBER;

---- Set all Singles to One ----
update t_osi_status_change_proc set seq=1 
  where status_change_sid in (select status_change_sid 
                                from t_osi_status_change_proc group by status_change_sid having count(*)<=1);
commit;                                

---- Set multiples to the correct Sequences ----
update t_osi_status_change_proc set seq=1 where proc_to_use='OSI_STATUS_PROC.COPY_SPECIAL_INTEREST';
update t_osi_status_change_proc set seq=2 where proc_to_use='OSI_STATUS_PROC.COPY_MISSION_AREA';
update t_osi_status_change_proc set seq=3 where proc_to_use='OSI_STATUS_PROC.AUTOFILL_SUMMARY_INV';
update t_osi_status_change_proc set seq=4 where proc_to_use='OSI_STATUS_PROC.SET_FILE_FULL_ID';
update t_osi_status_change_proc set seq=5 where proc_to_use='OSI_STATUS_PROC.CASE_CLEAR_NEGATIVE_INDEXES';
update t_osi_status_change_proc set seq=6 where proc_to_use='OSI_STATUS_PROC.CREATE_SUM_COMPLAINT_RPT';
commit;

update t_osi_status_change_proc set seq=1 where proc_to_use='OSI_STATUS_PROC.ACT_CLEAR_COMPLETE_DATE' and status_change_sid='222000005J4';
update t_osi_status_change_proc set seq=2 where proc_to_use='OSI_STATUS_PROC.ACT_CLEAR_CLOSE_DATE' and status_change_sid='222000005J4';
update t_osi_status_change_proc set seq=3 where proc_to_use='OSI_STATUS_PROC.REOPEN_OBJECT' and status_change_sid='222000005J4';
commit;

update t_osi_status_change_proc set seq=1 where proc_to_use='OSI_STATUS_PROC.UNMARK_CLOSED_SHORT_FILE' and seq is null;
update t_osi_status_change_proc set seq=2 where proc_to_use='OSI_STATUS_PROC.REOPEN_OBJECT' and seq is null;
commit;

update t_osi_status_change_proc set seq=1 where proc_to_use='OSI_STATUS_PROC.CHECK_FOR_OLD_PARTIC_LINKS' and seq is null;
update t_osi_status_change_proc set seq=2 where proc_to_use='OSI_STATUS_PROC.DEERS_UPDATE_LINKS' and seq is null;
commit;

update t_osi_status_change_proc set seq=1 where proc_to_use='OSI_STATUS_PROC.AAPP_CAN_RECALL' and seq is null;
update t_osi_status_change_proc set seq=2 where proc_to_use='OSI_STATUS_PROC.RECALL_AAPP_FILE' and seq is null;
commit;


update t_osi_status_change_proc set seq=1 where proc_to_use LIKE 'OSI_STATUS_PROC.PMM_USER_CAN%' and seq is null;
update t_osi_status_change_proc set seq=2 where proc_to_use LIKE 'OSI_STATUS_PROC.PMM_CHECK%' and seq is null;
update t_osi_status_change_proc set seq=3 where proc_to_use LIKE 'OSI_STATUS_PROC.PMM_%' and seq is null;
commit;

update t_osi_status_change_proc set seq=1 where seq is null;
commit;





