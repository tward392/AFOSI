--277 

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'begin
OSI_ACT_LOOK_UPDATES.UP_TITLE;
OSI_ACT_LOOK_UPDATES.UP_CONUNIT;
OSI_ACT_LOOK_UPDATES.UP_LEAD;
OSI_ACT_LOOK_UPDATES.UP_NOLEAD;
OSI_ACT_LOOK_UPDATES.UP_LEADAGT;
OSI_ACT_LOOK_UPDATES.UP_COMPDATE;
OSI_ACT_LOOK_UPDATES.DEL_ACT;
OSI_ACT_LOOK_UPDATES.ADD_ACT;
OSI_ACT_LOOK_UPDATES.UP_APPROVED;
OSI_ACT_LOOK_UPDATES.UP_READY_FOR_REVIEW;
OSI_ACT_LOOK_UPDATES.UP_ACT_TYPE;
end;'
   ,next_date => to_date('26/11/2012 08:12:56','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'SYSDATE+2/1440 '
   ,no_parse  => FALSE
  );
END;
/


