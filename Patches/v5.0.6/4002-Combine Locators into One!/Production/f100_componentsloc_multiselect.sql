--application/shared_components/logic/application_processes/loc_multiselect
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'  v_item_val VARCHAR2 (100) := apex_application.g_x01;'||chr(10)||
'  v_checked_flag VARCHAR2 (1) := apex_application.g_x02;'||chr(10)||
'BEGIN'||chr(10)||
'  IF v_checked_flag = ''Y'' THEN'||chr(10)||
'    IF :P0_LOC_SELECTIONS IS NULL THEN'||chr(10)||
'      :P0_LOC_SELECTIONS := '':'' || v_item_val || '':'';'||chr(10)||
'    ELSE'||chr(10)||
'      :P0_LOC_SELECTIONS := :P0_LOC_SELECTIONS || v_item_val || '':'';'||chr(10)||
'    END IF;'||chr(10)||
'  ELSE'||chr(10)||
'    :P0_LOC_SELECTIONS := REPLACE (:P0_LOC_SELECTIONS';

p:=p||', '':'' || '||chr(10)||
'                                v_item_val || '':'', '':'');'||chr(10)||
'  END IF;'||chr(10)||
'  htp.p(:P0_LOC_SELECTIONS);'||chr(10)||
'END;';

wwv_flow_api.create_flow_process(
  p_id => 94189415163413914 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'LOC_MULTISELECT',
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

