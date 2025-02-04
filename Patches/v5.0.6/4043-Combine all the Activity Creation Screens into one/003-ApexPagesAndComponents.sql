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
--   Date and Time:   13:14 Wednesday May 2, 2012
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
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runJQueryPopWin(''Generate Narrative'',''&P0_OBJ.'',''22010'');return false;',
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
--   Date and Time:   09:55 Friday May 4, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Desktop
--     PAGE TEMPLATE: Empty
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
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms_desktop.js" type="text/javascript"></script>'||chr(10)||
'<head>';

c1:=c1||''||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
'<!-- Begin JQuery/Hover help stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PR';

c1:=c1||'EFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<!-- Right Click Menu Code START -->'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/RightClickMenu/jquery.contextmenu.js"></script>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#jQuery/RightClickMenu/jquery.contextmenu.css" type="text/css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'///////////////////////////////////////////////////////////';

c1:=c1||'//////'||chr(10)||
'// Need to supply full path or IE will give a Security Warning //'||chr(10)||
'/////////////////////////////////////////////////////////////////'||chr(10)||
'var path = window.location+'''';'||chr(10)||
'path = path.substr(0,path.indexOf(''/pls/''))+#IMAGE_PREFIX#+''jQuery/RightClickMenu/'';'||chr(10)||
''||chr(10)||
'var vRankColumnNum = 0;'||chr(10)||
''||chr(10)||
'var menu1 = [ '||chr(10)||
'             {''Open Object'':{ onclick:function(menuItem,menu) { javascript:getObjURL(GetSidFromOpenLink(';

c1:=c1||'$(this))); }, icon:path+''OpenObject.gif'', title:''Open this Object'' } }, '||chr(10)||
'             {''Confirm'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Confirm''); }, icon:path+''Confirm.gif'', title:''Confirm Participant'' } }, '||chr(10)||
'             {''Email Link to this Object'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''EmailLink''); }, icon:path+''EmailLink.gif'', title:''Email Link';

c1:=c1||' to this Object'' } }, '||chr(10)||
'             {''Submit Help Desk Ticket'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Ticket''); }, icon:path+''AskForHelp.gif'', title:''Submit Help Desk Ticket'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Launch VLT'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''VLT''); }, icon:path+''VLT.gif'', title:''Launch VLT'' } }, '||chr(10)||
'         ';

c1:=c1||'    {''View Associated Activities'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Activities''); }, icon:path+''ViewAssociatedActivities.gif'', title:''View Associated Activities'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Keep On Top of Recent Cache'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Keep''); }, icon:path+''KeepOnTopofRecentCache.gif'', title';

c1:=c1||':''Keep On Top of Recent Cache'' } }, '||chr(10)||
'             {''Undo Keep On Top of Recent Cache'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''UnKeep''); }, icon:path+''UndoKeepOnTopofRecentCache.gif'', title:''Undo Keep On Top of Recent Cache'' } }, '||chr(10)||
'             {''Remove from Recent Cache'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''RemoveRecent''); }, icon:path+''RemoveRecen';

c1:=c1||'t16.gif'', title:''Remove from Recent Cache'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Clone'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Clone''); }, icon:path+''clone.gif'', title:''Clone'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Cancel'':{ onclick:function(menuItem,menu) { return true;  }, title:''Cancel'' } } '||chr(10)||
'            ]; '||chr(10)||
''||chr(10)||
'function CheckAccess(';

c1:=c1||'pObj)'||chr(10)||
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
' vRankColumnNum = 0'||chr(10)||
''||chr(10)||
' $(''.apexir_WORKSHEET_DATA'').find(''th'').each(function() '||chr(10)||
'  ';

c1:=c1||'{'||chr(10)||
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
'   if(currentCol==pRankColumnNum)'||chr(10)||
'     {'||chr(10)||
'      vRankValue = $(this).';

c1:=c1||'text();'||chr(10)||
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
' if(vIsRecent==true)'||chr(10)||
'   vRank = GetRankValue(pThis, vRankColumnNum);'||chr(10)||
' '||chr(10)||
' $(pMenu).find(''.';

c1:=c1||'context-menu-item'').each(function() '||chr(10)||
'  {'||chr(10)||
'   $(this).removeClass("context-menu-item-hidden");'||chr(10)||
'   $(this).removeClass("context-menu-item-disabled");'||chr(10)||
'   switch ($(this).prop(''title''))'||chr(10)||
'         {'||chr(10)||
'                                     case ''Clone'':'||chr(10)||
'                                                  if(vObjType.substring(0,4)!=''ACT.'')'||chr(10)||
'                                                    {'||chr(10)||
'                 ';

c1:=c1||'                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                     vRemoveCloneSeperator = true;'||chr(10)||
'                                                    }'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                       case ''Confirm Participant'':'||chr(10)||
'                                                  if(vObjType.substring';

c1:=c1||'(0,5)!=''PART.'')'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                  else'||chr(10)||
'                                                    {'||chr(10)||
'                                                     if(IsParticipantConfirmed(vSID)==''Y'')'||chr(10)||
'                                                       $(this).addClass("context-menu-';

c1:=c1||'item-hidden");'||chr(10)||
'                                                    }'||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                case ''View Associated Activities'':'||chr(10)||
'                                                  if(vObjType.substring(0,5)!=''FILE.'')'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                    ';

c1:=c1||'              break;'||chr(10)||
''||chr(10)||
'               case ''Keep On Top of Recent Cache'':'||chr(10)||
'                                                  if(vIsRecent==false || vRank=="999999.999999")'||chr(10)||
'                                                   $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'          case ''Undo Keep On Top of Recent Cache'':'||chr(10)||
'                       ';

c1:=c1||'                           if(vIsRecent==false || vRank!="999999.999999")'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                  case ''Remove from Recent Cache'':'||chr(10)||
'                                                  if(vIsRecent==false)'||chr(10)||
'                                               ';

c1:=c1||'     $(this).addClass("context-menu-item-hidden");'||chr(10)||
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
'   if (vIsRecent==false && vSeperatorCounter==2)'||chr(10)||
'     $(this).addClass("context-menu-item-hidden");'||chr(10)||
'';

c1:=c1||''||chr(10)||
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
'     beforeShow: function(t,e) '||chr(10)||
'               {'||chr(10)||
'                HideShowItems(t, $(thi';

c1:=c1||'s.menu));'||chr(10)||
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
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetConfirmStatusChangeSID(pSID)'||chr(10)||
'{'||chr(10)||
' var get = ';

c1:=c1||'new htmldb_Get(null,'||chr(10)||
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
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                 ';

c1:=c1||'         ''APPLICATION_PROCESS=Is_Participant_Confirmed'', 	'||chr(10)||
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
' var vTempString = pthis.prop(''innerHTML'');'||chr(10)||
' var startOfSid = vTempString.indexOf(''getObjURL(''';

c1:=c1||');'||chr(10)||
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
'                                         runJQueryPopWin(''Associated Activities'', pSID, ''10155'');'||chr(10)||
'              ';

c1:=c1||'                           break;'||chr(10)||
' '||chr(10)||
'                            case ''Clone'':'||chr(10)||
'                                         if (CheckAccess(pSID)=="Y")'||chr(10)||
''||chr(10)||
'                                           runJQueryPopWin (''Status'', pSID, ''CloneIt'');'||chr(10)||
''||chr(10)||
'                                         else'||chr(10)||
''||chr(10)||
'                                           alert(''You are not authorized to Clone this Activity.'');'||chr(10)||
''||chr(10)||
'               ';

c1:=c1||'                          break;'||chr(10)||
''||chr(10)||
'                          case ''Confirm'':'||chr(10)||
'                                         var vStatusChangeSID = GetConfirmStatusChangeSID(pSID);'||chr(10)||
''||chr(10)||
'                                         if(vStatusChangeSID==''not found'')'||chr(10)||
'                                           alert(''Proper Status could not be found, cannot Confirm from here.'');'||chr(10)||
'                                      ';

c1:=c1||'   else'||chr(10)||
'                                           {'||chr(10)||
'                                            if (CheckAccess(pSID)=="Y")'||chr(10)||
''||chr(10)||
'                                              runJQueryPopWin (''Status'', pSID, vStatusChangeSID);'||chr(10)||
''||chr(10)||
'                                            else'||chr(10)||
''||chr(10)||
'                                              alert(''You are not authorized to Confirm this Participant.'');'||chr(10)||
'                 ';

c1:=c1||'                          }'||chr(10)||
''||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                             case ''Keep'':'||chr(10)||
'                           case ''UnKeep'':'||chr(10)||
'                     case ''RemoveRecent'':'||chr(10)||
'                                         var get = new htmldb_Get(null,'||chr(10)||
'                                                                  $v(''pFlowId''),'||chr(10)||
'                                           ';

c1:=c1||'                       ''APPLICATION_PROCESS=KeepUnkeepRemove_From_Recent_Objects'','||chr(10)||
'                                                                  $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
'                                         get.addParam(''x01'',pSID);'||chr(10)||
'                                         get.addParam(''x02'',pMenuClicked);'||chr(10)||
'                                         get.addParam(''x03'',''&USER_SID.'');'||chr(10)||
'           ';

c1:=c1||'                              gReturn = $.trim(get.get());'||chr(10)||
'                                         window.location.reload();'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                           case ''Ticket'':'||chr(10)||
'                                         var itemValues = pSID+'',,''+''&APP_PAGE_ID.''+'',''+pSID;'||chr(10)||
'                                         newWindow({page:775,clear_cache:''775'',name:''feed';

c1:=c1||'back'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P775_LOCATION,P775_OBJECT'',item_values:itemValues})'||chr(10)||
'                                         break;'||chr(10)||
'             '||chr(10)||
'                              case ''VLT'':'||chr(10)||
'                                         newWindow({page:5550,clear_cache:''5550'',name:''VLT''+pSID,item_names:''P0_OBJ'',item_values:pSID,request:''OPEN''});'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'   ';

c1:=c1||'                     case ''EmailLink'':'||chr(10)||
'                                         //openLocator(''301'',''P5000_PERSONNEL'',''Y'','''',''OPEN'','''','''',''Choose Personnel...'',''PERSONNEL'',''&P0_OBJ.'');'||chr(10)||
'                                         //openLocator(''301'','''',''Y'','''',''OPEN'','''','''',''Choose Personnel...'',''PERSONNEL'',''&P0_OBJ.'');'||chr(10)||
'                                         runJQueryPopWin(''Email Link to this Object''';

c1:=c1||', pSID, ''770'');'||chr(10)||
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
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(';

c1:=c1||'^|\\s)" + className + "(\\s|$)");'||chr(10)||
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
'';

c1:=c1||''||chr(10)||
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
'      prevText: ''Previous'','||chr(10)||
'      showOtherMonths: true,'||chr(10)||
'      selectOtherMonths: true,'||chr(10)||
'      dayNamesShort: [''Sun'',''Mon'',''Tue'',''Wed''';

c1:=c1||',''Thu'',''Fri'',''Sat''],'||chr(10)||
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
'            ';

c1:=c1||' // Add jQuery DatePicker to all DatePicker input fields not hidden //'||chr(10)||
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
'           inputs[i].classNa';

c1:=c1||'me="datepickerdisabled";'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link to each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').clic';

c1:=c1||'k(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
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
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cl';

c1:=c1||'uetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
''||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.prop(''for''));';

c1:=c1||''||chr(10)||
'            $item.prop(''rel'', get.url());'||chr(10)||
'            $item.prop(''relTitle'', $item.html());'||chr(10)||
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
''||chr(10)||
'      // -- Handle Help Button --'||chr(10)||
'      $(''#apex';

c1:=c1||'ir_ACTIONSMENU a[title="Help"]'').prop({''href'':''&HELP_URL.'',''target'':''_blank''});'||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
''||chr(10)||
'<!-- Begin JQuery/Tipsy ToolTip Stuff -->'||chr(10)||
'<script type=''text/javascript'' src=''/i/jquery/tipsy-v1.0.0a-24/src/javascripts/jquery.tipsy.js''></script>'||chr(10)||
'<link rel=''stylesheet'' href=''/i/jquery/tipsy-v1.0.0a-24/src/stylesheets/tipsy.css'' type=''text/css'' />'||chr(10)||
''||chr(10)||
'<scrip';

c1:=c1||'t type=''text/javascript''>'||chr(10)||
'$(document).ready(function() {'||chr(10)||
'		$(''div.tooltip'').tipsy({live: true, fade: true, gravity: ''n'', title: ''tip''});'||chr(10)||
'        });'||chr(10)||
''||chr(10)||
'// Allows Resizing of Report Column Drop-downs //'||chr(10)||
'$(function()'||chr(10)||
'{  '||chr(10)||
' $("#apexir_rollover").resizable({minWidth:$("#apexir_rollover").width(), handles:"e", start:function(e,u){document.body.onclick="";},stop:function(e,u){$(this).css({"height":""}); se';

c1:=c1||'tTimeout(function(){document.body.onclick=gReport.dialog.check;},100);}}).css({"z-index":9999}).children(".ui-resizable-e").css({"background":"#EFEFEF"});'||chr(10)||
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
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script ty';

c1:=c1||'pe="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements ';

c1:=c1||'= (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
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
'  $.datepicker.se';

c1:=c1||'tDefaults({'||chr(10)||
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
'      constrai';

c1:=c1||'nInput: true,'||chr(10)||
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
'             $("td.datepicke';

c1:=c1||'r > input[type!=hidden]").datepicker();'||chr(10)||
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
'  // Add a Toda';

c1:=c1||'y Link to each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });';

c1:=c1||''||chr(10)||
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
''||chr(10)||
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'';

c1:=c1||'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
''||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.prop(''for''));'||chr(10)||
'            $item.prop(''rel'', get.url());'||chr(10)||
'            $item.prop(''relTitle'', $item.html());'||chr(10)||
'     ';

c1:=c1||'       return true;'||chr(10)||
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
''||chr(10)||
'      // -- Handle Help Button --'||chr(10)||
'      $(''#apexir_ACTIONSMENU a[title="Help"]'').prop({''href'':''&HELP_URL.'',''target'':''_blank''});'||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</s';

c1:=c1||'cript>'||chr(10)||
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

c1:=c1||'redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag';

c1:=c1||' = tag || "*";'||chr(10)||
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
'     $(".';

c1:=c1||'datepicker > input[id]").datepicker();'||chr(10)||
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
'      dayNamesMin: [''';

c1:=c1||'Sun'',''Mon'',''Tue'',''Wed'',''Thu'',''Fri'',''Sat''],'||chr(10)||
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
'             // Add jQuery DatePicker to all DatePicke';

c1:=c1||'r input fields not hidden //'||chr(10)||
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
'     ';

c1:=c1||'  }'||chr(10)||
''||chr(10)||
'  $(".datepickernew").datepicker();'||chr(10)||
''||chr(10)||
'  // Add a Today Link to each Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.d';

c1:=c1||'atepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
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
'<link href="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/';

c1:=c1||'javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
''||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.prop(''for''));'||chr(10)||
'            $item.prop(''rel'', get.url());';

c1:=c1||''||chr(10)||
'            $item.prop(''relTitle'', $item.html());'||chr(10)||
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
''||chr(10)||
'      // -- Handle Help Button --'||chr(10)||
'      $(''#apexir_ACTIONSMENU a[title="Help"]'').prop({''hr';

c1:=c1||'ef'':''&HELP_URL.'',''target'':''_blank''});'||chr(10)||
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
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></scrip';

c1:=c1||'t>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#javascript/StatusBar.css" />'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/StatusBar.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
' var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
' var tag = tag || "*";'||chr(10)||
' var elm = elm || document;'||chr(10)||
' var elements = (tag ';

c1:=c1||'== "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
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
'  $.datepicker.setDefaul';

c1:=c1||'ts({'||chr(10)||
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
'      constrainInput:';

c1:=c1||' true,'||chr(10)||
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
'             $("td.datepicker > inp';

c1:=c1||'ut[type!=hidden]").datepicker();'||chr(10)||
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
'  // Add a Today Link to ea';

c1:=c1||'ch Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'';

c1:=c1||'<!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
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
' ';

c1:=c1||''||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
''||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.prop(''for''));'||chr(10)||
'            $item.prop(''rel'', get.url());'||chr(10)||
'            $item.prop(''relTitle'', $item.html());'||chr(10)||
'            return';

c1:=c1||' true;'||chr(10)||
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
''||chr(10)||
'      // -- Handle Help Button --'||chr(10)||
'      $(''#apexir_ACTIONSMENU a[title="Help"]'').prop({''href'':''&HELP_URL.'',''target'':''_blank''});'||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
'<!-- E';

c1:=c1||'nd JQuery/Hover help stuff -->'||chr(10)||
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
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<';

c1:=c1||'link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#javascript/StatusBar.css" />'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/StatusBar.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
' var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
' var tag = tag || "*";'||chr(10)||
' var elm = elm || document;'||chr(10)||
' var elements = (tag == "*';

c1:=c1||'" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
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
'';

c1:=c1||'      dateFormat: ''dd-M-yy'','||chr(10)||
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
'      constrainInput: true';

c1:=c1||','||chr(10)||
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
'             $("td.datepicker > input[ty';

c1:=c1||'pe!=hidden]").datepicker();'||chr(10)||
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
'  // Add a Today Link to eac';

c1:=c1||'h Date Picker //'||chr(10)||
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<';

c1:=c1||'!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepicker-trigger'||chr(10)||
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
'';

c1:=c1||'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
''||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'            var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.prop(''for''));'||chr(10)||
'            $item.prop(''rel'', get.url());'||chr(10)||
'            $item.prop(''relTitle'', $item.html());'||chr(10)||
'            return ';

c1:=c1||'true;'||chr(10)||
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
''||chr(10)||
'      // -- Handle Help Button --'||chr(10)||
'      $(''#apexir_ACTIONSMENU a[title="Help"]'').prop({''href'':''&HELP_URL.'',''target'':''_blank''});'||chr(10)||
'   });'||chr(10)||
' '||chr(10)||
'//]]>'||chr(10)||
'</script>'||chr(10)||
'<!-- En';

c1:=c1||'d JQuery/Hover help stuff -->'||chr(10)||
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
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js">';

c1:=c1||'</script>'||chr(10)||
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
'		cur';

c1:=c1||'rent = elements[i];'||chr(10)||
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
'      ';

c1:=c1||'prevText: ''Previous'','||chr(10)||
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
'';

c1:=c1||''||chr(10)||
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
'$(document).ready(function()'||chr(10)||
' {'||chr(10)||
'  var inputs = getElementsByClassName("datepickernew", "", document);'||chr(10)||
'    '||chr(10)||
'    for (v';

c1:=c1||'ar i=0;i<inputs.length;i++)'||chr(10)||
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
'  $(''input.datepickernew'').datepicker().next(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertic';

c1:=c1||'al-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
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
'<link href="';

