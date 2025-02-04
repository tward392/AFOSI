------------------------------------------------
--- Changes:                                  ---
---                                           ---
--- 1.  Page 5450                             ---
--- 2.  Inserts into T_OSI_STATUS_CHANGE      ---
--- 3.  Inserts into T_OSI_STATUS_CHANGE_PROC ---
--- 4.  Insert into T_OSI_NOTE_TYPE           ---
--- 5.  OSI_SFS_INVESTIGATION (Spec and Body) ---
--- 6.  OSI_STATUS_PROC (Spec and Body)       ---
---                                           ---
--------------------------------------------------
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
--   Date and Time:   08:36 Thursday July 7, 2011
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




INSERT INTO T_OSI_STATUS_CHANGE ( SID, OBJ_TYPE, FROM_STATUS, TO_STATUS, TRANSITION, BUTTON_LABEL, COMMENT_TYPE, CONFIRM_MESSAGE, UNIT_REQUIRED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, NOTE_CAT, SEQ, UNIT_TEXT_REQUIRED, CHECKLIST_BUTTON_LABEL, OVERRIDE, ACTIVE, AUTH_ACTION, ALLOW_DATE ) VALUES ( '33317NI4', '22200000AJG', '222000005IY', '222000005IY', 'Create DCII Indexing File', 'Create DCII Indexing File', 'N', NULL, 'N', 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, 0, 'N', NULL, 'N', 'Y', '22201204', 'N'); 
INSERT INTO T_OSI_STATUS_CHANGE ( SID, OBJ_TYPE, FROM_STATUS, TO_STATUS, TRANSITION, BUTTON_LABEL, COMMENT_TYPE, CONFIRM_MESSAGE, UNIT_REQUIRED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, NOTE_CAT, SEQ, UNIT_TEXT_REQUIRED, CHECKLIST_BUTTON_LABEL, OVERRIDE, ACTIVE, AUTH_ACTION, ALLOW_DATE ) VALUES ( '33317NI5', '22200000AJG', '22200000GAB', '22200000GAB', 'Create DCII Indexing File', 'Create DCII Indexing File', 'N', NULL, 'N', 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, 0, 'N', NULL, 'N', 'Y', '22201204', 'N'); 
INSERT INTO T_OSI_STATUS_CHANGE ( SID, OBJ_TYPE, FROM_STATUS, TO_STATUS, TRANSITION, BUTTON_LABEL, COMMENT_TYPE, CONFIRM_MESSAGE, UNIT_REQUIRED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, NOTE_CAT, SEQ, UNIT_TEXT_REQUIRED, CHECKLIST_BUTTON_LABEL, OVERRIDE, ACTIVE, AUTH_ACTION, ALLOW_DATE ) VALUES ( '33317NI6', '22200000AJH', '222000005IY', '222000005IY', 'Create DCII Indexing File', 'Create DCII Indexing File', 'N', NULL, 'N', 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, 0, 'N', NULL, 'N', 'Y', '22201204', 'N'); 
INSERT INTO T_OSI_STATUS_CHANGE ( SID, OBJ_TYPE, FROM_STATUS, TO_STATUS, TRANSITION, BUTTON_LABEL, COMMENT_TYPE, CONFIRM_MESSAGE, UNIT_REQUIRED, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, NOTE_CAT, SEQ, UNIT_TEXT_REQUIRED, CHECKLIST_BUTTON_LABEL, OVERRIDE, ACTIVE, AUTH_ACTION, ALLOW_DATE ) VALUES ( '33317NI7', '22200000AJH', '22200000GAB', '22200000GAB', 'Create DCII Indexing File', 'Create DCII Indexing File', 'N', NULL, 'N', 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:53:53 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, 0, 'N', NULL, 'N', 'Y', '22201204', 'N'); 
COMMIT;



INSERT INTO T_OSI_STATUS_CHANGE_PROC ( SID, STATUS_CHANGE_SID, PROC_TO_USE, ACTIVE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PROCESS_POINT ) VALUES ( '33317NI8', '33317NI4', 'OSI_STATUS_PROC.CLONE_TO_DCII', 'Y', 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'AFTER'); 
INSERT INTO T_OSI_STATUS_CHANGE_PROC ( SID, STATUS_CHANGE_SID, PROC_TO_USE, ACTIVE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PROCESS_POINT ) VALUES ( '33317NI9', '33317NI5', 'OSI_STATUS_PROC.CLONE_TO_DCII', 'Y', 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'AFTER'); 
INSERT INTO T_OSI_STATUS_CHANGE_PROC ( SID, STATUS_CHANGE_SID, PROC_TO_USE, ACTIVE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PROCESS_POINT ) VALUES ( '33317NIA', '33317NI6', 'OSI_STATUS_PROC.CLONE_TO_DCII', 'Y', 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'AFTER'); 
INSERT INTO T_OSI_STATUS_CHANGE_PROC ( SID, STATUS_CHANGE_SID, PROC_TO_USE, ACTIVE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PROCESS_POINT ) VALUES ( '33317NIB', '33317NI7', 'OSI_STATUS_PROC.CLONE_TO_DCII', 'Y', 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 09:59:51 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'AFTER'); 
COMMIT;


INSERT INTO T_OSI_NOTE_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, OVERRIDE, AUTH_ACTION ) VALUES ( '33317NKE', '222034NS', 'NOTELIST', 'CREATE', 'Create DCII File Note', NULL, NULL, 'IMMED', 1, 'N', 'timothy.ward',  TO_Date( '07/06/2011 10:46:42 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '07/06/2011 10:46:42 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'N', NULL); 
COMMIT;


-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_sfs_investigation as
/******************************************************************************
   Name:     osi_sfs_investigation
   Purpose:  Provides functionality for the SFS Investigation File.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------------
    09-AUG-2010  T. Whitehead    Created this package
    06-Jul-2011  Tim Ward        CR#3600 - Allo Creating DCII Indexing file from Dev/Info Files.
                                  Added clone_to_dcii.

******************************************************************************/

    /* Given an object sid as p_obj, returns a default file tagline. */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given an object sid as p_obj, return a summary.  Can pass a variant
       in p_variant to affect the format of the results (i.e. HTML). */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    /* Given an object sid as p_obj and a reference to a clob, will fill in
       the clob with xml data to be used for the doc1 index .*/
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given an object sid as p_obj, will return the current status of the file. */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* Will take all necessary steps to create a new instance of this type of object. */
    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_background    in   varchar2,
        p_summary       in   varchar2)
        return varchar2;

    /* Returns Y if the input object is writable (not read-only). */
    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2;

    function clone_to_dcii(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) return varchar2;

/* Begin report routines. */
end osi_sfs_investigation;
/


CREATE OR REPLACE package body osi_sfs_investigation as
/******************************************************************************
   Name:     osi_sfs_investigation
   Purpose:  Provides functionality for the SFS Investigation File.

   Revisions:
    Date         Author          Description
    -----------  --------------  ------------------------------------------
    09-AUG-2010  T. Whitehead    Created this package
    06-Jul-2011  Tim Ward        CR#3600 - Allo Creating DCII Indexing file from Dev/Info Files.
                                  Added clone_to_dcii.

******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'osi_sfs_investigation';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_file.get_tagline(p_obj);
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_file.get_summary(p_obj, p_variant);
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_file.index1(p_obj, p_clob);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_file.get_status(p_obj);
    end get_status;

    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_background    in   varchar2,
        p_summary       in   varchar2)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
    begin
        -- Common file creation,
        -- handles t_core_obj, t_osi_file, starting status, lead assignment, unit owner
        v_sid := osi_file.create_instance(p_obj_type, p_title, p_restriction);

        insert into t_osi_f_sfs_investigation
                    (sid, background, summary)
             values (v_sid, p_background, p_summary);

        return v_sid;
    exception
        when others then
            log_error('osi_sfs_investigation.create_instance: ' || sqlerrm);
    end create_instance;

    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_obj_type   t_core_obj_type.sid%type;
        v_status     t_osi_status.code%type;
    begin
        v_obj_type := core_obj.get_objtype(p_obj);
        v_status := osi_object.get_status_code(p_obj);

        if (v_status = 'AA') then
            --Check for Approval Privilege
            return osi_auth.check_for_priv
                                        ('APPROVE',
                                         v_obj_type,
                                         core_context.personnel_sid,
                                         osi_personnel.get_current_unit(core_context.personnel_sid));
        elsif(v_status = 'AC') then
            --Check for Closure Priv
            return osi_auth.check_for_priv
                                        ('CLOSE',
                                         v_obj_type,
                                         core_context.personnel_sid,
                                         osi_personnel.get_current_unit(core_context.personnel_sid));
        elsif(   v_status = 'CL'
              or v_status = 'SV'
              or v_status = 'AV'
              or v_status = 'RV') then
            return osi_auth.check_for_priv
                                        ('BR_BYPASS',
                                         v_obj_type,
                                         core_context.personnel_sid,
                                         osi_personnel.get_current_unit(core_context.personnel_sid));
        else
            return 'Y';
        end if;
    exception
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

/* p_parameter1 is a list of Subjects to Create the Case with (separated with a ~) */
function clone_to_dcii(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) return varchar2 is

        v_new_sid        t_core_obj.SID%type;
        v_old_id         t_osi_file.id%type;
        v_new_id         t_osi_file.id%type;
        v_close_status   t_osi_status.SID%type;
        v_note_sid       t_osi_note.SID%type;
        v_starting_status  t_osi_status.sid%type;

