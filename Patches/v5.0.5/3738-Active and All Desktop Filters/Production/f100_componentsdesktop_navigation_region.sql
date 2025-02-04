--application/shared_components/user_interface/templates/region/desktop_navigation_region
prompt  ......region template 92059616840235631
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table id="dtMenu#REGION_ID#" class="dtNavRegion">'||chr(10)||
'  <thead id="dtNavHeader#REGION_ID#">'||chr(10)||
'    <tr>'||chr(10)||
'      <td class="dtNavHeader" onclick="dtHideExcept(''dtNavBody#REGION_ID#'')">#TITLE#</td>'||chr(10)||
'    </tr>'||chr(10)||
'  </thead>'||chr(10)||
'  <tbody id="dtNavBody#REGION_ID#">'||chr(10)||
'    <tr id="dtNavBody"></tr>'||chr(10)||
'    <tr><td>#BODY#</td></tr>'||chr(10)||
'  </tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 92059616840235631 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Desktop Navigation Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 101,
  p_theme_class_id => 5,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 92059616840235631 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