c1:=c1||'#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.css" type="text/css" rel="stylesheet" />'||chr(10)||
'<script src="#IMAGE_PREFIX#jquery/cluetip-1.2.2/jquery.cluetip.js" type="text/javascript"></script>'||chr(10)||
' '||chr(10)||
'<script type="text/javascript">'||chr(10)||
'//<![CDATA['||chr(10)||
' '||chr(10)||
'   $(document).ready(function(){'||chr(10)||
'      var pageID = $(''#pFlowId'').val();'||chr(10)||
''||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').each( function(i) {'||chr(10)||
'            var $item = $(this);'||chr(10)||
'          ';

c1:=c1||'  var get = new htmldb_Get(null,pageID,''APPLICATION_PROCESS=ITEM_HELP'',0);'||chr(10)||
'            get.add(''TEMP_ITEM'', $item.prop(''for''));'||chr(10)||
'            $item.prop(''rel'', get.url());'||chr(10)||
'            $item.prop(''relTitle'', $item.html());'||chr(10)||
'            return true;'||chr(10)||
'      });'||chr(10)||
' '||chr(10)||
'      $(''.hoverHelp'').cluetip({'||chr(10)||
'         arrows: true,'||chr(10)||
'         titleAttribute: ''relTitle'','||chr(10)||
'         hoverIntent: {    '||chr(10)||
'            sensitivity';

c1:=c1||': 2,'||chr(10)||
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
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#'||chr(10)||
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
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jquery/css/redmond1.8.20/jquery-ui-1.8.20.custom.css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.7.2.min.js"></';

c1:=c1||'script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-ui-1.8.20.custom.min.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getElementsByClassName(className, tag, elm){'||chr(10)||
'	var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");'||chr(10)||
'	var tag = tag || "*";'||chr(10)||
'	var elm = elm || document;'||chr(10)||
'	var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);'||chr(10)||
'	var ';

c1:=c1||'returnElements = [];'||chr(10)||
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
'      c';

c1:=c1||'hangeYear: true,'||chr(10)||
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
'      buttonImage: ''#IMAGE_PREFIX#Cal';

c1:=c1||'endarR24.png'','||chr(10)||
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
'$(document).read';

c1:=c1||'y(function()'||chr(10)||
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
'  $(''input.datepickernew'').datepicker().nex';

c1:=c1||'t(''.ui-datepicker-trigger'').after(''<a href="#" class="pickToday"><img style="margen-left: 2px; vertical-align : bottom;" class="imgToday" src="#IMAGE_PREFIX#TodayR24.png" alt="Today" title="Today"></a>'');'||chr(10)||
'  $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
' });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<!-- Align the Calendar Image better -->'||chr(10)||
'<style>'||chr(10)||
'.ui-datepick';

c1:=c1||'er-trigger'||chr(10)||
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
'      var pageID = $(''#pFlo';

c1:=c1||'wId'').val();'||chr(10)||
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
'         a';

c1:=c1||'rrows: true,'||chr(10)||
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
'</script>'||chr(10)||
'<!-- End JQuery/Hover help stuff -->'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_O';

c1:=c1||'PEN#';

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
--   Date and Time:   07:19 Monday April 30, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Create
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
 
 
prompt Component Export: LIST 88768131328537196
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Create',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 2700427483559020 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Create',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/OSI_CREATE.gif" />',
  p_list_item_icon_attributes=> '',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>100,
  p_list_item_link_text=> 'Activity',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Activity.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1244926876560210 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>999,
  p_list_item_link_text=> 'Initial Notification',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.INIT_NOTIF'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InitialNotification.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1000,
  p_list_item_link_text=> 'Interview',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Interview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 93004022942618907 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1002,
  p_list_item_link_text=> 'Subject Interview',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.INTERVIEW.SUBJECT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewSubject.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 93004231600621385 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1004,
  p_list_item_link_text=> 'Victim Interview',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.INTERVIEW.VICTIM'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewVictim.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 93004438526623429 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1005,
  p_list_item_link_text=> 'Witness Interview',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.INTERVIEW.WITNESS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewWitness.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 4078713631517926 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1006,
  p_list_item_link_text=> 'Group Interview',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.INTERVIEW.GROUP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewGroup.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1960306117916893 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1007,
  p_list_item_link_text=> 'Source Meet',
  p_list_item_link_target=> 'javascript:createActivityObject(21001, ''ACT.SOURCE_MEET'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SourceMeet.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1309017633334728 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1008,
  p_list_item_link_text=> 'Search',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.SEARCH'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SearchActivity.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88771530598584312 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1010,
  p_list_item_link_text=> 'Briefing',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.BRIEFING'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Briefing.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 96221522529576279 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1018,
  p_list_item_link_text=> 'Liaison',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.LIAISON'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Liaison.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99861620479810573 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1019,
  p_list_item_link_text=> 'Media Analysis',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.MEDIA_ANALYSIS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/MediaAnalysis.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91440021873143307 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1020,
  p_list_item_link_text=> 'Computer Intrusion',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.COMP_INTRUSION'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/ComputerIntrusion.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 100638836230460162 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1023,
  p_list_item_link_text=> 'Consultation',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.CONSULTATION.ACQUISITION'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Consultation.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 100641225542485474 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1026,
  p_list_item_link_text=> 'Coordination',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.COORDINATION.FORENSICS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Coordination.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5500705841679714 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1027,
  p_list_item_link_text=> 'Manual Fingerprint',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.FINGERPRINT.MANUAL'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/FingerPalmPrint.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1663014744902648 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1028,
  p_list_item_link_text=> 'Polygraph Exam',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.POLY_EXAM'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/PolyExam.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91260106297732654 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1030,
  p_list_item_link_text=> 'Document Review',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.DOCUMENT_REVIEW'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/DocumentReview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92085528407674231 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1040,
  p_list_item_link_text=> 'Law Enforcement Records Check',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.RECORDS_CHECK'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/LawEnforcementRecordsCheck.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1108204162889515 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1070,
  p_list_item_link_text=> 'Suspicious Activity Report',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.SUSPACT_REPORT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SuspicioiusActivityReport.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2376514196530442 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1080,
  p_list_item_link_text=> 'Surveillance',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.SURVEILLANCE'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Surveillance.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91558623723596190 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1100,
  p_list_item_link_text=> 'Exception',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.EXCEPTION'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/ExceptionActivity.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 4805420576927267 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1150,
  p_list_item_link_text=> 'Case File Assessment Tool (KFAT)',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.KFAT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/HQCaseReview.gif" />',
  p_list_item_icon_attributes=> '',
  p_list_item_disp_cond_type=> 'NEVER',
  p_list_item_disp_condition=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91691735680581873 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1200,
  p_list_item_link_text=> 'HQ Case Review',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.CC_REVIEW'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/HQCaseReview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 12943806654118135 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1210,
  p_list_item_link_text=> 'HQ Open Case Review',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.OC_REVIEW'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/HQCaseReview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 11620130855212196 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1220,
  p_list_item_link_text=> 'AV Support',
  p_list_item_link_target=> 'javascript:createActivityObject(21001,''ACT.AV_SUPPORT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/AVSupport.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>200,
  p_list_item_link_text=> 'Investigative File',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Investigations.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88790321331262918 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>210,
  p_list_item_link_text=> 'Informational',
  p_list_item_link_target=> 'javascript:createObject(11100,''FILE.INV.INFO'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Informational.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 94001732305162140 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>220,
  p_list_item_link_text=> 'Developmental',
  p_list_item_link_target=> 'javascript:createObject(11100,''FILE.INV.DEV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Developmental.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 94001935076162996 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>230,
  p_list_item_link_text=> 'Case',
  p_list_item_link_target=> 'javascript:createObject(11100,''FILE.INV.CASE'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Case.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 12147903531120300 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>240,
  p_list_item_link_text=> 'DCII Indexing File',
  p_list_item_link_target=> 'javascript:createObject(11600,''FILE.SFS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SFS.gif"/>',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>300,
  p_list_item_link_text=> 'Service File',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Service.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1440625451733781 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>310,
  p_list_item_link_text=> 'AFOSI Applicant File',
  p_list_item_link_target=> 'javascript:createObject(11200,''FILE.AAPP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/AgentApplication.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95584133940934231 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>3000,
  p_list_item_link_text=> 'Analysis and Production',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.ANP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/AandP.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95664821378992074 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>3010,
  p_list_item_link_text=> 'Threatened Airmen Support',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.THRTAIRMANSUPP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_list_item_disp_cond_type=> 'NEVER',
  p_list_item_disp_condition=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1809122725975296 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7020,
  p_list_item_link_text=> 'Force Protection Services',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Folder256.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1809332075978023 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7030,
  p_list_item_link_text=> 'PSO',
  p_list_item_link_target=> 'javascript:createObject(11400,''FILE.PSO'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/PSO.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 1809122725975296 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88772912505598014 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7031,
  p_list_item_link_text=> 'Counterintelligence Services',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Folder256.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2078909123757273 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7040,
  p_list_item_link_text=> 'CSP',
  p_list_item_link_target=> 'javascript:createObject(11500,''FILE.POLY_FILE.SEC'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/csp.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88772912505598014 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>400,
  p_list_item_link_text=> 'Support File',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Support.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2079530940763578 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4005,
  p_list_item_link_text=> 'Criminal Polygraph',
  p_list_item_link_target=> 'javascript:createObject(11500,''FILE.POLY_FILE.CRIM'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/CriminalPolygraph.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 89316834259916999 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4010,
  p_list_item_link_text=> 'Tech Surveillance',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.TECHSURV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95665824889021423 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4020,
  p_list_item_link_text=> 'Source Development',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.SRCDEV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95666235278024473 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4030,
  p_list_item_link_text=> 'Undercover Operations',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.UNDRCVROP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_list_item_disp_cond_type=> 'NEVER',
  p_list_item_disp_condition=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95666413245027589 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4040,
  p_list_item_link_text=> 'Undercover Operations Support',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.UNDRCVROPSUPP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>500,
  p_list_item_link_text=> 'Management',
  p_list_item_link_target=> 'f?p=&APP_ID.:500:&SESSION.::&DEBUG.::::',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Management.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1546418017313514 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5010,
  p_list_item_link_text=> 'Source',
  p_list_item_link_target=> 'javascript:createObject(11300, ''FILE.SOURCE'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Source.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 90146523981642801 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5030,
  p_list_item_link_text=> 'Personnel',
  p_list_item_link_target=> 'javascript:createObject(30400,''PERSONNEL'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Personnel.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 89640224842879257 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5040,
  p_list_item_link_text=> 'Unit',
  p_list_item_link_target=> 'javascript:createObject(30300,''UNIT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Unit.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95667138310044224 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5060,
  p_list_item_link_text=> 'Target Management',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.TARGETMGMT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/TargetManagement.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>600,
  p_list_item_link_text=> 'Participant',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Individual.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91388329810337401 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6010,
  p_list_item_link_text=> 'Individual',
  p_list_item_link_target=> 'javascript:createObject(30000,''PART.INDIV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Individual.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91389332366347587 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6020,
  p_list_item_link_text=> 'Company',
  p_list_item_link_target=> 'javascript:createObject(30100,''PART.NONINDIV.COMP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Company.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91389506870349664 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6030,
  p_list_item_link_text=> 'Organization',
  p_list_item_link_target=> 'javascript:createObject(30100,''PART.NONINDIV.ORG'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Organization.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91390019683353329 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6040,
  p_list_item_link_text=> 'Program',
  p_list_item_link_target=> 'javascript:createObject(30100,''PART.NONINDIV.PROG'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Program.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99870332778552145 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>700,
  p_list_item_link_text=> 'E-Funds',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/CFunds.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99870517325557145 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7010,
  p_list_item_link_text=> 'Advance',
  p_list_item_link_target=> 'javascript:createObject(30600,''CFUNDS_ADV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/CFundsAdvance.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 99870332778552145 + wwv_flow_api.g_id_offset,
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
--   Date and Time:   07:20 Monday April 30, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Get_Act_Surveillance_Techniques
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
 
 
prompt Component Export: APP PROCESS 13088016251705037
 
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
'  l_surveillance_info_type  varchar2(20) := apex_application.g_x01;'||chr(10)||
'  techniques                varchar2(32000);'||chr(10)||
'begin'||chr(10)||
'     for a in (select st.description, st.SID from t_osi_a_surv_technique st '||chr(10)||
'                 where (st.active = ''Y'' and exists(select ''x'' from t_osi_a_surv_mapping '||chr(10)||
'                                                      where technique = st.SID and info_type = nvl(l_surve';

p:=p||'illance_info_type, ''null''))) order by seq, description)'||chr(10)||
'     loop'||chr(10)||
'         techniques := techniques  || replace(a.description, '', '', '' / '') || '';'' || a.SID || '','';'||chr(10)||
'     end loop; '||chr(10)||
'     techniques  := rtrim(techniques , '','');'||chr(10)||
''||chr(10)||
'     htp.p(techniques);'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 13088016251705037 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get_Act_Surveillance_Techniques',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
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
--   Date and Time:   07:21 Monday April 30, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_CREATE_OBJECT
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
 
 
prompt Component Export: SHORTCUTS 93901124260008571
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script type="text/javascript" src="#IMAGE_PREFIX#javascript/i2ms_desktop.js"></script>'||chr(10)||
'';

