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
--   Date and Time:   09:58 Thursday November 29, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
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

PROMPT ...Remove page 1005
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1005);
 
end;
/

 
--application/pages/page_01005
prompt  ...PAGE 1005: Desktop
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"STYLE_FORMLAYOUT_100%"'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function getSetting(pSettingName, pDefaultValue)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=GET_OR_SET_USER_SETTING'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',''GET'');'||chr(10)||
' get.addParam(''x02'',''&USER_SID.'');'||chr(10)||
' get.addParam(''x03'',pSettingName);'||chr(10)||
' g';

ph:=ph||'et.addParam(''x04'',pDefaultValue);'||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function setSetting(pSettingName, pValue)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=GET_OR_SET_USER_SETTING'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',''SET'');'||chr(10)||
' get.addParam(''x02'',''&USER_SID.'');'||chr(10)||
' get.addParam(''x';

ph:=ph||'03'',pSettingName);'||chr(10)||
' get.addParam(''x04'',pValue);'||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function () '||chr(10)||
'{'||chr(10)||
' var tempSetting;'||chr(10)||
''||chr(10)||
' $( "#menuSetup" ).menu();'||chr(10)||
''||chr(10)||
' $("#menuSetup").mouseleave(function(e)'||chr(10)||
'  {'||chr(10)||
'   $(''#menuSetup'').fadeOut(''slow'');'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' $("#searchSetupButton").click(function(e)'||chr(10)||
'  {'||chr(10)||
'   searchSetupButton(e.pageX, e.pageY)'||chr(10)||
'  }); '||chr(10)||
''||chr(10)||
' tempSetting = getSetting(''P1005_SEARCH_F';

ph:=ph||'ILES'',''Y'');'||chr(10)||
' $(''#iconFiles'').removeClass(''ui-icon ui-icon-check'');'||chr(10)||
' $(''#iconFiles'').addClass(tempSetting==''Y'' ? ''ui-icon ui-icon-check'' : '''');'||chr(10)||
' $(''#P1005_SEARCH_FILES'').val(tempSetting==''Y'' ? ''ui-icon ui-icon-check'' : '''')'||chr(10)||
''||chr(10)||
' tempSetting = getSetting(''P1005_SEARCH_ACT'',''Y''); '||chr(10)||
' $(''#iconActivities'').removeClass(''ui-icon ui-icon-check'');'||chr(10)||
' $(''#iconActivities'').addClass(tempSetting==''Y'' ? ''ui-icon ui-ico';

ph:=ph||'n-check'' : '''');'||chr(10)||
' $(''#P1005_SEARCH_ACTIVITIES'').val(tempSetting==''Y'' ? ''ui-icon ui-icon-check'' : '''')'||chr(10)||
''||chr(10)||
' tempSetting = getSetting(''P1005_SEARCH_PART'',''Y''); '||chr(10)||
' $(''#iconParticipants'').removeClass(''ui-icon ui-icon-check'');'||chr(10)||
' $(''#iconParticipants'').addClass(tempSetting==''Y'' ? ''ui-icon ui-icon-check'' : '''');'||chr(10)||
' $(''#P1005_SEARCH_PARTICIPANTS'').val(tempSetting==''Y'' ? ''ui-icon ui-icon-check'' : '''')'||chr(10)||
''||chr(10)||
' tempSetting =';

ph:=ph||' getSetting(''P1005_SEARCH_ATTACH'',''NONE''); '||chr(10)||
' $(''#iconAttach'').removeClass(''ui-icon ui-icon-check'');'||chr(10)||
' $(''#iconAttach'').addClass(tempSetting==''INCLUDE'' ? ''ui-icon ui-icon-check'' : '''');'||chr(10)||
' $(''#P1005_SEARCH_ATTACH'').val(tempSetting==''INCLUDE'' ? ''ui-icon ui-icon-check'' : '''')'||chr(10)||
' $(''#iconOnlyAttach'').removeClass(''ui-icon ui-icon-check'');'||chr(10)||
' $(''#iconOnlyAttach'').addClass(tempSetting==''ONLY'' ? ''ui-icon ui-icon-c';

ph:=ph||'heck'' : '''');'||chr(10)||
' $(''#P1005_SEARCH_ONLYATTACH'').val(tempSetting==''ONLY'' ? ''ui-icon ui-icon-check'' : '''')'||chr(10)||
'});'||chr(10)||
''||chr(10)||
'function gotoLink(pageNumber, title)'||chr(10)||
'{'||chr(10)||
' var url;'||chr(10)||
' var tempSetting;'||chr(10)||
''||chr(10)||
' $(''.desktopSidebarTableCol'', window.parent.document).removeClass(''desktopSidebarTableColSelected'');'||chr(10)||
' '||chr(10)||
' switch(pageNumber)'||chr(10)||
'       {'||chr(10)||
'        case ''1010'':'||chr(10)||
'                    $(''#desktopActivities'', window.parent.document).addCla';

ph:=ph||'ss(''desktopSidebarTableColSelected'');'||chr(10)||
'                    break;'||chr(10)||
'        case ''1020'':'||chr(10)||
'                    $(''#desktopFiles'', window.parent.document).addClass(''desktopSidebarTableColSelected'');'||chr(10)||
'                    break;'||chr(10)||
'        case ''1050'':'||chr(10)||
'                    $(''#desktopNotifications'', window.parent.document).addClass(''desktopSidebarTableColSelected'');'||chr(10)||
'                    break;'||chr(10)||
'        case ''108';

ph:=ph||'0'':'||chr(10)||
'                    $(''#desktopFullTextSearch'', window.parent.document).addClass(''desktopSidebarTableColSelected'');'||chr(10)||
'                    var searchString = $(''#searchString'').attr(''value'');'||chr(10)||
''||chr(10)||
'                    var otherVars = '',P1080_AUTO_SEARCH_OBJECT,P1080_AUTO_SEARCH_ATTACH'';'||chr(10)||
''||chr(10)||
'                    var otherVals = '','';'||chr(10)||
''||chr(10)||
'                    otherVals = $(''#P1005_SEARCH_FILES'').val()!='''' ? othe';

ph:=ph||'rVals + ''FILES'' : otherVals;'||chr(10)||
'                    otherVals = $(''#P1005_SEARCH_ACTIVITIES'').val()!='''' ? otherVals + ''ACT'' : otherVals;'||chr(10)||
'                    otherVals = $(''#P1005_SEARCH_PARTICIPANTS'').val()!='''' ? otherVals + ''PART'' : otherVals;'||chr(10)||
''||chr(10)||
'                    if($(''#P1005_SEARCH_ATTACH'').val()!='''')'||chr(10)||
'                      otherVals = otherVals+'',INCLUDE'';'||chr(10)||
'                    else if($(''#P1005_SEA';

ph:=ph||'RCH_ONLYATTACH'').val()!='''')'||chr(10)||
'                           otherVals = otherVals+'',ONLY'';'||chr(10)||
'                    else'||chr(10)||
'                      otherVals = otherVals+'',NONE'';'||chr(10)||
''||chr(10)||
'                    if(searchString=='''')'||chr(10)||
'                      url = ''f?p=&APP_ID.:1080:&SESSION.::&DEBUG.::P1080_AUTO_SEARCH''+otherVars+'':N''+otherVals;'||chr(10)||
'                    else'||chr(10)||
'                      {'||chr(10)||
'                       url = ''f?p';

ph:=ph||'=&APP_ID.:1080:&SESSION.::&DEBUG.::P1080_SEARCH,P1080_AUTO_SEARCH''+otherVars+'':\\''+$(''#searchString'').attr(''value'')+''\\,Y''+otherVals;'||chr(10)||
''||chr(10)||
'                       setSetting(''P1005_SEARCH_FILES'',$(''#iconFiles'').attr(''class'')==''ui-icon ui-icon-check'' ? ''Y'' : ''N'');'||chr(10)||
'                       setSetting(''P1005_SEARCH_ACT'',$(''#iconActivities'').attr(''class'')==''ui-icon ui-icon-check'' ? ''Y'' : ''N'');'||chr(10)||
'              ';

ph:=ph||'         setSetting(''P1005_SEARCH_PART'',$(''#iconParticipants'').attr(''class'')==''ui-icon ui-icon-check'' ? ''Y'' : ''N'');'||chr(10)||
''||chr(10)||
'                       tempSetting = ''NONE'';'||chr(10)||
'                       tempSetting = ($(''#iconAttach'').attr(''class'')==''ui-icon ui-icon-check'' ? ''INCLUDE'' : tempSetting);'||chr(10)||
'                       tempSetting = ($(''#iconOnlyAttach'').attr(''class'')==''ui-icon ui-icon-check'' ? ''ONLY'' : tempSet';

ph:=ph||'ting);'||chr(10)||
'                       setSetting(''P1005_SEARCH_ATTACH'',tempSetting);'||chr(10)||
'                      }'||chr(10)||
'                    break;'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
' if(pageNumber!=''1080'')'||chr(10)||
'   {'||chr(10)||
'    if(typeof title === "undefined")'||chr(10)||
'      url = ''f?p=&APP_ID.:''+pageNumber+'':&SESSION.::&DEBUG.:::'';'||chr(10)||
'    else'||chr(10)||
'      url = ''f?p=&APP_ID.:''+pageNumber+'':&SESSION.::&DEBUG.::P''+pageNumber+''_TITLE:''+title;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' location.href=url;'||chr(10)||
' ret';

