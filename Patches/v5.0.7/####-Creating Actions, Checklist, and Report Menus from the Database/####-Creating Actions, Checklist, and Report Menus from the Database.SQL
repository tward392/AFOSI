--- CFUNDS ADVANCES AND EXPENSES ---
UPDATE T_OSI_OBJ_TYPE SET INCLUDE_STATUS_MENU='Y' WHERE SID IN ('222000008H4','22200000GJY');
COMMIT;


ALTER TABLE T_OSI_REPORT_TYPE ADD IMAGE VARCHAR2(50);



ALTER TABLE T_OSI_STATUS_CHANGE ADD IMAGE VARCHAR2(50);

ALTER TABLE T_OSI_STATUS_CHANGE ADD CHECKLIST_IMAGE VARCHAR2(50);


update t_osi_status_change set image='transfer16.gif' where transition like '%Transfer%';
commit;

update t_osi_status_change set image='adminclosure16.gif' where transition='Admin Closure';
commit;

update t_osi_status_change set image='approveclosure16.gif' where transition='Approve Closure';
commit;

update t_osi_status_change set image='approvefile16.gif' where transition like 'Approve %' and transition!='Approve Closure';
commit;

update t_osi_status_change set image='archive16.gif' where transition='Archive';
commit;

update t_osi_status_change set image='handclipboardcheckmark16.gif' where transition in ('Assign Auxiliary Unit');
commit;

update t_osi_status_change set image='cloneactivity16.gif' where transition in ('Clone Activity');
commit;

update t_osi_status_change set image='closefile16.gif' where transition like 'Close%' and transition!='Close Activity';
commit;

update t_osi_status_change set image='closeactivity16.gif' where transition='Close Activity';
commit;

update t_osi_status_change set image='handclipboardcheckmark16.gif' where transition='Complete Activity';
commit;

update t_osi_status_change set image='submitforapproveclose16.gif' where upper(transition) like '%SUBMIT FOR CLOSURE%' or upper(transition) like '%SUBMIT FOR APPROVAL%';
commit;

update t_osi_status_change set image='updateparticipantlinks16.gif' where transition='Update Participant Links';
commit;

update t_osi_status_change set image='unarchive16.gif' where transition='Unarchive';
commit;

update t_osi_status_change set image='receivedatarchive16.gif' where upper(transition) like '%RECEIVE%ARCHIVE%';
commit;

update t_osi_status_change set image='sendtoarchive16.gif' where upper(transition) like '%SEND%ARCHIVE%' OR upper(transition) like '%SUBMIT%ARCHIVE%';
commit;

update t_osi_status_change set image='reopenfile16.gif' where transition in ('Reopen','Reopen File','Reopen PSO');
commit;

update t_osi_status_change set image='rejectclosure16.gif' where transition in ('Reject Closure');
commit;

update t_osi_status_change set image='rejectapproval16.gif' where transition in ('Reject Approval');
commit;

update t_osi_status_change set image='Case.gif' where transition in ('Create Case');
commit;

update t_osi_status_change set image='recallactivity16.gif' where transition in ('Recall Activity');
update t_osi_status_change set image='rejectactivity16.gif' where transition in ('Reject Activity');
update t_osi_status_change set image='reopenactivity16.gif' where transition in ('Reopen Activity');
commit;

update t_osi_status_change set image='confirm16.gif' where transition in ('Confirm');
update t_osi_status_change set image='unconfirm16.gif' where transition in ('Unconfirm');
commit;

update t_osi_status_change set image='recallsubmission16.gif' where upper(transition) in ('RECALL SUBMIT FOR APPROVAL');
commit;

--- Source ---
update t_osi_status_change set image='sourceapprove16.gif' where upper(transition) in ('APPROVE SOURCE');
update t_osi_status_change set image='sourcerequestactivation16.gif' where upper(transition) in ('REQUEST ACTIVATION');
update t_osi_status_change set image='sourcerejecttermination16.gif' where upper(transition) in ('REJECT TERMINATION');
update t_osi_status_change set image='sourcemaintenancecomplete16.gif' where upper(transition) in ('MAINTENANCE COMPLETE');
update t_osi_status_change set image='sourcesubmitformaintenance16.gif' where upper(transition) in ('SUBMIT FOR MAINTENANCE');
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition) in ('RECALL SUBMIT FOR BURN');
update t_osi_status_change set image='sourcesubmitforburn16.gif' where upper(transition) in ('SUBMIT FOR BURN');
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition) in ('RECALL SUBMIT FOR TERMINATION');
update t_osi_status_change set image='sourcesubmitfortermination16.gif' where upper(transition) in ('SUBMIT FOR TERMINATION');
update t_osi_status_change set image='sourceapprovetermination16.gif' where upper(transition) in ('TERMINATE SOURCE');
update t_osi_status_change set image='transfer16.gif' where transition='Migrate to Existing Source';
commit;

--- AAPP ---
update t_osi_status_change set image='receivedatarchive16.gif' where upper(transition) like '%RETRIEVE%ARCHIVE%';
update t_osi_status_change set image='sourceapprovetermination16.gif' where upper(transition)='WITHDRAW';
update t_osi_status_change set image='sourcerejecttermination16.gif' where upper(transition)='TERMINATE';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='REGION RETURN';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='FORWARD TO REGION';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='UNIT RETURN';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR UNIT REVIEW';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='DOA APPROVED';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='DOA REJECT';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR DOA (AGENT)';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR REJECTION';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR DET APPROVAL';
update t_osi_status_change set image='submitforapproveclose16.gif' where upper(transition)='PRIOR AFOSI';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='DP RETURN';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='DET RETURN';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='RETURN TO AGENT';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='DET APPROVAL';
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition)='RECALL';
update t_osi_status_change set image='selectedforafosiduty16.gif' where upper(transition)='SELECTED FOR AFOSI DUTY';
update t_osi_status_change set image='notselectedforafosiduty16.gif' where upper(transition)='NOT SELECTED FOR AFOSI DUTY';
commit;

--- POLY ---
update t_osi_status_change set image='adminclosure16.gif' where upper(transition)='SUBMIT FOR ADMIN CLOSURE';
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition)='RECALL SUBMIT FOR HQ CLOSURE' or upper(transition)='RECALL SUBMIT FOR RPO REVIEW';
update t_osi_status_change set image='rejectclosure16.gif' where upper(transition)='REJECT BY HQ';
update t_osi_status_change set image='submitforapproveclose16.gif' where upper(transition)='SUBMIT FOR HQ REVIEW' or upper(transition)='SUBMIT FOR RPO REVIEW' or upper(transition)='SUBMIT FOR HQ CLOSURE';
commit;

--- PSO ---
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='REJECT PSO';
commit;

--- SUSPICIOUS ACTIVITY REPORT ---
update t_osi_status_change set image='createecho16.gif' where upper(transition)='CREATE ECHO';
update t_osi_status_change set image='publishreport16.gif' where upper(transition)='PUBLISH REPORT';
update t_osi_status_change set image='submitforreview16.gif' where upper(transition)='SUBMIT FOR REVIEW';
update t_osi_status_change set image='submittopublish16.gif' where upper(transition)='SUBMIT TO PUBLISH';
commit;

--- PMM ---
update t_osi_status_change set image='fixloginid16.gif' where transition='Fix Login ID';
--update t_osi_status_change set image='lockfile16.gif' where transition='';
update t_osi_status_change set image='resetpassword16.gif' where transition='Reset Password';
update t_osi_status_change set image='suspendpersonnelfile16.gif' where transition='Suspend User Account';
update t_osi_status_change set image='reopen16.gif' where transition='Re-Open User Account';
commit;


update t_osi_status_change set image='SFS.gif' where transition='Create DCII Indexing File';
commit;











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
    20-Jun-2012 Tim Ward       Added new parameter to get_report_links, get_status_buttons, and get_checklist_buttons.
                                Allows OSI_MENU to get the lists in a more usable way to split them up.
    
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

    function get_report_links(p_obj in varchar2, p_delim in varchar2 := '~')
        return varchar2;

    function get_report_menu(p_obj in varchar2, p_justTemplate in varchar2 := 'Y')
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of statuses that an
--    object may currently go to
    function get_status_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
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
    20-Jun-2012 Tim Ward       Added new parameter to get_report_links, get_status_buttons, and get_checklist_buttons.
                                Allows OSI_MENU to get the lists in a more usable way to split them up.

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

    function get_report_links(p_obj in varchar2, p_delim in varchar2 := '~')
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

            v_rtn := v_rtn || p_delim || a.description || '~';

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
    function get_status_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
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

            v_rtn := v_rtn || p_delim || i.button_label || '~' || i.sid;

        end loop;

        return v_rtn || p_delim;
    end get_status_buttons;
    
--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
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
            v_rtn := v_rtn || p_delim || i.checklist_button_label || '~' || i.sid;
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








-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_MENU" AS
/******************************************************************************
   Name:     osi_menu
   Purpose:  Provides Functionality for OSI Menu Creation

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    11-May-2012 Tim Ward        Created Package.
    20-Jun-2012 Tim Ward        Added GetObjectMenusHTML to allow building
                                 Lifecycle, Checklist, IAFIS, Versions, Reports,
                                 and E-Fund Menus from here......
                                       
******************************************************************************/
  vCRLF VARCHAR2(4) := CHR(13) || CHR(10);
   
  FUNCTION GetMenuHTML(pMenuID in varchar2, pTopLevelDescriptionReplace in varchar2 := NULL, pOtherNames in varchar2 := NULL, pOtherVals in varchar2 := NULL) RETURN CLOB;
  FUNCTION GetObjectMenusHTML(pObjSID in varchar2, pMenuToGet in varchar2, pObjContext in varchar2 := NULL) RETURN CLOB;

END Osi_Menu;
/


