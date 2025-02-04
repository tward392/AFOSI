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
--   Date and Time:   10:22 Friday July 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LABEL TEMPLATE: Optional Label with Hover Help
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
 
 
prompt Component Export: LABEL TEMPLATE 1591526640502753
 
prompt  ...label templates
--
prompt  ......label template 1591526640502753
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 1591526640502753 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label with Hover Help',
  p_template_body1=>'<label class="hoverHelp" style="font-weight: bold; color: #000; cursor: help;" tabindex="999" for="#CURRENT_ITEM_NAME#" rel="" reltitle="">'||chr(10)||
'',
  p_template_body2=>'</label>',
  p_on_error_before_label=>'',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#',
  p_theme_id  => 101,
  p_theme_class_id => 1,
  p_template_comment=> '');
end;
null;
 
end;
/

COMMIT;



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
--   Date and Time:   10:22 Friday July 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LABEL TEMPLATE: Required Label with Hover Help
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
 
 
prompt Component Export: LABEL TEMPLATE 1591617075509446
 
prompt  ...label templates
--
prompt  ......label template 1591617075509446
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 1591617075509446 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label with Hover Help',
  p_template_body1=>'<label class="hoverHelp" style="font-weight: bold; color: #FF1010; cursor: help;" tabindex="999" for="#CURRENT_ITEM_NAME#" rel="" reltitle="">'||chr(10)||
''||chr(10)||
'',
  p_template_body2=>'</label>',
  p_on_error_before_label=>'',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#',
  p_theme_id  => 101,
  p_theme_class_id => 2,
  p_template_comment=> '');
end;
null;
 
end;
/

COMMIT;



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
--   Date and Time:   11:17 Friday July 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Printer Friendly
--     PAGE TEMPLATE: Popup
--     PAGE TEMPLATE: Login
--     PAGE TEMPLATE: Empty
--     PAGE TEMPLATE: Objects without Tabs and Menus
--     PAGE TEMPLATE: Objects with Tabs and Menus
--     PAGE TEMPLATE: Desktop
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
 
 
prompt Component Export: PAGE TEMPLATE 179216056228554478
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 179216056228554478
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
'<head>'||chr(10)||
'#HEAD#'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_9/theme_V2.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquer';

c1:=c1||'y-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var';

c1:=c1||' elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnElements = [];'||chr(10)||
'	var current;'||chr(10)||
'	var length = elements.length;'||chr(10)||
'	for(var i=0; i<length; i++){'||chr(10)||
'		current = elements[i];'||chr(10)||
'		if(testClass.test(current.className)){'||chr(10)||
'			returnElements.push(current);'||chr(10)||
'		}'||chr(10)||
'	}'||chr(10)||
'	return returnElements;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#';

c1:=c1||'jQuery/jquery-datetimepicker.js"></script>'||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/jquery-datetimepicker-extras.css" type="text/css" rel="stylesheet" />'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/jquery-hoverhe';

c1:=c1||'lp.js" type="text/javascript"></script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<br />'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table class="t9pagebody" width="100%" cellpadding="4" cellspacing="2" border="0" summary="">'||chr(10)||
'<tr><td align="left" valign="top">&nbsp;</td><td valign="top"><img width="1" height="500" src="#IMAGE_PREFIX#spacer.gif" alt=""></td><td  valign="top" width="100%">#SUCCESS_MESSAGE# #NOTIFICATION_MESSAGE# #BOX_BODY#</td></tr></table>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 179216056228554478 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Printer Friendly',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t9success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t9notification">#MESSAGE#</div>',
  p_navigation_bar=> '<table cellpadding="0" cellspacing="0" border="0">'||chr(10)||
'<tr><td>&nbsp;&nbsp;</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_navbar_entry=> '',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'width="100%"',
  p_theme_id  => 101,
  p_theme_class_id => 5,
  p_template_comment => '3');
end;
 
null;
 
