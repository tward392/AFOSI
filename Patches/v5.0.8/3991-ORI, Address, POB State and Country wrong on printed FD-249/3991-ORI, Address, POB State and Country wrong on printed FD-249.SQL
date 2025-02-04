set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_FINGERPRINT" AS
/******************************************************************************
   Name:     Osi_fingerprint
   Purpose:  Provides Functionality For Fingerprint Activity Objects.
 
   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    9-Feb-2010  J.Faris         Created Package.
   21-Apr-2010  T.McGuffin      Added load_images_from_eft procedure.
   21-Apr-2010  J.Faris         Updated load_images_from_eft to support PALMPRINT usage 
                                and exception handling.
   22-Apr-2010  J.Faris         Added clean_images_from_efts, updated display_fingerprint
                                to also delete the temporary image file after displaying.
   30-Apr-2010 Tim Ward         Added FD-249 Function.
   04-May-2010 Tim Ward         Changed load_images_from_eft and display_fingerprint to 
                                 work with both fingers and palm prints.
   04-May-2010 Tim Ward         Removed clean_images_from_efts, no longer needed.  Since 
                                 the images are in the database, they can be deleted right
                                 after they are inserted into the database.
   16-Jun-2010 Tim Ward         Added the Caching Images Line to display_fingerprint.
                                 htp.p('Expires: ' || to_char(sysdate+2,'FMDy, DD Month YYYY HH24:MI:SS') || ' GMT');
   29-Jun-2010 Tim Ward         Changed load_images_from_eft to get directories from all_directories instead of
                                 OSI.FP_EXECUTABLE and OSI.FP_IMAGE_DIR from T_CORE_CONFIG.
   18-Aug-2010 Tim Ward         Changed load_images_from_eft to increase v_fp_directory from 100 to 1000 
                                 and v_fp_executable from 300 to 1000 to make sure we have enough room.
   19-Aug-2010 Tim Ward         Changed load_images_from_eft from a procedure to a Function so it can return 
                                 'EFT FILE NOT FOUND' when there is no EFT packet so the resulting APEX Page
                                 can let the user know there is no packet instead of just displaying empty
                                 image place holders.  Returns 'OK' when the packet is found or SQLERRM when 
                                 there is another error.
                                Changed load_images_from_eft to load t_osi_a_fingerprint_temp_print with the  
                                 filename='IMAGE NOT FOUND' and image=null when the images aren't in the EFT 
                                 packet.  This is so we can show a message instead of an empty image placeholder.  
   20-Aug-2010 Tim Ward         Changed for i in 1 .. 15 to use offset variables 1-14 for Fingers and 22-28 
                                 for Palms.  NIST_READ.EXE now names the files based off of Finger Position: 
                                    0 = Unknown 
                                    1 = Right Thumb 
                                    2 = Right Index Finger              20 = Unknown Palm 
                                    3 = Right Middle Finger             21 = Right Full Palm 
                                    4 = Right Ring Finger               22 = Right Writer's Palm 
                                    5 = Right Little Finger             23 = Left Full Palm 
                                    6 = Left Thumb                      24 = Left Writer's Palm 
                                    7 = Left Index Finger               25 = Right Lower Palm 
                                    8 = Left Middle Finger              26 = Right Upper Palm 
                                    9 = Left Ring Finger                27 = Left Lower Palm 
                                   10 = Left Little Finger              28 = Left Upper Palm 
                                   11 = Right Thumb Slap                29 = Right Other 
                                   12 = Left Thumb Slap                 30 = Left Other 
                                   13 = Right Four Finger Slap 
                                   14 = Left For Finger Slap 
   23-Aug-2010 Tim Ward         Changed load_images_from_eft to have a new p_report parameter that defaults 'NO'. 
                                 this allows for the FD-249 loading images call to load "Image Not Available"
                                 for all images if there is no EFT packet so we don't get an error when the 
                                 report opens in word. 
   24-Sep-2010 Tim Ward         Added PALMPRINT_REPORT function to print the Palm Print Report. 
   05-Oct-2010 Tim Ward         Problems with Send IAFIS Request Checklists. 
                                 Changed in send_criminal_inquiry.             
   02-Dec-2010 Tim Ward         Typo, message said Participans instead of Participants.
                                 Changed in send_criminal_inquiry.             
   20-May-2011 Tim Ward         CR#03858 - Should not be able to submit to IAFIS if there is not a fingerprint
                                 attachment.
                                 Changed send_criminal_inquiry.
   01-Aug-2012 Tim Ward         CR#03991 - ORI, Address, and POB missing or Incorrect.
                                 Changed FD249_Report to fix POB. 
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_FINGERPRINT';
 
    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;
 
    FUNCTION get_tagline(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN Osi_Activity.get_tagline(p_obj);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline: ' || SQLERRM);
            RETURN 'get_tagline: Error';
    END get_tagline;
 
    FUNCTION get_summary(p_obj IN VARCHAR2, p_variant IN VARCHAR2 := NULL)
        RETURN CLOB IS
    BEGIN
        RETURN Osi_Activity.get_summary(p_obj, p_variant);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_summary: ' || SQLERRM);
            RETURN 'get_summary: Error';
    END get_summary;
 
    PROCEDURE index1(p_obj IN VARCHAR2, p_clob IN OUT NOCOPY CLOB) IS
    BEGIN
        Osi_Activity.index1(p_obj, p_clob);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('index1: ' || SQLERRM);
    END index1;
 
    FUNCTION get_status(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN Osi_Activity.get_status(p_obj);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status: ' || SQLERRM);
            RETURN 'get_status: Error';
    END get_status;
 
    FUNCTION create_instance(
        p_obj_type      IN   VARCHAR2,
        p_act_date      IN   DATE,
        p_title         IN   VARCHAR2,
        p_restriction           IN   VARCHAR2,
        p_narrative     IN   CLOB,
        p_participant_version   IN   VARCHAR2)
        RETURN VARCHAR2 IS
        v_sid   T_CORE_OBJ.SID%TYPE;
    BEGIN
        v_sid := Osi_Activity.create_instance(p_obj_type, 
                                              p_act_date, 
                                              p_title, 
                                              p_restriction, 
                                              p_narrative);
 
        INSERT INTO T_OSI_A_FINGERPRINT
                    (SID)
             VALUES (v_sid);
 
        IF p_participant_version IS NOT NULL THEN
            INSERT INTO T_OSI_PARTIC_INVOLVEMENT i
                        (obj, participant_version, involvement_role)
                 VALUES (v_sid,
                         p_participant_version,
                         (SELECT SID
                            FROM T_OSI_PARTIC_ROLE_TYPE
                           WHERE obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type) 
                             AND USAGE = 'SUBJECT'));
        END IF;
 
        Core_Obj.bump(v_sid);
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_instance: ' || SQLERRM);
            RAISE;
    END create_instance;
 
    /* Used to clone an activity */
    PROCEDURE CLONE(p_obj IN VARCHAR2, p_new_sid IN VARCHAR2) IS
        v_osi_a_fingerprint_record   T_OSI_A_FINGERPRINT%ROWTYPE;
    BEGIN
        --Get fingerprint Activity record
        SELECT *
          INTO v_osi_a_fingerprint_record
          FROM T_OSI_A_FINGERPRINT
         WHERE SID = p_obj;
 
        --Insert a new fingerprint Activity record
        INSERT INTO T_OSI_A_FINGERPRINT
                    (SID, instrument_serial_num, instrument_brand, treat_as_adult, juvenile)
             VALUES (p_new_sid, 
                     v_osi_a_fingerprint_record.instrument_serial_num,
                     v_osi_a_fingerprint_record.instrument_brand,
                     v_osi_a_fingerprint_record.treat_as_adult,
                     v_osi_a_fingerprint_record.juvenile);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_fingerprint.clone: ' || SQLERRM);
            RAISE;
    END CLONE;
 
    /* This function performs the criminal inquiry request submission (if prerequisite checks are passed). */
    FUNCTION send_criminal_inquiry(p_obj IN VARCHAR2, p_type IN VARCHAR2) RETURN VARCHAR2 IS
 
        v_count             NUMBER         := 0;
        v_arrest_date       DATE           := NULL;
        v_msg               VARCHAR2(4000) := NULL;
        v_file_sid          VARCHAR2(20)   := NULL;
        v_counter           NUMBER         := 1;
        v_fingerprint_file  NUMBER; 
    BEGIN
         IF p_type NOT IN ('Criminal Inquiry','Criminal/Booking Submission') THEN

           RETURN '<B><br><br><FONT FACE="Courier New" COLOR=RED>*************************************************<br>******** IAFIS REQUEST COULD NOT BE SENT ********<br>*************************************************</FONT><BR><BR>' || p_type || ' is not Supported.<br>' || '<br><FONT FACE="Courier New" COLOR=RED>*************************************************<br>******** IAFIS REQUEST COULD NOT BE SENT ********<br>*************************************************</FONT></B>';
 
         END IF;
   
         --- Lead Agent must be present ---
         IF Osi_Object.get_lead_agent(p_obj) IS NULL THEN
        
           v_msg := v_msg || v_counter || '.&nbsp;&nbsp;Activity MUST have a Lead Agent.<br>';
           v_counter := v_counter + 1;
        
         END IF;

         --- Check to Make Sure Participant Version is Current ---
         SELECT COUNT(*) INTO v_count FROM T_OSI_PARTIC_INVOLVEMENT I, T_OSI_PARTIC_ROLE_TYPE T, T_OSI_PARTICIPANT P, T_OSI_PARTICIPANT_VERSION V
           WHERE I.OBJ = p_obj 
             AND T.ROLE='Subject'
             AND T.SID=I.INVOLVEMENT_ROLE
             AND V.SID=I.PARTICIPANT_VERSION
             AND V.PARTICIPANT=P.SID 
             AND I.PARTICIPANT_VERSION=P.CURRENT_VERSION;
    
          IF v_count = 0 THEN

            v_msg := v_msg || v_counter || '.&nbsp;&nbsp;Current Version of Participants need to be associated with this Activity.<br>';
            v_counter := v_counter + 1;

          END IF;

         --- Must have Subject date of birth ---
         FOR a IN(SELECT 1 FROM T_OSI_PARTICIPANT
                     WHERE SID = Osi_Object.get_participant_sid(p_obj, 'SUBJECT') AND dob IS NULL)
         LOOP

             v_msg := v_msg || v_counter || '.&nbsp;&nbsp;Subject Date of Birth is required by JABS/IAFIS.<br>';
             v_counter := v_counter + 1;
 
         END LOOP;

         --- Check that Subject has height ---
         SELECT COUNT(*) INTO v_count FROM T_OSI_PARTIC_INVOLVEMENT I, T_OSI_PARTIC_ROLE_TYPE T, T_OSI_PERSON_CHARS C
           WHERE I.OBJ = p_obj 
             AND T.ROLE='Subject'
             AND T.SID=I.INVOLVEMENT_ROLE
             AND C.SID=I.PARTICIPANT_VERSION
             AND C.HEIGHT > 0;
    
          IF v_count = 0 THEN

            v_msg := v_msg || v_counter || '.&nbsp;&nbsp;Subject is Missing Height.<br>';
            v_counter := v_counter + 1;

          END IF;

          --- Fingerprint Activity, Get the Lead Agent from the Fyle ---
          FOR C IN (SELECT FILE_SID FROM T_OSI_ASSOC_FLE_ACT WHERE ACTIVITY_SID=p_obj)
          LOOP
              v_file_sid := C.FILE_SID;
              EXIT;

          END LOOP;

          IF v_file_sid IS NULL THEN

            SELECT COUNT(*) INTO v_count
                  FROM T_OSI_PERSONNEL_CONTACT C, T_OSI_ASSIGNMENT A, T_OSI_ASSIGNMENT_ROLE_TYPE T, T_OSI_REFERENCE R
                  WHERE A.obj=p_obj 
                    AND T.DESCRIPTION='Lead Agent'
                    AND T.SID=A.ASSIGN_ROLE
                    AND C.PERSONNEL=A.PERSONNEL
                    AND R.SID=C.TYPE 
                    AND LENGTH(C.VALUE)>0 
                    AND R.DESCRIPTION IN ('Office - Primary',
                                          'Office - Alternate',
                                          'Office - Fax',
                                          'DSN - Primary',
                                          'DSN - Alternate',
                                          'DSN - FAX',
                                          'Mobile - Primary',
                                          'Mobile - Alternate',
                                          'Pager - Primary',
                                          'Pager - Alternate',
                                          'Home - Primary',
                                          'Home - Alternate',
                                          'Home - Fax');

          ELSE

            SELECT COUNT(*) INTO v_count
                  FROM T_OSI_PERSONNEL_CONTACT C, T_OSI_ASSIGNMENT A, T_OSI_ASSIGNMENT_ROLE_TYPE T, T_OSI_REFERENCE R
                  WHERE A.obj=v_file_sid 
                    AND T.DESCRIPTION='Lead Agent'
                    AND T.SID=A.ASSIGN_ROLE
                    AND C.PERSONNEL=A.PERSONNEL
                    AND R.SID=C.TYPE 
                    AND LENGTH(C.VALUE)>0 
                    AND R.DESCRIPTION IN ('Office - Primary',
                                          'Office - Alternate',
                                          'Office - Fax',
                                          'DSN - Primary',
                                          'DSN - Alternate',
                                          'DSN - FAX',
                                          'Mobile - Primary',
                                          'Mobile - Alternate',
                                          'Pager - Primary',
                                          'Pager - Alternate',
                                          'Home - Primary',
                                          'Home - Alternate',
                                          'Home - Fax');

          END IF;
          
          IF v_count = 0 THEN

            IF v_file_sid IS NULL THEN

              v_msg := v_msg || v_counter || '.&nbsp;&nbsp;Lead Agent MUST have a Phone Number.<br>';
              v_counter := v_counter + 1;

            ELSE

              v_msg := v_msg || v_counter || '.&nbsp;&nbsp;Lead Agent of Associated File MUST have a Phone Number.<br>';
              v_counter := v_counter + 1;

            END IF;
   
          END IF;

          --------------------------------------------
          --- Checks Not Required for Inquiry ONLY ---
          -------------------------------------------- 
          IF p_type != 'Criminal Inquiry' THEN

            --- Does the Activity Have File(s) Associated with it? ---
            SELECT COUNT(*) INTO v_count FROM T_OSI_ASSOC_FLE_ACT WHERE activity_sid = p_obj;
            IF v_count = 0 THEN
 
              v_msg := v_msg || v_counter || '.&nbsp;&nbsp;Activity MUST be associated to a file.<br>';
              v_counter := v_counter + 1;

            END IF;
         
            v_arrest_date := Get_Arrest_Date(p_obj, 'Y');
       
            IF v_arrest_date IS NULL OR v_arrest_date='' THEN

              v_msg := v_msg  || v_counter || '.&nbsp;&nbsp;Subject has not been arrested, and Arrest Date is required by JABS/IAFIS.<br>';
              v_counter := v_counter + 1;

            END IF;
     
          END IF;
          
          ----------------------------------------------------   
          --- Make sure the Attachment has some size to it ---
          ----------------------------------------------------
          BEGIN
               SELECT length(a.CONTENT) into v_fingerprint_file FROM T_OSI_ATTACHMENT a, T_OSI_ATTACHMENT_TYPE t  WHERE a.obj=p_obj and a.TYPE=T.SID AND T.code='FINGERPRINT' AND T.USAGE='FINGERPRINT';

          EXCEPTION WHEN OTHERS THEN

                   v_fingerprint_file:=0;
                   
          END;          
          if v_fingerprint_file is null or v_fingerprint_file=0 then

            v_msg := v_msg  || v_counter || '.&nbsp;&nbsp;Please review the Fingerprints Tab, there were no fingprints found to submit.<br>';
            v_counter := v_counter + 1;
          
          end if;
             
          IF v_msg IS NULL THEN

            --- Finished prerequisites, insert the IAFIS submission request ---
            INSERT INTO T_OSI_A_FP_IAFIS_REQUEST(SID,obj,request_type,request_on,request_by,request_sent_to_iafis)
                  VALUES(Core_Sidgen.NEXT_SID,p_obj,p_type,SYSDATE,Core_Context.personnel_sid,'N');
 
            RETURN 'Y';
   
          ELSE
     
            RETURN '<B><br><br><FONT FACE="Courier New" COLOR=RED>*************************************************<br>******** IAFIS REQUEST COULD NOT BE SENT ********<br>*************************************************</FONT><BR><BR>' || v_msg || '<br><FONT FACE="Courier New" COLOR=RED>*************************************************<br>******** IAFIS REQUEST COULD NOT BE SENT ********<br>*************************************************</FONT></B>';
       
          END IF;
 
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_FINGERPRINT.Send_Criminal_Inquiry: Error encountered using Object '
                      || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in OSI_FINGERPRINT.Send_Criminal_Inquiry using Object: ' || NVL(p_obj, 'NULL');
    END send_criminal_inquiry;
 
    /* This procedure retrieves the fingerprint/palmprint images using the nist_read.exe on the server.  */
 
    FUNCTION load_images_from_eft(p_obj IN VARCHAR2, p_usage IN VARCHAR2 := 'FINGERPRINT', p_report IN VARCHAR2 := 'NO') RETURN VARCHAR2 IS
        v_return           PLS_INTEGER;
        v_eft_size         NUMBER;
        v_eft_content      BLOB;
        v_start            NUMBER             := 1;
        v_chunk_size       NUMBER             := 32000;
        v_chunk            RAW(32000);
        v_remaining_size   NUMBER;
        v_file             UTL_FILE.FILE_TYPE;
        v_filename         VARCHAR2(4000);
        v_fp_directory     VARCHAR2(1000)      := NULL;
        v_fp_executable    VARCHAR2(1000)      := NULL;
        v_dest_loc         BLOB;
        v_src_loc          BFILE;
        v_cached_date      DATE;
        v_attach_date      DATE;
        v_return_value     VARCHAR2(4000) := 'OK';
        v_no_image_found   VARCHAR2(100);
        v_start_num        NUMBER;
        v_end_num          NUMBER;
    BEGIN
         SELECT directory_path || '\' INTO v_fp_directory FROM ALL_DIRECTORIES WHERE directory_name='FINGERPRINTIMAGES';
         SELECT directory_path || '\nist_read.exe' INTO v_fp_executable FROM ALL_DIRECTORIES WHERE directory_name='FINGERPRINTEXECUTABLES';
         
         BEGIN
              SELECT dbms_lob.getlength(a.content), a.content, p_obj || '-' || p_usage, a.create_on, (SELECT MAX (create_on)
                                                                                                      FROM T_OSI_A_FINGERPRINT_TEMP_PRINT
                                                                                                      WHERE obj = p_obj AND 
                                                                                                      fingerorpalm=SUBSTR(p_usage,1,1))
                   INTO v_eft_size, v_eft_content, v_filename, v_attach_date, v_cached_date
                   FROM T_OSI_ATTACHMENT a, T_OSI_ATTACHMENT_TYPE AT
                   WHERE a.obj = p_obj AND a.TYPE = AT.SID AND AT.USAGE = p_usage;
         
         EXCEPTION WHEN OTHERS THEN
                  
                  v_return_value := 'EFT FILE NOT FOUND';
         
         END;

         IF v_eft_size = 0 OR v_eft_content IS NULL THEN
         
           v_return_value := 'EFT FILE NOT FOUND';
           
         ELSE
         
           IF v_cached_date IS NULL OR v_cached_date < v_attach_date THEN

             v_remaining_size := v_eft_size;
             v_file := UTL_FILE.FOPEN('FINGERPRINTIMAGES', v_filename || '.EFT', 'wb', 32760);
 
             IF v_eft_size < 32760 THEN

               UTL_FILE.put_raw(v_file, v_eft_content, TRUE);

             ELSE

               WHILE v_start < v_eft_size AND v_chunk_size > 0
               LOOP
                   dbms_lob.READ(v_eft_content, v_chunk_size, v_start, v_chunk);
                   UTL_FILE.put_raw(v_file, v_chunk, TRUE);
                   v_start := v_start + v_chunk_size;
                   v_remaining_size := v_remaining_size - v_chunk_size;
 
                   IF v_remaining_size < 32000 THEN
          
                     v_chunk_size := v_remaining_size;
          
                   END IF;

               END LOOP;
          
             END IF;
         
             UTL_FILE.FCLOSE(v_file);

             IF p_usage = 'FINGERPRINT' THEN

               v_return := Run_Cmd(v_fp_executable || ' -d4 ' || v_fp_directory || v_filename || '.EFT ' || TO_CHAR(SYSDATE, 'DDD'));

             ELSE

               v_return := Run_Cmd(v_fp_executable || ' -d15 ' || v_fp_directory || v_filename || '.EFT ' || TO_CHAR(SYSDATE, 'DDD'));

             END IF;

             UTL_FILE.fremove('FINGERPRINTIMAGES', v_filename || '.EFT');

           END IF;
         
         END IF;
         
         IF (v_return_value = 'EFT FILE NOT FOUND' AND p_report = 'YES') OR (v_return_value = 'OK' AND (v_cached_date IS NULL OR v_cached_date < v_attach_date)) THEN
         
             DELETE FROM T_OSI_A_FINGERPRINT_TEMP_PRINT WHERE obj=p_obj AND fingerorpalm=SUBSTR(p_usage,1,1);
             
             IF p_usage = 'FINGERPRINT' THEN
  
               v_start_num := 1;
                 v_end_num := 14;

             ELSE

               v_start_num := 22;
                 v_end_num := 28;
                  
             END IF;
             
             FOR i IN v_start_num .. v_end_num
             LOOP
                 v_no_image_found := NULL;
                 v_src_loc := BFILENAME('FINGERPRINTIMAGES', v_filename || '-' || i || '.jpg');
  
                 BEGIN
                     dbms_lob.OPEN(v_src_loc, dbms_lob.lob_readonly);
                 EXCEPTION
                     WHEN OTHERS THEN
                         v_no_image_found := 'IMAGE NOT FOUND';
                 END;
                 
                 IF v_no_image_found IS NULL THEN

                   dbms_lob.createtemporary(v_dest_loc, TRUE, dbms_lob.SESSION);
                   dbms_lob.OPEN(v_dest_loc, dbms_lob.lob_readwrite);
                   dbms_lob.loadfromfile(dest_lob       => v_dest_loc,
                                         src_lob        => v_src_loc,
                                         amount         => dbms_lob.getlength(v_src_loc));
                   dbms_lob.CLOSE(v_src_loc);
 
                   INSERT INTO T_OSI_A_FINGERPRINT_TEMP_PRINT (SID, obj, idx, filename, image, fingerorpalm)
                         VALUES (p_obj || SUBSTR(p_usage,1,1) || TO_CHAR(i), p_obj, i, v_filename || '-' || TO_CHAR(i) || '.jpg', v_dest_loc, SUBSTR(p_usage,1,1));
                   COMMIT;                         
 
                   dbms_lob.CLOSE(v_dest_loc);
     
                   UTL_FILE.fremove('FINGERPRINTIMAGES', v_filename || '-' || TO_CHAR(i) || '.jpg');
                 
                 ELSE
                   
                   v_src_loc := BFILENAME('FINGERPRINTIMAGES', 'ImageNotAvailable.jpg');
                   dbms_lob.OPEN(v_src_loc, dbms_lob.lob_readonly);
                   dbms_lob.createtemporary(v_dest_loc, TRUE, dbms_lob.SESSION);
                   dbms_lob.OPEN(v_dest_loc, dbms_lob.lob_readwrite);
                   dbms_lob.loadfromfile(dest_lob       => v_dest_loc,
                                         src_lob        => v_src_loc,
                                         amount         => dbms_lob.getlength(v_src_loc));
                   dbms_lob.CLOSE(v_src_loc);
 
                   INSERT INTO T_OSI_A_FINGERPRINT_TEMP_PRINT (SID, obj, idx, filename, image, fingerorpalm)
                         VALUES (p_obj || SUBSTR(p_usage,1,1) || i, p_obj, i, 'ImageNotAvailable.jpg', v_dest_loc, SUBSTR(p_usage,1,1));
                   COMMIT;                         
 
                   dbms_lob.CLOSE(v_dest_loc);
     
                 END IF;
                 
             END LOOP;

           END IF;
         
         RETURN v_return_value;
         
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_FINGERPRINT.Load_Images_From_EFT: Error encountered using Object '
                      || NVL(p_obj, 'NULL') || ':' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace);
            RETURN SQLERRM;
    END load_images_from_eft;
 
    PROCEDURE display_fingerprint(p_obj IN VARCHAR2, p_index IN NUMBER, p_FingerOrPalm IN VARCHAR2 := 'F') IS
        v_mime_type   VARCHAR2(15)  := 'image/jpeg';
        v_size        NUMBER := 0;
        v_filename    VARCHAR2(400) := 'empty.jpg';
        v_image       BLOB;
    BEGIN
        BEGIN
            SELECT dbms_lob.getlength(image), filename, image
              INTO v_size, v_filename, v_image
              FROM T_OSI_A_FINGERPRINT_TEMP_PRINT
             WHERE obj = p_obj AND idx = p_index AND FingerOrPalm=p_FingerOrPalm;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        
        owa_util.mime_header( v_mime_type, FALSE);
        htp.p('Content-length: ' || v_size);
        htp.p('Expires: ' || TO_CHAR(SYSDATE+2,'FMDy, DD Month YYYY HH24:MI:SS') || ' GMT');
        htp.p('Content-Disposition: filename="' || v_filename || '"');
        owa_util.http_header_close;
        wpg_docload.download_file(v_image);
        
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END display_fingerprint;
 
    /* FD-249 Report */
    FUNCTION FD249_Report(p_obj IN VARCHAR2) RETURN CLOB IS

            v_ok1               VARCHAR2(500);
            v_ok2               VARCHAR2(500);
            v_return            CLOB                                    := NULL;
            v_return_date       DATE;
            v_temp              VARCHAR2(4000);
            v_temp0             VARCHAR2(4000);
            v_temp1             VARCHAR2(500);
            v_temp2             VARCHAR2(500);
            v_temp3             VARCHAR2(500);
            v_temp4             VARCHAR2(500);
            v_temp5             VARCHAR2(500);
            v_temp6             VARCHAR2(500);
            v_temp7             VARCHAR2(500);
            v_temp8             VARCHAR2(500);
            v_temp9             VARCHAR2(500);
            v_mime_type         T_CORE_TEMPLATE.mime_type%TYPE;
            v_mime_disp         T_CORE_TEMPLATE.mime_disposition%TYPE;
            v_newline           VARCHAR2(10)                            := CHR(13) || CHR(10);
            v_per_ver           VARCHAR2(20);
            p_Cursor            SYS_REFCURSOR;
            v_offense           NUMBER;
            v_finger            NUMBER;
            v_temp_blob         BLOB;
            v_load_images       VARCHAR2(500);   

    BEGIN
         -- Get latest template -- 
         v_ok1 := Core_Template.get_latest('FD-249', v_return, v_return_date, v_mime_type, v_mime_disp);

         -- Get Participant Version SID -- 
         SELECT V.SID INTO v_per_ver FROM  T_OSI_PARTIC_INVOLVEMENT I, T_OSI_PARTICIPANT_VERSION V WHERE I.PARTICIPANT_VERSION=V.SID AND OBJ=p_obj;

         -- Get Associated File ID -- 
         FOR A IN (SELECT NVL(FULL_ID,ID) AS ID FROM T_OSI_FILE F,T_OSI_ASSOC_FLE_ACT A WHERE A.ACTIVITY_SID=p_obj AND F.SID=A.FILE_SID ORDER BY A.CREATE_ON DESC)
         LOOP         
             
             v_temp1 := A.ID;
             EXIT;
             
         END LOOP;
         v_ok2 := Core_Template.replace_tag(v_return,  'ID', v_temp1, 'WEBTOK@', TRUE);
                           
         ----------------------------------- 
         --- Get Offense and Arrest Date --- 
         ----------------------------------- 
         --- v_temp1 = Date of Arrest, v_temp2 = Date of Offense --- 
         Osi_Iafis.GetOffenseArrestDates(p_obj, v_temp1, v_temp2, 'Y', 'MM DD YY');

         v_ok2 := Core_Template.replace_tag(v_return,  'AD', v_temp1, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return, 'DOO', v_temp2, 'WEBTOK@', TRUE);

         -------------------------  
         --- Get Offender Name --- 
         -------------------------  
         -- v_temp1 = Offender Last Name, v_temp2 = First Name, v_temp3 = Middle Name, v_temp4 = Suffix -- 
         Osi_Iafis.get_offender_name(p_obj, v_temp1, v_temp2, v_temp3, v_temp4);

         v_ok2 := Core_Template.replace_tag(v_return,   'IND_LAST_NAME', v_temp1, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,  'IND_FIRST_NAME', v_temp2, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return, 'IND_MIDDLE_NAME', v_temp3, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,     'IND_CADENCY', v_temp4, 'WEBTOK@', TRUE);
         
         --------------------------------------------- 
         --- Get ORI, Contributor Name and Address --- 
         --------------------------------------------- 
         -- v_temp1 = ORI, v_temp2 = Contributor Name, v_temp3 = Contributor Address -- 
         Osi_Iafis.GetContributorInfo(p_obj, v_temp1, v_temp2, v_temp3);

         v_ok2 := Core_Template.replace_tag(v_return,         'ORI', v_temp1, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return, 'CONTRIBUTOR', v_temp2, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,     'ADDRESS', v_temp3, 'WEBTOK@', TRUE);

         ---------------------------------------------------------- 
         --- Get Birth State/Country and Country of Citizenship --- 
         ---------------------------------------------------------- 
         -- v_temp1 = Birth State, v_temp2 = Birth Country, v_temp3 = Country of Citizenship -- 
         Osi_Iafis.GetBirthCitizenshipInfo(p_obj, v_per_ver, v_temp1, v_temp2, v_temp3);

         IF v_temp1 IS NOT NULL OR v_temp1 != '' THEN

           v_ok2 := Core_Template.replace_tag(v_return, 'POB', v_temp1, 'WEBTOK@', TRUE);

         ELSIF v_temp2 IS NOT NULL OR v_temp2 != '' THEN          

              v_ok2 := Core_Template.replace_tag(v_return, 'POB', v_temp2, 'WEBTOK@', TRUE);

         ELSE              

              v_ok2 := Core_Template.replace_tag(v_return, 'POB', '', 'WEBTOK@', TRUE);

         END IF;
         
         v_ok2 := Core_Template.replace_tag(v_return,     'COC', v_temp3, 'WEBTOK@', TRUE);

         -------------------------------------------------------------- 
         --- Get DOB, Sex, Race, Height, Weight, Eye and Hair Color --- 
         -------------------------------------------------------------- 
         -- v_temp1 = Date of Birth, v_temp2 = Sex, v_temp3 = Race, v_temp4 = Height, v_temp5 = Weight, v_temp6 = Eye Color, v_temp7 = Hair Color -- 
         Osi_Iafis.GetPersonalInformation(p_obj, v_temp1, v_temp2, v_temp3, v_temp4, v_temp5, v_temp6, v_temp7, 'MM DD YY');

         v_ok2 := Core_Template.replace_tag(v_return,   'DOBM', SUBSTR(v_temp1,1,2) , 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,   'DOBD', SUBSTR(v_temp1,4,2) , 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,   'DOBY', SUBSTR(v_temp1,7,2) , 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,    'SEX', v_temp2, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,   'RACE', NVL(v_temp3,'U'), 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return, 'HEIGHT', v_temp4, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return, 'WEIGHT', v_temp5, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,   'EYES', NVL(v_temp6,'XXX'), 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,   'HAIR', NVL(v_temp7,'XXX'), 'WEBTOK@', TRUE);

         --------------------------- 
         --- Get SSN and FBI #'s --- 
         --------------------------- 
         -- v_temp1 = SSN, v_temp2 = FBI# -- 
         Osi_Iafis.GetOffenderNumbers(p_obj, v_temp1, v_temp2);

         v_ok2 := Core_Template.replace_tag(v_return,   'SSN', v_temp1, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,   'FBI', v_temp2, 'WEBTOK@', TRUE);

         ------------------------------ 
         --- Get Offender Residence --- 
         ------------------------------ 
         -- v_temp1 = Address Line, v_temp2 = Address Line 1, v_temp3 = Address Line 2, v_temp4 = City, v_temp5 = State Code, --  
         -- v_temp6 = State Description, v_temp7 = Zip Code -- 
         Osi_Iafis.GetOffenderResidence(p_obj, v_per_ver, v_temp1, v_temp2, v_temp3, v_temp4, v_temp5, v_temp6, v_temp7);

         v_ok2 := Core_Template.replace_tag(v_return, 'RESIDENCE', REPLACE(v_temp1,CHR(13) || CHR(10),CHR(13) || CHR(10) || '\par '), 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,      'CITY', v_temp4, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,     'STATE', v_temp5, 'WEBTOK@', TRUE);

         ---------------------------------------- 
         --- Get Official Taking Fingerprints --- 
         ---------------------------------------- 
         -- v_temp1 = Last Name, v_temp2 = First Name, v_temp3 = Middle Name, v_temp4 = Phone Number --    
         -- v_temp6 = State Description, v_temp7 = Zip Code -- 
         Osi_Iafis.GetOfficialTakingFingerprints(p_obj, v_temp1, v_temp2, v_temp3, v_temp4);

         v_ok2 := Core_Template.replace_tag(v_return, 'LEAD_AGENT', v_temp1 || ', ' || v_temp2 || ', ' || v_temp3, 'WEBTOK@', TRUE);

         -------------------------------- 
         --- Get Employer Information --- 
         -------------------------------- 
         -- v_temp1 = Name, v_temp2 = Occupation, v_temp3 = Address Display, v_temp4 = Address 1, v_temp5 = Address 2 -- 
         -- v_temp6 = City, v_temp7 = State Code, v_temp8=State Description, v_temp9 = Zip Code                       --     
         -- v_temp6 = State Description, v_temp7 = Zip Code -- 
         Osi_Iafis.GetEmployerInformation(p_obj, v_per_ver, v_temp1, v_temp2, v_temp3, v_temp4, v_temp5, v_temp6, v_temp7, v_temp8, v_temp9);

         v_ok2 := Core_Template.replace_tag(v_return,   'EMPLOYER', v_temp1 || CHR(13) || CHR(10) || '\par ' || REPLACE(v_temp3, CHR(13) || CHR(10),CHR(13) || CHR(10) || '\par '), 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return, 'OCCUPATION', v_temp2, 'WEBTOK@', TRUE);

         ---------------------------------- 
         --- Get Basis for Caution Note --- 
         ---------------------------------- 
         -- v_temp1 = Basis for Caution Text --  
         Osi_Iafis.GetBasisForCaution(p_obj, v_per_ver, v_temp1);

         v_ok2 := Core_Template.replace_tag(v_return,   'BASISFORCAUTION', v_temp1, 'WEBTOK@', TRUE);
         
         --------------------------------- 
         --- Get Miscellaneous Numbers --- 
         --------------------------------- 
         -- v_temp1 = Type, v_temp2 = Number, v_temp3 = Issue Country, v_temp4 = Issue State, v_temp5 = Issue Date -- 
         -- v_temp6 = Expire Date, v_temp7 = Number Code, v_temp8 = Country Code, v_temp9 = State Code             --    
         Osi_Iafis.GetMiscellaneousNumbersByRS(p_obj, p_Cursor);
         
         v_temp := NULL;
         BEGIN
              LOOP

                  FETCH p_Cursor INTO v_temp1, v_temp2, v_temp3, v_temp4, v_temp5, v_temp6, v_temp7, v_temp8, v_temp9;
                  EXIT WHEN p_Cursor%NOTFOUND;
                  
                  v_temp := v_temp || trim(trim(trim(v_temp1 || ' ' || v_temp2) || ' ' || v_temp3) || ' ' || v_temp4) || ';\par ';                          
          
              END LOOP;
         END;
         v_ok2 := Core_Template.replace_tag(v_return,   'NUMBERS', v_temp, 'WEBTOK@', TRUE);

         ------------------------------------------------ 
         --- Get Scars, Marks, Tattoos, and Piercings --- 
         ------------------------------------------------ 
         -- v_temp1 = Code, v_temp2 = Description, v_temp3 = Type Code, -- 
         -- v_temp4 = Type NCIC Code, v_temp5 = Location Code, v_temp6 = Location NCIC Code -- 
         Osi_Iafis.GetMarksByRS(p_obj, p_Cursor);
         
         v_temp := NULL;
         BEGIN
              LOOP

                  FETCH p_Cursor INTO v_temp1, v_temp2, v_temp3, v_temp4, v_temp5, v_temp6;
                  EXIT WHEN p_Cursor%NOTFOUND;
                  
                  v_temp := v_temp || trim(v_temp1 || ' ' || v_temp2) || '; ';                          
          
              END LOOP;
         END;
         v_ok2 := Core_Template.replace_tag(v_return,   'MARKS', v_temp, 'WEBTOK@', TRUE);
           
         ----------------------------------------------- 
         --- Get Offense and Disposition Information --- 
         ----------------------------------------------- 
         -- v_temp1 = Charge/Citation, v_temp2 = Charge Date, v_temp3 = Disposition, v_temp4 = Disposition Date, v_temp5 = Arrest Date -- 
         Osi_Iafis.GetOffensesByRS(p_obj, p_Cursor);
         
         v_temp := NULL;
         v_Offense := 1;
         BEGIN
              LOOP

                  FETCH p_Cursor INTO v_temp1, v_temp2, v_temp3, v_temp4, v_temp5;
                  EXIT WHEN p_Cursor%NOTFOUND;
                  
                  IF v_Offense > 3 THEN

                    v_temp := v_temp || trim(v_temp1 || ' - ' || v_temp2) || '; ';
                    v_temp0 := v_temp0 || trim(v_temp3 || ' - ' || v_temp4) || '; ';
                  
                  ELSE

                    v_ok2 := Core_Template.replace_tag(v_return, 'CHARGE' || trim(v_Offense), v_temp1 || ' - ' || v_temp2, 'WEBTOK@', TRUE);
                    v_ok2 := Core_Template.replace_tag(v_return,  'DISPO' || trim(v_Offense), v_temp3 || ' - ' || v_temp4, 'WEBTOK@', TRUE);

                  END IF;
                  
                  v_Offense := v_Offense + 1;                          
          
              END LOOP;
         END;

         -- In case there are less offenses, make sure to clear out the WEBTOK@ tags --          
         FOR v_Offense IN 1..3
         LOOP

             v_ok2 := Core_Template.replace_tag(v_return, 'CHARGE' || trim(v_Offense), '', 'WEBTOK@', TRUE);
             v_ok2 := Core_Template.replace_tag(v_return,  'DISPO' || trim(v_Offense), '', 'WEBTOK@', TRUE);
             
         END LOOP;
         
         v_ok2 := Core_Template.replace_tag(v_return, 'ADDITIONALCHARGES', v_temp, 'WEBTOK@', TRUE);
         v_ok2 := Core_Template.replace_tag(v_return,  'ADDITIONALDISPOS', v_temp0, 'WEBTOK@', TRUE);

         ------------------- 
         --- Get Aliases --- 
         -------------------  
         -- v_temp1 = Last Name, v_temp2 = First Name, v_temp3 = Middle Name, v_temp4 = Suffix (Cadency) -- 
         Osi_Iafis.GetAliasesByRS(p_obj, p_Cursor);
         
         v_temp := NULL;
         BEGIN
              LOOP

                  FETCH p_Cursor INTO v_temp1, v_temp2, v_temp3, v_temp4;
                  EXIT WHEN p_Cursor%NOTFOUND;
                  
                  v_temp := v_temp || trim(trim(trim(v_temp1 || ' ' || v_temp2) || ' ' || v_temp3) || ' ' || v_temp4) || '; ';                          
          
              END LOOP;
         END;
         v_ok2 := Core_Template.replace_tag(v_return,   'ALIASES', v_temp, 'WEBTOK@', TRUE);
         
         v_load_images := Osi_Fingerprint.load_images_from_eft(p_obj, 'FINGERPRINT', 'YES');
   
         FOR A IN (SELECT * FROM T_OSI_A_FINGERPRINT_TEMP_PRINT WHERE fingerorpalm='F' AND obj=p_obj ORDER BY idx)
         LOOP
             v_ok2 := Core_Template.replace_tag(v_return,   'FINGER' || a.idx, Hex_Funcs.blob_to_hex(a.image), 'WEBTOK@', TRUE);

         END LOOP;   
         
         IF v_load_images = 'EFT FILE NOT FOUND' THEN

           DELETE FROM T_OSI_A_FINGERPRINT_TEMP_PRINT WHERE obj=p_obj AND fingerorpalm='F';
           COMMIT;
         
         END IF;
         
         RETURN v_return;

    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_fingerprint.FD249_Report: ' || SQLERRM);
            RETURN v_return;
    END FD249_Report;

    /* PalmPrint Report */
    FUNCTION PALMPRINT_Report(p_obj IN VARCHAR2) RETURN CLOB IS

            v_ok1               VARCHAR2(500);
            v_return            CLOB                                    := NULL;
            v_return_date       DATE;
            v_temp1             VARCHAR2(500);
            v_temp2             VARCHAR2(500);
            v_temp3             VARCHAR2(500);
            v_temp4             VARCHAR2(500);
            v_temp5             VARCHAR2(500);
            v_mime_type         T_CORE_TEMPLATE.mime_type%TYPE;
            v_mime_disp         T_CORE_TEMPLATE.mime_disposition%TYPE;
            v_load_images       VARCHAR2(500);   

    BEGIN
         -- Get latest template -- 
         v_ok1 := Core_Template.get_latest('PALMPRINT_REPORT', v_return, v_return_date, v_mime_type, v_mime_disp);

         -- Get Associated File ID --
         v_temp1 := ''; 
         FOR A IN (SELECT ID FROM T_OSI_FILE F,T_OSI_ASSOC_FLE_ACT A WHERE A.ACTIVITY_SID=p_obj AND F.SID=A.FILE_SID ORDER BY A.CREATE_ON DESC)
         LOOP         
             
             v_temp1 := A.ID;
             EXIT;
             
         END LOOP;
         v_ok1 := Core_Template.replace_tag(v_return,  'FILE_ID', v_temp1, 'WEBTOK@', TRUE);
   
         -- Add the Start and End * required for 3of9 Barcodes -- 
         IF v_temp1 IS NOT NULL AND v_temp1 != '' THEN
     
           v_temp1 := v_temp1 || '*' || v_temp1 || '*';
     
         END IF;
         v_ok1 := Core_Template.replace_tag(v_return,  'FILE_ID_BC', v_temp1, 'WEBTOK@', TRUE);
   
         -- Get Activity ID -- 
         FOR A IN (SELECT ID FROM T_OSI_ACTIVITY WHERE SID=p_obj)
         LOOP         
             
             v_temp1 := A.ID;
             EXIT;
             
         END LOOP;
         v_ok1 := Core_Template.replace_tag(v_return,  'ACT_ID', v_temp1, 'WEBTOK@', TRUE);
                           
         -------------------------  
         --- Get Offender Name --- 
         -------------------------  
         -- v_temp1 = Offender Last Name, v_temp2 = First Name, v_temp3 = Middle Name, v_temp4 = Suffix -- 
         Osi_Iafis.get_offender_name(p_obj, v_temp1, v_temp2, v_temp3, v_temp4);
         v_temp5 := v_temp1;

         IF v_temp2 IS NOT NULL AND v_temp2 != '-' THEN
     
           v_temp5 := v_temp5 || ', ' || v_temp2;
     
           IF v_temp3 IS NOT NULL AND v_temp3 != '-' THEN
       
             v_temp5 := v_temp5 || ' ' || v_temp3;
    
           END IF;
     
           IF v_temp4 IS NOT NULL AND v_temp4 != '-' THEN
       
             v_temp5 := v_temp5 || ' ' || v_temp4;
    
           END IF;
     
         END IF;
         v_ok1 := Core_Template.replace_tag(v_return, 'SUBJECT', v_temp5, 'WEBTOK@', TRUE);
         
         v_load_images := Osi_Fingerprint.load_images_from_eft(p_obj, 'PALMPRINT', 'YES');
   
         FOR A IN (SELECT * FROM T_OSI_A_FINGERPRINT_TEMP_PRINT WHERE fingerorpalm='P' AND obj=p_obj ORDER BY idx)
         LOOP
             v_ok1 := Core_Template.replace_tag(v_return,   'PP' || a.idx, Hex_Funcs.blob_to_hex(a.image), 'WEBTOK@', TRUE);

         END LOOP;   
         
         IF v_load_images = 'EFT FILE NOT FOUND' THEN

           DELETE FROM T_OSI_A_FINGERPRINT_TEMP_PRINT WHERE obj=p_obj AND fingerorpalm='P';
           COMMIT;
         
         END IF;
         
         RETURN v_return;

    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_fingerprint.FD249_Report: ' || SQLERRM);
            RETURN v_return;
   
    END PALMPRINT_Report;

END Osi_Fingerprint;
/







set define off;

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
    09-Nov-2012 Tim Ward        CR#3991-ORI, Address, POB State and Country wrong on printed FD-249
                                 Changed in GetContributorInfo.
                                                                                                    
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

         ---FOR A IN (SELECT ASSIGNED_UNIT FROM T_OSI_ACTIVITY A WHERE SID=p_obj)
         ---LOOP
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
                              U.UNIT_CODE='CC' AND
                              N.UNIT=U.SID AND
                              N.END_DATE IS NULL AND
                              N.UNIT=A.OBJ (+) AND
                              A.STATE=S.SID (+))
             LOOP

                 p_ORI := B.FBI_ORI_NUM;
                 p_CONTRIBUTOR_NAME := B.UNIT_NAME;
                 p_CONTRIBUTOR_ADDRESS := B.CITY || ', ' || B.NCIC_CODE || '.';

             END LOOP; 
     
         ---END LOOP;

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

