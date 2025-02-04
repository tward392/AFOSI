update t_osi_notification_event_type set description=replace(description,'CFunds','EFunds')
  where description like '%CFunds%';
commit;


update t_osi_auth_priv set description=replace(description,'CFunds','EFunds') 
  where description like '%CFunds%';
commit;
update t_osi_auth_priv set description=replace(description,'C-Funds','E-Funds') 
  where description like '%C-Funds%';
commit;
update t_osi_auth_priv set description=replace(description,'C- Funds','E-Funds') 
  where description like '%C- Funds%';
commit;
update t_osi_auth_priv set description=replace(description,'CFEXP','EFEXP') 
  where description like '%CFEXP%';
commit;
update t_osi_auth_priv set description=replace(description,'CFLIM','EFLIM') 
  where description like '%CFLIM%';
commit;
update t_osi_auth_priv set description=replace(description,'CFADV','EFADV') 
  where description like '%CFADV%';
commit;
update t_osi_auth_priv set description=replace(description,'CFXFR','EFXFR') 
  where description like '%CFXFR%';
commit;
update t_osi_auth_priv set description=replace(description,'CFMFR','EFMFR') 
  where description like '%CFMFR%';
commit;
  
update t_osi_auth_role set description=replace(description,'CFunds','EFunds') 
  where description like '%CFunds%';
commit;
update t_osi_auth_role set description=replace(description,'C-Funds','E-Funds') 
  where description like '%C-Funds%';
commit;

update t_osi_auth_role set complete_desc=replace(complete_desc,'CFunds','EFunds') 
  where complete_desc like '%CFunds%';
commit;
update t_osi_auth_role set complete_desc=replace(complete_desc,'C-Funds','E-Funds') 
  where complete_desc like '%C-Funds%';
commit;
update t_osi_auth_role set complete_desc=replace(complete_desc,'CFUND','EFUND') 
  where complete_desc like '%CFUND%';
commit;
update t_osi_auth_role set complete_desc=replace(complete_desc,'CFCUST','EFCUST') 
  where complete_desc like '%CFCUST%';
commit;


update t_osi_auth_action_type set description=replace(description,'CFunds','EFunds') 
  where description like '%CFunds%';
commit;
update t_osi_auth_action_type set description=replace(description,'C-Funds','E-Funds') 
  where description like '%C-Funds%';
commit;
update t_osi_auth_action_type set description=replace(description,'C- Funds','E-Funds') 
  where description like '%C- Funds%';
commit;

  
  


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
--   Date and Time:   08:19 Tuesday November 15, 2011
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

PROMPT ...Remove page 999
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>999);
 
end;
/

 
--application/pages/page_00999
prompt  ...PAGE 999: EFunds-Launcher
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 999,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'EFunds-Launcher',
  p_step_title=> 'EFunds-Launcher',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179216056228554478+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111115080619',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '15-Nov-2011 - Tim Ward - CR#3789 - Change CFunds to EFunds.');
 
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
  p_id=> 100558519790556734 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 999,
  p_plug_name=> 'The Region',
  p_region_name=>'',
  p_plug_template=> 0,
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
  p_plug_header=> '<script language="JavaScript">'||chr(10)||
'  window.location = ''&P999_URL_REDIR.'';'||chr(10)||
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
 
wwv_flow_api.create_page_branch(
  p_id=>100440822377875043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 999,
  p_branch_action=> 'f?p=&APP_ID.:999:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 20-OCT-2009 13:05 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100440423154856332 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 999,
  p_name=>'P999_TICKET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 100558519790556734+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Ticket',
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
  p_id=>100524424780892812 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 999,
  p_name=>'P999_URL_REDIR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 100558519790556734+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Url Redir',
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
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>100524726820940698 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 999,
  p_name=>'P999_CFUNDS_URL_RAW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 29,
  p_item_plug_id => 100558519790556734+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Raw CFunds Url',
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
  p_id=>100533013978110306 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 999,
  p_name=>'P999_REDIR_URL_RAW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 100558519790556734+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Redir Url Raw',
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
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
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
'v_duration number;'||chr(10)||
'begin'||chr(10)||
'    --Get ticket duration'||chr(10)||
'    v_duration  := core_util.get_config(''TICKET_CFUNDS_TIMEOUT'');'||chr(10)||
'    --Get ticket'||chr(10)||
'    ticket_pkg.get_ticket_for_vb(core_context.personnel_sid, :p999_ticket, v_duration);'||chr(10)||
'    --Get URL of the re-director'||chr(10)||
'    :p999_redir_url_raw := core_util.get_config(''OSI_REDIRECTOR_URL'');'||chr(10)||
'    --Get URL for CFunds'||chr(10)||
'    :p999_cfunds_url_raw := osi_cfunds.ge';

p:=p||'t_cfunds_mgmt_url_raw;'||chr(10)||
'    --Combine everything together'||chr(10)||
'    :p999_url_redir :='||chr(10)||
'        :p999_redir_url_raw || ''?ptkt='' || :p999_ticket || ''&p_par='' || :p999_cfunds_url_raw'||chr(10)||
'        || ''&p_type=cfn'';'||chr(10)||
'    --DEBUG ONLY'||chr(10)||
'    :debug := :p999_url_redir;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 100440526055866582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 999,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Process Everything (including the world!)',
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
-- ...updatable report columns for page 999
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
--   Date and Time:   07:54 Tuesday November 15, 2011
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

PROMPT ...Remove page 1070
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1070);
 
end;
/

 
--application/pages/page_01070
prompt  ...PAGE 1070: Desktop E-Funds Advances
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1070,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop E-Funds Advances',
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
  p_last_upd_yyyymmddhh24miss => '20111115075410',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '15-Aug-2011 - TJW - CR#3789 Change CFunds to EFunds.'||chr(10)||
'15-Nov-2011 - TJW - CR#3789 Change CFunds to EFunds, Missed Some.');
 
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
  p_id=> 6184603110274407 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1070,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''CFUNDS_ADV''))=''N''',
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
s:=s||'select ''javascript:getObjURL('''''' || cav2.sid || '''''');'' url,'||chr(10)||
'       to_char(cav2.request_date, :fmt_date) as "Date Requested",'||chr(10)||
'       (cav2.issue_on+90) as "Suspense Date",'||chr(10)||
'       osi_personnel.get_name(cav2.claimant) as "Claimant", cav2.narrative as "Description",'||chr(10)||
'       ''$'' || cav2.amount_requested as "Amount Requested",'||chr(10)||
'       cfunds_pkg.get_advance_status(cav2.submitted_on,'||chr(10)||
'                    ';

s:=s||'                 cav2.approved_on,'||chr(10)||
'                                     cav2.rejected_on,'||chr(10)||
'                                     cav2.issue_on,'||chr(10)||
'                                     cav2.close_date) as "Status",'||chr(10)||
'       osi_unit.get_name(cav2.unit) as "Charge To Unit",'||chr(10)||
'       osi_unit.get_name(osi_personnel.get_current_unit(cav2.claimant)) as "Claimants Unit",'||chr(10)||
'       o.times_accessed "Times Accessed",';

s:=s||''||chr(10)||
'       o.last_accessed "Last Accessed"'||chr(10)||
'  from t_cfunds_advance_v2 cav2,'||chr(10)||
'       (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1'||chr(10)||
'           where r1.obj(+) = o1.';

s:=s||'sid'||chr(10)||
'             and (   (    :p1070_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1070_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1070_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1070_filter in (''ALL'', ''OSI''))'||chr(10)||
'                ';

s:=s||'  or (    :p1070_filter = ''ME'' '||chr(10)||
'                      and osi_cfunds_adv.get_claimant(o1.sid)=:user_sid)'||chr(10)||
'                  or (    :p1070_filter = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1070_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'        ';

s:=s||'                  osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'                  or (    :p1070_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'              ';

s:=s||'                   osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'        t_core_obj_type ot'||chr(10)||
'where cav2.sid = o.sid'||chr(10)||
'      and ot.code=''CFUNDS_ADV'''||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 92414913067208368 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1070,
  p_plug_name=> 'Desktop > E-Funds Advances',
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''CFUNDS_ADV''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''javascript:getObjURL('''''' || cav2.sid || '''''');'' url,'||chr(10)||
'       to_char(cav2.request_date, :fmt_date) as "Date Requested",'||chr(10)||
'       (cav2.issue_on+90) as "Suspense Date",'||chr(10)||
'       osi_personnel.get_name(cav2.claimant) as "Claimant", cav2.narrative as "Description",'||chr(10)||
'       ''$'' || cav2.amount_requested as "Amount Requested",'||chr(10)||
'       cfunds_pkg.get_advance_status(cav2.submitted_on,'||chr(10)||
'                    ';

