----------------------------------------------------
--- 002 - WCHG0000331_Add Liaison Level Ref data ---
----------------------------------------------------
-- WCHG0000331: This adds a new Liaison Level choice for the Liaison Activity.

SET DEFINE OFF;
Insert into WEBI2MS.T_OSI_REFERENCE
   (SID, USAGE, CODE, DESCRIPTION, SEQ, ACTIVE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, COMMENTS)
 Values
   ('2220ONVA', 'LIAISON_LEVEL', 'PFC', 'Private Foreign Citizen', 12, 'Y', 'I2MS\Carolyn.Johnson', TO_DATE('01/26/2011 15:25:01', 'MM/DD/YYYY HH24:MI:SS'), 'I2MS\Carolyn.Johnson', TO_DATE('01/26/2011 15:25:01', 'MM/DD/YYYY HH24:MI:SS'), 'from CR # WCHG0000331');
COMMIT;


-------------------------------------------------------------
--- 003 - WCHG0000340_Interview_Act_Subject_String_Update ---
-------------------------------------------------------------

-- WCHG0000340: This updates the string seen in the Title of the "Create Interview" Apex page.

update WEBI2MS.T_OSI_OBJ_TYPE set DEFAULT_TITLE = 'Interview of: ~Person~' where SID IN ('222000009LJ','222000009LI','222000009LG');
commit;



-- WCHG0000340: This is necessary to allow the application to replace the "~Person~" substring with the participant's name, when the activity is created.

UPDATE
WEBI2MS.T_OSI_PARTIC_ROLE_TYPE
SET CODE = 'PERSON' 
WHERE SID = '22200000839';
COMMIT;



update t_osi_activity
   set title = replace(title, '~Subject~', '~Person~')
 where SID in(select SID
                from v_osi_activity_summary
               where title like '%~Subject~%' and object_type_description like 'Interview,%');

commit;

---------------------------
--- 004 - UMM_Bug_fixes ---
---------------------------
set define off
set verify off
set serveroutput on size 1000000
set feedback off
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   14:05 Wednesday January 26, 2011
--   Exported By:     JASON
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.12
 
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

PROMPT ...Remove page 30305
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30305);
 
end;
/

 
--application/pages/page_30305
prompt  ...PAGE 30305: Unit Management Information
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_LOCATOR"'||chr(10)||
'"JS_ADDRESS_WIDGET"'||chr(10)||
''||chr(10)||
'<script language="JavaScript">'||chr(10)||
'  function check_for_deactivate(){'||chr(10)||
'     var result = confirm("Are you sure you would like to de-activate this unit?");'||chr(10)||
'     if (result)'||chr(10)||
'         doSubmit(''DE_ACTIVATE_UNIT'');'||chr(10)||
'  }    '||chr(10)||
'  function check_for_activate(){'||chr(10)||
'     var result = confirm("Are you sure you would like to activate this unit?");'||chr(10)||
'     if (result)'||chr(10)||
'         doSubm';

ph:=ph||'it(''ACTIVATE_UNIT'');'||chr(10)||
'  }    '||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30305,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Unit Management Information',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title => 'Unit Management Information',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'JASON',
  p_last_upd_yyyymmddhh24miss => '20110126140541',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '06-DEC-2010 J.FARIS - WCHG0000386 - updates to address widget.'||chr(10)||
'26-JAN-2011 J.FARIS - Small bug fix on FBI ORI Num (RO) item');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30305,p_text=>ph);
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
  p_id=> 89782524496822301 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30305,
  p_plug_name=> 'Unit Summary',
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
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
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
  p_id=> 97966829025295854 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30305,
  p_plug_name=> 'Parent Unit Information',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89782710532822301 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30305,
  p_button_sequence=> 10,
  p_button_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89782924741822303 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30305,
  p_button_sequence=> 20,
  p_button_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5122301052698923 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30305,
  p_button_sequence=> 30,
  p_button_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_button_name    => 'ACTIVATE_UNIT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Re-Activate Unit',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:check_for_activate();',
  p_button_condition=> ':P30305_IS_ACTIVE = ''N'''||chr(10)||
'and'||chr(10)||
':P30305_USER_CAN_ACTIVATE = ''Y'''||chr(10)||
'and'||chr(10)||
':P0_WRITABLE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5122514904703010 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30305,
  p_button_sequence=> 40,
  p_button_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_button_name    => 'DE_ACTIVATE_UNIT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'De-Activate Unit',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:check_for_deactivate();',
  p_button_condition=> ':P30305_IS_ACTIVE = ''Y'''||chr(10)||
'and'||chr(10)||
':P30305_USER_CAN_DE_ACTIVATE = ''Y'''||chr(10)||
'and'||chr(10)||
':P0_WRITABLE = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89800422982332318 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST LIKE ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 30-APR-2009 15:12 by THOMAS');
 
wwv_flow_api.create_page_branch(
  p_id=>89799937050326837 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_branch_action=> 'f?p=&APP_ID.:30305:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 30-APR-2009 15:11 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5062632419728728 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_FBI_ORI_NUM_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'FBI ORI Number',
  p_source=>'FBI_ORI_NUM',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30305_IS_TOP_LEVEL_PARENT = ''N''',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>5063128095765332 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_IS_TOP_LEVEL_PARENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_IS_TOP_LEVEL_PARENT',
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
  p_id=>5084711583668910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_IS_ACTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_IS_ACTIVE',
  p_source=>'ACTIVE',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>5151929429956184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_USER_CAN_DE_ACTIVATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5.1,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_USER_CAN_DE_ACTIVATE',
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
  p_id=>5152104972958612 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_USER_CAN_ACTIVATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5.2,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_USER_CAN_ACTIVATE',
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
  p_id=>5211503773421900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_USER_CAN_EDIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5.3,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_USER_CAN_EDIT',
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
  p_id=>5211711738424204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_USER_CAN_RENAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5.4,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_USER_CAN_RENAME',
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
  p_id=>5262028276865917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_VIEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Unit" href="'' || '||chr(10)||
'osi_object.get_object_url(:P30305_PARENT_UNIT_SID) ||'||chr(10)||
'''">&ICON_MAGNIFY.</a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30305_PARENT_UNIT_SID is not null'||chr(10)||
'',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>7885007016425242 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_SEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 114,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(500,''P30305_PARENT_UNIT_SID'',''N'',''&P30305_PARENT_UNIT_SID.~&P0_OBJ.'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_display_when=>':P30305_USER_CAN_RENAME = ''Y''',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>7885504507443368 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_RENAME_LOCKOUT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5.5,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_RENAME_LOCKOUT',
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
  p_id=>89783127970822303 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_UNIT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Name',
  p_source=>'UNIT_NAME',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30305_RENAME_LOCKOUT.',
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
  p_id=>89783313554822303 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_UNIT_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Code',
  p_source=>'UNIT_CODE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 100,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30305_RENAME_LOCKOUT.',
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
  p_id=>89783528755822303 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_DIBRS_NUM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'DIBRS ORI Number',
  p_source=>'FBI_LOC_NUM',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 30,
  p_cHeight=> 1,
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
  p_id=>89783725237822304 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_FBI_ORI_NUM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'FBI ORI Number',
  p_source=>'FBI_ORI_NUM',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 9,
  p_cMaxlength=> 9,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30305_IS_TOP_LEVEL_PARENT = ''Y''',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>95317027998383985 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>97946606637805198 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_UNIT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50.2,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Type',
  p_source=>'UNIT_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P30305_UNIT_TYPE_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Unit Type -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97947212655816381 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_UNIT_TYPE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50.1,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_UNIT_TYPE_LOV',
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
  p_id=>97948512224835256 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_UIC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'UIC',
  p_source=>'UIC',
  p_source_type=> 'DB_COLUMN',
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
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97948833695841378 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_IIR_LOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Code',
  p_source=>'IIR_LOC',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 3,
  p_cMaxlength=> 3,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97949019628846818 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_CRC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'CRC',
  p_source=>'CRC',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 6,
  p_cMaxlength=> 6,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97966520236283873 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30305_UNIT_SID',
  p_source=>'UNIT_PARENT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>97966732011287237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Parent Unit',
  p_source=>'OSI_UNIT.GET_NAME(:P30305_PARENT_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
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
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'',item_values:''OSI.LOC.UNIT,P5450_UNIT_SID,&P5450_UNIT_EXCLUDE.''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>97968728080352392 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Code',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97969223493369945 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97969508172384498 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_ORI',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'DIBRS ORI Number',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97969829081399995 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_PARENT_UNIT_UIC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 97966829025295854+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Parent Unit UIC',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-CENTER',
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
  p_id=>97973819991766389 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_ADDRESS_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_address.get_addr_fields(osi_address.get_address_sid(:P30305_SID, ''UNIT_ADDR''))',
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
  p_id=>97974031073769590 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_ADDRESS_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Location',
  p_source=>'osi_address.get_addr_display(:P30305_ADDRESS_VALUE,''FIELDS'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 36,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXTAREA.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>97974208348772424 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_name=>'P30305_ADDRESS_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 89782524496822301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href ="javascript:void(0);" onclick = "javascript:addressWidget(''P30305_ADDRESS_VALUE''); return false;">&ICON_ADDRESS.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 95320937535500299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30305,
  p_computation_sequence => 10,
  p_computation_item=> 'P30305_SID',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> ':p0_obj',
  p_compute_when => '',
  p_compute_when_type=>'%null%');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95323724076524762 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_UNIT_NAME Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P30305_UNIT_NAME',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit Name must be specified.',
  p_validation_condition=> 'SAVE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 89783127970822303 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 15-JUL-2009 14:37');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 5262600581933557 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_UNIT_NAME must be unique',
  p_validation_sequence=> 1.5,
  p_validation => 'begin'||chr(10)||
'    for k in (select ou.sid'||chr(10)||
'                from t_osi_unit ou, t_osi_unit_name oun'||chr(10)||
'               where oun.unit_name = :P30305_UNIT_NAME and ou.sid = oun.unit and ou.sid <> :p0_obj)'||chr(10)||
'    loop'||chr(10)||
'        return false;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Unit Name must be unique across Activated units.',
  p_when_button_pressed=> 89782710532822301 + wwv_flow_api.g_id_offset,
  p_associated_item=> 89783127970822303 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95323935248524767 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_UNIT_CODE Not Null',
  p_validation_sequence=> 2,
  p_validation => 'P30305_UNIT_CODE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit Code must be specified.',
  p_validation_condition=> 'SAVE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 89783313554822303 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 15-JUL-2009 14:37');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95324137869524767 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_DIBRS_NUM Not Null',
  p_validation_sequence=> 3,
  p_validation => 'P30305_DIBRS_NUM',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'DIBRS ORI Number must be specified.',
  p_validation_condition=> 'SAVE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 89783528755822303 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 15-JUL-2009 14:37');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 95324332037524767 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_FBI_NUM Not Null',
  p_validation_sequence=> 4,
  p_validation => 'P30305_FBI_NUM',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'FBI ORI Number must be specified.',
  p_validation_condition=> 'SAVE',
  p_validation_condition_type=> 'NEVER',
  p_associated_item=> 89783725237822304 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 15-JUL-2009 14:37');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98072838111911020 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_ADDRESS_VALUE not null',
  p_validation_sequence=> 14,
  p_validation => 'P30305_ADDRESS_VALUE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Location must be specified.',
  p_validation_condition_type=> 'NEVER',
  p_when_button_pressed=> 89782710532822301 + wwv_flow_api.g_id_offset,
  p_associated_item=> 97974031073769590 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98073015039913857 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_PARENT_UNIT_SID not null',
  p_validation_sequence=> 24,
  p_validation => 'P30305_PARENT_UNIT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Parent Unit must be specified.',
  p_validation_condition_type=> 'NEVER',
  p_when_button_pressed=> 89782710532822301 + wwv_flow_api.g_id_offset,
  p_associated_item=> 97966732011287237 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 2415913829479553 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_validation_name => 'P30305_UNIT_TYPE',
  p_validation_sequence=> 34,
  p_validation => 'P30305_UNIT_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit Type must be specified.',
  p_when_button_pressed=> 89782710532822301 + wwv_flow_api.g_id_offset,
  p_associated_item=> 97946606637805198 + wwv_flow_api.g_id_offset,
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
p:=p||'#OWNER#:V_OSI_UNIT_INFO:P30305_SID:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 89810419978539618 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'ARP',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
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
'    osi_address.update_single_address(:p30305_sid, ''UNIT_ADDR'', :p30305_address_value);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 97975513936802520 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Address',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Address Update Failed',
  p_process_when=>'(:REQUEST = ''SAVE'' or :REQUEST = ''CREATE'')'||chr(10)||
'and'||chr(10)||
':P30305_ADDRESS_VALUE is not null',
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
'        update t_osi_unit'||chr(10)||
'           set active = ''N'''||chr(10)||
'         where sid = :p0_obj;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5262920975986807 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 50.1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'De-Activate Unit',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>':REQUEST in (''DE_ACTIVATE_UNIT'')'||chr(10)||
'and'||chr(10)||
':P30305_USER_CAN_DE_ACTIVATE = ''Y''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '&SUCCESS_MSG.',
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
'        update t_osi_unit'||chr(10)||
'           set active = ''Y'''||chr(10)||
'         where sid = :p0_obj;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5123204777718915 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 50.2,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Activate Unit',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>':REQUEST in (''ACTIVATE_UNIT'')'||chr(10)||
'and'||chr(10)||
':P30305_USER_CAN_ACTIVATE = ''Y''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '&SUCCESS_MSG.',
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
'    if (:request = ''CANCEL'') then'||chr(10)||
'        :p30305_unit_name := null;'||chr(10)||
'        :p30305_unit_code := null;'||chr(10)||
'        :p30305_dibrs_num := null;'||chr(10)||
'        :p30305_fbi_num := null;'||chr(10)||
'        :p30305_unit_type := null;'||chr(10)||
'        :p30305_uic := null;'||chr(10)||
'        :p30305_iir_loc := null;'||chr(10)||
'        :p30305_crc := null;'||chr(10)||
'        :p30305_address_value := null;'||chr(10)||
'        :p30305_parent_unit_sid := null;'||chr(10)||
'        :p30305_';

p:=p||'parent_unit_display := null;'||chr(10)||
'        :p30305_parent_unit_code := null;'||chr(10)||
'        :p30305_parent_unit_type := null;'||chr(10)||
'        :p30305_parent_unit_ori := null;'||chr(10)||
'        :p30305_parent_unit_uic := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 98568832227493292 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 99,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear items',
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
p:=p||'F|#OWNER#:V_OSI_UNIT_INFO:P30305_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 89793520961085623 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P30305_SID is not null ',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_when2=>'and'||chr(10)||
'nvl(:request,''NULL'') <> ''ADDRESS'' '||chr(10)||
'and'||chr(10)||
'nvl(:request,''NULL'') <> ''P30305_PARENT_UNIT_SID''',
  p_process_when_type2=>'',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>':P30305_SID is not null and'||chr(10)||
