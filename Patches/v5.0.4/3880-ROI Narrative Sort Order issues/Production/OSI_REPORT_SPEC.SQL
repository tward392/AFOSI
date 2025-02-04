set define off;

CREATE OR REPLACE package body osi_report_spec as
/******************************************************************************
   Name:     Osi_Report_Spec
   Purpose:  Provides Functionality For Report Spec Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     3-Jun-2010 J.Faris         Created Package
    14-Jun-2010 J.Faris         Added show_tab function.
    13-Jul-2010 J.Faris         Removed initialization of inherited activities for Source Files from 
                                initialize_activities (based on I2MS testing).
     9-Sep-2010 J.Faris         CHG0003310 - added reset_note_selections
    10-Oct-2010 J.Faris         Added custom deliver_blob (and cleanup_temp_clob support procedure)
                                
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_REPORT_SPEC';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function create_instance(
        p_obj_type              in   varchar2,
        p_obj                   in   varchar2,
        p_report_type           in   varchar2,
        p_title                 in   varchar2 := null,
        p_start_date            in   date := null,
        p_end_date              in   date := null,
        p_classification        in   varchar2 := null,
        p_ig_code               in   varchar2 := null,
        p_status                in   varchar2 := null,
        p_purpose               in   varchar2 := null)
        return varchar2 is
        v_sid   t_core_obj.sid%type;
    begin
        insert into t_core_obj
                    (obj_type)
             values (p_obj_type)
          returning SID
               into v_sid;

        insert into t_osi_report_spec
                    (sid,
                     obj,
                     report_type,
                     title,
                     start_date,
                     end_date,
                     classification,
                     ig_code,
                     status,
                     purpose)
             values (v_sid,
                     p_obj,
                     p_report_type,
                     p_title,
                     p_start_date,
                     p_end_date,
                     p_classification,
                     p_ig_code,
                     p_status,
                     p_purpose);

        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    function get_spec_sid(p_obj         in varchar2, 
                          p_report_type in varchar2) return varchar2 is
    begin
        for a in(select sid
                   from t_osi_report_spec
                  where obj = p_obj
                    and report_type = p_report_type)
        loop
             return a.sid;
        end loop;

        return null;

    exception
        when others then
            log_error('get_spec_sid: ' || sqlerrm);
            raise;
    end get_spec_sid;

    procedure initialize_activities(p_spec       in varchar2 := null, 
                                    p_obj         in varchar2, 
                                    p_report_type in varchar2) is
    v_spec varchar2(20);
    v_seq number;

    begin

        if p_spec is null then
           v_spec := osi_report_spec.create_instance(core_obj.lookup_objtype('ALL.REPORT_SPEC'),
                                                          p_obj,
                                                          p_report_type);
        else
           v_spec := p_spec;
        end if;

        if core_obj.get_objtype(p_obj) = core_obj.lookup_objtype('FILE.SOURCE') then
             for a in(select sid 
                        from t_osi_activity 
                       where (source = p_obj) --ME filter
                          /* or (sid in(select activity_sid
                                       from v_osi_assoc_fle_act
                                      where file_sid in(select that_file
                                                          from v_osi_assoc_fle_fle
                                                         where this_file = p_obj)))) --Inherited Activities filter (JF removed 7.13.10) */
                         and sid not in(select activity 
                                          from t_osi_report_activity 
                                         where spec = v_spec))
             loop
                  select max(seq) + 1
                    into v_seq
                    from t_osi_report_activity
                   where spec = v_spec;
                 
                 begin
                    insert into t_osi_report_activity(spec, activity, seq) values(v_spec, a.sid, nvl(v_seq,1));
                    commit;
                 exception
                     when OTHERS then
                          log_error('initialize_activities: ' || sqlerrm || ', using activity sid: ' || a.sid);
                 end;
             end loop;

        else
             for a in(select activity_sid 
                        from t_osi_assoc_fle_act
                       where (file_sid = p_obj --ME filter
                          or (activity_sid in(select activity_sid
                                                from v_osi_assoc_fle_act
                                               where file_sid in(select that_file
                                                                   from v_osi_assoc_fle_fle
                                                                  where this_file = p_obj)))) --Inherited Activities filter
                         and activity_sid not in(select activity
                                                   from t_osi_report_activity
                                                  where spec = v_spec))
             loop
                  select max(seq) + 1
                    into v_seq
                    from t_osi_report_activity
                   where spec = v_spec;

                 begin
                    insert into t_osi_report_activity(spec, activity, seq) values(v_spec, a.activity_sid, nvl(v_seq,1));
                    commit;
                 exception
                     when OTHERS then
                          log_error('initialize_activities: ' || sqlerrm || ', using activity_sid: ' || a.activity_sid);
                 end;
             end loop;

        end if;

    exception
        when others then
            log_error('initialize_activities: ' || sqlerrm);
            raise;
    end;

    procedure reorder_activities(p_spec     in varchar2, 
                                 p_activity in varchar2, 
                                 p_cur_seq  in number, 
                                 p_targ_seq in number) is

    begin
           
           update t_osi_report_activity set seq = p_targ_seq where spec = p_spec and activity = p_activity;
           commit;

           if p_targ_seq > p_cur_seq then --moving LOWER in the chain
             for a in(select * 
                        from t_osi_report_activity 
                       where spec = p_spec
                         and activity <> p_activity
                         and seq > p_cur_seq
                         and seq <= p_targ_seq
                       order by seq)
             loop
                 update t_osi_report_activity set seq = a.seq - 1 where sid = a.sid; 
             end loop;

             commit;
           elsif p_targ_seq < p_cur_seq then --moving HIGHER in the chain
             for a in(select * 
                        from t_osi_report_activity 
                       where spec = p_spec
                         and activity <> p_activity
                         and seq >= p_targ_seq
                         and seq < p_cur_seq
                       order by seq)
             loop
                 update t_osi_report_activity set seq = a.seq + 1 where sid = a.sid;
             end loop;

             commit;
           end if; 
             
    exception
        when others then
            log_error('reorder_activities: ' || sqlerrm);
            raise;
    end;

   procedure initialize_notes(p_spec       in varchar2 := null, 
                              p_obj         in varchar2, 
                              p_report_type in varchar2) is
    v_spec varchar2(20);
    v_seq number;

    begin
          if p_spec is null then
                v_spec := osi_report_spec.create_instance(core_obj.lookup_objtype('ALL.REPORT_SPEC'),
                                                          p_obj,
                                                          p_report_type);
          else
             v_spec := p_spec;
          end if;

          /* insert a row for every possible associated or inherited note */
          for a in(select sid 
                     from t_osi_note
                    where(OBJ = p_obj
                      or (OBJ in (select THAT_FILE from v_osi_assoc_fle_fle where this_file = p_obj))      -- Associated Files filter
                      or (OBJ in (select ACTIVITY_SID from v_osi_assoc_fle_ACT where file_sid = p_obj))    -- Associated Activities filter
                      or (OBJ in (select ACTIVITY_SID from v_osi_assoc_fle_ACT where file_sid in 
                                    (select THAT_FILE from v_osi_assoc_fle_fle where this_file =  p_obj)))) -- Inherited Activities filter
                      and sid not in(select note_sid 
                                       from v_osi_rpt_avail_note
                                      where spec = v_spec))
          loop
              select max(seq) + 1
                into v_seq
                from t_osi_report_note
               where spec = v_spec;
              
              begin
                  insert into t_osi_report_note(spec, note, seq) values(v_spec, a.sid, nvl(v_seq,1));
                  commit;
              exception
                  when OTHERS then
                         log_error('initialize_notes: ' || sqlerrm || ', using note sid: ' || a.sid); 
              end;
          end loop;
 
    exception
        when others then
            log_error('initialize_notes: ' || sqlerrm);
            raise;
    end;

    procedure reorder_notes(p_spec     in varchar2, 
                            p_note in varchar2, 
                            p_cur_seq  in number, 
                            p_targ_seq in number) is

    begin
           
           update t_osi_report_note set seq = p_targ_seq where spec = p_spec and note = p_note;
           commit;

           if p_targ_seq > p_cur_seq then --moving LOWER in the chain
             for a in(select * 
                        from t_osi_report_note 
                       where spec = p_spec
                         and note <> p_note
                         and seq > p_cur_seq
                         and seq <= p_targ_seq
                       order by seq)
             loop
                 update t_osi_report_note set seq = a.seq - 1 where sid = a.sid; 
             end loop;

             commit;
           elsif p_targ_seq < p_cur_seq then --moving HIGHER in the chain
             for a in(select * 
                        from t_osi_report_note 
                       where spec = p_spec
                         and note <> p_note
                         and seq >= p_targ_seq
                         and seq < p_cur_seq
                       order by seq)
             loop
                 update t_osi_report_note set seq = a.seq + 1 where sid = a.sid;
             end loop;

             commit;
           end if; 
             
    exception
        when others then
            log_error('reorder_notes: ' || sqlerrm);
            raise;
    end;

   /* This procedure will add/delete the attachments for activities selected/de-selected on the 'Narratives' tab */
   procedure initialize_attachments(p_spec        in varchar2, 
                                    p_activity    in varchar2,
                                    p_selected    in varchar2) is
    v_seq number;

    begin
         if p_selected = 'Y' then
             for a in(select sid
                        from v_osi_rpt_include_child_attach
                       where obj = p_activity
                         and sid not in(select attachment
                                          from v_osi_rpt_attachment
                                         where spec_sid = p_spec))
             loop
                select max(seq) + 1
                    into v_seq
                    from t_osi_report_attachment
                   where spec = p_spec;

                begin
                   insert into t_osi_report_attachment(spec, attachment, seq) values(p_spec, a.sid, nvl(v_seq,1));
                exception
                   when OTHERS then
                          log_error('initialize_attachments: ' || sqlerrm || ', using attachment sid: ' || a.sid); 
                end; 

             end loop;
         elsif p_selected = 'N' then
             delete from t_osi_report_attachment 
                       where attachment in(select sid 
                                             from v_osi_rpt_include_child_attach
                                            where obj = p_activity)
                         and spec = p_spec;
         end if;
    exception
        when others then
            log_error('initialize_attachments: ' || sqlerrm);
            raise;
    end;

   procedure initialize_caveats(p_spec       in varchar2 := null, 
                               p_obj         in varchar2, 
                               p_report_type in varchar2) is
    v_spec varchar2(20);

    begin
          if p_spec is null then
                v_spec := osi_report_spec.create_instance(core_obj.lookup_objtype('ALL.REPORT_SPEC'),
                                                          p_obj,
                                                          p_report_type);
          else
             v_spec := p_spec;
          end if;
 
          for a in(select sid 
                     from t_osi_report_caveat_type
                    where sid not in(select caveat_sid
                                       from v_osi_rpt_avail_caveat
                                      where spec = v_spec))
          loop
              insert into t_osi_report_caveat(spec, caveat) values(v_spec, a.sid);

          end loop;

          commit;
          

    exception
        when others then
            log_error('initialize_caveats: ' || sqlerrm);
            raise;
    end;

    -- This function checks the osi_report_type flags to hide/show report spec tabs
    function show_tab(p_report_type in varchar2, p_tab in varchar2)
                return varchar2 is

    v_result        varchar2(1);
    v_distributions varchar2(1);
    v_narratives    varchar2(1);
    v_notes         varchar2(1);
    v_attachments   varchar2(1);
    v_caveats       varchar2(1);
    v_tab_desc      varchar2(50);

    begin
         begin
             select pick_distribution, pick_narratives, pick_notes, pick_attachment, pick_caveats
               into v_distributions, v_narratives, v_notes, v_attachments, v_caveats
               from t_osi_report_type
              where sid = p_report_type;
         exception
              when NO_DATA_FOUND then
                 log_error('show_tab: Unable to locate report type: ' || nvl(p_report_type, 'Null') || sqlerrm);
                 return 'Y';
         end;

         begin
             select tab_label
               into v_tab_desc
               from t_osi_tab
              where sid = p_tab;
         exception
              when NO_DATA_FOUND then
                 log_error('show_tab: Unable to locate tab: ' || nvl(p_tab, 'Null') || sqlerrm);
                 return 'Y';
         end;

         case 
             when v_tab_desc = 'Distribution' then
                  return v_distributions;
             when v_tab_desc = 'Narratives(Activities)' then
                  return v_narratives;
             when v_tab_desc = 'Notes' then
                  return v_notes;
             when v_tab_desc = 'Attachments' then
                  return v_attachments;  -- attachments are driven by the activity narrative tab
             when v_tab_desc = 'Caveats' then
                  return v_caveats;
             else
                  return 'Y';
         end case;

    exception
         when others then
                log_error('show_tab: ' || sqlerrm);
                return 'Y';
    end;

    procedure activity_sort(p_spec in varchar2, p_mode in varchar2) is

    v_seq     Number := 0;
    v_source  Varchar2(1);

    begin

       --Is this a spec for a Source File?
       begin
        select 'Y'
          into v_source
          from t_osi_report_spec
         where sid = p_spec
           and core_obj.get_objtype(obj) = core_obj.lookup_objtype('FILE.SOURCE');
       exception
          when NO_DATA_FOUND then
               v_source := 'N';
       end;
       
       if v_source = 'N' then   
           case 
             when upper(p_mode) = 'DEFAULT' then
                 for a in
                    ( select sid
                       from v_osi_rpt_avail_activity
                      where spec = p_spec 
                      order by SELECTED desc,ROI_COMBINED_ORDER asc, ROI_GROUP, SEQ asc)
                 loop
                     v_seq := v_seq + 1;
                     update t_osi_report_activity set seq = v_seq where sid = a.sid;
                 end loop;
                 commit;
             when upper(p_mode) = 'ACT_DATE' then
                 for a in
                    ( select sid
                       from v_osi_rpt_avail_activity
                      where spec = p_spec
                      order by activity_date)
                 loop
                     v_seq := v_seq + 1;
                     update t_osi_report_activity set seq = v_seq where sid = a.sid;
                 end loop;
    		     commit;
             else
                 null;
           end case;
       else
           case 
             when upper(p_mode) = 'DEFAULT' then
                 for a in
                    ( select sid
                       from v_osi_rpt_avail_act_src_meet
                      where spec = p_spec 
                      order by SELECTED desc,ROI_COMBINED_ORDER asc, ROI_GROUP, SEQ asc)
                 loop
                     v_seq := v_seq + 1;
                     update t_osi_report_activity set seq = v_seq where sid = a.sid;
                 end loop;
    		     commit;
             when upper(p_mode) = 'ACT_DATE' then
                 for a in
                    ( select sid
                       from v_osi_rpt_avail_act_src_meet
                      where spec = p_spec 
                      order by activity_date)
                 loop
                     v_seq := v_seq + 1;
                     update t_osi_report_activity set seq = v_seq where sid = a.sid;
                 end loop;
    		     commit;
             else
                 null;
           end case;
       end if;

    exception
            when others then
                log_error('activity_sort: ' || sqlerrm);
                raise;
    end;

    procedure note_sort(p_spec in varchar2, p_mode in varchar2) is
    v_seq     Number := 0;

    begin     
       case 
         when upper(p_mode) = 'DEFAULT' then
             for a in
                ( select sid
                   from v_osi_rpt_avail_note
                  where spec = p_spec 
                  order by TIMESTAMP, SEQ asc)
             loop
                 v_seq := v_seq + 1;
                 update t_osi_report_note set seq = v_seq where sid = a.sid;
             end loop;
             commit;
         else
             null;
       end case;
    exception
            when others then
                log_error('note_sort: ' || sqlerrm);
                raise;
    end;

    -- The following procedure resets the default note selection, selecting IDP notes and de-selecting all others
    procedure reset_note_selections(p_spec in varchar2, p_obj in varchar2) is
    
    begin
         for a in
            ( select sid, category
                from v_osi_rpt_avail_note
               where spec = p_spec
                 and (obj = p_obj
                      or (obj in (select ACTIVITY_SID from v_osi_assoc_fle_ACT where file_sid = p_obj)))    -- Associated Activities filter
            ) -- select ignores associated FILE notes and inherited FILE notes per i2ms code
         loop
             if a.category = 'IDP Note' then
                update t_osi_report_note set selected = 'Y' where sid = a.sid;
             else
                update t_osi_report_note set selected = 'N' where sid = a.sid;
             end if;
         end loop;
         commit;
    exception
            when others then
                log_error('reset_note_selections: ' || sqlerrm);
                raise;
    end;

    procedure DELIVER_BLOB(
        P_CLOB               in out nocopy   Clob,
        P_MIME_TYPE          in              Varchar2 := 'application/octet',
        P_MIME_DISPOSITION   in              Varchar2 := 'ATTACHMENT',
        P_FILENAME           in              Varchar2 := null,
        P_NO_CACHE           in              boolean := false,
        P_LAST_MOD_DATE      in              Date := null) is
        V_BLOB          Blob;
        V_DEST_OFFSET   Number          := 1;
        V_SRC_OFFSET    Number          := 1;
        V_LANG          Number          := DBMS_LOB.DEFAULT_LANG_CTX;
        V_WARNING       Varchar2(32000) := null;
        V_DISP_LINE     Varchar2(300);
    begin
        if V_BLOB is not null then
            DBMS_LOB.FREETEMPORARY(V_BLOB);
            V_BLOB := null;
        end if;

        DBMS_LOB.CREATETEMPORARY(V_BLOB, false, DBMS_LOB.CALL);
        DBMS_LOB.CONVERTTOBLOB(V_BLOB,
                               P_CLOB,
                               DBMS_LOB.LOBMAXSIZE,
                               V_DEST_OFFSET,
                               V_SRC_OFFSET,
                               DBMS_LOB.DEFAULT_CSID,
                               V_LANG,
                               V_WARNING);
        CLEANUP_TEMP_CLOB(P_CLOB);
        OWA_UTIL.MIME_HEADER(nvl(P_MIME_TYPE, 'application/octet'), false);
        HTP.p('Content-length: ' || DBMS_LOB.GETLENGTH(V_BLOB));

        if P_NO_CACHE then
            HTP.p('Pragma: no-cache');
            HTP.p('Cache-Control: no-cache, no-store, must-revalidate');
        end if;

        /* Addition to CORE version....expires the download after 2 minutes */
        HTP.p('Expires: ' || to_char(SYSDATE+2/1440, 'FMDy, DD Month YYYY HH24:MI:SS') || ' GMT');
        /* End Addition */

        if P_MIME_DISPOSITION is not null then
            V_DISP_LINE := 'Content-Disposition: ' || P_MIME_DISPOSITION;

            if P_FILENAME is not null then
                V_DISP_LINE := V_DISP_LINE || '; filename="' || P_FILENAME || '"';
            end if;
        end if;

        if V_DISP_LINE is not null then
            HTP.p(V_DISP_LINE);
        end if;

        if P_LAST_MOD_DATE is not null then
            HTP.p('Last-Modified: '
                  || to_char(P_LAST_MOD_DATE - to_number(to_char(systimestamp, 'TZH')) / 24,
                             'Dy, dd Mon yyyy hh24:mi:ss')
                  || ' GMT');
        end if;

        OWA_UTIL.HTTP_HEADER_CLOSE;
        --dbms_lob.close(v_blob);
        WPG_DOCLOAD.DOWNLOAD_FILE(V_BLOB);

        if V_BLOB is not null then
            DBMS_LOB.FREETEMPORARY(V_BLOB);
            V_BLOB := null;
        end if;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Deliver_Blob Error: ' || sqlerrm);
            raise;
    end DELIVER_BLOB;

    procedure CLEANUP_TEMP_CLOB(P_CLOB in out nocopy Clob) is
    begin
        if DBMS_LOB.ISTEMPORARY(P_CLOB) = 0 then
            RAISE_APPLICATION_ERROR(-20200, 'Invalid Clob specified');
        end if;

        if DBMS_LOB.ISOPEN(P_CLOB) <> 0 then
            DBMS_LOB.CLOSE(P_CLOB);
        end if;

        if P_CLOB is not null then
            DBMS_LOB.FREETEMPORARY(P_CLOB);
            P_CLOB := null;
        end if;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Cleanup_Temp_Clob Error: ' || sqlerrm);
    end CLEANUP_TEMP_CLOB;
    

end osi_report_spec;
/