wwv_flow_api.create_shortcut (
 p_id=> 93901124260008571 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_CREATE_OBJECT',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '24-Apr-2012 - Tim Ward - checkForPriv and createObject are already in'||chr(10)||
'                         i2ms_desktop.js, no reason to have them twice.'||chr(10)||
''||chr(10)||
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
--   Date and Time:   13:14 Tuesday May 1, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_PRECISION_DATE
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
 
 
prompt Component Export: SHORTCUTS 5765702061185025
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'function precisionDate(pReturnItem)'||chr(10)||
'{'||chr(10)||
' var vItemNames = ''P100_RETURN_ITEM,P100_DATE_VALUE'';'||chr(10)||
' var vItemVals = pReturnItem+'',''+document.getElementById(pReturnItem).value;'||chr(10)||
''||chr(10)||
' runJQueryPopWin(''Precision Date'',vItemNames,vItemVals);'||chr(10)||
'}'||chr(10)||
'</script></script>';

wwv_flow_api.create_shortcut (
 p_id=> 5765702061185025 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_PRECISION_DATE',
 p_shortcut_type=> 'HTML_TEXT',
 p_comments=> '01-May-2012 - Tim Ward - CR#4043 - Changed to JQuery Pop-up Window.',
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
--   Date and Time:   08:36 Monday April 30, 2012
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
  p_last_upd_yyyymmddhh24miss => '20120430083645',
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
'                          createActivityObject instead of createObject.');
 
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
  p_id=> 2934707644772068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Email IAFIS Package',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .085,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 1956624401125621 + wwv_flow_api.g_id_offset,
  p_list_template_id=> 2700427483559020+ wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'SQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE=''ACT.FINGERPRINT.CRIMINAL'''||chr(10)||
'and'||chr(10)||
'((:APP_PAGE_ID between 22705 and 22720)'||chr(10)||
'or'||chr(10)||
':APP_PAGE_ID IN (20000,20100,5000,5150,5050,5100,5250,20050,5350))',
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
s:=s||'<a class="menuButton" href="javascript:createActivityObject(''21001'',''ACT.POLY_EXAM'',''P21001_PARTICIPANT_VERSION,P21001_FROM_OBJ'',''&P11505_PARTICIPANT_VERSION.,&P11505_SID.'')">Create Exam</a>';

wwv_flow_api.create_page_plug (
  p_id=> 4597330695664965 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Create Exam',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .09,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_required_role => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID = 11505 and '||chr(10)||
'osi_auth.check_for_priv(''ASSOC'',core_obj.lookup_objtype(''ACT.POLY_EXAM'')) = ''Y''',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<a class="menuButton" href="javascript:createObject(''22200'',''ACT.POLY_EXAM'',''P22200_PARTICIPANT_VERSION,P22200_FROM_OBJ'',''&P11505_PARTICIPANT_VERSION.,&P0_OBJ.'')">Create Exam</a>');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<a class="menuButton" href="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})">VLT</a>';

wwv_flow_api.create_page_plug (
  p_id=> 6168123222152187 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'VLT',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .075,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE not in (''UNIT'', ''PERSONNEL'', ''ALL.REPORT_SPEC'', ''EMM'', ''CFUNDS_EXP'', ''CFUNDS_ADV'')',
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
s:=s||'<a id="RunReport" class="menuButton" href="f?p=&APP_ID.:802:&SESSION.::&DEBUG.::P802_REPORT_TYPE,P802_SPEC_OBJ:&P0_OBJ_CONTEXT.,&P810_OBJ.">Run Report</a>';

wwv_flow_api.create_page_plug (
  p_id=> 7893100014867865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Run Report',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .095,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE = ''ALL.REPORT_SPEC''',
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
  p_id=> 88791007394277845 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Menu',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .01,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_06',
  p_plug_source=> s,
  p_plug_source_type=> 88768131328537196 + wwv_flow_api.g_id_offset,
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
  p_id=> 89804708962366039 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Status Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .03,
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
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_status_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
  p_id=> 92465821398219574 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Checklist Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .04,
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
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_checklist_menu = ''Y'''||chr(10)||
'    and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
  p_id=> 92828711806043271 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Status Menu',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .05,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_status_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
  p_id=> 92843026931189557 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Checklist Menu',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .06,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_checklist_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
  p_id=> 97324716662117817 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Web Links',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .015,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_06',
  p_plug_source=> s,
  p_plug_source_type=> 97324221463090806 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 10000,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_footer=> '<div style="clear:both;"></div>',
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
  p_id=> 98895027291926832 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Participant Versions',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .08,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 98895921535934612 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'')'||chr(10)||
'and osi_participant.is_confirmed(:p0_obj) is not null'||chr(10)||
'and ('||chr(10)||
'(:APP_PAGE_ID between 30105 and 30125) or'||chr(10)||
'(:APP_PAGE_ID between 30020 and 30040) or'||chr(10)||
'(:APP_PAGE_ID = 30415 and :P0_OBJ_TYPE_CODE not in (''PART.NONINDIV.PROG'')))',
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
  p_id=> 100519624593779185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Reports',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .07,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 100519934635782109 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P0_DISPLAY_REPORTS',
  p_plug_display_when_cond2=>'Y',
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
  p_id=> 100528311733447303 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Report Items',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P0_DISPLAY_REPORTS',
  p_plug_display_when_cond2=>'Y',
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
  p_id=>5674616393380192 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 78,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P0_LBL_CHANGE_STATUS7',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 13);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>5675201287385312 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P0_SID_CHANGE_STATUS7',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 14);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>7916731967601601 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 255,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 11);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7916912705605584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 12);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917230713610717 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 265,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 13);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917410412614389 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 14);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917721840617690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 275,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 15);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917905694622410 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 280,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 16);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918120932626854 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 285,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 17);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918307903632573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 290,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 18);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918518293635571 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT10',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 19);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918703879640856 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT10',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 295,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 20);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>89797924536294920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_STATUS_PARAM_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Param List',
  p_source=>'OSI_util.get_status_buttons(:P0_OBJ);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>89819231432769946 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status1',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 1);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>89819736065780829 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status2',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 3);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>89820010570782932 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status3',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 5);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>89820737582790649 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status1',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 2);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>89821627801806826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status2',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 4);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>89822313387812104 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status3',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 6);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>91206608500198768 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 72,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status4',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 7);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>91207316811201212 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 74,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status5',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 9);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>91207526854204131 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 76,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status6',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 11);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>91208734604215739 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status4',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 8);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91209006684217224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status5',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 10);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>91209213264219042 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status6',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 12);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>92466137674224220 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CHECKLIST_PARAM_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Checklist Param List',
  p_source=>'OSI_util.get_checklist_buttons(:P0_OBJ);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>92470937375252512 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHECKLIST1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 1);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>92471128156259299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHECKLIST1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 2);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_id=>92817637826729054 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHECKLIST2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 3);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>92817813715731596 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHECKLIST2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 4);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
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
  p_item_sequence=> 190,
  p_item_plug_id => 98895027291926832+wwv_flow_api.g_id_offset,
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
  p_id=>100536318967196882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_REPORT_PARAM_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_util.get_report_links(:p0_obj)',
  p_source_type=> 'FUNCTION',
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
  p_id=>100542336001381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 205,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 1);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100542517203381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 2);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100542712948381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 215,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 3);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100542910993381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 4);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543129107381585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 225,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 5);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543334958381585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 6);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543523811381585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 235,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 7);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543723900381589 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 8);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543910595381590 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 245,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 9);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100544133290381590 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 10);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
--   Date and Time:   07:23 Tuesday May 8, 2012
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

PROMPT ...Remove page 100
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>100);
 
end;
/

 
--application/pages/page_00100
prompt  ...PAGE 100: Precision Date Widget
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' $(''.title'').hide();'||chr(10)||
''||chr(10)||
' if ("&REQUEST."=="OK")'||chr(10)||
'   {'||chr(10)||
'    window.top.document.getElementById("&P100_RETURN_ITEM.").value = $("#P100_DATE_VALUE").val();'||chr(10)||
'    window.top.doSubmit("&P100_RETURN_ITEM.");'||chr(10)||
'   }'||chr(10)||
'});'||chr(10)||
''||chr(10)||
'function closeDialog()'||chr(10)||
'{'||chr(10)||
' parent.$(''#JQueryPopWin'', window.parent.document).dialog(''close'');'||chr(10)||
' parent.$(''#JQueryPopWin'', window.pare';

ph:=ph||'nt.document).remove();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 100,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Precision Date Widget',
  p_step_title=> 'Precision Date Widget',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120508072225',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '01-May-2012 - Tim Ward - CR#4043 - Changed to use JQuery Popup Window.'||chr(10)||
'                                   Remove title via HTML Header.'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>100,p_text=>ph);
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
  p_id=> 5701726781083392 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 100,
  p_plug_name=> 'Date',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 5762910325159025 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 100,
  p_button_sequence=> 10,
  p_button_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_button_name    => 'OK',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_OK.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5763620715162051 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 100,
  p_button_sequence=> 30,
  p_button_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Clear',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P100_DATE_VALUE',
  p_button_condition_type=> 'NEVER',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13543130567400717 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 100,
  p_button_sequence=> 40,
  p_button_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_button_name    => 'CLOSE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_cattributes=>'onClick="closeDialog();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5970719768363396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_branch_action=> 'f?p=&APP_ID.:100:&SESSION.:OK:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>5763620715162051+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 5,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 17-FEB-2010 11:20 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>5702301744293795 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_branch_action=> 'f?p=&APP_ID.:100:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-FEB-2010 13:28 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5702024816291065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_PRECISION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Precision',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP_WITH_SUBMIT',
  p_lov => 'STATIC2:Year;Y,Month;M,Day;D,Time;T',
  p_lov_columns=> 4,
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
  p_id=>5702503522322689 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_YEAR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Year',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select year_value a, year_value b'||chr(10)||
'  from wwv_flow_years',
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
  p_id=>5714601191728962 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_DAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Day',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select trim(to_char(rownum,''00'')) a, trim(to_char(rownum,''00'')) b'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where rownum <= '||chr(10)||
'       to_char(last_day(to_date(:p100_date_value,''yyyymmddhh24miss'')), ''dd'')',
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
  p_display_when=>'P100_PRECISION',
  p_display_when2=>'D:T',
  p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST',
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
  p_id=>5717907958844376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_DATE_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
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
  p_id=>5728804252975815 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_SECONDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
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
  p_id=>5730706807986032 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_HOURS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Time',
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
  p_display_when=>'P100_PRECISION',
  p_display_when2=>'T',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>5730923083990693 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_MINUTES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'MINUTES',
  p_lov => '.'||to_char(2677023537717654 + wwv_flow_api.g_id_offset)||'.',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P100_PRECISION',
  p_display_when2=>'T',
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
  p_id=>5744025975275439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_MON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Month',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select month_display, trim(to_char(month_value,''00'')) month_val'||chr(10)||
'  from wwv_flow_months_month',
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
  p_display_when=>'P100_PRECISION',
  p_display_when2=>'M:D:T',
  p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST',
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
  p_id=>5764804354176235 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 100,
  p_name=>'P100_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 5701726781083392+wwv_flow_api.g_id_offset,
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_test_date date;'||chr(10)||
'begin'||chr(10)||
'    case :p100_precision'||chr(10)||
'        when ''D'' then'||chr(10)||
'            :p100_seconds := ''00'';'||chr(10)||
'        when ''M'' then'||chr(10)||
'            :p100_seconds := ''01'';'||chr(10)||
'        when ''Y'' then'||chr(10)||
'            :p100_seconds := ''02'';'||chr(10)||
'        when ''T'' then'||chr(10)||
'            :p100_seconds := ''03'';'||chr(10)||
'    end case;'||chr(10)||
''||chr(10)||
'    :p100_date_value := :p100_year || '||chr(10)||
'                        :p100_mon || '||chr(10)||
'                   ';

p:=p||'     :p100_day || '||chr(10)||
'                        :p100_hours || '||chr(10)||
'                        :p100_minutes || '||chr(10)||
'                        :p100_seconds;'||chr(10)||
'    begin'||chr(10)||
'        v_test_date := to_date(:p100_date_value, ''yyyymmddhh24miss'');'||chr(10)||
'    exception'||chr(10)||
'        when others then'||chr(10)||
'            :p100_day := ''01'';'||chr(10)||
'            :p100_date_value := :p100_year || '||chr(10)||
'                                :p100_mon || '||chr(10)||
'                 ';

p:=p||'               :p100_day || '||chr(10)||
'                                :p100_hours || '||chr(10)||
'                                :p100_minutes || '||chr(10)||
'                                :p100_seconds;'||chr(10)||
'    end;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5745406900392926 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 100,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Info',
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
p:=p||'P100_DATE_VALUE';

wwv_flow_api.create_page_process(
  p_id     => 5971807002388165 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 100,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>5763620715162051 + wwv_flow_api.g_id_offset,
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
'    if :p100_date_value is not null then'||chr(10)||
'        :p100_year := substr(:p100_date_value, 1, 4);'||chr(10)||
'        :p100_mon := substr(:p100_date_value, 5, 2);'||chr(10)||
'        :p100_day := substr(:p100_date_value, 7, 2);'||chr(10)||
'        :p100_hours := substr(:p100_date_value, 9, 2);'||chr(10)||
'        :p100_minutes := substr(:p100_date_value, 11, 2);'||chr(10)||
'        :p100_seconds := substr(:p100_date_value, 13, 2);'||chr(10)||
'        case :p100_sec';

p:=p||'onds'||chr(10)||
'            when ''00'' then'||chr(10)||
'                :p100_precision := ''D'';'||chr(10)||
'            when ''01'' then'||chr(10)||
'                :p100_precision := ''M'';'||chr(10)||
'            when ''02'' then'||chr(10)||
'                :p100_precision := ''Y'';'||chr(10)||
'            when ''03'' then'||chr(10)||
'                :p100_precision := ''T'';'||chr(10)||
'        end case;'||chr(10)||
'    else'||chr(10)||
'        if :p100_precision is null then'||chr(10)||
'            :p100_precision := ''D'';'||chr(10)||
'            :p100_second';

p:=p||'s := ''00'';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        if :p100_year is null then'||chr(10)||
'            :p100_year := to_char(sysdate, ''yyyy'');'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        if :p100_mon is null then'||chr(10)||
'            :p100_mon := trim(to_char(sysdate, ''mm''));'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        if :p100_day is null then'||chr(10)||
'            :p100_day := to_char(sysdate, ''dd'');'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        if :p100_hours is null then'||chr(10)||
'            :p100_hours :=';

p:=p||' to_char(sysdate, ''hh24'');'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        if :p100_minutes is null then'||chr(10)||
'            :p100_minutes := to_char(sysdate, ''mi'');'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p100_date_value := :p100_year || '||chr(10)||
'                        :p100_mon || '||chr(10)||
'                        :p100_day || '||chr(10)||
'                        :p100_hours || '||chr(10)||
'                        :p100_minutes || '||chr(10)||
'                        :p100_seconds;'||chr(10)||
'';

p:=p||'end;';

wwv_flow_api.create_page_process(
  p_id     => 5715016213742731 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 100,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'OK',
  p_process_when_type=>'REQUEST_NOT_EQUAL_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 100
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
--   Date and Time:   07:26 Tuesday May 8, 2012
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

PROMPT ...Remove page 11215
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11215);
 
end;
/

 
--application/pages/page_11215
prompt  ...PAGE 11215: Agent Application File - Details
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_CREATE_OBJECT"';

wwv_flow_api.create_page(
  p_id     => 11215,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Agent Application File - Details',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120430083801',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '27-Oct-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
'20-Jan-2012 Tim Ward - CR#3990 Added Associated Activity count to objective report.'||chr(10)||
'                       Made comments stretch 99%.'||chr(10)||
''||chr(10)||
'                       Added (optional) to the Comments Label as asked for by'||chr(10)||
'                       DP.'||chr(10)||
''||chr(10)||
'30-Apr-2012 - Tim Ward - CR#4043 - Changed Buttons to call createActivityObject '||chr(10)||
'                          instead of createObject.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>11215,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select ofafo.sid, ofafot.description "Objective", ofafo.obj_met as "Objective Met",'||chr(10)||
'       (select count(*) from t_osi_f_aapp_file_obj_act where objective=ofafo.sid) as "Associated Activities",'||chr(10)||
'       ofafo.comments as "Comments", decode(ofafo.sid, :p11215_sid, ''Y'', ''N'') as "Current"'||chr(10)||
'  from t_osi_f_aapp_file_obj ofafo, t_osi_f_aapp_file_obj_type ofafot'||chr(10)||
' where ofafo.obj_type = ofafot.sid and ofafo.';

s:=s||'obj = :P11215_OBJ order by ofafot.seq;';

wwv_flow_api.create_report_region (
  p_id=> 1692607976837521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11215,
  p_name=> 'Objectives',
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
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Objectives Found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P11215_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 1692816199837525 + wwv_flow_api.g_id_offset,
  p_region_id=> 1692607976837521 + wwv_flow_api.g_id_offset,
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
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'N',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 1694123307898737 + wwv_flow_api.g_id_offset,
  p_region_id=> 1692607976837521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Objective',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Objective',
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
  p_id=> 1697708406168835 + wwv_flow_api.g_id_offset,
  p_region_id=> 1692607976837521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Objective Met',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Objective Met',
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
  p_id=> 1697906805177835 + wwv_flow_api.g_id_offset,
  p_region_id=> 1692607976837521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Comments',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Comments',
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
  p_id=> 1696505242139487 + wwv_flow_api.g_id_offset,
  p_region_id=> 1692607976837521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 3,
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
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 10406908148253086 + wwv_flow_api.g_id_offset,
  p_region_id=> 1692607976837521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Associated Activities',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Associated Activities',
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 1699515528360120 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11215,
  p_plug_name=> 'Selected Objective',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P11215_SID is not null',
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
s:=s||'select toa.id as "ID", osi_object.get_tagline_link(ofafoa.obj) as "Title",'||chr(10)||
'       to_char(toa.activity_date, :fmt_date) as "Activity Date/Time",'||chr(10)||
'       decode(oaaa.date_from || '' - '' || oaaa.date_to,'||chr(10)||
'              '' - '', '''','||chr(10)||
'              to_char(oaaa.date_from, :fmt_date) || '' - '' || to_char(oaaa.date_to, :fmt_date))'||chr(10)||
'                                                                                ';

s:=s||'as "Activity Dates"'||chr(10)||
'  from t_osi_f_aapp_file_obj_act ofafoa, t_osi_activity toa, t_osi_a_aapp_activity oaaa'||chr(10)||
' where ofafoa.objective = :p11215_sid and ofafoa.obj = toa.sid and oaaa.sid = toa.sid';

wwv_flow_api.create_report_region (
  p_id=> 1766312672009820 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11215,
  p_name=> 'Associated Activities that Support Objectives',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 40,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> 'P11215_SID',
  p_display_condition_type=> 'ITEM_IS_NOT_NULL',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'QUERY_COLUMNS',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Activities Found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P11215_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 1767120600059373 + wwv_flow_api.g_id_offset,
  p_region_id=> 1766312672009820 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'ID',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Id',
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
  p_id=> 1767207297059373 + wwv_flow_api.g_id_offset,
  p_region_id=> 1766312672009820 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Title',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Title',
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
  p_id=> 1767308624059373 + wwv_flow_api.g_id_offset,
  p_region_id=> 1766312672009820 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Date/Time',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Activity Date/Time',
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
  p_id=> 2201201426492526 + wwv_flow_api.g_id_offset,
  p_region_id=> 1766312672009820 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Dates',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Activity Dates',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 1750602312183628 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 30,
  p_button_plug_id => 1766312672009820+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_DOCUMENT_REVIEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Document Review',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:createActivityObject(21001,''ACT.AAPP.DOCUMENT_REVIEW'', ''P21001_FROM_OBJ,P21001_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');',
  p_button_condition=> 'instr(:P11215_POSSIBLE_ACT_TYPES, ''ACT.AAPP.DOCUMENT_REVIEW'') >0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'javascript:createObject(22300,''ACT.AAPP.DOCUMENT_REVIEW'', ''P22300_PARENT_OBJ,P22300_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1760000720618429 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 40,
  p_button_plug_id => 1766312672009820+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_RECORDS_CHECK',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Records Check',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:createActivityObject(21001,''ACT.AAPP.RECORDS_CHECK'', ''P21001_FROM_OBJ,P21001_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');',
  p_button_condition=> 'instr(:P11215_POSSIBLE_ACT_TYPES, ''ACT.AAPP.RECORDS_CHECK'') >0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'javascript:createObject(22300,''ACT.AAPP.RECORDS_CHECK'', ''P22300_PARENT_OBJ,P22300_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');'||chr(10)||
'',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1760432234627454 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 50,
  p_button_plug_id => 1766312672009820+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_INTERVIEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Interview',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:createActivityObject(21001,''ACT.AAPP.INTERVIEW'', ''P21001_FROM_OBJ,P21001_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');',
  p_button_condition=> 'instr(:P11215_POSSIBLE_ACT_TYPES, ''ACT.AAPP.INTERVIEW'') >0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'javascript:createObject(22300,''ACT.AAPP.INTERVIEW'', ''P22300_PARENT_OBJ,P22300_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1762329660815951 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 60,
  p_button_plug_id => 1766312672009820+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_EDUCATION',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Education Activity',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:createActivityObject(21001,''ACT.AAPP.EDUCATION'', ''P21001_FROM_OBJ,P21001_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');',
  p_button_condition=> 'instr(:P11215_POSSIBLE_ACT_TYPES, ''ACT.AAPP.EDUCATION'') >0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'javascript:createObject(22300,''ACT.AAPP.EDUCATION'', ''P22300_PARENT_OBJ,P22300_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');'||chr(10)||
'',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1762610398819854 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 70,
  p_button_plug_id => 1766312672009820+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_EMPLOYMENT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Employment Activity',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:createActivityObject(21001,''ACT.AAPP.EMPLOYMENT'', ''P21001_FROM_OBJ,P21001_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');',
  p_button_condition=> 'instr(:P11215_POSSIBLE_ACT_TYPES, ''ACT.AAPP.EMPLOYMENT'') >0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'javascript:createObject(22300,''ACT.AAPP.EMPLOYMENT'', ''P22300_PARENT_OBJ,P22300_PARENT_OBJECTIVE'', ''&P0_OBJ.,&P11215_SID.'');'||chr(10)||
'',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1679320658481645 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 20,
  p_button_plug_id => 1699515528360120+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15920807358211010 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 80,
  p_button_plug_id => 1692607976837521+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this,11215);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15922005112248215 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 90,
  p_button_plug_id => 1766312672009820+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this,11215);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 1679117195480634 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11215,
  p_button_sequence=> 10,
  p_button_plug_id => 1699515528360120+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:10250:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>1694207292912979 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-JUN-2009 15:47 by TIM McDORKEN');
 
wwv_flow_api.create_page_branch(
  p_id=>2370514459481581 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_branch_action=> 'f?p=&APP_ID.:11215:&SESSION.::&DEBUG.::P0_OBJ:&P11215_OBJ.:#&P11215_PREV_ITEM.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST = ''SAVE'' OR :REQUEST LIKE ''EDIT_%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-DEC-2009 15:58 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>1694512487914537 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_branch_action=> 'f?p=&APP_ID.:11215:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 13-NOV-2009 12:11 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1695530607127940 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 1692607976837521+wwv_flow_api.g_id_offset,
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
  p_id=>1699304100356826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_OBJECTIVE_MET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 1699515528360120+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Objective Met',
  p_source=>'OBJ_MET',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P11215_OBJECTIVE_MET_LOCKOUT.',
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
  p_id=>1705206215660229 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_COMMENTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 1699515528360120+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Comments<br>(optional)',
  p_source=>'COMMENTS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:100%;"',
  p_tag_attributes  => 'style="width:99%;"',
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
  p_id=>1758615303575304 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_POSSIBLE_ACT_TYPES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 1699515528360120+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Possible Activity Types',
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
  p_id=>1759525261597082 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_OBJECTIVE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 1699515528360120+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11215_OBJECTIVE_SID',
  p_source=>'OBJ_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
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
  p_id=>2367909302432785 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_PREV_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 1692607976837521+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Prev Item',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>2464410756325443 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_USER_CAN_MARK_OM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 1692607976837521+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'User Can Mark Om',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>2464807209343400 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_OBJECTIVE_MET_LOCKOUT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 1699515528360120+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Objective Lockout',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>7576024267994044 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 1692607976837521+wwv_flow_api.g_id_offset,
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
  p_id=>15921016016213515 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11215,
  p_name=>'P11215_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 1692607976837521+wwv_flow_api.g_id_offset,
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    :p11215_objective_met := null;'||chr(10)||
'    :p11215_comments := null;'||chr(10)||
'    :p11215_objective_sid := null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 1702722295475642 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11215,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear Out Fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
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
'    :p11215_sid := substr(:request, 6);'||chr(10)||
''||chr(10)||
'    --Get previous item'||chr(10)||
'    :p11215_prev_item := null;'||chr(10)||
''||chr(10)||
'    for k in (select   ofafo.sid'||chr(10)||
'                  from t_osi_f_aapp_file_obj ofafo, t_osi_f_aapp_file_obj_type ofafot'||chr(10)||
'                 where ofafo.obj_type = ofafot.sid'||chr(10)||
'                   and ofafo.obj = :p0_obj'||chr(10)||
'                   and ofafot.seq <'||chr(10)||
'                             (select ofafot2.seq';

p:=p||''||chr(10)||
'                                from t_osi_f_aapp_file_obj ofafo2,'||chr(10)||
'                                     t_osi_f_aapp_file_obj_type ofafot2'||chr(10)||
'                               where ofafo2.obj_type = ofafot2.sid and ofafo2.sid = :p11215_sid)'||chr(10)||
'              order by ofafot.seq desc)'||chr(10)||
'    loop'||chr(10)||
'        :p11215_prev_item := k.sid;'||chr(10)||
'        return;'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 1697225113154701 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11215,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Objective',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
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
p:=p||'#OWNER#:T_OSI_F_AAPP_FILE_OBJ:P11215_SID:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 1700905532385648 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11215,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'ARP',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>1679320658481645 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P11215_SID',
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
p:=p||'F|#OWNER#:T_OSI_F_AAPP_FILE_OBJ:P11215_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 1700516137379243 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11215,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11215_SID',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P11215_SID',
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
'    --Get possible activity types for this objective type'||chr(10)||
'    if (:p11215_sid is not null) then'||chr(10)||
'        select act_types'||chr(10)||
'          into :p11215_possible_act_types'||chr(10)||
'          from t_osi_f_aapp_file_obj_type'||chr(10)||
'         where sid = :p11215_objective_sid;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Get Permissions'||chr(10)||
'    :p11215_user_can_mark_om := osi_auth.check_for_priv(''AAPP_UOWM'', :p0_obj_type_sid);'||chr(10)||
''||chr(10)||
'    --Set lockouts'||chr(10)||
'  ';

p:=p||'  if (:p11215_user_can_mark_om = ''Y'') then'||chr(10)||
'        :p11215_objective_met_lockout := null;'||chr(10)||
'    else'||chr(10)||
'        :p11215_objective_met_lockout := :disable_radio;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :P11215_OBJ:=:P0_OBJ;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 1758831925580081 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11215,
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
 
---------------------------------------
-- ...updatable report columns for page 11215
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
--   Date and Time:   07:27 Tuesday May 8, 2012
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
  p_last_upd_yyyymmddhh24miss => '20120430084001',
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
  p_item_sequence=> 160,
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
  p_item_sequence=> 67,
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
  p_item_sequence=> 110,
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
  p_item_sequence=> 30,
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
  p_item_sequence=> 90,
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
  p_item_sequence=> 120,
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
  p_item_sequence=> 60,
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
  p_item_sequence=> 80,
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
  p_item_sequence=> 130,
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
  p_item_sequence=> 140,
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
  p_item_sequence=> 150,
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
wwv_flow_api.create_page_item(
  p_id=>91946019995415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
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
  p_id=>91946237380415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_INV_SUPPORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
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
  p_item_sequence=> 50,
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
  p_item_sequence=> 10,
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
  p_item_sequence=> 40,
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
  p_item_sequence=> 20,
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
  p_item_sequence=> 65,
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
  p_item_sequence=> 45,
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
--   Date and Time:   12:59 Tuesday May 8, 2012
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
''||chr(10)||
'<script language="javascript">'||chr(10)||
'function showParticWidget(objTypeCode)'||chr(10)||
'{'||chr(10)||
' var participantSID = $v(''P21001_PARTICIPANT'');'||chr(10)||
''||chr(10)||
' $("label[for=P21001_PARTIC_DISPLAY],#P21001_PARTIC_DISPLAY").show();'||chr(10)||
' $(''#FindPartic'').show();'||chr(10)||
''||chr(10)||
' if(participantSID.length > 0)'||chr(10)||
'   $(''#ViewParti';

ph:=ph||'c'').show();'||chr(10)||
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
'function hideField(pID, isDate, isTextAreaWithCounter)'||chr(10)||
'{'||chr(10)||
' var hideText = "label[for="+pID+"],#"+pID;'||chr(10)||
' '||chr(10)||
' $(hideText).hide();'||chr(10)||
''||chr(10)||
' if';

ph:=ph||'(isDate==true)'||chr(10)||
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
' var hideText = "label[for="+pID+"],#"+pID;'||chr(10)||
''||chr(10)||
' $(hideText).show();'||chr(10)||
''||chr(10)||
' if(isDate==true)'||chr(10)||
'   {'||chr(10)||
'    $("#"+pID).next().show();'||chr(10)||
'    $("#"+pID).next().next().show();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if(isTextAreaWithCoun';

ph:=ph||'ter==true)'||chr(10)||
'   $("#"+pID).next().show();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function makeLabelOptional(pID)'||chr(10)||
'{'||chr(10)||
' var label = "label[for="+pID+"]";'||chr(10)||
''||chr(10)||
' $(label).toggleClass(''optionallabel'', true);'||chr(10)||
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
'function hideShowFields(p';

ph:=ph||'this)'||chr(10)||
'{'||chr(10)||
' var list1Val = $("#P21001_LIST_1").val();'||chr(10)||
' var list1Text = $("#P21001_LIST_1 option:selected").text();'||chr(10)||
' var objTypeCode = $v(''P21001_OBJ_TYPE_CODE'');'||chr(10)||
' var explanationSIDS = $v(''P21001_EXPLANATION_VISIBLE'');'||chr(10)||
''||chr(10)||
' // Hide Optional Items //'||chr(10)||
' hideParticWidget();'||chr(10)||
' hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
' hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
' hideField(''P21001_HOUR'',false,false);'||chr(10)||
' ';

ph:=ph||'hideField(''P21001_MINUTE'',false,false);'||chr(10)||
' hideField(''P21001_HOUR_2'',false,false);'||chr(10)||
' hideField(''P21001_MINUTE_2'',false,false);'||chr(10)||
' hideField(''P21001_DATE_2'',true,false);'||chr(10)||
' hideField(''P21001_DATE_3'',true,false);'||chr(10)||
' hideField(''P21001_DATE_4'',true,false);'||chr(10)||
' hideField(''P21001_DATE_5'',true,false);'||chr(10)||
' hideField(''P21001_TEXT_2'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_3'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_4'',false,t';

ph:=ph||'rue);'||chr(10)||
' hideField(''P21001_TEXT_5'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_7'',false,true);'||chr(10)||
' hideField(''P21001_TEXT_8'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
' ';

ph:=ph||'hideField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
' hideField(''P21001_LIST_1'',false,false);'||chr(10)||
' hideField(''P21001_LIST_2'',false,false);'||chr(10)||
' hideField(''P21001_LIST_3'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
' // Hide File Association if value is passed in //'||chr(10)||
' hideField(''P21001_FILE_NAME'',false,false);'||chr(10)||
' hideField(''P21001_FIND_FILE_WIDGET''';

ph:=ph||',false,false);'||chr(10)||
' if($v(''P21001_FROM_OBJ'')=='''')'||chr(10)||
'   {'||chr(10)||
'    showField(''P21001_FILE_NAME'',false,false);'||chr(10)||
'    showField(''P21001_FIND_FILE_WIDGET'',false,false);'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' // Default Labels to Optional //'||chr(10)||
' makeLabelOptional(''P21001_LIST_1'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_2'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_2'');'||chr(10)||
' makeLabelOptional(''P2';

ph:=ph||'1001_DATE_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_4'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_5'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_1_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_2_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_3_DISPLAY'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_TEXT_1'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_2'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_3'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_4';

ph:=ph||''');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_5'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_6'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_7'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_8'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_9'');'||chr(10)||
' makeLabelOptional(''P21001_DOCUMENT_NUMBER'');'||chr(10)||
' makeLabelOptional(''P21001_EXPLANATION'');'||chr(10)||
' '||chr(10)||
' makeLabelOptional(''P21001_HOUR'');'||chr(10)||
' makeLabelOptional(''P21001_HOUR_2'',false,false);'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_RADIOGROU';

ph:=ph||'P_1'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_2'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_3'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_4'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
' switch(objTypeCode)'||chr(10)||
'       {'||chr(10)||
'                        case ''ACT.AAPP'':'||chr(10)||
'        case ''ACT.AAPP.DOCUMENT_REVIEW'':'||chr(10)||
'              case ''ACT.AAPP.EDUCATION'':'||chr(10)||
'             case ''ACT.AAPP.EMPLOYMENT'':'||chr(10)||
'              case ''AC';

ph:=ph||'T.AAPP.INTERVIEW'':'||chr(10)||
'          case ''ACT.AAPP.RECORDS_CHECK'':'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                  case ''ACT.AV_SUPPORT'':'||chr(10)||
'                                        showField(''P21001_LIST_1'');'||chr(10)||
'                                        showField(''P21001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                         ';

ph:=ph||'               showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                    case ''ACT.BRIEFING'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        brea';

ph:=ph||'k;'||chr(10)||
''||chr(10)||
'              case ''ACT.COMP_INTRUSION'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_3'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                             ';

ph:=ph||'           showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_1'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_3'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_PRECIS';

ph:=ph||'ION_DATE_1_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                        showField(''P21001_TEXT_8'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'             case ''ACT.DOCUMENT_REVIEW'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        make';

ph:=ph||'LabelRequired(''P21001_LIST_1'');'||chr(10)||
''||chr(10)||
'                                        if(explanationSIDS.indexOf(list1Val+''~'')>=0)'||chr(10)||
'                                          {'||chr(10)||
'                                           hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                          }'||chr(10)||
'               ';

ph:=ph||'                         else'||chr(10)||
'                                          {'||chr(10)||
'                                           showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'          case ''ACT.FINGERPRINT.MANUAL'':'||chr(10)||
'              ';

ph:=ph||'                          makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                  case ''ACT.INIT_NOTIF'':'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                     ';

ph:=ph||'   break;'||chr(10)||
'  '||chr(10)||
'           case ''ACT.INTERVIEW.SUBJECT'':'||chr(10)||
'            case ''ACT.INTERVIEW.VICTIM'':'||chr(10)||
'           case ''ACT.INTERVIEW.WITNESS'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;';

ph:=ph||''||chr(10)||
''||chr(10)||
''||chr(10)||
'                     case ''ACT.LIAISON'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
''||chr(10)||
'                                        if(';

ph:=ph||'list1Text!=''- Select -'')'||chr(10)||
'                                          {'||chr(10)||
'                                           if ($("#P21001_TITLE").val().length>0)'||chr(10)||
'                                             {'||chr(10)||
'                                              $("#P21001_LIST_1 option").each(function(i)'||chr(10)||
'                                               {'||chr(10)||
'                                                $("#P21001_TITL';

ph:=ph||'E").val($("#P21001_TITLE").val().replace($(this).text(),list1Text));'||chr(10)||
'                                               });'||chr(10)||
'                                             }'||chr(10)||
'                                           else'||chr(10)||
'                                             {'||chr(10)||
'                                              $("#P21001_TITLE").val(list1Text);'||chr(10)||
'                                             }'||chr(10)||
'          ';

ph:=ph||'                                }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.MEDIA_ANALYSIS'':'||chr(10)||
'                                        showField(''P21001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_4'',true,false);'||chr(10)||
'                                      ';

ph:=ph||'  showField(''P21001_DATE_5'',true,false);'||chr(10)||
'                                        showField(''P21001_TEXT_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_3'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_4'',false,true);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                  ';

ph:=ph||'      showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_DATE_2'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                   case ''ACT.POLY_EXAM'':'||chr(10)||
'                                 ';

ph:=ph||'       showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showField(''P21001_HOUR_2'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_5'',false,false);'||chr(10)||
'                                 ';

ph:=ph||'       showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
'            ';

ph:=ph||'   case ''ACT.RECORDS_CHECK'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        makeLabelRequired(''P21';

ph:=ph||'001_LIST_1'');'||chr(10)||
'                                        buildRecordsCheckNarrativeandTitle();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                      case ''ACT.SEARCH'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''';

ph:=ph||'P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
'                                        if(list1Text==''Search of Person'')'||chr(10)||
'                                          {'||chr(10)||
'                                           $(''#P21001_TEXT_6_LABEL'').val('''');'||chr(10)||
'                                           hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                         ';

ph:=ph||'                  showParticWidget();'||chr(10)||
'                                          }'||chr(10)||
'                                        else'||chr(10)||
'                                          {'||chr(10)||
'                                           if(list1Text!=''- Select -'')'||chr(10)||
'                                             {'||chr(10)||
'                                              $(''#P21001_TEXT_6_LABEL'').val(''Explanation'');'||chr(10)||
'                   ';

ph:=ph||'                           showField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                                              makeLabelRequired(''P21001_TEXT_6'');'||chr(10)||
'                                              hideParticWidget();'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                 case ''ACT.SOURCE_MEET'':'||chr(10)||
'     ';

ph:=ph||'                                   showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showField(''P21001_TEXT_7'',false,true);'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'    ';

ph:=ph||'                                    makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                case ''ACT.SURVEILLANCE'':'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'         ';

ph:=ph||'                               showField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_9'',false,false';

ph:=ph||');'||chr(10)||
'                                        showField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
'                                        showField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
'                                        showField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                                        makeLabelR';

ph:=ph||'equired(''P21001_RADIOGROUP_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_3'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001_TEXT_9'');'||chr(10)||
'                                        makeLabelRequired(';

ph:=ph||'''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        if(typeof pthis !== "undefined") '||chr(10)||
'                                          {'||chr(10)||
'                                           if(pthis.id==''P21001_LIST_1'')'||chr(10)||
'                                             {'||chr(10)||
'                                              var get = new htmldb_Get(null,'||chr(10)||
'                                                         ';

ph:=ph||'              $v(''pFlowId''),'||chr(10)||
'                                                                       ''APPLICATION_PROCESS=Get_Act_Surveillance_Techniques'','||chr(10)||
'                                                                       $v(''pFlowStepId''));'||chr(10)||
'                                              get.addParam(''x01'',list1Val);'||chr(10)||
'                                              gReturn = $.trim(get.get());'||chr(10)||
'   ';

ph:=ph||'                                           $("#P21001_LIST_2_LOV").val(gReturn);'||chr(10)||
'  '||chr(10)||
'                                              $(''#P21001_LIST_2'').children().remove().end().append(''<option selected value="%null%">- Select -</option>'');'||chr(10)||
'                                              var items = gReturn.split(","), i;'||chr(10)||
''||chr(10)||
'                                              for (i = 0; i < items.length; i++';

ph:=ph||') '||chr(10)||
'                                                 {'||chr(10)||
'                                                  if(items[i].length>0)'||chr(10)||
'                                                    {'||chr(10)||
'                                                     var values = items[i].split('';'');'||chr(10)||
'                                                     $(''#P21001_LIST_2'').children().end().append(''<option value="''+values[1]+''">''+val';

ph:=ph||'ues[0]+''</option>'');'||chr(10)||
'                                                    }'||chr(10)||
'                                                 }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.SUSPACT_REPORT'':'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                ';

ph:=ph||'                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                                default:'||chr(10)||
'                                        if ($(''#P21001_OBJ_TYPE_CODE'').val().su';

ph:=ph||'bstring(0,16)==''ACT.CONSULTATION'' || $(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.COORDINATION'')'||chr(10)||
'                                          {'||chr(10)||
'                                           // Adjust the Title //'||chr(10)||
'                                           adjustCoordinationConsultationTitle();'||chr(10)||
''||chr(10)||
'                                           showField(''P21001_HOUR'',false,false);'||chr(10)||
'                   ';

ph:=ph||'                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                           showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                           showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                           makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                           makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'              ';

ph:=ph||'                             makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
'                                           // Make sure there is at least one Coordination/Consultation Type in the Select List //'||chr(10)||
'                                           var list = document.getElementById(''P21001_LIST_1'');'||chr(10)||
'                                           if(list!=null)'||chr(10)||
'                                             {'||chr(10)||
'';

ph:=ph||'                                              if(list.length==1)'||chr(10)||
'                                                {'||chr(10)||
'                                                 if(list[0].text=''- Select -'')'||chr(10)||
'                                                   {'||chr(10)||
'                                                    alert(''You are not authorized to create any types of ''+'||chr(10)||
'                                             ';

ph:=ph||'             $("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activities.\n\n''+'||chr(10)||
'                                                          ''Please talk to your Unit Commander about assigning you permissions for ''+$("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activity Types that you need to create.'');'||chr(10)||
''||chr(10)||
'                                                    window.close();'||chr(10)||
'   ';

ph:=ph||'                                                }'||chr(10)||
'                                                }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
''||chr(10)||
'       }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' hideShowFields();'||chr(10)||
' $(document).attr("title", $v(''P21001_OBJ_TYPE_DESCRIPTION'')+" (Create)");'||chr(10)||
'});'||chr(10)||
'</script>';

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
''||chr(10)||
'function buildRecordsCheckNarrativeandTitle()'||chr(10)||
'{'||chr(10)||
' var docTypetxt = $(''#P21001_LIST_1 > option:selected'').text();'||chr(10)||
' var resultstxt = $(''#P21001_LIST_2 > option:selected'').text();'||chr(10)||
' var docTypeval = $(''#P21001_LIST_1 > option:selected'').val();'||chr(10)||
' var resultsval = $(''#P21001_LIST_2 > option:selected'').val();'||chr(10)||
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
' '||chr(10)||
'    gReturn = $.trim(get.get());'||chr(10)||
'    var placeHolder = gReturn.indexOf(''~`~`~`~`'');'||chr(10)||
''||chr(10)||
'    $s(''P21001_TITLE'',gReturn.substring(0,placeHolder));'||chr(10)||
'    $s(''P21001_NARRATIVE'',gReturn.substring(placeHolder+8));'||chr(10)||
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
  p_last_upd_yyyymmddhh24miss => '20120508125808',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '30-Apr-2012 - Tim Ward - CR#4043 - Created to replace ALL Activity Create Pages.');
 
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
'       OSI_PARTICIPANT.GET_NAME(SUBJECT_OF_ACTIVITY) as "Subject Of Activity",'||chr(10)||
'       REFERENCE_NUMBER,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(RESTRICTION) as "Restriction",'||chr(10)||
'       TITLE,'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Record Type",'||chr(10)||
'       decode(:p21001_select';

s:=s||'ed,sid,''Y'',''N'') "Current",'||chr(10)||
'       OSI_FILE.GET_ID(FILE_SID) AS "File"'||chr(10)||
'FROM T_OSI_A_RECORDS_CHECK_MULTI'||chr(10)||
'WHERE PERSONNEL=:USER_SID';

wwv_flow_api.create_report_region (
  p_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_name=> 'Law Enforcement Records Check to Create',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 12,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21001_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK''',
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
  p_query_no_data_found=> '<b><center>***** No Records Check in the List Yet *****</center></b>',
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
  p_id=> 13134213981888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
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
  p_id=> 13133909173888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Subject Of Activity',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Subject of Activity',
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
  p_id=> 13133501990888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'REFERENCE_NUMBER',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Reference Number',
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
  p_id=> 13134016024888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Restriction',
  p_column_display_sequence=> 8,
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
  p_id=> 13133625860888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'TITLE',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Title',
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
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 10,
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
  p_id=> 13134107013888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Record Type',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Record Type',
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
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 11,
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
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13134432753888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'File',
  p_column_display_sequence=> 5,
  p_column_heading=> 'File',
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
  p_id             => 13134618725888181 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 30,
  p_button_plug_id => 13133232569888170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_ACTIVITIES',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Activities',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13195012228757431 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 50,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_ONE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Above Activity and Exit',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13194825949751935 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 55,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add Check to List',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'');',
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
  p_button_condition=> ':P21001_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
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
  p_button_condition=> ':P21001_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'');',
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
  p_branch_condition=> ':REQUEST IN (''CREATE'',''CREATE_ONE'');',
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
  p_display_when=>':P21001_PARTICIPANT IS NOT NULL AND'||chr(10)||
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'');',
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE NOT IN (''ACT.COMP_INTRUSION'');',
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_activity_date is not null',
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
'(:P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'','||chr(10)||
'                          ''ACT.SEARCH'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.POLY_EXAM'','||chr(10)||
'                          ''ACT.SURVEILLANCE'','||chr(10)||
'                          ''ACT.SUSPACT_REPORT'','||chr(10)||
'                          ''ACT.RECORDS_CHECK'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION''));',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
'        v_FieldNames := ''sid,doc_type,explanation,document_number'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p2';

