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
--   Date and Time:   10:22 Wednesday June 8, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Init Page Zero Items
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
 
 
prompt Component Export: APP PROCESS 88895918473684379
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  v_id varchar2(1000);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'   --- SSL Certificate Items, CAC Card ---'||chr(10)||
'   :P0_SSL_CERT := OWA_UTIL.GET_CGI_ENV(''SSL_CLIENT_S_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT)))'||chr(10)||
'   LOOP'||chr(10)||
'       if substr(a.column_value,1,3) = ''CN='' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_S_DN_CN := substr(a.column_value,4);'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
''||chr(10)||
'   :P0_SSL_CERT_I := OWA_UTIL.GET_CGI_ENV(''SSL_';

p:=p||'CLIENT_I_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT_I)))'||chr(10)||
'   LOOP'||chr(10)||
'       if a.column_value=''OU=DoD'' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_I_DN_OU := a.column_value;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
'   ---------------------------------------'||chr(10)||
''||chr(10)||
'   if :P0_OBJ is not null and :APP_PAGE_ID >= 5000 then'||chr(10)||
'     select sid, '||chr(10)||
'            code, '||chr(10)||
'            core_obj.get_tagline(:P0_OBJ),'||chr(10)||
'            s';

p:=p||'ubstr(core_obj.get_tagline(:P0_OBJ),1,70),'||chr(10)||
'            osi_object.get_id(:P0_OBJ, :P0_OBJ_CONTEXT)'||chr(10)||
'       into :P0_OBJ_TYPE_SID, '||chr(10)||
'            :P0_OBJ_TYPE_CODE, '||chr(10)||
'            :P0_OBJ_TAGLINE,'||chr(10)||
'            :P0_OBJ_TAGLINE_SHORT,'||chr(10)||
'            :P0_OBJ_ID'||chr(10)||
'       from t_core_obj_type'||chr(10)||
'      where sid = core_obj.get_objtype(:P0_OBJ);'||chr(10)||
''||chr(10)||
'      :P0_AUTHORIZED := osi_auth.check_access(:P0_OBJ);'||chr(10)||
'      if     :P0_';

p:=p||'OBJ_TYPE_CODE = ''UNIT'' '||chr(10)||
'         and :APP_PAGE_ID between 30700 and 30799 then'||chr(10)||
'           :P0_OBJ_TYPE_CODE := ''EMM'';'||chr(10)||
''||chr(10)||
'           select sid into :P0_OBJ_TYPE_SID '||chr(10)||
'                 from t_core_obj_type where code=''EMM'';'||chr(10)||
''||chr(10)||
'           :P0_OBJ_TAGLINE := ''Evidence Management Module for: '' ||'||chr(10)||
'                              osi_unit.get_name(:P0_OBJ);'||chr(10)||
'           :P0_AUTHORIZED := osi_auth.check_for_priv(';

p:=p||'''EMM_CUST'','||chr(10)||
'                                          core_obj.lookup_objtype(''EMM''),'||chr(10)||
'                                          null,'||chr(10)||
'                                          :P0_OBJ);'||chr(10)||
'        :P0_WRITABLE := :P0_AUTHORIZED;'||chr(10)||
'      else'||chr(10)||
'        if osi_auth.check_for_priv(''UPDATE'',:P0_OBJ_TYPE_SID)=''Y'' then'||chr(10)||
'          :P0_WRITABLE := osi_object.check_writability(:P0_OBJ, :P0_OBJ_CONTEXT);'||chr(10)||
'        el';

p:=p||'se'||chr(10)||
'          :P0_WRITABLE := ''N'';'||chr(10)||
'        end if;'||chr(10)||
'      end if;'||chr(10)||
'  elsif :APP_PAGE_ID between 1000 and 4999 then'||chr(10)||
'      :P0_OBJ := null;'||chr(10)||
'      :P0_OBJ_TYPE_SID := null;'||chr(10)||
'      :P0_OBJ_TYPE_CODE := null;'||chr(10)||
'      :P0_OBJ_CONTEXT := null;'||chr(10)||
'      :P0_OBJ_TAGLINE := null;'||chr(10)||
'  else'||chr(10)||
'      :P0_OBJ_TYPE_SID := null;'||chr(10)||
'      :P0_OBJ_TAGLINE := null;'||chr(10)||
'      :P0_OBJ_ID := null;'||chr(10)||
'      if :P0_OBJ_TYPE_CODE is not null the';

p:=p||'n'||chr(10)||
'         :P0_OBJ_TYPE_SID := core_obj.lookup_objtype(:P0_OBJ_TYPE_CODE);'||chr(10)||
'      end if;'||chr(10)||
'      if :P0_OBJ_TYPE_CODE <> ''ALL.REPORT_SPEC'' then'||chr(10)||
'         :P0_OBJ_CONTEXT := null;'||chr(10)||
'      end if;'||chr(10)||
'      :P0_AUTHORIZED := null;'||chr(10)||
'  end if;'||chr(10)||
'  if :APP_PAGE_ID=30101 then'||chr(10)||
''||chr(10)||
'    :P0_AUTHORIZED:=''Y'';'||chr(10)||
'    :P0_WRITABLE:=''Y'';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 88895918473684379 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Init Page Zero Items',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Error Initializing Page Zero Items.',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> 'This process runs before the header for every page, and is responsible for maintaining the Page Zero Object-specifics (P0_OBJ, P0_OBJ_TYPE_CODE, P0_OBJ_TYPE_SID and P0_OBJ_TAGLINE). '||chr(10)||
''||chr(10)||
'16-JUN-2010 Jason Faris Task 2997 - Updated process to not reset obj_context item when obj_type_code = ''ALL.REPORT_SPEC''. '||chr(10)||
''||chr(10)||
'If the current page is not within our object specific pages, or common object pages (i.e. associations), then the values of these items are all cleared out.  Otherwise, if P0_OBJ is set (meaning we are in edit mode for an object), then P0_OBJ_TYPE_CODE and P0_OBJ_TYPE_SID are derived from P0_OBJ.  If P0_OBJ is NOT set (meaning we''re in create mode for an object), then P0_OBJ_TYPE_SID is derived from P0_OBJ_TYPE_CODE.'||chr(10)||
''||chr(10)||
''||chr(10)||
'08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Added Page 30101 check, so if accessed is always '||chr(10)||
'                       viewable by anyone.');
end;
 
null;
 
end;
/

COMMIT;

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
--   Date and Time:   10:21 Wednesday June 8, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Recently Accessed
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
 
 
prompt Component Export: APP PROCESS 6120009213511126
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'  if :AUDITING = ''ON'' then'||chr(10)||
'    log_info(''Launch:'' || :p0_obj || '' - '' || core_obj.get_tagline(:p0_obj));'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  update t_osi_personnel_recent_objects'||chr(10)||
'     set times_accessed= times_accessed+ 1,'||chr(10)||
'         last_accessed= sysdate'||chr(10)||
'   where personnel = :user_sid'||chr(10)||
'     and obj = :p0_obj;'||chr(10)||
''||chr(10)||
'  if sql%rowcount = 0 then'||chr(10)||
'      insert into t_osi_personnel_recent_objects'||chr(10)||
'              (personnel, '||chr(10)||
'   ';

p:=p||'            obj, '||chr(10)||
'               unit, '||chr(10)||
'               times_accessed, '||chr(10)||
'               last_accessed)'||chr(10)||
'      values (:user_sid, '||chr(10)||
'              :p0_obj, '||chr(10)||
'              osi_personnel.get_current_unit(:user_sid), '||chr(10)||
'              1, '||chr(10)||
'              sysdate);'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 6120009213511126 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1.1,
  p_process_point => 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Recently Accessed',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Error logging recently accessed object.',
  p_process_when=> '(:request = ''OPEN'' and :p0_obj is not null and :p0_AUTHORIZED = ''Y'') or :APP_PAGE_ID=30101',
  p_process_when_type=> 'PLSQL_EXPRESSION',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Added Page 30101 to allow adding to recent objects.');
end;
 
null;
 
end;
/

COMMIT;

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

PROMPT ...Remove page 0
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>0);
 
end;
/

 
--application/pages/page_00000
prompt  ...PAGE 0: Page Zero
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 0,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Page Zero',
  p_step_title=> 'Page Zero',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215462100554475+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110601112511',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-MAY-2010  Jason Faris     Added ''Create Exam'' Region (button html) for Poly File support.'||chr(10)||
'18-MAY-2010  Jason Faris     Fixed ''missing source'' bug in report label/url items 4 and 5.'||chr(10)||
'16-JUN-2010  Jason Faris     Task 2997 - Create Run Report - Page 0 Html Region (button).  Update condition on VLT - Page 0 Html Region (button). Update Navigation L1, L2, L3 Regions w/ show_tab = ''Y'' check.  Added P0_LBL_REPORT6 - 10, P0_URL_REPORT6 - 10 for additional Case report support.'||chr(10)||
'02-Mar-2011 - TJW - CR#3705 - Use Reports Menu now on CFunds Expenses, need to make sure the the VLT button doesn''''t show.'||chr(10)||
''||chr(10)||
'25-May-2011 - CR#3822 - Two Items Open at Same Time overwrite :P0_OBJ '||chr(10)||
'                        and cause problems.  Changed Navigation L1-3.');
 
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
  p_id=> 2934707644772068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Email IAFIS Package',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .085,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 1956624401125621 + wwv_flow_api.g_id_offset,
  p_list_template_id=> 2700427483559020+ wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'SQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE=''ACT.FINGERPRINT.CRIMINAL'''||chr(10)||