ph:=ph||'urn false;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function CheckForEnter(e)'||chr(10)||
'{'||chr(10)||
' if (e.keyCode == 13)'||chr(10)||
'   {'||chr(10)||
'    e.keyCode=0;'||chr(10)||
'    gotoLink(''1080'');'||chr(10)||
'    return false;'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'function setupClick(pThis)'||chr(10)||
'{'||chr(10)||
' var field = $(pThis).attr("id");'||chr(10)||
' var fieldValue = $(''#P1005_SEARCH_''+field.toUpperCase()).val();'||chr(10)||
' '||chr(10)||
' if(field==''Search'')'||chr(10)||
'   gotoLink(''1080'');'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    if(fieldValue == '''')'||chr(10)||
'      fieldValue = ''ui-icon ui-icon-check'';'||chr(10)||
'    else'||chr(10)||
'      ';

ph:=ph||'fieldValue = '''';'||chr(10)||
''||chr(10)||
'    $(''#P1005_SEARCH_''+field.toUpperCase()).val(fieldValue);'||chr(10)||
''||chr(10)||
'    $(''#icon''+field).removeClass(''ui-icon ui-icon-check'');'||chr(10)||
''||chr(10)||
'    $(''#icon''+field).addClass(fieldValue);'||chr(10)||
''||chr(10)||
'    if(field==''Attach'' && fieldValue==''ui-icon ui-icon-check'')'||chr(10)||
'      {'||chr(10)||
'       $(''#iconOnlyAttach'').removeClass(''ui-icon ui-icon-check'');'||chr(10)||
'       $(''#P1005_SEARCH_ONLYATTACH'').val('''');'||chr(10)||
'      }'||chr(10)||
'    else if(field==''OnlyA';

ph:=ph||'ttach'' && fieldValue==''ui-icon ui-icon-check'')'||chr(10)||
'           {'||chr(10)||
'            $(''#iconAttach'').removeClass(''ui-icon ui-icon-check'');'||chr(10)||
'            $(''#P1005_SEARCH_ATTACH'').val('''');'||chr(10)||
'           }'||chr(10)||
'    }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function searchSetupButton(mouseX, mouseY)'||chr(10)||
'{'||chr(10)||
' $(''#menuSetup'').css({''top'':mouseY,''left'':mouseX}).fadeIn(''slow'');'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'<style>'||chr(10)||
'table'||chr(10)||
'{'||chr(10)||
' border-collapse:collapse;'||chr(10)||
'}'||chr(10)||
'a'||chr(10)||
'{'||chr(10)||
' text-decoration:none;'||chr(10)||
'}'||chr(10)||
'label'||chr(10)||
'';

ph:=ph||'{'||chr(10)||
' font-weight: bold; '||chr(10)||
' font-size:medium;'||chr(10)||
'}'||chr(10)||
'.linkLabel'||chr(10)||
'{'||chr(10)||
' padding: 0 0 0 10px;'||chr(10)||
'}'||chr(10)||
'.linkImage'||chr(10)||
'{'||chr(10)||
' padding: 5px;'||chr(10)||
' background-color:#fff;'||chr(10)||
' border-width:1px;'||chr(10)||
' border-style:solid;'||chr(10)||
' border-bottom-color:#aaa;'||chr(10)||
' border-right-color:#aaa;'||chr(10)||
' border-top-color:#ddd;'||chr(10)||
' border-left-color:#ddd;'||chr(10)||
' border-radius:3px;'||chr(10)||
' -moz-border-radius:3px;'||chr(10)||
' -webkit-border-radius:3px;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.menuSep'||chr(10)||
'{'||chr(10)||
' padding: 5px;'||chr(10)||
' background-color:#fff;';

ph:=ph||''||chr(10)||
' border-width:1px;'||chr(10)||
' border-style:solid;'||chr(10)||
' border-bottom-color:#fff;'||chr(10)||
' border-right-color:#fff;'||chr(10)||
' border-top-color:#ddd;'||chr(10)||
' border-left-color:#fff;'||chr(10)||
' border-radius:3px;'||chr(10)||
' -moz-border-radius:3px;'||chr(10)||
' -webkit-border-radius:3px;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'</style>'||chr(10)||
'<ul id="menuSetup" style="display:none; width:170px;  position:absolute">'||chr(10)||
' <li><a id="Files" href="#" onClick="setupClick(this);"><span id="iconFiles" class="ui-icon ui-ico';

ph:=ph||'n-check"></span>Search for Files</a></li>'||chr(10)||
' <li><a id="Activities" href="#" onClick="setupClick(this);"><span id="iconActivities" class="ui-icon ui-icon-check"></span>Search for Activities</a></li>'||chr(10)||
' <li><a id="Participants" href="#" onClick="setupClick(this);"><span id="iconParticipants" class="ui-icon ui-icon-check"></span>Search for Participants</a></li>'||chr(10)||
' <li class="menuSep"><a  id="Attach" href=';

ph:=ph||'"#" onClick="setupClick(this);"><span id="iconAttach"></span>Include Attachments</a></li>'||chr(10)||
' <li><a id="OnlyAttach" href="#" onClick="setupClick(this);"><span id="iconOnlyAttach"></span>Only Attachments</a></li>'||chr(10)||
' <li class="menuSep"><a id="Search" href="#" onClick="setupClick(this);"><span id="iconSearch" class="ui-icon ui-icon-search"></span>Search</a></li>'||chr(10)||
'</ul>';

wwv_flow_api.create_page(
  p_id     => 1005,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop',
  p_step_title=> 'Desktop',
  p_step_sub_title => 'Desktop',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 17253320452445049+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121129075941',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '01-Apr-2011 - TJW - CR#3688 - Notifications Link on Desktop doesn''t have count.'||chr(10)||
''||chr(10)||
'30-Mar-2012 - TJW - CR#3738 - Active and All Desktop Filters.'||chr(10)||
'                               Changed all the links to pass the Navigation and'||chr(10)||
'                               the Files Link to pass a Title.'||chr(10)||
''||chr(10)||
'01-Nov-2012 - TJW - CR#0000 - Copied from 1000 to 1005.  The new page 1000 has '||chr(10)||
'                               a splitter to allow this page desktop pages like'||chr(10)||
'                               this one to display in an iframe now.'||chr(10)||
'29-Nov-2012 - TJW - Changed Setup Menu Width from 160px to 200px as Search for '||chr(10)||
'                     Participants was wrapping.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1005,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 17268408728886249 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1005,
  p_plug_name=> 'I2MS Desktop',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17268622581886252 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_OP_ACTIVITIES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 26,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select count(distinct at.sid)'||chr(10)||
'  from t_osi_assignment a, t_osi_activity at'||chr(10)||
' where a.personnel = core_context.personnel_sid'||chr(10)||
'   and a.end_date is null'||chr(10)||
'   and a.obj = at.sid'||chr(10)||
'   and osi_object.get_status_code(at.sid) <> ''CL'';',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17268824931886252 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_OP_FILES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 27,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select count(distinct f.sid)'||chr(10)||
'  from t_osi_assignment a, t_osi_file f'||chr(10)||
' where a.personnel = core_context.personnel_sid'||chr(10)||
'   and a.end_date is null'||chr(10)||
'   and a.obj = f.sid'||chr(10)||
'   and nvl(osi_status.last_sh_date(f.sid, ''CL''), to_date(''01-Jan-1900'')) <'||chr(10)||
'                                   nvl(osi_status.last_sh_date(f.sid, ''OP''), to_date(''01-Jan-1901''));',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17269008783886252 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_OP_NOTIFICIATIONS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 28,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select count(sid)'||chr(10)||
'  from t_osi_notification'||chr(10)||
' where recipient = core_context.personnel_sid;',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17269219802886252 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_BADGE_IMG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'&IMG_BADGE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'width="100"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 3,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17269422611886252 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_WELCOME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 31,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<table><tr><td><label style="font-weight:bold;font-style:italic;font-size:xx-large">Welcome to the I2MS Desktop</label></td></tr><tr><td align="center"><label style="font-weight:bold;font-size:large">'' || core_context.personnel_name || ''</label></td></tr></table>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 5,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-CENTER',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17269819484886252 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_TODAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 29,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'TO_CHAR(SYSDATE, ''Month DD, YYYY'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="font-weight:bold; font-size:medium; float:right;  background-color: #000000; color:#FFFFFF; padding: 5px 100px 5px 5px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 10,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17343310424462226 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 33,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17360927448271435 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_LINKS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 43,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<table width="100%">'||chr(10)||
' <tr>'||chr(10)||
'  <td width="100"></td>'||chr(10)||
'  <td width="32"><a href="#" onClick="gotoLink(''1010'');"><img class="linkImage" alt="Desktop Activities" src="#IMAGE_PREFIX#themes/OSI/Default_Desktop_Activities.gif"></a></td>'||chr(10)||
'  <td class="linkLabel"><label>Activities</label><br>&P1005_OP_ACTIVITIES. open activities.</td >'||chr(10)||
'  <td width="32"><a href="#" onClick="gotoLink(''1020'',''Desktop > Files'');"><img class="linkImage" alt="Desktop Files" src="#IMAGE_PREFIX#themes/OSI/Default_Desktop_Files.gif"></a></td>'||chr(10)||
'  <td class="linkLabel"><label>Files</label><br>&P1005_OP_FILES. open files.</td >'||chr(10)||
' </tr>'||chr(10)||
' <tr><td colspan="5">&nbsp;</td></tr>'||chr(10)||
' <tr>'||chr(10)||
'  <td width="100"></td >'||chr(10)||
'  <td width="32"><a href="#" onClick="gotoLink(''1050'');"><img class="linkImage" alt="Desktop Notifications" src="#IMAGE_PREFIX#themes/OSI/Default_Desktop_Notifications.gif"></a></td>'||chr(10)||
'  <td class="linkLabel"><label>Notifications</label><br>&P1005_OP_NOTIFICIATIONS. current notifications.</td>'||chr(10)||
'  <td width="32"><a href="#" onClick="gotoLink(''1080'');"><img class="linkImage" alt="Desktop Full Text Search" src="#IMAGE_PREFIX#themes/OSI/Default_Desktop_FTS.gif"></a></td>'||chr(10)||
'  <td class="linkLabel"><label>Full Text Search</label><br><input id="searchString" height="16px" size="50" maxLength="100" type="text" onkeydown="javascript:CheckForEnter(event);" onkeyup="javascript:CheckForEnter(event);">&nbsp;<a href="#"><img id="searchSetupButton" class="linkImage" alt="Full Text Search Setup" src="#IMAGE_PREFIX#themes/OSI/SetupSmall.gif"></a></td>'||chr(10)||
' </tr>'||chr(10)||
'</table>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17411608566619942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_SEARCH_FILES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 53,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ui-icon ui-icon-check',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17411814454621624 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_SEARCH_ACTIVITIES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 63,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ui-icon ui-icon-check',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17412018956622934 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_SEARCH_PARTICIPANTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 73,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ui-icon ui-icon-check',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17412224496624605 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_SEARCH_ATTACH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 83,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17412429691626081 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1005,
  p_name=>'P1005_SEARCH_ONLYATTACH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 93,
  p_item_plug_id => 17268408728886249+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1005
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done
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
--   Date and Time:   09:59 Thursday November 29, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
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

PROMPT ...Remove page 1010
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1010);
 
end;
/

 
--application/pages/page_01010
prompt  ...PAGE 1010: Desktop Activities
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_DESKTOP_FILTERS_COL_REF"'||chr(10)||
'"JS_DESKTOP_GOTO_FIRST_PAGE"';

wwv_flow_api.create_page(
  p_id     => 1010,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Activities',
  p_step_title=> '&DESKTOP_TITLE.',
  p_step_sub_title => 'Desktop Activities',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 17253320452445049+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121128130923',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '06-Jan-2012 - Tim Ward - CR#3738 - All/Active Filter missing.  '||chr(10)||
'                         CR#3728 - Save Filter and rows values.'||chr(10)||
'                         CR#3742 - Save Filter and rows values.'||chr(10)||
'                         CR#3641 - Default Sort Order for Recent.'||chr(10)||
'                         CR#3635 - Last Accessed inconsistencies.'||chr(10)||
'                         CR#3563 - Default Desktop Views.'||chr(10)||
'                         CR#3446 - Implement speed improvements.'||chr(10)||
'                         CR#3447 - Implement speed improvements.'||chr(10)||
''||chr(10)||
'01-Nov-2012 - Tim Ward - CR#0000 - Changed Page Template to '||chr(10)||
'                                    "Desktop - Center Frame".'||chr(10)||
''||chr(10)||
'26-Nov-2012 - Tim Ward - CR#4165 - Added Ready for Review Field.'||chr(10)||
'28-Nov-2012 - Tim Ward - CR#4185 - Added Signed Form 40 Attached Field.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1010,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT C001,C002,C003,C004,C005,C006,C007,to_date(C008),to_date(C009),C010,C011,C012,C013,C014,to_date(C015),to_date(C016),C017,C018,C019'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 2079608043609376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_plug_name=> 'Desktop > Activities',
  p_region_name=>'',
  p_plug_template=> 92167138176750921+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''ACT''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'SELECT C001,C002,C003,C004,C005,C006,C007,to_date(C008),to_date(C009),C010,C011,C012,C013,C014,to_date(C015),to_date(C016),C017,C018,C019'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';'||chr(10)||
'';

wwv_flow_api.create_worksheet(
  p_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1010,
  p_region_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_name => 'Desktop > C-Funds Expenses',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Activities found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => '',
  p_sort_asc_image       => '',
  p_sort_asc_image_attr  => '',
  p_sort_desc_image      => '',
  p_sort_desc_image_attr => '',
  p_sql_query => a1,
  p_status                    =>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving       =>'Y',
  p_allow_report_categories   =>'N',
  p_show_nulls_as             =>'-',
  p_pagination_type           =>'ROWS_X_TO_Y_OF_Z',
  p_pagination_display_pos    =>'BOTTOM_RIGHT',
  p_show_finder_drop_down     =>'Y',
  p_show_display_row_count    =>'Y',
  p_show_search_bar           =>'Y',
  p_show_search_textbox       =>'Y',
  p_show_actions_menu         =>'Y',
  p_report_list_mode          =>'TABS',
  p_show_detail_link          =>'C',
  p_show_select_columns       =>'Y',
  p_show_filter               =>'Y',
  p_show_sort                 =>'Y',
  p_show_control_break        =>'Y',
  p_show_highlight            =>'Y',
  p_show_computation          =>'N',
  p_show_aggregate            =>'N',
  p_show_chart                =>'N',
  p_show_calendar             =>'N',
  p_show_flashback            =>'N',
  p_show_reset                =>'N',
  p_show_download             =>'Y',
  p_show_help            =>'Y',
  p_download_formats          =>'CSV',
  p_download_filename         =>'&P1010_EXPORT_NAME.',
  p_detail_link              =>'#C001#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2082918883609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C001',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Url',
  p_report_label           =>'Url',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'HIDDEN',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083021220609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C002',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'ID',
  p_report_label           =>'ID',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083107607609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C003',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Activity Type',
  p_report_label           =>'Activity Type',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083220544609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C004',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Title',
  p_report_label           =>'Title',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083300436609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C005',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Lead Agent',
  p_report_label           =>'Lead Agent',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083418479609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C006',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Status',
  p_report_label           =>'Status',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083500251609406+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C007',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Controlling Unit',
  p_report_label           =>'Controlling Unit',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4860719320336770+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C008)',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Created On',
  p_report_label           =>'Created On',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4860827413336770+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C009)',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
  p_column_label           =>'Last Accessed',
  p_report_label           =>'Last Accessed',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE TO_DATE(C009) IS NOT NULL AND COLLECTION_NAME=''P1010_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083806261609406+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C010',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
  p_column_label           =>'Times Accessed',
  p_report_label           =>'Times Accessed',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C010 IS NOT NULL AND COLLECTION_NAME=''P1010_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083916281609406+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C011',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
  p_column_label           =>'Ranking',
  p_report_label           =>'Ranking',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C011 IS NOT NULL AND COLLECTION_NAME=''P1010_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4861722531394450+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C012',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'            ',
  p_report_label           =>'            ',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'#C012#',
  p_column_linktext        =>'&ICON_VLT.',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4861801281394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C013',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Q',
  p_column_label           =>'Created By',
  p_report_label           =>'Created By',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4861914834394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C014',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'R',
  p_column_label           =>'Is A Lead',
  p_report_label           =>'Is A Lead',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4862022500394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C015)',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'S',
  p_column_label           =>'Date Completed',
  p_report_label           =>'Date Completed',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4862101691394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C016)',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'T',
  p_column_label           =>'Suspense Date',
  p_report_label           =>'Suspense Date',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 16448214345311852+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C017',
  p_display_order          =>17,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'U',
  p_column_label           =>'Approved',
  p_report_label           =>'Approved',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 17778824362211297+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C018',
  p_display_order          =>18,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'V',
  p_column_label           =>'Ready for Review',
  p_report_label           =>'Ready for Review',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 17819922623598038+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C019',
  p_display_order          =>19,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'W',
  p_column_label           =>'Signed Form 40 Attached',
  p_report_label           =>'Signed Form 40 Attached',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 2085323540609409+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>25,
  p_report_columns          =>'C002:C003:C004:C005:C006:C007:TO_DATE(C008):TO_DATE(C009):C010:C011:C012',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'You do not have access privileges for this folder.'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 6183225704261979 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_plug_name=> 'Access Restricted',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''ACT''))=''N''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15191624248639839 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1010,
  p_button_sequence=> 10,
  p_button_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:getIRCSV(null, this, 1010);',
  p_button_cattributes=>'onClick="getIRCSV(null, this, 1010);"',
  p_button_comment=>'javascript:void(0);',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>6208415117295842 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_branch_action=> 'f?p=&APP_ID.:1010:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 22-FEB-2010 10:35 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6207731262291012 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER',
  p_lov => '.'||to_char(6129207658248740 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8788006742945022 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_ACTIVE_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER_ACTIVE',
  p_lov => '.'||to_char(8788412414956145 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8819808179336167 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_NUM_ROWS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Num Rows',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>10349213755153079 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_OBJECT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'ACT',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15442907538685931 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 8826509189459484 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_computation_sequence => 10,
  p_computation_item=> 'P1010_NUM_ROWS',
  p_computation_point=> 'BEFORE_BOX_BODY',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                               ''P'' || :APP_PAGE_ID || ''_NUM_ROWS.'' || ''ACT'','||chr(10)||
'                               ''25'');'||chr(10)||
'',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 6207904728292859 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_computation_sequence => 10,
  p_computation_item=> 'P1010_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1010_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 8793829242576054 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_computation_sequence => 20,
  p_computation_item=> 'P1010_ACTIVE_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'ACTIVE',
  p_compute_when => 'P1010_ACTIVE_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'   :P1010_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                   ''P'' || :APP_PAGE_ID || ''_FILTER.'' || ''ACT'','||chr(10)||
'                                                   ''RECENT'');'||chr(10)||
''||chr(10)||
'   :P1010_ACTIVE_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                          ''P'' || :APP_PAGE_ID || ''_ACTIVE_FILTER.'' || ''AC';

p:=p||'T'','||chr(10)||
'                                                          ''ACTIVE'');'||chr(10)||
''||chr(10)||
'End;';

wwv_flow_api.create_page_process(
  p_id     => 2079310683600681 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1010,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP FILTERS DEFAULT',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'/* OLD'||chr(10)||
'   if apex_collection.collection_exists'||chr(10)||
'     (p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'') then'||chr(10)||
'    '||chr(10)||
'     apex_collection.delete_collection'||chr(10)||
'         (p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'');'||chr(10)||
'  '||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'  APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY_B('||chr(10)||
'       p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'','||chr(10)||
'       p_query => OSI_DESKTOP.DesktopSQL(:P1010_FILTER, '||chr(10)||
'                                         :user_sid, '||chr(10)||
'                                         ''ACT'','||chr(10)||
'                                         '''', '||chr(10)||
'                                         :P1010_ACTIVE_FILTER,'||chr(10)||
'                                         :P1010_NUM_ROWS,'||chr(10)||
'                                         ''P'','||chr(10)||
'                                         '''','||chr(10)||
'                                         :APXWS_MAX_ROW_CNT));'||chr(10)||
'*/');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1010
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done
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
--   Date and Time:   10:26 Wednesday January 9, 2013
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
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

PROMPT ...Remove page 5100
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>5100);
 
end;
/

 
--application/pages/page_05100
prompt  ...PAGE 5100: Attachments
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript1.1" type="text/javascript">'||chr(10)||
''||chr(10)||
'    function SetDescription()'||chr(10)||
'    {'||chr(10)||
'     var pathname = $v(''P5100_SOURCE_DISPLAY1'');'||chr(10)||
''||chr(10)||
'     var filename = '||chr(10)||
'        pathname.substr(pathname.lastIndexOf("\\")+1,pathname.length)'||chr(10)||
''||chr(10)||
'     var ext ='||chr(10)||
'        filename.substr(filename.lastIndexOf("."),filename.length)'||chr(10)||
'     '||chr(10)||
'     if ($v(''P5100_LOCATION'')==''DB'' || $v(''P5100_LOCATION'')==''FILE'')'||chr(10)||
'       ';

ph:=ph||'{'||chr(10)||
'        if (filename==ext)'||chr(10)||
'          $s(''P5100_DESCRIPTION'',filename);'||chr(10)||
'        else'||chr(10)||
'          $s(''P5100_DESCRIPTION'',filename.replace(ext,""));'||chr(10)||
''||chr(10)||
'        $s(''P5100_LAST_FILE_PICKED'',pathname);'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
'    function CheckDescription()'||chr(10)||
'    {'||chr(10)||
'     if ($v(''P5100_LOCATION'')==''DB'' || $v(''P5100_LOCATION'')==''FILE'')'||chr(10)||
'       {'||chr(10)||
'        if (!$v_IsEmpty(''P5100_SOURCE_DISPLAY1''))'||chr(10)||
'          {'||chr(10)||
'           i';

ph:=ph||'f ($v_IsEmpty(''P5100_DESCRIPTION''))'||chr(10)||
'             {'||chr(10)||
'              alert("Description is required.");'||chr(10)||
'              //$f_First_field(''P5100_DESCRIPTION'');'||chr(10)||
'              //return false;'||chr(10)||
'              SetDescription();'||chr(10)||
'              return true;'||chr(10)||
'             }'||chr(10)||
'          }'||chr(10)||
'       }'||chr(10)||
'     return true;'||chr(10)||
'    }'||chr(10)||
' '||chr(10)||
'    function ReleaseCheck()'||chr(10)||
'    {'||chr(10)||
'     return true;'||chr(10)||
'    }'||chr(10)||
''||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"'||chr(10)||
''||chr(10)||
'<';

ph:=ph||'!-- jQuery SWFUpload Code -->'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jquery/jquery-swfupload/js/swfupload/swfupload.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jquery/jquery-swfupload/js/jquery.swfupload.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jquery/js/jquery.jqplugin.1.0.2.min.js"></script>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
''||chr(10)||
'$(function(){'||chr(10)||
'	$(''';

ph:=ph||'#swfupload-control'').swfupload({'||chr(10)||
'                upload_url: "#IMAGE_PREFIX#jquery/jquery-swfupload/upload-file.php",'||chr(10)||
'                file_post_name: ''uploadfile'','||chr(10)||
'                file_size_limit : "15360",'||chr(10)||
'                file_types : "*.*",'||chr(10)||
'                file_types_description : "All files",'||chr(10)||
'                file_upload_limit : 10,'||chr(10)||
'                flash_url : "#IMAGE_PREFIX#jquery/jquery-swfupl';

ph:=ph||'oad/js/swfupload/swfupload.swf",'||chr(10)||
'                button_image_url : ''#IMAGE_PREFIX#jquery/jquery-swfupload/js/swfupload/SelectFilesButton.png'','||chr(10)||
'                button_width : 110,'||chr(10)||
'                button_height : 22,'||chr(10)||
'                button_placeholder : $(''#button'')[0],'||chr(10)||
'                debug: false'||chr(10)||
'	})'||chr(10)||
'		.bind(''fileQueued'', function(event, file){'||chr(10)||
'			var listitem=''<li id="''+file.id+''" >''+'||chr(10)||
'				''File:';

ph:=ph||' <em>''+file.name+''</em> (''+Math.round(file.size/1024)+'' KB) <span class="progressvalue" ></span>''+'||chr(10)||
'				''<div class="progressbar" ><div class="progress" ></div></div>''+'||chr(10)||
'				''<p class="status" >Pending</p>''+'||chr(10)||
'				''<span class="cancel" >&nbsp;</span>''+'||chr(10)||
'				''</li>'';'||chr(10)||
'			$(''#log'').append(listitem);'||chr(10)||
'			$(''li#''+file.id+'' .cancel'').bind(''click'', function(){'||chr(10)||
'				var swfu = $.swfupload.getInstance(''#swfupload';

ph:=ph||'-control'');'||chr(10)||
'				swfu.cancelUpload(file.id);'||chr(10)||
'				$(''li#''+file.id).slideUp(''fast'');'||chr(10)||
'			});'||chr(10)||
''||chr(10)||
'			// start the upload since it''s queued'||chr(10)||
'			$(this).swfupload(''startUpload'');'||chr(10)||
'		})'||chr(10)||
'		.bind(''fileQueueError'', function(event, file, errorCode, message)'||chr(10)||
'                     {'||chr(10)||
'                      if(errorCode==-100)'||chr(10)||
'                        alert(''You are allowed to upload ''+message+'' files at a time.'');'||chr(10)||
'     ';

ph:=ph||'                 else'||chr(10)||
'			alert(''Size of the file ''+file.name+'' is greater than 15MB limit'');'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''fileDialogComplete'', function(event, numFilesSelected, numFilesQueued){'||chr(10)||
'			$(''#queuestatus'').text(''Files Selected: ''+numFilesSelected+'' / Queued Files: ''+numFilesQueued);'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadStart'', function(event, file){'||chr(10)||
''||chr(10)||
'                        var param = {''actualfilename'' : ''&USER_SID.''';

ph:=ph||'+file.name};'||chr(10)||
'                        $(this).swfupload(''setPostParams'', param);'||chr(10)||
''||chr(10)||
'			$(''#log li#''+file.id).find(''p.status'').text(''Uploading...'');'||chr(10)||
'			$(''#log li#''+file.id).find(''span.progressvalue'').text(''0%'');'||chr(10)||
'			$(''#log li#''+file.id).find(''span.cancel'').hide();'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadProgress'', function(event, file, bytesLoaded){'||chr(10)||
'			//Show Progress'||chr(10)||
'			var percentage=Math.round((bytesLoaded/file.size';

ph:=ph||')*100);'||chr(10)||
'			$(''#log li#''+file.id).find(''div.progress'').css(''width'', percentage+''%'');'||chr(10)||
'			$(''#log li#''+file.id).find(''span.progressvalue'').text(percentage+''%'');'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadSuccess'', function(event, file, serverData){'||chr(10)||
'			var item=$(''#log li#''+file.id);'||chr(10)||
'			item.find(''div.progress'').css(''width'', ''100%'');'||chr(10)||
'			item.find(''span.progressvalue'').text(''100%'');'||chr(10)||
'			item.addClass(''success'').find(''p.statu';

ph:=ph||'s'').html(''Upload complete...Loading into Database...'');'||chr(10)||
''||chr(10)||
'                        var get = new htmldb_Get(null,'||chr(10)||
'                                                 $v(''pFlowId''),'||chr(10)||
'                                                 ''APPLICATION_PROCESS=ATTACHMENTS_SAVE_TO_DATABASE'','||chr(10)||
'                                                 $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'                        var serverDataSplit = serverD';

ph:=ph||'ata.split("~~~");'||chr(10)||
''||chr(10)||
'                        get.addParam(''x01'',''&P5100_OBJ1.'');        // OBJ'||chr(10)||
'                        get.addParam(''x02'',''&USER_SID.'');          // User SID'||chr(10)||
'                        get.addParam(''x03'',serverDataSplit[0]);    // Filename'||chr(10)||
'                        get.addParam(''x04'',serverDataSplit[1]);    // MimeType'||chr(10)||
'                        gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'			if(gReturn = ';

ph:=ph||'"")'||chr(10)||
'                          item.find(''p.status'').html(''Upload complete......'');'||chr(10)||
'                        else '||chr(10)||
'                          item.find(''p.status'').html(''Upload complete...''+gReturn);'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadError'', function(event, file, errorCode, message)'||chr(10)||
'                     {'||chr(10)||
'                      if(errorCode!==-240)'||chr(10)||
'                        {'||chr(10)||
'			 var item=$(''#log li#''+file.id);'||chr(10)||
'			 ';

ph:=ph||'item.addClass(''error'').find(''p.status'').html(''Upload Failed...''+message);'||chr(10)||
'                        }'||chr(10)||
'		})'||chr(10)||
''||chr(10)||
'		.bind(''uploadComplete'', function(event, file){'||chr(10)||
'			// upload has completed, try the next one in the queue'||chr(10)||
'			$(this).swfupload(''startUpload'');'||chr(10)||
''||chr(10)||
'                        var stats = $.swfupload.getInstance(''#swfupload-control'').getStats();'||chr(10)||
''||chr(10)||
'                        if(stats.files_queued <= 0)'||chr(10)||
'  ';

ph:=ph||'                        {'||chr(10)||
'                           alert(''Uploads are complete, please click OK to refresh this page....'');'||chr(10)||
'                           clearDirty();'||chr(10)||
'                           doSubmit(''MULTI_SAVED'');'||chr(10)||
'                          }'||chr(10)||
'		})'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'<!-- jQuery SWFUpload Code -->'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 5100,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Attachments',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P5100_SEL_ATTACHMENT.'');"',
  p_step_sub_title => 'Attachments',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'$(window).load(function(){  '||chr(10)||
''||chr(10)||
'  var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
''||chr(10)||
'});'||chr(10)||
''||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' if(jQuery.browser.flash==false)'||chr(10)||
'   {'||chr(10)||
'    $("label[for=P5100_SWFUPLOAD],#P5100_SWFUPLOAD").hide();'||chr(10)||
'   }'||chr(10)||
'});'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20130109102541',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '21-OCT-2010  J.Faris - WCHG0000319 updated javascript ''description'' validation to set the default description instead of constantly popping the message.'||chr(10)||
''||chr(10)||
'11-Apr-2011 Tim Ward - Made Report not Use Pagination, gets rid of problems '||chr(10)||
'                       when items are deleted and Pagination changes.  User '||chr(10)||
'                       gets an ugly error until they close the browser and '||chr(10)||
'                       re-open it.  '||chr(10)||
''||chr(10)||
'                       Also set FileSize/Attached By/On to NoWrap to '||chr(10)||
'                       make them look better.'||chr(10)||
''||chr(10)||
'                       Made FileSize Right Justified.'||chr(10)||
''||chr(10)||
'                       Made the Report go 100% width.'||chr(10)||
''||chr(10)||
'18-May-2011 Tim Ward - CR#3783 and 3834 - Move Case File back to open if'||chr(10)||
'                       the "ROI/CSR Final Published" Report Type is changed.'||chr(10)||
'                       Changed in Process "change_status_back_OP", now runs'||chr(10)||
'                       on DELETE,SAVE.'||chr(10)||
''||chr(10)||
'15-Sep-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
'07-Oct-2011 - CR#3946 - Add ParentInfo Open Link to Grid and Selected'||chr(10)||
'                        Attachment Detials so the users can get to the'||chr(10)||
'                        parent quickly (if it is not the same as this file).'||chr(10)||
'                        Added File/Activity to the Grid, changed the value'||chr(10)||
'                        of P5100_OBJ_TAG is in "Preload Items".  Changed '||chr(10)||
'                        Condition of P5100_OBJ_TAG to be displayed only if'||chr(10)||
'                        P5100_USAGE=''ATTACHMENT'' since that is the only one '||chr(10)||
'                        that has filters to show attachments from associated '||chr(10)||
'                        files/activities.  Also changed '||chr(10)||
'                        OSI_OBJECT.GET_OPEN_LINK so it returns 32000 instead '||chr(10)||
'                        of 200 in the Link since the parentinfo can be as long '||chr(10)||
'                        as the title + a few characters...'||chr(10)||
''||chr(10)||
'07-Oct-2011  Tim Ward - Added Shift Up/Down Key for Navigation. '||chr(10)||
'                        Added "JS_REPORT_AUTO_SCROLL" to HTML Header.  '||chr(10)||
'                        Added onkeydown="return checkForUpDownArrows '||chr(10)||
'                        (event, ''&P5100_SEL_ATTACHMENT.'');" to HTML Body'||chr(10)||
'                        Attribute. '||chr(10)||
'                        Added name=''#SID#'' to "Link Attributes" of the '||chr(10)||
'                        SID Column of the Report. '||chr(10)||
'                        Added a new Branch to'||chr(10)||
'                                 "f?p=&APP_ID.:5100:&SESSION.::&DEBUG.:::#&5100_SEL_NOTE.",'||chr(10)||
'                        this allows the report to move the the Anchor '||chr(10)||
'                        of the selected currentrow.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
''||chr(10)||
'19-Jan-2012 Tim Ward - CR#3776 - Allow Adding Attachments after Closure, but hide the Save/Delete'||chr(10)||
'                        buttons so items can''t be changes/deleted.'||chr(10)||
''||chr(10)||
'01-May-2012 - Tim Ward - CR#4044 - Added ROI Print and Print Order Fields.'||chr(10)||
'                          Changed Query to join new table'||chr(10)||
'                          T_OSI_REPORT_ROI_ATTACH.'||chr(10)||
''||chr(10)||
'21-May-2012 - Tim Ward - CR#4070 - Source Files shouldn''t show filters.'||chr(10)||
''||chr(10)||
'25-Sep-2012 - Tim Ward - CR#3710, 3861 - Multiple uploads at once.'||chr(10)||
''||chr(10)||
'09-Nov-2012 - Tim Ward - CR#4186 - Hide Save, Delete, Browse, and Select'||chr(10)||
'                          when LOCK_MODE is not null.'||chr(10)||
''||chr(10)||
'27-Nov-2012 - Tim Ward - CR#4185 - Added process to check for a Signed Form 40'||chr(10)||
'                          on an Activity to update field:'||chr(10)||
'                           T_OSI_ACTIVITY_LOOKUP.SIGNED_FORM_40_ATTACHED.'||chr(10)||
'                          Added ''MULTI_SAVED'' to the submit for mult-uploads.'||chr(10)||
''||chr(10)||
'19-Dec-2012 - Tim Ward - Added code to check for a maximum file size that is'||chr(10)||
'                          located in T_CORE_CONFIG - OSI.ATTCH_MXSZ.'||chr(10)||
''||chr(10)||
'09-Jan-2013 - Tim Ward - Added Maximum of 10 files per multi-upload.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5100,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<div class="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 2573503288822953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_required_role => '!'||(5499017822598037+ wwv_flow_api.g_id_offset),
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 8105502134151193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Access Denied',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE = ''PERSONNEL'''||chr(10)||
'and'||chr(10)||
':TAB_ENABLED <> ''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89968506459315951 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Details of Selected &P5100_USAGE_DISPLAY. <font color="red"><i>([shift]+[down]/[up] to navigate &P5100_USAGE_DISPLAY.(s))</i></font>',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5100_SEL_ATTACHMENT IS NOT NULL OR :P5100_MODE = ''ADD''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89968731421315953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 89968931968315953 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_plug_name=> 'Choose the Attached Reports to Display',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P5100_IS_FILE = ''Y'''||chr(10)||
'AND :P0_OBJ_TYPE_CODE NOT IN (''FILE.SOURCE'')',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select a.sid "SID",'||chr(10)||
'       decode(a.storage_loc_type,'||chr(10)||
'              ''OUTSIDE'', '''','||chr(10)||
'              ''<a href=''''f?p=&APP_ID.:250:&SESSION.:'' || a.sid'||chr(10)||
'              || '':&DEBUG.:250:'''' target=''''_blank''''><img src="#IMAGE_PREFIX#themes/OSI/arrow_down-small.png" alt="Download/View" /></a>'') as "Download",'||chr(10)||
'       decode(a.mime_type,'||chr(10)||
'              null, ''Hard Copy'','||chr(10)||
'              ''<img src="&IMAGE_PREFIX.'''||chr(10)||
'';

s:=s||'              || osi_util.get_mime_icon(a.mime_type, a.source) || ''" alt="'' || a.mime_type || ''"> '') as "File Type",'||chr(10)||
'       a.description as "Description",'||chr(10)||
'       (select nvl(description, ''-'')'||chr(10)||
'          from t_osi_attachment_type at'||chr(10)||
'         where sid = a.type'||chr(10)||
'           and (   at.usage = :p5100_usage'||chr(10)||
'                or at.usage is null and :p5100_usage = ''ATTACHMENT'')) as "Attachment Type",'||chr(10)||
'    ';

s:=s||'   osi_util.parse_size(dbms_lob.getlength(a.content)) as "File Size",'||chr(10)||
'       a.create_by as "Attached By", a.create_on as "Date Attached",'||chr(10)||
'       decode(a.sid, :p5100_sel_attachment, ''Y'', ''N'') "Current",'||chr(10)||
'       decode(:P5100_OBJ, a.obj, core_obj.get_parentinfo(a.obj), osi_object.get_open_link(a.obj,core_obj.get_parentinfo(a.obj))) as "File/Activity",'||chr(10)||
'       decode(ra.attachment,a.sid,''Yes'',''No'') a';

s:=s||'s "Print",'||chr(10)||
'       nvl(ra.seq,0) as "Order"'||chr(10)||
'  from t_osi_attachment a,'||chr(10)||
'       t_osi_attachment_type at,'||chr(10)||
'       t_osi_report_roi_attach ra'||chr(10)||
' where (at.sid(+) = a.type'||chr(10)||
'   and nvl(at.usage, ''ATTACHMENT'') = :p5100_usage)'||chr(10)||
'   and (a.sid=ra.attachment(+) and a.obj=ra.obj(+))'||chr(10)||
'   &P5100_FILTERS.';

wwv_flow_api.create_report_region (
  p_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5100,
  p_name=> '&P5100_USAGE_DISPLAY.s',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P0_obj_type_code <> ''PERSONNEL'''||chr(10)||
'or'||chr(10)||
'(:P0_OBJ_TYPE_CODE = ''PERSONNEL'' and :TAB_ENABLED = ''Y'')',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '1000000000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No &P5100_REPORT_MSG. found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '1000000000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P5100_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000627243874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'N',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000728149874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Download',
  p_column_display_sequence=> 3,
  p_column_heading=> '&nbsp;',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000821042874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'File Type',
  p_column_display_sequence=> 2,
  p_column_heading=> 'File Type',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96000911699874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Description',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Description',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001006826874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Attachment Type',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Attachment Type',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'ITEM_NOT_NULL_OR_ZERO',
  p_display_when_condition=> 'p5100_show_type',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001133157874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'File Size',
  p_column_display_sequence=> 8,
  p_column_heading=> 'File Size',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001229742874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Attached By',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Attached By',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001316967874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Date Attached',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Date Attached',
  p_column_format=> '&FMT_DATE.',
  p_column_css_style=>'white-space:nowrap;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 96001428251874179 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8268816223964004 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'File/Activity',
  p_column_display_sequence=> 12,
  p_column_heading=> 'File/Activity',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P5100_USAGE=''ATTACHMENT'''||chr(10)||
'AND :P5100_IS_FILE=''Y'''||chr(10)||
'AND :P5100_ASSOC_ATTACHMENTS NOT IN (''ME'')',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13428607875061818 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Print',
  p_column_display_sequence=> 4,
  p_column_heading=> 'ROI Print?',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13429501519126245 + wwv_flow_api.g_id_offset,
  p_region_id=> 93061334254864723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Order',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Print Order',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89969128704315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 40,
  p_button_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P5100_ADD_LABEL.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> '(:P0_OBJ_TYPE_CODE not in (''PERSONNEL'',''UNIT'') and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
''||chr(10)||
'or'||chr(10)||
''||chr(10)||
'((:P0_OBJ_TYPE_CODE = ''PERSONNEL'' and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
'and'||chr(10)||
'osi_auth.check_for_priv(''ATCH'', :P0_OBJ_TYPE_SID) = ''Y'')'||chr(10)||
''||chr(10)||
'or'||chr(10)||
''||chr(10)||
'((:P0_OBJ_TYPE_CODE = ''UNIT'' and(:P5100_SHOW_TYPE > 0 or :P5100_USAGE = ''ATTACHMENT''))'||chr(10)||
'and'||chr(10)||
'osi_auth.check_for_priv(''ATCH'', :P0_OBJ_TYPE_SID) = ''Y'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969714565315956 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 20,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P5100_SEL_ATTACHMENT IS NOT NULL AND'||chr(10)||
':P5100_IS_ASSOC IS NOT NULL AND'||chr(10)||
':P0_WRITABLE=''Y'' AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969520283315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 30,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'P5100_SEL_ATTACHMENT',
  p_button_condition_type=> 'ITEM_IS_NULL',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 89969307841315954 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 10,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE.',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P5100_SEL_ATTACHMENT IS NOT NULL AND'||chr(10)||
':P5100_IS_ASSOC IS NOT NULL AND'||chr(10)||
'(osi_auth.check_for_priv(''ATCH_DELETE'', :p0_obj_type_sid) = ''Y'' or :p5100_CREATING_PERSONNEL = :user_sid) AND'||chr(10)||
':p0_writable=''Y'' AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 5499017822598037+ wwv_flow_api.g_id_offset,
  p_button_comment=>'--- Line Removed from Condition 19-Jan-2012'||chr(10)||
'---((:p0_obj_type_code = ''FILE.SFS'' and :p0_writable = ''Y'' and osi_object.get_status_code(:p0_obj) not in (''CL'',''SV'',''AV'',''RV'')) or true)',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16177023862626890 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 70,
  p_button_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 5100);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 91072535069823301 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 5100,
  p_button_sequence=> 60,
  p_button_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_cattributes=>'onclick="javascript:ReleaseCheck();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89977419753315976 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>89977231569315974 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_branch_action=> 'f?p=&APP_ID.:5100:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P5100_OBJ1.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5781903038960339 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 365,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6541403513057628 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_CREATING_PERSONNEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'CREATING_PERSONNEL',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8105819813151210 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ACCESS_DENIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8105502134151193+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Access Denied',
  p_source=>'You do not have permission to view the contents of this tab.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8751615819100764 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_RPT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 345,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select sid '||chr(10)||
'from t_osi_attachment_type '||chr(10)||
'where (usage = ''REPORT'' and code = ''CR'') '||chr(10)||
'and obj_type = :p0_obj',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13429003204098276 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_PRINT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 19,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'ROI Print?',
  p_source=>'PRINT',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13429227099105246 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_PRINT_ORDER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Print Order',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14705005429767507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SWFUPLOAD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Upload Multiple Attachments',
  p_source=>'<style type="text/css" >'||chr(10)||
'#swfupload-control p{ margin:10px 5px; font-size:0.9em; }'||chr(10)||
'#log{ margin:0; padding:0; width:500px;}'||chr(10)||
'#log li{ list-style-position:inside; margin:2px; border:1px solid #ccc; padding:10px; font-size:12px; '||chr(10)||
'	font-family:Arial, Helvetica, sans-serif; color:#333; background:#fff; position:relative;}'||chr(10)||
'#log li .progressbar{ border:1px solid #333; height:5px; background:#fff; }'||chr(10)||
'#log li .progress{ background:#999; width:0%; height:5px; }'||chr(10)||
'#log li p{ margin:0; line-height:18px; }'||chr(10)||
'#log li.success{ border:1px solid #339933; background:#ccf9b9; }'||chr(10)||
'#log li.error{ border:1px solid #B84D4D; background:#FF0000; }'||chr(10)||
'#log li span.cancel{ position:absolute; top:5px; right:5px; width:20px; height:20px; '||chr(10)||
'	background:url(''#IMAGE_PREFIX#jquery/jquery-swfupload/js/swfupload/cancel.png'') no-repeat; cursor:pointer; }'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<div id="swfupload-control">'||chr(10)||
'	<input type="button" id="button" /><label id="queuestatus" >Files Selected: 0 / Queued Files: 0</label>'||chr(10)||
'	<ol id="log"></ol>'||chr(10)||
'</div>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes2=> ' id="SWFUpload_Label_0"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'') AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16177203908630507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 355,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17486217734384656 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCK_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 21,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'LOCK_MODE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17987526572333122 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_MAX_SIZE_LIMIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_ESCAPE_SC',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970108112315956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_ATTACHMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SEL_ATTACHMENT=',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970324808315956 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Location',
  p_source=>'P5100_LOCATION_VALUE',
  p_source_type=> 'ITEM',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'SELECT DESCRIPTION, CODE'||chr(10)||
'FROM T_OSI_ATTACHMENT_LOC_TYPE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Location -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_read_only_when=>'P5100_SEL_ATTACHMENT',
  p_read_only_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970517561315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source=>'DESCRIPTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onblur="javascript:CheckDescription();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970730016315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DATE_MODIFIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Modified',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'DATE_MODIFIED',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89970922565315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ_TAG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File/Activity',
  p_source_type=> 'ITEM',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT IS NOT NULL'||chr(10)||
'AND :P5100_USAGE=''ATTACHMENT'''||chr(10)||
'AND :P5100_IS_FILE=''Y'''||chr(10)||
'AND :P5100_ASSOC_ATTACHMENTS NOT IN (''ME'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971135606315957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Type',
  p_source=>'TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select   description, sid'||chr(10)||
'    from t_osi_attachment_type'||chr(10)||
'   where obj_type=:p0_obj_type_sid and usage = :p5100_usage'||chr(10)||
'     and (active = ''Y'' or sid = :p5100_sel_attachment)'||chr(10)||
'order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Attachment Type -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'p5100_show_type',
  p_display_when_type=>'ITEM_NOT_NULL_OR_ZERO',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971512072315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ASSOC_ATTACHMENTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 89968931968315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ME',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Attachments for this File;ME,Attachments for Associated Files;A_FILES,Attachments for Associated Activities;A_ACT,Attachments for Inherited Activities;I_ACT',
  p_lov_columns=> 4,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''UPDATE'');"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971709629315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_IS_FILE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_IS_FILE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89971918229315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_USAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_USAGE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972135266315959 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_USAGE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_USAGE_DISPLAY',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972324566315960 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_ADD_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_ADD_LABEL',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972514425315960 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_FILENAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'SUBSTR(:P5100_SOURCE, INSTR(:P5100_SOURCE, ''/'')+1)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'') AND :P5100_SEL_ATTACHMENT IS NOT NULL',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'SUBSTR(:P5100_SOURCE, INSTR(:P5100_SOURCE, ''/'')+1)');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972728423315962 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 305,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_OBJ=',
  p_source=>'OBJ',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89972928881315967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DEFAULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_DEFAULT=',
  p_source=>'SELECT DEFAULT_SOURCE'||chr(10)||
'  FROM T_OSI_ATTACHMENT_LOC_TYPE'||chr(10)||
' WHERE CODE = :P5100_LOCATION;',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89973111291315967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE=',
  p_source=>'SOURCE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89973321073315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_LOCATION_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 300,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_LOCATION_VALUE=',
  p_source=>'STORAGE_LOC_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89973723512315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DISPLAY1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '&P5100_SOURCE_DEFAULT.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
  p_display_as=> 'FILE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 100,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:SetDescription();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE IN (''DB'', ''FILE'') AND'||chr(10)||
':P5100_LOCK_MODE IS NULL',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89974116508315968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'Filename',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_LABEL=',
  p_source=>'SELECT LT.SOURCE_LABEL'||chr(10)||
'  FROM T_OSI_ATTACHMENT_LOC_TYPE LT'||chr(10)||
' WHERE LT.CODE = :P5100_LOCATION',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89974306816315970 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_DISPLAY2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '&P5100_SOURCE_DEFAULT.',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P5100_SOURCE_LABEL.',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_LOCATION_VALUE = ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>90191435144745245 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SOURCE_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_SOURCE_VALUE',
  p_source=>'P5100_SOURCE',
  p_source_type=> 'ITEM',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91696110052924568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_FILE_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Type',
  p_source=>'select ''<img src="'' || ''&IMAGE_PREFIX.'''||chr(10)||
'       || osi_util.get_mime_icon(:p5100_mime_type, :p5100_source) || ''" alt="'' || :p5100_mime_type || ''"> '''||chr(10)||
'  from dual',
  p_source_type=> 'QUERY',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91696432216930996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_SIZE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Size',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91697016417935865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SEL_ATTACHED_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Attached By',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P5100_SEL_ATTACHMENT',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93438721493928231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_DOWNLOAD_LINK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 89968506459315951+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Download',
  p_source=>'<a href=''f?p=&APP_ID.:250:&SESSION.:&P5100_SEL_ATTACHMENT.:&DEBUG.:250:'' target=''_blank''>Download</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P5100_SEL_ATTACHMENT is not null and :P5100_LOCATION_VALUE <> ''OUTSIDE''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>93539128547458334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_MODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_MODE',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95314813809105521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_REPORT_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'LOWER(:P5100_USAGE_DISPLAY) || ''s''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95795113446811165 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_MIME_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 315,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'MIME_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>95987930071629068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_FILTERS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 65,
  p_item_plug_id => 89968731421315953+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_FILTERS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96043334900410276 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_IS_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 320,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P5100_IS_ASSOC',
  p_source=>'select 1'||chr(10)||
'  from t_osi_attachment'||chr(10)||
' where sid = :p5100_sel_attachment and obj = :p5100_obj;',
  p_source_type=> 'QUERY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>98521323722200984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5100,
  p_name=>'P5100_SHOW_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 325,
  p_item_plug_id => 93061334254864723+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100412724608218170 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_TYPE',
  p_validation_sequence=> 1,
  p_validation => 'P5100_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Type must be specified.',
  p_validation_condition=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89975215668315971 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_LOCATION Not Null',
  p_validation_sequence=> 5,
  p_validation => 'P5100_LOCATION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Location must be specified.',
  p_validation_condition=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89970324808315956 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89974816169315970 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Soft copy not null',
  p_validation_sequence=> 10,
  p_validation => 'P5100_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P5100_SOURCE_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''CREATE'') AND :P5100_LOCATION IN (''DB'', ''FILE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89973723512315968 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 22-APR-2009 11:33');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 17991104652544427 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Check Max Filesize',
  p_validation_sequence=> 11,
  p_validation => 'declare'||chr(10)||
'       v_size     number;'||chr(10)||
'       v_maxSize  number;'||chr(10)||
'       v_source   varchar2(32000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     select nvl(to_number(core_util.get_config(''OSI.ATTCH_MXSZ'')),0) into v_maxSize from dual;'||chr(10)||
'     if v_maxSize > 0 then'||chr(10)||
''||chr(10)||
'       if (:p5100_location_value <> ''OUTSIDE'') then'||chr(10)||
''||chr(10)||
'         if (:request = ''CREATE'') or ((:request = ''SAVE'') and (:p5100_source <> :p5100_source_display1)) then'||chr(10)||
''||chr(10)||
'          if (:request = ''CREATE'') then'||chr(10)||
''||chr(10)||
'            v_source := :p5100_source;'||chr(10)||
''||chr(10)||
'          elsif(:request = ''SAVE'') then'||chr(10)||
'  '||chr(10)||
'               v_source := :p5100_source_display1;'||chr(10)||
''||chr(10)||
'          end if;'||chr(10)||
'         '||chr(10)||
'           if v_source is null or v_source='''' then'||chr(10)||
''||chr(10)||
'             return ''Please browse for a file before clicking Save.'';'||chr(10)||
''||chr(10)||
'           else'||chr(10)||
''||chr(10)||
'             select doc_size'||chr(10)||
'               into v_size'||chr(10)||
'               from wwv_flow_files'||chr(10)||
'              where name = v_source;'||chr(10)||
''||chr(10)||
'             if (v_size > v_maxSize) then'||chr(10)||
'           '||chr(10)||
'               if (:request = ''CREATE'') then'||chr(10)||
''||chr(10)||
'                 delete from t_osi_attachment where sid = :p5100_sel_attachment;'||chr(10)||
''||chr(10)||
'               end if;'||chr(10)||
'               return ''File size:  '' || to_char(v_size,''999,999,999,999,999,999'') || '' exceeds maximumn allowed:  '' || to_char(v_maxSize,''999,999,999,999,999,999'') || ''.'';'||chr(10)||
''||chr(10)||
'             end if;'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
''||chr(10)||
'         end if;'||chr(10)||
''||chr(10)||
'       end if;    '||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return null;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'File size exceeds maximum allowed.',
  p_validation_condition=> ':REQUEST IN (''CREATE'',''SAVE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89974609671315970 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Hard copy not null',
  p_validation_sequence=> 15,
  p_validation => 'P5100_SOURCE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P5100_SOURCE_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''CREATE'', ''SAVE'') AND :P5100_LOCATION = ''OUTSIDE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89974306816315970 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 89975031327315971 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'P5100_DESCRIPTION Not Null',
  p_validation_sequence=> 20,
  p_validation => 'P5100_DESCRIPTION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Description must be specified.',
  p_validation_condition=> 'CREATE,SAVE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 89970517561315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'generated 22-APR-2009 11:33');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8721015473382834 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Check max_num attach types',
  p_validation_sequence=> 30,
  p_validation => 'declare '||chr(10)||
''||chr(10)||
'       v_max_count varchar(10);'||chr(10)||
'       v_attach_count varchar(10);'||chr(10)||
'begin'||chr(10)||
'     if :P5100_TYPE is not null then'||chr(10)||
''||chr(10)||
'       select max_num into v_max_count'||chr(10)||
'             from t_osi_attachment_type where sid = :P5100_TYPE;'||chr(10)||
'     '||chr(10)||
'       if :P5100_SEL_ATTACHMENT IS NULL then'||chr(10)||
''||chr(10)||
'         select count(*) into v_attach_count'||chr(10)||
'           from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'          where a.obj = :P0_OBJ'||chr(10)||
'            and a.type = at.sid'||chr(10)||
'            and at.sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         select count(*) into v_attach_count'||chr(10)||
'           from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'          where a.obj = :P0_OBJ'||chr(10)||
'            and a.type = at.sid'||chr(10)||
'            and at.sid = :P5100_TYPE'||chr(10)||
'            and a.sid != :P5100_SEL_ATTACHMENT;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'       if(v_attach_count >= v_max_count) then'||chr(10)||
''||chr(10)||
'         return ''There can only be '' || v_max_count || '||chr(10)||
'                '' Attachment of this type in this object.'';'||chr(10)||
''||chr(10)||
'       else '||chr(10)||
''||chr(10)||
'        return null;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Attachment type already exists on this File. ',
  p_validation_condition=> ':REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> ':P5100_SEL_ATTACHMENT IS NULL AND :REQUEST IN (''CREATE'',''SAVE'') AND :P5100_USAGE = ''REPORT'''||chr(10)||
''||chr(10)||
''||chr(10)||
'declare '||chr(10)||
''||chr(10)||
'       v_max_count varchar(10);'||chr(10)||
'       v_attach_count varchar(10);'||chr(10)||
'begin'||chr(10)||
'     select max_num'||chr(10)||
'       into v_max_count'||chr(10)||
'     from t_osi_attachment_type'||chr(10)||
'      where sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'     select count(*)'||chr(10)||
'       into v_attach_count'||chr(10)||
'       from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'      where a.obj = :P0_OBJ'||chr(10)||
'       and a.type = at.sid'||chr(10)||
'       and at.sid = :P5100_TYPE;'||chr(10)||
''||chr(10)||
'     if(v_attach_count >= v_max_count) then'||chr(10)||
''||chr(10)||
'       return ''There can only be '' || v_max_count || '' Attachment of this type in this object.'';'||chr(10)||
''||chr(10)||
'     else '||chr(10)||
''||chr(10)||
'      return null;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'end;');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8782524288390115 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Create/Save/Delete SCR',
  p_validation_sequence=> 40,
  p_validation => 'declare'||chr(10)||
''||chr(10)||
'   v_scr varchar2(20);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     select sid into v_scr'||chr(10)||
'       from t_osi_attachment_type'||chr(10)||
'        where usage=''REPORT'''||chr(10)||
'          and code=''CR'''||chr(10)||
'          and obj_type=:p0_obj_type_sid;'||chr(10)||
''||chr(10)||
'     if (:p5100_type = v_scr) then'||chr(10)||
''||chr(10)||
'       return ''You cannot Create, Edit, or Delete a Summary Complaint Report.'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return null;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_ERR_TEXT',
  p_error_message => 'Error',
  p_validation_condition=> ':REQUEST IN (''CREATE'',''SAVE'',''DELETE'') and'||chr(10)||
'osi_object.get_objtype_code(core_obj.get_objtype(:P0_OBJ)) like ''FILE.INV%''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89971135606315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> ':REQUEST IN (''SAVE'',''DELETE'') and'||chr(10)||
'osi_object.get_status(:P0_OBJ) not in (''New'', ''Awaiting Approval'') and'||chr(10)||
'select osi_object.get_objtype_code(core_obj.get_objtype(:P0_OBJ)) like ''FILE.INV%''');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11827424158571048 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 45,
  p_validation => 'P5100_DATE_MODIFIED',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''SAVE'',''CREATE'') AND :P5100_DATE_MODIFIED IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 89970730016315957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  procedure l(p_log_text varchar2) is'||chr(10)||
'  begin'||chr(10)||
'     core_logger.log_it(''timtest'', p_log_text);'||chr(10)||
'  end l;'||chr(10)||
'begin'||chr(10)||
'  l('' '');'||chr(10)||
'  l(''obj:'' || :p5100_obj || '', '' || core_obj.get_tagline(:p5100_obj));'||chr(10)||
'  l(''sid:'' || :p5100_sel_attachment);'||chr(10)||
'  l(''text:'' || :p5100_description);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6690205082622300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'debug',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (:request in(''ADD'', ''P5100_LOCATION'')) then'||chr(10)||
'        :p5100_mode := ''ADD'';'||chr(10)||
'    else'||chr(10)||
'        :p5100_mode := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95132918713047790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set mode',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:T_OSI_ATTACHMENT:P5100_SEL_ATTACHMENT:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 95299420877142370 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Do T_OSI_ATTACHMENT',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CREATE,SAVE,DELETE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P5100_SEL_ATTACHMENT',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_blob     blob          := null;'||chr(10)||
'    v_file     varchar2(400) := null;'||chr(10)||
'    v_mime     varchar2(255) := null;'||chr(10)||
''||chr(10)||
'    procedure upload(p_source in varchar2) is'||chr(10)||
'    begin'||chr(10)||
'        select blob_content, filename, mime_type---, doc_size, to_number(core_util.get_config(''OSI.ATTCH_MXSZ''))'||chr(10)||
'          into v_blob, v_file, v_mime---, v_size, v_maxSize'||chr(10)||
'          from wwv_flow_files'||chr(10)||
'         where nam';

p:=p||'e = p_source;'||chr(10)||
''||chr(10)||
'           update t_osi_attachment'||chr(10)||
'              set content = v_blob,'||chr(10)||
'                  source = v_file,'||chr(10)||
'                  mime_type = v_mime,'||chr(10)||
'                  type = :p5100_type,'||chr(10)||
'                  storage_loc_type = :p5100_location_value,'||chr(10)||
'                  description = :p5100_description'||chr(10)||
'            where sid = :p5100_sel_attachment;'||chr(10)||
''||chr(10)||
'    end;'||chr(10)||
'begin'||chr(10)||
'    if (:p5100_location_value';

p:=p||' <> ''OUTSIDE'') then'||chr(10)||
'        if (:request = ''CREATE'') then'||chr(10)||
'            upload(:p5100_source);'||chr(10)||
'        elsif(:request = ''SAVE'') then'||chr(10)||
'            if (:p5100_source <> :p5100_source_display1) then'||chr(10)||
'                --A new attachment was given.'||chr(10)||
'                upload(:p5100_source_display1);'||chr(10)||
'            else'||chr(10)||
'                update t_osi_attachment'||chr(10)||
'                   set type = :p5100_type,'||chr(10)||
'             ';

p:=p||'          storage_loc_type = :p5100_location_value,'||chr(10)||
'                       description = :p5100_description'||chr(10)||
'                 where sid = :p5100_sel_attachment;'||chr(10)||
'            end if;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 90170733611516101 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 15,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get the BLOB',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Error, Filesize exceeds maximum allowed:',
  p_process_when=>'CREATE,SAVE',
  p_process_when_type=>'',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'   v_status_change_sid varchar2(20);'||chr(10)||
'   v_current_status varchar2(20);'||chr(10)||
'   v_type varchar(50);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     '||chr(10)||
'  if(:P0_OBJ_TYPE_CODE like ''FILE.INV%'' and :P5100_USAGE = ''REPORT'') then'||chr(10)||
''||chr(10)||
'       select at.sid'||chr(10)||
'         into v_type'||chr(10)||
'         from t_osi_attachment_type at'||chr(10)||
'        where at.usage = ''REPORT'''||chr(10)||
'         and at.code = ''ROIFP'''||chr(10)||
'         and at.obj_type = :P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'       v_current_s';

p:=p||'tatus := osi_object.get_status_code(:P0_OBJ);'||chr(10)||
''||chr(10)||
'   if (v_current_status = ''OP'' and :P5100_TYPE = v_type) then'||chr(10)||
''||chr(10)||
'      select sc.sid'||chr(10)||
'        into v_status_change_sid'||chr(10)||
'        from t_osi_status_change sc, t_osi_status s1, t_osi_status s2'||chr(10)||
'       where sc.from_status = s1.sid'||chr(10)||
'        and sc.to_status = s2.sid'||chr(10)||
'        and s1.code = ''OP'''||chr(10)||
'        and s2.code = ''IC'''||chr(10)||
'        and sc.obj_type = core_obj.lookup_';

p:=p||'objtype(''FILE.INV'');'||chr(10)||
''||chr(10)||
'      osi_status.change_status(:P0_OBJ, v_status_change_sid);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8583804323504898 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 16,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'change_status_to_IC',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,SAVE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       v_attach_count number;'||chr(10)||
'begin'||chr(10)||
'     if(:P0_OBJ_TYPE_CODE like ''ACT.%'') then'||chr(10)||
''||chr(10)||
'       select count(*) into v_attach_count from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'        where obj = :P5100_OBJ '||chr(10)||
'          and a.type = at.sid'||chr(10)||
'          and at.code = ''FFORM40'';'||chr(10)||
''||chr(10)||
'       if v_attach_count > 0 then'||chr(10)||
''||chr(10)||
'         update t_osi_activity_lookup set signed_form_40_attached=''Y'' where sid=:P51';

p:=p||'00_OBJ;'||chr(10)||
'       '||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         update t_osi_activity_lookup set signed_form_40_attached=''N'' where sid=:P5100_OBJ;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 17803230537927445 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 16.1,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update T_OSI_ACTIVITY_LOOKUP',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE,SAVE,DELETE,MULTI_SAVED',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'Declare'||chr(10)||
''||chr(10)||
'  v_status_change_sid varchar2(20);'||chr(10)||
'  v_current_status varchar2(20);'||chr(10)||
'  v_type varchar2(20);'||chr(10)||
'  v_attach_count varchar2(10);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if (:P0_OBJ_TYPE_CODE like ''FILE.INV%'' and :P5100_USAGE = ''REPORT'') then'||chr(10)||
''||chr(10)||
'    select at.sid into v_type from t_osi_attachment_type at'||chr(10)||
'     where at.usage = ''REPORT'''||chr(10)||
'       and at.code = ''ROIFP'''||chr(10)||
'       and at.obj_type = :P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'    select count(*) ';

p:=p||'into v_attach_count from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'     where obj = :P0_OBJ '||chr(10)||
'       and a.type = at.sid'||chr(10)||
'       and at.code = ''ROIFP'';'||chr(10)||
' '||chr(10)||
'    v_current_status := osi_object.get_status_code(:P0_OBJ);'||chr(10)||
''||chr(10)||
'    ---if (v_current_status = ''IC'' and :P5100_TYPE = v_type and v_attach_count = 0) then    '||chr(10)||
'    if (v_current_status = ''IC'' and ((:P5100_TYPE = v_type and :request=''DELETE'') or (:P51';

p:=p||'00_TYPE != v_type and :request=''SAVE'')) and v_attach_count = 0) then    '||chr(10)||
''||chr(10)||
'      select sc.sid into v_status_change_sid from t_osi_status_change sc, t_osi_status s1, t_osi_status s2'||chr(10)||
'       where sc.from_status = s1.sid'||chr(10)||
'         and sc.to_status = s2.sid'||chr(10)||
'         and s1.code = ''IC'''||chr(10)||
'         and s2.code = ''IC'''||chr(10)||
'         and sc.transition = ''Reopen'''||chr(10)||
'         and sc.obj_type = core_obj.lookup_objtype(''F';

p:=p||'ILE.INV'');'||chr(10)||
''||chr(10)||
'      osi_status.change_status(:P0_OBJ, v_status_change_sid);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8593206971272143 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 17,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'change_status_back_OP',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'DELETE,SAVE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (   :request in(''ADD'', ''DELETE'', ''CANCEL'')'||chr(10)||
'        or :request like ''EDIT_%'') then'||chr(10)||
'        :p5100_type := null;'||chr(10)||
'        :p5100_source_label := null;'||chr(10)||
'        :p5100_description := null;'||chr(10)||
'        :p5100_date_modified := null;'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'        :p5100_location_value := null;'||chr(10)||
'        :p5100_location := null;'||chr(10)||
'        :p5100_date_modified := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:r';

p:=p||'equest in (''ADD'',''DELETE'')) then'||chr(10)||
'        :p5100_sel_attachment := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''P5100_LOCATION'') then'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 93949220719504334 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Clear fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'   v_Seq number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     :P5100_SEL_ATTACHMENT := SUBSTR(:REQUEST, 6);'||chr(10)||
''||chr(10)||
'     select seq into v_Seq from t_osi_report_roi_attach'||chr(10)||
'           where obj=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;'||chr(10)||
''||chr(10)||
'     :P5100_PRINT:=''Y'';'||chr(10)||
'     :P5100_PRINT_ORDER:=to_char(v_Seq);'||chr(10)||
''||chr(10)||
'exception when NO_DATA_FOUND then'||chr(10)||
''||chr(10)||
'         :P5100_PRINT:='''';'||chr(10)||
'         :P5100_PRINT_ORDER:=''0'';'||chr(10)||
'  '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89975928747315973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Attachment',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'     '||chr(10)||
'     v_Count Number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if (:P5100_PRINT IS NULL OR :P5100_PRINT=''N'' OR :P5100_PRINT='''') THEN ---:P5100_PRINT_OBJ is null or :P5100_PRINT_ATTACHMENT is null then'||chr(10)||
''||chr(10)||
'       delete from t_osi_report_roi_attach'||chr(10)||
'             where obj=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       select count(*) into v_Count from t_osi_report_roi_attach'||chr(10)||
'             where obj';

p:=p||'=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;'||chr(10)||
'     '||chr(10)||
'       if(v_Count=0) then'||chr(10)||
''||chr(10)||
'         insert into t_osi_report_roi_attach (obj,attachment,seq) values'||chr(10)||
'          (:P5100_OBJ, :P5100_SEL_ATTACHMENT, :P5100_PRINT_ORDER);  '||chr(10)||
''||chr(10)||
'       else'||chr(10)||
''||chr(10)||
'         update t_osi_report_roi_attach set seq=:P5100_PRINT_ORDER'||chr(10)||
'               where obj=:P5100_OBJ and attachment=:P5100_SEL_ATTACHMENT;  '||chr(10)||
'  '||chr(10)||
'       end if;'||chr(10)||
'';

p:=p||''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         null;'||chr(10)||
'     '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13431612507422697 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Save to T_OSI_REPORT_ROI_ATTACH',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''CREATE'',''SAVE'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       v_maxSize varchar2(32000);'||chr(10)||
'begin'||chr(10)||
'    :p5100_obj1 := :p0_obj;'||chr(10)||
'    :p5100_obj  := :p0_obj;'||chr(10)||
'    :p5100_usage := :tab_params;'||chr(10)||
''||chr(10)||
'    select count(sid)'||chr(10)||
'      into :p5100_show_type'||chr(10)||
'      from t_osi_attachment_type'||chr(10)||
'     where obj_type = :p0_obj_type_sid'||chr(10)||
'       and usage = :p5100_usage and active = ''Y'';'||chr(10)||
''||chr(10)||
'    if (:p5100_assoc_attachments is null) then'||chr(10)||
'        :p5100_assoc_attachments := ''ME'';'||chr(10)||
'';

p:=p||'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_sel_attachment is not null) then'||chr(10)||
'        select decode(at.description, ''NULL'', ''''),'||chr(10)||
'               osi_util.parse_size(dbms_lob.getlength(a.content)), a.create_by,'||chr(10)||
'               decode(a.obj, :P5100_OBJ, core_obj.get_parentinfo(a.obj), osi_object.get_open_link(a.obj,core_obj.get_parentinfo(a.obj)))'||chr(10)||
'          into :p5100_sel_type,'||chr(10)||
'               :p5100_sel_size, :p5100_';

p:=p||'sel_attached_by,'||chr(10)||
'               :p5100_obj_tag'||chr(10)||
'          from t_osi_attachment a, t_osi_attachment_type at'||chr(10)||
'         where a.sid = :p5100_sel_attachment and a.type = at.sid(+);'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_usage = ''ATTACHMENT'') then'||chr(10)||
'        :p5100_usage_display := initcap(:p5100_usage);'||chr(10)||
'        :p5100_add_label := :btn_add || '' Attachment(s)'';'||chr(10)||
''||chr(10)||
'        if (instr(:p0_obj_type_code, ''FILE.'', 1, 1) > 0';

p:=p||') then'||chr(10)||
'            :p5100_is_file := ''Y'';'||chr(10)||
'        else'||chr(10)||
'            :p5100_is_file := ''N'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:p5100_usage = ''REPORT'') then'||chr(10)||
'        :p5100_usage_display := ''Attached '' || initcap(:p5100_usage);'||chr(10)||
'        :p5100_add_label := :btn_add || '' Report(s)'';'||chr(10)||
'    end if;'||chr(10)||
'    '||chr(10)||
'    v_maxSize := core_util.get_config(''OSI.ATTCH_MXSZ'');'||chr(10)||
'    '||chr(10)||
'    if v_maxSize is null then'||chr(10)||
''||chr(10)||
'      :P5';

p:=p||'100_MAX_SIZE_LIMIT := '''';'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
''||chr(10)||
'      :P5100_MAX_SIZE_LIMIT := ''(maximum single filesize is:  '' || to_char(v_maxSize,''999,999,999,999,999,999,999'') || '' bytes)'';'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
'    when no_data_found then'||chr(10)||
'        return;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89975310618315971 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload Items',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_add_or   boolean := false;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'    :p5100_filters := null;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''ME'') > 0) then'||chr(10)||
'        v_add_or := true;'||chr(10)||
'        :p5100_filters := :p5100_filters'||chr(10)||
'                       || '' a.obj = '''''' || :p0_obj || '''''''';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''A_FILES'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_fi';

p:=p||'lters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p5100_filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in (select that_file from v_osi_assoc_fle_fle where this_file = '''''''||chr(10)||
'            || :p0_obj || '''''')'';'||chr(10)||
'        v_add_or := true;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''A_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_filters || '' or '';'||chr(10)||
'        ';

p:=p||'end if;'||chr(10)||
''||chr(10)||
'        :p5100_filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in(select activity_sid from v_osi_assoc_fle_act where file_sid = '''''''||chr(10)||
'            || :p0_obj || '''''')'';'||chr(10)||
'        v_add_or := true;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p5100_assoc_attachments, ''I_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) then'||chr(10)||
'            :p5100_filters := :p5100_filters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p5100_';

p:=p||'filters :='||chr(10)||
'            :p5100_filters'||chr(10)||
'            || '' a.obj in(select activity_sid'||chr(10)||
'                  from v_osi_assoc_fle_act'||chr(10)||
'                 where file_sid in(select that_file'||chr(10)||
'                                     from v_osi_assoc_fle_fle'||chr(10)||
'                                    where this_file = '''''''||chr(10)||
'            || :p0_obj || ''''''))'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'   if :p5100_filters is not null then'||chr(10)||
'       :p5100_fi';

p:=p||'lters := '' and ('' || :p5100_filters || '')'';'||chr(10)||
'   end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 95988135397639971 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Build WHERE clause',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'F|#OWNER#:T_OSI_ATTACHMENT:P5100_SEL_ATTACHMENT:SID';

wwv_flow_api.create_page_process(
  p_id     => 91758918521863790 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch T_OSI_ATTACHMENT',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P5100_SEL_ATTACHMENT IS NOT NULL AND :REQUEST <> ''P5100_LOCATION''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P5100_SEL_ATTACHMENT',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (   osi_auth.check_for_priv(''TAB_ATTACHMENTS'', :p0_obj_type_sid) = ''Y'''||chr(10)||
'        or osi_auth.check_for_priv(''TAB_ALL'', :p0_obj_type_sid) = ''Y'') then'||chr(10)||
'        :tab_enabled := ''Y'';'||chr(10)||
'    else'||chr(10)||
'        :tab_enabled := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8106112177154029 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SetTabDisabler',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (:request = ''CREATE'') then        '||chr(10)||
'        :p5100_location_value := :p5100_location;'||chr(10)||
'    '||chr(10)||
'        if (:p5100_location_value in(''DB'', ''FILE'')) then'||chr(10)||
'            :p5100_source := :p5100_source_display1;'||chr(10)||
'        else'||chr(10)||
'            :p5100_source := :p5100_source_display2;'||chr(10)||
'        end if;'||chr(10)||
'        '||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''SAVE'' and :p5100_location_value = ''OUTSIDE'') then'||chr(10)||
'        :p510';

p:=p||'0_source := :p5100_source_display2;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (:request = ''P5100_LOCATION'') then'||chr(10)||
'        :p5100_source := null;'||chr(10)||
'        :p5100_location_value := :p5100_location;'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89976131007315973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 5100,
  p_process_sequence=> 1,
  p_process_point=> 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set source',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 5100
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done
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
--   Date and Time:   13:11 Friday December 14, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
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

PROMPT ...Remove page 10150
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>10150);
 
end;
/

 
--application/pages/page_10150
prompt  ...PAGE 10150: File Associated Activities
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"'||chr(10)||
'<ul id=''mainReportsMenu'' style="left:200px; width:150px; position:absolute"></ul>'||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
'function getActList(pSelectedOrAll)'||chr(10)||
'{'||chr(10)||
' var pSelectedActivities=''~'';'||chr(10)||
''||chr(10)||
' $(''Input''+pSelectedOrAll).each(function()'||chr(10)||
'  {'||chr(10)||
'   if($(this).attr(''name'')==''f01'')'||chr(10)||
'     {'||chr(10)||
'      pSelectedActivities+=$(this).attr(''id'')+''~'';'||chr(10)||
'     }'||chr(10)||
'';

ph:=ph||'  });'||chr(10)||
''||chr(10)||
' return pSelectedActivities;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function isOneSelected()'||chr(10)||
'{'||chr(10)||
' var pOneSelected = false;'||chr(10)||
''||chr(10)||
' $("input:checked").each(function()'||chr(10)||
'  {'||chr(10)||
'   if($(this).attr(''name'')==''f01'')'||chr(10)||
'     {'||chr(10)||
'      pOneSelected = true;'||chr(10)||
'      return true;'||chr(10)||
'     }'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' return pOneSelected;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ccSelected()'||chr(10)||
'{'||chr(10)||
' if(isOneSelected()==false)'||chr(10)||
'   alert(''Please select at least one activity to Complete/Close.'');'||chr(10)||
' else'||chr(10)||
'   runJQueryP';

ph:=ph||'opWin(''Complete/Close Selected Activities'',''P5600_ACTION_TYPE,P5600_ACT_LIST,P0_OBJ'',''SEL,''+getActList('':checked'')+'',&P0_OBJ.'',''5600'',600,350);'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ccALL()'||chr(10)||
'{'||chr(10)||
' var pTotalFound=0;'||chr(10)||
''||chr(10)||
' $("input").each(function()'||chr(10)||
'  {'||chr(10)||
'   if($(this).attr(''name'')==''f01'')'||chr(10)||
'     {'||chr(10)||
'      pTotalFound+=1;'||chr(10)||
'      return true;'||chr(10)||
'     }'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' if(pTotalFound<=0)'||chr(10)||
'   alert(''There are no activities to Complete/Close.'');'||chr(10)||
' else'||chr(10)||
'  ';

ph:=ph||' runJQueryPopWin(''Complete/Close ALL Activities'',''P5600_ACTION_TYPE,P5600_ACT_LIST,P0_OBJ'',''ALL,''+getActList('''')+'',&P0_OBJ.'',''5600'',600,350);'||chr(10)||
''||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetAndOpenMenu(e,pThis,pThat,pSub)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                           $v(''pFlowId''),'||chr(10)||
'                           ''APPLICATION_PROCESS=GETREPORTMENUGUTS'','||chr(10)||
'                           $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' get.addParam(''';

ph:=ph||'x01'',pThat); '||chr(10)||
' get.addParam(''x02'',''N'');     '||chr(10)||
' '||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' // Get the Position for the Menu //'||chr(10)||
' if(getInternetExplorerVersion()!==-1) // do if internet explorer //'||chr(10)||
'   {'||chr(10)||
'    var cursorX = event.clientX + $(document).scrollLeft();'||chr(10)||
'    var cursorY = event.clientY + $(document).scrollTop();'||chr(10)||
'   }'||chr(10)||
' else  // do for all other browsers //'||chr(10)||
'   {'||chr(10)||
'    var cursorX = (window.Event) ? e.pageX : event.';

ph:=ph||'clientX + (document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft);'||chr(10)||
'    var cursorY = (window.Event) ? e.pageY : event.clientY + (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);'||chr(10)||
'   }'||chr(10)||
' '||chr(10)||
' // Get the Main Reports UI DOM Element //'||chr(10)||
' var rptList = $(''#mainReportsMenu'');'||chr(10)||
''||chr(10)||
' // Reset the inner LI Elements //'||chr(10)||
'';

ph:=ph||' rptList.html(gReturn);'||chr(10)||
' '||chr(10)||
' // Refresh with the New Returned Menu //'||chr(10)||
' $( "#mainReportsMenu" ).menu("refresh");'||chr(10)||
''||chr(10)||
' // Fade the Menu In //'||chr(10)||
' $(''#mainReportsMenu'').css({''top'':cursorY,''left'':cursorX}).fadeIn(''slow'');'||chr(10)||
''||chr(10)||
' // Reposition just incase it is off the screen //'||chr(10)||
' $(''#mainReportsMenu'').position({of: pThis,'||chr(10)||
'                                 my: "left top",'||chr(10)||
'                                 at: "left to';

ph:=ph||'p", '||chr(10)||
'                                 collision: "fit fit"});'||chr(10)||
' return;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ToggleSubstantive(pActSid)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Check_Access'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pActSid);'||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' if(gReturn==''Y'')'||chr(10)||
'   {'||chr(10)||
'    var get = new html';

