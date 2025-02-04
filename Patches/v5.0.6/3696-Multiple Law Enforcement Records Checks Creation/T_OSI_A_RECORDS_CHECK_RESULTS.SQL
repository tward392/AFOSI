CREATE TABLE WEBI2MS.T_OSI_A_RECORDS_CHECK_RESULTS
(
  CODE               VARCHAR2(10 BYTE),
  DESCRIPTION        VARCHAR2(100 BYTE),
  DEFAULT_NARRATIVE  VARCHAR2(4000 BYTE),
  ACTIVE             VARCHAR2(1 BYTE)
);

CREATE UNIQUE INDEX WEBI2MS.PK_OSI_A_RC_M_CODE ON WEBI2MS.T_OSI_A_RECORDS_CHECK_RESULTS
(CODE);

ALTER TABLE WEBI2MS.T_OSI_A_RECORDS_CHECK_RESULTS ADD (
  CONSTRAINT PK_OSI_A_RC_M_CODE
 PRIMARY KEY
 (CODE));

Insert into WEBI2MS.T_OSI_A_RECORDS_CHECK_RESULTS (CODE, DESCRIPTION, DEFAULT_NARRATIVE, ACTIVE) Values ('NOREC', 'No Record On File', 'A review of ~RECORD_TYPE~ records identifiable with SUBJECT disclosed nothing pertinent to this investigation.', 'Y');
Insert into WEBI2MS.T_OSI_A_RECORDS_CHECK_RESULTS (CODE, DESCRIPTION, DEFAULT_NARRATIVE, ACTIVE) Values ('NODEROG', 'No Derogatory Information', 'A review of ~RECORD_TYPE~ records identifiable with SUBJECT provided no derogatory information.', 'Y');
Insert into WEBI2MS.T_OSI_A_RECORDS_CHECK_RESULTS (CODE, DESCRIPTION, DEFAULT_NARRATIVE, ACTIVE) Values ('DEROGATORY', 'Derogatory Information', 'A review of ~RECORD_TYPE~ records identifiable with SUBJECT was done.  The review disclosed SUBJECT [[[[Derogatory Information HERE]]]]. ', 'Y');
COMMIT;