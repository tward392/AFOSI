INSERT INTO T_OSI_AUTH_PRIV (OBJ_TYPE,ACTION) SELECT T.SID,A.SID FROM T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A WHERE T.CODE='ACT.COORDINATION.AUTOPSY' AND A.CODE='CREATE';
INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV) SELECT R.SID,P.SID FROM T_OSI_AUTH_ROLE R,T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T WHERE R.CODE='AGTPERS' AND P.OBJ_TYPE=T.SID AND T.CODE='ACT.COORDINATION.AUTOPSY';

INSERT INTO T_OSI_AUTH_PRIV (OBJ_TYPE,ACTION) SELECT T.SID,A.SID FROM T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A WHERE T.CODE='ACT.COORDINATION.CC' AND A.CODE='CREATE';
INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV) SELECT R.SID,P.SID FROM T_OSI_AUTH_ROLE R,T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T WHERE R.CODE='AGTPERS' AND P.OBJ_TYPE=T.SID AND T.CODE='ACT.COORDINATION.CC';

INSERT INTO T_OSI_AUTH_PRIV (OBJ_TYPE,ACTION) SELECT T.SID,A.SID FROM T_CORE_OBJ_TYPE T,T_OSI_AUTH_ACTION_TYPE A WHERE T.CODE='ACT.COORDINATION.INV' AND A.CODE='CREATE';
INSERT INTO T_OSI_AUTH_ROLE_PRIV (ROLE,PRIV) SELECT R.SID,P.SID FROM T_OSI_AUTH_ROLE R,T_OSI_AUTH_PRIV P,T_CORE_OBJ_TYPE T WHERE R.CODE='AGTPERS' AND P.OBJ_TYPE=T.SID AND T.CODE='ACT.COORDINATION.INV';
COMMIT;


CREATE OR REPLACE VIEW V_OSI_CONSULT_CREATE_TYPES
(D, R)
AS 
select substr(description, 14, length(description) - 13) d, sid r
  from t_core_obj_type
 where code like substr('ACT.CONSULTATION', 1, 16) || '%'
   and description <> 'Consultation'
   and osi_auth.check_for_priv('CREATE',sid)='Y'
/

COMMIT;


CREATE OR REPLACE VIEW V_OSI_COORDIN_CREATE_TYPES
(D, R)
AS 
select substr(description, 14, length(description) - 13) d, sid r
  from t_core_obj_type
 where code like substr('ACT.COORDINATION', 1, 16) || '%'
   and description <> 'Coordination'
   and osi_auth.check_for_priv('CREATE',sid)='Y'
/

COMMIT;

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
--   Date and Time:   06:27 Thursday January 6, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Create
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
 
 
prompt Component Export: LIST 88768131328537196
 
prompt  ...lists
--
 
begin
 
