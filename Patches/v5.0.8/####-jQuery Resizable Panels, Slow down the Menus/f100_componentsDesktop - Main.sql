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
--   Date and Time:   08:10 Wednesday November 7, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Desktop - Main
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
 
 
prompt Component Export: PAGE TEMPLATE 17229627269976029
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 17229627269976029
 
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
'<head>'||chr(10)||
'<title>#TITLE#</tit';

c1:=c1||'le>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#jQuery/jQueryIncludes.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#jQuery/jquery.layout-latest.css" type="text/css" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jQuery/jquery.layout-latest.min.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<!-- Accordian Stuff -->'||chr(10)||
'<script ';

c1:=c1||'type=''text/javascript''>'||chr(10)||
'$(function() '||chr(10)||
'{'||chr(10)||
' $( "#accordion" ).accordion('||chr(10)||
'  {heightStyle: "content",'||chr(10)||
'   event: "click hoverintent"'||chr(10)||
'  });'||chr(10)||
'});'||chr(10)||
''||chr(10)||
'    var cfg = ($.hoverintent = {'||chr(10)||
'        sensitivity: 7,'||chr(10)||
'        interval: 100'||chr(10)||
'    });'||chr(10)||
' '||chr(10)||
'    $.event.special.hoverintent = {'||chr(10)||
'        setup: function() {'||chr(10)||
'            $( this ).bind( "mouseover", jQuery.event.special.hoverintent.handler );'||chr(10)||
'        },'||chr(10)||
'        teard';

c1:=c1||'own: function() {'||chr(10)||
'            $( this ).unbind( "mouseover", jQuery.event.special.hoverintent.handler );'||chr(10)||
'        },'||chr(10)||
'        handler: function( event ) {'||chr(10)||
'            var that = this,'||chr(10)||
'                args = arguments,'||chr(10)||
'                target = $( event.target ),'||chr(10)||
'                cX, cY, pX, pY;'||chr(10)||
' '||chr(10)||
'            function track( event ) {'||chr(10)||
'                cX = event.pageX;'||chr(10)||
'                cY = event.pageY;'||chr(10)||
'';

c1:=c1||'            };'||chr(10)||
'            pX = event.pageX;'||chr(10)||
'            pY = event.pageY;'||chr(10)||
'            function clear() {'||chr(10)||
'                target'||chr(10)||
'                    .unbind( "mousemove", track )'||chr(10)||
'                    .unbind( "mouseout", arguments.callee );'||chr(10)||
'                clearTimeout( timeout );'||chr(10)||
'            }'||chr(10)||
'            function handler() {'||chr(10)||
'                if ( ( Math.abs( pX - cX ) + Math.abs( pY - cY ) ) < cfg';

c1:=c1||'.sensitivity ) {'||chr(10)||
'                    clear();'||chr(10)||
'                    event.type = "hoverintent";'||chr(10)||
'                    // prevent accessing the original event since the new event'||chr(10)||
'                    // is fired asynchronously and the old event is no longer'||chr(10)||
'                    // usable (#6028)'||chr(10)||
'                    event.originalEvent = {};'||chr(10)||
'                    jQuery.event.handle.apply( that, args );'||chr(10)||
'   ';

c1:=c1||'             } else {'||chr(10)||
'                    pX = cX;'||chr(10)||
'                    pY = cY;'||chr(10)||
'                    timeout = setTimeout( handler, cfg.interval );'||chr(10)||
'                }'||chr(10)||
'            }'||chr(10)||
'            var timeout = setTimeout( handler, cfg.interval );'||chr(10)||
'            target.mousemove( track ).mouseout( clear );'||chr(10)||
'            return true;'||chr(10)||
'        }'||chr(10)||
'    };'||chr(10)||
'</script>'||chr(10)||
'<style>'||chr(10)||
'table.desktopSidebarTable'||chr(10)||
'{'||chr(10)||
' /*border: 1p';

