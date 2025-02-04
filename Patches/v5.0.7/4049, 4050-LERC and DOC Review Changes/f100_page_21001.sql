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
--   Date and Time:   14:06 Wednesday August 1, 2012
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

PROMPT ...Remove page 21001
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>21001);
 
end;
/

 
--application/pages/page_21001
prompt  ...PAGE 21001: Activity Create
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_PRECISION_DATE"'||chr(10)||
'"JS_POPUP_OBJ_DATA"'||chr(10)||
'"JS_CREATE_PARTIC_WIDGET"'||chr(10)||
'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'"JS_ADDRESS_WIDGET"'||chr(10)||
'"STYLE_FORMLAYOUT_100%"'||chr(10)||
'"JS_BUILDRC_DRNARRATIVEANDTITLE"'||chr(10)||
'"JS_HIDESHOWFIELD"'||chr(10)||
''||chr(10)||
'<script language="javascript">'||chr(10)||
'function showParticWidget(objTypeCode)'||chr(10)||
'{'||chr(10)||
' var participantSID = $v(''P21001_PARTICIPANT'');'||chr(10)||
''||chr(10)||
' $("label[for=P21001_PARTIC_DISPLAY],#P21001_PARTIC_DISPLAY").show();'||chr(10)||
' $(''#FindPartic'').show';

ph:=ph||'();'||chr(10)||
''||chr(10)||
' if(participantSID.length > 0)'||chr(10)||
'   $(''#ViewPartic'').show();'||chr(10)||
' else'||chr(10)||
'   $(''#ViewPartic'').hide();'||chr(10)||
''||chr(10)||
' $(''#CreatePartic'').show();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function hideParticWidget(objTypeCode)'||chr(10)||
'{'||chr(10)||
' $("label[for=P21001_PARTIC_DISPLAY],#P21001_PARTIC_DISPLAY").hide();'||chr(10)||
' $(''#FindPartic'').hide();'||chr(10)||
' $(''#ViewPartic'').hide();'||chr(10)||
' $(''#CreatePartic'').hide();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function makeLabelOptional(pID)'||chr(10)||
'{'||chr(10)||
' var label = "label[for="+pID+"]";'||chr(10)||
''||chr(10)||
' $(lab';

ph:=ph||'el).toggleClass(''optionallabel'', true);'||chr(10)||
' $(label).toggleClass(''requiredlabel'', false);'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function makeLabelRequired(pID)'||chr(10)||
'{'||chr(10)||
' var label = "label[for="+pID+"]";'||chr(10)||
''||chr(10)||
' $(label).toggleClass(''optionallabel'', false);'||chr(10)||
' $(label).toggleClass(''requiredlabel'', true);'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function hideShowFields(pthis)'||chr(10)||
'{'||chr(10)||
' var list1Val = $("#P21001_LIST_1").val();'||chr(10)||
' var list1Text = $("#P21001_LIST_1 option:selected").text();'||chr(10)||
' var ob';

ph:=ph||'jTypeCode = $v(''P21001_OBJ_TYPE_CODE'');'||chr(10)||
' var explanationSIDS = $v(''P21001_EXPLANATION_VISIBLE'');'||chr(10)||
''||chr(10)||
' // Hide Optional Items //'||chr(10)||
' hideParticWidget();'||chr(10)||
' hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
' hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
' hideField(''P21001_HOUR'',false,false);'||chr(10)||
' hideField(''P21001_MINUTE'',false,false);'||chr(10)||
' hideField(''P21001_HOUR_2'',false,false);'||chr(10)||
' hideField(''P21001_MINUTE_2'',false,fal';

ph:=ph||'se);'||chr(10)||
' hideField(''P21001_DATE_2'',true,false);'||chr(10)||
' hideField(''P21001_DATE_3'',true,false);'||chr(10)||
' hideField(''P21001_DATE_4'',true,false);'||chr(10)||
' hideField(''P21001_DATE_5'',true,false);'||chr(10)||
' hideField(''P21001_TEXT_2'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_3'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_4'',false,true);'||chr(10)||
' hideField(''P21001_TEXT_5'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_7'',fals';

ph:=ph||'e,true);'||chr(10)||
' hideField(''P21001_TEXT_8'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
' hideField(''P21001_LIST_1'',false,false);'||chr(10)||
' hideField(''P21001_LIST_2'',false';

ph:=ph||',false);'||chr(10)||
' hideField(''P21001_LIST_3'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
' // Hide File Association if value is passed in //'||chr(10)||
' hideField(''P21001_FILE_NAME'',false,false);'||chr(10)||
' hideField(''P21001_FIND_FILE_WIDGET'',false,false);'||chr(10)||
' if($v(''P21001_FROM_OBJ'')=='''')'||chr(10)||
'   {'||chr(10)||
'    showField(''P21001_FILE_NAME'',false,false);'||chr(10)||
'    showField(''P21001';

ph:=ph||'_FIND_FILE_WIDGET'',false,false);'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' // Default Labels to Optional //'||chr(10)||
' makeLabelOptional(''P21001_LIST_1'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_2'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_2'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_4'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_5'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_PR';

ph:=ph||'ECISION_DATE_1_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_2_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_3_DISPLAY'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_TEXT_1'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_2'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_3'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_4'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_5'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_6'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_7'');'||chr(10)||
' mak';

ph:=ph||'eLabelOptional(''P21001_TEXT_8'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_9'');'||chr(10)||
' makeLabelOptional(''P21001_DOCUMENT_NUMBER'');'||chr(10)||
' makeLabelOptional(''P21001_EXPLANATION'');'||chr(10)||
' '||chr(10)||
' makeLabelOptional(''P21001_HOUR'');'||chr(10)||
' makeLabelOptional(''P21001_HOUR_2'',false,false);'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_1'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_2'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_3'');'||chr(10)||
' makeLabelOptional(''P21001';

ph:=ph||'_RADIOGROUP_4'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
' switch(objTypeCode)'||chr(10)||
'       {'||chr(10)||
'                        case ''ACT.AAPP'':'||chr(10)||
'        case ''ACT.AAPP.DOCUMENT_REVIEW'':'||chr(10)||
'              case ''ACT.AAPP.EDUCATION'':'||chr(10)||
'             case ''ACT.AAPP.EMPLOYMENT'':'||chr(10)||
'              case ''ACT.AAPP.INTERVIEW'':'||chr(10)||
'          case ''ACT.AAPP.RECORDS_CHECK'':'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'           ';

ph:=ph||'       case ''ACT.AV_SUPPORT'':'||chr(10)||
'                                        showField(''P21001_LIST_1'');'||chr(10)||
'                                        showField(''P21001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                    case ''ACT.BRIEFI';

ph:=ph||'NG'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'              case ''ACT.COMP_INTRUSION'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,fa';

ph:=ph||'lse);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_3'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PREC';

ph:=ph||'ISION_DATE_1'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_3'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_PRECISION_DATE_1_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'            ';

ph:=ph||'                            showField(''P21001_TEXT_8'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'             case ''ACT.DOCUMENT_REVIEW'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'       ';

ph:=ph||'                                 showParticWidget();'||chr(10)||
''||chr(10)||
'                                        if(explanationSIDS.indexOf(list1Val+''~'')>=0)'||chr(10)||
'                                          {'||chr(10)||
'                                           hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                      ';

ph:=ph||'    }'||chr(10)||
'                                        else'||chr(10)||
'                                          {'||chr(10)||
'                                           showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                          }'||chr(10)||
''||chr(10)||
'                                        buildRC_DRNarrativeandTitle(''P21001_LIST_';

ph:=ph||'1'',''P21001_LIST_2'',''P21001_NARRATIVE'',''P21001_TITLE'',''P21001_OBJ_TYPE_CODE'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'          case ''ACT.FINGERPRINT.MANUAL'':'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                  case ''ACT.INIT_NOTIF'':'||chr(10)||
'';

ph:=ph||'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'           case ''ACT.INTERVIEW.SUBJECT'':'||chr(10)||
'            case ''ACT.INTERVIEW.VICTIM'':'||chr(10)||
'           case ''ACT.INTERVIEW.WITNESS'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'     ';

ph:=ph||'                                   showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
''||chr(10)||
'                     case ''ACT.LIAISON'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'               ';

ph:=ph||'                         makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
''||chr(10)||
'                                        if(list1Text!=''- Select -'')'||chr(10)||
'                                          {'||chr(10)||
'                                           if ($("#P21001_TITLE").val().length>0)'||chr(10)||
'                                             {'||chr(10)||
'                     ';

ph:=ph||'                         $("#P21001_LIST_1 option").each(function(i)'||chr(10)||
'                                               {'||chr(10)||
'                                                $("#P21001_TITLE").val($("#P21001_TITLE").val().replace($(this).text(),list1Text));'||chr(10)||
'                                               });'||chr(10)||
'                                             }'||chr(10)||
'                                           else'||chr(10)||
'    ';

ph:=ph||'                                         {'||chr(10)||
'                                              $("#P21001_TITLE").val(list1Text);'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.MEDIA_ANALYSIS'':'||chr(10)||
'                  case ''ACT.DDD_TRIAGE'':'||chr(10)||
'                                        showField(''P2';

ph:=ph||'1001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_4'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_5'',true,false);'||chr(10)||
'                                        showField(''P21001_TEXT_2'',false,false);'||chr(10)||
'                                        showField(''P21001';

ph:=ph||'_TEXT_3'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_4'',false,true);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelReq';

ph:=ph||'uired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_DATE_2'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                   case ''ACT.POLY_EXAM'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showField(''P2';

ph:=ph||'1001_HOUR_2'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_5'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequir';

ph:=ph||'ed(''P21001_HOUR'');'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
'               case ''ACT.RECORDS_CHECK'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',fal';

ph:=ph||'se,false);'||chr(10)||
'                                        showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        buildRC_DRNarrativeandTitle(''P21001_LIST_1'',''P21001_LIST_2'',''P21001_NARRATIVE'',''P21001_TITLE'',''P21001_OBJ_TYPE_CODE'');'||chr(10)||
'     ';

ph:=ph||'                                   break;'||chr(10)||
''||chr(10)||
'                      case ''ACT.SEARCH'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
' ';

ph:=ph||'                                       if(list1Text==''Search of Person'')'||chr(10)||
'                                          {'||chr(10)||
'                                           $(''#P21001_TEXT_6_LABEL'').val('''');'||chr(10)||
'                                           hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                                           showParticWidget();'||chr(10)||
'                                          }'||chr(10)||
'               ';

