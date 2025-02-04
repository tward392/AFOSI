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
--   Date and Time:   12:45 Wednesday April 27, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: GET_LOGOUT_URL
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
 
 
prompt Component Export: APP PROCESS 5416619653735709
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'htp.p(''wwv_flow_custom_auth_std.logout?p_this_flow='' || :APP_ID || ''&p_next_flow_page_sess='' || :APP_ID || '':102'');';

wwv_flow_api.create_flow_process(
  p_id => 5416619653735709 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'GET_LOGOUT_URL',
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
--   Date and Time:   12:43 Wednesday April 27, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     AUTH SETUP: OSI AUTHENTICATION
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
 
 
prompt Component Export: AUTH SETUP 88819408478057089
 
prompt  ...authentication schemes
--
prompt  ......scheme 88819408478057089
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1 := null;
s2:=s2||'return Core_Context.SET_CONTEXT(:APP_USER)';

s3 := null;
s4:=s4||'return CORE_CONTEXT.LOGIN';

s5:=s5||':SUCCESS_MSG := core_util.get_config(''OSI.SUCCESS_MSG'');'||chr(10)||
':FAILURE_MSG := core_util.get_config(''OSI.FAILURE_MSG'');'||chr(10)||
':HELP_PATH := core_util.get_config(''OSI.HELP_FILE_PATH'');'||chr(10)||
':FMT_DATE := core_util.get_config(''CORE.DATE_FMT_DAY'');'||chr(10)||
':FMT_TIME := core_util.get_config(''OSI.DATE_FMT_TIME'');'||chr(10)||
':FMT_CF_CURRENCY := core_util.get_config(''CFUNDS.CURRENCY'');'||chr(10)||
':BTN_SAVE := core_util.get_config(''OSI.BTN_SAVE'');'||chr(10)||
':BTN';

s5:=s5||'_CREATE := core_util.get_config(''OSI.BTN_CREATE'');'||chr(10)||
':BTN_DELETE := core_util.get_config(''OSI.BTN_DELETE'');'||chr(10)||
':BTN_CANCEL := core_util.get_config(''OSI.BTN_CANCEL'');'||chr(10)||
':BTN_ADD := core_util.get_config(''OSI.BTN_ADD'');'||chr(10)||
':BTN_OK := core_util.get_config(''OSI.BTN_OK'');'||chr(10)||
':ICON_EDIT := core_util.get_config(''OSI.ICON_EDIT'');'||chr(10)||
':ICON_LOCATOR := core_util.get_config(''OSI.ICON_LOCATOR'');'||chr(10)||
':ICON_ADDRESS := core_util.get_';

s5:=s5||'config(''OSI.ICON_ADDRESS'');'||chr(10)||
':ICON_MAGNIFY := core_util.get_config(''OSI.ICON_MAGNIFY'');'||chr(10)||
':ICON_VLT := core_util.get_config(''OSI.ICON_VLT'');'||chr(10)||
':ICON_CREATE_PERSON := core_util.get_config(''OSI.ICON_CREATE_PERSON'');'||chr(10)||
':ICON_DATE := core_util.get_config(''OSI.ICON_DATE'');'||chr(10)||
':OSI_VERSION := core_util.get_config(''OSI.VERSION'');'||chr(10)||
':OSI_BANNER := core_util.get_config(''CORE.BANNER'');'||chr(10)||
':DESKTOP_TITLE := core_util.get_c';

s5:=s5||'onfig(''OSI.DESKTOP_TITLE'') || '' - '' || core_util.get_config(''CORE.BANNER'');'||chr(10)||
':DISABLE_SELECT := core_util.get_config(''OSI.DISABLE_SELECT'');'||chr(10)||
':DISABLE_RADIO := core_util.get_config(''OSI.DISABLE_RADIO'');'||chr(10)||
':DISABLE_TEXT := core_util.get_config(''OSI.DISABLE_TEXT'');'||chr(10)||
':DISABLE_TEXTAREA := core_util.get_config(''OSI.DISABLE_TEXTAREA'');'||chr(10)||
'select sid'||chr(10)||
'  into :USER_SID'||chr(10)||
'  from t_core_personnel'||chr(10)||
'where login_id = :APP_';

s5:=s5||'USER;'||chr(10)||
':USER_URL := osi_object.get_object_url(:USER_SID);'||chr(10)||
':FEEDBACK_EMAIL_ADDRESS := core_util.get_config(''OSI.FEEDBACK_EMAIL_ADDRESS'');'||chr(10)||
':AUDITING := core_util.get_config(''OSI.AUDITING'');'||chr(10)||
':IMG_BADGE := CORE_UTIL.GET_CONFIG(''OSI.IMG_BADGE'');'||chr(10)||
':ICON_ACTIVITY := CORE_UTIL.GET_CONFIG(''OSI.ICON_ACTIVITY'');'||chr(10)||
':ICON_FILE := CORE_UTIL.GET_CONFIG(''OSI.ICON_FILE'');'||chr(10)||
':ICON_FTS := CORE_UTIL.GET_CONFIG(''OSI.ICON_FT';

s5:=s5||'S'');'||chr(10)||
':ICON_NOTIFICATIONS := CORE_UTIL.GET_CONFIG(''OSI.ICON_NOTIFICATIONS'');'||chr(10)||
':FEEDBACK_URL := CORE_UTIL.GET_CONFIG(''OSI.FEEDBACK_URL'');'||chr(10)||
':BTN_EXPORT := ''Export to Excel'';'||chr(10)||
''||chr(10)||
'--- Save CAC Card Common Name ---'||chr(10)||
'if :P0_SSL_CLIENT_S_DN_CN is not null then'||chr(10)||
''||chr(10)||
'  update t_osi_personnel '||chr(10)||
'        set SSL_CLIENT_S_DN_CN=:P0_SSL_CLIENT_S_DN_CN'||chr(10)||
'           where sid=:USER_SID;'||chr(10)||
'  commit;'||chr(10)||
''||chr(10)||
'end if;';

wwv_flow_api.create_auth_setup (
  p_id=> 88819408478057089 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'OSI AUTHENTICATION',
  p_description=>'Authenticate Users based on Username and Password stored in the database.',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'101',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'N',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'javascript:confirmLogOut(''Are you sure you want to Log Out?'');',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

COMMIT;

