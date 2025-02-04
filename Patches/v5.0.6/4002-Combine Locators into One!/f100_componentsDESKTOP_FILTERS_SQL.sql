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
--   Date and Time:   07:52 Tuesday March 6, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: DESKTOP_FILTERS_SQL
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

-- C O M P O N E N T    E X P O R T
-- Requires Application Express 2.2 or greater
begin
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
 
 
prompt Component Export: APP PROCESS 1902010004942942
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       pQuery varchar2(32000);'||chr(10)||
''||chr(10)||
'       pVarCount number := 0;'||chr(10)||
'       pWorkSheetID varchar2(4000);'||chr(10)||
'       pAPPUSER varchar2(4000);'||chr(10)||
'       pInstance varchar2(4000);'||chr(10)||
'       pReportName varchar2(4000) := '''';'||chr(10)||
'       pIsLocator varchar2(1) := ''N'';'||chr(10)||
'       pIsLocatorMulti varchar2(1) := ''N'';'||chr(10)||
'       pExclude varchar2(32000) := '''';'||chr(10)||
'       pIsLocateMany varchar2(1) := ''N'';'||chr(10)||
''||chr(10)||
'       pHeader VARCHAR2(32';

p:=p||'000);'||chr(10)||
'       pQuoteComma Number;'||chr(10)||
'       colCount Number;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if apex_collection.collection_exists(p_collection_name=>apex_application.g_x01) then'||chr(10)||
'    '||chr(10)||
'       apex_collection.delete_collection(p_collection_name=>apex_application.g_x01);'||chr(10)||
'  '||chr(10)||
'     end if;'||chr(10)||
'  '||chr(10)||
'     for a in (select * from table(split(apex_application.g_x10,''^^'')))'||chr(10)||
'     loop'||chr(10)||
'         if pVarCount=0 then'||chr(10)||
''||chr(10)||
'           pWorkSheetID :';

p:=p||'= a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=1 then'||chr(10)||
''||chr(10)||
'              pAPPUSER := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=2 then'||chr(10)||
''||chr(10)||
'              pInstance := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=3 then'||chr(10)||
''||chr(10)||
'              pReportName := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=4 then'||chr(10)||
''||chr(10)||
'              pIsLocator := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=5 then'||chr(10)||
''||chr(10)||
'              pIsLocatorMulti := a.col';

p:=p||'umn_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=6 then'||chr(10)||
''||chr(10)||
'              pExclude := a.column_value;'||chr(10)||
''||chr(10)||
'         elsif pVarCount=7 then'||chr(10)||
''||chr(10)||
'              pIsLocateMany := a.column_value;'||chr(10)||
''||chr(10)||
'         end if;'||chr(10)||
'         pVarCount := pVarCount+1;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     pQuery := OSI_DESKTOP.DesktopSQL(apex_application.g_x02, '||chr(10)||
'                                      :user_sid, '||chr(10)||
'                                      apex_applic';

p:=p||'ation.g_x04, '||chr(10)||
'                                      apex_application.g_x05, '||chr(10)||
'                                      apex_application.g_x06, '||chr(10)||
'                                      apex_application.g_x07, '||chr(10)||
'                                      apex_application.g_x08, '||chr(10)||
'                                      apex_application.g_x09,'||chr(10)||
'                                      ''10000'','||chr(10)||
'                         ';

p:=p||'             pWorkSheetID, '||chr(10)||
'                                      pAPPUSER, '||chr(10)||
'                                      pInstance,'||chr(10)||
'                                      pReportName,'||chr(10)||
'                                      pIsLocator,'||chr(10)||
'                                      pIsLocatorMulti,'||chr(10)||
'                                      pExclude,'||chr(10)||
'                                      pIsLocateMany);'||chr(10)||
''||chr(10)||
'     APEX_COLLE';

p:=p||'CTION.CREATE_COLLECTION_FROM_QUERY(p_collection_name=>apex_application.g_x01, p_query => pQuery);'||chr(10)||
''||chr(10)||
'     /* Setup Headers */'||chr(10)||
'     colCount := 0;'||chr(10)||
'     for a in (select * from table(split(pQuery,'' as "'')))'||chr(10)||
'     loop'||chr(10)||
'         pQuoteComma := instr(a.column_value,''",'');'||chr(10)||
''||chr(10)||
'         if (pQuoteComma <= 0) then'||chr(10)||
''||chr(10)||
'           pQuoteComma := instr(a.column_value,''"'' || CHR(13) || CHR(10) || ''      from'');'||chr(10)||
' '||chr(10)||
'    ';

p:=p||'     end if;'||chr(10)||
''||chr(10)||
'         pHeader := substr(a.column_value,1,pQuoteComma-1);'||chr(10)||
''||chr(10)||
'         case'||chr(10)||
'             when colCount=1 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD001:=pHeader;'||chr(10)||
'---                 :P || ''_COL_HEAD'' || to_char(colCount,''000'') := pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=2 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD002:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=3 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD003:=p';

p:=p||'Header;'||chr(10)||
''||chr(10)||
'             when colCount=4 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD004:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=5 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD005:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=6 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD006:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=7 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD007:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=8 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD0';

p:=p||'08:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=9 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD009:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=10 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD010:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=11 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD011:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=12 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD012:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=13 then'||chr(10)||
''||chr(10)||
'                 :P301_';

p:=p||'COL_HEAD013:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=14 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD014:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=15 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD015:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=16 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD016:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=17 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD017:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=18 then'||chr(10)||
''||chr(10)||
'             ';

p:=p||'    :P301_COL_HEAD018:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=19 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD019:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=20 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD020:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=21 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD021:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=22 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD022:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=23 then'||chr(10)||
''||chr(10)||
'   ';

p:=p||'              :P301_COL_HEAD023:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=24 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD024:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=25 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD025:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=26 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD026:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=27 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD027:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=28';

p:=p||' then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD028:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=29 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD029:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=30 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD030:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=31 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD031:=pHeader;'||chr(10)||
' '||chr(10)||
'             when colCount=32 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD032:=pHeader;'||chr(10)||
''||chr(10)||
'             when ';

p:=p||'colCount=33 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD033:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=34 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD034:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=35 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD035:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=36 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD036:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=37 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD037:=pHeader;'||chr(10)||
''||chr(10)||
'        ';

p:=p||'     when colCount=38 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD038:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=39 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD039:=pHeader;'||chr(10)||
''||chr(10)||
'             when colCount=40 then'||chr(10)||
''||chr(10)||
'                 :P301_COL_HEAD040:=pHeader;'||chr(10)||
''||chr(10)||
'             else'||chr(10)||
''||chr(10)||
'                 null;'||chr(10)||
'   '||chr(10)||
'         end case;'||chr(10)||
''||chr(10)||
'         colCount := colCount+1;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'End;';

wwv_flow_api.create_flow_process(
  p_id => 1902010004942942 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP_FILTERS_SQL',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '23-Jun-2011 - Tim Ward - CR#3868 - Added New Parameter for Return Item Name, '||chr(10)||
'                                   this is to support Locators.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Added more Parameters for Locators, also added'||chr(10)||
'                                    dynamic column headers based off of the '||chr(10)||
'                                    '' as "'' portion of the select.'||chr(10)||
'');
end;
 
null;
 
end;
/

COMMIT;