'and'||chr(10)||
'((:APP_PAGE_ID between 22705 and 22720)'||chr(10)||
'or'||chr(10)||
':APP_PAGE_ID IN (20000,20100,5000,5150,5050,5100,5250,20050,5350))',
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
s:=s||'<div class="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 4179910558064014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .001,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
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
  p_plug_display_when_condition => ':P0_OBJ is not null and'||chr(10)||
':APP_PAGE_ID not in (20100,5000,5050,5100,5250,5450,5500,5550,22805) and'||chr(10)||
':APP_PAGE_ID > 5000 and'||chr(10)||
':P0_WRITABLE = ''N''',
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
  p_id=> 4445306017641973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Region for all pages',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .002,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_03',
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
s:=s||'<a class="menuButton" href="javascript:createObject(''22200'',''ACT.POLY_EXAM'',''P22200_PARTICIPANT_VERSION,P22200_FROM_OBJ'',''&P11505_PARTICIPANT_VERSION.,&P0_OBJ.'')">Create Exam</a>';

wwv_flow_api.create_page_plug (
  p_id=> 4597330695664965 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Create Exam',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .09,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_required_role => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID = 11505 and '||chr(10)||
'osi_auth.check_for_priv(''ASSOC'',core_obj.lookup_objtype(''ACT.POLY_EXAM'')) = ''Y''',
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
s:=s||'<a class="menuButton" href="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})">VLT</a>';

wwv_flow_api.create_page_plug (
  p_id=> 6168123222152187 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'VLT',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .075,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE not in (''UNIT'', ''PERSONNEL'', ''ALL.REPORT_SPEC'', ''EMM'', ''CFUNDS_EXP'', ''CFUNDS_ADV'')',
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
s:=s||'<a class="menuButton" href="f?p=&APP_ID.:802:&SESSION.::&DEBUG.::P802_REPORT_TYPE,P802_SPEC_OBJ:&P0_OBJ_CONTEXT.,&P810_OBJ.">Run Report</a>';

wwv_flow_api.create_page_plug (
  p_id=> 7893100014867865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Run Report',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .095,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE = ''ALL.REPORT_SPEC''',
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
  p_id=> 88791007394277845 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Menu',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .01,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_06',
  p_plug_source=> s,
  p_plug_source_type=> 88768131328537196 + wwv_flow_api.g_id_offset,
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89804708962366039 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Status Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .03,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_status_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid)>0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab1('''''' ||'||chr(10)||
'                  sid |';

s:=s||'| '''''','' || '''''''' || :p0_obj || '''''''' || ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 1'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                               from t_osi_tab'||chr(10)||
'                              where obj_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                ';

s:=s||'                and tab_level = 1'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'       and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_context) = ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91428410802515584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L1',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .091,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 0',
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
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid) > 0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab1('''''' ||'||chr(10)||
'                  sid';

s:=s||' || '''''','' || '''''''' || :p0_obj || '''''''' || ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 2'||chr(10)||
'       and parent_tab = core_list.get_list_element(:P0_TABS,1)'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                               from t_osi_tab'||chr(10)||
'               ';

s:=s||'               where obj_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 2'||chr(10)||
'                                and parent_tab = core_list.get_list_element(:P0_TABS,1)'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'     and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_context) = ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        ';

s:=s||'htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91429436391570289 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L2',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .092,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 1',
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
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid) > 0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab1('''''' ||'||chr(10)||
'                  sid';

s:=s||' || '''''','' || '''''''' || :p0_obj || '''''''' || ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 3'||chr(10)||
'       and parent_tab = core_list.get_list_element(:P0_TABS,2)'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                               from t_osi_tab'||chr(10)||
'               ';

s:=s||'               where obj_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 3'||chr(10)||
'                                and parent_tab = core_list.get_list_element(:P0_TABS,2)'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_context) = ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p';

s:=s||'(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91429609510572045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L3',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .093,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 2',
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
  p_id=> 92111129885131770 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Desktop',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92112437289143401 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92225431857168384 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Investigative Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92386536451926771 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Management Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92387529309934109 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Service Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 25,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92388608316937557 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Support Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92389519051940631 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Participants',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 35,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92465821398219574 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Checklist Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .04,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_checklist_menu = ''Y'''||chr(10)||
'    and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
  p_id=> 92828711806043271 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Status Menu',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .05,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_status_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
  p_id=> 92843026931189557 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Checklist Menu',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .06,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'EXISTS',
  p_plug_display_when_condition => 'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_checklist_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
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
  p_id=> 97324716662117817 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Web Links',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .015,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_06',
  p_plug_source=> s,
  p_plug_source_type=> 97324221463090806 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 10000,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_footer=> '<div style="clear:both;"></div>',
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
  p_id=> 98895027291926832 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Participant Versions',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .08,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 98895921535934612 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'')'||chr(10)||
'and osi_participant.is_confirmed(:p0_obj) is not null'||chr(10)||
'and ('||chr(10)||
'(:APP_PAGE_ID between 30105 and 30125) or'||chr(10)||
'(:APP_PAGE_ID between 30020 and 30040) or'||chr(10)||
'(:APP_PAGE_ID = 30415 and :P0_OBJ_TYPE_CODE not in (''PART.NONINDIV.PROG'')))',
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
  p_id=> 100519624593779185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Reports',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .07,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 100519934635782109 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P0_DISPLAY_REPORTS',
  p_plug_display_when_cond2=>'Y',
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
  p_id=> 100528311733447303 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Report Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .045,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P0_DISPLAY_REPORTS',
  p_plug_display_when_cond2=>'Y',
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
  p_id=> 175627141504047911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Obj Items',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .02,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
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
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_footer=> '<script type="text/javascript">'||chr(10)||
'   if (document.getElementById(''P0_AUTHORIZED'').value == ''N''){'||chr(10)||
'        alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'        window.close();'||chr(10)||
'   }'||chr(10)||
'</script>',
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
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1132002937271910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CLIENT_S_DN_CN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>1132927757188885 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CERT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 330,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>1140331524832009 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TAGLINE_SHORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 36,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>1155812787079635 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CERT_I',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 340,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>1156020752081903 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CLIENT_I_DN_OU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 350,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>3297724392206432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_AUTHORIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>4169719506262300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_WRITABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 56,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>5674616393380192 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 78,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P0_LBL_CHANGE_STATUS7',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 13);',
  p_source_type=> 'FUNCTION',
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
  p_id=>5675201287385312 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P0_SID_CHANGE_STATUS7',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 14);',
  p_source_type=> 'FUNCTION',
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
  p_id=>7916731967601601 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 255,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 11);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7916912705605584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 12);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917230713610717 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 265,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 13);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917410412614389 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 14);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917721840617690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 275,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 15);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7917905694622410 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 280,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 16);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918120932626854 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 285,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 17);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918307903632573 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 290,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 18);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918518293635571 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT10',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 19);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>7918703879640856 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT10',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 295,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 20);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>12387231003449395 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DISPLAY_REPORTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 58,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>12390404094574065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_REPORTS_PRIV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 57,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'Declare'||chr(10)||
