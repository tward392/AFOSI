update t_core_obj_type set description=replace(description,'CFunds','EFunds') where description like 'CFunds%';
commit;