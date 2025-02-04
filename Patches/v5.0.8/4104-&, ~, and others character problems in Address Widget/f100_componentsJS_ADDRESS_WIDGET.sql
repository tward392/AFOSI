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
--   Date and Time:   08:32 Tuesday August 21, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_ADDRESS_WIDGET
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
 
 
prompt Component Export: SHORTCUTS 90112627491604354
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'var pAddrItem;'||chr(10)||
'var pAddrItems;'||chr(10)||
'var pIncludeSids;'||chr(10)||
''||chr(10)||
'function addressWidget(addrItem,includeSids)'||chr(10)||
'{'||chr(10)||
' pAddrItem = addrItem;'||chr(10)||
' pAddrItems = document.getElementById(addrItem).value;'||chr(10)||
''||chr(10)||
' if (includeSids)'||chr(10)||
'   {'||chr(10)||
'    pIncludeSids=includeSids;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' runJQueryPopWin(''Address'','''','''');'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function addressWidgetSetValues()'||chr(10)||
'{'||chr(10)||
' split = pAddrItems.split(''~^~'');'||chr(10)||
''||chr(10)||
' $';

c1:=c1||'(''#Address'').contents().find(''#P200_RETURN_ITEM'').val(pAddrItem);'||chr(10)||
' $(''#Address'').contents().find(''#P200_INCLUDE_SIDS'').val(pIncludeSids);'||chr(10)||
' $(''#Address'').contents().find(''#P200_ADDRESS_FIELDS'').val(pAddrItems);'||chr(10)||
' $(''#Address'').contents().find(''#P200_ADDRESS_1'').val(split[1]);'||chr(10)||
' $(''#Address'').contents().find(''#P200_ADDRESS_2'').val(split[2]);'||chr(10)||
' $(''#Address'').contents().find(''#P200_CITY'').val(split[3]);'||chr(10)||
'';

c1:=c1||' $(''#Address'').contents().find(''#P200_STATE'').val(split[4]);'||chr(10)||
' $(''#Address'').contents().find(''#P200_ZIP'').val(split[5]);'||chr(10)||
' $(''#Address'').contents().find(''#P200_COUNTRY'').val(split[6]);'||chr(10)||
' $(''#Address'').contents().find(''#P200_PROVINCE'').val(split[7]);'||chr(10)||
' $(''#Address'').contents().find(''#P200_GEO_COORDS'').val(split[8]);'||chr(10)||
''||chr(10)||
' if($(''#Address'').contents().find(''#P200_ADDRESS_FIELDS'').val()!='''')'||chr(10)||
'   $(''#Address'').';

c1:=c1||'contents().find(''#btnClear'').show();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 90112627491604354 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_ADDRESS_WIDGET',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> 'Example Call: '||chr(10)||
'  addressWidget(''P100_ADDRESS_VALUE'', ''~00100000FG3~00100000FG4~'');'||chr(10)||
'  '||chr(10)||
'  - P100_ADDRESS_VALUE: '||chr(10)||
'         the item that will receive the resulting address value.'||chr(10)||
'  - ~00100000FG3~00100000FG4~: '||chr(10)||
'         a list of object sids to include in looking for relevant (recent) '||chr(10)||
'         addresses.  This is an optional parameter, so the following call '||chr(10)||
'         works just as well:'||chr(10)||
'              addressWidget(''P100_ADDRESS_VALUE'');'||chr(10)||
'         Also note that the sid(s) MUST be in the LIST format (surrounded by ~)'||chr(10)||
''||chr(10)||
'25-Apr-2012 - Tim Ward - CR#4042 - Commas in the Address message up'||chr(10)||
'                                    displaying of values here.'||chr(10)||
'                                   Changed to use JQuery Popup Window.'||chr(10)||
''||chr(10)||
'21-Aug-2012 - Tim Ward - CR#4104 - Changed to use jQuery/JavaScript to'||chr(10)||
'                                    load values in P200 so we don''t have'||chr(10)||
'                                    to pass items on the URL (this causes'||chr(10)||
'                                    issues with certain characters like'||chr(10)||
'                                    &#,: etc....)'||chr(10)||
'',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