''||chr(10)||
'      v_count varchar(20);'||chr(10)||
'      v_objtype varchar(50);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'select count(*)'||chr(10)||
'  into v_count'||chr(10)||
'  from t_osi_report_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and obj_type member of OSI_OBJECT.GET_OBJTYPES(:P0_OBJ_TYPE_SID)'||chr(10)||
'   and active = ''Y'';'||chr(10)||
''||chr(10)||
'  v_objtype := OSI_OBJECT.GET_OBJTYPE_CODE(:P0_OBJ_TYPE_SID);'||chr(10)||
''||chr(10)||
''||chr(10)||
'if (v_count > 0) then'||chr(10)||
''||chr(10)||
'      if ( v_objtype like ''FILE.INV%'')  then'||chr(10)||
' '||chr(10)||
'         if (OSI_AUTH.CHECK_FOR_PRIV(''GEN_RPTS'', :P0_OBJ_TYPE_SID) = ''Y'') then'||chr(10)||
''||chr(10)||
'              :P0_DISPLAY_REPORTS := ''Y'';'||chr(10)||
''||chr(10)||
'        else'||chr(10)||
'              :P0_DISPLAY_REPORTS := ''N'';'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'       :P0_DISPLAY_REPORTS := ''Y'';'||chr(10)||
''||chr(10)||
'    '||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>22830502735416690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DIRTABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
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
  p_id=>88821038812330762 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TYPE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Type Sid',
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
  p_id=>89031738688681256 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>89797924536294920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_STATUS_PARAM_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Param List',
  p_source=>'OSI_util.get_status_buttons(:P0_OBJ);',
  p_source_type=> 'FUNCTION',
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
  p_id=>89819231432769946 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status1',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 1);',
  p_source_type=> 'FUNCTION',
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
  p_id=>89819736065780829 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status2',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 3);',
  p_source_type=> 'FUNCTION',
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
  p_id=>89820010570782932 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status3',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 5);',
  p_source_type=> 'FUNCTION',
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
  p_id=>89820737582790649 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status1',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 2);',
  p_source_type=> 'FUNCTION',
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
  p_id=>89821627801806826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status2',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 4);',
  p_source_type=> 'FUNCTION',
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
  p_id=>89822313387812104 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status3',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 6);',
  p_source_type=> 'FUNCTION',
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
  p_id=>91206608500198768 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 72,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status4',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 7);',
  p_source_type=> 'FUNCTION',
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
  p_id=>91207316811201212 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 74,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status5',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 9);',
  p_source_type=> 'FUNCTION',
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
  p_id=>91207526854204131 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHANGE_STATUS6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 76,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Change Status6',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 11);',
  p_source_type=> 'FUNCTION',
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
  p_id=>91208734604215739 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status4',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 8);',
  p_source_type=> 'FUNCTION',
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91209006684217224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status5',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 10);',
  p_source_type=> 'FUNCTION',
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
  p_id=>91209213264219042 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHANGE_STATUS6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89804708962366039+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Change Status6',
  p_source=>'core_list.get_list_element(:P0_STATUS_PARAM_LIST, 12);',
  p_source_type=> 'FUNCTION',
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
  p_id=>91571912883510851 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 37,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>92466137674224220 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CHECKLIST_PARAM_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Checklist Param List',
  p_source=>'OSI_util.get_checklist_buttons(:P0_OBJ);',
  p_source_type=> 'FUNCTION',
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
  p_id=>92470937375252512 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHECKLIST1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 1);',
  p_source_type=> 'FUNCTION',
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>92471128156259299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHECKLIST1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 2);',
  p_source_type=> 'FUNCTION',
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
  p_id=>92817637826729054 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_CHECKLIST2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Lbl Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 3);',
  p_source_type=> 'FUNCTION',
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>92817813715731596 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SID_CHECKLIST2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 92465821398219574+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid Checklist1',
  p_source=>'core_list.get_list_element(:P0_CHECKLIST_PARAM_LIST, 4);',
  p_source_type=> 'FUNCTION',
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96945507603721723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_CONTEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>99397625891426876 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LOC_SELECTIONS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>100031434194073317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_PARTIC_VERSION_INFO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 98895027291926832+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_version_label(:p0_obj_context)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_id=>100456419971725899 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DIRTY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>100536318967196882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_REPORT_PARAM_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_util.get_report_links(:p0_obj)',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100542336001381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 205,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 1);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100542517203381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 2);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100542712948381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 215,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 3);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100542910993381584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 4);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543129107381585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 225,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 5);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543334958381585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 6);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543523811381585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 235,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 7);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543723900381589 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 8);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100543910595381590 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LBL_REPORT5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 245,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 9);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>100544133290381590 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_URL_REPORT5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 100528311733447303+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_list.get_list_element(:P0_REPORT_PARAM_LIST, 10);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>175627449469050216 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Type Code',
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
  p_id=>175627653625051482 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Sid',
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
  p_id=>175628448739097322 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_TABS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Tabs',
  p_source=>'declare'||chr(10)||
