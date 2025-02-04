DECLARE 
  X NUMBER;
BEGIN
    SYS.DBMS_JOB.SUBMIT
        (job             => X,
         What            => 'DECLARE
                        BEGIN 
                          DELETE FROM WWV_FLOW_FILE_OBJECTS$ WHERE FLOW_ID = 0 and CREATED_ON < (SYSDATE-30);
                        END;',
         -- Code to be executed.
         next_date       => to_date('02/18/2011 06:00:00', 'mm/dd/yyyy hh24:mi:ss'),
         interval        => 'TRUNC(SYSDATE+7)+23/24',
         no_parse        => FALSE);
    dbms_output.put_line(to_char(X));
    COMMIT;
END;