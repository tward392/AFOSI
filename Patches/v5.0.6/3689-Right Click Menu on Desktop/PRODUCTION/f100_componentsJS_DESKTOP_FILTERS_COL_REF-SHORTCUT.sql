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
--   Date and Time:   10:39 Wednesday April 4, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_DESKTOP_FILTERS_COL_REF
--   Manifest End
--   Version: 3.2.1.00.10
 
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>1046323504969601);
 
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
 
 
prompt Component Export: SHORTCUTS 10339015946311656
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script type="text/javascript">'||chr(10)||
''||chr(10)||
'  // Handle Number of Rows Per Page (Pagination) //'||chr(10)||
'  $(function()'||chr(10)||
'   {'||chr(10)||
'    var pageNum = $v(''pFlowStepId'');'||chr(10)||
''||chr(10)||
'    maxval = $v(''P''+pageNum+''_NUM_ROWS'');'||chr(10)||
'    $(''option'', ''#apexir_NUM_ROWS'').each(function(i, item)'||chr(10)||
'     {'||chr(10)||
'      if ( parseInt(item.value) == maxval)'||chr(10)||
'        item.selected=true;'||chr(10)||
'     });'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
'function getCurrentReportTab()'||chr(10)||
'{'||chr(10)||
' var currentTab = $(''#apexir_';

c1:=c1||'REPORT_TABS'').find(''span.current'').text();'||chr(10)||
''||chr(10)||
' if(currentTab==''Working Report'')'||chr(10)||
'   return '''';'||chr(10)||
' else'||chr(10)||
'   return currentTab;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function Desktop_Filters_Col_Ref()'||chr(10)||
'{'||chr(10)||
' var pageNum = $v(''pFlowStepId'');'||chr(10)||
''||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=DESKTOP_FILTERS_SQL'','||chr(10)||
'                          $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' // Handle Ap';

c1:=c1||'ex Filters (CURRENT FILTER) //'||chr(10)||
' var searchParams = "";'||chr(10)||
' var CurrentSearchColumn = "";'||chr(10)||
' var CurrentSearch = "";'||chr(10)||
''||chr(10)||
' CurrentSearchColumn=$v(''apexir_CURRENT_SEARCH_COLUMN'');'||chr(10)||
' CurrentSearch=$v(''apexir_SEARCH'');'||chr(10)||
''||chr(10)||
' if(CurrentSearchColumn.length>0 || CurrentSearch.length>0)'||chr(10)||
'   {'||chr(10)||
'    if(CurrentSearchColumn.length==0)'||chr(10)||
'      {'||chr(10)||
'       if(CurrentSearch.length>0)'||chr(10)||
'         searchParams=''Row text contains ^~^''+Cur';

c1:=c1||'rentSearch;'||chr(10)||
'      }'||chr(10)||
'    else'||chr(10)||
'      {'||chr(10)||
'       if(CurrentSearch.length>0)'||chr(10)||
'         searchParams=CurrentSearchColumn+''^~^''+CurrentSearch;'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
' '||chr(10)||
' ////////////////////////'||chr(10)||
' // Get the Parameters //'||chr(10)||
' ////////////////////////'||chr(10)||
''||chr(10)||
' ///////////////////////////////////'||chr(10)||
' // Parameter 1 = Collection Name //'||chr(10)||
' ///////////////////////////////////'||chr(10)||
' get.addParam(''x01'',''P''+pageNum+''_CURRENT_FILTER'');    '||chr(10)||
''||chr(10)||
' ///';

c1:=c1||'/////////////////////////////////////////////'||chr(10)||
' // Parameter 2 = Filter                       //'||chr(10)||
' //  1040 = Workhours, need special processing //'||chr(10)||
' ////////////////////////////////////////////////'||chr(10)||
' if(pageNum==''1040'')'||chr(10)||
'   {'||chr(10)||
'    if ($v(''P''+pageNum+''_ALL_PRIV'')==''N'')'||chr(10)||
'      get.addParam(''x02'',''ME'');'||chr(10)||
'    else'||chr(10)||
'      get.addParam(''x02'',$v(''P''+pageNum+''_FILTER''));'||chr(10)||
''||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   get.addParam(''x02'',$v(''P''+p';

c1:=c1||'ageNum+''_FILTER''));'||chr(10)||
''||chr(10)||
' ////////////////////////////'||chr(10)||
' // Parameter 3 = User Sid //'||chr(10)||
' ////////////////////////////'||chr(10)||
' get.addParam(''x03'',$v(''USER_SID''));                  // User Sid'||chr(10)||
' '||chr(10)||
' ///////////////////////////////////'||chr(10)||
' // Parameter 4 = Object Type     //'||chr(10)||
' //  1030 = Particpants           //'||chr(10)||
' //  1110 = Investigative Files   //'||chr(10)||
' //  1130 = Service Files         //'||chr(10)||
' //  1140 = Support Files         //';

c1:=c1||''||chr(10)||
' ///////////////////////////////////'||chr(10)||
' switch(pageNum)'||chr(10)||
'       {'||chr(10)||
'        case ''1030'':'||chr(10)||
'                    get.addParam(''x04'',$v(''P''+pageNum+''_PARTIC_TYPE''));'||chr(10)||
'                    break;'||chr(10)||
''||chr(10)||
'        case ''1110'':'||chr(10)||
'        case ''1130'':'||chr(10)||
'        case ''1140'':'||chr(10)||
'                    get.addParam(''x04'',$v(''P''+pageNum+''_FILE_TYPE''));'||chr(10)||
'                    break;'||chr(10)||
''||chr(10)||
'            default:'||chr(10)||
'                    get.addParam(';

c1:=c1||'''x04'',$v(''P''+pageNum+''_OBJECT_TYPE''));'||chr(10)||
'                    break;'||chr(10)||
''||chr(10)||
'       }'||chr(10)||
''||chr(10)||
' ////////////////////////////////////////////////////////////'||chr(10)||
' // Parameter 5 = Return Page Item Name (Use for Locators) //'||chr(10)||
' ////////////////////////////////////////////////////////////'||chr(10)||
' get.addParam(''x05'',$v(''P''+pageNum+''_RETURN_ITEM''));'||chr(10)||
' '||chr(10)||
' /////////////////////////////////////////////////////////////////////////////////';