':request not in (''P30305_PARENT_UNIT_SID'',''ADDRESS'')');
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
'    --Get LOV''s'||chr(10)||
'    :P30305_UNIT_TYPE_LOV := osi_reference.get_lov(''UNIT_TYPE'', :P30305_UNIT_TYPE);'||chr(10)||
''||chr(10)||
'    :p30305_is_top_level_parent := osi_unit.is_top_level_parent(:p0_obj);'||chr(10)||
''||chr(10)||
'    if (:p30305_is_top_level_parent = ''N'') then'||chr(10)||
'        :p30305_fbi_ori_num_ro :='||chr(10)||
'                                osi_unit.get_fbi_ori_number(osi_unit.get_top_level_parent(:p0_obj));'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    --Get Permission(s';

p:=p||')'||chr(10)||
'    :P30305_USER_CAN_DE_ACTIVATE := osi_auth.check_for_priv(''DELETE'', :P0_OBJ_TYPE_SID);'||chr(10)||
'    :P30305_USER_CAN_ACTIVATE := osi_auth.check_for_priv(''CREATE'', :P0_OBJ_TYPE_SID);'||chr(10)||
'    :P30305_USER_CAN_EDIT := osi_auth.check_for_priv(''EDIT'', :P0_OBJ_TYPE_SID);'||chr(10)||
'    :P30305_USER_CAN_RENAME := osi_auth.check_for_priv(''RENAME'', :P0_OBJ_TYPE_SID);'||chr(10)||
''||chr(10)||
'    --Set Lockouts'||chr(10)||
'    if (:P30305_USER_CAN_RENAME <> ''Y'')';

p:=p||' then'||chr(10)||
'         :P30305_RENAME_LOCKOUT := :DISABLE_TEXT;'||chr(10)||
'    else'||chr(10)||
'         :P30305_RENAME_LOCKOUT := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5063323724773510 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Parameters',
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
p:=p||'begin'||chr(10)||
'    for k in (select unit_code, unit_type, fbi_loc_num, uic'||chr(10)||
'                from t_osi_unit'||chr(10)||
'               where sid = :p30305_parent_unit_sid)'||chr(10)||
'    loop'||chr(10)||
'        :p30305_parent_unit_code := k.unit_code;'||chr(10)||
'        :p30305_parent_unit_ori := k.fbi_loc_num;'||chr(10)||
'        :p30305_parent_unit_uic := k.uic;'||chr(10)||
''||chr(10)||
'        select code'||chr(10)||
'          into :p30305_parent_unit_type'||chr(10)||
'          from t_osi_reference'||chr(10)||
'        ';

p:=p||' where sid = k.unit_type;'||chr(10)||
'    end loop;'||chr(10)||
'exception'||chr(10)||
'    when no_data_found then'||chr(10)||
'        :p30305_parent_unit_type := null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 97970234407410937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30305,
  p_process_sequence=> 30,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Fetch Parent Unit Information',
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
-- ...updatable report columns for page 30305
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


CREATE OR REPLACE FORCE VIEW V_OSI_UNIT_INFO(SID,
                                             UNIT_CODE,
                                             UNIT_NAME,
                                             ACTIVE,
                                             UNIT_PARENT,
                                             UNIT_TYPE,
                                             FBI_LOC_NUM,
                                             UIC,
                                             CRC,
                                             IIR_LOC,
                                             FBI_ORI_NUM) AS
    select SID, unit_code, osi_unit.get_name(SID) unit_name, active, unit_parent, unit_type,
           fbi_loc_num, uic, crc, iir_loc, fbi_ori_num
      from t_osi_unit;


CREATE OR REPLACE TRIGGER osi_unit_info_io_u_01
    instead of update
    on v_osi_unit_info     for each row
begin
    if upper(:new.unit_name) <> upper(:old.unit_name) then
        update t_osi_unit_name
           set end_date = sysdate
         where unit = :new.sid
           and upper(unit_name) = upper(:old.unit_name);

        insert into t_osi_unit_name (unit, unit_name, start_date)
        values (:new.sid, upper(:new.unit_name), sysdate);
    end if;

    update t_osi_unit
       set unit_code = :new.unit_code,
           active = :new.active,
           unit_parent = :new.unit_parent,
           unit_type = :new.unit_type,
           fbi_loc_num = :new.fbi_loc_num,
           uic = :new.uic,
           crc = :new.crc,
           iir_loc = :new.iir_loc,
           fbi_ori_num = :new.fbi_ori_num
     where sid = :new.sid;

    core_obj.bump(:new.sid);
end;
/


-------------------------------------
--- 005 - CFunds_Notification_Bug ---
-------------------------------------
set scan off;
set define off;

CREATE OR REPLACE PACKAGE BODY Osi_Notification AS
/*
  Package: Notification_Pkg - Holds notification processing. Includes
           detection, generation, delivery and cleanup functions. All
           notification routines log their actions to the I2MS.NOTIF
           pipe (using the UTIL.LOGGER package).

  History:
    26-Feb-2002 RWH      Initial version.
    03-Jul-2002 RWH/AES  Added Detect_ACTLEADLATE and Detect_INVINACTIVE.
    29-Oct-2002 AES      Added Detect_PERCHANGED.
    04-Nov-2002 AES      Added Generate_PERCHANGED.
    24-Feb-2003 RWH      Corrected Priv Code usage in Generate_INVHEADSUP.
                         Updated Generate_For_Lead_Agents to not create
                          notifications for the personnel that caused the
                          original event to occur.
    24-Feb-2003 AES      Added Generate_ASGNMADE.
    25-Feb-2003 AES      Added Generate_FLEASSOCFLE, Generate_FLEASSOCACT.
    02-Apr-2004 AES      Added Detect_TMEXPIRATION.
    26-Oct-2005 WCC      Modified the Email_Send and Textmsg_Send functions to
                          filter for OGN addresses only.
    30-Mar-2006 TJW      PR #1854 Added Content-TYPE: text/html;' || to email_send to
                          send messages in html format.  Needed to send links
                          to notifications.
                          Also changes to deliver_generic, deliver_actleaddoneemail,
                          and deliver_invdeathemail.
    30-Mar-2006 TJW      PR #1796 Added notifications for Fraud Cases
                          Added deliver_invfraudemail.  This also requires changes
                          to T_NOTIFICATION_EVENT_TYPE, t_osi_notification_method,
                          T_STATUS_HISTORY.STATHIST_B_I_02, and T_OFFENSE_V2.OFFENSEV2_B_I_02.
    03-Apr-2006 WCC      Updates to deliver procedures and email_send to support FOUO and email length limits.
    10-Aug-2006 WCC      Added DeliverSpot15 and Deliver_INVSPOTEMAIL procedures
    11-Jun-2008 WCC      CheckForIAFISNotifications updated for CR#2634
    30-Sep-2008 WCC      Added a CheckForSurveillanceActivities call into the generate procedure
    07-Sep-2010 JLH      Added generate_cfexpreject
    22-Sep-2010 JAF      CHG0003182 - Added error handling to get_primary_email (post 1.7 build fix).
    09-Nov-2009 TJW      PR#3289 - Added 80, 90, 100 Days Advance Notifications.
                          New Functions checkforcfundadvances and cfundadvanceissuedbydays.
                          Changed in Generate.
    10-Oct-2010 JAF      CHG0003174 - modified deliver_actsurvexpiredemail (currently empty) to return pOK := 'Y'
                         to prevent errors on delivery.
    20-Oct-2010 TJW      PR#3211 - Reviewer Note Notification needed to change generate to
                          update Specifics since :NEW.NOTE_TEXT can not be read in the Trigger.
                           *** These types of notifications can not be Immediate Generation since it will cause a Mutating Trigger.
    25-Oct-2010 TJW      PR#3224 - Check Access Failure Notifications.
                          New Function generate_accessfailed.
    25-Oct-2010 JAF      WCHG0000357 - Removed the priv check from generate_invheadsup.
    01-Dec-2010 JAF      CHG0003182 - Enabled deliver_actsurvexpiredemail.
    19-Jan-2011 WCC      Modified deliver_invspotemail and deliverspot15 to use the sid not code.
    26-Jan-2011 JAF      Modified deliver_generic to omit 'Agent:' label on objects that cannot have a 'Lead Agent' (ie. Cfunds)
*/
    v_pipe             VARCHAR2(50)                       := 'NOTIFICATION';
    v_can_generate     BOOLEAN                            := FALSE;
    -- internal lock to control access to generate routines.
    v_can_deliver      BOOLEAN                            := FALSE;
    -- internal lock to control access to deliver routines.
    v_curr_event_rec   T_OSI_NOTIFICATION_EVENT%ROWTYPE;
    v_sender           VARCHAR2(50)                       := NULL;
    v_sendhost         VARCHAR2(50)                       := NULL;
    v_mailhost         VARCHAR2(30)                       := NULL;
    v_mailport         NUMBER                             := NULL;
    v_max_textmsg      NUMBER                             := NULL;

-- Private support routines
    FUNCTION email_default_addr(pfor IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_OSI_PERSONNEL_CONTACT.VALUE%TYPE   := NULL;
    BEGIN
        FOR e IN (SELECT   VALUE
                      FROM T_OSI_PERSONNEL_CONTACT
                     WHERE personnel = pfor
                       AND TYPE = (SELECT SID
                                     FROM T_OSI_REFERENCE
                                    WHERE USAGE = 'CONTACT_TYPE' AND CODE = 'EMLP')
                       AND VALUE IS NOT NULL
                  ORDER BY modify_on DESC)
        LOOP
            v_rtn := e.VALUE;
            Core_Logger.log_it(v_pipe, 'Default Email Address: ' || v_rtn);
            EXIT;                                                                    -- only need 1
        END LOOP;

        RETURN v_rtn;
    END email_default_addr;

    FUNCTION email_send(precipient IN VARCHAR2, psubject IN VARCHAR2, pmsg IN VARCHAR2)
        RETURN BOOLEAN IS
        v_mail_conn     utl_smtp.connection;
        v_reply         utl_smtp.reply;
        v_tag           VARCHAR2(30);
        v_msg           VARCHAR2(32000);
        v_recipient     VARCHAR2(500);
        v_parent        VARCHAR2(20);
        a_mail_error    EXCEPTION;
        v_mail_suffix   VARCHAR2(20000);

        PROCEDURE log_reply IS
        BEGIN
            Core_Logger.log_it(v_pipe, v_reply.code || ' ' || v_reply.text);
            RETURN;
        END log_reply;
    BEGIN
        v_recipient := LTRIM(RTRIM(precipient));              -- Remove trailing and leading blanks
        v_mail_suffix := Core_Util.GET_CONFIG('OSI.NOTIF_EMAIL_SUFFIX');

        IF     UPPER(v_recipient) LIKE '%' || v_mail_suffix || '%'                 --'%OGN.AF.MIL')
           --AND INSTR(v_recipient, '.') < INSTR(v_recipient, '@')  --JF commented, not needed
           AND REPLACE(TRANSLATE(UPPER(v_recipient),
                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.@',
                                 '**************************************'),
                       '*',
                       '') IS NULL THEN
            IF v_sender IS NULL THEN
                Core_Logger.log_it(v_pipe, 'Getting Email Config Data');
                v_sender := Core_Util.get_config('OSI.NOTIF_SNDR');
                v_sendhost := Core_Util.get_config('OSI.NOTIF_SNDH');
                v_mailhost := Core_Util.get_config('OSI.NOTIF_SRVR');
                v_mailport := Core_Util.get_config('OSI.NOTIF_PORT');
            END IF;

            v_msg :=
                'Subject:FOUO - I2MS Notifications - ' || psubject || utl_tcp.crlf
                || 'Content-TYPE: text/html;' || 'From:I2MS <' || v_sender || '>' || utl_tcp.crlf
                || 'To:' || precipient || utl_tcp.crlf || utl_tcp.crlf
                || '<CENTER><B>This e-mail contains FOR OFFICIAL USE ONLY (FOUO) information which must be protected under the Privacy Act and AFI 33-332.</B></CENTER><HR>'
                || utl_tcp.crlf || REPLACE(pmsg, CHR(13) || CHR(10), '<BR>' || CHR(13) || CHR(10))
                || utl_tcp.crlf
                || '<CENTER><B>This e-mail contains FOR OFFICIAL USE ONLY (FOUO) information which must be protected under the Privacy Act and AFI 33-332.</B></CENTER>';
            Core_Logger.log_it(v_pipe, 'Sending email TO: ' || precipient);
            --CORE_LOGGER.log_it(v_pipe, 'MSG: ' || v_msg);
            v_tag := 'OPEN';
            Core_Logger.log_it(v_pipe, 'Opening Connection: ' || v_mailhost || ' / ' || v_mailport);
            v_reply := utl_smtp.open_connection(v_mailhost, v_mailport, v_mail_conn);
            log_reply;

            IF v_reply.code <> 220 THEN
                RAISE a_mail_error;
            END IF;

            v_tag := 'helo';
            v_reply := utl_smtp.helo(v_mail_conn, v_sendhost);
            log_reply;

            IF v_reply.code <> 250 THEN
                RAISE a_mail_error;
            END IF;

            v_tag := 'mail';
            utl_smtp.mail(v_mail_conn, v_sender);
            v_tag := 'rcpt';
            utl_smtp.rcpt(v_mail_conn, precipient);
            v_tag := 'data';
            utl_smtp.DATA(v_mail_conn, v_msg);
            v_tag := 'quit';
            utl_smtp.quit(v_mail_conn);
            RETURN TRUE;
        ELSE
            Core_Logger.log_it(v_pipe, 'EMAIL_Address Error: ' || precipient);
            RETURN FALSE;
        END IF;
    EXCEPTION
        WHEN a_mail_error THEN
            --utl_smtp.quit(v_mail_conn);
            Core_Logger.log_it(v_pipe, 'EMAIL_Send Error (' || v_tag || '): ' || v_reply.text);
            RETURN FALSE;
        WHEN OTHERS THEN
            --utl_smtp.quit(v_mail_conn);
            Core_Logger.log_it(v_pipe, 'EMAIL_Send Error (' || v_tag || '): ' || SQLERRM);
            Core_Logger.log_it(v_pipe,
                               'EMAIL_Send Error (' || v_tag || '): ' || 'Length: '
                               || TO_CHAR(LENGTH(v_msg)));
            RETURN FALSE;
    END email_send;

    FUNCTION email_update_blank_addresses(pdelivery_method IN VARCHAR2)
        RETURN BOOLEAN IS
        v_cnt   NUMBER;
        v_tmp   VARCHAR2(200);
    BEGIN
        v_cnt := 0;

        FOR n IN (SELECT *
                    FROM T_OSI_NOTIFICATION
                   WHERE delivery_method = pdelivery_method
                     AND delivery_address IS NULL
                     AND delivery_date IS NULL)
        LOOP
            v_tmp := email_default_addr(n.recipient);

            IF v_tmp IS NOT NULL THEN
                UPDATE T_OSI_NOTIFICATION
                   SET delivery_address = v_tmp
                 WHERE SID = n.SID;

                v_cnt := v_cnt + 1;
            END IF;
        END LOOP;

        Core_Logger.log_it(v_pipe, 'Updated ' || v_cnt || ' NULL delivery addresses');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error UPDATING blank email addresses: ' || SQLERRM);
            RETURN FALSE;
    END email_update_blank_addresses;

    FUNCTION find_closest_interest(
        ppersonnel    IN   VARCHAR2,
        pevent_type   IN   VARCHAR2,
        punit         IN   VARCHAR2 := NULL)
        RETURN T_OSI_NOTIFICATION_INTEREST%ROWTYPE IS
/*
    This routine searches the t_osi_notification_interest table for the row
    that most closely matches the input requirements, and returns that
    row as the function result.

    Parameters:
        Personnel  - The personnel to search for. Required.
        Event_Type - The event code to search for. Required.
        Unit       - The unit to search for. If omitted, it
                     means that the interest record must have
                     a Null unit (meaning interest in all units).

    If a unit is specified, that unit is searched first, and then any
    parent and supporting units.
*/
        v_ni_rec           T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_unit             VARCHAR2(20);
        v_subs             NUMBER;
        v_event_type_sid   VARCHAR2(20);
    BEGIN
        --CORE_LOGGER.log_it(v_pipe, '^^^^0:pevent_type=' || pevent_type);
        --SELECT SID INTO V_EVENT_TYPE_SID FROM T_OSI_NOTIFICATION_EVENT_TYPE where CODE = pevent_type;
        --CORE_LOGGER.log_it(v_pipe, '^^^^1');
        -- Check special case where no unit is specified.
        IF punit IS NULL THEN
            Core_Logger.log_it(v_pipe, '^^^^2');
            Core_Logger.log_it(v_pipe, 'IN FIND_CLOSEST_INTEREST:  PUNIT IS NULL!!');
            Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
            Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);

            BEGIN
                SELECT *
                  INTO v_ni_rec
                  FROM T_OSI_NOTIFICATION_INTEREST
                 WHERE personnel = ppersonnel
                   AND event_type = PEVENT_TYPE
                   AND unit IS NULL
                   AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');
                    NULL;
            END;

            RETURN v_ni_rec;
        END IF;

        Core_Logger.log_it(v_pipe, '^^^^3');
        -- Check for interest in specified and parent units
        v_unit := punit;
        Core_Logger.log_it(v_pipe, '^^^^2');

        LOOP
            BEGIN
                Core_Logger.log_it(v_pipe,
                                   'IN FIND_CLOSEST_INTEREST (UNIT OR PARENT):  PUNIT IS ' || v_unit);
                Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
                Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);

                SELECT *
                  INTO v_ni_rec
                  FROM T_OSI_NOTIFICATION_INTEREST
                 WHERE personnel = ppersonnel AND event_type = PEVENT_TYPE AND unit = v_unit;

                RETURN v_ni_rec;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');

                    SELECT unit_parent
                      INTO v_unit
                      FROM T_OSI_UNIT
                     WHERE SID = v_unit;
            END;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        Core_Logger.log_it(v_pipe, '^^^^6');

        -- Check for interest in any supporting unit
        FOR s IN (SELECT DISTINCT sup_unit
                             FROM T_OSI_UNIT_SUP_UNITS
                            WHERE unit = punit)
        LOOP
            BEGIN
                Core_Logger.log_it(v_pipe,
                                   'IN FIND_CLOSEST_INTEREST (SUPPORT):  PUNIT IS ' || punit);
                Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
                Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);

                SELECT *
                  INTO v_ni_rec
                  FROM T_OSI_NOTIFICATION_INTEREST
                 WHERE personnel = ppersonnel AND event_type = PEVENT_TYPE AND unit = s.sup_unit;

                RETURN v_ni_rec;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');
                    NULL;
            END;
        END LOOP;

        -- Check for interest in all units
        BEGIN
            Core_Logger.log_it(v_pipe, 'IN FIND_CLOSEST_INTEREST (ALL):  PUNIT IS ' || punit);
            Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
            Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);
            Core_Logger.log_it(v_pipe, '^^^^10');

            SELECT *
              INTO v_ni_rec
              FROM T_OSI_NOTIFICATION_INTEREST
             WHERE personnel = ppersonnel AND event_type = PEVENT_TYPE AND unit IS NULL;

            RETURN v_ni_rec;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');
                NULL;
        END;

        Core_Logger.log_it(v_pipe, '^^ NO INTEREST FOUND!');
        RETURN NULL;                                                        -- no place else to look
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error during Find_Closest_Interest: ' || SQLERRM);
            RETURN NULL;
    END find_closest_interest;

    FUNCTION insert_notification(
        precipient          IN   VARCHAR2,
        pdelivery_method    IN   VARCHAR2,
        pdelivery_address   IN   VARCHAR2)
        RETURN BOOLEAN IS
        v_nm_rec   T_OSI_NOTIFICATION_METHOD%ROWTYPE;
        v_sid      VARCHAR2(20);
    BEGIN
        IF pdelivery_method IS NOT NULL THEN
            SELECT *
              INTO v_nm_rec
              FROM T_OSI_NOTIFICATION_METHOD
             WHERE SID = pdelivery_method;
        END IF;

        v_sid := Core_Sidgen.next_sid;

        INSERT INTO T_OSI_NOTIFICATION
                    (SID,
                     event,
                     recipient,
                     generation_date,
                     delivery_method,
                     delivery_address,
                     delivery_date)
             VALUES (v_sid,
                     v_curr_event_rec.SID,
                     precipient,
                     SYSDATE,
                     pdelivery_method,
                     pdelivery_address,
                     NULL);

        IF UPPER(v_nm_rec.immediate_delivery) = 'Y' THEN
            deliver(v_sid);
        END IF;

        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, 'Error IN Insert_Notification: Invalid Delivery Method');
            RETURN FALSE;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error IN Insert_Notification: ' || SQLERRM);
            RETURN FALSE;
    END insert_notification;

    FUNCTION textmsg_send(precipient IN VARCHAR2, psubject IN VARCHAR2, pmsg IN VARCHAR2)
        RETURN BOOLEAN IS
        v_mail_conn   utl_smtp.connection;
        v_tag         VARCHAR2(30);
        v_msg         VARCHAR2(32000);
        v_recipient   VARCHAR2(500);
    BEGIN
        v_recipient := LTRIM(RTRIM(precipient));              -- Remove trailing and leading blanks

        IF     UPPER(v_recipient) LIKE '%OGN.AF.MIL'
           AND REPLACE(TRANSLATE(UPPER(v_recipient),
                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.@',
                                 '**************************************'),
                       '*',
                       '') IS NULL THEN
            IF v_sender IS NULL THEN
                v_sender := Core_Util.get_config('NOTIF_SNDR');
                v_mailhost := Core_Util.get_config('NOTIF_SRVR');
                v_mailport := Core_Util.get_config('NOTIF_PORT');
            END IF;

            IF v_max_textmsg IS NULL THEN
                v_max_textmsg := Core_Util.get_config('NOTIF_MAX1');
                v_max_textmsg := NVL(v_max_textmsg, 200);
            END IF;

            v_msg := 'Subject: FOUO - ' || psubject || utl_tcp.crlf || utl_tcp.crlf || pmsg;
            v_msg := SUBSTR(v_msg, 1, v_max_textmsg);
            Core_Logger.log_it(v_pipe, 'Sending text message TO: ' || precipient);
            v_tag := 'OPEN';
            v_mail_conn := utl_smtp.open_connection(v_mailhost, v_mailport);
            v_tag := 'helo';
            utl_smtp.helo(v_mail_conn, v_mailhost);
            v_tag := 'mail';
            utl_smtp.mail(v_mail_conn, v_sender);
            v_tag := 'rcpt';
            utl_smtp.rcpt(v_mail_conn, precipient);
            v_tag := 'data';
            utl_smtp.DATA(v_mail_conn, v_msg);
            v_tag := 'quit';
            utl_smtp.quit(v_mail_conn);
            RETURN TRUE;
        ELSE
            Core_Logger.log_it(v_pipe, 'TEXT_Address Error: ' || precipient);
            RETURN FALSE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'TEXTMSG_Send Error (' || v_tag || '): ' || SQLERRM);
            RETURN FALSE;
    END textmsg_send;

