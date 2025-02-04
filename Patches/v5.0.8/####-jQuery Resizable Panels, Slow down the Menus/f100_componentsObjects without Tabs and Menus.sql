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
--   Date and Time:   08:11 Wednesday November 7, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Objects without Tabs and Menus
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
 
 
prompt Component Export: PAGE TEMPLATE 93856707457736574
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 93856707457736574
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"'||chr(10)||
' "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'||chr(10)||
'<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />'||chr(10)||
'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'   setGlobals("&APP_ID.","';

c1:=c1||'&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#jQuery/jQueryIncludes.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'#HEAD#'||chr(10)||
'<link rel="shortcut icon" href="#IMAGE_PREFIX#themes/OSI/&P0_OBJ_IMAGE.">'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'   var version = getInternetExplorerVersion();'||chr(10)||
''||chr(10)||
'   function checkDirty()'||chr(10)||
'   {'||chr(10)||
'    return (/\:&APP_PAGE_ID./.test(document.getElementById(''P0_DIRTY'').value));'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function highlightSave() '||chr(10)||
'   {'||chr(10)||
'    var anchors = document.getElementsByTagName(''a'');'||chr(10)||
''||chr(10)||
'    for (var i = 0;i<anchors.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (/SAVE/.test(anchors[i].href)) ';

c2:=c2||''||chr(10)||
'          anchors[i].style.color = ''red''; '||chr(10)||
''||chr(10)||
'        if ((/CREATE/.test(anchors[i].href)) && !(/CREATE_UNK/.test(anchors[i].href)) && !(/CREATE_OBJ/.test(anchors[i].href)))'||chr(10)||
'          anchors[i].style.color = ''red'';     '||chr(10)||
'       }   '||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setDirty()'||chr(10)||
'   {'||chr(10)||
'    document.getElementById(''P0_DIRTY'').value+='':&APP_PAGE_ID.'';'||chr(10)||
'    highlightSave();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function clearDirty() '||chr(10)||
'   {'||chr(10)||
'    documen';

c2:=c2||'t.getElementById(''P0_DIRTY'').value ='||chr(10)||
'    document.getElementById(''P0_DIRTY'').value.replace(/\:&APP_PAGE_ID./g, '''');'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setPopup() '||chr(10)||
'   {'||chr(10)||
'    isPopup = true;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function onUnload()'||chr(10)||
'   {'||chr(10)||
'    if (checkDirty())'||chr(10)||
'      {'||chr(10)||
'       clearDirty();'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   // Main'||chr(10)||
'   if (checkDirty()) '||chr(10)||
'     {'||chr(10)||
'      highlightSave();'||chr(10)||
'     }'||chr(10)||
''||chr(10)||
'   // TJW - 28-Dec-2011, Added the Version Check because Fi';

c2:=c2||'reFox uses addEventListner and IE uses attachEvent //'||chr(10)||
'   //                    so Firefox would never get the goAway Message.                                       //'||chr(10)||
'   var inputs, selects, textAreas, anchors;'||chr(10)||
'   inputs = document.getElementsByTagName(''input'');'||chr(10)||
'   selects = document.getElementsByTagName(''select'');'||chr(10)||
'   textAreas = document.getElementsByTagName(''textarea'');'||chr(10)||
'   anchors = document.get';

c2:=c2||'ElementsByTagName(''a'');'||chr(10)||
''||chr(10)||
'   for(var i=0; i<anchors.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if (/popup/i.test(anchors[i].href))'||chr(10)||
'         {'||chr(10)||
'          if(version==-1)'||chr(10)||
'            anchors[i].addEventListener(''onclick'',setPopup,false);'||chr(10)||
'          else'||chr(10)||
'            anchors[i].attachEvent(''onclick'',setPopup);'||chr(10)||
'         }'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<inputs.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if ((inputs[i].type==''checkbox'' && !(';

c2:=c2||'/f[0-9]+/.test(inputs[i].name))) || (inputs[i].type==''radio''))'||chr(10)||
'         {'||chr(10)||
'          if(version==-1)'||chr(10)||
'            inputs[i].addEventListener(''onchange'',setDirty,false);'||chr(10)||
'          else'||chr(10)||
'            inputs[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'       if (inputs[i].type==''text'')'||chr(10)||
'         $(inputs[i]).change(function() { setDirty(); });'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<selects.length; i++)'||chr(10)||
'      {'||chr(10)||
' ';

c2:=c2||'      if(version==-1)'||chr(10)||
'        selects[i].addEventListener(''onchange'',setDirty,false);'||chr(10)||
'       else'||chr(10)||
'        selects[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<textAreas.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if(version==-1)'||chr(10)||
'         textAreas[i].addEventListener(''onchange'',setDirty,false);'||chr(10)||
'       else'||chr(10)||
'         textAreas[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   window.onbeforeunload';

c2:=c2||' = onUnload;'||chr(10)||
'   function mySubmit(request, t)'||chr(10)||
'   { '||chr(10)||
'    if(request == ''&BTN_SAVE.'' || request == ''&BTN_DELETE.'' || request == ''&BTN_CANCEL.'')'||chr(10)||
'      clearDirty();'||chr(10)||
''||chr(10)||
'    if(request.substring(0,6).toUpperCase() !== ''DELETE'')'||chr(10)||
'      $(t).hide();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   $(document).ready(function() '||chr(10)||
'    {'||chr(10)||
'     $("div.tooltip").tipsy({live: true, fade: true, gravity: "n", title: "tip"});'||chr(10)||
'    });'||chr(10)||
'</script>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<';

c2:=c2||'/body>'||chr(10)||
'</html>';

c3:=c3||'<table class="bannerTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'      <td class="bannerLogo" width="30%">&nbsp;</td>'||chr(10)||
'      <td align="center" class="bannerLogo" width="40%">'||chr(10)||
'      <img height="35px" src="#IMAGE_PREFIX#themes/OSI/osi_object_banner.gif"/></td>'||chr(10)||
'      '||chr(10)||
'       <td class="navBar" width="30%">'||chr(10)||
'         <table cellpadding="0" cellspacing="0" border="0" summary=';

c3:=c3||'"" align="right">'||chr(10)||
'            <tr>'||chr(10)||
'               <td><a href="&USER_URL.">&APP_USER.</a></td>'||chr(10)||
'               <td>#NAVIGATION_BAR#</td>'||chr(10)||
'            </tr>'||chr(10)||
'         </table>'||chr(10)||
'      </td> '||chr(10)||
''||chr(10)||
'   </tr>'||chr(10)||
'   <tr>'||chr(10)||
'      <table width=100% cellpadding="0" cellspacing="0">'||chr(10)||
'  <tr>'||chr(10)||
'   <td width=33% class="underbannerbar" style="text-align: left;">&P0_OBJ_TAGLINE.&nbsp;</td>'||chr(10)||
'   <td width=33% class="underbannerbar"';

c3:=c3||' style="color:#e10505;text-align: center;">&OSI_BANNER.&nbsp;v&OSI_VERSION.</td>'||chr(10)||
'   <td width=100% class="underbannerbar" style="text-align: right;">&P0_OBJ_ID.&nbsp;</td>'||chr(10)||
'  </tr>'||chr(10)||
'   </table>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_01#'||chr(10)||
'#REGION_POSITION_02#'||chr(10)||
'#REGION_POSITION_03#'||chr(10)||
'<table class="contentTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding=';

c3:=c3||'"0" cellspacing="0" style="vertical-align:top; text-align:center; color:red;">#GLOBAL_NOTIFICATION#</td></tr>'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top;">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##BOX_BODY##REGION_POSITION_04##REGION_POSITION_05#</td>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'<div class="versionDiv">I2MS &OSI_VERSION.</div>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'  doc';

c3:=c3||'ument.write(getStatusBar("&P0_OBJ."));'||chr(10)||
'</script>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 93856707457736574 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Objects without Tabs and Menus',
  p_body_title=> '<!--#BODY_TITLE#-->',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t9success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<div style="float:right; padding:7px; padding-bottom:2px; border:1px solid #222222; background-color:#ffe0c0; border-bottom:none;">#TAB_LABEL##TAB_INLINE_EDIT#</div>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<div style="float:right; padding:5px; padding-bottom:2px; margin-top:2px; border:1px solid #222222; border-bottom:none; background-color:#ffe0c0; "><a href="#TAB_LINK#">#TAB_LABEL##TAB_INLINE_EDIT#</a></div>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t9notification">#MESSAGE#</div>',
  p_navigation_bar=> '<table cellpadding="1" cellspacing="2" border="0"  class="t9navbar"><tr><td valign="top"><img src="#IMAGE_PREFIX#themes/theme_9/separator.png"/>'||chr(10)||
'</td>#BAR_BODY#</tr></table>',
  p_navbar_entry=> '<td valign="top"><a href="#LINK#">#TEXT#</a></td><td valign="top">'||chr(10)||
'<img src="#IMAGE_PREFIX#themes/theme_9/separator.png"/>'||chr(10)||
'</td>'||chr(10)||
'',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 101,
  p_theme_class_id => 3,
  p_template_comment => '28-Aug-2012 - Tim Ward - Removed unused Submodal includes.'||chr(10)||
'28-Aug-2012 - Tim Ward - CR#4106 - Added this to the mySubmit call so we can hide the'||chr(10)||
'                                    button after it is pressed so it can''t be pressed'||chr(10)||
'                                    multiple times.'||chr(10)||
'16-Oct-2012 - Tim Ward - Create Activity Screen was turning "Submit Helpdesk Ticket"'||chr(10)||
'                          red because of the CREATE_OBJ in the link.');
end;
 
null;
 
end;
/

COMMIT;
