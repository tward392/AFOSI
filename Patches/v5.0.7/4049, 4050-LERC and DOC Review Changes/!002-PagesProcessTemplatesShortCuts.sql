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
--   Date and Time:   14:07 Wednesday August 1, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
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
'<link rel="shortcut icon" href="#IMAGE_PREFIX#themes/OSI/i2ms.ico">'||chr(10)||
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
--   Date and Time:   07:42 Thursday August 9, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: GET_LERC_DEFAULT_TITLE_NARRATIVE
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
 
 
prompt Component Export: APP PROCESS 12229714145416338
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'           vDocType  varchar2(20)    := apex_application.g_x01;'||chr(10)||
'            vResult  varchar2(10)    := apex_application.g_x02;'||chr(10)||
'       vObjTypeCode  varchar2(100)   := apex_application.g_x03;'||chr(10)||
'  vDefaultNarrative  varchar2(4000);'||chr(10)||
'   vTypeDescription  varchar2(4000);'||chr(10)||
'          vTypeCode  varchar2(4000);'||chr(10)||
'            vReturn  varchar2(4000);'||chr(10)||
'            vPrefix  varchar2(4000)  := '''';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'';

p:=p||'     select description,code into vTypeDescription,vTypeCode from t_osi_reference where sid=vDocType;'||chr(10)||
'     select default_narrative into vDefaultNarrative from t_osi_a_rc_dr_results where code=vResult;'||chr(10)||
''||chr(10)||
'     if (vObjTypeCode = ''ACT.RECORDS_CHECK'') then'||chr(10)||
''||chr(10)||
'       vReturn := ''Records Check of SUBJECT'' || ''~`~`~`~`'' || replace(vDefaultNarrative,''~RECORD_TYPE~'',vTypeDescription);'||chr(10)||
''||chr(10)||
'     elsif (vObjTypeCo';

p:=p||'de = ''ACT.DOCUMENT_REVIEW'') then'||chr(10)||
'          '||chr(10)||
'          case '||chr(10)||
''||chr(10)||
'              when vTypeCode in (''AR'',''ARMS'',''CF'',''CR'',''DCAA'',''DEIDS'',''HC'',''LAR'',''SADR'',''TR'') then'||chr(10)||
''||chr(10)||
'                  vPrefix := ''the '';'||chr(10)||
''||chr(10)||
'              else'||chr(10)||
''||chr(10)||
'                  vPrefix := '''';'||chr(10)||
''||chr(10)||
'          end case;'||chr(10)||
''||chr(10)||
'          case '||chr(10)||
''||chr(10)||
'              when vTypeCode in (''AR'',''ARMS'',''CF'',''CR'',''DCAA'',''DEIDS'',''DR'',''EDUTRAIN'',''FAR'',''FR'',''HC'',''LAR'',''';

p:=p||'MR'',''MHR'',''MPR'',''SADR'',''TR'') then'||chr(10)||
''||chr(10)||
'                  vDefaultNarrative := replace(vDefaultNarrative,'' records '','' '');'||chr(10)||
''||chr(10)||
'              else'||chr(10)||
'                  null;'||chr(10)||
''||chr(10)||
'          end case;'||chr(10)||
''||chr(10)||
'          vReturn := ''Document Review of SUBJECT'' || ''~`~`~`~`'' || replace(vDefaultNarrative,''~RECORD_TYPE~'',vPrefix || vTypeDescription);'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     htp.p(vReturn);'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         htp';

p:=p||'.p(sqlerrm);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 12229714145416338 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'GET_LERC_DEFAULT_TITLE_NARRATIVE',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '20-Mar-2012 - Tim Ward - CR#3696 - Created for Multi Records Check Creation.');
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
--   Date and Time:   14:09 Wednesday August 1, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Init Page Zero Items
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
 
 
prompt Component Export: APP PROCESS 88895918473684379
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  v_id varchar2(1000);'||chr(10)||
'begin'||chr(10)||
'   :P0_OBJ_IMAGE := NULL;'||chr(10)||
''||chr(10)||
'   --- SSL Certificate Items, CAC Card ---'||chr(10)||
'   :P0_SSL_CERT := OWA_UTIL.GET_CGI_ENV(''SSL_CLIENT_S_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT)))'||chr(10)||
'   LOOP'||chr(10)||
'       if substr(a.column_value,1,3) = ''CN='' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_S_DN_CN := substr(a.column_value,4);'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
''||chr(10)||
'   :P0_SSL_CERT_I := ';

p:=p||'OWA_UTIL.GET_CGI_ENV(''SSL_CLIENT_I_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT_I)))'||chr(10)||
'   LOOP'||chr(10)||
'       if a.column_value=''OU=DoD'' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_I_DN_OU := a.column_value;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
'   ---------------------------------------'||chr(10)||
''||chr(10)||
'   if :P0_OBJ is not null and :APP_PAGE_ID >= 5000 then'||chr(10)||
''||chr(10)||
'     select sid, '||chr(10)||
'            code, '||chr(10)||
'            core_obj.get_tagl';

p:=p||'ine(:P0_OBJ),'||chr(10)||
'            substr(core_obj.get_tagline(:P0_OBJ),1,70),'||chr(10)||
'            osi_object.get_id(:P0_OBJ, :P0_OBJ_CONTEXT),'||chr(10)||
'            replace(image,''.gif'',''.ico'')'||chr(10)||
'       into :P0_OBJ_TYPE_SID, '||chr(10)||
'            :P0_OBJ_TYPE_CODE, '||chr(10)||
'            :P0_OBJ_TAGLINE,'||chr(10)||
'            :P0_OBJ_TAGLINE_SHORT,'||chr(10)||
'            :P0_OBJ_ID,'||chr(10)||
'            :P0_OBJ_IMAGE'||chr(10)||
'       from t_core_obj_type'||chr(10)||
'      where sid = core_obj.';

p:=p||'get_objtype(:P0_OBJ);'||chr(10)||
''||chr(10)||
'      :P0_AUTHORIZED := osi_auth.check_access(:P0_OBJ);'||chr(10)||
''||chr(10)||
'      if :P0_OBJ_TYPE_CODE = ''UNIT'' and :APP_PAGE_ID between 30700 and 30799 then'||chr(10)||
''||chr(10)||
'        :P0_OBJ_TYPE_CODE := ''EMM'';'||chr(10)||
''||chr(10)||
'        select sid, replace(image,''.gif'',''.ico'') into :P0_OBJ_TYPE_SID, :P0_OBJ_IMAGE'||chr(10)||
'              from t_core_obj_type where code=''EMM'';'||chr(10)||
''||chr(10)||
'        :P0_OBJ_TAGLINE := ''Evidence Management Module for: ';

p:=p||''' || osi_unit.get_name(:P0_OBJ);'||chr(10)||
''||chr(10)||
'        :P0_AUTHORIZED := osi_auth.check_for_priv(''EMM_CUST'','||chr(10)||
'                                       core_obj.lookup_objtype(''EMM''),'||chr(10)||
'                                       null,'||chr(10)||
'                                       :P0_OBJ);'||chr(10)||
''||chr(10)||
'        :P0_WRITABLE := :P0_AUTHORIZED;'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'        if osi_auth.check_for_priv(''UPDATE'',:P0_OBJ_TYPE_SID)=''Y'' then'||chr(10)||
''||chr(10)||
'          :P0';

p:=p||'_WRITABLE := osi_object.check_writability(:P0_OBJ, :P0_OBJ_CONTEXT);'||chr(10)||
''||chr(10)||
'        else'||chr(10)||
''||chr(10)||
'          :P0_WRITABLE := ''N'';'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'  elsif :APP_PAGE_ID between 1000 and 4999 then'||chr(10)||
''||chr(10)||
'       :P0_OBJ := null;'||chr(10)||
'       :P0_OBJ_TYPE_SID := null;'||chr(10)||
'       :P0_OBJ_TYPE_CODE := null;'||chr(10)||
'       :P0_OBJ_CONTEXT := null;'||chr(10)||
'       :P0_OBJ_TAGLINE := null;'||chr(10)||
'       :P0_OBJ_IMAGE := null;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    :P0_O';

p:=p||'BJ_TYPE_SID := null;'||chr(10)||
'    :P0_OBJ_TAGLINE := null;'||chr(10)||
'    :P0_OBJ_ID := null;'||chr(10)||
'    if :P0_OBJ_TYPE_CODE is not null then'||chr(10)||
' '||chr(10)||
'      :P0_OBJ_TYPE_SID := core_obj.lookup_objtype(:P0_OBJ_TYPE_CODE);'||chr(10)||
' '||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if :P0_OBJ_TYPE_CODE <> ''ALL.REPORT_SPEC'' then'||chr(10)||
''||chr(10)||
'      :P0_OBJ_CONTEXT := null;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
'    :P0_AUTHORIZED := null;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if :APP_PAGE_ID=30101 then'||chr(10)||
''||chr(10)||
'    :P0_AUTHORIZED:=''Y'';'||chr(10)||
'    :P';

p:=p||'0_WRITABLE:=''Y'';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  if (:P0_OBJ_IMAGE is null) then'||chr(10)||
'    '||chr(10)||
'    if (:P0_OBJ_TYPE_CODE IS NOT NULL) then'||chr(10)||
''||chr(10)||
'      select replace(image,''.gif'',''.ico'') into :P0_OBJ_IMAGE from t_core_obj_type where code = :P0_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
' '||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 88895918473684379 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Init Page Zero Items',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Error Initializing Page Zero Items.',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> 'This process runs before the header for every page, and is responsible for maintaining the Page Zero Object-specifics (P0_OBJ, P0_OBJ_TYPE_CODE, P0_OBJ_TYPE_SID and P0_OBJ_TAGLINE). '||chr(10)||
''||chr(10)||
'16-JUN-2010 Jason Faris Task 2997 - Updated process to not reset obj_context item when obj_type_code = ''ALL.REPORT_SPEC''. '||chr(10)||
''||chr(10)||
'If the current page is not within our object specific pages, or common object pages (i.e. associations), then the values of these items are all cleared out.  Otherwise, if P0_OBJ is set (meaning we are in edit mode for an object), then P0_OBJ_TYPE_CODE and P0_OBJ_TYPE_SID are derived from P0_OBJ.  If P0_OBJ is NOT set (meaning we''re in create mode for an object), then P0_OBJ_TYPE_SID is derived from P0_OBJ_TYPE_CODE.'||chr(10)||
''||chr(10)||
''||chr(10)||
'08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Added Page 30101 check, so if accessed is always '||chr(10)||
'                       viewable by anyone.'||chr(10)||
''||chr(10)||
'20-Jun-2012 - Tim Ward Moved some page 0 items lookups from here back to'||chr(10)||
'                       the item source in Page 0.  Removed some debug'||chr(10)||
'                       print statements as well.');
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
--   Date and Time:   14:10 Wednesday August 1, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_BUILDRC_DRNARRATIVEANDTITLE
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
 
 
prompt Component Export: SHORTCUTS 15093629032910985
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="javascript">'||chr(10)||
'function buildRC_DRNarrativeandTitle(pTypeList, pResultList, pNarrative, pTitle, pObjectType)'||chr(10)||
'{'||chr(10)||
' var docTypetxt = $(''#''+pTypeList+'' > option:selected'').text();'||chr(10)||
' var resultstxt = $(''#''+pResultList+'' > option:selected'').text();'||chr(10)||
' var docTypeval = $(''#''+pTypeList+'' > option:selected'').val();'||chr(10)||
' var resultsval = $(''#''+pResultList+'' > option:selected'').val();'||chr(10)||
' var ObjectType';

c1:=c1||'txt = $(''#''+pObjectType).val();'||chr(10)||
''||chr(10)||
' if(docTypetxt!=''- Select -'' && resultstxt!=''- Select -'')'||chr(10)||
'   {'||chr(10)||
'    var get = new htmldb_Get(null,'||chr(10)||
'                             $v(''pFlowId''),'||chr(10)||
'                             ''APPLICATION_PROCESS=GET_LERC_DEFAULT_TITLE_NARRATIVE'','||chr(10)||
'                             $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
'    get.addParam(''x01'',docTypeval);'||chr(10)||
'    get.addParam(''x02'',resultsval);'||chr(10)||
'    get.addParam';

c1:=c1||'(''x03'',ObjectTypetxt);'||chr(10)||
' '||chr(10)||
'    gReturn = $.trim(get.get());'||chr(10)||
'    var placeHolder = gReturn.indexOf(''~`~`~`~`'');'||chr(10)||
''||chr(10)||
'    $s(pTitle,gReturn.substring(0,placeHolder));'||chr(10)||
'    $s(pNarrative,gReturn.substring(placeHolder+8));'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 15093629032910985 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_BUILDRC_DRNARRATIVEANDTITLE',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
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
--   Date and Time:   14:10 Wednesday August 1, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_HIDESHOWFIELD
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
 
 
prompt Component Export: SHORTCUTS 15245814402139178
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="javascript">'||chr(10)||
'function hideField(pID, isDate, isTextAreaWithCounter)'||chr(10)||
'{'||chr(10)||
' var hideText = "label[for="+pID+"],#"+pID;'||chr(10)||
' '||chr(10)||
' $(hideText).hide();'||chr(10)||
''||chr(10)||
' if(isDate==true)'||chr(10)||
'   {'||chr(10)||
'    $("#"+pID).next().hide();'||chr(10)||
'    $("#"+pID).next().next().hide();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if(isTextAreaWithCounter==true)'||chr(10)||
'   $("#"+pID).next().hide();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function showField(pID, isDate, isTextAreaWithCounter)'||chr(10)||
'{'||chr(10)||
' var hideText = "label[for';

c1:=c1||'="+pID+"],#"+pID;'||chr(10)||
''||chr(10)||
' $(hideText).show();'||chr(10)||
''||chr(10)||
' if(isDate==true)'||chr(10)||
'   {'||chr(10)||
'    $("#"+pID).next().show();'||chr(10)||
'    $("#"+pID).next().next().show();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if(isTextAreaWithCounter==true)'||chr(10)||
'   $("#"+pID).next().show();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 15245814402139178 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_HIDESHOWFIELD',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
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
'<link rel="shortcut icon" href="#IMAGE_PREFIX#themes/OSI/&P0_OBJ_IMAGE.">'||chr(10)||
'</hea';

c1:=c1||'d>'||chr(10)||
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
--   Date and Time:   14:08 Wednesday August 1, 2012
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
'<link rel="shortcut icon" href="#IMAGE_PREFIX#themes/OSI/&P0_OBJ_IMAGE.">'||chr(10)||
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
--   Date and Time:   14:06 Wednesday August 1, 2012
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

PROMPT ...Remove page 0
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>0);
 
end;
/

 
--application/pages/page_00000
prompt  ...PAGE 0: Page Zero
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 0,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Page Zero',
  p_step_title=> 'Page Zero',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215462100554475+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120727123209',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-MAY-2010  Jason Faris     Added ''Create Exam'' Region (button html) '||chr(10)||
'                             for Poly File support.'||chr(10)||
''||chr(10)||
'18-MAY-2010  Jason Faris     Fixed ''missing source'' bug in report label/url '||chr(10)||
'                             items 4 and 5.'||chr(10)||
''||chr(10)||
'16-JUN-2010  Jason Faris     Task 2997 - Create Run Report - Page 0 Html '||chr(10)||
'                             Region (button).  Update condition on VLT - '||chr(10)||
'                             Page 0 Html Region (button). '||chr(10)||
'                             Update Navigation L1, L2, L3 Regions w/ '||chr(10)||
'                             show_tab = ''Y'' check.  '||chr(10)||
'                             Added P0_LBL_REPORT6 - 10, P0_URL_REPORT6 - 10 '||chr(10)||
'                             for additional Case report support.'||chr(10)||
''||chr(10)||
'02-Mar-2011 - TJW - CR#3705 - Use Reports Menu now on CFunds Expenses, '||chr(10)||
'                              need to make sure the the VLT button '||chr(10)||
'                              doesn''''t show.'||chr(10)||
''||chr(10)||
'07-Jul-2011 Tim Ward - CR#3860 - Don''t show Read-Only on the FD-249 or '||chr(10)||
'                                 IAFIS Screens since they are read-only '||chr(10)||
'                                 by default.'||chr(10)||
'                                 Added 22710, 22711, 22715 and 22720'||chr(10)||
'                                 to not in clause, also added an ID to the '||chr(10)||
'                                 DIV so we can show/hide via javascript '||chr(10)||
'                                 in the future without changing '||chr(10)||
'                                 page 0.'||chr(10)||
''||chr(10)||
'10-Aug-2011 Tim Ward CR#3871 - Rearrange ROI Narratives.'||chr(10)||
'                                Added an ID to Run Report so we can hide '||chr(10)||
'                                it via Javascript..'||chr(10)||
''||chr(10)||
'27-Oct-2011 - CR#3822 - Two Items Open at Same Time overwrite :P0_OBJ '||chr(10)||
'                        and cause problems.  Added :P0_OBJ as a variable'||chr(10)||
'                        to goToTab call in Navigation L1, L2, and L3.'||chr(10)||
''||chr(10)||
'30-Apr-2012 - Tim Ward - CR#4043 - Changed Create Exam to call '||chr(10)||
'                          createActivityObject instead of createObject.'||chr(10)||
''||chr(10)||
'15-May-2012 - Tim Ward - CR#3975 - Create and WebLinks Menus now build'||chr(10)||
'                          from the database, removed regions and lists.'||chr(10)||
''||chr(10)||
'20-Jun-2012 - Tim Ward - Build Actions, Checklist, IAFIS, Versions, and '||chr(10)||
'                          E-Funds Menus from the database.  Removed'||chr(10)||
'                          associated regions and lists.  Reduced the items'||chr(10)||
'                          on the page from 62 to 31.'||chr(10)||
''||chr(10)||
'23-Jul-2012 - Tim Ward - Moved Create Activity Menu from Page 10150 to here'||chr(10)||
'                          and it only shows on FILES (Except SOURCES).'||chr(10)||
''||chr(10)||
'24-Jul-2012 - Tim Ward - Added P0_OBJ_IMAGE so we can display an icon on'||chr(10)||
'                          the browser tab depending on the Object Type.'||chr(10)||
'');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<div class="readOnlyBanner" id="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 4179910558064014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .001,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ is not null and'||chr(10)||
':APP_PAGE_ID not in (20100,5000,5050,5100,5250,5450,5500,5550,22710,22711,22715,22720,22805) and'||chr(10)||
':APP_PAGE_ID > 5000 and'||chr(10)||
':P0_WRITABLE = ''N''',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 4445306017641973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Region for all pages',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .002,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_03',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 13716901766966972 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Menus',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .01,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_06',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 14611614812197441 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Object Menus',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .045,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_header=> '<div id="Menus" style="z-index: 2; position: relative;">',
  p_plug_footer=> '</div>'||chr(10)||
