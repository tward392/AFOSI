-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_util as
/******************************************************************************
   Name:     OSI_UTIL
   Purpose:  Provides utility functions.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    23-APR-2009 T.Whitehead    Created package.
    07-MAY-2009 T.McGuffin     Added Address utilities (GET_ADDR_FIELDS, GET_ADDR_DISPLAY,
                               UPDATE_ADDRESS, INSERT_ADDRESS)
    16-may-2009 T.Whitehead    Added parse_size from OSI_ATTACHMENT.
    20-MAY-2009 T.McGuffin     Removed get_edit_link.
    22-May-2009 T.McGuffin     Modified insert_address to remove the obj_context.
    10-Jun-2009 R.Dibble       Added get_checklist_buttons
    25-Jun-2009 T.McGuffin     Added new update_single_address procedure which ties together insertion and
                               updating of an address, if either are applicable.
    29-Jul-2009 T.Whitehead    Moved get_mime_icon into this package.
    30-Nov-2009 T.Whitehead    Added get_report_links.
    29-Dec-2009 T.Whitehead    Added do_title_substitution.
    04-Jan-2010 T.Whitehead    Added procedure aitc that calls core_util.append_info_to_clob.
    16-Feb-2010 T.McGuffin     Added display_precision_date function.
    25-Mar-2010 T.Whitehead    Copied blob_to_clob, blob_to_hex, clob_to_clob, decapxml, encapxml
                               and hex_to_blob from I2MS.
    14-Jun-2010 J.Faris        Added show_tab function.
    12-Jul-2010 R.Dibble       Added encrypt_md5hex (copied from CORE_CONTEXT and made public)
    02-Mar-2011 Tim Ward       CR#3705 - Added WordWrapFunc.
    04-Oct-2011 Tim Ward       CR#3919 - Add Report Printing for Activities from the File/Activity Associations sreen.
                                Added get_report_menu.
    
******************************************************************************/
    procedure aitc(p_clob in out nocopy clob, p_text varchar2);

    function blob_to_clob(p_blob in blob)
        return clob;

    function blob_to_hex(p_blob in blob)
        return clob;

    function clob_to_blob(p_clob in clob)
        return blob;

    function decapxml(p_blob in blob, p_tag in varchar2)
        return blob;

    function encapxml(p_blob in blob)
        return blob;

    function hex_to_blob(p_blob in blob)
        return blob;

    function hex_to_blob(p_clob in clob)
        return blob;

    /*
     * Replaces any ~COLUMN_NAME~ items with values from table or view name p_tv_name.
     */
    function do_title_substitution(
        p_obj       in   varchar2,
        p_title     in   varchar2,
        p_tv_name   in   varchar2 := null)
        return varchar2;

    function get_mime_icon(p_mime_type in varchar2, p_file_name in varchar2)
        return varchar2;

    function get_report_links(p_obj in varchar2)
        return varchar2;

    function get_report_menu(p_obj in varchar2, p_justTemplate in varchar2 := 'Y')
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of statuses that an
--    object may currently go to
    function get_status_buttons(p_obj in varchar2)
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2)
        return varchar2;

--    The following functions all make reference to an address list.  This list uses core_list (squiggly-
--    delimited values) and contains all of the address fields in the following order:
--    ~ADDRESS1~ADDRESS2~CITY~STATE(sid)~ZIP~COUNTRY(sid)~

    --    Takes a number X and returns X bytes, X KB, X MB, or X GB.
    function parse_size(p_size in number)
        return varchar2;

    -- Given a date, displays in the precision imbedded in the seconds field of the date.
    function display_precision_date(p_date date)
        return varchar2;

    /* This function executes any object or object type specific code to show/hide page tabs */
    function show_tab(p_obj_type_code in varchar2, p_tab in varchar2, p_obj in varchar2 := null, p_context in varchar2 := null)
            return varchar2;
            
   /* Used to compare passwords for PASSWORD CHANGE SCREEN ONLY!!! */
   function encrypt_md5hex(p_clear_text in varchar2)
        return varchar2;

    function WordWrapFunc(pst$ in clob, pLength in Number, Delimiter in clob) return clob;

