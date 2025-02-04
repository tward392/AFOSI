CREATE OR REPLACE VIEW V_OSI_ASSOC_FLE_ACT
(SID, FILE_SID, FILE_ID, FILE_TITLE, FILE_TYPE_DESC, 
 ACTIVITY_SID, ACTIVITY_ID, ACTIVITY_TITLE, ACTIVITY_TYPE_DESC, ACTIVITY_COMPLETE_DATE, 
 ACTIVITY_CLOSE_DATE, ACTIVITY_DATE, ACTIVITY_SUSPENSE_DATE, ACTIVITY_UNIT_ASSIGNED, SUBSTANTIVE, LEADERSHIP_APPROVED, 
 SOURCE)
AS 
select oafa.sid, oafa.file_sid, of1.id as "FILE_ID", of1.title as "FILE_TITLE",
           cot1.description as "FILE_TYPE_DESC", oafa.activity_sid, oa.id as "ACTIVITY_ID",
           oa.title as "ACTIVITY_TITLE", cot2.description as "ACTIVITY_TYPE_DESC",
           oa.complete_date as "ACTIVITY_COMPLETE_DATE", oa.close_date as "ACTIVITY_CLOSE_DATE",
           oa.activity_date as "ACTIVITY_DATE", oa.suspense_date as "ACTIVITY_SUSPENSE_DATE", 
           osi_unit.get_name(oa.assigned_unit) as "ACTIVITY_UNIT_ASSIGNED",
           oa.substantive as "SUBSTANTIVE",
           oa.leadership_approved as "APPROVED",
           oa.source as "SOURCE"
    from   t_osi_assoc_fle_act oafa,
           t_osi_file of1,
           t_core_obj co1,
           t_core_obj_type cot1,
           t_osi_activity oa,
           t_core_obj co2,
           t_core_obj_type cot2
     where of1.sid = oafa.file_sid
       and of1.sid = co1.sid
       and cot1.sid = co1.obj_type
       and oa.sid = oafa.activity_sid
       and oa.sid = co2.sid
       and cot2.sid = co2.obj_type
/


