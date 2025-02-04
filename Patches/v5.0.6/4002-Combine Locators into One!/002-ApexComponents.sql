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
--   Date and Time:   07:46 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Actions
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
 
 
prompt Component Export: LIST 92826724656999729
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Actions',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'Actions',
  p_list_item_link_target=> '',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2520728589513384 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6,
  p_list_item_link_text=> 'Check DEERS',
  p_list_item_link_target=> 'javascript:checkDeers(''&P0_OBJ.'');" onclick="javascript:runDirtyTest(''Action''); return !(checkDirty());',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':p0_obj_type_code = ''PART.INDIV'' and'||chr(10)||
'(:p0_obj_context is null or'||chr(10)||
' :p0_obj_context = osi_participant.get_current_version(:p0_obj))',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 100181419940409692 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7,
  p_list_item_link_text=> 'Delete',
  p_list_item_link_target=> 'javascript:deleteObj(''&P0_OBJ.'',''DELETE_OBJECT'');',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_OBJ',
  p_list_item_disp_condition2=> 'javascript:doSubmit(''DELETE_OBJECT'');',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2720026837350801 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7.1,
  p_list_item_link_text=> 'Generate Narrative',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:showPopWin(''f?p=&APP_ID.:22010:&SESSION.::&DEBUG.:22010:::'',600,600,null);return false;',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':p0_obj_type_code = ''ACT.INIT_NOTIF''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827224358027970 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS1.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS1.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS1',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827538210031946 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS2.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS2.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS2',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827710983033635 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS3.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS3.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS3',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827914792034698 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS4.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS4.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS4',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92834125022151189 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS5.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS5.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS5',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92834327793151960 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS6.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS6.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS6',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5681128439478298 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS7.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS7.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS7',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 8397824798935030 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> 'Classify',
  p_list_item_link_target=> 'javascript:newWindow({page:765,clear_cache:''765'',name:''&P0_OBJ._CLASSIFICATION'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P765_OBJ,P765_CONTEXT'',item_values:''&P0_OBJ.,,&P0_OBJ.,'',request:''CLASSIFICATION''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> 'CORE_UTIL.GET_CONFIG(''OSI.ALLOW_CLASSIFICATIONS'')=''Y''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 16340017748308654 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>80,
  p_list_item_link_text=> 'Masking',
  p_list_item_link_target=> 'javascript:newWindow({page:760,clear_cache:''760'',name:''&P0_OBJ._MASK'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P760_OBJ'',item_values:''&P0_OBJ.,,&P0_OBJ.'',request:''MASK''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE in (''ACT.INTERVIEW.WITNESS'',''ACT.SOURCE_MEET'',''ACT.SURVEILLANCE'')',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 17869823711799476 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>90,
  p_list_item_link_text=> 'Duplicate Legacy I2MS Source Search',
  p_list_item_link_target=> 'javascript:newWindow({page:11330,clear_cache:''11330'',name:''&P0_OBJ._SRCSRCH'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P11330_OBJ'',item_values:''&P0_OBJ.,,&P0_OBJ.'',request:''SRCH''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE = ''FILE.SOURCE''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 22212726543600706 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>100,
  p_list_item_link_text=> 'Legacy I2MS Relationship Search',
  p_list_item_link_target=> 'javascript:importRelations(''&P0_OBJ.'',''IMPORT_RELATIONS'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE like (''PART.%'') and osi_participant.get_imp_relations_flag(:P0_OBJ) = ''N''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
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
--   Date and Time:   07:46 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Checklist Menu
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
 
 
prompt Component Export: LIST 92835038528155110
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Checklist Menu',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'Checklists',
  p_list_item_link_target=> '',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST1',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92835512064155112 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST1.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST1.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST1',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92840509831175153 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST2.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST2.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST2',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92840712256175906 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST3.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST3.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST3',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92840915026176668 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST4.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST4.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST4',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92841117796177540 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST5.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST5.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST5',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92841424376179357 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST6.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST6.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST6',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
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
--   Date and Time:   07:52 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: DESKTOP_FILTERS_SQL
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
 
 
prompt Component Export: APP PROCESS 1902010004942942
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       pQuery varchar2(32000);'||chr(10)||
''||chr(10)||
'       pVarCount number := 0;'||chr(10)||
'       pWorkSheetID varchar2(4000);'||chr(10)||
'       pAPPUSER varchar2(4000);'||chr(10)||
'       pInstance varchar2(4000);'||chr(10)||
'       pReportName varchar2(4000) := '''';'||chr(10)||
'       pIsLocator varchar2(1) := ''N'';'||chr(10)||
'       pIsLocatorMulti varchar2(1) := ''N'';'||chr(10)||
'       pExclude varchar2(32000) := '''';'||chr(10)||
'       pIsLocateMany varchar2(1) := ''N'';'||chr(10)||
''||chr(10)||
'       pHeader VARCHAR2(32';

