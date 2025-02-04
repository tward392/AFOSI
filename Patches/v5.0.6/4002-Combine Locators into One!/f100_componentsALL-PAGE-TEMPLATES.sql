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
--   Date and Time:   09:32 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Desktop
--     PAGE TEMPLATE: Empty
--     PAGE TEMPLATE: Initial Notification Generate Narrative
--     PAGE TEMPLATE: Login
--     PAGE TEMPLATE: Objects with Tabs and Menus
--     PAGE TEMPLATE: Objects without Tabs and Menus
--     PAGE TEMPLATE: Popup
--     PAGE TEMPLATE: Printer Friendly
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
'<link rel="stylesheet" href="#IMAGE_PREFIX#javascript/RightClickMenu.css" type="text/css" />'||chr(10)||
''||chr(10)||
' <div id="divContext" style="border: 1px solid gray; display: none; position: absolute">'||chr(10)||
'  <ul class="cmenu">'||chr(10)||
'   <li><a id="aClone" href="#">Clone</a></li>'||chr(10)||
'   <li><a id="aK';

c1:=c1||'eepOnTop" href="#">Keep On Top of Recent Cache</a></li>'||chr(10)||
'   <li class=topSep><a id="aCancel" href="#">Cancel</a></li>'||chr(10)||
'  </ul>'||chr(10)||
' </div>'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/RightClickMenu.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<sc';

c1:=c1||'ript src="#IMAGE_PREFIX#javascript/i2ms_desktop.js" type="text/javascript"></script>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQu';

c1:=c1||'ery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.get';

c1:=c1||'ElementsByTagName(tag);'||chr(10)||
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
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'      dateFormat: ''dd-M-yy'','||chr(10)||
'   ';

c1:=c1||'   changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
'      showOn: ''both'','||chr(10)||
'      bu';

c1:=c1||'ttonImage: ''#IMAGE_PREFIX#CalendarR24.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!=hidden]").datepicker();'||chr(10)||
'    ';

c1:=c1||'        });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link to each Date Picker //'||chr(10)||
'  $(''input.dat';

c1:=c1||'epickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Align the Calendar Image be';

c1:=c1||'tter -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<!--'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'-->'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.hoverIntent.js" type=';

c1:=c1||'"text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM';

c1:=c1||'_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'            timeout: 0'||chr(10)||
'         ';

c1:=c1||' }'||chr(10)||
'      }); '||chr(10)||
'      // -- Handle Help Button --'||chr(10)||
'      $(''#apexir_ACTIONSMENU a[title="Help"]'').attr({''href'':''&HELP_URL.'',''target'':''_blank''});'||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
''||chr(10)||
'<!-- Begin JQuery/Tipsy ToolTip Stuff -->'||chr(10)||
'<script type=''text/javascript'' src=''/i/jquery/tipsy-v1.0.0a-24/src/javascripts/jquery.tipsy.js''></script>'||chr(10)||
'<link rel=''stylesheet'' href=''/i/jquery/tipsy-v1';

c1:=c1||'.0.0a-24/src/stylesheets/tipsy.css'' type=''text/css'' />'||chr(10)||
''||chr(10)||
'<script type=''text/javascript''>'||chr(10)||
'$(document).ready(function() {'||chr(10)||
'		$(''div.tooltip'').tipsy({live: true, fade: true, gravity: ''n'', title: ''tip''});'||chr(10)||
'        });'||chr(10)||
''||chr(10)||
'// Allows Resizing of Report Column Drop-downs //'||chr(10)||
'$(function()'||chr(10)||
'{  '||chr(10)||
' $("#apexir_rollover").resizable({minWidth:$("#apexir_rollover").width(), handles:"e", start:function(e,u){document.body.';

c1:=c1||'onclick="";},stop:function(e,u){$(this).css({"height":""}); setTimeout(function(){document.body.onclick=gReport.dialog.check;},100);}}).css({"z-index":9999}).children(".ui-resizable-e").css({"background":"#EFEFEF"});'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'<!--   End JQuery/Tipsy ToolTip Stuff -->'||chr(10)||
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
'                       drop-downs.');
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
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="tex';

c1:=c1||'t/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag =';

c1:=c1||'= "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
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
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefault';

c1:=c1||'s({'||chr(10)||
'      dateFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: ';

c1:=c1||'true,'||chr(10)||
'      showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#CalendarR24.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > inpu';

c1:=c1||'t[type!=hidden]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link t';

c1:=c1||'o each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</scrip';

c1:=c1||'t>'||chr(10)||
''||chr(10)||
'<!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<!--'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'-->'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hover';

c1:=c1||'intent/jquery.hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(nu';

c1:=c1||'ll,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 20';

