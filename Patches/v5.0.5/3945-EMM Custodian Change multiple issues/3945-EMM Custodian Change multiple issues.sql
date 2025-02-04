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
--   Date and Time:   08:28 Wednesday September 28, 2011
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

PROMPT ...Remove page 30715
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30715);
 
end;
/

 
--application/pages/page_30715
prompt  ...PAGE 30715: Evidence Transaction Log
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 30715,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Evidence Transaction Log',
  p_step_title=> '&P30715_DESCRIPTION.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110927095619',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '27-Sep-2011 - TJW - CR#3945 - Auto select first transaction.'||chr(10)||
'                              Put Description in Title so they know what '||chr(10)||
'                              evidence the displayed log is for.');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select l.sid,'||chr(10)||
'       l.effective_date "Transaction Date",'||chr(10)||
'       t.description "Transaction Type",'||chr(10)||
'       osi_personnel.get_name(l.custodian_sid) '||chr(10)||
'               "Responsible Custodian",'||chr(10)||
'       decode(l.condition_change, ''Y'', ''Yes'', ''No'') '||chr(10)||
'               "Condition Change?",'||chr(10)||
'       other_party "Other Involved Parties",'||chr(10)||
'       decode(l.sid, :p30715_sel_transaction, ''Y'', ''N'') "Current"'||chr(10)||
'  from t_osi_';

s:=s||'evidence_trans_log l,'||chr(10)||
'       t_osi_reference t'||chr(10)||
' where t.sid = l.tran_type_sid'||chr(10)||
'   and l.evidence_sid = :p30715_evidence'||chr(10)||
' order by l.effective_date, l.create_on, l.sid';

wwv_flow_api.create_report_region (
  p_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30715,
  p_name=> 'Transaction List',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'BEFORE_BOX_BODY',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '1000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No transactions found.',
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
  p_plug_query_exp_filename=> '&P30715_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8816112163401060 + wwv_flow_api.g_id_offset,
  p_region_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
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
  p_id=> 8816222809401065 + wwv_flow_api.g_id_offset,
  p_region_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Transaction Date',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Transaction Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
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
  p_id=> 8816303727401065 + wwv_flow_api.g_id_offset,
  p_region_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Transaction Type',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Transaction Type',
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
  p_id=> 8816424979401065 + wwv_flow_api.g_id_offset,
  p_region_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Responsible Custodian',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Responsible Custodian',
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
  p_id=> 8816503496401065 + wwv_flow_api.g_id_offset,
  p_region_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Condition Change?',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Condition Change?',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'LEFT',
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
  p_id=> 8816611247401065 + wwv_flow_api.g_id_offset,
  p_region_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Other Involved Parties',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Other Involved Parties',
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
  p_id=> 8834309788814668 + wwv_flow_api.g_id_offset,
  p_region_id=> 8815818914401037 + wwv_flow_api.g_id_offset,
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 8817416060419118 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30715,
  p_plug_name=> 'Details of Selected Transaction',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 1000,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'ITEM_IS_NOT_NULL',
  p_plug_display_when_condition => 'P30715_SEL_TRANSACTION',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 16061613449228215 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30715,
  p_button_sequence=> 10,
  p_button_plug_id => 8815818914401037+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this, 30715);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>8827917585504718 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30715,
  p_branch_action=> 'f?p=&APP_ID.:30715:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-JUN-2010 15:54 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7681804910461612 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30715,
  p_name=>'P30715_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 8815818914401037+wwv_flow_api.g_id_offset,
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
  p_id=>8817122508411456 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30715,
  p_name=>'P30715_EVIDENCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8815818914401037+wwv_flow_api.g_id_offset,
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
  p_id=>8817723678421315 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30715,
  p_name=>'P30715_SEL_TRANSACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 8815818914401037+wwv_flow_api.g_id_offset,
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
  p_id=>8818111342427184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30715,
  p_name=>'P30715_PURPOSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 8817416060419118+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Purpose/Comments',
  p_source=>'select purpose from t_osi_evidence_trans_log'||chr(10)||
' where sid = :p30715_sel_transaction',
  p_source_type=> 'QUERY',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
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
  p_id=>16061820721230304 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30715,
  p_name=>'P30715_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 8815818914401037+wwv_flow_api.g_id_offset,
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
p:=p||':P30715_SEL_TRANSACTION := substr(:REQUEST,6);';

wwv_flow_api.create_page_process(
  p_id     => 8818702816434234 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30715,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Transaction',
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
p:=p||'BEGIN'||chr(10)||
'     select description into :P30715_DESCRIPTION from T_OSI_EVIDENCE WHERE SID=:P30715_EVIDENCE;'||chr(10)||
'EXCEPTION WHEN OTHERS THEN'||chr(10)||
'     '||chr(10)||
'    :P30715_DESCRIPTION:= ''Evidence Transaction Log...'';'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 7681529366459147 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30715,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup Window Title',
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
p:=p||'BEGIN'||chr(10)||
'     select min(sid) into :P30715_SEL_TRANSACTION from t_osi_evidence_trans_log '||chr(10)||
'           where evidence_sid=:P30715_EVIDENCE;'||chr(10)||
''||chr(10)||
'EXCEPTION WHEN OTHERS THEN'||chr(10)||
'     '||chr(10)||
'    :P30715_SEL_TRANSACTION:=''NULL'';'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 7682414223511579 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30715,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select first Transaction',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST not like ''EDIT_%''',
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
-- ...updatable report columns for page 30715
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
--   Date and Time:   08:28 Wednesday September 28, 2011
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

PROMPT ...Remove page 30720
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30720);
 
