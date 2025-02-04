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
--   Date and Time:   07:24 Monday January 9, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Desktop
--     LIST: Files
--     LIST: Investigative Files
--     LIST: Management Files
--     LIST: Participants
--     LIST: Service Files
--     LIST: Support Files
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
 
 
prompt Component Export: LIST 91998132424658949
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Desktop',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 92032707002616756 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92116208985192049 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'I2MS Desktop',
  p_list_item_link_target=> 'f?p=&APP_ID.:1000:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1000',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91998718702664468 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Activities',
  p_list_item_link_target=> 'f?p=&APP_ID.:1010:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1010',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91999023550665840 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1020:&SESSION.::&DEBUG.::P1020_TITLE,P0_DESKTOP_NAVIGATION:Desktop > Files,I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1020',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92002720480693324 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Participants',
  p_list_item_link_target=> 'f?p=&APP_ID.:1030:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1030_PARTIC_TYPE,P1030_TITLE:I2MS_DESKTOP,PARTICIPANT,Desktop > Participants:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1030_PARTIC_TYPE=''PARTICIPANT'' and :APP_PAGE_ID=''1030''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 6126203578140393 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Work Hours',
  p_list_item_link_target=> 'f?p=&APP_ID.:1040:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1040',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92203235573112745 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> 'Notifications',
  p_list_item_link_target=> 'f?p=&APP_ID.:1050:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1050',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92416419042215070 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> 'E-Funds Expenses',
  p_list_item_link_target=> 'f?p=&APP_ID.:1060:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1060',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92416623891216434 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> 'E-Funds Advances',
  p_list_item_link_target=> 'f?p=&APP_ID.:1070:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1070',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 4922801760506459 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>80,
  p_list_item_link_text=> 'Full Text Search',
  p_list_item_link_target=> 'f?p=&APP_ID.:1080:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:I2MS_DESKTOP:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1080',
  p_list_item_owner=> '');
 
null;
 
end;
/

 
prompt Component Export: LIST 91999430476667882
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Files',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 92032707002616756 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 91999913513667885 + wwv_flow_api.g_id_offset,
  p_list_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'All Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1020:&SESSION.::&DEBUG.::P1020_TITLE,P0_DESKTOP_NAVIGATION:Files > All Files,FILES:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1020',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91999615562667884 + wwv_flow_api.g_id_offset,
  p_list_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Investigative Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1110:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1110_FILE_TYPE,P1110_TITLE:FILES,FILE.INV,Files > Investigative Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1110_FILE_TYPE=''FILE.INV'' and :APP_PAGE_ID=''1110''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2089925380960679 + wwv_flow_api.g_id_offset,
  p_list_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Service Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1130_FILE_TYPE,P1130_TITLE:FILES,FILE.SERVICE,Files > Service:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1130_FILE_TYPE=''FILE.SERVICE'' and :APP_PAGE_ID=''1130''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2095001448001051 + wwv_flow_api.g_id_offset,
  p_list_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Support Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1140_FILE_TYPE,P1140_TITLE:FILES,FILE.SUPPORT,Files > Support:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1140_FILE_TYPE=''FILE.SUPPORT'' and :APP_PAGE_ID=''1140''',
  p_list_item_owner=> '');
 
null;
 
end;
/

 
prompt Component Export: LIST 92214720944127418
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Investigative Files',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 92032707002616756 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92215109647133659 + wwv_flow_api.g_id_offset,
  p_list_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'All Investigative Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1110:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1110_FILE_TYPE,P1110_TITLE:INVESTIGATIVE,FILE.INV,Investigative Files > All:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1110_FILE_TYPE=''FILE.INV'' and :APP_PAGE_ID=''1110''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92216227439148201 + wwv_flow_api.g_id_offset,
  p_list_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Case Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1110:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1110_FILE_TYPE,P1110_TITLE:INVESTIGATIVE,FILE.INV.CASE,Investigative Files > Case Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1110_FILE_TYPE=''FILE.INV.CASE'' and :APP_PAGE_ID=''1110''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92216410601152826 + wwv_flow_api.g_id_offset,
  p_list_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Developmental Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1110:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1110_FILE_TYPE,P1110_TITLE:INVESTIGATIVE,FILE.INV.DEV,Investigative Files > Developmental Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1110_FILE_TYPE=''FILE.INV.DEV'' and :APP_PAGE_ID=''1110''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92216626531157387 + wwv_flow_api.g_id_offset,
  p_list_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Informational Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1110:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1110_FILE_TYPE,P1110_TITLE:INVESTIGATIVE,FILE.INV.INFO,Investigative Files > Informational Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1110_FILE_TYPE=''FILE.INV.INFO'' and :APP_PAGE_ID=''1110''',
  p_list_item_owner=> '');
 
null;
 
