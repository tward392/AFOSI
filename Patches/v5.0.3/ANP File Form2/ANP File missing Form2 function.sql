update t_osi_report_type set package_function = 'OSI_FILE.RPT_GENERATE_FORM2' where sid = '22200000EFH';
update t_osi_report_type set package_function = 'OSI_FILE.RPT_GENERATE_30256' where sid = '22200000EFF';
update t_osi_report_type set package_function = 'OSI_FILE.RPT_GENERATE_30252' where sid = '22200000EFE';
COMMIT;