c1:=c1||'x solid black;*/'||chr(10)||
' width: 215px;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'td.desktopSidebarTableCol'||chr(10)||
'{'||chr(10)||
' /*border: 1px solid black;*/'||chr(10)||
' padding: .5em 1em;'||chr(10)||
' font-weight: bold;'||chr(10)||
' white-space: nowrap;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'td.desktopSidebarTableCol:hover'||chr(10)||
'{'||chr(10)||
' background-color:#2E6E9E;'||chr(10)||
' color:#FFFFFF;'||chr(10)||
' padding: .5em 1em;'||chr(10)||
' cursor:pointer;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'td.desktopSidebarTableColSelected'||chr(10)||
'{'||chr(10)||
' background-color:#2E6E9E;'||chr(10)||
' color:#FFFFFF;'||chr(10)||
' padding: .5em 1em;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<script type=''';

c1:=c1||'text/javascript''>'||chr(10)||
'var myLayout;'||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' $("div.tooltip").tipsy({live: true, fade: true, gravity: "n", title: "tip"});'||chr(10)||
''||chr(10)||
' myLayout = $(''body'').layout('||chr(10)||
' {'||chr(10)||
'   north__allowOverflow:      true'||chr(10)||
'  ,north__spacing_open:       1'||chr(10)||
'  ,north__spacing_closed:     1'||chr(10)||
'  ,north__resizerDragOpacity: 1'||chr(10)||
'  ,north__allowOverflow:      true'||chr(10)||
'  ,north__resizable:          false'||chr(10)||
'  ,north__closable:  ';

c1:=c1||'         false'||chr(10)||
'  ,north__slidable:           false'||chr(10)||
'  ,west__spacing_open:        6'||chr(10)||
'  ,west__spacing_closed:      6'||chr(10)||
'  ,west__resizerDragOpacity:  1'||chr(10)||
'  ,west__livePaneResizing:    true'||chr(10)||
'  ,west__fxSpeed_size:        "fast"'||chr(10)||
'  ,west__fxSpeed_open:        1000'||chr(10)||
'  ,west__fxSettings_open:     { easing: "easeOutBounce" }'||chr(10)||
'  ,west__fxSpeed_close:        1000'||chr(10)||
'  ,west__fxSettings_close:    { easing: "easeInBounc';

c1:=c1||'e" }'||chr(10)||
''||chr(10)||
'  ,center__maskContents:      true // IMPORTANT - enable iframe masking'||chr(10)||
' });'||chr(10)||
' '||chr(10)||
' $("#i2msNorth").css("padding","0px");'||chr(10)||
' $("#i2msWest").css("padding","5px");'||chr(10)||
' $("#mainFrame").css("padding","0px");'||chr(10)||
' $("#i2msMenus").css("border-bottom", "none");'||chr(10)||
' myLayout.sizePane("north",100);'||chr(10)||
' myLayout.allowOverflow("north");'||chr(10)||
' myLayout.sizePane("west",240);'||chr(10)||
''||chr(10)||
' $(''#desktop'').addClass(''desktopSidebarTableColSelec';

c1:=c1||'ted'');'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'#HEAD#'||chr(10)||
'<link rel="shortcut icon" href="#IMAGE_PREFIX#themes/OSI/i2ms.ico">'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<!-- #BOX_BODY# -->'||chr(10)||
'<iframe id="mainFrame" name="mainFrame" class="ui-layout-center"'||chr(10)||
'	width="100%" height="600" frameborder="0" scrolling="auto"'||chr(10)||
'	src="f?p=&APP_ID.:1005:&SESSION.::NO:::"></iframe>'||chr(10)||
''||chr(10)||
''||chr(10)||
'<div id="i2msNorth" class="ui-layout-north">'||chr(10)||
' <table class="bannerTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'   <td class="bannerLogo" width="30%">&nbsp;</td>'||chr(10)||
'   <td align="';

c3:=c3||'center" class="bannerLogo" width="40%"><img height="35px" src="#IMAGE_PREFIX#themes/OSI/osi_object_banner.gif"/></td>'||chr(10)||
'   <td class="navBar" width="30%">'||chr(10)||
'    <table cellpadding="0" cellspacing="0" border="0" summary="" align="right">'||chr(10)||
'     <tr>'||chr(10)||
'      <td><a href="&USER_URL.">&APP_USER.</a></td>'||chr(10)||
'      <td>#NAVIGATION_BAR#</td>'||chr(10)||
'     </tr>'||chr(10)||
'    </table>'||chr(10)||
'   </td> '||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'   <td colspan="3">'||chr(10)||
'    <';

