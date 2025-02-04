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
--   Date and Time:   09:33 Monday September 24, 2012
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

PROMPT ...Remove page 30710
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30710);
 
end;
/

 
--application/pages/page_30710
prompt  ...PAGE 30710: Evidence Transaction
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'function confirmSave()'||chr(10)||
'{'||chr(10)||
' var vOk = true;'||chr(10)||
' var sids = $(''#P30710_TRANS_SIDS'').val().split(''~'');'||chr(10)||
''||chr(10)||
' if ($v(''P30710_TRANS_TYPE'')==''LOGIN'' && $v(''P30710_EV_STATUS'')==''S'' && sids.length==3)'||chr(10)||
'   vOk = confirm(''You can no longer edit the Description once you exit this form.  Do you want to continue?'');'||chr(10)||
''||chr(10)||
' if ($v(''P30710_TRANS_TYPE'')==''LOGIN'' && $v(''P3';

ph:=ph||'0710_EV_STATUS'')==''S'' && sids.length>3)'||chr(10)||
'   vOk = confirm(''You can no longer edit the Descriptions once the Evidence is Logged In.  Do you want to continue?'');'||chr(10)||
'     '||chr(10)||
' if (vOk)'||chr(10)||
'   javascript:doSubmit(''SAVE'');'||chr(10)||
'}        '||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30710,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Evidence Transaction',
  p_step_title=> '&P30710_TITLE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="JavaScript">'||chr(10)||
