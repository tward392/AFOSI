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