p:=p||'000);'||chr(10)||
'       pQuoteComma Number;'||chr(10)||
'       colCount Number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if apex_collection.collection_exists(p_collection_name=>apex_application.g_x01) then'||chr(10)||
'    '||chr(10)||
'       apex_collection.delete_collection(p_collection_name=>apex_application.g_x01);'||chr(10)||
'  '||chr(10)||
'     end if;'||chr(10)||
'  '||chr(10)||
'     for a in (select * from table(split(apex_application.g_x10,''^^'')))'||chr(10)||
'     loop'||chr(10)||
'         if pVarCount=0 then'||chr(10)||
''||chr(10)||
'           pWorkSheetID :';

p:=p||'= a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=1 then'||chr(10)||
''||chr(10)||
'              pAPPUSER := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=2 then'||chr(10)||
''||chr(10)||
'              pInstance := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=3 then'||chr(10)||
''||chr(10)||
'              pReportName := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=4 then'||chr(10)||
''||chr(10)||
'              pIsLocator := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=5 then'||chr(10)||
''||chr(10)||
'              pIsLocatorMulti := a.col';

p:=p||'umn_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=6 then'||chr(10)||
''||chr(10)||
'              pExclude := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=7 then'||chr(10)||
''||chr(10)||
'              pIsLocateMany := a.column_value;'||chr(10)||
''||chr(10)||
'         end if;'||chr(10)||
'         pVarCount := pVarCount+1;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     pQuery := OSI_DESKTOP.DesktopSQL(apex_application.g_x02, '||chr(10)||
'                                      :user_sid, '||chr(10)||
'                                      apex_applic';

p:=p||'ation.g_x04, '||chr(10)||
'                                      apex_application.g_x05, '||chr(10)||
'                                      apex_application.g_x06, '||chr(10)||
'                                      apex_application.g_x07, '||chr(10)||
'                                      apex_application.g_x08, '||chr(10)||
'                                      apex_application.g_x09,'||chr(10)||
'                                      ''10000'','||chr(10)||
'                         ';

p:=p||'             pWorkSheetID, '||chr(10)||
'                                      pAPPUSER, '||chr(10)||
'                                      pInstance,'||chr(10)||
'                                      pReportName,'||chr(10)||
'                                      pIsLocator,'||chr(10)||
'                                      pIsLocatorMulti,'||chr(10)||
'                                      pExclude,'||chr(10)||
'                                      pIsLocateMany);'||chr(10)||
''||chr(10)||
'     APEX_COLLE';

p:=p||'CTION.CREATE_COLLECTION_FROM_QUERY(p_collection_name=>apex_application.g_x01, p_query => pQuery);'||chr(10)||
''||chr(10)||
'     /* Setup Headers */'||chr(10)||
'     colCount := 0;'||chr(10)||
'     for a in (select * from table(split(pQuery,'' as "'')))'||chr(10)||
'     loop'||chr(10)||
'         pQuoteComma := instr(a.column_value,''",'');'||chr(10)||
''||chr(10)||
'         if (pQuoteComma <= 0) then'||chr(10)||
''||chr(10)||
'           pQuoteComma := instr(a.column_value,''"'' || CHR(13) || CHR(10) || ''      from'');'||chr(10)||
' '||chr(10)||
'    ';

p:=p||'     end if;'||chr(10)||
''||chr(10)||
'         pHeader := substr(a.column_value,1,pQuoteComma-1);'||chr(10)||
''||chr(10)||
'         case'||chr(10)||
'             when colCount=1 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD001:=pHeader;'||chr(10)||
'---                 :P || ''_COL_HEAD'' || to_char(colCount,''000'') := pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=2 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD002:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=3 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD003:=p';

p:=p||'Header;'||chr(10)||
''||chr(10)||
'             when colCount=4 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD004:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=5 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD005:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=6 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD006:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=7 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD007:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=8 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD0';

p:=p||'08:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=9 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD009:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=10 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD010:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=11 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD011:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=12 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD012:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=13 then'||chr(10)||
''||chr(10)||
'                 :P301_';

p:=p||'COL_HEAD013:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=14 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD014:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=15 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD015:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=16 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD016:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=17 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD017:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=18 then'||chr(10)||
''||chr(10)||
'             ';

p:=p||'    :P301_COL_HEAD018:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=19 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD019:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=20 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD020:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=21 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD021:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=22 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD022:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=23 then'||chr(10)||
''||chr(10)||
'   ';

p:=p||'              :P301_COL_HEAD023:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=24 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD024:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=25 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD025:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=26 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD026:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=27 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD027:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=28';

p:=p||' then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD028:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=29 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD029:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=30 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD030:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=31 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD031:=pHeader;'||chr(10)||
' '||chr(10)||
'             when colCount=32 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD032:=pHeader;'||chr(10)||
''||chr(10)||
'             when ';

p:=p||'colCount=33 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD033:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=34 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD034:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=35 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD035:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=36 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD036:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=37 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD037:=pHeader;'||chr(10)||
''||chr(10)||
'        ';