'function printOne(report,tag)'||chr(10)||
'{'||chr(10)||
' newWindow({page:800,clear_cache:'''',name:'''',item_names:''P800_REPORT_TYPE,P0_OBJ,P800_PARAM_2'',item_values:report+'',&P0_OBJ.,''+tag+'','',request:''OPEN''});'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function AutoPrintTag()'||chr(10)||
'{'||chr(10)||
' if(''&P30710_TRANS_TYPE.''==''SPLIT'')'||chr(10)||
'   {'||chr(10)||
'    if(''&P30710_AUTO_PRINT_TAG.''==''I2MS'')'||chr(10)||
'      printOne(''&P30710_I2MS_RPT.'',''&P30710_NEW_SID_FOR_SPLIT.'');'||chr(10)||
''||chr(10)||
'    if(''&P30710_AUTO_PRINT_TAG.''==''AFF52'')'||chr(10)||
'      printOne(''&P30710_ORIG_RPT.'',''&P30710_NEW_SID_FOR_SPLIT.'');'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    var tags = ''&P30710_TRANS_SIDS.'';'||chr(10)||
'    tags = tags.split(''~'');'||chr(10)||
''||chr(10)||
'    for(var i=0;i<tags.length-1;i++)'||chr(10)||
'       {'||chr(10)||
'        if(tags[i].length>0)'||chr(10)||
'          {'||chr(10)||
'           if(''&P30710_AUTO_PRINT_TAG.''==''I2MS'')'||chr(10)||
'             printOne(''&P30710_I2MS_RPT.'',tags[i]);'||chr(10)||
''||chr(10)||
'           if(''&P30710_AUTO_PRINT_TAG.''==''AFF52'')'||chr(10)||
'             printOne(''&P30710_ORIG_RPT.'',tags[i]);'||chr(10)||
'          }'||chr(10)||
''||chr(10)||
'       }'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'if (''&REQUEST.''==''SAVE'')'||chr(10)||
'{'||chr(10)||
' if (''&P30710_DO_AUTO_PRINT_TAG.''==''YES'')'||chr(10)||
'   AutoPrintTag();'||chr(10)||
''||chr(10)||
' window.parent.doSubmit(''REFRESH'');'||chr(10)||
' closeDialog();'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120924093258',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '09-Jun-2011 - Tim Ward - CR#3591 - Allow multiple Comments.'||chr(10)||
''||chr(10)||
'17-Aug-2011 - Tim Ward - CR#3909 - Rename the Split Tag to Derivative Evidence.'||chr(10)||
''||chr(10)||
'24-Aug-2011 - Tim Ward - CR#3866 - Make Logging In faster, allow them to '||chr(10)||
'                                   choose to auto print the evidence tag.'||chr(10)||
''||chr(10)||
'                                   Also got rid of the bogus "cannot edit the '||chr(10)||
'                                   description" message when logging in logged'||chr(10)||
'                                   out evidence.  This message only applies'||chr(10)||
'                                   when Logging In Submitted Evidence.'||chr(10)||
''||chr(10)||
'01-Sep-2011 - Tim Ward - CR#3935 - Reject should only be allowed on Status '||chr(10)||
'                                   Submitted To Custodian.'||chr(10)||
'                                   Changed in "Perform Transaction" Process.'||chr(10)||
'                                   New Reject Region to confirm Rejection.'||chr(10)||
'                                   New Close Button for Error Region.'||chr(10)||
''||chr(10)||
'23-Dec-2011 - Tim Ward - CR#3977 - Added the Auto Printing of tag to '||chr(10)||
'                                   Derivative Evidence as well.'||chr(10)||
''||chr(10)||
'23-Dec-2011 - Tim Ward - CR#3978 - Trying to fix a timing issue with'||chr(10)||
'                                   the Auto Printing of Tag During'||chr(10)||
'                                   Log In and Derivative.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.'||chr(10)||
''||chr(10)||
'11-Jul-2012 - Tim Ward - CR#4034 - Allow Multiple Logins.'||chr(10)||
''||chr(10)||
'16-Jul-2012 - Tim Ward - CR#3999 - Added Hours Minutes and Seconds to the'||chr(10)||
'                                    effective date.'||chr(10)||
''||chr(10)||
'27-Aug-2012 - Tim Ward - Made window use jQuery Dialog instead of browser popup.'||chr(10)||
''||chr(10)||
'10-Sep-2012 - Tim Ward - CR#4034 - Multiple Logins should print multiple tags.'||chr(10)||
'14-Sep-2012 - Tim Ward - CR#4034 - Multiple Login overwriting descriptions.'||chr(10)||
'24-Sep-2012 - Tim Ward - CR#3999 - Added Hours Minutes and Seconds to the'||chr(10)||
'                                    effective date.  Fix Ora-01858 error.'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30710,p_text=>ph);
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
  p_id=> 7420300499465144 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> 'Auto Evidence Tag Print Options',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 20,
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
  p_plug_display_when_condition => ':P30710_ERRORS is null and (:P30710_EV_STATUS=''S'' or :P30710_TRANS_TYPE=''SPLIT'')',
  p_plug_header=> '<center>',
  p_plug_footer=> '</center>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> ' ---and :P30710_TRANS_TYPE = ''LOGIN'''||chr(10)||
':P30710_ERRORS is null and :P30710_TRANS_TYPE IN (''LOGIN'',''SPLIT'')');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'Are you sure you want to Send this item back to the Obtaining Agent?';

wwv_flow_api.create_page_plug (
  p_id=> 7497920723954436 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> 'Reject Evidence',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P30710_ERRORS is null and :P30710_TRANS_TYPE = ''REJECT'' and :REQUEST!=''SAVE''',
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
  p_id=> 8410712719206937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
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
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 8410918260208554 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> '&P30710_TITLE.',
  p_region_name=>'',
  p_region_attributes=>'width="100%"',
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P30710_ERRORS is null and :P30710_TRANS_TYPE != ''REJECT''',
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
  p_id=> 8723211146169965 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> 'Errors',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 7,
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
  p_plug_display_condition_type => 'ITEM_IS_NOT_NULL',
  p_plug_display_when_condition => 'P30710_ERRORS',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<a class="htmlButton" href="javascript:void(0);" onclick="javascript:closeDialog();">Close</a><br>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 16197302830743569 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30710,
  p_button_sequence=> 1,
  p_button_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_cattributes=>'onClick="javascript:closeDialog();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8638310897708112 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30710,
  p_button_sequence=> 2,
  p_button_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P30710_TITLE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_cattributes=>'onClick="javascript:confirmSave();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 7499118739010668 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30710,
  p_button_sequence=> 20,
  p_button_plug_id => 7497920723954436+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_cattributes=>'onClick="javascript:closeDialog();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 7498300076957908 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30710,
  p_button_sequence=> 30,
  p_button_plug_id => 7497920723954436+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'OK',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmSave();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>8667201960202637 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_branch_action=> 'f?p=&APP_ID.:30710:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 40,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 22-JUN-2010 11:17 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7420602839484721 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_AUTO_PRINT_TAG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 7420300499465144+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'NONE',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Auto Print Evidence Tag',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:AF Form 52;AFF52,I2MS Version;I2MS,None;NONE',
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
  p_label_alignment  => 'ABOVE',
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
  p_id=>7422820678877795 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_I2MS_RPT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'I2ms Rpt',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7423027950879980 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_ORIG_RPT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Orig Rpt',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7423426134898306 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_SEL_EVIDENCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sel Evidence',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8634926285523309 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANS_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Trans Sids',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
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
  p_id=>8635202174525809 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANS_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_id=>8635621567531401 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_id=>8637126341627345 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:99%"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'(:P30710_TRANS_TYPE=''LOGIN'' and :P30710_EV_STATUS=''S'' and core_list.count_list_elements(:P30710_TRANS_SIDS)=1) or'||chr(10)||
'(:P30710_TRANS_TYPE=''SPLIT'')',
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
  p_id=>8637404140668328 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_EFFECTIVE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char(sysdate,:FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Effective Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
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
  p_id=>8637822625683129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_STORAGE_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Storage Location',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 255,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:99%"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'LOGIN:SPLIT',
  p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST',
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
  p_id=>8638131413695067 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_PURPOSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Purpose/Comments',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_cattributes_element=>'style="width:99%"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>8649218219705870 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_CONDITION_CHANGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Condition Change',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:Yes;Y,No;N',
  p_lov_columns=> 3,
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
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'SUBMIT:LOGIN:LOGOUT:DISPOSE:UNDISPOSE:COMMENT',
  p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST',
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
  p_id=>8649814671723714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_EV_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_id=>8652308878778798 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TAG_NO_SUFFIX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Tag Number Suffix',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 5,
  p_cMaxlength=> 1,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'SPLIT',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>8653213389855815 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_OTHER_PARTY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Log Out To',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'LOGOUT',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>8655706041948315 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_EVIDENCE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Evidence',
  p_source=>'begin'||chr(10)||
'  if core_list.count_list_elements(:P30710_TRANS_SIDS) > 1 then'||chr(10)||
'     return core_list.count_list_elements(:P30710_TRANS_SIDS) ||'||chr(10)||
'            '' pieces of Evidence selected.<br>'' ||'||chr(10)||
'            ''Note: The effective dates and comments will be entered '' ||'||chr(10)||
'            ''the same for each.'';'||chr(10)||
'  else'||chr(10)||
'     return osi_evidence.get_tagline('||chr(10)||
'                 core_list.get_list_element(:P30710_TRANS_SIDS, 1));'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_id=>8659712106987942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANSFER_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
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
  p_id=>8660104272995178 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANSFER_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Transfer To',
  p_post_element_text=>'<a href="javascript:openLocator(''301'',''P30710_TRANSFER_UNIT'',''N'','''',''OPEN'','''','''',''Choose Unit to Transfer Evidence to...'',''UNITS'',''&P0_OBJ.'');" style="vertical-align:bottom; padding-left:2px;">&ICON_LOCATOR.</a>',
  p_source=>'osi_unit.get_name(:P30710_TRANSFER_UNIT)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
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
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'TRANSFER',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popupLocator(500,''P30710_TRANSFER_UNIT'');" style="vertical-align:bottom; padding-left:2px;">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8724326608240709 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_ERRORS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_id=>8724808778273429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_ERROR_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 8723211146169965+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'&P30710_ERRORS.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_id=>9807508589156361 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_DO_AUTO_PRINT_TAG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Auto Print Tag Url',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>9859007736319980 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_NEW_SID_FOR_SPLIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Sid For Split',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14899911343653284 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_HOUR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 132,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'declare'||chr(10)||
'       hour varchar2(2);'||chr(10)||
'begin'||chr(10)||
'     select to_char(sysdate,''HH24'') INTO HOUR FROM DUAL;'||chr(10)||
'     return hour;'||chr(10)||
'end;',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_prompt=>'Effective Time',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'HOURS',
  p_lov => '.'||to_char(2668702431512846 + wwv_flow_api.g_id_offset)||'.',
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
  p_id=>14900124849657116 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_MINUTE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 134,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'declare'||chr(10)||
