alter table t_osi_activity add substantive varchar2(1);--- default 'N';


alter table t_osi_a_records_check_multi add substantive varchar2(1) default 'N';



CREATE OR REPLACE VIEW V_OSI_ACTIVITY_SUMMARY
(SID, ID, TITLE, CREATE_ON, CREATE_BY, 
 RESTRICTION, ACTIVITY_DATE, CREATING_UNIT, ASSIGNED_UNIT, AUXILIARY_UNIT, 
 COMPLETE_DATE, SUSPENSE_DATE, CLOSE_DATE, CURRENT_STATUS, INV_SUPPORT, 
 NARRATIVE, OBJECT_TYPE_DESCRIPTION, SUBSTANTIVE)
AS 
select a.sid, a.id, a.title, o.create_on, o.create_by, a.restriction, a.activity_date,
           osi_unit.get_name(a.creating_unit) creating_unit,
           osi_unit.get_name(a.assigned_unit) assigned_unit,
           osi_unit.get_name(a.aux_unit) auxiliary_unit, a.complete_date, a.suspense_date,
           a.close_date, osi_object.get_status(a.sid) current_status,
           osi_activity.get_inv_support(a.sid) inv_support, a.narrative,
           (select description
              from t_core_obj_type
             where sid = core_obj.get_objtype(a.sid)) as "OBJECT_TYPE_DESCRIPTION",
           substantive
      from t_core_obj o, t_osi_activity a
     where a.sid = o.sid
/


CREATE OR REPLACE TRIGGER "OSI_ACTIVITY_SUMMARY_IO_U_01" 
    instead of update
    on v_osi_activity_summary
    for each row
begin
    update t_osi_activity
       set title = :new.title,
           activity_date = :new.activity_date,
           restriction = :new.restriction,
           substantive = :new.substantive
     where sid = :new.sid;

    if nvl(:new.inv_support, 'null') <> nvl(:old.inv_support, 'null') then
        osi_activity.set_inv_support(:new.sid, :new.inv_support);
    end if;

    core_obj.bump(:new.sid);
end;
/


CREATE OR REPLACE VIEW V_OSI_ASSOC_FLE_ACT
(SID, FILE_SID, FILE_ID, FILE_TITLE, FILE_TYPE_DESC, 
 ACTIVITY_SID, ACTIVITY_ID, ACTIVITY_TITLE, ACTIVITY_TYPE_DESC, ACTIVITY_COMPLETE_DATE, 
 ACTIVITY_CLOSE_DATE, ACTIVITY_DATE, ACTIVITY_SUSPENSE_DATE, ACTIVITY_UNIT_ASSIGNED, SUBSTANTIVE)
AS 
select oafa.sid, oafa.file_sid, of1.id as "FILE_ID", of1.title as "FILE_TITLE",
           cot1.description as "FILE_TYPE_DESC", oafa.activity_sid, oa.id as "ACTIVITY_ID",
           oa.title as "ACTIVITY_TITLE", cot2.description as "ACTIVITY_TYPE_DESC",
           oa.complete_date as "ACTIVITY_COMPLETE_DATE", oa.close_date as "ACTIVITY_CLOSE_DATE",
           oa.activity_date as "ACTIVITY_DATE", oa.suspense_date as "ACTIVITY_SUSPENSE_DATE", 
           osi_unit.get_name(oa.assigned_unit) as "ACTIVITY_UNIT_ASSIGNED",
           oa.substantive as "SUBSTANTIVE"
    from   t_osi_assoc_fle_act oafa,
           t_osi_file of1,
           t_core_obj co1,
           t_core_obj_type cot1,
           t_osi_activity oa,
           t_core_obj co2,
           t_core_obj_type cot2
     where of1.sid = oafa.file_sid
       and of1.sid = co1.sid
       and cot1.sid = co1.obj_type
       and oa.sid = oafa.activity_sid
       and oa.sid = co2.sid
       and cot2.sid = co2.obj_type
/


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
    function generate_form_40(p_obj in varchar2)
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
         insert into t_osi_activity (sid,id,title,creating_unit,assigned_unit,activity_date,narrative,restriction,source,substantive)
             values (v_sid,osi_object.get_next_id,p_title,osi_personnel.get_current_unit(core_context.personnel_sid),v_UnitSID,p_act_date,p_narrative,p_restriction,v_source,p_Substantive);
        
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

    function get_attachment_list(p_obj in varchar2) return varchar2 is
    
            v_tmp_attachments   varchar2(30000) := null;
            v_cnt               number          := 0;
    
    begin
         for a in (select description from t_osi_attachment where obj = p_obj order by description)
         loop
             v_cnt := v_cnt + 1;

             if a.description is not null then

               if v_cnt = 1 then

                 v_tmp_attachments := v_tmp_attachments || 'Attachments\line ';

               end if;

               v_tmp_attachments := v_tmp_attachments || ' - ' || a.description || '\line ';
            
             else
             
               return null;
             
             end if;

         end loop;

         return v_tmp_attachments;

    end get_attachment_list;

    /* Used to generate Form 40 Reports */
    function generate_form_40(p_obj in varchar2) return clob is

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

    begin
         --- Get latest template ---
         v_ok1 := core_template.get_latest('FORM_40', v_return, v_return_date, v_mime_type, v_mime_disp);

         for k in (select a.SID, a.id as act_no, a.title, a.activity_date, a.narrative from v_osi_activity_summary a where a.SID = p_obj)
         loop
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
    
             --- Assemble the Narrative Header ---
             v_narrative := v_narrative || k.title || '\par\par Date/Place: ' || k.activity_date || '/' || v_place || '\line\line ';

             ---   Appends Attachments List ---
             v_attachment_list := get_attachment_list(p_obj);

             if v_attachment_list is not null then

               v_narrative := v_narrative || v_attachment_list || '\line ';

             end if;

         end loop;

         for k in (select narrative from t_osi_activity where SID = p_obj)
         loop
             v_narrative_text := osi_report.clob_replace(k.narrative, v_newline, '\line ');
         end loop;

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
--   Date and Time:   08:15 Wednesday May 9, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: IsObjectWritable
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
 
 
prompt Component Export: APP PROCESS 13691701216207076
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       l_activity_sid  varchar2(200) := apex_application.g_x01;'||chr(10)||
'       l_writable      varchar2(4000);'||chr(10)||
'begin'||chr(10)||
'     select osi_object.check_writability(l_activity_sid,null) into l_writable from dual;'||chr(10)||
''||chr(10)||
'     htp.p(l_writable);'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         htp.p(sqlerrm);'||chr(10)||
''||chr(10)||
'end';

wwv_flow_api.create_flow_process(
  p_id => 13691701216207076 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'IsObjectWritable',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
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
--   Date and Time:   08:16 Wednesday May 9, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: OSI_ACTIVITY_TOGGLE_SUBSTANTIVE
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
 
 
prompt Component Export: APP PROCESS 13691221330089895
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'       l_activity_sid  varchar2(200) := apex_application.g_x01;'||chr(10)||
'       l_new_value     varchar2(1);'||chr(10)||
'begin'||chr(10)||
'     select decode(substantive,''Y'',''N'',''Y'') into l_new_value'||chr(10)||
'          from t_osi_activity where sid=l_activity_sid;'||chr(10)||
'    '||chr(10)||
'     '||chr(10)||
'     update t_osi_activity set substantive=l_new_value'||chr(10)||
'           where sid=l_activity_sid;'||chr(10)||
''||chr(10)||
'     if(l_new_value=''Y'') then'||chr(10)||
''||chr(10)||
'       htp.p(''Yes'');'||chr(10)||
''||chr(10)||
'     else'||chr(10)||
''||chr(10)||
' ';

p:=p||'      htp.p(''No'');'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'exception when others then'||chr(10)||
''||chr(10)||
'         htp.p(sqlerrm);'||chr(10)||
''||chr(10)||
'end';

wwv_flow_api.create_flow_process(
  p_id => 13691221330089895 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'OSI_ACTIVITY_TOGGLE_SUBSTANTIVE',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
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
--   Date and Time:   13:20 Wednesday May 9, 2012
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

PROMPT ...Remove page 10150
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>10150);
 
end;
/

 
--application/pages/page_10150
prompt  ...PAGE 10150: File Associated Activities
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'"JS_REPORT_AUTO_SCROLL"'||chr(10)||
'<script language="JavaScript" type="text/javascript">'||chr(10)||
'if (''&REQUEST.'' == ''CC_SEL''){'||chr(10)||
'	var pageNum = 5600;'||chr(10)||
'	var pageName = ''COM_CLO_WID'';'||chr(10)||
'	var itemNames = ''P5600_ACTION_TYPE,P5600_ACT_LIST,P0_OBJ'';'||chr(10)||
'	var itemVals = ''SEL,&P10150_ACT_LIST.,&P0_OBJ.'';'||chr(10)||
''||chr(10)||
'	popup({ page 		: pageNum,  '||chr(10)||
'		name 		: pageName,'||chr(10)||
'		item_names 	: itemNames,'||chr(10)||
'		item_values 	: itemVals,'||chr(10)||
'	';

ph:=ph||'	clear_cache 	: pageNum});'||chr(10)||
'};'||chr(10)||
''||chr(10)||
'if (''&REQUEST.'' == ''CC_ALL''){'||chr(10)||
'	var pageNum = 5600;'||chr(10)||
'	var pageName = ''COM_CLO_WID'';'||chr(10)||
'	var itemNames = ''P5600_ACTION_TYPE,P5600_ACT_LIST,P0_OBJ'';'||chr(10)||
'	var itemVals = ''ALL,&P10150_ACT_LIST.,&P0_OBJ.'';'||chr(10)||
''||chr(10)||
'	popup({ page 		: pageNum,  '||chr(10)||
'		name 		: pageName,'||chr(10)||
'		item_names 	: itemNames,'||chr(10)||
'		item_values 	: itemVals,'||chr(10)||
'		clear_cache 	: pageNum});'||chr(10)||
'};'||chr(10)||
''||chr(10)||
''||chr(10)||
'function GetAndOpenMenu(e,pThis,pThat,p';

ph:=ph||'Sub)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                           $v(''pFlowId''),'||chr(10)||
'                           ''APPLICATION_PROCESS=GETREPORTMENUGUTS'','||chr(10)||
'                           $v(''pFlowStepId''));   '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pThat); '||chr(10)||
' get.addParam(''x02'',''N'');     '||chr(10)||
' '||chr(10)||
' gReturn = get.get();'||chr(10)||
''||chr(10)||
' var rptList = document.getElementById(pThat);'||chr(10)||
' rptList.innerHTML=gReturn;'||chr(10)||
''||chr(10)||
' var lMenu = $x(pThat);'||chr(10)||
' if(pThis != gC';

ph:=ph||'urrentAppMenuImage)'||chr(10)||
'   {'||chr(10)||
'    app_AppMenuMultiClose();'||chr(10)||
'    var l_That = pThis.parentNode; '||chr(10)||
'    pThis.className = g_dhtmlMenuOn;'||chr(10)||
'    dhtml_MenuOpen(l_That,pThat,false,''Bottom'');'||chr(10)||
'    lMenu.style.top = e.y;'||chr(10)||
'    lMenu.style.left = e.x;'||chr(10)||
''||chr(10)||
'    gCurrentAppMenuImage = pThis;'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    dhtml_CloseAllSubMenus();'||chr(10)||
'    app_AppMenuMultiClose();'||chr(10)||
'   }'||chr(10)||
' return;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ToggleSubstantive(pActSid)'||chr(10)||
'{'||chr(10)||
' var';

ph:=ph||' get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Check_Access'','||chr(10)||
'                          $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pActSid);'||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' if(gReturn==''Y'')'||chr(10)||
'   {'||chr(10)||
'    var get = new htmldb_Get(null,'||chr(10)||
'                             $v(''pFlowId''),'||chr(10)||
'                             ''APPLICATION_PROCESS=IsObjectW';

ph:=ph||'ritable'','||chr(10)||
'                             $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'    get.addParam(''x01'',pActSid);'||chr(10)||
'    gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'    if(gReturn==''Y'')'||chr(10)||
'      {'||chr(10)||
'       if (confirm(''Are you sure you want to change this activity?''))'||chr(10)||
'         {'||chr(10)||
'          var get = new htmldb_Get(null,'||chr(10)||
'                                   $v(''pFlowId''),'||chr(10)||
'                                   ''APPLICATION_PROCESS=OSI_ACTIVITY_TOG';