end;
/

 
--application/pages/page_30720
prompt  ...PAGE 30720: Evidence Inventory
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_LOCATOR"'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
'function evTab()'||chr(10)||
'{'||chr(10)||
' var imSure = true;'||chr(10)||
' if (checkDirty())'||chr(10)||
'   {'||chr(10)||
'    var msg = ''Leaving this tab will cause all unsaved changes to be '' +'||chr(10)||
'              ''lost.  '' +'||chr(10)||
'              ''Click Cancel to return to the page and save changes now.'';'||chr(10)||
''||chr(10)||
'    imSure = confirm(msg);'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if (imSure)'||chr(10)||
'   {'||chr(10)||
'    window.location = ''f?p=&APP_ID.:30';

ph:=ph||'700:&SESSION.'' +'||chr(10)||
'                      '':OPEN:NO:30700:P0_OBJ:&P0_OBJ.'';'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function NewAgent()'||chr(10)||
'{'||chr(10)||
' var isDirty=false;'||chr(10)||
''||chr(10)||
' var anchors = document.getElementsByTagName(''a'');'||chr(10)||
' for (var i = 0;i<anchors.length;i++)'||chr(10)||
'     {'||chr(10)||
'      if ((/SAVE/.test(anchors[i].href)) ||'||chr(10)||
'         (/CREATE/.test(anchors[i].href))) '||chr(10)||
'        {'||chr(10)||
'         if(anchors[i].style.color == ''red'')'||chr(10)||
'           isDirty=true;'||chr(10)||
'        }'||chr(10)||
'  ';

ph:=ph||'   }'||chr(10)||
''||chr(10)||
' javascript:popupLocator(350,''NEW_AGENT_INVOLVED_SID'',''N'');'||chr(10)||
''||chr(10)||
' if(isDirty==true)'||chr(10)||
'   setDirty();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function IsEvidenceSelected()'||chr(10)||
'{'||chr(10)||
' var sTot = document.getElementById("TotalSelected");'||chr(10)||
' var eLst = $v(''P30720_CC_EVIDENCE'');'||chr(10)||
''||chr(10)||
' if (eLst.length > 0)'||chr(10)||
'   {'||chr(10)||
'    $s(''P30720_SAVE_BUTTON_NAME'',''Change Custodian on Selected Evidence'');'||chr(10)||
''||chr(10)||
'    if (sTot!=undefined)'||chr(10)||
'      sTot.innerHTML = eLst.split(/:/g).len';

ph:=ph||'gth + " Selected";'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    $s(''P30720_SAVE_BUTTON_NAME'',''Save'');'||chr(10)||
''||chr(10)||
'    if (sTot!=undefined)'||chr(10)||
'      sTot.innerHTML = "0 Selected";'||chr(10)||
''||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' var sBut = document.getElementById("SaveButton");'||chr(10)||
''||chr(10)||
' if (sBut!=undefined)'||chr(10)||
'   sBut.innerHTML = $v(''P30720_SAVE_BUTTON_NAME'');'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ClearSelected()'||chr(10)||
'{'||chr(10)||
' $s(''P30720_CC_EVIDENCE'','''');'||chr(10)||
' IsEvidenceSelected();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function SelectAll()'||chr(10)||
'{'||chr(10)||
' var lst = document';

ph:=ph||'.getElementById("P30720_CC_EVIDENCE");'||chr(10)||
' for(i=0;i<=lst.length-1;i++) '||chr(10)||
'    { '||chr(10)||
'     lst.options[i].selected = true; '||chr(10)||
'    }'||chr(10)||
' IsEvidenceSelected();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30720,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Evidence Inventory',
  p_step_title=> 'Evidence Inventory',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P30720_SEL_INVENTORY.'');"',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'$(window).load(function(){  '||chr(10)||
''||chr(10)||
'  var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
''||chr(10)||
'});'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110928074910',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '1-FEB-2011 J.Faris - Removed Delete button, no ability to delete an inventory in legacy.'||chr(10)||
'21-MAR-2011 J.Faris - CHG0003534 - Added Start Date not null validation and corrected End Date comparison validation.'||chr(10)||
'23-MAR-2011 J.Faris - CHG0003534 - Corrected Start Date RO item to fetch value Always instead of Only when null.'||chr(10)||
''||chr(10)||
'07-Jul-2011 Tim Ward - CR#3888 - Printing Evidence Inventory on inventory.'||chr(10)||
'07-Jul-2011 Tim Ward - CR#3857 - Incorrect Error when changing complete date.'||chr(10)||
'                                 record before it is saved causes an error.'||chr(10)||
'                                 Added a Condition to the print button.'||chr(10)||
'26-Sep-2011 Tim Ward - CR#3945 - Complete reworked this page to make the'||chr(10)||
'                                 custodian change more intuitive.  Users were'||chr(10)||
'                                 changing things they didn''t want to and  not'||chr(10)||
'                                 changing things they wanted to..  Many flaws'||chr(10)||
'                                 in the way the CC was working.'||chr(10)||
''||chr(10)||
'                                 Also added the UP/Down Arrow, Auto Select an'||chr(10)||
'                                 inventory when tab is pressed and make sure '||chr(10)||
'                                 the current selected inventory shows at all '||chr(10)||
'                                 times.'||chr(10)||
''||chr(10)||
'                                 Added "JS_REPORT_AUTO_SCROLL" to '||chr(10)||
'                                 HTML Header.  '||chr(10)||
'                                 Added onkeydown="return checkForUpDownArrows (event, ''&P30700_SEL_EVIDENCE.'');" '||chr(10)||
'                                 to HTML Body Attribute. '||chr(10)||
'                                 Added name=''#SID#'' to "Link Attributes" '||chr(10)||
'                                 of the SID Column of the Report. '||chr(10)||
'                                 Added a new Branch to'||chr(10)||
'                                 "f?p=&APP_ID.:5050:&SESSION.::&DEBUG.:::#&P30700_SEL_EVIDENCE..",'||chr(10)||
'                                 this allows the report to move the the '||chr(10)||
'                                 Anchor of the selected currentrow.'||chr(10)||
'                                 Added Function Call to Footer Text.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30720,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<a href="javascript:void(0);" '||chr(10)||
'   onclick="javascript:evTab();">Evidence List</a>'||chr(10)||
'<a class ="here">Evidence Inventory</a>'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 8928523421346732 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30720,
  p_plug_name=> 'Tabs',
  p_region_name=>'',
  p_plug_template=> 0,
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
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<table width=100% cellpadding=2 cellspacing=2 border=0>'||chr(10)||
'<tr><td nowrap><div class="OSITabLevel">'||chr(10)||
'',
  p_plug_footer=> '</div></td></tr></table>',
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
s:=s||'select i.sid,'||chr(10)||
'       i.start_date,'||chr(10)||
'       i.end_date "Date Completed",'||chr(10)||
'       ir.description "Reason for Inventory",'||chr(10)||
'       decode(i.outgoing_custodian_sid,null,'''',osi_personnel.get_name('||chr(10)||
'            i.outgoing_custodian_sid)) "Outgoing Custodian",'||chr(10)||
'       osi_personnel.get_name('||chr(10)||
'            i.responsible_custodian_sid) "Assuming Custodian",'||chr(10)||
'       decode(i.sid, :p30720_sel_inventory, ''Y'', ''N'') "Cu';