p:=p||'1001_explanation,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_document_number,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_document_review'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'        '||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_Pa';

p:=p||'rticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_fingerprint'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.INIT_NOTIF'' THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''PARTICIPANT'';'||chr(10)||
'        v_ParticipantCode := ''NOTIFIED'';'||chr(10)||
'        v_TableName := ''t_osi_a_init_notification'';'||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :';

p:=p||'P21001_OBJ_TYPE_CODE=''ACT.INTERVIEW.GROUP'' THEN'||chr(10)||
''||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.INTERVIEW.SUBJECT'',''ACT.INTERVIEW.VICTIM'',''ACT.INTERVIEW.WITNESS'') THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''PERSON'';'||chr(10)||
'        v_TableName := ''t_osi_a_interview'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date || '' '' |';

p:=p||'| nvl(:p21001_hour, ''00'') || '':'' || nvl(:p21001_minute, ''00''), :fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.LIAISON'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,liaison_type,liaison_level'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_';

p:=p||'2,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_liaison'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-MON-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.MEDIA_ANALYSIS'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,media_type,media_size,media_size_units,removable_flag,quantity,seizure_date,receive_date,analysis_start_date,analysis_end_date,comments,activity'';'||chr(10)||
'        v_Fie';

p:=p||'ldValues := ''core_sidgen.next_sid'' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_text_2,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || '||chr(10)||
'    ';

