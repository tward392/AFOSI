delete from t_osi_address a
where 
a.ADDRESS_TYPE = '22200000EI9'
AND a.SID IN (select b.new_sid from t_osi_migration b where b.type = 'UNIT_ADDRESS')