p:=p||'     when colCount=38 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD038:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=39 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD039:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=40 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD040:=pHeader;'||chr(10)||
''||chr(10)||
'             else'||chr(10)||
''||chr(10)||
'                 null;'||chr(10)||
'   '||chr(10)||
'         end case;'||chr(10)||
''||chr(10)||
'         colCount := colCount+1;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'End;';

wwv_flow_api.create_flow_process(
  p_id => 1902010004942942 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP_FILTERS_SQL',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '23-Jun-2011 - Tim Ward - CR#3868 - Added New Parameter for Return Item Name, '||chr(10)||
'                                   this is to support Locators.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Added more Parameters for Locators, also added'||chr(10)||
'                                    dynamic column headers based off of the '||chr(10)||
'                                    '' as "'' portion of the select.'||chr(10)||
'');
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
--   Date and Time:   07:49 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: CFUNDS_ADVANCE
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
 
 
prompt Component Export: LIST 98063018052301648
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'CFUNDS_ADVANCE',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Actions',
  p_list_item_link_target=> 'f?p=&APP_ID.:&APP_PAGEID.:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98063536707301651 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Issue Advance',
  p_list_item_link_target=> 'javascript:doSubmit(''ISSUE_ADVANCE'');',
  p_list_item_disp_cond_type=> 'NEVER',
  p_list_item_disp_condition=> ':P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98063817724301651 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Change Claimant',
  p_list_item_link_target=> 'javascript:openLocator(''301'',''P30600_CLAIMANT_SID'',''N'','''',''OPEN'','''','''',''Choose New Claimant...'',''PERSONNEL'',''&P0_OBJ.'');'||chr(10)||
'',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_SUBMITTED_ON is null and :P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98064124158301651 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>35,
  p_list_item_link_text=> 'Submit for Approval',
  p_list_item_link_target=> 'javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_SUBMITTED_ON is null and :P30600_SID is not null'||chr(10)||
'or'||chr(10)||
':P30600_STATUS = ''Disallowed''',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98064734478301653 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> 'Approve Advance',
  p_list_item_link_target=> 'javascript:doSubmit(''APPROVE_ADVANCE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_STATUS = ''Submitted''',
  p_list_item_disp_condition2=> '(:p30600_submitted_on is not null and '||chr(10)||
'    ((:p30600_approved_on is null) and'||chr(10)||
'     (:p30600_rejected_on is null))) and '||chr(10)||
':P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98064414883301653 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> 'Reject Advance',
  p_list_item_link_target=> 'javascript:doSubmit(''REJECT_ADVANCE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_STATUS = ''Submitted''',
  p_list_item_disp_condition2=> '(:p30600_submitted_on is not null and '||chr(10)||
'    ((:p30600_approved_on is null) and'||chr(10)||
'     (:p30600_rejected_on is null))) and'||chr(10)||
':P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2851325774049504 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> 'Delete Advance',
  p_list_item_link_target=> 'javascript:deleteObj(''&P0_OBJ.'',''DELETE_OBJECT'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ is not null'||chr(10)||
'',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
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
--   Date and Time:   07:48 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: CFUNDS_EXPENSE
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
 
 
prompt Component Export: LIST 97994415302351721
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'CFUNDS_EXPENSE',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Actions',
  p_list_item_link_target=> 'f?p=&APP_ID.:&APP_PAGEID.:&SESSION.::&DEBUG.::::',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_ACTION_VISIBLE=''Y''',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98007316790484610 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Change Claimant',
  p_list_item_link_target=> 'javascript:openLocator(''301'',''P30505_CLAIMANT'',''N'','''',''OPEN'','''','''',''Choose New Claimant...'',''PERSONNEL'',''&P0_OBJ.'');'||chr(10)||
'',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> '(:P30505_STATUS = '''' OR :P30505_STATUS = ''New'')'||chr(10)||
'and :P30505_SID is not null '||chr(10)||
'and cfunds_test_cfp(''EXP_CRE_PROXY'','||chr(10)||
'                       :p0_obj_type_sid,'||chr(10)||
'                       core_context.personnel_sid,'||chr(10)||
'                       osi_personnel.get_current_unit(core_context.personnel_sid)) = ''Y''',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98003030849403492 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>35,
  p_list_item_link_text=> 'Submit for Approval',
  p_list_item_link_target=> 'javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> '(:P30505_STATUS = ''New'' OR :P30505_STATUS = ''Disallowed'')'||chr(10)||
' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98007537915490643 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Disallow Expense',
  p_list_item_link_target=> 'javascript:popupCommentsWindow();',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Submitted'' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98008933722536792 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> 'Approve Expense',
  p_list_item_link_target=> 'javascript:doSubmit(''APPROVE_EXPENSE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Submitted'' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99356936198930156 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> 'Fix Expense',
  p_list_item_link_target=> 'javascript:doSubmit(''FIX_EXPENSE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Rejected''',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 21825829061769470 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> 'View Disallowed Expense Comments',
  p_list_item_link_target=> 'javascript:popupCommentsWindow();',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Disallowed'''||chr(10)||
' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5118719794111720 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>80,
  p_list_item_link_text=> 'Delete',
  p_list_item_link_target=> 'javascript:deleteObj(''&P30505_SID.'',''DELETE_OBJECT'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
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
--   Date and Time:   07:56 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_DESKTOP_FILTERS_COL_REF
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
 
 
prompt Component Export: SHORTCUTS 10339015946311656
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script type="text/javascript">'||chr(10)||
''||chr(10)||
'  // Handle Number of Rows Per Page (Pagination) //'||chr(10)||
'  $(function()'||chr(10)||
'   {'||chr(10)||
'    var pageNum = getPageNum();'||chr(10)||
''||chr(10)||
'    maxval = $v(''P''+pageNum+''_NUM_ROWS'');'||chr(10)||
'    $(''option'', ''#apexir_NUM_ROWS'').each(function(i, item)'||chr(10)||
'     {'||chr(10)||
'      if ( parseInt(item.value) == maxval)'||chr(10)||
'        item.selected=true;'||chr(10)||
'     });'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'function getPageNum()'||chr(10)||
'{'||chr(10)||
' var pageNum = $v(''pFlowStepId'');'||chr(10)||
''||chr(10)||
' var pag';

c1:=c1||'eNums = document.getElementsByName( ''p_flow_step_id'' );'||chr(10)||
''||chr(10)||
' if(pageNums.length > 1)'||chr(10)||
'   {'||chr(10)||
'    for(var i=0;i<pageNums.length;i++)'||chr(10)||
'       pageNum=pageNums[i].getAttribute(''value'');'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' return pageNum;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function getCurrentReportTab()'||chr(10)||
'{'||chr(10)||
' var currentTab = $(''#apexir_REPORT_TABS'').find(''span.current'').text();'||chr(10)||
''||chr(10)||
' if(currentTab==''Working Report'')'||chr(10)||
'   return '''';'||chr(10)||
' else'||chr(10)||
'   return currentTab;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function isLo';

c1:=c1||'cator()'||chr(10)||
'{'||chr(10)||
' var pageNum = getPageNum();'||chr(10)||
''||chr(10)||
' var pLocator = $v(''P''+pageNum+''_IS_LOCATOR'');'||chr(10)||
''||chr(10)||
' if(pLocator=='''')'||chr(10)||
'   pLocator=''N'';'||chr(10)||
''||chr(10)||
' return pLocator; '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function isLocatorMulti()'||chr(10)||
'{'||chr(10)||
' var pageNum = getPageNum();'||chr(10)||
''||chr(10)||
' var pLocatorMulti= $v(''P''+pageNum+''_MULTI'');'||chr(10)||
''||chr(10)||
' if(pLocatorMulti=='''')'||chr(10)||
'   pLocatorMulti=''N'';'||chr(10)||
''||chr(10)||
' return pLocatorMulti; '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function isLocateMany()'||chr(10)||
'{'||chr(10)||
' var pageNum = getPageNum();'||chr(10)||
''||chr(10)||
' var pLocateMany = $';

