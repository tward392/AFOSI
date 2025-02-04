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
--   Date and Time:   06:44 Friday November 2, 2012
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

PROMPT ...Remove page 5255
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5255);
 
end;
/

 
--application/pages/page_05255
prompt  ...PAGE 5255: Multiple Work Hours Entry
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script type="text/javascript">'||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' $("#Remove").hide();'||chr(10)||
''||chr(10)||
' $(''#P5255_PAY_CAT option:selected'').next().attr(''selected'',''selected'');'||chr(10)||
' $(''#P5255_PERSONNEL option:selected'').next().attr(''selected'',''selected'');'||chr(10)||
' $(''#P5255_MISSION option:selected'').next().attr(''selected'',''selected'');'||chr(10)||
'});'||chr(10)||
''||chr(10)||
'function AddNew()'||chr(10)||
'{'||chr(10)||
' $("#P5255_WORKHOURSVALUES tr:nth-child(2)").clone(true, true).find';

ph:=ph||'("input,select,a").each(function() '||chr(10)||
'  {'||chr(10)||
'   if ($(this).attr(''id'') == ''Remove'')'||chr(10)||
'     $(this).show();'||chr(10)||
'   '||chr(10)||
'   if ($(this).attr(''type'') == ''hidden'')'||chr(10)||
'     $(this).remove();'||chr(10)||
''||chr(10)||
'   $(this).attr(''id'', function(_, id) { return id + i });'||chr(10)||
''||chr(10)||
'  }).end().appendTo("#P5255_WORKHOURSVALUES");'||chr(10)||
''||chr(10)||
'  duplicateSelects(i);'||chr(10)||
'  i++;'||chr(10)||
''||chr(10)||
' setupDateTimePickers();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function Remove(pthis)'||chr(10)||
'{'||chr(10)||
' $(pthis).parent().parent().remove();'||chr(10)||
'}'||chr(10)||
'';

ph:=ph||''||chr(10)||
'function duplicateSelects(i)'||chr(10)||
'{'||chr(10)||
' var prev;'||chr(10)||
''||chr(10)||
' if(i==0)'||chr(10)||
'   prev = '''';'||chr(10)||
' else'||chr(10)||
'   prev = i-1;'||chr(10)||
''||chr(10)||
' $(''#P5255_PAY_CAT''+i).val($(''#P5255_PAY_CAT''+prev).val());'||chr(10)||
' $(''#P5255_DUTY_CAT''+i).val($(''#P5255_DUTY_CAT''+prev).val());'||chr(10)||
' $(''#P5255_PERSONNEL''+i).val($(''#P5255_PERSONNEL''+prev).val());'||chr(10)||
' $(''#P5255_PERSONNEL''+i+'' option:selected'').next().attr(''selected'',''selected'');'||chr(10)||
''||chr(10)||
' $(''#P5255_MISSION''+i).val($(''#P5255_MISSIO';

ph:=ph||'N''+prev).val());'||chr(10)||
' $(''#P5255_HOURS''+i).val($(''#P5255_HOURS''+prev).val());'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function setupDateTimePickers()'||chr(10)||
'{'||chr(10)||
' $(".ui-datepicker-trigger").remove();'||chr(10)||
' $(''.datepickernew'').removeClass(''hasDatepicker'').datepicker();'||chr(10)||
' $(''a.pickToday'').click(function() {$(this).prev().prev(''input.datepickernew'').datepicker(''setDate'', new Date());});'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function Save()'||chr(10)||
'{'||chr(10)||
' var id;'||chr(10)||
' var msg;'||chr(10)||
' var atLeastOneInserted = ''N'';';

ph:=ph||''||chr(10)||
''||chr(10)||
' $("#P5255_WAIT_ICON").show();'||chr(10)||
' $("#SaveButton").hide();'||chr(10)||
' $("#addNew").hide();'||chr(10)||
' $("#CancelButton").hide();'||chr(10)||
''||chr(10)||
' $("#P5255_WORKHOURSVALUES tbody").find("tr").each(function() '||chr(10)||
'  {'||chr(10)||
'   msg = ''Could not add a record:\n\n'';'||chr(10)||
''||chr(10)||
'   var get = new htmldb_Get(null,'||chr(10)||
'                            $v(''pFlowId''),'||chr(10)||
'                            ''APPLICATION_PROCESS=SaveWorkHours'','||chr(10)||
'                            $v(''pFlowSte';

ph:=ph||'pId''));'||chr(10)||
''||chr(10)||
'   $(this).find("select,input").each(function()'||chr(10)||
'    {'||chr(10)||
'     id = $(this).attr(''id'');'||chr(10)||
'     if(id!==undefined)'||chr(10)||
'       {'||chr(10)||
'        switch ($(this).attr(''id'').substring(0,11))'||chr(10)||
'        {'||chr(10)||
'           case ''P5255_PAY_C'':'||chr(10)||
'                              if ($(this).val() == ''%null%'')'||chr(10)||
'                                msg = msg + ''Pay Category cannot be blank!\n'';'||chr(10)||
''||chr(10)||
'                              get.addPar';

ph:=ph||'am(''x01'',$(this).val());'||chr(10)||
'                              break;'||chr(10)||
''||chr(10)||
'           case ''P5255_DUTY_'':'||chr(10)||
'                              if ($(this).val() == ''%null%'')'||chr(10)||
'                                msg = msg + ''Duty Category cannot be blank!\n'';'||chr(10)||
''||chr(10)||
'                              get.addParam(''x02'',$(this).val());'||chr(10)||
'                              break;'||chr(10)||
''||chr(10)||
'           case ''P5255_PERSO'':'||chr(10)||
'                              ';

ph:=ph||'if ($(this).val() == ''%null%'')'||chr(10)||
'                                msg = msg + ''Personnel cannot be blank!\n'';'||chr(10)||
''||chr(10)||
'                              get.addParam(''x03'',$(this).val());'||chr(10)||
'                              break;'||chr(10)||
''||chr(10)||
'           case ''P5255_MISSI'':'||chr(10)||
'                              get.addParam(''x04'',$(this).val());'||chr(10)||
'                              break;'||chr(10)||
''||chr(10)||
'           case ''P5255_WORK_'':'||chr(10)||
'                        ';

ph:=ph||'      if ($(this).val() == '''')'||chr(10)||
'                                msg = msg + ''Work Date cannot be blank!\n'';'||chr(10)||
''||chr(10)||
'                              if (new Date($(this).val().replace(/-/g,'' '')) > new Date())'||chr(10)||
'                                msg = msg + ''Work Date cannot be greater than Today!\n'';'||chr(10)||
''||chr(10)||
'                              get.addParam(''x05'',$(this).val());'||chr(10)||
'                              break;'||chr(10)||
''||chr(10)||
'         ';