ph:=ph||'GLE_SUBSTANTIVE'','||chr(10)||
'                                   $v(''pFlowStepId''));'||chr(10)||
''||chr(10)||
'          get.addParam(''x01'',pActSid);'||chr(10)||
'          gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
'          if(gReturn==''Yes'' || gReturn==''No'')'||chr(10)||
'            {'||chr(10)||
'             $(''#''+pActSid).text(gReturn);'||chr(10)||
'            } '||chr(10)||
'          else'||chr(10)||
'            {'||chr(10)||
'             alert(gReturn);'||chr(10)||
'            }'||chr(10)||
'         }'||chr(10)||
'      }'||chr(10)||
'    else'||chr(10)||
'      {'||chr(10)||
'       alert(''This ob';

ph:=ph||'ject is READ ONLY.'');'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
'    alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 10150,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'File Associated Activities',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_html_page_onload=>'onkeydown="return checkForUpDownArrows(event, ''&P10150_SEL_ASSOC.'');"',
  p_step_sub_title => 'File Associated Activities',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
'$(window).load(function(){  '||chr(10)||
''||chr(10)||
'  var t = setTimeout("scrollDivBackOne()", 500);'||chr(10)||
''||chr(10)||
'});'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89997728565512278+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120509131928',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '27-JUL-10 J.Faris Bug 0500 - Fixed typo in P10150_NARRATIVE_UNAVAIL static text.'||chr(10)||
''||chr(10)||
'12-May-2011 Tim Ward - CR#3745/3780 - Added nowrap to date fields of report.'||chr(10)||
'                       Made Narrative width = 100% and added more to the '||chr(10)||
'                       height of the text field (style="height:auto;" '||chr(10)||
'                       doesn''t seem to work).'||chr(10)||
''||chr(10)||
'                       Added "JS_REPORT_AUTO_SCROLL" to HTML '||chr(10)||
'                       Header.  Added onkeydown="return checkForUpDownArrows'||chr(10)||
'                       (event, ''&P10150_SEL_ASSOC.'');" to HTML Body Attribute. '||chr(10)||
'                       Added name=''#SID#'' to "Link Attributes" of the SID '||chr(10)||
'                       Column of the Report. Added a new Branch to'||chr(10)||
'"f?p=&APP_ID.:10150:&SESSION.::&DEBUG.:::#&P10150_SEL_ASSOC.",'||chr(10)||
'                       this allows the report to move the the Anchor '||chr(10)||
'                       of the selected currentrow.'||chr(10)||
''||chr(10)||
'13-Sep-2011 Tim Ward - CR#3905 - Added a Quick View Note Pop-Up Icon to'||chr(10)||
'                       the Report.'||chr(10)||
''||chr(10)||
'04-Oct-2011 - Tim Ward - CR#3919 - Add Report Printing for Activities from '||chr(10)||
'                         the File/Activity Associations sreen.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - CR#3822 - Set Page 0 on Tab changes.'||chr(10)||
'                        Added &TAB_PAGE_OBJ. to Tab Page Branch.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.'||chr(10)||
''||chr(10)||
'15-Mar-2012 - Tim Ward - CR#4010 - Added Multi Removal.  Added '||chr(10)||
'                          "Delete Associations" Process and renamed'||chr(10)||
'                          "Delete Associations" to "Delete Association".'||chr(10)||
'                          Added Delete Associations Button.'||chr(10)||
''||chr(10)||
'21-Mar-2012 - Carolyn Johnson - CR#3644 - Feedback Message Corrections.'||chr(10)||
'                                 Addded P10150_MESSAGE_TO_USER/_2/_3.'||chr(10)||
'                                 Changed Add Associations Process.'||chr(10)||
''||chr(10)||
'09-May-2012 - Tim Ward - CR#4045 - Added Substantive Field.'||chr(10)||
'                                   Also, hide File ID field if the'||chr(10)||
'                                   only filter is ME.'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>10150,p_text=>ph);
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
  p_id=> 2401416207751675 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_plug_name=> 'Choose the Associations to Display',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
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
  p_id=> 6794424078534921 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_plug_name=> 'Narrative of Selected Activity <font color="red"><i>([shift]+[down]/[up] to navigate narratives)</i></font>',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 40,
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
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P10150_SEL_ASSOC is not null',
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
s:=s||'select sid as "SID", '||chr(10)||
'       decode(file_sid, :p0_obj, htmldb_item.checkbox(1, sid), ''&nbsp;'') as "Remove",'||chr(10)||
'       file_id as "File ID",'||chr(10)||
'       decode(file_sid, :p0_obj,''<a href="javascript:ToggleSubstantive('' || '''''''' || activity_sid || '''''''' || '');" id="'' || activity_sid || ''" title="Toggle Field">'' || decode(substantive,''Y'',''Yes'',''No'') || ''</a>'',decode(substantive,''Y'',''Yes'',''No'')) as "Substantive';

s:=s||'",'||chr(10)||
'       activity_id as "Activity ID", '||chr(10)||
'       activity_type_desc as "Type of Activity", '||chr(10)||
'       osi_object.get_tagline_link(activity_sid) as "Activity Title",'||chr(10)||
'       activity_date as "Activity Date",'||chr(10)||
'       activity_unit_assigned as "Assigned Unit",'||chr(10)||
'       activity_suspense_date as "Suspense Date", '||chr(10)||
'       activity_complete_date as "Completed", '||chr(10)||
'       activity_close_date as "Closed", '||chr(10)||
'       de';

s:=s||'code(sid, :P10150_SEL_ASSOC, ''Y'', ''N'') as "Current",'||chr(10)||
'       ''<a href="'' ||'||chr(10)||
'       ''javascript:popup({page:5060,'' || '||chr(10)||
'            ''clear_cache:''''5060'''','' ||'||chr(10)||
'            ''item_names:''''P5060_OBJ'''','' || '||chr(10)||
'            ''item_values:'' || '''''''' || ACTIVITY_SID || '''''''' || '','' ||'||chr(10)||
'            ''height:550});">'' ||'||chr(10)||
'            ''<IMG SRC="#IMAGE_PREFIX#themes/osi/notes.gif"'' ||'||chr(10)||
'            '' alt="View IDP Notes">';

s:=s||''' ||'||chr(10)||
'            ''</a>'' as "Notes Pop-Up",'||chr(10)||
'            osi_util.get_report_menu(activity_sid) as "Reports"'||chr(10)||
'  from v_osi_assoc_fle_act &P10150_FILTERS.';

wwv_flow_api.create_report_region (
  p_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 10150,
  p_name=> 'Associated Activities',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '300000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No associations found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '300000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P10150_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'select sid as "SID", decode(file_sid, :p0_obj, htmldb_item.checkbox(1, sid), ''&nbsp;'') as "Remove",'||chr(10)||
'       activity_id as "ID", osi_object.get_tagline_link(activity_sid) as "Title",'||chr(10)||
'       activity_type_desc as "Type", to_char(activity_complete_date, :fmt_date) as "Complete Date", to_char(activity_close_date, :fmt_date) as "Close Date", decode(sid, :P10150_SEL_ASSOC, ''Y'', ''N'') as "Current"'||chr(10)||
'  from v_osi_assoc_fle_act &P10150_FILTERS.');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8245314419308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
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
  p_id=> 8245414250308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Remove',
  p_column_display_sequence=> 3,
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
  p_id=> 8245529601308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'File ID',
  p_column_display_sequence=> 4,
  p_column_heading=> 'File ID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_when_cond_type=> 'PLSQL_EXPRESSION',
  p_display_when_condition=> ':P10150_ASSOCIATION_FILTER IS NOT NULL AND :P10150_ASSOCIATION_FILTER!=''ME''',
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
  p_id=> 13689902695914164 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Substantive',
  p_column_display_sequence=> 5,
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
  p_id=> 8245620631308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Activity ID',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Activity ID',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>2,
  p_disable_sort_column=>'N',
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
  p_id=> 8245715256308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Type of Activity',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Type of Activity',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 8245816184308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Title',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Activity Title',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 8245907378308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Activity Date',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Activity Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 8246007468308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Assigned Unit',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Assigned Unit',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 8246111752308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Suspense Date',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Suspense Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 8246230319308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'Completed',
  p_column_display_sequence=> 12,
  p_column_heading=> 'Completed',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 8246318586308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'Closed',
  p_column_display_sequence=> 13,
  p_column_heading=> 'Closed',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 8246408515308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 13,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 14,
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
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8246513515308531 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 14,
  p_form_element_id=> null,
  p_column_alias=> 'Notes Pop-Up',
  p_column_display_sequence=> 2,
  p_column_heading=> '&nbsp;',
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
  p_id=> 8253431837864029 + wwv_flow_api.g_id_offset,
  p_region_id=> 89680238150812062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 15,
  p_form_element_id=> null,
  p_column_alias=> 'Reports',
  p_column_display_sequence=> 15,
  p_column_heading=> 'Reports',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 89681107763812106 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 10,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_ADD. Association',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:openLocator(''301'',''P10150_ASSOC_ACT'',''Y'',''&P10150_EXCLUDE_SIDS.'',''OPEN'','''','''',''Choose Activities...'',''ACT'',''&P0_OBJ.'');',
  p_button_condition=> ':P10150_USER_HAS_ADD_ASSOC_PRV = ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_button_comment=>'javascript:popupLocator(300,''P10150_ASSOC_ACT'',''Y'',''&P10150_EXCLUDE_SIDS.'');'||chr(10)||
''||chr(10)||
'javascript:popup({page:150,'||chr(10)||
'                      name:''ASSOC&P0_OBJ.'','||chr(10)||
'                      clear_cache:''150'','||chr(10)||
'                      item_names:''P150_VIEW,P150_RETURN_ITEM,P150_EXCLUDE_ITEMS'','||chr(10)||
'item_values:''OSI.LOC.ACT,P10150_ASSOC_ACT,&P10150_EXCLUDE_SIDS.''});',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6734629761804450 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 40,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'CC_SEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Complete and Close Selected Activities',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6738907897119887 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 50,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'CC_ALL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Complete and Close All Activities',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 12169205577672840 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 110,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Association(s)',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE_MULTI'');',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6862013070205275 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 70,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6861415709196515 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 80,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P10150_NAR_WRITABLE = ''Y'''||chr(10)||
'and'||chr(10)||
':P10150_ACT_IS_RESTRICTED <> ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 6886528193401900 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 90,
  p_button_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_DELETE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_DELETE. Association',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmDelete(htmldb_delete_message,''DELETE'');',
  p_button_condition=> ':P10150_ACTIVITY_IS_INHERITED <> ''Y''',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15698111556878178 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 10150,
  p_button_sequence=> 100,
  p_button_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 10150);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>89394529572684714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 23-APR-2009 17:07 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>5505629590450153 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:10150:&SESSION.::&DEBUG.:::#&P10150_SEL_ASSOC.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 15,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST = ''SAVE'' OR :REQUEST LIKE ''EDIT_%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-DEC-2009 15:58 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>5571516155664872 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_branch_action=> 'f?p=&APP_ID.:10150:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 29-APR-2009 13:45 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2401708022751679 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ASSOCIATION_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 2401416207751675+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'ME',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Activities for this File;ME,Inherited Activities;I_ACT',
  p_lov_columns=> 4,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''UPDATE'');"',
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
  p_id=>2402416254780095 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_FILTERS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_FILTERS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_id=>6747927636475617 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_LIST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_ACT_LIST',
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
  p_id=>6793832258527885 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_SEL_ASSOC',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_SEL_ASSOC',
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
  p_id=>6794710703540540 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 85,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'NARRATIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 10000,
  p_cMaxlength=> 30000,
  p_cHeight=> 15,
  p_tag_attributes  => 'style="width:100%;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT-BOTTOM',
  p_display_when=>':P10150_ACT_IS_RESTRICTED <> ''Y'''||chr(10)||