ph:=ph||'                         else'||chr(10)||
'                                          {'||chr(10)||
'                                           if(list1Text!=''- Select -'')'||chr(10)||
'                                             {'||chr(10)||
'                                              $(''#P21001_TEXT_6_LABEL'').val(''Explanation'');'||chr(10)||
'                                              showField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                              ';

ph:=ph||'                makeLabelRequired(''P21001_TEXT_6'');'||chr(10)||
'                                              hideParticWidget();'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                 case ''ACT.SOURCE_MEET'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                      ';

ph:=ph||'                  makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showField(''P21001_TEXT_7'',false,true);'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                           ';

ph:=ph||'             showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                case ''ACT.SURVEILLANCE'':'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
'                    ';

ph:=ph||'                    showField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_9'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
'       ';

ph:=ph||'                                 showField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
'                                        showField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001';

ph:=ph||'_RADIOGROUP_3'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001_TEXT_9'');'||chr(10)||
'                                        makeLabelRequired(''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        if(typeof pthis !== "undefine';

ph:=ph||'d") '||chr(10)||
'                                          {'||chr(10)||
'                                           if(pthis.id==''P21001_LIST_1'')'||chr(10)||
'                                             {'||chr(10)||
'                                              var get = new htmldb_Get(null,'||chr(10)||
'                                                                       $v(''pFlowId''),'||chr(10)||
'                                                                    ';

ph:=ph||'   ''APPLICATION_PROCESS=Get_Act_Surveillance_Techniques'','||chr(10)||
'                                                                       $v(''pFlowStepId''));'||chr(10)||
'                                              get.addParam(''x01'',list1Val);'||chr(10)||
'                                              gReturn = $.trim(get.get());'||chr(10)||
'                                              $("#P21001_LIST_2_LOV").val(gReturn);'||chr(10)||
'  '||chr(10)||
'             ';

ph:=ph||'                                 $(''#P21001_LIST_2'').children().remove().end().append(''<option selected value="%null%">- Select -</option>'');'||chr(10)||
'                                              var items = gReturn.split(","), i;'||chr(10)||
''||chr(10)||
'                                              for (i = 0; i < items.length; i++) '||chr(10)||
'                                                 {'||chr(10)||
'                                           ';

ph:=ph||'       if(items[i].length>0)'||chr(10)||
'                                                    {'||chr(10)||
'                                                     var values = items[i].split('';'');'||chr(10)||
'                                                     $(''#P21001_LIST_2'').children().end().append(''<option value="''+values[1]+''">''+values[0]+''</option>'');'||chr(10)||
'                                                    }'||chr(10)||
'                      ';

ph:=ph||'                           }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.SUSPACT_REPORT'':'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                               ';

ph:=ph||'         showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                                default:'||chr(10)||
'                                        if ($(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.CONSULTATION'' || $(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.COORD';

ph:=ph||'INATION'')'||chr(10)||
'                                          {'||chr(10)||
'                                           // Adjust the Title //'||chr(10)||
'                                           adjustCoordinationConsultationTitle();'||chr(10)||
''||chr(10)||
'                                           showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                           showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                 ';

ph:=ph||'          showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                           showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                           makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                           makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                           makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
'                             ';

ph:=ph||'              // Make sure there is at least one Coordination/Consultation Type in the Select List //'||chr(10)||
'                                           var list = document.getElementById(''P21001_LIST_1'');'||chr(10)||
'                                           if(list!=null)'||chr(10)||
'                                             {'||chr(10)||
'                                              if(list.length==1)'||chr(10)||
'                                ';

ph:=ph||'                {'||chr(10)||
'                                                 if(list[0].text=''- Select -'')'||chr(10)||
'                                                   {'||chr(10)||
'                                                    alert(''You are not authorized to create any types of ''+'||chr(10)||
'                                                          $("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activities.\n\n''+'||chr(10)||
'     ';

ph:=ph||'                                                     ''Please talk to your Unit Commander about assigning you permissions for ''+$("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activity Types that you need to create.'');'||chr(10)||
''||chr(10)||
'                                                    window.close();'||chr(10)||
'                                                   }'||chr(10)||
'                                               ';

ph:=ph||' }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
''||chr(10)||
'       }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function hideShowParticipantDetails(pHideParticDetails)'||chr(10)||
'{'||chr(10)||
' var src=$(''#showHideParticipantIcon'').attr("src");'||chr(10)||
' var forceHide="N";'||chr(10)||
''||chr(10)||
' if (typeof pHideParticDetails !== "undefined")'||chr(10)||
'   forceShow=pHideParticDetails;'||chr(10)||
''||chr(10)||
' if (src.indexOf("plus.gif")>-1 ';

ph:=ph||'|| pHideParticDetails=="N")'||chr(10)||
'   {'||chr(10)||
'    showField(''P21001_PARTICIPANT_DETAILS'',false,false);'||chr(10)||
'    $(''#showHideParticipantIcon'').attr("src",src.replace("plus","minus"));'||chr(10)||
'    $(''#P21001_HIDEPARTICDETAILS'').val("N");'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    hideField(''P21001_PARTICIPANT_DETAILS'',false,false);'||chr(10)||
'    $(''#showHideParticipantIcon'').attr("src",src.replace("minus","plus"));'||chr(10)||
'    $(''#P21001_HIDEPARTICDETAILS'').val("Y"';

ph:=ph||');'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' hideShowFields();'||chr(10)||
' $(document).attr("title", $v(''P21001_OBJ_TYPE_DESCRIPTION'')+" (Create)");'||chr(10)||
' hideShowParticipantDetails($v(''P21001_HIDEPARTICDETAILS''));'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 21001,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Activity Create',
  p_step_title=> '&P21001_OBJECT_TYPE_DESCRIPTION. (Create)',
  p_html_page_onload=>'onload=" '||chr(10)||
'if (''&P21001_DONE.'' == ''Y'')'||chr(10)||
'   {'||chr(10)||
'    window.opener.location.reload();'||chr(10)||
''||chr(10)||
'javascript:newWindow({page:20000,clear_cache:''20000'',name:''&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,'',request:''OPEN''});'||chr(10)||
''||chr(10)||
'window.close();'||chr(10)||
'   }'||chr(10)||
'"',
  p_step_sub_title => '&amp;P21000_INTERVIEW_TYPE_CODE. Interview (Create)',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="javascript">'||chr(10)||
'function adjustCoordinationConsultationTitle()'||chr(10)||
'{'||chr(10)||
' var vType;'||chr(10)||
' var vSubType;'||chr(10)||
' '||chr(10)||
' if($(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.CONSULTATION'')'||chr(10)||
'   vType=''Consultation, '';'||chr(10)||
''||chr(10)||
' if($(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.COORDINATION'')'||chr(10)||
'   vType=''Coordination, '';'||chr(10)||
''||chr(10)||
' $(''#P21001_LIST_1 > option:selected'').each(function() '||chr(10)||
'  {'||chr(10)||
'   vSubType=$(this).text();'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' if($(''#P21001_TITLE'').val()=='''')'||chr(10)||
'   $(''#P21001_TITLE'').val(vType+vSubType);'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    $(''#P21001_LIST_1 > option'').each(function() '||chr(10)||
'     {'||chr(10)||
'      $(''#P21001_TITLE'').val($(''#P21001_TITLE'').val().replace(vType+$(this).text(),vType+vSubType));'||chr(10)||
'     });'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120731120144',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '30-Apr-2012 - Tim Ward - CR#4043 - Created to replace ALL Activity Create Pages.'||chr(10)||
''||chr(10)||
'09-May-2012 - Tim Ward - CR#4045 - Added Substantive checkbox.'||chr(10)||
''||chr(10)||
'12-Jul-2012 - Tim Ward - CR#4027 - Added Support for Digital Data Device '||chr(10)||
'                          Triage Activity Creation (Same as Media Analysis).'||chr(10)||
''||chr(10)||
'24-Jul-2012 - Tim Ward - CR#4049, 4050 - Changed Records Check and Document'||chr(10)||
'                          Review Activities to allow multiples in the same'||chr(10)||
'                          activity.  (No longer creates separate activities).'||chr(10)||
'                         Moved buildRecordsCheckNarrativeandTitle to a '||chr(10)||
'                          shortcut and renamed it to '||chr(10)||
'                          buildRC_DRNarrativeandTitle so it can be used in '||chr(10)||
'                          page 21505.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21001,p_text=>ph);
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
  p_id=> 12904705240371170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_plug_name=> '&P21001_OBJ_TYPE_DESCRIPTION.',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 2,
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
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 12910916778411479 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_plug_name=> 'Hidden Items',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Date of Check",'||chr(10)||
'       REFERENCE_NUM,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Record Type",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       EXPLANATION as "Explanation",'||chr(10)||
'       OSI_PARTICIPANT.GET_NAME(SUBJECT_OF_ACTIVITY,''Y'') AS "Subject of Activity",'||chr(10)||
'       OSI_FILE.GET_FULL_ID(FILE_SID) AS "Associated File",'||chr(10)||
'       decod';

s:=s||'e(complete,''Y'',''Yes'',''No'') AS "Completed",'||chr(10)||
'       decode(substantive,''Y'',''Yes'',''No'') AS "Substantive",'||chr(10)||
'       osi_reference.lookup_ref_desc(restriction) as "Restriction",'||chr(10)||
'       decode(:p21001_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_RC_DR_MULTI_TEMP'||chr(10)||
'WHERE PERSONNEL=''&USER_SID.'''||chr(10)||
'AND OBJ_TYPE_CODE=:P21001_OBJ_TYPE_CODE';

