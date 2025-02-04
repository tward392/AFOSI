-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE           "CORE_UTIL" as
/*
    Core_Util: Adapted from various legacy procedures, functions and packages.

    31-Aug-2005 RWH     Originally assembled from legacy pieces.
                            Added: Get_Config, Blob_Size, Blob_Thumbnail
    02-Dec-2005 RWH     Added Date_Precision and Date_Format functions.
    21-Dec-2005 RWH     Use new Pipe naming conventions.
    04-Jan-2006 RWH     Added Append_Info_To_Clob.
    26-Jan-2006 RWH     Added Deliver_Blob.
    27-Jan-2006 RWH     Updated some LOB routines to take advantage of current
                        LOB semantics.
    02-Feb-2006 RWH     Started adding string utilities. First is Append_Info.
    06-Feb-2006 CJP     Added function to accept a mimetype and filename and will return an html img line to display an image
                            that is representitive of the type of file.  Mapping is located in T_CORE_MIME_IMAGE.
    23-May-2006 CJP     Altered mimetype function to return an "other" image if the
                            mimetype or file extension cannot be resolved.
    20-Jul-2006 RWH     Added No_Cache parameter to the Deliver_Blob routine(s).
    09-Aug-2006 CJP     Added Serve Clob.
    29-Sep-2006 RWH     Added Escape_Mode to Serve_Clob. Added Serve_DB_Clob procedure.
    05-Oct-2006 RWH     Added Last_Mod_Date to Deliver_Blob routines.
    24-Oct-2006 RWH     Added Boolean_to_String to convert a boolean value to a string.
    20-Dec-2006 RWH     Added Format_Date, which formats a date to a specified "canned" format
                            string. If the format is not specified, the format is determined
                            from the specified date.
    02-Mar-2007 RWH     Added Put_Config, which inserts or updates a row in T_CORE_CONFIG.
    10-Oct-2007 RWH     Added HTML format/sorting routines Format_for_HTML_Sort.
    26-Feb-2008 RWH     Added Ticket processing routines which support various integration efforts
                            (portals, 2-factor authentication, etc.).
    03-Mar-2008 RWH     Turned the new Get_Ticket function into a procedure (with an output
                            parameter) because procedures are easier to deal with in ADO.
    13-Jun-2008 RWH     Added new Email_Send routine.
    31-Jul-2008 DWB     Added the RESET_TICKET_TIME procedure.
    10-Oct-2008 RWH     Added Fix_Null function. Added Build_Custom_DML_Blocks.
*/

    /*
        General Utilities

        Boolean_to_String: Returns string representation of specified boolean. (True, False, Null)
        Get_Config: Returns value from T_CORE_CONFIG for specified Item.
        Put_Config: Inserts or updates a row in T_CORE_CONFIG.
        Quot: Returns specified string surrounded by ', with all internal ' replaced with ''.
        Fix_Null: Turns "%null%" into a real NULL. Useful when processing values from certain
            types of OAE items such as select lists.
    */
    function BOOLEAN_TO_STRING(P_BOOL in boolean)
        return Varchar2;

    function GET_CONFIG(P_ITEM in Varchar2)
        return Varchar2;

    procedure PUT_CONFIG(P_ITEM in Varchar2, P_VALUE in Varchar2);

    function QUOT(P_STRING in Varchar2)
        return Varchar2;

    function FIX_NULL(P_VAL in Varchar2)
        return Varchar2;

    -- BLOB Utilities
    function BLOB_SIZE(P_BLOB in Blob)
        return Number;

    function BLOB_THUMBNAIL(P_BLOB in Blob, P_MAX_SIZE in Number)
        return Blob;

    /*
        Deliver_Blob: Sends the specified Blob (Clob) to the browser, along with corresponding
            MIME headers which reflect the other specified parameters. If Last_Mod_Date is not
            specified, then no "Last-Modified:" header will be sent.
    */
    procedure DELIVER_BLOB(
        P_CLOB               in out nocopy   Clob,
        P_MIME_TYPE          in              Varchar2 := 'application/octet',
        P_MIME_DISPOSITION   in              Varchar2 := 'ATTACHMENT',
        P_FILENAME           in              Varchar2 := null,
        P_NO_CACHE           in              boolean := false,
        P_LAST_MOD_DATE      in              Date := null);

    procedure DELIVER_BLOB(
        P_BLOB               in out nocopy   Blob,
        P_MIME_TYPE          in              Varchar2 := 'application/octet',
        P_MIME_DISPOSITION   in              Varchar2 := 'ATTACHMENT',
        P_FILENAME           in              Varchar2 := null,
        P_NO_CACHE           in              boolean := false,
        P_LAST_MOD_DATE      in              Date := null);

    -- CLOB Utilities
    procedure APPEND_INFO_TO_CLOB(
        P_ORIGINAL    in out nocopy   Clob,
        P_APPEND      in              Varchar2,
        P_SEPARATOR   in              Varchar2 := ', ');

    procedure CLEANUP_TEMP_CLOB(P_CLOB in out nocopy Clob);

    function CLOB_REPLACE(P_TEXT in Clob, P_SEARCHFOR in Varchar2, P_REPLACEMENT in Varchar2)
        return Clob;

    function CLOB_SIZE(P_CLOB in Clob)
        return Number;

    function CLOB_TEXT(P_CLOB in Clob, P_MAXSIZE in Number)
        return Varchar2;

    function HTML_IZE(P_CLOB in Clob)
        return Clob;

    /*
        Sends the contents of Clob to the webserver (as a response), starting
        at Offset (defaults to 1), for Length characters (defaults to remainder
        of the Clob). Escape_Mode can be NONE (default), HTML or JSCRIPT. Escaping
        means changing certain characters in the source string so that the result
        is suitable for the intended use (HTML or JSCRIPT). An example substitution
        for HTML is "<" is replaced with "&lt;"
    */
    function SERVE_CLOB(
        P_CLOB          in   Clob,
        P_OFFSET        in   Number := null,
        P_LENGTH        in   Number := null,
        P_ESCAPE_MODE   in   Varchar2 := 'NONE')
        return Varchar2;

    /*
        Serves a complete clob from the specified Table/Column/Row(SID). Leverages Serve_Clob.
        If the identified clob is null/empty, the NDF_Msg is served.
    */
    procedure SERVE_DB_CLOB(
        P_TABLE         in   Varchar2,
        P_COLUMN        in   Varchar2,
        P_SID           in   Varchar2,
        P_NDF_MSG       in   Varchar2,
        P_ESCAPE_MODE   in   Varchar2 := 'HTML');

    /*
        Date Utilities: Provide ability to deal with date values that have "precision" encoded
            into them. Dates can have precision encoded into them by using special values for
            certain date/time fields. Specifically:

            If HHMISS     = 000000     then precision = 'Day'
            If MMDDHHMISS = 0101000002 then precision = 'Year'
            If DDHHMISS   = 01000001   then precision = 'Month'
                                       else precision = 'Second'

        The p_Format parameter is a string that must be either "Second", "Day", "Month" or "Year".

        The actual date formatting strings used are acquired from configuration items identified by
        codes CORE.DATE_FMT_SECOND|DAY|MONTH|YEAR.

        Date_Precision: Returns "Second" | "Day" | "Month" | "Year" based on the specified date.
        Date_Format: Returns the actual Oracle data format string for the specified precision.
        Format_Date: Formats the specified date according to the specified precision (P_Format). If
            P_Format is not specified, it is determined from the specified P_Date.
    */
    function DATE_PRECISION(P_DATE in Date)
        return Varchar2;

    function DATE_FORMAT(P_FORMAT in Varchar2)
        return Varchar2;

    function FORMAT_DATE(P_DATE in Date, P_FORMAT in Varchar2 := null)
        return Varchar2;

    -- String Utilities
    procedure APPEND_INFO(
        P_ORIGINAL    in out nocopy   Varchar2,
        P_APPEND      in              Varchar2,
        P_SEPARATOR   in              Varchar2 := ', ');

    --Mime type / file type Utilities
    function GET_MIME_ICON(P_MIME_TYPE in Varchar2, P_FILE_NAME in Varchar2)
        return Varchar2;

    /*
        HTML formatting/sorting utilities: Formats date and number values according to specified
            format masks, but does so such that the resulting display can still be sorted correctly
            using a simple ASCII collating sequence. This is accomplished by prefixing the displayable
            output with (non-displayable) inline comments that will be used for the actual sort. The
            functions are overloaded so that it will appear that both dates and numbers can be
            passed into the routine.

            The format masks used for display purposes can be specified, or a default will be used.
            For DATE formatting, the first default format string will be acquired from the config
            item CORE.HTML_SORT_DATE_FMT. If that item does not exist, then the format will be based
            on the precision of the specified date value.

            For NUMBER formatting, the default format string will be acquired from the config item
            CORE.HTML_SORT_INTEGER_FMT, or CORE.HTML_SORT_FLOAT_FMT, depending on if the specified
            number value. If that item does not exist, an internal default will be used.

            The optional Alignment parameter can be left | center | right.
    */
    function FORMAT_FOR_HTML_SORT(
        P_DATE     in   Date,
        P_FORMAT   in   Varchar2 := null,
        P_ALIGN    in   Varchar2 := 'left')
        return Varchar2;

    function FORMAT_FOR_HTML_SORT(
        P_NUM      in   Number,
        P_FORMAT   in   Varchar2 := null,
        P_ALIGN    in   Varchar2 := 'right')
        return Varchar2;

    /*
        Ticket Processing routines: Used to create and check tickets.
            Get_Ticket: Generates a new ticket for the specified holder, and returns that ticket
                to the caller. If any error occurs, NULL is returned. Optionally, you can specify
                the number of seconds the ticket will be valid for.
            Get_Holder: Returns the holder of the specified ticket. If any error occurs, or if
                the ticket has expired, NULL is returned.
            Reset_Ticket_Time: If the ticket is not expired, resets the the ticket issue time
                to the current time.

    */
    procedure CREATE_TICKET(P_HOLDER in Varchar2, P_DURATION in Number := -1);

    procedure GET_TICKET(P_HOLDER in Varchar2, P_TICKET out Varchar2, P_DURATION in Number := -1);

    function GET_TICKET_HOLDER(P_TICKET in Varchar2)
        return Varchar2;

    procedure RESET_TICKET_TIME(P_TICKET in Varchar2);

    /*
        Email routines: Used to send email messages. Several CORE_CONFIG entries are used. They
            all begin with CORE.EMAIL_. Routines return "OK" if successful, or "ERROR: some error"
            if not.
    */
    function EMAIL_SEND(
        P_RECIPIENT   in   Varchar2,
        P_SUBJECT     in   Varchar2,
        P_MSG         in   Varchar2,
        P_SENDER      in   Varchar2 := null,
        P_SEND_HOST   in   Varchar2 := null,
        P_MAIL_HOST   in   Varchar2 := null,
        P_MAIL_PORT   in   Number := null)
        return Varchar2;

    /*
        Custom DML Processing: The following routine supports OAE situations where normal ARF
            (Automatic Row Fetch) and ARP (Automatic Row Processing) is inadequate or too cumbersome
            to use. A common such situation is when a page requires several "select list with submits"
            that are used to drive conditional rendering.

            The strategy behind this approach is that the page items are NOT defined with a
            source of DATABASE COLUMN, but are instead "Static". Instead of using ARF and ARP
            processes, custom DML processes are used to load the data into the page items and to
            provide the subsequent Insert, Update and Delete processing.

            The Build_Custom_DML_Blocks function will return a set of anonymous blocks that can be
            used as the basis for these custom processes. These blocks are built with awareness of
            the table/view that constains the data, and the app/page that will ultimately hold the
            processes. That said, the processes should still be reviewed for suitability to each
            situation.

            To use this function, first create the OAE page with the page items corresponding to the
            columns that you want to process. The page item name (after the P[page]_) must match the
            database column name exactly. Specify the type of item (text box, select list, etc), and
            specify any data format if applicable (common for dates and numbers). Then, run this
            function (select ... from dual), and copy/paste the blocks into corresponding processes
            in the target page.

            This function places several requirements on the target page. Specifically, the target
            page must have a _SID item that identifies the row to be selected/processed. The page
            must have a _CRC item that is used to implement "lost update detection". This need not
            be a visible page item. The page needs a _NEED_FETCH item which is used to control when
            the select/fetch process is fired and is managed by the generated insert/update blocks.

            The generated blocks will only select and process columns that have corresponding page
            items. Furthermore, page items that "do not save state" are not included in the Insert
            or Update processing (but they are selected). Also, the SID, CREATE_BY, CREATE_ON,
            MODIFY_BY and MODIFY_ON columns are never processed by the Insert and Update blocks.
            When the Insert and Update statements are generated, the data format (from the page
            item) is used to convert between the database value and OAE item (string) value, and
            if the item uses an LOV, the Fix_Nulls function is used.

            The generated block have only basic formatting applied, and it is strongly suggested
            that the blocks be formatted in TOAD before incorporation in the OAE page.

            Note that if page items are added or removed, the resulting custom DML processes will
            have to be updated accordingly. The easiest way to do this is to re-generate the blocks.
            This means that it will be advantageous to NOT put additional processing inside the
            generated blocks, but instead use separate processes in those situations.

            Parameter descriptions:
                Tab_Name: Name of table or view to be processed.
                App_ID:   OAE application number (usually in the 100's).
                Page_ID:  Page number within App_ID.
                SID_Function: If null, the Insert block will use a "returning SID into ..." clause.
                              If not null, a statement will be generated that sets the SiD item
                              to the value of the specified SID Function. This could be something
                              like "Core_Sidgen.Last_Sid". Default is null.
    */
    function BUILD_CUSTOM_DML_BLOCKS(
        P_TAB_NAME       in   Varchar2,
        P_APP_ID         in   Number,
        P_PAGE_ID        in   Number,
        P_SID_FUNCTION   in   Varchar2 := null)
        return Varchar2;