'     v_result boolean;'||chr(10)||
'     v_tabs varchar2(4000) := null;'||chr(10)||
'     '||chr(10)||
'     procedure traverse_tab_parents(p_tab varchar2) is'||chr(10)||
'         v_parent t_osi_tab.parent_tab%type;'||chr(10)||
'     begin'||chr(10)||
'          v_result := core_list.add_item_to_list_front(p_tab, v_tabs);'||chr(10)||
'          '||chr(10)||
'          select parent_tab'||chr(10)||
'           into v_parent'||chr(10)||
'           from t_osi_tab'||chr(10)||
'          where sid = p_tab;'||chr(10)||
'          '||chr(10)||
'          if v_parent is not null then'||chr(10)||
'              traverse_tab_parents(v_parent);'||chr(10)||
'          end if;'||chr(10)||
'     end;'||chr(10)||
'begin'||chr(10)||
'    if :REQUEST = ''OPEN'' then'||chr(10)||
'       for i in (select sid'||chr(10)||
'                from t_osi_tab'||chr(10)||
'               where page_num = :APP_PAGE_ID'||chr(10)||
'                 and obj_type member of '||chr(10)||
'                        osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'               order by tab_level desc) loop'||chr(10)||
'          traverse_tab_parents(i.sid);'||chr(10)||
'          exit;        '||chr(10)||
'       end loop;'||chr(10)||
'       return v_tabs;'||chr(10)||
'    else'||chr(10)||
'         return :P0_TABS;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 0
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
--   Date and Time:   10:21 Wednesday June 8, 2011
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

PROMPT ...Remove page 30000
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30000);
 
end;
/

 
--application/pages/page_30000
prompt  ...PAGE 30000: Individual Participant (Search/Create)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'  if("&REQUEST." == "CREATE_RETURN" || "&REQUEST." == "CREATE_UNK_RETURN"){'||chr(10)||
'    passBack("&P30000_SEL_PARTICIPANT.");'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'function passBack(pSid){'||chr(10)||
'  opener.document.getElementById("&P30000_RETURN_ITEM.").value = pSid;'||chr(10)||
'  opener.doSubmit("&P30000_RETURN_ITEM.");'||chr(10)||
'  window.close();'||chr(10)||
'}'||chr(10)||
'function useSelected(pMessage){'||chr(10)||
'  if(confirm(pMessage)){'||chr(10)||
'    passBack("&P30000_SEL_PAR';

ph:=ph||'TICIPANT.");'||chr(10)||
'  }'||chr(10)||
'}'||chr(10)||
'/*'||chr(10)||
' * This function is available to prompt the user. It was being used by button'||chr(10)||
' * #16 but it isn''t right now.'||chr(10)||
' */'||chr(10)||
'function createInstance(pMessage, pRequest){'||chr(10)||
'  if(confirm(pMessage)){'||chr(10)||
'    doSubmit(pRequest);'||chr(10)||
'  }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'if (''&P30000_NEW_PARTIC_SID.''!=''''){'||chr(10)||
'newWindow({page:30005, '||chr(10)||
'                    clear_cache:30005, '||chr(10)||
'                    name:''&P30000_NEW_PARTIC_SID.'', item_names:''';

ph:=ph||'P0_OBJ'', '||chr(10)||
'                    item_values:''&P30000_NEW_PARTIC_SID.'', '||chr(10)||
'                    request:''OPEN''});'||chr(10)||
''||chr(10)||
'close();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30000,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Individual Participant (Search/Create)',
  p_step_title=> 'Search/Create Participant',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="JavaScript">'||chr(10)||
''||chr(10)||
'  if("&P30000_ACTION." == "DEERS_UNCONFIRM")'||chr(10)||
'    {'||chr(10)||
'     if ("&P30000_LAST_NAME." == "")'||chr(10)||
'       {'||chr(10)||
'        var r=false;'||chr(10)||
'        alert("Last Name is Required.");'||chr(10)||
'       }'||chr(10)||
'     else'||chr(10)||
'       var r=confirm("&P30000_DEERS_MSG.");'||chr(10)||
''||chr(10)||
'     if (r==true)'||chr(10)||
'       doSubmit("CREATE");'||chr(10)||
'    }'||chr(10)||
'  '||chr(10)||
'  if("&P30000_ACTION." == "DEERS_CREATED")'||chr(10)||
'    {'||chr(10)||
'     alert("&P30000_DEERS_MSG.");'||chr(10)||
'     doSubmit("DEERS_CREATED");'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
'  if("&P30000_ACTION." == ''DEERS_ERROR'')'||chr(10)||
'    alert("&P30000_DEERS_MSG.");'||chr(10)||
''||chr(10)||
'  if("&P30000_ACTION." == ''DEERS_MSG'')'||chr(10)||
'    alert("&P30000_DEERS_MSG.");'||chr(10)||
'  '||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110608102008',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '22-FEB-2011 J.FARIS WCHG0000371 - Participants Relationships Import, updated Import Legacy Participant process.'||chr(10)||
''||chr(10)||
'12-Apr-2011 Tim Ward CR#3795 - Added Check Last Name null validation.  '||chr(10)||
'                               Last Name is required to create a Participant.'||chr(10)||
''||chr(10)||
'12-Apr-2011 Tim Ward CR#3489 - Changed Footer Javascript to confirm OK/CANCEL '||chr(10)||
'                     CR#3764   if the user wants to create the unconfirmed '||chr(10)||
'                               participant.'||chr(10)||
''||chr(10)||
'08-Jun-2011 Tim Ward CR#3597 - Foreign ID Number Saves and SSN when '||chr(10)||
'                               Creating Participant.  Changed create_instance'||chr(10)||
'                               process to pass number type to'||chr(10)||
'                               osi_participant.create_instance function.'||chr(10)||
''||chr(10)||
'08-Jun-2011 - Tim Ward CR#3876 - Foreign National Privileges that are missing'||chr(10)||
'                                 Added Page 30101 branch.');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30000,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30000,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select person_version,'||chr(10)||
'       decode(person_version, :P30000_SEL_LEGACY_PART, ''Y'', ''N'') as "Current",'||chr(10)||
'       Names as "Names",'||chr(10)||
'       score as "Matching Likelihood",'||chr(10)||
'       details as "Reasons for Match"'||chr(10)||
'  from v_osi_migration_partic_hit'||chr(10)||
' where user_session = :P30000_LEGACY_PARTIC_SESSION';

