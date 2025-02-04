set define off;

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

    function create_instance(
        p_obj_type      in   varchar2,
        p_act_date      in   date,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_narrative     in   clob)
        return varchar2 is
        v_sid   t_core_obj.SID%type;
    begin
        insert into t_core_obj
                    (obj_type)
             values (p_obj_type)
          returning SID
               into v_sid;

        insert into t_osi_activity
                    (SID,
                     id,
                     title,
                     creating_unit,
                     assigned_unit,
                     activity_date,
                     narrative,
                     restriction)
             values (v_sid,
                     osi_object.get_next_id,
                     p_title,
                     osi_personnel.get_current_unit(core_context.personnel_sid),
                     osi_personnel.get_current_unit(core_context.personnel_sid),
                     p_act_date,
                     p_narrative,
                     p_restriction);

        --Create the Lead Assignment
        osi_object.create_lead_assignment(v_sid);
        --Set the starting status
        osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type), 'Created');
        core_obj.bump(v_sid);
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