c1:=c1||'///////'||chr(10)||
' // Parameter 6 = Active Filter for Most (Active/All)                                  //'||chr(10)||
' //   1030 = Participants Active Filter (Individuals/Companies/Organizations/Programs) //'||chr(10)||
' ////////////////////////////////////////////////////////////////////////////////////////'||chr(10)||
' if(pageNum==''1030'')'||chr(10)||
'   {'||chr(10)||
'    if ($v(''P1030_PARTIC_TYPE'')==''PARTICIPANT'')'||chr(10)||
'      get.addParam(''x06'',$v(''P1030_TYPE''));'||chr(10)||
'    ';

c1:=c1||'else'||chr(10)||
'      get.addParam(''x06'',$v(''P1030_ACTIVE_FILTER''));'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   get.addParam(''x06'',$v(''P''+pageNum+''_ACTIVE_FILTER''));'||chr(10)||
''||chr(10)||
' //////////////////////////////////////////////////////////////////////////////////////'||chr(10)||
' // Parameter 7 - 10, no special proccessing needed                                  //'||chr(10)||
' //////////////////////////////////////////////////////////////////////////////////////'||chr(10)||
' get.addP';

c1:=c1||'aram(''x07'',$v(''apexir_NUM_ROWS''));            // Rows Per Page'||chr(10)||
' get.addParam(''x08'',''P''+pageNum);                      // Page Identifier'||chr(10)||
' get.addParam(''x09'',searchParams);                     // Search Filters'||chr(10)||
' get.addParam(''x10'',$v(''apexir_WORKSHEET_ID'')+''~''+'||chr(10)||
'                    $v(''apexir_APP_USER'')+''~''+    '||chr(10)||
'                    $v(''pInstance'')+''~''+'||chr(10)||
'                    getCurrentReportTab());    ';

c1:=c1||'        // Worksheet ID~'||chr(10)||
'                                                       // User Login Name~'||chr(10)||
'                                                       // Session ID~'||chr(10)||
'                                                       // Report Name'||chr(10)||
'  '||chr(10)||
' gReturn = get.get();'||chr(10)||
' '||chr(10)||
' // Call APEX IR Search //'||chr(10)||
' if(typeof(gReport)!="undefined")'||chr(10)||
'   gReport.search(''SEARCH'');'||chr(10)||
'}'||chr(10)||
' '||chr(10)||
'// Run the following once the document ';

c1:=c1||'is ready'||chr(10)||
'$(document).ready(function()'||chr(10)||
'{'||chr(10)||
' // -- Handle Go Button --                               //'||chr(10)||
' // Unbind Click event. Important for order of execution //'||chr(10)||
' $(''input[type="button"][value="Go"]'').attr(''onclick'','''');'||chr(10)||
' '||chr(10)||
' // Rebind events //'||chr(10)||
' $(''input[type="button"][value="Go"]'').click(function(){Desktop_Filters_Col_Ref()});'||chr(10)||
'   '||chr(10)||
' // -- Handle "Enter" in input field -- //'||chr(10)||
' $(''#apexir_SEARCH'').attr(';

c1:=c1||'''onkeyup'',''''); //unbind onkeyup event'||chr(10)||
''||chr(10)||
' // Rebind Events //'||chr(10)||
' $(''#apexir_SEARCH'').keyup(function(event){($f_Enter(event))?Desktop_Filters_Col_Ref():null;});'||chr(10)||
''||chr(10)||
' // To Show Initial Report //'||chr(10)||
' Desktop_Filters_Col_Ref();'||chr(10)||
'}); '||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 10339015946311656 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_DESKTOP_FILTERS_COL_REF',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
