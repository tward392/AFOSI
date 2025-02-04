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
--   Date and Time:   13:44 Friday November 18, 2011
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

PROMPT ...Remove page 150,300,350,400,450,500,501,503,505,507,510,550,600,650,850,22900,22905,30142,30445,30601,30602,30603,30604
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>150);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>300);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>350);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>400);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>401);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>450);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>500);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>501);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>503);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>505);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>507);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>510);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>550);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>600);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>650);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>850);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>22900);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>22905);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30142);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30445);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30601);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30602);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30603);
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30604);
 
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
