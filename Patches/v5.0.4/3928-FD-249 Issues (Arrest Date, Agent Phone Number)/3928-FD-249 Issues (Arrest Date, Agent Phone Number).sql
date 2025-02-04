CREATE OR REPLACE FUNCTION "GET_ARREST_DATE" ( pActOrFileSID IN VARCHAR2, IsAct IN VARCHAR2 := 'N' ) RETURN VARCHAR2 IS

     /**********************************************************************************************
        Name:     get_arrest_date
        Purpose:  Provides arrest date for SendIAIFS.exe and WebI2MS display/report
                  of the FD-249.

        Revisions:
         Date        Author          Description
         ----------  --------------  -------------------------------------------------------------
         20-May-2011 Tim Ward        CR#03858 - Arrest Date problems with Sending IAFIS Requests.
                                      Changed GET_ARREST_DATE to return a string instead of
                                       a date, so the SendRequests.exe works correctly, but
                                       that broke the FD-249 screen in WebI2MS.  Also had to change
                                       OSI_IAFIS.GetOffenseArrestDates and .OffensesSQL.
         24-Aug-2011 Tim Ward        CR#3928 - Arrest Date Incorrect
                                                                                                         
     **********************************************************************************************/
     v_rtn DATE;
     FileSid VARCHAR2(20);
     sPersonSID VARCHAR2(20);
  
BEGIN
     /***************************************************************** 
     *  Currently used by frmActFingerprint.frm and SendRequests.exe  * 
     *****************************************************************/  
     Core_Logger.log_it('I2MS', 'GET_ARREST_DATE(' || pActOrFileSID || ',' || IsAct || ')');

     IF IsAct = 'Y' THEN
       
       BEGIN
            SELECT F.SID INTO FileSID FROM T_OSI_FILE F,T_OSI_ASSOC_FLE_ACT C WHERE C.FILE_SID=F.SID AND C.ACTIVITY_SID=pActOrFileSID;

       EXCEPTION
             WHEN OTHERS THEN NULL;
    
       END;
    
     ELSE
    
       FileSid := pActOrFileSID;
        
     END IF;
  
     Core_Logger.log_it('I2MS', 'GET_ARREST_DATE, FileSID=' || FileSid);
     
     -----------------------------------------------------
     --- Get the PERSON sid associated to the Activity ---
     -----------------------------------------------------
     BEGIN

          SELECT PARTICIPANT INTO sPersonSID 
            FROM T_OSI_PARTIC_INVOLVEMENT I,T_OSI_PARTICIPANT_VERSION V 
           WHERE I.OBJ=pActOrFileSID AND I.PARTICIPANT_VERSION=V.SID;
    
     EXCEPTION
              WHEN NO_DATA_FOUND THEN NULL;
     END;

     Core_Logger.log_it('I2MS', 'GET_ARREST_DATE, sPersonSID=' || sPersonSID);

     ----------------------------------------------------------
     --- Attempt to Get the Subject Interview Activity Date --- 
     ----------------------------------------------------------
     BEGIN

             SELECT MIN(ACTIVITY_DATE) INTO v_rtn 
               FROM 
                   T_OSI_PARTIC_INVOLVEMENT I,
                   T_OSI_PARTICIPANT_VERSION V,
                   T_OSI_ASSOC_FLE_ACT C,
                   T_OSI_ACTIVITY A,
                   T_CORE_OBJ O,
                   T_CORE_OBJ_TYPE OT 
              WHERE 
                   I.OBJ=C.ACTIVITY_SID AND 
                   I.PARTICIPANT_VERSION=V.SID AND 
                   V.PARTICIPANT=sPersonSID AND
                   C.FILE_SID=FileSid AND
                   C.ACTIVITY_SID=A.SID AND
                   C.ACTIVITY_SID=O.SID AND ----added TJW 23-Aug-2011 CR#3928
                   O.OBJ_TYPE=OT.SID AND
                   OT.CODE='ACT.INTERVIEW.SUBJECT' 
              ORDER BY ACTIVITY_DATE;      
           
              IF v_rtn IS NOT NULL THEN

                Core_Logger.log_it('I2MS', 'Using Subject Interview Date.');

              END IF;
  
     EXCEPTION
              WHEN NO_DATA_FOUND THEN v_rtn := NULL;

     END;
     
     ----------------------------------------------------------------------------------------
     --- Date Fingerprints were taken is used if there is no Subject Interview Date Found ---
     ----------------------------------------------------------------------------------------
     IF v_rtn IS NULL THEN
     
       BEGIN

            SELECT ACTIVITY_DATE INTO v_rtn FROM T_OSI_ACTIVITY A,T_OSI_ATTACHMENT T WHERE A.SID=pActOrFileSID AND A.SID=T.OBJ AND DESCRIPTION='Fingerprint EFT Packet';
            Core_Logger.log_it('I2MS', 'Using Fingerprint Date.');
    
       EXCEPTION
                WHEN NO_DATA_FOUND THEN v_rtn := NULL;
       END;

     END IF;
  
     ---------------------------------------------------------
     --- Use Investigatively Closed Date if all else fails ---
     ---------------------------------------------------------
     IF v_rtn IS NULL THEN

       v_rtn := Osi_Status.Last_SH_Date(FileSID,'IC');
    
     END IF;    

     Core_Logger.log_it('I2MS', 'GET_ARREST_DATE, v_rtn=' || TO_CHAR(v_rtn,'DD-Mon-YYYY'));
     RETURN TO_CHAR(v_rtn,'DD-Mon-YYYY');

