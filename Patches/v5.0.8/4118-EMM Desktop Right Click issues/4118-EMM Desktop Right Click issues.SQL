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



set define off;

CREATE OR REPLACE PACKAGE BODY Osi_Object AS
/******************************************************************************
   Name:     Osi_Object
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     17-Apr-2009 T.McGuffin      Created Package
     29-Apr-2009 T.McGuffin      Added Get_Next_Id Function.
     01-May-2009 Richard Dibble  Added Get_Status
     06-May-2009 T.McGuffin      Added Get_Objtype_Desc function.
     11-May-2009 T.Whitehead     Added Get_Address function.
     20-May-2009 R.Dibble        Modified Get_Status to utilize non-core tables
     21-May-2009 R. Dibble       Added Get_Obj_Package Procedure
     22-May-2009 T.McGuffin      Removed Get_Address.  Created Get_Address_Sid and Get_Participant_Sid
     27-May-2009 T.McGuffin      Added Create_Lead_Assignment procedure.
     01-Jun-2009 T.McGuffin      Added Get_Objtypes function.
     01-Jun-2009 T.McGuffin      Added Get_ID function.
     24-Aug-2009 T.McGuffin      Modified get_object_url to include optional parameters for item names and vals.
     13-Oct-2009 J.Faris         Added Delete_Object
     02-Nov-2009 T.Whitehead     Added get/set_special_interest.
     02-Nov-2009 Richard Dibble  Added get_objtype_code
     17-Dec-2009 T.Whitehead     Added get_default_title.
     18-Dec-2009 T.Whitehead     Added do_title_substitution.
     28-Dec-2009 T.Whitehead     Added get_status_code.
     12-Jan-2010 T.Whitehead     Added optional parameter p_text to get_open_link.
     13-Jan-2010 T.McGuffin      Added check_writability function.
     22-Feb-2010 T.McGuffin      Added is_assigned function.
     26-Feb-2010 T.McGuffin      Added get_lead_agent function.
     24-Mar-2010 T.McGuffin      Modified get_assigned_unit function to include cfunds advances.
     27-Apr-2010 J.Horne         Modified get/set_special_interest to include only special Interests
                                 that have been marked 'I.'
     10-May-2010 R.Dibble        Modified delete_object to always reject when the object type is UNIT
     25-May-2010 T.Leighty       Added addicon, append_assoc_activities, append_involved_participants,
                                 append_attachments, append_notes, append_related_files, get_template
                                 and doc_detail
     27-May-2010 T.Leighty       Modified append_involved_participants to use correct view table 
                                 combination in queries.
     08-Jun-2010 T.Leighty       Modified append_involved_participants to fix bug that prevented all
                                 file types to be included.
     15-Jul-2010 J.Faris         Implementing a previous update to error handling in is_assigned function.
     30-Nov-2010 J.Horne         Updated append_attachments; changed format for URL
     30-Nov-2010 Tim Ward        Changed get_next_id incase IDs are gotten in Rapid Succession.
     07-Dec-2010 Tim Ward        Added getStatusBar.
     09-Dec-2010 Richard Dibble  Modified get_object_url to forward user to a dummy page if they do not have access.
     13-Dec-2010 Richard Dibble  Modified get_object_url to supress logging
     18-Jan-2011 Tim Ward        Redid getStatusBar to not use the jixedBar.
     19-Jan-2011 Tim Ward        Added Last DEERS date to a PART.INDIV object's statusbar.
     19-Jan-2011 Tim Ward        Added core_util.get_config('OSI.IMAGE_PREFIX') to getStatusBar so we can get the correct
                                 #IMAGE_DIR# value for the Min/Max.gif buttons.
     16-Feb-2011 Tim Ward        Problem pulling correct DEERS_DATE.
     04-Mar-2011 Tim Ward        CR#3734 - set_special_interest is deleting 'I' and 'A' and it should only delete 'I'.
     18-Mar-2011 Tim Ward        CR#3731 - PERSONNEL should not be deleted.
                                  Also defaulted delete_object to return 'You are not authorized to perform the requested action.'
                                  instead of 'Y'.  Removed the checkForPriv from i2ms.js deleteObj function.
                                  Changed in delete_object.
     07-Oct-2011 Tim Ward        CR#3946 - Add ParentInfo Open Link to Grid and Selected Attachment Detials so the users can get to the
                                  parent quickly (if it is not the same as this file). 
                                  Changed OSI_OBJECT.GET_OPEN_LINK so it returns 32000 instead of 200 in the Link since the parentinfo 
                                  can be as long as the title + a few characters...
     25-Oct-2011 Tim Ward        Now looks up Object Classification, if not found, uses the OSI.DEFAULT_CLASS.
                                  Changed in getstatusbar.
     15-Nov-2011 Tim Ward        CR#3738 - Adding Active/All Flag.
                                  Added is_object_active.
     06-Dec-2011 Tim Ward        CR#3646 - Remove Disallowed/Repaid Expenses from Active Filter.
                                  Changed is_object_active.
     19-Dec-2011 Tim Ward        Added get_lead_agent_name to make desktop selects 8 seconds quicker
                                 by not having to call two functions.
     24-May-2012 Tim Ward        CR#4005 - Add Direct Links into Notes.
                                  Currently does Note only, but could be expanded to other Support Objects when needed.
                                  Changed get_object_url.
                                  Added go_to_tab.  (Moved from the Application Proccess, now that process calls this).
                                  Added get_support_obj_url.
     05-Oct-2012 Tim Ward        CR#4118 - Right Click issues on EMM Desktop.
                                  Changed get_id, get_object_url, and get_tagline_link.
                                  
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_OBJECT';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;
    
    FUNCTION get_default_title(p_obj_type_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT default_title
                    FROM T_OSI_OBJ_TYPE
                   WHERE SID = p_obj_type_sid)
        LOOP
            RETURN x.default_title;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_default_title: ' || SQLERRM);
    END get_default_title;
    
    PROCEDURE do_title_substitution(p_obj IN VARCHAR2) IS
        v_objcode   T_CORE_OBJ_TYPE.code%TYPE;
        v_updated   VARCHAR2(4000);
        v_sid       T_CORE_OBJ.SID%TYPE;
    BEGIN
        SELECT code
          INTO v_objcode
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        /*
         * Any object types that need special processing should have a case statement
         * that is above 'ACT%' added for them.
         */
        CASE
            WHEN v_objcode LIKE 'ACT.AAPP%' THEN
                BEGIN
                    SELECT file_sid
                      INTO v_sid
                      FROM T_OSI_ASSOC_FLE_ACT
                    WHERE activity_sid = p_obj;
                    
                    v_updated := Osi_Util.do_title_substitution(v_sid, Osi_Activity.get_title(p_obj));
                    v_updated := Osi_Util.do_title_substitution(p_obj, v_updated);
                    
                    UPDATE T_OSI_ACTIVITY
                       SET title = v_updated
                     WHERE SID = p_obj;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- This should never happen.
                        log_error('do_title_substitution: - Error in ACT.AAPP% case - ' || SQLERRM);
                 END;
                 
            WHEN v_objcode LIKE 'ACT%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_Activity.get_title(p_obj));

                UPDATE T_OSI_ACTIVITY
                   SET title = v_updated
                 WHERE SID = p_obj;

            WHEN v_objcode LIKE 'FILE%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_File.get_title(p_obj), 'T_OSI_FILE');

                UPDATE T_OSI_FILE
                   SET title = v_updated
                 WHERE SID = p_obj;
        END CASE;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('do_title_substitution: ' || SQLERRM);
    END do_title_substitution;

    FUNCTION get_participant_sid(p_obj IN VARCHAR2, p_usage IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_OSI_PARTICIPANT.SID%TYPE;
    BEGIN
        IF p_obj IS NOT NULL AND p_usage IS NOT NULL THEN
            SELECT i.participant_version
              INTO v_rtn
              FROM T_OSI_PARTIC_INVOLVEMENT i, T_OSI_PARTIC_ROLE_TYPE ir
             WHERE i.involvement_role = ir.SID AND i.obj = p_obj AND ir.USAGE = p_usage;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN v_rtn;
        WHEN OTHERS THEN
            log_error('get_participant_sid: ' || SQLERRM);
            RAISE;
    END get_participant_sid;

    FUNCTION get_support_obj_url(p_obj IN VARCHAR2, p_support_obj IN VARCHAR2, p_obj_context IN VARCHAR2, p_item_names IN VARCHAR2 := NULL, p_item_values IN VARCHAR2 := NULL) RETURN VARCHAR2 IS

            v_url            VARCHAR2(1000);
            v_obj_count      NUMBER;
            v_obj_type_sid   VARCHAR2(20);
            v_page_num       VARCHAR2(20);
            v_item_names     VARCHAR2(1000);
            v_item_values    VARCHAR2(1000);
            v_tab_sid        VARCHAR2(20);
            
    BEGIN
         SELECT 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
                   || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                   || DECODE(p_item_names, NULL, NULL, ',' || p_item_names) || ''',item_values:'''
                   || p_obj || ',' || p_obj_context || DECODE(p_item_values, NULL, NULL, ',' || p_item_values)
                   || ''',request:''OPEN''})'
              INTO v_url
              FROM T_CORE_DT_OBJ_TYPE_PAGE WHERE obj_type MEMBER OF Osi_Object.get_objtypes(p_obj) AND page_function = 'OPEN';

         --- Figure out what type of supoprt object this is ---
         v_obj_type_sid := core_obj.get_objtype(p_obj);
         v_item_names := p_item_names;
         if v_item_names is not null then
         
           v_item_names := ',' || v_item_names;
           
         end if;
         v_item_values := p_item_values;
         if v_item_values is not null then
         
           v_item_values := ',' || v_item_values;
           
         end if;
         
         --- Is it A Note? ---
         select count(*) into v_obj_count from t_osi_note where sid=p_support_obj;
         if v_obj_count > 0 then
           
           select page_num,sid into v_page_num,v_tab_sid from t_osi_tab where obj_type member of osi_object.get_objtypes(p_obj) and tab_label='Notes';

           v_url := 'javascript:newWindow({page:' || v_page_num || ',clear_cache:''' || v_page_num
                       || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                       || v_item_names || ''',item_values:'''
                       || p_obj || ',' || p_obj_context || v_item_values
                       || ''',request:''DIRECTLINK_' || p_support_obj || '_' || v_tab_sid || '_' || p_obj || '''})';

           return v_url;
           
         end if;

         --- Is it an Assignment? ---
         /*select count(*) into v_obj_count from t_osi_assignment where sid=p_support_obj;
         if v_obj_count > 0 then
           
           select page_num,sid into v_page_num,v_tab_sid from t_osi_tab where obj_type member of osi_object.get_objtypes(p_obj) and tab_label='Assignments';

           v_url := 'javascript:newWindow({page:' || v_page_num || ',clear_cache:''' || v_page_num
                       || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                       || v_item_names || ''',item_values:'''
                       || p_obj || ',' || p_obj_context || v_item_values
                       || ''',request:''DIRECTLINK_' || p_support_obj || '''})';

           return v_url;

         end if;

         --- Is it an Attachment/Report? ---
         select count(*) into v_obj_count from t_osi_attachment where sid=p_support_obj;
         if v_obj_count > 0 then
           
           select page_num,sid into v_page_num,v_tab_sid from t_osi_tab where obj_type member of osi_object.get_objtypes(p_obj) and tab_label='Attachments';

           v_url := 'javascript:newWindow({page:' || v_page_num || ',clear_cache:''' || v_page_num
                       || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                       || v_item_names || ''',item_values:'''
                       || p_obj || ',' || p_obj_context || v_item_values
                       || ''',request:''DIRECTLINK_' || p_support_obj || '''})';

           return v_url;

         end if;*/

         return v_url;
    
    EXCEPTION WHEN OTHERS THEN
             return v_url;
                               
    END get_support_obj_url;
    
    FUNCTION get_object_url(p_obj IN VARCHAR2, p_item_names IN VARCHAR2 := NULL, p_item_values IN VARCHAR2 := NULL) RETURN VARCHAR2 IS

            v_url            VARCHAR2(200);
            v_obj            T_CORE_OBJ.SID%TYPE;
            v_obj_context    T_OSI_PARTICIPANT_VERSION.SID%TYPE;
            v_support_obj    VARCHAR2(20) := null;
            v_split_counter  NUMBER := 1;

    BEGIN
         v_obj := p_obj;
         
         for a in (select * from table(split(v_obj,'~')))
         loop
             if (v_split_counter = 1) then
             
               v_obj := a.column_value;
               
             elsif (v_split_counter = 2) then
                  
                  v_support_obj := a.column_value;
                  
             end if;
             v_split_counter := v_split_counter+1;
             
         end loop;

         --- Special Handling for Evidence Management Module ---
         IF substr(v_obj,1,3)='EMM' THEN
  
           return 'javascript:newWindow({page:30700,clear_cache:''30700'',name:''' || v_obj || ''',item_names:''P0_OBJ'',item_values:''' || LTRIM(v_obj,'EMM') || ''',request:''OPEN''});';

         END IF;         
         --- See if this person has access first ---
         IF (Osi_Auth.Check_Access(v_obj, p_supress_logging=>TRUE) = 'N') THEN

           --- They do not, so do not give them the URL ---
           v_url := 'javascript:newWindow({page:120,clear_cache:'''',name:'''',item_names:''P120_OBJ'',item_values:''' || v_obj || ','',request:''OPEN''})';
           RETURN v_url;

         END IF;
    
         --- Determine if the given p_obj is an obj sid or a participant version sid. ---
         FOR x IN (SELECT SID, participant FROM v_osi_participant_version WHERE SID = v_obj)
         LOOP
             v_obj := x.participant;
             v_obj_context := x.SID;
             
         END LOOP;
         
         if v_support_obj is null then

           SELECT 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
                     || ''',name:''' || v_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                     || DECODE(p_item_names, NULL, NULL, ',' || p_item_names) || ''',item_values:'''
                     || v_obj || ',' || v_obj_context || DECODE(p_item_values, NULL, NULL, ',' || p_item_values)
                     || ''',request:''OPEN''})'
                INTO v_url
                FROM T_CORE_DT_OBJ_TYPE_PAGE WHERE obj_type MEMBER OF Osi_Object.get_objtypes(v_obj) AND page_function = 'OPEN';
         
         else
         
           v_url := get_support_obj_url(v_obj, v_support_obj, v_obj_context, p_item_names, p_item_values);
              
         end if;
         
         RETURN v_url;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_object_url: ' || SQLERRM);
            RETURN('get_object_url: Error');
    END get_object_url;

    FUNCTION get_open_link(p_obj IN VARCHAR2, p_text IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn VARCHAR2(32000);
    BEGIN
        IF p_obj IS NOT NULL THEN
            v_rtn := '<!--' || p_obj || '--><a href="' || get_object_url(p_obj) || '">';
            IF(p_text IS NULL)THEN
                v_rtn := v_rtn || 'Open</a>';
            ELSE
                v_rtn := v_rtn || p_text || '</a>';
            END IF;
            RETURN v_rtn;
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_open_link: ' || SQLERRM);
            RETURN('get_open_link: Error');
    END get_open_link;

    FUNCTION get_tagline_link(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF p_obj IS NOT NULL THEN
          
          IF SUBSTR(p_obj,1,3)='EMM' THEN

            RETURN '<!--' || Core_Obj.get_tagline(p_obj) || '--><a href="' || get_object_url(p_obj) || '">' || Core_Obj.get_tagline(p_obj) || '</a>';

          ELSE

            RETURN '<!--' || Core_Obj.get_tagline(p_obj) || '--><a href="' || get_object_url(p_obj) || '">' || Core_Obj.get_tagline(p_obj) || '</a>';

          END IF;
          
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline_link: ' || SQLERRM);
            RETURN('get_tagline_link: Error');
    END get_tagline_link;

    FUNCTION get_next_id
        RETURN VARCHAR2 IS
        v_personnel_num T_CORE_PERSONNEL.personnel_num%TYPE := NVL(Core_Context.personnel_num, '00000');
        v_year          NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'yy'));
        v_doy           NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'ddd'));
        v_hours         NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'hh24'));
        v_minutes       NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'mi'));
        v_tmp_id        T_OSI_FILE.ID%TYPE                  := NULL;
        v_exists        NUMBER                              := 1;
    BEGIN
         LOOP
             v_tmp_id := LTRIM(RTRIM(TO_CHAR(v_personnel_num,'00000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_year,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_doy,'000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_hours,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_minutes,'00')));

             BEGIN
                 SELECT 1
                   INTO v_exists
                   FROM dual
                  WHERE EXISTS(SELECT 1
                                 FROM (SELECT ID
                                         FROM T_OSI_FILE
                                       UNION ALL
                                       SELECT ID
                                         FROM T_OSI_ACTIVITY) o
                                WHERE o.ID = v_tmp_id);
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     EXIT;
             END;

             v_minutes := v_minutes - 1;

             IF v_minutes < 0 THEN
                
               v_hours := v_hours - 1;
                
               IF v_hours < 0 THEN
                  
                 v_doy := v_doy - 1;
                
                 IF v_doy < 0 THEN
                  
                   v_doy := 365;
                  
                 END IF;
                
                 v_hours := 23;
                  
               END IF;
                
               v_minutes := 59;
                
              END IF;
            
          END LOOP;

          RETURN v_tmp_id;
          
    END get_next_id;

    FUNCTION get_special_interest(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_array    apex_application_global.vc_arr2;
        v_idx      INTEGER                         := 1;
        v_string   VARCHAR2(4000);
    BEGIN
        FOR i IN (SELECT mission
                    FROM T_OSI_MISSION
                   WHERE obj = p_sid
                    AND obj_context = 'I')
        LOOP
            v_array(v_idx) := i.mission;
            v_idx := v_idx + 1;
        END LOOP;

        v_string := apex_util.table_to_string(v_array, ':');
        RETURN v_string;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_special_interest: ' || SQLERRM);
            RAISE;
    END get_special_interest;

    PROCEDURE set_special_interest(p_sid IN VARCHAR2, p_special_interest IN VARCHAR2) IS
        v_array    apex_application_global.vc_arr2;
        v_string   VARCHAR2(4000);
    BEGIN
        v_array := apex_util.string_to_table(p_special_interest, ':');

        FOR i IN 1 .. v_array.COUNT
        LOOP
            INSERT INTO T_OSI_MISSION
                        (obj, mission, obj_context)
                SELECT p_sid, v_array(i), 'I'
                  FROM dual
                 WHERE NOT EXISTS(SELECT 1
                                    FROM T_OSI_MISSION
                                   WHERE obj = p_sid AND mission = v_array(i) AND obj_context = 'I');
        END LOOP;

        DELETE FROM T_OSI_MISSION
              WHERE obj = p_sid AND INSTR(NVL(p_special_interest, 'null'), mission) = 0 and obj_context='I';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('set_special_interest: ' || SQLERRM);
            RAISE;
    END set_special_interest;
    
    /* Gets the status history SID of an object */
    FUNCTION get_status_history_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR k IN (SELECT SID
                    FROM T_OSI_STATUS_HISTORY
                   WHERE obj = p_obj AND is_current = 'Y')
        LOOP
            RETURN k.SID;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in get_status_history_sid function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_history_sid;
    
    FUNCTION get_status_code(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT s.code
                    FROM T_OSI_STATUS_HISTORY sh, T_OSI_STATUS s
                   WHERE sh.SID = get_status_history_sid(p_obj)
                     AND sh.status = s.SID)
        LOOP
            RETURN x.code;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status_code: ' || SQLERRM);
            RETURN NULL;
    END get_status_code;

    FUNCTION get_status_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR a IN (SELECT status
                    FROM T_OSI_STATUS_HISTORY
                   WHERE SID = get_status_history_sid(p_obj))
        LOOP
            RETURN a.status;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in GET_STATUS function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_sid;

    FUNCTION get_status(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_status   T_OSI_STATUS.description%TYPE;
    BEGIN
        IF p_obj IS NULL THEN
            log_error('get_status: null parameter passed');
            RETURN NULL;
        END IF;

        SELECT description
          INTO v_status
          FROM T_OSI_STATUS
         WHERE SID = get_status_sid(p_obj);

        RETURN v_status;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status: ' || SQLERRM || ' ~ ' || p_obj);
            RETURN NULL;
    END get_status;

    FUNCTION get_objtype_desc(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_description   T_CORE_OBJ_TYPE.description%TYPE;
    BEGIN
        SELECT description
          INTO v_description
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type
            OR code = p_obj_type;

        RETURN v_description;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_desc: ' || SQLERRM);
            RETURN('get_objtype_desc: Error');
    END get_objtype_desc;
    
        FUNCTION get_objtype_code(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   T_CORE_OBJ_TYPE.code%TYPE;
    BEGIN
        SELECT code
          INTO v_return
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_code: ' || SQLERRM);
            RETURN('get_objtype_code: Error');
    END get_objtype_code;

    /* Gets the object specific package to call */
    FUNCTION get_obj_package(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_package   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        SELECT method_pkg
          INTO v_package
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_package;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_obj_package: ' || SQLERRM);
            RAISE;
    END get_obj_package;

    PROCEDURE create_lead_assignment(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL) IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        IF p_obj IS NOT NULL THEN
            INSERT INTO T_OSI_ASSIGNMENT
                        (obj, personnel, unit, start_date, assign_role)
                 VALUES (p_obj,
                         v_personnel,
                         Osi_Personnel.get_current_unit(v_personnel),
                         SYSDATE,
                         (SELECT SID
                            FROM T_OSI_ASSIGNMENT_ROLE_TYPE
                           WHERE obj_type MEMBER OF get_objtypes(p_obj) AND code = 'LEAD'));
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_lead_assignment: ' || SQLERRM);
            RAISE;
    END create_lead_assignment;

    /* pipelines records of type t_parent_list one at a time.
       finds the input object type first, including this in the list.
       then it return the parent object type, and the parent's parent, etc.. */
    FUNCTION get_objtypes(p_obj_or_type IN VARCHAR2)
        RETURN t_parent_list pipelined IS
        v_tmp_parent    T_OSI_OBJ_TYPE.PARENT%TYPE;
        v_tmp_objtype   T_OSI_OBJ_TYPE.SID%TYPE;
    BEGIN
        v_tmp_objtype := Core_Obj.get_objtype(p_obj_or_type);

        IF v_tmp_objtype IS NULL THEN
            v_tmp_objtype := p_obj_or_type;
        END IF;

        LOOP
        BEGIN
            pipe ROW(v_tmp_objtype);

            SELECT PARENT
              INTO v_tmp_parent
              FROM T_OSI_OBJ_TYPE
             WHERE SID = v_tmp_objtype;

            EXIT WHEN v_tmp_parent IS NULL;
            v_tmp_objtype := v_tmp_parent;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            EXIT;
        END;
        END LOOP;

        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('get_objtypes: ' || SQLERRM);
            RETURN;
    END get_objtypes;

    FUNCTION get_id(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
         IF SUBSTR(p_obj,1,3)='EMM' THEN
           
           RETURN 'Evidence Management Module for:  ' || core_obj.get_tagline(LTRIM(p_obj,'EMM'));
           
         ELSE

           SELECT method_pkg, code
             INTO v_method_pkg, v_type_code
             FROM T_CORE_OBJ_TYPE
            WHERE SID = Core_Obj.get_objtype(p_obj);

           IF v_type_code LIKE 'ACT.%' THEN
             RETURN Osi_Activity.get_id(p_obj);
           ELSIF v_type_code LIKE 'FILE.%' THEN
                RETURN Osi_File.get_id(p_obj);
           ELSIF v_method_pkg IS NULL THEN
                RETURN NULL;
           ELSE
               BEGIN
                    EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.get_id(:obj,:context); end;'
                            USING OUT v_rtn, IN p_obj, IN p_obj_context;
                    RETURN v_rtn;
               EXCEPTION
                    WHEN OTHERS THEN
                        RETURN NULL;
               END;

           END IF;

         END IF;
          
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'invalid object type';
        WHEN OTHERS THEN
            RETURN 'untrapped error';
    END get_id;
    
    /* Takes and ACTIVITY or FILE sid and return the currently assigned unit */
    FUNCTION get_assigned_unit(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(20);
    --This function is assuming an object will always have an assignment of some type
    BEGIN
        --See if it is an activity
        FOR k IN (SELECT assigned_unit
                    FROM T_OSI_ACTIVITY
                   WHERE SID = p_obj)
        LOOP
            --An activity was found, send back the unit.
            RETURN k.assigned_unit;
        END LOOP;

        FOR k IN (SELECT SID FROM T_OSI_FILE WHERE SID = p_obj)
        LOOP
            RETURN Osi_File.get_unit_owner(p_obj);
        END LOOP;

        FOR k IN (SELECT unit FROM T_CFUNDS_ADVANCE_V2 WHERE SID = p_obj) LOOP
            RETURN k.unit;
        END LOOP;
        
        RETURN '<none>';
    EXCEPTION
        WHEN OTHERS THEN
            log_error(SQLERRM);
            RAISE;
    END get_assigned_unit;
    
    /* Performs deletion operation for all objects */
    FUNCTION delete_object(p_obj IN VARCHAR2) RETURN VARCHAR2 IS

          v_rtn      VARCHAR2(200)             := NULL;
          v_ot       VARCHAR2(20)              := NULL;
          v_ot_cd    VARCHAR2(200)             := NULL;

    BEGIN
         v_ot := Core_Obj.get_objtype(p_obj);

         IF v_ot IS NULL THEN

           log_error('Delete_Object: Error locating Object Type for ' || NVL(v_ot, 'NULL'));
           RETURN 'Invalid Object passed to Delete_Object';

         END IF;

         SELECT code INTO v_ot_cd FROM T_CORE_OBJ_TYPE WHERE SID = v_ot;

         CASE 
             WHEN SUBSTR(v_ot_cd,1,3) = 'ACT' THEN

                 v_rtn := Osi_Activity.can_delete(p_obj);

             WHEN SUBSTR(v_ot_cd,1,4) = 'FILE' THEN

                 v_rtn := Osi_File.can_delete(p_obj);
  
             WHEN SUBSTR(v_ot_cd,1,4) = 'PART' THEN

                 v_rtn := Osi_Participant.can_delete(p_obj);
      
             WHEN v_ot_cd = 'CFUNDS_ADV' THEN

                 v_rtn := Osi_Cfunds_Adv.can_delete(p_obj);
  
             WHEN v_ot_cd = 'CFUNDS_EXP' THEN

                 v_rtn := Osi_Cfunds.can_delete(p_obj);

             WHEN v_ot_cd = 'UNIT' THEN

                 ---Can never delete units, if this changes, will need to make a OSI_UNIT.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';

             WHEN v_ot_cd = 'PERSONNEL' THEN

                 ---Can never delete Personnel, if this changes, will need to make a OSI_PERSONNEL.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';
             
             WHEN v_ot_cd = 'EVIDENCE' THEN

                 ---Gets here ONLY if the Evidence is NOT Read-ONLY---
                 v_rtn := 'Y';
                      
             ELSE 
                 v_rtn := 'You are not authorized to perform the requested action.';

         END CASE;

         IF v_rtn <> 'Y' THEN

           RETURN v_rtn;

         END IF;
    
         ---execute the delete, all object-specific and child table deletions will cascade---
         DELETE FROM T_CORE_OBJ WHERE SID = p_obj;

         RETURN 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            log_error('Delete_Object: Error encountered using Object ' || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in Delete_Object using Object: ' || NVL(p_obj, 'NULL');
    END delete_object;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        
        SELECT method_pkg, code
          INTO v_method_pkg, v_type_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        IF v_type_code LIKE 'ACT.%' THEN
            RETURN Osi_Activity.check_writability(p_obj);
        ELSE
            BEGIN
                EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.check_writability(:obj,:context); end;'
                        USING OUT v_rtn, IN p_obj, IN p_obj_context;
                RETURN v_rtn;
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN 'Y';
            END;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('osi_object.check_writability: invalid object type');
        WHEN OTHERS THEN
            log_error('osi_object.check_writablity: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION is_assigned(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        FOR x IN (SELECT 'Y' AS result
                    FROM T_OSI_ASSIGNMENT
                   WHERE obj = p_obj
                     AND personnel = v_personnel
                     AND SYSDATE BETWEEN NVL(start_date, TO_DATE('01011901', 'mmddyyyy'))
                                     AND NVL(end_date, TO_DATE('12312999', 'mmddyyyy')))
        LOOP
            RETURN x.result;
        END LOOP;
        
        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.is_assigned: ' || SQLERRM);
            RAISE;
    END is_assigned;

    FUNCTION get_lead_agent(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR i IN (SELECT oa.personnel
                    FROM T_OSI_ASSIGNMENT oa, 
                         T_OSI_ASSIGNMENT_ROLE_TYPE oart
                   WHERE oa.obj = p_obj
                     AND oa.assign_role = oart.SID 
                     AND oart.code = 'LEAD'
                ORDER BY oa.end_date DESC)
        LOOP
            RETURN i.personnel;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.get_lead_agent: ' || SQLERRM);
            RAISE;
    END get_lead_agent;

    FUNCTION get_lead_agent_name(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
            FOR i IN (SELECT cp.last_name, cp.first_name
                        FROM T_OSI_ASSIGNMENT oa, 
                             T_OSI_ASSIGNMENT_ROLE_TYPE oart,
                             T_CORE_PERSONNEL cp
                       WHERE oa.obj = p_obj
                         AND oa.personnel = cp.SID
                         AND oa.assign_role = oart.SID 
                         AND oart.code = 'LEAD'
                    ORDER BY oa.end_date DESC)
            LOOP
                RETURN  i.last_name || ', ' || i.first_name;
            END LOOP;
            RETURN 'NO LEAD AGENT';
        EXCEPTION
            WHEN OTHERS THEN
                RETURN 'NO LEAD AGENT';
    END get_lead_agent_name;

--======================================================================================================================
--======================================================================================================================
    FUNCTION addicon(v_template IN CLOB, p_sid IN VARCHAR2)
        RETURN CLOB IS
        v_rtn        CLOB           := NULL;
        v_iconlink   VARCHAR2(1000);
        v_inifile    VARCHAR2(128);
        v_vlturl     VARCHAR2(1000);
    BEGIN

        SELECT setting                                                                       --value
          INTO v_inifile
          FROM T_CORE_CONFIG
         WHERE code = 'DEFAULTINI';

        v_iconlink :=
            '<A HREF="I2MS:://pSid=' || p_sid || ' ' || v_inifile
            || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="\images\I2MS\OBJ_SEARCH\i2ms.gif"></A>&nbsp&nbsp';
        IF    Core_Util.get_config('OSI_VLT_URL_JSP') IS NOT NULL
           OR Core_Util.get_config('OSI_VLT_URL_OWA') IS NOT NULL THEN

        v_iconlink :=
            v_iconlink || '<A HREF="' || v_vlturl
            || '"><IMG BORDER=0 ALT="Launch Visual Link Tool" SRC="\images\I2MS\OBJ_SEARCH\vlt.gif"></A>&nbsp&nbsp';

        END IF;
        IF    v_template = ''
           OR v_template IS NULL THEN
            v_rtn := v_iconlink;
        ELSE
            SELECT REPLACE(v_template, '<h2>', '<h2>' || v_iconlink)
              INTO v_rtn
              FROM dual;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.AddIcon Error: ' || SQLERRM);
            RETURN v_template;
    END addicon;

--======================================================================================================================
--   Retrieve the poper template                                                                                      ==
--======================================================================================================================

    PROCEDURE get_template(p_name IN VARCHAR2, p_template IN OUT NOCOPY CLOB) IS
        v_date              DATE;
        v_ok                VARCHAR2(256);
        v_prefix            VARCHAR2(20) := 'osi_';
        v_mime_type         T_CORE_TEMPLATE.mime_type%TYPE;
        v_mime_disposition  T_CORE_TEMPLATE.mime_disposition%TYPE;
    BEGIN

        v_ok := Core_Template.get_latest(v_prefix || p_name, p_template, v_date, v_mime_type, v_mime_disposition);

        IF v_date IS NULL THEN                                         -- try it without the prefix
            v_ok := Core_Template.get_latest(p_name, p_template, v_date, v_mime_type, v_mime_disposition);

            IF v_date IS NULL THEN

                RAISE_APPLICATION_ERROR(-20200,
                                        'Could not locate template "' || v_prefix || p_name || '"');
            END IF;
        END IF;

    END get_template;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_assoc_activities(
        p_doc      IN OUT NOCOPY   CLOB,
        p_parent   IN              VARCHAR2) IS

        v_cnt    NUMBER;
        v_temp   VARCHAR2(5000);

    BEGIN
        v_cnt := 0;

        FOR h IN (SELECT activity_sid, activity_id, activity_title
                    FROM v_osi_assoc_fle_act
                   WHERE file_sid = p_parent)
        LOOP
            IF (   (Core_Classification.has_hi(h.activity_sid, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.activity_sid, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Assoc_Activities: Object is ORCON or LIMDIS - User does not have permission to view document '
                     || 'therefore no link will be generated');
            ELSE
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
            v_temp := v_temp || Osi_Object.get_tagline_link(h.activity_sid);
            v_temp := v_temp || ', ' || h.activity_title || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;
    END append_assoc_activities;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_attachments(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_cnt2   NUMBER         := 0;
        v_temp   VARCHAR2(5000);

    BEGIN

        FOR h IN (SELECT a.SID, 
                           AT.USAGE, 
                           NVL(a.description, AT.description) AS desc_type,
                           NVL(dbms_lob.getlength(a.content), 0) AS blob_length
                      FROM T_OSI_ATTACHMENT a,
                           T_OSI_ATTACHMENT_TYPE AT,
                           T_CORE_OBJ o,
                           T_CORE_OBJ_TYPE ot
                     WHERE a.obj = p_parent
                       AND a.obj = o.SID
                       AND a.TYPE = AT.SID(+)
                       AND o.obj_type = ot.SID
                       AND NVL(AT.USAGE, 'ATTACHMENT') = 'ATTACHMENT'
                  ORDER BY a.modify_on)
        LOOP
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD><B>' || v_cnt || ':</B> </TD>';
            v_temp := v_temp || '<TD width="100%">';

            IF h.blob_length > 0 THEN
                --v_temp := v_temp || '<a href="docs/' || h.sid || '">';
                v_temp := v_temp || '<a href="f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':'
                                || h.SID || ':' || v('DEBUG') || ':250: " target="blank"/>';
            END IF;

            -- If there is no description then put something
            IF h.desc_type IS NULL THEN
                v_temp := v_temp || h.SID;
            ELSE
                v_temp := v_temp || h.desc_type;
            END IF;

            IF h.blob_length > 0 THEN
              v_temp := v_temp || '</a>';
            END IF;

            v_temp := v_temp || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
        END LOOP;
        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.Append_Attachments Error: ' || SQLERRM);
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
    END append_attachments;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_involved_participants(
        p_clob         IN OUT NOCOPY   CLOB,
        p_parent       IN              VARCHAR2,
        p_leave_blank  IN              BOOLEAN := FALSE) IS

        v_object_type   VARCHAR2(4);

    BEGIN
      SELECT SUBSTR(ot.code, 1, 4)
        INTO v_object_type
        FROM T_CORE_OBJ o,
             T_CORE_OBJ_TYPE ot
       WHERE o.SID = p_parent
         AND o.obj_type = ot.SID;

      CASE v_object_type
      WHEN 'FILE'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT fi.ROLE,
                           pv.participant
                      FROM v_osi_partic_file_involvement fi,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = fi.participant_version
                       AND fi.file_sid = p_parent
                  ORDER BY fi.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      WHEN 'ACT.'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT ai.ROLE,
                           pv.participant
                      FROM v_osi_partic_act_involvement ai,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = ai.participant_version
                       AND ai.activity = p_parent
                 ORDER BY ai.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      ELSE
        IF NOT p_leave_blank 
          THEN
            Osi_Util.aitc(p_clob, '<tr><td>No data found</td></tr>');
        END IF;
      END CASE;
    

    END append_involved_participants;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_notes(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt   NUMBER := 0;
    BEGIN

        v_cnt := 0;

        FOR n IN (SELECT n.modify_on, 
                      nt.description,
                      n.note_text
                 FROM T_OSI_NOTE n,
                      T_OSI_NOTE_TYPE nt
                WHERE n.obj = p_parent
                  AND n.note_type = nt.SID
             ORDER BY n.modify_on DESC)
        LOOP
            v_cnt := v_cnt + 1;
            Osi_Util.aitc(p_doc,
                 '<TR><TD width="100%"><B>' || v_cnt || ': NOTE (' || n.description || ', '
                 || TO_CHAR(n.modify_on, 'dd-Mon-YY hh24:mi:ss') || ')</B><BR>');
            dbms_lob.append(p_doc, Core_Util.html_ize(n.note_text));
            Osi_Util.aitc(p_doc, CHR(13) || CHR(10) || '</TD></TR>');
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD>No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Util.append_info_to_clob(p_doc,
                                '<TR><TD width="100%">No Data Found</TD></TR>' || CHR(13) || CHR(10)
                                || '</table></body>' || CHR(13) || CHR(10),
                                '');
    END append_notes;


--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_related_files(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_temp   VARCHAR2(5000);
    BEGIN

        FOR h IN (SELECT af.file_a AS related_file,
                        (SELECT ID
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS ID,
                        (SELECT title
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS title,
                        (SELECT sot.description
                           FROM T_CORE_OBJ so,
                                T_CORE_OBJ_TYPE sot
                          WHERE so.SID = af.file_a
                            AND so.obj_type = sot.SID) AS description
                   FROM T_OSI_FILE f,
                        T_OSI_ASSOC_FLE_FLE af,
                        T_CORE_OBJ o,
                        T_CORE_OBJ_TYPE ot
                  WHERE f.SID = p_parent
                    AND f.SID = o.SID
                    AND f.SID = af.file_b
                    AND o.obj_type = ot.SID 
                  UNION 
                 SELECT af.file_b AS related_file,
                       (SELECT ID
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS ID,
                       (SELECT title
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS title,
                       (SELECT sot.description
                          FROM T_CORE_OBJ so,
                               T_CORE_OBJ_TYPE sot
                         WHERE so.SID = af.file_b
                           AND so.obj_type = sot.SID) AS description
                  FROM T_OSI_FILE f,
                       T_OSI_ASSOC_FLE_FLE af,
                       T_CORE_OBJ o,
                       T_CORE_OBJ_TYPE ot
                 WHERE f.SID = p_parent
                   AND f.SID = o.SID
                   AND f.SID = af.file_a
                   AND o.obj_type = ot.SID 
              ORDER BY ID)
        LOOP
            IF ((Core_Classification.has_hi(h.related_file, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.related_file, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Related_Files: Object is ORCON or LIMDIS - User does not have permission to view document therefore no link will be generated');
            ELSE
                v_cnt := v_cnt + 1;
                v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
                v_temp := v_temp || Osi_Object.get_tagline_link(h.related_file) || ', ';
                v_temp := v_temp || h.title || ', ' || h.description;
                v_temp := v_temp || '</TD></TR>';
                Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;

    END append_related_files;


--======================================================================================================================
--  Initial parsing routine to determine appropriate report to generate.  Once the the proper report is determined    ==
--  the coorisponding report procedure is called.                                                                     ==
--======================================================================================================================
    PROCEDURE doc_detail(p_sid IN VARCHAR2 := NULL) IS

        v_ok           VARCHAR2(1000);
        v_doc          CLOB;
        v_obj_type     T_CORE_OBJ_TYPE.code%TYPE;
        v_authorized   VARCHAR2(10);                             -- can the user run a search
        v_restrict     VARCHAR2(10);                             -- For checking restricted objects
        v_cookie       VARCHAR2(100)   := NULL;

    BEGIN

        BEGIN
            -- restricted files and activities should not be displayed
            v_obj_type := NULL;
            v_restrict := NULL;

            SELECT SUBSTR(ot.code, 1, 3)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'ACT' THEN

                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_ACTIVITY a,
                       T_OSI_REFERENCE r
                 WHERE a.SID = p_sid
                   AND a.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This activity is restricted.');
                    RETURN;
                END IF;
            END IF;

            SELECT SUBSTR(ot.code, 1, 4)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'FILE' THEN
                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_FILE f,
                       T_OSI_REFERENCE r
                 WHERE f.SID = p_sid
                   AND f.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This file is restricted.');
                    RETURN;
                END IF;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;                                                 -- Continue processing
        END;

        -- there are calls from other procedures that do not set up the links to pass obj_type.
        -- therefore the need to make sure there is one. Hopefully.
        SELECT ot.code
          INTO v_obj_type
          FROM T_CORE_OBJ o,
               T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_sid
           AND o.obj_type = ot.SID;

        Core_Util.append_info_to_clob(v_doc, CHR(10), '');

        IF SUBSTR(v_obj_type, 1, 3) = 'ACT'
          THEN Osi_Activity.make_doc_act(p_sid, v_doc);   -- Activity Report
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART'
              THEN Osi_Participant.run_report_details(p_sid); -- Participant Report
              ELSE
                IF SUBSTR(v_obj_type, 1, 8) = 'FILE.INV'
                  THEN Osi_Investigation.make_doc_investigative_file(p_sid, v_doc); -- Investigative File Report
                  ELSE Osi_File.make_doc_misc_file(p_sid, v_doc); -- General File Report
                END IF;
            END IF;
        END IF;


        IF dbms_lob.getlength(v_doc) > 10 
          THEN
            v_ok := Core_Util.serve_clob(v_doc);
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART' 
              THEN NULL;
              ELSE htp.print('<html><head><title>No Document Exists</title></head>'
                      || '<body>No document currently exists for this object.</body></html>');
           END IF;
        END IF;

        Core_Util.cleanup_temp_clob(v_doc);
    END doc_detail;
 
    FUNCTION getStatusBar(p_obj_sid IN VARCHAR2) RETURN VARCHAR2 IS

        v_return VARCHAR2(4000);
        v_type_descr VARCHAR2(200);
        v_create_on VARCHAR2(200);
        v_status VARCHAR2(200);
        v_type_code VARCHAR2(200);
        v_tag VARCHAR2(200);
        v_obtained_by VARCHAR2(200);
        v_personnel_name VARCHAR2(200);
        v_unit_name VARCHAR2(200);
        v_suffix VARCHAR2(200);
        v_obj_type_sid VARCHAR2(200);
        v_obj_act_type_sid VARCHAR2(200);
        v_obj_fle_type_sid VARCHAR2(200);
        v_photo_count VARCHAR2(200);
        v_photo_size VARCHAR2(200);
        v_photo_tab_sid VARCHAR2(200);
        v_deers_date date;
        v_deers_date_string varchar2(200);
        v_classification varchar2(4000);
        
    BEGIN
         IF p_obj_sid IS NULL OR p_obj_sid='' THEN
    
           RETURN '';
     
         END IF;
   
         --- Get the Object Type Sid for ALL Activities ---
         BEGIN
              SELECT SID INTO v_obj_act_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='ACT';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_act_type_sid := '*unknown*';
      
         END;

         --- Get the Object Type Sid for ALL Files ---
         BEGIN
              SELECT SID INTO v_obj_fle_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='FILE';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_fle_type_sid := '*unknown*';
      
         END;

         --- Get the Type Code and Sid for the Current Object (p_obj_sid) ---
         BEGIN
              SELECT CODE,T.SID INTO v_type_code,v_obj_type_sid FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_code := '*unknown*';
      
         END;

         IF v_type_code IN ('EMM','UNIT','*unknown*') THEN
       
           RETURN '';
     
         END IF;
      
         --- Get Status for C-Funds Expense Objects ---
         IF v_type_code = 'CFUNDS_EXP' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_expense_v3 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for C-Funds Advance Objects ---
         ELSIF v_type_code = 'CFUNDS_ADV' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_advance_v2 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for All Other Objects ---
         ELSE
   
           BEGIN
                SELECT Osi_Object.get_status(p_obj_sid) INTO v_status FROM dual;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;
     
         END IF;
   
         --- Fix the Working for Pariticpant Confirmed/Unconfirmed ---
         IF v_status IN ('Confirm','Unconfirm') THEN
      
           v_status := v_status || 'ed';
     
         END IF;
   
         --- Get Object Type Description ---
         BEGIN
              SELECT description INTO v_type_descr FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_descr := '*unknown*';
      
         END;

         --- Get Create On Date ---
         BEGIN
              SELECT TO_CHAR(create_on,'dd-Mon-yyyy') INTO v_create_on FROM T_CORE_OBJ WHERE SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_create_on := '*unknown*';
      
         END;

         --- Get Activity Or File Suffix so we will say "Search Activity" instead of just "Search" ---
         BEGIN
              SELECT ' Activity' INTO v_suffix FROM dual WHERE v_obj_act_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
         EXCEPTION WHEN OTHERS THEN
            
            v_suffix := '';
      
         END;
   
         --- Get Activity Or File Suffix so we will say "Case File" instead of just "Case" ---
         IF v_suffix = '' OR v_suffix IS NULL THEN

           BEGIN
                SELECT ' File' INTO v_suffix FROM dual WHERE v_obj_fle_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
           EXCEPTION WHEN OTHERS THEN
            
                         v_suffix := '';
      
           END;
     
         END IF;
   
         --- Make sure we don't say "Security Polygrpah File File" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-4,5) = ' File' THEN
     
           v_suffix := '';
     
         END IF;

         --- Make sure we don't say "Agent Application Activity - Education Activity Activity" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-8,9) = ' Activity' THEN
     
           v_suffix := '';
     
         END IF;
   
         IF v_type_code = 'EVIDENCE' THEN
           
           BEGIN
                SELECT SUBSTR(DESCRIPTION,1,50),TO_CHAR(OBTAINED_DATE,'dd-Mon-yyyy'),STATUS,TAG_NUMBER,OBTAINED_BY
                      INTO v_type_descr,v_create_on,v_status,v_tag,v_obtained_by FROM v_osi_evidence WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
              
                    RETURN '';
     
           END;

           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || ' <small>Description</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_create_on || ' <small>Obtained on</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_tag || ' <small>Tag #</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_obtained_by || ' <small>Obtained By</small></li>' || CHR(10) || CHR(13);

         ELSIF v_type_code = 'PERSONNEL' THEN
           
              BEGIN
                   SELECT DECODE(PERSONNEL_STATUS,'CL','Closed','OP','Open','SU','Suspended','Unknown'),TO_CHAR(STATUS_DATE,'dd-Mon-yyyy'),PERSONNEL_NAME,UNIT_NAME
                         INTO v_type_descr,v_create_on,v_personnel_name,v_unit_name FROM v_osi_personnel WHERE SID=p_obj_sid;
     
              EXCEPTION WHEN OTHERS THEN
              
                       RETURN '';
     
              END;  
      
              v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
              v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Status: ' || v_type_descr || ' <small>Status</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Effective: ' || v_create_on || ' <small>Effective</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Agent: ' || v_personnel_name || ' <small>Agent Name</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Unit: ' || v_unit_name || ' <small>Assigned To</small></li>' || CHR(10) || CHR(13);

         ELSE
  
           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || v_suffix || ' <small>Object Type</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Created on ' || v_create_on || ' <small>Create Date</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Status is ' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
     
           IF v_type_code = 'PART.INDIV' THEN
             
             BEGIN
                  SELECT COUNT(*),Osi_Util.parse_size(SUM(DBMS_LOB.GETLENGTH(CONTENT))) INTO v_photo_count,v_photo_size FROM T_OSI_ATTACHMENT A,T_OSI_ATTACHMENT_TYPE T WHERE A.TYPE=T.SID AND T.USAGE='MUGSHOT' AND A.OBJ=p_obj_sid;

                  IF v_photo_count = '1' THEN
        
                    v_photo_count := v_photo_count || ' Photo';
      
                  ELSE

                    v_photo_count := v_photo_count || ' Photos';
         
                  END IF;
            
             EXCEPTION WHEN OTHERS THEN
    
                      v_photo_count := '0';
                      v_photo_size := '0 KB';
    
             END;
             
             BEGIN
                  SELECT SID INTO v_photo_tab_sid FROM T_OSI_TAB WHERE tab_label='Photo/Image';

             EXCEPTION WHEN OTHERS THEN

                      v_photo_tab_sid := '2220000077I';

             END;
    
             v_return := v_return || '  <li><a href=javascript:goToTab(''' || v_photo_tab_sid || '''); return false;>' || v_photo_count || '/' || v_photo_size || '</a> <small>Photos/Size</small></li>' || CHR(10) || CHR(13);

             BEGIN
                  SELECT max(DEERS_DATE) INTO v_deers_date FROM T_OSI_PARTICIPANT_HUMAN H,T_OSI_PARTICIPANT_VERSION V WHERE V.PARTICIPANT=p_obj_sid AND V.SID=H.SID;

                  if v_deers_date is null then
                    
                    v_deers_date_string := 'Never';

                  else

                    v_deers_date_string := to_char(v_deers_date,'dd-Mon-YYYY HH:MI:SS PM');
                  
                  end if;
                  
             EXCEPTION WHEN OTHERS THEN

                      v_deers_date := 'Never';

             END;
             v_return := v_return || '  <li>' || v_deers_date_string || '<small>Last DEERS</small></li>' || CHR(10) || CHR(13);
    
           END IF;
           
           v_classification := core_classification.FULL_MARKING(p_obj_sid);
           
           if v_classification is null or v_classification='' then
  
             v_classification := core_util.GET_CONFIG('OSI.DEFAULT_CLASS');
             
             if length(v_classification)<2 then
               
               begin
                    select description into v_classification from t_core_classification_level where code=v_classification;
               
               exception when others then

                             v_classification := core_util.GET_CONFIG('OSI.DEFAULT_CLASS');
               
               end;
               
             end if;
  
           end if;
           v_return := v_return || '  <li>This OBJECT IS Classified:  ' || v_classification || '<small>Classification</small></li>' || CHR(10) || CHR(13);
     
         END IF;
         
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="minbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="minbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="minbutton" onclick="javascript:hideStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/min.gif" align=bottom><small>Minimize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul">' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="maxbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="maxbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="maxbutton" onclick="javascript:showStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/max.gif" align=bottom><small>Maximize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);
   
         RETURN v_return;
   
    END getStatusBar;

    FUNCTION is_object_active (p_obj in varchar2) return varchar2 is 
  
            p_Active varchar2(1) := 'Y';
            p_Status varchar2(4000);
            p_StatusDate date;
            p_ObjType varchar2(100);
    
    begin
         begin
              select t.code into p_ObjType from t_core_obj c, t_core_obj_type t where c.obj_type=t.sid and c.sid=p_obj;

         exception when others then
              
                  return p_Active;
              
         end;
         
         if p_ObjType in ('CFUNDS_ADV','CFUNDS_EXP') then
           
           begin
                select upper(status),sysdate-120 into p_Status,p_StatusDate from v_cfunds_expense_v3 where sid=p_obj;
                
           exception when others then

                    return p_Active;
                    
           end;
           
         else

           begin
                select upper(s.description),h.effective_on into p_Status,p_StatusDate from t_osi_status_history h, t_osi_status s
                  where h.obj=p_obj
                    and h.status=s.sid
                    and h.is_current='Y';
                    
           exception when others then

                    return p_Active;
                    
           end;
                   
         end if;
         
         If p_Status in ('CLOSED', 'ADMIN CLOSURE', 'TERMINATED', 'DISALLOWED', 'REPAID') then

           --- has it been 30 days ---
           If p_StatusDate + 30 < sysdate then

             --- inactive ---
             p_Active := 'N';

           end if;

         end if;

         If p_Status in ('ARCHIVED','SUBMITTED TO ARCHIVE','SENT TO ARCHIVE','RECEIVED AT ARCHIVE') then --instantly inactive once archived

           --- inactive ---
           p_Active := 'N';

         end if; 
   
         return p_Active;
  
    end is_object_active;

    function Go_To_Tab(pRequest in varchar2,pAuditing in varchar2,p_obj in varchar2,p0_obj_type_sid in varchar2,p0_tabs in out varchar2,tab_params in out varchar2,tab_page in out varchar2, tab_page_obj in out varchar2) return varchar2 is

            v_tab varchar2(20);
            v_tmp varchar2(100);
            v_cnt number := 0;
            
            procedure traverse_tab_parents(p_tab varchar2) is

                     v_parent t_osi_tab.parent_tab%type;
                     v_result boolean;
                     
            begin
                 v_result := core_list.add_item_to_list_front(p_tab, p0_tabs);
          
                 select parent_tab into v_parent from t_osi_tab where sid = p_tab;
          
                 if v_parent is not null then
     
                   traverse_tab_parents(v_parent);

                 end if;
            end traverse_tab_parents;

            procedure set_tab_info(p_tab varchar2) is

                     v_cur_tab t_osi_tab.sid%type;
                     v_result boolean;
                     v_caption t_osi_tab.tab_label%type;
                     
            begin  
                 select page_num, tab_params, tab_label into tab_page, tab_params, v_caption from t_osi_tab where sid = p_tab;

                 if pAuditing = 'ON' then

                   log_info('TabShown:' || p_obj || ' - ' || v_caption);
         
                 end if;

                 if tab_page is null then

                   select x.sid into v_cur_tab from (select sid from t_osi_tab where parent_tab = p_tab and obj_type member of osi_object.get_objtypes(p0_obj_type_sid) order by is_default desc, seq asc) x where rownum = 1;
                   v_result := core_list.add_item_to_list(v_cur_tab, p0_tabs);
                   set_tab_info(v_cur_tab);
                   
                end if;
                
            end set_tab_info;
    begin
         if pRequest like 'TAB_%' then

           if pRequest like 'TAB_%_%' then
      
             v_tmp := substr(pRequest, 5);
      
             for a in (select * from table(split(v_tmp,'_')))
             loop
                 v_cnt := v_cnt + 1;

                 if v_cnt=1 then
            
                   v_tab := a.column_value;
                   v_cnt:=1;

                 end if;

                 if v_cnt=2 then
            
                   tab_page_obj := a.column_value;

                 end if;

             end loop;

            p0_tabs := null;
            traverse_tab_parents(v_tab);
            set_tab_info(v_tab);

          else 

            p0_tabs := null;
            v_tab := substr(pRequest, 5);
            traverse_tab_parents(v_tab);
            set_tab_info(v_tab);

          end if;

        else

          tab_page := null;
  
         end if;

       return p_obj;
       
    end Go_To_Tab;
     
END Osi_Object;
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
--   Date and Time:   07:51 Friday October 5, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PAGE TEMPLATE: Desktop
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
 
 
prompt Component Export: PAGE TEMPLATE 92011431286949262
 
prompt  ...page templates for application: 100
--
prompt  ......Page template 92011431286949262
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"'||chr(10)||
' "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'||chr(10)||
''||chr(10)||
'<html lang="&BROWSER_LANGUAGE.">'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#javascript/i2ms.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'   var imgPrefix = ''#IMAGE_PREFIX#'';'||chr(10)||
'   var helpURL = ''&HELP_URL.'';'||chr(10)||
'   setGlobals("&APP_ID.","&SESSION.","&DEBUG.");'||chr(10)||
'</script>'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</tit';

c1:=c1||'le>'||chr(10)||
''||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/OSI/OSI.css" type="text/css" />'||chr(10)||
''||chr(10)||
'<script src="#IMAGE_PREFIX#jQuery/jQueryIncludes.js" type="text/javascript"></script>'||chr(10)||
''||chr(10)||
'<!-- Right Click Menu Code START -->'||chr(10)||
'<script type="text/javascript" src="#IMAGE_PREFIX#jQuery/RightClickMenu/jquery.contextmenu.js"></script>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#jQuery/RightClickMenu/jquery.contextmenu';

c1:=c1||'.css" type="text/css" />'||chr(10)||
''||chr(10)||
'<script type="text/javascript">'||chr(10)||
'/////////////////////////////////////////////////////////////////'||chr(10)||
'// Need to supply full path or IE will give a Security Warning //'||chr(10)||
'/////////////////////////////////////////////////////////////////'||chr(10)||
'var path = window.location+'''';'||chr(10)||
'path = path.substr(0,path.indexOf(''/pls/''))+#IMAGE_PREFIX#+''jQuery/RightClickMenu/'';'||chr(10)||
''||chr(10)||
'var vRankColumnNum = 0;'||chr(10)||
''||chr(10)||
'va';

