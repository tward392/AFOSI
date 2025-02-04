SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY "OSI_FILE" as
/******************************************************************************
   Name:     Osi_File
   Purpose:  Provides Functionality For File Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     7-Apr-2009 T.McGuffin      Created Package
    28-Apr-2009 T.McGuffin      Modified Get_Tagline To Only Return Title.
    27-May-2009 T.McGuffin      Added Set_Unit_Owner procedure.
    27-May-2009 T.McGuffin      Added Create_Instance function
    01-Jun-2009 T.McGuffin      Added Get_ID function.
    01-Jun-2009 R.Dibble        Added get_unit_owner
    30-Jun-2009 T.McGuffin      Phased out CORE ACL for simple Restriction.
    26-Aug-2009 M.Batdorf       Added get_assoc_file_sids, get_assoc_act_sids
                                and get_inherited_act_sids.
    15-Oct-2009 J.Faris         Added can_delete
    17-Dec-2009 T.Whitehead     Added get_full_id.
    23-Dec-2009 T.Whitehead     Added get_title.
    26-Feb-2010 T.McGuffin      Modified can_delete to use osi_object.get_lead_agent.
    30-Mar-2010 T.McGuffin      Added get_days_since_opened function.
    04-Apr-2010 R.Dibble        Modified can_delete to use codes instead of
                                 hard coded descriptions
    02-Apr-2010 R.Dibble        Added rpt_generate_form2
    05-Apr-2010 R.Dibble        Added rpt_generate_30252
                                 Added rpt_generate_30256
    18-May-2010 J.Faris         Modified can_delete to handle special processing for
                                 Security Polygraph files.
    25-May-2010 T.Leighty       Added make_doc_misc_file.
    14-Jun-2010 R.Dibble        Modified can_delete() to handle PSO File special processing
    18-Mar-2011 Tim Ward        CR#3731 - Deleting should not stop you if you are not the Lead Agent, if you
                                 have the Delete Privilege.
                                 Also, PSO Files do not have any special processing.
                                 Added FILE.SOURCE special processing.
                                 Changed can_delete().
    20-Oct-2011  Tim Ward       CR#3932 - Classification on Reports is wrong.
                                 Changed in rpt_generate_form2.
    11-Jul-2012  Tim Ward       CR#4028 - Add subject Name and SSN to Agent Applicant 30256.
                                 Changed in rpt_generate_30256.
    12-Jul-2012 Tim Ward        CR#3983 - Make Days Since Opened Work for Sources.
                                 Changed in get_days_since_opened.
    30-Jan-2013 Tim Ward        CR#4248 - Form2 Location displaying incorrrectly.
                                 Changed in rpt_generate_form2.                                                                  
******************************************************************************/
    c_pipe        varchar2(100)  := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_FILE';
    v_syn_error   varchar2(4000) := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_full_id(p_obj in varchar2)
        return varchar2 is
        v_full_id   t_osi_file.full_id%type;
    begin
        if p_obj is null then
            log_error('get_full_id: null value passed');
            return null;
        end if;

        for x in (select full_id
                    from t_osi_file
                   where sid = p_obj)
        loop
            return x.full_id;
        end loop;

        return null;
    exception
        when others then
            log_error('get_full_id: ' || sqlerrm);
            return null;
    end get_full_id;

    function get_id(p_obj in varchar2)
        return varchar2 is
        v_id   t_osi_file.id%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select id
          into v_id
          from t_osi_file
         where sid = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_file.title%type;
    begin
        select title
          into v_title
          from t_osi_file
         where sid = p_obj;

        return v_title;
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return 'File Summary';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    function get_title(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select title
                    from t_osi_file
                   where sid = p_obj)
        loop
            return x.title;
        end loop;

        return null;
    exception
        when others then
            log_error('get_title: ' || sqlerrm);
            return 'get_title: Error';
    end get_title;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'File Index1 XML Clob';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return 'File Status';
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    procedure set_unit_owner(
        p_obj      in   varchar2,
        p_unit     in   varchar2 := null,
        p_reason   in   varchar2 := null) is
        v_unit     t_osi_unit.sid%type;
        v_reason   t_osi_f_unit.reason%type   := null;
    begin
        v_unit := nvl(p_unit, osi_personnel.get_current_unit(core_context.personnel_sid));

        if p_obj is not null and v_unit is not null then
            update t_osi_f_unit
               set end_date = sysdate
             where file_sid = p_obj;

            if p_reason is null then
                if sql%rowcount = 0 then
                    v_reason := 'Initial Owner';
                end if;
            else
                v_reason := p_reason;
            end if;

            insert into t_osi_f_unit
                        (file_sid, unit_sid, start_date, reason)
                 values (p_obj, v_unit, sysdate, v_reason);
        end if;
    exception
        when others then
            log_error('set_unit_owner: ' || sqlerrm);
            raise;
    end set_unit_owner;

    /* Given an Object, it return the owning unit */
    function get_unit_owner(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_f_unit.unit_sid%type;
    begin
        select unit_sid
          into v_return
          from t_osi_f_unit
         where file_sid = p_obj and end_date is null;

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_unit_owner: ' || sqlerrm);
            raise;
    end get_unit_owner;

    function create_instance(p_obj_type in varchar2, p_title in varchar2, p_restriction in varchar2)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
    begin
        insert into t_core_obj
                    (obj_type)
             values (p_obj_type)
          returning sid
               into v_sid;

        insert into t_osi_file
                    (sid, title, id, restriction)
             values (v_sid, p_title, osi_object.get_next_id, p_restriction);

        --Set the starting status
        osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type),
                                       'Created');
        --Create the Lead Assignment
        osi_object.create_lead_assignment(v_sid);
        --Set the owning unit
        osi_file.set_unit_owner(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    function get_assoc_file_sids(p_obj in varchar2)
        return varchar2 is
        v_rtn   varchar2(30000) := '';
    begin
        for af in (select that_file
                     from v_osi_assoc_fle_fle_raw
                    where this_file = p_obj)
        loop
            if not core_list.find_item_in_list(af.that_file, v_rtn) then
                if not core_list.add_item_to_list(af.that_file, v_rtn) then
                    -- it's not in the list but adding did not work
                    core_logger.log_it(c_pipe,
                                       'get_assoc_file_sids - Adding ' || af.that_file
                                       || ' to the list for obj ' || p_obj || ' did not work.');
                end if;
            end if;
        end loop;

        return v_rtn;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_assoc_file_sids: ' || sqlerrm);
            return null;
    end get_assoc_file_sids;

    function get_assoc_act_sids(p_obj in varchar2)
        return varchar2 is
        v_rtn   varchar2(30000) := '';
    begin
        for aa in (select activity_sid
                     from t_osi_assoc_fle_act
                    where file_sid = p_obj)
        loop
            if not core_list.find_item_in_list(aa.activity_sid, v_rtn) then
                if not core_list.add_item_to_list(aa.activity_sid, v_rtn) then
                    -- it's not in the list but adding did not work
                    core_logger.log_it(c_pipe,
                                       'get_assoc_act_sids - Adding ' || aa.activity_sid
                                       || ' to the list for obj ' || p_obj || ' did not work.');
                end if;
            end if;
        end loop;

        return v_rtn;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_assoc_act_sids: ' || sqlerrm);
            return null;
    end get_assoc_act_sids;

    function get_inherited_act_sids(p_obj in varchar2)
        return varchar2 is
        v_assoc_file_list    varchar2(4000);
        v_file_act_list      varchar2(4000);
        v_inherit_act_list   varchar2(4000);
        v_temp_act_list      varchar2(4000);
        v_int                number         := 0;
        v_int2               number         := 0;
        v_file_item          varchar2(20);
        v_act_item           varchar2(20);
        v_file_count         number         := 0;
        v_act_count          number         := 0;
    begin
        v_assoc_file_list := get_assoc_file_sids(p_obj);
        v_file_count := core_list.count_list_elements(v_assoc_file_list);

        for v_int in 1 .. v_file_count
        loop
            v_file_item := core_list.pop_list_item(v_assoc_file_list);
            v_temp_act_list := get_assoc_act_sids(v_file_item);
            v_file_act_list := v_temp_act_list;
            v_act_count := core_list.count_list_elements(v_temp_act_list);

            for v_int2 in 1 .. v_act_count
            loop
                v_act_item := core_list.get_list_element(v_temp_act_list, v_int2);

                if core_list.find_item_in_list(v_act_item, v_inherit_act_list) then
                    if not core_list.remove_item_from_list(v_act_item, v_file_act_list) then
                        core_logger.log_it(c_pipe,
                                           'get_inherited_act_sids: could not remove ' || v_act_item
                                           || ' from list ' || v_temp_act_list);
                    end if;
                end if;
            end loop;

            v_inherit_act_list := v_inherit_act_list || v_file_act_list;
            v_inherit_act_list := replace(v_inherit_act_list, '~~', '~');
        end loop;

        return v_inherit_act_list;
    exception
        when others then
            core_logger.log_it(c_pipe, 'Exception in get_inherited_act_sids: ' || sqlerrm);
            return null;
    end get_inherited_act_sids;

    function can_delete(p_obj in varchar2) return varchar2 is

            v_stat            varchar2(200);
            v_lead            varchar2(20);
            v_obj_type        varchar2(200);
            v_obj_type_code   varchar2(1000);
            v_last_TM_sh_sid  varchar2(1000);
            v_count_check     number;

    begin
         /* Note: This function can be used by *most* files.  If you find you
                  have a file that needs further special processing, we may
                  have to break can_delete() functions out into individual
                  object packages. - Richard Dibble 04/01/2010

         */

         ---Get Status Code and Object Type---
         v_stat := osi_object.get_status_code(p_obj);
         v_obj_type := core_obj.get_objtype(p_obj);
         v_obj_type_code := osi_object.get_objtype_code(v_obj_type);
         
         case v_obj_type_code
             
             ---Special case for Agent Application File (110)---
             when 'FILE.AAPP' then
                 
                 select count(*) into v_count_check from v_osi_f_aapp_file_obj_act where file_sid=p_obj;
                 if v_count_check > 0 then
                   
                   return 'You are not allowed to delete this file when there are ''Associated Activities that Support Objectives'', please remove them from the [Details] tab.';
                   
                 end if;

             ---Special case for Security Polygraph Files---
             when 'FILE.POLY_FILE.SEC' then

                 if v_stat in('CL', 'SV', 'RV', 'AV') then
 
                   return 'You cannot delete this file with status of ' || osi_object.get_status(p_obj) || '.';
 
                 end if;

             ---Special case for Source Files---
             when 'FILE.SOURCE' then

                 if v_stat in('PO', 'AA') then
                   
                   begin
                        select nvl(osi_status.last_sh_sid(p_obj, 'TM'),'~~~never terminated~~~') into v_last_TM_sh_sid FROM DUAL;
                        
                   exception when others then
                   
                            v_last_TM_sh_sid := '~~~never terminated~~~';
                             
                   end;
                   
                   if v_last_TM_sh_sid != '~~~never terminated~~~' then

                     return 'You cannot delete a soruce that has already been an Active source in the past.';

                   end if;
                   
                 else
                 
                   return 'You cannot delete this file with status of ' || osi_object.get_status(p_obj) || '.';
 
                 end if;
                 
                 select count(*) into v_count_check from t_osi_activity where source=p_obj;
                 if v_count_check > 0 then
                   
                   return 'You cannot delete a source used in an activity.';
                   
                 end if;
                 
                 select count(*) into v_count_check from t_osi_assoc_fle_act where activity_sid in(select sid from t_osi_activity where source=p_obj);
                 -------(pending Collection Requirements/Emphasis inclusion in WebI2MS)SID in (select CRCE from T_CR_USAGE where MEET in (select SID from T_ACTIVITY where SOURCE = :BO))
                 -------(pending IR inclusion in WebI2MS)SID in (select IR from T_IR_SOURCE where OSI_SOURCE = :BO)
                 if v_count_check > 0 then
                   
                   return 'You cannot delete a source used in a file.';
                   
                 end if;

             ---All others Files---
             else

               ---Is file in "NW", "AA" status? Otherwise No delete---
               if v_stat not in('NW', 'AA') then

                 return 'You cannot delete a file with status of ' || osi_object.get_status(p_obj) || '.';

               end if;
               
         end case;

         ---Is Current User the lead agent?---
         if (core_context.personnel_sid = osi_object.get_lead_agent(p_obj)) then

           return 'Y';

         else

           ---User is NOT lead agent, so see if they have "Delete" priv.---
           if (osi_auth.check_for_priv('DELETE', v_obj_type) = 'Y') then

             ---User has the priv, so they can delete---
             return 'Y';

           end if;

           return 'You are not authorized to perform the requested action.';

         end if;

    exception
        when others then
            log_error('OSI_FILE.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in OSI_FILE.Can_Delete using Object: ' || nvl(p_obj, 'NULL');

    end can_delete;

    function get_days_since_opened(p_obj in varchar2) return number is

        v_days           number;
        v_last_status    varchar2(100);
        v_open_status    varchar2(2):='OP';
        v_obj_type_code  varchar2(100);
        
    begin
         v_last_status := upper(osi_object.get_status_code(p_obj));
         
         select osi_object.get_objtype_code(core_obj.get_objtype(p_obj)) into v_obj_type_code from dual;
         if v_obj_type_code = 'FILE.SOURCE' then
          
           v_open_status := 'AC';
           
         end if;
         
         if v_last_status != v_open_status then

           v_days := 0;

         else

           v_days := floor(sysdate - osi_status.last_sh_date(p_obj, v_open_status));

         end if;

         return v_days;
    exception
        when others then
            log_error('osi_file.get_days_since_opened: ' || sqlerrm);
            raise;
    end get_days_since_opened;

    /* Used to generate the Form2 report */
    function rpt_generate_form2(p_obj in varchar2)
        return clob is
        v_placeholder      varchar2(200);
        --This is only for holding place of items that are not complete
        v_ok               varchar2(2000);
        v_return_date      date;
        v_return           clob;
        v_mime_type        t_core_template.mime_type%type;
        v_mime_disp        t_core_template.mime_disposition%type;
        v_classification   varchar2(100);
        v_cust_label       varchar2(1000);
        v_date_opened      date;
        v_date_closed      date;
        v_file_count       number;
        v_city             varchar2(1000);
        v_state            varchar2(1000);
        v_country          varchar2(1000);
    begin
        --Get latest template
        v_ok := core_template.get_latest('FORM_2', v_return, v_return_date, v_mime_type, v_mime_disp);

        --- Retrieve Classification Level  (U=Unclassified, C=Confidential, and S=Secret) --- 
        v_classification := core_classification.Class_Level(p_obj,'XML');

        --- If Object is NOT Classified, check for a Default Value --- 
        if (v_classification is null or v_classification = '') then

          v_classification := core_util.get_config('OSI.DEFAULT_CLASS');

        end if;
        
        --- If Object is NOT Classified, and NO Default is found, Default to the HIGHEST ---
        if (v_classification is null or v_classification = '') then

          v_classification := 'S';

        end if;

        --- Get Customer Label ---
        v_cust_label := core_util.get_config('OSI.CUSTLABEL');
        v_ok :=
            core_template.replace_tag(v_return,
                                      'FILETYPE',
                                      v_cust_label || ' '
                                      || osi_object.get_objtype_desc(core_obj.get_objtype(p_obj))
                                      || ' FILE');
        v_ok :=
            core_template.replace_tag(v_return,
                                      'ID',
                                      '*' || osi_object.get_id(p_obj, null) || '*',
                                      p_multiple       => true);

        if (osi_file.get_full_id(p_obj) is null) then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FULL_ID',
                                          osi_object.get_id(p_obj, null),
                                          p_multiple       => true);
        else
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FULL_ID',
                                          osi_file.get_full_id(p_obj),
                                          p_multiple       => true);
        end if;

        --- Get Date Opened ---
        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            v_date_opened := osi_status.first_sh_date(p_obj, 'AC');
        else
            v_date_opened := osi_status.first_sh_date(p_obj, 'OP');
        end if;

        v_ok := core_template.replace_tag(v_return, 'DOPENED', to_char(v_date_opened, 'YYYYMMDD'));

        --- Get Date Closed ---
        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            v_date_closed := osi_status.last_sh_date(p_obj, 'TM');
        else
            v_date_closed := osi_status.last_sh_date(p_obj, 'CL');
        end if;

        v_ok := core_template.replace_tag(v_return, 'DCLOSED', to_char(v_date_closed, 'YYYYMMDD'));

        --- Get Location Information ---
        v_city := core_list.get_list_element(osi_address.get_addr_fields(osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),'UNIT_ADDR')),3, '~^~');
        if v_city is not null then

          v_city := v_city || ', ';
          
        end if;
        
        begin
             select code into v_state from t_dibrs_state where sid=core_list.get_list_element(osi_address.get_addr_fields(osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),'UNIT_ADDR')),4, '~^~');
             v_state := v_state || ', ';
              
        exception when others then

                 v_state := null;
                 
        end;
        
        v_country := dibrs_reference.get_country_desc(core_list.get_list_element(osi_address.get_addr_fields(osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj),'UNIT_ADDR')),6, '~^~'));
        if v_country = 'United States of America' then

          v_country := '';
          
        end if;
         
        v_ok := core_template.replace_tag(v_return,'LOCATION',rtrim(osi_unit.get_name(osi_object.get_assigned_unit(p_obj)) || ' ' || v_city || v_state || v_country,', '));

        --- Get Related Files ---
        v_file_count := 1;

        if (osi_object.get_objtype_code(p_obj) = 'FILE.SOURCE') then
            for x in (select   nvl(file_full_id, file_id) as id
                          from v_osi_file
                         where (sid in(select file_sid
                                         from v_osi_assoc_fle_act
                                        where activity_sid in(select sid
                                                                from t_osi_activity
                                                               where source = p_obj)))
                      order by id)
            loop
                v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, x.id);
                v_file_count := v_file_count + 1;

                if (v_file_count > 5) then
                    exit;
                end if;
            end loop;
        else
            for k in (select   nvl(that_file_full_id, that_file_id) as id
                          from v_osi_assoc_fle_fle
                         where this_file = p_obj
                      order by that_file_id)
            loop
                v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, k.id);
                v_file_count := v_file_count + 1;

                if (v_file_count > 5) then
                    exit;
                end if;
            end loop;
        end if;

        --- If there aren't 5 files, make the WEBTOK@FILE#'s that remain blank ---
        loop
            exit when v_file_count > 5;
            v_ok := core_template.replace_tag(v_return, 'FILE' || v_file_count, '');
            v_file_count := v_file_count + 1;
        end loop;

        --- Set form Information ---
        if (v_classification = 'U') then
            v_ok :=
                core_template.replace_tag
                                       (v_return,
                                        'CLASS',
                                        '\b\f36\fs48\cf11 ' || chr(13) || chr(10)
                                        || 'UNCLASSIFIED//FOR OFFICIAL USE ONLY \b\f36\fs48\cf11 '
                                        || chr(13) || chr(10) || '\par \b\f1\fs36\cf11 ',
                                        p_multiple       => true);
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2A, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok := core_template.replace_tag(v_return, 'FORM_MESSAGE', '', p_multiple => true);
        elsif v_classification = 'C' then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'CLASS',
                                          '\b\f1\fs12\cf8 ' || chr(13) || chr(10)
                                          || '\par \b\f1\fs72\cf8 C O N F I D E N T I A L',
                                          p_multiple       => true);
            v_return := replace(v_return, '\clcbpat8', '\clcbpat2');
            v_return := replace(v_return, '\clcbpatraw8', '\clcbpatraw2');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2B, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORM_MESSAGE',
                                          '(Form is UNCLASSIFIED when attachments are removed)',
                                          p_multiple       => true);
        elsif v_classification = 'S' then
            v_ok :=
                core_template.replace_tag(v_return,
                                          'CLASS',
                                          '\b\f1\fs12\cf8 ' || chr(13) || chr(10)
                                          || '\par \b\f1\fs72\cf8 S    E    C    R    E    T',
                                          p_multiple       => true);
            v_return := replace(v_return, '\clcbpat8', '\clcbpat6');
            v_return := replace(v_return, '\clcbpatraw8', '\clcbpatraw6');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORMTYPE',
                                          'AFOSI FORM 2C, 14 DECEMBER 2006 (I2MS-V1)');
            v_ok :=
                core_template.replace_tag(v_return,
                                          'FORM_MESSAGE',
                                          '(Form is UNCLASSIFIED when attachments are removed)',
                                          p_multiple       => true);
        end if;

        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_form2: ' || sqlerrm);
            raise;
    end rpt_generate_form2;

    /* Used to generate the File Barcode Label (Label # 30252) report */
    function rpt_generate_30252(p_obj in varchar2)
        return clob is
        v_ok            varchar2(2000);
        v_return_date   date;
        v_return        clob;
        v_mime_type     t_core_template.mime_type%type;
        v_mime_disp     t_core_template.mime_disposition%type;
        v_placeholder   varchar2(200);
        v_id            t_osi_file.id%type;
        v_full_id       t_osi_file.full_id%type;
    begin
        --Get latest template
        v_ok :=
            core_template.get_latest('LABEL_FILE_30252',
                                     v_return,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);

        --Get ID and FULL ID
        select id, full_id
          into v_id, v_full_id
          from t_osi_file
         where sid = p_obj;

        --Write FULL_ID
        if (v_full_id is null) then
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_id);
        else
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_full_id);
        end if;

        --Write ID
        v_ok := core_template.replace_tag(v_return, 'ID', '*' || v_id || '*', p_multiple => true);
        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_30252: ' || sqlerrm);
            raise;
    end rpt_generate_30252;

    /* Used to generate the File Barcode Label (Label # 30252) report */
    function rpt_generate_30256(p_obj in varchar2)
        return clob is
        v_ok              varchar2(2000);
        v_return_date     date;
        v_return          clob;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_placeholder     varchar2(200);
        --v_id            t_osi_file.ID%TYPE;
        --v_full_id       t_osi_file.full_id%TYPE;
        v_file_type       varchar2(200);
        v_id              varchar2(200);
        v_full_id         varchar2(200);
        v_tempstring      clob;
        v_offense_count   number;
        v_subject_count   number;
    begin
        --Get latest template
        v_ok :=
            core_template.get_latest('FORM_3986_LABEL',
                                     v_return,
                                     v_return_date,
                                     v_mime_type,
                                     v_mime_disp);

        select upper(file_type_desc), file_id, file_full_id
          into v_file_type, v_id, v_full_id
          from v_osi_file
         where sid = p_obj;

        --- Header Information ---
        if substr(v_file_type,length(v_file_type)-4)=' FILE' then

          v_ok := core_template.replace_tag(v_return, 'FILETYPE', 'I2MS ' || v_file_type);

        else

          v_ok := core_template.replace_tag(v_return, 'FILETYPE', 'I2MS ' || v_file_type || ' FILE');

        end if;
        
        --Offenses
        v_offense_count := 0;

        for k in (select offense_desc
                    from v_osi_f_inv_offense
                   where investigation = p_obj and priority_desc = 'Primary')
        loop
            v_ok := core_template.replace_tag(v_return, 'OFFENSE', k.offense_desc);
            v_offense_count := v_offense_count + 1;
        end loop;

        --If no offenses exist, then replace tag with nothing.
        if (v_offense_count = 0) then
            v_ok := core_template.replace_tag(v_return, 'OFFENSE', '');
        end if;

        --- Footer Information ---
        v_ok := core_template.replace_tag(v_return, 'ID', '*' || v_id || '*', p_multiple => true);

        if (v_full_id is null) then
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_id, p_multiple => true);
        else
            v_ok := core_template.replace_tag(v_return, 'FULLID', v_full_id, p_multiple => true);
        end if;

        v_subject_count := 1;

        --- Subjects Header ---
        if (osi_object.get_objtype_code(core_obj.get_objtype(p_obj)) = 'FILE.AAPP') then

          v_tempstring := '\viewkind1\uc1\pard\b\f1\fs20 Subject:\par';
          
       elsif (osi_object.get_objtype_code(core_obj.get_objtype(p_obj)) != 'FILE.SOURCE') then

             v_tempstring := '\viewkind1\uc1\pard\b\f1\fs20 Subjects:\par';

        end if;

        for k in
            (select osi_participant.get_name(participant_version) as the_name,
                    osi_participant.get_number(participant_version,
                                               'SSN') as social_security_number,
                    osi_object.get_objtype_code
                             (osi_participant.get_type_sid(participant_version))
                                                                                as person_type_code
               from v_osi_partic_file_involvement
              where file_sid = p_obj and role in('Subject', 'Examinee','Applicant'))
        loop
            --- Black Line ---
            v_tempstring :=
                v_tempstring
                || '\viewkind1\uc1\trowd\trgaph108\trleft-108\trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';
            v_tempstring :=
                v_tempstring
                || '\clbrdrb\brdrw30\brdrs \cellx3290\pard\intbl\nowidctlpar\b\f1\fs4\cell\row\pard\nowidctlpar\b0\f0\fs24';
            --- Name and Social Security Number ---
            v_tempstring :=
                v_tempstring
                || '\viewkind1\uc1\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';
            v_tempstring :=
                v_tempstring || '\cellx3290\pard\intbl\b\f1\fs20 '
                || ltrim(rtrim(upper(k.the_name)))
                || '\cell\row\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3';

            if (k.person_type_code = 'PART.INDIV') then
                v_tempstring :=
                    v_tempstring || '\cellx3290\pard\intbl ' || 'SSN: ' || k.social_security_number
                    || '\cell\row\pard';
            else
                v_tempstring := v_tempstring || '\cellx3290\pard\intbl \cell\row\pard';
            end if;

            v_subject_count := v_subject_count + 1;

            if v_subject_count > 3 then
                exit;
            end if;
        end loop;

        v_ok := core_template.replace_tag(v_return, 'SUBJECTS', v_tempstring);
        return v_return;
    exception
        when others then
            log_error('osi_file.rpt_generate_30256: ' || sqlerrm);
            raise;
    end rpt_generate_30256;

    /* Given an Object SID, will return the proper FULL_ID */
    function generate_full_id(p_obj in varchar2)
        return varchar2 is
        v_ot_code   t_core_obj_type.code%type;
        v_return    t_osi_file.full_id%type;
    begin
        select ot.code
          into v_ot_code
          from t_core_obj o, t_core_obj_type ot
         where o.sid = p_obj and ot.sid = o.obj_type;

        /* Developers Note: (By Richard Dibble)
        The arcitecture for handling Full ID's was discussed on 04/02/2010 by Richard Dibble and Tim McGuffin.
        Ultimately we would like to centralize the creation of full ID's.
         To do this we need the equivalent to the I2MS.T_FILE_TYPE.FULL_ID_TAG column (probably in the T_OSI_OBJECT_TYPE table)
        Also, since most file Full ID's are similiar, we discussed using the CASE statement below just for special cases, and the ELSE would handle non-special cases.
         But, since we need the FULL_ID_TAG field, which we do not have, we are leaving this function
         as it is now, and will modify it later to properly handle Full ID integration across all objects.
         This was the Recommendation of Tim McGuffin - 04/02/2010

        */
        case
            when v_ot_code like 'FILE.INV%' then
                v_return := osi_investigation.generate_full_id(p_obj);
            when v_ot_code like 'FILE.PSO%' then
                v_return := osi_pso.generate_full_id(p_obj);
            else
                v_return := null;
        end case;

        return v_return;
    exception
        when others then
            log_error('osi_file.generate_full_id: ' || sqlerrm);
            raise;
    end generate_full_id;

