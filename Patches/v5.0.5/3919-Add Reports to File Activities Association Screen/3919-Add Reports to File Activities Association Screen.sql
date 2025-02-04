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
--   Date and Time:   10:00 Tuesday October 4, 2011
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

PROMPT ...Remove page 10150
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>10150);
 
end;
/

 
--application/pages/page_10150
prompt  ...PAGE 10150: File Associated Activities
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_LOCATOR"'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"'||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
'if (''&REQUEST.'' == ''CC_SEL''){'||chr(10)||
'	var pageNum = 5600;'||chr(10)||
'	var pageName = ''COM_CLO_WID'';'||chr(10)||
'	var itemNames = ''P5600_ACTION_TYPE,P5600_ACT_LIST,P0_OBJ'';'||chr(10)||
'	var itemVals = ''SEL,&P10150_ACT_LIST.,&P0_OBJ.'';'||chr(10)||
''||chr(10)||
'	popup({ page 		: pageNum,  '||chr(10)||
'		name 		: pageName,'||chr(10)||
'		item_names 	: itemNames,'||chr(10)||
'		item_values 	: itemVals,'||chr(10)||
'		clea';

ph:=ph||'r_cache 	: pageNum});'||chr(10)||
'};'||chr(10)||
''||chr(10)||
'if (''&REQUEST.'' == ''CC_ALL''){'||chr(10)||
'	var pageNum = 5600;'||chr(10)||
'	var pageName = ''COM_CLO_WID'';'||chr(10)||
'	var itemNames = ''P5600_ACTION_TYPE,P5600_ACT_LIST,P0_OBJ'';'||chr(10)||
'	var itemVals = ''ALL,&P10150_ACT_LIST.,&P0_OBJ.'';'||chr(10)||
''||chr(10)||
'	popup({ page 		: pageNum,  '||chr(10)||
'		name 		: pageName,'||chr(10)||
'		item_names 	: itemNames,'||chr(10)||
'		item_values 	: itemVals,'||chr(10)||
'		clear_cache 	: pageNum});'||chr(10)||
'};'||chr(10)||
''||chr(10)||
''||chr(10)||
'function GetAndOpenMenu(e,pThis,pThat,pSub)'||chr(10)||
'';

ph:=ph||'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                           $v(''pFlowId''),'||chr(10)||
'                           ''APPLICATION_PROCESS=GETREPORTMENUGUTS'','||chr(10)||
'                           $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pThat); '||chr(10)||
' get.addParam(''x02'',''N'');     '||chr(10)||
' '||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' var rptList = document.getElementById(pThat);'||chr(10)||
' rptList.innerHTML=gReturn;'||chr(10)||
''||chr(10)||
' var lMenu = $x(pThat);'||chr(10)||
' if(pThis != gCurren';

ph:=ph||'tAppMenuImage)'||chr(10)||
'   {'||chr(10)||
'    app_AppMenuMultiClose();'||chr(10)||
'    var l_That = pThis.parentNode; '||chr(10)||
'    pThis.className = g_dhtmlMenuOn;'||chr(10)||
'    dhtml_MenuOpen(l_That,pThat,false,''Bottom'');'||chr(10)||
'    lMenu.style.top = e.y;'||chr(10)||
'    lMenu.style.left = e.x;'||chr(10)||
''||chr(10)||
'    gCurrentAppMenuImage = pThis;'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    dhtml_CloseAllSubMenus();'||chr(10)||
'    app_AppMenuMultiClose();'||chr(10)||
'   }'||chr(10)||
' return;'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 10150,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'File Associated Activities',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P10150_SEL_ASSOC.'');"',
  p_step_sub_title => 'File Associated Activities',
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
  p_group_id => 89997728565512278+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111004095926',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '27-JUL-10 J.Faris Bug 0500 - Fixed typo in P10150_NARRATIVE_UNAVAIL static text.'||chr(10)||
''||chr(10)||
'12-May-2011 Tim Ward - CR#3745/3780 - Added nowrap to date fields of report.'||chr(10)||
'                       Made Narrative width = 100% and added more to the '||chr(10)||
'                       height of the text field (style="height:auto;" '||chr(10)||
'                       doesn''t seem to work).'||chr(10)||
''||chr(10)||
'                       Added "JS_REPORT_AUTO_SCROLL" to HTML '||chr(10)||
'                       Header.  Added onkeydown="return checkForUpDownArrows'||chr(10)||
'                       (event, ''&P10150_SEL_ASSOC.'');" to HTML Body Attribute. '||chr(10)||
'                       Added name=''#SID#'' to "Link Attributes" of the SID '||chr(10)||
'                       Column of the Report. Added a new Branch to'||chr(10)||
'"f?p=&APP_ID.:10150:&SESSION.::&DEBUG.:::#&P10150_SEL_ASSOC.",'||chr(10)||
'                       this allows the report to move the the Anchor '||chr(10)||
'                       of the selected currentrow.'||chr(10)||
''||chr(10)||
'13-Sep-2011 Tim Ward - CR#3905 - Added a Quick View Note Pop-Up Icon to'||chr(10)||
'                       the Report.'||chr(10)||
''||chr(10)||
'04-Oct-2011 - Tim Ward - CR#3919 - Add Report Printing for Activities from '||chr(10)||
'                         the File/Activity Associations sreen.'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>10150,p_text=>ph);
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
  p_id=> 2401416207751675 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_plug_name=> 'Choose the Associations to Display',
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
  p_id=> 6794424078534921 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_plug_name=> 'Narrative of Selected Activity <font color="red"><i>([shift]+[down]/[up] to navigate narratives)</i></font>',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P10150_SEL_ASSOC is not null',
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
s:=s||'select sid as "SID", '||chr(10)||
'       decode(file_sid, :p0_obj, htmldb_item.checkbox(1, sid), ''&nbsp;'') as "Remove",'||chr(10)||
'       file_id as "File ID",'||chr(10)||
'       activity_id as "Activity ID", '||chr(10)||
'       activity_type_desc as "Type of Activity", '||chr(10)||
'       osi_object.get_tagline_link(activity_sid) as "Activity Title",'||chr(10)||
'       activity_date as "Activity Date",'||chr(10)||
'       activity_unit_assigned as "Assigned Unit",'||chr(10)||
'       activit';

s:=s||'y_suspense_date as "Suspense Date", '||chr(10)||
'       activity_complete_date as "Completed", '||chr(10)||
'       activity_close_date as "Closed", '||chr(10)||
'       decode(sid, :P10150_SEL_ASSOC, ''Y'', ''N'') as "Current",'||chr(10)||
'       ''<a href="'' ||'||chr(10)||
'       ''javascript:popup({page:5060,'' || '||chr(10)||
'            ''clear_cache:''''5060'''','' ||'||chr(10)||
'            ''item_names:''''P5060_OBJ'''','' || '||chr(10)||
'            ''item_values:'' || '''''''' || ACTIVITY_SID || '''''''' || '','' ';