'and'||chr(10)||
':P10150_USER_HAS_ACT_ACCESS_PRV = ''Y''',
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
  p_id=>6795132520546882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 84,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>6860502634173814 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NAR_WRITABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 83,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
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
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>6871326968587746 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACT_IS_RESTRICTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 81,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
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
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>6873607538629464 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_NARRATIVE_UNAVAIL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 86,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative',
  p_source=>'This activity is restricted and the Narrative is not viewable from this screen. <br> Please open the activity to view the Narrative.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap" style="width:99%;"',
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P10150_ACT_IS_RESTRICTED = ''Y'' or'||chr(10)||
':P10150_ACT_IS_RESTRICTED is null',
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
  p_id=>6887606647490262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ACTIVITY_IS_INHERITED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 82,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
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
  p_cattributes_element=>'style="width:99%;"',
  p_tag_attributes  => 'style="width:99%;"',
  p_tag_attributes2=> 'style="width:99%;"',
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
  p_id=>7143022926607964 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_FAILURE_COUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_ERROR_DETECTED',
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
  p_id=>7190808782826134 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_USER_HAS_ACT_ACCESS_PRV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_USER_HAS_ACT_ACCESS_PRV',
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
  p_id=>7192019012942668 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_USER_HAS_ADD_ASSOC_PRV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_USER_HAS_ADD_ASSOC_PRV',
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
  p_id=>8250609739619477 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_REPORTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 87,
  p_item_plug_id => 6794424078534921+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_util.get_report_menu(:P10150_ACT_SID);',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when_type=>'NEVER',
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
  p_id=>12314423010727898 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER ',
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
  p_id=>12314632014730469 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER_2',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER_2',
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
  p_id=>12314805826732391 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_MESSAGE_TO_USER_3',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_MESSAGE_TO_USER_3',
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
  p_id=>15698319521880437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
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
  p_id=>89680926290812099 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_ASSOC_ACT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Assoc File',
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
  p_id=>89755622150846418 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 10150,
  p_name=>'P10150_EXCLUDE_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 89680238150812062+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'P10150_EXCLUDE_SIDS',
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

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6523830657956645 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_validation_name => 'Selected Activities - Assure Something Selected',
  p_validation_sequence=> 10,
  p_validation => 'begin'||chr(10)||
'    if (apex_application.g_f01.count >= 1) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'No activities have been selected.',
  p_when_button_pressed=> 6734629761804450 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 6754527420835112 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_validation_name => 'Assure Activities Exist (For CC/All only)',
  p_validation_sequence=> 20,
  p_validation => 'declare'||chr(10)||
'    v_cnt   number;'||chr(10)||
'begin'||chr(10)||
'    select count(sid)'||chr(10)||
'      into v_cnt'||chr(10)||
'      from v_osi_assoc_fle_act'||chr(10)||
'     where file_sid = :p0_obj;'||chr(10)||
''||chr(10)||
'    if (v_cnt >= 1) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'No Activites exist that may be closed.',
  p_when_button_pressed=> 6738907897119887 + wwv_flow_api.g_id_offset,
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
p:=p||'update t_osi_activity set narrative=:p10150_narrative'||chr(10)||
' where sid = :p10150_act_sid;';

wwv_flow_api.create_page_process(
  p_id     => 7712912109312509 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update Narratizzle',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>6861415709196515 + wwv_flow_api.g_id_offset,
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'       v_temp            varchar2(4000);'||chr(10)||
'       v_act_sid         t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'       v_failure_count   number                                  := 0;'||chr(10)||
'       v_failed_acts     varchar2(4000);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     v_temp := replace(:p10150_assoc_act, '':'', ''~'');'||chr(10)||
'     :P10150_MESSAGE_TO_USER_3 := '''';'||chr(10)||
'     :P10150_FAILURE_COUNT := 0;'||chr(10)||
'     :P10150_MESSAGE_TO_USER := ''All Activi';

p:=p||'ties were associated.'';'||chr(10)||
'     :P10150_MESSAGE_TO_USER_2 := '''';'||chr(10)||
'     v_failed_acts := ''Titles of Failed Activities: '';'||chr(10)||
''||chr(10)||
'     for i in 1 .. core_list.count_list_elements(v_temp)'||chr(10)||
'     loop'||chr(10)||
'         v_act_sid := core_list.get_list_element(v_temp,i);'||chr(10)||
''||chr(10)||
'         for k in (select restriction from t_osi_activity where sid = v_act_sid)'||chr(10)||
'         loop'||chr(10)||
'             if (osi_reference.lookup_ref_code(k.restrictio';

p:=p||'n) = ''NONE'') then'||chr(10)||
'  '||chr(10)||
'               insert into t_osi_assoc_fle_act (activity_sid, file_sid) values (v_act_sid, :p0_obj);'||chr(10)||
''||chr(10)||
'             else'||chr(10)||
''||chr(10)||
'               v_failure_count := v_failure_count + 1;'||chr(10)||
'               v_failed_acts := v_failed_acts || osi_activity.get_title(v_act_sid) || ''. '';'||chr(10)||
''||chr(10)||
'             end if;'||chr(10)||
''||chr(10)||
'         end loop;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAG';

p:=p||'E_ID, '''');'||chr(10)||
'     :P10150_FAILURE_COUNT := v_failure_count;'||chr(10)||
''||chr(10)||
'     if :P10150_FAILURE_COUNT > 0 then'||chr(10)||
'  '||chr(10)||
'       :P10150_MESSAGE_TO_USER_2 :=  ''Associate these activities to this file from the activity itself.'';'||chr(10)||
'       :P10150_MESSAGE_TO_USER   := ''Note: ['' || :P10150_FAILURE_COUNT || ''] activities were not associated due to restriction.'';'||chr(10)||
'       :P10150_MESSAGE_TO_USER_3 :=  v_failed_acts;'||chr(10)||
''||chr(10)||
'     end i';

p:=p||'f;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89696016285177781 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Associations',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'P10150_ASSOC_ACT',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG. <br> &P10150_MESSAGE_TO_USER. <br> &P10150_MESSAGE_TO_USER_2.  <br><br> &P10150_MESSAGE_TO_USER_3.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'OSI.LOC.ACT'||chr(10)||
''||chr(10)||
'declare'||chr(10)||
'    v_temp            varchar2(4000);'||chr(10)||
'    v_act_sid         t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'    v_failure_count   number                                  := 0;'||chr(10)||
'begin'||chr(10)||
'    v_temp := replace(:p10150_assoc_act, '':'', ''~'');'||chr(10)||
'    :P10150_FAILURE_COUNT := 0;'||chr(10)||
''||chr(10)||
'    for i in 1 .. core_list.count_list_elements(v_temp)'||chr(10)||
'    loop'||chr(10)||
'        v_act_sid := core_list.get_list_element(v_temp,i);'||chr(10)||
''||chr(10)||
'        for k in (select restriction'||chr(10)||
'                    from t_osi_activity'||chr(10)||
'                   where sid = v_act_sid)'||chr(10)||
'        loop'||chr(10)||
'            if (osi_reference.lookup_ref_code(k.restriction) = ''NONE'') then'||chr(10)||
'                insert into t_osi_assoc_fle_act'||chr(10)||
'                            (activity_sid, file_sid)'||chr(10)||
'                     values (v_act_sid, :p0_obj);'||chr(10)||
'            else'||chr(10)||
'                v_failure_count := v_failure_count + 1;'||chr(10)||
'            end if;'||chr(10)||
'        end loop;'||chr(10)||
'    end loop;'||chr(10)||
'    :P0_DIRTY := replace(:P0_DIRTY, '':'' || :APP_PAGE_ID, '''');'||chr(10)||
'    :P10150_FAILURE_COUNT := v_failure_count;'||chr(10)||
'end;'||chr(10)||
''||chr(10)||
''||chr(10)||
'&SUCCESS_MSG. <br> Note: [&P10150_FAILURE_COUNT.] activities were not associated due to restriction.  <br> If any exist, associate these activities to this file from the activity itself.'||chr(10)||
''||chr(10)||
'');
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
'        delete from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'              where sid = :P10150_SEL_ASSOC;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89695812822176774 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Association',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'DELETE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'declare'||chr(10)||
'    v_temp    varchar2(4000)                          := ''~'';'||chr(10)||
'    v_temp2   t_osi_assoc_fle_act.activity_sid%type;'||chr(10)||
'begin'||chr(10)||
'    if (:request = ''CC_SEL'') then'||chr(10)||
'        for i in 1 .. apex_application.g_f01.count'||chr(10)||
'        loop'||chr(10)||
'            select activity_sid'||chr(10)||
'              into v_temp2'||chr(10)||
'              from t_osi_assoc_fle_act'||chr(10)||
'             where sid = apex_application.g_f01(i);'||chr(10)||
''||chr(10)||
'            v_temp := ';

p:=p||'v_temp || v_temp2 || ''~'';'||chr(10)||
'        end loop;'||chr(10)||
'    elsif(:request = ''CC_ALL'') then'||chr(10)||
'        for k in (select activity_sid'||chr(10)||
'                    from v_osi_assoc_fle_act'||chr(10)||
'                   where file_sid = :p0_obj)'||chr(10)||
'        loop'||chr(10)||
'            v_temp := v_temp || k.activity_sid || ''~'';'||chr(10)||
'        end loop;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    :p10150_act_list := v_temp;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6748104218478317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Activity List - CC',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST IN (''CC_SEL'', ''CC_ALL'')',
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
'    for I in 1 .. HTMLDB_APPLICATION.G_F01.count'||chr(10)||
'    loop'||chr(10)||
'        delete from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'              where sid = HTMLDB_APPLICATION.G_F01 (I);'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 12168928648670019 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Delete Associations',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'DELETE_MULTI',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'P10150_SEL_ASSOC,P10150_ASSOC_ACT,P10150_ACT_SID,P10150_NAR_WRITABLE,P10150_NARRATIVE';