ph:=ph||'db_Get(null,'||chr(10)||
'                             $v(''pFlowId''),'||chr(10)||
'                             ''APPLICATION_PROCESS=IsObjectWritable'','||chr(10)||
'                             $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'    get.addParam(''x01'',pActSid);'||chr(10)||
'    gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'    if(gReturn==''Y'')'||chr(10)||
'      {'||chr(10)||
'       if (confirm(''Are you sure you want to change this activity?''))'||chr(10)||
'         {'||chr(10)||
'          var get = new htmldb_Get(null,'||chr(10)||
'      ';

ph:=ph||'                             $v(''pFlowId''),'||chr(10)||
'                                   ''APPLICATION_PROCESS=OSI_ACTIVITY_TOGGLE_SUBSTANTIVE'','||chr(10)||
'                                   $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'          get.addParam(''x01'',pActSid);'||chr(10)||
'          gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'          if(gReturn==''Yes'' || gReturn==''No'')'||chr(10)||
'            {'||chr(10)||
'             $(''#SUB_''+pActSid).text(gReturn);'||chr(10)||
'            } '||chr(10)||
'         ';

ph:=ph||' else'||chr(10)||
'            {'||chr(10)||
'             alert(gReturn);'||chr(10)||
'            }'||chr(10)||
'         }'||chr(10)||
'      }'||chr(10)||
'    else'||chr(10)||
'      {'||chr(10)||
'       alert(''This object is READ ONLY.'');'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function deletionConfirmation()'||chr(10)||
'{'||chr(10)||
' if(isOneSelected()==false)'||chr(10)||
'   alert(''Please select at least one association to delete.'');'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    if(confirm(''Are ';

ph:=ph||'you sure you want to remove the selected associations?''))'||chr(10)||
'      doSubmit(''DELETE_MULTI'');'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' if($(''#P10150_DIALOG'').val()==''Y'')'||chr(10)||
'   {'||chr(10)||
'    $(''.OSITabLevel'').remove();'||chr(10)||
'    $(''.bannerTable'').remove();'||chr(10)||
'    $(''.underbannerbar'').remove();'||chr(10)||
'    $(''.reportbuttons'').remove();'||chr(10)||
'    $(''#Menus'').remove();'||chr(10)||
'    $(''#footpanel'').remove();'||chr(10)||
'    $(''#minbuttononly'').remove();'||chr(10)||
'    $(';

ph:=ph||'''#maxbuttononly'').remove();'||chr(10)||
''||chr(10)||
'    $(".title").each(function()'||chr(10)||
'     {'||chr(10)||
'      if($(this).text()==''Associated Activities'')'||chr(10)||
'        $(this).remove();'||chr(10)||
'     });'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' $( "#mainReportsMenu" ).menu();'||chr(10)||
' $("#mainReportsMenu").mouseleave(function(e)'||chr(10)||
'  {'||chr(10)||
'   $(''#mainReportsMenu'').fadeOut(''slow'');'||chr(10)||
'  });'||chr(10)||
'});'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 10150,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'File Associated Activities',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P10150_SEL_ASSOC.'');"',
  p_step_sub_title => 'File Associated Activities',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'$(window).load(function()'||chr(10)||
'{  '||chr(10)||
' var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
'});'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89997728565512278+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121214131012',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '27-JUL-10 J.Faris Bug 0500 - Fixed typo in P10150_NARRATIVE_UNAVAIL static text.'||chr(10)||
''||chr(10)||
'12-May-2011 Tim Ward - CR#3745/3780 - Added nowrap to date fields of report.'||chr(10)||
'                       Made Narrative width = 100% and added more to the '||chr(10)||
'                       height of the text field (style="height:auto;" '||chr(10)||
'                       doesn''t seem to work).'||chr(10)||
''||chr(10)||
'                       Added "JS_REPORT_AUTO_SCROLL" to HTML '||chr(10)||
'                       Header.  Added onkeydown="return checkForUpDownArrows'||chr(10)||
'                       (event, ''&P10150_SEL_ASSOC.'');" to HTML Body Attribute. '||chr(10)||
'                       Added name=''#SID#'' to "Link Attributes" of the SID '||chr(10)||
'                       Column of the Report. Added a new Branch to'||chr(10)||
'"f?p=&APP_ID.:10150:&SESSION.::&DEBUG.:::#&P10150_SEL_ASSOC.",'||chr(10)||
'                       this allows the report to move the the Anchor '||chr(10)||
'                       of the selected currentrow.'||chr(10)||
''||chr(10)||
'13-Sep-2011 Tim Ward - CR#3905 - Added a Quick View Note Pop-Up Icon to'||chr(10)||
'                       the Report.'||chr(10)||
''||chr(10)||
'04-Oct-2011 - Tim Ward - CR#3919 - Add Report Printing for Activities from '||chr(10)||
'                         the File/Activity Associations sreen.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.'||chr(10)||
''||chr(10)||
'15-Mar-2012 - Tim Ward - CR#4010 - Added Multi Removal.  Added '||chr(10)||
'                          "Delete Associations" Process and renamed'||chr(10)||
'                          "Delete Associations" to "Delete Association".'||chr(10)||
'                          Added Delete Associations Button.'||chr(10)||
''||chr(10)||
'21-Mar-2012 - Carolyn Johnson - CR#3644 - Feedback Message Corrections.'||chr(10)||
'                                 Addded P10150_MESSAGE_TO_USER/_2/_3.'||chr(10)||
'                                 Changed Add Associations Process.'||chr(10)||
''||chr(10)||
'09-May-2012 - Tim Ward - CR#4045 - Added Substantive Field.'||chr(10)||
'                                   Also, hide File ID field if the'||chr(10)||
'                                   only filter is ME.'||chr(10)||
''||chr(10)||
'21-May-2012 - Tim Ward - CR#3599 - Complete/Close All for Sources.  Combined'||chr(10)||
'                                   page 11320 into 10150.'||chr(10)||
''||chr(10)||
'20-Jul-2012 - Tim Ward - Moved Create Activity Menu out to Page 0.'||chr(10)||
'                          Removed superfish stuff from header text.'||chr(10)||
'                          Removed P10150_CREATEMENU.'||chr(10)||
'                          Changed Get Parameters.'||chr(10)||
'                          Removed JS_CREATE_OBJECT.'||chr(10)||
''||chr(10)||
'14-Aug-2012 - Tim Ward - CR#4054 - Added Approval Field.'||chr(10)||
''||chr(10)||
'28-Aug-2012 - Tim Ward - Changed Complete Close to use jQuery Dialog instead'||chr(10)||
'                          of browser pop-up.'||chr(10)||
'                         Combine this with 10155 so we don''t need to keep'||chr(10)||
'                          a separate page for the Associated Activities'||chr(10)||
'                          Right Click Menu Pop Up. '||chr(10)||
'                         Changed IDP Note Pop Up to use jQuery Dialog.'||chr(10)||
''||chr(10)||
''||chr(10)||
'22-Oct-2012 - Tim Ward - CR#4147 - Narrative for Document Reviews and Law'||chr(10)||
'                          Enforcement Records check shouldn''t be editable here '||chr(10)||
'                          and they need to auto generate.'||chr(10)||
'26-Nov-2012 - Tim Ward - CR#4165 - Added Ready for Review Field.'||chr(10)||
'27-Nov-2012 - Tim Ward - CR#4185 - Added Signed Form 40 Attached Field.'||chr(10)||
'28-Nov-2012 - Tim Ward - Changed to jQuery Menu for Reports Popup.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>10150,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 2401416207751675 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_plug_name=> 'Choose the Associations to Display',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P0_OBJ_TYPE_CODE NOT IN (''FILE.SOURCE'')',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 6794424078534921 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_plug_name=> 'Narrative of Selected Activity <font color="red"><i>([shift]+[down]/[up] to navigate narratives)</i></font> &P10150_NARRATIVE_MESSAGE.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 40,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P10150_SEL_ASSOC is not null',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select sid as "SID", '||chr(10)||
'       decode(file_sid, :p0_obj, ''<input type="checkbox" value="'' || sid || ''" name="f01"'' || '' id="'' || activity_sid || ''">'') as "Remove",'||chr(10)||
'       file_id as "File ID",'||chr(10)||
'       decode(file_sid, :p0_obj,''<a href="javascript:ToggleSubstantive('' || '''''''' || activity_sid || '''''''' || '');" id="SUB_'' || activity_sid || ''" title="Toggle Field">'' || decode(substantive,''Y'',''Yes'',''No'') || ';

s:=s||'''</a>'',decode(substantive,''Y'',''Yes'',''No'')) as "Substantive",'||chr(10)||
'       decode(ready_for_review,''Y'',''<div class="requiredlabel">Yes</div>'',''No'') as "Ready for Review",'||chr(10)||
'       decode(leadership_approved,''Y'',''Yes'',''No'') as "Approved",'||chr(10)||
'       decode(form40attached,''Y'',''Yes'',''No'') as "Signed Form 40 Attached",'||chr(10)||
'       activity_id as "Activity ID", '||chr(10)||
'       activity_type_desc as "Type of Activity", '||chr(10)||
'       o';

s:=s||'si_object.get_tagline_link(activity_sid) as "Activity Title",'||chr(10)||
'       activity_date as "Activity Date",'||chr(10)||
'       activity_unit_assigned as "Assigned Unit",'||chr(10)||
'       activity_suspense_date as "Suspense Date", '||chr(10)||
'       activity_complete_date as "Completed", '||chr(10)||
'       activity_close_date as "Closed", '||chr(10)||
'       decode(sid, :P10150_SEL_ASSOC, ''Y'', ''N'') as "Current",'||chr(10)||
'       ''<a href="#" onClick="javascript:runJQu';

s:=s||'eryPopWin(''''IDP Notes'''',''''P5060_OBJ'''','''''' || ACTIVITY_SID || '''''','' || ''''''5060'''');"><img src="#IMAGE_PREFIX#themes/OSI/notes.gif" alt="View IDP Notes"></a>'' as "Notes Pop-Up",'||chr(10)||
'       osi_util.get_report_menu(activity_sid) as "Reports"'||chr(10)||
'  from v_osi_assoc_fle_act &P10150_FILTERS.'||chr(10)||
'union'||chr(10)||
'select sid as "SID", '||chr(10)||
'       decode(file_sid, :p0_obj, ''<input type="checkbox" value="'' || sid || ''" name="f01"'' || ';

s:=s||''' id="'' || activity_sid || ''">'') as "Remove",'||chr(10)||
'       file_id as "File ID",'||chr(10)||
'       decode(file_sid, :p0_obj,''<a href="javascript:ToggleSubstantive('' || '''''''' || activity_sid || '''''''' || '');" id="SUB_'' || activity_sid || ''" title="Toggle Field">'' || decode(substantive,''Y'',''Yes'',''No'') || ''</a>'',decode(substantive,''Y'',''Yes'',''No'')) as "Substantive",'||chr(10)||
'       decode(ready_for_review,''Y'',''<div class="require';

s:=s||'dlabel">Yes</div>'',''No'') as "Ready for Review",'||chr(10)||
'       decode(leadership_approved,''Y'',''Yes'',''No'') as "Approved",'||chr(10)||
'       decode(form40attached,''Y'',''Yes'',''No'') as "Signed Form 40 Attached",'||chr(10)||
'       activity_id as "Activity ID", '||chr(10)||
'       activity_type_desc as "Type of Activity", '||chr(10)||
'       osi_object.get_tagline_link(activity_sid) as "Activity Title",'||chr(10)||
'       activity_date as "Activity Date",'||chr(10)||
'       activi';

s:=s||'ty_unit_assigned as "Assigned Unit",'||chr(10)||
'       activity_suspense_date as "Suspense Date", '||chr(10)||
'       activity_complete_date as "Completed", '||chr(10)||
'       activity_close_date as "Closed", '||chr(10)||
'       decode(sid, :P10150_SEL_ASSOC, ''Y'', ''N'') as "Current",'||chr(10)||
'       ''<a href="#" onClick="javascript:runJQueryPopWin(''''IDP Notes'''',''''P5060_OBJ'''','''''' || ACTIVITY_SID || '''''','' || ''''''5060'''');"><img src="#IMAGE_PREFIX#themes/OS';

s:=s||'I/notes.gif" alt="View IDP Notes"></a>'' as "Notes Pop-Up",'||chr(10)||
'       osi_util.get_report_menu(activity_sid) as "Reports"'||chr(10)||
'  from V_OSI_ASSOC_SOURCE_MEET &P10150_FILTERS_SM.';

wwv_flow_api.create_report_region (
  p_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_name=> 'Associated Activities',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '300000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No associations found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '300000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P10150_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245314419308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245414250308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Remove',
  p_column_display_sequence=> 3,
  p_column_heading=> '<input type="Checkbox" onclick="$f_CheckFirstColumn(this)">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245529601308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'File ID',
  p_column_display_sequence=> 4,
  p_column_heading=> 'File ID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P10150_ASSOCIATION_FILTER IS NOT NULL AND :P10150_ASSOCIATION_FILTER!=''ME''',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13689902695914164 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Substantive',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Substantive',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17775008546664395 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Ready for Review',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Ready For<br>Review',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15912914399025167 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Approved',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Approved',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245620631308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Activity ID',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Activity ID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>2,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245715256308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Type of Activity',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Type of Activity',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245816184308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Title',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Activity Title',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245907378308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Date',
  p_column_display_sequence=> 12,
  p_column_heading=> 'Activity Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246007468308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Assigned Unit',
  p_column_display_sequence=> 13,
  p_column_heading=> 'Assigned Unit',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246111752308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 13,
  p_form_element_id=> null,
  p_column_alias=> 'Suspense Date',
  p_column_display_sequence=> 14,
  p_column_heading=> 'Suspense Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246230319308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 14,
  p_form_element_id=> null,
  p_column_alias=> 'Completed',
  p_column_display_sequence=> 15,
  p_column_heading=> 'Completed',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246318586308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 15,
  p_form_element_id=> null,
  p_column_alias=> 'Closed',
  p_column_display_sequence=> 16,
  p_column_heading=> 'Closed',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246408515308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 16,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 17,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246513515308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 17,
  p_form_element_id=> null,
  p_column_alias=> 'Notes Pop-Up',
  p_column_display_sequence=> 2,
  p_column_heading=> '&nbsp;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8253431837864029 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 18,
  p_form_element_id=> null,
  p_column_alias=> 'Reports',
  p_column_display_sequence=> 18,
  p_column_heading=> 'Reports',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17805112322707517 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 18,
  p_form_element_id=> null,
  p_column_alias=> 'Signed Form 40 Attached',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Signed Form<br>40 Attached',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89681107763812106 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 10,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Association',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_condition=> ':P10150_USER_HAS_ADD_ASSOC_PRV = ''Y'''||chr(10)||
'and'||chr(10)||
':P0_OBJ_TYPE_CODE NOT IN (''FILE.SOURCE'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="AssocActAdd" onClick="javascript:openLocator(''301'',''P10150_ASSOC_ACT'',''Y'',''&P10150_EXCLUDE_SIDS.'',''OPEN'','''','''',''Choose Activities...'',''ACT'',''&P0_OBJ.'');"',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_button_comment=>'javascript:popupLocator(300,''P10150_ASSOC_ACT'',''Y'',''&P10150_EXCLUDE_SIDS.'');'||chr(10)||
''||chr(10)||
'javascript:popup({page:150,'||chr(10)||
'                      name:''ASSOC&P0_OBJ.'','||chr(10)||
'                      clear_cache:''150'','||chr(10)||
'                      item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'','||chr(10)||
'item_values:''OSI.LOC.ACT,P10150_ASSOC_ACT,&P10150_EXCLUDE_SIDS.''});',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6734629761804450 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 40,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'CC_SEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Complete and Close Selected Activities',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_cattributes=>'id="ccSelButton" onClick="javascript:ccSelected();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6738907897119887 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 50,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'CC_ALL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Complete and Close All Activities',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_cattributes=>'id="ccAllButton" onClick="javascript:ccALL();"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 12169205577672840 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 110,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Association(s)',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '#',
  p_button_condition=> ':P0_OBJ_TYPE_CODE NOT IN (''FILE.SOURCE'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="AssocActDelete" onClick="deletionConfirmation();"',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6862013070205275 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 70,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_cattributes=>'id="AssocActCancel"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6861415709196515 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 80,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P10150_NAR_WRITABLE = ''Y'''||chr(10)||
'and'||chr(10)||
':P10150_ACT_IS_RESTRICTED <> ''Y'''||chr(10)||
'and'||chr(10)||
':P10150_ACT_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="AssocActSave"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6886528193401900 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 90,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Association',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P10150_ACTIVITY_IS_INHERITED <> ''Y'''||chr(10)||
'and'||chr(10)||
':P0_OBJ_TYPE_CODE NOT IN (''FILE.SOURCE'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_button_cattributes=>'id="AssocActDeleteSel"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15698111556878178 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 100,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 10150);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89394529572684714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 17:07 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>5505629590450153 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:10150:&SESSION.::&DEBUG.:::#&P10150_SEL_ASSOC.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 15,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST = ''SAVE'' OR :REQUEST LIKE ''EDIT_%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-DEC-2009 15:58 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>5571516155664872 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:10150:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 29-APR-2009 13:45 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2401708022751679 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ASSOCIATION_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 2401416207751675+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ME',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Activities for this File;ME,Inherited Activities;I_ACT',
  p_lov_columns=> 4,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''UPDATE'');"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2402416254780095 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_FILTERS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_FILTERS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6747927636475617 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_ACT_LIST',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6793832258527885 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_SEL_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_SEL_ASSOC',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6794710703540540 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 85,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10000,
  p_cMaxlength=> 30000,
  p_cHeight=> 15,
  p_tag_attributes  => '&P10150_NARRATIVE_STYLE.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P10150_ACT_IS_RESTRICTED <> ''Y'''||chr(10)||
'and'||chr(10)||
':P10150_USER_HAS_ACT_ACCESS_PRV = ''Y''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6795132520546882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 84,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6860502634173814 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NAR_WRITABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 83,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6871326968587746 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_IS_RESTRICTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 81,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6873607538629464 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE_UNAVAIL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 86,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative',
  p_source=>'This activity is restricted and the Narrative is not viewable from this screen. <br> Please open the activity to view the Narrative.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap" style="width:99%;"',
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P10150_ACT_IS_RESTRICTED = ''Y'' or'||chr(10)||
':P10150_ACT_IS_RESTRICTED is null',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6887606647490262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACTIVITY_IS_INHERITED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 82,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7143022926607964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_FAILURE_COUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_ERROR_DETECTED',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7190808782826134 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_USER_HAS_ACT_ACCESS_PRV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_USER_HAS_ACT_ACCESS_PRV',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7192019012942668 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_USER_HAS_ADD_ASSOC_PRV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_USER_HAS_ADD_ASSOC_PRV',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8250609739619477 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_REPORTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 87,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_util.get_report_menu(:P10150_ACT_SID);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when_type=>'NEVER',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12314423010727898 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER ',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12314632014730469 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER_2',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12314805826732391 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER_3',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13785330101002628 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_FILTERS_SM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 97,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_FILTERS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15698319521880437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16243712081958568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_DIALOG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 107,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17179916305330756 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE_STYLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 117,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17180411419376689 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 127,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17454926876359612 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE_MESSAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 137,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89680926290812099 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ASSOC_ACT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Assoc File',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>89755622150846418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_EXCLUDE_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_EXCLUDE_SIDS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6523830657956645 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_validation_name => 'Selected Activities - Assure Something Selected',
  p_validation_sequence=> 10,
  p_validation => 'begin'||chr(10)||
'    if (apex_application.g_f01.count >= 1) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'No activities have been selected.',
  p_when_button_pressed=> 6734629761804450 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6754527420835112 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_validation_name => 'Assure Activities Exist (For CC/All only)',
  p_validation_sequence=> 20,
  p_validation => 'declare'||chr(10)||
'    v_cnt   number;'||chr(10)||
'begin'||chr(10)||
'    select count(sid)'||chr(10)||
'      into v_cnt'||chr(10)||
'      from v_osi_assoc_fle_act'||chr(10)||
'     where file_sid = :p0_obj;'||chr(10)||
''||chr(10)||
'    if (v_cnt >= 1) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'No Activites exist that may be closed.',
  p_when_button_pressed=> 6738907897119887 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'update t_osi_activity set narrative=:p10150_narrative'||chr(10)||
' where sid = :p10150_act_sid;';

wwv_flow_api.create_page_process(
  p_id     => 7712912109312509 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Narrative',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>6861415709196515 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'       v_temp            varchar2(4000);'||chr(10)||
'       v_act_sid         t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'       v_failure_count   number                                  := 0;'||chr(10)||
'       v_failed_acts     varchar2(4000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     v_temp := replace(:p10150_assoc_act, '':'', ''~'');'||chr(10)||
'     :P10150_MESSAGE_TO_USER_3 := '''';'||chr(10)||
'     :P10150_FAILURE_COUNT := 0;'||chr(10)||
'     :P10150_MESSAGE_TO_USER := ''All Activi';

p:=p||'ties were associated.'';'||chr(10)||
'     :P10150_MESSAGE_TO_USER_2 := '''';'||chr(10)||
'     v_failed_acts := ''Titles of Failed Activities: '';'||chr(10)||
''||chr(10)||
'     for i in 1 .. core_list.count_list_elements(v_temp)'||chr(10)||
'     loop'||chr(10)||
'         v_act_sid := core_list.get_list_element(v_temp,i);'||chr(10)||
''||chr(10)||
'         for k in (select restriction from t_osi_activity where sid = v_act_sid)'||chr(10)||
'         loop'||chr(10)||
'             if (osi_reference.lookup_ref_code(k.restrictio';

p:=p||'n) = ''NONE'') then'||chr(10)||
'  '||chr(10)||
'               insert into t_osi_assoc_fle_act (activity_sid, file_sid) values (v_act_sid, :p0_obj);'||chr(10)||
''||chr(10)||
'             else'||chr(10)||
''||chr(10)||
'               v_failure_count := v_failure_count + 1;'||chr(10)||
'               v_failed_acts := v_failed_acts || osi_activity.get_title(v_act_sid) || ''. '';'||chr(10)||
''||chr(10)||
'             end if;'||chr(10)||
''||chr(10)||
'         end loop;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAG';

p:=p||'E_ID, '''');'||chr(10)||
'     :P10150_FAILURE_COUNT := v_failure_count;'||chr(10)||
''||chr(10)||
'     if :P10150_FAILURE_COUNT > 0 then'||chr(10)||
'  '||chr(10)||
'       :P10150_MESSAGE_TO_USER_2 :=  ''Associate these activities to this file from the activity itself.'';'||chr(10)||
'       :P10150_MESSAGE_TO_USER   := ''Note: ['' || :P10150_FAILURE_COUNT || ''] activities were not associated due to restriction.'';'||chr(10)||
'       :P10150_MESSAGE_TO_USER_3 :=  v_failed_acts;'||chr(10)||
''||chr(10)||
'     end i';

p:=p||'f;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89696016285177781 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Associations',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'P10150_ASSOC_ACT',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG. <br> &P10150_MESSAGE_TO_USER. <br> &P10150_MESSAGE_TO_USER_2.  <br><br> &P10150_MESSAGE_TO_USER_3.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'OSI.LOC.ACT'||chr(10)||
''||chr(10)||
'declare'||chr(10)||
'    v_temp            varchar2(4000);'||chr(10)||
'    v_act_sid         t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'    v_failure_count   number                                  := 0;'||chr(10)||
'begin'||chr(10)||
'    v_temp := replace(:p10150_assoc_act, '':'', ''~'');'||chr(10)||
'    :P10150_FAILURE_COUNT := 0;'||chr(10)||
''||chr(10)||
'    for i in 1 .. core_list.count_list_elements(v_temp)'||chr(10)||
'    loop'||chr(10)||
'        v_act_sid := core_list.get_list_element(v_temp,i);'||chr(10)||
''||chr(10)||
'        for k in (select restriction'||chr(10)||
'                    from t_osi_activity'||chr(10)||
'                   where sid = v_act_sid)'||chr(10)||
'        loop'||chr(10)||
'            if (osi_reference.lookup_ref_code(k.restriction) = ''NONE'') then'||chr(10)||
'                insert into t_osi_assoc_fle_act'||chr(10)||
'                            (activity_sid, file_sid)'||chr(10)||
'                     values (v_act_sid, :p0_obj);'||chr(10)||
'            else'||chr(10)||
'                v_failure_count := v_failure_count + 1;'||chr(10)||
'            end if;'||chr(10)||
'        end loop;'||chr(10)||
'    end loop;'||chr(10)||
'    :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAGE_ID, '''');'||chr(10)||
'    :P10150_FAILURE_COUNT := v_failure_count;'||chr(10)||
'end;'||chr(10)||
''||chr(10)||
''||chr(10)||
'&SUCCESS_MSG. <br> Note: [&P10150_FAILURE_COUNT.] activities were not associated due to restriction.  <br> If any exist, associate these activities to this file from the activity itself.'||chr(10)||
''||chr(10)||
'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'        delete from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'              where sid = :P10150_SEL_ASSOC;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89695812822176774 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Association',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'DELETE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_temp    varchar2(4000)                          := ''~'';'||chr(10)||
'    v_temp2   t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'begin'||chr(10)||
'     if (:request = ''CC_SEL'') then'||chr(10)||
''||chr(10)||
'       for i in 1 .. apex_application.g_f01.count'||chr(10)||
'       loop'||chr(10)||
'           if :p0_obj_type_code=''FILE.SOURCE'' then'||chr(10)||
''||chr(10)||
'             v_temp2 := apex_application.g_f01(i);'||chr(10)||
''||chr(10)||
'           else'||chr(10)||
'  '||chr(10)||
'             select activity_sid into v_temp2 from';

p:=p||' t_osi_assoc_fle_act where sid = apex_application.g_f01(i);'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
''||chr(10)||
'           v_temp := v_temp || v_temp2 || ''~'';'||chr(10)||
''||chr(10)||
'       end loop;'||chr(10)||
''||chr(10)||
'     elsif(:request = ''CC_ALL'') then'||chr(10)||
''||chr(10)||
'          if :p0_obj_type_code=''FILE.SOURCE'' then'||chr(10)||
''||chr(10)||
'            for k in (select activity_sid from v_osi_assoc_source_meet where file_sid=:p0_obj)'||chr(10)||
'            loop'||chr(10)||
''||chr(10)||
'                v_temp := v_temp || k.activity_sid ';

p:=p||'|| ''~'';'||chr(10)||
''||chr(10)||
'            end loop;'||chr(10)||
''||chr(10)||
'          else'||chr(10)||
''||chr(10)||
'            for k in (select activity_sid from v_osi_assoc_fle_act where file_sid = :p0_obj)'||chr(10)||
'            loop'||chr(10)||
''||chr(10)||
'                v_temp := v_temp || k.activity_sid || ''~'';'||chr(10)||
''||chr(10)||
'            end loop;'||chr(10)||
'         '||chr(10)||
'          end if;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p10150_act_list := v_temp;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6748104218478317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Activity List - CC',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''CC_SEL'', ''CC_ALL'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    for I in 1 .. HTMLDB_APPLICATION.G_F01.count'||chr(10)||
'    loop'||chr(10)||
'        delete from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'              where sid = HTMLDB_APPLICATION.G_F01 (I);'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 12168928648670019 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Associations',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'DELETE_MULTI',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'P10150_SEL_ASSOC,P10150_ASSOC_ACT,P10150_ACT_SID,P10150_NAR_WRITABLE,P10150_NARRATIVE';

wwv_flow_api.create_page_process(
  p_id     => 6863323375227179 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''DELETE'') or :REQUEST like ''EDIT_%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'     :P10150_SEL_ASSOC := substr(:request, 6);'||chr(10)||
'    '||chr(10)||
'     if :p0_obj_type_code=''FILE.SOURCE'' then'||chr(10)||
''||chr(10)||
'       :p10150_act_sid := :P10150_SEL_ASSOC;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       select activity_sid, activity_type_code'||chr(10)||
'         into :p10150_act_sid, :p10150_act_type_code'||chr(10)||
'         from v_osi_assoc_fle_act'||chr(10)||
'        where sid = substr(:request, 6);'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     --- Check for privileges ---'||chr(10)||
'     if (:p1015';

p:=p||'0_act_sid is not null) then'||chr(10)||
''||chr(10)||
'       :p10150_user_has_act_access_prv := osi_auth.check_for_priv(''ACCESS'', core_obj.get_objtype(:p10150_act_sid));'||chr(10)||
' '||chr(10)||
'     else'||chr(10)||
' '||chr(10)||
'       :p10150_user_has_act_access_prv := ''N'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if (:P10150_ACT_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'')) then'||chr(10)||
''||chr(10)||
'       --:P5150_NARRATIVE_LABEL:= ''Narrative Text (Document Review builds this automatically):'';'||chr(10)||
'       :P10150_NA';

p:=p||'RRATIVE := OSI_DOCUMENT_REVIEW.GET_NARRATIVE(:P10150_ACT_SID);'||chr(10)||
'       :P10150_NARRATIVE_STYLE := ''readOnly style="background-color:#f5f4ea; height:auto; width:100%; rows:30;"'';'||chr(10)||
'       :P10150_NARRATIVE_MESSAGE := '' ** Document Review Narrative NOT editable here, please open the activity **'';'||chr(10)||
''||chr(10)||
'     elsif (:P10150_ACT_TYPE_CODE IN (''ACT.RECORDS_CHECK'')) then'||chr(10)||
''||chr(10)||
'          ---:P5150_NARRATIVE_LABEL:= ''N';

p:=p||'arrative Text (Records Check builds this automatically):'';'||chr(10)||
'          :P10150_NARRATIVE := OSI_RECORDS_CHECK.GET_NARRATIVE(:P10150_ACT_SID);'||chr(10)||
'          :P10150_NARRATIVE_STYLE := ''readOnly style="background-color:#f5f4ea; height:auto; width:100%; rows:30;"'';'||chr(10)||
'          :P10150_NARRATIVE_MESSAGE := '' ** Law Enforcements Record Check Narrative NOT editable here, please open the activity **'';'||chr(10)||
''||chr(10)||
'     else';

p:=p||''||chr(10)||
''||chr(10)||
'       --:P5150_NARRATIVE_LABEL:= ''Narrative Text (Document Review builds this automatically):'';'||chr(10)||
'       select narrative into :P10150_NARRATIVE from t_osi_activity where sid=:P10150_ACT_SID;'||chr(10)||
'       :P10150_NARRATIVE_STYLE := ''style="height:auto; width:100%; rows:30;"'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6793523254525212 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Association',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'P10150_NARRATIVE';

wwv_flow_api.create_page_process(
  p_id     => 6862823936217884 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Fields - On Cancel',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>6862013070205275 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'     --- Get Writability ---'||chr(10)||
'     if (:p10150_act_sid is not null) then'||chr(10)||
' '||chr(10)||
'      :p10150_nar_writable := osi_object.check_writability(:p10150_act_sid, null);'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
'     '||chr(10)||
'       :p10150_nar_writable := ''N'';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'    --- Get Restriction ---'||chr(10)||
'    for k in (select restriction from t_osi_activity where sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        if (osi_reference.lookup_ref_code(k.restri';

p:=p||'ction) = ''NONE'') then'||chr(10)||
'  '||chr(10)||
'          :p10150_act_is_restricted := ''N'';'||chr(10)||
''||chr(10)||
'        else'||chr(10)||
''||chr(10)||
'          :p10150_act_is_restricted := ''Y'';'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    --- See if selected activity is inherited ---'||chr(10)||
'    :p10150_activity_is_inherited := ''Y'';'||chr(10)||
''||chr(10)||
'    for k in (select * from t_osi_assoc_fle_act where file_sid = :p0_obj and activity_sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        :p10150_activity_is_';

p:=p||'inherited := ''N'';'||chr(10)||
'        return;'||chr(10)||
''||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    --- Get privileges ---'||chr(10)||
'    :P10150_USER_HAS_ADD_ASSOC_PRV := osi_auth.check_for_priv(''ASSOC_ACT'', :P0_OBJ_TYPE_SID);'||chr(10)||
'    '||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6860713023176854 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Parameters',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_add_or   boolean := false;'||chr(10)||
'begin'||chr(10)||
'    :p10150_filters := ''where '';'||chr(10)||
'    '||chr(10)||
'    if :p0_obj_type_code = ''FILE.SOURCE'' then'||chr(10)||
''||chr(10)||
'      :p10150_filters_sm := '' WHERE FILE_SID='' || '''''''' || :P0_OBJ || '''''' '';'||chr(10)||
'      :p10150_filters := '' WHERE 1=2 '';'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
''||chr(10)||
'      :p10150_filters_sm := '' WHERE 1=2 '';'||chr(10)||
'      if (instr(:p10150_association_filter, ''ME'') > 0 or :P10150_ASSOCIATION_FILTER is null ) then';

p:=p||''||chr(10)||
''||chr(10)||
'        v_add_or := true;'||chr(10)||
'        :p10150_filters := :p10150_filters || '' FILE_SID = '' || '''''''' || :P0_OBJ || '''''''';'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'      if (instr(:p10150_association_filter, ''I_ACT'') > 0) then'||chr(10)||
'  '||chr(10)||
'        if (v_add_or) then'||chr(10)||
''||chr(10)||
'          :p10150_filters := :p10150_filters || '' or '';'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p10150_filters := :p10150_filters || '' activity_sid in(select activity_sid from v_osi_asso';

p:=p||'c_fle_act where file_sid in(select that_file'||chr(10)||
'                                       from v_osi_assoc_fle_fle where this_file = '''''' || :p0_obj || ''''''))'';'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 2402129282774346 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Build WHERE clause',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    V_SID_LIST   clob :=''SIDS_'';--varchar2 (5000) := ''SIDS_'';'||chr(10)||
'begin'||chr(10)||
'    for K in (select ACTIVITY_SID'||chr(10)||
'                from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'               where FILE_SID = :P0_OBJ)'||chr(10)||
'    loop'||chr(10)||
'        V_SID_LIST := V_SID_LIST || ''~'' || K.ACTIVITY_SID;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    :P10150_EXCLUDE_SIDS := V_SID_LIST;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89756414232872546 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Exclude SID List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 10150
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done
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
--   Date and Time:   10:00 Thursday November 29, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
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

PROMPT ...Remove page 20000
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>20000);
 
end;
/

 
--application/pages/page_20000
prompt  ...PAGE 20000: Activity Summary
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_SEND_REQUEST"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
'function restrictionWarning()'||chr(10)||
'{'||chr(10)||
' alert(''Please coordinate with HQ OPR before restricting this object'');'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function clearReadyForReview()'||chr(10)||
'{'||chr(10)||
' if($("#P20000_APPROVED_0").attr("checked")=="checked")'||chr(10)||
'   $("#P20000_READY_FOR_REVIEW_0").removeAttr("checked");'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 20000,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Activity Summary',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89997626141511567+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121126133621',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '25-AUG-2010  J.Faris CHG0003228 - Updated P20000_DATE_LABEL to handle Open Case Checklist, AV support object types.'||chr(10)||
'04-OCT-2010  J.Faris CHG0003243 - Updated P20000_DATE_LABEL to handle all remaining activity types.'||chr(10)||
'06-OCT-2010  J.Faris   WCHG0000397 - Integrated Tim Ward''s page updates (involved re-apply of Export button functionality).'||chr(10)||
'07-OCT-2010 J.FARIS WCHG0000360 - Disabled date picker. Removed validation.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - Tim Ward - CR#3822 - Two Items Open at Same Time overwrite :P0_OBJ '||chr(10)||
'                          and cause problems.  Changed all Branching to pass :P0_OBJ.'||chr(10)||
''||chr(10)||
'19-Jan-2012 - Tim Ward - CR#3990 - Enable Restriction for AAPP.'||chr(10)||
''||chr(10)||
'30-Apr-2012 - Tim Ward - CR#4043 - Added Time to Effective Date and Date '||chr(10)||
'                          Recorded.'||chr(10)||
''||chr(10)||
'08-May-2012 - Tim Ward - CR#4045 - Added Substantive checkbox.'||chr(10)||
''||chr(10)||
'06-Jul-2012 - Tim Ward - Added Optional Hover Help Label to Restriction.'||chr(10)||
''||chr(10)||
'14-Aug-2012 - Tim Ward - CR#4054 - Added Approval Field.'||chr(10)||
'03-Oct-2012 - Tim Ward - CR#4054 - Hide Approval Field for Consultations.'||chr(10)||
'26-Nov-2012 - Tim Ward - CR#4165 - Added Ready for Review Field.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>20000,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 91905523013189660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 20000,
  p_plug_name=> '&P20000_ACTIVITY_DESCRIPTION. Activity',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select transition_comment "Action",'||chr(10)||
'       create_by "Performed By",'||chr(10)||
'       effective_on "Effective Date",'||chr(10)||
'       create_on "Date Recorded"'||chr(10)||
'  from t_osi_status_history'||chr(10)||
' where obj = :P0_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 20000,
  p_name=> 'Activity History',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'QUERY_COLUMNS',
  p_query_num_rows=> '100000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No history found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '100000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P20000_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996144410883352 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'Action',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Action',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996215715883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Performed By',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Performed By',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996316299883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Effective Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Effective Date',
  p_column_format=> '&FMT_DATE.  hh24:mi:ss',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996436580883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Date Recorded',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Date Recorded',
  p_column_format=> '&FMT_DATE. hh24:mi:ss',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 91905830978191904 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 10,
  p_button_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16595501977703906 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 30,
  p_button_plug_id => 93995815537883335+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 20000);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 98438532224060568 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 20,
  p_button_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>91814539429626660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>91906139636194429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.::&DEBUG.::P0_OBJ:&P20000_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>91905830978191904+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 17-APR-2009 12:55 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>92847723654200564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P20000_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 30,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-MAY-2009 13:02 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3119025248737365 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 23,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5431035720360469 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION_LOCKOUT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction Lockout',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13686321518853353 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SUBSTANTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Substantive Investigative Activity?',
  p_source=>'SUBSTANTIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2: ;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15911500538945477 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_APPROVED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Leadership Approved?',
  p_source=>'LEADERSHIP_APPROVED',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2: ;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => '&P20000_APPROVED_LOCKED. onclick="clearReadyForReview();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE NOT LIKE ''ACT.CONSULTATION%''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15914029992105458 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_APPROVED_LOCKED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16595722755709887 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 93995815537883335+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17771917176439791 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_READY_FOR_REVIEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Ready for Review?',
  p_source=>'READY_FOR_REVIEW',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2: ;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE NOT LIKE ''ACT.CONSULTATION%''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91940231689043741 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATE_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Created By',
  p_source=>'CREATE_BY',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91940416236048785 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATING_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Creating Unit',
  p_source=>'CREATING_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91944639569415069 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CURRENT_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Current Status',
  p_source=>'CURRENT_STATUS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91944839694415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATE_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 19,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Created',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'CREATE_ON',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945042497415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ASSIGNED_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Assigned Unit',
  p_source=>'ASSIGNED_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945235641415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_AUXILIARY_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Auxiliary Unit',
  p_source=>'AUXILIARY_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945435701415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SUSPENSE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Suspense Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'SUSPENSE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945636024415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_COMPLETE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 21,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Completed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'COMPLETE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91945843973415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CLOSE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 22,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Closed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'CLOSE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
h := null;
h:=h||'Please coordinate with HQ OPR before restricting this object.';

wwv_flow_api.create_page_item(
  p_id=>91946019995415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction',
  p_source=>'RESTRICTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P20000_RESTRICTION_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_tag_attributes  => '&P20000_RESTRICTION_LOCKOUT. onchange="restrictionWarning()"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 1591526640502753+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_help_text   => h,
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>91946237380415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_INV_SUPPORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Investigative Support',
  p_source=>'INV_SUPPORT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'CHECKBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_mission_category'||chr(10)||
' where notification_area = ''Y'''||chr(10)||
' order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 7,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 10,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT-TOP',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94784018045123213 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char('||chr(10)||
'   to_date(:P20000_ACTIVITY_DATE_VALUE, :FMT_DATE || '' '' || :FMT_TIME), '||chr(10)||
'   :FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'&P20000_DATE_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 12,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94791034518317174 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>94932146476602702 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_DATE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'begin'||chr(10)||
'  case '||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.INTERVIEW.%'' then'||chr(10)||
'         return ''Interview Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE in (''ACT.DOCUMENT_REVIEW'','||chr(10)||
'                                 ''ACT.RECORDS_CHECK'','||chr(10)||
'                                 ''ACT.CC_REVIEW'','||chr(10)||
'                                 ''ACT.OC_REVIEW'') then'||chr(10)||
'          return ''Review Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''ACT.BRIEFING'' then'||chr(10)||
'          return ''Briefing Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''ACT.SURVEILLANCE'' then'||chr(10)||
'          return ''Requested Start Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.FINGERPRINT.%'' then'||chr(10)||
'         return ''Date Fingerprints Taken'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.SUSPACT_REPORT'' then'||chr(10)||
'         return ''Report Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.AV_SUPPORT'' then'||chr(10)||
'         return ''Date Request Received'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.COMP_INTRUSION'' then'||chr(10)||
'         return ''CCI Notified Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.INIT_NOTIF'' then'||chr(10)||
'        return ''Notified On'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.SOURCE_MEET'' then'||chr(10)||
'        return ''Meet Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.SEARCH%'' then'||chr(10)||
'        return ''Search Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.LIAISON'' then'||chr(10)||
'        return ''Liaison Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.CONSULTATION.%'' then'||chr(10)||
'        return ''Consultation Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.COORDINATION.%'' then'||chr(10)||
'        return ''Coordination Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.POLY_EXAM'' then'||chr(10)||
'        return ''Exam Date'';'||chr(10)||
'   else'||chr(10)||
'        return ''Activity Date'';'||chr(10)||
'   end case;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>96473438013419564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Title',
  p_post_element_text=>'<td rowspan=10 width="40px"></td>',
  p_source=>'TITLE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>97057333623584254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>101984118218814233 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DATE_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_format_mask=>'&FMT_DATE. &FMT_TIME.',
  p_source=>'ACTIVITY_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 17733929408342681 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_computation_sequence => 10,
  p_computation_item=> 'P20000_ACTIVITY_DATE_VALUE',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select :P20000_ACTIVITY_DATE || '' '' ||'||chr(10)||
'       to_char(activity_date, :FMT_TIME)'||chr(10)||
'  from t_osi_activity'||chr(10)||
' where sid = :P0_OBJ',
  p_compute_when => ':REQUEST = ''SAVE'' and :P20000_ACTIVITY_DATE is not null',
  p_compute_when_type=>'PLSQL_EXPRESSION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96473647363422286 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_validation_name => 'P20000_TITLE not null',
  p_validation_sequence=> 5,
  p_validation => 'P20000_TITLE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Title must be specified.',
  p_when_button_pressed=> 91905830978191904 + wwv_flow_api.g_id_offset,
  p_associated_item=> 96473438013419564 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:V_OSI_ACTIVITY_SUMMARY:P20000_SID:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 94795040208479739 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Activity Summary',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>91905830978191904 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'F|#OWNER#:V_OSI_ACTIVITY_SUMMARY:P0_OBJ:SID';

wwv_flow_api.create_page_process(
  p_id     => 94790725729305191 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Activity Summary',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
''||chr(10)||
'  :p20000_sid := :p0_obj;'||chr(10)||
''||chr(10)||
'  :p20000_restriction_lov := osi_reference.get_lov(''RESTRICTION'');'||chr(10)||
''||chr(10)||
'  :p20000_restriction_lockout := null;'||chr(10)||
''||chr(10)||
'  select description into :P20000_ACTIVITY_DESCRIPTION '||chr(10)||
'        from t_core_obj_type '||chr(10)||
'        where sid=:P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'  if osi_auth.check_for_priv(''APPROVE'',:P0_OBJ_TYPE_SID)=''N'' then'||chr(10)||
''||chr(10)||
'    :P20000_APPROVED_LOCKED:=''disabled="disabled"'';'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    :P2';

p:=p||'0000_APPROVED_LOCKED:='''';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 97049319144409735 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    for x in (select default_title'||chr(10)||
'                from t_osi_obj_type'||chr(10)||
'               where (   sid = :p0_obj_type_sid'||chr(10)||
'                      or sid member of osi_object.get_objtypes(:p0_obj_type_sid))'||chr(10)||
'                 and default_title is not null)'||chr(10)||
'    loop'||chr(10)||
'        :p20000_title := x.default_title;'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 9338207557266457 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 1,
  p_process_point=> 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Reset title',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST = ''SAVE'' AND :P20000_TITLE IS NULL',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 20000
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done



commit;