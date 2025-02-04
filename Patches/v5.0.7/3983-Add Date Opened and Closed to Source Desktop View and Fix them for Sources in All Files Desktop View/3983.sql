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
--   Date and Time:   11:30 Thursday July 12, 2012
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

PROMPT ...Remove page 1350
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1350);
 
end;
/

 
--application/pages/page_01350
prompt  ...PAGE 1350: Desktop Sources
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_DESKTOP_FILTERS_COL_REF"'||chr(10)||
'"JS_DESKTOP_GOTO_FIRST_PAGE"';

wwv_flow_api.create_page(
  p_id     => 1350,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Sources',
  p_step_title=> '&DESKTOP_TITLE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 92011431286949262+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120712113036',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '13-DEC-2010 J.Faris WCHG0000264 - DT view query updates for performance.'||chr(10)||
''||chr(10)||
'19-Apr-2011 Tim Ward - CR#3784 - Added Title to the available columns.'||chr(10)||
''||chr(10)||
'06-Jan-2012 - Tim Ward - CR#3738 - All/Active Filter missing.  '||chr(10)||
'                         CR#3728 - Save Filter and rows values.'||chr(10)||
'                         CR#3742 - Save Filter and rows values.'||chr(10)||
'                         CR#3641 - Default Sort Order for Recent.'||chr(10)||
'                         CR#3635 - Last Accessed inconsistencies.'||chr(10)||
'                         CR#3563 - Default Desktop Views.'||chr(10)||
'                         CR#3446 - Implement speed improvements.'||chr(10)||
'                         CR#3447 - Implement speed improvements.'||chr(10)||
''||chr(10)||
'12-Jul-2012 - Tim Ward - CR#3983 - Add Date Opened and Closed to Sources'||chr(10)||
'                                    Desktop View.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1350,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT C001, C002, C003, C004, C005, TO_DATE(C006) AS C006, C007, C008, C009, TO_DATE(C010) AS C010, TO_DATE(C011) AS C011, TO_DATE(C012) AS C012, C013, C014'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';';

wwv_flow_api.create_page_plug (
  p_id=> 1627501569148425 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
  p_plug_name=> 'Management Files > Sources',
  p_region_name=>'',
  p_plug_template=> 92167138176750921+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.SOURCE''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> 'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url, '||chr(10)||
'       f.id as "ID",'||chr(10)||
'       st.description as "Source Type",'||chr(10)||
'       decode(osi_object.get_lead_agent(o.sid),'||chr(10)||
'              null, ''NO LEAD AGENT'','||chr(10)||
'              osi_personnel.get_name(osi_object.get_lead_agent(o.sid))) as "Lead Agent",'||chr(10)||
'       osi_unit.get_name('||chr(10)||
'            osi_object.get_assigned_unit(o.sid)) as "Controlling Unit",'||chr(10)||
'       osi_object.get_status(o.sid) as "Status",'||chr(10)||
'       mc.description as "Mission Area",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       f.title as "Title"'||chr(10)||
'  from        (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_f_source f2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = f2.sid'||chr(10)||
'             and (   (    :p1350_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1350_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1350_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1350_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (    :p1350_filter = ''ME'' '||chr(10)||
'                      and osi_object.is_assigned(o1.sid)=''Y'')'||chr(10)||
'                  or (    :p1350_filter = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1350_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'                  or (    :p1350_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'                                 osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_osi_file f,'||chr(10)||
'       t_osi_f_source s,'||chr(10)||
'       t_osi_f_source_type st,'||chr(10)||
'       t_osi_mission_category mc'||chr(10)||
' where o.sid = s.sid'||chr(10)||
'   and s.sid = f.sid'||chr(10)||
'   and s.source_type = st.sid'||chr(10)||
'   and mc.sid(+) = s.mission_area');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'SELECT C001, C002, C003, C004, C005, TO_DATE(C006) AS C006, C007, C008, C009, TO_DATE(C010) AS C010, TO_DATE(C011) AS C011, TO_DATE(C012) AS C012, C013, C014'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';';

wwv_flow_api.create_worksheet(
  p_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1350,
  p_region_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_name => 'Management > Sources',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Sources found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1350_FILTER',
  p_sort_asc_image       => '',
  p_sort_asc_image_attr  => '',
  p_sort_desc_image      => '',
  p_sort_desc_image_attr => '',
  p_sql_query => a1,
  p_status                    =>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving       =>'Y',
  p_allow_report_categories   =>'N',
  p_show_nulls_as             =>'-',
  p_pagination_type           =>'ROWS_X_TO_Y',
  p_pagination_display_pos    =>'BOTTOM_RIGHT',
  p_show_finder_drop_down     =>'Y',
  p_show_display_row_count    =>'Y',
  p_show_search_bar           =>'Y',
  p_show_search_textbox       =>'Y',
  p_show_actions_menu         =>'Y',
  p_report_list_mode          =>'TABS',
  p_show_detail_link          =>'C',
  p_show_select_columns       =>'Y',
  p_show_filter               =>'Y',
  p_show_sort                 =>'Y',
  p_show_control_break        =>'Y',
  p_show_highlight            =>'Y',
  p_show_computation          =>'N',
  p_show_aggregate            =>'N',
  p_show_chart                =>'N',
  p_show_calendar             =>'N',
  p_show_flashback            =>'N',
  p_show_reset                =>'N',
  p_show_download             =>'Y',
  p_show_help            =>'Y',
  p_download_formats          =>'CSV',
  p_download_filename         =>'&P1350_EXPORT_NAME.',
  p_detail_link              =>'#C001#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="" />',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 10064126553597852+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C001',
  p_display_order          =>1,
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
  p_id => 10083415208625991+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C002',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'ID',
  p_report_label           =>'ID',
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
wwv_flow_api.create_worksheet_column(
  p_id => 10083513407625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C003',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Source Type',
  p_report_label           =>'Source Type',
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
wwv_flow_api.create_worksheet_column(
  p_id => 10083630096625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C004',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Lead Agent',
  p_report_label           =>'Lead Agent',
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
wwv_flow_api.create_worksheet_column(
  p_id => 10083722448625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C005',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Controlling Unit',
  p_report_label           =>'Controlling Unit',
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
wwv_flow_api.create_worksheet_column(
  p_id => 10083831855625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C006',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Date Created',
  p_report_label           =>'Date Created',
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
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 10083912315625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C007',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Status',
  p_report_label           =>'Status',
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
wwv_flow_api.create_worksheet_column(
  p_id => 10084016823625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C008',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Mission Area',
  p_report_label           =>'Mission Area',
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
wwv_flow_api.create_worksheet_column(
  p_id => 10084129939625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C009',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Title',
  p_report_label           =>'Title',
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
wwv_flow_api.create_worksheet_column(
  p_id => 10084226464625992+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C010',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
  p_column_label           =>'Date Opened',
  p_report_label           =>'Date Opened',
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
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 14841426098772443+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C013',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
  p_column_label           =>'Times Accessed',
  p_report_label           =>'Times Accessed',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C013 IS NOT NULL AND COLLECTION_NAME=''P1350_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 14841516658772449+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C014',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Ranking',
  p_report_label           =>'Ranking',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C014 IS NOT NULL AND COLLECTION_NAME=''P1350_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 14843310346805778+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C011',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
  p_column_label           =>'Date Closed',
  p_report_label           =>'Date Closed',
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
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 14843410379805778+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C012',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'Last Accessed',
  p_report_label           =>'Last Accessed',
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
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C012 IS NOT NULL AND COLLECTION_NAME=''P1350_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 1628100116149296+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
  p_worksheet_id => 1627602467148425+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>25,
  p_report_columns          =>'C002:C003:C004:C005:C006:C007:C008:C010:C011:C012:C013:C014',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'You do not have access privileges for this folder.';

wwv_flow_api.create_page_plug (
  p_id=> 6187026444290582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1350,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.SOURCE''))=''N''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15469607162508987 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1350,
  p_button_sequence=> 10,
  p_button_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1350);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>2474300917513654 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_branch_action=> 'f?p=&APP_ID.:1350:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 06-APR-2010 12:17 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2473712214507409 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_name=>'P1350_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER',
  p_lov => '.'||to_char(6129207658248740 + wwv_flow_api.g_id_offset)||'.',
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>10066107684630305 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_name=>'P1350_ACTIVE_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER_ACTIVE',
  p_lov => '.'||to_char(8788412414956145 + wwv_flow_api.g_id_offset)||'.',
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
  p_id=>10066312879631757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_name=>'P1350_NUM_ROWS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Num Rows',
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
  p_id=>10354022955345062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_name=>'P1350_OBJECT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SOURCES',
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
  p_id=>15469813742510910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_name=>'P1350_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 1627501569148425+wwv_flow_api.g_id_offset,
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
  p_id=> 10065524869625759 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_computation_sequence => 40,
  p_computation_item=> 'P1350_NUM_ROWS',
  p_computation_point=> 'BEFORE_BOX_BODY',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                               ''P'' || :APP_PAGE_ID || ''_NUM_ROWS.'' || ''SOURCES'','||chr(10)||
'                               ''25'');'||chr(10)||
'',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 2473816716508753 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_computation_sequence => 10,
  p_computation_item=> 'P1350_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1350_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 10066418074633286 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1350,
  p_computation_sequence => 40,
  p_computation_item=> 'P1350_ACTIVE_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'ACTIVE',
  p_compute_when => 'P1350_ACTIVE_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
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
'   :P1350_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                   ''P'' || :APP_PAGE_ID || ''_FILTER.'' || ''SOURCES'','||chr(10)||
'                                                   ''RECENT'');'||chr(10)||
''||chr(10)||
'   :P1350_ACTIVE_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                          ''P'' || :APP_PAGE_ID || ''_ACTIVE_FILTER.'' ||';

p:=p||' ''SOURCES'','||chr(10)||
'                                                          ''ACTIVE'');'||chr(10)||
''||chr(10)||
'End;';

wwv_flow_api.create_page_process(
  p_id     => 10065318635623956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1350,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP FILTERS DEFAULT',
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
-- ...updatable report columns for page 1350
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





set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_DESKTOP" AS
/******************************************************************************
   Name:     osi_desktop
   Purpose:  Provides Functionality for OSI Desktop Views

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    18-Oct-2010 Tim Ward        Created Package (WCGH0000264)
    02-Nov-2010 Tim Ward        WCHG0000262 - Notification Filters Missing
    16-Nov-2010 Jason Faris     WCHG0000262 - replaced missing comma on line 240
    02-Dec-2010 Tim Ward        WCHG0000262 - replaced missing comma on line 137
    02-Mar-2011 Tim Ward        CR#3723 - Changed DesktopCFundExpensesSQL to 
                                 use PARAGRAPH_NUMBER instead of PARAGRAPH so it 
                                 displays the correct #.
    02-Mar-2011 Tim Ward        CR#3716/3709 - Context is Wrong. 
                                 Changed DesktopCFundExpensesSQL to build context.
    18-Apr-2011 Tim Ward        CR#3754-CFunds Expense Desktop View Description too large. 
                                 Changed DesktopCFundExpensesSQL make Context and Description
                                 links truncated to 25 characters, title has the full text so
                                 when the user hovers over the link, it pops-up as a tooltip.
    23-Jun-2011 Tim Ward        CR#3868 - Added p_ReturnPageItemName to DesktopSQL 
                                 to support popup locators.
    23-Jun-2011 Tim Ward        CR#3868 - Added DesktopMilitaryLocationsSQL AND DesktopCityStateCountrySQL. 
    28-Nov-2011 Tim Ward        CR#3738 - Adding Active/All Flag.
                                CR#3623 - Active/All Filters Missing.
                                 Added correct order by for Activities (when not recent).
                                 Added ACTIVE_FILTER, NUM_ROWS, and PAGE_ID 
                                 parameters to DesktopSQL
                                 Changed desktopactivitiessql, desktopcfundexpensessql.
    28-Nov-2011 Tim Ward        CR#3446 - Implement improved code for faster performance
                                CR#3447 - Implement improved code for faster performance
                                 Added DesktopFilesSQL and DesktopParticipantsSQL.
    28-Nov-2011 Tim Ward        CR#3563 - Default Desktop Views.
                                CR#3742 - Default # Rows and Desktop Views.
                                CR#3728 - Default # Rows and Filters.
                                 Changed in DesktopSQL (to save to T_OSI_PERSONNEL_SETTINGS).
    28-Nov-2011 Tim Ward        CR#3641 - Default Sort Order for "Recent" Filters.
                                CR#3635 - Last Accessed/Times Accessed Inconsistencies.
                                 Changed all Desktop*SQL Functions.
    28-Nov-2011 Tim Ward        CR#3711 - Add Category to AAPP (Agent Applicant) Desktop View.
                                 Actually added any noticable missing columns to Desktop Views.
                                 Changed DesktopFilesSQL.
    28-Nov-2011 Tim Ward        CR#3964 - Add Lead Agent to Desktop->Files Desktop View.
                                CR#3727 - Add Lead Agent to Desktop->Files Desktop View.
                                 Changed DesktopFilesSQL.
    05-Dec-2011 Tim Ward        CR#3639 - Full Text Search added/optimized.
                                 Added DesktopFullTextSearchSQL and added p_OtherSearchCriteria to DesktopSQL.
    29-Dec-2011 WCC             Modified DesktopActivitiesSQL to use t_osi_activity_lookup
    05-Jan-2012 Tim Ward        CR#3781 - Added order by to CFunds Expenses to make it sort like Legacy.
                                 Changed in DesktopCFundExpensesSQL.
    06-Jan-2012 Tim Ward        CR#3446 - Implement improved code for faster performance
                                CR#3447 - Implement improved code for faster performance
                                 Added DesktopCFundsAdvanceSQL.
                                 Added DesktopEvidenceManagementSQL.
                                 Added DesktopPersonnelSQL.
                                 Added DesktopWorkHoursSQL.
                                 Added DesktopSourcesSQL.
                                 Added DesktopUnitSQL.
    27-Feb-2012 Tim Ward        CR#4002 - Combining Locators and Adding Active/All filters with Optimization.
                                 Added p_isLocator, p_Exclude, and p_isLocateMany to DesktopSQL parameters.
                                 Added Get_Filter_LOV, Get_Active_Filter_LOV, and Get_Participants_LOV.
                                 Added addLocatorReturnLink, AddFilter, and Desktop Functions for Locators.  
                                  Changed DesktopSQL to support the the locators.
                                  Changed existing Desktop Functions that needt to be Locators as well.
    26-Mar-2012 Tim Ward        CR#3446 - Improvements to the Files Desktop My Unit Query.
                                        - Subordinate Units should not show "My Unit".
                                        - Missing columns in Activities Search.
                                 Changed in DesktopFilesSQL.
                                 Changed in DesktopActivitiesSQL.
    29-Mar-2012 Tim Ward        CR#3446 - Commented out Piping in DesktopSQL as the Query in DesktopParticpantSQL
                                 can exceed 4000 characters which makes the log_error function error out.
    30-Mar-2012 Tim Ward        CR#3446 - Moved the log_error line before the return in ApexProcessRowTextContains.
                                          Added a Number of Previous Filters Logging to AddApexSearchFilters.
                                          Removed all formatting of SQLString from all procedures (removed extra
                                           spaces and vCRLF).
                                          Added the Call to the Pipe in DesktopSQL and added some error checking
                                           to CORE_LOGGER.LOG_IT.
    04-Apr-2012 Tim Ward        CR#3738 - Added Primary Offense Back into Columns.
                                 Changed DesktopFilesSQL.
    04-Apr-2012 Tim Ward        CR#3689 - Right Click Menu on Desktop.
                                 Added AddRankingToSelect, made KEEP_ON_TOP part of select and order by 
                                  for Recent Objects.  T_OSI_PERSONNEL_RECENT_OBJECTS.KEEP_ON_TOP Date
                                  field added.
                                 Added Support for "Email Link to this Object", new Locator Type of PERSONNEL_EMAIL.
                                  Changed in DesktopSQL, DesktopPersonnelSQL, and get_filter_lov.
    05-Jun-2012 Tim Ward        CR#4036 - Recent My Unit Duplicates.
                                 Added Sum/Max and Group By to SelectString.
                                 Changed AddRankingToSelect, DesktopActivitiesSQL, DesktopCFundAdvancesSQL, DesktopCFundExpensesSQL, 
                                  DesktopCityStateCountrySQL, DesktopEvidenceManagementSQL, DesktopFilesSQL, DesktopMilitaryLocationsSQL, 
                                  DesktopNotificationsSQL, DesktopOffensesSQL, DesktopParticipantsSQL, DesktopPersonnelSQL, DesktopSourcesSQL,
                                  DesktopUnitSQL, and DesktopWorkHoursSQL.
    12-Jul-2012 Tim Ward        CR#3983 - Add Date Opened and Date Closed to Sources Desktop View and make them fill in in the All Files View.
                                 Changed in DesktopFilesSQL and DesktopSourcesSQL.
                                       
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_DESKTOP';
    type assoc_arr is table of varchar2(255) index by varchar2(255);

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    FUNCTION addLocatorReturnLink(ReturnValue in varchar2 := 'o.sid', p_isLocatorMulti IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2, p_isLocateMany IN VARCHAR2 := 'N') return varchar2 is
      
      SQLString VARCHAR2(32000);
        
    BEGIN
         if p_isLocatorMulti='Y' then
           
           if p_isLocateMany='Y' then
           
             SQLString := 'select apex_item.checkbox(1,' || 
                                                     ReturnValue || ',' || 
                                                     '''' || 'onclick="toggleCheckbox(this); loadIndividuals();"' || '''' || ',' || 
                                                     '''' || ':p0_loc_selections' || '''' || ',' || 
                                                     '''' || ':' || '''' || ') as "Include",';
           
           else
  
             SQLString := 'select apex_item.checkbox(1,' || 
                                                     ReturnValue || ',' || 
                                                     '''' || 'onclick="toggleCheckbox(this);"' || '''' || ',' || 
                                                     '''' || ':p0_loc_selections' || '''' || ',' || 
                                                     '''' || ':' || '''' || ') as "Include",';
           
           end if;
           
         else

           if p_isLocateMany='Y' then
           
             SQLString := 'select ' || '''' || '<a href="javascript:loadIndividuals(''''' || '''' || ' || ' || ReturnValue || ' || ''''' || '''' || ');">Select</a>' || '''' || ' as "Select",' || vCRLF;
           
           else
             
             SQLString := 'select ' || '''' || '<a href="javascript:passBack(''''' || '''' || ' || ' || ReturnValue || ' || ''''' || '''' || ',' || '''' || '''' || p_ReturnPageItemName || '''' || '''' || ');">Select</a>' || '''' || ' as "Select",' || vCRLF;

           end if;
         
         end if;

         return SQLString;
         
    END addLocatorReturnLink;
    
    FUNCTION AddRankingToSelect(asNull in varchar2 := 'N', leadingComma in varchar2 := 'Y', trailingComma in varchar2 := 'N', FILTER in varchar2) return varchar2 is

            vTempString CLOB;
            
    BEGIN
         if asNull = 'Y' then

           vTempString := vTempString || CASE leadingComma when 'Y' then ',' else '' END || 
                          'NULL as "Last Accessed",' || 
                          'NULL as "Times Accessed",' || 
                          'NULL as "Ranking"' || CASE trailingComma when 'Y' then ',' else '' END;
         
         else
           
           if (FILTER='RECENT') then

             vTempString := vTempString || CASE leadingComma when 'Y' then ',' else '' END || 
                            'to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || 
                            'to_char(r1.times_accessed,''00000'') as "Times Accessed",' || 
                            'to_char(decode(r1.keep_on_top,null,r1.times_accessed/power((sysdate-r1.last_accessed+1),2),999999.999999),''000000.000000'') as "Ranking"' || CASE trailingComma when 'Y' then ',' else '' END;
           else

             ----RECENT MY UNIT----         
             vTempString := vTempString || CASE leadingComma when 'Y' then ',' else '' END || 
                           'to_char(max(r1.last_accessed),''dd-Mon-rrrr'') as "Last Accessed",' || 
                           'to_char(sum(r1.times_accessed),''00000'') as "Times Accessed",' || 
                           'to_char(decode(r1.keep_on_top,null,sum(r1.times_accessed)/power((sysdate-max(r1.last_accessed)+1),2),999999.999999),''000000.000000'') as "Ranking"' || CASE trailingComma when 'Y' then ',' else '' END;

           end if;                    

         end if;
         
         return vTempString;
         
    END AddRankingToSelect;
        
    FUNCTION ApexProcessRowTextContains(RowTextContains in varchar2, column_names in assoc_arr) return varchar2 is

      CurrentColumn VARCHAR2(255);
      ColumnCount NUMBER;
      SQLString VARCHAR2(32000);

    BEGIN
         log_error('>>>ApexProcessRowTextContains(' || RowTextContains || ',column_names' || ')');
         IF RowTextContains is not null THEN
                 
           IF length(RowTextContains)>0 THEN

             SQLString := SQLString || 
                              ' AND (';
                 
             CurrentColumn := column_names.first;
             ColumnCount := 0;
             loop
                 exit when CurrentColumn is null;
                 ColumnCount := ColumnCount + 1;
                     
                 IF ColumnCount > 1 THEN
  
                   SQLString := SQLString ||  
                                    ' or ';
                                  
                 END IF;

                 SQLString := SQLString ||
                              'instr(upper(' || column_names(CurrentColumn) || '),upper(' || '''' || RowTextContains || '''' || '))> 0';
                                
                 CurrentColumn := column_names.next(CurrentColumn);

             end loop;
                 
             SQLString := SQLString || ')';
  
           END IF;
                              
         END IF;

         log_error('<<<ApexProcessRowTextContains(' || RowTextContains || ',column_names' || ')');
         return SQLString;

    EXCEPTION WHEN OTHERS THEN
             log_error('Error in ApexProcessRowTextContains - ' || sqlerrm);
             return '';
         
    END ApexProcessRowTextContains;

    FUNCTION AddApexSearchFilters(p_OtherSearchCriteria in VARCHAR2, column_names in assoc_arr, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      RowTextContains VARCHAR2(32000);
      ColumnName VARCHAR2(32000);
      Operator VARCHAR2(32000);
      EXPR VARCHAR2(32000);
      EXPR2 VARCHAR2(32000);
      ConditionID VARCHAR2(32000);
      strPOS number;
      Multiplier VARCHAR2(32000);
      mySelect VARCHAR2(32000);
      
      p_Cursor SYS_REFCURSOR;
      
    BEGIN
         log_error('>>>AddApexSearchFilters(' || p_OtherSearchCriteria || ',column_names' || ',' || p_WorksheetID  || ',' || p_APP_USER  || ',' || p_Instance || ',' || p_ReportName || ')');
         
         --- Handle Current Search Criteria ---
         IF instr(p_OtherSearchCriteria, '^~^') > 0 THEN
                 
           IF instr(p_OtherSearchCriteria, 'Row text contains ') > 0 THEN
                   
             RowTextContains := replace(replace(p_OtherSearchCriteria,'Row text contains ^~^',''), chr(39), chr(39) || chr(39));
             SQLString := SQLString || ApexProcessRowTextContains(RowTextContains, column_names);

           ELSE
                 
             strPOS := instr(p_OtherSearchCriteria, '^~^');
                 
             SQLString := SQLString || 
                          ' AND (upper(' || column_names(substr(p_OtherSearchCriteria,1,strPOS-1)) || ') like upper(''%' || replace(substr(p_OtherSearchCriteria,strPOS+3), chr(39), chr(39) || chr(39)) || '%' || '''' || '))';
                              
           END IF;

         END IF;

         --- Build the APEX FILTER SEARCH ---
         mySelect := 'select c.name,c.column_name,c.operator,c.expr,c.expr2' ||  
                     ' from apex_030200.wwv_flow_worksheet_conditions c,apex_030200.wwv_flow_worksheet_rpts r' ||  
                     ' where c.enabled=''Y''' || 
                     ' and c.REPORT_ID=r.ID' || 
                     ' and r.session_id=' || p_Instance || 
                     ' and r.application_user=' || '''' || p_APP_USER || '''' || 
                     ' and r.worksheet_id=' || p_WorksheetID;
        
        if p_ReportName is null or p_ReportName='' then

          mySelect := mySelect || ' and (r.name='''' or r.name is null)';
        
        else

          mySelect := mySelect || ' and r.name=' || '''' || replace(p_ReportName, chr(39), chr(39) || chr(39)) || '''';
                
        end if;
        
        log_error('AddApexSearchFilters - ' || mySelect);
          
         OPEN P_CURSOR FOR mySelect;

         log_error('AddApexSearchFilters - Previous APEX filters Found:  ' || P_CURSOR%ROWCOUNT);
                        
         --- Get any Previous APEX Filters for the Report ---
         BEGIN
              LOOP

                  FETCH p_Cursor INTO RowTextContains, ColumnName, Operator, EXPR, EXPR2;
                  EXIT WHEN p_Cursor%NOTFOUND;

                  EXPR := replace(EXPR, chr(39), chr(39) || chr(39));
                  EXPR2 := replace(EXPR2, chr(39), chr(39) || chr(39));

                  IF instr(RowTextContains, 'Row text contains ') > 0 THEN
                   
                    RowTextContains := replace(RowTextContains,'Row text contains ' || chr(39), '');
                    RowTextContains := substr(RowTextContains, 1, length(RowTextContains)-1);
                    RowTextContains := replace(RowTextContains, chr(39), chr(39) || chr(39));
                    SQLString := SQLString || ApexProcessRowTextContains(RowTextContains, column_names);
                       
                  ELSIF instr(Operator,'contains') > 0 THEN

                       SQLString := SQLString || 
                                    ' AND (upper(' || column_names(ColumnName) || ') like upper(''%' || EXPR || '%' || '''' || '))';

                  ELSIF instr(Operator,'does not contain') > 0 THEN

                       SQLString := SQLString || 
                                    ' AND (upper(' || column_names(ColumnName) || ') not like upper(''%' || EXPR || '%' || '''' || '))';
                       
                  ELSIF Operator in ('like','not like') THEN

                       SQLString := SQLString || 
                                    ' AND (' || column_names(ColumnName) || ' ' || Operator || '''' || EXPR || '''' || ')';

                  ELSIF Operator in ('in','not in') THEN

                       SQLString := SQLString || 
                                    ' AND (' || column_names(ColumnName) || ' ' || Operator || ' (''' || replace(EXPR, ',', chr(39) || ',' || chr(39)) || '''' || '))';

                  ELSIF instr(Operator,'between') > 0 THEN
                  
                       IF instr(ColumnName,'TO_DATE(') > 0 THEN

                         SQLString := SQLString || 
                                      ' AND (' || column_names(ColumnName) || ' between ' || 'TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS'')' || ' AND ' || 'TO_DATE(' || '''' || EXPR2 || '''' || ',''YYYYMMDDHH24MISS'')' || ')';

                       ELSE     

                         SQLString := SQLString || 
                                      ' AND (' || column_names(ColumnName) || ' between ' || '''' || EXPR || '''' || ' AND ' || '''' || EXPR2 || '''' || ')';

                       END IF;
                  
                  ELSIF instr(Operator,'>') > 0 or instr(Operator,'<') > 0 THEN
                  
                       IF instr(ColumnName,'TO_DATE(') > 0 THEN
                    
                         SQLString := SQLString || 
                                      ' AND (' || column_names(ColumnName) || ' ' || Operator || ' TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS''))';

                       END IF;

                  ELSIF instr(Operator,'is in the') > 0 or instr(Operator,'is not in the') > 0 THEN

                       Case upper(EXPR2)

                           WHEN 'MINUTES' THEN
                                              MultiPlier := '((1/1440)*' || EXPR || ')';
                                           
                             WHEN 'HOURS' THEN
                                              MultiPlier := '((1/24)*' || EXPR || ')';
                                           
                              WHEN 'DAYS' THEN
                                              MultiPlier := '(1*' || EXPR || ')';
                                           
                             WHEN 'WEEKS' THEN
                                              MultiPlier := '(7*' || EXPR || ')';
                                           
                            WHEN 'MONTHS' THEN
                                              MultiPlier := 'add_months(systimestamp, -1*' || EXPR || ')';
                                           
                             WHEN 'YEARS' THEN
                                              MultiPlier := 'add_months(systimestamp, -12*' || EXPR || ')';
                                         
                        
                       end Case;
                  
                       if instr(Operator,'is in the last') > 0 then
                    
                         if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' between ' || MultiPlier || ' and systimestamp)';
                    
                         else
                     
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' between systimestamp-' || MultiPlier || ' and systimestamp)';
                    
                         end if;
                    
                       elsif instr(Operator,'is not in the last') > 0 then
                    
                         if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' not between ' || MultiPlier || ' and systimestamp)';
                    
                         else
                    
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' not between systimestamp-' || MultiPlier || ' and systimestamp)';

                         end if;

                       elsif instr(Operator,'is in the next') > 0 then

                            if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                            else
                       
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' between systimestamp and systimestamp+' || MultiPlier || ')';
                            end if;
                    
                       elsif instr(Operator,'is not in the next') > 0 then

                            if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' not between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                            else
                       
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' not between systimestamp and systimestamp+' || MultiPlier || ')';

                            end if;
                            
                       end if;

                  ELSIF length(Operator) > 0 and length(EXPR) > 0 and length(ColumnName) > 0 then
                       
                       SQLString := SQLString || 
                                    ' AND (' || column_names(ColumnName) || ' ' || Operator || ' ' || '''' || EXPR || '''' || ')';

                  END IF;
             
              end loop;
         END;
         log_error('<<<AddApexSearchFilters');
         RETURN SQLString;
  
    EXCEPTION WHEN OTHERS THEN
             log_error('Error in AddApexSearchFilters - ' || sqlerrm);
             return '';
           
    END AddApexSearchFilters;

    -----------------------------------------------------------------------------------
    ---   RETURN ALL subordinate units TO THE specified unit. THE specified unit IS ---
    ---   included IN THE output (AS THE FIRST ENTRY). THE LIST IS comma separated. ---
    -----------------------------------------------------------------------------------
    FUNCTION Get_Subordinate_Units  (pUnit IN VARCHAR2) RETURN VARCHAR2 IS

      pSubUnits VARCHAR2(32000) := NULL;
  
    BEGIN
         FOR u IN (SELECT SID FROM T_OSI_UNIT 
                         WHERE SID <> pUnit
                              START WITH SID = pUnit CONNECT BY PRIOR SID = UNIT_PARENT)
         LOOP
         
             IF pSubUnits IS NOT NULL THEN

               pSubUnits := pSubUnits || ',';
         
             END IF;

             pSubUnits := pSubUnits || '''' || u.SID || '''';
             
         END LOOP;

         IF pSubUnits IS NULL THEN
       
           pSubUnits := '''none''';
         
         END IF;

         pSubUnits := '(' || pSubUnits || ')';

         RETURN pSubUnits;

    EXCEPTION WHEN OTHERS THEN
             
             pSubUnits := '''none''';
             log_error('OSI_DESKTOP.Get_Subordinate_Units(' || pUnit || ') error: ' || SQLERRM );
             RETURN pSubUnits;

    END Get_Subordinate_Units;

    FUNCTION Get_Supported_Units (pUnit IN VARCHAR2)  RETURN VARCHAR2 IS

      pSupportedUnits VARCHAR2(32000) := NULL;
  
    BEGIN
         pSupportedUnits := NULL;

         FOR u IN (SELECT DISTINCT unit FROM T_OSI_UNIT_SUP_UNITS WHERE sup_unit=pUnit)
         LOOP
             IF pSupportedUnits IS NOT NULL THEN
          
               pSupportedUnits := pSupportedUnits || ',';
          
             END IF;
          
             pSupportedUnits := pSupportedUnits || '''' || u.unit || '''';
         
         END LOOP;

         IF pSupportedUnits IS NULL THEN
         
           pSupportedUnits := '''none''';
         
         END IF;

         pSupportedUnits := '(' || pSupportedUnits || ')';

         RETURN pSupportedUnits;

    EXCEPTION
             WHEN OTHERS THEN

                 pSupportedUnits := '''none''';
                 log_error('OSI_DESKTOP.Get_Supported_Units(' || pUnit || ') error: ' || SQLERRM );
                 RETURN pSupportedUnits;

    END Get_Supported_Units;
         
    /***************************/ 
    /*  CFund Expenses Section */   
    /***************************/ 
    FUNCTION DesktopCFundExpensesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopCFundExpensesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='to_char(e.incurred_date,''dd-Mon-rrrr'')';
         column_names('C003'):='e.claimant_name';
         column_names('C004'):='''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent)';
         column_names('C005'):='TO_CHAR(e.total_amount_us,''FML999G999G999G990D00'')';
         column_names('C006'):='e.CATEGORY';
         column_names('C007'):='e.paragraph_number';
         column_names('C008'):='e.modify_on';
         column_names('C009'):='e.voucher_no';
         column_names('C010'):='e.charge_to_unit_name';
         column_names('C011'):='e.status';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.SID ||'''''');'' as url,' || 
                      'to_char(e.incurred_date,''dd-Mon-rrrr'') as "Date Incurred",' || 
                      'e.claimant_name as "Claimant",' || 
                      '''<div class="tooltip" tip="Activity: '' || to_clob(htf.escape_sc(osi_activity.get_id(e.parent)) || '' - '' || core_obj.get_tagline(e.parent)) || ''">'' || substr(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent),1,25) || case when length(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent)) > 25 then ''...'' end || ''</div>'' as "Context",' || 
                      'TO_CHAR(e.total_amount_us, ''FML999G999G999G990D00'') as "Total Amount",' || 
                      '''<div class="tooltip" tip="'' || htf.escape_sc(substr(e.description,1,3000)) || ''">'' || substr(e.description,1,25) || case when length(e.description) > 25 then ''...'' end || ''</div>'' as "Description",' || 
                      'e.CATEGORY as "Category",' || 
                      'e.paragraph_number as "Paragraph",' || 
                      'e.modify_on as "Last Modified",' || 
                      'e.voucher_no as "Voucher #",' || 
                      'e.charge_to_unit_name as "Charge to Unit",' || 
                      'e.status as "Status"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
           
           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);

         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || 
                      ' from v_cfunds_expense_v3 e,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE e.SID=o.SID' || 
                        ' AND ot.code=''CFUNDS_EXP''';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        ' AND OSI_OBJECT.IS_OBJECT_ACTIVE(e.SID)=''Y''';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.claimant=''' || user_sid ||  '''' || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.charge_to_unit=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.charge_to_unit in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.charge_to_unit IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' ||
                                                                ' group by e.sid,e.incurred_date,e.claimant_name,e.total_amount_us,e.paragraph_number,e.voucher_no,e.modify_on,e.charge_to_unit_name,e.parent,e.description,e.category,e.status,r1.keep_on_top' ||                                                                 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopCFundExpensesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopCFundExpensesSQL;

    /***************************/ 
    /*  CFund Advances Section */   
    /***************************/ 
    FUNCTION DesktopCFundAdvancesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopCFundAdvancesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='to_char(a.request_date,''dd-Mon-rrrr'')';
         column_names('C003'):='to_char(a.issue_on+90,''dd-Mon-rrrr'')';
         column_names('C004'):='osi_personnel.get_name(a.claimant)';
         column_names('C005'):='a.narrative';
         column_names('C006'):='TO_CHAR(a.amount_requested,''FML999G999G999G990D00'')';
         column_names('C007'):='cfunds_pkg.get_advance_status(a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date)';
         column_names('C008'):='osi_unit.get_name(a.unit)';
         column_names('C009'):='osi_unit.get_name(osi_personnel.get_current_unit(a.claimant))';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| a.SID ||'''''');'' as url,' || 
                      'to_char(a.request_date,''dd-Mon-rrrr'') as "Date Requested",' || 
                      'to_char(a.issue_on+90,''dd-Mon-rrrr'') as "Suspense Date",' || 
                      'osi_personnel.get_name(a.claimant) as "Claimant",' || 
                      '''<div class="tooltip" tip="'' || htf.escape_sc(substr(a.narrative,1,3000)) || ''">'' || substr(a.narrative,1,25) || case when length(a.narrative) > 25 then ''...'' end || ''</div>'' as "Description",' || 
                      'TO_CHAR(a.amount_requested,''FML999G999G999G990D00'') as "Amount Requested",' || 
                      'cfunds_pkg.get_advance_status(a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date) as "Status",' || 
                      'osi_unit.get_name(a.unit) as "Charge To Unit",' || 
                      'osi_unit.get_name(osi_personnel.get_current_unit(a.claimant)) as "Claimants Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_cfunds_advance_v2 a,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE a.SID=o.SID' || 
                        ' AND ot.sid=o.obj_type' || 
                        ' AND ot.code=''CFUNDS_ADV''';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        ' AND DECODE(Cfunds_Pkg.Get_Advance_Status(A.SUBMITTED_ON,A.APPROVED_ON,A.REJECTED_ON,A.ISSUE_ON,A.CLOSE_DATE),''Closed'',0,1)=1';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.claimant=''' || user_sid ||  '''' || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.unit=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.unit in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.unit IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' ||
                                                                ' group by a.sid,a.request_date,a.issue_on,a.claimant,a.narrative,a.amount_requested,a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date,a.unit,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopCFundAdvancesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopCFundAdvancesSQL;

    /**************************/ 
    /*  Notifications Section */   
    /**************************/ 
    FUNCTION DesktopNotificationsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopNotificationsSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='et.description';
         column_names('TO_DATE(C003)'):='to_char(n.generation_date,''dd-Mon-rrrr'')';
         column_names('C004'):='Core_Obj.get_tagline(e.PARENT)';
         column_names('C005'):='p.PERSONNEL_NAME';
         column_names('C006'):='e.specifics';
         column_names('C007'):='Osi_Unit.GET_NAME(e.impacted_unit)';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.parent ||'''''');'' as url,' || 
                      'et.description as "Event",' || 
                      'to_char(n.generation_date,''dd-Mon-rrrr'') as "Event Date",' || 
                      '''<div class="tooltip" tip="'' || htf.escape_sc(substr(Core_Obj.get_tagline(e.PARENT),1,3000)) || ''">'' || substr(Core_Obj.get_tagline(e.PARENT),1,25) || case when length(Core_Obj.get_tagline(e.PARENT)) > 25 then ''...'' end || ''</div>'' as "Context",' || 
                      'p.PERSONNEL_NAME as "Recipient",' || 
                      'e.specifics as "Specifics",' || 
                      'Osi_Unit.GET_NAME(e.impacted_unit) as "Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_NOTIFICATION n,' || 
                      'T_OSI_NOTIFICATION_EVENT e,' || 
                      'T_OSI_NOTIFICATION_EVENT_TYPE et,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o,' || 
                      'V_OSI_PERSONNEL p';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE e.PARENT=o.SID' || 
                        ' AND ot.code=''NOTIFICATIONS''' || 
                        ' AND n.EVENT=e.SID' || 
                        ' AND et.SID=e.EVENT_CODE' || 
                        ' AND n.RECIPIENT=p.SID';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND RECIPIENT=''' || user_sid || '''';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.impacted_unit=''' || UnitSID ||  '''';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.impacted_unit in ' || Get_Subordinate_Units(UnitSID); 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.impacted_unit IN ' || Get_Supported_Units(UnitSID);
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by e.parent,et.description,n.generation_date,p.personnel_name,e.specifics,e.impacted_unit,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
                                                                                                               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopNotificationsSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopNotificationsSQL;

    /***************************************/ 
    /*  Evidence Management Module Section */   
    /***************************************/ 
    FUNCTION DesktopEvidenceManagementSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopEvidenceManagementSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='osi_unit.get_name(u.sid)';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:newWindow({page:30700,clear_cache:''''30700'''',name:''''EMM'' || u.sid || '''''',item_names:''''P0_OBJ'''',item_values:'''''' || u.sid || '''''',request:''''OPEN''''});'' as url,' || 
                      '       ''Evidence Management Module for: '' || osi_unit.get_name(u.sid) as "Module Name"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_UNIT u,' || 
                      'T_CORE_OBJ o';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE u.sid=o.SID';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID || '''' || 
                                                                ' ORDER BY "Module Name"';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Module Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid in ' || Get_Subordinate_Units(UnitSID) ||  
                                                                ' ORDER BY "Module Name"';
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY "Module Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by u.sid,r1.keep_on_top ' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY "Module Name"';
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
                                                                                                               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopEvidenceManagementSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopEvidenceManagementSQL;
    
    /***********************/ 
    /*  Activities Section */   
    /***********************/ 
    FUNCTION DesktopActivitiesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      
      column_names assoc_arr;
      
    BEGIN
         column_names('C002'):='a.id';
         column_names('C003'):='a.activity_type';
         column_names('C004'):='a.title';
         column_names('C005'):='a.lead_agent';
         column_names('C006'):='a.status';
         column_names('C007'):='a.controlling_unit';
         column_names('TO_DATE(C008)'):='a.created_on';

         column_names('C013'):='a.created_by';
         column_names('C014'):='a.Is_Lead';
         column_names('TO_DATE(C015)'):='a.Date_Completed';
         column_names('TO_DATE(C016)'):='a.Suspense_Date';
         
         log_error('>>>OSI_DESKTOP.DesktopActivitiesSQL(' || FILTER || ',' || user_sid || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ')');
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('a.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'SELECT a.url,' || vCRLF;
         
         end if;                  

         SQLString := SQLString || 
                      'a.ID as "ID",' || 
                      'a.Activity_Type as "Activity Type",' || 
                      'a.title as "Title",' || 
                      'a.Lead_Agent as "Lead Agent",' || 
                      'a.Status as "Status",' || 
                      'a.Controlling_Unit as "Controlling Unit",' || 
                      'a.Created_On as "Created On",';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','Y',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','Y',FILTER);
         
         END IF;
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || 
                        'a.VLT as "VLT",';

         else

           SQLString := SQLString || 
                        'NULL as "VLT",';
         end if;

         --- Fields not Shown by Default ---
         SQLString := SQLString || 
                      'a.created_by as "Created By",' || 
                      'a.Is_Lead as "Is a Lead",' || 
                      'a.Date_Completed as "Date Completed",' || 
                      'a.Suspense_Date as "Suspense Date"';
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_osi_activity_lookup a' ;

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE 1=1' || vCRLF;
                        
         END IF;
         
         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                       ' AND OSI_OBJECT.IS_OBJECT_ACTIVE(a.SID)=''Y''';
                        
         END IF;
         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',a.sid) = 0';
         
         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
           
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.sid in (select obj from t_osi_assignment where end_date is null and personnel=''' || user_sid || ''')' || 
                                                                ' ORDER BY a.activity_type';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.controlling_unit_sid=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY a.activity_type';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.controlling_unit_sid in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY a.activity_type'; 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.controlling_unit_sid IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY a.activity_type';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=a.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=a.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by a.sid,a.id,a.activity_type,a.title,a.url,a.lead_agent,a.status,a.controlling_unit,a.vlt,a.is_lead,a.date_completed,a.suspense_date,a.created_on,a.created_by,r1.keep_on_top' ||  
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY a.activity_type';                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopActivitiesSQL(' || FILTER || ',' || user_sid || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ')');
         RETURN SQLString;
         
    END DesktopActivitiesSQL;
    
    /******************/ 
    /*  Files Section */   
    /******************/ 
    FUNCTION DesktopFilesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);

      shDateOpenedCode VARCHAR2(100):='DECODE(ot.code,''FILE.SOURCE'',''AC'',''OP'')';
      shDateClosedCode VARCHAR2(100):='DECODE(ot.code,''FILE.SOURCE'',''TM'',''CL'')';
      
      column_names assoc_arr;
      
    BEGIN
         column_names('C002'):='F.ID';
         column_names('C003'):='OT.DESCRIPTION';
         column_names('C004'):='F.TITLE';
         column_names('C006'):='osi_object.get_status(f.sid)';
         column_names('C007'):='osi_unit.get_name(osi_file.get_unit_owner(f.sid))';
         column_names('C012'):='o.create_by';
         column_names('C013'):='osi_status.last_sh_date(f.sid,' || shDateOpenedCode || ')';
         column_names('C014'):='osi_status.last_sh_date(f.sid,' || shDateClosedCode || ')';
         column_names('C015'):='osi_file.get_days_since_opened(f.sid)';
         column_names('C016'):='Osi_Object.get_lead_agent_name(f.SID)';
         
         log_error('>>>OSI_DESKTOP.DesktopFilesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('f.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'select ''javascript:getObjURL('''''' || f.sid || '''''');'' url,';
         
         end if;                  
            
         SQLString := SQLString || 
                      'f.id as "ID",' || 
                      'ot.description as "File Type",' || 
                      'f.title as "Title",' || 
                      'o.create_on as "Created On",' || 
                      'osi_object.get_status(f.sid) as "Status",' || 
                      'osi_unit.get_name(osi_file.get_unit_owner(f.sid)) as "Controlling Unit",';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','Y',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','Y',FILTER);
         
         END IF;
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || 
                        '''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||f.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||f.sid||''''''''||''''||'',request:''''OPEN''''})'' as "VLT",';

         else

           SQLString := SQLString || 
                        'NULL as "VLT",';
         end if;

         --- Fields not Shown by Default ---
         SQLString := SQLString || 
                      'o.create_by as "Created By",' || 
                      'osi_status.last_sh_date(f.sid,' || shDateOpenedCode || ') as "Date Opened",' || 
                      'osi_status.last_sh_date(f.sid,' || shDateClosedCode || ') as "Date Closed",' || 
                      'osi_file.get_days_since_opened(f.sid) as "Days Since Opened",' || 
                      'Osi_Object.get_lead_agent_name(f.SID) as "Lead Agent"';

         --- Fields For Investigative Files Only ---
         IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           column_names('C017'):='mc.description';
           SQLString := SQLString || ',' || 
                        'mc.description as "Mission Area"';
                        
           IF p_ObjType IN ('FILE.INV','FILE.INV.CASE') THEN

             column_names('C018'):='osi_investigation.get_final_roi_date(f.sid)';
             SQLString := SQLString || ',' || 
                          'osi_investigation.get_final_roi_date(f.sid) as "ROI"';
           
           ELSE               

             SQLString := SQLString || ',NULL as "ROI"';

           END IF;

           column_names('C019'):='Primary Offense';
           SQLString := SQLString || ',(select dot.code || '' '' || dot.description from t_osi_f_inv_offense io,t_dibrs_offense_type dot,t_osi_reference r where io.investigation=f.sid and io.priority=r.sid and r.usage=''OFFENSE_PRIORITY'' and r.code=''P'' and io.offense=dot.sid) as "Primary Offense"';
         
         END IF;

         --- Fields For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           column_names('C017'):='aapp.category_desc';
           column_names('C018'):='aapp.applicant_rank';
           column_names('C019'):='aapp.suspense_date';
           column_names('C020'):='aapp.curr_disp';
           column_names('C021'):='aapp.start_date';
           
           SQLString := SQLString || ',' || 
                        'aapp.category_desc as "Category",' || 
                        'aapp.applicant_rank as "Rank",' || 
                        'aapp.suspense_date as "Suspense Date",' || 
                        'aapp.curr_disp as "Current Disposition",' || 
                        'aapp.start_date as "Start Date"';
         
         ELSE

           SQLString := SQLString || ',' || 
                        'NULL as "Category",' || 
                        'NULL as "Rank",' || 
                        'NULL as "Suspense Date",' || 
                        'NULL as "Current Disposition",' || 
                        'NULL as "Start Date"';
         
         END IF;

         --- Fields For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN
         
           column_names('C017'):='osi_unit.get_name(csp.requesting_unit)';
           column_names('C018'):='osi_unit.get_name(csp.rpo_unit)';
           SQLString := SQLString || ',' || 
                        'osi_unit.get_name(csp.requesting_unit) as "Requesting Unit",' || 
                        'osi_unit.get_name(csp.rpo_unit) as "RPO"';

         ELSE
         
           SQLString := SQLString || ',' || 
                        'NULL as "Requesting Unit",' || 
                        'NULL as "RPO"';

         END IF;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_FILE f,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';

         IF FILTER IN ('UNIT','SUB_UNIT','SUP_UNIT') THEN
                           
           SQLString := SQLString ||  
                        ',T_OSI_F_UNIT fu';

         END IF;
         
         --- Tables For Investigative Files Only ---
         IF p_ObjType in ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           SQLString := SQLString || ',' || 
                      'T_OSI_MISSION_CATEGORY mc,' || 
                      'T_OSI_F_INVESTIGATION i';
         
         END IF;

         --- Tables For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           SQLString := SQLString || ',' || 
                        'v_osi_f_aapp_file aapp';
         
         END IF;

         --- Tables For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN

           SQLString := SQLString || ',' || 
                        't_osi_f_poly_file csp';
         
         END IF;
                      
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE f.SID=o.SID' || 
                        ' AND o.obj_type=ot.SID';
                        
         END IF;
         
         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        '  AND OSI_OBJECT.IS_OBJECT_ACTIVE(f.SID)=''Y''';
                        
         END IF;

         --- WHERE Clause Parts for Investigative Files Only ---
         IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           SQLString := SQLString || 
                        ' AND i.sid=f.sid' || 
                        ' AND mc.sid(+)=i.manage_by';
           
           IF p_ObjType = 'FILE.INV' THEN

             SQLString := SQLString || 
                          ' AND ot.code in (''FILE.INV.CASE'',''FILE.INV.DEV'',''FILE.INV.INFO'',''FILE.INV'')';
           
           ELSE

             SQLString := SQLString || 
                          ' AND ot.code=''' || p_ObjType || '''';

           END IF;
                  
         END IF;
         
         --- WHERE Clause Parts for Service Files Only ---
         IF p_ObjType in ('FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC') THEN
           
           IF p_ObjType='FILE.SERVICE' THEN

             SQLString := SQLString || 
                          ' AND ot.code in (''FILE.AAPP'',''FILE.GEN.ANP'',''FILE.PSO'',''FILE.POLY_FILE.SEC'')';
                          
           ELSE

             SQLString := SQLString || 
                          ' AND ot.code in (''' || p_ObjType || ''')';
           
           END IF;
           
         END IF;

         --- WHERE Clause Parts for Support Files Only ---
         IF p_ObjType in ('FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM','FILE.GEN.TARGETMGMT') THEN
           
           IF p_ObjType='FILE.SUPPORT' THEN

             SQLString := SQLString || 
                          ' AND ot.code in (''FILE.SUPPORT'',''FILE.GEN.SRCDEV'',''FILE.GEN.UNDRCVROPSUPP'',''FILE.GEN.TECHSURV'',''FILE.POLY_FILE.CRIM'')';
                          
           ELSE

             SQLString := SQLString || 
                          ' AND ot.code in (''' || p_ObjType || ''')';
           
           END IF;
           
         END IF;

         --- Where Clause Part For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           SQLString := SQLString || 
                        ' AND aapp.sid=o.sid';
         
         END IF;

         --- Where Clause Part For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN

           SQLString := SQLString || 
                        ' AND csp.sid=o.sid';
         
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',f.sid) = 0';
         
         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
                                                  
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND o.sid in (select obj from t_osi_assignment where end_date is null and personnel=''' || user_sid || ''')';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND fu.file_sid=f.sid' || 
                                                                ' AND fu.unit_sid=''' || UnitSID ||  '''' || 
                                                                ' AND fu.end_date is null';
         
                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND fu.file_sid=f.sid' || 
                                                                ' AND fu.unit_sid in (select a.sid from t_osi_unit a start with a.sid=''' || UnitSID || '''' || ' connect by prior a.sid=a.unit_parent)' || 
                                                                ' AND fu.end_date is null' || 
                                                                ' AND fu.unit_sid!=''' || UnitSID || '''';
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND fu.file_sid=f.sid' || 
                                                                ' AND fu.unit_sid in (select unit from t_osi_unit_sup_units where sup_unit=''' || UnitSID || '''' || ')' || 
                                                                ' AND fu.end_date is null';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                                                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         --- Add the Order By Clause ---
         CASE
             WHEN FILTER IN ('RECENT') THEN
           
                 SQLString := SQLString ||
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER IN ('RECENT_UNIT') THEN

                 SQLString := SQLString ||
                              ' group by f.sid,f.id,ot.description,f.title,o.create_on,o.create_by,r1.keep_on_top' ||    
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='NONE' THEN            

                 NULL;           

             ELSE

               --- Order By Clause for Investigative Files Only ---
               IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

                 SQLString := SQLString ||  
                              ' ORDER BY title';
                              
                 IF p_ObjType IN ('FILE.INV','FILE.INV.CASE') THEN

                   SQLString := SQLString || ',ROI DESC';
                   
                 END IF;                              

               --- Order By Clause for Service Files Only ---
               ELSIF p_ObjType in ('FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC') THEN

                    SQLString := SQLString ||  
                                 ' ORDER BY ot.description,title';

               --- Order By Clause for Support Files Only ---
               ELSIF p_ObjType in ('FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM') THEN

                    SQLString := SQLString ||  
                                 ' ORDER BY ot.description,title';
               ELSE

                 SQLString := SQLString ||  
                              ' ORDER BY ot.description,title';

               END IF;
                                                 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopFilesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopFilesSQL;

    /************************/ 
    /*  Participant Section */   
    /************************/ 
    FUNCTION DesktopParticipantSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      groupBy VARCHAR2(32000);
      
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopParticipantSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ')');
         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('o.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url,';
           
         end if;
         
         groupBy := groupBy || 'o.sid,p.sid,o.create_by,o.create_on,r1.keep_on_top';
         
         CASE
             WHEN ACTIVE_FILTER in ('ALL') then

                 column_names('C002'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C006'):='osi_participant.get_type(o.sid)';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C021'):='osi_reference.lookup_ref_desc(ph.sa_service)';
                 column_names('C022'):='osi_reference.lookup_ref_desc(ph.sa_affiliation)';
                 column_names('C023'):='dibrs_reference.lookup_ref_desc(ph.sa_component)';
                 column_names('C024'):='dibrs_reference.lookup_ref_desc(pc.sa_pay_plan)';
                 column_names('C025'):='pg.description';
                 column_names('C026'):='ph.sa_rank';
                 column_names('C027'):='ph.sa_rank_date';
                 column_names('C028'):='ph.sa_specialty_code';

                 groupBy := groupBy || ',ph.sa_service,ph.sa_affiliation,ph.sa_affiliation,ph.sa_component,pc.sa_pay_plan,pg.description,ph.sa_rank,ph.sa_rank_date,ph.sa_specialty_code';
                 
                 SQLString := SQLString || 
                              'osi_participant.get_name(o.sid,''Y'') as "Name",' || 
                              'NULL as "Company",' || 
                              'NULL as "Organization",' || 
                              'NULL as "Program",' || 
                              'osi_participant.get_type(o.sid) as "Type",' || 
                              'osi_participant.get_subtype(o.sid) as "Sub-Type",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_service) as "Service",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_affiliation) as "Service Affiliation",' || 
                              'dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",' || 
                              'dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",' || 
                              'pg.description as "Service Pay Grade",' || 
                              'ph.sa_rank as "Service Rank",' || 
                              'ph.sa_rank_date as "Service Date of Rank",' || 
                              'ph.sa_specialty_code as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.INDIV') then

                 column_names('C002'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C008'):='osi_participant.get_name_type(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C012'):='dibrs_reference.lookup_ref_desc(pc.sex)';
                 column_names('C013'):='pc.height';
                 column_names('C014'):='pc.weight';
                 column_names('C015'):='decode(ph.age_low,null,null,''NB'',''0.008'',''NN'',''0.0014'',''BB'',''0.5'',ph.age_low)';
                 column_names('C016'):='ph.age_high';
                 column_names('C017'):='osi_participant.get_birth_country(o.sid)';
                 column_names('C018'):='osi_participant.get_birth_state(o.sid)';
                 column_names('C019'):='osi_participant.get_birth_city(o.sid)';
                 column_names('C020'):='p.dob';
                 column_names('C021'):='osi_reference.lookup_ref_desc(ph.sa_service)';
                 column_names('C022'):='osi_reference.lookup_ref_desc(ph.sa_affiliation)';
                 column_names('C023'):='dibrs_reference.lookup_ref_desc(ph.sa_component)';
                 column_names('C024'):='dibrs_reference.lookup_ref_desc(pc.sa_pay_plan)';
                 column_names('C025'):='pg.description';
                 column_names('C026'):='ph.sa_rank';
                 column_names('C027'):='ph.sa_rank_date';
                 column_names('C028'):='ph.sa_specialty_code';

                 groupBy := groupBy || ',pc.sex,pc.height,pc.weight,ph.age_low,ph.age_high,p.dob,ph.sa_service,ph.sa_affiliation,ph.sa_component,pc.sa_pay_plan,pg.description,ph.sa_rank,ph.sa_rank_date,ph.sa_specialty_code,pv.sid';

                 SQLString := SQLString || 
                              'osi_participant.get_name(o.sid,''Y'') as "Name",' || 
                              'NULL as "Company",' || 
                              'NULL as "Organization",' || 
                              'NULL as "Program",' || 
                              'NULL as "Type",' || 
                              'NULL as "Sub-Type",' || 
                              'osi_participant.get_name_type(o.sid) as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'dibrs_reference.lookup_ref_desc(pc.sex) as "Sex",' || 
                              'pc.height as "Height (in)",' || 
                              'pc.weight as "Weight (lbs)",' || 
                              'decode(ph.age_low, null, null,''NB'',''0.008'',''NN'',''0.0014'',''BB'',''0.5'',ph.age_low) as "Minimum Age (yrs)",' || 
                              'ph.age_high as "Maximum Age (yrs)",' || 
                              'osi_participant.get_birth_country(o.sid) as "Birth Country",' || 
                              'osi_participant.get_birth_state(o.sid) as "Birth State",' || 
                              'osi_participant.get_birth_city(o.sid) as "Birth City",' || 
                              'p.dob as "Birth Date",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_service) as "Service",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_affiliation) as "Service Affiliation",' || 
                              'dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",' || 
                              'dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",' || 
                              'pg.description as "Service Pay Grade",' || 
                              'ph.sa_rank as "Service Rank",' || 
                              'ph.sa_rank_date as "Service Date of Rank",' || 
                              'ph.sa_specialty_code as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.COMP') then

                 column_names('C003'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C029'):='pnh.co_duns';
                 column_names('C030'):='pnh.co_cage';
                 
                 SQLString := SQLString || 
                              'NULL as "Name",' || 
                              'osi_participant.get_name(o.sid) as "Company",' || 
                              'NULL as "Organization",' || 
                              'NULL as "Program",' || 
                              'NULL as "Type2",' || 
                              'osi_participant.get_subtype(o.sid) as "Type",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'NULL as "Service",' || 
                              'NULL as "Service Affiliation",' || 
                              'NULL as "Service Component",' || 
                              'NULL as "Service Pay Plan",' || 
                              'NULL as "Service Pay Grade",' || 
                              'NULL as "Service Rank",' || 
                              'NULL as "Service Date of Rank",' || 
                              'NULL as "Service Speciality Code",' || 
                              'pnh.co_duns as "DUNS",' || 
                              'pnh.co_cage as "Cage Code"';

                 groupBy := groupBy || ',pnh.co_duns,pnh.co_cage';  

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.ORG') then

                 column_names('C004'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';

                 SQLString := SQLString || 
                              'NULL as "Name",' || 
                              'NULL as "Company",' || 
                              'osi_participant.get_name(o.sid) as "Organization",' || 
                              'NULL as "Program",' || 
                              'NULL as "Type2",' || 
                              'osi_participant.get_subtype(o.sid) as "Type",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'NULL as "Service",' || 
                              'NULL as "Service Affiliation",' || 
                              'NULL as "Service Component",' || 
                              'NULL as "Service Pay Plan",' || 
                              'NULL as "Service Pay Grade",' || 
                              'NULL as "Service Rank",' || 
                              'NULL as "Service Date of Rank",' || 
                              'NULL as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.PROG') then

                 column_names('C005'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';

                 SQLString := SQLString || 
                              'NULL as "Name",' || 
                              'NULL as "Company",' || 
                              'NULL as "Organization",' || 
                              'osi_participant.get_name(o.sid) as "Program",' || 
                              'NULL as "Type",' || 
                              'NULL as "Type2",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'NULL as "Service",' || 
                              'NULL as "Service Affiliation",' || 
                              'NULL as "Service Component",' || 
                              'NULL as "Service Pay Plan",' || 
                              'NULL as "Service Pay Grade",' || 
                              'NULL as "Service Rank",' || 
                              'NULL as "Service Date of Rank",' || 
                              'NULL as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

         END CASE;

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','Y',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','Y',FILTER);
         
         END IF;

         --- Add SSN ---
         IF ACTIVE_FILTER in ('PART.INDIV') THEN

           column_names('C034'):='osi_participant.get_number(pv.sid,''SSN'')';
           SQLString := SQLString || 
             'osi_participant.get_number(pv.sid,''SSN'') as "Social Security Number",';

         ELSE

           SQLString := SQLString || 
             'NULL as "Social Security Number",';

         END IF;         
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || 
                        '''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||p.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||p.sid||''''''''||''''||'',request:''''OPEN''''})'' as "VLT"';

         else

           SQLString := SQLString || 
                        'NULL as "VLT"';
         
         end if;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_CORE_OBJ o,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_OSI_PARTICIPANT p,' || 
                      'T_OSI_PARTIC_NAME pn,' || 
                      'T_OSI_PARTICIPANT_VERSION pv,' || 
                      'T_OSI_PARTICIPANT_HUMAN ph,' || 
                      'T_OSI_PARTICIPANT_NONHUMAN pnh,' || 
                      'T_OSI_PERSON_CHARS pc,' || 
                      'T_DIBRS_PAY_GRADE_TYPE pg';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE p.SID=o.SID' || 
                        ' AND o.obj_type=ot.SID' || 
                        ' AND p.current_version=pv.sid' || 
                        ' AND pn.sid=pv.current_name' || 
                        ' AND ph.sid(+)=pv.sid' || 
                        ' AND pnh.sid(+)=pv.sid' || 
                        ' AND pc.sid(+)=pv.sid' || 
                        ' AND pg.sid(+)=pc.sa_pay_grade';
                        
         END IF;

         IF p_ObjType = 'PARTICIPANT' THEN
           
           IF ACTIVE_FILTER='ALL' THEN
  
             SQLString := SQLString || 
                          ' AND ot.code in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'',''PART.NONINDIV.PROG'')';
           
           ELSE
  
             SQLString := SQLString || 
                          ' AND ot.code=''' || ACTIVE_FILTER || '''';
           
           END IF;
                  
         ELSE

           SQLString := SQLString || 
                        ' AND ot.code=''' || p_ObjType || '''';

         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',o.sid) = 0' || 
                        ' and not exists(select 1 from t_osi_participant_version pv1 where pv1.participant=o.SID and instr(' || '''' || p_Exclude || '''' || ',pv1.sid)>0)';         

         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 

                             WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[a|b|c][[:alpha:]]'',1,1,0,''i'')=1';
                                                                
                             WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[d|e|f][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[g|h|i][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[j|k|l][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[m|n|o][[:alpha:]]'',1,1,0,''i'')=1';

                            WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[t|u|v][[:alpha:]]'',1,1,0,''i'')=1';

                            WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'')=1';

                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[0-9]'',1,1,0,''i'')=1';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[a-z]'',1,1,0,''i'')=1';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                                                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         --- Add the Order By Clause ---
         CASE
             WHEN FILTER IN ('RECENT_UNIT') THEN
           
                 SQLString := SQLString || ' group by ' || groupBy ||  
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER IN ('RECENT') THEN
           
                 SQLString := SQLString ||  
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='NONE' THEN            

                 NULL;           

             ELSE
               
               CASE
                   WHEN p_ObjType='PARTICIPANT' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Type","Name"';
                                    
                   WHEN p_ObjType='PART.INDIV' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Name"';

                   WHEN p_ObjType='PART.NONINDIV.COMP' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Company"';

                   WHEN p_ObjType='PART.NONINDIV.ORG' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Organization"';

                   WHEN p_ObjType='PART.NONINDIV.PROG' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Program"';

               END CASE;
               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopParticipantSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;

    EXCEPTION WHEN OTHERS THEN

            log_error('>>>OSI_DESKTOP.DesktopParticipantSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ')--->' || SQLERRM);
             
    END DesktopParticipantSQL;
    
    /**********************/ 
    /*  Personnel Section */   
    /**********************/ 
    FUNCTION DesktopPersonnelSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_PersonnelType IN VARCHAR2 := 'PERSONNEL', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      groupBy VARCHAR2(32000);
      
      EmailDomainAllowed VARCHAR2(4000) := core_util.GET_CONFIG('OSI.NOTIF_EMAIL_ALLOW_ADDRESSES');

      column_names assoc_arr;
   
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopPersonnelSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         IF p_PersonnelType='EMAIL' THEN

           column_names('C002'):='osi_personnel.get_name(p.sid)';
           column_names('C003'):='cont.value';

         ELSE
         
           column_names('C002'):='p.personnel_num';
           column_names('C003'):='osi_personnel.get_name(p.sid)';
           column_names('C004'):='osi_unit.get_name(osi_personnel.get_current_unit(p.sid))';
           column_names('C005'):='sex.code';
           column_names('C006'):='op.start_date';
           column_names('C007'):='op.ssn';
           column_names('C008'):='op.badge_num';
        
         END IF;
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('p.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || p.sid || '''''');'' url,';
           
         end if;
         
         IF p_PersonnelType='EMAIL' THEN

           SQLString := SQLString || 
                        'osi_personnel.get_name(p.sid) as "Name",' || 
                        'cont.value as "Email Address",' ||
                        'NULL as "Unit Name",' || 
                        'NULL as "Sex",' || 
                        'NULL as "Start Date",' || 
                        'NULL as "SSN",' || 
                        'NULL as "Badge Number"';
                        
                        groupBy := 'p.sid,cont.value';
         
         ELSE

           SQLString := SQLString || 
                        'p.personnel_num as "Employee #",' || 
                        'osi_personnel.get_name(p.sid) as "Name",' || 
                        'osi_unit.get_name(osi_personnel.get_current_unit(p.sid)) as "Unit Name",' || 
                        'sex.code as "Sex",' || 
                        'op.start_date as "Start Date",' || 
                        'op.ssn as "SSN",' || 
                        'op.badge_num as "Badge Number"';

                        groupBy := 'p.personnel_num,p.sid,sex.code,op.start_date,op.ssn,op.badge_num';
         
         END IF;
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_core_personnel p,' || 
                      't_osi_personnel op,' || 
                      't_osi_person_chars c,' || 
                      't_dibrs_reference sex';
         
         IF p_PersonnelType='EMAIL' THEN

           SQLString := SQLString || ',t_osi_personnel_contact cont,t_osi_reference r';

         END IF;
         
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE p.SID=op.SID' || 
                        ' AND c.SID(+)=p.SID' || 
                        ' AND sex.SID(+)=c.sex';
                        
         END IF;

         IF p_PersonnelType='EMAIL' THEN

           SQLString := SQLString || ' and cont.personnel=p.sid and r.sid=cont.type and r.code=''EMLP''';
           
           IF EmailDomainAllowed is not null THEN
             
             SQLString := SQLString || ' and upper(substr(cont.value,' || -length(EmailDomainAllowed) || '))=''' || upper(EmailDomainAllowed) || ''''; 
             
           END IF;
           
         END IF;
                                         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      '    AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        '    AND instr(' || '''' || p_Exclude || '''' || ', p.sid) = 0';
         
         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND p.sid=''' || user_sid || '''' || 
                                                                ' ORDER BY "Name"';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(p.sid)=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(p.sid) in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY "Name"'; 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(p.sid) IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY "Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=p.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=p.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by ' || groupBy || ',r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY "Name"'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopPersonnelSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopPersonnelSQL;
    
    /********************/ 
    /*  Sources Section */   
    /********************/ 
    FUNCTION DesktopSourcesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopSourcesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='f.id';
         column_names('C003'):='st.description';
         column_names('C004'):='Osi_Object.get_lead_agent_name(s.SID)';
         column_names('C005'):='osi_unit.get_name(osi_object.get_assigned_unit(s.sid))';
         column_names('C006'):='o.create_on';
         column_names('C007'):='osi_object.get_status(s.sid)';
         column_names('C008'):='mc.description';
         column_names('C009'):='f.title';
         column_names('C010'):='osi_status.last_sh_date(f.sid,''AC'')'; 
         column_names('C011'):='osi_status.last_sh_date(f.sid,''TM'')'; 

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('s.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || s.sid || '''''');'' url,';
           
         end if;
         
         SQLString := SQLString || 
                      'f.id as "ID",' || 
                      'st.description as "Source Type",' || 
                      'Osi_Object.get_lead_agent_name(s.SID) as "Lead Agent",' || 
                      'osi_unit.get_name(osi_object.get_assigned_unit(s.sid)) as "Controlling Unit",' || 
                      'o.create_on as "Date Created",' || 
                      'osi_object.get_status(s.sid) as "Status",' || 
                      'mc.description as "Mission Area",' || 
                      'f.title as "Title",' ||
                      'osi_status.last_sh_date(f.sid,''AC'') as "Date Opened",' || 
                      'osi_status.last_sh_date(f.sid,''TM'') as "Date Closed"'; 

                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_CORE_OBJ o,' || 
                      'T_OSI_FILE f,' || 
                      'T_OSI_F_SOURCE s,' || 
                      'T_OSI_F_SOURCE_TYPE st,' || 
                      'T_OSI_MISSION_CATEGORY mc';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE s.SID=o.SID' || 
                        ' AND s.SID=f.SID' || 
                        ' AND s.source_type=st.sid' || 
                        ' AND mc.sid(+) = s.mission_area';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        ' AND OSI_OBJECT.IS_OBJECT_ACTIVE(s.SID)=''Y''';
         
         ELSIF ACTIVE_FILTER IS NOT NULL AND ACTIVE_FILTER!='ALL' then

              SQLString := SQLString || 
                           ' AND s.source_type=' || '''' || ACTIVE_FILTER || '''';
                            
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',s.sid) = 0';
         
         end if;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND OSI_OBJECT.IS_ASSIGNED(s.sid,''' || user_sid ||  '''' || ')=''Y''' || 
                                                                ' ORDER BY ID'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_object.get_assigned_unit(s.sid)=''' || UnitSID || '''' || 
                                                                ' ORDER BY ID'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_object.get_assigned_unit(s.sid) in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY ID'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_object.get_assigned_unit(s.sid) IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY ID'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' ||
                                                                ' group by s.sid,f.id,st.description,o.create_on,mc.description,f.title,r1.keep_on_top' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY ID'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopSourcesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopSourcesSQL;
    
    /*******************************/ 
    /*  Military Locations Section */   
    /*******************************/ 
    FUNCTION DesktopMilitaryLocationsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='LOCATION_NAME';
         column_names('C004'):='LOCATION_LONG_NAME';
         column_names('C005'):='LOCATION_CITY';
         column_names('C006'):='LOCATION_STATE_COUNTRY';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('l.location_code', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'select ''javascript:getObjURL('''''' || l.location_code || '''''');'' url,';
         
         end if;                  
            
         SQLString := SQLString || 
                      'LOCATION_NAME as "Location Name",' || 
                      'LOCATION_LONG_NAME as "Location Long Name",' || 
                      'LOCATION_CITY as "City",' || 
                      'LOCATION_STATE_COUNTRY as "State/Country Name",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from t_sapro_locations l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',l.location_code) = 0';         

         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[a|b|c][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[d|e|f][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[g|h|i][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[j|k|l][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[m|n|o][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[t|u|v][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[0-9]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[a-z]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=location_code' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString ||  
                                                                '   AND r1.obj=location_code' || 
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || 
                                                                '   group by location_name,location_long_name,location_city,location_state_country,r1.keep_on_top ' ||
                                                                '    ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY LOCATION_NAME';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopMilitaryLocationsSQL;

    /****************************/ 
    /*  Briefing Topics Section */   
    /****************************/ 
    FUNCTION DesktopBriefingTopicsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='tc.topic_desc';
         column_names('C004'):='tc.subtopic_desc';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('tc.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'select ''javascript:getObjURL('''''' || tc.sid || '''''');'' url,';
         
         end if;                  
            
         SQLString := SQLString || 
                      'tc.topic_desc as "Topic",' || 
                      'tc.subtopic_desc as "Sub Topic",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from v_osi_topic_content tc';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;

         SQLString := SQLString || 
                      ' and active=''Y''';
                      
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        '  and instr(' || '''' || p_Exclude || '''' || ',tc.sid) = 0';         

         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=location_code' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                '  ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=location_code' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY tc.topic_desc,tc.subtopic_desc';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopBriefingTopicsSQL;
 
    /********************************/ 
    /*  City, State/Country Section */   
    /********************************/ 
    FUNCTION DesktopCityStateCountrySQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='CITY';
         column_names('C004'):='STATE';
         column_names('C005'):='COUNTRY';
         column_names('C006'):='STATE_COUNTRY_CODE';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('l.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || l.sid || '''''');'' url,';
           
         end if;

         SQLString := SQLString || 
                      'CITY as "City",' || 
                      'STATE as "State",' || 
                      'DECODE(COUNTRY,''UNITED STATES OF AMERICA'',''USA'',COUNTRY) as "Country",' || 
                      'STATE_COUNTRY_CODE as "State/Country Code",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from t_sapro_city_state_country l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',l.sid) = 0';         

         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[a|b|c][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[d|e|f][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[g|h|i][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[j|k|l][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[m|n|o][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[t|u|v][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[0-9]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[a-z]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=l.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=l.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by city,state,country,state_country_code,r1.keep_on_top ' ||  
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY CITY,STATE';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopCityStateCountrySQL;

    /*********************/ 
    /*  Offenses Section */   
    /*********************/ 
    FUNCTION DesktopOffensesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='o.code';
         column_names('C004'):='o.description';
         column_names('C005'):='o.crime_against';
         column_names('C006'):='c.category';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('o.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url,';
           
         end if;
   
            
         --- Main Select ---
         SQLString := SQLString || 
                      'o.code as "Offense ID",' || 
                      'o.description as "Offense Description",' || 
                      'o.crime_against as "Crime Against",' || 
                      'c.category as "Category",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from t_dibrs_offense_type o,' || 
                                            't_osi_f_offense_category c';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;
         
         --- Add where Clause ---
         SQLString := SQLString || 
                      ' AND c.offense(+)=o.sid' ||  
                      ' AND o.active = ''Y''';
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then

           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',o.sid) = 0' || 
                        ' AND not exists(select 1 from t_dibrs_offense_type o1 where o1.sid=o.SID and instr(' || ''''  || p_Exclude || ''''  || ',o1.sid) > 0)';
                        
         end if;
                           
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             WHEN FILTER IN ('Person','Property','Society') THEN                            
                 
                 SQLString := SQLString ||  
                              ' AND o.crime_against=' || '''' || FILTER || '''' || 
                              ' ORDER BY O.CODE';
                            
             WHEN FILTER IN ('Base Level Economic Crimes','Central Systems Economic Crimes','Counterintelligence','Drug Crimes','General Crimes','Sex Crimes') THEN 
             
                 SQLString := SQLString ||  
                              ' AND c.category=' || '''' || FILTER || '''' || 
                              ' ORDER BY O.CODE';
                                                    
             WHEN FILTER='RECENT' THEN             

                 SQLString := SQLString ||   
                              ' AND r1.obj=o.sid' || 
                              ' AND r1.personnel=''' || user_sid ||  '''' || 
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='RECENT_UNIT' THEN             

                 SQLString := SQLString ||  
                              ' AND r1.obj=o.sid' || 
                              ' AND r1.unit=''' || UnitSID ||  '''' || 
                              ' group by o.sid,o.code,o.description,o.crime_against,c.category,r1.keep_on_top' ||
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                    
             WHEN FILTER IN ('ALL','All Offenses','OSI') THEN            
             
                 SQLString := SQLString ||  
                              ' ORDER BY O.CODE';
                                                                
             WHEN FILTER='NONE' THEN            

                 SQLString := SQLString ||  
                              ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopOffensesSQL;
    
    /*****************************/ 
    /*  Full Text Search Section */   
    /*****************************/ 
    FUNCTION DesktopFullTextSearchSQL(FILTER IN VARCHAR2, SearchCriteria IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2) RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      objTypeFILE VARCHAR2(20);
      objTypeACT VARCHAR2(20);
      objTypePART VARCHAR2(20);
      whereClause VARCHAR2(5000);
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopFullTextSearchSQL(' || FILTER || ',' || SearchCriteria || ',' || ACTIVE_FILTER || ')');

         objTypeFILE := core_obj.lookup_objtype('FILE'); 
         objTypeACT  := core_obj.lookup_objtype('ACT'); 
         objTypePART := core_obj.lookup_objtype('PARTICIPANT'); 
         
         --- Main Select ---
         SQLString := 'SELECT DISTINCT ''javascript:getObjURL(''''''|| o.SID ||'''''');'' as url,' || 
                      'o.sid,' || 
                      'core_obj.get_tagline(o.sid) as "Title",' || 
                      'ot.description as "Object Type",' || 
                      'o.create_on as "Created On",' || 
                      'o.create_by as "Created By",' || 
                      'score(1) as "Score",' || 
                      'osi_vlt.get_vlt_url(o.sid) as "VLT",' || 
                      'null as "Summary"';

         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_CORE_OBJ o,' || 
                      'T_CORE_OBJ_TYPE ot';

         IF ACTIVE_FILTER IN ('INCLUDE','ONLY') THEN

           SQLString := SQLString || ',' || 
                        'T_OSI_ATTACHMENT a';
                        
         END IF;

         --- Where Clause  ---
         SQLString := SQLString || 
                      ' WHERE o.obj_type=ot.sid';

         IF INSTR(FILTER, 'FILE') > 0 THEN

           whereClause := whereClause || '''' || objTypeFILE || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         IF INSTR(FILTER, 'ACT') > 0 THEN

           whereClause := whereClause || '''' || objTypeACT || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         IF INSTR(FILTER, 'PART') > 0 THEN

           whereClause := whereClause || '''' || objTypePART || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         
         IF whereClause is not null THEN
         
           SQLString := SQLString || 
                        ' AND (' || substr(whereClause, 1, length(whereClause)-4) || ')';
                        
         END IF;
         
         IF ACTIVE_FILTER = 'NONE' THEN

           SQLString := SQLString || 
                        ' and contains(o.doc1, nvl(''' || SearchCriteria || ''',''zzz''),1)>0';
         
         ELSIF ACTIVE_FILTER = 'INCLUDE' THEN

               SQLString := SQLString || 
                            ' and o.sid=a.obj(+)' || 
                            ' and (contains(o.doc1, nvl(''' || SearchCriteria || ''',''zzz''),1)>0' || 
                            ' or contains(a.content, nvl(''' || SearchCriteria || ''',''zzz''),2)>0)';


         ELSIF ACTIVE_FILTER = 'ONLY' THEN

               SQLString := SQLString || 
                            ' and o.sid=a.obj(+)' || 
                            ' and contains(a.content, nvl(''' || SearchCriteria || ''',''zzz''),1)>0';
                            
         END IF;
         SQLString := SQLString ||  ' order by score(1) desc';
         
         log_error('<<<OSI_DESKTOP.DesktopFullTextSearchSQL(' || FILTER || ',' || SearchCriteria || ',' || ACTIVE_FILTER || ')');
         RETURN SQLString;
         
   END DesktopFullTextSearchSQL;

    /*****************/ 
    /*  Unit Section */   
    /*****************/ 
    FUNCTION DesktopUnitSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_UnitType IN VARCHAR2 := 'UNIT', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);

      column_names assoc_arr;
   
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopUnitSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='u.unit_code';
         column_names('C003'):='un1.unit_name';
         column_names('C004'):='un2.unit_name';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('u.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || u.sid || '''''');'' url,';
           
         end if;

         SQLString := SQLString || 
                      'u.unit_code as "Code",' || 
                      'un1.unit_name as "Name",' || 
                      'un2.unit_name as "Parent"';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_osi_unit u,' || 
                      't_osi_unit_name un1,' || 
                      't_osi_unit_name un2';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
         
         --- Add the E-Funds Unit table if needed ---
         IF p_UnitType = 'EFUNDS' THEN
          
           SQLString := SQLString || ',' || 
                        't_cfunds_unit cu';
         END IF;
         
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE (u.sid=un1.unit and un1.end_date is null)' || 
                        ' AND (u.unit_parent=un2.unit and un2.end_date is null)';
                        
         END IF;
                                         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',u.sid) = 0';         

         end if;
         
         --- Add the RPO Unit check if needed ---
         if (p_UnitType = 'RPO') then

           SQLString := SQLString || 
                        ' and u.sid in (select sup_unit from t_osi_unit_sup_units u,t_osi_mission_category c where u.MISSION=c.sid and c.code=''21'')';         

         end if;
         
         --- Add the E-Funds Unit check if needed ---
         IF p_UnitType = 'EFUNDS' THEN
          
           SQLString := SQLString || 
                        ' and cu.sid = u.sid';
                        
         END IF;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID || '''' || 
                                                                ' ORDER BY un1.unit_name';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID || '''' || 
                                                                ' ORDER BY un1.unit_name';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY un1.unit_name';
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY un1.unit_name';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=u.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=u.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by u.sid,u.unit_code,un1.unit_name,un2.unit_name,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                                
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY un1.unit_name';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopUnitSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopUnitSQL;

    /***********************/ 
    /*  Workhours Section  */   
    /***********************/ 
    FUNCTION DesktopWorkHoursSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopWorkHoursSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='osi_personnel.get_name(wh.personnel)';
         column_names('C003'):='to_char(wh.work_date,''dd-Mon-rrrr'')';
         column_names('C004'):='Core_Obj.get_parentinfo(wh.obj)';
         column_names('C005'):='ot.description';
         column_names('C006'):='m.description';
         column_names('C007'):='osi_unit.get_name(osi_personnel.get_current_unit(wh.personnel))';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| wh.obj ||'''''');'' as url,' || 
                      'osi_personnel.get_name(wh.personnel) as "Personnel Name",' || 
                      'wh.work_date as "Date",' || 
                      'Core_Obj.get_parentinfo(wh.obj) as "Context",' || 
                      'wh.hours as "Hours",' || 
                      'ot.description as "Category Description",' || 
                      'm.description as "Mission",' || 
                      'osi_unit.get_name(osi_personnel.get_current_unit(wh.personnel)) as "Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_WORK_HOURS wh,' || 
                      'T_OSI_MISSION_CATEGORY m,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE wh.obj=o.sid' || 
                        ' AND wh.mission=m.sid(+)' || 
                        ' AND ot.sid=o.obj_type';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND wh.personnel=''' || user_sid || '''' || 
                                                                ' ORDER BY PERSONNEL';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(wh.personnel)=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Personnel Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(wh.personnel) in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY "Personnel Name"';
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(wh.personnel) IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY "Personnel Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by wh.obj,wh.personnel,wh.work_date,wh.hours,ot.description,m.description,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY "Personnel Name"';
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
                                                                                                               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopWorkHoursSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopWorkHoursSQL;

   procedure AddFilter(P_ORIGINAL in out nocopy Varchar2, P_APPEND in Varchar2, P_SEPARATOR in Varchar2 := ', ', P_EXCLUDE in Varchar2 := '') is
   begin
        if instr(P_EXCLUDE, P_APPEND) <= 0 or P_EXCLUDE is null or P_EXCLUDE='' then

          if P_APPEND is not null then                                   

            if P_ORIGINAL is not null then

              P_ORIGINAL := P_ORIGINAL || P_SEPARATOR;

            end if;

            P_ORIGINAL := P_ORIGINAL || P_APPEND;
          
          end if;
        
        end if;
        
   exception
        when OTHERS then
            log_error('>>>AddFilter Error: ' || sqlerrm);

   end AddFilter;

   FUNCTION get_filter_lov(p_ObjType IN VARCHAR2, p_Filter_Excludes IN VARCHAR2 := '') RETURN VARCHAR2 IS

           v_lov    VARCHAR2(32000) := NULL;
           v_Filter_Excludes VARCHAR2(32000);

   BEGIN
        v_Filter_Excludes := replace(p_Filter_Excludes,'~',',');
        
        log_error('>>>OSI_DESKTOP.get_filter_lov(' || p_ObjType || ')');
        CASE 
            WHEN p_ObjType IN ('ACT','CFUNDS_ADV','CFUNDS_EXP','EMM','FILE', 'FILE.INV', 'FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO',
                               'FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC',
                               'FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM', 'FILE.GEN.TARGETMGMT',
                               'NOTIFICATIONS','PERSONNEL','PERSONNEL_EMAIL','SOURCES','SOURCE','UNITS','UNITS_EFUNDS','WORKHOURS') THEN

                AddFilter(v_lov, 'Me;ME', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'My Unit;UNIT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Supported Units;SUP_UNIT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Subordinate Units;SUB_UNIT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Recent;RECENT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Recent My Unit;RECENT_UNIT', ',', v_Filter_Excludes);
                --AddFilter(v_lov, 'Nothing;NONE', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'All OSI;OSI', ',', v_Filter_Excludes);

            WHEN p_ObjType IN ('CITY_STATE_COUNTRY','MILITARY_LOCS',
                               'PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN

                AddFilter(v_lov, 'Recent;RECENT', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Recent My Unit;RECENT_UNIT', v_Filter_Excludes);	 	 
                --AddFilter(v_lov, 'Nothing;NONE', ',', v_Filter_Excludes);		 
                AddFilter(v_lov, 'ABC;ABC', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'DEF;DEF', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'GHI;GHI', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'JKL;JKL', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'MNO;MNO', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'PQRS;PQRS', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'TUV;TUV', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'WXYZ;WXYZ', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Numeric;NUMERIC', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Alphabetic;ALPHA', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'All OSI;ALL', ',', v_Filter_Excludes);

            WHEN p_ObjType IN ('OFFENSE','OFFENSES','MATTERS INVESTIGATED','MATTERS') THEN
                
                AddFilter(v_lov, 'Recent;RECENT', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Recent My Unit;RECENT_UNIT', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'All Offenses;All Offenses', ',', v_Filter_Excludes);
                for a in (select distinct(category) as category from t_osi_f_offense_category  union
                          select distinct('Crimes against ' || crime_against) as category from t_dibrs_offense_type where active='Y' and crime_against not in ('Not a Crim','Don''t Use') order by category)
                loop
                    if (a.category='Counterintelligence') then

                      AddFilter(v_lov, 'Crimes against ' || a.category || ';' || replace(a.category, 'Crimes against ',''), ',', v_Filter_Excludes);

                    else

                      AddFilter(v_lov, a.category || ';' || replace(a.category, 'Crimes against ',''), ',', v_Filter_Excludes);

                    end if;
                    
                end loop;
                                
            --WHEN p_ObjType='BRIEFING' THEN

            --WHEN p_ObjType='FULLTEXTSEARCH' THEN
            
            ELSE
                v_lov:='';
                
        END CASE;

       log_error('<<<OSI_DESKTOP.get_filter_lov(' || p_ObjType || ')');
       RETURN v_lov;

   EXCEPTION
       WHEN OTHERS THEN
           log_error('<<<osi_desktop.get_filter_lov: ' || SQLERRM);
           RETURN NULL;
   END get_filter_lov;

   FUNCTION get_active_filter_lov(p_ObjType IN VARCHAR2, p_Active_Filter_Excludes IN VARCHAR2 := '') RETURN VARCHAR2 IS

           v_lov    VARCHAR2(32000) := NULL;
           v_Active_Filter_Excludes VARCHAR2(32000);

   BEGIN
        v_Active_Filter_Excludes := replace(p_Active_Filter_Excludes,'~',',');
        log_error('>>>OSI_DESKTOP.get_active_filter_lov(' || p_ObjType || ')');
        CASE 
            WHEN p_ObjType IN ('ACT','CFUNDS_ADV','CFUNDS_EXP',
                               'FILE', 'FILE.INV', 'FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO',
                               'FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC',
                               'FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM', 'FILE.GEN.TARGETMGMT') THEN

                AddFilter(v_lov, 'Active;ACTIVE', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'All;ALL', ',', v_Active_Filter_Excludes);

            WHEN p_ObjType IN ('PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN
            
                AddFilter(v_lov, 'All Participant Types;ALL', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Companies;PART.NONINDIV.COMP', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Individuals by Name;PART.INDIV', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Organizations;PART.NONINDIV.ORG', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Programs;PART.NONINDIV.PROG', ',', v_Active_Filter_Excludes);

            WHEN p_ObjType IN ('SOURCE','SOURCES') THEN

                AddFilter(v_lov, 'Active;ACTIVE', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'All;ALL', ',', v_Active_Filter_Excludes);
                
                for a in (select * from t_osi_f_source_type order by description)
                loop
                    AddFilter(v_lov, a.description || ';' || a.sid, ',', v_Active_Filter_Excludes);
                
                end loop;

            --WHEN p_ObjType='BRIEFING' THEN

            --WHEN p_ObjType='EMM' THEN

            --WHEN p_ObjType='FULLTEXTSEARCH' THEN

            --WHEN p_ObjType='NOTIFICATIONS' THEN

            --WHEN p_ObjType='PERSONNEL' THEN

            --WHEN p_ObjType='MILITARY_LOCS' THEN

            --WHEN p_ObjType='CITY_STATE_COUNTRY' THEN

            --WHEN p_ObjType='UNITS' THEN

            --WHEN p_ObjType='WORKHOURS' THEN

            ELSE
                v_lov:='';
                
        END CASE;

        log_error('<<<OSI_DESKTOP.get_active_filter_lov(' || p_ObjType || ')');
       RETURN v_lov;

   EXCEPTION
       WHEN OTHERS THEN
           log_error('<<<osi_desktop.get_active_filter_lov: ' || SQLERRM);
           RETURN NULL;
   END get_active_filter_lov;
   
   FUNCTION get_participants_lov(p_Comps_Orgs IN VARCHAR2 := '') RETURN VARCHAR2 IS

           v_lov VARCHAR2(32000) := NULL;

   BEGIN
        log_error('>>>OSI_DESKTOP.get_participants_lov(' || p_Comps_Orgs || ')');

        ----for a in (SELECT this_partic_name d, this_partic r, this_partic, that_partic FROM V_OSI_PARTIC_RELATION_2WAY where instr(p_Comps_Orgs,that_partic)>0 order by d)
        for a in (SELECT distinct this_partic_name d, this_partic r, this_partic, that_partic FROM V_OSI_PARTIC_RELATION_2WAY,T_CORE_OBJ O,T_CORE_OBJ_TYPE OT where O.SID=THIS_PARTIC AND O.OBJ_TYPE=OT.SID AND OT.CODE IN ('PART.INDIV') AND instr(p_Comps_Orgs,that_partic)>0 order by d)
        loop
            v_lov := v_lov || '^^' || a.d || ';' || a.r;
            
        end loop;

       log_error('<<<OSI_DESKTOP.get_participants_lov(' || p_Comps_Orgs || ')');
       RETURN v_lov;

   EXCEPTION
       WHEN OTHERS THEN
           log_error('<<<osi_desktop.get_participants_lov: ' || SQLERRM);
           RETURN NULL;
   END get_participants_lov;
    
   FUNCTION DesktopSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ObjType IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2 := 'ACTIVE', NUM_ROWS IN NUMBER := 15, PAGE_ID IN VARCHAR2 := 'P', p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN VARCHAR2 := '10000', p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      NewFilter VARCHAR2(32000);
      NewActiveFilter VARCHAR2(32000);
      v_temp VARCHAR2(32000);
      v_max_num_rows number;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopSQL(' || FILTER || ',' || user_sid || ',' || p_ObjType || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || NUM_ROWS || ',' || PAGE_ID || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ',' || p_isLocateMany || ')');
         
         v_max_num_rows := to_number(nvl(APXWS_MAX_ROW_CNT,'10000'));

         NewFilter := FILTER;
         NewActiveFilter := ACTIVE_FILTER;
         IF p_ObjType NOT IN ('FULLTEXTSEARCH') THEN

           IF p_ObjType IN ('OFFENSE','OFFENSES','MATTERS INVESTIGATED','MATTERS') THEN

             IF NewFilter NOT IN ('Person','Property','Society','Base Level Economic Crimes','Central Systems Economic Crimes','Counterintelligence','Drug Crimes','General Crimes','Sex Crimes','RECENT','RECENT_UNIT','ALL','All Offenses','OSI') OR NewFilter IS NULL THEN
 
               log_error('Filter not Supported, Changed to: RECENT');
               NewFilter := 'RECENT';
               
             END IF;
                        
           ELSIF p_ObjType NOT IN ('MILITARY_LOCS','CITY_STATE_COUNTRY','PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN
  
                IF NewFilter NOT IN ('ME','UNIT','SUB_UNIT','SUP_UNIT','RECENT','RECENT_UNIT','ALL','OSI','NONE') OR NewFilter IS NULL THEN
           
                  log_error('Filter not Supported, Changed to: RECENT');
                  NewFilter := 'RECENT';
           
                END IF;

           ELSE

             IF NewFilter NOT IN ('ABC','DEF','GHI','JKL','MNO','PQRS','TUV','WXYZ','NUMERIC','ALPHA','ALL','RECENT','RECENT_UNIT','OSI','NONE') OR NewFilter IS NULL THEN
           
               log_error('Filter not Supported, Changed to: RECENT');
               NewFilter := 'RECENT';
           
             END IF;

           END IF;
           
         END IF;
          
         CASE 
             WHEN p_ObjType='ACT' THEN
        
                 SQLString := DesktopActivitiesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='BRIEFING' THEN

                 NewFilter := 'ALL';
                 SQLString := DesktopBriefingTopicsSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType IN ('FILE', 'FILE.INV', 'FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO',
                                'FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC',
                                'FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM', 'FILE.GEN.TARGETMGMT') THEN
        
                 SQLString := DesktopFilesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType IN ('PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN
        
                 SQLString := DesktopParticipantSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);
             
             WHEN p_ObjType='EMM' THEN

                 SQLString := DesktopEvidenceManagementSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType='FULLTEXTSEARCH' THEN

                 SQLString := DesktopFullTextSearchSQL(NewFilter, p_OtherSearchCriteria, NewActiveFilter);
              
             WHEN p_ObjType='CFUNDS_ADV' THEN
        
                 SQLString := DesktopCFundAdvancesSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
                 
             WHEN p_ObjType='CFUNDS_EXP' THEN
        
                 SQLString := DesktopCFundExpensesSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType='NOTIFICATIONS' THEN

                 SQLString := DesktopNotificationsSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
             
             WHEN p_ObjType IN ('OFFENSE','OFFENSES','MATTERS INVESTIGATED','MATTERS') THEN
        
                 SQLString := DesktopOffensesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='PERSONNEL' THEN

                 SQLString := DesktopPersonnelSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'PERSONNEL', p_isLocateMany);

             WHEN p_ObjType='PERSONNEL_EMAIL' THEN

                 SQLString := DesktopPersonnelSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'EMAIL', p_isLocateMany);
             
             WHEN p_ObjType IN ('SOURCE','SOURCES') THEN
        
                 SQLString := DesktopSourcesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='MILITARY_LOCS' THEN
                              
                 SQLString := DesktopMilitaryLocationsSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);
             
             WHEN p_ObjType='CITY_STATE_COUNTRY' THEN

                 SQLString := DesktopCityStateCountrySQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='UNITS' THEN

                 SQLString := DesktopUnitSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'UNITS', p_isLocateMany);

             WHEN p_ObjType='UNITS_RPO' THEN

                 NewFilter := 'ALL';
                 SQLString := DesktopUnitSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'RPO', p_isLocateMany);

             WHEN p_ObjType='UNITS_EFUNDS' THEN

                 SQLString := DesktopUnitSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'EFUNDS', p_isLocateMany);

             WHEN p_ObjType='WORKHOURS' THEN

                 SQLString := DesktopWorkHoursSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
                             
         END CASE;
         
         if PAGE_ID <> 'P' then

           v_temp := osi_personnel.set_user_setting(user_sid,PAGE_ID || '_FILTER.' || p_ObjType, NewFilter);
           v_temp := osi_personnel.set_user_setting(user_sid,PAGE_ID || '_ACTIVE_FILTER.' || p_ObjType, NewActiveFilter);
           v_temp := osi_personnel.set_user_setting(user_sid,PAGE_ID || '_NUM_ROWS.' || p_ObjType, NUM_ROWS);
           
         end if;

         log_error('<<<OSI_DESKTOP.DesktopSQL --Returned--> ' || SQLString);
         RETURN SQLString;
         
    END DesktopSQL;
    
END Osi_Desktop;
/






set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_FILE" as
/******************************************************************************
   Name:     Osi_File
   Purpose:  Provides Functionality For File Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     7-Apr-2009 T.McGuffin      Created Package
    28-Apr-2009 T.McGuffin      Modified Get_Tagline To Only Return Title.
    27-May-2009 T.McGuffin      Added Set_Unit_Owner procedure.
    27-May-2009 T.McGuffin      Added Create_Instance function
    01-Jun-2009 T.McGuffin      Added Get_ID function.
    01-Jun-2009 R.Dibble        Added get_unit_owner
    30-Jun-2009 T.McGuffin      Phased out CORE ACL for simple Restriction.
    26-Aug-2009 M.Batdorf       Added get_assoc_file_sids, get_assoc_act_sids
                                and get_inherited_act_sids.
    15-Oct-2009 J.Faris         Added can_delete
    17-Dec-2009 T.Whitehead     Added get_full_id.
    23-Dec-2009 T.Whitehead     Added get_title.
    26-Feb-2010 T.McGuffin      Modified can_delete to use osi_object.get_lead_agent.
    30-Mar-2010 T.McGuffin      Added get_days_since_opened function.
    04-Apr-2010 R.Dibble        Modified can_delete to use codes instead of
                                 hard coded descriptions
    02-Apr-2010 R.Dibble        Added rpt_generate_form2
    05-Apr-2010 R.Dibble        Added rpt_generate_30252
                                 Added rpt_generate_30256
    18-May-2010 J.Faris         Modified can_delete to handle special processing for
                                 Security Polygraph files.
    25-May-2010 T.Leighty       Added make_doc_misc_file.
    14-Jun-2010 R.Dibble        Modified can_delete() to handle PSO File special processing
    18-Mar-2011 Tim Ward        CR#3731 - Deleting should not stop you if you are not the Lead Agent, if you
                                 have the Delete Privilege.
                                 Also, PSO Files do not have any special processing.
                                 Added FILE.SOURCE special processing.
                                 Changed can_delete().
    20-Oct-2011  Tim Ward       CR#3932 - Classification on Reports is wrong.
                                 Changed in rpt_generate_form2.
    11-Jul-2012  Tim Ward       CR#4028 - Add subject Name and SSN to Agent Applicant 30256.
                                 Changed in rpt_generate_30256.
    12-Jul-2012 Tim Ward        CR#3983 - Make Days Since Opened Work for Sources.
                                 Changed in get_days_since_opened.
                                                                  
******************************************************************************/
    c_pipe        varchar2(100)  := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_FILE';
    v_syn_error   varchar2(4000) := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_full_id(p_obj in varchar2)
        return varchar2 is
        v_full_id   t_osi_file.full_id%type;
    begin
        if p_obj is null then
            log_error('get_full_id: null value passed');
            return null;
        end if;

        for x in (select full_id
                    from t_osi_file
                   where sid = p_obj)
        loop
            return x.full_id;
        end loop;

        return null;
    exception
        when others then
            log_error('get_full_id: ' || sqlerrm);
            return null;
    end get_full_id;

    function get_id(p_obj in varchar2)
        return varchar2 is
        v_id   t_osi_file.id%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select id
          into v_id
          from t_osi_file
         where sid = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_file.title%type;
    begin
        select title
          into v_title
          from t_osi_file
         where sid = p_obj;

        return v_title;
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return 'File Summary';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    function get_title(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select title
                    from t_osi_file
                   where sid = p_obj)
        loop
            return x.title;
        end loop;

        return null;
    exception
        when others then
            log_error('get_title: ' || sqlerrm);
            return 'get_title: Error';
    end get_title;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'File Index1 XML Clob';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return 'File Status';
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    procedure set_unit_owner(
        p_obj      in   varchar2,
        p_unit     in   varchar2 := null,
        p_reason   in   varchar2 := null) is
        v_unit     t_osi_unit.sid%type;
        v_reason   t_osi_f_unit.reason%type   := null;
    begin
        v_unit := nvl(p_unit, osi_personnel.get_current_unit(core_context.personnel_sid));

        if p_obj is not null and v_unit is not null then
            update t_osi_f_unit
               set end_date = sysdate
             where file_sid = p_obj;

            if p_reason is null then
                if sql%rowcount = 0 then
                    v_reason := 'Initial Owner';
                end if;
            else
                v_reason := p_reason;
            end if;

            insert into t_osi_f_unit
                        (file_sid, unit_sid, start_date, reason)
                 values (p_obj, v_unit, sysdate, v_reason);
        end if;
    exception
        when others then
            log_error('set_unit_owner: ' || sqlerrm);
            raise;
    end set_unit_owner;

    /* Given an Object, it return the owning unit */
    function get_unit_owner(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_f_unit.unit_sid%type;
    begin
        select unit_sid
          into v_return
          from t_osi_f_unit
         where file_sid = p_obj and end_date is null;

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_unit_owner: ' || sqlerrm);
            raise;
    end get_unit_owner;

    function create_instance(p_obj_type in varchar2, p_title in varchar2, p_restriction in varchar2)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
    begin
        insert into t_core_obj
                    (obj_type)
             values (p_obj_type)
          returning sid
               into v_sid;

        insert into t_osi_file
                    (sid, title, id, restriction)
             values (v_sid, p_title, osi_object.get_next_id, p_restriction);

        --Set the starting status
        osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type),
                                       'Created');
        --Create the Lead Assignment
        osi_object.create_lead_assignment(v_sid);
        --Set the owning unit
        osi_file.set_unit_owner(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    function get_assoc_file_sids(p_obj in varchar2)
        return varchar2 is
        v_rtn   varchar2(30000) := '';
    begin
        for af in (select that_file
                     from v_osi_assoc_fle_fle_raw
                    where this_file = p_obj)
        loop
            if not core_list.find_item_in_list(af.that_file, v_rtn) then
                if not core_list.add_item_to_list(af.that_file, v_rtn) then
                    -- it's not in the list but adding did not work
                    core_logger.log_it(c_pipe,
                                       'get_assoc_file_sids - Adding ' || af.that_file
                                       || ' to the list for obj ' || p_obj || ' did not work.');
                end if;
            end if;
        end loop;

        return v_rtn;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_assoc_file_sids: ' || sqlerrm);
            return null;
    end get_assoc_file_sids;

    function get_assoc_act_sids(p_obj in varchar2)
        return varchar2 is
        v_rtn   varchar2(30000) := '';
    begin
        for aa in (select activity_sid
                     from t_osi_assoc_fle_act
                    where file_sid = p_obj)
        loop
            if not core_list.find_item_in_list(aa.activity_sid, v_rtn) then
                if not core_list.add_item_to_list(aa.activity_sid, v_rtn) then
                    -- it's not in the list but adding did not work
                    core_logger.log_it(c_pipe,
                                       'get_assoc_act_sids - Adding ' || aa.activity_sid
                                       || ' to the list for obj ' || p_obj || ' did not work.');
                end if;
            end if;
        end loop;

        return v_rtn;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_assoc_act_sids: ' || sqlerrm);
            return null;
    end get_assoc_act_sids;

    function get_inherited_act_sids(p_obj in varchar2)
        return varchar2 is
        v_assoc_file_list    varchar2(4000);
        v_file_act_list      varchar2(4000);
        v_inherit_act_list   varchar2(4000);
        v_temp_act_list      varchar2(4000);
        v_int                number         := 0;
        v_int2               number         := 0;
        v_file_item          varchar2(20);
        v_act_item           varchar2(20);
        v_file_count         number         := 0;
        v_act_count          number         := 0;
    begin
        v_assoc_file_list := get_assoc_file_sids(p_obj);
        v_file_count := core_list.count_list_elements(v_assoc_file_list);

        for v_int in 1 .. v_file_count
        loop
            v_file_item := core_list.pop_list_item(v_assoc_file_list);
            v_temp_act_list := get_assoc_act_sids(v_file_item);
            v_file_act_list := v_temp_act_list;
            v_act_count := core_list.count_list_elements(v_temp_act_list);

            for v_int2 in 1 .. v_act_count
            loop
                v_act_item := core_list.get_list_element(v_temp_act_list, v_int2);

                if core_list.find_item_in_list(v_act_item, v_inherit_act_list) then
                    if not core_list.remove_item_from_list(v_act_item, v_file_act_list) then
                        core_logger.log_it(c_pipe,
                                           'get_inherited_act_sids: could not remove ' || v_act_item
                                           || ' from list ' || v_temp_act_list);
                    end if;
                end if;
            end loop;

            v_inherit_act_list := v_inherit_act_list || v_file_act_list;
            v_inherit_act_list := replace(v_inherit_act_list, '~~', '~');
        end loop;

        return v_inherit_act_list;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_inherited_act_sids: ' || sqlerrm);
            return null;
    end get_inherited_act_sids;

    function can_delete(p_obj in varchar2) return varchar2 is

            v_stat            varchar2(200);
            v_lead            varchar2(20);
            v_obj_type        varchar2(200);
            v_obj_type_code   varchar2(1000);
            v_last_TM_sh_sid  varchar2(1000);
            v_count_check     number;

    begin
         /* Note: This function can be used by *most* files.  If you find you
                  have a file that needs further special processing, we may
                  have to break can_delete() functions out into individual
                  object packages. - Richard Dibble 04/01/2010

         */

         ---Get Status Code and Object Type---
         v_stat := osi_object.get_status_code(p_obj);
         v_obj_type := core_obj.get_objtype(p_obj);
         v_obj_type_code := osi_object.get_objtype_code(v_obj_type);
         
         case v_obj_type_code
             
             ---Special case for Agent Application File (110)---
             when 'FILE.AAPP' then
                 
                 select count(*) into v_count_check from v_osi_f_aapp_file_obj_act where file_sid=p_obj;
                 if v_count_check > 0 then
                   
                   return 'You are not allowed to delete this file when there are ''Associated Activities that Support Objectives'', please remove them from the [Details] tab.';
                   
                 end if;

             ---Special case for Security Polygraph Files---
             when 'FILE.POLY_FILE.SEC' then

                 if v_stat in('CL', 'SV', 'RV', 'AV') then
 
                   return 'You cannot delete this file with status of ' || osi_object.get_status(p_obj) || '.';
 
                 end if;

             ---Special case for Source Files---
             when 'FILE.SOURCE' then

                 if v_stat in('PO', 'AA') then
                   
                   begin
                        select nvl(osi_status.last_sh_sid(p_obj, 'TM'),'~~~never terminated~~~') into v_last_TM_sh_sid FROM DUAL;
                        
                   exception when others then
                   
                            v_last_TM_sh_sid := '~~~never terminated~~~';
                             
                   end;
                   
                   if v_last_TM_sh_sid != '~~~never terminated~~~' then

                     return 'You cannot delete a soruce that has already been an Active source in the past.';

                   end if;
                   
                 else
                 
                   return 'You cannot delete this file with status of ' || osi_object.get_status(p_obj) || '.';
 
                 end if;
                 
                 select count(*) into v_count_check from t_osi_activity where source=p_obj;
                 if v_count_check > 0 then
                   
                   return 'You cannot delete a source used in an activity.';
                   
                 end if;
                 
                 select count(*) into v_count_check from t_osi_assoc_fle_act where activity_sid in(select sid from t_osi_activity where source=p_obj);
                 -------(pending Collection Requirements/Emphasis inclusion in WebI2MS)SID in (select CRCE from T_CR_USAGE where MEET in (select SID from T_ACTIVITY where SOURCE = :BO))
                 -------(pending IR inclusion in WebI2MS)SID in (select IR from T_IR_SOURCE where OSI_SOURCE = :BO)
                 if v_count_check > 0 then
                   
                   return 'You cannot delete a source used in a file.';
                   
                 end if;

             ---All others Files---
             else

               ---Is file in "NW", "AA" status? Otherwise No delete---
               if v_stat not in('NW', 'AA') then

                 return 'You cannot delete a file with status of ' || osi_object.get_status(p_obj) || '.';

               end if;
               
         end case;

         ---Is Current User the lead agent?---
         if (core_context.personnel_sid = osi_object.get_lead_agent(p_obj)) then

           return 'Y';

         else

           ---User is NOT lead agent, so see if they have "Delete" priv.---
           if (osi_auth.check_for_priv('DELETE', v_obj_type) = 'Y') then

             ---User has the priv, so they can delete---
             return 'Y';

           end if;

           return 'You are not authorized to perform the requested action.';

         end if;

    exception
        when others then
            log_error('OSI_FILE.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in OSI_FILE.Can_Delete using Object: ' || nvl(p_obj, 'NULL');

    end can_delete;

    function get_days_since_opened(p_obj in varchar2) return number is

        v_days           number;
        v_last_status    varchar2(100);
        v_open_status    varchar2(2):='OP';
        v_obj_type_code  varchar2(100);
        
    begin
         v_last_status := upper(osi_object.get_status_code(p_obj));
         
         select osi_object.get_objtype_code(core_obj.get_objtype(p_obj)) into v_obj_type_code from dual;
         if v_obj_type_code = 'FILE.SOURCE' then
          
           v_open_status := 'AC';
           
         end if;
         
         if v_last_status != v_open_status then

           v_days := 0;

         else

           v_days := floor(sysdate - osi_status.last_sh_date(p_obj, v_open_status));

         end if;

         return v_days;
    exception
        when others then
            log_error('osi_file.get_days_since_opened: ' || sqlerrm);
            raise;
    end get_days_since_opened;

    /* Used to generate the Form2 report */
    function rpt_generate_form2(p_obj in varchar2)
        return clob is
        v_placeholder      varchar2(200);
        --This is only for holding place of items that are not complete
        v_ok               varchar2(2000);
        v_return_date      date;
        v_return           clob;
        v_mime_type        t_core_template.mime_type%type;
        v_mime_disp        t_core_template.mime_disposition%type;
        v_classification   varchar2(100);
        v_cust_label       varchar2(1000);
        v_date_opened      date;
        v_date_closed      date;
        v_file_count       number;
    begin
        --Get latest template
        v_ok := core_template.get_latest('FORM_2', v_return, v_return_date, v_mime_type, v_mime_disp);

        --- Retrieve Classification Level  (U=Unclassified, C=Confidential, and S=Secret) --- 
        v_classification := core_classification.Class_Level(p_obj,'XML');

        --- If Object is NOT Classified, check for a Default Value --- 
        if (v_classification is null or v_classification = '') then

          v_classification := core_util.get_config('OSI.DEFAULT_CLASS');

        end if;
        
        --- If Object is NOT Classified, and NO Default is found, Default to the HIGHEST ---
        if (v_classification is null or v_classification = '') then

          v_classification := 'S';

        end if;

        --- Get Customer Label ---
        v_cust_label := core_util.get_config('OSI.CUSTLABEL');
        v_ok :=
            core_template.replace_tag(v_return,
                                      'FILETYPE',
                                      v_cust_label || ' '
                                      || osi_object.get_objtype_desc(core_obj.get_objtype(p_obj))
                                      || ' FILE');
        v_ok :=
            core_template.replace_tag(v_return,
                                      'ID',
                                      '*' || osi_object.get_id(p_obj, null) || '*',
                                      p_multiple       => true);

        if (osi_file.get_full_id(p_obj) is null) then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FULL_ID',
                                          osi_object.get_id(p_obj, null),
                                          p_multiple       => true);
        else
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FULL_ID',
                                          osi_file.get_full_id(p_obj),
                                          p_multiple       => true);
        end if;

        --- Get Date Opened ---
        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            v_date_opened := osi_status.first_sh_date(p_obj, 'AC');
        else
            v_date_opened := osi_status.first_sh_date(p_obj, 'OP');
        end if;

        v_ok := core_template.replace_tag(v_return, 'DOPENED', to_char(v_date_opened, 'YYYYMMDD'));

        --- Get Date Closed ---
        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            v_date_closed := osi_status.last_sh_date(p_obj, 'TM');
        else
            v_date_closed := osi_status.last_sh_date(p_obj, 'CL');
        end if;

        v_ok := core_template.replace_tag(v_return, 'DCLOSED', to_char(v_date_closed, 'YYYYMMDD'));
        --- Get Location Information ---
        v_ok :=
            core_template.replace_tag
                (v_return,
                 'LOCATION',
                 osi_unit.get_name(osi_object.get_assigned_unit(p_obj)) || ' '
                 || core_list.get_list_element
                       (osi_address.get_addr_fields
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),
                                                               'UNIT_ADDR')),
                        3)
                 || ','
                 || dibrs_reference.get_state_desc
                       (core_list.get_list_element
                            (osi_address.get_addr_fields
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),
                                                               'UNIT_ADDR')),
                             4))
                 || ','
                 || dibrs_reference.get_country_desc
                       (core_list.get_list_element
                            (osi_address.get_addr_fields
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),
                                                               'UNIT_ADDR')),
                             6)));
        --- Get Related Files ---
        v_file_count := 1;

        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            for x in (select   nvl(file_full_id, file_id) as id
                          from v_osi_file
                         where (sid in(select file_sid
                                         from v_osi_assoc_fle_act
                                        where activity_sid in(select sid
                                                                from t_osi_activity
                                                               where source = p_obj)))
                      order by id)
            loop
                v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, x.id);
                v_file_count := v_file_count + 1;

                if (v_file_count > 5) then
                    exit;
                end if;
            end loop;
        else
            for k in (select   nvl(that_file_full_id, that_file_id) as id
                          from v_osi_assoc_fle_fle
                         where this_file = p_obj
                      order by that_file_id)
            loop
                v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, k.id);
                v_file_count := v_file_count + 1;

                if (v_file_count > 5) then
                    exit;
                end if;
            end loop;
        end if;

        --- If there aren't 5 files, make the WEBTOK@FILE#'s that remain blank ---
        loop
            exit when v_file_count > 5;
            v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, '');
            v_file_count := v_file_count + 1;
        end loop;

        --- Set form Information ---
        if (v_classification = 'U') then
            v_ok :=
                core_template.replace_tag
                                       (v_return,
                                        'CLASS',
                                        '\b\f36\fs48\cf11 ' || chr(13) || chr(10)
                                        || 'UNCLASSIFIED//FOR OFFICIAL USE ONLY \b\f36\fs48\cf11 '
                                        || chr(13) || chr(10) || '\par \b\f1\fs36\cf11 ',
                                        p_multiple       => true);
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2A, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok := core_template.replace_tag(v_return, 'FORM_MESSAGE', '', p_multiple => true);
        elsif v_classification = 'C' then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'CLASS',
                                          '\b\f1\fs12\cf8 ' || chr(13) || chr(10)
                                          || '\par \b\f1\fs72\cf8 C O N F I D E N T I A L',
                                          p_multiple       => true);
            v_return := replace(v_return, '\clcbpat8', '\clcbpat2');
            v_return := replace(v_return, '\clcbpatraw8', '\clcbpatraw2');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2B, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORM_MESSAGE',
                                          '(Form is UNCLASSIFIED when attachments are removed)',
                                          p_multiple       => true);
        elsif v_classification = 'S' then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'CLASS',
                                          '\b\f1\fs12\cf8 ' || chr(13) || chr(10)
                                          || '\par \b\f1\fs72\cf8 S    E    C    R    E    T',
                                          p_multiple       => true);
            v_return := replace(v_return, '\clcbpat8', '\clcbpat6');
            v_return := replace(v_return, '\clcbpatraw8', '\clcbpatraw6');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2C, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORM_MESSAGE',
                                          '(Form is UNCLASSIFIED when attachments are removed)',
                                          p_multiple       => true);
        end if;

        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_form2: ' || sqlerrm);
            raise;
    end rpt_generate_form2;

    /* Used to generate the File Barcode Label (Label # 30252) report */
    function rpt_generate_30252(p_obj in varchar2)
        return clob is
        v_ok            varchar2(2000);
        v_return_date   date;
        v_return        clob;
        v_mime_type     t_core_template.mime_type%type;
        v_mime_disp     t_core_template.mime_disposition%type;
        v_placeholder   varchar2(200);
        v_id            t_osi_file.id%type;
        v_full_id       t_osi_file.full_id%type;
    begin
        --Get latest template
        v_ok :=
            core_template.get_latest('LABEL_FILE_30252',
                                     v_return,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);

        --Get ID and FULL ID
        select id, full_id
          into v_id, v_full_id
          from t_osi_file
         where sid = p_obj;

        --Write FULL_ID
        if (v_full_id is null) then
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_id);
        else
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_full_id);
        end if;

        --Write ID
        v_ok := core_template.replace_tag(v_return, 'ID', '*' || v_id || '*', p_multiple => true);
        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_30252: ' || sqlerrm);
            raise;
    end rpt_generate_30252;

    /* Used to generate the File Barcode Label (Label # 30252) report */
    function rpt_generate_30256(p_obj in varchar2)
        return clob is
        v_ok              varchar2(2000);
        v_return_date     date;
        v_return          clob;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_placeholder     varchar2(200);
        --v_id            t_osi_file.ID%TYPE;
        --v_full_id       t_osi_file.full_id%TYPE;
        v_file_type       varchar2(200);
        v_id              varchar2(200);
        v_full_id         varchar2(200);
        v_tempstring      clob;
        v_offense_count   number;
        v_subject_count   number;
    begin
        --Get latest template
        v_ok :=
            core_template.get_latest('FORM_3986_LABEL',
                                     v_return,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);

        select upper(file_type_desc), file_id, file_full_id
          into v_file_type, v_id, v_full_id
          from v_osi_file
         where sid = p_obj;

        --- Header Information ---
        if substr(v_file_type,length(v_file_type)-4)=' FILE' then

          v_ok := core_template.replace_tag(v_return, 'FILETYPE', 'I2MS ' || v_file_type);

        else

          v_ok := core_template.replace_tag(v_return, 'FILETYPE', 'I2MS ' || v_file_type || ' FILE');

        end if;
        
        --Offenses
        v_offense_count := 0;

        for k in (select offense_desc
                    from v_osi_f_inv_offense
                   where investigation = p_obj and priority_desc = 'Primary')
        loop
            v_ok := core_template.replace_tag(v_return, 'OFFENSE', k.offense_desc);
            v_offense_count := v_offense_count + 1;
        end loop;

        --If no offenses exist, then replace tag with nothing.
        if (v_offense_count = 0) then
            v_ok := core_template.replace_tag(v_return, 'OFFENSE', '');
        end if;

        --- Footer Information ---
        v_ok := core_template.replace_tag(v_return, 'ID', '*' || v_id || '*', p_multiple => true);

        if (v_full_id is null) then
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_id, p_multiple => true);
        else
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_full_id, p_multiple => true);
        end if;

        v_subject_count := 1;

        --- Subjects Header ---
        if (osi_object.get_objtype_code(core_obj.get_objtype(p_obj)) = 'FILE.AAPP') then

          v_tempstring := '\viewkind1\uc1\pard\b\f1\fs20 Subject:\par';
          
       elsif (osi_object.get_objtype_code(core_obj.get_objtype(p_obj)) != 'FILE.SOURCE') then

             v_tempstring := '\viewkind1\uc1\pard\b\f1\fs20 Subjects:\par';

        end if;

        for k in
            (select osi_participant.get_name(participant_version) as the_name,
                    osi_participant.get_number(participant_version,
                                               'SSN') as social_security_number,
                    osi_object.get_objtype_code
                             (osi_participant.get_type_sid(participant_version))
                                                                                as person_type_code
               from v_osi_partic_file_involvement
              where file_sid = p_obj and role in('Subject', 'Examinee','Applicant'))
        loop
            --- Black Line ---
            v_tempstring :=
                v_tempstring
                || '\viewkind1\uc1\trowd\trgaph108\trleft-108\trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';
            v_tempstring :=
                v_tempstring
                || '\clbrdrb\brdrw30\brdrs \cellx3290\pard\intbl\nowidctlpar\b\f1\fs4\cell\row\pard\nowidctlpar\b0\f0\fs24';
            --- Name and Social Security Number ---
            v_tempstring :=
                v_tempstring
                || '\viewkind1\uc1\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';
            v_tempstring :=
                v_tempstring || '\cellx3290\pard\intbl\b\f1\fs20 '
                || ltrim(rtrim(upper(k.the_name)))
                || '\cell\row\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';

            if (k.person_type_code = 'PART.INDIV') then
                v_tempstring :=
                    v_tempstring || '\cellx3290\pard\intbl ' || 'SSN: ' || k.social_security_number
                    || '\cell\row\pard';
            else
                v_tempstring := v_tempstring || '\cellx3290\pard\intbl \cell\row\pard';
            end if;

            v_subject_count := v_subject_count + 1;

            if v_subject_count > 3 then
                exit;
            end if;
        end loop;

        v_ok := core_template.replace_tag(v_return, 'SUBJECTS', v_tempstring);
        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_30256: ' || sqlerrm);
            raise;
    end rpt_generate_30256;

    /* Given an Object SID, will return the proper FULL_ID */
    function generate_full_id(p_obj in varchar2)
        return varchar2 is
        v_ot_code   t_core_obj_type.code%type;
        v_return    t_osi_file.full_id%type;
    begin
        select ot.code
          into v_ot_code
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_obj and ot.sid = o.obj_type;

        /* Developers Note: (By Richard Dibble)
        The arcitecture for handling Full ID's was discussed on 04/02/2010 by Richard Dibble and Tim McGuffin.
        Ultimately we would like to centralize the creation of full ID's.
         To do this we need the equivalent to the I2MS.T_FILE_TYPE.FULL_ID_TAG column (probably in the T_OSI_OBJECT_TYPE table)
        Also, since most file Full ID's are similiar, we discussed using the CASE statement below just for special cases, and the ELSE would handle non-special cases.
         But, since we need the FULL_ID_TAG field, which we do not have, we are leaving this function
         as it is now, and will modify it later to properly handle Full ID integration across all objects.
         This was the Recommendation of Tim McGuffin - 04/02/2010

        */
        case
            when v_ot_code like 'FILE.INV%' then
                v_return := osi_investigation.generate_full_id(p_obj);
            when v_ot_code like 'FILE.PSO%' then
                v_return := osi_pso.generate_full_id(p_obj);
            else
                v_return := null;
        end case;

        return v_return;
    exception
        when others then
            log_error('osi_file.generate_full_id: ' || sqlerrm);
            raise;
    end generate_full_id;

--======================================================================================================================
-- This is a catch all to make a html page based on those type of files that are not
-- Participants, Case files, or Activities.  If the are found then put a page out with
-- minimum information.
--======================================================================================================================
    procedure make_doc_misc_file(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp_clob          clob;
        v_template           clob;
        v_file_id            v_osi_file.file_id%type;
        v_title              t_core_obj_type.description%type;
        v_sid                t_core_obj.sid%type;
        v_type_description   t_core_obj_type.description%type;
        v_ok                 varchar2(1000);                 -- flag indicating success or failure.
        v_template_date      date;               -- date of the most recent version of the template
    begin
        core_logger.log_it(c_pipe, '--> make_doc_misc_file');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                         (c_pipe,
                          'ODW.Make_Doc_Misc_File: File is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                        (c_pipe,
                         'ODW.Make_Doc_Misc_File: File is LIMDIS - no document will be synthesized');
            return;
        end if;

        select osf.file_id, obt.description as title, osf.sid, obt.description as type_description
          into v_file_id, v_title, v_sid, v_type_description
          from v_osi_file osf, t_core_obj ob, t_core_obj_type obt
         where osf.sid = p_sid and osf.sid = ob.sid and ob.obj_type = obt.sid;

        osi_object.get_template('OSI_ODW_DETAIL_MISC_FILE', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Fill in data
        v_ok := core_template.replace_tag(v_template, 'ID', v_file_id);

        if v_title is not null then
            v_ok := core_template.replace_tag(v_template, 'TITLE', v_title);
        else
            v_ok := core_template.replace_tag(v_template, 'TITLE', v_sid);
        end if;

        v_ok := core_template.replace_tag(v_template, 'TYPE', v_type_description);
        -- get Attachment Descriptions
        osi_object.append_attachments(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENT_DESC', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- return the completed template
        dbms_lob.append(p_doc, v_template);
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_misc_file');
    exception
        when no_data_found then
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_Misc_File Error: Non File SID Encountered.');
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_Misc_File Error: ' || v_syn_error);
    end make_doc_misc_file;
end osi_file;
/