'<script type="text/javascript"> '||chr(10)||
''||chr(10)||
'  $(document).ready(function() '||chr(10)||
'   {'||chr(10)||
'    var $menuDIV = $("#Menus");'||chr(10)||
'    $menuDIV.children("table").removeClass("formlayout");'||chr(10)||
'   });'||chr(10)||
''||chr(10)||
'</script>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<div id="Menus" style="z-index: 2; position: relative;"> fixes an IE Problem '||chr(10)||
'where the drop-downs will appear behind the tabs.  Need to remove the formlayout class or IE doesn''t display the menus correctly.');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid)>0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab('''''' ||'||chr(10)||
'                  sid ||';

s:=s||' '''''''' || '||chr(10)||
'                  '','' || '''''''' || :P0_OBJ || '''''''' ||'||chr(10)||
'                  ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 1'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                               from t_osi_tab'||chr(10)||
'                              where ob';

s:=s||'j_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 1'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'       and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_context) = ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91428410802515584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L1',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .091,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 0',
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
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid) > 0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab('''''' ||'||chr(10)||
'                  sid ';

s:=s||'|| '''''''' || '||chr(10)||
'                  '','' || '''''''' || :P0_OBJ || '''''''' ||'||chr(10)||
'                  ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 2'||chr(10)||
'       and parent_tab = core_list.get_list_element(:P0_TABS,1)'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                   ';

s:=s||'            from t_osi_tab'||chr(10)||
'                              where obj_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 2'||chr(10)||
'                                and parent_tab = core_list.get_list_element(:P0_TABS,1)'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'     and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_conte';

s:=s||'xt) = ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91429436391570289 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L2',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .092,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 1',
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
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid) > 0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab('''''' ||'||chr(10)||
'                  sid ';

s:=s||'|| '''''''' || '||chr(10)||
'                  '','' || '''''''' || :P0_OBJ || '''''''' ||'||chr(10)||
'                  ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 3'||chr(10)||
'       and parent_tab = core_list.get_list_element(:P0_TABS,2)'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                   ';

s:=s||'            from t_osi_tab'||chr(10)||
'                              where obj_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 3'||chr(10)||
'                                and parent_tab = core_list.get_list_element(:P0_TABS,2)'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_context) =';

s:=s||' ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91429609510572045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L3',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .093,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 2',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92111129885131770 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Desktop',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92112437289143401 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92225431857168384 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Investigative Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92386536451926771 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Management Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92387529309934109 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Service Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 25,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92388608316937557 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Support Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92389519051940631 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Participants',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 35,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 175627141504047911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Obj Items',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .02,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
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
  p_plug_footer=> '<script type="text/javascript">'||chr(10)||
'   if (document.getElementById(''P0_AUTHORIZED'').value == ''N''){'||chr(10)||
'        alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'        window.close();'||chr(10)||
'   }'||chr(10)||
'</script>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1132002937271910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CLIENT_S_DN_CN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>1132927757188885 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CERT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 330,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>1140331524832009 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TAGLINE_SHORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 36,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>1155812787079635 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CERT_I',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 340,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>1156020752081903 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CLIENT_I_DN_OU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 350,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>3297724392206432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_AUTHORIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>4169719506262300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_WRITABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 56,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>8965824316163151 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DESKTOP_NAVIGATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 360,
  p_item_plug_id => 92111129885131770+wwv_flow_api.g_id_offset,
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
  p_id=>12387231003449395 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DISPLAY_REPORTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 58,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
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
  p_id=>12390404094574065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_REPORTS_PRIV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 57,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'Declare'||chr(10)||
''||chr(10)||
'      v_count varchar(20);'||chr(10)||
'      v_objtype varchar(50);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'select count(*)'||chr(10)||
'  into v_count'||chr(10)||
'  from t_osi_report_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and obj_type member of OSI_OBJECT.GET_OBJTYPES(:P0_OBJ_TYPE_SID)'||chr(10)||
'   and active = ''Y'';'||chr(10)||
''||chr(10)||
'  v_objtype := OSI_OBJECT.GET_OBJTYPE_CODE(:P0_OBJ_TYPE_SID);'||chr(10)||
''||chr(10)||
''||chr(10)||
'if (v_count > 0) then'||chr(10)||
''||chr(10)||
'      if ( v_objtype like ''FILE.INV%'')  then'||chr(10)||
' '||chr(10)||
'         if (OSI_AUTH.CHECK_FOR_PRIV(''GEN_RPTS'', :P0_OBJ_TYPE_SID) = ''Y'') then'||chr(10)||
''||chr(10)||
'              :P0_DISPLAY_REPORTS := ''Y'';'||chr(10)||
''||chr(10)||
'        else'||chr(10)||
'              :P0_DISPLAY_REPORTS := ''N'';'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'       :P0_DISPLAY_REPORTS := ''Y'';'||chr(10)||
''||chr(10)||
'    '||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
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
  p_id=>13717217697971593 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CREATEMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> .01,
  p_item_plug_id => 13716901766966972+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETMENUHTML(''ID_CREATE'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>13717430510975220 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_WEBLINKSMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> .02,
  p_item_plug_id => 13716901766966972+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETMENUHTML(''ID_WEBLINKS'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>14613415036263774 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_ACTIONSMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 370,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''ACTIONS'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_status_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
  p_display_when_type=>'EXISTS',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>14615924657711238 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CHECKLISTMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 380,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''CHECKLIST'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_checklist_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
  p_display_when_type=>'EXISTS',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>14617200949817940 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_REPORTMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 390,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''REPORT'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P0_DISPLAY_REPORTS',
  p_display_when2=>'Y',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>14632602468103876 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_VLTMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<ul class="sf-menu">'||chr(10)||
'<li id="ID_VLT" class="sf-li-top">'||chr(10)||
'<a class="sf-with-ul-top sf-with-ul" href="javascript:void(0);" onclick="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})"><img class="sf-menu-img" src="/i/themes/OSI/vlt16.gif">VLT</a>'||chr(10)||
'</li>'||chr(10)||
'</ul>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE not in (''UNIT'', ''PERSONNEL'', ''ALL.REPORT_SPEC'', ''EMM'', ''CFUNDS_EXP'', ''CFUNDS_ADV'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a class="menuButton" href="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})">VLT</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14639605790437559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_IAFISMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 400,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''IAFIS'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE=''ACT.FINGERPRINT.CRIMINAL'''||chr(10)||
'and'||chr(10)||
'((:APP_PAGE_ID between 22705 and 22720)'||chr(10)||
'or'||chr(10)||
':APP_PAGE_ID IN (20000,20100,5000,5150,5050,5100,5250,20050,5350))',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>14656629600513696 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CREATEEXAM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 410,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<ul class="sf-menu">'||chr(10)||
'<li id="ID_CREATEEXAM" class="sf-li-top">'||chr(10)||
'<a class="sf-with-ul-top sf-with-ul" href="javascript:void(0);" onclick="javascript:createActivityObject(''21001'',''ACT.POLY_EXAM'',''P21001_PARTICIPANT_VERSION,P21001_FROM_OBJ'',''&P11505_PARTICIPANT_VERSION.,&P11505_SID.'');"><img class="sf-menu-img" src="/i/themes/OSI/createexam16.gif">Create Exam</a>'||chr(10)||
'</li>'||chr(10)||
'</ul>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':APP_PAGE_ID = 11505 and '||chr(10)||
'osi_auth.check_for_priv(''ASSOC'',core_obj.lookup_objtype(''ACT.POLY_EXAM'')) = ''Y''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a class="menuButton" href="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})">VLT</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14657304713534876 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_RUNREPORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<ul class="sf-menu">'||chr(10)||
'<li id="RunReport" class="sf-li-top">'||chr(10)||
'<a class="sf-with-ul-top sf-with-ul" href="f?p=&APP_ID.:802:&SESSION.::&DEBUG.::P802_REPORT_TYPE,P802_SPEC_OBJ:&P0_OBJ_CONTEXT.,&P810_OBJ."><img class="sf-menu-img" src="/i/themes/OSI/blank16.gif">Run Report</a>'||chr(10)||
'</li>'||chr(10)||
'</ul>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE = ''ALL.REPORT_SPEC''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a id="RunReport" class="menuButton" href="f?p=&APP_ID.:802:&SESSION.::&DEBUG.::P802_REPORT_TYPE,P802_SPEC_OBJ:&P0_OBJ_CONTEXT.,&P810_OBJ.">Run Report</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14658929909561095 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_PARTICIPANTVERSIONS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''VERSIONS'',''&P0_OBJ_CONTEXT.'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'')'||chr(10)||
'and osi_participant.is_confirmed(:p0_obj) is not null'||chr(10)||
'and ('||chr(10)||
'(:APP_PAGE_ID between 30105 and 30125) or'||chr(10)||
'(:APP_PAGE_ID between 30020 and 30040) or'||chr(10)||
'(:APP_PAGE_ID = 30415 and :P0_OBJ_TYPE_CODE not in (''PART.NONINDIV.PROG'')))',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>14938416823700711 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_ACTIVITYCREATEMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 460,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETMENUHTML(''ID_ACTIVITY'',''Create Activity'',''P21001_FROM_OBJ'',:P0_OBJ);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'substr(:P0_OBJ_TYPE_CODE,1,4)=''FILE'''||chr(10)||
'and'||chr(10)||
':P0_OBJ_TYPE_CODE != ''FILE.SOURCE'''||chr(10)||
'',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>15307203084812407 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_IMAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 470,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>22830502735416690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DIRTABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
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
  p_id=>88821038812330762 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TYPE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Type Sid',
  p_source_type=> 'STATIC',
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
  p_id=>89031738688681256 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>91571912883510851 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 37,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>96945507603721723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_CONTEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>99397625891426876 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LOC_SELECTIONS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>100031434194073317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_PARTIC_VERSION_INFO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 450,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_version_label(:p0_obj_context)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'')'||chr(10)||
'and osi_participant.is_confirmed(:p0_obj) is not null'||chr(10)||
'and ('||chr(10)||
'(:APP_PAGE_ID between 30105 and 30125) or'||chr(10)||
'(:APP_PAGE_ID between 30020 and 30040) or'||chr(10)||
'(:APP_PAGE_ID = 30415 and :P0_OBJ_TYPE_CODE not in (''PART.NONINDIV.PROG'')))',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>100456419971725899 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DIRTY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>175627449469050216 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Type Code',
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
  p_id=>175627653625051482 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Sid',
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
  p_id=>175628448739097322 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_TABS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Tabs',
  p_source=>'declare'||chr(10)||
'     v_result boolean;'||chr(10)||
'     v_tabs varchar2(4000) := null;'||chr(10)||
'     '||chr(10)||
'     procedure traverse_tab_parents(p_tab varchar2) is'||chr(10)||
'         v_parent t_osi_tab.parent_tab%type;'||chr(10)||
'     begin'||chr(10)||
'          v_result := core_list.add_item_to_list_front(p_tab, v_tabs);'||chr(10)||
'          '||chr(10)||
'          select parent_tab'||chr(10)||
'           into v_parent'||chr(10)||
'           from t_osi_tab'||chr(10)||
'          where sid = p_tab;'||chr(10)||
'          '||chr(10)||
'          if v_parent is not null then'||chr(10)||
'              traverse_tab_parents(v_parent);'||chr(10)||
'          end if;'||chr(10)||
'     end;'||chr(10)||
'begin'||chr(10)||
'    if :REQUEST = ''OPEN'' then'||chr(10)||
'       for i in (select sid'||chr(10)||
'                from t_osi_tab'||chr(10)||
'               where page_num = :APP_PAGE_ID'||chr(10)||
'                 and obj_type member of '||chr(10)||
'                        osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'               order by tab_level desc) loop'||chr(10)||
'          traverse_tab_parents(i.sid);'||chr(10)||
'          exit;        '||chr(10)||
'       end loop;'||chr(10)||
'       return v_tabs;'||chr(10)||
'    else'||chr(10)||
'         return :P0_TABS;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 0
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
--   Date and Time:   14:06 Wednesday August 1, 2012
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

