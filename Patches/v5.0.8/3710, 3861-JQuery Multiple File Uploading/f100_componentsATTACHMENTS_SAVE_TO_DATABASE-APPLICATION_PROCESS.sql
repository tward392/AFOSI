set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   11:20 Tuesday September 25, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: ATTACHMENTS_SAVE_TO_DATABASE
--   Manifest End
--   Version: 3.2.0.00.27
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
 
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>apex_util.find_security_group_id(user));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en-us'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2009.01.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := 100;
   wwv_flow_api.g_id_offset := 0;
null;
 
end;
/

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: APP PROCESS 14692215365317656
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       pObjSID        varchar2(32000);'||chr(10)||
'       pFileName      varchar2(32000);'||chr(10)||
'       pJustFileName  varchar2(32000);'||chr(10)||
'       pUserSID       varchar2(32000);'||chr(10)||
'       pMIMEType      varchar2(32000);'||chr(10)||
''||chr(10)||
'       v_dest_loc         BLOB;'||chr(10)||
'       v_src_loc          BFILE;'||chr(10)||
'       v_no_file_found    VARCHAR2(1) := ''N'';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
' '||chr(10)||
'     pObjSID    := apex_application.g_x01; '||chr(10)||
'     pUserSID   := apex_applicat';

p:=p||'ion.g_x02; '||chr(10)||
'     pFileName  := apex_application.g_x03; '||chr(10)||
'     pMIMEType  := apex_application.g_x04; '||chr(10)||
'     '||chr(10)||
'     for a in (select * from table(split(pFileName,''/'')))'||chr(10)||
'     loop'||chr(10)||
'         pJustFilename := a.column_value;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     pJustFilename := replace(pJustFilename, pUserSID, '''');'||chr(10)||
''||chr(10)||
''||chr(10)||
'     v_src_loc := BFILENAME(''ATTACHMENTS_TEMP'', pUserSID || pJustFilename);'||chr(10)||
'  '||chr(10)||
'     BEGIN'||chr(10)||
''||chr(10)||
'          dbms';

p:=p||'_lob.OPEN(v_src_loc, dbms_lob.lob_readonly);'||chr(10)||
''||chr(10)||
'     EXCEPTION'||chr(10)||
'              WHEN OTHERS THEN'||chr(10)||
'                  '||chr(10)||
'                  v_no_file_found := ''Y'';'||chr(10)||
''||chr(10)||
'     END;'||chr(10)||
'                 '||chr(10)||
'     IF v_no_file_found = ''N'' THEN'||chr(10)||
''||chr(10)||
'       dbms_lob.createtemporary(v_dest_loc, TRUE, dbms_lob.SESSION);'||chr(10)||
'       dbms_lob.OPEN(v_dest_loc, dbms_lob.lob_readwrite);'||chr(10)||
'       dbms_lob.loadfromfile(dest_lob       => v_dest_l';

p:=p||'oc,'||chr(10)||
'                             src_lob        => v_src_loc,'||chr(10)||
'                             amount         => dbms_lob.getlength(v_src_loc));'||chr(10)||
'       dbms_lob.CLOSE(v_src_loc);'||chr(10)||
' '||chr(10)||
'       insert into t_osi_attachment (obj,'||chr(10)||
'                                     storage_loc_type,'||chr(10)||
'                                     description,'||chr(10)||
'                                     source,'||chr(10)||
'                               ';

p:=p||'      creating_personnel,'||chr(10)||
'                                     content,'||chr(10)||
'                                     mime_type) values'||chr(10)||
'                                    (pObjSID,'||chr(10)||
'                                     ''DB'','||chr(10)||
'                                     pJustFileName,'||chr(10)||
'                                     pJustFileName,'||chr(10)||
'                                     pUserSID,'||chr(10)||
'                                 ';

p:=p||'    v_dest_loc,'||chr(10)||
'                                     pMIMEType);'||chr(10)||
' '||chr(10)||
'       dbms_lob.CLOSE(v_dest_loc);'||chr(10)||
'     '||chr(10)||
'       UTL_FILE.fremove(''ATTACHMENTS_TEMP'', pUserSID || pJustFilename);'||chr(10)||
'                 '||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         htp.p(sqlerrm);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 14692215365317656 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'ATTACHMENTS_SAVE_TO_DATABASE',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

COMMIT;
