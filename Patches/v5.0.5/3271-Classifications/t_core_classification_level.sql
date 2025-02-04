alter table t_core_classification_level add active varchar2(1) default 'Y';

update t_core_classification_level set active='N' where code='TS';

commit;