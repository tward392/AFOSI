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
--   Date and Time:   08:33 Thursday October 27, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Go To Tab
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
 
 
prompt Component Export: APP PROCESS 172533122691877427
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'     v_tab varchar2(20);'||chr(10)||
''||chr(10)||
'     procedure traverse_tab_parents(p_tab varchar2) is'||chr(10)||
'         v_parent t_osi_tab.parent_tab%type;'||chr(10)||
'         v_result boolean;'||chr(10)||
'     begin'||chr(10)||
'          v_result := core_list.add_item_to_list_front(p_tab, :P0_TABS);'||chr(10)||
'          '||chr(10)||
'          select parent_tab'||chr(10)||
'           into v_parent'||chr(10)||
'           from t_osi_tab'||chr(10)||
'          where sid = p_tab;'||chr(10)||
'          '||chr(10)||
'          if v_parent is ';

p:=p||'not null then'||chr(10)||
'              traverse_tab_parents(v_parent);'||chr(10)||
'          end if;'||chr(10)||
'     end traverse_tab_parents;'||chr(10)||
''||chr(10)||
'     procedure set_tab_info(p_tab varchar2) is'||chr(10)||
'        v_cur_tab t_osi_tab.sid%type;'||chr(10)||
'        v_result boolean;'||chr(10)||
'        v_caption t_osi_tab.tab_label%type;'||chr(10)||
'     begin  '||chr(10)||
'        select page_num, tab_params, tab_label'||chr(10)||
'          into :TAB_PAGE, :TAB_PARAMS, v_caption'||chr(10)||
'          from t_osi_tab'||chr(10)||
' ';

p:=p||'        where sid = p_tab;'||chr(10)||
''||chr(10)||
'        if :AUDITING = ''ON'' then'||chr(10)||
'          log_info(''TabShown:'' || :p0_obj || '' - '' || v_caption);'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        if :TAB_PAGE is null then'||chr(10)||
'              select x.sid '||chr(10)||
'                into v_cur_tab'||chr(10)||
'                from (select sid'||chr(10)||
'                        from t_osi_tab'||chr(10)||
'                       where parent_tab = p_tab'||chr(10)||
'                         and obj_type membe';

p:=p||'r of'||chr(10)||
'                                 osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'                       order by is_default desc, seq asc) x'||chr(10)||
'               where rownum = 1;'||chr(10)||
'              v_result := core_list.add_item_to_list(v_cur_tab, :P0_TABS);'||chr(10)||
'              set_tab_info(v_cur_tab);'||chr(10)||
'        end if;'||chr(10)||
'     end set_tab_info;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if :REQUEST like ''TAB_%'' then'||chr(10)||
'     :P0_TABS := null;'||chr(10)||
'      v_tab ';

p:=p||':= substr(:REQUEST, 5);'||chr(10)||
'      traverse_tab_parents(v_tab);'||chr(10)||
'      set_tab_info(v_tab);'||chr(10)||
'   else'||chr(10)||
'      :TAB_PAGE := null;'||chr(10)||
'   end if;'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 172533122691877427 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 20,
  p_process_point => 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Go To Tab',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Error in Go To Tab process.',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '  This process only runs when TAB_(sid) is the current request (when the user clicked on a tab for navigation).  It is responsible for determining what page to branch to based on the tab that was clicked.'||chr(10)||
'  If the clicked tab has no children, it will return the page_num associated to that tab.  Otherwise it will try to find the child of that parent that is marked IS_DEFAULT=Y in the table, otherwise the first child in sequence.  It then recursively will proceed through the above on that child tab.');
end;
 
null;
 
end;
/

COMMIT;