c1:=c1||'r menu1 = [ '||chr(10)||
'             {''Open Object'':{ onclick:function(menuItem,menu) { javascript:getObjURL(GetSidFromOpenLink($(this))); }, icon:path+''OpenObject.gif'', title:''Open this Object'' } }, '||chr(10)||
'             {''Confirm'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Confirm''); }, icon:path+''Confirm.gif'', title:''Confirm Participant'' } }, '||chr(10)||
'             {''Email Link to this Object'':{ oncli';

c1:=c1||'ck:function(menuItem,menu) { ProccessRightClick($(this),''EmailLink''); }, icon:path+''EmailLink.gif'', title:''Email Link to this Object'' } }, '||chr(10)||
'             {''Submit Help Desk Ticket'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Ticket''); }, icon:path+''AskForHelp.gif'', title:''Submit Help Desk Ticket'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Launch VLT'':{ onclick:fu';

c1:=c1||'nction(menuItem,menu) { ProccessRightClick($(this),''VLT''); }, icon:path+''VLT.gif'', title:''Launch VLT'' } }, '||chr(10)||
'             {''View Associated Activities'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Activities''); }, icon:path+''ViewAssociatedActivities.gif'', title:''View Associated Activities'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Keep On Top of Recent Cache'':{ o';

c1:=c1||'nclick:function(menuItem,menu) { ProccessRightClick($(this),''Keep''); }, icon:path+''KeepOnTopofRecentCache.gif'', title:''Keep On Top of Recent Cache'' } }, '||chr(10)||
'             {''Undo Keep On Top of Recent Cache'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''UnKeep''); }, icon:path+''UndoKeepOnTopofRecentCache.gif'', title:''Undo Keep On Top of Recent Cache'' } }, '||chr(10)||
'             {''Remove from Re';

