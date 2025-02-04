--application/pages/page_01610
prompt  ...PAGE 1610: Desktop Individuals
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1610,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Individuals',
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
  p_last_updated_by => 'JASON',
  p_last_upd_yyyymmddhh24miss => '20101213160933',
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
  p_id=> 6190310429304914 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.INDIV''))=''N''',
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
s:=s||'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url,'||chr(10)||
'       osi_participant.get_name(o.sid) as "Name",'||chr(10)||
'       osi_participant.get_name_type(o.sid) as "Type of Name",'||chr(10)||
'       osi_participant.get_birth_country(o.sid) as "Birth Country",'||chr(10)||
'       osi_participant.get_birth_state(o.sid) as "Birth State",'||chr(10)||
'       osi_participant.get_birth_city(o.sid) as "Birth City",'||chr(10)||
'       p.dob as "Birth Date",'||chr(10)||
'      ';

s:=s||' dibrs_reference.lookup_ref_desc(ph.sa_service) as "Service",'||chr(10)||
'       osi_reference.lookup_ref_desc(ph.sa_affiliation) as '||chr(10)||
'                                                         "Service Affiliation",'||chr(10)||
'       dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",'||chr(10)||
'       dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",'||chr(10)||
'       pg.description as "Service Pay Gr';

s:=s||'ade",'||chr(10)||
'       ph.sa_rank as "Service Rank",'||chr(10)||
'       ph.sa_rank_date as "Service Date of Rank",'||chr(10)||
'       ph.sa_specialty_code as "Service Specialty Code",'||chr(10)||
'       dibrs_reference.lookup_ref_desc(pc.sex) as "Sex",'||chr(10)||
'       pc.height as "Height",'||chr(10)||
'       pc.weight as "Weight",'||chr(10)||
'       decode(ph.age_low,'||chr(10)||
'              null, null,'||chr(10)||
'              ''NB'', ''0.008'','||chr(10)||
'              ''NN'', ''0.0014'','||chr(10)||
'              ''BB'', ''0';

s:=s||'.5'','||chr(10)||
'              ph.age_low) as "Minimum Age",'||chr(10)||
'       ph.age_high as "Maximum Age",'||chr(10)||
'       osi_participant.get_number(o.sid, ''SSN'') as "SSN",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       o.times_accessed as "Times Accessed",'||chr(10)||
'       o.last_accessed as "Last Accessed"'||chr(10)||
'  from '||chr(10)||
'        (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'';

s:=s||'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_participant_version pv2, t_osi_participant_human ph2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = pv2.participant'||chr(10)||
'             and pv2.sid = ph2.sid'||chr(10)||
'             and (  ';

s:=s||' (    :p1610_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1610_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1610_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1610_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (:p1610_filter = ''A';

s:=s||'BC'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''A'',''B'',''C''))'||chr(10)||
'                  or (:p1610_filter = ''DEF'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''D'',''E'',''F''))'||chr(10)||
'                  or (:p1610_filter = ''GHI'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.';

s:=s||'get_tagline(o1.sid)),1,1)in (''G'',''H'',''I''))'||chr(10)||
'                  or (:p1610_filter = ''JKL'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''J'',''K'',''L''))'||chr(10)||
'                  or (:p1610_filter = ''MNO'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''M'',''N'',''O''))'||chr(10)||
'                  or (:p1610_filter';

s:=s||' = ''PQRS'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''P'',''Q'',''R'',''S''))'||chr(10)||
'                  or (:p1610_filter = ''TUV'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''T'',''U'',''V''))'||chr(10)||
'                  or (:p1610_filter = ''WXYZ'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                       ';

s:=s||'  core_obj.get_tagline(o1.sid)),1,1)in (''W'',''X'',''Y'',''Z''))'||chr(10)||
'                  or (:p1610_filter = ''NUMERIC'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1) between ''0'' and ''9'')'||chr(10)||
'                  or (:p1610_filter = ''ALPHA'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1) between ''A'' and ''Z''))'||chr(10)||
'     ';

s:=s||'  group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_osi_participant p,'||chr(10)||
'       t_osi_participant_version pv,'||chr(10)||
'       t_osi_participant_human ph,'||chr(10)||
'       t_dibrs_pay_grade_type pg,'||chr(10)||
'       t_osi_person_chars pc'||chr(10)||
' where o.sid = p.sid'||chr(10)||
'   and p.current_version= pv.sid'||chr(10)||
'   and pv.sid = ph.sid'||chr(10)||
'   and pc.sid(+) = pv.sid'||chr(10)||
'   and pg.sid(+) = pc.sa_pay_grade'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 92985030428103701 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_plug_name=> 'Participants > Individuals',
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.INDIV''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url,'||chr(10)||
'       osi_participant.get_name(o.sid) as "Name",'||chr(10)||
'       osi_participant.get_name_type(o.sid) as "Type of Name",'||chr(10)||
'       osi_participant.get_birth_country(o.sid) as "Birth Country",'||chr(10)||
'       osi_participant.get_birth_state(o.sid) as "Birth State",'||chr(10)||
'       osi_participant.get_birth_city(o.sid) as "Birth City",'||chr(10)||
'       p.dob as "Birth Date",'||chr(10)||
'      ';

a1:=a1||' dibrs_reference.lookup_ref_desc(ph.sa_service) as "Service",'||chr(10)||
'       osi_reference.lookup_ref_desc(ph.sa_affiliation) as '||chr(10)||
'                                                         "Service Affiliation",'||chr(10)||
'       dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",'||chr(10)||
'       dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",'||chr(10)||
'       pg.description as "Service Pay Gr';

a1:=a1||'ade",'||chr(10)||
'       ph.sa_rank as "Service Rank",'||chr(10)||
'       ph.sa_rank_date as "Service Date of Rank",'||chr(10)||
'       ph.sa_specialty_code as "Service Specialty Code",'||chr(10)||
'       dibrs_reference.lookup_ref_desc(pc.sex) as "Sex",'||chr(10)||
'       pc.height as "Height",'||chr(10)||
'       pc.weight as "Weight",'||chr(10)||
'       decode(ph.age_low,'||chr(10)||
'              null, null,'||chr(10)||
'              ''NB'', ''0.008'','||chr(10)||
'              ''NN'', ''0.0014'','||chr(10)||
'              ''BB'', ''0';

a1:=a1||'.5'','||chr(10)||
'              ph.age_low) as "Minimum Age",'||chr(10)||
'       ph.age_high as "Maximum Age",'||chr(10)||
'       osi_participant.get_number(o.sid, ''SSN'') as "SSN",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       o.times_accessed as "Times Accessed",'||chr(10)||
'       o.last_accessed as "Last Accessed"'||chr(10)||
'  from '||chr(10)||
'        (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'';

a1:=a1||'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_participant_version pv2, t_osi_participant_human ph2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = pv2.participant'||chr(10)||
'             and pv2.sid = ph2.sid'||chr(10)||
'             and (  ';

a1:=a1||' (    :p1610_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1610_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1610_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1610_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (:p1610_filter = ''A';

a1:=a1||'BC'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''A'',''B'',''C''))'||chr(10)||
'                  or (:p1610_filter = ''DEF'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''D'',''E'',''F''))'||chr(10)||
'                  or (:p1610_filter = ''GHI'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.';

a1:=a1||'get_tagline(o1.sid)),1,1)in (''G'',''H'',''I''))'||chr(10)||
'                  or (:p1610_filter = ''JKL'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''J'',''K'',''L''))'||chr(10)||
'                  or (:p1610_filter = ''MNO'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''M'',''N'',''O''))'||chr(10)||
'                  or (:p1610_filter';

a1:=a1||' = ''PQRS'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''P'',''Q'',''R'',''S''))'||chr(10)||
'                  or (:p1610_filter = ''TUV'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1)in (''T'',''U'',''V''))'||chr(10)||
'                  or (:p1610_filter = ''WXYZ'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                       ';

a1:=a1||'  core_obj.get_tagline(o1.sid)),1,1)in (''W'',''X'',''Y'',''Z''))'||chr(10)||
'                  or (:p1610_filter = ''NUMERIC'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1) between ''0'' and ''9'')'||chr(10)||
'                  or (:p1610_filter = ''ALPHA'''||chr(10)||
'                      and substr(upper('||chr(10)||
'                         core_obj.get_tagline(o1.sid)),1,1) between ''A'' and ''Z''))'||chr(10)||
'     ';

