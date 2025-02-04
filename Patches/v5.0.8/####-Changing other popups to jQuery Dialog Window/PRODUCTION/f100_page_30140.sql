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
--   Date and Time:   10:58 Friday August 31, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.10
 
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>1046323504969601);
 
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

PROMPT ...Remove page 30140
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30140);
 
end;
/

 
--application/pages/page_30140
prompt  ...PAGE 30140: DEERS
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script type="text/javascript">'||chr(10)||
'function checkAll()'||chr(10)||
'{'||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
'  '||chr(10)||
' for (var i = 0; i < node_list.length; i++)'||chr(10)||
'    {'||chr(10)||
'     var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'     if (node.getAttribute(''type'') == ''checkbox'')'||chr(10)||
'       {'||chr(10)||
'        node.checked=true;'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function uncheckAll()'||chr(10)||
'{'||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
'  '||chr(10)||
' for (var i = 0';

ph:=ph||'; i < node_list.length; i++)'||chr(10)||
'    {'||chr(10)||
'     var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'     if (node.getAttribute(''type'') == ''checkbox'')'||chr(10)||
'       {'||chr(10)||
'        node.checked=false;'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function DeleteDeersImportRecord()'||chr(10)||
'{'||chr(10)||
' var l_field_id = document.getElementById(''P30140_SID'');'||chr(10)||
''||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=DeleteDeersI';

ph:=ph||'mportRecord'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',l_field_id.value);'||chr(10)||
' gReturn = get.get();'||chr(10)||
' window.close();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function UpdateDeers()'||chr(10)||
'{'||chr(10)||
' var unselected = "";'||chr(10)||
''||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
''||chr(10)||
' var l_field_id = document.getElementById(''P30140_UNCHECKED_ITEMS''); '||chr(10)||
' var l_field_sid = document.getElementById(''P30140_SID''); '||chr(10)||
' var l_field_obj = docu';

ph:=ph||'ment.getElementById(''P30140_OBJ''); '||chr(10)||
'  '||chr(10)||
' for (var i = 0; i < node_list.length; i++) '||chr(10)||
'    {'||chr(10)||
'     var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'     if (node.getAttribute(''type'') == ''checkbox'') '||chr(10)||
'       {'||chr(10)||
'        if (node.checked==false)'||chr(10)||
'          {'||chr(10)||
'           if (l_field_id.value.indexOf("~" + node.name + "~") < 0)'||chr(10)||
'             {'||chr(10)||
'              unselected = unselected.concat(node.name,"~");'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
' ';

ph:=ph||'      }'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
' l_field_id.value = l_field_id.value + unselected;'||chr(10)||
''||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=UpdateDeers'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',l_field_sid.value);'||chr(10)||
' get.addParam(''x02'',l_field_obj.value);'||chr(10)||
' get.addParam(''x03'',l_field_id.value);'||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' var myStr';

