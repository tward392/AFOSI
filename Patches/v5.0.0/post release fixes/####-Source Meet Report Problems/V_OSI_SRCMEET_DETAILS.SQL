CREATE OR REPLACE VIEW V_OSI_SRCMEET_DETAILS
(SID, SOURCE, SOURCE_ID, ACTIVITY_ID, MEET_DATE, 
 HOUR, MINUTE, CONTACT_METHOD, CONTACT_METHOD_DESCRIPTION, COMMODITY, 
 NEXT_MEET_DATE, NEXT_HOUR, NEXT_MINUTE, LOCATION, CREATE_BY, INFO_RECEIVED, INFO_LEVIED)
AS 
select a.SID, a.source, s.id as source_id, a.id as activity_id, a.activity_date as meet_date,
           to_char(a.activity_date, 'hh24') hour, to_char(a.activity_date, 'mi') minute,
           sm.contact_method, r.description as contact_method_description, sm.commodity,
           sm.next_meet_date, to_char(sm.next_meet_date, 'hh24') hour,
           to_char(sm.next_meet_date, 'mi') minute,
           osi_address.get_addr_fields(osi_address.get_address_sid(sm.SID, 'LOCATION')) as location,
           o.create_by, sm.info_received, sm.info_levied
      from t_core_obj o, t_osi_activity a, t_osi_a_source_meet sm, t_osi_file s, t_osi_reference r
     where o.SID = a.SID and a.SID = sm.SID and a.source = s.SID and sm.contact_method = r.SID(+)
/

CREATE OR REPLACE TRIGGER osi_srcmeet_details_io_u_01
    instead of update
    ON WEBI2MS.V_OSI_SRCMEET_DETAILS     for each row
declare
    v_new_date   date;
    v_old_date   date;
    v_new_nextdate   date;
begin
    v_new_date :=
        to_date(to_char(:new.meet_date, 'yyyymmdd') || nvl(:new.hour, '00')
                || nvl(:new.minute, '00') || '00',
                'yyyymmddhh24miss');
    v_old_date :=
        to_date(to_char(:old.meet_date, 'yyyymmdd') || nvl(:old.hour, '00')
                || nvl(:old.minute, '00') || '00',
                'yyyymmddhh24miss');

    if v_new_date <> v_old_date then
        update t_osi_activity
           set activity_date = v_new_date
         where sid = :new.sid;
    end if;

    if :new.next_meet_date is not null then
        v_new_nextdate :=
            to_date(to_char(:new.next_meet_date, 'yyyymmdd') || nvl(:new.next_hour, '00')
                    || nvl(:new.next_minute, '00') || '00',
                    'yyyymmddhh24miss');
    end if;

    update t_osi_a_source_meet
       set contact_method = :new.contact_method,
           commodity = :new.commodity,
           next_meet_date = v_new_nextdate
     where sid = :new.sid;

    osi_address.update_single_address(:new.sid, 'LOCATION', :new.location);
end;
/