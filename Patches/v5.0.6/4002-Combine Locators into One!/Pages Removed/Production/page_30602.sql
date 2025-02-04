--application/pages/page_30602
prompt  ...PAGE 30602: Efunds_test
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 30602,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Efunds_test',
  p_step_title=> 'cfunds_test',
  p_step_sub_title => 'cfunds_test',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110815134137',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '15-Aug-2011 - TJW - CR#3789 Change CFunds to EFunds.');
 
end;
 
end;
/

 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>97303437772260689 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30602,
  p_branch_action=> 'http://www.i2ms.com/oae/osi2one/iol_dev.cfunds_web.home_page',
  p_branch_point=> 'BEFORE_HEADER',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 05-AUG-2009 15:20 by MARK');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30602
--
 
begin
 
null;
end;
null;
 
end;
/

 