a1:=a1||'                 cav2.approved_on,'||chr(10)||
'                                     cav2.rejected_on,'||chr(10)||
'                                     cav2.issue_on,'||chr(10)||
'                                     cav2.close_date) as "Status",'||chr(10)||
'       osi_unit.get_name(cav2.unit) as "Charge To Unit",'||chr(10)||
'       osi_unit.get_name(osi_personnel.get_current_unit(cav2.claimant)) as "Claimants Unit",'||chr(10)||
'       o.times_accessed "Times Accessed",';

a1:=a1||''||chr(10)||
'       o.last_accessed "Last Accessed"'||chr(10)||
'  from t_cfunds_advance_v2 cav2,'||chr(10)||
'       (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1'||chr(10)||
'           where r1.obj(+) = o1.';

a1:=a1||'sid'||chr(10)||
'             and (   (    :p1070_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1070_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1070_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1070_filter in (''ALL'', ''OSI''))'||chr(10)||
'                ';

a1:=a1||'  or (    :p1070_filter = ''ME'' '||chr(10)||
'                      and osi_cfunds_adv.get_claimant(o1.sid)=:user_sid)'||chr(10)||
'                  or (    :p1070_filter = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1070_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'        ';

a1:=a1||'                  osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'                  or (    :p1070_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'              ';

a1:=a1||'                   osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'        t_core_obj_type ot'||chr(10)||
'where cav2.sid = o.sid'||chr(10)||
'      and ot.code=''CFUNDS_ADV'''||chr(10)||
'';

wwv_flow_api.create_worksheet(
  p_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1070,
  p_region_id => 92414913067208368+wwv_flow_api.g_id_offset,
  p_name => 'Desktop > C-Funds Advances',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No EFunds Advances found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1070_FILTER',
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
  p_download_filename         =>'&P1070_EXPORT_NAME.',
  p_detail_link              =>'#URL#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 1828602652802979+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'URL',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'Open',
  p_report_label           =>'Open',
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
  p_id => 1828715083802981+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Date Requested',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Date Requested',
  p_report_label           =>'Date Requested',
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
  p_id => 1828823390802981+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Claimant',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Claimant',
  p_report_label           =>'Claimant',
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
  p_id => 1828929943802981+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Description',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Description',
  p_report_label           =>'Description',
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
  p_id => 1829031798802982+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Amount Requested',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Amount Requested',
  p_report_label           =>'Amount Requested',
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
  p_id => 1829101848802982+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Status',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
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
  p_id => 1829201693802982+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Charge To Unit',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Charge To Unit',
  p_report_label           =>'Charge To Unit',
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
  p_id => 1829320410802984+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Claimants Unit',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Claimants Unit',
  p_report_label           =>'Claimants Unit',
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
  p_id => 1482902565269279+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Suspense Date',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Suspense Date',
  p_report_label           =>'Suspense Date',
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
  p_id => 1548732673594839+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Times Accessed',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
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
  p_id => 1548819342594842+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'Last Accessed',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
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
wwv_flow_api.create_worksheet_rpt(
  p_id => 92415329647208621+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1070,
  p_worksheet_id => 92415012902208368+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'IMAGETOUSE:Date Requested:Suspense Date:Claimant:Description:Amount Requested:Status:Charge To Unit:Claimants Unit:Times Accessed:Last Accessed',
  p_sort_column_1           =>'Charge To Unit',
  p_sort_direction_1        =>'ASC',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15447911487772181 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1070,
  p_button_sequence=> 10,
  p_button_plug_id => 92414913067208368+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1070);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>1518828836298812 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1070,
  p_branch_action=> 'f?p=&APP_ID.:1070:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 24-MAR-2010 16:35 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1518202863291265 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1070,
  p_name=>'P1070_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 92414913067208368+wwv_flow_api.g_id_offset,
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
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15448120838774871 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1070,
  p_name=>'P1070_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 92414913067208368+wwv_flow_api.g_id_offset,
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
  p_id=> 1518310136293378 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1070,
  p_computation_sequence => 10,
  p_computation_item=> 'P1070_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1070_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1070
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

CREATE OR REPLACE PACKAGE BODY Osi_Auth AS
/******************************************************************************
   Name:     osi_auth
   Purpose:  Provides Functionality For Authorization.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    29-Oct-2009 T.McGuffin      Created Package
    17-Dec-2009 R.Dibble        Added get_role_description, get_role_lov  
    18-Dec-2009 R.Dibble        Added get_role_complete_description,validate_role_creation
    04-Jan-2010 R.Dibble        Added get_perm_complete_description, get_perm_description, get_perm_lov
    06-Jan-2010 R.Dibble        Added user_can_grant_priv, priv_is_common_grant
    07-Jan-2010 R.Dibble        Added change_permission
    12-Jan-2010 R.Dibble        Added user_can_grant_role
    18-Jan-2010 R.Dibble        Added change_role    
    24-May-2010 T.McGuffin      Modified check_access to prevent multiple assignments causing an error.
    07-Jun-2010 T.McGuffin      Auditing failed check_for_privs.
    01-Oct-2010 R.Dibble        Added get_priv_description
    05-Oct-2010 T.Whitehead     CHG0003227 - Removed audit logging from check_for_priv.    
    20-Oct-2010 Tim Ward        Added OSI.CHECKFORPRIV_AUDIT_LOGGING to T_CORE_CONFIG to allow turning off
                                 check_for_priv failure logging (just like legacy).
                                 Changed check_for_priv.    
    20-Oct-2010 Tim Ward        CR#3223 & 3224 - Adding Logging and Notifications for check_access failures.
                                 Changed check_access.    
    01-Nov-2010 Tim Ward        Fix bug where Participants and Personnel Records couldn't be accessed.
    12-Nov-2010 J.Faris         Updated block of CheckAccess to return Y on affirmative checkforPriv while 
                                 continuing to log failures.
    09-Dec-2010 R.Dibble        Fixed small bug with check_access and ACCESS_ASS privilege
                                 Modified check_access to show pass messages on the 3 ACCESS type privilege checks
                                 Modified check_for_priv to look for explicit object actions prior to inherited object actions.
    13-Dec-2010 R.Dibble        Added p_supress_logging to check_access and check_for_priv.  Defaults to FALSE.
                                 Modified check_for_priv to do 2nd generation obj type testing when possible
    16-Dec-2010 R.Dibble        Fixed log suppression issue with Check_Access() 
    21-Dec-2010 J.Faris         Fixed issue with Check_Access to prevent any unit ownership checking when not applicable,
                                (Personnel, Participants). Also fixed bug in check_for_priv that wasn't parsing specific
                                object type code (by using a new function -"freq_instr").                            
    23-Dec-2010 J.Faris         Fixed Unit and Assigned Peronnel Only Restriction by changeing p_obj to v_personnel
                                in check_access on the IF v_obj_unit <> Osi_Personnel.get_current_unit(v_personnel) THEN                          
                                line.      
    28-Dec-2010 J.Faris         Fixed check_access to retrieve the participant SID when it is being called with a participant
                                version SID.                      
    08-Feb-2011 Tim Ward        CR#3536 - Lead Agent Name not found in check_access.
                                 Added a boolean input to check_access (p_get_message).
    04-Mar-2011 John Biggs      Changed check_for_priv to take out duplicate checking.
    04-Mar-2011 Tim Ward        Added p_explicit_action_check parameter to check_for_priv to tell it not to check parents.
                                 Changed p_supress_logging parameter from boolean := false to varchar2 := 'N' so we can call
                                  it from outside of PL/SQL.
    22-Apr-2011 Tim Ward        CR#3829 - Added v_explicit_action_check value to Check_Access.  
                                 Now check T_CORE_OBJ_TYPE.INHERIT_PRIVS_FROM_PARENT to see if 
                                 check_for_priv should check explicitly or not.
    10-Nov-2011 Tim Ward        CR#3789 - Change CFUNDS to EFUNDS.  
                                 Changed in get_perm_description and get_priv_description. 
                                         
******************************************************************************/
--###################################################################################################
--#                  Check Access Algorithm - Documented by Richard N. Dibble                       #
--###################################################################################################
--#  Privilege (or Combo)     #  User Ability                                                       #
--###################################################################################################
--#           .OVR            #  This privilege is a RESTRICTION OVERRIDE.                          #
--#                           #                                                                     #
--#                           #  Ex. If a user has all other needed access to an object, but does   #
--#                           #  NOT meet the proper restriction, they can still access the         #
--#                           #  object.  So, if an object is set to "Unit" or "Unit and Assigned   # 
--#                           #  Personnel" restrictions, and they are neither, they can access     #
--#                           #  this object if all other requirements are met (.ACA or .ACC, see   # 
--#       "OVERRIDE"          #  below).                                                            #
--###################################################################################################
--#           .ACA            #  This is the ACCESS ALL PRIVILEGE.                                  #
--#                           #                                                                     #
--#                           #  WHEN NO RESTRICTION EXISTS, a user can access an object in         #
--#                           #  another unit.  So, if an object is set to "None" restriction, they # 
--#                           #  can access an object either WITHIN or OUTSIDE OF THEIR UNIT.       #
--#                           #                                                                     #
--#                           #  WHEN A RESTRICTION EXISTS, a user would be able to access an       #
--#                           #  object only if they meet the restriction, whether or not they are  #
--#                           #  in the objects unit - a user may be assigned to an object, but not # 
--#                           #  in the objects unit (this is very common as agents from unit A     #
--#                           #  will often get assigned to objects from unit B).                   #
--#                           #                                                                     #
--#                           #  - If the restriction is "Unit and Assigned Personnel", they would  #
--#                           #  be able to open the object when either in the objects unit, or if  #
--#                           #  they are assigned to the object.                                   #
--#                           #                                                                     #
--#                           #  - If the restriction is "Unit", they would be able to open the     #
--#                           #  object when they are in the objects unit even if they are not      #
--#          "ACCESS"         #  assigned.                                                          #
--###################################################################################################
--#           .ACC            #  This is the ACCESS PRIVILEGE.                                      #
--#                           #                                                                     #
--#                           #  WHEN NO RESTRICTION EXISTS, a user can access an object in their   # 
--#                           #  unit.  This privilege deals with the notation "Within the          #
--#                           #  specified chain of command".  This means that if this privilege    #
--#                           #  is granted to the user for "All OSI Units" or "Unit and            #
--#                           #  Subordinate Units", the user will in fact be able to access an     #
--#                           #  object that is in either THEIR or in a SUBORDINATE UNIT.           #
--#                           #  **See details for this below.                                      #
--#                           #                                                                     #
--#                           #  WHEN A RESTRICTION EXISTS, the user would be able to access an     #
--#                           #  object as stated in the .ACA section - "When a restriction         #
--#        "ACCESS_UNT"       #  exists" above.                                                     #
--###################################################################################################
--#           .OVR            #  WHEN A RESTRICTION EXISTS, this combination will allow a user to   #
--#            and            #  access any object in THEIR UNIT, REGARDLESS of RESTRICTION.  Most  # 
--#           .ACC            #  likely used for Unit Leadership.                                   #
--###################################################################################################
--#           .OVR            #  WHEN A RESTRICTION EXISTS, this combination will a user to access  #
--#            and            #  any object REGARDLESS of RESTRICTION or UNIT AFFILIATION.  Most    #
--#           .ACA            #  likely used for Administrative or HQ leadership.                   #
--###################################################################################################
--# FURTHER NOTES:                                                                                  #
--# **This functionality algorithm is slightly different from Legacy to Web:                        #
--#                                                                                                 #
--#  LEGACY: The CheckForPriv() function would start at the objects unit, and travel upwards        #
--#          through the chain of command (looking at each subsequent units parent) until it found  #
--#          a match for the given privilege for the given personnel.                               #
--#                                                                                                 #
--#  WEB: In the web version, there is a single cursor loop (actually 3 for different checks) in    #
--#       the CheckForPriv() that utilizes the osi_unit.is_subordinate(objects_unit, users_unit)    #
--#       function to determine if the user has the privilege.                                      #
--#                                                                                                 #
--#  BOTH: Privs are checked by looking in the users roles, then their personnel privs, then the    #
--#        proxy table.                                                                             #
--###################################################################################################

    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_AUTH';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    FUNCTION check_for_priv(
        p_action                IN   VARCHAR2,
        p_obj_type              IN   VARCHAR2,
        p_personnel             IN   VARCHAR2 := NULL,
        p_unit                  IN   VARCHAR2 := NULL,
        p_supress_logging       in   VARCHAR2 := 'N',
        p_explicit_action_check in   VARCHAR2 := 'N')
        RETURN VARCHAR2 IS
        v_unit        T_OSI_UNIT.SID%TYPE;
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
        v_logfails    VARCHAR2(1);
        v_action      varchar2(100);
        v_obj_type varchar2(100);
        v_temp varchar2(20);
        

    BEGIN
        IF p_action IS NULL THEN
            RETURN 'N';
        END IF;

        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);
        v_unit := NVL(p_unit, Osi_Personnel.get_current_unit(v_personnel));
        --Set original action
        v_action := p_action;
                
        --If not: Continue on with the priv checking utilizing inheritance 
        FOR i IN (SELECT 1
                    FROM T_OSI_PERSONNEL_UNIT_ROLE ur, 
                          T_OSI_AUTH_ROLE_PRIV rp,
                          T_OSI_AUTH_PRIV p,
                          T_OSI_AUTH_ACTION_TYPE AT
                   WHERE ur.personnel = v_personnel
                     AND (   ur.unit IS NULL
                          OR (ur.unit = v_unit)
                          OR (    ur.include_subords = 'Y'
                              AND Osi_Unit.is_subordinate(ur.unit, v_unit) = 'Y'))
                     AND ur.assign_role = rp.ROLE
                     AND rp.priv = p.SID
                     AND AT.SID = p.action
                     AND AT.code = p_action
                     AND ((p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type) and p_explicit_action_check='N')
                     or (p.obj_type = p_obj_type and p_explicit_action_check='Y'))
                     AND ur.enabled = 'Y'
                     AND rp.enabled = 'Y'
                     AND SYSDATE BETWEEN NVL(ur.start_date, SYSDATE - 1)
                                     AND NVL(ur.end_date, SYSDATE + 1))
        LOOP
            LOG_ERROR('1-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
            RETURN 'Y';
        END LOOP;

        FOR i IN (SELECT 1
                    FROM T_OSI_PERSONNEL_PRIV pp,
                         T_OSI_AUTH_PRIV p,
                         T_OSI_AUTH_ACTION_TYPE AT
                   WHERE pp.personnel = v_personnel
                     AND pp.priv = p.SID
                     AND AT.SID = p.action
                     AND AT.code = p_action
                     AND ((p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type) and p_explicit_action_check='N')
                     or (p.obj_type = p_obj_type and p_explicit_action_check='Y'))
                     AND (   pp.unit IS NULL
                          OR pp.unit = v_unit
                          OR (pp.include_subords = 'Y' AND Osi_Unit.is_subordinate(pp.unit, v_unit) = 'Y'))
                     AND pp.enabled = 'Y'
                     AND SYSDATE BETWEEN NVL(pp.start_date, SYSDATE - 1) AND NVL(pp.end_date, SYSDATE + 1))
        LOOP
            LOG_ERROR('2-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
            RETURN 'Y';
        END LOOP;

        FOR i IN (SELECT 1
                    FROM T_OSI_PERSONNEL_PRIV_PROXY ppp,
                         T_OSI_AUTH_PRIV p,
                         T_OSI_AUTH_ACTION_TYPE AT
                   WHERE ppp.grantee = v_personnel
                     AND p.SID = ppp.priv
                     AND AT.SID = p.action
                     AND AT.code = p_action
                     --AND p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type)
                     AND ((p.obj_type MEMBER OF Osi_Object.get_objtypes(p_obj_type) and p_explicit_action_check='N')
                     or (p.obj_type = p_obj_type and p_explicit_action_check='Y'))
                     AND unit = v_unit
                     AND SYSDATE BETWEEN NVL(start_date, SYSDATE - 1) AND NVL(end_date, SYSDATE + 1))
        LOOP
            LOG_ERROR('3-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
            RETURN 'Y';
        END LOOP;
        
        v_logfails := Core_Util.GET_CONFIG('OSI.CHECKFORPRIV_AUDIT_LOGGING');
  
        IF v_logfails = 'Y' OR v_logfails IS NULL OR v_logfails='' THEN
          
          if (p_supress_logging = 'N') then

            Log_Info('Failed:' || p_obj_type || '-' || p_action);

          end if;

        END IF;
  
        LOG_ERROR('NNNNNNNOOOOOOOOO-v_personnel=' || v_personnel || 'v_action=' || v_action || 'v_unti=' || v_unit);
        RETURN 'N';
    END check_for_priv;

    PROCEDURE LogCheckAccessReturn(p_obj IN VARCHAR2, myRtn IN VARCHAR2, myMsg IN VARCHAR2, FailMsg IN VARCHAR2) IS
    
    v_CompleteMsg VARCHAR2(1000);
    v_event_sid   VARCHAR2(30);
    v_Log_Rtn     VARCHAR2(5);
    
 BEGIN
      IF myRTN = 'N' THEN
     
     v_Log_Rtn := 'False';

         ELSE
   
     v_Log_Rtn := 'True';
     
   END IF;

      v_CompleteMsg := 'CheckAccess:' || p_obj || ' - ' ||  v_Log_Rtn || ' - ';
   
   IF (FailMsg = '' OR FailMsg IS NULL) AND myRTN='N' THEN
     
        v_CompleteMsg := v_CompleteMsg || myMsg;
   
   ELSE
    
        v_CompleteMsg := v_CompleteMsg || FailMsg; 
     
   END IF;
   
         Log_Info(v_CompleteMsg);
   
   IF myRTN = 'N' THEN
           
     BEGIN
                SELECT SID INTO v_event_sid FROM T_OSI_NOTIFICATION_EVENT_TYPE t WHERE t.CODE='ACCESS.FAILED';

                INSERT INTO T_OSI_NOTIFICATION_EVENT (SID,EVENT_CODE,PARENT,PARENT_INFO,EVENT_BY,EVENT_ON,IMPACTED_UNIT,SPECIFICS,GENERATED) VALUES (NULL,v_event_sid,p_obj, Core_Obj.GET_TAGLINE(p_obj),Core_Context.personnel_name,SYSDATE,NULL,Core_Context.personnel_sid,'N');
                COMMIT;

     EXCEPTION WHEN OTHERS THEN
              
     NULL;
         
     END;       
     
   END IF;
   
 END LogCheckAccessReturn;
     
    FUNCTION Check_Access(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL,
        p_supress_logging   in   boolean := false, p_get_message in boolean := false) RETURN VARCHAR2 IS

        v_personnel              T_CORE_PERSONNEL.SID%TYPE;
        v_assigned               VARCHAR2(1)                 := 'N';
        v_obj                    T_OSI_PARTICIPANT.SID%TYPE;
        v_obj_type               T_CORE_OBJ_TYPE.SID%TYPE;
        v_obj_code               T_CORE_OBJ_TYPE.CODE%TYPE;
        v_obj_unit               T_OSI_UNIT.SID%TYPE;
        v_obj_restriction        T_OSI_REFERENCE.code%TYPE;
        v_lead_agent             T_CORE_PERSONNEL.SID%TYPE;
        myMsg                    VARCHAR2(4000);
        FailMsg                  VARCHAR2(4000);
        myRtn                    VARCHAR2(1) := 'Y';
        v_explicit_action_check  VARCHAR2(1) := 'N';
  
    BEGIN
         myMsg := 'You do not have permission to perform this function.';

         v_personnel := NVL(p_personnel, Core_Context.personnel_sid);
         
         BEGIN
              SELECT 'Y' INTO v_assigned
           FROM T_OSI_ASSIGNMENT
                        WHERE obj = p_obj
                          AND personnel = v_personnel
                          AND SYSDATE BETWEEN NVL(start_date, TO_DATE('01011901', 'mmddyyyy'))
                                          AND NVL(end_date, TO_DATE('12312999', 'mmddyyyy'))
                          AND ROWNUM=1;
         EXCEPTION
                  WHEN NO_DATA_FOUND THEN
         
                v_assigned := 'N';
         END;

         /* Check to see if a participant_version sid is being passed in
            (common for report links) if so, initialize v_obj with participant sid */
         if Core_Obj.get_objtype(p_obj) is not null then
              v_obj := p_obj;
         else
             BEGIN
                  SELECT PARTICIPANT
                    INTO v_obj
                    FROM T_OSI_PARTICIPANT_VERSION
                   WHERE SID = p_obj;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      v_obj := p_obj;
             END;
         end if;
         
         v_obj_unit := Osi_Object.get_assigned_unit(p_obj);
         v_obj_type := Core_Obj.get_objtype(v_obj);
         v_obj_code := osi_object.get_objtype_code(v_obj_type);
         v_explicit_action_check := core_obj.get_inherit_privs_flag(v_obj_type);
         
         IF NOT(check_for_priv('OVERRIDE', v_obj_type, v_personnel, v_obj_unit, 'Y', v_explicit_action_check) = 'Y' OR v_assigned = 'Y') THEN
           
           BEGIN
                SELECT r.code INTO v_obj_restriction
                      FROM (SELECT restriction FROM T_OSI_FILE WHERE SID = p_obj
                        UNION
                        SELECT restriction FROM T_OSI_ACTIVITY WHERE SID = p_obj) x, T_OSI_REFERENCE r
                              WHERE r.SID = x.restriction;
           EXCEPTION
                    WHEN NO_DATA_FOUND THEN
   
                     v_obj_restriction := 'NONE';
           END;

           v_lead_agent := osi_object.get_lead_agent(p_obj);
           IF v_obj_restriction = 'PERSONNEL' THEN
             
             if v_lead_agent = v_personnel then

               myMsg := REPLACE('This Object has been Restricted to ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR>Your Assignment in this object has been ended.', '  ', ' ');

             else

               myMsg := REPLACE('This Object has been Restricted to ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR>Please contact the Lead Agent ' || osi_personnel.get_name(v_lead_agent) || ' so they can give you access to this object.', '  ', ' ');

             end if;
             
             FailMsg := 'RESTRICTED TO ASSIGNED PERSONNEL ONLY';
             myRtn := 'N';
        
           ELSIF v_obj_restriction = 'UNIT' THEN
        
                IF v_obj_unit <> Osi_Personnel.get_current_unit(v_personnel) THEN
  
                  if v_lead_agent = v_personnel then

                    myMsg := REPLACE('This Object has been Restricted to UNIT AND ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR><BR>Your Assignment in this object has been ended.', '  ', ' ');

                  else

                    myMsg := REPLACE('This Object has been Restricted to UNIT AND ASSIGNED PERSONNEL ONLY.' || CHR(10) || CHR(13) || '<BR><BR>Please contact the Lead Agent ' || osi_personnel.get_name(v_lead_agent) || ' so they can give you access to this object.', '  ', ' ');

                  end if;

                  FailMsg := 'RESTRICTED TO UNIT';
                  myRtn := 'N';
        
                END IF;
        
           END IF;
        
         END IF;

         IF myRtn = 'Y' THEN

           --- Check Access without Unit ---
           IF check_for_priv('ACCESS', v_obj_type, v_personnel, null, 'Y', v_explicit_action_check) = 'N' THEN       

             FailMsg := 'check_for_priv(ACCESS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';
             myRtn := 'N';

           ELSE

             FailMsg := 'check_for_priv(ACCESS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';--NULL;
             myRtn := 'Y';

           END IF;

           if v_obj_unit != '<none>' then --Only do the following checks if Unit Ownership is applicable

             --- Check access with Unit ---
             IF myRtn = 'N' and check_for_priv('ACCESS_UNT', v_obj_type, v_personnel, v_obj_unit, 'Y', v_explicit_action_check) = 'N' THEN

               FailMsg := 'check_for_priv(ACCESS_UNT,' || v_obj_type || ',' || v_personnel || ',' || v_obj_unit || ',Y,' || v_explicit_action_check || ')';
               myRtn := 'N';

             ELSE

               FailMsg := 'check_for_priv(ACCESS_UNT,' || v_obj_type || ',' || v_personnel || ',' || v_obj_unit  || ',Y,' || v_explicit_action_check || ')';--NULL;
               myRtn := 'Y';

             END IF;
               
             --- Check access for objects assigned to ---
             if (myrtn = 'N') then

               if (v_assigned = 'Y' and check_for_priv('ACCESS_ASS', v_obj_type, v_personnel, null, 'Y', v_explicit_action_check) = 'Y') then

                 FailMsg := 'check_for_priv(ACCESS_ASS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';--NULL;
                 myRtn := 'Y';

               else
 
                 FailMsg := 'check_for_priv(ACCESS_ASS,' || v_obj_type || ',' || v_personnel || ',null,Y,' || v_explicit_action_check || ')';
                 myRtn := 'N';

               end if;
 
             end if;
 
           end if;

        END IF;
         
        --- Always allow them in their own Personnel Record ---
        IF p_obj = v_personnel THEN
                  
          FailMsg := NULL;
          myRtn := 'Y';
                
        END IF;

        --- Log Success or Failure of Access to Object ---
        if (p_supress_logging = false) then
 
          LogCheckAccessReturn(p_obj, myRtn, myMsg, FailMsg);
 
        end if;
        
        if p_get_message = false then

          RETURN myRtn;
        
        else
          
          RETURN myMSG;
          
        end if;
        
    END Check_Access;
 
/* Given a Role SID, I will return you the Description */
    FUNCTION get_role_description(p_role_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(200);
    BEGIN
        SELECT description
          INTO v_return
          FROM T_OSI_AUTH_ROLE
         WHERE SID = p_role_sid;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_role_description: ' || SQLERRM);
            RAISE;
    END get_role_description;
    
    /* Given a Role SID, I will return you the Complete Description */
    FUNCTION get_role_complete_description(p_role_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(200);
    BEGIN
        SELECT complete_desc
          INTO v_return
          FROM T_OSI_AUTH_ROLE
         WHERE SID = p_role_sid;

        RETURN v_return;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('osi_auth.get_role_complete_description: ' || SQLERRM);
            RAISE;
    END get_role_complete_description;
        
    FUNCTION get_role_lov(p_current_role IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn    VARCHAR2(32000);
        v_temp   VARCHAR2(1000);
    BEGIN
        FOR a IN (SELECT   description, SID
                      FROM T_OSI_AUTH_ROLE
                 
                  ORDER BY description)
        LOOP
            v_rtn := v_rtn || REPLACE(a.description, ', ', ' / ') || ';' || a.SID || ',';
        END LOOP;

        v_rtn := RTRIM(v_rtn, ',');
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_role_lov: ' || SQLERRM);
            RAISE;
    END get_role_lov;
        
    /* Given a Permission SID, I will return you the Complete Description */
    FUNCTION get_perm_complete_description(p_perm IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_obj VARCHAR2(20);
        v_action VARCHAR2(2000);
        v_return   VARCHAR2(1000);
    BEGIN
        SELECT obj_type, action INTO v_obj, v_action
        FROM T_OSI_AUTH_PRIV
        WHERE SID = p_perm;
        
        SELECT description INTO v_action FROM T_OSI_AUTH_ACTION_TYPE WHERE
        SID = v_action;
        
        v_return := Osi_Object.GET_OBJTYPE_DESC(v_obj) || ': ' || v_action;
        

        RETURN v_return;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            log_error('osi_auth.get_perm_complete_description: ' || SQLERRM);
            RAISE;
    END get_perm_complete_description;

    /* Given a Permission SID, I will return you the Basic Description */
    FUNCTION get_perm_description(p_perm IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(400);
    BEGIN
        SELECT replace(cot.code,'CFUND','EFUND') || '.' || oaat.code || ': ' || oap.description
          INTO v_return
          FROM T_OSI_AUTH_ACTION_TYPE oaat, T_OSI_AUTH_PRIV oap, T_CORE_OBJ_TYPE cot
         WHERE oaat.SID = oap.action AND oap.obj_type = cot.SID AND oap.SID = p_perm;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_perm_description: ' || SQLERRM);
            RAISE;
    END get_perm_description;
        
        
        
    /* Returns an LOV of currently usable permissions */
    FUNCTION get_perm_lov
        RETURN VARCHAR2 IS
                v_rtn    VARCHAR2(32000);
        v_temp   VARCHAR2(1000);
    BEGIN
        FOR k IN (SELECT    
                     SID
                      FROM v_osi_auth_priv
                 
                  ORDER BY obj_type, action_type)
        LOOP
            v_rtn := v_rtn || REPLACE(get_perm_description(k.SID), ', ', ' / ') || ';' || k.SID || ',';
        END LOOP;

        v_rtn := RTRIM(v_rtn, ',');
        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_perm_lov: ' || SQLERRM);
            RAISE;
    END get_perm_lov;
        
            
   /* Used to validate a role creation */
    FUNCTION validate_role_creation(
        p_assign_role   IN   VARCHAR2,
        p_unit          IN   VARCHAR2,
        p_personnel     IN   VARCHAR2)
        RETURN VARCHAR2 IS
        v_max_hq           NUMBER       := 0;
        v_max_rgn          NUMBER       := 0;
        v_max_sqd          NUMBER       := 0;
        v_max_unit         NUMBER       := 0;
        v_allow_top        VARCHAR2(1);
        v_agent_only       VARCHAR2(1);
        v_role_count       NUMBER       := 0;
        v_unit_type_code   VARCHAR2(20);
        not_an_agent       EXCEPTION;
        role_unit          EXCEPTION;
        role_unit_type     EXCEPTION;
        hq_role_max        EXCEPTION;
        rgn_role_exists    EXCEPTION;
        unit_role_exists   EXCEPTION;
        sqd_role_exists    EXCEPTION;
    BEGIN
        SELECT max_per_hq, max_per_rgn, max_per_sqd, max_per_unit, allow_top, agent_only
          INTO v_max_hq, v_max_rgn, v_max_sqd, v_max_unit, v_allow_top, v_agent_only
          FROM T_OSI_AUTH_ROLE
         WHERE SID = p_assign_role;

        v_unit_type_code := Osi_Reference.lookup_ref_code(Osi_Unit.get_unit_type(p_unit));

        -- Check to make sure the person is an agent for roles which require it.
        SELECT COUNT(*)
          INTO v_role_count
          FROM T_OSI_PERSONNEL
         WHERE SID = p_personnel AND badge_num IS NULL;

        --Note, due to a non-standard table (T_OSI_AUTH_ROLE), we are checking for 0 and N (checking for N in case the table gets fixed eventually) - RND:I did not create this table
        IF (v_role_count > 0 AND v_agent_only NOT IN ('N','0')) THEN
            RAISE not_an_agent;
        END IF;

        v_role_count := 0;

        -- Check if the role is allowed to be assigned at the top.
        --Note, due to a non-standard table (T_OSI_AUTH_ROLE), we are checking for 0 and N (checking for N in case the table gets fixed eventually) - RND:I did not create this table
        IF (p_unit IS NULL AND v_allow_top NOT IN ('N','0')) THEN
            RAISE role_unit;
        END IF;

        -- Count the number of times this role is used in this unit
        SELECT COUNT(*)
          INTO v_role_count
          FROM T_OSI_PERSONNEL_UNIT_ROLE
         WHERE assign_role = p_assign_role AND unit = p_unit
               AND(   end_date IS NULL
                   OR end_date > SYSDATE);

        -- Check if the role usage exceeds the maximum allowed
        IF (v_unit_type_code = 'HQ' AND v_role_count >= v_max_hq)  THEN
            IF v_max_hq = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE hq_role_max;
        END IF;

        IF (v_unit_type_code = 'REGN' AND v_role_count >= v_max_rgn) THEN
            IF v_max_rgn = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE rgn_role_exists;
        END IF;

        IF (v_unit_type_code = 'FIS' AND v_role_count >= v_max_sqd) THEN
            IF v_max_sqd = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE sqd_role_exists;
        END IF;

        IF ((   v_unit_type_code = 'DET'
            OR v_unit_type_code = 'OL') AND v_role_count >= v_max_unit) THEN
            IF v_max_unit = 0 THEN
                RAISE role_unit_type;
            END IF;

            RAISE unit_role_exists;
        END IF;
        
    --T_UNIT_ASSIGNMENT = Assigning Roles to Personnel (T_OSI_PERSONNEL_UNIT_ROLE) Note: This table is improperly named in WebI2MS.. Should be T_OSI_PERSONNEL_ROLE
    --T_ASSIGNMETN_HISTORY = Assigning Personnel to Units (T_OSI_PERSONNEL_UNIT_ASSIGN)
   RETURN NULL;
       EXCEPTION
        WHEN not_an_agent THEN
            RETURN 'The Role "' || get_role_description(p_assign_role)
                   || '" can only be assigned to badged agents.';
        WHEN role_unit THEN
            RETURN 'The unit can not be "All OSI" for the "' || get_role_description(p_assign_role)
                   || '" role.';
        WHEN role_unit_type THEN
            RETURN 'The Role, "' || get_role_description(p_assign_role)
                   || '", is not allowed for this unit type.';
        WHEN hq_role_max THEN
            RETURN 'Only ' || v_max_hq || ' active "' || get_role_description(p_assign_role)
                   || '" allowed in this HQ unit.';
        WHEN rgn_role_exists THEN
            RETURN 'Only ' || v_max_rgn || ' active "' || get_role_description(p_assign_role)
                   || '" per region is allowed.';
        WHEN sqd_role_exists THEN
            RETURN 'Only ' || v_max_sqd || ' active "' || get_role_description(p_assign_role)
                   || '" per squadron is allowed.';
        WHEN unit_role_exists THEN
            RETURN 'Only ' || v_max_unit || ' active "' || get_role_description(p_assign_role)
                   || '" per unit is allowed.';
        WHEN OTHERS THEN
            log_error('osi_auth.validate_role_creation: ' || SQLERRM);
            RETURN SQLERRM;
    END validate_role_creation;
    
    
    
    FUNCTION priv_is_common_grant(p_priv IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_cnt   NUMBER;
    BEGIN
        FOR k IN (SELECT priv
                    FROM v_osi_auth_role_priv
                   WHERE priv = p_priv AND common_grant = 'Y')
        LOOP
            RETURN 'Y';
        END LOOP;

        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.priv_is_common_grant: ' || SQLERRM);
            RETURN SQLERRM;
    END priv_is_common_grant;
    
    /* Returns 'Y' if the currently logged on user can grant a specific privilege */
    FUNCTION user_can_grant_priv(
        p_unit        IN   VARCHAR2,
        p_incsubs     IN   VARCHAR2,
        p_priv        IN   VARCHAR2,
        p_personnel   IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel   T_OSI_PERSONNEL.SID%TYPE;
        v_cnt         NUMBER;
        v_unit        VARCHAR2(20);
    BEGIN
        --First, need to check if its a common grant.. This trumps the 'Grantable' flag
        --That is of course provided the user has common grant privilege
        IF (    priv_is_common_grant(p_priv) = 'Y'
            AND Osi_Auth.check_for_priv('PMM_COMMON', Core_Obj.lookup_objtype('PERSONNEL')) = 'Y') THEN
            --This IS a common grantable priv, and the user HAS the privilege to use common grants
            RETURN 'Y';
        END IF;

        --Determine what personnel we have
        IF (p_personnel IS NULL) THEN
            v_personnel := Core_Context.personnel_sid;
        ELSE
            v_personnel := p_personnel;
        END IF;

        --CHECK FOR PERMISSION WITHIN A CURRENTLY ASSIGNED ROLE
        --Start with Unit we were passed
        v_unit := p_unit;

        LOOP
            --Checking Roles
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_PERSONNEL_UNIT_ROLE opur, T_OSI_AUTH_ROLE_PRIV oarp
             WHERE NVL(NVL(opur.unit, v_unit), 'x') = NVL(v_unit, 'x')
               AND opur.personnel = v_personnel
               AND SYSDATE BETWEEN NVL(opur.start_date, SYSDATE - 1) AND NVL(opur.end_date, SYSDATE + 1)
               AND (   v_unit = p_unit
                    OR opur.include_subords = 'Y'
                    OR opur.unit IS NULL)
               AND (   UPPER(NVL(p_incsubs, 'N')) <> 'Y'
                    OR opur.include_subords = 'Y'
                    OR opur.unit IS NULL)
               AND oarp.ROLE = opur.assign_role
               AND oarp.priv = p_priv
               AND oarp.grantable = 'Y';

            IF (v_cnt > 0) THEN
                --We found the grantable privilege within a role so return ok.
                RETURN 'Y';
            END IF;

            -- Look for the privilege in parent units
            IF (v_unit IS NOT NULL) THEN
                SELECT unit_parent
                  INTO v_unit
                  FROM T_OSI_UNIT
                 WHERE SID = v_unit;
            ELSE
                v_unit := NULL;
            END IF;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        --CHECK FOR EXPLICIT PRIVILEGE GRANTS
        --Start with Unit we were passed
        v_unit := p_unit;

        LOOP
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_PERSONNEL_PRIV
             WHERE NVL(NVL(unit, v_unit), 'x') = NVL(v_unit, 'x')
               AND priv = p_priv
               AND personnel = v_personnel
               AND SYSDATE BETWEEN NVL(start_date, SYSDATE - 1) AND NVL(end_date, SYSDATE + 1)
               AND grantable = 'Y'
               AND (   v_unit = p_unit
                    OR include_subords = 'Y'
                    OR unit IS NULL)
               AND (   UPPER(NVL(p_incsubs, 'N')) <> 'Y'
                    OR include_subords = 'Y'
                    OR unit IS NULL);

            IF (v_cnt > 0) THEN
                --We found the grantable privilege so return ok.
                RETURN 'Y';
            END IF;

            -- Look for the privilege in parent units
            IF (v_unit IS NOT NULL) THEN
                SELECT unit_parent
                  INTO v_unit
                  FROM T_OSI_UNIT
                 WHERE SID = v_unit;
            ELSE
                v_unit := NULL;
            END IF;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.user_can_grant_priv: ' || SQLERRM);
            RETURN SQLERRM;
    END user_can_grant_priv;
    
    /* Returns 'Y' if the currently logged on user can grant a specific role */
    FUNCTION user_can_grant_role(
        p_unit        IN   VARCHAR2,
        p_incsubs     IN   VARCHAR2,
        p_role        IN   VARCHAR2,
        p_personnel   IN   VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel    T_OSI_PERSONNEL.SID%TYPE;
        v_cnt          NUMBER;
        v_unit         VARCHAR2(20);
        v_grant_priv   T_OSI_AUTH_ROLE.grant_priv%TYPE;
    BEGIN

    --t_unit_role = t_osi_auth_role
    --t_unit_assignment = t_osi_personnel_unit_role

        --Get the privilege needed to grant this role
        FOR k IN (SELECT oap.action_type
                    FROM T_OSI_AUTH_ROLE oar, v_osi_auth_priv oap
                   WHERE oar.SID = p_role AND oar.grant_priv = oap.SID)
        LOOP
            v_grant_priv := k.action_type;
            EXIT;
        END LOOP;

        --Now that we know the basic permission to grant this role, lets see if the user has it.
        IF (Osi_Auth.check_for_priv(v_grant_priv, Core_Obj.lookup_objtype('PERSONNEL')) = 'Y') THEN
            --If so, return OK.
            RETURN 'Y';
        END IF;

        --Set the unit to the original unit
        v_unit := p_unit;
        
       --Determine what personnel we have
        IF (p_personnel IS NULL) THEN
            v_personnel := Core_Context.personnel_sid;
        ELSE
            v_personnel := p_personnel;
        END IF;
        
        LOOP
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_PERSONNEL_UNIT_ROLE
             WHERE assign_role = p_role
               AND personnel = v_personnel
               AND NVL(NVL(unit, v_unit), 'x') = NVL(v_unit, 'x')
               AND SYSDATE BETWEEN NVL(start_date, SYSDATE - 1) AND NVL(end_date, SYSDATE + 1)
               AND grantable = 'Y'
               AND (   v_unit = p_unit
                    OR include_subords = 'Y'
                    OR unit IS NULL)
               AND (   UPPER(NVL(p_incsubs, 'N')) <> 'Y'
                    OR include_subords = 'Y'
                    OR unit IS NULL);

            IF (v_cnt > 0) THEN
                --We found a grantable role, so exit
                RETURN 'Y';
            END IF;

            -- Look for the role in parent units
            IF (v_unit IS NOT NULL) THEN
                SELECT unit_parent
                  INTO v_unit
                  FROM T_OSI_UNIT
                 WHERE SID = v_unit;
            ELSE
                v_unit := NULL;
            END IF;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.user_can_grant_role: ' || SQLERRM);
            RETURN SQLERRM;
    END user_can_grant_role;
    
    
    /* Used when a user "Edit's" a permission */
    /* Note: This function actually ends the current permission, then creates another with the new specs. */
   FUNCTION change_permission(
        p_current_perm_sid   IN   VARCHAR2,
        p_perm               IN   VARCHAR2,
        p_unit               IN   VARCHAR2,
        p_start_date         IN   DATE,
        p_end_date           IN   DATE,
        p_enabled            IN   VARCHAR2,
        p_grantable          IN   VARCHAR2,
        p_include_subords    IN   VARCHAR2,
        p_allow_or_deny IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_personnel   T_OSI_PERSONNEL_PRIV.personnel%TYPE;
        v_sid         T_OSI_PERSONNEL_PRIV.SID%TYPE;
    BEGIN
        --Set the sid to the current perm.  
        --If the perm has not changed then this will be returned
        v_sid := p_current_perm_sid;

        --Get the personnel we are dealing with (saves us one input parameter)
        SELECT personnel
          INTO v_personnel
          FROM T_OSI_PERSONNEL_PRIV
         WHERE SID = p_current_perm_sid;

        --First see if there is a difference
        BEGIN
            SELECT SID
              INTO v_sid
              FROM T_OSI_PERSONNEL_PRIV
             WHERE SID = p_current_perm_sid
               AND personnel = v_personnel
               AND priv = p_perm
               AND unit = p_unit
               AND TO_CHAR(start_date,'DD/MM/YYYY') = TO_CHAR(p_start_date,'DD/MM/YYYY')
               
               AND (TO_CHAR(end_date,'DD/MM/YYYY') = TO_CHAR(p_end_date,'DD/MM/YYYY')
                    OR
                    (end_date IS NULL AND p_end_date IS NULL))
               
               AND grantable = p_grantable
               AND enabled = p_enabled
               AND include_subords = p_include_subords
               AND allow_or_deny = p_allow_or_deny;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Perm has changed - SO -
                --Update current perm with END date of now
                UPDATE T_OSI_PERSONNEL_PRIV
                   SET end_date = SYSDATE
                 WHERE SID = p_current_perm_sid;

                --Create a new perm with new specs
                INSERT INTO T_OSI_PERSONNEL_PRIV
                            (personnel,
                             priv,
                             unit,
                             start_date,
                             end_date,
                             grantable,
                             enabled,
                             include_subords,
                             allow_or_deny)
                     VALUES (v_personnel,
                             p_perm,
                             p_unit,
                             p_start_date,
                             p_end_date,
                             p_grantable,
                             p_enabled,
                             p_include_subords,
                             p_allow_or_deny)
                  RETURNING SID
                       INTO v_sid;
        END;

        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.change_permission: ' || SQLERRM);
            RETURN SQLERRM;
    END change_permission;
    
    /* Used when a user "Edit's" a role */
    /* Returns the SID of the new role for SEL_ROLE purposes */
    /* Note: This function actually ends the current role, then creates another with the new specs. */  
    
    FUNCTION change_role(
        p_current_role_sid   IN   VARCHAR2,
        p_role               IN   VARCHAR2,
        p_unit               IN   VARCHAR2,
        p_start_date         IN   DATE,
        p_end_date           IN   DATE,
        p_enabled            IN   VARCHAR2,
        p_grantable          IN   VARCHAR2,
        p_include_subords    IN   VARCHAR2)
        RETURN VARCHAR2 IS
        v_personnel   T_OSI_PERSONNEL_UNIT_ROLE.personnel%TYPE;
        v_sid         T_OSI_PERSONNEL_UNIT_ROLE.SID%TYPE;
    BEGIN
        --Set the sid to the current perm.  
        --If the perm has not changed then this will be returned
        v_sid := p_current_role_sid;

        --Get the personnel we are dealing with (saves us one input parameter)
        SELECT personnel
          INTO v_personnel
          FROM T_OSI_PERSONNEL_UNIT_ROLE
         WHERE SID = p_current_role_sid;

        --First see if there is a difference
        BEGIN
            SELECT SID
              INTO v_sid
              FROM T_OSI_PERSONNEL_UNIT_ROLE
             WHERE SID = p_current_role_sid
               AND personnel = v_personnel
               AND assign_role = p_role
               AND unit = p_unit
               AND TO_CHAR(start_date,'DD/MM/YYYY') = TO_CHAR(p_start_date,'DD/MM/YYYY')
               
               AND (TO_CHAR(end_date,'DD/MM/YYYY') = TO_CHAR(p_end_date,'DD/MM/YYYY')
                    OR
                    (end_date IS NULL AND p_end_date IS NULL))
               
               AND grantable = p_grantable
               AND enabled = p_enabled
               AND include_subords = p_include_subords;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Perm has changed - SO -
                --Update current perm with END date of now
                UPDATE T_OSI_PERSONNEL_UNIT_ROLE
                   SET end_date = SYSDATE
                 WHERE SID = p_current_role_sid;

                --Create a new perm with new specs
                INSERT INTO T_OSI_PERSONNEL_UNIT_ROLE
                            (personnel,
                             assign_role,
                             unit,
                             start_date,
                             end_date,
                             grantable,
                             enabled,
                             include_subords)
                     VALUES (v_personnel,
                             p_role,
                             p_unit,
                             p_start_date,
                             p_end_date,
                             p_grantable,
                             p_enabled,
                             p_include_subords)
                  RETURNING SID
                       INTO v_sid;
        END;

        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.change_role: ' || SQLERRM);
            RETURN SQLERRM;
    END change_role;
    
    /* Used to egt the free text representation of a permission */
    FUNCTION get_priv_description(p_priv IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR k IN (SELECT ot.code AS ot_code, AT.code AS at_code, ot.description AS ot_desc,
                         AT.description AS at_desc
                    FROM T_OSI_AUTH_ACTION_TYPE AT, T_CORE_OBJ_TYPE ot, T_OSI_AUTH_PRIV p
                   WHERE AT.SID = p.action AND ot.SID = p.obj_type AND p.SID = p_priv)
        LOOP
            IF (k.ot_desc LIKE 'Dummy%') THEN
                RETURN k.at_code || ': ' || k.at_desc;
            ELSE
                RETURN replace(k.ot_code,'CFUND','EFUND') || '.' || k.at_code || ': ' || k.ot_desc || '-' || k.at_desc;
            END IF;
        END LOOP;

        RETURN ' ';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_auth.get_priv_description: ' || SQLERRM);
            RETURN SQLERRM;
    END get_priv_description;
        
   
   
END Osi_Auth;
/




set define off;

CREATE OR REPLACE PACKAGE BODY "TICKET_WEB" as
/**
 * Air Force - Office Of Special Investigation
 *     _____  ___________________    _________.___
 *    /  _  \ \_   _____/\_____  \  /   _____/|   |
 *  /  /_\  \ |    __)   /   |   \ \_____  \ |   |
 * /    |    \|     \   /    |    \/        \|   |
 * \____|__  /\___  /   \_______  /_______  /|___|
 *         \/     \/            \/        \/
 *  Investigative Information Management System
 *  .___________    _____    _________
 *  |   \_____  \  /     \  /   _____/
 *  |   |/  ____/ /  \ /  \ \_____  \
 *  |   /       \/    Y    \/        \
 *  |___\_______ \____|__  /_______  /
 *              \/       \/        \/
 *  Ticket Authentication - Web Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       TICKET_WEB
   PURPOSE:    Supports Ticket Authentication in I2MS for Web Based Applications

   REVISIONS:
   Date         Author           Description
   ----------   ---------------  ------------------------------------
   09/30/2008   Richard Dibble   Created this package.
   10/21/2009   Richard Dibble   Added rdr
   15-Nov-2011  Tim Ward         CR#3789 - Change CFunds to EFunds
******************************************************************************/
    procedure create_cookie(ptkt in varchar2) is
    begin
        htp.p('Cookie Sent.');
    end create_cookie;

    procedure view_cookie(ptkt in varchar2) is
    begin
        htp.p('Cookie Value: [' || ticket_pkg.get_cookie('TICKET') || ']');
    end;
    
    procedure rdr(ptkt in varchar2, p_par in varchar2, p_type in varchar2) is
    begin
        htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">');
        htp.p('<html>');
        htp.p('<head>');
        htp.p('<title>Your Page Title</title>');
        htp.p('<meta http-equiv="REFRESH" content="0;url=' || p_par || '"></HEAD>');
        htp.p('<BODY>');
        if (upper(p_type) = 'CFN') then
            htp.p('Transfering you to EFunds, please wait.');
        else
            htp.p('Transfering you now, please wait. ');
        end if;
        htp.p('</BODY>');
        htp.p('</HTML>');
    end rdr;
end ticket_web;
/



commit;