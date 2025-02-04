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
--   Date and Time:   09:01 Monday April 30, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_CREATE_OBJECT
--   Manifest End
--   Version: 3.2.1.00.10
 
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>1046323504969601);
 
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
 
 
prompt Component Export: SHORTCUTS 93901124260008571
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'function checkForPriv(pAction,pObjType,pPersonnel,pUnit){'||chr(10)||
'   var get = new htmldb_Get(null,'||chr(10)||
'                            $v(''pFlowId''),'||chr(10)||
'                            ''APPLICATION_PROCESS=Check_For_Priv'','||chr(10)||
'                            $v(''pFlowStepId''));  '||chr(10)||
'   get.addParam(''x01'',pAction);'||chr(10)||
'   get.addParam(''x02'',pObjType);'||chr(10)||
'   get.addParam(''x03'',pPersonn';

c1:=c1||'el);'||chr(10)||
'   get.addParam(''x04'',pUnit);'||chr(10)||
'   gReturn = get.get();'||chr(10)||
'   '||chr(10)||
'   return gReturn.substr(0,1);'||chr(10)||
'}'||chr(10)||
'function createObject(pPage, pObjType, pOthNames, pOthVals){'||chr(10)||
'   if(checkForPriv(''CREATE'',pObjType)==''Y''){'||chr(10)||
'      var vPageName = Date.parse(Date().toString());'||chr(10)||
'      var vItemNames = ''P0_OBJ,P0_OBJ_TYPE_CODE'';'||chr(10)||
'      var vItemVals = '','' + pObjType;'||chr(10)||
'      if (pOthNames != undefined) vItemNames = vItemNames';

c1:=c1||' + '','' + pOthNames;'||chr(10)||
'      if (pOthVals != undefined) vItemVals = vItemVals + '','' + pOthVals;'||chr(10)||
''||chr(10)||
'      newWindow({name : vPageName, '||chr(10)||
'	         page : pPage, '||chr(10)||
'	         clear_cache : pPage, '||chr(10)||
'	         request : ''CREATE_OBJ'', '||chr(10)||
'	         item_names : vItemNames, '||chr(10)||
'	         item_values : vItemVals});'||chr(10)||
'   } else {'||chr(10)||
'      alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 93901124260008571 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_CREATE_OBJECT',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'function createParticWidget(particItem){'||chr(10)||
'   var itemNames = ''P30000_MODE,P30000_RETURN_ITEM'';'||chr(10)||
'   var itemVals = ''FROM_OBJ,'' + particItem;'||chr(10)||
''||chr(10)||
'   newWindow({page:30000, '||chr(10)||
'              request:''CREATE_OBJ'','||chr(10)||
'              name:''PARTICIPANT&P0_OBJ.'','||chr(10)||
'              clear_cache:''30000'','||chr(10)||
'              item_names:itemNames,'||chr(10)||
'              item_values:itemVals});'||chr(10)||
'}'||chr(10)||
'</script>',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