begin
     --- clone object ---
     insert into t_core_obj (obj_type)
             values (core_obj.lookup_objtype('FILE.SFS')) returning SID into v_new_sid;

     v_new_id := osi_object.get_next_id;

     --- clone basic file info ---
     insert into t_osi_file (SID, id, title, closed_short, restriction)
           select v_new_sid, v_new_id, title, closed_short, restriction from t_osi_file where SID = p_sid;

     --- clone investigation ---
     insert into t_osi_f_sfs_investigation
                (SID,
                 background,
                 summary)
        select v_new_sid, summary_allegation, summary_investigation
          from t_osi_f_investigation
         where SID = p_sid;

    --- clone ONLY subjects that were selected by the user ---
    insert into t_osi_partic_involvement
               (obj,
                participant_version,
                involvement_role,
                num_briefed,
                action_date,
                response,
                response_date,
                agency_file_num,
                report_to_dibrs,
                report_to_nibrs,
                reason)
        select v_new_sid, participant_version, involvement_role, num_briefed, action_date,
               response, response_date, agency_file_num, report_to_dibrs, report_to_nibrs,
               reason
          from t_osi_partic_involvement
         where obj=p_sid and involvement_role in (select sid from t_osi_partic_role_type where role='Subject') and participant_version in  (select * from table(split(p_parameter1,'~')) where column_value is not null);

    --- clone victims and agencies ---
    insert into t_osi_partic_involvement
               (obj,
                participant_version,
                involvement_role,
                num_briefed,
                action_date,
                response,
                response_date,
                agency_file_num,
                report_to_dibrs,
                report_to_nibrs,
                reason)
        select v_new_sid, participant_version, involvement_role, num_briefed, action_date,
               response, response_date, agency_file_num, report_to_dibrs, report_to_nibrs,
               reason
          from t_osi_partic_involvement
         where obj=p_sid and involvement_role in (select sid from t_osi_partic_role_type where role not in 'Subject');

    --- clone activity associations ---
    insert into t_osi_assoc_fle_act (file_sid, activity_sid, resource_allocation)
        select v_new_sid, activity_sid, resource_allocation
          from t_osi_assoc_fle_act
         where file_sid = p_sid;

    --- clone file associations ---
    insert into t_osi_assoc_fle_fle (file_a, file_b)
        select v_new_sid, file_b
          from t_osi_assoc_fle_fle
         where file_a = p_sid;

    insert into t_osi_assoc_fle_fle (file_a, file_b)
        select file_a, v_new_sid
          from t_osi_assoc_fle_fle
         where file_b = p_sid;

    --- associate to current file ---
    insert into t_osi_assoc_fle_fle (file_a, file_b) values (v_new_sid, p_sid);

    --- clone assignments ---
    insert into t_osi_assignment (obj, personnel, assign_role, start_date, end_date, unit)
        select v_new_sid, personnel, assign_role, start_date, end_date, unit from t_osi_assignment
         where obj = p_sid;

    --- set unit ownership to current user's unit ---
    osi_file.set_unit_owner(v_new_sid);

    --- save status ---
    select starting_status into v_starting_status from t_osi_obj_type ot, t_core_obj_type ct
         where ot.sid=ct.sid and ct.code='FILE.SFS';
        
    insert into t_osi_status_history
                (obj, status, effective_on, transition_comment, is_current) values
                (v_new_sid, v_starting_status, sysdate, 'Created', 'Y');

    select id into v_old_id from t_osi_file where SID = p_sid;

    --- Add Note ---
    v_note_sid := osi_note.add_note(v_new_sid, osi_note.get_note_type(core_obj.lookup_objtype('FILE.SFS'), 'CREATE'), 'This DCII Indexing File was created using the following File:  ' || v_old_id || '.');
    return v_new_sid;

exception when others then

    log_error('clone_to_dcii: ' || sqlerrm);
    raise;
        
end clone_to_dcii;

end osi_sfs_investigation;
/



