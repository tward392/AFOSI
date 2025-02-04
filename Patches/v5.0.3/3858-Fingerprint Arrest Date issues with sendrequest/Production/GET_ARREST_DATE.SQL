CREATE OR REPLACE FUNCTION "GET_ARREST_DATE" ( pActOrFileSID IN VARCHAR2, IsAct IN VARCHAR2 := 'N' ) RETURN VARCHAR2 IS

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