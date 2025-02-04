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