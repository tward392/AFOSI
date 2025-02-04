CREATE OR REPLACE TRIGGER osi_srcmeet_details_io_u_01
    instead of update
    ON WEBI2MS.V_OSI_SRCMEET_DETAILS     for each row
declare

  v_new_date       date;
  v_old_date       date;
  v_new_nextdate   date;

begin

  v_new_date := to_date(to_char(:new.meet_date, 'yyyymmdd') || nvl(:new.hour, '00') || nvl(:new.minute, '00') || '00', 'yyyymmddhh24miss');

  v_old_date := to_date(to_char(:old.meet_date, 'yyyymmdd') || nvl(:old.hour, '00') || nvl(:old.minute, '00') || '00', 'yyyymmddhh24miss');

  if v_new_date <> v_old_date then

    update t_osi_activity set activity_date = v_new_date where sid = :new.sid;

  end if;

  if :new.next_meet_date is not null then

    v_new_nextdate := to_date(to_char(:new.next_meet_date, 'yyyymmdd') || nvl(:new.next_hour, '00') || nvl(:new.next_minute, '00') || '00', 'yyyymmddhh24miss');

  end if;

  update t_osi_a_source_meet set contact_method = :new.contact_method,
                                 commodity = :new.commodity,
                                 next_meet_date = v_new_nextdate
        where sid = :new.sid;
  
  ---Added for CR#3830 where If Source Was changed it would not save---
  if :old.source != :new.source then

    update t_osi_activity set source = :new.source where sid = :new.sid;

  end if;

  osi_address.update_single_address(:new.sid, 'LOCATION', :new.location);
  
end;
/