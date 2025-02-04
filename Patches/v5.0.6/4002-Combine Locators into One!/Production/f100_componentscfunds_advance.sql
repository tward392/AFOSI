--application/shared_components/navigation/lists/cfunds_advance
 
begin
 
wwv_flow_api.create_list (
  p_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'CFUNDS_ADVANCE',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
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
  p_id=> 98063536707301651 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Issue Advance',
  p_list_item_link_target=> 'javascript:doSubmit(''ISSUE_ADVANCE'');',
  p_list_item_disp_cond_type=> 'NEVER',
  p_list_item_disp_condition=> ':P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98063817724301651 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Change Claimant',
  p_list_item_link_target=> 'javascript:popupLocator(350,''P30600_CLAIMANT_SID'',''N'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_SUBMITTED_ON is null and :P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98064124158301651 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>35,
  p_list_item_link_text=> 'Submit for Approval',
  p_list_item_link_target=> 'javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_SUBMITTED_ON is null and :P30600_SID is not null'||chr(10)||
'or'||chr(10)||
':P30600_STATUS = ''Disallowed''',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98064734478301653 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> 'Approve Advance',
  p_list_item_link_target=> 'javascript:doSubmit(''APPROVE_ADVANCE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_STATUS = ''Submitted''',
  p_list_item_disp_condition2=> '(:p30600_submitted_on is not null and '||chr(10)||
'    ((:p30600_approved_on is null) and'||chr(10)||
'     (:p30600_rejected_on is null))) and '||chr(10)||
':P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 98064414883301653 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> 'Reject Advance',
  p_list_item_link_target=> 'javascript:doSubmit(''REJECT_ADVANCE'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P30600_STATUS = ''Submitted''',
  p_list_item_disp_condition2=> '(:p30600_submitted_on is not null and '||chr(10)||
'    ((:p30600_approved_on is null) and'||chr(10)||
'     (:p30600_rejected_on is null))) and'||chr(10)||
':P30600_SID is not null',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2851325774049504 + wwv_flow_api.g_id_offset,
  p_list_id=> 98063018052301648 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>70,
  p_list_item_link_text=> 'Delete Advance',
  p_list_item_link_target=> 'javascript:deleteObj(''&P0_OBJ.'',''DELETE_OBJECT'');',
  p_list_item_disp_cond_type=> 'PLSQL_EXPRESSION',
  p_list_item_disp_condition=> ':P0_OBJ is not null'||chr(10)||
'',
  p_parent_list_item_id=> 98063232997301649 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
null;
 
end;
/

