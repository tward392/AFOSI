CREATE OR REPLACE VIEW V_OSI_F_STATUS_HISTORY_LAST
(SID, FYLE, STATUS, ON_DATE, EFFECTIVE_DATE, 
 PERSONNEL, STATUS_DESC, PERSONNEL_SSN, PERSONNEL_NAME)
AS 
select sh.sid, 
       sh.obj as fyle, 
       sh.status, 
       sh.create_on as on_date,
       sh.effective_on as effective_date,
       'unknown' as personnel,
       s.description as STATUS_DESC,
       'unknown' as PERSONNEL_SSN,
       sh.create_by as PERSONNEL_NAME
from T_OSI_STATUS_HISTORY sh,
     T_OSI_STATUS s,
     v_osi_f_status_history_last_dt vfshldt
where vfshldt.fyle=sh.obj
  and vfshldt.last_datetime=sh.create_on 
  and s.sid=sh.status 
  ---and s.obj_type = sh.obj_type
/