'       hour varchar2(2);'||chr(10)||
'begin'||chr(10)||
'     select to_char(sysdate,''MI'') INTO HOUR FROM DUAL;'||chr(10)||
'     return hour;'||chr(10)||
'end;',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'MINUTES',
  p_lov => '.'||to_char(2677023537717654 + wwv_flow_api.g_id_offset)||'.',
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
  p_id=>14901710032908315 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_SECONDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 136,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'declare'||chr(10)||
'       hour varchar2(2);'||chr(10)||
'begin'||chr(10)||
'     select to_char(sysdate,''SS'') INTO HOUR FROM DUAL;'||chr(10)||
'     return hour;'||chr(10)||
'end;',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'MINUTES',
  p_lov => '.'||to_char(2677023537717654 + wwv_flow_api.g_id_offset)||'.',
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
 
wwv_flow_api.create_page_validation(
  p_id => 11821931637488028 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 1,
  p_validation => 'P30710_EFFECTIVE_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST = ''SAVE'' AND :P30710_EFFECTIVE_DATE IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8637404140668328 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8668419210377921 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'description not null',
  p_validation_sequence=> 10,
  p_validation => 'P30710_DESCRIPTION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Description must be specified.',
  p_validation_condition=> '(:P30710_TRANS_TYPE=''LOGIN'' and :P30710_EV_STATUS=''S'') or'||chr(10)||
'(:P30710_TRANS_TYPE=''SPLIT'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8637126341627345 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8668830423390653 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'transfer unit not null',
  p_validation_sequence=> 20,
  p_validation => 'P30710_TRANSFER_UNIT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Transfer Unit must be specified.',
  p_validation_condition=> 'P30710_TRANS_TYPE',
  p_validation_condition2=> 'TRANSFER',
  p_validation_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8659712106987942 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8669030338409521 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'tag no suffix alphabetic',
  p_validation_sequence=> 30,
  p_validation => 'lower(:P30710_TAG_NO_SUFFIX) between ''a'' and ''z''',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'Tag Number Suffix must be between A and Z.',
  p_validation_condition=> 'P30710_TRANS_TYPE',
  p_validation_condition2=> 'SPLIT',
  p_validation_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8652308878778798 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8669428176427898 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'other party not null',
  p_validation_sequence=> 40,
  p_validation => 'P30710_OTHER_PARTY',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Log Out To must be specified.',
  p_validation_condition=> 'P30710_TRANS_TYPE',
  p_validation_condition2=> 'LOGOUT',
  p_validation_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8653213389855815 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8668601679382320 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'purpose not null',
  p_validation_sequence=> 50,
  p_validation => 'P30710_PURPOSE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Purpose/Comments must be specified.',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8638131413695067 + wwv_flow_api.g_id_offset,
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
p:=p||'declare'||chr(10)||
'  v_return varchar2(4000);'||chr(10)||
'  v_effective_date date;'||chr(10)||
'begin'||chr(10)||
'     v_return:=osi_personnel.set_user_setting(:USER_SID,''EMM_AUTO_PRINT_TAG_AT_LOGIN'',:P30710_AUTO_PRINT_TAG);'||chr(10)||
'     :P30710_DO_AUTO_PRINT_TAG:=''NO'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'     if :P30710_TRANS_TYPE=''REJECT'' then'||chr(10)||
''||chr(10)||
'       v_effective_date := sysdate();'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       v_effective_date := to_date(:p30710_effective_date || '' '' || :p30710_hour || '':'' || ';

p:=p||':p30710_minute || '':'' || :p30710_seconds, ''DD-MON-YYYY HH24:MI:SS'');'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'    case :p30710_trans_type'||chr(10)||
''||chr(10)||
'        when ''LOGIN'' then'||chr(10)||
'            '||chr(10)||
'            if :P30710_EV_STATUS=''S'' then'||chr(10)||
'  '||chr(10)||
'              :P30710_DO_AUTO_PRINT_TAG:=''YES'';'||chr(10)||
'  '||chr(10)||
'            end if;'||chr(10)||
''||chr(10)||
'            osi_evidence.login_evidence(:p30710_trans_sids,'||chr(10)||
'                                        :p0_obj,'||chr(10)||
'                      ';

p:=p||'                  v_effective_date,'||chr(10)||
'                                        :p30710_purpose,'||chr(10)||
'                                        :p30710_description,'||chr(10)||
'                                        :p30710_condition_change,'||chr(10)||
'                                        :p30710_storage_location);'||chr(10)||
''||chr(10)||
'        when ''LOGOUT'' then'||chr(10)||
'            osi_evidence.logout_evidence(:p30710_trans_sids,'||chr(10)||
'                        ';

p:=p||'                 v_effective_date,'||chr(10)||
'                                         :p30710_purpose,'||chr(10)||
'                                         :p30710_other_party,'||chr(10)||
'                                         :p30710_condition_change);'||chr(10)||
'        when ''SPLIT'' then'||chr(10)||
''||chr(10)||
'            :P30710_DO_AUTO_PRINT_TAG:=''YES'';'||chr(10)||
''||chr(10)||
'            :P30710_NEW_SID_FOR_SPLIT:=osi_evidence.split_tag_evidence(core_list.get_list_element(:p307';

p:=p||'10_trans_sids, 1),'||chr(10)||
'                                                                  v_effective_date,'||chr(10)||
'                                                                  :p30710_purpose,'||chr(10)||
'                                                                  :p30710_description,'||chr(10)||
'                                                                  :p30710_tag_no_suffix,'||chr(10)||
'                                      ';

p:=p||'                            :p30710_storage_location);'||chr(10)||
''||chr(10)||
'        when ''TRANSFER'' then'||chr(10)||
'            osi_evidence.transfer_evidence(:p30710_trans_sids,'||chr(10)||
'                                           v_effective_date,'||chr(10)||
'                                           :p30710_purpose,'||chr(10)||
'                                           :p30710_transfer_unit,'||chr(10)||
'                                           :p0_obj,'||chr(10)||
'             ';

p:=p||'                              :p30710_condition_change);'||chr(10)||
'        when ''DISPOSE'' then'||chr(10)||
'            osi_evidence.dispose_evidence(:p30710_trans_sids,'||chr(10)||
'                                          v_effective_date,'||chr(10)||
'                                          :p30710_purpose,'||chr(10)||
'                                          :p30710_condition_change);'||chr(10)||
'        when ''UNDISPOSE'' then'||chr(10)||
'            osi_evidence.undispose_';

p:=p||'evidence(core_list.get_list_element(:p30710_trans_sids, 1),'||chr(10)||
'                                          v_effective_date,'||chr(10)||
'                                          :p30710_purpose,'||chr(10)||
'                                          :p30710_condition_change);'||chr(10)||
'        when ''COMMENT'' then'||chr(10)||
'            osi_evidence.edit_evidence(:p30710_trans_sids,'||chr(10)||
'                                       v_effective_date,'||chr(10)||
'        ';

p:=p||'                               :p30710_purpose,'||chr(10)||
'                                       :p30710_condition_change);'||chr(10)||
'        when ''REJECT'' then'||chr(10)||
'            osi_evidence.reject_evidence(core_list.get_list_element(:p30710_trans_sids, 1),'||chr(10)||
'                                            v_effective_date,'||chr(10)||
'                                            :p30710_purpose);'||chr(10)||
'        else'||chr(10)||
'            null;'||chr(10)||
'    end case';

p:=p||';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8675527717919781 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Perform Transaction',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>8638310897708112 + wwv_flow_api.g_id_offset,
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
p:=p||'declare'||chr(10)||
'   v_evidence t_osi_evidence%rowtype;'||chr(10)||
'begin'||chr(10)||
'     :P30710_AUTO_PRINT_TAG:=osi_personnel.get_user_setting(:USER_SID,''EMM_AUTO_PRINT_TAG_AT_LOGIN'',''NONE'');'||chr(10)||
''||chr(10)||
'   if :P30710_TRANS_TYPE in (''LOGIN'',''SPLIT'',''UNDISPOSE'') then'||chr(10)||
'      select *'||chr(10)||
'        into v_evidence'||chr(10)||
'        from t_osi_evidence'||chr(10)||
'       where sid = core_list.get_list_element(:P30710_TRANS_SIDS, 1);'||chr(10)||
'   end if;'||chr(10)||
'   '||chr(10)||
'   --- Set up for Auto ';

p:=p||'Printing of the TAG ---'||chr(10)||
'   if :P30710_TRANS_TYPE in (''LOGIN'',''SPLIT'') then'||chr(10)||
'     '||chr(10)||
'     :P30710_SEL_EVIDENCE:=replace(:P30710_TRANS_SIDS,''~'','''');'||chr(10)||
'     if :P30710_I2MS_RPT is null then'||chr(10)||
'       '||chr(10)||
'       select sid into :P30710_I2MS_RPT'||chr(10)||
'         from t_osi_report_type'||chr(10)||
'        where obj_type = core_obj.lookup_objtype(''EMM'')'||chr(10)||
'          and description = ''I2MS Version'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P30710_ORIG_RP';

p:=p||'T is null then'||chr(10)||
''||chr(10)||
'       select sid into :P30710_ORIG_RPT'||chr(10)||
'         from t_osi_report_type'||chr(10)||
'        where obj_type = core_obj.lookup_objtype(''EMM'')'||chr(10)||
'          and description = ''Evidence Tag'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   case :P30710_TRANS_TYPE'||chr(10)||
'      when ''SUBMIT'' then'||chr(10)||
'         :P30710_TITLE := ''Submit'';'||chr(10)||
'         :P30710_PURPOSE := ''Submitting Evidence'';'||chr(10)||
'      when ''LOGIN'' then'||chr(10)||
''||chr(10)||
'         :P30710_DESC';

p:=p||'RIPTION := v_evidence.description;'||chr(10)||
'         :P30710_STORAGE_LOCATION := v_evidence.storage_location;'||chr(10)||
'         :P30710_EV_STATUS := osi_reference.lookup_ref_code(v_evidence.status_sid);'||chr(10)||
''||chr(10)||
'         case :P30710_EV_STATUS'||chr(10)||
'            when ''C'' then'||chr(10)||
'               :P30710_TITLE := ''Log In'';'||chr(10)||
'               :P30710_PURPOSE := ''Logging in Evidence'';'||chr(10)||
'            when ''S'' then'||chr(10)||
'               :P30710_TITLE :=';

p:=p||' ''Accept'';'||chr(10)||
'               :P30710_PURPOSE := ''Accepting Submitted Evidence'';'||chr(10)||
'            when ''X'' then'||chr(10)||
'               if :p0_obj = v_evidence.transferred_from_unit_sid then'||chr(10)||
'                  :P30710_PURPOSE := ''Recalling Transferred Evidence'';'||chr(10)||
'               else'||chr(10)||
'                  :P30710_PURPOSE := ''Logging In Transferred Evidence'';'||chr(10)||
'               end if;'||chr(10)||
'               :P30710_TITLE := ''Log In'';';

p:=p||''||chr(10)||
'            when ''T'' then'||chr(10)||
'               :P30710_TITLE := ''Log In'';'||chr(10)||
'               :P30710_PURPOSE := ''Logging in Evidence'';'||chr(10)||
'            else null;'||chr(10)||
'         end case;'||chr(10)||
'      when ''LOGOUT'' then'||chr(10)||
'         :P30710_TITLE := ''Log Out'';'||chr(10)||
'         :P30710_PURPOSE := ''Logging Out Evidence'';'||chr(10)||
'         :P30710_OTHER_PARTY := osi_personnel.get_name(:USER_SID);'||chr(10)||
'      when ''TRANSFER'' then'||chr(10)||
'         :P30710_TITLE :';

p:=p||'= ''Transfer'';'||chr(10)||
'         :P30710_PURPOSE := ''Transferring Evidence'';'||chr(10)||
'      when ''SPLIT'' then'||chr(10)||
'         :P30710_TITLE := ''Derivative Evidence'';'||chr(10)||
'         :P30710_PURPOSE := ''Derivative Evidence from Tag Number: '' ||'||chr(10)||
'              osi_activity.get_id(v_evidence.obj) || ''-'' || v_evidence.seq_num ||'||chr(10)||
'              v_evidence.split_tag_char;'||chr(10)||
'         :P30710_DESCRIPTION := v_evidence.description;'||chr(10)||
'         :';

p:=p||'P30710_STORAGE_LOCATION := v_evidence.storage_location;'||chr(10)||
'      when ''RECALL'' then'||chr(10)||
'         :P30710_TITLE := ''Recall'';'||chr(10)||
'         :P30710_PURPOSE := ''Recalling Evidence'';'||chr(10)||
'      when ''DISPOSE'' then'||chr(10)||
'         :P30710_TITLE := ''Dispose'';'||chr(10)||
'         :P30710_PURPOSE := ''Disposing Evidence'';'||chr(10)||
'      when ''UNDISPOSE'' then'||chr(10)||
'         :P30710_TITLE := ''Un-Dispose'';'||chr(10)||
'         :P30710_PURPOSE := ''Un-Disposing Evidence'';';

p:=p||''||chr(10)||
'      when ''COMMENT'' then'||chr(10)||
'         :P30710_TITLE := ''Edit'';'||chr(10)||
'      when ''REJECT'' then'||chr(10)||
'         :P30710_TITLE := ''Reject'';'||chr(10)||
'         :P30710_PURPOSE := ''Reject Evidence'';'||chr(10)||
'      else'||chr(10)||
'         null;'||chr(10)||
'    end case;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8635827632570946 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
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
'    v_evid   t_osi_evidence.sid%type;'||chr(10)||
'    v_err_count number := 0;'||chr(10)||
'begin'||chr(10)||
'    :p30710_errors := null;'||chr(10)||
''||chr(10)||
'    for i in 1 .. core_list.count_list_elements(:p30710_trans_sids)'||chr(10)||
'    loop'||chr(10)||
'        v_evid := core_list.get_list_element(:p30710_trans_sids, i);'||chr(10)||
''||chr(10)||
'        case osi_evidence.lookup_evid_status_code'||chr(10)||
'                                           (osi_evidence.get_status_sid(v_evid))'||chr(10)||
'            ';

p:=p||'when ''S'' then'||chr(10)||
'                if :p30710_trans_type not in(''REJECT'', ''LOGIN'') then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' submitted evidence</li>'';'||chr(10)||
'                end if;'||chr(10)||
'            when ''X'' then'||chr(10)||
'  ';

p:=p||'              if :p30710_trans_type <> ''LOGIN'' then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' evidence '''||chr(10)||
'                        || ''transferred to another unit</li>'';'||chr(10)||
'                end if;'||chr(10)||
'           ';

p:=p||' when ''C'' then'||chr(10)||
'                if :p30710_trans_type in(''REJECT'', ''LOGIN'', ''UNDISPOSE'') then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' evidence in '''||chr(10)||
'                        || ''Custodian control</li>'';'||chr(10)||
' ';

p:=p||'               end if;'||chr(10)||
'            when ''T'' then'||chr(10)||
'                if :p30710_trans_type not in(''LOGIN'', ''DISPOSE'') then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' logged out '''||chr(10)||
'                        || ''e';

p:=p||'vidence</li>'';'||chr(10)||
'                end if;'||chr(10)||
'            when ''D'' then'||chr(10)||
'                if :p30710_trans_type <> ''UNDISPOSE'' then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' disposed '''||chr(10)||
'                        || ';

p:=p||'''evidence</li>'';'||chr(10)||
'                end if;'||chr(10)||
'            else'||chr(10)||
'                null;'||chr(10)||
'        end case;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    if v_err_count > 0 then'||chr(10)||
'        if v_err_count > 1 then'||chr(10)||
'            :p30710_errors := ''<div class="t9notification">'' ||'||chr(10)||
'                              v_err_count || '' errors have occurred.'' ||'||chr(10)||
'                              ''<ul class="htmldbUlErr">'' || :p30710_errors || ''</ul></div>';

p:=p||''';'||chr(10)||
'        else'||chr(10)||
'            :p30710_errors := ''<div class="t9notification">'' ||'||chr(10)||
'                              v_err_count || '' error has occurred.'' ||'||chr(10)||
'                              ''<ul class="htmldbUlErr">'' || :p30710_errors || ''</ul></div>'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8723409593207398 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_process_sequence=> 15,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check inputs',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'OPEN',
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
-- ...updatable report columns for page 30710
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
