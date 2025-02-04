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
--   Date and Time:   08:08 Thursday May 12, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_REPORT_AUTO_SCROLL
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
 
 
prompt Component Export: SHORTCUTS 5510007386522883
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script type="text/javascript">'||chr(10)||
'function scrollDivBackOne()'||chr(10)||
'{'||chr(10)||
' var td = document.getElementById(''currentrow'');'||chr(10)||
' var div = document.getElementById(''reportContainer'');'||chr(10)||
' var th = document.getElementById(''SID'');'||chr(10)||
' '||chr(10)||
' if (td!=null && td!=undefined)'||chr(10)||
'   div.scrollTop=td.offsetTop-th.clientHeight;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function checkForUpDownArrows(e, currentRowSID)'||chr(10)||
'{'||chr(10)||
' var keynum;'||chr(10)||
' var keychar;'||chr(10)||
' var currentRow = "javascript:d';

c1:=c1||'oSubmit(''EDIT_"+currentRowSID+"'');";'||chr(10)||
' var nextRow = "javascript:doSubmit(''EDIT_";'||chr(10)||
''||chr(10)||
' if(window.event)        // IE'||chr(10)||
'   keynum = e.keyCode;'||chr(10)||
' else if(e.which)        // Netscape/Firefox/Opera'||chr(10)||
'     keynum = e.which;'||chr(10)||
''||chr(10)||
'  keychar = String.fromCharCode(keynum)'||chr(10)||
'  '||chr(10)||
'  if(e.shiftKey)'||chr(10)||
'    {'||chr(10)||
'     // Down Arrow //  '||chr(10)||
'     if(keynum==40)'||chr(10)||
'       {'||chr(10)||
'        var links = document.getElementsByTagName(''A'');'||chr(10)||
'     '||chr(10)||
'       ';

c1:=c1||' for(i=0; i<links.length; i++)'||chr(10)||
'           {'||chr(10)||
'            if(links[i].href==currentRow)'||chr(10)||
'              {'||chr(10)||
'               for(j=i+1; j<links.length; j++)'||chr(10)||
'                  {'||chr(10)||
'                   if(links[j].href.substring(0,26)==nextRow)'||chr(10)||
'                     {'||chr(10)||
'                      doSubmit(''EDIT_''+links[j].name);'||chr(10)||
'                      return (keynum != 40);'||chr(10)||
'                     }'||chr(10)||
'                  }'||chr(10)||
'   ';

c1:=c1||'            break;'||chr(10)||
'              }'||chr(10)||
'           }'||chr(10)||
'       }'||chr(10)||
'  '||chr(10)||
'     // Up Arrow //'||chr(10)||
'     if(keynum==38)'||chr(10)||
'       {'||chr(10)||
'        var links = document.getElementsByTagName(''A'');'||chr(10)||
'      '||chr(10)||
'        for(i=0; i<links.length; i++)'||chr(10)||
'           {'||chr(10)||
'            if(links[i].href==currentRow)'||chr(10)||
'              {'||chr(10)||
'               for(j=i-1; j>=0; j--)'||chr(10)||
'                  {'||chr(10)||
'                   if(links[j].href.substring(0,26)==nextRow)'||chr(10)||
'';

c1:=c1||'                     {'||chr(10)||
'                      doSubmit(''EDIT_''+links[j].name);'||chr(10)||
'                      return (keynum != 38);'||chr(10)||
'                     }'||chr(10)||
'                  }'||chr(10)||
'               break;'||chr(10)||
'              }'||chr(10)||
'           }'||chr(10)||
'       }'||chr(10)||
'     }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 5510007386522883 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_REPORT_AUTO_SCROLL',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '12-May-2011 - Tim Ward - CR#3745/3780 - Created this ShortCut.  This '||chr(10)||
'                         autoscrolls a report so the currentrow is in '||chr(10)||
'                         the view window.'||chr(10)||
''||chr(10)||
'--------------------------------------------------------------------'||chr(10)||
'---THIS NEEDS TO BE ADDED TO THE HTML BODY ATTRIBUTES OF THE PAGE---'||chr(10)||
'--------------------------------------------------------------------'||chr(10)||
'onkeydown="return checkForUpDownArrows(event);"'||chr(10)||
''||chr(10)||
'----------------------------------------------------------------------'||chr(10)||
'---THIS NEEDS TO BE ADDED TO THE PAGE FOOTER ATTRIBUTES OF THE PAGE---'||chr(10)||
'----------------------------------------------------------------------'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'$(window).load(function(){  '||chr(10)||
''||chr(10)||
'  var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
''||chr(10)||
'});'||chr(10)||
'</script>',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
