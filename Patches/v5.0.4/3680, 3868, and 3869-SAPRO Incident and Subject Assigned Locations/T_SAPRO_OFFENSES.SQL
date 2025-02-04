
CREATE TABLE WEBI2MS.T_SAPRO_OFFENSES
(
  OFFENSE_SID   VARCHAR2(20 BYTE)               NOT NULL,
  OFFENSE_CODE  VARCHAR2(10 BYTE)               NOT NULL
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


CREATE UNIQUE INDEX WEBI2MS.PK_SAPRO_OFFENSES ON WEBI2MS.T_SAPRO_OFFENSES
(OFFENSE_SID)
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


ALTER TABLE WEBI2MS.T_SAPRO_OFFENSES ADD (
  CONSTRAINT PK_SAPRO_OFFENSES
 PRIMARY KEY
 (OFFENSE_SID)
    USING INDEX 
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
               ));


ALTER TABLE WEBI2MS.T_SAPRO_OFFENSES ADD (
  CONSTRAINT FK_OFFENSE_SID 
 FOREIGN KEY (OFFENSE_SID) 
 REFERENCES WEBI2MS.T_DIBRS_OFFENSE_TYPE (SID));




INSERT INTO T_SAPRO_OFFENSES (OFFENSE_SID,OFFENSE_CODE) SELECT SID,CODE FROM T_DIBRS_OFFENSE_TYPE WHERE CODE like '120-A%' 
                                                                                                     OR CODE like '120-C%' 
                                                                                                     OR CODE like '120-E%' 
                                                                                                     OR CODE like '120-H%'
                                                                                                     OR CODE like '120-M%'
                                                                                                     OR CODE like '125-A%'
                                                                                                     OR CODE like '134-C1%';
COMMIT;