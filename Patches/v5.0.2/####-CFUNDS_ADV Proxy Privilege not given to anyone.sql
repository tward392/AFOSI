INSERT INTO T_OSI_AUTH_PRIV (OBJ_TYPE,ACTION) SELECT O.SID,A.SID FROM T_CORE_OBJ_TYPE O,T_OSI_AUTH_ACTION_TYPE A WHERE O.CODE='CFUNDS_ADV' AND A.CODE='CF_PROXY';
COMMIT;

INSERT INTO T_OSI_AUTH_ROLE_PRIV (GRANTABLE,ALLOW_OR_DENY,ROLE,PRIV) 
      SELECT 'Y','A',R.SID,P.SID 
        FROM T_OSI_AUTH_ROLE R,T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A
          WHERE R.CODE IN ('BRANCH',
                           'COMMANDER',
                           'HQCFUNDS',
                           'HQCOMMAND',
                           'HQPMO',
                           'IMACC',
                           'IMASUPER',
                           'RGNCFUNDS',
                           'RGNCOMMAND',
                           'RGNIMA',
                           'RGNSUPER',
                           'RGNVC',
                           'SQDCOMMAND',
                           'SUPER')
            AND T.CODE='CFUNDS_ADV' 
            AND T.SID=P.OBJ_TYPE 
            AND A.CODE='CF_PROXY' 
            AND A.SID=P.ACTION;

COMMIT;

INSERT INTO T_OSI_AUTH_ROLE_PRIV (GRANTABLE,ALLOW_OR_DENY,ROLE,PRIV) 
      SELECT 'N','A',R.SID,P.SID 
        FROM T_OSI_AUTH_ROLE R,T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A
          WHERE R.CODE IN ('CFCUST')
            AND T.CODE='CFUNDS_ADV' 
            AND T.SID=P.OBJ_TYPE 
            AND A.CODE='CF_PROXY' 
            AND A.SID=P.ACTION;
COMMIT;