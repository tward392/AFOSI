CREATE OR REPLACE VIEW V_OSI_F_STATUS_HISTORY_LAST_DT
(FYLE, LAST_DATETIME)
AS 
select
  obj as fyle, MAX(create_on) as last_datetime
from T_OSI_STATUS_HISTORY
group by OBJ
/