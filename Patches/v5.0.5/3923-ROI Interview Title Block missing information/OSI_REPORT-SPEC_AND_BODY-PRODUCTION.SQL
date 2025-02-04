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
     20-Jan-2011  Tim Ward        Added form686, v_Date_Format, v_Box_Empty, v_Box_withX.
     
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

    FUNCTION Form686(pSID IN VARCHAR2) RETURN CLOB;

    v_Date_Format Varchar2(15) := 'FMDD Mon FMFXYY';

    v_Box_Empty VARCHAR2(3) := '''6f'; ---6f     
    v_Box_withX VARCHAR2(3) := '''fd'; ---78';
    
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
     20-Jan-2011  Tim Ward        Added form686.

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
    
    FUNCTION Form686(pSID IN VARCHAR2) RETURN CLOB IS

      v_ok BOOLEAN; --varchar2(2);
      v_ok1 varchar2(2);
      
      v_template                   clob                                    := null;
      v_template_date              date;

      v_mime_type                  t_core_template.mime_type%type;
      v_mime_disp                  t_core_template.mime_disposition%type;

      vPERVERSID varchar2(20) := NULL;
      vSSN varchar2(50);

      vADDR varchar2(4000);
      vADDRZipCode varchar2(4000);

      vNUMSource varchar2(10);
  
      vMarks varchar2(32000) := '';
      vAliases varchar2(32000) := '';
    
      vDataUnknown varchar2(1) := '';

      dDate Date;

      vActivityID varchar2(100);

      vClearance varchar2(100);

      vFileID varchar2(100);

      v_act_obj_type_sid varchar2(20);
      
      v_obj_type_sid varchar2(20);
      v_obj_type_code varchar2(100);
            
    BEGIN

      core_logger.LOG_IT(c_pipe, '>>>Form686 - ' || pSID);
  
      /* Grab template and assign to v_template  */
      v_ok1 := core_template.get_latest('form686',
                                       v_template,
                                       v_template_date,
                                       v_mime_type,
                                       v_mime_disp);
 
      core_logger.LOG_IT(c_pipe, 'Form686 - ' || pSID);
      
      --- Get the Object Type SID for ALL ACTIVITIES ---
      select sid into v_act_obj_type_sid from t_core_obj_type where code='ACT';

      core_logger.LOG_IT(c_pipe, 'Form686 - v_act_obj_type_sid=' || v_act_obj_type_sid);

      --- Get the Object Type SID and Code for pSID (Object passed in) ---
      select t.sid,t.code into v_obj_type_sid,v_obj_type_code from t_core_obj_type t,t_core_obj o where o.obj_type=t.sid and o.sid=pSID;

      core_logger.LOG_IT(c_pipe, 'Form686 - v_obj_type_sid,v_obj_type_code=' || v_obj_type_sid || ',' || v_obj_type_code);
  
      --- Get the PARTICIPANT_VERSION field ---
      case 
          
          when v_obj_type_code like 'ACT.%' then
              
              BEGIN
                   SELECT PARTICIPANT_VERSION INTO vPERVERSID 
                         FROM T_OSI_PARTIC_INVOLVEMENT 
                         WHERE OBJ=pSID 
                           AND INVOLVEMENT_ROLE IN (SELECT SID FROM T_OSI_PARTIC_ROLE_TYPE WHERE UPPER(ROLE)='SUBJECT OF ACTIVITY' AND OBJ_TYPE=v_obj_type_sid);

              EXCEPTION WHEN OTHERS THEN
              
                       vPERVERSID := NULL;
                       
              END;
                    
          when v_obj_type_code = 'PART.INDIV' then
              
              BEGIN
                   SELECT CURRENT_VERSION INTO vPERVERSID from T_OSI_PARTICIPANT WHERE SID=pSID;
                   dDate := SYSDATE();
                   
              EXCEPTION WHEN OTHERS THEN
                       
                       vPERVERSID := NULL;
                       
              END;
          
      end case;

      core_logger.LOG_IT(c_pipe, 'Form686 - vPERVERSID=' || vPERVERSID);

      --- Get the Activity ID --- 
      BEGIN
           SELECT ID,ACTIVITY_DATE INTO vActivityID,dDate FROM T_OSI_ACTIVITY WHERE SID=pSID;

      EXCEPTION WHEN OTHERS THEN

               dDate := SYSDATE();
               vActivityID := ''; 

      END;

      core_logger.LOG_IT(c_pipe, 'Form686 - vAcitivityID=' || vActivityID);

      --- Get File ID if Activity is associated to a File ---
      vFileID := null;      
      if vActivityID IS NOT NULL then      

        FOR P IN (SELECT ID FROM T_OSI_FILE F,T_OSI_ASSOC_FLE_ACT A WHERE F.SID=A.FILE_SID AND A.ACTIVITY_SID=pSID ORDER BY A.MODIFY_ON)
        LOOP
            vFileID := P.ID;
            
        END LOOP;

      else

        FOR P IN (select ID from t_osi_partic_involvement i,t_osi_file f where i.participant_version in (select sid from t_osi_participant_version where participant=pSID) and i.obj=f.sid order by create_on)
        LOOP
            vFileID := P.ID;

        END LOOP;

      end if;
      
      core_logger.LOG_IT(c_pipe, 'Form686 - vFileID=' || vFileID);
      
      if vPERVERSID IS NOT NULL Then
  
        if vFileID IS NULL then

          v_ok := web_template_pkg.Replace_Tag(v_template, 'FILE_ID', vActivityID, 'WEBTOK@', TRUE);
          
        else

          v_ok := web_template_pkg.Replace_Tag(v_template, 'FILE_ID', vFileID, 'WEBTOK@', TRUE);
 
        end if;
 
        FOR P IN (SELECT * FROM V_OSI_PARTICIPANT_VERSION WHERE SID=vPERVERSID)
        LOOP
            v_ok := web_template_pkg.Replace_Tag(v_template, 'DATE', TO_CHAR(dDate,v_Date_Format), 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'INSTALLATION', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'AVAILABLE_NAME', vDataUnknown, 'WEBTOK@', TRUE);
    
 
            v_ok := web_template_pkg.Replace_Tag(v_template, 'SUBJECT', P.FULL_NAME, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'CAD', P.IND_CADENCY, 'WEBTOK@', TRUE);
  
            FOR A IN (SELECT * FROM V_OSI_PARTIC_NAME WHERE PARTICIPANT_VERSION=vPERVERSID AND TYPE_CODE IN ('A','M','AKA'))
            LOOP
                vAliases := vAliases || rtrim(rtrim(A.FULL_NAME,', ')) || '; ';
   
            END LOOP;
            v_ok := web_template_pkg.Replace_Tag(v_template, 'ALIAS', vAliases, 'WEBTOK@', TRUE);

            v_ok := web_template_pkg.Replace_Tag(v_template, 'GRADE', P.SA_PAY_GRADE_DESC, 'WEBTOK@', TRUE);

            BEGIN
                 SELECT NUM_VALUE INTO vSSN FROM V_OSI_PARTIC_NUMBER WHERE PARTICIPANT_VERSION=vPERVERSID AND NUM_TYPE_CODE='SSN';

            EXCEPTION WHEN OTHERS THEN

                     vSSN := '';
     
            END;
            
            v_ok := web_template_pkg.Replace_Tag(v_template, 'SSN', vSSN, 'WEBTOK@', TRUE);
  
            v_ok := web_template_pkg.Replace_Tag(v_template, 'SER', P.SA_SERVICE_DESC, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'COM', P.SA_COMPONENT_DESC, 'WEBTOK@', TRUE);
  
            v_ok := web_template_pkg.Replace_Tag(v_template, 'MC', P.ORG_MAJCOM_DESC, 'WEBTOK@', TRUE);

            v_ok := web_template_pkg.Replace_Tag(v_template, 'ORG', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'IDENT', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'TITLE', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'AFSC', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'DTARRIVED', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'ENL', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'DEROS', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'ETS', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'DOS', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'TSD', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'YEARS', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'MONTHS', vDataUnknown, 'WEBTOK@', TRUE);

            BEGIN
                 select osi_participant.get_address_data(vPERVERSID, 'MAIL', 'POSTAL_CODE') INTO vADDRZipCode from dual;

            EXCEPTION WHEN OTHERS THEN

                     vADDRZipCode := '';
     
            END;

            BEGIN
                 select osi_participant.get_address_data(vPERVERSID, 'MAIL', 'DISPLAY') INTO vADDR from dual;

            EXCEPTION WHEN OTHERS THEN

                     vADDR := '';
     
            END;

            v_ok := web_template_pkg.Replace_Tag(v_template, 'ADDRESS', vADDR, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'Z1', vADDRZipCode, 'WEBTOK@', TRUE);
    
            v_ok := web_template_pkg.Replace_Tag(v_template, 'ADD_RECORD', vDataUnknown, 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'Z2', vDataUnknown, 'WEBTOK@', TRUE);
  
            v_ok := web_template_pkg.Replace_Tag(v_template, 'POB', OSI_PARTICIPANT.GET_ADDRESS_DATA(vPERVERSID,'BIRTH','DISPLAY'), 'WEBTOK@', TRUE);
            v_ok := web_template_pkg.Replace_Tag(v_template, 'DOB', TO_CHAR(P.DOB,v_Date_Format), 'WEBTOK@', TRUE);

            if OSI_PARTICIPANT.IS_MARRIED(vPERVERSID) = 'YES' then

              v_ok := web_template_pkg.Replace_Tag(v_template, 'MS', 'M', 'WEBTOK@', TRUE);

            else  

              v_ok := web_template_pkg.Replace_Tag(v_template, 'MS', 'S', 'WEBTOK@', TRUE);

            end if;
            v_ok := web_template_pkg.Replace_Tag(v_template, 'RACE', P.RACE_DESC, 'WEBTOK@', TRUE);
  
           if P.SEX_CODE='M' then

             v_ok := web_template_pkg.Replace_Tag(v_template, 'SEX', '\f10\fs26 \' || v_Box_withX || '\f1\fs18   MALE    \f10\fs26 \' || v_Box_Empty || '\f1\fs18   FEMALE', 'WEBTOK@', TRUE);
    
           elsif p.SEX_CODE='F' then
       
                v_ok := web_template_pkg.Replace_Tag(v_template, 'SEX', '\f10\fs26 \' || v_Box_Empty || '\f1\fs18   MALE    \f10\fs26 \' || v_Box_withX || '\f1\fs18   FEMALE', 'WEBTOK@', TRUE);
    
           else

             v_ok := web_template_pkg.Replace_Tag(v_template, 'SEX', '\f10\fs26 \' || v_Box_Empty || '\f1\fs18   MALE    \f10\fs26 \' || v_Box_Empty || '\f1\fs18   FEMALE', 'WEBTOK@', TRUE);
  
           end if;
  
           v_ok := web_template_pkg.Replace_Tag(v_template, 'H', P.HAIR_COLOR_DESC, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'E', P.EYE_COLOR_DESC, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'HT', P.HEIGHT, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'WT', P.WEIGHT, 'WEBTOK@', TRUE);
    
           BEGIN
                SELECT NUM_VALUE,ISSUE_STATE_CODE INTO vSSN,vNUMSource FROM V_OSI_PARTIC_NUMBER WHERE PARTICIPANT_VERSION=vPERVERSID AND NUM_TYPE_CODE='DL';

           EXCEPTION WHEN OTHERS THEN

                    vSSN := '';
                    vNUMSource := '';
     
           END;
           
           v_ok := web_template_pkg.Replace_Tag(v_template, 'DLN', vSSN, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'DLS', vNUMSource, 'WEBTOK@', TRUE);

  
           BEGIN
                SELECT NUM_VALUE INTO vSSN FROM V_OSI_PARTIC_NUMBER WHERE PARTICIPANT_VERSION=vPERVERSID AND NUM_TYPE_CODE='ARN';

           EXCEPTION WHEN OTHERS THEN

                    vSSN := '';
     
           END;
           
           v_ok := web_template_pkg.Replace_Tag(v_template, 'AR', vSSN, 'WEBTOK@', TRUE);

           FOR M IN (SELECT * FROM V_OSI_PARTIC_MARK WHERE PERSON_VERSION=vPERVERSID)
           LOOP
               vMarks := vMarks || M.TYPE_DESC || ', ' || M.LOC_DESC || ', ' || M.DESCRIPTION || '; ';
   
           END LOOP;
           v_ok := web_template_pkg.Replace_Tag(v_template, 'SCARS', vMarks, 'WEBTOK@', TRUE);
  
           v_ok := web_template_pkg.Replace_Tag(v_template, 'BLOODTYPE', P.BLOOD_TYPE_DESC, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'EDU', P.EDUCATION_LEVEL, 'WEBTOK@', TRUE);

           v_ok := web_template_pkg.Replace_Tag(v_template, 'DEGREE', vDataUnknown, 'WEBTOK@', TRUE);
        
           IF P.SA_RESERVIST = 'Y' THEN
          
             v_ok := web_template_pkg.Replace_Tag(v_template, 'RESERVE', 'Yes', 'WEBTOK@', TRUE);
  
           END IF;

           IF P.SA_RESERVIST = 'N' THEN

             v_ok := web_template_pkg.Replace_Tag(v_template, 'RESERVE', 'No', 'WEBTOK@', TRUE);
  
           END IF;

           IF P.SA_RESERVIST = 'U' THEN

             v_ok := web_template_pkg.Replace_Tag(v_template, 'RESERVE', 'Unknown', 'WEBTOK@', TRUE);
  
           END IF;
    
           BEGIN
                SELECT DESCRIPTION INTO vClearance FROM T_OSI_REFERENCE WHERE CODE=P.CLEARANCE_CODE AND USAGE='INDIV_CLEARANCE';

           EXCEPTION WHEN OTHERS THEN

                    vClearance := '';
     
           END;
           v_ok := web_template_pkg.Replace_Tag(v_template, 'CLEARANCE', vClearance, 'WEBTOK@', TRUE);

           v_ok := web_template_pkg.Replace_Tag(v_template, 'LOF', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'IOF', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'DISCIPLINE', vDataUnknown, 'WEBTOK@', TRUE);
  
           v_ok := web_template_pkg.Replace_Tag(v_template, 'AM', '\f10\fs26 \' || v_Box_Empty || '\f1\fs18', 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'OFS', '\f10\fs26 \' || v_Box_Empty || '\f1\fs18', 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'MLO', '\f10\fs26 \' || v_Box_Empty || '\f1\fs18', 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'MMCM', '\f10\fs26 \' || v_Box_Empty || '\f1\fs18', 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'PRP', '\f10\fs26 \' || v_Box_Empty || '\f1\fs18', 'WEBTOK@', TRUE);

           v_ok := web_template_pkg.Replace_Tag(v_template, 'ADATE', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'ATYPE', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'AORGCODE', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'ARMED', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'GUN', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'OFFENSE', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'STAT', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'OFFENSE_IDENT', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'INVOLVE', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'ARREST_INVOLVE', vDataUnknown, 'WEBTOK@', TRUE);

           v_ok := web_template_pkg.Replace_Tag(v_template, 'OTHER_AGENCY', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'OTHER_AGENCY_ORI', vDataUnknown, 'WEBTOK@', TRUE);
           v_ok := web_template_pkg.Replace_Tag(v_template, 'REMARKS', vDataUnknown, 'WEBTOK@', TRUE);
  
       END LOOP;
 
    end if;
    
    core_logger.LOG_IT(c_pipe, '<<<Form686-' || pSID);

    RETURN v_template;

    EXCEPTION
      WHEN OTHERS THEN
          core_logger.LOG_IT(c_pipe, sqlerrm);
          core_logger.LOG_IT(c_pipe, '<<<Form686-' || pSID);
          RETURN v_template;
    END Form686;

end osi_report;
/