end;
/

 
prompt Component Export: PAGE TEMPLATE 179215770461554476
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 179215770461554476
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" '||chr(10)||
'   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'||chr(10)||
''||chr(10)||
'<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />'||chr(10)||
'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'   setGlobals("&APP_I';

c1:=c1||'D.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javas';

c1:=c1||'cript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnElements = [];'||chr(10)||
'	var current';

c1:=c1||';'||chr(10)||
'	var length = elements.length;'||chr(10)||
'	for(var i=0; i<length; i++){'||chr(10)||
'		current = elements[i];'||chr(10)||
'		if(testClass.test(current.className)){'||chr(10)||
'			returnElements.push(current);'||chr(10)||
'		}'||chr(10)||
'	}'||chr(10)||
'	return returnElements;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jquery-datetimepicker.js"></script>'||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/jquery-datetimepicker-extras.css" type="text/css" rel="stylesheet" /';

c1:=c1||'>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/jquery-hoverhelp.js" type="text/javascript"></script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#'||chr(10)||
'<a';

c1:=c1||' name="PAGETOP"></a>';

c2:=c2||'<br />'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'   var version = getInternetExplorerVersion();'||chr(10)||
'   '||chr(10)||
'   function checkDirty(){'||chr(10)||
'      return (/\:&APP_PAGE_ID./.test(document.getElementById(''P0_DIRTY'').value));'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function highlightSave() {'||chr(10)||
'      var anchors = document.getElementsByTagName(''a'');'||chr(10)||
'      for (var i = 0;i<anchors.length;i++){'||chr(10)||
'         if ((/SAVE/.test(anc';

c2:=c2||'hors[i].href)) ||'||chr(10)||
'            (/CREATE/.test(anchors[i].href)))'||chr(10)||
'            anchors[i].style.color = ''red'';'||chr(10)||
'      }   '||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setDirty() {'||chr(10)||
'      document.getElementById(''P0_DIRTY'').value+='':&APP_PAGE_ID.'';'||chr(10)||
'      highlightSave();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function clearDirty() {'||chr(10)||
'      document.getElementById(''P0_DIRTY'').value ='||chr(10)||
'      document.getElementById(''P0_DIRTY'').value.replace(/\:&APP_PAGE_ID./g, ''';

c2:=c2||''');'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setPopup() {'||chr(10)||
'      isPopup = true;'||chr(10)||
'   }'||chr(10)||
'   function onUnload(){'||chr(10)||
'      if (checkDirty()){'||chr(10)||
'         clearDirty();'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   // Main'||chr(10)||
'   if (checkDirty()) {'||chr(10)||
'      highlightSave();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   // TJW - 28-Dec-2011, Added the Version Check because FireFox uses addEventListner and IE uses attachEvent //'||chr(10)||
'   //                    so Firefox would never get the goAway Message.     ';

c2:=c2||'                                  //'||chr(10)||
'   var inputs, selects, textAreas, anchors;'||chr(10)||
'   inputs = document.getElementsByTagName(''input'');'||chr(10)||
'   selects = document.getElementsByTagName(''select'');'||chr(10)||
'   textAreas = document.getElementsByTagName(''textarea'');'||chr(10)||
'   anchors = document.getElementsByTagName(''a'');'||chr(10)||
''||chr(10)||
'   for(var i=0; i<anchors.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if (/popup/i.test(anchors[i].href))'||chr(10)||
'         {'||chr(10)||
'    ';

c2:=c2||'      if(version==-1)'||chr(10)||
'            anchors[i].addEventListener(''onclick'',setPopup,false);'||chr(10)||
'          else'||chr(10)||
'            anchors[i].attachEvent(''onclick'',setPopup);'||chr(10)||
'         }'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<inputs.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if ((inputs[i].type==''checkbox'' && !(/f[0-9]+/.test(inputs[i].name))) || (inputs[i].type==''radio''))'||chr(10)||
'         {'||chr(10)||
'          if(version==-1)'||chr(10)||
'            inputs[i].addEvent';

c2:=c2||'Listener(''onchange'',setDirty,false);'||chr(10)||
'          else'||chr(10)||
'            inputs[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'       if (inputs[i].type==''text'')'||chr(10)||
'         $(inputs[i]).change(function() {setDirty();});'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<selects.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if(version==-1)'||chr(10)||
'         selects[i].addEventListener(''onchange'',setDirty,false);'||chr(10)||
'       else'||chr(10)||
'         selects[i].attachEvent(''';

c2:=c2||'onchange'',setDirty);'||chr(10)||
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
'   window.onbeforeunload = onUnload;'||chr(10)||
'   function mySubmit(request, t)'||chr(10)||
'   { '||chr(10)||
'    if(request == ''&BTN_SAVE.'' || request == ''&BTN_DELETE.'' || request == ''&BT';

c2:=c2||'N_CANCEL.'')'||chr(10)||
'      clearDirty();'||chr(10)||
''||chr(10)||
'    $(t).hide();'||chr(10)||
'   }'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table class="t9pagebody" width="100%" border="0" summary="">'||chr(10)||
'<tr><td  valign="top" width="100%">#SUCCESS_MESSAGE# #NOTIFICATION_MESSAGE# #REGION_POSITION_03##BOX_BODY#</td></tr></table>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 179215770461554476 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Popup',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t9success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t9notification">#MESSAGE#</div>',
  p_navigation_bar=> '<table cellpadding="0" cellspacing="0" border="0">'||chr(10)||
'<tr><td>&nbsp;&nbsp;</td>'||chr(10)||
'#BAR_BODY#'||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_navbar_entry=> '',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'width="100%"',
  p_theme_id  => 101,
  p_theme_class_id => 4,
  p_template_comment => '23-Jun-2011 - Tim Ward - CR#3868 - Moved #HEAD# and #TITLE# to allow this template to '||chr(10)||
'                         do some JQuery stuff that wasn''t be declared at the correct '||chr(10)||
'                         point.'||chr(10)||
''||chr(10)||
'06-Apr-2012 - Tim Ward - CR#4030 - Added this to the mySubmit call so we can hide the'||chr(10)||
'                                    button after it is pressed so it can''t be pressed'||chr(10)||
'                                    multiple times.');
end;
 
null;
 
end;
/

 
prompt Component Export: PAGE TEMPLATE 179848065721383865
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 179848065721383865
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"'||chr(10)||
' "http://www.w3.org/TR/html4/loose.dtd">'||chr(10)||
''||chr(10)||
'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
'<head>'||chr(10)||
'#HEAD#'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'</script>'||chr(10)||
'<style>'||chr(10)||
'input'||chr(10)||
'{'||chr(10)||
' background-color:#ffffc0;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.cs';

c1:=c1||'s" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascri';

c1:=c1||'pt">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnElements = [];'||chr(10)||
'	var current;'||chr(10)||
'	var length = elements.length;'||chr(10)||
'	for(var i=0; i<length; i++){'||chr(10)||
'		current = elements[i];'||chr(10)||
'		if(testClass.tes';

c1:=c1||'t(current.className)){'||chr(10)||
'			returnElements.push(current);'||chr(10)||
'		}'||chr(10)||
'	}'||chr(10)||
'	return returnElements;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jquery-datetimepicker.js"></script>'||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/jquery-datetimepicker-extras.css" type="text/css" rel="stylesheet" />'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'';

c1:=c1||'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/jquery-hoverhelp.js" type="text/javascript"></script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>'||chr(10)||
''||chr(10)||
'';

c3:=c3||'<table class="bannerTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'      <td class="bannerLogo"><img src="#IMAGE_PREFIX#themes/OSI/i2ms2.png"/></td>'||chr(10)||
'   </tr>'||chr(10)||
'   <tr>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'<table class="contentTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; text-align:center; color:';

c3:=c3||'red;">'||chr(10)||
'      <!-- a name="PAGETOP"></a -->#GLOBAL_NOTIFICATION#</td></tr>'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top;">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#'||chr(10)||
'      <div style="clear:both;">           '||chr(10)||
'#BOX_BODY#'||chr(10)||
'</div>'||chr(10)||
'     </td>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 179848065721383865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Login',
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
  p_theme_class_id => 6,
  p_template_comment => '24-May-2012 - Tim Ward - Cleaning up some CSS and JS stuff.'||chr(10)||
'                          Removed mootools-osi.js - doesn''t exist.'||chr(10)||
'                          Removed suckerfish references, not used.'||chr(10)||
'                          Removed some CSS Styling that wasn''t being'||chr(10)||
'                           used.'||chr(10)||
'                          Removed some Date Precision popup code.');
end;
 
null;
 
end;
/

 
prompt Component Export: PAGE TEMPLATE 4444031419583031
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 4444031419583031
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#';

c1:=c1||'jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)"';

c1:=c1||');'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnElements = [];'||chr(10)||
'	var current;'||chr(10)||
'	var length = elements.length;'||chr(10)||
'	for(var i=0; i<length; i++){'||chr(10)||
'		current = elements[i];'||chr(10)||
'		if(testClass.test(current.className)){'||chr(10)||
'			returnElements.push(current);'||chr(10)||
'		}'||chr(10)||
'	}'||chr(10)||
'	return returnElements;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script type="text/j';

c1:=c1||'avascript" src="#IMAGE_PREFIX#jQuery/jquery-datetimepicker.js"></script>'||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/jquery-datetimepicker-extras.css" type="text/css" rel="stylesheet" />'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script src="#IMAG';

c1:=c1||'E_PREFIX#jquery/jquery-hoverhelp.js" type="text/javascript"></script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<!-- Nothing -->'||chr(10)||
'#BOX_BODY#';

wwv_flow_api.create_template(
  p_id=> 4444031419583031 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Empty',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '',
  p_navigation_bar=> '',
  p_navbar_entry=> '',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> '',
  p_theme_id  => 101,
  p_theme_class_id => 5,
  p_template_comment => '');
end;
 
null;
 
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
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_';

c1:=c1||'PREFIX#/themes/OSI/submodal/subModal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8';

c1:=c1||'.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#javascript/StatusBar.css" />'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/StatusBar.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
' var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
' var tag = tag || "*";'||chr(10)||
' var elm = elm || docum';

c1:=c1||'ent;'||chr(10)||
' var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
' var returnElements = [];'||chr(10)||
' var current;'||chr(10)||
' var length = elements.length;'||chr(10)||
' for(var i=0; i<length; i++){'||chr(10)||
'  current = elements[i];'||chr(10)||
'  if(testClass.test(current.className)){'||chr(10)||
'   returnElements.push(current);'||chr(10)||
'  }'||chr(10)||
' }'||chr(10)||
' return returnElements;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jquery-datet';

c1:=c1||'imepicker.js"></script>'||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/jquery-datetimepicker-extras.css" type="text/css" rel="stylesheet" />'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/jquery-hoverhelp.js" type="text/ja';

c1:=c1||'vascript"></script> '||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'   var version = getInternetExplorerVersion();'||chr(10)||
''||chr(10)||
'   function checkDirty(){'||chr(10)||
'      return (/\:&APP_PAGE_ID./.test(document.getElementById(''P0_DIRTY'').value));'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function highlightSave() {'||chr(10)||
'      var anchors = document.getElementsByTagName(''a'');'||chr(10)||
'      for (var i = 0;i<anchors.length;i++){'||chr(10)||
'          if (/SAVE/.test(anchors[i].href)) '||chr(10)||
'  anchor';

c2:=c2||'s[i].style.color = ''red''; '||chr(10)||
'          if ((/CREATE/.test(anchors[i].href)) &&'||chr(10)||
'           !(/CREATE_UNK/.test(anchors[i].href)))'||chr(10)||
'            anchors[i].style.color = ''red'';     '||chr(10)||
'     }   '||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setDirty() {'||chr(10)||
'      document.getElementById(''P0_DIRTY'').value+='':&APP_PAGE_ID.'';'||chr(10)||
'      highlightSave();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function clearDirty() {'||chr(10)||
'      document.getElementById(''P0_DIRTY'').value ='||chr(10)||
'      docu';

c2:=c2||'ment.getElementById(''P0_DIRTY'').value.replace(/\:&APP_PAGE_ID./g, '''');'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setPopup() {'||chr(10)||
'      isPopup = true;'||chr(10)||
'   }'||chr(10)||
'   function onUnload(){'||chr(10)||
'      if (checkDirty()){'||chr(10)||
'         clearDirty();'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   // Main'||chr(10)||
'   if (checkDirty()) {'||chr(10)||
'      highlightSave();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   // TJW - 28-Dec-2011, Added the Version Check because FireFox uses addEventListner and IE uses attachEvent //'||chr(10)||
'   //    ';

c2:=c2||'                so Firefox would never get the goAway Message.                                       //'||chr(10)||
'   var inputs, selects, textAreas, anchors;'||chr(10)||
'   inputs = document.getElementsByTagName(''input'');'||chr(10)||
'   selects = document.getElementsByTagName(''select'');'||chr(10)||
'   textAreas = document.getElementsByTagName(''textarea'');'||chr(10)||
'   anchors = document.getElementsByTagName(''a'');'||chr(10)||
''||chr(10)||
'   for(var i=0; i<anchors.length; i++)';

c2:=c2||''||chr(10)||
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
'       if ((inputs[i].type==''checkbox'' && !(/f[0-9]+/.test(inputs[i].name))) || (inputs[i].type==''radio''))'||chr(10)||
'';

c2:=c2||'         {'||chr(10)||
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
'       if(version==-1)'||chr(10)||
'        selects[i].addEventListener(''onch';

c2:=c2||'ange'',setDirty,false);'||chr(10)||
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
'   window.onbeforeunload = onUnload;'||chr(10)||
'   function mySubmit(request){ '||chr(10)||
'       if (request';

c2:=c2||' == ''&BTN_SAVE.'' ||'||chr(10)||
'           request == ''&BTN_DELETE.'' ||'||chr(10)||
'           request == ''&BTN_CANCEL.'')'||chr(10)||
'           clearDirty();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
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
'   <td width=33% class="underbannerbar" style="text-align: left;">'||chr(10)||
'             &P0_OBJ_TAGLINE.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'   <td width=33% clas';

c3:=c3||'s="underbannerbar" style="color:#e10505;text-align: center;">'||chr(10)||
'             &OSI_BANNER.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'   <td width=100% class="underbannerbar" style="text-align: right;">'||chr(10)||
'             &P0_OBJ_ID.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'  </tr>'||chr(10)||
'   </table>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_01#'||chr(10)||
'#REGION_POSITION_02#'||chr(10)||
'#REGION_POSITION_03#'||chr(10)||
'<table class="contentTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'  ';

c3:=c3||' <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; text-align:center; '||chr(10)||
''||chr(10)||
'color:red;">#GLOBAL_NOTIFICATION#</td></tr>'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top;">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#'||chr(10)||
''||chr(10)||
''||chr(10)||
'<!--div style="clear:both;"-->           '||chr(10)||
'#BOX_BODY##REGION_POSITION_04##REGION_POSITION_05#'||chr(10)||
'<!--/div-->'||chr(10)||
''||chr(10)||
''||chr(10)||
'     </td';

c3:=c3||'>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'<div class="versionDiv">I2MS &OSI_VERSION.</div>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'  document.write(getStatusBar("&P0_OBJ."));'||chr(10)||
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
  p_template_comment => '');
end;
 
null;
 
end;
/

 
prompt Component Export: PAGE TEMPLATE 179215462100554475
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 179215462100554475
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" '||chr(10)||
'   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'||chr(10)||
''||chr(10)||
'<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />'||chr(10)||
'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'   setGlobals("&APP_I';

c1:=c1||'D.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#I';

c1:=c1||'MAGE_PREFIX#/themes/OSI/submodal/subModal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-u';

c1:=c1||'i-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#javascript/StatusBar.css" />'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/StatusBar.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
' var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
' var tag = tag || "*";'||chr(10)||
' var elm = elm || ';

c1:=c1||'document;'||chr(10)||
' var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
' var returnElements = [];'||chr(10)||
' var current;'||chr(10)||
' var length = elements.length;'||chr(10)||
' for(var i=0; i<length; i++){'||chr(10)||
'  current = elements[i];'||chr(10)||
'  if(testClass.test(current.className)){'||chr(10)||
'   returnElements.push(current);'||chr(10)||
'  }'||chr(10)||
' }'||chr(10)||
' return returnElements;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jquery-';

c1:=c1||'datetimepicker.js"></script>'||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/jquery-datetimepicker-extras.css" type="text/css" rel="stylesheet" />'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/jquery-hoverhelp.js" type="tex';

c1:=c1||'t/javascript"></script>'||chr(10)||
' '||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'<!-- JQuery/Superfish Menu Stuff --->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jQuery/superfish-1.4.8/css/superfish.css" media="screen">'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/superfish-1.4.8/js/superfish.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/superfish-1.4.8/js/supers';

c1:=c1||'ubs.js"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
' '||chr(10)||
' $(document).ready(function(){ '||chr(10)||
'     $("ul.sf-menu").supersubs({ '||chr(10)||
'         minWidth:    12,   // minimum width of sub-menus in em units '||chr(10)||
'         maxWidth:    27,   // maximum width of sub-menus in em units '||chr(10)||
'         extraWidth:  1     // extra width can ensure lines don''t sometimes turn over '||chr(10)||
'                            // due to slight rounding';

c1:=c1||' differences and font-family '||chr(10)||
'     }).superfish();  // call supersubs first, then superfish, so that subs are '||chr(10)||
'                      // not display:none when measuring. Call before initialising '||chr(10)||
'                      // containing tabs for same reason. '||chr(10)||
''||chr(10)||
' });  '||chr(10)||
'</script>'||chr(10)||
'<!-- END JQuery/Superfish Menu Stuff --->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>'||chr(10)||
'#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'   var version = getInternetExplorerVersion();'||chr(10)||
''||chr(10)||
'   function checkDirty(){'||chr(10)||
'      return (/\:&APP_PAGE_ID./.test($v(''P0_DIRTY'')));'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   /*TMH 11/24 unused due to change in setDirty function*/'||chr(10)||
'   function checkWritable(){'||chr(10)||
'      return ($v(''P0_WRITABLE''));'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function checkDirtable() {'||chr(10)||
'      var anchors = document.getElemen';

c2:=c2||'tsByTagName(''a'');'||chr(10)||
'      for (var i = 0;i<anchors.length;i++){'||chr(10)||
'         if ((/SAVE/.test(anchors[i].href)) ||'||chr(10)||
'            (/CREATE/.test(anchors[i].href))) {'||chr(10)||
'            return true;'||chr(10)||
'         }'||chr(10)||
'      }'||chr(10)||
'      return false;   '||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function highlightSave() {'||chr(10)||
'      var anchors = document.getElementsByTagName(''a'');'||chr(10)||
'      for (var i = 0;i<anchors.length;i++){'||chr(10)||
'         if ((/SAVE/.test(anchors[i].hre';

c2:=c2||'f)) ||'||chr(10)||
'            (/CREATE/.test(anchors[i].href))) {'||chr(10)||
'            anchors[i].style.color = ''red'';'||chr(10)||
'            return true;'||chr(10)||
'         }'||chr(10)||
'      }'||chr(10)||
'      return false;   '||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setDirty() {'||chr(10)||
'      if (highlightSave()) {      '||chr(10)||
'          document.getElementById(''P0_DIRTY'').value+='':&APP_PAGE_ID.'';'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function clearDirty() {'||chr(10)||
'      document.getElementById(''P0_DIRTY'').value ='||chr(10)||
'      ';

c2:=c2||'document.getElementById(''P0_DIRTY'').value.replace(/\:&APP_PAGE_ID./g, '''');'||chr(10)||
'      //doSubmit(''CLEAR_DIRTY'');'||chr(10)||
'      document.getElementById(''P0_DIRTABLE'').value ='||chr(10)||
'      document.getElementById(''P0_DIRTABLE'').value.replace(/\Y/g, ''N'');'||chr(10)||
''||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function setPopup() {'||chr(10)||
'      isPopup = true;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
''||chr(10)||
'   function onUnload(){'||chr(10)||
'      //alert("Dirty Page: " + checkDirty());'||chr(10)||
'      if (checkDirty()){'||chr(10)||
'         cl';

c2:=c2||'earDirty();'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   // Main'||chr(10)||
'   if (checkDirty()) {'||chr(10)||
'      highlightSave();'||chr(10)||
'   }'||chr(10)||
'   /*TMH 03-04: Test to prevent application process from setting dirty to a page that isn''t dirty */'||chr(10)||
'   if (checkDirtable()) {'||chr(10)||
'      document.getElementById(''P0_DIRTABLE'').value=''Y'';'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function goAway(){'||chr(10)||
'      var imSure = true;'||chr(10)||
'      if (checkDirty()){'||chr(10)||
'         var msg = ''This action will cause all unsa';

c2:=c2||'ved changes to be lost.  '' +'||chr(10)||
'                   ''Click OK to return to the page and save changes before proceeding.'';'||chr(10)||
'         imSure = confirm(msg);'||chr(10)||
'      }'||chr(10)||
'      else{'||chr(10)||
'         return true;'||chr(10)||
'      }'||chr(10)||
'      if (imSure){'||chr(10)||
'         return false;'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
'   '||chr(10)||
'   // TJW - 28-Dec-2011, Added the Version Check because FireFox uses addEventListner and IE uses attachEvent //'||chr(10)||
'   //                    so ';

c2:=c2||'Firefox would never get the goAway Message.                                       //'||chr(10)||
'   var inputs, selects, textAreas, anchors;'||chr(10)||
'   inputs = document.getElementsByTagName(''input'');'||chr(10)||
'   selects = document.getElementsByTagName(''select'');'||chr(10)||
'   textAreas = document.getElementsByTagName(''textarea'');'||chr(10)||
'   anchors = document.getElementsByTagName(''a'');'||chr(10)||
''||chr(10)||
'   for(var i=0; i<anchors.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if ';

c2:=c2||'(/popup/i.test(anchors[i].href))'||chr(10)||
'         {'||chr(10)||
'          if (version == -1)'||chr(10)||
'            anchors[i].addEventListener(''onclick'',setPopup,false);'||chr(10)||
'          else'||chr(10)||
'            anchors[i].attachEvent(''onclick'',setPopup);'||chr(10)||
'         }'||chr(10)||
'       else if (/EDIT_/i.test(anchors[i].href))'||chr(10)||
'           {'||chr(10)||
'            if (version == -1)'||chr(10)||
'              anchors[i].addEventListener(''onclick'',goAway,false);'||chr(10)||
'            else'||chr(10)||
'  ';

c2:=c2||'            anchors[i].attachEvent(''onclick'',goAway);'||chr(10)||
'           }'||chr(10)||
'       else if (/ADD/i.test(anchors[i].href))'||chr(10)||
'           {'||chr(10)||
'            if (version == -1)'||chr(10)||
'              anchors[i].addEventListener(''onclick'',goAway,false);'||chr(10)||
'            else'||chr(10)||
'              anchors[i].attachEvent(''onclick'',goAway);'||chr(10)||
'           }'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<inputs.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if ((inputs[i].type==''checkb';

c2:=c2||'ox'' && !(/f[0-9]+/.test(inputs[i].name))) || (inputs[i].type==''radio''))'||chr(10)||
'         {'||chr(10)||
'          if (version == -1)'||chr(10)||
'            inputs[i].addEventListener(''onchange'',setDirty,false);'||chr(10)||
'          else'||chr(10)||
'            inputs[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'       if (inputs[i].type==''text'')'||chr(10)||
'         $(inputs[i]).change(function() {setDirty(); });'||chr(10)||
'      } '||chr(10)||
''||chr(10)||
'   for(var i=0; i<selects.length; i+';

c2:=c2||'+)'||chr(10)||
'      {'||chr(10)||
'       if (version == -1)'||chr(10)||
'         selects[i].addEventListener(''onchange'',setDirty,false);'||chr(10)||
'       else'||chr(10)||
'         selects[i].attachEvent(''onchange'',setDirty); '||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   for(var i=0; i<textAreas.length; i++)'||chr(10)||
'      {'||chr(10)||
'       if (version == -1)'||chr(10)||
'         textAreas[i].addEventListener(''onchange'',setDirty,false);'||chr(10)||
'       else'||chr(10)||
'         textAreas[i].attachEvent(''onchange'',setDirty);'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'   ';

c2:=c2||'window.onbeforeunload = onUnload;'||chr(10)||
''||chr(10)||
'   function mySubmit(request){ '||chr(10)||
'       if (request == ''&BTN_SAVE.'' ||'||chr(10)||
'           request == ''&BTN_DELETE.'' ||'||chr(10)||
'           request == ''&BTN_CANCEL.'')'||chr(10)||
'           clearDirty();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
'   function mySubmitSafe(request){ '||chr(10)||
'       if (request == ''&BTN_SAVE.'' ||'||chr(10)||
'           request == ''&BTN_DELETE.'' ||'||chr(10)||
'           request == ''&BTN_CANCEL.'')'||chr(10)||
'           clearDirty();'||chr(10)||
''||chr(10)||
'       i';

c2:=c2||'f (request == ''Add Participant''        '||chr(10)||
'           && (checkDirty())){'||chr(10)||
'           alert(''You must save before you can perform this action.'');'||chr(10)||
'           return false;'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'       if (request == ''Create New Individual''        '||chr(10)||
'           && (checkDirty())) {'||chr(10)||
'           alert(''You must save before you can perform this action.'');'||chr(10)||
'           return false;'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'/*'||chr(10)||
'       if (request == ''Creat';

c2:=c2||'e Participant''        '||chr(10)||
'           && checkDirty()) {'||chr(10)||
'           alert(''You must save before you can perform this action.'');'||chr(10)||
'           return false;'||chr(10)||
'       }'||chr(10)||
'*/'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
''||chr(10)||
'   function goToTab(pSid, pObj)'||chr(10)||
'   {'||chr(10)||
'      var imSure = false;'||chr(10)||
''||chr(10)||
'      if (checkDirty())'||chr(10)||
'        {'||chr(10)||
'         var msg = ''Leaving this tab will cause all unsaved changes to be lost.  '' +'||chr(10)||
'                   ''Click OK to return to the pag';

c2:=c2||'e and save changes before proceeding.'';'||chr(10)||
'         imSure = confirm(msg);'||chr(10)||
'        }'||chr(10)||
'      '||chr(10)||
'      if (!imSure)'||chr(10)||
'        {'||chr(10)||
'         if ( pObj === undefined )'||chr(10)||
'           doSubmit(''TAB_''+pSid);'||chr(10)||
'         else'||chr(10)||
'           doSubmit(''TAB_''+pSid+''_''+pObj);'||chr(10)||
'        }'||chr(10)||
'   }'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'</body>'||chr(10)||
'</html>'||chr(10)||
''||chr(10)||
'';

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
'   <td width=33% class="underbannerbar" style="text-align: left;">'||chr(10)||
'             &P0_OBJ_TAGLINE.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'   <td width=33% clas';

c3:=c3||'s="underbannerbar" style="color:#e10505;text-align: center;">'||chr(10)||
'             &OSI_BANNER.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'   <td width=100% class="underbannerbar" style="text-align: right;">'||chr(10)||
'             &P0_OBJ_ID.&nbsp;'||chr(10)||
'   </td>'||chr(10)||
'  </tr>'||chr(10)||
'   </table>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_01#'||chr(10)||
'#REGION_POSITION_07#<div style="clear:both;"/>'||chr(10)||
'#REGION_POSITION_08#'||chr(10)||
'#REGION_POSITION_02#'||chr(10)||
'#REGION_POSITION_03#'||chr(10)||
'<table class="conte';

c3:=c3||'ntTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'<!--'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; text-align:center; '||chr(10)||
'color:red;">#GLOBAL_NOTIFICATION#</td>'||chr(10)||
'-->'||chr(10)||
'</tr>'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top;">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#'||chr(10)||
''||chr(10)||
''||chr(10)||
'<!--div style="clear:both;"-->         ';

c3:=c3||'  '||chr(10)||
'#BOX_BODY##REGION_POSITION_04##REGION_POSITION_05#'||chr(10)||
'<!--/div-->'||chr(10)||
''||chr(10)||
''||chr(10)||
'     </td>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'<div class="versionDiv">I2MS &OSI_VERSION.</div>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'  document.write(getStatusBar("&P0_OBJ."));'||chr(10)||
'</script>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 179215462100554475 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Objects with Tabs and Menus',
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
  p_template_comment => '27-Oct-2011 - Tim Ward - CR#3822 - Made a change to gotoTab to take another parameter, '||chr(10)||
'                                   pObj so we can pass P0_OBJ to each tab.'||chr(10)||
''||chr(10)||
'15-May-2012 - Tim Ward - CR#3975 - Added JQuery/Superfish Menu JS/CSS coding.');
end;
 
null;
 
end;
/

 
prompt Component Export: PAGE TEMPLATE 92011431286949262
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 92011431286949262
 
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
''||chr(10)||
'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<script src="#IMAGE_PREFIX';

c1:=c1||'#javascript/i2ms_desktop.js" type="text/javascript"></script>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.';

c1:=c1||'7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<!-- Right Click Menu Code START -->'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/RightClickMenu/jquery.contextmenu.js"></script>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#jQuery/RightClickMenu/jquery.contextmenu.css" type="text/css" />'||chr(10)||
''||chr(10)||
'<script type="text/java';

c1:=c1||'script">'||chr(10)||
'/////////////////////////////////////////////////////////////////'||chr(10)||
'// Need to supply full path or IE will give a Security Warning //'||chr(10)||
'/////////////////////////////////////////////////////////////////'||chr(10)||
'var path = window.location+'''';'||chr(10)||
'path = path.substr(0,path.indexOf(''/pls/''))+#IMAGE_PREFIX#+''jQuery/RightClickMenu/'';'||chr(10)||
''||chr(10)||
'var vRankColumnNum = 0;'||chr(10)||
''||chr(10)||
'var menu1 = [ '||chr(10)||
'             {''Open Object'':{ onclic';

c1:=c1||'k:function(menuItem,menu) { javascript:getObjURL(GetSidFromOpenLink($(this))); }, icon:path+''OpenObject.gif'', title:''Open this Object'' } }, '||chr(10)||
'             {''Confirm'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Confirm''); }, icon:path+''Confirm.gif'', title:''Confirm Participant'' } }, '||chr(10)||
'             {''Email Link to this Object'':{ onclick:function(menuItem,menu) { ProccessRightClick($';

c1:=c1||'(this),''EmailLink''); }, icon:path+''EmailLink.gif'', title:''Email Link to this Object'' } }, '||chr(10)||
'             {''Submit Help Desk Ticket'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Ticket''); }, icon:path+''AskForHelp.gif'', title:''Submit Help Desk Ticket'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Launch VLT'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this';

c1:=c1||'),''VLT''); }, icon:path+''VLT.gif'', title:''Launch VLT'' } }, '||chr(10)||
'             {''View Associated Activities'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Activities''); }, icon:path+''ViewAssociatedActivities.gif'', title:''View Associated Activities'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Keep On Top of Recent Cache'':{ onclick:function(menuItem,menu) { ProccessRightCli';

c1:=c1||'ck($(this),''Keep''); }, icon:path+''KeepOnTopofRecentCache.gif'', title:''Keep On Top of Recent Cache'' } }, '||chr(10)||
'             {''Undo Keep On Top of Recent Cache'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''UnKeep''); }, icon:path+''UndoKeepOnTopofRecentCache.gif'', title:''Undo Keep On Top of Recent Cache'' } }, '||chr(10)||
'             {''Remove from Recent Cache'':{ onclick:function(menuItem,menu) { P';

c1:=c1||'roccessRightClick($(this),''RemoveRecent''); }, icon:path+''RemoveRecent16.gif'', title:''Remove from Recent Cache'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Clone'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Clone''); }, icon:path+''clone.gif'', title:''Clone'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Cancel'':{ onclick:function(menuItem,menu) { return ';

c1:=c1||'true;  }, title:''Cancel'' } } '||chr(10)||
'            ]; '||chr(10)||
''||chr(10)||
'function CheckAccess(pObj)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Check_Access'','||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pObj);'||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function IsRecent()'||chr(10)||
'{'||chr(10)||
' var vRankingFound = false;'||chr(10)||
' vRankColumn';

c1:=c1||'Num = 0'||chr(10)||
''||chr(10)||
' $(''.apexir_WORKSHEET_DATA'').find(''th'').each(function() '||chr(10)||
'  {'||chr(10)||
'   vRankColumnNum++;'||chr(10)||
''||chr(10)||
'   if($(this).text()==''Ranking'')'||chr(10)||
'     {'||chr(10)||
'      vRankingFound = true;'||chr(10)||
'      return false;'||chr(10)||
'     }'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' return vRankingFound;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetRankValue(pThis, pRankColumnNum)'||chr(10)||
'{'||chr(10)||
' var currentCol = 0;'||chr(10)||
' var vRankValue = "0";'||chr(10)||
''||chr(10)||
' pThis = $(pThis).parent();'||chr(10)||
''||chr(10)||
' $(pThis).find(''td'').each(function() '||chr(10)||
'  {'||chr(10)||
'   currentCol++;'||chr(10)||
'';

c1:=c1||'   if(currentCol==pRankColumnNum)'||chr(10)||
'     {'||chr(10)||
'      vRankValue = $(this).text();'||chr(10)||
'      return false;'||chr(10)||
'     }'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' return $.trim(vRankValue.toString());'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function HideShowItems(pThis, pMenu)'||chr(10)||
'{'||chr(10)||
' var vSID = GetSidFromOpenLink($(pThis));'||chr(10)||
' var vObjType = GetObjectTypeCode(vSID);'||chr(10)||
' var vIsRecent = IsRecent();'||chr(10)||
' var vRank;'||chr(10)||
' var vSeperatorCounter = 1;'||chr(10)||
' var vRemoveCloneSeperator = false;'||chr(10)||
''||chr(10)||
' if(vIsRecent==true)';

c1:=c1||''||chr(10)||
'   vRank = GetRankValue(pThis, vRankColumnNum);'||chr(10)||
' '||chr(10)||
' $(pMenu).find(''.context-menu-item'').each(function() '||chr(10)||
'  {'||chr(10)||
'   $(this).removeClass("context-menu-item-hidden");'||chr(10)||
'   $(this).removeClass("context-menu-item-disabled");'||chr(10)||
'   switch ($(this).prop(''title''))'||chr(10)||
'         {'||chr(10)||
'                                     case ''Clone'':'||chr(10)||
'                                                  if(vObjType.substring(0,4)!=''ACT.'')'||chr(10)||
'   ';

c1:=c1||'                                                 {'||chr(10)||
'                                                     $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                     vRemoveCloneSeperator = true;'||chr(10)||
'                                                    }'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                       case ''Confirm Participant'':'||chr(10)||
'   ';

c1:=c1||'                                               if(vObjType.substring(0,5)!=''PART.'')'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                  else'||chr(10)||
'                                                    {'||chr(10)||
'                                                     if(IsParticipantConfirmed(vSID)==''Y'')'||chr(10)||
'                  ';

c1:=c1||'                                     $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                    }'||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                case ''View Associated Activities'':'||chr(10)||
'                                                  if(vObjType.substring(0,5)!=''FILE.'')'||chr(10)||
'                                                    $(this).addClas';

c1:=c1||'s("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'               case ''Keep On Top of Recent Cache'':'||chr(10)||
'                                                  if(vIsRecent==false || vRank=="999999.999999")'||chr(10)||
'                                                   $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'      ';

c1:=c1||'    case ''Undo Keep On Top of Recent Cache'':'||chr(10)||
'                                                  if(vIsRecent==false || vRank!="999999.999999")'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                  case ''Remove from Recent Cache'':'||chr(10)||
'                                                  ';

c1:=c1||'if(vIsRecent==false)'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'         }'||chr(10)||
'  }); '||chr(10)||
''||chr(10)||
''||chr(10)||
' $(pMenu).find(''.context-menu-separator'').each(function() '||chr(10)||
'  {'||chr(10)||
'   $(this).removeClass("context-menu-item-hidden");'||chr(10)||
'   $(this).removeClass("context-menu-item-disabled");'||chr(10)||
''||chr(10)||
'   if (vIsRecent==false && vSepe';

c1:=c1||'ratorCounter==2)'||chr(10)||
'     $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'   if (vRemoveCloneSeperator==true && vSeperatorCounter==3)'||chr(10)||
'     $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'  vSeperatorCounter++;'||chr(10)||
'  }); '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).on(''mouseenter'', ''.apexir_WORKSHEET_DATA'', attachMenu);'||chr(10)||
''||chr(10)||
'function attachMenu()'||chr(10)||
'{'||chr(10)||
' $(''.apexir_WORKSHEET_DATA td'').contextMenu(menu1, {'||chr(10)||
'     theme:''vista'', '||chr(10)||
'     beforeShow: fu';

c1:=c1||'nction(t,e) '||chr(10)||
'               {'||chr(10)||
'                HideShowItems(t, $(this.menu));'||chr(10)||
'               } '||chr(10)||
'   }); '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetObjectTypeCode(pSID)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=GET_OBJECT_TYPE_CODE'','||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pSID);'||chr(10)||
' '||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' retur';

c1:=c1||'n gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetConfirmStatusChangeSID(pSID)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=GET_CONFIRM_STATUS_CHANGE_SID'','||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pSID);'||chr(10)||
' '||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function IsParticipantConfirmed(pSID)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_';

c1:=c1||'Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Is_Participant_Confirmed'', 	'||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pSID);'||chr(10)||
' '||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
''||chr(10)||
'function GetSidFromOpenLink(pthis)'||chr(10)||
'{'||chr(10)||
' while ($(pthis).prev().prop(''nodeName'')==''TD'')'||chr(10)||
'      pthis=$(pthis).prev();'||chr(10)||
'  '||chr(10)||
' var vTempString = pthis.p';

c1:=c1||'rop(''innerHTML'');'||chr(10)||
' var startOfSid = vTempString.indexOf(''getObjURL('');'||chr(10)||
' var endOfSid = vTempString.indexOf(''\'''');'||chr(10)||
' var vSID = vTempString.substring(startOfSid+11,endOfSid+9);'||chr(10)||
''||chr(10)||
' return vSID;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ProccessRightClick(pthis,pMenuClicked)'||chr(10)||
'{'||chr(10)||
' var pSID = GetSidFromOpenLink(pthis);'||chr(10)||
' switch (pMenuClicked)'||chr(10)||
'       {'||chr(10)||
'                       case ''Activities'':'||chr(10)||
'                                         run';

c1:=c1||'JQueryPopWin(''Associated Activities'', pSID, ''10155'');'||chr(10)||
'                                         break;'||chr(10)||
' '||chr(10)||
'                            case ''Clone'':'||chr(10)||
'                                         if (CheckAccess(pSID)=="Y")'||chr(10)||
''||chr(10)||
'                                           runJQueryPopWin (''Status'', pSID, ''CloneIt'');'||chr(10)||
''||chr(10)||
'                                         else'||chr(10)||
''||chr(10)||
'                                           alert';

c1:=c1||'(''You are not authorized to Clone this Activity.'');'||chr(10)||
''||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                          case ''Confirm'':'||chr(10)||
'                                         var vStatusChangeSID = GetConfirmStatusChangeSID(pSID);'||chr(10)||
''||chr(10)||
'                                         if(vStatusChangeSID==''not found'')'||chr(10)||
'                                           alert(''Proper Status could not be found,';

c1:=c1||' cannot Confirm from here.'');'||chr(10)||
'                                         else'||chr(10)||
'                                           {'||chr(10)||
'                                            if (CheckAccess(pSID)=="Y")'||chr(10)||
''||chr(10)||
'                                              runJQueryPopWin (''Status'', pSID, vStatusChangeSID);'||chr(10)||
''||chr(10)||
'                                            else'||chr(10)||
''||chr(10)||
'                                              alert(''You ';

c1:=c1||'are not authorized to Confirm this Participant.'');'||chr(10)||
'                                           }'||chr(10)||
''||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                             case ''Keep'':'||chr(10)||
'                           case ''UnKeep'':'||chr(10)||
'                     case ''RemoveRecent'':'||chr(10)||
'                                         var get = new htmldb_Get(null,'||chr(10)||
'                                                        ';

c1:=c1||'          $v(''pFlowId''),'||chr(10)||
'                                                                  ''APPLICATION_PROCESS=KeepUnkeepRemove_From_Recent_Objects'','||chr(10)||
'                                                                  $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
'                                         get.addParam(''x01'',pSID);'||chr(10)||
'                                         get.addParam(''x02'',pMenuClicked);'||chr(10)||
'                  ';

c1:=c1||'                       get.addParam(''x03'',''&USER_SID.'');'||chr(10)||
'                                         gReturn = $.trim(get.get());'||chr(10)||
'                                         window.location.reload();'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                           case ''Ticket'':'||chr(10)||
'                                         var itemValues = pSID+'',,''+''&APP_PAGE_ID.''+'',''+pSID;'||chr(10)||
'                     ';

c1:=c1||'                    newWindow({page:775,clear_cache:''775'',name:''feedback'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P775_LOCATION,P775_OBJECT'',item_values:itemValues})'||chr(10)||
'                                         break;'||chr(10)||
'             '||chr(10)||
'                              case ''VLT'':'||chr(10)||
'                                         newWindow({page:5550,clear_cache:''5550'',name:''VLT''+pSID,item_names:''P0_OBJ'',item_values:pSID,re';

c1:=c1||'quest:''OPEN''});'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                        case ''EmailLink'':'||chr(10)||
'                                         //openLocator(''301'',''P5000_PERSONNEL'',''Y'','''',''OPEN'','''','''',''Choose Personnel...'',''PERSONNEL'',''&P0_OBJ.'');'||chr(10)||
'                                         //openLocator(''301'','''',''Y'','''',''OPEN'','''','''',''Choose Personnel...'',''PERSONNEL'',''&P0_OBJ.'');'||chr(10)||
'                ';

c1:=c1||'                         runJQueryPopWin(''Email Link to this Object'', pSID, ''770'');'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                                 default:'||chr(10)||
'                                         alert(pMenuClicked+''=''+pSID);'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'       }'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'<!-- Right Click Menu Code END -->'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElem';

c1:=c1||'entsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnElements = [];'||chr(10)||
'	var current;'||chr(10)||
'	var length = elements.length;'||chr(10)||
'	for(var i=0; i<length; i++){'||chr(10)||
'		current = elements[i];'||chr(10)||
'		if(testClass.test(current.className))';

c1:=c1||'{'||chr(10)||
'			returnElements.push(current);'||chr(10)||
'		}'||chr(10)||
'	}'||chr(10)||
'	return returnElements;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jquery-datetimepicker.js"></script>'||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/jquery-datetimepicker-extras.css" type="text/css" rel="stylesheet" />'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_P';

c1:=c1||'REFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
''||chr(10)||
'<!-- Begin JQuery/Tipsy ToolTip Stuff -->'||chr(10)||
'<script type=''text/javascript'' src=''/i/jquery/tipsy-v1.0.0a-24/src/javascripts/jquery.tipsy.js''></script>'||chr(10)||
'<link rel=''stylesheet'' href=''/i/jquery/tipsy-v1.0.0a-24/src/stylesheets/tipsy.css'' type=''text/css'' />'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#jqu';

c1:=c1||'ery/jquery-hoverhelp.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script type=''text/javascript''>'||chr(10)||
'$(document).ready(function() {'||chr(10)||
'		$(''div.tooltip'').tipsy({live: true, fade: true, gravity: ''n'', title: ''tip''});'||chr(10)||
'        });'||chr(10)||
''||chr(10)||
'// Allows Resizing of Report Column Drop-downs //'||chr(10)||
'$(function()'||chr(10)||
'{  '||chr(10)||
' $("#apexir_rollover").resizable({minWidth:$("#apexir_rollover").width(), handles:"e", start:function(e,u){document.bo';

c1:=c1||'dy.onclick="";},stop:function(e,u){$(this).css({"height":""}); setTimeout(function(){document.body.onclick=gReport.dialog.check;},100);}}).css({"z-index":9999}).children(".ui-resizable-e").css({"background":"#EFEFEF"});'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'<!--   End JQuery/Tipsy ToolTip Stuff -->'||chr(10)||
''||chr(10)||
'<!-- JQuery/Superfish Menu Stuff --->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jQuery/superfish-1.4.8/css';

c1:=c1||'/superfish.css" media="screen">'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/superfish-1.4.8/js/superfish.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/superfish-1.4.8/js/supersubs.js"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
' '||chr(10)||
' $(document).ready(function(){ '||chr(10)||
'     $("ul.sf-menu").supersubs({ '||chr(10)||
'         minWidth:    12,   // minimum width of sub-menus in em unit';

c1:=c1||'s '||chr(10)||
'         maxWidth:    27,   // maximum width of sub-menus in em units '||chr(10)||
'         extraWidth:  1     // extra width can ensure lines don''t sometimes turn over '||chr(10)||
'                            // due to slight rounding differences and font-family '||chr(10)||
'     }).superfish();  // call supersubs first, then superfish, so that subs are '||chr(10)||
'                      // not display:none when measuring. Call before initi';

c1:=c1||'alising '||chr(10)||
'                      // containing tabs for same reason. '||chr(10)||
' });  '||chr(10)||
'</script>'||chr(10)||
'<!-- END JQuery/Superfish Menu Stuff --->'||chr(10)||
''||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' initNav();'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
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
'   <tr><td colspan="3">'||chr(10)||
'      <table width=100% cellpadding="0" cellspacing="0">'||chr(10)||
'  <tr>'||chr(10)||
'   <td width=100% class="underbannerbar" style="color:#e10505;text-align: center;">'||chr(10)||
'             &OSI_BANNER.&nbsp;'||chr(10)||
' ';

c3:=c3||'  </td>'||chr(10)||
'  </tr>'||chr(10)||
'   </table></td>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'<table summary="main content" class="dtMain">'||chr(10)||
'  <tr><td colspan="2">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</td></tr>'||chr(10)||
'  <tr><td colspan="2" class="dtMenuBar">#REGION_POSITION_06#</td></tr>'||chr(10)||
'  <tr class="dtMain">'||chr(10)||
'    <td class="dtSidebarList">#REGION_POSITION_02#</td>'||chr(10)||
'    <!--div style="clear:both;"-->'||chr(10)||
'    <td class="dtReportReg';

c3:=c3||'ion">#BOX_BODY#</td>'||chr(10)||
'    <!--/div-->'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<div class="versionDiv">I2MS &OSI_VERSION.</div>';

wwv_flow_api.create_template(
  p_id=> 92011431286949262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Desktop',
  p_body_title=> '<!--#BODY_TITLE#-->',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="dtSuccess">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="dtNotification">#MESSAGE#</div>',
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
  p_template_comment => '14-Oct-2011 Tim Ward - CR#3754-CFunds Expense Desktop View Description too large.'||chr(10)||
'                       Added JQuery/Tipsy Stuff to Header.'||chr(10)||
'14-Nov-2011 Tim Ward - Added Javascript to Header to allow resizing of report column'||chr(10)||
'                       drop-downs.'||chr(10)||
'15-May-2012 Tim Ward - CR#3975 - Added JQuery/Superfish Menu JS/CSS coding.');
end;
 
null;
 
end;
/

COMMIT;







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
--   Date and Time:   10:55 Friday July 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
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

PROMPT ...Remove page 20000
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>20000);
 
end;
/

 
--application/pages/page_20000
prompt  ...PAGE 20000: Activity Summary
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
'  function restrictionWarning(){'||chr(10)||
'     alert(''Please coordinate with HQ OPR before restricting this object'');'||chr(10)||
'  }'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'"JS_SEND_REQUEST"';

wwv_flow_api.create_page(
  p_id     => 20000,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Activity Summary',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89997626141511567+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120706105446',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '25-AUG-2010  J.Faris CHG0003228 - Updated P20000_DATE_LABEL to handle Open Case Checklist, AV support object types.'||chr(10)||
'04-OCT-2010  J.Faris CHG0003243 - Updated P20000_DATE_LABEL to handle all remaining activity types.'||chr(10)||
'06-OCT-2010  J.Faris   WCHG0000397 - Integrated Tim Ward''s page updates (involved re-apply of Export button functionality).'||chr(10)||
'07-OCT-2010 J.FARIS WCHG0000360 - Disabled date picker. Removed validation.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - Tim Ward - CR#3822 - Two Items Open at Same Time overwrite :P0_OBJ '||chr(10)||
'                          and cause problems.  Changed all Branching to pass :P0_OBJ.'||chr(10)||
''||chr(10)||
'19-Jan-2012 - Tim Ward - CR#3990 - Enable Restriction for AAPP.'||chr(10)||
''||chr(10)||
'30-Apr-2012 - Tim Ward - CR#4043 - Added Time to Effective Date and Date '||chr(10)||
'                          Recorded.'||chr(10)||
''||chr(10)||
'08-May-2012 - Tim Ward - CR#4045 - Added Substantive checkbox.'||chr(10)||
''||chr(10)||
'06-Jul-2012 - Tim Ward - Added Optional Hover Help Label to Restriction.'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>20000,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 91905523013189660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 20000,
  p_plug_name=> '&P20000_ACTIVITY_DESCRIPTION. Activity',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select transition_comment "Action",'||chr(10)||
'       create_by "Performed By",'||chr(10)||
'       effective_on "Effective Date",'||chr(10)||
'       create_on "Date Recorded"'||chr(10)||
'  from t_osi_status_history'||chr(10)||
' where obj = :P0_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 20000,
  p_name=> 'Activity History',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'QUERY_COLUMNS',
  p_query_num_rows=> '100000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No history found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '100000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P20000_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996144410883352 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'Action',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Action',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996215715883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Performed By',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Performed By',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996316299883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Effective Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Effective Date',
  p_column_format=> '&FMT_DATE.  hh24:mi:ss',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996436580883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Date Recorded',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Date Recorded',
  p_column_format=> '&FMT_DATE. hh24:mi:ss',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 91905830978191904 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 10,
  p_button_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16595501977703906 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 30,
  p_button_plug_id => 93995815537883335+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 20000);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 98438532224060568 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 20,
  p_button_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>91814539429626660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>91906139636194429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.::&DEBUG.::P0_OBJ:&P20000_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>91905830978191904+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 17-APR-2009 12:55 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>92847723654200564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P20000_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 30,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-MAY-2009 13:02 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3119025248737365 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5431035720360469 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION_LOCKOUT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction Lockout',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13686321518853353 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SUBSTANTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Substantive Investigative Activity?',
  p_source=>'SUBSTANTIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2: ;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16595722755709887 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 93995815537883335+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91940231689043741 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATE_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Created By',
  p_source=>'CREATE_BY',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91940416236048785 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATING_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Creating Unit',
  p_source=>'CREATING_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91944639569415069 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CURRENT_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Current Status',
  p_source=>'CURRENT_STATUS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91944839694415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATE_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Created',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'CREATE_ON',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945042497415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ASSIGNED_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Assigned Unit',
  p_source=>'ASSIGNED_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945235641415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_AUXILIARY_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Auxiliary Unit',
  p_source=>'AUXILIARY_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945435701415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SUSPENSE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Suspense Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'SUSPENSE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945636024415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_COMPLETE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Completed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'COMPLETE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945843973415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CLOSE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 19,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Closed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'CLOSE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
h := null;
h:=h||'Please coordinate with HQ OPR before restricting this object.';

wwv_flow_api.create_page_item(
  p_id=>91946019995415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction',
  p_source=>'RESTRICTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P20000_RESTRICTION_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_tag_attributes  => '&P20000_RESTRICTION_LOCKOUT. onchange="restrictionWarning()"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 1591526640502753+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_help_text   => h,
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91946237380415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_INV_SUPPORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Investigative Support',
  p_source=>'INV_SUPPORT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'CHECKBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_mission_category'||chr(10)||
' where notification_area = ''Y'''||chr(10)||
' order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 7,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 10,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT-TOP',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94784018045123213 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char('||chr(10)||
'   to_date(:P20000_ACTIVITY_DATE_VALUE, :FMT_DATE || '' '' || :FMT_TIME), '||chr(10)||
'   :FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'&P20000_DATE_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 12,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94791034518317174 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94932146476602702 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_DATE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'begin'||chr(10)||
'  case '||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.INTERVIEW.%'' then'||chr(10)||
'         return ''Interview Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE in (''ACT.DOCUMENT_REVIEW'','||chr(10)||
'                                 ''ACT.RECORDS_CHECK'','||chr(10)||
'                                 ''ACT.CC_REVIEW'','||chr(10)||
'                                 ''ACT.OC_REVIEW'') then'||chr(10)||
'          return ''Review Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''ACT.BRIEFING'' then'||chr(10)||
'          return ''Briefing Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''ACT.SURVEILLANCE'' then'||chr(10)||
'          return ''Requested Start Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.FINGERPRINT.%'' then'||chr(10)||
'         return ''Date Fingerprints Taken'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.SUSPACT_REPORT'' then'||chr(10)||
'         return ''Report Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.AV_SUPPORT'' then'||chr(10)||
'         return ''Date Request Received'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.COMP_INTRUSION'' then'||chr(10)||
'         return ''CCI Notified Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.INIT_NOTIF'' then'||chr(10)||
'        return ''Notified On'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.SOURCE_MEET'' then'||chr(10)||
'        return ''Meet Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.SEARCH%'' then'||chr(10)||
'        return ''Search Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.LIAISON'' then'||chr(10)||
'        return ''Liaison Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.CONSULTATION.%'' then'||chr(10)||
'        return ''Consultation Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.COORDINATION.%'' then'||chr(10)||
'        return ''Coordination Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.POLY_EXAM'' then'||chr(10)||
'        return ''Exam Date'';'||chr(10)||
'   else'||chr(10)||
'        return ''Activity Date'';'||chr(10)||
'   end case;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96473438013419564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Title',
  p_post_element_text=>'<td rowspan=10 width="40px"></td>',
  p_source=>'TITLE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>97057333623584254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>101984118218814233 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DATE_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_format_mask=>'&FMT_DATE. &FMT_TIME.',
  p_source=>'ACTIVITY_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 17733929408342681 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_computation_sequence => 10,
  p_computation_item=> 'P20000_ACTIVITY_DATE_VALUE',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select :P20000_ACTIVITY_DATE || '' '' ||'||chr(10)||
'       to_char(activity_date, :FMT_TIME)'||chr(10)||
'  from t_osi_activity'||chr(10)||
' where sid = :P0_OBJ',
  p_compute_when => ':REQUEST = ''SAVE'' and :P20000_ACTIVITY_DATE is not null',
  p_compute_when_type=>'PLSQL_EXPRESSION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96473647363422286 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_validation_name => 'P20000_TITLE not null',
  p_validation_sequence=> 5,
  p_validation => 'P20000_TITLE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Title must be specified.',
  p_when_button_pressed=> 91905830978191904 + wwv_flow_api.g_id_offset,
  p_associated_item=> 96473438013419564 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:V_OSI_ACTIVITY_SUMMARY:P20000_SID:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 94795040208479739 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Activity Summary',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>91905830978191904 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'F|#OWNER#:V_OSI_ACTIVITY_SUMMARY:P0_OBJ:SID';

wwv_flow_api.create_page_process(
  p_id     => 94790725729305191 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Activity Summary',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
''||chr(10)||
'  :p20000_sid := :p0_obj;'||chr(10)||
''||chr(10)||
'  :p20000_restriction_lov := osi_reference.get_lov(''RESTRICTION'');'||chr(10)||
''||chr(10)||
'  :p20000_restriction_lockout := null;'||chr(10)||
''||chr(10)||
'  select description into :P20000_ACTIVITY_DESCRIPTION '||chr(10)||
'        from t_core_obj_type '||chr(10)||
'        where sid=:P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 97049319144409735 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    for x in (select default_title'||chr(10)||
'                from t_osi_obj_type'||chr(10)||
'               where (   sid = :p0_obj_type_sid'||chr(10)||
'                      or sid member of osi_object.get_objtypes(:p0_obj_type_sid))'||chr(10)||
'                 and default_title is not null)'||chr(10)||
'    loop'||chr(10)||
'        :p20000_title := x.default_title;'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 9338207557266457 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 1,
  p_process_point=> 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Reset title',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST = ''SAVE'' AND :P20000_TITLE IS NULL',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 20000
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done

