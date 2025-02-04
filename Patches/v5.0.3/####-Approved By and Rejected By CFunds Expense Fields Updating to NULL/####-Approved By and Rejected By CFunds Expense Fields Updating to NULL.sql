CREATE OR REPLACE TRIGGER osi_cfunds_exp_io_u_01
    instead of delete or insert or update
    on v_cfunds_expense_v3
    referencing new as new old as old
    for each row
declare
    v_sid           varchar2(20);
    v_obj_type      varchar2(20);
    v_approved_by   varchar2(100) := :new.approved_by;
    v_rejected_by   varchar2(100) := :new.rejected_by;
begin
    if inserting then
        v_obj_type := core_obj.lookup_objtype('CFUNDS_EXP');

        insert into t_core_obj
                    (obj_type)
             values (v_obj_type)
          returning sid
               into v_sid;

        insert into t_cfunds_expense_v3
                    (sid,
                     incurred_date,
                     charge_to_unit,
                     claimant,
                     category,
                     paragraph,
                     description,
                     parent,
                     parent_info,
                     take_from_advances,
                     take_from_other_sources,
                     receipts_disposition,
                     source_amount,
                     agent_amount,
                     conversion_rate)
             values (v_sid,
                     :new.incurred_date,
                     :new.charge_to_unit,
                     :new.claimant,
                     :new.category,
                     :new.paragraph,
                     :new.description,
                     :new.parent,
                     :new.parent_info,
                     :new.take_from_advances,
                     :new.take_from_other_sources,
                     :new.receipts_disposition,
                     :new.source_amount,
                     :new.agent_amount,
                     :new.conversion_rate);

        core_obj.bump(v_sid);
    elsif updating then
        if (:old.approved_on is null and :new.approved_on is not null) then
            v_approved_by := substr(core_context.personnel_name, 1, 100);
        end if;

        if (:old.rejected_on is null and :new.rejected_on is not null) then
            v_rejected_by := substr(core_context.personnel_name, 1, 100);
        end if;

        update t_cfunds_expense_v3
           set incurred_date = :new.incurred_date,
               charge_to_unit = :new.charge_to_unit,
               paragraph = :new.paragraph,
               claimant = :new.claimant,
               category = :new.category,
               description = :new.description,
               source_amount = :new.source_amount,
               agent_amount = :new.agent_amount,
               conversion_rate = :new.conversion_rate,
               take_from_advances = :new.take_from_advances,
               receipts_disposition = :new.receipts_disposition,
               submitted_on = :new.submitted_on,
               approved_on = :new.approved_on,
               approved_by = v_approved_by,
               rejected_on = :new.rejected_on,
               rejected_by = v_rejected_by,
               rejection_comment = :new.rejection_comment
         where sid = :new.sid;

        core_obj.bump(:new.sid);
    end if;
exception
    when others then
        -- Consider logging the error and then re-raise
        raise;
end;
/