wwv_flow_api.create_report_region (
  p_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_name=> 'Legacy I2MS Participants',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 50,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P30000_CONTINUE = ''Y''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No Legacy I2MS Participant Matches Found',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 12141531488721506 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PERSON_VERSION',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp.',
  p_column_link=>'javascript:doSubmit(''LVIEW_#PERSON_VERSION#'')',
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
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 12136412470592992 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 5,
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
  p_id=> 12200804643144285 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Names',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Names',
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
  p_id=> 12130003009222854 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Matching Likelihood',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Matching Likelihood',
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
  p_id=> 12130128891222854 + wwv_flow_api.g_id_offset,
  p_region_id=> 12129308399222823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Reasons for Match',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Reasons For Match',
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 12140418067698773 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Details of Selected Legacy Participant',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 60,
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
  p_plug_display_when_condition => ':P30000_SEL_LEGACY_PART IS NOT NULL',
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
  p_id=> 89341136016602021 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Search/Create Parameters',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
  p_id=> 89345512226620324 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
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
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'select participant,'||chr(10)||
'       decode(participant, :P30000_SEL_PARTICIPANT, ''Y'', ''N'') as "Current",'||chr(10)||
'       last_name as "Last Name",'||chr(10)||
'       first_name as "First Name",'||chr(10)||
'       middle_name as "Middle Name",'||chr(10)||
'       score as "Matching Likelihood",'||chr(10)||
'       info as "Reasons for Match"'||chr(10)||
'  from v_osi_partic_search_result'||chr(10)||
' where session_id = :p30000_session';

wwv_flow_api.create_report_region (
  p_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_name=> 'Existing I2MS Participants',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P30000_CONTINUE = ''Y''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '100000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No matching participants found.',
  p_query_num_rows_type=> 'ROW_RANGES_WITH_LINKS',
  p_query_row_count_max=> '100000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5589426093214521 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PARTICIPANT',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''VIEW_#PARTICIPANT#'')',
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
  p_id=> 91173814978667756 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 7,
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
  p_id=> 91170916835547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Last Name',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Last Name',
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
  p_id=> 91171013061547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'First Name',
  p_column_display_sequence=> 3,
  p_column_heading=> 'First Name',
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
  p_id=> 91171138238547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Middle Name',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Middle Name',
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
  p_id=> 91171238301547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Matching Likelihood',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Matching Likelihood',
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
  p_id=> 91171323011547740 + wwv_flow_api.g_id_offset,
  p_region_id=> 89364113657999253 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Reasons for Match',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Reasons For Match',
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
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 90599109543441349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30000,
  p_plug_name=> 'Details of Selected Participant',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P30000_SEL_PARTICIPANT IS NOT NULL',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89405908818791303 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 10,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'SEARCH',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Search',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91222636952661168 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 100,
  p_button_plug_id => 89364113657999253+wwv_flow_api.g_id_offset,
  p_button_name    => 'OPEN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Open Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:newWindow({name:''PARTICIPANT&P30000_SEL_PARTICIPANT.'',              page:30005,              clear_cache:30005,              item_names:''P0_OBJ'',              item_values:''&P30000_SEL_PARTICIPANT.'',              request:''OPEN''});',
  p_button_condition=> 'P30000_SEL_PARTICIPANT',
  p_button_condition_type=> 'ITEM_IS_NOT_NULL',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91222813823661170 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 105,
  p_button_plug_id => 89364113657999253+wwv_flow_api.g_id_offset,
  p_button_name    => 'USE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Use Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:useSelected(''Are you sure you want to associate this participant to another object?'');',
  p_button_condition=> ':P30000_SEL_PARTICIPANT IS NOT NULL AND'||chr(10)||
':P30000_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13050432249930481 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 115,
  p_button_plug_id => 12129308399222823+wwv_flow_api.g_id_offset,
  p_button_name    => 'IMPORT_SELECTED',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Import Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_SEL_LEGACY_PART is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89341331911602023 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 15,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE IS NULL AND :P30000_CONTINUE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91267032597639204 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 16,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE = ''FROM_OBJ'' AND :P30000_CONTINUE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_comment=>'javascript:createInstance(''This participant will be created UNCONFIRMED and associated to object &P0_OBJ_TAGLINE.. Do you want to continue?'', ''CREATE_RETURN'');',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89418530138686924 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 20,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_UNK',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Unknown Participant',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91329434025836453 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 21,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_UNK_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Unknown Participant',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30000_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89341514582602023 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30000,
  p_button_sequence=> 25,
  p_button_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5917911033397014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30101:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> .5,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST=''CREATE'' and osi_auth.check_access(:P0_OBJ)=''N'';',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2011 13:00 by TWARD');
 
wwv_flow_api.create_page_branch(
  p_id=>89341722159602023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30005:&SESSION.:OPEN:&DEBUG.:30000::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 1,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST IN (''CREATE'', ''CREATE_UNK'', ''DEERS_CREATED'')',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>89406229948791306 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30000:&SESSION.:&REQUEST.:&DEBUG.::P30000_CONTINUE,P30000_SEL_PARTICIPANT:Y,',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>89405908818791303+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>89345334474607882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_branch_action=> 'f?p=&APP_ID.:30000:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 14:31 by RECHER');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3670711603404937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DEERS_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>3670904055404950 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DEERS_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>3809010655211925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
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
  p_id=>5612126859820320 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 204,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SESSION',
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
  p_id=>12128015091082846 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LEGACY_PARTIC_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_LEGACY_PARTIC_SESSION',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>12135209091573150 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_LEGACY_PART',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 12129308399222823+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEL_LEGACY_PART',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>12140730534702298 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_LEGACY_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 12140418067698773+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_legacy_part_details(:P30000_SEL_LEGACY_PART);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'width=100%',
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
  p_id=>13051211518952871 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NEW_PARTIC_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 12140418067698773+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_NEW_PARTIC_SID',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>89341938654602024 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_PARTICIPANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEL_PARTICIPANT',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
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
  p_id=>89367113059055907 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 205,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_pre_element_text=>'<h1>',
  p_post_element_text=>'</h1><tr><td width="155" rowspan="3" colspan="3">&nbsp;</td>',
  p_source=>'The first three letters of last name and Social Security/Foreign ID # are required to search DEERS.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 6,
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
  p_id=>89367333622071267 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LAST_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Last Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 100,
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
  p_id=>89367517823076190 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_FIRST_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 225,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'First Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
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
  p_id=>89367909989083378 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 5,
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
  p_id=>89368629167098340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DOB',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Birthdate',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'class="datepickernew"',
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
  p_id=>89368936224109821 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sex',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P30000_SEX_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Sex -',
  p_lov_null_value=> '',
  p_cSize=> 10,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>89405434052770254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_CONTINUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_CONTINUE=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>90599516946452935 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEL_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 400,
  p_item_plug_id => 90599109543441349+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_PARTICIPANT.GET_DETAILS(:P30000_SEL_PARTICIPANT);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'width=100%',
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
  p_id=>91259033619437731 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_RETURN_ITEM=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91262816181199224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_MODE=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93263632644079337 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 235,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_partic_number_type'||chr(10)||
'   where active = ''Y'''||chr(10)||
'      or sid = :p30000_number_type'||chr(10)||
'order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 6,
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
  p_id=>95045621212372757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 201,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'dibrs_reference.get_lov(''SEX'',:p30000_sex);',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95545015495471757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SSN_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 203,
  p_item_plug_id => 89341136016602021+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select sid'||chr(10)||
'  from t_osi_partic_number_type'||chr(10)||
' where code = ''SSN''',
  p_source_type=> 'QUERY',
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
  p_id=>96758123524419584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_FNAME_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_FNAME_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>96758315968419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_LNAME_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_LNAME_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>96758522773419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_NUMBER_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_NUMBER_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>96758717427419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_DOB_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_DOB_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
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
  p_id=>96758908934419585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30000,
  p_name=>'P30000_SEX_OLD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 89345512226620324+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30000_SEX_OLD=',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95544834972458520 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Numeric SSN',
  p_validation_sequence=> 1,
  p_validation => 'P30000_NUMBER_VALUE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => 'SSN must be numeric.',
  p_validation_condition=> ':request = ''SEARCH'' and :p30000_number_type = :p30000_ssn_type',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 1175616794373923 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'DOB is valid date',
  p_validation_sequence=> 2,
  p_validation => 'P30000_DOB',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'DOB must be a valid date.',
  p_validation_condition=> ':request = ''SEARCH''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89368629167098340 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89416938619651515 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Not null search terms',
  p_validation_sequence=> 5,
  p_validation => ':P30000_LAST_NAME IS NOT NULL OR '||chr(10)||
':P30000_FIRST_NAME IS NOT NULL OR'||chr(10)||
':P30000_NUMBER_VALUE IS NOT NULL',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'Must supply a first name, last name or SSN number.',
  p_validation_condition=> 'SEARCH',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95801423087059968 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'SSN is numeric',
  p_validation_sequence=> 10,
  p_validation => 'P30000_NUMBER_VALUE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => 'SSN must be numeric.',
  p_validation_condition=> ':P30000_NUMBER_TYPE = :P30000_SSN_TYPE AND'||chr(10)||
':REQUEST = ''CREATE'' OR'||chr(10)||
':REQUEST = ''CREATE_RETURN''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95801713306075979 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'SSN is 9 digits',
  p_validation_sequence=> 15,
  p_validation => 'begin'||chr(10)||
'  if(:p30000_number_type = :p30000_ssn_type)then'||chr(10)||
'      if(   length(:p30000_number_value) = 9'||chr(10)||
'         or :p30000_number_value is null)then'||chr(10)||
'        return true;'||chr(10)||
'      else'||chr(10)||
'        return false;'||chr(10)||
'      end if;'||chr(10)||
'  else'||chr(10)||
'    return true;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'SSN must be nine digits.',
  p_validation_condition=> 'CREATE,CREATE_RETURN,SEARCH',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 89367909989083378 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96773724440836168 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check last name',
  p_validation_sequence=> 20,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_lname_old is not null) then'||chr(10)||