p:=p||'                             replace(:p21001_text_3,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_2 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_3 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_4 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_5 || '''''''' || '','' || '''''''' || '||chr(10)||
'        ';

p:=p||'                         replace(:p21001_text_4,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
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
'        v_FieldValue';

p:=p||'s := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_5,'''''''','''''''''''') || '''''''' || '','' || '||chr(10)||
'''to_date(to_char(to_date('' || '''''''' || :p21001_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '||chr(10)||
'''to_date(to_char(to_date';

p:=p||'('' || '''''''' || :p21001_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour_2 || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute_2 || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantC';

p:=p||'ode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_poly_exam'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,doc_type,reference_num'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'    ';

p:=p||'                             replace(:p21001_document_number,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''PARTICIPANTS'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_records_check'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SEARCH'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,search_basis, explana';

p:=p||'tion'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_6,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_search'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_d';

p:=p||'ate, :fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'        :P21001_OBJ_TYPE_SID:=:p21001_list_1;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,commodity,contact_method'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_7,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''nu';

p:=p||'ll'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_source_meet'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || nvl(:p21001_minute,''00'') || ''00'', ''yyyymmddhh24miss'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,EMERGENCY,CONSENSUAL,US_LOCATION,ITEM_CASE,INFO_TYPE,TECHNIQUE,REQUESTED_DURATION'';'||chr(10)||
'';

p:=p||'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || :p21001_radiogroup_2 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_3 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_4 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replac';

p:=p||'e(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_9,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_surveillance'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || n';

p:=p||'vl(:p21001_minute,''00'') || ''00'', ''yyyymmddhh24miss'');'||chr(10)||
'        v_AddressUsage := ''ADDR_INTRCPT'';'||chr(10)||
'        v_AddressCode := ''ADDR_INTRCPT'';'||chr(10)||
'      '||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,CATEGORY,RESOLVED,REPORT_UNIT'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || ''''''''';

p:=p||' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || ''~^~UNIT~^~'' || '''''''';'||chr(10)||
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
'       :P21001_FROM_OBJ:=:';

p:=p||'P21001_FILE_ASSOC;'||chr(10)||
' '||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'     :P0_OBJ := osi_activity.create_instance(:p21001_obj_type_sid,'||chr(10)||
'                                             v_ActivityDate,'||chr(10)||
'                                             :p21001_title,'||chr(10)||
'                                             :p21001_restriction,'||chr(10)||
'                                             :P21001_narrative,'||chr(10)||
'                                             v_';

p:=p||'FieldNames,'||chr(10)||
'                                             v_FieldValues,'||chr(10)||
'                                             :p21001_participant_version,'||chr(10)||
'                                             v_ParticipantUsage,'||chr(10)||
'                                             v_ParticipantCode,'||chr(10)||
'                                             v_TableName,'||chr(10)||
'                                             :p21001_from_obj,'||chr(10)||
'    ';

p:=p||'                                         v_AddressUsage,'||chr(10)||
'                                             v_AddressCode,'||chr(10)||
'                                             :p21001_address_value,'||chr(10)||
'                                             :p21001_parent_objective,'||chr(10)||
'                                             replace(:p21001_pay_cat,''%null%'',''null''),'||chr(10)||
'                                             replace(:p21';

p:=p||'001_duty_cat,''%null%'',''null''),'||chr(10)||
'                                             replace(:p21001_mission,''%null%'',''null''),'||chr(10)||
'                                             :p21001_work_date,'||chr(10)||
'                                             :p21001_hours,'||chr(10)||
'                                             :p21001_complete);'||chr(10)||
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
  p_process_when=>':REQUEST IN (''CREATE'',''CREATE_ONE'');',
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
p:=p||'insert into t_osi_a_records_check_multi'||chr(10)||
'(activity_date,subject_of_activity,reference_number,restriction,title,narrative,doc_type,results,file_sid,personnel,WH_PAY_CAT,WH_DUTY_CAT,WH_MISSION,WH_DATE,WH_HOURS,COMPLETE)'||chr(10)||
'values'||chr(10)||
'(:P21001_ACTIVITY_DATE,'||chr(10)||
' :P21001_PARTICIPANT,'||chr(10)||
' :P21001_DOCUMENT_NUMBER,'||chr(10)||
' :P21001_RESTRICTION,'||chr(10)||
' :P21001_TITLE,'||chr(10)||
' :P21001_NARRATIVE,'||chr(10)||
' REPLACE(:P21001_LIST_1,''%null%'',NULL),'||chr(10)||
' REPLA';

p:=p||'CE(:P21001_LIST_2,''%null%'',NULL),'||chr(10)||
' :P21001_FILE_ASSOC,'||chr(10)||
' :USER_SID,'||chr(10)||
' REPLACE(:P21001_PAY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_DUTY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_MISSION,''%null%'',NULL),'||chr(10)||
' :P21001_WORK_DATE,'||chr(10)||
' :P21001_HOURS,'||chr(10)||
' :P21001_COMPLETE) '||chr(10)||
'returning sid into :P21001_SELECTED;'||chr(10)||
''||chr(10)||
'COMMIT;';

wwv_flow_api.create_page_process(
  p_id     => 13193311115501624 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Check To List',
  p_process_sql_clob => p, 
  p_process_error_message=> 'SHIT',
  p_process_when=>':REQUEST IN (''ADD'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'GOOD',
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
'        delete from T_OSI_A_RECORDS_CHECK_MULTI'||chr(10)||
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
'REFERENCE_NUMBER,'||chr(10)||
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
'COMPLETE'||chr(10)||
'INTO'||chr(10)||
':P21001_SELECTED,'||chr(10)||
':P21001_ACTIVITY_DATE,'||chr(10)||
':P21001_PARTICIPANT_VERSION,'||chr(10)||
':P21001_DOCUMENT_NUMBER,'||chr(10)||
':P21001_RESTRICTION,'||chr(10)||
':P21001_TITLE,'||chr(10)||
':P21001_NARRATIVE,'||chr(10)||
':P21001_LIST_1,';

p:=p||''||chr(10)||
':P21001_LIST_2,'||chr(10)||
':P21001_FILE_ASSOC,'||chr(10)||
':P21001_PAY_CAT,'||chr(10)||
':P21001_DUTY_CAT,'||chr(10)||
':P21001_MISSION,'||chr(10)||
':P21001_WORK_DATE,'||chr(10)||
':P21001_HOURS,'||chr(10)||
':P21001_COMPLETE'||chr(10)||
'FROM T_OSI_A_RECORDS_CHECK_MULTI WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');';

wwv_flow_api.create_page_process(
  p_id     => 13193725660505875 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'      v_sid                    varchar2(20);'||chr(10)||
'      v_act_count              number;'||chr(10)||
'      v_FieldNames             clob := NULL;'||chr(10)||
'      v_FieldValues            clob := NULL;'||chr(10)||
'      v_ActivityDate           date;'||chr(10)||
'      v_TableName              varchar2(100) := NULL;'||chr(10)||
'      v_ParticipantUsage       varchar2(100) := NULL;'||chr(10)||
'      v_ParticipantCode        varchar2(100) := NULL;'||chr(10)||
'      v_AddressUsa';

p:=p||'ge           varchar2(100) := NULL;'||chr(10)||
'      v_AddressCode            varchar2(100) := NULL;'||chr(10)||
'      v_Participant_Version    varchar2(20);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     v_FieldNames := ''doc_type,reference_num'';'||chr(10)||
''||chr(10)||
'     v_ParticipantUsage := ''PARTICIPANTS'';'||chr(10)||
'     v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'     v_TableName := ''t_osi_a_records_check'';'||chr(10)||
''||chr(10)||
'     for i in (SELECT * FROM T_OSI_A_RECORDS_CHECK_MULTI WHERE PERSONNEL=:USER_SID)'||chr(10)||
'';

p:=p||'     loop'||chr(10)||
'         v_ActivityDate := to_date(i.activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
'         v_Participant_Version:=osi_participant.get_current_version(i.subject_of_activity);'||chr(10)||
''||chr(10)||
'         v_FieldValues := '''''''' || replace(i.doc_type,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                          i.reference_number || '''''''';'||chr(10)||
''||chr(10)||
'         v_sid := osi_activity.create_instance(:p2100';

p:=p||'1_obj_type_sid,'||chr(10)||
'                                               v_ActivityDate,'||chr(10)||
'                                               i.title,'||chr(10)||
'                                               i.restriction,'||chr(10)||
'                                               i.narrative,'||chr(10)||
'                                               v_FieldNames,'||chr(10)||
'                                               v_FieldValues,'||chr(10)||
'                    ';

p:=p||'                           v_Participant_Version,'||chr(10)||
'                                               v_ParticipantUsage,'||chr(10)||
'                                               v_ParticipantCode,'||chr(10)||
'                                               v_TableName,'||chr(10)||
'                                               i.file_sid,'||chr(10)||
'                                               v_AddressUsage,'||chr(10)||
'                                   ';

p:=p||'            v_AddressCode,'||chr(10)||
'                                               :p21001_address_value,'||chr(10)||
'                                               :p21001_parent_objective,'||chr(10)||
'                                               replace(i.wh_pay_cat,''%null%'',''null''),'||chr(10)||
'                                               replace(i.wh_duty_cat,''%null%'',''null''),'||chr(10)||
'                                               replace(i.';

p:=p||'wh_mission,''%null%'',''null''),'||chr(10)||
'                                               i.wh_date,'||chr(10)||
'                                               i.wh_hours,'||chr(10)||
'                                               i.complete);'||chr(10)||
''||chr(10)||
'        select count(*) into v_act_count from t_osi_activity where sid=v_sid;'||chr(10)||
'        '||chr(10)||
'        if (v_act_count > 0) then'||chr(10)||
''||chr(10)||
'          recent_access(v_sid, :user_sid);'||chr(10)||
''||chr(10)||
'          delete from t_osi';

p:=p||'_a_records_check_multi where sid=i.sid;'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13193930854507277 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Multiple Records Checks',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Could not create new Law Enforcement Records Check.',
  p_process_when=>':REQUEST IN (''CREATE_ACTIVITIES'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'New Law Enforcement Records Check activity created.',
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

p:=p||'ption,t.sid,ot.default_title'||chr(10)||
'  into :P21001_OBJ_TYPE_DESCRIPTION,:P21001_OBJ_TYPE_SID,:P21001_TITLE'||chr(10)||
'  from t_core_obj_type t,t_osi_obj_type ot'||chr(10)||
' where t.code=:P21001_OBJ_TYPE_CODE'||chr(10)||
'   and ot.sid=t.sid;'||chr(10)||
''||chr(10)||
''||chr(10)||
'IF :P21001_OBJ_TYPE_CODE IN (''ACT.AAPP'',''ACT.AAPP.DOCUMENT_REVIEW'',''ACT.AAPP.EDUCATION'',''ACT.AAPP.EMPLOYMENT'',''ACT.AAPP.INTERVIEW'',''ACT.AAPP.RECORDS_CHECK'') THEN'||chr(10)||
'  '||chr(10)||
'  :P21001_RESTRICTION := osi_refe';

p:=p||'rence.lookup_ref_sid(''RESTRICTION'', ''UNIT'');'||chr(10)||
'  :P21001_NARRATIVE := osi_aapp_activity.get_pre_can_narrative(:P21001_PARENT_OBJECTIVE);'||chr(10)||
''||chr(10)||
'END IF;'||chr(10)||
''||chr(10)||
'CASE :P21001_OBJ_TYPE_CODE'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.AV_SUPPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Request Received'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Support Type'';'||chr(10)||
'             ';

p:=p||'                          :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AV_TYPE'');'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Date Requested By'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Date Completed'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Requestor'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_';

p:=p||'VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Pa';

p:=p||'rticipant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.BRIEFING'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Briefing Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Briefing Time'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.COMP_INTRUSION'' THEN'||chr(10)||
'                                       :P21001_PRECISION_DATE_1_LABEL:=''CCI Notified Date'';'||chr(10)||
'     ';

p:=p||'                                  :P21001_LIST_1_LABEL := ''Impact'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''COMPINT_IMPACT'');'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Contact Method'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
'   ';

p:=p||'                                    :P21001_LIST_3_LABEL := ''AFCERT Category'';'||chr(10)||
'                                       :P21001_LIST_3_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AFCERT_CATEGORY'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''CCI Notified'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Request For Information'';'||chr(10)||
'                   ';

p:=p||'                    :P21001_TEXT_8_LABEL:=''AFCERT Incident Num'';'||chr(10)||
''||chr(10)||
'                                       :P21001_PRECISION_DATE_2_LABEL:=''From'';'||chr(10)||
'                                       :P21001_PRECISION_DATE_3_LABEL:=''To'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''CCI Comment'';'||chr(10)||
''||chr(10)||
'        WHEN ''ACT.DOCUMENT_REVIEW'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_';

p:=p||'DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''DOCREV_DOCTYPE'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Document Type'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''Explanation'';'||chr(10)||
'                                       :P21001_DOCUMENT_NUMBER_LABEL:=''Document Number';

p:=p||''';'||chr(10)||
''||chr(10)||
'                                       :P21001_EXPLANATION_VISIBLE := osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') || ''~'';'||chr(10)||
''||chr(10)||
'     WHEN ''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Fingerprints Taken'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WID';

p:=p||'GET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'        ';

p:=p||'     WHEN ''ACT.INIT_NOTIF'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Notified On'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Notified By'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SR';

p:=p||'C:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.SUBJECT'' THEN'||chr(10)||
'                                       :P21001';

p:=p||'_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTIC';

p:=p||'IPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'       WHEN ''ACT.INTERVIEW.VICTIM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                   ';

p:=p||'    :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Victim'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                           ';

p:=p||'                     ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.WITNESS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                   ';

p:=p||'    :P21001_PARTIC_LABEL:=''Witness'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYP';

p:=p||'E_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                WHEN ''ACT.LIAISON'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Liaison Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Liaison Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON';

p:=p||'_TYPE'');'||chr(10)||
'                                       :P21001_LIST_2_LABEL:=''Liaison Level'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON_LEVEL'');'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.MEDIA_ANALYSIS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''';

p:=p||'Media Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_2_LABEL:=''Media Size'';'||chr(10)||
'                                       :P21001_TEXT_3_LABEL:=''Quantity'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Size Units'';'||chr(10)||
'                                       :';

p:=p||'P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_UNIT'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Removable?'';'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Seizure Date'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Receive Date'';'||chr(10)||
'                                       :P21001_DATE_4_LABEL:=''Analysis Start Date'';';

p:=p||''||chr(10)||
'                                       :P21001_DATE_5_LABEL:=''Analysis End Date'';'||chr(10)||
'                                       :P21001_TEXT_4_LABEL:=''Comments'';'||chr(10)||
''||chr(10)||
'              WHEN ''ACT.POLY_EXAM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Exam Date'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Examinee Name'';'||chr(10)||
'                                       :P210';

p:=p||'01_LIST_1_LABEL:=''Monitor to Exam'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''POLY_MONITOR'');'||chr(10)||
'                                       :P21001_TEXT_5_LABEL:=''Place of Examination'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Start Time'';'||chr(10)||
'                                       :P21001_HOUR_2_LABEL:=''End Time'';'||chr(10)||
'           ';

p:=p||'                            :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTIC';

p:=p||'IPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
'  '||chr(10)||
'          WHEN ''ACT.RECORDS_CHECK'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''LERC_DOCTYPE'');'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject of Activity'';'||chr(10)||
'                             ';

p:=p||'          :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Record Type'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Records Check Result'';'||chr(10)||
'                                       '||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select DESCRIPTION ';

p:=p||'d, CODE r from T_OSI_A_RECORDS_CHECK_RESULTS order by 1)'||chr(10)||
'                                       loop'||chr(10)||
'                                           :P21001_LIST_2_LOV := :P21001_LIST_2_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
''||chr(10)||
'                                       :P21001_DOCUMENT_NUMBER_LABEL:=''Reference Number'';'||chr(10)||
'                       ';

p:=p||'                :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                 WHEN ''ACT.SEARCH'' THEN'||chr(10)||
'         ';

p:=p||'                              :P21001_ACTIVITY_DATE_LABEL:=''Search Date'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Person Associated with Search'';'||chr(10)||
'                                       :P21001_TEXT_6_LABEL:=''Explanation'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Search Type'';'||chr(10)||
'     ';

p:=p||'                                  :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select description d, sid r  '||chr(10)||
'                                                       from t_core_obj_type '||chr(10)||
'                                                         where code like substr(''ACT.SEARCH'', 1, 10) || ''%'' '||chr(10)||
'                                                           ';

p:=p||'and description <> ''Search'' order by description)'||chr(10)||
'                                       loop'||chr(10)||
'                                           :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r|| '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
'                                       :P21001_LIST_1_LOV := rtrim(:P21001_LIST_1_LOV, '','');'||chr(10)||
'  '||chr(10)||
'                          ';

p:=p||'             :P21001_LIST_2_LABEL := ''Search Based Upon'';'||chr(10)||
'                                       :P21001_LIST_2_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SEARCH_BASIS'');'||chr(10)||
'  '||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                              ';

p:=p||'                  ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'            WHEN ''ACT.SOURCE_MEET'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Meet Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METH';

p:=p||'OD'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Interview Type'';'||chr(10)||
'                                       :P21001_TEXT_7_LABEL := ''Commodity'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Source'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                  ';

p:=p||'                     :P21001_FIND_WIDGET_SRC:=''<a href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','''''' ||'||chr(10)||
'                                                                '''''','''''''',''''Choose Source Number...'''',''''SOURCE'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'           WHEN ''ACT.SURVEILLANCE'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested St';

p:=p||'art Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CATEGORY'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Surveillance Information Type'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Surveillance Technique'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''US Locat';

p:=p||'ion'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Emergency'';'||chr(10)||
'                                       :P21001_RADIOGROUP_3_LABEL:=''Consensual'';'||chr(10)||
'                                       :P21001_RADIOGROUP_4_LABEL:=''ITEM Case'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SURV_INFO_TYPE'');'||chr(10)||
'                           ';

