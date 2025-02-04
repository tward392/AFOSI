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
--   Date and Time:   07:42 Thursday August 9, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: GET_LERC_DEFAULT_TITLE_NARRATIVE
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
 
 
prompt Component Export: APP PROCESS 12229714145416338
 
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
'           vDocType  varchar2(20)    := apex_application.g_x01;'||chr(10)||
'            vResult  varchar2(10)    := apex_application.g_x02;'||chr(10)||
'       vObjTypeCode  varchar2(100)   := apex_application.g_x03;'||chr(10)||
'  vDefaultNarrative  varchar2(4000);'||chr(10)||
'   vTypeDescription  varchar2(4000);'||chr(10)||
'          vTypeCode  varchar2(4000);'||chr(10)||
'            vReturn  varchar2(4000);'||chr(10)||
'            vPrefix  varchar2(4000)  := '''';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'';

p:=p||'     select description,code into vTypeDescription,vTypeCode from t_osi_reference where sid=vDocType;'||chr(10)||
'     select default_narrative into vDefaultNarrative from t_osi_a_rc_dr_results where code=vResult;'||chr(10)||
''||chr(10)||
'     if (vObjTypeCode = ''ACT.RECORDS_CHECK'') then'||chr(10)||
''||chr(10)||
'       vReturn := ''Records Check of SUBJECT'' || ''~`~`~`~`'' || replace(vDefaultNarrative,''~RECORD_TYPE~'',vTypeDescription);'||chr(10)||
''||chr(10)||
'     elsif (vObjTypeCo';

p:=p||'de = ''ACT.DOCUMENT_REVIEW'') then'||chr(10)||
'          '||chr(10)||
'          case '||chr(10)||
''||chr(10)||
'              when vTypeCode in (''AR'',''ARMS'',''CF'',''CR'',''DCAA'',''DEIDS'',''HC'',''LAR'',''SADR'',''TR'') then'||chr(10)||
''||chr(10)||
'                  vPrefix := ''the '';'||chr(10)||
''||chr(10)||
'              else'||chr(10)||
''||chr(10)||
'                  vPrefix := '''';'||chr(10)||
''||chr(10)||
'          end case;'||chr(10)||
''||chr(10)||
'          case '||chr(10)||
''||chr(10)||
'              when vTypeCode in (''AR'',''ARMS'',''CF'',''CR'',''DCAA'',''DEIDS'',''DR'',''EDUTRAIN'',''FAR'',''FR'',''HC'',''LAR'',''';

p:=p||'MR'',''MHR'',''MPR'',''SADR'',''TR'') then'||chr(10)||
''||chr(10)||
'                  vDefaultNarrative := replace(vDefaultNarrative,'' records '','' '');'||chr(10)||
''||chr(10)||
'              else'||chr(10)||
'                  null;'||chr(10)||
''||chr(10)||
'          end case;'||chr(10)||
''||chr(10)||
'          vReturn := ''Document Review of SUBJECT'' || ''~`~`~`~`'' || replace(vDefaultNarrative,''~RECORD_TYPE~'',vPrefix || vTypeDescription);'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     htp.p(vReturn);'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         htp';

p:=p||'.p(sqlerrm);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 12229714145416338 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'GET_LERC_DEFAULT_TITLE_NARRATIVE',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '20-Mar-2012 - Tim Ward - CR#3696 - Created for Multi Records Check Creation.');
end;
 
null;
 
end;
/

COMMIT;
