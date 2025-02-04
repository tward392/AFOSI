SET DEFINE OFF;
Insert into T_OSI_AUTH_ROLE_PRIV
   (ROLE, PRIV, GRANTABLE, ENABLED, ALLOW_OR_DENY)
 Values
   ('77701QE3', '22201040', 'Y', 'Y', 'A');
Insert into T_OSI_AUTH_ROLE_PRIV
   (ROLE, PRIV, GRANTABLE, ENABLED, ALLOW_OR_DENY)
 Values
   ('77701QE3', '22201222', 'Y', 'Y', 'A');
-- This one exists in Prod already... was missing in Beta  wcc 1/10/11
--Insert into T_OSI_AUTH_ROLE_PRIV
--   (ROLE, PRIV, GRANTABLE, ENABLED, ALLOW_OR_DENY)
-- Values
--   ('77701QE3', '22200ZNE', 'Y', 'Y', 'A');
COMMIT;
