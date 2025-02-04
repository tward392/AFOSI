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
--   Date and Time:   07:15 Thursday September 1, 2011
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

PROMPT ...Remove page 5050
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5050);
 
end;
/

 
--application/pages/page_05050
prompt  ...PAGE 5050: Notes
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_SEND_REQUEST"'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"';

wwv_flow_api.create_page(
  p_id     => 5050,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Notes',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P5050_SEL_NOTE.'');"'||chr(10)||
'',
  p_step_sub_title => 'Notes',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'$(window).load(function(){  '||chr(10)||
''||chr(10)||
'  var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
''||chr(10)||
'});'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110901071456',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '26-AUG-2010  J.Faris CHG0003228 - updated note category select list to include note type overrides tied to a "sub-parent" (like ACT.CHECKLIST).'||chr(10)||
''||chr(10)||
'06-OCT-2010  J.Faris   WCHG0000397 - Integrated Tim Ward''s page updates (involved re-apply of Export button functionality).'||chr(10)||
''||chr(10)||
'01-Apr-2011  Tim Ward  CR#3636 - Reformatted the screen to look more like Legacy, included the Time Created.  Made the report and note text 100% width.'||chr(10)||
''||chr(10)||
'18-Aug-2011  Tim Ward  CR#3855 - Added Shift Up/Down Key for Navigation. '||chr(10)||
'18-Aug-2011  Tim Ward  CR#3926 - While viewing Notes in a file with "Notes for Associated Activities" selected.  '||chr(10)||
'                                 If you select an Activity Note, a new added note gets attached to that activity'||chr(10)||
'                                 instead of the file.  Also, an update note gets moved to that activity.'||chr(10)||
'                                 Added P5050_OBJ1 to help with this issue.'||chr(10)||
''||chr(10)||
'                                 Added "JS_REPORT_AUTO_SCROLL" to HTML Header.  '||chr(10)||
'                                 Added onkeydown="return checkForUpDownArrows (event, ''&P10150_SEL_ASSOC.'');" '||chr(10)||
'                                 to HTML Body Attribute. '||chr(10)||
'                                 Added name=''#SID#'' to "Link Attributes" of the SID Column of the Report. '||chr(10)||
'                                 Added a new Branch to'||chr(10)||
'                                 "f?p=&APP_ID.:5050:&SESSION.::&DEBUG.:::#&5050_SEL_NOTE.",'||chr(10)||
'                                 this allows the report to move the the Anchor of the selected currentrow.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5050,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<div class="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 5494825937411081 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5050,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
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
  p_plug_required_role => '!'||(5459808427748525+ wwv_flow_api.g_id_offset),
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
  p_id=> 8125322827876248 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5050,
  p_plug_name=> 'Access Denied',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE = ''PERSONNEL'''||chr(10)||
'and'||chr(10)||
':TAB_ENABLED <> ''Y''',
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
  p_id=> 89959830988303506 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5050,
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
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
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
  p_id=> 89960036535303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5050,
  p_plug_name=> 'Details of Selected Note  <font color="red"><i>([shift]+[down]/[up] to navigate notes)</i></font>',
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
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5050_SEL_NOTE IS NOT NULL OR :P5050_MODE = ''ADD''',
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
s:=s||'select N.SID as "SID",'||chr(10)||
'       N.CREATE_ON as "Date Created",'||chr(10)||
'       OSI_PERSONNEL.GET_NAME'||chr(10)||
'                        (N.CREATING_PERSONNEL)'||chr(10)||
'                                               as "Created By",'||chr(10)||
'       core_obj.get_parentinfo(N.OBJ) as "File / Activity",'||chr(10)||
'       NT.DESCRIPTION as "Category",'||chr(10)||
'       OSI_NOTE.GET_NOTE_STATUS (N.sid) as "Status",'||chr(10)||
'       decode(n.sid, :P5050_SEL_NOTE, ''Y'', ''N'') ';

s:=s||'as "Current"'||chr(10)||
'  from T_OSI_NOTE N, T_OSI_NOTE_TYPE NT '||chr(10)||
'         &P5050_REPORT_WHERE_CLAUSE.';

wwv_flow_api.create_report_region (
  p_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5050,
  p_name=> 'Notes',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P0_obj_type_code <> ''PERSONNEL'''||chr(10)||
'or'||chr(10)||
'(:P0_obj_type_code = ''PERSONNEL'' and :TAB_ENABLED = ''Y'')',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '100000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No notes found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '100000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'INVISIBLE',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P5050_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'declare'||chr(10)||
'    v_sql varchar2(3000);'||chr(10)||
'begin'||chr(10)||
'    v_sql :='||chr(10)||
'       ''select N.SID as "SID",'||chr(10)||
'       N.CREATE_ON as "Date Created",'||chr(10)||
'       OSI_PERSONNEL.GET_NAME'||chr(10)||
'                        (N.CREATING_PERSONNEL)'||chr(10)||
'                                               "Created By",'||chr(10)||
'       core_obj.get_tagline(N.OBJ) as "FileActivity",'||chr(10)||
'       NT.DESCRIPTION as "Category",'||chr(10)||
'       OSI_NOTE.GET_NOTE_STATUS (N.sid) as "Status",'||chr(10)||
'       decode(n.sid, :P5050_SEL_NOTE, ''''Y'''', ''''N'''') "Current"'||chr(10)||
'  from T_OSI_NOTE N, T_OSI_NOTE_TYPE NT '''||chr(10)||
'        || :p5050_report_where_clause;'||chr(10)||
''||chr(10)||
':DEBUG := v_sql;'||chr(10)||
' return v_sql;'||chr(10)||
'end;'||chr(10)||
'----------------------------------------------------------------------'||chr(10)||
'declare'||chr(10)||
'    v_sql varchar2(3000);'||chr(10)||
'    --P5050_REPORT_WHERE_CLAUSE varchar2(3000) := ''1=1'';'||chr(10)||
'begin'||chr(10)||
'    v_sql :='||chr(10)||
'        '''||chr(10)||
'select ''''<a href="javascript:doSubmit(''''''''EDIT_'''' || n.sid || '''''''''''');" target=''''''''_blank''''''''>&ICON_EDIT.</a>'''' as "EDIT", N.SID as "SID2",'||chr(10)||
'       N.CREATE_ON as "Date Created",'||chr(10)||
'       OSI_PERSONNEL.GET_NAME'||chr(10)||
'                        (N.CREATING_PERSONNEL)'||chr(10)||
'                                               "Created By",'||chr(10)||
'       NT.DESCRIPTION as "Category",'||chr(10)||
'       OSI_NOTE.GET_NOTE_STATUS (N.sid) as "Status",'||chr(10)||
'       decode(n.sid, :P5050_SEL_NOTE, ''''Y'''', ''''N'''') "Current"'||chr(10)||
'  from T_OSI_NOTE N, T_OSI_NOTE_TYPE NT where '''||chr(10)||
'        || :p5050_report_where_clause;'||chr(10)||
''||chr(10)||
' return v_sql;'||chr(10)||
'end;');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96014433018367920 + wwv_flow_api.g_id_offset,
  p_region_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> '(osi_auth.check_for_priv(''ADD_VIEW_NOTES'', :P0_OBJ_TYPE_SID) =''Y'' and :P0_OBJ_TYPE_CODE = ''PERSONNEL'') '||chr(10)||
