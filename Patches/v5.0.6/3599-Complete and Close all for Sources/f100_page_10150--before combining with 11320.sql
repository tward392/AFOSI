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
--   Date and Time:   09:39 Monday May 21, 2012
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>1044521331756659);
 
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
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
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
'	';

ph:=ph||'	clear_cache 	: pageNum});'||chr(10)||
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
'function GetAndOpenMenu(e,pThis,pThat,p';

ph:=ph||'Sub)'||chr(10)||
'{'||chr(10)||
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
' if(pThis != gC';

ph:=ph||'urrentAppMenuImage)'||chr(10)||
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
''||chr(10)||
'function ToggleSubstantive(pActSid)'||chr(10)||
'{'||chr(10)||
' var';

ph:=ph||' get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Check_Access'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pActSid);'||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' if(gReturn==''Y'')'||chr(10)||
'   {'||chr(10)||
'    var get = new htmldb_Get(null,'||chr(10)||
'                             $v(''pFlowId''),'||chr(10)||
'                             ''APPLICATION_PROCESS=IsObjectW';

ph:=ph||'ritable'','||chr(10)||
'                             $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'    get.addParam(''x01'',pActSid);'||chr(10)||
'    gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'    if(gReturn==''Y'')'||chr(10)||
'      {'||chr(10)||
'       if (confirm(''Are you sure you want to change this activity?''))'||chr(10)||
'         {'||chr(10)||
'          var get = new htmldb_Get(null,'||chr(10)||
'                                   $v(''pFlowId''),'||chr(10)||
'                                   ''APPLICATION_PROCESS=OSI_ACTIVITY_TOG';

ph:=ph||'GLE_SUBSTANTIVE'','||chr(10)||
'                                   $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'          get.addParam(''x01'',pActSid);'||chr(10)||
'          gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'          if(gReturn==''Yes'' || gReturn==''No'')'||chr(10)||
'            {'||chr(10)||
'             $(''#''+pActSid).text(gReturn);'||chr(10)||
'            } '||chr(10)||
'          else'||chr(10)||
'            {'||chr(10)||
'             alert(gReturn);'||chr(10)||
'            }'||chr(10)||
'         }'||chr(10)||
'      }'||chr(10)||
'    else'||chr(10)||
'      {'||chr(10)||
'       alert(''This ob';

ph:=ph||'ject is READ ONLY.'');'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'"JS_CREATE_OBJECT"';

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
  p_welcome_text=> '<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#jQuery/superfish-1.4.8/css/superfish.css" media="screen">'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/superfish-1.4.8/js/superfish.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/superfish-1.4.8/js/supersubs.js"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
' '||chr(10)||
'$(document).ready(function()'||chr(10)||
'{'||chr(10)||
'// $(''.htmlExportButton'').before($v(''P10150_CREATEMENU''));'||chr(10)||
' $(''#AssocActAdd'').after($v(''P10150_CREATEMENU''));'||chr(10)||
'// Problem with menu going behind the Report Header and htmlButtons //'||chr(10)||
'//$("li").css(''z-index'', 9001);'||chr(10)||
'//{onBeforeShow:  function(){$("li").css(''z-index'', 9001);}}'||chr(10)||
''||chr(10)||
'     $("ul.sf-menu").supersubs({ '||chr(10)||
'         minWidth:    12,   // minimum width of sub-menus in em units '||chr(10)||
'         maxWidth:    27,   // maximum width of sub-menus in em units '||chr(10)||
'         extraWidth:  1     // extra width can ensure lines don''t sometimes turn over '||chr(10)||
'                            // due to slight rounding differences and font-family '||chr(10)||
'     }).superfish();  // call supersubs first, then superfish, so that subs are '||chr(10)||
'                      // not display:none when measuring. Call before initialising '||chr(10)||
'                      // containing tabs for same reason. '||chr(10)||
''||chr(10)||
' });  '||chr(10)||
'</script>',
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
  p_last_upd_yyyymmddhh24miss => '20120518081919',
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
''||chr(10)||
'27-Oct-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.'||chr(10)||
''||chr(10)||
'15-Mar-2012 - Tim Ward - CR#4010 - Added Multi Removal.  Added '||chr(10)||
'                          "Delete Associations" Process and renamed'||chr(10)||
'                          "Delete Associations" to "Delete Association".'||chr(10)||
'                          Added Delete Associations Button.'||chr(10)||
''||chr(10)||
'21-Mar-2012 - Carolyn Johnson - CR#3644 - Feedback Message Corrections.'||chr(10)||
'                                 Addded P10150_MESSAGE_TO_USER/_2/_3.'||chr(10)||
'                                 Changed Add Associations Process.'||chr(10)||
''||chr(10)||
'09-May-2012 - Tim Ward - CR#4045 - Added Substantive Field.'||chr(10)||
'                                   Also, hide File ID field if the'||chr(10)||
'                                   only filter is ME.'||chr(10)||
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
'       decode(file_sid, :p0_obj,''<a href="javascript:ToggleSubstantive('' || '''''''' || activity_sid || '''''''' || '');" id="'' || activity_sid || ''" title="Toggle Field">'' || decode(substantive,''Y'',''Yes'',''No'') || ''</a>'',decode(substantive,''Y'',''Yes'',''No'')) as "Substantive';

