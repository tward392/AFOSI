--application/shared_components/navigation/lists/checklist_menu
 
begin
 
wwv_flow_api.create_list (
  p_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Checklist Menu',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 91660737835300040 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5,
  p_list_item_link_text=> 'Checklists',
  p_list_item_link_target=> '',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST1',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92835512064155112 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST1.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST1.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST1',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92840509831175153 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST2.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST2.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST2',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92840712256175906 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST3.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST3.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST3',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92840915026176668 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST4.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST4.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST4',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92841117796177540 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>50,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST5.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST5.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST5',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92841424376179357 + wwv_flow_api.g_id_offset,
  p_list_id=> 92835038528155110 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>60,
  p_list_item_link_text=> '&P0_LBL_CHECKLIST6.',
  p_list_item_link_target=> 'javascript:void(0);" onclick="javascript:runPopWin(''Checklist'',''&P0_OBJ.'',''&P0_SID_CHECKLIST6.''); return false;',
  p_list_item_disp_cond_type=> 'ITEM_IS_NOT_NULL',
  p_list_item_disp_condition=> 'P0_SID_CHECKLIST6',
  p_parent_list_item_id=> 92835238480155110 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
null;
 
end;
/

