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
--   Date and Time:   09:51 Wednesday November 9, 2011
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

PROMPT ...Remove page 822
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>822);
 
end;
/

 
--application/pages/page_00822
prompt  ...PAGE 822: Report Spec (Rearrange Narratives)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 822,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Report Spec (Rearrange Narratives)',
  p_step_title=> 'Report Spec (Rearrange Narratives)',
  p_step_sub_title => 'Report Spec (Rearrange Narratives)',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20111109095102',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '10-Aug-2011 Tim Ward CR#3871 - Rearrange ROI Narratives.'||chr(10)||
'                                Created this page.');
 
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
  p_id=> 7141728600663072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 822,
  p_plug_name=> 'Hidden Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 70,
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
s:=s||'DECLARE'||chr(10)||
'BEGIN'||chr(10)||
'wwv_flow.debug(''Showing The God Damned Region NOW..........'');'||chr(10)||
'  htp.p(:p822_html1);'||chr(10)||
'  htp.p(:p822_html2);'||chr(10)||
'  htp.p(:p822_html3);'||chr(10)||
'  htp.p(:p822_html4);'||chr(10)||
'  htp.p(:p822_html5);'||chr(10)||
'  htp.p(:p822_html6);'||chr(10)||
'  htp.p(:p822_html7);'||chr(10)||
'  htp.p(:p822_html8);'||chr(10)||
'  htp.p(:p822_html9);'||chr(10)||
'  htp.p(:p822_html10);'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_plug (
  p_id=> 7142105238663072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 822,
  p_plug_name=> 'Rearrange Narrative Sequence....',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 80,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
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
  p_plug_header=> '<html>'||chr(10)||
'<head>'||chr(10)||
'<link id="themeStyles" rel="stylesheet" href=""#IMAGE_PREFIX#dojo-release-1.6.1/dijit/themes/claro/claro.css">'||chr(10)||
''||chr(10)||
' <link type="text/css" rel="stylesheet" href="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/resources/dnd.css"/>'||chr(10)||
''||chr(10)||
' <style type="text/css">'||chr(10)||
''||chr(10)||
'  body { padding: 1em; background: white; }'||chr(10)||
''||chr(10)||
'  .container { width: auto; display: block; }'||chr(10)||
'  .container.handles .dojoDndHandle { background: #fee; }'||chr(10)||
''||chr(10)||
'  button {'||chr(10)||
'          -webkit-transition: background-color 0.2s linear;'||chr(10)||
'          border-radius:4px;'||chr(10)||
'          -moz-border-radius: 4px 4px 4px 4px;'||chr(10)||
'          -moz-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.15);'||chr(10)||
'          background-color: #E4F2FF;'||chr(10)||
'          background-image: url("#IMAGE_PREFIX#dojo-release-1.6.1/dijit/themes/claro/form/images/button.png");'||chr(10)||
'          background-position: center top;'||chr(10)||
'          background-repeat: repeat-x;'||chr(10)||
'          border: 1px solid #769DC0;'||chr(10)||
'          padding: 2px 8px 4px;'||chr(10)||
'          font-size:1em;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'  button:hover {'||chr(10)||
'                background-color: #AFD9FF;'||chr(10)||
'                color: #000000;'||chr(10)||
'               }'||chr(10)||
''||chr(10)||
'.reportContainer {'||chr(10)||
'	overflow-y: scroll;'||chr(10)||
'	overflow-x: hidden;'||chr(10)||
'	border: solid 1px #aaa;'||chr(10)||
'	margin: 0px;'||chr(10)||
'	padding: 0px;'||chr(10)||
'	max-height: 195px;'||chr(10)||
'	float: left;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.container {'||chr(10)||
'/*	margin-right: 17px;*/'||chr(10)||
'	border-collapse: collapse;'||chr(10)||
'	border: solid 1px #aaa;'||chr(10)||
'	margin: 0px;'||chr(10)||
'	padding: 0px;'||chr(10)||
'}'||chr(10)||
'.container thead tr {'||chr(10)||
'	position: relative;'||chr(10)||
'	height: auto;'||chr(10)||
'	top: expression( this.parentNode.parentNode.parentNode.scrollTop + ''px'' );   '||chr(10)||
'}'||chr(10)||
'.container thead td {'||chr(10)||
'	color: #fff;'||chr(10)||
'	background-color: #4e7ec2;'||chr(10)||
'	border: solid 1px #aaa;'||chr(10)||
'	border-top: none;'||chr(10)||
'	border-left: none;'||chr(10)||
'	offset-top: 10px;'||chr(10)||
'	font-size: 12px;'||chr(10)||
'	font-weight: bold;'||chr(10)||
'	white-space: nowrap;'||chr(10)||
'}'||chr(10)||
'.container thead td a { color:#fff; }'||chr(10)||
'.container thead td a:hover { color:#ffffaa; active:lightblue; }'||chr(10)||
'	'||chr(10)||
'.container td {'||chr(10)||
'	border: #aaa 1px solid;'||chr(10)||
'	border-left: none;'||chr(10)||
'	padding: 3px;'||chr(10)||
'	font-size: 12px;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.container tbody {'||chr(10)||
'	overflow-x: hidden;'||chr(10)||
'	overflow-y: auto;'||chr(10)||
'	border-collapse: collapse;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
' </style>'||chr(10)||
''||chr(10)||
' <script type="text/javascript" src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" djConfig="isDebug: false, parseOnLoad: true"></script>'||chr(10)||
' <script type="text/javascript">'||chr(10)||
''||chr(10)||
'  var node = dojo.byId("RunReport");'||chr(10)||
'  node.style.visibility="hidden";'||chr(10)||
''||chr(10)||
'  dojo.require("dojo.parser");'||chr(10)||
'  dojo.require("dojo.dnd.Source");'||chr(10)||
''||chr(10)||
'  var initDND = function()'||chr(10)||
'  {'||chr(10)||
'   dojo.subscribe("/dnd/start", null, function(source,node,copy)'||chr(10)||
'                 {'||chr(10)||
'                  console.log("/dnd/start",source,node);'||chr(10)||
'                  //Don''t allow copies to be made'||chr(10)||
'                  console.log("copy="+copy);'||chr(10)||
'                  if(copy == true) '||chr(10)||
'                    {'||chr(10)||
'                     source.copyState = function(){return false;};'||chr(10)||
'                    }'||chr(10)||
'                 });'||chr(10)||
'   dojo.subscribe("/dnd/stop", null, function(source,node,copy)'||chr(10)||
'                 {'||chr(10)||
'                  console.log("/dnd/stop",source,node);'||chr(10)||
'                  //Don''t allow copies to be made'||chr(10)||
'                  console.log("copy="+copy);'||chr(10)||
'                  if(copy == true) '||chr(10)||
'                    {'||chr(10)||
'                     source.copyState = function(){return false;};'||chr(10)||
'                    }'||chr(10)||
'                 });'||chr(10)||
'  }'||chr(10)||
'  dojo.addOnLoad(initDND);'||chr(10)||
' </script>'||chr(10)||
''||chr(10)||
'</head>'||chr(10)||
'<body>'||chr(10)||
'  <h2><center>Rearrange Narrative Sequence....</center></h2>'||chr(10)||
'   <button onclick="javascript:Cancel();return(false);" style="float:right;">Cancel</button>'||chr(10)||
'   <button onclick="javascript:SaveOrder();return(false);" style="float:right;">Save</button>'||chr(10)||
'   <br>'||chr(10)||
'  <table dojoType="dojo.dnd.Source" jsId="c3" class="container" border=1 width=100%>'||chr(10)||
'  <thead>'||chr(10)||
'  <tr>'||chr(10)||
'   <td>Para.</td>'||chr(10)||
'   <td>Activity ID</td>'||chr(10)||
'   <td>Activity Type</td>'||chr(10)||
'   <td>Activity Group</td>'||chr(10)||
'   <td>Activity Title</td>'||chr(10)||
'   <td>Completed Date</td>'||chr(10)||
'   <td>Narrative Text</td>'||chr(10)||
'  </tr>'||chr(10)||
'  </thead>',
  p_plug_footer=> ' </table>'||chr(10)||
' <button onclick="javascript:Cancel();return(false);" style="float:right;">Cancel</button>'||chr(10)||
' <button onclick="javascript:SaveOrder();return(false);" style="float:right;">Save</button>'||chr(10)||
'</body>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
''||chr(10)||
'  var SaveOrder = function()'||chr(10)||
'  {'||chr(10)||
'   var msg = '''';'||chr(10)||
'   var NarrativeLength = c3.getAllNodes().length;'||chr(10)||
'   '||chr(10)||
'    c3.getAllNodes().forEach(function(node){'||chr(10)||
'    msg = msg + node.id + '','';'||chr(10)||
'    });   '||chr(10)||
''||chr(10)||
'   var get = new htmldb_Get(null,'||chr(10)||
'                            $v(''pFlowId''),'||chr(10)||
'                            ''APPLICATION_PROCESS=UpdateNarrativeOrder'','||chr(10)||
'                            $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'   get.addParam(''x01'',msg);'||chr(10)||
'   gReturn = get.get();'||chr(10)||
''||chr(10)||
'   window.opener.doSubmit(''REFRESH''); '||chr(10)||
'   window.close();'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'  var Cancel = function()'||chr(10)||
'  {'||chr(10)||
'   window.close();'||chr(10)||
'  }'||chr(10)||
'</script>'||chr(10)||
'</html>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '09-Nov-2011 - Tim Ward - Internet Explorer 7 shows a Debug Console.  Changed'||chr(10)||
'                         isDebug: true to false in the Region Header call to'||chr(10)||
'                         load dojo.js.');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>7144606886663078 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_branch_action=> 'f?p=&APP_ID.:822:&SESSION.::&DEBUG.:::#top',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition=> 'SaveOrder',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-AUG-2011 07:19 by TWARD');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7142315917663074 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7142505821663075 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7142706023663075 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7142901839663075 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7143124294663077 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7143326242663077 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7143501859663077 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7143701884663077 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML10',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7143915915663077 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
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
  p_id=>7144129034663077 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_HTML1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html',
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
  p_id=>7146800866096072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_SPEC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Spec',
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
  p_id=>7147007099097856 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_FILTERS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Filters',
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
  p_id=>7148701595399119 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_RECORDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Records',
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
  p_id=>7152721231040439 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 822,
  p_name=>'P822_NEWORDER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 7141728600663072+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Neworder',
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
p:=p||'htp.p(''javascript:alert("&P822_NEWORDER.");'');';

wwv_flow_api.create_page_process(
  p_id     => 7152315905029405 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 822,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SaveOrder',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SaveOrder',
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
p:=p||'DECLARE'||chr(10)||
'  '||chr(10)||
'  v_cnt number;'||chr(10)||
'  v_return clob;'||chr(10)||
'  v_records number;'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
''||chr(10)||
'  :P822_SPEC:=:P820_SPEC; '||chr(10)||
'  :P822_FILTERS:=:P820_FILTERS;'||chr(10)||
'  '||chr(10)||
'  v_cnt := 1;'||chr(10)||
'  v_records := 1;'||chr(10)||
''||chr(10)||
'  :p822_html1 := '''';'||chr(10)||
'  :p822_html2 := '''';'||chr(10)||
'  :p822_html3 := '''';'||chr(10)||
'  :p822_html4 := '''';'||chr(10)||
'  :p822_html5 := '''';'||chr(10)||
'  :p822_html6 := '''';'||chr(10)||
'  :p822_html7 := '''';'||chr(10)||
'  :p822_html8 := '''';'||chr(10)||
'  :p822_html9 := '''';'||chr(10)||
'  :p822_html10 := '''';'||chr(10)||
''||chr(10)||
'  for a in (select SI';

p:=p||'D,'||chr(10)||
'                   SEQ,'||chr(10)||
'                   ID,'||chr(10)||
'                   SUBTYPE_DESC,'||chr(10)||
'                   ROI_GROUP,'||chr(10)||
'                   TITLE,'||chr(10)||
'                   ACTIVITY_DATE,'||chr(10)||
'                   COMPLETE_DATE,'||chr(10)||
'                   decode(SELECTED, ''Y'',''Yes'',''N'',''No'',null) as Selected,   '||chr(10)||
'                   substr(NARRATIVE,1,50) AS NARRATIVE,'||chr(10)||
'                   activity_sid'||chr(10)||
'                   from V_OS';

p:=p||'I_RPT_AVAIL_ACTIVITY where 1=1 &P820_FILTERS.)-- order by SEQ)'||chr(10)||
' loop'||chr(10)||
'     v_return := v_return || ''<tr class="dojoDndItem" id="'' || a.sid || ''">'';'||chr(10)||
'     v_return := v_return || ''<td>'' || v_records || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.ID || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.SUBTYPE_DESC || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.ROI_GROUP || ''</td>'';'||chr(10)||
'     v_';

p:=p||'return := v_return || ''<td>'' || a.TITLE || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.COMPLETE_DATE || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.NARRATIVE || ''</td>'';'||chr(10)||
'     v_return := v_return || ''</tr>'';'||chr(10)||
'            '||chr(10)||
'     if length(v_return) >= 22000 then'||chr(10)||
'       '||chr(10)||
'       case '||chr(10)||
'           '||chr(10)||
'           when v_cnt = 0 then'||chr(10)||
'                              :p822_html1 := v_return;'||chr(10)||
'         ';

p:=p||'  when v_cnt = 1 then'||chr(10)||
'                              :p822_html2 := v_return;'||chr(10)||
'           when v_cnt = 2 then'||chr(10)||
'                              :p822_html3 := v_return;'||chr(10)||
'           when v_cnt = 3 then'||chr(10)||
'                              :p822_html4 := v_return;'||chr(10)||
'           when v_cnt = 4 then'||chr(10)||
'                              :p822_html5 := v_return;'||chr(10)||
'           when v_cnt = 5 then'||chr(10)||
'                              :p82';

p:=p||'2_html6 := v_return;'||chr(10)||
'           when v_cnt = 6 then'||chr(10)||
'                              :p822_html7 := v_return;'||chr(10)||
'           when v_cnt = 7 then'||chr(10)||
'                              :p822_html8 := v_return;'||chr(10)||
'           when v_cnt = 8 then'||chr(10)||
'                              :p822_html9 := v_return;'||chr(10)||
'           when v_cnt = 9 then'||chr(10)||
'                              :p822_html10 := v_return;'||chr(10)||
'              '||chr(10)||
'       end case;   ';

p:=p||'           '||chr(10)||
'       v_cnt := v_cnt+1;'||chr(10)||
'       v_return := '''';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     v_records := v_records + 1;'||chr(10)||
''||chr(10)||
' end loop;'||chr(10)||
' '||chr(10)||
' :P822_RECORDS := v_records;'||chr(10)||
''||chr(10)||
' if length(v_return) < 22000 then'||chr(10)||
'       '||chr(10)||
'   case '||chr(10)||
'           '||chr(10)||
'       when v_cnt = 0 then'||chr(10)||
'                          :p822_html1 := v_return;'||chr(10)||
'       when v_cnt = 1 then'||chr(10)||
'                          :p822_html2 := v_return;'||chr(10)||
'       when v_cnt = 2 then'||chr(10)||
'   ';

p:=p||'                       :p822_html3 := v_return;'||chr(10)||
'       when v_cnt = 3 then'||chr(10)||
'                          :p822_html4 := v_return;'||chr(10)||
'       when v_cnt = 4 then'||chr(10)||
'                          :p822_html5 := v_return;'||chr(10)||
'       when v_cnt = 5 then'||chr(10)||
'                          :p822_html6 := v_return;'||chr(10)||
'       when v_cnt = 6 then'||chr(10)||
'                          :p822_html7 := v_return;'||chr(10)||
'       when v_cnt = 7 then'||chr(10)||
'             ';

p:=p||'             :p822_html8 := v_return;'||chr(10)||
'       when v_cnt = 8 then'||chr(10)||
'                          :p822_html9 := v_return;'||chr(10)||
'       when v_cnt = 9 then'||chr(10)||
'                          :p822_html10 := v_return;'||chr(10)||
''||chr(10)||
'   end case;              '||chr(10)||
''||chr(10)||
' end if;'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 7144322913663078 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 822,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'GetNarratives',
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
-- ...updatable report columns for page 822
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
