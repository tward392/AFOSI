insert into t_osi_auth_role_priv 
(role,priv)  select role,'333195NI' from t_osi_auth_role_priv where priv='22200000RY0'

COMMIT;