wwv_flow_api.create_report_region (
  p_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_name=> '&P21001_OBJ_TYPE_DESCRIPTION.s to Create',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 12,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'')',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> '<b><center>***** No &P21001_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13133431966888176 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 2,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13134213981888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 1,
  p_column_heading=> '<input type="Checkbox" onclick="$f_CheckFirstColumn(this)">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13133827010888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Date of Check',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> 'dd-Mon-rrrr',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14972827686395334 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'REFERENCE_NUM',
  p_column_display_sequence=> 7,
  p_column_heading=> '&P21001_DOCUMENT_NUMBER_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13134107013888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Record Type',
  p_column_display_sequence=> 4,
  p_column_heading=> '&P21001_LIST_1_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13133732062888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Narrative',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15302810657085947 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Explanation',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Explanation',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P21001_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15331505382329072 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Subject of Activity',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Subject Of Activity',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15332009800349262 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Associated File',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Associated File',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15333511588453873 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Completed',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Completed',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15333606506453873 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Substantive',
  p_column_display_sequence=> 12,
  p_column_heading=> 'Substantive',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15333826263467491 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Restriction',
  p_column_display_sequence=> 13,
  p_column_heading=> 'Restriction',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13134331185888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 13,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 13135030246888185 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 28,
  p_button_plug_id => 13133232569888170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:if(confirm(''Are you Sure?''))window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13134800613888185 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 29,
  p_button_plug_id => 13133232569888170+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE_SELECTED',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'apex_application.g_f01.count > 0',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13194825949751935 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 55,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add to List',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 12904922969371175 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 10,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 12905111003371179 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 20,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'',''ACT.DOCUMENT_REVIEW'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>12910006285371195 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.:OPEN:&DEBUG.:20000::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>12904922969371175+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'NEVER',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>13121809958048925 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_branch_action=> 'f?p=&APP_ID.:21001:&SESSION.::&DEBUG.::P21001_DONE:Y',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 15,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST IN (''CREATE'',''CREATE_ACTIVITIES'');',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>12910206330371198 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_branch_action=> 'f?p=&APP_ID.:21001:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12905329984371179 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '1',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_HOUR_LABEL.',
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
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_HOUR_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12905522107371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_MINUTE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '00',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_HOUR_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>12905715820371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
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
  p_id=>12905904281371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'osi_object.get_default_title(:p0_obj_type_sid)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Title',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:55%"',
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
  p_id=>12906121078371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTICIPANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12906326561371182 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 19,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PARTIC_LABEL.',
  p_source=>'begin'||chr(10)||
