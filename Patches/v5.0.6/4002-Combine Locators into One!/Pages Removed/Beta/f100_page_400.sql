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
--   Date and Time:   07:42 Tuesday February 14, 2012
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

PROMPT ...Remove page 400
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>400);
 
end;
/

 
--application/pages/page_00400
prompt  ...PAGE 400: Locate Participants
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'"JS_LOCATOR"'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 400,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Locate Participants',
  p_step_title=> 'Locate Participants',
  p_step_sub_title => 'Locate Individual Participants',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'JASON',
  p_last_upd_yyyymmddhh24miss => '20110124113713',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '8-NOV-2010 J.Faris WCHG0000065 - Updated any references to :LOC_SELECTIONS to :P0_LOC_SELECTIONS, fixed conditions on ''Select'' links/checkboxes.'||chr(10)||
'18-JAN-2011 J.Faris - Query optimization updates, added CASE statements and regular expression alpha comparisons.'||chr(10)||
'21-JAN-2011 J.Faris - More optimization updates, added no_hash_join function to minimize full table scans.');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>400,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>400,p_text=>ph);
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
  p_id=> 94836511816933912 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 400,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
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
s:=s||'select apex_item.checkbox (1,'||chr(10)||
'                           o.sid,'||chr(10)||
'                           ''onchange="toggleCheckbox(this);"'','||chr(10)||
'                           :p0_loc_selections,'||chr(10)||
'                           '':'''||chr(10)||
'                          ) "Include",'||chr(10)||
'       ''<a href="javascript:passBack('''''' || o.sid || '''''', '''''' || '||chr(10)||
'                 :P400_RETURN_ITEM || '''''');">Select</a>'' "Select",'||chr(10)||
'       (CASE'||chr(10)||
'          ';

s:=s||'  WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.COMP'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Company",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.ORG'' then osi_participant.get_name(o.SID)'||chr(10)||
'    ';

s:=s||'        ELSE null'||chr(10)||
'        END) as "Organization",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.PROG'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Program",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then osi_participant.get_name_type(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type of Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p40';

s:=s||'0_partic_type = ''ALL'' then ot.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''ALL'' then osi_participant.get_subtype(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Sub Type",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''PART.NONINDIV.COMP'', ''PART.NONINDIV.ORG'') then osi_participant.get_subtype'||chr(10)||
'                                       ';

s:=s||'                                                       (o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Subtype2",'||chr(10)||
'       osi_participant.get_confirmation(o.sid) as "Confirmed",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then osi_participant.get_birth_country(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Country",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDI';

s:=s||'V'' then osi_participant.get_birth_state(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth State",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then osi_participant.get_birth_city(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth City",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then p.dob'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Date",'||chr(10)||
'       (CASE'||chr(10)||
'   ';

s:=s||'         WHEN :p400_partic_type = ''PART.NONINDIV.COMP'' then pnh.co_cage'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Cage Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.COMP'' then pnh.co_duns'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "DUNS",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                  ';

s:=s||'                                                    (ph.sa_service)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then osi_reference.lookup_ref_desc'||chr(10)||
'                                                                                  (ph.sa_affiliation)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Affiliation",'||chr(10)||
'       (CASE'||chr(10)||
'';

s:=s||'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                                                                    (ph.sa_component)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Component",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                  ';

s:=s||'                                                   (pc.sa_pay_plan)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Plan",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then pg.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Grade",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank'||chr(10)||
'            ELSE null'||chr(10)||
'        END) ';

s:=s||'as "Service Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank_date'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Date of Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then ph.sa_specialty_code'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Specialty Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' t';

s:=s||'hen dibrs_reference.lookup_ref_desc(pc.sex)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Sex",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then pc.height'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Height",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then pc.weight'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Weight",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.IND';

s:=s||'IV'' then decode(ph.age_low,'||chr(10)||
'                                                              null, null,'||chr(10)||
'                                                              ''NB'', ''0.008'','||chr(10)||
'                                                              ''NN'', ''0.0014'','||chr(10)||
'                                                              ''BB'', ''0.5'','||chr(10)||
'                                                              ph.age';

s:=s||'_low)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Minimum Age",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then ph.age_high'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Maximum Age",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By"'||chr(10)||
'  from (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 ';

s:=s||'sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, v_osi_participant_version pv1, t_osi_partic_name pn1'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and pv1.participant = o1.SID'||chr(10)||
'             and pv1.SID = pv1.current_version'||chr(10)||
'             and (pn1.SID = pv1.current_name)'||chr(10)||
'             and ';

s:=s||'(CASE'||chr(10)||
'                      WHEN(:p400_filter = ''RECENT'' and r1.personnel = :user_sid) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''RECENT_UNIT'''||chr(10)||
'                           and r1.unit = osi_personnel.get_current_unit(:user_sid)) then ''true'''||chr(10)||
'                      WHEN(:p400_filter = ''NONE'' and 1 = 2) then ''true'''||chr(10)||
'                      WHEN(:p400_filter in(''ALL'', ''OSI'')) then ''true'''||chr(10)||
'   ';

