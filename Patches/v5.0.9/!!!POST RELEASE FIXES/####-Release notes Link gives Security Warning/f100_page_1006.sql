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
--   Date and Time:   08:45 Thursday May 23, 2013
--   Exported By:     TJWARD
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

PROMPT ...Remove page 1006
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1006);
 
end;
/

 
--application/pages/page_01006
prompt  ...PAGE 1006: News and Notes
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 1006,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'News and Notes',
  p_step_title=> 'News and Notes',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 17253320452445049+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TJWARD',
  p_last_upd_yyyymmddhh24miss => '20130523084432',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<table width="100%">'||chr(10)||
' <tr>'||chr(10)||
'  <td style="text-align:center;">'||chr(10)||
'    <img src="/i/themes/OSI/th_new2_e0.gif"/>'||chr(10)||
'    <a href="https://hqcuiosilapp.ogn.af.mil/OSILink/llisapi.dll?func=ll&objId=14652342&objAction=Download"><b>v5.0.9 Release Notes</b></a>'||chr(10)||
'    <img src="/i/themes/OSI/th_new2_e0.gif"/>'||chr(10)||
'  </td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
'  <td style="text-align:center;">'||chr(10)||
'    <a target="_blank" href="https://hqcuiosilapp.og';

s:=s||'n.af.mil/OSILink/llisapi.dll?func=ll&objId=11212929&objAction=browse&viewType=1"><b>Previous Release Notes</b></a>'||chr(10)||
'  </td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
'  <td style="text-align:center;">'||chr(10)||
'   <a target="_blank" href="http://hqcuiweb1.ogn.af.mil/i2ms/Pages/FAQ.htm"><b>WebI2MS Frequently Asked Questions (FAQ)</b></a>'||chr(10)||
'  </td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
'  <td style="text-align:center;">'||chr(10)||
'   <a target="_blank" href="http://hqcuiweb1.og';

s:=s||'n.af.mil/i2ms/Pages/patches.htm#LocalMode"><b>I2MS Local Mode/Downloads Center</b></a>'||chr(10)||
'  </td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
'  <td style="text-align:center;">'||chr(10)||
'   <a target="_blank" href="http://hqcuiweb1.ogn.af.mil/i2ms/Pages/patches.htm#scanner"><b>Crossmatch Guardian LScan Installation Instructions</b></a>'||chr(10)||
'  </td>'||chr(10)||
' </tr>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
''||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 18368820296281152 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1006,
  p_plug_name=> 'News and Notes',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1006
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
