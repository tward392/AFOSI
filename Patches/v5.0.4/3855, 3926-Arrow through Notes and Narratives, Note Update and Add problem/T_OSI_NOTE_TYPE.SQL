update t_osi_note_type set lock_mode='72HR' 
   where lock_mode is null 
     and description in ('Reviewer Note','Case Strategy','Tech Advice','OES Note','USM Note','DetCo/SAC Note','Bibliography','Specialist Note','Support Staff Note');

update t_osi_note_type set lock_mode='NEVER' 
   where lock_mode is null 
     and description in ('IDP Note');

commit;

begin
     for n in (select * from t_osi_note where lock_mode is null)
     loop
         update t_osi_note set lock_mode=(select lock_mode from t_osi_note_type where sid=n.note_type) where sid=n.sid;
         commit;

     end loop;
end;
/