CREATE OR REPLACE PACKAGE BODY "OSI_MENU" AS
/******************************************************************************
   Name:     osi_menu
   Purpose:  Provides Functionality for OSI Menu Creation

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    11-May-2012 Tim Ward        Created Package.
    20-Jun-2012 Tim Ward        Added GetObjectMenusHTML to allow building
                                 Lifecycle, Checklist, IAFIS, Versions, Reports,
                                 and E-Fund Menus from here......
                                 Added GetActionsMenuHTML, GetChecklistImage, GetChecklistMenuHTML, 
                                  GetIAFISMenuHTML, GetObjectsMenusHTML, GetReportMenuHTML, 
                                  GetReportImage, GetStatusImage, and GetVersionsMenuHTML.
                                       
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_MENU';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    FUNCTION childrenCount(pMenuID in varchar2) return number is
            
            childCount number := 0;
    BEGIN
         select count(*) into childCount from t_osi_menu where parent_id=pMenuID and active='Y';

         return childCount;
    
    EXCEPTION WHEN OTHERS THEN
             
             return childCount;
                      
    END childrenCount;
    
    FUNCTION GetMenuHTML(pMenuID in varchar2, pTopLevelDescriptionReplace in varchar2 := NULL, pOtherNames in varchar2 := NULL, pOtherVals in varchar2 := NULL) return CLOB is
      
      SQLString     CLOB;
      topLevelClass varchar2(100) := ' class="sf-with-ul-top" ';
      topLevelli    varchar2(100) := ' class="sf-li-top" ';

    BEGIN
         SQLString := '<ul class="sf-menu">' || vCRLF;

         for m in (SELECT * from t_osi_menu where active='Y' START WITH id=pMenuId CONNECT BY prior id=parent_id order by seq)
         loop
             if(pOtherNames is not null and pOtherVals is not null) then
               
               if(m.command is null) then

                 SQLString := SQLString || '<li id="' || m.id || '"' || toplevelli || '><a' || toplevelclass || 'href="#">';
               
               else
                 
                 SQLString := SQLString || '<li id="' || m.id || '"' || toplevelli || '><a' || toplevelclass || 'href="' || replace(m.command,');',',' || '''' || pOtherNames || '''' || ',' || '''' || pOtherVals || '''' || ');') || '">';
               
               end if;

             else
  
               SQLString := SQLString || '<li id="' || m.id || '"' || toplevelli || '><a' || toplevelclass || 'href="' || nvl(m.command,'#') || '">';
               
             end if;
             
             if(m.icon is not null) then
  
               SQLString := SQLString || '<img class="sf-menu-img" src="' || m.icon || '">';
  
             end if;
             
             if(m.id=pMenuId and pTopLevelDescriptionReplace is not null) then

               SQLString := SQLString || pTopLevelDescriptionReplace || '</a>';

             else

               SQLString := SQLString || m.description || '</a>';

             end if;
             
             if(childrenCount(m.id)>0) then

               SQLString := SQLString  || vCRLF || '<ul id="' || m.id || '_MAIN">' || vCRLF;
             
             else

               SQLString := SQLString || '</li>' || vCRLF;
             
             end if;
             if(m.last_child)='Y' then

               SQLString:=SQLString || '</ul>' || vCRLF;

             end if;             
             if(m.double_close)='Y' then

               SQLString:=SQLString || '</ul>' || vCRLF;

             end if;
             topLevelClass:=' ';
             topLevelli:=' ';
             
         end loop;
         SQLString := SQLString || '</ul>' || vCRLF;

         return SQLString;
         
    END GetMenuHTML;

    FUNCTION GetReportImage(preportLabel in varchar2 ,preportSID in varchar2) return varchar2 is
      
      statusImage varchar2(100) := '/i/themes/OSI/report16.gif';
      
    BEGIN
         begin
              select '/i/themes/OSI/' || decode(image,null,'report16.gif',image) into statusImage from t_osi_report_type where sid=preportSID;
              
         exception when others then
                  
                  statusImage:='/i/themes/OSI/report16.gif';
                  
         end;
         
         return statusImage;
         
    END GetReportImage;

    FUNCTION GetChecklistImage(pchecklistLabel in varchar2 ,pstatusSID in varchar2) return varchar2 is
      
      statusImage varchar2(100) := '/i/themes/OSI/checklist16.gif';
      
    BEGIN
         begin
              select '/i/themes/OSI/' || decode(checklist_image,null,'checklist16.gif',image) into statusImage from t_osi_status_change where sid=pstatusSID;
              
         exception when others then
                  
                  statusImage:='/i/themes/OSI/checklist16.gif';
                  
         end;
         
         return statusImage;
         
    END GetChecklistImage;
    
    FUNCTION GetStatusImage(pstatusLabel in varchar2 ,pstatusSID in varchar2) return varchar2 is
      
      statusImage varchar2(100) := '/i/themes/OSI/blank16.gif';
      
    BEGIN
         begin
              select '/i/themes/OSI/' || decode(image,null,'blank16.gif',image) into statusImage from t_osi_status_change where sid=pstatusSID;
              
         exception when others then
                  
                  statusImage:='/i/themes/OSI/blank16.gif';
                  
         end;
         
         return statusImage;
         
    END GetStatusImage;
    
    FUNCTION GetActionsMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2, pObjTypeSID in varchar2) RETURN CLOB is    

      SQLString     CLOB;
      statusButtons CLOB;
      listCount     NUMBER;
      statusLabel   varchar2(1000);
      statusSID     varchar2(1000);
      statusImage   varchar2(1000);
      statusCount   NUMBER := 8;
      status        varchar2(1000);
      submitted_on  date;
                  
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_ACTIONS" class="sf-li-top"><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/blank16.gif">Actions</a>';
         SQLString := SQLString || '  <ul id="ID_ACTIONS_MAIN">';
         
         --- Delete Object Menu Item ---
         if (pObjSID is not null) then
         
           SQLString := SQLString || '   <li id="ID_STATUS1"><a href="javascript:void(0);" onclick="javascript:deleteObj(''' || pObjSID || ''',''DELETE_OBJECT'');"><img class="sf-menu-img" src="/i/themes/OSI/delete16.gif">Delete</a></li>';

         end if;
         
         --- E-Fund Expenses ONLY Related Menu Items ---
         if (pObjTypeCode='CFUNDS_EXP') then
           
           begin
                select status into status from v_cfunds_expense_v3 where sid=pObjSID;
           exception when others then
           
                    status := null;
           end;

           if (status='' or status='New') and cfunds_test_cfp('EXP_CRE_PROXY',pObjTypeSID,core_context.personnel_sid,osi_personnel.get_current_unit(core_context.personnel_sid)) = 'Y' then         

             SQLString := SQLString || '   <li id="ID_STATUSC1"><a href="javascript:void(0);" onclick="javascript:openLocator(''301'',''P30505_CLAIMANT'',''N'','''',''OPEN'','''','''',''Choose New Claimant...'',''PERSONNEL'',''' || pObjSID || ''');"><img class="sf-menu-img" src="/i/themes/OSI/ChangeClaimant16.gif">Change Claimant</a></li>';

           end if;

           if (status='Disallowed' or status='New') then         

             SQLString := SQLString || '   <li id="ID_STATUSC2"><a href="javascript:void(0);" onclick="javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');"><img class="sf-menu-img" src="/i/themes/OSI/submitforapproveclose16.gif">Submit for Approval</a></li>';

           end if;
           
           if (status='Submitted') then         

             SQLString := SQLString || '   <li id="ID_STATUSC3"><a href="javascript:void(0);" onclick="javascript:popupCommentsWindow();"><img class="sf-menu-img" src="/i/themes/OSI/RejectAdvanceExpense16.gif">Disallow Expense</a></li>';
             SQLString := SQLString || '   <li id="ID_STATUSC4"><a href="javascript:void(0);" onclick="javascript:doSubmit(''APPROVE_EXPENSE'');"><img class="sf-menu-img" src="/i/themes/OSI/ApproveAdvanceExpense16.gif">Approve Expense</a></li>';

           end if;
                      
           if (status='Rejected') then         

             SQLString := SQLString || '   <li id="ID_STATUSC5"><a href="javascript:void(0);" onclick="javascript:doSubmit(''FIX_EXPENSE'');"><img class="sf-menu-img" src="/i/themes/OSI/ResubmitFixedExpense16.gif">Fix Expense</a></li>';

           end if;
           
           if (status='Disallowed') then         

             SQLString := SQLString || '   <li id="ID_STATUSC6"><a href="javascript:void(0);" onclick="javascript:popupCommentsWindow();"><img class="sf-menu-img" src="/i/themes/OSI/ViewDisallowedExpenseComments16.gif">View Disallowed Expense Comments</a></li>';

           end if;
           
         end if;

         --- E-Fund Advances ONLY Related Menu Items ---
         if (pObjTypeCode='CFUNDS_ADV') then

           begin
                select status,submitted_on into status,submitted_on from v_cfunds_advance_v2 where sid=pObjSID;
           exception when others then
           
                    status := null;
                    submitted_on := null;
                    
           end;

           --SQLString := SQLString || '   <li id="ID_STATUSC1"><a href="javascript:void(0);" onclick="javascript:doSubmit(''ISSUE_ADVANCE'');"><img class="sf-menu-img" src="/i/themes/OSI/blank16.gif">Issue Advance</a></li>';

           if (submitted_on is null) then           

             SQLString := SQLString || '   <li id="ID_STATUSC2"><a href="javascript:void(0);" onclick="javascript:openLocator(''301'',''P30600_CLAIMANT_SID'',''N'','''',''OPEN'','''','''',''Choose New Claimant...'',''PERSONNEL'',''' || pObjSID || ''');"><img class="sf-menu-img" src="/i/themes/OSI/ChangeClaimant16.gif">Change Claimant</a></li>';

           end if;
           
           if (submitted_on is null or status='Disallowed') then           

             SQLString := SQLString || '   <li id="ID_STATUSC3"><a href="javascript:void(0);" onclick="javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');"><img class="sf-menu-img" src="/i/themes/OSI/submitforapproveclose16.gif">Submit for Approval</a></li>';

           end if;

           if (status='Submitted') then           

             SQLString := SQLString || '   <li id="ID_STATUSC4"><a href="javascript:void(0);" onclick="javascript:doSubmit(''APPROVE_ADVANCE'');"><img class="sf-menu-img" src="/i/themes/OSI/ApproveAdvanceExpense16.gif">Approve Advance</a></li>';

           end if;
                    
           if (status='Submitted') then           

             SQLString := SQLString || '   <li id="ID_STATUSC5"><a href="javascript:void(0);" onclick="javascript:doSubmit(''REJECT_ADVANCE'');"><img class="sf-menu-img" src="/i/themes/OSI/RejectAdvanceExpense16.gif">Reject Advance</a></li>';

           end if;

         end if;

         --- DEERS Check Menu Item ---
         if (pObjTypeCode='PART.INDIV') then -- and (:p0_obj_context is null or :p0_obj_context = osi_participant.get_current_version(:p0_obj))
         
           SQLString := SQLString || '   <li id="ID_STATUS2"><a href="javascript:void(0);" onclick="javascript:checkDeers(''' || pObjSID || ''');" onclick="javascript:runDirtyTest(''Action''); return !(checkDirty());"><img class="sf-menu-img" src="/i/themes/OSI/deers16.gif">Check DEERS</a></li>';

         end if;         
         
         --- Generate Narrative for Initial Notification Activities Menu Item ---
         if (pObjTypeCode='ACT.INIT_NOTIF') then

           SQLString := SQLString || '   <li id="ID_STATUS3"><a href="javascript:void(0)" onclick="javascript:runJQueryPopWin(''Generate Narrative'',''' || pObjSID || ''',''22010'');return false;"><img class="sf-menu-img" src="/i/themes/OSI/generatenarrative16.gif">Generate Narrative</a></li>';

         end if;
         
         --- Duplicate Legacy I2MS Source Search Menu Item ---
         if (pObjTypeCode='FILE.SOURCE') then

           SQLString := SQLString || '   <li id="ID_STATUS4"><a href="javascript:void(0);" onclick="javascript:newWindow({page:11330,clear_cache:''11330'',name:''' || pObjSID || '_SRCSRCH'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P11330_OBJ'',item_values:''' || pObjSID || ',,' || pObjSID || ''',request:''SRCH''});"><img class="sf-menu-img" src="/i/themes/OSI/duplicatelegacyi2mssourcesearch16.gif">Duplicate Legacy I2MS Source Search</a></li>';
         
         end if;

         --- Legacy I2MS Relationship Search Menu Item ---
         if (pObjTypeCode like ('PART.%') and osi_participant.get_imp_relations_flag(pObjSID) = 'N') then

           SQLString := SQLString || '   <li id="ID_STATUS5"><a href="javascript:void(0);" onclick="javascript:importRelations(''' || pObjSID || ''',''IMPORT_RELATIONS'');"><img class="sf-menu-img" src="/i/themes/OSI/legacyi2msrelationshipsearch16.gif">Legacy I2MS Relationship Search</a></li>';
         
         end if;
         
         --- Status Change Menu Items ---
         statusButtons := osi_util.get_status_buttons(pObjSID, '^~');
         if (statusButtons!='~') then
         
           for a in (select column_value from table(split(statusButtons,'^~')) where column_value is not null)
           loop

               listCount:=1;
               for b in (select column_value from table(split(a.column_value,'~')))
               loop
                   if (listCount=1) then
                 
                     statusLabel := replace(b.column_value,'''','''''');

                   elsif (listCount=2) then

                        statusSID := replace(b.column_value,'''','''''');

                   end if;
                   listCount:=listCount+1;
                 
               end loop;
               statusImage := GetStatusImage(statusLabel,statusSID);
               SQLString := SQLString || '   <li id="ID_STATUS"' || statusCount || '><a href="javascript:void(0);" onclick="javascript:runJQueryPopWin(''Status'',''' || pObjSID || ''',''' || statusSID || ''');"><img class="sf-menu-img" src="' || statusImage || '">' || statusLabel || '</a></li>';
               statusCount := statusCount + 1;
               
           end loop;

         end if;
         
         --- Classify Menu Item ---
         if (CORE_UTIL.GET_CONFIG('OSI.ALLOW_CLASSIFICATIONS')='Y' AND pObjTypeCode NOT IN ('CFUNDS_ADV','CFUNDS_EXP','PERSONNEL')) then         

           SQLString := SQLString || '   <li id="ID_STATUS6"><a href="javascript:void(0);" onclick="javascript:newWindow({page:765,clear_cache:''765'',name:''' || pObjSID || '_CLASSIFICATION'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P765_OBJ,P765_CONTEXT'',item_values:''' || pObjSID || ',,' || pObjSID || ','',request:''CLASSIFICATION''});"><img class="sf-menu-img" src="/i/themes/OSI/classify16.gif">Classify</a></li>';
           
         end if;
         
         --- Masking Menu Item ---
         if (pObjTypeCode in ('ACT.INTERVIEW.WITNESS','ACT.SOURCE_MEET','ACT.SURVEILLANCE')) then

           SQLString := SQLString || '   <li id="ID_STATUS7"><a href="javascript:void(0);" onclick="javascript:newWindow({page:760,clear_cache:''760'',name:''' || pObjSID || '_MASK'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P760_OBJ'',item_values:''' || pObjSID || ',,' || pObjSID || ''',request:''MASK''});"><img class="sf-menu-img" src="/i/themes/OSI/masking16.gif">Masking</a></li>';

         end if;
                  
         SQLString := SQLString || '  </ul>';
         SQLString := SQLString || ' </li>';
         SQLString := SQLString || '</ul>';

         return SQLString;

    END GetActionsMenuHTML;    

    FUNCTION GetChecklistMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2) RETURN CLOB is    

      SQLString        CLOB;
      checklistButtons CLOB;
      listCount        NUMBER;
      checklistLabel   varchar2(1000);
      checklistSID     varchar2(1000);
      checklistImage   varchar2(1000);
      checklistCount   NUMBER := 1;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_CHECKLIST" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/checklist16.gif">Checklists</a>';
         SQLString := SQLString || '  <ul id="ID_CHECKLISTS_MAIN">';
         
         --- Checklist Menu Items ---
         checklistButtons := osi_util.get_checklist_buttons(pObjSID, '^~');
         if (checklistButtons='~') then
         
           SQLString := '';
           
         else

           for a in (select column_value from table(split(checklistButtons,'^~')) where column_value is not null)
           loop

               listCount:=1;
               for b in (select column_value from table(split(a.column_value,'~')))
               loop
                   if (listCount=1) then
                  
                     checklistLabel := replace(b.column_value,'''','''''');

                   elsif (listCount=2) then

                        checklistSID := replace(b.column_value,'''','''''');

                   end if;
                   listCount:=listCount+1;
                 
               end loop;
               checklistImage := GetChecklistImage(checklistLabel,checklistSID);
               SQLString := SQLString || '   <li id="ID_STATUS"' || checklistCount || '><a href="javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''' || pObjSID || ''',''' || checklistSID || ''');"><img class="sf-menu-img" src="' || checklistImage || '">' || checklistLabel || '</a></li>';
               checklistCount := checklistCount + 1;
               
           end loop;

           SQLString := SQLString || '  </ul>';
           SQLString := SQLString || ' </li>';
           SQLString := SQLString || '</ul>';
           
         end if;
         
         return SQLString;

    END GetChecklistMenuHTML;    

    FUNCTION GetIAFISMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2) RETURN CLOB is    

      SQLString     CLOB;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_IAFIS" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/emailIAFIS_Package.gif">Email IAFIS Package</a>';
         SQLString := SQLString || '  <ul id="ID_IAFIS_MAIN">';
         
         SQLString := SQLString || '   <li id="ID_IAFIS1" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal Inquiry'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalInquiry.gif">Criminal Inquiry</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS2" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal/Booking Submission'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalSubmission.gif">Criminal/Booking Submission</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS3" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal History'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalHistory.gif">Criminal History</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS4" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal/Booking History Update'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalHistoryUpdate.gif">Criminal/Booking History Update</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS5" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Latent'');"><img class="sf-menu-img" src="/i/themes/OSI/Latent.gif">Latent</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS6" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Search'');"><img class="sf-menu-img" src="/i/themes/OSI/Search.gif">Search</a></li>';
                  
         SQLString := SQLString || '  </ul>';
         SQLString := SQLString || ' </li>';
         SQLString := SQLString || '</ul>';

         return SQLString;

    END GetIAFISMenuHTML;    

    FUNCTION GetVersionsMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2, pObjContext in varchar2) RETURN CLOB is    

      SQLString     CLOB;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_VERSIONS" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/version16.gif">Versions</a>';
         SQLString := SQLString || '  <ul id="ID_VERSIONS_MAIN">';

         if (pObjContext = osi_participant.get_current_version(pObjSID) and osi_participant.is_confirmed(pObjSID) is not null) then         

           SQLString := SQLString || '   <li id="ID_VERSION1" ><a href="javascript:void(0);" onclick="javascript:addNote(''NEW_VERSION'',''ADD_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versionadd16.gif">Add</a></li>';

         end if;
         
         --SQLString := SQLString || '   <li id="ID_VERSION2" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''DELETE_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versiondelete16.gif">Delete</a></li>';
         
         if osi_participant.get_next_version(pObjContext) is not null then

           SQLString := SQLString || '   <li id="ID_VERSION3" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''NEXT_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versionnext16.gif">Next</a></li>';

         end if;
         
         if osi_participant.get_previous_version(pObjContext) is not null then
  
           SQLString := SQLString || '   <li id="ID_VERSION4" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''PREVIOUS_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versionprevious16.gif">Previous</a></li>';

         end if;
         
         if (osi_participant.get_current_version(pObjSID) != pObjContext) then

           SQLString := SQLString || '   <li id="ID_VERSION5" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''CURRENT_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/version16.gif">Current</a></li>';

         end if;
                  
         SQLString := SQLString || '  </ul>';
         SQLString := SQLString || ' </li>';
         SQLString := SQLString || '</ul>';

         return SQLString;

    END GetVersionsMenuHTML;    
    
    FUNCTION GetReportMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2) RETURN CLOB is    

      SQLString        CLOB;
      reportButtons    CLOB;
      listCount        NUMBER;
      reportLabel      varchar2(1000);
      reportLink       varchar2(1000);
      reportImage      varchar2(1000);
      reportCount      NUMBER := 1;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_REPORT" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/report16.gif">Reports</a>';
         SQLString := SQLString || '  <ul id="ID_REPORTS_MAIN">';
         
         --- Report Menu Items ---
         reportButtons := osi_util.get_report_links(pObjSID, '^~');
         if (reportButtons='~') then
         
           SQLString := '';
           
         else

           for a in (select column_value from table(split(reportButtons,'^~')) where column_value is not null)
           loop

               listCount:=1;
               for b in (select column_value from table(split(a.column_value,'~')))
               loop
                   if (listCount=1) then
                 
                     --reportLabel := replace(b.column_value,'''','''''');
                     reportLabel := b.column_value;
                     
                   elsif (listCount=2) then

                        --reportLink := replace(b.column_value,'''','''''');
                        reportLink := b.column_value;

                   end if;
                   listCount:=listCount+1;
                 
               end loop;
               reportImage := GetReportImage(reportLabel,null);
               SQLString := SQLString || '   <li id="ID_STATUS"' || reportCount || '><a href="javascript:void(0);" onclick="' || reportLink || '"><img class="sf-menu-img" src="' || reportImage || '">' || reportLabel || '</a></li>';
               reportCount := reportCount + 1;
               
           end loop;

           SQLString := SQLString || '  </ul>';
           SQLString := SQLString || ' </li>';
           SQLString := SQLString || '</ul>';
           
         end if;
         
         return SQLString;

    END GetReportMenuHTML;    
    
    FUNCTION GetObjectMenusHTML(pObjSID in varchar2, pMenuToGet in varchar2, pObjContext in varchar2 := NULL) RETURN CLOB is    

      SQLString     CLOB;
      vObjTypeSID   varchar2(100);
      vObjTypeCode  varchar2(100);
            
    BEGIN
         vObjTypeSID := core_obj.get_objtype(pObjSID);
         vObjTypeCode := osi_object.get_objtype_code(vObjTypeSID);
         
         CASE UPPER(pMenuToGet)
         
                WHEN 'ACTIONS' THEN
                                   SQLString := GetActionsMenuHTML(pObjSid, vObjTypeCode, vObjTypeSID);

              WHEN 'CHECKLIST' THEN
                                   SQLString := GetChecklistMenuHTML(pObjSid, vObjTypeCode);

                  WHEN 'IAFIS' THEN
                                   SQLString := GetIAFISMenuHTML(pObjSid, vObjTypeCode);

                 WHEN 'REPORT' THEN
                                   SQLString := GetReportMenuHTML(pObjSid, vObjTypeCode);

                 WHEN 'STATUS' THEN
                                   SQLString := GetActionsMenuHTML(pObjSid, vObjTypeCode, vObjTypeSID);
         
               WHEN 'VERSIONS' THEN
                                   SQLString := GetVersionsMenuHTML(pObjSid, vObjTypeCode, pObjContext);

         END CASE; 
         
         return SQLString;

    END GetObjectMenusHTML;
        
END Osi_Menu;
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
--   Date and Time:   08:14 Wednesday June 20, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     APP PROCESS: Init Page Zero Items
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
 
 
prompt Component Export: APP PROCESS 88895918473684379
 
prompt  ...application processes
--
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  v_id varchar2(1000);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'   --- SSL Certificate Items, CAC Card ---'||chr(10)||
'   :P0_SSL_CERT := OWA_UTIL.GET_CGI_ENV(''SSL_CLIENT_S_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT)))'||chr(10)||
'   LOOP'||chr(10)||
'       if substr(a.column_value,1,3) = ''CN='' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_S_DN_CN := substr(a.column_value,4);'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
''||chr(10)||
'   :P0_SSL_CERT_I := OWA_UTIL.GET_CGI_ENV(''SSL_';

p:=p||'CLIENT_I_DN'');'||chr(10)||
'   FOR A IN (select * from table(split(:P0_SSL_CERT_I)))'||chr(10)||
'   LOOP'||chr(10)||
'       if a.column_value=''OU=DoD'' then'||chr(10)||
'      '||chr(10)||
'         :P0_SSL_CLIENT_I_DN_OU := a.column_value;'||chr(10)||
''||chr(10)||
'       end if;'||chr(10)||
''||chr(10)||
'   END LOOP;'||chr(10)||
'   ---------------------------------------'||chr(10)||
''||chr(10)||
'   if :P0_OBJ is not null and :APP_PAGE_ID >= 5000 then'||chr(10)||
''||chr(10)||
'     select sid, '||chr(10)||
'            code, '||chr(10)||
'            core_obj.get_tagline(:P0_OBJ),'||chr(10)||
'            ';

p:=p||'substr(core_obj.get_tagline(:P0_OBJ),1,70),'||chr(10)||
'            osi_object.get_id(:P0_OBJ, :P0_OBJ_CONTEXT)'||chr(10)||
'       into :P0_OBJ_TYPE_SID, '||chr(10)||
'            :P0_OBJ_TYPE_CODE, '||chr(10)||
'            :P0_OBJ_TAGLINE,'||chr(10)||
'            :P0_OBJ_TAGLINE_SHORT,'||chr(10)||
'            :P0_OBJ_ID'||chr(10)||
'       from t_core_obj_type'||chr(10)||
'      where sid = core_obj.get_objtype(:P0_OBJ);'||chr(10)||
''||chr(10)||
'      :P0_AUTHORIZED := osi_auth.check_access(:P0_OBJ);'||chr(10)||
'      if     :P0';

p:=p||'_OBJ_TYPE_CODE = ''UNIT'' '||chr(10)||
'         and :APP_PAGE_ID between 30700 and 30799 then'||chr(10)||
'           :P0_OBJ_TYPE_CODE := ''EMM'';'||chr(10)||
''||chr(10)||
'           select sid into :P0_OBJ_TYPE_SID '||chr(10)||
'                 from t_core_obj_type where code=''EMM'';'||chr(10)||
''||chr(10)||
'           :P0_OBJ_TAGLINE := ''Evidence Management Module for: '' ||'||chr(10)||
'                              osi_unit.get_name(:P0_OBJ);'||chr(10)||
'           :P0_AUTHORIZED := osi_auth.check_for_priv';

p:=p||'(''EMM_CUST'','||chr(10)||
'                                          core_obj.lookup_objtype(''EMM''),'||chr(10)||
'                                          null,'||chr(10)||
'                                          :P0_OBJ);'||chr(10)||
'        :P0_WRITABLE := :P0_AUTHORIZED;'||chr(10)||
'      else'||chr(10)||
'        if osi_auth.check_for_priv(''UPDATE'',:P0_OBJ_TYPE_SID)=''Y'' then'||chr(10)||
'          :P0_WRITABLE := osi_object.check_writability(:P0_OBJ, :P0_OBJ_CONTEXT);'||chr(10)||
'        e';

p:=p||'lse'||chr(10)||
'          :P0_WRITABLE := ''N'';'||chr(10)||
'        end if;'||chr(10)||
'      end if;'||chr(10)||
'  elsif :APP_PAGE_ID between 1000 and 4999 then'||chr(10)||
'      :P0_OBJ := null;'||chr(10)||
'      :P0_OBJ_TYPE_SID := null;'||chr(10)||
'      :P0_OBJ_TYPE_CODE := null;'||chr(10)||
'      :P0_OBJ_CONTEXT := null;'||chr(10)||
'      :P0_OBJ_TAGLINE := null;'||chr(10)||
'  else'||chr(10)||
'      :P0_OBJ_TYPE_SID := null;'||chr(10)||
'      :P0_OBJ_TAGLINE := null;'||chr(10)||
'      :P0_OBJ_ID := null;'||chr(10)||
'      if :P0_OBJ_TYPE_CODE is not null th';

p:=p||'en'||chr(10)||
'         :P0_OBJ_TYPE_SID := core_obj.lookup_objtype(:P0_OBJ_TYPE_CODE);'||chr(10)||
'      end if;'||chr(10)||
'      if :P0_OBJ_TYPE_CODE <> ''ALL.REPORT_SPEC'' then'||chr(10)||
'         :P0_OBJ_CONTEXT := null;'||chr(10)||
'      end if;'||chr(10)||
'      :P0_AUTHORIZED := null;'||chr(10)||
'  end if;'||chr(10)||
'  if :APP_PAGE_ID=30101 then'||chr(10)||
''||chr(10)||
'    :P0_AUTHORIZED:=''Y'';'||chr(10)||
'    :P0_WRITABLE:=''Y'';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'   '||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 88895918473684379 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Init Page Zero Items',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Error Initializing Page Zero Items.',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> 'This process runs before the header for every page, and is responsible for maintaining the Page Zero Object-specifics (P0_OBJ, P0_OBJ_TYPE_CODE, P0_OBJ_TYPE_SID and P0_OBJ_TAGLINE). '||chr(10)||
''||chr(10)||
'16-JUN-2010 Jason Faris Task 2997 - Updated process to not reset obj_context item when obj_type_code = ''ALL.REPORT_SPEC''. '||chr(10)||
''||chr(10)||
'If the current page is not within our object specific pages, or common object pages (i.e. associations), then the values of these items are all cleared out.  Otherwise, if P0_OBJ is set (meaning we are in edit mode for an object), then P0_OBJ_TYPE_CODE and P0_OBJ_TYPE_SID are derived from P0_OBJ.  If P0_OBJ is NOT set (meaning we''re in create mode for an object), then P0_OBJ_TYPE_SID is derived from P0_OBJ_TYPE_CODE.'||chr(10)||
''||chr(10)||
''||chr(10)||
'08-Jun-2011 - Tim Ward CR#3876-Foreign National Privileges that are missing'||chr(10)||
'                       Added Page 30101 check, so if accessed is always '||chr(10)||
'                       viewable by anyone.'||chr(10)||
''||chr(10)||
'20-Jun-2012 - Tim Ward Moved some page 0 items lookups from here back to'||chr(10)||
'                       the item source in Page 0.  Removed some debug'||chr(10)||
'                       print statements as well.');
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
--   Date and Time:   08:12 Wednesday June 20, 2012
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

PROMPT ...Remove page 0
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>0);
 
end;
/

 
--application/pages/page_00000
prompt  ...PAGE 0: Page Zero
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 0,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Page Zero',
  p_step_title=> 'Page Zero',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817229855006448+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 179215462100554475+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120620081230',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-MAY-2010  Jason Faris     Added ''Create Exam'' Region (button html) '||chr(10)||
'                             for Poly File support.'||chr(10)||
''||chr(10)||
'18-MAY-2010  Jason Faris     Fixed ''missing source'' bug in report label/url '||chr(10)||
'                             items 4 and 5.'||chr(10)||
''||chr(10)||
'16-JUN-2010  Jason Faris     Task 2997 - Create Run Report - Page 0 Html '||chr(10)||
'                             Region (button).  Update condition on VLT - '||chr(10)||
'                             Page 0 Html Region (button). '||chr(10)||
'                             Update Navigation L1, L2, L3 Regions w/ '||chr(10)||
'                             show_tab = ''Y'' check.  '||chr(10)||
'                             Added P0_LBL_REPORT6 - 10, P0_URL_REPORT6 - 10 '||chr(10)||
'                             for additional Case report support.'||chr(10)||
''||chr(10)||
'02-Mar-2011 - TJW - CR#3705 - Use Reports Menu now on CFunds Expenses, '||chr(10)||
'                              need to make sure the the VLT button '||chr(10)||
'                              doesn''''t show.'||chr(10)||
''||chr(10)||
'07-Jul-2011 Tim Ward - CR#3860 - Don''t show Read-Only on the FD-249 or '||chr(10)||
'                                 IAFIS Screens since they are read-only '||chr(10)||
'                                 by default.'||chr(10)||
'                                 Added 22710, 22711, 22715 and 22720'||chr(10)||
'                                 to not in clause, also added an ID to the '||chr(10)||
'                                 DIV so we can show/hide via javascript '||chr(10)||
'                                 in the future without changing '||chr(10)||
'                                 page 0.'||chr(10)||
''||chr(10)||
'10-Aug-2011 Tim Ward CR#3871 - Rearrange ROI Narratives.'||chr(10)||
'                                Added an ID to Run Report so we can hide '||chr(10)||
'                                it via Javascript..'||chr(10)||
''||chr(10)||
'27-Oct-2011 - CR#3822 - Two Items Open at Same Time overwrite :P0_OBJ '||chr(10)||
'                        and cause problems.  Added :P0_OBJ as a variable'||chr(10)||
'                        to goToTab call in Navigation L1, L2, and L3.'||chr(10)||
''||chr(10)||
'30-Apr-2012 - Tim Ward - CR#4043 - Changed Create Exam to call '||chr(10)||
'                          createActivityObject instead of createObject.'||chr(10)||
''||chr(10)||
'15-May-2012 - Tim Ward - CR#3975 - Create and WebLinks Menus now build'||chr(10)||
'                          from the database, removed regions and lists.'||chr(10)||
''||chr(10)||
'20-Jun-2012 - Tim Ward - Build Actions, Checklist, IAFIS, Versions, and '||chr(10)||
'                          E-Funds Menus from the database.  Removed'||chr(10)||
'                          associated regions and lists.  Reduced the items'||chr(10)||
'                          on the page from 62 to 31.');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<div class="readOnlyBanner" id="readOnlyBanner"><span>READ-ONLY</span></div>';

wwv_flow_api.create_page_plug (
  p_id=> 4179910558064014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Read-Only Banner',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .001,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'BEFORE_BOX_BODY',
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
  p_plug_display_when_condition => ':P0_OBJ is not null and'||chr(10)||
':APP_PAGE_ID not in (20100,5000,5050,5100,5250,5450,5500,5550,22710,22711,22715,22720,22805) and'||chr(10)||
':APP_PAGE_ID > 5000 and'||chr(10)||
':P0_WRITABLE = ''N''',
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
  p_id=> 4445306017641973 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Region for all pages',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .002,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_03',
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
  p_id=> 13716901766966972 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Menus',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .01,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_06',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
  p_id=> 14611614812197441 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Object Menus',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> .045,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_07',
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
  p_plug_header=> '<div id="Menus" style="z-index: 2; position: relative;">',
  p_plug_footer=> '</div>'||chr(10)||
'<script type="text/javascript"> '||chr(10)||
''||chr(10)||
'  $(document).ready(function() '||chr(10)||
'   {'||chr(10)||
'    var $menuDIV = $("#Menus");'||chr(10)||
'    $menuDIV.children("table").removeClass("formlayout");'||chr(10)||
'   });'||chr(10)||
''||chr(10)||
'</script>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '<div id="Menus" style="z-index: 2; position: relative;"> fixes an IE Problem '||chr(10)||
'where the drop-downs will appear behind the tabs.  Need to remove the formlayout class or IE doesn''t display the menus correctly.');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid)>0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab('''''' ||'||chr(10)||
'                  sid ||';

s:=s||' '''''''' || '||chr(10)||
'                  '','' || '''''''' || :P0_OBJ || '''''''' ||'||chr(10)||
'                  ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 1'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                               from t_osi_tab'||chr(10)||
'                              where ob';

s:=s||'j_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 1'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'       and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_context) = ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91428410802515584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L1',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .091,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 0',
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
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid) > 0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab('''''' ||'||chr(10)||
'                  sid ';

s:=s||'|| '''''''' || '||chr(10)||
'                  '','' || '''''''' || :P0_OBJ || '''''''' ||'||chr(10)||
'                  ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 2'||chr(10)||
'       and parent_tab = core_list.get_list_element(:P0_TABS,1)'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                   ';

s:=s||'            from t_osi_tab'||chr(10)||
'                              where obj_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 2'||chr(10)||
'                                and parent_tab = core_list.get_list_element(:P0_TABS,1)'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'     and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_conte';

s:=s||'xt) = ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91429436391570289 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L2',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .092,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 1',
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
s:=s||'begin'||chr(10)||
'  for i in ('||chr(10)||
'     select (case '||chr(10)||
'               when instr(:P0_TABS, sid) > 0 then'||chr(10)||
'                  ''<a class ="here">'' || tab_label || ''</a>'''||chr(10)||
'               when active<>''Y'' then'||chr(10)||
'                  ''<a class="disabled">'' || tab_label || ''</a>'''||chr(10)||
'               else'||chr(10)||
'                  ''<a href="javascript:void(0);" '' ||'||chr(10)||
'                  ''onclick="javascript:goToTab('''''' ||'||chr(10)||
'                  sid ';

s:=s||'|| '''''''' || '||chr(10)||
'                  '','' || '''''''' || :P0_OBJ || '''''''' ||'||chr(10)||
'                  ''); return false;">'' || tab_label || ''</a>'''||chr(10)||
'             end) as link'||chr(10)||
'      from t_osi_tab t'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'       and tab_level = 3'||chr(10)||
'       and parent_tab = core_list.get_list_element(:P0_TABS,2)'||chr(10)||
'       and tab_label not in (select tab_label'||chr(10)||
'                   ';

s:=s||'            from t_osi_tab'||chr(10)||
'                              where obj_type = :P0_OBJ_TYPE_SID'||chr(10)||
'                                and tab_level = 3'||chr(10)||
'                                and parent_tab = core_list.get_list_element(:P0_TABS,2)'||chr(10)||
'                                and override=''Y'''||chr(10)||
'                                and sid <> t.sid)'||chr(10)||
'and osi_util.show_tab(:p0_obj_type_code,t.sid,:p0_obj,:p0_obj_context) =';

s:=s||' ''Y'''||chr(10)||
'     order by seq) loop'||chr(10)||
'        htp.p(i.link || ''&nbsp;'');'||chr(10)||
'     end loop;'||chr(10)||
'end;';

wwv_flow_api.create_page_plug (
  p_id=> 91429609510572045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Navigation L3',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .093,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_08',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'core_list.count_list_elements(:P0_TABS) > 2',
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
  p_id=> 92111129885131770 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Desktop',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 91998132424658949 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92112437289143401 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 91999430476667882 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92225431857168384 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Investigative Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 15,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92214720944127418 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92386536451926771 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Management Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92363332155840307 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92387529309934109 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Service Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 25,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92373837050870107 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92388608316937557 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Support Files',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92376809046890382 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 92389519051940631 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Participants',
  p_region_name=>'',
  p_plug_template=> 92059616840235631+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 35,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_02',
  p_plug_source=> s,
  p_plug_source_type=> 92377423591894620 + wwv_flow_api.g_id_offset,
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':APP_PAGE_ID between 1000 and 4999',
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
  p_id=> 175627141504047911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Hidden Obj Items',
  p_region_name=>'',
  p_plug_template=> 4189612428200021+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> .02,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
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
  p_plug_footer=> '<script type="text/javascript">'||chr(10)||
'   if (document.getElementById(''P0_AUTHORIZED'').value == ''N''){'||chr(10)||
'        alert(''You are not authorized to perform the requested action.'');'||chr(10)||
'        window.close();'||chr(10)||
'   }'||chr(10)||
'</script>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1132002937271910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CLIENT_S_DN_CN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 310,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>1132927757188885 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CERT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 330,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>1140331524832009 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TAGLINE_SHORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 36,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>1155812787079635 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CERT_I',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 340,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>1156020752081903 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_SSL_CLIENT_I_DN_OU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 350,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>3297724392206432 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_AUTHORIZED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>4169719506262300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_WRITABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 56,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>8965824316163151 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DESKTOP_NAVIGATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 360,
  p_item_plug_id => 92111129885131770+wwv_flow_api.g_id_offset,
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
  p_id=>12387231003449395 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DISPLAY_REPORTS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 58,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_line => 'YES',
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
  p_id=>12390404094574065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_REPORTS_PRIV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 57,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'Declare'||chr(10)||
''||chr(10)||
'      v_count varchar(20);'||chr(10)||
'      v_objtype varchar(50);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'select count(*)'||chr(10)||
'  into v_count'||chr(10)||
'  from t_osi_report_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and obj_type member of OSI_OBJECT.GET_OBJTYPES(:P0_OBJ_TYPE_SID)'||chr(10)||
'   and active = ''Y'';'||chr(10)||
''||chr(10)||
'  v_objtype := OSI_OBJECT.GET_OBJTYPE_CODE(:P0_OBJ_TYPE_SID);'||chr(10)||
''||chr(10)||
''||chr(10)||
'if (v_count > 0) then'||chr(10)||
''||chr(10)||
'      if ( v_objtype like ''FILE.INV%'')  then'||chr(10)||
' '||chr(10)||
'         if (OSI_AUTH.CHECK_FOR_PRIV(''GEN_RPTS'', :P0_OBJ_TYPE_SID) = ''Y'') then'||chr(10)||
''||chr(10)||
'              :P0_DISPLAY_REPORTS := ''Y'';'||chr(10)||
''||chr(10)||
'        else'||chr(10)||
'              :P0_DISPLAY_REPORTS := ''N'';'||chr(10)||
''||chr(10)||
'        end if;'||chr(10)||
''||chr(10)||
'      else'||chr(10)||
''||chr(10)||
'       :P0_DISPLAY_REPORTS := ''Y'';'||chr(10)||
''||chr(10)||
'    '||chr(10)||
'      end if;'||chr(10)||
''||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_id=>13717217697971593 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CREATEMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> .01,
  p_item_plug_id => 13716901766966972+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETMENUHTML(''ID_CREATE'');',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_id=>13717430510975220 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_WEBLINKSMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> .02,
  p_item_plug_id => 13716901766966972+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETMENUHTML(''ID_WEBLINKS'');',
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
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
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
  p_id=>14613415036263774 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_ACTIONSMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 370,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''ACTIONS'');',
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
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_status_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
  p_display_when_type=>'EXISTS',
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
  p_id=>14615924657711238 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CHECKLISTMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 380,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''CHECKLIST'');',
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
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'select 1 from t_osi_obj_type'||chr(10)||
' where :P0_OBJ is not null'||chr(10)||
'   and sid = :P0_OBJ_TYPE_SID'||chr(10)||
'   and include_checklist_menu = ''Y'''||chr(10)||
'   and not(nvl(:P&APP_PAGE_ID._EXCLUDE_MENUS,''N'')=''Y'')',
  p_display_when_type=>'EXISTS',
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
  p_id=>14617200949817940 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_REPORTMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 390,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''REPORT'');',
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
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P0_DISPLAY_REPORTS',
  p_display_when2=>'Y',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>14632602468103876 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_VLTMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<ul class="sf-menu">'||chr(10)||
'<li id="ID_VLT" class="sf-li-top">'||chr(10)||
'<a class="sf-with-ul-top sf-with-ul" href="javascript:void(0);" onclick="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})"><img class="sf-menu-img" src="/i/themes/OSI/vlt16.gif">VLT</a>'||chr(10)||
'</li>'||chr(10)||
'</ul>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE not in (''UNIT'', ''PERSONNEL'', ''ALL.REPORT_SPEC'', ''EMM'', ''CFUNDS_EXP'', ''CFUNDS_ADV'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a class="menuButton" href="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})">VLT</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14639605790437559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_IAFISMENU',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 400,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''IAFIS'');',
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
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE=''ACT.FINGERPRINT.CRIMINAL'''||chr(10)||
'and'||chr(10)||
'((:APP_PAGE_ID between 22705 and 22720)'||chr(10)||
'or'||chr(10)||
':APP_PAGE_ID IN (20000,20100,5000,5150,5050,5100,5250,20050,5350))',
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
  p_id=>14656629600513696 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_CREATEEXAM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 410,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<ul class="sf-menu">'||chr(10)||
'<li id="ID_CREATEEXAM" class="sf-li-top">'||chr(10)||
'<a class="sf-with-ul-top sf-with-ul" href="javascript:void(0);" onclick="javascript:createActivityObject(''21001'',''ACT.POLY_EXAM'',''P21001_PARTICIPANT_VERSION,P21001_FROM_OBJ'',''&P11505_PARTICIPANT_VERSION.,&P11505_SID.'');"><img class="sf-menu-img" src="/i/themes/OSI/createexam16.gif">Create Exam</a>'||chr(10)||
'</li>'||chr(10)||
'</ul>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':APP_PAGE_ID = 11505 and '||chr(10)||
'osi_auth.check_for_priv(''ASSOC'',core_obj.lookup_objtype(''ACT.POLY_EXAM'')) = ''Y''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a class="menuButton" href="javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT&P0_OBJ.'',item_names:''P0_OBJ,P0_OBJ_CONTEXT'',item_values:''&P0_OBJ.,''})">VLT</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14657304713534876 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_RUNREPORT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<ul class="sf-menu">'||chr(10)||
'<li id="RunReport" class="sf-li-top">'||chr(10)||
'<a class="sf-with-ul-top sf-with-ul" href="f?p=&APP_ID.:802:&SESSION.::&DEBUG.::P802_REPORT_TYPE,P802_SPEC_OBJ:&P0_OBJ_CONTEXT.,&P810_OBJ."><img class="sf-menu-img" src="/i/themes/OSI/blank16.gif">Run Report</a>'||chr(10)||
'</li>'||chr(10)||
'</ul>',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE = ''ALL.REPORT_SPEC''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a id="RunReport" class="menuButton" href="f?p=&APP_ID.:802:&SESSION.::&DEBUG.::P802_REPORT_TYPE,P802_SPEC_OBJ:&P0_OBJ_CONTEXT.,&P810_OBJ.">Run Report</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14658929909561095 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_PARTICIPANTVERSIONS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 440,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OSI_MENU.GETOBJECTMENUSHTML(''&P0_OBJ.'',''VERSIONS'',''&P0_OBJ_CONTEXT.'');',
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
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'')'||chr(10)||
'and osi_participant.is_confirmed(:p0_obj) is not null'||chr(10)||
'and ('||chr(10)||
'(:APP_PAGE_ID between 30105 and 30125) or'||chr(10)||
'(:APP_PAGE_ID between 30020 and 30040) or'||chr(10)||
'(:APP_PAGE_ID = 30415 and :P0_OBJ_TYPE_CODE not in (''PART.NONINDIV.PROG'')))',
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
  p_id=>22830502735416690 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DIRTABLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 55,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
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
  p_id=>88821038812330762 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TYPE_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Type Sid',
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
  p_id=>89031738688681256 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TAGLINE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 35,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>91571912883510851 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 37,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>96945507603721723 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_CONTEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
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
  p_id=>99397625891426876 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_LOC_SELECTIONS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>100031434194073317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_PARTIC_VERSION_INFO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 450,
  p_item_plug_id => 14611614812197441+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'osi_participant.get_version_label(:p0_obj_context)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P0_OBJ_TYPE_CODE in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'')'||chr(10)||
'and osi_participant.is_confirmed(:p0_obj) is not null'||chr(10)||
'and ('||chr(10)||
'(:APP_PAGE_ID between 30105 and 30125) or'||chr(10)||
'(:APP_PAGE_ID between 30020 and 30040) or'||chr(10)||
'(:APP_PAGE_ID = 30415 and :P0_OBJ_TYPE_CODE not in (''PART.NONINDIV.PROG'')))',
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
  p_id=>100456419971725899 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DIRTY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 4445306017641973+wwv_flow_api.g_id_offset,
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
  p_id=>175627449469050216 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Type Code',
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
  p_id=>175627653625051482 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object Sid',
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
  p_id=>175628448739097322 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_TABS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 175627141504047911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Tabs',
  p_source=>'declare'||chr(10)||
'     v_result boolean;'||chr(10)||
'     v_tabs varchar2(4000) := null;'||chr(10)||
'     '||chr(10)||
'     procedure traverse_tab_parents(p_tab varchar2) is'||chr(10)||
'         v_parent t_osi_tab.parent_tab%type;'||chr(10)||
'     begin'||chr(10)||
'          v_result := core_list.add_item_to_list_front(p_tab, v_tabs);'||chr(10)||
'          '||chr(10)||
'          select parent_tab'||chr(10)||
'           into v_parent'||chr(10)||
'           from t_osi_tab'||chr(10)||
'          where sid = p_tab;'||chr(10)||
'          '||chr(10)||
'          if v_parent is not null then'||chr(10)||
'              traverse_tab_parents(v_parent);'||chr(10)||
'          end if;'||chr(10)||
'     end;'||chr(10)||
'begin'||chr(10)||
'    if :REQUEST = ''OPEN'' then'||chr(10)||
'       for i in (select sid'||chr(10)||
'                from t_osi_tab'||chr(10)||
'               where page_num = :APP_PAGE_ID'||chr(10)||
'                 and obj_type member of '||chr(10)||
'                        osi_object.get_objtypes(:P0_OBJ_TYPE_SID)'||chr(10)||
'               order by tab_level desc) loop'||chr(10)||
'          traverse_tab_parents(i.sid);'||chr(10)||
'          exit;        '||chr(10)||
'       end loop;'||chr(10)||
'       return v_tabs;'||chr(10)||
'    else'||chr(10)||
'         return :P0_TABS;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 0
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
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   08:17 Wednesday June 20, 2012
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

PROMPT ...Remove page 30600
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30600);
 
end;
/

 
--application/pages/page_30600
prompt  ...PAGE 30600: EFunds Advance
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_JQUERY_OPENLOCATOR"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'function popupCommentsWindow(){'||chr(10)||
'  var wdth = 655;'||chr(10)||
'  var hght = 425;'||chr(10)||
'  var lft = (screen.width-wdth)/2;'||chr(10)||
'  var topp = (screen.height-hght)/2;'||chr(10)||
''||chr(10)||
'  javascript:popup({page:30510,name:''DISALLOW_COMMENT'',clear_cache:''30510'','||chr(10)||
'    item_names:''P30510_FROM_ITEM'',item_values:''P30505_DISALLOW_COMMENT'','||chr(10)||
'    width:wdth,height:hght,left:lft,top:topp});'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'fun';

ph:=ph||'ction popupCoverSheet(){'||chr(10)||
'  var wdth = 720;'||chr(10)||
'  var hght = 750;'||chr(10)||
'  var lft = (screen.width-wdth)/2;'||chr(10)||
'  var topp = (screen.height-hght)/2;'||chr(10)||
''||chr(10)||
'  javascript:popup({page:30515,name:''EXPENSE_COVER_SHEET'',clear_cache:''30515'','||chr(10)||
'    item_names:''P30515_SID'',item_values:''&P30505_SID.'','||chr(10)||
'    width:wdth,height:hght,left:lft,top:topp});'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30600,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'EFunds Advance',
  p_step_title=> '&P30600_PAGE_TITLE.',
  p_html_page_onload=>'onload=" '||chr(10)||
'if (''&REQUEST.'' == ''ALL_DONE'')'||chr(10)||
'   {'||chr(10)||
'    window.opener.doSubmit();'||chr(10)||
'    window.close();'||chr(10)||
'   }'||chr(10)||
'"'||chr(10)||
'',
  p_step_sub_title => 'CFunds Advance',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215462100554475+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120620081658',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '02-Mar-2011 - TJW - CR#3712 Default Unit Locator.'||chr(10)||
'                    Added view Unit button as well.'||chr(10)||
''||chr(10)||
'15-Aug-2011 - TJW - CR#3789 Change CFunds to EFunds.'||chr(10)||
''||chr(10)||
'27-Feb-2012 - Tim Ward - CR#4002 - Changed to JQuery Locators Page #301.'||chr(10)||
''||chr(10)||
'20-Jun-2012 - Tim Ward - Changed template to Objects with Tabs and Menus'||chr(10)||
'                          so the menus built on page 0 from the Database'||chr(10)||
'                          will show up!');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30600,p_text=>ph);
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
  p_id=> 98029507020469996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30600,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 98029732132469998 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30600,
  p_plug_name=> 'EFunds Advance',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 100123509322627917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30600,
  p_plug_name=> 'General',
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
  p_plug_display_when_condition => ':P30600_STATUS = ''Closed''',
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
  p_id=> 100129828040784640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30600,
  p_plug_name=> 'Payment Details',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 50,
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
  p_plug_display_when_condition => ':P30600_STATUS = ''Active'''||chr(10)||
'or'||chr(10)||
':P30600_STATUS = ''Closed''',
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
s:=s||'select voucher_no as "ID Number", cash_amount as "Cash ($)", check_amount as "Check ($)",'||chr(10)||
'       receive_by as "Received By", receive_on as "Date Received"'||chr(10)||
'  from t_cfunds_advance_repayment_v2'||chr(10)||
' where advance = :p30600_sid';

wwv_flow_api.create_report_region (
  p_id=> 100132620861839437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30600,
  p_name=> 'Repayment Details',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 60,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P30600_STATUS = ''Active'''||chr(10)||
'or'||chr(10)||
':P30600_STATUS = ''Closed''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'QUERY_COLUMNS',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No repayment details found.',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'Y',
  p_csv_output_link_text=> 'BLANK',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_exp_filename=> '&P30600_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 100132913893839451 + wwv_flow_api.g_id_offset,
  p_region_id=> 100132620861839437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'ID Number',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Id Number',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
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
  p_id=> 100133736098843749 + wwv_flow_api.g_id_offset,
  p_region_id=> 100132620861839437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Cash ($)',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Cash ($)',
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
  p_id=> 100133837172843749 + wwv_flow_api.g_id_offset,
  p_region_id=> 100132620861839437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Check ($)',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Check ($)',
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
  p_id=> 100133207854839454 + wwv_flow_api.g_id_offset,
  p_region_id=> 100132620861839437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Received By',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Received By',
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
  p_id=> 100133330891839456 + wwv_flow_api.g_id_offset,
  p_region_id=> 100132620861839437 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Date Received',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Date Received',
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
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 98029917410469998 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30600,
  p_button_sequence=> 10,
  p_button_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30600_SID is null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 98030119584470001 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30600,
  p_button_sequence=> 30,
  p_button_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30600_SID is not null',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16056608507169982 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30600,
  p_button_sequence=> 50,
  p_button_plug_id => 100132620861839437+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this, 30600);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 98030329768470003 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30600,
  p_button_sequence=> 40,
  p_button_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:window.close();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>2764518710280446 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_branch_action=> 'f?p=&APP_ID.:30600:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_branch_condition_type=> 'REQUEST_IN_CONDITION',
  p_branch_condition=> 'SUBMIT_FOR_APPROVAL,APPROVE_ADVANCE,REJECT_ADVANCE',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-DEC-2009 11:39 by DIBBLE');
 
wwv_flow_api.create_page_branch(
  p_id=>1543007514521431 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_branch_action=> 'f?p=&APP_ID.:30600:&SESSION.:OPEN:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>98029917410469998+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 25-MAR-2010 09:52 by TIM');
 
wwv_flow_api.create_page_branch(
  p_id=>98039211147470037 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_branch_action=> 'f?p=&APP_ID.:30600:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 08-MAY-2009 12:01 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4979719216877920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_VIEW_ICON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'''<a title="View Unit" href="'''||chr(10)||
'|| osi_object.get_object_url(:P30600_REQ_UNIT_SID)'||chr(10)||
'||''">&ICON_MAGNIFY.</a>''',
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
  p_display_when=>'P30600_REQ_UNIT_SID',
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
  p_id=>16056814740171831 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
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
  p_id=>98031123036470006 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_REQUEST_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char(sysdate,''&FMT_DATE.'');',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Date of Request',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'REQUEST_DATE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width: 100px;" ',
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
  p_id=>98031514250470006 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Purpose',
  p_source=>'NARRATIVE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>98032522882470010 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_AMOUNT_REQUESTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Requested Amount',
  p_source=>'AMOUNT_REQUESTED',
  p_source_type=> 'DB_COLUMN',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '&FMT_CF_CURRENCY.');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>98032738245470010 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_ADVANCE_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to be auto-generated',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'ID Number',
  p_source=>'VOUCHER_NO',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_id=>98035321998470015 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'SID',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>98035529701470015 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_ERROR_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 98029507020469996+wwv_flow_api.g_id_offset,
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
  p_id=>98035719193470015 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_ACTION_REG_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 975,
  p_item_plug_id => 98029507020469996+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Action Reg Title',
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
  p_id=>98036130121470017 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_PAGE_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 98029507020469996+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Page Title',
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
  p_id=>99877711970669114 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_REQ_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Requested Unit Sid',
  p_source=>'UNIT',
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
  p_id=>99878131710674882 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_REQ_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Requester Unit',
  p_source=>'OSI_UNIT.GET_NAME(:P30600_REQ_UNIT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXT.',
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
  p_item_comment => '<a href="javascript:popup({page:150,name:''UNITLOC&P0_OBJ.'',clear_cache:''150'',item_names:''P150_VIEW,P150_RETURN_ITEM'',item_values:''OSI.LOC.UNIT,P30605_UNIT_SID''});">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>99878321798681396 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_REQ_UNIT_FIND_WIDGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'<a href="javascript:openLocator(''301'',''P30600_REQ_UNIT_SID'',''N'',''&P30600_REQ_UNIT_SID.'',''OPEN'','''','''',''Choose Requester Unit...'',''UNITS'',''&P0_OBJ.'');">&ICON_LOCATOR.</a>',
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
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '<a href="javascript:popupLocator(650,''P30600_REQ_UNIT_SID'',''N'',''&P30600_REQ_UNIT_SID.'');">&ICON_LOCATOR.</a>');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>99900628143891462 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_CLAIMANT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Claimant SID',
  p_source=>'CLAIMANT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>99916123988240323 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_CLAIMANT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Claimant',
  p_source=>'osi_personnel.get_name(:P30600_CLAIMANT_SID)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => '&DISABLE_TEXT.',
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
  p_id=>100079114537030278 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_SUBMITTED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Submitted On',
  p_format_mask=>'&FMT_DATE. &FMT_TIME.',
  p_source=>'SUBMITTED_ON',
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
  p_id=>100081023766099184 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_APPROVED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 13,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Approved On',
  p_format_mask=>'&FMT_DATE. &FMT_TIME.',
  p_source=>'APPROVED_ON',
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
  p_id=>100081235194102554 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_REJECTED_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Rejected On',
  p_format_mask=>'&FMT_DATE. &FMT_TIME.',
  p_source=>'REJECTED_ON',
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
  p_id=>100081413508105701 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_ISSUE_ON',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1045,
  p_item_plug_id => 100129828040784640+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Payment Issued On',
  p_format_mask=>'&FMT_DATE.',
  p_source=>'ISSUE_ON',
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
  p_id=>100081622512108354 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_CLOSE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Close Date',
  p_format_mask=>'&FMT_DATE. &FMT_TIME.',
  p_source=>'CLOSE_DATE',
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
  p_id=>100081934417121199 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 18,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Status',
  p_source_type=> 'STATIC',
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
  p_id=>100082323082174749 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_APPROVED_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 14,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Approved By',
  p_source=>'APPROVED_BY',
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
  p_id=>100084222053250106 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_ERROR',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 19,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Error',
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
  p_id=>100087032863508728 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_REJECTED_BY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 98029732132469998+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Rejected By',
  p_source=>'REJECTED_BY',
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
  p_id=>100123831485634384 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_AMT_PAID_TO_AGENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1085,
  p_item_plug_id => 100123509322627917+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Total Amount Paid To Agent $',
  p_source_type=> 'STATIC',
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
  p_id=>100124407291655748 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_AMT_REPAID_BY_AGENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1095,
  p_item_plug_id => 100123509322627917+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Amount Repaid By Agent $',
  p_source_type=> 'STATIC',
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
  p_id=>100126725869727268 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_OUTSTANDING_AMT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1105,
  p_item_plug_id => 100123509322627917+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Total Amount Outstanding $',
  p_source_type=> 'STATIC',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100130506831797474 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_CHECK_AMOUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1115,
  p_item_plug_id => 100129828040784640+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Check Amount $',
  p_source=>'CHECK_AMOUNT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=>100131035574805834 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_CHECK_NUMBER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1125,
  p_item_plug_id => 100129828040784640+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Check Number',
  p_source=>'CHECK_NUMBER',
  p_source_type=> 'DB_COLUMN',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100131215273809362 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_name=>'P30600_CASH_AMOUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1135,
  p_item_plug_id => 100129828040784640+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Cash Amount $',
  p_source=>'CASH_AMOUNT',
  p_source_type=> 'DB_COLUMN',
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
  p_id=> 4979319431868530 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_computation_sequence => 45,
  p_computation_item=> 'P30600_REQ_UNIT_SID',
  p_computation_point=> 'AFTER_HEADER',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'return osi_cfunds.get_default_charge_unit'||chr(10)||
'',
  p_computation_comment=> 'declare'||chr(10)||
''||chr(10)||
'     myCount           number;'||chr(10)||
'     myUnit            varchar2(20);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'     myUnit := osi_personnel.get_current_unit(:USER_SID);'||chr(10)||
''||chr(10)||
'     while myUnit is not null'||chr(10)||
'     loop'||chr(10)||
'     '||chr(10)||
'          select count(*) into myCount from t_cfunds_unit where sid=myUnit;'||chr(10)||
'          '||chr(10)||
'          if myCount = 1 then'||chr(10)||
'       '||chr(10)||
'            return myUnit;'||chr(10)||
''||chr(10)||
'          end if;'||chr(10)||
''||chr(10)||
'          select unit_parent into myUnit from t_osi_unit where sid=myUnit;'||chr(10)||
''||chr(10)||
'     end loop;'||chr(10)||
''||chr(10)||
'     return null;'||chr(10)||
''||chr(10)||
'end;',
  p_compute_when => 'P30600_REQ_UNIT_SID',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 98037033478470021 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_computation_sequence => 10,
  p_computation_item=> 'P30600_SID',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'ITEM_VALUE',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'P0_OBJ',
  p_compute_when => 'P30600_SID',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 98036835461470018 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30600,
  p_computation_sequence => 15,
  p_computation_item=> 'P30600_PAGE_TITLE',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'FUNCTION_BODY',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'if :P30600_SID is null then '||chr(10)||
' return ''C-Funds Expense (Create)'';'||chr(10)||
'else'||chr(10)||
' return core_obj.get_tagline(''&P30600_SID.'');'||chr(10)||
'end if;',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 99903935987959953 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'P30600_CLAIMANT_SID not null',
  p_validation_sequence=> 10,
  p_validation => 'P30600_CLAIMANT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Claimant must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 99916123988240323 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98037837956470034 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'P30600_REQUEST_DATE not null',
  p_validation_sequence=> 20,
  p_validation => 'P30600_REQUEST_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Request Date must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 98031123036470006 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98037425422470029 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'P30600_AMOUNTS',
  p_validation_sequence=> 30,
  p_validation => 'declare'||chr(10)||
'    --v_source_valid   varchar2(2);'||chr(10)||
'    --v_agent_valid    varchar2(2);'||chr(10)||
'    v_rv             boolean     := true;'||chr(10)||
'begin'||chr(10)||
'/*'||chr(10)||
'    if :p30600_source_amount is null then'||chr(10)||
'        :p30600_source_amount := ''0'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if :p30600_agent_amount is null then'||chr(10)||
'        :p30600_agent_amount := ''0'';'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    v_source_valid :='||chr(10)||
'        osi_cfunds.validate_amount(:p30600_source_amount,'||chr(10)||
'                                ''&FMT_CF_CURRENCY.'');'||chr(10)||
'    v_agent_valid :='||chr(10)||
'        osi_cfunds.validate_amount(:p30600_agent_amount,'||chr(10)||
'                                ''&FMT_CF_CURRENCY.'');'||chr(10)||
''||chr(10)||
'    if (   v_source_valid = ''N'''||chr(10)||
'        or v_agent_valid = ''N'') then'||chr(10)||
'        :p30600_error_msg :='||chr(10)||
'                  ''Source Amount and Agent Amount must both be numeric.'';'||chr(10)||
'        v_rv := false;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    -- one of the amounts needs to be greater than zero.'||chr(10)||
'    if (v_source_valid = ''Y0'' and v_agent_valid = ''Y0'') then'||chr(10)||
'        :p30600_error_msg :='||chr(10)||
'            ''Source Amount or Agent Amount must be greater than zero.'';'||chr(10)||
'        v_rv := false;'||chr(10)||
'    end if;'||chr(10)||
'*/'||chr(10)||
'  if :p30600_AMOUNT_REQUESTED < 1 then'||chr(10)||
'        :p30600_error_msg :='||chr(10)||
'            ''Amount Requested must be greater than zero.'';'||chr(10)||
'        v_rv := false;'||chr(10)||
'  end if;'||chr(10)||
'    return v_rv;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => '&P30600_ERROR_MSG.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'NEVER',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 99880219037756359 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'Amount Requested must be numeric',
  p_validation_sequence=> 30.2,
  p_validation => 'declare'||chr(10)||
