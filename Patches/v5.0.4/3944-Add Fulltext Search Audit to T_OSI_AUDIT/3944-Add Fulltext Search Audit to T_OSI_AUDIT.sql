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
--   Date and Time:   09:20 Monday October 3, 2011
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

PROMPT ...Remove page 1080
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1080);
 
end;
/

 
--application/pages/page_01080
prompt  ...PAGE 1080: Desktop Full Text Search
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1080,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Full Text Search',
  p_step_title=> 'Desktop Full Text Search',
  p_step_sub_title => 'Desktop Full Text Search',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_welcome_text=> '<script language="javascript">'||chr(10)||
'function logInfo(v_msg)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Log_Info'','||chr(10)||
'                          $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',v_msg);'||chr(10)||
' gReturn = get.get();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function SearchStart()'||chr(10)||
'{'||chr(10)||
' v_msg=''FullTextSearchStart:''+$v("P1080_SEARCH");'||chr(10)||
' logInfo(v_msg);'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function CheckForEnter(e)'||chr(10)||
'{'||chr(10)||
' if (e.keyCode == 13)'||chr(10)||
'   {'||chr(10)||
'    SearchStart();'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 92011431286949262+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111003091947',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '03-Oct-2011 - TJW - CR#3944 - Added Audit Trail to Full Text Searching.'||chr(10)||
'                               New Page Item P1080_APXWS_ROW_CNT.'||chr(10)||
'                               New Javascript Functions:'||chr(10)||
'                                CheckForEnter, logInfo, SearchStart, SearchEnd.');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select o.sid,'||chr(10)||
'       ''javascript:getObjURL('''''' || o.sid || '''''');'' as "URL", '||chr(10)||
'       core_obj.get_tagline(o.sid) as "Title",'||chr(10)||
'       ot.description as "Object Type", '||chr(10)||
'       o.create_on as "Created On", '||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       score(1) as "Score",'||chr(10)||
'       osi_vlt.get_vlt_url(o.sid) as "VLT",'||chr(10)||
'       null as "Summary"'||chr(10)||
'  from t_core_obj o,'||chr(10)||
'       (select x.sid, x.description'||chr(10)||
'        ';

s:=s||'   from t_core_obj_type x'||chr(10)||
'          where ((instr(:p1080_obj_type,''FILE'')>0 '||chr(10)||
'                 and core_obj.lookup_objtype(''FILE'') '||chr(10)||
'                     member of osi_object.get_objtypes(x.sid))'||chr(10)||
'             or (instr(:p1080_obj_type,''ACT'')>0 '||chr(10)||
'                 and core_obj.lookup_objtype(''ACT'') '||chr(10)||
'                     member of osi_object.get_objtypes(x.sid))'||chr(10)||
'             or (instr(:p1080_obj_type,''P';

s:=s||'ART'')>0 '||chr(10)||
'                 and core_obj.lookup_objtype(''PARTICIPANT'') '||chr(10)||
'                     member of osi_object.get_objtypes(x.sid))'||chr(10)||
'       )) ot'||chr(10)||
' where o.obj_type = ot.sid'||chr(10)||
'   and ((:p1080_atch_option <> ''ONLY'' '||chr(10)||
'        and contains(o.doc1, nvl(:p1080_search,''zzz''), 1)>0)'||chr(10)||
'   or (:p1080_atch_option <> ''NONE'' and exists '||chr(10)||
'         (select 1'||chr(10)||
'            from t_osi_attachment a'||chr(10)||
'           where a.obj =';

s:=s||' o.sid'||chr(10)||
'             and contains(a.content, nvl(:p1080_search,''zzz''), 2)>0)))';

wwv_flow_api.create_page_plug (
  p_id=> 4924313558514629 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_plug_name=> 'Search Results',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_num_rows => 15,
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'nvl(:REQUEST,''RESET'')<>''RESET'' and'||chr(10)||
'osi_auth.check_for_priv(''WEB_SEARCH'',core_obj.lookup_objtype(''NONE''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_footer=> '<script language="javascript">'||chr(10)||
' v_msg=''FullTextSearchEnd:''+$v("P1080_SEARCH");'||chr(10)||
' var v_elem = getElementsByClassName("fielddata", "", document);'||chr(10)||
' '||chr(10)||
' for(i=0;i<v_elem.length;i++)'||chr(10)||
'    {'||chr(10)||
'     if (v_elem[i].parentElement.className=="pagination")'||chr(10)||
'       {'||chr(10)||
'        var pages = v_elem[i].innerHTML.split("-");'||chr(10)||
'        $s(''P1080_APXWS_ROW_CNT'',pages[1]);'||chr(10)||
'        break;'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
' '||chr(10)||
' if (typeof pages === "undefined")'||chr(10)||
'   logInfo(v_msg + '' - 0 found.'');'||chr(10)||
' else '||chr(10)||
'   logInfo(v_msg + '' - '' + pages[1] + '' found.'');'||chr(10)||
''||chr(10)||
'</script>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select o.sid,'||chr(10)||
'       ''javascript:getObjURL('''''' || o.sid || '''''');'' as "URL", '||chr(10)||
'       core_obj.get_tagline(o.sid) as "Title",'||chr(10)||
'       ot.description as "Object Type", '||chr(10)||
'       o.create_on as "Created On", '||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       score(1) as "Score",'||chr(10)||
'       osi_vlt.get_vlt_url(o.sid) as "VLT",'||chr(10)||
'       null as "Summary"'||chr(10)||
'  from t_core_obj o,'||chr(10)||
'       (select x.sid, x.description'||chr(10)||
'        ';

a1:=a1||'   from t_core_obj_type x'||chr(10)||
'          where ((instr(:p1080_obj_type,''FILE'')>0 '||chr(10)||
'                 and core_obj.lookup_objtype(''FILE'') '||chr(10)||
'                     member of osi_object.get_objtypes(x.sid))'||chr(10)||
'             or (instr(:p1080_obj_type,''ACT'')>0 '||chr(10)||
'                 and core_obj.lookup_objtype(''ACT'') '||chr(10)||
'                     member of osi_object.get_objtypes(x.sid))'||chr(10)||
'             or (instr(:p1080_obj_type,''P';

a1:=a1||'ART'')>0 '||chr(10)||
'                 and core_obj.lookup_objtype(''PARTICIPANT'') '||chr(10)||
'                     member of osi_object.get_objtypes(x.sid))'||chr(10)||
'       )) ot'||chr(10)||
' where o.obj_type = ot.sid'||chr(10)||
'   and ((:p1080_atch_option <> ''ONLY'' '||chr(10)||
'        and contains(o.doc1, nvl(:p1080_search,''zzz''), 1)>0)'||chr(10)||
'   or (:p1080_atch_option <> ''NONE'' and exists '||chr(10)||
'         (select 1'||chr(10)||
'            from t_osi_attachment a'||chr(10)||
'           where a.obj =';

a1:=a1||' o.sid'||chr(10)||
'             and contains(a.content, nvl(:p1080_search,''zzz''), 2)>0)))';

wwv_flow_api.create_worksheet(
  p_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1080,
  p_region_id => 4924313558514629+wwv_flow_api.g_id_offset,
  p_name => 'Search Results',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more than 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No data found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => '',
  p_sort_asc_image       => '',
  p_sort_asc_image_attr  => '',
  p_sort_desc_image      => '',
  p_sort_desc_image_attr => '',
  p_sql_query => a1,
  p_status                    =>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving       =>'N',
  p_allow_report_categories   =>'N',
  p_show_nulls_as             =>'-',
  p_pagination_type           =>'ROWS_X_TO_Y',
  p_pagination_display_pos    =>'BOTTOM_RIGHT',
  p_show_finder_drop_down     =>'N',
  p_show_display_row_count    =>'N',
  p_show_search_bar           =>'N',
  p_show_search_textbox       =>'N',
  p_show_actions_menu         =>'N',
  p_report_list_mode          =>'TABS',
  p_show_detail_link          =>'C',
  p_show_select_columns       =>'N',
  p_show_filter               =>'N',
  p_show_sort                 =>'N',
  p_show_control_break        =>'N',
  p_show_highlight            =>'N',
  p_show_computation          =>'N',
  p_show_aggregate            =>'N',
  p_show_chart                =>'N',
  p_show_calendar             =>'N',
  p_show_flashback            =>'N',
  p_show_reset                =>'N',
  p_show_download             =>'N',
  p_show_help            =>'N',
  p_download_formats          =>'CSV',
  p_detail_link              =>'#URL#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'TIM');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 6482132536005115+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'SID',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Sid',
  p_report_label           =>'Sid',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'HIDDEN',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4924600612514637+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'URL',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'Url',
  p_report_label           =>'Url',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'HIDDEN',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4924731688514640+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Title',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Title',
  p_report_label           =>'Title',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'N',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'N',
  p_allow_aggregations     =>'N',
  p_allow_computations     =>'N',
  p_allow_charting         =>'N',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4924817589514640+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Object Type',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Object Type',
  p_report_label           =>'Object Type',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'N',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'N',
  p_allow_aggregations     =>'N',
  p_allow_computations     =>'N',
  p_allow_charting         =>'N',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4924906842514642+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created On',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Created On',
  p_report_label           =>'Created On',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'N',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'N',
  p_allow_aggregations     =>'N',
  p_allow_computations     =>'N',
  p_allow_charting         =>'N',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'&FMT_DATE.',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4925018707514642+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created By',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Created By',
  p_report_label           =>'Created By',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'N',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'N',
  p_allow_aggregations     =>'N',
  p_allow_computations     =>'N',
  p_allow_charting         =>'N',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4925125083514643+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'VLT',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'VLT',
  p_report_label           =>'VLT',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'#VLT#',
  p_column_linktext        =>'&ICON_VLT.',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'N',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'N',
  p_allow_aggregations     =>'N',
  p_allow_computations     =>'N',
  p_allow_charting         =>'N',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4925221632514643+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Score',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Score',
  p_report_label           =>'Score',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'N',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'N',
  p_allow_aggregations     =>'N',
  p_allow_computations     =>'N',
  p_allow_charting         =>'N',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 6478931142929035+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Summary',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Summary',
  p_report_label           =>'Summary',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'javascript:newWindow({page:5560,name:''#SID#detail'',item_names:''P5560_SID'',item_values:''#SID#''});',
  p_column_linktext        =>'Summary',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 4925328158514643+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_worksheet_id => 4924508503514632+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'Title:Object Type:Created On:Created By:Score:VLT:Summary',
  p_sort_column_1           =>'Score',
  p_sort_direction_1        =>'DESC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 4925429033514645 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_plug_name=> 'Full Text Search',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''WEB_SEARCH'',core_obj.lookup_objtype(''NONE''))=''Y''',
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
s:=s||'You do not have access privileges for this folder.';