s:=s||'",'||chr(10)||
'       activity_id as "Activity ID", '||chr(10)||
'       activity_type_desc as "Type of Activity", '||chr(10)||
'       osi_object.get_tagline_link(activity_sid) as "Activity Title",'||chr(10)||
'       activity_date as "Activity Date",'||chr(10)||
'       activity_unit_assigned as "Assigned Unit",'||chr(10)||
'       activity_suspense_date as "Suspense Date", '||chr(10)||
'       activity_complete_date as "Completed", '||chr(10)||
'       activity_close_date as "Closed", '||chr(10)||
'       de';

s:=s||'code(sid, :P10150_SEL_ASSOC, ''Y'', ''N'') as "Current",'||chr(10)||
'       ''<a href="'' ||'||chr(10)||
'       ''javascript:popup({page:5060,'' || '||chr(10)||
'            ''clear_cache:''''5060'''','' ||'||chr(10)||
'            ''item_names:''''P5060_OBJ'''','' || '||chr(10)||
'            ''item_values:'' || '''''''' || ACTIVITY_SID || '''''''' || '','' ||'||chr(10)||
'            ''height:550});">'' ||'||chr(10)||
'            ''<IMG SRC="#IMAGE_PREFIX#themes/osi/notes.gif"'' ||'||chr(10)||
'            '' alt="View IDP Notes">';

s:=s||''' ||'||chr(10)||
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
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P10150_ASSOCIATION_FILTER IS NOT NULL AND :P10150_ASSOCIATION_FILTER!=''ME''',
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
  p_id=> 13689902695914164 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Substantive',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Substantive',
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
  p_id=> 8245620631308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Activity ID',
  p_column_display_sequence=> 6,
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
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Type of Activity',
  p_column_display_sequence=> 7,
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
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Title',
  p_column_display_sequence=> 8,
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
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Date',
  p_column_display_sequence=> 9,
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
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Assigned Unit',
  p_column_display_sequence=> 10,
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
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Suspense Date',
  p_column_display_sequence=> 11,
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
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Completed',
  p_column_display_sequence=> 12,
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
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Closed',
  p_column_display_sequence=> 13,
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
  p_query_column_id=> 13,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 14,
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
  p_query_column_id=> 14,
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
  p_query_column_id=> 15,
  p_form_element_id=> null,
  p_column_alias=> 'Reports',
  p_column_display_sequence=> 15,
  p_column_heading=> 'Reports',
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
  p_button_redirect_url=> 'javascript:openLocator(''301'',''P10150_ASSOC_ACT'',''Y'',''&P10150_EXCLUDE_SIDS.'',''OPEN'','''','''',''Choose Activities...'',''ACT'',''&P0_OBJ.'');',
  p_button_condition=> ':P10150_USER_HAS_ADD_ASSOC_PRV = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="AssocActAdd" style="height:19.5px; padding: 4px 3px 0px 3px;"',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_button_comment=>'javascript:popupLocator(300,''P10150_ASSOC_ACT'',''Y'',''&P10150_EXCLUDE_SIDS.'');'||chr(10)||
