CREATE OR REPLACE VIEW V_OSI_FILE_RELATION_1
(THIS_FILE, THAT_FILE, MODIFY_BY, MODIFY_ON)
AS 
select
  file_a as this_file,
  file_b as that_file,
  modify_by,
  modify_on
from
  T_OSI_ASSOC_FLE_FLE
union
select
  file_b as this_file,
  file_a as that_file,
  modify_by,
  modify_on
from
  T_OSI_ASSOC_FLE_FLE
/