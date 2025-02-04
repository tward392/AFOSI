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
--   Date and Time:   10:55 Wednesday March 2, 2011
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

PROMPT ...Remove page 800
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>800);
 
end;
/

 
--application/pages/page_00800
prompt  ...PAGE 800: Autorun Reports
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 800,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Autorun Reports',
  p_step_title=> 'Reports',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110302105508',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '02-Mar-2011 TJW - CR#3705 Changed Run Report to get Voucher # for Expense Cover Sheet Reports');
 
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
  p_id=> 2178915652979167 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 800,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
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
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>2205022663706842 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 800,
  p_branch_action=> 'f?p=&APP_ID.:800:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 30-NOV-2009 12:49 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2184105982903746 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 800,
  p_name=>'P800_REPORT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 2178915652979167+wwv_flow_api.g_id_offset,
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
  p_id=>9060519375372175 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 800,
  p_name=>'P800_PARAM_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 2178915652979167+wwv_flow_api.g_id_offset,
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_content       clob;'||chr(10)||
'    v_exe           varchar2(250);'||chr(10)||
'    v_function      varchar2(200);'||chr(10)||
'    v_description   varchar2(100);'||chr(10)||
'    v_id            varchar2(100);'||chr(10)||
'    v_extension     t_osi_report_mime_type.file_extension%type;'||chr(10)||
'    v_mime          t_osi_report_mime_type.mime_type%type;'||chr(10)||
'    v_file_name     varchar2(100)                                := ''No_File_ID_Given'';'||chr(10)||
'    v_dispositi';

p:=p||'on   varchar2(10)                                 := ''ATTACHMENT'';'||chr(10)||
'    v_error         exception;'||chr(10)||
'begin'||chr(10)||
'    select rt.package_function, mt.mime_type, mt.file_extension, rt.description'||chr(10)||
'      into v_function, v_mime, v_extension, v_description'||chr(10)||
'      from t_osi_report_type rt, t_osi_report_mime_type mt'||chr(10)||
'     where rt.sid = :p800_report_type and rt.mime_type = mt.sid(+);'||chr(10)||
''||chr(10)||
'    if (:auditing = ''ON'') then';

p:=p||''||chr(10)||
'        log_info(''Report:'' || :p0_obj || '' - '' || v_description);'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    -- Look for a File or Activity ID first.'||chr(10)||
'    for x in (select full_id'||chr(10)||
'                from t_osi_file'||chr(10)||
'               where sid = :p0_obj)'||chr(10)||
'    loop'||chr(10)||
'        v_id := x.full_id;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    if (v_id is null) then'||chr(10)||
'        for x in (select id'||chr(10)||
'                    from t_osi_activity'||chr(10)||
'                   where sid = :';

p:=p||'p0_obj)'||chr(10)||
'        loop'||chr(10)||
'            v_id := x.id;'||chr(10)||
'        end loop;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (v_id is null) then'||chr(10)||
'        for x in (select voucher_no'||chr(10)||
'                    from t_cfunds_expense_v3'||chr(10)||
'                   where sid = :p0_obj)'||chr(10)||
'        loop'||chr(10)||
'            v_id := x.voucher_no;'||chr(10)||
'        end loop;'||chr(10)||
'    end if;'||chr(10)||
'    '||chr(10)||
'    if (v_id is not null) then'||chr(10)||
'        v_file_name := v_id;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    v_file_name := ';

p:=p||'v_file_name || to_char(sysdate, ''ddMonyyhhmiss'') || v_extension;'||chr(10)||
''||chr(10)||
'    if (v_function is null) then'||chr(10)||
'        raise v_error;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if :p800_param_2 is null then'||chr(10)||
'        v_exe := ''begin :RTN := '' || v_function || ''(:1); end;'';'||chr(10)||
''||chr(10)||
'        execute immediate v_exe'||chr(10)||
'                    using out v_content, in :p0_obj;'||chr(10)||
'    else'||chr(10)||
'        v_exe := ''begin :RTN := '' || v_function || ''(:1,:2); end;'';'||chr(10)||
''||chr(10)||
'  ';

p:=p||'      execute immediate v_exe'||chr(10)||
'                    using out v_content, in :p0_obj, :p800_param_2;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    core_util.deliver_blob(v_content, v_mime, v_disposition, v_file_name, false, sysdate);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 100568928343776881 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 800,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Run report',
  p_process_sql_clob => p, 
  p_process_error_message=> 'No report function defined.',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 800
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