wwv_flow_api.create_list (
  p_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Create',
  p_list_status=> 'PUBLIC',
  p_list_displayed=> 'BY_DEFAULT',
  p_display_row_template_id=> 2700427483559020 + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_list_item (
  p_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>10,
  p_list_item_link_text=> 'Create',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/OSI_CREATE.gif" />',
  p_list_item_icon_attributes=> '',
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>100,
  p_list_item_link_text=> 'Activity',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Activity.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1244926876560210 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>999,
  p_list_item_link_text=> 'Initial Notification',
  p_list_item_link_target=> 'javascript:createObject(22000,''ACT.INIT_NOTIF'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InitialNotification.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1000,
  p_list_item_link_text=> 'Interview',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Interview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 93004022942618907 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1002,
  p_list_item_link_text=> 'Subject Interview',
  p_list_item_link_target=> 'javascript:createObject(21000,''ACT.INTERVIEW.SUBJECT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewSubject.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 93004231600621385 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1004,
  p_list_item_link_text=> 'Victim Interview',
  p_list_item_link_target=> 'javascript:createObject(21000,''ACT.INTERVIEW.VICTIM'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewVictim.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 93004438526623429 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1005,
  p_list_item_link_text=> 'Witness Interview',
  p_list_item_link_target=> 'javascript:createObject(21000,''ACT.INTERVIEW.WITNESS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewWitness.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 4078713631517926 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1006,
  p_list_item_link_text=> 'Group Interview',
  p_list_item_link_target=> 'javascript:createObject(22600,''ACT.INTERVIEW.GROUP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/InterviewGroup.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770938432577107 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1960306117916893 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1007,
  p_list_item_link_text=> 'Source Meet',
  p_list_item_link_target=> 'javascript:createObject(22400, ''ACT.SOURCE_MEET'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SourceMeet.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1309017633334728 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1008,
  p_list_item_link_text=> 'Search',
  p_list_item_link_target=> 'javascript:createObject(22100,''ACT.SEARCH'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SearchActivity.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88771530598584312 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1010,
  p_list_item_link_text=> 'Briefing',
  p_list_item_link_target=> 'javascript:createObject(21700,''ACT.BRIEFING'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Briefing.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 96221522529576279 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1018,
  p_list_item_link_text=> 'Liaison',
  p_list_item_link_target=> 'javascript:createObject(21600,''ACT.LIAISON'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Liaison.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99861620479810573 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1019,
  p_list_item_link_text=> 'Media Analysis',
  p_list_item_link_target=> 'javascript:createObject(21800,''ACT.MEDIA_ANALYSIS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/MediaAnalysis.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91440021873143307 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1020,
  p_list_item_link_text=> 'Computer Intrusion',
  p_list_item_link_target=> 'javascript:createObject(21100,''ACT.COMP_INTRUSION'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/ComputerIntrusion.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 100638836230460162 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1023,
  p_list_item_link_text=> 'Consultation',
  p_list_item_link_target=> 'javascript:createObject(21900,''ACT.CONSULTATION.ACQUISITION'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Consultation.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 100641225542485474 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1026,
  p_list_item_link_text=> 'Coordination',
  p_list_item_link_target=> 'javascript:createObject(21900,''ACT.COORDINATION.FORENSICS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Coordination.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 5500705841679714 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1027,
  p_list_item_link_text=> 'Manual Fingerprint',
  p_list_item_link_target=> 'javascript:createObject(22700,''ACT.FINGERPRINT.MANUAL'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/FingerPalmPrint.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1663014744902648 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1028,
  p_list_item_link_text=> 'Polygraph Exam',
  p_list_item_link_target=> 'javascript:createObject(22200,''ACT.POLY_EXAM'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/PolyExam.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91260106297732654 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1030,
  p_list_item_link_text=> 'Document Review',
  p_list_item_link_target=> 'javascript:createObject(21200,''ACT.DOCUMENT_REVIEW'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/DocumentReview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 92085528407674231 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1040,
  p_list_item_link_text=> 'Law Enforcement Records Check',
  p_list_item_link_target=> 'javascript:createObject(21500,''ACT.RECORDS_CHECK'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/LawEnforcementRecordsCheck.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1108204162889515 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1070,
  p_list_item_link_text=> 'Suspicious Activity Report',
  p_list_item_link_target=> 'javascript:createObject(22800,''ACT.SUSPACT_REPORT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SuspicioiusActivityReport.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2376514196530442 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1080,
  p_list_item_link_text=> 'Surveillance',
  p_list_item_link_target=> 'javascript:createObject(22500,''ACT.SURVEILLANCE'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Surveillance.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91558623723596190 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1100,
  p_list_item_link_text=> 'Exception',
  p_list_item_link_target=> 'javascript:createObject(21300,''ACT.EXCEPTION'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/ExceptionActivity.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91691735680581873 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1200,
  p_list_item_link_text=> 'HQ Case Review',
  p_list_item_link_target=> 'javascript:createObject(21400,''ACT.CC_REVIEW'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/HQCaseReview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 12943806654118135 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1210,
  p_list_item_link_text=> 'HQ Open Case Review',
  p_list_item_link_target=> 'javascript:createObject(21400,''ACT.OC_REVIEW'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/HQCaseReview.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 11620130855212196 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>1220,
  p_list_item_link_text=> 'AV Support',
  p_list_item_link_target=> 'javascript:createObject(23000,''ACT.AV_SUPPORT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/AVSupport.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769211027540849 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>200,
  p_list_item_link_text=> 'Investigative File',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Investigations.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88790321331262918 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>210,
  p_list_item_link_text=> 'Informational',
  p_list_item_link_target=> 'javascript:createObject(11100,''FILE.INV.INFO'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Informational.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 94001732305162140 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>220,
  p_list_item_link_text=> 'Developmental',
  p_list_item_link_target=> 'javascript:createObject(11100,''FILE.INV.DEV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Developmental.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 94001935076162996 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>230,
  p_list_item_link_text=> 'Case',
  p_list_item_link_target=> 'javascript:createObject(11100,''FILE.INV.CASE'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Case.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 12147903531120300 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>240,
  p_list_item_link_text=> 'SFS Investigation',
  p_list_item_link_target=> 'javascript:createObject(11600,''FILE.SFS'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/SFS.gif"/>',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769419338543262 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>300,
  p_list_item_link_text=> 'Service File',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Service.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1440625451733781 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>310,
  p_list_item_link_text=> 'OSI Application',
  p_list_item_link_target=> 'javascript:createObject(11200,''FILE.AAPP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/AgentApplication.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95584133940934231 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>3000,
  p_list_item_link_text=> 'Analysis and Production',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.ANP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/AandP.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95664821378992074 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>3010,
  p_list_item_link_text=> 'Threatened Airmen Support',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.THRTAIRMANSUPP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_list_item_disp_cond_type=> 'NEVER',
  p_list_item_disp_condition=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1809122725975296 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7020,
  p_list_item_link_text=> 'Force Protection Services',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Folder256.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1809332075978023 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7030,
  p_list_item_link_text=> 'PSO',
  p_list_item_link_target=> 'javascript:createObject(11400,''FILE.PSO'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/PSO.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 1809122725975296 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88772912505598014 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7031,
  p_list_item_link_text=> 'Counterintelligence Services',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Folder256.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769623147544287 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2078909123757273 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7040,
  p_list_item_link_text=> 'CSP',
  p_list_item_link_target=> 'javascript:createObject(11500,''FILE.POLY_FILE.SEC'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/csp.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88772912505598014 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>400,
  p_list_item_link_text=> 'Support File',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Support.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 2079530940763578 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4005,
  p_list_item_link_text=> 'Criminal Polygraph',
  p_list_item_link_target=> 'javascript:createObject(11500,''FILE.POLY_FILE.CRIM'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/CriminalPolygraph.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 89316834259916999 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4010,
  p_list_item_link_text=> 'Tech Surveillance',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.TECHSURV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95665824889021423 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4020,
  p_list_item_link_text=> 'Source Development',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.SRCDEV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95666235278024473 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4030,
  p_list_item_link_text=> 'Undercover Operations',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.UNDRCVROP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_list_item_disp_cond_type=> 'NEVER',
  p_list_item_disp_condition=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95666413245027589 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>4040,
  p_list_item_link_text=> 'Undercover Operations Support',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.UNDRCVROPSUPP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Generic.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88769837000548312 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>500,
  p_list_item_link_text=> 'Management',
  p_list_item_link_target=> 'f?p=&APP_ID.:500:&SESSION.::&DEBUG.::::',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Management.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 1546418017313514 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5010,
  p_list_item_link_text=> 'Source',
  p_list_item_link_target=> 'javascript:createObject(11300, ''FILE.SOURCE'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Source.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 90146523981642801 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5030,
  p_list_item_link_text=> 'Personnel',
  p_list_item_link_target=> 'javascript:createObject(30400,''PERSONNEL'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Personnel.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 89640224842879257 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5040,
  p_list_item_link_text=> 'Unit',
  p_list_item_link_target=> 'javascript:createObject(30300,''UNIT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Unit.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 95667138310044224 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>5060,
  p_list_item_link_text=> 'Target Management',
  p_list_item_link_target=> 'javascript:createObject(11000,''FILE.GEN.TARGETMGMT'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/TargetManagement.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770011850550503 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>600,
  p_list_item_link_text=> 'Participant',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Individual.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91388329810337401 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6010,
  p_list_item_link_text=> 'Individual',
  p_list_item_link_target=> 'javascript:createObject(30000,''PART.INDIV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Individual.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91389332366347587 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6020,
  p_list_item_link_text=> 'Company',
  p_list_item_link_target=> 'javascript:createObject(30100,''PART.NONINDIV.COMP'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Company.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91389506870349664 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6030,
  p_list_item_link_text=> 'Organization',
  p_list_item_link_target=> 'javascript:createObject(30100,''PART.NONINDIV.ORG'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Organization.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 91390019683353329 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>6040,
  p_list_item_link_text=> 'Program',
  p_list_item_link_target=> 'javascript:createObject(30100,''PART.NONINDIV.PROG'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/Program.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88770218776552499 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99870332778552145 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>700,
  p_list_item_link_text=> 'C-Funds',
  p_list_item_link_target=> '',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/CFunds.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 88771911335588232 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
wwv_flow_api.create_list_item (
  p_id=> 99870517325557145 + wwv_flow_api.g_id_offset,
  p_list_id=> 88768131328537196 + wwv_flow_api.g_id_offset,
  p_list_item_type=> 'LINK',
  p_list_item_status=> 'PUBLIC',
  p_item_displayed=> 'BY_DEFAULT',
  p_list_item_display_sequence=>7010,
  p_list_item_link_text=> 'Advance',
  p_list_item_link_target=> 'javascript:createObject(30600,''CFUNDS_ADV'');',
  p_list_item_icon   => '<img src="#IMAGE_PREFIX#themes/OSI/CFundsAdvance.gif" />',
  p_list_item_icon_attributes=> '',
  p_parent_list_item_id=> 99870332778552145 + wwv_flow_api.g_id_offset,
  p_list_countclicks_y_n=> 'N',
  p_list_text_01=> '',
  p_list_item_current_type=> 'COLON_DELIMITED_PAGE_LIST',
  p_list_item_owner=> '');
 
null;
 
end;
/

COMMIT;

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
--   Date and Time:   06:28 Thursday January 6, 2011
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

PROMPT ...Remove page 21900
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>21900);
 
end;
/

 
--application/pages/page_21900
prompt  ...PAGE 21900: Consultation/Coordination (Create)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 21900,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Consultation/Coordination (Create)',
  p_step_title=> '&P21900_ACTIVITY_TYPE_LABEL. (Create)',
  p_step_sub_title => 'Coordination / Consultation (Create)',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110106062601',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => 'Created 17-SEP-2009 by MARK');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 100632718929118806 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21900,
  p_plug_name=> '&P21900_ACTIVITY_TYPE_LABEL.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> 'Created 17-SEP-2009 by MARK');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 100632937902118817 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21900,
  p_button_sequence=> 10,
  p_button_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 100633134344118821 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21900,
  p_button_sequence=> 20,
  p_button_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>100635436145118851 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.:OPEN:&DEBUG.:20000::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>100632937902118817+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-SEP-2009 16:42 by MARK');
 
wwv_flow_api.create_page_branch(
  p_id=>100635622999118857 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_branch_action=> 'f?p=&APP_ID.:21900:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-SEP-2009 by MARK');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15780412575495200 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_CONTACT_METHOD_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P21900_CONTACT_METHOD_LOV',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15780621233497668 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_CONTACT_METHOD',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21905_ACTIVITY_TYPE_LABEL. Method',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21900_CONTACT_METHOD_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Contact Method -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15780905088502412 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_HOUR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50.2,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21905_ACTIVITY_TYPE_LABEL. Time',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'HOURS',
  p_lov => '.'||to_char(2668702431512846 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15781109590503728 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_MINUTE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50.3,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'MINUTES',
  p_lov => '.'||to_char(2677023537717654 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100633311782118823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_RESTRICTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21900_RESTRICTION_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100633525302118831 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative',
  p_source=>'NARRATIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 30000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100633707761118831 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50.1,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21900_ACTIVITY_TYPE_LABEL. Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'ACTIVITY_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100633927751118832 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100634128784118834 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'osi_object.get_default_title(:p0_obj_type_sid)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Title',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100634338683118834 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_RESTRICTION_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 77,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100642614244491674 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_ACTIVITY_TYPE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Activity Type Label',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100674810958228804 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_TYPE_CONSULTATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'declare'||chr(10)||
'  obj_type_sid varchar2(20);'||chr(10)||
'begin'||chr(10)||
'select sid into obj_type_sid '||chr(10)||
'      from t_core_obj_type where code =''ACT.CONSULTATION.ACQUISITION'';'||chr(10)||
'return obj_type_sid;'||chr(10)||
'end;',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_prompt=>'Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select D display_value, R return_value '||chr(10)||
'from V_OSI_CONSULT_CREATE_TYPES'||chr(10)||
'order by 1',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Type -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'Instr(:P0_OBJ_TYPE_CODE, ''CONSULTATION'') >0',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'select substr(description, 14, length(description) - 13) d, sid r'||chr(10)||
'  from t_core_obj_type'||chr(10)||
' where code like substr(:p0_obj_type_code, 1, 16) || ''%'''||chr(10)||
'   and description <> ''Consultation'''||chr(10)||
'   and osi_auth.check_for_priv(''CREATE'',r)=''Y'''||chr(10)||
' order by description');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100683136247012035 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_name=>'P21900_TYPE_COORDINATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 100632718929118806+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'declare'||chr(10)||
'  obj_type_sid varchar2(20);'||chr(10)||
'begin'||chr(10)||
'select sid into obj_type_sid '||chr(10)||
'      from t_core_obj_type where code =''ACT.COORDINATION.FORENSICS'';'||chr(10)||
'return obj_type_sid;'||chr(10)||
'end;',
  p_item_default_type => 'PLSQL_FUNCTION_BODY',
  p_prompt=>'Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select D display_value, R return_value '||chr(10)||
'from V_OSI_COORDIN_CREATE_TYPES'||chr(10)||
'order by 1',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Type -',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'Instr(:P0_OBJ_TYPE_CODE, ''COORDINATION'') >0',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'select substr(description, 14, length(description) - 13) d, sid r'||chr(10)||
'  from t_core_obj_type'||chr(10)||
' where code like substr(:p0_obj_type_code, 1, 16) || ''%'''||chr(10)||
'   and description <> ''Coordination'''||chr(10)||
' order by description');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 100634636744118835 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21900,
  p_computation_sequence => 10,
  p_computation_item=> 'P21900_RESTRICTION_LOV',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_reference.get_lov(''RESTRICTION'')',
  p_computation_comment=> 'Created 17-SEP-2009 by MARK',
  p_compute_when => 'P21900_RESTRICTION_LOV',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11866202959659518 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_validation_name => 'User can create',
  p_validation_sequence=> .5,
  p_validation => 'begin'||chr(10)||
'    if (instr(:p0_obj_type_code, ''CONSULTATION'') > 0) then'||chr(10)||
'        if (osi_auth.check_for_priv(''CREATE'', :p21900_type_consultation) <> ''Y'' and :p21900_type_consultation is not null) then'||chr(10)||
'            return false;'||chr(10)||
'        else'||chr(10)||
'            return true;'||chr(10)||
'        end if;'||chr(10)||
'    elsif(instr(:p0_obj_type_code, ''COORDINATION'') > 0) then'||chr(10)||
'        if (osi_auth.check_for_priv(''CREATE'', :p21900_type_coordination) <> ''Y'' and :p21900_type_coordination is not null) then'||chr(10)||
'            return false;'||chr(10)||
'        else'||chr(10)||
'            return true;'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'You do not have permission to create this object.',
  p_when_button_pressed=> 100632937902118817 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100634829802118842 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_validation_name => 'P21900_TITLE Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P21900_TITLE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Title must be specified.',
  p_when_button_pressed=> 100632937902118817 + wwv_flow_api.g_id_offset,
  p_associated_item=> 100634128784118834 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'Created 17-SEP-2009 by MARK');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100675629443243579 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_validation_name => 'P21900_TYPE_COORDINATION',
  p_validation_sequence=> 2,
  p_validation => 'P21900_TYPE_COORDINATION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21900_ACTIVITY_TYPE_LABEL. Type must be specified.',
  p_validation_condition=> 'Instr(:P0_OBJ_TYPE_CODE, ''COORDINATION'') >0',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_when_button_pressed=> 100632937902118817 + wwv_flow_api.g_id_offset,
  p_associated_item=> 100683136247012035 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100686034047077585 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_validation_name => 'P21900_TYPE_CONSULTATION',
  p_validation_sequence=> 3,
  p_validation => 'P21900_TYPE_CONSULTATION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21900_ACTIVITY_TYPE_LABEL. Type must be specified.',
  p_validation_condition=> 'Instr(:P0_OBJ_TYPE_CODE, ''CONSULTATION'') >0',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_when_button_pressed=> 100632937902118817 + wwv_flow_api.g_id_offset,
  p_associated_item=> 100674810958228804 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 15786410544522918 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_validation_name => 'P21900_CONTACT_METHOD',
  p_validation_sequence=> 3.5,
  p_validation => 'P21900_CONTACT_METHOD',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21900_ACTIVITY_TYPE_LABEL. Method must be specified.',
  p_when_button_pressed=> 100632937902118817 + wwv_flow_api.g_id_offset,
  p_associated_item=> 15780621233497668 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100635030631118843 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_validation_name => 'P21900_ACTIVITY_DATE not null',
  p_validation_sequence=> 4,
  p_validation => 'P21900_ACTIVITY_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21900_ACTIVITY_TYPE_LABEL. Date must be specified.',
  p_when_button_pressed=> 100632937902118817 + wwv_flow_api.g_id_offset,
  p_associated_item=> 100633707761118831 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> 'Created 17-SEP-2009 by MARK');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 10779425396019821 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 5,
  p_validation => 'p21900_activity_date',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':request = ''CREATE'' and :p21900_activity_date is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 100633707761118831 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_type   varchar2(200);'||chr(10)||
