delete from t_cfunds_expense_v3 e where e.SID not in (select sid from t_core_obj) and paid_on is null;
commit;

alter table t_cfunds_expense_v3 add constraint fk_osi_expense_obj foreign key (sid) references t_core_obj(sid) ON DELETE CASCADE;