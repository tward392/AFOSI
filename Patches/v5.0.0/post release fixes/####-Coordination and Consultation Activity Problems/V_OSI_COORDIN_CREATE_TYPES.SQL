CREATE OR REPLACE VIEW V_OSI_COORDIN_CREATE_TYPES
(D, R)
AS 
select substr(description, 14, length(description) - 13) d, sid r
  from t_core_obj_type
 where code like substr('ACT.COORDINATION', 1, 16) || '%'
   and description <> 'Coordination'
   and osi_auth.check_for_priv('CREATE',sid)='Y'
/