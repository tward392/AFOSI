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
--   Date and Time:   09:28 Wednesday June 8, 2011
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

PROMPT ...Remove page 30000
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30000);
 
end;
/

 
--application/pages/page_30000
prompt  ...PAGE 30000: Individual Participant (Search/Create)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'  if("&REQUEST." == "CREATE_RETURN" || "&REQUEST." == "CREATE_UNK_RETURN"){'||chr(10)||
'    passBack("&P30000_SEL_PARTICIPANT.");'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'function passBack(pSid){'||chr(10)||
'  opener.document.getElementById("&P30000_RETURN_ITEM.").value = pSid;'||chr(10)||
'  opener.doSubmit("&P30000_RETURN_ITEM.");'||chr(10)||
'  window.close();'||chr(10)||
'}'||chr(10)||
'function useSelected(pMessage){'||chr(10)||
'  if(confirm(pMessage)){'||chr(10)||
'    passBack("&P30000_SEL_PAR';

ph:=ph||'TICIPANT.");'||chr(10)||
'  }'||chr(10)||
'}'||chr(10)||
'/*'||chr(10)||
' * This function is available to prompt the user. It was being used by button'||chr(10)||
' * #16 but it isn''t right now.'||chr(10)||
' */'||chr(10)||
'function createInstance(pMessage, pRequest){'||chr(10)||
'  if(confirm(pMessage)){'||chr(10)||
'    doSubmit(pRequest);'||chr(10)||
'  }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'if (''&P30000_NEW_PARTIC_SID.''!=''''){'||chr(10)||
'newWindow({page:30005, '||chr(10)||
'                    clear_cache:30005, '||chr(10)||
'                    name:''&P30000_NEW_PARTIC_SID.'', item_names:''';

ph:=ph||'P0_OBJ'', '||chr(10)||
'                    item_values:''&P30000_NEW_PARTIC_SID.'', '||chr(10)||
'                    request:''OPEN''});'||chr(10)||
''||chr(10)||
'close();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30000,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Individual Participant (Search/Create)',
  p_step_title=> 'Search/Create Participant',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="JavaScript">'||chr(10)||
''||chr(10)||
'  if("&P30000_ACTION." == "DEERS_UNCONFIRM")'||chr(10)||
'    {'||chr(10)||
'     if ("&P30000_LAST_NAME." == "")'||chr(10)||
'       {'||chr(10)||
'        var r=false;'||chr(10)||
'        alert("Last Name is Required.");'||chr(10)||
'       }'||chr(10)||
'     else'||chr(10)||
'       var r=confirm("&P30000_DEERS_MSG.");'||chr(10)||
''||chr(10)||
'     if (r==true)'||chr(10)||
'       doSubmit("CREATE");'||chr(10)||
'    }'||chr(10)||
'  '||chr(10)||
'  if("&P30000_ACTION." == "DEERS_CREATED")'||chr(10)||
'    {'||chr(10)||
'     alert("&P30000_DEERS_MSG.");'||chr(10)||
'     doSubmit("DEERS_CREATED");'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
'  if("&P30000_ACTION." == ''DEERS_ERROR'')'||chr(10)||
'    alert("&P30000_DEERS_MSG.");'||chr(10)||
''||chr(10)||
'  if("&P30000_ACTION." == ''DEERS_MSG'')'||chr(10)||
'    alert("&P30000_DEERS_MSG.");'||chr(10)||
'  '||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110608092803',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '22-FEB-2011 J.FARIS WCHG0000371 - Participants Relationships Import, updated Import Legacy Participant process.'||chr(10)||
''||chr(10)||
'12-Apr-2011 Tim Ward CR#3795 - Added Check Last Name null validation.  '||chr(10)||
'                               Last Name is required to create a Participant.'||chr(10)||
''||chr(10)||
'12-Apr-2011 Tim Ward CR#3489 - Changed Footer Javascript to confirm OK/CANCEL '||chr(10)||
'                     CR#3764   if the user wants to create the unconfirmed '||chr(10)||
'                               participant.'||chr(10)||
''||chr(10)||
'08-Jun-2011 Tim Ward CR#3597 - Foreign ID Number Saves and SSN when '||chr(10)||
'                               Creating Participant.  Changed create_instance'||chr(10)||
'                               process to pass number type to'||chr(10)||
'                               osi_participant.create_instance function.');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30000,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30000,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select person_version,'||chr(10)||
'       decode(person_version, :P30000_SEL_LEGACY_PART, ''Y'', ''N'') as "Current",'||chr(10)||
'       Names as "Names",'||chr(10)||
'       score as "Matching Likelihood",'||chr(10)||
'       details as "Reasons for Match"'||chr(10)||
'  from v_osi_migration_partic_hit'||chr(10)||
' where user_session = :P30000_LEGACY_PARTIC_SESSION';