s:=s||'rrent"'||chr(10)||
'  from t_osi_evidence_inventory i,'||chr(10)||
'       t_osi_reference ir'||chr(10)||
' where i.unit_sid = :P0_OBJ'||chr(10)||
'   and i.inventory_reason_sid = ir.sid'||chr(10)||
'   and (ir.code <> ''IGS'' or :p30720_IG = ''Y'')';

wwv_flow_api.create_report_region (
  p_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30720,
  p_name=> 'Inventory List',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_header=> '<table width=100%>'||chr(10)||
'<tr><td width=100%>',
  p_footer=> '</td></tr></table>'||chr(10)||
'',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' -',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No inventory data found.',
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
  p_plug_query_exp_filename=> '&P30720_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8956211676449417 + wwv_flow_api.g_id_offset,
  p_region_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
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
  p_heading_alignment=>'LEFT',
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
  p_id=> 8956305372449420 + wwv_flow_api.g_id_offset,
  p_region_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'START_DATE',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Start Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>1,
  p_default_sort_dir=>'desc',
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
  p_id=> 8956410536449420 + wwv_flow_api.g_id_offset,
  p_region_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Date Completed',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Date Completed',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
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
  p_id=> 8956518839449420 + wwv_flow_api.g_id_offset,
  p_region_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Reason for Inventory',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Reason For Inventory',
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
  p_id=> 8956614766449420 + wwv_flow_api.g_id_offset,
  p_region_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Outgoing Custodian',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Outgoing Custodian',
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
  p_id=> 8956701835449420 + wwv_flow_api.g_id_offset,
  p_region_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Assuming Custodian',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Assuming Custodian',
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
  p_id=> 8957213566457414 + wwv_flow_api.g_id_offset,
  p_region_id=> 8955918629449396 + wwv_flow_api.g_id_offset,
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 8957611619466307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30720,
  p_plug_name=> 'Details of Selected Inventory <font color="red"><i>([shift]+[down]/[up] to navigate evidence inventory)</i></font>',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 10000,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_column_width => 'width=100%',
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P30720_MODE = ''ADD'' or :P30720_SEL_INVENTORY is not null',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<table width=100% id="InventoryDetails" border=0>'||chr(10)||
'<tr><td width=75% nowrap>'||chr(10)||
'',
  p_plug_footer=> '</td><td width=25% nowrap style="border-left: 1px solid #000;" valign=top>',
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
s:=s||'select HTMLDB_ITEM.CHECKBOX (1, sid) "Select",'||chr(10)||
'       osi_object.get_tagline_link(personnel_sid) "Agent"'||chr(10)||
'  from t_osi_evidence_inv_personnel'||chr(10)||
' where inventory_sid = :p30720_sel_inventory';

wwv_flow_api.create_report_region (
  p_id=> 8975727268368400 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30720,
  p_name=> 'Involved Agents',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 40,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> 'P30720_SEL_INVENTORY',
  p_display_condition_type=> 'ITEM_IS_NOT_NULL',
  p_plug_caching=> 'NOT_CACHED',
  p_footer=> '</td></tr></table>',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Involved Agents.',
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
  p_id=> 8976623590376792 + wwv_flow_api.g_id_offset,
  p_region_id=> 8975727268368400 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 1,
  p_column_heading=> '<input id="f00" name="f01" type="checkbox" onclick="$f_CheckFirstColumn(this);">',
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
  p_id=> 8976009853368421 + wwv_flow_api.g_id_offset,
  p_region_id=> 8975727268368400 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Agent',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Agents',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 8977915110412192 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 45,
  p_button_plug_id => 8975727268368400+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE_AGENT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Selected Agent(s)',
  p_button_position=> 'BELOW_BOX',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'declare'||chr(10)||
''||chr(10)||
'  v_cnt number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     select count(*) into v_cnt from t_osi_evidence_inv_personnel where inventory_sid = :p30720_sel_inventory;'||chr(10)||
''||chr(10)||
'     if :P30720_END_DATE is null and v_cnt > 0 then'||chr(10)||
'       '||chr(10)||
'       return true;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return false;'||chr(10)||
''||chr(10)||
'end;',
  p_button_condition_type=> 'FUNCTION_BODY',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8976932378388782 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 50,
  p_button_plug_id => 8975727268368400+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD_AGENT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Agent',
  p_button_position=> 'BELOW_BOX',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:NewAgent();',
  p_button_condition=> 'P30720_END_DATE',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 9058410278312712 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 5,
  p_button_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_button_name    => 'REPORT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Print Evidence Inventory',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:800:&SESSION.::&DEBUG.:800:P800_REPORT_TYPE,P0_OBJ,P800_PARAM_2:&P30720_RPT_TYPE.,&P0_OBJ.,&P30720_SEL_INVENTORY.',
  p_button_condition=> '(:P30720_MODE NOT IN (''ADD'') OR :P30720_MODE IS NULL)'||chr(10)||
'AND '||chr(10)||
':P30720_END_DATE IS NULL',
  p_button_condition_type=> 'SQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8958010711475540 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 10,
  p_button_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Inventory',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6738715361987483 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 10,
  p_button_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P30720_SEL_INVENTORY',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8958631264485895 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 20,
  p_button_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P30720_SAVE_BUTTON_NAME.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30720_SEL_INVENTORY IS NOT NULL AND'||chr(10)||
':P30720_END_DATE_ORIG IS NULL',
  p_button_condition_type=> 'SQL_EXPRESSION',
  p_button_cattributes=>'id="SaveButton"',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16062905053244760 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 70,
  p_button_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this, 30720);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8959004525485896 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30720,
  p_button_sequence=> 40,
  p_button_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
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
  p_id=>7706208521023915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_branch_action=> 'f?p=&APP_ID.:30720:&SESSION.::&DEBUG.:::#&P32700_SEL_INVENTORY.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 5,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> '/*:REQUEST = ''SAVE'' OR*/ :REQUEST LIKE ''EDIT_%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-AUG-2011 10:50 by TWARD');
 
wwv_flow_api.create_page_branch(
  p_id=>8960708558569500 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_branch_action=> 'f?p=&APP_ID.:30720:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 24-JUN-2010 17:05 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6873327713814776 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'NEW_AGENT_INVOLVED_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 8975727268368400+wwv_flow_api.g_id_offset,
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
  p_id=>7680014663218317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_CC_COUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Cc Count',
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
  p_id=>7945216298330518 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_FIRST_INVENTORY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'First Inventory',
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
  p_id=>8123430954893074 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_SAVE_BUTTON_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '&BTN_SAVE.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Save Button Name',
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
  p_id=>8957923393469685 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_SEL_INVENTORY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
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
  p_id=>8959201969491967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_START_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char(sysdate,''dd-Mon-yyyy'')',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Start Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'START_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:50%"',
  p_tag_attributes  => 'class="datepickernew" ',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30720_END_DATE_ORIG',
  p_display_when_type=>'ITEM_IS_NULL',
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
  p_id=>8959414782495590 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_END_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Completed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'END_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:50%"',
  p_tag_attributes  => 'class="datepickernew"',
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
  p_id=>8960330937566571 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_INVENTORY_REASON_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Inventory Reason',
  p_source=>'INVENTORY_REASON_SID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where usage = ''EVIDENCE_INVENTORY_REASON'''||chr(10)||
'   and active = ''Y'''||chr(10)||
'   and (code <> ''IGS'' or :p30720_ig=''Y'')'||chr(10)||
' order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Inventory -',
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
  p_display_when=>'P30720_END_DATE_ORIG',
  p_display_when_type=>'ITEM_IS_NULL',
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
  p_id=>8961628429584773 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
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
  p_id=>8962730291594753 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_IG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
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
  p_id=>8963111506608273 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_INVENTORY_TYPE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'declare'||chr(10)||
'  v_type t_osi_reference.sid%type;'||chr(10)||
'begin'||chr(10)||
'  select sid'||chr(10)||
'    into v_type'||chr(10)||
'    from t_osi_reference'||chr(10)||
'   where usage = ''EVIDENCE_INVENTORY_TYPE'''||chr(10)||
'     and code = ''FULL'';'||chr(10)||
'  return v_type;'||chr(10)||
'end;',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_source=>'INVENTORY_TYPE_SID',
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
  p_id=>8963429861613542 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_INVENTORY_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_prompt=>'Inventory Type',
  p_source=>'select description'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where sid = :p30720_inventory_type_sid',
  p_source_type=> 'QUERY',
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
  p_id=>8963608521616825 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_OUTGOING_CUST_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OUTGOING_CUSTODIAN_SID',
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
  p_id=>8963831030623303 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_OUTGOING_CUST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Outgoing Custodian',
  p_source=>'begin'||chr(10)||
'  if :P30720_OUTGOING_CUST_SID is not null then'||chr(10)||
'      return osi_personnel.get_name(:P30720_OUTGOING_CUST_SID);'||chr(10)||
'  else'||chr(10)||
'      return null;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 45,
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
  p_id=>8964028045631903 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_OUTGOING_CUST_SELECT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(350,''P30720_OUTGOING_CUST_SID'',''N'');">&ICON_LOCATOR.</a>',
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
  p_display_when=>'select 1'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where sid = :p30720_inventory_reason_sid'||chr(10)||
'   and code in (''ACC'',''PCC'')',
  p_display_when_type=>'EXISTS',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8964427137641115 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_RESPONSIBLE_CUST_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'core_context.personnel_sid',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_source=>'RESPONSIBLE_CUSTODIAN_SID',
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
  p_id=>8964609260645453 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_RESPONSIBLE_CUST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Responsible Custodian',
  p_source=>'begin'||chr(10)||
'  if :P30720_RESPONSIBLE_CUST_SID is not null then'||chr(10)||
'      return osi_personnel.get_name(:P30720_RESPONSIBLE_CUST_SID);'||chr(10)||
'  else'||chr(10)||
'      return null;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_id=>8964819649648414 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_COMMENTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Comments',
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
  p_cattributes_element=>'style="width:99%"',
  p_tag_attributes  => 'style="width:99%"',
  p_tag_attributes2=> 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 4,
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
  p_id=>8967715802694618 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => ':P0_OBJ',
  p_item_default_type => 'PLSQL_EXPRESSION',
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
  p_id=>8986424572623085 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_START_DATE_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Start Date',
  p_source=>'select to_char(start_date,:FMT_DATE)'||chr(10)||
'  from t_osi_evidence_inventory'||chr(10)||
' where sid = :p30720_sel_inventory',
  p_source_type=> 'QUERY',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:50%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30720_END_DATE_ORIG',
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
  p_id=>8987110420647468 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_INVENTORY_REASON_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Inventory Reason',
  p_source=>'select ir.description'||chr(10)||
'  from t_osi_evidence_inventory i,'||chr(10)||
'       t_osi_reference ir'||chr(10)||
' where ir.sid = i.inventory_reason_sid'||chr(10)||
'   and i.sid = :p30720_sel_inventory',
  p_source_type=> 'QUERY',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_display_when=>'P30720_END_DATE_ORIG',
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
  p_id=>9058730017318481 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_RPT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
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
  p_id=>9609916245959115 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_CC_EVIDENCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Select Evidence for Custodian Change',
  p_post_element_text=>'<BR><span id="TotalSelected" class="optionallabel" style="float:right;">0 Selected</span><BR>'||chr(10)||
'<a href="javascript:ClearSelected();" class="htmlButton">Clear</a>'||chr(10)||
'<a href="javascript:SelectAll();" class="htmlButton">Select All</a>&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'MULTIPLESELECT',
  p_lov => 'select core_obj.get_tagline(sid) || '' for '' || core_obj.get_tagline(obj) disp, sid'||chr(10)||
'  from v_osi_evidence'||chr(10)||
' where unit_sid = :p0_obj'||chr(10)||
'   and status_code = ''C''',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onclick="javascript:IsEvidenceSelected();" style="width:100%;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 4,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
  p_field_alignment  => 'LEFT',
  p_display_when=>'select 1'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where sid = :p30720_inventory_reason_sid'||chr(10)||
'   and code in (''ACC'',''PCC'')'||chr(10)||
'/*   and :p30720_sel_inventory is null*/',
  p_display_when_type=>'EXISTS',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>9612830611275542 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_END_DATE_ORIG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
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
  p_id=>9614902392305278 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_INVENTORY_REASON_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 8957611619466307+wwv_flow_api.g_id_offset,
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
  p_id=>16063112672246935 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_name=>'P30720_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 8955918629449396+wwv_flow_api.g_id_offset,
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
 
wwv_flow_api.create_page_computation(
  p_id=> 8991931779795568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_computation_sequence => 10,
  p_computation_item=> 'P30720_INVENTORY_TYPE_SID',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select sid'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where usage = ''EVIDENCE_INVENTORY_TYPE'''||chr(10)||
'   and code = ''PART''',
  p_compute_when => 'select 1'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where sid = :p30720_inventory_reason_sid'||chr(10)||
'   and code = ''ACC''',
  p_compute_when_type=>'EXISTS');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 8993007369826368 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_computation_sequence => 20,
  p_computation_item=> 'P30720_INVENTORY_TYPE_SID',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select sid'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where usage = ''EVIDENCE_INVENTORY_TYPE'''||chr(10)||
'   and code = ''FULL''',
  p_compute_when => 'select 1'||chr(10)||
'  from t_osi_reference'||chr(10)||
' where sid = :p30720_inventory_reason_sid'||chr(10)||
'   and code = ''ACC''',
  p_compute_when_type=>'NOT_EXISTS');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 9062504793415209 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30720,
  p_computation_sequence => 30,
  p_computation_item=> 'P30720_RPT_TYPE',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select sid'||chr(10)||
'  from t_osi_report_type'||chr(10)||
' where obj_type = core_obj.lookup_objtype(''EMM'')'||chr(10)||
'   and description = ''Inventory''',
  p_compute_when => 'P30720_RPT_TYPE',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11824129259515673 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Valid start date',
  p_validation_sequence=> 1,
  p_validation => 'P30720_START_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid start date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30720_START_DATE IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8959201969491967 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11824312421520325 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Valid end date',
  p_validation_sequence=> 2,
  p_validation => 'P30720_END_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid completed date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30720_END_DATE IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8959414782495590 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11824531814525896 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Completed date >= start date',
  p_validation_sequence=> 3,
  p_validation => 'begin'||chr(10)||
'wwv_flow.debug('':P30720_START_DATE='' || :P30720_START_DATE);'||chr(10)||
'wwv_flow.debug('':P30720_END_DATE='' || :P30720_END_DATE);'||chr(10)||
'    if (to_date(:P30720_END_DATE, ''DD-MON-YYYY HH24:MI'') >='||chr(10)||
'                                         to_date(:P30720_START_DATE, ''DD-MON-YYYY HH24:MI'')) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'exception'||chr(10)||
'    when others then'||chr(10)||
'        -- Return true because if an exception is thrown here then the validation that looks for a valid date will have failed.'||chr(10)||
'        return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Completed date must be >= start date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30720_END_DATE IS NOT NULL'||chr(10)||
'AND :P30720_END_DATE_ORIG IS NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8959414782495590 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6656300136240380 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Completed date >= start date when start date is read only',
  p_validation_sequence=> 3.5,
  p_validation => 'begin'||chr(10)||
'wwv_flow.debug('':P30720_START_DATE_RO='' || :P30720_START_DATE_RO);'||chr(10)||
'wwv_flow.debug('':P30720_END_DATE='' || :P30720_END_DATE);'||chr(10)||
'    if (to_date(:P30720_END_DATE, ''DD-MON-YYYY HH24:MI'') >='||chr(10)||
'                                         to_date(:P30720_START_DATE_RO, ''DD-MON-YYYY HH24:MI'')) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'exception'||chr(10)||
'    when others then'||chr(10)||
'        -- Return true because if an exception is thrown here then the validation that looks for a valid date will have failed.'||chr(10)||
'        return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Completed date must be >= start date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30720_END_DATE IS NOT NULL'||chr(10)||
'AND :P30720_END_DATE_ORIG IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8959414782495590 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 9611927916180160 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'P30720_INVENTORY_REASON_SID',
  p_validation_sequence=> 5,
  p_validation => 'P30720_INVENTORY_REASON_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Inventory Reason must be specified.',
  p_validation_condition=> ':REQUEST in (''SAVE'',''CREATE'') and :P30720_END_DATE_ORIG is null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8960330937566571 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8978222167423760 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Agent(s) Selected',
  p_validation_sequence=> 10,
  p_validation => 'apex_application.g_f01.count > 0',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'No Agent(s) selected.',
  p_when_button_pressed=> 8977915110412192 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8981408277467070 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Agent Unique',
  p_validation_sequence=> 20,
  p_validation => 'select 1'||chr(10)||
'  from t_osi_evidence_inv_personnel'||chr(10)||
' where personnel_sid = :NEW_AGENT_INVOLVED_SID'||chr(10)||
'   and inventory_sid = :p30720_sel_inventory',
  p_validation_type => 'NOT_EXISTS',
  p_error_message => 'The selected agent is already tied to this inventory',
  p_validation_condition=> 'NEW_AGENT_INVOLVED_SID',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 9631112238186731 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Custodian Change Evidence selected',
  p_validation_sequence=> 30,
  p_validation => 'P30720_CC_EVIDENCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Evidence must be selected for a custodian change.',
  p_validation_condition=> ':P30720_INVENTORY_REASON_CODE in (''ACC'',''PCC'')'||chr(10)||
'AND :REQUEST=''SAVE'''||chr(10)||
'AND :P30720_END_DATE IS NOT NULL'||chr(10)||
'AND :P30720_END_DATE != :P30720_ORIG_END_DATE',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 9609916245959115 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> ':P30720_INVENTORY_REASON_CODE in (''ACC'',''PCC'')'||chr(10)||
'AND'||chr(10)||
':REQUEST NOT IN (''P30720_INVENTORY_REASON_SID'')'||chr(10)||
'AND'||chr(10)||
':REQUEST NOT LIKE ''EDIT_%''');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6959420417947833 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'P30720_START_DATE',
  p_validation_sequence=> 40,
  p_validation => 'P30720_START_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Start Date must be specified.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P30720_END_DATE_ORIG IS NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8959201969491967 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 7678912548914991 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_validation_name => 'Custodian Change Outgoing Custodian Selected',
  p_validation_sequence=> 50,
  p_validation => 'P30720_OUTGOING_CUST_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Outgoing Evidence Custodian must be selected for a custodian change.',
  p_validation_condition=> ':P30720_INVENTORY_REASON_CODE in (''ACC'',''PCC'')'||chr(10)||