c1:=c1||'v(''P''+pageNum+''_LOCATEMANY'');'||chr(10)||
''||chr(10)||
' if(pLocateMany=='''')'||chr(10)||
'   pLocateMany=''N'';'||chr(10)||
''||chr(10)||
' return pLocateMany; '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function Desktop_Filters_Col_Ref()'||chr(10)||
'{'||chr(10)||
' var pageNum = getPageNum();'||chr(10)||
''||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=DESKTOP_FILTERS_SQL'','||chr(10)||
'                          $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' // Handle Apex Filters (CURRENT FILTER) //';

c1:=c1||''||chr(10)||
' var searchParams = "";'||chr(10)||
' var CurrentSearchColumn = "";'||chr(10)||
' var CurrentSearch = "";'||chr(10)||
''||chr(10)||
' CurrentSearchColumn=$v(''apexir_CURRENT_SEARCH_COLUMN'');'||chr(10)||
' CurrentSearch=$v(''apexir_SEARCH'');'||chr(10)||
''||chr(10)||
' if(CurrentSearchColumn.length>0 || CurrentSearch.length>0)'||chr(10)||
'   {'||chr(10)||
'    if(CurrentSearchColumn.length==0)'||chr(10)||
'      {'||chr(10)||
'       if(CurrentSearch.length>0)'||chr(10)||
'         searchParams=''Row text contains ^~^''+CurrentSearch;'||chr(10)||
'      }'||chr(10)||
'    else'||chr(10)||
' ';

c1:=c1||'     {'||chr(10)||
'       if(CurrentSearch.length>0)'||chr(10)||
'         searchParams=CurrentSearchColumn+''^~^''+CurrentSearch;'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
' '||chr(10)||
' ////////////////////////'||chr(10)||
' // Get the Parameters //'||chr(10)||
' ////////////////////////'||chr(10)||
''||chr(10)||
' ///////////////////////////////////'||chr(10)||
' // Parameter 1 = Collection Name //'||chr(10)||
' ///////////////////////////////////'||chr(10)||
' get.addParam(''x01'',''P''+pageNum+''_CURRENT_FILTER'');    '||chr(10)||
''||chr(10)||
' /////////////////////////////////';

c1:=c1||'///////////////'||chr(10)||
' // Parameter 2 = Filter                       //'||chr(10)||
' //  1040 = Workhours, need special processing //'||chr(10)||
' ////////////////////////////////////////////////'||chr(10)||
' if(pageNum==''1040'')'||chr(10)||
'   {'||chr(10)||
'    if ($v(''P''+pageNum+''_ALL_PRIV'')==''N'')'||chr(10)||
'      get.addParam(''x02'',''ME'');'||chr(10)||
'    else'||chr(10)||
'      get.addParam(''x02'',$v(''P''+pageNum+''_FILTER''));'||chr(10)||
''||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   get.addParam(''x02'',$v(''P''+pageNum+''_FILTER''));'||chr(10)||
''||chr(10)||
' ////////';

c1:=c1||'////////////////////'||chr(10)||
' // Parameter 3 = User Sid //'||chr(10)||
' ////////////////////////////'||chr(10)||
' get.addParam(''x03'',$v(''USER_SID''));                  // User Sid'||chr(10)||
' '||chr(10)||
' ///////////////////////////////////'||chr(10)||
' // Parameter 4 = Object Type     //'||chr(10)||
' //  1030 = Particpants           //'||chr(10)||
' //  1110 = Investigative Files   //'||chr(10)||
' //  1130 = Service Files         //'||chr(10)||
' //  1140 = Support Files         //'||chr(10)||
' ////////////////////////////';

c1:=c1||'///////'||chr(10)||
' switch(pageNum)'||chr(10)||
'       {'||chr(10)||
'        case ''1030'':'||chr(10)||
'                    get.addParam(''x04'',$v(''P''+pageNum+''_PARTIC_TYPE''));'||chr(10)||
'                    break;'||chr(10)||
''||chr(10)||
'        case ''1110'':'||chr(10)||
'        case ''1130'':'||chr(10)||
'        case ''1140'':'||chr(10)||
'                    get.addParam(''x04'',$v(''P''+pageNum+''_FILE_TYPE''));'||chr(10)||
'                    break;'||chr(10)||
''||chr(10)||
'            default:'||chr(10)||
'                    get.addParam(''x04'',$v(''P''+pageNum+''_OBJECT_';

c1:=c1||'TYPE''));'||chr(10)||
'                    break;'||chr(10)||
''||chr(10)||
'       }'||chr(10)||
''||chr(10)||
' ////////////////////////////////////////////////////////////'||chr(10)||
' // Parameter 5 = Return Page Item Name (Use for Locators) //'||chr(10)||
' ////////////////////////////////////////////////////////////'||chr(10)||
' get.addParam(''x05'',$v(''P''+pageNum+''_RETURN_ITEM''));'||chr(10)||
' '||chr(10)||
' ////////////////////////////////////////////////////////////////////////////////////////'||chr(10)||
' // Parameter 6 = Acti';

c1:=c1||'ve Filter for Most (Active/All)                                  //'||chr(10)||
' //   1030 = Participants Active Filter (Individuals/Companies/Organizations/Programs) //'||chr(10)||
' ////////////////////////////////////////////////////////////////////////////////////////'||chr(10)||
' if(pageNum==''1030'')'||chr(10)||
'   {'||chr(10)||
'    if ($v(''P1030_PARTIC_TYPE'')==''PARTICIPANT'')'||chr(10)||
'      get.addParam(''x06'',$v(''P1030_TYPE''));'||chr(10)||
'    else'||chr(10)||
'      get.addParam(''x06'',';

c1:=c1||'$v(''P1030_ACTIVE_FILTER''));'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   get.addParam(''x06'',$v(''P''+pageNum+''_ACTIVE_FILTER''));'||chr(10)||
''||chr(10)||
' //////////////////////////////////////////////////////////////////////////////////////'||chr(10)||
' // Parameter 7 - 10, no special proccessing needed                                  //'||chr(10)||
' //////////////////////////////////////////////////////////////////////////////////////'||chr(10)||
' get.addParam(''x07'',$v(''apexir_NUM_ROWS';

c1:=c1||'''));            // Rows Per Page'||chr(10)||
' get.addParam(''x08'',''P''+pageNum);                      // Page Identifier'||chr(10)||
' get.addParam(''x09'',searchParams);                     // Search Filters'||chr(10)||
' get.addParam(''x10'',$v(''apexir_WORKSHEET_ID'')+''^^''+'||chr(10)||
'                    $v(''apexir_APP_USER'')+''^^''+    '||chr(10)||
'                    $v(''pInstance'')+''^^''+'||chr(10)||
'                    getCurrentReportTab()+''^^''+'||chr(10)||
'                    isLoca';