wwv_flow_api.create_page_plug (
  p_id=> 6184808997276078 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1080,
  p_plug_name=> 'Access Restricted',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'not(osi_auth.check_for_priv(''WEB_SEARCH'',core_obj.lookup_objtype(''NONE''))=''Y'')',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>4927315430514657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_branch_action=> 'f?p=&APP_ID.:1080:&SESSION.::&DEBUG.:RP,1080::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>4926410192514650+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 5,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-MAY-2010 14:37 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>4926914654514657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_branch_action=> 'f?p=&APP_ID.:1080:&SESSION.:SEARCH:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_branch_condition=> 'P1080_SEARCH',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 10-JUN-2009 13:19 by CHRIS');
 
wwv_flow_api.create_page_branch(
  p_id=>4927127254514657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_branch_action=> 'f?p=&APP_ID.:1080:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-MAY-2010 14:40 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4925600850514646 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_name=>'P1080_OBJ_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 4925429033514645+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'FILE:ACT:PART',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Search for:',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Files;FILE,Activities;ACT,Participants;PART',
  p_lov_columns=> 3,
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
  p_id=>4925816935514648 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_name=>'P1080_SEARCH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 4925429033514645+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Enter search criteria:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_WITH_ENTER_SUBMIT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onkeyup="javascript:CheckForEnter(event);"',
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
  p_id=>4926018337514648 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_name=>'P1080_ATCH_OPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 4925429033514645+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'NONE',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Attachment options:',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:Do Not Include Attachments;NONE,Include Attachments;INCLUDE,Only Attachments;ONLY',
  p_lov_columns=> 3,
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
  p_id=>4926201080514650 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_name=>'1080_SEARCH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 4925429033514645+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'SEARCH',
  p_prompt=>'Search',
  p_source=>'SEARCH',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(179221063608554498 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_button_image_attr=> 'onclick="javascript:SearchStart();"',
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4926410192514650 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_name=>'1080_RESET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 4925429033514645+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'RESET',
  p_prompt=>'Reset',
  p_source=>'RESET',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(179221063608554498 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8220829098990576 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1080,
  p_name=>'P1080_APXWS_ROW_CNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 4925429033514645+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Apxws Row Cnt',
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
 
wwv_flow_api.create_page_validation(
  p_id => 4926731049514653 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 1080,
  p_validation_name => 'P1080_SEARCH',
  p_validation_sequence=> 10,
  p_validation => 'P1080_SEARCH',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Search criteria must be specified.',
  p_validation_condition=> 'RESET',
  p_validation_condition_type=> 'REQUEST_NOT_EQUAL_CONDITION',
  p_associated_item=> 4925816935514648 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1080
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
--   Date and Time:   09:21 Monday October 3, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_GETELEMENTSBYCLASSNAME
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
 
 
prompt Component Export: SHORTCUTS 8225002358308500
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'/*'||chr(10)||
'	Developed by Robert Nyman, http://www.robertnyman.com'||chr(10)||
'	Code/licensing: http://code.google.com/p/getelementsbyclassname/'||chr(10)||
'*/'||chr(10)||
'var getElementsByClassName = function (className, tag, elm){'||chr(10)||
'	if (document.getElementsByClassName) {'||chr(10)||
'		getElementsByClassName = function (className, tag, elm) {'||chr(10)||
'			elm = elm || document;'||chr(10)||
'			var elements = elm.getElement';

c1:=c1||'sByClassName(className),'||chr(10)||
'				nodeName = (tag)? new RegExp("\\b" + tag + "\\b", "i") : null,'||chr(10)||
'				returnElements = [],'||chr(10)||
'				current;'||chr(10)||
'			for(var i=0, il=elements.length; i<il; i+=1){'||chr(10)||
'				current = elements[i];'||chr(10)||
'				if(!nodeName || nodeName.test(current.nodeName)) {'||chr(10)||
'					returnElements.push(current);'||chr(10)||
'				}'||chr(10)||
'			}'||chr(10)||
'			return returnElements;'||chr(10)||
'		};'||chr(10)||
'	}'||chr(10)||
'	else if (document.evaluate) {'||chr(10)||
'		getElementsByClassName = f';

c1:=c1||'unction (className, tag, elm) {'||chr(10)||
'			tag = tag || "*";'||chr(10)||
'			elm = elm || document;'||chr(10)||
'			var classes = className.split(" "),'||chr(10)||
'				classesToCheck = "",'||chr(10)||
'				xhtmlNamespace = "http://www.w3.org/1999/xhtml",'||chr(10)||
'				namespaceResolver = (document.documentElement.namespaceURI === xhtmlNamespace)? xhtmlNamespace : null,'||chr(10)||
'				returnElements = [],'||chr(10)||
'				elements,'||chr(10)||
'				node;'||chr(10)||
'			for(var j=0, jl=classes.length; j<jl; j+=1){'||chr(10)||
'';

c1:=c1||'				classesToCheck += "[contains(concat('' '', @class, '' ''), '' " + classes[j] + " '')]";'||chr(10)||
'			}'||chr(10)||
'			try	{'||chr(10)||
'				elements = document.evaluate(".//" + tag + classesToCheck, elm, namespaceResolver, 0, null);'||chr(10)||
'			}'||chr(10)||
'			catch (e) {'||chr(10)||
'				elements = document.evaluate(".//" + tag + classesToCheck, elm, null, 0, null);'||chr(10)||
'			}'||chr(10)||
'			while ((node = elements.iterateNext())) {'||chr(10)||
'				returnElements.push(node);'||chr(10)||
'			}'||chr(10)||
'			return ret';

c1:=c1||'urnElements;'||chr(10)||
'		};'||chr(10)||
'	}'||chr(10)||
'	else {'||chr(10)||
'		getElementsByClassName = function (className, tag, elm) {'||chr(10)||
'			tag = tag || "*";'||chr(10)||
'			elm = elm || document;'||chr(10)||
'			var classes = className.split(" "),'||chr(10)||
'				classesToCheck = [],'||chr(10)||
'				elements = (tag === "*" && elm.all)? elm.all : elm.getElementsByTagName(tag),'||chr(10)||
'				current,'||chr(10)||
'				returnElements = [],'||chr(10)||
'				match;'||chr(10)||
'			for(var k=0, kl=classes.length; k<kl; k+=1){'||chr(10)||
'				classesToCheck.pu';

c1:=c1||'sh(new RegExp("(^|\\s)" + classes[k] + "(\\s|$)"));'||chr(10)||
'			}'||chr(10)||
'			for(var l=0, ll=elements.length; l<ll; l+=1){'||chr(10)||
'				current = elements[l];'||chr(10)||
'				match = false;'||chr(10)||
'				for(var m=0, ml=classesToCheck.length; m<ml; m+=1){'||chr(10)||
'					match = classesToCheck[m].test(current.className);'||chr(10)||
'					if (!match) {'||chr(10)||
'						break;'||chr(10)||
'					}'||chr(10)||
'				}'||chr(10)||
'				if (match) {'||chr(10)||
'					returnElements.push(current);'||chr(10)||
'				}'||chr(10)||
'			}'||chr(10)||
'			return returnElements;'||chr(10)||
'		';

c1:=c1||'};'||chr(10)||
'	}'||chr(10)||
'	return getElementsByClassName(className, tag, elm);'||chr(10)||
'};'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 8225002358308500 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_GETELEMENTSBYCLASSNAME',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;

