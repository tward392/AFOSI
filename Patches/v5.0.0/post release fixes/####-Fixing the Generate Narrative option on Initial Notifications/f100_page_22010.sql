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
--   Date and Time:   10:54 Wednesday January 26, 2011
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

PROMPT ...Remove page 22010
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>22010);
 
end;
/

 
--application/pages/page_22010
prompt  ...PAGE 22010: Initial Notifcation Generate Narrative
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script type="text/javascript">'||chr(10)||
'function GenerateNarrative(pObj, pDoWhat)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Generate Narrative'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pObj);'||chr(10)||
' get.addParam(''x02'',pDoWhat);'||chr(10)||
''||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' var myString = String(gReturn);'||chr(10)||
' myString=myString.rep';

ph:=ph||'lace(''\n'', '''', ''g'');'||chr(10)||
' '||chr(10)||
' if(pDoWhat!=''Keep'')'||chr(10)||
'   {'||chr(10)||
'    if(myString==''Y'') '||chr(10)||
'      {'||chr(10)||
'       alert(''Narrative has been updated.'');'||chr(10)||
'       window.parent.doSubmit(''RELOAD'');'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'    if(myString==''N'') '||chr(10)||
'      {'||chr(10)||
'       alert(''Narrative did not need to be generated...'');'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' window.top.hidePopWin();'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 22010,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Initial Notifcation Generate Narrative',
  p_step_title=> 'Initial Notifcation Generate Narrative',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110126104822',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>22010,p_text=>ph);
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
  p_id=> 3725800787958172 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22010,
  p_plug_name=> 'Hidden',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<H1>'||chr(10)||
'A Narrative already exists, would you like to KEEP the CURRENT Narrative, OVERWRITE the existing Narrative, or APPEND to the CURRENT Narrative?'||chr(10)||
'</H1>'||chr(10)||
'<TABLE>'||chr(10)||
'  <TD><B>Current Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_CURRENT_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_CURRENT_NARRATIVE" readonly="readonly">&P22010_CURRENT_NAR';

s:=s||'RATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a class="htmlButton" href="javascript:GenerateNarrative(''&P22010_OBJ.'',''Keep'');">Keep Current</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>New Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_NEW_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_NEW_NARRATIVE" readonly="readonly">&P22010_N';

s:=s||'EW_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a class="htmlButton" href="javascript:GenerateNarrative(''&P22010_OBJ.'',''Over'');">Overwrite</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>Append Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_APPEND_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_APPEND_NARRATIVE" readonly="readonl';

s:=s||'y">&P22010_APPEND_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a class="htmlButton" href="javascript:GenerateNarrative(''&P22010_OBJ.'',''Append'');">Append</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>';

wwv_flow_api.create_page_plug (
  p_id=> 3775915747718095 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22010,
  p_plug_name=> 'myRegion',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<H1>'||chr(10)||
'A Narrative already exists, would you like to KEEP the CURRENT Narrative, OVERWRITE the existing Narrative, or APPEND to the CURRENT Narrative?'||chr(10)||
'</H1>'||chr(10)||
'<TABLE>'||chr(10)||
'  <TD><B>Current Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_CURRENT_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_CURRENT_NARRATIVE" readonly="readonly">&P22010_CURRENT_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a  class="htmlButton" href="javascript:doSubmit(''Keep'');" onclick="mySubmit(''Keep'');">Keep Current</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>New Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_NEW_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_NEW_NARRATIVE" readonly="readonly">&P22010_NEW_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a  class="htmlButton" href="javascript:doSubmit(''Over'');" onclick="mySubmit(''Over'');">Overwrite</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE>'||chr(10)||
' <TR>'||chr(10)||
'  <TD><B>Append Narrative:</B></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR style="border-bottom:1px solid">'||chr(10)||
'  <TD>'||chr(10)||
'   <textarea name="P22010_APPEND_NARRATIVE" rows="5" cols="80" wrap="virtual" id="P22010_APPEND_NARRATIVE" readonly="readonly">&P22010_APPEND_NARRATIVE.</textarea></TD>'||chr(10)||
' </TR>'||chr(10)||
' <TR>'||chr(10)||
'  <TD>'||chr(10)||
'   <a  class="htmlButton" href="javascript:doSubmit(''Append'');" onclick="mySubmit(''Append'');">Append</a>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>3732210564680345 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_branch_action=> 'f?p=&FLOW_ID.:22010:&SESSION.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3725100656948606 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_CURRENT_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Current Narrative:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_id=>3725309314951182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_NEW_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Narrative:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_id=>3761802751732071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Obj',
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
  p_id=>3764027020966205 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_AUTO_UPDATE_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_id=>3767531344279694 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_APPEND_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Narrative:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_id=>3785218533388827 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22010,
  p_name=>'P22010_NARRATIVES_EQUAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 3725800787958172+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narratives Equal',
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
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||':P22010_OBJ := :P0_OBJ;'||chr(10)||
':P22010_AUTO_UPDATE_NARRATIVE := ''N'';'||chr(10)||
':P22010_NARRATIVES_EQUAL := ''N'';'||chr(10)||
''||chr(10)||
'select narrative into :P22010_CURRENT_NARRATIVE from t_osi_activity where sid=:P22010_OBJ;'||chr(10)||
''||chr(10)||
':P22010_NEW_NARRATIVE := osi_util.do_title_substitution(:p0_obj,core_util.get_config(''OSI.INV_DEFAULT_BACKGROUND''));'||chr(10)||
''||chr(10)||
':P22010_APPEND_NARRATIVE := :P22010_CURRENT_NARRATIVE || chr(10) || chr(13) || :P22010_NEW_NAR';

p:=p||'RATIVE;'||chr(10)||
''||chr(10)||
'if :P22010_CURRENT_NARRATIVE is null or :P22010_CURRENT_NARRATIVE='''' then'||chr(10)||
''||chr(10)||
'  :P22010_AUTO_UPDATE_NARRATIVE := ''Y'';'||chr(10)||
''||chr(10)||
'  htp.p('''||chr(10)||
'<SCRIPT type="text/javascript">'||chr(10)||
'<!--  to hide script contents from old browsers'||chr(10)||
'GenerateNarrative(''''&P0_OBJ.'''',''''Over'''');'||chr(10)||
'window.top.hidePopWin();'||chr(10)||
'// end hiding contents from old browsers  -->'||chr(10)||
'</SCRIPT>'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P22010_CURRENT_NARRATIVE = :P22010_NEW_NARRAT';

p:=p||'IVE then'||chr(10)||
' '||chr(10)||
'  :P22010_NARRATIVES_EQUAL := ''Y'';'||chr(10)||
'htp.p(''<SCRIPT type="text/javascript">'||chr(10)||
'<!--  to hide script contents from old browsers'||chr(10)||
'alert(''''Narrative that would be generated would be the same as the current Narrative.  No Changes Made....'''');'||chr(10)||
'window.top.hidePopWin();'||chr(10)||
'// end hiding contents from old browsers  -->'||chr(10)||
'</SCRIPT>'');'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 3761525822729307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 22010,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_HEADER',
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
 
---------------------------------------
-- ...updatable report columns for page 22010
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
