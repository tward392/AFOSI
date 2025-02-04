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
 
        v_count        NUMBER         := 0;
        v_arrest_date  DATE           := NULL;
        v_msg          VARCHAR2(4000) := NULL;
        v_file_sid     VARCHAR2(20)   := NULL;
        v_counter      NUMBER         := 1;
 
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

         IF v_temp1 IS NOT NULL AND v_temp1 != '' THEN

           v_ok2 := Core_Template.replace_tag(v_return, 'POB', v_temp1, 'WEBTOK@', TRUE);

         ELSIF v_temp2 IS NOT NULL AND v_temp2 != '' THEN          

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