PROMPT ...Remove page 21001
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>21001);
 
end;
/

 
--application/pages/page_21001
prompt  ...PAGE 21001: Activity Create
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_PRECISION_DATE"'||chr(10)||
'"JS_POPUP_OBJ_DATA"'||chr(10)||
'"JS_CREATE_PARTIC_WIDGET"'||chr(10)||
'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'"JS_ADDRESS_WIDGET"'||chr(10)||
'"STYLE_FORMLAYOUT_100%"'||chr(10)||
'"JS_BUILDRC_DRNARRATIVEANDTITLE"'||chr(10)||
'"JS_HIDESHOWFIELD"'||chr(10)||
''||chr(10)||
'<script language="javascript">'||chr(10)||
'function showParticWidget(objTypeCode)'||chr(10)||
'{'||chr(10)||
' var participantSID = $v(''P21001_PARTICIPANT'');'||chr(10)||
''||chr(10)||
' $("label[for=P21001_PARTIC_DISPLAY],#P21001_PARTIC_DISPLAY").show();'||chr(10)||
' $(''#FindPartic'').show';

ph:=ph||'();'||chr(10)||
''||chr(10)||
' if(participantSID.length > 0)'||chr(10)||
'   $(''#ViewPartic'').show();'||chr(10)||
' else'||chr(10)||
'   $(''#ViewPartic'').hide();'||chr(10)||
''||chr(10)||
' $(''#CreatePartic'').show();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function hideParticWidget(objTypeCode)'||chr(10)||
'{'||chr(10)||
' $("label[for=P21001_PARTIC_DISPLAY],#P21001_PARTIC_DISPLAY").hide();'||chr(10)||
' $(''#FindPartic'').hide();'||chr(10)||
' $(''#ViewPartic'').hide();'||chr(10)||
' $(''#CreatePartic'').hide();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function makeLabelOptional(pID)'||chr(10)||
'{'||chr(10)||
' var label = "label[for="+pID+"]";'||chr(10)||
''||chr(10)||
' $(lab';

ph:=ph||'el).toggleClass(''optionallabel'', true);'||chr(10)||
' $(label).toggleClass(''requiredlabel'', false);'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function makeLabelRequired(pID)'||chr(10)||
'{'||chr(10)||
' var label = "label[for="+pID+"]";'||chr(10)||
''||chr(10)||
' $(label).toggleClass(''optionallabel'', false);'||chr(10)||
' $(label).toggleClass(''requiredlabel'', true);'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function hideShowFields(pthis)'||chr(10)||
'{'||chr(10)||
' var list1Val = $("#P21001_LIST_1").val();'||chr(10)||
' var list1Text = $("#P21001_LIST_1 option:selected").text();'||chr(10)||
' var ob';

ph:=ph||'jTypeCode = $v(''P21001_OBJ_TYPE_CODE'');'||chr(10)||
' var explanationSIDS = $v(''P21001_EXPLANATION_VISIBLE'');'||chr(10)||
''||chr(10)||
' // Hide Optional Items //'||chr(10)||
' hideParticWidget();'||chr(10)||
' hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
' hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
' hideField(''P21001_HOUR'',false,false);'||chr(10)||
' hideField(''P21001_MINUTE'',false,false);'||chr(10)||
' hideField(''P21001_HOUR_2'',false,false);'||chr(10)||
' hideField(''P21001_MINUTE_2'',false,fal';

ph:=ph||'se);'||chr(10)||
' hideField(''P21001_DATE_2'',true,false);'||chr(10)||
' hideField(''P21001_DATE_3'',true,false);'||chr(10)||
' hideField(''P21001_DATE_4'',true,false);'||chr(10)||
' hideField(''P21001_DATE_5'',true,false);'||chr(10)||
' hideField(''P21001_TEXT_2'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_3'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_4'',false,true);'||chr(10)||
' hideField(''P21001_TEXT_5'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_7'',fals';

ph:=ph||'e,true);'||chr(10)||
' hideField(''P21001_TEXT_8'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
' hideField(''P21001_LIST_1'',false,false);'||chr(10)||
' hideField(''P21001_LIST_2'',false';

ph:=ph||',false);'||chr(10)||
' hideField(''P21001_LIST_3'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
' // Hide File Association if value is passed in //'||chr(10)||
' hideField(''P21001_FILE_NAME'',false,false);'||chr(10)||
' hideField(''P21001_FIND_FILE_WIDGET'',false,false);'||chr(10)||
' if($v(''P21001_FROM_OBJ'')=='''')'||chr(10)||
'   {'||chr(10)||
'    showField(''P21001_FILE_NAME'',false,false);'||chr(10)||
'    showField(''P21001';

ph:=ph||'_FIND_FILE_WIDGET'',false,false);'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' // Default Labels to Optional //'||chr(10)||
' makeLabelOptional(''P21001_LIST_1'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_2'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_2'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_4'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_5'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_PR';

ph:=ph||'ECISION_DATE_1_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_2_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_3_DISPLAY'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_TEXT_1'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_2'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_3'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_4'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_5'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_6'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_7'');'||chr(10)||
' mak';

ph:=ph||'eLabelOptional(''P21001_TEXT_8'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_9'');'||chr(10)||
' makeLabelOptional(''P21001_DOCUMENT_NUMBER'');'||chr(10)||
' makeLabelOptional(''P21001_EXPLANATION'');'||chr(10)||
' '||chr(10)||
' makeLabelOptional(''P21001_HOUR'');'||chr(10)||
' makeLabelOptional(''P21001_HOUR_2'',false,false);'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_1'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_2'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_3'');'||chr(10)||
' makeLabelOptional(''P21001';

ph:=ph||'_RADIOGROUP_4'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
' switch(objTypeCode)'||chr(10)||
'       {'||chr(10)||
'                        case ''ACT.AAPP'':'||chr(10)||
'        case ''ACT.AAPP.DOCUMENT_REVIEW'':'||chr(10)||
'              case ''ACT.AAPP.EDUCATION'':'||chr(10)||
'             case ''ACT.AAPP.EMPLOYMENT'':'||chr(10)||
'              case ''ACT.AAPP.INTERVIEW'':'||chr(10)||
'          case ''ACT.AAPP.RECORDS_CHECK'':'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'           ';

ph:=ph||'       case ''ACT.AV_SUPPORT'':'||chr(10)||
'                                        showField(''P21001_LIST_1'');'||chr(10)||
'                                        showField(''P21001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                    case ''ACT.BRIEFI';

ph:=ph||'NG'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'              case ''ACT.COMP_INTRUSION'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,fa';

ph:=ph||'lse);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_3'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PREC';

ph:=ph||'ISION_DATE_1'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_3'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_PRECISION_DATE_1_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'            ';

ph:=ph||'                            showField(''P21001_TEXT_8'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'             case ''ACT.DOCUMENT_REVIEW'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'       ';

ph:=ph||'                                 showParticWidget();'||chr(10)||
''||chr(10)||
'                                        if(explanationSIDS.indexOf(list1Val+''~'')>=0)'||chr(10)||
'                                          {'||chr(10)||
'                                           hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                      ';

ph:=ph||'    }'||chr(10)||
'                                        else'||chr(10)||
'                                          {'||chr(10)||
'                                           showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                          }'||chr(10)||
''||chr(10)||
'                                        buildRC_DRNarrativeandTitle(''P21001_LIST_';

ph:=ph||'1'',''P21001_LIST_2'',''P21001_NARRATIVE'',''P21001_TITLE'',''P21001_OBJ_TYPE_CODE'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'          case ''ACT.FINGERPRINT.MANUAL'':'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                  case ''ACT.INIT_NOTIF'':'||chr(10)||
'';

ph:=ph||'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'           case ''ACT.INTERVIEW.SUBJECT'':'||chr(10)||
'            case ''ACT.INTERVIEW.VICTIM'':'||chr(10)||
'           case ''ACT.INTERVIEW.WITNESS'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'     ';

ph:=ph||'                                   showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
''||chr(10)||
'                     case ''ACT.LIAISON'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'               ';

ph:=ph||'                         makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
''||chr(10)||
'                                        if(list1Text!=''- Select -'')'||chr(10)||
'                                          {'||chr(10)||
'                                           if ($("#P21001_TITLE").val().length>0)'||chr(10)||
'                                             {'||chr(10)||
'                     ';

ph:=ph||'                         $("#P21001_LIST_1 option").each(function(i)'||chr(10)||
'                                               {'||chr(10)||
'                                                $("#P21001_TITLE").val($("#P21001_TITLE").val().replace($(this).text(),list1Text));'||chr(10)||
'                                               });'||chr(10)||
'                                             }'||chr(10)||
'                                           else'||chr(10)||
'    ';

ph:=ph||'                                         {'||chr(10)||
'                                              $("#P21001_TITLE").val(list1Text);'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.MEDIA_ANALYSIS'':'||chr(10)||
'                  case ''ACT.DDD_TRIAGE'':'||chr(10)||
'                                        showField(''P2';

ph:=ph||'1001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_4'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_5'',true,false);'||chr(10)||
'                                        showField(''P21001_TEXT_2'',false,false);'||chr(10)||
'                                        showField(''P21001';

ph:=ph||'_TEXT_3'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_4'',false,true);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelReq';

ph:=ph||'uired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_DATE_2'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                   case ''ACT.POLY_EXAM'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showField(''P2';

ph:=ph||'1001_HOUR_2'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_5'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequir';

ph:=ph||'ed(''P21001_HOUR'');'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
'               case ''ACT.RECORDS_CHECK'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',fal';

ph:=ph||'se,false);'||chr(10)||
'                                        showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        buildRC_DRNarrativeandTitle(''P21001_LIST_1'',''P21001_LIST_2'',''P21001_NARRATIVE'',''P21001_TITLE'',''P21001_OBJ_TYPE_CODE'');'||chr(10)||
'     ';

ph:=ph||'                                   break;'||chr(10)||
''||chr(10)||
'                      case ''ACT.SEARCH'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
' ';

ph:=ph||'                                       if(list1Text==''Search of Person'')'||chr(10)||
'                                          {'||chr(10)||
'                                           $(''#P21001_TEXT_6_LABEL'').val('''');'||chr(10)||
'                                           hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                                           showParticWidget();'||chr(10)||
'                                          }'||chr(10)||
'               ';

ph:=ph||'                         else'||chr(10)||
'                                          {'||chr(10)||
'                                           if(list1Text!=''- Select -'')'||chr(10)||
'                                             {'||chr(10)||
'                                              $(''#P21001_TEXT_6_LABEL'').val(''Explanation'');'||chr(10)||
'                                              showField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                              ';

ph:=ph||'                makeLabelRequired(''P21001_TEXT_6'');'||chr(10)||
'                                              hideParticWidget();'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                 case ''ACT.SOURCE_MEET'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                      ';

ph:=ph||'                  makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showField(''P21001_TEXT_7'',false,true);'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                           ';

ph:=ph||'             showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                case ''ACT.SURVEILLANCE'':'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
'                    ';

ph:=ph||'                    showField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_9'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
'       ';

ph:=ph||'                                 showField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
'                                        showField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001';

ph:=ph||'_RADIOGROUP_3'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001_TEXT_9'');'||chr(10)||
'                                        makeLabelRequired(''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        if(typeof pthis !== "undefine';

ph:=ph||'d") '||chr(10)||
'                                          {'||chr(10)||
'                                           if(pthis.id==''P21001_LIST_1'')'||chr(10)||
'                                             {'||chr(10)||
'                                              var get = new htmldb_Get(null,'||chr(10)||
'                                                                       $v(''pFlowId''),'||chr(10)||
'                                                                    ';

ph:=ph||'   ''APPLICATION_PROCESS=Get_Act_Surveillance_Techniques'','||chr(10)||
'                                                                       $v(''pFlowStepId''));'||chr(10)||
'                                              get.addParam(''x01'',list1Val);'||chr(10)||
'                                              gReturn = $.trim(get.get());'||chr(10)||
'                                              $("#P21001_LIST_2_LOV").val(gReturn);'||chr(10)||
'  '||chr(10)||
'             ';

ph:=ph||'                                 $(''#P21001_LIST_2'').children().remove().end().append(''<option selected value="%null%">- Select -</option>'');'||chr(10)||
'                                              var items = gReturn.split(","), i;'||chr(10)||
''||chr(10)||
'                                              for (i = 0; i < items.length; i++) '||chr(10)||
'                                                 {'||chr(10)||
'                                           ';

ph:=ph||'       if(items[i].length>0)'||chr(10)||
'                                                    {'||chr(10)||
'                                                     var values = items[i].split('';'');'||chr(10)||
'                                                     $(''#P21001_LIST_2'').children().end().append(''<option value="''+values[1]+''">''+values[0]+''</option>'');'||chr(10)||
'                                                    }'||chr(10)||
'                      ';

ph:=ph||'                           }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.SUSPACT_REPORT'':'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                               ';

ph:=ph||'         showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                                default:'||chr(10)||
'                                        if ($(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.CONSULTATION'' || $(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.COORD';

ph:=ph||'INATION'')'||chr(10)||
'                                          {'||chr(10)||
'                                           // Adjust the Title //'||chr(10)||
'                                           adjustCoordinationConsultationTitle();'||chr(10)||
''||chr(10)||
'                                           showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                           showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                 ';

ph:=ph||'          showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                           showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                           makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                           makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                           makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
'                             ';

ph:=ph||'              // Make sure there is at least one Coordination/Consultation Type in the Select List //'||chr(10)||
'                                           var list = document.getElementById(''P21001_LIST_1'');'||chr(10)||
'                                           if(list!=null)'||chr(10)||
'                                             {'||chr(10)||
'                                              if(list.length==1)'||chr(10)||
'                                ';

ph:=ph||'                {'||chr(10)||
'                                                 if(list[0].text=''- Select -'')'||chr(10)||
'                                                   {'||chr(10)||
'                                                    alert(''You are not authorized to create any types of ''+'||chr(10)||
'                                                          $("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activities.\n\n''+'||chr(10)||
'     ';

ph:=ph||'                                                     ''Please talk to your Unit Commander about assigning you permissions for ''+$("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activity Types that you need to create.'');'||chr(10)||
''||chr(10)||
'                                                    window.close();'||chr(10)||
'                                                   }'||chr(10)||
'                                               ';

ph:=ph||' }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
''||chr(10)||
'       }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function hideShowParticipantDetails(pHideParticDetails)'||chr(10)||
'{'||chr(10)||
' var src=$(''#showHideParticipantIcon'').attr("src");'||chr(10)||
' var forceHide="N";'||chr(10)||
''||chr(10)||
' if (typeof pHideParticDetails !== "undefined")'||chr(10)||
'   forceShow=pHideParticDetails;'||chr(10)||
''||chr(10)||
' if (src.indexOf("plus.gif")>-1 ';

ph:=ph||'|| pHideParticDetails=="N")'||chr(10)||
'   {'||chr(10)||
'    showField(''P21001_PARTICIPANT_DETAILS'',false,false);'||chr(10)||
'    $(''#showHideParticipantIcon'').attr("src",src.replace("plus","minus"));'||chr(10)||
'    $(''#P21001_HIDEPARTICDETAILS'').val("N");'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    hideField(''P21001_PARTICIPANT_DETAILS'',false,false);'||chr(10)||
'    $(''#showHideParticipantIcon'').attr("src",src.replace("minus","plus"));'||chr(10)||
'    $(''#P21001_HIDEPARTICDETAILS'').val("Y"';

