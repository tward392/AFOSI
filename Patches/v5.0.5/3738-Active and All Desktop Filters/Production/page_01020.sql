--application/pages/page_01020
prompt  ...PAGE 1020: Desktop Files
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1020,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Files',
  p_step_title=> '&DESKTOP_TITLE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 92011431286949262+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111118130659',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '13-DEC-2010 J.Faris WCHG0000264 - DT view query updates for performance.');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'You do not have access privileges for this folder.';

wwv_flow_api.create_page_plug (
  p_id=> 6183608174266359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.CASE''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.DEV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.INFO''))=''N''or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.AAPP''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.ANP''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.PSO''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.POLY_FILE.SEC'')) = ''N''or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.SRCDEV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.UNDRCVROPSUPP''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.TECHSURV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.POLY_FILE.CRIM''))=''N''',
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
s:=s||'select ''javascript:getObjURL('''''' || f.sid || '''''');'' url,'||chr(10)||
'       f.id as "ID",'||chr(10)||
'       ot.description as "File Type",'||chr(10)||
'       f.title as "Title",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       osi_object.get_status(f.sid) as "Status",'||chr(10)||
'       osi_unit.get_name('||chr(10)||
'           osi_file.get_unit_owner(f.sid)) as "Controlling Unit",'||chr(10)||
'       osi_status.last_sh_date(f.sid, ''OP'') ';

s:=s||'"Date Opened",'||chr(10)||
'       osi_status.last_sh_date(f.sid, ''CL'') "Date Closed",'||chr(10)||
'       osi_file.get_days_since_opened(f.sid) "Days Since Opened",'||chr(10)||
'       o.times_accessed as "Times Accessed",'||chr(10)||
'       o.last_accessed as "Last Accessed",'||chr(10)||
'       osi_vlt.get_vlt_url(o.sid) as "VLT"'||chr(10)||
'  from t_osi_file f,'||chr(10)||
'       (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.';

s:=s||'create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_file f2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = f2.sid'||chr(10)||
'             and (   (    :p1020_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    ';

s:=s||':p1020_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1020_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1020_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (    :p1020_filter = ''ME'' '||chr(10)||
'                      and osi_object.is_assigned(o1.sid)=''Y'')'||chr(10)||
'                  or (    :p1020_filter';

s:=s||' = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1020_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'              ';

s:=s||'    or (    :p1020_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'                                 osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o';

s:=s||'1.create_on) o,'||chr(10)||
'       t_core_obj_type ot'||chr(10)||
' where f.sid = o.sid'||chr(10)||
'   and o.obj_type = ot.sid';

wwv_flow_api.create_page_plug (
  p_id=> 92401423302081999 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_plug_name=> 'Desktop > Files',
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
  p_plug_display_when_condition => 'not ('||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.CASE''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.DEV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.INFO''))=''N''or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.AAPP''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.ANP''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.PSO''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'', '||chr(10)||
'    core_obj.lookup_objtype(''FILE.POLY_FILE.SEC'')) = ''N''or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.SRCDEV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.UNDRCVROPSUPP''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.GEN.TECHSURV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'','||chr(10)||
'    core_obj.lookup_objtype(''FILE.POLY_FILE.CRIM''))=''N'''||chr(10)||
')',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_prn_output_show_link=> 'Y',
  p_prn_content_disposition=> 'ATTACHMENT',
  p_prn_document_header=> 'APEX',
  p_prn_units=> 'INCHES',
  p_prn_paper_size=> 'LETTER',
  p_prn_width=> 11,
  p_prn_height=> 8.5,
  p_prn_orientation=> 'HORIZONTAL',
  p_prn_page_header_font_color=> '#000000',
  p_prn_page_header_font_family=> 'Helvetica',
  p_prn_page_header_font_weight=> 'normal',
  p_prn_page_header_font_size=> '12',
  p_prn_page_footer_font_color=> '#000000',
  p_prn_page_footer_font_family=> 'Helvetica',
  p_prn_page_footer_font_weight=> 'normal',
  p_prn_page_footer_font_size=> '12',
  p_prn_header_bg_color=> '#9bafde',
  p_prn_header_font_color=> '#ffffff',
  p_prn_header_font_family=> 'Helvetica',
  p_prn_header_font_weight=> 'normal',
  p_prn_header_font_size=> '10',
  p_prn_body_bg_color=> '#efefef',
  p_prn_body_font_color=> '#000000',
  p_prn_body_font_family=> 'Helvetica',
  p_prn_body_font_weight=> 'normal',
  p_prn_body_font_size=> '10',
  p_prn_border_width=> .5,
  p_prn_page_header_alignment=> 'LEFT',
  p_prn_page_footer_alignment=> 'LEFT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''javascript:getObjURL('''''' || f.sid || '''''');'' url,'||chr(10)||
'       f.id as "ID",'||chr(10)||
'       ot.description as "File Type",'||chr(10)||
'       f.title as "Title",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       osi_object.get_status(f.sid) as "Status",'||chr(10)||
'       osi_unit.get_name('||chr(10)||
'           osi_file.get_unit_owner(f.sid)) as "Controlling Unit",'||chr(10)||
'       osi_status.last_sh_date(f.sid, ''OP'') ';

a1:=a1||'"Date Opened",'||chr(10)||
'       osi_status.last_sh_date(f.sid, ''CL'') "Date Closed",'||chr(10)||
'       osi_file.get_days_since_opened(f.sid) "Days Since Opened",'||chr(10)||
'       o.times_accessed as "Times Accessed",'||chr(10)||
'       o.last_accessed as "Last Accessed",'||chr(10)||
'       osi_vlt.get_vlt_url(o.sid) as "VLT"'||chr(10)||
'  from t_osi_file f,'||chr(10)||
'       (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.';

a1:=a1||'create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_file f2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = f2.sid'||chr(10)||
'             and (   (    :p1020_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    ';

a1:=a1||':p1020_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1020_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1020_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (    :p1020_filter = ''ME'' '||chr(10)||
'                      and osi_object.is_assigned(o1.sid)=''Y'')'||chr(10)||
'                  or (    :p1020_filter';

a1:=a1||' = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1020_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'              ';

a1:=a1||'    or (    :p1020_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'                                 osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o';

a1:=a1||'1.create_on) o,'||chr(10)||
'       t_core_obj_type ot'||chr(10)||
' where f.sid = o.sid'||chr(10)||
'   and o.obj_type = ot.sid';

wwv_flow_api.create_worksheet(
  p_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1020,
  p_region_id => 92401423302081999+wwv_flow_api.g_id_offset,
  p_name => 'Desktop > Files',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Files found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1020_FILTER',
  p_sort_asc_image       => '',
  p_sort_asc_image_attr  => '',
  p_sort_desc_image      => '',
  p_sort_desc_image_attr => '',
  p_sql_query => a1,
  p_status                    =>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving       =>'Y',
  p_allow_report_categories   =>'N',
  p_show_nulls_as             =>'-',
  p_pagination_type           =>'ROWS_X_TO_Y_OF_Z',
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
  p_download_filename         =>'&P1020_EXPORT_NAME.',
  p_detail_link              =>'#URL#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 92401727562081999+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'URL',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'&nbsp;',
  p_report_label           =>'&nbsp;',
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
  p_id => 92401816657082001+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'ID',
  p_display_order          =>3,
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
  p_id => 92401935794082001+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'File Type',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'File Type',
  p_report_label           =>'File Type',
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
  p_id => 92402015717082001+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Title',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
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
  p_id => 92402130970082001+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created On',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Created On',
  p_report_label           =>'Created On',
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
  p_id => 92402206674082003+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created By',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Created By',
  p_report_label           =>'Created By',
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
  p_id => 6866619193731004+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Status',
  p_display_order          =>8,
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
  p_id => 6866716868731014+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Controlling Unit',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
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
  p_id => 6866831100731014+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Times Accessed',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
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
  p_id => 6866913269731014+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Last Accessed',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
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
  p_format_mask            =>'&FMT_DATE. &FMT_TIME.',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1646407118943615+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'VLT',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
  p_column_label           =>'       ',
  p_report_label           =>'       ',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'#VLT#',
  p_column_linktext        =>'&ICON_VLT.',
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
  p_id => 1903520868909698+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Date Opened',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
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
  p_format_mask            =>'&FMT_DATE.',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1903623961909700+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Date Closed',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
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
  p_format_mask            =>'&FMT_DATE.',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1903729894909700+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Days Since Opened',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Days Since Opened',
  p_report_label           =>'Days Since Opened',
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
wwv_flow_api.create_worksheet_rpt(
  p_id => 92402321710083373+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1020,
  p_worksheet_id => 92401536778081999+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'IMAGETOUSE:ID:File Type:Title:Status:Controlling Unit:Created On:Times Accessed:Last Accessed:VLT',
  p_sort_column_1           =>'Last Accessed',
  p_sort_direction_1        =>'DESC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15345911774323343 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1020,
  p_button_sequence=> 10,
  p_button_plug_id => 92401423302081999+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1020);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>6868905519764976 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1020,
  p_branch_action=> 'f?p=&APP_ID.:1020:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAR-2010 09:13 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6868514045757920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1020,
  p_name=>'P1020_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 92401423302081999+wwv_flow_api.g_id_offset,
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
  p_id=>15400630669268615 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1020,
  p_name=>'P1020_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 92401423302081999+wwv_flow_api.g_id_offset,
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
  p_id=> 6960931251599803 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1020,
  p_computation_sequence => 10,
  p_computation_item=> 'P1020_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1020_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1020
--
 
begin
 
null;
end;
null;
 
end;
/

 
