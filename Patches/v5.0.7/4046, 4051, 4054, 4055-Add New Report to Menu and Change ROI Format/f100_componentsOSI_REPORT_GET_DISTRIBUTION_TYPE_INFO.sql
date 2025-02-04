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
--   Date and Time:   10:19 Wednesday September 12, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: OSI_REPORT_GET_DISTRIBUTION_TYPE_INFO
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
 
 
prompt Component Export: APP PROCESS 16517810615441835
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       pType varchar2(32000);'||chr(10)||
'       pAmount varchar2(1000);'||chr(10)||
'       pSeq varchar2(1000);'||chr(10)||
'       pWithExhibits varchar2(1000);'||chr(10)||
'       pCreateBySID  varchar2(20);'||chr(10)||
'       pSID varchar2(20);'||chr(10)||
'       pDistText varchar2(50);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if (apex_application.g_x02=''0'') then'||chr(10)||
''||chr(10)||
'       select default_amount,seq,withexhibits,create_by_sid,sid,distribution into pAmount,pSeq,pWithExhibits,pCreateBySID,pS';

p:=p||'ID,pDistText'||chr(10)||
'         from t_osi_report_distribution_type '||chr(10)||
'         where sid=apex_application.g_x01; '||chr(10)||
''||chr(10)||
'       htp.p(pAmount || ''|'' || pSeq || ''|'' || pWithExhibits || ''|'' || pCreateBySID || ''|'' || pSID || ''|'' || pDistText );'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       select amount,seq,withexhibits,'''',sid,distribution into pAmount,pSeq,pWithExhibits,pCreateBySID,pSID,pDistText'||chr(10)||
'         from t_osi_report_distribution'||chr(10)||
'     ';

p:=p||'    where sid=apex_application.g_x02; '||chr(10)||
''||chr(10)||
'       htp.p(pAmount || ''|'' || pSeq || ''|'' || pWithExhibits || ''|'' || pCreateBySID || ''|'' || pSID || ''|'' || pDistText );'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         htp.p('''');'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 16517810615441835 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'OSI_REPORT_GET_DISTRIBUTION_TYPE_INFO',
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