ph:=ph||');'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' hideShowFields();'||chr(10)||
' $(document).attr("title", $v(''P21001_OBJ_TYPE_DESCRIPTION'')+" (Create)");'||chr(10)||
' hideShowParticipantDetails($v(''P21001_HIDEPARTICDETAILS''));'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 21001,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Activity Create',
  p_step_title=> '&P21001_OBJECT_TYPE_DESCRIPTION. (Create)',
  p_html_page_onload=>'onload=" '||chr(10)||
'if (''&P21001_DONE.'' == ''Y'')'||chr(10)||
'   {'||chr(10)||
'    window.opener.location.reload();'||chr(10)||
''||chr(10)||
'javascript:newWindow({page:20000,clear_cache:''20000'',name:''&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,'',request:''OPEN''});'||chr(10)||
''||chr(10)||
'window.close();'||chr(10)||
'   }'||chr(10)||
'"',
  p_step_sub_title => '&amp;P21000_INTERVIEW_TYPE_CODE. Interview (Create)',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="javascript">'||chr(10)||
'function adjustCoordinationConsultationTitle()'||chr(10)||
'{'||chr(10)||
' var vType;'||chr(10)||
' var vSubType;'||chr(10)||
' '||chr(10)||
' if($(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.CONSULTATION'')'||chr(10)||
'   vType=''Consultation, '';'||chr(10)||
''||chr(10)||
' if($(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.COORDINATION'')'||chr(10)||
'   vType=''Coordination, '';'||chr(10)||
''||chr(10)||
' $(''#P21001_LIST_1 > option:selected'').each(function() '||chr(10)||
'  {'||chr(10)||
'   vSubType=$(this).text();'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' if($(''#P21001_TITLE'').val()=='''')'||chr(10)||
'   $(''#P21001_TITLE'').val(vType+vSubType);'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    $(''#P21001_LIST_1 > option'').each(function() '||chr(10)||
'     {'||chr(10)||
'      $(''#P21001_TITLE'').val($(''#P21001_TITLE'').val().replace(vType+$(this).text(),vType+vSubType));'||chr(10)||
'     });'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120731120144',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '30-Apr-2012 - Tim Ward - CR#4043 - Created to replace ALL Activity Create Pages.'||chr(10)||
''||chr(10)||
'09-May-2012 - Tim Ward - CR#4045 - Added Substantive checkbox.'||chr(10)||
''||chr(10)||
'12-Jul-2012 - Tim Ward - CR#4027 - Added Support for Digital Data Device '||chr(10)||
'                          Triage Activity Creation (Same as Media Analysis).'||chr(10)||
''||chr(10)||
'24-Jul-2012 - Tim Ward - CR#4049, 4050 - Changed Records Check and Document'||chr(10)||
'                          Review Activities to allow multiples in the same'||chr(10)||
'                          activity.  (No longer creates separate activities).'||chr(10)||
'                         Moved buildRecordsCheckNarrativeandTitle to a '||chr(10)||
'                          shortcut and renamed it to '||chr(10)||
'                          buildRC_DRNarrativeandTitle so it can be used in '||chr(10)||
'                          page 21505.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21001,p_text=>ph);
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
  p_id=> 12904705240371170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_plug_name=> '&P21001_OBJ_TYPE_DESCRIPTION.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 2,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 12910916778411479 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_plug_name=> 'Hidden Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Date of Check",'||chr(10)||
'       REFERENCE_NUM,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Record Type",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       EXPLANATION as "Explanation",'||chr(10)||
'       OSI_PARTICIPANT.GET_NAME(SUBJECT_OF_ACTIVITY,''Y'') AS "Subject of Activity",'||chr(10)||
'       OSI_FILE.GET_FULL_ID(FILE_SID) AS "Associated File",'||chr(10)||
'       decod';

s:=s||'e(complete,''Y'',''Yes'',''No'') AS "Completed",'||chr(10)||
'       decode(substantive,''Y'',''Yes'',''No'') AS "Substantive",'||chr(10)||
'       osi_reference.lookup_ref_desc(restriction) as "Restriction",'||chr(10)||
'       decode(:p21001_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_RC_DR_MULTI_TEMP'||chr(10)||
'WHERE PERSONNEL=''&USER_SID.'''||chr(10)||
'AND OBJ_TYPE_CODE=:P21001_OBJ_TYPE_CODE';

wwv_flow_api.create_report_region (
  p_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_name=> '&P21001_OBJ_TYPE_DESCRIPTION.s to Create',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 12,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'')',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> '<b><center>***** No &P21001_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13133431966888176 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 2,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13134213981888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 1,
  p_column_heading=> '<input type="Checkbox" onclick="$f_CheckFirstColumn(this)">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 13133827010888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Date of Check',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> 'dd-Mon-rrrr',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14972827686395334 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'REFERENCE_NUM',
  p_column_display_sequence=> 7,
  p_column_heading=> '&P21001_DOCUMENT_NUMBER_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 13134107013888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Record Type',
  p_column_display_sequence=> 4,
  p_column_heading=> '&P21001_LIST_1_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 13133732062888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Narrative',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15302810657085947 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Explanation',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Explanation',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P21001_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
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
  p_id=> 15331505382329072 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Subject of Activity',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Subject Of Activity',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15332009800349262 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Associated File',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Associated File',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15333511588453873 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Completed',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Completed',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15333606506453873 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Substantive',
  p_column_display_sequence=> 12,
  p_column_heading=> 'Substantive',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15333826263467491 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Restriction',
  p_column_display_sequence=> 13,
  p_column_heading=> 'Restriction',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 13134331185888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 13,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 13135030246888185 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 28,
  p_button_plug_id => 13133232569888170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:if(confirm(''Are you Sure?''))window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13134800613888185 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 29,
  p_button_plug_id => 13133232569888170+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE_SELECTED',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'apex_application.g_f01.count > 0',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13194825949751935 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 55,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add to List',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 12904922969371175 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 10,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 12905111003371179 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 20,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>12910006285371195 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.:OPEN:&DEBUG.:20000::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>12904922969371175+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'NEVER',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>13121809958048925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_branch_action=> 'f?p=&APP_ID.:21001:&SESSION.::&DEBUG.::P21001_DONE:Y',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 15,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST IN (''CREATE'',''CREATE_ACTIVITIES'');',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>12910206330371198 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_branch_action=> 'f?p=&APP_ID.:21001:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12905329984371179 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '1',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_HOUR_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'HOURS',
  p_lov => '.'||to_char(2668702431512846 + wwv_flow_api.g_id_offset)||'.',
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
  p_display_when=>'P21001_HOUR_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12905522107371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_MINUTE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '00',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_HOUR_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>12905715820371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
  p_source_type=> 'STATIC',
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
  p_id=>12905904281371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'osi_object.get_default_title(:p0_obj_type_sid)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Title',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:55%"',
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
  p_id=>12906121078371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTICIPANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12906326561371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 19,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PARTIC_LABEL.',
  p_source=>'begin'||chr(10)||
'  if :P21001_PARTICIPANT_VERSION is not null then'||chr(10)||
'    '||chr(10)||
'    if :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' then'||chr(10)||
''||chr(10)||
'      return osi_source.get_id(:P21001_PARTICIPANT_VERSION);'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
'  '||chr(10)||
'      return osi_participant.get_name(:P21001_PARTICIPANT_VERSION);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'     return null;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:35%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>12906502807371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ_TYPE_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Subject',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
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
  p_id=>12906717306371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RESTRICTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 41,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_RESTRICTION_LOV.',
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
  p_id=>12906918076371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 42,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative',
  p_source=>'NARRATIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 30000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>12907108080371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_ACTIVITY_DATE_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'ACTIVITY_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_ACTIVITY_DATE_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12907304848371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'&P21001_FIND_WIDGET_SRC.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popupLocator(400,''P21000_PARTICIPANT'',''N'','''',''PART.INDIV'');">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12907515743371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 21,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a id="ViewPartic" title="View Participant" href="'' || osi_object.get_object_url(:P21001_PARTICIPANT) || ''">&ICON_MAGNIFY.</a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTICIPANT_VERSION IS NOT NULL AND'||chr(10)||
':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>12907706838371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_CREATE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 22,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a id="CreatePartic" title="Create Participant" href="javascript:createParticWidget(''P21001_PARTICIPANT'');">&ICON_CREATE_PERSON.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>12907923844371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RESTRICTION_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12908121248371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTICIPANT_VERSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12908316096371186 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTICIPANT_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 23,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_INTERVIEW_TYPE_CODE. Details',
  p_source=>'OSI_PARTICIPANT.GET_DETAILS(:P21001_PARTICIPANT_VERSION);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTICIPANT IS NOT NULL AND'||chr(10)||
':P21001_OBJ_TYPE_CODE NOT IN (''ACT.SOURCE_MEET'');',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>12910803272407585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Subject',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
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
  p_id=>12911709346522858 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12912428571566265 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12912614503571653 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ACTIVITY_DATE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12913523123621463 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ_TYPE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12914904619805374 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_LIST_1_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_LIST_1_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:hideShowFields(this);"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_LIST_1_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => ':P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.SEARCH'','||chr(10)||
'                          ''ACT.SOURCE_MEET'','||chr(10)||
'                          ''ACT.AV_SUPPORT'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.POLY_EXAM'','||chr(10)||
'                          ''ACT.COMP_INTRUSION'','||chr(10)||
'                          ''ACT.SURVEILLANCE'','||chr(10)||
'                          ''ACT.SUSPACT_REPORT'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION'');');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12915113277807860 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DOCUMENT_NUMBER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 28,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DOCUMENT_NUMBER_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:55%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') <> nvl(:P21200_DOCUMENT_TYPE,''bogus'')',
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
  p_id=>12915320895810124 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_EXPLANATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 29,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_EXPLANATION_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 1000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>12915919641819178 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_1_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'LOV 1',
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
  p_label_alignment  => 'RIGHT',
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
  p_id=>12918202662088712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_EXPLANATION_VISIBLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12924731602636352 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_1_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12926328166862504 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_2_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12926503710864870 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12928326566871455 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_LIST_2_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_LIST_2_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:hideShowFields();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_LIST_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => ':P21001_OBJ_TYPE_CODE IN (''ACT.SEARCH'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.COMP_INTRUSION'','||chr(10)||
'                          ''ACT.SURVEILLANCE'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION'');'||chr(10)||
'');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12932203045809568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_WIDGET_VISIBLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12942327276441017 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_TYPE_EXCLUDES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 3000,
  p_cMaxlength=> 30000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
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
  p_id=>12946729943009549 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FIND_WIDGET_SRC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12963606682366990 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_2_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12963816725369957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_3_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12964027114372877 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 75,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12964202658375333 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 85,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12967816182530599 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_4_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 95,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12968021723532186 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_5_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12968228303534167 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_4_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_4_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12968404885536819 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_5_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_5_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12970905418650523 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 26,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_2_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12971114076653026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 27,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_3_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12971321695655233 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12971528621657180 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12975726299789051 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_4_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 155,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12975914656795099 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 31,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_4_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_4_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12977913888889537 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_1_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 165,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>12980308151048742 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 34,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_1_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_1_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13047822330601649 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 24,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_5_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:55%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_5_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13048108609607111 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_5_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 185,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13049430342632380 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 195,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13049604500634359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 205,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>13049920430638958 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '1',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_HOUR_2_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'HOURS',
  p_lov => '.'||to_char(2668702431512846 + wwv_flow_api.g_id_offset)||'.',
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
  p_display_when=>'P21001_HOUR_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13050127010640835 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_MINUTE_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '00',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_HOUR_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>13055408215928711 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FROM_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 215,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13056800821992881 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_6_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 225,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13057013981996676 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 32,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_6_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 200,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:55%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_6_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13058600138068376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_7_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 235,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13058812605071937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_7_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 500,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_7_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13060413812384584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_EXPLANATION_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 245,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13060930350408221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 255,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13061104162410177 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_3_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 265,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13061322170415383 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 37,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_LIST_3_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_LIST_3_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:hideShowFields();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_LIST_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => ':P21001_OBJ_TYPE_CODE=''ACT.COMP_INTRUSION'';');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13063726868605943 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 33,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_2_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13063901719608122 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 295,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13064107606609838 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_8_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 305,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13064321458613865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 38,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_8_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:35%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_8_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13068002635442591 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 315,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13068210946445034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_4_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 325,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13068420296447757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_3_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13068627222449767 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 36,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_4_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_4_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13077131845435134 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_9_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 335,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13077312929439106 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_9_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 3,
  p_cMaxlength=> 3,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_9_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13077731760454088 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_9_SUFFIX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 10,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-BOTTOM',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>'P21001_TEXT_9_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>13103128531526299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 380,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13103308922530066 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 39,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_ADDRESS_LABEL.',
  p_source=>'osi_address.get_addr_display(:P21001_ADDRESS_VALUE,''FIELDS'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 36,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_tag_attributes  => 'readOnly',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_ADDRESS_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13103521389533706 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href ="javascript:void(0);" onclick = "javascript:addressWidget(''P21001_ADDRESS_VALUE''); return false;">&ICON_ADDRESS.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_ADDRESS_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>13104532518565254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 410,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13119309490764917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARENT_OBJECTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13122311474058870 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13123216949230794 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FILE_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Associate to File',
  p_source=>'begin'||chr(10)||
'  if :P21001_FILE_ASSOC is not null then'||chr(10)||
'     return core_obj.get_tagline(:P21001_FILE_ASSOC);'||chr(10)||
'  else'||chr(10)||
'     return null;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
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
  p_id=>13123424914233094 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FIND_FILE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:openLocator(''301'',''P21001_FILE_ASSOC'',''N'',''&P21001_FILE_ASSOC.'',''OPEN'','''','''',''Choose File...'',''FILE'',''&P21001_OBJ.'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popupLocator(450,''P21400_FILE'',''N'',''&P21400_SID.'');">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13129121610468647 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FILE_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13136201804983340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DOCUMENT_NUMBER_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 450,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13137030941020164 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PAY_CAT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 43,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => ':P21500_pay_cat',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Pay Category',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_PAY_CAT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'-Select Pay Category -',
  p_lov_null_value=> '',
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
  p_id=>13137208215023069 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DUTY_CAT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 44,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Duty Category',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_DUTY_CAT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Duty Category -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'osi_reference.lookup_ref_sid(''DUTY_CATEGORY'',''01'')');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13137414795024936 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_MISSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mission',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_mission_category'||chr(10)||
' where management_area=''Y'''||chr(10)||
'   and active = ''Y'''||chr(10)||
' order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Mission -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13137622760027285 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_WORK_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 46,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char(sysdate,:FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Work Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13137800035030179 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOURS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 47,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hours',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 11,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13138007654032369 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_COMPLETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 48,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Complete Activity Upon Creation?',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:Yes;Y,No;N',
  p_lov_columns=> 2,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 9,
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
  p_id=>13139000559068145 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PAY_CAT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 520,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13139206446069880 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DUTY_CAT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 530,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13208828270970263 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 540,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13539907543081798 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_1_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PRECISION_DATE_1_LABEL.',
  p_post_element_text=>'<a href=javascript:precisionDate(''P21001_PRECISION_DATE_1'');>&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p21001_precision_date_1,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_PRECISION_DATE_1_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13540120356085460 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 560,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13543625204437002 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_2_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PRECISION_DATE_2_LABEL.',
  p_post_element_text=>'<a href="javascript:precisionDate(''P21001_PRECISION_DATE_2'');">&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p21001_precision_date_2,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_PRECISION_DATE_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13543801786439750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 580,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13544031007457621 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_3_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PRECISION_DATE_3_LABEL.',
  p_post_element_text=>'<a href="javascript:precisionDate(''P21001_PRECISION_DATE_3'');">&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p21001_precision_date_3,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_PRECISION_DATE_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13544203434459089 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 600,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13544806120478809 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_1_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 610,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13545011314480340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 620,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13545216509481823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 630,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>13684915705757129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_SUBSTANTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 640,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Substantive Investigative Activity?',
  p_source_type=> 'STATIC',
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
  p_id=>15306101746490240 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_IMAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 650,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>15334031683535378 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HIDESHOW_PARTIC_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 22.5,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a id="hideShowPartic" title="Hide/Show Participant Details" href="javascript:hideShowParticipantDetails();"><img id="showHideParticipantIcon" alt="Hide/Show Participant Details" src="#IMAGE_PREFIX#themes/OSI/minus.gif"></a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTICIPANT_VERSION IS NOT NULL AND'||chr(10)||