-- Generic Routines (don't need TO be PUBLIC because they are normally called
-- in error handling situations, but they do need to be after all other private
-- support routines.)
    PROCEDURE generate_generic(pok OUT VARCHAR2) IS
/*
    Generate notifications for any personnel interested in the current event
    for the impacted unit. The interest determines the delivery method.
*/
        v_ni_rec       T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        a_problem      EXCEPTION;
        v_event_code   VARCHAR(30);
    BEGIN
        FOR a IN (SELECT DISTINCT personnel
                             FROM T_OSI_NOTIFICATION_INTEREST
                            WHERE event_type = v_curr_event_rec.event_code)
        LOOP
            -- Determine interest and extract delivery method
            v_ni_rec :=
                find_closest_interest(a.personnel,
                                      v_curr_event_rec.event_code,
                                      v_curr_event_rec.impacted_unit);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT insert_notification(a.personnel,
                                           v_ni_rec.delivery_method,
                                           v_ni_rec.delivery_address) THEN
                    RAISE a_problem;
                END IF;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: In Generate_Generic' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_generic;

    PROCEDURE generate_for_lead_agents(pok OUT VARCHAR2) IS
/*
    Generate notification for lead agent of the file/activity, assuming
    the lead agent specified an interest in this type of notification.
    The interest determines the delivery method.
*/
        v_ni_rec    T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        a_problem   EXCEPTION;
    BEGIN
        FOR a IN (SELECT   *
                      FROM T_OSI_ASSIGNMENT
                     WHERE obj = v_curr_event_rec.PARENT
                       AND assign_role IN(SELECT SID
                                            FROM T_OSI_ASSIGNMENT_ROLE_TYPE
                                           WHERE UPPER(DESCRIPTION) IN('LEAD AGENT', 'EXAMINER'))
                       AND Osi_Personnel.GET_NAME(PERSONNEL) <> v_curr_event_rec.event_by
                  ORDER BY start_date DESC)
        LOOP
            Core_Logger.log_it(v_pipe, 'Found Lead Agent: ' || Osi_Personnel.GET_NAME(a.PERSONNEL));
            -- Determine interest and extract delivery method
            v_ni_rec :=
                find_closest_interest(a.personnel,
                                      v_curr_event_rec.event_code,
                                      v_curr_event_rec.impacted_unit);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT insert_notification(a.personnel,
                                           v_ni_rec.delivery_method,
                                           v_ni_rec.delivery_address) THEN
                    RAISE a_problem;
                END IF;
            ELSE
                Core_Logger.log_it(v_pipe, 'No interest indicated.');
            END IF;

            EXIT;                                            -- only need the most recent lead agent
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_for_lead_agents;

    PROCEDURE deliver_generic(
        pdeliverymethod   IN       VARCHAR2,
        pok               OUT      VARCHAR2,
        pthis1            IN       VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(10);                                          -- newline
    BEGIN
        Core_Logger.log_it(v_pipe, '>> DELIVER_GENERIC ');
        pok := 'N';

        IF NOT email_update_blank_addresses(pdeliverymethod) THEN
            Core_Logger.log_it(v_pipe, 'EMAIL UPDATE BLANK ADDRESSES: FALSE');
            RETURN;
        END IF;

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address, net.description
                             FROM T_OSI_NOTIFICATION n,
                                  T_OSI_NOTIFICATION_EVENT ne,
                                  T_OSI_NOTIFICATION_EVENT_TYPE net
                            WHERE n.delivery_method = pdeliverymethod
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL)
                              AND ne.SID = n.event
                              AND net.SID = ne.event_code)
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = pdeliverymethod
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                Core_Logger.log_it(v_pipe, 'INSIDE TEST LOOP');
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || ' ' || Get_Config('DEFAULTINI') || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';

                if n.event_by <> 'get_name: Error' then  --occurs on objects that cannot have a 'Lead Agent'
                   v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                end if;

                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || '<BR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, a.description, v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        Core_Logger.log_it(v_pipe, '<< DELIVER_GENERIC ');
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
            Core_Logger.log_it(v_pipe, '<< DELIVER_GENERIC ');
    END deliver_generic;

