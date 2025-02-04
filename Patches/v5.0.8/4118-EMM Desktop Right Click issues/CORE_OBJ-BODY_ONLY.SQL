set define off;

CREATE OR REPLACE PACKAGE BODY "CORE_OBJ" as
/*
    Core_Obj: Utility routines to process/retrieve info about abstract Objects.

    01-Nov-2005 RWH     Original version.
    07-Nov-2005 RWH     Added Get_Desktop_Page_Num.
    10-Nov-2005 RWH     Removed Get_Desktop_Page_Num. This function will be implemented
                        in the Core_Desktop package.
    01-Dec-2005 RWH     Added Bump.
    03-Jan-2006 RWH     Added Get_Tagline.
    04-Jan-2006 RWH     Added Index1 procedure (for DOC1 full text indexing).
    10-Jan-2006 RWH     Added Lookup_ObjType function.
    08-Feb-2006 RWH     Added Get_Status function.
    03-Oct-2006 RWH     Added Dump_Index1 function. This is used mostly for debugging index
                        routines.
    30-Oct-2006 RWH     Added Get_Summary. This will work similarly to Get_Tagline, but will
                        return a summary of the entire object. Typically, the output will be
                        formatted HTML.
    13-Dec-2006 JAF/RWH Added Get_Context_Description. Works similarly to Get_Tagline, returning
                        a user-friendly context description based on the specified Object and
                        Context.
    18-Jan-2007 RWH     Added Index and Dump_Index routines for indexes 2 thru 5.
    22-Apr-2011 TJW     CR#3829 - Added get_inherit_privs_flag.  
    18-Aug-2011 TJW     CR#3926 - New and Updated Notes attaching to Activity instead of File.
                                  Added get_parentinfo.  
    05-Oct-2012 TJW     CR#4118 - Right Click issues on EMM Desktop.
                                  Changed get_objtype and get_tagline.
*/
    c_pipe   varchar2(100) := nvl(core_util.get_config('CORE.PIPE_PREFIX'), 'I2G.') || 'CORE_OBJ';

-- Private support routines
    procedure build_index(
        p_ndx        in              number,
        p_rowid      in              rowid,
        p_clob       in out nocopy   clob,
        p_doc_head   in              varchar2 := '<DOC>',
        p_doc_tail   in              varchar2 := '</DOC>') is
        v_sid      varchar2(20);
        v_ot_pkg   t_core_obj_type.method_pkg%type;
        v_clob     clob;
    begin
        select o.sid, ot.method_pkg
          into v_sid, v_ot_pkg
          from t_core_obj o, t_core_obj_type ot
         where o.rowid = p_rowid and ot.sid = o.obj_type;

        core_util.append_info_to_clob(p_clob, p_doc_head, null);

        if v_ot_pkg is null then
            core_logger.log_it(c_pipe, 'Build_Index(' || p_ndx || '): Method Pkg not defined');
        else
            begin
                core_util.append_info_to_clob(v_clob, ' ', null);

                execute immediate 'begin ' || v_ot_pkg || '.INDEX' || p_ndx
                                  || '(:OBJ, :CLOB); end;'
                            using in v_sid, in out v_clob;

                -- If we get here, document was synthesized, so insert real content.
                dbms_lob.append(p_clob, v_clob);
            exception
                when others then
                    if sqlerrm like '%PLS-00302%INDEX%' then
                        core_logger.log_it(c_pipe,
                                           v_ot_pkg || '.Index' || p_ndx || ' procedure not defined');
                    else
                        core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                    end if;
            end;
        end if;

        core_util.cleanup_temp_clob(v_clob);
        core_util.append_info_to_clob(p_clob, p_doc_tail, null);
    exception
        when no_data_found then
            core_logger.log_it(c_pipe, 'Build_Index(' || p_ndx || '): Invalid ROWID specified');
    end build_index;