-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_status_proc as
/**
 * Air Force - Office Of Special Investigation
 *    _____  ___________________    _________.___
 *   /  _  \ \_   _____/\_____  \  /   _____/|   |
 *  /  /_\  \ |    __)   /   |   \ \_____  \ |   |
 * /    |    \|     \   /    |    \/        \|   |
 * \____|__  /\___  /   \_______  /_______  /|___|
 *         \/     \/            \/        \/
 *  Investigative Information Management System
 *  .___________    _____    _________
 *  |   \_____  \  /     \  /   _____/
 *  |   |/  ____/ /  \ /  \ \_____  \
 *  |   /       \/    Y    \/        \
 *  |___\_______ \____|__  /_______  /
 *              \/       \/        \/
 *  Lifecycle - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_STATUS_PROC
   PURPOSE:    Provides functionality status change processing in WebI2MS.

    REVISIONS:
    Date        Author           Description
    ----------  ---------------  ------------------------------------
    11-may-2009  Richard Dibble  Created this package
    26-May-2009  Richard Dibble  Added transfer_file
    29-May-2009  Richard Dibble  Added verify_user_created_last_sh
    01-Jun-2009  Richard Dibble  Added mark_closed_short_file, unmark_closed_short_file and unarchive_file
    23-Jul-2009  T.Whitehead     Added confirm_participant, unconfirm_participant.
    06-Oct-2009  T.McGuffin      Added clone_to_case procedure.
    08-Oct-2009  T.McGuffin      Added set_file_full_id procedure.
    06-Nov-2009  T.Whitehead     Added case_from_init_notif.
    07-Dec-2009  T.Whitehead     Added transfer_file_end_assignments.
    28-Jan-2009  T.Whitehead     Added source_burn and source_unburn.
    02-Feb-2009  T.Whitehead     Added source_migrate.
    08-Feb-2010  Richard Dibble  Added aapp_can_recall
    09-Feb-2010  Richard Dibble  Added recall_aapp_file
    16-Mar-2010  Richard Dibble  Added aapp_set_restriction_ap
    18-Mar-2010  Jason Faris     Added sar_phase_update
    02-Apr2010   Richard Dibble  Added pso_set_full_id
    09-Apr-2010  Jason Faris     Added reopen_sar
    29-Apr-2010  T.Whitehead     Added deers_update_links.
    06-May-2010  JaNelle Horne   Added copy_special_interest
    12-May-2010  Jason Faris     Added poly_file_auto_transfer.
    12-May-2010  T.Whitehead     Added source_exists.
    18-May-2010  JaNelle Horne   Added copy_mission_area, autofill_summary_inv
    28-May-2010  JaNelle Horne   Added create_sum_complaint_rpt
    05-Jun-2010  Richard Dibble  Added act_clear_complete_date, act_clear_close_date
    06-Jun-2010  JaNelle Horne   Updated create_sum_complaint_rpt so that attachment type sid is pulled back
                                 based on obj_type
    22-Jun-2010  JaNelle Horne   Updated find_last_valid_return_point; missing a join in the query.
                                 Updated create_sum_complaint_rpt so that it checks for existing SCR and deletes any
                                 before adding final SCR.
    23-Jun-2010  Jason Faris     Added case_clear_negative_indexes.
    19-Aug-2010  Richard Dibble  Added pmm_close_account, pmm_user_can_close_account
    20-Aug-2010  Richard Dibble  Added pmm_suspend_account, pmm_reopen_account,
                                 pmm_user_can_reopen_account, pmm_handle_pw_reset,
                                 pmm_handle_fix_login_id, pmm_user_can_fix_login_id,
                                 pmm_check_for_active_assign
    09-Nov-2010  Richard Dibble  Added check_for_old_partic_links
    30-Jun-2011  Tim Ward        CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Added Get_Subject_Selection_HTML.
    06-Jul-2011  Tim Ward        CR#3600 - Allo Creating DCII Indexing file from Dev/Info Files.
                                  Added clone_to_dcii.
******************************************************************************/

    /* Used to process an activity on Completion */
    procedure complete_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process an activity on Closure */
    procedure close_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process an activity on Assignment of an Auxilary Unit */
    procedure assign_auxilary_unit(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process an activity on Re-Call */
    procedure recall_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process an activity on Re-Open */
    procedure reopen_object(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process an activity on Rejection */
    procedure reject_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to create an Investigate Case File from an Initial Notification Activity.*/
    procedure case_from_init_notif(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process an activity on Clone */
    procedure clone_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    procedure clone_to_case(
        p_sid          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to retrieve the SID of a recently cloned object */
    function get_cloned_sid
        return varchar2;

    /* Used to process a file transfer */
    procedure transfer_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process a file being closed short */
    procedure mark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to process a file being re-opened */
    procedure unmark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to unarchive a file */
    procedure unarchive_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to verify that the current user was the one that created the last status history record */
    function verify_user_created_last_sh(p_obj in varchar2)
        return varchar2;

    /* Used to unconfirm a participant */
    procedure unconfirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to confirm a participant */
    procedure confirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to generate and populate the full_id into t_osi_file */
    procedure set_file_full_id(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to mark a source as burned. */
    procedure source_burn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to determine if the given source's participant is already a source.*/
    function source_exists(p_obj in varchar2)
        return varchar2;

    /* Used to migrate a new source to an existing source. */
    procedure source_migrate(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to mark a source as not burned. */
    procedure source_unburn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Transfer a file and end assignments at the same time. */
    procedure transfer_file_end_assignments(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Determines whether or not a certain 110 file can be recalled (based on current status) */
    function aapp_can_recall(p_obj in varchar2)
        return varchar2;

    /* Used to recall an Agent Application (110) File */
    procedure recall_aapp_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Used to change an AAPP (110 File)'s restriction to "Assigned Personnel" on close .  This stops personnel from seeing their own file.*/
    procedure aapp_set_restriction_ap(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Suspicious Activity (phase) status changes update the "follow-up suffix" */
    procedure sar_phase_update(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /*Suspicious Activity "reopen" restores to the last phase transition */
    procedure reopen_sar(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

--    /* Used to change an AAPP (110 File)'s restriction to "Assigned Personnel" on close .  This stops personnel from seeing their own file.*/
--    procedure pso_set_full_id(p_obj          in   varchar2,
--        p_parameter1   in   varchar2 := null,
--        p_parameter2   in   varchar2 := null);

    /*Used to copy special interests on Case when approved*/
    procedure copy_special_interest(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Calls OSI_DEERS.UPDATE_ALL_PV_LINKS. */
    procedure deers_update_links(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);
        
        /* Returns a message to the user if no Updatable participant links can be updated */
    function check_for_old_partic_links(p_obj in varchar2)
        return varchar2;

    /* Used to transfer ownership of a Poly File automatically based on status. */
    procedure poly_file_auto_transfer(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    procedure copy_mission_area(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    procedure autofill_summary_inv(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    procedure create_sum_complaint_rpt(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Clears the COMPLETE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_complete_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* Clears the CLOSE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_close_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* At case approval, clear all subjects' negative DCII indications */
    procedure case_clear_negative_indexes(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* PMM: Used to verify that the current user is allowed to close the given account SID */
    function pmm_user_can_close_account(p_obj in varchar2)
        return varchar2;

    /* PMM: Used to Close a Personnel File (User Account) */
    procedure pmm_close_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* PMM: Used to Suspend a Personnel File (User Account) */
    procedure pmm_suspend_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* PMM: Used to Re-Open a Personnel File (User Account) */
    procedure pmm_reopen_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

    /* PMM: Used to verify that the current user is allowed to reopen the given account SID */
    function pmm_user_can_reopen_account(p_obj in varchar2)
        return varchar2;

    /* PMM: Used to reset password via the Actions Menu */
    procedure pmm_handle_pw_reset(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);
        
   /* PMM: Used to Fix Login ID's via the Actions Menu */
    procedure pmm_handle_fix_login_id(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);
        
    /* PMM: Used to verify that the current user is allowed to fix a login ID on the given account SID */
    function pmm_user_can_fix_login_id(p_obj in varchar2)
        return varchar2;
        
    /*P PMM: Returns message as to whether the object has open assignments. */
    function pmm_check_for_active_assign(p_obj in varchar2)
    return varchar2;

    function Get_Subject_Selection_HTML(p_obj in varchar2) 
        return Clob;
    
    procedure clone_to_dcii(
        p_sid          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null);

end osi_status_proc;
/


CREATE OR REPLACE package body osi_status_proc as
/**
 * Air Force - Office Of Special Investigation
 *    _____  ___________________    _________.___
 *   /  _  \ \_   _____/\_____  \  /   _____/|   |
 *  /  /_\  \ |    __)   /   |   \ \_____  \ |   |
 * /    |    \|     \   /    |    \/        \|   |
 * \____|__  /\___  /   \_______  /_______  /|___|
 *         \/     \/            \/        \/
 *  Investigative Information Management System
 *  .___________    _____    _________
 *  |   \_____  \  /     \  /   _____/
 *  |   |/  ____/ /  \ /  \ \_____  \
 *  |   /       \/    Y    \/        \
 *  |___\_______ \____|__  /_______  /
 *              \/       \/        \/
 *  Lifecycle - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_STATUS_PROC
   PURPOSE:    Provides functionality status change processing in WebI2MS.

    REVISIONS:
    Date        Author           Description
    ----------  ---------------  ------------------------------------
    11-may-2009  Richard Dibble  Created this package
    26-May-2009  Richard Dibble  Added transfer_file
    29-May-2009  Richard Dibble  Added verify_user_created_last_sh
    01-Jun-2009  Richard Dibble  Added mark_closed_short_file and unmark_closed_short_file
    04-Jun-2009  Tim McGuffin    Modified clone_activity to account for non-core addresses
    05-Jun-2009  Tim McGuffin    Modified verify_user_created_last_sh to reference new version
                                 of OSI_STATUS_PROC.last_sh_create_by.
    23-Jun-2009  Richard Dibble  Fixed reopen_object after Tim broke it
    02-Jul-2009  Richard Dibble  Modified reset_restriction to handle new ACL/ACE setup
                                 Added is_activity, is_file and get_restriction_sid
    15-Jul-2009  Tim McGuffin    Added update_activity_close_date function and called it from close_activity.
    15-Jul-2009  Tim McGuffin    Modified action text in Reopen_object to just say "Reopen", instead of
                                 "ReOpen-Last Open State"
    23-Jul-2009  T. Whitehead    Added confirm_participant, unconfirm_participant.
    06-Oct-2009  T.McGuffin      Added clone_to_case procedure.
    08-Oct-2009  T.McGuffin      Added set_file_full_id procedure.
    06-Nov-2009  T. Whitehead    Added case_from_init_notif.
    07-Dec-2009  T.Whitehead     Added transfer_file_end_assignments.
    28-Jan-2009  T.Whitehead     Added source_burn and source_unburn.
    08-Feb-2010  R.Dibble        Added aapp_can_recall  
    09-Feb-2010  Richard Dibble  Added recall_aapp_file 
    16-Mar-2010  Richard Dibble  Added aapp_set_restriction_ap
    18-Mar-2010  Jason Faris     Added sar_phase_update
    09-Apr-2010  Jason Faris     Added reopen_sar  
    29-Apr-2010  T.Whitehead     Added deers_update_links.
    06-May-2010  JaNelle Horne   Added copy_special_interest
    12-May-2010  Jason Faris     Added poly_file_auto_transfer.
    12-May-2010  T.Whitehead     Added source_exists.
    18-May-2010  JaNelle Horne   Added copy_mission_area, autofill_summary_inv
    28-May-2010  JaNelle Horne   Added create_sum_complaint_rpt
    05-Jun-2010  Richard Dibble  Added act_clear_complete_date, act_clear_close_date
    06-Jun-2010  JaNelle Horne   Updated create_sum_complaint_rpt so that attachment type sid is pulled back
                                 based on obj_type
    22-Jun-2010  JaNelle Horne   Updated find_last_valid_return_point; missing a join in the query
                                 Updated create_sum_complaint_rpt so that it checks for existing SCR and deletes any
                                 before adding final SCR.
    23-Jun-2010  Jason Faris     Added case_clear_negative_indexes.
    19-Aug-2010  Richard Dibble  Added pmm_close_account, user_can_close_account
    20-Aug-2010  Richard Dibble  Added pmm_suspend_account, pmm_reopen_account, 
                                 user_can_reopen_account, pmm_handle_pw_reset,
                                 pmm_handle_fix_login_id, pmm_user_can_fix_login_id,
                                 pmm_check_for_active_assign   
    30-Aug-2010  Richard Dibble  Modified pmm_disable_password to handle effective date
                                 Modified pmm_suspend_account and pmm_close_account to handle effective date
    09-Nov-2010  Richard Dibble  Added check_for_old_partic_links
    02-Mar-2011  Tim Ward        CR#3725 - Added Source to clone_activity for Sourc Meet Activities.
    04-Mar-2011  Carl Grunert    Added get file name code to create_sum_complaint_rpt. (CHG0003675) 
    08-Mar-2011  Tim Ward        CR#3740 - poly_file_auto_transfer not always auto tranferring to correct
                                  previous unit, also had to delete one of the auto_transfer calls because
                                  it was auto transferring twice on HQ Rejection:

                                  DELETE FROM T_OSI_STATUS_CHANGE_PROC WHERE SID='22200000XQB';
                                  COMMIT;                                  
    22-Mar-2011  Tim Ward        CR#3760 - Changed pmm_close/suspend/reopen_account to include personnel_status_date.
    05-May-2011  Tim Ward        CR#3836 - Changed poly_file_auto_transfer to change RPO/Requesting Unit before transfer.
    06-May-2011  Tim Ward        CR#3837 - Changed clone_activity to add the correct cloned from ID to the Note instead
                                  of the new ID.
    10-May-2011  Tim Ward        CR#3839 - Cloning Activities results in a Title that is over the max length.
                                  Chagned in clone_activity.
    09-Jun-2011  Tim Ward        CR#3879 - Cloning Activities that are assigned as leads copies the assigned unit
                                  over, this makes the activity a 1/2 lead....
                                  Chagned in clone_activity.
    27-Jun-2011  Tim Ward        CR#3863 - Reopening of FILE.INV should go back to Investigatively Closed if there
                                  is a "ROI/CSR Final Published" attached in the reports tab.
                                  Changed in reopen_object.
    30-Jun-2011  Tim Ward        CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Added Get_Subject_Selection_HTML.
                                  Changed clone_to_case.
                                  Changed case_from_init_notif.
    06-Jul-2011  Tim Ward        CR#3600 - Allo Creating DCII Indexing file from Dev/Info Files.
                                  Added clone_to_dcii.
    
******************************************************************************/
    
    c_pipe                  varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX')
                                       || 'OSI_status_proc';
    v_clone_new_sid         varchar2(20)  := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    -- Tells whether or not the given object is an activity
    function is_activity(p_obj in varchar2) return number is
    begin
        for K in (select SID from t_osi_activity where sid = p_obj)
        loop
            return 1;
        end loop;
    return 0; 
       exception
     
        when others then
            log_error('OSI_STATUS_PROC.is_activity: ' || sqlerrm);
            raise;
    end is_activity;
    
    -- Tells whether or not the given object is a file
        function is_file(p_obj in varchar2) return number is
    begin
        for K in (select SID from t_osi_file where sid = p_obj)
        loop
            return 1;
        end loop;
    return 0; 
       exception
     
        when others then
            log_error('OSI_STATUS_PROC.is_file: ' || sqlerrm);
            raise;
    end is_file;
    
    --Returns the SID of the given restriction
    function get_restriction_sid(p_restriction in varchar2) return varchar2 is
    begin
        for K in (select SID from t_osi_reference where description = p_restriction and usage = 'RESTRICTION')
        loop
            return k.sid;
        end loop;
           exception
     
        when others then
            log_error('OSI_STATUS_PROC.get_acl_sid: ' || sqlerrm);
            raise;
    end get_restriction_sid;
    

    --Handles restriction changes when switching units
    --(Assures that an activity restricted to "Assigned Personnel" can be
    --accessed by others in the newly assigned unit, etc.)
    procedure reset_restriction(p_obj in varchar2) is
        v_current_restriction_desc   varchar2(300);
        v_new_restriction            t_core_obj.acl%type;
    --The hard coding in this function was recomended by Tim McGuffin on 05/12/2009
    begin
        --Get new restriction
        v_new_restriction := get_restriction_sid('Unit and Assigned Personnel');
        
        --ACTIVITIES
        if (is_activity(p_obj) = 1) then
        
            --Get the current ACL
            select tor.DESCRIPTION
            into v_current_restriction_desc
            from t_osi_reference tor, t_osi_activity toa
            where toa.RESTRICTION = tor.SID(+) and toa.sid = p_obj;

            --If the ACL is "Assigned Personnel", then we need to change it to
            --Unit and Assigned Personnel
            if (v_current_restriction_desc = 'Assigned Personnel') then

                --Update T_CORE_OBJ with new ACL
                update t_osi_activity
                   set restriction = v_new_restriction
                 where sid = p_obj;
            end if;
        
        end if;
        
        --FILES
        if (is_file(p_obj) = 1) then
        
            --Get the current ACL
            select tor.DESCRIPTION
            into v_current_restriction_desc
            from t_osi_reference tor, t_osi_file tof
            where tof.RESTRICTION = tor.SID(+)  and tof.sid = p_obj;

            --If the ACL is "Assigned Personnel", then we need to change it to
            --Unit and Assigned Personnel
            if (v_current_restriction_desc = 'Assigned Personnel') then

                --Update T_CORE_OBJ with new ACL
                update t_osi_file
                   set restriction = v_new_restriction
                 where sid = p_obj;
            end if;
        
        end if;
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.reset_restriction: ' || sqlerrm);
            raise;
    end reset_restriction;

    --Returns the creating unit of an activity
    function get_activity_create_by_unit(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_activity.assigned_unit%type;
    begin
        select creating_unit
          into v_return
          from t_osi_activity
         where sid = p_obj;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.get_activity_create_by_unit: ' || sqlerrm);
            raise;
    end get_activity_create_by_unit;

    --Ends all assignments for the specified object
    procedure end_all_assignments(p_obj in varchar2) is
    begin
        update t_osi_assignment
           set end_date = sysdate
         where obj = p_obj and end_date is null;
    exception
        when others then
            log_error('OSI_STATUS_PROC.end_all_assignments: ' || sqlerrm);
            raise;
    end end_all_assignments;

    --Finds the last valid return point in the status history chain
    function find_last_valid_return_point(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(20) := '<none>';
    begin
        --This is using a cursor-for loop although it will only grab the first record, then exit.
        --It was left with this architecture in case we need to add some further code to it later.
        for k in (select os.SID
                    from t_osi_status_history osh, t_osi_status os, t_osi_status_return_points osrp
                   where os.SID = osrp.status_sid and osrp.active = 'Y' and osh.obj = p_obj and osh.status = os.SID
                     and (   osrp.OBJ_TYPE member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                     or obj_type = core_obj.lookup_objtype('ALL'))
                   order by osh.create_on desc)
        loop
            v_return := k.sid;
            exit;
        end loop;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.find_last_valid_return_point: ' || sqlerrm);
            raise;
    end find_last_valid_return_point;

    --Finds the number of days to use for a suspense date calculation
    function find_days_for_suspense(p_obj in varchar2)
        return number is
        v_number_of_days   t_core_config.setting%type;
    begin
/************************************************************************
--Below is the SQL from the fat client.  This will need to be implemented once
we have out Investigative File tables in place
--        SQL = " SELECT "
--        SQL = SQL & "    SPECIAL_INTEREST"
--        SQL = SQL & " FROM "
--        SQL = SQL & "    T_INVESTIGATIVE_FILE"
--        SQL = SQL & " WHERE "
--        SQL = SQL & "    SID in"
--        SQL = SQL & "       (select FYLE from T_FILE_CONTENT "
--        SQL = SQL & "        where ACTIVITY = '" & pActivitySID & "') "
--        SQL = SQL & "    and"
--        SQL = SQL & "    SPECIAL_INTEREST = '13'"
************************************************************************/
--Notes:05/15/2009
--Basicaly what happens is, you check the associated investigative files,
--see if there is one with a special interest of 13 or'Seven Burner',
--and IF SO, it uses core_util.GET_CONFIG('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_2') which is 5 days
--and IF NOT, it uses core_util.GET_CONFIG('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_1') which is 20 days

        --For now, we will just return 20 days
        return core_util.get_config('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_1');
    exception
        when others then
            log_error('OSI_STATUS_PROC.find_days_for_suspense: ' || sqlerrm);
            raise;
    end find_days_for_suspense;

    --Used for updating an activities create by unit
    procedure update_activity_create_by_unit(p_obj in varchar2, p_unit in number) is
        v_date   date;
    begin
        update t_osi_activity
           set creating_unit = p_unit;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_create_by_unit: ' || sqlerrm);
            raise;
    end update_activity_create_by_unit;

    --Used for updating an activities suspense date
    procedure update_activity_suspense_date(p_obj in varchar2, p_num_of_days in number) is
        v_date   date;
    begin
        --See if there is already a suspense date
        select suspense_date
          into v_date
          from t_osi_activity
         where sid = p_obj;

        if (v_date is null) then
            v_date := sysdate + p_num_of_days;
        else
            v_date := v_date + p_num_of_days;
        end if;

        update t_osi_activity
           set suspense_date = v_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_suspense_date: ' || sqlerrm);
            raise;
    end update_activity_suspense_date;

    --Used for updating an activities complete date
    procedure update_activity_complete_date(p_obj in varchar2, p_date in date) is
    begin
        --Set the activity Completed Date
        update t_osi_activity
           set complete_date = p_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_complete_date: ' || sqlerrm);
            raise;
    end;

    --Used for updating an activities complete date
    procedure update_activity_close_date(p_obj in varchar2, p_date in date) is
    begin
        --Set the activity Close Date
        update t_osi_activity
           set close_date = p_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_close_date: ' || sqlerrm);
            raise;
    end;

    --Used for updating activity unit assignment
    procedure update_activity_unit_assign(p_obj in varchar2, p_unit in varchar2) is
    begin
        update t_osi_activity
           set assigned_unit = p_unit
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_unit_assign: ' || sqlerrm);
            raise;
    end update_activity_unit_assign;

    --Used for updating activity unit assignment
    procedure update_activity_aux_unit(p_obj in varchar2, p_unit in varchar2) is
    begin
        update t_osi_activity
           set aux_unit = p_unit
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_aux_unit: ' || sqlerrm);
            raise;
    end update_activity_aux_unit;

    /* Used to process an activity on Completion */
    procedure complete_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Set the activity Completed Date
        update_activity_complete_date(p_obj, sysdate);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.complete_activity: ' || sqlerrm);
            raise;
    end complete_activity;

    /* Used to process an activity on Closure */
    procedure close_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update_activity_close_date(p_obj, sysdate);
        end_all_assignments(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.close_activity: ' || sqlerrm);
            raise;
    end close_activity;

    /* Changes Investigations from OPEN to Investigatively Closed (when the file is being Re-Opened */
/*    procedure ic_object(p_obj in varchar2) is

        v_status_sid        T_OSI_STATUS.sid%type;
        v_status_change_sid T_OSI_STATUS.sid%type;
        v_current_status    T_OSI_STATUS.sid%type;
        v_type              varchar(50);
        
    begin
         if(:P0_OBJ_TYPE_CODE like 'FILE.INV%' and :P5100_USAGE = 'REPORT') then

           select at.sid into v_type from t_osi_attachment_type at 
                 where at.usage = 'REPORT'
                   and at.code = 'ROIFP'
                   and at.obj_type = :P0_OBJ_TYPE_SID;

           v_current_status := osi_object.get_status_code(:P0_OBJ);

           if (v_current_status = 'OP' and :P5100_TYPE = v_type) then

             select sc.sid into v_status_change_sid from t_osi_status_change sc, t_osi_status s1, t_osi_status s2
                   where sc.from_status = s1.sid
                     and sc.to_status = s2.sid
                     and s1.code = 'OP'
                     and s2.code = 'IC'
                     and sc.obj_type = core_obj.lookup_objtype('FILE.INV');

             osi_status.change_status(:P0_OBJ, v_status_change_sid);

           end if;
         
         end if;
         
      exception
        when others then
            log_error('OSI_STATUS_PROC.ic_object: ' || sqlerrm);
            raise;
    end ic_object;
*/    
    /* Used to process an activity on Re-Open */
    procedure reopen_object(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status_sid   t_OSI_STATUS.sid%type;
        v_object_type_code  varchar2(100);
        v_last_inv_closed   date;
        v_inv_closed_status_sid varchar2(20);
        v_roi_count number;
    begin
        --Get last allowable return point
        v_status_sid := find_last_valid_return_point(p_obj);
        --Change to tha status we just got from the find_last_valid_return_point() function
        OSI_STATUS.change_status_brute(p_obj, v_status_sid, 'Reopen');
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
        
        v_object_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

        ---Investigations need to go from Open to Investigatively Closed if there is a 'ROI/CSR Final Published' attached---
        if v_object_type_code in ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') then
          
          select count(*) into v_roi_count from t_osi_attachment a,t_osi_attachment_type t
                where a.obj=p_obj and a.type=t.sid and t.code='ROIFP' and t.OBJ_TYPE=core_obj.get_objtype(p_obj);
          
          if v_roi_count > 0 then                

            select sid into v_inv_closed_status_sid 
                 from t_osi_status where code='IC' and description='Investigatively Closed';
                
            v_last_inv_closed := osi_status.last_sh_date(p_obj, v_inv_closed_status_sid);

            update t_osi_status_history set is_current='N' where obj=p_obj;
            insert into t_osi_status_history (obj, status, effective_on, transition_comment, is_current)
               values (p_obj, v_inv_closed_status_sid, v_last_inv_closed, 'Investigatively Closed', 'Y');

          end if;
            
        End if;
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.reopen_object: ' || sqlerrm);
            raise;
    end reopen_object;

    /* Used to process an activiting on Assignment of an Auxilary Unit */
    procedure assign_auxilary_unit(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_suspense_days_to_use   number;
    begin
/*****************************************************************/
--Keep the descriptiopn below "Assign Auxillary Unit DET 401"
--Me.SHDescription.xValue = Me.SHDescription.Value & " " & pUnitName
--NOTE SURE HOW WE'RE GOING TO HANDLE THIS
--Might have to just update the last SH change that was made..
/*****************************************************************/

        --Update Unit Assignment
        update_activity_unit_assign(p_obj, p_parameter1);
        --Update aux unit
        update_activity_aux_unit(p_obj, p_parameter1);
        --Update the suspense date
        update_activity_suspense_date(p_obj, find_days_for_suspense(p_obj));
        --Update the completed date
        update_activity_complete_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.assign_auxilary_unit: ' || sqlerrm);
            raise;
    end assign_auxilary_unit;

    /* Used to process an activity on Re-Call */
    procedure recall_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        test   number;
    begin
        --**Note: This function is virtually identical to reject_activity, but left seperate for differentiation
        --**>
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Update aux unit
        update_activity_aux_unit(p_obj, null);
        --Update the suspense date
        update_activity_suspense_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.recall_activity: ' || sqlerrm);
            raise;
    end recall_activity;

    /* Used to process an activity on Rejection */
    procedure reject_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        test   number;
    begin
        --**Note: This function is virtually identical to recall_activity, but left seperate for differentiation
        --**>
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Update aux unit
        update_activity_aux_unit(p_obj, null);
        --Update the suspense date
        update_activity_suspense_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.reject_activity: ' || sqlerrm);
            raise;
    end reject_activity;

    procedure case_from_init_notif(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_init_notification.create_case_file(p_obj, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('case_from_init_notif' || sqlerrm);
            raise;
    end case_from_init_notif;
    /* Used to process an activity on Clone */
    procedure clone_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_core_obj_record           t_core_obj%rowtype;
        v_object_type               t_core_obj_type.sid%type;
        v_object_type_description   t_core_obj_type.description%type;
        v_new_sid                   varchar2(20);
        v_new_id                    varchar2(100);
        v_temp t_osi_note.sid%type;
        v_id                        varchar2(100);
        v_title                     varchar2(100);
    begin
        --Set v_object_type
        v_object_type := core_obj.get_objtype(p_obj);

        --Set v_object_type_description
        select description
          into v_object_type_description
          from t_core_obj_type
         where sid = v_object_type;

        --Get new ID
        v_new_id := osi_object.get_next_id;

        --Get the Core_Obj Information
        select *
          into v_core_obj_record
          from t_core_obj
         where sid = p_obj;

        --Create t_core_obj record
        insert into t_core_obj
                    (obj_type, acl)
             values (v_core_obj_record.obj_type, v_core_obj_record.acl)
          returning sid
               into v_new_sid;

        --Set global clone sid
        v_clone_new_sid := v_new_sid;
        
        --Create t_osi_activity_record
        for k in (select *
                    from t_osi_activity
                   where sid = p_obj)
        loop
            v_id := k.id;

            v_title := osi_object.get_default_title(v_core_obj_record.obj_type);
        
            if v_title is null or v_title='' then
          
              v_title := substr('Copy of: ' || k.title, 1, 100);

            end if;
            
            insert into t_osi_activity
                        (sid,
                         id,
                         title,
                         narrative,
                         creating_unit,
                         assigned_unit,
                         activity_date,
                         source)
                 values (v_new_sid,
                         v_new_id,
                         v_title, ---'Copy of: ' || k.title,
                         k.narrative,
                         k.creating_unit,
                         k.creating_unit,
                         k.activity_date,
                         k.source);
        end loop;

        osi_object.do_title_substitution(v_new_sid);

        --Set status
        OSI_STATUS.change_status_brute(v_new_sid,
                                       OSI_STATUS.get_starting_status(v_object_type),
                                       'Created');
        --Add Note
        v_temp := osi_note.add_note(v_new_sid,
                          osi_note.get_note_type(v_object_type, 'CLONE'),
                          'This ' || v_object_type_description || ' Activity was created from the '
                          || v_object_type_description || ' with ID# ' || v_id || '.');

        --Clone AddressList
        for k in (select *
                    from t_osi_address
                   where obj = p_obj)
        loop
            insert into t_osi_address
                        (obj,
                         address_type,
                         address_1,
                         address_2,
                         city,
                         state,
                         postal_code,
                         country,
                         start_date,
                         end_date,
                         known_date,
                         province,
                         geo_coords,
                         comments)
                 values (v_new_sid,
                         k.address_type,
                         k.address_1,
                         k.address_2,
                         k.city,
                         k.state,
                         k.postal_code,
                         k.country,
                         k.start_date,
                         k.end_date,
                         k.known_date,
                         k.province,
                         k.geo_coords,
                         k.comments);
        end loop;

        --Clone Assignment List
        for k in (select *
                    from t_osi_assignment
                   where obj = p_obj)
        loop
            insert into t_osi_assignment
                        (obj, personnel, assign_role, start_date, end_date, unit)
                 values (v_new_sid, k.personnel, k.assign_role, k.start_date, k.end_date, k.unit);
        end loop;

        --Clone Investigative Support
        --t_osi_mission_category, t_osi_mission
        for k in (select *
                    from t_osi_mission
                   where obj = p_obj)
        loop
            insert into t_osi_mission
                        (obj, obj_context, mission)
                 values (v_new_sid, k.obj_context, k.mission);
        end loop;

        --Clone Associated Files
        for k in (select *
                    from t_osi_assoc_fle_act
                   where activity_sid = p_obj)
        loop
            insert into t_osi_assoc_fle_act
                        (activity_sid, file_sid, resource_allocation)
                 values (v_new_sid, k.file_sid, k.resource_allocation);
        end loop;

        --Clone Participant List
        for k in (select *
                    from t_osi_partic_involvement
                   where obj = p_obj)
        loop
            insert into t_osi_partic_involvement
                        (obj,
                         participant_version,
                         involvement_role,
                         num_briefed,
                         action_date,
                         response,
                         response_date,
                         agency_file_num,
                         report_to_dibrs,
                         report_to_nibrs,
                         reason)
                 values (v_new_sid,
                         k.participant_version,
                         k.involvement_role,
                         k.num_briefed,
                         k.action_date,
                         k.response,
                         k.response_date,
                         k.agency_file_num,
                         k.report_to_dibrs,
                         k.report_to_nibrs,
                         k.reason);
        end loop;
        
        --Do special processing (per object), each object will need its own CLONE() procedure.
        execute immediate 'BEGIN ' || osi_object.get_obj_package(v_object_type) || '.CLONE('''
                          || p_obj || ''', ''' || v_new_sid || '''); END;';
    exception
        when others then
            log_error('OSI_STATUS_PROC.clone_activity: ' || sqlerrm);
            raise;
    end clone_activity;

    procedure clone_to_case(
        p_sid          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_investigation.clone_to_case(p_sid, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('clone_to_case: ' || sqlerrm);
            raise;
    end clone_to_case;


    /* Used to retrieve the SID of a recently cloned object */
    function get_cloned_sid
        return varchar2 is
    begin
        return v_clone_new_sid;
    exception
        when others then
            log_error('OSI_STATUS_PROC.get_cloned_sid: ' || sqlerrm);
            raise;
    end get_cloned_sid;

    /* Used to process a file transfer */
    procedure transfer_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        --Set the owning unit
        osi_file.set_unit_owner(p_obj, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('OSI_STATUS_PROC.transfer_file: ' || sqlerrm);
            raise;
    end transfer_file;

    /* Used to process a file being closed short */
    procedure mark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_file
           set closed_short = 'Y'
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.mark_closed_short_file: ' || sqlerrm);
            raise;
    end mark_closed_short_file;

    /* Used to process a file being re-opened */
    procedure unmark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_file
           set closed_short = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.unmark_closed_short_file: ' || sqlerrm);
            raise;
    end unmark_closed_short_file;

    /* Used to unarchive a file */
    procedure unarchive_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_temp   varchar2(2000);
    begin
        --Parameter 1 should be the unit
        --Parameter 2 should be the reason

        --Set the owner to the new unit (if it is different than the current unit)
        if (p_parameter1 != osi_file.get_unit_owner(p_obj)) then
            if (p_parameter2 is null) then
                v_temp := 'Unarchive to a Different Unit';
            else
                v_temp := p_parameter2;
            end if;

            osi_file.set_unit_owner(p_obj, p_parameter1, v_temp);
            
            reset_restriction(p_obj);
        end if;

    exception
        when others then
            log_error('OSI_STATUS_PROC.unarchive_file: ' || sqlerrm);
            raise;
    end unarchive_file;

    /* Used to verify that the current user was the one that created the last status history record */
    function verify_user_created_last_sh(p_obj in varchar2)
        return varchar2 is
        v_return       varchar2(3000);
        v_created_by   varchar2(200);
    begin
        v_created_by := OSI_STATUS.last_sh_create_by(p_obj, null);

        if (core_context.personnel_name != v_created_by) then
            v_return := 'Only ' || v_created_by || ' can perform this operation.';
        else
            v_return := null;
        end if;

        return v_return;
    exception
        when others then
            log_error('verify_user_created_last_sh: ' || sqlerrm);
            raise;
    end verify_user_created_last_sh;
    
    procedure confirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_participant.confirm(p_obj);
    exception
        when others then
            log_error('confirm_participant: ' || sqlerrm);
            raise;
    end confirm_participant;

    procedure unconfirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_participant.unconfirm(p_obj);
    exception
        when others then
            log_error('unconfirm_participant: ' || sqlerrm);
            raise;
    end unconfirm_participant;

    procedure set_file_full_id(p_obj in varchar2,
                               p_parameter1 in varchar2 := null,
                               p_parameter2 in varchar2 := null) is
        v_ot_code t_core_obj_type.code%type;
        v_full_id t_osi_file.full_id%type;
    begin
        log_error('set_file_full_id called');

        v_full_id := osi_file.generate_full_id(p_obj);

        if v_full_id is not null then
        update t_osi_file
           set full_id = v_full_id
         where sid = p_obj;
        end if;
    exception when others then
            log_error('OSI_STATUS_PROC.set_file_full_id: ' || sqlerrm);
    end set_file_full_id;
    
    procedure source_burn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_source.burn(p_obj);
    exception
        when others then
            log_error('source_burn: ' || sqlerrm);
    end source_burn;
    
    function source_exists(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_source.already_exists(p_obj);
    exception
        when others then
            log_error('source_exists: ' || sqlerrm);
    end source_exists;
    
    procedure source_migrate(
        p_obj           in varchar2,
        p_parameter1    in varchar2 := null,
        p_parameter2    in varchar2 := null)is
    begin
        v_clone_new_sid := osi_source.migrate(p_obj);
    exception
        when others then
            log_error('source_migrate: ' || sqlerrm);
    end source_migrate;
    
    procedure source_unburn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_source.unburn(p_obj);
    exception
        when others then
            log_error('source_unburn: ' || sqlerrm);
    end source_unburn;
    
    procedure transfer_file_end_assignments(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        transfer_file(p_obj, p_parameter1, p_parameter2);
        end_all_assignments(p_obj);
    exception when others then
        log_error('transfer_file_end_assignments: ' || sqlerrm);
    end transfer_file_end_assignments;
    
    /* Determines whether or not a certain 110 file can be recalled (based on current status) */
    function aapp_can_recall(p_obj in varchar2)
        return varchar2 is
        v_return        varchar2(3000);
        --v_current_lifecycle_state t_osi_status_history
        v_status_code   varchar2(200);
        v_crlf varchar2(200) := Chr(13) ;
    begin
        --Need to lock out Recall during the following status states:
        --NW,CL,STA,RAA,ARCH
        v_status_code := osi_object.get_status_code(p_obj);

        if (v_status_code in ('NW','CL','STA','RAA','ARCH')) then
            v_return :=
                'Recall can not be done in the following lifecycle states:' || v_crlf || 'New' || v_crlf || 'Closed' || v_crlf || 'Sent to Archive' || v_crlf || 'Received At Archive' || v_crlf || 'Archived';
        else
            v_return := null;
        end if;

        return v_return;
    exception
        when others then
            log_error('aapp_can_recall: ' || sqlerrm);
            raise;
    end aapp_can_recall;
    
    procedure recall_aapp_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_new_status    t_osi_status_history.status%type;
    begin
        --Append to Note (Done in After Update process in the Page [Page 5450])
        
        --Get last status (where TO and FROM status are different)
        -->There is no FROM and TO in STATUS_HISTORY
        for K in (select STATUS from t_osi_status_history
        where is_current = 'N' and obj = p_obj order by create_on desc)
        loop
            --Ordering descending, grab the first item and leave
            v_new_status := k.status;
            exit;
        end loop;        
        
        --Change Status to last [real] status (Check to see how this works in a 
        --loop.  Assuming the user might expect to move back multiple 
        --lifecycle steps??) [meaning we would have to find items where 
        --TO and FROM status were different, AND also not coupled by a recall] 
        --NOT DOING THIS: SEE COMMENT BELOW
        osi_status.CHANGE_STATUS_BRUTE(p_obj, v_new_status, 'Recalled To ' || osi_status.GET_STATUS_DESC(v_new_status));
        --Will not be handling looping.  So, it someone Recalls from Open to New, 
        --then Recalls again, it will recall back to Open.
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.recall_aapp_file: ' || sqlerrm);
            raise;
    end recall_aapp_file;
    
    /* Used to change an AAPP (110 File)'s restriction to "Assigned Personnel" on close .  This stops personnel from seeing their own file. */
    procedure aapp_set_restriction_ap(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_new_restriction            t_core_obj.acl%type;
        v_current_restriction_desc   varchar2(300);
    begin
        --Get new restriction
        v_new_restriction := get_restriction_sid('Assigned Personnel');

        --Get the current ACL
        select tor.description
          into v_current_restriction_desc
          from t_osi_reference tor, t_osi_file tof
         where tof.restriction = tor.sid(+) and tof.sid = p_obj;

        --If the ACL is "Assigned Personnel", then we need to change it to
        --Unit and Assigned Personnel
        if (v_current_restriction_desc = 'Unit and Assigned Personnel') then
            --Update T_CORE_OBJ with new ACL
            update t_osi_file
               set restriction = v_new_restriction
             where sid = p_obj;
        end if;
    exception
        when others then
            log_error('OSI_STATUS_PROC.aapp_set_restriction_ap: ' || sqlerrm);
            raise;
    end aapp_set_restriction_ap;

    /* Suspicious Activity (phase) status changes update the "follow-up suffix" */
    procedure sar_phase_update(p_obj in varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        --v_current_lifecycle_state t_osi_status_history
        v_status_code   varchar2(200);
        v_cur_suffix    t_osi_a_suspact_report.followup_suffix%type;
        v_new_suffix    varchar2(50);
        v_version_char   varchar2(1);
    begin
        --get current status
        v_status_code := osi_object.get_status_code(p_obj);

        begin
            select followup_suffix
              into v_cur_suffix
              from t_osi_a_suspact_report
             where sid = p_obj;
        exception
            when NO_DATA_FOUND then
                 v_cur_suffix := '';
        end;

        v_version_char := nvl(substr(v_cur_suffix, 3), '');

        case v_status_code
            when 'SR' then--Submit for Review
            v_new_suffix := 'YN' || v_version_char; 
            when 'SP' then--Submit to Publish
            v_new_suffix := 'YY' || v_version_char; 
            when 'PU' then--Publish SAR
            v_new_suffix := 'NY' || v_version_char; 
            when 'OP' then--Create Echo
               if v_version_char is null then
                  v_version_char := 'a';
               else
                  v_version_char := CHR(ASCII(SUBSTR(v_version_char, 1, 1)) + 1);
               end if;
               v_new_suffix := 'NN' || v_version_char;
        end case;

        update t_osi_a_suspact_report set followup_suffix = v_new_suffix where sid = p_obj;

    exception
        when others then
            log_error('sar_phase_update: ' || sqlerrm);
            raise;
    end sar_phase_update; 

    /*Suspicious Activity "reopen" restores to the last phase transition */
    procedure reopen_sar(
    p_obj          in   varchar2,
    p_parameter1   in   varchar2 := null,
    p_parameter2   in   varchar2 := null) is
    v_cur_suffix    t_osi_a_suspact_report.followup_suffix%type;
    v_status_code   varchar2(100);
    v_to_status     varchar2(20);
    begin
        begin
            select followup_suffix
              into v_cur_suffix
              from t_osi_a_suspact_report
             where SID = p_obj;
        exception
            when NO_DATA_FOUND then
                v_cur_suffix := '';
        end;

        case nvl(substr(v_cur_suffix, 1, 2), '')
            when '' then                                --indicates no phase transitions
                v_status_code := 'CM';
            when 'YN' then                              --indicates last phase was: Submitted for Review
                v_status_code := 'SR';
            when 'YY' then                              --indicates last phase was: Submitted to Publish
                v_status_code := 'SP';
            when 'NY' then                              --indicates last phase was: Published
                v_status_code := 'PU';
            when 'NN' then/* This is special...indicates last phase was Echo created, then completed, closed, and re-opened.
                             In this case the status goes back to 'Published'*/
                v_status_code := 'PU';
        end case;

        select SID
          into v_to_status
          from t_osi_status
         where code = v_status_code;

        OSI_STATUS.change_status_brute(p_obj, v_to_status, 'Reopen');
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when OTHERS then
            log_error('reopen_sar error: ' || sqlerrm);
    end;   

    /*Used to copy special interests on Case when approved*/
    procedure copy_special_interest(
        p_obj          in   varchar2, 
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    
    begin
        
        --delete existing special interests with obj_context of 'A', if any

        delete from t_osi_mission
        where obj = p_obj
        and obj_context = 'A';

        --make copies of existing special interestes

        insert into t_osi_mission (obj, mission, obj_context)
            select obj, mission, 'A'
             from t_osi_mission
            where obj = p_obj
             and obj_context = 'I';

    exception
        when others then
            log_error('OSI_STATUS_PROC.copy_special_interest: ' || sqlerrm);
            raise;
    end copy_special_interest;

    procedure deers_update_links(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        l_result varchar2(32767) := null;
    begin
        -- Status methods that execute AFTER do not have return values.
        l_result := osi_deers.update_all_pv_links(p_obj);
    exception
        when others then
            log_error('osi_status_proc.deers_update_links: ' || sqlerrm);
            raise;
    end deers_update_links;
    
    function check_for_old_partic_links(p_obj in varchar2)
        return varchar2 is
        l_yr_ago   date         := sysdate - 365;
        l_pv_sid   varchar2(50) := null;
    begin
        --Loop through activity participants tied to this file
        for i in (select activity_sid
                    from t_osi_assoc_fle_act
                   where file_sid = p_obj and modify_on > l_yr_ago)
        loop
            for j in (select pv.participant, z.participant_version
                        from v_osi_partic_act_involvement z,
                             t_osi_participant ip,
                             t_osi_participant_version pv
                       where z.activity = i.activity_sid
                         and z.participant_version = pv.sid
                         and pv.participant = ip.sid)
            loop
                begin
                    select sid
                      into l_pv_sid
                      from v_osi_participant_version
                     where participant = j.participant and sid = current_version;
                exception
                    when no_data_found then
                        l_pv_sid := null;
                end;

                if (l_pv_sid <> j.participant_version and l_pv_sid is not null) then
                    --update_pv_links(j.participant_version, l_pv_sid, i.activity_sid, false);
                    --Updatable link was found, return null and allow user to update
                    return null;
                end if;
            end loop;
        end loop;

        --Loop through file participants
        for m in (select pv.participant, f.participant_version
                    from v_osi_partic_file_involvement f,
                         t_osi_participant ip,
                         t_osi_participant_version pv
                   where f.file_sid = p_obj
                     and f.participant_version = pv.sid
                     and pv.participant = ip.sid)
        loop
            begin
                select sid
                  into l_pv_sid
                  from v_osi_participant_version
                 where participant = m.participant and sid = current_version;
            exception
                when no_data_found then
                    l_pv_sid := null;
            end;

            if (l_pv_sid <> m.participant_version and l_pv_sid is not null) then
                
                --Updatable link was found, return null and allow user to update
                return null;
            end if;
        end loop;

        return 'No Participant Links need updating.';
    exception
        when OTHERS then
            log_error('OSI_STATUS_PROC.check_for_old_partic_links: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            raise;
    end check_for_old_partic_links;

    /* Used to transfer ownership of a Poly File automatically based on status. */
    procedure poly_file_auto_transfer(p_obj in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) is
        
        v_transfer_reason  varchar2(500);
        v_prev_unit        varchar2(20);
        v_status_code      varchar2(200);
        
    begin
         v_status_code := osi_object.get_status_code(p_obj);
       
         select transition_comment into v_transfer_reason
           from t_osi_status_history
          where obj = p_obj
            and is_current = 'Y';
        
                      
         --- if 'Awaiting Approval' set the requesting_unit = Poly Auth Unit, if 'Awaiting ---
         ---    Closure' set the RPO Unit = Poly Auth Unit.                                ---
         case
             when v_status_code = 'AA' then
         
                 --- Set Request Unit to Last Owner but ONLY FOR CRIM POLY ---
                 if osi_object.get_objtype_code(core_obj.GET_OBJTYPE(p_obj))='FILE.POLY_FILE.CRIM' then
                   
                   update t_osi_f_poly_file set requesting_unit = osi_file.get_unit_owner(p_obj)where sid = p_obj;-------->core_util.get_config('POLY_SID') where sid = p_obj;
                   
                 end if;
                 
                 --- transfer ownership to Poly Auth Unit ---
                 transfer_file(p_obj, core_util.get_config('POLY_SID'), v_transfer_reason);

             when v_status_code = 'AC' then

                 --- Set RPO Unit to Last Owner ---
                 update t_osi_f_poly_file set rpo_unit = osi_file.get_unit_owner(p_obj)where sid = p_obj;--------> core_util.get_config('POLY_SID') where sid = p_obj;

                 --- transfer ownership to Poly Auth Unit ---
                 transfer_file(p_obj, core_util.get_config('POLY_SID'), v_transfer_reason);

             --- if status is reverting to 'New' or 'Open' transfer ownership to PREVIOUS unit. --- 
             when v_status_code in('NW','OP') then

                 for a in(select unit_sid from t_osi_f_unit
                                where file_sid = p_obj
                                  and end_date is not null
                                order by start_date desc)
                 loop
                     v_prev_unit := a.unit_sid;
                     exit;
                          
                 end loop;

                 --- transfer ownership to the previous unit ---
                 transfer_file(p_obj, v_prev_unit, v_transfer_reason); 

         end case;  
    
    exception
        when OTHERS then
            log_error('OSI_STATUS_PROC.POLY_FILE_AUTO_TRANSFER: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            raise;
    end;

/*Used to copy mission area value at the time the investigative file was approved */
     procedure copy_mission_area(
        p_obj          in   varchar2, 
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    
    begin
           --make copies of existing mission areas

            update t_osi_f_investigation 
                set manage_by_appv = (select manage_by
                                        from t_osi_f_investigation
                                        where sid = p_obj
                                        and manage_by is not null)
                where sid = p_obj;

    exception
        when others then
            log_error('OSI_STATUS_PROC.copy_mission_area: ' || sqlerrm);
            raise;
    end copy_mission_area;

/*Used to fill in the summary of investigation if null and add default suffix when investigative
    file is approved. */
 procedure autofill_summary_inv(
         p_obj          in   varchar2, 
   p_parameter1   in   varchar2 := null,
   p_parameter2   in   varchar2 := null) is

    v_summary clob;

    
    begin 
 
   select summary_investigation
                 into v_summary
             from T_OSI_F_INVESTIGATION
   where sid = p_obj; 
   
    --Copy background into summary investigation if summary investigation is null
    
    if dbms_lob.getlength(v_summary) = 0 then

     update t_osi_f_investigation
      set summary_investigation = (select summary_allegation
                                                       from t_osi_f_investigation
                                                       where sid = p_obj)
       where sid = p_obj;
  
    end if;
    
  --Add default suffix to summary investigation

           update t_osi_f_investigation
    set summary_investigation = summary_investigation || core_util.get_config('OSI.INV_SUMMARY_SUFFIX')
   where sid = p_obj;
 
 exception
        when others then
            log_error('OSI_STATUS_PROC.autofill_summary_inv: ' || sqlerrm);
            raise;
    end autofill_summary_inv; 

procedure create_sum_complaint_rpt(
    p_obj          in   varchar2,
    p_parameter1   in   varchar2 := null,
    p_parameter2   in   varchar2 := null) is
        v_blob           blob;
        v_clob           clob;
        v_in Pls_Integer := 1;
        v_out Pls_Integer := 1;
        v_lang Pls_Integer := 0;
        v_warning Pls_Integer := 0;
        v_attach_count   varchar2(10);
        v_id            varchar2(100);
        v_extension     t_osi_report_mime_type.file_extension%type;
        v_file_name     varchar2(100)                                := 'No_File_ID_Given';
        v_report_type   varchar2(20);
begin
    -- Check for existing SCR and delete if any exist
    select count(*)
      into v_attach_count
      from t_osi_attachment a, t_osi_attachment_type at
     where a.obj = p_obj
       and a.type = at.SID
       and at.usage = 'REPORT'
       and at.code = 'CR';


       if(v_attach_count > 0) then

             delete from t_osi_attachment a
               where a.obj = p_obj
               and a.type =
                 (select SID
                    from t_osi_attachment_type
                   where (usage = 'REPORT' and code = 'CR')
                     and obj_type = core_obj.get_objtype(p_obj));

       end if;

    -- Create Summary Complaint Report
    DBMS_LOB.CREATETEMPORARY(v_blob, FALSE);
    DBMS_LOB.OPEN(v_blob, DBMS_LOB.LOB_READWRITE);
    v_clob := osi_investigation.summary_complaint_rpt(p_obj);
    --Attach complaint report to investigative file
    dbms_lob.converttoblob(v_blob, v_clob, dbms_lob.getlength(v_clob), v_in, v_out, 1 ,v_lang, v_warning);

    --Get file name
    select SID into v_report_type from T_OSI_REPORT_TYPE
  where upper(description) = 'SUMMARY COMPLAINT REPORT';
    select mt.file_extension
      into  v_extension
      from t_osi_report_type rt, t_osi_report_mime_type mt
     where rt.sid = v_report_type and rt.mime_type = mt.sid(+);

    
    -- Look for a File or Activity ID first.
    for x in (select full_id
                from t_osi_file
               where sid = p_obj)
    loop
        v_id := x.full_id;
    end loop;

    if (v_id is not null) then
        v_file_name := v_id;
    end if;

    v_file_name := v_file_name || v_extension;

    
    insert into t_osi_attachment
                (obj, type, content, storage_loc_type, description, source, mime_type, creating_personnel)
         values (p_obj,
                 (select SID
                    from t_osi_attachment_type
                   where (usage = 'REPORT' and code = 'CR')
                     and obj_type = core_obj.get_objtype(p_obj)),
                 v_blob,
                 'DB',
                 'Complaint Report-Final',
                 v_file_name,
                 'application/msword',
                 core_context.personnel_sid);
exception
    when others then
        log_error('OSI_STATUS_PROC.create_sum_complaint_rpt: ' || sqlerrm);
        raise;
end create_sum_complaint_rpt;
    
   /* Clears the COMPLETE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_complete_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_activity
           set complete_date = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.act_clear_complete_date: ' || sqlerrm);
            raise;
    end act_clear_complete_date;

    /* Clears the CLOSE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_close_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_activity
           set close_date = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.act_clear_close_date: ' || sqlerrm);
            raise;
    end act_clear_close_date;

    /* At case approval, clear all subjects' negative DCII indications */
    procedure case_clear_negative_indexes(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_dcii_intentions
           set include_in_index = null
         where investigation = p_obj
     and include_in_index = 'N';
    exception
        when others then
            log_error('OSI_STATUS_PROC.case_clear_negative_indexes: ' || sqlerrm);
            raise;
    end case_clear_negative_indexes;

    /* Used to disable a Personnel PW */
    procedure pmm_disable_password(p_obj in varchar2, p_effective_date in date) is
        v_effective_date date;
    begin
        --Get PW Expirt Effective Date
        if (p_effective_date is not null) then
            v_effective_date := p_effective_date;
        else
            v_effective_date := sysdate;
        end if;
        
        --Disable Password
        update t_core_personnel
           set pswd = 'DISABLED'
         where sid = p_obj;

        --Update Pswd Exp. date
        update t_core_personnel
           set pswd_expiration_date = v_effective_date - 30
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_disable_password: ' || sqlerrm);
            raise;
    end pmm_disable_password;

    /* Used to Close a Personnel File (User Account) */
    procedure pmm_close_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status   t_osi_personnel.personnel_status_sid%type;
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);
        
        --Disable Password
        pmm_disable_password(p_obj, v_effective_date);

        --End current unit assignment
        update t_osi_personnel_unit_assign
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --End roles
        update t_osi_personnel_unit_role
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --End privs
        update t_osi_personnel_priv
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --Clear Badge Number
        update t_osi_personnel
           set badge_num = null
         where sid = p_obj;

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'CL';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_close_account: ' || sqlerrm);
            raise;
    end pmm_close_account;

    /* Used to verify that the current user is allowed to close the given account SID */
    function pmm_user_can_close_account(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
    begin
        if (core_context.personnel_sid = p_obj) then
            v_return := 'You may not close your own Personnel Record.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_close_account: ' || sqlerrm);
            raise;
    end pmm_user_can_close_account;

    /* Used to Suspend a Personnel File (User Account) */
    procedure pmm_suspend_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status   t_osi_personnel.personnel_status_sid%type;
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);
        
        
        --Disable Password
        pmm_disable_password(p_obj, v_effective_date);

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'SU';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_suspend_account: ' || sqlerrm);
            raise;
    end pmm_suspend_account;

    /* Used to Reopen a Personnel File (User Account) */
    procedure pmm_reopen_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_username   t_core_personnel.login_id%type;
        v_status     t_osi_personnel.personnel_status_sid%type;
        v_ok         varchar2(200);
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);

        --Get Username
        select login_id
          into v_username
          from t_core_personnel
         where sid = p_obj;

        --Reset Password
        v_ok := core_context.reset_pswd(v_username, core_util.get_config('CORE.PSWD_RESET'));

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'OP';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_reopen_account: ' || sqlerrm);
            raise;
    end pmm_reopen_account;

    /* Used to verify that the current user is allowed to reopen the given account SID */
    function pmm_user_can_reopen_account(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
    begin
        --Must be able to reset a PW
        if (osi_auth.check_for_priv('RESET_PW', core_obj.get_objtype(p_obj)) <> 'Y') then
            v_return :=
                'You do not have permission to reset a users password which is required to reopen an account.'
                || chr(13);
        end if;

        --Target Personnel must have a current Unit Assignment
        if (osi_personnel.get_current_unit(p_obj) is null) then
            v_return :=
                v_return
                || 'This account can only be re-opened if the Agent has been assigned to a Unit.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_reopen_account: ' || sqlerrm);
            raise;
    end pmm_user_can_reopen_account;

    /* Used to reset password via the Actions Menu */
    procedure pmm_handle_pw_reset(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_username   t_core_personnel.login_id%type;
        v_ok         varchar2(200);
    begin
        --Get Username
        select login_id
          into v_username
          from t_core_personnel
         where sid = p_obj;

        --Reset Password
        v_ok := core_context.reset_pswd(v_username, core_util.get_config('CORE.PSWD_RESET'));
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_handle_pw_reset: ' || sqlerrm);
            raise;
    end pmm_handle_pw_reset;
    
    /* PMM: Used to Fix Login ID's via the Actions Menu */
    procedure pmm_handle_fix_login_id(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_current_login_id t_core_personnel.LOGIN_ID%type;
        v_new_id            t_core_personnel.LOGIN_ID%type;
        v_orig_ln        varchar2(100);
        v_fi             varchar2(1);
        v_mi             varchar2(1);
        v_ln             varchar2(50);
        v_id             varchar2(30);
        v_fname         varchar2(100);
        v_mname         varchar2(100);
        v_lname         varchar2(100);
     
        begin
              --Get Old ID and other info
        select login_id, last_name, first_name, middle_name 
         into v_current_login_id, v_lname, v_fname, v_mname
          from t_core_personnel where sid = p_obj;
        
        
        --Save off Original Last Name (minus spaces and dashes and apostrophies)
        v_orig_ln := replace(v_lname, '-', '');
        v_orig_ln := replace(v_orig_ln, ' ', '');
        v_orig_ln := replace(v_orig_ln, '''', '');
        --Get first initial
        v_fi := substr(v_fname, 1, 1);
        --Get middle initial
        v_mi := substr(v_mname, 1, 1);
        --Put both together
        v_id := v_fi || v_mi;
        --Get Last Name
        v_ln := ltrim(upper(v_orig_ln), 8 - length(v_id));
        --Concatonate ID
        v_id := substr(v_id || v_ln, 0, 8);
        
        if (v_current_login_id <> v_id) then
            --If these two are the same, then the only thing we would be 
            --doing is incrementing the nunber at the end, which is pointless
            v_new_id := osi_personnel.CREATE_LOGIN_ID(v_fname, v_mname, v_lname);
                     
            update t_core_personnel
            set login_id = v_new_id where sid = p_obj;
        end if;
         
        exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_handle_fix_login_id: ' || sqlerrm);
            raise;
    end pmm_handle_fix_login_id;
    
    
    /* PMM: Used to verify that the current user is allowed to fix a login ID on the given account SID */
    function pmm_user_can_fix_login_id(p_obj in varchar2)
      
      return varchar2 is
        v_return   varchar2(3000) := null;
    begin
         if (core_context.personnel_sid = p_obj) then
            v_return := 'You may not fix your own Login ID.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_fix_login_id: ' || sqlerrm);
            raise;
    end pmm_user_can_fix_login_id;
    
    /*PMM: Returns message as to whether the object has open assignments. */
   function pmm_check_for_active_assign(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
        v_act      boolean := false;
        v_file     boolean := false;
    begin
        for k in (select *
                    from t_osi_assignment oa
                   where personnel = p_obj
                     and end_date is null
                     and osi_object.get_objtype_code(core_obj.get_objtype(oa.obj)) like 'ACT%')
        loop
            v_act := true;
        end loop;

        for k in (select *
                    from t_osi_assignment oa
                   where personnel = p_obj
                     and end_date is null
                     and osi_object.get_objtype_code(core_obj.get_objtype(oa.obj)) like 'FILE%')
        loop
            v_file := true;
        end loop;

        if (v_act and v_file) then
            v_return :=
                'This user has current assignment(s) in both Activities and Files, are you sure you would like to perform this action?';
        elsif(v_act and not v_file) then
            v_return :=
                'This user has current assignment(s) in Activities, are you sure you would like to perform this action?';
        elsif(not v_act and v_file) then
            v_return :=
                'This user has current assignment(s) in Files, are you sure you would like to perform this action?';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_check_for_active_assign: ' || sqlerrm);
            raise;
    end pmm_check_for_active_assign;

    function Get_Subject_Selection_HTML (p_obj in Varchar2) return clob is
    
        vCRLF            varchar2(2) :=  chr(10) || chr(13);
        l_rowCount       number default 1;
        l_i2msTable      clob;
        object_type      varchar2(100);
        v_name           varchar2(400);
        v_partic_version varchar2(20);
        
        vCursor sys_refcursor;
                
    begin
         l_i2msTable := '<P ALIGN=CENTER><TABLE ID="SubjectList">' || vCRLF || ' <TR ID="HeaderRow">' || vCRLF;
         l_i2msTable := l_i2msTable || '  <TD ID="HeaderColumn">*** Pick Subjects to Include in New Case File ***</TD>' || ' </TR>';

         l_rowCount := 0;

         --See if it is File or Activity--        
         select t.code into object_type from t_core_obj o,t_core_obj_type t where o.sid=p_obj and o.OBJ_TYPE=t.sid;
         if object_type like 'ACT.%' then

           open vCursor for SELECT osi_participant.get_name(participant_version) as name,participant_version FROM v_osi_partic_act_involvement WHERE activity=p_obj and role='Subject' order by name;      
         
         else

           open vCursor for SELECT osi_participant.get_name(participant_version) as name,participant_version FROM v_osi_partic_file_involvement WHERE file_sid=p_obj and role='Subject' order by name;      

         end if;
         
         loop
             FETCH vCursor INTO v_name, v_partic_version;
             EXIT WHEN vCursor%NOTFOUND;             
             l_i2msTable := l_i2msTable || ' <TR ';
               
             if mod(l_rowCount, 2) = 0 then
               
               l_i2msTable := l_i2msTable || 'ID="evenRow"';

             else
               
               l_i2msTable := l_i2msTable || 'ID="oddRow"';
                 
             end if;

             l_i2msTable := l_i2msTable || '><TD ID="theLabel"><input checked="true" name="p_t32" id="P5450_SUBJECT_CHECKBOX_' || l_rowCount || '" type="checkbox" value="' || v_partic_version || '" />' || v_name || '</TD></TR>' || vCRLF;

             l_rowCount := l_rowCount + 1;
         
         end loop;
     
         l_i2msTable := l_i2msTable || '</TABLE></P>' || vCRLF;
         
         close vCursor;
         if l_rowCount > 1 then

           log_error('Get_Subject_Selection_HTML returned=' || l_i2msTable);
           return l_i2msTable;
           
         else

           log_error('Get_Subject_Selection_HTML returned=NOTHING');
           return '';

         end if;
                 
         exception
             when others then
                 log_error('ERROR IN Get_Subject_Selection_HTML=' || sqlerrm);
                 raise;   
     
    end Get_Subject_Selection_HTML;

    procedure clone_to_dcii(
        p_sid          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_sfs_investigation.clone_to_dcii(p_sid, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('clone_to_dcii: ' || sqlerrm);
            raise;
    end clone_to_dcii;
 
end osi_status_proc;
/


