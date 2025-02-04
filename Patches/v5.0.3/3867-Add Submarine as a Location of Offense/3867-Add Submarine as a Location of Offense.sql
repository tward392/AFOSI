alter table t_dibrs_offense_location_type add report_as varchar2(10);

update t_dibrs_offense_location_type set report_as=code where report_as is null;
commit;

INSERT INTO T_DIBRS_OFFENSE_LOCATION_TYPE ( SID, CODE, DESCRIPTION, ACTIVE, SEQ, MULTI_ENTRIES_APPLIES, CREATE_ON, CREATE_BY, MODIFY_ON, MODIFY_BY, REPORT_AS ) VALUES ( '333168DJ', '28-1', 'Submarine', 'Y', 27.5, NULL,  TO_Date( '06/02/2011 08:48:26 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/02/2011 08:50:13 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward', '28'); 
COMMIT;