set define off
set verify off
set serveroutput on size 1000000
set feedback off
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   08:19 Friday March 18, 2011
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
  p_list_item_link_target=> 'javascript:popupLocator(350,''P30505_CLAIMANT'',''N'');',
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
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   08:28 Friday March 18, 2011
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

PROMPT ...Remove page 30505
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30505);
 
end;
/

 
--application/pages/page_30505
prompt  ...PAGE 30505: CFunds Expense
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_LOCATOR"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'function popupCommentsWindow(){'||chr(10)||
'  var wdth = 655;'||chr(10)||
'  var hght = 425;'||chr(10)||
'  var lft = (screen.width-wdth)/2;'||chr(10)||
'  var topp = (screen.height-hght)/2;'||chr(10)||
''||chr(10)||
'  javascript:popup({page:30510,name:''DISALLOW_COMMENT'',clear_cache:''30510'', '||chr(10)||
'    item_names:''P30510_FROM_OBJ,P30510_FROM_ITEM'',item_values:''&P30505_SID., P30505_DISALLOW_COMMENT'','||chr(10)||
'    width:wdth,height:hght,l';

ph:=ph||'eft:lft,top:topp});'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function popupCoverSheet(){'||chr(10)||
'  var wdth = 720;'||chr(10)||
'  var hght = 750;'||chr(10)||
'  var lft = (screen.width-wdth)/2;'||chr(10)||
'  var topp = (screen.height-hght)/2;'||chr(10)||
''||chr(10)||
'  javascript:popup({page:30515,name:''EXPENSE_COVER_SHEET'',clear_cache:''30515'','||chr(10)||
'    item_names:''P30515_SID'',item_values:''&P30505_SID.'','||chr(10)||
'    width:wdth,height:hght,left:lft,top:topp});'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30505,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'CFunds Expense',
  p_step_title=> '&P30505_PAGE_TITLE.',
  p_html_page_onload=>'onload=" '||chr(10)||
'if (''&REQUEST.'' == ''ALL_DONE'')'||chr(10)||
'   {'||chr(10)||
'    window.opener.doSubmit();'||chr(10)||
'   }'||chr(10)||
'"'||chr(10)||
'',
  p_step_sub_title => 'CFunds Expense',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215462100554475+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110318082810',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '02-Mar-2011 - TJW - CR#3723 Showing wrong Paragraph #.'||chr(10)||
'                    CR#3712 Unit Locator is showing all Units.'||chr(10)||
'                    CR#3712 Default Unit Locator.'||chr(10)||
'                    CR#3709/3716 - Fixed Context and added View Associated '||chr(10)||
'                                   Activity and Source Buttons.'||chr(10)||
'                    CR#3705 - Changed page to use the Reports menu.'||chr(10)||
''||chr(10)||
'18-Mar-2011 - TJW - CR#3731 - Make sure Actions Menu shows if Delete'||chr(10)||
'                              is allowed.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30505,p_text=>ph);
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
  p_id=> 90761918570048646 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30505,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
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
  p_plug_display_condition_type => 'NEVER',
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
  p_id=> 90762109577048651 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30505,
  p_plug_name=> 'CFunds Expense',
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
  p_id=> 98004408863435026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30505,
  p_plug_name=> '&P30505_ACTION_REG_TITLE.',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .01,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'N',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 94144411250930206 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30505,
  p_button_sequence=> 10,
  p_button_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30505_SID is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90869710748898728 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30505,
  p_button_sequence=> 30,
  p_button_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30505_SID is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91180530973552404 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30505,
  p_button_sequence=> 40,
  p_button_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.opener.doSubmit();window.close();',
  p_button_condition=> 'P30505_SID',
  p_button_condition_type=> 'NEVER',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 98615937524208439 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30505,
  p_button_sequence=> 45,
  p_button_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_button_condition=> 'P30505_SID',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>21758410282554304 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_branch_action=> 'f?p=&APP_ID.:30505:&SESSION.:ALL_DONE:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_IN_CONDITION',
  p_branch_condition=> 'CREATE,SAVE',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 24-JAN-2011 14:04 by JASON');
 
wwv_flow_api.create_page_branch(
  p_id=>90764813826048681 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_branch_action=> 'f?p=&APP_ID.:30505:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 12:01 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4959323666256512 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_ACTION_VISIBLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 255,
  p_item_plug_id => 90761918570048646+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Action Visible',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4969330654256678 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_VIEW_ASSOC_ACTIVITY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 299,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Associated Activity" href="'''||chr(10)||
'|| osi_object.get_object_url(:P30505_PARENT)'||chr(10)||
'||''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>'P30505_PARENT',
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
  p_id=>4969509315260003 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_ASSOC_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 301,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Associated Source" href="'''||chr(10)||
'|| osi_object.get_object_url(:P30505_SOURCESID)'||chr(10)||
'||''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>'P30505_SOURCESID',
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
  p_id=>4973806160306391 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_SOURCESID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 319,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sourcesid',
  p_source=>'SOURCESID',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>90762721428048657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 289,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Expense Status',
  p_source=>'STATUS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>90762938567048657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_EXPENSE_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 290,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Expense ID',
  p_source=>'VOUCHER_NO',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>90763136177048657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_CHARGE_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 291,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Charged with Expense',
  p_source=>'CHARGE_TO_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
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
  p_id=>90763334691048659 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_CREATE_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 288,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
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
  p_id=>90763519540048659 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_PARAGRAPH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 295,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Paragraph',
  p_source=>'PARAGRAPH',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   paragraph_number || '' - '' || content display_value,'||chr(10)||
'         paragraph return_value'||chr(10)||
'    from t_cfunds_paragraphs'||chr(10)||
'   where active = ''Y'''||chr(10)||
'      or paragraph = :p30505_paragraph'||chr(10)||
'order by 1',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Paragraph -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width: 580px;"',
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
  p_id=>90763736518048660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_CATEGORY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 296,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Category',
  p_source=>'CATEGORY',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select CODE_DESCRIPTION_AND_PEC_DTL display_value, code return_value'||chr(10)||
'from V_CFUNDS_CATEGORIES_DTL_LOOKUP'||chr(10)||
'order by code',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Category -',
  p_lov_null_value=> '',
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
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '2009_08_20 M.Batdorf - replaced '||chr(10)||
'''select   code || '' - '' || description display_value, code return_value'||chr(10)||
'from t_cfunds_categories'||chr(10)||
'order by 1''');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90764107391048660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_DATE_INCURRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 287,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'to_char(sysdate,''&FMT_DATE.'');',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Date Incurred',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'INCURRED_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>90768709162114726 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_DEDUCT_FROM_ADVANCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 303,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Deduct from<br>Advance Balance',
  p_source=>'TAKE_FROM_ADVANCES',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:?;2,Yes;-1,No;0',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'STATIC2:- Select Y/N -;2,Yes;-1,No;0');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90803418296194615 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_JUSTIF_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 297,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Justification, Details<br>and Explanation',
  p_source=>'DESCRIPTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>90803819813204537 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_PARENT_INFO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 279,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '''Activity: '' || osi_activity.get_id(:p30505_parent) || '' - '' || core_obj.get_tagline(:p30505_parent);',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Context',
  p_source=>'PARENT_INFO',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>90804119644242349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_SOURCE_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Source ID',
  p_source=>'SOURCE_ID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>90804337437256974 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_SOURCE_AMOUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 304,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Source Amount',
  p_format_mask=>'&FMT_CF_CURRENCY.',
  p_source=>'SOURCE_AMOUNT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>90804516097260273 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_AGENT_AMOUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 305,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Agent Amount',
  p_format_mask=>'&FMT_CF_CURRENCY.',
  p_source=>'AGENT_AMOUNT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>90804731334264685 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_TOTAL_AMOUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 306,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Amount Spent',
  p_format_mask=>'&FMT_CF_CURRENCY.',
  p_source=>'TOTAL_AMOUNT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>90804909994267984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_CONVERSION_RATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 307,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '1.0',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Conversion Rate',
  p_source=>'CONVERSION_RATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>90805230080273721 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_TOTAL_AMOUNT_US',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 308,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'US Currency Total',
  p_format_mask=>'&FMT_CF_CURRENCY.',
  p_source=>'TOTAL_AMOUNT_US',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>90806524155319384 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_RECEIPTS_DISPOSITION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 302,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Receipts Disposition',
  p_source=>'RECEIPTS_DISPOSITION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select DESCRIPTION display_value, CODE return_value '||chr(10)||
'from T_CFUNDS_RECEIPT_DISPOSITION'||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Disposition -',
  p_lov_null_value=> '',
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
  p_id=>90918607518157874 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_CONTEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 298,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Context',
  p_source=>'''Activity: '' || osi_activity.get_id(:p30505_parent) || '' - '' || core_obj.get_tagline(:p30505_parent);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>90919120331161515 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_PARENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 278,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Parent',
  p_source=>'PARENT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>92847623309302089 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_CLAIMANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 277,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'core_context.personnel_sid',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Claimant',
  p_source=>'CLAIMANT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>93421518733652979 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_ERROR_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 90761918570048646+wwv_flow_api.g_id_offset,
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
  p_id=>93543124195617904 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_SUBMITTED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 280,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Submitted On',
  p_source=>'SUBMITTED_ON',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>93585434976999507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_APPROVED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 281,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Approved On',
  p_source=>'APPROVED_ON',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>93585609828001657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_REJECTED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 282,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Rejected On',
  p_source=>'REJECTED_ON',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>93646024107805290 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_DISALLOW_COMMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 286,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Disallow Comment',
  p_source=>'REJECTION_COMMENT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>94275221581279756 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 276,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
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
  p_id=>94854619184232035 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_PAGE_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 90761918570048646+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Page Title',
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
  p_id=>98013207860737485 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_ACTION_REG_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 90761918570048646+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Action Reg Title',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>98608715632946617 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_CHARGE_UNIT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 292,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Charged<br>with Expense',
  p_source=>'osi_unit.get_name(:p30505_charge_unit);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 2000,
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
  p_id=>98611624169015285 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_FIND_ICON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 293,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(650,''P30505_CHARGE_UNIT'',''N'',''&P30505_CHARGE_UNIT.'');">&ICON_LOCATOR.</a>',
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
  p_id=>98612732180046029 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_VIEW_ICON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 294,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Unit" href="'''||chr(10)||
'|| osi_object.get_object_url(:P30505_CHARGE_UNIT)'||chr(10)||
'||''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>'P30505_CHARGE_UNIT',
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
  p_id=>98726426963111920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_ERROR_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 309,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN_PROTECTED',
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
  p_id=>99347625034895617 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_INVALIDATED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 283,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'INVALIDATED_ON',
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
  p_id=>99347838539899490 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_REPAID_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 284,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'REPAID_ON',
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
  p_id=>99348034515907767 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_name=>'P30505_REVIEWING_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 285,
  p_item_plug_id => 90762109577048651+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'REVIEWING_UNIT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=> 4967522025131144 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_computation_sequence => 35,
  p_computation_item=> 'P30505_CHARGE_UNIT',
  p_computation_point=> 'AFTER_HEADER',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'return osi_cfunds.get_default_charge_unit'||chr(10)||
'',
  p_computation_comment=> ''||chr(10)||
'declare'||chr(10)||
''||chr(10)||
'     myCount           number;'||chr(10)||
'     myUnit            varchar2(20);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     myUnit := osi_personnel.get_current_unit(:USER_SID);'||chr(10)||
''||chr(10)||
'     while myUnit is not null'||chr(10)||
'     loop'||chr(10)||
'     '||chr(10)||
'          select count(*) into myCount from t_cfunds_unit where sid=myUnit;'||chr(10)||
'          '||chr(10)||
'          if myCount = 1 then'||chr(10)||
'       '||chr(10)||
'            return myUnit;'||chr(10)||
''||chr(10)||
'          end if;'||chr(10)||
''||chr(10)||
'          select unit_parent into myUnit from t_osi_unit where sid=myUnit;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     return null;'||chr(10)||
''||chr(10)||
'end;',
  p_compute_when => 'P30505_CHARGE_UNIT',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 94803221646485187 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_computation_sequence => 10,
  p_computation_item=> 'P30505_SID',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'ITEM_VALUE',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'P0_OBJ',
  p_compute_when => 'P30505_SID',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 94857611135248634 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_computation_sequence => 15,
  p_computation_item=> 'P30505_PAGE_TITLE',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'if :P30505_SID is null then '||chr(10)||
' return ''C-Funds Expense (Create)'';'||chr(10)||
'else'||chr(10)||
' return core_obj.get_tagline(''&P30505_SID.'');'||chr(10)||
'end if;',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 4959516524263880 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30505,
  p_computation_sequence => 25,
  p_computation_item=> 'P30505_ACTION_VISIBLE',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> '     declare v_status varchar2(100);'||chr(10)||
'begin'||chr(10)||
'     begin'||chr(10)||
'          select status into v_status from v_cfunds_expense_v3 where sid=:P30505_SID;'||chr(10)||
'     exception when others then'||chr(10)||
'              v_status := null;'||chr(10)||
'     end;'||chr(10)||
''||chr(10)||
'     ---change claimant---'||chr(10)||
'     if (v_status = '''' OR v_status = ''New'') and :P30505_SID is not null and cfunds_test_cfp(''EXP_CRE_PROXY'',:p0_obj_type_sid,core_context.personnel_sid,osi_personnel.get_current_unit(core_context.personnel_sid)) = ''Y'' then'||chr(10)||
' '||chr(10)||
'       return ''Y'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
' '||chr(10)||
'     ---Submit for Approval---'||chr(10)||
'     if (v_status = ''New'' OR v_status = ''Disallowed'') and :P30505_SID is not null then'||chr(10)||
''||chr(10)||
'          return ''Y'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     ---Disallow Expense---'||chr(10)||
'     if v_status = ''Submitted'' and :P30505_SID is not null then'||chr(10)||
'     '||chr(10)||
'          return ''Y'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     ---Approve Expense---'||chr(10)||
'     if v_status = ''Submitted'' and :P30505_SID is not null then'||chr(10)||
''||chr(10)||
'          return ''Y'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     ---Fix Expense---'||chr(10)||
'     if v_status = ''Rejected'' then'||chr(10)||
''||chr(10)||
'           return ''Y'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     ---View Disallow---'||chr(10)||
'     if v_status = ''Disallowed'' and :P30505_SID is not null then'||chr(10)||
''||chr(10)||
'          return ''Y'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     ---Deletable?---'||chr(10)||
'     if osi_cfunds.can_delete(:P30505_SID) = ''Y'' then'||chr(10)||
'       '||chr(10)||
'       return ''Y'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return ''N'';'||chr(10)||
''||chr(10)||
'end;',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90966438094999353 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_DATE_INCURRED',
  p_validation_sequence=> 1,
  p_validation => 'P30505_DATE_INCURRED',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Date Incurred must be specified.',
  p_validation_condition=> 'SAVE,CREATE,SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 90764107391048660 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98642835136210701 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'No future date',
  p_validation_sequence=> 2,
  p_validation => ':P30505_DATE_INCURRED <= SYSDATE',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'The date of this expense cannot be in the future.',
  p_validation_condition=> 'SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 90764107391048660 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11809329110354843 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 3,
  p_validation => 'P30505_DATE_INCURRED',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30505_DATE_INCURRED IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 90764107391048660 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98641522099140739 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_CLAIMANT Not Null',
  p_validation_sequence=> 4,
  p_validation => 'P30505_CLAIMANT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Claimant must be specified.',
  p_validation_condition=> 'SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> 'generated 14-SEP-2009 15:59');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98643536007248798 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_CONTEXT',
  p_validation_sequence=> 15,
  p_validation => 'P30505_CONTEXT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Context of this expense is unknown.',
  p_validation_condition=> 'SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 90918607518157874 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90966712037010781 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_CHARGE_UNIT',
  p_validation_sequence=> 20,
  p_validation => 'P30505_CHARGE_UNIT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit Charged with Expense must be specified.',
  p_validation_condition=> 'SAVE,CREATE,SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 90763136177048657 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98640733265125057 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_PARAGRAPH',
  p_validation_sequence=> 25,
  p_validation => 'P30505_PARAGRAPH',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Paragraph must be specified.',
  p_validation_condition=> 'SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 90763519540048659 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90966923812014110 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_CATEGORY',
  p_validation_sequence=> 30,
  p_validation => 'P30505_CATEGORY',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Category must be specified.',
  p_validation_condition=> 'SAVE,CREATE,SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 90763736518048660 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98643209557231685 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_JUSTIF_DESC',
  p_validation_sequence=> 35,
  p_validation => 'P30505_JUSTIF_DESC',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Justification must be specified.',
  p_validation_condition=> 'SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 90803418296194615 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95438928770584034 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_RECEIPTS_DISPOSITION',
  p_validation_sequence=> 40,
  p_validation => 'P30505_RECEIPTS_DISPOSITION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Receipts Disposition must be specified.',
  p_validation_condition=> 'SAVE,CREATE,SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 90806524155319384 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90967136625017878 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_AMOUNTS',
  p_validation_sequence=> 45,
  p_validation => 'declare'||chr(10)||
'    v_source_valid   varchar2(2);'||chr(10)||
'    v_agent_valid    varchar2(2);'||chr(10)||
'    v_rv             boolean     := true;'||chr(10)||
'begin'||chr(10)||
'    if :p30505_source_amount is null then'||chr(10)||
'        :p30505_source_amount := ''0'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if :p30505_agent_amount is null then'||chr(10)||
'        :p30505_agent_amount := ''0'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    v_source_valid :='||chr(10)||
'        osi_cfunds.validate_amount(:p30505_source_amount,'||chr(10)||
'                                ''&FMT_CF_CURRENCY.'');'||chr(10)||
'    v_agent_valid :='||chr(10)||
'        osi_cfunds.validate_amount(:p30505_agent_amount,'||chr(10)||
'                                ''&FMT_CF_CURRENCY.'');'||chr(10)||
''||chr(10)||
'    if (   v_source_valid = ''N'''||chr(10)||
'        or v_agent_valid = ''N'') then'||chr(10)||
'        :p30505_error_msg :='||chr(10)||
'                  ''Source Amount and Agent Amount must both be numeric.'';'||chr(10)||
'        v_rv := false;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    -- one of the amounts needs to be greater than zero.'||chr(10)||
'    if (v_source_valid = ''Y0'' and v_agent_valid = ''Y0'') then'||chr(10)||
'        :p30505_error_msg :='||chr(10)||
'            ''Source Amount or Agent Amount must be greater than zero.'';'||chr(10)||
'        v_rv := false;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    return v_rv;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => '&P30505_ERROR_MSG.',
  p_validation_condition=> 'SAVE,CREATE,SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90967828791025042 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_validation_name => 'P30505_CONVERSION_RATE',
  p_validation_sequence=> 50,
  p_validation => 'declare'||chr(10)||
'    v_num   number;'||chr(10)||
'begin'||chr(10)||
'    v_num := to_number(:p30505_conversion_rate);'||chr(10)||
''||chr(10)||
'    if (v_num > 0 and v_num is not null) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'exception'||chr(10)||
'    when value_error then'||chr(10)||
'        return false;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'A positive Conversion Rate must be specified.',
  p_validation_condition=> 'SAVE,CREATE,SUBMIT_FOR_APPROVAL',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 90804909994267984 + wwv_flow_api.g_id_offset,
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
p:=p||'begin'||chr(10)||
'    if (''&REQUEST.'' = ''SUBMIT_FOR_APPROVAL'') then'||chr(10)||
'        cfunds_pkg.submit_expense(:p30505_sid);'||chr(10)||
'        commit;'||chr(10)||
'    elsif(''&REQUEST.'' = ''APPROVE_EXPENSE'') then'||chr(10)||
'        cfunds_pkg.approve_expense(:p30505_sid);'||chr(10)||
'    elsif(''&REQUEST.'' = ''DISALLOW_EXPENSE'') then'||chr(10)||
''||chr(10)||
'      if :P30505_STATUS = ''Submitted'' then'||chr(10)||
'        cfunds_pkg.disallow_expense(:p30505_sid, :p30505_disallow_comment);'||chr(10)||
'      end if;'||chr(10)||
'';

p:=p||''||chr(10)||
'    elsif(''&REQUEST.'' = ''FIX_EXPENSE'') then'||chr(10)||
'        cfunds_pkg.fix_expense(:p30505_sid);'||chr(10)||
'    end if;'||chr(10)||
'exception'||chr(10)||
'    when others then'||chr(10)||
'        :p30505_error_details := cfunds_pkg.get_error_detail;'||chr(10)||
'        raise_application_error(-20200, :p30505_error_details);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 91760025625903734 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Change Lifecycle State',
  p_process_sql_clob => p, 
  p_process_error_message=> '&P30505_ERROR_DETAILS.',
  p_process_when=>'SUBMIT_FOR_APPROVAL,APPROVE_EXPENSE,DISALLOW_EXPENSE,FIX_EXPENSE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'Each of the request values in the condition indicates that an update needs to take place, so the value of :REQUEST is changed to ''Update'', so the DML process will fire. Note that ''Update'' is used intentionally, because ''Save'' results in ALL_DONE being set, which causes the window to close.');
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
'   apex_application.g_request := ''UPDATE'';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 98219413092486290 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Prep for Update',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST = ''P30505_CLAIMANT''',
  p_process_when_type=>'NEVER',
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
'      :p30505_sid := osi_cfunds.create_instance(:p30505_date_incurred,'||chr(10)||
' :p30505_charge_unit,'||chr(10)||
' :p30505_claimant,'||chr(10)||
' :p30505_category,'||chr(10)||
' :p30505_paragraph,'||chr(10)||
' :p30505_justif_desc,'||chr(10)||
' :p30505_parent,'||chr(10)||
' :p30505_parent_info,'||chr(10)||
' :p30505_deduct_from_advance,'||chr(10)||
' null,   --:p30505_take_from_other_sources?'||chr(10)||
' :p30505_receipts_disposition,'||chr(10)||
' :p30505_source_amount,'||chr(10)||
' :p30505_agent_amount,'||chr(10)||
' :p30505_conversion_rate'||chr(10)||
' );'||chr(10)||
'e';

p:=p||'nd;';

wwv_flow_api.create_page_process(
  p_id     => 21748000727586467 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Expense',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE',
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
p:=p||'#OWNER#:V_CFUNDS_EXPENSE_V3:P30505_SID:SID|UD';

wwv_flow_api.create_page_process(
  p_id     => 90869314773890432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Row V_CFUNDS_EXPENSE_V3',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30505_SID',
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
p:=p||'F|#OWNER#:V_CFUNDS_EXPENSE_V3:P30505_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 90764321320048670 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30505,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'fetch row V_CFUNDS_EXPENSE_V3',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P30505',
  p_process_when_type=>'REQUEST_NOT_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30505
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
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   13:13 Thursday March 17, 2011
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

PROMPT ...Remove page 30605
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30605);
 
end;
/

 
--application/pages/page_30605
prompt  ...PAGE 30605: Evidence Widget
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_ADDRESS_WIDGET"'||chr(10)||
'"JS_POPUP_OBJ_DATA"'||chr(10)||
'"JS_POPUP_LOCATOR"'||chr(10)||
'"JS_CREATE_PARTIC_WIDGET"'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'<!-- '||chr(10)||
'function deleteEvidence()'||chr(10)||
'{'||chr(10)||
' deleteObj(''&P30605_SID.'',''DELETE_OBJECT'');'||chr(10)||
' window.opener.doSubmit();'||chr(10)||
'}'||chr(10)||
'//-->'||chr(10)||
''||chr(10)||
'if (''&P30605_REFRESH_PARENT_WINDOW.'' == ''Y'')'||chr(10)||
'    window.opener.doSubmit();'||chr(10)||
''||chr(10)||
'   function submitEvidence(objSid,statusChange,statusChangeDesc){'||chr(10)||
'      var pageNum = 30610;'||chr(10)||
'';

ph:=ph||'      var pageName = ''EVID_STATUS'';'||chr(10)||
'      var itemNames = ''P30610_STATUS_CHANGE,P30610_EVIDENCE_SID,P30610_STATUS_CHANGE_DESC'';'||chr(10)||
'      var itemVals = statusChange + '','' + objSid + '','' + statusChangeDesc;'||chr(10)||
'      '||chr(10)||
'      popup({ page   : pageNum,  '||chr(10)||
'    name   : pageName,'||chr(10)||
'    item_names  : itemNames,'||chr(10)||
'    item_values : itemVals,'||chr(10)||
'    clear_cache : pageNum,'||chr(10)||
'                                request     : ''EV';

ph:=ph||'ID_STAT''});'||chr(10)||
' }'||chr(10)||
'//-->'||chr(10)||
'</script>'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 30605,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Evidence Widget',
  p_step_title=> 'Evidence: &P30605_TAG_NUMBER_DISPLAY.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110317131330',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '06-DEC-2010 J.FARIS - WCHG0000386 - updates to address widget, removed read-only condition from date received (not necessary when SAVE not available).'||chr(10)||
''||chr(10)||
'17-Mar-2011 Tim Ward - CR#3731 - Added deleteEvidence to Javascript Header, changed the delete button to call it and removed the delete process.  Stops the No Data Found Error when Evidence is deleted.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30605,p_text=>ph);
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
  p_id=> 9228512051774026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30605,
  p_plug_name=> 'Actions',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_source=> s,
  p_plug_source_type=> 9227114297736817 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P30605_ENTRY_POINT = ''ACTIVITY'' and :P30605_SID is not null',
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
  p_id=> 9228726596778307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30605,
  p_plug_name=> 'Reports',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_source=> s,
  p_plug_source_type=> 9227729188741117 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'ITEM_IS_NOT_NULL',
  p_plug_display_when_condition => 'P30605_SID',
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
  p_id=> 93885234648663201 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30605,
  p_plug_name=> 'Acquisition Details',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 40,
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
  p_id=> 93885920365677968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30605,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
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
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 93890620374753624 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30605,
  p_button_sequence=> 10,
  p_button_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30605_SID is not null'||chr(10)||
'and'||chr(10)||
':P30605_ENTRY_POINT = ''ACTIVITY''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 94077812778897590 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30605,
  p_button_sequence=> 20,
  p_button_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':p30605_sid is null and :p30605_entry_point = ''ACTIVITY''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 9225702729648371 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30605,
  p_button_sequence=> 60,
  p_button_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:deleteEvidence();',
  p_button_condition=> ':p30605_sid is not null and :p30605_entry_point = ''ACTIVITY'' and :p30605_status_code = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'deleteObj(''&P30605_SID.'',''DELETE_OBJECT'');',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 94646912976062259 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30605,
  p_button_sequence=> 40,
  p_button_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_button_name    => 'Cancel',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>94078130266897592 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_branch_action=> 'f?p=&APP_ID.:30605:&SESSION.::&DEBUG.::P30605_REFRESH_PARENT_WINDOW:Y&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_IN_CONDITION',
  p_branch_condition=> 'CREATE,SAVE',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>93891523622764059 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_branch_action=> 'f?p=&APP_ID.:30605:&SESSION.:&REQUEST.:&DEBUG.::P30605_REFRESH_PARENT_WINDOW:&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 29-JUN-2009 10:24 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5334129361714917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RFP',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30605_RFP',
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
  p_id=>5334519103721418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RFP_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Received From Participant',
  p_source=>'begin'||chr(10)||
'  if (:P30605_RFP is not null) then'||chr(10)||
'     return osi_participant.get_name(:P30605_RFP);'||chr(10)||
'  else'||chr(10)||
'     return null;'||chr(10)||
'  end if;'||chr(10)||
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
  p_tag_attributes  => '&DISABLE_TEXT.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30605_AQUISITION_METHOD = ''RFP''',
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
  p_id=>5335207114727440 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RFP_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 450,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(400,''P30605_RFP'',''N'',''&P30605_RFP.'',''PART.INDIV'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30605_AQUISITION_METHOD = ''RFP'''||chr(10)||
'and'||chr(10)||
':P30605_ENTRY_POINT = ''ACTIVITY''',
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
  p_id=>5335522005731707 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RFP_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 460,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Participant" href="'' || '||chr(10)||
'osi_object.get_object_url(:p30605_rfp) ||'||chr(10)||
'''">&ICON_MAGNIFY.</a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30605_AQUISITION_METHOD = ''RFP'' '||chr(10)||
'and'||chr(10)||
':P30605_RFP is not null',
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
  p_id=>5335701011735168 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RFP_CREATE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 470,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a title="Create Participant" href="javascript:createParticWidget(''P30605_RFP'');">&ICON_CREATE_PERSON.</a>',
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
  p_display_when=>':P30605_AQUISITION_METHOD = ''RFP'''||chr(10)||
'and'||chr(10)||
':P30605_ENTRY_POINT = ''ACTIVITY''',
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
  p_id=>5356330915027656 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RFP_ORIGINAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30605_RFP_ORIGINAL',
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
  p_id=>5391201514090062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_SFP_ORIGINAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 360,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30605_SFP_ORIGINAL',
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
  p_id=>9231816047888792 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_FORM52',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 111,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
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
  p_id=>9232023320890865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_I2MS_VERSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 112,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
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
  p_id=>9605315693694048 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RECEIPT_RPT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 113,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
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
  p_id=>93885513654666567 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source=>'DESCRIPTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30605_LOCKOUT_TEXTAREA.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>93887817164695954 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OBJ_PARENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Parent Obj',
  p_source=>'OBJ',
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
  p_id=>93888208291702890 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OBJ_PARENT_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Related Activity',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>93890330847737796 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_DATE_RECEIVED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Received',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'OBTAINED_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 12,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_read_only_when=>':P30605_ENTRY_POINT <> ''ACTIVITY''',
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
  p_id=>93931506306159473 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OWNER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Owner',
  p_source=>'OWNER_SID',
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
  p_id=>93931826738165440 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OWNER_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Owner',
  p_source=>'begin'||chr(10)||
'  if :P30605_OWNER is not null then'||chr(10)||
'     return osi_participant.get_name(:P30605_OWNER);'||chr(10)||
'  else'||chr(10)||
'     return null;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
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
  p_item_comment => '<span style="vertical-align:bottom">'||chr(10)||
'<a href="javascript:popup({page:150,name:''PERSONLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM'',item_values:''OSI.LOC.PARTICIPANT,P21005_PARTICIPANT''});">&ICON_LOCATOR.</a>'||chr(10)||
'<a href="javascript:createParticWidget(''P21005_PARTICIPANT'');"><img src="#IMAGE_PREFIX#themes/OSI/create_person.gif" alt="Find" height="18px"></span></a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93932010939170309 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OWNER_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(400,''P30605_OWNER'',''N'','''',''PART.INDIV'');">&ICON_LOCATOR.</a>',
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
  p_display_when=>':P30605_ENTRY_POINT = ''ACTIVITY''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a title="Find Participant"'||chr(10)||
'   href="javascript:popup({page:150,'||chr(10)||
'      name:''PERSONLOC&P0_OBJ.'','||chr(10)||
'      clear_cache:''150'','||chr(10)||
'      item_names:''P150_VIEW,P150_RETURN_ITEM'','||chr(10)||
'      item_values:''OSI.LOC.PARTICIPANT,P30605_OWNER''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93932621674173443 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OWNER_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Participant" href="'' || '||chr(10)||
'osi_object.get_object_url(:P30605_OWNER) ||'||chr(10)||
'''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>'P30605_OWNER',
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
  p_id=>93932931717176349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OWNER_CREATE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a title="Create Participant" href="javascript:createParticWidget(''P30605_OWNER'');">&ICON_CREATE_PERSON.</a>',
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
  p_display_when=>':P30605_ENTRY_POINT = ''ACTIVITY'''||chr(10)||
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
  p_id=>93964212837833273 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30605_UNIT_SID',
  p_source=>'UNIT_SID',
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
  p_id=>93964524957836728 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Controlling Unit',
  p_source=>'OSI_UNIT.GET_NAME(:P30605_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
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
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM'',item_values:''OSI.LOC.UNIT,P30605_UNIT_SID''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94037215560573696 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RECEIVING_PERSONNEL_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Personnel',
  p_source=>'OBTAINED_BY_SID',
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
  p_id=>94037612921582392 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RECEIVING_PERSONNEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Receiving Personnel',
  p_source=>'begin'||chr(10)||
'  if :P30605_RECEIVING_PERSONNEL_SID is not null then'||chr(10)||
'      return osi_personnel.get_name(:P30605_RECEIVING_PERSONNEL_SID);'||chr(10)||
'  else'||chr(10)||
'      return null;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
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
  p_item_comment => '<a href="javascript:popup({page:150,name:''PRSNLLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM'',item_values:''OSI.LOC.PERSONNEL,P30605_RECEIVING_PERSONNEL_SID''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94039832361616446 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OBTAINED_AT_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 280,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_address.get_addr_fields(osi_address.get_address_sid(:P30605_SID, ''OBTAINED_AT''))',
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
  p_id=>94040012752620221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OBTAINED_AT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 290,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Obtained At',
  p_source=>'osi_address.get_addr_display(:P30605_OBTAINED_AT_VALUE,''FIELDS'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 36,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXTAREA.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>94040227297624357 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_OBTAINED_AT_ADDRESS_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href ="javascript:void(0);" onclick = "javascript:addressWidget(''P30605_OBTAINED_AT_VALUE'',''~&P30605_OBJ_PARENT.~''); return false;">&ICON_ADDRESS.</a>',
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
  p_display_when=>':P30605_ENTRY_POINT = ''ACTIVITY''',
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
  p_id=>94041706490741429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
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
  p_id=>94071308997773476 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_REC_FINAL_DISP',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Recommended<br>Final Disposition',
  p_source=>'FINAL_DISP',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 500,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30605_LOCKOUT_TEXTAREA.',
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
  p_id=>94146424420009664 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_AQUISITION_METHOD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 330,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'RFIA',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'ACQUISITION_METHOD',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP_WITH_SUBMIT',
  p_lov => 'STATIC2:Received From Investigative Activity;RFIA,Received From Source;RFS,Obtained During Search Of;ODSO,Received From Participant;RFP,Seized From Participant;SFP',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => '&P30605_LOCKOUT_RADIO.',
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
  p_item_comment => 'STATIC2:Obtained During Search Of;ODSO,Received From Investigative Activity;RFIA,Received From Participant;RFP,Received From Source;RFS,Seized From Participant;SFP');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94162523138141790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_IDENTIFY_SOURCE_AS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 320,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Identify Source As',
  p_source=>'IDENTIFY_AS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30605_LOCKOUT_TEXT.',
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
  p_id=>94164520283159829 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_DESCRIPTION_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'(If property is to be returned, include condition and claimed value.)',
  p_source_type=> 'STATIC',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<label class="requiredlabel">(If property is to be returned, include condition and claimed value.)</label>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94181731168323864 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_ODSO_COMMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 350,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Comment',
  p_source=>'P30605_ODSO_COMMENT_VALUE',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30605_LOCKOUT_TEXTAREA.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30605_AQUISITION_METHOD = ''ODSO''',
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
  p_id=>94205222406889114 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_SFP',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 370,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30605_SFP',
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
  p_id=>94205433834892431 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_SFP_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 380,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Seized From Participant',
  p_source=>'begin'||chr(10)||
'  if (:P30605_SFP is not null) then'||chr(10)||
'     return osi_participant.get_name(:P30605_SFP);'||chr(10)||
'  else'||chr(10)||
'     return null;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30605_AQUISITION_METHOD = ''SFP''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<span style="vertical-align:bottom">'||chr(10)||
'<a href="javascript:popup({page:150,name:''PERSONLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM'',item_values:''OSI.LOC.PARTICIPANT,P21005_PARTICIPANT''});">&ICON_LOCATOR.</a>'||chr(10)||
'<a href="javascript:createParticWidget(''P21005_PARTICIPANT'');"><img src="#IMAGE_PREFIX#themes/OSI/create_person.gif" alt="Find" height="18px"></span></a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94205610070894964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_SFP_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 390,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(400,''P30605_SFP'',''N'',''&P30605_SFP.'',''PART.INDIV'');">&ICON_LOCATOR.</a>',
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
  p_display_when=>':P30605_AQUISITION_METHOD = ''SFP'''||chr(10)||
'and'||chr(10)||
':P30605_ENTRY_POINT = ''ACTIVITY''',
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
  p_id=>94205915957896707 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_SFP_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 400,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Participant" href="'' || '||chr(10)||
'osi_object.get_object_url(:P30605_SFP) ||'||chr(10)||
'''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>':P30605_AQUISITION_METHOD = ''SFP'' '||chr(10)||
'and'||chr(10)||
':P30605_SFP is not null',
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
  p_id=>94206121498898279 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_SFP_CREATE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 410,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a title="Create Participant" href="javascript:createParticWidget(''P30605_SFP'');">&ICON_CREATE_PERSON.</a>',
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
  p_display_when=>':P30605_AQUISITION_METHOD = ''SFP'''||chr(10)||
'and'||chr(10)||
':P30605_ENTRY_POINT = ''ACTIVITY''',
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
  p_id=>94467737411795534 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_ODSO_COMMENT_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 340,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Odso Comment Value',
  p_source=>'ODSO_COMMENT',
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
  p_id=>94498527049070051 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_EVIDENCE_TAG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Tentative Tag #',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_display_when=>':P30605_sid is null',
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
  p_id=>94722225309156920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status',
  p_source=>'STATUS_SID',
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
  p_id=>94723335006159718 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_STATUS_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Code',
  p_source=>'osi_evidence.lookup_evid_status_code(:P30605_STATUS)',
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
  p_id=>95600714660136917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_REFRESH_PARENT_WINDOW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
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
  p_id=>97605209355020167 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_ENTRY_POINT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Entry Point',
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
  p_id=>97605526455034609 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_LOCKOUT_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lockout',
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
  p_id=>97658813761432906 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_LOCKOUT_RADIO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lockout Readonly',
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
  p_id=>97662538358515774 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_UNIT_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(500,''P30605_UNIT_SID'',''N'',''&P30605_UNIT_SID.'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_display_when=>':P30605_ENTRY_POINT = ''ACTIVITY''',
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
  p_id=>97663433079533143 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RECEIVING_PERSONNEL_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(350,''P30605_RECEIVING_PERSONNEL_SID'',''N'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_display_when=>':P30605_ENTRY_POINT = ''ACTIVITY''',
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
  p_id=>97761038504545339 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_LOCKOUT_TEXTAREA',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lockout Textarea',
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
  p_id=>97890609990847504 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_TAG_NUMBER_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Tag Number Display',
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
  p_id=>97891615924877596 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_STATUS_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 93885920365677968+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Desc',
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
 
wwv_flow_api.create_page_computation(
  p_id=> 94468409969806543 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_computation_sequence => 10,
  p_computation_item=> 'P30605_ODSO_COMMENT_VALUE',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> ':P30605_ODSO_COMMENT',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 94092230580337967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_computation_sequence => 10,
  p_computation_item=> 'P30605_SID',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'ITEM_VALUE',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'P0_OBJ',
  p_compute_when => 'P30605_SID',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 97605729010044764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_computation_sequence => 20,
  p_computation_item=> 'P30605_LOCKOUT_TEXT',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> '&DISABLE_TEXT.',
  p_computation_comment=> 'if (:P30605_ENTRY_POINT = ''FILE'') then'||chr(10)||
'    :P30605_LOCKOUT := ''disabled'';'||chr(10)||
'else'||chr(10)||
'    :P30605_LOCKOUT := null;'||chr(10)||
'end if;',
  p_compute_when => 'P30605_ENTRY_POINT',
  p_compute_when_text=>'FILE',
  p_compute_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 97761214047547712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_computation_sequence => 20,
  p_computation_item=> 'P30605_LOCKOUT_TEXTAREA',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> '&DISABLE_TEXTAREA.',
  p_compute_when => 'P30605_ENTRY_POINT',
  p_compute_when_text=>'FILE',
  p_compute_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 97659028306437117 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_computation_sequence => 30,
  p_computation_item=> 'P30605_LOCKOUT_RADIO',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> '&DISABLE_RADIO.',
  p_computation_comment=> 'if (:P30605_ENTRY_POINT = ''FILE'') then'||chr(10)||
'    :P30605_LOCKOUT := ''disabled'';'||chr(10)||
'else'||chr(10)||
'    :P30605_LOCKOUT := null;'||chr(10)||
'end if;',
  p_compute_when => 'P30605_ENTRY_POINT',
  p_compute_when_text=>'FILE',
  p_compute_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 2955613998164328 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_validation_name => 'Personnel Must Be In Unit',
  p_validation_sequence=> 5,
  p_validation => 'begin'||chr(10)||
'    if (osi_personnel.get_current_unit(core_context.personnel_sid) is null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'You are not currently assigned to a Unit.  <br>Assign yourself to a Unit in the personnel page and then try creating your evidence again.',
  p_when_button_pressed=> 94077812778897590 + wwv_flow_api.g_id_offset,
  p_associated_item=> 94041706490741429 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 94241714327728846 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_validation_name => 'P30605_DESCRIPTION',
  p_validation_sequence=> 10,
  p_validation => 'P30605_DESCRIPTION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Description must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 93885513654666567 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 94242120907730768 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_validation_name => 'P30605_DATE_RECEIVED',
  p_validation_sequence=> 20,
  p_validation => 'P30605_DATE_RECEIVED',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Date Received must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 93890330847737796 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11819818646446392 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 21,
  p_validation => 'P30605_DATE_RECEIVED',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30605_DATE_RECEIVED IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 93890330847737796 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 94242528526732929 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_validation_name => 'P30605_UNIT_SID',
  p_validation_sequence=> 30,
  p_validation => 'P30605_UNIT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Controlling Unit must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 93964524957836728 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 94242734413734654 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_validation_name => 'P30605_RECEIVING_PERSONNEL_SID',
  p_validation_sequence=> 40,
  p_validation => 'P30605_RECEIVING_PERSONNEL_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Recieving Personnel must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 94037612921582392 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 94673827753258781 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_validation_name => 'P30605_OBTAINED_AT_DISPLAY',
  p_validation_sequence=> 50,
  p_validation => 'P30605_OBTAINED_AT_DISPLAY',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Location must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 94040012752620221 + wwv_flow_api.g_id_offset,
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
p:=p||'begin'||chr(10)||
'    if (:p30605_aquisition_method <> ''RFP'') then'||chr(10)||
'        :p30605_rfp := null;'||chr(10)||
'        :p30605_rfp_name := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p30605_aquisition_method <> ''SFP'') then'||chr(10)||
'        :p30605_sfp := null;'||chr(10)||
'        :P30605_sfp_name := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p30605_aquisition_method <> ''ODSO'') then'||chr(10)||
'        :p30605_odso_comment_value := null;'||chr(10)||
'        :p30605_odso_comment := null;'||chr(10)||
'    end if;'||chr(10)||
'';

p:=p||'end;';

wwv_flow_api.create_page_process(
  p_id     => 94464918655686053 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear Out Aquisition Data',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SAVE,CREATE',
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
p:=p||'#OWNER#:T_OSI_EVIDENCE:P30605_SID:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 93891211155760498 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Evidence',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>93890620374753624 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30605_SID',
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
'    :p0_obj :='||chr(10)||
'        osi_evidence.create_instance(:p30605_obj_parent,'||chr(10)||
'                                     :p30605_description,'||chr(10)||
'                                     :p30605_receiving_personnel_sid,'||chr(10)||
'                                     :p30605_date_received,'||chr(10)||
'                                     :p30605_unit_sid,'||chr(10)||
'                                     osi_personnel.get_current_unit(core_contex';

p:=p||'t.personnel_sid),'||chr(10)||
'                                     :p30605_owner,'||chr(10)||
'                                     :p30605_rec_final_disp,'||chr(10)||
'                                     :p30605_aquisition_method,'||chr(10)||
'                                     :p30605_odso_comment_value,'||chr(10)||
'                                     :p30605_rfp,'||chr(10)||
'                                     :p30605_sfp);'||chr(10)||
'    :p30605_sid := :p0_obj;'||chr(10)||
'    --:P306';

p:=p||'05_REFRESH_PARENT_WINDOW := ''Y'';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 94079021913909720 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Evidence',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>94077812778897590 + wwv_flow_api.g_id_offset,
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
p:=p||'begin'||chr(10)||
''||chr(10)||
'osi_address.update_single_address(:P30605_SID, ''OBTAINED_AT'', :P30605_OBTAINED_AT_VALUE);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 94043032640786717 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Address',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Address Update Failed',
  p_process_when=>'(:REQUEST = ''SAVE'' or :REQUEST = ''CREATE'')'||chr(10)||
'and'||chr(10)||
':P30605_OBTAINED_AT_VALUE is not null',
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
'    v_partic_role   t_osi_partic_role_type.sid%type;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'    select sid'||chr(10)||
'    into v_partic_role'||chr(10)||
'    from t_osi_partic_role_type'||chr(10)||
'    where obj_type member of osi_object.get_objtypes(:P0_OBJ) and usage = ''RFP'';'||chr(10)||
''||chr(10)||
'    if (:p30605_aquisition_method = ''RFP'') then'||chr(10)||
'        if (:p30605_rfp_original is not null) then'||chr(10)||
'            if (:p30605_rfp <> :p30605_rfp_original) then'||chr(10)||
'                update ';

p:=p||'t_osi_partic_involvement i'||chr(10)||
'                   set participant_version = osi_participant.get_current_version(:p30605_rfp)'||chr(10)||
'                 where obj = :p0_obj and involvement_role = v_partic_role;'||chr(10)||
''||chr(10)||
'                :p30605_rfp_original := :p30605_rfp;'||chr(10)||
'            end if;'||chr(10)||
'        else'||chr(10)||
'            if (:p30605_rfp is not null) then'||chr(10)||
'                insert into t_osi_partic_involvement i'||chr(10)||
'                ';

p:=p||'            (obj, participant_version, involvement_role)'||chr(10)||
'                     values (:p0_obj,'||chr(10)||
'                             osi_participant.get_current_version(:p30605_rfp),'||chr(10)||
'                             v_partic_role);'||chr(10)||
''||chr(10)||
'                :p30605_rfp_original := :p30605_rfp;'||chr(10)||
'            end if;'||chr(10)||
'        end if;'||chr(10)||
'    else'||chr(10)||
'        delete from t_osi_partic_involvement'||chr(10)||
'              where obj = :p0_obj and';

p:=p||' involvement_role = v_partic_role;'||chr(10)||
'        :p30605_rfp_original := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5356614208041751 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update RFP',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'(:REQUEST = ''SAVE'' or :REQUEST = ''CREATE'')',
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
'    v_partic_role   t_osi_partic_role_type.sid%type;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'    select sid'||chr(10)||
'    into v_partic_role'||chr(10)||
'    from t_osi_partic_role_type'||chr(10)||
'    where obj_type member of osi_object.get_objtypes(:P0_OBJ) and usage = ''SFP'';'||chr(10)||
''||chr(10)||
'    if (:p30605_aquisition_method = ''SFP'') then'||chr(10)||
'        if (:p30605_SFP_original is not null) then'||chr(10)||
'            if (:p30605_SFP <> :p30605_SFP_original) then'||chr(10)||
'                update ';

p:=p||'t_osi_partic_involvement i'||chr(10)||
'                   set participant_version = osi_participant.get_current_version(:p30605_SFP)'||chr(10)||
'                 where obj = :p0_obj and involvement_role = v_partic_role;'||chr(10)||
''||chr(10)||
'                :p30605_SFP_original := :p30605_SFP;'||chr(10)||
'            end if;'||chr(10)||
'        else'||chr(10)||
'            if (:p30605_SFP is not null) then'||chr(10)||
'                insert into t_osi_partic_involvement i'||chr(10)||
'                ';

p:=p||'            (obj, participant_version, involvement_role)'||chr(10)||
'                     values (:p0_obj,'||chr(10)||
'                             osi_participant.get_current_version(:p30605_SFP),'||chr(10)||
'                             v_partic_role);'||chr(10)||
''||chr(10)||
'                :p30605_SFP_original := :p30605_SFP;'||chr(10)||
'            end if;'||chr(10)||
'        end if;'||chr(10)||
'    else'||chr(10)||
'        delete from t_osi_partic_involvement'||chr(10)||
'              where obj = :p0_obj and';

p:=p||' involvement_role = v_partic_role;'||chr(10)||
'        :p30605_SFP_original := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5392717276132417 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update SFP',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'(:REQUEST = ''SAVE'' or :REQUEST = ''CREATE'')',
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
p:=p||'F|#OWNER#:T_OSI_EVIDENCE:P30605_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 93885609629674839 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST = ''OPEN''',
  p_process_when_type=>'',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30605_SID',
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
'    --Get the description of the activity this evidence belongs to'||chr(10)||
'    select id || '' - '' || title'||chr(10)||
'      into :p30605_obj_parent_description'||chr(10)||
'      from t_osi_activity'||chr(10)||
'     where sid = :p30605_obj_parent;'||chr(10)||
''||chr(10)||
'   if (:p30605_sid is not null and '||chr(10)||
'      (:p30605_form52 is null or :p30605_i2ms_version is null)) then'||chr(10)||
'       select sid'||chr(10)||
'         into :p30605_form52'||chr(10)||
'         from t_osi_report_type'||chr(10)||
'     ';

p:=p||'   where obj_type = core_obj.lookup_objtype(''EMM'')'||chr(10)||
'          and description = ''Evidence Tag'';'||chr(10)||
''||chr(10)||
'       select sid'||chr(10)||
'         into :p30605_i2ms_version'||chr(10)||
'         from t_osi_report_type'||chr(10)||
'        where obj_type = core_obj.lookup_objtype(''EMM'')'||chr(10)||
'          and description = ''I2MS Version'';'||chr(10)||
''||chr(10)||
'       select sid'||chr(10)||
'         into :p30605_receipt_rpt'||chr(10)||
'         from t_osi_report_type'||chr(10)||
'        where obj_type = core_obj.';

p:=p||'lookup_objtype(''ACT'')'||chr(10)||
'          and description = ''Evidence Receipt'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Get the address for this page (Obtained At)'||chr(10)||
'    --:P30605_OBTAINED_AT_VALUE := osi_util.get_addr_fields(                         osi_object.get_address_sid(:P30605_SID, ''OBTAINED_AT''));'||chr(10)||
''||chr(10)||
'    --Get the ODSO Comment'||chr(10)||
'    --This is done through an item level source'||chr(10)||
'    --:P30605_ODSO_COMMENT := :P30605_ODSO_COMMEN';

p:=p||'T_VALUE;'||chr(10)||
''||chr(10)||
'    --Get tag display for existing objects'||chr(10)||
'    :P30605_TAG_NUMBER_DISPLAY := osi_evidence.get_tag_number(:P0_OBJ);'||chr(10)||
''||chr(10)||
'    --Get status description'||chr(10)||
'    :P30605_STATUS_DESC := osi_evidence.lookup_evid_status_desc(osi_evidence.get_status_sid(:P0_OBJ));'||chr(10)||
''||chr(10)||
'    --Handle defaulted items'||chr(10)||
'    if (:request = ''CREATE_OBJ'') then'||chr(10)||
'        :p30605_receiving_personnel_sid := core_context.personnel_sid;'||chr(10)||
'   ';

p:=p||'     --:p30605_unit_sid := osi_personnel.get_current_unit(core_context.personnel_sid);'||chr(10)||
'        if :p30605_unit_sid is null then'||chr(10)||
'           :p30605_unit_sid := osi_object.get_assigned_unit(:P30605_OBJ_PARENT);'||chr(10)||
'        end if;'||chr(10)||
'        :p30605_date_received := to_char(osi_activity.get_activity_date(:p30605_obj_parent), :FMT_DATE);'||chr(10)||
''||chr(10)||
'        --This value may actually change if 2 people add evidence at ';

p:=p||'the same time.. not sure if we need a better way to do this or not.'||chr(10)||
'        :p30605_evidence_tag :='||chr(10)||
'            osi_object.get_id(:p30605_obj_parent, null) || ''-'''||chr(10)||
'            || osi_evidence.get_next_seq_num(:p30605_obj_parent);'||chr(10)||
''||chr(10)||
'        --Get tag display for existing objects'||chr(10)||
'        :P30605_TAG_NUMBER_DISPLAY := :p30605_evidence_tag;'||chr(10)||
'        '||chr(10)||
'        --Get last used address'||chr(10)||
'        :P30605_OBTAIN';

p:=p||'ED_AT_VALUE := osi_evidence.GET_LAST_ADDRESS(:P30605_OBJ_PARENT);'||chr(10)||
''||chr(10)||
'        --Get status description'||chr(10)||
'        :P30605_STATUS_DESC := osi_evidence.lookup_evid_status_desc(''N'');'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Get RFP/SFP'||chr(10)||
'    if (:request <> ''P30605_RFP'' and :request <> ''P30605_SFP'') then'||chr(10)||
'        if (:p30605_aquisition_method = ''RFP'') then'||chr(10)||
'            :p30605_rfp := osi_object.get_participant_sid(:p0_obj, ''RFP'');'||chr(10)||
'';

p:=p||'            :p30605_rfp_original := :p30605_rfp;'||chr(10)||
'        elsif(:p30605_aquisition_method = ''SFP'') then'||chr(10)||
'            :p30605_sfp := osi_object.get_participant_sid(:p0_obj, ''SFP'');'||chr(10)||
'            :p30605_sfp_original := :p30605_sfp;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 93887926168698570 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30605,
  p_process_sequence=> 15,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Parameters',
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
-- ...updatable report columns for page 30605
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

SET DEFINE OFF;

CREATE OR REPLACE package body osi_activity as
/******************************************************************************
   Name:     Osi_Activity
   Purpose:  Provides Functionality For Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     7-Apr-2009 T.McGuffin      Created Package.
    28-Apr-2009 T.McGuffin      Modified Get_Tagline To Only Return Title.
    27-May-2009 T.McGuffin      Added Create_Instance function.
    01-Jun-2009 T.McGuffin      Added Get_ID function.
    04-Jun-2009 T.McGuffin      Added Get_Inv_Support function and Set_Inv_Support procedure.
    16-Jun-2009 T.McGuffin      Removed subtype from Create Instance.
    30-Jun-2009 T.McGuffin      Phased out CORE ACL for simple Restriction.
    06-Jul-2009 R.Dibble        Added get_activity_date
    15-Oct-2009 J.Faris         Added can_delete.
    28-Oct-2009 R.Dibble        Added generate_form_40
    16-Nov-2009 R.Dibble        Added get_title
    02-Dec-2009 R.Dibble        Modified generate_form_40 to utilize CORE_TEMPLATE procedure calls
    09-Dec-2009 T.McGuffin      Modified get_f40_place for the briefing activity.
    23-Dec-2009 T.Whitehead     Added get_source.
    30-Dec-2009 T.Whitehead     Added get_file.
    10-Feb-2010 T.McGuffin      Added check_writability function.
    10-Feb-2010 T.McGuffin      Modified can_delete to include cfunds expenses.
    26-Feb-2010 T.McGuffin      Modified generate_form_40 to remove get_activity_lead function to
                                replace the call with osi_object.get_lead_agent.
     4-Apr-2010 J.Faris         Updated check_writability to accommodate object type specific rules.
     9-Apr-2010 J.Faris         Added Susp Act specific privilege check of 'SAR.EDIT' to can_delete.
    25-May-2010 T.Leighty       Added make_doc_act
    25-Jun-2010 T.McGuffin      Added get_oldest_file
     5-Aug-2010 J.Faris         Added generate_form_40_summary.
    18-Mar-2011 Tim Ward        CR#3731 - Privilege needs to be checked in here now since the
                                 checkForPriv from i2ms.js deleteObj function.
                                 Fixed the Pending check for deletion with workhours.
                                 Changed for loops to select count(*).
                                 Changed in can_delete.
******************************************************************************/
    c_pipe        varchar2(100)  := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_ACTIVITY';
    v_syn_error   varchar2(4000) := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_file(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select   file_sid
                      from t_osi_assoc_fle_act
                     where activity_sid = p_obj
                  order by create_on asc)
        loop
            return x.file_sid;
        end loop;

        return null;
    exception
        when others then
            log_error('get_file: ' || sqlerrm);
            return null;
    end get_file;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_activity.title%type;
    begin
        select title
          into v_title
          from t_osi_activity
         where SID = p_obj;

        return v_title;
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_id(p_obj in varchar2)
        return varchar2 is
        v_id   t_osi_activity.id%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select id
          into v_id
          from t_osi_activity
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;

    /* Given and activity sid as p_obj, returns the title of the activity */
    function get_title(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_activity.id%type;
    begin
        if p_obj is null then
            log_error('get_title: null value passed');
            return null;
        end if;

        select title
          into v_title
          from t_osi_activity
         where SID = p_obj;

        return v_title;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_title: ' || sqlerrm);
    end get_title;

    function get_source(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select source
                    from t_osi_activity
                   where SID = p_obj)
        loop
            return x.source;
        end loop;

        return null;
    exception
        when others then
            log_error('get_source: ' || sqlerrm);
            return null;
    end get_source;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return 'Activity Summary';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'Activity Index1 XML Clob';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_object.get_status(p_obj);
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function create_instance(
        p_obj_type      in   varchar2,
        p_act_date      in   date,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_narrative     in   clob)
        return varchar2 is
        v_sid   t_core_obj.SID%type;
    begin
        insert into t_core_obj
                    (obj_type)
             values (p_obj_type)
          returning SID
               into v_sid;

        insert into t_osi_activity
                    (SID,
                     id,
                     title,
                     creating_unit,
                     assigned_unit,
                     activity_date,
                     narrative,
                     restriction)
             values (v_sid,
                     osi_object.get_next_id,
                     p_title,
                     osi_personnel.get_current_unit(core_context.personnel_sid),
                     osi_personnel.get_current_unit(core_context.personnel_sid),
                     p_act_date,
                     p_narrative,
                     p_restriction);

        --Create the Lead Assignment
        osi_object.create_lead_assignment(v_sid);
        --Set the starting status
        osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type), 'Created');
        core_obj.bump(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    /* Build an array of the missions associated to the activity, and
       convert that array to an apex-friendly colon-delimited list */
    function get_inv_support(p_obj in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select mission
                    from t_osi_mission
                   where obj = p_obj)
        loop
            v_array(v_idx) := i.mission;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_inv_support: ' || sqlerrm);
            raise;
    end get_inv_support;

    /* Translates p_inv_support (colon-delimited list of mission sids) into an array, then
       loops through and adds those that don't exist already.  Deletes those that no longer
       appear in the list */
    procedure set_inv_support(p_obj in varchar2, p_inv_support in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_inv_support, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_mission
                        (obj, mission)
                select p_obj, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_mission
                                   where obj = p_obj and mission = v_array(i));
        end loop;

        delete from t_osi_mission
              where obj = p_obj and instr(nvl(p_inv_support, 'null'), mission) = 0;
    exception
        when others then
            log_error('set_inv_support: ' || sqlerrm);
            raise;
    end set_inv_support;

    /*Returns the activity date for the current activity*/
    function get_activity_date(p_obj in varchar2)
        return date is
        v_return   date;
    begin
        select activity_date
          into v_return
          from t_osi_activity
         where SID = p_obj;

        return v_return;
    exception
        when others then
            log_error('get_activity_date: ' || sqlerrm);
            raise;
    end get_activity_date;

    /*Returns a custom error message if the object is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2) return varchar2 is

         v_status      varchar2(200) := null;
         v_count_check number := 0;
         
    begin
         if osi_auth.check_for_priv('DELETE',Core_Obj.get_objtype(p_obj))='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;
         
         v_status := upper(osi_object.get_status(p_obj));

         ---Is activity completed?---
         if v_status = 'COMPLETED' then
 
           return 'Cannot delete completed activities.';
  
         end if;

         ---Is activity closed?---
         if v_status = 'CLOSED' then
 
           return 'Cannot delete closed activities.';
  
         end if;

         ---Is Activity an Active Lead?---
         for a in (select SID from t_osi_activity
                         where SID=p_obj 
                           and nvl(creating_unit, 'NONE') <> nvl(assigned_unit, 'NONE'))
         loop

             return 'Cannot delete active leads.';

         end loop;

         ---Does the Activity Have WorkHours Associated with it?---
         select count(*) into v_count_check from t_osi_work_hours where obj=p_obj;
         if v_count_check > 0 then

           return 'Cannot delete activities with associated work hours.';

         end if;

         ---Does the Activity Have File(s) Associated with it?---
         select count(*) into v_count_check from t_osi_assoc_fle_act where activity_sid = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with associated files.';

         end if;

         ---Does the Activity Have CFund Expenses Associated with it?---
         select count(*) into v_count_check from t_cfunds_expense_v3 where parent = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with C Fund Expenses.';

         end if;

         ---Does the Activity Have Evidence Associated with it?---
         select count(*) into v_count_check from t_osi_evidence where obj = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with Evidence.';

         end if;

         ---Suspicious Activity Report specific check - must also have 'SAR.EDIT' priv --- 
         ---Only watch members may delete talons because of the talon 'states'         ---
         if core_obj.get_objtype(p_obj) = core_obj.lookup_objtype('ACT.SUSPACT_REPORT') then
        
           if osi_auth.check_for_priv('SAR.EDIT', core_obj.get_objtype(p_obj)) <> 'Y' then
        
             return 'You are not authorized to perform the requested action.';
        
           end if;
        
         end if;

         return 'Y';

    exception
        when others then
            log_error('OSI_ACTIVITY.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in OSI_ACTIVITY.Can_Delete using Object: ' || nvl(p_obj, 'NULL');

    end can_delete;

    /* Used to generate Form 40 Reports */
    function generate_form_40(p_obj in varchar2)
        return clob is
        v_ok1               varchar2(2);
        v_ok2               varchar2(10);
        v_return            clob                                    := null;
        v_return_date       date;
        v_mime_type         t_core_template.mime_type%type;
        v_mime_disp         t_core_template.mime_disposition%type;
        v_narrative_text    clob                                    := null;
        v_narrative         clob                                    := null;
        v_attachment_list   varchar2(3000)                          := null;
        v_classification    varchar2(1000)                          := null;
        v_activity_lead     varchar2(20);
        v_place             varchar2(32000);
        v_newline           varchar2(10)                            := chr(13) || chr(10);

        function get_f40_place(p_obj in varchar2)
            return varchar2 is
            v_return           varchar2(1000) := null;
            v_create_by_unit   varchar2(20);
            v_name             varchar2(100);
            v_obj_type_code    varchar2(200);
        begin
            --Note: This was originally added here for the Consultation/Coordination activity
            --If you need to add other activities, this will need to be modified.
            select creating_unit
              into v_create_by_unit
              from t_osi_activity
             where SID = p_obj;

            --Get object type code
            v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

            if v_obj_type_code like 'ACT.INTERVIEW%' then                           -- interviews --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            elsif v_obj_type_code like 'ACT.BRIEFING%' then                          -- briefings --
                select location
                  into v_return
                  from t_osi_a_briefing
                 where SID = p_obj;
            elsif v_obj_type_code like 'ACT.SOURCE%' then                         -- source meets --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            elsif v_obj_type_code like 'ACT.SEARCH%' then                             -- searches --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            elsif v_obj_type_code like 'ACT.POLY%' then                             -- polygraphs --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
--                select location
--                  into v_return
--                  from t_act_poly_exam
--                 where sid = psid;
            elsif v_obj_type_code like 'ACT.SURV%' then                             -- polygraphs --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            else
                --This is the displayed text for all other types
                v_name := osi_unit.get_name(osi_object.get_assigned_unit(p_obj));
                v_return :=
                    v_name || ', '
                    || osi_address.get_addr_display
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj)));
            end if;

            v_return := replace(v_return, chr(13) || chr(10), ' ');                        -- CRLF's
            v_return := replace(v_return, chr(10), ' ');                                     -- LF's
            v_return := rtrim(v_return, ', ');
            return v_return;
        exception
            when no_data_found then
                raise;
                return null;
        end get_f40_place;

        function get_attachment_list(p_obj in varchar2)
            return varchar2 is
            v_tmp_attachments   varchar2(30000) := null;
            v_cnt               number          := 0;
        begin
            for a in (select   description
                          from t_osi_attachment
                         where obj = p_obj
                      order by description)
            loop
                v_cnt := v_cnt + 1;

                if a.description is not null then
                    if v_cnt = 1 then
                        v_tmp_attachments := v_tmp_attachments || 'Attachments\line ';
                    end if;

                    v_tmp_attachments := v_tmp_attachments || ' - ' || a.description || '\line ';
                else
                    return null;
                end if;
            end loop;

            return v_tmp_attachments;
        end get_attachment_list;
    begin
        --Get latest template
        v_ok1 :=
             core_template.get_latest('FORM_40', v_return, v_return_date, v_mime_type, v_mime_disp);
        --Get Activity Lead
        v_activity_lead := osi_object.get_lead_agent(p_obj);

        for k in (select a.SID, a.id as act_no, a.title, a.activity_date, a.narrative,
                         osi_personnel.get_name(v_activity_lead) as act_lead_agent
                    --,a.object_type_description
                  from   v_osi_activity_summary a, v_osi_personnel_gen_info p
                   where p.SID(+) = v_activity_lead and a.SID = p_obj)
        loop
            --Get place of activity
            v_place := get_f40_place(k.SID);
            --Get classification Markings
            /*
            -->SAVE THIS CODE: May be needed later for SIPR
                        select classification_pkg.full_marking(v_parent_sid)
                          into v_classification
                          from dual;
            */
            v_ok2 := core_template.replace_tag(v_return, 'LEADAGENT_NAME', k.act_lead_agent);
            v_ok2 :=
                core_template.replace_tag(v_return,
                                          'RPT_DATE',
                                          to_char(k.activity_date, 'dd-Mon-yyyy'));
            v_ok2 := core_template.replace_tag(v_return, 'ACTIVITY_NO', k.act_no);
            v_ok2 := core_template.replace_tag(v_return, 'PLACE_OF_ACTIVITY', v_place);
            /*
            -->SAVE THIS CODE: May be needed later for SIPR
            if v_classification is not null then
                v_ok :=
                    web.template_pkg.replace_tag(v_return,
                                                 'BOILERPLATE',
                                                 v_classification,
                                                 'WEBTOK@',
                                                 true);
            end if;
            */

            -- Assemble the Narrative Header
            v_narrative :=
                v_narrative || k.title || '\par\par Date/Place: ' || k.activity_date || '/'
                || v_place || '\line\line ';
            --  Appends Attachments List
            v_attachment_list := get_attachment_list(p_obj);

            if v_attachment_list is not null then
                v_narrative := v_narrative || v_attachment_list || '\line ';
            --aitc(v_narrative, v_attachment_list || '\line ');
            end if;
        end loop;

        for k in (select narrative
                    from t_osi_activity
                   where SID = p_obj)
        loop
            v_narrative_text := osi_report.clob_replace(k.narrative, v_newline, '\line ');
        end loop;

        -- Append Narrative to variable
        dbms_lob.append(v_narrative, v_narrative_text);
        -- Appends the Narrative itself
        v_ok2 := core_template.replace_tag(v_return, 'NARRATIVE', v_narrative, 'TOKEN@', true);
        /*
        -->SAVE THIS CODE: May be needed later for SIPR
        -- Get the boilerplate ---
        if v_classification is null then
            for f in (select value
                        from t_i2ms_config
                       where code = 'F40_CAVEAT')
            loop
                begin
                    select description
                      into v_classification
                      from t_classification_hi_type
                     where code = f.value;
                exception
                    when others then
                        begin
                            select description
                              into v_classification
                              from t_classification_level
                             where code = f.value;
                        exception
                            when others then
                                v_classification := null;
                        end;
                end;
            end loop;
        end if;

        if v_classification is null then
            for f in (select value
                        from t_i2ms_config
                       where code = 'DEFAULT_CLASS')
            loop
                begin
                    select description
                      into v_classification
                      from t_classification_hi_type
                     where code = f.value;
                exception
                    when others then
                        begin
                            select description
                              into v_classification
                              from t_classification_level
                             where code = f.value;
                        exception
                            when others then
                                v_classification := f.value;
                        end;
                end;
            end loop;
        end if;

        if v_classification is null then
            v_classification := 'FOR OFFICIAL USE ONLY';
        end if;

        v_ok :=
            web.template_pkg.replace_tag(v_return,
                                         'BOILERPLATE',
                                         upper(v_classification),
                                         'WEBTOK@',
                                         true);
        */
        return v_return;
    exception
        when others then
            log_error('osi_activity.generate_form_40: ' || sqlerrm);
            raise;
    end generate_form_40;

    /* Used to generate Form 40 Reports */
    function generate_form_40_summary(p_obj in varchar2)
        return clob is
        v_ok1              varchar2(2);
        v_ok2              varchar2(10);
        v_return           clob                                    := null;
        v_return_date      date;
        v_mime_type        t_core_template.mime_type%type;
        v_mime_disp        t_core_template.mime_disposition%type;
        v_narrative_text   clob                                    := null;
        v_classification   varchar2(1000)                          := null;
        v_activity_lead    varchar2(20);
        v_place            varchar2(32000);
        v_newline          varchar2(10)                            := chr(13) || chr(10);
        v_cnt              number                                  := 0;

        function get_f40_place(p_obj in varchar2)
            return varchar2 is
            v_return           varchar2(1000) := null;
            v_create_by_unit   varchar2(20);
            v_name             varchar2(100);
            v_obj_type_code    varchar2(200);
        begin
            --Note: This was originally added here for the Consultation/Coordination activity
            --If you need to add other activities, this will need to be modified.
            select creating_unit
              into v_create_by_unit
              from t_osi_activity
             where SID = p_obj;

            --Get object type code
            v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

            if v_obj_type_code like 'ACT.INTERVIEW%' then                           -- interviews --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            elsif v_obj_type_code like 'ACT.BRIEFING%' then                          -- briefings --
                select location
                  into v_return
                  from t_osi_a_briefing
                 where SID = p_obj;
            elsif v_obj_type_code like 'ACT.SOURCE%' then                         -- source meets --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            elsif v_obj_type_code like 'ACT.SEARCH%' then                             -- searches --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            elsif v_obj_type_code like 'ACT.POLY%' then                             -- polygraphs --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
--                select location
--                  into v_return
--                  from t_act_poly_exam
--                 where sid = psid;
            elsif v_obj_type_code like 'ACT.SURV%' then                             -- polygraphs --
                v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
            else
                --This is the displayed text for all other types
                v_name := osi_unit.get_name(osi_object.get_assigned_unit(p_obj));
                v_return :=
                    v_name || ', '
                    || osi_address.get_addr_display
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj)));
            end if;

            v_return := replace(v_return, chr(13) || chr(10), ' ');                        -- CRLF's
            v_return := replace(v_return, chr(10), ' ');                                     -- LF's
            v_return := rtrim(v_return, ', ');
            return v_return;
        exception
            when no_data_found then
                raise;
                return null;
        end get_f40_place;
    begin
        --Get latest template
        v_ok1 :=
            core_template.get_latest('FORM_40_SUMMARY',
                                     v_return,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);
        --Get Activity Lead
        v_activity_lead := osi_object.get_lead_agent(p_obj);

        for k in (select a.SID, a.id as act_no, a.title, a.activity_date,
                         osi_personnel.get_name(v_activity_lead) as act_lead_agent
                    --,a.object_type_description
                  from   v_osi_activity_summary a, v_osi_personnel_gen_info p
                   where p.SID(+) = v_activity_lead and a.SID = p_obj)
        loop
            --Get place of activity
            v_place := get_f40_place(k.SID);
            --Get classification Markings
            /*
            -->SAVE THIS CODE: May be needed later for SIPR
                        select classification_pkg.full_marking(v_parent_sid)
                          into v_classification
                          from dual;
            */
            v_ok2 := core_template.replace_tag(v_return, 'LEADAGENT_NAME', k.act_lead_agent);
            v_ok2 :=
                core_template.replace_tag(v_return,
                                          'RPT_DATE',
                                          to_char(k.activity_date, 'dd-Mon-yyyy'));
            v_ok2 := core_template.replace_tag(v_return, 'ACTIVITY_NO', k.act_no);
            v_ok2 := core_template.replace_tag(v_return, 'PLACE_OF_ACTIVITY', v_place);
        /*
        -->SAVE THIS CODE: May be needed later for SIPR
        if v_classification is not null then
            v_ok :=
                web.template_pkg.replace_tag(v_return,
                                             'BOILERPLATE',
                                             v_classification,
                                             'WEBTOK@',
                                             true);
        end if;
        */
        end loop;

        for k in (select   n.note_text
                      from t_osi_note n, t_osi_note_type nt
                     where n.obj = p_obj
                       and n.note_type = nt.SID
                       and nt.description = 'Form 40 Summary Note'
                  order by n.create_on)
        loop
            v_cnt := v_cnt + 1;

            if v_cnt > 1 then
                v_narrative_text := v_narrative_text || '\par\par ';
            end if;

            v_narrative_text := v_narrative_text || v_cnt || '.  ';
            v_narrative_text :=
                       v_narrative_text || osi_report.clob_replace(k.note_text, v_newline, '\line ');
        end loop;

        -- Appends the Narrative itself
        v_ok2 := core_template.replace_tag(v_return, 'NARRATIVE', v_narrative_text, 'TOKEN@', true);
        /*
        -->SAVE THIS CODE: May be needed later for SIPR
        -- Get the boilerplate ---
        if v_classification is null then
            for f in (select value
                        from t_i2ms_config
                       where code = 'F40_CAVEAT')
            loop
                begin
                    select description
                      into v_classification
                      from t_classification_hi_type
                     where code = f.value;
                exception
                    when others then
                        begin
                            select description
                              into v_classification
                              from t_classification_level
                             where code = f.value;
                        exception
                            when others then
                                v_classification := null;
                        end;
                end;
            end loop;
        end if;

        if v_classification is null then
            for f in (select value
                        from t_i2ms_config
                       where code = 'DEFAULT_CLASS')
            loop
                begin
                    select description
                      into v_classification
                      from t_classification_hi_type
                     where code = f.value;
                exception
                    when others then
                        begin
                            select description
                              into v_classification
                              from t_classification_level
                             where code = f.value;
                        exception
                            when others then
                                v_classification := f.value;
                        end;
                end;
            end loop;
        end if;

        if v_classification is null then
            v_classification := 'FOR OFFICIAL USE ONLY';
        end if;

        v_ok :=
            web.template_pkg.replace_tag(v_return,
                                         'BOILERPLATE',
                                         upper(v_classification),
                                         'WEBTOK@',
                                         true);
        */
        return v_return;
    exception
        when others then
            log_error('osi_activity.generate_form_40_summary: ' || sqlerrm
                      || dbms_utility.format_error_backtrace);
            raise;
    end generate_form_40_summary;

    function check_writability(p_obj in varchar2)
        return varchar2 is
        v_rtn      varchar2(1000)            := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        -- begin object type specific writability check
        v_ot_rec.SID := core_obj.get_objtype(p_obj);

        select *
          into v_ot_rec
          from t_core_obj_type
         where SID = v_ot_rec.SID;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                              || '.CHECK_WRITABILITY(:OBJ); end;'
                        using out v_rtn, in p_obj;

            if v_rtn = 'N' then
                return v_rtn;
            end if;
        exception
            when others then
                null;                              -- do nothing, move on to generic activity check
        end;

        --end object type specific writability check
        if osi_object.get_status_code(p_obj) = 'CL' then
            return 'N';
        else
            return 'Y';
        end if;
    exception
        when others then
            log_error('osi_activity.check_writability: ' || sqlerrm);
            raise;
    end check_writability;

--======================================================================================================================
-- Following routines create activity object type specific documents for reporting purposes.
--======================================================================================================================
    procedure make_doc_act(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp_clob   clob;
        v_template    clob;
        v_ok          varchar2(1000);
        v_act_rec     t_osi_activity%rowtype;
    begin
        core_logger.log_it(c_pipe, '--> make_doc_act');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                           (c_pipe,
                            'ODW.Make_Doc_ACT: Activity is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                          (c_pipe,
                           'ODW.Make_Doc_ACT: Activity is LIMDIS - no document will be synthesized');
            return;
        end if;

        select *
          into v_act_rec
          from t_osi_activity
         where SID = p_sid;

        osi_object.get_template('OSI_ODW_DETAIL_ACT', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Fill in data
        v_ok := core_template.replace_tag(v_template, 'ID', v_act_rec.id);
        v_ok := core_template.replace_tag(v_template, 'TITLE', v_act_rec.title);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'NARRATIVE',
                                      core_util.html_ize(v_act_rec.narrative));
        osi_object.append_involved_participants(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'PARTICIPANTS', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        osi_object.append_attachments(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENTS', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        osi_object.append_notes(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'NOTES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        p_doc := v_template;
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_act');
    exception
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_ACT Error: ' || v_syn_error);
    end make_doc_act;

    function get_oldest_file(p_obj in varchar2)
        return varchar2 is
    begin
        for f in (select   file_sid
                      from t_osi_assoc_fle_act
                     where activity_sid = p_obj
                  order by modify_on)
        loop
            return f.file_sid;                                               -- only need first one
        end loop;

        return null;                                                          -- no associated files
    end get_oldest_file;
end osi_activity;
/

SET DEFINE OFF;

CREATE OR REPLACE package body osi_cfunds as
/******************************************************************************
   Name:     Osi_CFunds
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    24-Jun-2009 C.Hall          Created Package
    26-Jun-2009 C.Hall          Added get_tagline.
    21-Oct-2009 R.Dibble        Added get_cfunds_mgmt_url_raw
    9-Nov-2009  J.Faris         Added can_delete.
    19-Jan-2010  T.McGuffin     Added check_writability.
    24-Jan-2011 J.Faris         Added create_instance, creates a new cfunds expense object.
    02-Mar-2011 Tim Ward        CR#3705 - Added generate_expense_cover_sheet.
    02-Mar-2011 Tim Ward        CR#3722 - Added get_default_charge_unit and call it from
                                 get_cfunds_mgmt_url and get_cfunds_mgmt_url_raw.
    16-Mar-2011 Tim Ward        Added get_id function.
    18-Mar-2011  Tim Ward       CR#3731 - Privilege needs to be checked in here now since the
                                 checkForPriv from i2ms.js deleteObj function.
                                 can_delete was not checking proxy or correct status.
                                 Changed in can_delete.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_CFUNDS';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function validate_amount(p_amount in varchar2, p_mask varchar2)
        return varchar2 is
        v_err_found    varchar2(10) := 'N';
        v_amount_num   number;
    begin
        begin
            v_amount_num := to_number(p_amount, p_mask);
        exception
            when value_error then
                v_err_found := 'Y';
        end;

        -- try converting without the mask
        if (v_err_found = 'Y') then
            begin
                v_amount_num := to_number(p_amount);
            exception
                when value_error then
                    return 'N';
            end;
        end if;

        if (v_amount_num > 0) then
            return 'Y';
        elsif(v_amount_num = 0) then
            return 'Y0';
        else
            return 'N';
        end if;
    exception
        when others then
            log_error('Amount conversion error: ' || p_amount || ' ~ ' || p_mask || ' ~ ' || sqlerrm);
            return 'N';
    end validate_amount;

    function get_cfunds_url(p_obj in varchar2)
        return varchar2 is
        v_url   varchar2(200);
    begin
        select 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
               || ''',name:''' || p_obj || ''',item_names:''P' || page_num
               || '_SID'',item_values:''' || p_obj || ''',request:''OPEN''})'
          into v_url
          from t_core_dt_obj_type_page
         where obj_type = core_obj.get_objtype(p_obj) and page_function = 'OPEN';

        return v_url;
    exception
        when others then
            log_error('get_cfunds_url: ' || sqlerrm);
            return('get_funds_url: Error');
    end get_cfunds_url;

    function get_default_charge_unit return varchar2 is

         myCount           number;
         myUnit            varchar2(20);

    begin
         myUnit := osi_personnel.get_current_unit;

         while myUnit is not null
         loop
     
              select count(*) into myCount from t_cfunds_unit where sid=myUnit;
          
              if myCount = 1 then
       
                return myUnit;

              end if;

              select unit_parent into myUnit from t_osi_unit where sid=myUnit;

         end loop;

         return null;

    end get_default_charge_unit;

    function get_cfunds_mgmt_url
        return varchar2 is
        v_ticket   varchar2(200);
    begin
        --ticket_pkg.get_ticket_for_vb(core_context.personnel_sid, v_ticket);
        ticket_pkg.get_ticket(core_context.personnel_sid, v_ticket);
        return core_util.get_config('CFUNDS_URL') || '?punit=' || nvl(get_default_charge_unit,osi_personnel.get_current_unit)
               || '&' || core_util.get_config('TICKET_PARAM_NAME') || '=' || v_ticket || '"'
               || ' target=' || chr(39) || '_blank' || chr(39);
    end get_cfunds_mgmt_url;

    function get_cfunds_mgmt_url_raw
        return varchar2 is
        v_ticket   varchar2(200);
    begin
        return core_util.get_config('CFUNDS_URL') || '?punit=' || nvl(get_default_charge_unit,osi_personnel.get_current_unit);
    end get_cfunds_mgmt_url_raw;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_claimant   varchar2(120);
    begin
        select osi_personnel.get_name(claimant)
          into v_claimant
          from v_cfunds_expense_v3
         where SID = p_obj;

        return 'C-Funds Expense for ' || v_claimant;
    exception
        when others then
            log_error('get_tagline error: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function can_delete(p_obj in varchar2) return varchar2 is

         v_stat       varchar2(20);
         v_claimant   varchar2(20);
         v_ot         varchar2(20);
         v_paid_on    date;
         
    begin
         v_ot := Core_Obj.get_objtype(p_obj);

         if osi_auth.check_for_priv('DELETE',v_ot)='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;

         ---if status in New, Submitted, Approved, or Disallowed AND not paid, ok to delete---
         select status,claimant,paid_on into v_stat,v_claimant,v_paid_on from v_cfunds_expense_v3 where sid=p_obj;
         if v_stat not in ('New','Submitted','Approved','Disallowed') and v_paid_on is not null then

           return 'The Expense has already been paid to the agent, therefore it cannot be deleted.';

         end if;
         
         ---Check if this is the claimant of the expense OR has the proxy privilege.---
         if v_claimant != core_context.personnel_sid and Osi_Auth.check_for_priv('CF_PROXY', v_ot) = 'N' then 

           return 'You can only delete your own expense.';

         end if;

         return 'Y';

    exception
        when others then
            log_error('OSI_CFUNDS.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in OSI_CFUNDS.Can_Delete using Object: ' || nvl(p_obj, 'NULL');

    end can_delete;

    function check_writability(p_obj in varchar2, p_context in varchar2)
        return varchar2 is
        v_claimant          t_core_personnel.SID%type;
        v_obj_type          t_core_obj_type.SID%type;
        v_status            varchar2(50);
        v_parent_writable   varchar2(1);
    begin
        select claimant,
               cfunds_pkg.get_expense_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             paid_on,
                                             invalidated_on,
                                             repaid_on,
                                             reviewing_unit,
                                             closed_on),
               core_obj.lookup_objtype('CFUNDS_EXP'), osi_object.check_writability(parent, null)
          into v_claimant,
               v_status,
               v_obj_type, v_parent_writable
          from t_cfunds_expense_v3
         where SID = p_obj;

        if v_parent_writable = 'Y' then
            if (    (   v_claimant = core_context.personnel_sid
                     or osi_auth.check_for_priv('EXP_CRE_PROXY', v_obj_type) = 'Y')
                and v_status in('New', 'Disallowed', 'Rejected')) then
                return 'Y';
            elsif     osi_auth.check_for_priv('APPROVE_CL', v_obj_type) = 'Y'
                  and v_status in('Submitted', 'Disallowed') then
                return 'Y';
            end if;
        end if;

        return 'N';
    exception
        when no_data_found then
            return 'N';
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

    function create_instance(
        p_incurred_date             IN   DATE,
        p_charge_to_unit            IN   VARCHAR2,
        p_claimant                  IN   VARCHAR2,
        p_category                  IN   VARCHAR2,
        p_paragraph                 IN   VARCHAR2,
        p_description               IN   VARCHAR2,
        p_parent                    IN   VARCHAR2,
        p_parent_info               IN   VARCHAR2,
        p_take_from_advances        IN   NUMBER,
        p_take_from_other_sources   IN   NUMBER,
        p_receipt_disposition       IN   VARCHAR2,
        p_source_amount             IN   NUMBER,
        p_agent_amount              IN   NUMBER,
        p_conversion_rate           IN   NUMBER)
        return VARCHAR2 IS
        v_sid        T_CORE_OBJ.SID%TYPE;
        v_obj_type   VARCHAR2(20);
    begin
        v_obj_type := core_obj.lookup_objtype('CFUNDS_EXP');

        insert into t_core_obj
                    (obj_type)
             values (v_obj_type)
          returning SID
               into v_sid;

        insert into t_cfunds_expense_v3
                    (SID,
                     incurred_date,
                     charge_to_unit,
                     claimant,
                     category,
                     paragraph,
                     description,
                     parent,
                     parent_info,
                     take_from_advances,
                     take_from_other_sources,
                     receipts_disposition,
                     source_amount,
                     agent_amount,
                     conversion_rate)
             values (v_sid,
                     p_incurred_date,
                     p_charge_to_unit,
                     p_claimant,
                     p_category,
                     p_paragraph,
                     p_description,
                     p_parent,
                     p_parent_info,
                     p_take_from_advances,
                     p_take_from_other_sources,
                     p_receipt_disposition,
                     p_source_amount,
                     p_agent_amount,
                     p_conversion_rate);

        Core_Obj.bump(v_sid);
        return v_sid;
    exception
        when OTHERS then
            log_error('Error creating CFunds Expense. Error is: ' || SQLERRM);
            RAISE;
    end create_instance;

    function generate_expense_cover_sheet(p_obj in varchar2) return clob is

        v_agent             varchar2(4000);
        v_paragraph         varchar2(4000);
        v_category          varchar2(4000);
        v_date_incurred     date;
        v_expense_id        varchar2(30);
        v_charge_to_unit    varchar2(20);
        v_context           varchar2(4000);
        v_source_id         varchar2(19);
        v_source_amount     number;
        v_agent_amount      number;
        v_total_amount      number;
        v_conversion_rate   number;
        v_total_amount_us   number;
        v_description       varchar2(4000);
        v_paragraph_number  varchar2(4000);
        v_paragraph_content varchar2(4000);
        v_parent            varchar2(20);
        v_return            clob := null;
        v_fmt_cf_currency   varchar2(4000) := core_util.get_config('CFUNDS.CURRENCY');
        v_date_fmt_day      varchar2(4000) := core_util.get_config('CORE.DATE_FMT_DAY');
        v_CRLF              varchar2(4) := CHR(13) || CHR(10);

    begin

        select claimant_name,
               paragraph_number || ' - ' || paragraph_content,
               category_desc, incurred_date, voucher_no, charge_to_unit,
               parent_info, decode(source_id,null,'N/A','','N/A',source_id), source_amount,
               agent_amount, total_amount, conversion_rate,
               total_amount_us, description,
               paragraph_number,
               paragraph_content,
               parent
          into v_agent,
               v_paragraph,
               v_category, v_date_incurred, v_expense_id, v_charge_to_unit,
               v_context, v_source_id, v_source_amount,
               v_agent_amount, v_total_amount, v_conversion_rate,
               v_total_amount_us, v_description,
               v_paragraph_number,
               v_paragraph_content,
               v_parent
          from v_cfunds_expense_v3
         where sid = p_obj;


        v_return :=
            '***************************************************************' || v_CRLF
            || 'CFunds Expense Cover Sheet, printed on '
            || to_char(systimestamp, v_date_fmt_day || ' HH12:MI:SS AM') || v_CRLF
            || '***************************************************************'
            || v_CRLF || v_CRLF || 'Agent Name                 :  ' || v_agent
            || v_CRLF || v_CRLF || 'Incurred Date              :  '
            || to_char(v_date_incurred, v_date_fmt_day) || v_CRLF || v_CRLF
            || 'Expense ID                 :  ' || v_expense_id || v_CRLF
            || v_CRLF || v_CRLF || 'Unit Charged with Expense  :  '
            || osi_unit.get_name(v_charge_to_unit) || v_CRLF || v_CRLF
            || 'Paragraph                  :  ' || v_paragraph_number || ' - ' || osi_util.wordwrapfunc(v_paragraph_content, 40 - Length(v_paragraph_number) -3, v_CRLF || '                              ' || lpad(' ', Length(v_paragraph_number) + 3, ' ')) || v_CRLF || v_CRLF
            || v_CRLF || 'Category                   :  ' || v_category || v_CRLF
            || v_CRLF || 'Context                    :  ' || 'Activity: ' || osi_activity.get_id(v_parent) || ' - ' || core_obj.get_tagline(v_parent) || v_CRLF
            || v_CRLF || v_CRLF || 'Source Number              :  ' || v_source_id
            || v_CRLF || v_CRLF || 'Source Amount              :  '
            || ltrim(to_char(v_source_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || 'Agent Amount               :  '
            || ltrim(to_char(v_agent_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || '                              __________' || v_CRLF
            || 'Amount Spent               :  '
            || ltrim(to_char(v_total_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || 'Conversion Rate            :  ' || v_conversion_rate
            || v_CRLF || v_CRLF || '                              __________'
            || v_CRLF || 'Expense Amount (US Dollars):  '
            || to_char(v_total_amount_us, v_fmt_cf_currency) || v_CRLF || v_CRLF
            || v_CRLF || 'Details                    :  ' || v_description;
            
            return v_return;

    end generate_expense_cover_sheet;

    function get_id(p_obj in varchar2, p_obj_context in varchar2 := null)
        return varchar2 is
        v_id   t_cfunds_expense_v3.voucher_no%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select voucher_no
          into v_id
          from t_cfunds_expense_v3
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;
            
end osi_cfunds;
/

SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY "OSI_CFUNDS_ADV" AS
/******************************************************************************
   NAME:       OSI_CFUNDS_ADV
   PURPOSE:    Used to handle CFunds Advance objects

   REVISIONS:
   Date         Author           Description
   -----------  ---------------  ------------------------------------
   07-Oct-2009  Richard Dibble   Created this package.
   09-Nov-2009  Jason Faris      Added can_delete.
   16-Dec-2009  Richard Dibble   Modified can_delete to use the proper
                                  "get status" function
   10-Feb-2010  Tim McGuffin     Added check_writability, fixed can_delete.
   25-Mar-2010  Tim McGuffin     Added get_claimant.
   06-Oct-2010  Tim Ward         CR#3232 - Allow Rejected (Disallowed) Advances
                                  to be Submitted Again.
								  Changed in check_writability.
   16-Mar-2011  Tim Ward         Added get_id function.
   18-Mar-2011  Tim Ward        CR#3731 - Privilege needs to be checked in here now since the
                                 checkForPriv from i2ms.js deleteObj function.
                                 Changed in can_delete.
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_cfunds_adv';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    /* Given an object sid as p_obj, returns a default activity tagline */
    FUNCTION get_tagline(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(300);
    BEGIN
        FOR k IN (SELECT voucher_no, request_date, claimant
                    FROM T_CFUNDS_ADVANCE_V2
                   WHERE SID = p_obj)
        LOOP
            v_return :=
                'CFunds Advance: ' || k.voucher_no || ' - '
                || TO_CHAR(k.request_date, 'dd-Mon-yyyy') || ' - '
                || Osi_Personnel.get_name(k.claimant);
        END LOOP;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline: ' || SQLERRM);
            RETURN 'get_tagline: Error';
    END get_tagline;

    /* Will take all necessary steps to create a new instance of this type of object */
    FUNCTION create_instance(
        p_obj_type           IN   VARCHAR2,
        p_claimant           IN   VARCHAR2,
        p_requested_amount   IN   VARCHAR2,
        p_requested_unit     IN   VARCHAR2,
        p_voucher_no         IN   VARCHAR2,
        p_narrative          IN   VARCHAR2,
        p_date_of_request    IN   DATE)
        RETURN VARCHAR2 IS
        v_sid   T_CORE_OBJ.SID%TYPE;
    BEGIN
        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (p_obj_type)
          RETURNING SID
               INTO v_sid;

        INSERT INTO T_CFUNDS_ADVANCE_V2
                    (SID, voucher_no, claimant, request_date, amount_requested, narrative, unit)
             VALUES (v_sid,
                     p_voucher_no,
                     p_claimant,
                     p_date_of_request,
                     p_requested_amount,
                     p_narrative,
                     p_requested_unit);

        Core_Obj.bump(v_sid);
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('Error creating CFunds Advance. Error is: ' || SQLERRM);
            RAISE;
    END create_instance;

    FUNCTION can_delete(p_obj IN VARCHAR2) RETURN VARCHAR2 IS

         v_claimant          T_CORE_PERSONNEL.SID%TYPE;
         v_obj_type          T_CORE_OBJ_TYPE.SID%TYPE;
         v_status            VARCHAR2(50);
         v_parent_writable   VARCHAR2(1);

    BEGIN
         if osi_auth.check_for_priv('DELETE',Core_Obj.get_objtype(p_obj))='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;

         SELECT claimant,
                Cfunds_Pkg.get_advance_status(submitted_on,
                                              approved_on,
                                              rejected_on,
                                              issue_on,
                                              close_date),
                Core_Obj.lookup_objtype('CFUNDS_ADV')
           INTO v_claimant,
                v_status,
                v_obj_type
           FROM T_CFUNDS_ADVANCE_V2
          WHERE SID = p_obj;

         IF v_claimant = Core_Context.personnel_sid OR Osi_Auth.check_for_priv('CF_PROXY', v_obj_type) = 'Y' THEN

           IF v_status IN('New', 'Rejected') THEN

             RETURN 'Y';

           ELSE

             RETURN 'Cannot delete unless status is New or Rejected.';
 
           END IF;

         ELSE

           RETURN 'You can only delete your own advance.';

         END IF;

    EXCEPTION
        WHEN OTHERS THEN
            log_error('can_delete: ' || SQLERRM);
            RAISE;
    END can_delete;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_claimant          T_CORE_PERSONNEL.SID%TYPE;
        v_obj_type          T_CORE_OBJ_TYPE.SID%TYPE;
        v_status            VARCHAR2(50);
        v_parent_writable   VARCHAR2(1);
    BEGIN
        SELECT claimant,
               Cfunds_Pkg.get_advance_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             issue_on,
                                             close_date),
               Core_Obj.lookup_objtype('CFUNDS_ADV')
          INTO v_claimant,
               v_status,
               v_obj_type
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        IF (    (   v_claimant = Core_Context.personnel_sid
                 OR Osi_Auth.check_for_priv('CF_PROXY', v_obj_type) = 'Y')
            AND v_status IN('New', 'Rejected', 'Disallowed')) THEN
            RETURN 'Y';
        ELSIF     Osi_Auth.check_for_priv('APPROVE_CL', v_obj_type) = 'Y'
              AND v_status IN('Submitted', 'Rejected', 'Disallowed') THEN
            RETURN 'Y';
        END IF;

        RETURN 'N';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'N';
        WHEN OTHERS THEN
            log_error('check_writability: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION get_claimant(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_CFUNDS_ADVANCE_V2.claimant%TYPE;
    BEGIN
        SELECT claimant
          INTO v_rtn
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_claimant: ' || SQLERRM);
            RAISE;
    END get_claimant;

    function get_id(p_obj in varchar2, p_obj_context in varchar2 := null)
        return varchar2 is
        v_id   t_cfunds_advance_v2.voucher_no%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select voucher_no
          into v_id
          from t_cfunds_advance_v2
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;        

END Osi_Cfunds_Adv;
/

SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY "OSI_FILE" as
/******************************************************************************
   Name:     Osi_File
   Purpose:  Provides Functionality For File Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     7-Apr-2009 T.McGuffin      Created Package
    28-Apr-2009 T.McGuffin      Modified Get_Tagline To Only Return Title.
    27-May-2009 T.McGuffin      Added Set_Unit_Owner procedure.
    27-May-2009 T.McGuffin      Added Create_Instance function
    01-Jun-2009 T.McGuffin      Added Get_ID function.
    01-Jun-2009 R.Dibble        Added get_unit_owner
    30-Jun-2009 T.McGuffin      Phased out CORE ACL for simple Restriction.
    26-Aug-2009 M.Batdorf       Added get_assoc_file_sids, get_assoc_act_sids
                                and get_inherited_act_sids.
    15-Oct-2009 J.Faris         Added can_delete
    17-Dec-2009 T.Whitehead     Added get_full_id.
    23-Dec-2009 T.Whitehead     Added get_title.
    26-Feb-2010 T.McGuffin      Modified can_delete to use osi_object.get_lead_agent.
    30-Mar-2010 T.McGuffin      Added get_days_since_opened function.
    04-Apr-2010 R.Dibble        Modified can_delete to use codes instead of
                                 hard coded descriptions
    02-Apr-2010 R.Dibble        Added rpt_generate_form2
    05-Apr-2010 R.Dibble        Added rpt_generate_30252
                                 Added rpt_generate_30256
    18-May-2010 J.Faris         Modified can_delete to handle special processing for
                                 Security Polygraph files.
    25-May-2010 T.Leighty       Added make_doc_misc_file.
    14-Jun-2010 R.Dibble        Modified can_delete() to handle PSO File special processing
    18-Mar-2011 Tim Ward        CR#3731 - Deleting should not stop you if you are not the Lead Agent, if you
                                 have the Delete Privilege.
                                 Also, PSO Files do not have any special processing.
                                 Added FILE.SOURCE special processing.
                                 Changed can_delete().
                                 
******************************************************************************/
    c_pipe        varchar2(100)  := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_FILE';
    v_syn_error   varchar2(4000) := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_full_id(p_obj in varchar2)
        return varchar2 is
        v_full_id   t_osi_file.full_id%type;
    begin
        if p_obj is null then
            log_error('get_full_id: null value passed');
            return null;
        end if;

        for x in (select full_id
                    from t_osi_file
                   where sid = p_obj)
        loop
            return x.full_id;
        end loop;

        return null;
    exception
        when others then
            log_error('get_full_id: ' || sqlerrm);
            return null;
    end get_full_id;

    function get_id(p_obj in varchar2)
        return varchar2 is
        v_id   t_osi_file.id%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select id
          into v_id
          from t_osi_file
         where sid = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_file.title%type;
    begin
        select title
          into v_title
          from t_osi_file
         where sid = p_obj;

        return v_title;
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return 'File Summary';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    function get_title(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select title
                    from t_osi_file
                   where sid = p_obj)
        loop
            return x.title;
        end loop;

        return null;
    exception
        when others then
            log_error('get_title: ' || sqlerrm);
            return 'get_title: Error';
    end get_title;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'File Index1 XML Clob';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return 'File Status';
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    procedure set_unit_owner(
        p_obj      in   varchar2,
        p_unit     in   varchar2 := null,
        p_reason   in   varchar2 := null) is
        v_unit     t_osi_unit.sid%type;
        v_reason   t_osi_f_unit.reason%type   := null;
    begin
        v_unit := nvl(p_unit, osi_personnel.get_current_unit(core_context.personnel_sid));

        if p_obj is not null and v_unit is not null then
            update t_osi_f_unit
               set end_date = sysdate
             where file_sid = p_obj;

            if p_reason is null then
                if sql%rowcount = 0 then
                    v_reason := 'Initial Owner';
                end if;
            else
                v_reason := p_reason;
            end if;

            insert into t_osi_f_unit
                        (file_sid, unit_sid, start_date, reason)
                 values (p_obj, v_unit, sysdate, v_reason);
        end if;
    exception
        when others then
            log_error('set_unit_owner: ' || sqlerrm);
            raise;
    end set_unit_owner;

    /* Given an Object, it return the owning unit */
    function get_unit_owner(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_f_unit.unit_sid%type;
    begin
        select unit_sid
          into v_return
          from t_osi_f_unit
         where file_sid = p_obj and end_date is null;

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_unit_owner: ' || sqlerrm);
            raise;
    end get_unit_owner;

    function create_instance(p_obj_type in varchar2, p_title in varchar2, p_restriction in varchar2)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
    begin
        insert into t_core_obj
                    (obj_type)
             values (p_obj_type)
          returning sid
               into v_sid;

        insert into t_osi_file
                    (sid, title, id, restriction)
             values (v_sid, p_title, osi_object.get_next_id, p_restriction);

        --Set the starting status
        osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type),
                                       'Created');
        --Create the Lead Assignment
        osi_object.create_lead_assignment(v_sid);
        --Set the owning unit
        osi_file.set_unit_owner(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    function get_assoc_file_sids(p_obj in varchar2)
        return varchar2 is
        v_rtn   varchar2(30000) := '';
    begin
        for af in (select that_file
                     from v_osi_assoc_fle_fle_raw
                    where this_file = p_obj)
        loop
            if not core_list.find_item_in_list(af.that_file, v_rtn) then
                if not core_list.add_item_to_list(af.that_file, v_rtn) then
                    -- it's not in the list but adding did not work
                    core_logger.log_it(c_pipe,
                                       'get_assoc_file_sids - Adding ' || af.that_file
                                       || ' to the list for obj ' || p_obj || ' did not work.');
                end if;
            end if;
        end loop;

        return v_rtn;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_assoc_file_sids: ' || sqlerrm);
            return null;
    end get_assoc_file_sids;

    function get_assoc_act_sids(p_obj in varchar2)
        return varchar2 is
        v_rtn   varchar2(30000) := '';
    begin
        for aa in (select activity_sid
                     from t_osi_assoc_fle_act
                    where file_sid = p_obj)
        loop
            if not core_list.find_item_in_list(aa.activity_sid, v_rtn) then
                if not core_list.add_item_to_list(aa.activity_sid, v_rtn) then
                    -- it's not in the list but adding did not work
                    core_logger.log_it(c_pipe,
                                       'get_assoc_act_sids - Adding ' || aa.activity_sid
                                       || ' to the list for obj ' || p_obj || ' did not work.');
                end if;
            end if;
        end loop;

        return v_rtn;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_assoc_act_sids: ' || sqlerrm);
            return null;
    end get_assoc_act_sids;

    function get_inherited_act_sids(p_obj in varchar2)
        return varchar2 is
        v_assoc_file_list    varchar2(4000);
        v_file_act_list      varchar2(4000);
        v_inherit_act_list   varchar2(4000);
        v_temp_act_list      varchar2(4000);
        v_int                number         := 0;
        v_int2               number         := 0;
        v_file_item          varchar2(20);
        v_act_item           varchar2(20);
        v_file_count         number         := 0;
        v_act_count          number         := 0;
    begin
        v_assoc_file_list := get_assoc_file_sids(p_obj);
        v_file_count := core_list.count_list_elements(v_assoc_file_list);

        for v_int in 1 .. v_file_count
        loop
            v_file_item := core_list.pop_list_item(v_assoc_file_list);
            v_temp_act_list := get_assoc_act_sids(v_file_item);
            v_file_act_list := v_temp_act_list;
            v_act_count := core_list.count_list_elements(v_temp_act_list);

            for v_int2 in 1 .. v_act_count
            loop
                v_act_item := core_list.get_list_element(v_temp_act_list, v_int2);

                if core_list.find_item_in_list(v_act_item, v_inherit_act_list) then
                    if not core_list.remove_item_from_list(v_act_item, v_file_act_list) then
                        core_logger.log_it(c_pipe,
                                           'get_inherited_act_sids: could not remove ' || v_act_item
                                           || ' from list ' || v_temp_act_list);
                    end if;
                end if;
            end loop;

            v_inherit_act_list := v_inherit_act_list || v_file_act_list;
            v_inherit_act_list := replace(v_inherit_act_list, '~~', '~');
        end loop;

        return v_inherit_act_list;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_inherited_act_sids: ' || sqlerrm);
            return null;
    end get_inherited_act_sids;

    function can_delete(p_obj in varchar2) return varchar2 is

            v_stat            varchar2(200);
            v_lead            varchar2(20);
            v_obj_type        varchar2(200);
            v_obj_type_code   varchar2(1000);
            v_last_TM_sh_sid  varchar2(1000);
            v_count_check     number;

    begin
         /* Note: This function can be used by *most* files.  If you find you
                  have a file that needs further special processing, we may
                  have to break can_delete() functions out into individual
                  object packages. - Richard Dibble 04/01/2010

         */

         ---Get Status Code and Object Type---
         v_stat := osi_object.get_status_code(p_obj);
         v_obj_type := core_obj.get_objtype(p_obj);
         v_obj_type_code := osi_object.get_objtype_code(v_obj_type);
         
         case v_obj_type_code
             
             ---Special case for Agent Application File (110)---
             when 'FILE.AAPP' then
                 
                 select count(*) into v_count_check from v_osi_f_aapp_file_obj_act where file_sid=p_obj;
                 if v_count_check > 0 then
                   
                   return 'You are not allowed to delete this file when there are ''Associated Activities that Support Objectives'', please remove them from the [Details] tab.';
                   
                 end if;

             ---Special case for Security Polygraph Files---
             when 'FILE.POLY_FILE.SEC' then

                 if v_stat in('CL', 'SV', 'RV', 'AV') then
 
                   return 'You cannot delete this file with status of ' || osi_object.get_status(p_obj) || '.';
 
                 end if;

             ---Special case for Source Files---
             when 'FILE.SOURCE' then

                 if v_stat in('PO', 'AA') then
                   
                   begin
                        select nvl(osi_status.last_sh_sid(p_obj, 'TM'),'~~~never terminated~~~') into v_last_TM_sh_sid FROM DUAL;
                        
                   exception when others then
                   
                            v_last_TM_sh_sid := '~~~never terminated~~~';
                             
                   end;
                   
                   if v_last_TM_sh_sid != '~~~never terminated~~~' then

                     return 'You cannot delete a soruce that has already been an Active source in the past.';

                   end if;
                   
                 else
                 
                   return 'You cannot delete this file with status of ' || osi_object.get_status(p_obj) || '.';
 
                 end if;
                 
                 select count(*) into v_count_check from t_osi_activity where source=p_obj;
                 if v_count_check > 0 then
                   
                   return 'You cannot delete a source used in an activity.';
                   
                 end if;
                 
                 select count(*) into v_count_check from t_osi_assoc_fle_act where activity_sid in(select sid from t_osi_activity where source=p_obj);
                 -------(pending Collection Requirements/Emphasis inclusion in WebI2MS)SID in (select CRCE from T_CR_USAGE where MEET in (select SID from T_ACTIVITY where SOURCE = :BO))
                 -------(pending IR inclusion in WebI2MS)SID in (select IR from T_IR_SOURCE where OSI_SOURCE = :BO)
                 if v_count_check > 0 then
                   
                   return 'You cannot delete a source used in a file.';
                   
                 end if;

             ---All others Files---
             else

               ---Is file in "NW", "AA" status? Otherwise No delete---
               if v_stat not in('NW', 'AA') then

                 return 'You cannot delete a file with status of ' || osi_object.get_status(p_obj) || '.';

               end if;
               
         end case;

         ---Is Current User the lead agent?---
         if (core_context.personnel_sid = osi_object.get_lead_agent(p_obj)) then

           return 'Y';

         else

           ---User is NOT lead agent, so see if they have "Delete" priv.---
           if (osi_auth.check_for_priv('DELETE', v_obj_type) = 'Y') then

             ---User has the priv, so they can delete---
             return 'Y';

           end if;

           return 'You are not authorized to perform the requested action.';

         end if;

    exception
        when others then
            log_error('OSI_FILE.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in OSI_FILE.Can_Delete using Object: ' || nvl(p_obj, 'NULL');

    end can_delete;

    function get_days_since_opened(p_obj in varchar2)
        return number is
        v_days          number;
        v_last_status   varchar2(100);
    begin
        v_last_status := upper(osi_object.get_status_code(p_obj));

        if v_last_status != 'OP' then
            v_days := 0;
        else
            v_days := floor(sysdate - osi_status.last_sh_date(p_obj, 'OP'));
        end if;

        return v_days;
    exception
        when others then
            log_error('osi_file.get_days_since_opened: ' || sqlerrm);
            raise;
    end get_days_since_opened;

    /* Used to generate the Form2 report */
    function rpt_generate_form2(p_obj in varchar2)
        return clob is
        v_placeholder      varchar2(200);
        --This is only for holding place of items that are not complete
        v_ok               varchar2(2000);
        v_return_date      date;
        v_return           clob;
        v_mime_type        t_core_template.mime_type%type;
        v_mime_disp        t_core_template.mime_disposition%type;
        v_classification   varchar2(100);
        v_cust_label       varchar2(1000);
        v_date_opened      date;
        v_date_closed      date;
        v_file_count       number;
    begin
        --Get latest template
        v_ok :=
              core_template.get_latest('FORM_2', v_return, v_return_date, v_mime_type, v_mime_disp);
        --- Retrieve Classification Level  (U=Unclassified, C=Confidential, and S=Secret) ---
        v_classification := osi_classification.get_report_class(p_obj);

        --- If Object is NOT Classified, and NO Default is found, Default to the HIGHEST ---
        if (   v_classification is null
            or v_classification = '') then
            v_classification := 'S';
        end if;

        --- Get Customer Label ---
        v_cust_label := core_util.get_config('OSI.CUSTLABEL');
        v_ok :=
            core_template.replace_tag(v_return,
                                      'FILETYPE',
                                      v_cust_label || ' '
                                      || osi_object.get_objtype_desc(core_obj.get_objtype(p_obj))
                                      || ' FILE');
        v_ok :=
            core_template.replace_tag(v_return,
                                      'ID',
                                      '*' || osi_object.get_id(p_obj, null) || '*',
                                      p_multiple       => true);

        if (osi_file.get_full_id(p_obj) is null) then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FULL_ID',
                                          osi_object.get_id(p_obj, null),
                                          p_multiple       => true);
        else
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FULL_ID',
                                          osi_file.get_full_id(p_obj),
                                          p_multiple       => true);
        end if;

        --- Get Date Opened ---
        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            v_date_opened := osi_status.first_sh_date(p_obj, 'AC');
        else
            v_date_opened := osi_status.first_sh_date(p_obj, 'OP');
        end if;

        v_ok := core_template.replace_tag(v_return, 'DOPENED', to_char(v_date_opened, 'YYYYMMDD'));

        --- Get Date Closed ---
        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            v_date_closed := osi_status.last_sh_date(p_obj, 'TM');
        else
            v_date_closed := osi_status.last_sh_date(p_obj, 'CL');
        end if;

        v_ok := core_template.replace_tag(v_return, 'DCLOSED', to_char(v_date_closed, 'YYYYMMDD'));
        --- Get Location Information ---
        v_ok :=
            core_template.replace_tag
                (v_return,
                 'LOCATION',
                 osi_unit.get_name(osi_object.get_assigned_unit(p_obj)) || ' '
                 || core_list.get_list_element
                       (osi_address.get_addr_fields
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),
                                                               'UNIT_ADDR')),
                        3)
                 || ','
                 || dibrs_reference.get_state_desc
                       (core_list.get_list_element
                            (osi_address.get_addr_fields
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),
                                                               'UNIT_ADDR')),
                             4))
                 || ','
                 || dibrs_reference.get_country_desc
                       (core_list.get_list_element
                            (osi_address.get_addr_fields
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),
                                                               'UNIT_ADDR')),
                             6)));
        --- Get Related Files ---
        v_file_count := 1;

        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            for x in (select   nvl(file_full_id, file_id) as id
                          from v_osi_file
                         where (sid in(select file_sid
                                         from v_osi_assoc_fle_act
                                        where activity_sid in(select sid
                                                                from t_osi_activity
                                                               where source = p_obj)))
                      order by id)
            loop
                v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, x.id);
                v_file_count := v_file_count + 1;

                if (v_file_count > 5) then
                    exit;
                end if;
            end loop;
        else
            for k in (select   nvl(that_file_full_id, that_file_id) as id
                          from v_osi_assoc_fle_fle
                         where this_file = p_obj
                      order by that_file_id)
            loop
                v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, k.id);
                v_file_count := v_file_count + 1;

                if (v_file_count > 5) then
                    exit;
                end if;
            end loop;
        end if;

        --- If there aren't 5 files, make the WEBTOK@FILE#'s that remain blank ---
        loop
            exit when v_file_count > 5;
            v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, '');
            v_file_count := v_file_count + 1;
        end loop;

        --- Set form Information ---
        if (v_classification = 'U') then
            v_ok :=
                core_template.replace_tag
                                       (v_return,
                                        'CLASS',
                                        '\b\f36\fs48\cf11 ' || chr(13) || chr(10)
                                        || 'UNCLASSIFIED//FOR OFFICIAL USE ONLY \b\f36\fs48\cf11 '
                                        || chr(13) || chr(10) || '\par \b\f1\fs36\cf11 ',
                                        p_multiple       => true);
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2A, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok := core_template.replace_tag(v_return, 'FORM_MESSAGE', '', p_multiple => true);
        elsif v_classification = 'C' then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'CLASS',
                                          '\b\f1\fs12\cf8 ' || chr(13) || chr(10)
                                          || '\par \b\f1\fs72\cf8 C O N F I D E N T I A L',
                                          p_multiple       => true);
            v_return := replace(v_return, '\clcbpat8', '\clcbpat2');
            v_return := replace(v_return, '\clcbpatraw8', '\clcbpatraw2');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2B, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORM_MESSAGE',
                                          '(Form is UNCLASSIFIED when attachments are removed)',
                                          p_multiple       => true);
        elsif v_classification = 'S' then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'CLASS',
                                          '\b\f1\fs12\cf8 ' || chr(13) || chr(10)
                                          || '\par \b\f1\fs72\cf8 S    E    C    R    E    T',
                                          p_multiple       => true);
            v_return := replace(v_return, '\clcbpat8', '\clcbpat6');
            v_return := replace(v_return, '\clcbpatraw8', '\clcbpatraw6');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2C, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORM_MESSAGE',
                                          '(Form is UNCLASSIFIED when attachments are removed)',
                                          p_multiple       => true);
        end if;

        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_form2: ' || sqlerrm);
            raise;
    end rpt_generate_form2;

    /* Used to generate the File Barcode Label (Label # 30252) report */
    function rpt_generate_30252(p_obj in varchar2)
        return clob is
        v_ok            varchar2(2000);
        v_return_date   date;
        v_return        clob;
        v_mime_type     t_core_template.mime_type%type;
        v_mime_disp     t_core_template.mime_disposition%type;
        v_placeholder   varchar2(200);
        v_id            t_osi_file.id%type;
        v_full_id       t_osi_file.full_id%type;
    begin
        --Get latest template
        v_ok :=
            core_template.get_latest('LABEL_FILE_30252',
                                     v_return,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);

        --Get ID and FULL ID
        select id, full_id
          into v_id, v_full_id
          from t_osi_file
         where sid = p_obj;

        --Write FULL_ID
        if (v_full_id is null) then
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_id);
        else
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_full_id);
        end if;

        --Write ID
        v_ok := core_template.replace_tag(v_return, 'ID', '*' || v_id || '*', p_multiple => true);
        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_30252: ' || sqlerrm);
            raise;
    end rpt_generate_30252;

    /* Used to generate the File Barcode Label (Label # 30252) report */
    function rpt_generate_30256(p_obj in varchar2)
        return clob is
        v_ok              varchar2(2000);
        v_return_date     date;
        v_return          clob;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_placeholder     varchar2(200);
        --v_id            t_osi_file.ID%TYPE;
        --v_full_id       t_osi_file.full_id%TYPE;
        v_file_type       varchar2(200);
        v_id              varchar2(200);
        v_full_id         varchar2(200);
        v_tempstring      clob;
        v_offense_count   number;
        v_subject_count   number;
    begin
        --Get latest template
        v_ok :=
            core_template.get_latest('FORM_3986_LABEL',
                                     v_return,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);

        select upper(file_type_desc), file_id, file_full_id
          into v_file_type, v_id, v_full_id
          from v_osi_file
         where sid = p_obj;

        --- Header Information ---
        v_ok := core_template.replace_tag(v_return, 'FILETYPE', 'I2MS ' || v_file_type || ' FILE');
        --Offenses
        v_offense_count := 0;

        for k in (select offense_desc
                    from v_osi_f_inv_offense
                   where investigation = p_obj and priority_desc = 'Primary')
        loop
            v_ok := core_template.replace_tag(v_return, 'OFFENSE', k.offense_desc);
            v_offense_count := v_offense_count + 1;
        end loop;

        --If no offenses exist, then replace tag with nothing.
        if (v_offense_count = 0) then
            v_ok := core_template.replace_tag(v_return, 'OFFENSE', '');
        end if;

        --- Footer Information ---
        v_ok := core_template.replace_tag(v_return, 'ID', '*' || v_id || '*', p_multiple => true);

        if (v_full_id is null) then
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_id, p_multiple => true);
        else
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_full_id, p_multiple => true);
        end if;

        v_subject_count := 1;

        --IF pobjtypecode != 'SRC'
        --THEN
        if (osi_object.get_objtype_code(core_obj.get_objtype(p_obj)) != 'FILE.SOURCE') then
            --- Subjects Header ---
            v_tempstring := '\viewkind1\uc1\pard\b\f1\fs20 Subjects:\par';
        end if;

        for k in
            (select osi_participant.get_name(participant_version) as the_name,
                    osi_participant.get_number(participant_version,
                                               'SSN') as social_security_number,
                    osi_object.get_objtype_code
                             (osi_participant.get_type_sid(participant_version))
                                                                                as person_type_code
               from v_osi_partic_file_involvement
              where file_sid = p_obj and role in('Subject', 'Examinee'))
        loop
            --- Black Line ---
            v_tempstring :=
                v_tempstring
                || '\viewkind1\uc1\trowd\trgaph108\trleft-108\trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';
            v_tempstring :=
                v_tempstring
                || '\clbrdrb\brdrw30\brdrs \cellx3290\pard\intbl\nowidctlpar\b\f1\fs4\cell\row\pard\nowidctlpar\b0\f0\fs24';
            --- Name and Social Security Number ---
            v_tempstring :=
                v_tempstring
                || '\viewkind1\uc1\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';
            v_tempstring :=
                v_tempstring || '\cellx3290\pard\intbl\b\f1\fs20 '
                || ltrim(rtrim(upper(k.the_name)))
                || '\cell\row\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';

            if (k.person_type_code = 'PART.INDIV') then
                v_tempstring :=
                    v_tempstring || '\cellx3290\pard\intbl ' || 'SSN: ' || k.social_security_number
                    || '\cell\row\pard';
            else
                v_tempstring := v_tempstring || '\cellx3290\pard\intbl \cell\row\pard';
            end if;

            v_subject_count := v_subject_count + 1;

            if v_subject_count > 3 then
                exit;
            end if;
        end loop;

        v_ok := core_template.replace_tag(v_return, 'SUBJECTS', v_tempstring);
        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_30256: ' || sqlerrm);
            raise;
    end rpt_generate_30256;

    /* Given an Object SID, will return the proper FULL_ID */
    function generate_full_id(p_obj in varchar2)
        return varchar2 is
        v_ot_code   t_core_obj_type.code%type;
        v_return    t_osi_file.full_id%type;
    begin
        select ot.code
          into v_ot_code
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_obj and ot.sid = o.obj_type;

        /* Developers Note: (By Richard Dibble)
        The arcitecture for handling Full ID's was discussed on 04/02/2010 by Richard Dibble and Tim McGuffin.
        Ultimately we would like to centralize the creation of full ID's.
         To do this we need the equivalent to the I2MS.T_FILE_TYPE.FULL_ID_TAG column (probably in the T_OSI_OBJECT_TYPE table)
        Also, since most file Full ID's are similiar, we discussed using the CASE statement below just for special cases, and the ELSE would handle non-special cases.
         But, since we need the FULL_ID_TAG field, which we do not have, we are leaving this function
         as it is now, and will modify it later to properly handle Full ID integration across all objects.
         This was the Recommendation of Tim McGuffin - 04/02/2010

        */
        case
            when v_ot_code like 'FILE.INV%' then
                v_return := osi_investigation.generate_full_id(p_obj);
            when v_ot_code like 'FILE.PSO%' then
                v_return := osi_pso.generate_full_id(p_obj);
            else
                v_return := null;
        end case;

        return v_return;
    exception
        when others then
            log_error('osi_file.generate_full_id: ' || sqlerrm);
            raise;
    end generate_full_id;

--======================================================================================================================
-- This is a catch all to make a html page based on those type of files that are not
-- Participants, Case files, or Activities.  If the are found then put a page out with
-- minimum information.
--======================================================================================================================
    procedure make_doc_misc_file(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp_clob          clob;
        v_template           clob;
        v_file_id            v_osi_file.file_id%type;
        v_title              t_core_obj_type.description%type;
        v_sid                t_core_obj.sid%type;
        v_type_description   t_core_obj_type.description%type;
        v_ok                 varchar2(1000);                 -- flag indicating success or failure.
        v_template_date      date;               -- date of the most recent version of the template
    begin
        core_logger.log_it(c_pipe, '--> make_doc_misc_file');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                         (c_pipe,
                          'ODW.Make_Doc_Misc_File: File is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                        (c_pipe,
                         'ODW.Make_Doc_Misc_File: File is LIMDIS - no document will be synthesized');
            return;
        end if;

        select osf.file_id, obt.description as title, osf.sid, obt.description as type_description
          into v_file_id, v_title, v_sid, v_type_description
          from v_osi_file osf, t_core_obj ob, t_core_obj_type obt
         where osf.sid = p_sid and osf.sid = ob.sid and ob.obj_type = obt.sid;

        osi_object.get_template('OSI_ODW_DETAIL_MISC_FILE', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Fill in data
        v_ok := core_template.replace_tag(v_template, 'ID', v_file_id);

        if v_title is not null then
            v_ok := core_template.replace_tag(v_template, 'TITLE', v_title);
        else
            v_ok := core_template.replace_tag(v_template, 'TITLE', v_sid);
        end if;

        v_ok := core_template.replace_tag(v_template, 'TYPE', v_type_description);
        -- get Attachment Descriptions
        osi_object.append_attachments(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENT_DESC', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- return the completed template
        dbms_lob.append(p_doc, v_template);
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_misc_file');
    exception
        when no_data_found then
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_Misc_File Error: Non File SID Encountered.');
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_Misc_File Error: ' || v_syn_error);
    end make_doc_misc_file;
end osi_file;
/

SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY Osi_Participant AS
/******************************************************************************
   name:     osi_participant
   purpose:  provides functionality for participant objects.

   revisions:
    date         author          description
    ----------   --------------  ------------------------------------
     12-may-2009 t.whitehead     Created this package.
     01-jun-2009 t.whitehead     Added create_nonindiv_instance.
     02-jun-2009 t.whitehead     Added Set_Current_Name.
     08-jun-2009 t.whitehead     Added Get_Subtype.
     15-jun-2009 t.whitehead     Added get_address_data, get_birth_city,
                                  get_birth_country, get_birth_state, get_number.
     16-jun-2009 t.whitehead     Added get_confirmation.
     22-jun-2009 t.whitehead     Added set_clearance.
     08-jul-2009 t.whitehead     Added set_current_address.
     20-jul-2009 t.whitehead     Added dob and sex params to create_instance.
     23-jul-2009 t.whitehead     Added p_acronym to create_nonindiv_instance.
     31-jul-2009 t.whitehead     Added get_relation_specifics, get_type_lov.
     10-aug-2009 t.whitehead     Modified get_name to consider versioning.
     11-aug-2009 t.whitehead     Modified the remaining functions that need to
                                 consider versioning.
     14-aug-2009 t.whitehead     Added get/set _address_sid, get_current_version,
                                 get_birth_address_sid methods.
     03-sep-2009 t.whitehead     Added get_subtype_sid, get_mil_member_name.
     04-sep-2009 t.whitehead     Added get_org_member_name.
     17-sep-2009 t.whitehead     Added get_next/previous_version, add/delete_version,
                                 get_participant.
     18-sep-2009 t.whitehead     Added is_confirmed.
     23-sep-2009 t.whitehead     Added get_version_label.
     05-oct-2009 t.whitehead     Added get/set_image_sid.
     09-oct-2009 t.whitehead     Added get_id.
     12-oct-2009 t.whitehead     Added an optional parameter to get_version_label.
     28-oct-2009 t.whitehead     Added has_isn_number.
     03-nov-2009 t.whitehead     Added get_create_menu.
     09-nov-2009 j.faris         Added can_delete.
     13-nov-2009 t.whitehead     Added p_omit_sa to get_details. This parameter is null by default
                                 and will cause the function to return all information about an
                                 individual. If you pass anything in for this parameter then
                                 service affiliation data will not be included in the details.
     11-dec-2009 t.whitehead     Added get_birth_country_code.
     31-dec-2009 t.whitehead     Added run_report_details.
     13-jan-2009 t.whitehead     Added check_writability.
     21-jan-2010 j.faris         Modified get_type_lov a accept an optional type list parameter.
     25-jan-2010 t.whitehead     Added remap_org_names.
     03-feb-2010 t.whitehead     Moved confirm, unconfirm from osi_status_proc.
     04-feb-2010 t.whitehead     Added check_for_matches.
     11-feb-2010 t.whitehead     Added check_for_duplicates.
     16-feb-2010 t.whitehead     Added get_confirm_messages, get_confirm_session. After calling
                                 check_for_duplicates calling get_confirm_messages returns any messages
                                 that would explain why check_for_duplicates returned null and
                                 get_confirm_session returns either null or a session sid.
     17-feb-2010 r.dibble        Added get_inv_type_sid
     19-feb-2010 t.whitehead     Added replace_with.
     21-apr-2010 t.whitehead     Added get_birth_state_code, get_contact_value.
     07-jun-2010 t.mcguffin      Added logging to DEERS query code.
     11-jun-2010 t.whitehead     Added get_rank.
     14-jun-2010 j.horne         Updated get_org_member_name to return sid of organization, changed name to
                                 get_org_member. Added get_org_member_addr.
     11-aug-2010 t.whitehead     Added get_type.
     23-aug-2010 r.dibble        Added import_legacy_participant
                                 Modified check_for_matches to search legacy participants
     25-aug-2010 r.dibble        Added get_legacy_part_details, get_legacy_part_names
     27-aug-2010 r.dibble        Modified import_legacy_participant to handle all versions
                                 Added import_legacy_part_version
     03-sep-2010 r.dibble        Added get_max_allowed_for_role, get_num_part_in_role
     08-sep-2010 t.whitehead     Updated the unconfirm procedure to automatically add a note.
     27-sep-2010 r.dibble        Fixed minor issue with import_legacy_participant() for note category handling
     18-sep-2010 r.dibble        Added these_details_are_editable
     19-Sep-2010 r.dibble        Modified import_legacy_participant to handle new attachments architecture
                                  as well as handle the DETAILS_LOCK functionality.
     11-Nov-2010 j.horne         Updated get_org_member.  Removed join to t_osi_partic_relation and added
                                 v_osi_partic_relation_2way
     24-Nov-2010 Tim Ward        Changed import_legacy_participant to use Global Temporary Tables for
                                  both Notes and Attachments to avoid the ora-22992 error that occurs when
                                  trying to get records with LOBs accross Database Links.
     08-Jan-2011 Tim Ward        Changed check_for_duplicates to not set v_confirm_allowed := 'N' when v_session
                                  is null, causing the function to return 'N' when it shouldn't.
     14-Jan-2011 j.horne         Updated run_report_details so SQL to get relationships used participant SID
                                  and not participant version sid. Updated SQL for images to look at SEQ.
     20-Jan-2011 j.horne         Added procedure reorder_partic_images and partic_image_sort
     24-Jan-2011 Tim Ward        Added Is_Married Function.
     24-Jan-2011 Tim Ward        Changed get_address_date to use V_OSI_PARTIC_ADDRESS and added DISPLAY as a return type.
     15-Feb-2011 Tim Ward        Fixed Is_Married still had a hard coded sid.
     16-Feb-2011 Tim Ward        Fixed import_legacy_participant to use the Legacy Attach_by and Attach_date as the new
                                  Create_by and Create_on.
     24-Feb-2011 j.faris         Fixed the ethnicity mapping in import_legacy_participant.
     28-Feb-2011 Tim Ward        Changed CASE k.addr_type to CASE upper(k.addr_type) in import_legacy_participant.
                                  This gets rid of an "ORA-06592" error that was happening when the type returned
                                  was 'Permanent' instead of 'PERMANENT'.
     18-Mar-2011 Tim Ward        CR#3731 - Privilege needs to be checked in here now since the
                                  checkForPriv from i2ms.js deleteObj function.
                                  Changed for loops to select count(*).
                                  Changed in can_delete.

******************************************************************************/
    c_pipe          VARCHAR2(100)   := Core_Util.get_config('CORE.PIPE_PREFIX')
                                       || 'OSI_PARTICIPANT';
    v_address_sid   T_OSI_PARTIC_ADDRESS.SID%TYPE;
    v_image_sid     T_OSI_ATTACHMENT.SID%TYPE;
    v_messages      VARCHAR2(2000);
    v_session       VARCHAR2(20);

    /*
     * Private functions first.
     */
    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    /*
     * Public functions.
     */
    FUNCTION add_version(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_new_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_old_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_obj           T_OSI_PARTICIPANT.SID%TYPE;
        v_type          T_CORE_OBJ_TYPE.code%TYPE;
        v_sql           VARCHAR2(4000);
        v_table         VARCHAR2(100);
        v_current       VARCHAR2(20);
        v_temp          VARCHAR2(20);

        /*
         * Get the timestamp trigger name for the given table.
         */
        FUNCTION get_ts_trigger_script(p_table_name IN VARCHAR2, p_on_off IN VARCHAR2 := NULL)
            RETURN VARCHAR2 IS
            v_trig   VARCHAR2(256);
            v_rtn    VARCHAR2(300);
        BEGIN
            SELECT trigger_name
              INTO v_trig
              FROM USER_TRIGGERS
             WHERE table_name = p_table_name AND trigger_name LIKE '%_TS';

            SELECT 'alter trigger ' || v_trig || DECODE(p_on_off, NULL, ' disable', ' enable')
              INTO v_rtn
              FROM dual;

            RETURN v_rtn;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN NULL;
            WHEN OTHERS THEN
                log_error('get_ts_trigger_script: ' || SQLERRM);
                RETURN 'get_ts_trigger_script: ' || SQLERRM;
        END get_ts_trigger_script;

        /*
         * This function return a DML string that will copy all the data from a given table for
         * one version (p_old_version) into records for a new version (p_new_version).
         */
        FUNCTION get_duplicate_sql(
            p_table_name    IN   VARCHAR2,
            p_new_version   IN   VARCHAR2,
            p_old_version   IN   VARCHAR2)
            RETURN VARCHAR2 IS
            v_sql       VARCHAR2(4000)
                                     := 'insert into ' || p_table_name || ' (participant_version, ';
            v_rtn       VARCHAR2(4000);
            v_columns   VARCHAR2(4000);
        BEGIN
            FOR i IN (SELECT LOWER(column_name) AS column_name
                        FROM USER_TAB_COLUMNS
                       WHERE table_name = p_table_name
                         AND LOWER(column_name) NOT IN('sid', 'participant_version', 'obj'))
            LOOP
                v_columns := v_columns || i.column_name || ', ';
            END LOOP;

            v_columns := RTRIM(v_columns, ', ');
            v_sql :=
                v_sql || v_columns || ') select ''' || p_new_version || ''', ' || v_columns
                || ' from ' || p_table_name || ' where participant_version = ''' || p_old_version
                || '''';
            v_rtn := v_rtn || v_sql;
            RETURN v_rtn;
        END get_duplicate_sql;
    BEGIN
        v_obj := p_obj;
        -- Get the current version sid.
        v_old_version := get_current_version(v_obj);

        -- Get the new version sid.
        INSERT INTO T_OSI_PARTICIPANT_VERSION
                    (participant)
             VALUES (v_obj)
          RETURNING SID
               INTO v_new_version;

        -- Determine if this is an individual or not.
        SELECT ot.code
          INTO v_type
          FROM T_CORE_OBJ o, T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_obj AND o.obj_type = ot.SID;

        -- Name and Address versioning apply to individuals, organizations and companies.

        -- Names data.
        BEGIN
            v_table := 'T_OSI_PARTIC_NAME';

            -- Get the current name.
            SELECT current_name
              INTO v_current
              FROM T_OSI_PARTICIPANT_VERSION
             WHERE SID = v_old_version;

            -- Disable the timestamp trigger to preserve the original timestamp.
            EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

            -- Copy all the existing names except for the "current" one.
            v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
            v_sql := v_sql || ' and sid <> ''' || v_current || '''';

            EXECUTE IMMEDIATE v_sql;

            -- Now we'll do the "current" name manually.
            FOR x IN (SELECT name_type, title, last_name, first_name, middle_name, cadency,
                             create_by, create_on, modify_by, modify_on
                        FROM T_OSI_PARTIC_NAME
                       WHERE SID = v_current)
            LOOP
                INSERT INTO T_OSI_PARTIC_NAME
                            (participant_version,
                             name_type,
                             title,
                             last_name,
                             first_name,
                             middle_name,
                             cadency,
                             create_by,
                             create_on,
                             modify_by,
                             modify_on)
                     VALUES (v_new_version,
                             x.name_type,
                             x.title,
                             x.last_name,
                             x.first_name,
                             x.middle_name,
                             x.cadency,
                             x.create_by,
                             x.create_on,
                             x.modify_by,
                             x.modify_on)
                  RETURNING SID
                       INTO v_temp;

                -- Update which name is the current name.
                UPDATE T_OSI_PARTICIPANT_VERSION
                   SET current_name = v_temp
                 WHERE SID = v_new_version;
            END LOOP;

            -- Re-enable the timestamp trigger.
            EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
        EXCEPTION
            WHEN OTHERS THEN
                log_error('add_version: Error versioning name data: ' || SQLERRM);

                -- There was a problem so re-enable the trigger.
                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                RAISE;
        END;

        -- Address data.
        BEGIN
            -- Get the current address.
            SELECT current_address
              INTO v_current
              FROM T_OSI_PARTICIPANT_VERSION
             WHERE SID = v_old_version;

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

            -- Here we'll duplicate the records manually.
            FOR x IN (SELECT SID, obj, address_type, address_1, address_2, city, province, state,
                             postal_code, country, geo_coords, start_date, end_date, known_date,
                             comments, create_by, create_on, modify_by, modify_on
                        FROM T_OSI_ADDRESS
                       WHERE obj = v_obj)
            LOOP
                INSERT INTO T_OSI_ADDRESS
                            (obj,
                             address_type,
                             address_1,
                             address_2,
                             city,
                             province,
                             state,
                             postal_code,
                             country,
                             geo_coords,
                             start_date,
                             end_date,
                             known_date,
                             comments,
                             create_by,
                             create_on,
                             modify_by,
                             modify_on)
                     VALUES (x.obj,
                             x.address_type,
                             x.address_1,
                             x.address_2,
                             x.city,
                             x.province,
                             x.state,
                             x.postal_code,
                             x.country,
                             x.geo_coords,
                             x.start_date,
                             x.end_date,
                             x.known_date,
                             x.comments,
                             x.create_by,
                             x.create_on,
                             x.modify_by,
                             x.modify_on)
                  RETURNING SID
                       INTO v_temp;

                -- Add corresponding records to the participant address table.
                INSERT INTO T_OSI_PARTIC_ADDRESS
                            (participant_version, address)
                     VALUES (v_new_version, v_temp);

                IF (x.SID = v_current) THEN
                    -- Update the "current" address.
                    UPDATE T_OSI_PARTICIPANT_VERSION
                       SET current_address = v_temp
                     WHERE SID = v_new_version;
                END IF;
            END LOOP;

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
        EXCEPTION
            WHEN OTHERS THEN
                log_error('add_version: Error versioning address data: ' || SQLERRM);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                RAISE;
        END;

        -- Vehicle data.
        BEGIN
            v_table := 'T_OSI_PARTIC_VEHICLE';

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

            v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);

            EXECUTE IMMEDIATE v_sql;

            EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
        EXCEPTION
            WHEN OTHERS THEN
                log_error('add_version: Error versioning vehicle data: ' || SQLERRM);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                RAISE;
        END;

        -- Specifics/Organization Attributes apply only to organizations.
        IF (v_type = 'PART.NONINDIV.ORG') THEN
            BEGIN
                v_table := 'T_OSI_PARTIC_ORG_ATTR';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error
                           ('add_version: Error versioning other organization attributes data: '
                            || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;
        END IF;

        -- Company and Organization specific data.
        IF (v_type IN('PART.NONINDIV.COMP', 'PART.NONINDIV.ORG')) THEN
            BEGIN
                v_table := 'T_OSI_PARTICIPANT_NONHUMAN';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
                v_sql := REPLACE(v_sql, 'participant_version', 'sid');

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning non-individual data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;
        END IF;

        -- Everything below applies only to individuals.
        IF (v_type = 'PART.INDIV') THEN
            -- Other Dates data.
            BEGIN
                v_table := 'T_OSI_PARTIC_DATE';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning other dates data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Citizenships data.
            BEGIN
                v_table := 'T_OSI_PARTIC_CITIZENSHIP';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning citizenship data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Identifying Numbers data.
            BEGIN
                v_table := 'T_OSI_PARTIC_NUMBER';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                EXECUTE IMMEDIATE get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning identifying numbers data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Individual data.
            BEGIN
                v_table := 'T_OSI_PARTICIPANT_HUMAN';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
                v_sql := REPLACE(v_sql, 'participant_version', 'sid');

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning individual data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- More individual data.
            BEGIN
                v_table := 'T_OSI_PERSON_CHARS';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);
                v_sql := REPLACE(v_sql, 'participant_version', 'sid');

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning person chars data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Special marks data.
            BEGIN
                v_table := 'T_OSI_PARTIC_MARK';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning special marks data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;

            -- Contact data.
            BEGIN
                v_table := 'T_OSI_PARTIC_CONTACT';

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table);

                v_sql := get_duplicate_sql(v_table, v_new_version, v_old_version);

                EXECUTE IMMEDIATE v_sql;

                EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);
            EXCEPTION
                WHEN OTHERS THEN
                    log_error('add_version: Error versioning contact data: ' || SQLERRM);

                    EXECUTE IMMEDIATE get_ts_trigger_script(v_table, 1);

                    RAISE;
            END;
        END IF;

        -- Set the new version as the current version.
        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_new_version
         WHERE SID = v_obj;

        RETURN v_new_version;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('add_version: ' || SQLERRM);
            RAISE;
    END add_version;

    FUNCTION delete_version(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_result    VARCHAR2(1)                          := 'Y';
        v_current   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
        v_current := get_previous_version(p_version);

        IF (v_current IS NULL) THEN
            v_result := 'N';
        ELSE
            UPDATE T_OSI_PARTICIPANT
               SET current_version = v_current
             WHERE SID = get_participant(p_version);

            DELETE FROM T_OSI_PARTICIPANT_VERSION
                  WHERE SID = p_version;
        END IF;

        RETURN v_result;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('delete_version: ' || SQLERRM);
            RETURN 'delete_version: ' || SQLERRM;
    END delete_version;

    FUNCTION can_delete(p_obj IN VARCHAR2) RETURN VARCHAR2 IS
         
         v_count_check number;
         
    BEGIN
         if osi_auth.check_for_priv('DELETE',Core_Obj.get_objtype(p_obj))='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;

         ---Does this person have associations (files or activities)?---
         select count(*) into v_count_check FROM T_OSI_PARTIC_INVOLVEMENT pi, T_OSI_PARTICIPANT_VERSION pv WHERE pi.participant_version = pv.SID AND pv.participant = p_obj;
         if v_count_check > 0 then

           RETURN 'You cannot delete a participant used in a file or activity.';

         end if;

         ---Does this person have relationships?---
         select count(*) into v_count_check FROM T_OSI_PARTIC_RELATION pr WHERE pr.partic_a = p_obj OR pr.partic_b = p_obj;
         if v_count_check > 0 then

           RETURN 'You cannot delete a participant with an existing relationship.';

         end if;

         RETURN 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.Can_Delete: Error encountered using Object ' || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in OSI_PARTICIPANT.Can_Delete using Object: ' || NVL(p_obj, 'NULL');

    END can_delete;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF (   p_version IS NULL
            OR p_version = get_current_version(p_obj)) THEN
            RETURN 'Y';
        ELSE
            RETURN 'N';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('check_writability: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION create_instance(
        p_lname     IN   VARCHAR2 := NULL,
        p_fname     IN   VARCHAR2 := NULL,
        p_ssn       IN   VARCHAR2 := NULL,
        p_dob       IN   DATE := NULL,
        p_sex       IN   VARCHAR2 := NULL,
        p_unknown   IN   VARCHAR2 := 'Y')
        RETURN VARCHAR2 IS
        v_sid         T_CORE_OBJ.SID%TYPE;
        v_obj_type    T_CORE_OBJ_TYPE.SID%TYPE;
        v_par_type    T_OSI_REFERENCE.SID%TYPE;
        v_num_type    T_OSI_REFERENCE.SID%TYPE;
        v_ssn         T_OSI_PARTIC_NUMBER.num_value%TYPE;
        v_name_type   T_OSI_PARTIC_NAME_TYPE.SID%TYPE;
        v_fname       T_OSI_PARTIC_NAME.first_name%TYPE;
        v_lname       T_OSI_PARTIC_NAME.last_name%TYPE;
        v_version     T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_cur_name    T_OSI_PARTIC_NAME.SID%TYPE;

        /*
        * The first name for an unknown participant is UNIT_CODE-YEAR-NUMBER.
        * Example: 106-2009-0001
        * The last four digits start at one and are incremented by one. Each year the
        * sequence starts over.
        */
        FUNCTION get_unknown_number
            RETURN VARCHAR2 IS
            v_max    T_OSI_PARTIC_NAME.first_name%TYPE;
            v_rtn    T_OSI_PARTIC_NAME.first_name%TYPE;
            v_temp   T_OSI_PARTIC_NAME.first_name%TYPE;
        BEGIN
            v_temp :=
                Osi_Unit.get_code(Osi_Personnel.get_current_unit()) || '-'
                || TO_CHAR(SYSDATE, 'YYYY');

            SELECT MAX(first_name)
              INTO v_max
              FROM T_OSI_PARTIC_NAME
             WHERE first_name LIKE v_temp || '%';

            IF (v_max IS NULL) THEN
                v_max := 0;
            ELSE
                v_max := SUBSTR(v_max, INSTR(v_max, '-', 1, 2) + 1);
            END IF;

            v_rtn := v_temp || '-' || trim(TO_CHAR(v_max + 1, '0000'));
            RETURN v_rtn;
        END get_unknown_number;
    BEGIN
        v_obj_type := Core_Obj.lookup_objtype('PART.INDIV');

        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (v_obj_type)
          RETURNING SID
               INTO v_sid;

        INSERT INTO T_OSI_PARTICIPANT
                    (SID, unknown_flag, dob)
             VALUES (v_sid, p_unknown, p_dob);

        INSERT INTO T_OSI_PARTICIPANT_VERSION
                    (participant)
             VALUES (v_sid)
          RETURNING SID
               INTO v_version;

        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_version
         WHERE SID = v_sid;

        INSERT INTO T_OSI_PARTICIPANT_HUMAN
                    (SID)
             VALUES (v_version);

        INSERT INTO T_OSI_PERSON_CHARS
                    (SID, sex)
             VALUES (v_version, p_sex);

        SELECT n.SID
          INTO v_name_type
          FROM T_OSI_PARTIC_NAME_TYPE_MAP m, T_OSI_PARTIC_NAME_TYPE n
         WHERE m.participant_type = Osi_Reference.lookup_ref_sid('PART.INDIV', 'PI')
           AND m.name_type = n.SID
           AND n.code = 'L'
           AND m.active = 'Y';

        IF (p_unknown = 'Y') THEN
            v_lname := 'UNKNOWN';
            v_fname := get_unknown_number;
            v_ssn := NULL;
        ELSE
            v_lname := p_lname;
            v_fname := p_fname;
            v_ssn := p_ssn;
        END IF;

        INSERT INTO T_OSI_PARTIC_NAME
                    (participant_version, name_type, last_name, first_name)
             VALUES (v_version, v_name_type, v_lname, v_fname)
          RETURNING SID
               INTO v_cur_name;

        UPDATE T_OSI_PARTICIPANT_VERSION
           SET current_name = v_cur_name
         WHERE SID = v_version;

        IF (p_ssn IS NOT NULL) THEN
            SELECT SID
              INTO v_num_type
              FROM T_OSI_PARTIC_NUMBER_TYPE
             WHERE code = 'SSN';

            INSERT INTO T_OSI_PARTIC_NUMBER
                        (participant_version, num_type, num_value)
                 VALUES (v_version, v_num_type, v_ssn);
        END IF;

        Osi_Status.change_status_brute(v_sid, Osi_Status.get_starting_status(v_obj_type), 'Created');
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_instance: ' || SQLERRM);
            RAISE;
    END create_instance;

    FUNCTION create_nonindiv_instance(
        p_obj_type_sid   IN   VARCHAR2,
        p_sub_type       IN   VARCHAR2,
        p_name_type      IN   VARCHAR2,
        p_name           IN   VARCHAR2,
        p_acronym        IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_sid        T_CORE_OBJ.SID%TYPE;
        v_version    T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_cur_name   T_OSI_PARTIC_NAME.SID%TYPE;
    BEGIN
        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (p_obj_type_sid)
          RETURNING SID
               INTO v_sid;

        INSERT INTO T_OSI_PARTICIPANT
                    (SID)
             VALUES (v_sid);

        INSERT INTO T_OSI_PARTICIPANT_VERSION
                    (participant)
             VALUES (v_sid)
          RETURNING SID
               INTO v_version;

        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_version
         WHERE SID = v_sid;

        INSERT INTO T_OSI_PARTICIPANT_NONHUMAN
                    (SID, sub_type)
             VALUES (v_version, p_sub_type);

        INSERT INTO T_OSI_PARTIC_NAME
                    (participant_version, name_type, last_name, first_name)
             VALUES (v_version, p_name_type, p_name, p_acronym)
          RETURNING SID
               INTO v_cur_name;

        UPDATE T_OSI_PARTICIPANT_VERSION
           SET current_name = v_cur_name
         WHERE SID = v_version;

        Osi_Status.change_status_brute(v_sid,
                                       Osi_Status.get_starting_status(p_obj_type_sid),
                                       'Created');
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_nonindiv_instance: ' || SQLERRM);
            RAISE;
    END create_nonindiv_instance;

    FUNCTION is_confirmed(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_yn   VARCHAR2(1);
    BEGIN
        SELECT DECODE(confirm_by, NULL, NULL, 'Y')
          INTO v_yn
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        RETURN v_yn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('is_confirmed: ' || SQLERRM);
            RETURN 'is_confirmed: ' || SQLERRM;
    END is_confirmed;

    FUNCTION get_address_data(
        p_pvop           IN   VARCHAR2,
        p_address_code   IN   VARCHAR2,
        p_address_item   IN   VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT * FROM V_OSI_PARTIC_ADDRESS
                   WHERE (participant_version = p_pvop or participant_version = osi_participant.get_current_version(p_pvop))
                     and type_code=p_address_code
                   order by modify_on desc)
        LOOP
            CASE UPPER(p_address_item)
                WHEN 'SID' THEN
                    RETURN x.SID;
                WHEN 'ADDRESS1' THEN
                    RETURN x.address_1;
                WHEN 'ADDRESS2' THEN
                    RETURN x.address_2;
                WHEN 'ADDRESS' THEN
                    RETURN x.address_1 || CHR(10) || CHR(13) || x.address_2;
                WHEN 'CITY' THEN
                    RETURN x.city;
                WHEN 'PROVINCE' THEN
                    RETURN x.province;
                WHEN 'STATE' THEN
                    RETURN x.state_desc;
                WHEN 'STATE_CODE' THEN
                    RETURN x.state_code;
                WHEN 'ZIP' THEN
                    RETURN x.postal_code;
                WHEN 'POSTAL_CODE' THEN
                    RETURN x.postal_code;
                WHEN 'COUNTRY' THEN
                    RETURN x.country_desc;
                WHEN 'COUNTRY_CODE' THEN
                    RETURN x.country_code;
                WHEN 'GEO_COORDS' THEN
                    RETURN x.geo_coords;
                WHEN 'DISPLAY' THEN
                    IF SUBSTR(UPPER(p_address_code),-3) = '_ML' THEN
                      RETURN( x.display_string );
                    ELSIF SUBSTR(UPPER(p_address_code),-4) = '_SCO' THEN
                         RETURN( NVL(x.state_desc, x.country_desc) );
                    ELSE
                      RETURN( x.single_line );
                    END IF;
            END CASE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_address_data: ' || SQLERRM);
            RETURN 'get_address_data: ' || SQLERRM;
    END get_address_data;

    FUNCTION get_address_sid
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_address_sid;
    END get_address_sid;

    FUNCTION get_birth_address_sid(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'SID');
    END get_birth_address_sid;

    FUNCTION get_birth_city(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'CITY');
    END get_birth_city;

    FUNCTION get_birth_country(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'COUNTRY');
    END get_birth_country;

    FUNCTION get_birth_country_code(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'COUNTRY_CODE');
    END get_birth_country_code;

    FUNCTION get_birth_state(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'STATE');
    END get_birth_state;

    FUNCTION get_birth_state_code(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_address_data(p_pvop, 'BIRTH', 'STATE_CODE');
    END get_birth_state_code;

    FUNCTION get_confirm_messages
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_messages;
    END get_confirm_messages;

    FUNCTION get_confirm_session
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_session;
    END get_confirm_session;

    FUNCTION get_confirmation(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_confirmed   T_OSI_PARTICIPANT.confirm_by%TYPE;
    BEGIN
        SELECT DECODE(confirm_by, NULL, 'Not Confirmed', 'Confirmed')
          INTO v_confirmed
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        RETURN v_confirmed;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_confirmation: ' || SQLERRM);
            RETURN 'get_confirmation: ' || SQLERRM;
    END get_confirmation;

    FUNCTION get_contact_value(p_pvop IN VARCHAR2, p_type IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT VALUE
                    FROM v_osi_participant_version pv, T_OSI_PARTIC_CONTACT pc
                   WHERE (   pv.SID = p_pvop
                          OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                     AND pc.participant_version = pv.SID
                     AND pc.TYPE = Osi_Reference.lookup_ref_sid('CONTACT_TYPE', p_type))
        LOOP
            RETURN x.VALUE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_contact_value: ' || SQLERRM);
            RETURN 'get_contact_value: ' || SQLERRM;
    END get_contact_value;

    FUNCTION get_create_menu(p_icon IN VARCHAR2, p_page_item IN VARCHAR2, p_type_list IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_array      apex_application_global.vc_arr2;
        v_rtn        VARCHAR2(4000);
        v_id         VARCHAR2(10);
        v_page_num   NUMBER;
    BEGIN
        v_array := apex_util.string_to_table(p_type_list, '~');
        v_id := dbms_random.string('U', 10);
        v_rtn := '<a href="javascript:showHide(''' || v_id || ''');">' || p_icon || '</a>';
        v_rtn := v_rtn || '<div id="' || v_id || '" style="display:none;position:absolute;">';
        v_rtn := v_rtn || '<ul class="expandButton">';

        FOR x IN 1 .. v_array.COUNT
        LOOP
            FOR y IN (SELECT description
                        FROM T_CORE_OBJ_TYPE
                       WHERE code = UPPER(v_array(x)))
            LOOP
                IF (v_array(x) = 'PART.INDIV') THEN
                    v_rtn :=
                        v_rtn
                        || '<li class="expandedItem1"><a href="javascript:createObject(30000,''';
                    v_rtn := v_rtn || v_array(x) || ''', ''P30000_RETURN_ITEM,P30000_MODE'', ''';
                ELSE
                    v_rtn :=
                        v_rtn
                        || '<li class="expandedItem1"><a href="javascript:createObject(30100,''';
                    v_rtn := v_rtn || v_array(x) || ''', ''P30100_RETURN_ITEM,P30100_MODE'', ''';
                END IF;

                v_rtn := v_rtn || p_page_item || ',FROM_OBJ'');"';
                v_rtn := v_rtn || ' class="expandedLink">' || y.description || '</a></li>';
            END LOOP;
        END LOOP;

        RETURN v_rtn || '</ul>';
    END get_create_menu;

    FUNCTION get_current_version(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT current_version
                    FROM T_OSI_PARTICIPANT
                   WHERE SID = p_obj)
        LOOP
            RETURN x.current_version;
        END LOOP;

        RETURN NULL;
    END get_current_version;

    FUNCTION get_date(p_pvop IN VARCHAR2, p_code IN VARCHAR2)
        RETURN DATE IS
    BEGIN
        FOR x IN (SELECT   d.VALUE
                      FROM T_OSI_PARTIC_DATE d, v_osi_participant_version pv, T_OSI_REFERENCE r
                     WHERE (   pv.SID = p_pvop
                            OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                       AND d.participant_version = pv.SID
                       AND d.TYPE = r.SID
                       AND (   r.USAGE = 'INDIV_DATE'
                            OR r.USAGE = 'NON_INDIV_DATE')
                       AND r.code = p_code
                  ORDER BY d.modify_on DESC)
        LOOP
            RETURN x.VALUE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_date: ' || SQLERRM);
            RETURN 'get_date: ' || SQLERRM;
    END get_date;

    FUNCTION get_details(
        p_pvop          IN   VARCHAR2,
        p_omit_sa       IN   VARCHAR2 := NULL,
        p_for_confirm   IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn       VARCHAR2(4000);
        v_objtype   T_CORE_OBJ_TYPE.SID%TYPE;

        FUNCTION row_start
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<TR>';
        END row_start;

        FUNCTION row_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TR>';
        END row_end;

        FUNCTION new_row(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN row_start || p_text || row_end;
        END new_row;

        FUNCTION cell_start(p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
            v_rtn   VARCHAR2(500) := '<TD vAlign="top" ';
        BEGIN
            IF (p_col_span > 0) THEN
                v_rtn := v_rtn || 'colSpan="' || p_col_span || '" ';
            END IF;

            IF (p_row_span > 0) THEN
                v_rtn := v_rtn || 'rowSpan="' || p_row_span || '" ';
            END IF;

            RETURN v_rtn || '>';
        END cell_start;

        FUNCTION cell_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TD>';
        END cell_end;

        FUNCTION new_cell(p_text IN VARCHAR2, p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN cell_start(p_col_span, p_row_span) || p_text || cell_end;
        END new_cell;

        FUNCTION make_label(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<LABEL class="optionallabel"><SPAN>' || p_text || '</SPAN></LABEL>';
        END make_label;

        FUNCTION get_indiv_details(p_pvop IN VARCHAR2)
            RETURN VARCHAR2 IS
            v_name                    v_osi_participant_indiv_title.NAME%TYPE;
            v_sex                     v_osi_participant_indiv_title.sex%TYPE;
            v_service                 v_osi_participant_indiv_title.service%TYPE;
            v_address                 v_osi_participant_indiv_title.address%TYPE;
            v_dob                     v_osi_participant_indiv_title.dob%TYPE;
            v_affiliation             v_osi_participant_indiv_title.affiliation%TYPE;
            v_race                    v_osi_participant_indiv_title.race%TYPE;
            v_component               v_osi_participant_indiv_title.component%TYPE;
            v_ssn                     v_osi_participant_indiv_title.ssn%TYPE;
            v_pay_plan                v_osi_participant_indiv_title.pay_plan%TYPE;
            v_confirmed               v_osi_participant_indiv_title.confirmed%TYPE;
            v_pay_grade               v_osi_participant_indiv_title.pay_grade%TYPE;
            v_rank                    v_osi_participant_indiv_title.rank%TYPE;
            v_rank_date               v_osi_participant_indiv_title.rank_date%TYPE;
            v_specialty_code          v_osi_participant_indiv_title.specialty_code%TYPE;
            v_military_organization   v_osi_participant_indiv_title.military_organization%TYPE;
            v_format                  VARCHAR2(11);
        BEGIN
            IF (p_pvop IS NOT NULL) THEN
                SELECT pi.NAME, pi.sex, pi.service, pi.address, pi.dob, pi.affiliation, pi.race,
                       pi.component, pi.ssn, pi.pay_plan, pi.confirmed, pi.pay_grade, pi.rank,
                       pi.rank_date, pi.specialty_code, pi.military_organization
                  INTO v_name, v_sex, v_service, v_address, v_dob, v_affiliation, v_race,
                       v_component, v_ssn, v_pay_plan, v_confirmed, v_pay_grade, v_rank,
                       v_rank_date, v_specialty_code, v_military_organization
                  FROM v_osi_participant_indiv_title pi
                 WHERE pi.SID = p_pvop
                    OR (pi.participant = p_pvop AND pi.SID = pi.current_version);

                v_format := Core_Util.get_config('CORE.DATE_FMT_DAY');
            END IF;

            v_rtn := '<TABLE class="formlayout" width="100%" border="0"><TBODY>';
            v_rtn := v_rtn || '<colgroup span="3" align="left" width="33%"></colgroup>';
            v_rtn := v_rtn || row_start || new_cell('Name: ' || v_name);
            v_rtn := v_rtn || new_cell('Sex: ' || v_sex);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Service: ' || v_service);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address, 0, 8);
            v_rtn := v_rtn || new_cell('Date of Birth: ' || TO_CHAR(v_dob, v_format));

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Affiliation: ' || v_affiliation);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Race: ' || v_race);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Component: ' || v_component);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('SSN: ' || v_ssn);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Plan: ' || v_pay_plan);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Grade: ' || v_pay_grade);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank: ' || v_rank);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank Date: ' || TO_CHAR(v_rank_date, v_format));
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Specialty: ' || v_specialty_code);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Military Organization: ' || v_military_organization);
            END IF;

            v_rtn := v_rtn || row_end || '</TBODY></TABLE>';
            RETURN v_rtn;
        END get_indiv_details;

        FUNCTION get_nonindiv_details(p_pvop IN VARCHAR2)
            RETURN VARCHAR2 IS
            v_name        VARCHAR2(100);
            v_confirmed   VARCHAR2(20);
            v_subtype     VARCHAR2(100);
            v_address     VARCHAR2(4000);
            v_acronym     v_osi_participant_version.current_name%TYPE;
            v_cage        v_osi_participant_version.co_cage%TYPE;
            v_uic         v_osi_participant_version.org_uic%TYPE;
        BEGIN
            v_name := get_name(p_pvop);
            v_confirmed := get_confirmation(p_pvop);
            v_subtype := get_subtype(p_pvop);

            SELECT co_cage, org_uic, Osi_Address.get_addr_display(current_address, NULL, '<br>'),
                   current_name
              INTO v_cage, v_uic, v_address,
                   v_acronym
              FROM v_osi_participant_version
             WHERE SID = p_pvop
                OR (SID = current_version AND participant = p_pvop);

            v_rtn := '<TABLE class="formlayout" width="100%" border="0"><TBODY>';
            v_rtn := v_rtn || '<colgroup span="3" align="left" width="33%"></colgroup>';

            CASE v_objtype
                WHEN Core_Obj.lookup_objtype('PART.NONINDIV.PROG') THEN
                    v_rtn := v_rtn || row_start || new_cell('Program: ' || v_name) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

                    IF (p_for_confirm IS NOT NULL) THEN
                        BEGIN
                            SELECT first_name
                              INTO v_name
                              FROM v_osi_partic_name
                             WHERE SID = v_acronym;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                v_name := NULL;
                        END;

                        v_rtn := v_rtn || row_start || new_cell('Acronym: ' || v_name);
                        v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address);
                    END IF;

                    v_rtn := v_rtn || row_end;
                WHEN Core_Obj.lookup_objtype('PART.NONINDIV.ORG') THEN
                    v_rtn := v_rtn || row_start || new_cell('Organization: ' || v_name, 0, 3);
                    v_rtn := v_rtn || new_cell('Subtype: ' || v_subtype) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('UIC/PAS: ' || v_uic) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

                    IF (p_for_confirm IS NOT NULL) THEN
                        v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address);
                    END IF;

                    v_rtn := v_rtn || row_end;
                WHEN Core_Obj.lookup_objtype('PART.NONINDIV.COMP') THEN
                    v_rtn := v_rtn || row_start || new_cell('Company: ' || v_name, 0, 3);
                    v_rtn := v_rtn || new_cell('Subtype: ' || v_subtype) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Cage Code: ' || v_cage) || row_end;
                    v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

                    IF (p_for_confirm IS NOT NULL) THEN
                        v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address);
                    END IF;

                    v_rtn := v_rtn || row_end;
            END CASE;

            v_rtn := v_rtn || '</TBODY></TABLE>';
            RETURN v_rtn;
        END get_nonindiv_details;
    BEGIN
        IF (p_pvop IS NOT NULL) THEN
            v_objtype := get_type_sid(p_pvop);

            IF (v_objtype = Core_Obj.lookup_objtype('PART.INDIV')) THEN
                RETURN get_indiv_details(p_pvop);
            ELSE
                RETURN get_nonindiv_details(p_pvop);
            END IF;
        END IF;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_details: ' || SQLERRM);
            RETURN 'get_details: ' || SQLERRM;
    END get_details;

    FUNCTION get_id(p_obj IN VARCHAR2, p_obj_context VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF (p_obj_context IS NULL) THEN
            RETURN get_version_label(get_current_version(p_obj), 1);
        ELSE
            RETURN get_version_label(p_obj_context, 1);
        END IF;
    END get_id;

    FUNCTION get_image_sid
        RETURN VARCHAR2 IS
    BEGIN
        RETURN v_image_sid;
    END get_image_sid;

    FUNCTION get_mil_member_name(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        BEGIN
            FOR x IN (SELECT   pr.partic_b
                          FROM T_OSI_PARTIC_RELATION pr, v_osi_participant_version pv
                         WHERE (   pv.SID = p_pvop
                                OR (pv.participant = p_pvop AND pv.SID = current_version))
                           AND pr.partic_a = pv.participant
                           AND pr.end_date IS NULL
                           AND Osi_Participant.get_subtype_sid(pr.partic_b) =
                                           Osi_Reference.lookup_ref_sid('PART.NONINDIV.ORG', 'POUM')
                      ORDER BY pr.start_date DESC)
            LOOP
                v_rtn := get_name(x.partic_b);
                EXIT;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rtn := NULL;
        END;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_mil_member_name: ' || SQLERRM);
            RETURN 'get_mil_member_name: ' || SQLERRM;
    END get_mil_member_name;

    FUNCTION get_name(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_program   T_CORE_OBJ_TYPE.SID%TYPE;
    BEGIN
        v_program := Core_Obj.lookup_objtype('PART.NONINDIV.PROG');

        FOR x IN (SELECT RTRIM(RTRIM(pn.last_name
                                     || DECODE(pv.obj_type, v_program, '', ', ' || pn.first_name)
                                     || ' ' || pn.middle_name,
                                     ' '),
                               ',')
                         || DECODE(pv.org_majcom, NULL, '', ' (' || pv.org_majcom_desc || ')')
                                                                                           AS NAME
                    FROM T_OSI_PARTIC_NAME pn, v_osi_participant_version pv
                   WHERE (   pv.SID = p_pvop
                          OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                     AND (pn.SID = pv.current_name))
        LOOP
            RETURN x.NAME;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_name: ' || SQLERRM);
            RETURN 'get_name: ' || SQLERRM;
    END get_name;

    FUNCTION get_name_type(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT t.description
                    FROM v_osi_participant_version pv,
                         T_OSI_PARTIC_NAME pn,
                         T_OSI_PARTIC_NAME_TYPE t
                   WHERE (   pv.SID = p_pvop
                          OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                     AND pn.SID = pv.current_name
                     AND pn.name_type = t.SID)
        LOOP
            RETURN x.description;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_name_type: ' || SQLERRM);
            RETURN 'get_name_type: ' || SQLERRM;
    END get_name_type;

    FUNCTION get_next_version(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_partic    T_OSI_PARTICIPANT.SID%TYPE;
        v_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
        v_partic := get_participant(p_version);

        IF (v_partic IS NULL) THEN
            -- An invalid version sid was given.
            log_error('get_next_version: Unknown version given.');
            RETURN NULL;
        END IF;

        SELECT SID
          INTO v_version
          FROM (SELECT   SID
                    FROM T_OSI_PARTICIPANT_VERSION
                   WHERE participant = v_partic AND SID > p_version
                ORDER BY SID ASC)
         WHERE ROWNUM = 1;

        RETURN v_version;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('get_next_version: ' || SQLERRM);
            RETURN 'get_next_version: ' || SQLERRM;
    END get_next_version;

    FUNCTION get_previous_version(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_partic    T_OSI_PARTICIPANT.SID%TYPE;
        v_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
        v_partic := get_participant(p_version);

        IF (v_partic IS NULL) THEN
            -- An invalid version sid was given.
            log_error('get_previous_version: Unknown version given.');
            RETURN NULL;
        END IF;

        SELECT SID
          INTO v_version
          FROM (SELECT   SID
                    FROM T_OSI_PARTICIPANT_VERSION
                   WHERE participant = v_partic AND SID < p_version
                ORDER BY SID DESC)
         WHERE ROWNUM = 1;

        RETURN v_version;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('get_previous_version: ' || SQLERRM);
            RETURN 'get_previous_version: ' || SQLERRM;
    END get_previous_version;

    FUNCTION get_number(p_pvop IN VARCHAR2, p_code IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_obj_code   T_CORE_OBJ_TYPE.code%TYPE;
    BEGIN
        SELECT code
          INTO v_obj_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = get_type_sid(p_pvop);

        IF (v_obj_code = 'PART.INDIV') THEN
            FOR x IN (SELECT pn.num_value
                        FROM T_OSI_PARTIC_NUMBER pn,
                             T_OSI_PARTIC_NUMBER_TYPE nt,
                             v_osi_participant_version pv
                       WHERE (   pv.SID = p_pvop
                              OR (pv.participant = p_pvop AND pv.SID = current_version))
                         AND pn.participant_version = pv.SID
                         AND pn.num_type = nt.SID
                         AND nt.code = p_code)
            LOOP
                RETURN x.num_value;
            END LOOP;
        ELSE
            FOR x IN (SELECT DECODE(v_obj_code,
                                    'PART.NONINDIV.COMP', co_cage,
                                    'PART.NONINDIV.ORG', org_uic) AS num_value
                        FROM v_osi_participant_version
                       WHERE SID = p_pvop
                          OR (participant = p_pvop AND SID = current_version))
            LOOP
                RETURN x.num_value;
            END LOOP;
        END IF;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_number: ' || SQLERRM);
            RETURN 'get_number: ' || SQLERRM;
    END get_number;

    FUNCTION get_org_member(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        BEGIN
            FOR x IN (SELECT   pr.SID
                          FROM v_osi_partic_relation_2way pr,
                               v_osi_participant_version pv,
                               T_OSI_PARTIC_RELATION_TYPE rt
                         WHERE (   pv.SID = p_pvop
                                OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                           AND pr.this_partic = pv.participant
                           AND (   pr.end_date IS NULL
                                OR pr.end_date > SYSDATE)
                           AND pr.rel_type = rt.SID
                           AND rt.code IN('IMOU', 'HUM', 'IMO', 'HM')
                      ORDER BY NVL(pr.start_date, pr.modify_on) DESC)
            LOOP
                v_rtn := x.SID;
                EXIT;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rtn := NULL;
        END;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_org_member: ' || SQLERRM);
            RETURN 'get_org_member: ' || SQLERRM;
    END get_org_member;

    FUNCTION get_org_member_name(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        v_rtn := get_name(get_org_member(p_pvop));
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_org_member_name: ' || SQLERRM);
            RETURN 'get_org_member_name: ' || SQLERRM;
    END get_org_member_name;

    FUNCTION get_org_member_addr(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   VARCHAR2(200);
    BEGIN
        v_rtn := Osi_Address.get_addr_display(Osi_Address.get_address_sid(get_org_member(p_pvop)));
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_org_member_addr: ' || SQLERRM);
            RETURN 'get_org_member_addr: ' || SQLERRM;
    END get_org_member_addr;

    FUNCTION get_participant(p_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_sid   T_OSI_PARTICIPANT.SID%TYPE;
    BEGIN
        SELECT participant
          INTO v_sid
          FROM T_OSI_PARTICIPANT_VERSION
         WHERE SID = p_version;

        RETURN v_sid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('get_participant: ' || SQLERRM);
            RETURN 'get_participant: ' || SQLERRM;
    END get_participant;

    FUNCTION get_rank(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT sa_rank AS rank
                    FROM v_osi_participant_version
                   WHERE SID = p_pvop
                      OR (participant = p_pvop AND SID = current_version))
        LOOP
            RETURN x.rank;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_rank: ' || SQLERRM);
            RETURN 'get_rank: ' || SQLERRM;
    END get_rank;

    FUNCTION get_relation_specifics(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_specifics    VARCHAR2(3300);
        v_mod1_name    T_OSI_PARTIC_RELATION_TYPE.mod1_name%TYPE;
        v_mod2_name    T_OSI_PARTIC_RELATION_TYPE.mod2_name%TYPE;
        v_mod3_name    T_OSI_PARTIC_RELATION_TYPE.mod3_name%TYPE;
        v_mod1_value   T_OSI_PARTIC_RELATION.mod1_value%TYPE;
        v_mod2_value   T_OSI_PARTIC_RELATION.mod2_value%TYPE;
        v_mod3_value   T_OSI_PARTIC_RELATION.mod3_value%TYPE;
    BEGIN
        SELECT t.mod1_name, t.mod2_name, t.mod3_name, r.mod1_value, r.mod2_value, r.mod3_value
          INTO v_mod1_name, v_mod2_name, v_mod3_name, v_mod1_value, v_mod2_value, v_mod3_value
          FROM T_OSI_PARTIC_RELATION_TYPE t, T_OSI_PARTIC_RELATION r
         WHERE r.SID = p_sid AND r.rel_type = t.SID;

        IF (v_mod1_value IS NOT NULL) THEN
            Core_Util.append_info(v_specifics, v_mod1_name);
            Core_Util.append_info(v_specifics, v_mod1_value, ': ');
        END IF;

        IF (v_mod2_value IS NOT NULL) THEN
            Core_Util.append_info(v_specifics, v_mod2_name);
            Core_Util.append_info(v_specifics, v_mod2_value, ': ');
        END IF;

        IF (v_mod3_value IS NOT NULL) THEN
            Core_Util.append_info(v_specifics, v_mod3_name);
            Core_Util.append_info(v_specifics, v_mod3_value, ': ');
        END IF;

        RETURN v_specifics;
    END get_relation_specifics;

    FUNCTION get_subtype(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_subtype   T_OSI_REFERENCE.SID%TYPE;
        v_rtn       VARCHAR2(100);
    BEGIN
        SELECT sub_type
          INTO v_subtype
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        IF (v_subtype IS NULL) THEN
            v_rtn := 'Not Applicable';
        ELSE
            SELECT description
              INTO v_rtn
              FROM T_OSI_REFERENCE
             WHERE SID = v_subtype;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_subtype: ' || SQLERRM);
            RETURN 'get_subtype: ' || SQLERRM;
    END get_subtype;

    FUNCTION get_subtype_sid(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_subtype   T_OSI_REFERENCE.SID%TYPE;
        v_rtn       T_OSI_PARTICIPANT_NONHUMAN.sub_type%TYPE;
    BEGIN
        SELECT sub_type
          INTO v_subtype
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        IF (v_subtype IS NULL) THEN
            v_rtn := NULL;
        ELSE
            SELECT SID
              INTO v_rtn
              FROM T_OSI_REFERENCE
             WHERE SID = v_subtype;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_subtype: ' || SQLERRM);
            RETURN 'get_subtype: ' || SQLERRM;
    END get_subtype_sid;

    FUNCTION get_type(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_type   v_osi_participant_version.obj_type_desc%TYPE;
    BEGIN
        SELECT obj_type_desc
          INTO v_type
          FROM v_osi_participant_version
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);

        RETURN v_type;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_type: ' || SQLERRM);
            RETURN 'get_type: ' || SQLERRM;
    END get_type;

    FUNCTION get_type_sid(p_popv IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_sid   T_CORE_OBJ_TYPE.SID%TYPE;
    BEGIN
        --Assume it's a participant sid.
        BEGIN
            SELECT Core_Obj.get_objtype(p.SID)
              INTO v_sid
              FROM T_OSI_PARTICIPANT p
             WHERE p.SID = p_popv;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Must be a version sid.
                SELECT Core_Obj.get_objtype(pv.participant)
                  INTO v_sid
                  FROM T_OSI_PARTICIPANT_VERSION pv
                 WHERE pv.SID = p_popv;
        END;

        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_type_sid: ' || SQLERRM);
            RETURN 'get_type_sid: ' || SQLERRM;
    END get_type_sid;

    FUNCTION get_tagline(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN get_name(p_pvop);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline: ' || SQLERRM);
            RETURN 'get_tagline: ' || SQLERRM;
    END get_tagline;

    FUNCTION get_type_lov(p_type_list IN VARCHAR2 := 'ALL')
        RETURN VARCHAR2 IS
        v_lov    VARCHAR2(200);
        v_code   VARCHAR2(200);
        v_desc   VARCHAR2(200);
    BEGIN
        IF p_type_list = 'ALL' THEN
            Core_Util.append_info(v_lov, 'All Participant Types;ALL');
            Core_Util.append_info(v_lov, 'Companies;PART.NONINDIV.COMP');
            Core_Util.append_info(v_lov, 'Individuals by Name;PART.INDIV');
            Core_Util.append_info(v_lov, 'Organizations;PART.NONINDIV.ORG');
            Core_Util.append_info(v_lov, 'Programs;PART.NONINDIV.PROG');
        ELSE
            FOR a IN 1 .. 4
            LOOP
                v_code := Core_List.get_list_element(p_type_list, a);

                BEGIN
                    SELECT description
                      INTO v_desc
                      FROM T_CORE_OBJ_TYPE
                     WHERE code = v_code;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_desc := NULL;
                END;

                IF v_desc IS NOT NULL THEN
                    Core_Util.append_info(v_lov, v_desc || ';' || v_code);
                END IF;
            END LOOP;
        END IF;

        RETURN v_lov;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_type_lov: ' || SQLERRM);
            RETURN 'get_type_lov: ' || SQLERRM;
    END get_type_lov;

    FUNCTION get_version_label(p_pv IN VARCHAR2, p_short_label IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn       VARCHAR2(100);
        v_sid       VARCHAR2(20);
        v_current   VARCHAR2(20);
        v_by        VARCHAR2(100);
        v_date      VARCHAR2(11);
        v_time      VARCHAR2(8);
        v_format    VARCHAR2(30);
    BEGIN
        v_format := Core_Util.get_config('CORE.DATE_FMT_DAY');
        v_current := get_current_version(get_participant(p_pv));

        IF (v_current = p_pv) THEN
            v_sid := v_current;
            v_rtn := 'Current';
        ELSE
            v_sid := p_pv;
            v_rtn := 'Previous';
        END IF;

        IF (p_short_label IS NOT NULL) THEN
            RETURN v_rtn || ' Version';
        END IF;

        SELECT TO_CHAR(create_on, v_format), TO_CHAR(create_on, 'HH12:MI AM'), create_by
          INTO v_date, v_time, v_by
          FROM T_OSI_PARTICIPANT_VERSION
         WHERE SID = v_sid;

        RETURN v_rtn || ' version created by ' || v_by || ' on ' || v_date || ' at ' || v_time;
    END get_version_label;

    FUNCTION has_isn_number(p_pvop IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1);
        v_isn_exists   NUMBER;
        v_isn_type     T_OSI_REFERENCE.SID%TYPE;
    BEGIN
        -- Check for the existence of ISN number type.
        v_isn_type := Osi_Reference.lookup_ref_sid('INDIV_NUM', 'ISN');

        IF (v_isn_type IS NOT NULL) THEN
            SELECT COUNT(pn.SID)
              INTO v_isn_exists
              FROM v_osi_participant_version pv, T_OSI_PARTIC_NUMBER pn
             WHERE pv.SID = p_pvop
                OR     (pv.participant = p_pvop AND pv.current_version = pv.SID)
                   AND pv.SID = pn.participant_version
                   AND pn.num_type = v_isn_type;
        END IF;

        IF (v_isn_exists > 0) THEN
            v_rtn := 'Y';
        ELSE
            v_rtn := 'N';
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('has_isn_number: ' || SQLERRM);
            RAISE;
    END has_isn_number;

    FUNCTION check_for_duplicates(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_target            v_osi_participant_version%ROWTYPE;
        v_indiv             T_CORE_OBJ_TYPE.SID%TYPE;
        v_comp              T_CORE_OBJ_TYPE.SID%TYPE;
        v_org               T_CORE_OBJ_TYPE.SID%TYPE;
        v_prog              T_CORE_OBJ_TYPE.SID%TYPE;
        v_confirm_allowed   VARCHAR2(1);
        v_do_soundex        BOOLEAN;
        v_score             NUMBER                              := 0;
        v_max_score         NUMBER                              := 0;
        v_id_count          NUMBER;
        v_ssn_count         NUMBER;
        v_info              VARCHAR2(200);
    BEGIN
        v_messages := NULL;
        v_session := NULL;
        v_confirm_allowed := 'Y';
        v_indiv := Core_Obj.lookup_objtype('PART.INDIV');
        v_comp := Core_Obj.lookup_objtype('PART.NONINDIV.COMP');
        v_org := Core_Obj.lookup_objtype('PART.NONINDIV.ORG');
        v_prog := Core_Obj.lookup_objtype('PART.NONINDIV.PROG');

        -- This is the new participant that we want to verfiy doesn't already exist.
        SELECT *
          INTO v_target
          FROM v_osi_participant_version
         WHERE SID = current_version AND participant = p_obj;

        -- This loops over all the other confirmed participants.
        FOR x IN (SELECT v.SID, v.dob, v.participant, v.obj_type, v.co_cage, v.co_duns, v.org_uic,
                         v.sex
                    FROM v_osi_participant_version v
                   WHERE v.SID = v.current_version
                     AND v.confirm_on IS NOT NULL
                     AND v.obj_type = v_target.obj_type
                     AND v.SID <> v_target.SID)
        LOOP
            v_score := 0;
            v_info := NULL;

            -- Check DOB.
            IF (x.dob = v_target.dob) THEN
                v_score := v_score + 20;
                v_info := v_info || 'Same birth date. ';
            END IF;

            -- Check identifying numbers for each participant type.
            -- Individual
            IF (v_target.obj_type = v_indiv) THEN
                FOR n IN (SELECT DISTINCT nt.code, UPPER(pn.num_value) AS num_value
                                     FROM T_OSI_PARTIC_NUMBER pn, T_OSI_PARTIC_NUMBER_TYPE nt
                                    WHERE pn.participant_version = x.SID AND pn.num_type = nt.SID
                          INTERSECT
                          SELECT DISTINCT nt.code, UPPER(pn.num_value) AS num_value
                                     FROM T_OSI_PARTIC_NUMBER pn, T_OSI_PARTIC_NUMBER_TYPE nt
                                    WHERE pn.participant_version = v_target.SID
                                      AND pn.num_type = nt.SID)
                LOOP
                    IF (n.code = 'SSN') THEN
                        v_score := v_score + 75;
                        v_info := v_info || 'Same SSN. ';
                        EXIT;
                    END IF;

                    v_score := v_score + 50;
                    v_info := v_info || 'Same indentifying number. ';
                    EXIT;
                END LOOP;
            END IF;

            -- Company
            IF (v_target.obj_type = v_comp) THEN
                IF (UPPER(x.co_cage) = UPPER(v_target.co_cage)) THEN
                    v_score := v_score + 75;
                    v_info := v_info || 'Same CAGE Code. ';
                END IF;

                IF (UPPER(x.co_duns) = UPPER(v_target.co_duns)) THEN
                    v_score := v_score + 75;
                    v_info := v_info || 'Same DUNS. ';
                END IF;
            END IF;

            -- Organization
            IF (v_target.obj_type = v_org) THEN
                IF (UPPER(x.org_uic) = UPPER(v_target.org_uic)) THEN
                    v_score := v_score + 75;
                    v_info := v_info || 'Same UIC. ';
                END IF;
            END IF;

            -- Program
            IF (v_target.obj_type = v_prog) THEN
                -- Check relationship contracts.
                FOR r IN (SELECT DISTINCT related_to
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = x.SID
                                      AND relation_code IN('ICB', 'ICF')
                          INTERSECT
                          SELECT DISTINCT related_to
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = v_target.SID
                                      AND relation_code IN('ICB', 'ICF'))
                LOOP
                    v_score := v_score + 10;
                    v_info := v_info || 'Same contractor. ';
                    EXIT;
                END LOOP;

                FOR r IN (SELECT DISTINCT UPPER(specifics)
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = x.SID
                                          AND relation_code IN('ICB', 'ICF')
                          INTERSECT
                          SELECT DISTINCT UPPER(specifics)
                                     FROM v_osi_partic_relation
                                    WHERE this_participant = v_target.SID
                                      AND relation_code IN('ICB', 'ICF'))
                LOOP
                    v_score := v_score + 10;
                    v_info := v_info || 'Same contract number. ';
                    EXIT;
                END LOOP;
            END IF;

            -- Check the names.
            IF (v_score < 80 AND v_max_score < 80) THEN
                v_do_soundex := TRUE;

                FOR n IN (SELECT DISTINCT UPPER(last_name),
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = x.SID AND type_code <> 'A'
                          INTERSECT
                          SELECT DISTINCT UPPER(last_name),
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = v_target.SID AND type_code <> 'A')
                LOOP
                    v_score := v_score + 50;
                    v_info := v_info || 'Same name';

                    IF (v_target.obj_type = v_prog) THEN
                        v_info := v_info || ' (or acronym)';
                    END IF;

                    v_info := v_info || '. ';
                    v_do_soundex := FALSE;
                    EXIT;
                END LOOP;
            END IF;

            IF (v_score < 75 AND v_score > 15 AND v_max_score < 80 AND v_do_soundex) THEN
                FOR n IN (SELECT DISTINCT SOUNDEX(last_name) AS last_name,
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = x.SID AND type_code <> 'A'
                          INTERSECT
                          SELECT DISTINCT SOUNDEX(last_name) AS last_name,
                                          UPPER(SUBSTR(NVL(first_name, ' '), 1, 1))
                                                                                  AS first_initial
                                     FROM v_osi_partic_name
                                    WHERE participant_version = v_target.SID AND type_code <> 'A')
                LOOP
                    v_score := v_score + 25;
                    v_info := v_info || 'Similar name';

                    IF (v_target.obj_type = v_prog) THEN
                        v_info := v_info || ' (or acronym)';
                    END IF;

                    v_info := v_info || '. ';
                END LOOP;
            END IF;

            -- Adjust score for expected differences.
            IF (    v_score > 0
                AND x.sex IS NOT NULL
                AND v_target.sex IS NOT NULL
                AND x.sex <> v_target.sex) THEN
                v_score := v_score - 50;
                v_info := v_info || 'DIFFERENT sex. ';
            END IF;

            IF (v_score <= 0) THEN
                v_score := 0;
            ELSE
                v_info := RTRIM(v_info, ' ');

                IF (v_score > 100) THEN
                    v_score := 100;
                END IF;

                IF (v_session IS NULL) THEN
                    -- This is the first result so set the session.
                    v_session := Core_Sidgen.next_sid;
--                    v_confirm_allowed := 'N';
                END IF;

                INSERT INTO T_OSI_PARTIC_SEARCH_RESULT
                            (session_id, participant, score, info)
                     VALUES (v_session, x.participant, v_score, v_info);
            END IF;

            IF (v_score > v_max_score) THEN
                v_max_score := v_score;
            END IF;
        END LOOP;

        IF (v_max_score >= 75) THEN
            v_confirm_allowed := 'N';
        END IF;

        IF (v_target.obj_type = v_prog) THEN
            SELECT COUNT(SID)
              INTO v_score
              FROM v_osi_partic_relation
             WHERE this_participant = v_target.SID AND relation_code IN('ICB', 'ICF');

            IF (v_score = 0) THEN
                v_confirm_allowed := 'N';
            END IF;
        END IF;

        RETURN v_confirm_allowed;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('check_for_duplicates: ' || SQLERRM);
            --v_confirm_allowed := 'N';
            RAISE;
    END check_for_duplicates;

    PROCEDURE check_for_matches(
        p_number           IN       VARCHAR2,
        p_number_type      IN       VARCHAR2,
        p_dob              IN       DATE,
        p_lname            IN       VARCHAR2,
        p_fname            IN       VARCHAR2,
        p_sex              IN       VARCHAR2,
        p_session_web      IN OUT   VARCHAR2,
        p_session_legacy   IN OUT   VARCHAR2,
        p_deers_result     OUT      VARCHAR2) IS
        v_name_types             T_CORE_CONFIG.setting%TYPE;
        v_lname                  T_OSI_PARTIC_NAME.last_name%TYPE;
        v_fname                  T_OSI_PARTIC_NAME.first_name%TYPE;
        v_score                  NUMBER                               := 0;
        v_info                   VARCHAR2(150);
        v_code                   T_OSI_PARTIC_NUMBER_TYPE.code%TYPE;
        --v_cnt          number                               := 0;--TODO
        v_found_match            BOOLEAN;
        v_sex_code               VARCHAR2(200);
        v_num_type_code          VARCHAR2(200);
        v_num_type_description   VARCHAR2(200);

        --Process_Match = Legacy Only
        PROCEDURE process_match(
            p_session          IN   VARCHAR2,
            p_person_version   IN   VARCHAR2,
            p_hit_score        IN   NUMBER,
            p_details          IN   VARCHAR2) IS
            v_cnt   NUMBER;
        BEGIN
            --Clear Buffer
            v_cnt := 0;

            FOR k IN (SELECT *
                        FROM T_OSI_MIGRATION_PARTIC_HIT
                       WHERE user_session = p_session AND person_version = p_person_version)
            LOOP
                --See if this person has been processed as a hit already
                v_cnt := v_cnt + 1;
            END LOOP;

            IF (v_cnt > 0) THEN
                RETURN;
            ELSE
                FOR k IN (SELECT *
                            FROM T_OSI_MIGRATION
                           WHERE TYPE = 'PARTICIPANT_VERSION' AND old_sid = p_person_version)
                LOOP
                    --See if this person has been imported already
                    v_cnt := v_cnt + 1;
                END LOOP;
            END IF;

            IF (v_cnt = 0) THEN
                INSERT INTO T_OSI_MIGRATION_PARTIC_HIT
                            (user_session, person_version, score, details)
                     VALUES (p_session, p_person_version, p_hit_score, p_details);

                COMMIT;
            END IF;
        END process_match;
    BEGIN
        --Clear Buffers
        v_found_match := FALSE;

        --Get Session ID's
        --Legacy
        IF (p_session_legacy IS NULL) THEN
            p_session_legacy := Core_Sidgen.next_sid;

            --Just remove anything over 6 hours old
            DELETE FROM T_OSI_MIGRATION_PARTIC_HIT
                  WHERE create_on < SYSDATE - .25;

            COMMIT;
        ELSE
            --Clear out old session data
            DELETE FROM T_OSI_MIGRATION_PARTIC_HIT
                  WHERE user_session = p_session_legacy;

            COMMIT;
        END IF;

        --Web
        IF (p_session_web IS NULL) THEN
            p_session_web := Core_Sidgen.next_sid;

            --Just remove anything over 6 hours old
            DELETE FROM T_OSI_PARTIC_SEARCH_RESULT
                  WHERE create_on < SYSDATE - .25;

            COMMIT;
        ELSE
            --Clear out old session data
            DELETE FROM T_OSI_PARTIC_SEARCH_RESULT
                  WHERE session_id = p_session_web;

            COMMIT;
        END IF;

        IF (p_number IS NULL) THEN
            --p_session := core_sidgen.next_sid;--TODO
            -- Get the type codes for the searchable names.
            v_name_types := Core_Util.get_config('OSI.SEARCH_PARTICIPANT_NAME_TYPES');
            v_lname := UPPER(trim(p_lname));
            v_fname := UPPER(trim(p_fname));

            --Web Participant Search[BEGIN]
            FOR x IN (SELECT pv.SID, pv.participant, pn.last_name, pn.first_name
                        FROM v_osi_participant_version pv, v_osi_partic_name pn
                       WHERE pv.SID = pv.current_version
                         --and pv.current_name = pn.sid
                         AND pv.SID = pn.participant_version
                         AND (   p_dob IS NULL
                              OR pv.dob = p_dob)
                         AND (   p_sex IS NULL
                              OR pv.sex = p_sex)
                         AND INSTR(v_name_types, pn.type_code) > 0
                         AND (    (   SOUNDEX(pn.last_name) = SOUNDEX(v_lname)
                                   OR pn.last_name LIKE v_lname || '%')
                              AND (   SOUNDEX(pn.first_name) = SOUNDEX(v_fname)
                                   OR pn.first_name LIKE v_fname || '%'))
                         AND pv.confirm_by IS NOT NULL
                         AND pv.confirm_on IS NOT NULL)
            LOOP
                IF (   v_lname IS NOT NULL
                    OR LENGTH(v_lname) <> 0) THEN
                    IF (x.last_name = v_lname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching last name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding last name. ';
                    END IF;
                END IF;

                IF (   v_fname IS NOT NULL
                    OR LENGTH(v_fname) <> 0) THEN
                    IF (x.first_name = v_fname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching first name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding first name. ';
                    END IF;
                END IF;

                IF (p_dob IS NOT NULL) THEN
                    v_score := v_score + 25;
                    v_info := v_info || 'Matching DOB. ';
                END IF;

                IF (p_sex IS NOT NULL) THEN
                    v_score := v_score + 15;
                    v_info := v_info || 'Matching sex.';
                END IF;

                INSERT INTO T_OSI_PARTIC_SEARCH_RESULT
                            (session_id, participant, score, info)
                     VALUES (p_session_web, x.participant, v_score, v_info);

                v_score := 0;
                v_info := '';
            END LOOP;

            --Web Participant Search[END]

            --Legacy Participant Search[BEGIN]
            --Get Sex Code
            IF (p_sex IS NOT NULL) THEN
                SELECT code
                  INTO v_sex_code
                  FROM T_DIBRS_REFERENCE
                 WHERE SID = p_sex;
            END IF;

            FOR match IN (SELECT pv.SID, pv.person, pn.last_name, pn.first_name, pv.sex
                            FROM ref_t_person_version pv, ref_t_person_name pn, ref_t_person p
                           WHERE p.SID = pv.person
                             AND pv.SID = pn.person_version
                             AND (   p_dob IS NULL
                                  OR p.birth_date = p_dob)
                             AND (   pv.sex IS NULL
                                  OR pv.sex LIKE v_sex_code || '%')
                             AND INSTR(v_name_types, pn.name_type) > 0
                             AND (    (   SOUNDEX(pn.last_name) = SOUNDEX(v_lname)
                                       OR pn.last_name LIKE v_lname || '%')
                                  AND (   SOUNDEX(pn.first_name) = SOUNDEX(v_fname)
                                       OR pn.first_name LIKE v_fname || '%'))
                             AND p.confirm_by IS NOT NULL
                             AND p.confirm_on IS NOT NULL
                             AND pv.current_flag = 1)
            LOOP
                --Reset Scores and Info
                v_score := 0;
                v_info := '';

                --Last Name
                IF (   v_lname IS NOT NULL
                    OR LENGTH(v_lname) <> 0) THEN
                    IF (match.last_name = v_lname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching last name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding last name. ';
                    END IF;
                END IF;

                --First Name
                IF (   v_fname IS NOT NULL
                    OR LENGTH(v_fname) <> 0) THEN
                    IF (match.first_name = v_fname) THEN
                        v_score := v_score + 25;
                        v_info := v_info || 'Matching first name. ';
                    ELSE
                        v_score := v_score + 10;
                        v_info := v_info || 'Like sounding first name. ';
                    END IF;
                END IF;

                --Birth Date
                IF (p_dob IS NOT NULL) THEN
                    v_info := v_info || 'Matching DOB. ';
                    v_score := v_score + 25;
                END IF;

                --Sex
                IF ((   v_sex_code IS NOT NULL
                     OR LENGTH(v_sex_code) <> 0) AND match.sex IS NOT NULL) THEN
                    v_info := v_info || 'Matching sex. ';
                    v_score := v_score + 15;
                END IF;

                --Mark match
                process_match(p_session_legacy, match.SID, v_score, v_info);
            END LOOP;
        --Legacy Participant Search[END]
        ELSE
            --Try matching on Number
            v_score := 90;

            --p_session := core_sidgen.next_sid;--TODO

            --Web Participant Search With Number [BEGIN]
            SELECT 'Matching ' || description || '.', code
              INTO v_info, v_code
              FROM T_OSI_PARTIC_NUMBER_TYPE
             WHERE SID = p_number_type;

            FOR x IN (SELECT pv.SID, pv.participant
                        FROM v_osi_participant_version pv, T_OSI_PARTIC_NUMBER pn
                       WHERE pv.SID = pv.current_version
                         AND pn.participant_version = pv.SID
                         AND pn.num_type = p_number_type
                         AND pn.num_value = p_number
                         AND pv.confirm_by IS NOT NULL
                         AND pv.confirm_on IS NOT NULL)
            LOOP
                INSERT INTO T_OSI_PARTIC_SEARCH_RESULT
                            (session_id, participant, score, info)
                     VALUES (p_session_web, x.participant, v_score, v_info);

                --v_cnt := 1;--TODO
                v_found_match := TRUE;
            END LOOP;

            --Web Participant Search With Number[END]

            --Legacy Participant Search With Number[BEGIN]
            IF (p_number IS NOT NULL) THEN
                IF (p_number_type IS NOT NULL) THEN
                    --Get current code
                    SELECT code, description
                      INTO v_num_type_code, v_num_type_description
                      FROM T_OSI_PARTIC_NUMBER_TYPE
                     WHERE SID = p_number_type;

                    IF (v_num_type_code = 'OID') THEN
                        --Codes don't match in legacy vs. web
                        v_num_type_code := 'OTHER';
                    END IF;

                    v_info := 'Matching ' || v_num_type_description || '.';
                END IF;

                FOR k IN (SELECT person_version
                            FROM ref_t_person_number
                           WHERE UPPER(num_value) LIKE '%' || p_number || '%'
                             AND UPPER(num_type) = UPPER(v_num_type_code))
                LOOP
                    process_match(p_session_legacy, k.person_version, 90, v_info);
                    v_found_match := TRUE;
                END LOOP;
            END IF;

            --Legacy Participant Search With Number[END]
            IF (v_found_match = FALSE AND Osi_Deers.is_searchable_number(p_number_type) = 'Y') THEN
                -- Check deers.
                p_session_web := NULL;
                p_session_legacy := NULL;

                IF Core_Util.get_config('OSI.AUDITING') = 'ON' THEN
                    Log_Info('DEERS:Query for ' || UPPER(trim(p_lname)) || ', ' || p_number);
                END IF;

                p_deers_result :=
                          Osi_Deers.get_deers_information(p_number, UPPER(trim(p_lname)), 1, v_code);
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('check_for_matches: ' || SQLERRM);
            RAISE;
    END check_for_matches;

    PROCEDURE confirm(p_obj IN VARCHAR2) IS
    BEGIN
        UPDATE T_OSI_PARTICIPANT
           SET confirm_on = SYSDATE,
               confirm_by = Core_Context.personnel_name
         WHERE SID = p_obj;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('confirm: ' || SQLERRM);
            RAISE;
    END confirm;

    PROCEDURE unconfirm(p_obj IN VARCHAR2) IS
    BEGIN
        UPDATE T_OSI_PARTICIPANT
           SET confirm_on = NULL,
               confirm_by = NULL
         WHERE SID = p_obj;

        INSERT INTO T_OSI_NOTE
                    (obj, note_type, note_text, lock_mode)
             VALUES (p_obj,
                     (SELECT SID
                        FROM T_OSI_NOTE_TYPE
                       WHERE code = 'UNCONFIRM' AND USAGE = 'NOTELIST'),
                     'Participant was unconfirmed.',
                     'IMMED');
    EXCEPTION
        WHEN OTHERS THEN
            log_error('unconfirm: ' || SQLERRM);
            RAISE;
    END unconfirm;

    PROCEDURE remap_org_names(p_pvop IN VARCHAR2) IS
        v_count     INTEGER;
        v_pv        T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_ok        T_OSI_PARTIC_NAME_TYPE.SID%TYPE;
        v_subtype   T_OSI_PARTICIPANT_NONHUMAN.sub_type%TYPE;
    BEGIN
        -- See if this is a participant sid instead of a version sid.
        v_pv := get_current_version(p_pvop);

        IF (v_pv IS NULL) THEN
            v_pv := p_pvop;
        END IF;

        -- Get the organization type.
        v_subtype := get_subtype_sid(v_pv);

        FOR x IN (SELECT   SID, name_type
                      FROM T_OSI_PARTIC_NAME
                     WHERE participant_version = v_pv
                  ORDER BY create_on ASC)
        LOOP
            -- See if there is a corresponding name for the subtype.
            BEGIN
                SELECT m.name_type
                  INTO v_ok
                  FROM T_OSI_PARTIC_NAME_TYPE_MAP m
                 WHERE m.participant_type = v_subtype AND m.name_type = x.name_type;

                -- Make the first mapped name the default name.
                IF (v_count IS NULL) THEN
                    UPDATE T_OSI_PARTICIPANT_VERSION
                       SET current_name = x.SID
                     WHERE SID = v_pv;

                    v_count := 1;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- This name didn't map so unset it if it's the current name then delete it.
                    UPDATE T_OSI_PARTICIPANT_VERSION
                       SET current_name = NULL
                     WHERE SID = v_pv AND current_name = x.SID;

                    DELETE FROM T_OSI_PARTIC_NAME
                          WHERE SID = x.SID;
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('remap_org_names: ' || SQLERRM);
            RAISE;
    END remap_org_names;

    PROCEDURE replace_with(p_obj IN VARCHAR2, p_replacement IN VARCHAR2) IS
        v_count             INTEGER;
        v_sid               VARCHAR2(20);
        v_note              VARCHAR2(32767);
        v_crlf              VARCHAR2(2)                          := CHR(13) || CHR(10);
        v_obj_version       T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_replace_version   T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_obj_row           v_osi_participant_version%ROWTYPE;
        v_replace_row       v_osi_participant_version%ROWTYPE;

        PROCEDURE log_note(p_note IN VARCHAR2) IS
        BEGIN
            Core_Util.append_info(v_note, p_note, v_crlf);
        END log_note;

        PROCEDURE check_diff(p_target IN VARCHAR2, p_replace IN VARCHAR2, p_note IN VARCHAR2) IS
            v_yn   VARCHAR2(3);
        BEGIN
            IF (NVL(p_target, 'NULL') <> NVL(p_replace, 'NULL')) THEN
                CASE p_target
                    WHEN 'Y' THEN
                        log_note(p_note || '=Yes');
                    WHEN 'N' THEN
                        log_note(p_note || '=No');
                    WHEN 'U' THEN
                        log_note(p_note || '=');
                    ELSE
                        log_note(p_note || '=' || p_target);
                END CASE;
            END IF;
        END check_diff;

        PROCEDURE check_diff(p_target IN DATE, p_replace IN DATE, p_note IN VARCHAR2) IS
        BEGIN
            IF (NVL(p_target, TO_DATE('01/01/1900', 'mm/dd/yyyy')) <>
                                                 NVL(p_replace, TO_DATE('01/01/1900', 'mm/dd/yyyy'))) THEN
                log_note(p_note || '=' || p_target);
            END IF;
        END check_diff;
    BEGIN
        IF (p_obj IS NOT NULL AND p_replacement IS NOT NULL) THEN
            v_obj_version := get_current_version(p_obj);
            v_replace_version := get_current_version(p_replacement);

            -- Agent Applicant File
            FOR c IN (SELECT pi.SID
                        FROM T_OSI_PARTIC_INVOLVEMENT pi, T_OSI_PARTIC_ROLE_TYPE rt
                       WHERE pi.involvement_role = rt.SID
                         AND rt.USAGE = 'SUBJECT'
                         AND rt.obj_type = Core_Obj.lookup_objtype('FILE.AAPP')
                         AND pi.participant_version IN(SELECT SID
                                                         FROM T_OSI_PARTICIPANT_VERSION
                                                        WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_PARTIC_INVOLVEMENT
                       SET participant_version = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate T_AGENT_Applicant filtered out.');
                END;
            END LOOP;

            -- Group Interview
            FOR c IN (SELECT i.SID
                        FROM T_OSI_A_GI_INVOLVEMENT i
                       WHERE participant_version IN(SELECT SID
                                                      FROM T_OSI_PARTICIPANT_VERSION
                                                     WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_A_GI_INVOLVEMENT
                       SET participant_version = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate GI Involvement filtered out.');
                END;
            END LOOP;

            -- Personnel Recent Objects
            FOR c IN (SELECT p.SID
                        FROM T_OSI_PERSONNEL_RECENT_OBJECTS p
                       WHERE p.obj = p_obj)
            LOOP
                BEGIN
                    UPDATE T_OSI_PERSONNEL_RECENT_OBJECTS
                       SET obj = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Personnel Cache filtered out.');
                END;
            END LOOP;

            -- Participant Involvement
            FOR c IN (SELECT pi.SID
                        FROM T_OSI_PARTIC_INVOLVEMENT pi
                       WHERE participant_version IN(SELECT SID
                                                      FROM T_OSI_PARTICIPANT_VERSION
                                                     WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_PARTIC_INVOLVEMENT
                       SET participant_version = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Participant Involvement filtered out.');
                END;
            END LOOP;

            -- Investigative File Specification Victim
            FOR c IN (SELECT i.SID
                        FROM T_OSI_F_INV_SPEC i
                       WHERE i.victim IN(SELECT SID
                                           FROM T_OSI_PARTICIPANT_VERSION
                                          WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_F_INV_SPEC
                       SET victim = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Specification Victim filtered out.');
                END;
            END LOOP;

            -- Investigative File Specification Subject
            FOR c IN (SELECT i.SID
                        FROM T_OSI_F_INV_SPEC i
                       WHERE i.subject IN(SELECT SID
                                            FROM T_OSI_PARTICIPANT_VERSION
                                           WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_F_INV_SPEC
                       SET subject = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Specification Subject filtered out.');
                END;
            END LOOP;

            -- Investigative File Subject Disposition
            FOR c IN (SELECT s.SID
                        FROM T_OSI_F_INV_SUBJ_DISPOSITION s
                       WHERE s.subject IN(SELECT SID
                                            FROM T_OSI_PARTICIPANT_VERSION
                                           WHERE participant = p_obj))
            LOOP
                BEGIN
                    UPDATE T_OSI_F_INV_SUBJ_DISPOSITION
                       SET subject = v_replace_version
                     WHERE SID = c.SID;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        log_note('Duplicate Subject Disposition filtered out.');
                END;
            END LOOP;

            -- Source File
            UPDATE T_OSI_F_SOURCE
               SET participant = p_replacement
             WHERE participant = p_obj;

            -- Participant Relationships
            UPDATE T_OSI_PARTIC_RELATION r
               SET r.partic_a = p_replacement
             WHERE r.partic_a = p_obj
               AND NOT EXISTS(
                       SELECT SID
                         FROM T_OSI_PARTIC_RELATION
                        WHERE partic_a = r.partic_b
                          AND partic_b = p_replacement
                          AND rel_type = r.rel_type
                          AND NVL(known_date, TRUNC(SYSDATE)) = NVL(r.known_date, TRUNC(SYSDATE)));

            UPDATE T_OSI_PARTIC_RELATION r
               SET r.partic_b = p_replacement
             WHERE r.partic_b = p_obj
               AND NOT EXISTS(
                       SELECT SID
                         FROM T_OSI_PARTIC_RELATION
                        WHERE partic_a = r.partic_a
                          AND partic_b = p_replacement
                          AND rel_type = r.rel_type
                          AND NVL(known_date, TRUNC(SYSDATE)) = NVL(r.known_date, TRUNC(SYSDATE)));

            -- For the participant version details we're going to log in the note any differences.
            SELECT *
              INTO v_obj_row
              FROM v_osi_participant_version
             WHERE SID = v_obj_version;

            SELECT *
              INTO v_replace_row
              FROM v_osi_participant_version
             WHERE SID = v_replace_version;

            check_diff(v_obj_row.education_level, v_replace_row.education_level, 'education_level');
            check_diff(v_obj_row.sa_pay_grade_desc, v_replace_row.sa_pay_grade_desc, 'sa_pay_grade');
            check_diff(v_obj_row.sa_pay_plan_desc, v_replace_row.sa_pay_plan_desc, 'sa_pay_plan');
            check_diff(v_obj_row.height, v_replace_row.height, 'height');
            check_diff(v_obj_row.weight, v_replace_row.weight, 'weight');
            check_diff(v_obj_row.race_desc, v_replace_row.race_desc, 'race');
            check_diff(v_obj_row.hair_color_desc, v_replace_row.hair_color_desc, 'hair_color');
            check_diff(v_obj_row.eye_color_desc, v_replace_row.eye_color_desc, 'eye_color');
            check_diff(v_obj_row.age_low, v_replace_row.age_low, 'age_low');
            check_diff(v_obj_row.age_high, v_replace_row.age_high, 'age_high');
            check_diff(v_obj_row.sex_desc, v_replace_row.sex_desc, 'sex');
            check_diff(v_obj_row.sa_service_desc, v_replace_row.sa_service_desc, 'sa_service');
            check_diff(v_obj_row.sa_component_desc, v_replace_row.sa_component_desc, 'sa_component');
            check_diff(v_obj_row.org_uic, v_replace_row.org_uic, 'org_uic');
            check_diff(v_obj_row.org_high_risk, v_replace_row.org_high_risk, 'org_high_risk');
            check_diff(v_obj_row.org_num_people, v_replace_row.org_num_people, 'org_num_people');
            check_diff(v_obj_row.org_supporting_unit,
                       v_replace_row.org_supporting_unit,
                       'org_supporting_unit');
            check_diff(v_obj_row.current_address_desc,
                       v_replace_row.current_address_desc,
                       'current_address');
            check_diff(v_obj_row.build_desc, v_replace_row.build_desc, 'build');
            check_diff(v_obj_row.writing_hand_desc, v_replace_row.writing_hand_desc, 'writing_hand');
            check_diff(v_obj_row.is_bald, v_replace_row.is_bald, 'is_bald');
            check_diff(v_obj_row.bald_comment, v_replace_row.bald_comment, 'bald_comment');
            check_diff(v_obj_row.has_facial_hair, v_replace_row.has_facial_hair, 'has_facial_hair');
            check_diff(v_obj_row.facial_hair_comment,
                       v_replace_row.facial_hair_comment,
                       'facial_hair_comment');
            check_diff(v_obj_row.wears_glasses, v_replace_row.wears_glasses, 'wears_glasses');
            check_diff(v_obj_row.glasses_comment, v_replace_row.glasses_comment, 'glasses_comment');
            check_diff(v_obj_row.is_hard_of_hearing,
                       v_replace_row.is_hard_of_hearing,
                       'is_hard_of_hearing');
            check_diff(v_obj_row.hearing_comment, v_replace_row.hearing_comment, 'hearing_comment');
            check_diff(v_obj_row.has_teeth, v_replace_row.has_teeth, 'has_teeth');
            check_diff(v_obj_row.teeth_comment, v_replace_row.teeth_comment, 'teeth_comment');
            check_diff(v_obj_row.sa_rank, v_replace_row.sa_rank, 'sa_rank');
            check_diff(v_obj_row.sa_rank_date, v_replace_row.sa_rank_date, 'sa_rank_date');
            check_diff(v_obj_row.sa_affiliation_desc,
                       v_replace_row.sa_affiliation_desc,
                       'sa_affiliation');
            check_diff(v_obj_row.sa_specialty_code,
                       v_replace_row.sa_specialty_code,
                       'sa_specialty_code');
            check_diff(v_obj_row.fsa_service_desc, v_replace_row.fsa_service_desc, 'fsa_service');
            check_diff(v_obj_row.fsa_rank, v_replace_row.fsa_rank, 'fsa_rank');
            check_diff(v_obj_row.fsa_equiv_rank, v_replace_row.fsa_equiv_rank, 'fsa_equiv_rank');
            check_diff(v_obj_row.fsa_rank_date, v_replace_row.fsa_rank_date, 'fsa_rank_date');
            check_diff(v_obj_row.org_majcom, v_replace_row.org_majcom, 'org_majcom');
            check_diff(v_obj_row.posture_desc, v_replace_row.posture_desc, 'posture');
            check_diff(v_obj_row.religion, v_replace_row.religion, 'religion');
            check_diff(v_obj_row.religion_involvement_desc,
                       v_replace_row.religion_involvement_desc,
                       'religion_involvement');
            check_diff(v_obj_row.prog_description,
                       v_replace_row.prog_description,
                       'prog_description');
            v_note := v_note || v_crlf;

            /*
             * Now go through all the p_obj data and copy it with the p_replacement sid
             * before deleting p_obj.
             */

            /*
             * For each data element (i.e. table) we want to maintain the audit history so
             * we disable all the triggers before inserting. This requires providing a sid.
             * We only insert records that have certain unique fields.
             */
            EXECUTE IMMEDIATE 'alter table t_osi_partic_citizenship disable all triggers';

            INSERT INTO T_OSI_PARTIC_CITIZENSHIP
                        (SID,
                         participant_version,
                         country,
                         effective_date,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, country, effective_date, create_by,
                       create_on, modify_by, modify_on
                  FROM T_OSI_PARTIC_CITIZENSHIP
                 WHERE participant_version = v_obj_version
                   AND (country, effective_date) NOT IN(
                                                       SELECT country, effective_date
                                                         FROM T_OSI_PARTIC_CITIZENSHIP
                                                        WHERE participant_version =
                                                                                   v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_citizenship enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_mark disable all triggers';

            INSERT INTO T_OSI_PARTIC_MARK
                        (SID,
                         participant_version,
                         mark_type,
                         mark_location,
                         description,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, mark_type, mark_location,
                       description, create_by, create_on, modify_by, modify_on
                  FROM T_OSI_PARTIC_MARK
                 WHERE participant_version = v_obj_version
                   AND (mark_type, mark_location) NOT IN(
                                                       SELECT mark_type, mark_location
                                                         FROM T_OSI_PARTIC_MARK
                                                        WHERE participant_version =
                                                                                   v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_mark enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_name disable all triggers';

            INSERT INTO T_OSI_PARTIC_NAME
                        (SID,
                         participant_version,
                         name_type,
                         title,
                         last_name,
                         first_name,
                         middle_name,
                         cadency,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, name_type, title, last_name,
                       first_name, middle_name, cadency, create_by, create_on, modify_by, modify_on
                  FROM T_OSI_PARTIC_NAME
                 WHERE participant_version = v_obj_version
                   AND (name_type, last_name, first_name, middle_name, cadency) NOT IN(
                                       SELECT name_type, last_name, first_name, middle_name,
                                              cadency
                                         FROM T_OSI_PARTIC_NAME
                                        WHERE participant_version = v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_name enable all triggers';

            -- We'll take all the participant numbers.
            EXECUTE IMMEDIATE 'alter table t_osi_partic_number disable all triggers';

            FOR x IN (SELECT *
                        FROM T_OSI_PARTIC_NUMBER
                       WHERE participant_version = v_obj_version)
            LOOP
                BEGIN
                    INSERT INTO T_OSI_PARTIC_NUMBER
                                (SID,
                                 participant_version,
                                 num_type,
                                 num_value,
                                 issue_date,
                                 issue_country,
                                 issue_state,
                                 issue_province,
                                 expire_date,
                                 note,
                                 create_on,
                                 create_by,
                                 modify_on,
                                 modify_by)
                         VALUES (Core_Sidgen.next_sid,
                                 v_replace_version,
                                 x.num_type,
                                 x.num_value,
                                 x.issue_date,
                                 x.issue_country,
                                 x.issue_state,
                                 x.issue_province,
                                 x.expire_date,
                                 x.note,
                                 x.create_on,
                                 x.create_by,
                                 x.modify_on,
                                 x.modify_by);
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        NULL;
                END;
            END LOOP;

            EXECUTE IMMEDIATE 'alter table t_osi_partic_number enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_org_attr disable all triggers';

            INSERT INTO T_OSI_PARTIC_ORG_ATTR
                        (SID,
                         participant_version,
                         ATTRIBUTE,
                         comments,
                         create_on,
                         create_by,
                         modify_on,
                         modify_by)
                SELECT Core_Sidgen.next_sid, v_replace_version, ATTRIBUTE, comments, create_on,
                       create_by, modify_on, modify_by
                  FROM T_OSI_PARTIC_ORG_ATTR
                 WHERE participant_version = v_obj_version
                   AND (ATTRIBUTE, comments) NOT IN(SELECT ATTRIBUTE, comments
                                                      FROM T_OSI_PARTIC_ORG_ATTR
                                                     WHERE participant_version = v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_org_attr enable all triggers';

            -- This data is handled differently because we need to log the duplicate records.
            EXECUTE IMMEDIATE 'alter table t_osi_partic_vehicle disable all triggers';

            FOR x IN (SELECT plate_num, reg_exp_date, reg_country, reg_state,
                             (SELECT description
                                FROM T_DIBRS_STATE
                               WHERE SID = reg_state) AS state_desc, reg_province, title_owner, vin,
                             make, MODEL, YEAR, color, body_type, gross_weight, num_axles, ROLE,
                             comments, create_by, create_on, modify_by, modify_on
                        FROM T_OSI_PARTIC_VEHICLE
                       WHERE participant_version = v_obj_version)
            LOOP
                DECLARE
                    v_dup   BOOLEAN := FALSE;
                BEGIN
                    FOR y IN (SELECT plate_num, reg_exp_date, reg_country, reg_state, reg_province,
                                     title_owner, vin, make, MODEL, YEAR, color, body_type,
                                     gross_weight, num_axles, ROLE, comments, create_by, create_on,
                                     modify_by, modify_on
                                FROM T_OSI_PARTIC_VEHICLE
                               WHERE participant_version = v_replace_version)
                    LOOP
                        IF (    x.plate_num = y.plate_num
                            AND (   x.reg_state = y.reg_state
                                 OR x.reg_province = y.reg_province)) THEN
                            -- This is a duplicate. Log it.
                            v_dup := TRUE;
                            v_note := v_note || 'Vehicle Information Duplication: plate number=';
                            v_note :=
                                v_note || x.plate_num || ' state/province='
                                || NVL(x.state_desc, x.reg_province) || v_crlf;
                        END IF;
                    END LOOP;

                    IF (NOT v_dup) THEN
                        INSERT INTO T_OSI_PARTIC_VEHICLE
                                    (SID,
                                     participant_version,
                                     plate_num,
                                     reg_exp_date,
                                     reg_country,
                                     reg_state,
                                     reg_province,
                                     title_owner,
                                     vin,
                                     make,
                                     MODEL,
                                     YEAR,
                                     color,
                                     body_type,
                                     gross_weight,
                                     num_axles,
                                     ROLE,
                                     comments,
                                     create_by,
                                     create_on,
                                     modify_by,
                                     modify_on)
                             VALUES (Core_Sidgen.next_sid,
                                     v_replace_version,
                                     x.plate_num,
                                     x.reg_exp_date,
                                     x.reg_country,
                                     x.reg_state,
                                     x.reg_province,
                                     x.title_owner,
                                     x.vin,
                                     x.make,
                                     x.MODEL,
                                     x.YEAR,
                                     x.color,
                                     x.body_type,
                                     x.gross_weight,
                                     x.num_axles,
                                     x.ROLE,
                                     x.comments,
                                     x.create_by,
                                     x.create_on,
                                     x.modify_by,
                                     x.modify_on);
                    END IF;
                END;
            END LOOP;

            EXECUTE IMMEDIATE 'alter table t_osi_partic_vehicle enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_partic_contact disable all triggers';

            INSERT INTO T_OSI_PARTIC_CONTACT
                        (SID,
                         participant_version,
                         TYPE,
                         VALUE,
                         create_by,
                         create_on,
                         modify_by,
                         modify_on)
                SELECT Core_Sidgen.next_sid, v_replace_version, TYPE, VALUE, create_by, create_on,
                       modify_by, modify_on
                  FROM T_OSI_PARTIC_CONTACT
                 WHERE participant_version = v_obj_version
                   AND (TYPE, VALUE) NOT IN(SELECT TYPE, VALUE
                                              FROM T_OSI_PARTIC_CONTACT
                                             WHERE participant_version = v_replace_version);

            EXECUTE IMMEDIATE 'alter table t_osi_partic_contact enable all triggers';

            -- In Web I2MS participant addresses are spread across two tables.
            EXECUTE IMMEDIATE 'alter table t_osi_partic_address disable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_address disable all triggers';

            FOR x IN (SELECT va.address_type, va.address_1, va.address_2, va.city, va.province,
                             va.state, va.postal_code, va.country, va.start_date, va.end_date,
                             va.known_date, va.geo_coords, va.comments, va.create_on, va.create_by,
                             va.modify_on, va.modify_by, a.create_on AS c1, a.create_by AS c2,
                             a.modify_on AS m1, a.modify_by AS m2
                        FROM v_osi_partic_address va, T_OSI_PARTIC_ADDRESS a
                       WHERE va.participant_version = v_obj_version
                         AND va.participant_version = a.participant_version
                         AND va.SID = a.SID
                         AND (va.address_1,
                              va.address_2,
                              va.city,
                              va.province,
                              va.state,
                              va.postal_code,
                              va.country,
                              va.start_date,
                              va.end_date,
                              va.known_date,
                              va.geo_coords,
                              va.comments) NOT IN(
                                 SELECT address_1, address_2, city, province, state, postal_code,
                                        country, start_date, end_date, known_date, geo_coords,
                                        comments
                                   FROM v_osi_partic_address
                                  WHERE participant_version = v_replace_version))
            LOOP
                INSERT INTO T_OSI_ADDRESS
                            (SID,
                             obj,
                             address_type,
                             address_1,
                             address_2,
                             city,
                             province,
                             state,
                             postal_code,
                             country,
                             geo_coords,
                             start_date,
                             end_date,
                             known_date,
                             comments,
                             create_on,
                             create_by,
                             modify_on,
                             modify_by)
                     VALUES (Core_Sidgen.next_sid,
                             p_replacement,
                             x.address_type,
                             x.address_1,
                             x.address_2,
                             x.city,
                             x.province,
                             x.state,
                             x.postal_code,
                             x.country,
                             x.geo_coords,
                             x.start_date,
                             x.end_date,
                             x.known_date,
                             x.comments,
                             x.create_on,
                             x.create_by,
                             x.modify_on,
                             x.modify_by)
                  RETURNING SID
                       INTO v_sid;

                INSERT INTO T_OSI_PARTIC_ADDRESS
                            (SID,
                             participant_version,
                             address,
                             create_on,
                             create_by,
                             modify_on,
                             modify_by)
                     VALUES (Core_Sidgen.next_sid, v_replace_version, v_sid, x.c1, x.c2, x.m1, x.m2);
            END LOOP;

            EXECUTE IMMEDIATE 'alter table t_osi_partic_address enable all triggers';

            EXECUTE IMMEDIATE 'alter table t_osi_address enable all triggers';

            DELETE FROM T_CORE_OBJ
                  WHERE SID = p_obj;

            IF (v_note IS NOT NULL) THEN
                v_note :=
                    'Deleted target data: ' || v_obj_row.obj_type_desc || ' Name= '
                    || v_obj_row.full_name || v_crlf || RTRIM(v_note, ', ');

                INSERT INTO T_OSI_NOTE
                            (obj, note_type, note_text, creating_personnel)
                     VALUES (p_replacement,
                             (SELECT SID
                                FROM T_OSI_NOTE_TYPE
                               WHERE obj_type = Core_Obj.lookup_objtype('PARTICIPANT')
                                 AND code = 'CONFIRM_REPLACE'),
                             v_note,
                             Core_Context.personnel_sid);
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('replace_with: ' || SQLERRM);
            RAISE;
    END replace_with;

    PROCEDURE run_report_details(p_obj IN VARCHAR2) IS
        v_date_fmt        VARCHAR2(11);
        v_mugshot         BLOB;
        v_ok              VARCHAR2(1000);
        v_template_date   DATE;
        v_mime_type       T_CORE_TEMPLATE.mime_type%TYPE;
        v_mime_disp       T_CORE_TEMPLATE.mime_disposition%TYPE;
        v_ot_code         T_CORE_OBJ_TYPE.code%TYPE;
        v_pv_sid          T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_sa_record       v_osi_partic_sa%ROWTYPE;
        v_counter         INTEGER                                 := 0;
        v_clob            CLOB;
        v_temp_clob       CLOB;
        v_main_clob       CLOB;
        v_pc_clob         CLOB;
        v_sa_clob         CLOB;
        v_bgcolor         VARCHAR2(9);
        v_name            VARCHAR2(200);
        v_no_data         VARCHAR2(35)                         := '<tr><td>No Data Found</td></tr>';
        v_address_list    VARCHAR2(400)
            := '<table class="bTABLE"><tr><td class="bTD" width="55%"><strong><u>All Addresses:</u></strong></td><td class="bTD" width="15%"><strong><u>Start Date</u></strong></td><td class="bTD" width="15%"><strong><u>End Date</u></strong></td><td class="bTD" width="15%"><strong><u>Known Date</u></strong></td></tr>[TOKEN@ADDRESS_ROWS]</table>';

        v_seq             NUMBER := 0;
    BEGIN
        v_pv_sid := get_current_version(p_obj);
        v_date_fmt := Core_Util.get_config('CORE.DATE_FMT_DAY');
        -- Get the style for this report.
        v_ok :=
            Core_Template.get_latest('PARTIC_DETAILS_STYLE',
                                     v_temp_clob,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        -- Load up the main template.
        v_ok :=
            Core_Template.get_latest('PARTIC_DETAILS_MAIN',
                                     v_main_clob,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        -- Apply the style.
        v_ok := Core_Template.replace_tag(v_main_clob, 'STYLE', v_temp_clob);
        v_temp_clob := NULL;
        -- All this applies to every participant type.
        v_name := Osi_Participant.get_name(p_obj);
        v_ok := Core_Template.replace_tag(v_main_clob, 'TITLE_CONTENTS', v_name);
        v_ok := Core_Template.replace_tag(v_main_clob, 'CURRENT_NAME', v_name);

        -- Other names.
        FOR x IN (SELECT full_name, type_description AS TYPE
                    FROM v_osi_partic_name
                   WHERE participant_version = v_pv_sid)
        --AND is_current = 'N')
        LOOP
            Osi_Util.aitc(v_temp_clob, '<b>' || x.TYPE || '</b> - ' || x.full_name || '<br>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            v_ok := Core_Template.replace_tag(v_main_clob, 'OTHER_NAMES', '');
        ELSE
            v_ok := Core_Template.replace_tag(v_main_clob, 'OTHER_NAMES', v_temp_clob);
        END IF;

        v_temp_clob := NULL;

        -- Current address.
        FOR x IN (SELECT single_line
                    FROM v_osi_partic_address
                   WHERE participant = p_obj AND is_current = 'Y')
        LOOP
            Osi_Util.aitc(v_temp_clob, x.single_line);
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            v_temp_clob := '';
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'CURRENT_ADDRESS', v_temp_clob);
        v_temp_clob := NULL;

        FOR x IN (SELECT single_line, type_description AS TYPE, start_date, end_date, known_date
                    FROM v_osi_partic_address
                   WHERE participant = p_obj AND is_current = 'N' AND type_code <> 'BIRTH')
        LOOP
            v_counter := v_counter + 1;

            -- Alternate row colors.
            IF (MOD(v_counter, 2) = 0) THEN
                v_bgcolor := '"#f5f5f5"';
            ELSE
                v_bgcolor := '""';
            END IF;

            IF (x.single_line IS NOT NULL) THEN
                Osi_Util.aitc(v_temp_clob,
                              '<tr bgcolor=' || v_bgcolor || '><td class="bTD" width="55%"><STRONG>'
                              || x.TYPE || '</STRONG>' || ' - ' || x.single_line
                              || '</td><td class="bTD" width="15%">'
                              || Osi_Util.display_precision_date(x.start_date)
                              || ' </td><td class="bTD" width="15%">'
                              || Osi_Util.display_precision_date(x.end_date)
                              || ' </td><td class="bTD" width="15%">'
                              || Osi_Util.display_precision_date(x.known_date) || ' </td></tr>');
            END IF;
        END LOOP;

        v_counter := 0;

        IF (v_temp_clob IS NULL) THEN
            v_ok := Core_Template.replace_tag(v_main_clob, 'ADDRESS_LIST', '');
        ELSE
            -- v_address_list is the table that we will add rows of addresses to.
            v_ok := Core_Template.replace_tag(v_main_clob, 'ADDRESS_LIST', v_address_list);
            v_ok := Core_Template.replace_tag(v_main_clob, 'ADDRESS_ROWS', v_temp_clob);
        END IF;

        v_temp_clob := NULL;

        SELECT ot.code
          INTO v_ot_code
          FROM T_CORE_OBJ o, T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_obj AND o.obj_type = ot.SID;

        -- Individual only data.
        IF (v_ot_code = 'PART.INDIV') THEN
            -- Make the first cell a bit smaller to fit the mugshot in.
            v_ok := Core_Template.replace_tag(v_main_clob, 'IWIDTH', '80%');
            -- Set the colSpan attribute to the default.
            v_ok := Core_Template.replace_tag(v_main_clob, 'COLSPAN', '1');
            -- Remove the replacement tokens for the other participant types.
            v_ok := Core_Template.replace_tag(v_main_clob, 'NON_INDIV', '');

            SELECT MIN(SEQ)
             INTO V_SEQ
            FROM v_osi_partic_images
            WHERE obj = p_obj;

            -- Get the mugshot image.
            FOR x IN (SELECT   SID
                          FROM v_osi_partic_images
                         WHERE obj = p_obj AND seq = v_seq)
            LOOP
                Osi_Util.aitc(v_temp_clob,
                              '<td align="center"><img src="f?p=' || v( 'APP_ID') || ':801:'
                              || v( 'SESSION') || ':' || x.SID
                              || '" border="0" alt="Mugshot" style="vertical-align:top;"/></td>');
            END LOOP;

            IF (v_temp_clob IS NULL) THEN
                Osi_Util.aitc(v_temp_clob,
                              '<td align="center"><strong>Image Not Available</strong></td>');
            END IF;

            v_ok := Core_Template.replace_tag(v_main_clob, 'MUGSHOT', v_temp_clob);
            v_temp_clob := NULL;
            -- Contact list data.
            Osi_Util.aitc(v_temp_clob, '<strong><u>Contact Information List:</u></strong><br>');

            -- Build the list of contact values.
            FOR x IN (SELECT r.description AS TYPE, c.VALUE
                        FROM T_OSI_PARTIC_CONTACT c, T_OSI_REFERENCE r
                       WHERE c.participant_version = v_pv_sid AND c.TYPE = r.SID)
            LOOP
                Osi_Util.aitc(v_temp_clob, x.TYPE || ' - ' || x.VALUE || '<br>');
            END LOOP;

            v_ok := Core_Template.replace_tag(v_main_clob, 'CONTACT_LIST', v_temp_clob);
            v_temp_clob := NULL;
            -- Physical information sub-template.
            v_ok :=
                Core_Template.get_latest('PARTIC_DETAILS_PHYSICAL',
                                         v_pc_clob,
                                         v_template_date,
                                         v_mime_type,
                                         v_mime_disp);

            FOR x IN (SELECT a.single_line
                        FROM v_osi_partic_address a
                       WHERE a.participant_version = v_pv_sid AND a.type_code = 'BIRTH')
            LOOP
                Osi_Util.aitc(v_temp_clob, x.single_line);
            END LOOP;

            v_ok := Core_Template.replace_tag(v_pc_clob, 'BIRTH_ADDRESS', v_temp_clob);
            v_temp_clob := NULL;

            -- Most of the physical data is handled here.
            FOR x IN (SELECT bi.nationality, FLOOR((SYSDATE - bi.dob) / 365) AS age, bi.dob,
                             bi.ethnicity_desc, pc.is_hard_of_hearing_desc, pc.hearing_comment,
                             pc.has_teeth_desc, pc.teeth_comment, pc.has_facial_hair_desc,
                             pc.facial_hair_comment, pc.wears_glasses_desc, pc.glasses_comment,
                             pc.is_bald_desc, pc.bald_comment, pc.height, pc.weight,
                             pc.hair_color_desc, pc.eye_color_desc, pc.sex_desc, pc.build_desc,
                             pc.posture_desc, pc.writing_hand_desc, pc.race_desc
                        FROM v_osi_partic_birth_info bi, v_osi_partic_physical_chars pc
                       WHERE pc.SID = bi.SID AND pc.SID = v_pv_sid)
            LOOP
                v_ok := Core_Template.replace_tag(v_pc_clob, 'NATIONALITY', x.nationality);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'AGE', x.age);
                v_ok :=
                     Core_Template.replace_tag(v_pc_clob, 'BIRTH_DATE', TO_CHAR(x.dob, v_date_fmt));
                v_ok := Core_Template.replace_tag(v_pc_clob, 'ETHNICITY', x.ethnicity_desc);
                v_ok :=
                    Core_Template.replace_tag(v_pc_clob,
                                              'IS_HARD_OF_HEARING',
                                              x.is_hard_of_hearing_desc);
                v_ok :=
                    Core_Template.replace_tag(v_pc_clob,
                                              'HARD_OF_HEARING_COMMENT',
                                              x.hearing_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'HAS_TEETH', x.has_teeth_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'TEETH_COMMENT', x.teeth_comment);
                v_ok :=
                     Core_Template.replace_tag(v_pc_clob, 'HAS_FACIAL_HAIR', x.has_facial_hair_desc);
                v_ok :=
                    Core_Template.replace_tag(v_pc_clob,
                                              'FACIAL_HAIR_COMMENT',
                                              x.facial_hair_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'WEARS_GLASSES', x.wears_glasses_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'GLASSES_COMMENT', x.glasses_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'IS_BALD', x.is_bald_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'BALD_COMMENT', x.bald_comment);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'HEIGHT', x.height);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'WEIGHT', x.weight);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'HAIR_COLOR', x.hair_color_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'EYE_COLOR', x.eye_color_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'SEX', x.sex_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'BUILD', x.build_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'POSTURE', x.posture_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'WRITING_HAND', x.writing_hand_desc);
                v_ok := Core_Template.replace_tag(v_pc_clob, 'RACE', x.race_desc);
            END LOOP;

            -- Get citizenships.
            FOR x IN (SELECT d.description AS country
                        FROM T_OSI_PARTIC_CITIZENSHIP pc, T_DIBRS_COUNTRY d
                       WHERE pc.participant_version = v_pv_sid AND pc.country = d.SID)
            LOOP
                Osi_Util.aitc(v_temp_clob, x.country || '; ');
            END LOOP;

            v_ok := Core_Template.replace_tag(v_pc_clob, 'CITIZENSHIP', RTRIM(v_temp_clob, '; '));
            v_temp_clob := NULL;

            -- Get special marks.
            FOR x IN (SELECT m.description AS comment_txt, ml.description AS LOCATION,
                             mt.description AS TYPE
                        FROM T_OSI_PARTIC_MARK m,
                             T_DIBRS_MARK_LOCATION_TYPE ml,
                             T_DIBRS_MARK_TYPE mt
                       WHERE m.participant_version = v_pv_sid
                         AND m.mark_type = mt.SID
                         AND m.mark_location = ml.SID)
            LOOP
                IF (x.comment_txt IS NULL) THEN
                    Osi_Util.aitc(v_temp_clob, x.TYPE);
                ELSE
                    Osi_Util.aitc(v_temp_clob, x.comment_txt || '-' || x.TYPE);
                END IF;

                Osi_Util.aitc(v_temp_clob, '-' || x.LOCATION || ';');
            END LOOP;

            v_ok := Core_Template.replace_tag(v_pc_clob, 'SPECIAL_MARKS', RTRIM(v_temp_clob, '; '));
            v_temp_clob := NULL;
            -- Add the sub-template to the main template.
            v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_PHYSICAL', v_pc_clob);
            -- Service affiliation sub-template.
            v_ok :=
                Core_Template.get_latest('PARTIC_DETAILS_SA',
                                         v_sa_clob,
                                         v_template_date,
                                         v_mime_type,
                                         v_mime_disp);

            BEGIN
                SELECT *
                  INTO v_sa_record
                  FROM v_osi_partic_sa
                 WHERE SID = v_pv_sid;

                IF (   v_sa_record.service_desc IS NOT NULL
                    OR v_sa_record.pay_grade_desc IS NOT NULL
                    OR v_sa_record.pay_plan_desc IS NOT NULL
                    OR v_sa_record.rank IS NOT NULL
                    OR v_sa_record.rank_date IS NOT NULL
                    OR v_sa_record.component_desc IS NOT NULL
                    OR v_sa_record.affiliation_desc IS NOT NULL
                    OR v_sa_record.specialty_code IS NOT NULL
                    OR v_sa_record.fsa_rank IS NOT NULL
                    OR v_sa_record.fsa_equiv_rank IS NOT NULL
                    OR v_sa_record.fsa_rank_date IS NOT NULL) THEN
                    v_ok :=
                          Core_Template.replace_tag(v_sa_clob, 'SERVICE', v_sa_record.service_desc);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'PAY_GRADE',
                                                  v_sa_record.pay_grade_desc);
                    v_ok :=
                         Core_Template.replace_tag(v_sa_clob, 'PAY_PLAN', v_sa_record.pay_plan_desc);
                    v_ok := Core_Template.replace_tag(v_sa_clob, 'RANK', v_sa_record.rank);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'RANK_DATE',
                                                  TO_CHAR(v_sa_record.rank_date, v_date_fmt));
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob, 'COMPONENT',
                                                  v_sa_record.component_desc);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'AFFILIATION',
                                                  v_sa_record.affiliation_desc);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'SPECIALTY_CODE',
                                                  v_sa_record.specialty_code);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'FSA_SERVICE',
                                                  v_sa_record.fsa_service_desc);
                    v_ok := Core_Template.replace_tag(v_sa_clob, 'FSA_RANK', v_sa_record.fsa_rank);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'FSA_EQUIV_RANK',
                                                  v_sa_record.fsa_equiv_rank);
                    v_ok :=
                        Core_Template.replace_tag(v_sa_clob,
                                                  'FSA_RANK_DATE',
                                                  TO_CHAR(v_sa_record.fsa_rank_date, v_date_fmt));
                    -- Add the sub-template to the main template.
                    v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', v_sa_clob);
                ELSE
                    v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', '');
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', '');
            END;
        END IF;

        -- Nonindividual only data.
        IF (v_ot_code LIKE 'PART.NONINDIV%') THEN
            -- Make the first cell as wide as the table since there is no mugshot.
            v_ok := Core_Template.replace_tag(v_main_clob, 'IWIDTH', '100%');
            -- Set the colSpan attribute to 2 so any following table rows that have two columns
            -- won't mess up the first row.
            v_ok := Core_Template.replace_tag(v_main_clob, 'COLSPAN', '2');
            -- Remove the replacement tokens not applicable to these participant types.
            v_ok := Core_Template.replace_tag(v_main_clob, 'MUGSHOT', '');
            v_ok := Core_Template.replace_tag(v_main_clob, 'CONTACT_LIST', '');
            v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_PHYSICAL', '');
            v_ok := Core_Template.replace_tag(v_main_clob, 'PARTIC_DETAILS_SA', '');
            v_temp_clob := NULL;

            FOR x IN (SELECT r.description AS TYPE, n.co_cage, n.org_uic,
                             r2.description AS org_majcom, n.org_num_people,
                             DECODE(n.org_high_risk, 'Y', 'Yes', 'N', 'No', '') AS org_high_risk,
                             n.prog_description
                        FROM T_OSI_PARTICIPANT_NONHUMAN n, T_OSI_REFERENCE r, T_OSI_REFERENCE r2
                       WHERE n.sub_type = r.SID(+) AND n.org_majcom = r2.SID(+)
                             AND n.SID = v_pv_sid)
            LOOP
                IF (v_ot_code = 'PART.NONINDIV.COMP') THEN
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2" width="100%">');
                    Osi_Util.aitc(v_temp_clob, '<strong>Sub Type:</strong> ' || x.TYPE || '<br>');
                    Osi_Util.aitc(v_temp_clob, '<strong>Cage Code:</strong> ' || x.co_cage);
                    Osi_Util.aitc(v_temp_clob, '</td></tr>');
                ELSIF(v_ot_code = 'PART.NONINDIV.ORG') THEN
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2" width="100%">');
                    Osi_Util.aitc(v_temp_clob, '<strong>Sub Type:</strong> ' || x.TYPE || '<br>');
                    Osi_Util.aitc(v_temp_clob, '<strong>UIC:</strong> ' || x.org_uic || '<br>');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>Major Command:</strong> ' || x.org_majcom || '<br>');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>Number of People:</strong> ' || x.org_num_people
                                  || '<br>');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>High Risk:</strong> ' || x.org_high_risk || '<br>');
                    Osi_Util.aitc(v_temp_clob, '</td></tr>');
                    -- Time for organization specifics. Add the header row first.
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2"><strong>Specifics: </strong>');

                    FOR x IN (SELECT a.comments, AT.CATEGORY, AT.sub_category
                                FROM T_OSI_PARTIC_ORG_ATTR a, T_OSI_PARTIC_ORG_ATTR_TYPE AT
                               WHERE a.participant_version = v_pv_sid AND a.ATTRIBUTE = AT.SID(+))
                    LOOP
                        IF (v_counter = 0) THEN
                            -- Close the header row.
                            Osi_Util.aitc(v_temp_clob, '</td></tr>');
                        END IF;

                        v_counter := v_counter + 1;
                        Osi_Util.aitc(v_temp_clob,
                                      '<tr><td><strong>' || v_counter || '</strong></td>');
                        Osi_Util.aitc(v_temp_clob,
                                      '<td><strong>Category</strong> - ' || x.CATEGORY || '<br>');
                        Osi_Util.aitc(v_temp_clob,
                                      '<strong>Sub-Category</strong> - ' || x.sub_category || '<br>');
                        Osi_Util.aitc(v_temp_clob, '<strong>Comments</strong> - ' || x.comments);
                        Osi_Util.aitc(v_temp_clob, '</td></tr>');
                    END LOOP;

                    IF (v_counter = 0) THEN
                        Osi_Util.aitc(v_temp_clob, 'No Data Found');
                        -- Close the header row.
                        Osi_Util.aitc(v_temp_clob, '</td></tr>');
                    END IF;

                    v_counter := 0;
                ELSIF(v_ot_code = 'PART.NONINDIV.PROG') THEN
                    Osi_Util.aitc(v_temp_clob, '<tr><td colspan="2" width="100%">');
                    Osi_Util.aitc(v_temp_clob,
                                  '<strong>Program Description:</strong> ' || x.prog_description);
                    Osi_Util.aitc(v_temp_clob, '</td></tr>');
                END IF;

                v_ok := Core_Template.replace_tag(v_main_clob, 'NON_INDIV', v_temp_clob);
                v_temp_clob := NULL;
            END LOOP;
        END IF;

        -- Remaining object data.
        v_counter := 0;

        -- Identifying Numbers.
        FOR x IN (SELECT   nt.description AS TYPE, n.num_value, ds.description AS issue_state,
                           dc.description AS issue_country, n.issue_province
                      FROM T_OSI_PARTIC_NUMBER n,
                           T_OSI_PARTIC_NUMBER_TYPE nt,
                           T_DIBRS_STATE ds,
                           T_DIBRS_COUNTRY dc
                     WHERE n.participant_version = v_pv_sid
                       AND n.num_type = nt.SID
                       AND n.issue_state = ds.SID(+)
                       AND n.issue_country = dc.SID(+)
                  ORDER BY TYPE)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || x.TYPE);
            Core_Util.append_info_to_clob(v_temp_clob, x.num_value);
            Core_Util.append_info_to_clob(v_temp_clob, x.issue_state);
            Core_Util.append_info_to_clob(v_temp_clob, x.issue_country);
            Core_Util.append_info_to_clob(v_temp_clob, x.issue_province);
            Osi_Util.aitc(v_temp_clob, '</td></td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ID_NUMBERS', v_temp_clob);
        v_temp_clob := NULL;
        -- Associated Activities
        -- TODO: Add Handling Instructions
        v_counter := 0;

        FOR x IN (SELECT SID, ROLE, activity, activity_date, ID, title
                    FROM v_osi_partic_act_involvement
                   WHERE participant_version = v_pv_sid)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || Osi_Object.get_open_link(x.activity, x.ID));
            Core_Util.append_info_to_clob(v_temp_clob, x.title);
            Core_Util.append_info_to_clob(v_temp_clob, x.ROLE || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ASSOCIATED_ACTIVITIES', v_temp_clob);
        v_temp_clob := NULL;
        -- Associated Files
        -- TODO: Add Handling Instructions
        v_counter := 0;

        FOR x IN (SELECT SID, ROLE, file_sid, ID, title
                    FROM v_osi_partic_file_involvement
                   WHERE participant_version = v_pv_sid)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || Osi_Object.get_open_link(x.file_sid, x.ID));
            Core_Util.append_info_to_clob(v_temp_clob, x.title);
            Core_Util.append_info_to_clob(v_temp_clob, x.ROLE || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ASSOCIATED_FILES', v_temp_clob);
        v_temp_clob := NULL;
        -- Attachments: The only ones we're interested in are mugshots.
        v_counter := 0;

        FOR x IN (SELECT SID, NVL(description, SOURCE) AS description, content
                    FROM v_osi_partic_images
                   WHERE obj = p_obj)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="5%"><strong>' || v_counter || '</strong></td><td>');

            IF (x.content IS NOT NULL) THEN
                Osi_Util.aitc(v_temp_clob,
                              '<a href="f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':'
                              || x.SID || '" target="blank"/>');
            END IF;

            Osi_Util.aitc(v_temp_clob, x.description || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'ATTACHMENTS', v_temp_clob);
        v_temp_clob := NULL;
        -- Relationships
        v_counter := 0;

        FOR x IN (SELECT   this_participant, related_to,
                           DECODE(get_participant(v_pv_sid),
                                  this_participant, related_name,
                                  this_name) AS NAME,
                           description, specifics, comments, mod2_value
                      FROM v_osi_partic_relation
                     WHERE (   this_participant = get_participant(v_pv_sid)
                            OR related_to = get_participant(v_pv_sid))
                       AND description IS NOT NULL
                  ORDER BY description, NAME)
        LOOP
            IF (   (NVL(x.mod2_value, 'xxx') LIKE 'ORCON%')
                OR (NVL(x.mod2_value, 'xxx') LIKE 'LIMDIS%')) THEN
                --TODO: Replace with a system log entry.
                log_error
                    ('run_report_details: Object is ORCON or LIMDIS - User does not have permission to view document therefore no link will be generated');
            ELSE
                v_counter := v_counter + 1;
                Osi_Util.aitc(v_temp_clob,
                              '<tr><td width="5%"><strong>' || v_counter || '</strong></td>');

                IF (x.related_to = v_pv_sid) THEN
                    Osi_Util.aitc
                            (v_temp_clob,
                             '<td>' || x.description || ': '
                             || Osi_Object.get_tagline_link(get_current_version(x.this_participant))
                             || '</td></tr>');
                ELSE
                    Osi_Util.aitc(v_temp_clob,
                                  '<td>' || x.description || ': '
                                  || Osi_Object.get_tagline_link(get_current_version(x.related_to))
                                  || '</td></tr>');
                END IF;

                IF (x.specifics IS NOT NULL) THEN
                    Osi_Util.aitc(v_temp_clob,
                                  '<tr><td></td><td bgcolor="#f5f5f5"><b>Specifics: </b>'
                                  || x.specifics || '</td></tr>');
                END IF;

                IF (LENGTH(x.comments) > 0) THEN
                    Osi_Util.aitc(v_temp_clob,
                                  '<tr><td></td><td bgcolor="#f5f5f5"><b>Comments: </b>'
                                  || x.comments || '</td></tr>');
                END IF;
            END IF;
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'RELATIONSHIPS', v_temp_clob);
        v_temp_clob := NULL;
        -- Notes
        v_counter := 0;

        FOR x IN (SELECT nt.description AS TYPE, n.create_on, n.note_text
                    FROM T_OSI_NOTE n, T_OSI_NOTE_TYPE nt
                   WHERE n.obj = p_obj AND n.note_type = nt.SID)
        LOOP
            v_counter := v_counter + 1;
            Osi_Util.aitc(v_temp_clob,
                          '<tr><td width="25%"><strong>' || v_counter || ': ' || x.TYPE || '<br>'
                          || TO_CHAR(x.create_on, v_date_fmt || ' hh24:mi:ss') || '</strong></td>');
            Osi_Util.aitc(v_temp_clob, '<td>' || Core_Util.html_ize(x.note_text) || '</td></tr>');
        END LOOP;

        IF (v_temp_clob IS NULL) THEN
            Osi_Util.aitc(v_temp_clob, v_no_data);
        END IF;

        v_ok := Core_Template.replace_tag(v_main_clob, 'NOTES', v_temp_clob);
        v_ok := Core_Util.serve_clob(v_main_clob);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('run_report_details: ' || SQLERRM);
            RAISE;
    END run_report_details;

    PROCEDURE set_address_sid(p_sid IN VARCHAR2) IS
    BEGIN
        v_address_sid := p_sid;
    END set_address_sid;

    PROCEDURE set_current_address(p_pvop IN VARCHAR2, p_address_sid IN VARCHAR2 := NULL) IS
        v_new_current   T_OSI_PARTIC_ADDRESS.SID%TYPE;
    BEGIN
        v_new_current := p_address_sid;

        IF (v_new_current IS NULL) THEN
            -- No address was given so find the latest one added.
            FOR x IN (SELECT   a.SID
                          FROM v_osi_partic_address a
                         WHERE (   a.participant_version = p_pvop
                                OR a.participant = p_pvop)
                      ORDER BY a.create_on DESC)
            LOOP
                v_new_current := x.SID;
                EXIT;
            END LOOP;
        END IF;

        UPDATE v_osi_participant_version
           SET current_address = v_new_current
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);
    END set_current_address;

    PROCEDURE set_current_name(p_pvop IN VARCHAR2, p_name_sid IN VARCHAR2 := NULL) IS
        v_new_current   T_OSI_PARTIC_NAME.SID%TYPE;
    BEGIN
        v_new_current := p_name_sid;

        IF (v_new_current IS NULL) THEN
            -- No name was given so see if there is a LEGAL name.
            BEGIN
                SELECT n.SID
                  INTO v_new_current
                  FROM T_OSI_PARTIC_NAME n,
                       v_osi_participant_version pv,
                       T_OSI_PARTIC_NAME_TYPE_MAP t
                 WHERE (   pv.SID = p_pvop
                        OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                   AND n.participant_version = pv.SID
                   AND n.name_type = t.SID
                   AND t.max_num = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_new_current := NULL;
            END;

            IF (v_new_current IS NULL) THEN
                -- There was no LEGAL name so get the latest name added.
                FOR x IN (SELECT   n.SID
                              FROM T_OSI_PARTIC_NAME n,
                                   v_osi_participant_version pv,
                                   T_OSI_PARTIC_NAME_TYPE t
                             WHERE (   pv.SID = p_pvop
                                    OR (pv.participant = p_pvop AND pv.SID = pv.current_version))
                               AND n.participant_version = pv.SID
                               AND n.name_type = t.SID
                          ORDER BY n.create_on DESC)
                LOOP
                    v_new_current := x.SID;
                    EXIT;
                END LOOP;
            END IF;
        END IF;

        UPDATE v_osi_participant_version
           SET current_name = v_new_current
         WHERE SID = p_pvop
            OR (participant = p_pvop AND SID = current_version);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('set_current_name: ' || SQLERRM);
    END set_current_name;

    PROCEDURE set_image_sid(p_sid IN VARCHAR2) IS
    BEGIN
        v_image_sid := p_sid;
    END set_image_sid;

    /* Given an Object Type SID, USAGE and CODE - Returns the SID of the involvement type */
    FUNCTION get_inv_type_sid(p_obj_type IN VARCHAR2, p_usage IN VARCHAR2, p_code IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   T_OSI_PARTIC_ROLE_TYPE.SID%TYPE;
    BEGIN
        SELECT SID
          INTO v_return
          FROM T_OSI_PARTIC_ROLE_TYPE
         WHERE obj_type = p_obj_type AND USAGE = p_usage AND code = p_code;

        RETURN v_return;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --No matching TYPE SID was found
            RETURN NULL;
        WHEN OTHERS THEN
            --Some other error
            log_error('osi_participant.get_inv_type_sid: ' || SQLERRM);
            RAISE;
    END get_inv_type_sid;

    PROCEDURE import_legacy_part_version(
        p_legacy_person_version   IN   VARCHAR2,
        p_new_person              IN   VARCHAR2) IS
        --T_OSI_PERSON_CHARS Columns
        v_osi_person_chars_sex           T_OSI_PERSON_CHARS.sex%TYPE;
        v_osi_person_chars_eye_color     T_OSI_PERSON_CHARS.eye_color%TYPE;
        v_osi_person_chars_hair_color    T_OSI_PERSON_CHARS.hair_color%TYPE;
        v_osi_person_chars_blood_type    T_OSI_PERSON_CHARS.blood_type%TYPE;
        v_osi_person_chars_race          T_OSI_PERSON_CHARS.race%TYPE;
        v_osi_person_chars_sa_pay_plan   T_OSI_PERSON_CHARS.sa_pay_plan%TYPE;
        v_osi_person_chars_sa_pay_grad   T_OSI_PERSON_CHARS.sa_pay_grade%TYPE;
        v_osi_person_chars_sa_pay_band   T_OSI_PERSON_CHARS.sa_pay_band%TYPE;
        --T_OSI_PARTICIPANT_HUMAN Columns
        v_osi_partic_human_build         T_OSI_PARTICIPANT_HUMAN.BUILD%TYPE;
        v_osi_partic_human_posture       T_OSI_PARTICIPANT_HUMAN.posture%TYPE;
        v_osi_partic_human_writ_hand     T_OSI_PARTICIPANT_HUMAN.writing_hand%TYPE;
        v_osi_partic_human_rel_inv       T_OSI_PARTICIPANT_HUMAN.religion_involvement%TYPE;
        v_osi_partic_human_clearance     T_OSI_PARTICIPANT_HUMAN.clearance%TYPE;
        v_osi_partic_human_sa_service    T_OSI_PARTICIPANT_HUMAN.sa_service%TYPE;
        v_osi_partic_human_sa_affil      T_OSI_PARTICIPANT_HUMAN.sa_affiliation%TYPE;
        v_osi_partic_human_sa_comp       T_OSI_PARTICIPANT_HUMAN.sa_component%TYPE;
        v_osi_partic_human_sa_res        T_OSI_PARTICIPANT_HUMAN.sa_reservist%TYPE;
        v_osi_partic_human_sa_res_stat   T_OSI_PARTICIPANT_HUMAN.sa_reservist_status%TYPE;
        v_osi_partic_human_sa_res_type   T_OSI_PARTICIPANT_HUMAN.sa_reservist_type%TYPE;
        v_osi_partic_human_fsa_service   T_OSI_PARTICIPANT_HUMAN.fsa_service%TYPE;
        v_osi_partic_human_sus_io        T_OSI_PARTICIPANT_HUMAN.suspected_io%TYPE;
        v_osi_partic_human_known_io      T_OSI_PARTICIPANT_HUMAN.known_io%TYPE;
        v_osi_partic_human_bald          T_OSI_PARTICIPANT_HUMAN.is_bald%TYPE;
        v_osi_partic_human_hard_hear     T_OSI_PARTICIPANT_HUMAN.is_hard_of_hearing%TYPE;
        v_osi_partic_human_facial_hair   T_OSI_PARTICIPANT_HUMAN.has_facial_hair%TYPE;
        v_osi_partic_human_wear_glass    T_OSI_PARTICIPANT_HUMAN.wears_glasses%TYPE;
        v_osi_partic_human_has_teeth     T_OSI_PARTICIPANT_HUMAN.has_teeth%TYPE;
        --T_OSI_PARTIC_NAME Columns
        v_osi_partic_name_name_type      T_OSI_PARTIC_NAME.name_type%TYPE;
        --T_OSI_ADDRESS Columns
        v_osi_address_address_type       T_OSI_ADDRESS.address_type%TYPE;
        --T_OSI_PARTIC_NUMBER Columns
        v_osi_partic_number_num_type     T_OSI_PARTIC_NUMBER.num_type%TYPE;
        --T_OSI_PARTIC_CONTACT Columns
        v_osi_partic_contact_type        T_OSI_PARTIC_CONTACT.TYPE%TYPE;
        --T_OSI_PARTIC_VEHICLE Columns
        v_osi_partic_vehicle_body_type   T_OSI_PARTIC_VEHICLE.body_type%TYPE;
        v_osi_partic_vehicle_role        T_OSI_PARTIC_VEHICLE.ROLE%TYPE;
        --Other
        v_new_sid_version                VARCHAR2(20);
        v_migration_cnt_total            NUMBER                                              := 0;
        v_new_sid_temp                   VARCHAR2(20);
        v_temp                           VARCHAR2(4000);
        v_current_address                T_OSI_PARTICIPANT_VERSION.current_address%TYPE;
        v_current_name                   T_OSI_PARTICIPANT_VERSION.current_name%TYPE;
        v_person_sid                     VARCHAR2(40);
        v_obj_type                       T_CORE_OBJ_TYPE.SID%TYPE;

        FUNCTION handle_boolean(p_data IN NUMBER)
            RETURN VARCHAR2 IS
        BEGIN
            IF (p_data IS NOT NULL) THEN
                IF (p_data = -1) THEN
                    RETURN 'Y';
                ELSIF(p_data = 0) THEN
                    RETURN 'N';
                ELSE
                    --Probably do not need to account for this situation
                    RETURN 'U';
                END IF;
            ELSE
                RETURN 'U';
            END IF;

            --If all else fails
            RETURN 'U';
        END handle_boolean;

        PROCEDURE mark_as_mig(
            p_type      IN   VARCHAR2,
            p_old_sid   IN   VARCHAR2,
            p_new_sid   IN   VARCHAR2,
            p_parent    IN   VARCHAR2) IS
        BEGIN
            v_migration_cnt_total := v_migration_cnt_total + 1;

            INSERT INTO T_OSI_MIGRATION
                        (TYPE, old_sid, new_sid, date_time, num, PARENT)
                 VALUES (p_type, p_old_sid, p_new_sid, SYSDATE, v_migration_cnt_total, p_parent);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE;
        END mark_as_mig;
    BEGIN
        --Get object type SID
        v_obj_type := Core_Obj.lookup_objtype('PART.INDIV');

        --Get the T_PERSON SID
        SELECT person
          INTO v_person_sid
          FROM ref_v_person_version
         WHERE SID = p_legacy_person_version;

        --T_PERSON_VERSION
        FOR k IN (SELECT *
                    FROM ref_t_person_version
                   WHERE SID = p_legacy_person_version)
        LOOP
            --Participant Version Table - Insert
            INSERT INTO T_OSI_PARTICIPANT_VERSION
                        (participant, locked_on, locked_by)
                 VALUES (p_new_person, k.locked_on, k.locked_by)
              RETURNING SID
                   INTO v_new_sid_version;

            --Get PERSON_CHARS columns [BEGIN]
            v_osi_person_chars_sex := Dibrs_Reference.lookup_ref_sid('SEX', UPPER(k.sex));

            IF (k.eye_color IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_person_chars_eye_color
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'PERSON_EYE_COLOR' AND UPPER(description) = UPPER(k.eye_color);
            ELSE
                v_osi_person_chars_eye_color := NULL;
            END IF;

            IF (k.hair_color IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_person_chars_hair_color
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'PERSON_HAIR_COLOR' AND UPPER(description) = UPPER(k.hair_color);
            ELSE
                v_osi_person_chars_hair_color := NULL;
            END IF;

            v_osi_person_chars_blood_type :=
                                     Osi_Reference.lookup_ref_sid('PERSON_BLOOD_TYPE', k.blood_type);
            v_osi_person_chars_race := Dibrs_Reference.get_race_sid(k.race);
            v_osi_person_chars_sa_pay_plan :=
                                           Dibrs_Reference.lookup_ref_sid('PAY_PLAN', k.sa_pay_plan);
            v_osi_person_chars_sa_pay_grad := Dibrs_Reference.get_pay_grade_sid(k.sa_pay_grade);
            v_osi_person_chars_sa_pay_band := Dibrs_Reference.get_pay_band_sid(k.sa_pay_band);

            --Get PERSON_CHARS columns [END]

            --Person Chars Table - Insert
            INSERT INTO T_OSI_PERSON_CHARS
                        (SID,
                         sex,
                         eye_color,
                         hair_color,
                         blood_type,
                         race,
                         sa_pay_plan,
                         sa_pay_grade,
                         sa_pay_band,
                         height,
                         weight,
                         education_level)
                 VALUES (v_new_sid_version,
                         v_osi_person_chars_sex,
                         v_osi_person_chars_eye_color,
                         v_osi_person_chars_hair_color,
                         v_osi_person_chars_blood_type,
                         v_osi_person_chars_race,
                         v_osi_person_chars_sa_pay_plan,
                         v_osi_person_chars_sa_pay_grad,
                         v_osi_person_chars_sa_pay_band,
                         k.height,
                         k.weight,
                         k.education_level);

            --Get PARTICIPANT_HUMAN columns [BEGIN]
            IF (k.BUILD IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_build
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_BUILD' AND UPPER(description) = UPPER(k.BUILD);
            ELSE
                v_osi_partic_human_build := NULL;
            END IF;

            IF (k.posture IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_posture
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_POSTURE' AND UPPER(description) = UPPER(k.posture);
            ELSE
                v_osi_partic_human_posture := NULL;
            END IF;

            IF (k.writing_hand IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_writ_hand
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_HAND' AND UPPER(description) = UPPER(k.writing_hand);
            ELSE
                v_osi_partic_human_writ_hand := NULL;
            END IF;

            IF (k.religious_involvement IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_human_rel_inv
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'INDIV_RELIGION_INVOLVEMENT'
                   AND UPPER(description) = UPPER(k.religious_involvement);
            ELSE
                v_osi_partic_human_rel_inv := NULL;
            END IF;

            IF (k.clearance IS NOT NULL) THEN
                IF (k.clearance = 'CON') THEN
                    v_osi_partic_human_clearance :=
                                               Osi_Reference.lookup_ref_sid('INDIV_CLEARANCE', 'C');
                ELSIF(k.clearance = 'SEC') THEN
                    v_osi_partic_human_clearance :=
                                               Osi_Reference.lookup_ref_sid('INDIV_CLEARANCE', 'S');
                ELSE
                    v_osi_partic_human_clearance :=
                                       Osi_Reference.lookup_ref_sid('INDIV_CLEARANCE', k.clearance);
                END IF;
            ELSE
                v_osi_partic_human_clearance := NULL;
            END IF;

            v_osi_partic_human_sa_service :=
                                          Osi_Reference.lookup_ref_sid('SERVICE_TYPE', k.sa_service);
            v_osi_partic_human_sa_affil :=
                                 Osi_Reference.lookup_ref_sid('INDIV_AFFILIATION', k.sa_affiliation);
            v_osi_partic_human_sa_comp :=
                                   Osi_Reference.lookup_ref_sid('SERVICE_COMPONENT', k.sa_component);
            v_osi_partic_human_sa_res := handle_boolean(k.sa_reservist);
            v_osi_partic_human_sa_res_stat :=
                         Osi_Reference.lookup_ref_sid('INDIV_RESERVE_STATUS', k.sa_reservist_status);
            v_osi_partic_human_sa_res_type :=
                             Osi_Reference.lookup_ref_sid('INDIV_RESERVE_TYPE', k.sa_reservist_type);
            v_osi_partic_human_fsa_service :=
                                       Dibrs_Reference.lookup_ref_sid('SERVICE_TYPE', k.fsa_service);
            v_osi_partic_human_sus_io := handle_boolean(k.suspected_io);
            v_osi_partic_human_known_io := handle_boolean(k.known_io);
            v_osi_partic_human_bald := handle_boolean(k.is_bald);
            v_osi_partic_human_hard_hear := handle_boolean(k.is_hard_of_hearing);
            v_osi_partic_human_facial_hair := handle_boolean(k.has_facial_hair);
            v_osi_partic_human_wear_glass := handle_boolean(k.wears_glasses);
            v_osi_partic_human_has_teeth := handle_boolean(k.has_teeth);

            --Get PARTICIPANT_HUMAN columns [END]
            INSERT INTO T_OSI_PARTICIPANT_HUMAN
                        (SID,
                         age_low,
                         age_high,
                         BUILD,
                         posture,
                         writing_hand,
                         religion,
                         religion_involvement,
                         clearance,
                         sa_service,
                         sa_affiliation,
                         sa_component,
                         sa_rank,
                         sa_rank_date,
                         sa_specialty_code,
                         sa_reservist,
                         sa_reservist_status,
                         sa_reservist_type,
                         fsa_service,
                         fsa_rank,
                         fsa_equiv_rank,
                         fsa_rank_date,
                         suspected_io,
                         known_io,
                         is_bald,
                         bald_comment,
                         is_hard_of_hearing,
                         hearing_comment,
                         has_facial_hair,
                         facial_hair_comment,
                         wears_glasses,
                         glasses_comment,
                         has_teeth,
                         teeth_comment,
                         deers_date)
                 VALUES (v_new_sid_version,
                         k.age_low,
                         k.age_high,
                         v_osi_partic_human_build,
                         v_osi_partic_human_posture,
                         v_osi_partic_human_writ_hand,
                         k.religious_affiliation,
                         v_osi_partic_human_rel_inv,
                         v_osi_partic_human_clearance,
                         v_osi_partic_human_sa_service,
                         v_osi_partic_human_sa_affil,
                         v_osi_partic_human_sa_comp,
                         k.sa_rank,
                         k.sa_rank_date,
                         k.sa_specialty_code,
                         v_osi_partic_human_sa_res,
                         v_osi_partic_human_sa_res_stat,
                         v_osi_partic_human_sa_res_type,
                         v_osi_partic_human_fsa_service,
                         k.fsa_rank,
                         k.fsa_equiv_rank,
                         k.fsa_rank_date,
                         v_osi_partic_human_sus_io,
                         v_osi_partic_human_known_io,
                         v_osi_partic_human_bald,
                         k.bald_comment,
                         v_osi_partic_human_hard_hear,
                         k.hard_of_hearing_comment,
                         v_osi_partic_human_facial_hair,
                         k.facial_hair_comment,
                         v_osi_partic_human_wear_glass,
                         k.glasses_comment,
                         v_osi_partic_human_has_teeth,
                         k.teeth_comment,
                         k.deers_date);
        END LOOP;

        mark_as_mig('PARTICIPANT_VERSION', p_legacy_person_version, v_new_sid_version, p_new_person);

        --T_PERSON_CITIZENSHIP Table
        FOR k IN (SELECT *
                    FROM ref_t_person_citizenship
                   WHERE person_version = p_legacy_person_version)
        LOOP
            INSERT INTO T_OSI_PARTIC_CITIZENSHIP
                        (participant_version, country, effective_date)
                 VALUES (v_new_sid_version,
                         Dibrs_Reference.get_country_sid(k.country),
                         k.effective_date)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_CITIZENSHIP', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_MARK
        FOR k IN (SELECT *
                    FROM ref_t_person_mark
                   WHERE person_version = p_legacy_person_version)
        LOOP
            INSERT INTO T_OSI_PARTIC_MARK
                        (participant_version, mark_type, mark_location, description)
                 VALUES (v_new_sid_version,
                         Dibrs_Reference.get_mark_type_sid(k.type_code),
                         Dibrs_Reference.get_mark_location_type_sid(k.loc_code),
                         k.description)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_MARK', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_NAME
        FOR k IN (SELECT *
                    FROM ref_t_person_name
                   WHERE person_version = p_legacy_person_version)
        LOOP
            --Get Columns
            IF (k.name_type IS NOT NULL) THEN
                v_temp := k.name_type;

                IF (k.name_type = 'A') THEN
                    --Special case for AKA (When dealing with individual participants)
                    v_temp := 'AKA';
                ELSE
                    v_temp := k.name_type;
                END IF;

                --Shouldn't need this try/catch, but have it in place for non-indiv folks
                BEGIN
                    SELECT SID
                      INTO v_osi_partic_name_name_type
                      FROM T_OSI_PARTIC_NAME_TYPE
                     WHERE code = v_temp;
                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('Bad Type : [' || k.name_type || ']');
                END;
            ELSE
                v_osi_partic_name_name_type := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_NAME
                        (participant_version,
                         name_type,
                         title,
                         last_name,
                         first_name,
                         middle_name,
                         cadency)
                 VALUES (v_new_sid_version,
                         v_osi_partic_name_name_type,
                         k.title,
                         k.last_name,
                         k.first_name,
                         k.middle_name,
                         k.cadency)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_NAME', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_ADDRESS_V2
        --Clear Current Address
        v_current_address := NULL;

        FOR k IN (SELECT *
                    FROM ref_t_address_v2
                   WHERE PARENT = p_legacy_person_version
                      OR PARENT = v_person_sid)
        LOOP
            CASE upper(k.addr_type)
                WHEN 'PERMANENT' THEN
                    v_osi_address_address_type :=
                                         Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'PERM');
                WHEN 'EDUCATION' THEN
                    v_osi_address_address_type :=
                                           Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'ED');
                WHEN 'EMPLOYMENT' THEN
                    v_osi_address_address_type :=
                                          Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'EMP');
                WHEN 'MAIL' THEN
                    v_osi_address_address_type :=
                                         Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'MAIL');
                WHEN 'OTHER' THEN
                    v_osi_address_address_type :=
                                          Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'OTH');
                WHEN 'RESIDENCE' THEN
                    v_osi_address_address_type :=
                                          Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'RES');
                WHEN 'TEMPORARY' THEN
                    v_osi_address_address_type :=
                                         Osi_Address.get_addr_type(v_obj_type, 'ADDR_LIST', 'TEMP');
                WHEN 'BIRTH' THEN
                    v_osi_address_address_type :=
                                            Osi_Address.get_addr_type(v_obj_type, 'BIRTH', 'BIRTH');
            END CASE;

            --Create Address Record, Tied to PERSON
            INSERT INTO T_OSI_ADDRESS
                        (obj,
                         address_type,
                         address_1,
                         address_2,
                         city,
                         province,
                         state,
                         postal_code,
                         country,
                         geo_coords,
                         start_date,
                         end_date,
                         known_date,
                         comments)
                 VALUES (p_new_person,
                         v_osi_address_address_type,
                         k.addr_1,
                         k.addr_2,
                         k.addr_city,
                         k.addr_province,
                         Dibrs_Reference.get_state_sid(k.addr_state),
                         k.addr_zip,
                         Dibrs_Reference.get_country_sid(k.addr_country),
                         k.geo_coords,
                         k.start_date,
                         k.end_date,
                         k.known_date,
                         k.comments)
              RETURNING SID
                   INTO v_new_sid_temp;

            --Create Participant Address Record, Tied to PERSON_VERSION
            IF (k.PARENT <> v_person_sid) THEN
                --Only need to tie the PERSON_VERSION (non birth) to the version
                INSERT INTO T_OSI_PARTIC_ADDRESS
                            (participant_version, address)
                     VALUES (v_new_sid_version, v_new_sid_temp)
                  RETURNING SID
                       INTO v_new_sid_temp;
            END IF;

            mark_as_mig('PARTICIPANT_ADDRESS',
                        k.SID,
                        v_new_sid_temp,
                        '~' || p_new_person || '~' || v_new_sid_version || '~');

            --Check for Current Address
            IF (k.selected = -1 AND k.PARENT = p_legacy_person_version) THEN
                v_current_address := v_new_sid_temp;
            END IF;
        END LOOP;

        --Numbers
        FOR k IN (SELECT *
                    FROM ref_t_person_number
                   WHERE person_version = p_legacy_person_version)
        LOOP
            v_temp := NULL;

            IF (k.num_type = 'OTHER') THEN
                v_temp := 'OID';
            ELSE
                v_temp := k.num_type;
            END IF;

            SELECT SID
              INTO v_osi_partic_number_num_type
              FROM T_OSI_PARTIC_NUMBER_TYPE
             WHERE code = v_temp;

            INSERT INTO T_OSI_PARTIC_NUMBER
                        (participant_version,
                         num_type,
                         num_value,
                         issue_date,
                         issue_country,
                         issue_state,
                         issue_province,
                         expire_date,
                         note)
                 VALUES (v_new_sid_version,
                         v_osi_partic_number_num_type,
                         k.num_value,
                         k.issue_date,
                         Dibrs_Reference.get_country_sid(k.issue_country),
                         Dibrs_Reference.get_state_sid(k.issue_state),
                         k.issue_province,
                         k.expire_date,
                         k.note)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_NUMBER', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --Contact Info
        FOR k IN (SELECT *
                    FROM ref_t_phone_email
                   WHERE PARENT = p_legacy_person_version)
        LOOP
            IF (k.pe_category IS NOT NULL) THEN
                SELECT SID
                  INTO v_osi_partic_contact_type
                  FROM T_OSI_REFERENCE
                 WHERE USAGE = 'CONTACT_TYPE' AND UPPER(description) = UPPER(k.pe_category);
            --Need to UPPER() above because Legacy Val is DSN-Fax and Web Val is DSN-FAX
            ELSE
                v_osi_partic_contact_type := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_CONTACT
                        (participant_version, TYPE, VALUE)
                 VALUES (v_new_sid_version, v_osi_partic_contact_type, k.pe_value)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_CONTACT', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_ORG_ATTR
        FOR k IN (SELECT *
                    FROM ref_t_person_org_attr
                   WHERE person_version = p_legacy_person_version)
        LOOP
            IF (k.ATTRIBUTE IS NOT NULL) THEN
                SELECT SID
                  INTO v_temp
                  FROM T_OSI_PARTIC_ORG_ATTR_TYPE
                 WHERE code = k.ATTRIBUTE;
            ELSE
                v_temp := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_ORG_ATTR
                        (participant_version, ATTRIBUTE, comments)
                 VALUES (v_new_sid_version, v_temp, k.comments);

            mark_as_mig('PARTICIPANT_ORG_ATTR', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_PERSON_VEHICLE
        FOR k IN (SELECT *
                    FROM ref_t_person_vehicle
                   WHERE person_version = p_legacy_person_version)
        LOOP
            --Get Body Type (From Description)
            IF (k.body_type IS NOT NULL) THEN
                SELECT description
                  INTO v_temp
                  FROM wcc_ref_t_person_vehicle_bt
                 WHERE SID = k.body_type;

                BEGIN
                    SELECT SID
                      INTO v_osi_partic_vehicle_body_type
                      FROM T_OSI_REFERENCE
                     WHERE USAGE = 'VEHICLE_BODY' AND description = v_temp;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_osi_partic_vehicle_body_type := NULL;
                END;
            ELSE
                v_osi_partic_vehicle_body_type := NULL;
            END IF;

            --Get Role (From Description)
            IF (k.ROLE IS NOT NULL) THEN
                SELECT description
                  INTO v_temp
                  FROM wcc_ref_t_person_vehicle_roles
                 WHERE SID = k.ROLE;

                BEGIN
                    SELECT SID
                      INTO v_osi_partic_vehicle_role
                      FROM T_OSI_REFERENCE
                     WHERE USAGE = 'VEHICLE_ROLE' AND description = v_temp;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_osi_partic_vehicle_role := NULL;
                END;
            ELSE
                v_osi_partic_vehicle_role := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_VEHICLE
                        (participant_version,
                         plate_num,
                         reg_exp_date,
                         reg_country,
                         reg_state,
                         reg_province,
                         title_owner,
                         vin,
                         make,
                         MODEL,
                         YEAR,
                         color,
                         body_type,
                         gross_weight,
                         num_axles,
                         ROLE,
                         comments)
                 VALUES (v_new_sid_version,
                         k.plate_num,
                         k.reg_exp_date,
                         Dibrs_Reference.get_country_sid(k.reg_country),
                         Dibrs_Reference.get_state_sid(k.reg_state),
                         k.reg_province,
                         k.title_num,
                         k.vin,
                         k.vehicle_make,
                         k.vehicle_model,
                         k.vehicle_year,
                         k.vehicle_color,
                         v_osi_partic_vehicle_body_type,
                         k.gross_weight,
                         k.num_axles,
                         v_osi_partic_vehicle_role,
                         k.comments)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_VEHICLE', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --T_DATE
        FOR k IN (SELECT *
                    FROM wcc_ref_t_date
                   WHERE PARENT = p_legacy_person_version)
        LOOP
            --Get Date Type (From Description)
            IF (k.date_type IS NOT NULL) THEN
                BEGIN
                    SELECT SID
                      INTO v_temp
                      FROM T_OSI_REFERENCE
                     WHERE USAGE = 'INDIV_DATE' AND description = k.date_type;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_temp := NULL;
                END;
            ELSE
                v_temp := NULL;
            END IF;

            INSERT INTO T_OSI_PARTIC_DATE
                        (participant_version, TYPE, VALUE, comments)
                 VALUES (v_new_sid_version, v_temp, k.date_value, k.comments)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_DATE', k.SID, v_new_sid_temp, v_new_sid_version);
        END LOOP;

        --FINALIZATION STUFF

        --TODO, probably should a p_current to the function and only update when set to Y

        --Update Current Name and Current Address[BEGIN]
        --v_current_name
        v_current_name := NULL;

        FOR k IN (SELECT ind_curr_name
                    FROM ref_t_person_version
                   WHERE SID = p_legacy_person_version)
        LOOP
            v_current_name := k.ind_curr_name;
        END LOOP;

        FOR k IN (SELECT new_sid
                    FROM T_OSI_MIGRATION
                   WHERE old_sid = v_current_name AND PARENT = v_new_sid_version)
        LOOP
            v_current_name := k.new_sid;
        END LOOP;

        UPDATE T_OSI_PARTICIPANT_VERSION
           SET current_name = v_current_name,
               current_address = v_current_address
         WHERE SID = v_new_sid_version;
    --Update Current Name and Current Address[END]
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_participant.import_legacy_part_version: ' || SQLERRM);
            RAISE;
    END import_legacy_part_version;

    FUNCTION import_legacy_participant(p_person_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_temp                          VARCHAR2(4000);
        v_temp2                         VARCHAR2(4000);
        v_temp_clob                     CLOB;
        v_person_sid                    VARCHAR2(40);
        v_obj_type                      T_CORE_OBJ_TYPE.SID%TYPE;
        v_new_sid                       T_CORE_OBJ.SID%TYPE;
        v_new_sid_version               T_OSI_PARTICIPANT_VERSION.SID%TYPE;
        v_new_sid_temp                  VARCHAR2(20);
        v_migration_cnt_total           NUMBER                               := 0;
        v_current_version_sid           VARCHAR2(20);
        --T_OSI_PARTICIPANT Columns
        v_osi_participant_ethnicity     T_OSI_PARTICIPANT.ethnicity%TYPE;
        --T_OSI_NOTE Columns
        v_osi_note_note_type            T_OSI_NOTE.note_type%TYPE;
        v_osi_note_creating_personnel   T_OSI_NOTE.creating_personnel%TYPE;
        v_create_by                     varchar2(100);

        PROCEDURE mark_as_mig(
            p_type      IN   VARCHAR2,
            p_old_sid   IN   VARCHAR2,
            p_new_sid   IN   VARCHAR2,
            p_parent    IN   VARCHAR2) IS
        BEGIN
            v_migration_cnt_total := v_migration_cnt_total + 1;

            INSERT INTO T_OSI_MIGRATION
                        (TYPE, old_sid, new_sid, date_time, num, PARENT)
                 VALUES (p_type, p_old_sid, p_new_sid, SYSDATE, v_migration_cnt_total, p_parent);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE;
        END mark_as_mig;

        FUNCTION get_part_rel_info(p_person IN VARCHAR2)
            RETURN CLOB IS
            v_file_begin   VARCHAR2(2000)
                := '{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}} {\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20';
            v_file_end     VARCHAR2(2000)  := '\par }';
            v_return       CLOB;
            v_temp1        VARCHAR2(20000);
            v_cnt          NUMBER;
        BEGIN
            --Start File
            v_return := v_file_begin;
            --*****Header
            v_temp1 :=
                'Relational data for: ' || ref_person.current_name(p_person) || ' \par  As of: '
                || SYSDATE || ' \par\par ';
            v_return := v_return || v_temp1;
            v_temp1 := '';
            --*****Associated Activities
            v_temp1 := NULL;
            v_cnt := 0;
            v_temp1 := '\b ASSOCIATED ACTIVITIES \b0 \par \par ';

            FOR k IN (SELECT DISTINCT ID, title, subtype_desc, involvement_role, SID
                                 FROM ref_v_person_act_inv
                                WHERE person = p_person)
            LOOP
                --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
                IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                    AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                    v_cnt := v_cnt + 1;
                    v_temp1 :=
                            v_temp1 || '\b ' || v_cnt || '.> \b0 Activity ID: ' || k.ID || ' \par ';
                    v_temp1 := v_temp1 || 'Activity Title: ' || k.title || ' \par ';
                    v_temp1 := v_temp1 || 'Activity Type: ' || k.subtype_desc || ' \par ';
                    v_temp1 :=
                         v_temp1 || 'Activity Involvement Role: ' || k.involvement_role || ' \par ';
                    v_temp1 := v_temp1 || ' \par ';
                END IF;
            END LOOP;

            IF v_cnt = 0 THEN
                v_temp1 := v_temp1 || 'No Data Found \par ';
            END IF;

            --Concatonate the activities
            v_return := v_return || v_temp1 || ' \par ';
            --Clear buffer(s)
            v_temp1 := NULL;
            v_cnt := 0;
            v_temp1 := '\b ASSOCIATED FILES \b0 \par \par ';

            --*****Associated Files
            FOR k IN (SELECT DISTINCT ID, title, type_desc, subtype_desc, involvement_role, SID
                                 FROM ref_v_person_file_inv
                                WHERE person = p_person)
            LOOP
                --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
                IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                    AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                    v_cnt := v_cnt + 1;
                    v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 File ID: ' || k.ID || ' \par ';
                    v_temp1 := v_temp1 || 'File Title: ' || k.title || ' \par ';
                    v_temp1 := v_temp1 || 'File Type: ' || k.type_desc || ' \par ';
                    v_temp1 := v_temp1 || 'File Sub Type: ' || k.subtype_desc || ' \par ';
                    v_temp1 :=
                             v_temp1 || 'File Involvement Role: ' || k.involvement_role || ' \par ';
                    v_temp1 := v_temp1 || ' \par ';
                END IF;
            END LOOP;

            IF v_cnt = 0 THEN
                v_temp1 := v_temp1 || 'No Data Found \par ';
            END IF;

            --Concatonate the files
            v_return := v_return || v_temp1 || ' \par ';
            --Clear buffer(s)
            v_temp1 := NULL;
            v_cnt := 0;
            v_temp1 := '\b RELATIONSHIPS \b0 \par \par ';

            --*****Relationships
            FOR k IN (SELECT *
                        FROM ref_v_person_relation
                       WHERE this_person = p_person)
            LOOP
                IF (    (NVL(k.mod2_value, 'xxx') NOT LIKE 'ORCON%')
                    AND (NVL(k.mod2_value, 'xxx') NOT LIKE 'LIMDIS%')) THEN
                    IF (k.rel_desc IS NOT NULL) THEN
                        v_cnt := v_cnt + 1;
                        v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 ' || k.rel_desc || ' \par ';
                        v_temp1 := v_temp1 || 'Participant: ' || k.that_name || ' \par ';

                        -- add specifics if any
                        IF (k.rel_specifics IS NOT NULL) THEN
                            v_temp1 := v_temp1 || 'Specifics: ' || k.rel_specifics || ' \par ';
                        END IF;

                        -- add comments if any
                        IF (k.comments IS NOT NULL) THEN
                            v_temp1 := v_temp1 || 'Comments: ' || k.comments || ' \par ';
                        END IF;

                        v_temp1 := v_temp1 || ' \par ';
                    END IF;
                END IF;
            END LOOP;

            IF v_cnt = 0 THEN
                v_temp1 := v_temp1 || 'No Data Found \par ';
            END IF;

            --Concatonate the files
            v_return := v_return || v_temp1 || ' \par ';
            --Finish off file
            v_return := v_return || v_file_end;
            --Send home
            RETURN v_return;
        END get_part_rel_info;
    BEGIN
        --Get object type SID
        v_obj_type := Core_Obj.lookup_objtype('PART.INDIV');

        --Get the T_PERSON SID
        SELECT person
          INTO v_person_sid
          FROM ref_v_person_version
         WHERE SID = p_person_version;

        --CORE_OBJ Record - Insert
        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (v_obj_type)
          RETURNING SID
               INTO v_new_sid;

        --Main Participant Record
        FOR k IN (SELECT *
                    FROM ref_t_person
                   WHERE SID = v_person_sid)
        LOOP
            --Get Ethnicity
            v_osi_participant_ethnicity := Dibrs_Reference.lookup_ref_sid('ETHNICITY', k.ethnicity);

            --Main Part Record - Insert
            INSERT INTO T_OSI_PARTICIPANT
                        (SID,
                         unknown_flag,
                         confirm_on,
                         confirm_by,
                         dod_edi_pn_id,
                         dob,
                         dod,
                         ethnicity,
                         nationality,
                         details_lock)
                 VALUES (v_new_sid,
                         'N',
                         k.confirm_on,
                         k.confirm_by,
                         k.dod_edi_pn_id,
                         k.birth_date,
                         k.decease_date,
                         v_osi_participant_ethnicity,
                         k.nationality,
                         k.lock_details)
              RETURNING SID
                   INTO v_new_sid_temp;

            --Save off the Confirmed By field for use below
            v_temp := k.confirm_by;
            mark_as_mig('PARTICIPANT', k.SID, v_new_sid_temp, '');
        END LOOP;

        --Give the participant a starting status
        Osi_Status.change_status_brute
                             (v_new_sid,
                              Osi_Status.get_starting_status(Core_Obj.lookup_objtype('PART.INDIV')),
                              'Created');

        --If person is confirmed, need to change their status to show it
        IF (v_temp IS NOT NULL) THEN
            --Get status change
            SELECT SID
              INTO v_temp
              FROM T_OSI_STATUS_CHANGE
             WHERE obj_type = Core_Obj.lookup_objtype('PART.INDIV')
               AND from_status =
                               Osi_Status.get_starting_status(Core_Obj.lookup_objtype('PART.INDIV'))
               AND UPPER(transition) = 'CONFIRM';

            Osi_Status.change_status(v_new_sid, v_temp);
        END IF;

        --Notes
        --Transfer the notes to the temp table
        DELETE FROM T_OSI_MIGRATION_NOTES;

        INSERT INTO T_OSI_MIGRATION_NOTES
            SELECT *
              FROM ref_t_note_v2
             WHERE PARENT = v_person_sid;

        FOR k IN (SELECT *
                    FROM T_OSI_MIGRATION_NOTES
                   WHERE PARENT = v_person_sid)
        LOOP
            --Get Category
            IF (k.CATEGORY IS NOT NULL) THEN
                BEGIN
                    SELECT SID
                      INTO v_osi_note_note_type
                      FROM T_OSI_NOTE_TYPE
                     WHERE obj_type = Core_Obj.lookup_objtype('PART.INDIV')
                       AND USAGE = 'NOTELIST'
                       AND UPPER(description) = UPPER(k.CATEGORY);
                EXCEPTION
                    WHEN OTHERS THEN
                        --If not type is not found, then use the 'Additional Info' note.
                        v_osi_note_note_type :=
                            Osi_Note.get_note_type(Core_Obj.lookup_objtype('PART.INDIV'),
                                                   'ADD_INFO');
                END;
            ELSE
                --Category should never be null, but if it is, just use "Additional Info" note.
                v_osi_note_note_type :=
                          Osi_Note.get_note_type(Core_Obj.lookup_objtype('PART.INDIV'), 'ADD_INFO');
            END IF;

            --Get Creating Personnel
            IF (k.personnel IS NOT NULL) THEN
                BEGIN
                    SELECT new_sid
                      INTO v_osi_note_creating_personnel
                      FROM T_OSI_MIGRATION
                     WHERE TYPE = 'PERSONNEL' AND old_sid = k.personnel;
                EXCEPTION
                    WHEN OTHERS THEN
                        --If personnel is not found, then use the current personnel
                        v_osi_note_creating_personnel := Core_Context.personnel_sid;
                END;
            ELSE
                --Personnel should never be null, but if it is, use the current User.
                v_osi_note_creating_personnel := Core_Context.personnel_sid;
            END IF;

            INSERT INTO T_OSI_NOTE
                        (obj, note_type, note_text, creating_personnel, lock_mode)
                 VALUES (v_new_sid,
                         v_osi_note_note_type,
                         k.note,
                         v_osi_note_creating_personnel,
                         k.lock_mode)
              RETURNING SID
                   INTO v_new_sid_temp;

            mark_as_mig('PARTICIPANT_NOTE', k.SID, v_new_sid_temp, v_new_sid);
        END LOOP;

        --Attachments / Images (Mugshots)
        --Transfer the Attachments to the temp table
        DELETE FROM T_OSI_MIGRATION_ATCH;

        INSERT INTO T_OSI_MIGRATION_ATCH
            SELECT *
              FROM ref_t_attachment_v3
             WHERE PARENT = v_person_sid;

        FOR k IN (SELECT *
                    FROM T_OSI_MIGRATION_ATCH
                   WHERE PARENT = v_person_sid)
        LOOP
            --Get Creating Personnel
            IF (k.attach_by IS NOT NULL) THEN
                BEGIN
                    SELECT new_sid
                      INTO v_temp
                      FROM T_OSI_MIGRATION
                     WHERE TYPE = 'PERSONNEL' AND old_sid = k.attach_by;
                EXCEPTION
                    WHEN OTHERS THEN
                        --If personnel is not found, then use the current personnel
                        v_temp := Core_Context.personnel_sid;
                END;
            ELSE
                --Personnel should never be null, but if it is, use the current User.
                v_temp := Core_Context.personnel_sid;
            END IF;

            --Get Type
            IF (k.USAGE = 'MUGSHOT') THEN
                v_temp2 :=
                    Osi_Attachment.get_attachment_type_sid(Core_Obj.lookup_objtype('PART.INDIV'),
                                                           'MUG',
                                                           'MUGSHOT');
            ELSE
                v_temp2 := NULL;
            END IF;

            --Transfer the Attachment to the temp table
            DELETE FROM T_OSI_MIGRATION_ATCH;

            INSERT INTO T_OSI_MIGRATION_ATCH
                SELECT *
                  FROM ref_t_attachment_v3
                 WHERE SID = k.SID;

            FOR j IN (SELECT *
                        FROM T_OSI_MIGRATION_ATCH
                       WHERE SID = k.SID)
            LOOP
                --Note: Do not need Attachment Type
                INSERT INTO T_OSI_ATTACHMENT
                            (obj,
                             TYPE,
                             content,
                             storage_loc_type,
                             description,
                             SOURCE,
                             mime_type,
                             creating_personnel,
                             lock_mode,
                             date_modified)
                     VALUES (v_new_sid,
                             v_temp2,
                             j.blob_content,
                             j.attach_location,
                             j.description,
                             j.source_location,
                             NULL,
                             v_temp,
                             j.LOCKED,
                             j.content_date)
                  RETURNING SID
                       INTO v_new_sid_temp;
                  
                  begin
                       select osi_personnel.get_name(v_temp) into v_create_by from dual;

                  exception when others then
                       
                           v_create_by := core_context.personnel_name;
                       
                  end;             
                  --- To keep the Original Create On/By from Legacy, mainly for DEERS ---     
                  update t_osi_attachment set create_by=v_create_by, create_on=j.attach_date where sid=v_new_sid_temp;
                  
            END LOOP;

            mark_as_mig('PARTICIPANT_ATCH', k.SID, v_new_sid_temp, v_new_sid);
        END LOOP;

        --Person Detail Report
        --ref_obj_doc_web.make_doc_per(v_person_sid, v_temp_clob, null);
        v_temp_clob := get_part_rel_info(v_person_sid);

        INSERT INTO T_OSI_ATTACHMENT
                    (obj,
                     content,
                     storage_loc_type,
                     description,
                     SOURCE,
                     mime_type,
                     creating_personnel)
             VALUES (v_new_sid,
                     Hex_Funcs.clob_to_blob(v_temp_clob),
                     'DB',
                     'Participant Detail Report - Imported Participant',
                     'DetailReport.rtf',
                     'application/msword',
                     Core_Context.personnel_sid)
          RETURNING SID
               INTO v_new_sid_temp;

        mark_as_mig('PARTICIPANT_DOC_DETAIL', p_person_version, v_new_sid_temp, v_new_sid);

        --Import Versions
        FOR k IN (SELECT   SID
                      FROM ref_t_person_version
                     WHERE person = v_person_sid
                  ORDER BY SID)
        LOOP
            import_legacy_part_version(k.SID, v_new_sid);
        END LOOP;

        --Get the current version
        FOR k IN (SELECT SID
                    FROM ref_t_person_version
                   WHERE person = v_person_sid AND current_flag = 1)
        LOOP
            SELECT new_sid
              INTO v_current_version_sid
              FROM T_OSI_MIGRATION
             WHERE old_sid = k.SID AND TYPE = 'PARTICIPANT_VERSION';
        END LOOP;

        --Update the Current Version
        UPDATE T_OSI_PARTICIPANT
           SET current_version = v_current_version_sid
         WHERE SID = v_new_sid;

        --Legacy:
        --T_PERSON [Complete]
        --T_PERSON_VERSION [Completish - See Notes]
        --T_PERSON_CITIZENSHIP [Complete]
        --T_PERSON_INVOLVEMENT_V2 (Not needed, will be generating the Part Detail Rpt.)
        --T_PERSON_MARK [Complete]
        --T_PERSON_NAME [Complete]
        --T_PERSON_NUMBER [Complete]
        --T_PERSON_ORG_ATTR [Complete]
        --T_PERSON_RELATION (Not needed, will be generating the Part Detail Rpt.)
        --T_PERSON_VEHICLE [Complete]
        --T_ADDRESS_V2 [Complete]
        --T_PHONE_EMAIL [Complete]
        --T_DATE [Complete]
        --Attach: Person Detail Report
        --Images [Complete]
        --Notes [Complete]
        --Attachments [Complete]
        --No associations [Complete]
        --No relationships [Complete]

        --Web:
        --T_CORE_OBJ [Complete]
        --T_OSI_PARTICIPANT [Complete]
        --T_OSI_PARTICIPANT_VERSION (Need CURRENT_ADDRESS, CURRENT_NAME)
        --T_OSI_PARTICIPANT_HUMAN [Complete]
        --T_OSI_PERSON_CHARS [Complete]
        --T_OSI_PARTIC_ADDRESS [Complete]
        --T_OSI_PARTIC_CITIZENSHIP [Complete]
        --T_OSI_PARTIC_CONTACT [Complete]
        --T_OSI_PARTIC_DATE [Complete]
        --T_OSI_PARTIC_NAME [Complete]
        --T_OSI_PARTIC_NUMBER [Complete]
        --T_OSI_PARTIC_ORG_ATTR [Complete]
        --T_OSI_PARTIC_VEHICLE [Complete]
        RETURN v_new_sid;
    END import_legacy_participant;

    FUNCTION get_legacy_part_names(p_person_version IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_legal_names    VARCHAR2(4000) := NULL;
        v_alias_names    VARCHAR2(4000) := NULL;
        v_maiden_names   VARCHAR2(4000) := NULL;
        v_temp           VARCHAR2(4000);
    BEGIN
        FOR k IN (SELECT name_type, last_name, first_name, middle_name
                    FROM ref_t_person_name
                   WHERE person_version = p_person_version AND name_type IN('L', 'A', 'M'))
        LOOP
            v_temp := '';

            IF (k.last_name IS NOT NULL) THEN
                v_temp := v_temp || k.last_name || ', ';
            END IF;

            IF (k.first_name IS NOT NULL) THEN
                v_temp := v_temp || k.first_name || ', ';
            END IF;

            IF (k.middle_name IS NOT NULL) THEN
                v_temp := v_temp || k.middle_name || ', ';
            END IF;

            v_temp := RTRIM(v_temp, ', ');

            CASE UPPER(k.name_type)
                WHEN 'L' THEN
                    v_legal_names := v_temp || ' (Legal) ';
                WHEN 'M' THEN
                    v_maiden_names := v_temp || ' (Maiden) ';
                WHEN 'A' THEN
                    v_alias_names := v_temp || ' (AKA) ';
            END CASE;
        END LOOP;

        RETURN v_legal_names || v_maiden_names || v_alias_names;
    END get_legacy_part_names;

    FUNCTION get_legacy_part_details(
        p_person_version   IN   VARCHAR2,
        p_omit_sa          IN   VARCHAR2 := NULL,
        p_for_confirm      IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn       VARCHAR2(4000);
        v_objtype   VARCHAR2(40);                                       --t_core_obj_type.sid%type;

        FUNCTION row_start
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<TR>';
        END row_start;

        FUNCTION row_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TR>';
        END row_end;

        FUNCTION new_row(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN row_start || p_text || row_end;
        END new_row;

        FUNCTION cell_start(p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
            v_rtn   VARCHAR2(500) := '<TD vAlign="top" ';
        BEGIN
            IF (p_col_span > 0) THEN
                v_rtn := v_rtn || 'colSpan="' || p_col_span || '" ';
            END IF;

            IF (p_row_span > 0) THEN
                v_rtn := v_rtn || 'rowSpan="' || p_row_span || '" ';
            END IF;

            RETURN v_rtn || '>';
        END cell_start;

        FUNCTION cell_end
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '</TD>';
        END cell_end;

        FUNCTION new_cell(p_text IN VARCHAR2, p_col_span IN INTEGER := 0, p_row_span IN INTEGER := 0)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN cell_start(p_col_span, p_row_span) || p_text || cell_end;
        END new_cell;

        FUNCTION make_label(p_text IN VARCHAR2)
            RETURN VARCHAR2 IS
        BEGIN
            RETURN '<LABEL class="optionallabel"><SPAN>' || p_text || '</SPAN></LABEL>';
        END make_label;

        FUNCTION get_indiv_details(p_person_version IN VARCHAR2)
            RETURN VARCHAR2 IS
            v_name                    VARCHAR2(200);
            v_sex                     VARCHAR2(200);
            v_service                 VARCHAR2(200);
            v_address                 VARCHAR2(200);
            v_dob                     DATE;
            v_affiliation             VARCHAR2(200);
            v_race                    VARCHAR2(200);
            v_component               VARCHAR2(200);
            v_ssn                     VARCHAR2(200);
            v_pay_plan                VARCHAR2(200);
            v_confirmed               VARCHAR2(200);
            v_pay_grade               VARCHAR2(200);
            v_rank                    VARCHAR2(200);
            v_rank_date               DATE;
            v_specialty_code          VARCHAR2(200);
            v_military_organization   VARCHAR2(200);
            v_format                  VARCHAR2(11);
        BEGIN
            IF (p_person_version IS NOT NULL) THEN
                SELECT ref_person.current_name(vpv.SID), sex, vpv.sa_service_desc "SA_SERVICE",
                       ref_person.address(vpv.SID, 'CURRENT') AS "ADDRESS", vpv.birth_date,
                       oaffiliation.description AS "SA_AFFILIATION", vpv.race_desc,
                       dcomponent.description AS "SA_COMPONENT",
                       ref_person.latest_number(vpv.SID, 'SSN') AS "SSN",
                       dpay_plan.description AS "SA_PAYPLAN",
                       (SELECT DECODE(confirm_by, NULL, 'Not Confirmed', 'Confirmed')
                          FROM ref_t_person
                         WHERE SID = vpv.person) AS "CONFIRMED",
                       dpay_grade.description AS "SA_PAY_GRADE", vpv.sa_rank AS "SA_RANK",
                       vpv.sa_rank_date AS "SA_RANK_DATE",
                       vpv.sa_specialty_code AS "SA_SPECIALTY_CODE",
                       ref_person.get_org_info(vpv.SID) AS "MILITARY_ORG"
                  INTO v_name, v_sex, v_service,
                       v_address, v_dob,
                       v_affiliation, v_race,
                       v_component,
                       v_ssn,
                       v_pay_plan,
                       v_confirmed,
                       v_pay_grade, v_rank,
                       v_rank_date,
                       v_specialty_code,
                       v_military_organization
                  FROM ref_v_person_version vpv,
                       T_OSI_REFERENCE oaffiliation,
                       T_DIBRS_REFERENCE dcomponent,
                       T_DIBRS_REFERENCE dpay_plan,
                       T_DIBRS_PAY_GRADE_TYPE dpay_grade
                 WHERE (oaffiliation.code(+) = vpv.sa_affiliation AND oaffiliation.USAGE(+) =
                                                                                 'INDIV_AFFILIATION')
                   AND (dcomponent.code(+) = vpv.sa_component AND dcomponent.USAGE(+) =
                                                                                 'SERVICE_COMPONENT')
                   AND (dpay_plan.code(+) = vpv.sa_pay_plan AND dpay_plan.USAGE(+) = 'PAY_PLAN')
                   AND (dpay_grade.code(+) = vpv.sa_pay_grade)
                   AND vpv.SID = p_person_version;

                v_format := Core_Util.get_config('CORE.DATE_FMT_DAY');
            END IF;

            v_rtn := '<TABLE class="formlayout" width="100%" border="0"><TBODY>';
            v_rtn := v_rtn || '<colgroup span="3" align="left" width="33%"></colgroup>';
            v_rtn := v_rtn || row_start || new_cell('Name: ' || v_name);
            v_rtn := v_rtn || new_cell('Sex: ' || v_sex);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Service: ' || v_service);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Address:<br>' || v_address, 0, 8);
            v_rtn := v_rtn || new_cell('Date of Birth: ' || TO_CHAR(v_dob, v_format));

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Affiliation: ' || v_affiliation);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Race: ' || v_race);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Component: ' || v_component);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('SSN: ' || v_ssn);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Plan: ' || v_pay_plan);
            END IF;

            v_rtn := v_rtn || row_end;
            v_rtn := v_rtn || row_start || new_cell('Confirmed: ' || v_confirmed);

            IF (p_omit_sa IS NULL) THEN
                v_rtn := v_rtn || new_cell('Pay Grade: ' || v_pay_grade);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank: ' || v_rank);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Rank Date: ' || TO_CHAR(v_rank_date, v_format));
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Specialty: ' || v_specialty_code);
                v_rtn := v_rtn || row_end;
                v_rtn := v_rtn || row_start || new_cell('');
                v_rtn := v_rtn || new_cell('Military Organization: ' || v_military_organization);
            END IF;

            v_rtn := v_rtn || row_end || '</TBODY></TABLE>';
            RETURN v_rtn;
        END get_indiv_details;
    BEGIN
        RETURN get_indiv_details(p_person_version);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_legacy_part_details: ' || SQLERRM);
            RETURN 'get_legacy_part_details: ' || SQLERRM;
    END get_legacy_part_details;

    FUNCTION get_part_rel_info(p_person IN VARCHAR2)
        RETURN CLOB IS
        v_file_begin   VARCHAR2(2000)
            := '{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}} {\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20';
        v_file_end     VARCHAR2(2000)  := '\par }';
        v_return       CLOB;
        v_temp1        VARCHAR2(20000);
        --v_temp2 varchar2(20000);
        --v_temp3 varchar2(32000);
        v_cnt          NUMBER;
    BEGIN
        --Start File
        v_return := v_file_begin;
        --*****Header
        v_temp1 :=
            'Relational data for: ' || ref_person.current_name(p_person) || ' \par  As of: '
            || SYSDATE || ' \par\par ';
        v_return := v_return || v_temp1;
        v_temp1 := '';
        --*****Associated Activities
        v_temp1 := NULL;
        v_cnt := 0;
        v_temp1 := '\b ASSOCIATED ACTIVITIES \b0 \par \par ';

        FOR k IN (SELECT DISTINCT ID, title, subtype_desc, involvement_role, SID
                             FROM ref_v_person_act_inv
                            WHERE person = p_person)
        LOOP
            --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
            IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                v_cnt := v_cnt + 1;
                v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 Activity ID: ' || k.ID || ' \par ';
                v_temp1 := v_temp1 || 'Activity Title: ' || k.title || ' \par ';
                v_temp1 := v_temp1 || 'Activity Type: ' || k.subtype_desc || ' \par ';
                v_temp1 :=
                         v_temp1 || 'Activity Involvement Role: ' || k.involvement_role || ' \par ';
                v_temp1 := v_temp1 || ' \par ';
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            v_temp1 := v_temp1 || 'No Data Found \par ';
        END IF;

        --Concatonate the activities
        v_return := v_return || v_temp1 || ' \par ';
        --Clear buffer(s)
        v_temp1 := NULL;
        v_cnt := 0;
        v_temp1 := '\b ASSOCIATED FILES \b0 \par \par ';

        --*****Associated Files
        FOR k IN (SELECT DISTINCT ID, title, type_desc, subtype_desc, involvement_role, SID
                             FROM ref_v_person_file_inv
                            WHERE person = p_person)
        LOOP
            --Do not need to check for WEB.SECURE as it does not exist in NIPR so will not exist anyway
            IF (    (ref_classification_pkg.has_hi(k.SID, 'ORCON') <> 'Y')
                AND (ref_classification_pkg.has_hi(k.SID, 'LIMDIS') <> 'Y')) THEN
                v_cnt := v_cnt + 1;
                v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 File ID: ' || k.ID || ' \par ';
                v_temp1 := v_temp1 || 'File Title: ' || k.title || ' \par ';
                v_temp1 := v_temp1 || 'File Type: ' || k.type_desc || ' \par ';
                v_temp1 := v_temp1 || 'File Sub Type: ' || k.subtype_desc || ' \par ';
                v_temp1 := v_temp1 || 'File Involvement Role: ' || k.involvement_role || ' \par ';
                v_temp1 := v_temp1 || ' \par ';
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            v_temp1 := v_temp1 || 'No Data Found \par ';
        END IF;

        --Concatonate the files
        v_return := v_return || v_temp1 || ' \par ';
        --Clear buffer(s)
        v_temp1 := NULL;
        v_cnt := 0;
        v_temp1 := '\b RELATIONSHIPS \b0 \par \par ';

        --*****Relationships
        FOR k IN (SELECT *
                    FROM ref_v_person_relation
                   WHERE this_person = p_person)
        LOOP
            IF (    (NVL(k.mod2_value, 'xxx') NOT LIKE 'ORCON%')
                AND (NVL(k.mod2_value, 'xxx') NOT LIKE 'LIMDIS%')) THEN
                IF (k.rel_desc IS NOT NULL) THEN
                    v_cnt := v_cnt + 1;
                    v_temp1 := v_temp1 || '\b ' || v_cnt || '.> \b0 ' || k.rel_desc || ' \par ';
                    v_temp1 := v_temp1 || 'Participant: ' || k.that_name || ' \par ';

                    -- add specifics if any
                    IF (k.rel_specifics IS NOT NULL) THEN
                        v_temp1 := v_temp1 || 'Specifics: ' || k.rel_specifics || ' \par ';
                    END IF;

                    -- add comments if any
                    IF (k.comments IS NOT NULL) THEN
                        v_temp1 := v_temp1 || 'Comments: ' || k.comments || ' \par ';
                    END IF;

                    v_temp1 := v_temp1 || ' \par ';
                END IF;
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            v_temp1 := v_temp1 || 'No Data Found \par ';
        END IF;

        --Concatonate the files
        v_return := v_return || v_temp1 || ' \par ';
        --Clear buffer(s)
        --v_temp1 := null; [Do Not Need]
        --v_cnt := 0;      [Do Not Need]

        --Finish off file
        v_return := v_return || v_file_end;
        --Send home
        RETURN v_return;
    END get_part_rel_info;

    /* Given a specific role type SID, return the maximum number of participants allowed per object */
    FUNCTION get_max_allowed_for_role(p_role IN VARCHAR2)
        RETURN NUMBER IS
    BEGIN
        FOR k IN (SELECT max_num
                    FROM T_OSI_PARTIC_ROLE_TYPE
                   WHERE SID = p_role)
        LOOP
            RETURN k.max_num;
        END LOOP;

        --Simply return if passed an invalid sid
        RETURN 0;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.get_max_allowed_for_role: ' || SQLERRM);
            RAISE;
    END get_max_allowed_for_role;

    /* Given an object SID and a role SID, return the number already in that given role tied to the given object */
    --Note the exclude parameter, this is used to exclude the current item your on
    FUNCTION get_num_part_in_role(p_obj IN VARCHAR2, p_role IN VARCHAR2, p_exclude IN VARCHAR2)
        RETURN NUMBER IS
        v_cnt       NUMBER;
        v_exclude   VARCHAR2(20);
    BEGIN
        --Clear buffer
        v_cnt := 0;

        --Did this to make the query simpler
        IF (p_exclude IS NULL) THEN
            v_exclude := ' ';
        ELSE
            v_exclude := p_exclude;
        END IF;

        FOR k IN (SELECT SID
                    FROM T_OSI_PARTIC_INVOLVEMENT
                   WHERE obj = p_obj AND involvement_role = p_role AND SID <> v_exclude)
        LOOP
            v_cnt := v_cnt + 1;
        END LOOP;

        --Return value
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.get_num_part_in_role: ' || SQLERRM);
            RAISE;
    END get_num_part_in_role;

    /* Given a participant SID and a personnel SID (optional) will return Y/N if the details should be editable */
    FUNCTION details_are_editable(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_return          VARCHAR2(1)                 := 'N';
        v_personnel_sid   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        --First see if participant object is locked
        FOR k IN (SELECT SID
                    FROM T_OSI_PARTICIPANT
                   WHERE SID = p_obj AND details_lock = 'N')
        LOOP
            --If its not locked, just exit right out
            RETURN 'Y';
        END LOOP;

        --Get the personnel that is attempting to see data
        IF (p_personnel IS NOT NULL) THEN
            v_personnel_sid := p_personnel;
        ELSE
            v_personnel_sid := Core_Context.personnel_sid;
        END IF;

        --Since the object is marked as locked, need to see if the user has the override privilege
        --Action type = 'DET_UNL'
        IF (Osi_Auth.check_for_priv('DET_UNL',
                                    Core_Obj.lookup_objtype('PARTICIPANT'),
                                    v_personnel_sid) = 'Y') THEN
            v_return := 'Y';
        ELSE
            v_return := 'N';
        END IF;

        --If all else, return current v_return value
        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('OSI_PARTICIPANT.details_are_editable: ' || SQLERRM);
            RAISE;
    END details_are_editable;

    procedure reorder_partic_images(p_obj in varchar2, p_cur_seq in number, p_targ_seq in number) is
    begin
        if p_targ_seq > p_cur_seq then                                  --moving LOWER in the chain
            for a in (select   *
                          from t_osi_attachment
                         where obj = p_obj and seq > p_cur_seq and seq <= p_targ_seq
                      order by seq)
            loop
                update v_osi_partic_images
                   set seq = a.seq - 1
                 where SID = a.SID;
            end loop;

            commit;
        elsif p_targ_seq < p_cur_seq then                               --moving HIGHER in the chain
            for a in (select   *
                          from v_osi_partic_images
                         where obj = p_obj and seq >= p_targ_seq and seq < p_cur_seq
                      order by seq)
            loop
                update t_osi_attachment
                   set seq = a.seq + 1
                 where SID = a.SID;
            end loop;

            commit;
        end if;
    exception
        when others then
            log_error('reorder_partic_images: ' || sqlerrm);
            raise;
    end;

    procedure partic_image_sort(v_obj in varchar2) is
        v_seq   Number := 0;
    Begin
        for a in (select   SID
                      from v_osi_partic_images
                     where obj = v_obj
                  order by SEQ asc)
        loop
            v_seq := v_seq + 1;

            update t_osi_attachment
               set seq = v_seq
             where SID = a.SID;
        end loop;

      end;

    FUNCTION Is_Married( pPoPV IN VARCHAR2 ) RETURN VARCHAR2 IS

        v_result VARCHAR2(3);
        v_cnt NUMBER;
    
    BEGIN
        SELECT COUNT(*) INTO v_cnt
          FROM T_OSI_PARTICIPANT_VERSION pv,
               V_OSI_PARTIC_RELATION_2WAY pr
          WHERE pr.this_partic = pv.participant AND
                upper(pr.rel_desc) LIKE '%SPOUSE%' AND
                (pv.participant = pPoPV OR pv.SID = pPoPV) AND
                NVL(pr.END_DATE,(SYSDATE + 1)) > SYSDATE;
                       
        IF v_cnt > 0 THEN

          v_result := 'YES';

        ELSE

          v_result := 'NO';

        END IF;
    
        RETURN (v_result);

    END Is_Married;
--grant select on t_person_name to webi2ms;
--grant select on t_person_number_type to webi2ms;
--grant select on t_person_number to webi2ms;
--grant select on t_person to webi2ms;
--grant select on t_person_version to webi2ms;
--grant select on v_person_version to webi2ms;
--grant select on t_person_citizenship to webi2ms;
--grant select on t_person_mark to webi2ms;
--grant select on t_address_v2 to webi2ms;
--grant select on t_phone_email to webi2ms;
--grant select on t_person_org_attr to webi2ms;
--grant select on t_person_vehicle to webi2ms;
--grant select on t_person_vehicle_body_types to webi2ms;
--grant select on t_person_vehicle_roles to webi2ms;
--grant select on t_date to webi2ms;
--grant select on t_date_type to webi2ms;
--grant select on t_note_v2 to webi2ms;
--grant select on t_attachment_v3 to webi2ms;
--grant select on v_person_act_inv to webi2ms;
--grant select on v_person_file_inv to webi2ms;
--grant select on v_person_relation to webi2ms;
--grant execute on person to webi2ms;
--grant execute on obj_doc_web to webi2ms;
--grant execute on classification_pkg to webi2ms;

--create synonym ref_t_person_name for i2ms.t_person_name;
--create synonym ref_t_person_number_type for i2ms.t_person_number_type;
--create synonym ref_t_person_number for i2ms.t_person_number;
--create synonym ref_t_person for i2ms.t_person;
--create synonym ref_t_person_version for i2ms.t_person_version;
--create synonym ref_v_person_version for i2ms.v_person_version;
--create synonym ref_t_person_citizenship for i2ms.t_person_citizenship;
--create synonym ref_t_person_mark for i2ms.t_person_mark;
--create synonym ref_t_address_v2  for i2ms.t_address_v2;
--create synonym ref_t_phone_email for i2ms.t_phone_email;
--create synonym ref_t_person_org_attr for i2ms.t_person_org_attr;
--create synonym ref_t_person_vehicle for i2ms.t_person_vehicle;
--create synonym ref_t_person_vehicle_bt for i2ms.t_person_vehicle_body_types;
--create synonym ref_t_person_vehicle_roles for i2ms.t_person_vehicle_roles;
--create synonym ref_t_date for i2ms.t_date;
--create synonym ref_t_date_type for i2ms.t_date_type;
--create synonym ref_t_note_v2 for i2ms.t_note_v2;
--create synonym ref_t_attachment_v3 for i2ms.t_attachment_v3;
--create synonym ref_v_person_act_inv  for i2ms.v_person_act_inv;
--create synonym ref_v_person_file_inv  for i2ms.v_person_file_inv;
--create synonym ref_v_person_relation  for i2ms.v_person_relation;
--create synonym ref_person for i2ms.person;
--create synonym ref_obj_doc_web for i2ms.obj_doc_web;
--create synonym ref_classification_pkg for i2ms.classification_pkg;
END Osi_Participant;
/

SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY Osi_Object AS
/******************************************************************************
   Name:     Osi_Object
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     17-Apr-2009 T.McGuffin      Created Package
     29-Apr-2009 T.McGuffin      Added Get_Next_Id Function.
     01-May-2009 Richard Dibble  Added Get_Status
     06-May-2009 T.McGuffin      Added Get_Objtype_Desc function.
     11-May-2009 T.Whitehead     Added Get_Address function.
     20-May-2009 R.Dibble        Modified Get_Status to utilize non-core tables
     21-May-2009 R. Dibble       Added Get_Obj_Package Procedure
     22-May-2009 T.McGuffin      Removed Get_Address.  Created Get_Address_Sid and Get_Participant_Sid
     27-May-2009 T.McGuffin      Added Create_Lead_Assignment procedure.
     01-Jun-2009 T.McGuffin      Added Get_Objtypes function.
     01-Jun-2009 T.McGuffin      Added Get_ID function.
     24-Aug-2009 T.McGuffin      Modified get_object_url to include optional parameters for item names and vals.
     13-Oct-2009 J.Faris         Added Delete_Object
     02-Nov-2009 T.Whitehead     Added get/set_special_interest.
     02-Nov-2009 Richard Dibble  Added get_objtype_code
     17-Dec-2009 T.Whitehead     Added get_default_title.
     18-Dec-2009 T.Whitehead     Added do_title_substitution.
     28-Dec-2009 T.Whitehead     Added get_status_code.
     12-Jan-2010 T.Whitehead     Added optional parameter p_text to get_open_link.
     13-Jan-2010 T.McGuffin      Added check_writability function.
     22-Feb-2010 T.McGuffin      Added is_assigned function.
     26-Feb-2010 T.McGuffin      Added get_lead_agent function.
     24-Mar-2010 T.McGuffin      Modified get_assigned_unit function to include cfunds advances.
     27-Apr-2010 J.Horne         Modified get/set_special_interest to include only special Interests
                                 that have been marked 'I.'
     10-May-2010 R.Dibble        Modified delete_object to always reject when the object type is UNIT
     25-May-2010 T.Leighty       Added addicon, append_assoc_activities, append_involved_participants,
                                 append_attachments, append_notes, append_related_files, get_template
                                 and doc_detail
     27-May-2010 T.Leighty       Modified append_involved_participants to use correct view table 
                                 combination in queries.
     08-Jun-2010 T.Leighty       Modified append_involved_participants to fix bug that prevented all
                                 file types to be included.
     15-Jul-2010 J.Faris         Implementing a previous update to error handling in is_assigned function.
     30-Nov-2010 J.Horne         Updated append_attachments; changed format for URL
     30-Nov-2010 Tim Ward        Changed get_next_id incase IDs are gotten in Rapid Succession.
     07-Dec-2010 Tim Ward        Added getStatusBar.
     09-Dec-2010 Richard Dibble  Modified get_object_url to forward user to a dummy page if they do not have access.
     13-Dec-2010 Richard Dibble  Modified get_object_url to supress logging
     18-Jan-2011 Tim Ward        Redid getStatusBar to not use the jixedBar.
     19-Jan-2011 Tim Ward        Added Last DEERS date to a PART.INDIV object's statusbar.
     19-Jan-2011 Tim Ward        Added core_util.get_config('OSI.IMAGE_PREFIX') to getStatusBar so we can get the correct
                                 #IMAGE_DIR# value for the Min/Max.gif buttons.
     16-Feb-2011 Tim Ward        Problem pulling correct DEERS_DATE.
     04-Mar-2011 Tim Ward        CR#3734 - set_special_interest is deleting 'I' and 'A' and it should only delete 'I'.
     18-Mar-2011 Tim Ward        CR#3731 - PERSONNEL should not be deleted.
                                  Also defaulted delete_object to return 'You are not authorized to perform the requested action.'
                                  instead of 'Y'.  Removed the checkForPriv from i2ms.js deleteObj function.
                                  Changed in delete_object.

******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_OBJECT';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;
    
    FUNCTION get_default_title(p_obj_type_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT default_title
                    FROM T_OSI_OBJ_TYPE
                   WHERE SID = p_obj_type_sid)
        LOOP
            RETURN x.default_title;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_default_title: ' || SQLERRM);
    END get_default_title;
    
    PROCEDURE do_title_substitution(p_obj IN VARCHAR2) IS
        v_objcode   T_CORE_OBJ_TYPE.code%TYPE;
        v_updated   VARCHAR2(4000);
        v_sid       T_CORE_OBJ.SID%TYPE;
    BEGIN
        SELECT code
          INTO v_objcode
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        /*
         * Any object types that need special processing should have a case statement
         * that is above 'ACT%' added for them.
         */
        CASE
            WHEN v_objcode LIKE 'ACT.AAPP%' THEN
                BEGIN
                    SELECT file_sid
                      INTO v_sid
                      FROM T_OSI_ASSOC_FLE_ACT
                    WHERE activity_sid = p_obj;
                    
                    v_updated := Osi_Util.do_title_substitution(v_sid, Osi_Activity.get_title(p_obj));
                    v_updated := Osi_Util.do_title_substitution(p_obj, v_updated);
                    
                    UPDATE T_OSI_ACTIVITY
                       SET title = v_updated
                     WHERE SID = p_obj;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- This should never happen.
                        log_error('do_title_substitution: - Error in ACT.AAPP% case - ' || SQLERRM);
                 END;
                 
            WHEN v_objcode LIKE 'ACT%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_Activity.get_title(p_obj));

                UPDATE T_OSI_ACTIVITY
                   SET title = v_updated
                 WHERE SID = p_obj;

            WHEN v_objcode LIKE 'FILE%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_File.get_title(p_obj), 'T_OSI_FILE');

                UPDATE T_OSI_FILE
                   SET title = v_updated
                 WHERE SID = p_obj;
        END CASE;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('do_title_substitution: ' || SQLERRM);
    END do_title_substitution;

    FUNCTION get_participant_sid(p_obj IN VARCHAR2, p_usage IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_OSI_PARTICIPANT.SID%TYPE;
    BEGIN
        IF p_obj IS NOT NULL AND p_usage IS NOT NULL THEN
            SELECT i.participant_version
              INTO v_rtn
              FROM T_OSI_PARTIC_INVOLVEMENT i, T_OSI_PARTIC_ROLE_TYPE ir
             WHERE i.involvement_role = ir.SID AND i.obj = p_obj AND ir.USAGE = p_usage;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN v_rtn;
        WHEN OTHERS THEN
            log_error('get_participant_sid: ' || SQLERRM);
            RAISE;
    END get_participant_sid;

    FUNCTION get_object_url(
        p_obj           IN   VARCHAR2,
        p_item_names    IN   VARCHAR2 := NULL,
        p_item_values   IN   VARCHAR2 := NULL)
    RETURN VARCHAR2 IS
        v_url   VARCHAR2(200);
        v_obj            T_CORE_OBJ.SID%TYPE;
        v_obj_context    T_OSI_PARTICIPANT_VERSION.SID%TYPE;
    BEGIN
    
        --See if this person has access first
        IF (Osi_Auth.Check_Access(p_obj, p_supress_logging=>TRUE) = 'N') THEN
            --They do not, so do not give them the URL
            v_url := 'javascript:newWindow({page:120,clear_cache:'''',name:'''',item_names:''P120_OBJ'',item_values:''' || p_obj || ','',request:''OPEN''})';
            RETURN v_url;
        END IF;
    
        v_obj := p_obj;
        -- Determine if the given p_obj is an obj sid or a participant version sid.
        FOR x IN (SELECT SID, participant
                    FROM v_osi_participant_version
                   WHERE SID = p_obj)
        LOOP
            v_obj := x.participant;
            v_obj_context := x.SID;
        END LOOP;
        
        SELECT 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
                   || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                   || DECODE(p_item_names, NULL, NULL, ',' || p_item_names) || ''',item_values:'''
                   || v_obj || ',' || v_obj_context || DECODE(p_item_values, NULL, NULL, ',' || p_item_values)
                   || ''',request:''OPEN''})'
              INTO v_url
              FROM T_CORE_DT_OBJ_TYPE_PAGE
             WHERE obj_type MEMBER OF Osi_Object.get_objtypes(v_obj) AND page_function = 'OPEN';
        RETURN v_url;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_object_url: ' || SQLERRM);
            RETURN('get_object_url: Error');
    END get_object_url;

    FUNCTION get_open_link(p_obj IN VARCHAR2, p_text IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn VARCHAR2(200);
    BEGIN
        IF p_obj IS NOT NULL THEN
            v_rtn := '<!--' || p_obj || '--><a href="' || get_object_url(p_obj) || '">';
            IF(p_text IS NULL)THEN
                v_rtn := v_rtn || 'Open</a>';
            ELSE
                v_rtn := v_rtn || p_text || '</a>';
            END IF;
            RETURN v_rtn;
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_open_link: ' || SQLERRM);
            RETURN('get_open_link: Error');
    END get_open_link;

    FUNCTION get_tagline_link(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF p_obj IS NOT NULL THEN
            RETURN '<!--' || Core_Obj.get_tagline(p_obj) || '--><a href="' || get_object_url(p_obj)
                  || '">' || Core_Obj.get_tagline(p_obj) || '</a>';
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline_link: ' || SQLERRM);
            RETURN('get_tagline_link: Error');
    END get_tagline_link;

    FUNCTION get_next_id
        RETURN VARCHAR2 IS
        v_personnel_num T_CORE_PERSONNEL.personnel_num%TYPE := NVL(Core_Context.personnel_num, '00000');
        v_year          NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'yy'));
        v_doy           NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'ddd'));
        v_hours         NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'hh24'));
        v_minutes       NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'mi'));
        v_tmp_id        T_OSI_FILE.ID%TYPE                  := NULL;
        v_exists        NUMBER                              := 1;
    BEGIN
         LOOP
             v_tmp_id := LTRIM(RTRIM(TO_CHAR(v_personnel_num,'00000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_year,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_doy,'000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_hours,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_minutes,'00')));

             BEGIN
                 SELECT 1
                   INTO v_exists
                   FROM dual
                  WHERE EXISTS(SELECT 1
                                 FROM (SELECT ID
                                         FROM T_OSI_FILE
                                       UNION ALL
                                       SELECT ID
                                         FROM T_OSI_ACTIVITY) o
                                WHERE o.ID = v_tmp_id);
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     EXIT;
             END;

             v_minutes := v_minutes - 1;

             IF v_minutes < 0 THEN
                
               v_hours := v_hours - 1;
                
               IF v_hours < 0 THEN
                  
                 v_doy := v_doy - 1;
                
                 IF v_doy < 0 THEN
                  
                   v_doy := 365;
                  
                 END IF;
                
                 v_hours := 23;
                  
               END IF;
                
               v_minutes := 59;
                
              END IF;
            
          END LOOP;

          RETURN v_tmp_id;
          
    END get_next_id;

    FUNCTION get_special_interest(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_array    apex_application_global.vc_arr2;
        v_idx      INTEGER                         := 1;
        v_string   VARCHAR2(4000);
    BEGIN
        FOR i IN (SELECT mission
                    FROM T_OSI_MISSION
                   WHERE obj = p_sid
                    AND obj_context = 'I')
        LOOP
            v_array(v_idx) := i.mission;
            v_idx := v_idx + 1;
        END LOOP;

        v_string := apex_util.table_to_string(v_array, ':');
        RETURN v_string;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_special_interest: ' || SQLERRM);
            RAISE;
    END get_special_interest;

    PROCEDURE set_special_interest(p_sid IN VARCHAR2, p_special_interest IN VARCHAR2) IS
        v_array    apex_application_global.vc_arr2;
        v_string   VARCHAR2(4000);
    BEGIN
        v_array := apex_util.string_to_table(p_special_interest, ':');

        FOR i IN 1 .. v_array.COUNT
        LOOP
            INSERT INTO T_OSI_MISSION
                        (obj, mission, obj_context)
                SELECT p_sid, v_array(i), 'I'
                  FROM dual
                 WHERE NOT EXISTS(SELECT 1
                                    FROM T_OSI_MISSION
                                   WHERE obj = p_sid AND mission = v_array(i) AND obj_context = 'I');
        END LOOP;

        DELETE FROM T_OSI_MISSION
              WHERE obj = p_sid AND INSTR(NVL(p_special_interest, 'null'), mission) = 0 and obj_context='I';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('set_special_interest: ' || SQLERRM);
            RAISE;
    END set_special_interest;
    
    /* Gets the status history SID of an object */
    FUNCTION get_status_history_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR k IN (SELECT SID
                    FROM T_OSI_STATUS_HISTORY
                   WHERE obj = p_obj AND is_current = 'Y')
        LOOP
            RETURN k.SID;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in get_status_history_sid function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_history_sid;
    
    FUNCTION get_status_code(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT s.code
                    FROM T_OSI_STATUS_HISTORY sh, T_OSI_STATUS s
                   WHERE sh.SID = get_status_history_sid(p_obj)
                     AND sh.status = s.SID)
        LOOP
            RETURN x.code;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status_code: ' || SQLERRM);
            RETURN NULL;
    END get_status_code;

    FUNCTION get_status_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR a IN (SELECT status
                    FROM T_OSI_STATUS_HISTORY
                   WHERE SID = get_status_history_sid(p_obj))
        LOOP
            RETURN a.status;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in GET_STATUS function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_sid;

    FUNCTION get_status(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_status   T_OSI_STATUS.description%TYPE;
    BEGIN
        IF p_obj IS NULL THEN
            log_error('get_status: null parameter passed');
            RETURN NULL;
        END IF;

        SELECT description
          INTO v_status
          FROM T_OSI_STATUS
         WHERE SID = get_status_sid(p_obj);

        RETURN v_status;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status: ' || SQLERRM || ' ~ ' || p_obj);
            RETURN NULL;
    END get_status;

    FUNCTION get_objtype_desc(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_description   T_CORE_OBJ_TYPE.description%TYPE;
    BEGIN
        SELECT description
          INTO v_description
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type
            OR code = p_obj_type;

        RETURN v_description;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_desc: ' || SQLERRM);
            RETURN('get_objtype_desc: Error');
    END get_objtype_desc;
    
        FUNCTION get_objtype_code(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   T_CORE_OBJ_TYPE.code%TYPE;
    BEGIN
        SELECT code
          INTO v_return
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_code: ' || SQLERRM);
            RETURN('get_objtype_code: Error');
    END get_objtype_code;

    /* Gets the object specific package to call */
    FUNCTION get_obj_package(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_package   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        SELECT method_pkg
          INTO v_package
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_package;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_obj_package: ' || SQLERRM);
            RAISE;
    END get_obj_package;

    PROCEDURE create_lead_assignment(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL) IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        IF p_obj IS NOT NULL THEN
            INSERT INTO T_OSI_ASSIGNMENT
                        (obj, personnel, unit, start_date, assign_role)
                 VALUES (p_obj,
                         v_personnel,
                         Osi_Personnel.get_current_unit(v_personnel),
                         SYSDATE,
                         (SELECT SID
                            FROM T_OSI_ASSIGNMENT_ROLE_TYPE
                           WHERE obj_type MEMBER OF get_objtypes(p_obj) AND code = 'LEAD'));
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_lead_assignment: ' || SQLERRM);
            RAISE;
    END create_lead_assignment;

    /* pipelines records of type t_parent_list one at a time.
       finds the input object type first, including this in the list.
       then it return the parent object type, and the parent's parent, etc.. */
    FUNCTION get_objtypes(p_obj_or_type IN VARCHAR2)
        RETURN t_parent_list pipelined IS
        v_tmp_parent    T_OSI_OBJ_TYPE.PARENT%TYPE;
        v_tmp_objtype   T_OSI_OBJ_TYPE.SID%TYPE;
    BEGIN
        v_tmp_objtype := Core_Obj.get_objtype(p_obj_or_type);

        IF v_tmp_objtype IS NULL THEN
            v_tmp_objtype := p_obj_or_type;
        END IF;

        LOOP
        BEGIN
            pipe ROW(v_tmp_objtype);

            SELECT PARENT
              INTO v_tmp_parent
              FROM T_OSI_OBJ_TYPE
             WHERE SID = v_tmp_objtype;

            EXIT WHEN v_tmp_parent IS NULL;
            v_tmp_objtype := v_tmp_parent;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            EXIT;
        END;
        END LOOP;

        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('get_objtypes: ' || SQLERRM);
            RETURN;
    END get_objtypes;

    FUNCTION get_id(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        SELECT method_pkg, code
          INTO v_method_pkg, v_type_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        IF v_type_code LIKE 'ACT.%' THEN
            RETURN Osi_Activity.get_id(p_obj);
        ELSIF v_type_code LIKE 'FILE.%' THEN
            RETURN Osi_File.get_id(p_obj);
        ELSIF v_method_pkg IS NULL THEN
            RETURN NULL;
        ELSE
            BEGIN
                EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.get_id(:obj,:context); end;'
                        USING OUT v_rtn, IN p_obj, IN p_obj_context;
                RETURN v_rtn;
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN NULL;
            END;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'invalid object type';
        WHEN OTHERS THEN
            RETURN 'untrapped error';
    END get_id;
    
    /* Takes and ACTIVITY or FILE sid and return the currently assigned unit */
    FUNCTION get_assigned_unit(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(20);
    --This function is assuming an object will always have an assignment of some type
    BEGIN
        --See if it is an activity
        FOR k IN (SELECT assigned_unit
                    FROM T_OSI_ACTIVITY
                   WHERE SID = p_obj)
        LOOP
            --An activity was found, send back the unit.
            RETURN k.assigned_unit;
        END LOOP;

        FOR k IN (SELECT SID FROM T_OSI_FILE WHERE SID = p_obj)
        LOOP
            RETURN Osi_File.get_unit_owner(p_obj);
        END LOOP;

        FOR k IN (SELECT unit FROM T_CFUNDS_ADVANCE_V2 WHERE SID = p_obj) LOOP
            RETURN k.unit;
        END LOOP;
        
        RETURN '<none>';
    EXCEPTION
        WHEN OTHERS THEN
            log_error(SQLERRM);
            RAISE;
    END get_assigned_unit;
    
    /* Performs deletion operation for all objects */
    FUNCTION delete_object(p_obj IN VARCHAR2) RETURN VARCHAR2 IS

          v_rtn      VARCHAR2(200)             := NULL;
          v_ot       VARCHAR2(20)              := NULL;
          v_ot_cd    VARCHAR2(200)             := NULL;

    BEGIN
         v_ot := Core_Obj.get_objtype(p_obj);

         IF v_ot IS NULL THEN

           log_error('Delete_Object: Error locating Object Type for ' || NVL(v_ot, 'NULL'));
           RETURN 'Invalid Object passed to Delete_Object';

         END IF;

         SELECT code INTO v_ot_cd FROM T_CORE_OBJ_TYPE WHERE SID = v_ot;

         CASE 
             WHEN SUBSTR(v_ot_cd,1,3) = 'ACT' THEN

                 v_rtn := Osi_Activity.can_delete(p_obj);

             WHEN SUBSTR(v_ot_cd,1,4) = 'FILE' THEN

                 v_rtn := Osi_File.can_delete(p_obj);
  
             WHEN SUBSTR(v_ot_cd,1,4) = 'PART' THEN

                 v_rtn := Osi_Participant.can_delete(p_obj);
      
             WHEN v_ot_cd = 'CFUNDS_ADV' THEN

                 v_rtn := Osi_Cfunds_Adv.can_delete(p_obj);
  
             WHEN v_ot_cd = 'CFUNDS_EXP' THEN

                 v_rtn := Osi_Cfunds.can_delete(p_obj);

             WHEN v_ot_cd = 'UNIT' THEN

                 ---Can never delete units, if this changes, will need to make a OSI_UNIT.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';

             WHEN v_ot_cd = 'PERSONNEL' THEN

                 ---Can never delete Personnel, if this changes, will need to make a OSI_PERSONNEL.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';
             
             WHEN v_ot_cd = 'EVIDENCE' THEN

                 ---Gets here ONLY if the Evidence is NOT Read-ONLY---
                 v_rtn := 'Y';
                      
             ELSE 
                 v_rtn := 'You are not authorized to perform the requested action.';

         END CASE;

         IF v_rtn <> 'Y' THEN

           RETURN v_rtn;

         END IF;
    
         ---execute the delete, all object-specific and child table deletions will cascade---
         DELETE FROM T_CORE_OBJ WHERE SID = p_obj;

         RETURN 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            log_error('Delete_Object: Error encountered using Object ' || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in Delete_Object using Object: ' || NVL(p_obj, 'NULL');
    END delete_object;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        
        SELECT method_pkg, code
          INTO v_method_pkg, v_type_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        IF v_type_code LIKE 'ACT.%' THEN
            RETURN Osi_Activity.check_writability(p_obj);
        ELSE
            BEGIN
                EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.check_writability(:obj,:context); end;'
                        USING OUT v_rtn, IN p_obj, IN p_obj_context;
                RETURN v_rtn;
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN 'Y';
            END;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('osi_object.check_writability: invalid object type');
        WHEN OTHERS THEN
            log_error('osi_object.check_writablity: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION is_assigned(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        FOR x IN (SELECT 'Y' AS result
                    FROM T_OSI_ASSIGNMENT
                   WHERE obj = p_obj
                     AND personnel = v_personnel
                     AND SYSDATE BETWEEN NVL(start_date, TO_DATE('01011901', 'mmddyyyy'))
                                     AND NVL(end_date, TO_DATE('12312999', 'mmddyyyy')))
        LOOP
            RETURN x.result;
        END LOOP;
        
        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.is_assigned: ' || SQLERRM);
            RAISE;
    END is_assigned;

    FUNCTION get_lead_agent(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR i IN (SELECT oa.personnel
                    FROM T_OSI_ASSIGNMENT oa, 
                         T_OSI_ASSIGNMENT_ROLE_TYPE oart
                   WHERE oa.obj = p_obj
                     AND oa.assign_role = oart.SID 
                     AND oart.code = 'LEAD'
                ORDER BY oa.end_date DESC)
        LOOP
            RETURN i.personnel;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.get_lead_agent: ' || SQLERRM);
            RAISE;
    END get_lead_agent;


--======================================================================================================================
--======================================================================================================================
    FUNCTION addicon(v_template IN CLOB, p_sid IN VARCHAR2)
        RETURN CLOB IS
        v_rtn        CLOB           := NULL;
        v_iconlink   VARCHAR2(1000);
        v_inifile    VARCHAR2(128);
        v_vlturl     VARCHAR2(1000);
    BEGIN

        SELECT setting                                                                       --value
          INTO v_inifile
          FROM T_CORE_CONFIG
         WHERE code = 'DEFAULTINI';

        v_iconlink :=
            '<A HREF="I2MS:://pSid=' || p_sid || ' ' || v_inifile
            || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="\images\I2MS\OBJ_SEARCH\i2ms.gif"></A>&nbsp&nbsp';
        IF    Core_Util.get_config('OSI_VLT_URL_JSP') IS NOT NULL
           OR Core_Util.get_config('OSI_VLT_URL_OWA') IS NOT NULL THEN

        v_iconlink :=
            v_iconlink || '<A HREF="' || v_vlturl
            || '"><IMG BORDER=0 ALT="Launch Visual Link Tool" SRC="\images\I2MS\OBJ_SEARCH\vlt.gif"></A>&nbsp&nbsp';

        END IF;
        IF    v_template = ''
           OR v_template IS NULL THEN
            v_rtn := v_iconlink;
        ELSE
            SELECT REPLACE(v_template, '<h2>', '<h2>' || v_iconlink)
              INTO v_rtn
              FROM dual;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.AddIcon Error: ' || SQLERRM);
            RETURN v_template;
    END addicon;

--======================================================================================================================
--   Retrieve the poper template                                                                                      ==
--======================================================================================================================

    PROCEDURE get_template(p_name IN VARCHAR2, p_template IN OUT NOCOPY CLOB) IS
        v_date              DATE;
        v_ok                VARCHAR2(256);
        v_prefix            VARCHAR2(20) := 'osi_';
        v_mime_type         T_CORE_TEMPLATE.mime_type%TYPE;
        v_mime_disposition  T_CORE_TEMPLATE.mime_disposition%TYPE;
    BEGIN

        v_ok := Core_Template.get_latest(v_prefix || p_name, p_template, v_date, v_mime_type, v_mime_disposition);

        IF v_date IS NULL THEN                                         -- try it without the prefix
            v_ok := Core_Template.get_latest(p_name, p_template, v_date, v_mime_type, v_mime_disposition);

            IF v_date IS NULL THEN

                RAISE_APPLICATION_ERROR(-20200,
                                        'Could not locate template "' || v_prefix || p_name || '"');
            END IF;
        END IF;

    END get_template;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_assoc_activities(
        p_doc      IN OUT NOCOPY   CLOB,
        p_parent   IN              VARCHAR2) IS

        v_cnt    NUMBER;
        v_temp   VARCHAR2(5000);

    BEGIN
        v_cnt := 0;

        FOR h IN (SELECT activity_sid, activity_id, activity_title
                    FROM v_osi_assoc_fle_act
                   WHERE file_sid = p_parent)
        LOOP
            IF (   (Core_Classification.has_hi(h.activity_sid, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.activity_sid, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Assoc_Activities: Object is ORCON or LIMDIS - User does not have permission to view document '
                     || 'therefore no link will be generated');
            ELSE
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
            v_temp := v_temp || Osi_Object.get_tagline_link(h.activity_sid);
            v_temp := v_temp || ', ' || h.activity_title || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;
    END append_assoc_activities;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_attachments(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_cnt2   NUMBER         := 0;
        v_temp   VARCHAR2(5000);

    BEGIN

        FOR h IN (SELECT a.SID, 
                           AT.USAGE, 
                           NVL(a.description, AT.description) AS desc_type,
                           NVL(dbms_lob.getlength(a.content), 0) AS blob_length
                      FROM T_OSI_ATTACHMENT a,
                           T_OSI_ATTACHMENT_TYPE AT,
                           T_CORE_OBJ o,
                           T_CORE_OBJ_TYPE ot
                     WHERE a.obj = p_parent
                       AND a.obj = o.SID
                       AND a.TYPE = AT.SID(+)
                       AND o.obj_type = ot.SID
                       AND NVL(AT.USAGE, 'ATTACHMENT') = 'ATTACHMENT'
                  ORDER BY a.modify_on)
        LOOP
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD><B>' || v_cnt || ':</B> </TD>';
            v_temp := v_temp || '<TD width="100%">';

            IF h.blob_length > 0 THEN
                --v_temp := v_temp || '<a href="docs/' || h.sid || '">';
                v_temp := v_temp || '<a href="f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':'
                                || h.SID || ':' || v('DEBUG') || ':250: " target="blank"/>';
            END IF;

            -- If there is no description then put something
            IF h.desc_type IS NULL THEN
                v_temp := v_temp || h.SID;
            ELSE
                v_temp := v_temp || h.desc_type;
            END IF;

            IF h.blob_length > 0 THEN
              v_temp := v_temp || '</a>';
            END IF;

            v_temp := v_temp || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
        END LOOP;
        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.Append_Attachments Error: ' || SQLERRM);
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
    END append_attachments;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_involved_participants(
        p_clob         IN OUT NOCOPY   CLOB,
        p_parent       IN              VARCHAR2,
        p_leave_blank  IN              BOOLEAN := FALSE) IS

        v_object_type   VARCHAR2(4);

    BEGIN
      SELECT SUBSTR(ot.code, 1, 4)
        INTO v_object_type
        FROM T_CORE_OBJ o,
             T_CORE_OBJ_TYPE ot
       WHERE o.SID = p_parent
         AND o.obj_type = ot.SID;

      CASE v_object_type
      WHEN 'FILE'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT fi.ROLE,
                           pv.participant
                      FROM v_osi_partic_file_involvement fi,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = fi.participant_version
                       AND fi.file_sid = p_parent
                  ORDER BY fi.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      WHEN 'ACT.'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT ai.ROLE,
                           pv.participant
                      FROM v_osi_partic_act_involvement ai,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = ai.participant_version
                       AND ai.activity = p_parent
                 ORDER BY ai.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      ELSE
        IF NOT p_leave_blank 
          THEN
            Osi_Util.aitc(p_clob, '<tr><td>No data found</td></tr>');
        END IF;
      END CASE;
    

    END append_involved_participants;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_notes(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt   NUMBER := 0;
    BEGIN

        v_cnt := 0;

        FOR n IN (SELECT n.modify_on, 
                      nt.description,
                      n.note_text
                 FROM T_OSI_NOTE n,
                      T_OSI_NOTE_TYPE nt
                WHERE n.obj = p_parent
                  AND n.note_type = nt.SID
             ORDER BY n.modify_on DESC)
        LOOP
            v_cnt := v_cnt + 1;
            Osi_Util.aitc(p_doc,
                 '<TR><TD width="100%"><B>' || v_cnt || ': NOTE (' || n.description || ', '
                 || TO_CHAR(n.modify_on, 'dd-Mon-YY hh24:mi:ss') || ')</B><BR>');
            dbms_lob.append(p_doc, Core_Util.html_ize(n.note_text));
            Osi_Util.aitc(p_doc, CHR(13) || CHR(10) || '</TD></TR>');
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD>No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Util.append_info_to_clob(p_doc,
                                '<TR><TD width="100%">No Data Found</TD></TR>' || CHR(13) || CHR(10)
                                || '</table></body>' || CHR(13) || CHR(10),
                                '');
    END append_notes;


--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_related_files(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_temp   VARCHAR2(5000);
    BEGIN

        FOR h IN (SELECT af.file_a AS related_file,
                        (SELECT ID
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS ID,
                        (SELECT title
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS title,
                        (SELECT sot.description
                           FROM T_CORE_OBJ so,
                                T_CORE_OBJ_TYPE sot
                          WHERE so.SID = af.file_a
                            AND so.obj_type = sot.SID) AS description
                   FROM T_OSI_FILE f,
                        T_OSI_ASSOC_FLE_FLE af,
                        T_CORE_OBJ o,
                        T_CORE_OBJ_TYPE ot
                  WHERE f.SID = p_parent
                    AND f.SID = o.SID
                    AND f.SID = af.file_b
                    AND o.obj_type = ot.SID 
                  UNION 
                 SELECT af.file_b AS related_file,
                       (SELECT ID
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS ID,
                       (SELECT title
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS title,
                       (SELECT sot.description
                          FROM T_CORE_OBJ so,
                               T_CORE_OBJ_TYPE sot
                         WHERE so.SID = af.file_b
                           AND so.obj_type = sot.SID) AS description
                  FROM T_OSI_FILE f,
                       T_OSI_ASSOC_FLE_FLE af,
                       T_CORE_OBJ o,
                       T_CORE_OBJ_TYPE ot
                 WHERE f.SID = p_parent
                   AND f.SID = o.SID
                   AND f.SID = af.file_a
                   AND o.obj_type = ot.SID 
              ORDER BY ID)
        LOOP
            IF ((Core_Classification.has_hi(h.related_file, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.related_file, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Related_Files: Object is ORCON or LIMDIS - User does not have permission to view document therefore no link will be generated');
            ELSE
                v_cnt := v_cnt + 1;
                v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
                v_temp := v_temp || Osi_Object.get_tagline_link(h.related_file) || ', ';
                v_temp := v_temp || h.title || ', ' || h.description;
                v_temp := v_temp || '</TD></TR>';
                Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;

    END append_related_files;


--======================================================================================================================
--  Initial parsing routine to determine appropriate report to generate.  Once the the proper report is determined    ==
--  the coorisponding report procedure is called.                                                                     ==
--======================================================================================================================
    PROCEDURE doc_detail(p_sid IN VARCHAR2 := NULL) IS

        v_ok           VARCHAR2(1000);
        v_doc          CLOB;
        v_obj_type     T_CORE_OBJ_TYPE.code%TYPE;
        v_authorized   VARCHAR2(10);                             -- can the user run a search
        v_restrict     VARCHAR2(10);                             -- For checking restricted objects
        v_cookie       VARCHAR2(100)   := NULL;

    BEGIN

        BEGIN
            -- restricted files and activities should not be displayed
            v_obj_type := NULL;
            v_restrict := NULL;

            SELECT SUBSTR(ot.code, 1, 3)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'ACT' THEN

                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_ACTIVITY a,
                       T_OSI_REFERENCE r
                 WHERE a.SID = p_sid
                   AND a.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This activity is restricted.');
                    RETURN;
                END IF;
            END IF;

            SELECT SUBSTR(ot.code, 1, 4)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'FILE' THEN
                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_FILE f,
                       T_OSI_REFERENCE r
                 WHERE f.SID = p_sid
                   AND f.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This file is restricted.');
                    RETURN;
                END IF;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;                                                 -- Continue processing
        END;

        -- there are calls from other procedures that do not set up the links to pass obj_type.
        -- therefore the need to make sure there is one. Hopefully.
        SELECT ot.code
          INTO v_obj_type
          FROM T_CORE_OBJ o,
               T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_sid
           AND o.obj_type = ot.SID;

        Core_Util.append_info_to_clob(v_doc, CHR(10), '');

        IF SUBSTR(v_obj_type, 1, 3) = 'ACT'
          THEN Osi_Activity.make_doc_act(p_sid, v_doc);   -- Activity Report
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART'
              THEN Osi_Participant.run_report_details(p_sid); -- Participant Report
              ELSE
                IF SUBSTR(v_obj_type, 1, 8) = 'FILE.INV'
                  THEN Osi_Investigation.make_doc_investigative_file(p_sid, v_doc); -- Investigative File Report
                  ELSE Osi_File.make_doc_misc_file(p_sid, v_doc); -- General File Report
                END IF;
            END IF;
        END IF;


        IF dbms_lob.getlength(v_doc) > 10 
          THEN
            v_ok := Core_Util.serve_clob(v_doc);
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART' 
              THEN NULL;
              ELSE htp.print('<html><head><title>No Document Exists</title></head>'
                      || '<body>No document currently exists for this object.</body></html>');
           END IF;
        END IF;

        Core_Util.cleanup_temp_clob(v_doc);
    END doc_detail;
 
    FUNCTION getStatusBar(p_obj_sid IN VARCHAR2) RETURN VARCHAR2 IS

        v_return VARCHAR2(4000);
        v_type_descr VARCHAR2(200);
        v_create_on VARCHAR2(200);
        v_status VARCHAR2(200);
        v_type_code VARCHAR2(200);
        v_tag VARCHAR2(200);
        v_obtained_by VARCHAR2(200);
        v_personnel_name VARCHAR2(200);
        v_unit_name VARCHAR2(200);
        v_suffix VARCHAR2(200);
        v_obj_type_sid VARCHAR2(200);
        v_obj_act_type_sid VARCHAR2(200);
        v_obj_fle_type_sid VARCHAR2(200);
        v_photo_count VARCHAR2(200);
        v_photo_size VARCHAR2(200);
        v_photo_tab_sid VARCHAR2(200);
        v_deers_date date;
        v_deers_date_string varchar2(200);
        
    BEGIN
         IF p_obj_sid IS NULL OR p_obj_sid='' THEN
    
           RETURN '';
     
         END IF;
   
         --- Get the Object Type Sid for ALL Activities ---
         BEGIN
              SELECT SID INTO v_obj_act_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='ACT';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_act_type_sid := '*unknown*';
      
         END;

         --- Get the Object Type Sid for ALL Files ---
         BEGIN
              SELECT SID INTO v_obj_fle_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='FILE';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_fle_type_sid := '*unknown*';
      
         END;

         --- Get the Type Code and Sid for the Current Object (p_obj_sid) ---
         BEGIN
              SELECT CODE,T.SID INTO v_type_code,v_obj_type_sid FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_code := '*unknown*';
      
         END;

         IF v_type_code IN ('EMM','UNIT','*unknown*') THEN
       
           RETURN '';
     
         END IF;
      
         --- Get Status for C-Funds Expense Objects ---
         IF v_type_code = 'CFUNDS_EXP' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_expense_v3 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for C-Funds Advance Objects ---
         ELSIF v_type_code = 'CFUNDS_ADV' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_advance_v2 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for All Other Objects ---
         ELSE
   
           BEGIN
                SELECT Osi_Object.get_status(p_obj_sid) INTO v_status FROM dual;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;
     
         END IF;
   
         --- Fix the Working for Pariticpant Confirmed/Unconfirmed ---
         IF v_status IN ('Confirm','Unconfirm') THEN
      
           v_status := v_status || 'ed';
     
         END IF;
   
         --- Get Object Type Description ---
         BEGIN
              SELECT description INTO v_type_descr FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_descr := '*unknown*';
      
         END;

         --- Get Create On Date ---
         BEGIN
              SELECT TO_CHAR(create_on,'dd-Mon-yyyy') INTO v_create_on FROM T_CORE_OBJ WHERE SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_create_on := '*unknown*';
      
         END;

         --- Get Activity Or File Suffix so we will say "Search Activity" instead of just "Search" ---
         BEGIN
              SELECT ' Activity' INTO v_suffix FROM dual WHERE v_obj_act_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
         EXCEPTION WHEN OTHERS THEN
            
            v_suffix := '';
      
         END;
   
         --- Get Activity Or File Suffix so we will say "Case File" instead of just "Case" ---
         IF v_suffix = '' OR v_suffix IS NULL THEN

           BEGIN
                SELECT ' File' INTO v_suffix FROM dual WHERE v_obj_fle_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
           EXCEPTION WHEN OTHERS THEN
            
                         v_suffix := '';
      
           END;
     
         END IF;
   
         --- Make sure we don't say "Security Polygrpah File File" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-4,5) = ' File' THEN
     
           v_suffix := '';
     
         END IF;

         --- Make sure we don't say "Agent Application Activity - Education Activity Activity" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-8,9) = ' Activity' THEN
     
           v_suffix := '';
     
         END IF;
   
         IF v_type_code = 'EVIDENCE' THEN
           
           BEGIN
                SELECT SUBSTR(DESCRIPTION,1,50),TO_CHAR(OBTAINED_DATE,'dd-Mon-yyyy'),STATUS,TAG_NUMBER,OBTAINED_BY
                      INTO v_type_descr,v_create_on,v_status,v_tag,v_obtained_by FROM v_osi_evidence WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
              
                    RETURN '';
     
           END;

           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || ' <small>Description</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_create_on || ' <small>Obtained on</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_tag || ' <small>Tag #</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_obtained_by || ' <small>Obtained By</small></li>' || CHR(10) || CHR(13);

         ELSIF v_type_code = 'PERSONNEL' THEN
           
              BEGIN
                   SELECT DECODE(PERSONNEL_STATUS,'CL','Closed','OP','Open','SU','Suspended','Unknown'),TO_CHAR(STATUS_DATE,'dd-Mon-yyyy'),PERSONNEL_NAME,UNIT_NAME
                         INTO v_type_descr,v_create_on,v_personnel_name,v_unit_name FROM v_osi_personnel WHERE SID=p_obj_sid;
     
              EXCEPTION WHEN OTHERS THEN
              
                       RETURN '';
     
              END;  
      
              v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
              v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Status: ' || v_type_descr || ' <small>Status</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Effective: ' || v_create_on || ' <small>Effective</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Agent: ' || v_personnel_name || ' <small>Agent Name</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Unit: ' || v_unit_name || ' <small>Assigned To</small></li>' || CHR(10) || CHR(13);

         ELSE
  
           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || v_suffix || ' <small>Object Type</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Created on ' || v_create_on || ' <small>Create Date</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Status is ' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
     
           IF v_type_code = 'PART.INDIV' THEN
             
             BEGIN
                  SELECT COUNT(*),Osi_Util.parse_size(SUM(DBMS_LOB.GETLENGTH(CONTENT))) INTO v_photo_count,v_photo_size FROM T_OSI_ATTACHMENT A,T_OSI_ATTACHMENT_TYPE T WHERE A.TYPE=T.SID AND T.USAGE='MUGSHOT' AND A.OBJ=p_obj_sid;

                  IF v_photo_count = '1' THEN
        
                    v_photo_count := v_photo_count || ' Photo';
      
                  ELSE

                    v_photo_count := v_photo_count || ' Photos';
         
                  END IF;
            
             EXCEPTION WHEN OTHERS THEN
    
                      v_photo_count := '0';
                      v_photo_size := '0 KB';
    
             END;
             
             BEGIN
                  SELECT SID INTO v_photo_tab_sid FROM T_OSI_TAB WHERE tab_label='Photo/Image';

             EXCEPTION WHEN OTHERS THEN

                      v_photo_tab_sid := '2220000077I';

             END;
    
             v_return := v_return || '  <li><a href=javascript:goToTab(''' || v_photo_tab_sid || '''); return false;>' || v_photo_count || '/' || v_photo_size || '</a> <small>Photos/Size</small></li>' || CHR(10) || CHR(13);

             BEGIN
                  SELECT max(DEERS_DATE) INTO v_deers_date FROM T_OSI_PARTICIPANT_HUMAN H,T_OSI_PARTICIPANT_VERSION V WHERE V.PARTICIPANT=p_obj_sid AND V.SID=H.SID;

                  if v_deers_date is null then
                    
                    v_deers_date_string := 'Never';

                  else

                    v_deers_date_string := to_char(v_deers_date,'dd-Mon-YYYY HH:MI:SS PM');
                  
                  end if;
                  
             EXCEPTION WHEN OTHERS THEN

                      v_deers_date := 'Never';

             END;
             v_return := v_return || '  <li>' || v_deers_date_string || '<small>Last DEERS</small></li>' || CHR(10) || CHR(13);
    
           END IF;
     
           v_return := v_return || '  <li>This OBJECT IS Classified:  UNCLASSIFIED <small>Classification</small></li>' || CHR(10) || CHR(13);
     
         END IF;
         
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="minbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="minbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="minbutton" onclick="javascript:hideStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/min.gif" align=bottom><small>Minimize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul">' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="maxbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="maxbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="maxbutton" onclick="javascript:showStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/max.gif" align=bottom><small>Maximize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);
   
         RETURN v_return;
   
    END getStatusBar;
 
END Osi_Object;
/