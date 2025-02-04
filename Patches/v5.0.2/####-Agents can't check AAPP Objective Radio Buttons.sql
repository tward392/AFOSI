insert into t_osi_auth_role_priv (role,priv,grantable,enabled) select r.sid,p.sid,'N','Y' from t_osi_auth_role r,t_osi_auth_priv p where r.code='AGTPERS' and p.DESCRIPTION='Agent Application File, Update "Objective Was Met"';
insert into t_osi_auth_role_priv (role,priv,grantable,enabled) select r.sid,p.sid,'N','Y' from t_osi_auth_role r,t_osi_auth_priv p where r.code='SUPPORT' and p.DESCRIPTION='Agent Application File, Update "Objective Was Met"';
COMMIT;