end osi_util;
/


CREATE OR REPLACE package body osi_util as
/******************************************************************************
   Name:     OSI_UTIL
   Purpose:  Provides utility functions.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    23-APR-2009 T.Whitehead    Created package.
    07-MAY-2009 T.McGuffin     Added Address utilities (GET_ADDR_FIELDS, GET_ADDR_DISPLAY,
                               UPDATE_ADDRESS, INSERT_ADDRESS)
    16-MAY-2009 T.Whitehead    Added PARSE_SIZE from OSI_ATTACHMENT.
    16-MAY-2009 T.McGuffin     Modified get_edit_link to use our &ICON_EDIT. image
    20-MAY-2009 T.McGuffin     Removed get_edit_link.
    21-May-2009 R.Dibble       Modified get_status_buttons to utilize 'ALL' status change types'
    22-May-2009 T.McGuffin     Modified insert_address to remove the obj_context.
    26-May-2009 R.Dibble       Modified get_status_buttons to handle object type 
                               specific status changes correctly and to use SEQ
    10-Jun-2009 R.Dibble       Added get_checklist_buttons
    25-Jun-2009 T.McGuffin     Added new update_single_address procedure which ties together insertion and
                               updating of an address, if either are applicable.
    29-Jul-2009 T.Whitehead    Moved get_mime_icon into this package.
    29-Oct-2009 R.Dibble       Modified get_status_buttons and get_checklist_buttons
                               to handle object type overrides
    30-Nov-2009 T.Whitehead    Added get_report_links.
    29-Dec-2009 T.Whitehead    Added do_title_substitution.
    04-Jan-2010 T.Whitehead    Added procedure aitc that calls core_util.append_info_to_clob.
    16-Feb-2010 T.McGuffin     Added display_precision_date function.
    25-Mar-2010 T.Whitehead    Copied blob_to_clob, blob_to_hex, clob_to_clob, decapxml, encapxml
                               and hex_to_blob from I2MS.
    1-Jun-2010  J.Horne        Updated get_report_links so that if statement compares disabled_status
                               to v_status_codes correctly.
    14-Jun-2010 J.Faris        Added show_tab function.
    12-Jul-2010 R.Dibble       Added encrypt_md5hex (copied from CORE_CONTEXT and made public)
    24-Aug-2010 J.Faris        Updated get_status_buttons, get_checklist_buttons to include status change 
                               overrides tied to a "sub-parent" (like ACT.CHECKLIST).
    15-Nov-2010 R.Dibble       Incorporated Todd Hughsons change to get_report_links() to handle
                                the new report link dropdown architecture                           
    16-Feb-2011 Tim Ward       CR#3697 - Fixed do_title_substitution to not lock up if there is
                                a ~ typed in the Title somewhere.                           
    02-Mar-2011 Tim Ward       CR#3705 - Added an else in the Case of get_report_links to support .txt mime type.
    02-Mar-2011 Tim Ward       CR#3705 - Added WordWrapFunc.
    04-Oct-2011 Tim Ward       CR#3919 - Add Report Printing for Activities from the File/Activity Associations sreen.
                                Added get_report_menu.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_UTIL';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    procedure aitc(p_clob in out nocopy clob, p_text varchar2) is
    begin
        core_util.append_info_to_clob(p_clob, p_text, '');
    end aitc;
    
    function blob_to_clob(p_blob in blob)
        return clob is
        --Used to convert a Blob to a Clob
        v_clob          clob;
        v_blob_length   integer;
        v_blob_chunk    raw(1024);
        v_blob_byte     raw(1);
        v_chunk_size    integer   := 1024;
    begin
        dbms_lob.createtemporary(v_clob, true, dbms_lob.session);
        v_blob_length := dbms_lob.getlength(p_blob);

        for i in 0 .. floor(v_blob_length / v_chunk_size) - 1
        loop
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_clob, utl_raw.cast_to_varchar2(v_blob_chunk));
        end loop;

        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_clob, utl_raw.cast_to_varchar2(v_blob_byte));
        end loop;

        return v_clob;
    end;
    
    function blob_to_hex(p_blob in blob)
        return clob is
        --Used to convert a Raw Blob into a Hex Clob
        v_clob          clob;
        v_blob_length   integer;
        v_blob_chunk    raw(1024);
        v_blob_byte     raw(1);
        v_chunk_size    integer   := 1024;
    begin
        dbms_lob.createtemporary(v_clob, true, dbms_lob.session);
        v_blob_length := dbms_lob.getlength(p_blob);

        for i in 0 .. floor(v_blob_length / v_chunk_size) - 1
        loop
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_clob, rawtohex(v_blob_chunk));
        end loop;

        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_clob, rawtohex(v_blob_byte));
        end loop;

        return v_clob;
    end;
    
    -- Used to convert a Clob to a Blob. Richard D.
    function clob_to_blob(p_clob in clob)
        return blob
    is
        v_pos       pls_integer    := 1;
        v_buffer    raw(32767);
        v_return    blob;
        v_lob_len   pls_integer    := dbms_lob.getlength(p_clob);
        --WAS pls_integer
        v_err       varchar2(4000);
    begin
        dbms_lob.createtemporary(v_return, true);
        dbms_lob.open(v_return, dbms_lob.lob_readwrite);

        loop
            v_buffer := utl_raw.cast_to_raw(dbms_lob.substr(p_clob, 16000, v_pos));

            if utl_raw.length(v_buffer) > 0 then
                dbms_lob.writeappend(v_return, utl_raw.length(v_buffer), v_buffer);
            end if;

            v_pos := v_pos + 16000;
            exit when v_pos > v_lob_len;
        end loop;

        return v_return;
    exception
        when others then
            v_err := sqlerrm;
            return v_return;
    end clob_to_blob;
    
    function decapxml(p_blob in blob, p_tag in varchar2)
        return blob is
        v_output            blob           := null;
        v_work              blob           := null;
        v_err               varchar2(4000);
        v_length_to_parse   integer;
        v_offset            integer;
        v_pattern           raw(2000);
        --V_RAW               raw (32767);
        v_blob_length       integer;
        v_blob_chunk        raw(1024);
        v_blob_byte         raw(1);
        v_chunk_size        integer        := 1024;
    begin
        --Get LENGTH we need to keep
        v_pattern := utl_raw.cast_to_raw('</' || p_tag || '>');
        v_length_to_parse := dbms_lob.instr(p_blob, v_pattern) -(2 * 1) -(2 * length(p_tag));
        --Get OFFSET point that we need to keep
        v_pattern := utl_raw.cast_to_raw('<' || p_tag || '>');
        v_offset := dbms_lob.instr(p_blob, v_pattern) + length(p_tag) + 3;
        --Capture input
        v_work := p_blob;
        v_blob_length := v_length_to_parse;

        --Create a temporary clob
        if v_output is null then
            dbms_lob.createtemporary(v_output, true);
        end if;

        --Grab the contents in large chunks (currently 1024bytes) and convert it
        --Floor is similiar to RoundDown(x)
        for i in 0 .. floor((v_blob_length) / v_chunk_size) - 1
        loop
            --Get 1K of the lob (After the offset)
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, v_offset +(i * v_chunk_size) + 1);
            dbms_lob.append(v_output, v_blob_chunk);
        end loop;

        --Anything left after the chunks (the remainder 1023Bytes or <'er)
        --Handle in 1 byte chunks.. Not doing hex/raw conversion here so that is fine
        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_output, v_blob_byte);
        end loop;

        return v_output;
    exception
        when others then
            v_err := sqlerrm;
            return v_output;
    end decapxml;
    
    function encapxml(p_blob in blob)
        return blob is
        v_cr       varchar2(10) := chr(13) || chr(10);
        v_return   clob;
    begin
        --Convert to Clob
        --V_WORK := blob_to_clob(P_BLOB);

        --Opening Tag(s)
        core_util.append_info_to_clob(v_return, '<XML>' || v_cr || '  <ATTACHMENT>' || v_cr);
        --V_RETURN := '<XML>' || V_CR || '  <ATTACHMENT>' || V_CR;

        --Rest of Blob
        v_return := v_return || blob_to_hex(p_blob);
        --Closing Tag(s)
        core_util.append_info_to_clob(v_return, v_cr || '  </ATTACHMENT>' || v_cr || '</XML>' || v_cr, '');
        --V_RETURN := V_RETURN || '<XML>' || V_CR || '  <ATTACHMENT>' || V_CR;
        return clob_to_blob(v_return);
    end encapxml;
    
    function hex_to_blob(p_blob in blob)
        return blob is
    --Used to convert a hex blob into a raw blob
    begin
        return hex_to_blob(blob_to_clob(p_blob));
    end;

    function hex_to_blob(p_clob in clob)
        return blob is
        --Used to convert a Hex Clob into a Raw Blob
        v_blob                         blob;
        v_clob_length                  integer;
        v_clob_chunk                   varchar2(1024);
        v_clob_hex_byte                varchar2(2);
        v_chunk_size                   integer        := 1024;
        v_remaining_characters_start   integer;
    begin
        dbms_lob.createtemporary(v_blob, true, dbms_lob.session);
        v_clob_length := dbms_lob.getlength(p_clob);

        for i in 0 .. floor(v_clob_length / v_chunk_size) - 1
        loop
            v_clob_chunk := dbms_lob.substr(p_clob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_blob, hextoraw(v_clob_chunk));
            dbms_output.put_line('HEX_TO_BLOB - CHUNKS: ' || v_clob_chunk);
        end loop;

        v_remaining_characters_start :=(floor(v_clob_length / v_chunk_size) * v_chunk_size + 1);

        while v_remaining_characters_start < v_clob_length
        loop
            v_clob_hex_byte := dbms_lob.substr(p_clob, 2, v_remaining_characters_start);
            dbms_output.put_line('HEX_TO_BLOB - BYTES: ' || v_clob_hex_byte);
            dbms_lob.append(v_blob, hextoraw(v_clob_hex_byte));
            v_remaining_characters_start := v_remaining_characters_start + 2;
        end loop;

        return v_blob;
    end;
    
    function do_title_substitution(p_obj in varchar2, p_title in varchar2, p_tv_name in varchar2 := null)
        return varchar2 is
        v_caret     integer        := 0;
        v_title     varchar2(4000);
        v_rtn       varchar2(4000);
        v_value     varchar2(1000);
        v_item_og   varchar2(128);
        v_format    varchar2(30);
        v_item      varchar2(4000);
    begin
        v_title := p_title;
        v_rtn := v_title;

        for i in (SELECT column_value FROM TABLE(SPLIT(v_title,'~')) where column_value is not null)
        loop
            v_item := i.column_value;
            
            v_caret := instr(v_item, '^');
            if (v_caret > 0) then

              -- Save the item before separating the date format from the column name. --
              v_item_og := i.column_value;
              v_format := substr(v_item, v_caret + 1, length(v_item) - v_caret);
              v_item := substr(v_item, 1, v_caret - 1);
                  
            end if;

            -- See if the item is activity data. --
            begin
                 execute immediate 'select ' || v_item || ' from v_osi_title_activity '
                                  || ' where sid = ''' || p_obj || ''''
                             into v_value;
            exception
                when others then
                    begin
                        -- See if the item is participant data.
                        execute immediate 'select name from v_osi_title_partic '
                                          || ' where sid = ''' || p_obj || ''''
                                          || ' and upper(code) = upper(''' || v_item || ''')'
                                          || ' and rownum = 1'
                                     into v_value;
                    exception
                        when others then
                            -- If the item was neither see if a table or view name was
                            -- given and check it.
                            if (p_tv_name is not null) then
                               begin
                                    execute immediate 'select ' || v_item || ' from ' || p_tv_name
                                                  || ' where sid = ''' || p_obj || ''''
                                             into v_value;
                                exception
                                    when others then
                                        null; -- No replace will be made.
                                end;
                            end if;
                    end;
            end;

            -- If there was a date format, apply it now.
            if (v_caret > 0) then
 
              v_value := to_char(to_date(v_value, v_format), v_format);
              -- Get the original item for the replacement step.
              v_item := v_item_og;

            end if;
                
            -- Do the actual replacement.
            if (v_value is not null) then

              v_rtn := replace(v_rtn, '~' || v_item || '~', v_value);
              v_value := null;

            end if;

        end loop;

        return v_rtn;

    exception
        when others then
            log_error('do_title_substitution: ' || sqlerrm);
            raise;
    end do_title_substitution;

    function get_mime_icon(p_mime_type in varchar2, p_file_name in varchar2)
        return varchar2 is
        v_temp   varchar2(100) := null;
        v_mime   varchar2(500) := p_mime_type;
        v_file   varchar2(500) := p_file_name;
    begin
        begin
            if v_file is not null then
                while v_file <> regexp_substr(v_file, '[[:alnum:]]*')
                loop
                    v_file := regexp_substr(v_file, '[.].*');
                    v_file := regexp_substr(v_file, '[[:alnum:]].*');
                end loop;

                v_file := '.' || v_file;

                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper(v_file) and rownum = 1;
            end if;
        exception
            when no_data_found then
                if v_temp is null and v_mime is null then
                    select image
                      into v_temp
                      from t_core_mime_image
                     where upper(mime_or_file_extension) = upper('exe') and rownum = 1;
                end if;
        end;

        begin
            if v_mime is not null then
                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper(v_mime) and rownum = 1;
            end if;
        exception
            when no_data_found then
                -- Can't find an icon for this type so give it the default.
                --if v_temp is null and v_file is null then
                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper('exe') and rownum = 1;
        --end if;
        end;

        return v_temp;
    end get_mime_icon;

    function get_report_links(p_obj in varchar2)
        return varchar2 is
        v_rtn           varchar2(5000);
        v_auto_run      varchar2(1);
        v_status_code   t_osi_status.code%type;
    begin
        v_status_code := osi_object.get_status_code(p_obj);

        for a in (select   rt.description, rt.sid, rt.disabled_status, mt.file_extension
                      from t_osi_report_type rt, t_osi_report_mime_type mt
                     where (rt.obj_type member of osi_object.get_objtypes(p_obj)
                            or rt.obj_type = core_obj.lookup_objtype('ALL'))
                           and rt.active = 'Y'
                           and rt.mime_type = mt.sid(+)
                  order by rt.seq asc)
        loop
            begin
                select 'N'
                  into v_auto_run
                  from t_osi_report_type
                 where sid = a.sid
                   and active = 'Y'
                   and (   pick_dates = 'Y'
                        or pick_narratives = 'Y'
                        or pick_notes = 'Y'
                        or pick_caveats = 'Y'
                        or pick_dists = 'Y'
                        or pick_classification = 'Y'
                        or pick_attachment = 'Y'
                        or pick_purpose = 'Y'
                        or pick_distribution = 'Y'
                        or pick_igcode = 'Y'
                        or pick_status = 'Y');
            exception
                when no_data_found then
                    v_auto_run := 'Y';
            end;

            v_rtn := v_rtn || '~' || a.description || '~';

             if (a.disabled_status is not null and a.disabled_status like '%' || v_status_code || '%') then
                v_rtn := v_rtn || 'javascript:alert(''Report unavailable in the current status.'');';
            else
                if(v_auto_run = 'Y')then
                    case lower(a.file_extension)
                        when '.rtf' then
                            -- This link will run a report that an application will load outside of the browser.
                            v_rtn := v_rtn || 'javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::'
                                     || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || a.sid || ',' || p_obj || ''');';
                        when '.html' then
                            -- This javascript creates a new browser window for page 805 to show a report in.
                            v_rtn := v_rtn || 'javascript:launchReportHtml(''' || p_obj || ''');';

                        else
                            -- This link will run a report that an application will load outside of the browser.
                            v_rtn := v_rtn || 'javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::'
                                     || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || a.sid || ',' || p_obj || ''');';
                    end case;    
                else
                    -- This javascript launches a page with an interface to modify the report before creating it.
                    v_rtn := v_rtn || 'javascript:launchReportSpec(''' || a.sid || ''',''' || p_obj || ''');';
                end if;
            end if;
        end loop;

        return v_rtn || '~';
    end get_report_links;

    /*************************************************************************************************************/
    /*  get_report_menu - Build the Reports Dropdown menu just as it appears on every apex page.                 */
    /*************************************************************************************************************/
    function get_report_menu(p_obj in varchar2, p_justTemplate in varchar2 := 'Y') return varchar2 is
        v_links         varchar2(5000);
        v_rtn           varchar2(5000);
        v_cnt           number := 1;
        v_description   varchar2(5000);
        v_msg           varchar2(5000);
    begin
         /*************************************************************************************************************/
         /*  p_JustTemplate - Using 'Y' from Apex Page 10150 for Speed of retrieval.  Then when the user presses      */
         /*                    the down arrow to show reports, we call this with 'N' to get just the list of Reports. */
         /*************************************************************************************************************/
         v_rtn := '';
         if p_justTemplate = 'N' then
           
           if osi_auth.check_access(p_obj)='N' then
  
             v_msg:=osi_auth.check_access(p_obj=>p_obj, p_get_message=>true);
             return '<li>' || v_msg || '</li>';

           end if;
           
           v_links := get_report_links(p_obj);
           
           for a in (select * from table(split(v_links,'~')) where column_value is not null)
           loop
               if mod(v_cnt, 2) = 0 then

                 v_rtn := v_rtn || '<li><a href="javascript:void(0)" onclick="' || a.column_value || ' return false;" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">' || v_description || '</a></li>';
               
               else
               
                 v_description := a.column_value;
                
               end if;
               v_cnt := v_cnt + 1;
             
           end loop;
           return v_rtn;
         
         else

           v_rtn := '<ul class="dhtmlMenuLG2"><li class="dhtmlMenuItem1"><a>Reports</a><img src="/i/themes/theme_13/menu_small.gif" alt="Expand" onclick="GetAndOpenMenu(event, this,' || '''' || 'L' || p_obj || '''' || ',false)" style="cursor: pointer;"/></li><ul id="L' || p_obj || '" htmldb:listlevel="2" class="dhtmlSubMenu2" style="display:none;">';
           v_rtn := v_rtn || '</ul></ul>';
           
         end if;
         

         return v_rtn;
         
    end get_report_menu;
    
