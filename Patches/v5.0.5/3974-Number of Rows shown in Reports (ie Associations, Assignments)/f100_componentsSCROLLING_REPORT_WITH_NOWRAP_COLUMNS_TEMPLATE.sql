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
--   Date and Time:   07:56 Tuesday January 10, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     REPORT TEMPLATE: Scrolling Report with Nowrap Columns
--   Manifest End
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

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: REPORT TEMPLATE 1899530952156348
 
prompt  ...report templates
--
prompt  ......report template 1899530952156348
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="currentrow" nowrap>#COLUMN_VALUE#</td>';

c2:=c2||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="oddrow" id="dataColumn" nowrap>#COLUMN_VALUE#</td>';

c3:=c3||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="evenrow" id="dataColumn" nowrap>#COLUMN_VALUE#</td>';

c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 1899530952156348 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Scrolling Report with Nowrap Columns',
  p_row_template1=> c1,
  p_row_template_condition1=> '''#Current#''=''Y''',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" width=98%>'||chr(10)||
'#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2">'||chr(10)||
'<div class="reportContainer" id="reportContainer" style="max-height: 7000px; width:100%;" name="#REGION_ID#">'||chr(10)||
'<table class="reportData" cellpadding="0" cellspacing="0" border="0" width=98%>',
  p_row_template_after_rows =>'</tbody>'||chr(10)||
'</table>'||chr(10)||
'</div>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<BR>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_before_column_heading=>'<thead>'||chr(10)||
'',
  p_column_heading_template=>'<td#ALIGNMENT# id="#COLUMN_HEADER_NAME#" nowrap>#COLUMN_HEADER#</td>',
  p_after_column_heading=>'</thead><tbody>',
  p_row_template_display_cond1=>'NOT_CONDITIONAL',
  p_row_template_display_cond2=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'NOT_CONDITIONAL',
  p_pagination_template=>'#TEXT#',
  p_row_style_checked=>'#EEEEEE',
  p_theme_id  => 101,
  p_theme_class_id => 5,
  p_row_template_comment=> '28-Dec-2011 - Tim Ward - CR#3771, 3957, 3974 - Make Datagrid show more rows.'||chr(10)||
'                          Added id="dataColumn" to Column Template 2 and 3.'||chr(10)||
'                          Added  name="#REGION_ID#" to reportContainer.'||chr(10)||
'                          Added width="100%" to reportContainer for Fingerprint'||chr(10)||
'                           IAFIS Screen.'||chr(10)||
'                          Added a <BR> after ROWS, this is incase the datagrid'||chr(10)||
'                           is small, the buttons can overlay the pagination.');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 1899530952156348 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

COMMIT;
