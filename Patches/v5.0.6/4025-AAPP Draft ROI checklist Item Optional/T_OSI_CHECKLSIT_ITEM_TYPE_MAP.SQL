update t_osi_checklist_item_type_map set completion_required=0 where sid in (
select m.sid from t_osi_checklist_item_type t,t_osi_checklist_item_type_map m where t.title='Draft ROI Document attached' and t.sid=m.CHECKLIST_ITEM_TYPE_SID);
commit;