-- DETECTION
    PROCEDURE detect_actleadlate IS
        v_event_by        VARCHAR2(50)   := 'Detect_ACTLEADLATE';
        --Current Event is Detect_ACTLEADLATE
        v_event_type      VARCHAR2(50)   := 'ACT.LEADLATE';      --Event_Type for this notification
        v_lag_code        VARCHAR2(50)   := 'OSI.NOTIF_LAT1';
        --CODE in T_I2MS_CONFIG for Activity Lead Past Suspense Date
        v_lag             NUMBER         := 0; --time lag allowed for inactivity past suspense date
        v_counter         NUMBER         := 0;                            --count resulting records
        v_parent          VARCHAR2(200);
        v_parent_info     VARCHAR2(200);
        v_event_on        DATE;
        v_impacted_unit   VARCHAR2(200);
        v_specifics       VARCHAR2(1000);
    BEGIN
           -- Loop through all the activities
        -- where the auxiliary unit and the created_by unit are different,
        -- the current date is past the suspense date by v_LAG
        -- and the complete and closed dates are null
        Core_Logger.log_it(v_pipe, '>>> ' || v_event_by || ': started');          --Start Procedure
        v_lag := Core_Util.get_config(v_lag_code);                  --GET v_lag based on v_lag_code

        FOR n IN (SELECT a.*
                    FROM v_osi_activity_summary a
                   WHERE a.creating_unit <> a.auxiliary_unit
                     AND a.suspense_date IS NOT NULL
                     AND (a.suspense_date <= SYSDATE - v_lag)
                     AND a.complete_date IS NULL
                     AND a.close_date IS NULL)
        LOOP
            v_counter := v_counter + 1;
            v_parent := n.SID;
            v_parent_info := n.ID || ' - ' || n.title;
            v_event_on := SYSDATE;
            v_impacted_unit := NULL;

            FOR i IN (SELECT *
                        FROM T_OSI_UNIT
                       WHERE UNIT_CODE = n.CREATING_UNIT)
            LOOP
                v_impacted_unit := i.SID;
            END LOOP;

            --v_impacted_unit := n.creating_unit;
            v_specifics := 'Assigned to Unit ' || n.assigned_unit;
            v_specifics := v_specifics || ' with a Suspense Date of ' || n.suspense_date;
            Osi_Notification.record_detection(v_event_type,
                                              v_parent,
                                              v_parent_info,
                                              v_event_by,
                                              v_event_on,
                                              v_impacted_unit,
                                              v_specifics);
        -- CORE_LOGGER.log_it(v_pipe, '>>> ' || v_Event_By || ' ' || v_counter || '. ' || v_Parent || ' / ' || v_Parent_Info);
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, v_counter || ' records found.');
        Core_Logger.log_it(v_pipe, '<<< ' || v_event_by || ': stopped');            --Stop Procedure
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': No Data Found');
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': Error: ' || SQLERRM);
    END detect_actleadlate;

    PROCEDURE detect_invinactive IS
        v_event_by           VARCHAR2(50)   := 'Detect_INVINACTIVE';
        --Current Event is Detect_INVINACTIVE
        v_event_type         VARCHAR2(50)   := 'INV.INACTIVE';   --Event_Type for this notification
        v_lag_code           VARCHAR2(50)   := 'OSI.NOTIF_LAT2';
        --CODE in T_I2MS_CONFIG for No Activity on Open Investigation.
        v_type_code          VARCHAR2(50)   := 'INVSTGTV';
        --CODE in T_FILE_V2 for Investigative Files
        v_lag                NUMBER         := 0; --time lag allowed for inactivity past given date
        v_counter            NUMBER         := 0;                         --count resulting records
        v_parent             VARCHAR2(200);
        v_parent_info        VARCHAR2(200);
        v_event_on           DATE;
        v_impacted_unit      VARCHAR2(200);
        v_specifics          VARCHAR2(1000);
        x_active             EXCEPTION;                     --FLAG for files which are still active
        v_last_modify_by     VARCHAR2(200);                                 --Most recent Modify By
        v_last_modify_on     DATE;                                     --Most recent Modify On date
        v_last_modify_desc   VARCHAR2(50);               --Most recently modified table description
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> ' || v_event_by || ': started');          --Start Procedure
        v_lag := Core_Util.get_config(v_lag_code);                  --GET v_lag based on v_lag_code

        -- Initially loop through candidate records in T_FILE_V2
        -- Only look at Investigative Files (TYPE_CODE='INVSTGTV') and
        -- Only look at those with inactivity (MODIFY_ON <= sysdate - v_lag)
        -- Only look at Open Investigative Files (STATUS ='OP' )
        FOR n IN (SELECT obj.SID AS OBJ_SID, obj.MODIFY_ON AS obj_modify_on,
                         obj.MODIFY_BY AS OBJ_MODIFY_BY, fyle.*,
                         Osi_File.GET_UNIT_OWNER(fyle.SID) AS OWNING_UNIT,
                         Osi_Object.GET_STATUS(obj.SID) AS CURRENT_STATUS
                    FROM T_OSI_FILE fyle, T_OSI_F_INVESTIGATION inv, T_CORE_OBJ obj
                   WHERE fyle.SID = inv.SID
                     AND fyle.SID = obj.SID
                     AND (obj.modify_on <= SYSDATE - v_lag)
                     AND UPPER(Osi_Object.GET_STATUS(obj.SID)) = 'OPEN')
        LOOP
            BEGIN
                v_parent := n.SID;
                v_parent_info := n.ID || ' - ' || n.title;
                v_event_on := SYSDATE;
                v_impacted_unit := n.owning_unit;
                v_last_modify_by := n.obj_modify_by;
                v_last_modify_on := n.obj_modify_on;
                v_last_modify_desc := 'Investigative File';

                --Look at each T_INVESTIGATIVE child table:
                --   T_ARREST, T_INVESTIGATIVE_CR05, T_INVESTIGATIVE_CR17, T_INVESTIGATIVE_DISPOSITION,
                --   T_OFFENSE_V2, T_SPECIFICATION_V2, T_SUBJECT_DISPOSITION, T_PROPERTY, T_INCIDENT
                BEGIN
                    --Look for updates to child tables
                    FOR m IN (
                              /*select 'Arrest' modify_desc, modify_by, modify_on
                                from t_arrest
                               where investigation = v_parent
                              union
                              select 'CR05' modify_desc, modify_by, modify_on
                                from t_investigative_cr05
                               where investigation = v_parent
                              union
                              select 'CR17' modify_desc, modify_by, modify_on
                                from t_investigative_cr17
                               where investigation = v_parent

                              union*/
                              SELECT 'Investigative Disposition' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_DISPOSITION
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Offense' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_OFFENSE
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Specification' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_SPEC
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Subject Disposition' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_SUBJ_DISPOSITION
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Property' modify_desc, p.modify_by, p.modify_on
                                FROM T_OSI_F_INV_PROPERTY p, T_OSI_F_INV_SPEC s
                               WHERE p.SPECIFICATION = s.SID AND s.investigation = v_parent
                              UNION
                              SELECT 'Incident' modify_desc, a.modify_by, a.modify_on
                                FROM T_OSI_F_INV_INCIDENT a, T_OSI_F_INV_INCIDENT_MAP b
                               WHERE b.investigation = v_parent AND b.incident = a.SID)
                    LOOP
                        --Determine the most recent table update
                        IF m.modify_on > v_last_modify_on THEN
                            v_last_modify_on := m.modify_on;
                            v_last_modify_by := m.modify_by;
                            v_last_modify_desc := m.modify_desc;
                        ELSIF m.modify_on = v_last_modify_on THEN
                            --track all changes with the same date
                            v_last_modify_by := v_last_modify_by || ' & ' || m.modify_by;
                            v_last_modify_desc := v_last_modify_desc || ' & ' || m.modify_desc;
                        END IF;
                    END LOOP;

                    --If the latest Modify_On date is recent then current record is active)
                    IF (v_last_modify_on > SYSDATE - v_lag) THEN
                        RAISE x_active;
                    END IF;
                EXCEPTION
                    --If NO_DATA_FOUND then there are no recent updates to the Investigative File
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                v_specifics := 'Last Modified ' || RTRIM(v_last_modify_desc);
                v_specifics := v_specifics || ' on ' || v_last_modify_on;
                v_specifics := v_specifics || ' by ' || v_last_modify_by;
                Core_Logger.log_it(v_pipe, 'ABOUT TO DO RECORED_DETECTION');
                Osi_Notification.record_detection(v_event_type,
                                                  v_parent,
                                                  v_parent_info,
                                                  v_event_by,
                                                  v_event_on,
                                                  v_impacted_unit,
                                                  v_specifics);
                v_counter := v_counter + 1;
                Core_Logger.log_it(v_pipe,
                                   '>>> ' || v_Event_By || ' ' || v_counter || '. ' || v_Parent
                                   || ' / ' || v_Parent_Info);
            EXCEPTION
                WHEN x_active THEN
                    NULL;             --If the File is Active then exclude it from the Notification
                WHEN OTHERS THEN
                    Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': Error: ' || SQLERRM);
            END;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, '<<< ' || v_event_by || ': stopped');            --Stop Procedure
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, '!!!! ' || v_event_by || ': No Data Found');
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!!! ' || v_event_by || ': Error: ' || SQLERRM);
    END detect_invinactive;

    PROCEDURE detect_perchanged IS
        v_event_type       VARCHAR2(50)                                  := 'PER.CHANGED';
        --Event_Type for this notification
        v_begin_run_code   VARCHAR2(50)                                  := 'OSI.NOTIF_LR1';
        --CODE in T_I2MS_CONFIG for begin date/time range to run Detect_PERCHANGED
        v_end_run_code     VARCHAR2(50)                                  := 'OSI.NOTIF_LR2';
        --CODE in T_I2MS_CONFIG for end date/time range to run Detect_PERCHANGED
        v_begin_run        DATE;                                            --begin date/time range
        v_end_run          DATE;                                         --end date/time code range
        v_cnt              NUMBER                                        := 0;
        --count resulting records
        v_parent           T_OSI_NOTIFICATION_EVENT.PARENT%TYPE;
        v_last_parent      T_OSI_NOTIFICATION_EVENT.PARENT%TYPE;
        v_parent_info      T_OSI_NOTIFICATION_EVENT.parent_info%TYPE;
        v_event_by         T_OSI_NOTIFICATION_EVENT.event_by%TYPE;
        v_event_on         T_OSI_NOTIFICATION_EVENT.event_on%TYPE;
        v_impacted_unit    T_OSI_NOTIFICATION_EVENT.impacted_unit%TYPE;
        v_specifics        T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
        v_count            NUMBER;
    BEGIN
        --GET PREVIOUS DATE RANGE
        v_begin_run := TO_DATE(Core_Util.get_config(v_begin_run_code), 'DD-MON-YYYY hh24:mi:ss');
        --GET begin date/time range fron I2MS Config
        v_end_run := TO_DATE(Core_Util.get_config(v_end_run_code), 'DD-MON-YYYY hh24:mi:ss');
                                                         --GET end date/time range fron I2MS Config
        --UPDATE DATE RANGE
        v_begin_run := v_end_run;
        v_end_run := SYSDATE;
        Core_Logger.log_it(v_pipe, 'BEGIN RUN: ' || v_begin_run);
        Core_Logger.LOG_IT(v_pipe, 'END RUN:   ' || v_end_run);

        --update I2MS_CONFIG table with new begin and end dates
        UPDATE T_CORE_CONFIG
           SET setting = TO_CHAR(v_begin_run, 'DD-MON-YYYY hh24:mi:ss')
         WHERE code = v_begin_run_code;

        UPDATE T_CORE_CONFIG
           SET setting = TO_CHAR(v_end_run, 'DD-MON-YYYY hh24:mi:ss')
         WHERE code = v_end_run_code;

        Core_Logger.log_it(v_pipe,
                           '>>> Detect_PERCHANGED: started. Date Range:' || v_begin_run || '-'
                           || v_end_run);                                          --Start Procedure
        Core_Logger.log_it('I2MS.DEBUG',
                           '>>> Detect_PERCHANGED started. Date Range:' || v_begin_run || '-'
                           || v_end_run);                                          --Start Procedure
        v_last_parent := NULL;
        Core_Logger.log_it(v_pipe, v_begin_run);
        Core_Logger.LOG_IT(v_pipe, v_end_run);

        -- Loop through all participants changed since Detect_PERCHANGED was last run
        --This includes participants with a different T_PERSON_VERSION.SID but the same T_PERSON_VERSION.PERSON
        FOR m IN (
                  --GET ALL PERSON_VERSIONS WHICH HAVE BEEN MODIFIED
                  --FIND THE PERSON LINKED TO THAT PERSON_VERSION
                  SELECT   pv.participant, pvs.partic_version, pvs.modify_by, pvs.modify_on
                      FROM T_OSI_PARTICIPANT_VERSION pv,
                           (
                            --GET ALL MODIFY_ON DATES AFTER v_last_run FROM PERSON-RELATED TABLES
                            SELECT SID partic_version, modify_by, modify_on
                              FROM T_OSI_PARTICIPANT_VERSION
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT partic_a partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_RELATION
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT partic_b partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_RELATION
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_NUMBER
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_MARK
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_NAME
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_CONTACT
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_ADDRESS
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run) pvs
                     WHERE pv.SID = pvs.partic_version
                  ORDER BY pv.participant, pvs.modify_on DESC)
        LOOP
            Core_Logger.log_it(v_pipe, 'INSIDE LOOP SO AT LEAST ONE RECORD FOUND!!!');
            v_parent := m.participant;
            v_event_by := m.modify_by;
            v_event_on := m.modify_on;
            v_impacted_unit := NULL;
            v_specifics := NULL;

            FOR I IN (SELECT *
                        FROM T_CORE_PERSONNEL
                       WHERE Osi_Personnel.GET_NAME(SID) = UPPER(v_event_by))
            LOOP
                v_EVENT_BY := I.SID;
            END LOOP;

            --LOOP ONCE FOR EACH PERSON
            IF v_last_parent <> v_parent THEN
                v_cnt := v_cnt + 1;                         --ONLY COUNT ONCE FOR EACH PERSON FOUND
                v_parent_info := Osi_Participant.GET_NAME(v_parent);
                --GET FIRST AVAILABLE NAME (LEGAL NAME IF IT EXISTS)
                Core_Logger.log_it(v_pipe,
                                   '>>> ' || v_event_by || ' ' || v_event_on || ' ' || v_cnt || '. '
                                   || v_parent || ' [' || v_parent_info || '] ' || m.modify_by
                                   || ':::' || m.modify_on);
                Core_Logger.log_it('I2MS.DEBUG',
                                   '>>> ' || v_event_by || ' ' || v_event_on || ' ' || v_cnt || '. '
                                   || v_parent || ' [' || v_parent_info || '] ' || m.modify_by
                                   || ':::' || m.modify_on);
                Osi_Notification.record_detection(v_event_type,
                                                  v_parent,
                                                  v_parent_info,
                                                  v_event_by,
                                                  v_event_on,
                                                  v_impacted_unit,
                                                  v_specifics);
            END IF;

            v_last_parent := m.participant;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, v_cnt || ' records found.');
        Core_Logger.log_it(v_pipe, '<<< Detect_PERCHANGED: stopped');               --Stop Procedure
        Core_Logger.log_it('I2MS.DEBUG', v_cnt || ' records found.');
        Core_Logger.log_it('I2MS.DEBUG', '<<< Detect_PERCHANGED: stopped');         --Stop Procedure
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': No Data Found');
            Core_Logger.log_it('I2MS.DEBUG', '!!! ' || v_event_by || ': No Data Found');
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': Error: ' || SQLERRM);
            Core_Logger.log_it('I2MS.DEBUG', '!!! ' || v_event_by || ': Error: ' || SQLERRM);
    END detect_perchanged;

    PROCEDURE detect_tmexpiration IS
        v_event_by           VARCHAR2(50)                                  := 'Detect_TMEXPIRATION';
        --Current Event is Detect_TMEXPIRATION
        v_event_type         VARCHAR2(50)                                  := 'TM.EXPIRATION';
        --Event_Type for this notification
        v_counter            NUMBER                                        := 0;
        --count resulting records
        v_subcounter         NUMBER                                        := 0; --count duplicates
        v_months_until_exp   NUMBER                                        := 0;
        --number of months until expiration date
        v_reminder_text      VARCHAR2(100)                                 := '';
        v_code_attendee      VARCHAR2(100)                                 := '';
        v_parent             T_OSI_NOTIFICATION_EVENT.PARENT%TYPE;
        v_parent_info        T_OSI_NOTIFICATION_EVENT.parent_info%TYPE;
        v_event_on           T_OSI_NOTIFICATION_EVENT.event_on%TYPE;
        v_impacted_unit      T_OSI_NOTIFICATION_EVENT.impacted_unit%TYPE;
        v_specifics          T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
    BEGIN
        NULL;
    END detect_tmexpiration;

    PROCEDURE record_detection(
        pevent_type      IN   VARCHAR2,
        pparent          IN   VARCHAR2,
        pparent_info     IN   VARCHAR2,
        pevent_by        IN   VARCHAR2,
        pevent_on        IN   DATE,
        pimpacted_unit   IN   VARCHAR2,
        pspecifics       IN   VARCHAR2) IS
/*
    This routine is used by various database triggers and timed jobs
    to record event detections. This routine verifies that the event
    type is valid, and also determines if the event should be immediately
    generated. If so, it generates the notifications for the event.

    Parameters: (Correspond to columns of T_NOTIFICATION_EVENT)
*/
        v_net_rec   T_OSI_NOTIFICATION_EVENT_TYPE%ROWTYPE;
        v_sid       VARCHAR2(20);
    BEGIN
        Core_Logger.log_it(v_pipe, 'RECORD_DETECTION CALLED / EVENT_TYPE: ' || pevent_type);

        SELECT *
          INTO v_net_rec
          FROM T_OSI_NOTIFICATION_EVENT_TYPE
         WHERE code = pevent_type;

        Core_Logger.log_it(v_pipe, 'DEBUG: EVENT_TYPE: ' || pevent_type);

        IF UPPER(v_net_rec.active) <> 'Y' THEN
            Core_Logger.log_it(v_pipe,
                               'Record_Detection: Inactive Event Type - ' || v_net_rec.code);
            RETURN;
        END IF;

        v_sid := Core_Sidgen.NEXT_SID;
        --SELECT SID INTO pevent_type FROM T_OSI_NOTIFICATION_EVENT_TYPE WHERE CODE = pevent_type;
        Core_Logger.log_it(v_pipe, 'RECORD_DETECTION ABOUT TO INSERT EVENT');

        INSERT INTO T_OSI_NOTIFICATION_EVENT
                    (SID,
                     event_code,
                     PARENT,
                     parent_info,
                     event_by,
                     event_on,
                     impacted_unit,
                     specifics,
                     GENERATED)
             VALUES (v_sid,
                     v_net_rec.SID,
                     pparent,
                     pparent_info,
                     pevent_by,
                     pevent_on,
                     pimpacted_unit,
                     pspecifics,
                     'N');

        Core_Logger.log_it(v_pipe, 'Record_Detection: ' || pevent_type || ' on ' || pparent_info);

        -- Check for immediate generation
        IF UPPER(v_net_rec.immediate_generation) = 'Y' THEN
            Core_Logger.log_it(v_pipe, 'Record_Detection: Immediate Generation Requested');
            generate(v_sid);
        END IF;

        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, 'Error in Record_Detection. Details follow:');
            Core_Logger.log_it(v_pipe, '.  Event Type:  ' || pevent_type);
            Core_Logger.log_it(v_pipe, '.  Error Msg:   Invalid event type');
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error in Record_Detection. Details follow:');
            Core_Logger.log_it(v_pipe, '.  Event Type:  ' || pevent_type);
            Core_Logger.log_it(v_pipe, '.  Parent Info: ' || pparent_info);
            Core_Logger.log_it(v_pipe, '.  Specifics:   ' || pspecifics);
            Core_Logger.log_it(v_pipe, '.  Error Msg:   ' || SQLERRM);
            RETURN;
    END record_detection;

    PROCEDURE checkcasesapproachingdaysopen IS
        v_cnt                  NUMBER;
        v_records              NUMBER;
        v_lastsid              VARCHAR2(20)                              := '~~~VERY_FIRST_ONE~~~';
        v_lastid               VARCHAR2(100);
        v_lasttitle            VARCHAR2(300);
        v_lastopened           DATE;
        v_unit                 VARCHAR2(20);
        v_specifics            T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
        v_status_sid           VARCHAR2(20)                              := NULL;
        v_event_sid_not_code   VARCHAR2(20)                              := NULL;
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> CheckCasesApproachingDaysOpen');

-----------------------------------------------------
-----------------------------------------------------
-- Check for Fraud Cases approaching 180 days open --
-----------------------------------------------------
-----------------------------------------------------
        SELECT SID
          INTO v_status_sid
          FROM T_OSI_STATUS
         WHERE CODE = 'OP';

        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_F_INVESTIGATION f, T_OSI_F_INV_OFFENSE o
         WHERE f.SID = o.investigation
           AND o.offense IN(
                   SELECT SID
                     FROM T_DIBRS_OFFENSE_TYPE
                    WHERE CODE IN
                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-', '132-F-', '083-A-',
                               '083-B-'))
           AND Get_Days_Since_Opened(f.SID) = 178;

        Core_Logger.log_it(v_pipe,
                           'Generating Events for Fraud Cases Approaching 180 Days Open:  '
                           || v_records || ' case(s) found!');

        FOR fraud IN (SELECT   f.SID AS fyle, f.ID AS ID, f.title AS title,
                               Osi_Status.last_sh_date(f.SID, 'OP') AS opened,
                               dot.description AS odesc
                          FROM T_OSI_FILE f, T_OSI_F_INV_OFFENSE o, T_DIBRS_OFFENSE_TYPE dot
                         WHERE f.SID = o.investigation
                           AND dot.SID = o.offense
                           AND o.offense IN(
                                   SELECT SID
                                     FROM T_DIBRS_OFFENSE_TYPE
                                    WHERE CODE IN
                                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-',
                                               '132-F-', '083-A-', '083-B-'))
                           AND Get_Days_Since_Opened(f.SID) = 178
                      ORDER BY f.SID, o.offense)
        LOOP
            BEGIN
                IF v_lastsid <> fraud.fyle THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT unit_sid
                          INTO v_unit
                          FROM T_OSI_F_UNIT
                         WHERE file_sid = v_lastsid AND end_date IS NULL;

                        Core_Logger.LOG_IT('NOTIFICATION', 'UNIT SID: ' || v_unit);

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = 'INV.FRAUD.180' AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES (NULL,
                                         'INV.FRAUD.180',
                                         v_lastsid,
                                         'File:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_unit,
                                         'Fraud Offenses:' || v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := fraud.fyle;
                    v_lastid := fraud.ID;
                    v_lasttitle := fraud.title;
                    v_lastopened := fraud.opened;
                    v_cnt := 1;
                    v_specifics := ' (' || v_cnt || ') ' || fraud.odesc;
                ELSE
                    v_cnt := v_cnt + 1;
                    v_specifics := v_specifics || ' (' || v_cnt || ') ' || fraud.odesc;
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = 'INV.FRAUD.180' AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                Core_Logger.log_it(v_pipe,
                                   '>>> CheckCasesApproachingDaysOpen: About to insert event');
                Core_Logger.log_it(v_pipe,
                                   '>>> CheckCasesApproachingDaysOpen: V_LAST_SID:' || v_lastsid);

                SELECT SID
                  INTO v_event_sid_not_code
                  FROM T_OSI_NOTIFICATION_EVENT_TYPE
                 WHERE CODE = 'INV.FRAUD.180';

                SELECT unit_sid
                  INTO v_unit
                  FROM T_OSI_F_UNIT
                 WHERE file_sid = v_lastsid AND end_date IS NULL;

                Core_Logger.LOG_IT('NOTIFICATION', 'UNIT SID: ' || v_unit);

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'File:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             'Fraud Offenses:' || v_specifics,
                             'N');
            END IF;
        END IF;

        Core_Logger.log_it(v_pipe, '>>> CheckCasesApproachingDaysOpen: EVENT INSERTED');