'or'||chr(10)||
'(:P0_OBJ_TYPE_CODE <> ''PERSONNEL'')',
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
  p_id=> 96014512011367920 + wwv_flow_api.g_id_offset,
  p_region_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Date Created',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Date Created',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
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
  p_id=> 96014621061367920 + wwv_flow_api.g_id_offset,
  p_region_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Created By',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Created By',
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
  p_id=> 96015837651378745 + wwv_flow_api.g_id_offset,
  p_region_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'File / Activity',
  p_column_display_sequence=> 3,
  p_column_heading=> 'File / Activity',
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
  p_id=> 96014836319367920 + wwv_flow_api.g_id_offset,
  p_region_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Category',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Category',
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
  p_id=> 96014937189367920 + wwv_flow_api.g_id_offset,
  p_region_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Status',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Status',
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
  p_id=> 96015018648367920 + wwv_flow_api.g_id_offset,
  p_region_id=> 89960226795303507 + wwv_flow_api.g_id_offset,
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
  p_id=> 93113530125208810 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5050,
  p_plug_name=> 'Choose the Notes to Display',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5050_IS_FILE = ''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89960911365303509 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5050,
  p_button_sequence=> 40,
  p_button_plug_id => 89960226795303507+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Note',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> '(osi_auth.check_for_priv(''ADD_VIEW_NOTES'', :P0_OBJ_TYPE_SID) = ''Y'' and :P0_OBJ_TYPE_CODE = ''PERSONNEL'') '||chr(10)||
'or'||chr(10)||
'(osi_auth.check_for_priv(''NOTES_ADD'', :P0_OBJ_TYPE_SID) = ''Y'' and :P0_OBJ_TYPE_CODE = ''UNIT'') '||chr(10)||
'or'||chr(10)||
'(:P0_OBJ_TYPE_CODE not in (''PERSONNEL'',''UNIT''))',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5459808427748525+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89961519126303510 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5050,
  p_button_sequence=> 10,
  p_button_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P5050_SEL_NOTE is not null '||chr(10)||
'and '||chr(10)||
':P5050_NOTE_STATUS is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5459808427748525+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89961125812303510 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5050,
  p_button_sequence=> 20,
  p_button_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5050_SEL_NOTE is not null'||chr(10)||
'and'||chr(10)||
':P5050_NOTE_STATUS is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5459808427748525+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90054934693849831 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5050,
  p_button_sequence=> 50,
  p_button_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P5050_SEL_NOTE',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_security_scheme => 5459808427748525+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16568917834752857 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5050,
  p_button_sequence=> 70,
  p_button_plug_id => 89960226795303507+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 5050);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90853938173386146 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5050,
  p_button_sequence=> 60,
  p_button_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
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
  p_id=>89964807483303526 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>7409418616402481 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_branch_action=> 'f?p=&APP_ID.:5050:&SESSION.::&DEBUG.:::#&P5050_SEL_NOTE.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 15,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST = ''SAVE'' OR :REQUEST LIKE ''EDIT_%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-AUG-2011 10:50 by TWARD');
 
