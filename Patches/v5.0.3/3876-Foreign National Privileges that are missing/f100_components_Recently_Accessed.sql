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
--   Date and Time:   10:21 Wednesday June 8, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Recently Accessed
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
 
 
prompt Component Export: APP PROCESS 6120009213511126
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'  if :AUDITING = ''ON'' then'||chr(10)||
'    log_info(''Launch:'' || :p0_obj || '' - '' || core_obj.get_tagline(:p0_obj));'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  update t_osi_personnel_recent_objects'||chr(10)||
'     set times_accessed= times_accessed+ 1,'||chr(10)||
'         last_accessed= sysdate'||chr(10)||
'   where personnel = :user_sid'||chr(10)||
'     and obj = :p0_obj;'||chr(10)||
''||chr(10)||
'  if sql%rowcount = 0 then'||chr(10)||
'      insert into t_osi_personnel_recent_objects'||chr(10)||
'              (personnel, '||chr(10)||
'   ';

p:=p||'            obj, '||chr(10)||
'               unit, '||chr(10)||
'               times_accessed, '||chr(10)||
'               last_accessed)'||chr(10)||
'      values (:user_sid, '||chr(10)||
'              :p0_obj, '||chr(10)||
'              osi_personnel.get_current_unit(:user_sid), '||chr(10)||
'              1, '||chr(10)||
'              sysdate);'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 6120009213511126 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1.1,
  p_process_point => 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Recently Accessed',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Error logging recently accessed object.',
  p_process_when=> '(:request = ''OPEN'' and :p0_obj is not null and :p0_AUTHORIZED = ''Y'') or :APP_PAGE_ID=30101',
  p_process_when_type=> 'PLSQL_EXPRESSION',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Added Page 30101 to allow adding to recent objects.');
end;
 
null;
 
end;
/

COMMIT;