wwv_flow_api.create_page_process(
  p_id     => 6863323375227179 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Fields',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST in (''DELETE'') or :REQUEST like ''EDIT_%''',
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
'    :p10150_sel_assoc := substr(:request, 6);'||chr(10)||
''||chr(10)||
'    select activity_sid'||chr(10)||
'      into :p10150_act_sid'||chr(10)||
'      from v_osi_assoc_fle_act'||chr(10)||
'     where sid = substr(:request, 6);'||chr(10)||
''||chr(10)||
'--Check for privileges'||chr(10)||
'    if (:p10150_act_sid is not null) then'||chr(10)||
'        :p10150_user_has_act_access_prv :='||chr(10)||
'                           osi_auth.check_for_priv(''ACCESS'', core_obj.get_objtype(:p10150_act_sid));'||chr(10)||
'    else'||chr(10)||
'        ';

p:=p||':p10150_user_has_act_access_prv := ''N'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6793523254525212 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Association',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
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
p:=p||'P10150_NARRATIVE';

wwv_flow_api.create_page_process(
  p_id     => 6862823936217884 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Fields - On Cancel',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>6862013070205275 + wwv_flow_api.g_id_offset,
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
'--Get Writability'||chr(10)||
'    if (:p10150_act_sid is not null) then'||chr(10)||
'        :p10150_nar_writable := osi_object.check_writability(:p10150_act_sid, null);'||chr(10)||
'    else'||chr(10)||
'        :p10150_nar_writable := ''N'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'--Get Restriction'||chr(10)||
'    for k in (select restriction'||chr(10)||
'                from t_osi_activity'||chr(10)||
'               where sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        if (osi_reference.lookup_ref_code(k.restri';

p:=p||'ction) = ''NONE'') then'||chr(10)||
'            :p10150_act_is_restricted := ''N'';'||chr(10)||
'        else'||chr(10)||
'            :p10150_act_is_restricted := ''Y'';'||chr(10)||
'        end if;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'--See if selected activity is inherited'||chr(10)||
'    :p10150_activity_is_inherited := ''Y'';'||chr(10)||
''||chr(10)||
'    for k in (select *'||chr(10)||
'                from t_osi_assoc_fle_act'||chr(10)||
'               where file_sid = :p0_obj and activity_sid = :p10150_act_sid)'||chr(10)||
'    loop'||chr(10)||
'        :p';

p:=p||'10150_activity_is_inherited := ''N'';'||chr(10)||
'        return;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'--Get privileges'||chr(10)||
'    :P10150_USER_HAS_ADD_ASSOC_PRV := osi_auth.check_for_priv(''ASSOC_ACT'', :P0_OBJ_TYPE_SID);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 6860713023176854 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 5,
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v_add_or   boolean := false;'||chr(10)||
'begin'||chr(10)||
'    :p10150_filters := ''where '';'||chr(10)||
''||chr(10)||
'    if (instr(:p10150_association_filter, ''ME'') > 0 or'||chr(10)||
'         :P10150_ASSOCIATION_FILTER is null ) then'||chr(10)||
'        v_add_or := true;'||chr(10)||
''||chr(10)||
'        :p10150_filters := :p10150_filters || '' FILE_SID = '' || '''''''' || :P0_OBJ || '''''''';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if (instr(:p10150_association_filter, ''I_ACT'') > 0) then'||chr(10)||
'        if (v_add_or) t';

p:=p||'hen'||chr(10)||
'            :p10150_filters := :p10150_filters || '' or '';'||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'        :p10150_filters :='||chr(10)||
'            :p10150_filters'||chr(10)||
'            || '' activity_sid in(select activity_sid'||chr(10)||
'                  from v_osi_assoc_fle_act'||chr(10)||
'                 where file_sid in(select that_file'||chr(10)||
'                                     from v_osi_assoc_fle_fle'||chr(10)||
'                                    where this_file = ''''';

p:=p||''''||chr(10)||
'            || :p0_obj || ''''''))'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 2402129282774346 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Build WHERE clause',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    V_SID_LIST   varchar2 (5000) := ''SIDS_'';'||chr(10)||
'begin'||chr(10)||
'    for K in (select ACTIVITY_SID'||chr(10)||
'                from T_OSI_ASSOC_FLE_ACT'||chr(10)||
'               where FILE_SID = :P0_OBJ)'||chr(10)||
'    loop'||chr(10)||
'        V_SID_LIST := V_SID_LIST || ''~'' || K.ACTIVITY_SID;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    :P10150_EXCLUDE_SIDS := V_SID_LIST;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 89756414232872546 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Exclude SID List',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'F|#OWNER#:T_OSI_ACTIVITY:P10150_ACT_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 6794823170544140 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 10150,
  p_process_sequence=> 30,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P10150_ACT_SID is not null',
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
-- ...updatable report columns for page 10150
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

 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   06:50 Wednesday May 9, 2012
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

PROMPT ...Remove page 20000
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>20000);
 
end;
/

 
--application/pages/page_20000
prompt  ...PAGE 20000: Activity Summary
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
'  function restrictionWarning(){'||chr(10)||
'     alert(''Please coordinate with HQ OPR before restricting this object'');'||chr(10)||
'  }'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'"JS_SEND_REQUEST"';

wwv_flow_api.create_page(
  p_id     => 20000,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Activity Summary',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89997626141511567+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120509064939',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '25-AUG-2010  J.Faris CHG0003228 - Updated P20000_DATE_LABEL to handle Open Case Checklist, AV support object types.'||chr(10)||
'04-OCT-2010  J.Faris CHG0003243 - Updated P20000_DATE_LABEL to handle all remaining activity types.'||chr(10)||
'06-OCT-2010  J.Faris   WCHG0000397 - Integrated Tim Ward''s page updates (involved re-apply of Export button functionality).'||chr(10)||
'07-OCT-2010 J.FARIS WCHG0000360 - Disabled date picker. Removed validation.'||chr(10)||
''||chr(10)||
'27-Oct-2011 - Tim Ward - CR#3822 - Two Items Open at Same Time overwrite :P0_OBJ '||chr(10)||
'                          and cause problems.  Changed all Branching to pass :P0_OBJ.'||chr(10)||
''||chr(10)||
'19-Jan-2012 - Tim Ward - CR#3990 - Enable Restriction for AAPP.'||chr(10)||
''||chr(10)||
'30-Apr-2012 - Tim Ward - CR#4043 - Added Time to Effective Date and Date '||chr(10)||
'                          Recorded.'||chr(10)||
''||chr(10)||
'08-May-2012 - Tim Ward - CR#4045 - Added Substantive checkbox.'||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>20000,p_text=>ph);
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
  p_id=> 91905523013189660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 20000,
  p_plug_name=> '&P20000_ACTIVITY_DESCRIPTION. Activity',
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
  p_plug_query_num_rows => 15,
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
s:=s||'select transition_comment "Action",'||chr(10)||
'       create_by "Performed By",'||chr(10)||
'       effective_on "Effective Date",'||chr(10)||
'       create_on "Date Recorded"'||chr(10)||
'  from t_osi_status_history'||chr(10)||
' where obj = :P0_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 20000,
  p_name=> 'Activity History',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 20,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'QUERY_COLUMNS',
  p_query_num_rows=> '100000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No history found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '100000',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P20000_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 93996144410883352 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'Action',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Action',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 93996215715883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Performed By',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Performed By',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
  p_id=> 93996316299883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Effective Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Effective Date',
  p_column_format=> '&FMT_DATE.  hh24:mi:ss',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_disable_sort_column=>'N',
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
  p_id=> 93996436580883357 + wwv_flow_api.g_id_offset,
  p_region_id=> 93995815537883335 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Date Recorded',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Date Recorded',
  p_column_format=> '&FMT_DATE. hh24:mi:ss',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 91905830978191904 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 10,
  p_button_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16595501977703906 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 30,
  p_button_plug_id => 93995815537883335+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getCSV(null, this, 20000);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 98438532224060568 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 20000,
  p_button_sequence=> 20,
  p_button_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
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
  p_id=>91814539429626660 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST like ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 16-APR-2009 22:15 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>91906139636194429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.::&DEBUG.::P0_OBJ:&P20000_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>91905830978191904+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 17-APR-2009 12:55 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>92847723654200564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_branch_action=> 'f?p=&APP_ID.:20000:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P20000_SID.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 30,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 01-MAY-2009 13:02 by DIBBLE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3119025248737365 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
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
  p_id=>5431035720360469 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION_LOCKOUT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction Lockout',
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
  p_id=>13686321518853353 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SUBSTANTIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Substantive Investigative Activity?',
  p_source=>'SUBSTANTIVE',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>16595722755709887 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 93995815537883335+wwv_flow_api.g_id_offset,
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
  p_id=>91940231689043741 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATE_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Created By',
  p_source=>'CREATE_BY',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>91940416236048785 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATING_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Creating Unit',
  p_source=>'CREATING_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
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
  p_id=>91944639569415069 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CURRENT_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Current Status',
  p_source=>'CURRENT_STATUS',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>91944839694415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CREATE_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Created',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'CREATE_ON',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>91945042497415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ASSIGNED_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Assigned Unit',
  p_source=>'ASSIGNED_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
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
  p_id=>91945235641415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_AUXILIARY_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Auxiliary Unit',
  p_source=>'AUXILIARY_UNIT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
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
  p_id=>91945435701415071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SUSPENSE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Suspense Date',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'SUSPENSE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
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
  p_id=>91945636024415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_COMPLETE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Completed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'COMPLETE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>91945843973415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_CLOSE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 19,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date Closed',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'CLOSE_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
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
  p_id=>91946019995415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Restriction',
  p_source=>'RESTRICTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P20000_RESTRICTION_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_tag_attributes  => '&P20000_RESTRICTION_LOCKOUT. onchange="restrictionWarning()"',
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
  p_id=>91946237380415072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_INV_SUPPORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Investigative Support',
  p_source=>'INV_SUPPORT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'CHECKBOX',
  p_lov => 'select description, sid'||chr(10)||
'  from t_osi_mission_category'||chr(10)||
' where notification_area = ''Y'''||chr(10)||
' order by seq',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 7,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 10,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>94784018045123213 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char('||chr(10)||
'   to_date(:P20000_ACTIVITY_DATE_VALUE, :FMT_DATE || '' '' || :FMT_TIME), '||chr(10)||
'   :FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'&P20000_DATE_LABEL.',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 12,
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
  p_id=>94791034518317174 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
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
  p_id=>94932146476602702 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_DATE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'begin'||chr(10)||
'  case '||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.INTERVIEW.%'' then'||chr(10)||
'         return ''Interview Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE in (''ACT.DOCUMENT_REVIEW'','||chr(10)||
'                                 ''ACT.RECORDS_CHECK'','||chr(10)||
'                                 ''ACT.CC_REVIEW'','||chr(10)||
'                                 ''ACT.OC_REVIEW'') then'||chr(10)||
'          return ''Review Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''ACT.BRIEFING'' then'||chr(10)||
'          return ''Briefing Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE = ''ACT.SURVEILLANCE'' then'||chr(10)||
'          return ''Requested Start Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.FINGERPRINT.%'' then'||chr(10)||
'         return ''Date Fingerprints Taken'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.SUSPACT_REPORT'' then'||chr(10)||
'         return ''Report Date'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.AV_SUPPORT'' then'||chr(10)||
'         return ''Date Request Received'';'||chr(10)||
'      when :P0_OBJ_TYPE_CODE like ''ACT.COMP_INTRUSION'' then'||chr(10)||
'         return ''CCI Notified Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.INIT_NOTIF'' then'||chr(10)||
'        return ''Notified On'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.SOURCE_MEET'' then'||chr(10)||
'        return ''Meet Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.SEARCH%'' then'||chr(10)||
'        return ''Search Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like  ''ACT.LIAISON'' then'||chr(10)||
'        return ''Liaison Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.CONSULTATION.%'' then'||chr(10)||
'        return ''Consultation Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.COORDINATION.%'' then'||chr(10)||
'        return ''Coordination Date'';'||chr(10)||
'     when :P0_OBJ_TYPE_CODE like ''ACT.POLY_EXAM'' then'||chr(10)||
'        return ''Exam Date'';'||chr(10)||
'   else'||chr(10)||
'        return ''Activity Date'';'||chr(10)||
'   end case;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_id=>96473438013419564 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Title',
  p_post_element_text=>'<td rowspan=10 width="40px"></td>',
  p_source=>'TITLE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
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
  p_id=>97057333623584254 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_RESTRICTION_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
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
  p_id=>101984118218814233 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_name=>'P20000_ACTIVITY_DATE_VALUE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 91905523013189660+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_format_mask=>'&FMT_DATE. &FMT_TIME.',
  p_source=>'ACTIVITY_DATE',
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

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 17733929408342681 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 20000,
  p_computation_sequence => 10,
  p_computation_item=> 'P20000_ACTIVITY_DATE_VALUE',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'QUERY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'select :P20000_ACTIVITY_DATE || '' '' ||'||chr(10)||
'       to_char(activity_date, :FMT_TIME)'||chr(10)||
'  from t_osi_activity'||chr(10)||
' where sid = :P0_OBJ',
  p_compute_when => ':REQUEST = ''SAVE'' and :P20000_ACTIVITY_DATE is not null',
  p_compute_when_type=>'PLSQL_EXPRESSION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 96473647363422286 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_validation_name => 'P20000_TITLE not null',
  p_validation_sequence=> 5,
  p_validation => 'P20000_TITLE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Title must be specified.',
  p_when_button_pressed=> 91905830978191904 + wwv_flow_api.g_id_offset,
  p_associated_item=> 96473438013419564 + wwv_flow_api.g_id_offset,
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
p:=p||'#OWNER#:V_OSI_ACTIVITY_SUMMARY:P20000_SID:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 94795040208479739 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Process Activity Summary',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>91905830978191904 + wwv_flow_api.g_id_offset,
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
p:=p||'F|#OWNER#:V_OSI_ACTIVITY_SUMMARY:P0_OBJ:SID';

wwv_flow_api.create_page_process(
  p_id     => 94790725729305191 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Activity Summary',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
''||chr(10)||
'  :p20000_sid := :p0_obj;'||chr(10)||
''||chr(10)||
'  :p20000_restriction_lov := osi_reference.get_lov(''RESTRICTION'');'||chr(10)||
''||chr(10)||
'  :p20000_restriction_lockout := null;'||chr(10)||
''||chr(10)||
'  select description into :P20000_ACTIVITY_DESCRIPTION '||chr(10)||
'        from t_core_obj_type '||chr(10)||
'        where sid=:P0_OBJ_TYPE_SID;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 97049319144409735 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'    for x in (select default_title'||chr(10)||
'                from t_osi_obj_type'||chr(10)||
'               where (   sid = :p0_obj_type_sid'||chr(10)||
'                      or sid member of osi_object.get_objtypes(:p0_obj_type_sid))'||chr(10)||
'                 and default_title is not null)'||chr(10)||
'    loop'||chr(10)||
'        :p20000_title := x.default_title;'||chr(10)||
'    end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 9338207557266457 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 20000,
  p_process_sequence=> 1,
  p_process_point=> 'ON_SUBMIT_BEFORE_COMPUTATION',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Reset title',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST = ''SAVE'' AND :P20000_TITLE IS NULL',
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
-- ...updatable report columns for page 20000
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

set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
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
--   Date and Time:   10:21 Wednesday August 22, 2012
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Page Export
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
''||chr(10)||
'<script language="javascript">'||chr(10)||
'function showParticWidget(objTypeCode)'||chr(10)||
'{'||chr(10)||
' var participantSID = $v(''P21001_PARTICIPANT'');'||chr(10)||
''||chr(10)||
' $("label[for=P21001_PARTIC_DISPLAY],#P21001_PARTIC_DISPLAY").show();'||chr(10)||
' $(''#FindPartic'').show();'||chr(10)||
''||chr(10)||
' if(participantSID.length > 0)'||chr(10)||
'   $(''#ViewParti';

ph:=ph||'c'').show();'||chr(10)||
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
'function hideField(pID, isDate, isTextAreaWithCounter)'||chr(10)||
'{'||chr(10)||
' var hideText = "label[for="+pID+"],#"+pID;'||chr(10)||
' '||chr(10)||
' $(hideText).hide();'||chr(10)||
''||chr(10)||
' if';

ph:=ph||'(isDate==true)'||chr(10)||
'   {'||chr(10)||
'    $("#"+pID).next().hide();'||chr(10)||
'    $("#"+pID).next().next().hide();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if(isTextAreaWithCounter==true)'||chr(10)||
'   $("#"+pID).next().hide();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function showField(pID, isDate, isTextAreaWithCounter)'||chr(10)||
'{'||chr(10)||
' var hideText = "label[for="+pID+"],#"+pID;'||chr(10)||
''||chr(10)||
' $(hideText).show();'||chr(10)||
''||chr(10)||
' if(isDate==true)'||chr(10)||
'   {'||chr(10)||
'    $("#"+pID).next().show();'||chr(10)||
'    $("#"+pID).next().next().show();'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' if(isTextAreaWithCoun';

ph:=ph||'ter==true)'||chr(10)||
'   $("#"+pID).next().show();'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function makeLabelOptional(pID)'||chr(10)||
'{'||chr(10)||
' var label = "label[for="+pID+"]";'||chr(10)||
''||chr(10)||
' $(label).toggleClass(''optionallabel'', true);'||chr(10)||
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
'function hideShowFields(p';

ph:=ph||'this)'||chr(10)||
'{'||chr(10)||
' var list1Val = $("#P21001_LIST_1").val();'||chr(10)||
' var list1Text = $("#P21001_LIST_1 option:selected").text();'||chr(10)||
' var objTypeCode = $v(''P21001_OBJ_TYPE_CODE'');'||chr(10)||
' var explanationSIDS = $v(''P21001_EXPLANATION_VISIBLE'');'||chr(10)||
''||chr(10)||
' // Hide Optional Items //'||chr(10)||
' hideParticWidget();'||chr(10)||
' hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
' hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
' hideField(''P21001_HOUR'',false,false);'||chr(10)||
' ';

ph:=ph||'hideField(''P21001_MINUTE'',false,false);'||chr(10)||
' hideField(''P21001_HOUR_2'',false,false);'||chr(10)||
' hideField(''P21001_MINUTE_2'',false,false);'||chr(10)||
' hideField(''P21001_DATE_2'',true,false);'||chr(10)||
' hideField(''P21001_DATE_3'',true,false);'||chr(10)||
' hideField(''P21001_DATE_4'',true,false);'||chr(10)||
' hideField(''P21001_DATE_5'',true,false);'||chr(10)||
' hideField(''P21001_TEXT_2'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_3'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_4'',false,t';

ph:=ph||'rue);'||chr(10)||
' hideField(''P21001_TEXT_5'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_7'',false,true);'||chr(10)||
' hideField(''P21001_TEXT_8'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9'',false,false);'||chr(10)||
' hideField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
' hideField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
' ';

ph:=ph||'hideField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
' hideField(''P21001_LIST_1'',false,false);'||chr(10)||
' hideField(''P21001_LIST_2'',false,false);'||chr(10)||
' hideField(''P21001_LIST_3'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
' hideField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
' // Hide File Association if value is passed in //'||chr(10)||
' hideField(''P21001_FILE_NAME'',false,false);'||chr(10)||
' hideField(''P21001_FIND_FILE_WIDGET''';

ph:=ph||',false,false);'||chr(10)||
' if($v(''P21001_FROM_OBJ'')=='''')'||chr(10)||
'   {'||chr(10)||
'    showField(''P21001_FILE_NAME'',false,false);'||chr(10)||
'    showField(''P21001_FIND_FILE_WIDGET'',false,false);'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' // Default Labels to Optional //'||chr(10)||
' makeLabelOptional(''P21001_LIST_1'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_2'');'||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_LIST_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_2'');'||chr(10)||
' makeLabelOptional(''P2';

ph:=ph||'1001_DATE_3'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_4'');'||chr(10)||
' makeLabelOptional(''P21001_DATE_5'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_1_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_2_DISPLAY'');'||chr(10)||
' makeLabelOptional(''P21001_PRECISION_DATE_3_DISPLAY'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_TEXT_1'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_2'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_3'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_4';

ph:=ph||''');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_5'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_6'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_7'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_8'');'||chr(10)||
' makeLabelOptional(''P21001_TEXT_9'');'||chr(10)||
' makeLabelOptional(''P21001_DOCUMENT_NUMBER'');'||chr(10)||
' makeLabelOptional(''P21001_EXPLANATION'');'||chr(10)||
' '||chr(10)||
' makeLabelOptional(''P21001_HOUR'');'||chr(10)||
' makeLabelOptional(''P21001_HOUR_2'',false,false);'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_RADIOGROU';

ph:=ph||'P_1'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_2'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_3'');'||chr(10)||
' makeLabelOptional(''P21001_RADIOGROUP_4'');'||chr(10)||
''||chr(10)||
' makeLabelOptional(''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
' switch(objTypeCode)'||chr(10)||
'       {'||chr(10)||
'                        case ''ACT.AAPP'':'||chr(10)||
'        case ''ACT.AAPP.DOCUMENT_REVIEW'':'||chr(10)||
'              case ''ACT.AAPP.EDUCATION'':'||chr(10)||
'             case ''ACT.AAPP.EMPLOYMENT'':'||chr(10)||
'              case ''AC';

ph:=ph||'T.AAPP.INTERVIEW'':'||chr(10)||
'          case ''ACT.AAPP.RECORDS_CHECK'':'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                  case ''ACT.AV_SUPPORT'':'||chr(10)||
'                                        showField(''P21001_LIST_1'');'||chr(10)||
'                                        showField(''P21001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                         ';

ph:=ph||'               showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                    case ''ACT.BRIEFING'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        brea';

ph:=ph||'k;'||chr(10)||
''||chr(10)||
'              case ''ACT.COMP_INTRUSION'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_3'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                             ';

ph:=ph||'           showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_1'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_PRECISION_DATE_3'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_PRECIS';

ph:=ph||'ION_DATE_1_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                        showField(''P21001_TEXT_8'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'             case ''ACT.DOCUMENT_REVIEW'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        make';

ph:=ph||'LabelRequired(''P21001_LIST_1'');'||chr(10)||
''||chr(10)||
'                                        if(explanationSIDS.indexOf(list1Val+''~'')>=0)'||chr(10)||
'                                          {'||chr(10)||
'                                           hideField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           showField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                          }'||chr(10)||
'               ';

ph:=ph||'                         else'||chr(10)||
'                                          {'||chr(10)||
'                                           showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                           hideField(''P21001_EXPLANATION'',false,true);'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'          case ''ACT.FINGERPRINT.MANUAL'':'||chr(10)||
'              ';

ph:=ph||'                          makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                  case ''ACT.INIT_NOTIF'':'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                     ';

ph:=ph||'   break;'||chr(10)||
'  '||chr(10)||
'           case ''ACT.INTERVIEW.SUBJECT'':'||chr(10)||
'            case ''ACT.INTERVIEW.VICTIM'':'||chr(10)||
'           case ''ACT.INTERVIEW.WITNESS'':'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;';

ph:=ph||''||chr(10)||
''||chr(10)||
''||chr(10)||
'                     case ''ACT.LIAISON'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
''||chr(10)||
'                                        if(';

ph:=ph||'list1Text!=''- Select -'')'||chr(10)||
'                                          {'||chr(10)||
'                                           if ($("#P21001_TITLE").val().length>0)'||chr(10)||
'                                             {'||chr(10)||
'                                              $("#P21001_LIST_1 option").each(function(i)'||chr(10)||
'                                               {'||chr(10)||
'                                                $("#P21001_TITL';

ph:=ph||'E").val($("#P21001_TITLE").val().replace($(this).text(),list1Text));'||chr(10)||
'                                               });'||chr(10)||
'                                             }'||chr(10)||
'                                           else'||chr(10)||
'                                             {'||chr(10)||
'                                              $("#P21001_TITLE").val(list1Text);'||chr(10)||
'                                             }'||chr(10)||
'          ';

ph:=ph||'                                }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.MEDIA_ANALYSIS'':'||chr(10)||
'                                        showField(''P21001_DATE_2'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_3'',true,false);'||chr(10)||
'                                        showField(''P21001_DATE_4'',true,false);'||chr(10)||
'                                      ';

ph:=ph||'  showField(''P21001_DATE_5'',true,false);'||chr(10)||
'                                        showField(''P21001_TEXT_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_3'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_4'',false,true);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                  ';