wwv_flow_api.create_report_region (
  p_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_name=> 'Legacy I2MS Participants',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 50,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P30000_CONTINUE = ''Y''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Legacy I2MS Participant Matches Found',
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
  p_id=> 12141531488721506 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PERSON_VERSION',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp.',
  p_column_link=>'javascript:doSubmit(''LVIEW_#PERSON_VERSION#'')',
  p_column_linktext=>'&ICON_EDIT.',
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
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 12136412470592992 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 5,
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
  p_id=> 12200804643144285 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Names',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Names',
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
  p_id=> 12130003009222854 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Matching Likelihood',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Matching Likelihood',
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
  p_id=> 12130128891222854 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Reasons for Match',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Reasons For Match',
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 12140418067698773 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Details of Selected Legacy Participant',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 60,
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
  p_plug_display_when_condition => ':P30000_SEL_LEGACY_PART IS NOT NULL',
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
  p_id=> 89341136016602021 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Search/Create Parameters',
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
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89345512226620324 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
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
s:=s||'select participant,'||chr(10)||
'       decode(participant, :P30000_SEL_PARTICIPANT, ''Y'', ''N'') as "Current",'||chr(10)||
'       last_name as "Last Name",'||chr(10)||
'       first_name as "First Name",'||chr(10)||
'       middle_name as "Middle Name",'||chr(10)||
'       score as "Matching Likelihood",'||chr(10)||
'       info as "Reasons for Match"'||chr(10)||
'  from v_osi_partic_search_result'||chr(10)||
' where session_id = :p30000_session';

wwv_flow_api.create_report_region (
  p_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_name=> 'Existing I2MS Participants',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P30000_CONTINUE = ''Y''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '100000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No matching participants found.',
  p_query_num_rows_type=> 'ROW_RANGES_WITH_LINKS',
  p_query_row_count_max=> '100000',
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
  p_id=> 5589426093214521 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PARTICIPANT',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''VIEW_#PARTICIPANT#'')',
  p_column_linktext=>'&ICON_EDIT.',
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
  p_id=> 91173814978667756 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
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
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 91170916835547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Last Name',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Last Name',
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
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 91171013061547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'First Name',
  p_column_display_sequence=> 3,
  p_column_heading=> 'First Name',
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
  p_id=> 91171138238547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Middle Name',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Middle Name',
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
  p_id=> 91171238301547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Matching Likelihood',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Matching Likelihood',
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
  p_id=> 91171323011547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Reasons for Match',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Reasons For Match',
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 90599109543441349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Details of Selected Participant',
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
  p_plug_display_when_condition => ':P30000_SEL_PARTICIPANT IS NOT NULL',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89405908818791303 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 10,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'SEARCH',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Search',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91222636952661168 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 100,
  p_button_plug_id => 89364113657999253+wwv_flow_api.g_id_offset,
  p_button_name    => 'OPEN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Open Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:newWindow({name:''PARTICIPANT&P30000_SEL_PARTICIPANT.'',              page:30005,              clear_cache:30005,              item_names:''P0_OBJ'',              item_values:''&P30000_SEL_PARTICIPANT.'',              request:''OPEN''});',
  p_button_condition=> 'P30000_SEL_PARTICIPANT',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91222813823661170 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 105,
  p_button_plug_id => 89364113657999253+wwv_flow_api.g_id_offset,
  p_button_name    => 'USE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Use Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:useSelected(''Are you sure you want to associate this participant to another object?'');',
  p_button_condition=> ':P30000_SEL_PARTICIPANT IS NOT NULL AND'||chr(10)||
':P30000_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13050432249930481 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 115,
  p_button_plug_id => 12129308399222823+wwv_flow_api.g_id_offset,
  p_button_name    => 'IMPORT_SELECTED',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Import Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_SEL_LEGACY_PART is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89341331911602023 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 15,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE IS NULL AND :P30000_CONTINUE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91267032597639204 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 16,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE = ''FROM_OBJ'' AND :P30000_CONTINUE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'javascript:createInstance(''This participant will be created UNCONFIRMED and associated to object &P0_OBJ_TAGLINE.. Do you want to continue?'', ''CREATE_RETURN'');',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89418530138686924 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 20,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_UNK',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Unknown Participant',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91329434025836453 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 21,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_UNK_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Unknown Participant',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89341514582602023 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 25,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5917911033397014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30101:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> .5,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST=''CREATE'' and osi_auth.check_access(:P0_OBJ)=''N'';',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2011 13:00 by TWARD');
 
wwv_flow_api.create_page_branch(
  p_id=>89341722159602023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30005:&SESSION.:OPEN:&DEBUG.:30000::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 1,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST IN (''CREATE'', ''CREATE_UNK'', ''DEERS_CREATED'')',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>89406229948791306 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30000:&SESSION.:&REQUEST.:&DEBUG.::P30000_CONTINUE,P30000_SEL_PARTICIPANT:Y,',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>89405908818791303+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>89345334474607882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30000:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 14:31 by RECHER');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3670711603404937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DEERS_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>3670904055404950 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DEERS_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>3809010655211925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
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
  p_id=>5612126859820320 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 204,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SESSION',
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
  p_id=>12128015091082846 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LEGACY_PARTIC_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_LEGACY_PARTIC_SESSION',
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
  p_id=>12135209091573150 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_LEGACY_PART',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 12129308399222823+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEL_LEGACY_PART',
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
  p_id=>12140730534702298 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_LEGACY_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 12140418067698773+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_legacy_part_details(:P30000_SEL_LEGACY_PART);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'width=100%',
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
  p_id=>13051211518952871 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NEW_PARTIC_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 12140418067698773+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_NEW_PARTIC_SID',
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
  p_id=>89341938654602024 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_PARTICIPANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEL_PARTICIPANT',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
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
  p_id=>89367113059055907 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 205,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_pre_element_text=>'<h1>',
  p_post_element_text=>'</h1><tr><td width="155" rowspan="3" colspan="3">&nbsp;</td>',
  p_source=>'The first three letters of last name and Social Security/Foreign ID # are required to search DEERS.',
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
  p_colspan => 6,
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
  p_id=>89367333622071267 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LAST_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Last Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 100,
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
  p_id=>89367517823076190 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_FIRST_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 225,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'First Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
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
  p_id=>89367909989083378 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 5,
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
  p_id=>89368629167098340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DOB',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Birthdate',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>89368936224109821 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sex',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P30000_SEX_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Sex -',
  p_lov_null_value=> '',
  p_cSize=> 10,
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
  p_id=>89405434052770254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_CONTINUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_CONTINUE=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>90599516946452935 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 400,
  p_item_plug_id => 90599109543441349+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_PARTICIPANT.GET_DETAILS(:P30000_SEL_PARTICIPANT);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'width=100%',
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
  p_id=>91259033619437731 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_RETURN_ITEM=',
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
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91262816181199224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_MODE=',
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
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93263632644079337 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 235,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_partic_number_type'||chr(10)||
'   where active = ''Y'''||chr(10)||
'      or sid = :p30000_number_type'||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 6,
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
  p_id=>95045621212372757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 201,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'dibrs_reference.get_lov(''SEX'',:p30000_sex);',
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
  p_id=>95545015495471757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SSN_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 203,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select sid'||chr(10)||
'  from t_osi_partic_number_type'||chr(10)||
' where code = ''SSN''',
  p_source_type=> 'QUERY',
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
  p_id=>96758123524419584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_FNAME_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_FNAME_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758315968419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LNAME_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_LNAME_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758522773419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_NUMBER_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758717427419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DOB_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_DOB_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>96758908934419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEX_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95544834972458520 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Numeric SSN',
  p_validation_sequence=> 1,
  p_validation => 'P30000_NUMBER_VALUE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => 'SSN must be numeric.',
  p_validation_condition=> ':request = ''SEARCH'' and :p30000_number_type = :p30000_ssn_type',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 1175616794373923 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'DOB is valid date',
  p_validation_sequence=> 2,
  p_validation => 'P30000_DOB',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'DOB must be a valid date.',
  p_validation_condition=> ':request = ''SEARCH''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89368629167098340 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89416938619651515 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Not null search terms',
  p_validation_sequence=> 5,
  p_validation => ':P30000_LAST_NAME IS NOT NULL OR '||chr(10)||
':P30000_FIRST_NAME IS NOT NULL OR'||chr(10)||
':P30000_NUMBER_VALUE IS NOT NULL',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'Must supply a first name, last name or SSN number.',
  p_validation_condition=> 'SEARCH',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95801423087059968 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'SSN is numeric',
  p_validation_sequence=> 10,
  p_validation => 'P30000_NUMBER_VALUE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => 'SSN must be numeric.',
  p_validation_condition=> ':P30000_NUMBER_TYPE = :P30000_SSN_TYPE AND'||chr(10)||
':REQUEST = ''CREATE'' OR'||chr(10)||
':REQUEST = ''CREATE_RETURN''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95801713306075979 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'SSN is 9 digits',
  p_validation_sequence=> 15,
  p_validation => 'begin'||chr(10)||
'  if(:p30000_number_type = :p30000_ssn_type)then'||chr(10)||
'      if(   length(:p30000_number_value) = 9'||chr(10)||
'         or :p30000_number_value is null)then'||chr(10)||
'        return true;'||chr(10)||
'      else'||chr(10)||
'        return false;'||chr(10)||
'      end if;'||chr(10)||
'  else'||chr(10)||
'    return true;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'SSN must be nine digits.',
  p_validation_condition=> 'CREATE,CREATE_RETURN,SEARCH',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96773724440836168 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check last name',
  p_validation_sequence=> 20,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_lname_old is not null) then'||chr(10)||
'        if (:p30000_lname_old = :p30000_last_name) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_lname_old is null and :p30000_last_name is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The last name has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96806310073287789 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check first name',
  p_validation_sequence=> 21,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_fname_old is not null) then'||chr(10)||
'        if (:p30000_fname_old = :p30000_first_name) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_fname_old is null and :p30000_first_name is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The first name has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808013068354920 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check number',
  p_validation_sequence=> 22,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_number_old is not null) then'||chr(10)||