c1:=c1||'cent Cache'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''RemoveRecent''); }, icon:path+''RemoveRecent16.gif'', title:''Remove from Recent Cache'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Clone'':{ onclick:function(menuItem,menu) { ProccessRightClick($(this),''Clone''); }, icon:path+''clone.gif'', title:''Clone'' } }, '||chr(10)||
'             $.contextMenu.separator,'||chr(10)||
'             {''Ca';

c1:=c1||'ncel'':{ onclick:function(menuItem,menu) { return true;  }, title:''Cancel'' } } '||chr(10)||
'            ]; '||chr(10)||
''||chr(10)||
'function CheckAccess(pObj)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Check_Access'','||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pObj);'||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function IsRe';

c1:=c1||'cent()'||chr(10)||
'{'||chr(10)||
' var vRankingFound = false;'||chr(10)||
' vRankColumnNum = 0'||chr(10)||
''||chr(10)||
' $(''.apexir_WORKSHEET_DATA'').find(''th'').each(function() '||chr(10)||
'  {'||chr(10)||
'   vRankColumnNum++;'||chr(10)||
''||chr(10)||
'   if($(this).text()==''Ranking'')'||chr(10)||
'     {'||chr(10)||
'      vRankingFound = true;'||chr(10)||
'      return false;'||chr(10)||
'     }'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' return vRankingFound;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetRankValue(pThis, pRankColumnNum)'||chr(10)||
'{'||chr(10)||
' var currentCol = 0;'||chr(10)||
' var vRankValue = "0";'||chr(10)||
''||chr(10)||
' pThis = $(pThis).parent();'||chr(10)||
''||chr(10)||
' $(pThis).';