'  if :P21001_PARTICIPANT_VERSION is not null then'||chr(10)||
'    '||chr(10)||
'    if :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' then'||chr(10)||
''||chr(10)||
'      return osi_source.get_id(:P21001_PARTICIPANT_VERSION);'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
'  '||chr(10)||
'      return osi_participant.get_name(:P21001_PARTICIPANT_VERSION);'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
''||chr(10)||
'     return null;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:35%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>12906502807371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ_TYPE_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Subject',
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
  p_id=>12906717306371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RESTRICTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 41,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_RESTRICTION_LOV.',
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
  p_id=>12906918076371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 42,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
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
  p_tag_attributes  => 'style="width:99%"',
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
  p_id=>12907108080371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_ACTIVITY_DATE_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'ACTIVITY_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_ACTIVITY_DATE_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12907304848371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'&P21001_FIND_WIDGET_SRC.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popupLocator(400,''P21000_PARTICIPANT'',''N'','''',''PART.INDIV'');">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12907515743371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_VIEW_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 21,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a id="ViewPartic" title="View Participant" href="'' || osi_object.get_object_url(:P21001_PARTICIPANT) || ''">&ICON_MAGNIFY.</a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTICIPANT_VERSION IS NOT NULL AND'||chr(10)||
':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>12907706838371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_CREATE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 22,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a id="CreatePartic" title="Create Participant" href="javascript:createParticWidget(''P21001_PARTICIPANT'');">&ICON_CREATE_PERSON.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>12907923844371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RESTRICTION_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12908121248371184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTICIPANT_VERSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12908316096371186 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTICIPANT_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 23,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_INTERVIEW_TYPE_CODE. Details',
  p_source=>'OSI_PARTICIPANT.GET_DETAILS(:P21001_PARTICIPANT_VERSION);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTICIPANT IS NOT NULL AND'||chr(10)||
':P21001_OBJ_TYPE_CODE NOT IN (''ACT.SOURCE_MEET'');',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>12910803272407585 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'Subject',
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
  p_id=>12911709346522858 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12912428571566265 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12912614503571653 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ACTIVITY_DATE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12913523123621463 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_OBJ_TYPE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12914904619805374 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_LIST_1_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_LIST_1_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:hideShowFields(this);"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_LIST_1_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => ':P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.SEARCH'','||chr(10)||
'                          ''ACT.SOURCE_MEET'','||chr(10)||
'                          ''ACT.AV_SUPPORT'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.POLY_EXAM'','||chr(10)||
'                          ''ACT.COMP_INTRUSION'','||chr(10)||
'                          ''ACT.SURVEILLANCE'','||chr(10)||
'                          ''ACT.SUSPACT_REPORT'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION'');');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12915113277807860 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DOCUMENT_NUMBER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 28,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DOCUMENT_NUMBER_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:55%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') <> nvl(:P21200_DOCUMENT_TYPE,''bogus'')',
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
  p_id=>12915320895810124 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_EXPLANATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 29,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_EXPLANATION_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 1000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:99%"',
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
  p_id=>12915919641819178 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_1_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'LOV 1',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_label_alignment  => 'RIGHT',
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
  p_id=>12918202662088712 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_EXPLANATION_VISIBLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12924731602636352 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_1_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12926328166862504 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_2_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12926503710864870 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12928326566871455 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_LIST_2_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_LIST_2_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:hideShowFields();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_LIST_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => ':P21001_OBJ_TYPE_CODE IN (''ACT.SEARCH'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.COMP_INTRUSION'','||chr(10)||
'                          ''ACT.SURVEILLANCE'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION'');'||chr(10)||
'');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12932203045809568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_WIDGET_VISIBLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12942327276441017 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARTIC_TYPE_EXCLUDES',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 3000,
  p_cMaxlength=> 30000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
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
  p_id=>12946729943009549 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FIND_WIDGET_SRC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12963606682366990 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_2_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12963816725369957 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_3_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12964027114372877 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 75,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12964202658375333 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 85,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12967816182530599 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_4_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 95,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12968021723532186 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_5_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12968228303534167 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_4_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_4_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12968404885536819 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DATE_5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_DATE_5_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_DATE_5_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12970905418650523 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 26,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_2_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12971114076653026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 27,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_3_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
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
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12971321695655233 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 135,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12971528621657180 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12975726299789051 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_4_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 155,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12975914656795099 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 31,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_4_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 10,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_4_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>12977913888889537 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_1_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 165,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>12980308151048742 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 34,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_1_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_1_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13047822330601649 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_5',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 24,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_5_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 100,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:55%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_5_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13048108609607111 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_5_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 185,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13049430342632380 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 195,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13049604500634359 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 205,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'YES',
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
  p_id=>13049920430638958 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOUR_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '1',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_HOUR_2_LABEL.',
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
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_HOUR_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13050127010640835 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_MINUTE_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '00',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_HOUR_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>13055408215928711 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FROM_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 215,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13056800821992881 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_6_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 225,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13057013981996676 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_6',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 32,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_6_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 200,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:55%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_6_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13058600138068376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_7_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 235,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13058812605071937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_7',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_7_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 500,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:99%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_7_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13060413812384584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_EXPLANATION_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 245,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13060930350408221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 255,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13061104162410177 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_3_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 265,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13061322170415383 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_LIST_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 37,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_LIST_3_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_LIST_3_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:hideShowFields();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_LIST_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => ':P21001_OBJ_TYPE_CODE=''ACT.COMP_INTRUSION'';');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13063726868605943 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 33,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_2_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13063901719608122 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 295,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13064107606609838 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_8_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 305,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13064321458613865 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_8',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 38,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_8_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 50,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:35%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_8_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13068002635442591 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 315,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13068210946445034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_4_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 325,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13068420296447757 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_3_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13068627222449767 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_RADIOGROUP_4',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 36,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_RADIOGROUP_4_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>'P21001_RADIOGROUP_4_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13077131845435134 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_9_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 335,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13077312929439106 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_9',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_TEXT_9_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 3,
  p_cMaxlength=> 3,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_TEXT_9_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13077731760454088 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_TEXT_9_SUFFIX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10,
  p_cMaxlength=> 10,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-BOTTOM',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>'P21001_TEXT_9_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>13103128531526299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 380,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
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
  p_id=>13103308922530066 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 39,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_ADDRESS_LABEL.',
  p_source=>'osi_address.get_addr_display(:P21001_ADDRESS_VALUE,''FIELDS'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXTAREA',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 36,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_tag_attributes  => 'readOnly',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_ADDRESS_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13103521389533706 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href ="javascript:void(0);" onclick = "javascript:addressWidget(''P21001_ADDRESS_VALUE''); return false;">&ICON_ADDRESS.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_ADDRESS_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>13104532518565254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_ADDRESS_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 410,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13119309490764917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PARENT_OBJECTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13122311474058870 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DONE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13123216949230794 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FILE_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Associate to File',
  p_source=>'begin'||chr(10)||
'  if :P21001_FILE_ASSOC is not null then'||chr(10)||
'     return core_obj.get_tagline(:P21001_FILE_ASSOC);'||chr(10)||
'  else'||chr(10)||
'     return null;'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
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
  p_id=>13123424914233094 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FIND_FILE_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:openLocator(''301'',''P21001_FILE_ASSOC'',''N'',''&P21001_FILE_ASSOC.'',''OPEN'','''','''',''Choose File...'',''FILE'',''&P21001_OBJ.'');">&ICON_LOCATOR.</a>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popupLocator(450,''P21400_FILE'',''N'',''&P21400_SID.'');">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13129121610468647 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_FILE_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13136201804983340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DOCUMENT_NUMBER_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 450,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13137030941020164 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PAY_CAT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 43,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => ':P21500_pay_cat',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Pay Category',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_PAY_CAT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'-Select Pay Category -',
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
  p_id=>13137208215023069 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DUTY_CAT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 44,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Duty Category',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21001_DUTY_CAT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Duty Category -',
  p_lov_null_value=> '',
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
  p_item_comment => 'osi_reference.lookup_ref_sid(''DUTY_CATEGORY'',''01'')');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13137414795024936 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_MISSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mission',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_mission_category'||chr(10)||
' where management_area=''Y'''||chr(10)||
'   and active = ''Y'''||chr(10)||
' order by seq, description',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select Mission -',
  p_lov_null_value=> '',
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
  p_id=>13137622760027285 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_WORK_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 46,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char(sysdate,:FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Work Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
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
  p_id=>13137800035030179 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HOURS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 47,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hours',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 11,
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
  p_id=>13138007654032369 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_COMPLETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 48,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Complete Activity Upon Creation?',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:Yes;Y,No;N',
  p_lov_columns=> 2,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 9,
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
  p_id=>13139000559068145 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PAY_CAT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 520,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13139206446069880 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_DUTY_CAT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 530,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13208828270970263 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 540,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>13539907543081798 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_1_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PRECISION_DATE_1_LABEL.',
  p_post_element_text=>'<a href=javascript:precisionDate(''P21001_PRECISION_DATE_1'');>&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p21001_precision_date_1,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_PRECISION_DATE_1_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13540120356085460 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 560,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
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
  p_id=>13543625204437002 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_2_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PRECISION_DATE_2_LABEL.',
  p_post_element_text=>'<a href="javascript:precisionDate(''P21001_PRECISION_DATE_2'');">&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p21001_precision_date_2,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_PRECISION_DATE_2_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13543801786439750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 580,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
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
  p_id=>13544031007457621 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_3_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21001_PRECISION_DATE_3_LABEL.',
  p_post_element_text=>'<a href="javascript:precisionDate(''P21001_PRECISION_DATE_3'');">&ICON_DATE.</a>',
  p_source=>'osi_util.display_precision_date(to_date(:p21001_precision_date_3,''yyyymmddhh24miss''))',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P21001_PRECISION_DATE_3_LABEL',
  p_display_when_type=>'ITEM_IS_NOT_NULL',
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
  p_id=>13544203434459089 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 600,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
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
  p_id=>13544806120478809 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_1_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 610,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
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
  p_id=>13545011314480340 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_2_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 620,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
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
  p_id=>13545216509481823 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_PRECISION_DATE_3_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 630,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 18,
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
  p_id=>13684915705757129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_SUBSTANTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 640,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Substantive Investigative Activity?',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2: ;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
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
  p_id=>15306101746490240 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_IMAGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 650,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15334031683535378 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HIDESHOW_PARTIC_DETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 22.5,
  p_item_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a id="hideShowPartic" title="Hide/Show Participant Details" href="javascript:hideShowParticipantDetails();"><img id="showHideParticipantIcon" alt="Hide/Show Participant Details" src="#IMAGE_PREFIX#themes/OSI/minus.gif"></a>''',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="vertical-align:bottom; padding-left:2px;"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21001_PARTICIPANT_VERSION IS NOT NULL AND'||chr(10)||
':P21001_PARTIC_WIDGET_VISIBLE=''Y'';',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
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
  p_id=>15335307329670250 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_name=>'P21001_HIDEPARTICDETAILS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 660,
  p_item_plug_id => 12910916778411479+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
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
  p_begin_on_new_field=> 'YES',
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

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 12908617199371186 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_computation_sequence => 10,
  p_computation_item=> 'P21001_RESTRICTION_LOV',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_reference.get_lov(''RESTRICTION'')',
  p_compute_when => 'P21001_RESTRICTION_LOV',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 12908817816371189 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21001,
  p_computation_sequence => 10,
  p_computation_item=> 'P21001_PARTICIPANT_VERSION',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'begin'||chr(10)||
'     if :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' then'||chr(10)||
''||chr(10)||
'       return :P21001_PARTICIPANT;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       return osi_participant.get_current_version(:P21001_PARTICIPANT);'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'end;',
  p_compute_when => 'P21001_PARTICIPANT',
  p_compute_when_type=>'REQUEST_EQUALS_CONDITION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12909019645371190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_TITLE Not Null',
  p_validation_sequence=> 1,
  p_validation => 'P21001_TITLE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Title must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12905904281371182 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12909230128371190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_ACTIVITY_DATE not null',
  p_validation_sequence=> 2,
  p_validation => 'P21001_ACTIVITY_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_ACTIVITY_DATE_LABEL. must be specified.',
  p_validation_condition=> '(:REQUEST IN (''CREATE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE NOT IN (''ACT.COMP_INTRUSION''))'||chr(10)||
'OR (:REQUEST IN (''ADD'') AND :P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK''));',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12907108080371184 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12909422327371190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Activity Date',
  p_validation_sequence=> 3,
  p_validation => 'p21001_activity_date',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''CREATE'') and :p21001_activity_date is not null'||chr(10)||
'OR'||chr(10)||
'(:REQUEST IN (''ADD'') AND :P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK'') '||chr(10)||
'                     AND :p21001_activity_date is not null);',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12907108080371184 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12915600941813735 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_LIST_1 Not Null',
  p_validation_sequence=> 14,
  p_validation => 'P21001_LIST_1',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_LIST_1_LABEL. must be specified.',
  p_validation_condition=> '(:REQUEST IN (''CREATE'') AND'||chr(10)||
'(:P21001_OBJ_TYPE_CODE IN (''ACT.SEARCH'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.DDD_TRIAGE'','||chr(10)||
'                          ''ACT.POLY_EXAM'','||chr(10)||
'                          ''ACT.SURVEILLANCE'','||chr(10)||
'                          ''ACT.SUSPACT_REPORT'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION'')))'||chr(10)||
'OR'||chr(10)||
':REQUEST IN (''ADD'') AND :P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12939917037248840 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_LIST_2 Not Null',
  p_validation_sequence=> 24,
  p_validation => 'P21001_LIST_2',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_LIST_2_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
'(:P21001_OBJ_TYPE_CODE IN (''ACT.SEARCH'',''ACT.LIAISON'',''ACT.SURVEILLANCE'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION''));',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12941001725339038 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Participant Version Not Null',
  p_validation_sequence=> 34,
  p_validation => 'P21001_PARTICIPANT_VERSION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_PARTIC_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.INIT_NOTIF'','||chr(10)||
'                          ''ACT.SOURCE_MEET'','||chr(10)||
'                          ''ACT.FINGERPRINT.MANUAL'','||chr(10)||
'                          ''ACT.POLY_EXAM'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12908121248371184 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12972503734678449 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Date 2 Not Null',
  p_validation_sequence=> 44,
  p_validation => 'P21001_DATE_2',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_DATE_2_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12963606682366990 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12973021526693015 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 2',
  p_validation_sequence=> 54,
  p_validation => 'p21001_date_2',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_2 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12963606682366990 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12973615770700865 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 3',
  p_validation_sequence=> 64,
  p_validation => 'p21001_date_3',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_3 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12963816725369957 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12973925813703729 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 4',
  p_validation_sequence=> 74,
  p_validation => 'p21001_date_4',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_4 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12968228303534167 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12974204473707071 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Valid Date 5',
  p_validation_sequence=> 84,
  p_validation => 'p21001_date_5',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_date_5 is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12968404885536819 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12974619149720689 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 2 Must be a Number',
  p_validation_sequence=> 94,
  p_validation => 'length(translate(trim(:P21001_TEXT_2),'' +-.0123456789'','' '')) = 0'||chr(10)||
'OR'||chr(10)||
'length(translate(trim(:P21001_TEXT_2),'' +-.0123456789'','' '')) is null',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_TEXT_2_LABEL. must be a NUMBER.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12970905418650523 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12974806598736068 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 3 Must be a Number',
  p_validation_sequence=> 104,
  p_validation => 'length(translate(trim(:P21001_TEXT_3),'' +-.0123456789'','' '')) = 0'||chr(10)||
'OR'||chr(10)||
'length(translate(trim(:P21001_TEXT_3),'' +-.0123456789'','' '')) is null',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_TEXT_3_LABEL. must be a NUMBER.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12971114076653026 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12977028471846403 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 2 Must be a Number > 0',
  p_validation_sequence=> 114,
  p_validation => 'declare'||chr(10)||
'       test number;'||chr(10)||
'begin'||chr(10)||
'     if :P21001_TEXT_2 is null then'||chr(10)||
'       '||chr(10)||
'       return true;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       test := to_number(:P21001_TEXT_2);'||chr(10)||
'       if test>0 then'||chr(10)||
'  '||chr(10)||
'         return true;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return false;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
''||chr(10)||
'  when OTHERS then '||chr(10)||
''||chr(10)||
'      return false;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => '&P21001_TEXT_2_LABEL. must be greater than 0.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12970905418650523 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 12977425616864530 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 3 Must be a Number >=1',
  p_validation_sequence=> 124,
  p_validation => 'declare'||chr(10)||
'       test number;'||chr(10)||
'begin'||chr(10)||
'     if :P21001_TEXT_3 is null then'||chr(10)||
'       '||chr(10)||
'       return true;'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
'       test := to_number(:P21001_TEXT_3);'||chr(10)||
'       if test>=1 then'||chr(10)||
'  '||chr(10)||
'         return true;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     return false;'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
''||chr(10)||
'  when OTHERS then '||chr(10)||
''||chr(10)||
'      return false;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => '&P21001_TEXT_3_LABEL. must be greater than or equal to 1.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND '||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12971114076653026 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13057821515017741 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 6 not NULL',
  p_validation_sequence=> 134,
  p_validation => 'P21001_TEXT_6',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_TEXT_6_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND '||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SEARCH'' AND'||chr(10)||
':P21001_TEXT_6_LABEL IS NOT NULL;',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13057013981996676 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13066803104958575 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Radio Group 1 is not null',
  p_validation_sequence=> 144,
  p_validation => ':P21001_RADIOGROUP_1 IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':P21001_RADIOGROUP_1 NOT IN (''U'')',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_RADIOGROUP_1_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.SURVEILLANCE'',''ACT.SUSPACT_REPORT'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 12980308151048742 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13070229618573464 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Radio Group 2 is not null',
  p_validation_sequence=> 154,
  p_validation => ':P21001_RADIOGROUP_2 IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':P21001_RADIOGROUP_2 NOT IN (''U'')',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_RADIOGROUP_2_LABEL. is missing.'||chr(10)||
'',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13063726868605943 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13070617629579425 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Radio Group 3 is not null',
  p_validation_sequence=> 164,
  p_validation => ':P21001_RADIOGROUP_3 IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':P21001_RADIOGROUP_3 NOT IN (''U'')',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => '&P21001_RADIOGROUP_3_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13068420296447757 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13085728307528725 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 9 not null',
  p_validation_sequence=> 174,
  p_validation => 'P21001_TEXT_9',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_TEXT_9_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13077312929439106 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13085919780535712 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Text 9 must be numeric',
  p_validation_sequence=> 184,
  p_validation => 'P21001_TEXT_9',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => '&P21001_TEXT_9_LABEL. must be numeric.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
':P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'';',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13077312929439106 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13192623011438819 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Work Hours > 0',
  p_validation_sequence=> 194,
  p_validation => 'begin'||chr(10)||
'     if to_number(:P21001_HOURS) <= 0 then'||chr(10)||
'       '||chr(10)||
'       return false;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     '||chr(10)||
'     return true;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
'         return false;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Workhours must be > 0.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13137800035030179 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13192812191454619 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Work Date not in the Future',
  p_validation_sequence=> 204,
  p_validation => 'declare'||chr(10)||
'  v_date date;'||chr(10)||
'begin'||chr(10)||
' v_date := :p21001_work_date;'||chr(10)||
' if v_date > trunc(sysdate+1) then'||chr(10)||
'   return false;'||chr(10)||
' else'||chr(10)||
'   return true;'||chr(10)||
' end if;'||chr(10)||
'exception when others then'||chr(10)||
'  return true;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Work Date cannot be in the future.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13137622760027285 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13551505090554190 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'P21001_PRECISION_DATE_1 not null',
  p_validation_sequence=> 214,
  p_validation => 'P21001_PRECISION_DATE_1',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => '&P21001_PRECISION_DATE_1_LABEL. must be specified.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.COMP_INTRUSION'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13539907543081798 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 13565802336822929 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'Address NOT NULL',
  p_validation_sequence=> 224,
  p_validation => 'P21001_ADDRESS_VALUE',
  p_validation_type => 'ITEM_NOT_NULL_OR_ZERO',
  p_error_message => '&P21001_ADDRESS_LABEL. is missing.',
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.SURVEILLANCE'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 13103128531526299 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 15339022715185622 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_validation_name => 'No LERC or DR Currently in the List',
  p_validation_sequence=> 234,
  p_validation => 'declare'||chr(10)||
''||chr(10)||
'       v_cnt number;'||chr(10)||
'begin'||chr(10)||
'     select count(*) into v_cnt'||chr(10)||
'       from t_osi_a_rc_dr_multi_temp'||chr(10)||
'        where personnel=:USER_SID '||chr(10)||
'          and obj_type_code=:P21001_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
''||chr(10)||
'    if v_cnt = 0 then'||chr(10)||
'      '||chr(10)||
'      return false;'||chr(10)||
''||chr(10)||
'    else'||chr(10)||
''||chr(10)||
'      return true;'||chr(10)||
''||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Please add a &P21001_OBJ_TYPE_DESCRIPTION. to the list before clicking Save.',
  p_validation_condition=> ':REQUEST IN (''CREATE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'',''ACT.RECORDS_CHECK'');',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
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
''||chr(10)||
'       v_FieldNames       clob := NULL;'||chr(10)||
'       v_FieldValues      clob := NULL;'||chr(10)||
'       v_ActivityDate     date;'||chr(10)||
'       v_TableName        varchar2(100) := NULL;'||chr(10)||
'       v_ParticipantUsage varchar2(100) := NULL;'||chr(10)||
'       v_ParticipantCode  varchar2(100) := NULL;'||chr(10)||
'       v_AddressUsage     varchar2(100) := NULL;'||chr(10)||
'       v_AddressCode      varchar2(100) := NULL;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'CASE '||chr(10)||
'    WHEN :P21001_OBJ';

p:=p||'_TYPE_CODE IN (''ACT.CC_REVIEW'',''ACT.CHECKLIST'',''ACT.KFAT'',''ACT.OC_REVIEW'') THEN'||chr(10)||
'                                         '||chr(10)||
'        v_TableName := ''t_osi_a_clist'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, :FMT_DATE);'||chr(10)||
'        v_FieldNames := ''sid,checklist_type'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || osi_clist.get_checklist_type(:p21001_obj_type_sid';

p:=p||') || '''''''';'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.AAPP'',''ACT.AAPP.DOCUMENT_REVIEW'',''ACT.AAPP.EDUCATION'',''ACT.AAPP.EMPLOYMENT'',''ACT.AAPP.INTERVIEW'',''ACT.AAPP.RECORDS_CHECK'') THEN'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_aapp_activity'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date,:fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.AV_SUPPORT'' THEN'||chr(10)||
'        '||chr(10)||
'        v_FieldNames';

p:=p||' := ''SID,AV_TYPE,DATE_REQUEST_BY,DATE_COMPLETED'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || :p21001_date_2 || '''''''' || '','' || '''''''' || :p21001_date_3 || '''''''';'||chr(10)||
'        v_ParticipantUsage := ''REQUESTOR'';'||chr(10)||
'        v_ParticipantCode := ''REQUESTOR'';'||chr(10)||
'        v_TableName := ''t_osi_a_avsupport'';'||chr(10)||
'        v_Activi';

p:=p||'tyDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.BRIEFING'' THEN'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_briefing'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date || '' '' || nvl(:p21001_hour, ''00'') || '':'' || nvl(:p21001_minute, ''00''),''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.COMP_INTRUSION'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,intrusion';

p:=p||'_from_date,intrusion_to_date,cci_notified,cci_comment,request_for_information,intrusion_impact,contact_method,afcert_category,afcert_incident_num'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 to_date(:p21001_precision_date_2, ''yyyymmddhh24miss'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 to_date(:p21001_precision_date';

p:=p||'_3, ''yyyymmddhh24miss'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_explanation,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_radiogroup_2 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '',';

p:=p||''' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_3,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_text_8,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_comp_intrusion'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_precision_date_1';

p:=p||', ''yyyymmddhh24miss'');'||chr(10)||
'    '||chr(10)||
'    WHEN substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.CONSULTATION'' OR substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.COORDINATION'' THEN'||chr(10)||
''||chr(10)||
'        :p21001_obj_type_sid := :p21001_list_1;'||chr(10)||
'        v_FieldNames := ''sid,cc_method'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_2,''%null%'',''null'') || '''''''';'||chr(10)||
'        v_TableName := ''t_osi_a_co';

p:=p||'nsult_coord'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW'' THEN'||chr(10)||
''||chr(10)||
'        :P0_OBJ := osi_document_review.create_instance(''&USER_SID.'');'||chr(10)||
'        return;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'        '||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_Table';

p:=p||'Name := ''t_osi_a_fingerprint'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.INIT_NOTIF'' THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''PARTICIPANT'';'||chr(10)||
'        v_ParticipantCode := ''NOTIFIED'';'||chr(10)||
'        v_TableName := ''t_osi_a_init_notification'';'||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.INTERVIEW.GROUP'' ';

p:=p||'THEN'||chr(10)||
''||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.INTERVIEW.SUBJECT'',''ACT.INTERVIEW.VICTIM'',''ACT.INTERVIEW.WITNESS'') THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''PERSON'';'||chr(10)||
'        v_TableName := ''t_osi_a_interview'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date || '' '' || nvl(:p21001_hour, ''00'') || '':'' || nvl(:p2';

p:=p||'1001_minute, ''00''), :fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.LIAISON'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,liaison_type,liaison_level'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_Tabl';

p:=p||'eName := ''t_osi_a_liaison'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-MON-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'',''ACT.DDD_TRIAGE'') THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,media_type,media_size,media_size_units,removable_flag,quantity,seizure_date,receive_date,analysis_start_date,analysis_end_date,comments,activity'';'||chr(10)||
'        v_FieldValues := ''core_sid';