c1:=c1||'0,'||chr(10)||
'            timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
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

 
prompt Component Export: PAGE TEMPLATE 3750900317774787
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 3750900317774787
 
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
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
''||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css';

c1:=c1||'" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + classNa';

c1:=c1||'me + "(\\s|$)");'||chr(10)||
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
''||chr(10)||
'$(document).read';

c1:=c1||'y(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'      dateFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat';

c1:=c1||'''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
'      showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#CalendarR24.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery Da';

c1:=c1||'tePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!=hidden]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdis';

c1:=c1||'abled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
'  // Add a Today Link to each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(th';

c1:=c1||'is).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = document.getElementById("P22010_NARRATIVES_EQUAL", "", document);'||chr(10)||
'  if (inputs.value == ''N'')'||chr(10)||
'    {'||chr(10)||
'     //document.getElementById('''||chr(10)||
'     document.getElementById(''openDialog'').click();'||chr(10)||
'    }'||chr(10)||
' });'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-';

c1:=c1||'datepicker-trigger'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<!--'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'-->'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.hoverIntent.js" type="text/javascript"></scr';

c1:=c1||'ipt>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            ';

c1:=c1||'get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'            timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'';

c1:=c1||'//]]>'||chr(10)||
''||chr(10)||
'$( function() {'||chr(10)||
'   $(''#NarrativeConfirmationDialog'').dialog('||chr(10)||
'   {'||chr(10)||
'        modal : true ,'||chr(10)||
'        autoOpen : false ,'||chr(10)||
'        resizable: false,'||chr(10)||
'        height:''auto'','||chr(10)||
'        position:''center'','||chr(10)||
'        width:600,'||chr(10)||
'/*        buttons  : {'||chr(10)||
'            Cancel : function() {$(this).dialog("close")},'||chr(10)||
'            Create : function() {$(this).dialog("close");doSubmit(''CREATE'')}'||chr(10)||
'            }'||chr(10)||
'*/'||chr(10)||
'      ';

c1:=c1||'    buttons: { Yes: function() {$( this ).dialog( "close" );},'||chr(10)||
'                      No: function() {$( this ).dialog( "close" );},'||chr(10)||
'                  Cancel: function() {$( this ).dialog( "close" );}}'||chr(10)||
'   });'||chr(10)||
'});'||chr(10)||
' '||chr(10)||
'function openNarrativeConfirmationDialog()'||chr(10)||
'{'||chr(10)||
' $(''#NarrativeConfirmationDialog'').dialog(''open'');'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#'||chr(10)||
'<a nam';

c1:=c1||'e="PAGETOP"></a>';

c2:=c2||'<br />'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<SCRIPT type="text/javascript">'||chr(10)||
'<!--  to hide script contents from old browsers'||chr(10)||
' GenerateNarrative();'||chr(10)||
'// end hiding contents from old browsers  -->'||chr(10)||
'</SCRIPT>'||chr(10)||
''||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table class="t9pagebody" width="100%" border="0" summary="">'||chr(10)||
'<tr><td  valign="top" width="100%">#SUCCESS_MESSAGE# #NOTIFICATION_MESSAGE# #REGION_POSITION_03##BOX_BODY#</td></tr></table>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 3750900317774787 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Initial Notification Generate Narrative',
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
  p_template_comment => '');
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
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/javascript/mootools-osi.js"></script>  '||chr(10)||
''||chr(10)||
'<style>'||chr(10)||
''||chr(10)||
'.toggler {'||chr(10)||
'	color: #222;'||chr(10)||
'	margin: 0;'||chr(10)||
'	padding: 2px 5px;'||chr(10)||
'	background: #eee;'||chr(10)||
'	border-bottom: 1px solid #555;'||chr(10)||
'	border-right: 1px solid #555;'||chr(10)||
'	border-';

c1:=c1||'top: 1px solid #f5f5f5;'||chr(10)||
'	border-left: 1px solid #f5f5f5;'||chr(10)||
'	font-size: 11px;'||chr(10)||
'	font-weight: normal;'||chr(10)||
'	font-family: ''Andale Mono'', sans-serif;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.element{'||chr(10)||
'background-color:#999999;'||chr(10)||
'}'||chr(10)||
'.element a {'||chr(10)||
'color:#ffffff;'||chr(10)||
'text-decoration:none;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.element a:hover {'||chr(10)||
'text-decoration:underline;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.element p {'||chr(10)||
' margin:15px;'||chr(10)||
' white-space: nowrap;'||chr(10)||
'}'||chr(10)||
'input'||chr(10)||
'{'||chr(10)||
'background-color:#ffffc0;'||chr(10)||
'}'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<script language="Ja';