--    This function is used to return a squigly deliminted list (~) of statuses that an
--    object may currently go to
    function get_status_buttons(p_obj in varchar2)
        return varchar2 is
        v_rtn           varchar2(1000);
        v_obj_type      varchar2(20);
        v_obj_subtype   varchar2(20);
   
    begin
        --Get the object type
        v_obj_type := core_obj.get_objtype(p_obj);

        --Get distinct list of next possiible TO statuses
        ----Then check to see if there are any checklists tied to them

        --Get the button sids, etc.
        for i in (select osc.button_label, osc.sid, osc.from_status, osc.to_status
                    from v_osi_status_change osc
                   where (   from_status = osi_object.get_status_sid(p_obj)
                          or from_status_code = 'ALL')
                     and (   obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
          or obj_type = core_obj.lookup_objtype('ALL')
                     )and button_label is not null
                     and osc.active = 'Y'
                     
                     and osc.code not in(
                
                     select code
                          from v_osi_status_change osc2 
                         where ((obj_type = core_obj.get_objtype(p_obj) and override = 'Y')
                               /* updated 8.24.10 to include status change overrides tied to a "sub-parent" (like ACT.CHECKLIST) */ 
                                or
                               (obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                           and override = 'Y'))  and
                        
                           osc.sid <> osc2.sid
                           )
                           
                     order by SEQ desc)
        loop

            v_rtn := v_rtn || '~' || i.button_label || '~' || i.sid;

        end loop;

        return v_rtn || '~';
    end get_status_buttons;
    
