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
--   Date and Time:   08:32 Wednesday January 18, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Service Files
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
 
 
prompt Component Export: LIST 92373837050870107
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Service Files',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 92032707002616756 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 2102306960125675 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'All Service Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1130_FILE_TYPE,P1130_TITLE:SERVICE,FILE.SERVICE,Files > Service:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1130_FILE_TYPE=''FILE.SERVICE'' and :APP_PAGE_ID=''1130''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2110412810174643 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Analysis and Production Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1130_FILE_TYPE,P1130_TITLE:SERVICE,FILE.GEN.ANP,Service > Analysis and Production Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1130_FILE_TYPE=''FILE.GEN.ANP'' and :APP_PAGE_ID=''1130''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5602421400237101 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'CSP Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1130_FILE_TYPE,P1130_TITLE:SERVICE,FILE.POLY_FILE.SEC,Service > CSP Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1130_FILE_TYPE=''FILE.POLY_FILE.SEC'' and :APP_PAGE_ID=''1130''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2119430827255503 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'AFOSI Applicant Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1130_FILE_TYPE,P1130_TITLE:SERVICE,FILE.AAPP,Service >AFOSI Applicant Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1130_FILE_TYPE=''FILE.AAPP'' and :APP_PAGE_ID=''1130''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2125814906326662 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'PSO Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1130_FILE_TYPE,P1130_TITLE:SERVICE,FILE.PSO,Service > PSO Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1130_FILE_TYPE=''FILE.PSO'' and :APP_PAGE_ID=''1130''',
  p_list_item_owner=> '');
 
null;
 
end;
/

COMMIT;
