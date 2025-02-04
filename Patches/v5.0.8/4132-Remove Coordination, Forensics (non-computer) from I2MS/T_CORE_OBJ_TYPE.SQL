alter table t_core_obj_type add active varchar2(1) default 'Y';

update t_core_obj_type set active='N' where code='ACT.COORDINATION.FORENSICS';
commit;