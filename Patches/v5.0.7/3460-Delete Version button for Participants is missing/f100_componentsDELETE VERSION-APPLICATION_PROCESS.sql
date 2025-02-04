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
--   Date and Time:   13:40 Friday July 20, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Delete Version
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
 
 
prompt Component Export: APP PROCESS 98918007150517114
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    delete_fail   exception;'||chr(10)||
'    v_temp        t_osi_participant_version.sid%type;'||chr(10)||
'    v_ok          varchar2(1);'||chr(10)||
'begin'||chr(10)||
'    v_temp := osi_participant.get_previous_version(:p0_obj_context);'||chr(10)||
''||chr(10)||
'    if (v_temp is not null) then'||chr(10)||
''||chr(10)||
'      v_ok := osi_participant.delete_version(:p0_obj_context);'||chr(10)||
'      :p0_obj_context := v_temp;'||chr(10)||
''||chr(10)||
'      if (v_ok <> ''Y'') then'||chr(10)||
''||chr(10)||
'        raise delete_fail;'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
'';

p:=p||''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 98918007150517114 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Version',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Could not delete this version.',
  p_process_when=> ':p0_obj_type_code like ''PART%'' and :request = ''DELETE_VERSION''',
  p_process_when_type=> 'PLSQL_EXPRESSION',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '20-Jul-2012 - Tim Ward - CR#3460-Delete Version button for Participants '||chr(10)||
'                          is missing.');
end;
 
null;
 
end;
/

COMMIT;
