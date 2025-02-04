--application/pages/page_01030
prompt  ...PAGE 1030: Desktop Participants
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1030,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Participants',
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
  p_last_upd_yyyymmddhh24miss => '20110121152214',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '19-JAN-2011 J.Faris - Query optimization updates, added CASE statements and regular expression alpha comparisons.'||chr(10)||
'21-JAN-2011 J.Faris - More optimization updates, added no_hash_join function to minimize full table scans.');
 
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
  p_id=> 6183812329267562 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1030,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.INDIV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.PROG''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.ORG''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.COMP''))=''N''',
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
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.COMP'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Company",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type =';

s:=s||' ''PART.NONINDIV.ORG'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Organization",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.PROG'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Program",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then osi_participant.get_name_type(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as ';

s:=s||'"Type of Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''ALL'' then ot.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''PART.NONINDIV.COMP'', ''PART.NONINDIV.ORG'') then osi_participant.get_subtype(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type 2",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''ALL''  then osi_participant.get_subtype(o.SID)'||chr(10)||
' ';

s:=s||'           ELSE null'||chr(10)||
'        END) as "Sub Type",'||chr(10)||
'       osi_participant.get_confirmation(o.sid) as "Confirmed",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.COMP'' then pnh.co_cage'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Cage Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.COMP'' then pnh.co_duns'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "DUNS",'||chr(10)||
'       (CASE'||chr(10)||
'            WH';

s:=s||'EN :p1030_type = ''PART.INDIV'' then osi_participant.get_birth_country(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Country",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then osi_participant.get_birth_state(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth State",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then osi_participant.get_birth_city(o.SID)'||chr(10)||
'            ELS';

s:=s||'E null'||chr(10)||
'        END) as "Birth City",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then p.dob'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Date",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                                                                      (ph.sa_service)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as ';

s:=s||'"Service",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then osi_reference.lookup_ref_desc'||chr(10)||
'                                                                                  (ph.sa_affiliation)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Affiliation",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                      ';

s:=s||'                                                              (ph.sa_component)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Component",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                                                                     (pc.sa_pay_plan)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Plan"';

s:=s||','||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then pg.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Grade",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank_date'||chr(10)||
'            ELSE null'||chr(10)||
'        ';

s:=s||'END) as "Service Date of Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then ph.sa_specialty_code'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Specialty Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then dibrs_reference.lookup_ref_desc(pc.sex)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Sex",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then pc.';

s:=s||'height'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Height",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then pc.weight'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Weight",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then decode(ph.age_low,'||chr(10)||
'                                                              null, null,'||chr(10)||
'                                                              ''NB'', ''0';

s:=s||'.008'','||chr(10)||
'                                                              ''NN'', ''0.0014'','||chr(10)||
'                                                              ''BB'', ''0.5'','||chr(10)||
'                                                              ph.age_low)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Minimum Age",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then ph.age_high'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "';

s:=s||'Maximum Age",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.times_accessed "Times Accessed",'||chr(10)||
'       o.last_accessed "Last Accessed",'||chr(10)||
'       osi_vlt.get_vlt_url(o.sid) as "VLT"'||chr(10)||
'  from        (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'      ';

s:=s||'           max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, v_osi_participant_version pv1, t_osi_partic_name pn1'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and pv1.participant = o1.sid '||chr(10)||
'             and pv1.SID = pv1.current_version'||chr(10)||
'             and (pn1.SID = pv1.current_name)'||chr(10)||
'             and (CASE'||chr(10)||
'                      WHEN(:p1030_filt';

s:=s||'er = ''RECENT'' and r1.personnel = :user_sid) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''RECENT_UNIT'''||chr(10)||
'                           and r1.unit = osi_personnel.get_current_unit(:user_sid)) then ''true'''||chr(10)||
'                      WHEN(:p1030_filter = ''NONE'' and 1 = 2) then ''true'''||chr(10)||
'                      WHEN(:p1030_filter in(''ALL'', ''OSI'')) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filte';

s:=s||'r = ''ABC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a|b|c][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''DEF'''||chr(10)||
'     ';

s:=s||'                      and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[d|e|f][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''GHI'''||chr(10)||
'                    ';

s:=s||'       and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[g|h|i][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''JKL'''||chr(10)||
'                           and REGE';

s:=s||'XP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[j|k|l][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''MNO'''||chr(10)||
'                           and REGEXP_INSTR(pn1.la';

s:=s||'st_name,'||chr(10)||
'                                            ''[m|n|o][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''PQRS'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'     ';

s:=s||'                                       ''[p|q|r|s][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''TUV'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                  ';

s:=s||'                          ''[t|u|v][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''WXYZ'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                ';

s:=s||'            ''[w|x|y|z][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''NUMERIC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                         ';

s:=s||'   ''[0-9]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''ALPHA'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a-z]'','||chr(10)||
'              ';

s:=s||'                              1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      ELSE ''false'''||chr(10)||
'                  END = ''true'')'||chr(10)||
'       group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_core_obj_type ot,'||chr(10)||
'       t_osi_participant p,'||chr(10)||
'       t_osi_part';

