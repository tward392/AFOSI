--application/shared_components/navigation/lists/cfunds_expense
 
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
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_ACTION_VISIBLE=''Y''',
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
 
wwv_flow_api.create_list_item (
  p_id=> 21825829061769470 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> 'View Disallowed Expense Comments',
  p_list_item_link_target=> 'javascript:popupCommentsWindow();',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_STATUS = ''Disallowed'''||chr(10)||
' and :P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5118719794111720 + wwv_flow_api.g_id_offset,
  p_list_id=> 97994415302351721 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>80,
  p_list_item_link_text=> 'Delete',
  p_list_item_link_target=> 'javascript:deleteObj(''&P30505_SID.'',''DELETE_OBJECT'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30505_SID is not null',
  p_parent_list_item_id=> 98012336210717312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
null;
 
end;
/