'        if (:p30000_number_old = :p30000_number_value) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_number_old is null and :p30000_number_value is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The number value has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808408351363045 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check DOB',
  p_validation_sequence=> 23,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_dob_old is not null) then'||chr(10)||
'        if (:p30000_dob_old = :p30000_dob) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_dob_old is null and :p30000_dob is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The birthdate has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808625320367978 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check sex',
  p_validation_sequence=> 24,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_sex_old is not null) then'||chr(10)||
'        if (:p30000_sex_old = :p30000_sex) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_sex_old is null and :p30000_sex is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The sex value has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 5275827908497509 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check Last Name null',
  p_validation_sequence=> 34,
  p_validation => 'begin'||chr(10)||
'    if(:p30000_last_name is null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The last name is a required field.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
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
p:=p||'begin'||chr(10)||
''||chr(10)||
'  :P30000_SEL_LEGACY_PART := null;'||chr(10)||
''||chr(10)||
'  osi_participant.check_for_matches(:p30000_number_value,'||chr(10)||
'                                    :p30000_number_type,'||chr(10)||
'                                    :p30000_dob,'||chr(10)||
'                                    :p30000_last_name,'||chr(10)||
'                                    :p30000_first_name,'||chr(10)||
'                                    :p30000_sex,'||chr(10)||
'                                 ';