s:=s||'icipant_version pv,'||chr(10)||
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
'   and (   :p1030_type = ''ALL'''||chr(10)||
'        or ot.co';

s:=s||'de = :p1030_type)'||chr(10)||
'   and no_hash_join(o.sid) = ''Y''';

wwv_flow_api.create_page_plug (
  p_id=> 92404724559127059 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1030,
  p_plug_name=> 'Desktop > Participants',
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
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.INDIV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.PROG''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.ORG''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''PART.NONINDIV.COMP''))=''N'''||chr(10)||
')',
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
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.COMP'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Company",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type =';

a1:=a1||' ''PART.NONINDIV.ORG'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Organization",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.PROG'' then osi_participant.get_name(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Program",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then osi_participant.get_name_type(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as ';

a1:=a1||'"Type of Name",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''ALL'' then ot.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''PART.NONINDIV.COMP'', ''PART.NONINDIV.ORG'') then osi_participant.get_subtype(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Type 2",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''ALL''  then osi_participant.get_subtype(o.SID)'||chr(10)||
' ';

a1:=a1||'           ELSE null'||chr(10)||
'        END) as "Sub Type",'||chr(10)||
'       osi_participant.get_confirmation(o.sid) as "Confirmed",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.COMP'' then pnh.co_cage'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Cage Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.NONINDIV.COMP'' then pnh.co_duns'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "DUNS",'||chr(10)||
'       (CASE'||chr(10)||
'            WH';

a1:=a1||'EN :p1030_type = ''PART.INDIV'' then osi_participant.get_birth_country(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Country",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then osi_participant.get_birth_state(o.SID)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth State",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then osi_participant.get_birth_city(o.SID)'||chr(10)||
'            ELS';

a1:=a1||'E null'||chr(10)||
'        END) as "Birth City",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then p.dob'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Birth Date",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                                                                      (ph.sa_service)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as ';

a1:=a1||'"Service",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then osi_reference.lookup_ref_desc'||chr(10)||
'                                                                                  (ph.sa_affiliation)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Affiliation",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                      ';

a1:=a1||'                                                              (ph.sa_component)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Component",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then dibrs_reference.lookup_ref_desc'||chr(10)||
'                                                                                     (pc.sa_pay_plan)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Plan"';

a1:=a1||','||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then pg.description'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Pay Grade",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then ph.sa_rank_date'||chr(10)||
'            ELSE null'||chr(10)||
'        ';

a1:=a1||'END) as "Service Date of Rank",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type in(''ALL'', ''PART.INDIV'') then ph.sa_specialty_code'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Service Specialty Code",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then dibrs_reference.lookup_ref_desc(pc.sex)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Sex",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then pc.';

a1:=a1||'height'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Height",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then pc.weight'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Weight",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then decode(ph.age_low,'||chr(10)||
'                                                              null, null,'||chr(10)||
'                                                              ''NB'', ''0';

a1:=a1||'.008'','||chr(10)||
'                                                              ''NN'', ''0.0014'','||chr(10)||
'                                                              ''BB'', ''0.5'','||chr(10)||
'                                                              ph.age_low)'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "Minimum Age",'||chr(10)||
'       (CASE'||chr(10)||
'            WHEN :p1030_type = ''PART.INDIV'' then ph.age_high'||chr(10)||
'            ELSE null'||chr(10)||
'        END) as "';

a1:=a1||'Maximum Age",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.times_accessed "Times Accessed",'||chr(10)||
'       o.last_accessed "Last Accessed",'||chr(10)||
'       osi_vlt.get_vlt_url(o.sid) as "VLT"'||chr(10)||
'  from        (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'      ';

a1:=a1||'           max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, v_osi_participant_version pv1, t_osi_partic_name pn1'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and pv1.participant = o1.sid '||chr(10)||
'             and pv1.SID = pv1.current_version'||chr(10)||
'             and (pn1.SID = pv1.current_name)'||chr(10)||
'             and (CASE'||chr(10)||
'                      WHEN(:p1030_filt';

a1:=a1||'er = ''RECENT'' and r1.personnel = :user_sid) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''RECENT_UNIT'''||chr(10)||
'                           and r1.unit = osi_personnel.get_current_unit(:user_sid)) then ''true'''||chr(10)||
'                      WHEN(:p1030_filter = ''NONE'' and 1 = 2) then ''true'''||chr(10)||
'                      WHEN(:p1030_filter in(''ALL'', ''OSI'')) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filte';

a1:=a1||'r = ''ABC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a|b|c][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''DEF'''||chr(10)||
'     ';

a1:=a1||'                      and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[d|e|f][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''GHI'''||chr(10)||
'                    ';

a1:=a1||'       and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[g|h|i][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''JKL'''||chr(10)||
'                           and REGE';

a1:=a1||'XP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[j|k|l][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''MNO'''||chr(10)||
'                           and REGEXP_INSTR(pn1.la';

a1:=a1||'st_name,'||chr(10)||
'                                            ''[m|n|o][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''PQRS'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'     ';

a1:=a1||'                                       ''[p|q|r|s][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''TUV'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                  ';