':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>15335307329670250 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HIDEPARTICDETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 660,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
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
  p_begin_on_new_field=> 'YES',
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
  p_id=> 12908617199371186 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_computation_sequence => 10,
  p_computation_item=> 'P21001_RESTRICTION_LOV',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_reference.get_lov(''RESTRICTION'')',
  p_compute_when => 'P21001_RESTRICTION_LOV',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 12908817816371189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_computation_sequence => 10,
  p_computation_item=> 'P21001_PARTICIPANT_VERSION',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'begin'||chr(10)||
'     if :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' then'||chr(10)||
''||chr(10)||
'       return :P21001_PARTICIPANT;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       return osi_participant.get_current_version(:P21001_PARTICIPANT);'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'end;',
  p_compute_when => 'P21001_PARTICIPANT',
  p_compute_when_type=>'REQUEST_EQUALS_CONDITION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12909019645371190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_TITLE Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P21001_TITLE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Title must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12905904281371182 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12909230128371190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_ACTIVITY_DATE not null',
  p_validation_sequence=> 2,
  p_validation => 'P21001_ACTIVITY_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_ACTIVITY_DATE_LABEL. must be specified.',
  p_validation_condition=> '(:REQUEST IN (''CREATE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE NOT IN (''ACT.COMP_INTRUSION''))'||chr(10)||
'OR (:REQUEST IN (''ADD'') AND :P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK''));',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12907108080371184 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12909422327371190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Activity Date',
  p_validation_sequence=> 3,
  p_validation => 'p21001_activity_date',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''CREATE'') and :p21001_activity_date is not null'||chr(10)||
'OR'||chr(10)||
'(:REQUEST IN (''ADD'') AND :P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK'') '||chr(10)||
'                     AND :p21001_activity_date is not null);',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12907108080371184 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12915600941813735 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_LIST_1 Not Null',
  p_validation_sequence=> 14,
  p_validation => 'P21001_LIST_1',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_LIST_1_LABEL. must be specified.',
  p_validation_condition=> '(:REQUEST IN (''CREATE'') AND'||chr(10)||
'(:P21001_OBJ_TYPE_CODE IN (''ACT.SEARCH'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.DDD_TRIAGE'','||chr(10)||
'                          ''ACT.POLY_EXAM'','||chr(10)||
'                          ''ACT.SURVEILLANCE'','||chr(10)||
'                          ''ACT.SUSPACT_REPORT'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION'')))'||chr(10)||
'OR'||chr(10)||
':REQUEST IN (''ADD'') AND :P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12939917037248840 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_LIST_2 Not Null',
  p_validation_sequence=> 24,
  p_validation => 'P21001_LIST_2',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_LIST_2_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
'(:P21001_OBJ_TYPE_CODE IN (''ACT.SEARCH'',''ACT.LIAISON'',''ACT.SURVEILLANCE'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION''));',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12941001725339038 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Participant Version Not Null',
  p_validation_sequence=> 34,
  p_validation => 'P21001_PARTICIPANT_VERSION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_PARTIC_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.INIT_NOTIF'','||chr(10)||
'                          ''ACT.SOURCE_MEET'','||chr(10)||
'                          ''ACT.FINGERPRINT.MANUAL'','||chr(10)||
'                          ''ACT.POLY_EXAM'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12908121248371184 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12972503734678449 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Date 2 Not Null',
  p_validation_sequence=> 44,
  p_validation => 'P21001_DATE_2',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_DATE_2_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12963606682366990 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12973021526693015 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 2',
  p_validation_sequence=> 54,
  p_validation => 'p21001_date_2',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_2 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12963606682366990 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12973615770700865 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 3',
  p_validation_sequence=> 64,
  p_validation => 'p21001_date_3',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_3 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12963816725369957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12973925813703729 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 4',
  p_validation_sequence=> 74,
  p_validation => 'p21001_date_4',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_4 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12968228303534167 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12974204473707071 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 5',
  p_validation_sequence=> 84,
  p_validation => 'p21001_date_5',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_5 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12968404885536819 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12974619149720689 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 2 Must be a Number',
  p_validation_sequence=> 94,
  p_validation => 'length(translate(trim(:P21001_TEXT_2),'' +-.0123456789'','' '')) = 0'||chr(10)||
'OR'||chr(10)||
'length(translate(trim(:P21001_TEXT_2),'' +-.0123456789'','' '')) is null',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_TEXT_2_LABEL. must be a NUMBER.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12970905418650523 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12974806598736068 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 3 Must be a Number',
  p_validation_sequence=> 104,
  p_validation => 'length(translate(trim(:P21001_TEXT_3),'' +-.0123456789'','' '')) = 0'||chr(10)||
'OR'||chr(10)||
'length(translate(trim(:P21001_TEXT_3),'' +-.0123456789'','' '')) is null',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_TEXT_3_LABEL. must be a NUMBER.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12971114076653026 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12977028471846403 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 2 Must be a Number > 0',
  p_validation_sequence=> 114,
  p_validation => 'declare'||chr(10)||
'       test number;'||chr(10)||
'begin'||chr(10)||
'     if :P21001_TEXT_2 is null then'||chr(10)||
'       '||chr(10)||
'       return true;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       test := to_number(:P21001_TEXT_2);'||chr(10)||
'       if test>0 then'||chr(10)||
'  '||chr(10)||
'         return true;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return false;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
''||chr(10)||
'  when OTHERS then '||chr(10)||
''||chr(10)||
'      return false;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => '&P21001_TEXT_2_LABEL. must be greater than 0.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12970905418650523 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12977425616864530 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 3 Must be a Number >=1',
  p_validation_sequence=> 124,
  p_validation => 'declare'||chr(10)||
'       test number;'||chr(10)||
'begin'||chr(10)||
'     if :P21001_TEXT_3 is null then'||chr(10)||
'       '||chr(10)||
'       return true;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       test := to_number(:P21001_TEXT_3);'||chr(10)||
'       if test>=1 then'||chr(10)||
'  '||chr(10)||
'         return true;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return false;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
''||chr(10)||
'  when OTHERS then '||chr(10)||
''||chr(10)||
'      return false;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => '&P21001_TEXT_3_LABEL. must be greater than or equal to 1.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND '||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12971114076653026 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13057821515017741 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 6 not NULL',
  p_validation_sequence=> 134,
  p_validation => 'P21001_TEXT_6',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_TEXT_6_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND '||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SEARCH'' AND'||chr(10)||
':P21001_TEXT_6_LABEL IS NOT NULL;',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13057013981996676 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13066803104958575 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Radio Group 1 is not null',
  p_validation_sequence=> 144,
  p_validation => ':P21001_RADIOGROUP_1 IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':P21001_RADIOGROUP_1 NOT IN (''U'')',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_RADIOGROUP_1_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.SURVEILLANCE'',''ACT.SUSPACT_REPORT'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12980308151048742 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13070229618573464 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Radio Group 2 is not null',
  p_validation_sequence=> 154,
  p_validation => ':P21001_RADIOGROUP_2 IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':P21001_RADIOGROUP_2 NOT IN (''U'')',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_RADIOGROUP_2_LABEL. is missing.'||chr(10)||
'',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13063726868605943 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13070617629579425 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Radio Group 3 is not null',
  p_validation_sequence=> 164,
  p_validation => ':P21001_RADIOGROUP_3 IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':P21001_RADIOGROUP_3 NOT IN (''U'')',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_RADIOGROUP_3_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13068420296447757 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13085728307528725 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 9 not null',
  p_validation_sequence=> 174,
  p_validation => 'P21001_TEXT_9',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_TEXT_9_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13077312929439106 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13085919780535712 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 9 must be numeric',
  p_validation_sequence=> 184,
  p_validation => 'P21001_TEXT_9',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => '&P21001_TEXT_9_LABEL. must be numeric.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13077312929439106 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13192623011438819 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Work Hours > 0',
  p_validation_sequence=> 194,
  p_validation => 'begin'||chr(10)||
'     if to_number(:P21001_HOURS) <= 0 then'||chr(10)||
'       '||chr(10)||
'       return false;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     '||chr(10)||
'     return true;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
'         return false;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Workhours must be > 0.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13137800035030179 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13192812191454619 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Work Date not in the Future',
  p_validation_sequence=> 204,
  p_validation => 'declare'||chr(10)||
'  v_date date;'||chr(10)||
'begin'||chr(10)||
' v_date := :p21001_work_date;'||chr(10)||
' if v_date > trunc(sysdate+1) then'||chr(10)||
'   return false;'||chr(10)||
' else'||chr(10)||
'   return true;'||chr(10)||
' end if;'||chr(10)||
'exception when others then'||chr(10)||
'  return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Work Date cannot be in the future.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13137622760027285 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13551505090554190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_PRECISION_DATE_1 not null',
  p_validation_sequence=> 214,
  p_validation => 'P21001_PRECISION_DATE_1',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_PRECISION_DATE_1_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.COMP_INTRUSION'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13539907543081798 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13565802336822929 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Address NOT NULL',
  p_validation_sequence=> 224,
  p_validation => 'P21001_ADDRESS_VALUE',
  p_validation_type => 'ITEM_NOT_NULL_OR_ZERO',
  p_error_message => '&P21001_ADDRESS_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.SURVEILLANCE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13103128531526299 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 15339022715185622 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'No LERC or DR Currently in the List',
  p_validation_sequence=> 234,
  p_validation => 'declare'||chr(10)||
''||chr(10)||
'       v_cnt number;'||chr(10)||
'begin'||chr(10)||
'     select count(*) into v_cnt'||chr(10)||
'       from t_osi_a_rc_dr_multi_temp'||chr(10)||
'        where personnel=:USER_SID '||chr(10)||
'          and obj_type_code=:P21001_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
''||chr(10)||
'    if v_cnt = 0 then'||chr(10)||
'      '||chr(10)||
'      return false;'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
''||chr(10)||
'      return true;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Please add a &P21001_OBJ_TYPE_DESCRIPTION. to the list before clicking Save.',
  p_validation_condition=> ':REQUEST IN (''CREATE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'       v_FieldNames       clob := NULL;'||chr(10)||
'       v_FieldValues      clob := NULL;'||chr(10)||
'       v_ActivityDate     date;'||chr(10)||
'       v_TableName        varchar2(100) := NULL;'||chr(10)||
'       v_ParticipantUsage varchar2(100) := NULL;'||chr(10)||
'       v_ParticipantCode  varchar2(100) := NULL;'||chr(10)||
'       v_AddressUsage     varchar2(100) := NULL;'||chr(10)||
'       v_AddressCode      varchar2(100) := NULL;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'CASE '||chr(10)||
'    WHEN :P21001_OBJ';

p:=p||'_TYPE_CODE IN (''ACT.CC_REVIEW'',''ACT.CHECKLIST'',''ACT.KFAT'',''ACT.OC_REVIEW'') THEN'||chr(10)||
'                                         '||chr(10)||
'        v_TableName := ''t_osi_a_clist'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, :FMT_DATE);'||chr(10)||
'        v_FieldNames := ''sid,checklist_type'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || osi_clist.get_checklist_type(:p21001_obj_type_sid';

p:=p||') || '''''''';'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.AAPP'',''ACT.AAPP.DOCUMENT_REVIEW'',''ACT.AAPP.EDUCATION'',''ACT.AAPP.EMPLOYMENT'',''ACT.AAPP.INTERVIEW'',''ACT.AAPP.RECORDS_CHECK'') THEN'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_aapp_activity'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date,:fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.AV_SUPPORT'' THEN'||chr(10)||
'        '||chr(10)||
'        v_FieldNames';

p:=p||' := ''SID,AV_TYPE,DATE_REQUEST_BY,DATE_COMPLETED'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || :p21001_date_2 || '''''''' || '','' || '''''''' || :p21001_date_3 || '''''''';'||chr(10)||
'        v_ParticipantUsage := ''REQUESTOR'';'||chr(10)||
'        v_ParticipantCode := ''REQUESTOR'';'||chr(10)||
'        v_TableName := ''t_osi_a_avsupport'';'||chr(10)||
'        v_Activi';

p:=p||'tyDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.BRIEFING'' THEN'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_briefing'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date || '' '' || nvl(:p21001_hour, ''00'') || '':'' || nvl(:p21001_minute, ''00''),''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.COMP_INTRUSION'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,intrusion';

