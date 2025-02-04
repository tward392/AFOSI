CREATE OR REPLACE VIEW V_OSI_PARTICIPANT_INDIV_TITLE
(SID, PARTICIPANT, CURRENT_VERSION, NAME, ADDRESS, 
 SEX, DOB, RACE, SSN, CONFIRMED, 
 MEMBER_OF_ORG, SERVICE, AFFILIATION, COMPONENT, PAY_PLAN, 
 PAY_GRADE, RANK, RANK_DATE, SPECIALTY_CODE, MILITARY_ORGANIZATION, 
 DEERS_DATE)
AS 
select pv.sid, pv.participant, p.current_version, osi_participant.get_name(pv.sid) as name,
           --osi_address.get_addr_display(osi_address.get_address_sid(pv.participant),
           --                             null,
           --                             '<br>') as address,
           replace(osi_participant.get_address_data(pv.sid,'CURRENT_ML','DISPLAY'),chr(13)||chr(10),'<br>') as address,
           dsex.description as sex, p.dob, drace.description as race,
           osi_participant.get_number(pv.sid, 'SSN') as ssn,
           osi_participant.get_confirmation(pv.sid) as confirmed,
           osi_participant.get_org_member_name(pv.sid) as member_of_org,
           dservice.description as service, r.description as affiliation,
           dcomponent.description as component, dpp.description as pay_plan,
           dpg.description as pay_grade, ph.sa_rank as rank, ph.sa_rank_date as rank_date,
           ph.sa_specialty_code as specialty_code,
           osi_participant.get_mil_member_name(pv.sid) as military_organization,
           ph.deers_date as deers_date
      from t_core_obj o,
           t_osi_participant p,
           t_osi_participant_human ph,
           t_osi_participant_version pv,
           t_osi_person_chars pc,
           t_dibrs_reference dsex,
           t_dibrs_reference dservice,
           t_dibrs_reference dcomponent,
           t_dibrs_reference dpp,
           t_dibrs_race_type drace,
           t_dibrs_pay_grade_type dpg,
           t_osi_reference r
     where o.sid = p.sid
       and p.sid = pv.participant
       and ph.sid(+) = pv.sid
       and pc.sid(+) = pv.sid
       and dservice.sid(+) = ph.sa_service
       and r.sid(+) = ph.sa_affiliation
       and dcomponent.sid(+) = ph.sa_component
       and dpp.sid(+) = pc.sa_pay_plan
       and dpg.sid(+) = pc.sa_pay_grade
       and dsex.sid(+) = pc.sex
       and drace.sid(+) = pc.race
/