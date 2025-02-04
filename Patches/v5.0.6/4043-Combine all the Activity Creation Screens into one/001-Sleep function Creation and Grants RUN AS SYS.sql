/*************************************************
************************************************** 
************************************************** 
******************* RUN AS SYS ******************* 
************************************************** 
************************************************** 
**************************************************/
GRANT EXECUTE ON DBMS_LOCK TO IOL;

-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE function iol.sleep (p_time in number := 10)
return number
is
begin
-- Testing sleep 27 April 12 ... wcc
DBMS_LOCK.SLEEP(p_time);
return 1;
end;
/


GRANT EXECUTE ON  IOL.SLEEP TO WEBI2MS;






