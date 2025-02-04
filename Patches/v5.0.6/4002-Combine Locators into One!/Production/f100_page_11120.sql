--application/pages/page_11120
prompt  ...PAGE 11120: Matters Investigated
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_LOCATOR"'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 11120,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Matters Investigated',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onLoad="javascript:setFocus(''P11120_OFFENSE_CODE'');"',
  p_step_sub_title => 'Matters Investigated',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_welcome_text=> '<script type="text/javascript">'||chr(10)||
' function setFocus(PageItem) '||chr(10)||
' {'||chr(10)||
'  var mode = document.getElementById(''P11120_MODE'');'||chr(10)||
'  var ele = document.getElementById(PageItem);'||chr(10)||
''||chr(10)||
'  //var ele_selector = document.getElementById(''P11120_OFFENSE_SELECTOR'');'||chr(10)||
''||chr(10)||
'//  if(ele_selector!=null)'||chr(10)||
'//    {'||chr(10)||
'     if(mode!=null)'||chr(10)||
'       {'||chr(10)||
'        if(mode.value==''ADD'')'||chr(10)||
'          {'||chr(10)||
'           if (ele!=null)'||chr(10)||
'             {'||chr(10)||
'              ele.focus();'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
'//    }'||chr(10)||
' }'||chr(10)||
' '||chr(10)||
' function showLocatorIfNeeded()'||chr(10)||
' {'||chr(10)||
'  var excludes = document.getElementById(''P11120_EXCLUDE_SIDS'');'||chr(10)||
'  var ele_selector = document.getElementById(''P11120_OFFENSE_SELECTOR'');'||chr(10)||
''||chr(10)||
'  if(ele_selector!=null)'||chr(10)||
'    {'||chr(10)||
'     popupLocator(550,''P11120_OFFENSE'',''Y'', excludes.value);'||chr(10)||
'    }'||chr(10)||
' }'||chr(10)||
'</script>',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'  if(''&REQUEST.'' == ''CREATE'' && ''&P11120_SEL_OFFENSE.'' == ''''){'||chr(10)||
'    checkPrimary(''CREATE_SP'');'||chr(10)||
'  }else if(''&REQUEST.'' == ''SAVE''){'||chr(10)||
'    checkPrimary(''SAVE_SP'');'||chr(10)||
'  }'||chr(10)||
'    '||chr(10)||
'  function checkPrimary(pRequest){'||chr(10)||
'    var resubmit = true;'||chr(10)||
'    var message = ''A primary offense already exists. Would you like to make this one the new primary offense?'';'||chr(10)||
'    if(   ''&P11120_PRIMARY_EXISTS.'' == ''Y'''||chr(10)||
'       && ''&P11120_PRIORITY.'' == ''&P11120_PRIMARY_SID.''){'||chr(10)||
'      if(window.confirm(message)){'||chr(10)||
'        $s(''P11120_NEW_PRIMARY'',''Y'');'||chr(10)||
'      }else{'||chr(10)||
'        $s(''P11120_NEW_PRIMARY'',''N'');'||chr(10)||
'        resubmit = false;'||chr(10)||
'      }'||chr(10)||
'    }'||chr(10)||
'    if(resubmit){'||chr(10)||
'      doSubmit(pRequest);'||chr(10)||
'    }'||chr(10)||
'  }'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817023621004643+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110517132949',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '17-May-2011 - Tim Ward - CR#3787 - Adding Crime Against Society doesn''t add'||chr(10)||
'                         Society as a victim.  Rewrote the After Submit'||chr(10)||
'                         Process "Create Society Victim" so it fires on'||chr(10)||
'                         P11120_OFFENSE Request and splits the Selected'||chr(10)||
'                         Offenses to see if it needs to add SOCIETY.'||chr(10)||
''||chr(10)||
'17-May-2011 - Tim Ward - Changed Offense Report to fit Width 100%.'||chr(10)||
''||chr(10)||
'17-May-2011 - Tim Ward - CR#3678 - Changed "Special Processing" process to'||chr(10)||
'                         delete the specification.  Also changed the'||chr(10)||
'                         deletion confirmation message to match Legacy'||chr(10)||
'                         stating that Specs will be deleted.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>11120,p_text=>ph);
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
  p_id=> 94018317836378034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11120,
  p_plug_name=> 'Details of Selected Offense',
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
  p_plug_display_when_condition => ':P11120_SEL_OFFENSE is not null or :P11120_MODE = ''ADD''',
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
s:=s||'select io.sid "SID",'||chr(10)||
'       pri.description "Priority",'||chr(10)||
'       off.code "Offense ID",'||chr(10)||
'       off.nibrs_code "NIBRS Code",'||chr(10)||
'       off.class_code "Class",'||chr(10)||
'       off.description "Description",'||chr(10)||
'       off.crime_against "Crime Against",'||chr(10)||
'       decode(:P11120_SEL_OFFENSE, io.sid, ''Y'', ''N'') "Current"'||chr(10)||
'  from t_osi_f_inv_offense io,'||chr(10)||
'       t_dibrs_offense_type off,'||chr(10)||
'       t_osi_reference pri'||chr(10)||
' where io.inv';