--======================================================================================================================
-- This is a catch all to make a html page based on those type of files that are not
-- Participants, Case files, or Activities.  If the are found then put a page out with
-- minimum information.
--======================================================================================================================
    procedure make_doc_misc_file(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp_clob          clob;
        v_template           clob;
        v_file_id            v_osi_file.file_id%type;
        v_title              t_core_obj_type.description%type;
        v_sid                t_core_obj.sid%type;
        v_type_description   t_core_obj_type.description%type;
        v_ok                 varchar2(1000);                 -- flag indicating success or failure.
        v_template_date      date;               -- date of the most recent version of the template
    begin
        core_logger.log_it(c_pipe, '--> make_doc_misc_file');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                         (c_pipe,
                          'ODW.Make_Doc_Misc_File: File is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                        (c_pipe,
                         'ODW.Make_Doc_Misc_File: File is LIMDIS - no document will be synthesized');
            return;
        end if;

        select osf.file_id, obt.description as title, osf.sid, obt.description as type_description
          into v_file_id, v_title, v_sid, v_type_description
          from v_osi_file osf, t_core_obj ob, t_core_obj_type obt
         where osf.sid = p_sid and osf.sid = ob.sid and ob.obj_type = obt.sid;

        osi_object.get_template('OSI_ODW_DETAIL_MISC_FILE', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Fill in data
        v_ok := core_template.replace_tag(v_template, 'ID', v_file_id);

        if v_title is not null then
            v_ok := core_template.replace_tag(v_template, 'TITLE', v_title);
        else
            v_ok := core_template.replace_tag(v_template, 'TITLE', v_sid);
        end if;

        v_ok := core_template.replace_tag(v_template, 'TYPE', v_type_description);
        -- get Attachment Descriptions
        osi_object.append_attachments(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENT_DESC', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- return the completed template
        dbms_lob.append(p_doc, v_template);
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_misc_file');
    exception
        when no_data_found then
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_Misc_File Error: Non File SID Encountered.');
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_Misc_File Error: ' || v_syn_error);
    end make_doc_misc_file;
end osi_file;
/