s:=s||'                   WHEN(    :p400_filter = ''ABC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a|b|c][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                   ';

s:=s||'   WHEN(    :p400_filter = ''DEF'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[d|e|f][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p40';

s:=s||'0_filter = ''GHI'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[g|h|i][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''JKL''';

s:=s||''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[j|k|l][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''MNO'''||chr(10)||
'               ';

s:=s||'            and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[m|n|o][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''PQRS'''||chr(10)||
'                           and';

s:=s||' REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[p|q|r|s][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''TUV'''||chr(10)||
'                           and REGEXP_INSTR(';

s:=s||'pn1.last_name,'||chr(10)||
'                                            ''[t|u|v][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''WXYZ'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'';

s:=s||'                                            ''[w|x|y|z][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''NUMERIC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'          ';

s:=s||'                                  ''[0-9]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''ALPHA'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                     ';

s:=s||'       ''[a-z]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      ELSE ''false'''||chr(10)||
'                  END = ''true'')'||chr(10)||
'       group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_core_obj_type ot,'||chr(10)||
'       t_osi_pa';

s:=s||'rticipant p,'||chr(10)||
'       t_osi_participant_version pv,'||chr(10)||
'       t_osi_participant_human ph,'||chr(10)||
'       t_osi_participant_nonhuman pnh,'||chr(10)||
'       t_osi_person_chars pc,'||chr(10)||
'       t_dibrs_pay_grade_type pg'||chr(10)||
' where o.sid = p.sid'||chr(10)||
'   and p.current_version = pv.sid'||chr(10)||
'   and ph.sid(+) = pv.sid'||chr(10)||
'   and pnh.sid(+) = pv.sid'||chr(10)||
'   and pc.sid(+) = pv.sid'||chr(10)||
'   and pg.sid(+) = pc.sa_pay_grade'||chr(10)||
'   and ot.sid = o.obj_type'||chr(10)||
'   and (   :p400_';

s:=s||'partic_type = ''ALL'''||chr(10)||
'        or ot.code = :p400_partic_type)'||chr(10)||
'   and instr(:P400_EXCLUDE, o.sid) = 0'||chr(10)||
'   and not exists(select 1'||chr(10)||
'                    from t_osi_participant_version pv1'||chr(10)||
'                   where pv1.participant = o.SID'||chr(10)||
'                     and instr(:P400_EXCLUDE, pv1.sid) > 0)'||chr(10)||
'   and no_hash_join(o.SID) = ''Y''';

wwv_flow_api.create_page_plug (
  p_id=> 94836722398933918 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 400,
  p_plug_name=> '&P400_OBJ_TAGLINE.',
  p_region_name=>'',
  p_plug_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> 'select apex_item.checkbox (1,'||chr(10)||
'                           o.sid,'||chr(10)||
'                           ''onchange="toggleCheckbox(this);"'','||chr(10)||
'                           :LOC_SELECTIONS,'||chr(10)||
'                           '':'''||chr(10)||
'                          ) "Include",'||chr(10)||
'       ''<a href="javascript:passBack('''''' || o.sid || '''''', '''''' || '||chr(10)||
'                 :P400_RETURN_ITEM || '''''');">Select</a>'' "Select",'||chr(10)||
'       osi_participant.get_name(o.sid) as "Name",'||chr(10)||
'       osi_participant.get_name(o.sid) as "Company",'||chr(10)||
'       osi_participant.get_name(o.sid) as "Organization",'||chr(10)||
'       osi_participant.get_name(o.sid) as "Program",'||chr(10)||
'       osi_participant.get_name_type(o.sid) as "Type of Name",'||chr(10)||
'       ot.description as "Type",'||chr(10)||
'       osi_participant.get_subtype(o.sid) as "Subtype",'||chr(10)||
'       osi_participant.get_subtype(o.sid) as "Subtype2",'||chr(10)||
'       osi_participant.get_confirmation(o.sid) as "Confirmed",'||chr(10)||
'       osi_participant.get_birth_country(o.sid) as "Birth Country",'||chr(10)||
'       osi_participant.get_birth_state(o.sid) as "Birth State",'||chr(10)||
'       osi_participant.get_birth_city(o.sid) as "Birth City",'||chr(10)||
'       ph.dob as "Birth Date",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By"'||chr(10)||
'  from t_core_obj o,'||chr(10)||
'       t_core_obj_type ot,'||chr(10)||
'       t_osi_participant_human ph,'||chr(10)||
'       t_osi_participant p'||chr(10)||
' where p.sid = o.sid'||chr(10)||
'   and ot.sid = o.obj_type'||chr(10)||
'   and ph.sid(+) = o.sid'||chr(10)||
'   and (:p400_partic_type = ''ALL'' or ot.code = :p400_partic_type)'||chr(10)||
'   and instr(:P400_EXCLUDE, o.sid) = 0');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select apex_item.checkbox (1,'||chr(10)||
'                           o.sid,'||chr(10)||
'                           ''onchange="toggleCheckbox(this);"'','||chr(10)||
'                           :p0_loc_selections,'||chr(10)||
'                           '':'''||chr(10)||
'                          ) "Include",'||chr(10)||
'       ''<a href="javascript:passBack('''''' || o.sid || '''''', '''''' || '||chr(10)||
'                 :P400_RETURN_ITEM || '''''');">Select</a>'' "Select",'||chr(10)||
'       (CASE'||chr(10)||
'          ';

a1:=a1||'  WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.COMP'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Company",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.ORG'' then osi_participant.get_name(o.SID)'||chr(10)||
'    ';

a1:=a1||'        ELSE null'||chr(10)||
'        END) as "Organization",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.PROG'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Program",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then osi_participant.get_name_type(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type of Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p40';

a1:=a1||'0_partic_type = ''ALL'' then ot.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''ALL'' then osi_participant.get_subtype(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Sub Type",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''PART.NONINDIV.COMP'', ''PART.NONINDIV.ORG'') then osi_participant.get_subtype'||chr(10)||
'                                       ';

a1:=a1||'                                                       (o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Subtype2",'||chr(10)||
'       osi_participant.get_confirmation(o.sid) as "Confirmed",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then osi_participant.get_birth_country(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Country",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDI';

a1:=a1||'V'' then osi_participant.get_birth_state(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth State",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then osi_participant.get_birth_city(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth City",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then p.dob'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Date",'||chr(10)||
'       (CASE'||chr(10)||
'   ';

a1:=a1||'         WHEN :p400_partic_type = ''PART.NONINDIV.COMP'' then pnh.co_cage'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Cage Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.NONINDIV.COMP'' then pnh.co_duns'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "DUNS",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                  ';

a1:=a1||'                                                    (ph.sa_service)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then osi_reference.lookup_ref_desc'||chr(10)||
'                                                                                  (ph.sa_affiliation)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Affiliation",'||chr(10)||
'       (CASE'||chr(10)||
'';

a1:=a1||'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                                                                    (ph.sa_component)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Component",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                  ';

a1:=a1||'                                                   (pc.sa_pay_plan)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Plan",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then pg.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Grade",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank'||chr(10)||
'            ELSE null'||chr(10)||
'        END) ';

a1:=a1||'as "Service Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank_date'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Date of Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type in(''ALL'', ''PART.INDIV'') then ph.sa_specialty_code'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Specialty Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' t';

a1:=a1||'hen dibrs_reference.lookup_ref_desc(pc.sex)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Sex",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then pc.height'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Height",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then pc.weight'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Weight",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.IND';

a1:=a1||'IV'' then decode(ph.age_low,'||chr(10)||
'                                                              null, null,'||chr(10)||
'                                                              ''NB'', ''0.008'','||chr(10)||
'                                                              ''NN'', ''0.0014'','||chr(10)||
'                                                              ''BB'', ''0.5'','||chr(10)||
'                                                              ph.age';

a1:=a1||'_low)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Minimum Age",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p400_partic_type = ''PART.INDIV'' then ph.age_high'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Maximum Age",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By"'||chr(10)||
'  from (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 ';

a1:=a1||'sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, v_osi_participant_version pv1, t_osi_partic_name pn1'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and pv1.participant = o1.SID'||chr(10)||
'             and pv1.SID = pv1.current_version'||chr(10)||
'             and (pn1.SID = pv1.current_name)'||chr(10)||
'             and ';

a1:=a1||'(CASE'||chr(10)||
'                      WHEN(:p400_filter = ''RECENT'' and r1.personnel = :user_sid) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''RECENT_UNIT'''||chr(10)||
'                           and r1.unit = osi_personnel.get_current_unit(:user_sid)) then ''true'''||chr(10)||
'                      WHEN(:p400_filter = ''NONE'' and 1 = 2) then ''true'''||chr(10)||
'                      WHEN(:p400_filter in(''ALL'', ''OSI'')) then ''true'''||chr(10)||
'   ';

a1:=a1||'                   WHEN(    :p400_filter = ''ABC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a|b|c][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                   ';

a1:=a1||'   WHEN(    :p400_filter = ''DEF'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[d|e|f][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p40';

a1:=a1||'0_filter = ''GHI'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[g|h|i][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''JKL''';

a1:=a1||''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[j|k|l][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''MNO'''||chr(10)||
'               ';

a1:=a1||'            and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[m|n|o][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''PQRS'''||chr(10)||
'                           and';

a1:=a1||' REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[p|q|r|s][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''TUV'''||chr(10)||
'                           and REGEXP_INSTR(';

a1:=a1||'pn1.last_name,'||chr(10)||
'                                            ''[t|u|v][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''WXYZ'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'';

a1:=a1||'                                            ''[w|x|y|z][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''NUMERIC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'          ';

a1:=a1||'                                  ''[0-9]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p400_filter = ''ALPHA'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                     ';

a1:=a1||'       ''[a-z]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      ELSE ''false'''||chr(10)||
'                  END = ''true'')'||chr(10)||
'       group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_core_obj_type ot,'||chr(10)||
'       t_osi_pa';

a1:=a1||'rticipant p,'||chr(10)||
'       t_osi_participant_version pv,'||chr(10)||
'       t_osi_participant_human ph,'||chr(10)||
'       t_osi_participant_nonhuman pnh,'||chr(10)||
'       t_osi_person_chars pc,'||chr(10)||
'       t_dibrs_pay_grade_type pg'||chr(10)||
' where o.sid = p.sid'||chr(10)||
'   and p.current_version = pv.sid'||chr(10)||
'   and ph.sid(+) = pv.sid'||chr(10)||
'   and pnh.sid(+) = pv.sid'||chr(10)||
'   and pc.sid(+) = pv.sid'||chr(10)||
'   and pg.sid(+) = pc.sa_pay_grade'||chr(10)||
'   and ot.sid = o.obj_type'||chr(10)||
'   and (   :p400_';

a1:=a1||'partic_type = ''ALL'''||chr(10)||
'        or ot.code = :p400_partic_type)'||chr(10)||
'   and instr(:P400_EXCLUDE, o.sid) = 0'||chr(10)||
'   and not exists(select 1'||chr(10)||
'                    from t_osi_participant_version pv1'||chr(10)||
'                   where pv1.participant = o.SID'||chr(10)||
'                     and instr(:P400_EXCLUDE, pv1.sid) > 0)'||chr(10)||
'   and no_hash_join(o.SID) = ''Y''';

wwv_flow_api.create_worksheet(
  p_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 400,
  p_region_id => 94836722398933918+wwv_flow_api.g_id_offset,
  p_name => 'Activities',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more than 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No data found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P400_FILTER,P400_PARTIC_TYPE',
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
  p_show_detail_link          =>'N',
  p_show_select_columns       =>'N',
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
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'TIM');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94837017264933931+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 400,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Include',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'Include',
  p_report_label           =>'Include',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_MULTI',
  p_display_condition2     =>'Y',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94837120231933937+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 400,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Select',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Select',
  p_report_label           =>'Select',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2',
  p_display_condition      =>'P400_MULTI',
  p_display_condition2     =>'Y',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94841015992975681+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Name',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE = ''ALL'' or :P400_PARTIC_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94864210152352418+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Company',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Company',
  p_report_label           =>'Company',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.NONINDIV.COMP',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94864331324352418+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Organization',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Organization',
  p_report_label           =>'Organization',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.NONINDIV.ORG',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94864836948369618+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Program',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Program',
  p_report_label           =>'Program',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.NONINDIV.PROG',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94854229526206615+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Type',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 21511626378731481+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Sub Type',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AG',
  p_column_label           =>'Sub Type',
  p_report_label           =>'Sub Type',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94864410459352418+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Subtype2',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94841124731975682+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Type of Name',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94841215063975682+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Confirmed',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
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
  p_id => 94841326303975682+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth Country',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94841427293975682+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth State',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94841525025975684+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth City',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94841631387975685+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth Date',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
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
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'&FMT_DATE.',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 94841707157975685+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created On',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
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
  p_id => 94841818940975685+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created By',
  p_display_order          =>17,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Q',
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
  p_id => 5145515240677670+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Cage Code',
  p_display_order          =>18,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'R',
  p_column_label           =>'Cage Code',
  p_report_label           =>'Cage Code',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.NONINDIV.COMP',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5145611133677670+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DUNS',
  p_display_order          =>19,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'S',
  p_column_label           =>'DUNS',
  p_report_label           =>'DUNS',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.NONINDIV.COMP',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5145719944677670+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service',
  p_display_order          =>20,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'T',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5145808314677671+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Affiliation',
  p_display_order          =>21,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'U',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5145924442677671+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Component',
  p_display_order          =>22,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'V',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146028815677671+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Pay Plan',
  p_display_order          =>23,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'W',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146110853677671+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Pay Grade',
  p_display_order          =>24,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'X',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146222180677673+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Rank',
  p_display_order          =>25,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Y',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146306544677673+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Date of Rank',
  p_display_order          =>26,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Z',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146403834677673+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Service Specialty Code',
  p_display_order          =>27,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AA',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P400_PARTIC_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146525782677675+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Sex',
  p_display_order          =>28,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AB',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146618282677675+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Height',
  p_display_order          =>29,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AC',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146711935677675+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Weight',
  p_display_order          =>30,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AD',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146814574677675+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Minimum Age',
  p_display_order          =>31,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AE',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 5146924353677675+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Maximum Age',
  p_display_order          =>32,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AF',
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
  p_display_condition_type =>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_display_condition      =>'P400_PARTIC_TYPE',
  p_display_condition2     =>'PART.INDIV',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 94837531273933942+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 400,
  p_worksheet_id => 94836912264933920+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'Include:Select:Name:Company:Organization:Program:Type:Subtype:Subtype2:Type of Name:Confirmed:Birth Country:Birth State:Birth City:Birth Date:Created On:Created By',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 94837616384933945 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 400,
  p_button_sequence=> 10,
  p_button_plug_id => 94836722398933918+wwv_flow_api.g_id_offset,
  p_button_name    => 'RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Return Selections',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:passBack(''theList'',''&P400_RETURN_ITEM.'');',
  p_button_condition=> 'P400_MULTI',
  p_button_condition2=> 'Y',
  p_button_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>94839308582933964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_branch_action=> 'f?p=&APP_ID.:400:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4629525213039556 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_PARTIC_TYPE_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ALL',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P400_PARTIC_TYPE_LIST',
  p_source_type=> 'STATIC',
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5147130824682200 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 94836722398933918+wwv_flow_api.g_id_offset,
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
  p_id=>94837811964933949 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_MULTI',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
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
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>94838038951933951 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_EXCLUDE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Z',
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
  p_id=>94838210635933951 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>94838434363933953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>94838635169933953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P400_RETURN',
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
  p_id=>94838831355933954 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_INITIALIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 94836722398933918+wwv_flow_api.g_id_offset,
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
  p_id=>94851733542122690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_PARTIC_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 94836722398933918+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ALL',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P400_PARTIC_TYPE_LOV.',
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
  p_display_when=>'P400_SHOW_PARTIC_TYPE',
  p_display_when2=>'Y',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>95019924226241157 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_SHOW_PARTIC_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Y',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P400_SHOW_PARTIC_TYPE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>96942838631645559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_name=>'P400_PARTIC_TYPE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 94836511816933912+wwv_flow_api.g_id_offset,
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
  p_id=> 5147201865683253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 400,
  p_computation_sequence => 10,
  p_computation_item=> 'P400_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P400_FILTER',
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
p:=p||':P0_LOC_SELECTIONS := null;'||chr(10)||
':P400_INITIALIZED := ''Y'';'||chr(10)||
''||chr(10)||
':P400_PARTIC_TYPE_LOV := OSI_PARTICIPANT.GET_TYPE_LOV(nvl(:P400_PARTIC_TYPE_LIST, ''ALL''));'||chr(10)||
'if :P400_OBJ is not null then'||chr(10)||
'   :P400_OBJ_TAGLINE := core_obj.get_tagline(:P400_OBJ);'||chr(10)||
'end if;'||chr(10)||
'if :REQUEST <> ''OPEN'' then'||chr(10)||
'   :P400_SHOW_PARTIC_TYPE := ''N'';'||chr(10)||
'   :P400_PARTIC_TYPE := :REQUEST;'||chr(10)||
'else'||chr(10)||
'   --change the default type for :p400_partic_type if ''ALL''';

p:=p||' not available'||chr(10)||
'   if instr(nvl(:P400_PARTIC_TYPE_LIST, ''ALL''), ''ALL'') = 0 then'||chr(10)||
'      :P400_PARTIC_TYPE := core_list.get_list_element(:P400_PARTIC_TYPE_LIST, 1);'||chr(10)||
'   end if;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 94839028850933956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 400,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P400_INITIALIZED',
  p_process_when_type=>'ITEM_IS_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 400
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
