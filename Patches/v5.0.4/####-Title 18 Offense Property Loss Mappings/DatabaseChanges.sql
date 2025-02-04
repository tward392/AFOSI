---Offense ATTEMPTED---
insert into t_dibrs_prop_loss_by_map (offense_type,offense_result,prop_loss_by)
  select o.sid,r.sid,lb.sid from t_dibrs_offense_type o,t_dibrs_reference r,t_dibrs_property_loss_by_type lb where o.code in ('180872',
                                                                                                                              '180875',
                                                                                                                              '181831',
                                                                                                                              '180470',
                                                                                                                              '180286',
                                                                                                                              '180435',
                                                                                                                              '313729',
                                                                                                                              '26A',
                                                                                                                              '180371',
                                                                                                                              '180038',
                                                                                                                              '092C2B',
                                                                                                                              '181341',
                                                                                                                              '181031',
                                                                                                                              '092C2A',
                                                                                                                              '181002',
                                                                                                                              '180287',
                                                                                                                              '181030',
                                                                                                                              '26B',
                                                                                                                              '181029',
                                                                                                                              '26E',
                                                                                                                              '181343',
                                                                                                                              '180648',
                                                                                                                              '410051',
                                                                                                                              '180201',
                                                                                                                              '180208') 
                                                                                                               and r.code='A' and r.USAGE='OFFENSE_RESULT' and lb.code in ('1','8');
                                                                                                               
---Offense COMPLETED---
insert into t_dibrs_prop_loss_by_map (offense_type,offense_result,prop_loss_by)
  select o.sid,r.sid,lb.sid from t_dibrs_offense_type o,t_dibrs_reference r,t_dibrs_property_loss_by_type lb where o.code in ('180872',
                                                                                                                              '180875',
                                                                                                                              '181831',
                                                                                                                              '180286',
                                                                                                                              '180435',
                                                                                                                              '313729',
                                                                                                                              '26A',
                                                                                                                              '180371',
                                                                                                                              '180038',
                                                                                                                              '092C2B',
                                                                                                                              '181341',
                                                                                                                              '181031',
                                                                                                                              '092C2A',
                                                                                                                              '181002',
                                                                                                                              '180287',
                                                                                                                              '181030',
                                                                                                                              '26B',
                                                                                                                              '181029',
                                                                                                                              '26E',
                                                                                                                              '181343',
                                                                                                                              '180648')
                                                                                                               and r.code='C' and r.USAGE='OFFENSE_RESULT' and lb.code in ('5','7');                                                                                                               



                                                                                                               
insert into t_dibrs_prop_loss_by_map (offense_type,offense_result,prop_loss_by)
  select o.sid,r.sid,lb.sid from t_dibrs_offense_type o,t_dibrs_reference r,t_dibrs_property_loss_by_type lb where o.code in ('410051',
                                                                                                                              '180201',
                                                                                                                              '180208') 
                                                                                                               and r.code='C' and r.USAGE='OFFENSE_RESULT' and lb.code in ('1','5','7','8');                                                                                                               


insert into t_dibrs_prop_loss_by_map (offense_type,offense_result,prop_loss_by)
  select o.sid,r.sid,lb.sid from t_dibrs_offense_type o,t_dibrs_reference r,t_dibrs_property_loss_by_type lb where o.code in ('180470') 
                                                                                                               and r.code='C' and r.USAGE='OFFENSE_RESULT' and lb.code in ('3','5','6');                                                                                                               
                                                                                                               