c1:=c1||'find(''td'').each(function() '||chr(10)||
'  {'||chr(10)||
'   currentCol++;'||chr(10)||
'   if(currentCol==pRankColumnNum)'||chr(10)||
'     {'||chr(10)||
'      vRankValue = $(this).text();'||chr(10)||
'      return false;'||chr(10)||
'     }'||chr(10)||
'  });'||chr(10)||
''||chr(10)||
' return $.trim(vRankValue.toString());'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function HideShowItems(pThis, pMenu)'||chr(10)||
'{'||chr(10)||
' var vSID = GetSidFromOpenLink($(pThis));'||chr(10)||
' var vObjType = GetObjectTypeCode(vSID);'||chr(10)||
' var vIsRecent = IsRecent();'||chr(10)||
' var vRank;'||chr(10)||
' var vSeperatorCounter = 1;'||chr(10)||
' var vRe';

c1:=c1||'moveCloneSeperator = false;'||chr(10)||
''||chr(10)||
' if(vIsRecent==true)'||chr(10)||
'   vRank = GetRankValue(pThis, vRankColumnNum);'||chr(10)||
' '||chr(10)||
' $(pMenu).find(''.context-menu-item'').each(function() '||chr(10)||
'  {'||chr(10)||
'   $(this).removeClass("context-menu-item-hidden");'||chr(10)||
'   $(this).removeClass("context-menu-item-disabled");'||chr(10)||
'   switch ($(this).prop(''title''))'||chr(10)||
'         {'||chr(10)||
'                                     case ''Clone'':'||chr(10)||
'                                        ';