c3:=c3||'table width=100% cellpadding="0" cellspacing="0">'||chr(10)||
'     <tr>'||chr(10)||
'      <td width=100% class="underbannerbar" style="color:#e10505;text-align: center;">&OSI_BANNER.&nbsp;v&OSI_VERSION.</td>'||chr(10)||
'     </tr>'||chr(10)||
'    </table>'||chr(10)||
'   </td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr><td colspan="2">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</td></tr>'||chr(10)||
' </table>'||chr(10)||
' <table summary="main content" class="dtMain">'||chr(10)||
'  <tr><td id="i2msMenus" ';

c3:=c3||'colspan="2" class="dtMenuBar">#REGION_POSITION_06#</td></tr>'||chr(10)||
' </table>'||chr(10)||
'</div>'||chr(10)||
''||chr(10)||
'<div id="i2msWest" class="ui-layout-west">'||chr(10)||
' <table class="desktopSidebar">'||chr(10)||
'  <tr>'||chr(10)||
'   <td>'||chr(10)||
'    <div id="accordion">'||chr(10)||
'     <h3>Desktop</h3>'||chr(10)||
'     <div style="padding: 2px;">'||chr(10)||
'        <table class="desktopSidebarTable">'||chr(10)||
'        <tr><td id=''desktop'' pageNumber=''1005'' class="desktopSidebarTableCol">I2MS Desktop</td></tr>'||chr(10)||
'      ';

c3:=c3||'  <tr><td id=''desktopActivities'' pageNumber=''1010'' class="desktopSidebarTableCol">Activities</td></tr>'||chr(10)||
'        <tr><td id=''desktopFiles'' pageNumber=''1020'' title=''Desktop > Files'' class="desktopSidebarTableCol">Files</td></tr>'||chr(10)||
'        <tr><td id=''desktopParticipants'' pageNumber=''1030'' title=''Desktop > Participants'' typeField=''P1030_PARTIC_TYPE'' typeValue=''PARTICIPANT'' class="desktopSidebarTableCol"';

c3:=c3||'>Participants</td></tr>'||chr(10)||
'        <tr><td id=''desktopWorkHours'' pageNumber=''1040'' class="desktopSidebarTableCol">Work Hours</td></tr>'||chr(10)||
'        <tr><td id=''desktopNotifications'' pageNumber=''1050'' class="desktopSidebarTableCol">Notifications</td></tr>'||chr(10)||
'        <tr><td id=''desktopExpenses'' pageNumber=''1060'' class="desktopSidebarTableCol">E-Funds Expenses</td></tr>'||chr(10)||
'        <tr><td id=''desktopAdvances'' pag';

c3:=c3||'eNumber=''1070'' class="desktopSidebarTableCol">E-Funds Advances</td></tr>'||chr(10)||
'        <tr><td id=''desktopFullTextSearch'' pageNumber=''1080'' class="desktopSidebarTableCol">Full Text Search</td></tr>'||chr(10)||
'        </table>'||chr(10)||
'     </div>'||chr(10)||
'     <h3>Files</h3>'||chr(10)||
'     <div style="padding: 2px;">'||chr(10)||
'        <table class="desktopSidebarTable">'||chr(10)||
'        <tr><td id=''FILE'' pageNumber=''1020'' title=''Files > All Files'' class="deskt';

c3:=c3||'opSidebarTableCol">All Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.INV'' pageNumber=''1110'' title=''Files > Investigative Files'' typeField=''P1110_FILE_TYPE'' typeValue=''FILE.INV'' class="desktopSidebarTableCol">Investigative Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.SERVICE'' pageNumber=''1130'' title=''Files > Service Files'' typeField=''P1130_FILE_TYPE'' typeValue=''FILE.SERVICE'' class="desktopSidebarTableCol">S';

