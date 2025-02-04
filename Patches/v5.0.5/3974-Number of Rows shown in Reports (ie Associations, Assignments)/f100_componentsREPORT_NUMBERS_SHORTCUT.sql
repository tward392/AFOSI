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
--   Date and Time:   07:09 Tuesday January 10, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: REPORT_NUMBERS_SHORTCUT
--   Manifest End
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

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: SHORTCUTS 9935621558753975
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||' <div id="reportRows#REGION_ID#" style="float:right; margin:17px;">'||chr(10)||
'  <b>Rows:&nbsp;&nbsp;</b>'||chr(10)||
'  <select id="reportRowsNumber#REGION_ID#" onchange="javascript:ChangeMaxHeight#REGION_ID#();">'||chr(10)||
'   <option value="5">5</option>'||chr(10)||
'   <option value="10">10</option>'||chr(10)||
'   <option value="15">15</option>'||chr(10)||
'   <option value="20">20</option>'||chr(10)||
'   <option value="25">25</option>'||chr(10)||
'   <option value="30">30</option>'||chr(10)||
'   <opt';

c1:=c1||'ion value="35">35</option>'||chr(10)||
'   <option value="40">40</option>'||chr(10)||
'   <option value="45">45</option>'||chr(10)||
'   <option value="50">50</option>'||chr(10)||
'   <option value="55">55</option>'||chr(10)||
'   <option value="60">60</option>'||chr(10)||
'   <option value="65">65</option>'||chr(10)||
'   <option value="70">70</option>'||chr(10)||
'   <option value="75">75</option>'||chr(10)||
'   <option value="80">80</option>'||chr(10)||
'   <option value="85">85</option>'||chr(10)||
'   <option value="90">90</option>';

c1:=c1||''||chr(10)||
'   <option value="95">95</option>'||chr(10)||
'   <option value="100">100</option>'||chr(10)||
'  </select>'||chr(10)||
' </div>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'var version = getInternetExplorerVersion();'||chr(10)||
''||chr(10)||
'function getHeader(regionID)'||chr(10)||
'{'||chr(10)||
' var heads = document.getElementsByTagName( ''thead'' );'||chr(10)||
' for(var i=0;i<heads.length;i++)'||chr(10)||
'    {'||chr(10)||
'     var head = heads.item(i).parentNode.parentNode;'||chr(10)||
''||chr(10)||
'     if(head.getAttribute( ''name'' ) == regionID )'||chr(10)||
'  ';

c1:=c1||'     {'||chr(10)||
'        if(head.getAttribute( ''id'' ) == ''reportContainer'' )'||chr(10)||
'          return heads.item(i);'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
' return undefined;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function getDataColumn(header, regionID)'||chr(10)||
'{'||chr(10)||
' var headerChild = header.nextSibling;'||chr(10)||
''||chr(10)||
' if(version == -1)'||chr(10)||
'   var first = headerChild.children[0];'||chr(10)||
' else'||chr(10)||
'   var first = headerChild.firstChild;'||chr(10)||
''||chr(10)||
' if(version == -1)'||chr(10)||
'   var second = first.children[0];'||chr(10)||
' else'||chr(10)||
'   var second = ';

c1:=c1||'first.firstChild;'||chr(10)||
''||chr(10)||
' return second;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function getMaxHeight(rows,regionID)'||chr(10)||
'{'||chr(10)||
' var multiplier = 33;'||chr(10)||
' var headerHeight = 27;'||chr(10)||
''||chr(10)||
' var header = getHeader(regionID);'||chr(10)||
' '||chr(10)||
' if (header!=undefined)'||chr(10)||
'   var td = getDataColumn(header, regionID);//document.getElementById(''dataColumn'');'||chr(10)||
''||chr(10)||
' if(td!=undefined)'||chr(10)||
'   {'||chr(10)||
'    if(td.offsetHeight!= "" || td.offsetHeight>0)'||chr(10)||
'      multiplier = td.offsetHeight;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if(header!=u';

c1:=c1||'ndefined)'||chr(10)||
'   {'||chr(10)||
'    if(header.offsetHeight!= "" || header.offsetHeight>0)'||chr(10)||
'      headerHeight = header.offsetHeight;'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if (header==undefined && td==undefined)'||chr(10)||
'   return -1;'||chr(10)||
' else'||chr(10)||
'   return (multiplier*rows)+headerHeight;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ChangeMaxHeight#REGION_ID#()'||chr(10)||
'{'||chr(10)||
' var rows = getRows(''#REGION_ID#'');'||chr(10)||
' var maxHeight= getMaxHeight(rows.value,''#REGION_ID#'');'||chr(10)||
' '||chr(10)||
' if (maxHeight==-1)'||chr(10)||
'   {'||chr(10)||
'    var rows =';

