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
--   Date and Time:   07:47 Tuesday March 6, 2012
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

PROMPT ...Remove page 99999999
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>99999999);
 
end;
/

 
--application/pages/page_99999
prompt  ...PAGE 99999999: JQuery/DOJO Testing Page
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 99999999,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'JQuery/DOJO Testing Page',
  p_alias  => 'JQUERYTESTINGPAGE',
  p_step_title=> 'JQuery Testing Page',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120223120056',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>99999999,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<style>'||chr(10)||
'    #sortable {'||chr(10)||
'               list-style-type: none; '||chr(10)||
'               margin: 0; '||chr(10)||
'               padding: 0; '||chr(10)||
'               width: 100%; '||chr(10)||
'              }'||chr(10)||
''||chr(10)||
' #sortable li { '||chr(10)||
'               margin: 0 1px 1px 1px; '||chr(10)||
'               padding: 0.4em; '||chr(10)||
'               padding-left: 1.5em;'||chr(10)||
'               font-size: 1.0em; '||chr(10)||
'               height: 12px; '||chr(10)||
'              }'||chr(10)||
''||chr(10)||
' #sortable li span '||chr(10)||
'           ';

s:=s||'       { '||chr(10)||
'                   position: absolute; '||chr(10)||
'                   margin-left: -1.3em; '||chr(10)||
'                  }'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<script>'||chr(10)||
''||chr(10)||
' $(function() {'||chr(10)||
'               $("#sortable").sortable({placeholder: "ui-state-highlight"});'||chr(10)||
'               //$("#sortable").disableSelection();'||chr(10)||
'	       $("#sortable").selectable();'||chr(10)||
''||chr(10)||
'	      });'||chr(10)||
''||chr(10)||
''||chr(10)||
' function getList()'||chr(10)||
' {'||chr(10)||
'  var msg='''';'||chr(10)||
'  var sortedList = $(''#sortable'').so';

s:=s||'rtable(''toArray'');'||chr(10)||
''||chr(10)||
'  for ( var i=0, len=sortedList.length; i<len; ++i )'||chr(10)||
'     {'||chr(10)||
'      msg=msg+''i=''+i+'', value=''+sortedList[i]+''\n'';'||chr(10)||
'     }'||chr(10)||
'  alert(msg);'||chr(10)||
' }'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<div class="demo">'||chr(10)||
' <ul id="sortable">'||chr(10)||
'  <li id="001" class="ui-state-default">Item 001</li>'||chr(10)||
'  <li id="002" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 002</li>'||chr(10)||
'  <li id="003" class="ui-state-';

s:=s||'default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 003</li>'||chr(10)||
'  <li id="004" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 004</li>'||chr(10)||
'  <li id="005" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 005</li>'||chr(10)||
'  <li id="006" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 006</li>';

s:=s||''||chr(10)||
'  <li id="007" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 007</li>'||chr(10)||
'  <li id="008" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 008</li>'||chr(10)||
'  <li id="009" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 009</li>'||chr(10)||
'  <li id="010" class="ui-state-default"><span class="ui-icon ui-icon-arrowt';

s:=s||'hick-2-n-s"></span>Item 010</li>'||chr(10)||
'  <li id="011" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 011</li>'||chr(10)||
'  <li id="012" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 012</li>'||chr(10)||
'  <li id="013" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 013</li>'||chr(10)||
'  <li id="014" class="ui-state-default"><sp';

s:=s||'an class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 014</li>'||chr(10)||
'  <li id="015" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 015</li>'||chr(10)||
'  <li id="016" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 016</li>'||chr(10)||
'  <li id="017" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 017</li>'||chr(10)||
'  <li id="0';

s:=s||'18" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 018</li>'||chr(10)||
'  <li id="019" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 019</li>'||chr(10)||
'  <li id="020" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 020</li>'||chr(10)||
' </ul>'||chr(10)||
''||chr(10)||
'  <button type="button" onclick="javascript:getList();">Save</button>'||chr(10)||
'</div>';

wwv_flow_api.create_page_plug (
  p_id=> 7085306144120759 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'Sort Testing',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/DragDropMultiSelect/jquery.ui.js"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/DragDropMultiSelect/jquery.drag_drop_multi_select_alpha.js"></script>'||chr(10)||
''||chr(10)||
'<style>'||chr(10)||
'html {height:100%;}'||chr(10)||
'body {height:100%;}'||chr(10)||
' '||chr(10)||
'.ui-selectable-helper {position: absolute; z-index: 100; border:1px solid #000;}'||chr(10)||
'.ui-selectable-helper div {opacity:0.1;';

s:=s||' filter: alpha(opacity=10); width:auto; height:auto; background-color:#000;}'||chr(10)||
' '||chr(10)||
'.ui-draggable-dragging {z-index:9999;}'||chr(10)||
' '||chr(10)||
'#drag_drop { text-align:center; height:100%; position:relative; background-color:#fff; overflow:hidden;}'||chr(10)||
'#drag_drop .container { width:570px; margin:0 auto; padding-top:10px;}'||chr(10)||
'#drag_drop .list {width:150px; float:left; padding:0 20px;}'||chr(10)||
'#drag_drop .list .title {font-size:15px; fon';

s:=s||'t-weight:bold;}'||chr(10)||
'#drag_drop .list ul {}'||chr(10)||
'#drag_drop .list ul li {list-style:none; background-color:gray; margin:2px; height:20px; padding-top:3px; cursor:pointer; width:140px;}'||chr(10)||
'#drag_drop .items_selected {background-color:gray; color:#fff;height:16px; width:100%;}'||chr(10)||
'#drag_drop .list ul li.ui-selecting {background-color:#aaa !important;}'||chr(10)||
'#drag_drop .list ul li.ddms_selected {background-color:#aaa !impo';

s:=s||'rtant;}'||chr(10)||
'#drag_drop .list ul li.ddms_move {background-color:#ccc !important;}'||chr(10)||
'#drag_drop .list.ddms_hover {background-color:#bbb !important;}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<div id="drag_drop" class="demo">'||chr(10)||
'    <div class="container">'||chr(10)||
'        <div class="list">'||chr(10)||
'            <div class="title">List 1</div>'||chr(10)||
'            <ul>'||chr(10)||
'                <li>item 1</li>'||chr(10)||
'                <li>item 2</li>'||chr(10)||
'                <li>item 3</li>'||chr(10)||
'   ';

s:=s||'             <li>item 4</li>'||chr(10)||
'                <li>item 5</li>'||chr(10)||
'                <li>item 6</li>'||chr(10)||
'            </ul>'||chr(10)||
'        </div>'||chr(10)||
'        <div class="list">'||chr(10)||
'            <div class="title">List 2</div>'||chr(10)||
'            <ul>'||chr(10)||
'                <li>item 7</li>'||chr(10)||
'                <li>item 8</li>'||chr(10)||
'                <li>item 9</li>'||chr(10)||
'                <li>item 10</li>'||chr(10)||
'                <li>item 11</li>'||chr(10)||
'                <li>item';

s:=s||' 12</li>'||chr(10)||
'            </ul>'||chr(10)||
'        </div>'||chr(10)||
'        <div class="list">'||chr(10)||
'            <div class="title">List 3</div>'||chr(10)||
'            <ul>'||chr(10)||
'                <li>item 13</li>'||chr(10)||
'                <li>item 14</li>'||chr(10)||
'                <li>item 15</li>'||chr(10)||
'                <li>item 16</li>'||chr(10)||
'                <li>item 17</li>'||chr(10)||
'                <li>item 18</li>'||chr(10)||
'            </ul>'||chr(10)||
'        </div>'||chr(10)||
'        <div class="clear"></div>'||chr(10)||
'    <';

s:=s||'/div>'||chr(10)||
'    <div class="items_selected"></div>'||chr(10)||
'</div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'<script>'||chr(10)||
'$(document).ready(function(){'||chr(10)||
'    // Set the default function'||chr(10)||
'    $.fn.drag_drop_multi_select.defaults.after_drop_action = function($item,$old,$new,e,ui){'||chr(10)||
'        // Possible param $item_instance, $old_container, $new_container, event, helper'||chr(10)||
'        var $target = $(e.target);'||chr(10)||
'        $target.find(''ul'').append($item);'||chr(10)||
'    };'||chr(10)||
'    // In';

s:=s||'itiate the drag & drop'||chr(10)||
'    $(''#drag_drop'').drag_drop_multi_select({'||chr(10)||
'        element_to_drag_drop_select:''.list ul li'','||chr(10)||
'        elements_to_drop:''.list'','||chr(10)||
'        elements_to_cancel_select:''.title'''||chr(10)||
'    });'||chr(10)||
'    // Align the selection bar'||chr(10)||
'    $(''#drag_drop .items_selected'').JCSS_align({'||chr(10)||
'        vertical_align:''bottom'','||chr(10)||
'        horizontal_align:''left'''||chr(10)||
'    });'||chr(10)||
'});'||chr(10)||
'</script>';

