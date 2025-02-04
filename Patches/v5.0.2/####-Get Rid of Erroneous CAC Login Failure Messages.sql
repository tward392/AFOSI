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
--   Date and Time:   11:25 Monday March 7, 2011
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

PROMPT ...Remove page 101
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>101);
 
end;
/

 
--application/pages/page_00101
prompt  ...PAGE 101: Login
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 101,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Login',
  p_alias  => 'LOGIN',
  p_step_title=> 'Login',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179848065721383865+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110307112532',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '21-Jan-2011 J.Faris - Added Invalid username message to existing validation (for clarity).'||chr(10)||
'04-Mar-2011 Tim Ward - Added a CAC Failure Logging to T_OSI_AUDIT.'||chr(10)||
'07-Mar-2011 Tim Ward - Get Rid of Erroneous CAC Failure Messages.');
 
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
  p_id=> 1156231057103821 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'CAC Assignment',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 30,
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
  p_plug_display_condition_type => 'FUNCTION_BODY',
  p_plug_display_when_condition => 'BEGIN'||chr(10)||
'     IF CORE_UTIL.GET_CONFIG(''OSI.USE_CAC'') = ''Y'' THEN'||chr(10)||
'       '||chr(10)||
'       IF :P0_SSL_CLIENT_S_DN_CN IS NOT NULL THEN'||chr(10)||
'       '||chr(10)||
'         RETURN TRUE;'||chr(10)||
'       '||chr(10)||
'       ELSE'||chr(10)||
''||chr(10)||
'         RETURN FALSE;'||chr(10)||
''||chr(10)||
'       END IF;'||chr(10)||
''||chr(10)||
'     ELSE'||chr(10)||
''||chr(10)||
'       RETURN FALSE;'||chr(10)||
''||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'END;',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<P ALIGN=CENTER>'||chr(10)||
'<TABLE BORDER=2>'||chr(10)||
' <TR>'||chr(10)||
'  <TD ALIGN=CENTER>'||chr(10)||
'      <FONT COLOR=RED>'||chr(10)||
'       <B>To Login Using your CAC Card, Please Enter your Personnel Number or the Last 4 Digits of your Social Security Number</B>'||chr(10)||
'      </FONT>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>',
  p_plug_footer=> '  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
'</P>',
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
s:=s||'<P ALIGN=CENTER>'||chr(10)||
'<TABLE BORDER=2 ALIGN=CENTER>'||chr(10)||
' <TR>'||chr(10)||
'  <TD ALIGN=CENTER>'||chr(10)||
'    <FONT COLOR=RED>'||chr(10)||
'     <B>***NO CAC CARD FOUND, YOU CAN ONLY LOG IN TO I2MS '||chr(10)||
'        USING A CAC CARD***</B>'||chr(10)||
'    </FONT>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
'</P>'||chr(10)||
''||chr(10)||
'<P ALIGN=CENTER>'||chr(10)||
'  <B>...Please Close your Browser to Try to Login Again...</B>'||chr(10)||
'</P>';

