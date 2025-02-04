INSERT INTO T_CORE_TEMPLATE ( SID, TEMPLATE_NAME, TEMPLATE_INFO, MIME_TYPE, MIME_DISPOSITION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33319C2S', 'FORM_40_DRAFT', NULL, NULL, 'ATTACHMENT', 'timothy.ward',  TO_Date( '10/17/2012 10:19:08 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/17/2012 10:19:20 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

INSERT INTO T_OSI_REPORT_TYPE ( SID, OBJ_TYPE, DESCRIPTION, PICK_DATES, PICK_NARRATIVES, PICK_NOTES, PICK_CAVEATS, PICK_DISTS, PICK_CLASSIFICATION, PICK_ATTACHMENT, PICK_PURPOSE, PICK_DISTRIBUTION, PICK_IGCODE, PICK_STATUS, SPECIAL_PROCESSING, ACTIVE, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PACKAGE_FUNCTION, DISABLED_STATUS, MIME_TYPE, IMAGE ) VALUES ( '33319C2T', '2220000083O', 'Form 40 Draft', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', NULL, 'Y', NULL, 'timothy.ward',  TO_Date( '10/17/2012 10:22:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '10/17/2012 10:22:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'OSI_ACTIVITY.GENERATE_FORM_40_DRAFT', NULL, '22200000P36', NULL); 
COMMIT;

-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_activity as
/******************************************************************************
   Name:     Osi_Activity
   Purpose:  Provides Functionality For Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     7-Apr-2009 T.McGuffin      Created Package
    27-May-2009 T.McGuffin      Added Create_Instance function.
    01-Jun-2009 T.McGuffin      Added Get_ID function.
    04-Jun-2009 T.McGuffin      Added Get_Inv_Support function and Set_Inv_Support procedure.
    16-Jun-2009 T.McGuffin      Removed subtype from Create Instance.
    30-Jun-2009 T.McGuffin      Phased out CORE ACL for simple Restriction.
    06-Jul-2009 R.Dibble        Added get_activity_date
    15-Oct-2009 J.Faris         Added can_delete
    28-Oct-2009 R.Dibble        Added generate_form_40
    22-Dec-2009 T.Whitehead     Added get_source.
    23-Dec-2009 T.Whitehead     Added get_title.
    30-Dec-2009 T.Whitehead     Added get_file.
     13-Jan-2009 T.McGuffin     Added check_writability function.
    25-May-2010 T.Leighty       Added make_doc_act
    25-Jun-2010 T.McGuffin      Added get_oldest_file
     5-Aug-2010  J.Faris        Added generate_form_40_summary.
    30-Apr-2012 Tim Ward        CR#4043 - Changed parameters to create_instance.
                                 All Activities now call this for creation.
    09-May-2012 Tim Ward        CR#4045 - Added substantive parameter create_instance.
    17-Oct-2012 Tim Ward        CR#4151 - Form 40 Draft.
                                 New Function generate_form_40_draft.
                                 Added pDraft parameter to generate_form_40.
******************************************************************************/

    /* Get the earliest associated file sid. */
    function get_file(p_obj in varchar2)
        return varchar2;

    /* Given an activity sid as p_obj, returns a default activity tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given and activity sid as p_obj, returns the ID of the activity */
    function get_id(p_obj in varchar2)
        return varchar2;

    function get_title(p_obj in varchar2)
        return varchar2;

    function get_source(p_obj in varchar2)
        return varchar2;

    /* Given an activity sid as p_obj, return a summary.  Can pass a variant
       in p_variant to affect the format of the results (i.e. HTML) */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    /* Given an activity sid as p_obj and a reference to a clob, will fill in
       the clob with xml data to be used for the doc1 index */
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given an activity sid as p_obj, will return the current status of the activity */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* This function creates a new activity instance and returns the new sid.
       Handles t_core_obj, t_osi_activity, starting status, unit assignments, and lead assignment */
    function create_instance(p_obj_type_sid in varchar2,
                             p_act_date in date,
                             p_title in varchar2,
                             p_restriction in varchar2,
                             p_narrative in clob,
                             p_FieldNames in clob:=null,
                             p_FieldValues in clob:=null,
                             p_ParticipantVersion in varchar2:=null,
                             p_ParticipantUsage in varchar2:=null,
                             p_ParticipantCode in varchar2:=null,
                             p_TableName in varchar2:=null,
                             p_FileToAssociate in varchar2:=null,
                             p_AddressUsage in varchar2:=null,
                             p_AddressCode in varchar2:=null,
                             p_AddressValue in varchar2:=null,
                             p_ObjectiveParent in varchar2:=null,
                             p_Pay_Cat in varchar2:=null,
                             p_Duty_Cat in varchar2:=null, 
                             p_Mission in varchar2:=null, 
                             p_Work_Date in date:=null, 
                             p_Hours in varchar2:=null,
                             p_Complete in varchar2:=null,
                             p_Substantive in varchar2:='N') return varchar2;

    /* Given an object sid for an activity, will return an apex-friendly colon-delimited
       list of mission sids that support the activity */
    function get_inv_support(p_obj in varchar2)
        return varchar2;

    /* Given an object sid for an activity and a colon-delimited list of mission sids,
       will synch the list with t_osi_mission for that object (activity) */
    procedure set_inv_support(p_obj in varchar2, p_inv_support in varchar2);

    /*Returns the activity date for the current activity*/
    function get_activity_date(p_obj in varchar2)
        return date;

    /*Given an object sid for an activity, will return a custom error message if the object
      is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2)
        return varchar2;

    /* Used to generate Form 40 Reports */
    function generate_form_40(p_obj in varchar2, pDraft in varchar2 := 'N')
        return clob;

    function generate_form_40_draft(p_obj in varchar2)
        return clob;

    /* Used to generate Form 40 Summary Reports */
    function generate_form_40_summary(p_obj in varchar2)
        return clob;

    /* Usually will be called by osi_object.check_writability, this function returns Y or N
       indicating whether the object is editable or not */
    function check_writability(p_obj in varchar2)
        return varchar2;

    /* Following routines create activity object type specific documents for reporting purposes. */
    procedure make_doc_act(p_sid in varchar2, p_doc in out nocopy clob);

    /* used to get the first file associated to a given activity.  implies some sort of ownership */
    function get_oldest_file(p_obj in varchar2)
        return varchar2;
end osi_activity;
/


CREATE OR REPLACE package body osi_activity as
/******************************************************************************
   Name:     Osi_Activity
   Purpose:  Provides Functionality For Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     7-Apr-2009 T.McGuffin      Created Package.
    28-Apr-2009 T.McGuffin      Modified Get_Tagline To Only Return Title.
    27-May-2009 T.McGuffin      Added Create_Instance function.
    01-Jun-2009 T.McGuffin      Added Get_ID function.
    04-Jun-2009 T.McGuffin      Added Get_Inv_Support function and Set_Inv_Support procedure.
    16-Jun-2009 T.McGuffin      Removed subtype from Create Instance.
    30-Jun-2009 T.McGuffin      Phased out CORE ACL for simple Restriction.
    06-Jul-2009 R.Dibble        Added get_activity_date
    15-Oct-2009 J.Faris         Added can_delete.
    28-Oct-2009 R.Dibble        Added generate_form_40
    16-Nov-2009 R.Dibble        Added get_title
    02-Dec-2009 R.Dibble        Modified generate_form_40 to utilize CORE_TEMPLATE procedure calls
    09-Dec-2009 T.McGuffin      Modified get_f40_place for the briefing activity.
    23-Dec-2009 T.Whitehead     Added get_source.
    30-Dec-2009 T.Whitehead     Added get_file.
    10-Feb-2010 T.McGuffin      Added check_writability function.
    10-Feb-2010 T.McGuffin      Modified can_delete to include cfunds expenses.
    26-Feb-2010 T.McGuffin      Modified generate_form_40 to remove get_activity_lead function to
                                replace the call with osi_object.get_lead_agent.
     4-Apr-2010 J.Faris         Updated check_writability to accommodate object type specific rules.
     9-Apr-2010 J.Faris         Added Susp Act specific privilege check of 'SAR.EDIT' to can_delete.
    25-May-2010 T.Leighty       Added make_doc_act
    25-Jun-2010 T.McGuffin      Added get_oldest_file
     5-Aug-2010 J.Faris         Added generate_form_40_summary.
    18-Mar-2011 Tim Ward        CR#3731 - Privilege needs to be checked in here now since the
                                 checkForPriv from i2ms.js deleteObj function.
                                 Fixed the Pending check for deletion with workhours.
                                 Changed for loops to select count(*).
                                 Changed in can_delete.
    24-Jan-2012 Tim Ward        CR#3959 - Form 40 Report fails when there is no lead agent.
                                 Changed generate_form_40 and generate_form_40_summary.
                                 Pulled get_f40_place from both generate_form_40 functions so it
                                 is only in one place.
    30-Apr-2012 Tim Ward        CR#4043 - Changed parameters to create_instance.
                                 All Activities now call this for creation.
    09-May-2012 Tim Ward        CR#4045 - Added substantive parameter create_instance.
    17-Jul-2012 Tim Ward        CR#4048 - Interview Form 40 Changes.
                                 Changed in generate_form_40 and get_attachment_list.
    24-Jul-2012 Tim Ward        CR#4049 - Law Enforcement Records Check Form 40 Changes.
                                 Changed in generate_form_40.
    30-Jul-2012 Tim Ward        CR#4050 - Law Enforcement Records Check Form 40 Changes.
                                 Changed in generate_form_40.
    14-Aug-2012 Tim Ward        CR#4054 - Added a check for Leadership approval before 
                                 generating the Form 40.
                                 Changed in generate_form_40.
    03-Oct-2012 Tim Ward        CR#4054 - Get rid of the last ';' in the attachment list.
                                 Changed in generate_form_40.                                 
    03-Oct-2012 Tim Ward        CR#4054 - Since Leadership approved is being hidden for 
                                 ACT.CONSULTATION, make sure it defaults to 'Y'.
                                 Changed in create_instance.
    04-Oct-2012 Tim Ward        CR#4054 - ALL FORM 40's need to show Case file and new
                                 stuff that I only included in Interviews, Document Reviews,
                                 and Record Checks.  Also only show Participant Information
                                 for activities that have participants, for the others
                                 show the title instead.
                                 Changed in generate_form_40.                                 
    17-Oct-2012 Tim Ward        CR#4151 - Form 40 Draft.
                                 New Function generate_form_40_draft.
                                 Added pDraft parameter to generate_form_40.
                                 Changed in generate_form_40.
******************************************************************************/
    c_pipe        varchar2(100)  := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_ACTIVITY';
    v_syn_error   varchar2(4000) := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_file(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select   file_sid
                      from t_osi_assoc_fle_act
                     where activity_sid = p_obj
                  order by create_on asc)
        loop
            return x.file_sid;
        end loop;

        return null;
    exception
        when others then
            log_error('get_file: ' || sqlerrm);
            return null;
    end get_file;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_activity.title%type;
    begin
        select title
          into v_title
          from t_osi_activity
         where SID = p_obj;

        return v_title;
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_id(p_obj in varchar2)
        return varchar2 is
        v_id   t_osi_activity.id%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select id
          into v_id
          from t_osi_activity
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;

    /* Given and activity sid as p_obj, returns the title of the activity */
    function get_title(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_activity.id%type;
    begin
        if p_obj is null then
            log_error('get_title: null value passed');
            return null;
        end if;

        select title
          into v_title
          from t_osi_activity
         where SID = p_obj;

        return v_title;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_title: ' || sqlerrm);
    end get_title;

    function get_source(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select source
                    from t_osi_activity
                   where SID = p_obj)
        loop
            return x.source;
        end loop;

        return null;
    exception
        when others then
            log_error('get_source: ' || sqlerrm);
            return null;
    end get_source;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return 'Activity Summary';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'Activity Index1 XML Clob';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_object.get_status(p_obj);
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function create_instance(p_obj_type_sid in varchar2,p_act_date in date,p_title in varchar2,p_restriction in varchar2,p_narrative in clob,p_FieldNames in clob:=null,p_FieldValues in clob:=null,p_ParticipantVersion in varchar2:=null,p_ParticipantUsage in varchar2:=null,p_ParticipantCode in varchar2:=null,p_TableName in varchar2:=null,p_FileToAssociate in varchar2:=null,p_AddressUsage in varchar2:=null,p_AddressCode in varchar2:=null,p_AddressValue in varchar2:=null,p_ObjectiveParent in varchar2:=null,p_Pay_Cat in varchar2:=null,p_Duty_Cat in varchar2:=null,p_Mission in varchar2:=null,p_Work_Date in date:=null,p_Hours in varchar2:=null,p_Complete in varchar2:=null,p_Substantive in varchar2:='N') return varchar2 is

         v_sid                  t_core_obj.SID%type;
         v_obj_type_code        t_core_obj_type.CODE%type;
         v_insert_string        varchar2(32000);
         v_source               t_core_obj.SID%type;
         v_ParticipantVersion   t_core_obj.SID%type;
         v_InvolvementRole      t_core_obj.SID%type;
         v_complete_status_sid  t_core_obj.SID%type;
         stime                  number;
         v_UnitSID              t_core_obj.SID%type:=osi_personnel.get_current_unit(core_context.personnel_sid);
         
    begin
         log_error('<<< create_instance(' || p_obj_type_sid || ',' || p_act_date || ',' || p_title || ',' || p_restriction || ',' || p_narrative || ',' || p_FieldNames || ',' || p_FieldValues || ',' || p_ParticipantVersion || ',' || p_ParticipantUsage || ',' || p_ParticipantCode || ',' || p_TableName || ',' || p_FileToAssociate || ',' || p_AddressUsage || ',' || p_AddressCode || ',' || p_AddressValue || ',' || p_ObjectiveParent || ',' || p_Pay_Cat || ',' || p_Duty_Cat  || ',' || p_Mission || ',' || p_Work_Date || ',' || p_Hours || ',' || p_Complete || ')');

         -------------------------------------------------
         --- Get Object Type Code from Object Type SID ---
         -------------------------------------------------
         select code into v_obj_type_code from t_core_obj_type where sid=p_obj_type_sid;
         
         ---------------------------------
         --- Insert Core Object Record ---
         ---------------------------------
         insert into t_core_obj (obj_type) values (p_obj_type_sid) returning SID into v_sid;

         --------------------------------------------------------------
         --- If Source Meet, Participant is Source, not Participant ---
         --------------------------------------------------------------
         if v_obj_type_code='ACT.SOURCE_MEET' then
           
           v_source := p_ParticipantVersion;
           v_ParticipantVersion := NULL;
         
         else
           
           v_ParticipantVersion := p_ParticipantVersion;
           
         end if;
         
         ------------------------------
         --- Insert Activity Record ---
         ------------------------------
         if (v_obj_type_code like 'ACT.CONSULTATION%') then

           insert into t_osi_activity (sid,id,title,creating_unit,assigned_unit,activity_date,narrative,restriction,source,substantive,leadership_approved)
               values (v_sid,osi_object.get_next_id,p_title,osi_personnel.get_current_unit(core_context.personnel_sid),v_UnitSID,p_act_date,p_narrative,p_restriction,v_source,p_Substantive,'Y');

         else

           insert into t_osi_activity (sid,id,title,creating_unit,assigned_unit,activity_date,narrative,restriction,source,substantive)
               values (v_sid,osi_object.get_next_id,p_title,osi_personnel.get_current_unit(core_context.personnel_sid),v_UnitSID,p_act_date,p_narrative,p_restriction,v_source,p_Substantive);

         end if;
         
         ---------------------------------------------------------
         --- Insert into Activity Specific Table, if passed in ---
         ---------------------------------------------------------
         if p_TableName is not null then 
  
           v_insert_string := 'insert into ' || p_TableName || ' (';
           if p_FieldNames is null or p_FieldValues is null then

             v_insert_string := v_insert_string || 'sid) values (''' || v_sid || ''')';

           else

             v_insert_string := v_insert_string || p_FieldNames || ') values (' || replace(replace(p_FieldValues,'~^~P0_OBJ~^~',v_sid),'~^~UNIT~^~',v_UnitSID) || ')';

           end if;
           
           v_insert_string:=replace(replace(v_insert_string,'''' || 'null' || '''','Null'),'''' || '%null%' || '''','Null');
           log_error(v_insert_string);
           execute immediate v_insert_string;
           
         end if;

         --------------------------
         --- Handle Participant ---
         --------------------------
         if v_ParticipantVersion is not null then
          
           begin
                select sid into v_InvolvementRole from t_osi_partic_role_type where obj_type=p_obj_type_sid and code=p_ParticipantCode and usage=p_ParticipantUsage;
               
           exception when others then

                    null;

           end;
          
           if v_InvolvementRole is null then
  
             begin 
                  select sid into v_InvolvementRole from t_osi_partic_role_type where obj_type member of osi_object.get_objtypes(p_obj_type_sid) and code=p_ParticipantCode and usage=p_ParticipantUsage;
               
             exception when others then

                      null;

             end;
 
           end if;
          
           insert into t_osi_partic_involvement i (obj, participant_version, involvement_role) values (v_sid,v_ParticipantVersion,v_InvolvementRole);

         end if;

         -------------------------------
         --- Handle File Association ---
         -------------------------------
         if p_FileToAssociate is not null then
 
           insert into T_OSI_ASSOC_FLE_ACT (ACTIVITY_SID, FILE_SID) values (v_sid, p_FileToAssociate);
                                                
         end if;

         ------------------------------------------------------------------------------
         --- Handle Associate activity to objective (Agent Applicant Activity ONLY) ---
         ------------------------------------------------------------------------------
         if p_ObjectiveParent is not null then

           insert into t_osi_f_aapp_file_obj_act (objective, obj) values (p_ObjectiveParent, v_sid);

         end if;
        
         ----------------------------
         --- Handle Address Field ---
         ----------------------------
         if p_AddressUsage is not null and p_AddressCode is not null and p_AddressValue is not null then

           osi_address.insert_address(v_sid,osi_address.get_addr_type(p_obj_type_sid,p_AddressUsage,p_AddressCode),p_AddressValue);
          
         end if;
        
         ----------------------------------
         --- Create the Lead Assignment ---
         ----------------------------------
         osi_object.create_lead_assignment(v_sid);

         -------------------------------
         --- Set the starting status ---
         -------------------------------
         osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type_sid), 'Created');
         core_obj.bump(v_sid);

         -----------------------------------------------------------
         --- Handle Workhours if all required fields are present ---
         -----------------------------------------------------------
         if p_pay_cat is not null and p_duty_cat is not null and p_work_date is not null and p_hours is not null then

           insert into t_osi_work_hours (PERSONNEL,OBJ,WORK_DATE,PAY_CAT,DUTY_CAT,MISSION,HOURS) VALUES
             (core_context.personnel_sid,v_sid,p_work_date,p_pay_cat,p_duty_cat,p_mission,p_hours);
             
         end if;
         
         -------------------------------------------
         --- Handle Marking Activity as Complete ---
         -------------------------------------------
         if (p_complete='Y') then
           
           begin
                ---------------------------------------------------
                --- Try to get the Status for Complete Activity ---
                ---------------------------------------------------
                select sid into v_complete_status_sid
                         from v_osi_status_change osc
                        where (from_status = osi_status.get_starting_status(p_obj_type_sid) and button_label='Complete Activity')
                          and (obj_type member of osi_object.get_objtypes(p_obj_type_sid) or obj_type = core_obj.lookup_objtype('ALL'))and button_label is not null
                          and osc.active = 'Y'
                          and osc.code not in(                
                          select code
                               from v_osi_status_change osc2 
                              where ((obj_type = p_obj_type_sid and override = 'Y')
                                     or
                                    (obj_type member of osi_object.get_objtypes(p_obj_type_sid)
                                and override = 'Y'))  and osc.sid <> osc2.sid);         
 
                if (osi_checklist.checklist_complete(v_sid,v_complete_status_sid))='Y' then
  
                  --- Sleep 1 Second so the Create/Complete are at least one second apart ---
                  stime := iol.sleep(1);
                                           
                  osi_status.change_status(v_sid,v_complete_status_sid);
             
                end if;
           
           exception when others then

                    log_error('create_instance - Could not get Complete Status - ' || SQLERRM);
                    
           end;
             
         end if;

        log_error('>>> create_instance(' || p_obj_type_sid || ',' || p_act_date || ',' || p_title || ',' || p_restriction || ',' || p_narrative || ',' || p_FieldNames || ',' || p_FieldValues || ',' || p_ParticipantVersion || ',' || p_ParticipantUsage || ',' || p_ParticipantCode || ',' || p_TableName || ',' || p_FileToAssociate || ',' || p_AddressUsage || ',' || p_AddressCode || ',' || p_AddressValue || ',' || p_ObjectiveParent || ',' || p_Pay_Cat || ',' || p_Duty_Cat  || ',' || p_Mission || ',' || p_Work_Date || ',' || p_Hours || ',' || p_Complete || ')');
        return v_sid;

    exception
        when others then

            log_error('create_instance: ' || sqlerrm);
            raise;

    end create_instance;

    /* Build an array of the missions associated to the activity, and
       convert that array to an apex-friendly colon-delimited list */
    function get_inv_support(p_obj in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select mission
                    from t_osi_mission
                   where obj = p_obj)
        loop
            v_array(v_idx) := i.mission;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_inv_support: ' || sqlerrm);
            raise;
    end get_inv_support;

    /* Translates p_inv_support (colon-delimited list of mission sids) into an array, then
       loops through and adds those that don't exist already.  Deletes those that no longer
       appear in the list */
    procedure set_inv_support(p_obj in varchar2, p_inv_support in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_inv_support, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_mission
                        (obj, mission)
                select p_obj, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_mission
                                   where obj = p_obj and mission = v_array(i));
        end loop;

        delete from t_osi_mission
              where obj = p_obj and instr(nvl(p_inv_support, 'null'), mission) = 0;
    exception
        when others then
            log_error('set_inv_support: ' || sqlerrm);
            raise;
    end set_inv_support;

    /*Returns the activity date for the current activity*/
    function get_activity_date(p_obj in varchar2)
        return date is
        v_return   date;
    begin
        select activity_date
          into v_return
          from t_osi_activity
         where SID = p_obj;

        return v_return;
    exception
        when others then
            log_error('get_activity_date: ' || sqlerrm);
            raise;
    end get_activity_date;

    /*Returns a custom error message if the object is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2) return varchar2 is

         v_status      varchar2(200) := null;
         v_count_check number := 0;
         
    begin
         if osi_auth.check_for_priv('DELETE',Core_Obj.get_objtype(p_obj))='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;
         
         v_status := upper(osi_object.get_status(p_obj));

         ---Is activity completed?---
         if v_status = 'COMPLETED' then
 
           return 'Cannot delete completed activities.';
  
         end if;

         ---Is activity closed?---
         if v_status = 'CLOSED' then
 
           return 'Cannot delete closed activities.';
  
         end if;

         ---Is Activity an Active Lead?---
         for a in (select SID from t_osi_activity
                         where SID=p_obj 
                           and nvl(creating_unit, 'NONE') <> nvl(assigned_unit, 'NONE'))
         loop

             return 'Cannot delete active leads.';

         end loop;

         ---Does the Activity Have WorkHours Associated with it?---
         select count(*) into v_count_check from t_osi_work_hours where obj=p_obj;
         if v_count_check > 0 then

           return 'Cannot delete activities with associated work hours.';

         end if;

         ---Does the Activity Have File(s) Associated with it?---
         select count(*) into v_count_check from t_osi_assoc_fle_act where activity_sid = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with associated files.';

         end if;

         ---Does the Activity Have CFund Expenses Associated with it?---
         select count(*) into v_count_check from t_cfunds_expense_v3 where parent = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with C Fund Expenses.';

         end if;

         ---Does the Activity Have Evidence Associated with it?---
         select count(*) into v_count_check from t_osi_evidence where obj = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with Evidence.';

         end if;

         ---Suspicious Activity Report specific check - must also have 'SAR.EDIT' priv --- 
         ---Only watch members may delete talons because of the talon 'states'         ---
         if core_obj.get_objtype(p_obj) = core_obj.lookup_objtype('ACT.SUSPACT_REPORT') then
        
           if osi_auth.check_for_priv('SAR.EDIT', core_obj.get_objtype(p_obj)) <> 'Y' then
        
             return 'You are not authorized to perform the requested action.';
        
           end if;
        
         end if;

         return 'Y';

    exception
        when others then
            log_error('OSI_ACTIVITY.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in OSI_ACTIVITY.Can_Delete using Object: ' || nvl(p_obj, 'NULL');

    end can_delete;

    function get_f40_place(p_obj in varchar2) return varchar2 is

            v_return           varchar2(1000) := null;
            v_create_by_unit   varchar2(20);
            v_name             varchar2(100);
            v_obj_type_code    varchar2(200);

    begin
         select creating_unit into v_create_by_unit from t_osi_activity where SID = p_obj;

         --- Get object type code ---
         v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

         if v_obj_type_code like 'ACT.INTERVIEW%' then                           -- interviews --

           v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

         elsif v_obj_type_code like 'ACT.BRIEFING%' then                         -- briefings --

              select location into v_return from t_osi_a_briefing where SID = p_obj;
              
         elsif v_obj_type_code like 'ACT.SOURCE%' then                           -- source meets --

              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

         elsif v_obj_type_code like 'ACT.SEARCH%' then                           -- searches --

              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

         elsif v_obj_type_code like 'ACT.POLY%' then                             -- polygraphs --

              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

              ---select location into v_return from t_act_poly_exam where sid = psid;
              
         elsif v_obj_type_code like 'ACT.SURV%' then                             -- polygraphs --
 
              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
              
         else
         
           --- This is the displayed text for all other types ---
           v_name := osi_unit.get_name(osi_object.get_assigned_unit(p_obj));
           v_return := v_name || ', ' || osi_address.get_addr_display (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj)));

         end if;

         v_return := replace(v_return, chr(13) || chr(10), ' ');                        -- CRLF's
         v_return := replace(v_return, chr(10), ' ');                                     -- LF's
         v_return := rtrim(v_return, ', ');
         return v_return;
    exception
    
         when no_data_found then
             raise;
             return null;
    
    end get_f40_place;

    function get_attachment_list(p_obj in varchar2, p_delimeter1 in varchar2 := ' - ', p_delimeter2 in varchar2 := '\line ', p_header in varchar2 := 'Attachments\line ') return varchar2 is
    
            v_tmp_attachments   varchar2(30000) := null;
            v_cnt               number          := 0;
    
    begin
         for a in (select description from t_osi_attachment where obj = p_obj order by description)
         loop
             v_cnt := v_cnt + 1;

             if a.description is not null then

               if v_cnt = 1 then

                 v_tmp_attachments := v_tmp_attachments || p_header;

               end if;

               v_tmp_attachments := v_tmp_attachments || p_delimeter1 || a.description || p_delimeter2;
            
             else
             
               return null;
             
             end if;

         end loop;

         return v_tmp_attachments;

    end get_attachment_list;

    function generate_form_40_draft(p_obj in varchar2) return clob is
    begin
         return generate_form_40(p_obj, 'Y');
         
    end generate_form_40_draft;
    /* Used to generate Form 40 Reports */
    function generate_form_40(p_obj in varchar2, pDraft in varchar2 := 'N') return clob is

        v_ok1               varchar2(1000);
        v_ok2               varchar2(1000);
        v_return            clob                                    := null;
        v_return_date       date;
        v_mime_type         t_core_template.mime_type%type;
        v_mime_disp         t_core_template.mime_disposition%type;
        v_narrative_text    clob                                    := null;
        v_narrative         clob                                    := null;
        v_attachment_list   varchar2(3000)                          := null;
        v_classification    varchar2(1000)                          := null;
        v_activity_lead     varchar2(20);
        v_place             varchar2(32000);
        v_newline           varchar2(10)                            := chr(13) || chr(10);
        v_particVersionSid  varchar2(20);
        v_Result            varchar2(32000);
        v_SAA               varchar2(32000);
        v_Per               varchar2(32000);
        v_SubjectName       varchar2(32000);
        v_LatestOrg         varchar2(20);
        v_RelationshipSID   varchar2(20);
        v_Position          varchar2(32000);
        v_Phone             varchar2(32000);
        v_last_unit_name    varchar2(32000);
        v_unit_address      varchar2(32000);
        v_per_unit_cnt      number;
        v_title             varchar2(32000);
        v_obj_type_code     varchar2(1000);
                
    begin
         --- Get latest template ---
         if pDraft='N' then

           v_ok1 := core_template.get_latest('FORM_40', v_return, v_return_date, v_mime_type, v_mime_disp);
         
         else
         
           v_ok1 := core_template.get_latest('FORM_40_DRAFT', v_return, v_return_date, v_mime_type, v_mime_disp);
           v_return := replace(v_return,'AFOSI','***** DRAFT ONLY *****');
           v_return := replace(v_return,'AIR FORCE OFFICE OF SPECIAL INVESTIGATIONS','***** DRAFT ONLY *****');
           v_return := replace(v_return,'REPORT OF INVESTIGATIVE ACTIVITY','***** DRAFT ONLY *****');

         end if;
         
         for k in (select a.SID, a.id as act_no, a.title, a.activity_date, a.narrative, a.object_type_code, a.leadership_approved 
                     from v_osi_activity_summary a 
                         where a.SID = p_obj)
         loop
             if (k.leadership_approved is null or k.leadership_approved = 'N') and pDraft = 'N' then
               
               return 'Form 40 Cannot be genereated until Activity is Approved by Leadership.....';
               
             end if;
             
             v_obj_type_code := k.object_type_code;

             --- Get place of activity ---
             v_place := get_f40_place(k.SID);

             --- Get classification Markings --
             select osi_classification.get_report_class(p_obj) into v_classification from dual;

             v_ok2 := core_template.replace_tag(v_return, 'LEADAGENT_NAME', osi_object.get_lead_agent_name(p_obj));
             v_ok2 := core_template.replace_tag(v_return, 'RPT_DATE', to_char(k.activity_date, 'dd-Mon-yyyy'));
             v_ok2 := core_template.replace_tag(v_return, 'ACTIVITY_NO', k.act_no);
             v_ok2 := core_template.replace_tag(v_return, 'PLACE_OF_ACTIVITY', v_place);
             if v_classification is not null then

               v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', v_classification, 'TOKEN@', true);

             end if;
             
---             if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS','ACT.DOCUMENT_REVIEW','ACT.RECORDS_CHECK') then

               begin
                    select participant_version into v_particVersionSid 
                      from t_osi_partic_involvement i, t_osi_partic_role_type rt  
                          where i.OBJ=p_obj
                            and i.INVOLVEMENT_ROLE=rt.sid
                            and upper(rt.role)='SUBJECT OF ACTIVITY';

               exception when others then

                        v_particVersionSid := null;
                        
               end;
               
               if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS') then

                 v_title := 'Interview of:  ';
                 
               elsif k.object_type_code in ('ACT.DOCUMENT_REVIEW') then

                    v_title := 'Document Review of:  ';

               elsif k.object_type_code in ('ACT.RECORDS_CHECK') then

                    v_title := 'Law Enforcement Checks of:  ';

               end if;
               
               --- Show Subject Information for Activities that have a Participant or Title ---
               if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS',
                                         'ACT.FINGERPRINT.CRIMINAL','ACT.FINGERPRINT.MANUAL',
                                         'ACT.INIT_NOTIF','ACT.POLY_EXAM','ACT.SEARCH.PERSON',
                                         'ACT.DOCUMENT_REVIEW','ACT.RECORDS_CHECK') then

                 --- Get Subject Name ---
                 osi_investigation.get_basic_info(v_particVersionSid, v_SubjectName, v_SAA, v_Per, True, True, False, False, 'N');
               
                 --- Get Other Basic Information ---
                 osi_investigation.get_basic_info(v_particVersionSid, v_Result, v_SAA, v_Per, False, False, False, False, 'N');
                 v_narrative := v_narrative || v_title || rtrim(v_SubjectName,' ;') || ' (SUBJECT); ' || v_Result;

                 ---  Get Military Organization ---
                 v_Result := osi_investigation.get_org_info(v_particVersionSid, True);
                 v_narrative := v_narrative || v_Result || '; ';
               
                 --- Get Current Work Position ---
                 begin
                      v_LatestOrg := osi_participant.Latest_Org(v_particVersionSid);
                      select w.sid into v_RelationshipSID from v_osi_partic_relation_2way w 
                         where w.this_partic=v_Per 
                           and w.THAT_PARTIC=v_LatestOrg;
               
                      v_Position := osi_participant.get_relation_specifics(v_RelationshipSID);
                    
                 exception when others then
                        
                          v_Position := 'UNK';
                        
                 end;
               
                 v_narrative := v_narrative || v_Position || '; ';
                 
                 --- Get Participant Phone Number ---
                 v_Phone := osi_investigation.getparticipantphone(v_Per);
                 v_narrative := v_narrative || 'Phone: ' || v_Phone || '.\line ';
               
               else
                 
                 v_narrative := v_narrative || k.title || '\line ';
                   
               end if;
               
               if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS') then

                 --- Get Interviewers ---
                 v_narrative := v_narrative || 'Interviewers: ';
               
                 --- Segment by Units so we only display the Unit address ONCE ---
                 for u in (select distinct un.unit as unit_sid, un.unit_name as unit_name 
                             from t_osi_assignment a, t_osi_assignment_role_type at, t_osi_personnel op, t_core_personnel cp, t_osi_personnel_unit_assign ua, t_osi_unit_name un
                              where a.assign_role=at.sid
                                and a.obj=p_obj
                                and a.personnel=op.sid
                                and op.sid=cp.sid
                                and ua.personnel=op.sid
                                and ua.end_date is null
                                and un.unit=ua.unit
                                and un.end_date is null order by un.unit_name)
                 loop
                     begin
                          select u.unit_name || ', ' || ad.city || decode(s.code,null, '', ', ' || s.code) into v_unit_address from t_osi_address ad,t_dibrs_state s where obj=u.unit_sid and ad.state=s.sid(+);
                          
                     exception when others then

                              v_unit_address := '';
                              
                     end;
                   
                     for a in (select last_name,first_Name,badge_num,un.unit_name,decode(badge_num,null,'','SA ') as name_prefix, decode(at.code,'LEAD',' (LEAD)','') as name_suffix, rownum, count(un.unit_name) over (partition by un.unit_name) as rowcount 
                                 from t_osi_assignment a, t_osi_assignment_role_type at, t_osi_personnel op, t_core_personnel cp, t_osi_unit_name un, t_osi_personnel_unit_assign ua
                                  where a.assign_role=at.sid
                                    and a.obj=p_obj
                                    and a.personnel=op.sid
                                    and op.sid=cp.sid
                                    and un.unit=u.unit_sid
                                    and ua.personnel=op.sid
                                    and ua.end_date is null
                                    and un.unit=ua.unit
                                    and un.end_date is null order by un.unit_name, last_name, first_name)
                     loop
                         if (a.rownum = (a.rowcount-1)) then

                           v_narrative := v_narrative || a.name_prefix || a.first_name || ' ' || a.last_name || a.name_suffix || ', and ';

                         else

                           v_narrative := v_narrative || a.name_prefix || a.first_name || ' ' || a.last_name || a.name_suffix || ', ';
                       
                         end if;
                     
                     end loop;

                     v_narrative := v_narrative || v_unit_address || '; ';
                   
                 end loop;
                 v_narrative := v_narrative || '\line ';
                 
               end if;
                              
               --- Get Associated Case File ---
               for c in (select nvl(f.full_id,f.id) as id,offt.description
                from t_osi_assoc_fle_act fa, t_osi_file f, t_core_obj_type ot, t_core_obj o, t_osi_f_inv_offense off, t_dibrs_offense_type offt, t_osi_reference ref
                           where fa.file_sid=f.sid 
                             and fa.activity_sid=p_obj
                             and o.sid=fa.file_sid
                             and ot.sid=o.obj_type
                             and off.investigation=fa.file_sid
                             and off.offense=offt.sid(+)
                             and off.priority=ref.sid(+)
                             and ref.code='P')
               loop
                   v_narrative := v_narrative || 'Case: ' || c.description || ', ' || c.id || '\line ';
                   
               end loop;

               ---   Appends Attachments List ---
               v_attachment_list := get_attachment_list(p_obj, '', '; ', 'Attachments: ');
  
               if v_attachment_list is not null then

                 v_narrative := v_narrative || rtrim(v_attachment_list, '; ') || '\line ';

               end if;
               v_narrative := v_narrative || '\line ';
               
---             else
---
---               --- Assemble the Narrative Header ---
---               v_narrative := v_narrative || k.title || '\par\par Date/Place: ' || k.activity_date || '/' || v_place || '\line\line ';
---
---               ---   Appends Attachments List ---
---               v_attachment_list := get_attachment_list(p_obj, '', '; ', 'Attachments: ');
---  
---               if v_attachment_list is not null then
---
---                 v_narrative := v_narrative || rtrim(v_attachment_list, '; ') || '\line ';
---
---               end if;
---
---             end if;
             
         end loop;

         if v_obj_type_code in ('ACT.RECORDS_CHECK','ACT.DOCUMENT_REVIEW') then
           
           
           if v_obj_type_code='ACT.RECORDS_CHECK' then

             v_narrative_text := replace(osi_records_check.get_narrative(p_obj),chr(13) || chr(10),'\line ');

           end if;
           
           if v_obj_type_code='ACT.DOCUMENT_REVIEW' then

             v_narrative_text := replace(osi_document_review.get_narrative(p_obj),chr(13) || chr(10),'\line ');

           end if;

         else

           for k in (select narrative from t_osi_activity where SID = p_obj)
           loop
               v_narrative_text := osi_report.clob_replace(k.narrative, v_newline, '\line ');
           end loop;
           
         end if;
         
         --- Append Narrative to variable ---
         dbms_lob.append(v_narrative, v_narrative_text);

         --- Appends the Narrative itself ---
         v_ok2 := core_template.replace_tag(v_return, 'NARRATIVE', v_narrative, 'TOKEN@', true);

         -- Get the boilerplate ---
         if v_classification is null then

           for f in (select setting from t_core_config where code = 'F40_CAVEAT')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                             select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                            when others then
                                v_classification := null;
                        end;
               end;

           end loop;

         end if;

         if v_classification is null then

           for f in (select setting from t_core_config where code = 'DEFAULT_CLASS')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                           select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                           when others then
                               v_classification := f.setting;
                        end;
               end;
 
           end loop;

         end if;

         if v_classification is null then

           v_classification := 'FOR OFFICIAL USE ONLY';

         end if;

         v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', upper(v_classification), 'TOKEN@', true);

         return v_return;

    exception
        when others then
            log_error('osi_activity.generate_form_40: ' || sqlerrm);
            raise;
            return v_return;
    end generate_form_40;

    /* Used to generate Form 40 Reports */
    function generate_form_40_summary(p_obj in varchar2) return clob is

        v_ok1              varchar2(1000);
        v_ok2              varchar2(1000);
        v_return           clob                                    := null;
        v_return_date      date;
        v_mime_type        t_core_template.mime_type%type;
        v_mime_disp        t_core_template.mime_disposition%type;
        v_narrative_text   clob                                    := null;
        v_classification   varchar2(1000)                          := null;
        v_activity_lead    varchar2(20);
        v_place            varchar2(32000);
        v_newline          varchar2(10)                            := chr(13) || chr(10);
        v_cnt              number                                  := 0;

    begin
         --- Get latest template ---
         v_ok1 := core_template.get_latest('FORM_40_SUMMARY', v_return, v_return_date, v_mime_type, v_mime_disp);

         --- Get Activity Lead ---
         v_activity_lead := osi_object.get_lead_agent(p_obj);

         for k in (select a.SID, a.id as act_no, a.title, a.activity_date, a.narrative from v_osi_activity_summary a where a.SID = p_obj)
         loop
             --- Get place of activity ---
             v_place := get_f40_place(k.SID);

             --- Get classification Markings ---
             select osi_classification.get_report_class(p_obj) into v_classification from dual;

             v_ok2 := core_template.replace_tag(v_return, 'LEADAGENT_NAME', osi_object.get_lead_agent_name(p_obj));
             v_ok2 := core_template.replace_tag(v_return, 'RPT_DATE', to_char(k.activity_date, 'dd-Mon-yyyy'));
             v_ok2 := core_template.replace_tag(v_return, 'ACTIVITY_NO', k.act_no);
             v_ok2 := core_template.replace_tag(v_return, 'PLACE_OF_ACTIVITY', v_place);

             if v_classification is not null then

               v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', v_classification, p_multiple => true);

             end if;

         end loop;

         for k in (select n.note_text 
                         from t_osi_note n, t_osi_note_type nt
                             where n.obj = p_obj 
                               and n.note_type = nt.SID
                               and nt.description = 'Form 40 Summary Note'
                             order by n.create_on)
         loop
             v_cnt := v_cnt + 1;

             if v_cnt > 1 then
             
               v_narrative_text := v_narrative_text || '\par\par ';
             
             end if;

             v_narrative_text := v_narrative_text || v_cnt || '.  ';
             v_narrative_text := v_narrative_text || osi_report.clob_replace(k.note_text, v_newline, '\line ');

         end loop;

         --- Appends the Narrative itself ---
         v_ok2 := core_template.replace_tag(v_return, 'NARRATIVE', v_narrative_text, 'TOKEN@', true);
 
         --- Get the boilerplate ---
         if v_classification is null then

           for f in (select setting from t_core_config where code = 'F40_CAVEAT')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                             select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                            when others then
                                v_classification := null;
                        end;
               end;

           end loop;

         end if;

         if v_classification is null then

           for f in (select setting from t_core_config where code = 'DEFAULT_CLASS')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                             select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                             when others then
                                 v_classification := f.setting;
                        end;
               end;

           end loop;

         end if;

         if v_classification is null then
  
           v_classification := 'FOR OFFICIAL USE ONLY';
   
         end if;

         v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', upper(v_classification), p_multiple => true);
         return v_return;

    exception
        when others then
            log_error('osi_activity.generate_form_40_summary: ' || sqlerrm || dbms_utility.format_error_backtrace);
            raise;
            return v_return;
            
    end generate_form_40_summary;

    function check_writability(p_obj in varchar2)
        return varchar2 is
        v_rtn      varchar2(1000)            := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        -- begin object type specific writability check
        v_ot_rec.SID := core_obj.get_objtype(p_obj);

        select *
          into v_ot_rec
          from t_core_obj_type
         where SID = v_ot_rec.SID;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                              || '.CHECK_WRITABILITY(:OBJ); end;'
                        using out v_rtn, in p_obj;

            if v_rtn = 'N' then
                return v_rtn;
            end if;
        exception
            when others then
                null;                              -- do nothing, move on to generic activity check
        end;

        --end object type specific writability check
        if osi_object.get_status_code(p_obj) = 'CL' then
            return 'N';
        else
            return 'Y';
        end if;
    exception
        when others then
            log_error('osi_activity.check_writability: ' || sqlerrm);
            raise;
    end check_writability;

--======================================================================================================================
-- Following routines create activity object type specific documents for reporting purposes.
--======================================================================================================================
    procedure make_doc_act(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp_clob   clob;
        v_template    clob;
        v_ok          varchar2(1000);
        v_act_rec     t_osi_activity%rowtype;
    begin
        core_logger.log_it(c_pipe, '--> make_doc_act');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                           (c_pipe,
                            'ODW.Make_Doc_ACT: Activity is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                          (c_pipe,
                           'ODW.Make_Doc_ACT: Activity is LIMDIS - no document will be synthesized');
            return;
        end if;

        select *
          into v_act_rec
          from t_osi_activity
         where SID = p_sid;

        osi_object.get_template('OSI_ODW_DETAIL_ACT', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Fill in data
        v_ok := core_template.replace_tag(v_template, 'ID', v_act_rec.id);
        v_ok := core_template.replace_tag(v_template, 'TITLE', v_act_rec.title);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'NARRATIVE',
                                      core_util.html_ize(v_act_rec.narrative));
        osi_object.append_involved_participants(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'PARTICIPANTS', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        osi_object.append_attachments(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENTS', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        osi_object.append_notes(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'NOTES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        p_doc := v_template;
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_act');
    exception
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_ACT Error: ' || v_syn_error);
    end make_doc_act;

    function get_oldest_file(p_obj in varchar2)
        return varchar2 is
    begin
        for f in (select   file_sid
                      from t_osi_assoc_fle_act
                     where activity_sid = p_obj
                  order by modify_on)
        loop
            return f.file_sid;                                               -- only need first one
        end loop;

        return null;                                                          -- no associated files
    end get_oldest_file;
end osi_activity;
/