-------------------------------------------------------
-------------------------------------------------------
-- Check for Criminal Cases approaching 90 days open --
-------------------------------------------------------
-------------------------------------------------------
        v_cnt := 0;
        v_records := 0;
        v_lastsid := '~~~VERY_FIRST_ONE~~~';
        v_lastid := '';
        v_lasttitle := '';
        v_lastopened := NULL;
        v_unit := '';
        v_specifics := NULL;

        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_FILE f, T_OSI_F_INV_OFFENSE o
         WHERE f.SID = o.investigation
           AND o.offense NOT IN(
                   SELECT SID
                     FROM T_DIBRS_OFFENSE_TYPE
                    WHERE CODE IN
                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-', '132-F-', '083-A-',
                               '083-B-'))
           AND Get_Days_Since_Opened(f.SID) = 88;

        Core_Logger.log_it(v_pipe,
                           'Generating Events for Criminal Cases Approaching 90 Days Open:  '
                           || v_records || ' case(s) found!');

        FOR fraud IN (SELECT   f.SID AS fyle, f.ID AS ID, f.title AS title,
                               Osi_Status.last_sh_date(f.SID, 'OP') AS opened,
                               dot.description AS odesc
                          FROM T_OSI_FILE f, T_OSI_F_INV_OFFENSE o, T_DIBRS_OFFENSE_TYPE dot
                         WHERE f.SID = o.investigation
                           AND dot.SID = o.offense
                           AND o.offense NOT IN(
                                   SELECT SID
                                     FROM T_DIBRS_OFFENSE_TYPE
                                    WHERE CODE IN
                                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-',
                                               '132-F-', '083-A-', '083-B-'))
                           AND Get_Days_Since_Opened(f.SID) = 88
                      ORDER BY f.SID, o.offense)
        LOOP
            BEGIN
                IF v_lastsid <> fraud.fyle THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT unit_sid
                          INTO v_unit
                          FROM T_OSI_F_UNIT
                         WHERE file_sid = v_lastsid AND end_date IS NULL;

                        SELECT SID
                          INTO v_event_sid_not_code
                          FROM T_OSI_NOTIFICATION_EVENT_TYPE
                         WHERE CODE = 'INV.CRIME.90';

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES (NULL,
                                         v_event_sid_not_code,
                                         v_lastsid,
                                         'File:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_unit,
                                         'Offenses:' || v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := fraud.fyle;
                    v_lastid := fraud.ID;
                    v_lasttitle := fraud.title;
                    v_lastopened := fraud.opened;
                    v_cnt := 1;
                    v_specifics := ' (' || v_cnt || ') ' || fraud.odesc;
                ELSE
                    v_cnt := v_cnt + 1;
                    v_specifics := v_specifics || ' (' || v_cnt || ') ' || fraud.odesc;
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'INV.CRIME.90';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                SELECT unit_sid
                  INTO v_unit
                  FROM T_OSI_F_UNIT
                 WHERE file_sid = v_lastsid AND end_date IS NULL;

                Core_Logger.LOG_IT('NOTIFICATION', 'UNIT SID: ' || v_unit);

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'File:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             'Offenses:' || v_specifics,
                             'N');
            END IF;
        END IF;

        Core_Logger.log_it(v_pipe, '<<< CheckCasesApproachingDaysOpen');
    END checkcasesapproachingdaysopen;

--    18-Jun-08 TJW      PR#2702 - Make sure File/Activity ID shows in text incase HTML Link doesn't work.
--                     Changed in checkforiafisnotifications.

    -------------------------------------------------------------------------------------------------
---- PR#1967 - Notifications for IAFIS                                                       ----
----           New Function                                                                  ----
---- PR#2634 - Added OR R.RESPONSE_TEXT LIKE '%Updated information has been added to JABS.%' ----
---- PR#2702 - Make sure File/Activity ID shows in text incase HTML Link doesn't work        ----
-------------------------------------------------------------------------------------------------
    PROCEDURE checkforiafisnotifications IS
        v_records              NUMBER;
        v_lastsid              VARCHAR2(20)                              := '~~~VERY_FIRST_ONE~~~';
        v_lastid               VARCHAR2(100);
        v_lastunit             VARCHAR2(50);
        v_lasttitle            VARCHAR2(300);
        v_unit                 VARCHAR2(20);
        v_specifics            T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
        v_event_sid_not_code   VARCHAR2(200);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> CheckForIAFISNotifications');
---------------------------------------------------------------
---------------------------------------------------------------
-- Check for Requests sent, but no IAFIS Reponse in 12 hours --
---------------------------------------------------------------
---------------------------------------------------------------
        Core_Logger.log_it
                        (v_pipe,
                         'Generating Events for IAFIS Requests Send, but NO Responses in 12 Hours.');

        FOR iafis IN
            (SELECT a.SID AS thesid, a.title AS thetitle, a.ID AS theid, a.assigned_unit AS theunit
               FROM T_OSI_A_FP_IAFIS_REQUEST s, T_OSI_ACTIVITY a
              WHERE request_sent_to_iafis = 'Y'
                AND (   a.complete_date IS NULL
                     OR a.close_date IS NULL)
                AND s.SID NOT IN(
                        SELECT r.request
                          FROM T_OSI_A_FP_IAFIS_RESPONSE r
                         WHERE UPPER(r.response_text) LIKE '%IAFIS RESPONSE RECEIVED: %'
                            OR r.response_text LIKE '%Updated information has been added to JABS.%')
                AND SYSDATE > s.request_on +(720 / 1440)
                AND a.SID = s.OBJ)
        LOOP
            BEGIN
                Core_Logger.log_it(v_pipe, 'IAFIS record found.');

                IF v_lastsid <> iafis.thesid THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT SID
                          INTO v_event_sid_not_code
                          FROM T_OSI_NOTIFICATION_EVENT_TYPE
                         WHERE CODE = 'IAFIS.RSP.NOT.RCV';

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            Core_Logger.log_it(v_pipe, 'Insert record.');

                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES (NULL,
                                         v_event_sid_not_code,
                                         v_lastsid,
                                         'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_lastunit,
                                         v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := iafis.thesid;
                    v_lasttitle := iafis.thetitle;
                    v_lastunit := iafis.theunit;
                    v_lastid := iafis.theid;
                    v_specifics := 'IAFIS Response NOT Recieved in 12 Hours or more.';
                    Core_Logger.log_it(v_pipe, 'IAFIS Response NOT Recieved in 12 Hours or more. 1');
                ELSE
                    v_specifics := ' IAFIS Response NOT Recieved in 12 Hours or more.';
                    Core_Logger.log_it(v_pipe,
                                       'IAFIS Response NOT Recieved in 12 Hours or more. 2');
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'IAFIS.RSP.NOT.RCV';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                Core_Logger.log_it(v_pipe, 'Insert record 2');

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             v_specifics,
                             'N');
            END IF;
        END IF;

---------------------------------------------------------
---------------------------------------------------------
-- Check for Requests not sent, but fingerprints taken --
---------------------------------------------------------
---------------------------------------------------------------
        Core_Logger.log_it
                      (v_pipe,
                       'Generating Events for Fingerprints taken, but Prints not yet sent to IAFIS.');
        v_lastsid := '~~~VERY_FIRST_ONE~~~';
        v_lastid := '';
        v_lastunit := '';
        v_lasttitle := '';
        v_unit := '';
        v_specifics := '';

        FOR iafis IN (SELECT a.SID AS thesid, a.title AS thetitle, a.ID AS theid,
                             a.assigned_unit AS theunit
                        FROM T_OSI_ACTIVITY a, T_OSI_A_FINGERPRINT f, T_OSI_ATTACHMENT AT
                       WHERE a.SID NOT IN(SELECT r.obj
                                            FROM T_OSI_A_FP_IAFIS_REQUEST r
                                           WHERE SYSDATE > a.activity_date +(720 / 1440))
                         AND a.SID = f.SID
                         AND AT.obj = a.SID
                         AND AT.content IS NOT NULL
                         AND AT.SOURCE = 'Fingerprint Module')
        LOOP
            BEGIN
                IF v_lastsid <> iafis.thesid THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT SID
                          INTO v_event_sid_not_code
                          FROM T_OSI_NOTIFICATION_EVENT_TYPE
                         WHERE CODE = 'IAFIS.NOT.SENT';

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES ('GETONE',
                                         v_event_sid_not_code,
                                         v_lastsid,
                                         'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_lastunit,
                                         v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := iafis.thesid;
                    v_lasttitle := iafis.thetitle;
                    v_lastunit := iafis.theunit;
                    v_lastid := iafis.theid;
                    v_specifics := 'Fingerprints taken, but Prints not yet sent to IAFIS.';
                ELSE
                    v_specifics := 'Fingerprints taken, but Prints not yet sent to IAFIS.';
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'IAFIS.NOT.SENT';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             v_specifics,
                             'N');
            END IF;
        END IF;

---------------------------------------------------------------
---------------------------------------------------------------
-- Check for Requests sent and response from IAFIS received ---
---------------------------------------------------------------
---------------------------------------------------------------
        Core_Logger.log_it(v_pipe, 'Generating Events for Reponse Received from IAFIS');
        v_lastsid := '~~~VERY_FIRST_ONE~~~';
        v_lastid := '';
        v_lastunit := '';
        v_lasttitle := '';
        v_unit := '';
        v_specifics := '';

        FOR iafis IN
            (SELECT a.SID AS thesid, a.title AS thetitle, a.ID AS theid, a.assigned_unit AS theunit
               FROM T_OSI_A_FP_IAFIS_REQUEST s, T_OSI_ACTIVITY a
              WHERE request_sent_to_iafis = 'Y'
                AND (   a.complete_date IS NULL
                     OR a.close_date IS NULL)
                AND s.SID IN(
                        SELECT r.request
                          FROM T_OSI_A_FP_IAFIS_RESPONSE r
                         WHERE UPPER(r.response_text) LIKE '%IAFIS RESPONSE RECEIVED: %'
                            OR r.response_text LIKE '%Updated information has been added to JABS.%')
                AND SYSDATE > s.request_on +(720 / 1440)
                AND a.SID = s.OBJ)
        LOOP
            IF v_lastsid <> iafis.thesid THEN
                IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                    SELECT SID
                      INTO v_event_sid_not_code
                      FROM T_OSI_NOTIFICATION_EVENT_TYPE
                     WHERE CODE = 'IAFIS.RSP.RCV';

                    SELECT COUNT(*)
                      INTO v_records
                      FROM T_OSI_NOTIFICATION_EVENT
                     WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                    IF v_records = 0 THEN
                        Core_Logger.log_it(v_pipe, 'Insert record.');

                        INSERT INTO T_OSI_NOTIFICATION_EVENT
                                    (SID,
                                     event_code,
                                     PARENT,
                                     parent_info,
                                     event_by,
                                     event_on,
                                     impacted_unit,
                                     specifics,
                                     GENERATED)
                             VALUES (NULL,
                                     v_event_sid_not_code,
                                     v_lastsid,
                                     'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                                     'I2MS',
                                     SYSDATE,
                                     v_lastunit,
                                     v_specifics,
                                     'N');
                    END IF;
                END IF;

                v_lastsid := iafis.thesid;
                v_lasttitle := iafis.thetitle;
                v_lastunit := iafis.theunit;
                v_lastid := iafis.theid;
                v_specifics := 'IAFIS Response Recieved.';
                Core_Logger.log_it(v_pipe, 'IAFIS Response Recieved.');
            ELSE
                v_specifics := ' IAFIS Response Recieved.';
                Core_Logger.log_it(v_pipe, 'IAFIS Response Recieved. 2');
            END IF;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'IAFIS.RSP.RCV';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                Core_Logger.log_it(v_pipe, 'Insert record 3');

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             v_specifics,
                             'N');
            END IF;
        END IF;

        Core_Logger.log_it(v_pipe, '<<< CheckForIAFISNotifications');
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error in checkforiafisnotifications: ' || SQLERRM);
    END checkforiafisnotifications;

    PROCEDURE checkforsurveillanceactivities IS
        v_records        NUMBER;
        expires          DATE;
        v_sid_not_code   VARCHAR2(20);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> CheckForSurveillanceActivities');

