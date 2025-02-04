INSERT INTO T_OSI_AUTH_ACTION_TYPE ( SID, CODE, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33318LTX', 'PMM_CLOSE', 'PMM:  Allow Closing of a PMM.', 'timothy.ward',  TO_Date( '04/16/2012 01:29:23 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '04/16/2012 01:29:50 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_AUTH_ACTION_TYPE ( SID, CODE, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33318LTY', 'PMM_SUSPEND', 'PMM:  Allow Suspending of a PMM.', 'timothy.ward',  TO_Date( '04/16/2012 01:31:20 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '04/16/2012 01:31:20 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;


update t_osi_status_change set auth_action='33318LTX' where button_label='Close User Account';
update t_osi_status_change set auth_action='33318LTY' where button_label='Suspend User Account';
COMMIT;


INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '33318LTZ', '222000005HF', '33318LTX', 'timothy.ward',  TO_Date( '04/16/2012 01:40:45 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '04/16/2012 01:40:45 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'Close a PMM'); 
INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '33318LU0', '222000005HF', '33318LTY', 'timothy.ward',  TO_Date( '04/16/2012 01:41:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '04/16/2012 01:41:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'Suspend a PMM'); 
COMMIT;




--- Give Close and Suspend to the Two Roles that Already have the Create ---
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','Y','Y' from t_osi_auth_role r where code='HQPMO';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='HQHELP';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','Y','Y' from t_osi_auth_role r where code='HQPMO';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='HQHELP';
commit;







--- Give Close and Suspend to the Commander Type Roles ---
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='BRANCH';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='BRANCH';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='RGNCOMMAND';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='RGNCOMMAND';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='RGNSC';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='RGNSC';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='RGNSUPER';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='RGNSUPER';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='RGNVC';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='RGNVC';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='SQDCOMMAND';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='SQDCOMMAND';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='COMMANDER';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='COMMANDER';

insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LTZ','N','Y' from t_osi_auth_role r where code='SUPER';
insert into t_osi_auth_role_priv (sid,role,priv,grantable,enabled) select null,r.sid,'33318LU0','N','Y' from t_osi_auth_role r where code='SUPER';
commit;



