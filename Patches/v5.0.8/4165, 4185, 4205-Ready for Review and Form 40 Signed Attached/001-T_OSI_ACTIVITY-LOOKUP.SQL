alter trigger OSI_ACT_B_IUD_BUMP disable;

ALTER TABLE T_OSI_ACTIVITY ADD READY_FOR_REVIEW VARCHAR2(1) DEFAULT 'N';
ALTER TABLE T_OSI_ACTIVITY_LOOKUP ADD READY_FOR_REVIEW VARCHAR2(1) DEFAULT 'N';
ALTER TABLE T_OSI_ACTIVITY_LOOKUP ADD SIGNED_FORM_40_ATTACHED VARCHAR2(1) DEFAULT 'N';

declare
  v_signed_form40_count number;
begin
     for a in (select sid from t_osi_activity_lookup order by sid)
     loop
         select count(*) into v_signed_form40_count from t_osi_attachment attach,t_osi_attachment_type at,t_core_obj o,t_core_obj_type ot 
                where attach.obj=o.sid 
                  and o.obj_type=ot.sid
                  and attach.type=at.sid
                  and at.code='FFORM40'
                  and o.sid=a.sid;
         
         if (v_signed_form40_count > 0) then

           update t_osi_activity_lookup set signed_form_40_attached='Y' where sid=a.sid;
           commit;

         end if;
    end loop;
end;

alter trigger OSI_ACT_B_IUD_BUMP enable;