'begin'||chr(10)||
'    if (instr(:p0_obj_type_code, ''COORDINATION'') > 0) then'||chr(10)||
'        v_type := :p21900_type_coordination;'||chr(10)||
'    elsif(instr(:p0_obj_type_code, ''CONSULTATION'') > 0) then'||chr(10)||
'        v_type := :p21900_type_consultation;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (v_type is not null) then'||chr(10)||
'        :p0_obj :='||chr(10)||
'            osi_consult_coord.create_instance(v_type,'||chr(10)||
'                             ';

p:=p||'                 to_date(:p21900_activity_date || '' '' || :p21900_hour'||chr(10)||
'                                                      || '' '' || :p21900_minute,'||chr(10)||
'                                                      :fmt_date || '' '' || :fmt_time),'||chr(10)||
'                                              :p21900_title,'||chr(10)||
'                                              :p21900_restriction,'||chr(10)||
'                                    ';

p:=p||'          :p21900_narrative,'||chr(10)||
'                                              :p21900_contact_method);'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 100635112518118845 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Consult/Coord',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>100632937902118817 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    if (instr(:p0_obj_type_code, ''COORDINATION'') > 0) then'||chr(10)||
'        :P21900_ACTIVITY_TYPE_LABEL := ''Coordination'';'||chr(10)||
'    elsif(instr(:p0_obj_type_code, ''CONSULTATION'') > 0) then'||chr(10)||
'        :P21900_ACTIVITY_TYPE_LABEL := ''Consultation'';'||chr(10)||
'    else'||chr(10)||
'        :P21900_ACTIVITY_TYPE_LABEL := null;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p21900_contact_method_lov := osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 100642919785493237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21900,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Parameters',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 21900
--
 
begin
 
null;
end;
null;
 
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

COMMIT;