c1:=c1||'tor()+''^^''+'||chr(10)||
'                    isLocatorMulti()+''^^''+'||chr(10)||
'                    $v(''P''+pageNum+''_EXCLUDE'')+''^^''+'||chr(10)||
'                    isLocateMany());                   // Worksheet ID^^'||chr(10)||
'                                                       // User Login Name^^'||chr(10)||
'                                                       // Session ID^^'||chr(10)||
'                                                       // Report Name^^'||chr(10)||
'';

c1:=c1||'                                                       // Is this a Locator Page? (Y/N)^^'||chr(10)||
'                                                       // Is this Locator Multi-Select? (Y/N)^^'||chr(10)||
'                                                       // Excludes for Locator Pages^^'||chr(10)||
'                                                       // Is this a Locate Many? (Y/N)'||chr(10)||
'  '||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' // Call APEX ';

c1:=c1||'IR Search //'||chr(10)||
' if(typeof(gReport)!="undefined")'||chr(10)||
'   gReport.search(''SEARCH'');'||chr(10)||
'}'||chr(10)||
' '||chr(10)||
'// Run the following once the document is ready'||chr(10)||
'$(document).ready(function()'||chr(10)||
'{'||chr(10)||
' // -- Handle Go Button --                               //'||chr(10)||
' // Unbind Click event. Important for order of execution //'||chr(10)||
' $(''input[type="button"][value="Go"]'').attr(''onclick'','''');'||chr(10)||
' '||chr(10)||
' // Rebind events //'||chr(10)||
' $(''input[type="button"][value="Go"]'').';

c1:=c1||'click(function(){Desktop_Filters_Col_Ref()});'||chr(10)||
'   '||chr(10)||
' // -- Handle "Enter" in input field -- //'||chr(10)||
' $(''#apexir_SEARCH'').attr(''onkeyup'',''''); //unbind onkeyup event'||chr(10)||
''||chr(10)||
' // Rebind Events //'||chr(10)||
' $(''#apexir_SEARCH'').keyup(function(event){($f_Enter(event))?Desktop_Filters_Col_Ref():null;});'||chr(10)||
''||chr(10)||
' // To Show Initial Report //'||chr(10)||
' Desktop_Filters_Col_Ref();'||chr(10)||
'}); '||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 10339015946311656 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_DESKTOP_FILTERS_COL_REF',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '27-Feb-2012 - Tim Ward - CR#4002 - Moved from Pages/Templates to a Shortcut '||chr(10)||
'                         and changed for JQuery Locators Page #301.'||chr(10)||
'',
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
--   Date and Time:   07:55 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_JQUERY_LOCATOR
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
 
 
prompt Component Export: SHORTCUTS 10898320459413508
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'function logInfo(pMsg)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Log_Info'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pMsg);'||chr(10)||
' gReturn = get.get();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function recentAccess(pObj)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v';

c1:=c1||'(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=RECENT_ACCESS'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
'   '||chr(10)||
' get.addParam(''x01'',pObj);'||chr(10)||
' gReturn = get.get();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function toggleCheckbox(pThis)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=LOC_MULTISELECT'','||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' g';

c1:=c1||'et.addParam(''x01'',pThis.value);'||chr(10)||
' get.addParam(''x02'',pThis.checked ? ''Y'':''N'');'||chr(10)||
' gReturn = get.get();'||chr(10)||
'    '||chr(10)||
' selectionList=gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function loadIndividuals(pParticipant)'||chr(10)||
'{'||chr(10)||
' if(typeof pParticipant == "undefined")'||chr(10)||
'   window.refreshIndividualList(selectionList);'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    window.refreshIndividualList(pParticipant);'||chr(10)||
'    var get = new htmldb_Get(null,'||chr(10)||
'                             $v(''pFlowId''),'||chr(10)||
' ';

c1:=c1||'                            ''APPLICATION_PROCESS=LOC_MULTISELECT'','||chr(10)||
'                             $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
'    get.addParam(''x01'',pParticipant);'||chr(10)||
'    get.addParam(''x02'',''Y'');'||chr(10)||
'    get.addParam(''x03'',''Y'');           // Clear First //'||chr(10)||
'    gReturn = get.get();'||chr(10)||
'    '||chr(10)||
'    selectionList=gReturn;'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function addIndivParticipants(selectionList)'||chr(10)||
'{'||chr(10)||
' selectionList = selectionList.replace(/^\s+|';

c1:=c1||'\s+$/g,"");'||chr(10)||
' var elSel = document.getElementById(''P301_INDIVIDUAL_PARTICIPANTS'');'||chr(10)||
' '||chr(10)||
' if (typeof elSel != "undefined")'||chr(10)||
'   {'||chr(10)||
'    if(elSel!=null)'||chr(10)||
'      {'||chr(10)||
'       for(i=0; i<elSel.length; i++)'||chr(10)||
'          {'||chr(10)||
'           if(elSel[i].selected==true)'||chr(10)||
'             selectionList = selectionList+'':''+elSel[i].value;'||chr(10)||
'          }'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' return selectionList;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function passBack(selectedValue, returnItem)'||chr(10)||
'{';

