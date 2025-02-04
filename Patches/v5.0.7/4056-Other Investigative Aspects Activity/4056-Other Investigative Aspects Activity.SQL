/****************************************************************************************/
/****************************************************************************************/
/*4056-Other Investigative Aspects Activity*/
/****************************************************************************************/
/****************************************************************************************/


UPDATE T_OSI_MENU SET LAST_CHILD='N' WHERE ID='ID_AV_SUPPORT';
COMMIT;

INSERT INTO T_OSI_MENU ( ID, DESCRIPTION, COMMAND, PARENT_ID, ICON, SEQ, ACTIVE, LAST_CHILD, DOUBLE_CLOSE ) VALUES ( 'ID_OTHER_INV_ASPECTS', 'Other Investigative Aspects', 'javascript:createActivityObject(21001,''ACT.OTHER.INV.ASPECTS'');', 'ID_ACTIVITY', '/i/themes/OSI/OtherInvAspects.gif', 27.1, 'Y', 'Y', 'N'); 
COMMIT;



INSERT INTO T_CORE_OBJ_TYPE ( SID, CODE, DESCRIPTION, METHOD_PKG, HAS_OWNING_UNIT, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, IMAGE, INHERIT_PRIVS_FROM_PARENT ) VALUES ( '33318QCZ', 'ACT.OTHER.INV.ASPECTS', 'Other Investigative Aspects', 'OSI_OTHER_INV_ASPECTS', 'Y', 'timothy.ward',  TO_Date( '06/06/2012 08:35:25 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/06/2012 08:57:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'OtherInvAspects.gif', 'Y');
COMMIT;



INSERT INTO T_OSI_OBJ_TYPE ( SID, STARTING_STATUS, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PARENT, INCLUDE_STATUS_MENU, INCLUDE_CHECKLIST_MENU, DEFAULT_TITLE ) VALUES ( '33318QCZ', '222000005IY', 'timothy.ward',  TO_Date( '06/06/2012 09:06:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/06/2012 09:06:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), '2220000083O', 'Y', 'Y', 'Other Investigative Aspects'); 
COMMIT;


INSERT INTO T_CORE_ACL ( SID, OBJ_TYPE, ACL_NAME, RESTRICT_SEE, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33318QD0', '33318QCZ', 'Default', 'N', 1, 'timothy.ward',  TO_Date( '06/06/2012 09:10:43 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/06/2012 09:10:43 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;


INSERT INTO T_CORE_DT_OBJ_TYPE_PAGE ( SID, OBJ_TYPE, PAGE_FUNCTION, PAGE_NUM, REQUEST, DISPLAY_HTML, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, URL_SUFFIX, OTHER_ITEMS, OTHER_VALUES ) VALUES ( '33318QDA', '33318QCZ', 'OPEN', 20000, NULL, NULL, 'timothy.ward',  TO_Date( '06/06/2012 10:00:12 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/06/2012 10:00:12 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, NULL, NULL); 
COMMIT;



INSERT INTO T_OSI_TAB ( SID, OBJ_TYPE, TAB_LEVEL, PARENT_TAB, SEQ, TAB_LABEL, PAGE_NUM, IS_DEFAULT, TAB_PARAMS, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ACTIVE, AUTH_ACTION, OVERRIDE ) VALUES ( '33318QD6', '33318QCZ', 1, NULL, 15, 'Details', NULL, 'N', NULL, 'timothy.ward',  TO_Date( '06/06/2012 09:31:29 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/06/2012 09:31:29 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Y', NULL, 'N'); 
INSERT INTO T_OSI_TAB ( SID, OBJ_TYPE, TAB_LEVEL, PARENT_TAB, SEQ, TAB_LABEL, PAGE_NUM, IS_DEFAULT, TAB_PARAMS, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ACTIVE, AUTH_ACTION, OVERRIDE ) VALUES ( '33318QD7', '33318QCZ', 2, '33318QD6', 15, 'General Info', 22905, 'Y', NULL, 'timothy.ward',  TO_Date( '06/06/2012 09:32:09 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/06/2012 10:13:05 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Y', NULL, 'N'); 
INSERT INTO T_OSI_TAB ( SID, OBJ_TYPE, TAB_LEVEL, PARENT_TAB, SEQ, TAB_LABEL, PAGE_NUM, IS_DEFAULT, TAB_PARAMS, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ACTIVE, AUTH_ACTION, OVERRIDE ) VALUES ( '33318QD8', '33318QCZ', 2, '33318QD6', 20, 'Participants', 5300, 'N', 'PARTICIPANTS', 'timothy.ward',  TO_Date( '06/06/2012 09:32:39 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '06/06/2012 10:13:04 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Y', NULL, 'N'); 
COMMIT;




-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE           "OSI_OTHER_INV_ASPECTS" as
/*************************************************************************************
   Name:     osi_other_inv_aspects
   Purpose:  Provides Functionality For Other Investigative Aspects Activity Objects.

   Revisions:
    Date         Author          Description
    -----------  --------------  ----------------------------------------------
    06-Jun-2012  Tim Ward        CR#4056 - Created Package from OSI_EXCEPTION.

*************************************************************************************/

    /* Given a sid (p_obj), this function returns a default tagline.  Currently using the default activity tagline */
    function get_tagline(p_obj in varchar2) return varchar2;

    /* Given a sid (p_obj), returns a summary.  Can pass a variant in p_variant to affect the format of the results (i.e. HTML) Currently using the default activity summary */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null) return clob;

    /* Given a sid (p_obj) and a reference to a clob, will fill in the clob with xml data to be used for the doc1 index Currently using the default activity index1 */
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given a sid (p_obj), will return the current status of the Other Investigative Aspects Activity. Currently using the default activity status */
    function get_status(p_obj in varchar2) return varchar2;

    /* This function creates a new Other Investigative Aspects Activity instance and returns the new sid */
    function create_instance(p_title in varchar2, p_explanation in varchar2, p_act_date in date, p_restriction in varchar2, p_narrative in clob, p_participant in varchar2 := '', p_participant_role in varchar2 := '') return varchar2;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2);

end osi_OTHER_INV_ASPECTS;
/

CREATE OR REPLACE PACKAGE BODY           "OSI_OTHER_INV_ASPECTS" as
/*************************************************************************************
   Name:     osi_other_inv_aspects
   Purpose:  Provides Functionality For Other Investigative Aspects Activity Objects.

   Revisions:
    Date         Author          Description
    -----------  --------------  ----------------------------------------------
    06-Jun-2012  Tim Ward        CR#4056 - Created Package from OSI_EXCEPTION.

*************************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_OTHER_INV_ASPECTS';

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
            log_error('get_summary: p_obj = ' || nvl(p_obj, 'null') || ', p_variant = ' || nvl(p_variant, 'null') || '. Error is: ' || sqlerrm);
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

    -- the create_instance function is not being used by the application for the Other Investigative Aspects Activity
    -- the osi_activity.create_instance is being used with a general activity create page
    function create_instance(
        p_title              in   varchar2,
        p_explanation        in   varchar2,
        p_act_date           in   date,
        p_restriction        in   varchar2,
        p_narrative          in   clob,
        p_participant        in   varchar2 := '',
        p_participant_role   in   varchar2 := '')
        return varchar2 is
        v_sid                t_core_obj.sid%type;
        v_participant_role   varchar2(20);
    begin
        v_sid :=
            osi_activity.create_instance(core_obj.lookup_objtype('ACT.OTHER.INV.ASPECTS'),
--                                         null,
                                         p_act_date,
                                         p_title,
                                         p_restriction,
                                         p_narrative);

        --        insert into t_osi_a_OTHER_INV_ASPECTS
        --                    (sid, explanation, activity_date)
        --             values (v_sid, p_explanation, p_act_date);
        if p_participant is not null then
            begin
                if p_participant_role is not null then
                    v_participant_role := p_participant_role;
                else
                    select sid
                      into v_participant_role
                      from t_osi_partic_role_type
                     where usage = 'PARTICIPANTS'
                       and obj_type = core_obj.lookup_objtype('ACT.OTHER.INV.ASPECTS')
                       and upper(role) = 'OTHER PARTICIPANT';
                end if;

                insert into t_osi_partic_involvement i
                            (obj, participant_version, involvement_role)
                     values (v_sid, p_participant, v_participant_role);
            exception
                when others then
                    log_error
                        ('create_instance: error attempting insert into t_osi_partic_involvement. v_sid = '
                         || v_sid || ', p_participant = ' || nvl(p_participant, 'null')
                         || ', p_participant_role = ' || nvl(p_participant_role, 'null'));
            end;
        end if;

        core_obj.bump(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: p_title = ' || nvl(p_title, 'null') || ', p_explanation = '
                      || nvl(p_explanation, 'null') || ', p_act_date = '
                      || to_char(nvl(p_act_date,
                                     to_date('01-JAN-1900 00:00', 'DD-MON-YYYY HH24:MI')),
                                 'DD-MON-YYYY HH24:MI')
                      || ', p_restriction = ' || nvl(p_restriction, 'null') || '. Error is: '
                      || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_other_inv_aspects_rec t_osi_activity%rowtype;
    begin
        -- NO ADDITIONAL PROCESSING IS NEEDED FOR THE Other Investigative Aspects Activity. EVERYTHING THAT NEEDS
        -- TO BE DONE IS DONE IN THE OSI_STATUS_PROC PACKAGE.
        --Get Exception Activity record just to record the exception if it does not exist
        select *
          into v_other_inv_aspects_rec
          from t_osi_activity
         where sid = p_obj;
    exception
        when others then
            log_error('osi_v_other_inv_aspects_rec.clone: p_obj = ' || nvl(p_obj, 'null') || ', p_new_sid = '
                      || nvl(p_new_sid, 'null') || '. Error is: ' || sqlerrm);
            raise;
    end clone;
end osi_OTHER_INV_ASPECTS;
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
--   Date and Time:   11:07 Wednesday June 6, 2012
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

PROMPT ...Remove page 22905
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>22905);
 
end;
/

 
--application/pages/page_22905
prompt  ...PAGE 22905: Other Investigative Aspects (General)
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 22905,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Other Investigative Aspects (General)',
  p_step_title=> 'Other Investigative Aspects (General)',
  p_step_sub_title => 'Other Investigative Aspects (General)',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120606100657',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
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
  p_id=> 14587500053988554 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22905,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
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
  p_id=> 14587725756988556 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 22905,
  p_plug_name=> 'General Info',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 14587915786988556 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 22905,
  p_button_sequence=> 50,
  p_button_plug_id => 14587725756988556+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 14588113125988559 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 22905,
  p_button_sequence=> 60,
  p_button_plug_id => 14587725756988556+wwv_flow_api.g_id_offset,
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
  p_id=>14589628280988568 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22905,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>14589821981988571 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22905,
  p_branch_action=> 'f?p=&APP_ID.:22905:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14588314345988559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22905,
  p_name=>'P22905_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 14587500053988554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P22905_SID=',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>14588532412988560 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 22905,
  p_name=>'P22905_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 14587725756988556+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Activity Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'select to_char(activity_date, ''&FMT_DATE.'') from t_osi_activity where sid = :p0_obj',
  p_source_type=> 'QUERY',
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

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 14588811443988562 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 22905,
  p_validation_name => 'P22905_ACTIVITY_DATE is not null',
  p_validation_sequence=> 10,
  p_validation => 'P22905_ACTIVITY_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Activity Date must be specified.',
  p_when_button_pressed=> 14587915786988556 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 14589032620988565 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 22905,
  p_validation_name => 'Valid Date',
  p_validation_sequence=> 20,
  p_validation => 'P22905_ACTIVITY_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':request = ''SAVE'' and :p22905_activity_date is not null',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
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
p:=p||'begin'||chr(10)||
'   update t_osi_activity'||chr(10)||
'      set activity_date = :p22905_activity_date'||chr(10)||
'    where SID = :p0_obj;'||chr(10)||
'   commit;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14589104245988566 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 22905,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Activity Date',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>14587915786988556 + wwv_flow_api.g_id_offset,
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
''||chr(10)||
'    :p22905_sid := :p0_obj;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14589300395988566 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 22905,
  p_process_sequence=> 1,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Preload items',
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
-- ...updatable report columns for page 22905
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

