update t_core_config set description='Default Classification to Use for Printing of Form_2A, Form_2B, and Form_2C (If no classification is specified).'
  where code='OSI.DEFAULT_CLASS';
COMMIT;

INSERT INTO T_CORE_CONFIG ( SID, CODE, SETTING, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333183E5', 'OSI.DEFAULT_REPORT_CLASS', 'FOR OFFICIAL USE ONLY', 'Default classification for MOST reports.', 'timothy.ward',  TO_Date( '10/20/2011 07:28:09 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/20/2011 07:31:10 AM', 'MM/DD/YYYY HH:MI:SS AM'));
COMMIT;