c1:=c1||''||chr(10)||
' var shit = selectedValue'||chr(10)||
''||chr(10)||
' if (selectedValue != "theList")'||chr(10)||
'   {'||chr(10)||
'    recentAccess(selectedValue);'||chr(10)||
'    window.parent.document.getElementById(returnItem).value = selectedValue;'||chr(10)||
'   } '||chr(10)||
' else '||chr(10)||
'   {'||chr(10)||
'    if (typeof selectionList != "undefined")'||chr(10)||
'      {'||chr(10)||
'       selectionList = addIndivParticipants(selectionList);'||chr(10)||
''||chr(10)||
'       window.parent.document.getElementById(returnItem).value = selectionList.replace(/^\s+';

c1:=c1||'|\s+$/g,"");'||chr(10)||
''||chr(10)||
'       recentAccess(selectionList);'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' window.parent.doSubmit(returnItem);'||chr(10)||
'} '||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 10898320459413508 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_JQUERY_LOCATOR',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '27-Feb-2012 - Tim Ward - CR#4002 - Created for JQuery Locators Page.'||chr(10)||
'',
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
--   Date and Time:   07:54 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_JQUERY_OPENLOCATOR
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
 
 
prompt Component Export: SHORTCUTS 10824323204693450
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'function openLocator(pPage,pReturnItemName,pMulti,pExclude,pRequest,pOthNames,pOthVals,pTitle,pType,pOBJ,pLocateMany)'||chr(10)||
'{'||chr(10)||
' var vMulti = (pMulti == undefined) ? ''N'' : pMulti;'||chr(10)||
' var vExclude = (pExclude == undefined) ? '''' : pExclude;'||chr(10)||
' var vRequest = (pRequest == undefined) ? ''OPEN'' : pRequest;'||chr(10)||
' var vTitle = (pTitle == undefined) ? ''Locator'' : pTitl';

c1:=c1||'e;'||chr(10)||
' var vOthNames = (pOthNames == undefined || pOthNames=='''') ? '''' : '',''+pOthNames;'||chr(10)||
' var vOthVals = (pOthVals == undefined || pOthVals=='''') ? '''' : '',''+pOthVals;'||chr(10)||
' var vDebug = ''NO'';'||chr(10)||
' var vLocateMany= (pLocateMany == undefined) ? ''N'' : pLocateMany;'||chr(10)||
''||chr(10)||
' var iframesource = ''<div width="100%" id="LocatorDiv" class="LocatorDiv" name="LocatorDiv"><iframe width="100%" '' +'||chr(10)||
'                    ''height="100%" ';

c1:=c1||''' +'||chr(10)||
'                    ''frameborder="0" '' +'||chr(10)||
'                    ''name="Locator" id="Locator" class="Locator" '' +'||chr(10)||
'                    ''allowtransparencty="true" '' +'||chr(10)||
'                    ''style="background-color: transparent;" '' +'||chr(10)||
'                    ''src="f?p=&APP_ID.:''+pPage+'':&SESSION.:''+vRequest+'':''+vDebug+'':''+pPage+'':P''+pPage+''_OBJECT_TYPE,P''+pPage+''_OBJ,P''+pPage+''_RETURN_ITEM,P''+pPage+''_MULTI,';

c1:=c1||'P''+pPage+''_LOCATEMANY,P''+pPage+''_EXCLUDE''+vOthNames+'':''+'||chr(10)||
'                    pType+'',''+pOBJ+'',''+pReturnItemName+'',''+vMulti+'',''+vLocateMany+'',''+vExclude+vOthVals+'':"></iframe></div>'';'||chr(10)||
''||chr(10)||
' var vInnerWidth = $(window).width();'||chr(10)||
' var vInnerHeight = $(window).height();'||chr(10)||
''||chr(10)||
' var xRatio = vInnerWidth /960;'||chr(10)||
' var yRatio = vInnerHeight /550;'||chr(10)||
' var xRatio2 = vInnerWidth / 1371;'||chr(10)||
''||chr(10)||
' if(xRatio < 1.1)'||chr(10)||
'   xRatio=1.1;'||chr(10)||
' '||chr(10)||
' ';

c1:=c1||'if(yRatio < 1.1)'||chr(10)||
'   yRatio=1.1;'||chr(10)||
''||chr(10)||
' if(xRatio2 < 1.05)'||chr(10)||
'   xRatio2=1.05;'||chr(10)||
''||chr(10)||
' if(vMulti==''Y'' || vLocateMany==''Y'')'||chr(10)||
'   {'||chr(10)||
'    var execute = function() { document.getElementById(''Locator'').contentWindow.passBack(''theList'',pReturnItemName); }'||chr(10)||
''||chr(10)||
'    var cancel = function() { $dialog.dialog(''close''); }'||chr(10)||
''||chr(10)||
'                                  '||chr(10)||
'    var $dialog = $(iframesource)'||chr(10)||
'                           .dialog({'||chr(10)||
'   ';

