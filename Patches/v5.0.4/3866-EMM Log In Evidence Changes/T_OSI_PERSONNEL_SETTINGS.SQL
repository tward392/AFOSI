
CREATE TABLE WEBI2MS.T_OSI_PERSONNEL_SETTINGS
(
  PERSONNEL      VARCHAR2(20 BYTE)              NOT NULL,
  SETTING_NAME   VARCHAR2(100 BYTE),
  SETTING_VALUE  VARCHAR2(4000 BYTE)
)
TABLESPACE I2MS
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


CREATE INDEX WEBI2MS.I$T_OSI_PERS_SETTINGS$NAME ON WEBI2MS.T_OSI_PERSONNEL_SETTINGS
(SETTING_NAME)
LOGGING
TABLESPACE I2MS
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


CREATE INDEX WEBI2MS.I$T_OSI_PERS_SET$PERSONNEL ON WEBI2MS.T_OSI_PERSONNEL_SETTINGS
(PERSONNEL)
LOGGING
TABLESPACE I2MS
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


ALTER TABLE WEBI2MS.T_OSI_PERSONNEL_SETTINGS ADD (
  CONSTRAINT FK$T_CORE_PERSONNEL$SID 
 FOREIGN KEY (PERSONNEL) 
 REFERENCES WEBI2MS.T_CORE_PERSONNEL (SID));