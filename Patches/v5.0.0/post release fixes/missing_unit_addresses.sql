update t_osi_address oa
set oa.address_type = '22200000EI9'
where 
oa.address_type is null and
oa.OBJ in (select a.sid from t_core_obj a
         where a.obj_type = '222000005ID')
         
         