update t_dibrs_offense_type set TYPE_WEAPON_USED_APPLIES='Y', TYPE_INJURY_APPLIES='Y'
  where nibrs_code='210';
commit;