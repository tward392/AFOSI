CREATE OR REPLACE VIEW V_OSI_SURVACT_DETAILS
(SID, ACTIVITY_DATE, EMERGENCY, CONSENSUAL, US_LOCATION, 
 ITEM_CASE, INFO_TYPE, TECHNIQUE, TARGET_TYPE, REQUESTED_DURATION, 
 ACTIVATION_DATE, TSO_COORD_DATE, ADDRESS_INTRCPT, INTERCEPT_LINE, PWA_REQUIRED, 
 OTHER_EQUIP, OTHER_EQ_LOC, INTERCEPTCONDUCTED, APPROVED_BY, APPROVED_DURATION, 
 APPROVED_DATE, APPROVAL_CREATE_BY, APPROVAL_CREATE_ON, APPROVAL_MODIFY_BY, APPROVAL_MODIFY_ON, 
 EQ_LOC_LIST, EQUIPMENT_LIST, PURPOSE_LIST)
AS 
select a.sid, a.activity_date, s.emergency, s.consensual, s.us_location, s.item_case,
           s.info_type, s.technique, s.target_type, s.requested_duration, s.activation_date,
           s.tso_coord_date,
           osi_address.get_addr_fields
                                    (osi_address.get_address_sid(a.sid, 'ADDR_INTRCPT'))
                                                                                 as address_intrcpt,
           s.intercept_line, s.pwa_required, s.other_equip, s.other_eq_loc, s.interceptconducted,
           s.approved_by, s.approved_duration, s.approved_date, s.approval_create_by,
           s.approval_create_on, s.approval_modify_by, s.approval_modify_on,
           osi_surveillance.get_surv_eq_loc(a.sid) eq_loc_list,
           osi_surveillance.get_surv_equipment(a.sid) equipment_list,
           osi_surveillance.get_surv_purpose(a.sid) purpose_list
      from t_osi_activity a, t_osi_a_surveillance s
     where s.sid = a.sid
/


CREATE OR REPLACE TRIGGER "OSI_SURVACT_DETAILS_IO_U_01" 
    instead of update
    ON V_OSI_SURVACT_DETAILS     for each row
begin
    if (:new.activity_date <> :old.activity_date) then
        update t_osi_activity
           set activity_date = :new.activity_date
         where SID = :new.SID;
    end if;

    --updated columns in t_osi_a_surveillance
    update t_osi_a_surveillance
       set emergency = nvl(:new.emergency, 'N'),
           consensual = nvl(:new.consensual, 'N'),
           us_location = nvl(:new.us_location, 'N'),
           item_case = :new.item_case,
           info_type = :new.info_type,
           technique = :new.technique,
           target_type = :new.target_type,
           requested_duration = :new.requested_duration,
           activation_date = :new.activation_date,
           tso_coord_date = :new.tso_coord_date,
           intercept_line = :new.intercept_line,
           pwa_required = :new.pwa_required,
           other_equip = :new.other_equip,
           other_eq_loc = :new.other_eq_loc,
           interceptconducted = :new.interceptconducted,
           approved_duration = :new.approved_duration,
           approved_date = :new.approved_date,
           approved_by = :new.approved_by
     where SID = :new.SID
       and (   nvl(emergency, 'x') <> nvl(:new.emergency, 'x')
            or nvl(consensual, 'x') <> nvl(:new.consensual, 'x')
            or nvl(us_location, 'x') <> nvl(:new.us_location, 'x')
            or nvl(item_case, 'x') <> nvl(:new.item_case, 'x')
            or nvl(info_type, 'x') <> nvl(:new.info_type, 'x')
            or nvl(technique, 'x') <> nvl(:new.technique, 'x')
            or nvl(target_type, 'x') <> nvl(:new.target_type, 'x')
            or nvl(requested_duration, -1) <> nvl(:new.requested_duration, -1)
            or nvl(activation_date, sysdate) <> nvl(:new.activation_date, sysdate)
            or nvl(tso_coord_date, sysdate) <> nvl(:new.tso_coord_date, sysdate)
            or nvl(intercept_line, 'x') <> nvl(:new.intercept_line, 'x')
            or nvl(pwa_required, 'x') <> nvl(:new.pwa_required, 'x')
            or nvl(other_equip, 'x') <> nvl(:new.other_equip, 'x')
            or nvl(other_eq_loc, 'x') <> nvl(:new.other_eq_loc, 'x')
            or nvl(interceptconducted, 'x') <> nvl(:new.interceptconducted, 'x')
            or nvl(approved_duration, -1) <> nvl(:new.approved_duration, -1)
            or nvl(approved_date, sysdate) <> nvl(:new.approved_date, sysdate)
            or nvl(approved_by, 'x') <> nvl(:new.approved_by, 'x'));

    --update  surveillance address of intercept
    osi_address.update_single_address(:new.SID, 'ADDR_INTRCPT', :new.address_intrcpt);

    -- update approval created/modified stamps if approval fields have changed.
    if    nvl(:new.approved_duration, -1) <> nvl(:old.approved_duration, -1)
       or nvl(:new.approved_date, sysdate) <> nvl(:old.approved_date, sysdate)
       or nvl(:new.approved_by, 'x') <> nvl(:old.approved_by, 'x') then
        update t_osi_a_surveillance
           set approval_modify_by = core_context.personnel_name,
               approval_modify_on = sysdate
         where sid = :new.sid;

        if :new.approval_create_by is null then
            update t_osi_a_surveillance
               set approval_create_by = core_context.personnel_name,
                   approval_create_on = sysdate
             where sid = :new.sid;
        end if;
    end if;

    osi_surveillance.set_surv_eq_loc(:new.SID, :new.eq_loc_list);
    osi_surveillance.set_surv_equipment(:new.SID, :new.equipment_list);
    osi_surveillance.set_surv_purpose(:new.SID, :new.purpose_list);
    core_obj.bump(:new.SID);
end;
/