--------------------------------------------------------------------
--------------------------------------------------------------------
-- Check for Surveillance Activities within 10 days of expiration --
--------------------------------------------------------------------
--------------------------------------------------------------------
        SELECT SID
          INTO v_sid_not_code
          FROM T_OSI_NOTIFICATION_EVENT_TYPE
         WHERE CODE = 'ACT.SURV.EXPIRED';

        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
         WHERE TO_CHAR(s.activation_date + s.approved_duration - 10, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
           AND a.complete_date IS NULL
           AND a.close_date IS NULL
           AND s.SID = a.SID;

        Core_Logger.log_it
               (v_pipe,
                'Generating Events for :  Surveillance Activities within 10 days of expiration, '
                || v_records || ' activitie(s) found!');

        FOR s IN (SELECT   narrative, s.SID AS activity, activation_date, approved_duration,
                           assigned_unit, ID, title AS title
                      FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
                     WHERE TO_CHAR(s.activation_date + s.approved_duration - 10, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
                       AND a.complete_date IS NULL
                       AND a.close_date IS NULL
                       AND s.SID = a.SID
                  ORDER BY a.ID)
        LOOP
            BEGIN
                expires := s.activation_date + s.approved_duration;

                --Select Sid into v_sid_not_code from T_OSI_NOTIFICATION_EVENT_TYPE WHERE CODE = 'ACT.SURV.EXPIRED';
                SELECT COUNT(*)
                  INTO v_records
                  FROM T_OSI_NOTIFICATION_EVENT
                 WHERE event_code = v_sid_not_code AND PARENT = s.activity;

                IF v_records = 0 THEN
                    Core_Logger.log_it(v_pipe, 'ACT.SURV.EXPIRED:  ' || s.activity);

                    INSERT INTO T_OSI_NOTIFICATION_EVENT
                                (SID,
                                 event_code,
                                 PARENT,
                                 parent_info,
                                 event_by,
                                 event_on,
                                 impacted_unit,
                                 specifics,
                                 GENERATED)
                         VALUES (NULL,
                                 v_sid_not_code,
                                 s.activity,
                                 'Activity:  ' || s.ID || ' - ' || s.title,
                                 'I2MS',
                                 SYSDATE,
                                 s.assigned_unit,
                                 'Surveillance Activity Approaching Expiration ('
                                 || s.activation_date || '+' || s.approved_duration || ' Days ='
                                 || expires || '):<BR>' || s.narrative,
                                 'N');

                    COMMIT;
                END IF;
            END;
        END LOOP;

---------------------------------------------------------
---------------------------------------------------------
-- Check for Surveillance Activities that have expired --
---------------------------------------------------------
---------------------------------------------------------
        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
         WHERE TO_CHAR(s.activation_date + s.approved_duration + 1, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
           AND a.complete_date IS NULL
           AND a.close_date IS NULL
           AND s.SID = a.SID;

        Core_Logger.log_it
                          (v_pipe,
                           'Generating Events for :  Surveillance Activities that have expired, '
                           || v_records || ' activitie(s) found!');

        FOR s IN (SELECT   narrative, s.SID AS activity, activation_date, approved_duration,
                           assigned_unit, ID, title AS title
                      FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
                     WHERE TO_CHAR(s.activation_date + s.approved_duration + 1, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
                       AND a.complete_date IS NULL
                       AND a.close_date IS NULL
                       AND s.SID = a.SID
                  ORDER BY a.ID)
        LOOP
            BEGIN
                expires := s.activation_date + s.approved_duration;

                SELECT COUNT(*)
                  INTO v_records
                  FROM T_OSI_NOTIFICATION_EVENT
                 WHERE event_code = v_sid_not_code AND PARENT = s.activity;

                IF v_records = 0 THEN
                    Core_Logger.log_it(v_pipe, 'ACT.SURV.EXPIRED:  ' || s.activity);

                    INSERT INTO T_OSI_NOTIFICATION_EVENT
                                (SID,
                                 event_code,
                                 PARENT,
                                 parent_info,
                                 event_by,
                                 event_on,
                                 impacted_unit,
                                 specifics,
                                 GENERATED)
                         VALUES (NULL,
                                 v_sid_not_code,
                                 s.activity,
                                 'Activity:  ' || s.ID || ' - ' || s.title,
                                 'I2MS',
                                 SYSDATE,
                                 s.assigned_unit,
                                 'Surveillance Activity EXPIRED (' || s.activation_date || '+'
                                 || s.approved_duration || ' Days =' || expires || '):<BR>'
                                 || s.narrative,
                                 'N');

                    COMMIT;
                END IF;
            END;
        END LOOP;

        Core_Logger.log_it(v_pipe, '<<< CheckForSurveillanceActivities');
    END checkforsurveillanceactivities;

    PROCEDURE CFundAdvancesIssuedbyDays(Days IN NUMBER) IS
        v_records         NUMBER;
        v_event_counter   NUMBER;
        v_sid_not_code    VARCHAR2(20);
    BEGIN
        Core_Logger.LOG_IT(v_pipe, '>>> CFundAdvancesIssuedbyDays(' || Days || ')');

        SELECT SID
          INTO v_sid_not_code
          FROM T_OSI_NOTIFICATION_EVENT_TYPE
         WHERE CODE = 'CF.ADV100';

        v_event_counter := 0;

        FOR C IN (SELECT *
                    FROM V_CFUNDS_ADVANCE_V2 C
                   WHERE TO_CHAR(C.ISSUE_ON + Days, 'MM/DD/YYYY') = TO_CHAR(SYSDATE, 'MM/DD/YYYY')
                     AND C.CLOSE_DATE IS NULL)
        LOOP
            BEGIN
                SELECT COUNT(*)
                  INTO v_records
                  FROM T_OSI_NOTIFICATION_EVENT
                 WHERE EVENT_CODE = v_sid_not_code AND PARENT = C.SID;

                IF v_records = 0 THEN
                    Core_Logger.LOG_IT(v_pipe, 'CF.ADV100:  ' || C.VOUCHER_NO);

                    INSERT INTO T_OSI_NOTIFICATION_EVENT
                                (SID,
                                 EVENT_CODE,
                                 PARENT,
                                 PARENT_INFO,
                                 EVENT_BY,
                                 EVENT_ON,
                                 IMPACTED_UNIT,
                                 SPECIFICS,
                                 GENERATED)
                         VALUES (NULL,
                                 v_sid_not_code,
                                 C.SID,
                                 'CFund Advance Voucher #:  ' || C.VOUCHER_NO,
                                 'I2MS',
                                 SYSDATE,
                                 C.UNIT,
                                 C.VOUCHER_NO || ' CFund Advance ' || Days
                                 || ' days from Issue Date (' || C.ISSUE_ON || '):<BR>'
                                 || C.NARRATIVE,
                                 'N');

                    v_event_counter := v_event_counter + 1;
                    COMMIT;
                END IF;
            END;
        END LOOP;

        Core_Logger.LOG_IT(v_pipe,
                           v_event_counter || ' events generated for :  CFund Advances ' || Days
                           || ' days from Issue Date.');
        Core_Logger.LOG_IT(v_pipe, '<<< CFundAdvancesIssuedbyDays(' || Days || ')');
    END CFundAdvancesIssuedbyDays;

    PROCEDURE CheckForCFundAdvances IS
    BEGIN
        Core_Logger.LOG_IT(v_pipe, '>>> CheckForCFundAdvances');
--------------------------------------------------
--------------------------------------------------
-- Check for CFund Advances Issued  80 days ago --
--------------------------------------------------
--------------------------------------------------
        CFundAdvancesIssuedbyDays(80);
--------------------------------------------------
--------------------------------------------------
-- Check for CFund Advances Issued  90 days ago --
--------------------------------------------------
--------------------------------------------------
        CFundAdvancesIssuedbyDays(90);
--------------------------------------------------
--------------------------------------------------
-- Check for CFund Advances Issued 100 days ago --
--------------------------------------------------
--------------------------------------------------
        CFundAdvancesIssuedbyDays(100);
        Core_Logger.LOG_IT(v_pipe, '<<< CheckForCFundAdvances');
    END CheckForCFundAdvances;

    -- GENERATION --
    PROCEDURE generate(pthisevent IN VARCHAR2 := NULL) IS
        /*
        This procedure examines either the specified event or all previously
        un-generated events, and calls an event type specific generation routine.
        It is those specific routines that determine who gets notifications for
        the event. If the specific generation routine returns successfully, this
        routine marks the event as generated and commits all changes. If not,
        this routine rolls back any changes.

        Parameters:
            pThisEvent - Indicates a specific event to generate (optional).
        */
        v_cnt                  NUMBER;
        v_ok                   VARCHAR2(1);
        v_dyn_sql              VARCHAR2(200);
        v_event_code_not_sid   VARCHAR2(200);
        v_specifics            VARCHAR2(4000);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> Generate');

        IF pthisevent IS NOT NULL THEN
            Core_Logger.log_it(v_pipe, 'Generating specific event: ' || pthisevent);
        ELSE
            Checkcasesapproachingdaysopen;
            Checkforiafisnotifications;
            Checkforsurveillanceactivities;
            CheckForCFundAdvances;

            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_NOTIFICATION_EVENT ne
             WHERE ne.GENERATED = 'N';

            Core_Logger.log_it(v_pipe, 'Number of events found: ' || v_cnt);
        END IF;

        FOR ne IN (SELECT   *
                       FROM T_OSI_NOTIFICATION_EVENT
                      WHERE (   SID = pthisevent
                             OR pthisevent IS NULL) AND GENERATED = 'N'
                   ORDER BY event_on)
        LOOP
            -- Build the dynamic SQL statement to execute Event Code specific processing. --
            SELECT code
              INTO v_event_code_not_sid
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE SID = ne.event_code;

---------------------------------------------------------------------------------------------
--- Do this here since :NEW.NOTE_TEXT will not work in the Actual Trigger on T_OSI_NOTE   ---
---  *** These types of notifications can not be Immediate Generation since it will cause ---
---      a Mutating Trigger.                                                              ---
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
            IF v_event_code_not_sid = 'FLE.REVIEW.NOTE' THEN
                BEGIN
                    SELECT SUBSTR(note_text, 1, 4000)
                      INTO v_specifics
                      FROM T_OSI_NOTE
                     WHERE SID = ne.specifics;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_specifics := 'Note Text Not Found - ' || SQLERRM;
                END;

                BEGIN
                    UPDATE T_OSI_NOTIFICATION_EVENT
                       SET specifics = v_specifics
                     WHERE SID = ne.SID;

                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_specifics := 'Specifics Not Updated - ' || SQLERRM;
                END;
            ELSE
                v_specifics := ne.specifics;
            END IF;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
            Core_Logger.log_it(v_pipe, 'Processing event ' || ne.event_code);
            Core_Logger.log_it(v_pipe,
                               'Event occurred at '
                               || TO_CHAR(ne.event_on, 'dd-Mon-yyyy hh24:mi:ss'));
            Core_Logger.log_it(v_pipe, 'Parent info: ' || ne.parent_info);
            Core_Logger.log_it(v_pipe, 'Specifics: ' || v_specifics);
            -- save for specific processing --
            v_curr_event_rec := ne;
            v_dyn_sql := v_event_code_not_sid;
            v_dyn_sql := REPLACE(v_dyn_sql, '.', '');
            v_dyn_sql := REPLACE(v_dyn_sql, '_', '');
            v_dyn_sql := 'OSI_NOTIFICATION.Generate_' || v_dyn_sql;
            Core_Logger.log_it(v_pipe, 'Processing routine: ' || v_dyn_sql);
            v_dyn_sql := 'begin ' || v_dyn_sql || '(:ok); end;';
            v_can_generate := TRUE;

            DECLARE
                v_sqlerrm   VARCHAR2(4000);
            BEGIN
                v_ok := 'N';

                EXECUTE IMMEDIATE v_dyn_sql
                            USING OUT v_ok;
            EXCEPTION
                WHEN OTHERS THEN
                    -- If the error string contains PLS-00302, it means the specific --
                    -- generation routine doesn't exist (yet). Try using a generic   --
                    -- routine.                                                      --
                    v_sqlerrm := SQLERRM;

                    IF INSTR(v_sqlerrm, 'PLS-00302') > 0 THEN
                        Core_Logger.log_it(v_pipe,
                                           'Processing routine not found - Using generic routine');
                        generate_generic(v_ok);
                    ELSE
                        Core_Logger.log_it(v_pipe, 'Error: ' || v_sqlerrm);
                        v_ok := 'N';
                    END IF;
            END;

            v_can_generate := FALSE;

            -- if successful generation, mark this event as generated --
            IF v_ok = 'Y' THEN
                UPDATE T_OSI_NOTIFICATION_EVENT
                   SET GENERATED = 'Y'
                 WHERE SID = ne.SID;

                IF pthisevent IS NULL THEN
                    COMMIT;
                END IF;
            ELSE
                IF pthisevent IS NULL THEN
                    ROLLBACK;
                END IF;
            END IF;

            -- spacer --
            Core_Logger.log_it(v_pipe, '.');
        END LOOP;

        <<exit_proc>>
        Core_Logger.log_it(v_pipe, '<<< Generate');
    END generate;

-- Private generation routines specific to an event type.
    PROCEDURE generate_actleaddone(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_actleaddone;

    PROCEDURE generate_actnarrchng(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_actnarrchng;

    PROCEDURE generate_asgnmade(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_asgnmade;

    PROCEDURE generate_fleassocact(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_fleassocact;

    PROCEDURE generate_fleassocfle(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_fleassocfle;

/*  replaced by generic routine

procedure Generate_INVDEATH( pOK out Varchar2 ) is

--  Generate notifications for any personnel interested in death cases
--  for the impacted unit. The interest determines the delivery method.

    v_ni_rec t_osi_notification_interest%rowtype := null;
    a_problem exception;

begin
    if not v_can_generate then
        pOK := 'N';
        CORE_LOGGER.log_it(v_pipe, 'Illegal call to generation helper routine.');
        return;
    end if;

    for a in (select distinct PERSONNEL
              from t_osi_notification_interest
              where EVENT_TYPE = 'INV.DEATH')
    loop
        -- Determine interest and extract delivery method

        v_ni_rec := Find_Closest_Interest(a.PERSONNEL, 'INV.DEATH',
                                          v_curr_event_rec.IMPACTED_UNIT);
        if v_ni_rec.SID is not null then
            if not Insert_Notification(a.PERSONNEL,
                    v_ni_rec.DELIVERY_METHOD,
                    v_ni_rec.DELIVERY_ADDRESS) then
                raise a_problem;
            end if;
        end if;
    end loop;

    pOK := 'Y';
    return;

exception
    when a_problem then
        pOK := 'N';
        return;

    when OTHERS then
        CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
        pOK := 'N';
        return;

end Generate_INVDEATH;
*/
    PROCEDURE generate_invheadsup(pok OUT VARCHAR2) IS
/*
    Generate notification for approval authority of the unit assuming
    the they specified an interest in this type of notification.
    The interest determines the delivery method.
*/
        v_event_type varchar2(20) := null;
        v_ni_rec    T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_fu_rec    T_OSI_F_UNIT%ROWTYPE;
        a_problem   EXCEPTION;
    BEGIN
        Core_Logger.log_it(v_pipe, 'Starting GENERATE_INVHEADSUP');

        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        -- Get the file's current unit info
        SELECT *
          INTO v_fu_rec
          FROM T_OSI_F_UNIT
         WHERE file_sid = v_curr_event_rec.PARENT AND end_date IS NULL;

        --Get INV.HEADSUP event type sid
        select SID
          into v_event_type
          from t_osi_notification_event_type
         where code = 'INV.HEADSUP';

        FOR a IN
            (SELECT   *
                 FROM T_CORE_PERSONNEL
                WHERE    /*removed the priv check per wchg0000357
                         Osi_Auth.CHECK_FOR_PRIV('APPROVE',
                                                 Core_Obj.GET_OBJTYPE(v_fu_rec.FILE_SID),
                                                 SID,
                                                 v_FU_REC.UNIT_SID) = 'Y'
                                          --('INV.APP', SID, v_curr_event_rec.impacted_unit) = 'Y'*/
                      --and OSI_AUTH.CHECK_FOR_PRIV('APPROVE', SID, v_fu_rec.unit_SID) = 'N'
                      -- would filter out "sibling" notifications
                      --AND
                      SID IN(SELECT personnel
                               FROM T_OSI_NOTIFICATION_INTEREST
                              WHERE event_type = v_event_type)
             ORDER BY LAST_NAME, FIRST_NAME)
        LOOP
            Core_Logger.log_it(v_pipe,
                               'Found Approval Authority: ' || a.Last_Name || ' ' || a.First_Name);
            -- Determine interest and extract delivery method
            v_ni_rec := find_closest_interest(a.SID, v_event_type, v_curr_event_rec.impacted_unit);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT insert_notification(a.SID,
                                           v_ni_rec.delivery_method,
                                           v_ni_rec.delivery_address) THEN
                    RAISE a_problem;
                END IF;
            ELSE
                Core_Logger.log_it(v_pipe, 'No interest indicated.');
            END IF;
--        exit;   -- only need 1
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_invheadsup;

    PROCEDURE generate_notenonlead(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_notenonlead;

    PROCEDURE generate_perchanged(pok OUT VARCHAR2) IS
/*
    Generate notification for lead agent of file/activity
    where the most recent personnel who modified the PERSON is not the lead agent.
    The interest determines the delivery method.
*/
        v_begin_run_code   VARCHAR2(50)                          := 'OSI.NOTIF_LR1';
        --CODE in T_I2MS_CONFIG for begin date/time range to run Detect_PERCHANGED
        v_end_run_code     VARCHAR2(50)                          := 'OSI.NOTIF_LR2';
        --CODE in T_I2MS_CONFIG for end date/time range to run Detect_PERCHANGED
        v_begin_run        DATE;                                            --begin date/time range
        v_end_run          DATE;                                         --end date/time code range
        v_lead_agent       VARCHAR2(200);                                      --Name of Lead Agent
        v_lead_agent_sid   VARCHAR2(200);                                       --SID of Lead Agent
        v_ni_rec           T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_cnt              NUMBER                                := 0;
        a_problem          EXCEPTION;
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        --GET DATE RANGE
        v_begin_run := TO_DATE(Core_Util.GET_CONFIG(v_begin_run_code), 'DD-MON-YYYY hh24:mi:ss');
        --GET begin date/time range fron I2MS Config
        v_end_run := TO_DATE(Core_Util.get_config(v_end_run_code), 'DD-MON-YYYY hh24:mi:ss');
         --GET end date/time range fron I2MS Config
        -- CORE_LOGGER.log_it(v_pipe,
                            --'>>> Generate_PERCHANGED: started ' || to_char(v_begin_run,'DD-MON-YYYY hh24:mi:ss') || '-' || to_char(v_end_run,'DD-MON-YYYY hh24:mi:ss'));
         --Start Procedure
        Core_Logger.log_it(v_pipe,
                           '>>> Generate_PERCHANGED: started '
                           || TO_CHAR(v_begin_run, 'DD-MON-YYYY hh24:mi:ss') || '-'
                           || TO_CHAR(v_end_run, 'DD-MON-YYYY hh24:mi:ss'));

        --Start Procedure

        --GET ALL PERSON_VERSIONs BASED ON current PERSON (PARENT)
        FOR m IN (SELECT DISTINCT SID
                             FROM T_OSI_PARTICIPANT_VERSION
                            WHERE participant = v_curr_event_rec.PARENT)
        LOOP
            --LOOP THROUGH ALL OPEN ACTIVITIES AND FILES HAVING ANY ROLE WITH SPECIFIED PERSON_VERSION
            FOR n IN
                (SELECT DISTINCT
                                 --PI.INVOLVEMENT_ROLE,           --INVOLVEMENT_ROLE NOT NEEDED AT THIS TIME
                                 pi.activity AS OBJ, pi.title
                            FROM v_osi_partic_act_involvement pi, T_OSI_ACTIVITY act_file
                           WHERE pi.participant_version = m.SID
                             AND                            --GET ALL ROLES WHERE PERSON IS INVOLVED
                                 pi.activity = act_file.SID
                             AND                       --GET ALL ACTIVITIES WHERE PERSON IS INVOLVED
                                 act_file.close_date IS NULL          --ONLY LOOK AT OPEN ACTIVITIES
                 UNION ALL
                 SELECT DISTINCT
                                 --PI.INVOLVEMENT_ROLE,           --INVOLVEMENT_ROLE NOT NEEDED AT THIS TIME
                                 pi.File_sid AS OBJ, pi.title
                            FROM v_osi_partic_file_involvement pi, T_OSI_FILE act_file
                           WHERE pi.participant_version = m.SID
                             AND                            --GET ALL ROLES WHERE PERSON IS INVOLVED
                                 pi.file_sid = act_file.SID
                             AND                            --GET ALL FILES WHERE PERSON IS INVOLVED
                                 UPPER(Osi_Status.GET_STATUS_DESC(pi.FIle_Sid)) NOT IN
                                     ('ARCHIVED', 'RECEIVED AT ARCHIVE', 'SENT TO ARCHIVE',
                                      'CLOSED')
                                               --ONLY GET FILES NOT CLOSED OR ARCHIVED
                )
            LOOP
                Core_Logger.log_it(v_pipe,
                                   'SID=' || m.SID || '///PARENT=' || n.OBJ || ':::' || n.title);
                Core_Logger.log_it('I2MS.DEBUG',
                                   'SID=' || m.SID || '///PARENT=' || n.OBJ || ':::' || n.title);

                FOR a IN (SELECT changes.*
                            FROM 
                                 --LOOP THROUGH ALL CHANGES TO PERSON_VERSION WITH MODIFY_ON AFTER LAST RUN DATE
                                 (SELECT SID person_version, modify_by, modify_on
                                    FROM T_OSI_PARTICIPANT_VERSION
                                   WHERE SID IN(SELECT SID
                                                  FROM T_OSI_PARTICIPANT_VERSION
                                                 WHERE participant = v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT partic_a partic_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_RELATION
                                   WHERE partic_a IN(SELECT SID
                                                       FROM T_OSI_PARTICIPANT_VERSION
                                                      WHERE participant = v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT partic_b partic_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_RELATION
                                   WHERE partic_b IN(SELECT SID
                                                       FROM T_OSI_PARTICIPANT_VERSION
                                                      WHERE participant = v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_NUMBER
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_NUMBER
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_MARK
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_NAME
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version participant_version, modify_by,
                                         modify_on
                                    FROM T_OSI_PARTIC_CONTACT
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version person_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_ADDRESS
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)) changes
                           WHERE changes.modify_on > v_begin_run AND changes.modify_on <= v_end_run)
                LOOP
                    --GET SID OF LEAD AGENT
                    v_lead_agent_sid := Osi_Object.GET_LEAD_AGENT(n.OBJ);

                    --GET FULL NAME OF ALEAD AGENT
                    SELECT LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME
                      INTO v_lead_agent
                      FROM T_CORE_PERSONNEL
                     WHERE SID = v_lead_agent_sid;

                    --IF AT LEAST ONE PERSON_VERSION RELATED TO FILE/ACTIVITY WAS MODIFIED BY PERSONNEL OTHER THAN LEAD AGENT
                    Core_Logger.log_it(v_pipe, 'LEAD AGENT:' || v_lead_agent);
                    Core_Logger.log_it(v_pipe, 'MODIFY BY:' || a.modify_by);

                    IF trim(v_lead_agent) <> trim(a.modify_by) THEN
                        --COUNT NOTIFICATIONS GENERATED
                        Core_Logger.log_it(v_pipe, 'GOT A HIT!!!!!!!');
                        v_cnt := v_cnt + 1;
                        Core_Logger.log_it(v_pipe,
                                           '****' || v_cnt || '.SID=' || m.SID || '/PARENT='
                                           || n.OBJ || '****Lead Agent[' || v_lead_agent
                                           || ']:::Modify_By[' || a.modify_by || ']');
                        Core_Logger.log_it('I2MS.DEBUG',
                                           '****' || v_cnt || '.SID=' || m.SID || '/PARENT='
                                           || n.OBJ || '****Lead Agent[' || v_lead_agent
                                           || ']:::Modify_By[' || a.modify_by || ']');
                        -- Determine interest and extract delivery method
                        v_ni_rec := find_closest_interest(v_lead_agent_sid, 'PER.CHANGED');
                        Core_Logger.log_it(v_pipe,
                                           'ABOUT TO DO INSERT_NOTIFICATION(' || v_lead_agent_sid
                                           || ',' || v_ni_rec.delivery_method || ','
                                           || v_ni_rec.delivery_address || ')');

                        IF v_ni_rec.SID IS NOT NULL THEN
                            IF NOT insert_notification(v_lead_agent_sid,
                                                       v_ni_rec.delivery_method,
                                                       v_ni_rec.delivery_address) THEN
                                RAISE a_problem;
                            END IF;
                        ELSE
                            Core_Logger.log_it(v_pipe, 'No interest indicated.');
                        END IF;

                        EXIT;                                                         -- only need 1
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;

        Core_Logger.log_it(v_pipe, '<<< Generate_PERCHANGED: stopped');             --Stop Procedure
        Core_Logger.log_it('I2MS.DEBUG', '<<< Generate_PERCHANGED: stopped');       --Stop Procedure
        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!!  Generate_PERCHANGED : Error: ' || SQLERRM);
            Core_Logger.log_it('I2MS.DEBUG', '!!! Generate_PERCHANGED : Error: ' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_perchanged;

    PROCEDURE Generate_CFEXPREJECT(pOK OUT VARCHAR2) IS
/*
    Generate notifications for any personnel interested in the current event
    for the impacted unit. The interest determines the delivery method.
*/
        v_ni_rec        T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_deliverymtd   VARCHAR2(20);
        a_problem       EXCEPTION;
    BEGIN
        FOR a IN (SELECT DISTINCT PERSONNEL
                             FROM T_OSI_NOTIFICATION_INTEREST
                            WHERE EVENT_TYPE = v_curr_event_rec.EVENT_CODE)
        LOOP
            --- Determine interest and extract delivery method ---
            v_ni_rec :=
                Find_Closest_Interest(a.PERSONNEL,
                                      v_curr_event_rec.EVENT_CODE,
                                      v_curr_event_rec.IMPACTED_UNIT);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT Insert_Notification(a.PERSONNEL,
                                           v_ni_rec.DELIVERY_METHOD,
                                           v_ni_rec.DELIVERY_ADDRESS) THEN
                    RAISE a_problem;
                END IF;
            END IF;
        END LOOP;

        FOR A IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE SID = v_curr_event_rec.PARENT)
        LOOP
            SELECT SID
              INTO v_deliverymtd
              FROM T_OSI_NOTIFICATION_METHOD
             WHERE code = 'CF.EXP.REJECT.EMAIL';

            IF NOT Insert_Notification(a.claimant, v_deliverymtd, '') THEN
                RAISE a_problem;
            END IF;
        END LOOP;

        pOK := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pOK := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.LOG_IT(v_pipe, 'Error: ' || SQLERRM);
            pOK := 'N';
            RETURN;
    END Generate_CFEXPREJECT;

    PROCEDURE Generate_ACCESSFAILED(pOK OUT VARCHAR2) IS
        v_ni_rec                T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_fu_rec                T_OSI_F_UNIT%ROWTYPE;
        a_problem               EXCEPTION;
        pSID                    VARCHAR2(20);
        pObjTypeCode            VARCHAR2(30);
        pObjTypeDesc            VARCHAR2(100);
        pClass                  VARCHAR2(50);
        pForm                   VARCHAR2(50);
        pLocatorClass           VARCHAR2(50);
        pLocatorForm            VARCHAR2(50);
        pUnitSID                VARCHAR2(20);
        pUsername               VARCHAR2(1000);
        pCurrentUnit            VARCHAR2(20);
        pUserUnitName           VARCHAR2(50);
        pPersonnelAlreadySent   VARCHAR2(4000)                        := ',';
        pDeliveryMethodSID      VARCHAR2(20);
    BEGIN
        Core_Logger.LOG_IT(v_pipe, '>>>Generate_ACCESSFAILED');

        IF NOT v_can_generate THEN
            pOK := 'N';
            Core_Logger.LOG_IT(v_pipe, 'Illegal call to generation helper routine.');
            Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
            RETURN;
        END IF;

        pSID := v_curr_event_rec.PARENT;

        --- Get Sid of Delivery Method ---
        BEGIN
            SELECT M.SID
              INTO pDeliveryMethodSID
              FROM T_OSI_NOTIFICATION_METHOD M, T_OSI_NOTIFICATION_EVENT_TYPE T
             WHERE M.EVENT_TYPE = T.SID AND T.CODE = 'ACCESS.FAILED';
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        --- Get the Objects Owning Unit SID ---

        --- Check to See if it is a File ---
        BEGIN
            SELECT UNIT_SID
              INTO pUnitSID
              FROM T_OSI_F_UNIT
             WHERE FILE_SID = v_curr_event_rec.PARENT AND END_DATE IS NULL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pUnitSID := NULL;
        END;

        --- Check to See if it is an Activity ---
        IF pUnitSID IS NULL THEN
            BEGIN
                SELECT ASSIGNED_UNIT
                  INTO pUnitSID
                  FROM T_OSI_ACTIVITY
                 WHERE SID = v_curr_event_rec.PARENT;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pUnitSID := NULL;
            END;
        END IF;

        Core_Logger.LOG_IT(v_pipe, 'pUnitSID=' || pUnitSID);

        --- Get Personnel Name of Person that Check Access Failed for ---
        BEGIN
            SELECT P.PERSONNEL_NAME, P.UNIT_NAME
              INTO pUserName, pUserUnitName
              FROM V_OSI_PERSONNEL P
             WHERE P.SID = v_curr_event_rec.specifics;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pUserName := '<<NAME NOT FOUND>>';
        END;

        Core_Logger.LOG_IT(v_pipe, 'pUserName=' || pUserName);
        --- Try to deliver to the Lead Agent, if they are still in the owning unit ---
        Core_Logger.LOG_IT(v_pipe, 'Searching for Lead Agent, still in owning unit..............');

        FOR A IN (SELECT *
                    FROM V_OSI_ASSIGNMENT
                   WHERE ASSIGN_ROLE = 'Lead Agent' AND PARENT = v_curr_event_rec.PARENT)
        LOOP
            Core_Logger.LOG_IT(v_pipe, 'A.PERSONNEL_NAME=' || A.PERSONNEL_NAME);

            BEGIN
                SELECT UNIT
                  INTO pCurrentUnit
                  FROM T_OSI_PERSONNEL_UNIT_ASSIGN
                 WHERE PERSONNEL = A.PERSONNEL AND END_DATE IS NULL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pCurrentUnit := '~~NOT FOUND~~';
            END;

            Core_Logger.LOG_IT(v_pipe, 'pCurrentUnit=' || pCurrentUnit || ', pUnitSID=' || pUnitSID);

            IF pCurrentUnit = pUnitSID THEN
                IF INSTR(pPersonnelAlreadySent, a.personnel || ',') = 0 THEN
                    Core_Logger.LOG_IT(v_pipe, 'Lead Agent Found.');

                    IF NOT Insert_Notification(a.personnel, pDeliveryMethodSID, NULL) THEN
                        RAISE a_problem;
                    END IF;

                    pPersonnelAlreadySent := pPersonnelAlreadySent || a.personnel || ',';
                END IF;
            END IF;
        END LOOP;

        --- Try to deliver to the DETCO of the owning unit ---
        Core_Logger.LOG_IT(v_pipe, 'Searching for DETCO of the owning unit..............');

        FOR A IN (SELECT *
                    FROM V_OSI_UNIT_ASSIGNMENT
                   WHERE ASSIGN_ROLE = 'COMMANDER' AND END_DATE IS NULL AND UNIT = pUnitSID)
        LOOP
            IF INSTR(pPersonnelAlreadySent, a.personnel || ',') = 0 THEN
                Core_Logger.LOG_IT(v_pipe,
                                   'A.PERSONNEL_NAME=' || A.PERSONNEL_NAME || ', DETCO Found.');

                IF NOT Insert_Notification(a.personnel, pDeliveryMethodSID, NULL) THEN
                    RAISE a_problem;
                END IF;

                pPersonnelAlreadySent := pPersonnelAlreadySent || a.personnel || ',';
            END IF;
        END LOOP;

        --- Try to deliver to any other Agents that are interested ---
        Core_Logger.LOG_IT(v_pipe, 'Searching for any other Interested parties..............');

        FOR a IN (SELECT DISTINCT PERSONNEL
                             FROM T_OSI_NOTIFICATION_INTEREST
                            WHERE EVENT_TYPE = v_curr_event_rec.EVENT_CODE)
        LOOP
            --- Determine interest and extract delivery method ---
            v_ni_rec := Find_Closest_Interest(a.PERSONNEL, v_curr_event_rec.EVENT_CODE, pUnitSID);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF INSTR(pPersonnelAlreadySent, a.personnel || ',') = 0 THEN
                    Core_Logger.LOG_IT(v_pipe, 'Interest Found....');

                    IF NOT Insert_Notification(a.PERSONNEL,
                                               v_ni_rec.DELIVERY_METHOD,
                                               v_ni_rec.DELIVERY_ADDRESS) THEN
                        RAISE a_problem;
                    END IF;

                    pPersonnelAlreadySent := pPersonnelAlreadySent || a.personnel || ',';
                END IF;
            END IF;
        END LOOP;

        UPDATE T_OSI_NOTIFICATION_EVENT
           SET IMPACTED_UNIT = pUnitSID,
               SPECIFICS =
                   pUsername || ' from ' || pUserUnitName
                   || ' Failed to gain access to this object.'
         WHERE SID = v_curr_event_rec.SID;

        COMMIT;
        pOK := 'Y';
        Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pOK := 'N';
            Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.LOG_IT(v_pipe, 'Error: ' || SQLERRM);
            pOK := 'N';
            Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
            RETURN;
    END Generate_ACCESSFAILED;

-- DELIVERY
    PROCEDURE deliver(pthisnotification IN VARCHAR2 := NULL) IS
/*
    This procedure examines either the specified notification or all
    previously un-delivered notifications, groups them by delivery
    method, and calls a delivery method specific routine for each group.

    Each delivery routine has complete control over the delivery process.
    Options such as grouping of notification within an address, the content
    of the delivery, etc.

    Parameters:
        pThisNotification - A specific notification to deliver (optional).
*/
        v_cnt                   NUMBER;
        v_ok                    VARCHAR2(1);
        v_dyn_sql               VARCHAR2(200);
        v_method_code_not_sid   VARCHAR2(200);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> Deliver');

        -- Mark all Desktop-only notifications as delivered
        UPDATE T_OSI_NOTIFICATION
           SET delivery_date = SYSDATE
         WHERE delivery_date IS NULL AND delivery_method IS NULL;

        v_cnt := SQL%rowcount;
        Core_Logger.log_it(v_pipe, 'Marked ' || v_cnt || ' desktop notifications as delivered.');

        IF pthisnotification IS NOT NULL THEN
            Core_Logger.log_it(v_pipe, 'Delivering specified notification: ' || pthisnotification);
        ELSE
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_NOTIFICATION n
             WHERE n.delivery_date IS NULL;

            Core_Logger.log_it(v_pipe, 'Number of notifications found: ' || v_cnt);
        END IF;

        FOR n IN (SELECT DISTINCT n.delivery_method
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_date IS NULL
                              AND (   pthisnotification IS NULL
                                   OR pthisnotification = n.SID))
        LOOP
            Core_Logger.log_it(v_pipe, 'Delivering ' || n.delivery_method);

            -- Build the dynamic SQL statement to execute Delivery Method
            -- specific processing.
            SELECT code
              INTO v_method_code_not_sid
              FROM T_OSI_NOTIFICATION_METHOD
             WHERE SID = n.delivery_method;

            v_dyn_sql := v_method_code_not_sid;
            v_dyn_sql := REPLACE(v_dyn_sql, '.', '');
            v_dyn_sql := REPLACE(v_dyn_sql, '_', '');
            v_dyn_sql := 'OSI_NOTIFICATION.Deliver_' || v_dyn_sql;
            Core_Logger.log_it(v_pipe, 'Processing routine: ' || v_dyn_sql);
            v_dyn_sql := 'begin ' || v_dyn_sql || '(:ok,:t1); end;';
            v_can_deliver := TRUE;

            DECLARE
                v_sqlerrm   VARCHAR2(4000);
            BEGIN
                v_ok := 'N';

                EXECUTE IMMEDIATE v_dyn_sql
                            USING OUT v_ok, IN pthisnotification;
            EXCEPTION
                WHEN OTHERS THEN
                    -- If the error string contains PLS-00302, it means the specific
                    -- generation routine doesn't exist (yet). Try using a generic
                    -- routine.
                    v_sqlerrm := SQLERRM;

                    IF INSTR(v_sqlerrm, 'PLS-00302') > 0 THEN
                        Core_Logger.log_it(v_pipe,
                                           'Processing routine not found - Using generic routine');
                        deliver_generic(n.delivery_method, v_ok, pthisnotification);
                    ELSE
                        Core_Logger.log_it(v_pipe, 'Error #1: ' || v_sqlerrm);
                        v_ok := 'N';
                    END IF;
            END;

            v_can_deliver := FALSE;

            IF v_ok = 'Y' THEN
                IF pthisnotification IS NULL THEN
                    COMMIT;
                END IF;
            ELSE
                IF pthisnotification IS NULL THEN
                    ROLLBACK;
                END IF;
            END IF;
        END LOOP;

        <<exit_proc>>
        Core_Logger.log_it(v_pipe, '<<< Deliver');
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            Core_Logger.log_it(v_pipe, '<<< Deliver');

            IF pthisnotification IS NULL THEN
                ROLLBACK;
            END IF;

            RETURN;
    END deliver;

-- Private delivery routines specific to a delivery mechanism
    PROCEDURE deliver_actleaddoneemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(10);                                        -- Line Feed
    BEGIN
/*
        pok := 'N';

        if not v_can_deliver then
            CORE_LOGGER.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            return;
        end if;

        if not email_update_blank_addresses('ACT.LEADDONE.EMAIL') then
            return;
        end if;

        -- Loop through all the notifications, grouped by effective address
        for a in (select distinct n.delivery_address
                             from t_osi_notification n
                            where n.delivery_method = 'ACT.LEADDONE.EMAIL'
                              and n.delivery_date is null
                              and n.delivery_address is not null
                              and (   n.SID = pthis1
                                   or pthis1 is null))
        loop
            v_message := null;
            CORE_LOGGER.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            for n in (select   n.*
                          from v_notification n
                         where n.delivery_method = 'ACT.LEADDONE.EMAIL'
                           and n.delivery_date is null
                           and n.delivery_address = a.delivery_address
                           and (   n.SID = pthis1
                                or pthis1 is null)
                      order by n.parent_info)
            loop
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || ' ' || Get_Config('DEFAULTINI') || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="I2MS:://pSid=' || n.parent || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || to_char(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Narrative (first 2k): ' || '<BR>';

                for t in (select *
                            from t_activity
                           where SID = n.parent)
                loop
                    if t.narrative is not null then
                        v_message := v_message || '<BR>' || clob_text(t.narrative, 2000) || '<BR>';
                    end if;
                end loop;

                v_message := v_message || '<HR>';
                CORE_LOGGER.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                update t_notification
                   set delivery_date = sysdate
                 where SID = n.SID;

                if length(v_message) > 28000 then
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    CORE_LOGGER.log_it(v_pipe,
                                       'Added message length notice: ' || length(v_message));
                    exit;
                end if;
            end loop;

            if email_send(a.delivery_address, 'Activity Completions', v_message) then
                null;
            end if;
        end loop;

        pok := 'Y';
        return;
    exception
        when others then
            CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
            pok := 'N';
*/
        NULL;
    END deliver_actleaddoneemail;

    PROCEDURE deliver_actleaddonetextmsg(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(13) || CHR(10);             -- Carriage Return/Line Feed
    BEGIN
/*
        pok := 'N';

        if not v_can_deliver then
            CORE_LOGGER.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            return;
        end if;

    if not EMAIL_Update_Blank_Addresses('ACT.LEADDONE.TEXTMSG') then
        return;
    end if;
*/  -- Loop through all the notifications. Since each message will contain
    -- only 1 notification, there is no need to group them like the E-mail
    -- delivery method.
/*        for n in (select   n.*
                      from v_notification n
                     where n.delivery_method = 'ACT.LEADDONE.TEXTMSG'
                       and n.delivery_date is null
                       and n.delivery_address is not null
                       and (   n.SID = pthis1
                            or pthis1 is null)
                  order by n.event_on)
        loop
            v_message := n.parent_info;

            if textmsg_send(n.delivery_address, 'Lead Done', v_message) then
                update t_notification
                   set delivery_date = sysdate
                 where SID = n.SID;
            end if;
        end loop;

        pok := 'Y';
        return;
    exception
        when others then
            CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
            pok := 'N';
*/
        NULL;
    END deliver_actleaddonetextmsg;

    PROCEDURE deliver_invdeathemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(20);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        Core_Logger.log_it(v_pipe, '%%%%%%%%%%%%%%%Inside deliver_invdeathemail');

        IF NOT email_update_blank_addresses('INV.DEATH.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.DEATH.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || ' ' || Get_Config('DEFAULTINI') || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 2k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 2000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Death Case', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invdeathemail;

    PROCEDURE deliver_invfraudemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(200);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.FRAUD.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.FRAUD.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || ' ' || Get_Config('DEFAULTINI') || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 5k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 5000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Fraud Case', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invfraudemail;

    PROCEDURE deliver_invfraud180email(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(20);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.FRAUD.180.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.FRAUD.180.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                --v_message := v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || ' ' || Get_Config('DEFAULTINI') || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date Opened: '
                    || TO_CHAR(Osi_Status.last_sh_date(n.PARENT, 'Open'), 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message :=
                       v_message || 'Total Days Open: ' || Get_Days_Since_Opened(n.PARENT)
                       || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 2k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 2000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Approaching 180 Days into a Fraud Case.', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invfraud180email;

    PROCEDURE deliver_invcrime90email(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(20);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.CRIME.90.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.CRIME.90.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_OSI_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                --v_message := v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || ' ' || Get_Config('DEFAULTINI') || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date Opened: '
                    || TO_CHAR(Osi_Status.last_sh_date(n.PARENT, 'Open'), 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message :=
                       v_message || 'Total Days Open: ' || Get_Days_Since_Opened(n.PARENT)
                       || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 2k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 2000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Approaching 90 Days into a Criminal Case.',
                          v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invcrime90email;

    PROCEDURE deliverspot15(pthisnotification IN VARCHAR2 := NULL) IS
/*
     For email delivery of SPOT reports on a more frequent basis.
 This procedure may be called on 15 minute intervals for SPOT reports only. WC
    Parameters:
        pThisNotification - A specific notification to deliver (optional).
*/
        v_cnt       NUMBER;
        v_ok        VARCHAR2(1);
        v_dyn_sql   VARCHAR2(200);
        v_method_sid_not_code   VARCHAR2(200);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> DeliverSpot15');
        
        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.SPOT.EMAIL';

        SELECT COUNT(*)
          INTO v_cnt
          FROM T_OSI_NOTIFICATION n
         WHERE n.delivery_date IS NULL AND n.delivery_method = v_method_sid_not_code;

        Core_Logger.log_it(v_pipe, 'Number of SPOT notifications found: ' || v_cnt);
        Core_Logger.log_it(v_pipe, 'Delivering INV.SPOT.EMAIL');
        v_dyn_sql := 'OSI_NOTIFICATION.Deliver_INVSPOTEMAIL';
        Core_Logger.log_it(v_pipe, 'Processing routine: ' || v_dyn_sql);
        v_dyn_sql := 'begin ' || v_dyn_sql || '(:ok,:t1); end;';
        v_can_deliver := TRUE;

        DECLARE
            v_sqlerrm   VARCHAR2(4000);
        BEGIN
            v_ok := 'N';

            EXECUTE IMMEDIATE v_dyn_sql
                        USING OUT v_ok, IN pthisnotification;
        EXCEPTION
            WHEN OTHERS THEN
                v_sqlerrm := SQLERRM;
                Core_Logger.log_it(v_pipe, 'Error: ' || v_sqlerrm);
                v_ok := 'N';
        END;

        v_can_deliver := FALSE;

        IF v_ok = 'Y' THEN
            IF pthisnotification IS NULL THEN
                COMMIT;
            END IF;
        ELSE
            IF pthisnotification IS NULL THEN
                ROLLBACK;
            END IF;
        END IF;

        <<exit_proc>>
        Core_Logger.log_it(v_pipe, '<<< DeliverSpot15');
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            Core_Logger.log_it(v_pipe, '<<< DeliverSpot15');

            IF pthisnotification IS NULL THEN
                ROLLBACK;
            END IF;

            RETURN;
    END deliverspot15;

    PROCEDURE deliver_invspotemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(10);                                        -- Line Feed
        v_tmp       VARCHAR2(1000);
        v_cnt       NUMBER;
        v_method_sid_not_code   VARCHAR2(200);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.SPOT.EMAIL') THEN
            RETURN;
        END IF;
        
        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.SPOT.EMAIL';
         
        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                v_message :=
                    v_message ||  n.parent_info || '<BR>';
                    --v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || '"'
                    --|| ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 6k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 6000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 24000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'SPOT Reportable Cases', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invspotemail;

    PROCEDURE deliver_actsurvexpiredemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
    v_message   VARCHAR2(32000) := NULL;
    v_nl        VARCHAR2(10)    := CHR(10);                                            -- Line Feed
    v_tmp       VARCHAR2(1000);
    v_cnt       NUMBER;
    BEGIN
        pok := 'N';

        if not v_can_deliver then
            CORE_LOGGER.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            return;
        end if;

        if not email_update_blank_addresses('ACT.SURV.EXPIRED.EMAIL') then
            return;
        end if;

        -- Loop through all the notifications, grouped by effective address
        for a in (SELECT DISTINCT n.delivery_address, net.description
                             FROM T_OSI_NOTIFICATION n,
                                  T_OSI_NOTIFICATION_EVENT ne,
                                  T_OSI_NOTIFICATION_EVENT_TYPE net
                            WHERE net.code = 'ACT.SURV.EXPIRED'
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL)
                              AND ne.SID = n.event
                              AND net.SID = ne.event_code)
        loop
            v_message := null;
            CORE_LOGGER.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            for n in (SELECT   n.*
                          FROM v_osi_notification n, t_osi_notification_method nm
                         WHERE nm.code = 'ACT.SURV.EXPIRED.EMAIL'
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                           AND n.delivery_method = nm.SID
                      ORDER BY n.parent_info)
            loop
                --v_message := v_message || '<A HREF="I2MS:://pSid=' || n.PARENT || ' ' || Get_Config('DEFAULTINI') || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="I2MS:://pSid=' || n.parent || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || '<HR>';
                CORE_LOGGER.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                update t_osi_notification
                   set delivery_date = sysdate
                 where SID = n.SID;

                if length(v_message) > 28000 then
                    v_message :=
                        v_message
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    CORE_LOGGER.log_it(v_pipe, 'Added message length notice: ' || length(v_message));
                    exit;
                end if;
            end loop;

            if email_send(a.delivery_address, 'Surveillance Expired or Expiring in 10 Days.', v_message) then
                null;
            end if;
        end loop;

        pok := 'Y';
        return;
    exception
        when others then
            CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
            pok := 'N';
            pok := 'Y';
            NULL;
    END deliver_actsurvexpiredemail;

-- CLEANUP
    PROCEDURE cleanup IS
        v_desktop_age_limit   NUMBER;
        v_undeliv_age_limit   NUMBER;
        v_cnt                 NUMBER;
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> Cleanup');
        v_desktop_age_limit := NVL(Core_Util.get_config('NOTIF_CLN1'), 14);
        v_undeliv_age_limit := NVL(Core_Util.get_config('NOTIF_CLN2'), 21);
        -- Get notifications that have done their job (or apparently won't)
        v_cnt := 0;

        FOR n IN (SELECT n.SID
                    FROM T_OSI_NOTIFICATION n, T_OSI_NOTIFICATION_METHOD nm
                   WHERE nm.code(+) = n.delivery_method
                     AND (   (n.delivery_date + NVL(nm.age_limit, v_desktop_age_limit)) < SYSDATE
                          OR (n.generation_date + v_undeliv_age_limit) < SYSDATE))
        LOOP
            BEGIN
                DELETE FROM T_OSI_NOTIFICATION
                      WHERE SID = n.SID;

                v_cnt := v_cnt + SQL%rowcount;
            EXCEPTION
                WHEN OTHERS THEN
                    Core_Logger.log_it(v_pipe, 'Error (notifications): ' || SQLERRM);
            END;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, 'Deleted ' || v_cnt || ' notifications');
        -- Get generated events that no longer have any notifications
        v_cnt := 0;

        FOR e IN (SELECT SID
                    FROM T_OSI_NOTIFICATION_EVENT ne
                   WHERE UPPER(ne.GENERATED) = 'Y' AND ne.SID NOT IN(SELECT event
                                                                       FROM T_OSI_NOTIFICATION))
        LOOP
            BEGIN
                DELETE FROM T_OSI_NOTIFICATION_EVENT
                      WHERE SID = e.SID;

                v_cnt := v_cnt + SQL%rowcount;
            EXCEPTION
                WHEN OTHERS THEN
                    Core_Logger.log_it(v_pipe, 'Error (events): ' || SQLERRM);
            END;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, 'Deleted ' || v_cnt || ' events');
        Core_Logger.log_it(v_pipe, '<<< Cleanup');
    END cleanup;

    FUNCTION get_primary_email(p_personnel IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_email   VARCHAR2(200);
        v_code    VARCHAR2(200);
    BEGIN
        SELECT SID
          INTO V_CODE
          FROM T_OSI_REFERENCE
         WHERE USAGE = 'CONTACT_TYPE' AND CODE = 'EMLP';

        FOR i IN (SELECT   *
                      FROM T_OSI_PERSONNEL_CONTACT
                     WHERE PERSONNEL = p_PERSONNEL AND TYPE = v_CODE AND VALUE IS NOT NULL
                  ORDER BY modify_on DESC)
        LOOP
            RETURN i.VALUE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe,
                               'get_primary_email error: ' || DBMS_UTILITY.format_error_backtrace
                               || ' p_personnel= ' || p_personnel);
            RETURN NULL;
    END get_primary_email;

    FUNCTION is_open_file(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR i IN (SELECT SID
                    FROM T_OSI_FILE
                   WHERE SID = p_sid AND UPPER(Osi_Object.GET_STATUS(p_SID)) = 'OPEN')
        LOOP
            RETURN 'Y';
        END LOOP;

        RETURN 'N';
    END;
END Osi_Notification;
/


------------------------------------------------------------------------
--- 022 - 3626 - CFunds Expense - make rejectdisallowed note visible ---
------------------------------------------------------------------------
/**************************************************************************************************************
      REMOVED CFUNDS_EXP LIST COMPONENT
      REMOVED CFUNDS EXPENSE PAGE 30505  --- BOTH UPDATED later so these changes are included there.... 
**************************************************************************************************************/
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
--   Date and Time:   09:47 Thursday February 10, 2011
--   Exported By:     JANELLE
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.12
 
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

PROMPT ...Remove page 30510
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30510);
 
end;
/

 
--application/pages/page_30510
prompt  ...PAGE 30510: CFunds Disallow Comment
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
'function passbackAndClose()'||chr(10)||
'{'||chr(10)||
'  //var from_item = document.getElementById(''P30510_FROM_ITEM'').value;'||chr(10)||
'  var comment = document.getElementById(''P30510_DISALLOW_COMMENT'').value;'||chr(10)||
''||chr(10)||
'  opener.document.getElementById(''P30505_DISALLOW_COMMENT'').value = comment;'||chr(10)||
'  opener.doSubmit(''DISALLOW_EXPENSE'');'||chr(10)||
'  window.close();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30510,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'CFunds Disallow Comment',
  p_step_title=> 'CFunds Disallow Comment',
  p_step_sub_title => 'CFunds Disallow Comment',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'JANELLE',
  p_last_upd_yyyymmddhh24miss => '20110128143358',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30510,p_text=>ph);
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
  p_id=> 93614024698545374 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30510,
  p_plug_name=> 'Disallowed Expense Comments',
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
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
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
  p_id             => 93615410512545384 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30510,
  p_button_sequence=> 30,
  p_button_plug_id => 93614024698545374+wwv_flow_api.g_id_offset,
  p_button_name    => 'OK',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'OK',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:passbackAndClose();'||chr(10)||
'',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 93615228246545381 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30510,
  p_button_sequence=> 40,
  p_button_plug_id => 93614024698545374+wwv_flow_api.g_id_offset,
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
  p_id=>93624521660545420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30510,
  p_branch_action=> 'f?p=&APP_ID.:30510:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 12:01 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21907108723983682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30510,
  p_name=>'P30510_FROM_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 93614024698545374+wwv_flow_api.g_id_offset,
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
  p_id=>93630936735645023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30510,
  p_name=>'P30510_DISALLOW_COMMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 93614024698545374+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'Select rejection_comment '||chr(10)||
'from T_CFUNDS_EXPENSE_V3'||chr(10)||
'where sid = :p30510_FROM_OBJ',
  p_source_type=> 'QUERY',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 15,
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
  p_id=>93643529245702653 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30510,
  p_name=>'P30510_FROM_ITEM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 93614024698545374+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'From Item',
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
  p_label_alignment  => 'RIGHT',
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
-- ...updatable report columns for page 30510
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



















----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
--- Version Update ---
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
----------------------
update t_core_config set setting = '5.0.2' where code = 'OSI.VERSION';
commit;