wwv_flow_api.create_page_plug (
  p_id=> 1251329577096911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'NO CAC Card Present',
  p_region_name=>'',
  p_plug_template=> 0,
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
  p_plug_display_condition_type => 'FUNCTION_BODY',
  p_plug_display_when_condition => 'BEGIN'||chr(10)||
'     IF CORE_UTIL.GET_CONFIG(''OSI.USE_CAC'') = ''Y'' THEN'||chr(10)||
'       '||chr(10)||
'       IF :P0_SSL_CLIENT_S_DN_CN IS NULL THEN'||chr(10)||
'       '||chr(10)||
'         RETURN TRUE;'||chr(10)||
'       '||chr(10)||
'       ELSE'||chr(10)||
''||chr(10)||
'         RETURN FALSE;'||chr(10)||
''||chr(10)||
'       END IF;'||chr(10)||
''||chr(10)||
'     '||chr(10)||
'     ELSE'||chr(10)||
''||chr(10)||
'       RETURN FALSE;'||chr(10)||
''||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'END;',
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
  p_id=> 1472424419151415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'Hidden Things',
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
s:=s||'<table width="100%" border="3" cellpadding="15"><tr><th>'||chr(10)||
'You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.'||chr(10)||
'By using this IS (which includes any device attached to this IS), you consent to the following conditions:'||chr(10)||
'The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration ';

s:=s||'testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations. '||chr(10)||
'At any time, the USG may inspect and seize data stored on this IS. '||chr(10)||
'Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG authorize';

s:=s||'d purpose. '||chr(10)||
'This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy. '||chr(10)||
'Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorn';

s:=s||'eys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.'||chr(10)||
'</td></tr></table><br>';

wwv_flow_api.create_page_plug (
  p_id=> 6361932624467639 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'Legal Disclaimer',
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
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '27-May-2010 Tom Leighty  -  Original region created.');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 171938240497298924 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'Login',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'FUNCTION_BODY',
  p_plug_display_when_condition => 'BEGIN'||chr(10)||
'     IF CORE_UTIL.GET_CONFIG(''OSI.USE_CAC'') = ''N'' THEN'||chr(10)||
'       '||chr(10)||
'       RETURN TRUE;'||chr(10)||
'     '||chr(10)||
'     ELSE'||chr(10)||
''||chr(10)||
'       RETURN FALSE;'||chr(10)||
''||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'END;',
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
  p_id=>1160222811281163 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_branch_action=> 'f?p=&APP_ID.:101:&SESSION.:CANCEL:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_branch_condition=> 'CANCEL',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 22-OCT-2010 09:08 by TWARD');
 