c3:=c3||'ervice Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.SUPPORT'' pageNumber=''1140'' title=''Files > Support Files'' typeField=''P1140_FILE_TYPE'' typeValue=''FILE.SUPPORT'' class="desktopSidebarTableCol">Support Files</td></tr>'||chr(10)||
'        </table>'||chr(10)||
'     </div>'||chr(10)||
'     <h3>Investigative Files</h3>'||chr(10)||
'     <div style="padding: 2px;">'||chr(10)||
'        <table class="desktopSidebarTable">'||chr(10)||
'        <tr><td id=''FILE.INV'' pageNumber=''1110''';

c3:=c3||' title=''Investigative Files > All'' typeField=''P1110_FILE_TYPE'' typeValue=''FILE.INV'' class="desktopSidebarTableCol">All Investigative Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.INV.CASE'' pageNumber=''1110'' title=''Investigative Files > Case Files'' typeField=''P1110_FILE_TYPE'' typeValue=''FILE.INV.CASE'' class="desktopSidebarTableCol">Case Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.INV.DEV'' pageNumber=''1110''';

c3:=c3||' title=''Investigative Files > Developmental Files'' typeField=''P1110_FILE_TYPE'' typeValue=''FILE.INV.DEV'' class="desktopSidebarTableCol">Developmental Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.INV.INFO'' pageNumber=''1110'' title=''Investigative Files > Informational Files'' typeField=''P1110_FILE_TYPE'' typeValue=''FILE.INV.INFO'' class="desktopSidebarTableCol">Informational Files</td></tr>'||chr(10)||
'        </table>'||chr(10)||
'';

c3:=c3||'     </div>'||chr(10)||
'     <h3>Management Files</h3>'||chr(10)||
'     <div style="padding: 2px;">'||chr(10)||
'        <table class="desktopSidebarTable">'||chr(10)||
'        <tr><td id=''EMM'' pageNumber=''1320'' class="desktopSidebarTableCol">Evidence Management</td></tr>'||chr(10)||
'        <tr><td id=''PERSONNEL'' pageNumber=''1340'' class="desktopSidebarTableCol">Personnel</td></tr>'||chr(10)||
'        <tr><td id=''FILE.SOURCE'' pageNumber=''1350'' class="desktopSidebarTabl';

c3:=c3||'eCol">Sources</td></tr>'||chr(10)||
'        <tr><td id=''FILE.GEN.TARGETMGMT'' pageNumber=''1140'' title=''Management Files > Target Files'' typeField=''P1140_FILE_TYPE'' typeValue=''FILE.GEN.TARGETMGMT'' class="desktopSidebarTableCol">Target Files</td></tr>'||chr(10)||
'        <tr><td id=''UNIT'' pageNumber=''1390'' class="desktopSidebarTableCol">Units</td></tr>'||chr(10)||
'        </table>'||chr(10)||
'     </div>'||chr(10)||
'     <h3>Service Files</h3>'||chr(10)||
'     <div style';

c3:=c3||'="padding: 2px;">'||chr(10)||
'        <table class="desktopSidebarTable">'||chr(10)||
'        <tr><td id=''FILE.SERVICE'' pageNumber=''1130'' title=''Files > Service Files'' typeField=''P1130_FILE_TYPE'' typeValue=''FILE.SERVICE'' class="desktopSidebarTableCol">All Service Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.GEN.ANP'' pageNumber=''1130'' title=''Service > Analysis and Prodution Files'' typeField=''P1130_FILE_TYPE'' typeValue=''FILE.G';

c3:=c3||'EN.ANP'' class="desktopSidebarTableCol">Analysis and Production Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.POLY_FILE.SEC'' pageNumber=''1130'' title=''Service > CSP Files'' typeField=''P1130_FILE_TYPE'' typeValue=''FILE.POLY_FILE.SEC'' class="desktopSidebarTableCol">CSP Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.AAPP'' pageNumber=''1130'' title=''Service > AFOSI Applicant Files'' typeField=''P1130_FILE_TYPE'' typeValu';