a1:=a1||'                          ''[t|u|v][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''WXYZ'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                ';

a1:=a1||'            ''[w|x|y|z][[:alpha:]]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''NUMERIC'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                         ';

a1:=a1||'   ''[0-9]'','||chr(10)||
'                                            1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      WHEN(    :p1030_filter = ''ALPHA'''||chr(10)||
'                           and REGEXP_INSTR(pn1.last_name,'||chr(10)||
'                                            ''[a-z]'','||chr(10)||
'              ';

a1:=a1||'                              1,'||chr(10)||
'                                            1,'||chr(10)||
'                                            0,'||chr(10)||
'                                            ''i'') = 1) then ''true'''||chr(10)||
'                      ELSE ''false'''||chr(10)||
'                  END = ''true'')'||chr(10)||
'       group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_core_obj_type ot,'||chr(10)||
'       t_osi_participant p,'||chr(10)||
'       t_osi_part';

a1:=a1||'icipant_version pv,'||chr(10)||
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
'   and (   :p1030_type = ''ALL'''||chr(10)||
'        or ot.co';

a1:=a1||'de = :p1030_type)'||chr(10)||
'   and no_hash_join(o.sid) = ''Y''';

wwv_flow_api.create_worksheet(
  p_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1030,
  p_region_id => 92404724559127059+wwv_flow_api.g_id_offset,
  p_name => 'Desktop > Participants',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more than 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Participants found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1030_FILTER,P1030_TYPE',
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
  p_download_filename         =>'&P1030_EXPORT_NAME.',
  p_detail_link              =>'#URL#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97175135294017445+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_id => 92405119909127060+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1030,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''ALL'' or :P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97172618540003145+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Company',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
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
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.NONINDIV.COMP''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97172728081003154+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Organization',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
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
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.NONINDIV.ORG''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97172825834003154+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Program',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
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
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.NONINDIV.PROG''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96583321404590664+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Type',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''ALL''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97177013186115174+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Sub Type',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
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
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''ALL''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97172930338003154+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Type of Name',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Type of Name',
  p_report_label           =>'Type of Name',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 21572105040779846+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Type 2',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AI',
  p_column_label           =>'Type 2',
  p_report_label           =>'Type 2',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.NONINDIV.COMP'' or :P1030_TYPE = ''PART.NONINDIV.ORG''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 96584437258689803+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Confirmed',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
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
  p_id => 97173227256003156+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth Country',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97173317921003156+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth State',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97173410362003156+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth City',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 97176811324105137+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Birth Date',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 92405508376127062+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1030,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created By',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
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
  p_id => 92405413371127062+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1030,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Created On',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'Created On',
  p_report_label           =>'Created On',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_linktext        =>'#',
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
  p_id => 6882114840240770+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Times Accessed',
  p_display_order          =>17,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Q',
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
  p_id => 6882231760240770+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Last Accessed',
  p_display_order          =>18,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'R',
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
  p_id => 1641503346895221+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'VLT',
  p_display_order          =>19,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'S',
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
  p_id => 1910816487192334+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1910904329192334+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1911026440192335+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1911129284192335+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1911224377192335+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1911307245192348+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1911414089192348+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1911510250192350+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition      =>':P1030_TYPE in (''ALL'',''PART.INDIV'')',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1913620006297464+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1913707046297464+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1913828495297464+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1913920503297464+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1914020687297465+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.INDIV''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1929828757424631+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Cage Code',
  p_display_order          =>33,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AG',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.NONINDIV.COMP''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1929914971424631+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DUNS',
  p_display_order          =>34,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'AH',
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
  p_display_condition_type =>'PLSQL_EXPRESSION',
  p_display_condition      =>':P1030_TYPE = ''PART.NONINDIV.COMP''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 92405711976127859+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1030,
  p_worksheet_id => 92404837689127059+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'Program:Name:Company:Organization:Type:Sub Type:Confirmed:Type of Name:Type2:Birth Country:Birth State:Birth City:Birth Date:Created By:Created On:Times Accessed:Last Accessed:VLT',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15360919870685234 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1030,
  p_button_sequence=> 10,
  p_button_plug_id => 92404724559127059+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1030);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>96578136848509953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1030,
  p_branch_action=> 'f?p=&APP_ID.:1030:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 31-JUL-2009 16:28 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6879209496078321 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1030,
  p_name=>'P1030_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 92404724559127059+wwv_flow_api.g_id_offset,
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
  p_id=>15444123730709517 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1030,
  p_name=>'P1030_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 92404724559127059+wwv_flow_api.g_id_offset,
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
  p_id=>96577607758501531 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1030,
  p_name=>'P1030_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 92404724559127059+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ALL',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P1030_TYPE_LOV.',
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
  p_id=>96577821610505540 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1030,
  p_name=>'P1030_TYPE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 92404724559127059+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_type_lov',
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

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 6961208180602570 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1030,
  p_computation_sequence => 10,
  p_computation_item=> 'P1030_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1030_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1030
--
 
begin
 
null;
end;
null;
 
end;
/

 
