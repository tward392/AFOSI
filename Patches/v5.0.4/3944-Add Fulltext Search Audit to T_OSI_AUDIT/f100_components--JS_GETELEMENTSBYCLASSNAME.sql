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
--   Date and Time:   09:21 Monday October 3, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     SHORTCUTS: JS_GETELEMENTSBYCLASSNAME
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
 
 
prompt Component Export: SHORTCUTS 8225002358308500
 
prompt  ...Shortcuts
--
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'/*'||chr(10)||
'	Developed by Robert Nyman, http://www.robertnyman.com'||chr(10)||
'	Code/licensing: http://code.google.com/p/getelementsbyclassname/'||chr(10)||
'*/'||chr(10)||
'var getElementsByClassName = function (className, tag, elm){'||chr(10)||
'	if (document.getElementsByClassName) {'||chr(10)||
'		getElementsByClassName = function (className, tag, elm) {'||chr(10)||
'			elm = elm || document;'||chr(10)||
'			var elements = elm.getElement';

c1:=c1||'sByClassName(className),'||chr(10)||
'				nodeName = (tag)? new RegExp("\\b" + tag + "\\b", "i") : null,'||chr(10)||
'				returnElements = [],'||chr(10)||
'				current;'||chr(10)||
'			for(var i=0, il=elements.length; i<il; i+=1){'||chr(10)||
'				current = elements[i];'||chr(10)||
'				if(!nodeName || nodeName.test(current.nodeName)) {'||chr(10)||
'					returnElements.push(current);'||chr(10)||
'				}'||chr(10)||
'			}'||chr(10)||
'			return returnElements;'||chr(10)||
'		};'||chr(10)||
'	}'||chr(10)||
'	else if (document.evaluate) {'||chr(10)||
'		getElementsByClassName = f';

c1:=c1||'unction (className, tag, elm) {'||chr(10)||
'			tag = tag || "*";'||chr(10)||
'			elm = elm || document;'||chr(10)||
'			var classes = className.split(" "),'||chr(10)||
'				classesToCheck = "",'||chr(10)||
'				xhtmlNamespace = "http://www.w3.org/1999/xhtml",'||chr(10)||
'				namespaceResolver = (document.documentElement.namespaceURI === xhtmlNamespace)? xhtmlNamespace : null,'||chr(10)||
'				returnElements = [],'||chr(10)||
'				elements,'||chr(10)||
'				node;'||chr(10)||
'			for(var j=0, jl=classes.length; j<jl; j+=1){'||chr(10)||
'';

c1:=c1||'				classesToCheck += "[contains(concat('' '', @class, '' ''), '' " + classes[j] + " '')]";'||chr(10)||
'			}'||chr(10)||
'			try	{'||chr(10)||
'				elements = document.evaluate(".//" + tag + classesToCheck, elm, namespaceResolver, 0, null);'||chr(10)||
'			}'||chr(10)||
'			catch (e) {'||chr(10)||
'				elements = document.evaluate(".//" + tag + classesToCheck, elm, null, 0, null);'||chr(10)||
'			}'||chr(10)||
'			while ((node = elements.iterateNext())) {'||chr(10)||
'				returnElements.push(node);'||chr(10)||
'			}'||chr(10)||
'			return ret';

c1:=c1||'urnElements;'||chr(10)||
'		};'||chr(10)||
'	}'||chr(10)||
'	else {'||chr(10)||
'		getElementsByClassName = function (className, tag, elm) {'||chr(10)||
'			tag = tag || "*";'||chr(10)||
'			elm = elm || document;'||chr(10)||
'			var classes = className.split(" "),'||chr(10)||
'				classesToCheck = [],'||chr(10)||
'				elements = (tag === "*" && elm.all)? elm.all : elm.getElementsByTagName(tag),'||chr(10)||
'				current,'||chr(10)||
'				returnElements = [],'||chr(10)||
'				match;'||chr(10)||
'			for(var k=0, kl=classes.length; k<kl; k+=1){'||chr(10)||
'				classesToCheck.pu';

c1:=c1||'sh(new RegExp("(^|\\s)" + classes[k] + "(\\s|$)"));'||chr(10)||
'			}'||chr(10)||
'			for(var l=0, ll=elements.length; l<ll; l+=1){'||chr(10)||
'				current = elements[l];'||chr(10)||
'				match = false;'||chr(10)||
'				for(var m=0, ml=classesToCheck.length; m<ml; m+=1){'||chr(10)||
'					match = classesToCheck[m].test(current.className);'||chr(10)||
'					if (!match) {'||chr(10)||
'						break;'||chr(10)||
'					}'||chr(10)||
'				}'||chr(10)||
'				if (match) {'||chr(10)||
'					returnElements.push(current);'||chr(10)||
'				}'||chr(10)||
'			}'||chr(10)||
'			return returnElements;'||chr(10)||
'		';

c1:=c1||'};'||chr(10)||
'	}'||chr(10)||
'	return getElementsByClassName(className, tag, elm);'||chr(10)||
'};'||chr(10)||
'</script>';

wwv_flow_api.create_shortcut (
 p_id=> 8225002358308500 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'JS_GETELEMENTSBYCLASSNAME',
 p_shortcut_type=> 'HTML_TEXT',
 p_shortcut=> c1);
end;
null;
 
end;
/

COMMIT;