s:=s||'estigation = :P0_OBJ'||chr(10)||
'   and io.offense = off.sid'||chr(10)||
'   and pri.sid(+) = io.priority';

wwv_flow_api.create_report_region (
  p_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11120,
  p_name=> 'Offenses',
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
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '9999',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Offenses found.',
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
  p_plug_query_exp_filename=> '&P11120_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96246031316772665 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
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
  p_id=> 96245038795768009 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Priority',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Priority',
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
  p_id=> 96245116479768014 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Offense ID',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Offense ID',
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
  p_id=> 96245233690768014 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'NIBRS Code',
  p_column_display_sequence=> 4,
  p_column_heading=> 'NIBRS Code',
  p_column_alignment=>'CENTER',
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
  p_id=> 96245334302768014 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Class',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Class',
  p_column_alignment=>'CENTER',
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
  p_id=> 96245430030768014 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Description',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Description',
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
  p_id=> 96245506314768014 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Crime Against',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Crime Against',
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
  p_id=> 96307131811581832 + wwv_flow_api.g_id_offset,
  p_region_id=> 96244715386767984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 8,
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
s:=s||'select i.incident_id "Incident ID",'||chr(10)||
'       o.description "Offense Description",'||chr(10)||
'       osi_object.get_tagline_link(s.subject) "Subject",'||chr(10)||
'       osi_object.get_tagline_link(s.victim) "Victim"'||chr(10)||
'  from t_osi_f_inv_spec s,'||chr(10)||
'       t_osi_f_inv_incident i,'||chr(10)||
'       t_dibrs_offense_type o'||chr(10)||
' where s.investigation = :P0_OBJ'||chr(10)||
'   and s.offense = :P11120_OFFENSE'||chr(10)||
'   and i.sid = s.incident'||chr(10)||
'   and o.sid = s.offense';

wwv_flow_api.create_report_region (
  p_id=> 97312731000857004 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 11120,
  p_name=> 'Specifications for Selected Offense',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 40,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> 'P11120_SEL_OFFENSE',
  p_display_condition_type=> 'ITEM_IS_NOT_NULL',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'QUERY_COLUMNS',
  p_query_num_rows=> '10000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Specifications found.',
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
  p_plug_query_exp_filename=> '&P11120_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 97313031748857007 + wwv_flow_api.g_id_offset,
  p_region_id=> 97312731000857004 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'Incident ID',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Incident Id',
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
  p_id=> 97313130691857007 + wwv_flow_api.g_id_offset,
  p_region_id=> 97312731000857004 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Offense Description',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Offense Description',
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
  p_id=> 97313230884857007 + wwv_flow_api.g_id_offset,
  p_region_id=> 97312731000857004 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Subject',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Subject',
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
  p_id=> 97313307190857007 + wwv_flow_api.g_id_offset,
  p_region_id=> 97312731000857004 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Victim',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Victim',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 96298713916434681 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11120,
  p_button_sequence=> 50,
  p_button_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Offense',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 94018536708378037 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11120,
  p_button_sequence=> 10,
  p_button_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11120_SEL_OFFENSE',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96212026900218014 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11120,
  p_button_sequence=> 30,
  p_button_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P11120_SEL_OFFENSE',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96213026732255785 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11120,
  p_button_sequence=> 40,
  p_button_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(''Warning: deleting the selected Offense will cause any Specifications and Dispositions that use this Offense to be deleted permanently.'',''DELETE'');',
  p_button_condition=> 'P11120_SEL_OFFENSE',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15864125292542648 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11120,
  p_button_sequence=> 60,
  p_button_plug_id => 97312731000857004+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this,11120);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15865608239556673 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11120,
  p_button_sequence=> 70,
  p_button_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this,11120);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 94018712219378037 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 11120,
  p_button_sequence=> 20,
  p_button_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>94019030600378039 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 16:49 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>94019236558378039 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_branch_action=> 'f?p=&APP_ID.:11120:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 13:53 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7466803966859760 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_OFFENSE_SELECTOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_post_element_text=>'<a href="javascript:popupLocator(550,''P11120_OFFENSE'',''Y'', ''&P11120_EXCLUDE_SIDS.'');">&ICON_LOCATOR.</a>'||chr(10)||