p:=p||'_from_date,intrusion_to_date,cci_notified,cci_comment,request_for_information,intrusion_impact,contact_method,afcert_category,afcert_incident_num'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 to_date(:p21001_precision_date_2, ''yyyymmddhh24miss'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 to_date(:p21001_precision_date';

p:=p||'_3, ''yyyymmddhh24miss'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_explanation,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_radiogroup_2 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '',';

p:=p||''' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_3,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_text_8,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_comp_intrusion'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_precision_date_1';

p:=p||', ''yyyymmddhh24miss'');'||chr(10)||
'    '||chr(10)||
'    WHEN substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.CONSULTATION'' OR substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.COORDINATION'' THEN'||chr(10)||
''||chr(10)||
'        :p21001_obj_type_sid := :p21001_list_1;'||chr(10)||
'        v_FieldNames := ''sid,cc_method'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_2,''%null%'',''null'') || '''''''';'||chr(10)||
'        v_TableName := ''t_osi_a_co';

p:=p||'nsult_coord'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW'' THEN'||chr(10)||
''||chr(10)||
'        :P0_OBJ := osi_document_review.create_instance(''&USER_SID.'');'||chr(10)||
'        return;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'        '||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_Table';

p:=p||'Name := ''t_osi_a_fingerprint'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.INIT_NOTIF'' THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''PARTICIPANT'';'||chr(10)||
'        v_ParticipantCode := ''NOTIFIED'';'||chr(10)||
'        v_TableName := ''t_osi_a_init_notification'';'||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.INTERVIEW.GROUP'' ';

p:=p||'THEN'||chr(10)||
''||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.INTERVIEW.SUBJECT'',''ACT.INTERVIEW.VICTIM'',''ACT.INTERVIEW.WITNESS'') THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''PERSON'';'||chr(10)||
'        v_TableName := ''t_osi_a_interview'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date || '' '' || nvl(:p21001_hour, ''00'') || '':'' || nvl(:p2';

p:=p||'1001_minute, ''00''), :fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.LIAISON'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,liaison_type,liaison_level'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_Tabl';

p:=p||'eName := ''t_osi_a_liaison'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-MON-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'') THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,media_type,media_size,media_size_units,removable_flag,quantity,seizure_date,receive_date,analysis_start_date,analysis_end_date,comments,activity'';'||chr(10)||
'        v_FieldValues := ''core_sid';

p:=p||'gen.next_sid'' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_text_2,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || '||chr(10)||
'                         ';

p:=p||'        replace(:p21001_text_3,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_2 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_3 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_4 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_5 || '''''''' || '','' || '''''''' || '||chr(10)||
'                             ';

p:=p||'    replace(:p21001_text_4,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 ''~^~P0_OBJ~^~'' || '''''''';'||chr(10)||
''||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_media_analysis'';'||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.POLY_EXAM'' THEN'||chr(10)||
''||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,location,start_datetime,end_datetime,exam_monitor'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_O';

p:=p||'BJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_5,'''''''','''''''''''') || '''''''' || '','' || '||chr(10)||
'''to_date(to_char(to_date('' || '''''''' || :p21001_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '||chr(10)||
'''to_date(to_char(to_date('' || '''''''' || :p21001';

p:=p||'_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour_2 || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute_2 || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'   ';

p:=p||'     v_TableName := ''t_osi_a_poly_exam'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK'' THEN'||chr(10)||
''||chr(10)||
'        :P0_OBJ := osi_records_check.create_instance(''&USER_SID.'');'||chr(10)||
'        return;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SEARCH'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,search_basis, explanation'';'||chr(10)||
'        v_FieldValues := ''''''';

p:=p||''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_6,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_search'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, :fmt_date || '' '' || :fmt_time)';

p:=p||';'||chr(10)||
''||chr(10)||
'        :P21001_OBJ_TYPE_SID:=:p21001_list_1;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,commodity,contact_method'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_7,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName ';

p:=p||':= ''t_osi_a_source_meet'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || nvl(:p21001_minute,''00'') || ''00'', ''yyyymmddhh24miss'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,EMERGENCY,CONSENSUAL,US_LOCATION,ITEM_CASE,INFO_TYPE,TECHNIQUE,REQUESTED_DURATION'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~';

p:=p||'^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || :p21001_radiogroup_2 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_3 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_4 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') |';

p:=p||'| '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_9,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_surveillance'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || nvl(:p21001_minute,''00'') || ''00'', ''y';

p:=p||'yyymmddhh24miss'');'||chr(10)||
'        v_AddressUsage := ''ADDR_INTRCPT'';'||chr(10)||
'        v_AddressCode := ''ADDR_INTRCPT'';'||chr(10)||
'      '||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,CATEGORY,RESOLVED,REPORT_UNIT'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                               ';

p:=p||'  :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || ''~^~UNIT~^~'' || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_suspact_report'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'   ELSE'||chr(10)||
'       v_ActivityDate := to_date(:p21001_activity_date,''DD-MON-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'END CASE;'||chr(10)||
''||chr(10)||
'     IF :P21001_FILE_ASSOC IS NOT NULL THEN'||chr(10)||
''||chr(10)||
'       :P21001_FROM_OBJ:=:P21001_FILE_ASSOC;'||chr(10)||
' '||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'';

p:=p||'     :P0_OBJ := osi_activity.create_instance(:p21001_obj_type_sid,'||chr(10)||
'                                             v_ActivityDate,'||chr(10)||
'                                             :p21001_title,'||chr(10)||
'                                             :p21001_restriction,'||chr(10)||
'                                             :P21001_narrative,'||chr(10)||
'                                             v_FieldNames,'||chr(10)||
'                       ';

p:=p||'                      v_FieldValues,'||chr(10)||
'                                             :p21001_participant_version,'||chr(10)||
'                                             v_ParticipantUsage,'||chr(10)||
'                                             v_ParticipantCode,'||chr(10)||
'                                             v_TableName,'||chr(10)||
'                                             :p21001_from_obj,'||chr(10)||
'                                       ';

p:=p||'      v_AddressUsage,'||chr(10)||
'                                             v_AddressCode,'||chr(10)||
'                                             :p21001_address_value,'||chr(10)||
'                                             :p21001_parent_objective,'||chr(10)||
'                                             replace(:p21001_pay_cat,''%null%'',''null''),'||chr(10)||
'                                             replace(:p21001_duty_cat,''%null%'',''null''),'||chr(10)||
'    ';

p:=p||'                                         replace(:p21001_mission,''%null%'',''null''),'||chr(10)||
'                                             :p21001_work_date,'||chr(10)||
'                                             :p21001_hours,'||chr(10)||
'                                             :p21001_complete,'||chr(10)||
'                                             :p21001_substantive);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 12935431854997678 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''CREATE'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
'     /* Since all go into one activity now, make sure they all have the same'||chr(10)||
'        values for certain fields like File association etc ....             */'||chr(10)||
'     if :P21001_FILE_ASSOC is null then'||chr(10)||
''||chr(10)||
'       select file_sid into :P21001_FILE_ASSOC '||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'';

p:=p||'     if :P21001_PARTICIPANT is null then'||chr(10)||
''||chr(10)||
'       select subject_of_activity into :P21001_PARTICIPANT '||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_COMPLETE is null then'||chr(10)||
''||chr(10)||
'       select complete into :P21001_COMPLETE'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personne';

p:=p||'l=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_SUBSTANTIVE is null then'||chr(10)||
''||chr(10)||
'       select substantive into :P21001_SUBSTANTIVE'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_RESTRICTION is null then'||chr(10)||
''||chr(10)||
'       select restriction into :P21';

p:=p||'001_RESTRICTION '||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_PAY_CAT is null then'||chr(10)||
''||chr(10)||
'       select wh_pay_cat into :P21001_PAY_CAT'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'    ';

p:=p||' if :P21001_DUTY_CAT is null then'||chr(10)||
''||chr(10)||
'       select wh_duty_cat into :P21001_DUTY_CAT'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     if :P21001_MISSION is null then'||chr(10)||
''||chr(10)||
'       select wh_mission into :P21001_MISSION'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'       ';

p:=p||'      and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     if :P21001_WORK_DATE is null then'||chr(10)||
''||chr(10)||
'       select wh_date into :P21001_WORK_DATE'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     if :P21001_HOURS is null then'||chr(10)||
''||chr(10)||
'       select wh_hours into :P21001_HOURS'||chr(10)||
'          from t_osi_a_rc_dr_';

p:=p||'multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         null;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
''||chr(10)||
'insert into t_osi_a_rc_dr_multi_temp'||chr(10)||
'(activity_date,subject_of_activity,reference_num,restriction,title,narrative,doc_type,results,file_sid,personnel,WH_PAY_CAT,WH_DUTY_CAT,WH_MISSION,WH_DATE,WH_HOURS,COMPLETE,SUBSTANTIVE,OBJ_TYPE_';

p:=p||'CODE,EXPLANATION)'||chr(10)||
'values'||chr(10)||
'(:P21001_ACTIVITY_DATE,'||chr(10)||
' :P21001_PARTICIPANT,'||chr(10)||
' :P21001_DOCUMENT_NUMBER,'||chr(10)||
' :P21001_RESTRICTION,'||chr(10)||
' :P21001_TITLE,'||chr(10)||
' :P21001_NARRATIVE,'||chr(10)||
' REPLACE(:P21001_LIST_1,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_LIST_2,''%null%'',NULL),'||chr(10)||
' :P21001_FILE_ASSOC,'||chr(10)||
' :USER_SID,'||chr(10)||
' REPLACE(:P21001_PAY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_DUTY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_MISSION,''%null%'',NULL),'||chr(10)||
' :P21001';

p:=p||'_WORK_DATE,'||chr(10)||
' :P21001_HOURS,'||chr(10)||
' :P21001_COMPLETE,'||chr(10)||
' :P21001_SUBSTANTIVE,'||chr(10)||
' :P21001_OBJ_TYPE_CODE,'||chr(10)||
' :P21001_EXPLANATION) '||chr(10)||
'returning sid into :P21001_SELECTED;'||chr(10)||
''||chr(10)||
''||chr(10)||
'update t_osi_a_rc_dr_multi_temp '||chr(10)||
'   set subject_of_activity=:p21001_participant,'||chr(10)||
'       file_sid=:p21001_file_assoc,'||chr(10)||
'       complete=:p21001_complete,'||chr(10)||
'       substantive=:p21001_substantive,'||chr(10)||
'       restriction=:p21001_restriction,'||chr(10)||
'       wh_pay_';

p:=p||'cat=:p21001_pay_cat,'||chr(10)||
'       wh_duty_cat=:p21001_duty_cat,'||chr(10)||
'       wh_mission=:p21001_mission,'||chr(10)||
'       wh_date=:p21001_work_date,'||chr(10)||
'       wh_hours=:p21001_hours'||chr(10)||
'     where personnel=:user_sid '||chr(10)||
'       and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'COMMIT;';

wwv_flow_api.create_page_process(
  p_id     => 13193311115501624 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Check/Review To List',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Failed to add check to the list.',
  p_process_when=>':REQUEST IN (''ADD'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
'    for I in 1 .. apex_application.g_f01.count'||chr(10)||
'    loop'||chr(10)||
'        delete from T_OSI_A_RC_DR_MULTI_TEMP'||chr(10)||
'              where sid = apex_application.g_f01(I);'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13193519426504026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Remove Selected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'REMOVE_SELECTED',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'SELECT SID,to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'SUBJECT_OF_ACTIVITY,'||chr(10)||
'REFERENCE_NUM,'||chr(10)||
'RESTRICTION,'||chr(10)||
'TITLE,'||chr(10)||
'NARRATIVE,'||chr(10)||
'DOC_TYPE,'||chr(10)||
'RESULTS,'||chr(10)||
'FILE_SID,'||chr(10)||
'WH_PAY_CAT,'||chr(10)||
'WH_DUTY_CAT,'||chr(10)||
'WH_MISSION,'||chr(10)||
'WH_DATE,'||chr(10)||
'WH_HOURS,'||chr(10)||
'COMPLETE,'||chr(10)||
'SUBSTANTIVE,'||chr(10)||
'EXPLANATION'||chr(10)||
'INTO'||chr(10)||
':P21001_SELECTED,'||chr(10)||
':P21001_ACTIVITY_DATE,'||chr(10)||
':P21001_PARTICIPANT,'||chr(10)||
':P21001_DOCUMENT_NUMBER,'||chr(10)||
':P21001_RESTRICTION,'||chr(10)||
':P21001_TITLE,'||chr(10)||
':P21001_NARRATIVE,'||chr(10)||
'';

p:=p||':P21001_LIST_1,'||chr(10)||
':P21001_LIST_2,'||chr(10)||
':P21001_FILE_ASSOC,'||chr(10)||
':P21001_PAY_CAT,'||chr(10)||
':P21001_DUTY_CAT,'||chr(10)||
':P21001_MISSION,'||chr(10)||
':P21001_WORK_DATE,'||chr(10)||
':P21001_HOURS,'||chr(10)||
':P21001_COMPLETE,'||chr(10)||
':P21001_SUBSTANTIVE,'||chr(10)||
':P21001_EXPLANATION'||chr(10)||
'FROM T_OSI_A_RC_DR_MULTI_TEMP WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'     SELECT OSI_PARTICIPANT.GET_CURRENT_VERSION(:P21001_PARTICIPANT) INTO :P21001_PARTICIPANT_VERSION FROM DUAL;'||chr(10)||
''||chr(10)||
'EXCEPTION WH';

p:=p||'EN OTHERS THEN'||chr(10)||
''||chr(10)||
'         NULL;'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 13193725660505875 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Check/Review in List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''EDIT%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
p:=p||':P21001_PARTIC_WIDGET_VISIBLE:=''N'';'||chr(10)||
':P21001_HOUR_LABEL:=''Time'';'||chr(10)||
''||chr(10)||
':P21001_LIST_1_LOV:=''- Select -;%null%'';'||chr(10)||
':P21001_LIST_2_LOV:=''- Select -;%null%'';'||chr(10)||
':P21001_LIST_3_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'--- Default to exclude all but Individuals ---'||chr(10)||
':P21001_PARTIC_TYPE_EXCLUDES:=''All Participant Types;ALL~Programs;PART.NONINDIV.PROG~Companies;PART.NONINDIV.COMP~Organizations;PART.NONINDIV.ORG'';'||chr(10)||
''||chr(10)||
'select t.descri';

p:=p||'ption,t.sid,ot.default_title,replace(image,''.gif'',''.ico'')'||chr(10)||
'  into :P21001_OBJ_TYPE_DESCRIPTION,:P21001_OBJ_TYPE_SID,:P21001_TITLE,:P0_OBJ_IMAGE'||chr(10)||
'  from t_core_obj_type t,t_osi_obj_type ot'||chr(10)||
' where t.code=:P21001_OBJ_TYPE_CODE'||chr(10)||
'   and ot.sid=t.sid;'||chr(10)||
''||chr(10)||
'IF :P21001_OBJ_TYPE_CODE IN (''ACT.AAPP'',''ACT.AAPP.DOCUMENT_REVIEW'',''ACT.AAPP.EDUCATION'',''ACT.AAPP.EMPLOYMENT'',''ACT.AAPP.INTERVIEW'',''ACT.AAPP.RECORDS_CHECK'')';

p:=p||' THEN'||chr(10)||
'  '||chr(10)||
'  :P21001_RESTRICTION := osi_reference.lookup_ref_sid(''RESTRICTION'', ''UNIT'');'||chr(10)||
'  :P21001_NARRATIVE := osi_aapp_activity.get_pre_can_narrative(:P21001_PARENT_OBJECTIVE);'||chr(10)||
''||chr(10)||
'END IF;'||chr(10)||
''||chr(10)||
'CASE :P21001_OBJ_TYPE_CODE'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.AV_SUPPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Request Received'';'||chr(10)||
'                                       :P21001_LIS';

p:=p||'T_1_LABEL := ''Support Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AV_TYPE'');'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Date Requested By'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Date Completed'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Requestor'';'||chr(10)||
'                   ';

p:=p||'                    :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''';

p:=p||'P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.BRIEFING'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Briefing Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Briefing Time'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.COMP_INTRUSION'' THEN'||chr(10)||
'                                       :P21001_PRECISIO';

p:=p||'N_DATE_1_LABEL:=''CCI Notified Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Impact'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''COMPINT_IMPACT'');'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Contact Method'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || os';

p:=p||'i_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
'                                       :P21001_LIST_3_LABEL := ''AFCERT Category'';'||chr(10)||
'                                       :P21001_LIST_3_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AFCERT_CATEGORY'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''CCI Notified'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Req';

p:=p||'uest For Information'';'||chr(10)||
'                                       :P21001_TEXT_8_LABEL:=''AFCERT Incident Num'';'||chr(10)||
''||chr(10)||
'                                       :P21001_PRECISION_DATE_2_LABEL:=''From'';'||chr(10)||
'                                       :P21001_PRECISION_DATE_3_LABEL:=''To'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''CCI Comment'';'||chr(10)||
''||chr(10)||
'        WHEN ''ACT.DOCUMENT_REVIEW'' THEN'||chr(10)||
'              ';

p:=p||'                         :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''DOCREV_DOCTYPE'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Document Type'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''Explanation'';'||chr(10)||
'                                       :P210';

p:=p||'01_DOCUMENT_NUMBER_LABEL:=''Document Number'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject of Activity'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
''||chr(10)||
'                                       :P21001_EXPLANATION_VISIBLE := osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') || ''~'';'||chr(10)||
''||chr(10)||
'                                       :P21001_LIST_2_LABEL := ';

p:=p||'''Document Review Result'';'||chr(10)||
'                                       '||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select DESCRIPTION d, CODE r from T_OSI_A_RC_DR_RESULTS order by 1)'||chr(10)||
'                                       loop'||chr(10)||
'                                           :P21001_LIST_2_LOV := :P21001_LIST_2_LOV || repla';

p:=p||'ce(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
''||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Ch';

p:=p||'oose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'     WHEN ''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Fingerprints Taken'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FI';

p:=p||'ND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'             WHEN ''ACT.INIT_NOTIF'' THEN'||chr(10)||
'                                   ';

p:=p||'    :P21001_ACTIVITY_DATE_LABEL:=''Notified On'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Notified By'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P2100';

p:=p||'1_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.SUBJECT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                           ';

p:=p||'            :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                  ';

p:=p||'                              ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'       WHEN ''ACT.INTERVIEW.VICTIM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                         ';

p:=p||'              :P21001_PARTIC_LABEL:=''Victim'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_P';

p:=p||'ARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.WITNESS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Witness'';'||chr(10)||
'                              ';

p:=p||'         :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&IC';

p:=p||'ON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                WHEN ''ACT.LIAISON'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Liaison Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Liaison Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON_TYPE'');'||chr(10)||
'                                       :P21001_LIST_2_LABE';

p:=p||'L:=''Liaison Level'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON_LEVEL'');'||chr(10)||
''||chr(10)||
'             WHEN ''ACT.DDD_TRIAGE'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Media Type'';'||chr(10)||
'                                       :P21001_LIST_1_';

p:=p||'LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_2_LABEL:=''Media Size'';'||chr(10)||
'                                       :P21001_TEXT_3_LABEL:=''Quantity'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Size Units'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''M';

p:=p||'EDANLY_UNIT'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Removable?'';'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Seizure Date'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Receive Date'';'||chr(10)||
'                                       :P21001_DATE_4_LABEL:=''Analysis Start Date'';'||chr(10)||
'                                       :P21001_DATE_5_LABEL:=''Anal';

p:=p||'ysis End Date'';'||chr(10)||
'                                       :P21001_TEXT_4_LABEL:=''Comments'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.MEDIA_ANALYSIS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Media Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''ME';

p:=p||'DANLY_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_2_LABEL:=''Media Size'';'||chr(10)||
'                                       :P21001_TEXT_3_LABEL:=''Quantity'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Size Units'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_UNIT'');'||chr(10)||
'                                       ';

p:=p||':P21001_RADIOGROUP_1_LABEL:=''Removable?'';'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Seizure Date'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Receive Date'';'||chr(10)||
'                                       :P21001_DATE_4_LABEL:=''Analysis Start Date'';'||chr(10)||
'                                       :P21001_DATE_5_LABEL:=''Analysis End Date'';'||chr(10)||
'                                      ';

p:=p||' :P21001_TEXT_4_LABEL:=''Comments'';'||chr(10)||
''||chr(10)||
'              WHEN ''ACT.POLY_EXAM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Exam Date'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Examinee Name'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Monitor to Exam'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || os';

p:=p||'i_reference.get_lov(''POLY_MONITOR'');'||chr(10)||
'                                       :P21001_TEXT_5_LABEL:=''Place of Examination'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Start Time'';'||chr(10)||
'                                       :P21001_HOUR_2_LABEL:=''End Time'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGE';

p:=p||'T_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
'  '||chr(10)||
'          WHEN ''ACT.RECORDS_CHECK'' THEN'||chr(10)||
'                                       :P';

p:=p||'21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''LERC_DOCTYPE'');'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject of Activity'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Record Type';

p:=p||''';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Records Check Result'';'||chr(10)||
'                                       '||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select DESCRIPTION d, CODE r from T_OSI_A_RC_DR_RESULTS order by 1)'||chr(10)||
'                                       loop'||chr(10)||
'                            ';

p:=p||'               :P21001_LIST_2_LOV := :P21001_LIST_2_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
''||chr(10)||
'                                       :P21001_DOCUMENT_NUMBER_LABEL:=''Reference Number'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''',''''';

p:=p||''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                 WHEN ''ACT.SEARCH'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Search Date'';'||chr(10)||
'                                       :P21001_PARTIC_L';

p:=p||'ABEL:=''Person Associated with Search'';'||chr(10)||
'                                       :P21001_TEXT_6_LABEL:=''Explanation'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Search Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (sele';

p:=p||'ct description d, sid r  '||chr(10)||
'                                                       from t_core_obj_type '||chr(10)||
'                                                         where code like substr(''ACT.SEARCH'', 1, 10) || ''%'' '||chr(10)||
'                                                           and description <> ''Search'' order by description)'||chr(10)||
'                                       loop'||chr(10)||
'                                   ';

p:=p||'        :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r|| '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
'                                       :P21001_LIST_1_LOV := rtrim(:P21001_LIST_1_LOV, '','');'||chr(10)||
'  '||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Search Based Upon'';'||chr(10)||
'                                       :P21001_LIST_2_LOV := ''- Select ';

p:=p||'-;%null%,'' || osi_reference.get_lov(''SEARCH_BASIS'');'||chr(10)||
'  '||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''',';

p:=p||''''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'            WHEN ''ACT.SOURCE_MEET'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Meet Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Interview Type'';'||chr(10)||
'                                       :P2';

p:=p||'1001_TEXT_7_LABEL := ''Commodity'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Source'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN''''';

p:=p||','''''' ||'||chr(10)||
'                                                                '''''','''''''',''''Choose Source Number...'''',''''SOURCE'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'           WHEN ''ACT.SURVEILLANCE'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested Start Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CA';

p:=p||'TEGORY'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Surveillance Information Type'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Surveillance Technique'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''US Location'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Emergency'';'||chr(10)||
'                                       :P21';

p:=p||'001_RADIOGROUP_3_LABEL:=''Consensual'';'||chr(10)||
'                                       :P21001_RADIOGROUP_4_LABEL:=''ITEM Case'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SURV_INFO_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_9_LABEL := ''Requested Duration'';'||chr(10)||
'                                       :P21001_TEXT_9_SUFFIX := ''  days';

p:=p||''';'||chr(10)||
'                                       :P21001_ADDRESS_LABEL := ''Address of Intercept'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested Start Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CATEGORY'');'||chr(10)||
'                                       :P21001_L';

p:=p||'IST_1_LABEL := ''Category of Suspicious Activity'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Resolved'';'||chr(10)||
''||chr(10)||
'                                   ELSE'||chr(10)||
'                                       if (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.CONSULTATION'') then'||chr(10)||
''||chr(10)||
'                                         :P21001_ACTIVITY_DATE_LABEL:=''Consultation Date'';'||chr(10)||
'                                   ';

p:=p||'      :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                         :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                                         for a in (select d,r '||chr(10)||
'                                                         from V_OSI_CONSULT_CREATE_TYPES order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P2';

p:=p||'1001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                                         begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type where code =''ACT.CONSULTATION.ACQUISITION'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
'         '||chr(10)||
'            ';

p:=p||'                                      null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       elsif (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.COORDINATION'') then'||chr(10)||
''||chr(10)||
' ';

p:=p||'                                           :P21001_ACTIVITY_DATE_LABEL:=''Coordination Date'';'||chr(10)||
'                                            :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                            :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                                         for a in (select d,r '||chr(10)||
'                                                         from V_OSI_COORDIN_CREATE_';

p:=p||'TYPES order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                                         begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type w';

p:=p||'here code =''ACT.COORDINATION.FORENSICS'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
''||chr(10)||
'                                                  null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONT';

p:=p||'ACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       else'||chr(10)||
'                                         '||chr(10)||
'                                         if (:P21001_OBJ_TYPE_CODE IN (''ACT.CC_REVIEW'',''ACT.CHECKLIST'',''ACT.KFAT'',''ACT.OC_REVIEW'')) then'||chr(10)||
'                                         '||chr(10)||
'  '||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
''||chr(10)||
'                             ';

p:=p||'            else'||chr(10)||
''||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                           :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
''||chr(10)||
'                                         end if;'||chr(10)||
''||chr(10)||
'                                       end if;'||chr(10)||
''||chr(10)||
' '||chr(10)||
'END CASE;'||chr(10)||
''||chr(10)||
'if :P21001_LIST_1_LOV = '''' then'||chr(10)||
''||chr(10)||
'  :P21001_LIST_1_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_LIST_2_L';

p:=p||'OV = '''' then'||chr(10)||
''||chr(10)||
'  :P21001_LIST_2_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_LIST_3_LOV = '''' then'||chr(10)||
''||chr(10)||
'  :P21001_LIST_3_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_duty_cat_lov is null then'||chr(10)||
'  '||chr(10)||
'  :P21001_pay_cat_lov := osi_reference.get_lov(''PERSONNEL_PAY_CATEGORY'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_duty_cat_lov is null then'||chr(10)||
''||chr(10)||
'  :P21001_duty_cat_lov := osi_reference.get_lov(''DUTY_CATEGORY'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P2100';

p:=p||'1_activity_date is null then'||chr(10)||
''||chr(10)||
'  select to_char(sysdate,''&FMT_DATE.'') into :P21001_activity_date from dual;'||chr(10)||
''||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 12909702564371193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST NOT IN (''P21001_PARTICIPANT'',''ADDRESS'');',
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
-- ...updatable report columns for page 21001
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
--   Date and Time:   14:07 Wednesday August 1, 2012
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

PROMPT ...Remove page 21505
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>21505);
 
end;
/

 
--application/pages/page_21505
prompt  ...PAGE 21505: Records Check and Document Review Details
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'"JS_BUILDRC_DRNARRATIVEANDTITLE"'||chr(10)||
'"JS_HIDESHOWFIELD"'||chr(10)||
'<script language="javascript">'||chr(10)||
'function showHideFields()'||chr(10)||
'{'||chr(10)||
' pObjTypeCode = $(''#P21505_OBJ_TYPE_CODE'').val();'||chr(10)||
' pDocTypeText = $(''#P21505_TYPE > option:selected'').text();'||chr(10)||
''||chr(10)||
' showField(''P21505_REFERENCE_NUM'', false, false);'||chr(10)||
' hideField(''P21505_EXPLANATION'', false, true);'||chr(10)||
''||chr(10)||
' if(pObjTypeCode==''ACT.DOCUMENT_REVIEW'')'||chr(10)||
'   {'||chr(10)||
'    if(pDocTypeText==''Other'')'||chr(10)||
'    ';

ph:=ph||'  {'||chr(10)||
'       showField(''P21505_EXPLANATION'', false, true);'||chr(10)||
'       hideField(''P21505_REFERENCE_NUM'', false, false);'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 21505,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Records Check and Document Review Details',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="javascript">'||chr(10)||
'$(document).ready(function () '||chr(10)||
'{'||chr(10)||
' showHideFields();'||chr(10)||
'});'||chr(10)||
''||chr(10)||
''||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120727130938',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-OCT-2010 J.FARIS WCHG0000360 - Enabled date picker.'||chr(10)||
''||chr(10)||
'24-Jul-2012 - Tim Ward - CR#4049 - Allow multiple Checks in one Activity.');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21505,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21505,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Review Date",'||chr(10)||
'       REFERENCE_NUM as "Reference Number",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Record Type",'||chr(10)||
'       decode(:p21505_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_RECORDS_CHECK'||chr(10)||
'WHERE OBJ=:P21505_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_name=> 'Law Enforcement Records Checks Associated to this Activity',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 40,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21505_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> '<b><center>***** No &P21505_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14971617016394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14972424256394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 2,
  p_column_heading=> '<input type="Checkbox" onclick="$f_CheckFirstColumn(this)">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 14973029895405378 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Review Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 14973310287409203 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Reference Number',
  p_column_display_sequence=> 5,
  p_column_heading=> '&P21505_NUMBER_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 14971910336394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Narrative',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 14972317792394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Record Type',
  p_column_display_sequence=> 4,
  p_column_heading=> '&P21505_TYPE_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 14972532547394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Review Date",'||chr(10)||