end;
/

 
prompt Component Export: LIST 92363332155840307
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Management Files',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 92032707002616756 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 97318510671983603 + wwv_flow_api.g_id_offset,
  p_list_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7,
  p_list_item_link_text=> 'CFunds Management',
  p_list_item_link_target=> 'osi_cfunds.get_cfunds_mgmt_url',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> 'core_context.personnel_loginid = ''MARK''',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 8429608292461118 + wwv_flow_api.g_id_offset,
  p_list_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Evidence Management',
  p_list_item_link_target=> 'f?p=&APP_ID.:1320:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:MANAGEMENT:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1320',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92370607267861482 + wwv_flow_api.g_id_offset,
  p_list_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Personnel',
  p_list_item_link_target=> 'f?p=&APP_ID.:1340:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:MANAGEMENT:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1340',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92371118349864674 + wwv_flow_api.g_id_offset,
  p_list_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> 'Sources',
  p_list_item_link_target=> 'f?p=&APP_ID.:1350:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:MANAGEMENT:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1350',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2481112176554754 + wwv_flow_api.g_id_offset,
  p_list_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> 'Target Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1140_FILE_TYPE,P1140_TITLE:MANAGEMENT,FILE.GEN.TARGETMGMT,Management Files > Target Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1140_FILE_TYPE=''FILE.GEN.TARGETMGMT'' and :APP_PAGE_ID=''1140''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92373131509868521 + wwv_flow_api.g_id_offset,
  p_list_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>90,
  p_list_item_link_text=> 'Units',
  p_list_item_link_target=> 'f?p=&APP_ID.:1390:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION:MANAGEMENT:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1390',
  p_list_item_owner=> '');
 
null;
 
end;
/

 
prompt Component Export: LIST 92377423591894620
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Participants',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 92032707002616756 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92377628093895973 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'All Participants',
  p_list_item_link_target=> 'f?p=&APP_ID.:1030:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1030_PARTIC_TYPE,P1030_TITLE:PARTICIPANTS,PARTICIPANT,Participants > All Participants:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1030_PARTIC_TYPE=''PARTICIPANT'' and :APP_PAGE_ID=''1030''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378032248897120 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Individuals',
  p_list_item_link_target=> 'f?p=&APP_ID.:1030:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1030_PARTIC_TYPE,P1030_TITLE:PARTICIPANTS,PART.INDIV,Participants > Individuals:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1030_PARTIC_TYPE=''PART.INDIV'' and :APP_PAGE_ID=''1030''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378235365897989 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Companies',
  p_list_item_link_target=> 'f?p=&APP_ID.:1030:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1030_PARTIC_TYPE,P1030_TITLE:PARTICIPANTS,PART.NONINDIV.COMP,Participants > Companies:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1030_PARTIC_TYPE=''PART.NONINDIV.COMP'' and :APP_PAGE_ID=''1030''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378438482898956 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Organizations',
  p_list_item_link_target=> 'f?p=&APP_ID.:1030:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1030_PARTIC_TYPE,P1030_TITLE:PARTICIPANTS,PART.NONINDIV.ORG,Participants > Organizations:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1030_PARTIC_TYPE=''PART.NONINDIV.ORG'' and :APP_PAGE_ID=''1030''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378608830899828 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Programs',
  p_list_item_link_target=> 'f?p=&APP_ID.:1030:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1030_PARTIC_TYPE,P1030_TITLE:PARTICIPANTS,PART.NONINDIV.PROG,Participants > Programs:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1030_PARTIC_TYPE=''PART.NONINDIV.PROG'' and :APP_PAGE_ID=''1030''',
  p_list_item_owner=> '');
 
null;
 
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
  p_list_item_link_text=> 'OSI Application Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1130_FILE_TYPE,P1130_TITLE:SERVICE,FILE.AAPP,Service > OSI Application Files:',
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

 
prompt Component Export: LIST 92376809046890382
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Support Files',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 92032707002616756 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 2137303299335760 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'All Support Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1140_FILE_TYPE,P1140_TITLE:SUPPORT,FILE.SUPPORT,Support Files > All Support Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1140_FILE_TYPE=''FILE.SUPPORT'' and :APP_PAGE_ID=''1140''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5616505694298873 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Criminal Polygraph Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1140_FILE_TYPE,P1140_TITLE:SUPPORT,FILE.POLY_FILE.CRIM,Support Files > Criminal Polygraph Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1140_FILE_TYPE=''FILE.POLY_FILE.CRIM'' and :APP_PAGE_ID=''1140''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2137616805339689 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Tech Surveillance Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1140_FILE_TYPE,P1140_TITLE:SUPPORT,FILE.GEN.TECHSURV,Support Files > Tech Surveillance Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1140_FILE_TYPE=''FILE.GEN.TECHSURV'' and :APP_PAGE_ID=''1140''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2137827194342682 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Source Development Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1140_FILE_TYPE,P1140_TITLE:SUPPORT,FILE.GEN.SRCDEV,Support Files > Source Development Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1140_FILE_TYPE=''FILE.GEN.SRCDEV'' and :APP_PAGE_ID=''1140''',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2138005508345845 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Undercover Operations Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::P0_DESKTOP_NAVIGATION,P1140_FILE_TYPE,P1140_TITLE:SUPPORT,FILE.GEN.UNDRCVROPSUPP,Support Files > Undercover Operations Files:',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'PLSQL_EXPRESSION',
  p_list_item_current_for_pages=> ':P1140_FILE_TYPE=''FILE.GEN.UNDRCVROPSUPP'' and :APP_PAGE_ID=''1140''',
  p_list_item_owner=> '');
 
null;
 
end;
/

COMMIT;
