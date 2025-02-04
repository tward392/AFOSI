/*
--- Beta ---
insert into t_osi_auth_role_priv (role,priv) select r.sid,p.sid from t_osi_auth_priv p,t_core_obj_type t,t_osi_auth_action_type at,t_osi_auth_role r where p.action=at.sid and p.OBJ_TYPE=t.sid and t.code='FILE.SOURCE' and at.code='OVERRIDE' and r.CODE IN ('BRANCH','HQANL','HQCOMMAND','HQFILE','HQIG','HQPOLY','IMACC','IMASUPER','RGNANL','RGNCOMMAND','RGNIMA','RGNSUPER','RGNVC','SQDCOMMAND','SUPER');
commit;
*/

--- Production ---
insert into t_osi_auth_role_priv (role,priv) select r.sid,p.sid from t_osi_auth_priv p,t_core_obj_type t,t_osi_auth_action_type at,t_osi_auth_role r where p.action=at.sid and p.OBJ_TYPE=t.sid and t.code='FILE.SOURCE' and at.code='OVERRIDE' and r.CODE IN ('BRANCH','COMMANDER','HQANL','HQCOMMAND','HQFILE','HQIG','HQPOLY','IMACC','IMASUPER','RGNANL','RGNCOMMAND','RGNIMA','RGNSUPER','RGNVC','SQDCOMMAND','SUPER');
commit;
