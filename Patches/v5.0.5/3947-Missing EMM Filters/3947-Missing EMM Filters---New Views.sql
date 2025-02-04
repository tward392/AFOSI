CREATE OR REPLACE VIEW V_OSI_FILE_RELATION_1
(THIS_FILE, THAT_FILE, MODIFY_BY, MODIFY_ON)
AS 
select
  file_a as this_file,
  file_b as that_file,
  modify_by,
  modify_on
from
  T_OSI_ASSOC_FLE_FLE
union
select
  file_b as this_file,
  file_a as that_file,
  modify_by,
  modify_on
from
  T_OSI_ASSOC_FLE_FLE
/

CREATE OR REPLACE VIEW V_OSI_F_STATUS_HISTORY_LAST_DT
(FYLE, LAST_DATETIME)
AS 
select
  obj as fyle, MAX(create_on) as last_datetime
from T_OSI_STATUS_HISTORY
group by OBJ
/


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


CREATE OR REPLACE VIEW V_OSI_F_STATUS_HISTORY_CURRENT
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
     T_OSI_STATUS s
where sh.IS_CURRENT='Y' 
  and s.sid=sh.status 
  ---and s.obj_type = sh.obj_type
/


CREATE OR REPLACE VIEW V_OSI_FILE_RELATION
(THIS_FILE, THAT_FILE, MODIFY_BY, MODIFY_ON, THIS_ID, 
 THIS_TITLE, THIS_TYPE_CODE, THIS_TYPE, THIS_STATUS_DESC, THAT_ID, 
 THAT_TITLE, THAT_TYPE_CODE, THAT_TYPE, THAT_STATUS_DESC, THIS_FULL_ID, 
 THAT_FULL_ID)
AS 
select
  fr.THIS_FILE,
  fr.THAT_FILE,
  fr.MODIFY_BY,
  fr.MODIFY_ON,
  f1.id as this_id,
  f1.title as this_title,
  ot1.code as this_type_code,
  ot1.description as this_type,
  s1.status_desc as this_status_desc,
  f2.id as that_id,
  f2.title as that_title,
  ot2.code as that_type_code,
  ot2.description as that_type,
  s2.status_desc as that_status_desc,
  f1.full_id as this_full_id,
  f2.full_id as that_full_id
from
  v_osi_file_relation_1 fr,
  T_OSI_FILE f1,
  T_OSI_FILE f2,
  T_CORE_OBJ_TYPE ot1,
  T_CORE_OBJ_TYPE ot2,
  T_CORE_OBJ o1,
  T_CORE_OBJ o2,
  v_osi_f_status_history_current s1,
  v_osi_f_status_history_current s2
where f1.sid(+) = fr.this_file 
  and ot1.sid(+) = o1.obj_type 
  and o1.sid=f1.sid
  and f2.sid(+) = fr.that_file
  and ot2.sid(+) = o2.obj_type 
  and o2.sid=f2.sid
  and s1.fyle(+) = fr.this_file 
  and s2.fyle(+) = fr.that_file
/