'AND'||chr(10)||
':REQUEST=''SAVE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8963831030623303 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '    :P30720_INVENTORY_REASON_CODE in (''ACC'',''PCC'')'||chr(10)||
'AND :REQUEST NOT IN (''P30720_INVENTORY_REASON_SID'')'||chr(10)||
'AND :REQUEST NOT LIKE ''EDIT_%''');
 
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
'     for a in (select i.sid from t_osi_evidence_inventory i, t_osi_reference ir'||chr(10)||
'                 where i.unit_sid = :P0_OBJ'||chr(10)||
'                   and i.inventory_reason_sid = ir.sid'||chr(10)||
'                   and (ir.code <> ''IGS'' or :p30720_IG = ''Y'') order by i.start_date desc,i.end_Date)'||chr(10)||
'     loop'||chr(10)||
'         :P30720_FIRST_INVENTORY:=a.sid;'||chr(10)||
'         htp.p(''<script language="JavaScript" type="text/javasc';

p:=p||'ript">var td = document.getElementById("currentrow");if (td==undefined){doSubmit("'' || ''EDIT_'' || a.sid || ''");}</script>'');'||chr(10)||
'         exit;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 7685126435622222 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_FOOTER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Auto Select',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P30720_FIRST_INVENTORY IS NULL AND'||chr(10)||
':REQUEST NOT IN (''ADD'','||chr(10)||
'                 ''CREATE'','||chr(10)||
'                 ''SAVE'','||chr(10)||
'                 ''DELETE'','||chr(10)||
'                 ''P30720_INVENTORY_REASON_SID'','||chr(10)||
'                 ''P30720_OUTGOING_CUST_SID'')',
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
p:=p||'htp.p(''<script language="JavaScript">var cnt=$v("P30720_CC_COUNT"); alert("Custodian Changes Complete:\n\n"+cnt+" changed");</script>'');'||chr(10)||
''||chr(10)||
':P30720_CC_COUNT:=0;';