c1:=c1||' document.getElementById(''reportRows#REGION_ID#'');'||chr(10)||
'    rows.style.display=''none'';'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    var div = getDIV(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'    if(div!=undefined)'||chr(10)||
'      {'||chr(10)||
'       div.style.maxHeight = maxHeight+"px";'||chr(10)||
'       refreshOtherReportRegions(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'       var get = new htmldb_Get(null,'||chr(10)||
'                                $v(''pFlowId''),'||chr(10)||
'                                ''APPLICATION_PROCESS=';

c1:=c1||'SAVE_REPORT_ROWS_NUMBER'','||chr(10)||
'                                $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
'       get.addParam(''x01'',''&APP_PAGE_ID._''+''#REGION_ID#'');       // Page#_RegionID'||chr(10)||
'       get.addParam(''x02'',rows.value);                           // Number Of Rows'||chr(10)||
'  '||chr(10)||
'       gReturn = get.get();'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'// Needed because IE displaces the Header of other Report Regions on the Page //'||chr(10)||
'// this function moves t';

c1:=c1||'he header back into its proper place                  //'||chr(10)||
'function refreshOtherReportRegions(regionID)'||chr(10)||
'{'||chr(10)||
' var divs = document.getElementsByTagName( ''div'' );'||chr(10)||
' for(var i=0;i<divs.length;i++)'||chr(10)||
'    {'||chr(10)||
'     if(divs.item(i).getAttribute( ''name'' ) != regionID )'||chr(10)||
'       {    '||chr(10)||
'        if(divs.item(i).getAttribute(''className'') == ''reportContainer'')'||chr(10)||
'          divs[i].style.scrollTop=1;'||chr(10)||
'       }'||chr(10)||
'    }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function';

c1:=c1||' getDIV(regionID)'||chr(10)||
'{'||chr(10)||
' var divs = document.getElementsByTagName( ''div'' );'||chr(10)||
' for(var i=0;i<divs.length;i++)'||chr(10)||
'    {'||chr(10)||
'     if(divs.item(i).getAttribute( ''name'' ) == regionID )'||chr(10)||
'       var div = divs.item(i);'||chr(10)||
'    }'||chr(10)||
' return div;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function getRows(regionID)'||chr(10)||
'{'||chr(10)||
' var rows = document.getElementById(''reportRowsNumber''+regionID)'||chr(10)||
''||chr(10)||
' try'||chr(10)||
'    {'||chr(10)||
'     rows.detachEvent(''onchange'',setDirty); '||chr(10)||
'     rows.removeEventListene';

c1:=c1||'r(''onchange'', setDirty, false)'||chr(10)||
'    }'||chr(10)||
' catch(err)'||chr(10)||
'      {'||chr(10)||
'      }'||chr(10)||
''||chr(10)||
' return rows;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function () '||chr(10)||
'{'||chr(10)||
' var irReport = document.getElementById(''apexir_NUM_ROWS'');'||chr(10)||
''||chr(10)||
' if(irReport==undefined)'||chr(10)||
'   {'||chr(10)||
'    var rows = getRows(''#REGION_ID#'');'||chr(10)||
'    var div = getDIV(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'    if(div!=undefined)'||chr(10)||
'      {'||chr(10)||
'       var get = new htmldb_Get(null,'||chr(10)||
'                                $v(''pFlowId''),'||chr(10)||
'';

c1:=c1||'                                ''APPLICATION_PROCESS=GET_REPORT_ROWS_NUMBER'','||chr(10)||
'                                $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
'       get.addParam(''x01'',''&APP_PAGE_ID._''+''#REGION_ID#'');       // Page#_RegionID'||chr(10)||
'    '||chr(10)||
'       gReturn = get.get();'||chr(10)||
''||chr(10)||
'       maxval = gReturn;'||chr(10)||
'       $(''option'', ''#reportRowsNumber#REGION_ID#'').each(function(i, item)'||chr(10)||
'        {'||chr(10)||
'         if ( parseInt(item.value) == ma';

c1:=c1||'xval)'||chr(10)||
'           item.selected=true;'||chr(10)||
'        });'||chr(10)||
''||chr(10)||
'       var maxHeight= getMaxHeight(maxval,''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'       if(maxHeight==-1)'||chr(10)||
'         {'||chr(10)||
'          var rows = document.getElementById(''reportRows#REGION_ID#'');'||chr(10)||
'          rows.style.display=''none'';'||chr(10)||
'         }'||chr(10)||
'       else'||chr(10)||
'         {'||chr(10)||
'          div.style.maxHeight = maxHeight+"px";'||chr(10)||
'          refreshOtherReportRegions(''#REGION_ID#'');'||chr(10)||
'         }'||chr(10)||
'  ';

c1:=c1||'    }'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    var rows = document.getElementById(''reportRows#REGION_ID#'');'||chr(10)||
'    rows.style.display=''none'';'||chr(10)||
'   }'||chr(10)||
'});'||chr(10)||
''||chr(10)||
'</script>'||chr(10)||
'</div>'||chr(10)||
'<br>';

wwv_flow_api.create_shortcut (
 p_id=> 9935621558753975 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'REPORT_NUMBERS_SHORTCUT',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
