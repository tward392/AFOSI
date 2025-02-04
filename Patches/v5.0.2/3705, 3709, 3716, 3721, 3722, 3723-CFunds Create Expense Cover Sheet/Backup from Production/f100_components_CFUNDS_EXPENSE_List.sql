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
--   Date and Time:   11:25 Wednesday March 2, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: CFUNDS_EXPENSE
--   Manifest End
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

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: LIST 97994415302351721
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'CFUNDS_EXPENSE',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Actions',
  p_list_item_link_target=> 'f?p=&APP_ID.:&APP_PAGEID.:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98007126010477798 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Create Expense Cover Sheet',
  p_list_item_link_target=> 'javascript:popupCoverSheet();',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_SID is not null '||chr(10)||
'and :P30505_STATUS in(''New'',''Submitted'',''Rejected'',''Disallowed'',''Approved'',''Paid'',''Repaid'',''Closed'')',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98007316790484610 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Change Claimant',
  p_list_item_link_target=> 'javascript:popupLocator(350,''P30505_CLAIMANT'',''N'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> '(:P30505_STATUS = '''' OR :P30505_STATUS = ''New'')'||chr(10)||
'and :P30505_SID is not null '||chr(10)||
'and cfunds_test_cfp(''EXP_CRE_PROXY'','||chr(10)||
'                       :p0_obj_type_sid,'||chr(10)||
'                       core_context.personnel_sid,'||chr(10)||
'                       osi_personnel.get_current_unit(core_context.personnel_sid)) = ''Y''',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98003030849403492 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>35,
  p_list_item_link_text=> 'Submit for Approval',
  p_list_item_link_target=> 'javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> '(:P30505_STATUS = ''New'' OR :P30505_STATUS = ''Disallowed'')'||chr(10)||
' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98007537915490643 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Disallow Expense',
  p_list_item_link_target=> 'javascript:popupCommentsWindow();',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Submitted'' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98008933722536792 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> 'Approve Expense',
  p_list_item_link_target=> 'javascript:doSubmit(''APPROVE_EXPENSE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Submitted'' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99356936198930156 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> 'Fix Expense',
  p_list_item_link_target=> 'javascript:doSubmit(''FIX_EXPENSE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Rejected''',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
null;
 
end;
/

COMMIT;
