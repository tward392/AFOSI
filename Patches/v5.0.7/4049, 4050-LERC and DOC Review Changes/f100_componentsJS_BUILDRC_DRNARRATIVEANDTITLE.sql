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
--   Date and Time:   14:10 Wednesday August 1, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_BUILDRC_DRNARRATIVEANDTITLE
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
 
 
prompt Component Export: SHORTCUTS 15093629032910985
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="javascript">'||chr(10)||
'function buildRC_DRNarrativeandTitle(pTypeList, pResultList, pNarrative, pTitle, pObjectType)'||chr(10)||
'{'||chr(10)||
' var docTypetxt = $(''#''+pTypeList+'' > option:selected'').text();'||chr(10)||
' var resultstxt = $(''#''+pResultList+'' > option:selected'').text();'||chr(10)||
' var docTypeval = $(''#''+pTypeList+'' > option:selected'').val();'||chr(10)||
' var resultsval = $(''#''+pResultList+'' > option:selected'').val();'||chr(10)||
' var ObjectType';

c1:=c1||'txt = $(''#''+pObjectType).val();'||chr(10)||
''||chr(10)||
' if(docTypetxt!=''- Select -'' && resultstxt!=''- Select -'')'||chr(10)||
'   {'||chr(10)||
'    var get = new htmldb_Get(null,'||chr(10)||
'                             $v(''pFlowId''),'||chr(10)||
'                             ''APPLICATION_PROCESS=GET_LERC_DEFAULT_TITLE_NARRATIVE'','||chr(10)||
'                             $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
'    get.addParam(''x01'',docTypeval);'||chr(10)||
'    get.addParam(''x02'',resultsval);'||chr(10)||
'    get.addParam';

c1:=c1||'(''x03'',ObjectTypetxt);'||chr(10)||
' '||chr(10)||
'    gReturn = $.trim(get.get());'||chr(10)||
'    var placeHolder = gReturn.indexOf(''~`~`~`~`'');'||chr(10)||
''||chr(10)||
'    $s(pTitle,gReturn.substring(0,placeHolder));'||chr(10)||
'    $s(pNarrative,gReturn.substring(placeHolder+8));'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 15093629032910985 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_BUILDRC_DRNARRATIVEANDTITLE',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