--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2)
              return varchar2 is
        v_rtn           varchar2(1000);
        v_obj_type      varchar2(20);
        v_obj_subtype   varchar2(20);
             v_cnt   number;
    begin
        --Get the object type
        v_obj_type := core_obj.get_objtype(p_obj);

        --Get the button sids, etc.
        for i in (select osc.checklist_button_label, osc.sid
                    from v_osi_status_change osc
                   where (   from_status = osi_object.get_status_sid(p_obj)
                         or from_status_code = 'ALL')
                     and (   obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
          or obj_type = core_obj.lookup_objtype('ALL'))
           and osc.active = 'Y'
          and osc.code not in(
                
                     select code
                          from v_osi_status_change osc2 
                         where ((obj_type = core_obj.get_objtype(p_obj) and override = 'Y')
                               /* updated 8.24.10 to include status change overrides tied to a "sub-parent" (like ACT.CHECKLIST) */ 
                                or
                               (obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                           and override = 'Y'))  and
                        
                           osc.sid <> osc2.sid
                           )
                           
                     order by SEQ desc)
        loop
            select count(sid) 
            into v_cnt 
            from t_osi_checklist_item_type_map 
            where status_change_sid = i.sid;
        
        if (v_cnt >0) then
            v_rtn := v_rtn || '~' || i.checklist_button_label || '~' || i.sid;
        end if;
            v_cnt := 0;
        end loop;

        return v_rtn || '~';
    end get_checklist_buttons;

    function parse_size(p_size in number)
        return varchar2 is
        v_size   number;
        v_rtn    varchar2(100) := null;
    begin
        if (p_size is null) then
            v_size := 0;
        else
            v_size := p_size;
        end if;

        if v_size >= 1024 then
            v_size := v_size / 1024;
        else
            v_rtn := v_size || ' Bytes';
        end if;

        if v_size >= 1024 then
            v_size := v_size / 1024;
        elsif v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' KB';
        end if;

        if v_size >= 1000 then
            v_size := v_size / 1000;
        elsif v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' MB';
        end if;

        if v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' GB';
        end if;

        return v_rtn;
    end parse_size;

    function display_precision_date(p_date date)
        return varchar2 is
    begin
        case to_char(p_date, 'ss')
            when '00' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_DAY'));
            when '01' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_MONTH'));
            when '02' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_YEAR'));
            when '03' then
                return to_char(p_date,
                               core_util.get_config('CORE.DATE_FMT_DAY') || ' '
                               || core_util.get_config('OSI.DATE_FMT_TIME'));
            else
                return p_date;
        end case;
    exception
        when others then
            log_error('display_precision_date: ' || sqlerrm);
    end display_precision_date;

    /* This function executes any object or object type specific code to show/hide individual tabs */
    function show_tab(p_obj_type_code in varchar2, p_tab in varchar2, p_obj in varchar2 := null, p_context in varchar2 := null)
                return varchar2 is
    v_result varchar2(1);

    begin
         if p_obj_type_code = 'ALL.REPORT_SPEC' then 
            --p_obj is null and p_context is a report_type sid
            v_result := osi_report_spec.show_tab(p_context, p_tab);
            return v_result;
         else
            return 'Y';
         end if;
    exception
         when others then
                log_error('show_tab: ' || sqlerrm);
    end;
    
    /* Used to compare passwords for PASSWORD CHANGE SCREEN ONLY!!! */
    function encrypt_md5hex(p_clear_text in varchar2)
        return varchar2 is
        v_b64   varchar2(16);
        v_b16   varchar2(32);
        i       integer;
        c       integer;
        h       integer;
    begin
        v_b64 := dbms_obfuscation_toolkit.md5(input_string => p_clear_text);

        -- convert result to HEX:
        for i in 1 .. 16
        loop
            c := ascii(substr(v_b64, i, 1));
            h := trunc(c / 16);

            if h >= 10 then
                v_b16 := v_b16 || chr(h + 55);
            else
                v_b16 := v_b16 || chr(h + 48);
            end if;

            h := mod(c, 16);

            if h >= 10 then
                v_b16 := v_b16 || chr(h + 55);
            else
                v_b16 := v_b16 || chr(h + 48);
            end if;
        end loop;

        return lower(v_b16);
    end;

    Function WordWrapFunc(pst$ in clob, pLength in Number, Delimiter in clob) return clob is
  
      Cr$           varchar2(2) := chr(13);
      CrLF$         varchar2(4) := chr(13) || chr(10);
      NextLine$     clob := '';
      Text$         clob := '';
      l             number;
      s             number;
      c             number;
      Comma         number;
      DoneOnce      boolean;
      LineLength    number;
      st$           clob;
      DoneNow       number := 0;
      
    begin
         --- This function converts raw text into "Delimiter" delimited lines. ---
         st$ := ltrim(rtrim(pst$));
         LineLength := pLength + 1;
 
         while DoneNow=0
         loop
             l := nvl(length(NextLine$),0);
             s := InStr(st$, ' ');
             c := InStr(st$, Cr$);
             Comma := InStr(st$, ',');

             If c > 0 Then

               If l + c <= LineLength Then

                 Text$ := Text$ || NextLine$ || substr(st$,1,c);--   Left$(st$, c);
                 NextLine$ := '';
                 st$ := substr(st$, c + 1);-- Mid$(st$, c + 1);
                 GoTo LoopHere;

               End If;

             End If;
        
             If s > 0  Then

               If l + s <= LineLength Then

                 DoneOnce := True;
                 NextLine$ := NextLine$ || substr(st$, 1, s);-- Left$(st$, s);
                 st$ := substr(st$, s + 1);--Mid$(st$, s + 1)
           
               ElsIf s > LineLength Then
           
                    Text$ := Text$ || Delimiter || substr(st$,1,LineLength);-- Left$(st$, LineLength)
                    st$ := substr(st$, LineLength + 1); --Mid$(st$, LineLength + 1)
           
               Else
           
                 Text$ := Text$ || NextLine$ || Delimiter;
                 NextLine$ := '';

               End If;

             ElsIf Comma > 0 Then

                  If l + Comma <= LineLength Then

                    DoneOnce := True;
                    NextLine$ := NextLine$ || substr(st$, 1, Comma);-- Left$(st$, Comma)
                    st$ := substr(st$, Comma + 1); -- Mid$(st$, Comma + 1)

                  ElsIf s > LineLength Then

                        Text$ := Text$ || Delimiter || substr(st$, 1, LineLength);-- Left$(st$, LineLength)
                        st$ := substr(st$, LineLength + 1);-- Mid$(st$, LineLength + 1)
                        
                  Else

                    Text$ := Text$ || NextLine$ || Delimiter;
                    NextLine$ := '';

                  End If;

             Else
 
               If l > 0 Then
            
                 If l + nvl(Length(st$),0) > LineLength Then
            
                   Text$ := Text$ || NextLine$ || Delimiter || st$ || Delimiter;
            
                 Else
            
                   Text$ := Text$ || NextLine$ || st$ || Delimiter;
            
                 End If;

               Else

                 Text$ := Text$ || st$ || Delimiter;

               End If;

               DoneNow:=1;

             End If;

<<LoopHere>>
            null;
        
        end Loop;

        return Text$;

    End WordWrapFunc;
    
end osi_util;
/

