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
--   Date and Time:   14:29 Friday February 25, 2011
--   Exported By:     JASON
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Check_Legacy_Relations
--   Manifest End
--   Version: 3.2.1.00.12
 
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
 
 
prompt Component Export: APP PROCESS 22610431448340376
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_new_person      varchar2(20) := apex_application.g_x01;'||chr(10)||
'    v_source_person   varchar2(20);'||chr(10)||
'    v_rel_cnt         number       := 0;'||chr(10)||
'    v_result          varchar2(10);'||chr(10)||
'begin'||chr(10)||
'    begin'||chr(10)||
'        select old_sid'||chr(10)||
'          into v_source_person'||chr(10)||
'          from t_osi_migration'||chr(10)||
'         where new_sid = v_new_person and type = ''PARTICIPANT'';'||chr(10)||
'    exception'||chr(10)||
'        when no_data_found then'||chr(10)||
'      ';

p:=p||'      core_logger.log_it(''CHECK_LEGACY_RELATIONS'','||chr(10)||
'                               ''error: unable to locate a legacy participant for '' || v_new_person);'||chr(10)||
'            v_result := ''N'';'||chr(10)||
'    end;'||chr(10)||
''||chr(10)||
'    /* count any legacy relationships for v_source_person, excluding those previously migrated */'||chr(10)||
'    select count(this_person)'||chr(10)||
'      into v_rel_cnt'||chr(10)||
'      from ref_v_person_relation'||chr(10)||
'     where this_person = v_';

p:=p||'source_person and SID not in(select old_sid'||chr(10)||
'                                                          from t_osi_migration'||chr(10)||
'                                                         where type = ''RELATIONSHIP'');'||chr(10)||
''||chr(10)||
'    if v_rel_cnt = 0 then'||chr(10)||
'        v_result := ''N'';'||chr(10)||
'    else'||chr(10)||
'        v_result := ''Y'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    htp.p(v_result);'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 22610431448340376 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check_Legacy_Relations',
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
