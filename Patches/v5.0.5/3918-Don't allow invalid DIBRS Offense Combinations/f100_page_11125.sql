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
--   Date and Time:   07:33 Tuesday November 8, 2011
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

PROMPT ...Remove page 11125
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>11125);
 
end;
/

 
--application/pages/page_11125
prompt  ...PAGE 11125: Specification Details
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript" type="text/javascript">'||chr(10)||
' if ("&REQUEST."=="DONE")'||chr(10)||
'  {'||chr(10)||
'   opener.doSubmit(''EDIT_&P11125_SEL_SPECIFICATION.'');'||chr(10)||
'   close();'||chr(10)||
'  }'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 11125,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Specification Details',
  p_step_title=> 'Specification for &P0_OBJ_TAGLINE.',
  p_step_sub_title => 'Specifications',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817023621004643+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111107135338',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-Nov-2011 - Tim Ward - CR#3918 - Don''t allow invalid offense combinations.'||chr(10)||
'                                    Changed AutoFill (there was a hard-coded'||chr(10)||
'                                    sid in the offense select).'||chr(10)||
'                                    Added "Check for Valid DIBRS Offense" '||chr(10)||
'                                    and "Check for Duplicate Specification"');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>11125,p_text=>ph);
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
  p_id=> 94019914438382751 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11125,
  p_plug_name=> 'Specification Details',
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
  p_id=> 96332620513938137 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11125,
  p_plug_name=> 'Hidden',
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
  p_plug_display_condition_type => 'NEVER',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 94020120656382753 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 10,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11125_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96318733214733668 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 40,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11125_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96532236521610932 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 30,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> 'P11125_SEL_SPECIFICATION',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 94020327857382753 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11125,
  p_button_sequence=> 20,
  p_button_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
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
  p_id=>96429320859356164 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_branch_action=> 'f?p=&APP_ID.:11125:&SESSION.:DONE:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_IN_CONDITION',
  p_branch_condition=> 'SAVE,CREATE,DELETE',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 30-JUL-2009 09:29 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96334017312956174 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_SEL_SPECIFICATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 96332620513938137+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Selected Specification',
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
  p_label_alignment  => 'LEFT',
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
  p_id=>96341108103038674 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_INCIDENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Incident',
  p_source=>'INCIDENT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select i.incident_id d, i.sid r'||chr(10)||
'  from t_osi_f_inv_incident i,'||chr(10)||
'       t_osi_f_inv_incident_map im'||chr(10)||
' where im.investigation = :P0_OBJ'||chr(10)||
'   and im.incident = i.sid'||chr(10)||
' order by i.incident_id',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Incident -',
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
  p_id=>96341418277051068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_OFFENSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Offense',
  p_source=>'OFFENSE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select distinct o.description, o.sid'||chr(10)||
'  from t_dibrs_offense_type o,'||chr(10)||
'       t_osi_f_inv_offense io'||chr(10)||
' where io.investigation = :p0_obj'||chr(10)||
'   and io.offense = o.sid',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Offense -',
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
  p_id=>96341636200075087 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_SUBJECT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Subject',
  p_source=>'SUBJECT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select core_obj.get_tagline(pi.participant_version) disp, '||chr(10)||
'       pi.participant_version retn'||chr(10)||
'  from t_osi_partic_involvement pi,'||chr(10)||
'       t_osi_partic_role_type rt'||chr(10)||
' where pi.obj = :p0_obj'||chr(10)||
'   and pi.involvement_role = rt.sid'||chr(10)||
'   and rt.usage = ''SUBJECT'''||chr(10)||
' order by core_obj.get_tagline(pi.participant_version)',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Subject -',
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
  p_id=>96341817631079240 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_VICTIM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Victim',
  p_source=>'VICTIM',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select core_obj.get_tagline(pi.participant_version) disp, '||chr(10)||
