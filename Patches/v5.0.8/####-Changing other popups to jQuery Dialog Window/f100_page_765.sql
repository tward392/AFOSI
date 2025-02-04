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
--   Date and Time:   08:02 Thursday August 30, 2012
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

PROMPT ...Remove page 765
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>765);
 
end;
/

 
--application/pages/page_00765
prompt  ...PAGE 765: Classify
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 765,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Classify',
  p_step_title=> 'Classify',
  p_html_page_onload=>'onload="javascript:ClassificationPreview();"',
  p_step_sub_title => 'Classify',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_welcome_text=> '<script language="JavaScript" type="text/javascript">'||chr(10)||
'if(''&P765_DONE.'' == ''Y'')'||chr(10)||
'  {'||chr(10)||
'   window.parent.location.reload(true);'||chr(10)||
'   closeDialog();'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'function ClassificationPreview()'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                           $v(''pFlowId''),'||chr(10)||
'                           ''APPLICATION_PROCESS=CLASSIFICATIONPREVIEW'','||chr(10)||
'                           $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',$v(''P765_CLASSIFICATION'')); '||chr(10)||
' get.addParam(''x02'',$v(''P765_DISSEMINATION''));     '||chr(10)||
' get.addParam(''x03'',$v(''P765_RELEASE_TO''));     '||chr(10)||
' '||chr(10)||
' gReturn = get.get();'||chr(10)||
' $s(''P765_PREVIEW'',gReturn);'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120830080255',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '30-Aug-2012 - Tim Ward - Made this a jQuery Dialog instead of browser pop-up.');
 
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
  p_id=> 8362305733907974 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 765,
  p_plug_name=> 'Classify',
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
  p_id             => 8362500335907982 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 765,
  p_button_sequence=> 10,
  p_button_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P765_SID is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8362726574907984 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 765,
  p_button_sequence=> 15,
  p_button_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P765_SID is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8362921708907984 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 765,
  p_button_sequence=> 20,
  p_button_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_cattributes=>'onClick="javascript:closeDialog();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>8365008500907994 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_branch_action=> 'f?p=&APP_ID.:765:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-OCT-2010 11:00 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8363107852907984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_CLASSIFICATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Classification:',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select description d, sid r'||chr(10)||
'  from t_core_classification_level'||chr(10)||
'   where active=''Y'' order by weight',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Classification Type -',
  p_lov_null_value=> '~~~',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%"',
  p_tag_attributes2=> 'style="width:100%"',
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
  p_id=>8363312271907987 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P765_SID',
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
  p_id=>8363707750907987 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P765_OBJ',
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
  p_id=>8365416546937012 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_PREVIEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
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
  p_cattributes_element=>'style="width:100%;"',
  p_tag_attributes  => 'style="width:100%; height:85px;" readonly="readonly"',
  p_tag_attributes2=> 'style="width:100%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 3,
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
  p_id=>8366900541027015 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_DISSEMINATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Dissemination<br>Controls:',
  p_pre_element_text=>'<div class="scrollChecklist" style="height:175px;">',
  p_post_element_text=>'</div>',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => '&P765_DISS_SELECT.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_tag_attributes  => 'onclick="javascript:ClassificationPreview();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P765_CLASSIFICATION is not null and'||chr(10)||
':P765_CLASSIFICATION not in (''~~~'') and'||chr(10)||
'length(:P765_CLASSIFICATION) <> 0',
  p_display_when_type=>'SQL_EXPRESSION',
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
  p_id=>8368306260066509 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_RELEASE_TO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Release To:',
  p_pre_element_text=>'<div class="scrollChecklist" style="height:175px;">',
  p_post_element_text=>'</div>',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'select description display_value, sid return_value '||chr(10)||
