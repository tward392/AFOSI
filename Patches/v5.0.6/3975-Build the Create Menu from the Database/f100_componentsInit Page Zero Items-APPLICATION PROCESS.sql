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
--   Date and Time:   11:54 Monday May 14, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Init Page Zero Items
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
 
 
prompt Component Export: APP PROCESS 88895918473684379
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  v_id varchar2(1000);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'   --- SSL Certificate Items, CAC Card ---'||chr(10)||
'   :P0_SSL_CERT := OWA_UTIL.GET_CGI_ENV(''SSL_CLIENT_S_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT)))'||chr(10)||
'   LOOP'||chr(10)||
'       if substr(a.column_value,1,3) = ''CN='' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_S_DN_CN := substr(a.column_value,4);'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
''||chr(10)||
'   :P0_SSL_CERT_I := OWA_UTIL.GET_CGI_ENV(''SSL_';

p:=p||'CLIENT_I_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT_I)))'||chr(10)||
'   LOOP'||chr(10)||
'       if a.column_value=''OU=DoD'' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_I_DN_OU := a.column_value;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
'   ---------------------------------------'||chr(10)||
''||chr(10)||
'   if :P0_OBJ is not null and :APP_PAGE_ID >= 5000 then'||chr(10)||
'wwv_flow.debug('':P0_OBJ='' || :P0_OBJ);'||chr(10)||
'wwv_flow.debug('':APP_PAGE_ID='' || :APP_PAGE_ID);'||chr(10)||
'     ';

p:=p||'select sid, '||chr(10)||
'            code, '||chr(10)||
'            core_obj.get_tagline(:P0_OBJ),'||chr(10)||
'            substr(core_obj.get_tagline(:P0_OBJ),1,70),'||chr(10)||
'            osi_object.get_id(:P0_OBJ, :P0_OBJ_CONTEXT)'||chr(10)||
'       into :P0_OBJ_TYPE_SID, '||chr(10)||
'            :P0_OBJ_TYPE_CODE, '||chr(10)||
'            :P0_OBJ_TAGLINE,'||chr(10)||
'            :P0_OBJ_TAGLINE_SHORT,'||chr(10)||
'            :P0_OBJ_ID'||chr(10)||
'       from t_core_obj_type'||chr(10)||
'      where sid = core_obj.get_objt';

p:=p||'ype(:P0_OBJ);'||chr(10)||
''||chr(10)||
'      :P0_AUTHORIZED := osi_auth.check_access(:P0_OBJ);'||chr(10)||
'      if     :P0_OBJ_TYPE_CODE = ''UNIT'' '||chr(10)||
'         and :APP_PAGE_ID between 30700 and 30799 then'||chr(10)||
'           :P0_OBJ_TYPE_CODE := ''EMM'';'||chr(10)||
''||chr(10)||
'           select sid into :P0_OBJ_TYPE_SID '||chr(10)||
'                 from t_core_obj_type where code=''EMM'';'||chr(10)||
''||chr(10)||
'           :P0_OBJ_TAGLINE := ''Evidence Management Module for: '' ||'||chr(10)||
'                       ';

p:=p||'       osi_unit.get_name(:P0_OBJ);'||chr(10)||
'           :P0_AUTHORIZED := osi_auth.check_for_priv(''EMM_CUST'','||chr(10)||
'                                          core_obj.lookup_objtype(''EMM''),'||chr(10)||
'                                          null,'||chr(10)||
'                                          :P0_OBJ);'||chr(10)||
'        :P0_WRITABLE := :P0_AUTHORIZED;'||chr(10)||
'      else'||chr(10)||
'        if osi_auth.check_for_priv(''UPDATE'',:P0_OBJ_TYPE_SID)=''Y'' then'||chr(10)||
'    ';

p:=p||'      :P0_WRITABLE := osi_object.check_writability(:P0_OBJ, :P0_OBJ_CONTEXT);'||chr(10)||
'        else'||chr(10)||
'          :P0_WRITABLE := ''N'';'||chr(10)||
'        end if;'||chr(10)||
'      end if;'||chr(10)||
'  elsif :APP_PAGE_ID between 1000 and 4999 then'||chr(10)||
'      :P0_OBJ := null;'||chr(10)||
'      :P0_OBJ_TYPE_SID := null;'||chr(10)||
'      :P0_OBJ_TYPE_CODE := null;'||chr(10)||
'      :P0_OBJ_CONTEXT := null;'||chr(10)||
'      :P0_OBJ_TAGLINE := null;'||chr(10)||
'  else'||chr(10)||
'      :P0_OBJ_TYPE_SID := null;'||chr(10)||
'      :P0_O';

p:=p||'BJ_TAGLINE := null;'||chr(10)||
'      :P0_OBJ_ID := null;'||chr(10)||
'      if :P0_OBJ_TYPE_CODE is not null then'||chr(10)||
'         :P0_OBJ_TYPE_SID := core_obj.lookup_objtype(:P0_OBJ_TYPE_CODE);'||chr(10)||
'      end if;'||chr(10)||
'      if :P0_OBJ_TYPE_CODE <> ''ALL.REPORT_SPEC'' then'||chr(10)||
'         :P0_OBJ_CONTEXT := null;'||chr(10)||
'      end if;'||chr(10)||
'      :P0_AUTHORIZED := null;'||chr(10)||
'  end if;'||chr(10)||
'  if :APP_PAGE_ID=30101 then'||chr(10)||
''||chr(10)||
'    :P0_AUTHORIZED:=''Y'';'||chr(10)||
'    :P0_WRITABLE:=''Y'';'||chr(10)||
''||chr(10)||
'  e';

p:=p||'nd if;'||chr(10)||
'  :P0_CREATEMENU:=OSI_MENU.GETMENUHTML(''ID_CREATE'');'||chr(10)||
'  :P0_WEBLINKSMENU:=OSI_MENU.GETMENUHTML(''ID_WEBLINKS'');'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 88895918473684379 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Init Page Zero Items',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Error Initializing Page Zero Items.',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> 'This process runs before the header for every page, and is responsible for maintaining the Page Zero Object-specifics (P0_OBJ, P0_OBJ_TYPE_CODE, P0_OBJ_TYPE_SID and P0_OBJ_TAGLINE). '||chr(10)||
''||chr(10)||
'16-JUN-2010 Jason Faris Task 2997 - Updated process to not reset obj_context item when obj_type_code = ''ALL.REPORT_SPEC''. '||chr(10)||
''||chr(10)||
'If the current page is not within our object specific pages, or common object pages (i.e. associations), then the values of these items are all cleared out.  Otherwise, if P0_OBJ is set (meaning we are in edit mode for an object), then P0_OBJ_TYPE_CODE and P0_OBJ_TYPE_SID are derived from P0_OBJ.  If P0_OBJ is NOT set (meaning we''re in create mode for an object), then P0_OBJ_TYPE_SID is derived from P0_OBJ_TYPE_CODE.'||chr(10)||
''||chr(10)||
''||chr(10)||
'08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Added Page 30101 check, so if accessed is always '||chr(10)||
'                       viewable by anyone.');
end;
 
null;
 
end;
/

COMMIT;
