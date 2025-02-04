update t_osi_note_type set code='RN'
 where code='REV' and obj_type in (select sid from t_core_obj_type where code in ('FILE.INV.INFO','FILE.INV.DEV'));
commit;