'       pi.participant_version retn'||chr(10)||
'  from t_osi_partic_involvement pi,'||chr(10)||
'       t_osi_partic_role_type rt'||chr(10)||
' where pi.obj = :p0_obj'||chr(10)||
'   and pi.involvement_role = rt.sid'||chr(10)||
'   and rt.usage = ''VICTIM'''||chr(10)||
' order by core_obj.get_tagline(pi.participant_version)',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Victim -',
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
  p_id=>96342807026085639 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_name=>'P11125_INVESTIGATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 94019914438382751+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => ':P0_OBJ',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_source=>'INVESTIGATION',
  p_source_type=> 'DB_COLUMN',
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

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 15949230625097714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11125,
  p_computation_sequence => 10,
  p_computation_item=> 'P11125_INCIDENT',
  p_computation_point=> 'AFTER_HEADER',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'SELECT SID FROM (select i.Sid'||chr(10)||
'  from t_osi_f_inv_incident i,'||chr(10)||
'       t_osi_f_inv_incident_map im'||chr(10)||
' where im.investigation = :P0_OBJ'||chr(10)||
'   and im.incident = i.sid'||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1',
  p_compute_when => '',
  p_compute_when_type=>'NEVER');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342028020082243 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_INCIDENT Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P11125_INCIDENT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Incident must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341108103038674 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342207435082245 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_OFFENSE Not Null',
  p_validation_sequence=> 2,
  p_validation => 'P11125_OFFENSE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Offense must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341418277051068 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342413868082245 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_SUBJECT Not Null',
  p_validation_sequence=> 3,
  p_validation => 'P11125_SUBJECT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Subject must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341636200075087 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96342632472082245 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'P11125_VICTIM Not Null',
  p_validation_sequence=> 4,
  p_validation => 'P11125_VICTIM',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Victim must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96341817631079240 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 29-JUL-2009 16:03');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8757324793983937 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'Check for Valid DIBRS Offense Combination',
  p_validation_sequence=> 40,
  p_validation => 'declare'||chr(10)||
'  '||chr(10)||
'  p_offense varchar2(4000);'||chr(10)||
'  p_nibrs_code varchar2(4000);'||chr(10)||
'  p_complete varchar2(4000);'||chr(10)||
'  p_msg varchar2(4000); '||chr(10)||
'  v_count number := 0;'||chr(10)||
'  '||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'     begin  '||chr(10)||
'          select code, nibrs_code into p_offense, p_nibrs_code'||chr(10)||
'             from t_dibrs_offense_type where sid=:P11125_OFFENSE;'||chr(10)||
''||chr(10)||
'     exception when others then'||chr(10)||
''||chr(10)||
'              return '''';'||chr(10)||
''||chr(10)||
'     end;'||chr(10)||
''||chr(10)||
'     osi_checklist.check_offense_combos(:P0_OBJ, '||chr(10)||
'                                        p_nibrs_code, '||chr(10)||
'                                        :P11125_INCIDENT, '||chr(10)||
'                                        :P11125_VICTIM, '||chr(10)||
'                                        p_offense, '||chr(10)||
'                                        p_complete, '||chr(10)||
'                                        p_msg, '||chr(10)||
'                                        v_count);'||chr(10)||
''||chr(10)||
'     return p_msg;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Error',
  p_validation_condition=> ':request in (''SAVE'',''CREATE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8758920356162488 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_validation_name => 'Check for Duplicate Specification',
  p_validation_sequence=> 50,
  p_validation => 'declare'||chr(10)||
'     v_count number := 0;'||chr(10)||
'begin'||chr(10)||
'     select count(*) into v_count'||chr(10)||
'       from T_OSI_F_INV_SPEC'||chr(10)||
'      where investigation=:p0_obj'||chr(10)||
'        and offense=:P11125_OFFENSE'||chr(10)||
'        and incident=:P11125_INCIDENT'||chr(10)||
'        and subject=:P11125_SUBJECT'||chr(10)||
'        and victim=:P11125_VICTIM;'||chr(10)||
''||chr(10)||
'  if v_count > 0 then'||chr(10)||
'    '||chr(10)||
'    return ''Duplicate specifications are not allowed'';'||chr(10)||
'  '||chr(10)||
'  else'||chr(10)||
'  '||chr(10)||
'    return '''';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Error',
  p_validation_condition=> ':request in (''SAVE'',''CREATE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
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
'  v_list varchar2(2000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     osi_investigation.auto_load_specs(:P0_OBJ, v_list, ''Y'');'||chr(10)||
'wwv_flow.debug(''v_list='' || v_list);'||chr(10)||
'     :P11125_INCIDENT := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
'     :P11125_OFFENSE := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
'     :P11125_SUBJECT := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
'     :P11125_VICTIM := core_list.POP_LIST_ITEM(v_list);'||chr(10)||
' '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 15961123231161840 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Auto Fill',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11125_SEL_SPECIFICATION',
  p_process_when_type=>'ITEM_IS_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'Declare'||chr(10)||
