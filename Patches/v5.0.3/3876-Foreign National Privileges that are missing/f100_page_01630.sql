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
--   Date and Time:   10:20 Wednesday June 8, 2011
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

PROMPT ...Remove page 1630
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1630);
 
end;
/

 
--application/pages/page_01630
prompt  ...PAGE 1630: Desktop Organizations
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1630,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Organizations',
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
  p_last_upd_yyyymmddhh24miss => '20110601085737',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '18-JAN-2011 J.Faris - Query optimization updates, added CASE statements and regular expression alpha comparisons.'||chr(10)||
'21-JAN-2011 J.Faris - More optimization updates, added no_hash_join function to minimize full table scans.'||chr(10)||
''||chr(10)||
'01-Jun-2011 Tim Ward - Filter showing even if access denied.');
 
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
  p_id=> 6190715624306440 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1630,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.ORG''))=''N''',
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
s:=s||'select ''javascript:getObjURL('''''' || o.SID || '''''');'' url, osi_participant.get_name(o.SID) as "Name",'||chr(10)||
'       osi_participant.get_subtype(o.SID) as "Type",'||chr(10)||
'       osi_participant.get_confirmation(o.SID) as "Confirmed", o.create_by as "Created By",'||chr(10)||
'       o.create_on as "Created On", o.times_accessed "Times Accessed",'||chr(10)||
'       o.last_accessed "Last Accessed"'||chr(10)||
'  from (select   o1.SID, o1.obj_type, o1.crea';

s:=s||'te_by, o1.create_on,'||chr(10)||
'                 sum(r1.times_accessed) times_accessed, max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, v_osi_participant_version pv1, t_osi_partic_name pn1'||chr(10)||
'           where r1.obj(+) = o1.SID'||chr(10)||
'             and pv1.participant = o1.SID'||chr(10)||
'             and pv1.SID = pv1.current_version'||chr(10)||
'             and (pn1.SID = pv1.current_na';

s:=s||'me)'||chr(10)||
'             and (CASE'||chr(10)||
'                      WHEN(:p1630_filter = ''RECENT'' and r1.personnel = :user_sid) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''RECENT_UNIT'''||chr(10)||
'                           and r1.unit = osi_personnel.get_current_unit(:user_sid)) then ''true'''||chr(10)||
'                      WHEN(:p1630_filter = ''NONE'' and 1 = 2) then ''true'''||chr(10)||
'                      WHEN(:p1630_filter in(''ALL''';

s:=s||', ''OSI'')) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''ABC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a|b|c][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ';

s:=s||'''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''DEF'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[d|e|f][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'        ';

s:=s||'              WHEN(    :p1630_filter = ''GHI'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[g|h|i][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      W';

s:=s||'HEN(    :p1630_filter = ''JKL'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[j|k|l][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_';

s:=s||'filter = ''MNO'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[m|n|o][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''PQRS''';

