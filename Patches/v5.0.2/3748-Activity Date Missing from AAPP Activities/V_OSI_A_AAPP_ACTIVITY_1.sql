CREATE OR REPLACE VIEW V_OSI_A_AAPP_ACTIVITY_1
(ACTIVITY_DATE, HOUR, MINUTE, SID, DEG_SCHOOL, 
 DEG_DEGREE, DEG_GRAD_DATE, DATE_FROM, DATE_TO, ADDRESS1, 
 ADDRESS2, EMP_EMPLOYER, EMP_POSITION, EMP_POS_TYPE, INT_OF, 
 INT_ORG, INT_PHONE, INT_TYPE, INT_INTERVIEWER, INT_ASST_INTERVIEWER, 
 INT_RELATIVE, RECCHK_REFNUM, RECCHK_POC, RECCHK_AGENCY, DOC_DATE, 
 DOC_TYPE, DOC_NUM, DOC_OBTAINED_FROM)
AS 
SELECT
  A.ACTIVITY_DATE AS ACTIVITY_DATE,
  to_char(a.activity_date, 'hh24') hour,
  to_char(a.activity_date, 'mi') minute,
  AA.SID AS SID,
  DEG_SCHOOL,
  DEG_DEGREE,
  DEG_GRAD_DATE,
  DATE_FROM,
  DATE_TO,
  ADDRESS1,
  ADDRESS2,
  EMP_EMPLOYER,
  EMP_POSITION,
  EMP_POS_TYPE,
  INT_OF,
  INT_ORG,
  INT_PHONE,
  INT_TYPE,
  INT_INTERVIEWER,
  INT_ASST_INTERVIEWER,
  INT_RELATIVE,
  RECCHK_REFNUM,
  RECCHK_POC,
  RECCHK_AGENCY,
  DOC_DATE,
  DOC_TYPE,
  DOC_NUM,
  DOC_OBTAINED_FROM
FROM T_OSI_A_AAPP_ACTIVITY AA,T_OSI_ACTIVITY A
  WHERE AA.SID=A.SID
/


CREATE OR REPLACE TRIGGER V_OSI_A_AAPP_A_1_io_u_01
    instead of update
    on V_OSI_A_AAPP_ACTIVITY_1
    for each row
begin
    update t_osi_activity
       set activity_date = to_date(to_char(:new.activity_date, 'yyyymmdd') || nvl(:new.hour, '01') || nvl(:new.minute, '00') || '00', 'yyyymmddhh24miss')
     where sid = :new.sid;

    update t_osi_a_aapp_activity
       set DEG_SCHOOL=:new.DEG_SCHOOL,
           DEG_DEGREE=:new.DEG_DEGREE,
           DEG_GRAD_DATE=:new.DEG_GRAD_DATE,
           DATE_FROM=:new.DATE_FROM,
           DATE_TO=:new.DATE_TO,
           ADDRESS1=:new.ADDRESS1,
           ADDRESS2=:new.ADDRESS2,
           EMP_EMPLOYER=:new.EMP_EMPLOYER,
           EMP_POSITION=:new.EMP_POSITION,
           EMP_POS_TYPE=:new.EMP_POS_TYPE,
           INT_OF=:new.INT_OF,
           INT_ORG=:new.INT_ORG,
           INT_PHONE=:new.INT_PHONE,
           INT_TYPE=:new.INT_TYPE,
           INT_INTERVIEWER=:new.INT_INTERVIEWER,
           INT_ASST_INTERVIEWER=:new.INT_ASST_INTERVIEWER,
           INT_RELATIVE=:new.INT_RELATIVE,
           RECCHK_REFNUM=:new.RECCHK_REFNUM,
           RECCHK_POC=:new.RECCHK_POC,
           RECCHK_AGENCY=:new.RECCHK_AGENCY,
           DOC_DATE=:new.DOC_DATE,
           DOC_TYPE=:new.DOC_TYPE,
           DOC_NUM=:new.DOC_NUM,
           DOC_OBTAINED_FROM=:new.DOC_OBTAINED_FROM       
     where sid = :new.sid;

    core_obj.bump(:new.sid);
end;
/