wwv_flow_api.create_page_plug (
  p_id=> 7088112995567497 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'Multi-DragDrop',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jstree/_lib/jquery.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jstree/_lib/jquery.cookie.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jstree/_lib/jquery.hotkeys.js"></script>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jstree/jquery.jstree.js"></script>'||chr(10)||
'<link type="text/css" r';

s:=s||'el="stylesheet" href="#IMAGE_PREFIX#jQuery/jstree/_docs/syntax/!style.css"/>'||chr(10)||
'<link type="text/css" rel="stylesheet" href="#IMAGE_PREFIX#jQuery/jstree/_docs/!style.css"/>'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/jstree/_docs/syntax/!script.js"></script>'||chr(10)||
''||chr(10)||
'<div id="ROINarrative" class="ROINarrative" style="height:auto;width:100%">'||chr(10)||
' <ul>'||chr(10)||
'  <li id="phtml_2"><a href="#">Narrative 001</a>';

s:=s||'</li>'||chr(10)||
'  <li id="phtml_3"><a href="#">Narrative 002</a></li>'||chr(10)||
'  <li id="phtml_4"><a href="#">Narrative 003</a></li>'||chr(10)||
'  <li id="phtml_5"><a href="#">Narrative 004</a></li>'||chr(10)||
'  <li id="phtml_6"><a href="#">Narrative 005</a></li>'||chr(10)||
'  <li id="phtml_7"><a href="#">Narrative 006</a></li>'||chr(10)||
'  <li id="phtml_8"><a href="#">Narrative 007</a></li>'||chr(10)||
'  <li id="phtml_9"><a href="#">Narrative 008</a></li>'||chr(10)||
'  <li id="phtml_';

s:=s||'10"><a href="#">Narrative 009</a></li>'||chr(10)||
'  <li id="phtml_11"><a href="#">Narrative 010</a></li>'||chr(10)||
' </ul>'||chr(10)||
'</div>'||chr(10)||
''||chr(10)||
'<script type="text/javascript" class="source below">'||chr(10)||
'$(function () '||chr(10)||
'{'||chr(10)||
' $("#ROINarrative")'||chr(10)||
'                   .jstree({"plugins" : ["themes","html_data","ui","crrm","dnd","hotkeys"],})'||chr(10)||
'		   .bind("loaded.jstree", function (event, data) {});'||chr(10)||
'                   setTimeout(function () { $("#ROI';

s:=s||'Narrative").jstree("set_focus"); }, 500);'||chr(10)||
''||chr(10)||
' $("#ROINarrative").bind("open_node.jstree", function (e, data) {data.inst.select_node("#phtml_2", true);});'||chr(10)||
''||chr(10)||
'// $("#ROINarrative").jstree({'||chr(10)||
'//types : {'||chr(10)||
'//	"default" : {'||chr(10)||
'//"icon" : {"image" : ""#IMAGE_PREFIX#jQuery/jstree/_demo/file.png"},		'||chr(10)||
'//                "max_children"   : -1,'||chr(10)||
'//		"max_depth"      : -1,'||chr(10)||
'//		"valid_children" : "all"'||chr(10)||
'//'||chr(10)||
'//		// Bound fu';

s:=s||'nctions - you can bind any other function here //(using boolean or function)'||chr(10)||
'//		//"select_node"	: true,'||chr(10)||
'//		//"open_node"	: true,'||chr(10)||
'//		//"close_node"	: true,'||chr(10)||
'//		//"create_node"	: true,'||chr(10)||
'//		//"delete_node"	: true'||chr(10)||
'//	}'||chr(10)||
'//});'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'</div>'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 7091212339220114 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'JSTree',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
'<style>'||chr(10)||
'.demo { width: 620px }'||chr(10)||
''||chr(10)||
'ul { width: 400px; height: 150px; padding: 2em; margin: 10px; color:#ddd; list-style: none; }'||chr(10)||
'ul li { cursor: pointer; }'||chr(10)||
''||chr(10)||
'#draggable { background: #444; }'||chr(10)||
'#droppable { background: #222; }'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<div class="demo">'||chr(10)||
''||chr(10)||
' <p>Available Boxes (click to select multiple boxes)</p>  ';

s:=s||'  '||chr(10)||
' <ul id="draggable">'||chr(10)||
'  <li>Box #1</li>'||chr(10)||
'  <li>Box #2</li>'||chr(10)||
'  <li>Box #3</li>'||chr(10)||
'  <li>Box #4</li>'||chr(10)||
' </ul>'||chr(10)||
'    '||chr(10)||
' <p>My Boxes</p>'||chr(10)||
' <ul id="droppable"></ul>'||chr(10)||
'    '||chr(10)||
'</div>'||chr(10)||
''||chr(10)||
'<script>'||chr(10)||
'$(document).ready(function() {'||chr(10)||
''||chr(10)||
'    var selectedClass = ''ui-state-highlight'','||chr(10)||
'        clickDelay = 600,'||chr(10)||
'        // click time (milliseconds)'||chr(10)||
'        lastClick, diffClick; // timestamps'||chr(10)||
''||chr(10)||
'    $("#draggable li")'||chr(10)||
'    // Script to d';

s:=s||'eferentiate a click from a mousedown for drag event'||chr(10)||
'    .bind(''mousedown mouseup'', function(e) {'||chr(10)||
'        if (e.type == "mousedown") {'||chr(10)||
'            lastClick = e.timeStamp; // get mousedown time'||chr(10)||
'        } else {'||chr(10)||
'            diffClick = e.timeStamp - lastClick;'||chr(10)||
'            if (diffClick < clickDelay) {'||chr(10)||
'                // add selected class to group draggable objects'||chr(10)||
'                $(this).toggleClas';

s:=s||'s(selectedClass);'||chr(10)||
'            }'||chr(10)||
'        }'||chr(10)||
'    })'||chr(10)||
'    .draggable({'||chr(10)||
'        revertDuration: 10,'||chr(10)||
'        // grouped items animate separately, so leave this number low'||chr(10)||
'        containment: ''.demo'','||chr(10)||
'        start: function(e, ui) {'||chr(10)||
'            ui.helper.addClass(selectedClass);'||chr(10)||
'        },'||chr(10)||
'        stop: function(e, ui) {'||chr(10)||
'            // reset group positions'||chr(10)||
'            $(''.'' + selectedClass).css({'||chr(10)||
'     ';

s:=s||'           top: 0,'||chr(10)||
'                left: 0'||chr(10)||
'            });'||chr(10)||
'        },'||chr(10)||
'        drag: function(e, ui) {'||chr(10)||
'            // set selected group position to main dragged object'||chr(10)||
'            // this works because the position is relative to the starting position'||chr(10)||
'            $(''.'' + selectedClass).css({'||chr(10)||
'                top: ui.position.top,'||chr(10)||
'                left: ui.position.left'||chr(10)||
'            });'||chr(10)||
'        }'||chr(10)||
'    ';

s:=s||'});'||chr(10)||
''||chr(10)||
'    $("#droppable, #draggable").sortable().droppable({'||chr(10)||
'        drop: function(e, ui) {'||chr(10)||
'            $(''.'' + selectedClass).appendTo($(this)).add(ui.draggable) // ui.draggable is appended by the script, so add it after'||chr(10)||
'            .removeClass(selectedClass).css({'||chr(10)||
'                top: 0,'||chr(10)||
'                left: 0'||chr(10)||
'            });'||chr(10)||
'        }'||chr(10)||
'    });'||chr(10)||
''||chr(10)||
'});'||chr(10)||
'</script>';

wwv_flow_api.create_page_plug (
  p_id=> 7095801115600064 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'More Drag Testing',
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
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<a id="top"></a>'||chr(10)||
'<style>'||chr(10)||
''||chr(10)||
'#three {'||chr(10)||
'        background:#e3e3e3;'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'button {'||chr(10)||
'        -webkit-transition: background-color 0.2s linear;'||chr(10)||
'        border-radius:4px;'||chr(10)||
'        -moz-border-radius: 4px 4px 4px 4px;'||chr(10)||
'        -moz-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.15);'||chr(10)||
'        background-color: #E4F2FF;'||chr(10)||
'        background-image: url("#IMAGE_PREFIX#dojo-release-1.6.1/dijit/themes/claro/form/images/bu';

s:=s||'tton.png");'||chr(10)||
'        background-position: center top;'||chr(10)||
'        background-repeat: repeat-x;'||chr(10)||
'        border: 1px solid #769DC0;'||chr(10)||
'        padding: 2px 8px 4px;'||chr(10)||
'        font-size:1em;'||chr(10)||
'       }'||chr(10)||
''||chr(10)||
'button:hover {'||chr(10)||
'              background-color: #AFD9FF;'||chr(10)||
'              color: #000000;'||chr(10)||
'             }'||chr(10)||
''||chr(10)||
'.red-block {'||chr(10)||
'            width: 100px;'||chr(10)||
'            height: 100px;'||chr(10)||
'            background-color: red;'||chr(10)||
'         ';

s:=s||'  }'||chr(10)||
''||chr(10)||
'.wipe {'||chr(10)||
'	font-size: 28px;'||chr(10)||
'	height: auto;'||chr(10)||
'	width: auto;'||chr(10)||
'}'||chr(10)||
'.slide {'||chr(10)||
'	position: absolute;'||chr(10)||
'}'||chr(10)||
'.chain {'||chr(10)||
'	opacity: 0;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'    <script>'||chr(10)||
'        //Change Hello to "Hello, from ######"//'||chr(10)||
'        dojo.ready(function(){'||chr(10)||
'            dojo.byId("greeting").innerHTML += ", from " + dojo.version;'||chr(10)||
'        });'||chr(10)||
'';

s:=s||''||chr(10)||
'       //You can have as many calls to .ready as you want//'||chr(10)||
'       function init() {'||chr(10)||
'                        dojo.byId("greeting").innerHTML += ", from " + dojo.version + " - Changed Again";'||chr(10)||
'                        // More initialization here'||chr(10)||
'                        }'||chr(10)||
'       dojo.ready(init);'||chr(10)||
''||chr(10)||
''||chr(10)||
'      //Shows how to import/include stuff not in the base dojo.js//'||chr(10)||
'      // New: Require in the dojo.f';

s:=s||'x module'||chr(10)||
'      dojo.require("dojo.fx");'||chr(10)||
' '||chr(10)||
'      // Remember, dojo.ready waits for both the DOM and all dependencies'||chr(10)||
'      dojo.ready(function(){'||chr(10)||
'          // The piece we had before - change our innerHTML'||chr(10)||
'          dojo.byId("greeting").innerHTML += ", from " + dojo.version;'||chr(10)||
'       '||chr(10)||
'          // Now, slide the greeting'||chr(10)||
'          dojo.fx.slideTo({'||chr(10)||
'              top: 100,'||chr(10)||
'              left: 200,'||chr(10)||
'  ';

s:=s||'            node: dojo.byId("greeting")'||chr(10)||
'          }).play();'||chr(10)||
'      });'||chr(10)||
''||chr(10)||
'      function setText(node, text){'||chr(10)||
'          node = dojo.byId(node);'||chr(10)||
'          node.innerHTML = text;'||chr(10)||
'      }'||chr(10)||
' '||chr(10)||
'      dojo.ready(function(){'||chr(10)||
'          var one = dojo.byId("one");'||chr(10)||
' '||chr(10)||
'          setText(one, "One has been set");'||chr(10)||
'          setText("two", "Two has been set as well");'||chr(10)||
'      });'||chr(10)||
''||chr(10)||
''||chr(10)||
'      dojo.ready(function(){'||chr(10)||
'       ';

s:=s||'   var list = dojo.byId("list"),'||chr(10)||
'              three = dojo.byId("three");'||chr(10)||
' '||chr(10)||
'          dojo.create("li", {'||chr(10)||
'              innerHTML: "Six"'||chr(10)||
'          }, list);'||chr(10)||
' '||chr(10)||
'          dojo.create("li", {'||chr(10)||
'              innerHTML: "Seven",'||chr(10)||
'              className: "seven",'||chr(10)||
'              style: {'||chr(10)||
'                  fontWeight: "bold"'||chr(10)||
'              }'||chr(10)||
'          }, list);'||chr(10)||
' '||chr(10)||
'          dojo.create("li", {'||chr(10)||
'              ';

s:=s||'innerHTML: "Three and a half"'||chr(10)||
'          }, three, "after");'||chr(10)||
'      });    '||chr(10)||
''||chr(10)||
'      function moveFirst(){'||chr(10)||
'          var list = dojo.byId("list"),'||chr(10)||
'              three = dojo.byId("three");'||chr(10)||
' '||chr(10)||
'          dojo.place(three, list, "first");'||chr(10)||
'      }'||chr(10)||
' '||chr(10)||
'      function moveBeforeTwo(){'||chr(10)||
'          var two = dojo.byId("two"),'||chr(10)||
'              three = dojo.byId("three");'||chr(10)||
' '||chr(10)||
'          dojo.place(three, two, "before");'||chr(10)||
' ';

s:=s||'     }'||chr(10)||
' '||chr(10)||
'      function moveAfterFour(){'||chr(10)||
'          var four = dojo.byId("four"),'||chr(10)||
'              three = dojo.byId("three");'||chr(10)||
' '||chr(10)||
'          dojo.place(three, four, "after");'||chr(10)||
'      }'||chr(10)||
' '||chr(10)||
'      function moveLast(){'||chr(10)||
'          var list = dojo.byId("list"),'||chr(10)||
'              three = dojo.byId("three");'||chr(10)||
' '||chr(10)||
'          dojo.place(three, list);'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
'      function destroyFirst(){'||chr(10)||
'          var list = dojo.byId("lis';

s:=s||'t"),'||chr(10)||
'              items = list.getElementsByTagName("li");'||chr(10)||
' '||chr(10)||
'          if(items.length){'||chr(10)||
'              dojo.destroy(items[0]);'||chr(10)||
'          }'||chr(10)||
'      }'||chr(10)||
' '||chr(10)||
'      function destroyAll(){'||chr(10)||
'          dojo.empty("list");'||chr(10)||
'      }'||chr(10)||
'    </script>'||chr(10)||
''||chr(10)||
'<h1 id="greeting">Hello</h1>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
'        <button onclick="moveFirst();return false;">The first item</button>'||chr(10)||
'        <button onclick="moveBeforeTwo();return false;">';

s:=s||'Before Two</button>'||chr(10)||
'        <button onclick="moveAfterFour();return false;">After Four</button>'||chr(10)||
'        <button onclick="moveLast();return false;">The last item</button>'||chr(10)||
'        <button onclick="destroyFirst();return false;">Destroy the first list item</button>'||chr(10)||
'        <button onclick="destroyAll();return false;">Destroy all list items</button>'||chr(10)||
'        <ul id="list">'||chr(10)||
'            <li id="one">One</';

s:=s||'li>'||chr(10)||
'            <li id="two">Two</li>'||chr(10)||
'            <li id="three">Three</li>'||chr(10)||
'            <li id="four">Four</li>'||chr(10)||
'            <li id="five">Five</li>'||chr(10)||
'        </ul>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'<script>'||chr(10)||
'        dojo.ready(function(){'||chr(10)||
'                              var myButton = dojo.byId("myButton"),'||chr(10)||
'                                  myDiv = dojo.byId("myDiv");'||chr(10)||
' '||chr(10)||
'                              dojo.connect(myButton, "onclick';

s:=s||'", function(evt){'||chr(10)||
'                                  dojo.style(myDiv, "backgroundColor", "blue");'||chr(10)||
'                                  return false;'||chr(10)||
'                              });'||chr(10)||
'                              dojo.connect(myDiv, "onmouseenter", function(evt){'||chr(10)||
'                                  dojo.style(myDiv, "backgroundColor", "red");'||chr(10)||
'                              });'||chr(10)||
'                          ';

s:=s||'    dojo.connect(myDiv, "onmouseleave", function(evt){'||chr(10)||
'                                  dojo.style(myDiv, "backgroundColor", "");'||chr(10)||
'                              });'||chr(10)||
''||chr(10)||
'                              var handle = dojo.connect(myButton, "onclick", function(evt){'||chr(10)||
'                                  // Disconnect this event using the handle'||chr(10)||
'                                  dojo.disconnect(handle);'||chr(10)||
'       ';

s:=s||'                        '||chr(10)||
'                                  // Do other stuff here that you only want to happen one time'||chr(10)||
'                                  alert("This alert will only happen one time.");'||chr(10)||
'});'||chr(10)||
'                            });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
'<button id="myButton" onclick="javascript:return false;">Click me!</button>'||chr(10)||
'<div id="myDiv">Hover over me!</div>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
'<button id="myButton1" on';

s:=s||'click="javascript:return false;">My button1</button>'||chr(10)||
'<script>'||chr(10)||
'        dojo.ready(function(){'||chr(10)||
'    var myButtonObject = {'||chr(10)||
'        onClick: function(evt){'||chr(10)||
'            alert("The button was clicked");'||chr(10)||
'        }'||chr(10)||
'    };'||chr(10)||
'    dojo.connect(dojo.byId("myButton1"), "onclick", myButtonObject, "onClick");'||chr(10)||
'    dojo.connect(myButtonObject, "onClick", function(evt){'||chr(10)||
'    alert("The button was clicked and ''onClick''';

s:=s||' was called");'||chr(10)||
'});});'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
'<button id="alertButton" onclick="javascript:return false;">Alert the user</button>'||chr(10)||
'<button id="createAlert" onclick="javascript:return false;">Create another alert button</button>'||chr(10)||
' '||chr(10)||
'<script>'||chr(10)||
'    var alertButton = dojo.byId("alertButton"),'||chr(10)||
'        createAlert = dojo.byId("createAlert");'||chr(10)||
' '||chr(10)||
'    dojo.connect(alertButton, "onclick", function(evt){'||chr(10)||
'        // When';

s:=s||' this button is clicked,'||chr(10)||
'        // publish to the "alertUser" topic'||chr(10)||
'        dojo.publish("alertUser", ["I am alerting you."]);'||chr(10)||
'    });'||chr(10)||
'    dojo.connect(createAlert, "onclick", function(evt){'||chr(10)||
'        // Create another button'||chr(10)||
'        var anotherButton = dojo.create("button", {'||chr(10)||
'            innerHTML: "Another alert button",'||chr(10)||
'            onclick: "javascript:return false;"'||chr(10)||
'        }, createAlert, "aft';

s:=s||'er");'||chr(10)||
' '||chr(10)||
'        // When the other button is clicked,'||chr(10)||
'        // publish to the "alertUser" topic'||chr(10)||
'        dojo.connect(anotherButton, "onclick", function(evt){'||chr(10)||
'            dojo.publish("alertUser", ["I am also alerting you."]);'||chr(10)||
'        });'||chr(10)||
'    });'||chr(10)||
' '||chr(10)||
'    // Register the alerting routine with the "alertUser"'||chr(10)||
'    // topic.'||chr(10)||
'    dojo.subscribe("alertUser", function(text){'||chr(10)||
'        alert(text);'||chr(10)||
'    });'||chr(10)||
'</';

s:=s||'script>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
'<h2>FadeIn/FadeOut</h2>'||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
'<button id="fadeOutButton" onclick="return false;">Fade block out</button>'||chr(10)||
'<button id="fadeInButton" onclick="return false;">Fade block in</button>'||chr(10)||
' '||chr(10)||
'<div id="fadeTarget" class="red-block">'||chr(10)||
'    A red block'||chr(10)||
'</div>'||chr(10)||
'<script>'||chr(10)||
'    dojo.ready(function(){'||chr(10)||
'        var fadeOutButton = dojo.byId("fadeOutButton"),'||chr(10)||
'            fadeInButton = dojo.byId("fadeInButton"';

s:=s||'),'||chr(10)||
'            fadeTarget = dojo.byId("fadeTarget");'||chr(10)||
' '||chr(10)||
'        dojo.connect(fadeOutButton, "onclick", function(evt){'||chr(10)||
'            dojo.fadeOut({ node: fadeTarget }).play();'||chr(10)||
'        });'||chr(10)||
'        dojo.connect(fadeInButton, "onclick", function(evt){'||chr(10)||
'            dojo.fadeIn({ node: fadeTarget }).play();'||chr(10)||
'        });'||chr(10)||
'    });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
'<H2>WIPE</H2>'||chr(10)||
'<HR>'||chr(10)||
'<button id="wipeOutButton" onclick="return fal';

s:=s||'se;">Wipe block out</button>'||chr(10)||
'<button id="wipeInButton" onclick="return false;">Wipe block in</button>'||chr(10)||
' '||chr(10)||
'<div id="wipeTarget" class="red-block wipe">'||chr(10)||
'    A red block'||chr(10)||
'</div>'||chr(10)||
'<script>'||chr(10)||
'    // Load the dojo.fx module'||chr(10)||
'    dojo.require("dojo.fx");'||chr(10)||
' '||chr(10)||
'    // Don''t forget, when using modules, wrap your code in a dojo.ready'||chr(10)||
'    dojo.ready(function(){'||chr(10)||
'        var wipeOutButton = dojo.byId("wipeOutButton"),'||chr(10)||
'  ';

s:=s||'          wipeInButton = dojo.byId("wipeInButton"),'||chr(10)||
'            wipeTarget = dojo.byId("wipeTarget");'||chr(10)||
' '||chr(10)||
'        dojo.connect(wipeOutButton, "onclick", function(evt){'||chr(10)||
'            dojo.fx.wipeOut({ node: wipeTarget }).play();'||chr(10)||
'        });'||chr(10)||
'        dojo.connect(wipeInButton, "onclick", function(evt){'||chr(10)||
'            dojo.fx.wipeIn({ node: wipeTarget }).play();'||chr(10)||
'        });'||chr(10)||
'    });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
'<H2>SLIDE<';

s:=s||'/H2>'||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
'<button id="slideAwayButton" onclick="return false;">Slide block away</button>'||chr(10)||
'<button id="slideBackButton" onclick="return false;">Slide block back</button>'||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
'<div id="slideTarget" class="red-block slide">'||chr(10)||
'    A red block'||chr(10)||
'</div>'||chr(10)||
''||chr(10)||
'<script>'||chr(10)||
'    dojo.require("dojo.fx");'||chr(10)||
' '||chr(10)||
'    dojo.ready(function(){'||chr(10)||
'        var slideAwayButton = dojo.byId("slideAwayButton"),'||chr(10)||
'            slideBackButton';

s:=s||' = dojo.byId("slideBackButton"),'||chr(10)||
'            slideTarget = dojo.byId("slideTarget")'||chr(10)||
' '||chr(10)||
'        dojo.connect(slideAwayButton, "onclick", function(evt){'||chr(10)||
'            dojo.fx.slideTo({ node: slideTarget, left: (dojo.coords("slideTarget").l+200).toString(), top: (dojo.coords("slideTarget").t+0).toString()}).play();'||chr(10)||
'        });'||chr(10)||
'        dojo.connect(slideBackButton, "onclick", function(evt){'||chr(10)||
'            d';

s:=s||'ojo.fx.slideTo({ node: slideTarget, left: (dojo.coords("slideTarget").l-200), top: (dojo.coords("slideTarget").t-0).toString() }).play();'||chr(10)||
'        });'||chr(10)||
'    });'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
'<BR>'||chr(10)||
''||chr(10)||
'<HR>'||chr(10)||
'<H1>TOOLTIPS</H1>'||chr(10)||
'<HR>'||chr(10)||
''||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#dojo-release-1.6.1/dijit/themes/claro/claro.css" />'||chr(10)||
''||chr(10)||
'<script>'||chr(10)||
'        // Require the Tooltip class'||chr(10)||
'        dojo.requi';

s:=s||'re("dijit.Tooltip");'||chr(10)||
''||chr(10)||
'        // When the DOM and reources are ready....'||chr(10)||
'        dojo.ready(function(){'||chr(10)||
''||chr(10)||
'                //Add tooltip of record'||chr(10)||
'//                new dijit.Tooltip({'||chr(10)||
'//                        connectId: ["77700001"],'||chr(10)||
'//                        label: "On 3 Aug 10, SA HUGH DEAVER and INV WOODY //BATEMAN, AFOSI 9 FIS, EAFB, FL, conducted a site survey (Activity //#31119102171559) of ';

s:=s||'Fish Lipz, 203 Brooks Street Southeast, Fort Walton //Beach, FL.  The site Survey was conducted in furtherance of the ongoing //Narcotics Threat Assessment.  SA DEAVER purchased refreshments to blend in //and complete the mission without jeopardizing the safety, security, or //identity of personnel involved.  SA DEAVER spent C-Funds in the amount of //$20.00 for refreshments.  (SA DEAVER - $10.00;';

s:=s||' INV BATEMAN - $10.00)"'||chr(10)||
'//                });'||chr(10)||
''||chr(10)||
'                // Add custom tooltip'||chr(10)||
'                var myTip = new dijit.Tooltip({'||chr(10)||
'                        connectId: ["hoverLink"],'||chr(10)||
'                        label: "Don''t I look funky?",'||chr(10)||
'                        "class": "customTip"'||chr(10)||
'                });'||chr(10)||
'        });'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<table border=1>'||chr(10)||
'<tr ><td><a href="javascript:getObjURL(''3331225I'');" ><im';

s:=s||'g src="/i/ws/small_page.gif" alt=""></a></td><td  align="left">03-Aug-2010</td><td  align="left">E100131563</td><td  align="left">DEAVER, HUGH J</td><td  align="left"><div class="tooltip" title="Activity: 00000103560902 - CFunds Expenses - Migration Activity #1">Activity: 00000103560902 ...</div></td><td  align="left">$20.00</td><td  align="left">Closed</td><td  align="left">FIS 9</td><td id="7770';

s:=s||'0001" align="left">On 3 Aug 10, SA HUGH DEAV...</td><td  align="left">D</td><td  align="left">A2.2.19</td><td  align="left">25-Jul-2011</td><td  align="left"> 00003</td><td  align="left"> 000000.025520</td></tr>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'<button id="tooltipButton" onmouseover="dijit.Tooltip.defaultPosition=[''above'', ''below'']">Tooltip Above</button>'||chr(10)||
'<div class="dijitHidden"><span data-dojo-type="dijit.Tooltip" dat';

s:=s||'a-dojo-props="connectId:''tooltipButton''">I am <strong>above</strong> the button</span></div>'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 7097231615936592 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'DOJO Testing',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 50,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<style type="text/css">'||chr(10)||
'  @import "/explorer/featureexplorer/Dojo/Drag%20And%20Drop/dndDefault.css";'||chr(10)||
'  .dndContainer {'||chr(10)||
'    width: 100px;'||chr(10)||
'    display: block;'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'  .clear {'||chr(10)||
'    clear: both;'||chr(10)||
'  }'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'  dojo.require("dojo.dnd.Container");'||chr(10)||
'  dojo.require("dojo.dnd.Manager");'||chr(10)||
'  dojo.require("dojo.dnd.Source");'||chr(10)||
''||chr(10)||
'  function initDND(){'||chr(10)||
'    var c1;'||chr(10)||
'    c1 = new dojo.dnd.Source("container1");'||chr(10)||
'    c1.insertNodes(false, [1, "A", [1, 2, 3],'||chr(10)||
'      function(x){ return x + x; },'||chr(10)||
'      {toString: function(){ return "CUSTOM!"; }},'||chr(10)||
'      null]);'||chr(10)||
''||chr(10)||
'    // example subscribe to events'||chr(10)||
'    dojo.subscribe("/dnd/start", function(source){'||chr(10)||
'      console.debug("Starting the drop", source);'||chr(10)||
'    });'||chr(10)||
'    dojo.subscribe("/dnd/drop/before", function(source, nodes, copy, target){'||chr(10)||
'      if(target == c1){'||chr(10)||
'        console.debug(copy ? "Copying from" : "Moving from", source, "to", target, "before", target.before);'||chr(10)||
'      }'||chr(10)||
'    });'||chr(10)||
'    dojo.subscribe("/dnd/drop", function(source, nodes, copy, target){'||chr(10)||
'      if(target == c1){'||chr(10)||
'        console.debug(copy ? "Copying from" : "Moving from", source, "to", target, "before", target.before);'||chr(10)||
'      }'||chr(10)||
'    });'||chr(10)||
'    dojo.connect('||chr(10)||
'c4, "onDndDrop", function(source, nodes, copy, target){'||chr(10)||
'      if(target == c4){'||chr(10)||
'        console.debug(copy ? "Copying from" : "Moving from", source);'||chr(10)||
'      }'||chr(10)||
'    });'||chr(10)||
'  };'||chr(10)||
''||chr(10)||
'  dojo.addOnLoad(initDND);'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<div id="dragLists">'||chr(10)||
'  <div style="float: left; margin: 5px;">'||chr(10)||
'    <h3>Source 1</h3>'||chr(10)||
'    <div id="container1" class="dndContainer"></div>'||chr(10)||
'  </div>'||chr(10)||
'  <div style="float: left; margin: 5px;">'||chr(10)||
'    <h3>Source 2</h3>'||chr(10)||
'    <div dojoType="dojo.dnd.Source" jsId="c2" class="dndContainer">'||chr(10)||
'      <div class="dojoDndItem">Item <strong>X</strong></div>'||chr(10)||
'      <div class="dojoDndItem">Item <strong>Y</strong></div>'||chr(10)||
'      <div class="dojoDndItem">Item <strong>Z</strong></div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'  <div style="float: left; margin: 5px;">'||chr(10)||
'    <h3>Source 3</h3>'||chr(10)||
'    <div dojoType="dojo.dnd.Source" jsId="c3" class="dndContainer">'||chr(10)||
'      <script type="dojo/method" event="creator" args="item, hint">'||chr(10)||
'        // this is custom creator, which changes the avatar representation'||chr(10)||
'        var node = dojo.doc.createElement("div"), s = String(item);'||chr(10)||
'        node.id = dojo.dnd.getUniqueId();'||chr(10)||
'        node.className = "dojoDndItem";'||chr(10)||
'        node.innerHTML = (hint != "avatar" || s.indexOf("Item") < 0) ?'||chr(10)||
'          s : "<strong style=''color: darkred''>Special</strong> " + s;'||chr(10)||
'        return {node: node, data: item, type: ["text"]};'||chr(10)||
'      </script>'||chr(10)||
'      <div class="dojoDndItem">Item <strong>Alpha</strong></div>'||chr(10)||
'      <div class="dojoDndItem">Item <strong>Beta</strong></div>'||chr(10)||
'      <div class="dojoDndItem">Item <strong>Gamma</strong></div>'||chr(10)||
'      <div class="dojoDndItem">Item <strong>Delta</strong></div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'  <div style="float: left; margin: 5px;">'||chr(10)||
'    <h3>Pure Target 4</h3>'||chr(10)||
'    <div dojoType="dojo.dnd.Target" jsId="c4" class="dndContainer">'||chr(10)||
'      <div class="dojoDndItem">One item</div>'||chr(10)||
'    </div>'||chr(10)||
'  </div>'||chr(10)||
'  <div class="clear"></div>'||chr(10)||
'</div>');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<link type="text/css" rel="stylesheet" href="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/resources/dnd.css"/>'||chr(10)||
''||chr(10)||
'<style type="text/css">'||chr(10)||
''||chr(10)||
'  body { padding: 1em; background: white; }'||chr(10)||
''||chr(10)||
'  .container { width: 200px; display: block; }'||chr(10)||
'  .container.handles .dojoDndHandle { background: #fee; }'||chr(10)||
''||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script type="t';

s:=s||'ext/javascript">'||chr(10)||
''||chr(10)||
'  //dojo.ready(function(){alert(dojo.version);});'||chr(10)||
''||chr(10)||
'  //dojo.require("dojo.parser");'||chr(10)||
'  dojo.require("dojo.dnd.Container");'||chr(10)||
'  dojo.require("dojo.dnd.Source");'||chr(10)||
'  dojo.require("dojo.dnd.Selector");'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'		<div style="float: left; margin: 5px;">'||chr(10)||
'			<h3>Source 3</h3>'||chr(10)||
'			<div dojoType="dojo.dnd.Source" jsId="c3" class="container">'||chr(10)||
'				<script type="dojo/method" event="creator" ';

s:=s||'args="item, hint">'||chr(10)||
'					// this is custom creator, which changes the avatar representation'||chr(10)||
'					var node = dojo.doc.createElement("div"), s = String(item);'||chr(10)||
'					node.id = dojo.dnd.getUniqueId();'||chr(10)||
'					node.className = "dojoDndItem";'||chr(10)||
'					node.innerHTML = (hint != "avatar" || s.indexOf("Item") < 0) ?'||chr(10)||
'						s : "<strong style=''color: darkred''>Special</strong> " + s;'||chr(10)||
'					return {node: node, data: ite';

s:=s||'m, type: ["text"]};'||chr(10)||
'				</script>'||chr(10)||
'				<div class="dojoDndItem">Item <strong>Alpha</strong></div>'||chr(10)||
'				<div class="dojoDndItem">Item <strong>Beta</strong></div>'||chr(10)||
''||chr(10)||
'				<div class="dojoDndItem">Item <strong>Gamma</strong></div>'||chr(10)||
'				<div class="dojoDndItem">Item <strong>Delta</strong></div>'||chr(10)||
'			</div>'||chr(10)||
'		</div>'||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
''||chr(10)||
'<p>Source with handles. Items should be draggable by "Item".</p>'||chr(10)||
' <div dojoType';

s:=s||'="dojo.dnd.Source" withHandles="true" class="container handles">'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndHandle">Item</span> <strong>Alpha</strong></div>'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndHandle">Item</span> <strong>Beta</strong></div>'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndHandle">Item</span> <strong>Gamma</strong></div>'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndH';

s:=s||'andle">Item</span> <strong>Delta</strong></div>'||chr(10)||
' </div>'||chr(10)||
''||chr(10)||
'<p>Source without handles.</p>'||chr(10)||
' <div dojoType="dojo.dnd.Source" class="container">'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndHandle">Item</span> <strong>Epsilon</strong></div>'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndHandle">Item</span> <strong>Zeta</strong></div>'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndHandle">Item</span> ';

s:=s||'<strong>Eta</strong></div>'||chr(10)||
'  <div class="dojoDndItem"><span class="dojoDndHandle">Item</span> <strong>Theta</strong></div>'||chr(10)||
'</div>'||chr(10)||
''||chr(10)||
'<div dojoType="dojo.dnd.Source" jsId="c2" class="container" copyOnly="true">'||chr(10)||
' <div class="dojoDndItem">Item <strong>X</strong></div>'||chr(10)||
' <div class="dojoDndItem">Item <strong>Y</strong></div>'||chr(10)||
' <div class="dojoDndItem">Item <strong>Z</strong></div>'||chr(10)||
'</div>';

wwv_flow_api.create_page_plug (
  p_id=> 7112703131415505 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'DOJO Drag and Drop',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 60,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<script src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" type="text/javascript"></script>');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<html>'||chr(10)||
'<head>'||chr(10)||
' <link type="text/css" rel="stylesheet" href="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/resources/dnd.css"/>'||chr(10)||
''||chr(10)||
' <style type="text/css">'||chr(10)||
''||chr(10)||
'  body { padding: 1em; background: white; }'||chr(10)||
''||chr(10)||
'  .container { width: 200px; display: block; }'||chr(10)||
'  .container.handles .dojoDndHandle { background: #fee; }'||chr(10)||
''||chr(10)||
' </style>'||chr(10)||
''||chr(10)||
' <script type="text/javascript" src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" djConfig';

s:=s||'="isDebug: true, parseOnLoad: true"></script>'||chr(10)||
' <script type="text/javascript">'||chr(10)||
''||chr(10)||
'  dojo.require("dojo.parser");'||chr(10)||
'  dojo.require("dojo.dnd.Source");'||chr(10)||
''||chr(10)||
'  var initDND = function()'||chr(10)||
'  {'||chr(10)||
'   dojo.subscribe("/dnd/start", null, function(source,node,copy)'||chr(10)||
'                 {'||chr(10)||
'                  console.log("/dnd/start",source,node);'||chr(10)||
'                  //Don''t allow copies to be made'||chr(10)||
'                  console.log("';

s:=s||'copy="+copy);'||chr(10)||
'                  if(copy == true) '||chr(10)||
'                    {'||chr(10)||
'                     source.copyState = function(){return false;};'||chr(10)||
'                    }'||chr(10)||
'                 });'||chr(10)||
'   dojo.subscribe("/dnd/stop", null, function(source,node,copy)'||chr(10)||
'                 {'||chr(10)||
'                  console.log("/dnd/stop",source,node);'||chr(10)||
'                  //Don''t allow copies to be made'||chr(10)||
'                  console.log';

s:=s||'("copy="+copy);'||chr(10)||
'                  if(copy == true) '||chr(10)||
'                    {'||chr(10)||
'                     source.copyState = function(){return false;};'||chr(10)||
'                    }'||chr(10)||
'                 });'||chr(10)||
'  }'||chr(10)||
'  dojo.addOnLoad(initDND);'||chr(10)||
' </script>'||chr(10)||
''||chr(10)||
'</head>'||chr(10)||
'<body>'||chr(10)||
' <h3>Narratives</h3>'||chr(10)||
'  <div dojoType="dojo.dnd.Source" jsId="c3" class="container">'||chr(10)||
'  <div class="dojoDndItem" id="0001">001.  Narrative 1</div>'||chr(10)||
'  <div class=';

s:=s||'"dojoDndItem" id="0002">002.  Narrative 2</div>'||chr(10)||
'  <div class="dojoDndItem" id="0003">003.  Narrative 3</div>'||chr(10)||
'  <div class="dojoDndItem" id="0004">004.  Narrative 4</div>'||chr(10)||
'  <div class="dojoDndItem" id="0005">005.  Narrative 5</div>'||chr(10)||
' </div>'||chr(10)||
'</body>'||chr(10)||
'</html>'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 7118716090030032 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'More DOJO DND Testing',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 70,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'DECLARE'||chr(10)||
'BEGIN'||chr(10)||
''||chr(10)||
'  htp.p(:p99999999_html1);'||chr(10)||
'  htp.p(:p99999999_html2);'||chr(10)||
'  htp.p(:p99999999_html3);'||chr(10)||
'  htp.p(:p99999999_html4);'||chr(10)||
'  htp.p(:p99999999_html5);'||chr(10)||
'  htp.p(:p99999999_html6);'||chr(10)||
'  htp.p(:p99999999_html7);'||chr(10)||
'  htp.p(:p99999999_html8);'||chr(10)||
'  htp.p(:p99999999_html9);'||chr(10)||
'  htp.p(:p99999999_html10);'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_plug (
  p_id=> 7126112990580983 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'Rearrange Narrative Sequence....',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 80,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'NEVER',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<html>'||chr(10)||
'<head>'||chr(10)||
'<link id="themeStyles" rel="stylesheet" href=""#IMAGE_PREFIX#dojo-release-1.6.1/dijit/themes/claro/claro.css">'||chr(10)||
''||chr(10)||
' <link type="text/css" rel="stylesheet" href="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/resources/dnd.css"/>'||chr(10)||
''||chr(10)||
' <style type="text/css">'||chr(10)||
''||chr(10)||
'  body { padding: 1em; background: white; }'||chr(10)||
''||chr(10)||
'  .container { width: auto; display: block; }'||chr(10)||
'  .container.handles .dojoDndHandle { background: #fee; }'||chr(10)||
''||chr(10)||
'  button {'||chr(10)||
'          -webkit-transition: background-color 0.2s linear;'||chr(10)||
'          border-radius:4px;'||chr(10)||
'          -moz-border-radius: 4px 4px 4px 4px;'||chr(10)||
'          -moz-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.15);'||chr(10)||
'          background-color: #E4F2FF;'||chr(10)||
'          background-image: url("#IMAGE_PREFIX#dojo-release-1.6.1/dijit/themes/claro/form/images/button.png");'||chr(10)||
'          background-position: center top;'||chr(10)||
'          background-repeat: repeat-x;'||chr(10)||
'          border: 1px solid #769DC0;'||chr(10)||
'          padding: 2px 8px 4px;'||chr(10)||
'          font-size:1em;'||chr(10)||
'         }'||chr(10)||
''||chr(10)||
'  button:hover {'||chr(10)||
'                background-color: #AFD9FF;'||chr(10)||
'                color: #000000;'||chr(10)||
'               }'||chr(10)||
''||chr(10)||
'.reportContainer {'||chr(10)||
'	overflow-y: scroll;'||chr(10)||
'	overflow-x: hidden;'||chr(10)||
'	border: solid 1px #aaa;'||chr(10)||
'	margin: 0px;'||chr(10)||
'	padding: 0px;'||chr(10)||
'	max-height: 195px;'||chr(10)||
'	float: left;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.container {'||chr(10)||
'/*	margin-right: 17px;*/'||chr(10)||
'	border-collapse: collapse;'||chr(10)||
'	border: solid 1px #aaa;'||chr(10)||
'	margin: 0px;'||chr(10)||
'	padding: 0px;'||chr(10)||
'}'||chr(10)||
'.container thead tr {'||chr(10)||
'	position: relative;'||chr(10)||
'	height: auto;'||chr(10)||
'	top: expression( this.parentNode.parentNode.parentNode.scrollTop + ''px'' );   '||chr(10)||
'}'||chr(10)||
'.container thead td {'||chr(10)||
'	color: #fff;'||chr(10)||
'	background-color: #4e7ec2;'||chr(10)||
'	border: solid 1px #aaa;'||chr(10)||
'	border-top: none;'||chr(10)||
'	border-left: none;'||chr(10)||
'	offset-top: 10px;'||chr(10)||
'	font-size: 12px;'||chr(10)||
'	font-weight: bold;'||chr(10)||
'	white-space: nowrap;'||chr(10)||
'}'||chr(10)||
'.container thead td a { color:#fff; }'||chr(10)||
'.container thead td a:hover { color:#ffffaa; active:lightblue; }'||chr(10)||
'	'||chr(10)||
'.container td {'||chr(10)||
'	border: #aaa 1px solid;'||chr(10)||
'	border-left: none;'||chr(10)||
'	padding: 3px;'||chr(10)||
'	font-size: 12px;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.container tbody {'||chr(10)||
'	overflow-x: hidden;'||chr(10)||
'	overflow-y: auto;'||chr(10)||
'	border-collapse: collapse;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.container .oddrow {'||chr(10)||
'	background-color: #fff;'||chr(10)||
'}'||chr(10)||
'.container .evenrow {'||chr(10)||
'	background-color: #efefef;'||chr(10)||
'}'||chr(10)||
'.container .currentrow {'||chr(10)||
'	background-color: #c5f3ce;'||chr(10)||
'}'||chr(10)||
' </style>'||chr(10)||
''||chr(10)||
' <script type="text/javascript" src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" djConfig="isDebug: true, parseOnLoad: true"></script>'||chr(10)||
' <script type="text/javascript">'||chr(10)||
''||chr(10)||
'  dojo.require("dojo.parser");'||chr(10)||
'  dojo.require("dojo.dnd.Source");'||chr(10)||
''||chr(10)||
'  var initDND = function()'||chr(10)||
'  {'||chr(10)||
'   dojo.subscribe("/dnd/start", null, function(source,node,copy)'||chr(10)||
'                 {'||chr(10)||
'                  console.log("/dnd/start",source,node);'||chr(10)||
'                  //Don''t allow copies to be made'||chr(10)||
'                  console.log("copy="+copy);'||chr(10)||
'                  if(copy == true) '||chr(10)||
'                    {'||chr(10)||
'                     source.copyState = function(){return false;};'||chr(10)||
'                    }'||chr(10)||
'                 });'||chr(10)||
'   dojo.subscribe("/dnd/stop", null, function(source,node,copy)'||chr(10)||
'                 {'||chr(10)||
'                  console.log("/dnd/stop",source,node);'||chr(10)||
'                  //Don''t allow copies to be made'||chr(10)||
'                  console.log("copy="+copy);'||chr(10)||
'                  if(copy == true) '||chr(10)||
'                    {'||chr(10)||
'                     source.copyState = function(){return false;};'||chr(10)||
'                    }'||chr(10)||
'                 });'||chr(10)||
'  }'||chr(10)||
'  dojo.addOnLoad(initDND);'||chr(10)||
' </script>'||chr(10)||
''||chr(10)||
'</head>'||chr(10)||
'<body>'||chr(10)||
'  <h2><center>Rearrange Narrative Sequence....</center></h2>'||chr(10)||
'  <button onclick="javascript:return(false);">Save</button>'||chr(10)||
'  <button onclick="javascript:return(false);">Cancel</button>'||chr(10)||
'  <table dojoType="dojo.dnd.Source" jsId="c3" class="container" border=1 width=100%>'||chr(10)||
'  <thead>'||chr(10)||
'  <tr>'||chr(10)||
'   <td>Para.</td>'||chr(10)||
'   <td>Activity ID</td>'||chr(10)||
'   <td>Activity Type</td>'||chr(10)||
'   <td>Activity Group</td>'||chr(10)||
'   <td>Activity Title</td>'||chr(10)||
'   <td>Completed Date</td>'||chr(10)||
'   <td>Narrative Text</td>'||chr(10)||
'  </tr>'||chr(10)||
'  </thead>',
  p_plug_footer=> ' </table>'||chr(10)||
' <button onclick="javascript:return(false);">Save</button>'||chr(10)||
' <button onclick="javascript:return(false);">Cancel</button>'||chr(10)||
'</body>'||chr(10)||
'</html>'||chr(10)||
'',
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
s:=s||'<style>'||chr(10)||
'.chatContainer {	'||chr(10)||
'	width:320px;'||chr(10)||
'	height:260px;'||chr(10)||
'        border:1px solid black;'||chr(10)||
'	padding-top:7px;'||chr(10)||
'	padding-left:12px;'||chr(10)||
'	text-align:center;'||chr(10)||
'	background:#fff url("bg.jpg") repeat-x top left;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.chatBox {'||chr(10)||
'	width:300px;'||chr(10)||
'	height:160px;'||chr(10)||
'	padding-left:5px;'||chr(10)||
'	background-color:#FFFFFF;'||chr(10)||
'	overflow:auto;'||chr(10)||
'        text-align:left;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.buttonArea{ '||chr(10)||
'        padding-top:5px;'||chr(10)||
'	padding-right:10px;'||chr(10)||
'	text-align:';

s:=s||'right;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'.button{ '||chr(10)||
'   font-size:84%;'||chr(10)||
''||chr(10)||
'}'||chr(10)||
'	'||chr(10)||
'.inputBox {'||chr(10)||
'	width:260px;'||chr(10)||
'}'||chr(10)||
'</style>'||chr(10)||
''||chr(10)||
'<script language="JavaScript" src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" djConfig="isDebug: false, parseOnLoad: true"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'dojo.provide("samples.widget.ChatWidget");'||chr(10)||
'dojo.require("dojox.cometd");'||chr(10)||
'dojo.require("dijit._Widget");'||chr(10)||
'dojo.require("dijit._Templated");'||chr(10)||
''||chr(10)||
'dojo.decla';

s:=s||'re("samples.widget.ChatWidget", [dijit._Widget, dijit._Templated], {'||chr(10)||
'    templatePath: dojo.moduleUrl("samples", "widget/templates/ChatWidget.html"),'||chr(10)||
'   '||chr(10)||
'    title: "Chat",'||chr(10)||
'    chatTopic:"",'||chr(10)||
'    chatName:"",'||chr(10)||
'  '||chr(10)||
'    postCreate: function(){  '||chr(10)||
'        dojox.cometd.subscribe(this.chatTopic,this, "receiveMessage");'||chr(10)||
'        this.chatName = "User" +(Math.floor(Math.random()*10000) + 1);'||chr(10)||
'        this.name';

s:=s||'Value.value = this.chatName;'||chr(10)||
'        this._appendText(this.titleText, this.title);'||chr(10)||
'        dojox.cometd.publish(this.chatTopic, { user: this.chatName, operation:"new"});'||chr(10)||
'    },'||chr(10)||
'		'||chr(10)||
'    receiveMessage: function(message){'||chr(10)||
'        var chatarea = dojo.byId(this.chatBox);'||chr(10)||
'        if (message.data.operation == "rename")'||chr(10)||
'            chatarea.innerHTML = chatarea.innerHTML + "<br><i>" + message.data.oldUse';

s:=s||'r + " has changed names to " + message.data.user + ".</i>";   '||chr(10)||
'        else if (message.data.operation == "new")'||chr(10)||
'            chatarea.innerHTML = chatarea.innerHTML + "<br><i>" + message.data.user + " has joined the chat.</i>";   '||chr(10)||
'        else if (message.data.operation == "message")'||chr(10)||
'            chatarea.innerHTML = chatarea.innerHTML + "<br><i>" + message.data.user + ":</i>&nbsp;&nbsp;" +  messag';

s:=s||'e.data.message;    '||chr(10)||
'       chatarea.scrollTop = chatarea.scrollHeight;'||chr(10)||
'    },'||chr(10)||
'    '||chr(10)||
'    sendMessage: function() {'||chr(10)||
'       dojox.cometd.publish(this.chatTopic, {message: this.chatText.value, user: this.chatName, operation:"message"});'||chr(10)||
'       this.chatText.value = ""; '||chr(10)||
'    }, '||chr(10)||
'       '||chr(10)||
'    enterCheck: function(evt) {'||chr(10)||
'        if(evt.keyCode == dojo.keys.ENTER) {'||chr(10)||
'            this.sendMessage();'||chr(10)||
'         ';

s:=s||'   dojo.stopEvent(evt);'||chr(10)||
'        }'||chr(10)||
'    },'||chr(10)||
'    '||chr(10)||
'    _appendText: function(node, text){'||chr(10)||
'        while(node.firstChild){'||chr(10)||
'	    node.removeChild(node.firstChild);'||chr(10)||
'	}'||chr(10)||
'        node.appendChild(document.createTextNode(text));'||chr(10)||
'    },'||chr(10)||
'     '||chr(10)||
'    changeName: function() {  '||chr(10)||
'        if (this.nameValue.value == "") {'||chr(10)||
'            this.nameValue.value = this.chatName;   // Attempted to specify as blank. Revert to o';

s:=s||'riginal name'||chr(10)||
'            return;'||chr(10)||
'       }'||chr(10)||
'       if (this.nameValue.value == this.chatName)'||chr(10)||
'           return;       '||chr(10)||
'       dojox.cometd.publish(this.chatTopic, { user: this.nameValue.value, oldUser:this.chatName, operation:"rename"});   '||chr(10)||
'       this.chatName = this.nameValue.value;'||chr(10)||
'    }'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'   <div class="chatContainer">'||chr(10)||
'        <span class="title" dojoAttachPoint="titleText"></span>';

s:=s||'<br><br>'||chr(10)||
'        <div  dojoAttachPoint="chatBox" class="chatBox"></div>'||chr(10)||
'        <div class="buttonArea">'||chr(10)||
'            <input dojoAttachPoint="chatText" dojoAttachEvent="onkeypress: enterCheck" type="text"  class="inputBox" >'||chr(10)||
'            <input dojoAttachEvent="onclick: sendMessage" type="button" value="Say" class="button" ><br>     '||chr(10)||
'            <input dojoAttachPoint="nameValue" type="text" style="';

s:=s||'width:90px;" value="">'||chr(10)||
'           <button class="button" dojoAttachEvent="onclick:changeName">Change name</button>'||chr(10)||
'        </div>'||chr(10)||
'  </div>';

wwv_flow_api.create_page_plug (
  p_id=> 7511821707594896 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'DOJO Chat Widget Testing',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 90,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<html>	'||chr(10)||
'<head>'||chr(10)||
'	<style type="text/css">'||chr(10)||
'			@import "#IMAGE_PREFIX#dojo-release-1.6.1/dojo/resources/dojo.css";'||chr(10)||
'			@import "#IMAGE_PREFIX#dojo-release-1.6.1/dijit/themes/tundra/tundra.css";'||chr(10)||
'			@import "samples/widget/templates/ChatWidget.css";'||chr(10)||
'	</style>'||chr(10)||
''||chr(10)||
'    <script language="JavaScript" src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" djConfig="isDebug: false, parseOnLoad: true"></script>'||chr(10)||
'    <script type="text/JavaScript" src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js"></script>	'||chr(10)||
'    <script type="text/JavaScript">'||chr(10)||
'       '||chr(10)||
'        dojo.require("dojox.cometd");   '||chr(10)||
'        dojo.registerModulePath("samples", "../samples");'||chr(10)||
'        dojo.require("samples.widget.ChatWidget");'||chr(10)||
'        dojo.require("dojo.parser");'||chr(10)||
'        dojo.addOnLoad(function(){'||chr(10)||
'            dojox.cometd.init("cometdTest");'||chr(10)||
'        });'||chr(10)||
'      </script>'||chr(10)||
'</head><body>'||chr(10)||
''||chr(10)||
' <div align="center">'||chr(10)||
' <br><br>'||chr(10)||
'    <div'||chr(10)||
'       dojoType="samples.widget.ChatWidget"'||chr(10)||
'       title="Chat box #1"'||chr(10)||
'       chatTopic="/chatTopic1">'||chr(10)||
'    </div>   '||chr(10)||
'  </div>'||chr(10)||
'</body></html>'||chr(10)||
'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<html>'||chr(10)||
'<head>'||chr(10)||
' '||chr(10)||
'  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'||chr(10)||
'  <title>jQuery</title>'||chr(10)||
'  <style type="text/css">'||chr(10)||
'    #daddy-shoutbox {'||chr(10)||
'      padding: 5px;'||chr(10)||
'      background: #3E5468;'||chr(10)||
'      color: white;'||chr(10)||
'      width: 600px;'||chr(10)||
'      font-family: Arial,Helvetica,sans-serif;'||chr(10)||
'      font-size: 11px;'||chr(10)||
'    }'||chr(10)||
'    .shoutbox-list {'||chr(10)||
'      border-bottom: 1px solid #627C98;'||chr(10)||
'      '||chr(10)||
'      ';

s:=s||'padding: 5px;'||chr(10)||
'      display: none;'||chr(10)||
'    }'||chr(10)||
'    #daddy-shoutbox-list {'||chr(10)||
'      text-align: left;'||chr(10)||
'      margin: 0px auto;'||chr(10)||
'    }'||chr(10)||
'    #daddy-shoutbox-form {'||chr(10)||
'      text-align: left;'||chr(10)||
'      '||chr(10)||
'    }'||chr(10)||
'    .shoutbox-list-time {'||chr(10)||
'      color: #8DA2B4;'||chr(10)||
'    }'||chr(10)||
'    .shoutbox-list-nick {'||chr(10)||
'      margin-left: 5px;'||chr(10)||
'      font-weight: bold;'||chr(10)||
'    }'||chr(10)||
'    .shoutbox-list-message {'||chr(10)||
'      margin-left: 5px;'||chr(10)||
'    }'||chr(10)||
'    '||chr(10)||
'  </style>'||chr(10)||
'<scr';

s:=s||'ipt type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
''||chr(10)||
''||chr(10)||
'  <script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.5.2.min.js"></script>'||chr(10)||
'  <script type="text/javascript" src="="#IMAGE_PREFIX#jQuery/js/jquery.form.js"></script>'||chr(10)||
'</head>'||chr(10)||
'  <body>'||chr(10)||
''||chr(10)||
'  <center>'||chr(10)||
'  <div id="daddy-shoutbox">'||chr(10)||
'    <div id="daddy-shoutbox-list"></div>'||chr(10)||
'    <br />'||chr(10)||
'    <form id="daddy';

s:=s||'-shoutbox-form" action="daddy-shoutbox.php?action=add" method="post"> '||chr(10)||
'    Nick: <input type="text" name="nickname" /> Say: <input type="text" name="message" />'||chr(10)||
'    <input type="submit" value="Submit" />'||chr(10)||
'    <span id="daddy-shoutbox-response"></span>'||chr(10)||
'    </form>'||chr(10)||
'  </div>'||chr(10)||
'  </center>'||chr(10)||
'  '||chr(10)||
'  <script type="text/javascript">'||chr(10)||
'        var count = 0;'||chr(10)||
'        var files = '''';'||chr(10)||
'        var lastTime = 0;'||chr(10)||
'      ';

s:=s||'  '||chr(10)||
'        function prepare(response) {'||chr(10)||
'          var d = new Date();'||chr(10)||
'          count++;'||chr(10)||
'          d.setTime(response.time*1000);'||chr(10)||
'          var mytime = d.getHours()+'':''+d.getMinutes()+'':''+d.getSeconds();'||chr(10)||
'          var string = ''<div class="shoutbox-list" id="list-''+count+''">'''||chr(10)||
'              + ''<span class="shoutbox-list-time">''+mytime+''</span>'''||chr(10)||
'              + ''<span class="shoutbox-list-nick">''+r';

s:=s||'esponse.nickname+'':</span>'''||chr(10)||
'              + ''<span class="shoutbox-list-message">''+response.message+''</span>'''||chr(10)||
'              +''</div>'';'||chr(10)||
'          '||chr(10)||
'          return string;'||chr(10)||
'        }'||chr(10)||
'        '||chr(10)||
'        function success(response, status)  { '||chr(10)||
'          if(status == ''success'') {'||chr(10)||
'            lastTime = response.time;'||chr(10)||
'            $(''#daddy-shoutbox-response'').html(''<img src="''+files+''images/accept.png" />''';

s:=s||');'||chr(10)||
'            $(''#daddy-shoutbox-list'').append(prepare(response));'||chr(10)||
'            $(''input[@name=message]'').attr(''value'', '''').focus();'||chr(10)||
'            $(''#list-''+count).fadeIn(''slow'');'||chr(10)||
'            timeoutID = setTimeout(refresh, 3000);'||chr(10)||
'          }'||chr(10)||
'        }'||chr(10)||
'        '||chr(10)||
'        function validate(formData, jqForm, options) {'||chr(10)||
'          for (var i=0; i < formData.length; i++) { '||chr(10)||
'              if (!formData[i].';

s:=s||'value) {'||chr(10)||
'                  alert(''Please fill in all the fields''); '||chr(10)||
'                  $(''input[@name=''+formData[i].name+'']'').css(''background'', ''red'');'||chr(10)||
'                  return false; '||chr(10)||
'              } '||chr(10)||
'          } '||chr(10)||
'          $(''#daddy-shoutbox-response'').html(''<img src="''+files+''images/loader.gif" />'');'||chr(10)||
'          clearTimeout(timeoutID);'||chr(10)||
'        }'||chr(10)||
''||chr(10)||
'        function refresh() {'||chr(10)||
'          $.getJSON(f';

s:=s||'iles+"daddy-shoutbox.php?action=view&time="+lastTime, function(json) {'||chr(10)||
'            if(json.length) {'||chr(10)||
'              for(i=0; i < json.length; i++) {'||chr(10)||
'                $(''#daddy-shoutbox-list'').append(prepare(json[i]));'||chr(10)||
'                $(''#list-'' + count).fadeIn(''slow'');'||chr(10)||
'              }'||chr(10)||
'              var j = i-1;'||chr(10)||
'              lastTime = json[j].time;'||chr(10)||
'            }'||chr(10)||
'            //alert(lastTime);'||chr(10)||
'     ';

s:=s||'     });'||chr(10)||
'          timeoutID = setTimeout(refresh, 3000);'||chr(10)||
'        }'||chr(10)||
'        '||chr(10)||
'        // wait for the DOM to be loaded '||chr(10)||
'        $(document).ready(function() { '||chr(10)||
'            var options = { '||chr(10)||
'              dataType:       ''json'','||chr(10)||
'              beforeSubmit:   validate,'||chr(10)||
'              success:        success'||chr(10)||
'            }; '||chr(10)||
'            $(''#daddy-shoutbox-form'').ajaxForm(options);'||chr(10)||
'            timeoutID =';

s:=s||' setTimeout(refresh, 100);'||chr(10)||
'        });'||chr(10)||
'  </script>'||chr(10)||
'</body>'||chr(10)||
'</html>';

wwv_flow_api.create_page_plug (
  p_id=> 7513311168781100 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'JQUERY Shoutbox',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 100,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<!-- <div style="display:none"> -->'||chr(10)||
'<!-- <form name="otherParams">'||chr(10)||
'   parent: <input type="text" name="pOBJ" value="22200000GAB"/>'||chr(10)||
'   person: <input type="text" name="pPER" value="22200000GAC"/>'||chr(10)||
' </form> -->'||chr(10)||
'<!-- </div> -->'||chr(10)||
''||chr(10)||
'<APPLET '||chr(10)||
'  CODE="wjhk.jupload2.JUploadApplet"'||chr(10)||
'  NAME="JUpload"'||chr(10)||
'  ARCHIVE="http://hqcuiwebi2ms:8080/jUpload/wjhk.jupload.jar"'||chr(10)||
'  WIDTH="640"'||chr(10)||
'  HEIGHT="300"'||chr(10)||
'  MAYSCRIPT="true"'||chr(10)||
'  ';

s:=s||'ALT="The java plugin must be installed.">'||chr(10)||
''||chr(10)||
'  <param name="postURL" '||chr(10)||
'        value="http://hqcuiwebi2ms:8080/jUpload/parseRequest.jsp" />'||chr(10)||
'  <param name="lookAndFeel"   value="system" />'||chr(10)||
'  <param name="maxFileSize"   value="15728640" />'||chr(10)||
'  <param name="debugLevel"    value="99" />'||chr(10)||
'  <param name="showLogWindow" value="true" />'||chr(10)||
'  <param name="stringUploadSuccess" value="SUCCESS" />'||chr(10)||
'  <param name="uploa';

s:=s||'dPolicy" value="FileByFileUploadPolicy" />'||chr(10)||
'  <param name="formdata" value="otherParams" />'||chr(10)||
'  <param name="afterUploadURL" value="javascript:alert(''%body%'');" />'||chr(10)||
'  Java 1.5 or higher plugin required. '||chr(10)||
'</APPLET>';

wwv_flow_api.create_page_plug (
  p_id=> 7643127438430700 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'jUpload',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 110,
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
  p_plug_display_condition_type => 'NEVER',
  p_plug_display_when_condition => ':P99999999_LOCATION_VALUE IN (''DB'', ''FILE'')',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '  <param name="uploadPolicy" value="SuperSimpleUploadPolicy" />'||chr(10)||
'  <param name="uploadPolicy" value="FileByFileUploadPolicy" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'function afterUpload()'||chr(10)||
'{'||chr(10)||
' alert(fileData.getFileName());'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function newFileUploaded(String filename)'||chr(10)||
'{'||chr(10)||
' alert(filename);'||chr(10)||
' //addToGlobalArray(filename);'||chr(10)||
' //displayFilelist();'||chr(10)||
'}'||chr(10)||
'</script>');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<script language="JavaScript" src="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/dojo.js" djConfig="isDebug: false, parseOnLoad: true"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
''||chr(10)||
'dojo.require("dojox.cometd");'||chr(10)||
'dojo.require("dojox.cometd.timestamp");'||chr(10)||
''||chr(10)||
'var room = {'||chr(10)||
'	_last: "",'||chr(10)||
'	_username: null,'||chr(10)||
'	_connected: true,'||chr(10)||
'	groupName: "whimsical",'||chr(10)||
''||chr(10)||
'	join: function(name){'||chr(10)||
''||chr(10)||
'		if(name == null || name.length==0 ){'||chr(10)||
'			aler';

s:=s||'t(''Please enter a username!'');'||chr(10)||
'		}else{'||chr(10)||
''||chr(10)||
'			dojox.cometd.init(new String(document.location).replace(/http:\/\/[^\/]*/,'''').replace(/\/examples\/.*$/,'''')+"/cometd");'||chr(10)||
'			// dojox.cometd.init("http://127.0.0.2:8080/cometd");'||chr(10)||
'			this._connected = true;'||chr(10)||
''||chr(10)||
'			this._username = name;'||chr(10)||
'			dojo.byId(''join'').className=''hidden'';'||chr(10)||
'			dojo.byId(''joined'').className='''';'||chr(10)||
'			dojo.byId(''phrase'').focus();'||chr(10)||
''||chr(10)||
'			// subscrib';

s:=s||'e and join'||chr(10)||
'			dojox.cometd.startBatch();'||chr(10)||
'			dojox.cometd.subscribe("/chat/demo", room, "_chat", { groupName: this.groupName});'||chr(10)||
'			dojox.cometd.publish("/chat/demo", { '||chr(10)||
'				user: room._username,'||chr(10)||
'				join: true,'||chr(10)||
'				chat : room._username+" has joined"'||chr(10)||
'			}, { groupName: this.groupName });'||chr(10)||
'			dojox.cometd.endBatch();'||chr(10)||
''||chr(10)||
'			// handle cometd failures while in the room'||chr(10)||
'			room._meta = dojo.subscribe("/com';

s:=s||'etd/meta", this, function(event){'||chr(10)||
'				console.debug(event);   '||chr(10)||
'				if(event.action == "handshake"){'||chr(10)||
'					room._chat({ data: {'||chr(10)||
'						join: true,'||chr(10)||
'						user:"SERVER",'||chr(10)||
'						chat:"reinitialized"'||chr(10)||
'					} });'||chr(10)||
'					dojox.cometd.subscribe("/chat/demo", room, "_chat", { groupName: this.groupName });'||chr(10)||
'				}else if(event.action == "connect"){'||chr(10)||
'					if(event.successful && !this._connected){'||chr(10)||
'						room._chat({ d';

s:=s||'ata: {'||chr(10)||
'							leave: true,'||chr(10)||
'							user: "SERVER",'||chr(10)||
'							chat: "reconnected!"'||chr(10)||
'						} });'||chr(10)||
'					}'||chr(10)||
'					if(!event.successful && this._connected){'||chr(10)||
'						room._chat({ data: {'||chr(10)||
'							leave: true,'||chr(10)||
'							user: "SERVER",'||chr(10)||
'							chat: "disconnected!"'||chr(10)||
'						} });'||chr(10)||
'					}'||chr(10)||
'					this._connected = event.successful;'||chr(10)||
'				}'||chr(10)||
'			}, {groupName: this.groupName });'||chr(10)||
'		}'||chr(10)||
'	},'||chr(10)||
''||chr(10)||
'	leave: function(){'||chr(10)||
'		if(!room._username){'||chr(10)||
'		';

s:=s||'	return;'||chr(10)||
'		}'||chr(10)||
''||chr(10)||
'		if(room._meta){'||chr(10)||
'			dojo.unsubscribe(room._meta, null, null, { groupName: this.groupName });'||chr(10)||
'		}'||chr(10)||
'		room._meta=null;'||chr(10)||
''||chr(10)||
'		dojox.cometd.startBatch();'||chr(10)||
'		dojox.cometd.unsubscribe("/chat/demo", room, "_chat", { groupName: this.groupName });'||chr(10)||
'		dojox.cometd.publish("/chat/demo", { '||chr(10)||
'			user: room._username,'||chr(10)||
'			leave: true,'||chr(10)||
'			chat : room._username+" has left"'||chr(10)||
'		}, { groupName: this.groupName ';

s:=s||'});'||chr(10)||
'		dojox.cometd.endBatch();'||chr(10)||
''||chr(10)||
'		// switch the input form'||chr(10)||
'		dojo.byId(''join'').className='''';'||chr(10)||
'		dojo.byId(''joined'').className=''hidden'';'||chr(10)||
'		dojo.byId(''username'').focus();'||chr(10)||
'		room._username = null;'||chr(10)||
'		dojox.cometd.disconnect();'||chr(10)||
'	},'||chr(10)||
''||chr(10)||
'	chat: function(text){'||chr(10)||
'		if(!text || !text.length){'||chr(10)||
'			return false;'||chr(10)||
'		}'||chr(10)||
'		dojox.cometd.publish("/chat/demo", { user: room._username, chat: text}, { groupName: this.groupNam';

s:=s||'e });'||chr(10)||
'	},'||chr(10)||
''||chr(10)||
'	_chat: function(message){'||chr(10)||
'		var chat=dojo.byId(''chat'');'||chr(10)||
'		if(!message.data){'||chr(10)||
'			console.debug("bad message format "+message);'||chr(10)||
'			return;'||chr(10)||
'		}'||chr(10)||
'		var from=message.data.user;'||chr(10)||
'		var special=message.data.join || message.data.leave;'||chr(10)||
'		var text=message.data.chat;'||chr(10)||
'		if(!text){ return; }'||chr(10)||
''||chr(10)||
'		if( !special && from == room._last ){'||chr(10)||
'			from="...";'||chr(10)||
'		}else{'||chr(10)||
'			room._last=from;'||chr(10)||
'			from+=":";'||chr(10)||
'		}'||chr(10)||
''||chr(10)||
'		if(';

s:=s||'special){'||chr(10)||
'			chat.innerHTML += "<span class=\"alert\">"+from+" "+text+"";'||chr(10)||
'			room._last="";'||chr(10)||
'		}else{'||chr(10)||
'			chat.innerHTML += "<span class=\"from\">"+from+" "+text+"";'||chr(10)||
'		} '||chr(10)||
'		chat.scrollTop = chat.scrollHeight - chat.clientHeight;    '||chr(10)||
'	},'||chr(10)||
''||chr(10)||
'	_init: function(){'||chr(10)||
'		dojo.byId(''join'').className='''';'||chr(10)||
'		dojo.byId(''joined'').className=''hidden'';'||chr(10)||
'		dojo.byId(''username'').focus();'||chr(10)||
''||chr(10)||
'		var element=dojo.byId(''username''';

s:=s||');'||chr(10)||
'		element.setAttribute("autocomplete","OFF"); '||chr(10)||
'		dojo.connect(element, "onkeyup", function(e){   '||chr(10)||
'			if(e.keyCode == dojo.keys.ENTER){'||chr(10)||
'				room.join(dojo.byId(''username'').value);'||chr(10)||
'				return false;'||chr(10)||
'			}'||chr(10)||
'			return true;'||chr(10)||
'		});'||chr(10)||
''||chr(10)||
'		dojo.connect(dojo.byId(''joinB''), "onclick", function(e){'||chr(10)||
'			room.join(dojo.byId(''username'').value);'||chr(10)||
'			e.preventDefault();'||chr(10)||
'		});'||chr(10)||
''||chr(10)||
'		element=dojo.byId(''phrase'');'||chr(10)||
'		element';

s:=s||'.setAttribute("autocomplete","OFF");'||chr(10)||
'		dojo.connect(element, "onkeyup", function(e){   '||chr(10)||
'			if(e.keyCode == dojo.keys.ENTER){'||chr(10)||
'				room.chat(dojo.byId(''phrase'').value);'||chr(10)||
'				dojo.byId(''phrase'').value='''';'||chr(10)||
'				e.preventDefault();'||chr(10)||
'			}'||chr(10)||
'		});'||chr(10)||
''||chr(10)||
'                dojo.connect(dojo.byId(''sendB''), "onclick", function(e){   '||chr(10)||
'                        room.chat(dojo.byId(''phrase'').value);'||chr(10)||
'                        d';

s:=s||'ojo.byId(''phrase'').value='''';'||chr(10)||
'                });'||chr(10)||
'		dojo.connect(dojo.byId(''leaveB''), "onclick", room, "leave");'||chr(10)||
'	} '||chr(10)||
'};'||chr(10)||
''||chr(10)||
'dojo.addOnLoad(room, "_init");'||chr(10)||
'dojo.addOnUnload(room,"leave");'||chr(10)||
''||chr(10)||
'</script>';

wwv_flow_api.create_page_plug (
  p_id=> 7654012502024096 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'More DOJO Chatting Stuff',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 120,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
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
s:=s||'<script language="JavaScript">'||chr(10)||
'function app_AppMenuMultiOpenRight(pThis,pThat,pSub){'||chr(10)||
'      var lMenu = $x(pThat);'||chr(10)||
'      if(pThis != gCurrentAppMenuImage){'||chr(10)||
'        app_AppMenuMultiClose();'||chr(10)||
'        var l_That = pThis.parentNode; '||chr(10)||
'        pThis.className = g_dhtmlMenuOn;'||chr(10)||
'        dhtml_MenuOpen(l_That,pThat,false,''Right'');'||chr(10)||
'        gCurrentAppMenuImage = pThis;'||chr(10)||
'      }else{'||chr(10)||
'        dhtml_CloseAllSubMen';

s:=s||'us();'||chr(10)||
'        app_AppMenuMultiClose();'||chr(10)||
'      }'||chr(10)||
'  return;'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'<ul class="dhtmlMenuLG2"><li class="dhtmlMenuItem1"><a>Reports</a><img src="/i/themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenRight(this,''L33315YNF'',false)" style="cursor: pointer;"/></li><ul id="L33315YNF" htmldb:listlevel="2" class="dhtmlSubMenu2" style="display:none;"><li><a href="javascript:void(0)';

s:=s||'" onclick="javascript:window.open(''f?p=100:800:815447527488078::NO::P800_REPORT_TYPE,P0_OBJ:22203484,33315YNF''); return false;" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">Form 40 Summary</a></li><li><a href="javascript:void(0)" onclick="javascript:window.open(''f?p=100:800:815447527488078::NO::P800_REPORT_TYPE,P0_OBJ:222000005L7,33315YNF''); return false;" class="dhtmlSubMenuN';

s:=s||'" onmouseover="dhtml_CloseAllSubMenusL(this)">Form 40</a></li></ul></ul>';

wwv_flow_api.create_page_plug (
  p_id=> 8236821206525182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'TEST Report Menu',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 130,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'NEVER',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<ul class="dhtmlMenuLG2"><li class="dhtmlMenuItem1"><a>Reports</a><img src="/i/themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''L100523423001863899'',false)" '||chr(10)||
'  style="cursor: pointer;"/>'||chr(10)||
'</li><ul id="L100523423001863899" htmldb:listlevel="2" class="dhtmlSubMenu2" style="display:none;"><li><a href="javascript:void(0)" onclick="javascript:window.open(''f?p=100:800:815447527488078::NO::P800_REPORT_TYPE,P0_OBJ:22203484,3330BR7D''); return false;" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">Form 40 Summary</a></li><li><a href="javascript:void(0)" onclick="javascript:window.open(''f?p=100:800:815447527488078::NO::P800_REPORT_TYPE,P0_OBJ:222000005L7,3330BR7D''); return false;" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">Form 40</a></li></ul></ul>');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 9260217541605189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'Testing Email to USACIL',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 140,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
  p_id=> 10478111854566105 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'Testing New Locator',
  p_region_name=>'',
  p_plug_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 150,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> ' var iframesource = ''<iframe width="100%" '' +'||chr(10)||
'                    ''height="100%" '' +'||chr(10)||
'                    ''frameborder="0" '' +'||chr(10)||
'                    ''name="popupFrame id="popupFrame" '' +'||chr(10)||
'                    ''allowtransparencty="true" '' +'||chr(10)||
'                    ''style="width: 796px; height: 500px; background-color: transparent;" '' +'||chr(10)||
'                    ''src="f?p=&APP_ID.:''+pPage+'':&SESSION.:OPEN:NO:''+pPage+'':P''+pPage+''_OBJECT_TYPE,P''+pPage+''_OBJ,P''+pPage+''_RETURN_ITEM,P''+pPage+''_MULTI,P''+pPage+''_EXCLUDE:''+'||chr(10)||
'                    pType+'',''+pOBJ+'',''+pReturnItemName+'',''+pMulti+'',''+pExclude+'':"></iframe>'';'||chr(10)||
'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<script language=javascript>'||chr(10)||
'//***************************************************'||chr(10)||
'// File:     Environment.js (WSH sample in JScript)   '||chr(10)||
'// Author:   (c) G. Born'||chr(10)||
'// '||chr(10)||
'// Displaying environment variables by using the'||chr(10)||
'// WshShell object'||chr(10)||
'//***************************************************'||chr(10)||
''||chr(10)||
'var Message, Title;'||chr(10)||
'var vbInformation = 64;'||chr(10)||
'var vbOKOnly = 0;'||chr(10)||
''||chr(10)||
'// Get WshShell object.'||chr(10)||
'//var WshShell = WScrip';

s:=s||'t.CreateObject("WScript.Shell");'||chr(10)||
'//  var WshShell = WScript.CreateObject("WSCRIPT.SHELL");'||chr(10)||
'//var WshShell = ActiveXObject("WScript.Shell");'||chr(10)||
'  var WshShell = ActiveXObject("WSCRIPT.SHELL");'||chr(10)||
''||chr(10)||
'// Get collection by using the Environment property.'||chr(10)||
'var objEnv = WshShell.Environment("Process");'||chr(10)||
''||chr(10)||
'// Read environment variables.'||chr(10)||
'Message = "Environment variables\n\n";'||chr(10)||
'Message = Message + "Path: " + objEnv("P';

s:=s||'ATH") + "\n";'||chr(10)||
'Message = Message + "Extensions: " + objEnv("PATHEXT") + "\n";'||chr(10)||
'Message = Message + "Prompt: " + objEnv("PROMPT") + "\n";'||chr(10)||
''||chr(10)||
'Message = Message + "System Drive: " + objEnv("SYSTEMDRIVE") + "\n";'||chr(10)||
'Message = Message + "System Root: " + objEnv("SYSTEMROOT") + "\n";'||chr(10)||
'Message = Message + "Windows Directory: " + objEnv("WINDIR") + "\n";'||chr(10)||
''||chr(10)||
'Message = Message + "TEMP: " + objEnv("TEMP") + "\n";'||chr(10)||
'Mess';

s:=s||'age = Message + "TMP: " + objEnv("TMP") + "\n";'||chr(10)||
''||chr(10)||
'Message = Message + "OS: " + objEnv("OS") + "\n";'||chr(10)||
''||chr(10)||
'// Get user-defined environment variable.'||chr(10)||
'Message = Message + "Blaster: " + objEnv("BLASTER") + "\n";'||chr(10)||
''||chr(10)||
'// Initialize title text.'||chr(10)||
'Title = "WSH sample " + WScript.ScriptName + " - by G. Born";'||chr(10)||
''||chr(10)||
'WshShell.Popup(Message, vbInformation + vbOKOnly, Title);'||chr(10)||
''||chr(10)||
'//*** End'||chr(10)||
''||chr(10)||
''||chr(10)||
'//var wshShell = new ActiveXObject("W';

s:=s||'script.Shell");'||chr(10)||
'//var wshshell = new ActiveXObject("wscript.shell");'||chr(10)||
'//var wshEnv = wshShell.Environment("Process");'||chr(10)||
'//var username = wshEnv.Item("UserName");'||chr(10)||
'//alert(username);'||chr(10)||
''||chr(10)||
''||chr(10)||
'/*'||chr(10)||
''||chr(10)||
'<!--'||chr(10)||
'//    var wshshell = new ActiveXObject("wscript.shell");'||chr(10)||
'//    var username = wshshell.ExpandEnvironmentStrings("%username%");'||chr(10)||
'//    var hostname = "domainame";'||chr(10)||
'//    var linktext = username + "@" + hostname;'||chr(10)||
'//';

s:=s||'    alert(displayname + "<br>")'||chr(10)||
'//    alert("<a href=" + "mail" + "to:" + username + "@" + hostname + ">" + linktext + "</a>") '||chr(10)||
'-->'||chr(10)||
'*/'||chr(10)||
''||chr(10)||
'/*'||chr(10)||
'var conn = new ActiveXObject("ADODB.Connection");'||chr(10)||
'conn.Open("Provider=ADsDSOObject");'||chr(10)||
'var rs = conn.Execute("<LDAP://DC=your-domain,DC=com>;(objectClass=user);sn,givenname");'||chr(10)||
'var i;'||chr(10)||
'if(!rs.EOF)'||chr(10)||
'{'||chr(10)||
'    rs.MoveFirst();'||chr(10)||
'    while(!rs.EOF)'||chr(10)||
'    {'||chr(10)||
''||chr(10)||
'        WScript.Ech';

s:=s||'o(rs.Fields.Item("givenname")+","+rs.Fields.Item("sn")+"\n");'||chr(10)||
'        rs.MoveNext();'||chr(10)||
'    }'||chr(10)||
'}'||chr(10)||
'*/'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
''||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 11623024381974831 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 99999999,
  p_plug_name=> 'Testing Getting Active Directory Username',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 160,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
 
wwv_flow_api.create_page_branch(
  p_id=>7099625661173022 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_branch_action=> 'f?p=&APP_ID.:99999999:&SESSION.::&DEBUG.:::#top',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'NEVER',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 04-AUG-2011 07:19 by TWARD');
 
wwv_flow_api.create_page_branch(
  p_id=>9260706108611519 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_branch_action=> 'f?p=&FLOW_ID.:99999999:&SESSION.',
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
  p_id=>7125727918537996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_id=>7131306577309349 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7132201691355246 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7132406193356583 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7132612081358278 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7135116123851454 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7135323049853415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7135527205854613 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7135732400856115 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7135904826857622 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML10',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html2',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>9260506590611519 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_EMAIL_TO_USACIL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 9260217541605189+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'EMAILUSACIL',
  p_prompt=>'Email USACIL',
  p_source=>'EMAILUSACIL',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(179221063608554498 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>10479401165591451 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:popupLocator(301,''P99999999_LOCATOR_VALUE'',''N'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'','''',''OPEN'','''','''',''Choose a Military Location...'',''MILITARY_LOCS'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<!-- <a href="javascript:openLocator2(550,''P11120_OFFENSE'',''Y'', ''&P11120_EXCLUDE_SIDS.'');">&ICON_LOCATOR.</a> -->',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P11130_OFF_ON_USI=''Y''',
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
  p_id=>10543002123226311 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_LOCATOR_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 119,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Value',
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
  p_id=>10544618316249906 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_LOCATOR_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 119.1,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Display',
  p_source=>'declare'||chr(10)||
''||chr(10)||
'  v_location_name varchar2(200);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if :P99999999_LOCATOR_CODE is not null then'||chr(10)||
''||chr(10)||
'       SELECT LOCATION_NAME into v_location_name'||chr(10)||
'             FROM T_SAPRO_LOCATIONS '||chr(10)||
'                 WHERE LOCATION_CODE=:P99999999_LOCATOR_CODE;'||chr(10)||
'       '||chr(10)||
'       return v_location_name;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'        return null;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'exception when others then'||chr(10)||
'         return null;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_cattributes_element=>'style="width:100%;"',
  p_tag_attributes  => 'style="width:95%;"',
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
  p_id=>10603621102733725 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_LOCATOR_PARTICIPANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Participant',
  p_source=>'<a href="javascript:popupLocator(302,''P99999999_LOCATOR_CODE'',''Y'',''sids_~3330BQIY~33316YH6~3330TTAO'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<!--javascript:popupLocator(400,''P5300_SEL_PARTICIPANT'',''Y'');-->'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~3330BQIY~33316YH6~3330TTAO'',''OPEN'','''','''',''Choose a Participant...'',''PARTICIPANT'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10742619298940688 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_OFFENSE_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Offenses',
  p_source=>'<a href="javascript:popupLocator(550,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Offenses...'',''OFFENSE'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Offenses...'',''OFFENSE'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10779118089028467 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_ACTIVITIES_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Activities',
  p_source=>'<a href="javascript:popupLocator(300,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Activities...'',''ACT'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Activities...'',''ACT'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10782515169216864 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_PERSONNEL_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Personnel',
  p_source=>'<a href="javascript:popupLocator(350,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Personnel...'',''PERSONNEL'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Personnel...'',''PERSONNEL'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10791202336411899 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_FILES_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Files',
  p_source=>'<a href="javascript:popupLocator(450,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Files...'',''FILE'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Files...'',''FILE'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10793406595545570 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_UNITS_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Units',
  p_source=>'<a href="javascript:popupLocator(500,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Files...'',''UNITS'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Files...'',''UNITS'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10795326905617688 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_UNITS_RPO_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator RPO Units',
  p_source=>'<a href="javascript:popupLocator(501,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose RPO  Units...'',''UNITS_RPO'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose RPO Units...'',''UNITS_RPO'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10798831341789242 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_SOURCES_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Sources',
  p_source=>'<a href="javascript:popupLocator(850,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Sources...'',''SOURCES'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Sources...'',''SOURCES'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10802804601876217 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_BRIEFING_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Briefing Topics',
  p_source=>'<a href="javascript:popupLocator(600,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Topics Briefed...'',''BRIEFING'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose Topics Briefed...'',''BRIEFING'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10805424920023991 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_UNITS_EFUNDS_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator E-Funds Units',
  p_source=>'<a href="javascript:popupLocator(650,''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''N'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose E-Funds Units...'',''UNITS_EFUNDS'',''3330BPJG'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~222000006A4~222000006A5~222000006A6~222000006A7~222000006A8'',''OPEN'','''','''',''Choose E-Funds Units...'',''UNITS_EFUNDS'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10813023711179676 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_PART_EXCLUDE_LOCATOR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator Participant (Exclude Types)',
  p_source=>'<a href="javascript:popupLocator(400,''P5300_SEL_PARTICIPANT'',''Y'',''SIDS_~33315QN8~3330C396~3330BV15~3330TW4U~333168TO~33315Y9A~33315RKB~333166ZC~3330BSKL~3331688V~33316780~333165G9~3330C8I5'',''OPEN'',''P400_PARTIC_TYPE_LIST'',''~PART.NONINDIV.COMP~PART.NONINDIV.ORG~'');">&ICON_LOCATOR.</a>'||chr(10)||
''||chr(10)||
'<a href="javascript:openLocator(''301'',''P99999999_LOCATOR_CODE'',''Y'',''sids_~3330BQIY~33316YH6~3330TTAO'',''OPEN'',''P301_ACTIVE_FILTER_EXCLUDES'',''All Participant Types;ALL~Individuals by Name;PART.INDIV~Programs;PART.NONINDIV.PROG'',''Choose a Company or Organization...'',''PARTICIPANT'',''3330BPJG'');">&ICON_LOCATOR.</a>',
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
  p_id=>10814018002215866 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_LOCATOR_IN_STATUS_WINDOW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Locator within a STATUS Window.....',
  p_source=>'<a onmouseover="dhtml_CloseAllSubMenusL(this)" class="dhtmlSubMenuN" onclick="javascript:runPopWin(''Status'',''3331643A'',''22200000GCF''); return false;" href="javascript:void(0)">Unarchive</a>',
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
  p_id=>11104218461126231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_TESTING_ADDING_A_LINK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 10478111854566105+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Testing Adding A Link',
  p_pre_element_text=>'<span id="addHere">Will be Added here.</span>'||chr(10)||
'<script>'||chr(10)||
'function testing()'||chr(10)||
'{'||chr(10)||
'// var anchor = document.getElementById("testing");'||chr(10)||
'// console.debug(''anchor.value=''+anchor.value);'||chr(10)||
'// console.debug(''anchor.text=''+anchor.text);'||chr(10)||
''||chr(10)||
'// var element = document.createElement("BUTTON");'||chr(10)||
' var element = document.createElement("a");'||chr(10)||
' element.setAttribute(''href'',"yourlink.htm");'||chr(10)||
' element.innerHTML = "link text";'||chr(10)||
''||chr(10)||
' var AddHere = document.getElementById("addHere");'||chr(10)||
' console.debug(''span.text=''+AddHere.text);'||chr(10)||
' console.debug(''span.value=''+AddHere.value);'||chr(10)||
' console.debug(''span.innerHTML=''+AddHere.innerHTML);'||chr(10)||
' console.debug(''span=''+AddHere);'||chr(10)||
' '||chr(10)||
' //Append the element in page (in span).'||chr(10)||
' AddHere.appendChild(element);'||chr(10)||
'}'||chr(10)||
'</script>',
  p_source=>'<a href="javascript:testing();">&ICON_LOCATOR.</a>'||chr(10)||
'<a href="javascript:testing();" id=''testing''>this is a test</a>',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
''||chr(10)||
'  v_eft_blob blob;'||chr(10)||
'  v_filename varchar2(4000);'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'     select content,id || ''-FP.eft'' into v_eft_blob,v_filename '||chr(10)||
'       from t_osi_activity a,t_osi_attachment at,t_osi_attachment_type t'||chr(10)||
'        where a.sid=at.obj'||chr(10)||
'          and at.type=t.sid'||chr(10)||
'          and t.usage=''FINGERPRINT'''||chr(10)||
'          and a.sid=''3330C5BT'';'||chr(10)||
''||chr(10)||
'     OSI_SENDMAIL.send_blob_via_email(''timothy.ward.ctr@ogn.af.mil'',''timoth';

p:=p||'y.ward.ctr@ogn.af.mil'',''Fingerprint EFTS File'',v_filename,v_eft_blob);'||chr(10)||
'     --OSI_SENDMAIL.send(''timothy.ward.ctr@ogn.af.mil'',''timothy.ward.ctr@ogn.af.mil'',''Fingerprint EFTS File'');'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 9260813057755327 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 99999999,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'EMAILUSACIL',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'EMAILUSACIL',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'DECLARE'||chr(10)||
'  '||chr(10)||
'  v_cnt number;'||chr(10)||
'  v_return clob;'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'  '||chr(10)||
'  v_cnt := 1;'||chr(10)||
'  :p99999999_html1 := '''';'||chr(10)||
'  :p99999999_html2 := '''';'||chr(10)||
'  :p99999999_html3 := '''';'||chr(10)||
'  :p99999999_html4 := '''';'||chr(10)||
'  :p99999999_html5 := '''';'||chr(10)||
''||chr(10)||
'  for a in (select SID,'||chr(10)||
'                   SEQ,'||chr(10)||
'                   ID,'||chr(10)||
'                   SUBTYPE_DESC,'||chr(10)||
'                   ROI_GROUP,'||chr(10)||
'                   TITLE,'||chr(10)||
'                   ACTIVITY_DATE,'||chr(10)||
'       ';

p:=p||'            COMPLETE_DATE,'||chr(10)||
'                   decode(SELECTED, ''Y'',''Yes'',''N'',''No'',null) as Selected,   '||chr(10)||
'                   substr(NARRATIVE,1,50) AS NARRATIVE,'||chr(10)||
'                   activity_sid'||chr(10)||
'                   from V_OSI_RPT_AVAIL_ACTIVITY where spec=''33317WC8'' order by SEQ) --and &P820_FILTERS.'||chr(10)||
' loop'||chr(10)||
'     v_return := v_return || ''<tr class="dojoDndItem" id="'' || a.activity_sid || ''">'';'||chr(10)||
'     v_re';

p:=p||'turn := v_return || ''<td>'' || a.SEQ || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.ID || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.SUBTYPE_DESC || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.ROI_GROUP || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.TITLE || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.COMPLETE_DATE || ''</td>'';'||chr(10)||
'     v_return := v_return || ''<td>'' || a.';

p:=p||'NARRATIVE || ''</td>'';'||chr(10)||
'     v_return := v_return || ''</tr>'';'||chr(10)||
'            '||chr(10)||
'     if length(v_return) >= 22000 then'||chr(10)||
'       '||chr(10)||
'       case '||chr(10)||
'           '||chr(10)||
'           when v_cnt = 0 then'||chr(10)||
'                              :p99999999_html1 := v_return;'||chr(10)||
'           when v_cnt = 1 then'||chr(10)||
'                              :p99999999_html2 := v_return;'||chr(10)||
'           when v_cnt = 2 then'||chr(10)||
'                              :p99999999_h';

p:=p||'tml3 := v_return;'||chr(10)||
'           when v_cnt = 3 then'||chr(10)||
'                              :p99999999_html4 := v_return;'||chr(10)||
'           when v_cnt = 4 then'||chr(10)||
'                              :p99999999_html5 := v_return;'||chr(10)||
'           when v_cnt = 5 then'||chr(10)||
'                              :p99999999_html6 := v_return;'||chr(10)||
'           when v_cnt = 6 then'||chr(10)||
'                              :p99999999_html7 := v_return;'||chr(10)||
'           when v_';

p:=p||'cnt = 7 then'||chr(10)||
'                              :p99999999_html8 := v_return;'||chr(10)||
'           when v_cnt = 8 then'||chr(10)||
'                              :p99999999_html9 := v_return;'||chr(10)||
'           when v_cnt = 9 then'||chr(10)||
'                              :p99999999_html10 := v_return;'||chr(10)||
'              '||chr(10)||
'       end case;              '||chr(10)||
'       v_cnt := v_cnt+1;'||chr(10)||
'       v_return := '''';'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
' end loop;'||chr(10)||
''||chr(10)||
' if length(v_return) < ';

p:=p||'22000 then'||chr(10)||
'       '||chr(10)||
'   case '||chr(10)||
'           '||chr(10)||
'       when v_cnt = 0 then'||chr(10)||
'                          :p99999999_html1 := v_return;'||chr(10)||
'       when v_cnt = 1 then'||chr(10)||
'                          :p99999999_html2 := v_return;'||chr(10)||
'       when v_cnt = 2 then'||chr(10)||
'                          :p99999999_html3 := v_return;'||chr(10)||
'       when v_cnt = 3 then'||chr(10)||
'                          :p99999999_html4 := v_return;'||chr(10)||
'       when v_cnt = 4 then'||chr(10)||
' ';

p:=p||'                         :p99999999_html5 := v_return;'||chr(10)||
'       when v_cnt = 5 then'||chr(10)||
'                          :p99999999_html6 := v_return;'||chr(10)||
'       when v_cnt = 6 then'||chr(10)||
'                          :p99999999_html7 := v_return;'||chr(10)||
'       when v_cnt = 7 then'||chr(10)||
'                          :p99999999_html8 := v_return;'||chr(10)||
'       when v_cnt = 8 then'||chr(10)||
'                          :p99999999_html9 := v_return;'||chr(10)||
'       when v';

p:=p||'_cnt = 9 then'||chr(10)||
'                          :p99999999_html10 := v_return;'||chr(10)||
''||chr(10)||
'   end case;              '||chr(10)||
''||chr(10)||
' end if;'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 7124720159450585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 99999999,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'GetNarratives',
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
-- ...updatable report columns for page 99999999
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
