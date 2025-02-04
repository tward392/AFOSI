CREATE OR REPLACE VIEW V_OSI_ACTIVITY_SUMMARY
(SID, ID, TITLE, CREATE_ON, CREATE_BY, 
 RESTRICTION, ACTIVITY_DATE, CREATING_UNIT, ASSIGNED_UNIT, AUXILIARY_UNIT, 
 COMPLETE_DATE, SUSPENSE_DATE, CLOSE_DATE, CURRENT_STATUS, INV_SUPPORT, 
 NARRATIVE, OBJECT_TYPE_DESCRIPTION, OBJECT_TYPE_CODE, OBJECT_TYPE_SID, SUBSTANTIVE, 
 LEADERSHIP_APPROVED, READY_FOR_REVIEW)
AS 
select a.sid, a.id, a.title, o.create_on, o.create_by, a.restriction, a.activity_date,
           osi_unit.get_name(a.creating_unit) creating_unit,
           osi_unit.get_name(a.assigned_unit) assigned_unit,
           osi_unit.get_name(a.aux_unit) auxiliary_unit, a.complete_date, a.suspense_date,
           a.close_date, osi_object.get_status(a.sid) current_status,
           osi_activity.get_inv_support(a.sid) inv_support, a.narrative,
           ot.description as "OBJECT_TYPE_DESCRIPTION",
           ot.code as object_type_code,
           ot.sid as object_type_sid,
           substantive,
           leadership_approved,
           ready_for_review
      from t_core_obj o, t_osi_activity a, t_core_obj_type ot
     where a.sid = o.sid
       and o.obj_type=ot.sid
/


CREATE OR REPLACE TRIGGER "OSI_ACTIVITY_SUMMARY_IO_U_01" 
    instead of update
    on v_osi_activity_summary
    for each row
begin
    update t_osi_activity
       set title = :new.title,
           activity_date = :new.activity_date,
           restriction = :new.restriction,
           substantive = nvl(:new.substantive,'N'),
           leadership_approved = nvl(:new.leadership_approved,'N'),
           ready_for_review = nvl(:new.ready_for_review,'N')
     where sid = :new.sid;

    if nvl(:new.inv_support, 'null') <> nvl(:old.inv_support, 'null') then
        osi_activity.set_inv_support(:new.sid, :new.inv_support);
    end if;

    core_obj.bump(:new.sid);
end;
/