'',
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
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P11120_SEL_OFFENSE',
  p_display_when_type=>'ITEM_IS_NULL',
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
  p_id=>15864809147547440 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
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
  p_id=>17072823376722710 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_PRIMARY_EXISTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11120_PRIMARY_EXISTS=',
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
  p_id=>17088217132995359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_NEW_PRIMARY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11120_NEW_PRIMARY=',
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
  p_id=>17134300377031387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_PRIMARY_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11120_PRIMARY_SID=',
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
  p_id=>18644300419861253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_EXCLUDE_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
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
  p_id=>96213613011261334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_SEL_OFFENSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11120_SEL_OFFENSE=',
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
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96237225888145014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_INVESTIGATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => ':P0_OBJ',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_source=>'INVESTIGATION',
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
  p_id=>96237637316148334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_OFFENSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11120_OFFENSE=',
  p_source=>'OFFENSE',
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
  p_id=>96240938017705071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_OFFENSE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Offense ID',
  p_source=>'select code'||chr(10)||
'  from t_dibrs_offense_type'||chr(10)||
' where sid = :P11120_OFFENSE',
  p_source_type=> 'QUERY',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'readOnly onFocus="showLocatorIfNeeded();"',
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
  p_id=>96298506512423085 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_OFFENSE_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Offense Description',
  p_source=>'select description'||chr(10)||
'  from t_dibrs_offense_type'||chr(10)||
' where sid = :P11120_OFFENSE',
  p_source_type=> 'QUERY',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 200,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'readOnly',
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
  p_id=>96303116742539592 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_PRIORITY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'declare'||chr(10)||
'    v_priority_code      t_osi_reference.code%type;'||chr(10)||
'    v_default_priority   t_osi_reference.sid%type;'||chr(10)||
'    v_offense_count      number                      := 0;'||chr(10)||
'begin'||chr(10)||
'    select count(1)'||chr(10)||
'      into v_offense_count'||chr(10)||
'      from t_osi_f_inv_offense'||chr(10)||
'     where investigation = :p0_obj;'||chr(10)||
''||chr(10)||
'    if v_offense_count > 0 then'||chr(10)||
'        v_priority_code := ''R'';'||chr(10)||
'    else'||chr(10)||
'        v_priority_code := ''P'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    begin'||chr(10)||
'        select sid'||chr(10)||
'          into v_default_priority'||chr(10)||
'          from t_osi_reference'||chr(10)||
'         where usage = ''OFFENSE_PRIORITY'' and code = v_priority_code;'||chr(10)||
'    exception'||chr(10)||
'        when no_data_found then'||chr(10)||
'            null;'||chr(10)||
'    end;'||chr(10)||
''||chr(10)||
'    return v_default_priority;'||chr(10)||
'end;',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_prompt=>'Priority',
  p_source=>'PRIORITY',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P11120_PRIORITY_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Priority -',
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
  p_id=>96304117351558773 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_PRIORITY_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 94018317836378034+wwv_flow_api.g_id_offset,
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
  p_id=>96309626233627564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_name=>'P11120_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 96244715386767984+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P11120_MODE=',
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
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 17172431833404631 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_computation_sequence => 10,
  p_computation_item=> 'P11120_PRIMARY_EXISTS',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select decode(count(sid), 0, ''N'', ''Y'')'||chr(10)||