s:=s||'||'||chr(10)||
'            ''height:550});">'' ||'||chr(10)||
'            ''<IMG SRC="#IMAGE_PREFIX#themes/osi/notes.gif"'' ||'||chr(10)||
'            '' alt="View IDP Notes">'' ||'||chr(10)||
'            ''</a>'' as "Notes Pop-Up",'||chr(10)||
'            osi_util.get_report_menu(activity_sid) as "Reports"'||chr(10)||
'  from v_osi_assoc_fle_act &P10150_FILTERS.';

wwv_flow_api.create_report_region (
  p_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_name=> 'Associated Activities',
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
  p_query_num_rows=> '300000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No associations found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '300000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P10150_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'select sid as "SID", decode(file_sid, :p0_obj, htmldb_item.checkbox(1, sid), ''&nbsp;'') as "Remove",'||chr(10)||
'       activity_id as "ID", osi_object.get_tagline_link(activity_sid) as "Title",'||chr(10)||
'       activity_type_desc as "Type", to_char(activity_complete_date, :fmt_date) as "Complete Date", to_char(activity_close_date, :fmt_date) as "Close Date", decode(sid, :P10150_SEL_ASSOC, ''Y'', ''N'') as "Current"'||chr(10)||
'  from v_osi_assoc_fle_act &P10150_FILTERS.');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245314419308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
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
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245414250308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Remove',
  p_column_display_sequence=> 3,
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
  p_id=> 8245529601308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'File ID',
  p_column_display_sequence=> 4,
  p_column_heading=> 'File ID',
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
  p_id=> 8245620631308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Activity ID',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Activity ID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>2,
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
  p_id=> 8245715256308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Type of Activity',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Type of Activity',
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
  p_id=> 8245816184308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Title',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Activity Title',
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
  p_id=> 8245907378308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Date',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Activity Date',
  p_column_format=> '&FMT_DATE.',
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
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246007468308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Assigned Unit',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Assigned Unit',
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
  p_id=> 8246111752308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Suspense Date',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Suspense Date',
  p_column_format=> '&FMT_DATE.',
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
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246230319308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Completed',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Completed',
  p_column_format=> '&FMT_DATE.',
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
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246318586308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Closed',
  p_column_display_sequence=> 12,
  p_column_heading=> 'Closed',
  p_column_format=> '&FMT_DATE.',
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
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246408515308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 13,
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
  p_id=> 8246513515308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 13,
  p_form_element_id=> null,
  p_column_alias=> 'Notes Pop-Up',
  p_column_display_sequence=> 2,
  p_column_heading=> '&nbsp;',
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
  p_id=> 8253431837864029 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 14,
  p_form_element_id=> null,
  p_column_alias=> 'Reports',
  p_column_display_sequence=> 14,
  p_column_heading=> 'Reports',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
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
  p_id             => 89681107763812106 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 10,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Association',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:popupLocator(300,''P10150_ASSOC_ACT'',''Y'',''&P10150_EXCLUDE_SIDS.'');',
  p_button_condition=> ':P10150_USER_HAS_ADD_ASSOC_PRV = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_button_comment=>'javascript:popup({page:150,'||chr(10)||
'                      name:''ASSOC&P0_OBJ.'','||chr(10)||
'                      clear_cache:''150'','||chr(10)||
'                      item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'','||chr(10)||
'item_values:''OSI.LOC.ACT,P10150_ASSOC_ACT,&P10150_EXCLUDE_SIDS.''});',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6734629761804450 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 40,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'CC_SEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Complete and Close Selected Activities',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6738907897119887 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 50,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'CC_ALL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Complete and Close All Activities',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6862013070205275 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 70,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6861415709196515 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 80,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P10150_NAR_WRITABLE = ''Y'''||chr(10)||
'and'||chr(10)||
':P10150_ACT_IS_RESTRICTED <> ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6886528193401900 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 90,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Association',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P10150_ACTIVITY_IS_INHERITED <> ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15698111556878178 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 100,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 10150);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89394529572684714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 17:07 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>5505629590450153 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:10150:&SESSION.::&DEBUG.:::#&P10150_SEL_ASSOC.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 15,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST = ''SAVE'' OR :REQUEST LIKE ''EDIT_%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-DEC-2009 15:58 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>5571516155664872 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:10150:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 29-APR-2009 13:45 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2401708022751679 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ASSOCIATION_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 2401416207751675+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ME',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Activities for this File;ME,Inherited Activities;I_ACT',
  p_lov_columns=> 4,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''UPDATE'');"',
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
  p_id=>2402416254780095 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_FILTERS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_FILTERS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_id=>6747927636475617 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_ACT_LIST',
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
  p_id=>6793832258527885 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_SEL_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_SEL_ASSOC',
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
  p_id=>6794710703540540 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 85,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'NARRATIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10000,
  p_cMaxlength=> 30000,
  p_cHeight=> 15,
  p_tag_attributes  => 'style="width:100%;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P10150_ACT_IS_RESTRICTED <> ''Y'''||chr(10)||
'and'||chr(10)||
':P10150_USER_HAS_ACT_ACCESS_PRV = ''Y''',
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
  p_id=>6795132520546882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 84,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
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
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>6860502634173814 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NAR_WRITABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 83,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>6871326968587746 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_IS_RESTRICTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 81,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>6873607538629464 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE_UNAVAIL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 86,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative',
  p_source=>'This activity is restricted and the Narrative is not viewable from this screen. <br> Please open the activity to view the Narrative.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap" style="width:99%;"',
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P10150_ACT_IS_RESTRICTED = ''Y'' or'||chr(10)||
':P10150_ACT_IS_RESTRICTED is null',
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
  p_id=>6887606647490262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACTIVITY_IS_INHERITED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 82,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>7143022926607964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_FAILURE_COUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_ERROR_DETECTED',
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
  p_id=>7190808782826134 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_USER_HAS_ACT_ACCESS_PRV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_USER_HAS_ACT_ACCESS_PRV',
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
  p_id=>7192019012942668 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_USER_HAS_ADD_ASSOC_PRV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_USER_HAS_ADD_ASSOC_PRV',
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
  p_id=>8250609739619477 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_REPORTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 87,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_util.get_report_menu(:P10150_ACT_SID);',
  p_source_type=> 'FUNCTION',
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
  p_display_when_type=>'NEVER',
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
  p_id=>15698319521880437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
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
  p_id=>89680926290812099 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ASSOC_ACT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Assoc File',
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
  p_id=>89755622150846418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_EXCLUDE_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_EXCLUDE_SIDS',
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

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6523830657956645 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_validation_name => 'Selected Activities - Assure Something Selected',
  p_validation_sequence=> 10,
  p_validation => 'begin'||chr(10)||
'    if (apex_application.g_f01.count >= 1) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'No activities have been selected.',
  p_when_button_pressed=> 6734629761804450 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6754527420835112 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_validation_name => 'Assure Activities Exist (For CC/All only)',
  p_validation_sequence=> 20,
  p_validation => 'declare'||chr(10)||
'    v_cnt   number;'||chr(10)||
'begin'||chr(10)||
'    select count(sid)'||chr(10)||
'      into v_cnt'||chr(10)||
'      from v_osi_assoc_fle_act'||chr(10)||
'     where file_sid = :p0_obj;'||chr(10)||
''||chr(10)||
'    if (v_cnt >= 1) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'No Activites exist that may be closed.',
  p_when_button_pressed=> 6738907897119887 + wwv_flow_api.g_id_offset,
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
p:=p||'update t_osi_activity set narrative=:p10150_narrative'||chr(10)||
' where sid = :p10150_act_sid;';

wwv_flow_api.create_page_process(
  p_id     => 7712912109312509 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Narratizzle',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>6861415709196515 + wwv_flow_api.g_id_offset,
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
'    v_temp            varchar2(4000);'||chr(10)||
'    v_act_sid         t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'    v_failure_count   number                                  := 0;'||chr(10)||
'begin'||chr(10)||
'    v_temp := replace(:p10150_assoc_act, '':'', ''~'');'||chr(10)||
'    :P10150_FAILURE_COUNT := 0;'||chr(10)||
''||chr(10)||
'    for i in 1 .. core_list.count_list_elements(v_temp)'||chr(10)||
'    loop'||chr(10)||
'        v_act_sid := core_list.get_list_element(v_temp,i);'||chr(10)||
''||chr(10)||
'        f';

p:=p||'or k in (select restriction'||chr(10)||
'                    from t_osi_activity'||chr(10)||
'                   where sid = v_act_sid)'||chr(10)||
'        loop'||chr(10)||
'            if (osi_reference.lookup_ref_code(k.restriction) = ''NONE'') then'||chr(10)||
'                insert into t_osi_assoc_fle_act'||chr(10)||
'                            (activity_sid, file_sid)'||chr(10)||
'                     values (v_act_sid, :p0_obj);'||chr(10)||
'            else'||chr(10)||
'                v_failure_count :';

p:=p||'= v_failure_count + 1;'||chr(10)||
'            end if;'||chr(10)||
'        end loop;'||chr(10)||
'    end loop;'||chr(10)||
'    :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAGE_ID, '''');'||chr(10)||
'    :P10150_FAILURE_COUNT := v_failure_count;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89696016285177781 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Associations',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'P10150_ASSOC_ACT',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG. <br> Note: [&P10150_FAILURE_COUNT.] activities were not associated due to restriction.  <br> If any exist, associate these activities to this file from the activity itself.'||chr(10)||
'',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'OSI.LOC.ACT');
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
'        delete from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'              where sid = :P10150_SEL_ASSOC;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89695812822176774 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Associations',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'DELETE',
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
p:=p||'declare'||chr(10)||
'    v_temp    varchar2(4000)                          := ''~'';'||chr(10)||
'    v_temp2   t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'begin'||chr(10)||
'    if (:request = ''CC_SEL'') then'||chr(10)||
'        for i in 1 .. apex_application.g_f01.count'||chr(10)||
'        loop'||chr(10)||
'            select activity_sid'||chr(10)||
'              into v_temp2'||chr(10)||
'              from t_osi_assoc_fle_act'||chr(10)||
'             where sid = apex_application.g_f01(i);'||chr(10)||
''||chr(10)||
'            v_temp := ';

p:=p||'v_temp || v_temp2 || ''~'';'||chr(10)||
'        end loop;'||chr(10)||
'    elsif(:request = ''CC_ALL'') then'||chr(10)||
'        for k in (select activity_sid'||chr(10)||
'                    from v_osi_assoc_fle_act'||chr(10)||
'                   where file_sid = :p0_obj)'||chr(10)||
'        loop'||chr(10)||
'            v_temp := v_temp || k.activity_sid || ''~'';'||chr(10)||
'        end loop;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p10150_act_list := v_temp;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6748104218478317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Activity List - CC',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''CC_SEL'', ''CC_ALL'')',
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
p:=p||'P10150_SEL_ASSOC,P10150_ASSOC_ACT,P10150_ACT_SID,P10150_NAR_WRITABLE,P10150_NARRATIVE';

wwv_flow_api.create_page_process(
  p_id     => 6863323375227179 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''DELETE'') or :REQUEST like ''EDIT_%''',
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
'    :p10150_sel_assoc := substr(:request, 6);'||chr(10)||
''||chr(10)||
'    select activity_sid'||chr(10)||
'      into :p10150_act_sid'||chr(10)||
'      from v_osi_assoc_fle_act'||chr(10)||
'     where sid = substr(:request, 6);'||chr(10)||
''||chr(10)||
'--Check for privileges'||chr(10)||
'    if (:p10150_act_sid is not null) then'||chr(10)||
'        :p10150_user_has_act_access_prv :='||chr(10)||
'                           osi_auth.check_for_priv(''ACCESS'', core_obj.get_objtype(:p10150_act_sid));'||chr(10)||
'    else'||chr(10)||
'        ';

p:=p||':p10150_user_has_act_access_prv := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6793523254525212 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Association',
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
p:=p||'P10150_NARRATIVE';

wwv_flow_api.create_page_process(
  p_id     => 6862823936217884 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Fields - On Cancel',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>6862013070205275 + wwv_flow_api.g_id_offset,
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
'--Get Writability'||chr(10)||
'    if (:p10150_act_sid is not null) then'||chr(10)||
'        :p10150_nar_writable := osi_object.check_writability(:p10150_act_sid, null);'||chr(10)||
'    else'||chr(10)||
'        :p10150_nar_writable := ''N'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'--Get Restriction'||chr(10)||
'    for k in (select restriction'||chr(10)||
'                from t_osi_activity'||chr(10)||
'               where sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        if (osi_reference.lookup_ref_code(k.restri';

p:=p||'ction) = ''NONE'') then'||chr(10)||
'            :p10150_act_is_restricted := ''N'';'||chr(10)||
'        else'||chr(10)||
'            :p10150_act_is_restricted := ''Y'';'||chr(10)||
'        end if;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'--See if selected activity is inherited'||chr(10)||
'    :p10150_activity_is_inherited := ''Y'';'||chr(10)||
''||chr(10)||
'    for k in (select *'||chr(10)||
'                from t_osi_assoc_fle_act'||chr(10)||
'               where file_sid = :p0_obj and activity_sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        :p';

p:=p||'10150_activity_is_inherited := ''N'';'||chr(10)||
'        return;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'--Get privileges'||chr(10)||
'    :P10150_USER_HAS_ADD_ASSOC_PRV := osi_auth.check_for_priv(''ASSOC_ACT'', :P0_OBJ_TYPE_SID);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6860713023176854 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 5,
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_add_or   boolean := false;'||chr(10)||
'begin'||chr(10)||
'    :p10150_filters := ''where '';'||chr(10)||
''||chr(10)||
'    if (instr(:p10150_association_filter, ''ME'') > 0 or'||chr(10)||
'         :P10150_ASSOCIATION_FILTER is null ) then'||chr(10)||
'        v_add_or := true;'||chr(10)||
''||chr(10)||
'        :p10150_filters := :p10150_filters || '' FILE_SID = '' || '''''''' || :P0_OBJ || '''''''';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p10150_association_filter, ''I_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) t';

p:=p||'hen'||chr(10)||
'            :p10150_filters := :p10150_filters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p10150_filters :='||chr(10)||
'            :p10150_filters'||chr(10)||
'            || '' activity_sid in(select activity_sid'||chr(10)||
'                  from v_osi_assoc_fle_act'||chr(10)||
'                 where file_sid in(select that_file'||chr(10)||
'                                     from v_osi_assoc_fle_fle'||chr(10)||
'                                    where this_file = ''''';

p:=p||''''||chr(10)||
'            || :p0_obj || ''''''))'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 2402129282774346 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Build WHERE clause',
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
'    V_SID_LIST   varchar2 (5000) := ''SIDS_'';'||chr(10)||
'begin'||chr(10)||
'    for K in (select ACTIVITY_SID'||chr(10)||
'                from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'               where FILE_SID = :P0_OBJ)'||chr(10)||
'    loop'||chr(10)||
'        V_SID_LIST := V_SID_LIST || ''~'' || K.ACTIVITY_SID;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    :P10150_EXCLUDE_SIDS := V_SID_LIST;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89756414232872546 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 20,
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'F|#OWNER#:T_OSI_ACTIVITY:P10150_ACT_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 6794823170544140 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 30,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P10150_ACT_SID is not null',
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
-- ...updatable report columns for page 10150
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
--   Date and Time:   10:00 Tuesday October 4, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: GETREPORTMENUGUTS
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
 
 
prompt Component Export: APP PROCESS 8254600950025376
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  v_obj 	varchar2(100):= apex_application.g_x01;'||chr(10)||
'  v_template    varchar2(100):= apex_application.g_x02;'||chr(10)||
'  v_result      varchar2(4000);'||chr(10)||
'begin'||chr(10)||
'     v_result := osi_util.get_report_menu(substr(v_obj,2,length(v_obj)-1), '||chr(10)||
'                                          v_template);'||chr(10)||
''||chr(10)||
'     htp.p(v_result);'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 8254600950025376 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'GETREPORTMENUGUTS',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '04-Oct-2011 - Tim Ward - CR#3919 - Add Report Printing for Activities from '||chr(10)||
'                         the File/Activity Associations sreen.'||chr(10)||
'');
end;
 
null;
 
end;
/

COMMIT;



-- "Set define off" turns off substitution variables. 
Set define off; 
set feedback on;

CREATE OR REPLACE package osi_util as
/******************************************************************************
   Name:     OSI_UTIL
   Purpose:  Provides utility functions.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    23-APR-2009 T.Whitehead    Created package.
    07-MAY-2009 T.McGuffin     Added Address utilities (GET_ADDR_FIELDS, GET_ADDR_DISPLAY,
                               UPDATE_ADDRESS, INSERT_ADDRESS)
    16-may-2009 T.Whitehead    Added parse_size from OSI_ATTACHMENT.
    20-MAY-2009 T.McGuffin     Removed get_edit_link.
    22-May-2009 T.McGuffin     Modified insert_address to remove the obj_context.
    10-Jun-2009 R.Dibble       Added get_checklist_buttons
    25-Jun-2009 T.McGuffin     Added new update_single_address procedure which ties together insertion and
                               updating of an address, if either are applicable.
    29-Jul-2009 T.Whitehead    Moved get_mime_icon into this package.
    30-Nov-2009 T.Whitehead    Added get_report_links.
    29-Dec-2009 T.Whitehead    Added do_title_substitution.
    04-Jan-2010 T.Whitehead    Added procedure aitc that calls core_util.append_info_to_clob.
    16-Feb-2010 T.McGuffin     Added display_precision_date function.
    25-Mar-2010 T.Whitehead    Copied blob_to_clob, blob_to_hex, clob_to_clob, decapxml, encapxml
                               and hex_to_blob from I2MS.
    14-Jun-2010 J.Faris        Added show_tab function.
    12-Jul-2010 R.Dibble       Added encrypt_md5hex (copied from CORE_CONTEXT and made public)
    02-Mar-2011 Tim Ward       CR#3705 - Added WordWrapFunc.
    04-Oct-2011 Tim Ward       CR#3919 - Add Report Printing for Activities from the File/Activity Associations sreen.
                                Added get_report_menu.
    
******************************************************************************/
    procedure aitc(p_clob in out nocopy clob, p_text varchar2);

    function blob_to_clob(p_blob in blob)
        return clob;

    function blob_to_hex(p_blob in blob)
        return clob;

    function clob_to_blob(p_clob in clob)
        return blob;

    function decapxml(p_blob in blob, p_tag in varchar2)
        return blob;

    function encapxml(p_blob in blob)
        return blob;

    function hex_to_blob(p_blob in blob)
        return blob;

    function hex_to_blob(p_clob in clob)
        return blob;

    /*
     * Replaces any ~COLUMN_NAME~ items with values from table or view name p_tv_name.
     */
    function do_title_substitution(
        p_obj       in   varchar2,
        p_title     in   varchar2,
        p_tv_name   in   varchar2 := null)
        return varchar2;

    function get_mime_icon(p_mime_type in varchar2, p_file_name in varchar2)
        return varchar2;

    function get_report_links(p_obj in varchar2)
        return varchar2;

    function get_report_menu(p_obj in varchar2, p_justTemplate in varchar2 := 'Y')
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of statuses that an
--    object may currently go to
    function get_status_buttons(p_obj in varchar2)
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2)
        return varchar2;

--    The following functions all make reference to an address list.  This list uses core_list (squiggly-
--    delimited values) and contains all of the address fields in the following order:
--    ~ADDRESS1~ADDRESS2~CITY~STATE(sid)~ZIP~COUNTRY(sid)~

    --    Takes a number X and returns X bytes, X KB, X MB, or X GB.
    function parse_size(p_size in number)
        return varchar2;

    -- Given a date, displays in the precision imbedded in the seconds field of the date.
    function display_precision_date(p_date date)
        return varchar2;

    /* This function executes any object or object type specific code to show/hide page tabs */
    function show_tab(p_obj_type_code in varchar2, p_tab in varchar2, p_obj in varchar2 := null, p_context in varchar2 := null)
            return varchar2;
            
   /* Used to compare passwords for PASSWORD CHANGE SCREEN ONLY!!! */
   function encrypt_md5hex(p_clear_text in varchar2)
        return varchar2;

    function WordWrapFunc(pst$ in clob, pLength in Number, Delimiter in clob) return clob;

end osi_util;
/


CREATE OR REPLACE package body osi_util as
/******************************************************************************
   Name:     OSI_UTIL
   Purpose:  Provides utility functions.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    23-APR-2009 T.Whitehead    Created package.
    07-MAY-2009 T.McGuffin     Added Address utilities (GET_ADDR_FIELDS, GET_ADDR_DISPLAY,
                               UPDATE_ADDRESS, INSERT_ADDRESS)
    16-MAY-2009 T.Whitehead    Added PARSE_SIZE from OSI_ATTACHMENT.
    16-MAY-2009 T.McGuffin     Modified get_edit_link to use our &ICON_EDIT. image
    20-MAY-2009 T.McGuffin     Removed get_edit_link.
    21-May-2009 R.Dibble       Modified get_status_buttons to utilize 'ALL' status change types'
    22-May-2009 T.McGuffin     Modified insert_address to remove the obj_context.
    26-May-2009 R.Dibble       Modified get_status_buttons to handle object type 
                               specific status changes correctly and to use SEQ
    10-Jun-2009 R.Dibble       Added get_checklist_buttons
    25-Jun-2009 T.McGuffin     Added new update_single_address procedure which ties together insertion and
                               updating of an address, if either are applicable.
    29-Jul-2009 T.Whitehead    Moved get_mime_icon into this package.
    29-Oct-2009 R.Dibble       Modified get_status_buttons and get_checklist_buttons
                               to handle object type overrides
    30-Nov-2009 T.Whitehead    Added get_report_links.
    29-Dec-2009 T.Whitehead    Added do_title_substitution.
    04-Jan-2010 T.Whitehead    Added procedure aitc that calls core_util.append_info_to_clob.
    16-Feb-2010 T.McGuffin     Added display_precision_date function.
    25-Mar-2010 T.Whitehead    Copied blob_to_clob, blob_to_hex, clob_to_clob, decapxml, encapxml
                               and hex_to_blob from I2MS.
    1-Jun-2010  J.Horne        Updated get_report_links so that if statement compares disabled_status
                               to v_status_codes correctly.
    14-Jun-2010 J.Faris        Added show_tab function.
    12-Jul-2010 R.Dibble       Added encrypt_md5hex (copied from CORE_CONTEXT and made public)
    24-Aug-2010 J.Faris        Updated get_status_buttons, get_checklist_buttons to include status change 
                               overrides tied to a "sub-parent" (like ACT.CHECKLIST).
    15-Nov-2010 R.Dibble       Incorporated Todd Hughsons change to get_report_links() to handle
                                the new report link dropdown architecture                           
    16-Feb-2011 Tim Ward       CR#3697 - Fixed do_title_substitution to not lock up if there is
                                a ~ typed in the Title somewhere.                           
    02-Mar-2011 Tim Ward       CR#3705 - Added an else in the Case of get_report_links to support .txt mime type.
    02-Mar-2011 Tim Ward       CR#3705 - Added WordWrapFunc.
    04-Oct-2011 Tim Ward       CR#3919 - Add Report Printing for Activities from the File/Activity Associations sreen.
                                Added get_report_menu.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_UTIL';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    procedure aitc(p_clob in out nocopy clob, p_text varchar2) is
    begin
        core_util.append_info_to_clob(p_clob, p_text, '');
    end aitc;
    
    function blob_to_clob(p_blob in blob)
        return clob is
        --Used to convert a Blob to a Clob
        v_clob          clob;
        v_blob_length   integer;
        v_blob_chunk    raw(1024);
        v_blob_byte     raw(1);
        v_chunk_size    integer   := 1024;
    begin
        dbms_lob.createtemporary(v_clob, true, dbms_lob.session);
        v_blob_length := dbms_lob.getlength(p_blob);

        for i in 0 .. floor(v_blob_length / v_chunk_size) - 1
        loop
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_clob, utl_raw.cast_to_varchar2(v_blob_chunk));
        end loop;

        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_clob, utl_raw.cast_to_varchar2(v_blob_byte));
        end loop;

        return v_clob;
    end;
    
    function blob_to_hex(p_blob in blob)
        return clob is
        --Used to convert a Raw Blob into a Hex Clob
        v_clob          clob;
        v_blob_length   integer;
        v_blob_chunk    raw(1024);
        v_blob_byte     raw(1);
        v_chunk_size    integer   := 1024;
    begin
        dbms_lob.createtemporary(v_clob, true, dbms_lob.session);
        v_blob_length := dbms_lob.getlength(p_blob);

        for i in 0 .. floor(v_blob_length / v_chunk_size) - 1
        loop
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_clob, rawtohex(v_blob_chunk));
        end loop;

        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_clob, rawtohex(v_blob_byte));
        end loop;

        return v_clob;
    end;
    
    -- Used to convert a Clob to a Blob. Richard D.
    function clob_to_blob(p_clob in clob)
        return blob
    is
        v_pos       pls_integer    := 1;
        v_buffer    raw(32767);
        v_return    blob;
        v_lob_len   pls_integer    := dbms_lob.getlength(p_clob);
        --WAS pls_integer
        v_err       varchar2(4000);
    begin
        dbms_lob.createtemporary(v_return, true);
        dbms_lob.open(v_return, dbms_lob.lob_readwrite);

        loop
            v_buffer := utl_raw.cast_to_raw(dbms_lob.substr(p_clob, 16000, v_pos));

            if utl_raw.length(v_buffer) > 0 then
                dbms_lob.writeappend(v_return, utl_raw.length(v_buffer), v_buffer);
            end if;

            v_pos := v_pos + 16000;
            exit when v_pos > v_lob_len;
        end loop;

        return v_return;
    exception
        when others then
            v_err := sqlerrm;
            return v_return;
    end clob_to_blob;
    
    function decapxml(p_blob in blob, p_tag in varchar2)
        return blob is
        v_output            blob           := null;
        v_work              blob           := null;
        v_err               varchar2(4000);
        v_length_to_parse   integer;
        v_offset            integer;
        v_pattern           raw(2000);
        --V_RAW               raw (32767);
        v_blob_length       integer;
        v_blob_chunk        raw(1024);
        v_blob_byte         raw(1);
        v_chunk_size        integer        := 1024;
    begin
        --Get LENGTH we need to keep
        v_pattern := utl_raw.cast_to_raw('</' || p_tag || '>');
        v_length_to_parse := dbms_lob.instr(p_blob, v_pattern) -(2 * 1) -(2 * length(p_tag));
        --Get OFFSET point that we need to keep
        v_pattern := utl_raw.cast_to_raw('<' || p_tag || '>');
        v_offset := dbms_lob.instr(p_blob, v_pattern) + length(p_tag) + 3;
        --Capture input
        v_work := p_blob;
        v_blob_length := v_length_to_parse;

        --Create a temporary clob
        if v_output is null then
            dbms_lob.createtemporary(v_output, true);
        end if;

        --Grab the contents in large chunks (currently 1024bytes) and convert it
        --Floor is similiar to RoundDown(x)
        for i in 0 .. floor((v_blob_length) / v_chunk_size) - 1
        loop
            --Get 1K of the lob (After the offset)
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, v_offset +(i * v_chunk_size) + 1);
            dbms_lob.append(v_output, v_blob_chunk);
        end loop;

        --Anything left after the chunks (the remainder 1023Bytes or <'er)
        --Handle in 1 byte chunks.. Not doing hex/raw conversion here so that is fine
        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_output, v_blob_byte);
        end loop;

        return v_output;
    exception
        when others then
            v_err := sqlerrm;
            return v_output;
    end decapxml;
    
    function encapxml(p_blob in blob)
        return blob is
        v_cr       varchar2(10) := chr(13) || chr(10);
        v_return   clob;
    begin
        --Convert to Clob
        --V_WORK := blob_to_clob(P_BLOB);

        --Opening Tag(s)
        core_util.append_info_to_clob(v_return, '<XML>' || v_cr || '  <ATTACHMENT>' || v_cr);
        --V_RETURN := '<XML>' || V_CR || '  <ATTACHMENT>' || V_CR;

        --Rest of Blob
        v_return := v_return || blob_to_hex(p_blob);
        --Closing Tag(s)
        core_util.append_info_to_clob(v_return, v_cr || '  </ATTACHMENT>' || v_cr || '</XML>' || v_cr, '');
        --V_RETURN := V_RETURN || '<XML>' || V_CR || '  <ATTACHMENT>' || V_CR;
        return clob_to_blob(v_return);
    end encapxml;
    
    function hex_to_blob(p_blob in blob)
        return blob is
    --Used to convert a hex blob into a raw blob
    begin
        return hex_to_blob(blob_to_clob(p_blob));
    end;

    function hex_to_blob(p_clob in clob)
        return blob is
        --Used to convert a Hex Clob into a Raw Blob
        v_blob                         blob;
        v_clob_length                  integer;
        v_clob_chunk                   varchar2(1024);
        v_clob_hex_byte                varchar2(2);
        v_chunk_size                   integer        := 1024;
        v_remaining_characters_start   integer;
    begin
        dbms_lob.createtemporary(v_blob, true, dbms_lob.session);
        v_clob_length := dbms_lob.getlength(p_clob);

        for i in 0 .. floor(v_clob_length / v_chunk_size) - 1
        loop
            v_clob_chunk := dbms_lob.substr(p_clob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_blob, hextoraw(v_clob_chunk));
            dbms_output.put_line('HEX_TO_BLOB - CHUNKS: ' || v_clob_chunk);
        end loop;

        v_remaining_characters_start :=(floor(v_clob_length / v_chunk_size) * v_chunk_size + 1);

        while v_remaining_characters_start < v_clob_length
        loop
            v_clob_hex_byte := dbms_lob.substr(p_clob, 2, v_remaining_characters_start);
            dbms_output.put_line('HEX_TO_BLOB - BYTES: ' || v_clob_hex_byte);
            dbms_lob.append(v_blob, hextoraw(v_clob_hex_byte));
            v_remaining_characters_start := v_remaining_characters_start + 2;
        end loop;

        return v_blob;
    end;
    
    function do_title_substitution(p_obj in varchar2, p_title in varchar2, p_tv_name in varchar2 := null)
        return varchar2 is
        v_caret     integer        := 0;
        v_title     varchar2(4000);
        v_rtn       varchar2(4000);
        v_value     varchar2(1000);
        v_item_og   varchar2(128);
        v_format    varchar2(30);
        v_item      varchar2(4000);
    begin
        v_title := p_title;
        v_rtn := v_title;

        for i in (SELECT column_value FROM TABLE(SPLIT(v_title,'~')) where column_value is not null)
        loop
            v_item := i.column_value;
            
            v_caret := instr(v_item, '^');
            if (v_caret > 0) then

              -- Save the item before separating the date format from the column name. --
              v_item_og := i.column_value;
              v_format := substr(v_item, v_caret + 1, length(v_item) - v_caret);
              v_item := substr(v_item, 1, v_caret - 1);
                  
            end if;

            -- See if the item is activity data. --
            begin
                 execute immediate 'select ' || v_item || ' from v_osi_title_activity '
                                  || ' where sid = ''' || p_obj || ''''
                             into v_value;
            exception
                when others then
                    begin
                        -- See if the item is participant data.
                        execute immediate 'select name from v_osi_title_partic '
                                          || ' where sid = ''' || p_obj || ''''
                                          || ' and upper(code) = upper(''' || v_item || ''')'
                                          || ' and rownum = 1'
                                     into v_value;
                    exception
                        when others then
                            -- If the item was neither see if a table or view name was
                            -- given and check it.
                            if (p_tv_name is not null) then
                               begin
                                    execute immediate 'select ' || v_item || ' from ' || p_tv_name
                                                  || ' where sid = ''' || p_obj || ''''
                                             into v_value;
                                exception
                                    when others then
                                        null; -- No replace will be made.
                                end;
                            end if;
                    end;
            end;

            -- If there was a date format, apply it now.
            if (v_caret > 0) then
 
              v_value := to_char(to_date(v_value, v_format), v_format);
              -- Get the original item for the replacement step.
              v_item := v_item_og;

            end if;
                
            -- Do the actual replacement.
            if (v_value is not null) then

              v_rtn := replace(v_rtn, '~' || v_item || '~', v_value);
              v_value := null;

            end if;

        end loop;

        return v_rtn;

    exception
        when others then
            log_error('do_title_substitution: ' || sqlerrm);
            raise;
    end do_title_substitution;

    function get_mime_icon(p_mime_type in varchar2, p_file_name in varchar2)
        return varchar2 is
        v_temp   varchar2(100) := null;
        v_mime   varchar2(500) := p_mime_type;
        v_file   varchar2(500) := p_file_name;
    begin
        begin
            if v_file is not null then
                while v_file <> regexp_substr(v_file, '[[:alnum:]]*')
                loop
                    v_file := regexp_substr(v_file, '[.].*');
                    v_file := regexp_substr(v_file, '[[:alnum:]].*');
                end loop;

                v_file := '.' || v_file;

                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper(v_file) and rownum = 1;
            end if;
        exception
            when no_data_found then
                if v_temp is null and v_mime is null then
                    select image
                      into v_temp
                      from t_core_mime_image
                     where upper(mime_or_file_extension) = upper('exe') and rownum = 1;
                end if;
        end;

        begin
            if v_mime is not null then
                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper(v_mime) and rownum = 1;
            end if;
        exception
            when no_data_found then
                -- Can't find an icon for this type so give it the default.
                --if v_temp is null and v_file is null then
                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper('exe') and rownum = 1;
        --end if;
        end;

        return v_temp;
    end get_mime_icon;

    function get_report_links(p_obj in varchar2)
        return varchar2 is
        v_rtn           varchar2(5000);
        v_auto_run      varchar2(1);
        v_status_code   t_osi_status.code%type;
    begin
        v_status_code := osi_object.get_status_code(p_obj);

        for a in (select   rt.description, rt.sid, rt.disabled_status, mt.file_extension
                      from t_osi_report_type rt, t_osi_report_mime_type mt
                     where (rt.obj_type member of osi_object.get_objtypes(p_obj)
                            or rt.obj_type = core_obj.lookup_objtype('ALL'))
                           and rt.active = 'Y'
                           and rt.mime_type = mt.sid(+)
                  order by rt.seq asc)
        loop
            begin
                select 'N'
                  into v_auto_run
                  from t_osi_report_type
                 where sid = a.sid
                   and active = 'Y'
                   and (   pick_dates = 'Y'
                        or pick_narratives = 'Y'
                        or pick_notes = 'Y'
                        or pick_caveats = 'Y'
                        or pick_dists = 'Y'
                        or pick_classification = 'Y'
                        or pick_attachment = 'Y'
                        or pick_purpose = 'Y'
                        or pick_distribution = 'Y'
                        or pick_igcode = 'Y'
                        or pick_status = 'Y');
            exception
                when no_data_found then
                    v_auto_run := 'Y';
            end;

            v_rtn := v_rtn || '~' || a.description || '~';

             if (a.disabled_status is not null and a.disabled_status like '%' || v_status_code || '%') then
                v_rtn := v_rtn || 'javascript:alert(''Report unavailable in the current status.'');';
            else
                if(v_auto_run = 'Y')then
                    case lower(a.file_extension)
                        when '.rtf' then
                            -- This link will run a report that an application will load outside of the browser.
                            v_rtn := v_rtn || 'javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::'
                                     || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || a.sid || ',' || p_obj || ''');';
                        when '.html' then
                            -- This javascript creates a new browser window for page 805 to show a report in.
                            v_rtn := v_rtn || 'javascript:launchReportHtml(''' || p_obj || ''');';

                        else
                            -- This link will run a report that an application will load outside of the browser.
                            v_rtn := v_rtn || 'javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::'
                                     || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || a.sid || ',' || p_obj || ''');';
                    end case;    
                else
                    -- This javascript launches a page with an interface to modify the report before creating it.
                    v_rtn := v_rtn || 'javascript:launchReportSpec(''' || a.sid || ''',''' || p_obj || ''');';
                end if;
            end if;
        end loop;

        return v_rtn || '~';
    end get_report_links;

    /*************************************************************************************************************/
    /*  get_report_menu - Build the Reports Dropdown menu just as it appears on every apex page.                 */
    /*************************************************************************************************************/
    function get_report_menu(p_obj in varchar2, p_justTemplate in varchar2 := 'Y') return varchar2 is
        v_links         varchar2(5000);
        v_rtn           varchar2(5000);
        v_cnt           number := 1;
        v_description   varchar2(5000);
        v_msg           varchar2(5000);
    begin
         /*************************************************************************************************************/
         /*  p_JustTemplate - Using 'Y' from Apex Page 10150 for Speed of retrieval.  Then when the user presses      */
         /*                    the down arrow to show reports, we call this with 'N' to get just the list of Reports. */
         /*************************************************************************************************************/
         v_rtn := '';
         if p_justTemplate = 'N' then
           
           if osi_auth.check_access(p_obj)='N' then
  
             v_msg:=osi_auth.check_access(p_obj=>p_obj, p_get_message=>true);
             return '<li>' || v_msg || '</li>';

           end if;
           
           v_links := get_report_links(p_obj);
           
           for a in (select * from table(split(v_links,'~')) where column_value is not null)
           loop
               if mod(v_cnt, 2) = 0 then

                 v_rtn := v_rtn || '<li><a href="javascript:void(0)" onclick="' || a.column_value || ' return false;" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">' || v_description || '</a></li>';
               
               else
               
                 v_description := a.column_value;
                
               end if;
               v_cnt := v_cnt + 1;
             
           end loop;
           return v_rtn;
         
         else

           v_rtn := '<ul class="dhtmlMenuLG2"><li class="dhtmlMenuItem1"><a>Reports</a><img src="/i/themes/theme_13/menu_small.gif" alt="Expand" onclick="GetAndOpenMenu(event, this,' || '''' || 'L' || p_obj || '''' || ',false)" style="cursor: pointer;"/></li><ul id="L' || p_obj || '" htmldb:listlevel="2" class="dhtmlSubMenu2" style="display:none;">';
           v_rtn := v_rtn || '</ul></ul>';
           
         end if;
         

         return v_rtn;
         
    end get_report_menu;
    
--    This function is used to return a squigly deliminted list (~) of statuses that an
--    object may currently go to
    function get_status_buttons(p_obj in varchar2)
        return varchar2 is
        v_rtn           varchar2(1000);
        v_obj_type      varchar2(20);
        v_obj_subtype   varchar2(20);
   
    begin
        --Get the object type
        v_obj_type := core_obj.get_objtype(p_obj);

        --Get distinct list of next possiible TO statuses
        ----Then check to see if there are any checklists tied to them

        --Get the button sids, etc.
        for i in (select osc.button_label, osc.sid, osc.from_status, osc.to_status
                    from v_osi_status_change osc
                   where (   from_status = osi_object.get_status_sid(p_obj)
                          or from_status_code = 'ALL')
                     and (   obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
          or obj_type = core_obj.lookup_objtype('ALL')
                     )and button_label is not null
                     and osc.active = 'Y'
                     
                     and osc.code not in(
                
                     select code
                          from v_osi_status_change osc2 
                         where ((obj_type = core_obj.get_objtype(p_obj) and override = 'Y')
                               /* updated 8.24.10 to include status change overrides tied to a "sub-parent" (like ACT.CHECKLIST) */ 
                                or
                               (obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                           and override = 'Y'))  and
                        
                           osc.sid <> osc2.sid
                           )
                           
                     order by SEQ desc)
        loop

            v_rtn := v_rtn || '~' || i.button_label || '~' || i.sid;

        end loop;

        return v_rtn || '~';
    end get_status_buttons;
    
--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2)
              return varchar2 is
        v_rtn           varchar2(1000);
        v_obj_type      varchar2(20);
        v_obj_subtype   varchar2(20);
             v_cnt   number;
    begin
        --Get the object type
        v_obj_type := core_obj.get_objtype(p_obj);

        --Get the button sids, etc.
        for i in (select osc.checklist_button_label, osc.sid
                    from v_osi_status_change osc
                   where (   from_status = osi_object.get_status_sid(p_obj)
                         or from_status_code = 'ALL')
                     and (   obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
          or obj_type = core_obj.lookup_objtype('ALL'))
           and osc.active = 'Y'
          and osc.code not in(
                
                     select code
                          from v_osi_status_change osc2 
                         where ((obj_type = core_obj.get_objtype(p_obj) and override = 'Y')
                               /* updated 8.24.10 to include status change overrides tied to a "sub-parent" (like ACT.CHECKLIST) */ 
                                or
                               (obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                           and override = 'Y'))  and
                        
                           osc.sid <> osc2.sid
                           )
                           
                     order by SEQ desc)
        loop
            select count(sid) 
            into v_cnt 
            from t_osi_checklist_item_type_map 
            where status_change_sid = i.sid;
        
        if (v_cnt >0) then
            v_rtn := v_rtn || '~' || i.checklist_button_label || '~' || i.sid;
        end if;
            v_cnt := 0;
        end loop;

        return v_rtn || '~';
    end get_checklist_buttons;

    function parse_size(p_size in number)
        return varchar2 is
        v_size   number;
        v_rtn    varchar2(100) := null;
    begin
        if (p_size is null) then
            v_size := 0;
        else
            v_size := p_size;
        end if;

        if v_size >= 1024 then
            v_size := v_size / 1024;
        else
            v_rtn := v_size || ' Bytes';
        end if;

        if v_size >= 1024 then
            v_size := v_size / 1024;
        elsif v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' KB';
        end if;

        if v_size >= 1000 then
            v_size := v_size / 1000;
        elsif v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' MB';
        end if;

        if v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' GB';
        end if;

        return v_rtn;
    end parse_size;

    function display_precision_date(p_date date)
        return varchar2 is
    begin
        case to_char(p_date, 'ss')
            when '00' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_DAY'));
            when '01' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_MONTH'));
            when '02' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_YEAR'));
            when '03' then
                return to_char(p_date,
                               core_util.get_config('CORE.DATE_FMT_DAY') || ' '
                               || core_util.get_config('OSI.DATE_FMT_TIME'));
            else
                return p_date;
        end case;
    exception
        when others then
            log_error('display_precision_date: ' || sqlerrm);
    end display_precision_date;

    /* This function executes any object or object type specific code to show/hide individual tabs */
    function show_tab(p_obj_type_code in varchar2, p_tab in varchar2, p_obj in varchar2 := null, p_context in varchar2 := null)
                return varchar2 is
    v_result varchar2(1);

    begin
         if p_obj_type_code = 'ALL.REPORT_SPEC' then 
            --p_obj is null and p_context is a report_type sid
            v_result := osi_report_spec.show_tab(p_context, p_tab);
            return v_result;
         else
            return 'Y';
         end if;
    exception
         when others then
                log_error('show_tab: ' || sqlerrm);
    end;
    
    /* Used to compare passwords for PASSWORD CHANGE SCREEN ONLY!!! */
    function encrypt_md5hex(p_clear_text in varchar2)
        return varchar2 is
        v_b64   varchar2(16);
        v_b16   varchar2(32);
        i       integer;
        c       integer;
        h       integer;
    begin
        v_b64 := dbms_obfuscation_toolkit.md5(input_string => p_clear_text);

        -- convert result to HEX:
        for i in 1 .. 16
        loop
            c := ascii(substr(v_b64, i, 1));
            h := trunc(c / 16);

            if h >= 10 then
                v_b16 := v_b16 || chr(h + 55);
            else
                v_b16 := v_b16 || chr(h + 48);
            end if;

            h := mod(c, 16);

            if h >= 10 then
                v_b16 := v_b16 || chr(h + 55);
            else
                v_b16 := v_b16 || chr(h + 48);
            end if;
        end loop;

        return lower(v_b16);
    end;

    Function WordWrapFunc(pst$ in clob, pLength in Number, Delimiter in clob) return clob is
  
      Cr$           varchar2(2) := chr(13);
      CrLF$         varchar2(4) := chr(13) || chr(10);
      NextLine$     clob := '';
      Text$         clob := '';
      l             number;
      s             number;
      c             number;
      Comma         number;
      DoneOnce      boolean;
      LineLength    number;
      st$           clob;
      DoneNow       number := 0;
      
    begin
         --- This function converts raw text into "Delimiter" delimited lines. ---
         st$ := ltrim(rtrim(pst$));
         LineLength := pLength + 1;
 
         while DoneNow=0
         loop
             l := nvl(length(NextLine$),0);
             s := InStr(st$, ' ');
             c := InStr(st$, Cr$);
             Comma := InStr(st$, ',');

             If c > 0 Then

               If l + c <= LineLength Then

                 Text$ := Text$ || NextLine$ || substr(st$,1,c);--   Left$(st$, c);
                 NextLine$ := '';
                 st$ := substr(st$, c + 1);-- Mid$(st$, c + 1);
                 GoTo LoopHere;

               End If;

             End If;
        
             If s > 0  Then

               If l + s <= LineLength Then

                 DoneOnce := True;
                 NextLine$ := NextLine$ || substr(st$, 1, s);-- Left$(st$, s);
                 st$ := substr(st$, s + 1);--Mid$(st$, s + 1)
           
               ElsIf s > LineLength Then
           
                    Text$ := Text$ || Delimiter || substr(st$,1,LineLength);-- Left$(st$, LineLength)
                    st$ := substr(st$, LineLength + 1); --Mid$(st$, LineLength + 1)
           
               Else
           
                 Text$ := Text$ || NextLine$ || Delimiter;
                 NextLine$ := '';

               End If;

             ElsIf Comma > 0 Then

                  If l + Comma <= LineLength Then

                    DoneOnce := True;
                    NextLine$ := NextLine$ || substr(st$, 1, Comma);-- Left$(st$, Comma)
                    st$ := substr(st$, Comma + 1); -- Mid$(st$, Comma + 1)

                  ElsIf s > LineLength Then

                        Text$ := Text$ || Delimiter || substr(st$, 1, LineLength);-- Left$(st$, LineLength)
                        st$ := substr(st$, LineLength + 1);-- Mid$(st$, LineLength + 1)
                        
                  Else

                    Text$ := Text$ || NextLine$ || Delimiter;
                    NextLine$ := '';

                  End If;

             Else
 
               If l > 0 Then
            
                 If l + nvl(Length(st$),0) > LineLength Then
            
                   Text$ := Text$ || NextLine$ || Delimiter || st$ || Delimiter;
            
                 Else
            
                   Text$ := Text$ || NextLine$ || st$ || Delimiter;
            
                 End If;

               Else

                 Text$ := Text$ || st$ || Delimiter;

               End If;

               DoneNow:=1;

             End If;

<<LoopHere>>
            null;
        
        end Loop;

        return Text$;

    End WordWrapFunc;
    
end osi_util;
/