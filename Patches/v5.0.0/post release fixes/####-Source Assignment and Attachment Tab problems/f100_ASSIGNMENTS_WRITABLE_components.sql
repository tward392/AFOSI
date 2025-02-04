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
--   Date and Time:   07:08 Friday February 4, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SECURITY SCHEME: Assignments Writable
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
 
 
prompt Component Export: SECURITY SCHEME 5498713142558806
 
prompt  ...authorization schemes
--
 
begin
 
wwv_flow_api.create_security_scheme(
  p_id => 5498713142558806 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_name=>'Assignments Writable',
  p_scheme_type=>'FUNCTION_RETURNING_BOOLEAN',
  p_scheme=>'begin'||chr(10)||
''||chr(10)||
'  if osi_auth.check_for_priv(''UPDATE'', :p0_obj_type_sid) = ''Y'' then'||chr(10)||
''||chr(10)||
'    if (:p0_obj_type_code = ''FILE.SOURCE'') then'||chr(10)||
''||chr(10)||
'      if (osi_object.get_assigned_unit(:p0_obj) = osi_personnel.get_current_unit) then'||chr(10)||
''||chr(10)||
'        --- Always keep the support objects unlocked when the Source is ''Active'' ----         '||chr(10)||
'        if (osi_object.get_status_code(:p0_obj) <> ''AC'') then'||chr(10)||
''||chr(10)||
'          if (osi_object.get_status_code(:p0_obj) = ''IM'' and osi_auth.check_for_priv(''SOURCE_CHANGE'', :p0_obj_type_sid) = ''Y'') then'||chr(10)||
''||chr(10)||
'            return false;'||chr(10)||
''||chr(10)||
'          else'||chr(10)||
''||chr(10)||
'            return(:p0_writable = ''Y'');'||chr(10)||
''||chr(10)||
'          end if;'||chr(10)||
'        '||chr(10)||
'        else'||chr(10)||
''||chr(10)||
'          return true;'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'        return false;'||chr(10)||
''||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
' '||chr(10)||
'     return(:p0_writable = ''Y'');'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'    return false;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_caching=>'BY_USER_BY_PAGE_VIEW',
  p_error_message=>'This object is read-only.');
 
 
end;
/

COMMIT;
