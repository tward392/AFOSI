-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_REPORT" as
/******************************************************************************
   Name:     Osi_Report
   Purpose:  Provides Functionality for Reportd

   Revisions:
     Date         Author          Description
     -----------  --------------  ------------------------------------
     29-Oct-2009  Richard Dibble  Created Package
     02-Nov-2009  Richard Dibble  Added replace_special_chars_clob and clob_replace
     02-Dec-2009  Richard Dibble  Removed REPLACE_TAG functions as they already exist in CORE_TEMPLATE
     28-May-2010  JaNelle Horne   Added replace_special_chars
     11-Jun-2010  Thomas Whitehad Added get_agent_name.
     07-Jan-2011  Tim Ward        Moved load_agents_assigned from OSI_INVESTIGATION to here.
     07-Jan-2011  Tim Ward        Moved get_assignments from OSI_INVESTIGATION to here.
     07-Jan-2011  Tim Ward        Moved build_agent_name from OSI_INVESTIGATION to here.
******************************************************************************/

    /*
        Updates Text by replacing the specified Tag with Replacement. The
        actual string searched for is '['<prefix><tag>']'. For example, if
        Tag is "NAME", and Replacement is "John Doe", and Prefix is not
        specified, The first occurrance of "[WEBTOK@NAME]" will be replaced
        with "John Doe".
    */
    function get_agent_name(p_obj in varchar2, p_role in varchar2 := 'LEAD')
        return varchar2;

    /* Used to replace special characters */
    function replace_special_chars_clob(p_text in clob, p_htmlorrtf in varchar2)
        return clob;

    function replace_special_chars(ptext in varchar2, htmlorrtf in varchar2)
        return varchar2;

    /* Does some clob replacing stuff */
    function clob_replace(p_text in clob, p_search_for in varchar2, p_replacement in varchar2)
        return clob;

    procedure load_agents_assigned(p_file_sid in varchar2);

    function get_assignments(
        psid       in   varchar2,
        proleset   in   varchar2 := null,
        psep       in   varchar2 := ', ')
        return varchar2;

    function build_agent_name(
        p_personnel    in   varchar2,
        p_sort_order   in   number,
        p_sep          in   varchar2 := ', ')
        return varchar2;
    
end osi_report;
/