p:=p||'   :p30000_session,'||chr(10)||
'                                    :p30000_legacy_partic_session,'||chr(10)||
'                                    :p30000_deers_result);'||chr(10)||
''||chr(10)||
'  :debug := ''deers result: '' || :p30000_deers_result;'||chr(10)||
''||chr(10)||
'  --- If this is true then a DEERS query was made. ---'||chr(10)||
'  if (:p30000_session is null) then'||chr(10)||
''||chr(10)||
'     --- If this is true then a DEERS error occured. ---'||chr(10)||
'     if (:p30000_deers_result is null) then'||chr(10)||
''||chr(10)||
'    ';

p:=p||'   :p30000_deers_msg := ltrim(osi_deers.get_import_message, ''MSG '') || ''\nUnconfirmed participant will be created.'';'||chr(10)||
'       :p30000_action := ''DEERS_UNCONFIRM'';'||chr(10)||
''||chr(10)||
'     elsif(instr(:p30000_deers_result, ''ERROR'') > 0) then'||chr(10)||
''||chr(10)||
'         :p30000_deers_msg := ltrim(:p30000_deers_result, ''ERROR '');'||chr(10)||
'         :p30000_action := ''DEERS_ERROR'';'||chr(10)||
' '||chr(10)||
'    elsif(instr(:p30000_deers_result, ''MSG'') > 0) then'||chr(10)||
''||chr(10)||
'         :';

