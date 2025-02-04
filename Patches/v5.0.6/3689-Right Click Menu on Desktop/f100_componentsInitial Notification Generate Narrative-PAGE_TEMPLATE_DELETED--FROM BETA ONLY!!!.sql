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
--   Date and Time:   12:26 Wednesday March 21, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Initial Notification Generate Narrative
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
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.1.min.js"></script>'||chr(10)||
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
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = ';

c1:=c1||'$(''#pFlowId'').val();'||chr(10)||
''||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.prop(''for''));'||chr(10)||
'            $item.prop(''rel'', get.url());'||chr(10)||
'            $item.prop(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'  ';

c1:=c1||'       arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity: 2,'||chr(10)||
'            interval: 200,'||chr(10)||
'            timeout: 0'||chr(10)||
'          }'||chr(10)||
'      }); '||chr(10)||
''||chr(10)||
'      // -- Handle Help Button --'||chr(10)||
'      $(''#apexir_ACTIONSMENU a[title="Help"]'').prop({''href'':''&HELP_URL.'',''target'':''_blank''});'||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
''||chr(10)||
'$( function() {'||chr(10)||
'   $(''#NarrativeConfirmationDialog'').dialog('||chr(10)||
'   {'||chr(10)||
'  ';

c1:=c1||'      modal : true ,'||chr(10)||
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
'          buttons: { Yes: function() {$( this ).dialog( "close" );},'||chr(10)||
'            ';

c1:=c1||'          No: function() {$( this ).dialog( "close" );},'||chr(10)||
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
'<a name="PAGETOP"></a>';

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

COMMIT;
