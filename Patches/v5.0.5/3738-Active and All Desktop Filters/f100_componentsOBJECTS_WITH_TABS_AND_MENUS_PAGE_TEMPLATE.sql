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
--   Date and Time:   07:10 Wednesday December 28, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Objects with Tabs and Menus
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
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/';

c1:=c1||'submodal/subModal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond/jquery-ui-1.8.4.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.4.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.4.custom.min.js"></script';

c1:=c1||'>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#javascript/StatusBar.css" />'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/StatusBar.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
' var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
' var tag = tag || "*";'||chr(10)||
' var elm = elm || document;'||chr(10)||
' var elements = (tag =';

c1:=c1||'= "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
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
'      buttonImage: ''#IMAGE_PREFIX#asfdcldr.gif'','||chr(10)||
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
'             $("td.datepicker > input[t';

c1:=c1||'ype!=hidden]").datepicker();'||chr(10)||
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
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<link href=';

c1:=c1||'"#IMAGE_PREFIX#jquery/cluetip/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/dimensions/jquery.dimensions.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/hoverintent/jquery.hoverIntent.js" type="text/javascript"></script>'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-0.9.8/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script ty';

c1:=c1||'pe="text/javascript">'||chr(10)||
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
'            $item.attr(''relTitle'',';

c1:=c1||' $item.html());'||chr(10)||
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
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
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

COMMIT;
