
CREATE TABLE WEBI2MS.T_OSI_A_SURV_BRIEFED
(
  SID             VARCHAR2(20 BYTE)             DEFAULT NULL                  NOT NULL,
  SURVEILLANCE    VARCHAR2(20 BYTE)             NOT NULL,
  PERSON_BRIEFED  VARCHAR2(100 BYTE)            NOT NULL,
  CREATE_BY       VARCHAR2(100 BYTE),
  CREATE_ON       DATE,
  MODIFY_BY       VARCHAR2(100 BYTE),
  MODIFY_ON       DATE
);

CREATE UNIQUE INDEX WEBI2MS.PK_OSI_SURV_BRIEFED ON WEBI2MS.T_OSI_A_SURV_BRIEFED (SID);

CREATE INDEX WEBI2MS.I_OSI_SURV_BRIEFED_OBJ ON WEBI2MS.T_OSI_A_SURV_BRIEFED (SURVEILLANCE);


CREATE OR REPLACE TRIGGER WEBI2MS."OSI_SURV_BRIEFED_B_IU_TS" 
    before insert or update
    on T_OSI_A_SURV_BRIEFED
    for each row
declare
    v_who    varchar2(100);
    v_when   date;
begin
    v_who := core_context.personnel_name;

    if v_who is null then
        v_who := v('APP_USER');
    end if;

    if v_who is null then
        v_who := sys_context('USERENV', 'OS_USER');
    end if;

    if v_who is null then
        v_who := user;
    end if;

    v_when := sysdate;

    if inserting then
        :new.create_by := v_who;
        :new.create_on := v_when;
    end if;

    :new.modify_by := v_who;
    :new.modify_on := v_when;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER WEBI2MS."OSI_SURV_BRIEFED_B_I_SID" 
    before insert
    on T_OSI_A_SURV_BRIEFED
    for each row
begin
    if :new.sid is null then
        :new.sid := core_sidgen.next_sid;
    end if;
end;
/
SHOW ERRORS;



ALTER TABLE WEBI2MS.T_OSI_A_SURV_BRIEFED ADD (CONSTRAINT PK_OSI_SURV_BRIEFED PRIMARY KEY (SID));

ALTER TABLE WEBI2MS.T_OSI_A_SURV_BRIEFED ADD (CONSTRAINT FK_OSI_SURV_BRIEFED_OBJ FOREIGN KEY (SURVEILLANCE)  REFERENCES WEBI2MS.T_OSI_A_SURVEILLANCE (SID) ON DELETE CASCADE);

GRANT SELECT ON  WEBI2MS.T_OSI_A_SURV_BRIEFED TO MIS_ROLE;

