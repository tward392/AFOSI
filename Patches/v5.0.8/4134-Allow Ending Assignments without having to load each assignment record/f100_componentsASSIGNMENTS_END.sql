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
--   Date and Time:   08:44 Tuesday October 23, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: ASSIGNMENTS_END
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
 
 
prompt Component Export: APP PROCESS 17199116011303492
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
''||chr(10)||
'     v_obj           varchar2(20):= apex_application.g_x01;'||chr(10)||
'     v_assignments   varchar2(32000):= apex_application.g_x02;'||chr(10)||
'     v_updated       number := 0;'||chr(10)||
'     v_total_updated number := 0;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     if v_assignments is null then'||chr(10)||
''||chr(10)||
'       update t_osi_assignment '||chr(10)||
'             set end_date=sysdate '||chr(10)||
'                where obj=v_obj '||chr(10)||
'                  and end_date is null returning count(si';

p:=p||'d) into v_total_updated;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
'        '||chr(10)||
'       for a in (select * from table(split(v_assignments,''~'')))'||chr(10)||
'       loop'||chr(10)||
'           if a.column_value is not null then'||chr(10)||
''||chr(10)||
'             update t_osi_assignment '||chr(10)||
'                   set end_date=sysdate '||chr(10)||
'                      where sid=a.column_value'||chr(10)||
'                        and end_date is null returning count(sid) into v_updated;'||chr(10)||
''||chr(10)||
'             v_total_up';

p:=p||'dated := v_total_updated + v_updated;'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
''||chr(10)||
'       end loop;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'      '||chr(10)||
'     if v_total_updated > 0 then'||chr(10)||
''||chr(10)||
'       htp.p(''Y'');'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       htp.p(''N'');'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 17199116011303492 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'ASSIGNMENTS_END',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '23-Oct-2012 - Tim Ward - CR#4134 - All Ending All or Selected Assignments.');
end;
 
null;
 
end;
/

COMMIT;