end CORE_UTIL;
/


CREATE OR REPLACE PACKAGE BODY           "CORE_UTIL" as
/*
    Core_Util: Adapted from various legacy procedures, functions and packages.

    31-Aug-2005 RWH     Originally assembled from legacy pieces.
                            Added: Get_Config, Blob_Size, Blob_Thumbnail
    02-Dec-2005 RWH     Added Date_Precision and Date_Format functions.
    21-Dec-2005 RWH     Use new Pipe naming conventions.
    04-Jan-2006 RWH     Added Append_Info_To_Clob.
    26-Jan-2006 RWH     Added Deliver_Blob.
    27-Jan-2006 RWH     Updated some LOB routines to take advantage of current
                        LOB semantics.
    02-Feb-2006 RWH     Started adding string utilities. First is Append_Info.
    06-Feb-2006 CJP     Added function to accept a mimetype and filename and will return an html img line to display an image
                            that is representitive of the type of file.  Mapping is located in T_CORE_MIME_IMAGE.
    23-May-2006 CJP     Altered mimetype function to return an "other" image if the
                            mimetype or file extension cannot be resolved.
    09-Aug-2006 CJP     Added Serve Clob.
    20-Sep-2006 RWH     Made date formats configuration items.
    29-Sep-2006 RWH     Added Escape_Mode to Serve_Clob.
    05-Oct-2006 RWH     Added Last_Mod_Date to Deliver_Blob routines.
    18-Oct-2006 RWH     Removed the warning message when Serve_Clob gets an empty value.
    24-Oct-2006 RWH     Added Boolean_to_String to convert a boolean value to a string.
    29-Nov-2006 RWH     In Serve_(DB_)Clob, enhanced logging. Removed unnecessary
                            Cleanup_Temp_Clob.
    20-Dec-2006 RWH     Added Format_Date, which formats a date to a specified "canned" format
                            string. If the format is not specified, the format is determined
                            from the specified date.
    02-Mar-2007 RWH     Added Put_Config, which inserts or updates a row in T_CORE_CONFIG.
    26-Aug-2007 RWH     Added HTTP/1.1 Cache-Control headers to the Deliver_Blob routines.
    10-Oct-2007 RWH     Added HTML format/sorting routines Format_for_HTML_Sort.
    26-Feb-2008 RWH     Added Ticket processing routines which support various integration efforts
                            (portals, 2-factor authentication, etc.).
    03-Mar-2008 RWH     Turned the new Get_Ticket function into a procedure (with an output
                            parameter) because procedures are easier to deal with in ADO.
    13-Jun-2008 RWH     Added Email_Send.
    31-Jul-2008 DWB     Added the RESET_TICKET_TIME procedure and reworked the way
                        the ticket functions work internally to support. Existing functions
                        still provide the same behavior, only internal logic was changed.
    10-Oct-2008 RWH     Added Fix_Null function. Added Build_Custom_DML_Blocks function.
*/
    C_PIPE   Varchar2(100) := nvl(CORE_UTIL.GET_CONFIG('CORE.PIPE_PREFIX'), 'I2G.') || 'CORE_UTIL';

    -- General Utilities
    function BOOLEAN_TO_STRING(P_BOOL in boolean)
        return Varchar2 is
    begin
        case P_BOOL
            when null then
                return 'Null';
            when true then
                return 'True';
            when false then
                return 'False';
        end case;
    end BOOLEAN_TO_STRING;

    function GET_CONFIG(P_ITEM in Varchar2)
        return Varchar2 is
        V_RTN   T_CORE_CONFIG.SETTING%type;
    begin
        select SETTING
          into V_RTN
          from T_CORE_CONFIG
         where CODE = P_ITEM;

        return V_RTN;
    exception
        when NO_DATA_FOUND then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Get_Config: Could not find config value for: ' || P_ITEM);
            return null;
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Get_Config: ' || sqlerrm);
            return null;
    end GET_CONFIG;

    procedure PUT_CONFIG(P_ITEM in Varchar2, P_VALUE in Varchar2) is
    begin
        if P_ITEM is null then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Put_Config: No Item specified');
            return;
        end if;

        update T_CORE_CONFIG
           set SETTING = P_VALUE
         where CODE = P_ITEM;

        if sql%rowcount = 0 then
            insert into T_CORE_CONFIG
                        (CODE, SETTING)
                 values (P_ITEM, P_VALUE);

            if sql%rowcount <> 1 then
                CORE_LOGGER.LOG_IT(C_PIPE, 'Put_Config: Could not insert new row');
            end if;
        end if;

        return;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Put_Config: ' || sqlerrm);
    end PUT_CONFIG;

    function QUOT(P_STRING in Varchar2)
        return Varchar2 is
    begin
        return '''' || replace(P_STRING, '''', '''''') || '''';
    end QUOT;

    function FIX_NULL(P_VAL in Varchar2)
        return Varchar2 is
    begin
        if P_VAL = '%null%' then
            return null;
        else
            return P_VAL;
        end if;
    end FIX_NULL;

    -- BLOB Utilities
    function BLOB_SIZE(P_BLOB in Blob)
        return Number is
        V_RTN   Number;
    begin
        V_RTN := DBMS_LOB.GETLENGTH(P_BLOB);
        return V_RTN;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Blob_Size: ' || sqlerrm);
            return null;
    end BLOB_SIZE;

    function BLOB_THUMBNAIL(P_BLOB in Blob, P_MAX_SIZE in Number)
        return Blob is
        V_DST   Blob;
    begin
        DBMS_LOB.CREATETEMPORARY(V_DST, true);
        DBMS_LOB.OPEN(V_DST, DBMS_LOB.LOB_READWRITE);
        ORDSYS.ORDIMAGE.PROCESSCOPY(P_BLOB, 'maxScale=' || P_MAX_SIZE || ' ' || P_MAX_SIZE, V_DST);
        DBMS_LOB.CLOSE(V_DST);
        -- DBMS_LOB.FREETEMPORARY (V_DST);
        -- V_DST := null;
        return V_DST;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Blob_Thumbnail: ' || sqlerrm);
            return null;
    end BLOB_THUMBNAIL;

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

    procedure DELIVER_BLOB(
        P_BLOB               in out nocopy   Blob,
        P_MIME_TYPE          in              Varchar2 := 'application/octet',
        P_MIME_DISPOSITION   in              Varchar2 := 'ATTACHMENT',
        P_FILENAME           in              Varchar2 := null,
        P_NO_CACHE           in              boolean := false,
        P_LAST_MOD_DATE      in              Date := null) is
        V_DISP_LINE   Varchar2(300);
    begin
        OWA_UTIL.MIME_HEADER(nvl(P_MIME_TYPE, 'application/octet'), false);
        HTP.p('Content-length: ' || DBMS_LOB.GETLENGTH(P_BLOB));

        if P_NO_CACHE then
            HTP.p('Pragma: no-cache');
            HTP.p('Cache-Control: no-cache, no-store, must-revalidate');
        end if;

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
        WPG_DOCLOAD.DOWNLOAD_FILE(P_BLOB);
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Deliver_Blob Error: ' || sqlerrm);
            raise;
    end DELIVER_BLOB;

    -- CLOB Utilities
    procedure APPEND_INFO_TO_CLOB(
        P_ORIGINAL    in out nocopy   Clob,
        P_APPEND      in              Varchar2,
        P_SEPARATOR   in              Varchar2 := ', ') is
        -- these local variable are used only for error reporting
        V_ORIG         Varchar2(50);
        V_LEN_ORIG     Number;
        V_LEN_APPEND   Number;
        V_LEN_SEP      Number;
    begin
        V_ORIG := DBMS_LOB.SUBSTR(P_ORIGINAL, 50, 1);        -- save in case we need to report them
        V_LEN_ORIG := nvl(DBMS_LOB.GETLENGTH(P_ORIGINAL), 0);
        V_LEN_APPEND := nvl(length(P_APPEND), 0);
        V_LEN_SEP := nvl(length(P_SEPARATOR), 0);

        if P_ORIGINAL is null then                                            -- create a temp clob
            DBMS_LOB.CREATETEMPORARY(P_ORIGINAL, true);
        end if;

        if DBMS_LOB.ISOPEN(P_ORIGINAL) = 0 then                              -- open it (read-write)
            DBMS_LOB.OPEN(P_ORIGINAL, DBMS_LOB.LOB_READWRITE);
        end if;

        if P_APPEND is not null then                                     -- we're gonna do something
            if V_LEN_ORIG > 0 and V_LEN_SEP > 0 then                          -- need the separator
                DBMS_LOB.WRITEAPPEND(P_ORIGINAL, V_LEN_SEP, P_SEPARATOR);
            end if;

            DBMS_LOB.WRITEAPPEND(P_ORIGINAL, V_LEN_APPEND, P_APPEND);
        end if;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Append_Info_to_Clob Error: ' || sqlerrm);
            CORE_LOGGER.LOG_IT(C_PIPE,
                               '  Orig/Append/Sep lengths: ' || V_LEN_ORIG || '/' || V_LEN_APPEND
                               || '/' || V_LEN_SEP);
            CORE_LOGGER.LOG_IT(C_PIPE, '  Start of Orig: ' || V_ORIG);
    -- by not re-raising the exception, the routine will complete
    -- without error, and pOriginal will be as full as it can be.
    end APPEND_INFO_TO_CLOB;

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

    function CLOB_REPLACE(P_TEXT in Clob, P_SEARCHFOR in Varchar2, P_REPLACEMENT in Varchar2)
        return Clob is
        V_WORK      Clob;
        V_SQLERRM   Varchar2(1000);
        V_START     Number         := 1;
        V_END       Number;
        V_SIZE      Number;
        V_TAG       Varchar2(100);
        V_TEXT      Varchar2(50);
        V_SEARCH    Varchar2(10);
        V_REPLACE   Varchar2(10);
    begin
        V_TAG := 'Saving Parameters';
        V_TEXT := DBMS_LOB.SUBSTR(P_TEXT, 50, 1);
        V_SEARCH := substr(P_SEARCHFOR, 1, 10);
        V_REPLACE := substr(P_REPLACEMENT, 1, 10);
        V_TAG := 'Creating Temp';
        DBMS_LOB.CREATETEMPORARY(V_WORK, false);
        V_TAG := 'Opening Temp';
        DBMS_LOB.OPEN(V_WORK, DBMS_LOB.LOB_READWRITE);

        if nvl(length(V_TEXT), 0) = 0 then
            V_TAG := 'Returning empty clob';
            DBMS_LOB.CLOSE(V_WORK);
            return V_WORK;
        end if;

        if P_SEARCHFOR is null then
            V_TAG := 'Copying Original';
            DBMS_LOB.COPY(V_WORK, P_TEXT, DBMS_LOB.GETLENGTH(P_TEXT));
            DBMS_LOB.CLOSE(V_WORK);
            return V_WORK;
        end if;

        loop
            V_TAG := 'Getting length of Temp';
            V_SIZE := DBMS_LOB.GETLENGTH(V_WORK);
            V_TAG := 'Searching Text';
            V_END := DBMS_LOB.INSTR(P_TEXT, P_SEARCHFOR, V_START);

            if nvl(V_END, 0) = 0 then                                -- copy rest of pText and exit
                V_TAG := 'Copying Remainder';
                DBMS_LOB.COPY(V_WORK, P_TEXT, DBMS_LOB.LOBMAXSIZE,(V_SIZE + 1), V_START);
                exit;
            end if;

            -- Copy upto the found value
            if V_END > V_START then
                V_TAG := 'Copying First Part';
                DBMS_LOB.COPY(V_WORK, P_TEXT,(V_END - V_START),(V_SIZE + 1), V_START);
            end if;

            -- Append the replacement value
            if length(P_REPLACEMENT) > 0 then
                V_TAG := 'Appending Replacement';
                DBMS_LOB.WRITEAPPEND(V_WORK, length(P_REPLACEMENT), P_REPLACEMENT);
            end if;

            V_START := V_END + length(P_SEARCHFOR);
            exit when V_START > DBMS_LOB.GETLENGTH(P_TEXT);
        end loop;

        V_TAG := 'Returning Temp';
        DBMS_LOB.CLOSE(V_WORK);
        return V_WORK;
    exception
        when OTHERS then
            V_SQLERRM := sqlerrm;
            CORE_LOGGER.LOG_IT(C_PIPE, 'Clob_Replace Error (' || V_TAG || '): ' || V_SQLERRM);
            CORE_LOGGER.LOG_IT(C_PIPE,
                               '  Text/Search/Replacement: ' || V_TEXT || '/' || V_SEARCH || '/'
                               || V_REPLACE);

            if DBMS_LOB.GETLENGTH(P_TEXT) > 0 then
                DBMS_LOB.COPY(V_WORK, P_TEXT, DBMS_LOB.GETLENGTH(P_TEXT));
            end if;

            DBMS_LOB.CLOSE(V_WORK);
            return V_WORK;
    end CLOB_REPLACE;

    function CLOB_SIZE(P_CLOB in Clob)
        return Number is
        V_RTN   Number;
    begin
        V_RTN := DBMS_LOB.GETLENGTH(P_CLOB);
        return V_RTN;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Clob_Size: ' || sqlerrm);
            return null;
    end CLOB_SIZE;

    function CLOB_TEXT(P_CLOB in Clob, P_MAXSIZE in Number)
        return Varchar2 is
        V_TMP   Varchar2(32000) := null;
        V_MAX   Number          := P_MAXSIZE;
    begin
        if    P_CLOB is null
           or P_MAXSIZE < 1 then
            return null;
        end if;

        if V_MAX > 32000 then
            V_MAX := 32000;
        end if;

        -- dbms_lob.open(P_CLOB, dbms_lob.LOB_READONLY);
        DBMS_LOB.READ(P_CLOB, V_MAX, 1, V_TMP);
        -- dbms_lob.close(P_CLOB);
        return V_TMP;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Clob_Text: ' || sqlerrm);
            return null;
    end CLOB_TEXT;

    function HTML_IZE(P_CLOB in Clob)
        return Clob is
        V_CLOB   Clob;
    begin
        V_CLOB := CLOB_REPLACE(P_CLOB, chr(13), null);
        V_CLOB := CLOB_REPLACE(V_CLOB, chr(10), '<br>');
        return V_CLOB;
    end HTML_IZE;

    function SERVE_CLOB(
        P_CLOB          in   Clob,
        P_OFFSET        in   Number := null,
        P_LENGTH        in   Number := null,
        P_ESCAPE_MODE   in   Varchar2 := 'NONE')
        return Varchar2 is
        V_LEN   Number;
        V_OFF   Number;
        V_STR   Varchar2(20000);
    begin
        if    P_CLOB is null
           or DBMS_LOB.GETLENGTH(P_CLOB) < 1 then
            CORE_LOGGER.LOG_IT(C_PIPE, 'SERVE_CLOB: P_CLOB is 0 length or null.');
            -- htp.PRN('<!--SERVE_CLOB RECEIVED CLOB of 0 LENGTH-->');
            return 'Y';
        end if;

        V_OFF := nvl(P_OFFSET, 1);
        V_LEN := nvl(P_LENGTH, DBMS_LOB.GETLENGTH(P_CLOB) - V_OFF + 1);
        CORE_LOGGER.LOG_IT(C_PIPE,
                           'SERVE_CLOB: OFFSET=' || V_OFF || ', LENGTH=' || V_LEN
                           || ', ESCAPE_MODE=' || P_ESCAPE_MODE);

        loop
            V_STR := DBMS_LOB.SUBSTR(P_CLOB, least(V_LEN, 10000), V_OFF);
            exit when V_STR is null;
            CORE_LOGGER.LOG_IT(C_PIPE,
                               'SERVE_CLOB: Serving ' || length(V_STR) || ' bytes from offset '
                               || V_OFF || ' (before escaping)');
            V_OFF := V_OFF + length(V_STR);
            V_LEN := V_LEN - length(V_STR);

            case nvl(P_ESCAPE_MODE, 'NONE')
                when 'HTML' then
                    V_STR := replace(V_STR, '&', '&amp;');
                    V_STR := replace(V_STR, '<', '&lt;');
                    V_STR := replace(V_STR, '>', '&gt;');
                    V_STR := replace(V_STR, '"', '&quot;');
                    V_STR := replace(V_STR, chr(13), null);
                    V_STR := replace(V_STR, chr(10), '<br>');
                when 'JSCRIPT' then
                    V_STR := replace(V_STR, '\', '\\');
                    V_STR := replace(V_STR, '''', '\''');
                    V_STR := replace(V_STR, chr(13), '');
                    V_STR := replace(V_STR, chr(10), '\n');
                else
                    null;
            end case;

            HTP.PRN(V_STR);
            CORE_LOGGER.LOG_IT(C_PIPE,
                               'SERVE_CLOB: Served ' || length(V_STR) || ' bytes (after escaping)');
        end loop;

        return 'Y';
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'SERVE_CLOB Error: ' || sqlerrm);
            return 'N';
    end SERVE_CLOB;

    procedure SERVE_DB_CLOB(
        P_TABLE         in   Varchar2,
        P_COLUMN        in   Varchar2,
        P_SID           in   Varchar2,
        P_NDF_MSG       in   Varchar2,
        P_ESCAPE_MODE   in   Varchar2 := 'HTML') is
        V_SQL    Varchar2(1000);
        V_CLOB   Clob;
        V_OK     Varchar2(10);
    begin
        V_SQL := 'select ' || P_COLUMN || ' from ' || P_TABLE || ' where SID = :P_SID';

        execute immediate V_SQL
                     into V_CLOB
                    using P_SID;

        V_OK := SERVE_CLOB(V_CLOB, null, null, nvl(P_ESCAPE_MODE, 'HTML'));

        if V_OK <> 'Y' then
            HTP.PRN('Error serving column ' || upper(P_COLUMN) || ' from table ' || upper(P_TABLE)
                    || ' for SID=' || P_SID);
        end if;
    -- CLEANUP_TEMP_CLOB(V_CLOB);
    exception
        when NO_DATA_FOUND then
            HTP.PRN(P_NDF_MSG);
            CLEANUP_TEMP_CLOB(V_CLOB);
        when OTHERS then
            HTP.PRN('Error fetching column ' || upper(P_COLUMN) || ' from table ' || upper(P_TABLE)
                    || ' for SID=' || P_SID || chr(10) || sqlerrm);
            CLEANUP_TEMP_CLOB(V_CLOB);
    end SERVE_DB_CLOB;

    -- Date Utilities
    function DATE_PRECISION(P_DATE in Date)
        return Varchar2 is
        V_RTN    Varchar2(100);
        V_MM     Varchar2(2);
        V_DD     Varchar2(2);
        V_TIME   Varchar2(6);
    begin
        V_MM := to_char(P_DATE, 'mm');
        V_DD := to_char(P_DATE, 'dd');
        V_TIME := to_char(P_DATE, 'hh24miss');

        case
            when V_TIME = '000000' then
                V_RTN := 'Day';
            when V_MM = '01' and V_DD = '01' and V_TIME = '000002' then
                V_RTN := 'Year';
            when V_DD = '01' and V_TIME = '000001' then
                V_RTN := 'Month';
            else
                V_RTN := 'Second';
        end case;

        return V_RTN;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Date_Precision: ' || sqlerrm);
            return null;
    end DATE_PRECISION;

    function DATE_FORMAT(P_FORMAT Varchar2)
        return Varchar2 is
        /*
        This function is to be used in conjuction with Date_Precision.  This will return
        a date format for I2MS if you give a format specified from Date_Precision.
        ex:  to_char(pDate, Date_Format(Date_Precision(pDate)))
        */
        V_RTN   Varchar2(100);
    begin
        case P_FORMAT
            when 'Day' then
                V_RTN := nvl(GET_CONFIG('CORE.DATE_FMT_DAY'), 'dd-Mon-yy');
            when 'Year' then
                V_RTN := nvl(GET_CONFIG('CORE.DATE_FMT_YEAR'), 'yyyy');
            when 'Month' then
                V_RTN := nvl(GET_CONFIG('CORE.DATE_FMT_MONTH'), 'Mon-yy');
            else
                V_RTN := nvl(GET_CONFIG('CORE.DATE_FMT_SECOND'), 'dd-Mon-yy hh24:mi:ss');
        end case;

        return V_RTN;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Date_Format: ' || sqlerrm);
            return nvl(GET_CONFIG('CORE.DATE_FMT_SECOND'), 'dd-Mon-yy hh24:mi:ss');
    end DATE_FORMAT;

    function FORMAT_DATE(P_DATE in Date, P_FORMAT in Varchar2 := null)
        return Varchar2 is
    begin
        return to_char(P_DATE, DATE_FORMAT(nvl(P_FORMAT, DATE_PRECISION(P_DATE))));
    end FORMAT_DATE;

    -- String Utilities
    procedure APPEND_INFO(
        P_ORIGINAL    in out nocopy   Varchar2,
        P_APPEND      in              Varchar2,
        P_SEPARATOR   in              Varchar2 := ', ') is
    begin
        if P_APPEND is not null then                                    -- we're gonna do something
            if P_ORIGINAL is not null then                                    -- need the separator
                P_ORIGINAL := P_ORIGINAL || P_SEPARATOR;
            end if;

            P_ORIGINAL := P_ORIGINAL || P_APPEND;
        end if;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Append_Info Error: ' || sqlerrm);
    -- by not re-raising the exception, the routine will complete
    -- without error, and pOriginal will be as full as it can be.
    end APPEND_INFO;

    --Mime type / file type Utilities
    function GET_MIME_ICON(P_MIME_TYPE in Varchar2, P_FILE_NAME in Varchar2)
        return Varchar2 is
        V_TEMP   Varchar2(500) := null;
        V_CHAR   Varchar2(1)   := '';
    begin
        for N in (select *
                    from T_CORE_MIME_IMAGE
                   where upper(MIME_OR_FILE_EXTENSION) = upper(P_MIME_TYPE))
        loop
            return '<img src="' || V( 'APP_IMAGES') || N.IMAGE || '" alt="'
                   || nvl(N.ALT_TEXT, 'UNKNOWN') || '">';
        end loop;

        --if get to this point then we have to parse and look for the file extension.
        if P_FILE_NAME is null then
            return null;
        end if;

        for N in (select *
                    from T_CORE_MIME_IMAGE
                   where upper(MIME_OR_FILE_EXTENSION) =
                                              upper(substr(P_FILE_NAME, instr(P_FILE_NAME, '.', -1))))
        loop
            return '<img src="' || V( 'APP_IMAGES') || N.IMAGE || '" alt="'
                   || nvl(N.ALT_TEXT, 'UNKNOWN') || '">';
        end loop;

        return '<img src="' || V( 'APP_IMAGES') || 'other.gif" alt="' || 'UNKNOWN' || '">';
    exception
        when OTHERS then
            return null;
    end GET_MIME_ICON;

    -- HTML Formatting/Sorting utilities
    function FORMAT_FOR_HTML_SORT(
        P_DATE     in   Date,
        P_FORMAT   in   Varchar2 := null,
        P_ALIGN    in   Varchar2 := 'left')
        return Varchar2 is
        V_FMT   Varchar2(200) := P_FORMAT;
    begin
        if V_FMT is null then
            V_FMT := CORE_UTIL.GET_CONFIG('CORE.HTML_SORT_DATE_FMT');
        end if;

        if V_FMT is null then
            V_FMT := CORE_UTIL.DATE_FORMAT(CORE_UTIL.DATE_PRECISION(P_DATE));
        end if;

        return '<!-- ' || to_char(P_DATE, 'yyyymmddhh24miss')
               || ' --><div width="100%" style="text-align: ' || nvl(P_ALIGN, 'left') || '">'
               || to_char(P_DATE, V_FMT) || '</div>';
    end FORMAT_FOR_HTML_SORT;

    function FORMAT_FOR_HTML_SORT(
        P_NUM      in   Number,
        P_FORMAT   in   Varchar2 := null,
        P_ALIGN    in   Varchar2 := 'right')
        return Varchar2 is
        V_FMT   Varchar2(200) := P_FORMAT;
    begin
        if V_FMT is null then
            if trunc(P_NUM) = P_NUM then
                V_FMT :=
                    nvl(CORE_UTIL.GET_CONFIG('CORE.HTML_SORT_INTEGER_FMT'),
                        'fm999g999g999g999g990');
            else
                V_FMT :=
                    nvl(CORE_UTIL.GET_CONFIG('CORE.HTML_SORT_FLOAT_FMT'),
                        'fm999g999g999g999g990d00');
            end if;
        end if;

        return '<!-- ' || to_char(P_NUM + 1000000000000000, '0000000000000000.00')
               || ' --><div width="100%" style="text-align: ' || nvl(P_ALIGN, 'right') || '">'
               || to_char(P_NUM, V_FMT) || '</div>';
    end FORMAT_FOR_HTML_SORT;

    -- Ticket processing routines.
    procedure CREATE_TICKET(P_HOLDER in Varchar2, P_DURATION in Number := -1) is
        V_TICKET   Varchar2(100);
    begin
        delete from T_CORE_TICKET
              where ISSUED_TO = upper(P_HOLDER);

        V_TICKET := sys_guid;

        insert into T_CORE_TICKET
                    (TICKET, ISSUED_TO, ISSUED_ON, DURATION)
             values (V_TICKET, upper(P_HOLDER), sysdate, P_DURATION);

    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Get_Ticket: ' || sqlerrm); 
    end CREATE_TICKET;

    procedure GET_TICKET(P_HOLDER in Varchar2, P_TICKET out Varchar2, P_DURATION in Number := -1) is
        V_TICKET   Varchar2(100);
    begin
        delete from T_CORE_TICKET
              where ISSUED_TO = upper(P_HOLDER);

        V_TICKET := sys_guid;

        insert into T_CORE_TICKET
                    (TICKET, ISSUED_TO, ISSUED_ON, DURATION)
             values (V_TICKET, upper(P_HOLDER), sysdate, P_DURATION);

        P_TICKET := V_TICKET;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Get_Ticket: ' || sqlerrm);
            P_TICKET := null;
    end GET_TICKET;

    function GET_TICKET_HOLDER(P_TICKET in Varchar2)
        return Varchar2 is
        V_HOLDER             Varchar2(100);
        V_ISSUE_TIME         Date;
        V_DEFAULT_DURATION   Number;
        V_DURATION           Number;
    begin
        --calculate the default ticket duration
        V_DEFAULT_DURATION := nvl(CORE_UTIL.GET_CONFIG('CORE.TICKET_LIFE'), 5);       -- in seconds

        --attempt to find this ticket in the ticket list
        begin
            select ISSUED_TO, DURATION, ISSUED_ON
              into V_HOLDER, V_DURATION, V_ISSUE_TIME
              from T_CORE_TICKET
             where TICKET = P_TICKET;
        exception
            when OTHERS then
                --ticket not found, so obviously not a valid ticket
                return null;
        end;

        -- if no duration specified, then use the default duration
        if V_DURATION <= 0 then
            V_DURATION := V_DEFAULT_DURATION;
        end if;

        --if the ticket is still valid, return the holder, otherwise,
        -- return null
        if V_ISSUE_TIME +(V_DURATION /(24 * 60 * 60)) > sysdate then
            return V_HOLDER;
        else
            return null;
        end if;

        return V_HOLDER;
    exception
        when OTHERS then
            CORE_LOGGER.LOG_IT(C_PIPE, 'Get_Ticket_Holder: ' || sqlerrm);
            return null;
    end GET_TICKET_HOLDER;

    procedure RESET_TICKET_TIME(P_TICKET in Varchar2) is
    begin
        --if this ticket is still valid, reset it's issue time to the current time
        if GET_TICKET_HOLDER(P_TICKET) is not null then
            update T_CORE_TICKET
               set ISSUED_ON = sysdate
             where TICKET = P_TICKET;
        end if;
    end;

    -- Email routines.
    function EMAIL_SEND(
        P_RECIPIENT   in   Varchar2,
        P_SUBJECT     in   Varchar2,
        P_MSG         in   Varchar2,
        P_SENDER      in   Varchar2 := null,
        P_SEND_HOST   in   Varchar2 := null,
        P_MAIL_HOST   in   Varchar2 := null,
        P_MAIL_PORT   in   Number := null)
        return Varchar2 is
        V_MAIL_CONN        UTL_SMTP.CONNECTION;
        V_REPLY            UTL_SMTP.REPLY;
        V_MAIL_HOST        Varchar2(200);
        V_MAIL_PORT        Number;
        V_SEND_HOST        Varchar2(200);
        V_SENDER           Varchar2(200);
        V_MSG              Varchar2(32000);
        V_RECIPIENT_LIST   Varchar2(2000);
        V_RECIPIENT        Varchar2(200);
        V_TAG              Varchar2(100);
        A_MAIL_ERROR       exception;
        V_ERROR            Varchar2(1000);

        procedure LOG_REPLY is
        begin
            CORE_LOGGER.LOG_IT(C_PIPE, 'Email_Send: ' || V_REPLY.CODE || ' ' || V_REPLY.TEXT);
            return;
        end LOG_REPLY;
    begin
        V_SENDER := nvl(P_SENDER, CORE_UTIL.GET_CONFIG('CORE.EMAIL_SENDER'));
        V_SEND_HOST := nvl(P_SEND_HOST, CORE_UTIL.GET_CONFIG('CORE.EMAIL_SEND_HOST'));
        V_MAIL_HOST := nvl(P_MAIL_HOST, CORE_UTIL.GET_CONFIG('CORE.EMAIL_MAIL_HOST'));
        V_MAIL_PORT := nvl(P_MAIL_PORT, CORE_UTIL.GET_CONFIG('CORE.EMAIL_MAIL_PORT'));
        V_TAG := 'open';
        V_REPLY := UTL_SMTP.OPEN_CONNECTION(V_MAIL_HOST, V_MAIL_PORT, V_MAIL_CONN);
        LOG_REPLY;

        if V_REPLY.CODE <> 220 then
            raise A_MAIL_ERROR;
        end if;

        V_TAG := 'helo';
        V_REPLY := UTL_SMTP.HELO(V_MAIL_CONN, V_SEND_HOST);
        LOG_REPLY;

        if V_REPLY.CODE <> 250 then
            raise A_MAIL_ERROR;
        end if;

        V_MSG :=
            'Subject:' || P_SUBJECT || UTL_TCP.CRLF || 'Content-TYPE: text/plain;' || 'From:I2G <'
            || V_SENDER || '>' || UTL_TCP.CRLF || 'To:' || P_RECIPIENT || UTL_TCP.CRLF
            || UTL_TCP.CRLF || P_MSG;
        V_TAG := 'mail';
        UTL_SMTP.MAIL(V_MAIL_CONN, V_SENDER);
        V_TAG := 'rcpt';
        V_RECIPIENT_LIST := '~' || replace(P_RECIPIENT, ',', '~') || '~';

        loop
            V_RECIPIENT := CORE_LIST.POP_LIST_ITEM(V_RECIPIENT_LIST);
            exit when V_RECIPIENT is null;
            UTL_SMTP.RCPT(V_MAIL_CONN, V_RECIPIENT);
            CORE_LOGGER.LOG_IT(C_PIPE, 'Email_Send: Added RCPT: ' || V_RECIPIENT);
        end loop;

        V_TAG := 'data';
        UTL_SMTP.data(V_MAIL_CONN, V_MSG);
        V_TAG := 'quit';
        UTL_SMTP.QUIT(V_MAIL_CONN);
        return 'OK';
    exception
        when A_MAIL_ERROR then
            --utl_smtp.quit(v_mail_conn);
            V_ERROR := 'ERROR: (' || V_TAG || '): ' || V_REPLY.TEXT;
            CORE_LOGGER.LOG_IT(C_PIPE, 'Email_Send: ' || V_ERROR);
            return V_ERROR;
        when OTHERS then
            --utl_smtp.quit(v_mail_conn);
            V_ERROR := 'ERROR: (' || V_TAG || '): ' || sqlerrm;
            CORE_LOGGER.LOG_IT(C_PIPE, 'Email_Send: ' || V_ERROR);
            CORE_LOGGER.LOG_IT(C_PIPE,
                               'Email_Send: (' || V_TAG || '): ' || 'Length: '
                               || to_char(length(V_MSG)));
            return V_ERROR;
    end EMAIL_SEND;

    function BUILD_CUSTOM_DML_BLOCKS(
        P_TAB_NAME       in   Varchar2,
        P_APP_ID         in   Number,
        P_PAGE_ID        in   Number,
        P_SID_FUNCTION   in   Varchar2 := null)
        return Varchar2 is
/*
    Creates anonymous blocks that can be used to create Apex processes.
*/
        V_RTN            Varchar2(32000);
        V_SEP            Varchar2(10)    := ',';
        V_RETURNING      Varchar2(200);
        V_SID_FUNCTION   Varchar2(200);
        V_SEL_LIST       Varchar2(10000);
        V_INTO_LIST      Varchar2(10000);
        V_INSCOL_LIST    Varchar2(10000);
        V_INSVAL_LIST    Varchar2(10000);
        V_UPDATE_LIST    Varchar2(10000);
        V_NEW_VAL        Varchar2(500);
        V_EXISTS         boolean;
        V_FORMAT_MASK    Varchar2(100);
        V_HAS_LOV        boolean;
        V_SAVES_STATE    boolean;

        procedure GET_ITEM_INFO(
            P_APP_ID        in       Number,
            P_PAGE_ID       in       Number,
            P_COLUMN        in       Varchar2,
            P_EXISTS        out      boolean,
            P_FORMAT_MASK   out      Varchar2,
            P_HAS_LOV       out      boolean,
            P_SAVES_STATE   out      boolean) is
        begin
            P_EXISTS := false;
            P_FORMAT_MASK := null;
            P_HAS_LOV := false;
            P_SAVES_STATE := true;

            for a in (select FORMAT_MASK, LOV_DEFINITION, DISPLAY_AS
                        from APEX_APPLICATION_PAGE_ITEMS
                       where APPLICATION_ID = P_APP_ID
                         and PAGE_ID = P_PAGE_ID
                         and ITEM_NAME = 'P' || P_PAGE_ID || '_' || P_COLUMN)
            loop
                P_EXISTS := true;
                P_FORMAT_MASK := a.FORMAT_MASK;

                if a.LOV_DEFINITION is not null then
                    P_HAS_LOV := true;
                end if;

                if instr(a.DISPLAY_AS, 'does not save state') > 0 then
                    P_SAVES_STATE := false;
                end if;
            end loop;

            return;
        end GET_ITEM_INFO;
    begin
        V_RTN :=
            '
begin   -- SELECT block (condition: when :P[PAGE]_NEED_FETCH is not null)
    select [SEL]
      into [INTO]
      from [TABLE] where sid = :P[PAGE]_SID;
end;

begin   -- block to clear NEED_FETCH (after fetch, condition: when :P[PAGE]_NEED_FETCH is not null)
    :P[PAGE]_NEED_FETCH := null;
end;

begin   -- INSERT block
    insert into [TABLE] ([INSCOL])
      values ([INSVAL]) [RETURNING];
    [SIDGET]
    :P[PAGE]_NEED_FETCH := ''Y'';
end;

begin   --- UPDATE block
    update [TABLE] set
        [UPDATE]
      where sid = :P[PAGE]_SID and modify_on = to_date(:P[PAGE]_CRC,''yyyymmddhh24miss'');
    if sql%rowcount <> 1 then
        raise_application_error(-20200, ''Row has been modified or deleted since fetch.'');
    end if;
    :P[PAGE]_NEED_FETCH := ''Y'';
end;

begin   -- DELETE block
    delete from [TABLE]
      where sid = :P[PAGE]_SID and modify_on = to_date(:P[PAGE]_CRC,''yyyymmddhh24miss'');
    if sql%rowcount <> 1 then
        raise_application_error(-20200, ''Row has been modified or deleted since fetch.'');
    end if;
end;
';

        for a in (select   COLUMN_NAME, DATA_TYPE
                      from USER_TAB_COLUMNS
                     where TABLE_NAME = upper(P_TAB_NAME)
                  order by COLUMN_ID)
        loop
            GET_ITEM_INFO(P_APP_ID,
                          P_PAGE_ID,
                          a.COLUMN_NAME,
                          V_EXISTS,
                          V_FORMAT_MASK,
                          V_HAS_LOV,
                          V_SAVES_STATE);

            if V_EXISTS then
                -- SELECT processing
                if V_FORMAT_MASK is not null then
                    CORE_UTIL.APPEND_INFO(V_SEL_LIST,
                                          'to_char(' || a.COLUMN_NAME || ',''' || V_FORMAT_MASK
                                          || ''')',
                                          V_SEP);
                else
                    CORE_UTIL.APPEND_INFO(V_SEL_LIST, a.COLUMN_NAME, V_SEP);
                end if;

                CORE_UTIL.APPEND_INFO(V_INTO_LIST, ':p[PAGE]_' || a.COLUMN_NAME, V_SEP);

                -- INSERT, UPDATE processing
                if    a.COLUMN_NAME in('SID', 'CREATE_BY', 'CREATE_ON', 'MODIFY_BY', 'MODIFY_ON')
                   or not V_SAVES_STATE then
                    null;
                -- don't update this column
                else
                    if a.DATA_TYPE = 'DATE' then
                        V_NEW_VAL :=
                            'to_date(:p[PAGE]_' || a.COLUMN_NAME || ','''
                            || nvl(V_FORMAT_MASK, '&FMT_TIMESTAMP.') || ''')';
                    elsif a.DATA_TYPE = 'NUMBER' then
                        V_NEW_VAL :=
                            'to_number(:p[PAGE]_' || a.COLUMN_NAME || ','''
                            || nvl(V_FORMAT_MASK, 'fm999999999999') || ''')';
                    elsif V_HAS_LOV then
                        V_NEW_VAL := 'core_util.fix_null(:p[PAGE]_' || a.COLUMN_NAME || ')';
                    else
                        V_NEW_VAL := ':p[PAGE]_' || a.COLUMN_NAME;
                    end if;

                    CORE_UTIL.APPEND_INFO(V_INSCOL_LIST, a.COLUMN_NAME);
                    CORE_UTIL.APPEND_INFO(V_INSVAL_LIST, V_NEW_VAL, V_SEP);
                    CORE_UTIL.APPEND_INFO(V_UPDATE_LIST, a.COLUMN_NAME || '=' || V_NEW_VAL, V_SEP);
                end if;
            end if;
        end loop;

        CORE_UTIL.APPEND_INFO(V_SEL_LIST, 'to_char(MODIFY_ON,''yyyymmddhh24miss'')', V_SEP);
        CORE_UTIL.APPEND_INFO(V_INTO_LIST, ':p[PAGE]_crc', V_SEP);

        if P_SID_FUNCTION is null then
            V_RETURNING := 'returning SID into :P[PAGE]_SID';
        else
            V_SID_FUNCTION := ':P[PAGE]_SID := ' || P_SID_FUNCTION || ';';
        end if;

        V_RTN := replace(V_RTN, '[SEL]', V_SEL_LIST);
        V_RTN := replace(V_RTN, '[INTO]', V_INTO_LIST);
        V_RTN := replace(V_RTN, '[INSCOL]', V_INSCOL_LIST);
        V_RTN := replace(V_RTN, '[INSVAL]', V_INSVAL_LIST);
        V_RTN := replace(V_RTN, '[UPDATE]', V_UPDATE_LIST);
        V_RTN := replace(V_RTN, '[TABLE]', upper(P_TAB_NAME));
        V_RTN := replace(V_RTN, '[RETURNING]', V_RETURNING);
        V_RTN := replace(V_RTN, '[SIDGET]', V_SID_FUNCTION);
        V_RTN := replace(V_RTN, '[PAGE]', P_PAGE_ID);
        return V_RTN;
    end BUILD_CUSTOM_DML_BLOCKS;
end CORE_UTIL;
/


GRANT EXECUTE ON  CORE_UTIL TO IOL;