c1:=c1||'          if(vObjType.substring(0,4)!=''ACT.'')'||chr(10)||
'                                                    {'||chr(10)||
'                                                     $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                     vRemoveCloneSeperator = true;'||chr(10)||
'                                                    }'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'     ';

c1:=c1||'                  case ''Confirm Participant'':'||chr(10)||
'                                                  if(vObjType.substring(0,5)!=''PART.'')'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                  else'||chr(10)||
'                                                    {'||chr(10)||
'                                                     if(IsPa';

c1:=c1||'rticipantConfirmed(vSID)==''Y'')'||chr(10)||
'                                                       $(this).addClass("context-menu-item-hidden");'||chr(10)||
'                                                    }'||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                case ''View Associated Activities'':'||chr(10)||
'                                                  if(vObjType.substring(0,5)!=''FILE.'')'||chr(10)||
'                  ';

c1:=c1||'                                  $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'               case ''Keep On Top of Recent Cache'':'||chr(10)||
'                                                  if(vIsRecent==false || vRank=="999999.999999")'||chr(10)||
'                                                   $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'               ';

c1:=c1||'                                   break;'||chr(10)||
''||chr(10)||
'          case ''Undo Keep On Top of Recent Cache'':'||chr(10)||
'                                                  if(vIsRecent==false || vRank!="999999.999999")'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'                  case ''Remove from Recent Cache'':'||chr(10)||
' ';