'    v_test   number;'||chr(10)||
'begin'||chr(10)||
'    v_test := to_number(:p30600_amount_requested);'||chr(10)||
'/*'||chr(10)||
'    v_test := to_number(replace(replace(:p30600_amount_requested, ''.'', ''''), ''$'', ''''));'||chr(10)||
'*/'||chr(10)||
'    return true;'||chr(10)||
'exception'||chr(10)||
'    when others then'||chr(10)||
'        return false;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'Amount Requested must be numeric.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98037620359470031 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'P30600_CONVERSION_RATE',
  p_validation_sequence=> 40,
  p_validation => 'declare'||chr(10)||
'    v_num   number;'||chr(10)||
'begin'||chr(10)||
'    v_num := to_number(:p30600_conversion_rate);'||chr(10)||
''||chr(10)||
'    if (v_num > 0 and v_num is not null) then'||chr(10)||
'        return true;'||chr(10)||
'    else'||chr(10)||
'        return false;'||chr(10)||
'    end if;'||chr(10)||
'exception'||chr(10)||
'    when value_error then'||chr(10)||
'        return false;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'A positive Conversion Rate must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'NEVER',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 99879620506737823 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'P30600_AMOUNT_REQUESTED not null',
  p_validation_sequence=> 50,
  p_validation => 'P30600_AMOUNT_REQUESTED',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Requested Amount must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 98032522882470010 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 2767325084367428 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'P30600_NARRATIVE',
  p_validation_sequence=> 60,
  p_validation => 'P30600_NARRATIVE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Purpose must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 98031514250470006 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 98038007036470034 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'P30600_REQ_UNIT_SID not null',
  p_validation_sequence=> 70,
  p_validation => 'P30600_REQ_UNIT_SID',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Unit must be specified.',
  p_validation_condition=> 'SAVE,CREATE',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_associated_item=> 99878131710674882 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 14138823457907848 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_validation_name => 'Cannot Approve Your Own Advance',
  p_validation_sequence=> 80,
  p_validation => 'begin'||chr(10)||
