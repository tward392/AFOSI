-----------------------------------
--- Create the Create Privilege ---
-----------------------------------
INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '33319KFW', '2220116Y', '22200000LD5', 'timothy.ward',  TO_Date( '01/30/2013 10:52:58 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '01/30/2013 10:53:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Create Consultation, Technical Services Activity');
COMMIT;

--------------------------------------
--- Inserts for WebI2MS PRODUCTION ---
--------------------------------------
INSERT INTO T_OSI_AUTH_ROLE_PRIV ( SID, ROLE, PRIV, GRANTABLE, ENABLED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ALLOW_OR_DENY ) VALUES ( '33319KFX', '77701QEK', '33319KFW', 'N', 'Y', 'timothy.ward',  TO_Date( '01/30/2013 11:00:01 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '01/30/2013 11:00:01 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL); 
INSERT INTO T_OSI_AUTH_ROLE_PRIV ( SID, ROLE, PRIV, GRANTABLE, ENABLED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ALLOW_OR_DENY ) VALUES ( '33319KFY', '77701QER', '33319KFW', 'N', 'Y', 'timothy.ward',  TO_Date( '01/30/2013 11:00:13 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '01/30/2013 11:00:13 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL); 
COMMIT;




---------------------------------------
--- Get Privilege SID and Role SIDS ---
---------------------------------------
---SELECT P.SID AS PRIV,R.SID AS ROLE FROM T_OSI_AUTH_PRIV P,T_OSI_AUTH_ROLE R WHERE P.OBJ_TYPE IN (SELECT SID FROM T_CORE_OBJ_TYPE OT WHERE OT.CODE IN ('ACT.CONSULTATION.TECHNICAL')) AND R.CODE IN ('HQTECH','TECHAGT');


--------------------------------
--- Inserts for WebI2MS Beta ---
--------------------------------
---INSERT INTO T_OSI_AUTH_ROLE_PRIV ( SID, ROLE, PRIV, GRANTABLE, ENABLED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ALLOW_OR_DENY ) VALUES ( '33319KFX', '33305C28', '33319KFW', 'N', 'Y', 'timothy.ward',  TO_Date( '01/30/2013 11:00:01 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '01/30/2013 11:00:01 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL); 
---INSERT INTO T_OSI_AUTH_ROLE_PRIV ( SID, ROLE, PRIV, GRANTABLE, ENABLED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ALLOW_OR_DENY ) VALUES ( '33319KFY', '33305C21', '33319KFW', 'N', 'Y', 'timothy.ward',  TO_Date( '01/30/2013 11:00:13 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '01/30/2013 11:00:13 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL); 
---COMMIT;



UPDATE T_CORE_OBJ_TYPE SET DESCRIPTION='Consultation, Technical Services' WHERE CODE='ACT.CONSULTATION.TECHNICAL';
COMMIT;