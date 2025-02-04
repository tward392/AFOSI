ALTER TABLE T_OSI_A_DOCUMENT_REVIEW ADD USE_DATE_IN_NARRATIVE VARCHAR2(1) DEFAULT 'Y';

ALTER TABLE T_OSI_A_RECORDS_CHECK ADD USE_DATE_IN_NARRATIVE VARCHAR2(1) DEFAULT 'Y';


set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_DOCUMENT_REVIEW" as
/******************************************************************************
   Name:     Osi_document_review
   Purpose:  Provides Functionality For Document Review Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    22-May-2009 M.Batdorf       Created this package body. log_error, get_tagline, get_summary, index1,
                                get_status, create_instance, and clone.
    26-Jul-2012 Tim Ward        CR#4050 - Document Reviews can not have multiples in the same activity.
                                 Changed create_instance.
                                 Added get_narrative.
                                 Changed clone.
    06-Sep-2012 Tim Ward        CR#4050 - When Narrative is generated "On 05 Sep 12, A " needs to
                                 be "On 05 Sep 12, a ".
                                 Changed get_narrative.
    18-Oct-2012 Tim Ward        CR#4152 - Check use_date_in_narrative field.
                                 Changed get_narrative.
                                 
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_DOCUMENT_REVIEW';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: p_obj = ' || nvl(p_obj, 'null') || ', p_variant = '
                      || nvl(p_variant, 'null') || '. Error is: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function get_narrative(p_obj in varchar2) return clob is
    
         v_Narrative clob;
         v_Narrative_Temp clob;
         
    begin
         for i in (select * from t_osi_a_document_review where obj=p_obj order by activity_date,sid)
         loop
             if (substr(i.narrative,1,2)='A ') then
             
               v_Narrative_Temp := 'a ' || substr(i.narrative,3);
             
             else

               v_Narrative_Temp := i.narrative;
             
             end if;
             v_Narrative := v_Narrative || CASE i.use_date_in_narrative WHEN 'Y' THEN 'On ' || to_char(i.activity_date,'DD Mon YY') || ', ' ELSE '' END || v_Narrative_Temp || CHR(13) || CHR(10) || CHR(13) || CHR(10);
             
         end loop;
         
         return v_Narrative;
         
    exception
        when others then
            log_error('get_narrative: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_narrative;

   function create_instance(p_personnelSID in varchar2) return varchar2 is
        v_count                  number := 1;
        v_act_count              number;
        v_ParticipantUsage       varchar2(100) := 'PARTICIPANTS';
        v_ParticipantCode        varchar2(100) := 'SUBJECT';
        v_AddressUsage           varchar2(100) := NULL;
        v_AddressCode            varchar2(100) := NULL;
        v_Participant_Version    varchar2(20);
        v_sid                    t_core_obj.sid%type;
        v_obj                    t_core_obj.sid%type;
        v_obj_type_sid           varchar2(20) := core_obj.lookup_objtype('ACT.DOCUMENT_REVIEW');
    begin
         for i in (SELECT * FROM T_OSI_A_RC_DR_MULTI_TEMP WHERE PERSONNEL=p_personnelSID and OBJ_TYPE_CODE='ACT.DOCUMENT_REVIEW')
         loop
             v_Participant_Version:=osi_participant.get_current_version(i.subject_of_activity);

             if (v_count = 1) then

               v_obj := osi_activity.create_instance(v_obj_type_sid,
                                                     i.activity_date,
                                                     i.title,
                                                     i.restriction,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     v_Participant_Version,
                                                     v_ParticipantUsage,
                                                     v_ParticipantCode,
                                                     NULL,
                                                     i.file_sid,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     replace(i.wh_pay_cat,'%null%','null'),
                                                     replace(i.wh_duty_cat,'%null%','null'),
                                                     replace(i.wh_mission,'%null%','null'),
                                                     i.wh_date,
                                                     i.wh_hours,
                                                     i.complete,
                                                     i.substantive);
                                                   
                                                              
            end if;
            
            insert into t_osi_a_document_review (activity_date,document_number,narrative,doc_type,results,obj,explanation)
                  values (i.activity_date,i.reference_num,i.narrative,i.doc_type,i.results,v_obj,i.explanation) returning sid into v_sid;
            commit;
            
            select count(*) into v_act_count from t_osi_a_document_review where sid=v_sid;
        
            if (v_act_count > 0) then

              delete from T_OSI_A_RC_DR_MULTI_TEMP where sid=i.sid;

            end if;
            v_count := v_count + 1;
            
         end loop;

         recent_access(v_obj, p_personnelSID);
         return v_obj;
        
    exception
        when others then
            log_error('create_instance error, ' || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
    begin
        --- Get Document Review Activity record ---
        for a in (select * from t_osi_a_document_review where sid=p_obj)
        loop
            --- Insert a new Document Review Activity record ---
            insert into t_osi_a_document_review (obj, doc_type, document_number, explanation, narrative, activity_date, results) values (p_new_sid, a.doc_type, a.document_number, a.explanation, a.narrative, a.activity_date, a.results);

        end loop;
        
    exception
        when others then
            log_error('osi_document_review.clone: p_obj = ' || nvl(p_obj, 'null')
                      || ', p_new_sid = ' || nvl(p_new_sid, 'null') || '. Error is: ' || sqlerrm);
            raise;
    end clone;
end osi_document_review;
/



set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_RECORDS_CHECK" as
/******************************************************************************
   Name:     osi_records_check
   Purpose:  Provides Functionality For Law Enforcement Records Check Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    05-Jun-2009 M.Batdorf       Created this package body. get_tagline, get_summary, index1,
                                get_status, create_instance, and clone.
    14-Jul-2009 T.McGuffin      Removed participant and participant role from create_instance.
    19-Mar-2012 Tim Ward        CR#3696 - Create Multiple Records Check Activities at Once.
                                 Added p_subject_of_activity, p_file_sid, p_work_hours_fields, and
                                 p_complete to create_instance paramters.
    24-Jul-2012 Tim Ward        CR#4049 - Records Checks can not have multiples in the same activity.
                                 Changed create_instance.
                                 Added get_narrative.
                                 Changed clone.
    06-Sep-2012 Tim Ward        CR#4049 - When Narrative is generated "On 05 Sep 12, A " needs to
                                 be "On 05 Sep 12, a ".
                                 Changed get_narrative.
    18-Oct-2012 Tim Ward        CR#4152 - Check use_date_in_narrative field.
                                 Changed get_narrative.
                                 
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_RECORDS_CHECK';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: p_obj = ' || nvl(p_obj, 'null') || ', p_variant = '
                      || nvl(p_variant, 'null') || '. Error is: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
    end index1;

    function get_narrative(p_obj in varchar2) return clob is
    
         v_Narrative clob;
         v_Narrative_Temp clob;
         
    begin
         for i in (select * from t_osi_a_records_check where obj=p_obj order by activity_date,sid)
         loop
             if (substr(i.narrative,1,2)='A ') then
             
               v_Narrative_Temp := 'a ' || substr(i.narrative,3);
             
             else

               v_Narrative_Temp := i.narrative;
             
             end if;
             
             --v_Narrative := v_Narrative || 'On ' || to_char(i.activity_date,'DD Mon YY') || ', ' || v_Narrative_Temp || CHR(13) || CHR(10) || CHR(13) || CHR(10);
             v_Narrative := v_Narrative || CASE i.use_date_in_narrative WHEN 'Y' THEN 'On ' || to_char(i.activity_date,'DD Mon YY') || ', ' ELSE '' END || v_Narrative_Temp || CHR(13) || CHR(10) || CHR(13) || CHR(10);
             
         end loop;
         
         return v_Narrative;
         
    exception
        when others then
            log_error('get_narrative: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_narrative;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function create_instance(p_personnelSID in varchar2) return varchar2 is
        v_count                  number := 1;
        v_act_count              number;
        v_ParticipantUsage       varchar2(100) := 'PARTICIPANTS';
        v_ParticipantCode        varchar2(100) := 'SUBJECT';
        v_AddressUsage           varchar2(100) := NULL;
        v_AddressCode            varchar2(100) := NULL;
        v_Participant_Version    varchar2(20);
        v_sid                    t_core_obj.sid%type;
        v_obj                    t_core_obj.sid%type;
        v_obj_type_sid           varchar2(20) := core_obj.lookup_objtype('ACT.RECORDS_CHECK');
    begin
         for i in (SELECT * FROM T_OSI_A_RC_DR_MULTI_TEMP WHERE PERSONNEL=p_personnelSID and OBJ_TYPE_CODE='ACT.RECORDS_CHECK')
         loop
             v_Participant_Version:=osi_participant.get_current_version(i.subject_of_activity);

             if (v_count = 1) then

               v_obj := osi_activity.create_instance(v_obj_type_sid,
                                                     i.activity_date,
                                                     i.title,
                                                     i.restriction,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     v_Participant_Version,
                                                     v_ParticipantUsage,
                                                     v_ParticipantCode,
                                                     NULL,
                                                     i.file_sid,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     replace(i.wh_pay_cat,'%null%','null'),
                                                     replace(i.wh_duty_cat,'%null%','null'),
                                                     replace(i.wh_mission,'%null%','null'),
                                                     i.wh_date,
                                                     i.wh_hours,
                                                     i.complete,
                                                     i.substantive);
                                                   
                                                              
            end if;
            
            insert into t_osi_a_records_check (activity_date,reference_num,narrative,doc_type,results,obj)
                  values (i.activity_date,i.reference_num,i.narrative,i.doc_type,i.results,v_obj) returning sid into v_sid;
            commit;
            
            select count(*) into v_act_count from t_osi_a_records_check where sid=v_sid;
        
            if (v_act_count > 0) then

              delete from T_OSI_A_RC_DR_MULTI_TEMP where sid=i.sid;

            end if;
            v_count := v_count + 1;
            
         end loop;

         recent_access(v_obj, p_personnelSID);
         return v_obj;
        
    exception
        when others then
            log_error('create_instance error, ' || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
    begin
        --- Get Law Enforcement Records Check Activity record ---
        for a in (select * from t_osi_a_records_check where sid=p_obj)
        loop
            --- Insert a new Document Review Activity record ---
            insert into t_osi_a_records_check (obj, doc_type, reference_num, narrative, activity_date, results) values (p_new_sid, a.doc_type, a.reference_num, a.narrative, a.activity_date, a.results);

        end loop;
        
    exception
        when others then
            log_error('osi_records_check.clone: p_obj = ' || nvl(p_obj, 'null')
                      || ', p_new_sid = ' || nvl(p_new_sid, 'null') || '. Error is: ' || sqlerrm);
            raise;
    end clone;
    
end osi_records_check;
/







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
--   Date and Time:   06:33 Thursday October 18, 2012
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

PROMPT ...Remove page 21505
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>21505);
 
end;
/

 
--application/pages/page_21505
prompt  ...PAGE 21505: Records Check and Document Review Details
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'"JS_BUILDRC_DRNARRATIVEANDTITLE"'||chr(10)||
'"JS_HIDESHOWFIELD"'||chr(10)||
'<script language="javascript">'||chr(10)||
'function showHideFields()'||chr(10)||
'{'||chr(10)||
' pObjTypeCode = $(''#P21505_OBJ_TYPE_CODE'').val();'||chr(10)||
' pDocTypeText = $(''#P21505_TYPE > option:selected'').text();'||chr(10)||
''||chr(10)||
' showField(''P21505_REFERENCE_NUM'', false, false);'||chr(10)||
' hideField(''P21505_EXPLANATION'', false, true);'||chr(10)||
''||chr(10)||
' if(pObjTypeCode==''ACT.DOCUMENT_REVIEW'')'||chr(10)||
'   {'||chr(10)||
'    if(pDocTypeText==''Other'')'||chr(10)||
'    ';

ph:=ph||'  {'||chr(10)||
'       showField(''P21505_EXPLANATION'', false, true);'||chr(10)||
'       hideField(''P21505_REFERENCE_NUM'', false, false);'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 21505,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Records Check and Document Review Details',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="javascript">'||chr(10)||
'$(document).ready(function () '||chr(10)||
'{'||chr(10)||
' showHideFields();'||chr(10)||
'});'||chr(10)||
''||chr(10)||
''||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20121018063348',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-OCT-2010 J.FARIS WCHG0000360 - Enabled date picker.'||chr(10)||
''||chr(10)||
'24-Jul-2012 - Tim Ward - CR#4049 - Allow multiple Checks in one Activity.'||chr(10)||
''||chr(10)||
'02-Aug-2012 - Tim Ward - P0_OBJ Passing in the Page Branches.'||chr(10)||
''||chr(10)||
'11-Sep-2012 - Tim Ward - CR#4049 - Beta Testing found error when updating'||chr(10)||
'                          because pick lists return .'||chr(10)||
''||chr(10)||
'18-Oct-2012 - Tim Ward - CR#4152 - Added Use Date In Narrative Field.');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21505,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21505,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Review Date",'||chr(10)||
'       REFERENCE_NUM as "Reference Number",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Record Type",'||chr(10)||
'       decode(:p21505_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_RECORDS_CHECK'||chr(10)||
'WHERE OBJ=:P21505_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_name=> 'Law Enforcement Records Checks Associated to this Activity',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 40,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21505_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK''',
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
  p_query_no_data_found=> '<b><center>***** No &P21505_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
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
  p_id=> 14971617016394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
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
  p_id=> 14972424256394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 2,
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
  p_id=> 14973029895405378 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Review Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
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
  p_id=> 14973310287409203 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Reference Number',
  p_column_display_sequence=> 5,
  p_column_heading=> '&P21505_NUMBER_LABEL.',
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
  p_id=> 14971910336394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
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
  p_id=> 14972317792394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Record Type',
  p_column_display_sequence=> 4,
  p_column_heading=> '&P21505_TYPE_LABEL.',
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
  p_id=> 14972532547394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 7,
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
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Review Date",'||chr(10)||
'       DOCUMENT_NUMBER as "Document Number",'||chr(10)||
'       EXPLANATION as "Explanation",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Document Type",'||chr(10)||
'       decode(:p21505_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_DOCUMENT_REVIEW'||chr(10)||
'WHERE OBJ=:P21505_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_name=> 'Document Reviews Associated to this Activity',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 30,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
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
  p_query_no_data_found=> '<b><center>***** No &P21505_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
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
  p_id=> 15158527104591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
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
  p_id=> 15158612089591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 2,
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
  p_id=> 15158724174591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Review Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> '&FMT_DATE.',
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
  p_id=> 15159914337609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Document Number',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Document Number',
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
  p_id=> 15160022347609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Explanation',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Explanation',
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
  p_id=> 15158907025591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 7,
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
  p_id=> 15160132539609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Document Type',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Document Type',
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
  p_id=> 15159128236591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 8,
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
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 15255719924339446 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
  p_id=> 92093732891224301 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_plug_name=> '&P21505_OBJ_TYPE_DESCRIPTION. Details',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 50,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P21505_SELECTED IS NOT NULL'||chr(10)||
'OR'||chr(10)||
':REQUEST IN (''ADDNEW'')',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 14993025346725866 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 50,
  p_button_plug_id => 14971424570394387+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADDNEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add New',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15112517566305156 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 70,
  p_button_plug_id => 14971424570394387+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15167023950630994 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 80,
  p_button_plug_id => 15158319616591900+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADDNEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add New',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15167227066631877 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 90,
  p_button_plug_id => 15158319616591900+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 92094015476224306 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 30,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21505_SELECTED IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':REQUEST NOT IN (''ADDNEW'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15104005820178675 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 60,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'ADDNEW',
  p_button_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 92094338215224307 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 10,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>92557208179630251 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 5,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST LIKE ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>92094926113224317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_branch_action=> 'f?p=&APP_ID.:21505:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P21505_OBJ.&success_msg=#SUCCESS_MSG#',
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
  p_id=>14974716399477216 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_id=>14975028650490262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative Text:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 0,
  p_cMaxlength=> 30000,
  p_cHeight=> 15,
  p_cAttributes=> 'style="width:100%"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%" style="height:auto" style="rows:30"',
  p_tag_attributes2=> 'style="width:100%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
  p_field_alignment  => 'LEFT-TOP',
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
  p_id=>14975614368504983 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
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
  p_id=>14992017802629046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21505_RESULT_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21505_RESULT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:buildRC_DRNarrativeandTitle(''P21505_TYPE'',''P21505_RESULT'',''P21505_NARRATIVE'','''',''P21505_OBJ_TYPE_CODE''); showHideFields();"',
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
  p_id=>14992231655633045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_id=>14992503520643836 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_id=>15060718222934705 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_id=>15060925148936716 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_id=>15111311501265521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_id=>15146103902227797 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_id=>15147331653264200 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ_TYPE_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_id=>15149211015343399 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_NUMBER_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_id=>15149720936412471 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_EXPLANATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Explanation',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 1000,
  p_cHeight=> 10,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') = :P21505_TYPE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16853427690736732 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Review Date',
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
  p_id=>17154122583017120 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_USE_DATE_IN_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1.5,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Use Date In Narrative',
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
  p_begin_on_new_line => 'NO',
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
  p_id=>92095130765224317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
  p_begin_on_new_line => 'NO',
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
  p_id=>92095321905224326 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_REFERENCE_NUM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21505_NUMBER_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 100,
  p_cHeight=> 1,
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
  p_id=>92559636884685906 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Record Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21505_TYPE_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 200,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onchange="javascript:buildRC_DRNarrativeandTitle(''P21505_TYPE'',''P21505_RESULT'',''P21505_NARRATIVE'','''',''P21505_OBJ_TYPE_CODE''); showHideFields();"',
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

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 16854312368751275 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'P21505_ACTIVITY_DATE',
  p_validation_sequence=> 1,
  p_validation => 'P21505_ACTIVITY_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Review Date must be specified.',
  p_when_button_pressed=> 92094015476224306 + wwv_flow_api.g_id_offset,
  p_associated_item=> 16853427690736732 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 16854606958759159 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'Valid Date',
  p_validation_sequence=> 5,
  p_validation => 'P21505_ACTIVITY_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Date is invalid.',
  p_validation_condition=> ':p21505_activity_date is not null and :request = ''SAVE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 16853427690736732 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 92594608534406278 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'Document Type not null',
  p_validation_sequence=> 10,
  p_validation => 'P21505_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'A Record Type must be selected from the list.',
  p_when_button_pressed=> 92094015476224306 + wwv_flow_api.g_id_offset,
  p_associated_item=> 92559636884685906 + wwv_flow_api.g_id_offset,
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
p:=p||':P21505_SELECTED:=NULL;'||chr(10)||
':P21505_NARRATIVE:=NULL;'||chr(10)||
':P21505_TYPE:=NULL;'||chr(10)||
':P21505_RESULT:=NULL;'||chr(10)||
':P21505_REFERENCE_NUM:=NULL;'||chr(10)||
':P21505_EXPLANATION:=NULL;'||chr(10)||
':P21505_USE_DATE_IN_NARRATIVE:=''Y'';';

wwv_flow_api.create_page_process(
  p_id     => 15096317201153588 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'ClearSelected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'ADDNEW',
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
p:=p||'begin'||chr(10)||
'     if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'       begin'||chr(10)||
'           for I in 1 .. apex_application.g_f01.count'||chr(10)||
'           loop'||chr(10)||
'               delete from T_OSI_A_RECORDS_CHECK'||chr(10)||
'                     where sid = apex_application.g_f01(I);'||chr(10)||
''||chr(10)||
'               if (apex_application.g_f01(I) = :P21505_SELECTED) then'||chr(10)||
''||chr(10)||
'                 :P21505_SELECTED:=NULL;'||chr(10)||
''||chr(10)||
'               end if;'||chr(10)||
''||chr(10)||
'        ';

p:=p||'   end loop;'||chr(10)||
''||chr(10)||
'       end;'||chr(10)||
''||chr(10)||
'     elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'          begin'||chr(10)||
'              for I in 1 .. apex_application.g_f01.count'||chr(10)||
'              loop'||chr(10)||
'                  delete from T_OSI_A_DOCUMENT_REVIEW'||chr(10)||
'                        where sid = apex_application.g_f01(I);'||chr(10)||
''||chr(10)||
'                  if (apex_application.g_f01(I) = :P21505_SELECTED) then'||chr(10)||
''||chr(10)||
'                    :P21505_';

p:=p||'SELECTED:=NULL;'||chr(10)||
''||chr(10)||
'                  end if;'||chr(10)||
''||chr(10)||
'              end loop;'||chr(10)||
''||chr(10)||
'          end;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     commit;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14973915743429703 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Remove Selected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>15112517566305156 + wwv_flow_api.g_id_offset,
  p_process_when=>'REMOVE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     insert into t_osi_a_records_check (activity_date,reference_num,narrative,doc_type,results,obj,use_date_in_narrative) values'||chr(10)||
'           (:P21505_ACTIVITY_DATE,'||chr(10)||
'           :P21505_REFERENCE_NUM,'||chr(10)||
'           :P21505_NARRATIVE,'||chr(10)||
'           REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'           REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'          ';

p:=p||' :P21505_OBJ,'||chr(10)||
'           decode(:P21505_USE_DATE_IN_NARRATIVE,NULL,''N'',''Y'')) '||chr(10)||
'     returning sid into :P21505_SELECTED;'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'         insert into t_osi_a_document_review (activity_date,document_number,narrative,doc_type,results,obj,explanation,use_date_in_narrative) values'||chr(10)||
'               (:P21505_ACTIVITY_DATE,'||chr(10)||
'               :P21505_REFERENCE';

p:=p||'_NUM,'||chr(10)||
'               :P21505_NARRATIVE,'||chr(10)||
'               REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'               REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'               :P21505_OBJ,'||chr(10)||
'               :P21505_EXPLANATION,'||chr(10)||
'               decode(:P21505_USE_DATE_IN_NARRATIVE,NULL,''N'',''Y'')) '||chr(10)||
'        returning sid into :P21505_SELECTED;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   commit;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14974121284431269 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Check To List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>15104005820178675 + wwv_flow_api.g_id_offset,
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     update t_osi_a_records_check set'||chr(10)||
'           reference_num=:p21505_reference_num,'||chr(10)||
'           doc_type=REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'           narrative=:p21505_narrative,'||chr(10)||
'           activity_date=:p21505_activity_date,'||chr(10)||
'           results=REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'           use_date_in_narrative=decode(:P21505';

p:=p||'_USE_DATE_IN_NARRATIVE,NULL,''N'',''Y'')'||chr(10)||
'      where SID=:p21505_selected;'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'        update t_osi_a_document_review set'||chr(10)||
'              document_number=:p21505_reference_num,'||chr(10)||
'              doc_type=REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'              narrative=:p21505_narrative,'||chr(10)||
'              activity_date=:p21505_activity_date,'||chr(10)||
'              resul';

p:=p||'ts=REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'              explanation=:p21505_explanation,'||chr(10)||
'              use_date_in_narrative=decode(:P21505_USE_DATE_IN_NARRATIVE,NULL,''N'',''Y'')'||chr(10)||
'         where SID=:p21505_selected;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   commit;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 16853728167746410 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>92094015476224306 + wwv_flow_api.g_id_offset,
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     SELECT SID,'||chr(10)||
'            to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'            REFERENCE_NUM,'||chr(10)||
'            NARRATIVE,'||chr(10)||
'            DOC_TYPE,'||chr(10)||
'            RESULTS,'||chr(10)||
'            DECODE(USE_DATE_IN_NARRATIVE,''N'',NULL,USE_DATE_IN_NARRATIVE)'||chr(10)||
''||chr(10)||
'        INTO'||chr(10)||
'            :P21505_SELECTED,'||chr(10)||
'            :P21505_ACTIVITY_DATE,'||chr(10)||
'       ';

p:=p||'     :P21505_REFERENCE_NUM,'||chr(10)||
'            :P21505_NARRATIVE,'||chr(10)||
'            :P21505_TYPE,'||chr(10)||
'            :P21505_RESULT,'||chr(10)||
'            :P21505_USE_DATE_IN_NARRATIVE'||chr(10)||
'        FROM T_OSI_A_RECORDS_CHECK WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'        SELECT SID,'||chr(10)||
'               to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'               DOCUM';

p:=p||'ENT_NUMBER,'||chr(10)||
'               NARRATIVE,'||chr(10)||
'               DOC_TYPE,'||chr(10)||
'               RESULTS,'||chr(10)||
'               EXPLANATION,'||chr(10)||
'               DECODE(USE_DATE_IN_NARRATIVE,''N'',NULL,USE_DATE_IN_NARRATIVE)'||chr(10)||
'           INTO'||chr(10)||
'               :P21505_SELECTED,'||chr(10)||
'               :P21505_ACTIVITY_DATE,'||chr(10)||
'               :P21505_REFERENCE_NUM,'||chr(10)||
'               :P21505_NARRATIVE,'||chr(10)||
'               :P21505_TYPE,'||chr(10)||
'               :P2150';

p:=p||'5_RESULT,'||chr(10)||
'               :P21505_EXPLANATION,'||chr(10)||
'               :P21505_USE_DATE_IN_NARRATIVE'||chr(10)||
'           FROM T_OSI_A_DOCUMENT_REVIEW WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14973710549428221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Check in List',
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
p:=p||'P21505_SELECTED';

wwv_flow_api.create_page_process(
  p_id     => 15610323737847566 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Cancel',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>92094338215224307 + wwv_flow_api.g_id_offset,
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
'  :P21505_obj := :p0_obj;'||chr(10)||
'  :P21505_OBJ_TYPE_CODE := :P0_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
'  select t.description into :P21505_OBJ_TYPE_DESCRIPTION  '||chr(10)||
'    from t_core_obj_type t where t.code=:P21505_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
'  IF (:P21505_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK'') THEN'||chr(10)||
''||chr(10)||
'    :P21505_TYPE_LABEL := ''Records Check Type'';'||chr(10)||
'    :P21505_TYPE_LOV := ''- Select Record Type -;%null%,'' || osi_reference.get_lov(''LERC_DOCTYPE';

p:=p||''');'||chr(10)||
'    :P21505_RESULT_LABEL := ''Records Check Result'';'||chr(10)||
'    :P21505_NUMBER_LABEL := ''Reference Number'';'||chr(10)||
''||chr(10)||
'  ELSIF (:P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW'') THEN'||chr(10)||
''||chr(10)||
'       :P21505_TYPE_LABEL := ''Document Type'';'||chr(10)||
'       :P21505_TYPE_LOV := ''- Select Document Type -;%null%,'' || osi_reference.get_lov(''DOCREV_DOCTYPE'');'||chr(10)||
'       :P21505_RESULT_LABEL := ''Document Review Result'';'||chr(10)||
'       :P21505_NUMBER_LABE';

p:=p||'L := ''Document Number'';'||chr(10)||
''||chr(10)||
'  END IF;'||chr(10)||
''||chr(10)||
'  if :P21505_RESULT is null then'||chr(10)||
''||chr(10)||
'    :P21505_RESULT_LOV:=''- Select -;%null%,'';'||chr(10)||
'    for a in (select DESCRIPTION d, CODE r from T_OSI_A_RC_DR_RESULTS order by 1)'||chr(10)||
'    loop'||chr(10)||
'        :P21505_RESULT_LOV := :P21505_RESULT_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 92558037877657803 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'p21505_obj',
  p_process_when_type=>'ITEM_IS_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 21505
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