c1:=c1||'                                                 if(vIsRecent==false)'||chr(10)||
'                                                    $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'                                                  break;'||chr(10)||
''||chr(10)||
'         }'||chr(10)||
'  }); '||chr(10)||
''||chr(10)||
''||chr(10)||
' $(pMenu).find(''.context-menu-separator'').each(function() '||chr(10)||
'  {'||chr(10)||
'   $(this).removeClass("context-menu-item-hidden");'||chr(10)||
'   $(this).removeClass("context-menu-i';

c1:=c1||'tem-disabled");'||chr(10)||
''||chr(10)||
'   if (vIsRecent==false && vSeperatorCounter==2)'||chr(10)||
'     $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'   if (vRemoveCloneSeperator==true && vSeperatorCounter==3)'||chr(10)||
'     $(this).addClass("context-menu-item-hidden");'||chr(10)||
''||chr(10)||
'  vSeperatorCounter++;'||chr(10)||
'  }); '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'$(document).on(''mouseenter'', ''.apexir_WORKSHEET_DATA'', attachMenu);'||chr(10)||
''||chr(10)||
'function attachMenu()'||chr(10)||
'{'||chr(10)||
' $(''.apexir_WORKSHEET_DATA td'').contextMenu(';

c1:=c1||'menu1, {'||chr(10)||
'     theme:''vista'', '||chr(10)||
'     beforeShow: function(t,e) '||chr(10)||
'               {'||chr(10)||
'                HideShowItems(t, $(this.menu));'||chr(10)||
'               } '||chr(10)||
'   }); '||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetObjectTypeCode(pSID)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=GET_OBJECT_TYPE_CODE'','||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x0';