'        if (:p30000_lname_old = :p30000_last_name) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_lname_old is null and :p30000_last_name is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The last name has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96806310073287789 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check first name',
  p_validation_sequence=> 21,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_fname_old is not null) then'||chr(10)||
'        if (:p30000_fname_old = :p30000_first_name) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_fname_old is null and :p30000_first_name is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The first name has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808013068354920 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check number',
  p_validation_sequence=> 22,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_number_old is not null) then'||chr(10)||
'        if (:p30000_number_old = :p30000_number_value) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_number_old is null and :p30000_number_value is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The number value has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808408351363045 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check DOB',
  p_validation_sequence=> 23,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_dob_old is not null) then'||chr(10)||
'        if (:p30000_dob_old = :p30000_dob) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_dob_old is null and :p30000_dob is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The birthdate has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96808625320367978 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check sex',
  p_validation_sequence=> 24,
  p_validation => 'begin'||chr(10)||
'    if (:p30000_sex_old is not null) then'||chr(10)||
'        if (:p30000_sex_old = :p30000_sex) then'||chr(10)||
'            return true;'||chr(10)||
'        else'||chr(10)||
'            return false;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(:p30000_sex_old is null and :p30000_sex is not null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The sex value has changed. Please search again before attempting to create a participant.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 5275827908497509 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_validation_name => 'Check Last Name null',
  p_validation_sequence=> 34,
  p_validation => 'begin'||chr(10)||
'    if(:p30000_last_name is null) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'The last name is a required field.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
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
''||chr(10)||
'  :P30000_SEL_LEGACY_PART := null;'||chr(10)||
''||chr(10)||
'  osi_participant.check_for_matches(:p30000_number_value,'||chr(10)||
'                                    :p30000_number_type,'||chr(10)||
'                                    :p30000_dob,'||chr(10)||
'                                    :p30000_last_name,'||chr(10)||
'                                    :p30000_first_name,'||chr(10)||
'                                    :p30000_sex,'||chr(10)||
'                                 ';