s:=s||''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[p|q|r|s][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''TUV'''||chr(10)||
'            ';

s:=s||'               and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[t|u|v][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''WXYZ'''||chr(10)||
'                          ';

s:=s||' and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[w|x|y|z][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''NUMERIC'''||chr(10)||
'                           and REGE';

s:=s||'XP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[0-9]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''ALPHA'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'  ';

s:=s||'                                          ''[a-z]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      ELSE ''false'''||chr(10)||
'                  END = ''true'')'||chr(10)||
'        group by o1.SID, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'      ';

s:=s||' t_core_obj_type ot,'||chr(10)||
'       t_osi_participant p,'||chr(10)||
'       t_osi_participant_version pv,'||chr(10)||
'       t_osi_participant_human ph,'||chr(10)||
'       t_osi_person_chars pc,'||chr(10)||
'       t_dibrs_pay_grade_type pg,'||chr(10)||
'       t_osi_participant_nonhuman pnh'||chr(10)||
' where o.SID = p.SID'||chr(10)||
'   and p.current_version = pv.SID'||chr(10)||
'   and ph.SID(+) = pv.SID'||chr(10)||
'   and pnh.SID(+) = pv.SID'||chr(10)||
'   and ot.SID = o.obj_type'||chr(10)||
'   and pc.SID(+) = pv.SID'||chr(10)||
'   and pg.SID(+)';

s:=s||' = pc.sa_pay_grade'||chr(10)||
'   and ot.code = ''PART.NONINDIV.ORG'''||chr(10)||
'   and no_hash_join(o.SID) = ''Y''';

wwv_flow_api.create_page_plug (
  p_id=> 19326732731724054 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1630,
  p_plug_name=> 'Participants > Organizations',
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.ORG''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''javascript:getObjURL('''''' || o.SID || '''''');'' url, osi_participant.get_name(o.SID) as "Name",'||chr(10)||
'       osi_participant.get_subtype(o.SID) as "Type",'||chr(10)||
'       osi_participant.get_confirmation(o.SID) as "Confirmed", o.create_by as "Created By",'||chr(10)||
'       o.create_on as "Created On", o.times_accessed "Times Accessed",'||chr(10)||
'       o.last_accessed "Last Accessed"'||chr(10)||
'  from (select   o1.SID, o1.obj_type, o1.crea';

a1:=a1||'te_by, o1.create_on,'||chr(10)||
'                 sum(r1.times_accessed) times_accessed, max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, v_osi_participant_version pv1, t_osi_partic_name pn1'||chr(10)||
'           where r1.obj(+) = o1.SID'||chr(10)||
'             and pv1.participant = o1.SID'||chr(10)||
'             and pv1.SID = pv1.current_version'||chr(10)||
'             and (pn1.SID = pv1.current_na';

a1:=a1||'me)'||chr(10)||
'             and (CASE'||chr(10)||
'                      WHEN(:p1630_filter = ''RECENT'' and r1.personnel = :user_sid) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''RECENT_UNIT'''||chr(10)||
'                           and r1.unit = osi_personnel.get_current_unit(:user_sid)) then ''true'''||chr(10)||
'                      WHEN(:p1630_filter = ''NONE'' and 1 = 2) then ''true'''||chr(10)||
'                      WHEN(:p1630_filter in(''ALL''';

a1:=a1||', ''OSI'')) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''ABC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a|b|c][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ';

a1:=a1||'''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''DEF'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[d|e|f][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'        ';

a1:=a1||'              WHEN(    :p1630_filter = ''GHI'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[g|h|i][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      W';

a1:=a1||'HEN(    :p1630_filter = ''JKL'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[j|k|l][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_';

a1:=a1||'filter = ''MNO'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[m|n|o][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''PQRS''';

a1:=a1||''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[p|q|r|s][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''TUV'''||chr(10)||
'            ';

a1:=a1||'               and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[t|u|v][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''WXYZ'''||chr(10)||
'                          ';

a1:=a1||' and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[w|x|y|z][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''NUMERIC'''||chr(10)||
'                           and REGE';

a1:=a1||'XP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[0-9]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1630_filter = ''ALPHA'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'  ';

a1:=a1||'                                          ''[a-z]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      ELSE ''false'''||chr(10)||
'                  END = ''true'')'||chr(10)||
'        group by o1.SID, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'      ';

a1:=a1||' t_core_obj_type ot,'||chr(10)||
'       t_osi_participant p,'||chr(10)||
'       t_osi_participant_version pv,'||chr(10)||
'       t_osi_participant_human ph,'||chr(10)||
'       t_osi_person_chars pc,'||chr(10)||
'       t_dibrs_pay_grade_type pg,'||chr(10)||
'       t_osi_participant_nonhuman pnh'||chr(10)||
' where o.SID = p.SID'||chr(10)||
'   and p.current_version = pv.SID'||chr(10)||
'   and ph.SID(+) = pv.SID'||chr(10)||
'   and pnh.SID(+) = pv.SID'||chr(10)||
'   and ot.SID = o.obj_type'||chr(10)||
'   and pc.SID(+) = pv.SID'||chr(10)||
'   and pg.SID(+)';

a1:=a1||' = pc.sa_pay_grade'||chr(10)||
'   and ot.code = ''PART.NONINDIV.ORG'''||chr(10)||
'   and no_hash_join(o.SID) = ''Y''';

wwv_flow_api.create_worksheet(
  p_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1630,
  p_region_id => 19326732731724054+wwv_flow_api.g_id_offset,
  p_name => 'Desktop > C-Funds Expenses',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more than 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Activities found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1630_FILTER',
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
  p_download_filename         =>'&P1630_EXPORT_NAME.',
  p_detail_link              =>'#URL#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 21471009898993485+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
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
  p_id => 21471114639993487+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
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
  p_id => 21471216982993487+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Type',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Type',
  p_report_label           =>'Type',
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
  p_id => 21471304171993487+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Confirmed',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Confirmed',
  p_report_label           =>'Confirmed',
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
  p_id => 21471414626993487+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created On',
  p_display_order          =>5,
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
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 21471505539993489+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created By',
  p_display_order          =>6,
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
  p_id => 21471616061993489+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Times Accessed',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
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
  p_id => 21471722143993489+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Last Accessed',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
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
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 19332427886724075+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1630,
  p_worksheet_id => 19326924618724056+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'Name:Type:Confirmed:Created On:Created By:Times Accessed:Last Accessed',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15526705935163235 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1630,
  p_button_sequence=> 10,
  p_button_plug_id => 93038016766061346+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1630);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>1631518659805057 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1630,
  p_branch_action=> 'f?p=&APP_ID.:1630:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 25-MAR-2010 16:13 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1629612987793878 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1630,
  p_name=>'P1630_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 19326732731724054+wwv_flow_api.g_id_offset,
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
  p_id=>15533928276557612 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1630,
  p_name=>'P1630_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
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
  p_id=> 1629920952796185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1630,
  p_computation_sequence => 10,
  p_computation_item=> 'P1630_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1630_FILTER',
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
''||chr(10)||
'  if apex_collection.collection_exists(p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'') then'||chr(10)||
'    '||chr(10)||
'    apex_collection.delete_collection(p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'');'||chr(10)||
'  '||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
''||chr(10)||
'  APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY('||chr(10)||
'      p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'','||chr(10)||
'      p_query => OSI_DESKTOP.DesktopSQL(:P1630_FILTER';

p:=p||', :user_sid, ''PART.NONINDIV.ORG''));'||chr(10)||
'End;';

wwv_flow_api.create_page_process(
  p_id     => 19184923771405001 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1630,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP FILTERS DEFAULT',
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
 
---------------------------------------
-- ...updatable report columns for page 1630
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