'       DOCUMENT_NUMBER as "Document Number",'||chr(10)||
'       EXPLANATION as "Explanation",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Document Type",'||chr(10)||
'       decode(:p21505_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_DOCUMENT_REVIEW'||chr(10)||
'WHERE OBJ=:P21505_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_name=> 'Document Reviews Associated to this Activity',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 30,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> '<b><center>***** No &P21505_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15158527104591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15158612089591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 2,
  p_column_heading=> '<input type="Checkbox" onclick="$f_CheckFirstColumn(this)">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15158724174591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Review Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15159914337609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Document Number',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Document Number',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15160022347609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Explanation',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Explanation',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15158907025591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Narrative',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15160132539609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Document Type',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Document Type',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
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
  p_id=> 15159128236591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 15255719924339446 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 92093732891224301 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_plug_name=> '&P21505_OBJ_TYPE_DESCRIPTION. Details',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 50,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P21505_SELECTED IS NOT NULL'||chr(10)||
'OR'||chr(10)||
':REQUEST IN (''ADDNEW'')',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 14993025346725866 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 50,
  p_button_plug_id => 14971424570394387+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADDNEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add New',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15112517566305156 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 70,
  p_button_plug_id => 14971424570394387+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15167023950630994 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 80,
  p_button_plug_id => 15158319616591900+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADDNEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add New',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15167227066631877 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 90,
  p_button_plug_id => 15158319616591900+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 92094015476224306 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 30,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21505_SELECTED IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':REQUEST NOT IN (''ADDNEW'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15104005820178675 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 60,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'ADDNEW',
  p_button_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 92094338215224307 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 10,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:21505:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>92557208179630251 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 5,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST LIKE ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-JUN-2009 14:16 by MARK');
 
