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