a1:=a1||'  group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_osi_participant p,'||chr(10)||
'       t_osi_participant_version pv,'||chr(10)||
'       t_osi_participant_human ph,'||chr(10)||
'       t_dibrs_pay_grade_type pg,'||chr(10)||
'       t_osi_person_chars pc'||chr(10)||
' where o.sid = p.sid'||chr(10)||
'   and p.current_version= pv.sid'||chr(10)||
'   and pv.sid = ph.sid'||chr(10)||
'   and pc.sid(+) = pv.sid'||chr(10)||
'   and pg.sid(+) = pc.sa_pay_grade'||chr(10)||
'';

wwv_flow_api.create_worksheet(
  p_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1610,
  p_region_id => 92985030428103701+wwv_flow_api.g_id_offset,
  p_name => 'Desktop > Individuals',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Participants found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1610_FILTER',
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
  p_download_filename         =>'&P1610_EXPORT_NAME.',
  p_detail_link              =>'#URL#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="" />',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 92985308238103704+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'URL',
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
  p_id => 92985414277103706+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Name',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Name',
  p_report_label           =>'Name',
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
  p_id => 92985522709103707+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Type of Name',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Type Of Name',
  p_report_label           =>'Type Of Name',
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
  p_id => 92985634350103707+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth Country',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Birth Country',
  p_report_label           =>'Birth Country',
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
  p_id => 92985714972103707+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth State',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Birth State',
  p_report_label           =>'Birth State',
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
  p_id => 92985823058103707+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth City',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Birth City',
  p_report_label           =>'Birth City',
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
  p_id => 93810029435279279+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth Date',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Birth Date',
  p_report_label           =>'Birth Date',
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
  p_id => 92986037377103709+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'SSN',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'SSN',
  p_report_label           =>'SSN',
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
  p_id => 92986129625103709+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created On',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
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
  p_id => 92986223307103709+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created By',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
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
  p_id => 1632103899810187+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Times Accessed',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
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
  p_id => 1632225948810187+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Last Accessed',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
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
  p_id => 1982115491739073+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
  p_column_label           =>'Service',
  p_report_label           =>'Service',
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
  p_id => 1982204466739076+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Affiliation',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Service Affiliation',
  p_report_label           =>'Service Affiliation',
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
  p_id => 1982325571739076+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Component',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
  p_column_label           =>'Service Component',
  p_report_label           =>'Service Component',
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
  p_id => 1982419518739078+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Pay Plan',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'Service Pay Plan',
  p_report_label           =>'Service Pay Plan',
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
  p_id => 1982528216739078+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Pay Grade',
  p_display_order          =>17,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Q',
  p_column_label           =>'Service Pay Grade',
  p_report_label           =>'Service Pay Grade',
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
  p_id => 1982617160739078+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Rank',
  p_display_order          =>18,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'R',
  p_column_label           =>'Service Rank',
  p_report_label           =>'Service Rank',
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
  p_id => 1982729505739079+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Date of Rank',
  p_display_order          =>19,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'S',
  p_column_label           =>'Service Date Of Rank',
  p_report_label           =>'Service Date Of Rank',
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
  p_id => 1982820853739079+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Specialty Code',
  p_display_order          =>20,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'T',
  p_column_label           =>'Service Specialty Code',
  p_report_label           =>'Service Specialty Code',
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
  p_id => 1982911134739079+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Sex',
  p_display_order          =>21,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'U',
  p_column_label           =>'Sex',
  p_report_label           =>'Sex',
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
  p_id => 1983007865739079+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Height',
  p_display_order          =>22,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'V',
  p_column_label           =>'Height',
  p_report_label           =>'Height',
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
  p_id => 1983105162739081+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Weight',
  p_display_order          =>23,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'W',
  p_column_label           =>'Weight',
  p_report_label           =>'Weight',
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
  p_id => 1983200233739081+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Minimum Age',
  p_display_order          =>24,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'X',
  p_column_label           =>'Minimum Age',
  p_report_label           =>'Minimum Age',
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
  p_id => 1983309911739081+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Maximum Age',
  p_display_order          =>25,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Y',
  p_column_label           =>'Maximum Age',
  p_report_label           =>'Maximum Age',
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
wwv_flow_api.create_worksheet_rpt(
  p_id => 92986337468104007+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1610,
  p_worksheet_id => 92985119762103701+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'Name:Type of Name:Birth Country:Birth State:Birth City:Birth Date:SSN:Created On:Created By:Times Accessed:Last Accessed',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15524909136145189 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1610,
  p_button_sequence=> 10,
  p_button_plug_id => 92985030428103701+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1610);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>1630808616802150 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1610,
  p_branch_action=> 'f?p=&APP_ID.:1610:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 25-MAR-2010 16:12 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1629027747788701 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1610,
  p_name=>'P1610_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 92985030428103701+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER_PARTIC',
  p_lov => '.'||to_char(6131017354251614 + wwv_flow_api.g_id_offset)||'.',
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
  p_id=>15525115023146962 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1610,
  p_name=>'P1610_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 92985030428103701+wwv_flow_api.g_id_offset,
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
  p_id=> 1629103637791250 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1610,
  p_computation_sequence => 10,
  p_computation_item=> 'P1610_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1610_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1610
--
 
begin
 
null;
end;
null;
 
end;
/

 