p:=p||'   :p30000_session,'||chr(10)||
'                                    :p30000_legacy_partic_session,'||chr(10)||
'                                    :p30000_deers_result);'||chr(10)||
''||chr(10)||
'  :debug := ''deers result: '' || :p30000_deers_result;'||chr(10)||
''||chr(10)||
'  --- If this is true then a DEERS query was made. ---'||chr(10)||
'  if (:p30000_session is null) then'||chr(10)||
''||chr(10)||
'     --- If this is true then a DEERS error occured. ---'||chr(10)||
'     if (:p30000_deers_result is null) then'||chr(10)||
''||chr(10)||
'    ';

p:=p||'   :p30000_deers_msg := ltrim(osi_deers.get_import_message, ''MSG '') || ''\nUnconfirmed participant will be created.'';'||chr(10)||
'       :p30000_action := ''DEERS_UNCONFIRM'';'||chr(10)||
''||chr(10)||
'     elsif(instr(:p30000_deers_result, ''ERROR'') > 0) then'||chr(10)||
''||chr(10)||
'         :p30000_deers_msg := ltrim(:p30000_deers_result, ''ERROR '');'||chr(10)||
'         :p30000_action := ''DEERS_ERROR'';'||chr(10)||
' '||chr(10)||
'    elsif(instr(:p30000_deers_result, ''MSG'') > 0) then'||chr(10)||
''||chr(10)||
'         :';

p:=p||'p30000_deers_msg := ltrim(:p30000_deers_result, ''MSG '');'||chr(10)||
'         :p30000_action := ''DEERS_MSG'';'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
''||chr(10)||
'      --- A new participant was created and we have a version sid. ---'||chr(10)||
'      :p0_obj := osi_participant.get_participant(:p30000_deers_result);'||chr(10)||
'      :p30000_deers_msg := ''DEERS match found. Confirmed participant was created.'';'||chr(10)||
'      :p30000_action := ''DEERS_CREATED'';'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'';

p:=p||''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5578311932812948 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check for matches',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SEARCH',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'begin'||chr(10)||
'    :P30000_SEL_LEGACY_PART := null;'||chr(10)||
''||chr(10)||
'    osi_participant.check_for_matches(:p30000_number_value,'||chr(10)||
'                                      :p30000_number_type,'||chr(10)||
'                                      :p30000_dob,'||chr(10)||
'                                      :p30000_last_name,'||chr(10)||
'                                      :p30000_first_name,'||chr(10)||
'                                      :p30000_sex,'||chr(10)||
'                                      :p30000_session,'||chr(10)||
'                                      :p30000_legacy_partic_session,'||chr(10)||
'                                      :p30000_deers_result);'||chr(10)||
'    :debug := ''deers result: '' || :p30000_deers_result;'||chr(10)||
''||chr(10)||
'    -- If this is true then a DEERS query was made.'||chr(10)||
'    if (:p30000_session is null) then'||chr(10)||
'        -- If this is true then a DEERS error occured.'||chr(10)||
'        if (:p30000_deers_result is null) then'||chr(10)||
'            :p30000_deers_msg :='||chr(10)||
'                ltrim(osi_deers.get_import_message, ''MSG '')'||chr(10)||
'                || ''\nUnconfirmed participant will be created.'';'||chr(10)||
'            :p30000_action := ''DEERS_UNCONFIRM'';'||chr(10)||
'        elsif(instr(:p30000_deers_result, ''ERROR'') > 0) then'||chr(10)||
'            :p30000_deers_msg := ltrim(:p30000_deers_result, ''ERROR '');'||chr(10)||
'            :p30000_action := ''DEERS_ERROR'';'||chr(10)||
'        elsif(instr(:p30000_deers_result, ''MSG'') > 0) then'||chr(10)||
'            :p30000_deers_msg := ltrim(:p30000_deers_result, ''MSG '');'||chr(10)||
'            :p30000_action := ''DEERS_MSG'';'||chr(10)||
'        else'||chr(10)||
'            -- A new participant was created and we have a version sid.'||chr(10)||
'            :p0_obj := osi_participant.get_participant(:p30000_deers_result);'||chr(10)||
'            :p30000_deers_msg := ''DEERS match found. Confirmed participant was created.'';'||chr(10)||
'            :p30000_action := ''DEERS_CREATED'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;');
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
'    v_sid varchar2(1000);'||chr(10)||
'begin'||chr(10)||
'    if (:request like ''CREATE_UNK%'') then'||chr(10)||
'        v_sid :='||chr(10)||
'            osi_participant.create_instance();'||chr(10)||
''||chr(10)||
'        if (:request = ''CREATE_UNK_RETURN'') then'||chr(10)||
'            :p30000_sel_participant := v_sid;'||chr(10)||
'        else'||chr(10)||
'            :p0_obj := v_sid;'||chr(10)||
'        end if;'||chr(10)||
'    else'||chr(10)||
'        v_sid :='||chr(10)||
'            osi_participant.create_instance(:p30000_last_name,'||chr(10)||
'          ';

p:=p||'                                  :p30000_first_name,'||chr(10)||
'                                            :p30000_number_value,'||chr(10)||
'                                            :p30000_dob,'||chr(10)||
'                                            :p30000_sex,'||chr(10)||
'                                            ''N'','||chr(10)||
'                                            :p30000_number_type);'||chr(10)||
'        if (:request = ''CREATE_RETURN'') then'||chr(10)||
'      ';

p:=p||'      :p30000_sel_participant := v_sid;'||chr(10)||
'        else'||chr(10)||
'            :p0_obj := v_sid;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90630618723532185 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create instance',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''CREATE%''',
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
p:=p||'delete t_osi_partic_search_result where session_id = :p30000_session;';

wwv_flow_api.create_page_process(
  p_id     => 5620119062130325 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear search results',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':request like ''%CREATE%''',
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
p:=p||':P30000_SEL_PARTICIPANT := SUBSTR(:REQUEST, 6);';