p:=p||'gen.next_sid'' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_text_2,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || '||chr(10)||
'                         ';

p:=p||'        replace(:p21001_text_3,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_2 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_3 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_4 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_5 || '''''''' || '','' || '''''''' || '||chr(10)||
'                             ';

p:=p||'    replace(:p21001_text_4,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 ''~^~P0_OBJ~^~'' || '''''''';'||chr(10)||
''||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_media_analysis'';'||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.POLY_EXAM'' THEN'||chr(10)||
''||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,location,start_datetime,end_datetime,exam_monitor'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_O';

p:=p||'BJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_5,'''''''','''''''''''') || '''''''' || '','' || '||chr(10)||
'''to_date(to_char(to_date('' || '''''''' || :p21001_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '||chr(10)||
'''to_date(to_char(to_date('' || '''''''' || :p21001';

p:=p||'_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour_2 || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute_2 || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'   ';

p:=p||'     v_TableName := ''t_osi_a_poly_exam'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK'' THEN'||chr(10)||
''||chr(10)||
'        :P0_OBJ := osi_records_check.create_instance(''&USER_SID.'');'||chr(10)||
'        return;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SEARCH'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,search_basis, explanation'';'||chr(10)||
'        v_FieldValues := ''''''';

p:=p||''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_6,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_search'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, :fmt_date || '' '' || :fmt_time)';

p:=p||';'||chr(10)||
''||chr(10)||
'        :P21001_OBJ_TYPE_SID:=:p21001_list_1;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,commodity,contact_method'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_7,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName ';

p:=p||':= ''t_osi_a_source_meet'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || nvl(:p21001_minute,''00'') || ''00'', ''yyyymmddhh24miss'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,EMERGENCY,CONSENSUAL,US_LOCATION,ITEM_CASE,INFO_TYPE,TECHNIQUE,REQUESTED_DURATION'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~';

p:=p||'^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || :p21001_radiogroup_2 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_3 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_4 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') |';

p:=p||'| '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_9,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_surveillance'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || nvl(:p21001_minute,''00'') || ''00'', ''y';

p:=p||'yyymmddhh24miss'');'||chr(10)||
'        v_AddressUsage := ''ADDR_INTRCPT'';'||chr(10)||
'        v_AddressCode := ''ADDR_INTRCPT'';'||chr(10)||
'      '||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,CATEGORY,RESOLVED,REPORT_UNIT'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                               ';

p:=p||'  :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || ''~^~UNIT~^~'' || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_suspact_report'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'   ELSE'||chr(10)||
'       v_ActivityDate := to_date(:p21001_activity_date,''DD-MON-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'END CASE;'||chr(10)||
''||chr(10)||
'     IF :P21001_FILE_ASSOC IS NOT NULL THEN'||chr(10)||
''||chr(10)||
'       :P21001_FROM_OBJ:=:P21001_FILE_ASSOC;'||chr(10)||
' '||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'';

p:=p||'     :P0_OBJ := osi_activity.create_instance(:p21001_obj_type_sid,'||chr(10)||
'                                             v_ActivityDate,'||chr(10)||
'                                             :p21001_title,'||chr(10)||
'                                             :p21001_restriction,'||chr(10)||
'                                             :P21001_narrative,'||chr(10)||
'                                             v_FieldNames,'||chr(10)||
'                       ';

p:=p||'                      v_FieldValues,'||chr(10)||
'                                             :p21001_participant_version,'||chr(10)||
'                                             v_ParticipantUsage,'||chr(10)||
'                                             v_ParticipantCode,'||chr(10)||
'                                             v_TableName,'||chr(10)||
'                                             :p21001_from_obj,'||chr(10)||
'                                       ';

p:=p||'      v_AddressUsage,'||chr(10)||
'                                             v_AddressCode,'||chr(10)||
'                                             :p21001_address_value,'||chr(10)||
'                                             :p21001_parent_objective,'||chr(10)||
'                                             replace(:p21001_pay_cat,''%null%'',''null''),'||chr(10)||
'                                             replace(:p21001_duty_cat,''%null%'',''null''),'||chr(10)||
'    ';

p:=p||'                                         replace(:p21001_mission,''%null%'',''null''),'||chr(10)||
'                                             :p21001_work_date,'||chr(10)||
'                                             :p21001_hours,'||chr(10)||
'                                             :p21001_complete,'||chr(10)||
'                                             :p21001_substantive);'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 12935431854997678 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''CREATE'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
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
'     /* Since all go into one activity now, make sure they all have the same'||chr(10)||
'        values for certain fields like File association etc ....             */'||chr(10)||
'     if :P21001_FILE_ASSOC is null then'||chr(10)||
''||chr(10)||
'       select file_sid into :P21001_FILE_ASSOC '||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'';

p:=p||'     if :P21001_PARTICIPANT is null then'||chr(10)||
''||chr(10)||
'       select subject_of_activity into :P21001_PARTICIPANT '||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_COMPLETE is null then'||chr(10)||
''||chr(10)||
'       select complete into :P21001_COMPLETE'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personne';

p:=p||'l=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_SUBSTANTIVE is null then'||chr(10)||
''||chr(10)||
'       select substantive into :P21001_SUBSTANTIVE'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_RESTRICTION is null then'||chr(10)||
''||chr(10)||
'       select restriction into :P21';

p:=p||'001_RESTRICTION '||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     if :P21001_PAY_CAT is null then'||chr(10)||
''||chr(10)||
'       select wh_pay_cat into :P21001_PAY_CAT'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'    ';

p:=p||' if :P21001_DUTY_CAT is null then'||chr(10)||
''||chr(10)||
'       select wh_duty_cat into :P21001_DUTY_CAT'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     if :P21001_MISSION is null then'||chr(10)||
''||chr(10)||
'       select wh_mission into :P21001_MISSION'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'       ';

p:=p||'      and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     if :P21001_WORK_DATE is null then'||chr(10)||
''||chr(10)||
'       select wh_date into :P21001_WORK_DATE'||chr(10)||
'          from t_osi_a_rc_dr_multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
'     if :P21001_HOURS is null then'||chr(10)||
''||chr(10)||
'       select wh_hours into :P21001_HOURS'||chr(10)||
'          from t_osi_a_rc_dr_';

p:=p||'multi_temp '||chr(10)||
'           where personnel=:USER_SID '||chr(10)||
'             and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         null;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
''||chr(10)||
'insert into t_osi_a_rc_dr_multi_temp'||chr(10)||
'(activity_date,subject_of_activity,reference_num,restriction,title,narrative,doc_type,results,file_sid,personnel,WH_PAY_CAT,WH_DUTY_CAT,WH_MISSION,WH_DATE,WH_HOURS,COMPLETE,SUBSTANTIVE,OBJ_TYPE_';

p:=p||'CODE,EXPLANATION)'||chr(10)||
'values'||chr(10)||
'(:P21001_ACTIVITY_DATE,'||chr(10)||
' :P21001_PARTICIPANT,'||chr(10)||
' :P21001_DOCUMENT_NUMBER,'||chr(10)||
' :P21001_RESTRICTION,'||chr(10)||
' :P21001_TITLE,'||chr(10)||
' :P21001_NARRATIVE,'||chr(10)||
' REPLACE(:P21001_LIST_1,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_LIST_2,''%null%'',NULL),'||chr(10)||
' :P21001_FILE_ASSOC,'||chr(10)||
' :USER_SID,'||chr(10)||
' REPLACE(:P21001_PAY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_DUTY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_MISSION,''%null%'',NULL),'||chr(10)||
' :P21001';

p:=p||'_WORK_DATE,'||chr(10)||
' :P21001_HOURS,'||chr(10)||
' :P21001_COMPLETE,'||chr(10)||
' :P21001_SUBSTANTIVE,'||chr(10)||
' :P21001_OBJ_TYPE_CODE,'||chr(10)||
' :P21001_EXPLANATION) '||chr(10)||
'returning sid into :P21001_SELECTED;'||chr(10)||
''||chr(10)||
''||chr(10)||
'update t_osi_a_rc_dr_multi_temp '||chr(10)||
'   set subject_of_activity=:p21001_participant,'||chr(10)||
'       file_sid=:p21001_file_assoc,'||chr(10)||
'       complete=:p21001_complete,'||chr(10)||
'       substantive=:p21001_substantive,'||chr(10)||
'       restriction=:p21001_restriction,'||chr(10)||
'       wh_pay_';

p:=p||'cat=:p21001_pay_cat,'||chr(10)||
'       wh_duty_cat=:p21001_duty_cat,'||chr(10)||
'       wh_mission=:p21001_mission,'||chr(10)||
'       wh_date=:p21001_work_date,'||chr(10)||
'       wh_hours=:p21001_hours'||chr(10)||
'     where personnel=:user_sid '||chr(10)||
'       and obj_type_code=:P21001_obj_type_code;'||chr(10)||
''||chr(10)||
'COMMIT;';

wwv_flow_api.create_page_process(
  p_id     => 13193311115501624 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Check/Review To List',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Failed to add check to the list.',
  p_process_when=>':REQUEST IN (''ADD'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
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
'    for I in 1 .. apex_application.g_f01.count'||chr(10)||
'    loop'||chr(10)||
'        delete from T_OSI_A_RC_DR_MULTI_TEMP'||chr(10)||
'              where sid = apex_application.g_f01(I);'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13193519426504026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Remove Selected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'REMOVE_SELECTED',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
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
p:=p||'SELECT SID,to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'SUBJECT_OF_ACTIVITY,'||chr(10)||
'REFERENCE_NUM,'||chr(10)||
'RESTRICTION,'||chr(10)||
'TITLE,'||chr(10)||
'NARRATIVE,'||chr(10)||
'DOC_TYPE,'||chr(10)||
'RESULTS,'||chr(10)||
'FILE_SID,'||chr(10)||
'WH_PAY_CAT,'||chr(10)||
'WH_DUTY_CAT,'||chr(10)||
'WH_MISSION,'||chr(10)||
'WH_DATE,'||chr(10)||
'WH_HOURS,'||chr(10)||
'COMPLETE,'||chr(10)||
'SUBSTANTIVE,'||chr(10)||
'EXPLANATION'||chr(10)||
'INTO'||chr(10)||
':P21001_SELECTED,'||chr(10)||
':P21001_ACTIVITY_DATE,'||chr(10)||
':P21001_PARTICIPANT,'||chr(10)||
':P21001_DOCUMENT_NUMBER,'||chr(10)||
':P21001_RESTRICTION,'||chr(10)||
':P21001_TITLE,'||chr(10)||
':P21001_NARRATIVE,'||chr(10)||
'';

p:=p||':P21001_LIST_1,'||chr(10)||
':P21001_LIST_2,'||chr(10)||
':P21001_FILE_ASSOC,'||chr(10)||
':P21001_PAY_CAT,'||chr(10)||
':P21001_DUTY_CAT,'||chr(10)||
':P21001_MISSION,'||chr(10)||
':P21001_WORK_DATE,'||chr(10)||
':P21001_HOURS,'||chr(10)||
':P21001_COMPLETE,'||chr(10)||
':P21001_SUBSTANTIVE,'||chr(10)||
':P21001_EXPLANATION'||chr(10)||
'FROM T_OSI_A_RC_DR_MULTI_TEMP WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'BEGIN'||chr(10)||
'     SELECT OSI_PARTICIPANT.GET_CURRENT_VERSION(:P21001_PARTICIPANT) INTO :P21001_PARTICIPANT_VERSION FROM DUAL;'||chr(10)||
''||chr(10)||
'EXCEPTION WH';

p:=p||'EN OTHERS THEN'||chr(10)||
''||chr(10)||
'         NULL;'||chr(10)||
''||chr(10)||
'END;';

wwv_flow_api.create_page_process(
  p_id     => 13193725660505875 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Check/Review in List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''EDIT%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
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
p:=p||':P21001_PARTIC_WIDGET_VISIBLE:=''N'';'||chr(10)||
':P21001_HOUR_LABEL:=''Time'';'||chr(10)||
''||chr(10)||
':P21001_LIST_1_LOV:=''- Select -;%null%'';'||chr(10)||
':P21001_LIST_2_LOV:=''- Select -;%null%'';'||chr(10)||
':P21001_LIST_3_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'--- Default to exclude all but Individuals ---'||chr(10)||
':P21001_PARTIC_TYPE_EXCLUDES:=''All Participant Types;ALL~Programs;PART.NONINDIV.PROG~Companies;PART.NONINDIV.COMP~Organizations;PART.NONINDIV.ORG'';'||chr(10)||
''||chr(10)||
'select t.descri';

p:=p||'ption,t.sid,ot.default_title,replace(image,''.gif'',''.ico'')'||chr(10)||
'  into :P21001_OBJ_TYPE_DESCRIPTION,:P21001_OBJ_TYPE_SID,:P21001_TITLE,:P0_OBJ_IMAGE'||chr(10)||
'  from t_core_obj_type t,t_osi_obj_type ot'||chr(10)||
' where t.code=:P21001_OBJ_TYPE_CODE'||chr(10)||
'   and ot.sid=t.sid;'||chr(10)||
''||chr(10)||
'IF :P21001_OBJ_TYPE_CODE IN (''ACT.AAPP'',''ACT.AAPP.DOCUMENT_REVIEW'',''ACT.AAPP.EDUCATION'',''ACT.AAPP.EMPLOYMENT'',''ACT.AAPP.INTERVIEW'',''ACT.AAPP.RECORDS_CHECK'')';

p:=p||' THEN'||chr(10)||
'  '||chr(10)||
'  :P21001_RESTRICTION := osi_reference.lookup_ref_sid(''RESTRICTION'', ''UNIT'');'||chr(10)||
'  :P21001_NARRATIVE := osi_aapp_activity.get_pre_can_narrative(:P21001_PARENT_OBJECTIVE);'||chr(10)||
''||chr(10)||
'END IF;'||chr(10)||
''||chr(10)||
'CASE :P21001_OBJ_TYPE_CODE'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.AV_SUPPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Request Received'';'||chr(10)||
'                                       :P21001_LIS';

p:=p||'T_1_LABEL := ''Support Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AV_TYPE'');'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Date Requested By'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Date Completed'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Requestor'';'||chr(10)||
'                   ';

p:=p||'                    :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''';

p:=p||'P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.BRIEFING'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Briefing Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Briefing Time'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.COMP_INTRUSION'' THEN'||chr(10)||
'                                       :P21001_PRECISIO';

p:=p||'N_DATE_1_LABEL:=''CCI Notified Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Impact'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''COMPINT_IMPACT'');'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Contact Method'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || os';

p:=p||'i_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
'                                       :P21001_LIST_3_LABEL := ''AFCERT Category'';'||chr(10)||
'                                       :P21001_LIST_3_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AFCERT_CATEGORY'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''CCI Notified'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Req';

p:=p||'uest For Information'';'||chr(10)||
'                                       :P21001_TEXT_8_LABEL:=''AFCERT Incident Num'';'||chr(10)||
''||chr(10)||
'                                       :P21001_PRECISION_DATE_2_LABEL:=''From'';'||chr(10)||
'                                       :P21001_PRECISION_DATE_3_LABEL:=''To'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''CCI Comment'';'||chr(10)||
''||chr(10)||
'        WHEN ''ACT.DOCUMENT_REVIEW'' THEN'||chr(10)||
'              ';

p:=p||'                         :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''DOCREV_DOCTYPE'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Document Type'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''Explanation'';'||chr(10)||
'                                       :P210';

p:=p||'01_DOCUMENT_NUMBER_LABEL:=''Document Number'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject of Activity'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
''||chr(10)||
'                                       :P21001_EXPLANATION_VISIBLE := osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') || ''~'';'||chr(10)||
''||chr(10)||
'                                       :P21001_LIST_2_LABEL := ';

p:=p||'''Document Review Result'';'||chr(10)||
'                                       '||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select DESCRIPTION d, CODE r from T_OSI_A_RC_DR_RESULTS order by 1)'||chr(10)||
'                                       loop'||chr(10)||
'                                           :P21001_LIST_2_LOV := :P21001_LIST_2_LOV || repla';

p:=p||'ce(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
''||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Ch';

p:=p||'oose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'     WHEN ''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Fingerprints Taken'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FI';

p:=p||'ND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'             WHEN ''ACT.INIT_NOTIF'' THEN'||chr(10)||
'                                   ';

p:=p||'    :P21001_ACTIVITY_DATE_LABEL:=''Notified On'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Notified By'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P2100';

p:=p||'1_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.SUBJECT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                           ';

p:=p||'            :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                  ';

p:=p||'                              ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'       WHEN ''ACT.INTERVIEW.VICTIM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                         ';

p:=p||'              :P21001_PARTIC_LABEL:=''Victim'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_P';

p:=p||'ARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.WITNESS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Witness'';'||chr(10)||
'                              ';

p:=p||'         :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&IC';

p:=p||'ON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                WHEN ''ACT.LIAISON'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Liaison Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Liaison Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON_TYPE'');'||chr(10)||
'                                       :P21001_LIST_2_LABE';

p:=p||'L:=''Liaison Level'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON_LEVEL'');'||chr(10)||
''||chr(10)||
'             WHEN ''ACT.DDD_TRIAGE'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Media Type'';'||chr(10)||
'                                       :P21001_LIST_1_';

p:=p||'LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_2_LABEL:=''Media Size'';'||chr(10)||
'                                       :P21001_TEXT_3_LABEL:=''Quantity'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Size Units'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''M';

p:=p||'EDANLY_UNIT'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Removable?'';'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Seizure Date'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Receive Date'';'||chr(10)||
'                                       :P21001_DATE_4_LABEL:=''Analysis Start Date'';'||chr(10)||
'                                       :P21001_DATE_5_LABEL:=''Anal';

p:=p||'ysis End Date'';'||chr(10)||
'                                       :P21001_TEXT_4_LABEL:=''Comments'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.MEDIA_ANALYSIS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Media Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''ME';

p:=p||'DANLY_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_2_LABEL:=''Media Size'';'||chr(10)||
'                                       :P21001_TEXT_3_LABEL:=''Quantity'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Size Units'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_UNIT'');'||chr(10)||
'                                       ';

p:=p||':P21001_RADIOGROUP_1_LABEL:=''Removable?'';'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Seizure Date'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Receive Date'';'||chr(10)||
'                                       :P21001_DATE_4_LABEL:=''Analysis Start Date'';'||chr(10)||
'                                       :P21001_DATE_5_LABEL:=''Analysis End Date'';'||chr(10)||
'                                      ';

p:=p||' :P21001_TEXT_4_LABEL:=''Comments'';'||chr(10)||
''||chr(10)||
'              WHEN ''ACT.POLY_EXAM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Exam Date'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Examinee Name'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Monitor to Exam'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || os';

p:=p||'i_reference.get_lov(''POLY_MONITOR'');'||chr(10)||
'                                       :P21001_TEXT_5_LABEL:=''Place of Examination'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Start Time'';'||chr(10)||
'                                       :P21001_HOUR_2_LABEL:=''End Time'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGE';

p:=p||'T_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
'  '||chr(10)||
'          WHEN ''ACT.RECORDS_CHECK'' THEN'||chr(10)||
'                                       :P';

p:=p||'21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''LERC_DOCTYPE'');'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject of Activity'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Record Type';

p:=p||''';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Records Check Result'';'||chr(10)||
'                                       '||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select DESCRIPTION d, CODE r from T_OSI_A_RC_DR_RESULTS order by 1)'||chr(10)||
'                                       loop'||chr(10)||
'                            ';

