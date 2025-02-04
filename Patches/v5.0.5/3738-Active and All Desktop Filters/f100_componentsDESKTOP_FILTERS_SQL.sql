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
--   Date and Time:   12:50 Thursday January 5, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: DESKTOP_FILTERS_SQL
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
 
 
prompt Component Export: APP PROCESS 1902010004942942
 
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
'       pVarCount number := 0;'||chr(10)||
'       pWorkSheetID varchar2(4000);'||chr(10)||
'       pAPPUSER varchar2(4000);'||chr(10)||
'       pInstance varchar2(4000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if apex_collection.collection_exists(p_collection_name=>apex_application.g_x01) then'||chr(10)||
'    '||chr(10)||
'    apex_collection.delete_collection(p_collection_name=>apex_application.g_x01);'||chr(10)||
'  '||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  for a in (select * from table(split(apex_application.g_x10,''';

p:=p||'~'')))'||chr(10)||
'  loop'||chr(10)||
'      if pVarCount=0 then'||chr(10)||
''||chr(10)||
'        pWorkSheetID := a.column_value;'||chr(10)||
''||chr(10)||
'      elsif pVarCount=1 then'||chr(10)||
''||chr(10)||
'           pAPPUSER := a.column_value;'||chr(10)||
''||chr(10)||
'      elsif pVarCount=2 then'||chr(10)||
''||chr(10)||
'           pInstance := a.column_value;'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
'      pVarCount := pVarCount+1;'||chr(10)||
''||chr(10)||
'  end loop;'||chr(10)||
''||chr(10)||
'  APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY('||chr(10)||
'      p_collection_name=>apex_application.g_x01,'||chr(10)||
'      p_query => OSI_';

p:=p||'DESKTOP.DesktopSQL(apex_application.g_x02, '||chr(10)||
'                                        :user_sid, '||chr(10)||
'                                        apex_application.g_x04, '||chr(10)||
'                                        apex_application.g_x05, '||chr(10)||
'                                        apex_application.g_x06, '||chr(10)||
'                                        apex_application.g_x07, '||chr(10)||
'                                        apex';

p:=p||'_application.g_x08, '||chr(10)||
'                                        apex_application.g_x09,'||chr(10)||
'                                        ''10000'','||chr(10)||
'                                        pWorkSheetID, '||chr(10)||
'                                        pAPPUSER, '||chr(10)||
'                                        pInstance));'||chr(10)||
''||chr(10)||
'End;';

wwv_flow_api.create_flow_process(
  p_id => 1902010004942942 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP_FILTERS_SQL',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '23-Jun-2011 - Tim Ward - CR#3868 - Added New Parameter for Return Item Name, '||chr(10)||
'                                   this is to support Locators.');
end;
 
null;
 
end;
/

COMMIT;
