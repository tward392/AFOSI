CREATE OR REPLACE VIEW V_OSI_CONSULT_CREATE_TYPES
(D, R)
AS 
select substr(description, 14, length(description) - 13) d, sid r
  from t_core_obj_type
 where code like substr('ACT.CONSULTATION', 1, 16) || '%'
   and description <> 'Consultation'
   and osi_auth.check_for_priv('CREATE',sid,null,null,'Y','Y')='Y'
/