c1:=c1||'vaScript" type="text/javascript">'||chr(10)||
'<!--'||chr(10)||
'function DatePrecisionPopup (DBItem,DisplayItem,IncludeTime) {'||chr(10)||
'var formVal1 = document.getElementById(DBItem).value;'||chr(10)||
'var formVal2 = DBItem;'||chr(10)||
'var formVal3 = DisplayItem;'||chr(10)||
'var formVal4 = IncludeTime;'||chr(10)||
'var url;'||chr(10)||
'url = ''f?p=&APP_ID.:1:&APP_SESSION.::::P1_HIDDEN_DATE_VALUE,P1_HIDDEN_DB_CONTROL,P1_HIDDEN_DISPLAY_CONTROL,P1_HIDDEN_INCLUDE_TIME:'' + formVal1 + '','' + formV';

c1:=c1||'al2 + '','' + formVal3 + '','' + formVal4;'||chr(10)||
'w = open(url,"winLov","Scrollbars=1,resizable=1,width=500,height=360");'||chr(10)||
'if (w.opener == null)'||chr(10)||
'w.opener = self;'||chr(10)||
'w.focus();'||chr(10)||
'}'||chr(10)||
'//-->'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Suckerfish dropdown script -->'||chr(10)||
'<script type="text/javascript"><!--//--><![CDATA[//><!--'||chr(10)||
'  sfHover = function() {'||chr(10)||
'  	var navUls = document.getElementsByTagName(''ul'');'||chr(10)||
'    for (var c=0; c<navUls.length; c++)'||chr(10)||
'		{'||chr(10)||
'     ';

c1:=c1||' if(navUls[c].className == "nav")'||chr(10)||
'			{'||chr(10)||
'  		  /*loop through all li tags in this nav ul*/ '||chr(10)||
'  		  var sfEls = navUls[c].getElementsByTagName(''LI'');'||chr(10)||
'      	for (var i=0; i<sfEls.length; i++) '||chr(10)||
'  			{'||chr(10)||
'    			sfEls[i].onmouseover=function() '||chr(10)||
'  				{'||chr(10)||
'    			 this.className+=" sfhover";'||chr(10)||
'    			}'||chr(10)||
'  					'||chr(10)||
'      		sfEls[i].onmouseout=function() '||chr(10)||
'  				{'||chr(10)||
'      			this.className=this.className.replace(new RegE';

c1:=c1||'xp(" sfhover\\b"), "");'||chr(10)||
'      		}'||chr(10)||
'      	}'||chr(10)||
'			}'||chr(10)||
'		}'||chr(10)||
'  }'||chr(10)||
'  if (window.attachEvent) window.attachEvent("onload", sfHover);'||chr(10)||
''||chr(10)||
'//--><!]]></script>'||chr(10)||
'<!-- End of Suckerfish dropdown script -->'||chr(10)||
''||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/';

c1:=c1||'redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag |';

c1:=c1||'| "*";'||chr(10)||
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
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepick';

c1:=c1||'er > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'      dateFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mo';

c1:=c1||'n'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
'      showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#CalendarR24.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input ';

c1:=c1||'fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!=hidden]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $';

c1:=c1||'(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link to each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepicke';

c1:=c1||'rnew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<!--'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascrip';

c1:=c1||'t"></script>'||chr(10)||
'-->'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var ';

c1:=c1||'$item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: { ';

c1:=c1||'   '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'            timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
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
  p_template_comment => '<table class="bannerTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'      <td class="bannerLogo"><img src="#IMAGE_PREFIX#themes/OSI/i2ms2.png"/></td>'||chr(10)||
'   </tr>'||chr(10)||
'   <tr>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'<table class="contentTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; text-align:center; color:red;">'||chr(10)||
'      <!-- a name="PAGETOP"></a -->#GLOBAL_NOTIFICATION#</td></tr>'||chr(10)||
'   <tr>'||chr(10)||
'     <td width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top;">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#'||chr(10)||
'      <div style="clear:both;">           '||chr(10)||
'#BOX_BODY##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_08##REGION_POSITION_03#</div>'||chr(10)||
'     </td>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'');
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
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</s';

c1:=c1||'cript>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submoda';

c1:=c1||'l/subModal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<lin';

c1:=c1||'k rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#javascript/StatusBar.css" />'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/StatusBar.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
' var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
' var tag = tag || "*";'||chr(10)||
' var elm = elm || document;'||chr(10)||
' var elements = (tag == "*" &';

c1:=c1||'& elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
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
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'   ';

c1:=c1||'   dateFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
' ';

c1:=c1||'     showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#CalendarR24.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!';

c1:=c1||'=hidden]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
''||chr(10)||
'    for (var i=0;i<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link to each Date ';

c1:=c1||'Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Ali';