'from t_core_classification_rt_dest'||chr(10)||
'where code <> ''USA'' order by seq, code',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_tag_attributes  => 'onclick="javascript:ClassificationPreview();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P765_RELEASE_TO_VISIBLE',
  p_display_when2=>'Y',
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
  p_id=>8370115252392966 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_DISS_SELECT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Diss Select',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%"',
  p_tag_attributes2=> 'style="width:100%"',
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
  p_id=>8395728495727975 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_RELEASE_TO_VISIBLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Release To Visible',
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
  p_id=>8398314165064438 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_CLASSIFICATION_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Classification Code',
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
  p_id=>8718118346461282 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P765_DONE',
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
  p_id=>8784624237937682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 765,
  p_name=>'P765_CONTEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 8362305733907974+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Context',
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'if :P765_CLASSIFICATION is null or :P765_CLASSIFICATION='''' or :P765_CLASSIFICATION=''~~~'' then'||chr(10)||
'  '||chr(10)||
'  :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'  :P765_CLASSIFICATION_CODE:=NULL;'||chr(10)||
''||chr(10)||
'else'||chr(10)||
'  '||chr(10)||
'  begin'||chr(10)||
'       select RT_ALLOWED,CODE INTO :P765_RELEASE_TO_VISIBLE,:P765_CLASSIFICATION_CODE '||chr(10)||
'             from t_core_classification_level where sid=:P765_CLASSIFICATION;'||chr(10)||
''||chr(10)||
'  exception when others then'||chr(10)||
'           '||chr(10)||
'         ';

p:=p||'  :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'           :P765_CLASSIFICATION_CODE := ''U'';'||chr(10)||
''||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
':P765_DISS_SELECT := ''select t.description display_value, t.sid return_value '' ||'||chr(10)||
'                     ''        from t_core_classification_hi_type t,'' ||'||chr(10)||
'                     ''             t_core_classification_level_hi h,'' ||'||chr(10)||
'                     ''             t_core_classification_level l'' ||'||chr(10)||
'      ';

p:=p||'               ''          where t.sid=h.hi '' ||'||chr(10)||
'                     ''            and l.sid=h.lvl '' ||'||chr(10)||
'                     ''            and l.code='' || '''''''' || :P765_CLASSIFICATION_CODE || '''''''' ||'||chr(10)||
'                     ''               order by t.seq, t.description'';';

wwv_flow_api.create_page_process(
  p_id     => 8481122888596860 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Classification Picked',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P765_CLASSIFICATION',
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
p:=p||'if :p765_sid is not null then'||chr(10)||
''||chr(10)||
'  delete from t_core_classification_hi where marking=:p765_sid;'||chr(10)||
'  delete from t_core_classification_rt where marking=:p765_sid;'||chr(10)||
'  commit;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P765_CLASSIFICATION is not null and'||chr(10)||
'   :P765_CLASSIFICATION not in (''~~~'') and'||chr(10)||
'   length(:P765_CLASSIFICATION) <> 0 then'||chr(10)||
''||chr(10)||
'  if :REQUEST in (''SAVE'') then'||chr(10)||
'    '||chr(10)||
'    update t_core_classification set class_level=:p765_clas';

p:=p||'sification'||chr(10)||
'      where sid=:p765_sid;'||chr(10)||
'    commit;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    insert into t_core_classification  '||chr(10)||
'           (obj,obj_context,class_level,hi_applies,rt_applies) '||chr(10)||
'    values (:p765_obj,:p765_context,:p765_classification,''N'',''N'') returning sid into :p765_sid;'||chr(10)||
'    commit;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if length(nvl(:P765_DISSEMINATION,'''')) > 0 then'||chr(10)||
''||chr(10)||
'    for i in (select column_value from table(split(:P765_DISSEMINA';

