--application/shared_components/logic/application_processes/desktop_filters_sql
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'begin'||chr(10)||
''||chr(10)||
'  if apex_collection.collection_exists(p_collection_name=>apex_application.g_x01) then'||chr(10)||
'    '||chr(10)||
'    apex_collection.delete_collection(p_collection_name=>apex_application.g_x01);'||chr(10)||
'  '||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY('||chr(10)||
'      p_collection_name=>apex_application.g_x01,'||chr(10)||
'      p_query => OSI_DESKTOP.DesktopSQL(apex_application.g_x02, :user_sid, apex_application.g_x04, apex_appl';

p:=p||'ication.g_x05));'||chr(10)||
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
  p_process_comment=> '');
end;
 
null;
 
end;
/

