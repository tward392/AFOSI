--application/shared_components/navigation/lists/desktop
 
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1000:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1010:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1020:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1030:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1030',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 6126203578140393 + wwv_flow_api.g_id_offset,
  p_list_id=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Work Hours',
  p_list_item_link_target=> 'f?p=&APP_ID.:1040:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1050:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1060:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1070:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1080:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1080',
  p_list_item_owner=> '');
 
null;
 
end;
/

--application/shared_components/navigation/lists/files
 
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1100:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1100',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91999615562667884 + wwv_flow_api.g_id_offset,
  p_list_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Investigative Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1110:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1110',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2089925380960679 + wwv_flow_api.g_id_offset,
  p_list_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Service Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1130:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1130',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2095001448001051 + wwv_flow_api.g_id_offset,
  p_list_id=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Support Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1140:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1140',
  p_list_item_owner=> '');
 
null;
 
end;
/

--application/shared_components/navigation/lists/investigative_files
 
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1200:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1200',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92216227439148201 + wwv_flow_api.g_id_offset,
  p_list_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Case Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1210:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1210',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92216410601152826 + wwv_flow_api.g_id_offset,
  p_list_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Developmental Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1220:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1220',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92216626531157387 + wwv_flow_api.g_id_offset,
  p_list_id=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Informational Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1230:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1230',
  p_list_item_owner=> '');
 
null;
 
end;
/

--application/shared_components/navigation/lists/management_files
 
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1320:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1340:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1350:&SESSION.::&DEBUG.::::',
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1360:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1360',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92373131509868521 + wwv_flow_api.g_id_offset,
  p_list_id=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>90,
  p_list_item_link_text=> 'Units',
  p_list_item_link_target=> 'f?p=&APP_ID.:1390:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1390',
  p_list_item_owner=> '');
 
null;
 
end;
/

--application/shared_components/navigation/lists/participants
 
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1600:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1600',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378032248897120 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Individuals',
  p_list_item_link_target=> 'f?p=&APP_ID.:1610:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1610',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378235365897989 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Companies',
  p_list_item_link_target=> 'f?p=&APP_ID.:1620:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1620',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378438482898956 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Organizations',
  p_list_item_link_target=> 'f?p=&APP_ID.:1630:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1630',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92378608830899828 + wwv_flow_api.g_id_offset,
  p_list_id=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Programs',
  p_list_item_link_target=> 'f?p=&APP_ID.:1640:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1640',
  p_list_item_owner=> '');
 
null;
 
end;
/

--application/shared_components/navigation/lists/service_files
 
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1400:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1400',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2110412810174643 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Analysis and Production Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1410:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1410',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5602421400237101 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'CSP Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1420:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1420',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2119430827255503 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'OSI Application Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1430:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1430',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2125814906326662 + wwv_flow_api.g_id_offset,
  p_list_id=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'PSO Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1440:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1440',
  p_list_item_owner=> '');
 
null;
 
end;
/

--application/shared_components/navigation/lists/support_files
 
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
  p_list_item_link_target=> 'f?p=&APP_ID.:1500:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1500',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5616505694298873 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Criminal Polygraph Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1510:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1510',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2137616805339689 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>20,
  p_list_item_link_text=> 'Tech Surveillance Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1520:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1520',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2137827194342682 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>30,
  p_list_item_link_text=> 'Source Development Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1530:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1530',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2138005508345845 + wwv_flow_api.g_id_offset,
  p_list_id=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>40,
  p_list_item_link_text=> 'Undercover Operations Files',
  p_list_item_link_target=> 'f?p=&APP_ID.:1540:&SESSION.::&DEBUG.::::',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_current_for_pages=> '1540',
  p_list_item_owner=> '');
 
null;
 
end;
/

