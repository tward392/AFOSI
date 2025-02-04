set define off;

CREATE TABLE WEBI2MS.T_OSI_MENU
(
  ID            VARCHAR2(20 BYTE),
  DESCRIPTION   VARCHAR2(100 BYTE),
  COMMAND       VARCHAR2(200 BYTE),
  PARENT_ID     VARCHAR2(20 BYTE),
  ICON          VARCHAR2(100 BYTE),
  SEQ           NUMBER,
  ACTIVE        VARCHAR2(1 BYTE)                DEFAULT 'Y',
  LAST_CHILD    VARCHAR2(1 BYTE)                DEFAULT 'N',
  DOUBLE_CLOSE  VARCHAR2(1 BYTE)                DEFAULT 'N'
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


CREATE UNIQUE INDEX WEBI2MS.PK_T_OSI_MENU ON WEBI2MS.T_OSI_MENU
(ID)
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


CREATE INDEX WEBI2MS.T_OSI_MENU_PARENT_ID ON WEBI2MS.T_OSI_MENU
(PARENT_ID)
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


CREATE OR REPLACE TRIGGER WEBI2MS.NEW_SEQ
BEFORE INSERT
ON WEBI2MS.T_OSI_MENU
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
WHEN (
NEW.SEQ IS NULL
      )
BEGIN

    SELECT MAX(SEQ)+1 INTO :NEW.SEQ FROM T_OSI_MENU;
    
END;
/
SHOW ERRORS;



ALTER TABLE WEBI2MS.T_OSI_MENU ADD (
  CONSTRAINT PK_T_OSI_MENU
 PRIMARY KEY
 (ID)
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

Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CREATE', 'Create', NULL, NULL, '/i/themes/OSI/OSI_CREATE16.gif', 
    0, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_ACTIVITY', 'Activity', NULL, 'ID_CREATE', '/i/themes/OSI/Activity.gif', 
    1, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_INIT_NOTIF', 'Initial Notification', 'javascript:createActivityObject(21001,''ACT.INIT_NOTIF'');', 'ID_ACTIVITY', '/i/themes/OSI/InitialNotification.gif', 
    2, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_INTERVIEW', 'Interview', NULL, 'ID_ACTIVITY', '/i/themes/OSI/Interview.gif', 
    3, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SUBJECT_INTERVIEW', 'Subject Interview', 'javascript:createActivityObject(21001,''ACT.INTERVIEW.SUBJECT'');', 'ID_INTERVIEW', '/i/themes/OSI/InterviewSubject.gif', 
    4, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_VICTIM_INTERVIEW', 'Victim Interview', 'javascript:createActivityObject(21001,''ACT.INTERVIEW.VICTIM'');', 'ID_INTERVIEW', '/i/themes/OSI/InterviewVictim.gif', 
    5, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_WITNESS_INTERVIEW', 'Witness Interview', 'javascript:createActivityObject(21001,''ACT.INTERVIEW.WITNESS'');', 'ID_INTERVIEW', '/i/themes/OSI/InterviewWitness.gif', 
    6, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_GROUP_INTERVIEW', 'Group Interview', 'javascript:createActivityObject(21001,''ACT.INTERVIEW.GROUP'');', 'ID_INTERVIEW', '/i/themes/OSI/InterviewGroup.gif', 
    7, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SOURCE_MEET', 'Source Meet', 'javascript:createActivityObject(21001, ''ACT.SOURCE_MEET'');', 'ID_ACTIVITY', '/i/themes/OSI/SourceMeet.gif', 
    8, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SEARCH', 'Search', 'javascript:createActivityObject(21001, ''ACT.SEARCH'');', 'ID_ACTIVITY', '/i/themes/OSI/SearchActivity.gif', 
    9, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_BRIEFING', 'Briefing', 'javascript:createActivityObject(21001, ''ACT.BRIEFING'');', 'ID_ACTIVITY', '/i/themes/OSI/Briefing.gif', 
    10, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_LIAISON', 'Liaison', 'javascript:createActivityObject(21001, ''ACT.LIAISON'');', 'ID_ACTIVITY', '/i/themes/OSI/Liaison.gif', 
    11, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_MEDIA_ANALYSIS', 'Media Analysis', 'javascript:createActivityObject(21001, ''ACT.MEDIA_ANALYSIS'');', 'ID_ACTIVITY', '/i/themes/OSI/MediaAnalysis.gif', 
    12, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_COMP_INTRUSION', 'Computer Intrusion', 'javascript:createActivityObject(21001, ''ACT.COMP_INTRUSION'');', 'ID_ACTIVITY', '/i/themes/OSI/ComputerIntrusion.gif', 
    13, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CONSULTATION', 'Consultation', 'javascript:createActivityObject(21001, ''ACT.CONSULTATION.ACQUISITION'');', 'ID_ACTIVITY', '/i/themes/OSI/Consultation.gif', 
    14, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_COORDINATION', 'Coordination', 'javascript:createActivityObject(21001, ''ACT.COORDINATION.FORENSICS'');', 'ID_ACTIVITY', '/i/themes/OSI/Coordination.gif', 
    15, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_FINGERPRINT_MAN', 'Manual Fingerprint', 'javascript:createActivityObject(21001, ''ACT.FINGERPRINT.MANUAL'');', 'ID_ACTIVITY', '/i/themes/OSI/FingerPalmPrint.gif', 
    16, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_POLY_EXAM', 'Polygraph Exam', 'javascript:createActivityObject(21001, ''ACT.POLY_EXAM'');', 'ID_ACTIVITY', '/i/themes/OSI/PolyExam.gif', 
    17, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_DOC_REVIEW', 'Document Review', 'javascript:createActivityObject(21001, ''ACT.DOCUMENT_REVIEW'');', 'ID_ACTIVITY', '/i/themes/OSI/DocumentReview.gif', 
    18, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_LERC', 'Law Enforcement Records Check', 'javascript:createActivityObject(21001, ''ACT.RECORDS_CHECK'');', 'ID_ACTIVITY', '/i/themes/OSI/LawEnforcementRecordsCheck.gif', 
    19, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SAR', 'Suspicious Activity Report', 'javascript:createActivityObject(21001, ''ACT.SUSPACT_REPORT'');', 'ID_ACTIVITY', '/i/themes/OSI/SuspicioiusActivityReport.gif', 
    20, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SURVEILLANCE', 'Surveillance', 'javascript:createActivityObject(21001, ''ACT.SURVEILLANCE'');', 'ID_ACTIVITY', '/i/themes/OSI/Surveillance.gif', 
    21, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_EXCEPTION', 'Exception', 'javascript:createActivityObject(21001, ''ACT.EXCEPTION'');', 'ID_ACTIVITY', '/i/themes/OSI/ExceptionActivity.gif', 
    22, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CASE_REVIEW', 'HQ Case Review', 'javascript:createActivityObject(21001, ''ACT.CC_REVIEW'');', 'ID_CASE_REVIEWS', '/i/themes/OSI/HQCaseReview.gif', 
    25, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_OPEN_CASE_REVIEW', 'HQ Open Case Review', 'javascript:createActivityObject(21001, ''ACT.OC_REVIEW'');', 'ID_CASE_REVIEWS', '/i/themes/OSI/HQCaseReview.gif', 
    26, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_AV_SUPPORT', 'AV Support', 'javascript:createActivityObject(21001, ''ACT.AV_SUPPORT'');', 'ID_ACTIVITY', '/i/themes/OSI/AVSupport.gif', 
    27, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_KFAT', 'Case File Assessment Tool (KFAT)', 'javascript:createActivityObject(21001, ''ACT.KFAT'');', 'ID_CASE_REVIEWS', '/i/themes/OSI/HQCaseReview.gif', 
    24, 'N', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_THRTAIRMAN', 'Threatened Airmen Support', 'javascript:createObject(11000,''FILE.GEN.THRTAIRMANSUPP'');', 'ID_SERVICE', '/i/themes/OSI/Generic.gif', 
    36, 'N', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_UNDRCVROP', 'Undercover Operations', 'javascript:createObject(11000,''FILE.GEN.UNDRCVROP'');', 'ID_SUPPORT', '/i/themes/OSI/Generic.gif', 
    45, 'N', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CASE_REVIEWS', 'Case Reviews', NULL, 'ID_ACTIVITY', '/i/themes/OSI/HQCaseReview.gif', 
    23, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_INVESTIGATIVE', 'Investigative File', NULL, 'ID_CREATE', '/i/themes/OSI/Investigations.gif', 
    28, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_INFORMATIONAL', 'Informational', 'javascript:createObject(11100,''FILE.INV.INFO'');', 'ID_INVESTIGATIVE', '/i/themes/OSI/Informational.gif', 
    29, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_DEVELOPMENTAL', 'Developmental', 'javascript:createObject(11100,''FILE.INV.DEV'');', 'ID_INVESTIGATIVE', '/i/themes/OSI/Developmental.gif', 
    30, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CASE', 'Case', 'javascript:createObject(11100,''FILE.INV.CASE'');', 'ID_INVESTIGATIVE', '/i/themes/OSI/Case.gif', 
    31, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_DCII', 'DCII Indexing File', 'javascript:createObject(11600,''FILE.SFS'');', 'ID_INVESTIGATIVE', '/i/themes/OSI/SFS.gif', 
    32, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SERVICE', 'Service File', NULL, 'ID_CREATE', '/i/themes/OSI/Service.gif', 
    33, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_AAPP', 'AFOSI Applicant File', 'javascript:createObject(11200,''FILE.AAPP'');', 'ID_SERVICE', '/i/themes/OSI/AgentApplication.gif', 
    34, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_AANDP', 'Analysis and Production', 'javascript:createObject(11000,''FILE.GEN.ANP'');', 'ID_SERVICE', '/i/themes/OSI/AandP.gif', 
    35, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_FPS', 'Force Protection Services', NULL, 'ID_SERVICE', '/i/themes/OSI/Folder256.gif', 
    37, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_PSO', 'PSO', 'javascript:createObject(11400,''FILE.PSO'');', 'ID_FPS', '/i/themes/OSI/PSO.gif', 
    38, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CISERVICES', 'Counterintelligence Services', NULL, 'ID_SERVICE', '/i/themes/OSI/Folder256.gif', 
    39, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CSP', 'CSP', 'javascript:createObject(11500,''FILE.POLY_FILE.SEC'');', 'ID_CISERVICES', '/i/themes/OSI/csp.gif', 
    40, 'Y', 'Y', 'Y');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SUPPORT', 'Support File', NULL, 'ID_CREATE', '/i/themes/OSI/Support.gif', 
    41, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CRIMPOLY', 'Criminal Polygraph', 'javascript:createObject(11500,''FILE.POLY_FILE.CRIM'');', 'ID_SUPPORT', '/i/themes/OSI/CriminalPolygraph.gif', 
    42, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_TECHSURV', 'Tech Surveillance', 'javascript:createObject(11000,''FILE.GEN.TECHSURV'');', 'ID_SUPPORT', '/i/themes/OSI/Generic.gif', 
    43, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SOURCEDEV', 'Source Development', 'javascript:createObject(11000,''FILE.GEN.SRCDEV'');', 'ID_SUPPORT', '/i/themes/OSI/Generic.gif', 
    44, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_UNDRCVROPSUPP', 'Undercover Operations Support', 'javascript:createObject(11000,''FILE.GEN.UNDRCVROPSUPP'');', 'ID_SUPPORT', '/i/themes/OSI/Generic.gif', 
    46, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_MANAGEMENT', 'Management', NULL, 'ID_CREATE', '/i/themes/OSI/Management.gif', 
    47, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SOURCE', 'Source', 'javascript:createObject(11300, ''FILE.SOURCE'');', 'ID_MANAGEMENT', '/i/themes/OSI/Source.gif', 
    48, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_PERSONNEL', 'Personnel', 'javascript:createObject(30400,''PERSONNEL'');', 'ID_MANAGEMENT', '/i/themes/OSI/Personnel.gif', 
    49, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_UNIT', 'Unit', 'javascript:createObject(30300,''UNIT'');', 'ID_MANAGEMENT', '/i/themes/OSI/Unit.gif', 
    50, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_TARGET', 'Target Management', 'javascript:createObject(11000,''FILE.GEN.TARGETMGMT'');', 'ID_MANAGEMENT', '/i/themes/OSI/TargetManagement.gif', 
    51, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_PARTICIPANT', 'Participant', NULL, 'ID_CREATE', '/i/themes/OSI/Individual.gif', 
    52, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_INDIVIDUAL', 'Individual', 'javascript:createObject(30000,''PART.INDIV'');', 'ID_PARTICIPANT', '/i/themes/OSI/Individual.gif', 
    53, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_COMPANY', 'Company', 'javascript:createObject(30100,''PART.NONINDIV.COMP'');', 'ID_PARTICIPANT', '/i/themes/OSI/Company.gif', 
    54, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_ORGANIZATION', 'Organization', 'javascript:createObject(30100,''PART.NONINDIV.ORG'');', 'ID_PARTICIPANT', '/i/themes/OSI/Organization.gif', 
    55, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_PROGRAM', 'Program', 'javascript:createObject(30100,''PART.NONINDIV.PROG'');', 'ID_PARTICIPANT', '/i/themes/OSI/Program.gif', 
    56, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_EFUNDS', 'E-Funds', NULL, 'ID_CREATE', '/i/themes/OSI/CFunds.gif', 
    57, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_EFUNDS_ADV', 'Advance', 'javascript:createObject(30600,''CFUNDS_ADV'');', 'ID_EFUNDS', '/i/themes/OSI/CFundsAdvance.gif', 
    58, 'Y', 'Y', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_WEBLINKS', 'Web Links', NULL, NULL, '/i/themes/OSI/link16.gif', 
    59, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_EFMS', 'E-Funds Management System', 'javascript:newWindow({page:999,name:''CFunds''});', 'ID_WEBLINKS', '/i/themes/OSI/CFMS.gif', 
    60, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_FEEDBACK', 'Submit Feedback', 'javascript:void(window.open(''http://hqcuiweb1.ogn.af.mil/i2ms/webi2ms%20suggestion.htm'',''_blank''));', 'ID_WEBLINKS', '/i/themes/OSI/I2MSLogo.gif', 
    67, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_CAGEDUNSSEARCH', 'Cage/Duns Code Search', 'javascript:void(window.open(''http://www.dlis.dla.mil/BINCS/begin_search.aspx'',''_blank''));', 'ID_WEBLINKS', '/i/themes/OSI/WebPage.gif', 
    62, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_OSILINK', 'OSILink', 'javascript:void(window.open(''http://hqcuiosilapp.ogn.af.mil'',''_blank''));', 'ID_WEBLINKS', '/i/themes/OSI/OSILink.gif', 
    64, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_I2MSWEBSITE', 'I2MS Web Site', 'javascript:void(window.open(''http://hqcuiweb1.ogn.af.mil/i2ms/'',''_blank''));', 'ID_WEBLINKS', '/i/themes/OSI/I2MS.gif', 
    65, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_OSILINKI2MS', 'OSILink - KC 71 - I2MS', 'javascript:void(window.open(''http://hqcuiosilapp.ogn.af.mil/osilink/llisapi.dll?func=ll&objId=1133167&objAction=browse&sort=name'',''_blank''));', 'ID_WEBLINKS', '/i/themes/OSI/OSILink.gif', 
    66, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_FULLTEXTSEARCH', 'Full Text Search', 'javascript:newWindow({page:1080});', 'ID_WEBLINKS', '/i/themes/OSI/FullTextSearchSmall.gif', 
    61, 'Y', 'N', 'N');
Insert into WEBI2MS.T_OSI_MENU
   (ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, 
    SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE)
 Values
   ('ID_SMARTOSI', 'Smart OSI', 'javascript:void(window.open(''http://hqcuitabisprod/tabisprod'',''_blank''));', 'ID_WEBLINKS', '/i/themes/OSI/SmartOSI.gif', 
    63, 'Y', 'N', 'N');
COMMIT;

ALTER TABLE WEBI2MS.T_OSI_MENU ADD (
  CONSTRAINT T_OSI_MENU_R01 
 FOREIGN KEY (PARENT_ID) 
 REFERENCES WEBI2MS.T_OSI_MENU (ID));