wwv_flow_api.create_page_process(
  p_id     => 8147111017748361 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_FOOTER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Show Count',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P30720_CC_COUNT > 0',
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
p:=p||'#OWNER#:T_OSI_EVIDENCE_INVENTORY:P30720_SEL_INVENTORY:SID|IU';

wwv_flow_api.create_page_process(
  p_id     => 8966515671685110 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'ARP',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CREATE,SAVE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30720_SEL_INVENTORY',
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
p:=p||':p30720_sel_inventory := substr(:REQUEST, 6);'||chr(10)||
':P30720_CC_EVIDENCE:=NULL;';

wwv_flow_api.create_page_process(
  p_id     => 8960825181574339 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Inventory',
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
p:=p||'if :REQUEST in (''ADD'',''P30720_OUTGOING_CUST_SID'',''P30720_INVENTORY_REASON_SID'') then'||chr(10)||
'   :P30720_MODE := ''ADD'';'||chr(10)||
'else'||chr(10)||
'   :P30720_MODE := null;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 8961322195582978 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Mode',
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
p:=p||'insert into t_osi_evidence_inv_personnel '||chr(10)||
'(inventory_sid, personnel_sid) '||chr(10)||
'values  '||chr(10)||
'(:p30720_sel_inventory, :NEW_AGENT_INVOLVED_SID);';

wwv_flow_api.create_page_process(
  p_id     => 8977610477401384 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Involved Agent',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'NEW_AGENT_INVOLVED_SID',
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
p:=p||'begin'||chr(10)||
'  for i in 1..apex_application.g_f01.count loop'||chr(10)||
'     delete from t_osi_evidence_inv_personnel'||chr(10)||
'      where sid = apex_application.g_f01(i);'||chr(10)||
'  end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8979132687436175 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Involved Agent',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>8977915110412192 + wwv_flow_api.g_id_offset,
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
p:=p||'--if editing or cancel, clear all fields except the selected sid.'||chr(10)||
'--if adding or deleting, clear them all.'||chr(10)||
'--any cleared field will need to re-fetch from the database.'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if (   (:REQUEST in (''ADD'',''DELETE'',''CANCEL''))'||chr(10)||
'      or (:REQUEST like ''EDIT_%'')) then'||chr(10)||
'      :P30720_START_DATE := null;'||chr(10)||
'      :P30720_END_DATE := null; '||chr(10)||
'      :P30720_INVENTORY_REASON_SID := null; '||chr(10)||
'      :P30720_INVENTORY_';

p:=p||'TYPE_SID := null; '||chr(10)||
'      :P30720_OUTGOING_CUST_SID := null; '||chr(10)||
'      :P30720_RESPONSIBLE_CUST_SID := null; '||chr(10)||
'      :P30720_COMMENTS := null; '||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if :REQUEST in (''ADD'',''DELETE'') then'||chr(10)||
'      :P30720_SEL_INVENTORY := null;'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if :REQUEST = ''P30720_INVENTORY_REASON_SID'' then'||chr(10)||
'      :P30720_OUTGOING_CUST_SID := null;'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8982509494505189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear Fields',
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
p:=p||'insert into t_osi_evidence_trans_log'||chr(10)||
'   (evidence_sid, '||chr(10)||
'    tran_type_sid, '||chr(10)||
'    effective_date, '||chr(10)||
'    other_party, '||chr(10)||
'    purpose, '||chr(10)||
'    custodian_sid)'||chr(10)||
'select sid,'||chr(10)||
'       osi_evidence.lookup_evid_trans_type_sid(''LOGOUT''),'||chr(10)||
'       sysdate,'||chr(10)||
'       osi_personnel.get_name,'||chr(10)||
'        ''Logging Out for '' ||'||chr(10)||
'        decode(:p30720_inventory_reason_code, '||chr(10)||
'               ''ACC'', ''Alternate Custodian Change.'','||chr(10)||
'     ';

p:=p||'          ''PCC'', ''Primary Custodian Change.'','||chr(10)||
'               ''Unknown reason.''),'||chr(10)||
'         nvl(:p30720_outgoing_cust_sid,'||chr(10)||
'             :user_sid)'||chr(10)||
'    from t_osi_evidence'||chr(10)||
'   where instr(:p30720_cc_evidence, sid)>0'||chr(10)||
'     and unit_sid = :p0_obj;'||chr(10)||
''||chr(10)||
''||chr(10)||
'insert into t_osi_evidence_trans_log'||chr(10)||
'   (evidence_sid, '||chr(10)||
'    tran_type_sid, '||chr(10)||
'    effective_date, '||chr(10)||
'    other_party, '||chr(10)||
'    purpose, '||chr(10)||
'    custodian_sid)'||chr(10)||
'select si';

p:=p||'d,'||chr(10)||
'       osi_evidence.lookup_evid_trans_type_sid(''LOGIN''),'||chr(10)||
'       sysdate,'||chr(10)||
'       null,'||chr(10)||
'        ''Logging In for '' ||'||chr(10)||
'        decode(:p30720_inventory_reason_code, '||chr(10)||
'               ''ACC'', ''Alternate Custodian Change.'','||chr(10)||
'               ''PCC'', ''Primary Custodian Change.'','||chr(10)||
'               ''Unknown reason.''),'||chr(10)||
'               :user_sid'||chr(10)||
'    from t_osi_evidence'||chr(10)||
'   where instr(:p30720_cc_evidence, sid)>0'||chr(10)||
'    ';

p:=p||' and unit_sid = :p0_obj;'||chr(10)||
''||chr(10)||
'update t_osi_evidence set transferred_from_unit_sid = null, unit_sid = :p0_obj'||chr(10)||
' where instr(:p30720_cc_evidence, sid)>0 returning count(sid) into :P30720_CC_COUNT;'||chr(10)||
''||chr(10)||
':P30720_CC_EVIDENCE := NULL;';

wwv_flow_api.create_page_process(
  p_id     => 9634226287379984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Process Custodian Change',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Failure Changing Custodian',
  p_process_when=>':P30720_INVENTORY_REASON_CODE in (''ACC'',''PCC'') AND'||chr(10)||
':REQUEST NOT IN (''P30720_INVENTORY_REASON_SID'','||chr(10)||
'                 ''P30720_OUTGOING_CUST_SELECT'','||chr(10)||
'                 ''P30720_OUTGOING_CUST_SID'') AND'||chr(10)||
':REQUEST NOT LIKE ''EDIT_%'' AND'||chr(10)||
':REQUEST NOT IN (''ADD'',''DELETE'',''CREATE'')',
  p_process_when_type=>'SQL_EXPRESSION',
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
p:=p||'F|#OWNER#:T_OSI_EVIDENCE_INVENTORY:P30720_SEL_INVENTORY:SID';

wwv_flow_api.create_page_process(
  p_id     => 8964911815655615 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST not in (''P30720_INVENTORY_REASON_SID'', ''P30720_INV_AGENT'', ''P30720_OUTGOING_CUST_SID'')',
  p_process_when_type=>'',
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
p:=p||':p30720_ig := osi_auth.check_for_priv(''EMM_IG'', core_obj.lookup_objtype(''EMM''), null, :p0_obj);'||chr(10)||
''||chr(10)||
'if :p30720_sel_inventory is not null then'||chr(10)||
''||chr(10)||
'   if :p30720_inventory_reason_sid is not null then'||chr(10)||
''||chr(10)||
'     select code into :p30720_inventory_reason_code'||chr(10)||
'       from t_osi_reference where sid=:p30720_inventory_reason_sid;'||chr(10)||
''||chr(10)||
'   else'||chr(10)||
''||chr(10)||
'     select ir.code into :p30720_inventory_reason_code'||chr(10)||
'       from t_osi_refe';

p:=p||'rence ir, t_osi_evidence_inventory i'||chr(10)||
'       where i.inventory_reason_sid=ir.sid'||chr(10)||
'         and i.sid=:p30720_sel_inventory;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   select end_date into :p30720_end_date_orig '||chr(10)||
'     from t_osi_evidence_inventory where sid=:p30720_sel_inventory;'||chr(10)||
''||chr(10)||
'else'||chr(10)||
''||chr(10)||
'  :p30720_end_date_orig := null;'||chr(10)||
''||chr(10)||
'  if :p30720_inventory_reason_sid is not null then'||chr(10)||
''||chr(10)||
'    select code into :p30720_inventory_reason_code'||chr(10)||
'      ';

p:=p||'from t_osi_reference where sid=:p30720_inventory_reason_sid;'||chr(10)||
''||chr(10)||
'   else'||chr(10)||
''||chr(10)||
'     :p30720_inventory_reason_code := null;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :p30720_end_date_orig is not null then'||chr(10)||
''||chr(10)||
'  :p0_writable:=''N'';'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P30720_INVENTORY_REASON_CODE in (''ACC'',''PCC'') and'||chr(10)||
'   length(:P30720_CC_EVIDENCE) > 0 then'||chr(10)||
'  '||chr(10)||
'  :P30720_SAVE_BUTTON_NAME := ''Change Custodian on Selected Evidence'';'||chr(10)||
''||chr(10)||
'else'||chr(10)||
''||chr(10)||
'  :P30720_SAVE';

p:=p||'_BUTTON_NAME := ''Save'';'||chr(10)||
''||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 9613012865289376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30720,
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
-- ...updatable report columns for page 30720
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