wwv_flow_api.create_page_branch(
  p_id=>89964623944303526 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_branch_action=> 'f?p=&APP_ID.:5050:&SESSION.:&REQUEST.:&DEBUG.::P5050_OBJ1:&P5050_OBJ1.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 20-APR-2009 20:58 by Richard Dibble');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5210111000138771 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_TIME_CREATED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 319,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Time Created:',
  p_format_mask=>'hh:mi:ss am',
  p_source=>'SUBSTR(:P5050_CREATE_ON,LENGTH(''&FMT_DATE.'')+2)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap width=20%',
  p_cattributes_element=>'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P5050_SEL_NOTE',
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
  p_id=>5215005993250872 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_SPACER1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 313,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-CENTER',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5215307556250872 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_SPACER2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 315,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-CENTER',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5217021230255221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_SPACER3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 318,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-CENTER',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5226923073814093 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_CREATE_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 298,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_format_mask=>'&FMT_DATE. HH:MI:SS AM',
  p_source=>'CREATE_ON',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5781425286947859 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_OBJ1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 331,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
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
  p_id=>6955831345306470 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_NOTE_CAT_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8125628924876250 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_ACCESS_DENIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8125322827876248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Access Denied',
  p_source=>'You do not have permission to view the contents of this tab.',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16569129608756237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 89960226795303507+wwv_flow_api.g_id_offset,
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
  p_id=>89961926091303512 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_source=>'OBJ',
  p_source_type=> 'DB_COLUMN',
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
  p_item_comment => ':P0_OBJ was in Default Value---Removed.'||chr(10)||
'');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89962110711303514 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_SEL_NOTE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Selected Note SID',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>89962331517303514 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_NOTE_CATEGORY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 316,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Category:',
  p_source=>'NOTE_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   DESCRIPTION, sid'||chr(10)||
'    from T_OSI_NOTE_TYPE nt'||chr(10)||
'   where (OBJ_TYPE member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'     and (ACTIVE = ''Y'')'||chr(10)||
'     and USAGE = ''NOTELIST'''||chr(10)||
'     and code not in (select code'||chr(10)||
'                      from t_osi_note_type'||chr(10)||
'                     where ((obj_type = :P0_OBJ_TYPE_SID and override = ''Y'')'||chr(10)||
'                                or'||chr(10)||
'                               (obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'                           and override = ''Y''))'||chr(10)||
'                       and sid <> nt.sid)) or SID = :P5050_NOTE_CATEGORY'||chr(10)||
'   order by SEQ, DESCRIPTION',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Category -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap width=30%',
  p_cattributes_element=>'nowrap',
  p_tag_attributes  => '&P5050_NOTE_CAT_STATUS.',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_read_only_when=>'P5050_NOTE_STATUS',
  p_read_only_when2=>'readOnly',
  p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>89962532754303515 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_NOTE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 321,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Text',
  p_source=>'NOTE_TEXT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 85,
  p_cMaxlength=> 30000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:99%"',
  p_tag_attributes  => '&P5050_NOTE_STATUS. style="width:99%"',
  p_tag_attributes2=> 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 10,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>89962722248303515 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_NOTE_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Status',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>90844319931888887 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_DATE_CREATED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 317,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Created:',
  p_source=>'SUBSTR(:P5050_CREATE_ON,1,LENGTH(''&FMT_DATE.''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap width=30%',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P5050_SEL_NOTE',
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
  p_id=>90844616253897246 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_CREATED_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 311,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Created By',
  p_source=>'CREATING_PERSONNEL',
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
  p_id=>90844820193907887 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 314,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status:',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap width=10%',
  p_cattributes_element=>'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P5050_SEL_NOTE',
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
  p_id=>90850133175223826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_CREATED_BY_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 312,
  p_item_plug_id => 89960036535303507+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Author:',
  p_source=>'osi_personnel.get_name(:P5050_CREATED_BY)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap width=30%',
  p_cattributes_element=>'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P5050_SEL_NOTE',
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
  p_id=>93113826066208826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_ASSOC_NOTES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 93113530125208810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Notes for this File;ME,Notes for Associated Files;A_FILES,Notes for Associated Activities;A_ACT,Notes for Inherited Activities;I_ACT',
  p_lov_columns=> 4,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onClick="javascript:doSubmit(''UPDATE'');"',
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
  p_id=>93116526625255034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_IS_FILE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Is File?',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>93549136455706640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5050_MODE',
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
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95808223246646612 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5050,
  p_name=>'P5050_REPORT_WHERE_CLAUSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 89959830988303506+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'WHERE Clause',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 150,
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
 