c1:=c1||'gn the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<!--'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'-->'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery';

c1:=c1||'.hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''AP';

c1:=c1||'PLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'          ';

c1:=c1||'  timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
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
'                                   pObj so we can pass P0_OBJ to each tab.');
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
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script';

c1:=c1||'>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/sub';

c1:=c1||'Modal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<link rel';

c1:=c1||'="stylesheet" type="text/css" href="#IMAGE_PREFIX#javascript/StatusBar.css" />'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/StatusBar.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
' var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
' var tag = tag || "*";'||chr(10)||
' var elm = elm || document;'||chr(10)||
' var elements = (tag == "*" && elm';

c1:=c1||'.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
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
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'      da';

c1:=c1||'teFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
'      ';

c1:=c1||'showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#CalendarR24.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!=hidd';

c1:=c1||'en]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
'  // Add a Today Link to each Date P';

c1:=c1||'icker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Alig';

c1:=c1||'n the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<!--'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'-->'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.';

c1:=c1||'hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APP';

c1:=c1||'LICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'           ';

c1:=c1||' timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
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
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet"';

c1:=c1||' href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script';

c1:=c1||'>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnElements = [];'||chr(10)||
'	var current;'||chr(10)||
'	var length = elements.length;'||chr(10)||
'	for(var i=0; i<length; i++){'||chr(10)||
'		current = e';

c1:=c1||'lements[i];'||chr(10)||
'		if(testClass.test(current.className)){'||chr(10)||
'			returnElements.push(current);'||chr(10)||
'		}'||chr(10)||
'	}'||chr(10)||
'	return returnElements;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'      dateFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYear: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText';

c1:=c1||': ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
'      showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#CalendarR24.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(';

c1:=c1||'function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!=hidden]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i';

c1:=c1||'<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link to each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align';

c1:=c1||' : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_P';

c1:=c1||'REFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<!--'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'-->'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script typ';

c1:=c1||'e="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', ';

c1:=c1||'$item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'            timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c1:=c1||''||chr(10)||
'<a name="PAGETOP"></a>';

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
'   function mySubmit(request){ '||chr(10)||
'       if (request == ''&BTN_SAVE.'' ||'||chr(10)||
'           request == ''&BTN_DELETE.'' ||'||chr(10)||
'       ';

c2:=c2||'    request == ''&BTN_CANCEL.'')'||chr(10)||
'           clearDirty();'||chr(10)||
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
'                         point.');
end;
 
null;
 
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
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_9/theme_V2.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>';

c1:=c1||''||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var returnEl';

c1:=c1||'ements = [];'||chr(10)||
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
''||chr(10)||
'$(document).ready(function () {'||chr(10)||
'     $(".datepicker > input[id]").datepicker();'||chr(10)||
''||chr(10)||
'  $.datepicker.setDefaults({'||chr(10)||
'      dateFormat: ''dd-M-yy'','||chr(10)||
'      changeMonth: true,'||chr(10)||
'      changeYea';

c1:=c1||'r: true,'||chr(10)||
'      closeText: ''Done'','||chr(10)||
'      showButtonPanel: true,'||chr(10)||
'      duration: ''slow'','||chr(10)||
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      dayNamesMin: [''Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
'      constrainInput: true,'||chr(10)||
'      showOn: ''both'','||chr(10)||
'      buttonImage: ''#IMAGE_PREFIX#CalendarR24';

c1:=c1||'.png'','||chr(10)||
'      buttonImageOnly: true,'||chr(10)||
'      buttonText: ''Calendar'','||chr(10)||
'      autoSize: true'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'             // Remove Original Date Picker //'||chr(10)||
'             $("td.datepicker + td").remove();'||chr(10)||
''||chr(10)||
'             // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
'             $("td.datepicker > input[type!=hidden]").datepicker();'||chr(10)||
'            });'||chr(10)||
''||chr(10)||
'$(document).ready(functi';

c1:=c1||'on()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (var i=0;i<inputs.length;i++)'||chr(10)||
'       {'||chr(10)||
'        if (typeof inputs[i].type == "undefined")'||chr(10)||
'          {'||chr(10)||
'           inputs[i].className="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link to each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-d';

c1:=c1||'atepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigg';

c1:=c1||'er'||chr(10)||
'{'||chr(10)||
' margin-left : 2px;'||chr(10)||
' vertical-align : bottom;'||chr(10)||
' cursor: pointer;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_';

c1:=c1||'PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $ite';

c1:=c1||'m.attr(''for''));'||chr(10)||
'            $item.attr(''rel'', get.url());'||chr(10)||
'            $item.attr(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'            timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
'<!-- End ';

c1:=c1||'JQuery/Hover help stuff -->'||chr(10)||
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

COMMIT;
