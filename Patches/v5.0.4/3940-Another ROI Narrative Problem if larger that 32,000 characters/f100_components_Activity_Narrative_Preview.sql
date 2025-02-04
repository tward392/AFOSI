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
--   Date and Time:   12:38 Thursday September 15, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Activity_Narrative_Preview
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
 
 
prompt Component Export: APP PROCESS 7304609334316628
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'  l_narrative     clob;'||chr(10)||
'  l_activity_sid  varchar2(200) := apex_application.g_x01;'||chr(10)||
'  l_limit         NUMBER := 32767;'||chr(10)||
'  v_text_amt      BINARY_INTEGER := l_limit;'||chr(10)||
'  v_text_buffer   varchar2(32767);'||chr(10)||
'  v_text_pos      NUMBER := 1;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'     --- Create a tempory LOB to place our html in ---'||chr(10)||
'     dbms_lob.CREATETEMPORARY(lob_loc => l_narrative'||chr(10)||
'        , cache   => false'||chr(10)||
'        , dur     =';

p:=p||'> dbms_lob.session);'||chr(10)||
'  '||chr(10)||
'     l_narrative := '||chr(10)||
'           osi_investigation.Activity_Narrative_Preview(l_activity_sid,''HTML'');'||chr(10)||
' '||chr(10)||
' '||chr(10)||
'     owa_util.mime_header(''text/http'', false);'||chr(10)||
'     htp.p(''Cache-Control: no-cache'');'||chr(10)||
'     htp.p(''Pragma: no-cache'');'||chr(10)||
'     owa_util.http_header_close();'||chr(10)||
'    '||chr(10)||
'     --- Now to loop through the CLOB in 32k intervals       ---'||chr(10)||
'     --- so we can htp.p the string of data back';

p:=p||' on the page ---'||chr(10)||
' '||chr(10)||
'     LOOP'||chr(10)||
'         v_text_buffer := DBMS_LOB.SUBSTR(l_narrative, v_text_amt, v_text_pos);'||chr(10)||
'         EXIT WHEN v_text_buffer IS NULL;'||chr(10)||
''||chr(10)||
'         --- process the text and prepare to read again ---'||chr(10)||
'         htp.p(v_text_buffer);'||chr(10)||
'         v_text_pos := v_text_pos + v_text_amt;'||chr(10)||
''||chr(10)||
'     END LOOP;'||chr(10)||
' '||chr(10)||
'     --- Kill the temporary LOB ---   '||chr(10)||
'     DBMS_LOB.FREETEMPORARY(lob_loc => l_narrative);';

p:=p||''||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 7304609334316628 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Activity_Narrative_Preview',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '15-Sep-2011 - Tim Ward - CR#3940 - Send in 32K chunks now since we know '||chr(10)||
'                         htp.p can only handle 32K at once.');
end;
 
null;
 
end;
/

COMMIT;