'    if (:p30600_claimant_sid = core_context.personnel_sid) then'||chr(10)||
'        return false;'||chr(10)||
'    else'||chr(10)||
'        return true;'||chr(10)||
'    end if;'||chr(10)||
'end;',
  p_validation_type => 'FUNC_BODY_RETURNING_BOOLEAN',
  p_error_message => 'You cannot approve your own Advance.',
  p_validation_condition=> ':REQUEST = ''APPROVE_ADVANCE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 99916123988240323 + wwv_flow_api.g_id_offset,
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
'    v_test   varchar2(20);'||chr(10)||
'begin'||chr(10)||
'    :P30600_ERROR := null;'||chr(10)||
''||chr(10)||
'    if (''&REQUEST.'' = ''SUBMIT_FOR_APPROVAL'') then'||chr(10)||
'        :p30600_submitted_on := to_char(sysdate, :FMT_DATE || '' '' || :FMT_TIME);'||chr(10)||
'    elsif(''&REQUEST.'' = ''APPROVE_ADVANCE'') then'||chr(10)||
'        begin'||chr(10)||
'            cfunds_pkg.approve_advance_for_apex(:p30600_sid);'||chr(10)||
'            :p30600_approved_on := to_char(sysdate, :FMT_DATE || '' '' || :FMT';