'  from t_osi_f_inv_offense o'||chr(10)||
' where o.investigation = :p0_obj and o.priority = osi_reference.lookup_ref_sid(''OFFENSE_PRIORITY'', ''P'');',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 17171714864399720 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 11120,
  p_computation_sequence => 10,
  p_computation_item=> 'P11120_PRIMARY_SID',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_reference.lookup_ref_sid(''OFFENSE_PRIORITY'', ''P'');',
  p_compute_when => '',
  p_compute_when_type=>'%null%');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96300722667494010 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_validation_name => 'P11120_OFFENSE not null',
  p_validation_sequence=> 10,
  p_validation => 'P11120_OFFENSE_DESCRIPTION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Offense must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96240938017705071 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96312732859657785 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_validation_name => 'P11120_PRIORITY not null',
  p_validation_sequence=> 20,
  p_validation => 'P11120_PRIORITY',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Priority must be specified.',
  p_validation_condition=> 'CREATE,SAVE,DELETE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 96303116742539592 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 7147529215713821 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_validation_name => 'Check Spec/Property for Offense',
  p_validation_sequence=> 40,
  p_validation => 'declare '||chr(10)||
''||chr(10)||
'v_count varchar2(10) := 0;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'select count(*)'||chr(10)||
'into v_count'||chr(10)||
'from t_osi_f_inv_spec s, t_osi_f_inv_offense o, t_osi_f_inv_property p'||chr(10)||
'where s.INVESTIGATION = o.INVESTIGATION'||chr(10)||
'and s.OFFENSE = o.OFFENSE'||chr(10)||
'and s.sid = p.SPECIFICATION(+)'||chr(10)||
'and o.investigation = :P0_OBJ'||chr(10)||
'and s.offense = :P11120_OFFENSE;'||chr(10)||
''||chr(10)||
'if (v_count > 0)then'||chr(10)||
''||chr(10)||
'return false;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'return true;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The offense you are trying to delete is on a specification and/or a property/drug record. ',
  p_validation_condition_type=> 'NEVER',
  p_when_button_pressed=> 96213026732255785 + wwv_flow_api.g_id_offset,
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
'    if (:request = ''CREATE_SP'') then'||chr(10)||
'        insert into t_osi_f_inv_offense'||chr(10)||
'                    (investigation, offense, priority)'||chr(10)||
'             values (:p11120_investigation, :p11120_offense, :p11120_priority)'||chr(10)||
'          returning sid'||chr(10)||
'               into :p11120_sel_offense;'||chr(10)||
''||chr(10)||
'        if (:p11120_new_primary = ''Y'') then'||chr(10)||
'            update t_osi_f_inv_offense'||chr(10)||
'               set priority = osi_';

p:=p||'reference.lookup_ref_sid(''OFFENSE_PRIORITY'', ''R'')'||chr(10)||
'             where investigation = :p0_obj'||chr(10)||
'               and priority = :p11120_primary_sid'||chr(10)||
'               and sid <> :p11120_sel_offense;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:request = ''SAVE_SP'') then'||chr(10)||
'        if (:p11120_new_primary = ''Y'') then'||chr(10)||
'            update t_osi_f_inv_offense'||chr(10)||
'               set priority = osi_reference.lookup_ref_sid(''OFFENSE_PRIORI';

p:=p||'TY'', ''R'')'||chr(10)||
'             where investigation = :p0_obj'||chr(10)||
'               and priority = :p11120_primary_sid'||chr(10)||
'               and sid <> :p11120_sel_offense;'||chr(10)||
''||chr(10)||
'            update t_osi_f_inv_offense'||chr(10)||
'               set priority = :p11120_primary_sid'||chr(10)||
'             where sid = :p11120_sel_offense;'||chr(10)||
'        else'||chr(10)||
'            update t_osi_f_inv_offense'||chr(10)||
'               set offense = :p11120_offense,'||chr(10)||
'                ';

p:=p||'   priority = :p11120_priority'||chr(10)||
'             where sid = :p11120_sel_offense;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:request = ''DELETE'') then'||chr(10)||
'         '||chr(10)||
'         delete from t_osi_f_inv_spec '||chr(10)||
'               where investigation=:p11120_investigation and offense=:p11120_offense;'||chr(10)||
''||chr(10)||
'         delete from t_osi_f_inv_offense where sid = :p11120_sel_offense;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 17087908475992887 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Special Processing',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>':REQUEST IN (''CREATE_SP'',''SAVE_SP'',''DELETE'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
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
p:=p||':P11120_SEL_OFFENSE := substr(:REQUEST,6);';