p:=p||'            :P21001_TEXT_9_LABEL := ''Requested Duration'';'||chr(10)||
'                                       :P21001_TEXT_9_SUFFIX := ''  days'';'||chr(10)||
'                                       :P21001_ADDRESS_LABEL := ''Address of Intercept'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested Start Date'';'||chr(10)||
'                                       :P21001_';

p:=p||'LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CATEGORY'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Category of Suspicious Activity'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Resolved'';'||chr(10)||
''||chr(10)||
'                                   ELSE'||chr(10)||
'                                       if (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.CONSULTATION'') the';

p:=p||'n'||chr(10)||
''||chr(10)||
'                                         :P21001_ACTIVITY_DATE_LABEL:=''Consultation Date'';'||chr(10)||
'                                         :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                         :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                                         for a in (select d,r '||chr(10)||
'                                                         from V_OSI_CONSULT_CREATE_TYPES';

p:=p||' order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                                         begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type where ';

p:=p||'code =''ACT.CONSULTATION.ACQUISITION'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
'         '||chr(10)||
'                                                  null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov';

p:=p||'(''CONTACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       elsif (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.COORDINATION'') then'||chr(10)||
''||chr(10)||
'                                            :P21001_ACTIVITY_DATE_LABEL:=''Coordination Date'';'||chr(10)||
'                                            :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                            :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                 ';

p:=p||'                        for a in (select d,r '||chr(10)||
'                                                         from V_OSI_COORDIN_CREATE_TYPES order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                 ';

p:=p||'                        begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type where code =''ACT.COORDINATION.FORENSICS'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
''||chr(10)||
'                                                  null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_';

p:=p||'LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       else'||chr(10)||
'                                         '||chr(10)||
'                                         if (:P21001_OBJ_TYPE_CODE IN (''ACT.CC_REVIEW'',''ACT.CHECKLIST'',''ACT.KFAT'',''ACT.OC_REVIEW'')) then'||chr(10)||
'                                 ';

p:=p||'        '||chr(10)||
'  '||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
''||chr(10)||
'                                         else'||chr(10)||
''||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                           :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
''||chr(10)||
'                                         end if;'||chr(10)||
''||chr(10)||
'                                     ';

p:=p||'  end if;'||chr(10)||
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
'if :P21001_LIST_2_LOV = '''' then'||chr(10)||
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
'end';

p:=p||' if;'||chr(10)||
''||chr(10)||
'if :P21001_duty_cat_lov is null then'||chr(10)||
''||chr(10)||
'  :P21001_duty_cat_lov := osi_reference.get_lov(''DUTY_CATEGORY'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_activity_date is null then'||chr(10)||
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
--   Date and Time:   07:39 Tuesday May 8, 2012
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

PROMPT ...Remove page 22010
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>22010);
 
end;
/

 
--application/pages/page_22010
prompt  ...PAGE 22010: Initial Notifcation Generate Narrative
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script type="text/javascript">'||chr(10)||
'function GenerateNarrative(pObj, pDoWhat)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Generate Narrative'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pObj);'||chr(10)||
' get.addParam(''x02'',pDoWhat);'||chr(10)||
''||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' var myString = String(gReturn);'||chr(10)||
' myString=myString.rep';

ph:=ph||'lace(''\n'', '''', ''g'');'||chr(10)||
' '||chr(10)||
' if(pDoWhat!=''Keep'')'||chr(10)||
'   {'||chr(10)||
'    if(myString==''Y'') '||chr(10)||
'      {'||chr(10)||
'       alert(''Narrative has been updated.'');'||chr(10)||
'       window.parent.doSubmit(''RELOAD'');'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'    if(myString==''N'') '||chr(10)||
'      {'||chr(10)||
'       alert(''Narrative did not need to be generated...'');'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' closeDialog();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function closeDialog()'||chr(10)||
'{'||chr(10)||
' parent.$("#JQueryPopWin", window.parent.document).dialog(''close'');'||chr(10)||
' parent.$';

ph:=ph||'("#JQueryPopWin", window.parent.document).remove();'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 22010,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Initial Notifcation Generate Narrative',
  p_step_title=> 'Initial Notifcation Generate Narrative',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120508073451',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '02-May-2012 - Tim Ward - CR#4043 - Changed to use the JQueryPopWin.'||chr(10)||
'                                    Had to change the way it closes.'||chr(10)||
''||chr(10)||
'                                   Made TextAreas 100% width.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>22010,p_text=>ph);
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
  p_id=> 3725800787958172 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22010,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<H1>'||chr(10)||
'A Narrative already exists, would you like to KEEP the CURRENT Narrative, OVERWRITE the existing Narrative, or APPEND to the CURRENT Narrative?'||chr(10)||
'</H1>'||chr(10)||
'<TABLE WIDTH=100%>'||chr(10)||
'  <TD><B>Current Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_CURRENT_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_CURRENT_NARRATIVE" readonly="readonly" style="w';

s:=s||'idth:100%">&P22010_CURRENT_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a id=''Keep'' class="htmlButton" href="javascript:GenerateNarrative(''&P22010_OBJ.'',''Keep'');">Keep Current</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE WIDTH=100%>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>New Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_NEW_NARRATIVE" rows="5" cols="80" wrap="virtual" id="';

s:=s||'P22010_NEW_NARRATIVE" readonly="readonly" style="width:100%">&P22010_NEW_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a class="htmlButton" href="javascript:GenerateNarrative(''&P22010_OBJ.'',''Over'');">Overwrite</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE WIDTH=100%>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>Append Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_APPEND_NARRATIVE"';

s:=s||' rows="5" cols="80" wrap="virtual" id="P22010_APPEND_NARRATIVE" readonly="readonly" style="width:100%">&P22010_APPEND_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a class="htmlButton" href="javascript:GenerateNarrative(''&P22010_OBJ.'',''Append'');">Append</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>';

wwv_flow_api.create_page_plug (
  p_id=> 3775915747718095 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22010,
  p_plug_name=> 'myRegion',
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
  p_plug_comment=> '<H1>'||chr(10)||
'A Narrative already exists, would you like to KEEP the CURRENT Narrative, OVERWRITE the existing Narrative, or APPEND to the CURRENT Narrative?'||chr(10)||
'</H1>'||chr(10)||
'<TABLE>'||chr(10)||
'  <TD><B>Current Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_CURRENT_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_CURRENT_NARRATIVE" readonly="readonly">&P22010_CURRENT_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a  class="htmlButton" href="javascript:doSubmit(''Keep'');" onclick="mySubmit(''Keep'');">Keep Current</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>New Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_NEW_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_NEW_NARRATIVE" readonly="readonly">&P22010_NEW_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a  class="htmlButton" href="javascript:doSubmit(''Over'');" onclick="mySubmit(''Over'');">Overwrite</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>Append Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_APPEND_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_APPEND_NARRATIVE" readonly="readonly">&P22010_APPEND_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a  class="htmlButton" href="javascript:doSubmit(''Append'');" onclick="mySubmit(''Append'');">Append</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>3732210564680345 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_branch_action=> 'f?p=&FLOW_ID.:22010:&SESSION.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3725100656948606 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_CURRENT_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Current Narrative:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>3725309314951182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_NEW_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Narrative:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>3761802751732071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Obj',
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
  p_id=>3764027020966205 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_AUTO_UPDATE_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_id=>3767531344279694 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_APPEND_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Narrative:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>3785218533388827 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_NARRATIVES_EQUAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narratives Equal',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||':P22010_OBJ := :P0_OBJ;'||chr(10)||
':P22010_AUTO_UPDATE_NARRATIVE := ''N'';'||chr(10)||
':P22010_NARRATIVES_EQUAL := ''N'';'||chr(10)||
''||chr(10)||
'select narrative into :P22010_CURRENT_NARRATIVE from t_osi_activity where sid=:P22010_OBJ;'||chr(10)||
''||chr(10)||
':P22010_NEW_NARRATIVE := osi_util.do_title_substitution(:p0_obj,core_util.get_config(''OSI.INV_DEFAULT_BACKGROUND''));'||chr(10)||
''||chr(10)||
':P22010_APPEND_NARRATIVE := :P22010_CURRENT_NARRATIVE || chr(10) || chr(13) || :P22010_NEW_NAR';

p:=p||'RATIVE;'||chr(10)||
''||chr(10)||
'if :P22010_CURRENT_NARRATIVE is null or :P22010_CURRENT_NARRATIVE='''' then'||chr(10)||
''||chr(10)||
'  :P22010_AUTO_UPDATE_NARRATIVE := ''Y'';'||chr(10)||
''||chr(10)||
'  htp.p('''||chr(10)||
'<SCRIPT type="text/javascript">'||chr(10)||
'<!--  to hide script contents from old browsers'||chr(10)||
'GenerateNarrative(''''&P0_OBJ.'''',''''Over'''');'||chr(10)||
'closeDialog();'||chr(10)||
'// end hiding contents from old browsers  -->'||chr(10)||
'</SCRIPT>'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P22010_CURRENT_NARRATIVE = :P22010_NEW_NARRATIVE then'||chr(10)||
' ';

p:=p||''||chr(10)||
'  :P22010_NARRATIVES_EQUAL := ''Y'';'||chr(10)||
'htp.p(''<SCRIPT type="text/javascript">'||chr(10)||
'<!--  to hide script contents from old browsers'||chr(10)||
'alert(''''Narrative that would be generated would be the same as the current Narrative.  No Changes Made....'''');'||chr(10)||
'closeDialog();'||chr(10)||
'// end hiding contents from old browsers  -->'||chr(10)||
'</SCRIPT>'');'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 3761525822729307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 22010,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_HEADER',
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
 
---------------------------------------
-- ...updatable report columns for page 22010
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
--   Date and Time:   08:25 Tuesday May 8, 2012
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

PROMPT ...Remove page 5450
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5450);
 
end;
/

 
--application/pages/page_05450
prompt  ...PAGE 5450: Status Change Widget
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
'function closeThis()'||chr(10)||
'{'||chr(10)||
' //window.parent.doSubmit(''closeIt'');'||chr(10)||
' parent.$(''#JQueryPopWin'', window.parent.document).dialog(''close'');'||chr(10)||
' parent.$(''#JQueryPopWin'', window.parent.document).remove();'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'if (''&P5450_DONE.'' == ''Y'')'||chr(10)||
'  {'||chr(10)||
'   var cloning = 0;'||chr(10)||
'   var open_';

ph:=ph||'new = false;'||chr(10)||
''||chr(10)||
'   switch (''&P5450_STATUS_CHANGE_DESC.'') '||chr(10)||
'         {'||chr(10)||
'                      case ''Clone Activity'': '||chr(10)||
'                                            cloning = 1; '||chr(10)||
'                                            alert(''Click OK to open the cloned activity.''); '||chr(10)||
'                                            break;'||chr(10)||
''||chr(10)||
'                         case ''Create Case'': '||chr(10)||
'                                      ';

ph:=ph||'      cloning = 1; '||chr(10)||
'                                            alert(''Click OK to open the case file.''); '||chr(10)||
'                                            break;'||chr(10)||
''||chr(10)||
'           case ''Create DCII Indexing File'': '||chr(10)||
'                                            cloning = 1; '||chr(10)||
'                                            alert(''Click OK to open the DCII Indexing file.''); '||chr(10)||
'                                         ';

ph:=ph||'   break;'||chr(10)||
''||chr(10)||
'          case ''Migrate to Existing Source'':'||chr(10)||
'                                            open_new = confirm(''This source has been migrated to '' + ''&P5450_SOURCE_ID.'' + '', would you like to open it?'');'||chr(10)||
'                                            break;'||chr(10)||
''||chr(10)||
'                                    default: '||chr(10)||
'                                            break;'||chr(10)||
'         } '||chr(10)||
'  '||chr(10)||
'   if(''&P5450_STATUS_CHA';

ph:=ph||'NGE_DESC.'' == ''Migrate to Existing Source'')'||chr(10)||
'     {'||chr(10)||
'      window.parent.close();'||chr(10)||
'     }'||chr(10)||
'   else'||chr(10)||
'     {'||chr(10)||
'      if (cloning == 0 & open_new == false) '||chr(10)||
'        {'||chr(10)||
'         window.parent.doSubmit(''RELOAD'');'||chr(10)||
'        }'||chr(10)||
'     }'||chr(10)||
'    '||chr(10)||
'    if (cloning == 1 || open_new == true)'||chr(10)||
'      {'||chr(10)||
'       newWindow({page:''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'                  clear_cache:''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'         ';

ph:=ph||'         name:''&P5450_CLONE_NEW_SID.'', item_names:''P0_OBJ'', '||chr(10)||
'                  item_values:''&P5450_CLONE_NEW_SID.'', '||chr(10)||
'                  request:''OPEN''});'||chr(10)||
'      }'||chr(10)||
'   '||chr(10)||
'   if(''&P5450_STATUS_CHANGE_DESC.'' == ''Approve File'' & ''&P5450_OBJ_TYPE.'' == ''Case'')'||chr(10)||
'     {'||chr(10)||
'      //window.location = ''f?p=&APP_ID.:800:&SESSION.::::P800_REPORT_TYPE,P0_OBJ:&P5450_REPORT_TYPE.,&P0_OBJ.'';'||chr(10)||
'      window.open(''f?p=&APP_ID.';

ph:=ph||':800:&SESSION.::::P800_REPORT_TYPE,P0_OBJ:&P5450_REPORT_TYPE.,&P0_OBJ.'',''_blank'');'||chr(10)||
'      closeThis();'||chr(10)||
'     }'||chr(10)||
'   else '||chr(10)||
'     {'||chr(10)||
'      closeThis();'||chr(10)||
'     }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetSelectedSubjects(Request)'||chr(10)||
'{'||chr(10)||
' var selected = "";'||chr(10)||
''||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
''||chr(10)||
' var l_field_id = document.getElementById(''P5450_SUBJECTS_SELECTED''); '||chr(10)||
' '||chr(10)||
' if(l_field_id!=null)'||chr(10)||
'   {'||chr(10)||
'    for (var i = 0; i < nod';

ph:=ph||'e_list.length; i++) '||chr(10)||
'       {'||chr(10)||
'        var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'        if (node.getAttribute(''type'') == ''checkbox'') '||chr(10)||
'          {'||chr(10)||
'           if (node.checked==true)'||chr(10)||
'             {'||chr(10)||
'              selected = selected.concat(node.value,"~");'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'    l_field_id.value = selected;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if (Request!=undefined)'||chr(10)||
'   doSubmit(Request);'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<style>'||chr(10)||
''||chr(10)||
'#SubjectList'||chr(10)||
'  ';

ph:=ph||'       {'||chr(10)||
'          border: 3px ridge;'||chr(10)||
'          width: 95%;'||chr(10)||
'          font: 1em Courier New;'||chr(10)||
'          border-collapse: collapse;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#SubjectList td'||chr(10)||
'            {'||chr(10)||
'             height: 22px;'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'             border-bottom: 1px ridge;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'#evenRow'||chr(10)||
'         {'||chr(10)||
'          background: #fff;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#oddRow'||chr(10)||
'         {'||chr(10)||
'      ';

ph:=ph||'    background: #eee;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#HeaderColumn'||chr(10)||
'            {'||chr(10)||
'             border-bottom: 3px ridge;'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'             color:#fff;'||chr(10)||
'             text-align:center;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'#HeaderRow'||chr(10)||
'            {'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'             background: #4e7ec2;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'</style>';