c1:=c1||'                                 autoOpen: false,'||chr(10)||
'                                    title: pTitle,'||chr(10)||
'                                    position: ''center'','||chr(10)||
'                                    width: $(window).width()/xRatio2,'||chr(10)||
'                                    height: $(window).height()/yRatio,'||chr(10)||
'                                    modal: true,'||chr(10)||
'                                    buttons: {"Return';

c1:=c1||' Selections":  execute, "Cancel":  cancel }'||chr(10)||
'                                 });'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    var $dialog = $(iframesource)'||chr(10)||
'                           .dialog({'||chr(10)||
'                                    autoOpen: false,'||chr(10)||
'                                    title: pTitle,'||chr(10)||
'                                    position: ''center'','||chr(10)||
'                                    width: $(window).width()/xRatio,'||chr(10)||
'   ';

c1:=c1||'                                 height: $(window).height()/yRatio,'||chr(10)||
'                                    modal: true'||chr(10)||
'                                 });'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' $dialog.dialog(''open'');'||chr(10)||
''||chr(10)||
' try'||chr(10)||
'   {'||chr(10)||
'    var LocatorDiv = document.getElementById(''LocatorDiv'');'||chr(10)||
'    LocatorDiv.className="LocatorDiv";'||chr(10)||
'   }'||chr(10)||
' catch(err)'||chr(10)||
'      {'||chr(10)||
'      }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 10824323204693450 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_JQUERY_OPENLOCATOR',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '27-Feb-2012 - Tim Ward - CR#4002 - Created for JQuery Locators Page.',
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
--   Date and Time:   08:00 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: LOC_MULTISELECT
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
 
 
prompt Component Export: APP PROCESS 94189415163413914
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'       v_item_val VARCHAR2 (100) := apex_application.g_x01;'||chr(10)||
'       v_checked_flag VARCHAR2 (1) := apex_application.g_x02;'||chr(10)||
'       v_clear_first VARCHAR2(1) := apex_application.g_x03;'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'     if v_clear_first = ''Y'' THEN'||chr(10)||
'       '||chr(10)||
'       :P0_LOC_SELECTIONS:= '''';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     IF v_checked_flag = ''Y'' THEN'||chr(10)||
''||chr(10)||
'       IF :P0_LOC_SELECTIONS IS NULL THEN'||chr(10)||
''||chr(10)||
'         :P0_LOC_SELECTIONS := '':'' ||';

p:=p||' v_item_val || '':'';'||chr(10)||
'   '||chr(10)||
'       ELSE'||chr(10)||
''||chr(10)||
'         :P0_LOC_SELECTIONS := :P0_LOC_SELECTIONS || v_item_val || '':'';'||chr(10)||
''||chr(10)||
'      END IF;'||chr(10)||
''||chr(10)||
'     ELSE'||chr(10)||
''||chr(10)||
'       :P0_LOC_SELECTIONS := REPLACE (:P0_LOC_SELECTIONS, '':'' || '||chr(10)||
'                                v_item_val || '':'', '':'');'||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'     htp.p(:P0_LOC_SELECTIONS);'||chr(10)||
'END;';

wwv_flow_api.create_flow_process(
  p_id => 94189415163413914 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'LOC_MULTISELECT',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '27-Feb-2012 - Tim Ward - CR#4002 - Changed for JQuery Locators Page #301.'||chr(10)||
'                                    Added ClearFirst parameter.'||chr(10)||
'');
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
--   Date and Time:   07:58 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: OSI_DESKTOP_GET_PARTICIPANTS_LOV
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
 
 
prompt Component Export: APP PROCESS 11163917103933986
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       pList varchar2(32000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     pList := OSI_DESKTOP.GET_PARTICIPANTS_LOV(apex_application.g_x01); '||chr(10)||
''||chr(10)||
'     htp.p(pList);'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 11163917103933986 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'OSI_DESKTOP_GET_PARTICIPANTS_LOV',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '27-Feb-2012 - Tim Ward - CR#4002 - Created for JQuery Locators Page #301.'||chr(10)||
'');
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
--   Date and Time:   07:59 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: OSI_PARTICPANT_GET_NAME
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
 
 
prompt Component Export: APP PROCESS 11366305049854549
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       pName varchar2(32000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     pName := OSI_PARTICIPANT.GET_NAME(apex_application.g_x01); '||chr(10)||
''||chr(10)||
'     htp.p(pName);'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 11366305049854549 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'OSI_PARTICPANT_GET_NAME',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '27-Feb-2012 - Tim Ward - CR#4002 - Added for JQuery Locators Page #301.'||chr(10)||
'');
end;
 
null;
 
end;
/

COMMIT;