p:=p||'_TIME);'||chr(10)||
'            :p30600_approved_by := core_context.personnel_name;'||chr(10)||
'        exception'||chr(10)||
'            when others then'||chr(10)||
'                :P30600_ERROR := cfunds_pkg.get_error_detail;'||chr(10)||
'        end;'||chr(10)||
'    elsif(''&REQUEST.'' = ''REJECT_ADVANCE'') then'||chr(10)||
'        :p30600_rejected_on := to_char(sysdate, :FMT_DATE || '' '' || :FMT_TIME);'||chr(10)||
'        :P30600_rejected_by := core_context.personnel_name;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'    if';

p:=p||' (:P30600_ERROR is null or length(:P30600_ERROR) < 20) then'||chr(10)||
'         :P30600_ERROR := ''You must save this Advance for the changes to take effect.'';'||chr(10)||
'    end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 98038333564470035 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Prep for Update',
  p_process_sql_clob => p, 
  p_process_error_message=> '&P30600_ERROR.',
  p_process_when=>'SUBMIT_FOR_APPROVAL,APPROVE_ADVANCE,REJECT_ADVANCE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_when2=>',APPROVE_EXPENSE,DISALLOW_EXPENSE,P30600_CLAIMANT,',
  p_process_when_type2=>'',
  p_process_success_message=> '&P30600_ERROR.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'Each of the request values in the condition indicates that an update needs to take place, so the value of :REQUEST is changed to ''Update'', so the DML process will fire. Note that ''Update'' is used intentionally, because ''Save'' results in ALL_DONE being set, which causes the window to close.');
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
p:=p||'#OWNER#:T_CFUNDS_ADVANCE_V2:P30600_SID:SID|IUD';