wwv_flow_api.create_page(
  p_id     => 5450,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Status Change Widget',
  p_step_title=> 'Status Change Widget',
  p_step_sub_title => 'Status Change Widget',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="JavaScript" type="text/javascript">'||chr(10)||
'if (''&P5450_SHOW_CONFIRM.'' == ''Y''){'||chr(10)||
'    newWindow({page:''30135'', '||chr(10)||
'           clear_cache:''30135'', '||chr(10)||
'           name:''CONFIRM_'' + ''&P5450_CONFIRM_SESSION.'','||chr(10)||
'           item_names:''P30135_SC_SID,P30135_SESSION,P30135_CONFIRM_ALLOWED'', '||chr(10)||
'           item_values:''&P5450_STATUS_CHANGE_SID.,&P5450_CONFIRM_SESSION.,&P5450_CONFIRM_ALLOWED.'', '||chr(10)||
'           request:''OPEN''});'||chr(10)||
'javascript:closeThis();'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120508082524',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '11-MAY-2010  Jason Faris    Added conditional ''RPO Unit'' selector'||chr(10)||
'                            for Criminal Poly File Support.'||chr(10)||
''||chr(10)||
'04-JUN-2010  Tim McGuffin   Added audit logging of status changes.'||chr(10)||
''||chr(10)||
'01-JAN-2011  Jason Faris    An update was made to the javascript on P5450'||chr(10)||
'                            HTML Header to prevent a reload of the page in'||chr(10)||
'                            the case of a clone or Migrate Source action.'');'||chr(10)||
''||chr(10)||
'09-Jun-2011 - Tim Ward -    CR#3872 - Unarchiving requires unit to be entered,'||chr(10)||
'                             but excludes the current unit so it can be'||chr(10)||
'                             unarchived to the unit that owns it, only to '||chr(10)||
'                             another unit.'||chr(10)||
'                             Changed "Pre-Load Status Change Information" to '||chr(10)||
'                             default unit to current, if we are doing an'||chr(10)||
'                             "UNARCHIVE" and to not exclude the current unit '||chr(10)||
'                             at all for any status changes.'||chr(10)||
''||chr(10)||
'30-Jun-2011  Tim Ward       CR#3566 - Allow Picking of Subjects when '||chr(10)||
'                            Creating Case from Developmental.'||chr(10)||
'                            Added GetSelectedSubjects and CSS for the Subject'||chr(10)||
'                            listing HTML to the Page HTML Header.'||chr(10)||
'                            Added "Pick Subjects to Create Case" Region '||chr(10)||
'                            and Items.'||chr(10)||
'                            Changed "Update Object Status" page process to pass'||chr(10)||
'                            the list of subjects to OSI_STATUS_PROC functions.'||chr(10)||
'                            Changed the "SAVE_CONFIRM" button to call'||chr(10)||
'                            GetSelectedSubjects which also submits the page.'||chr(10)||
''||chr(10)||
'06-Jul-2011  Tim Ward       CR#3600 - Added ''Create DCII Indexing File'' checks'||chr(10)||
'                                      where there was a ''Create Case'' check.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery popup dialog.'||chr(10)||
''||chr(10)||
'04-Apr-2012 - Tim Ward - CR#3689 - Adding Right Click Menu to the Desktop.'||chr(10)||
''||chr(10)||
'10-Apr-2012 - Tim Ward - CR#4031 - When Cases are approved and the Letter'||chr(10)||
'                                    of Notification displays, sometimes'||chr(10)||
'                                    the status window stays and the page'||chr(10)||
'                                    under doesn''t refresh.  This can cause'||chr(10)||
'                                    multiple approvals.'||chr(10)||
'                                   Changed window.location to window.open '||chr(10)||
'                                     in the HTML Header.'||chr(10)||
''||chr(10)||
'13-Apr-2012 - Tim Ward - CR#4021 - Units can Assign their activities as '||chr(10)||
'                                    Leads to themselves.'||chr(10)||
''||chr(10)||
'08-May-2012 - Tim Ward - CR#4043 - Changed the way the popup closes, now'||chr(10)||
'                          it doesn''t have to refresh the underlying page.'||chr(10)||
''||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5450,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'DECLARE'||chr(10)||
'BEGIN'||chr(10)||
''||chr(10)||
'  :P5450_SUBJECT_HTML:=OSI_STATUS_PROC.GET_SUBJECT_SELECTION_HTML(:P0_OBJ);'||chr(10)||
'  htp.p(:p5450_subject_html || ''<script>GetSelectedSubjects();</script>'');'||chr(10)||
'   '||chr(10)||
'END;';

wwv_flow_api.create_page_plug (
  p_id=> 6558923278122600 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Pick Subjects to Create Case',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 23,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_STATUS_CHANGE_DESC in (''Create Case'',''Create DCII Indexing File'')',
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
  p_id=> 13476723894407034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Effective Date',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 27,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_DATE_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null'||chr(10)||
'and'||chr(10)||
':P5450_CHECKLIST_COMPLETE = ''Y''',
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
  p_id=> 90144213595465317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Comment',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
'(:P5450_NOTE_REQUIRED = ''O'' or :P5450_NOTE_REQUIRED = ''R'')'||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 90157609856244248 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Parameter Stuff',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
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
  p_id=> 90159622370276293 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Checklist Information',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
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
  p_plug_display_when_condition => ':P5450_PRE_PROCESS_CHECK is null',
  p_plug_footer=> '<script language="JavaScript" type="text/javascript">'||chr(10)||
'if ($v(''P5450_AUTHORIZED'')==''N''){'||chr(10)||
'   alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'   closeThis();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'</script>',
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
  p_id=> 90163324027371415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Confirmation - &P5450_STATUS_CHANGE_DESC.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 25,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 90589130294220195 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Unit Assignment',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 22,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_UNIT_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 91382720890965764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Access Verification - The following problems were found:',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_PRE_PROCESS_CHECK is not null',
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
  p_id=> 93419223048540671 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Item',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 90144619756465332 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 5,
  p_button_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_CHECKLIST',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="StatusCancel"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90162412683349201 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 10,
  p_button_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_NOTE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_cattributes=>'id="StatusCancel"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90144434019465328 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 20,
  p_button_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_NOTE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90164025805400273 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 30,
  p_button_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_CONFIRM',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_NOTE_REQUIRED = ''N'''||chr(10)||
'and'||chr(10)||
':P5450_DATE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="StatusCancel"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90164529053410734 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 40,
  p_button_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_CONFIRM',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:GetSelectedSubjects(''SAVE_CONFIRM'');',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_NOTE_REQUIRED = ''N'''||chr(10)||
'and'||chr(10)||
':P5450_DATE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91385514124200345 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 50,
  p_button_plug_id => 91382720890965764+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_PRE_PROCESS',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_cattributes=>'id="StatusCancel"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13478806935477865 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 70,
  p_button_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_DATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_NOTE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="StatusCancel"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13479011437479185 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 80,
  p_button_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_DATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5450_NOTE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16896902164612353 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 90,
  p_button_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_button_name    => 'SHOW_CHECKLIST',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Show Checklist',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>16897229522620264 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_branch_action=> 'f?p=&APP_ID.:5500:&SESSION.::&DEBUG.:5500:P5500_STATUS_CHANGE_SID,P0_OBJ:&P5450_STATUS_CHANGE_SID.,&P0_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>16896902164612353+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-OCT-2010 15:56 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>90145506390465349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_branch_action=> 'f?p=&APP_ID.:5450:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-MAY-2009 12:19 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3363806060047418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_AUTHORIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>3364312256096601 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_AUTH_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>3548722741431534 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CONFIRM_ALLOWED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>4856518545297114 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'begin'||chr(10)||
'  case '||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''FILE.POLY_FILE.CRIM'' '||chr(10)||
'           and :P5450_STATUS_CHANGE_DESC = ''Approve CrimPoly'' then'||chr(10)||
'          return ''RPO'';'||chr(10)||
'      when :P5450_STATUS_CHANGE_DESC = ''Unarchive'' then'||chr(10)||
'          return ''Unarchive to Unit'';'||chr(10)||
'      else'||chr(10)||
'          return ''Unit'';'||chr(10)||
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
  p_id=>4908906244006206 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_RPO_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5450_UNIT_LABEL.',
  p_post_element_text=>'<a href="javascript:openLocator(''301'',''P5450_UNIT_SID'',''N'',''&P5450_UNIT_EXCLUDE.'',''OPEN'','''','''',''&P5450_UNIT_LABEL....'',''UNITS_RPO'',''&P0_OBJ.'');">&ICON_LOCATOR.</a>'||chr(10)||
'',
  p_source=>'OSI_UNIT.GET_NAME(:P5450_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED',
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
  p_display_when=>':P5450_STATUS_CHANGE_DESC in(''Approve CrimPoly'',''Approve SecPoly'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'',item_values:''OSI.LOC.UNIT,P5450_UNIT_SID,&P5450_UNIT_EXCLUDE.''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5507305410048631 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NEW_NOTE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Note Sid',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>5901314800310025 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SHOW_CONFIRM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>6040419886165925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CONFIRM_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>6560916238380749 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SUBJECT_HTML',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 280,
  p_item_plug_id => 6558923278122600+wwv_flow_api.g_id_offset,
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
  p_id=>6567910668202368 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SUBJECTS_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 290,
  p_item_plug_id => 6558923278122600+wwv_flow_api.g_id_offset,
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
  p_id=>6573418211649242 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SUBJECT_CHECKBOX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 6558923278122600+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Test Checkbox',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
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
  p_id=>7430418540040818 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SOURCE_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>8018030643299712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_REPORT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Report Type',
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
  p_id=>8018429867318396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_OBJ_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select ot.description'||chr(10)||
'from t_core_obj o, t_core_obj_type ot'||chr(10)||
'where o.sid = :p0_obj'||chr(10)||
'and o.obj_type = ot.sid',
  p_source_type=> 'QUERY',
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
  p_id=>13477209827412426 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_DATE_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_DATE_REQUIRED',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>13480306635506175 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_EFFECTIVE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Effective Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
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
  p_id=>90144832022465332 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NOTE_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Text',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 90,
  p_cMaxlength=> 32000,
  p_cHeight=> 15,
  p_cAttributes=> 'nowrap',
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
  p_id=>90157129680231087 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_STATUS_CHANGE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Change Sid',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>90158020592247382 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_CHECKLIST_COMPLETE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
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
  p_id=>90158228211249582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CUSTOM_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
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
  p_id=>90158434098251281 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NOTE_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Required',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>90160106571281224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE_DISPLAY_YES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'<img src="#IMAGE_PREFIX#themes/OSI/success_w.gif"/> Checklist Complete - You may proceed.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_CHECKLIST_COMPLETE = ''Y''',
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
  p_id=>90161335446299020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE_MESSAGE_NO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'<img src="#IMAGE_PREFIX#themes/OSI/fail.gif"/> Checklist Not Complete - Please complete the checklist.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_CHECKLIST_COMPLETE = ''N''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<img src="#IMAGE_PREFIX#themes/OSI/fail.gif"/><a href="javascript:runChecklist(''&P0_OBJ.'',''&P5450_STATUS_CHANGE_SID.'')">Checklist Not Complete - Please complete the checklist.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90171008462518299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_COMMENT_MSG_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<label tabindex="999" class="requiredlabel">A comment for this action is REQUIRED.</label>',
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
  p_display_when=>':P5450_NOTE_REQUIRED = ''R''',
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
  p_id=>90172010801537865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_COMMENT_MSG_OPTIONAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'A comment for this action is OPTIONAL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_NOTE_REQUIRED = ''O''',
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
  p_id=>90589834783239292 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5450_UNIT_LABEL.',
  p_post_element_text=>'<a href="javascript:openLocator(''301'',''P5450_UNIT_SID'',''N'',''&P5450_UNIT_EXCLUDE.'',''OPEN'','''','''',''&P5450_UNIT_LABEL....'',''UNITS'',''&P0_OBJ.'');" style="vertical-align:bottom; padding-left:2px;">&ICON_LOCATOR.</a>',
  p_source=>'OSI_UNIT.GET_NAME(:P5450_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED',
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
  p_display_when=>':P5450_STATUS_CHANGE_DESC not in(''Approve CrimPoly'',''Approve SecPoly'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'',item_values:''OSI.LOC.UNIT,P5450_UNIT_SID,&P5450_UNIT_EXCLUDE.''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90591207684239295 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_UNIT_SID',
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
  p_id=>90593917405311145 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Required',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>90660322917367023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_EXCLUDE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Exclude',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>90706932143254204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Done',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>90708210073304640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_ERROR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'THERE HAS BEEN A SYSTEM ERROR WHEN CHANGING STATUS.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_DONE = ''N''',
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
  p_id=>90856123722438759 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_STATUS_CHANGE_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Change Desc',
  p_source=>'osi_status.get_status_change_desc(:P5450_STATUS_CHANGE_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
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
  p_id=>90933536158383762 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CLONE_PAGE_TO_LAUNCH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'none',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Clone Page To Launch',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>90933823822389589 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CLONE_NEW_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'none',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Clone New Sid',
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
  p_id=>91372833134852682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_TEXT_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Text Required',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>91374906750015454 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Reason',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_UNIT_TEXT_REQUIRED = ''Y''',
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
  p_id=>91383036128970142 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_PRE_PROCESS_CHECK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_PRE_PROCESS_CHECK',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>91384721649145767 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_PRE_PROCESS_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 91382720890965764+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5450_PRE_PROCESS_CHECK',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXTAREA-AUTO-HEIGHT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'readOnly',
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
  p_id=>93419618677548935 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 93419223048540671+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_obj.get_tagline(:P0_obj)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90595124294360435 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'UNIT must not be null',
  p_validation_sequence=> 5,
  p_validation => 'P5450_UNIT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit must be selected.',
  p_validation_condition=> ':P5450_UNIT_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':request not in (''P5450_UNIT_SID'', ''SHOW_CHECKLIST'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 90589834783239292 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90145121301465340 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'NOTE_TEXT must not be null',
  p_validation_sequence=> 10,
  p_validation => 'P5450_NOTE_TEXT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Note Text must be filled in.',
  p_validation_condition=> ':P5450_NOTE_REQUIRED = ''R'''||chr(10)||
'and'||chr(10)||
':request not in (''P5450_UNIT_SID'', ''SHOW_CHECKLIST'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 90144832022465332 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 14120623560758929 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'Effective Date cannot be more than 2 days in advance',
  p_validation_sequence=> 30,
  p_validation => 'begin'||chr(10)||
'    if (:p5450_date_required = ''Y'' and :p5450_effective_date is not null) then'||chr(10)||
'        if (:p5450_effective_date > trunc(sysdate) +2) then'||chr(10)||
'            return ''Effective date cannot be more than 2 days ahead.'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => '',
  p_validation_condition=> ':REQUEST like ''SAVE%''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13480306635506175 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12883201097074192 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'Creating Unit cannot be selected as the assigned unit',
  p_validation_sequence=> 40,
  p_validation => 'DECLARE'||chr(10)||
''||chr(10)||
'       v_Creating_Unit varchar2(20);'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'     select creating_unit into v_Creating_Unit'||chr(10)||
'        from t_osi_activity where sid=:p0_obj;'||chr(10)||
''||chr(10)||
'     if (:P5450_UNIT_SID=v_Creating_Unit) then'||chr(10)||
''||chr(10)||
'       return false;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'    return true;'||chr(10)||
'END;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The Creating unit cannot be selected as the assigned unit.',
  p_validation_condition=> 'P5450_STATUS_CHANGE_DESC',
  p_validation_condition2=> 'Assign Auxiliary Unit',
  p_validation_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_when_button_pressed=> 90164529053410734 + wwv_flow_api.g_id_offset,
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
'  v_parameter1   varchar2(500)  := null;'||chr(10)||
'  v_parameter2   varchar2(4000) := null;'||chr(10)||
'  v_temp         t_osi_note.sid%type;'||chr(10)||
'  v_result       varchar2(32767) := null;'||chr(10)||
'  v_log_msg      varchar2(500);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  v_log_msg := ''Lifecycle:'' || :p0_obj || ''-'' || :p5450_status_change_desc;'||chr(10)||
''||chr(10)||
'  --- Grab Unit into Parameter1 if nessecary ---'||chr(10)||
'  if (:p5450_unit_required = ''Y'') then'||chr(10)||
''||chr(10)||
'    v_parameter1 := :p545';

p:=p||'0_unit_sid;'||chr(10)||
'    v_log_msg := v_log_msg || ''-'' || v_parameter1;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  log_info(v_log_msg);'||chr(10)||
''||chr(10)||
'  --- Grab Unit Text into Parameter2 if nessecary ---'||chr(10)||
'  --- TJW - 10-Jan-2011 added the Replace to get by a problem where Apostrophes in the Text Cause Oracle Errors ---'||chr(10)||
'  if (:p5450_unit_text_required = ''Y'') then'||chr(10)||
''||chr(10)||
'    v_parameter2 := replace(:p5450_unit_text,'''''''','''''''''''');'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if (:p5450_st';

p:=p||'atus_change_desc in (''Create Case'',''Create DCII Indexing File'')) then'||chr(10)||
''||chr(10)||
'    v_parameter1 := :p5450_Subjects_Selected;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
''||chr(10)||
'  osi_status.change_status(:p0_obj, :p5450_status_change_sid, v_parameter1, v_parameter2, :P5450_EFFECTIVE_DATE);'||chr(10)||
''||chr(10)||
'  if (:p5450_note_text is not null) then'||chr(10)||
''||chr(10)||
'    :P5450_NEW_NOTE_SID := osi_note.add_note(:p0_obj, osi_status.get_required_note_type(:p5450_status_change_sid)';

p:=p||', :p5450_note_text);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if (:p5450_status_change_desc in (''Clone Activity'',''Create Case'',''Create DCII Indexing File'')) then'||chr(10)||
''||chr(10)||
'    --- Put the cloned sid in the page if it exists. ---'||chr(10)||
'    :p5450_clone_new_sid := osi_status_proc.get_cloned_sid;'||chr(10)||
'        '||chr(10)||
'    select page_num into :p5450_clone_page_to_launch'||chr(10)||
'      from t_core_dt_obj_type_page'||chr(10)||
'     where obj_type member of osi_object.get_objty';

p:=p||'pes(:p5450_clone_new_sid)'||chr(10)||
'       and page_function = ''OPEN'';'||chr(10)||
'     --where obj_type = core_obj.get_objtype(:p5450_clone_new_sid);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'    '||chr(10)||
'  if(:p5450_status_change_desc = ''Migrate to Existing Source'') then'||chr(10)||
' '||chr(10)||
'   :p5450_clone_new_sid := osi_status_proc.get_cloned_sid;'||chr(10)||
'   :P5450_source_id := osi_source.get_id(:p5450_clone_new_sid);'||chr(10)||
'        '||chr(10)||
'   select page_num into :p5450_clone_page_to_launch'||chr(10)||
' ';

p:=p||'     from t_core_dt_obj_type_page'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:p5450_clone_new_sid)'||chr(10)||
'       and page_function = ''OPEN'';'||chr(10)||
'        '||chr(10)||
'    delete from t_core_obj where sid = :p0_obj;'||chr(10)||
'    :p0_obj := :p5450_clone_new_sid;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if(:p5450_status_change_desc = ''Approve File'' and :p5450_obj_type = ''Case'')then     '||chr(10)||
'      '||chr(10)||
'    select sid into :p5450_report_type'||chr(10)||
'     from t_osi_';

p:=p||'report_type'||chr(10)||
'      where description = ''Letter of Notification'''||chr(10)||
'        and obj_type = core_obj.lookup_objtype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'    :debug := :p5450_report_type;'||chr(10)||
'  '||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  :p5450_done := ''Y'';'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
''||chr(10)||
'  when others then'||chr(10)||
'      :p5450_done := ''N'';'||chr(10)||
'      raise;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90145220571465348 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Object Status',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE_CONFIRM,SAVE_NOTE,SAVE_DATE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
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
p:=p||'declare'||chr(10)||
'    v_temp   varchar2(20);'||chr(10)||
'begin'||chr(10)||
'    if (:p0_obj_type_code = ''FILE.AAPP'') then'||chr(10)||
'        if (:P5450_STATUS_CHANGE_DESC like ''%Recall%'') then'||chr(10)||
'             osi_aapp_file.update_recall_note(:P5450_NEW_NOTE_SID);'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5486532760930489 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Special Processing on Note',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SAVE_CONFIRM,SAVE_NOTE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'  v_ok                  varchar2(1);'||chr(10)||
'  v_possible_dupes      number;'||chr(10)||
'  v_status_change_sid   varchar2(40);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     --- Check for Right-Click Menu Clone ---'||chr(10)||
'     if (:p5450_status_change_sid = ''CloneIt'') then'||chr(10)||
''||chr(10)||
'       :P5450_STATUS_CHANGE_DESC := ''Clone'';'||chr(10)||
'       begin'||chr(10)||
'            SELECT c.SID into :p5450_status_change_sid'||chr(10)||
'                  FROM T_CORE_OBJ o,T_CORE_OBJ_TYPE t,T_OSI_STATU';

p:=p||'S_CHANGE c'||chr(10)||
'                  WHERE o.SID=:p0_obj'||chr(10)||
'                    AND o.obj_type=t.SID '||chr(10)||
'                    AND c.OBJ_TYPE MEMBER OF Osi_Object.get_objtypes(:p0_obj)'||chr(10)||
'                    AND button_label=''Clone Activity'';'||chr(10)||
'       exception when others then'||chr(10)||
''||chr(10)||
'                :p5450_authorized := ''N'';'||chr(10)||
'                :p5450_status_change_sid := Null;'||chr(10)||
'       end;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'  :p5450_checklist_com';

p:=p||'plete := osi_checklist.checklist_complete(:p0_obj, :p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  begin'||chr(10)||
'       select aa.code into :p5450_auth_action'||chr(10)||
'        from t_osi_status_change sc, '||chr(10)||
'             t_osi_auth_action_type aa'||chr(10)||
'        where sc.sid = :p5450_status_change_sid'||chr(10)||
'          and aa.sid(+) = sc.auth_action;'||chr(10)||
'  exception when no_data_found then'||chr(10)||
''||chr(10)||
'           :p5450_auth_action := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'  if :p5450_auth';

p:=p||'_action is not null then'||chr(10)||
''||chr(10)||
'    :p5450_authorized := osi_auth.check_for_priv(:p5450_auth_action,'||chr(10)||
'                                                 core_obj.get_objtype(:p0_obj));    '||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    :p5450_authorized := ''Y'';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  --For some reason, note_required does not always re-fill in correctly.'||chr(10)||
'  :p5450_note_required := osi_status.note_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
'  :';

p:=p||'p5450_unit_required := osi_status.unit_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
'  :P5450_unit_text_required := osi_status.unit_text_required_on_statchng(:P5450_status_change_sid);'||chr(10)||
'  :p5450_custom_message := osi_status.get_confirm_message(:p5450_status_change_sid, :P0_OBJ);'||chr(10)||
'  :status_stat_change_sid := v_status_change_sid;'||chr(10)||
'  :p5450_date_required := osi_status.date_is_required_on_stat_chn';

p:=p||'g(:p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  --Unit Exclusion'||chr(10)||
'  --:p5450_unit_exclude := osi_object.get_assigned_unit(:P0_OBJ);'||chr(10)||
'  --:p5450_unit_exclude := osi_personnel.get_current_unit(core_context.personnel_sid);'||chr(10)||
'  '||chr(10)||
'  if :P5450_AUTH_ACTION = ''UNARCHIVE'' and :P5450_UNIT_SID is null then'||chr(10)||
''||chr(10)||
'    :P5450_UNIT_SID := osi_object.get_assigned_unit(:P0_OBJ);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  :P5450_pre_process_check := osi_status.run_pre_';

p:=p||'processing(:p0_obj, :p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  if(:p5450_checklist_complete = ''Y'' and :p0_obj_type_code = ''PART.INDIV'')then'||chr(10)||
''||chr(10)||
'     v_ok := osi_participant.check_for_duplicates(:p0_obj);'||chr(10)||
''||chr(10)||
'     :P5450_CONFIRM_ALLOWED := v_ok;'||chr(10)||
''||chr(10)||
'     --if(:p5450_auth_action = ''CONFIRM'' and v_ok = ''N'')then'||chr(10)||
'     if :p5450_auth_action = ''CONFIRM'' then'||chr(10)||
''||chr(10)||
'       :p5450_confirm_session := osi_participant.get_confirm_sessio';

p:=p||'n;'||chr(10)||
''||chr(10)||
'       select count(*) into v_possible_dupes'||chr(10)||
'        from v_osi_partic_search_result'||chr(10)||
'         where session_id = :p5450_confirm_session;'||chr(10)||
'       '||chr(10)||
'      if v_possible_dupes <= 0 then'||chr(10)||
''||chr(10)||
'        :p5450_show_confirm := ''N'';'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'        :p5450_show_confirm := ''Y'';'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       :p5450_show_confirm := ''N'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90158607694262545 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Pre-Load Status Change Information',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 5450
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
--   Date and Time:   08:22 Tuesday May 8, 2012
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

PROMPT ...Remove page 5500
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5500);
 
end;
/

 
--application/pages/page_05500
prompt  ...PAGE 5500: Checklist Widget - &P0_OBJ_ID.
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
'if (''&P5500_DONE.'' == ''Y'')'||chr(10)||
'{'||chr(10)||
' closeThis();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function closeThis()'||chr(10)||
'{'||chr(10)||
' parent.$(''#JQueryPopWin'', window.parent.document).dialog(''close'');'||chr(10)||
' parent.$(''#JQueryPopWin'', window.parent.document).remove();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 5500,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Checklist Widget - &P0_OBJ_ID.',
  p_step_title=> '&P5500_CHECKLIST_NAME. &P5500_CHECKLIST_COMPLETE. - &P5500_OBJ_ID.',
  p_step_sub_title => 'Checklist Widget',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120508082220',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '21-Jun-2011 Tim Ward CR#3894 Fixing "value error: character string buffer too'||chr(10)||
'                             small" error during Case Closure Checklist.'||chr(10)||
'                             Added i2ms_desktop.js to HTML Header so we can use'||chr(10)||
'                             getObjURL javascript function.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.'||chr(10)||
''||chr(10)||
'08-May-2012 - Tim Ward - CR#4043 - Changed the way the popup closes, now'||chr(10)||
'                          it doesn''t have to refresh the underlying page.'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5500,p_text=>ph);
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
  p_id=> 92486935665569182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5500,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
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
  p_id=> 92645227954056989 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5500,
  p_plug_name=> 'Automated Checks',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 11,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5500_AUTOMATED_CHECKS_F_SRC_1 is not null'||chr(10)||
'or'||chr(10)||
':P5500_AUTOMATED_CHECKS_P_SRC_1 is not null'||chr(10)||
'or'||chr(10)||
':P5500_AUTOMATED_CHECKS_D_SRC_1 is not null'||chr(10)||
'or'||chr(10)||
'(:P5500_CHECKLIST_COMPLETE = ''(COMPLETE)'' and :P5500_SOFT_CHECKS_EXIST = ''N'')',
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
  p_id=> 93036811333978115 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5500,
  p_plug_name=> 'Self Checks',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 21,
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
  p_plug_display_when_condition => ':P5500_SOFT_CHECKS_EXIST = ''Y''',
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
  p_id=> 93419733915553256 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5500,
  p_plug_name=> 'Checklist - &P5500_STATUS_CHANGE_DESC.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 93028023428404370 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5500,
  p_button_sequence=> 10,
  p_button_plug_id => 93036811333978115+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Ok',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 93138829992599699 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5500,
  p_button_sequence=> 20,
  p_button_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_button_name    => 'Ok',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Ok',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5500_SOFT_CHECKS_EXIST = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 93386014767014940 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5500,
  p_button_sequence=> 30,
  p_button_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_button_name    => 'REFRESH',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Refresh',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5500_SOFT_CHECKS_EXIST = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 93386433121020198 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5500,
  p_button_sequence=> 40,
  p_button_plug_id => 93036811333978115+wwv_flow_api.g_id_offset,
  p_button_name    => 'REFRESH',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Refresh',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16369720283217762 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5500,
  p_button_sequence=> 50,
  p_button_plug_id => 93419733915553256+wwv_flow_api.g_id_offset,
  p_button_name    => 'DETAILS_SHOW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Details',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> '(:p5500_details_show = ''N'' or :p5500_details_show is null)'||chr(10)||
'and'||chr(10)||
':P5500_DETAILS_EXIST = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16369928594220207 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5500,
  p_button_sequence=> 60,
  p_button_plug_id => 93419733915553256+wwv_flow_api.g_id_offset,
  p_button_name    => 'DETAILS_HIDE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Checklist',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':p5500_details_show = ''Y'''||chr(10)||
'and'||chr(10)||
':P5500_DETAILS_EXIST = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>93386333803014945 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_branch_action=> 'f?p=&APP_ID.:5500:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P5500_P0_OBJ_PLACEHOLDER.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>93386014767014940+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>92493815277569196 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_branch_action=> 'f?p=&APP_ID.:5500:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-MAY-2009 12:19 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16370211064224525 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_DETAILS_SHOW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 93419733915553256+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_DETAILS_SHOW',
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
  p_id=>16371430288267964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_SELF_CHECK_SAVE_STATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 93036811333978115+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_SELF_CHECK_SAVE_STATE',
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
  p_id=>16444814346006042 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_P_SRC_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 165.1,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_AUTOMATED_CHECKS_P_SRC_1',
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
  p_id=>16670713393449959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_SELF_CHECKS_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150.3,
  p_item_plug_id => 93036811333978115+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_SELF_CHECKS_SOURCE',
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
  p_id=>16772425931577828 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_DETAILS_EXIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 93419733915553256+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_DETAILS_EXIST',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>16775228420758259 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_P_SRC_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 167.1,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_AUTOMATED_CHECKS_P_SRC_2',
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
  p_id=>16775614006763573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_P_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 167.2,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5500_AUTOMATED_CHECKS_P_SRC_2',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5500_AUTOMATED_CHECKS_P_SRC_2 is not null',
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
  p_id=>16796013716217723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_F_SRC_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150.1,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_AUTOMATED_CHECKS_P_SRC_1',
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
  p_id=>16796623412220479 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_F_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150.2,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5500_AUTOMATED_CHECKS_F_SRC_1',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5500_AUTOMATED_CHECKS_F_SRC_1 is not null',
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
  p_id=>16796831031222678 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_F_SRC_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160.1,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_AUTOMATED_CHECKS_F_SRC_2',
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
  p_id=>16797203458224207 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_F_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160.2,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5500_AUTOMATED_CHECKS_F_SRC_2',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5500_AUTOMATED_CHECKS_F_SRC_2 is not null',
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
  p_id=>16797410384226193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_D_SRC_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170.1,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_AUTOMATED_CHECKS_D_SRC_1',
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
  p_id=>16797716963228071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_D_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170.2,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5500_AUTOMATED_CHECKS_D_SRC_1',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5500_AUTOMATED_CHECKS_D_SRC_1 is not null',
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
  p_id=>16797922851229803 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_D_SRC_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180.1,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_AUTOMATED_CHECKS_D_SRC_2',
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
  p_id=>16798301857233232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_D_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180.2,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5500_AUTOMATED_CHECKS_D_SRC_2',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5500_AUTOMATED_CHECKS_D_SRC_2 is not null',
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
  p_id=>18872628518710967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 93419733915553256+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Also show',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Completed Items;PASS,Items that Do Not Apply (Click Refresh after making selections);DNA',
  p_lov_columns=> 2,
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
  p_id=>18884617361152398 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_NOTE_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 93419733915553256+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note',
  p_source=>'"Completed" and "Do Not Apply" checklist items may not exist for the current checklist.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_id=>18918415731702434 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 92486935665569182+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_OBJ',
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
  p_id=>92489135298569187 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 92486935665569182+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_DONE',
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
  p_id=>92489732532569189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_STATUS_CHANGE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 92486935665569182+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_STATUS_CHANGE_SID',
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
  p_id=>92491914260569192 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_STATUS_CHANGE_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 92486935665569182+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_STATUS_CHANGE_DESC',
  p_source=>'osi_status.get_status_change_desc(:P5500_STATUS_CHANGE_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
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
  p_id=>92645524622065424 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_AUTOMATED_CHECKS_P_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 165.2,
  p_item_plug_id => 92645227954056989+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5500_AUTOMATED_CHECKS_P_SRC_1',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5500_AUTOMATED_CHECKS_P_SRC_1 is not null',
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
  p_id=>93037229436040046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_SELF_CHECKS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 93036811333978115+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC:&P5500_SELF_CHECKS_SOURCE.',
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
  p_id=>93139728008655820 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_SOFT_CHECKS_EXIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 92486935665569182+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_SOFT_CHECKS_EXIST',
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
  p_id=>93420025654553262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 93419733915553256+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_obj.get_tagline(:P5500_obj)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_id=>97825330668602807 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_CHECKLIST_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 92486935665569182+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_CHECKLIST_NAME',
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
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97838525969112489 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5500,
  p_name=>'P5500_CHECKLIST_COMPLETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 215,
  p_item_plug_id => 92486935665569182+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5500_CHECKLIST_COMPLETE',
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
  p_label_alignment  => 'LEFT-CENTER',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
p:=p||'declare'||chr(10)||
'    v_array    apex_application_global.vc_arr2;'||chr(10)||
'    v_string   varchar2(4000);'||chr(10)||
'begin'||chr(10)||
'    v_array := apex_util.string_to_table(:p5500_self_checks, '':'');'||chr(10)||
''||chr(10)||
'    delete from t_osi_checklist_item'||chr(10)||
'          where obj = :p5500_obj and status_change_sid = :p5500_status_change_sid;'||chr(10)||
''||chr(10)||
'    for i in 1 .. v_array.count'||chr(10)||
'    loop'||chr(10)||
'        insert into t_osi_checklist_item'||chr(10)||
'                    (obj, checklist_';

p:=p||'item_type_sid, status_change_sid)'||chr(10)||
'            select :p5500_obj, v_array(i), :p5500_status_change_sid'||chr(10)||
'              from dual'||chr(10)||
'             where not exists('||chr(10)||
'                       select 1'||chr(10)||
'                         from t_osi_checklist_item'||chr(10)||
'                        where obj = :p5500_obj'||chr(10)||
'                          and checklist_item_type_sid = v_array(i)'||chr(10)||
'                          and status_change_si';

p:=p||'d = :p5500_status_change_sid);'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    :p5500_done := ''Y'';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 93060637754818385 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5500,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Self Checks',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>93028023428404370 + wwv_flow_api.g_id_offset,
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
'    if (:request = ''DETAILS_SHOW'') then'||chr(10)||
'        :p5500_details_show := ''Y'';'||chr(10)||
'    elsif(:request = ''DETAILS_HIDE'') then'||chr(10)||
'        :p5500_details_show := ''N'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p5500_self_check_save_state := :p5500_self_checks;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 16370326301228995 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5500,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Hide / Show Details',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''DETAILS_SHOW'',''DETAILS_HIDE'')',
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
'    if (:p5500_obj is null) then'||chr(10)||
'        :p5500_obj := :p0_obj;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p5500_soft_checks_exist := osi_checklist.soft_checks_exist(:p5500_obj,'||chr(10)||
'                                                                :p5500_status_change_sid);'||chr(10)||
''||chr(10)||
'    --:p5500_status_change_desc := osi_status.get_status_change_desc(:p5500_status_change_sid);'||chr(10)||
''||chr(10)||
'    --Get the checklist title'||chr(10)||
'    select checklist_b';

p:=p||'utton_label'||chr(10)||
'      into :p5500_checklist_name'||chr(10)||
'      from t_osi_status_change'||chr(10)||
'     where sid = :p5500_status_change_sid;'||chr(10)||
''||chr(10)||
'    --Determine if checklist is complete or not'||chr(10)||
'    if (osi_checklist.checklist_complete(:p5500_obj, :p5500_status_change_sid) = ''Y'') then'||chr(10)||
'        :p5500_checklist_complete := ''(COMPLETE)'';'||chr(10)||
'    else'||chr(10)||
'        :p5500_checklist_complete := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Details Available?'||chr(10)||
'';

p:=p||'    :p5500_details_exist :='||chr(10)||
'                        osi_checklist.details_exist_for_this_cl(:p5500_obj,'||chr(10)||
'                                                                :p5500_status_change_sid);'||chr(10)||
''||chr(10)||
'    --Auto Source'||chr(10)||
'    if (:p5500_details_show = ''Y'') then'||chr(10)||
'        osi_checklist.get_checklist_auto_output(:p5500_obj,'||chr(10)||
'                                                :p5500_status_change_sid,'||chr(10)||
'            ';

p:=p||'                                    :p5500_automated_checks_p_src_1,'||chr(10)||
'                                                :p5500_automated_checks_p_src_2,'||chr(10)||
'                                                :p5500_automated_checks_f_src_1,'||chr(10)||
'                                                :p5500_automated_checks_f_src_2,'||chr(10)||
'                                                :p5500_automated_checks_d_src_1,'||chr(10)||
'       ';

p:=p||'                                         :p5500_automated_checks_d_src_2,'||chr(10)||
'                                                ''Y'','||chr(10)||
'                                                :p5500_filter);'||chr(10)||
'    elsif(   :p5500_details_show = ''N'''||chr(10)||
'          or :p5500_details_show is null) then'||chr(10)||
'        osi_checklist.get_checklist_auto_output(:p5500_obj,'||chr(10)||
'                                                :p5500_status_c';

p:=p||'hange_sid,'||chr(10)||
'                                                :p5500_automated_checks_p_src_1,'||chr(10)||
'                                                :p5500_automated_checks_p_src_2,'||chr(10)||
'                                                :p5500_automated_checks_f_src_1,'||chr(10)||
'                                                :p5500_automated_checks_f_src_2,'||chr(10)||
'                                                :p5500_automated_';

p:=p||'checks_d_src_1,'||chr(10)||
'                                                :p5500_automated_checks_d_src_2,'||chr(10)||
'                                                ''N'','||chr(10)||
'                                                :p5500_filter);'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Self Source'||chr(10)||
'    if (:p5500_details_show = ''Y'') then'||chr(10)||
'        :p5500_self_checks_source :='||chr(10)||
'                  osi_checklist.get_checklist_self_output(:p5500_obj, :p5500_s';

p:=p||'tatus_change_sid,'||chr(10)||
'                                                          ''Y'');'||chr(10)||
'    elsif(   :p5500_details_show = ''N'''||chr(10)||
'          or :p5500_details_show is null) then'||chr(10)||
'        :p5500_self_checks_source :='||chr(10)||
'                  osi_checklist.get_checklist_self_output(:p5500_obj, :p5500_status_change_sid,'||chr(10)||
'                                                          ''N'');'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 93139914980661576 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5500,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload Page Parameters',
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
'    if (:request in(''DETAILS_SHOW'', ''DETAILS_HIDE'')) then'||chr(10)||
'        --If they are changing from Details to Checklist or Vice Versa, then need to rpeserve anything they have checked.'||chr(10)||
'        :p5500_self_checks := :p5500_self_check_save_state;'||chr(10)||
'    else'||chr(10)||
'        --On initial load, or Refresh, we need to get checked items from database.'||chr(10)||
'        :p5500_self_checks :='||chr(10)||
'                          osi_ch';

p:=p||'ecklist.get_soft_checked_items(:p5500_obj,'||chr(10)||
'                                                               :p5500_status_change_sid);'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 16371801114278496 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5500,
  p_process_sequence=> 30,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preserve Self Check State',
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
 
---------------------------------------
-- ...updatable report columns for page 5500
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

