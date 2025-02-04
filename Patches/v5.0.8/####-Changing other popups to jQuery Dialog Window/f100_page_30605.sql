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
--   Date and Time:   10:02 Wednesday August 29, 2012
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
'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'"JS_CREATE_PARTIC_WIDGET"'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function deleteEvidence()'||chr(10)||
'{'||chr(10)||
' deleteObj(''&P30605_SID.'',''DELETE_OBJECT'');'||chr(10)||
' window.opener.doSubmit();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'if (''&P30605_REFRESH_PARENT_WINDOW.'' == ''Y'')'||chr(10)||
'  window.opener.doSubmit();'||chr(10)||
''||chr(10)||
'function submitEvidence(objSid,statusChange,statusChangeDesc)'||chr(10)||
'{'||chr(10)||
' runJQueryPopWin(''Submit Evidence to Custodian....'',''P3061';

ph:=ph||'0_STATUS_CHANGE,P30610_EVIDENCE_SID,P30610_STATUS_CHANGE_DESC'',statusChange + '','' + objSid + '','' + statusChangeDesc,''30610'',0,400,''EVID_STAT'');'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function()'||chr(10)||
'{'||chr(10)||
' $("#ID_VLT").remove();'||chr(10)||
'});'||chr(10)||
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
  p_step_template => 179215462100554475+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120829100120',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '06-DEC-2010 J.FARIS - WCHG0000386 - updates to address widget, removed read-only condition from date received (not necessary when SAVE not available).'||chr(10)||
''||chr(10)||
'17-Mar-2011 Tim Ward - CR#3731 - Added deleteEvidence to Javascript Header, changed the delete button to call it and removed the delete process.  Stops the No Data Found Error when Evidence is deleted.'||chr(10)||
''||chr(10)||
'30-Mar-2011 Tim Ward - CR#3778 - User cannot assign an organization as the owner of evidence.'||chr(10)||
''||chr(10)||
'27-Feb-2012 Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.'||chr(10)||
'                                 Added View Icons for Unit and Personnel (in-line with Legacy).'||chr(10)||
''||chr(10)||
'23-Aug-2012 - Tim Ward - Getting rid of JS_POPUP_OBJ_DATA in favor of'||chr(10)||
'                          jQuery Modal Dialog window.'||chr(10)||
''||chr(10)||
'29-Aug-2012 - Tim Ward - Changed browser pop-up to jQuery Dialog.'||chr(10)||
'                         Changed page template to with menus and tab so we can'||chr(10)||
'                          build them menus from the database.');
 
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
  p_source=>'<a href="javascript:openLocator(''301'',''P30605_RFP'',''N'',''&P30605_RFP.'',''OPEN'','''','''',''Choose Participant Received From...'',''PARTICIPANT'',''&P0_OBJ.'');">&ICON_LOCATOR.</a>',
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
  p_item_comment => '<a href="javascript:popupLocator(400,''P30605_RFP'',''N'',''&P30605_RFP.'');">&ICON_LOCATOR.</a>');
 
 
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
  p_source=>'''<a title="View the Selected Participant" href="'' || '||chr(10)||
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
  p_id=>11661030227473695 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_UNIT_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 241,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View the Unit" href="'' || osi_object.get_object_url(:P30605_UNIT_SID) || ''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>':P30605_UNIT_SID is not null',
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
  p_id=>11662317339564576 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30605,
  p_name=>'P30605_RECEIVING_PERSONNEL_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 271,
  p_item_plug_id => 93885234648663201+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View the Selected Personnel" href="'' || osi_object.get_object_url(:P30605_RECEIVING_PERSONNEL_SID) || ''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>':P30605_RECEIVING_PERSONNEL_SID is not null',
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
  p_source=>'<a href="javascript:openLocator(''301'',''P30605_OWNER'',''N'','''',''OPEN'','''','''',''Choose Evidence Owner...'',''PARTICIPANT'',''&P0_OBJ.'');">&ICON_LOCATOR.</a>',
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
  p_item_comment => '<a href="javascript:popupLocator(400,''P30605_OWNER'',''N'','''');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a title="Find Participant"'||chr(10)||
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
  p_source=>'''<a title="View the Selected Participant" href="'' || '||chr(10)||
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
  p_source=>'<a href="javascript:openLocator(''301'',''P30605_SFP'',''N'',''&P30605_SFP.'',''OPEN'','''','''',''Choose Participant Seized From...'',''PARTICIPANT'',''&P0_OBJ.'');">&ICON_LOCATOR.</a>',
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
  p_item_comment => '<a href="javascript:popupLocator(400,''P30605_SFP'',''N'',''&P30605_SFP.'');">&ICON_LOCATOR.</a>');
 
 
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
  p_source=>'''<a title="View the Selected Participant" href="'' || '||chr(10)||
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
  p_source=>'<a href="javascript:openLocator(''301'',''P30605_UNIT_SID'',''N'',''&P30605_UNIT_SID.'',''OPEN'','''','''',''Choose Controlling Unit...'',''UNITS'',''&P0_OBJ.'');">&ICON_LOCATOR.</a>',
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
  p_item_comment => '<a href="javascript:popupLocator(500,''P30605_UNIT_SID'',''N'',''&P30605_UNIT_SID.'');">&ICON_LOCATOR.</a>');
 
 
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
  p_source=>'<a href="javascript:openLocator(''301'',''P30605_RECEIVING_PERSONNEL_SID'',''N'','''',''OPEN'','''','''',''Choose Receiving Personnel...'',''PERSONNEL'',''&P0_OBJ.'');">&ICON_LOCATOR.</a>',
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
  p_item_comment => '<a href="javascript:popupLocator(350,''P30605_RECEIVING_PERSONNEL_SID'',''N'');">&ICON_LOCATOR.</a>');
 
 
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
'    --Get the address for this page (Obtained At)'||chr(10)||
'    --:P30605_OBTAINED_AT_VALUE := osi_util.get_addr_fields(                         osi_object.get_address_sid(:P30605_SID, ''OBTAINED_AT'')';

