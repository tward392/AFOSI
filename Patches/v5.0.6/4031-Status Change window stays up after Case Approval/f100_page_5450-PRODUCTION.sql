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
--   Date and Time:   10:11 Tuesday April 10, 2012
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

PROMPT ...Remove page 5450
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5450);
 
end;
/

 
--application/pages/page_05450
prompt  ...PAGE 5450: Status Change Widget
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<!-- This has to be declared above any reference to submodal scripts. -->'||chr(10)||
'<script type="text/javascript">var imgPrefix = ''#IMAGE_PREFIX#'';</script>'||chr(10)||
'<!-- Submodal stuff -->'||chr(10)||
'<link rel="stylesheet" type="text/css" href="#IMAGE_PREFIX#/themes/OSI/submodal/subModal.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#/themes/OSI/submodal/common.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMA';

ph:=ph||'GE_PREFIX#/themes/OSI/submodal/subModal.js"></script>'||chr(10)||
'<!-- End Submodal stuff -->'||chr(10)||
''||chr(10)||
'"JS_POPUP_LOCATOR"'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
'function closeThis(){'||chr(10)||
'    /*'||chr(10)||
'    var xbox = window.top.document.getElementById(''popCloseBox'');'||chr(10)||
'    xbox.click();'||chr(10)||
'    */'||chr(10)||
'    window.top.hidePopWin();'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
''||chr(10)||
'if (''&P5450_DONE.'' == ''Y'')';

ph:=ph||'{'||chr(10)||
'    var cloning = 0;'||chr(10)||
'    var open_new = false;'||chr(10)||
''||chr(10)||
'    switch (''&P5450_STATUS_CHANGE_DESC.'') {'||chr(10)||
'      case ''Clone Activity'': '||chr(10)||
'              cloning = 1; '||chr(10)||
'              alert(''Click OK to open the cloned activity.''); '||chr(10)||
'              break;'||chr(10)||
'      case ''Create Case'': '||chr(10)||
'              cloning = 1; '||chr(10)||
'              alert(''Click OK to open the case file.''); '||chr(10)||
'              break;'||chr(10)||
'      case ''Create DCII Indexin';

ph:=ph||'g File'': '||chr(10)||
'              cloning = 1; '||chr(10)||
'              alert(''Click OK to open the DCII Indexing file.''); '||chr(10)||
'              break;'||chr(10)||
'      case ''Migrate to Existing Source'':'||chr(10)||
'              open_new = confirm(''This source has been migrated to '' + ''&P5450_SOURCE_ID.'' + '', would you like to open it?'');'||chr(10)||
'              break;'||chr(10)||
'      default: '||chr(10)||
'              break;'||chr(10)||
'     }'||chr(10)||
''||chr(10)||
'    if(''&P5450_STATUS_CHANGE_DESC.'' == ''Mi';

ph:=ph||'grate to Existing Source''){'||chr(10)||
'        window.parent.close();'||chr(10)||
'        /*opener.close();*/'||chr(10)||
'    }else{'||chr(10)||
'        if (cloning == 0 & open_new == false) '||chr(10)||
'          {'||chr(10)||
'           window.parent.doSubmit(''RELOAD'');'||chr(10)||
'           /*opener.doSubmit(''RELOAD'');*/'||chr(10)||
'          }'||chr(10)||
'    }'||chr(10)||
'    '||chr(10)||
'    if (cloning == 1 || open_new == true){'||chr(10)||
'         newWindow({page:''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'                    clear_cache:';

