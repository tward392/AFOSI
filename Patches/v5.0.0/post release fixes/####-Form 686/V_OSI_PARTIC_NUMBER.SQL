CREATE OR REPLACE VIEW V_OSI_PARTIC_NUMBER
(SID, PARTICIPANT, PARTICIPANT_VERSION, NUM_TYPE, NUM_VALUE, 
 ISSUE_DATE, EXPIRE_DATE, ISSUE_COUNTRY, ISSUE_STATE, ISSUE_PROVINCE, 
 NOTE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, 
 NUM_TYPE_DESC, NUM_TYPE_CODE, ISSUE_STATE_CODE, ISSUE_STATE_DESC, ISSUE_COUNTRY_CODE, 
 ISSUE_COUNTRY_DESC)
AS 
SELECT pn.SID, (SELECT PARTICIPANT FROM t_osi_participant_version WHERE SID = pn.PARTICIPANT_VERSION) AS PARTICIPANT,
       pn.PARTICIPANT_VERSION, pn.NUM_TYPE, pn.NUM_VALUE, pn.ISSUE_DATE,
       pn.EXPIRE_DATE, pn.ISSUE_COUNTRY, pn.ISSUE_STATE,
       pn.ISSUE_PROVINCE, pn.NOTE, pn.CREATE_BY, pn.CREATE_ON,
       pn.MODIFY_BY, pn.MODIFY_ON, pnt.description AS num_type_desc, pnt.code,
       ds.code, ds.description, dc.code, dc.description
  FROM t_osi_partic_number pn, t_osi_partic_number_type pnt, t_dibrs_state ds, t_dibrs_country dc
   WHERE pnt.sid = pn.num_type
     and pn.issue_state=ds.sid(+)
     and pn.issue_country=dc.sid(+)
/