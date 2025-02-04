CREATE OR REPLACE VIEW V_OSI_COORDIN_CREATE_TYPES
(D, R, ACTIVE)
AS 
select substr(description, 14, length(description) - 13) d, sid r, active
  from t_core_obj_type
 where code like substr('ACT.COORDINATION', 1, 16) || '%'
   and description <> 'Coordination'
   and (osi_auth.check_for_priv('CREATE',sid,null,null,'Y','Y')='Y'
    or  osi_auth.check_for_priv('CREATE',core_obj.lookup_objtype('ACT.COORDINATION'),null,null,'Y','Y')='Y')
/