ph:=ph||'  case ''P5255_HOURS'':'||chr(10)||
'                              if ($(this).val() <= 0)'||chr(10)||
'                                msg = msg + ''Hours must be greater than 0!\n'';'||chr(10)||
'                              '||chr(10)||
'                              if(msg != ''Could not add a record:\n\n'')'||chr(10)||
'                                alert(msg);'||chr(10)||
'                              else'||chr(10)||
'                                {'||chr(10)||
'                              ';

ph:=ph||'   get.addParam(''x06'',$(this).val());'||chr(10)||
'                                 get.addParam(''x07'',$(''#P5255_OBJ'').val());'||chr(10)||
'                                 gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'                                 if(gReturn!=''TRUE'')'||chr(10)||
'                                   alert(gReturn);'||chr(10)||
'                                 else'||chr(10)||
'                                   atLeastOneInserted = ''Y'';'||chr(10)||
'                    ';

ph:=ph||'            }'||chr(10)||
'                              break;'||chr(10)||
'        }'||chr(10)||
'       }'||chr(10)||
'     '||chr(10)||
'    });'||chr(10)||
'  });'||chr(10)||
' '||chr(10)||
' if(atLeastOneInserted==''Y'')'||chr(10)||
'   window.parent.location.reload();'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    $("#P5255_WAIT_ICON").hide();'||chr(10)||
'    $("#SaveButton").show();'||chr(10)||
'    $("#addNew").show();'||chr(10)||
'    $("#CancelButton").show();'||chr(10)||
''||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 5255,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Multiple Work Hours Entry',
  p_step_title=> 'Multiple Work Hours Entry',
  p_step_sub_title => 'Multiple Work Hours Entry',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121102064245',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '24-Aug-2012 - Tim Ward - CR#4083 - Created to Allow Multiple Work '||chr(10)||