c3:=c3||'e=''FILE.AAPP'' class="desktopSidebarTableCol">AFOSI Applicant Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.PSO'' pageNumber=''1130'' title=''Service > PSO Files'' typeField=''P1130_FILE_TYPE'' typeValue=''FILE.PSO'' class="desktopSidebarTableCol">PSO Files</td></tr>'||chr(10)||
'        </table>'||chr(10)||
'     </div>'||chr(10)||
'     <h3>Support Files</h3>'||chr(10)||
'     <div style="padding: 2px;">'||chr(10)||
'        <table class="desktopSidebarTable">'||chr(10)||
'        <tr><';

c3:=c3||'td id=''FILE.SUPPORT'' pageNumber=''1140'' title=''Support Files > All Support Files'' typeField=''P1140_FILE_TYPE'' typeValue=''FILE.SUPPORT'' class="desktopSidebarTableCol">All Support Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.POLY_FILE.CRIM'' pageNumber=''1140'' title=''Support Files > Criminal Polygraph Files'' typeField=''P1140_FILE_TYPE'' typeValue=''FILE.POLY_FILE.CRIM'' class="desktopSidebarTableCol">Criminal';

c3:=c3||' Polygraph Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.GEN.TECHSURV'' pageNumber=''1140'' title=''Support Files > Tech Surveillance Files'' typeField=''P1140_FILE_TYPE'' typeValue=''FILE.GEN.TECHSURV'' class="desktopSidebarTableCol">Tech Surveillance Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.GEN.SRCDEV'' pageNumber=''1140'' title=''Support Files > Source Development Files'' typeField=''P1140_FILE_TYPE'' typeValue=''FI';

c3:=c3||'LE.GEN.SRCDEV'' class="desktopSidebarTableCol">Source Development Files</td></tr>'||chr(10)||
'        <tr><td id=''FILE.GEN.UNDRCVROPSUPP'' pageNumber=''1140'' title=''Support Files > Undercover Operations Files'' typeField=''P1140_FILE_TYPE'' typeValue=''FILE.GEN.UNDRCVROPSUPP'' class="desktopSidebarTableCol">Undercover Operations Files</td></tr>'||chr(10)||
'        </table>'||chr(10)||
'     </div>'||chr(10)||
'     <h3>Participants</h3>'||chr(10)||
'     <div style="';

c3:=c3||'padding: 2px;">'||chr(10)||
'        <table class="desktopSidebarTable">'||chr(10)||
'        <tr><td id=''PARTICIPANT'' pageNumber=''1030'' title=''Participants > All Participants'' typeField=''P1030_PARTIC_TYPE'' typeValue=''PARTICIPANT'' class="desktopSidebarTableCol">All Participants</td></tr>'||chr(10)||
'        <tr><td id=''PART.INDIV'' pageNumber=''1030'' title=''Participants > Individuals'' typeField=''P1030_PARTIC_TYPE'' typeValue=''PART.INDIV''';

c3:=c3||' class="desktopSidebarTableCol">Individuals</td></tr>'||chr(10)||
'        <tr><td id=''PART.NONINDIV.COMP'' pageNumber=''1030'' title=''Participants > Companies'' typeField=''P1030_PARTIC_TYPE'' typeValue=''PART.NONINDIV.COMP'' class="desktopSidebarTableCol">Companies</td></tr>'||chr(10)||
'        <tr><td id=''PART.NONINDIV.ORG'' pageNumber=''1030'' title=''Participants > Organizations'' typeField=''P1030_PARTIC_TYPE'' typeValue=''PART.NON';

c3:=c3||'INDIV.ORG'' class="desktopSidebarTableCol">Organizations</td></tr>'||chr(10)||
'        <tr><td id=''PART.NONINDIV.PROG'' pageNumber=''1030'' title=''Participants > Programs'' typeField=''P1030_PARTIC_TYPE'' typeValue=''PART.NONINDIV.PROG'' class="desktopSidebarTableCol">Programs</td></tr>'||chr(10)||
'        </table>'||chr(10)||
'     </div>'||chr(10)||
'    </div>'||chr(10)||
'   </td>'||chr(10)||
'  </tr>'||chr(10)||
' </table>'||chr(10)||
'</div>'||chr(10)||
''||chr(10)||
'<script>'||chr(10)||
' var prevPage;'||chr(10)||
' $(".desktopSidebarTableCol").on("';