ph:=ph||'''&P5450_CLONE_PAGE_TO_LAUNCH.'', '||chr(10)||
'                    name:''&P5450_CLONE_NEW_SID.'', item_names:''P0_OBJ'', '||chr(10)||
'                    item_values:''&P5450_CLONE_NEW_SID.'', '||chr(10)||
'                    request:''OPEN''});'||chr(10)||
'    }'||chr(10)||
'   '||chr(10)||
'    if(''&P5450_STATUS_CHANGE_DESC.'' == ''Approve File'' & ''&P5450_OBJ_TYPE.'' == ''Case''){'||chr(10)||
'        window.location = ''f?p=&APP_ID.:800:&SESSION.::::P800_REPORT_TYPE,P0_OBJ:&P5450_REPORT_TYPE.,&';

ph:=ph||'P0_OBJ.'';'||chr(10)||
'   }'||chr(10)||
'   else {'||chr(10)||
'        closeThis();'||chr(10)||
'   }'||chr(10)||
'   '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetSelectedSubjects(Request)'||chr(10)||
'{'||chr(10)||
' var selected = "";'||chr(10)||
''||chr(10)||
' var node_list = document.getElementsByTagName(''input'');'||chr(10)||
''||chr(10)||
' var l_field_id = document.getElementById(''P5450_SUBJECTS_SELECTED''); '||chr(10)||
' '||chr(10)||
' if(l_field_id!=null)'||chr(10)||
'   {'||chr(10)||
'    for (var i = 0; i < node_list.length; i++) '||chr(10)||
'       {'||chr(10)||
'        var node = node_list[i];'||chr(10)||
'  '||chr(10)||
'        if (node.getAttribute(';

ph:=ph||'''type'') == ''checkbox'') '||chr(10)||
'          {'||chr(10)||
'           if (node.checked==true)'||chr(10)||
'             {'||chr(10)||
'              selected = selected.concat(node.value,"~");'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'    l_field_id.value = selected;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if (Request!=undefined)'||chr(10)||
'   doSubmit(Request);'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<style>'||chr(10)||
''||chr(10)||
'#SubjectList'||chr(10)||
'         {'||chr(10)||
'          border: 3px ridge;'||chr(10)||
'          width: 95%;'||chr(10)||
'          font: 1em Courier New;'||chr(10)||
'   ';

ph:=ph||'       border-collapse: collapse;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'#SubjectList td'||chr(10)||
'            {'||chr(10)||
'             height: 22px;'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'             border-bottom: 1px ridge;'||chr(10)||
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
'#HeaderColumn'||chr(10)||
'            {'||chr(10)||
'             border-bottom: 3px ri';

ph:=ph||'dge;'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'             color:#fff;'||chr(10)||
'             text-align:center;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'#HeaderRow'||chr(10)||
'            {'||chr(10)||
'             cellspacing: 0;'||chr(10)||
'             white-space:nowrap;'||chr(10)||
'             background: #4e7ec2;'||chr(10)||
'            }'||chr(10)||
''||chr(10)||
'</style>';