wwv_flow_api.create_page_validation(
  p_id => 89963033121303515 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_validation_name => 'P5050_NOTE_CATEGORY Not Null',
  p_validation_sequence=> 13,
  p_validation => 'P5050_NOTE_CATEGORY',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Category must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89963206564303517 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_validation_name => 'P5050_NOTE Not Null',
  p_validation_sequence=> 23,
  p_validation => 'P5050_NOTE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Note text must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 89962532754303515 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89963419602303517 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_validation_name => 'MAX_NUM Validation',
  p_validation_sequence=> 33,
  p_validation => 'declare'||chr(10)||
''||chr(10)||
'    V_MAX_NUM      number;'||chr(10)||
'    V_NOTE_COUNT   number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'    select MAX_NUM into V_MAX_NUM'||chr(10)||
'          from T_OSI_NOTE_TYPE'||chr(10)||
'              where sid=:P5050_NOTE_CATEGORY;'||chr(10)||
''||chr(10)||
'--wwv_flow.debug(''V_MAX_NUM='' || V_MAX_NUM);      '||chr(10)||
''||chr(10)||
'    if (V_MAX_NUM > 0) then'||chr(10)||
''||chr(10)||
'      if :P5050_SEL_NOTE IS NULL then'||chr(10)||
''||chr(10)||
'        select count(*) into V_NOTE_COUNT'||chr(10)||
'              from T_OSI_NOTE'||chr(10)||
'                  where OBJ=:P0_OBJ'||chr(10)||
'                    and NOTE_TYPE=:P5050_NOTE_CATEGORY;'||chr(10)||
'    '||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'        select count(*) into V_NOTE_COUNT'||chr(10)||
'              from T_OSI_NOTE'||chr(10)||
'                  where OBJ=:P0_OBJ'||chr(10)||
'                    and NOTE_TYPE=:P5050_NOTE_CATEGORY'||chr(10)||
'                    and sid!=:P5050_SEL_NOTE;'||chr(10)||
''||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'      if (V_NOTE_COUNT >= V_MAX_NUM) then'||chr(10)||
''||chr(10)||
'        return false;'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    return true;'||chr(10)||
'exception'||chr(10)||
'    when no_data_found then'||chr(10)||
'        return true;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The maximum number of notes for the selected category has been reached.  Please change the category to something different.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 4918708220481146 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_validation_name => 'Authorization verification',
  p_validation_sequence=> 35,
  p_validation => 'begin'||chr(10)||
'    for x in (select at.code'||chr(10)||
'                from t_osi_auth_action_type at, t_osi_note_type nt'||chr(10)||
'               where nt.sid = :p5050_note_category'||chr(10)||
'                 and nt.auth_action = at.sid'||chr(10)||
'                 and nt.obj_type = :p0_obj_type_sid)'||chr(10)||
'    loop'||chr(10)||
'        if (osi_auth.check_for_priv(x.code, :p0_obj_type_sid) = ''Y'') then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'You are not authorized to add or modify this note type.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
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
'     if (:request in(''ADD'')) then'||chr(10)||
'     '||chr(10)||
'       :p5050_mode := ''ADD'';'||chr(10)||
'       :P5050_obj  := :p5050_obj1;'||chr(10)||
'     '||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       :p5050_mode := null;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95490906988348787 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set mode',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'UPDATE',
  p_process_when_type=>'REQUEST_NOT_IN_CONDITION',
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
p:=p||'#OWNER#:T_OSI_NOTE:P5050_SEL_NOTE:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 89963914024303524 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'ARP',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE,DELETE,CREATE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P5050_SEL_NOTE',
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
p:=p||'P5050_SEL_NOTE,P5050_NOTE_CATEGORY,P5050_NOTE';

wwv_flow_api.create_page_process(
  p_id     => 89964135788303526 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Note Fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''ADD'',''DELETE'') or :REQUEST like ''EDIT_%''',
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
p:=p||':P5050_SEL_NOTE:= substr(:REQUEST,6);'||chr(10)||
':P5050_OBJ := :P5050_OBJ1;';

wwv_flow_api.create_page_process(
  p_id     => 89964336670303526 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Note',
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
p:=p||'P5050_NOTE_CATEGORY,P5050_NOTE';

wwv_flow_api.create_page_process(
  p_id     => 2865210049660076 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Reset Fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CANCEL',
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
p:=p||':P5050_SEL_NOTE:=Null;';

wwv_flow_api.create_page_process(
  p_id     => 7407719825314645 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear Selected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'UPDATE',
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
p:=p||'F|#OWNER#:T_OSI_NOTE:P5050_SEL_NOTE:SID';

wwv_flow_api.create_page_process(
  p_id     => 90023210650264157 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P5050_SEL_NOTE',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
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
'       v_cnt number;'||chr(10)||
'begin'||chr(10)||
'     if :P5050_OBJ1 is null then'||chr(10)||
''||chr(10)||
'       :P5050_OBJ1:=:P0_OBJ;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if (osi_note.get_note_status(:p5050_sel_note) = ''Locked'') then'||chr(10)||
''||chr(10)||
'       --- This check is for notes locked due to a lock mode ---'||chr(10)||
'      :p5050_note_status := ''readOnly style="background-color:#f5f4ea;width:99%"'';---:DISABLE_TEXTAREA;'||chr(10)||
'      :p5050_note_cat_status := :DISABLE_SELECT;'||chr(10)||
'';

p:=p||'      :p5050_status := ''Locked'';'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       --- Now we need to check to see if the note is from this                       ---'||chr(10)||
'       --- object (if simply viewing another objects notes, they too must be locked). ---'||chr(10)||
'       select count(sid) into v_cnt from t_osi_note where obj = :p0_obj and sid = :p5050_sel_note;'||chr(10)||
''||chr(10)||
'       if (v_cnt > 0 or :p5050_mode = ''ADD'') then'||chr(10)||
''||chr(10)||
'         :p5050_note_sta';

p:=p||'tus := null;'||chr(10)||
'         :p5050_note_cat_status := null;'||chr(10)||
'         :p5050_status := ''Open'';'||chr(10)||
'       '||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         :p5050_note_status := ''readOnly style="background-color:#f5f4ea;width:99%"'';---:DISABLE_TEXTAREA;'||chr(10)||
'         :p5050_note_cat_status := :DISABLE_SELECT;'||chr(10)||
'         :p5050_status := osi_note.get_note_status(:p5050_sel_note);'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if (instr(:p0_obj_type_code';

p:=p||', ''FILE.'', 1, 1) > 0) then'||chr(10)||
' '||chr(10)||
'       :p5050_is_file := ''Y'';'||chr(10)||
' '||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       :p5050_is_file := ''N'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89963507774303517 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Parameters',
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
'    if (   osi_auth.check_for_priv(''TAB_NOTES'', :p0_obj_type_sid) = ''Y'''||chr(10)||
'        or osi_auth.check_for_priv(''TAB_ALL'', :p0_obj_type_sid) = ''Y'') then'||chr(10)||
'        :tab_enabled := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        :tab_enabled := ''N'';'||chr(10)||
'    end if;         '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8125931831878909 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 40,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetTabDisabler',
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
p:=p||'declare'||chr(10)||
'       P5050_ASSOC_NOTES         varchar2(300)   := :P5050_ASSOC_NOTES;'||chr(10)||
'       P5050_REPORT_WHERE_CLAUSE varchar2(3000);'||chr(10)||
'       p0_obj                    varchar2(20)    := :P0_obj;'||chr(10)||
'       v_output                  varchar2(10000) := '' '';'||chr(10)||
'begin'||chr(10)||
'     if (instr(p5050_assoc_notes, ''ME'') > 0) then'||chr(10)||
''||chr(10)||
'       ---This File ---'||chr(10)||
'       if (length(v_output) > 2) then'||chr(10)||
''||chr(10)||
'         v_output := v_output || ';

p:=p||''' OR '';'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'       v_output := v_output || '' N.OBJ = '''''' || p0_obj || '''''''';'||chr(10)||
'       dbms_output.put_line(''This File'');'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if (instr(p5050_assoc_notes, ''A_FILES'') > 0) then'||chr(10)||
''||chr(10)||
'       --- Associated Files ---'||chr(10)||
'       if (length(v_output) > 2) then'||chr(10)||
''||chr(10)||
'         v_output := v_output || '' OR '';'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'       v_output := v_output || '' (N.OBJ in (select THAT_FILE from v_o';

p:=p||'si_assoc_fle_fle where this_file = '''''' || p0_obj || '''''')) '';'||chr(10)||
'       dbms_output.put_line(''Associated Files'');'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if (instr(p5050_assoc_notes, ''A_ACT'') > 0) then'||chr(10)||
''||chr(10)||
'       --- Associated Activities ---'||chr(10)||
'       if (length(v_output) > 2) then'||chr(10)||
''||chr(10)||
'         v_output := v_output || '' OR '';'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
'        '||chr(10)||
'       v_output := v_output || '' (N.OBJ in (select ACTIVITY_SID from v_osi_asso';

p:=p||'c_fle_ACT where file_sid = '''''' || p0_obj || '''''')) '';'||chr(10)||
'       dbms_output.put_line(''Associated Activities'');'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if (instr(p5050_assoc_notes, ''I_ACT'') > 0) then'||chr(10)||
''||chr(10)||
'       --- Inherited Activities ---'||chr(10)||
'       if (length(v_output) > 2) then'||chr(10)||
''||chr(10)||
'         v_output := v_output || '' OR '';'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'       v_output := v_output || '' (N.OBJ in (select ACTIVITY_SID from v_osi_assoc_fle_ACT wh';

p:=p||'ere file_sid in '||chr(10)||
'                                           (select THAT_FILE from v_osi_assoc_fle_fle where this_file =  '''''' || p0_obj || ''''''))) '';'||chr(10)||
''||chr(10)||
'       dbms_output.put_line(''Inherited Activities'');'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
' '||chr(10)||
'     if (length(v_output) > 2) then'||chr(10)||
'    '||chr(10)||
'       v_output := '' WHERE N.NOTE_TYPE = NT.sid AND ('' || v_output || '')'';'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       v_output := '' WHERE N.NOTE_TYPE = NT.sid and N';

p:=p||'.OBJ = '''''' || p0_obj || '''''''';'||chr(10)||
''||chr(10)||
'       :p5050_assoc_notes := ''ME'';'||chr(10)||
' '||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     :P5050_REPORT_WHERE_CLAUSE := v_output;'||chr(10)||
'     dbms_output.put_line(P5050_REPORT_WHERE_CLAUSE );'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95905309969953228 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5050,
  p_process_sequence=> 50,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create WHERE clause',
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
-- ...updatable report columns for page 5050
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








-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "CORE_OBJ" as
/*
    Core_Obj: Utility routines to process/retrieve info about abstract Objects.

    01-Nov-2005 RWH     Original version.
    07-Nov-2005 RWH     Added Get_Desktop_Page_Num.
    10-Nov-2005 RWH     Removed Get_Desktop_Page_Num. This function will be implemented
                        in the Core_Desktop package.
    01-Dec-2005 RWH     Added Bump.
    03-Jan-2006 RWH     Added Get_Tagline.
    04-Jan-2006 RWH     Added Index1 procedure (for DOC1 full text indexing).
    10-Jan-2006 RWH     Added Lookup_ObjType function.
    08-Feb-2006 RWH     Added Get_Status function.
    03-Oct-2006 RWH     Added Dump_Index1 function. This is used mostly for debugging index
                        routines.
    30-Oct-2006 RWH     Added Get_Summary. This will work similarly to Get_Tagline, but will
                        return a summary of the entire object. Typically, the output will be
                        formatted HTML.
    13-Dec-2006 JAF/RWH Added Get_Context_Description. Works similarly to Get_Tagline, returning
                        a user-friendly context description based on the specified Object and
                        Context.
    18-Jan-2007 RWH     Added Index and Dump_Index routines for indexes 2 thru 5.
    22-Apr-2011 TJW     CR#3829 - Added get_inherit_privs_flag.
    18-Aug-2011 TJW     CR#3926 - New and Updated Notes attaching to Activity instead of File.
                                  Added get_parentinfo.  

*/  /*
        Bump: This routine accomplishes 2 things. First, it causes the timestamp trigger
            to fire for T_CORE_OBJ, and second, it will notify any full text index that
            might be anchored to the DOC1 column.
    */
    procedure BUMP(P_OBJ in Varchar2);

    /*
        Dump_Index{n}: This routines calls the Index{n} routine with a temporary clob, and
            then return that clob as the function result. Used for debugging index routines.
    */
    function DUMP_INDEX1(P_SID in Varchar2)
        return Clob;

    function DUMP_INDEX2(P_SID in Varchar2)
        return Clob;

    function DUMP_INDEX3(P_SID in Varchar2)
        return Clob;

    function DUMP_INDEX4(P_SID in Varchar2)
        return Clob;

    function DUMP_INDEX5(P_SID in Varchar2)
        return Clob;

    /*
        Get_ACL: This routine returns the SID of the ACL for the specified object.
    */
    function GET_ACL(P_OBJ in Varchar2)
        return Varchar2;

    /*
        Get_Context_Description:  This routine returns an identifying string for the specified
        Object and Context. It does this by calling the Get_Context_Description function in the
        Object Type's method package.
    */
    function GET_CONTEXT_DESCRIPTION(P_OBJ in Varchar2, P_OBJ_CONTEXT in Varchar2)
        return Varchar2;

    /*
        Get_ObjType: This routines returns the SID of the Object Type for the specified
            object.
    */
    function GET_OBJTYPE(P_OBJ in Varchar2)
        return Varchar2;

    /*
        Get_Status: This routine returns the current status for the specified object.
            It does this by calling the Get_Status function in the Object Type's
            method package. The Object Type need not use the LifeCycle support object in
            order to have "statuses".
    */
    function GET_STATUS(P_OBJ in Varchar2)
        return Varchar2;

    /*
        Get_Summary: This routine returns a (read-only) summary for the specified object.
            It does this by calling the Get_Summary function in the Object Type's method
            package. The Variant parameter is optional, and is used by the specific Obj
            Type's method routine to generate different "variants" of the output based on
            the parameter. The Core routine does not examine this parameter, and passes it
            to the method package routine unchanged.

    */
    function GET_summary(P_OBJ in Varchar2, p_variant in varchar2 := null)
        return clob;

    /*
        Get_Tagline: This routine returns the user identifying string for the specified
            object. It does this by calling the Get_Tagline function in the Object Type's
            method package.
    */
    function GET_TAGLINE(P_OBJ in Varchar2)
        return Varchar2;

    /*
        Index{n}: This abstract procedure is the document synthesis entry point for the
            full text indexing mechanism. It maps the ROWID to a SID and then calls the
            Index{n} procedure in the Object Type's method package.
    */
    procedure INDEX1(R in rowid, C in out nocopy Clob);

    procedure INDEX2(R in rowid, C in out nocopy Clob);

    procedure INDEX3(R in rowid, C in out nocopy Clob);

    procedure INDEX4(R in rowid, C in out nocopy Clob);

    procedure INDEX5(R in rowid, C in out nocopy Clob);

    /*
        Lookup_ObjType: This routine return the SID of the specified (by Code) Object Type.
    */
    function LOOKUP_OBJTYPE(P_OBJ_TYPE_CODE in Varchar2)
        return Varchar2;

    function get_inherit_privs_flag(p_obj_type_sid in varchar2) return varchar2;

    function get_parentinfo(p_obj in varchar2) return varchar2;
    
end Core_Obj;
/


CREATE OR REPLACE PACKAGE BODY "CORE_OBJ" as
/*
    Core_Obj: Utility routines to process/retrieve info about abstract Objects.

    01-Nov-2005 RWH     Original version.
    07-Nov-2005 RWH     Added Get_Desktop_Page_Num.
    10-Nov-2005 RWH     Removed Get_Desktop_Page_Num. This function will be implemented
                        in the Core_Desktop package.
    01-Dec-2005 RWH     Added Bump.
    03-Jan-2006 RWH     Added Get_Tagline.
    04-Jan-2006 RWH     Added Index1 procedure (for DOC1 full text indexing).
    10-Jan-2006 RWH     Added Lookup_ObjType function.
    08-Feb-2006 RWH     Added Get_Status function.
    03-Oct-2006 RWH     Added Dump_Index1 function. This is used mostly for debugging index
                        routines.
    30-Oct-2006 RWH     Added Get_Summary. This will work similarly to Get_Tagline, but will
                        return a summary of the entire object. Typically, the output will be
                        formatted HTML.
    13-Dec-2006 JAF/RWH Added Get_Context_Description. Works similarly to Get_Tagline, returning
                        a user-friendly context description based on the specified Object and
                        Context.
    18-Jan-2007 RWH     Added Index and Dump_Index routines for indexes 2 thru 5.
    22-Apr-2011 TJW     CR#3829 - Added get_inherit_privs_flag.  
    18-Aug-2011 TJW     CR#3926 - New and Updated Notes attaching to Activity instead of File.
                                  Added get_parentinfo.  
*/
    c_pipe   varchar2(100) := nvl(core_util.get_config('CORE.PIPE_PREFIX'), 'I2G.') || 'CORE_OBJ';

-- Private support routines
    procedure build_index(
        p_ndx        in              number,
        p_rowid      in              rowid,
        p_clob       in out nocopy   clob,
        p_doc_head   in              varchar2 := '<DOC>',
        p_doc_tail   in              varchar2 := '</DOC>') is
        v_sid      varchar2(20);
        v_ot_pkg   t_core_obj_type.method_pkg%type;
        v_clob     clob;
    begin
        select o.sid, ot.method_pkg
          into v_sid, v_ot_pkg
          from t_core_obj o, t_core_obj_type ot
         where o.rowid = p_rowid and ot.sid = o.obj_type;

        core_util.append_info_to_clob(p_clob, p_doc_head, null);

        if v_ot_pkg is null then
            core_logger.log_it(c_pipe, 'Build_Index(' || p_ndx || '): Method Pkg not defined');
        else
            begin
                core_util.append_info_to_clob(v_clob, ' ', null);

                execute immediate 'begin ' || v_ot_pkg || '.INDEX' || p_ndx
                                  || '(:OBJ, :CLOB); end;'
                            using in v_sid, in out v_clob;

                -- If we get here, document was synthesized, so insert real content.
                dbms_lob.append(p_clob, v_clob);
            exception
                when others then
                    if sqlerrm like '%PLS-00302%INDEX%' then
                        core_logger.log_it(c_pipe,
                                           v_ot_pkg || '.Index' || p_ndx || ' procedure not defined');
                    else
                        core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                    end if;
            end;
        end if;

        core_util.cleanup_temp_clob(v_clob);
        core_util.append_info_to_clob(p_clob, p_doc_tail, null);
    exception
        when no_data_found then
            core_logger.log_it(c_pipe, 'Build_Index(' || p_ndx || '): Invalid ROWID specified');
    end build_index;

-- Public routines
    procedure bump(p_obj in varchar2) is
        v_docn_val   varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
    begin
        update t_core_obj
           set doc1 = v_docn_val,
               doc2 = v_docn_val,
               doc3 = v_docn_val,
               doc4 = v_docn_val,
               doc5 = v_docn_val
         where sid = p_obj;
    end bump;

    function dump_index1(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index1(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index1;

    function dump_index2(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index2(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index2;

    function dump_index3(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index3(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index3;

    function dump_index4(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index4(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index4;

    function dump_index5(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index5(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index5;

    function get_acl(p_obj in varchar2)
        return varchar2 is
        v_acl   varchar2(20);
    begin
        select acl
          into v_acl
          from t_core_obj
         where sid = p_obj;

        return v_acl;
    exception
        when no_data_found then
            return null;
    end get_acl;

    function get_context_description(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_rtn      varchar2(200)             := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        v_ot_rec.sid := core_obj.get_objtype(p_obj);

        if v_ot_rec.sid is null then
            core_logger.log_it(c_pipe,
                               'Get_Context_Description: Error locating Object Type for '
                               || nvl(v_ot_rec.sid, 'NULL'));
            return 'Invalid Object passed to Get_Context_Description';
        end if;

        select *
          into v_ot_rec
          from t_core_obj_type
         where sid = v_ot_rec.sid;

        if v_ot_rec.method_pkg is null then
            core_logger.log_it
                           (c_pipe,
                            'Get_Context_Description: Method package not defined for Obj_Type: '
                            || v_ot_rec.code);
            return 'Method package not defined for ' || v_ot_rec.description;
        end if;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                              || '.Get_Context_Description(:CONTEXT); end;'
                        using out v_rtn, in p_obj_context;

            return v_rtn;
        exception
            when others then
                core_logger.log_it(c_pipe,
                                   'Get_Context_Description: Error during execute immediate: '
                                   || sqlerrm);
                return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Context_Description';
        end;
    exception
        when others then
            core_logger.log_it(c_pipe,
                               'Get_Context_Description: Error encountered using Object '
                               || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in Get_Context_Description using Object: ' || nvl(p_obj, 'NULL');
    end get_context_description;

    function get_objtype(p_obj in varchar2)
        return varchar2 is
        v_ot   varchar2(20);
    begin
        select obj_type
          into v_ot
          from t_core_obj
         where sid = p_obj;

        return v_ot;
    exception
        when no_data_found then
            return null;
    end get_objtype;

    function get_status(p_obj in varchar2)
        return varchar2 is
        v_rtn      varchar2(1000)            := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        v_rtn := 'Invalid parameter passed to Get_Status';
        v_ot_rec.sid := get_objtype(p_obj);

        if v_ot_rec.sid is null then
            raise no_data_found;
        end if;

        v_rtn := 'Could not locate Obj_Type for specified Object';

        select *
          into v_ot_rec
          from t_core_obj_type
         where sid = v_ot_rec.sid;

        if v_ot_rec.method_pkg is null then
            return 'Method package not defined for Obj_Type: ' || v_ot_rec.code;
        end if;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg || '.GET_STATUS(:OBJ); end;'
                        using out v_rtn, in p_obj;

            return v_rtn;
        exception
            when others then
                core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Status';
        end;
    exception
        when no_data_found then
            return v_rtn;
        when others then
            return 'Untrapped error in Get_Status';
    end get_status;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
        v_rtn      clob;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        v_rtn := 'Invalid parameter passed to Get_Summary';
        v_ot_rec.sid := get_objtype(p_obj);

        if v_ot_rec.sid is null then
            raise no_data_found;
        end if;

        v_rtn := 'Could not locate Obj_Type for specified Object';

        select *
          into v_ot_rec
          from t_core_obj_type
         where sid = v_ot_rec.sid;

        if v_ot_rec.method_pkg is null then
            return 'Method package not defined for Obj_Type: ' || v_ot_rec.code;
        end if;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                              || '.GET_SUMMARY(:OBJ, :VAR); end;'
                        using out v_rtn, in p_obj, in p_variant;

            return v_rtn;
        exception
            when others then
                core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Summary';
        end;
    exception
        when no_data_found then
            return v_rtn;
        when others then
            return 'Untrapped error in Get_Summary';
    end get_summary;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_rtn      varchar2(1000)            := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        v_rtn := 'Invalid parameter passed to Get_Tagline';
        v_ot_rec.sid := get_objtype(p_obj);

        if v_ot_rec.sid is null then
            select 'ok'
              into v_rtn
              from t_osi_participant_version
             where sid = p_obj;

            return osi_participant.get_tagline(p_obj);
        else
            v_rtn := 'Could not locate Obj_Type for specified Object';

            select *
              into v_ot_rec
              from t_core_obj_type
             where sid = v_ot_rec.sid;

            if v_ot_rec.method_pkg is null then
                return 'Method package not defined for Obj_Type: ' || v_ot_rec.code;
            end if;

            begin
                execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                                  || '.GET_TAGLINE(:OBJ); end;'
                            using out v_rtn, in p_obj;

                return v_rtn;
            exception
                when others then
                    core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                    return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Tagline';
            end;
        end if;
    exception
        when no_data_found then
            return v_rtn;
        when others then
            return 'Untrapped error in Get_Tagline';
    end get_tagline;

    procedure index1(r in rowid, c in out nocopy clob) is
    begin
        build_index(1, r, c, '<DOC><NONSPECIFIC>SPECIALTOKENTHATSINALLOBJECTS</NONSPECIFIC>');
    end index1;

    procedure index2(r in rowid, c in out nocopy clob) is
    begin
        build_index(2, r, c);
    end index2;

    procedure index3(r in rowid, c in out nocopy clob) is
    begin
        build_index(3, r, c);
    end index3;

    procedure index4(r in rowid, c in out nocopy clob) is
    begin
        build_index(4, r, c);
    end index4;

    procedure index5(r in rowid, c in out nocopy clob) is
    begin
        build_index(5, r, c);
    end index5;

    function lookup_objtype(p_obj_type_code in varchar2)
        return varchar2 is
        v_ot   varchar2(20);
    begin
        select sid
          into v_ot
          from t_core_obj_type
         where code = p_obj_type_code;

        return v_ot;
    exception
        when no_data_found then
            return null;
        when others then
            core_logger.log_it(c_pipe, 'Lookup_ObjType: ' || sqlerrm);
            return null;
    end lookup_objtype;

    function get_inherit_privs_flag(p_obj_type_sid in varchar2) return varchar2 is

         v_return   varchar2(1) := 'N';

    begin
         select decode(inherit_privs_from_parent,'N','Y','N') into v_return from t_core_obj_type where sid=p_obj_type_sid;
         return v_return;
              
    exception when others then

             return v_return;
                  
    end get_inherit_privs_flag;

function get_parentinfo(p_obj in varchar2) return varchar2 is
     
     v_title  varchar2(1000)            := null;
     v_id     varchar2(1000)            := null;
     v_rtn    varchar2(1000)            := null;
     v_ot_rec t_core_obj_type%rowtype;

begin
     for o in (select t.code from t_core_obj o, t_core_obj_type t where o.OBJ_TYPE=t.sid and o.sid=p_obj)
     loop
         case
             
             when o.code like 'ACT%' then
                 
                 v_id := osi_activity.get_id(p_obj);
                 v_title := osi_activity.get_title(p_obj);
                 
                 if substr(v_title, 1, length('Activity: ' || v_id)) = 'Activity: ' || v_id then
                   
                   v_rtn := v_title;
                 
                 else 
                   
                   v_rtn := 'Activity: ' || v_id || ' - ' || v_title;
                   
                 end if;
                 
                 return v_rtn;

             when o.code like 'FILE%' then
                 
                 v_id := osi_file.get_id(p_obj);
                 v_title := osi_file.get_title(p_obj);
                 
                 if substr(v_title, 1, length('File: ' || v_id)) = 'File: ' || v_id then
                   
                   v_rtn := v_title;

                 else 
                   
                   v_rtn := 'File: ' || v_id || ' - ' || v_title;

                 end if;

                 return v_rtn;
             
             else

               return get_tagline(p_obj);
             
         end case;
         
     end loop;
     
exception
    when others then
        return get_tagline(p_obj);
end get_parentinfo;
    
end core_obj;
/









update t_osi_note_type set lock_mode='72HR' 
   where lock_mode is null 
     and description in ('Reviewer Note','Case Strategy','Tech Advice','OES Note','USM Note','DetCo/SAC Note','Bibliography','Specialist Note','Support Staff Note');

update t_osi_note_type set lock_mode='NEVER' 
   where lock_mode is null 
     and description in ('IDP Note');

commit;

begin
     for n in (select * from t_osi_note where lock_mode is null)
     loop
         update t_osi_note set lock_mode=(select lock_mode from t_osi_note_type where sid=n.note_type) where sid=n.sid;
         commit;

     end loop;
end;
/



commit;