''||chr(10)||
'javascript:popup({page:150,'||chr(10)||
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
  p_button_cattributes=>'id="ccSelButton" style="height:19.5px; padding: 4px 3px 0px 3px;"',
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
  p_button_cattributes=>'id="ccAllButton" style="height:19.5px; padding: 4px 3px 0px 3px;"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 12169205577672840 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 110,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Association(s)',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE_MULTI'');',
  p_button_cattributes=>'id="AssocActDelete" style="height:19.5px; padding: 4px 3px 0px 3px;"',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
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
  p_button_cattributes=>'id="AssocActCancel" style="height:19.5px; padding: 4px 3px 0px 3px;"',
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
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
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
  p_item_sequence=> 9,
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
  p_item_sequence=> 10,
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
  p_item_sequence=> 2,
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
  p_item_sequence=> 3,
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
  p_item_sequence=> 11,
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
  p_item_sequence=> 12,
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
  p_id=>12314423010727898 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER ',
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
  p_id=>12314632014730469 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER_2',
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
  p_id=>12314805826732391 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER_3',
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
  p_id=>13728408560077593 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_CREATEMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
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
  p_cHeight=> 5,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
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
  p_id=>15698319521880437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
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
  p_item_sequence=> 7,
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
  p_item_sequence=> 8,
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
''||chr(10)||
'       v_temp            varchar2(4000);'||chr(10)||
'       v_act_sid         t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'       v_failure_count   number                                  := 0;'||chr(10)||
'       v_failed_acts     varchar2(4000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     v_temp := replace(:p10150_assoc_act, '':'', ''~'');'||chr(10)||
'     :P10150_MESSAGE_TO_USER_3 := '''';'||chr(10)||
'     :P10150_FAILURE_COUNT := 0;'||chr(10)||
'     :P10150_MESSAGE_TO_USER := ''All Activi';

p:=p||'ties were associated.'';'||chr(10)||
'     :P10150_MESSAGE_TO_USER_2 := '''';'||chr(10)||
'     v_failed_acts := ''Titles of Failed Activities: '';'||chr(10)||
''||chr(10)||
'     for i in 1 .. core_list.count_list_elements(v_temp)'||chr(10)||
'     loop'||chr(10)||
'         v_act_sid := core_list.get_list_element(v_temp,i);'||chr(10)||
''||chr(10)||
'         for k in (select restriction from t_osi_activity where sid = v_act_sid)'||chr(10)||
'         loop'||chr(10)||
'             if (osi_reference.lookup_ref_code(k.restrictio';

p:=p||'n) = ''NONE'') then'||chr(10)||
'  '||chr(10)||
'               insert into t_osi_assoc_fle_act (activity_sid, file_sid) values (v_act_sid, :p0_obj);'||chr(10)||
''||chr(10)||
'             else'||chr(10)||
''||chr(10)||
'               v_failure_count := v_failure_count + 1;'||chr(10)||
'               v_failed_acts := v_failed_acts || osi_activity.get_title(v_act_sid) || ''. '';'||chr(10)||
''||chr(10)||
'             end if;'||chr(10)||
''||chr(10)||
'         end loop;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAG';

