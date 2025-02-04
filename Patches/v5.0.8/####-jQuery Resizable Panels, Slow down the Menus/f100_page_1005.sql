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
--   Date and Time:   06:09 Friday January 25, 2013
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>1044521331756659);
 
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
  p_last_upd_yyyymmddhh24miss => '20130125060829',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '01-Apr-2011 - TJW - CR#3688 - Notifications Link on Desktop doesn''t have count.'||chr(10)||
''||chr(10)||
'30-Mar-2012 - TJW - CR#3738 - Active and All Desktop Filters.'||chr(10)||
'                     Changed all the links to pass the Navigation and'||chr(10)||
'                     the Files Link to pass a Title.'||chr(10)||
''||chr(10)||
'01-Nov-2012 - TJW - CR#0000 - Copied from 1000 to 1005.  The new page 1000 has '||chr(10)||
'                     a splitter to allow this page desktop pages like'||chr(10)||
'                     this one to display in an iframe now.'||chr(10)||
''||chr(10)||
'29-Nov-2012 - TJW - Changed Setup Menu Width from 160px to 200px as Search for '||chr(10)||
'                     Participants was wrapping.'||chr(10)||
''||chr(10)||
'25-Jan-2013 - WCC - Changed Activities Query for Speed purposes.  Increased'||chr(10)||
'                     the query from seconds to milliseconds.');
 
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
'   and at.close_date is null',
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
  p_item_comment => 'select count(distinct at.sid)'||chr(10)||
'  from t_osi_assignment a, t_osi_activity at'||chr(10)||
' where a.personnel = core_context.personnel_sid'||chr(10)||
'   and a.end_date is null'||chr(10)||
'   and a.obj = at.sid'||chr(10)||
'   and osi_object.get_status_code(at.sid) <> ''CL'';');
 
 
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
