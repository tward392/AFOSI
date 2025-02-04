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