wwv_flow_api.create_page_branch(
  p_id=>1158719266221190 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_branch_action=> 'f?p=&APP_ID.:101:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_branch_condition_type=> 'NEVER',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1135311115732826 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_SSL_CLIENT_S_DN_CN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 171938240497298924+wwv_flow_api.g_id_offset,
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
  p_id=>1156802706123964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_PERSONNEL_NUM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 1156231057103821+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_WITH_ENTER_SUBMIT',
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
  p_id=>1158511635221187 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'LINK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 1156231057103821+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'LINK',
  p_prompt=>'Login',
  p_source=>'LINK',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(179221063608554498 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1159100338227442 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'CANCEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 1156231057103821+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'CANCEL',
  p_prompt=>'Cancel',
  p_source=>'CANCEL',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(179221063608554498 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when_type=>'NEVER',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1434413629643837 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 1472424419151415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_id=>1452229614452719 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_RETURN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 1472424419151415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Return',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 500,
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
  p_id=>10052102542373218 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_CHANGE_PASSWORD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 171938240497298924+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Change Password;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
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
  p_id=>171938332938298938 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_USERNAME',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 171938240497298924+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'User Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> 1,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
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
  p_id=>171938444161298944 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_PASSWORD',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 171938240497298924+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Password',
  p_source_type=> 'STATIC',
  p_display_as=> 'PASSWORD_WITH_ENTER_SUBMIT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> 1,
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
  p_encrypt_session_state_yn=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>171938548584298944 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_LOGIN',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 171938240497298924+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default => 'Login',
  p_prompt=>'Login',
  p_source=>'LOGIN',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> null,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(179221063608554498 + wwv_flow_api.g_id_offset),
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
 
wwv_flow_api.create_page_computation(
  p_id=> 1473221564169430 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_computation_sequence => 10,
  p_computation_item=> 'P101_RETURN',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'TESTING',
  p_compute_when => '',
  p_compute_when_type=>'%null%');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 3088013046840134 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_validation_name => 'User Has Unit',
  p_validation_sequence=> 10,
  p_validation => 'declare'||chr(10)||
'v_result   number;'||chr(10)||
'v_err      varchar2(100);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     v_result := osi_personnel.user_is_assigned_to_unit(:p101_username);'||chr(10)||
'     if v_result = 2 then'||chr(10)||
'         v_err := ''Invalid username.'';'||chr(10)||
'     elsif v_result = 0 then'||chr(10)||
'         v_err := ''User is not assigned to a unit.'';'||chr(10)||
'     else'||chr(10)||
'         return null;'||chr(10)||
'     end if;'||chr(10)||
'    return v_err;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'User is not assigned to a unit.',
  p_validation_condition=> ':P101_USERNAME is not null'||chr(10)||
'and'||chr(10)||
':P101_PASSWORD is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'    v_page          varchar2(30) := ''1000'';'||chr(10)||
'    v_last_name     varchar2(50);'||chr(10)||
'    v_first_name    varchar2(50);'||chr(10)||
'    v_name_comb     varchar2(101);'||chr(10)||
'    v_personnel_num varchar2(50);'||chr(10)||
'    v_login_id      varchar2(20);'||chr(10)||
'    v_ssn           varchar2(4);'||chr(10)||
'    v_return        boolean;'||chr(10)||
'    v_display_msg   varchar2(500);'||chr(10)||
'    v_password      varchar2(32);'||chr(10)||
'    v_failed_link   varchar2(1) := ''N'';'||chr(10)||
''||chr(10)||
'begi';

p:=p||'n'||chr(10)||
'     if CORE_UTIL.GET_CONFIG(''OSI.USE_CAC'') = ''Y'' then'||chr(10)||
''||chr(10)||
'       if length(:P101_PERSONNEL_NUM)=5 then'||chr(10)||
'       '||chr(10)||
'         begin'||chr(10)||
'         select c.last_name,c.first_name,c.personnel_num, c.last_name || ''.'' || c.first_name, '||chr(10)||
'                c.login_id, substr(o.ssn,length(o.ssn)-3,4),'||chr(10)||
'                c.login_id, c.pswd, r.code'||chr(10)||
'           into v_last_name, v_first_name, v_personnel_num, v_name_comb, v_';

p:=p||'login_id, v_ssn,'||chr(10)||
'                :p101_username, v_password, :p101_STATUS'||chr(10)||
'               from t_core_personnel c,t_osi_personnel o, t_osi_reference r'||chr(10)||
'               where o.sid=c.sid '||chr(10)||
'                 and c.personnel_num=:P101_PERSONNEL_NUM'||chr(10)||
'                 and o.PERSONNEL_STATUS_SID=r.sid;'||chr(10)||
''||chr(10)||
'         exception when others then'||chr(10)||
'                '||chr(10)||
'                  NULL;'||chr(10)||
''||chr(10)||
'         end;'||chr(10)||
''||chr(10)||
'         if v_';

p:=p||'name_comb = substr(:P0_SSL_CLIENT_S_DN_CN,1,length(v_name_comb)) then'||chr(10)||
'        '||chr(10)||
'           :p101_password := ''~~USE_CAC~~'' || :P0_SSL_CLIENT_S_DN_CN;'||chr(10)||
'           :p101_username := v_login_id;'||chr(10)||
'           v_failed_link  := ''N'';'||chr(10)||
'         '||chr(10)||
'         else'||chr(10)||
'           '||chr(10)||
'           v_failed_link  := ''Y'';'||chr(10)||
''||chr(10)||
'         end if;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'       if length(:P101_PERSONNEL_NUM)=4 then'||chr(10)||
''||chr(10)||
'         for a in (select';

p:=p||' c.last_name,c.first_name,c.personnel_num, '||chr(10)||
'                          c.last_name || ''.'' || c.first_name as v_name_comb, '||chr(10)||
'                          c.login_id as v_login_id, substr(o.ssn,length(o.ssn)-3,4) as v_ssn,'||chr(10)||
'                          c.pswd as password, r.code as status'||chr(10)||
'               from t_core_personnel c,t_osi_personnel o, t_osi_reference r'||chr(10)||
'               where o.sid=c.sid '||chr(10)||
'           ';

p:=p||'      and substr(o.ssn,length(o.ssn)-3,4)=:P101_PERSONNEL_NUM'||chr(10)||
'                 and o.PERSONNEL_STATUS_SID=r.sid)'||chr(10)||
'         loop'||chr(10)||
'             if a.v_name_comb = substr(:P0_SSL_CLIENT_S_DN_CN,1,length(a.v_name_comb)) then'||chr(10)||
'        '||chr(10)||
'               :p101_password := ''~~USE_CAC~~'' || :P0_SSL_CLIENT_S_DN_CN;'||chr(10)||
'               :p101_username := a.v_login_id;'||chr(10)||
''||chr(10)||
'               v_password := a.password;'||chr(10)||
'         ';

p:=p||'      :p101_STATUS := a.status;'||chr(10)||
''||chr(10)||
'               v_failed_link  := ''N'';'||chr(10)||
'               exit;'||chr(10)||
''||chr(10)||
'             else'||chr(10)||
'           '||chr(10)||
'               v_failed_link  := ''Y'';'||chr(10)||
''||chr(10)||
'             end if;'||chr(10)||
''||chr(10)||
'         end loop;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
'       '||chr(10)||
'       if v_failed_link  = ''Y'' then'||chr(10)||
''||chr(10)||
'         insert into t_osi_audit (message) values (''CAC Link Failure - '' || :P0_SSL_CLIENT_S_DN_CN || '' - '' || :P101_PERSONNEL_NUM);'||chr(10)||
''||chr(10)||
'  ';

p:=p||'     end if;'||chr(10)||
''||chr(10)||
'       CHECK_PERSONNEL_STATUS(:p101_username, v_password,:p101_STATUS,'||chr(10)||
'                              v_return,v_display_msg);'||chr(10)||
''||chr(10)||
'       if v_return = false then'||chr(10)||
'         '||chr(10)||
'         owa_util.redirect_url(''f?p=&APP_ID.:102:&SESSION.::::P102_MESSAGE:'' || v_display_msg);'||chr(10)||
''||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         wwv_flow_custom_auth_std.login(p_uname            => :p101_username,'||chr(10)||
'                             ';

p:=p||'           p_password         => :p101_password,'||chr(10)||
'                                        p_session_id       => v(  ''APP_SESSION''),'||chr(10)||
'                                        p_flow_page        => :app_id || '':'' || v_page);'||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     :p101_password := null;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 1160403811304111 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> .1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'CAC Linking',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''LINK'',''P101_PERSONNEL_NUM'')',
  p_process_when_type=>'SQL_EXPRESSION',
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
p:=p||':P0_SSL_CLIENT_S_DN_CN:=NULL;'||chr(10)||
':P0_SSL_CERT:=NULL;'||chr(10)||
':P0_SSL_CERT_I:=NULL;'||chr(10)||
':P0_SSL_CLIENT_I_DN_OU:=NULL;';

wwv_flow_api.create_page_process(
  p_id     => 1159407395238860 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> .2,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Cancel CAC Linking',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST=''CANCEL''',
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
p:=p||'begin'||chr(10)||
'owa_util.mime_header(''text/html'', FALSE);'||chr(10)||
'owa_cookie.send('||chr(10)||
'    name=>''LOGIN_USERNAME_COOKIE'','||chr(10)||
'    value=>lower(:P101_USERNAME));'||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 171938744043298957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Username Cookie',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_page   varchar2(30) := ''1000'';'||chr(10)||
'begin'||chr(10)||
'    if ((   :p101_password = core_util.get_config(''CORE.PSWD_RESET'')'||chr(10)||
'        or :p101_change_password = ''Y'')'||chr(10)||
'--and :p101_username = ''dibble'''||chr(10)||
') then'||chr(10)||
'        v_page := ''110'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    wwv_flow_custom_auth_std.login(p_uname            => :p101_username,'||chr(10)||
'                                   p_password         => :p101_password,'||chr(10)||
'                 ';

p:=p||'                  p_session_id       => v(  ''APP_SESSION''),'||chr(10)||
'                                   p_flow_page        => :app_id || '':'' || v_page);'||chr(10)||
'    --Copied this from ICE, not sure if we need it or not (thinking we do)'||chr(10)||
'    :p101_password := null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 171938641720298949 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Login',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST NOT IN (''CANCEL'',''LINK'')',
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
p:=p||'CORE_UTIL.CREATE_TICKET(:APP_USER, 10 * 60 * 60);';

wwv_flow_api.create_page_process(
  p_id     => 1159502222792534 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Ticket for VLT Processing',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'APP_USER',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'Specified by Tim Sanders on Tuesday, March 16, 2009.  Do not remove this page since the VLT expects a user Ticket to exist before it commences with its processing.');
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
p:=p||'101';

wwv_flow_api.create_page_process(
  p_id     => 171938932270298958 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_PAGES',
  p_process_name=> 'Clear Page(s) Cache',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v varchar2(255) := null;'||chr(10)||
'    c owa_cookie.cookie;'||chr(10)||
'begin'||chr(10)||
'   c := owa_cookie.get(''LOGIN_USERNAME_COOKIE'');'||chr(10)||
'   :P101_USERNAME := c.vals(1);'||chr(10)||
''||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 171938843470298958 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Username Cookie',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'  v_page          varchar2(30) := ''1000'';'||chr(10)||
'  v_display_msg   varchar2(500);'||chr(10)||
'  v_return        boolean;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  '||chr(10)||
'  --v_test := owa_util.print_cgi_env;'||chr(10)||
'  --wwv_flow.debug(v_test);'||chr(10)||
''||chr(10)||
'  if CORE_UTIL.GET_CONFIG(''OSI.USE_CAC'') = ''Y'' then'||chr(10)||
''||chr(10)||
'    begin'||chr(10)||
'         select LOGIN_ID,PSWD,SSL_CLIENT_S_DN_CN,R.CODE'||chr(10)||
'           into :p101_username,:p101_password,:p101_SSL_CLIENT_S_DN_CN,:p101_STATUS'||chr(10)||
'         ';

p:=p||'     from t_core_personnel c,t_osi_personnel p, t_osi_reference r '||chr(10)||
'                  where c.sid=p.sid'||chr(10)||
'                    and p.PERSONNEL_STATUS_SID=r.sid '||chr(10)||
'                    and SSL_CLIENT_S_DN_CN=:P0_SSL_CLIENT_S_DN_CN;'||chr(10)||
''||chr(10)||
'    exception when others then'||chr(10)||
''||chr(10)||
'             :p101_username := null;'||chr(10)||
'             :p101_password := null;'||chr(10)||
'             :p101_SSL_CLIENT_S_DN_CN := null;'||chr(10)||
''||chr(10)||
'    end;'||chr(10)||
'  '||chr(10)||
'    if :p';

p:=p||'101_username is not null and '||chr(10)||
'       :p101_password is not null and '||chr(10)||
'       :p101_SSL_CLIENT_S_DN_CN is not null then  '||chr(10)||
'    '||chr(10)||
'      if :P0_SSL_CLIENT_I_DN_OU=''OU=DoD'' then'||chr(10)||
'        '||chr(10)||
'        CHECK_PERSONNEL_STATUS(:p101_username,:p101_password,:p101_STATUS,'||chr(10)||
'                               v_return,v_display_msg);'||chr(10)||
''||chr(10)||
'        if v_return = false then'||chr(10)||
''||chr(10)||
'          owa_util.redirect_url(''f?p=&APP_ID.:102:&SES';

p:=p||'SION.::::P102_MESSAGE:'' || v_display_msg);'||chr(10)||
''||chr(10)||
'        else'||chr(10)||
''||chr(10)||
'          wwv_flow_custom_auth_std.login(p_uname      => :p101_username,'||chr(10)||
'                                         p_password   => ''~~USE_CAC~~'' || :p101_SSL_CLIENT_S_DN_CN,'||chr(10)||
'                                         p_session_id => v(''APP_SESSION''),'||chr(10)||
'                                         p_flow_page  => :app_id || '':'' || v_page);'||chr(10)||
'    '||chr(10)||
'     ';

p:=p||'     CORE_UTIL.CREATE_TICKET(V(''APP_USER''), 10 * 60 * 60);'||chr(10)||
'         '||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  :p101_password := null;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 1134725482699175 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 50,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check_CAC',
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
-- ...updatable report columns for page 101
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