c1:=c1||'1'',pSID);'||chr(10)||
' '||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function GetConfirmStatusChangeSID(pSID)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=GET_CONFIRM_STATUS_CHANGE_SID'','||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pSID);'||chr(10)||
' '||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function IsPa';

c1:=c1||'rticipantConfirmed(pSID)'||chr(10)||
'{'||chr(10)||
' var get = new htmldb_Get(null,'||chr(10)||
'                          $v(''pFlowId''),'||chr(10)||
'                          ''APPLICATION_PROCESS=Is_Participant_Confirmed'', 	'||chr(10)||
'                          $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
' get.addParam(''x01'',pSID);'||chr(10)||
' '||chr(10)||
' gReturn = $.trim(get.get());'||chr(10)||
''||chr(10)||
' return gReturn;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
''||chr(10)||
'function GetSidFromOpenLink(pthis)'||chr(10)||
'{'||chr(10)||
' var startOfSid;'||chr(10)||
' var endOfSid;'||chr(10)||
' var vSID;'||chr(10)||
' var vTempStri';

c1:=c1||'ng;'||chr(10)||
''||chr(10)||
' while ($(pthis).prev().prop(''nodeName'')==''TD'')'||chr(10)||
'      pthis=$(pthis).prev();'||chr(10)||
'  '||chr(10)||
' vTempString = pthis.prop(''innerHTML'');'||chr(10)||
' startOfSid = vTempString.indexOf(''getObjURL('');'||chr(10)||
'  '||chr(10)||
' // Account for EMM //'||chr(10)||
' if(startOfSid==-1)'||chr(10)||
'   {'||chr(10)||
'    startOfSid = vTempString.indexOf('',name:'');'||chr(10)||
'    endOfSid = vTempString.indexOf(''\'',item_names'');'||chr(10)||
'    vSID = vTempString.substring(startOfSid+7,endOfSid);'||chr(10)||
'   }'||chr(10)||
' else'||chr(10)||
'   {'||chr(10)||
' ';

c1:=c1||'   endOfSid = vTempString.indexOf(''\'''');'||chr(10)||
'    vSID = vTempString.substring(startOfSid+11,endOfSid+9);'||chr(10)||
'   }'||chr(10)||
''||chr(10)||
' return vSID;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function ProccessRightClick(pthis,pMenuClicked)'||chr(10)||
'{'||chr(10)||
' var pSID = GetSidFromOpenLink(pthis);'||chr(10)||
' switch (pMenuClicked)'||chr(10)||
'       {'||chr(10)||
'                       case ''Activities'':'||chr(10)||
'                                         if (CheckAccess(pSID)=="Y")'||chr(10)||
'                                           r';

