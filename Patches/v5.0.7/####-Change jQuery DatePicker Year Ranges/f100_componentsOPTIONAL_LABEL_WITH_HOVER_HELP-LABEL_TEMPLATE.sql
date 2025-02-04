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
--   Date and Time:   10:22 Friday July 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LABEL TEMPLATE: Optional Label with Hover Help
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
 
 
prompt Component Export: LABEL TEMPLATE 1591526640502753
 
prompt  ...label templates
--
prompt  ......label template 1591526640502753
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 1591526640502753 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label with Hover Help',
  p_template_body1=>'<label class="hoverHelp" style="font-weight: bold; color: #000; cursor: help;" tabindex="999" for="#CURRENT_ITEM_NAME#" rel="" reltitle="">'||chr(10)||
'',
  p_template_body2=>'</label>',
  p_on_error_before_label=>'',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#',
  p_theme_id  => 101,
  p_theme_class_id => 1,
  p_template_comment=> '');
end;
null;
 
end;
/

COMMIT;