ph:=ph||'      showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_DATE_2'');'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                   case ''ACT.POLY_EXAM'':'||chr(10)||
'                                 ';

ph:=ph||'       showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                        showField(''P21001_HOUR_2'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_5'',false,false);'||chr(10)||
'                                 ';

ph:=ph||'       showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
'            ';

ph:=ph||'   case ''ACT.RECORDS_CHECK'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_DOCUMENT_NUMBER'',false,false);'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        makeLabelRequired(''P21';

ph:=ph||'001_LIST_1'');'||chr(10)||
'                                        buildRecordsCheckNarrativeandTitle();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                      case ''ACT.SEARCH'':'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        makeLabelRequired(''';

ph:=ph||'P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
'                                        if(list1Text==''Search of Person'')'||chr(10)||
'                                          {'||chr(10)||
'                                           $(''#P21001_TEXT_6_LABEL'').val('''');'||chr(10)||
'                                           hideField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                         ';

ph:=ph||'                  showParticWidget();'||chr(10)||
'                                          }'||chr(10)||
'                                        else'||chr(10)||
'                                          {'||chr(10)||
'                                           if(list1Text!=''- Select -'')'||chr(10)||
'                                             {'||chr(10)||
'                                              $(''#P21001_TEXT_6_LABEL'').val(''Explanation'');'||chr(10)||
'                   ';

ph:=ph||'                           showField(''P21001_TEXT_6'',false,false);'||chr(10)||
'                                              makeLabelRequired(''P21001_TEXT_6'');'||chr(10)||
'                                              hideParticWidget();'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                 case ''ACT.SOURCE_MEET'':'||chr(10)||
'     ';

ph:=ph||'                                   showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        makeLabelRequired(''P21001_PARTIC_DISPLAY'');'||chr(10)||
'                                        showField(''P21001_TEXT_7'',false,true);'||chr(10)||
'                                        showField(''P21001_HOUR'',false,false);'||chr(10)||
'                                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'    ';

ph:=ph||'                                    makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                        showParticWidget();'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                case ''ACT.SURVEILLANCE'':'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_2'',false,false);'||chr(10)||
'         ';

ph:=ph||'                               showField(''P21001_RADIOGROUP_3'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_4'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                        showField(''P21001_TEXT_9'',false,false';

ph:=ph||');'||chr(10)||
'                                        showField(''P21001_TEXT_9_SUFFIX'',false,false);'||chr(10)||
'                                        showField(''P21001_ADDRESS_DISPLAY'',false,false);'||chr(10)||
'                                        showField(''P21001_ADDRESS_WIDGET'',false,false);'||chr(10)||
''||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                                        makeLabelR';

ph:=ph||'equired(''P21001_RADIOGROUP_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001_RADIOGROUP_3'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'                                        makeLabelRequired(''P21001_TEXT_9'');'||chr(10)||
'                                        makeLabelRequired(';

ph:=ph||'''P21001_ADDRESS_DISPLAY'');'||chr(10)||
''||chr(10)||
'                                        if(typeof pthis !== "undefined") '||chr(10)||
'                                          {'||chr(10)||
'                                           if(pthis.id==''P21001_LIST_1'')'||chr(10)||
'                                             {'||chr(10)||
'                                              var get = new htmldb_Get(null,'||chr(10)||
'                                                         ';

ph:=ph||'              $v(''pFlowId''),'||chr(10)||
'                                                                       ''APPLICATION_PROCESS=Get_Act_Surveillance_Techniques'','||chr(10)||
'                                                                       $v(''pFlowStepId''));'||chr(10)||
'                                              get.addParam(''x01'',list1Val);'||chr(10)||
'                                              gReturn = $.trim(get.get());'||chr(10)||
'   ';

ph:=ph||'                                           $("#P21001_LIST_2_LOV").val(gReturn);'||chr(10)||
'  '||chr(10)||
'                                              $(''#P21001_LIST_2'').children().remove().end().append(''<option selected value="%null%">- Select -</option>'');'||chr(10)||
'                                              var items = gReturn.split(","), i;'||chr(10)||
''||chr(10)||
'                                              for (i = 0; i < items.length; i++';

ph:=ph||') '||chr(10)||
'                                                 {'||chr(10)||
'                                                  if(items[i].length>0)'||chr(10)||
'                                                    {'||chr(10)||
'                                                     var values = items[i].split('';'');'||chr(10)||
'                                                     $(''#P21001_LIST_2'').children().end().append(''<option value="''+values[1]+''">''+val';

ph:=ph||'ues[0]+''</option>'');'||chr(10)||
'                                                    }'||chr(10)||
'                                                 }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
'  '||chr(10)||
'              case ''ACT.SUSPACT_REPORT'':'||chr(10)||
'                                        makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'                ';

ph:=ph||'                        makeLabelRequired(''P21001_RADIOGROUP_1'');'||chr(10)||
'                                        showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                        showField(''P21001_RADIOGROUP_1'',false,false);'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
'                                default:'||chr(10)||
'                                        if ($(''#P21001_OBJ_TYPE_CODE'').val().su';

ph:=ph||'bstring(0,16)==''ACT.CONSULTATION'' || $(''#P21001_OBJ_TYPE_CODE'').val().substring(0,16)==''ACT.COORDINATION'')'||chr(10)||
'                                          {'||chr(10)||
'                                           // Adjust the Title //'||chr(10)||
'                                           adjustCoordinationConsultationTitle();'||chr(10)||
''||chr(10)||
'                                           showField(''P21001_HOUR'',false,false);'||chr(10)||
'                   ';

ph:=ph||'                        showField(''P21001_MINUTE'',false,false);'||chr(10)||
'                                           showField(''P21001_LIST_1'',false,false);'||chr(10)||
'                                           showField(''P21001_LIST_2'',false,false);'||chr(10)||
'                                           makeLabelRequired(''P21001_HOUR'');'||chr(10)||
'                                           makeLabelRequired(''P21001_LIST_1'');'||chr(10)||
'              ';

ph:=ph||'                             makeLabelRequired(''P21001_LIST_2'');'||chr(10)||
'  '||chr(10)||
'                                           // Make sure there is at least one Coordination/Consultation Type in the Select List //'||chr(10)||
'                                           var list = document.getElementById(''P21001_LIST_1'');'||chr(10)||
'                                           if(list!=null)'||chr(10)||
'                                             {'||chr(10)||
'';

ph:=ph||'                                              if(list.length==1)'||chr(10)||
'                                                {'||chr(10)||
'                                                 if(list[0].text=''- Select -'')'||chr(10)||
'                                                   {'||chr(10)||
'                                                    alert(''You are not authorized to create any types of ''+'||chr(10)||
'                                             ';

ph:=ph||'             $("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activities.\n\n''+'||chr(10)||
'                                                          ''Please talk to your Unit Commander about assigning you permissions for ''+$("#P21001_ACTIVITY_DATE_LABEL").val().replace('' Date'','''')+'' Activity Types that you need to create.'');'||chr(10)||
''||chr(10)||
'                                                    window.close();'||chr(10)||
'   ';

ph:=ph||'                                                }'||chr(10)||
'                                                }'||chr(10)||
'                                             }'||chr(10)||
'                                          }'||chr(10)||
'                                        break;'||chr(10)||
''||chr(10)||
''||chr(10)||
'       }'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' hideShowFields();'||chr(10)||
' $(document).attr("title", $v(''P21001_OBJ_TYPE_DESCRIPTION'')+" (Create)");'||chr(10)||
'});'||chr(10)||
'</script>';

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
''||chr(10)||
'function buildRecordsCheckNarrativeandTitle()'||chr(10)||
'{'||chr(10)||
' var docTypetxt = $(''#P21001_LIST_1 > option:selected'').text();'||chr(10)||
' var resultstxt = $(''#P21001_LIST_2 > option:selected'').text();'||chr(10)||
' var docTypeval = $(''#P21001_LIST_1 > option:selected'').val();'||chr(10)||
' var resultsval = $(''#P21001_LIST_2 > option:selected'').val();'||chr(10)||
''||chr(10)||
' if(docTypetxt!=''- Select -'' && resultstxt!=''- Select -'')'||chr(10)||
'   {'||chr(10)||
'    var get = new htmldb_Get(null,'||chr(10)||
'                             $v(''pFlowId''),'||chr(10)||
'                             ''APPLICATION_PROCESS=GET_LERC_DEFAULT_TITLE_NARRATIVE'','||chr(10)||
'                             $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
'    get.addParam(''x01'',docTypeval);'||chr(10)||
'    get.addParam(''x02'',resultsval);'||chr(10)||
' '||chr(10)||
'    gReturn = $.trim(get.get());'||chr(10)||
'    var placeHolder = gReturn.indexOf(''~`~`~`~`'');'||chr(10)||
''||chr(10)||
'    $s(''P21001_TITLE'',gReturn.substring(0,placeHolder));'||chr(10)||
'    $s(''P21001_NARRATIVE'',gReturn.substring(placeHolder+8));'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 93856707457736574+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss => '20120822101559',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '30-Apr-2012 - Tim Ward - CR#4043 - Created to replace ALL Activity Create Pages.'||chr(10)||
''||chr(10)||
'09-May-2012 - Tim Ward - CR#4045 - Added Substantive checkbox.');
 
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
'       OSI_PARTICIPANT.GET_NAME(SUBJECT_OF_ACTIVITY) as "Subject Of Activity",'||chr(10)||
'       REFERENCE_NUMBER,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(RESTRICTION) as "Restriction",'||chr(10)||
'       TITLE,'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Record Type",'||chr(10)||
'       decode(:p21001_select';

