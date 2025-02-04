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
--   Date and Time:   07:54 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_JQUERY_OPENLOCATOR
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>1044521331756659);
 
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
 
 
prompt Component Export: SHORTCUTS 10824323204693450
 
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
'function openLocator(pPage,pReturnItemName,pMulti,pExclude,pRequest,pOthNames,pOthVals,pTitle,pType,pOBJ,pLocateMany)'||chr(10)||
'{'||chr(10)||
' var vMulti = (pMulti == undefined) ? ''N'' : pMulti;'||chr(10)||
' var vExclude = (pExclude == undefined) ? '''' : pExclude;'||chr(10)||
' var vRequest = (pRequest == undefined) ? ''OPEN'' : pRequest;'||chr(10)||
' var vTitle = (pTitle == undefined) ? ''Locator'' : pTitl';

c1:=c1||'e;'||chr(10)||
' var vOthNames = (pOthNames == undefined || pOthNames=='''') ? '''' : '',''+pOthNames;'||chr(10)||
' var vOthVals = (pOthVals == undefined || pOthVals=='''') ? '''' : '',''+pOthVals;'||chr(10)||
' var vDebug = ''NO'';'||chr(10)||
' var vLocateMany= (pLocateMany == undefined) ? ''N'' : pLocateMany;'||chr(10)||
''||chr(10)||
' var iframesource = ''<div width="100%" id="LocatorDiv" class="LocatorDiv" name="LocatorDiv"><iframe width="100%" '' +'||chr(10)||
'                    ''height="100%" ';

c1:=c1||''' +'||chr(10)||
'                    ''frameborder="0" '' +'||chr(10)||
'                    ''name="Locator" id="Locator" class="Locator" '' +'||chr(10)||
'                    ''allowtransparencty="true" '' +'||chr(10)||
'                    ''style="background-color: transparent;" '' +'||chr(10)||
'                    ''src="f?p=&APP_ID.:''+pPage+'':&SESSION.:''+vRequest+'':''+vDebug+'':''+pPage+'':P''+pPage+''_OBJECT_TYPE,P''+pPage+''_OBJ,P''+pPage+''_RETURN_ITEM,P''+pPage+''_MULTI,';

c1:=c1||'P''+pPage+''_LOCATEMANY,P''+pPage+''_EXCLUDE''+vOthNames+'':''+'||chr(10)||
'                    pType+'',''+pOBJ+'',''+pReturnItemName+'',''+vMulti+'',''+vLocateMany+'',''+vExclude+vOthVals+'':"></iframe></div>'';'||chr(10)||
''||chr(10)||
' var vInnerWidth = $(window).width();'||chr(10)||
' var vInnerHeight = $(window).height();'||chr(10)||
''||chr(10)||
' var xRatio = vInnerWidth /960;'||chr(10)||
' var yRatio = vInnerHeight /550;'||chr(10)||
' var xRatio2 = vInnerWidth / 1371;'||chr(10)||
''||chr(10)||
' if(xRatio < 1.1)'||chr(10)||
'   xRatio=1.1;'||chr(10)||
' '||chr(10)||
' ';

c1:=c1||'if(yRatio < 1.1)'||chr(10)||
'   yRatio=1.1;'||chr(10)||
''||chr(10)||
' if(xRatio2 < 1.05)'||chr(10)||
'   xRatio2=1.05;'||chr(10)||
''||chr(10)||
' if(vMulti==''Y'' || vLocateMany==''Y'')'||chr(10)||
'   {'||chr(10)||
'    var execute = function() { document.getElementById(''Locator'').contentWindow.passBack(''theList'',pReturnItemName); }'||chr(10)||
''||chr(10)||
'    var cancel = function() { $dialog.dialog(''close''); }'||chr(10)||
''||chr(10)||
'                                  '||chr(10)||
'    var $dialog = $(iframesource)'||chr(10)||
'                           .dialog({'||chr(10)||
'   ';

c1:=c1||'                                 autoOpen: false,'||chr(10)||
'                                    title: pTitle,'||chr(10)||
'                                    position: ''center'','||chr(10)||
'                                    width: $(window).width()/xRatio2,'||chr(10)||
'                                    height: $(window).height()/yRatio,'||chr(10)||
'                                    modal: true,'||chr(10)||
'                                    buttons: {"Return';

c1:=c1||' Selections":  execute, "Cancel":  cancel }'||chr(10)||
'                                 });'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    var $dialog = $(iframesource)'||chr(10)||
'                           .dialog({'||chr(10)||
'                                    autoOpen: false,'||chr(10)||
'                                    title: pTitle,'||chr(10)||
'                                    position: ''center'','||chr(10)||
'                                    width: $(window).width()/xRatio,'||chr(10)||
'   ';

c1:=c1||'                                 height: $(window).height()/yRatio,'||chr(10)||
'                                    modal: true'||chr(10)||
'                                 });'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' $dialog.dialog(''open'');'||chr(10)||
''||chr(10)||
' try'||chr(10)||
'   {'||chr(10)||
'    var LocatorDiv = document.getElementById(''LocatorDiv'');'||chr(10)||
'    LocatorDiv.className="LocatorDiv";'||chr(10)||
'   }'||chr(10)||
' catch(err)'||chr(10)||
'      {'||chr(10)||
'      }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 10824323204693450 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_JQUERY_OPENLOCATOR',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '27-Feb-2012 - Tim Ward - CR#4002 - Created for JQuery Locators Page.',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
