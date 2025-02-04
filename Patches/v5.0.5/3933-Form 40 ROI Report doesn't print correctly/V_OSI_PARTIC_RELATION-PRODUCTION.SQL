CREATE OR REPLACE VIEW V_OSI_PARTIC_RELATION
(SID, THIS_PARTICIPANT, THIS_NAME, RELATED_TO, RELATED_NAME, 
 RELATION_CODE, DESCRIPTION, SPECIFICS, COMMENTS, MOD2_VALUE)
AS 
select pr.sid, pr.partic_a as this_participant, osi_participant.get_name(pr.partic_a) as this_name,
           pr.partic_b as related_to, osi_participant.get_name(pr.partic_b) as related_name,
           rt.code as relation_code, rt.description,
           rtrim(decode(pr.mod1_value, null, null, rt.mod1_name || ':' || pr.mod1_value) || ', '
                 || decode(pr.mod2_value, null, null, rt.mod2_name || ':' || pr.mod2_value) || ', '
                 || decode(pr.mod3_value, null, null, rt.mod3_name || ':' || pr.mod3_value),
                 ':, ') as specifics,
           pr.comments, pr.mod2_value
      from t_osi_partic_relation pr, t_osi_partic_relation_type rt
     where pr.rel_type = rt.sid
/