s:=s||'ed,sid,''Y'',''N'') "Current",'||chr(10)||
'       OSI_FILE.GET_ID(FILE_SID) AS "File"'||chr(10)||
'FROM T_OSI_A_RECORDS_CHECK_MULTI'||chr(10)||
'WHERE PERSONNEL=:USER_SID';

wwv_flow_api.create_report_region (
  p_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21001,
  p_name=> 'Law Enforcement Records Check to Create',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 12,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21001_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK''',
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
  p_query_no_data_found=> '<b><center>***** No Records Check in the List Yet *****</center></b>',
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
  p_id=> 13133431966888176 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
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
  p_id=> 13134213981888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
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
  p_id=> 13133909173888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Subject Of Activity',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Subject of Activity',
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
  p_id=> 13133501990888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'REFERENCE_NUMBER',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Reference Number',
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
  p_id=> 13134016024888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Restriction',
  p_column_display_sequence=> 8,
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
  p_id=> 13133625860888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'TITLE',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Title',
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
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 10,
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
  p_id=> 13134107013888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'Record Type',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Record Type',
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
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 11,
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
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 13134432753888179 + wwv_flow_api.g_id_offset,
  p_region_id=> 13133232569888170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'File',
  p_column_display_sequence=> 5,
  p_column_heading=> 'File',
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
  p_id             => 13134618725888181 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 30,
  p_button_plug_id => 13133232569888170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_ACTIVITIES',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Activities',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13195012228757431 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 50,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE_ONE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Create Above Activity and Exit',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 13194825949751935 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21001,
  p_button_sequence=> 55,
  p_button_plug_id => 12904705240371170+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add Check to List',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21001_OBJ_TYPE_CODE IN (''ACT.RECORDS_CHECK'');',
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
  p_button_condition=> ':P21001_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'');',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
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
  p_button_condition=> ':P21001_OBJ_TYPE_CODE NOT IN (''ACT.RECORDS_CHECK'');',
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
  p_branch_condition=> ':REQUEST IN (''CREATE'',''CREATE_ONE'');',
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
  p_display_when=>':P21001_PARTICIPANT IS NOT NULL AND'||chr(10)||
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'');',
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'')'||chr(10)||
'AND'||chr(10)||
':P21001_OBJ_TYPE_CODE NOT IN (''ACT.COMP_INTRUSION'');',
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') and :p21001_activity_date is not null',
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
  p_validation_condition=> ':REQUEST IN (''ADD'',''CREATE'',''CREATE_ONE'') AND'||chr(10)||
'(:P21001_OBJ_TYPE_CODE IN (''ACT.DOCUMENT_REVIEW'','||chr(10)||
'                          ''ACT.SEARCH'','||chr(10)||
'                          ''ACT.LIAISON'','||chr(10)||
'                          ''ACT.MEDIA_ANALYSIS'','||chr(10)||
'                          ''ACT.POLY_EXAM'','||chr(10)||
'                          ''ACT.SURVEILLANCE'','||chr(10)||
'                          ''ACT.SUSPACT_REPORT'','||chr(10)||
'                          ''ACT.RECORDS_CHECK'')'||chr(10)||
'OR substr(:P21001_OBJ_TYPE_CODE,1,16) IN (''ACT.CONSULTATION'',''ACT.COORDINATION''));',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
':P21001_OBJ_TYPE_CODE IN (''ACT.MEDIA_ANALYSIS'');',
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
'        v_FieldNames := ''sid,doc_type,explanation,document_number'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p2';

p:=p||'1001_explanation,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_document_number,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_document_review'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'        '||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_Pa';

p:=p||'rticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_fingerprint'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.INIT_NOTIF'' THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''PARTICIPANT'';'||chr(10)||
'        v_ParticipantCode := ''NOTIFIED'';'||chr(10)||
'        v_TableName := ''t_osi_a_init_notification'';'||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :';

p:=p||'P21001_OBJ_TYPE_CODE=''ACT.INTERVIEW.GROUP'' THEN'||chr(10)||
''||chr(10)||
'        v_ActivityDate := :p21001_activity_date;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE IN (''ACT.INTERVIEW.SUBJECT'',''ACT.INTERVIEW.VICTIM'',''ACT.INTERVIEW.WITNESS'') THEN'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''PERSON'';'||chr(10)||
'        v_TableName := ''t_osi_a_interview'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date || '' '' |';

p:=p||'| nvl(:p21001_hour, ''00'') || '':'' || nvl(:p21001_minute, ''00''), :fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.LIAISON'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,liaison_type,liaison_level'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_';

p:=p||'2,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_liaison'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-MON-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.MEDIA_ANALYSIS'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,media_type,media_size,media_size_units,removable_flag,quantity,seizure_date,receive_date,analysis_start_date,analysis_end_date,comments,activity'';'||chr(10)||
'        v_Fie';

p:=p||'ldValues := ''core_sidgen.next_sid'' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_text_2,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || '||chr(10)||
'    ';

p:=p||'                             replace(:p21001_text_3,'''''''','''''''''''') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_2 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_3 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_4 || '''''''' || '','' || '''''''' || '||chr(10)||
'                                 :p21001_date_5 || '''''''' || '','' || '''''''' || '||chr(10)||
'        ';

p:=p||'                         replace(:p21001_text_4,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
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
'        v_FieldValue';

p:=p||'s := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_5,'''''''','''''''''''') || '''''''' || '','' || '||chr(10)||
'''to_date(to_char(to_date('' || '''''''' || :p21001_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '||chr(10)||
'''to_date(to_char(to_date';

p:=p||'('' || '''''''' || :p21001_activity_date || '''''''' || ''),''''yyyymmdd'''')'' || '' ||nvl('' || '''''''' || :p21001_hour_2 || '''''''' || '',''''01'''')'' || '' || nvl('' || '''''''' || :p21001_minute_2 || '''''''' || '',''''00'''') || '' || ''''''00'''''' || '', ''''yyyymmddhh24miss'''')''  || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''null'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantC';

p:=p||'ode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_poly_exam'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,doc_type,reference_num'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'    ';

p:=p||'                             replace(:p21001_document_number,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''PARTICIPANTS'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_records_check'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SEARCH'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,search_basis, explana';

p:=p||'tion'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_6,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_ParticipantUsage := ''SUBJECT'';'||chr(10)||
'        v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'        v_TableName := ''t_osi_a_search'';'||chr(10)||
'        v_ActivityDate := to_date(:p21001_activity_d';

p:=p||'ate, :fmt_date || '' '' || :fmt_time);'||chr(10)||
''||chr(10)||
'        :P21001_OBJ_TYPE_SID:=:p21001_list_1;'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SOURCE_MEET'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''sid,commodity,contact_method'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_text_7,'''''''','''''''''''') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_1,''%null%'',''nu';

p:=p||'ll'') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_source_meet'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || nvl(:p21001_minute,''00'') || ''00'', ''yyyymmddhh24miss'');'||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SURVEILLANCE'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,EMERGENCY,CONSENSUAL,US_LOCATION,ITEM_CASE,INFO_TYPE,TECHNIQUE,REQUESTED_DURATION'';'||chr(10)||
'';

p:=p||'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || :p21001_radiogroup_2 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_3 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 :p21001_radiogroup_4 || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replac';

p:=p||'e(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_list_2,''%null%'',''null'') || '''''''' || '','' || '''''''' ||'||chr(10)||
'                                 replace(:p21001_text_9,'''''''','''''''''''') || '''''''';'||chr(10)||
''||chr(10)||
'        v_TableName := ''t_osi_a_surveillance'';'||chr(10)||
'        v_ActivityDate := to_date(to_char(to_date(:p21001_activity_date),''yyyymmdd'') || nvl(:p21001_hour,''01'') || n';

p:=p||'vl(:p21001_minute,''00'') || ''00'', ''yyyymmddhh24miss'');'||chr(10)||
'        v_AddressUsage := ''ADDR_INTRCPT'';'||chr(10)||
'        v_AddressCode := ''ADDR_INTRCPT'';'||chr(10)||
'      '||chr(10)||
''||chr(10)||
'    WHEN :P21001_OBJ_TYPE_CODE=''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
''||chr(10)||
'        v_FieldNames := ''SID,CATEGORY,RESOLVED,REPORT_UNIT'';'||chr(10)||
'        v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(:p21001_list_1,''%null%'',''null'') || '''''''' || '','' || ''''''''';

p:=p||' ||'||chr(10)||
'                                 :p21001_radiogroup_1 || '''''''' || '','' || '''''''' || ''~^~UNIT~^~'' || '''''''';'||chr(10)||
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
'       :P21001_FROM_OBJ:=:';

p:=p||'P21001_FILE_ASSOC;'||chr(10)||
' '||chr(10)||
'     END IF;'||chr(10)||
''||chr(10)||
'     :P0_OBJ := osi_activity.create_instance(:p21001_obj_type_sid,'||chr(10)||
'                                             v_ActivityDate,'||chr(10)||
'                                             :p21001_title,'||chr(10)||
'                                             :p21001_restriction,'||chr(10)||
'                                             :P21001_narrative,'||chr(10)||
'                                             v_';

p:=p||'FieldNames,'||chr(10)||
'                                             v_FieldValues,'||chr(10)||
'                                             :p21001_participant_version,'||chr(10)||
'                                             v_ParticipantUsage,'||chr(10)||
'                                             v_ParticipantCode,'||chr(10)||
'                                             v_TableName,'||chr(10)||
'                                             :p21001_from_obj,'||chr(10)||
'    ';

p:=p||'                                         v_AddressUsage,'||chr(10)||
'                                             v_AddressCode,'||chr(10)||
'                                             :p21001_address_value,'||chr(10)||
'                                             :p21001_parent_objective,'||chr(10)||
'                                             replace(:p21001_pay_cat,''%null%'',''null''),'||chr(10)||
'                                             replace(:p21';

p:=p||'001_duty_cat,''%null%'',''null''),'||chr(10)||
'                                             replace(:p21001_mission,''%null%'',''null''),'||chr(10)||
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
  p_process_when=>':REQUEST IN (''CREATE'',''CREATE_ONE'');',
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
p:=p||'insert into t_osi_a_records_check_multi'||chr(10)||
'(activity_date,subject_of_activity,reference_number,restriction,title,narrative,doc_type,results,file_sid,personnel,WH_PAY_CAT,WH_DUTY_CAT,WH_MISSION,WH_DATE,WH_HOURS,COMPLETE,SUBSTANTIVE)'||chr(10)||
'values'||chr(10)||
'(:P21001_ACTIVITY_DATE,'||chr(10)||
' :P21001_PARTICIPANT,'||chr(10)||
' :P21001_DOCUMENT_NUMBER,'||chr(10)||
' :P21001_RESTRICTION,'||chr(10)||
' :P21001_TITLE,'||chr(10)||
' :P21001_NARRATIVE,'||chr(10)||
' REPLACE(:P21001_LIST_1,''%null%'',N';

p:=p||'ULL),'||chr(10)||
' REPLACE(:P21001_LIST_2,''%null%'',NULL),'||chr(10)||
' :P21001_FILE_ASSOC,'||chr(10)||
' :USER_SID,'||chr(10)||
' REPLACE(:P21001_PAY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_DUTY_CAT,''%null%'',NULL),'||chr(10)||
' REPLACE(:P21001_MISSION,''%null%'',NULL),'||chr(10)||
' :P21001_WORK_DATE,'||chr(10)||
' :P21001_HOURS,'||chr(10)||
' :P21001_COMPLETE,'||chr(10)||
' :P21001_SUBSTANTIVE) '||chr(10)||
'returning sid into :P21001_SELECTED;'||chr(10)||
''||chr(10)||
'COMMIT;';

wwv_flow_api.create_page_process(
  p_id     => 13193311115501624 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Check To List',
  p_process_sql_clob => p, 
  p_process_error_message=> 'SHIT',
  p_process_when=>':REQUEST IN (''ADD'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'GOOD',
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
'        delete from T_OSI_A_RECORDS_CHECK_MULTI'||chr(10)||
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
'REFERENCE_NUMBER,'||chr(10)||
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
'SUBSTANTIVE'||chr(10)||
'INTO'||chr(10)||
':P21001_SELECTED,'||chr(10)||
':P21001_ACTIVITY_DATE,'||chr(10)||
':P21001_PARTICIPANT_VERSION,'||chr(10)||
':P21001_DOCUMENT_NUMBER,'||chr(10)||
':P21001_RESTRICTION,'||chr(10)||
':P21001_TITLE,'||chr(10)||
':P21001_NARRATIVE,'||chr(10)||
':P';

p:=p||'21001_LIST_1,'||chr(10)||
':P21001_LIST_2,'||chr(10)||
':P21001_FILE_ASSOC,'||chr(10)||
':P21001_PAY_CAT,'||chr(10)||
':P21001_DUTY_CAT,'||chr(10)||
':P21001_MISSION,'||chr(10)||
':P21001_WORK_DATE,'||chr(10)||
':P21001_HOURS,'||chr(10)||
':P21001_COMPLETE,'||chr(10)||
':P21001_SUBSTANTIVE'||chr(10)||
'FROM T_OSI_A_RECORDS_CHECK_MULTI WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');';

wwv_flow_api.create_page_process(
  p_id     => 13193725660505875 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
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
p:=p||'declare'||chr(10)||
''||chr(10)||
'      v_sid                    varchar2(20);'||chr(10)||
'      v_act_count              number;'||chr(10)||
'      v_FieldNames             clob := NULL;'||chr(10)||
'      v_FieldValues            clob := NULL;'||chr(10)||
'      v_ActivityDate           date;'||chr(10)||
'      v_TableName              varchar2(100) := NULL;'||chr(10)||
'      v_ParticipantUsage       varchar2(100) := NULL;'||chr(10)||
'      v_ParticipantCode        varchar2(100) := NULL;'||chr(10)||
'      v_AddressUsa';

p:=p||'ge           varchar2(100) := NULL;'||chr(10)||
'      v_AddressCode            varchar2(100) := NULL;'||chr(10)||
'      v_Participant_Version    varchar2(20);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     v_FieldNames := ''sid,doc_type,reference_num'';'||chr(10)||
''||chr(10)||
'     v_ParticipantUsage := ''PARTICIPANTS'';'||chr(10)||
'     v_ParticipantCode := ''SUBJECT'';'||chr(10)||
'     v_TableName := ''t_osi_a_records_check'';'||chr(10)||
''||chr(10)||
'     for i in (SELECT * FROM T_OSI_A_RECORDS_CHECK_MULTI WHERE PERSONNEL=:USER_S';

p:=p||'ID)'||chr(10)||
'     loop'||chr(10)||
'         v_ActivityDate := to_date(i.activity_date, ''DD-Mon-YYYY HH24:MI'');'||chr(10)||
'         v_Participant_Version:=osi_participant.get_current_version(i.subject_of_activity);'||chr(10)||
''||chr(10)||
'         v_FieldValues := '''''''' || ''~^~P0_OBJ~^~'' || '''''''' || '','' || '''''''' || replace(i.doc_type,''%null%'',''null'') || '''''''' || '','' || '''''''' || '||chr(10)||
'                                          i.reference_number || '''''''';'||chr(10)||
''||chr(10)||
'        ';

p:=p||' v_sid := osi_activity.create_instance(:p21001_obj_type_sid,'||chr(10)||
'                                               v_ActivityDate,'||chr(10)||
'                                               i.title,'||chr(10)||
'                                               i.restriction,'||chr(10)||
'                                               i.narrative,'||chr(10)||
'                                               v_FieldNames,'||chr(10)||
'                                     ';

p:=p||'          v_FieldValues,'||chr(10)||
'                                               v_Participant_Version,'||chr(10)||
'                                               v_ParticipantUsage,'||chr(10)||
'                                               v_ParticipantCode,'||chr(10)||
'                                               v_TableName,'||chr(10)||
'                                               i.file_sid,'||chr(10)||
'                                               v_Addr';

p:=p||'essUsage,'||chr(10)||
'                                               v_AddressCode,'||chr(10)||
'                                               :p21001_address_value,'||chr(10)||
'                                               :p21001_parent_objective,'||chr(10)||
'                                               replace(i.wh_pay_cat,''%null%'',''null''),'||chr(10)||
'                                               replace(i.wh_duty_cat,''%null%'',''null''),'||chr(10)||
'            ';

p:=p||'                                   replace(i.wh_mission,''%null%'',''null''),'||chr(10)||
'                                               i.wh_date,'||chr(10)||
'                                               i.wh_hours,'||chr(10)||
'                                               i.complete,'||chr(10)||
'                                               i.substantive);'||chr(10)||
''||chr(10)||
'        select count(*) into v_act_count from t_osi_activity where sid=v_sid;'||chr(10)||
'        ';

p:=p||''||chr(10)||
'        if (v_act_count > 0) then'||chr(10)||
''||chr(10)||
'          recent_access(v_sid, :user_sid);'||chr(10)||
''||chr(10)||
'          delete from t_osi_a_records_check_multi where sid=i.sid;'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 13193930854507277 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21001,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Create Multiple Records Checks',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Could not create new Law Enforcement Records Check.',
  p_process_when=>':REQUEST IN (''CREATE_ACTIVITIES'')',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> 'New Law Enforcement Records Check activity created.',
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

p:=p||'ption,t.sid,ot.default_title'||chr(10)||
'  into :P21001_OBJ_TYPE_DESCRIPTION,:P21001_OBJ_TYPE_SID,:P21001_TITLE'||chr(10)||
'  from t_core_obj_type t,t_osi_obj_type ot'||chr(10)||
' where t.code=:P21001_OBJ_TYPE_CODE'||chr(10)||
'   and ot.sid=t.sid;'||chr(10)||
''||chr(10)||
''||chr(10)||
'IF :P21001_OBJ_TYPE_CODE IN (''ACT.AAPP'',''ACT.AAPP.DOCUMENT_REVIEW'',''ACT.AAPP.EDUCATION'',''ACT.AAPP.EMPLOYMENT'',''ACT.AAPP.INTERVIEW'',''ACT.AAPP.RECORDS_CHECK'') THEN'||chr(10)||
'  '||chr(10)||
'  :P21001_RESTRICTION := osi_refe';

p:=p||'rence.lookup_ref_sid(''RESTRICTION'', ''UNIT'');'||chr(10)||
'  :P21001_NARRATIVE := osi_aapp_activity.get_pre_can_narrative(:P21001_PARENT_OBJECTIVE);'||chr(10)||
''||chr(10)||
'END IF;'||chr(10)||
''||chr(10)||
'CASE :P21001_OBJ_TYPE_CODE'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.AV_SUPPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Request Received'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Support Type'';'||chr(10)||
'             ';

p:=p||'                          :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AV_TYPE'');'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Date Requested By'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Date Completed'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Requestor'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_';

p:=p||'VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Pa';

p:=p||'rticipant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'               WHEN ''ACT.BRIEFING'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Briefing Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Briefing Time'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.COMP_INTRUSION'' THEN'||chr(10)||
'                                       :P21001_PRECISION_DATE_1_LABEL:=''CCI Notified Date'';'||chr(10)||
'     ';

p:=p||'                                  :P21001_LIST_1_LABEL := ''Impact'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''COMPINT_IMPACT'');'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Contact Method'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
'   ';

p:=p||'                                    :P21001_LIST_3_LABEL := ''AFCERT Category'';'||chr(10)||
'                                       :P21001_LIST_3_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''AFCERT_CATEGORY'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''CCI Notified'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Request For Information'';'||chr(10)||
'                   ';

p:=p||'                    :P21001_TEXT_8_LABEL:=''AFCERT Incident Num'';'||chr(10)||
''||chr(10)||
'                                       :P21001_PRECISION_DATE_2_LABEL:=''From'';'||chr(10)||
'                                       :P21001_PRECISION_DATE_3_LABEL:=''To'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''CCI Comment'';'||chr(10)||
''||chr(10)||
'        WHEN ''ACT.DOCUMENT_REVIEW'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_';

p:=p||'DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''DOCREV_DOCTYPE'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Document Type'';'||chr(10)||
'                                       :P21001_EXPLANATION_LABEL:=''Explanation'';'||chr(10)||
'                                       :P21001_DOCUMENT_NUMBER_LABEL:=''Document Number';

p:=p||''';'||chr(10)||
''||chr(10)||
'                                       :P21001_EXPLANATION_VISIBLE := osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') || ''~'';'||chr(10)||
''||chr(10)||
'     WHEN ''ACT.FINGERPRINT.MANUAL'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Date Fingerprints Taken'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WID';

p:=p||'GET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'        ';

p:=p||'     WHEN ''ACT.INIT_NOTIF'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Notified On'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Notified By'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SR';

p:=p||'C:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.SUBJECT'' THEN'||chr(10)||
'                                       :P21001';

p:=p||'_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTIC';

p:=p||'IPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
''||chr(10)||
'       WHEN ''ACT.INTERVIEW.VICTIM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                   ';

p:=p||'    :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Victim'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                           ';

p:=p||'                     ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'      WHEN ''ACT.INTERVIEW.WITNESS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Interview Date'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Interview Time'';'||chr(10)||
'                                   ';

p:=p||'    :P21001_PARTIC_LABEL:=''Witness'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYP';

p:=p||'E_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                WHEN ''ACT.LIAISON'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Liaison Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Liaison Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON';

p:=p||'_TYPE'');'||chr(10)||
'                                       :P21001_LIST_2_LABEL:=''Liaison Level'';'||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''LIAISON_LEVEL'');'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.MEDIA_ANALYSIS'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''';

p:=p||'Media Type'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_TYPE'');'||chr(10)||
'                                       :P21001_TEXT_2_LABEL:=''Media Size'';'||chr(10)||
'                                       :P21001_TEXT_3_LABEL:=''Quantity'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Size Units'';'||chr(10)||
'                                       :';

p:=p||'P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''MEDANLY_UNIT'');'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Removable?'';'||chr(10)||
'                                       :P21001_DATE_2_LABEL:=''Seizure Date'';'||chr(10)||
'                                       :P21001_DATE_3_LABEL:=''Receive Date'';'||chr(10)||
'                                       :P21001_DATE_4_LABEL:=''Analysis Start Date'';';

p:=p||''||chr(10)||
'                                       :P21001_DATE_5_LABEL:=''Analysis End Date'';'||chr(10)||
'                                       :P21001_TEXT_4_LABEL:=''Comments'';'||chr(10)||
''||chr(10)||
'              WHEN ''ACT.POLY_EXAM'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Exam Date'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Examinee Name'';'||chr(10)||
'                                       :P210';

p:=p||'01_LIST_1_LABEL:=''Monitor to Exam'';'||chr(10)||
'                                       :P21001_LIST_1_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''POLY_MONITOR'');'||chr(10)||
'                                       :P21001_TEXT_5_LABEL:=''Place of Examination'';'||chr(10)||
'                                       :P21001_HOUR_LABEL:=''Start Time'';'||chr(10)||
'                                       :P21001_HOUR_2_LABEL:=''End Time'';'||chr(10)||
'           ';

p:=p||'                            :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTIC';

p:=p||'IPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
'  '||chr(10)||
'          WHEN ''ACT.RECORDS_CHECK'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''LERC_DOCTYPE'');'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Subject of Activity'';'||chr(10)||
'                             ';

p:=p||'          :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Record Type'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Records Check Result'';'||chr(10)||
'                                       '||chr(10)||
'                                       :P21001_LIST_2_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select DESCRIPTION ';

p:=p||'d, CODE r from T_OSI_A_RECORDS_CHECK_RESULTS order by 1)'||chr(10)||
'                                       loop'||chr(10)||
'                                           :P21001_LIST_2_LOV := :P21001_LIST_2_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
''||chr(10)||
'                                       :P21001_DOCUMENT_NUMBER_LABEL:=''Reference Number'';'||chr(10)||
'                       ';

p:=p||'                :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                                                ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'                 WHEN ''ACT.SEARCH'' THEN'||chr(10)||
'         ';

p:=p||'                              :P21001_ACTIVITY_DATE_LABEL:=''Search Date'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Person Associated with Search'';'||chr(10)||
'                                       :P21001_TEXT_6_LABEL:=''Explanation'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_LIST_1_LABEL:=''Search Type'';'||chr(10)||
'     ';

p:=p||'                                  :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
'                                       for a in (select description d, sid r  '||chr(10)||
'                                                       from t_core_obj_type '||chr(10)||
'                                                         where code like substr(''ACT.SEARCH'', 1, 10) || ''%'' '||chr(10)||
'                                                           ';

p:=p||'and description <> ''Search'' order by description)'||chr(10)||
'                                       loop'||chr(10)||
'                                           :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r|| '',''; '||chr(10)||
'                                       end loop;'||chr(10)||
'                                       :P21001_LIST_1_LOV := rtrim(:P21001_LIST_1_LOV, '','');'||chr(10)||
'  '||chr(10)||
'                          ';

p:=p||'             :P21001_LIST_2_LABEL := ''Search Based Upon'';'||chr(10)||
'                                       :P21001_LIST_2_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SEARCH_BASIS'');'||chr(10)||
'  '||chr(10)||
'                                       :P21001_FIND_WIDGET_SRC:=''<a id="FindPartic" href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','' ||'||chr(10)||
'                                              ';

p:=p||'                  ''''''P301_ACTIVE_FILTER_EXCLUDES'''',$v(''''P21001_PARTIC_TYPE_EXCLUDES''''),''''Choose Participant...'''',''''PARTICIPANT'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'            WHEN ''ACT.SOURCE_MEET'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Meet Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METH';

p:=p||'OD'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Interview Type'';'||chr(10)||
'                                       :P21001_TEXT_7_LABEL := ''Commodity'';'||chr(10)||
'                                       :P21001_PARTIC_LABEL:=''Source'';'||chr(10)||
'                                       :P21001_PARTIC_WIDGET_VISIBLE:=''Y'';'||chr(10)||
'                                       :P21001_PARTIC_TYPE_EXCLUDES:='''';'||chr(10)||
'                  ';

p:=p||'                     :P21001_FIND_WIDGET_SRC:=''<a href="javascript:openLocator(''''301'''',''''P21001_PARTICIPANT'''',''''N'''','''''''',''''OPEN'''','''''' ||'||chr(10)||
'                                                                '''''','''''''',''''Choose Source Number...'''',''''SOURCE'''','''''''');">&ICON_LOCATOR.</a>'';'||chr(10)||
''||chr(10)||
'           WHEN ''ACT.SURVEILLANCE'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested St';

p:=p||'art Date'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CATEGORY'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Surveillance Information Type'';'||chr(10)||
'                                       :P21001_LIST_2_LABEL := ''Surveillance Technique'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''US Locat';

p:=p||'ion'';'||chr(10)||
'                                       :P21001_RADIOGROUP_2_LABEL:=''Emergency'';'||chr(10)||
'                                       :P21001_RADIOGROUP_3_LABEL:=''Consensual'';'||chr(10)||
'                                       :P21001_RADIOGROUP_4_LABEL:=''ITEM Case'';'||chr(10)||
'                                       :P21001_LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SURV_INFO_TYPE'');'||chr(10)||
'                           ';

p:=p||'            :P21001_TEXT_9_LABEL := ''Requested Duration'';'||chr(10)||
'                                       :P21001_TEXT_9_SUFFIX := ''  days'';'||chr(10)||
'                                       :P21001_ADDRESS_LABEL := ''Address of Intercept'';'||chr(10)||
''||chr(10)||
'         WHEN ''ACT.SUSPACT_REPORT'' THEN'||chr(10)||
'                                       :P21001_ACTIVITY_DATE_LABEL:=''Requested Start Date'';'||chr(10)||
'                                       :P21001_';

p:=p||'LIST_1_LOV := ''- Select -;%null%,'' || osi_reference.get_lov(''SUSPACT_CATEGORY'');'||chr(10)||
'                                       :P21001_LIST_1_LABEL := ''Category of Suspicious Activity'';'||chr(10)||
'                                       :P21001_RADIOGROUP_1_LABEL:=''Resolved'';'||chr(10)||
''||chr(10)||
'                                   ELSE'||chr(10)||
'                                       if (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.CONSULTATION'') the';

p:=p||'n'||chr(10)||
''||chr(10)||
'                                         :P21001_ACTIVITY_DATE_LABEL:=''Consultation Date'';'||chr(10)||
'                                         :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                         :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                                         for a in (select d,r '||chr(10)||
'                                                         from V_OSI_CONSULT_CREATE_TYPES';

p:=p||' order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                                         begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type where ';

p:=p||'code =''ACT.CONSULTATION.ACQUISITION'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
'         '||chr(10)||
'                                                  null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov';

p:=p||'(''CONTACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       elsif (substr(:P21001_OBJ_TYPE_CODE,1,16)=''ACT.COORDINATION'') then'||chr(10)||
''||chr(10)||
'                                            :P21001_ACTIVITY_DATE_LABEL:=''Coordination Date'';'||chr(10)||
'                                            :P21001_LIST_1_LABEL:=''Type'';'||chr(10)||
'                                            :P21001_LIST_1_LOV:=''- Select -;%null%,'';'||chr(10)||
''||chr(10)||
'                 ';

p:=p||'                        for a in (select d,r '||chr(10)||
'                                                         from V_OSI_COORDIN_CREATE_TYPES order by 1)'||chr(10)||
'                                         loop'||chr(10)||
'                                             :P21001_LIST_1_LOV := :P21001_LIST_1_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'                                         end loop;'||chr(10)||
''||chr(10)||
'                 ';

p:=p||'                        begin'||chr(10)||
'                                              select sid into :P21001_LIST_1 from t_core_obj_type where code =''ACT.COORDINATION.FORENSICS'';'||chr(10)||
''||chr(10)||
'                                         exception when others then'||chr(10)||
''||chr(10)||
'                                                  null;'||chr(10)||
''||chr(10)||
'                                         end;'||chr(10)||
''||chr(10)||
'                                         :P21001_LIST_2_';

p:=p||'LABEL:=''Method'';'||chr(10)||
'                                         :P21001_LIST_2_LOV:=''- Select -;%null%,'' || osi_reference.get_lov(''CONTACT_METHOD'');'||chr(10)||
''||chr(10)||
'                                       else'||chr(10)||
'                                         '||chr(10)||
'                                         if (:P21001_OBJ_TYPE_CODE IN (''ACT.CC_REVIEW'',''ACT.CHECKLIST'',''ACT.KFAT'',''ACT.OC_REVIEW'')) then'||chr(10)||
'                                 ';

p:=p||'        '||chr(10)||
'  '||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Review Date'';'||chr(10)||
''||chr(10)||
'                                         else'||chr(10)||
''||chr(10)||
'                                           :P21001_ACTIVITY_DATE_LABEL:=''Activity Date'';'||chr(10)||
'                                           :P21001_PARTIC_LABEL:=''Subject'';'||chr(10)||
''||chr(10)||
'                                         end if;'||chr(10)||
''||chr(10)||
'                                     ';

p:=p||'  end if;'||chr(10)||
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
'if :P21001_LIST_2_LOV = '''' then'||chr(10)||
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
'end';

p:=p||' if;'||chr(10)||
''||chr(10)||
'if :P21001_duty_cat_lov is null then'||chr(10)||
''||chr(10)||
'  :P21001_duty_cat_lov := osi_reference.get_lov(''DUTY_CATEGORY'');'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P21001_activity_date is null then'||chr(10)||
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


