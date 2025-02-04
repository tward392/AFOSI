update t_cfunds_menu_items set name=replace(name,'C-Funds','E-Funds') where name like '%C-Funds%';
commit;

update t_cfunds_menu_items set name=replace(name,'CFMS','EFMS') where name like '%CFMS%';
commit;