p:=p||'p30000_deers_msg := ltrim(:p30000_deers_result, ''MSG '');'||chr(10)||
'         :p30000_action := ''DEERS_MSG'';'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
''||chr(10)||
'      --- A new participant was created and we have a version sid. ---'||chr(10)||
'      :p0_obj := osi_participant.get_participant(:p30000_deers_result);'||chr(10)||
'      :p30000_deers_msg := ''DEERS match found. Confirmed participant was created.'';'||chr(10)||
'      :p30000_action := ''DEERS_CREATED'';'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'';

p:=p||''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5578311932812948 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check for matches',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SEARCH',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'begin'||chr(10)||
'    :P30000_SEL_LEGACY_PART := null;'||chr(10)||
''||chr(10)||
'    osi_participant.check_for_matches(:p30000_number_value,'||chr(10)||
'                                      :p30000_number_type,'||chr(10)||
'                                      :p30000_dob,'||chr(10)||
'                                      :p30000_last_name,'||chr(10)||
'                                      :p30000_first_name,'||chr(10)||
'                                      :p30000_sex,'||chr(10)||
'                                      :p30000_session,'||chr(10)||
'                                      :p30000_legacy_partic_session,'||chr(10)||
'                                      :p30000_deers_result);'||chr(10)||
'    :debug := ''deers result: '' || :p30000_deers_result;'||chr(10)||
''||chr(10)||
'    -- If this is true then a DEERS query was made.'||chr(10)||
'    if (:p30000_session is null) then'||chr(10)||
'        -- If this is true then a DEERS error occured.'||chr(10)||
'        if (:p30000_deers_result is null) then'||chr(10)||
'            :p30000_deers_msg :='||chr(10)||
'                ltrim(osi_deers.get_import_message, ''MSG '')'||chr(10)||
'                || ''\nUnconfirmed participant will be created.'';'||chr(10)||
'            :p30000_action := ''DEERS_UNCONFIRM'';'||chr(10)||
'        elsif(instr(:p30000_deers_result, ''ERROR'') > 0) then'||chr(10)||
'            :p30000_deers_msg := ltrim(:p30000_deers_result, ''ERROR '');'||chr(10)||
'            :p30000_action := ''DEERS_ERROR'';'||chr(10)||
'        elsif(instr(:p30000_deers_result, ''MSG'') > 0) then'||chr(10)||
'            :p30000_deers_msg := ltrim(:p30000_deers_result, ''MSG '');'||chr(10)||
'            :p30000_action := ''DEERS_MSG'';'||chr(10)||
'        else'||chr(10)||
'            -- A new participant was created and we have a version sid.'||chr(10)||
'            :p0_obj := osi_participant.get_participant(:p30000_deers_result);'||chr(10)||
'            :p30000_deers_msg := ''DEERS match found. Confirmed participant was created.'';'||chr(10)||
'            :p30000_action := ''DEERS_CREATED'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
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
p:=p||'declare'||chr(10)||
'    v_sid varchar2(1000);'||chr(10)||
'begin'||chr(10)||
'    if (:request like ''CREATE_UNK%'') then'||chr(10)||
'        v_sid :='||chr(10)||
'            osi_participant.create_instance();'||chr(10)||
''||chr(10)||
'        if (:request = ''CREATE_UNK_RETURN'') then'||chr(10)||
'            :p30000_sel_participant := v_sid;'||chr(10)||
'        else'||chr(10)||
'            :p0_obj := v_sid;'||chr(10)||
'        end if;'||chr(10)||
'    else'||chr(10)||
'        v_sid :='||chr(10)||
'            osi_participant.create_instance(:p30000_last_name,'||chr(10)||
'          ';