wwv_flow_api.create_page(
  p_id     => 5450,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Status Change Widget',
  p_step_title=> 'Status Change Widget',
  p_step_sub_title => 'Status Change Widget',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="JavaScript" type="text/javascript">'||chr(10)||
'if (''&P5450_SHOW_CONFIRM.'' == ''Y''){'||chr(10)||
'    newWindow({page:''30135'', '||chr(10)||
'           clear_cache:''30135'', '||chr(10)||
'           name:''CONFIRM_'' + ''&P5450_CONFIRM_SESSION.'','||chr(10)||
'           item_names:''P30135_SC_SID,P30135_SESSION,P30135_CONFIRM_ALLOWED'', '||chr(10)||
'           item_values:''&P5450_STATUS_CHANGE_SID.,&P5450_CONFIRM_SESSION.,&P5450_CONFIRM_ALLOWED.'', '||chr(10)||
'           request:''OPEN''});'||chr(10)||
'javascript:closeThis();'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110707083429',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '11-MAY-2010  Jason Faris    Added conditional ''RPO Unit'' selector'||chr(10)||
'                            for Criminal Poly File Support.'||chr(10)||
''||chr(10)||
'04-JUN-2010  Tim McGuffin   Added audit logging of status changes.'||chr(10)||
''||chr(10)||
'01-JAN-2011  Jason Faris    An update was made to the javascript on P5450'||chr(10)||
'                            HTML Header to prevent a reload of the page in'||chr(10)||
'                            the case of a clone or Migrate Source action.'');'||chr(10)||
''||chr(10)||
'09-Jun-2011 - Tim Ward -    CR#3872 - Unarchiving requires unit to be entered,'||chr(10)||
'                             but excludes the current unit so it can be'||chr(10)||
'                             unarchived to the unit that owns it, only to '||chr(10)||
'                             another unit.'||chr(10)||
'                             Changed "Pre-Load Status Change Information" to '||chr(10)||
'                             default unit to current, if we are doing an'||chr(10)||
'                             "UNARCHIVE" and to not exclude the current unit '||chr(10)||
'                             at all for any status changes.'||chr(10)||
''||chr(10)||
'30-Jun-2011  Tim Ward       CR#3566 - Allow Picking of Subjects when '||chr(10)||
'                            Creating Case from Developmental.'||chr(10)||
'                            Added GetSelectedSubjects and CSS for the Subject'||chr(10)||
'                            listing HTML to the Page HTML Header.'||chr(10)||
'                            Added "Pick Subjects to Create Case" Region '||chr(10)||
'                            and Items.'||chr(10)||
'                            Changed "Update Object Status" page process to pass'||chr(10)||
'                            the list of subjects to OSI_STATUS_PROC functions.'||chr(10)||
'                            Changed the "SAVE_CONFIRM" button to call'||chr(10)||
'                            GetSelectedSubjects which also submits the page.'||chr(10)||
''||chr(10)||
'06-Jul-2011  Tim Ward       CR#3600 - Added ''Create DCII Indexing File'' checks'||chr(10)||
'                                      where there was a ''Create Case'' check.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5450,p_text=>ph);
end;
 
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
'  :P5450_SUBJECT_HTML:=OSI_STATUS_PROC.GET_SUBJECT_SELECTION_HTML(:P0_OBJ);'||chr(10)||
'  htp.p(:p5450_subject_html || ''<script>GetSelectedSubjects();</script>'');'||chr(10)||
'   '||chr(10)||
'END;';

wwv_flow_api.create_page_plug (
  p_id=> 6558923278122600 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Pick Subjects to Create Case',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 23,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_STATUS_CHANGE_DESC in (''Create Case'',''Create DCII Indexing File'')',
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
  p_id=> 13476723894407034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Effective Date',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 27,
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
  p_plug_display_when_condition => ':P5450_DATE_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null'||chr(10)||
'and'||chr(10)||
':P5450_CHECKLIST_COMPLETE = ''Y''',
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
  p_id=> 90144213595465317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Comment',
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
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
'(:P5450_NOTE_REQUIRED = ''O'' or :P5450_NOTE_REQUIRED = ''R'')'||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 90157609856244248 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Parameter Stuff',
  p_region_name=>'',
  p_plug_template=> 0,
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 90159622370276293 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Checklist Information',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_PRE_PROCESS_CHECK is null',
  p_plug_footer=> '<script language="JavaScript" type="text/javascript">'||chr(10)||
'if ($v(''P5450_AUTHORIZED'')==''N''){'||chr(10)||
'   alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'   closeThis();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'</script>',
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
  p_id=> 90163324027371415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Confirmation - &P5450_STATUS_CHANGE_DESC.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 25,
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
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 90589130294220195 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Unit Assignment',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 22,
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
  p_plug_display_when_condition => ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_UNIT_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_PRE_PROCESS_CHECK is null',
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
  p_id=> 91382720890965764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Access Verification - The following problems were found:',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5450_PRE_PROCESS_CHECK is not null',
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
  p_id=> 93419223048540671 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5450,
  p_plug_name=> 'Item',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
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
  p_id             => 90144619756465332 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 5,
  p_button_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_CHECKLIST',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90162412683349201 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 10,
  p_button_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_NOTE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90144434019465328 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 20,
  p_button_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_NOTE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90164025805400273 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 30,
  p_button_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_CONFIRM',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_NOTE_REQUIRED = ''N'''||chr(10)||
'and'||chr(10)||
':P5450_DATE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 90164529053410734 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 40,
  p_button_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_CONFIRM',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:GetSelectedSubjects(''SAVE_CONFIRM'');',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''Y'''||chr(10)||
'and'||chr(10)||
':P5450_NOTE_REQUIRED = ''N'''||chr(10)||
'and'||chr(10)||
':P5450_DATE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91385514124200345 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 50,
  p_button_plug_id => 91382720890965764+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_PRE_PROCESS',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13478806935477865 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 70,
  p_button_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL_DATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeThis();',
  p_button_condition=> ':P5450_NOTE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13479011437479185 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 80,
  p_button_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE_DATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5450_STATUS_CHANGE_DESC.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5450_NOTE_REQUIRED = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16896902164612353 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5450,
  p_button_sequence=> 90,
  p_button_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_button_name    => 'SHOW_CHECKLIST',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Show Checklist',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5450_CHECKLIST_COMPLETE = ''N''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>16897229522620264 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_branch_action=> 'f?p=&APP_ID.:5500:&SESSION.::&DEBUG.:5500:P5500_STATUS_CHANGE_SID,P0_OBJ:&P5450_STATUS_CHANGE_SID.,&P0_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>16896902164612353+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-OCT-2010 15:56 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>90145506390465349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_branch_action=> 'f?p=&APP_ID.:5450:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-MAY-2009 12:19 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3363806060047418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_AUTHORIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>3364312256096601 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_AUTH_ACTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>3548722741431534 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CONFIRM_ALLOWED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 270,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>4856518545297114 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 125,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'begin'||chr(10)||
'  case '||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''FILE.POLY_FILE.CRIM'' '||chr(10)||
'           and :P5450_STATUS_CHANGE_DESC = ''Approve CrimPoly'' then'||chr(10)||
'          return ''RPO'';'||chr(10)||
'      when :P5450_STATUS_CHANGE_DESC = ''Unarchive'' then'||chr(10)||
'          return ''Unarchive to Unit'';'||chr(10)||
'      else'||chr(10)||
'          return ''Unit'';'||chr(10)||
'   end case;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
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
  p_id=>4908906244006206 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_RPO_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5450_UNIT_LABEL.',
  p_post_element_text=>'<a href="javascript:popupLocator(503,''P5450_UNIT_SID'',''N'',''&P5450_UNIT_EXCLUDE.'');">&ICON_LOCATOR.</a>',
  p_source=>'OSI_UNIT.GET_NAME(:P5450_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_STATUS_CHANGE_DESC in(''Approve CrimPoly'',''Approve SecPoly'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
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
  p_id=>5507305410048631 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NEW_NOTE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Note Sid',
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
  p_id=>5901314800310025 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SHOW_CONFIRM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>6040419886165925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CONFIRM_SESSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>6560916238380749 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SUBJECT_HTML',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 280,
  p_item_plug_id => 6558923278122600+wwv_flow_api.g_id_offset,
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
  p_id=>6567910668202368 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SUBJECTS_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 290,
  p_item_plug_id => 6558923278122600+wwv_flow_api.g_id_offset,
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
  p_id=>6573418211649242 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SUBJECT_CHECKBOX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 6558923278122600+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Test Checkbox',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
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
  p_id=>7430418540040818 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_SOURCE_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
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
  p_id=>8018030643299712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_REPORT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Report Type',
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
  p_id=>8018429867318396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_OBJ_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select ot.description'||chr(10)||
'from t_core_obj o, t_core_obj_type ot'||chr(10)||
'where o.sid = :p0_obj'||chr(10)||
'and o.obj_type = ot.sid',
  p_source_type=> 'QUERY',
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
  p_id=>13477209827412426 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_DATE_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_DATE_REQUIRED',
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
  p_id=>13480306635506175 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_EFFECTIVE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 260,
  p_item_plug_id => 13476723894407034+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Effective Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
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
  p_id=>90144832022465332 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NOTE_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Text',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 90,
  p_cMaxlength=> 32000,
  p_cHeight=> 15,
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
  p_id=>90157129680231087 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_STATUS_CHANGE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Change Sid',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>90158020592247382 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_CHECKLIST_COMPLETE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 10000,
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
  p_id=>90158228211249582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CUSTOM_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_id=>90158434098251281 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_NOTE_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Note Required',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>90160106571281224 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE_DISPLAY_YES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'<img src="#IMAGE_PREFIX#themes/OSI/success_w.gif"/> Checklist Complete - You may proceed.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_CHECKLIST_COMPLETE = ''Y''',
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
  p_id=>90161335446299020 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CHECKLIST_COMPLETE_MESSAGE_NO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 90159622370276293+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'<img src="#IMAGE_PREFIX#themes/OSI/fail.gif"/> Checklist Not Complete - Please complete the checklist.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_CHECKLIST_COMPLETE = ''N''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<img src="#IMAGE_PREFIX#themes/OSI/fail.gif"/><a href="javascript:runChecklist(''&P0_OBJ.'',''&P5450_STATUS_CHANGE_SID.'')">Checklist Not Complete - Please complete the checklist.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90171008462518299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_COMMENT_MSG_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<label tabindex="999" class="requiredlabel">A comment for this action is REQUIRED.</label>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_NOTE_REQUIRED = ''R''',
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
  p_id=>90172010801537865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_COMMENT_MSG_OPTIONAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 90144213595465317+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'A comment for this action is OPTIONAL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_NOTE_REQUIRED = ''O''',
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
  p_id=>90589834783239292 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5450_UNIT_LABEL.',
  p_post_element_text=>'<a href="javascript:popupLocator(510,''P5450_UNIT_SID'',''N'',''&P5450_UNIT_EXCLUDE.'');">&ICON_LOCATOR.</a>',
  p_source=>'OSI_UNIT.GET_NAME(:P5450_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_STATUS_CHANGE_DESC not in(''Approve CrimPoly'',''Approve SecPoly'') ',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
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
  p_id=>90591207684239295 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_UNIT_SID',
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
  p_id=>90593917405311145 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Required',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>90660322917367023 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_EXCLUDE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Exclude',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>90706932143254204 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Done',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>90708210073304640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_ERROR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 90163324027371415+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'THERE HAS BEEN A SYSTEM ERROR WHEN CHANGING STATUS.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_display_when=>':P5450_DONE = ''N''',
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
  p_id=>90856123722438759 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_STATUS_CHANGE_DESC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status Change Desc',
  p_source=>'osi_status.get_status_change_desc(:P5450_STATUS_CHANGE_SID)',
  p_source_type=> 'FUNCTION',
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
  p_id=>90933536158383762 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CLONE_PAGE_TO_LAUNCH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'none',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Clone Page To Launch',
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>90933823822389589 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_CLONE_NEW_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'none',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Clone New Sid',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>91372833134852682 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_TEXT_REQUIRED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Unit Text Required',
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
  p_id=>91374906750015454 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_UNIT_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 90589130294220195+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Reason',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5450_UNIT_TEXT_REQUIRED = ''Y''',
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
  p_id=>91383036128970142 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_PRE_PROCESS_CHECK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 90157609856244248+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5450_PRE_PROCESS_CHECK',
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
  p_id=>91384721649145767 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_PRE_PROCESS_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 91382720890965764+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P5450_PRE_PROCESS_CHECK',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXTAREA-AUTO-HEIGHT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'readOnly',
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
  p_id=>93419618677548935 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5450,
  p_name=>'P5450_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 93419223048540671+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'core_obj.get_tagline(:P0_obj)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
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
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90595124294360435 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'UNIT must not be null',
  p_validation_sequence=> 5,
  p_validation => 'P5450_UNIT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit must be selected.',
  p_validation_condition=> ':P5450_UNIT_REQUIRED = ''Y'''||chr(10)||
'and'||chr(10)||
':request not in (''P5450_UNIT_SID'', ''SHOW_CHECKLIST'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 90589834783239292 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 90145121301465340 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'NOTE_TEXT must not be null',
  p_validation_sequence=> 10,
  p_validation => 'P5450_NOTE_TEXT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Note Text must be filled in.',
  p_validation_condition=> ':P5450_NOTE_REQUIRED = ''R'''||chr(10)||
'and'||chr(10)||
':request not in (''P5450_UNIT_SID'', ''SHOW_CHECKLIST'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 90144832022465332 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 14120623560758929 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_validation_name => 'Effective Date cannot be more than 2 days in advance',
  p_validation_sequence=> 30,
  p_validation => 'begin'||chr(10)||
'    if (:p5450_date_required = ''Y'' and :p5450_effective_date is not null) then'||chr(10)||
'        if (:p5450_effective_date > trunc(sysdate) +2) then'||chr(10)||
'            return ''Effective date cannot be more than 2 days ahead.'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => '',
  p_validation_condition=> ':REQUEST like ''SAVE%''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13480306635506175 + wwv_flow_api.g_id_offset,
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
'  v_parameter1   varchar2(500)  := null;'||chr(10)||
'  v_parameter2   varchar2(4000) := null;'||chr(10)||
'  v_temp         t_osi_note.sid%type;'||chr(10)||
'  v_result       varchar2(32767) := null;'||chr(10)||
'  v_log_msg      varchar2(500);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  v_log_msg := ''Lifecycle:'' || :p0_obj || ''-'' || :p5450_status_change_desc;'||chr(10)||
''||chr(10)||
'  --- Grab Unit into Parameter1 if nessecary ---'||chr(10)||
'  if (:p5450_unit_required = ''Y'') then'||chr(10)||
''||chr(10)||
'    v_parameter1 := :p545';

p:=p||'0_unit_sid;'||chr(10)||
'    v_log_msg := v_log_msg || ''-'' || v_parameter1;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  log_info(v_log_msg);'||chr(10)||
''||chr(10)||
'  --- Grab Unit Text into Parameter2 if nessecary ---'||chr(10)||
'  --- TJW - 10-Jan-2011 added the Replace to get by a problem where Apostrophes in the Text Cause Oracle Errors ---'||chr(10)||
'  if (:p5450_unit_text_required = ''Y'') then'||chr(10)||
''||chr(10)||
'    v_parameter2 := replace(:p5450_unit_text,'''''''','''''''''''');'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if (:p5450_st';

p:=p||'atus_change_desc in (''Create Case'',''Create DCII Indexing File'')) then'||chr(10)||
''||chr(10)||
'    v_parameter1 := :p5450_Subjects_Selected;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
''||chr(10)||
'  osi_status.change_status(:p0_obj, :p5450_status_change_sid, v_parameter1, v_parameter2, :P5450_EFFECTIVE_DATE);'||chr(10)||
''||chr(10)||
'  if (:p5450_note_text is not null) then'||chr(10)||
''||chr(10)||
'    :P5450_NEW_NOTE_SID := osi_note.add_note(:p0_obj, osi_status.get_required_note_type(:p5450_status_change_sid)';

p:=p||', :p5450_note_text);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if (:p5450_status_change_desc in (''Clone Activity'',''Create Case'',''Create DCII Indexing File'')) then'||chr(10)||
''||chr(10)||
'    --- Put the cloned sid in the page if it exists. ---'||chr(10)||
'    :p5450_clone_new_sid := osi_status_proc.get_cloned_sid;'||chr(10)||
'        '||chr(10)||
'    select page_num into :p5450_clone_page_to_launch'||chr(10)||
'      from t_core_dt_obj_type_page'||chr(10)||
'     where obj_type member of osi_object.get_objty';

p:=p||'pes(:p5450_clone_new_sid)'||chr(10)||
'       and page_function = ''OPEN'';'||chr(10)||
'     --where obj_type = core_obj.get_objtype(:p5450_clone_new_sid);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'    '||chr(10)||
'  if(:p5450_status_change_desc = ''Migrate to Existing Source'') then'||chr(10)||
' '||chr(10)||
'   :p5450_clone_new_sid := osi_status_proc.get_cloned_sid;'||chr(10)||
'   :P5450_source_id := osi_source.get_id(:p5450_clone_new_sid);'||chr(10)||
'        '||chr(10)||
'   select page_num into :p5450_clone_page_to_launch'||chr(10)||
' ';

p:=p||'     from t_core_dt_obj_type_page'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:p5450_clone_new_sid)'||chr(10)||
'       and page_function = ''OPEN'';'||chr(10)||
'        '||chr(10)||
'    delete from t_core_obj where sid = :p0_obj;'||chr(10)||
'    :p0_obj := :p5450_clone_new_sid;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if(:p5450_status_change_desc = ''Approve File'' and :p5450_obj_type = ''Case'')then     '||chr(10)||
'      '||chr(10)||
'    select sid into :p5450_report_type'||chr(10)||
'     from t_osi_';

p:=p||'report_type'||chr(10)||
'      where description = ''Letter of Notification'''||chr(10)||
'        and obj_type = core_obj.lookup_objtype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'    :debug := :p5450_report_type;'||chr(10)||
'  '||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  :p5450_done := ''Y'';'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
''||chr(10)||
'  when others then'||chr(10)||
'      :p5450_done := ''N'';'||chr(10)||
'      raise;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90145220571465348 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Object Status',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE_CONFIRM,SAVE_NOTE,SAVE_DATE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
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
'    v_temp   varchar2(20);'||chr(10)||
'begin'||chr(10)||
'    if (:p0_obj_type_code = ''FILE.AAPP'') then'||chr(10)||
'        if (:P5450_STATUS_CHANGE_DESC like ''%Recall%'') then'||chr(10)||
'             osi_aapp_file.update_recall_note(:P5450_NEW_NOTE_SID);'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5486532760930489 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Special Processing on Note',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'SAVE_CONFIRM,SAVE_NOTE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
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
'  v_ok                  varchar2(1);'||chr(10)||
'  v_possible_dupes      number;'||chr(10)||
'  v_status_change_sid   varchar2(40);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  :p5450_checklist_complete := osi_checklist.checklist_complete(:p0_obj, :p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  begin'||chr(10)||
'       select aa.code into :p5450_auth_action'||chr(10)||
'        from t_osi_status_change sc, '||chr(10)||
'             t_osi_auth_action_type aa'||chr(10)||
'        where sc.sid = :p5450_status_change_';

p:=p||'sid'||chr(10)||
'          and aa.sid(+) = sc.auth_action;'||chr(10)||
'  exception when no_data_found then'||chr(10)||
''||chr(10)||
'           :p5450_auth_action := null;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'  if :p5450_auth_action is not null then'||chr(10)||
''||chr(10)||
'    :p5450_authorized := osi_auth.check_for_priv(:p5450_auth_action,'||chr(10)||
'                                                 core_obj.get_objtype(:p0_obj));    '||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    :p5450_authorized := ''Y'';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  --For some reason, not';

p:=p||'e_required does not always re-fill in correctly.'||chr(10)||
'  :p5450_note_required := osi_status.note_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
'  :p5450_unit_required := osi_status.unit_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
'  :P5450_unit_text_required := osi_status.unit_text_required_on_statchng(:P5450_status_change_sid);'||chr(10)||
'  :p5450_custom_message := osi_status.get_confirm_message(:p545';

p:=p||'0_status_change_sid, :P0_OBJ);'||chr(10)||
'  :status_stat_change_sid := v_status_change_sid;'||chr(10)||
'  :p5450_date_required := osi_status.date_is_required_on_stat_chng(:p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  --Unit Exclusion'||chr(10)||
'  --:p5450_unit_exclude := osi_object.get_assigned_unit(:P0_OBJ);'||chr(10)||
'  --:p5450_unit_exclude := osi_personnel.get_current_unit(core_context.personnel_sid);'||chr(10)||
'  '||chr(10)||
'  if :P5450_AUTH_ACTION = ''UNARCHIVE'' and :P5450_';

p:=p||'UNIT_SID is null then'||chr(10)||
''||chr(10)||
'    :P5450_UNIT_SID := osi_object.get_assigned_unit(:P0_OBJ);'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  :P5450_pre_process_check := osi_status.run_pre_processing(:p0_obj, :p5450_status_change_sid);'||chr(10)||
''||chr(10)||
'  if(:p5450_checklist_complete = ''Y'' and :p0_obj_type_code = ''PART.INDIV'')then'||chr(10)||
''||chr(10)||
'     v_ok := osi_participant.check_for_duplicates(:p0_obj);'||chr(10)||
''||chr(10)||
'     :P5450_CONFIRM_ALLOWED := v_ok;'||chr(10)||
''||chr(10)||
'     --if(:p5450_auth_actio';

p:=p||'n = ''CONFIRM'' and v_ok = ''N'')then'||chr(10)||
'     if :p5450_auth_action = ''CONFIRM'' then'||chr(10)||
''||chr(10)||
'       :p5450_confirm_session := osi_participant.get_confirm_session;'||chr(10)||
''||chr(10)||
'       select count(*) into v_possible_dupes'||chr(10)||
'        from v_osi_partic_search_result'||chr(10)||
'         where session_id = :p5450_confirm_session;'||chr(10)||
'       '||chr(10)||
'      if v_possible_dupes <= 0 then'||chr(10)||
''||chr(10)||
'        :p5450_show_confirm := ''N'';'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'        :p5450_show';

p:=p||'_confirm := ''Y'';'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       :p5450_show_confirm := ''N'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90158607694262545 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5450,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Pre-Load Status Change Information',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 5450
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
