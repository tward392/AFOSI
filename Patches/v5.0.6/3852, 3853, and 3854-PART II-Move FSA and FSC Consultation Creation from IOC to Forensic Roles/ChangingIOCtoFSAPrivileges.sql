update t_osi_auth_role_priv rp set rp.ROLE=(select r.sid from t_osi_auth_role r where r.code='FORAGT') where rp.SID in (
select rp.sid from t_osi_auth_role r,
              t_osi_auth_role_priv rp,
              t_osi_auth_priv p 
where r.code='IOCAGENT' 
  and r.sid=rp.role 
  and p.sid=rp.priv 
  and (p.description like '%, FSA%' OR p.description like '%, FSC%'));
commit;

update t_osi_auth_role_priv rp set rp.ROLE=(select r.sid from t_osi_auth_role r where r.code='HQFOR') where rp.SID in (
select rp.sid from t_osi_auth_role r,
              t_osi_auth_role_priv rp,
              t_osi_auth_priv p 
where r.code='IOCMAN' 
  and r.sid=rp.role 
  and p.sid=rp.priv 
  and (p.description like '%, FSA%' OR p.description like '%, FSC%'));
COMMIT;  



INSERT INTO T_OSI_AUTH_ACTION_TYPE ( SID, CODE, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33318LGY', 'GRANT_IOCMAN', 'GRANT: The IOC Manager Role', 'timothy.ward',  TO_Date( '04/10/2012 01:19:23 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '04/10/2012 01:19:23 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '33318LGZ', '222000005HF', '33318LGY', 'timothy.ward',  TO_Date( '04/10/2012 01:20:31 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '04/10/2012 01:20:44 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'GRANT: The IOC Manager Role'); 
COMMIT;

insert into t_osi_auth_role_priv (role,priv) select r.sid,'33318LGZ' from t_osi_auth_role r where r.code='HQPMO';
commit;

update t_osi_auth_role set grant_priv='33318LGZ' where code='IOCMAN';
COMMIT;