wwv_flow_api.create_page_process(
  p_id     => 96300232317468382 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Offense',
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
'    if (:request in (''ADD'',''DELETE'')) then'||chr(10)||
'        :p11120_sel_offense := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request in (''ADD'', ''DELETE'', ''CANCEL'') or :request like ''EDIT_%'') then'||chr(10)||
'        :p11120_offense := null;'||chr(10)||
'        :p11120_priority := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 96300437081488760 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear Items',
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
p:=p||'if :request in (''ADD'',''CREATE'',''P11120_OFFENSE'') then'||chr(10)||
'  :p11120_mode := ''ADD'';'||chr(10)||
'else'||chr(10)||
'  :p11120_mode := null;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 96309213420623849 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 40,
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
p:=p||'declare '||chr(10)||
'    '||chr(10)||
'  v_victim_sid varchar2(20);'||chr(10)||
'  V_society_sid varchar2(20);'||chr(10)||
'  v_society_exists varchar2(10);'||chr(10)||
'  '||chr(10)||
'  v_society_offense_count number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  --- Get SID of Proper Society ---'||chr(10)||
'  select sid into v_society_sid from t_osi_participant_version'||chr(10)||
'   where participant = core_util.get_config(''OSI.SOCIETY_SID'');'||chr(10)||
''||chr(10)||
'  --- Check to see if Society Already Exists as a Victim ---'||chr(10)||
'  select count(*) into v';

p:=p||'_society_exists from t_osi_partic_involvement PI, '||chr(10)||
'                                             t_osi_participant p, '||chr(10)||
'                                             t_osi_partic_role_type prt'||chr(10)||
'   where PI.OBJ = :P0_OBJ and '||chr(10)||
'         p.current_version = pi.participant_version and '||chr(10)||
'         pi.participant_version = v_society_sid and '||chr(10)||
'         pi.involvement_role = prt.sid and '||chr(10)||
'         prt.role = ''Vict';

p:=p||'im'' and '||chr(10)||
'         prt.usage = ''VICTIM'';'||chr(10)||
'  '||chr(10)||
'  --- Society Doesn''t Exist, add it if one of the new offense is against Society ---'||chr(10)||
'  if (v_society_exists = 0) then '||chr(10)||
'    '||chr(10)||
'    --- How many Offense Select are Against Society ---'||chr(10)||
'    select count(*) into v_society_offense_count from t_dibrs_offense_type'||chr(10)||
'          where sid in '||chr(10)||
'           (select * from table(split(:p11120_offense, '':'')) '||chr(10)||
'                ';

p:=p||'   where column_value is not null)'||chr(10)||
'            and crime_against=''Society'';'||chr(10)||
'    '||chr(10)||
'    --- If one Offense Selected is a Crime Against Society ---'||chr(10)||
'    if (v_society_offense_count > 0 ) then'||chr(10)||
''||chr(10)||
'      --- Get Victim Role Type ---'||chr(10)||
'      select sid into v_victim_sid from t_osi_partic_role_type '||chr(10)||
'       where role = ''Victim'' and '||chr(10)||
'             usage = ''VICTIM'' and '||chr(10)||
'             obj_type = core_obj.lookup_objt';

p:=p||'ype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'      insert into T_OSI_PARTIC_INVOLVEMENT (OBJ, PARTICIPANT_VERSION,  INVOLVEMENT_ROLE)'||chr(10)||
'           values (:P0_OBJ, v_society_sid, v_victim_sid);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8806404014970901 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Society Victim',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11120_OFFENSE',
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'  v_temp            varchar2(4000);'||chr(10)||
'  v_off_sid         varchar2(20);'||chr(10)||
'  v_prime_role      varchar2(20);'||chr(10)||
'  v_report_role     varchar2(20);'||chr(10)||
'  v_prime_count     number := 0;'||chr(10)||
'  v_off_count       number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     v_temp := replace(:P11120_OFFENSE, '':'', ''~'');'||chr(10)||
''||chr(10)||
'     if substr(v_temp,1,1) <> ''~'' then'||chr(10)||
'       '||chr(10)||
'       v_temp := ''~'' || v_temp;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if substr(v_temp,length(v_temp),1)';

p:=p||' <> ''~'' then'||chr(10)||
'       '||chr(10)||
'       v_temp := v_temp || ''~'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     --- Get Sid for Primary Offense ---'||chr(10)||
'     select sid into v_prime_role'||chr(10)||
'       from t_osi_reference'||chr(10)||
'      where usage=''OFFENSE_PRIORITY'''||chr(10)||
'        and code=''P'';'||chr(10)||
''||chr(10)||
'     --- Get Sid for Reportable Offense ---'||chr(10)||
'     select sid into v_report_role'||chr(10)||
'       from t_osi_reference'||chr(10)||
'      where usage=''OFFENSE_PRIORITY'''||chr(10)||
'        and code=''R'';'||chr(10)||
'   ';

p:=p||' '||chr(10)||
'     --- Check to See if a Lead Agent Exists ---'||chr(10)||
'     select count(*) into v_prime_count from t_osi_f_inv_offense'||chr(10)||
'       where investigation=:p0_obj and priority=v_prime_role;'||chr(10)||
''||chr(10)||
'     for i in 1 .. core_list.count_list_elements(v_temp)'||chr(10)||
'     loop'||chr(10)||
'         v_off_sid := core_list.get_list_element(v_temp,i); '||chr(10)||
'         '||chr(10)||
'         select count(*) into v_off_count from t_osi_f_inv_offense '||chr(10)||
'               ';

p:=p||'where investigation=:p0_obj and offense=v_off_sid;'||chr(10)||
'         '||chr(10)||
'         if v_off_count = 0 then'||chr(10)||
''||chr(10)||
'           if v_prime_count = 0 then'||chr(10)||
''||chr(10)||
'             insert into t_osi_f_inv_offense (investigation, offense, priority)'||chr(10)||
'                        values (:p0_obj, v_off_sid, v_prime_role)'||chr(10)||
'                              returning sid into :P11120_SEL_OFFENSE;'||chr(10)||
''||chr(10)||
'             v_prime_count := v_prime_count + 1;'||chr(10)||
''||chr(10)||
'';

p:=p||'           else'||chr(10)||
''||chr(10)||
'             insert into t_osi_f_inv_offense (investigation, offense, priority)'||chr(10)||
'                        values (:p0_obj, v_off_sid, v_report_role)'||chr(10)||
'                              returning sid into :P11120_SEL_OFFENSE;'||chr(10)||
''||chr(10)||
'           end if; '||chr(10)||
''||chr(10)||
'         end if;'||chr(10)||
'         commit;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAGE_ID, '''');  '||chr(10)||
'     :P11120_OFFENSE := null';

p:=p||';'||chr(10)||
'     :P11120_MODE:=null;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
'  when OTHERS then'||chr(10)||
'      :P11120_OFFENSE := null;'||chr(10)||
'      :P11120_MODE:=null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3958732267548185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Process Selected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11120_OFFENSE',
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
p:=p||'begin'||chr(10)||
'    :p11120_primary_sid := osi_reference.lookup_ref_sid(''OFFENSE_PRIORITY'', ''P'');'||chr(10)||
''||chr(10)||
'    select decode(count(sid), 0, ''N'', ''Y'')'||chr(10)||
'      into :p11120_primary_exists'||chr(10)||
'      from t_osi_f_inv_offense o'||chr(10)||
'     where o.investigation = :p0_obj and o.priority = :p11120_primary_sid;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 17134707434042857 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 1,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'',
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
p:=p||'F|#OWNER#:T_OSI_F_INV_OFFENSE:P11120_SEL_OFFENSE:SID';

wwv_flow_api.create_page_process(
  p_id     => 96300834788497573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Offense',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P11120_SEL_OFFENSE',
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
p:=p||':P11120_PRIORITY_LOV := osi_reference.get_lov(''OFFENSE_PRIORITY'', :P11120_PRIORITY);';

wwv_flow_api.create_page_process(
  p_id     => 96303508000556015 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Priority LOV',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P11120_SEL_OFFENSE is not null or :P11120_MODE = ''ADD''',
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
'    v_sid_list   varchar2 (5000) := ''sids_'';'||chr(10)||
'begin'||chr(10)||
'    for k in (SELECT OFFENSE'||chr(10)||
'                FROM T_OSI_F_INV_OFFENSE O'||chr(10)||
'               WHERE O.INVESTIGATION = :p0_obj)'||chr(10)||
'    loop'||chr(10)||
'        v_sid_list := v_sid_list || ''~'' || k.offense;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    :p11120_exclude_sids := v_sid_list;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 18646806887005039 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 11120,
  p_process_sequence=> 60,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Exclude SID List',
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
-- ...updatable report columns for page 11120
--
 
begin
 
null;
end;
null;
 
end;
/

 