wwv_flow_api.create_page_process(
  p_id     => 98038522559470035 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'ARP',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'SAVE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '&SUCCESS_MSG.',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30600_SID',
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
'    :p0_obj:='||chr(10)||
'        osi_cfunds_adv.create_instance(:p0_obj_type_sid,'||chr(10)||
'                                       :p30600_claimant_sid,'||chr(10)||
'                                       :p30600_amount_requested,'||chr(10)||
'                                       :p30600_req_unit_sid,'||chr(10)||
'                                       :p30600_advance_id,'||chr(10)||
'                                       :p30600_narrative,'||chr(10)||
'                   ';

p:=p||'                    :p30600_request_date);'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 99928309190642926 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'CREATE Instance',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'CREATE',
  p_process_when_type=>'REQUEST_IN_CONDITION',
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
p:=p||'F|#OWNER#:T_CFUNDS_ADVANCE_V2:P30600_SID:SID';

wwv_flow_api.create_page_process(
  p_id     => 98038731663470035 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST <> ''CREATE_OBJ''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P30600_SID',
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
':P30600_STATUS := cfunds_pkg.get_advance_status(    to_date(:p30600_submitted_on, :fmt_date || '' '' || :fmt_time),'||chr(10)||
'                                  to_date(:p30600_approved_on, :fmt_date || '' '' || :fmt_time),'||chr(10)||
'                                  to_date(:p30600_rejected_on, :fmt_date || '' '' || :fmt_time),'||chr(10)||
'                                  to_date(:p30600_issue_on, :fmt_date || '' '' || :fmt_time';

p:=p||'),'||chr(10)||
'                                  to_date(:p30600_close_date, :fmt_date || '' '' || :fmt_time)'||chr(10)||
');'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14137918777868706 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 30,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Status',
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
'    --:P30600_REQ_UNIT_SID := OSI_PERSONNEL.get_current_unit(CORE_CONTEXT.PERSONNEL_SID);'||chr(10)||
''||chr(10)||
'    :P30600_CLAIMANT_SID := CORE_CONTEXT.PERSONNEL_SID;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 99900936239903237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 35,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Defaults',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P30600_SID is null',
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
'  :P30600_TOTAL_AMOUNT_PAID := :P30600_CASH_AMOUNT + :P30600_CHECK_AMOUNT;'||chr(10)||
'  :P30600_TOTAL_REPAID := CFUNDS_PKG.Get_Advance_Total_Repayments(:P0_OBJ);'||chr(10)||
'  :P30600_TOTAL_CREDITED := :P30600_TOTAL_REPAID + :P30600_EXPENSED_AMOUNT;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 98061235807013534 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 40,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Calculate Totals',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'',
  p_process_when_type=>'NEVER',
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
'    v_paid     number;'||chr(10)||
'    v_repaid   number;'||chr(10)||
'begin'||chr(10)||
'    v_repaid := 0;'||chr(10)||
'    v_paid := 0;'||chr(10)||
''||chr(10)||
'    for k in (select check_amount, cash_amount'||chr(10)||
'                from t_cfunds_advance_v2'||chr(10)||
'               where sid = :p30600_sid)'||chr(10)||
'    loop'||chr(10)||
'        --Note, there will only be one record here'||chr(10)||
'        v_paid := k.check_amount + k.cash_amount;'||chr(10)||
'        :p30600_amt_paid_to_agent := v_paid;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    f';

p:=p||'or k in (select check_amount, cash_amount'||chr(10)||
'                from t_cfunds_advance_repayment_v2'||chr(10)||
'               where advance = :p30600_sid)'||chr(10)||
'    loop'||chr(10)||
'        v_repaid := v_repaid + k.check_amount + k.cash_amount;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    :p30600_amt_repaid_by_agent := v_repaid;'||chr(10)||
'    :p30600_outstanding_amt := v_paid - v_repaid;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 100124010623647293 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30600,
  p_process_sequence=> 50,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Closed Totals',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':P30600_SID is not null',
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
-- ...updatable report columns for page 30600
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

