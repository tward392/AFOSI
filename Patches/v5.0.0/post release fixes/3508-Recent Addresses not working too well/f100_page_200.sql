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
--   Date and Time:   12:35 Monday February 7, 2011
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

PROMPT ...Remove page 200
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>200);
 
end;
/

 
--application/pages/page_00200
prompt  ...PAGE 200: Address Widget
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
'    if ("&REQUEST."=="OK"){'||chr(10)||
'         window.top.document.getElementById("&P200_RETURN_ITEM.").value = '||chr(10)||
'            "&P200_ADDRESS_FIELDS.";'||chr(10)||
'         window.top.doSubmit("ADDRESS");'||chr(10)||
'  }'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 200,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Address Widget',
  p_step_title=> 'Address Widget',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110207120424',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>200,p_text=>ph);
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
  p_id=> 89907920507171809 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 200,
  p_plug_name=> 'Address',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
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
  p_id=> 89911418046218499 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 200,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_HEADER',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89908117175180314 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 200,
  p_button_sequence=> 10,
  p_button_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_button_name    => 'OK',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_OK.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90234736929368368 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 200,
  p_button_sequence=> 30,
  p_button_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Clear',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P200_ADDRESS_FIELDS',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89908335183185596 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 200,
  p_button_sequence=> 20,
  p_button_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.top.hidePopWin(false);',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>90235523124392821 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_branch_action=> 'f?p=&APP_ID.:200:&SESSION.:OK:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>90234736929368368+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 5,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 09:29 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>89914816857407356 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_branch_action=> 'f?p=&APP_ID.:200:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-MAY-2009 16:24 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3804631261138634 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_RECENT_ADDRESS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9.5,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Recent',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'SELECT'||chr(10)||
'DISTINCT'||chr(10)||
'       (CASE  '||chr(10)||
'           WHEN LENGTH (single_line) > 40'||chr(10)||
'           THEN'||chr(10)||
'              SUBSTR (single_line, 1, 40)'||chr(10)||
'              || ''...'''||chr(10)||
'           ELSE'||chr(10)||
'              single_line'||chr(10)||
'        END)'||chr(10)||
'          addr_display,'||chr(10)||
'        fields'||chr(10)||
'  FROM v_osi_address'||chr(10)||
' WHERE obj IN (SELECT * FROM table(OSI_ADDRESS.ADDRESS_WIDGET_OBJS(:P0_OBJ,:USER_SID,:P200_INCLUDE_SIDS)))'||chr(10)||
' and single_line is not null'||chr(10)||
'order by addr_display'||chr(10)||
'',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'-- Select an Address --',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'SELECT DISTINCT'||chr(10)||
'       (CASE'||chr(10)||
'           WHEN LENGTH (osi_address.get_addr_display (sid, ''SID'', '' '')) > 40'||chr(10)||
'           THEN'||chr(10)||
'              SUBSTR (osi_address.get_addr_display (sid, ''SID'', '' ''), 1, 40)'||chr(10)||
'              || ''...'''||chr(10)||
'           ELSE'||chr(10)||
'              osi_address.get_addr_display (sid, ''SID'', '' '')'||chr(10)||
'        END)'||chr(10)||
'          addr_display,'||chr(10)||
'       osi_address.get_addr_fields (sid) fields'||chr(10)||
'  FROM t_osi_address'||chr(10)||
' WHERE obj IN (SELECT * FROM table(OSI_ADDRESS.ADDRESS_WIDGET_OBJS(:P0_OBJ,:USER_SID,:P200_INCLUDE_SID)))'||chr(10)||
'ORDER BY addr_display');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3901801698183321 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_INCLUDE_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5.5,
  p_item_plug_id => 89911418046218499+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P200_INCLUDE_SIDS',
  p_source_type=> 'STATIC',
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
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89909706421215379 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_ADDRESS_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Address 2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 100,
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
  p_id=>89909925179215379 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_CITY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'City',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 100,
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
  p_id=>89910131944215379 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_STATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'State',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P200_STATE_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select State -',
  p_lov_null_value=> '',
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
  p_id=>89910333685215379 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_ZIP',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Zip',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 30,
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
  p_id=>89910523478215381 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_COUNTRY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Country',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P200_COUNTRY_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Country -',
  p_lov_null_value=> '',
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
  p_id=>89910711257215381 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_PROVINCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Province',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 30,
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
  p_id=>89910911117215381 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_GEO_COORDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Geo Coordinates',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 18,
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
  p_id=>89911135866215381 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 89911418046218499+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Return Item',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>89916016950464185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_ADDRESS_FIELDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 89911418046218499+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Address Fields',
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
  p_id=>90013336126760467 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_DISPLAY_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 89911418046218499+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>90051610106492687 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_ADDRESS_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89907920507171809+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Address 1',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 100,
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
  p_id=>94081009343123649 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_COUNTRY_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 89911418046218499+wwv_flow_api.g_id_offset,
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
  p_id=>94082312123200218 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 200,
  p_name=>'P200_STATE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 89911418046218499+wwv_flow_api.g_id_offset,
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'P200_ADDRESS_1,P200_ADDRESS_2,P200_CITY,P200_STATE,P200_COUNTRY,P200_PROVINCE,P200_GEO_COORDS,P200_ZIP';

