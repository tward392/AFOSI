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
--   Date and Time:   09:07 Thursday February 3, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_LOCATOR
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
 
 
prompt Component Export: SHORTCUTS 94262633075112718
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'   function logInfo(pMsg){'||chr(10)||
'      var get = new htmldb_Get(null,'||chr(10)||
'                            $v(''pFlowId''),'||chr(10)||
'                            ''APPLICATION_PROCESS=Log_Info'','||chr(10)||
'                            $v(''pFlowStepId''));'||chr(10)||
'      get.addParam(''x01'',pMsg);'||chr(10)||
'      gReturn = get.get();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function recentAccess(pObj){'||chr(10)||
'      var get = new htmldb_Get(nu';

c1:=c1||'ll,'||chr(10)||
'                               $v(''pFlowId''),'||chr(10)||
'                               ''APPLICATION_PROCESS=RECENT_ACCESS'','||chr(10)||
'                               $v(''pFlowStepId''));'||chr(10)||
'      get.addParam(''x01'',pObj);'||chr(10)||
'      gReturn = get.get();'||chr(10)||
'   }'||chr(10)||
'   //var selectionList = document.getElementById(''P0_LOC_SELECTIONS'').value;'||chr(10)||
'   function toggleCheckbox(pThis){'||chr(10)||
'       var get = new htmldb_Get(null,'||chr(10)||
'                 ';

c1:=c1||'               $v(''pFlowId''),'||chr(10)||
'                                ''APPLICATION_PROCESS=LOC_MULTISELECT'','||chr(10)||
'                                $v(''pFlowStepId''));  '||chr(10)||
'       get.addParam(''x01'',pThis.value);'||chr(10)||
'       get.addParam(''x02'',pThis.checked ? ''Y'':''N'');'||chr(10)||
'       gReturn = get.get();'||chr(10)||
'    '||chr(10)||
'       selectionList=gReturn;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function passBack(selectedValue, returnItem){'||chr(10)||
'      if (selectedValue != "theList';

c1:=c1||'"){'||chr(10)||
'         recentAccess(selectedValue);'||chr(10)||
'         window.top.document.getElementById(returnItem).value = selectedValue;'||chr(10)||
'      } else {'||chr(10)||
'         if (selectionList != undefined)'||chr(10)||
'           window.top.document.getElementById(returnItem).value = '||chr(10)||
'                                    selectionList.replace(/^\s+|\s+$/g,"");'||chr(10)||
'      }'||chr(10)||
'      window.top.doSubmit(returnItem);'||chr(10)||
'      //close();'||chr(10)||
'   } '||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 94262633075112718 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_LOCATOR',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
