------------------------------------------------
--- Create UPDATE for CFUNDS_ADV Object Type ---
------------------------------------------------
INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '333167WR', '22200000GJY', '2220103Y', 'timothy.ward',  TO_Date( '06/01/2011 07:13:34 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/01/2011 07:13:34 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'CFunds Advance UPDATE'); 
COMMIT;

INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV) SELECT R.SID,P.SID FROM
T_OSI_AUTH_ROLE R,T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A 
WHERE R.CODE IN ('FRNNATL','UFRNNATL') 
  AND T.CODE='CFUNDS_ADV' AND T.SID=P.OBJ_TYPE AND A.CODE='UPDATE' AND A.SID=P.ACTION;

COMMIT;


------------------------------------------------
--- Create UPDATE for CFUNDS_EXP Object Type ---
------------------------------------------------
INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '333167WX', '222000008H4', '2220103Y', 'timothy.ward',  TO_Date( '06/01/2011 07:32:04 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/01/2011 07:32:04 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'CFunds Expense UPDATE'); 
COMMIT;

INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV) SELECT R.SID,P.SID FROM
T_OSI_AUTH_ROLE R,T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A 
WHERE R.CODE IN ('FRNNATL','UFRNNATL') 
  AND T.CODE='CFUNDS_EXP' AND T.SID=P.OBJ_TYPE AND A.CODE='UPDATE' AND A.SID=P.ACTION;

COMMIT;


------------------------------------------------
--- Remove the ALL Files Desktop View Access ---
------------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE' AND T.SID=P.OBJ_TYPE AND A.CODE='DESKTOP' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;

--------------------------------------------------------------
--- Remove the Tech Surveillance Files Desktop View Access ---
--------------------------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE.GEN.TECHSURV' AND T.SID=P.OBJ_TYPE AND A.CODE='DESKTOP' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;


---------------------------------------------------------------
--- Remove the Source Development Files Desktop View Access ---
---------------------------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE.GEN.SRCDEV' AND T.SID=P.OBJ_TYPE AND A.CODE='DESKTOP' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;


------------------------------------------------------------------
--- Remove the Undercover Operations Files Desktop View Access ---
------------------------------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE.GEN.UNDRCVROPSUPP' AND T.SID=P.OBJ_TYPE AND A.CODE='DESKTOP' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;


------------------------------------------------
--- Remove the A&P Files Desktop View Access ---
------------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE.GEN.ANP' AND T.SID=P.OBJ_TYPE AND A.CODE='DESKTOP' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;

------------------------------------------------
--- Remove the PSO Files Desktop View Access ---
------------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE.PSO' AND T.SID=P.OBJ_TYPE AND A.CODE='DESKTOP' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;


--------------------------------------------
--- Remove the ANP File Create Privilege ---
--------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE.GEN.ANP' AND T.SID=P.OBJ_TYPE AND A.CODE='CREATE' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;

------------------------------------------------------
--- Remove the DCII Indexing File Create Privilege ---
------------------------------------------------------
DELETE FROM T_OSI_AUTH_ROLE_PRIV WHERE SID IN (SELECT RP.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A,T_OSI_AUTH_ROLE_PRIV RP,T_OSI_AUTH_ROLE R WHERE  T.CODE='FILE.SFS' AND T.SID=P.OBJ_TYPE AND A.CODE='CREATE' AND A.SID=P.ACTION AND RP.PRIV=P.SID AND RP.ROLE=R.SID AND R.CODE IN ('FRNNATL','UFRNNATL'));
COMMIT;






----------------------------------------------
----------------------------------------------
------------------ Testing -------------------
----------------------------------------------
----------------------------------------------
--SELECT R.SID FROM T_OSI_AUTH_ROLE R WHERE R.CODE IN ('FRNNATL','UFRNNATL')

--SELECT P.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A WHERE  T.CODE='CFUNDS_ADV' AND T.SID=P.OBJ_TYPE AND A.CODE='UPDATE' AND A.SID=P.ACTION;

---SELECT P.SID FROM T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A WHERE  T.CODE='CFUNDS_ADV' ' AND T.SID=P.OBJ_TYPE AND A.CODE='UPDATE' AND A.SID=P.ACTION;
--SELECT CODE FROM T_OSI_AUTH_ROLE_PRIV P,T_OSI_AUTH_ROLE R WHERE PRIV='22200000OYW' AND P.ROLE=R.SID ORDER BY CODE

--select code from t_osi_auth_role_priv p,t_osi_auth_role r where priv='22200000OYV' and p.role=r.sid ORDER BY CODE;