p:=p||'                                  :p30000_first_name,'||chr(10)||
'                                            :p30000_number_value,'||chr(10)||
'                                            :p30000_dob,'||chr(10)||
'                                            :p30000_sex,'||chr(10)||
'                                            ''N'','||chr(10)||
'                                            :p30000_number_type);'||chr(10)||
'        if (:request = ''CREATE_RETURN'') then'||chr(10)||
'      ';

p:=p||'      :p30000_sel_participant := v_sid;'||chr(10)||
'        else'||chr(10)||
'            :p0_obj := v_sid;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90630618723532185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create instance',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''CREATE%''',
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
p:=p||'delete t_osi_partic_search_result where session_id = :p30000_session;';

wwv_flow_api.create_page_process(
  p_id     => 5620119062130325 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear search results',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':request like ''%CREATE%''',
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
p:=p||':P30000_SEL_PARTICIPANT := SUBSTR(:REQUEST, 6);';

wwv_flow_api.create_page_process(
  p_id     => 91172133539588020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select participant',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''VIEW_%'';',
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
p:=p||':P30000_SEL_LEGACY_PART := SUBSTR(:REQUEST, 7);';

wwv_flow_api.create_page_process(
  p_id     => 12135319134576042 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Legacy participant',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''LVIEW_%'';',
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
'my_exception exception;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     :P30000_NEW_PARTIC_SID := osi_participant.import_legacy_participant(:P30000_SEL_LEGACY_PART);'||chr(10)||
'     if :P30000_NEW_PARTIC_SID like ''Error:%'' then'||chr(10)||
'        raise my_exception;'||chr(10)||
'     end if;'||chr(10)||
'exception'||chr(10)||
'    when my_exception then'||chr(10)||
'         raise;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13051332642958923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Import Legacy Participant',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Error importing legacy participant',
  p_process_when=>':REQUEST = ''IMPORT_SELECTED'';',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'Legacy Participant Imported',
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
'    :p30000_lname_old := :p30000_last_name;'||chr(10)||
'    :p30000_fname_old := :p30000_first_name;'||chr(10)||
'    :p30000_number_old := :p30000_number_value;'||chr(10)||
'    :p30000_dob_old := :p30000_dob;'||chr(10)||
'    :p30000_sex_old := :p30000_sex;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 96760115391455048 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 15,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Save search terms',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SEARCH',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30000
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