wwv_flow_api.create_page_process(
  p_id     => 90234908102379060 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 200,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Address Fields (Delete)',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>90234736929368368 + wwv_flow_api.g_id_offset,
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
'   procedure addItem(p_item varchar2) is'||chr(10)||
'      v_result boolean;'||chr(10)||
'   begin'||chr(10)||
'      v_result := core_list.add_item_to_list'||chr(10)||
'                          (p_item, :P200_ADDRESS_FIELDS);'||chr(10)||
'   end addItem;'||chr(10)||
'begin'||chr(10)||
'   :P200_ADDRESS_FIELDS := null;'||chr(10)||
'   addItem(:P200_ADDRESS_1);'||chr(10)||
'   addItem(:P200_ADDRESS_2);'||chr(10)||
'   addItem(:P200_CITY);'||chr(10)||
'   addItem(:P200_STATE);'||chr(10)||
'   addItem(:P200_ZIP);'||chr(10)||
'   addItem(:P200_COUNTRY);'||chr(10)||
'   ';

p:=p||'addItem(:P200_PROVINCE);'||chr(10)||
'   addItem(:P200_GEO_COORDS);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89913438918281253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 200,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Build Address Item',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'OK,DELETE',
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
p:=p||':P200_ADDRESS_FIELDS := :P200_RECENT_ADDRESS;';

wwv_flow_api.create_page_process(
  p_id     => 3805102050196467 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 200,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Recent Address',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST = ''P200_RECENT_ADDRESS'' and :P200_RECENT_ADDRESS is not null',
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
'    v_exclude_non_birth   varchar2(1);'||chr(10)||
'begin'||chr(10)||
'    if (:P200_RETURN_ITEM in (''P30020_LOCATION_VALUE'',''P30405_BIRTH_ADDR_VALUE'')) then'||chr(10)||
'        v_exclude_non_birth := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        v_exclude_non_birth := ''N'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p200_country_lov := dibrs_reference.get_country_lov(:p200_country);'||chr(10)||
'    :p200_state_lov :='||chr(10)||
'        dibrs_reference.get_state_lov(:p200_state, p_exclude_non_birth';

p:=p||'_types => v_exclude_non_birth);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 94081322035193579 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 200,
  p_process_sequence=> 1,
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
p:=p||':P200_ADDRESS_1 := core_list.get_list_element(:P200_ADDRESS_FIELDS,1);'||chr(10)||
':P200_ADDRESS_2 := core_list.get_list_element(:P200_ADDRESS_FIELDS,2);'||chr(10)||
':P200_CITY := core_list.get_list_element(:P200_ADDRESS_FIELDS,3);'||chr(10)||
':P200_STATE := core_list.get_list_element(:P200_ADDRESS_FIELDS,4);'||chr(10)||
':P200_ZIP := core_list.get_list_element(:P200_ADDRESS_FIELDS,5);'||chr(10)||
':P200_COUNTRY := core_list.get_list_element(:P200_ADDRESS_FI';

p:=p||'ELDS,6);'||chr(10)||
':P200_PROVINCE := core_list.get_list_element(:P200_ADDRESS_FIELDS,7);'||chr(10)||
':P200_GEO_COORDS := core_list.get_list_element(:P200_ADDRESS_FIELDS,8);';

wwv_flow_api.create_page_process(
  p_id     => 90021109302216403 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 200,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload Address Fields',
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
-- ...updatable report columns for page 200
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
