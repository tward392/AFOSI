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
--   Date and Time:   09:00 Tuesday August 16, 2011
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     LIST: Create
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
  p_list_item_link_text=> 'DCII Indexing File',
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
