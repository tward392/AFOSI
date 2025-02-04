INSERT INTO T_OSI_AUTH_ACTION_TYPE ( SID, CODE, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33319CM5', 'GRANT_SQANLU', 'GRANT: The Squadron Analyst Role in a Unit', 'timothy.ward',  TO_Date( '10/23/2012 11:34:23 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/23/2012 11:34:23 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;







INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '33319CM6', '222000005HF', '33319CM5', 'timothy.ward',  TO_Date( '10/23/2012 11:35:40 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/23/2012 11:35:40 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'GRANT: The Squadron Analyst Role in a Unit'); 
COMMIT;






INSERT INTO T_OSI_AUTH_ROLE ( SID, CODE, DESCRIPTION, KEEP_ON_TRANSFER, COMMON_GRANT, ALLOW_TOP, MAX_PER_SQD, MAX_PER_RGN, MAX_PER_UNIT, MAX_PER_HQ, AGENT_ONLY, GRANT_PRIV, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, COMPLETE_DESC, RPT_DESCR, RPT_PRIORITY, RPT_SIGNATURE ) VALUES ( '33319CM4', 'SQANL', 'Squadron Analyst', NULL, NULL, '1', 99999, 0, 0, 0, '0', '33319CM6', 'timothy.ward',  TO_Date( '10/23/2012 11:32:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/23/2012 11:36:36 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'SQANL: Squadron Analyst', NULL, NULL, NULL); 
COMMIT;






--------------------
--- WEBI2MS BETA ---
--------------------
---INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV,GRANTABLE,ENABLED,ALLOW_OR_DENY) 
---  SELECT '33319CM4',PRIV,GRANTABLE,ENABLED,ALLOW_OR_DENY FROM T_OSI_AUTH_ROLE_PRIV WHERE ROLE='33305C1S';

--------------------------
--- WEBI2MS PRODUCTION ---
--------------------------
INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV,GRANTABLE,ENABLED,ALLOW_OR_DENY)
  SELECT '33319CM4',PRIV,GRANTABLE,ENABLED,ALLOW_OR_DENY FROM T_OSI_AUTH_ROLE_PRIV WHERE ROLE='77701QEB';

COMMIT;










-------------------------------------------------------
-------------------------------------------------------
--- GIVE I2MS PMO ROLE THE GRANT PRIVILEGE FOR THIS ---
-------------------------------------------------------
-------------------------------------------------------

--------------------
--- WEBI2MS BETA ---
--------------------
--INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV,GRANTABLE,ENABLED,ALLOW_OR_DENY) VALUES ('33305C2S','33319CM6','Y','Y','A');

--------------------------
--- WEBI2MS PRODUCTION ---
--------------------------
INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV,GRANTABLE,ENABLED,ALLOW_OR_DENY) VALUES ('77701QFB','33319CM6','Y','Y','A');

COMMIT;

