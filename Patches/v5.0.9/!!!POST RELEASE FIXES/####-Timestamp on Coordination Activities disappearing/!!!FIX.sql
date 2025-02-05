CREATE OR REPLACE TRIGGER "OSI_ACTIVITY_SUMMARY_IO_U_01" 
    instead of update
    on v_osi_activity_summary
    for each row
begin
    update t_osi_activity
       set title = :new.title,
           restriction = :new.restriction,
           substantive = nvl(:new.substantive,'N'),
           leadership_approved = nvl(:new.leadership_approved,'N'),
           ready_for_review = nvl(:new.ready_for_review,'N')
     where sid = :new.sid;

    if nvl(:new.inv_support, 'null') <> nvl(:old.inv_support, 'null') then
        osi_activity.set_inv_support(:new.sid, :new.inv_support);
    end if;

    core_obj.bump(:new.sid);
end;
/
