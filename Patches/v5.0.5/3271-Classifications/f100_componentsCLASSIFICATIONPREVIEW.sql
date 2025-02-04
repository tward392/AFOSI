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
--   Date and Time:   09:27 Tuesday October 25, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: CLASSIFICATIONPREVIEW
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
 
 
prompt Component Export: APP PROCESS 8659721679334624
 
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
'  v_class       varchar2(20)    := apex_application.g_x01;'||chr(10)||
'  v_disseminate varchar2(32000) := apex_application.g_x02;'||chr(10)||
'  v_release_to  varchar2(32000) := apex_application.g_x03;'||chr(10)||
'  v_result      varchar2(32000);'||chr(10)||
'  v_temp        varchar2(32000);'||chr(10)||
'  v_cnt         number;'||chr(10)||
'  v_tot_rt      number;'||chr(10)||
'  v_tot_hi      number;'||chr(10)||
'  v_blockRT     number := 0;'||chr(10)||
'  v_block_temp  varchar2(1);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     select';

p:=p||' count(*) into v_tot_rt '||chr(10)||
'           from table(split(v_release_to,'':'')) where column_value is not null;'||chr(10)||
''||chr(10)||
'     select count(*) into v_tot_hi '||chr(10)||
'           from table(split(v_disseminate,'':'')) where column_value is not null;'||chr(10)||
'       '||chr(10)||
'     if v_class is null or v_class = '''' or v_class = ''~~~''then'||chr(10)||
'       '||chr(10)||
'       v_result:='''';'||chr(10)||
''||chr(10)||
'     else     '||chr(10)||
''||chr(10)||
'       select description into v_result from t_core_classifica';

p:=p||'tion_level'||chr(10)||
'             where sid=v_class;'||chr(10)||
'     '||chr(10)||
'       v_cnt := 1;'||chr(10)||
'       for d in (select column_value from table(split(v_disseminate,'':''))'||chr(10)||
'                  where column_value is not null)'||chr(10)||
'       loop'||chr(10)||
'           select code,blocks_rt into v_temp,v_block_temp'||chr(10)||
'               from t_core_classification_hi_type'||chr(10)||
'                 where sid=d.column_value;'||chr(10)||
'         '||chr(10)||
'           if v_cnt = 1 then'||chr(10)||
''||chr(10)||
'     ';

p:=p||'        v_result := v_result || ''//'';'||chr(10)||
''||chr(10)||
'           else'||chr(10)||
''||chr(10)||
'             v_result := v_result || '','';'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
''||chr(10)||
'           v_result := v_result || v_temp;'||chr(10)||
'           v_cnt := v_cnt + 1;'||chr(10)||
'         '||chr(10)||
'           if v_block_temp <> ''N'' then'||chr(10)||
'           '||chr(10)||
'             v_blockRT := 1;'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
''||chr(10)||
'       end loop;'||chr(10)||
'     '||chr(10)||
'       if v_blockRT = 0 then'||chr(10)||
''||chr(10)||
'         if v_tot_rt > 0 then'||chr(10)||
'           '||chr(10)||
' ';

p:=p||'          if v_tot_hi > 0 then'||chr(10)||
''||chr(10)||
'             v_result := v_result || '','';'||chr(10)||
''||chr(10)||
'           else'||chr(10)||
''||chr(10)||
'             v_result := v_result || ''//'';'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
'     '||chr(10)||
'           if v_tot_rt > 0 then'||chr(10)||
'   '||chr(10)||
'             v_result := v_result || ''REL TO USA'';'||chr(10)||
''||chr(10)||
'           end if;'||chr(10)||
'     '||chr(10)||
'           v_cnt := 1;'||chr(10)||
'           for r in (select column_value from table(split(v_release_to,'':''))'||chr(10)||
'                      wher';

p:=p||'e column_value is not null)'||chr(10)||
'           loop'||chr(10)||
'               select code into v_temp from t_core_classification_rt_dest'||chr(10)||
'                     where sid=r.column_value;'||chr(10)||
'         '||chr(10)||
'               if v_cnt = v_tot_rt then'||chr(10)||
'           '||chr(10)||
'                 v_result := v_result || '' AND '' || v_temp;'||chr(10)||
'  '||chr(10)||
'               else '||chr(10)||
'  '||chr(10)||
'                 v_result := v_result || '','' || v_temp;'||chr(10)||
''||chr(10)||
'               end if;'||chr(10)||
'      ';

p:=p||'         v_cnt := v_cnt + 1;'||chr(10)||
'  '||chr(10)||
'           end loop;'||chr(10)||
''||chr(10)||
'         end if;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     htp.p(v_result);'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 8659721679334624 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'CLASSIFICATIONPREVIEW',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

COMMIT;
