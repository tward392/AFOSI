CREATE OR REPLACE VIEW V_OSI_RPT_SRCMEET
(SID, SOURCE, SOURCE_ID, ACTIVITY_ID, MEET_DATE, 
 HOUR, MINUTE, CONTACT_METHOD, CONTACT_METHOD_DESCRIPTION, COMMODITY, 
 NEXT_MEET_DATE, NEXT_HOUR, NEXT_MINUTE, LOCATION, CREATE_BY, 
 INFO_RECEIVED, INFO_LEVIED, LEAD_SUPPORT_AGENTS)
AS 
select a.SID, a.source, s.id as source_id, a.id as activity_id, a.activity_date as meet_date,
           to_char(a.activity_date, 'hh24') hour, to_char(a.activity_date, 'mi') minute,
           sm.contact_method, r.description as contact_method_description, sm.commodity,
           sm.next_meet_date, to_char(sm.next_meet_date, 'hh24') hour,
           to_char(sm.next_meet_date, 'mi') minute,
           osi_address.get_addr_fields(osi_address.get_address_sid(sm.SID, 'LOCATION')) as location,
           o.create_by, sm.info_received, sm.info_levied,
           RTRIM(osi_report.Get_Assignments(A.SID,'~Lead Agent~') || ' / ' || osi_report.Get_Assignments(A.SID, '~Support Agent~'),' / ') AS LEAD_SUPPORT_AGENTS
      from t_core_obj o, t_osi_activity a, t_osi_a_source_meet sm, t_osi_file s, t_osi_reference r
     where o.SID = a.SID and a.SID = sm.SID and a.source = s.SID and sm.contact_method = r.SID(+)
/