wwv_flow_api.create_page_process(
  p_id     => 91172133539588020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select participant',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''VIEW_%'';',
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
p:=p||':P30000_SEL_LEGACY_PART := SUBSTR(:REQUEST, 7);';

wwv_flow_api.create_page_process(
  p_id     => 12135319134576042 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Legacy participant',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''LVIEW_%'';',
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
'my_exception exception;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     :P30000_NEW_PARTIC_SID := osi_participant.import_legacy_participant(:P30000_SEL_LEGACY_PART);'||chr(10)||
'     if :P30000_NEW_PARTIC_SID like ''Error:%'' then'||chr(10)||
'        raise my_exception;'||chr(10)||
'     end if;'||chr(10)||
'exception'||chr(10)||
'    when my_exception then'||chr(10)||
'         raise;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13051332642958923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Import Legacy Participant',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Error importing legacy participant',
  p_process_when=>':REQUEST = ''IMPORT_SELECTED'';',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'Legacy Participant Imported',
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
'    :p30000_lname_old := :p30000_last_name;'||chr(10)||
'    :p30000_fname_old := :p30000_first_name;'||chr(10)||
'    :p30000_number_old := :p30000_number_value;'||chr(10)||
'    :p30000_dob_old := :p30000_dob;'||chr(10)||
'    :p30000_sex_old := :p30000_sex;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 96760115391455048 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30000,
  p_process_sequence=> 15,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Save search terms',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SEARCH',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30000
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
--   Date and Time:   10:21 Wednesday June 8, 2011
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

PROMPT ...Remove page 30100
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30100);
 
end;
/

 
--application/pages/page_30100
prompt  ...PAGE 30100: Non-Individual Participant (Create)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'if("&REQUEST." == "CREATE_RETURN"){'||chr(10)||
'  passBack("&P30100_SID.");'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function passBack(pSid){'||chr(10)||
'  opener.document.getElementById("&P30100_RETURN_ITEM.").value = pSid;'||chr(10)||
'  opener.doSubmit("&P30100_RETURN_ITEM.");'||chr(10)||
'  close();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30100,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Non-Individual Participant (Create)',
  p_step_title=> '&P30100_OBJ_TYPE_DESC. (Create)',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110608101635',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Added Page 30101 branch.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30100,p_text=>ph);
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
  p_id=> 91408538636002232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30100,
  p_plug_name=> '&P30100_OBJ_TYPE_DESC.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 91444131774761220 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30100,
  p_button_sequence=> 10,
  p_button_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30100_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 96165826881998749 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30100,
  p_button_sequence=> 15,
  p_button_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_RETURN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30100_MODE = ''FROM_OBJ''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91444327459761224 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30100,
  p_button_sequence=> 20,
  p_button_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5895629669872530 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_branch_action=> 'f?p=&APP_ID.:30101:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST=''CREATE'' and osi_auth.check_access(:P0_OBJ)=''N'';',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2011 11:33 by TWARD'||chr(10)||
'');
 
wwv_flow_api.create_page_branch(
  p_id=>91445512296774509 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_branch_action=> 'f?p=&APP_ID.:30106:&SESSION.:OPEN:&DEBUG.:30106::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_branch_condition=> 'CREATE',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2009 13:02 by THOMAS');
 
wwv_flow_api.create_page_branch(
  p_id=>91442835883734051 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_branch_action=> 'f?p=&APP_ID.:30100:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-JUN-2009 12:55 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91411425092045681 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_SUB_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sub Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'STATIC2:&P30100_TYPE_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Sub Type -',
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
  p_display_when=>':P0_OBJ_TYPE_CODE <> ''PART.NONINDIV.PROG''',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>91411612064051371 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P30100_NAME_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>91412231504085401 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_NAME_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Name Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   t.description, t.sid'||chr(10)||
'    from t_osi_partic_name_type t, t_osi_partic_name_type_map m'||chr(10)||
'   where m.participant_type = :P30100_SUB_TYPE and m.active = ''Y'''||chr(10)||
'     and m.name_type = t.sid'||chr(10)||
'order by m.seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Name Type -',
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
  p_id=>94992924508361224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_TYPE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_reference.get_lov(:p0_obj_type_code, :p30100_sub_type);',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95552735524073729 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_OBJ_TYPE_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
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
  p_id=>95806307999566564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_NAME_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'if(:p0_obj_type_code = ''PART.NONINDIV.PROG'')then'||chr(10)||
'  return ''Title'';'||chr(10)||
'else'||chr(10)||
'  return ''Name'';'||chr(10)||
'end if;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_id=>95879831526890207 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_ACRONYM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Acronym',
  p_source=>'ACRONYM',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96159929522639918 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
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
  p_id=>96160135409641667 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_RETURN_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
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
  p_id=>96166714808023692 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_name=>'P30100_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 91408538636002232+wwv_flow_api.g_id_offset,
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
  p_id=> 95553125612080268 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_computation_sequence => 1,
  p_computation_item=> 'P30100_OBJ_TYPE_DESC',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_object.get_objtype_desc(:p0_obj_type_code);',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 95553636834168731 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30100,
  p_computation_sequence => 5,
  p_computation_item=> 'P30100_SUB_TYPE',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_reference.lookup_ref_sid(''PART.NONINDIV.PROG'', ''PP'');',
  p_compute_when => ':P0_OBJ_TYPE_CODE = ''PART.NONINDIV.PROG''',
  p_compute_when_type=>'PLSQL_EXPRESSION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 91465911660228509 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30100,
  p_validation_name => 'P30100_SUB_TYPE Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P30100_SUB_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Sub type must be specified.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 91411425092045681 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 01-JUN-2009 14:18');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 91466135487228509 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30100,
  p_validation_name => 'P30100_NAME_TYPE Not Null',
  p_validation_sequence=> 2,
  p_validation => 'P30100_NAME_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Name type must be specified.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 91412231504085401 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 01-JUN-2009 14:18');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 91466331974228509 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30100,
  p_validation_name => 'P30100_NAME Not Null',
  p_validation_sequence=> 3,
  p_validation => 'P30100_NAME',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Name must be specified.',
  p_validation_condition=> 'CREATE,CREATE_RETURN',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 91411612064051371 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 01-JUN-2009 14:18');
 
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
'  :p0_obj := osi_participant.create_nonindiv_instance(:p0_obj_type_sid, :p30100_sub_type, :p30100_name_type, :p30100_name, :p30100_acronym);'||chr(10)||
''||chr(10)||
'  :p30100_sid := :p0_obj;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 91476826383270645 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30100,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Run Create_Instance function',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,CREATE_RETURN',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30100
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
--   Date and Time:   10:21 Wednesday June 8, 2011
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

PROMPT ...Remove page 30101
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30101);
 
end;
/

 
--application/pages/page_30101
prompt  ...PAGE 30101: Participant Created
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 30101,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Participant Created',
  p_step_title=> 'Participant Created',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110608101812',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Created.');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'Your participant has been created and should now appear in your recent participants desktop view.'||chr(10)||
'<BR>'||chr(10)||
'<p align=center>'||chr(10)||
'<a class="htmlButton" style="float:none;" href="javascript:window.close();" onclick="mySubmit(''Close'');">Close</a>'||chr(10)||
'</p>'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 5905120075002238 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30101,
  p_plug_name=> 'Participant Created',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30101
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