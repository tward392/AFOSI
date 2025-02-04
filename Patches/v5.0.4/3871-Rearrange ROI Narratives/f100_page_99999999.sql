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
--   Date and Time:   13:45 Monday August 8, 2011
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
prompt  ...PAGE 99999999: JQuery Testing Page
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 99999999,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'JQuery Testing Page',
  p_alias  => 'JQUERYTESTINGPAGE',
  p_step_title=> 'JQuery Testing Page',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110808134303',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
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
s:=s||'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/js/jquery-1.4.2.min.js"></script>'||chr(10)||
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
'  htp.p(:p99999999_html);'||chr(10)||
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
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<html>'||chr(10)||
'<head>'||chr(10)||
' <link type="text/css" rel="stylesheet" href="#IMAGE_PREFIX#dojo-release-1.6.1/dojo/resources/dnd.css"/>'||chr(10)||
''||chr(10)||
' <style type="text/css">'||chr(10)||
''||chr(10)||
'  body { padding: 1em; background: white; }'||chr(10)||
''||chr(10)||
'  .container { width: auto; display: block; }'||chr(10)||
'  .container.handles .dojoDndHandle { background: #fee; }'||chr(10)||
''||chr(10)||
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
'  <h1>Rearrange Narrative Sequence....</h1>'||chr(10)||
'  <table dojoType="dojo.dnd.Source" jsId="c3" class="container" border=1 width=100%>'||chr(10)||
'  <tr>'||chr(10)||
'   <th>Para.</th>'||chr(10)||
'   <th>Activity ID</th>'||chr(10)||
'   <th>Activity Type</th>'||chr(10)||
'   <th>Activity Group</th>'||chr(10)||
'   <th>Activity Title</th>'||chr(10)||
'   <th>Completed Date</th>'||chr(10)||
'   <th>Narrative Text</th>'||chr(10)||
'  </tr>',
  p_plug_footer=> ' </table>'||chr(10)||
'</body>'||chr(10)||
'</html>'||chr(10)||
'',
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
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>7125727918537996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 99999999,
  p_name=>'P99999999_HTML',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 7118716090030032+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Html',
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

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
''||chr(10)||
'  p_shown          varchar2(1);'||chr(10)||
'  p_uncheckedItems varchar2(4000);'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'  '||chr(10)||
'  :p99999999_html := (osi_investigation.get_narratives(''33317WC8''));'||chr(10)||
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