-- Public routines
    procedure bump(p_obj in varchar2) is
        v_docn_val   varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
    begin
        update t_core_obj
           set doc1 = v_docn_val,
               doc2 = v_docn_val,
               doc3 = v_docn_val,
               doc4 = v_docn_val,
               doc5 = v_docn_val
         where sid = p_obj;
    end bump;

    function dump_index1(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index1(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index1;

    function dump_index2(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index2(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index2;

    function dump_index3(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index3(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index3;

    function dump_index4(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index4(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index4;

    function dump_index5(p_sid in varchar2)
        return clob is
        v_rowid   varchar2(30) := null;
        v_clob    clob         := null;
    begin
        select rowid
          into v_rowid
          from t_core_obj
         where sid = p_sid;

        index5(v_rowid, v_clob);
        return v_clob;
    exception
        when no_data_found then
            return null;
    end dump_index5;

    function get_acl(p_obj in varchar2)
        return varchar2 is
        v_acl   varchar2(20);
    begin
        select acl
          into v_acl
          from t_core_obj
         where sid = p_obj;

        return v_acl;
    exception
        when no_data_found then
            return null;
    end get_acl;

    function get_context_description(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_rtn      varchar2(200)             := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        v_ot_rec.sid := core_obj.get_objtype(p_obj);

        if v_ot_rec.sid is null then
            core_logger.log_it(c_pipe,
                               'Get_Context_Description: Error locating Object Type for '
                               || nvl(v_ot_rec.sid, 'NULL'));
            return 'Invalid Object passed to Get_Context_Description';
        end if;

        select *
          into v_ot_rec
          from t_core_obj_type
         where sid = v_ot_rec.sid;

        if v_ot_rec.method_pkg is null then
            core_logger.log_it
                           (c_pipe,
                            'Get_Context_Description: Method package not defined for Obj_Type: '
                            || v_ot_rec.code);
            return 'Method package not defined for ' || v_ot_rec.description;
        end if;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                              || '.Get_Context_Description(:CONTEXT); end;'
                        using out v_rtn, in p_obj_context;

            return v_rtn;
        exception
            when others then
                core_logger.log_it(c_pipe,
                                   'Get_Context_Description: Error during execute immediate: '
                                   || sqlerrm);
                return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Context_Description';
        end;
    exception
        when others then
            core_logger.log_it(c_pipe,
                               'Get_Context_Description: Error encountered using Object '
                               || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in Get_Context_Description using Object: ' || nvl(p_obj, 'NULL');
    end get_context_description;

    function get_objtype(p_obj in varchar2)
        return varchar2 is
        v_ot   varchar2(20);
    begin
         IF SUBSTR(p_obj,1,3)='EMM' THEN

           select sid into v_ot from t_core_obj_type where code='EMM';

         ELSE

           select obj_type into v_ot from t_core_obj where sid = p_obj;

         END IF;
         
         return v_ot;
    exception
        when no_data_found then
            return null;
    end get_objtype;

    function get_status(p_obj in varchar2)
        return varchar2 is
        v_rtn      varchar2(1000)            := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        v_rtn := 'Invalid parameter passed to Get_Status';
        v_ot_rec.sid := get_objtype(p_obj);

        if v_ot_rec.sid is null then
            raise no_data_found;
        end if;

        v_rtn := 'Could not locate Obj_Type for specified Object';

        select *
          into v_ot_rec
          from t_core_obj_type
         where sid = v_ot_rec.sid;

        if v_ot_rec.method_pkg is null then
            return 'Method package not defined for Obj_Type: ' || v_ot_rec.code;
        end if;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg || '.GET_STATUS(:OBJ); end;'
                        using out v_rtn, in p_obj;

            return v_rtn;
        exception
            when others then
                core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Status';
        end;
    exception
        when no_data_found then
            return v_rtn;
        when others then
            return 'Untrapped error in Get_Status';
    end get_status;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
        v_rtn      clob;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        v_rtn := 'Invalid parameter passed to Get_Summary';
        v_ot_rec.sid := get_objtype(p_obj);

        if v_ot_rec.sid is null then
            raise no_data_found;
        end if;

        v_rtn := 'Could not locate Obj_Type for specified Object';

        select *
          into v_ot_rec
          from t_core_obj_type
         where sid = v_ot_rec.sid;

        if v_ot_rec.method_pkg is null then
            return 'Method package not defined for Obj_Type: ' || v_ot_rec.code;
        end if;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                              || '.GET_SUMMARY(:OBJ, :VAR); end;'
                        using out v_rtn, in p_obj, in p_variant;

            return v_rtn;
        exception
            when others then
                core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Summary';
        end;
    exception
        when no_data_found then
            return v_rtn;
        when others then
            return 'Untrapped error in Get_Summary';
    end get_summary;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_rtn      varchar2(1000)            := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
         IF SUBSTR(p_obj,1,3)='EMM' THEN
         
           v_rtn := 'Evidence Management Module for: ' || osi_unit.get_tagline(LTRIM(p_obj,'EMM'));
           return v_rtn;
           
         ELSE

           v_rtn := 'Invalid parameter passed to Get_Tagline';
           v_ot_rec.sid := get_objtype(p_obj);

           if v_ot_rec.sid is null then
             select 'ok'
                into v_rtn
                 from t_osi_participant_version
                where sid = p_obj;

               return osi_participant.get_tagline(p_obj);
           else
               v_rtn := 'Could not locate Obj_Type for specified Object';

               select *
                 into v_ot_rec
                 from t_core_obj_type
                where sid = v_ot_rec.sid;

               if v_ot_rec.method_pkg is null then
                 return 'Method package not defined for Obj_Type: ' || v_ot_rec.code;
               end if;

               begin
                   execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                                     || '.GET_TAGLINE(:OBJ); end;'
                               using out v_rtn, in p_obj;

                   return v_rtn;
            exception
                when others then
                    core_logger.log_it(c_pipe, 'Error during execute immediate: ' || sqlerrm);
                    return 'Error invoking ' || v_ot_rec.method_pkg || '.Get_Tagline';
            end;
           end if;
           
         END IF;
         
    exception
        when no_data_found then
            return v_rtn;
        when others then
            return 'Untrapped error in Get_Tagline';
    end get_tagline;

    procedure index1(r in rowid, c in out nocopy clob) is
    begin
        build_index(1, r, c, '<DOC><NONSPECIFIC>SPECIALTOKENTHATSINALLOBJECTS</NONSPECIFIC>');
    end index1;

    procedure index2(r in rowid, c in out nocopy clob) is
    begin
        build_index(2, r, c);
    end index2;

    procedure index3(r in rowid, c in out nocopy clob) is
    begin
        build_index(3, r, c);
    end index3;

    procedure index4(r in rowid, c in out nocopy clob) is
    begin
        build_index(4, r, c);
    end index4;

    procedure index5(r in rowid, c in out nocopy clob) is
    begin
        build_index(5, r, c);
    end index5;

    function lookup_objtype(p_obj_type_code in varchar2)
        return varchar2 is
        v_ot   varchar2(20);
    begin
        select sid
          into v_ot
          from t_core_obj_type
         where code = p_obj_type_code;

        return v_ot;
    exception
        when no_data_found then
            return null;
        when others then
            core_logger.log_it(c_pipe, 'Lookup_ObjType: ' || sqlerrm);
            return null;
    end lookup_objtype;

    function get_inherit_privs_flag(p_obj_type_sid in varchar2) return varchar2 is

         v_return   varchar2(1) := 'N';

    begin
         select decode(inherit_privs_from_parent,'N','Y','N') into v_return from t_core_obj_type where sid=p_obj_type_sid;
         return v_return;
              
    exception when others then

             return v_return;
                  
    end get_inherit_privs_flag;

function get_parentinfo(p_obj in varchar2) return varchar2 is
     
     v_title  varchar2(1000)            := null;
     v_id     varchar2(1000)            := null;
     v_rtn    varchar2(1000)            := null;
     v_ot_rec t_core_obj_type%rowtype;

begin
     for o in (select t.code from t_core_obj o, t_core_obj_type t where o.OBJ_TYPE=t.sid and o.sid=p_obj)
     loop
         case
             
             when o.code like 'ACT%' then
                 
                 v_id := osi_activity.get_id(p_obj);
                 v_title := osi_activity.get_title(p_obj);
                 
                 if substr(v_title, 1, length('Activity: ' || v_id)) = 'Activity: ' || v_id then
                   
                   v_rtn := v_title;
                 
                 else 
                   
                   v_rtn := 'Activity: ' || v_id || ' - ' || v_title;
                   
                 end if;
                 
                 return v_rtn;

             when o.code like 'FILE%' then
                 
                 v_id := osi_file.get_id(p_obj);
                 v_title := osi_file.get_title(p_obj);
                 
                 if substr(v_title, 1, length('File: ' || v_id)) = 'File: ' || v_id then
                   
                   v_rtn := v_title;

                 else 
                   
                   v_rtn := 'File: ' || v_id || ' - ' || v_title;

                 end if;

                 return v_rtn;
             
             else

               return get_tagline(p_obj);
             
         end case;
         
     end loop;
     
exception
    when others then
        return get_tagline(p_obj);
end get_parentinfo;
    
end core_obj;
/


