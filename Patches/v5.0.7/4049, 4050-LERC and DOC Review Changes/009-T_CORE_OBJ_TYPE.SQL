update t_core_obj_type set image='SuspiciousActivityReport.ico' where image='SuspicioiusActivityReport.gif';
commit;

update t_core_obj_type set image='AVSupport.gif' where code='ACT.AV_SUPPORT';
commit;

update t_core_obj_type set image='CSP.gif' where code='FILE.POLY_FILE.SEC';
commit;

update t_core_obj_type set image='CriminalPolygraph.gif' where code='FILE.POLY_FILE.CRIM';
commit;


update t_core_obj_type set image='AandP.gif' where code='FILE.GEN.ANP';
commit;

update t_core_obj_type set image='Evidence.gif' where code='EMM';
commit;



update t_core_obj_type set image='SFS.gif' where code='FILE.SFS';
commit;