''||chr(10)||
'    v_inc_not_used varchar(20);'||chr(10)||
'    v_off_not_used varchar(20);'||chr(10)||
'    v_sub_not_used varchar(20);'||chr(10)||
'    v_vic_not_used varchar(20);'||chr(10)||
'    v_newest_inc varchar(20);'||chr(10)||
'    v_newest_off varchar(20);'||chr(10)||
'    v_newest_sub varchar(20);'||chr(10)||
'    v_newest_vic varchar(20);'||chr(10)||
''||chr(10)||
'Begin'||chr(10)||
''||chr(10)||
'--Select details not already on a spec '||chr(10)||
''||chr(10)||
'--Incidents'||chr(10)||
'  Begin'||chr(10)||
'   select incident into v_inc_not_used from('||chr(10)||
'    select im.incident     '||chr(10)||
'     from t_osi_f_inv_incident_map im, t_osi_f_inv_spec s'||chr(10)||
'    where im.investigation = :P0_OBJ'||chr(10)||
'     and s.incident(+) = im.incident'||chr(10)||
'     and s.incident is null'||chr(10)||
'    order by im.sid desc)'||chr(10)||
'   where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_inc_not_used := null;'||chr(10)||
'  end;'||chr(10)||
' '||chr(10)||
'--Offenses'||chr(10)||
'  Begin'||chr(10)||
'   SELECT offense into v_off_not_used from '||chr(10)||
'    (select o.offense'||chr(10)||
'       from t_osi_f_inv_offense o, t_osi_f_inv_spec s'||chr(10)||
'      where o.investigation = :P0_OBJ'||chr(10)||
'       and s.investigation(+) = o.investigation'||chr(10)||
'       and s.offense(+) = o.offense'||chr(10)||
'       and s.offense is null'||chr(10)||
'      order by o.sid desc)'||chr(10)||
'    where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_off_not_used := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'--Subjects'||chr(10)||
'  Begin'||chr(10)||
''||chr(10)||
'  select participant_version into v_sub_not_used from '||chr(10)||
'    (select i.participant_version'||chr(10)||
'      from t_osi_partic_involvement i, t_osi_partic_role_type rt, t_osi_f_inv_spec s'||chr(10)||
'     where i.obj = :P0_OBJ'||chr(10)||
'      and i.involvement_role = rt.sid'||chr(10)||
'      and i.obj = s.investigation(+)'||chr(10)||
'      and rt.role = ''Subject'''||chr(10)||
'      and s.subject is null'||chr(10)||
'     order by i.sid desc)'||chr(10)||
'    where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_sub_not_used := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'--Victims'||chr(10)||
'  Begin'||chr(10)||
'   select participant_version into v_vic_not_used from('||chr(10)||
'     select i.participant_version'||chr(10)||
'      from t_osi_partic_involvement i, t_osi_partic_role_type rt, t_osi_f_inv_spec s'||chr(10)||
'     where i.obj = :P0_OBJ'||chr(10)||
'      and i.involvement_role = rt.sid'||chr(10)||
'      and i.obj = s.investigation(+)'||chr(10)||
'      and rt.role = ''Victim'''||chr(10)||
'      and s.victim is null'||chr(10)||
'     order by i.sid desc)'||chr(10)||
'    where rownum = 1;'||chr(10)||
' '||chr(10)||
'  exception '||chr(10)||
'    when no_data_found then'||chr(10)||
'    v_vic_not_used := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'--Select newest details '||chr(10)||
''||chr(10)||
'SELECT SID into v_newest_inc'||chr(10)||
'FROM (select i.Sid'||chr(10)||
'  from t_osi_f_inv_incident i,'||chr(10)||
'       t_osi_f_inv_incident_map im'||chr(10)||
' where im.investigation = :P0_OBJ'||chr(10)||
'   and im.incident = i.sid'||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
'SELECT offense into v_newest_off'||chr(10)||
'FROM (select o.offense'||chr(10)||
'  from t_osi_f_inv_offense o'||chr(10)||
' where o.investigation = :P0_OBJ'||chr(10)||
'   order by o.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
'SELECT SID into v_newest_sub'||chr(10)||
'FROM (select i.participant_version sid'||chr(10)||
'  from t_osi_partic_involvement i, t_osi_partic_role_type rt'||chr(10)||
' where i.obj = :P0_OBJ'||chr(10)||
'   and i.involvement_role = rt.sid'||chr(10)||
'   and rt.role = ''Subject'''||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
'SELECT SID into v_newest_vic'||chr(10)||
'FROM (select i.participant_version sid'||chr(10)||
'  from t_osi_partic_involvement i, t_osi_partic_role_type rt'||chr(10)||
' where i.obj = :P0_OBJ'||chr(10)||
'   and i.involvement_role = rt.sid'||chr(10)||
'   and rt.role = ''Victim'''||chr(10)||
'   order by i.sid desc)'||chr(10)||
'WHERE ROWNUM = 1;'||chr(10)||
''||chr(10)||
''||chr(10)||
'  --Display details not already on spec. If none exist, display newest details'||chr(10)||
''||chr(10)||
'  if v_inc_not_used is not null then'||chr(10)||
'      :P11125_INCIDENT := v_inc_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_INCIDENT := v_newest_inc;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if v_off_not_used is not null then'||chr(10)||
'      :P11125_OFFENSE := v_off_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_OFFENSE := v_newest_off;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if v_sub_not_used is not null then'||chr(10)||
'      :P11125_SUBJECT := v_sub_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_SUBJECT := v_newest_sub;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if v_vic_not_used is not null then'||chr(10)||
'      :P11125_VICTIM := v_vic_not_used;'||chr(10)||
' '||chr(10)||
'  else '||chr(10)||
'      :P11125_VICTIM := v_newest_vic;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;');
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
p:=p||'#OWNER#:T_OSI_F_INV_SPEC:P11125_SEL_SPECIFICATION:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 96334708785963131 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE,CREATE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P11125_SEL_SPECIFICATION',
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
p:=p||'P11125_SEL_SPECIFICATION';

wwv_flow_api.create_page_process(
  p_id     => 96556830184826720 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>96532236521610932 + wwv_flow_api.g_id_offset,
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
p:=p||'CLOSE_WINDOW';

wwv_flow_api.create_page_process(
  p_id     => 96551213299802912 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLOSE_WINDOW',
  p_process_name=> 'Close Window',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>94020327857382753 + wwv_flow_api.g_id_offset,
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
p:=p||'F|#OWNER#:T_OSI_F_INV_SPEC:P11125_SEL_SPECIFICATION:SID';

wwv_flow_api.create_page_process(
  p_id     => 96332918220946962 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11125,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Specification',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11125_SEL_SPECIFICATION',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 11125
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
