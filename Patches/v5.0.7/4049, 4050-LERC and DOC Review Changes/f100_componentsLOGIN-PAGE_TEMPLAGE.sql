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
--   Date and Time:   14:08 Wednesday August 1, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Login
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
'<link rel="shortcut icon" href="#IMAGE_PREFIX#themes/OSI/i2ms.ico">'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#'||chr(10)||
'';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   function mySubmit(request, t)'||chr(10)||
'   { '||chr(10)||
'    $(t).hide();'||chr(10)||
'   }'||chr(10)||
'</script>'||chr(10)||
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
'                          Removed some Date Precision popup code.'||chr(10)||
''||chr(10)||
'11-Jul-2012 - Tim Ward - CR#4084 - Javascript error on button presses because'||chr(10)||
'                                    mySubmit didn''t exist.');
end;
 
null;
 
end;
/

COMMIT;