p:=p||');'||chr(10)||
''||chr(10)||
'    --Get the ODSO Comment'||chr(10)||
'    --This is done through an item level source'||chr(10)||
'    --:P30605_ODSO_COMMENT := :P30605_ODSO_COMMENT_VALUE;'||chr(10)||
''||chr(10)||
'    --Get tag display for existing objects'||chr(10)||
'    :P30605_TAG_NUMBER_DISPLAY := osi_evidence.get_tag_number(:P0_OBJ);'||chr(10)||
''||chr(10)||
'    --Get status description'||chr(10)||
'    :P30605_STATUS_DESC := osi_evidence.lookup_evid_status_desc(osi_evidence.get_status_sid(:P0_OBJ));'||chr(10)||
''||chr(10)||
'    --Handle ';

p:=p||'defaulted items'||chr(10)||
'    if (:request = ''CREATE_OBJ'') then'||chr(10)||
'        :p30605_receiving_personnel_sid := core_context.personnel_sid;'||chr(10)||
'        --:p30605_unit_sid := osi_personnel.get_current_unit(core_context.personnel_sid);'||chr(10)||
'        if :p30605_unit_sid is null then'||chr(10)||
'           :p30605_unit_sid := osi_object.get_assigned_unit(:P30605_OBJ_PARENT);'||chr(10)||
'        end if;'||chr(10)||
'        :p30605_date_received := to_char(osi_ac';

p:=p||'tivity.get_activity_date(:p30605_obj_parent), :FMT_DATE);'||chr(10)||
''||chr(10)||
'        --This value may actually change if 2 people add evidence at the same time.. not sure if we need a better way to do this or not.'||chr(10)||
'        :p30605_evidence_tag :='||chr(10)||
'            osi_object.get_id(:p30605_obj_parent, null) || ''-'''||chr(10)||
'            || osi_evidence.get_next_seq_num(:p30605_obj_parent);'||chr(10)||
''||chr(10)||
'        --Get tag display for existing obj';

p:=p||'ects'||chr(10)||
'        :P30605_TAG_NUMBER_DISPLAY := :p30605_evidence_tag;'||chr(10)||
'        '||chr(10)||
'        --Get last used address'||chr(10)||
'        :P30605_OBTAINED_AT_VALUE := osi_evidence.GET_LAST_ADDRESS(:P30605_OBJ_PARENT);'||chr(10)||
''||chr(10)||
'        --Get status description'||chr(10)||
'        :P30605_STATUS_DESC := osi_evidence.lookup_evid_status_desc(''N'');'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Get RFP/SFP'||chr(10)||
'    if (:request <> ''P30605_RFP'' and :request <> ''P30605_SFP'') then';

p:=p||''||chr(10)||
'        if (:p30605_aquisition_method = ''RFP'') then'||chr(10)||
'            :p30605_rfp := osi_object.get_participant_sid(:p0_obj, ''RFP'');'||chr(10)||
'            :p30605_rfp_original := :p30605_rfp;'||chr(10)||
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
