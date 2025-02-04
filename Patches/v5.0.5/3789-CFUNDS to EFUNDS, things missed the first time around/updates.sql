update t_osi_notification_event_type set description=replace(description,'CFunds','EFunds')
  where description like '%CFunds%';
commit;


update t_osi_auth_priv set description=replace(description,'CFunds','EFunds') 
  where description like '%CFunds%';
commit;
update t_osi_auth_priv set description=replace(description,'C-Funds','E-Funds') 
  where description like '%C-Funds%';
commit;
update t_osi_auth_priv set description=replace(description,'C- Funds','E-Funds') 
  where description like '%C- Funds%';
commit;
update t_osi_auth_priv set description=replace(description,'CFEXP','EFEXP') 
  where description like '%CFEXP%';
commit;
update t_osi_auth_priv set description=replace(description,'CFLIM','EFLIM') 
  where description like '%CFLIM%';
commit;
update t_osi_auth_priv set description=replace(description,'CFADV','EFADV') 
  where description like '%CFADV%';
commit;
update t_osi_auth_priv set description=replace(description,'CFXFR','EFXFR') 
  where description like '%CFXFR%';
commit;
update t_osi_auth_priv set description=replace(description,'CFMFR','EFMFR') 
  where description like '%CFMFR%';
commit;
  
update t_osi_auth_role set description=replace(description,'CFunds','EFunds') 
  where description like '%CFunds%';
commit;
update t_osi_auth_role set description=replace(description,'C-Funds','E-Funds') 
  where description like '%C-Funds%';
commit;

update t_osi_auth_role set complete_desc=replace(complete_desc,'CFunds','EFunds') 
  where complete_desc like '%CFunds%';
commit;
update t_osi_auth_role set complete_desc=replace(complete_desc,'C-Funds','E-Funds') 
  where complete_desc like '%C-Funds%';
commit;
update t_osi_auth_role set complete_desc=replace(complete_desc,'CFUND','EFUND') 
  where complete_desc like '%CFUND%';
commit;
update t_osi_auth_role set complete_desc=replace(complete_desc,'CFCUST','EFCUST') 
  where complete_desc like '%CFCUST%';
commit;


update t_osi_auth_action_type set description=replace(description,'CFunds','EFunds') 
  where description like '%CFunds%';
commit;
update t_osi_auth_action_type set description=replace(description,'C-Funds','E-Funds') 
  where description like '%C-Funds%';
commit;
update t_osi_auth_action_type set description=replace(description,'C- Funds','E-Funds') 
  where description like '%C- Funds%';
commit;

  
  