CREATE OR REPLACE package body osi_report as
/******************************************************************************
   Name:     Osi_Report
   Purpose:  Provides Functionality for Reportd

   Revisions:
     Date         Author          Description
     -----------  --------------  ------------------------------------
     29-Oct-2009  Richard Dibble  Created Package
     02-Nov-2009  Richard Dibble  Added replace_special_chars_clob and clob_replace
     02-Dec-2009  Richard Dibble  Removed REPLACE_TAG functions as they already exist in CORE_TEMPLATE
     28-May-2010  JaNelle Horne   Added replace_special_chars
     11-Jun-2010  Thomas Whitehad Added get_agent_name.
     08-Oct-2010  Richard Dibble  Modified replace_special_chars/return varchar to handle 32767 bytes instead of 32000
     07-Jan-2011  Tim Ward        Moved load_agents_assigned from OSI_INVESTIGATION to here.
     07-Jan-2011  Tim Ward        Moved get_assignments from OSI_INVESTIGATION to here.
     07-Jan-2011  Tim Ward        Moved build_agent_name from OSI_INVESTIGATION to here.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_REPORT';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_agent_name(p_obj in varchar2, p_role in varchar2 := 'LEAD')
        return varchar2 is
    begin
        for x in (select   first_name,
                           decode(middle_name,
                                  null, '(UNK)',
                                  '', '(UNK)',
                                  middle_name) as middle_name,
                           last_name, current_unit
                      from v_osi_obj_assignments
                     where obj = p_obj and role = p_role
                  order by start_date desc)
        loop
            return 'SA ' || x.first_name || ' ' || x.middle_name || ' ' || x.last_name || ', '
                   || osi_unit.get_name(x.current_unit);
        end loop;

        return null;
    end get_agent_name;

    function replace_special_chars_clob(p_text in clob, p_htmlorrtf in varchar2)
        return clob is
        v_text   clob;
    begin
        v_text := p_text;

        if p_htmlorrtf = 'HTML' then
            v_text :=
                replace(replace(replace(replace(replace(v_text, '<', '&lt'), '>', '&gt'),
                                        chr(10) || chr(13),
                                        '<BR>'),
                                chr(13) || chr(10),
                                '<BR>'),
                        chr(10),
                        '<BR>');
        end if;

        if p_htmlorrtf = 'RTF' then
            v_text := replace(v_text, '\', '\\');
            v_text := replace(v_text, '{', '\{');
            v_text := replace(v_text, '}', '\}');
            v_text := replace(v_text, chr(13) || chr(10), '~|~|z');
            v_text := replace(v_text, chr(10) || chr(13), '~|~|z');
            v_text := replace(v_text, chr(13), '~|~|z');
            v_text := replace(v_text, chr(10), '~|~|z');
            v_text := replace(v_text, '~|~|z', '\par' || chr(13) || chr(10));
        end if;

        return v_text;
    end replace_special_chars_clob;

    function replace_special_chars(ptext in varchar2, htmlorrtf in varchar2)
        return varchar2 is
        v_text   varchar2(32767);
    begin
        if htmlorrtf = 'HTML' then
            v_text :=
                replace(replace(replace(replace(replace(ptext, '<', '&lt'), '>', '&gt'),
                                        chr(10) || chr(13),
                                        '<BR>'),
                                chr(13) || chr(10),
                                '<BR>'),
                        chr(10),
                        '<BR>');
        end if;

        if htmlorrtf = 'RTF' then
            v_text := replace(ptext, '\', '\\');
            v_text := replace(v_text, '{', '\{');
            v_text := replace(v_text, '}', '\}');
            v_text := replace(v_text, chr(13) || chr(10), '~|~|z');
            v_text := replace(v_text, chr(10) || chr(13), '~|~|z');
            v_text := replace(v_text, chr(13), '~|~|z');
            v_text := replace(v_text, chr(10), '~|~|z');
            v_text := replace(v_text, '~|~|z', '\par' || chr(13) || chr(10));
        end if;

        return v_text;
    exception
        when others then
            log_error('OSI_REPORT.replace_special_chars:' || sqlerrm);
    end replace_special_chars;

    function clob_replace(p_text in clob, p_search_for in varchar2, p_replacement in varchar2)
        return clob is
        v_work      clob;
        v_sqlerrm   varchar2(1000);
        v_start     number         := 1;
        v_end       number;
        v_size      number;
        v_tag       varchar2(100);
        v_text      varchar2(50);
        v_search    varchar2(10);
        v_replace   varchar2(10);
    begin
        v_tag := 'Saving Parameters';
        v_text := dbms_lob.substr(p_text, 50, 1);
        v_search := substr(p_search_for, 1, 10);
        v_replace := substr(p_replacement, 1, 10);
        v_tag := 'Creating Temp';
        dbms_lob.createtemporary(v_work, false);
        v_tag := 'Opening Temp';
        dbms_lob.open(v_work, dbms_lob.lob_readwrite);

        if nvl(length(v_text), 0) = 0 then
            v_tag := 'Returning empty clob';
            dbms_lob.close(v_work);
            return v_work;
        end if;

        if p_search_for is null then
            v_tag := 'Copying Original';
            dbms_lob.copy(v_work, p_text, dbms_lob.getlength(p_text));
            dbms_lob.close(v_work);
            return v_work;
        end if;

        loop
            v_tag := 'Getting length of Temp';
            v_size := dbms_lob.getlength(v_work);
            v_tag := 'Searching Text';
            v_end := dbms_lob.instr(p_text, p_search_for, v_start);

            if nvl(v_end, 0) = 0 then                                -- copy rest of pText and exit
                v_tag := 'Copying Remainder';
                dbms_lob.copy(v_work, p_text, 2000000000,(v_size + 1), v_start);
                exit;
            end if;

            -- Copy upto the found value
            if v_end > v_start then
                v_tag := 'Copying First Part';
                dbms_lob.copy(v_work, p_text,(v_end - v_start),(v_size + 1), v_start);
            end if;

            -- Append the replacement value
            if length(p_replacement) > 0 then
                v_tag := 'Appending Replacement';
                dbms_lob.writeappend(v_work, length(p_replacement), p_replacement);
            end if;

            v_start := v_end + length(p_search_for);
            exit when v_start > dbms_lob.getlength(p_text);
        end loop;

        v_tag := 'Returning Temp';
        dbms_lob.close(v_work);
        return v_work;
    exception
        when others then
            v_sqlerrm := sqlerrm;
            log_error('Clob_Replace Error (' || v_tag || '): ' || v_sqlerrm);
            log_error('  Text/Search/Replacement: ' || v_text || '/' || v_search || '/' || v_replace);

            if dbms_lob.getlength(p_text) > 0 then
                dbms_lob.copy(v_work, p_text, dbms_lob.getlength(p_text));
            end if;

            dbms_lob.close(v_work);
            return v_work;
    end clob_replace;

    procedure load_agents_assigned(p_file_sid in varchar2) is
        v_count        number;
        v_is_agent     varchar2(3);
        v_city         varchar2(100);
        v_state        varchar2(100);
        v_full         varchar2(1000);
        v_short        varchar2(1000);
        v_loop_count   number         := 0;
        v_new_name     varchar2(1000);
        pragma autonomous_transaction;
    begin
        delete from t_osi_report_agents_used;

        commit;

        for a in (select   p.first_name, p.middle_name, p.last_name, p.unit_name, p.unit,
                           p.badge_num, a.personnel
                      from v_osi_obj_assignments a, v_osi_personnel p
                     where a.role not in('ADMIN') and p.sid = a.personnel and a.obj = p_file_sid
                  union all
                  select   p.first_name, p.middle_name, p.last_name, p.unit_name, p.unit,
                           p.badge_num, sid
                      from v_osi_personnel p
                     where p.sid in(
                               select obtained_by_sid
                                 from v_osi_evidence
                                where obj in(
                                          select activity_sid
                                            from t_osi_assoc_fle_act
                                           where (   file_sid = p_file_sid
                                                  or file_sid in(select that_file
                                                                   from v_osi_assoc_fle_fle
                                                                  where this_file = p_file_sid))))
                  union all
                  select   p.first_name, p.middle_name, p.last_name, p.unit_name, p.unit,
                           p.badge_num, a.personnel
                      from v_osi_obj_assignments a, v_osi_personnel p, v_osi_assoc_fle_act fc
                     where a.role not in('ADMIN')
                       and p.sid = a.personnel
                       and a.obj = fc.activity_sid
                       and fc.file_sid = p_file_sid
                  order by 3, 1, 2)
        loop
            select count(*)
              into v_count
              from t_osi_report_agents_used
             where personnel = a.personnel;

            if (v_count = 0) then
                if    a.badge_num is null
                   or a.badge_num = '' then
                    v_is_agent := '';
                else
                    v_is_agent := 'SA ';
                end if;

                begin
                    select city, state_code
                      into v_city, v_state
                      from v_osi_address va
                     where va.obj = a.unit;
                exception
                    when no_data_found then
                        v_city := null;
                        v_state := null;
                end;

                v_full :=
                      a.first_name || ' ' || a.last_name || '~~LEAD_OR_NOT~~' || ', ' || a.unit_name;

                if (v_city is not null) then
                    v_full := v_full || ', ' || v_city;
                end if;

                if (v_state is not null) then
                    v_full := v_full || ', ' || v_state;
                end if;

                v_short := a.last_name || '~~LEAD_OR_NOT~~';
                log_error('<<Load_Agents_Assigned Full/Short=' || v_full || '/' || v_short);

                insert into t_osi_report_agents_used
                            (personnel,
                             last_name,
                             first_name,
                             middle_name,
                             unit_name,
                             unit_city,
                             unit_state,
                             is_agent,
                             used,
                             full,
                             short)
                     values (a.personnel,
                             a.last_name,
                             a.first_name,
                             a.middle_name,
                             a.unit_name,
                             v_city,
                             v_state,
                             v_is_agent,
                             0,
                             v_full,
                             v_short);

                commit;
            end if;
        end loop;

------------------------------------------------------------------------------------------------------------
--- Now check for Duplicate Short Names twice, and Use First Name for 1st Pass, Middle Name for 2nd Pass ---
------------------------------------------------------------------------------------------------------------
        begin
            loop
                v_loop_count := v_loop_count + 1;

                for a in (select   *
                              from t_osi_report_agents_used
                          order by last_name, first_name, middle_name)
                loop
                    select count(*)
                      into v_count
                      from t_osi_report_agents_used
                     where short = a.short;

                    if (v_count > 1) then
                        for b in (select *
                                    from t_osi_report_agents_used
                                   where short = a.short)
                        loop
                            if v_loop_count = 1 then
                                v_new_name :=
                                            b.first_name || ' ' || b.last_name || '~~LEAD_OR_NOT~~';

                                update t_osi_report_agents_used
                                   set short = v_new_name
                                 where personnel = b.personnel;

                                log_error('<<Load_Agents_Assigned>> vLoopCount=1--->' || b.short
                                          || ' changed to ' || v_new_name);
                            elsif(v_loop_count = 2) then
                                v_new_name :=
                                    b.first_name || ' ' || b.middle_name || ' ' || b.last_name
                                    || '~~LEAD_OR_NOT~~';

                                update t_osi_report_agents_used
                                   set short = v_new_name
                                 where personnel = b.personnel;

                                log_error('<<Load_Agents_Assigned>> vLoopCount=2--->' || b.short
                                          || ' changed to ' || v_new_name);
                            end if;

                            commit;
                        end loop;
                    end if;
                end loop;

                exit when v_loop_count = 3;
            end loop;
        end;

---------------------------------------------------------------------------------
--- Now check for Duplicate Full Names, Then add Middle Name to the Full Name ---
---------------------------------------------------------------------------------
        for a in (select   *
                      from t_osi_report_agents_used
                  order by last_name, first_name, middle_name)
        loop
            select count(*)
              into v_count
              from t_osi_report_agents_used
             where last_name = a.last_name and first_name = a.first_name;

            if (v_count > 1) then
                for b in (select *
                            from t_osi_report_agents_used
                           where last_name = a.last_name and first_name = a.first_name)
                loop
                    update t_osi_report_agents_used
                       set full =
                               replace(full,
                                       b.first_name || ' ' || b.last_name,
                                       b.first_name || ' ' || b.middle_name || ' ' || b.last_name)
                     where personnel = b.personnel;

                    log_error('<<Load_Agents_Assigned>> vLoopCount=1--->' || b.full
                              || ' changed to add Middle Name');
                    commit;
                end loop;
            end if;
        end loop;
    end load_agents_assigned;

    function get_assignments(
        psid       in   varchar2,
        proleset   in   varchar2 := null,
        psep       in   varchar2 := ', ')
        return varchar2 is
/*
    Returns list of personnel assigned to current activity. If pRoleSet is null
    (default), all assignments are processed. If pRoleSet is not null, it must be
    a list of Roles to process. The list should be prefixed, suffixed and separated
    by tildes (~). For example: ~Lead Agent~
*/
        vtmp1        varchar2(32000) := null;
        vusednames   varchar2(32000) := '~NONEYET~,';
        pragma autonomous_transaction;
    begin
        log_error('Starting get_assignments');

        for a in (select   a.personnel, decode(art.description, 'Lead Agent', 1, 99) as sortorder
                      from t_osi_assignment a, t_core_personnel p, t_osi_assignment_role_type art
                     where art.description not in('Administrative')
                       and a.obj = psid
                       and p.sid = a.personnel
                       and a.assign_role = art.sid
                       and (   proleset is null
                            or instr(proleset, '~' || art.description || '~') > 0)
                  order by sortorder, p.last_name, p.first_name, p.middle_name)
        loop
            if instr(vusednames, a.personnel || ',') = 0 then
                vtmp1 := vtmp1 || build_agent_name(a.personnel, a.sortorder, psep) || psep;
                vusednames := vusednames || a.personnel || ',';
            end if;
        end loop;

        log_error('Get_Assignments---(' || psid || ')>' || vtmp1);
        return rtrim(vtmp1, psep);
    end get_assignments;

    function build_agent_name(
        p_personnel    in   varchar2,
        p_sort_order   in   number,
        p_sep          in   varchar2 := ', ')
        return varchar2 is
        v_tmp_1   varchar2(1000) := null;
        v_tmp_2   varchar2(1000) := null;
        pragma autonomous_transaction;
    begin
        select is_agent || decode(used, 0, full, short)
          into v_tmp_1
          from t_osi_report_agents_used
         where personnel = p_personnel;

        update t_osi_report_agents_used
           set used = 1
         where personnel = p_personnel;

        commit;

        if (p_sort_order = 1) then
            v_tmp_1 := replace(v_tmp_1, '~~LEAD_OR_NOT~~', ' (LEAD)');
        else
            v_tmp_1 := replace(v_tmp_1, '~~LEAD_OR_NOT~~', '');
        end if;

        if (v_tmp_2 is null) then
            v_tmp_2 := v_tmp_1;
        else
            v_tmp_2 := v_tmp_2 || p_sep || v_tmp_1;
        end if;

        return v_tmp_2;
    end build_agent_name;

end osi_report;
/