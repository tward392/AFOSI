declare
  hist_record  varchar2(1) := 'N';
  recs_added   number := 0;
begin
  for a_rec in (select b.SID, 
                       decode (b.PERSONNEL_STATUS_SID, '22200000DKD','222000005IY',
                                                       '22200000DKE','22203BOL',
                                                       '22200000DKF','222000005IZ') as hist_status, 
                       a.DATE_TIME from t_osi_migration a, t_osi_personnel b 
                 where a.TYPE = 'PERSONNEL'
                   and a.new_sid = b.sid
                   and b.PERSONNEL_STATUS_SID is not null)
  loop

    begin
      select distinct 'Y' into hist_record from t_osi_status_history sh where sh.obj = a_rec.sid;
    exception
      when no_data_found then
        hist_record := 'N';
    end;

    if hist_record = 'N' then
      recs_added := recs_added+1;
      osi_status.change_status_brute (a_rec.sid,a_rec.hist_status,'Created',a_rec.date_time);
      commit;
    end if;
  end loop;
  sys.dbms_output.put_line('Status History Records Added: '||to_char(recs_added));
end;