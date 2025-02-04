CREATE TRIGGER WEBI2MS."OSI_SUBDISP_B_U_02" 
    before update
    on T_OSI_F_INV_SUBJ_DISPOSITION
    for each row
begin
    if :new.INVESTIGATION <> :old.INVESTIGATION then
        RAISE_APPLICATION_ERROR(-20200, 'Cannot move row to different Investigation.', false);
    end if;
    if :new.SUBJECT <> :old.SUBJECT then
       RAISE_APPLICATION_ERROR(-20200, 'Cannot move row to different Subject.', false);
    end if;
end;
/

CREATE TRIGGER WEBI2MS."OSI_STATHIST_B_I_02" 
    before insert 
    on T_OSI_STATUS_HISTORY
    for each row
declare
    o_sh t_osi_status_change.FROM_STATUS%type := null;
    o_type t_core_obj_type.SID%type := null;
    match_found  varchar2(1) := 'N';
begin
    o_type := core_obj.GET_OBJTYPE(:new.obj);
    o_sh   := osi_object.GET_STATUS_SID(:new.obj);
         
     if o_sh is not null then
     begin
     select distinct 'Y' into match_found 
     from t_osi_status_change sc
     where sc.FROM_STATUS = o_sh
       and sc.TO_STATUS = :new.STATUS
       and sc.OBJ_TYPE member of osi_object.GET_OBJTYPES(o_type);
     exception
     when no_data_found then
       RAISE_APPLICATION_ERROR(-20200, 'Error creating Status History.',false);
     end;
     end if;   
end;
/
