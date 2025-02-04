update t_core_obj_type set description='DCII Indexing File' where code='FILE.SFS';
commit;

update t_osi_obj_type set default_title='DCII Indexing File: ~ID~' where sid in (select sid from t_core_obj_type where code='FILE.SFS');
commit;

update t_osi_file set title=replace(title,'SFS Investigative File','DCII Indexing File') where title like 'SFS Investigative File%';
commit;