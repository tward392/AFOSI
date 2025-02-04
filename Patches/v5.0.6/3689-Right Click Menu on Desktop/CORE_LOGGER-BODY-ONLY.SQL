set define off;

CREATE OR REPLACE PACKAGE BODY "CORE_LOGGER" as
/*
  CORE_LOGGER - Debug Logging functions.

  26-May-99 RWH/ESC Original version.
  --
  31-Aug-05 RWH     Adapted from legacy package (LOGGER).
                        Pragmas not needed in 10g.
  29-Mar-12 TJW     Added exception when others check incase PACK_MESSAGE 
                        buffer of 4096 is exceeded.
                        
*/
    procedure LOG_IT(
        pipe    in   varchar2,
        MSG     in   varchar2,
        TOUT    in   number := 5,
        PSIZE   in   number := 1000000) is
        STATUS   number;
    begin
        DBMS_PIPE.PACK_MESSAGE(sysdate);
        DBMS_PIPE.PACK_MESSAGE(MSG);
        STATUS := DBMS_PIPE.SEND_MESSAGE(pipe, TOUT, PSIZE);

        if STATUS != 0 then   -- try purging the pipe
            DBMS_PIPE.purge(pipe);
            DBMS_PIPE.RESET_BUFFER;
            DBMS_PIPE.PACK_MESSAGE(sysdate);
            DBMS_PIPE.PACK_MESSAGE(MSG);
            STATUS := DBMS_PIPE.SEND_MESSAGE(pipe, TOUT, PSIZE);
        end if;

        if STATUS != 0 then
            RAISE_APPLICATION_ERROR(-20200, 'ERROR: LOGGER.Log_It could not send message');
       end if;
    
    exception when others then

             DBMS_PIPE.RESET_BUFFER;
             DBMS_PIPE.PACK_MESSAGE(sysdate);
             DBMS_PIPE.PACK_MESSAGE('Error in CORE_LOGGER.Log_it, Last Messages was could not be written here! (' || sqlerrm || ')');
             STATUS := DBMS_PIPE.SEND_MESSAGE(pipe, TOUT, PSIZE);
    
    end LOG_IT;

    procedure DUMP_EM(pipe in varchar2, TOUT in number := 5, MAXOUT in number := 1000000) is
        TS       date;   -- timestamp
        MO       number          := MAXOUT;
        OSF      number          := 0;   -- output so far
        MSG      varchar2(30000);
        LINE     varchar2(31000);
        STATUS   number;

        procedure DUMP_MSG is
            FIRST_ONE   boolean       := true;
            MY_BUFF     varchar2(255);
        begin
            loop
                exit when LINE is null;
                MY_BUFF := substr(LINE, 1, 200);
                LINE := substr(LINE, 201);

                if FIRST_ONE then
                    FIRST_ONE := false;
                else
                    MY_BUFF := '       ' || MY_BUFF;
                end if;

                DBMS_OUTPUT.PUT_LINE(MY_BUFF);
                OSF := OSF + length(MY_BUFF);
            end loop;
        end;
    begin
        DBMS_OUTPUT.enable(1000000);

        if MO > 1000000 - 300 then
            MO := 1000000 - 300;
        end if;

        loop
            STATUS := DBMS_PIPE.RECEIVE_MESSAGE(pipe, TOUT);
            exit when STATUS = 1;
            DBMS_PIPE.UNPACK_MESSAGE(TS);
            DBMS_PIPE.UNPACK_MESSAGE(MSG);
            LINE := to_char(TS, 'dd-Mon-yy HH24:MI:SS') || ' ' || MSG;
            DUMP_MSG;

            if OSF >= MO then
                DBMS_OUTPUT.PUT_LINE('WARNING - Logger.dump reached max output. Rerun Logger.dump');
                exit;
            end if;
        end loop;
    end DUMP_EM;

    procedure LOAD_TEST(pipe in varchar2, LINES in number, PSIZE in number := 1000000) is
    begin
        for I in 1 .. LINES
        loop
            LOG_IT(pipe, 'This is line ' || I, 10, PSIZE);
        end loop;
    end LOAD_TEST;
end CORE_LOGGER;
/



