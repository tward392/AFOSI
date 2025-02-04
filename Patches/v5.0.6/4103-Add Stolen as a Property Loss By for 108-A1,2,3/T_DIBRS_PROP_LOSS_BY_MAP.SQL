---Used to insert into beta...........-------
---insert into t_dibrs_prop_loss_by_map (OFFENSE_TYPE,PROP_LOSS_BY,OFFENSE_RESULT)
---select ot.sid,lt.sid,r.sid from t_dibrs_offense_type ot,t_dibrs_property_loss_by_type lt,t_dibrs_reference r where ot.code like '108-A%' and lt.code='7' and r.code='C' and r.usage='OFFENSE_RESULT';
---COMMIT;


INSERT INTO T_DIBRS_PROP_LOSS_BY_MAP ( SID, OFFENSE_TYPE, OFFENSE_RESULT, PROP_LOSS_BY, CREATE_ON, CREATE_BY, MODIFY_ON, MODIFY_BY ) VALUES ( '33318WA5', '2220000065Z', '2220000062G', '222000006OD',  TO_Date( '08/16/2012 07:21:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/16/2012 07:21:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward'); 
INSERT INTO T_DIBRS_PROP_LOSS_BY_MAP ( SID, OFFENSE_TYPE, OFFENSE_RESULT, PROP_LOSS_BY, CREATE_ON, CREATE_BY, MODIFY_ON, MODIFY_BY ) VALUES ( '33318WA6', '22200000660', '2220000062G', '222000006OD',  TO_Date( '08/16/2012 07:21:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/16/2012 07:21:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward'); 
INSERT INTO T_DIBRS_PROP_LOSS_BY_MAP ( SID, OFFENSE_TYPE, OFFENSE_RESULT, PROP_LOSS_BY, CREATE_ON, CREATE_BY, MODIFY_ON, MODIFY_BY ) VALUES ( '33318WA7', '222000006AB', '2220000062G', '222000006OD',  TO_Date( '08/16/2012 07:21:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/16/2012 07:21:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward'); 
COMMIT;

