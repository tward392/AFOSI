---IG ROLE

INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'ACT.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'FLE.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'SRC.NOWN', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'SRC.ALLTAB', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'FLE.ACA', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'SRC.ACC', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'AAPP.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'AAM.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'EMM.CUST', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'EMM.IG', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'AAPP.ACA', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'AAAP15.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'AAAP25.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'IGAGT', 'AAAP35.OVR', 0, 1); 
COMMIT;

---IG Manager Role
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'HQIG', 'ACT.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'HQIG', 'FLE.OVR', 0, 1); 
INSERT INTO T_ROLE_PRIVILEGE ( ROLE, PRIVILEGE, GRANTABLE, ENABLED ) VALUES ( 'HQIG', 'SRC.NOWN', 0, 1); 
COMMIT;