p:=p||'TION,'':'')) '||chr(10)||
'                    where column_value is not null)'||chr(10)||
'    loop'||chr(10)||
'       '||chr(10)||
'        insert into t_core_classification_hi (marking,hi) values'||chr(10)||
'         (:p765_sid,i.column_value);'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
'    update t_core_classification set hi_applies=''Y'' where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    update t_core_classification set hi_applies=''N'' where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if length(nvl(:P765_RELEASE_TO,''''';

p:=p||')) > 0 then'||chr(10)||
''||chr(10)||
'    for i in (select column_value from table(split(:P765_RELEASE_TO,'':''))'||chr(10)||
'                    where column_value is not null)'||chr(10)||
'    loop'||chr(10)||
'        insert into t_core_classification_rt (marking,rt) values'||chr(10)||
'         (:p765_sid,i.column_value);'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    update t_core_classification set rt_applies=''Y'' where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    update t_core_classification set rt_applies=''N'' ';

p:=p||'where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'else'||chr(10)||
''||chr(10)||
'  delete from t_core_classification where sid=:p765_sid;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
'commit;';

wwv_flow_api.create_page_process(
  p_id     => 8400918639188714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Save',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Error Saving Classification',
  p_process_when=>':REQUEST in (''SAVE'',''CREATE'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'Classification saved.',
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
'    :p765_done := ''Y'';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8717807956458298 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set DONE Flag',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''SAVE'',''CREATE'')',
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
'     if :p765_context is null or :p765_context='''' then'||chr(10)||
''||chr(10)||
'       select sid,class_level into :p765_sid, :p765_classification '||chr(10)||
'          from t_core_classification where obj=:p765_obj and (obj_context is null '||chr(10)||
'                                                           or obj_context='''');'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       select sid,class_level into :p765_sid, :p765_classification '||chr(10)||
'          from t_core_classi';

p:=p||'fication where obj=:p765_obj and obj_context=:p765_context;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'  :P767_SID := NULL;'||chr(10)||
'  :P767_CLASSIFICATION := NULL;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
''||chr(10)||
'if :P765_CLASSIFICATION is null or :P765_CLASSIFICATION='''' or :P765_CLASSIFICATION=''~~~'' then'||chr(10)||
'  '||chr(10)||
'  :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'  :P765_CLASSIFICATION_CODE:=NULL;'||chr(10)||
'  :P765_DISSEMINATE:=NULL;'||chr(10)||
'  :P765_RELEASE_TO:=NULL;'||chr(10)||
''||chr(10)||
'else'||chr(10)||
'  '||chr(10)||
'  begin'||chr(10)||
'';

p:=p||'       select RT_ALLOWED,CODE INTO :P765_RELEASE_TO_VISIBLE,:P765_CLASSIFICATION_CODE '||chr(10)||
'             from t_core_classification_level where sid=:P765_CLASSIFICATION;'||chr(10)||
''||chr(10)||
'  exception when others then'||chr(10)||
'           '||chr(10)||
'           :P765_RELEASE_TO_VISIBLE := ''N'';'||chr(10)||
'           :P765_CLASSIFICATION_CODE := ''U'';'||chr(10)||
''||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
':P765_DISS_SELECT := ''select t.description display_value, t.sid return_value '' ||'||chr(10)||
'    ';

p:=p||'                 ''        from t_core_classification_hi_type t,'' ||'||chr(10)||
'                     ''             t_core_classification_level_hi h,'' ||'||chr(10)||
'                     ''             t_core_classification_level l'' ||'||chr(10)||
'                     ''          where t.sid=h.hi '' ||'||chr(10)||
'                     ''            and l.sid=h.lvl '' ||'||chr(10)||
'                     ''            and l.code='' || '''''''' || :P765_CLASSIFICATION_CO';

p:=p||'DE || '''''''' ||'||chr(10)||
'                     ''               order by t.seq, t.description'';'||chr(10)||
''||chr(10)||
':P765_DISSEMINATION := '''';'||chr(10)||
'for d in (select * from t_core_classification_hi where marking=:P765_SID)'||chr(10)||
'loop'||chr(10)||
'    :P765_DISSEMINATION := :P765_DISSEMINATION || d.hi || '':'';'||chr(10)||
' '||chr(10)||
'end loop;'||chr(10)||
''||chr(10)||
':P765_RELEASE_TO := '''';'||chr(10)||
'for d in (select * from t_core_classification_rt where marking=:P765_SID)'||chr(10)||
'loop'||chr(10)||
'    :P765_RELEASE_TO := :P765_R';

p:=p||'ELEASE_TO || d.rt || '':'';'||chr(10)||
' '||chr(10)||
'end loop;';

wwv_flow_api.create_page_process(
  p_id     => 8401605535289065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 765,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_BOX_BODY',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Load',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CLASSIFICATION',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'select DESCRIPTION display_value, CODE return_value '||chr(10)||
'      from T_CORE_CLASSIFICATION_HI_TYPE '||chr(10)||
'          order by SEQ, DESCRIPTION');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 765
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