EXCEPTION
     WHEN OTHERS THEN
         Core_Logger.log_it('I2MS', 'Error in GET_ARREST_DATE: ' || SQLERRM );
         RETURN NULL;
   
END Get_Arrest_Date;
/





CREATE OR REPLACE PACKAGE BODY "OSI_IAFIS" as
/******************************************************************************
   Name:     osi_iafis
   Purpose:  Provides Functionality For IAFIS FD-249 display

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    23-Mar-2010 Tim Ward        Created Package
    14-Apr-2010 Tim Ward        Changed GetOffenseArrestDates to get actual dates.
                                Changed OffensesSQL to get Actual Offense Results.
    21-Apr-2010 Tim Ward        Changed GetPersonalInformation to have a p_Format date 
                                 format string passed into it. 
    04-May-2010 Tim Ward        Added Alias Functions.
                                Fixed Miscellaneous Numbers, they were joining to
                                 T_OSI_REFERENCE instead of T_OSI_PARTIC_NUMBER_TYPE.
                                Fixed Employment Information to use PARTICIPANT 
                                 instead of PARTICIPANT_VERSION.
    14-Mar-2011 Tim Ward        Fixed ORI/Address information for Unit. 
                                 Changed in GetContributorInfo.
    20-May-2011 Tim Ward        CR#03858 - Arrest Date problems with Sending IAFIS Requests.
                                 Changed GET_ARREST_DATE to return a string instead of
                                  a date, so the SendRequests.exe works correctly, but
                                  that broke the FD-249 screen in WebI2MS.  Changed the
                                  TO_CHAR's to TO_DATE in  GetOffenseArrestDates and OffensesSQL.
    07-Jul-2011 Tim Ward        CR#03895 - Too many dispositions showing on FD-249 Screen.
                                 Added get_subject_pv_sid.
                                 Changed OffensesSQL.
    20-May-2011 Tim Ward        CR#3928 - Agent Phone Number incorrect on FD-249.
                                 Changed in GetOfficialTakingFingerprints.
                                                                                                    
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_IAFIS';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    function Get_Subject_PV_Sid(p_obj in varchar2) return varchar2 is
    
            v_pv_sid varchar2(20);
            
    begin
         select i.participant_version into v_pv_sid from t_osi_partic_involvement i, t_osi_partic_role_type t 
            where obj=p_obj
              and i.INVOLVEMENT_ROLE=t.sid
              and t.role='Subject'
              and t.usage='SUBJECT';
         
         return v_pv_sid;
         
    exception
        when others then
            return null;
            
    end Get_Subject_PV_Sid;
     
    function Get_File_Assoc_To_Act(p_obj in varchar2) return varchar2 is

            FileSid Varchar2(20);
      
    begin
         SELECT F.SID into FileSID FROM T_OSI_FILE F,T_OSI_ASSOC_FLE_ACT C WHERE C.FILE_SID=F.SID AND C.ACTIVITY_SID=p_obj;
         return FileSid;

    exception
        when others then
            log_error('Get_File_Assoc_To_Act: ' || sqlerrm);
            return p_obj;
   
    end Get_File_Assoc_To_Act;
    
    /**************************/
    /*  Offender Name Section */  
    /**************************/
    procedure get_offender_name(p_obj in varchar2, p_Last_Name out Varchar2, p_First_Name out Varchar2, p_Middle_Name out Varchar2, p_Suffix out Varchar2) is
    begin
         FOR S IN (SELECT decode(LAST_NAME,NULL,'-',LAST_NAME) AS LAST_NAME,
                          decode(FIRST_NAME,NULL,'-',FIRST_NAME) AS FIRST_NAME,
                          decode(MIDDLE_NAME,NULL,'-',MIDDLE_NAME) AS MIDDLE_NAME,
                          decode(CADENCY,NULL,'-',CADENCY) AS CADENCY
                   FROM T_OSI_PARTIC_INVOLVEMENT I,
                        T_OSI_PARTICIPANT_VERSION V,
                        T_OSI_PARTIC_NAME N, 
                        T_OSI_PARTIC_NAME_TYPE T 
                   WHERE 
                        I.PARTICIPANT_VERSION=V.SID AND 
                        N.PARTICIPANT_VERSION=V.SID AND 
                        N.NAME_TYPE=T.SID AND T.CODE='L' AND 
                        OBJ=p_obj)
         LOOP
             p_Last_Name := S.LAST_NAME;
             p_First_Name := S.FIRST_NAME;
             p_Middle_Name := S.MIDDLE_NAME;
             p_Suffix := S.CADENCY;
  
         END LOOP;

    exception
        when others then
            log_error('get_offender_name: ' || sqlerrm);
    end get_offender_name;
 
    /*************************************/
    /*  Offense and Arrest Dates Section */  
    /*************************************/
    procedure GetOffenseArrestDates(p_obj in varchar2, p_DOA out varchar2, p_DOO out varchar2, p_IsAct in varchar2 := 'N', p_Format in varchar2 := 'DD-MON-YYYY') is
    begin

         p_DOA := TO_CHAR(TO_DATE(GET_ARREST_DATE(p_obj, p_IsAct)),p_Format);
         p_DOO := TO_CHAR(GET_FIRST_INCIDENT_DATE(p_obj, p_IsAct),p_Format);
         
    exception
        when others then
            log_error('GetOffenseArrestDates: ' || sqlerrm);
    end GetOffenseArrestDates;

    /************************************/
    /*  Contributor Information Section */  
    /************************************/
    procedure GetContributorInfo(p_obj in varchar2, p_ORI out varchar2, p_Contributor_Name out varchar2, p_Contributor_Address out varchar2) is
    begin 

         FOR A IN (SELECT ASSIGNED_UNIT FROM T_OSI_ACTIVITY A WHERE SID=p_obj)
         LOOP
             FOR B IN (SELECT U.FBI_ORI_NUM,
                              N.UNIT_NAME,
                              A.CITY,
                              S.NCIC_CODE 
                         FROM T_OSI_UNIT U, 
                              T_OSI_UNIT_NAME N,
                              T_OSI_ADDRESS A,
                              T_DIBRS_STATE S
                        WHERE --(U.SID=GET_ACCOUNTABLE_PARENT(A.ASSIGNED_UNIT) or 
                              --U.SID=A.ASSIGNED_UNIT) AND
                              U.SID=GET_ACCOUNTABLE_PARENT(A.ASSIGNED_UNIT) AND
                              N.UNIT=U.SID AND
                              N.END_DATE IS NULL AND
                              N.UNIT=A.OBJ (+) AND
                              A.STATE=S.SID (+))
             LOOP

                 p_ORI := B.FBI_ORI_NUM;
                 p_CONTRIBUTOR_NAME := B.UNIT_NAME;
                 p_CONTRIBUTOR_ADDRESS := B.CITY || ', ' || B.NCIC_CODE || '.';

             END LOOP; 
     
         END LOOP;

    exception
        when others then
            log_error('GetContributorInfo: ' || sqlerrm);
    end GetContributorInfo;

    /*****************************************/
    /*  Person Birth and Citizenship Section */
    /*****************************************/
    procedure GetBirthCitizenshipInfo(p_obj in varchar2, p_Partic_Ver in varchar2, p_BS out varchar2, p_BC out varchar2, p_COC out varchar2) is
    begin
         FOR A IN (SELECT S.DESCRIPTION AS STATE, C.DESCRIPTION AS COUNTRY
                      FROM 
                          T_OSI_PARTIC_ADDRESS P,
                          T_OSI_ADDRESS D,
                          T_DIBRS_STATE S,
                          T_DIBRS_COUNTRY C,
                          T_OSI_ADDR_TYPE T
                     WHERE
                          P.ADDRESS=D.SID (+) AND
                          D.STATE=S.SID (+) AND
                          D.COUNTRY=C.SID (+) AND
                          T.SID=D.ADDRESS_TYPE AND
                          T.CODE='BIRTH' AND
                          P.PARTICIPANT_VERSION=p_Partic_Ver)
         LOOP

           p_BS := A.STATE;
           p_BC := A.COUNTRY;

         END LOOP;

         FOR A IN (SELECT D.DESCRIPTION
                      FROM 
                          T_OSI_PARTIC_CITIZENSHIP C,
                          T_DIBRS_COUNTRY D
                     WHERE
                          C.COUNTRY=D.SID (+) AND
                          C.PARTICIPANT_VERSION=p_Partic_Ver)
         LOOP
       
       
           p_COC := A.DESCRIPTION;
       
         END LOOP;

    exception
        when others then
            log_error('GetBirthCitizenshipInfo: ' || sqlerrm);
    end GetBirthCitizenshipInfo;

    /*********************************/
    /*  Personal Information Section */  
    /*********************************/
    procedure GetPersonalInformation(p_obj in varchar2, p_DOB out varchar2, p_SEX out varchar2, p_RACE out varchar2, p_HEIGHT out varchar2, p_WEIGHT out varchar2, p_EYE_COLOR out varchar2, p_HAIR_COLOR out varchar2, p_Format in varchar2 := 'DD-MON-YYYY') is
    begin
         FOR S IN (SELECT 
                         SEX.CODE AS SEX, 
                         RACE.NCIC_CODE AS RACE, 
                         EC.CODE AS EYE_COLOR, 
                         HC.CODE AS HAIR_COLOR, 
                         WEIGHT, 
                         HEIGHT, 
                         TO_CHAR(P.DOB,p_Format) AS DOB
                     FROM 
                         T_OSI_PARTIC_INVOLVEMENT I,
                         T_OSI_PARTICIPANT_VERSION V,
                         T_OSI_PARTICIPANT P,
                         T_OSI_PERSON_CHARS C,
                         T_DIBRS_REFERENCE SEX,
                         T_OSI_REFERENCE EC,
                         T_OSI_REFERENCE HC,
                         T_DIBRS_RACE_TYPE RACE
                    WHERE
                         I.PARTICIPANT_VERSION=V.SID AND 
                         C.SID=V.SID AND
                         P.SID=V.PARTICIPANT AND
                         C.SEX=SEX.SID (+) AND
                         C.EYE_COLOR=EC.SID (+) AND
                         C.HAIR_COLOR=HC.SID (+) AND
                         C.RACE=RACE.SID (+) AND
                         OBJ=p_obj)
         LOOP
      
             p_DOB:=S.DOB;
             p_SEX:=S.SEX;
             p_RACE:=S.RACE;
             p_HEIGHT:=S.HEIGHT;
             p_WEIGHT:=S.WEIGHT;
             p_EYE_COLOR:=S.EYE_COLOR;
             p_HAIR_COLOR:=S.HAIR_COLOR;
               
         END LOOP;
   
    exception
        when others then
            log_error('GetPersonalInformation: ' || sqlerrm);
    end GetPersonalInformation;
    
    /****************************************/
    /*  Person Numbers (SSN, FBI, State ID) */  
    /****************************************/
    procedure GetOffenderNumbers(p_obj in varchar2, p_SSN out varchar2, p_FBI out varchar2) is
    begin
         FOR S IN (SELECT
                         DESCRIPTION,
                         NUM_VALUE,
                         T.CODE
                     FROM 
                         T_OSI_PARTIC_INVOLVEMENT I,
                         T_OSI_PARTICIPANT_VERSION V,
                         T_OSI_PARTIC_NUMBER N, 
                         T_OSI_PARTIC_NUMBER_TYPE T 
                    WHERE 
                         I.PARTICIPANT_VERSION=V.SID AND 
                         N.PARTICIPANT_VERSION=V.SID AND 
                         N.NUM_TYPE=T.SID AND 
                         T.CODE IN ('SSN','FBI') AND 
                         OBJ=p_obj)
         LOOP
      
             IF S.CODE = 'SSN' THEN

               p_SSN := S.NUM_VALUE;

             END IF;
             IF S.CODE = 'FBI' THEN

               p_FBI := S.NUM_VALUE;

             END IF;
  
         END LOOP;

    exception
        when others then
            log_error('GetOffenderNumbers: ' || sqlerrm);
    end GetOffenderNumbers;
    
    /*********************************/
    /*  Other Person Numbers Section */  
    /*********************************/
    function MiscellaneousNumbersSQL(p_obj in varchar2) return varchar2 is
    begin
         return 'SELECT                          T.DESCRIPTION AS "Type",                          NUM_VALUE AS "Number",        C.DESCRIPTION AS "Issue Country",        S.DESCRIPTION AS "Issue State",        N.ISSUE_DATE AS "Issue Date",        N.EXPIRE_DATE AS "Expire Date",                          T.CODE AS NUMBER_CODE,        C.NCIC_CODE AS COUNTRY_CODE,        S.NCIC_CODE AS STATE_CODE                      FROM                           T_OSI_PARTIC_INVOLVEMENT I,                          T_OSI_PARTICIPANT_VERSION V,                          T_OSI_PARTIC_NUMBER N,                           T_OSI_PARTIC_NUMBER_TYPE T,        T_DIBRS_COUNTRY C,        T_DIBRS_STATE S                      WHERE                           I.PARTICIPANT_VERSION=V.SID AND                           N.PARTICIPANT_VERSION=V.SID AND                           N.NUM_TYPE=T.SID AND                           T.CODE IN (''DL'',''PP'',''AR'') AND        N.ISSUE_COUNTRY=C.SID (+) AND         N.ISSUE_STATE=S.SID (+) AND                          OBJ=''' || p_obj || '''';
       
    end MiscellaneousNumbersSQL;
 
    /************************************************************/
    /*  Other Person Numbers Section Returns Select String ONLY */  
    /************************************************************/
    procedure GetMiscellaneousNumbersBySQL(p_obj in varchar2, p_SQL OUT VARCHAR2) is
    begin
      
         p_SQL := MiscellaneousNumbersSQL(p_obj);
   
    end GetMiscellaneousNumbersBySQL;
 
    /***************************************************/
    /*  Other Person Numbers Section Returns RecordSet */  
    /***************************************************/
    procedure GetMiscellaneousNumbersByRS(p_obj in varchar2, p_recordset OUT SYS_REFCURSOR) is
    begin
         OPEN p_recordset FOR MiscellaneousNumbersSQL(p_obj);
   
    exception
        when others then
            log_error('GetMiscellaneousNumbersByRS: ' || sqlerrm);
    end GetMiscellaneousNumbersByRS;


    /**************************************************/
    /*  Person Scars, Marks, Tattoos, and Amputations */
    /**************************************************/
    function FixMarks(p_Code in varchar2, p_NCIC_Code in varchar2, p_NCIC_Loc_Code in varchar2, p_Description in varchar2) return varchar2 is
   
      myTemp varchar2(4000);
      myDescription varchar2(4000);
   
    begin
         myDescription:=UPPER(p_Description);
   
         --- Fix some Agent Data Input Inconsistencies found when Initially written --- 
         if p_Code = 'C' Then
 
           if instr(myDescription, 'MOLE', 1, 1) > 0 then
     
             mytemp := 'MOLE ' || p_NCIC_Loc_Code;
      
           elsif instr(myDescription, 'PEIRCE', 1, 1) > 0 or 
                 instr(myDescription, 'PEIRCED', 1, 1) > 0 or
                 instr(myDescription, 'RING', 1, 1) > 0 or
                 instr(myDescription, 'PEIRCING', 1, 1) > 0 or
                 instr(myDescription, 'PEIRCINGS', 1, 1) > 0 or
                 instr(myDescription, 'PIERCE', 1, 1) > 0 or
                 instr(myDescription, 'PIERCED', 1, 1) > 0 or
                 instr(myDescription, 'POST IN', 1, 1) > 0 or
                 instr(myDescription, 'PIERCING', 1, 1) > 0 or
                 instr(myDescription, 'PIERCINGS', 1, 1) > 0 then
     
                if p_NCIC_Loc_Code = 'CHEST' then
       
                  myTemp := 'PRCD NIPPL';
     
                else
       
                  myTemp := 'PRCD ' || p_NCIC_Loc_Code;
    
                end if;
     
           else
              
             myTemp := 'DISC ' || p_NCIC_Loc_Code;
          
           end if;
   
         else
     
           myTemp := p_NCIC_Code || ' ' || p_NCIC_Loc_Code; 
       
         end if; 
   
         --- Fix some Inconsistencies in NCIC-Codes for Scars vs. Tattoos....... ---  
         if p_Code = 'B' then
   
           myTemp := replace(myTemp, 'SC CHEEK', 'SC CHK');

           myTemp := replace(myTemp, 'SC LELBOW', 'SC L ELB');
           myTemp := replace(myTemp, 'SC RELBOW', 'SC R ELB');

           myTemp := replace(myTemp, 'SC FNGR', 'SC FGR');

           myTemp := replace(myTemp, 'SC L FOOT', 'SC L FT');
           myTemp := replace(myTemp, 'SC R FOOT', 'SC R FT');

           myTemp := replace(myTemp, 'SC LW LIP', 'SC LOW LIP');

           myTemp := replace(myTemp, 'SC WRS', 'SC WRIST');
           myTemp := replace(myTemp, 'SC L WRS', 'SC L WRIST');
           myTemp := replace(myTemp, 'SC R WRS', 'SC R WRIST');

           myTemp := replace(myTemp, 'SC ABDMN', 'SC ABDOM');
     
         end if;

         --- Fix some Inconsistencies in NCIC-Codes for Tattoos vs. Piercings....... ---  
         if p_Code = 'A' then
   
           myTemp := replace(myTemp, 'TAT ABDMN', 'TAT ABDOM');
     
         end if;
    
         return myTemp;
   
    exception
        when others then
            log_error('FixMarks: ' || sqlerrm);
            return p_Code;

    end FixMarks;
 
    function MarksSQL(p_obj in varchar2) return varchar2 is
    begin
         return 'SELECT                          OSI_IAFIS.FIXMARKS(T.CODE,T.NCIC_CODE,L.NCIC_CODE,M.DESCRIPTION) AS "Code",                          M.DESCRIPTION AS "Description",                          T.CODE,                          T.NCIC_CODE,                          L.CODE,                          L.NCIC_CODE                      FROM                           T_OSI_PARTIC_INVOLVEMENT I,                          T_OSI_PARTICIPANT_VERSION V,                          T_OSI_PARTIC_MARK M,                           T_DIBRS_MARK_TYPE T,                          T_DIBRS_MARK_LOCATION_TYPE L                      WHERE                           I.PARTICIPANT_VERSION=V.SID AND                           M.PARTICIPANT_VERSION=V.SID AND                           M.MARK_TYPE=T.SID (+) AND                           M.MARK_LOCATION=L.SID (+) AND                           OBJ=''' || p_obj || '''';

    end MarksSQL;
 
    /*************************************************************************************/
    /*  Person Scars, Marks, Tattoos, and Amputations Section Returns Select String ONLY */  
    /*************************************************************************************/
    procedure GetMarksBySQL(p_obj in varchar2, p_SQL OUT VARCHAR2) is
    begin
      
         log_error('GetMarksBySQL(' || p_obj || ')');
         p_SQL := MarksSQL(p_obj);
   
    end GetMarksBySQL;
 
    /****************************************************************************/
    /*  Person Scars, Marks, Tattoos, and Amputations Section Returns RecordSet */  
    /****************************************************************************/
    procedure GetMarksByRS(p_obj in varchar2, p_recordset OUT SYS_REFCURSOR) is
    begin
         OPEN p_recordset FOR MarksSQL(p_obj);
   
    exception
        when others then
            log_error('GetMarksByRS: ' || sqlerrm);
    end GetMarksByRS;

    /*****************************************/
    /*  Offender Residence (Address) Section */  
    /*****************************************/
    procedure GetOffenderResidence(p_obj in varchar2, p_Partic_Ver in varchar2, p_Residence out varchar2, p_Address1 out varchar2, p_Address2 out varchar2, p_City out varchar2, p_State_Code out varchar2, p_State_Description out varchar2, p_Postal_Code out varchar2) is
    begin 

         FOR A IN (SELECT S.DESCRIPTION AS STATE, C.DESCRIPTION AS COUNTRY, ADDRESS_1, ADDRESS_2, CITY, POSTAL_CODE, S.NCIC_CODE
                      FROM 
                          T_OSI_PARTIC_ADDRESS P,
                          T_OSI_ADDRESS D,
                          T_DIBRS_STATE S,
                          T_DIBRS_COUNTRY C,
                          T_OSI_ADDR_TYPE T
                     WHERE
                          P.ADDRESS=D.SID (+) AND
                          D.STATE=S.SID (+) AND
                          D.COUNTRY=C.SID (+) AND
                          T.SID=D.ADDRESS_TYPE AND
                          T.CODE IN ('RES','PERM') AND
                          P.PARTICIPANT_VERSION=p_Partic_Ver)
         LOOP

          p_Residence := A.ADDRESS_1;
    
          if A.ADDRESS_2 is not null then
      
            p_Residence := p_Residence || CHR(13) || CHR(10) || A.ADDRESS_2;
   
          end if;

          p_Residence := p_Residence || CHR(13) || CHR(10) || A.CITY || ', ' || A.NCIC_CODE || ' ' || A.POSTAL_CODE;

          p_Address1:=A.ADDRESS_1; 
          p_Address2:=A.ADDRESS_2; 
          p_City:=A.CITY; 
          p_State_Code:=A.NCIC_CODE; 
          p_State_Description:=A.STATE; 
          p_Postal_Code:=A.POSTAL_CODE;
    
         END LOOP;

    exception
        when others then
            log_error('GetOffenderResidence: ' || sqlerrm);
    end GetOffenderResidence;

    /*****************************************/
    /*  Official Taking Fingerprints Section */  
    /*****************************************/
    procedure GetOfficialTakingFingerprints(p_obj in varchar2, p_Last_Name out varchar2, p_First_Name out varchar2, p_Middle_Name out varchar2, p_PhoneNum out varchar2) is

      pLeadAgentSid varchar2(20);
   
    begin 
         ---------------------------- 
         --- Get First Lead Agent --- 
         ---------------------------- 
         p_Last_Name := '-';
         p_First_Name := '-';
         p_Middle_Name := '-';
   
         FOR A IN (SELECT DECODE(CP.LAST_NAME,NULL,'-',CP.LAST_NAME) AS LAST_NAME, 
                          DECODE(CP.FIRST_NAME,NULL,'-',CP.FIRST_NAME) AS FIRST_NAME, 
                          DECODE(CP.MIDDLE_NAME,NULL,'-',CP.MIDDLE_NAME) AS MIDDLE_NAME,
                          A.PERSONNEL
                      FROM 
                          T_OSI_ASSIGNMENT A,
                          T_OSI_ASSIGNMENT_ROLE_TYPE T,
                          T_OSI_PERSONNEL P,
                          T_CORE_PERSONNEL CP
                     WHERE
                          A.OBJ=p_obj AND
                          A.ASSIGN_ROLE=T.SID AND
                          T.CODE='LEAD' AND
        A.PERSONNEL=P.SID AND
        P.SID=CP.SID
                          ORDER BY A.START_DATE)
         LOOP

             p_Last_Name := A.LAST_NAME;
             p_First_Name := A.FIRST_NAME;
             p_Middle_Name := A.MIDDLE_NAME;
             pLeadAgentSid := A.PERSONNEL;
             exit;
    
         END LOOP;
   
         ------------------------------ 
         --- Get Agent Phone Number --- 
         ------------------------------ 
         p_PhoneNum := '-';
   
         FOR A IN (SELECT C.VALUE, 
                          R.CODE, 
                          R.DESCRIPTION, 
                          DECODE(R.CODE,'OFFP',0,
                                        'OFFA',1,
                                        'DSNP',2,
                                        'OFFF',3,
                                        'MOBP',4,
                                        'MOBA',5,
          'PAGEP',6,
          'PAGEA',7,
          'HOMEP',8,
          'HOMEA',9,
          'DSNA',10,
           99) AS MOSTWANTED
                      FROM 
                          T_OSI_PERSONNEL P,
                          T_OSI_PERSONNEL_CONTACT C,
                          T_OSI_REFERENCE R
                     WHERE
                          P.SID=pLeadAgentSid AND
                          P.SID=C.PERSONNEL AND
                          C.TYPE=R.SID ORDER BY MOSTWANTED)
         LOOP
             
             p_PhoneNum := A.VALUE;
             exit;

         END LOOP;

    exception
        when others then
            log_error('GetOfficialTakingFingerprints: ' || sqlerrm);
    end GetOfficialTakingFingerprints;

    /******************************/
    /*  Charges/Citations Section */  
    /******************************/
    function OffensesSQL(p_obj in varchar2) return varchar2 is

      FileSID varchar2(20);
      ArrestDate varchar2(100);
      v_pv_sid varchar2(20);
      
    begin
         FileSID := Get_File_Assoc_To_Act(p_obj);
         --ArrestDate := TO_DATE(GET_ARREST_DATE(p_obj, 'N'),'DD-MON-YYYY');
         ArrestDate := TO_DATE(GET_ARREST_DATE(p_obj, 'Y'),'DD-MON-YYYY');
         
         v_pv_sid := get_Subject_pv_sid(p_obj);
          
         return  'SELECT                         OFFENSE_CHARGE as "Charge/Citation",                         TO_CHAR(OFFENSE_DATE,''DD-MON-YYYY'') as "Charge Date",                         COURT_DISP as "Disposition",                         TO_CHAR(COURT_DISP_DATE,''DD-MON-YYYY'') as "Disposition Date",                         ''' || ArrestDate || ''' as "Arrest Date"                     FROM                          V_OSI_IAFIS_OFFENSE_INFO                    WHERE INVESTIGATION=''' || FileSID || '''' || ' AND SUBJECT=''' || v_pv_sid || '''';
       
    end OffensesSQL;
 
    /*********************************************************/
    /*  Charges/Citations Section Returns Select String ONLY */  
    /*********************************************************/
    procedure GetOffensesBySQL(p_obj in varchar2, p_SQL OUT VARCHAR2) is
    begin
         p_SQL := OffensesSQL(p_obj);
   
    end GetOffensesBySQL;
 
    /************************************************/
    /*  Charges/Citations Section Returns RecordSet */  
    /************************************************/
    procedure GetOffensesByRS(p_obj in varchar2, p_recordset OUT SYS_REFCURSOR) is
    begin
         OPEN p_recordset FOR OffensesSQL(p_obj);
   
    exception
        when others then
            log_error('GetOffensesByRS: ' || sqlerrm);
    end GetOffensesByRS;
 
    /********************************************************************************************************/
    /*  Date Last Requests and Responses Sent/Received from IAFIS - For Fingerprint Activity Details Screen */
    /********************************************************************************************************/
    procedure GetLastIAFISDates(p_obj in varchar2, p_LAST_SENT_TO_IAFIS out varchar2, p_LAST_IAFIS_REPLY out varchar2) is
    begin
         select to_char(max(request_on),'DD-MON-YYYY') into p_LAST_SENT_TO_IAFIS from t_osi_a_fp_iafis_request where obj=p_obj;
         select to_char(max(response_on),'DD-MON-YYYY') into p_LAST_IAFIS_REPLY from t_osi_a_fp_iafis_response where request in (select sid from t_osi_a_fp_iafis_request where obj=p_obj);
   
    exception
        when others then
            log_error('GetLastIAFISDates: ' || sqlerrm);
    end GetLastIAFISDates;

    /******************************/
    /*  Basis for Caution Section */
    /******************************/
    procedure GetBasisForCaution(p_obj in varchar2, p_Partic_Ver in varchar2, p_Basis_for_Caution out varchar2) is

      p_Partic_Sid varchar2(20);
   
    begin
         select participant into p_Partic_Sid from t_osi_participant_version where sid=p_Partic_Ver;
   
         FOR A IN (SELECT NOTE_TEXT 
                      FROM 
                          t_osi_note n,
                          t_osi_note_type t
                     WHERE
                          obj=p_Partic_Sid and
                          n.NOTE_TYPE=t.sid and
                          t.DESCRIPTION='Basis for Caution'
                  ORDER BY n.CREATE_ON DESC)
         LOOP

             p_Basis_for_Caution := SUBSTR(A.NOTE_TEXT,1,50);
             EXIT;
    
         END LOOP;

         IF p_Basis_for_Caution IS NULL THEN
     
           FOR A IN (SELECT NOTE_TEXT 
                        FROM 
                            t_osi_note n,
                            t_osi_note_type t
                       WHERE
                            obj=p_obj and
                            n.NOTE_TYPE=t.sid and
                            t.DESCRIPTION='Basis for Caution'
                    ORDER BY N.CREATE_ON DESC)
           LOOP

               p_Basis_for_Caution := SUBSTR(A.NOTE_TEXT,1,50);
               EXIT;
    
           END LOOP;
     
         END IF;
   
         IF p_Basis_for_Caution IS NULL or p_Basis_for_Caution='' then

           p_Basis_for_Caution := '-';
        
         END IF;  

    exception
        when others then
            log_error('GetBasisForCaution: ' || sqlerrm);
    end GetBasisForCaution;

    /*********************************/
    /*  Employer Information Section */
    /*********************************/
    procedure GetEmployerInformation(p_obj in varchar2, p_Partic_Ver in varchar2, p_Name out varchar2, p_Occupation out varchar2, p_Address out varchar2, p_Address1 out varchar2, p_Address2 out varchar2, p_City out varchar2, p_State_Code out varchar2, p_State_Description out varchar2, p_Postal_Code out varchar2) is
   
      p_Partic_VER_SID varchar2(20);
      p_Partic varchar2(20);
      p_Partic_Type varchar2(100);
      p_Partic_SubType varchar2(100);
      
    begin

         SELECT PARTICIPANT INTO p_Partic FROM T_OSI_PARTICIPANT_VERSION WHERE SID=p_Partic_Ver;
   
         p_Name := '-'; 
         p_Occupation := '-';
         p_Address := '-';          
         p_Address1 := '-'; 
         p_Address2 := '-'; 
         p_City := '-'; 
         p_State_Code := '-'; 
         p_State_Description := '-'; 
         p_Postal_Code := '-';

         /* Check for Military Employment */
         FOR A IN (SELECT MOD1_VALUE, OSI_PARTICIPANT.get_name(partic_b) AS NAME, PARTIC_B
                      FROM 
                          t_osi_partic_relation r,
                          t_osi_partic_relation_type t
                     WHERE
                          (partic_a=p_Partic) and
                          t.sid=r.REL_TYPE and
                          t.code='IMO' and
                          end_date is null)
         LOOP

             SELECT CURRENT_VERSION INTO p_Partic_VER_SID FROM T_OSI_PARTICIPANT WHERE SID=A.PARTIC_B;
             SELECT CODE INTO p_Partic_Type FROM T_CORE_OBJ_TYPE WHERE CORE_OBJ.get_objtype(A.PARTIC_B)=T_CORE_OBJ_TYPE.SID;
             SELECT OSI_PARTICIPANT.get_subtype(A.PARTIC_B) INTO p_Partic_SubType FROM DUAL;

             if p_Partic_Type = 'PART.NONINDIV.ORG' and p_Partic_SubType='US Military' then
  
               p_Name := A.NAME;
               p_Occupation := A.MOD1_VALUE;
    
               FOR B IN (SELECT S.DESCRIPTION AS STATE, C.DESCRIPTION AS COUNTRY, ADDRESS_1, ADDRESS_2, CITY, POSTAL_CODE, S.NCIC_CODE
                            FROM 
                                T_OSI_PARTIC_ADDRESS P,
                                T_OSI_ADDRESS D,
                                T_DIBRS_STATE S,
                                T_DIBRS_COUNTRY C,
                                T_OSI_ADDR_TYPE T
                           WHERE
                                P.ADDRESS=D.SID (+) AND
                                D.STATE=S.SID (+) AND
                                D.COUNTRY=C.SID (+) AND
                                T.SID=D.ADDRESS_TYPE AND
                                P.PARTICIPANT_VERSION=p_Partic_VER_SID)
               LOOP

                   p_Address := B.ADDRESS_1;
       
                   if B.ADDRESS_2 is not null then
      
                     p_Address := p_Address || CHR(13) || CHR(10) || B.ADDRESS_2;
   
                   end if;

                   p_Address := p_Address || CHR(13) || CHR(10) || B.CITY || ', ' || B.NCIC_CODE || ' ' || B.POSTAL_CODE;

                   p_Address1:=B.ADDRESS_1; 
                   p_Address2:=B.ADDRESS_2; 
                   p_City:=B.CITY; 
                   p_State_Code:=B.NCIC_CODE; 
                   p_State_Description:=B.STATE; 
                   p_Postal_Code:=B.POSTAL_CODE;
    
               END LOOP;

             end if;
             EXIT;
    
         END LOOP;

         /* Check for Regular Employment */
         FOR A IN (SELECT MOD1_VALUE, OSI_PARTICIPANT.get_name(partic_b) AS NAME, PARTIC_B
                      FROM 
                          t_osi_partic_relation r,
                          t_osi_partic_relation_type t
                     WHERE
                          (partic_a=p_Partic) and
                          t.sid=r.REL_TYPE and
                          t.code='IEDB' and
                          end_date is null)
         LOOP
             
             p_Name := A.NAME;
             p_Occupation := A.MOD1_VALUE;
             SELECT CURRENT_VERSION INTO p_Partic_VER_SID FROM T_OSI_PARTICIPANT WHERE SID=A.PARTIC_B;
    
             FOR B IN (SELECT S.DESCRIPTION AS STATE, C.DESCRIPTION AS COUNTRY, ADDRESS_1, ADDRESS_2, CITY, POSTAL_CODE, S.NCIC_CODE
                          FROM 
                              T_OSI_PARTIC_ADDRESS P,
                              T_OSI_ADDRESS D,
                              T_DIBRS_STATE S,
                              T_DIBRS_COUNTRY C,
                              T_OSI_ADDR_TYPE T
                         WHERE
                              P.ADDRESS=D.SID (+) AND
                              D.STATE=S.SID (+) AND
                              D.COUNTRY=C.SID (+) AND
                              T.SID=D.ADDRESS_TYPE AND
                              P.PARTICIPANT_VERSION=p_Partic_VER_SID)
             LOOP

                 p_Address := B.ADDRESS_1;
     
                 if B.ADDRESS_2 is not null then
      
                   p_Address := p_Address || CHR(13) || CHR(10) || B.ADDRESS_2;
   
                 end if;

                 p_Address := p_Address || CHR(13) || CHR(10) || B.CITY || ', ' || B.NCIC_CODE || ' ' || B.POSTAL_CODE;

                 p_Address1:=B.ADDRESS_1; 
                 p_Address2:=B.ADDRESS_2; 
                 p_City:=B.CITY; 
                 p_State_Code:=B.NCIC_CODE; 
                 p_State_Description:=B.STATE; 
                 p_Postal_Code:=B.POSTAL_CODE;
    
             END LOOP;
    
             EXIT;
    
         END LOOP;
      
    exception
        when others then
            log_error('GetEmployerInformation: ' || sqlerrm);
    end GetEmployerInformation;

    /********************/
    /*  Aliases Section */  
    /********************/
    function AliasesSQL(p_obj in varchar2) return varchar2 is
    begin
         return 'SELECT LAST_NAME as "Last Name", FIRST_NAME as "First Name", MIDDLE_NAME as "Middle Name", CADENCY as "Suffix" FROM T_OSI_PARTIC_INVOLVEMENT I,T_OSI_PARTICIPANT_VERSION V,T_OSI_PARTIC_NAME N,T_OSI_PARTIC_NAME_TYPE T WHERE I.PARTICIPANT_VERSION=V.SID AND N.PARTICIPANT_VERSION=V.SID AND N.NAME_TYPE=T.SID AND T.CODE!=''L'' AND OBJ=''' || p_obj || '''';     
       
    end AliasesSQL;
 
    /***********************************************/
    /*  Aliases Section Returns Select String ONLY */  
    /***********************************************/
    procedure GetAliasesBySQL(p_obj in varchar2, p_SQL OUT VARCHAR2) is
    begin
         p_SQL :=  AliasesSQL(p_obj);
   
    end GetAliasesBySQL;
 
    /***************************************/
    /*   Aliases Section Returns RecordSet */  
    /***************************************/
    procedure GetAliasesByRS(p_obj in varchar2, p_recordset OUT SYS_REFCURSOR) is
    begin
         OPEN p_recordset FOR AliasesSQL(p_obj);
   
    exception
    when others then
        log_error('GetAliasesByRS: ' || sqlerrm);
    end GetAliasesByRS;
     
end osi_iafis;
/