ph:=ph||'ing = String(gReturn);'||chr(10)||
' myString=myString.replace(''\n'', '''', ''g'');'||chr(10)||
''||chr(10)||
' if (myString=="DEERS data matches Web I2MS data. No changes were made.")'||chr(10)||
'   {'||chr(10)||
'    // Only the DEERS timestamp was updated. //'||chr(10)||
'    alert(gReturn);'||chr(10)||
'    window.close();'||chr(10)||
'   }'||chr(10)||
' else if(myString.indexOf(''The following error occured while'')==0)'||chr(10)||
'        {'||chr(10)||
'         alert(gReturn);'||chr(10)||
'         window.close();'||chr(10)||
'        }    '||chr(10)||
'      else'||chr(10)||
'        {';

ph:=ph||''||chr(10)||
'         // A new participant version was created.         //'||chr(10)||
'         // or the Photo was changed without a new version //'||chr(10)||
'         alert(gReturn);'||chr(10)||
'         newWindow({page:''30005'', '||chr(10)||
'                    clear_cache:''30005'', '||chr(10)||
'                    name:''&P0_OBJ.'', item_names:''P0_OBJ_CONTEXT'','||chr(10)||
'                    item_values:''&P30140_RESULT.'','||chr(10)||
'                    request:''OPEN''});'||chr(10)||
'         window.cl';

ph:=ph||'ose();'||chr(10)||
'        }'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<style>'||chr(10)||
'#DEERSComparison '||chr(10)||
'                {'||chr(10)||
'                 border: none;'||chr(10)||
'                 width: 97%;'||chr(10)||
'                 font: 1em Courier New;'||chr(10)||
'                }'||chr(10)||
''||chr(10)||
'#DEERSDataColumn'||chr(10)||
'                {'||chr(10)||
'                 width: 50%;'||chr(10)||
'                }'||chr(10)||
''||chr(10)||
'#I2MSDataColumn'||chr(10)||
'                {'||chr(10)||
'                 width: 50%;'||chr(10)||
'                }'||chr(10)||
''||chr(10)||
'#DEERSData'||chr(10)||
'          {'||chr(10)||
'           border: ';

ph:=ph||'3px ridge;'||chr(10)||
'           width: 100%;'||chr(10)||
'           font: 1em Courier New;'||chr(10)||
'           border-collapse: collapse;'||chr(10)||
'          }'||chr(10)||
'#I2MSData'||chr(10)||
'         {'||chr(10)||
'          border: 3px ridge;'||chr(10)||
'          width: 100%;'||chr(10)||
'          font: 1em Courier New;'||chr(10)||
'          border-collapse: collapse;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#I2MSData td'||chr(10)||
'            {'||chr(10)||
'             height: 22px;'||chr(10)||
'             border-left: 1px solid #D9D9D9;'||chr(10)||
'             cellspacing: 0';

ph:=ph||';'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'#DEERSData td'||chr(10)||
'            {'||chr(10)||
'             height: 22px;'||chr(10)||
'             border-left: 1px solid #D9D9D9;'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'#evenRow'||chr(10)||
'         {'||chr(10)||
'          background: #fff;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#oddRow'||chr(10)||
'         {'||chr(10)||
'          background: #eee;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#currentHeader'||chr(10)||
'              {'||chr(10)||
'               border-b';

ph:=ph||'ottom: 3px ridge;'||chr(10)||
'              }'||chr(10)||
''||chr(10)||
'#DeersHeader'||chr(10)||
'              {'||chr(10)||
'               border-bottom: 3px ridge;'||chr(10)||
'              }'||chr(10)||
'</style>';

wwv_flow_api.create_page(
  p_id     => 30140,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'DEERS',
  p_step_title=> 'DEERS Check',
  p_step_sub_title => 'DEERS',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110119080010',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30140,p_text=>ph);
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
  p_id=> 3210011864697148 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30140,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'DECLARE'||chr(10)||
'BEGIN'||chr(10)||
''||chr(10)||
'  htp.p(:p30140_html);'||chr(10)||
'  '||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_plug (
  p_id=> 3657419316494285 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30140,
  p_plug_name=> 'Participant Comparison',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 3,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_plug_display_when_condition => 'P30140_SHOWN',
  p_plug_display_when_cond2=>'Y',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 3210432486697150 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 5,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'UPDATE_DEERS',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Update',
  p_button_position=> 'REGION_TEMPLATE_EDIT',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:UpdateDeers();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3210204089697148 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 15,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:DeleteDeersImportRecord();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3674719343071494 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 10,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'SELECT_ALL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Select All',
  p_button_position=> 'REGION_TEMPLATE_NEXT',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:checkAll();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 3675712726116890 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30140,
  p_button_sequence=> 11,
  p_button_plug_id => 3657419316494285+wwv_flow_api.g_id_offset,
  p_button_name    => 'DESELECT_ALL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'De-Select All',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:uncheckAll();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>3229528606697206 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_branch_action=> 'f?p=&APP_ID.:30140:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 09-APR-2010 16:07 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3211201166697151 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3222012720697181 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30140_RESULT=',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 8000,
  p_cHeight=> 10,
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
  p_id=>3222422691697182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3222605017697182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_MUGSHOT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'PHOTO',
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
  p_id=>3222810502697184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_D_MUGSHOT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'DEERS_PHOTO',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>3336827467553720 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P30140_ACTION=',
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
  p_id=>3580728043495959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_ACTION_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3643831470455779 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_SHOWN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 248,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>3658328413553673 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_HTML',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 258,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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
  p_id=>4330830460650535 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30140,
  p_name=>'P30140_UNCHECKED_ITEMS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 3210011864697148+wwv_flow_api.g_id_offset,
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
''||chr(10)||
'  if (:p30140_sid is null) then'||chr(10)||
''||chr(10)||
'    :p30140_sid := osi_deers.get_deers_information(:p30140_obj, null, 0, null);'||chr(10)||
''||chr(10)||
'    -- A match was not found or an error occured.'||chr(10)||
'    if (:p30140_sid is null) then'||chr(10)||
'    '||chr(10)||
'      :p30140_shown  := ''N'';'||chr(10)||
'      htp.p(''<script language="JavaScript">alert("'' || ltrim(ltrim(osi_deers.get_import_message, ''ERROR ''), ''MSG '') || ''");window.close();</script>'');'||chr(10)||
''||chr(10)||
'    end i';

p:=p||'f;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 3228810727697204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30140,
  p_process_sequence=> 1,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CANCEL',
  p_process_when_type=>'REQUEST_NOT_EQUAL_CONDITION',
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
p:=p||'F|#OWNER#:V_OSI_DEERS_COMPARE:P30140_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 3229019374697204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30140,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Get V_OSI_DEERS_COMPARE',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P30140_SID',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
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
p:=p||'DECLARE'||chr(10)||
''||chr(10)||
'  p_shown          varchar2(1);'||chr(10)||
'  p_uncheckedItems varchar2(4000);'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'  '||chr(10)||
'  :p30140_html := osi_deers.deers_compare(:p30140_obj, p_shown, p_uncheckedItems);'||chr(10)||
'  '||chr(10)||
'  :p30140_shown := p_shown;'||chr(10)||
'  :p30140_unchecked_items := p_uncheckedItems;'||chr(10)||
'  '||chr(10)||
'  if p_shown = ''N'' then'||chr(10)||
''||chr(10)||
'    osi_deers.delete_import_record(:P30140_SID);'||chr(10)||
'    htp.p(''<script language="JavaScript">alert("All Web I2MS information is ';

p:=p||'up to date.");window.close();</script>'');'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 3584410530001928 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30140,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check for differences',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'P30140_SID',
  p_process_when_type=>'ITEM_IS_NOT_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30140
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