p:=p||'               :P21001_LIST_2_LOV := :P21001_LIST_2_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
''||chr(10)||
'                                       :P21001_DOCUMENT_NUMBER_LABEL:=''Reference Number'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''',''''';

p:=p||''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                 WHEN ''ACT.SEARCH'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Search Date'';'||chr(10)||
'                                       :P21001_PARTIC_L';

p:=p||'ABEL:=''Person Associated with Search'';'||chr(10)||
'                                       :P21001_TEXT_6_LABEL:=''Explanation'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Search Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (sele';

p:=p||'ct description d, sid r  '||chr(10)||
'                                                       from t_core_obj_type '||chr(10)||
'                                                         where code like substr(''ACT.SEARCH'', 1, 10) || ''%'' '||chr(10)||
'                                                           and description <> ''Search'' order by description)'||chr(10)||
'                                       loop'||chr(10)||
'                                   ';

p:=p||'        :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r|| '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
'                                       :P21001_LIST_1_LOV := rtrim(:P21001_LIST_1_LOV, '','');'||chr(10)||
'  '||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Search Based Upon'';'||chr(10)||
'                                       :P21001_LIST_2_LOV := ''- Select ';

p:=p||'-;%null%,'' || osi_reference.get_lov(''SEARCH_BASIS'');'||chr(10)||
'  '||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''',';

p:=p||''''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'            WHEN ''ACT.SOURCE_MEET'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Meet Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Interview Type'';'||chr(10)||
'                                       :P2';

p:=p||'1001_TEXT_7_LABEL := ''Commodity'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Source'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN''''';

p:=p||','''''' ||'||chr(10)||
'                                                                '''''','''''''',''''Choose Source Number...'''',''''SOURCE'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'           WHEN ''ACT.SURVEILLANCE'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested Start Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CA';

p:=p||'TEGORY'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Surveillance Information Type'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Surveillance Technique'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''US Location'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Emergency'';'||chr(10)||
'                                       :P21';

p:=p||'001_RADIOGROUP_3_LABEL:=''Consensual'';'||chr(10)||
'                                       :P21001_RADIOGROUP_4_LABEL:=''ITEM Case'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SURV_INFO_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_9_LABEL := ''Requested Duration'';'||chr(10)||
'                                       :P21001_TEXT_9_SUFFIX := ''  days';

p:=p||''';'||chr(10)||
'                                       :P21001_ADDRESS_LABEL := ''Address of Intercept'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested Start Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CATEGORY'');'||chr(10)||
'                                       :P21001_L';

p:=p||'IST_1_LABEL := ''Category of Suspicious Activity'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Resolved'';'||chr(10)||
''||chr(10)||
'                                   ELSE'||chr(10)||
'                                       if (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.CONSULTATION'') then'||chr(10)||
''||chr(10)||
'                                         :P21001_ACTIVITY_DATE_LABEL:=''Consultation Date'';'||chr(10)||
'                                   ';

p:=p||'      :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                         :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                                         for a in (select d,r '||chr(10)||
'                                                         from V_OSI_CONSULT_CREATE_TYPES order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P2';

p:=p||'1001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                                         begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type where code =''ACT.CONSULTATION.ACQUISITION'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
'         '||chr(10)||
'            ';

p:=p||'                                      null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       elsif (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.COORDINATION'') then'||chr(10)||
''||chr(10)||
' ';

p:=p||'                                           :P21001_ACTIVITY_DATE_LABEL:=''Coordination Date'';'||chr(10)||
'                                            :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                            :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                                         for a in (select d,r '||chr(10)||
'                                                         from V_OSI_COORDIN_CREATE_';

p:=p||'TYPES order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                                         begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type w';

p:=p||'here code =''ACT.COORDINATION.FORENSICS'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
''||chr(10)||
'                                                  null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONT';

p:=p||'ACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       else'||chr(10)||
'                                         '||chr(10)||
'                                         if (:P21001_OBJ_TYPE_CODE IN (''ACT.CC_REVIEW'',''ACT.CHECKLIST'',''ACT.KFAT'',''ACT.OC_REVIEW'')) then'||chr(10)||
'                                         '||chr(10)||
'  '||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
''||chr(10)||
'                             ';

p:=p||'            else'||chr(10)||
''||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                           :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
''||chr(10)||
'                                         end if;'||chr(10)||
''||chr(10)||
'                                       end if;'||chr(10)||
''||chr(10)||
' '||chr(10)||
'END CASE;'||chr(10)||
''||chr(10)||
'if :P21001_LIST_1_LOV = '''' then'||chr(10)||
''||chr(10)||
'  :P21001_LIST_1_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_LIST_2_L';

p:=p||'OV = '''' then'||chr(10)||
''||chr(10)||
'  :P21001_LIST_2_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_LIST_3_LOV = '''' then'||chr(10)||
''||chr(10)||
'  :P21001_LIST_3_LOV:=''- Select -;%null%'';'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_duty_cat_lov is null then'||chr(10)||
'  '||chr(10)||
'  :P21001_pay_cat_lov := osi_reference.get_lov(''PERSONNEL_PAY_CATEGORY'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_duty_cat_lov is null then'||chr(10)||
''||chr(10)||
'  :P21001_duty_cat_lov := osi_reference.get_lov(''DUTY_CATEGORY'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P2100';

p:=p||'1_activity_date is null then'||chr(10)||
''||chr(10)||
'  select to_char(sysdate,''&FMT_DATE.'') into :P21001_activity_date from dual;'||chr(10)||
''||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 12909702564371193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST NOT IN (''P21001_PARTICIPANT'',''ADDRESS'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 21001
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