wwv_flow_api.create_page_branch(
  p_id=>92094926113224317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_branch_action=> 'f?p=&APP_ID.:21505:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P21505_OBJ.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14974716399477216 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>14975028650490262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative Text:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 0,
  p_cMaxlength=> 30000,
  p_cHeight=> 15,
  p_cAttributes=> 'style="width:100%"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%" style="height:auto" style="rows:30"',
  p_tag_attributes2=> 'style="width:100%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>14975614368504983 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
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
  p_id=>14992017802629046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21505_RESULT_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21505_RESULT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:buildRC_DRNarrativeandTitle(''P21505_TYPE'',''P21505_RESULT'',''P21505_NARRATIVE'','''',''P21505_OBJ_TYPE_CODE''); showHideFields();"',
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
  p_id=>14992231655633045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>14992503520643836 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>15060718222934705 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>15060925148936716 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>15111311501265521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>15146103902227797 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>15147331653264200 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ_TYPE_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>15149211015343399 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_NUMBER_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>15149720936412471 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_EXPLANATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Explanation',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 1000,
  p_cHeight=> 10,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') = :P21505_TYPE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16853427690736732 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Review Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
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
  p_id=>92095130765224317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
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
  p_id=>92095321905224326 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_REFERENCE_NUM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21505_NUMBER_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 100,
  p_cHeight=> 1,
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
  p_id=>92559636884685906 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Record Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21505_TYPE_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 200,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onchange="javascript:buildRC_DRNarrativeandTitle(''P21505_TYPE'',''P21505_RESULT'',''P21505_NARRATIVE'','''',''P21505_OBJ_TYPE_CODE''); showHideFields();"',
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

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 16854312368751275 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'P21505_ACTIVITY_DATE',
  p_validation_sequence=> 1,
  p_validation => 'P21505_ACTIVITY_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Review Date must be specified.',
  p_when_button_pressed=> 92094015476224306 + wwv_flow_api.g_id_offset,
  p_associated_item=> 16853427690736732 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 16854606958759159 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'Valid Date',
  p_validation_sequence=> 5,
  p_validation => 'P21505_ACTIVITY_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Date is invalid.',
  p_validation_condition=> ':p21505_activity_date is not null and :request = ''SAVE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 16853427690736732 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 92594608534406278 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'Document Type not null',
  p_validation_sequence=> 10,
  p_validation => 'P21505_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'A Record Type must be selected from the list.',
  p_when_button_pressed=> 92094015476224306 + wwv_flow_api.g_id_offset,
  p_associated_item=> 92559636884685906 + wwv_flow_api.g_id_offset,
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
p:=p||':P21505_SELECTED:=NULL;'||chr(10)||
':P21505_NARRATIVE:=NULL;'||chr(10)||
':P21505_TYPE:=NULL;'||chr(10)||
':P21505_RESULT:=NULL;'||chr(10)||
':P21505_REFERENCE_NUM:=NULL;'||chr(10)||
':P21505_EXPLANATION:=NULL;';

wwv_flow_api.create_page_process(
  p_id     => 15096317201153588 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'ClearSelected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'ADDNEW',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
'     if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'       begin'||chr(10)||
'           for I in 1 .. apex_application.g_f01.count'||chr(10)||
'           loop'||chr(10)||
'               delete from T_OSI_A_RECORDS_CHECK'||chr(10)||
'                     where sid = apex_application.g_f01(I);'||chr(10)||
''||chr(10)||
'               if (apex_application.g_f01(I) = :P21505_SELECTED) then'||chr(10)||
''||chr(10)||
'                 :P21505_SELECTED:=NULL;'||chr(10)||
''||chr(10)||
'               end if;'||chr(10)||
''||chr(10)||
'        ';

p:=p||'   end loop;'||chr(10)||
''||chr(10)||
'       end;'||chr(10)||
''||chr(10)||
'     elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'          begin'||chr(10)||
'              for I in 1 .. apex_application.g_f01.count'||chr(10)||
'              loop'||chr(10)||
'                  delete from T_OSI_A_DOCUMENT_REVIEW'||chr(10)||
'                        where sid = apex_application.g_f01(I);'||chr(10)||
''||chr(10)||
'                  if (apex_application.g_f01(I) = :P21505_SELECTED) then'||chr(10)||
''||chr(10)||
'                    :P21505_';

p:=p||'SELECTED:=NULL;'||chr(10)||
''||chr(10)||
'                  end if;'||chr(10)||
''||chr(10)||
'              end loop;'||chr(10)||
''||chr(10)||
'          end;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     commit;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14973915743429703 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Remove Selected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>15112517566305156 + wwv_flow_api.g_id_offset,
  p_process_when=>'REMOVE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     insert into t_osi_a_records_check (activity_date,reference_num,narrative,doc_type,results,obj) values'||chr(10)||
'           (:P21505_ACTIVITY_DATE,'||chr(10)||
'           :P21505_REFERENCE_NUM,'||chr(10)||
'           :P21505_NARRATIVE,'||chr(10)||
'           REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'           REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'           :P21505_OBJ) '||chr(10)||
'     re';

p:=p||'turning sid into :P21505_SELECTED;'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'         insert into t_osi_a_document_review (activity_date,document_number,narrative,doc_type,results,obj,explanation) values'||chr(10)||
'               (:P21505_ACTIVITY_DATE,'||chr(10)||
'               :P21505_REFERENCE_NUM,'||chr(10)||
'               :P21505_NARRATIVE,'||chr(10)||
'               REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'               ';

p:=p||'REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'               :P21505_OBJ,'||chr(10)||
'               :P21505_EXPLANATION) '||chr(10)||
'        returning sid into :P21505_SELECTED;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   commit;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14974121284431269 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Check To List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>15104005820178675 + wwv_flow_api.g_id_offset,
  p_process_when=>':REQUEST IN (''ADD'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     update t_osi_a_records_check set'||chr(10)||
'           reference_num=:p21505_reference_num,'||chr(10)||
'           doc_type=:p21505_type,'||chr(10)||
'           narrative=:p21505_narrative,'||chr(10)||
'           activity_date=:p21505_activity_date,'||chr(10)||
'           results=:p21505_result'||chr(10)||
'      where SID=:p21505_selected;'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'';

p:=p||'        update t_osi_a_document_review set'||chr(10)||
'              document_number=:p21505_reference_num,'||chr(10)||
'              doc_type=:p21505_type,'||chr(10)||
'              narrative=:p21505_narrative,'||chr(10)||
'              activity_date=:p21505_activity_date,'||chr(10)||
'              results=:p21505_result,'||chr(10)||
'              explanation=:p21505_explanation'||chr(10)||
'         where SID=:p21505_selected;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   commit;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 16853728167746410 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>92094015476224306 + wwv_flow_api.g_id_offset,
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     SELECT SID,'||chr(10)||
'            to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'            REFERENCE_NUM,'||chr(10)||
'            NARRATIVE,'||chr(10)||
'            DOC_TYPE,'||chr(10)||
'            RESULTS'||chr(10)||
'        INTO'||chr(10)||
'            :P21505_SELECTED,'||chr(10)||
'            :P21505_ACTIVITY_DATE,'||chr(10)||
'            :P21505_REFERENCE_NUM,'||chr(10)||
'            :P21505_NARRATIVE,'||chr(10)||
'            :P21';

p:=p||'505_TYPE,'||chr(10)||
'            :P21505_RESULT'||chr(10)||
'        FROM T_OSI_A_RECORDS_CHECK WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'        SELECT SID,'||chr(10)||
'               to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'               DOCUMENT_NUMBER,'||chr(10)||
'               NARRATIVE,'||chr(10)||
'               DOC_TYPE,'||chr(10)||
'               RESULTS,'||chr(10)||
'               EXPLANATION'||chr(10)||
'    ';

p:=p||'       INTO'||chr(10)||
'               :P21505_SELECTED,'||chr(10)||
'               :P21505_ACTIVITY_DATE,'||chr(10)||
'               :P21505_REFERENCE_NUM,'||chr(10)||
'               :P21505_NARRATIVE,'||chr(10)||
'               :P21505_TYPE,'||chr(10)||
'               :P21505_RESULT,'||chr(10)||
'               :P21505_EXPLANATION'||chr(10)||
'           FROM T_OSI_A_DOCUMENT_REVIEW WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14973710549428221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Check in List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''EDIT%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
'  :P21505_obj := :p0_obj;'||chr(10)||
'  :P21505_OBJ_TYPE_CODE := :P0_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
'  select t.description into :P21505_OBJ_TYPE_DESCRIPTION  '||chr(10)||
'    from t_core_obj_type t where t.code=:P21505_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
'  IF (:P21505_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK'') THEN'||chr(10)||
''||chr(10)||
'    :P21505_TYPE_LABEL := ''Records Check Type'';'||chr(10)||
'    :P21505_TYPE_LOV := ''- Select Record Type -;%null%,'' || osi_reference.get_lov(''LERC_DOCTYPE';

p:=p||''');'||chr(10)||
'    :P21505_RESULT_LABEL := ''Records Check Result'';'||chr(10)||
'    :P21505_NUMBER_LABEL := ''Reference Number'';'||chr(10)||
''||chr(10)||
'  ELSIF (:P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW'') THEN'||chr(10)||
''||chr(10)||
'       :P21505_TYPE_LABEL := ''Document Type'';'||chr(10)||
'       :P21505_TYPE_LOV := ''- Select Document Type -;%null%,'' || osi_reference.get_lov(''DOCREV_DOCTYPE'');'||chr(10)||
'       :P21505_RESULT_LABEL := ''Document Review Result'';'||chr(10)||
'       :P21505_NUMBER_LABE';

p:=p||'L := ''Document Number'';'||chr(10)||
''||chr(10)||
'  END IF;'||chr(10)||
''||chr(10)||
'  if :P21505_RESULT is null then'||chr(10)||
''||chr(10)||
'    :P21505_RESULT_LOV:=''- Select -;%null%,'';'||chr(10)||
'    for a in (select DESCRIPTION d, CODE r from T_OSI_A_RC_DR_RESULTS order by 1)'||chr(10)||
'    loop'||chr(10)||
'        :P21505_RESULT_LOV := :P21505_RESULT_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 92558037877657803 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'p21505_obj',
  p_process_when_type=>'ITEM_IS_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 21505
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
--   Date and Time:   14:06 Wednesday August 1, 2012
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

PROMPT ...Remove page 5150
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5150);
 
end;
/

 
--application/pages/page_05150
prompt  ...PAGE 5150: Narrative
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_SEND_REQUEST"'||chr(10)||
'"STYLE_FORMLAYOUT_100%"';

wwv_flow_api.create_page(
  p_id     => 5150,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Narrative',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onload="resizeIt(''''); first_field();"',
  p_step_sub_title => 'Narrative',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript" language="javascript">'||chr(10)||
'function resizeIt(ta) '||chr(10)||
'{'||chr(10)||
' var ta = document.getElementById(''P5150_NARRATIVE'');'||chr(10)||
''||chr(10)||
' while(ta.clientHeight<ta.scrollHeight)'||chr(10)||
'      ta.rows = ta.rows+2;'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215462100554475+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120730105227',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '12-Aug-2011 - Tim Ward CR#3475 - Redid the Narrative Preview so it doesn''t '||chr(10)||
'                                 reload the page.  This was causing '||chr(10)||
'                                 Narrative Loss if not saved.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
'24-Jul-2012 - Tim Ward - CR#4049 - Allow multiple Checks in one Law '||chr(10)||
'                          Enforcement Records Check Activity.'||chr(10)||
'                          Narrative built from those, so it is disabled'||chr(10)||
'                          where it is an ACT.RECORDS_CHECK activity.'||chr(10)||
''||chr(10)||
'30-Jul-2012 - Tim Ward - CR#4050 - Allow multiple Reviews in one '||chr(10)||
'                          Document Review. Narrative built from those, so '||chr(10)||
'                          it is disabled where it is an ACT.DOCUMENT_REVIEW'||chr(10)||
'                          activity.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5150,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<script>'||chr(10)||
'function doRefresh()'||chr(10)||
'{'||chr(10)||
' var node=document.getElementById("NarrativePreview");'||chr(10)||
' node.innerHTML = "Refreshing........Please Wait!";'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Activity_Narrative_Preview'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',''&P5150_SID.'');'||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' node.';

s:=s||'innerHTML = gReturn;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
' <B>Narrative as it will appear in an ROI:</B>'||chr(10)||
' <TABLE WIDTH=100% BORDER=1 BORDERCOLOR=#00000 CELLSPACING=0 CELLPADDING=5 BGCOLOR=#CCCCCC>'||chr(10)||
'  <TR>'||chr(10)||
'   <TD>'||chr(10)||
'    <div id="NarrativePreview">*****Press Refresh to See the Narrative as it will appear in an ROI*****</div>'||chr(10)||
'   </TD>'||chr(10)||
'  </TR>'||chr(10)||
'</TABLE>'||chr(10)||
'<a id="refresh" class="htmlButton" href="javascript:doRefresh();">';

s:=s||'Refresh</a>';

wwv_flow_api.create_page_plug (
  p_id=> 1173832108849825 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5150,
  p_plug_name=> 'Narrative Preview',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 30,
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89979907623334551 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5150,
  p_plug_name=> 'Narrative',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 95231208448973310 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5150,
  p_button_sequence=> 5,
  p_button_plug_id => 89979907623334551+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'ABOVE_BOX',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89980135960334551 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5150,
  p_button_sequence=> 10,
  p_button_plug_id => 89979907623334551+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'ABOVE_BOX',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P0_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_database_action=>'UPDATE',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89981816661334556 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5150,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>89981616487334556 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5150,
  p_branch_action=> 'f?p=&APP_ID.:5150:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P5150_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15122901850991373 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5150,
  p_name=>'P5150_NARRATIVE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 89979907623334551+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'123',
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>15126030949425529 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5150,
  p_name=>'P5150_NARRATIVE_STYLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 89979907623334551+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => ''||chr(10)||
'',
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>89980514358334553 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5150,
  p_name=>'P5150_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 89979907623334551+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5150_NARRATIVE_LABEL.',
  p_source=>'NARRATIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 0,
  p_cMaxlength=> 30000,
  p_cHeight=> 15,
  p_cAttributes=> 'style="width:100%"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => '&P5150_NARRATIVE_STYLE.',
  p_tag_attributes2=> 'style="width:100%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>89980708055334553 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5150,
  p_name=>'P5150_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89979907623334551+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'style="width:100%"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%"',
  p_tag_attributes2=> 'style="width:100%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:T_OSI_ACTIVITY:P5150_SID:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 89980917537334554 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5150,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process T_OSI_ACTIVITY',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||':P5150_SID := :P0_OBJ;'||chr(10)||
':P5150_NARRATIVE_LABEL := ''Narrative:'';'||chr(10)||
':P5150_NARRATIVE_STYLE := ''style="height:auto; width:100%; rows:30;"'';';

wwv_flow_api.create_page_process(
  p_id     => 89981312768334554 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5150,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload Items',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P5150_SID',
  p_process_when_type=>'ITEM_IS_NULL',
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
p:=p||':P5150_NARRATIVE_LABEL:= ''Narrative Text (Records Check builds this automatically):'';'||chr(10)||
':P5150_NARRATIVE := OSI_RECORDS_CHECK.GET_NARRATIVE(:P5150_SID);'||chr(10)||
':P5150_NARRATIVE_STYLE := ''readOnly style="background-color:#f5f4ea; height:auto; width:100%; rows:30;"'';';

wwv_flow_api.create_page_process(
  p_id     => 15123727748093416 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5150,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup Records Check Narrative',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P0_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
p:=p||':P5150_NARRATIVE_LABEL:= ''Narrative Text (Document Review builds this automatically):'';'||chr(10)||
':P5150_NARRATIVE := OSI_DOCUMENT_REVIEW.GET_NARRATIVE(:P5150_SID);'||chr(10)||
':P5150_NARRATIVE_STYLE := ''readOnly style="background-color:#f5f4ea; height:auto; width:100%; rows:30;"'';';

wwv_flow_api.create_page_process(
  p_id     => 15145627058206118 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5150,
  p_process_sequence=> 25,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup Document Review Narrative',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P0_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
p:=p||'F|#OWNER#:T_OSI_ACTIVITY:P5150_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 93527309033818679 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5150,
  p_process_sequence=> 30,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Narrative',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P0_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'')',
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
-- ...updatable report columns for page 5150
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


