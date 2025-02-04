CREATE OR REPLACE FORCE VIEW webi2ms.v_osi_consult_create_types (d, r)
AS
   SELECT SUBSTR (description, 14, LENGTH (description) - 13) d, SID r
     FROM t_core_obj_type
    WHERE code LIKE SUBSTR ('ACT.CONSULTATION', 1, 16) || '%'
      AND description <> 'Consultation'
      AND osi_auth.check_for_priv ('CREATE', SID) = 'Y';