p:=p||'E_ID, '''');'||chr(10)||
'     :P10150_FAILURE_COUNT := v_failure_count;'||chr(10)||
''||chr(10)||
'     if :P10150_FAILURE_COUNT > 0 then'||chr(10)||
'  '||chr(10)||
'       :P10150_MESSAGE_TO_USER_2 :=  ''Associate these activities to this file from the activity itself.'';'||chr(10)||
'       :P10150_MESSAGE_TO_USER   := ''Note: ['' || :P10150_FAILURE_COUNT || ''] activities were not associated due to restriction.'';'||chr(10)||
'       :P10150_MESSAGE_TO_USER_3 :=  v_failed_acts;'||chr(10)||
''||chr(10)||
'     end i';

p:=p||'f;'||chr(10)||
''||chr(10)||
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
  p_process_success_message=> '&SUCCESS_MSG. <br> &P10150_MESSAGE_TO_USER. <br> &P10150_MESSAGE_TO_USER_2.  <br><br> &P10150_MESSAGE_TO_USER_3.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'OSI.LOC.ACT'||chr(10)||
''||chr(10)||
'declare'||chr(10)||
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
'        for k in (select restriction'||chr(10)||
'                    from t_osi_activity'||chr(10)||
'                   where sid = v_act_sid)'||chr(10)||
'        loop'||chr(10)||
'            if (osi_reference.lookup_ref_code(k.restriction) = ''NONE'') then'||chr(10)||
'                insert into t_osi_assoc_fle_act'||chr(10)||
'                            (activity_sid, file_sid)'||chr(10)||
'                     values (v_act_sid, :p0_obj);'||chr(10)||
'            else'||chr(10)||
'                v_failure_count := v_failure_count + 1;'||chr(10)||
'            end if;'||chr(10)||
'        end loop;'||chr(10)||
'    end loop;'||chr(10)||
'    :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAGE_ID, '''');'||chr(10)||
'    :P10150_FAILURE_COUNT := v_failure_count;'||chr(10)||
'end;'||chr(10)||
''||chr(10)||
''||chr(10)||
'&SUCCESS_MSG. <br> Note: [&P10150_FAILURE_COUNT.] activities were not associated due to restriction.  <br> If any exist, associate these activities to this file from the activity itself.'||chr(10)||
''||chr(10)||
'');
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
  p_process_name=> 'Delete Association',
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
p:=p||'begin'||chr(10)||
'    for I in 1 .. HTMLDB_APPLICATION.G_F01.count'||chr(10)||
'    loop'||chr(10)||
'        delete from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'              where sid = HTMLDB_APPLICATION.G_F01 (I);'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 12168928648670019 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Associations',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'DELETE_MULTI',
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
'     --- Get Writability ---'||chr(10)||
'     if (:p10150_act_sid is not null) then'||chr(10)||
' '||chr(10)||
'      :p10150_nar_writable := osi_object.check_writability(:p10150_act_sid, null);'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
'     '||chr(10)||
'       :p10150_nar_writable := ''N'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'    --- Get Restriction ---'||chr(10)||
'    for k in (select restriction from t_osi_activity where sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        if (osi_reference.lookup_ref_code(k.restri';

p:=p||'ction) = ''NONE'') then'||chr(10)||
'  '||chr(10)||
'          :p10150_act_is_restricted := ''N'';'||chr(10)||
''||chr(10)||
'        else'||chr(10)||
''||chr(10)||
'          :p10150_act_is_restricted := ''Y'';'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    --- See if selected activity is inherited ---'||chr(10)||
'    :p10150_activity_is_inherited := ''Y'';'||chr(10)||
''||chr(10)||
'    for k in (select * from t_osi_assoc_fle_act where file_sid = :p0_obj and activity_sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        :p10150_activity_is_';

p:=p||'inherited := ''N'';'||chr(10)||
'        return;'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    --- Get privileges ---'||chr(10)||
'    :P10150_USER_HAS_ADD_ASSOC_PRV := osi_auth.check_for_priv(''ASSOC_ACT'', :P0_OBJ_TYPE_SID);'||chr(10)||
''||chr(10)||
'    :P10150_CREATEMENU:=OSI_MENU.GETMENUHTML(''ID_ACTIVITY'',''Create Activity'',''P21001_FROM_OBJ'',:P0_OBJ);'||chr(10)||
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
