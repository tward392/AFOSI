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
--   Date and Time:   07:21 Thursday August 2, 2012
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

PROMPT ...Remove page 22710
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>22710);
 
end;
/

 
--application/pages/page_22710
prompt  ...PAGE 22710: View Fingerprints
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_SEND_REQUEST"';

wwv_flow_api.create_page(
  p_id     => 22710,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'View Fingerprints',
  p_step_title=> '&P0_OBJ_TAGLINE_SHORT.',
  p_step_sub_title => 'View Fingerprints/Palmprints',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120802071920',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '02-Aug-2012 - Tim Ward - P0_OBJ Passing in the Page Branches.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>22710,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<CENTER>'||chr(10)||
'<TABLE BORDER=1 CELLSPACING=0, BORDERCOLOR=RED>'||chr(10)||
'<TR><TD>'||chr(10)||
'<TABLE BORDER=1 CELLSPACING=0, BORDERCOLOR=RED>'||chr(10)||
'<TR><TD><B><FONT COLOR=RED>***** NO FINGERPRINT IMAGES WERE FOUND *****</FONT></B></TD></TR>'||chr(10)||
'</TABLE>'||chr(10)||
'</TD></TR>'||chr(10)||
'</TABLE>'||chr(10)||
'</CENTER>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 1201232587672462 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22710,
  p_plug_name=> 'EFT PACKET IS MISSING',
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
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P22710_IMAGES_LOADED',
  p_plug_display_when_cond2=>'EFT FILE NOT FOUND',
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
  p_id=> 4407516101556523 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22710,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 188668793727358242+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
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
s:=s||'<TABLE class="fingerprintsTable">'||chr(10)||
' <TR>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,1,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>R. Thumb</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,2,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>R. Index</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD ';

s:=s||'class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,3,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>R. Middle</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,4,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>R. Ring</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:';

s:=s||'22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,5,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>R. Little</B>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
''||chr(10)||
' <TR>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,6,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>L. Thumb</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_';

s:=s||'OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,7,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>L. Index</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,8,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>L. Middle</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,9,F"'||chr(10)||
'    ';

s:=s||'WIDTH=150 HEIGHT=150><BR><B>L. Ring</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="rollprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,10,F"'||chr(10)||
'    WIDTH=150 HEIGHT=150><BR><B>L. Little</B>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>'||chr(10)||
''||chr(10)||
'<TABLE class="fingerprintsTable">'||chr(10)||
' <TR>'||chr(10)||
'  <TD class="fourslapprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P';

s:=s||'0_OBJ.,14,F" '||chr(10)||
'    WIDTH=300 HEIGHT=200><BR><B>Left Four Fingers Taken Simultaneously</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="thumbslapprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,12,F"'||chr(10)||
'    WIDTH=73 HEIGHT=200><BR><B>L. Thumb</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="thumbslapprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OB';

s:=s||'J.,11,F"'||chr(10)||
'    WIDTH=73 HEIGHT=200><BR><B>R. Thumb</B>'||chr(10)||
'  </TD>'||chr(10)||
'  <TD class="fourslapprints">'||chr(10)||
'   <IMG SRC="f?p=&APP_ID.:22712:&SESSION.:::22712:P22712_OBJ,P22712_IDX,P22712_FORP:&P0_OBJ.,13,F" '||chr(10)||
'    WIDTH=300 HEIGHT=200><BR><B>Right Four Fingers Taken Simultaneously</B>'||chr(10)||
'  </TD>'||chr(10)||
' </TR>'||chr(10)||
'</TABLE>';

wwv_flow_api.create_page_plug (
  p_id=> 4455809238909776 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22710,
  p_plug_name=> 'Fingerprint Images',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P22710_IMAGES_LOADED',
  p_plug_display_when_cond2=>'OK',
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
  p_id=>4411238919556526 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22710,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>4411424347556526 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22710,
  p_branch_action=> 'f?p=&APP_ID.:22710:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P22710_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1200928993662012 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22710,
  p_name=>'P22710_IMAGES_LOADED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 4407516101556523+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Images Loaded',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4408321748556524 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22710,
  p_name=>'P22710_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> .5,
  p_item_plug_id => 4407516101556523+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Sid',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
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
  p_field_template => 188672785063358258+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 4410015173556524 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22710,
  p_computation_sequence => 10,
  p_computation_item=> 'P22710_SID',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> ':P0_OBJ',
  p_compute_when => 'P22710_SID',
  p_compute_when_type=>'');
 
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
'  :P22710_IMAGES_LOADED := osi_fingerprint.load_images_from_eft(:P0_OBJ);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 4455629885906340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 22710,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_BOX_BODY',
  p_process_type=> 'PLSQL',
  p_process_name=> 'LOAD_IMAGES',
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
-- ...updatable report columns for page 22710
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
