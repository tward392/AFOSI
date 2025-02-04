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
--   Date and Time:   10:32 Tuesday November 8, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Actions
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
 
 
prompt Component Export: LIST 92826724656999729
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Actions',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'Actions',
  p_list_item_link_target=> '',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2520728589513384 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6,
  p_list_item_link_text=> 'Check DEERS',
  p_list_item_link_target=> 'javascript:checkDeers(''&P0_OBJ.'');" onclick="javascript:runDirtyTest(''Action''); return !(checkDirty());',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':p0_obj_type_code = ''PART.INDIV'' and'||chr(10)||
'(:p0_obj_context is null or'||chr(10)||
' :p0_obj_context = osi_participant.get_current_version(:p0_obj))',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 100181419940409692 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7,
  p_list_item_link_text=> 'Delete',
  p_list_item_link_target=> 'javascript:deleteObj(''&P0_OBJ.'',''DELETE_OBJECT'');',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_OBJ',
  p_list_item_disp_condition2=> 'javascript:doSubmit(''DELETE_OBJECT'');',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2720026837350801 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7.1,
  p_list_item_link_text=> 'Generate Narrative',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:showPopWin(''f?p=&APP_ID.:22010:&SESSION.::&DEBUG.:22010:::'',600,600,null);return false;',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':p0_obj_type_code = ''ACT.INIT_NOTIF''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827224358027970 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS1.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS1.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS1',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827538210031946 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS2.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS2.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS2',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827710983033635 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS3.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS3.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS3',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92827914792034698 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS4.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS4.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS4',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92834125022151189 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS5.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS5.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS5',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92834327793151960 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS6.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS6.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS6',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5681128439478298 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> '&P0_LBL_CHANGE_STATUS7.',
  p_list_item_link_target=> 'javascript:void(0)" onclick="javascript:runPopWin(''Status'',''&P0_OBJ.'',''&P0_SID_CHANGE_STATUS7.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHANGE_STATUS7',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 16340017748308654 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>80,
  p_list_item_link_text=> 'Masking',
  p_list_item_link_target=> 'javascript:newWindow({page:760,clear_cache:''760'',name:''&P0_OBJ._MASK'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P760_OBJ'',item_values:''&P0_OBJ.,,&P0_OBJ.'',request:''MASK''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE in (''ACT.INTERVIEW.WITNESS'',''ACT.SOURCE_MEET'',''ACT.SURVEILLANCE'')',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 17869823711799476 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>90,
  p_list_item_link_text=> 'Duplicate Legacy I2MS Source Search',
  p_list_item_link_target=> 'javascript:newWindow({page:11330,clear_cache:''11330'',name:''&P0_OBJ._SRCSRCH'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P11330_OBJ'',item_values:''&P0_OBJ.,,&P0_OBJ.'',request:''SRCH''})',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE = ''FILE.SOURCE''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 22212726543600706 + wwv_flow_api.g_id_offset,
  p_list_id=> 92826724656999729 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>100,
  p_list_item_link_text=> 'Legacy I2MS Relationship Search',
  p_list_item_link_target=> 'javascript:importRelations(''&P0_OBJ.'',''IMPORT_RELATIONS'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ_TYPE_CODE like (''PART.%'') and osi_participant.get_imp_relations_flag(:P0_OBJ) = ''N''',
  p_parent_list_item_id=> 92829506397051181 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
null;
 
end;
/

COMMIT;
