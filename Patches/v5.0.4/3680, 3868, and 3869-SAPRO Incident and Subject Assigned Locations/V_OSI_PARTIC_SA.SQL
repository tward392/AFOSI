CREATE OR REPLACE VIEW V_OSI_PARTIC_SA
(SID, SERVICE, SERVICE_DESC, AFFILIATION, AFFILIATION_DESC, 
 COMPONENT, COMPONENT_DESC, RANK, RANK_DATE, SPECIALTY_CODE, 
 PAY_PLAN, PAY_PLAN_DESC, PAY_GRADE, PAY_GRADE_DESC, PAY_BAND, 
 PAY_BAND_DESC, RESERVIST, RESERVIST_TYPE, RESERVIST_TYPE_DESC, RESERVIST_STATUS, 
 RESERVIST_STATUS_DESC, FSA_SERVICE, FSA_SERVICE_DESC, FSA_RANK, FSA_EQUIV_RANK, 
 FSA_RANK_DATE, SUSPECTED_IO, KNOWN_IO, CLEARANCE, CLEARANCE_DESC, SAPRO_ASSIGNED_LOCATION_CODE)
AS 
select ph.sid, ph.sa_service as service, dr1.description as service_desc,
       ph.sa_affiliation as affiliation, r1.description as affiliation_desc,
       ph.sa_component as component, dr2.description as component_desc, ph.sa_rank as rank,
       ph.sa_rank_date as rank_date, ph.sa_specialty_code as specialty_code,
       pc.sa_pay_plan as pay_plan, dr3.description as pay_plan_desc, pc.sa_pay_grade as pay_grade,
       pgt.description as pay_grade_desc, pc.sa_pay_band as pay_band,
       pbt.description as pay_band_desc, ph.sa_reservist as reservist,
       ph.sa_reservist_type as reservist_type, r2.description as reservist_type_desc,
       ph.sa_reservist_status as reservist_status, r3.description as reservist_status_desc,
       ph.fsa_service, dr4.description as fsa_service_desc, ph.fsa_rank, ph.fsa_equiv_rank,
       ph.fsa_rank_date, ph.suspected_io, ph.known_io, ph.clearance,
       r4.description as clearance_desc,
       sapro_assigned_location_code
  from t_osi_participant_human ph,
       t_osi_person_chars pc,
       t_dibrs_reference dr1,
       t_dibrs_reference dr2,
       t_dibrs_reference dr3,
       t_dibrs_reference dr4,
       t_osi_reference r1,
       t_osi_reference r2,
       t_osi_reference r3,
       t_osi_reference r4,
       t_dibrs_pay_grade_type pgt,
       t_dibrs_pay_band_type pbt
 where ph.sid = pc.sid(+)
   and ph.sa_service = dr1.sid(+)
   and ph.sa_affiliation = r1.sid(+)
   and ph.sa_component = dr2.sid(+)
   and pc.sa_pay_plan = dr3.sid(+)
   and pc.sa_pay_grade = pgt.sid(+)
   and pc.sa_pay_band = pbt.sid(+)
   and ph.sa_reservist_type = r2.sid(+)
   and ph.sa_reservist_status = r3.sid(+)
   and ph.fsa_service = dr4.sid(+)
   and ph.clearance = r4.sid(+)
/


CREATE OR REPLACE TRIGGER "OSI_PARTIC_SA_IO_U_01" 
    instead of update
    ON V_OSI_PARTIC_SA     for each row
declare
    v_count   integer;
begin
    update t_osi_participant_human ph
       set ph.sa_service = :new.service,
           ph.sa_affiliation = :new.affiliation,
           ph.sa_component = :new.component,
           ph.sa_rank = :new.rank,
           ph.sa_rank_date = :new.rank_date,
           ph.sa_specialty_code = :new.specialty_code,
           ph.sa_reservist = :new.reservist,
           ph.sa_reservist_type = :new.reservist_type,
           ph.sa_reservist_status = :new.reservist_status,
           ph.fsa_service = :new.fsa_service,
           ph.fsa_rank = :new.fsa_rank,
           ph.fsa_equiv_rank = :new.fsa_equiv_rank,
           ph.fsa_rank_date = :new.fsa_rank_date,
           ph.suspected_io = :new.suspected_io,
           ph.known_io = :new.known_io,
           ph.clearance = :new.clearance,
           sapro_assigned_location_code = :new.sapro_assigned_location_code
     where ph.sid = :new.sid;

    select count(sid)
      into v_count
      from t_osi_person_chars
     where sid = :new.sid and rownum = 1;

    if (v_count > 0) then
        update t_osi_person_chars pc
           set pc.sa_pay_plan = :new.pay_plan,
               pc.sa_pay_grade = :new.pay_grade,
               pc.sa_pay_band = :new.pay_band
         where pc.sid = :new.sid;
    else
        insert into t_osi_person_chars
                    (sid, sa_pay_plan, sa_pay_grade, sa_pay_band)
             values (:new.sid, :new.pay_plan, :new.pay_grade, :new.pay_band);
    end if;
    exception
    when others then
     raise;
end;
/