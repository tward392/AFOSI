CREATE OR REPLACE VIEW V_OSI_F_AAPP_FILE
(SID, START_DATE, CATEGORY_SID, CATEGORY_CODE, CATEGORY_DESC, 
 SYNOPSIS, SUSPENSE_DATE, APPLICANT_RANK, CURR_DISP)
AS 
select ofaf.sid, 
       ofaf.start_date, 
       ofaf.sid as CATEGORY_SID, 
       oref.code as CATEGORY_CODE,
       oref.description as CATEGORY_DESC, 
       ofaf.synopsis as SYNOPSIS,
       ofaf.suspense_date as SUSPENSE_DATE,
       DECODE (pv.sa_pay_plan_code, 'OM', 'Officer', 'EM', 'Enlisted', '') as applicant_rank,
       osi_status.Last_SH_Status_Change_Desc(ofaf.sid, osi_status.last_sh_sid(ofaf.sid,null)) as CURR_DISP
      from 
       t_osi_f_aapp_file ofaf, 
       t_osi_reference oref,
       t_osi_partic_involvement pi,
       v_osi_participant_version pv
     where 
       ofaf.category = oref.sid(+)
       and ofaf.sid=pi.obj(+)
       and pi.participant_version=pv.sid(+)
/