c3:=c3||'click", function(event)'||chr(10)||
'  {'||chr(10)||
'   $(''.desktopSidebarTableCol'').removeClass(''desktopSidebarTableColSelected'');'||chr(10)||
'   $(this).addClass(''desktopSidebarTableColSelected'');'||chr(10)||
''||chr(10)||
'   var pageNumber=$(this).attr(''pageNumber'');'||chr(10)||
'   var titleField='''';'||chr(10)||
'   var title=$(this).attr(''title'');'||chr(10)||
'   var typeField=$(this).attr(''typeField'');'||chr(10)||
'   var typeValue=$(this).attr(''typeValue'');'||chr(10)||
'   var url;'||chr(10)||
''||chr(10)||
'   if(typeof title === "undefine';

c3:=c3||'d")'||chr(10)||
'     title='''';'||chr(10)||
''||chr(10)||
'   if(typeof typeField=== "undefined")'||chr(10)||
'     typeField='''';'||chr(10)||
''||chr(10)||
'   if(typeof typeValue=== "undefined")'||chr(10)||
'     typeValue='''';'||chr(10)||
''||chr(10)||
'   if(typeof prevPage=== "undefined")'||chr(10)||
'     prevPage=''1000'';'||chr(10)||
''||chr(10)||
'   if(title!='''')'||chr(10)||
'     titleField=''P''+pageNumber+''_TITLE'';'||chr(10)||
''||chr(10)||
'   if(title!='''' && typeField!='''')'||chr(10)||
'     url=''f?p=&APP_ID.:''+pageNumber+'':&SESSION.::NO::''+typeField+'',''+titleField+'':''+typeValue+'',''+title;'||chr(10)||
''||chr(10)||
'  ';

c3:=c3||' if(title=='''' && typeField!='''')'||chr(10)||
'     url=''f?p=&APP_ID.:''+pageNumber+'':&SESSION.::NO::''+typeField+'':''+typeValue;'||chr(10)||
''||chr(10)||
'   if(title!='''' && typeField=='''')'||chr(10)||
'     url=''f?p=&APP_ID.:''+pageNumber+'':&SESSION.::NO::''+titleField+'':''+title;'||chr(10)||
''||chr(10)||
'   if(title=='''' && typeField=='''')'||chr(10)||
'     url=''f?p=&APP_ID.:''+pageNumber+'':&SESSION.::NO:::'';'||chr(10)||
'   '||chr(10)||
'   $(''#mainFrame'').attr(''src'',url);'||chr(10)||
''||chr(10)||
'   var tempstring;'||chr(10)||
''||chr(10)||
'   tempstring = $(''#i2m';

c3:=c3||'sHelp'').attr(''href'');'||chr(10)||
'   $(''#i2msHelp'').attr(''href'',tempstring.replace(prevPage,pageNumber));'||chr(10)||
''||chr(10)||
'   tempstring = $(''#i2msHelpDeskTicket'').attr(''onClick'');'||chr(10)||
'   $(''#i2msHelpDeskTicket'').attr(''onClick'',tempstring.replace(prevPage,pageNumber));'||chr(10)||
''||chr(10)||
'   prevPage=pageNumber;'||chr(10)||
'  });'||chr(10)||
'</script>';

wwv_flow_api.create_template(
  p_id=> 17229627269976029 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Desktop - Main',
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
'15-May-2012 Tim Ward - CR#3975 - Added JQuery/Superfish Menu JS/CSS coding.'||chr(10)||
'27-Aug-2012 Tim Ward - Changed Helpdesk ticket to use jQuery Dialog instead of browser'||chr(10)||
'                        pop-up.'||chr(10)||
'28-Aug-2012 Tim Ward - Changed Associated Activities to use 10150 instead of 10155.'||chr(10)||
'05-Oct-2012 Tim Ward - CR#4118 - Right Click Issues on EMM.');
end;
 
null;
 
end;
/

COMMIT;