'                                    Hour Entries at once.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5255,p_text=>ph);
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
  p_id=> 16022422554437810 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5255,
  p_plug_name=> 'Work Hours to Add',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 100,
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
s:=s||'<div class="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 16023025097437811 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5255,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
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
  p_plug_required_role => '!'||(5922010158979075+ wwv_flow_api.g_id_offset),
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
  p_id=>16031104544437824 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_branch_action=> 'f?p=&APP_ID.:5255:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P5255_OBJ1.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 06-MAY-2009 10:30 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16025009946437816 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_PAY_CAT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>16025202524437816 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_DUTY_CAT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>16025405551437816 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_PAY_CAT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => ':p5250_pay_cat',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Pay Category:',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P5255_PAY_CAT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'-Select Pay Category -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>16025605314437816 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_DUTY_CAT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'osi_reference.lookup_ref_sid(''DUTY_CATEGORY'',''01'')',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Duty Category:',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P5255_DUTY_CAT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Duty Category -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>16025820287437817 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_PERSONNEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => ':p5250_personnel',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Personnel:',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select distinct osi_personnel.get_name(personnel)d, personnel r'||chr(10)||
'  from t_osi_assignment'||chr(10)||
' where obj = :p5255_obj'||chr(10)||
' order by osi_personnel.get_name(personnel)',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Personnel -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>16026000104437817 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_MISSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Mission:',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_mission_category'||chr(10)||
' where management_area=''Y'''||chr(10)||
'   and active = ''Y'''||chr(10)||
' order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Mission -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
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
  p_id=>16026217469437817 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_HOURS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Hours:',
  p_post_element_text=>'<td><br><a id="Remove" style="float:none;" class="htmlButton" href="javascript:void(0);" onclick="javascript:Remove(this);">X</a></td>',
  p_source=>'HOURS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 4,
  p_cMaxlength=> 4,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>16026415356437817 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
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
  p_id=>16027429879437817 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_WORK_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char(sysdate,:FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Work Date:',
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
  p_cattributes_element=>'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
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
  p_id=>16043330803908087 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_WORKHOURSVALUES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
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
  p_id=>16046717306329998 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_ADDNEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a id="addNew" class="htmlButton" href="javascript:void(0);" onclick="javascript:AddNew();">Add New</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'nowrap="nowrap" style="padding:4px 0px 4px 0px;"',
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
  p_id=>16085507244389164 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_SAVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a id="SaveButton" class="htmlButton" href="javascript:void(0);" onClick="javascript:Save();">Save</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>' nowrap="nowrap" style="padding:4px 0px 4px 0px;"',
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
  p_id=>16179931658451693 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_CANCEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a id="CancelButton" class="htmlButton" href="javascript:void(0);" onClick="javascript:closeDialog();">Cancel</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>' nowrap="nowrap" style="padding:4px 0px 4px 0px;"',
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
  p_id=>16182117637835598 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5255,
  p_name=>'P5255_WAIT_ICON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 16022422554437810+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<div><img src="#IMAGE_PREFIX#ajax-loader.gif" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saving.....Please Wait!</div>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="display:none;"',
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||':P5255_OBJ:=:P0_OBJ;'||chr(10)||
''||chr(10)||
'if :p5255_pay_cat_lov is null then'||chr(10)||
'  :p5255_pay_cat_lov := osi_reference.get_lov(''PERSONNEL_PAY_CATEGORY'');'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :p5255_duty_cat_lov is null then'||chr(10)||
'  :p5255_duty_cat_lov := osi_reference.get_lov(''DUTY_CATEGORY'');'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :REQUEST = ''ADD'' then'||chr(10)||
'  for i in (select personnel '||chr(10)||
'              from (select personnel'||chr(10)||
'                      from t_osi_assignment'||chr(10)||
'               ';

p:=p||'      where obj = :p0_obj'||chr(10)||
'                     order by osi_personnel.get_name(personnel))'||chr(10)||
'             where rownum = 1) loop'||chr(10)||
'     :p5255_personnel := i.personnel;'||chr(10)||
'  end loop;'||chr(10)||
'  :p5255_obj := :p0_obj;'||chr(10)||
'end if;'||chr(10)||
'if :REQUEST in (''ADD'', ''P5255_PERSONNEL'')  and :p5255_personnel is not null then'||chr(10)||
'     select pay_category'||chr(10)||
'       into :p5255_pay_cat'||chr(10)||
'       from t_osi_personnel'||chr(10)||
'      where sid = :p5255_pers';

p:=p||'onnel;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 16029209982437822 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5255,
  p_process_sequence=> 20,
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
 
---------------------------------------
-- ...updatable report columns for page 5255
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
