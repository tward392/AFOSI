---select o.sid,o.code,t.sid,t.code, r.sid, r.description
insert into t_dibrs_prop_loss_by_map (offense_type, prop_loss_by, offense_result)
select o.sid,t.sid,r.sid 
      from t_dibrs_offense_type o, t_dibrs_property_loss_by_type t, t_dibrs_reference r 
      where o.code in ('103-A1','103-A2','110-A-','110-B-','123AA1','123AA2','123AB-','134-A1','134-F1','134-V2','134-Z2','134-Z4','90A') and r.usage='OFFENSE_RESULT';
commit;