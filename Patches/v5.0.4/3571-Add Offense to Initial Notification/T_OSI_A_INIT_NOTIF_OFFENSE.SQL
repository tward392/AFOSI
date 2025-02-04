
CREATE TABLE WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE
(
  SID        VARCHAR2(20 BYTE)                  NOT NULL,
  ACTIVITY   VARCHAR2(20 BYTE)                  NOT NULL,
  OFFENSE    VARCHAR2(20 BYTE)                  NOT NULL,
  PRIORITY   VARCHAR2(20 BYTE)                  NOT NULL,
  CREATE_BY  VARCHAR2(100 BYTE),
  CREATE_ON  DATE,
  MODIFY_BY  VARCHAR2(100 BYTE),
  MODIFY_ON  DATE
)
TABLESPACE I2MS_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE IS '[REF:N][ISOBJ:N][ABBREV:INVOFFNS]Associates Initial Notification Activities to DIBRS Offenses. Replaces T_OFFENSE.';

COMMENT ON COLUMN WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE.SID IS 'The unique system identification number.';

COMMENT ON COLUMN WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE.ACTIVITY IS 'The SID of the Initial Notification Activity that this Offense applies to.';

COMMENT ON COLUMN WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE.OFFENSE IS 'The Offense.';

COMMENT ON COLUMN WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE.PRIORITY IS 'The Offense Priority that indicates the priority of the offense.';


CREATE UNIQUE INDEX WEBI2MS.PK_OSI_INIT_NOTIF_OFFNS ON WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE
(SID)
LOGGING
TABLESPACE I2MS_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX WEBI2MS.UK_OSI_INIT_NOTIF_OFFNS ON WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE
(ACTIVITY, OFFENSE)
LOGGING
TABLESPACE I2MS_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX WEBI2MS.I_OSI_INIT_NOTIF_OFFNS_ACT ON WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE
(ACTIVITY)
LOGGING
TABLESPACE I2MS_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX WEBI2MS.I_OSI_INITOFFNS_PRIORITY ON WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE
(PRIORITY)
LOGGING
TABLESPACE I2MS_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER WEBI2MS."OSI_INITOFFNS_B_IUD_BUMP" 
    before insert or update or delete
    on T_OSI_A_INIT_NOTIF_OFFENSE
    referencing new as new old as old
    for each row
declare
    c_pipe           varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_TRIGGER';
    excep_mutating   exception;
    pragma exception_init(excep_mutating, -4091);
begin
    core_obj.bump(nvl(:new.activity, :old.activity));
exception
    when excep_mutating then
        core_logger.log_it(c_pipe, 'TRIGGER (OSI_INITOFFNS_B_IUD_BUMP): ' || sqlerrm);
    when others then
        raise;
end;
/
SHOW ERRORS;



CREATE OR REPLACE TRIGGER WEBI2MS."OSI_INITOFFNS_B_I_SID" 
    before insert on T_OSI_A_INIT_NOTIF_OFFENSE for each row
begin
    if :new.SID is null then
       :new.SID := Core_Sidgen.NEXT_SID;
    end if;
end;
/
SHOW ERRORS;



CREATE OR REPLACE TRIGGER WEBI2MS."OSI_INITOFFNS_B_IU_TS" 
    before insert or update
    on T_OSI_A_INIT_NOTIF_OFFENSE
    for each row
declare
    V_WHO   Varchar2(100);
    V_WHEN  Date;
begin
    V_WHO := Core_Context.PERSONNEL_NAME;
    if V_WHO is null then
        V_WHO := V('APP_USER');
    end if;
    if V_WHO is null then
        V_WHO := SYS_CONTEXT('USERENV', 'OS_USER');
    end if;
    if V_WHO is null then
        V_WHO := user;
    end if;
    V_WHEN := sysdate;
    if INSERTING then
        :new.CREATE_BY := V_WHO;
        :new.CREATE_ON := V_WHEN;
    end if;
    :new.MODIFY_BY := V_WHO;
    :new.MODIFY_ON := V_WHEN;
end;
/
SHOW ERRORS;



ALTER TABLE WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE ADD (
  CONSTRAINT PK_OSI_INITOFFNS
 PRIMARY KEY
 (SID));


ALTER TABLE WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE ADD (
  CONSTRAINT FK_OSI_INITOFFNS_INVESTIGATION 
 FOREIGN KEY (ACTIVITY) 
 REFERENCES WEBI2MS.T_OSI_A_INIT_NOTIFICATION (SID)
    ON DELETE CASCADE);

ALTER TABLE WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE ADD (
  CONSTRAINT FK_OSI_INITOFFNS_PRIORITY 
 FOREIGN KEY (PRIORITY) 
 REFERENCES WEBI2MS.T_OSI_REFERENCE (SID));

ALTER TABLE WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE ADD (
  CONSTRAINT FK_OSI_INITOFFNS_OFFENSE 
 FOREIGN KEY (OFFENSE) 
 REFERENCES WEBI2MS.T_DIBRS_OFFENSE_TYPE (SID));


GRANT SELECT ON  WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE TO MIS;

GRANT SELECT ON  WEBI2MS.T_OSI_A_INIT_NOTIF_OFFENSE TO MIS_ROLE;