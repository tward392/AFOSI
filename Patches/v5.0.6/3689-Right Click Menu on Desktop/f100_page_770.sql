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
--   Date and Time:   10:16 Wednesday April 4, 2012
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

PROMPT ...Remove page 770
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>770);
 
end;
/

 
--application/pages/page_00770
prompt  ...PAGE 770: Email Link to Object
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 770,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Email Link to Object',
  p_step_title=> 'Email Link to Object',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_welcome_text=> '<script language="javascript">'||chr(10)||
'function SaveToPageValue(pMessage)'||chr(10)||
'{'||chr(10)||
' $s(''P770_MESSAGE'',pMessage);'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 4444031419583031+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120404101654',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '04-Apr-2012 - TJW - CR#3689 - Right Click Menu, Created.');
 
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
  p_id=> 12641020869318346 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 770,
  p_plug_name=> 'Hidden',
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
s:=s||'<div width="100%" height="100%" id="LocatorDiv" class="LocatorDiv" name="LocatorDiv">'||chr(10)||
'<table border=1 style="width:100%; height:95%;" id="EmailLinkTable">'||chr(10)||
'<tr><td colspan=2 style="font-family:Arial; font-size:12px; font-weight:bold;">From:&nbsp;&nbsp;&P770_EMAIL_ADDRESS.</td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td style="width:70%; height=100%;">'||chr(10)||
'<div style="font-family:Arial; font-size:12px; font-weight:bold;">Send to:</';

s:=s||'div>'||chr(10)||
'<iframe width="100%" height="98%" frameborder="0" name="Locator" id="Locator" class="Locator" allowtransparencty="true" style="background-color: transparent;"'||chr(10)||
' src="f?p=&APP_ID.:301:&SESSION.:OPEN:NO:301:P301_OBJECT_TYPE,P301_OBJ,P301_RETURN_ITEM,P301_IS_LOCATOR,P301_MULTI,P301_LOCATEMANY,P301_EXCLUDE:PERSONNEL_EMAIL,&P770_OBJ.,P770_SELECTED,Y,Y,N,:">'||chr(10)||
'</iframe>'||chr(10)||
'</td>'||chr(10)||
'<td style="width:30%; hei';

s:=s||'ght:100%"><div style="font-family:Arial; font-size:12px; font-weight:bold;">Message text to go with link:</div>'||chr(10)||
'<textarea style="width:98%; height:97%" id="EmailMessage" onchange="javascript:SaveToPageValue(this.value);">'||chr(10)||
'</textarea>'||chr(10)||
'</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_page_plug (
  p_id=> 12736522889196331 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 770,
  p_plug_name=> 'Locator Region',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => '(:P770_DONE=''N'' OR :P770_DONE IS NULL) '||chr(10)||
'AND :P770_EMAIL_ADDRESS NOT LIKE ''No Valid %'';',
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
s:=s||'<HR>'||chr(10)||
'<BR>'||chr(10)||
'<CENTER><H3>Email has been sent to &P770_TOT_SELECTED. recipients.</H3></CENTER><BR>'||chr(10)||
'<HR>';

wwv_flow_api.create_page_plug (
  p_id=> 12737614016203259 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 770,
  p_plug_name=> 'Done',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P770_DONE=''Y'';',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> 'onclick="mySubmit(''CloseIT'');');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<center>'||chr(10)||
'<h2>You do not have a valid email address.</h2>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<h3>'||chr(10)||
'Please go to your Personnel Management Module (PMM) and enter a valid "Email - Primary" in the "Details->Personal Information->Contact Information" tab.'||chr(10)||
'</h3>'||chr(10)||
'</center>';

wwv_flow_api.create_page_plug (
  p_id=> 12787125129496102 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 770,
  p_plug_name=> 'Invalid From Email Address',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 40,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P770_EMAIL_ADDRESS LIKE ''No Valid %'';',
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
  p_id=>12658602654748367 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 770,
  p_branch_action=> 'f?p=&APP_ID.:770:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 30-MAR-2012 12:18 by TWARD');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12567804708003221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 770,
  p_name=>'P770_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
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
  p_id=>12641430565321148 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 770,
  p_name=>'P770_EMAIL_ADDRESS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 12641020869318346+wwv_flow_api.g_id_offset,
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
  p_id=>12658016806723987 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 770,
  p_name=>'P770_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 12641020869318346+wwv_flow_api.g_id_offset,
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
  p_id=>12674020054965432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 770,
  p_name=>'P770_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 12641020869318346+wwv_flow_api.g_id_offset,
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
  p_id=>12688004245244764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 770,
  p_name=>'P770_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 12641020869318346+wwv_flow_api.g_id_offset,
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
  p_id=>12761110459495577 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 770,
  p_name=>'P770_TOT_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 12641020869318346+wwv_flow_api.g_id_offset,
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
p:=p||'INSERT INTO T_OSI_EMAILLINK (PERSONNEL,OBJ,USER_TEXT,SENDER,RECIPIENTS)'||chr(10)||
'VALUES'||chr(10)||
'(''&USER_SID.'',:P770_OBJ,:P770_MESSAGE,:P770_EMAIL_ADDRESS,:P770_SELECTED);'||chr(10)||
''||chr(10)||
':P770_DONE:=''Y'';';

wwv_flow_api.create_page_process(
  p_id     => 12666507326592777 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 770,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Send Email(s)',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P770_SELECTED',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'BEGIN'||chr(10)||
':P770_OBJ:=:P0_OBJ;'||chr(10)||
':P770_TOT_SELECTED:=CORE_LIST.COUNT_LIST_ELEMENTS(REPLACE(:P770_SELECTED,'':'',''~''));'||chr(10)||
''||chr(10)||
'select cont.value into :P770_EMAIL_ADDRESS'||chr(10)||
'  from t_core_personnel p,'||chr(10)||
'       t_osi_personnel op,'||chr(10)||
'       t_osi_personnel_contact cont,'||chr(10)||
'       t_osi_reference r '||chr(10)||
'  WHERE p.SID=op.SID AND '||chr(10)||
'        cont.personnel=p.sid and '||chr(10)||
'        r.sid=cont.type and '||chr(10)||
'        r.code=''EMLP'' and '||chr(10)||
'upper(substr(';

p:=p||'cont.value,-LENGTH(UPPER(core_util.GET_CONFIG(''OSI.NOTIF_EMAIL_ALLOW_ADDRESSES'')))))=UPPER(core_util.GET_CONFIG(''OSI.NOTIF_EMAIL_ALLOW_ADDRESSES'')) AND'||chr(10)||
'        p.sid=:USER_SID;'||chr(10)||
'EXCEPTION WHEN OTHERS THEN'||chr(10)||
'         '||chr(10)||
'         :P770_EMAIL_ADDRESS:=''No Valid *@'' || core_util.GET_CONFIG(''OSI.NOTIF_EMAIL_ALLOW_ADDRESSES'') || '' was found.'';'||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 12567917521006921 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 770,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P770_SELECTED',
  p_process_when_type=>'',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 770
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