c1:=c1||'unJQueryPopWin(''Associated Activities'', ''P0_OBJ,P10150_DIALOG'', pSID+'',Y'', ''10150'');'||chr(10)||
'                                         else'||chr(10)||
'                                           alert(''You are not authorized to view this files associated activities.'');'||chr(10)||
''||chr(10)||
'                                         break;'||chr(10)||
' '||chr(10)||
'                            case ''Clone'':'||chr(10)||
'                                         if (CheckAccess(p';

c1:=c1||'SID)=="Y")'||chr(10)||
''||chr(10)||
'                                           runJQueryPopWin (''Status'', pSID, ''CloneIt'');'||chr(10)||
''||chr(10)||
'                                         else'||chr(10)||
''||chr(10)||
'                                           alert(''You are not authorized to Clone this Activity.'');'||chr(10)||
''||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                          case ''Confirm'':'||chr(10)||
'                                         var vStatusChangeSI';

c1:=c1||'D = GetConfirmStatusChangeSID(pSID);'||chr(10)||
''||chr(10)||
'                                         if(vStatusChangeSID==''not found'')'||chr(10)||
'                                           alert(''Proper Status could not be found, cannot Confirm from here.'');'||chr(10)||
'                                         else'||chr(10)||
'                                           {'||chr(10)||
'                                            if (CheckAccess(pSID)=="Y")'||chr(10)||
''||chr(10)||
'          ';

c1:=c1||'                                    runJQueryPopWin (''Status'', pSID, vStatusChangeSID);'||chr(10)||
''||chr(10)||
'                                            else'||chr(10)||
''||chr(10)||
'                                              alert(''You are not authorized to Confirm this Participant.'');'||chr(10)||
'                                           }'||chr(10)||
''||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                             case ''Keep'':'||chr(10)||
'                ';

c1:=c1||'           case ''UnKeep'':'||chr(10)||
'                     case ''RemoveRecent'':'||chr(10)||
'                                         var get = new htmldb_Get(null,'||chr(10)||
'                                                                  $v(''pFlowId''),'||chr(10)||
'                                                                  ''APPLICATION_PROCESS=KeepUnkeepRemove_From_Recent_Objects'','||chr(10)||
'                                                     ';

c1:=c1||'             $v(''pFlowStepId''));  '||chr(10)||
''||chr(10)||
'                                         get.addParam(''x01'',pSID);'||chr(10)||
'                                         get.addParam(''x02'',pMenuClicked);'||chr(10)||
'                                         get.addParam(''x03'',''&USER_SID.'');'||chr(10)||
'                                         gReturn = $.trim(get.get());'||chr(10)||
'                                         window.location.reload();'||chr(10)||
'          ';

c1:=c1||'                               break;'||chr(10)||
''||chr(10)||
'                           case ''Ticket'':'||chr(10)||
'                                         var itemValues = pSID+'',,''+''&APP_PAGE_ID.''+'',''+pSID;'||chr(10)||
'                                         runJQueryPopWin(''Submit Help Desk Ticket'',''P0_OBJ,P0_OBJ_CONTEXT,P775_LOCATION,P775_OBJECT'',itemValues,''775'');'||chr(10)||
'                                         break;'||chr(10)||
'             '||chr(10)||
'           ';

c1:=c1||'                   case ''VLT'':'||chr(10)||
'                                         newWindow({page:5550,clear_cache:''5550'',name:''VLT''+pSID,item_names:''P0_OBJ'',item_values:pSID,request:''OPEN''});'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                        case ''EmailLink'':'||chr(10)||
'                                         //openLocator(''301'',''P5000_PERSONNEL'',''Y'','''',''OPEN'','''','''',''Choose Personnel...'',''PERS';

c1:=c1||'ONNEL'',''&P0_OBJ.'');'||chr(10)||
'                                         //openLocator(''301'','''',''Y'','''',''OPEN'','''','''',''Choose Personnel...'',''PERSONNEL'',''&P0_OBJ.'');'||chr(10)||
'                                         runJQueryPopWin(''Email Link to this Object'', pSID, ''770'');'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'                                 default:'||chr(10)||
'                                         alert(pMenuClicke';

c1:=c1||'d+''=''+pSID);'||chr(10)||
'                                         break;'||chr(10)||
''||chr(10)||
'       }'||chr(10)||
'}'||chr(10)||
'</script>'||chr(10)||
'<!-- Right Click Menu Code END -->'||chr(10)||
''||chr(10)||
'<!-- Allows Resizing of Report Column Drop-downs -->'||chr(10)||
'<script type=''text/javascript''>'||chr(10)||
'$(function()'||chr(10)||
'{  '||chr(10)||
' $("#apexir_rollover").resizable({minWidth:$("#apexir_rollover").width(), handles:"e", start:function(e,u){document.body.onclick="";},stop:function(e,u){$(this).css({"height":""})';

c1:=c1||'; setTimeout(function(){document.body.onclick=gReport.dialog.check;},100);}}).css({"z-index":9999}).children(".ui-resizable-e").css({"background":"#EFEFEF"});'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
''||chr(10)||
'#HEAD#'||chr(10)||
'<link rel="shortcut icon" href="#IMAGE_PREFIX#themes/OSI/i2ms.ico">'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#'||chr(10)||
'</body>'||chr(10)||
'<script type="text/javascript">'||chr(10)||
'$(document).ready(function() '||chr(10)||
'{'||chr(10)||
' initNav();'||chr(10)||
' $("div.tooltip").tipsy({live: true, fade: true, gravity: "n", title: "tip"});'||chr(10)||
'});'||chr(10)||
'</script>'||chr(10)||
'</html>';

c3:=c3||'<table class="bannerTable" width="100%" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'   <tr>'||chr(10)||
'      <td class="bannerLogo" width="30%">&nbsp;</td>'||chr(10)||
'      <td align="center" class="bannerLogo" width="40%">'||chr(10)||
'      <img height="35px" src="#IMAGE_PREFIX#themes/OSI/osi_object_banner.gif"/></td>'||chr(10)||
'      '||chr(10)||
'       <td class="navBar" width="30%">'||chr(10)||
'         <table cellpadding="0" cellspacing="0" border="0" summary=';

c3:=c3||'"" align="right">'||chr(10)||
'            <tr>'||chr(10)||
'               <td><a href="&USER_URL.">&APP_USER.</a></td>'||chr(10)||
'               <td>#NAVIGATION_BAR#</td>'||chr(10)||
'            </tr>'||chr(10)||
'         </table>'||chr(10)||
'      </td> '||chr(10)||
''||chr(10)||
'   </tr>'||chr(10)||
'   <tr><td colspan="3">'||chr(10)||
'      <table width=100% cellpadding="0" cellspacing="0">'||chr(10)||
'  <tr>'||chr(10)||
'   <td width=100% class="underbannerbar" style="color:#e10505;text-align: center;">'||chr(10)||
'             &OSI_BANNER.&nbsp;'||chr(10)||
' ';

c3:=c3||'  </td>'||chr(10)||
'  </tr>'||chr(10)||
'   </table></td>'||chr(10)||
'   </tr>'||chr(10)||
'</table>'||chr(10)||
'<table summary="main content" class="dtMain">'||chr(10)||
'  <tr><td colspan="2">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</td></tr>'||chr(10)||
'  <tr><td colspan="2" class="dtMenuBar">#REGION_POSITION_06#</td></tr>'||chr(10)||
'  <tr class="dtMain">'||chr(10)||
'    <td class="dtSidebarList">#REGION_POSITION_02#</td>'||chr(10)||
'    <!--div style="clear:both;"-->'||chr(10)||
'    <td class="dtReportReg';

c3:=c3||'ion">#BOX_BODY#</td>'||chr(10)||
'    <!--/div-->'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<div class="versionDiv">I2MS &OSI_VERSION.</div>';

wwv_flow_api.create_template(
  p_id=> 92011431286949262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Desktop',
  p_body_title=> '<!--#BODY_TITLE#-->',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="dtSuccess">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="dtNotification">#MESSAGE#</div>',
  p_navigation_bar=> '<table cellpadding="1" cellspacing="2" border="0"  class="t9navbar"><tr><td valign="top"><img src="#IMAGE_PREFIX#themes/theme_9/separator.png"/>'||chr(10)||
'</td>#BAR_BODY#</tr></table>',
  p_navbar_entry=> '<td valign="top"><a href="#LINK#">#TEXT#</a></td><td valign="top">'||chr(10)||
'<img src="#IMAGE_PREFIX#themes/theme_9/separator.png"/>'||chr(10)||
'</td>'||chr(10)||
'',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 101,
  p_theme_class_id => 3,
  p_template_comment => '14-Oct-2011 Tim Ward - CR#3754-CFunds Expense Desktop View Description too large.'||chr(10)||
'                       Added JQuery/Tipsy Stuff to Header.'||chr(10)||
'14-Nov-2011 Tim Ward - Added Javascript to Header to allow resizing of report column'||chr(10)||
'                       drop-downs.'||chr(10)||
'15-May-2012 Tim Ward - CR#3975 - Added JQuery/Superfish Menu JS/CSS coding.'||chr(10)||
'27-Aug-2012 Tim Ward - Changed Helpdesk ticket to use jQuery Dialog instead of browser'||chr(10)||
'                        pop-up.'||chr(10)||
'28-Aug-2012 Tim Ward - Changed Associated Activities to use 10150 instead of 10155.'||chr(10)||
'05-Oct-2012 Tim Ward - CR#4118 - Right Click Issues on EMM.');
end;
 
null;
 
end;
/

COMMIT;

